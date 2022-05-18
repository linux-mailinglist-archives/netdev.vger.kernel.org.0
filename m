Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2590B52B923
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiERLvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiERLvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:51:11 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DA06467;
        Wed, 18 May 2022 04:51:07 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ch13so3243832ejb.12;
        Wed, 18 May 2022 04:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVVRJWY3LkzCEn7edt9NNkxfoGmjpJZT2KNTYyeloog=;
        b=CjICLHLfzEsizEKMpfYtP4+FXeytqoBUiGcF8Vub9GBQ+59eXLfiF+tjH+FXhjsGKj
         8N/lrHELQWFsoe3ofAr/i5aX9YUsrHGwRKfHp00YSNONeCdNTzRwl59h1h1oQbLpyX/p
         qsRo9cB1qAAoLDMAK1nvRIRqF5oxukk2/HnfGZvevzardH6wOfuZqZv6Cm7uC1ZufS9A
         CDnkpF9fwIzLXOiUlnjxrTHk/RvlrbLdFRZpYOOUu+PBJLeLnehlWmhYfOLWsIti4afQ
         gfCtjQQOMEFlFEyqPssinRQvmQMbBMVIGAnJ1Kq5iOJnxLvGaDYaAuth8r1fVf5s2wwm
         538w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVVRJWY3LkzCEn7edt9NNkxfoGmjpJZT2KNTYyeloog=;
        b=M62DDiimlAwOxA7vSP9axB1TZ+t/pCt+LA+brb0BM9ZM1pHptcd0+dtt/nlKfAmslu
         PwKHUV/DwhGmVsXqsO8Yr/xrd4iTCm6GGXk1yp9UesU8RbNyKG2h0rxbi1HElY4OHvqC
         zrgU6l2I1rhN7y9vbHUpE/zK2Twkpp+ipL4c47zjVpdnel9nJq7PHYG0Tc+w/CXmfsG8
         5b1OSJQ4SZNVLKAqL3FYdIjJ1qDu3WePuGlk2R8hfVPfYfnAv9BidoYYS6tGgM9vr3ML
         pMRQwXgCvaaYueVh8Fl7y0p5FuDDvUKhgOWlcJ9QJrA8Jgz/IYiwdtT4wr/Xgw8t3AxG
         nncA==
X-Gm-Message-State: AOAM531BgH4j594GapNJLA4UCEzkOd11yOynpaxijGoIk/wKhlRLsyRK
        LOkD3/nGkKH9UKOp+a3j3xOyYP44ZGc=
X-Google-Smtp-Source: ABdhPJyMZcAKlF9TgxW4enniFw0Fk9br2XUT7LiwWSOS6Ct21rHMSM1o88ch9RjHRfbBXraJijyd5A==
X-Received: by 2002:a17:906:3c52:b0:6fe:8b16:5f92 with SMTP id i18-20020a1709063c5200b006fe8b165f92mr1896598ejg.423.1652874665894;
        Wed, 18 May 2022 04:51:05 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id hf15-20020a1709072c4f00b006f3ef214da4sm872517ejc.10.2022.05.18.04.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 04:51:05 -0700 (PDT)
Date:   Wed, 18 May 2022 14:51:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net-next 3/9] net: dsa: microchip: perform the
 compatibility check for dev probed
Message-ID: <20220518115103.nlssfqkrlisqcxx3@skbuf>
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
 <20220517094333.27225-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517094333.27225-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 03:13:27PM +0530, Arun Ramadoss wrote:
> This patch perform the compatibility check for the device after the chip
> detect is done. It is to prevent the mismatch between the device
> compatible specified in the device tree and actual device found during
> the detect. The ksz9477 device doesn't use any .data in the
> of_device_id. But the ksz8795_spi uses .data for assigning the regmap
> between 8830 family and 87xx family switch. Changed the regmap
> assignment based on the chip_id from the .data.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Other than hoping this doesn't cause regressions:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
