Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472F3443BB0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhKCDJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhKCDJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:09:22 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15ABC061203;
        Tue,  2 Nov 2021 20:06:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so1654969ote.8;
        Tue, 02 Nov 2021 20:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i5D64TfyrAvrxwhd90ZrsbSzk93mZsSmsculp94NFPY=;
        b=EEUbPEFnizI3vk7rX/JADCRBBrhLk8LhzL72RLeS01+3x2ATflkg84ry44PnCtYzaG
         cGieZ6xGoeDhYOzLjri+E20o7prewe0dUtA6KxcqgExyGI0lQPooGrIb0F+UnJtAjfTr
         wC77D3DuVgPrijp2FjqzdzAAk31fs+KroFPa32jjFx9CShAcFYxaYflyqYX+hOkXG2In
         e9vSO7Ebj3HKrZGmso3PNnA06xqFeXp/bm4cDgVw38PExmKBlBgGeQgP+1mi9T85L5jI
         F7JfAolc8Q16yKfnPMmnKfrM6kyvgIjVhqQZv7OwI+/QiSK+O0KwTkwLXvKd0rbdOJuE
         3HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i5D64TfyrAvrxwhd90ZrsbSzk93mZsSmsculp94NFPY=;
        b=ecwea65W8/6fWHeiDQKjUV7EkYV+U/Y8HSyFPWoju5SGwe+KgP0XNELlVmpiaip1BU
         ruQbfxhTiJKoPtmHwAIBYxLFWLaQYvV/Q02KTVgTEUsUTBrrw2vVG+AJ2651AodsBW7I
         E3JjWrJMlq4Gs8QZIDljwjIGgFcrM7FP6ohTaXEBTwLzBoPhPZ1MUab6ESAUfRykP4nK
         D6DYtqA5vTWIQX5bh7j2gFNsPzp5FcKYCWKKZ84fL0cJXIX4oSqwANhcIcmLkKVTX5M0
         ZD/DiQpJE0Ub7RZg7XME7R3MwIF2KsHFvBA4BLnRJswu49BH2PqbUiOebC+d0NNPwHDL
         +EdQ==
X-Gm-Message-State: AOAM5324u75NXFhC+EcQboYtWL9bwF8Umc5LAgOq4eIToKxgSBONAryL
        5vk3JEQ+24NPZbtNnEGaW3U=
X-Google-Smtp-Source: ABdhPJx8hPIQDa+PCMT6YSNUS259orVc6ilILTqUNLncbBalUTQbcy8Ctq0uzAC7B0hRroQcjaypUw==
X-Received: by 2002:a9d:825:: with SMTP id 34mr1137042oty.305.1635908806152;
        Tue, 02 Nov 2021 20:06:46 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s26sm228629otq.14.2021.11.02.20.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:06:45 -0700 (PDT)
Message-ID: <e08a7554-bd3e-e524-830d-64b76853ace2@gmail.com>
Date:   Tue, 2 Nov 2021 21:06:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 21/25] tcp: authopt: Add initial l3index support
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <4e049d1ade4be3010b4ea63daf2ef3bed4e1892b.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <4e049d1ade4be3010b4ea63daf2ef3bed4e1892b.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> @@ -584,10 +614,24 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>  		return -EINVAL;
>  	err = tcp_authopt_alg_require(alg);
>  	if (err)
>  		return err;
>  
> +	/* check ifindex is valid (zero is always valid) */
> +	if (opt.flags & TCP_AUTHOPT_KEY_IFINDEX && opt.ifindex) {
> +		struct net_device *dev;
> +
> +		rcu_read_lock();
> +		dev = dev_get_by_index_rcu(sock_net(sk), opt.ifindex);
> +		if (dev && netif_is_l3_master(dev))
> +			l3index = dev->ifindex;
> +		rcu_read_unlock();

rcu_read_lock()... rcu_read_unlock() can be replaced with
netif_index_is_l3_master(...)

