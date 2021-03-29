Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6034CD52
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhC2JwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhC2Jvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:51:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765BFC061574;
        Mon, 29 Mar 2021 02:51:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j9so10444551wrx.12;
        Mon, 29 Mar 2021 02:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=93DcfhqgtfktNYwco+/lseOCnkVnHEhuy5c9l8CVzz4=;
        b=pffyDvAOie8uMl0siTK3GLdLWHiNqPgExweQb9wXMb483DBV1zWgFYHf0/ExWZOXIC
         59A43Z66AS0dBfPHbCjuma1K9gQGAjk3Yh6WJ6t7mzB+//avDZ1Y35DHxxJeimRPttIP
         pbIoNp6Db6FpuUcdOUHE2DawEdukr9exayyHkXbB8WxwdwgEqAg040uXn8Op4UFBZIdN
         jHNpfKJ6VpMQn/T7cryeR7mWOx1G5Q43fFdqEJlnOLIvz3pmuVZQIltqUSnp8rTqyXAi
         AP3d8dIGMz49QgwcIqvSrT2vcDEEmEeQM9jgayJr7U5U8jpSlQeM2F+/HeUg8v2EGU2d
         7yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=93DcfhqgtfktNYwco+/lseOCnkVnHEhuy5c9l8CVzz4=;
        b=MhxSgF3nHYvLfVrx2AZkAeV8rGiWLcUc29fE2MZ7tcYOAA7s1iDm5GTviEKqxQ3RcX
         Au+xWx/wbBK5iM+4zkNJbeENdwbd9aGtl0jsmSDYKBX1ECqQ5pg2wJ1exnd3HCvdi7Jc
         tRgyaAP6RJZhBvC+fIm2Yun5POgtI1Rmmd/INL5PIfLm3TTQZV3suDmrPm8klIxTlQzQ
         6e+5e173nq6ejEcT2ORTCVXLH8t5QjLZbevCNL0WvKTHF7COHwXrsefPuhkjF4mzgsMC
         O/OYzH7w1HyAQEhw7tYVrch9iRIHb2PYZPhtvaMAZxyNA+gEETAYTaEECysjJPsO1hnF
         C0rA==
X-Gm-Message-State: AOAM530dzIimQd4qWzwq5BKUbzdDlTt/isyVr9IG1TIGbTkHhCgfcOFy
        sHQaU8WouuIjTS7awcaz38q40xmY4REMZA==
X-Google-Smtp-Source: ABdhPJwpWPMYvsiGwLPDE6K+GRTz4Xw21Fxhc4GZIQCLGW7TdEToZ7flewLP3wrAkuiHydS+sUQqGQ==
X-Received: by 2002:a05:6000:120f:: with SMTP id e15mr26610369wrx.129.1617011497996;
        Mon, 29 Mar 2021 02:51:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:b80f:8305:42a8:f5fd? (p200300ea8f1fbb00b80f830542a8f5fd.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:b80f:8305:42a8:f5fd])
        by smtp.googlemail.com with ESMTPSA id t8sm29657343wrr.10.2021.03.29.02.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 02:51:37 -0700 (PDT)
Subject: Re: [PATCH] ethernet/realtek/r8169: Fix a double free in
 rtl8169_start_xmit
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, nic_swsd@realtek.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210329090248.4209-1-lyl2019@mail.ustc.edu.cn>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8d40cd7a-c47e-199d-dccb-e242ec93e143@gmail.com>
Date:   Mon, 29 Mar 2021 11:51:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210329090248.4209-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.03.2021 11:02, Lv Yunlong wrote:
> In rtl8169_start_xmit, it calls rtl8169_tso_csum_v2(tp, skb, opts) and
> rtl8169_tso_csum_v2() calls __skb_put_padto(skb, padto, false). If
> __skb_put_padto() failed, it will free the skb in the first time and
> return error. Then rtl8169_start_xmit will goto err_dma_0.
> 

No, the skb isn't freed here in case of error. Have a look at the
implementation of __skb_put_padto() and see also cc6528bc9a0c
("r8169: fix potential skb double free in an error path").


> But in err_dma_0 label, the skb is freed by dev_kfree_skb_any(skb) in
> the second time.
> 
> My patch adds a new label inside the old err_dma_0 label to avoid the
> double free and renames the error labels to keep the origin function
> unchanged.
> 
> Fixes: b8447abc4c8fb ("r8169: factor out rtl8169_tx_map")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index f704da3f214c..91c43399712b 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4217,13 +4217,13 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>  
>  	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
>  				    entry, false)))
> -		goto err_dma_0;
> +		goto err_dma_1;
>  
>  	txd_first = tp->TxDescArray + entry;
>  
>  	if (frags) {
>  		if (rtl8169_xmit_frags(tp, skb, opts, entry))
> -			goto err_dma_1;
> +			goto err_dma_2;
>  		entry = (entry + frags) % NUM_TX_DESC;
>  	}
>  
> @@ -4270,10 +4270,11 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>  
>  	return NETDEV_TX_OK;
>  
> -err_dma_1:
> +err_dma_2:
>  	rtl8169_unmap_tx_skb(tp, entry);
> -err_dma_0:
> +err_dma_1:
>  	dev_kfree_skb_any(skb);
> +err_dma_0:
>  	dev->stats.tx_dropped++;
>  	return NETDEV_TX_OK;
>  
> 

