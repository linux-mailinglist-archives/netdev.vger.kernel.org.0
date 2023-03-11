Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E852F6B5F96
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjCKSOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCKSOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:14:39 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E11F6287A;
        Sat, 11 Mar 2023 10:14:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id da10so33347933edb.3;
        Sat, 11 Mar 2023 10:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z1fvfYknXX3s4BMvhdB9LJyWlF6Mhekj+R7eFWprXOE=;
        b=ZfJAcF7uPhRJSAXwcid6/B7qfuPr/5cWlyH703KEZViuUAK8uf9OnSkBjNxK0F5/br
         XCeoTPMn/AmpNYwlckwTGdkF+OFV2DvTBdwdtl/dbJj6vrPL7ZVqm9xO9aE7Z45s70Pc
         TukRa+naUdtVfpFSA6wzzwmqXOGSZqK6SJsfr+NEJpACgSY37KVV3c8dedN8PY7tXk2a
         PB0Kd8ZbH0+Yi8wB5fhEbvBSV7aw8SXL4Oll8ADCll1UgckSiFv9Qg7RbyzndBZthK3x
         lYdGJqL1gq4DGvfWeJWoLQ/+SL13T6cjep6emnU+B4P2dOsFLJVKeAdee4nlsqj4Ozth
         RYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z1fvfYknXX3s4BMvhdB9LJyWlF6Mhekj+R7eFWprXOE=;
        b=F/5ybCybR2PVGbf43Lfc3kEkwkm4A/bfaxzAVxHbnW4hdBb39f1jlk4frkB5ltRfJF
         vNpC4nyhzhpETwvZfsEhzeQUthPCNi5Epf2P0AcM/7sW98HCMvs3C7rO2HpvQLqfuhsW
         Og3t8wCDmjPGEKEB1SLi4etKHrM2OKI/9CmFezOpO4sbqKkl8mXauiJA6wp1isQy4hmy
         woVc871KHuyTzg3Bf4ZFOvg+zPMBcH8Gm+LYRnwl+ig+4RlJT9TWrnuszMpTz+3g7z4W
         i5tqGKzpmkVbkKM1IYNsL8OV92M8R1KS7YGMfPjlZJWuhukiCE4/IiQNupYPGcyXGQnH
         1vQA==
X-Gm-Message-State: AO0yUKXURT7qJgWGiqtRc63WCzVyIRN1OXIyKx+cLPGJYiUqpJYuyRFB
        MChVBKQKdRrKCnig1yohU4Y=
X-Google-Smtp-Source: AK7set8ClX79YIet7szK6WARyHNYMAjqItBvSIAUu8NA8wuQkIeFJ591KGFOSJFGJFNIBAbX2sQp4g==
X-Received: by 2002:a17:906:fe43:b0:88f:9c29:d232 with SMTP id wz3-20020a170906fe4300b0088f9c29d232mr39454144ejb.57.1678558476965;
        Sat, 11 Mar 2023 10:14:36 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m15-20020a17090607cf00b00914fec9f40esm1338874ejc.71.2023.03.11.10.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 10:14:36 -0800 (PST)
Date:   Sat, 11 Mar 2023 20:14:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as
 maybe unused
Message-ID: <20230311181434.lycxr5h2f6xcmwdj@skbuf>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 06:32:52PM +0100, Krzysztof Kozlowski wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/net/dsa/lantiq_gswip.c:1888:34: error: ‘xway_gphy_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---

Do you happen to have any context as to why of_match_node() without
CONFIG_OF is implemented as:

#define of_match_node(_matches, _node)	NULL

and not as:

static inline const struct of_device_id *
of_match_node(const struct of_device_id *matches,
	      const struct device_node *node)
{
	return NULL;
}

?

Generally, the static inline shim function model is nicer, because it
allows us to not scatter __maybe_unused all around.
