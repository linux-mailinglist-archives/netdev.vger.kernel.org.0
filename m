Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC630A010
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhBABiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:38:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8642 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBABiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 20:38:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60175b4f0002>; Sun, 31 Jan 2021 17:37:19 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 01:37:16 +0000
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
Date:   Mon, 1 Feb 2021 09:37:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210130144231.GA3329243@shredder.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612143439; bh=rPKRd3bs/t1KKnw0/2Exqew8ULcL0hhZp4tjHocwmkM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=pj6rNhX5glMPlgfCjS59+Um/ZThpXEHoQbIkx2wGMZXExkQU/46yIDRorAzbrm0fP
         ieLPEJ23eCTUbu1yvTAb6LQ6GgwQ/RhjuBmeyqhQzpYKxXbODI0AaJIQ5GOFDcUzZQ
         lfbtc8LWVZ7i2iXIjYizn+OrrMDpXqsBiR1RtiRrsjMF9VMN2NcteI+p5fgdcNnZ5z
         iVM1m084KsDAJYNlKoH/q/208QT2gJ2LCRtt+nLg8at1yw9XQGQrZWwxMD4YAqXyC5
         0T6EYiU8LaVSGKNNxMgSJfSgwjx1OOgZ4e+tKev5hKRmNu2mosm2O6dOwKGo9hS0/b
         gm/45/IRLMwqA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
>> On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
>>> Instead of discussing it several days, maybe it's better to review
>>> current patch, so that we can move forward :)
>> It took you 4 revisions to post a patch which builds cleanly and now
>> you want to hasten the review? My favorite kind of submission.
>>
>> The mlxsw core + spectrum drivers are 65 times the size of psample
>> on my system. Why is the dependency a problem?
> mlxsw has been using psample for ~4 years and I don't remember seeing a
> single complaint about the dependency. I don't understand why this patch
> is needed.
Please see Saeed's comment in previous email:

"

The issue is with distros who ship modules independently.. having a
hard dependency will make it impossible for basic mlx5_core.ko users to
load the driver when psample is not installed/loaded.

I prefer to have 0 dependency on external modules in a HW driver.
"

We are working on a tc sample offload feature for mlx5_core. The distros
are likely to request us to do this. So we address it before submitting
the driver changes.

Regards,
Chris

