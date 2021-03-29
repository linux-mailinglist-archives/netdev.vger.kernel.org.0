Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FAD34D87E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhC2TpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhC2Tow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:44:52 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1EFC061574;
        Mon, 29 Mar 2021 12:44:52 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id f5so3311202ilr.9;
        Mon, 29 Mar 2021 12:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+k9+ub7sCNRUSa5LA0jmZ8uchMMnOBBkoeHvdAd4VhI=;
        b=H5nSDS8rbVstqy9mjHvczPgmXCbQqh9IrqZkX33e/CX6/MIH9f//BLDdDLmz5jfN++
         Au5Az60H7akGqsS360HWQ97Z03w24q4af6bM4QSdlL7LrVJ3J7J7XbL8OtlEhmWkU/h8
         fOvj2qgbzpZHHdxgGMf7YGDXpdTIM7M1vOyXPOVJye624FCF5ulSS7zZxGc1iB4Zt5kt
         VkVtSvQA0GjDrxCj4WVGsTAIFEY0PBbQcnyq+BNSGzTNp0GgLgTg0gtExf0i6arTi8FW
         P1Q7TSXfRDDHGKjDd4YyuPiDcraWyYge+cl+AKYyEkS/JI9IybrJujbW9kGCMUcWsD6C
         BaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+k9+ub7sCNRUSa5LA0jmZ8uchMMnOBBkoeHvdAd4VhI=;
        b=gvQyHwOlNW9C9qzyS0UxAscd15nCyvWKjPK/6nicUC/1lCKx3LUAq7UvmTsWO+fnYq
         JtNQHYkepSIH+IK373YuRoMiZdDdBG6X9ec3sDK8PlRz2y/onzYDVR7JeP4udUudoa0t
         xsZEUuSFHXC3pnX+/k9a6ddbILc+LUCyuG4PYjIjo2hpKVC7Ttti1d0L9mUPGt7NdcOh
         o1n8GMaCU19z99P3MLpUizhuDKTkF9GOdN8yxyOju3ct9KdgGR6TibvWP9zX422VrXUH
         Bsu74rhLPscedHp95QRFj9GPmxCzG1+CIIpKc+MzW93VQy7ejqxZUnM5xjSdV/qaKmrQ
         UjpQ==
X-Gm-Message-State: AOAM533okc4QTrzP35QPDKHpTw0JtcgT7TVmHx7NTBbeDlAT8iK8wsXJ
        aHDTQC3WxGDBTa9qZjC1+1k=
X-Google-Smtp-Source: ABdhPJxSkyBt40FNGPV/Nku52WaBiC6m16jcVmklv6TYNtEDsRZPLRGhYHPn2+7C/6eeY6oYIdo+ew==
X-Received: by 2002:a92:c52f:: with SMTP id m15mr12851586ili.289.1617047091970;
        Mon, 29 Mar 2021 12:44:51 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id a10sm5654302ilk.71.2021.03.29.12.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:44:51 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:44:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60622e2d9cf16_401fb208c0@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-7-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-7-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 06/13] skmsg: use GFP_KERNEL in
 sk_psock_create_ingress_msg()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This function is only called in process context.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/skmsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index d43d43905d2c..656eceab73bc 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -410,7 +410,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
>  	if (!sk_rmem_schedule(sk, skb, skb->truesize))
>  		return NULL;
>  
> -	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
> +	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
>  	if (unlikely(!msg))
>  		return NULL;
>  
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
