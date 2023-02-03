Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9467689B72
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjBCOTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjBCOSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:18:46 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C7313504;
        Fri,  3 Feb 2023 06:18:45 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u21so5332466edv.3;
        Fri, 03 Feb 2023 06:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5QSL2KQ7I6Qbye6De1VwL36uZ19OhoWx467Nfxob8I=;
        b=oFKxvoCUuD0kdQrD8wLZOBSp4dHJc3BesofQGhdR7hhRNemcXWTuC9jlIJMSzYBv6J
         HWsVLvltQhLxb2O0lC8FYLFaeo7pyIwbRKuD1kaGN16r9MZtpHmd0/208Al5d8lgaehP
         SxTSa/gXboj+rMT6TaruMb4KyVGzEsJUU3gsAsCAhLnje1V8dMb5WDjsrieanlUJ+QnE
         fhimA7zv+xBh6GNsEu4+yeUz/94V0Uw2dAsEucDF//vkBtOWM36Y9NEwBd/KJ8cAqqYM
         /JMO04RD4Xz56hR45fxx6t+Mv9oW6qya25MeWIEpVcCq1h+xluL4//pKeBINs1uIow2l
         BNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5QSL2KQ7I6Qbye6De1VwL36uZ19OhoWx467Nfxob8I=;
        b=jURk4+QAe4nXzT9CtT6PpeQLXmTEVeWECLTSwv+aefKAoEBEw8fCgdTUeqhREcd+p8
         IePRXUZTwfK5nIGcnVl+iUTLWQlctE6jdJhTTJ0UNQLoNQaF3lY94QUY2rpjK7tXiWyw
         AwHxmwQvacCcq45T3nTjlywgl8hunY/GpdFWffOggJOMqBJ5gHvHesmQcq4sQFxTkVuL
         MErbIF/UejcpMGGyiNzEU8yFM4ybiLefUN1P5XnPgdEfT6TFG1kuGhCgLPQKhuQxJbhV
         gUdimmLd05xa/h877zD8Tba5NRYofCeb32w+4FWBF/UbdBn7Ab5BlwNKuPi3kKZOtGz7
         xlSQ==
X-Gm-Message-State: AO0yUKXSy7g/lnZpiY5hwdJ8hVAi/bxz5aJBiSNmBCD60gtlQAxKkfqM
        YgCgRNhYf17hRXPQeMc+oUo=
X-Google-Smtp-Source: AK7set/lqhJkKG1jhrlMZ7tsVU350vT6gguJgctsAvHm76Udi3CWQAiKtESaORNQaAbHnXKFxJ2QPQ==
X-Received: by 2002:a05:6402:124b:b0:49b:63ea:b5d8 with SMTP id l11-20020a056402124b00b0049b63eab5d8mr10962336edw.4.1675433923587;
        Fri, 03 Feb 2023 06:18:43 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id h23-20020a170906855700b00872a726783dsm1408158ejy.217.2023.02.03.06.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 06:18:43 -0800 (PST)
Date:   Fri, 3 Feb 2023 16:18:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
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
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 1/9] net: ethernet: mtk_eth_soc: add support for MT7981
 SoC
Message-ID: <20230203141840.chljzf3opxbxyp33@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
 <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
 <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:00:21AM +0000, Daniel Golle wrote:
> The MediaTek MT7981 SoC comes two 1G/2.5G SGMII, just like MT7986.
> 
> In addition MT7981 comes with a built-in 1000Base-T PHY which can be
> used with GMAC1.
> 
> As many MT7981 boards make use of swapping SGMII phase and neutral, add
> new device-tree attribute 'mediatek,pn_swap' to support them.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

Phase and neutral? What is this, a power plug?
Since SGMII uses differential signaling, I wonder if this isn't about
the polarity of the TX lane (which pin carries the Positive signal and
which the Negative one).

I think there is room for a more general device tree property name than
"mediatek,pn_swap". The Designware XPCS also supports this, see
DW_VR_MII_DIG_CTRL2_TX_POL_INV and the comments in
nxp_sja1105_sgmii_pma_config().
