Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7256A7F7B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCBKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCBKBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:01:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9138457FB;
        Thu,  2 Mar 2023 02:00:53 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id a25so2807833edb.0;
        Thu, 02 Mar 2023 02:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tSEKXQWn54O1bcUyLcSiBooFO95lr1k3X3C2W2Migjs=;
        b=PKEfnraJ0Alp4pZNcheigWRJmahYGgvQZZeXjs9znoUqTHAuIKqbvPVYLDS3NI0Uxg
         17miis2AxLl7gJL7cBMEPQiz3F6Qy2oW9dmmbmAIq3EjdK2r8GoSpV553oczuktpW3EO
         PkoTbiG8qdONuQeSPe0Jl+XBpVVdOW7cia/qyi2wV4/YOIlstLOA78Prqjs31KCainjT
         QR0ryppzWVcQR9Ip6wPQQesRXh7n0wcaQdL3IEwZRj/rTUiwxRUPQQ/RmpA6Cg880Wgx
         6PvfD+jHaeGIrCOjEe9XJ1DNd+UGcNXSx6ZM45VhbpByT+6TPeUrt855RdHTuLSwyfCE
         oX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSEKXQWn54O1bcUyLcSiBooFO95lr1k3X3C2W2Migjs=;
        b=exvSLgxx1vTzWqWkRg8YOkJolSH9DK1hqjTbrl/Len18enDsxYHDhXYAFplzQlzlVp
         I32GrZMhNeMCYcygpcoyLSsUbFH5ohqm70p1jjVy1XuuZlIAqQfDeEANBsENVHheSowQ
         dFXy9F4Td6sEfst6TTYN/nxBSOGMUeUAqm2L0AZaeKYssLE1NTC3FXB0K0SqNEB45Rh/
         jAmEnWP6ffTDnAuYMQ6ILg61+BTB9t+AyTstzkme4a94LZLGJsfQJuvTk3XtHzMMIRhi
         J/Ouxkuxm7BJhk/gyhEyQd2V3tDapwR/7XtDJC4/rDzWs/fS0bNRSCel8cssFWm9Jun9
         YSFw==
X-Gm-Message-State: AO0yUKXTA9+FckOvGxSx1+KD5MCysAChL6K0ZRyC3z7kIWpzcoRQjJc9
        nXrvN+y1NLesNW2R/Pj/4t0=
X-Google-Smtp-Source: AK7set8cMBsQgSgzNy7n5UjRfNXJOKgJ96z0jDtPPJnBMG6MPTIk+Qj7xG+k75iN3bojtTFYfU1r2A==
X-Received: by 2002:a17:907:2cc4:b0:8a9:e031:c4b7 with SMTP id hg4-20020a1709072cc400b008a9e031c4b7mr11816825ejc.4.1677751225127;
        Thu, 02 Mar 2023 02:00:25 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w18-20020a1709061f1200b008c9b44b7851sm6881257ejj.182.2023.03.02.02.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 02:00:24 -0800 (PST)
Date:   Thu, 2 Mar 2023 12:00:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
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
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [RFC PATCH v11 08/12] net: ethernet: mtk_eth_soc: fix RX data
 corruption issue
Message-ID: <20230302100022.vcw5kqpiy6jpmq3r@skbuf>
References: <cover.1677699407.git.daniel@makrotopia.org>
 <9a788bb6984c836e63a7ecbdadff11a723769c37.1677699407.git.daniel@makrotopia.org>
 <20230301233121.trnzgverxndxgunu@skbuf>
 <Y//n4R2QuWvySDbg@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y//n4R2QuWvySDbg@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 12:03:45AM +0000, Daniel Golle wrote:
> On Thu, Mar 02, 2023 at 01:31:21AM +0200, Vladimir Oltean wrote:
> > On Wed, Mar 01, 2023 at 07:55:05PM +0000, Daniel Golle wrote:
> > > Also set bit 12 which disabled the RX FIDO clear function when setting up
> > > MAC MCR, as MediaTek SDK did the same change stating:
> > > "If without this patch, kernel might receive invalid packets that are
> > > corrupted by GMAC."[1]
> > > This fixes issues with <= 1G speed where we could previously observe
> > > about 30% packet loss while the bad packet counter was increasing.
> > > 
> > > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63
> > > Tested-by: Bjørn Mork <bjorn@mork.no>
> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > ---
> > 
> > Should this patch be submitted separately from the series, to the
> > net.git tree, to be backported to stable kernels?
> 
> Maybe yes, as this issue may affect e.g. the BPi-R3 board when used
> with 1G SFP modules. Previously this has just never been a problem as
> all practically all boards with MediaTek SoCs using SGMII also use the
> MediaTek MT7531 switch connecting in 2500Base-X mode.
> 
> Should the Fixes:-tag hence reference the commit adding support for the
> BPi-R3?

If it's not an issue that affects existing setups, there is no need to
backport the patch. But it needs to be clearly described as such in the
commit message.

You mention <= 1G speeds, but then only talk about 1G SFP modules.
I see that the mtk_eth_soc driver also sets "gmii" and "rgmii" in
phylink's supported_interfaces. Those are also <= 1G speeds. There could
also be SGMII on-board PHYs. Does the RX FIFO clearing issue not affect
those?
