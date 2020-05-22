Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251011DE97C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgEVOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbgEVOrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 10:47:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D17C061A0E;
        Fri, 22 May 2020 07:47:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l73so2297354pjb.1;
        Fri, 22 May 2020 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pyI8RXJv0A9qOfUOs7+t5xXq9tBCjrOPiOAhgZoNJGU=;
        b=Ujuhda9sRCNvYqh00NglKq18LhbkIq8aE4BUcXG3v7wbWcu1ySHA8zIVb+5qyZ5cXW
         UPnhYOx5gxzweUHjEMfamVI16WBTsGW/NWZNFpC9CEQgX161wxmC4s/WE5Nr6RTQeIaH
         4b0YabqbO/sH76bBoye3TRdm6o763j0xliAkqVo4UvT1jBaZSTQ2HyKPHfXhhuaOEGov
         OnPnEuh+Lz3gZcTkTSnw3jkWnBbRhfB3bq6nDxWHwRcrdf+dhjoA/2tWBwEyXr13fZGJ
         fX40OFWM3EC8WYw3wOseIxV8YbmhcqwcoQNHcF/foWZpegvLrHtAdMB1s4r0DZIG6ixg
         HPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pyI8RXJv0A9qOfUOs7+t5xXq9tBCjrOPiOAhgZoNJGU=;
        b=O/hCP1V0NNJMQZUG+t9Bh5lxdUqVMSr3Qi+spR+8ouILsF45hzs17drHoHlshSpY4U
         3mUc0WKdF2fu8kwlhsRdftUaJFrahz05moRmmNqv0O1u602gkT0lzGC3KUrsEwA0bay/
         1wv0eEKLXcctPNITtDP9vcIH7iCzR1nWBaSzKfjdGZNAQYc0CEJamx6qcL4Gg5//PpBm
         3QV7gGO7UtBHIRKl8UJJfDJ5n42mzywPS8t3rf9ZJx7o9QidtqCkb+c39l2+qA7xQoAD
         QS4g/N4YwzI95zZBNYTKUUvBF+HWh/BPRHe1N7ebM51DkRl553jNi0vwEyNttL7qFDy5
         bDow==
X-Gm-Message-State: AOAM5302slwv5SbSva3ryBEGqn2pmj+qe/qzpqMMwdYBn7itrccZydCA
        mymHwrCSXGrvwzS3lx2/a0k=
X-Google-Smtp-Source: ABdhPJwEjkbC0ZRvqsKRNasE1thUYFAv46HEbfQoZ9/iqC+b34JBVlEVMv+91eqFvfq8/THk/tyv3A==
X-Received: by 2002:a17:902:bd42:: with SMTP id b2mr14491950plx.219.1590158830652;
        Fri, 22 May 2020 07:47:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v127sm7113218pfb.91.2020.05.22.07.47.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 May 2020 07:47:08 -0700 (PDT)
Date:   Fri, 22 May 2020 07:47:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
Message-ID: <20200522144707.GA173101@roeck-us.net>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 04:08:56PM +0100, Lad Prabhakar wrote:
> RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
> therefore add relevant documentation.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  Documentation/devicetree/bindings/watchdog/renesas,wdt.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt b/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
> index 79b3c62..e42fd30 100644
> --- a/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/renesas,wdt.txt
> @@ -5,6 +5,7 @@ Required properties:
>  		fallback compatible string when compatible with the generic
>  		version.
>  	       Examples with soctypes are:
> +		 - "renesas,r8a7742-wdt" (RZ/G1H)
>  		 - "renesas,r8a7743-wdt" (RZ/G1M)
>  		 - "renesas,r8a7744-wdt" (RZ/G1N)
>  		 - "renesas,r8a7745-wdt" (RZ/G1E)
