Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D444D51ED
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfJLTCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:02:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43371 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfJLTCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:02:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so8012448pfo.10
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xWZ56NBmVEcDwqCs8+XU51pN1dHy6wH+emb1XCC/M8o=;
        b=TyPIbm5EqngdsId97+KwcLWTovi/nabn7uOD3xBPsd95xGJDto+ICMaHSXTOnJ3MDY
         2erhjk1s0eAmeL8mPT6E4QopSlOGG7cqYPuLnRgyA/1MRlHOgak3EIBK7AGFoctzaucB
         YnGmeTquzkhNYEzCsHpjghPPGyARdyjSABG7QZHzETlWgZotfI4JiJHymyRhhIYCz5q7
         QEA11J+QA0QMxQghMQnD/ro/GVpTNR8EOZ3BiIHtepQcSX6L8EkYLBPgs70mthvUNbyO
         p2oAmyY53GX60Dh8pUPWlOsokpxc5mM1TfLGi6SY9ub2OHt86f3coNaHo9WVI+CQRB4J
         y+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xWZ56NBmVEcDwqCs8+XU51pN1dHy6wH+emb1XCC/M8o=;
        b=NRzJ2EtBWOnoTCQvvgHL/xov6FtshbvilGWGx6wpgFWt7ZXbwPPgMFl7QzON8mSzqN
         FuBkyrpftF0XvFfo4r/RgWUT6t1vYZ8LjA6+iJATmU3VykgxEplpm/tx4V9+cvCe6cyY
         B76JcV3OBi5syPaReZkarOtr9wdDS7mc+SbwAVbqVpM3DQuyouGZLOesmfJZ7yipEqi4
         82Ji+gF5TVDW+RhfntPvyjqaYLgYIo154GccHzDTCwRorqXeq/CrmejCU9C0qvjGVdq4
         l1R0OQdGYELpPzgKtYFdNQQj21os9HYDySRiQlmUHi6CWqP1bPCx4NWIiQYNpSiLYBKs
         ZSfw==
X-Gm-Message-State: APjAAAXmMS4NSFlIg/XFA0egVzQhehGewX7ZUDnrUc8trT+y+pL/R40x
        STvuXgsaGOUhKEOAsKGh4LQ=
X-Google-Smtp-Source: APXvYqxC1Dm5WQ5Kx0xng+UByQ/loDRQ3H0Dw+KFe3P5cLcGzzHAIYu8qkgpq3qRX2hXwp9hgqmzcQ==
X-Received: by 2002:a17:90a:9701:: with SMTP id x1mr24772503pjo.35.1570906966139;
        Sat, 12 Oct 2019 12:02:46 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a16sm14081409pfa.53.2019.10.12.12.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 12:02:45 -0700 (PDT)
Date:   Sat, 12 Oct 2019 12:02:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Message-ID: <20191012190242.GK3165@localhost>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <df637c9a87f6fd0107ad536d0c87be45e69feaa0.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df637c9a87f6fd0107ad536d0c87be45e69feaa0.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:40AM +0000, Igor Russkikh wrote:

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> index d5a28904f708..ba1597bb6eab 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> @@ -16,15 +16,107 @@
>  struct aq_ptp_s {
>  	struct aq_nic_s *aq_nic;
>  
> +	spinlock_t ptp_lock;
>  	struct ptp_clock *ptp_clock;
>  	struct ptp_clock_info ptp_info;
>  };
>  
> +/* aq_ptp_adjfreq
> + * @ptp: the ptp clock structure
> + * @ppb: parts per billion adjustment from base
> + *
> + * adjust the frequency of the ptp cycle counter by the
> + * indicated ppb from the base frequency.
> + */
> +static int aq_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)

The adjfreq() callback is deprecated.  Please implement adjfine() instead.

> +{
> +	struct aq_ptp_s *aq_ptp = container_of(ptp, struct aq_ptp_s, ptp_info);
> +	struct aq_nic_s *aq_nic = aq_ptp->aq_nic;
> +
> +	mutex_lock(&aq_nic->fwreq_mutex);

Here you use a different lock than...

> +	aq_nic->aq_hw_ops->hw_adj_clock_freq(aq_nic->aq_hw, ppb);
> +	mutex_unlock(&aq_nic->fwreq_mutex);
> +
> +	return 0;
> +}
> +
> +/* aq_ptp_adjtime
> + * @ptp: the ptp clock structure
> + * @delta: offset to adjust the cycle counter by
> + *
> + * adjust the timer by resetting the timecounter structure.
> + */
> +static int aq_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct aq_ptp_s *aq_ptp = container_of(ptp, struct aq_ptp_s, ptp_info);
> +	struct aq_nic_s *aq_nic = aq_ptp->aq_nic;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&aq_ptp->ptp_lock, flags);

... here.  Is it safe to concurrently set the time and the frequency?

> +	aq_nic->aq_hw_ops->hw_adj_sys_clock(aq_nic->aq_hw, delta);
> +	spin_unlock_irqrestore(&aq_ptp->ptp_lock, flags);
> +
> +	return 0;
> +}

Thanks,
Richard
