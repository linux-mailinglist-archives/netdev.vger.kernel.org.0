Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDB91CFA87
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgELQYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:24:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9996 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbgELQYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 12:24:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CGFuqw025440;
        Tue, 12 May 2020 09:23:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=1r6cd4S8RMtPNhd34CncojOuEsgGyyr3fSzoDBmCBaA=;
 b=dz9MjXR3RWwr+z+H4pj5Vv+ykwxVY+fYTYcevnqpDTMi1EWutaVXpiLO+7BKHOJiHDPR
 WWGcg91qticg6bS4b45MIGPZUP9MC+U6Wc3EpAckuNdB6PxAxc/I7bC8mMZ5TzXT2rKk
 /ek03Dkj7BJOEYWFfEednV8Fsv6g/Zs9KPKxcy4adam8ECPWVL5NfqbyFh9pVkfJFVsJ
 s/mOwKwPtYH4BkkpEyLOi4JeaSqBMOVPcykVfQv8ibj/cjcNC7MDnFSJHxMT/RO+B268
 nVEmtsTRBQfTt/Lj7UNPZVVHdahcMoiD6A9+uipoPN3R0PUCfUmge7u6fxDsUw7ZVs0n GA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqmts0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 09:23:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 May
 2020 09:23:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 May
 2020 09:23:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 May 2020 09:23:37 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 2853A3F703F;
        Tue, 12 May 2020 09:23:29 -0700 (PDT)
Subject: Re: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     <jeyu@kernel.org>, <akpm@linux-foundation.org>, <arnd@arndb.de>,
        <rostedt@goodmis.org>, <mingo@redhat.com>, <aquini@redhat.com>,
        <cai@lca.pw>, <dyoung@redhat.com>, <bhe@redhat.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <gpiccoli@canonical.com>, <pmladek@suse.com>, <tiwai@suse.de>,
        <schlad@suse.de>, <andriy.shevchenko@linux.intel.com>,
        <keescook@chromium.org>, <daniel.vetter@ffwll.ch>,
        <will@kernel.org>, <mchehab+samsung@kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
 <20200509164229.GJ11244@42.do-not-panic.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
Date:   Tue, 12 May 2020 19:23:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200509164229.GJ11244@42.do-not-panic.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> So I think its not a good place to insert this call.
>> Its hard to find exact good place to insert it in qed.
> 
> Is there a way to check if what happened was indeed a fw crash?

Our driver has two firmwares (slowpath and fastpath).
For slowpath firmware the way to understand it crashed is to observe command
response timeout. This is in qed_mcp.c, around "The MFW failed to respond to
command" traceout.

For fastpath this is tricky, think you may leave the above place as the only
place to invoke module_firmware_crashed()

> 
>> One more thing is that AFAIU taint flag gets permanent on kernel, but
> for
>> example our device can recover itself from some FW crashes, thus it'd be
>> transparent for user.
> 
> Similar things are *supposed* to recoverable with other device, however
> this can also sometimes lead to a situation where devices are not usable
> anymore, and require a full driver unload / load.
> 
>> Whats the logical purpose of module_firmware_crashed? Does it mean fatal
>> unrecoverable error on device?
> 
> Its just to annotate on the module and kernel that this has happened.
> 
> I take it you may agree that, firmware crashing *often* is not good
> design,
> and these issues should be reported to / fixed by vendors. In cases
> where driver bugs are reported it is good to see if a firmware crash has
> happened before, so that during analysis this is ruled out.

Probably, but still I see some misalignment here, in sense that taint is about
the kernel state, not about a hardware state indication.

devlink health could really be a much better candidate for such things.

Regards
  Igor
