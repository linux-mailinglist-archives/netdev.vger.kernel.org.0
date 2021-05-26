Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8CA390F4F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhEZEYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhEZEYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:24:18 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395DAC061574;
        Tue, 25 May 2021 21:22:48 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h15so27404638ilr.2;
        Tue, 25 May 2021 21:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lYjEjq2CeERrjfTH2MU7B9d6sbjc0bVXhNKk7CXEuuM=;
        b=S40drgnAc5PJjkSjV7OpeZ9qKI2aBZr/Xwm948kcAfKEu6JrpyoLlO+uhB6E0WbRHI
         ilggkvHZfRLmFQf4cH3OE2BATTIo6fvP8d0zo3idL4Yfc+UKvUAy/fA+Jp1QjJw8g/7q
         rt4nFw7BIdMCtKyCw1s1d7vyMaqAO2eWSJDsOIsxJDk+F2kEO8PWgYGE5ISMsakPN9Wz
         EWEng7NRn2PLVsVxSwGEDd6dbKwI/rO75aJWN/Ex+QLjaozd8OyW2RuirQIm0O//aHoh
         jdXX/oZ1/35MbzLjZm1hd9SqAADOTlc23aHdNcSfeaF18EZfrO0z9GQtYBZ1JqEJm6jM
         mEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lYjEjq2CeERrjfTH2MU7B9d6sbjc0bVXhNKk7CXEuuM=;
        b=r5N2L5aYo0Ss66Hmdi/I1OfFPvJ3RyIdcxlj24tpVADXRZVgDh9cygst5eZ4H4erWI
         KE3ZpBM4lRJa1MZGlIB2hicfuapbYj8Lcvb4dc4D3gpGtyYvAr1V5sETZUSIsQM8FTNn
         W1AO36lXxlkXrYV6jTLDWAIv8D7iEeGaRSDG3YIp2o5H+JUSKdiYz7Vkokyvug2S64Ma
         XdlowH9AHHbz04sKX+pXk8d+QlzYr40wJKDJOfS4qDkuDtglhE3ZxcA0dsE1N9wn26He
         WFSbV90w8vPbogziPyW6G+XJgBjkIAcidTs3sdCP1KAfDiFheoUUToJlM4MHuGoEqrN0
         e4rA==
X-Gm-Message-State: AOAM532eCXR2PkGx/T0mXU2AlDKud/x0acvkL6LUiPx5knbbRufHcLX6
        jqn/aXBXwd+BozxAkE6tAqg=
X-Google-Smtp-Source: ABdhPJwukZ4u5y0BjeQYQaL1LNT8LqZn1WGbZn6FYj/IPQnuUEDFe3tQ3pWal+MEjyX4Lz1kee7RNw==
X-Received: by 2002:a05:6e02:1204:: with SMTP id a4mr28264414ilq.158.1622002967434;
        Tue, 25 May 2021 21:22:47 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id p10sm13168893ios.2.2021.05.25.21.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 21:22:46 -0700 (PDT)
Date:   Tue, 25 May 2021 21:22:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60adcd0ec9aa_3b75f208f0@john-XPS-13-9370.notmuch>
In-Reply-To: <20210522191411.21446-8-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
 <20210522191411.21446-8-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v2 7/7] skmsg: increase sk->sk_drops when dropping
 packets
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
> It is hard to observe packet drops without increase relevant
> drop counters, here we should increase sk->sk_drops which is
> a protocol-independent counter. Fortunately psock is always
> assocaited with a struct sock, we can just use psock->sk.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

[...]

>  static void sk_psock_backlog(struct work_struct *work)
>  {
>  	struct sk_psock *psock = container_of(work, struct sk_psock, work);
> @@ -617,7 +623,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  				/* Hard errors break pipe and stop xmit. */
>  				sk_psock_report_error(psock, ret ? -ret : EPIPE);
>  				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> -				kfree_skb(skb);
> +				sock_drop(psock->sk, skb);
>  				goto end;
>  			}
>  			off += ret;
> @@ -625,7 +631,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  		} while (len);
>  
>  		if (!ingress)
> -			kfree_skb(skb);
> +			sock_drop(psock->sk, skb);

This is not a dropped skb this was sent via skb_send_sock().

The rest LGTM thanks.
