Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD666A8256
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 13:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCBMfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 07:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBMfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 07:35:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CA824492;
        Thu,  2 Mar 2023 04:35:43 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o15so64499372edr.13;
        Thu, 02 Mar 2023 04:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ8LF7+zMiKZ+S5iJr62As+T9036Y3LSmDtjC77E6fw=;
        b=mlO7j+I91CiF9Odrd89eS5DsyvO9jnI534f7ySKGe/AxKKqBarZBPaTBWbozq5s54H
         mA1vty6oG43Dx0fphA5LwVjR9Fv/fyOrgQxcvhkk6fW9M/nuWhBQ3AoPkkJ84Pt/e3vF
         c1ZuCtHXtv3HGYtJ1eYDNhtWT6NPLQj+EaHuxbSkIcLghu6v6q5f4Ib1upxtOhrDePxc
         i38h733YifQd7ds7euuFkkjxrby70kxqWVgK8f1WH+U150460s1FJ0ffkHjMjKuDV9zC
         zlUJgMgeisDb9u+ZryN3n4oPpWClolLCnv45+uLXQxIAkRvAsJrmrtazD/vENtT4nT8p
         W3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ8LF7+zMiKZ+S5iJr62As+T9036Y3LSmDtjC77E6fw=;
        b=fXVP3FtcTWKfaczbXSw8sqtFuMN4GjyWv9AAuDsEJK92EsxvVbXkIQbgdbA/q/0GX5
         VbOMlVHWQGqGr5GxFqui6lqCviH1KSvX97492/1cixvagtF8eGeU/e1IOxZ/qzb8eyoF
         2Fhe1tAnDis0W3FHhbzz2EJ3vIJTFU94wXZ5aScOah/2mIt84bVnSSEQ5F0L5PV82kTx
         vv5i6i2c9sRR9me1vyTK30VLwcTKhYawWMb8DuR6GrrzLZg0F1LGaJiFjJslpSKi2oPf
         S1VANXMuadKAgbMM5vSl/xmzq0k1MTkuA0tXWHyFWYcHpY4dP0fvtUeQzguhzGuC54Xf
         ww/A==
X-Gm-Message-State: AO0yUKXen8yziWAOayiuv/OYYS8kx7vzzj62owcP92GYtsv2Kh+X6jbv
        KoFW6SqC/sTfSF9rW7iL+jg=
X-Google-Smtp-Source: AK7set8MXoP7Db7st9sGfnC5hTDR9aH7I/VoW6jkHJdXhamvjRsvuoLCTgBBjKl6GLv2MDwh/uhWGA==
X-Received: by 2002:a17:906:7687:b0:8f1:939b:9701 with SMTP id o7-20020a170906768700b008f1939b9701mr10351811ejm.66.1677760541584;
        Thu, 02 Mar 2023 04:35:41 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id eg22-20020a056402289600b004c2a2ae772asm143014edb.67.2023.03.02.04.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 04:35:41 -0800 (PST)
Date:   Thu, 2 Mar 2023 14:35:38 +0200
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
Message-ID: <20230302123538.nfet4k3im3bcj4uj@skbuf>
References: <cover.1677699407.git.daniel@makrotopia.org>
 <9a788bb6984c836e63a7ecbdadff11a723769c37.1677699407.git.daniel@makrotopia.org>
 <20230301233121.trnzgverxndxgunu@skbuf>
 <Y//n4R2QuWvySDbg@makrotopia.org>
 <20230302100022.vcw5kqpiy6jpmq3r@skbuf>
 <ZACPCHxbuD7deGTa@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZACPCHxbuD7deGTa@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 11:56:56AM +0000, Daniel Golle wrote:
> The issues affects PHYs (and potentially switch PHY ICs) connected via
> SGMII operating at 1.25Mbaud.
> 
> The only officially supported board affected by this is the BPi-R3 where
> it affects the SFP cages -- the on-board MT7531 switch which is also
> used on all other boards using these SoCs is connected with 2500Base-X.
> 
> The issue does **not** affect RGMII or GMII on the MT7623 SoC, but I
> don't have any way to try RGMII or GMII on more recent SoCs as I lack
> hardware making use of that to connect a PHY.

I don't believe that board vendors need to have their device tree
"officially supported" in Linux in order to claim that a bug affecting
them should be fixed on stable kernels. As long as the PHY interface
type is generally supported by the driver and is expected to work,
it should work with any board (the exception being if there are other
configuration steps specific to that board required).

In any case, a good commit message for a bug fix explains what is the
user impact of the bug being fixed, the configurations which are affected,
how it was noticed, an adequate Fixes: tag, and if necessary, why it is
being fixed the way it is. In other words, it must be able to respond to
normal questions that a reader might have when he/she stumbles upon it,
for various reasons (it introduces a regression, they are debugging an
issue and want to assess whether backporting this patch would help them,
etc). The reader might be in the not so close future, when you might not
be able to provide clarifications personally, so the commit message
should contain all that you know which is relevant to the topic.

Most of these clarifications were provided by you as replies to the
patch, but they should be present in the commit message instead.
