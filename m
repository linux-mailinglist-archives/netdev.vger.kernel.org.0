Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EB68E99D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBHIOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBHIOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:14:37 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2959A1259C;
        Wed,  8 Feb 2023 00:14:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675844041; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WeDIxqqukEHbNXOn/uBSj0kVXEhR97vE6zejJ+WfzvB1repQPM5ucfM8jCPyTWFhSeXTn9T0eIOx06N71IVqJmca2MLiHWcRKe01kgfX5we2MOXJOHpMYz0frdQPFcYEUTByCWm5nNMfDm2Fudy11OK76LUi2vfd0gac9leZy6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675844041; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Tq7GEayWsvRw96cMHfok6bYt1VMpZwPrUFgKIuPy65s=; 
        b=ne6IDCfXBMNPAPGv1UsKN6Q/gp5D0txK4aGFhr3G8UM23w6wABMPyW5kcVCG3V387ZZrp6BZT7KQe8Q1bBaOrs7VNoRTWSVnifYr4tZ011LegnhzngJ09p8s2DzyP8qKCm1QBwjEJ7BHDkQup5LBHwmevsyCWrYVEFZzb1t9gdI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675844041;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Tq7GEayWsvRw96cMHfok6bYt1VMpZwPrUFgKIuPy65s=;
        b=Cn+QHurTvKT5eFvMaxyl7rXMMSpuNNKSJpDnxZlHDLheoh/FT46dkphMeFBeYvG7
        2BNjxdNJbMvT5s1JfmybdQ2WpeEv0Z/5zhRA7oHSGHTra12049wVYx21snHKPMZxnSI
        9U5tlQ8i+vEXBKRhhAooTkFpA8b8gqIIvVWQ4GXU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1675844038914268.9156197429097; Wed, 8 Feb 2023 00:13:58 -0800 (PST)
Message-ID: <17958d10-80cb-b5a7-3a5b-97192de2266e@arinc9.com>
Date:   Wed, 8 Feb 2023 11:13:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when
 any MAC uses DSA
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     arinc9.unal@gmail.com, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com,
        Frank Wunderlich <frank-w@public-files.de>
References: <20230205175331.511332-1-arinc.unal@arinc9.com>
 <20230207105613.4f56b445@kernel.org>
 <5d025125-77e4-cbfb-8caa-b71dd4adfc40@arinc9.com>
 <52f8fc7f-9578-6873-61ae-b4bf85151c0f@arinc9.com>
 <20230207155801.3e6295b0@kernel.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230207155801.3e6295b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8.02.2023 02:58, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 23:25:32 +0300 Arınç ÜNAL wrote:
>>>> As Paolo pointed out to me off-list this is pretty much a revert of
>>>> commit under Fixes. Is this an actual regression fix, or second MAC
>>>> as DSA port never worked but now you found a way to make it work?
>>>
>>> Second MAC as DSA master after hardware DSA untagging was enabled never
>>> worked. I first disabled it to make the communication work again, then,
>>> with this patch, I found a way to make it work which is what should've
>>> been done with the commit for adding hardware DSA untagging support.
>>
>> Should both commits be mentioned with Fixes tag?
> 
> No strong preference, TBH.
> 
> The motivation for my question was to try to figure out how long we
> should wait with applying this patch. I applied the commit under Fixes
> without waiting for a test from Frank, which made me feel a bit guilty
> :)

Oh that's fine, they were going to test on the same hardware I've got 
anyway. You can apply this one whenever is convenient.

Arınç
