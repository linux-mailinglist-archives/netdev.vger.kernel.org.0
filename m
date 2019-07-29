Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A896079010
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfG2QAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:00:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42357 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbfG2QAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:00:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so28471021pgb.9
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S4J+No4gkWOnQVKPGqRwSBJLUZy6AyDfmvu5ZpQSHH8=;
        b=bOhzRjH4G1FajHckEmmu+y7DFxdejwmtd3Ed+Gkca1gJOGsU5n54FxKjURCCPkqkpF
         J7l/Q7SqEYJ1jtAXrG60/1bT8Fe5zpgi2bi14RDjNdmL/RdCnVtMu7QwxDrH3tpKtU0o
         BEkotUQ8OmGGQ1+fNd42GzmPF1fC8fxHcmBoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S4J+No4gkWOnQVKPGqRwSBJLUZy6AyDfmvu5ZpQSHH8=;
        b=WKlQPgkofvoIVGbQlwVel6SS+5fjwmB4d6jKk5JaNqiXFvaLRSsvbJf8rfGB7dl5tN
         2SrQtKd7+7EqBV2c7q7G1nM/nznycBnleeucpcNpaYn62nUzChWLe+xVR5DHxnaDOxfR
         XHvIvuTFfPgyZM9b85XwVF1Jq3fsiDWMNmYypOjBX1jewPkLDGv9FgR8+BsQ7EcpS7Fh
         IqGGqmMYjPFV2SiDMmVrwLhx1lRFqWedE63oCii8DcM0OOa1+Aw3LDc819su/BuyZO2D
         eZaVMNELAMrq/RoeEXkO+BvwK+luufzT/11g8jJa8Ppcirgmn6LdY9Ty/NHnCjyEMZAa
         cS7A==
X-Gm-Message-State: APjAAAVCW8BjTRUKnMi+3UOkv9Jb05VdOXDlMN+XH17AEFq1uLx3NIuM
        13gU6H9QF2NqvjQshKJJ0s4EsQ==
X-Google-Smtp-Source: APXvYqwAp3qyhnbwBBWRBCE1eQkQ3EEc5VDAgvIsB4VGCk0/UBZqXxXAx7j+NLBnGakSA9sqWd49lA==
X-Received: by 2002:a63:211c:: with SMTP id h28mr104567673pgh.438.1564416009060;
        Mon, 29 Jul 2019 09:00:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d6sm55069374pgf.55.2019.07.29.09.00.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 09:00:08 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:00:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] arcnet: com90io: Mark expected switch fall-throughs
Message-ID: <201907290900.80C6D551@keescook>
References: <20190729111320.GA3193@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729111320.GA3193@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 06:13:20AM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings (Building: powerpc allyesconfig):
> 
> drivers/net/arcnet/com90io.c: In function 'com90io_setup':
> include/linux/printk.h:304:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/arcnet/com90io.c:365:3: note: in expansion of macro 'pr_err'
>    pr_err("Too many arguments\n");
>    ^~~~~~
> drivers/net/arcnet/com90io.c:366:2: note: here
>   case 2:  /* IRQ */
>   ^~~~
> drivers/net/arcnet/com90io.c:367:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    irq = ints[2];
>    ~~~~^~~~~~~~~
> drivers/net/arcnet/com90io.c:368:2: note: here
>   case 1:  /* IO address */
>   ^~~~
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/arcnet/com90io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
> index 2c546013a980..186bbf87bc84 100644
> --- a/drivers/net/arcnet/com90io.c
> +++ b/drivers/net/arcnet/com90io.c
> @@ -363,8 +363,10 @@ static int __init com90io_setup(char *s)
>  	switch (ints[0]) {
>  	default:		/* ERROR */
>  		pr_err("Too many arguments\n");
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
