Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82836985C5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBOUnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:43:22 -0500
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF2E2A6CB;
        Wed, 15 Feb 2023 12:43:21 -0800 (PST)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-16cc1e43244so164137fac.12;
        Wed, 15 Feb 2023 12:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bt0frRzR+llEQZaK/DO0XkpInRvQORs9L/8JhGVHFqc=;
        b=H0P5SrNgWQDhOhHB5wK9a26PoCTHS4iAa6UiJwk3qhuRC6uSWB8aR1D2WTGF1rHii4
         8nEhq98+HZwX/WkQmni1GMQAkLk/vV5ekk+KUqjp6k8hm8QFa+S6nHoOV9Tb+B7f+C4U
         S5mv0tm5HRdg4uX6ZJY/U+6RRDo42BSa7f9df2f0br4K11ULEj33imGP1s07o2oL4Har
         4UlU38a6qjxdOBvbYVoFYXWyG5ASgWfjJv+bMQp+jCfD/b01qfhlZ/0s1hodqnY+2NLj
         WdXMRnQif6YUn0eQ0kwzK7FX6fl8DDvwL6zJ32e+d91I4U7J26kJsAvNTwLwsKyVIA0J
         h/qg==
X-Gm-Message-State: AO0yUKWM5ng5MuEl5ZBqAdyAlNPUddH/b29ALdveKLDDPJI7jkeYV6c0
        9bwUw7Fdo0lhTtp4MQfiOQ==
X-Google-Smtp-Source: AK7set/50GBdop8VIc7s3EAxwGBGWbyNcA539gq34/FMTl1ZDlaTwOVNjvWSnEXsfwQb/NQwOO/gYw==
X-Received: by 2002:a05:6870:c0c6:b0:16d:f177:1a1a with SMTP id e6-20020a056870c0c600b0016df1771a1amr1659946oad.46.1676493800394;
        Wed, 15 Feb 2023 12:43:20 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p1-20020a056870a54100b0015f83e16a10sm7374482oal.44.2023.02.15.12.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:43:20 -0800 (PST)
Received: (nullmailer pid 521661 invoked by uid 1000);
        Wed, 15 Feb 2023 20:43:18 -0000
Date:   Wed, 15 Feb 2023 14:43:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     devicetree@vger.kernel.org,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v6 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert
 to DT schema
Message-ID: <20230215204318.GA517744-robh@kernel.org>
References: <cover.1676323692.git.daniel@makrotopia.org>
 <f4b378f4b19064df85d529973ed6c73ae7aa9f2d.1676323692.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4b378f4b19064df85d529973ed6c73ae7aa9f2d.1676323692.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:34:43PM +0000, Daniel Golle wrote:
> Convert mediatek,sgmiiisys bindings to DT schema format.
> Add maintainer Matthias Brugger, no maintainers were listed in the
> original documentation.
> As this node is also referenced by the Ethernet controller and used
> as SGMII PCS add this fact to the description.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../arm/mediatek/mediatek,sgmiisys.txt        | 27 ----------
>  .../arm/mediatek/mediatek,sgmiisys.yaml       | 49 +++++++++++++++++++
>  2 files changed, 49 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml

If you respin or as a follow-up, can you move this to bindings/clock/?

Reviewed-by: Rob Herring <robh@kernel.org>
