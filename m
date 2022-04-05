Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E404F3EA8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344831AbiDEUBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572907AbiDERS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:18:27 -0400
Received: from sender4-op-o18.zoho.com (sender4-op-o18.zoho.com [136.143.188.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C3925DA;
        Tue,  5 Apr 2022 10:16:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649178945; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VY+0yKVKo/OVl+of7lhiC+NmERw/mO0QIL7d/4Zt2BK2DvDHJe7p+FYSZU3ej7pPRyCuFkYQodsZwHnCI9+bDNxwX6ymxq8d2/QH2AiqgeWo721jljL1AS/mnCSF93Ovl7njzvvGJE/8nPx2+CC5dv5YPbayD+LBEOc4kDhEH7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1649178945; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IGWowlI8r+WgRZZc7My5D0pUljhMLj42f7CltFmHSBg=; 
        b=IdFBMiNpx3O18xSKZrid62+fV4c3LjwQ0U5dbZNvNfinfrS7/JVi5247bRbVOWBFRMEJiwUeCx6wk3pzHbgYwYkhdYAco8Bl+gggK3j9lZ90igApJOd55kFN68d/l64iucbBTvPDLVxNw/1oB/WW11qtZRNczpsySkwuvQczSNQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1649178945;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=IGWowlI8r+WgRZZc7My5D0pUljhMLj42f7CltFmHSBg=;
        b=MMUud1Fbn3lFWPmI1IjLMb9yr4uoLp/IjkTbnW4xngwQb5ukVWKyYDRd7ForX3lU
        eqqJTnUHQSunNNAPWg/AhRaRNXIuO13j9Kn+KjJHPo0ShvP3vajIfrUphFmiIEMh6Hz
        hGrk6GwnArH72BXcmPELd+uzA/l0c3659orphwOI=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1649178943002319.0872332652002; Tue, 5 Apr 2022 10:15:43 -0700 (PDT)
Message-ID: <991f49fd-354b-6d07-6925-f79ca7f09838@arinc9.com>
Date:   Tue, 5 Apr 2022 20:15:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: add label support for GMACs
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20220404114000.3549-1-arinc.unal@arinc9.com>
 <Ykri9tOtUDmXzHkG@lunn.ch>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Ykri9tOtUDmXzHkG@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/2022 15:22, Andrew Lunn wrote:
> On Mon, Apr 04, 2022 at 02:40:00PM +0300, Arınç ÜNAL wrote:
>> From: René van Dorst <opensource@vdorst.com>
>>
>> Add label support for GMACs. The network interface of the GMAC will have
>> the string of the label property defined on the devicetree as its name.
> 
> Sorry, but no. This has been discussed a few times, you need something
> in user space, udev or systemd etc to set interface names.
> 
> Please look back in the archive at previous discussions.

Thanks for the heads up Andrew, I found your quote from 
https://lore.kernel.org/all/Ydhwfa%2FECqTE3rLx@lunn.ch/:

> I agree with Russell here. I doubt this is going to be accepted.
> 
> DSA is special because DSA is very old, much older than DT, and maybe
> older than udev. The old DSA platform drivers had a mechanism to
> supply the interface name to the DSA core. When we added a DT binding
> to DSA we kept that mechanism, since that mechanism had been used for
> a long time.
> 
> Even if you could show there was a generic old mechanism, from before
> the days of DT, that allowed interface names to be set from platform
> drivers, i doubt it would be accepted because there is no continuity,
> which DSA has.

On MT7621 SoC, we can mux a switch phy of MT7530 (must be phy0 or 4) to 
the SoC's gmac1. So a UTP port connected to that phy becomes directly 
connected to the SoC's gmac1. Because of that, I wanted to be able to 
give the gmac's netdev interface a name from DT like DSA. However, the 
quote above makes sense why not to do so.

Thanks.
Arınç
