Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E21455020
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241022AbhKQWGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240924AbhKQWGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637186627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UM3rOln8kBcAURl+w/UPvP+woZK+h5DIoF92PXfCfdQ=;
        b=A9EkBiBsYgbYeMpc3cMEg8y0HwGyFAEYhTtWpp7yGnGNazZmr+MNcL4qEvISdgF4X3lFuJ
        ZzA4sXHZczv9NGs+m3MPuUBBNR+We7p30qNgeT1Eh2r3jJ1cc/upMcuRtIeFIDWQ3ZLlsR
        fupRH/VIidjzM8ZSSAbKdE5caUqR6iI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-efY2qvC-Pt64TDu3ZIbEdA-1; Wed, 17 Nov 2021 17:03:46 -0500
X-MC-Unique: efY2qvC-Pt64TDu3ZIbEdA-1
Received: by mail-qk1-f199.google.com with SMTP id bk21-20020a05620a1a1500b004631b196a46so3102977qkb.4
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 14:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UM3rOln8kBcAURl+w/UPvP+woZK+h5DIoF92PXfCfdQ=;
        b=aC1LDQzfAooK9IuFcPcKGB4LdKpL9+T3qEInJlVj1Ys9LYev65e5V6rAQ3TMZjM3lD
         bzL8MbMKZIE42AuyQkF4qSOG6/BfcugP/UFzQz92R0pHPqYcp+R7MQPhdL432FYjT9/f
         fXSk6GrfqYLvtgP8ucb+obKHJBZqWSHISVqdRDmRItO0cV8zyAF44+vsVN60X03LDFVP
         dhwZUTh25wFFjPNkRTxAPMe9QtorZMKgqw/fYo/FCZmcTzZF8pBwbAWy4K9FJA/dhggC
         ll50/eexOuKRdFtyoNSJ9qzlEK81kNSzntjGve1Y+HjFnDYakqRDzQHwHhEa7eZQ7/UD
         jYRw==
X-Gm-Message-State: AOAM532x0/sjKscMeX5K9VhcELKgX8nPKs74SVUQKs8OgkiiqFXWz+dk
        erT/8LCDLBpHEbfuT7WEgVLddQV1wXV0litVCG4bq84P6mnqWFmE5luTZwIqbTcUcUdJckfPiGV
        9jLrcOarG6O3tHsi9
X-Received: by 2002:ac8:5c53:: with SMTP id j19mr21301629qtj.40.1637186625533;
        Wed, 17 Nov 2021 14:03:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKbmfhLXEcjpNEixYPWQ886lMm649m9jzw2P56FDGKONoExY3utbgtPOsfA1loXEghxgDNQQ==
X-Received: by 2002:ac8:5c53:: with SMTP id j19mr21301599qtj.40.1637186625332;
        Wed, 17 Nov 2021 14:03:45 -0800 (PST)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id w10sm691272qkp.121.2021.11.17.14.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:03:44 -0800 (PST)
Message-ID: <0aea60c5-28d5-258a-3a32-bae1895a96ee@redhat.com>
Date:   Wed, 17 Nov 2021 17:06:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] tipc: check for null after calling kmemdup
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, davem@davemloft.net
Cc:     Ying Xue <ying.xue@windriver.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
References: <20211115160143.5099-1-tadeusz.struk@linaro.org>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20211115160143.5099-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Jon Maloy <jmaloy@redhat.com>

On 11/15/21 11:01, Tadeusz Struk wrote:
> kmemdup can return a null pointer so need to check for it, otherwise
> the null key will be dereferenced later in tipc_crypto_key_xmit as
> can be seen in the trace [1].
>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: tipc-discussion@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10
>
> [1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58
>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> Changed in v2:
> - use tipc_aead_free() to free all crytpo tfm instances
>    that might have been allocated before the fail.
> ---
>   net/tipc/crypto.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index dc60c32bb70d..d293614d5fc6 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -597,6 +597,10 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
>   	tmp->cloned = NULL;
>   	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
>   	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
> +	if (!tmp->key) {
> +		tipc_aead_free(&tmp->rcu);
> +		return -ENOMEM;
> +	}
>   	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
>   	atomic_set(&tmp->users, 0);
>   	atomic64_set(&tmp->seqno, 0);

