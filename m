Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA3745539D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbhKREDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbhKREDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 23:03:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235EAC061570;
        Wed, 17 Nov 2021 20:00:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso4420101pjo.3;
        Wed, 17 Nov 2021 20:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jdGrrXPUOtxSQN3it++JjoOFhHsi3reFXEOFB2aKNIM=;
        b=WJ76E809amb4tC5M4xXYnnelwDS9nI7Of9Zy7cA2+eZdLxhPgq/TF1oUL9IqrQ9Gtr
         WIcFBk0LHyPZ84HksYiCOzdb+vW7TyDDORIVUKKKO/s/MZCHBIKSMlZnE/Hhrsr6ScUR
         EJDQBeXMdsX3k08Vxvz7YJGnb/Q9/lrDrKgXO/AATheFw9OzhotYxipSJfSiD+FoC2zm
         yCfjx0q3mlRips7KARTB05kglPwMFAHReWubKy6gycLQGIcYCbXFJinr7x5820GeMyWj
         bcLwKeRPPB7mg9SDsBy90z3O4doDKQIondGQZqO4c9gA/8tQ9OlI/YaIm4m4Mn+0p7Js
         owOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdGrrXPUOtxSQN3it++JjoOFhHsi3reFXEOFB2aKNIM=;
        b=vqotb5YrSqJy8GB4PraNC3nPLPgCZKdtZsWJ9DxkzbMDD2UZF/Mti3gwFjwH4n9sLr
         Li9rq8RZO2A1qy+IORHQnWbtJRgmXkQGzn3TTMUJCvlfKjw3lg297d/XO5ODtUct0Jsr
         7R16625+yp4Joi4+Bj32cquDDjRR3vmdhNey/Wr8qJcMdbjntktwhK4LBkn5IRwAYbii
         juf7Hc0xzRBGuJhaIPLHJuwXiwcjHCgXTLVpmD47Ls+h4hGOuW5nBOKIhfvjx9n6dGJt
         jMmwSvXLUx+qjgoXmmYiazcHGfD7CPx0MaXSllpEjmBdlWIUqOBd4848VkcNT5/yX5Pg
         9BuA==
X-Gm-Message-State: AOAM530eNN8ZBQRl09tB4bddnujYA9S4O5SpIEuu/xajUs3g5I6gMk6/
        5UQnHvkvfl1RUvZ/K4MfuDuF9hNblTg=
X-Google-Smtp-Source: ABdhPJxDIDJg4bw8+7uZE+u+vt2Rzdyj5v0ckwPBIYgE49L80MSH+km5mDzm+5B7EUV4qGjVoorKUg==
X-Received: by 2002:a17:902:d490:b0:141:fd0f:5316 with SMTP id c16-20020a170902d49000b00141fd0f5316mr61937331plg.14.1637208038473;
        Wed, 17 Nov 2021 20:00:38 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j15sm1152310pfh.35.2021.11.17.20.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 20:00:37 -0800 (PST)
Subject: Re: [PATCH -next] net: mvpp2: Use div64_ul instead of do_div
To:     Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net
Cc:     kuba@kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <1637204701-8224-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cbcdb354-04de-2a9a-1754-c32dd014e859@gmail.com>
Date:   Wed, 17 Nov 2021 20:00:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1637204701-8224-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/21 7:05 PM, Yang Li wrote:
> do_div() does a 64-by-32 division. Here the divisor is an
> unsigned long which on some platforms is 64 bit wide. So use
> div64_ul instead of do_div to avoid a possible truncation.
> 
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:2742:1-7: WARNING:
> do_div() does a 64-by-32 division, please consider using div64_ul
> instead.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index df6c793..41244a5 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -2739,7 +2739,7 @@ static u32 mvpp2_cycles_to_usec(u32 cycles, unsigned long clk_hz)
>  {
>  	u64 tmp = (u64)cycles * USEC_PER_SEC;
>  
> -	do_div(tmp, clk_hz);
> +	tmp = div64_ul(tmp, clk_hz);
>  
>  	return tmp > U32_MAX ? U32_MAX : tmp;
>  }
> 

This is silly, clk_hz fits in a u32, why pretends it is 64bit ?

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index df6c793f4b1b04eb1f812ce2a3a82a39cde0f68b..1bea316bf13ac42ad65ba326fc1d9e206546766e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2726,7 +2726,7 @@ static void mvpp2_tx_pkts_coal_set(struct mvpp2_port *port,
        }
 }
 
-static u32 mvpp2_usec_to_cycles(u32 usec, unsigned long clk_hz)
+static u32 mvpp2_usec_to_cycles(u32 usec, u32 clk_hz)
 {
        u64 tmp = (u64)clk_hz * usec;
 
@@ -2735,7 +2735,7 @@ static u32 mvpp2_usec_to_cycles(u32 usec, unsigned long clk_hz)
        return tmp > U32_MAX ? U32_MAX : tmp;
 }
 
-static u32 mvpp2_cycles_to_usec(u32 cycles, unsigned long clk_hz)
+static u32 mvpp2_cycles_to_usec(u32 cycles, u32 clk_hz)
 {
        u64 tmp = (u64)cycles * USEC_PER_SEC;
 
@@ -2748,7 +2748,7 @@ static u32 mvpp2_cycles_to_usec(u32 cycles, unsigned long clk_hz)
 static void mvpp2_rx_time_coal_set(struct mvpp2_port *port,
                                   struct mvpp2_rx_queue *rxq)
 {
-       unsigned long freq = port->priv->tclk;
+       u32 freq = port->priv->tclk;
        u32 val = mvpp2_usec_to_cycles(rxq->time_coal, freq);
 
        if (val > MVPP2_MAX_ISR_RX_THRESHOLD) {
@@ -2764,7 +2764,7 @@ static void mvpp2_rx_time_coal_set(struct mvpp2_port *port,
 
 static void mvpp2_tx_time_coal_set(struct mvpp2_port *port)
 {
-       unsigned long freq = port->priv->tclk;
+       u32 freq = port->priv->tclk;
        u32 val = mvpp2_usec_to_cycles(port->tx_time_coal, freq);
 
        if (val > MVPP2_MAX_ISR_TX_THRESHOLD) {


