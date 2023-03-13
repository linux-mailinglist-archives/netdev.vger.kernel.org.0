Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5E06B8654
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCMXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCMXve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:51:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA088894;
        Mon, 13 Mar 2023 16:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E3C8B81673;
        Mon, 13 Mar 2023 23:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50790C433EF;
        Mon, 13 Mar 2023 23:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678751487;
        bh=4ba/LXqyFOYnPz1mlKuD3GEqjFZuQ2b9fp0nAZ/ueqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Syy5G1QewWWlZ9TK7ummt8gGsimvVOpxB46dZV+nbGl0ZBXIs5D6XBxc/oTSrtPds
         /f7hXPQEB/BKeAPNVg4BhKpX17YXyt4zg5v7Q0uLv3hfpJtAVldzJblH7P/Hkgg1IM
         HoQLM4cpXsvSfnlz53OEFG4xvWJ6Tf88IuPo/St6trdeCGG+kDBPrFneBSM0M5OND8
         870RhbaOzGLdtLX8cQq0rtHklpBk6abM7+1G/VlXUhUAC3jB+stpO/D0S5xqsE/Vx3
         EPxEojQLs+F12KA7iXywyE+B+TRjD338wp0r5iNe+GWR+AI1JtKaqRR22XVemKCBi1
         Er/97XRKJBERg==
Date:   Mon, 13 Mar 2023 16:51:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v13 00/16] net: ethernet: mtk_eth_soc: various
 enhancements
Message-ID: <20230313165125.4743e5c7@kernel.org>
In-Reply-To: <cover.1678357225.git.daniel@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 10:54:23 +0000 Daniel Golle wrote:
> This series brings a variety of fixes and enhancements for mtk_eth_soc,
> adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
> code between mtk_eth_soc and mt7530.
> Also prepare support for MT7988 which has been done while net-next was
> closed.

The netdev review queue is too long for me to comprehend, since the
discussion is still ongoing on v12 (even tho seemingly tangential) 
I'll drop this, please repost once conclusion is reached.
