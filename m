Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77F30B4CC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBBBnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:43:19 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1243 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhBBBnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:43:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018ae0e0000>; Mon, 01 Feb 2021 17:42:38 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 01:42:35 +0000
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
References: <20210130023319.32560-1-cmi@nvidia.com>
 <20210129225918.0b621ed7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6ba2203c-919f-7baa-da7e-5c389187ef2a@nvidia.com>
 <20210201131051.4937f0ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <6cf86e79-f6ed-5736-2ead-456d4f296a19@nvidia.com>
Date:   Tue, 2 Feb 2021 09:42:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201131051.4937f0ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612230158; bh=Xv4JNXbrCz5P6Oz/dXRiUMLebiXPxlQ0SrcAQ2MKn60=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=bV1Pj9ptz1nSAdpNfjc5ji6Xv52128yq12zd+5XlDDIhmibZq7mfgnBbWIy/L7aGZ
         S8QZDssyURio3DdZeuOOsXflwyKcEu3oolY+rLlFYrbdyT5uB6+HWWpqI/YOSBw4xa
         68+/+Jx+AgDIfdLk4SvV1gwQMxmZ6KFUYDKr1hGVqI3aSBYKcO5UfD7eE2LDOpCj9T
         Skp05B9Dx6FWti/DmTa8Xwax0SpcjC1rPJy0FHWVZagy0xdZt5lbdp7Q+auMapJZqb
         gkTyVA2oo6GAckgm3bMNo412O4CAkbpuiqHvnMLo8Hdv71X3z0mAX1avbSAH430cRQ
         BeCZSYTz1Nf9w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/2021 5:10 AM, Jakub Kicinski wrote:
> On Mon, 1 Feb 2021 09:32:15 +0800 Chris Mi wrote:
>> On 1/30/2021 2:59 PM, Jakub Kicinski wrote:
>>> On Sat, 30 Jan 2021 10:33:19 +0800 Chris Mi wrote:
>>>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>>>> +/* Copyright (c) 2021 Mellanox Technologies. */
>>>> +
>>>> +const struct psample_ops __rcu *psample_ops __read_mostly;
>>>> +EXPORT_SYMBOL_GPL(psample_ops);
>>> Please explain to me how you could possibly have compile tested this
>>> and not caught that it doesn't build.
>> Sorry, I don't understand which issue you are talking about. Do you mean
>> the issue sparse found before or new issues in v5?
> There is no include here now, and it uses EXPORT_SYMBOL_GPL()
> and a bunch of decorators.
>
But there is no errors in 'checks' section of this page:
https://patchwork.kernel.org/project/netdevbpf/patch/20210128014543.521151-1-cmi@nvidia.com/

And I followed kernel test robot guide, I reproduced the errors in v1, 
but I fixed it in v2.

reproduce:

         wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
         chmod +x ~/bin/make.cross
         # apt-get install sparse
         # sparse version: v0.6.3-212-g56dbccf5-dirty
         #https://github.com/0day-ci/linux/commit/f2df98afc1a1f1809d9e8a178b2d4766cbca8bf7
         git remote add linux-reviewhttps://github.com/0day-ci/linux
         git fetch --no-tags linux-review Chris-Mi/net-psample-Introduce-stubs-to-remove-NIC-driver-dependency/20210127-082451
         git checkout f2df98afc1a1f1809d9e8a178b2d4766cbca8bf7
         # save the attached .config to linux build tree
         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=s390

I didn't see errors even if there is no include.

