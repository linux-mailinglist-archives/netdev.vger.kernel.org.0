Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F94D429CEC
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 07:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhJLFIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 01:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhJLFIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 01:08:10 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98EAC061570;
        Mon, 11 Oct 2021 22:06:09 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id d125so6365486iof.5;
        Mon, 11 Oct 2021 22:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=D1EXf0UQ7O0n0PRZAuiXxXUhGb2pOwfptpjgbbeKvkg=;
        b=hFHrkPDvfYRfIfxI7wHlqF/vsgzMd/MlZ7AqY00g/OyByz5PMFmwhCoopKazgIwJ47
         /3+2P/ZNfz1fSUjmm8XoilqFJfKqVTnA1frmNzlUkK0+2pwS4DOUPGNGLFgFACZgav5O
         vGd/rVF/QDMxqxHpI+izQOu+oarMxT6eUzvgJvUDsh+1hY16toXxX7tjedEN6Oz8WDI6
         ULw2I3kYzvQyMjxrLnqscjrtLkzi+7cU2edBvh0KtH1E3DDhqBL1dCbmWfy431B/uGcd
         c4O305hIXzi5W/+F9+lqYw5a6ZsFm3IcUmxScMExaTVwasKrp83lfjJVYjWH1MbCZ2TH
         l9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=D1EXf0UQ7O0n0PRZAuiXxXUhGb2pOwfptpjgbbeKvkg=;
        b=hDa96DCFtcQcwYkVFdGjThrUommG+HJPhB757Lo8z5GySFRmBEKB9hDPSmISzeRUaD
         zM22tiZsUVwBMm7h0bStzXx2WNAaMlnHzc94bFGgPBcFJYulmDP6ZbwUVxQYjlXRBMzj
         9NTgkyYaAUjAIcgnHCjkq1Xxw+BpH0KO55/3f70sjKg8mjn/JMfewxvyiVLT5j6xinhE
         rsPyzbEvsn6nMHgYmLuMON2FUpBzHdr3VMcum/QGAOjONv7aN8QR5yf575ieX56YrvP8
         3VyrCG5IlhTgAbgbp4OGhklaGFxMQtMI8IvKMptpNxn+O38ysVfLnBvN+aZlGY5Ygxbr
         gsKA==
X-Gm-Message-State: AOAM530jAfA650d6+ZIk00g14keav8nxPRQqryex5BTQPTA+AHfZsqWP
        pr+aaKYPlgdG5CGU+/njIbc=
X-Google-Smtp-Source: ABdhPJyQ8vjy1AnDje/oXz3nQUgQ0ke1qvBtNoBLk05P6Nn/QntD/msKDFInI5nflE4YL7ykI5wZDw==
X-Received: by 2002:a02:858c:: with SMTP id d12mr9537564jai.110.1634015169106;
        Mon, 11 Oct 2021 22:06:09 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id t1sm4987301ilf.70.2021.10.11.22.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 22:06:08 -0700 (PDT)
Date:   Mon, 11 Oct 2021 22:06:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <616517b9b7336_2215c208b2@john-XPS-13-9370.notmuch>
In-Reply-To: <20211008204604.38014-1-xiyou.wangcong@gmail.com>
References: <20211008204604.38014-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf] udp: validate checksum in udp_read_sock()
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
> It turns out the skb's in sock receive queue could have
> bad checksums, as both ->poll() and ->recvmsg() validate
> checksums. We have to do the same for ->read_sock() path
> too before they are redirected in sockmap.
> 
> Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> Reported-by: John Fastabend <john.fastabend@gmail.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/ipv4/udp.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8536b2a7210b..0ae8ab5e05b4 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1808,6 +1808,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  		skb = skb_recv_udp(sk, 0, 1, &err);
>  		if (!skb)
>  			return err;
> +
> +		if (udp_lib_checksum_complete(skb)) {
> +			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
> +					IS_UDPLITE(sk));
> +			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
> +					IS_UDPLITE(sk));
> +			atomic_inc(&sk->sk_drops);
> +			kfree_skb(skb);

We could use sock_drop() here? Otherwise looks good thanks.

> +			continue;
> +		}
> +
>  		used = recv_actor(desc, skb, 0, skb->len);
>  		if (used <= 0) {
>  			if (!copied)
> -- 
> 2.30.2
> 


