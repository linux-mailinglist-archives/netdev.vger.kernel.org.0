Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB0434339A
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCURGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCURG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:06:28 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B334CC061574;
        Sun, 21 Mar 2021 10:06:28 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so13634746otn.1;
        Sun, 21 Mar 2021 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=14zWWAJneppaL5NOdrQtrcBVTmwfOhcTLhxNt18wLZg=;
        b=J7C7jthk8allXdR9K2gqP7e84nohTadivN5MqCtA+C+j9yMQLZzecsdEasX5rjuC2i
         nvVDneEGq67Qde+oebdpDgrPA0GL9Lxz2t8vyJ0gPgmPpzR2e4+u/AlDfjq5XB0hD+fU
         3vycv3myRabxuL2YDDgRiX/qFkoRZitWL7vARwEfX+gXVJS1KQ9qExATIPh5E+Hcevs+
         Q8wFYddaW4W4FQndr01xu8x8F9X7qS3G9hWeurRPVutw/3Zq3fxPGaKFv+wxD8GV/VlH
         6Bp+3Ou1UcBnCBmyHyoWe0sF59ZHdTEV/M4RW3hAhLE0Kvf+x9eLdQYI/wHRjCdEaEKg
         WE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=14zWWAJneppaL5NOdrQtrcBVTmwfOhcTLhxNt18wLZg=;
        b=QJZ+uufcMcW/vyA9UeCtEmOrqP9S9YyC9iH1ZMzWpCHJD9hPsWyck8DJwL0HLSJ8lO
         UBHieB976EgLe5bTL6DtFBIRDLwNd+cCW+bZfiIhLVe8xVRYNcpx6iBabTIiOYmAB5W4
         lOetgx8RNWIP6e9SGELxu+D3wEoUve6AIxA+aEgBSOQ5TALrN5JciiRIVy8OVdzh/vrH
         EDkbftyPRpUByHtonDPb7sN97yqJjgEkP2N4zTBfSt3bkSMPYvmzN4LQKsdOAe/ajJng
         LmfA5O0OLxoYXDRdVmfh0EtB+GzIOhjTqM9Jcya+youzKDLV/IgMpjayrjIIXs35pzsm
         2H5w==
X-Gm-Message-State: AOAM533Vua/jaRyhG7Un6ZNVG/3c0i2qsSIafg2z1rHaMlw8jvneqtn4
        H/SMBna35lJVwVLhQkh7bcGdFPgPohM=
X-Google-Smtp-Source: ABdhPJwb3Vj/QetxfzTFLKUSy27JgBKSV+/QIcQyig0tW4f/7/872ECsaqU0sThmZCOuLPkkZvYYyg==
X-Received: by 2002:a9d:1c7:: with SMTP id e65mr8565494ote.259.1616346387978;
        Sun, 21 Mar 2021 10:06:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:15d7:4991:5c5e:8e9d])
        by smtp.googlemail.com with ESMTPSA id 24sm2652127oij.58.2021.03.21.10.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 10:06:27 -0700 (PDT)
Subject: Re: [PATCH] ipv4/raw: support binding to nonlocal addresses
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210321002045.23700-1-pbl@bestov.io>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad051ee7-faaf-af4e-9a72-6315fedf63c5@gmail.com>
Date:   Sun, 21 Mar 2021 11:06:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210321002045.23700-1-pbl@bestov.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/21 6:20 PM, Riccardo Paolo Bestetti wrote:
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 50a73178d63a..734c0332b54b 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -717,6 +717,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  {
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
> +	struct net *net = sock_net(sk);
>  	u32 tb_id = RT_TABLE_LOCAL;
>  	int ret = -EINVAL;
>  	int chk_addr_ret;
> @@ -732,7 +733,8 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  					    tb_id);
>  
>  	ret = -EADDRNOTAVAIL;
> -	if (addr->sin_addr.s_addr && chk_addr_ret != RTN_LOCAL &&
> +	if (!inet_can_nonlocal_bind(net, inet) &&
> +	    addr->sin_addr.s_addr && chk_addr_ret != RTN_LOCAL &&
>  	    chk_addr_ret != RTN_MULTICAST && chk_addr_ret != RTN_BROADCAST)
>  		goto out;
>  	inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
> 


Please add test cases to ipv4_addr_bind and ipv6_addr_bind in
tools/testing/selftests/net/fcnal-test.sh. The latter will verify if
IPv6 works the same or needs a change.

Also, this check duplicates the ones in __inet_bind and __inet6_bind; it
would be good to use an inline helper to reduce the duplication.
