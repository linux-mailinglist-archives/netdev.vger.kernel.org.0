Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E46D16C8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCaF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaF2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:28:43 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D505A11EAD;
        Thu, 30 Mar 2023 22:28:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680240471; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=L06KcmfBNR7A0LWsD9ZHLpL03rDdGFbcptnk4FioS1o3vRP68W8krzV9Y0I9NWuiIaR2GIh64mXKOHPiIQKfe/hzuAih4QE/mcXojbXOFoT2QavtCD4WmMsNxNzBvPuGh5Z2JQe1PW4V+Nd3vXz1inPJsl2IOE9qLRXMHewrQrk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680240471; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Lf3DvMAV/sNzJPuHjjqRoBkj47OvRM2awPuqcku5fzU=; 
        b=nQGHypyeNGi6aTq6tTqQ8nws5kYkWD67rV8B82ul4Mp7LlJzRsxVgj75lI/nCbKmmXhpvEBjA/WMuMv3xlA/e003WUkSJyZqqbqf5Y1FqQlniEB5f5oU8/QWAJ9/eOoYNOR9uarNKCETkwn9xV+DB4YPnaXoHrPCMaXIl6KLFFo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680240471;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Lf3DvMAV/sNzJPuHjjqRoBkj47OvRM2awPuqcku5fzU=;
        b=AViDsNjdJKXnzidguIx6dv+Nl7fObcxbOHw4MOtcU1pOSt+nnlmPKMIWPRCHvkkA
        15t35e6w+S8EiAaDaki6zRRA0Ckn+Fhip7p4dSQtpHGvl5ZmUEXuGYDkf1LiiRIDFPz
        g0wj2BnLutnaZLE+sTL5KoWI2ZETrZokfvI17R+k=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680240470694189.91428087746; Thu, 30 Mar 2023 22:27:50 -0700 (PDT)
Message-ID: <c11c86e4-5f8e-5b9b-1db5-e3861b2bade6@arinc9.com>
Date:   Fri, 31 Mar 2023 08:27:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 00/15] net: dsa: add support for MT7988
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <cover.1680180959.git.daniel@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <cover.1680180959.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2023 18:19, Daniel Golle wrote:
> The MediaTek MT7988 SoC comes with a built-in switch very similar to
> previous MT7530 and MT7531. However, the switch address space is mapped
> into the SoCs memory space rather than being connected via MDIO.
> Using MMIO simplifies register access and also removes the need for a bus
> lock, and for that reason also makes interrupt handling more light-weight.
> 
> Note that this is different from previous SoCs like MT7621 and MT7623N
> which also came with an integrated MT7530-like switch which yet had to be
> accessed via MDIO.

MT7623NI does not come with the MT7530 switch. MT7623AI does.

It's not an MT7530-like switch, it's the MT7530 switch, which is part of 
the multi-chip module, in a chip-stack package.

To be more specific, it's only the MT7621AT, MT7621DAT, and MT7621ST 
SoCs. MT7621NT SoC don't have it.

> 
> Split-off the part of the driver registering an MDIO driver, then add
> another module acting as MMIO/platform driver.
> 
> The whole series has been tested on various MediaTek boards:
>   * MT7623A + MT7530 (BPi-R2)

BPI-R2 has MT7623NI SoC, not MT7623AI. The MT7530 switch in this device 
is standalone.

Arınç
