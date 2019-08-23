Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335289B445
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388986AbfHWQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:10:11 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39671 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388976AbfHWQKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:10:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id z3so5843368pln.6
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 09:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=brEz57KSv9M0lzRju932ZTp5uWTNGJMBeYQNt57q3B8=;
        b=LSk4JaiG3kNahJym5ph4p7/DJszhGCxXYsNz9CSryZBvZSEWdvgKnM9o/iYlhJpnhY
         CIxBe/BWxYQDTnOwVGPWaxb7855aVGTWS2LKsP+jgxko4VMfvsyEeaWp11bI5zR40AxO
         SmqZ1nUYR4g85pD5hbkGczt5q5VVEQvWbckzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=brEz57KSv9M0lzRju932ZTp5uWTNGJMBeYQNt57q3B8=;
        b=c+H08I/PN4kHH+6XUM15jZI1ZetM5NxIJyRgGZb6/BFMG4g7nHpwkiJOzWKz1b05w1
         Jkx+dd9/uQ60f50tIVKySksbdgEUkObIMWddDsSA/k2cEfN2GRrTRfH8PQtVS9KpPN0I
         v/ZsIgk8mCfsAKkq36IRvUmBwxQTc/7rueFEFCzOsV1rdV9HepLNeAcsViybWeoKZTf4
         XFScWLOT0bMiGZVJLEmclQ5Ig7CGVO6U1LMh3c2O0AXCttC6GUWH3TPXPaVGbYRFIKOD
         Ej6eURBR+Bj8weu07FdUr6EmlTikUieEmr+5tFhqJP7MI33NdkhnZCe1HcX6iBVexUpk
         aoQQ==
X-Gm-Message-State: APjAAAVVfMvdJqDgn4lxqx4u61Ek/QWoPYVwdBFk34GrpxX3ilkPYgk7
        Sksn9Ep7sUZnUKYShK4zWbxBuA==
X-Google-Smtp-Source: APXvYqxiP2ekIBBxAiFgPENCMVwHMGc68Z6hyNSBFfdXPSdkPG9bT4Of774IUlvHarZSaUjmecbKzA==
X-Received: by 2002:a17:902:f24:: with SMTP id 33mr3626425ply.309.1566576609501;
        Fri, 23 Aug 2019 09:10:09 -0700 (PDT)
Received: from [10.136.13.65] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id a142sm3342737pfd.147.2019.08.23.09.10.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:10:08 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=5bPATCH=5d_ethernet=3a_Delete_unnecessary_checks_b?=
 =?UTF-8?Q?efore_the_macro_call_=e2=80=9cdev=5fkfree=5fskb=e2=80=9d?=
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        intel-wired-lan@lists.osuosl.org,
        bcm-kernel-feedback-list@broadcom.com,
        UNGLinuxDriver@microchip.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
Cc:     kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
 <4ab7f2a5-f472-f462-9d4c-7c8d5237c44e@wanadoo.fr>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <c90f0649-0dc0-df9a-21e6-ae6566ca5935@broadcom.com>
Date:   Fri, 23 Aug 2019 09:10:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4ab7f2a5-f472-f462-9d4c-7c8d5237c44e@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-08-23 7:08 a.m., Christophe JAILLET wrote:
> Hi,
>
> in this patch, there is one piece that looked better before. (see below)
>
> Removing the 'if (skb)' is fine, but concatening everything in one 
> statement just to save 2 variables and a few LOC is of no use, IMHO, 
> and the code is less readable.
Agreed.
>
> just my 2c.
>
>
> CJ
>
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c 
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index d3a0b614dbfa..8b19ddcdafaa 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2515,19 +2515,14 @@ static int bcmgenet_dma_teardown(struct 
> bcmgenet_priv *priv)
>  static void bcmgenet_fini_dma(struct bcmgenet_priv *priv)
>  {
>      struct netdev_queue *txq;
> -    struct sk_buff *skb;
> -    struct enet_cb *cb;
>      int i;
>
>      bcmgenet_fini_rx_napi(priv);
>      bcmgenet_fini_tx_napi(priv);
>
> -    for (i = 0; i < priv->num_tx_bds; i++) {
> -        cb = priv->tx_cbs + i;
> -        skb = bcmgenet_free_tx_cb(&priv->pdev->dev, cb);
> -        if (skb)
> -            dev_kfree_skb(skb);
> -    }
> +    for (i = 0; i < priv->num_tx_bds; i++)
> + dev_kfree_skb(bcmgenet_free_tx_cb(&priv->pdev->dev,
> +                          priv->tx_cbs + i));
>
>      for (i = 0; i < priv->hw_params->tx_queues; i++) {
>          txq = netdev_get_tx_queue(priv->dev, priv->tx_rings[i].queue);
