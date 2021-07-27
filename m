Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135BB3D7AA1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhG0QM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhG0QMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:12:25 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC881C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:12:25 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 185so16570476iou.10
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=En0pdER263cW6I9Y+7h6JpCEP6J2OKalf20rLcFu4hw=;
        b=rerItmmL4CKodwYIafStYT4zF7z73d3RgcBSRv8LtW2EnRunsia41t9bVwn2NwtnLM
         pM4nAXq54xzf9jLI/WzVR7+tNBGqI0q0Hp6j1V1fEEjsr8lihfJz8D4LKSbreh+EGxGo
         Saml+Kzhb0cwVvVrDzFtVoromXzZmtsUqiwXvAQvwDvNzvPS0XVw57wDUVUvDMPkru1l
         DfayMQXgkb4T0KmxHK4xu3NWQd74BtyfTI9DaV+YqD4eD5XuoJvDq8VSrNADgc4IpJ2Z
         YCB/f45C+BnXGXZCyTHFvyFoiN8Ez3Z2vx6jeqegFfPLPHtyTMpRU1L8eY1a24JnzvJw
         dmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=En0pdER263cW6I9Y+7h6JpCEP6J2OKalf20rLcFu4hw=;
        b=H/5tqTriDQQPhNFYZl04I0aozl0OW+7ZXkjn4yYQM7yUXN7py/3VPH9M9Ch+klZ5Ms
         liPLTZIbN24PbaESvDd/4dIf7tStZwc/HOMwYhPxkMobFtGZGRfJ3xFCy8SiiNFCO4pv
         rrLUnJ+ax8X6JNX4GHwwemhH4htfgRe4SC8b1Kr+IyCKRTQBDbSnV92QuYSRdSMZ2dBi
         1p8YsN4GqLIiR1mH3mZuWilyOukJfDqZwxzpZ0IB6TTivmGZC0xzrREfktjWOGcGgg9z
         x74+/y4iRfxeM4tY/o6PKTNv36qr0aCMA/TwEKmBVRdcBNKEcX4KFT2NS/ngaAhvyvuy
         bCFQ==
X-Gm-Message-State: AOAM532j331LeSSN9HaDp5djoPU+uZddZLxLKo/nU/2W9WQm+GyyleNp
        1GI6N3kU9A+3SvDpSpV2V7Y=
X-Google-Smtp-Source: ABdhPJyA4/8us+YIsNAs6wih0jaAnQG2bl2G+A2X0yM2hv9wp37p/1yPp1nHxcUrDWL2v2CZftQqTw==
X-Received: by 2002:a05:6602:249a:: with SMTP id g26mr19406362ioe.150.1627402345081;
        Tue, 27 Jul 2021 09:12:25 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id k4sm2488361ior.55.2021.07.27.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:12:24 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:12:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <610030612aaa3_199a412083d@john-XPS-13-9370.notmuch>
In-Reply-To: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
References: <20210723183630.5088-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] unix_bpf: fix a potential deadlock in
 unix_dgram_bpf_recvmsg()
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
> As Eric noticed, __unix_dgram_recvmsg() may acquire u->iolock
> too, so we have to release it before calling this function.
> 
> Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/unix/unix_bpf.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index db0cda29fb2f..b07cb30e87b1 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -53,8 +53,9 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  	mutex_lock(&u->iolock);
>  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
>  	    sk_psock_queue_empty(psock)) {
> -		ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> -		goto out;
> +		mutex_unlock(&u->iolock);
> +		sk_psock_put(sk, psock);
> +		return __unix_dgram_recvmsg(sk, msg, len, flags);
>  	}

Is there a reason to grab the mutex_lock(u->iolock) above the
skb_queue_emptyaand sk_psock_queue_empty checks?

Could it be move here just above the msg_bytes_ready label?

>  
>  msg_bytes_ready:
> @@ -68,13 +69,13 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		if (data) {
>  			if (!sk_psock_queue_empty(psock))
>  				goto msg_bytes_ready;
> -			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> -			goto out;
> +			mutex_unlock(&u->iolock);
> +			sk_psock_put(sk, psock);
> +			return __unix_dgram_recvmsg(sk, msg, len, flags);
>  		}
>  		copied = -EAGAIN;
>  	}
>  	ret = copied;
> -out:
>  	mutex_unlock(&u->iolock);
>  	sk_psock_put(sk, psock);
>  	return ret;
> -- 
> 2.27.0
> 
