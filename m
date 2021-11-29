Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDDC46150D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhK2MdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:33:03 -0500
Received: from sender4-op-o13.zoho.com ([136.143.188.13]:17352 "EHLO
        sender4-op-o13.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbhK2MbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:31:03 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1638188856; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=D0Ej5tOvijOp4iOLOADjrkCvTp8dQLj2Eh7ubWD052vbw9+4QoG3iMUbg99cS0SeC5Du5Xse9PcIqoaNsLJYroSa/eDpQXXne9pY+uxUODJikLh4zdeTeZB2L69sc4tD4FJopLWppIkj4GC6LKx0r63ASKULojV3spum3oyE0uE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1638188856; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Vku0fIHOP0jOIMCj01R2y1dll8gTGrk7iI4I3qjcb5I=; 
        b=mWGD+uRl/iP/DTR74wlWmHQuFmMqlipn4420yRXZ7gCkMj72145lIFgtgF3p4/vp43uBdLfq/nzgzwhc8Wa/rS0wluEfg3jSdc4sOr+rywa7yYmegYx8UsKLes2D0/7joFVQ2DGLHv3ELEka941W2plCiND6dUecAhVdVW0NSSs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1638188856;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=Vku0fIHOP0jOIMCj01R2y1dll8gTGrk7iI4I3qjcb5I=;
        b=Jx37vCVUjAzRxNtZGQMnbianFYSHee74G+JsulffPAkcwP1XI5VTaLYKJq/gOAFl
        wz4+aMT/NEBrcqhr4nFX8PEjPa73V76QYGcxxPJk+r2G/0WV5dUmLoY6t9vmRoNKwNA
        n3NuOWG/U90BGt77K9tiUVC+4lgnkJq+FKnXu6cg=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1638188854531804.3588742489017; Mon, 29 Nov 2021 04:27:34 -0800 (PST)
Message-ID: <42ec21b6-07c0-9724-35e2-b4cc2050265f@arinc9.com>
Date:   Mon, 29 Nov 2021 15:27:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps
 of 0.3 ns
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20211126125007.1319946-3-alvin@pqrs.dk>
 <8F46AA41-9B98-4EFA-AB2E-03990632D75C@arinc9.com>
 <46bd63ea-b153-e3ad-3cee-eb845e6b2709@bang-olufsen.dk>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <46bd63ea-b153-e3ad-3cee-eb845e6b2709@bang-olufsen.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Alvin.

On 26/11/2021 16:01, Alvin Šipraga wrote:
> Hi Arınç,
> On 11/26/21 13:57, Arınç ÜNAL wrote:
>>> On 26 Nov 2021, at 15:50, Alvin Šipraga <alvin@pqrs.dk> wrote:
>>>
>>> ﻿From: Alvin Šipraga <alsi@bang-olufsen.dk>
>>>
>>> A contact at Realtek has clarified what exactly the units of RGMII RX
>>> delay are. The answer is that the unit of RX delay is "about 0.3 ns".
>>> Take this into account when parsing rx-internal-delay-ps by
>>> approximating the closest step value. Delays of more than 2.1 ns are
>>> rejected.
>>>
>>> This obviously contradicts the previous assumption in the driver that a
>>> step value of 4 was "about 2 ns", but Realtek also points out that it is
>>> easy to find more than one RX delay step value which makes RGMII work.
>>>
>>> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
>>> Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
>>> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
>>
>> Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> I know you submitted a device tree using this driver with
> rx-internal-delay-ps = <2000>. Would you care to test your device tree
> with this patch and see if it needs updating? Before this patch, the
> driver would configure a step value of 4. After this patch it will
> configure a step value of 7.
> 
> If you experience problems then we will have to update the device tree
> again, assuming this patch is accepted.
I just tested the driver with this patch on 5.15. The switch seems to 
receive/transmit frames through the cpu port with rx-internal-delay-ps = 
<2000> fine.

Should we update the device tree to use 2100 ps for rx-internal-delay-ps 
anyway?

Arınç
