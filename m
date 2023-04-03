Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F86D5015
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjDCSN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjDCSN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:13:56 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28961BC1;
        Mon,  3 Apr 2023 11:13:54 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pjOgd-0001gS-2R;
        Mon, 03 Apr 2023 20:13:47 +0200
Date:   Mon, 3 Apr 2023 19:13:43 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
Message-ID: <ZCsXV7MkcUJldQbf@makrotopia.org>
References: <cover.1680483895.git.daniel@makrotopia.org>
 <53d89480-936d-25b1-6422-cda7769de369@arinc9.com>
 <ZCsQIylAgh-rxjfu@makrotopia.org>
 <73ce771f-3a13-b1c7-659d-7e1c236fdd0b@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73ce771f-3a13-b1c7-659d-7e1c236fdd0b@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 08:50:11PM +0300, Arınç ÜNAL wrote:
> On 3.04.2023 20:42, Daniel Golle wrote:
> > Hi Arınç,
> > 
> > On Mon, Apr 03, 2023 at 08:08:19PM +0300, Arınç ÜNAL wrote:
> > > On 3.04.2023 04:16, Daniel Golle wrote:
> > > > The MediaTek MT7988 SoC comes with a built-in switch very similar to
> > > > previous MT7530 and MT7531. However, the switch address space is mapped
> > > > into the SoCs memory space rather than being connected via MDIO.
> > > > Using MMIO simplifies register access and also removes the need for a bus
> > > > lock, and for that reason also makes interrupt handling more light-weight.
> > > > 
> > > > Note that this is different from previous SoCs like MT7621 and MT7623N
> > > > which also came with an integrated MT7530-like switch which yet had to be
> > > > accessed via MDIO.
> > > > 
> > > > Split-off the part of the driver registering an MDIO driver, then add
> > > > another module acting as MMIO/platform driver.
> > > > 
> > > > The whole series has been tested on various MediaTek boards:
> > > >    * MT7623A + MT7530 (BPi-R2)
> > > >    * MT7986A + MT7531 (BPi-R3)
> > > >    * MT7988A reference board
> > > 
> > > You did not address the incorrect information I pointed out here. Now that
> > 
> > I'm sorry, that was certainly not intentional and I may have missed
> > your comments. Actually it doesn't look like they have made it to the
> > netdev list archive or patchwork either.
> > 
> > > the patch series is applied, people reading this on the merge branch commit
> > > will be misled by the misinformation.
> > 
> > I've changed Kconfig stuff according to your recommendation and also
> > addressed possible misleading USXGMII and 10GBase-KR support by
> > introducing MT7988-specific functions and using 'internal' PHY mode.
> > So which of your comments have not been addressed?
> 
> https://lore.kernel.org/netdev/c11c86e4-5f8e-5b9b-1db5-e3861b2bade6@arinc9.com/

Strange that both emails didn't make it into patchwork.

> 
> > 
> > > 
> > > > 
> > > > Changes since v1:
> > > >    * use 'internal' PHY mode where appropriate
> > > >    * use regmap_update_bits in mt7530_rmw
> > > >    * improve dt-bindings
> > > 
> > > As a maintainer of the said dt-bindings, I pointed out almost 7 things for
> > > you to change. Of those 7 points, you only did one, a trivial grammar
> > > change. The patch series is applied now so one of us maintainers (you are
> > > one too now) need to fix it with additional patches.
> > 
> > I was also surprised the series made it to net-next so quickly, but it
> > wasn't me applying it, I merly posted v2 with all comments I received
> > addressed.
> > 
> > Me and supposedly also netdevbpf maintainers use patchwork to track
> > patches and whether comments have been addressed. Can you point me to
> > emails with the comments which haven't been addressed there? Looking in
> > patchwork for the dt-bindings patch [1] I don't see any comments there.
> 
> https://lore.kernel.org/netdev/a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com/
> 
> > 
> > 
> > Thank you for reviewing!
> > 
> > 
> > Daniel
> > 
> > 
> > [1]: See patchwork tracking for RFCv3, v1 and v2. Prior to RFCv3 the series
> > didn't have the dt-bindings addition, I introduced it with RFCv3 when splitting
> > the series into many small changes:
> > https://patchwork.kernel.org/project/netdevbpf/patch/9b504e3e88807bfb62022c0877451933d30abeb5.1680105013.git.daniel@makrotopia.org/
> > https://patchwork.kernel.org/project/netdevbpf/patch/fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org/
> > https://patchwork.kernel.org/project/netdevbpf/patch/dffacdb59aea462c9f7d4242cf9563a04cf79807.1680483896.git.daniel@makrotopia.org/
> 
> Although I've been a maintainer for the dt-bindings schema for quite some
> time, I was somehow missed as a recipient on RFC v3.

Yeah, that was my mistake. get_maintainers.pl comes up with unreadable
unicode garbage, probably something is wrong in my local Perl setup.
So I always manually replace your name with readable UTF-8, but I missed
that for RFC v3.
