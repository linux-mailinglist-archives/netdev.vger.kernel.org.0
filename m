Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2170E1147B4
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 20:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfLETeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 14:34:23 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40883 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfLETeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 14:34:22 -0500
Received: by mail-lf1-f66.google.com with SMTP id y5so3384232lfy.7
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 11:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HOF5G9qgWC4dJfxrWQ2lROjBvucxvYFOJhe3eJU34R4=;
        b=kgIfiUIEb6kHLBnQNu3ixiIIg2vRiiTZuWa5n5p0f3P/9BU7ZUZOkuXKi9kXMoiapc
         l4Ey1iB3O5ZsSa1Q8p04lP4KewQEoKZcBj2sXNP8sK2yWNH4fc1tpnSUIwvvu3WfmZNA
         0SIFUnkO4gVNb7ZKJLeq6HINI9VHfireQJDgQafqwm1kHz4Bq/kCZJJQf4IVDuHy0Q5R
         U/jVQfScZULqoEXNO17fiiakAq0MnRYxEsEw4PKWkOfppzjavnqCaWagy+OWHQlm+oXO
         rkDula/i64Y1eYYMCv21Mre1eR+Gu1M4eb0wsfMRkqRZhNqGdKWr2gy1gM86+gaF9Ccy
         U79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HOF5G9qgWC4dJfxrWQ2lROjBvucxvYFOJhe3eJU34R4=;
        b=cGJZ91MfUR1l25NsLpERn6u7ItDuPobcDxeF7lUhUc1AnbjSNHZWLH1VQoOPnDFo6G
         tUJOWEleWM3t+5TZJmkmVjokeNfcx+IpS4zewBRoP5Pdfp2HT0hSmo5yTaTW0mrXlNOw
         C+IIbQARDARI/oPpzN7L+Q3zC627DcJMbDNMnOYXF+Qz74xWY9vDa1xts8e+ASoJJHEA
         NKU7Mg+abR8742I7XMTTPnKCWHVt1m8HP++0rZkrWk92kpN2Th3yWgJtdLdpavaxcsnn
         ONM1oci33mzbR7TvZDCSe+Au+45YXjd4YGCqSAWaOW2QqDnbZNEm6XY02Uqp7K3Er9pw
         9idQ==
X-Gm-Message-State: APjAAAXqTGGjNEwuyL4zyCYE91HSTrVfLqlZmqGef27PpA1Gz7/NBqu4
        X0xqi0ZpEReNwLFEksnxOJEQVg==
X-Google-Smtp-Source: APXvYqxiQTCp3BRErfEYQF98tRym70z6mlQ3nceZaIQ9oCcbJsIjhi1HtTDd9SwfXG0YSKEkg5tuXA==
X-Received: by 2002:ac2:455c:: with SMTP id j28mr6419747lfm.184.1575574460288;
        Thu, 05 Dec 2019 11:34:20 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t9sm5406063lfl.51.2019.12.05.11.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 11:34:20 -0800 (PST)
Date:   Thu, 5 Dec 2019 11:34:11 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
Message-ID: <20191205113411.5e672807@cakuba.netronome.com>
In-Reply-To: <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
        <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Dec 2019 07:41:18 +0100, Valentin Vidic wrote:
> ENOTSUPP is not available in userspace, for example:
> 
>   setsockopt failed, 524, Unknown error 524
> 
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 0683788bbef0..cd91ad812291 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -429,7 +429,7 @@ static int tls_push_data(struct sock *sk,
>  
>  	if (flags &
>  	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (unlikely(sk->sk_err))
>  		return -sk->sk_err;
> @@ -571,7 +571,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>  	lock_sock(sk);
>  
>  	if (flags & MSG_OOB) {
> -		rc = -ENOTSUPP;
> +		rc = -EOPNOTSUPP;

Perhaps the flag checks should return EINVAL? Willem any opinions?

>  		goto out;
>  	}
>  
> @@ -1023,7 +1023,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
>  	}
>  
>  	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
> -		rc = -ENOTSUPP;
> +		rc = -EOPNOTSUPP;
>  		goto release_netdev;
>  	}
>  
> @@ -1098,7 +1098,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
>  	}
>  
>  	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
> -		rc = -ENOTSUPP;
> +		rc = -EOPNOTSUPP;
>  		goto release_netdev;
>  	}
>  
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index bdca31ffe6da..5830b8e02a36 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
>  	/* check version */
>  	if (crypto_info->version != TLS_1_2_VERSION &&
>  	    crypto_info->version != TLS_1_3_VERSION) {
> -		rc = -ENOTSUPP;
> +		rc = -EINVAL;

This one I think Willem asked to be EOPNOTSUPP OTOH.

>  		goto err_crypto_info;
>  	}
>  
> @@ -723,7 +723,7 @@ static int tls_init(struct sock *sk)
>  	 * share the ulp context.
>  	 */
>  	if (sk->sk_state != TCP_ESTABLISHED)
> -		return -ENOTSUPP;
> +		return -ENOTCONN;
>  
>  	/* allocate tls context */
>  	write_lock_bh(&sk->sk_callback_lock);
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index da9f9ce51e7b..2969dc30e4e0 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -900,7 +900,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  	int ret = 0;
>  
>  	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	mutex_lock(&tls_ctx->tx_lock);
>  	lock_sock(sk);
> @@ -1215,7 +1215,7 @@ int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
>  	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
>  		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
>  		      MSG_NO_SHARED_FRAGS))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	return tls_sw_do_sendpage(sk, page, offset, size, flags);
>  }
> @@ -1228,7 +1228,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
>  
>  	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
>  		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;

Same suggestion for flags checks in tls_sw.c

>  
>  	mutex_lock(&tls_ctx->tx_lock);
>  	lock_sock(sk);
> @@ -1927,7 +1927,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>  
>  		/* splice does not support reading control messages */
>  		if (ctx->control != TLS_RECORD_TYPE_DATA) {
> -			err = -ENOTSUPP;
> +			err = -EINVAL;
>  			goto splice_read_end;
>  		}
>  

