Return-Path: <netdev+bounces-10306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B736872DBCD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE74D2810E4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180FC567E;
	Tue, 13 Jun 2023 07:59:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A8C323C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:59:03 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CF61FC7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:58:34 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f7373b5499so8625455e9.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686643092; x=1689235092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9VnTBxUfbgN/9foJR6iyloks5c6wdugCZ7HhQe+r5I=;
        b=Oree4cdc+XXZh3J1ICBqso064gYkq6ZCVR3tDNzVZLxzB9LzVazj2IA6I64+8w2iG3
         73dc81PUW+Cxc2TVyNsQ2cA53WzzK4Dky6EjD+uWss77Znc8PWO4QdkZj4UB9SvFVKuQ
         vsDVJRlNURdCyipQDGpHjG58JCvjOsorQ2YAwln85zSLVzW6M5gYfj62QFNwbKN30/Dl
         zoQ23+cxdYvnsaKaMFz0yDJfg7DIVCp3zW2iiPcqmMD8KGjP/6qzKPuXXDTkH9VMV3Db
         QLbu/Kyf4+5rolVpq+JV8vJYJmjb4Z5ruFhc8T2tQUIpqXT7w0DAGCq/xAVsWlUntGoR
         +Z9w==
X-Gm-Message-State: AC+VfDwpHfqr80muHO/9kLhmPehVo0QBTwO30RR+jTLxwwU4BbYIz2da
	zhd6KfKw1s4xKGgVzAME/fs=
X-Google-Smtp-Source: ACHHUZ4uQhNINzWeLB440wOoJ04ma4DPbOWLtoFzjj9Srpn71qsS4k1OHoP+F5t5b5pbI0jiEsOBFQ==
X-Received: by 2002:adf:f581:0:b0:30e:460b:bede with SMTP id f1-20020adff581000000b0030e460bbedemr7574011wro.5.1686643092260;
        Tue, 13 Jun 2023 00:58:12 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id o16-20020a1c7510000000b003f7e6d7f71esm13611058wmc.36.2023.06.13.00.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 00:58:11 -0700 (PDT)
Message-ID: <f560c8fa-d6a1-7bd2-3fd7-728f90207322@grimberg.me>
Date: Tue, 13 Jun 2023 10:58:10 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/4] net/tls: handle MSG_EOR for tls_device TX flow
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20230612143833.70805-1-hare@suse.de>
 <20230612143833.70805-3-hare@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230612143833.70805-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/12/23 17:38, Hannes Reinecke wrote:
> tls_push_data() MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails
> out on MSG_EOR.
> But seeing that MSG_EOR is basically the opposite of
> MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
> MSG_EOR by treating it as the absence of MSG_MORE.
> Consequently we should return an error when both are set.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   net/tls/tls_device.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index a7cc4f9faac2..0024febd40de 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -448,10 +448,6 @@ static int tls_push_data(struct sock *sk,
>   	int copy, rc = 0;
>   	long timeo;
>   
> -	if (flags &
> -	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
> -		return -EOPNOTSUPP;
> -
>   	if (unlikely(sk->sk_err))
>   		return -sk->sk_err;
>   
> @@ -529,6 +525,10 @@ static int tls_push_data(struct sock *sk,
>   				more = true;
>   				break;
>   			}
> +			if (flags & MSG_EOR) {
> +				more = false;
> +				break;
> +			}
>   
>   			done = true;
>   		}
> @@ -573,6 +573,14 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>   	union tls_iter_offset iter;
>   	int rc;
>   
> +	if (msg->msg_flags &
> +	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_EOR))
> +		return -EOPNOTSUPP;
> +
> +	if ((msg->msg_flags & MSG_MORE) &&
> +	    (msg->msg_flags & MSG_EOR))
> +		return -EOPNOTSUPP;

EINVAL is more appropriate I think...

> +
>   	mutex_lock(&tls_ctx->tx_lock);
>   	lock_sock(sk);
>   
> @@ -601,9 +609,17 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>   	struct kvec iov;
>   	int rc;
>   
> +	if (flags &
> +	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST | MSG_EOR))
> +		return -EOPNOTSUPP;
> +
>   	if (flags & MSG_SENDPAGE_NOTLAST)
>   		flags |= MSG_MORE;
>   
> +	if ((flags & MSG_MORE) &&
> +	    (flags & MSG_EOR))
> +		return -EOPNOTSUPP;

EINVAL?

