Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A385ECBAF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiI0RyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiI0RyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:54:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3935FA7;
        Tue, 27 Sep 2022 10:53:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y8so14230988edc.10;
        Tue, 27 Sep 2022 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1Ypdl4TRQC+1OSWNoWtNsZeRHzU6ew8cFJ+YEjQfHTc=;
        b=KqO/zXxWkOwDPjKbXu8hyuaZYWxR9s9hv1at+3jJv5Y1FY6E0+h8Rgc0BE+pauKcdo
         KHXPYY5Co95VFHegGHFKyg6eiNfyncmORzdlLOM59YxHuYo71OEdMGc7Ksu/R5LhQoOZ
         0p9c3auRYjW/2g0W3Q6WUoij8rvt0NMtgGAlcR5plE0dZ81MJZF/Azy7wu8EPC6Irpjp
         XH/XHMPcsLmTqi/yWbjhr/zx0XFFBFjLbwJ66lmIyRI6cb6QtL2HavkWTR2OaXE9FhpL
         BZiTfbXVybauGSTo3aHFuTOTrl0rpWhC0oTQQhrdhrPhW+EZ8+S794xtfQZ0DlGDZf+3
         pYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1Ypdl4TRQC+1OSWNoWtNsZeRHzU6ew8cFJ+YEjQfHTc=;
        b=pW7VVKvcXKzj/WNEnVBSXe00pojx5BLdJ3WSXu1j0dLGhDJCFc0HT8VdHf1PzP2w2L
         Q5feWq4vsvffPoURHcj0hracjXklcjU2af0K+61VaQU0XV4EkTuiHwEtq3Lsx/ZKPBmB
         zEUxbpfrCBSLordqWRiVAszNvQeYKTxpgNJHpoW832hL1a2dlJMBA0whWYo37QZKL3/9
         Fq5wvAjzvCU0mMxiAztVMlyuy3Ck8+IcDUKImYcDwzdZOw44tKW0cUGCA0sGdWJEnPzY
         VU8H4rtihBIK2s1CzCG21mt3Z9F2Y72OQvVOnK5n1NkSFNcsQ1AVJQ40EO+OP8glN11q
         RGCg==
X-Gm-Message-State: ACrzQf1N5Mlp6Kr3e5ElOhWELtPOumNnyeyKAFErFtd29PmBzOucBMWh
        mtA48fO8nDz10PjLxRhm4c+s9YuSRBT12IMy
X-Google-Smtp-Source: AMsMyM4oYDuidVOOn0Lqag9BVv4J+Q7FYAuopwpG4GOuNpRt6Rih4mCc0JdTv2q9+6xTw0yPNXZZ+w==
X-Received: by 2002:a05:6402:1554:b0:457:375e:7289 with SMTP id p20-20020a056402155400b00457375e7289mr13151127edx.171.1664301237455;
        Tue, 27 Sep 2022 10:53:57 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id k22-20020a17090632d600b007030c97ae62sm1123767ejk.191.2022.09.27.10.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:53:56 -0700 (PDT)
Date:   Tue, 27 Sep 2022 20:53:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 08/14] net: dsa: felix: update init_regmap to
 be string-based
Message-ID: <20220927175353.mn5lpxopp2n2yegr@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926002928.2744638-9-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Sun, Sep 25, 2022 at 05:29:22PM -0700, Colin Foster wrote:
> During development, it was believed that a wrapper for ocelot_regmap_init()
> would be sufficient for the felix driver to work in non-mmio scenarios.
> This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
> add interface for custom regmaps")
> 
> As the external ocelot DSA driver grew closer to an acceptable state, it
> was realized that most of the parameters that were passed in from struct
> resource *res were useless and ignored. This is due to the fact that the
> external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).
> 
> Instead of simply ignoring those parameters, refactor the API to only
> require the name as an argument. MMIO scenarios this will reconstruct the
> struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
> scenarios need only call dev_get_regmap(dev, name).
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

I don't like how this turned out. I was expecting you not to look at the
exported resources from the ocelot-core anymore - that was kind of the
point of using just the names rather than the whole resource definitions.

I am also sorry for the mess that the felix driver currently is in, and
the fact that some things may have confused you. I will prepare a patch
set which offers an alternative to this, and send it for review.
