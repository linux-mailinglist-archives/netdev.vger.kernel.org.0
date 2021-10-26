Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225BC43A971
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhJZAx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233234AbhJZAx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 20:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635209464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tKLugvAaWnuPS5GFB24O2qm4lnwESzjzWelpJYyk+To=;
        b=DG8JtNdKrzBDtuC127EgHoEn/Bk/OUG3s4xgL5N1pLSlcQd6ujLPp/lV3Pl+r1+/XO6AeR
        ZNqzKQ7+fFpHkv2S+c+AEXGH9V0UGxBJZsy6601zosIprAfjVuIR8gnfLW5+rAID6VCNKl
        7rf823tCjHQpUWeX5MleHt4jt+/AZ9M=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-gtRrC7X4PEaY5CjRbteLrw-1; Mon, 25 Oct 2021 20:51:03 -0400
X-MC-Unique: gtRrC7X4PEaY5CjRbteLrw-1
Received: by mail-qk1-f197.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so10390694qkd.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 17:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tKLugvAaWnuPS5GFB24O2qm4lnwESzjzWelpJYyk+To=;
        b=iI46sDQqxkd6Vjf1q1HMGi+u4nFYlMxfoj0oZcQxPohbsubTMdALTvZxI63tCvpLQd
         Lsye6xb3h3w3oxQ5rJ/xNUbhW3VklrO9JfMGYRlfYiBTMS5WJyXxR+CZ0CYghR9+oEmR
         xIOgDcMnAs0gSLUr+GQdW7+rztL3iHR99M6LOfik5jeYpS8aKZ0HBEkeGp4V4dBQgyUI
         h6fQWRhMNGItvtAsPvxsAQdBLeB49Bdc6/8kYQw7fZqAhceaUaRk0m+Pso0M1EVDm2GQ
         YdVtnPrtGYCIpuWoCmU1QJMCpalbS2RyhC77opIiIFs79WFTZsIxRFPa2QDYGrQFJVg8
         zHYQ==
X-Gm-Message-State: AOAM533ITq6/9dMuwUvcuPhdUvzWMW3M1f3ODbds/adCJ9APcMF8D1xq
        kJjMTl0vBsV27NtkigApiZ07Iw85s/Dz3/KRRMARNCf+A6I78F+efzFAxO2d2OTrHIw9ephU5MT
        N7LYYUhxEOKiQkzu2
X-Received: by 2002:a05:622a:315:: with SMTP id q21mr21324875qtw.87.1635209462946;
        Mon, 25 Oct 2021 17:51:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVqasP05wBOjZ6+tpuyXlzC/xEV9iDrkZgoUboVrS5E4s/mAsb4h2mCivZ5GVCwy1w5SduSA==
X-Received: by 2002:a05:622a:315:: with SMTP id q21mr21324859qtw.87.1635209462741;
        Mon, 25 Oct 2021 17:51:02 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id q13sm356365qkl.7.2021.10.25.17.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 17:51:02 -0700 (PDT)
Message-ID: <3def567a-5f99-970d-f9e4-3b9426809b16@redhat.com>
Date:   Mon, 25 Oct 2021 20:53:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] tipc: fix size validations for the MSG_CRYPTO type
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        Max VA <maxv@sentinelone.com>,
        Ying Xue <ying.xue@windriver.com>
References: <YXbN6S9KPq8S5N0v@kroah.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <YXbN6S9KPq8S5N0v@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Jon Maloy <jmaloy@redhat.com>

On 10/25/21 11:31, Greg KH wrote:
> From: Max VA <maxv@sentinelone.com>
>
> The function tipc_crypto_key_rcv is used to parse MSG_CRYPTO messages
> to receive keys from other nodes in the cluster in order to decrypt any
> further messages from them.
> This patch verifies that any supplied sizes in the message body are
> valid for the received message.
>
> Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
> Signed-off-by: Max VA <maxv@sentinelone.com>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/tipc/crypto.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
>
> Max's email system doesn't seem to be able to send non-attachment
> patches out, so I'm forwarding this on for him.  It's already acked by
> one of the tipc maintainers.
>
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index c9391d38de85..dc60c32bb70d 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -2285,43 +2285,53 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
>   	u16 key_gen = msg_key_gen(hdr);
>   	u16 size = msg_data_sz(hdr);
>   	u8 *data = msg_data(hdr);
> +	unsigned int keylen;
> +
> +	/* Verify whether the size can exist in the packet */
> +	if (unlikely(size < sizeof(struct tipc_aead_key) + TIPC_AEAD_KEYLEN_MIN)) {
> +		pr_debug("%s: message data size is too small\n", rx->name);
> +		goto exit;
> +	}
> +
> +	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
> +
> +	/* Verify the supplied size values */
> +	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
> +		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
> +		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
> +		goto exit;
> +	}
>   
>   	spin_lock(&rx->lock);
>   	if (unlikely(rx->skey || (key_gen == rx->key_gen && rx->key.keys))) {
>   		pr_err("%s: key existed <%p>, gen %d vs %d\n", rx->name,
>   		       rx->skey, key_gen, rx->key_gen);
> -		goto exit;
> +		goto exit_unlock;
>   	}
>   
>   	/* Allocate memory for the key */
>   	skey = kmalloc(size, GFP_ATOMIC);
>   	if (unlikely(!skey)) {
>   		pr_err("%s: unable to allocate memory for skey\n", rx->name);
> -		goto exit;
> +		goto exit_unlock;
>   	}
>   
>   	/* Copy key from msg data */
> -	skey->keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
> +	skey->keylen = keylen;
>   	memcpy(skey->alg_name, data, TIPC_AEAD_ALG_NAME);
>   	memcpy(skey->key, data + TIPC_AEAD_ALG_NAME + sizeof(__be32),
>   	       skey->keylen);
>   
> -	/* Sanity check */
> -	if (unlikely(size != tipc_aead_key_size(skey))) {
> -		kfree(skey);
> -		skey = NULL;
> -		goto exit;
> -	}
> -
>   	rx->key_gen = key_gen;
>   	rx->skey_mode = msg_key_mode(hdr);
>   	rx->skey = skey;
>   	rx->nokey = 0;
>   	mb(); /* for nokey flag */
>   
> -exit:
> +exit_unlock:
>   	spin_unlock(&rx->lock);
>   
> +exit:
>   	/* Schedule the key attaching on this crypto */
>   	if (likely(skey && queue_delayed_work(tx->wq, &rx->work, 0)))
>   		return true;

