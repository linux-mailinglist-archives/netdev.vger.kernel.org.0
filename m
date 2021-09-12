Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9CD407E75
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhILQO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhILQOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:14:21 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Sep 2021 09:13:01 PDT
Received: from lb1-smtp-cloud9.xs4all.net (lb1-smtp-cloud9.xs4all.net [IPv6:2001:888:0:108::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A374C061574;
        Sun, 12 Sep 2021 09:13:01 -0700 (PDT)
Received: from cust-3a8def63 ([IPv6:fc0c:c1c9:903d:e9b4:326e:d2bd:718e:17cc])
        by smtp-cloud9.xs4all.net with ESMTPSA
        id PS57m4UmccSrkPS59mriLd; Sun, 12 Sep 2021 18:11:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1631463114; bh=Rkh5fe5ckn+qv2he4b3qNVogdA8plV7NpPMyL17OrJ0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From:
         Subject;
        b=tpeNy1kSwSoI+lvdLcKG52+7AwavVNtPziXnSj8+4LWYS6LcGN4DDcnfVZ9v7W33z
         LSUjGuJcEw1KjQK/Nnl7I+SlZA3MPWMlCQMiS5oqo7hpOPJCnhYFHBWJiFcYZSEm+X
         46nzMB1D8F2muY/J8Jaq1ou/0U9CY94ZMayOJGuOldK0QQUQmU0HiFLdHLUfi6i8HJ
         GCw1YTrgoKsLiqVge5lE1ogiNLSeh3E3kjLrdgqJqkZMOhfuoFlYfA3XovSQee9pSy
         bc3Hg9btUwwzvcQ9y5f54BKWWIXNc7GR5n/Zkq4rjVmMyv9rzPffGwbNGKGNULjOpC
         Kq86eZmK0HkyA==
Date:   Sun, 12 Sep 2021 18:11:48 +0200
From:   Jeroen Roovers <jer@xs4all.nl>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-alpha@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 2/4] net: i825xx: Use absolute_pointer for memcpy on
 fixed memory location
Message-ID: <20210912181148.60f147c8@wim.jer>
In-Reply-To: <20210912160149.2227137-3-linux@roeck-us.net>
References: <20210912160149.2227137-1-linux@roeck-us.net>
        <20210912160149.2227137-3-linux@roeck-us.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDDN+TVFZlqrPTgn5UvnCAIeaDEYv00W+k2D6F8WSW6CaVM3Vx2T12jZ3P+tSZYXAkmi6pjvZgc8k9a2owRgUCSuC2zQGYxwEYaHCL5QuBfRHx9eHd4A
 eZyYC12vLAmsBCmCHogCVD9xE3ne1gBAFQDRn6Uhps5sLb4wxLrzmi1dmgm71vH2Wfg5Zo/38RPF174c6DCbDqlg5jY1DYgFNhjZRmkgOBlKBDogPiRpyJvO
 rSYfziqnvgoT+H1Z7UKwrCo3+7vE0g0DS+Ixf59o53mcejQTRA4uhlrw//Xqs9ImhWM63wROcfIQjpNcw6CV2sMPkV6zKEHqA195ny4fQNbT0QVM8upL4McG
 LSUypvGXg3M5ZkvPie7YQ0LfNW7tt8lvpT1pBb8VjoWYGotgEud9dI7fbj8E+5FVZodxbbOb6hdJ3QALRHXnhfhXE5nPARSrXDuwUKZjdtR0a9XvcCgbSsIx
 H1tc95ZpyxPmRkZbkm9MaLYADy5ZY/+pnwZnFJc6emWx3cqQkHacNyeI3LUqL/6OiqgRTb/WSUFYMINyofds3yUhef34fWvFE5Wd6mXsaGPi45ovRKZn7ECf
 1pHG1fFaOiEmO5lUNWTgf7jaioAjG20J5MHd6blltY+B5RCj/nqb+OBg4Zv+tVOJLkgfAA2ACFfRwsIfCrDWx/jY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Sep 2021 09:01:47 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> gcc 11.x reports the following compiler warning/error.
> 
> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
>     ./arch/m68k/include/asm/string.h:72:25: error:
>             '__builtin_memcpy' reading 6 bytes from a region of size 0
>                     [-Werror=stringop-overread]
> 
> Use absolute_address() to work around the problem.

=> absolute_pointer()

> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/net/ethernet/i825xx/82596.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/i825xx/82596.c
> b/drivers/net/ethernet/i825xx/82596.c index
> b8a40146b895..b482f6f633bd 100644 ---
> a/drivers/net/ethernet/i825xx/82596.c +++
> b/drivers/net/ethernet/i825xx/82596.c @@ -1144,7 +1144,7 @@ static
> struct net_device * __init i82596_probe(void) err = -ENODEV;
>  			goto out;
>  		}
> -		memcpy(eth_addr, (void *) 0xfffc1f2c,
> ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
> +		memcpy(eth_addr, absolute_pointer(0xfffc1f2c),
> ETH_ALEN); /* YUCK! Get addr from NOVRAM */ dev->base_addr =
> MVME_I596_BASE; dev->irq = (unsigned) MVME16x_IRQ_I596;
>  		goto found;


Regards,
      jer
