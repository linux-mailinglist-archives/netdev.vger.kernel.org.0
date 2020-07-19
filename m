Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B11225213
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGSN7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 09:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGSN7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 09:59:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2108C0619D2;
        Sun, 19 Jul 2020 06:59:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m22so9045784pgv.9;
        Sun, 19 Jul 2020 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eAMuwrdgZT+muWB0jbfvOv3S8Lq4I5ca8nN0yy/ukz0=;
        b=gQUNuyKuer2aVg+6zju4B6jW7FIv2GqsAgJ+M8TgSIPMdHFHkBjH1FGBEOtK3hR6fR
         OA8w7cGg9AMlxtp1fign1fIN7Ez5zjqP+qpCVvCgvKnx4Vj7IgZzMUciGtTkX1jgOC+o
         +1ae8Dw7u7tKH7O3VuTB0hP5ZJt2zcppNmiBRQCr5C7BYTP7UskNINiPTL3EYF+a2S+d
         K0HVaUuftzhK4lyu/QwKa78yeAQ+IIgZiitzKNxJpc3GIWUteYIJ5dW4nOKTPAu5bDOL
         zMeGzYozRgLB851TiCD1HLvFFblkR4j1WQlZYrdVm0mgO8eNR3BQ2LEqrZ1jhyAl5P0Z
         goNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eAMuwrdgZT+muWB0jbfvOv3S8Lq4I5ca8nN0yy/ukz0=;
        b=c1zh4R40VYT9Sa50a8NxGPHGYZyeOzyWP/JLlc6u2/G1z2tlUeYYzTo8xhNVjKJ75Q
         FXMAkQW8uTjYJjzjVK5P2ruKacNhG3fEQj2vE/gWKxUUbImHV5GGUTgKQL9/NQyxzDDk
         2A+JuI8AKmrv3UOsNo1i41YuRkf/+HaeT65BGrxyJYPRdUllnymrgx7kqYBjxSLOE+r3
         TZEZerVwD96TWJlS3JOYeNcyZm9Du8n5flrb32iK5J/qEEqIUsXsa3HJIQsZOM9FzS4r
         Ne4IBDvFaW7Itz95/hVSmK+oYb8O4fANBAkSg0fThahY5ffKFiCrjXB1GBYTlZ8iY/2s
         kORg==
X-Gm-Message-State: AOAM533TpjDqUblOUpURbuaKKnAIbOeYXhNfV2NiglIO/g2YPRktK7y9
        knXJaRbu2W6bwb2VYx2RBQU=
X-Google-Smtp-Source: ABdhPJzAcSGTRrLFOmP79A7ggudrEJgXuKyu8xMVkv0QQMyCBYdTZ/AamCIx35vhcp1GbD6dWOo6aA==
X-Received: by 2002:a62:ce83:: with SMTP id y125mr14969637pfg.181.1595167180458;
        Sun, 19 Jul 2020 06:59:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y24sm14438897pfp.217.2020.07.19.06.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Jul 2020 06:59:40 -0700 (PDT)
Date:   Sun, 19 Jul 2020 06:59:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 16/20] dt-bindings: watchdog: renesas,wdt: Document
 r8a774e1 support
Message-ID: <20200719135939.GA37256@roeck-us.net>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 12:09:06PM +0100, Lad Prabhakar wrote:
> RZ/G2H (a.k.a. R8A774E1) watchdog implementation is compatible
> with R-Car Gen3, therefore add the relevant documentation.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml b/Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml
> index 572f4c912fef..6933005b52bd 100644
> --- a/Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml
> +++ b/Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml
> @@ -41,6 +41,7 @@ properties:
>                - renesas,r8a774a1-wdt     # RZ/G2M
>                - renesas,r8a774b1-wdt     # RZ/G2N
>                - renesas,r8a774c0-wdt     # RZ/G2E
> +              - renesas,r8a774e1-wdt     # RZ/G2H
>                - renesas,r8a7795-wdt      # R-Car H3
>                - renesas,r8a7796-wdt      # R-Car M3-W
>                - renesas,r8a77961-wdt     # R-Car M3-W+
