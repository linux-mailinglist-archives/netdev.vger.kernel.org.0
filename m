Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1960D132D1D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgAGRdx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jan 2020 12:33:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:12616 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgAGRdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 12:33:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 09:33:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="303281897"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2020 09:33:37 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jan 2020 09:33:37 -0800
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.124]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.244]) with mapi id 14.03.0439.000;
 Tue, 7 Jan 2020 09:33:37 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "valex@mellanox.com" <valex@mellanox.com>
Subject: Re: [question] About triggering a region snapshot through the
 devlink cmd
Thread-Topic: Re: [question] About triggering a region snapshot through the
 devlink cmd
Thread-Index: AdXFf5eE+crGCZM3TJSp+ItqQuX7Bg==
Date:   Tue, 7 Jan 2020 17:33:36 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B26FA36F@fmsmsx101.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/27 16:13, Jiri Pirko wrote:
> Fri, Sep 27, 2019 at 09:40:47AM CEST, linyunsheng@huawei.com wrote:
>> Hi, Jiri & Alex
>>
>>    It seems that a region' snapshot is only created through the
>> driver when some error is detected, for example:
>> mlx4_crdump_collect_fw_health() -> devlink_region_snapshot_create()
>>
>>    We want to trigger a region' snapshot creation through devlink
>> cmd, maybe by adding the "devlink region triger", because we want
>> to check some hardware register/state when the driver or the hardware
>> does not detect the error sometimes.
>>
>> Does about "devlink region triger" make sense?
>>
>> If yes, is there plan to implement it? or any suggestion to implement
>> it?
> 
> Actually, the plan is co convert mlx4 to "devlink health" api. Mlx5
> already uses that.
> 
> You should look into "devlink health".

Hi Jiri,

I agree, the mlx4 firmware dump stuff should use the devlink health API, as it's for error conditions.

I've recently been investigating using devlink regions to expose non-error regions where it really does make sense to "trigger" a snapshot.

The original region commit message indicates that there were plans to support requesting snapshots, and even potentially writing to the region directly.

I wanted to use a region to expose some set of flash/NVM contents. Being able to request a snapshot is essential in this case. I saw that netdevsim does this through a debugfs hook, but that really doesn't make sense to me for a production driver.

It makes sense to me to be able to trigger a region snapshot directly through devlink. Should I spin up some patches to implement it?

Thanks,
Jake
