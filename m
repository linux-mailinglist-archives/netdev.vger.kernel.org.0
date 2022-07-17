Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96B0577686
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiGQOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiGQOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:01:22 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435F814D2D;
        Sun, 17 Jul 2022 07:01:21 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id os14so16994757ejb.4;
        Sun, 17 Jul 2022 07:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0fCCgfS7ij43FjTWRN9mQV9zz2OmcIOkd0dxDKuPXYc=;
        b=MxmP4+rUL9U0QucF53UCwek/ue/9/8jkmTOLIBPPnaQw6RDoHwel3q0Z7YaI7q4gB7
         PG/053yVy7MYIoXFMWhlzceZ55vs5ZXWit/Qf5BZcbnE1zU6EXtX+3FCJa8hClcqU5vO
         hd2/bgNYRSEJwYIP+jTqNBm6ErKn2tvZCZGPVhCm1vtXYm4JVd4jkQgJvRqlw0bNz0fr
         xdxghc/fz0wDdpYVJ5hicXhzsP9uIkGHoBQgYpoMZqL+ac1m177jk5wnfYjo0uxDUC3f
         I5Mre4ZNmR7MgVQfntlpNKDgHD8kC/TLnfJ11VzV3svNrk0d1ELJfUJER25RTRJUzcg0
         3OGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0fCCgfS7ij43FjTWRN9mQV9zz2OmcIOkd0dxDKuPXYc=;
        b=dAI/LfoY3C4h/O8f6ELiE12FiYWzSz90mHPMx2Ocyej86VMmIb95RvX9ElUJ/CanKL
         JHlFPNyW1BEcZWtR/KBP/RxUq4iYu2JEZjYM1pKlQSN5xYaZxUdadN9z+u0Gt64RFlgZ
         8gxBH8A6JiCvOIHo+jA8wC2djbPfu2xkKKxqEgAFg/5SMli+4MZrW7AEytxlaoLAJypc
         xXxMD3JWC6DblPRMUWRdTNAShMoWZMGsMWIYoh/qc1rSkc0TzeFsjQOMkpMw/BO0dL9X
         9Y2jam81t+1r8ani1cV8FkRqh1WWbhchhTwlNzJmyKJlgN2BURgJ/Dp+t2Lj81TU9Xad
         KWVA==
X-Gm-Message-State: AJIora9rxj1buxRNhOuiPLSK3rj/AIlpxkiq4njjmGOIsOQ9xQdT6Zcp
        omwU4pnsDuhceImc3CrFH9o=
X-Google-Smtp-Source: AGRyM1s5acGdq+NIJcpc1876kB8xodCdwcPghxrgQuhyBQKisZyQYSD6BDPVJ5NWWfoJgf3THRBBRw==
X-Received: by 2002:a17:907:d22:b0:72b:9b4b:78a9 with SMTP id gn34-20020a1709070d2200b0072b9b4b78a9mr21626163ejc.626.1658066479793;
        Sun, 17 Jul 2022 07:01:19 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id b18-20020a1709063cb200b00722f069fd40sm4347357ejh.159.2022.07.17.07.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 07:01:16 -0700 (PDT)
Date:   Sun, 17 Jul 2022 17:01:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net: dsa: vitesse-vsc73xx: silent
 spi_device_id warnings
Message-ID: <20220717140114.pzouvrvfohp7hi3b@skbuf>
References: <20220717135831.2492844-1-o.rempel@pengutronix.de>
 <20220717135831.2492844-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717135831.2492844-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 03:58:31PM +0200, Oleksij Rempel wrote:
> Add spi_device_id entries to silent SPI warnings.
> 
> Fixes: 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT compatible")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Thanks!

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
