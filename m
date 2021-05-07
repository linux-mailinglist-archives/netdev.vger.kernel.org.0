Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AC03761C4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhEGIUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbhEGIUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:20:00 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84703C061761
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 01:18:58 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a36so10478756ljq.8
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 01:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=MWUVk7yj4646QDn77Qt6hcagY8Hi56LhWTAfIF7pdMg=;
        b=DbVZ6yH9o0FYTy0CiT+ADnreY6dYlUSWyGcLtWbjKd3sAAUljty/16PHsUoM/pi12a
         mJKhcbvaKymrnjtvRMMXSuzu1n5LorL4FJIQkfVtDsDzcYqQtzVWn7NnvRHydCJp02Um
         fSw4gPpR5hxX/GwrFhcYlhl6xT2NpCApEXp/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=MWUVk7yj4646QDn77Qt6hcagY8Hi56LhWTAfIF7pdMg=;
        b=czjxdg/mmFkmzFXLG3wfWjJSo7TbghL0X84oAbIS/u1fvZeShuOYoSMxe2uibnNWMG
         0Fceek37rg8lrYSrFJmrvGN1VSkdVmt8aMiscCwrf3MXbRNzkXWyQeKXAXeu2lQBROhy
         zOfvYURyDvYJaUuD6Jx2vay9kZdummTBgEBSHFp3k8SLyzVxlaBl5YP2rDK7PLJIJ6Jt
         v9SmmIGozBJTy5cSewMer968GOJ+/vqHg5Faj/rt7oMvBSwwGzLA4QG+Pf3vP16+Y9J+
         4VnYwIw17CMcob85LlfBCZSF2oeG2iUhYUCYW6Q2wfvMC1c0WjSfEybY8piRblIuUvmM
         0OFA==
X-Gm-Message-State: AOAM531FF0o1VLdzqu990Ug1mIA6G+4z/EOCbqpTJ9t5euBQCrqmP1zs
        xoq9XyLkxT5ao1j3k25ekn757g==
X-Google-Smtp-Source: ABdhPJypd6aRbK0rSSS+jySi5DZGTAj8XBKj+Bp2XKwZBIBwOv4W4kOyj8SEKhV5o/W7k41GbM3zzA==
X-Received: by 2002:a2e:581a:: with SMTP id m26mr6768114ljb.493.1620375536887;
        Fri, 07 May 2021 01:18:56 -0700 (PDT)
Received: from cloudflare.com (83.31.64.64.ipv4.supernova.orange.pl. [83.31.64.64])
        by smtp.gmail.com with ESMTPSA id n20sm1284526lfq.186.2021.05.07.01.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:18:56 -0700 (PDT)
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-5-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        jiang.wang@bytedance.com, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v3 04/10] af_unix: set TCP_ESTABLISHED for
 datagram sockets too
In-reply-to: <20210426025001.7899-5-xiyou.wangcong@gmail.com>
Date:   Fri, 07 May 2021 10:18:54 +0200
Message-ID: <87mtt7ufbl.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently only unix stream socket sets TCP_ESTABLISHED,
> datagram socket can set this too when they connect to its
> peer socket. At least __ip4_datagram_connect() does the same.
>
> This will be used by the next patch to determine whether an
> AF_UNIX datagram socket can be redirected in sockmap.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/unix/af_unix.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 8968ed44a89f..c4afc5fbe137 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1206,6 +1206,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
>  		unix_peer(sk) = other;
>  		unix_state_double_unlock(sk, other);
>  	}
> +
> +	sk->sk_state = other->sk_state = TCP_ESTABLISHED;

`other` can be NULL. In such case we're back to UNCONNECTED state.

>  	return 0;
>  
>  out_unlock:

[...]
