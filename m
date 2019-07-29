Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192E77900F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfG2P74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:59:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36590 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbfG2P74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:59:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so27694116plt.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ypw9PUbsShknmT2duzGjmQ83venT9YzhrR/q0NdLkL4=;
        b=GwjgBUER3x86bQrzgggNOqaONeQm7M4oF4dWF9VHXIXm+J9ORp+B66F0mbXg3X4ikg
         FJfBV315qg3LM6m2+amp6YyawGiYqN5jaqmw7T4+kb1IYyB3VqTbP/v6eKB0LofMXShG
         NW8IG/xrk9KXSzf/dmPh7SkgYkTm2qiPaYojI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ypw9PUbsShknmT2duzGjmQ83venT9YzhrR/q0NdLkL4=;
        b=j1toqZwZrgeqYvngjiIS++QsTgitvSRh4iJMUI55sdGPkY2ZwqS+3FVfyh6JATv5Ab
         S5XxscptFnIvMxKUatJf2gTw4HdyLC/oFU3qZ172CPmhtp/PTpdvjMVuxdnj8oGpZxia
         bfoGWahnfl+aTSJKs8QrTCCiEaM2ox9d2PosDcJiPdHx9LKIwaDV15vcySQIpUA8JrGM
         w6Dlv0tIoSf/RjQCEBw8mQzrFSJpAHPmxzRPRf78QjfMndUUZfCZDaC5FaOjf9I6dVPJ
         HJLWxgZehoGPvJOB1n/swY/amPKlX5Mpy4X5xfnIq93tJA+x79xxbiCs6UMHbuJ5X8w+
         XpXA==
X-Gm-Message-State: APjAAAXpsbiTqxYsoz1VnH23kXd9RdThhGEkc0zEi+TpJPhbeLfRxxrK
        bMT99D3C4Sv5Payxz2DsbpCVeA==
X-Google-Smtp-Source: APXvYqxQqArafC9IimGzDGwVWM723dCkB1XEmSqfUV0sVHdThXbA5OabXfrSR2b1qQhfBv/iOji9Tg==
X-Received: by 2002:a17:902:bcc4:: with SMTP id o4mr108706932pls.90.1564415995533;
        Mon, 29 Jul 2019 08:59:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z63sm33165280pfb.98.2019.07.29.08.59.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 08:59:54 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:59:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] arcnet: com90xx: Mark expected switch fall-throughs
Message-ID: <201907290859.E762A250@keescook>
References: <20190729110953.GA3048@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729110953.GA3048@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 06:09:53AM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings (Building: powerpc allyesconfig):
> 
> drivers/net/arcnet/com90xx.c: In function 'com90xx_setup':
> include/linux/printk.h:304:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/arcnet/com90xx.c:695:3: note: in expansion of macro 'pr_err'
>    pr_err("Too many arguments\n");
>    ^~~~~~
> drivers/net/arcnet/com90xx.c:696:2: note: here
>   case 3:  /* Mem address */
>   ^~~~
> drivers/net/arcnet/com90xx.c:697:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    shmem = ints[3];
>    ~~~~~~^~~~~~~~~
> drivers/net/arcnet/com90xx.c:698:2: note: here
>   case 2:  /* IRQ */
>   ^~~~
> drivers/net/arcnet/com90xx.c:699:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    irq = ints[2];
>    ~~~~^~~~~~~~~
> drivers/net/arcnet/com90xx.c:700:2: note: here
>   case 1:  /* IO address */
>   ^~~~
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/arcnet/com90xx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
> index ca4a57c30bf8..bd75d06ad7df 100644
> --- a/drivers/net/arcnet/com90xx.c
> +++ b/drivers/net/arcnet/com90xx.c
> @@ -693,10 +693,13 @@ static int __init com90xx_setup(char *s)
>  	switch (ints[0]) {
>  	default:		/* ERROR */
>  		pr_err("Too many arguments\n");
> +		/* Fall through */
>  	case 3:		/* Mem address */
>  		shmem = ints[3];
> +		/* Fall through */
>  	case 2:		/* IRQ */
>  		irq = ints[2];
> +		/* Fall through */
>  	case 1:		/* IO address */
>  		io = ints[1];
>  	}
> -- 
> 2.22.0
> 

-- 
Kees Cook
