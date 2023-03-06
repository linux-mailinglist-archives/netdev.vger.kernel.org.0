Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FF26ABF48
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCFMP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCFMP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:15:56 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45E520579;
        Mon,  6 Mar 2023 04:15:53 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g3so37728421eda.1;
        Mon, 06 Mar 2023 04:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678104952;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1g4AYGzxTWyuARpoPesNpg8EiVTXYK4wwkJzSL4nXXs=;
        b=bNBYn1TnRcdbUj1TqpxVf5w4INnvEjSqvJATHZL3viiCgAe5kp/1aYJV3tXUZ+I8YT
         0vCWGQuC16ynAcvcZnRa5hfRn/jz/QCFUY6K7Zrww2DOxPQLM9RLS3vqxXuG8Yc26yPz
         o2IVbERznLqdY8VE1LgEKZh+B5AfNg7DwIjDcTKTy1k9Or5yOIV3cCyZ9Dr6vQ993zDC
         CEZBUuUoHmV8iNhBwIuy9wsE5KyOBmLoNeECjwtbZQ1S03Of68bWqzXkOCIsZJBdYaHe
         JoZGH+txs9zp+P6QinTeqi9DThGgPfkNutBu2p20LjJsTtWbv0J12Z2H/1D48xXogVHp
         Buuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104952;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1g4AYGzxTWyuARpoPesNpg8EiVTXYK4wwkJzSL4nXXs=;
        b=ii+iQLNpl5fM09H1cyJDPB1T7L7EeT6aWQ06KmtGD9vA2BrS9CO6XTri2dyOgt4G2F
         Ry6gg6prR66X5IXpHjjWKryk0NA0vphv6dmxKZK0ULWlwTga3v2isIdQaPyUwR9BY6Sc
         1VFIDgsXBn5mm1tRfrSa0SyUhetCUjTIw9828IE1bU6h+Ut+tvOuwBQwDMM8ZqpaNrt2
         qciDSXGtAXaT6Hg0MNXylcNGieNnxdFbcCMH2/lvmSu4+CuqD/tGPhDpXOW0/gVyLlx4
         /0FmYPqRzIEcbqZmREVnUg/Dgb40/i27Dbby7L6LJovifxemOWAvssu98lEszsrC2Qqm
         BVsA==
X-Gm-Message-State: AO0yUKW5c+nqmPIjHAU9FIlne8I/YerxopT8foFJn2fxe7ddcXocvMWO
        hmjbDNiucn6BICscn01ctOM=
X-Google-Smtp-Source: AK7set83ncGukr5k9XtPEBkCv42ZvOmeZIY23CtKgfOVZ1N4PNDRl2X2UQy2myUkpOZpI/aknFckcQ==
X-Received: by 2002:a17:907:c689:b0:914:4164:658a with SMTP id ue9-20020a170907c68900b009144164658amr506482ejc.42.1678104952142;
        Mon, 06 Mar 2023 04:15:52 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o13-20020a1709062e8d00b008e22978b98bsm4525453eji.61.2023.03.06.04.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:15:51 -0800 (PST)
Date:   Mon, 6 Mar 2023 14:15:48 +0200
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        arinc9.unal@gmail.com, frank-w@public-files.de
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix RX data corruption
 issue
Message-ID: <20230306121548.k33fgu7adg44zruu@skbuf>
References: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
 <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
 <138da2735f92c8b6f8578ec2e5a794ee515b665f.1677937317.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 01:43:20PM +0000, Daniel Golle wrote:
> Fix data corruption issue with SerDes connected PHYs operating at 1.25
> Gbps speed where we could previously observe about 30% packet loss while
> the bad packet counter was increasing.
> 
> As almost all boards with MediaTek MT7622 or MT7986 use either the MT7531
> switch IC operating at 3.125Gbps SerDes rate or single-port PHYs using
> rate-adaptation to 2500Base-X mode, this issue only got exposed now when
> we started trying to use SFP modules operating with 1.25 Gbps with the
> BananaPi R3 board.
> 
> The fix is to set bit 12 which disables the RX FIFO clear function when
> setting up MAC MCR, MediaTek SDK did the same change stating:
> "If without this patch, kernel might receive invalid packets that are
> corrupted by GMAC."[1]
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/d8a2975939a12686c4a95c40db21efdc3f821f63
> 
> Fixes: 42c03844e93d ("net-next: mediatek: add support for MediaTek MT7622 SoC")
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

I don't see something particularly controversial with this change.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
