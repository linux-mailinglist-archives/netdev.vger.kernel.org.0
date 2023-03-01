Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E86A77A8
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCAXba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 18:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCAXb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 18:31:29 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9804ECED;
        Wed,  1 Mar 2023 15:31:26 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ck15so60948381edb.0;
        Wed, 01 Mar 2023 15:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6jUS8n9lg5ijWAj5qDIi6FkkKAFasoVfY7e8vEy7IvM=;
        b=hXAjuASpDVoBDvFrgpEoN083JPnbLaB4WI691Y3TSgEEnIu0PjGAIEAtrxUiZASk1L
         y/u6VO+M1qFmDfIqfynfrfE3fomHbQvl3tj7SU+Iigh8XcfpjwaTs4r87GANIdrjJgkq
         pvEF7JjXOf7UF0Qf1y3tpwnGVbuzA9PZgwdpKGYLpQEdBXsxpzEYW9OfXJ9Q8ycYJq7T
         dsGlXpC/9qIIZTlcVZXTF0smydK9iumjYU0x+RBIfNXWylR85kAKVX95uUM6r7zgmw2O
         jCKb/Dy8eednFUON2e9Yf64eKRUZTxzWCbicdw9EFU3jb+qgGQqH+4DVBUwU7WDtIM8h
         sPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jUS8n9lg5ijWAj5qDIi6FkkKAFasoVfY7e8vEy7IvM=;
        b=d/2BPC/lBvTKhbCiQmWXWieey4FRJP9S5/pTniOhPVkFiWSsQLoDw5nnqxzyCspYhV
         s7CSyG6YAC6RCm5WC1Ge7VPldsWQvzIXZiJzIZICgyujybiXs20BR+LbMyLBZ34N1aIu
         g1aYgmM99YgcVWJA8BnbqNNJhQv1WkByRwZTVM0T37lcElVFbRxRRoRt5kBn5I53qiUM
         qJ/ZcePko4jAvFjSw8GW0Bq2VGoOltvaNf+v5Oe7e8srw6cVeiquzWJS7Exwa4r+7Iv4
         e7mNtKfi2e5OeZDJF21NJS9GsUpk3lbMq/Wy5i7IIyQnySUyLZaR24rmsQrRFNlYyjol
         Nc7A==
X-Gm-Message-State: AO0yUKU8ju6axFaqOP75MWiHXVHJFffn9F4QDwF9Ixe8cRcUSH6mFWWC
        lsufb8hKXFGRP07OON/ppN0+BctEcsR4uw==
X-Google-Smtp-Source: AK7set8z969kk793FiYkFoh/JWXyInKIiqDlZJN6AjuWjFSfkF8Dh7s6GEJ5JmlwgkyLWXS3JMuBEQ==
X-Received: by 2002:a17:907:6093:b0:8b2:d30:e722 with SMTP id ht19-20020a170907609300b008b20d30e722mr12240050ejc.3.1677713484433;
        Wed, 01 Mar 2023 15:31:24 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id fi5-20020a170906da0500b008e17dc10decsm6343841ejb.52.2023.03.01.15.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 15:31:24 -0800 (PST)
Date:   Thu, 2 Mar 2023 01:31:21 +0200
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
Message-ID: <20230301233121.trnzgverxndxgunu@skbuf>
References: <cover.1677699407.git.daniel@makrotopia.org>
 <9a788bb6984c836e63a7ecbdadff11a723769c37.1677699407.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a788bb6984c836e63a7ecbdadff11a723769c37.1677699407.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 07:55:05PM +0000, Daniel Golle wrote:
> Also set bit 12 which disabled the RX FIDO clear function when setting up
> MAC MCR, as MediaTek SDK did the same change stating:
> "If without this patch, kernel might receive invalid packets that are
> corrupted by GMAC."[1]
> This fixes issues with <= 1G speed where we could previously observe
> about 30% packet loss while the bad packet counter was increasing.
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

Should this patch be submitted separately from the series, to the
net.git tree, to be backported to stable kernels?
