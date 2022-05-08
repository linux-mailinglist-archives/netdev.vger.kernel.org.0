Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C4B51ECB1
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiEHJxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiEHJpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:45:53 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B93DFBA;
        Sun,  8 May 2022 02:42:02 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1nndQD-0008Ms-Hg; Sun, 08 May 2022 11:41:49 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     linux-rockchip@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
Date:   Sun, 08 May 2022 11:41:48 +0200
Message-ID: <2509116.Lt9SDvczpP@phil>
In-Reply-To: <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de>
References: <20220507170440.64005-1-linux@fw-web.de> <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org> <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, 8. Mai 2022, 08:24:37 CEST schrieb Frank Wunderlich:
> Am 7. Mai 2022 22:01:22 MESZ schrieb Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>:
> >On 07/05/2022 19:04, Frank Wunderlich wrote:
> >> From: Frank Wunderlich <frank-w@public-files.de>
> >> 
> >> Make reset optional as driver already supports it, 
> >
> >I do not see the connection between hardware needing or not needing a
> >reset GPIO and a driver supporting it or not... What does it mean?
> 
> My board has a shared gpio-reset between gmac and switch, so both will resetted if it is asserted. Currently it is set to the gmac and is aquired exclusive. Adding it to switch results in 2 problems:
> 
> - due to exclusive and already mapped to gmac, switch driver exits as it cannot get the reset-gpio again.
> - if i drop the reset from gmac and add to switch, it resets the gmac and this takes too long for switch to get up. Of course i can increase the wait time after reset,but dropping reset here was the easier way.
> 
> Using reset only on gmac side brings the switch up.

I think the issue is more for the description itself.

Devicetree is only meant to describe the hardware and does in general don't
care how any firmware (Linux-kernel, *BSD, etc) handles it. So going with
"the kernel does it this way" is not a valid reason for a binding change ;-) .

Instead in general want to reason that there are boards without this reset
facility and thus make it optional for those.

Heiko

> >> allow port 5 as
> >> cpu-port 
> >
> >How do you allow it here?
> 
> Argh, seems i accidentally removed this part and have not recognized while checking :(
> 
> It should only change description of reg for ports to:
> 
> "Port address described must be 5 or 6 for CPU port and from 0 to 5 for user ports."
> 
> regards Frank
> 




