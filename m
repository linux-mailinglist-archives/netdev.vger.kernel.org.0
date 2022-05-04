Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1746E51A3D3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346046AbiEDPZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352451AbiEDPYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:24:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6245529;
        Wed,  4 May 2022 08:21:07 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l18so3534087ejc.7;
        Wed, 04 May 2022 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LAHAvyI6ZnoSXv+X/gfsslQYBTBEo6ls5kRk7sRimNQ=;
        b=d2zLTEfxiFW8IHkGbm+yF8OyirFjLdhxSjhT022lHH3p4j3lqZegdJRmOF7k73ramv
         BMogGRR85t5Rl95au7I8Hes3qTx+i+viaO6tKgMdx4rG9HPoX5gKwW1oPK3d162VkOGo
         Mis72JEjdTrJMjrO/iTgIm/uQ6MrgEahwrVodKf9deWDreacy5g3h/GK9jtxofo0Q3OZ
         TlAM4Y4eoZs/iuLUkSRGzxIdXzsU0QS2V6t6H0495LmLh9lMOQfKEe/HTR4YC3+cQQk+
         Mw2OPi89yh5BJu8O3Zay0fyQJThboCs8+JiEGPG60JVHUYrhRcXNJ+EJFqrOLQbBGkr2
         rSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LAHAvyI6ZnoSXv+X/gfsslQYBTBEo6ls5kRk7sRimNQ=;
        b=BL+mj6jQWedHeJ7Vg+GsYnAeG2tjxS5TLKMXUqt4zsLryy/oIPooZ5lMqQMOYKPyjM
         f11z1FDwyfO28yAo5wV1f2wPpyJQmXWD9YZoQ4PxNLNhFXePjiozFxYMB9LnHL67HavB
         OYNnonyHA3GT/DqlATguB4odbFnn6GOVlSfgVi0dokaR5e+MScLR+/nl10rHXEbngmI1
         bQaDaVgtaO4+AKVcAYm41izz1u0IYo3YHW6iohrbJ5KTzaZu2lz6UAGph2fL7r97Mg0o
         sbKcr3kCStMnJU1NosBNuvyzWoLkJNvQou2fIvTguZ+Td295RhWkw2FILg2Q+RXSeGeq
         OmPQ==
X-Gm-Message-State: AOAM531GcYiAIWnsBAGtFeVMScpY9xuVd6QbvSBNvY1BpoanBsD09sIF
        nGtm9gXmw8rqow1km5Z6KIE=
X-Google-Smtp-Source: ABdhPJytXMsaNpSUTjcFGT9EV1QZ2w1xoQzIzDdeblj/sRBxFnmF0qT47s3Tb29DCb7pIUYkg6tCWw==
X-Received: by 2002:a17:907:7e91:b0:6f4:3b93:1f6e with SMTP id qb17-20020a1709077e9100b006f43b931f6emr16167776ejc.91.1651677665407;
        Wed, 04 May 2022 08:21:05 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id ca19-20020aa7cd73000000b0042617ba63c3sm9264323edb.77.2022.05.04.08.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:21:04 -0700 (PDT)
Date:   Wed, 4 May 2022 18:21:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 1/4] net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
Message-ID: <20220504152102.cj3fwae5anahthku@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-2-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430130347.15190-2-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 03:03:44PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Rework vlan_add/vlan_del functions in preparation for dynamic cpu port.
> 
> Currently BIT(MT7530_CPU_PORT) is added to new_members, even though
> mt7530_port_vlan_add() will be called on the CPU port too.
> 
> Let DSA core decide when to call port_vlan_add for the CPU port, rather
> than doing it implicitly.
> 
> We can do autonomous forwarding in a certain VLAN, but not add br0 to that
> VLAN and avoid flooding the CPU with those packets, if software knows it
> doesn't need to process them.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
