Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1A86B8659
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCMXxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCMXxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:53:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1A829412;
        Mon, 13 Mar 2023 16:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C66B8166E;
        Mon, 13 Mar 2023 23:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5FCC433EF;
        Mon, 13 Mar 2023 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678751626;
        bh=gSAvD8e0r3C0d1zGg6+R2BHZ7ljZS6nIV2sHt+LmnIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ancY9WMY/uv/1HxBZAT5oqADuUq9bshYi8NtqOgyyPxeCw3pxhYSzAxe8LvEIkhfU
         Z+tYK5oIvRwcvh31DwBIY4MFjmc0Xz45zqafxk3oiIM/SNGeT8r3Qs3SEWqky64NyK
         E8oShOIWbXoWozxraHxk7LKv6xsCucetzIoF7OsqWBSdeuNkacylYMI/ZDBZe3Swe/
         bZee4zWUZ5w2buRnfISTgcZoTpW7uDsK0IEely5YiWNt1ZziYtJZNgWrSzeVTD1Qxc
         /q6SF/czgyVFfGLOeS4YXXKOHI1kloxkO6u3Hmiallyo6aRG84CXGM3eBKjkb6BAP1
         kF/5bfJaOMOww==
Date:   Mon, 13 Mar 2023 16:53:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
Subject: Re: [PATCH net-next v13 16/16] net: ethernet: mtk_eth_soc: convert
 caps in mtk_soc_data struct to u64
Message-ID: <20230313165344.4db8f750@kernel.org>
In-Reply-To: <2d10d7a2de2a94f475c5134868580ddef4852c11.1678357225.git.daniel@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
        <2d10d7a2de2a94f475c5134868580ddef4852c11.1678357225.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 10:58:58 +0000 Daniel Golle wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> This is a preliminary patch to introduce support for MT7988 SoC.

When posting v14 please do us a favor and withhold this patch.

It looks like the series doesn't need it and the limit on patches 
in one series is 15.
