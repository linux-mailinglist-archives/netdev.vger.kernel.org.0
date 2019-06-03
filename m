Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380A73352E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfFCQmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:42:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:53902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbfFCQmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 12:42:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3319AE79;
        Mon,  3 Jun 2019 16:42:13 +0000 (UTC)
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jocke@infinera.com" <joakim.tjernlund@infinera.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@suse.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <d086216f-f3fc-c88a-3891-81e84e8bdb01@suse.de>
 <VI1PR04MB5134BFA391D8FF013762882FEC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
 <19cc3230-33b0-e465-6317-590780b33efa@suse.de>
 <VI1PR04MB5134E4DA6EA052BEBB3C26EFEC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Linux GmbH
Message-ID: <c237dd17-ed43-d2d0-c76c-0c1dbf859690@suse.de>
Date:   Mon, 3 Jun 2019 18:42:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB5134E4DA6EA052BEBB3C26EFEC190@VI1PR04MB5134.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 31.05.19 um 19:32 schrieb Laurentiu Tudor:
>> -----Original Message-----
>> From: Andreas Färber <afaerber@suse.de>
>> Sent: Friday, May 31, 2019 8:04 PM
>>
>> Hello Laurentiu,
>>
>> Am 31.05.19 um 18:46 schrieb Laurentiu Tudor:
>>>> -----Original Message-----
>>>> From: Andreas Färber <afaerber@suse.de>
>>>> Sent: Friday, May 31, 2019 7:15 PM
>>>>
>>>> Hi Laurentiu,
>>>>
>>>> Am 30.05.19 um 16:19 schrieb laurentiu.tudor@nxp.com:
>>>>> This patch series contains several fixes in preparation for SMMU
>>>>> support on NXP LS1043A and LS1046A chips. Once these get picked up,
>>>>> I'll submit the actual SMMU enablement patches consisting in the
>>>>> required device tree changes.
>>>>
>>>> Have you thought through what will happen if this patch ordering is not
>>>> preserved? In particular, a user installing a future U-Boot update with
>>>> the DTB bits but booting a stable kernel without this patch series -
>>>> wouldn't that regress dpaa then for our customers?
>>>>
>>>
>>> These are fixes for issues that popped out after enabling SMMU.
>>> I do not expect them to break anything.
>>
>> That was not my question! You're missing my point: All your patches are
>> lacking a Fixes header in their commit message, for backporting them, to
>> avoid _your DT patches_ breaking the driver on stable branches!
> 
> It does appear that I'm missing your point. For sure, the DT updates solely will
> break the kernel without these fixes but I'm not sure I understand how this
> could happen.

In short, customers rarely run master branch. Kindly have your
colleagues explain stable branches to you in details.

With Fixes header I was referring to the syntax explained here:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

> My plan was to share the kernel dts patches sometime after this series
> makes it through.

That's fine. What I'm warning you is that seemingly your DT patches,
once in one of your LSDK U-Boot releases, will cause a regression for
distros like our SLES 15 SP1 unless these prereq kernel patches get
applied on the respective stable branches. Which will not happen
automatically unless you as patch author take the appropriate action
before they get merged.

Thanks,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
