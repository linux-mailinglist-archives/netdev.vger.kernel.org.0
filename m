Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65854418723
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 09:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhIZH22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 03:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhIZH21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 03:28:27 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604B4C061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 00:26:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v10so50188692edj.10
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 00:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6sJObhDubOjt3m0e1lZZZ3v+mzCtoD8DuEdUF5auOqU=;
        b=ml/7FKYrFSFByzGhbrm3pEm2vHc6eckZG+85KNWFpXncR70mvGYKQgwcHqVa1+VVNp
         SqCsVRW4BpiI+tIenknrPyFdyeeOKs6getOwbWBudXcSHdNwT3pkyXzHWr8jrDMv35vz
         Z0F4PzJF/doF6Kg0RO97uscReXAPfv47xNE2KIzx5P0GeR2WHoD+CaLKkUp/emuPai7i
         ckxJ6bkM9XzAD09K+RuyirSIgZUZMFYsNtxQI8MXKzqLvbCf8kNzL6iTVLpRl+Gw+z5m
         0Tpo2qLHEwR6N2BCIkY4XSCg8BAG9o3Whnrr02TGNBZQuDAz+jcBWHCvlSkjdxDHNT9y
         Fnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6sJObhDubOjt3m0e1lZZZ3v+mzCtoD8DuEdUF5auOqU=;
        b=0GEVinJQsl4SpkUddyPnGKa4Op1LcFHzbpqHsYBI8XSjMIDtKbNXb+wBhcQmuZV4fR
         bh2wqbUItH56zdJSkS2cesssRRxL6cxYZZHXSVojjgtzCNTq1NfaieC1nXuwVMzSmqo3
         45YRQv8boI3odVEsEUmzdJkIa5aqaCu9Yct3VZTscxJMbx9mVFXR2XeD24A/eHgMvIJW
         +NEigNfZ0XclWkvTaMS6Kb1KLIj9phglwgVOBqXLwf7S9wL7FzmwIMSnNU5vtSrEgq7E
         f5kbH/Wgsu+Gk3W4AsbkxjKK/XVOH4i5bzOPx0LnLXl2g7MUDbdF6Kw2euy332Zl4vEv
         XDSA==
X-Gm-Message-State: AOAM532Zf13ldd7PlpOxguQROQnUENBelpphCyHurabhRoBwykArnGgn
        o4Ls0i3WoIry+m+jmcvfhmiuFKcw1xQ=
X-Google-Smtp-Source: ABdhPJyftt4J20YQqGFv0RZFJME6RW5SCEIFYkGFP/1X3gvxYhrAqnyIcc6Ob845Mf29wOJAwKR8Ig==
X-Received: by 2002:a50:e04e:: with SMTP id g14mr16653823edl.168.1632641209896;
        Sun, 26 Sep 2021 00:26:49 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id e28sm8517661edc.93.2021.09.26.00.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 00:26:49 -0700 (PDT)
Subject: Re: [PATCH net-next] net: mlx4: Add support for XDP_REDIRECT
To:     Joshua Roys <roysjosh@gmail.com>, netdev@vger.kernel.org
References: <20210923161034.18975-1-roysjosh@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <8d7773a0-054a-84d5-e0b6-66a13509149e@gmail.com>
Date:   Sun, 26 Sep 2021 10:26:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923161034.18975-1-roysjosh@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your patch.
It was submitted and accepted during the weekend, in our off-hours (we 
work Sunday - Thursday).
Please check my comments below.

On 9/23/2021 7:10 PM, Joshua Roys wrote:

Empty commit message? No feature description, motivation, performance 
numbers, etc... That's bad.

> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> This is a pattern-match commit, based off of the mlx4 XDP_TX and other
> drivers' XDP_REDIRECT enablement patches. The goal was to get AF_XDP
> working in VPP and this was successful. Tested with a CX3.
> 

Your comment here doesn't get into the git commit log. It can't replace 
the patch description above.

> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 7f6d3b82c29b..557d7daac2d3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -669,6 +669,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	struct bpf_prog *xdp_prog;
>   	int cq_ring = cq->ring;
>   	bool doorbell_pending;
> +	bool xdp_redir_flush;
>   	struct mlx4_cqe *cqe;
>   	struct xdp_buff xdp;
>   	int polled = 0;
> @@ -682,6 +683,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
>   	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
>   	doorbell_pending = false;
> +	xdp_redir_flush = false;
>   
>   	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
>   	 * descriptor offset can be deduced from the CQE index instead of
> @@ -790,6 +792,14 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   			switch (act) {
>   			case XDP_PASS:
>   				break;
> +			case XDP_REDIRECT:
> +				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {

xdp_do_redirect returns a negative error code, or zero on success.
The >= 0 comparison looks strange and doesn't fit to the code style.
Simply use: "if (xdp_do_redirect(...))"


> +					xdp_redir_flush = true;
> +					frags[0].page = NULL;
> +					goto next;
> +				}
> +				trace_xdp_exception(dev, xdp_prog, act);
> +				goto xdp_drop_no_cnt;

You didn't add the required stats to count packets going through the new 
xdp_redirect flow. Every incoming packet *MUST* increase some counter. 
Please add it.

>   			case XDP_TX:
>   				if (likely(!mlx4_en_xmit_frame(ring, frags, priv,
>   							length, cq_ring,
> @@ -897,6 +907,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   			break;
>   	}
>   
> +	if (xdp_redir_flush)
> +		xdp_do_flush();
> +
>   	if (likely(polled)) {
>   		if (doorbell_pending) {
>   			priv->tx_cq[TX_XDP][cq_ring]->xdp_busy = true;
> 

Thanks,
Tariq
