Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B796EF002
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbjDZINu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbjDZINt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:13:49 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A153C31;
        Wed, 26 Apr 2023 01:13:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682496746; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=g2H/eTsheAIYkCOppxipJfD5P5trI7RfjlfLGFx7ZriFbsPQ5doZW6vCvbHCNkkTR0gpPH80WGrvAs1aEWSyrtX272EkYIUttpEhqIFX1sMXk7vbJPie8ZcCOoU7WBY/vT0bExpt9wc6Kya3eRiRdD4bSvVnsgNlkTMluC0vECI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682496746; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=scdniOaEMN93CnEzkg3P5onK/tzC0rz3np2V8rdqLqo=; 
        b=czijfwYx310rhCUDxDVJy2aiugbW42a/peCGYLIxLOcaA1HuMSUCB7SynmGOJg+0jRKda6T9kL5XpjrbuzsB1WQ3jr6KYgvGLxYFEUsNizPhZJw243Nnhdu4Sk8yxvCe4KpaKo/aS7vEPFXzO9NpYRBY5YWg9ZJrTHNm4R3hDO4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682496746;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=scdniOaEMN93CnEzkg3P5onK/tzC0rz3np2V8rdqLqo=;
        b=I0oPro1bUVwflc9HXRdxK81n8+PJ+A3j2HzFyrNaM0p4Yk0InSOZk7LmTp8zOC/+
        jaOqwPqZyhmB2GIpAoiz672nn5yh5P26Ipg8m4+U56mLCSqPx/9uXD0gfCNfIjEqVrJ
        FSCU7jBXWYO9xGrAqIn4PQ6EelDecH9C4BZD1Nu4=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682496745634552.1517854827307; Wed, 26 Apr 2023 01:12:25 -0700 (PDT)
Message-ID: <ce681fac-5f00-f0fc-b2cf-89907c50ee7c@arinc9.com>
Date:   Wed, 26 Apr 2023 11:12:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 04/24] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-5-arinc.unal@arinc9.com>
 <ZEfsCit0XX8zqUIJ@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZEfsCit0XX8zqUIJ@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.04.2023 18:04, Daniel Golle wrote:
> On Tue, Apr 25, 2023 at 11:29:13AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Introduce the p5_sgmii pointer to store the information for whether port 5
>> has got SGMII or not.
> 
> The p5_sgmii your are introducing to struct mt7530_priv is a boolean
> variable, and not a pointer.

I must've meant to say field.

> 
>>
>> Move the comment about MT7531AE and MT7531BE to mt7531_setup(), where the
>> switch is identified.
>>
>> Get rid of mt7531_dual_sgmii_supported() now that priv->p5_sgmii stores the
>> information. Address the code where mt7531_dual_sgmii_supported() is used.
>>
>> Get rid of mt7531_is_rgmii_port() which just prints the opposite of
>> priv->p5_sgmii.
>>
>> Remove P5_INTF_SEL_GMAC5_SGMII. The p5_interface_select enum is supposed to
>> represent the mode that port 5 is being used in, not the hardware
>> information of port 5. Set p5_intf_sel to P5_INTF_SEL_GMAC5 instead, if
>> port 5 is not dsa_is_unused_port().
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> Other than the comment above this change makes sense and looks good to
> me, so once you correct the commit message, you may add my Acked-by.

Will do, thanks.

Arınç
