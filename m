Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0AE3A4F6E
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 17:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhFLPF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 11:05:59 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:36769 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLPF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 11:05:58 -0400
Received: by mail-ej1-f47.google.com with SMTP id nd37so1348869ejc.3;
        Sat, 12 Jun 2021 08:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lzkuIcYZnAVqMXyxD6xyd/7tudQR5k0g+A1SIi5XBXM=;
        b=NGTfdSi11NO/flIjG1D0AwbccPck7H8Gp2yO3ZR2Mff84O8SQpXJ8HIDulyokJAKIu
         gm+w8JXuPA/4WRQ8JIOFqRQAS7pRa1AKQztJMlidL9J0o1BXOVLq5/XsDh0PxxQhVQ3L
         lwpvyer+pSWOx9kb5Ye1vzXiesPFmrx1tJ4E7/eGQh47MOehWIwwwnLfMFeH4mHTa1t3
         +CjZNSP4zye7MSOUj8NJ3S7tEkKFKbje7QiWfDUq/8NUZmubAV6CGqz+qgc4HSMl8HPQ
         7xRWiCrsBt49t7h+jGTkQoDwXDd8EzVvzx49Im8TpdZhNgceUmc1hTXknQIS9T+XDsQz
         s77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lzkuIcYZnAVqMXyxD6xyd/7tudQR5k0g+A1SIi5XBXM=;
        b=LnqH+iM4MfaCVh9Zi80qAz6Yo9KPmzFhj4KVoQ1h6mYXHmiylR2k87AsPvA3NjPqEn
         y+rMDWnBJEd8dp8tc55mNNlu0OKBuOvhkrwixRnrsgYxoR4sKExDIvv9thCiqUnoI6Dy
         KE2zsNWAmO3l1omLcMj9ywzMYDmRhcpX2oMXRqA4lBV1N9ZWd8ul7uJa5JUHmpW+xeyp
         2mUL44hL8zlEIC1pj8iSsg36KZqADEyiAzSo4Yu21KtTczpRzfwTkvKo3ngEgag3VSwz
         v2rc9unPXYtQCsrpdVjEBE4VpbJuMd1rClG8j0izPr8zPT+fbe1qhrqdiMWliw5fQR+Y
         noiQ==
X-Gm-Message-State: AOAM533ivS8ffEgf6ZfyyadguEW03QYFQX5f6L+najL0RLxluJDK/x9c
        MHQNIZchJ2i/ycnI2vicFpw=
X-Google-Smtp-Source: ABdhPJzSO+Lw4ZmsVe+cS+swewzYpfxKi+2oYyEABFnks0olrceriyOcYej+IRW1DQZsGAR2pDUheA==
X-Received: by 2002:a17:907:2895:: with SMTP id em21mr7852119ejc.164.1623510177795;
        Sat, 12 Jun 2021 08:02:57 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id t18sm3985455edw.47.2021.06.12.08.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 08:02:57 -0700 (PDT)
Date:   Sat, 12 Jun 2021 18:02:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: Fix dereference of null dev
Message-ID: <20210612150256.jziw3xhk7i6fyms4@skbuf>
References: <20210612144407.60259-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612144407.60259-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 03:44:07PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently pointer priv is dereferencing dev before dev is being null
> checked so a potential null pointer dereference can occur. Fix this
> by only assigning and using priv if dev is not-null.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 16994374a6fc ("net: dsa: b53: Make SRAB driver manage port interrupts")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/dsa/b53/b53_srab.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
> index aaa12d73784e..e77ac598f859 100644
> --- a/drivers/net/dsa/b53/b53_srab.c
> +++ b/drivers/net/dsa/b53/b53_srab.c
> @@ -629,11 +629,13 @@ static int b53_srab_probe(struct platform_device *pdev)
>  static int b53_srab_remove(struct platform_device *pdev)
>  {
>  	struct b53_device *dev = platform_get_drvdata(pdev);
> -	struct b53_srab_priv *priv = dev->priv;
>  
> -	b53_srab_intr_set(priv, false);
> -	if (dev)
> +	if (dev) {
> +		struct b53_srab_priv *priv = dev->priv;
> +
> +		b53_srab_intr_set(priv, false);
>  		b53_switch_remove(dev);
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.31.1
> 

I think the better question is how can "dev" be NULL in the first
place, since b53_srab_probe() does an unconditional platform_set_drvdata()
with what appears to be a non-NULL dev.
