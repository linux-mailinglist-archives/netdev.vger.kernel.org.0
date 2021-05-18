Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05FE387155
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 07:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhERFh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 01:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbhERFh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 01:37:56 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9267C061573;
        Mon, 17 May 2021 22:36:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z24so8214108ioj.7;
        Mon, 17 May 2021 22:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=D0RH+M8yWxv/vYVmDJZOY8Nk2L+FWMlGG7b/HoI+pRc=;
        b=UDD9UEy7hEt0+l2LEBczupXXD53qaSJUA4WF7lcFMUhv3/o9+5yqVlwjcdSE0plfQU
         e44I+uK0TNwjl7FyH8HyWU8XH6nrENV5ky8cV13TyveZ5hG2E0DbnDQ9pjFtGC1kf6pj
         /NxGhyTSP4zgpYesXJvszfHCKYdVA2asQYw7XVYEc7cAIbSOFIQ6WAzKiWdB3n55j3vn
         +AmkJONKSYdpdkr/FM/LMde2qaQEJJWMnTgMz9Az7s9QLzYwyljEsfj01x+BdQpV7zOQ
         B7qSXi9HidZHowHAgloCGZOUl6NeJU09mGVmbwDsXyFSG71f6KBj4jgRBugtqdHHVKfn
         VFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=D0RH+M8yWxv/vYVmDJZOY8Nk2L+FWMlGG7b/HoI+pRc=;
        b=Hkv0i9HK77lmAHIDTeFReb2KyNGSa43GkCHB5QpbWjTQhFncdQUdzjPGVpGT+UcJ5v
         0Ccfey4XuZHR9odD0KgOSLqqLPRMOYj+yKSZ+DIIxxjJ9MD/0YYlENsFwSH8J/YpZh1A
         Kf54aCLuJFcZ/reIPe4AUBWKt9HPmmq1aMjC8kk0EG7y3cOARHwr1sxqZVFRdt1nWH+d
         cNvzfPKBD9EFuXzFtjQ9aaNKMdEmrADvWCd1Z16yd3U+4RoBz6W3VtBZVaeB00isRlfA
         zOF3qh23gSY6CigixmOoCcHpU4NhdxF4KkeWlqOefJMEmCqNzsl8WLlFlqg+KBu20/lj
         VIhQ==
X-Gm-Message-State: AOAM531CVytOioXI8p0PJENmrgDegYqevKhY1KzX3+6fWCtBItwDe+2v
        YiZWYt0ErsVKd8jVJoIiEOc=
X-Google-Smtp-Source: ABdhPJwCbYsKIqf+yCxTI+bShnwmLS3PuG/Lbci34OaUvtt7N6H6g0DA81M6iUrHs4Uw10v38q/HVw==
X-Received: by 2002:a05:6602:70d:: with SMTP id f13mr3065633iox.16.1621316198415;
        Mon, 17 May 2021 22:36:38 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id l9sm8616591iop.34.2021.05.17.22.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:36:37 -0700 (PDT)
Date:   Mon, 17 May 2021 22:36:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
In-Reply-To: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf] udp: fix a memory leak in udp_read_sock()
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
> sk_psock_verdict_recv() clones the skb and uses the clone
> afterward, so udp_read_sock() should free the original skb after
> done using it.

The clone only happens if sk_psock_verdict_recv() returns >0.

> 
> Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/ipv4/udp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 15f5504adf5b..e31d67fd5183 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  		if (used <= 0) {
>  			if (!copied)
>  				copied = used;
> +			kfree_skb(skb);

This case is different from the TCP side, if there is an error
the sockmap side will also call kfree_skb(). In TCP side we peek
the skb because we don't want to drop it. On UDP side this will
just drop data on the floor. Its not super friendly, but its
UDP so we are making the assumption this is ok? We've tried
to remove all the drop data cases from TCP it would be nice
to not drop data on UDP side if we can help it. Could we
requeue or peek the UDP skb to avoid this?

>  			break;
>  		} else if (used <= skb->len) {
>  			copied += used;
>  		}
>  
> +		kfree_skb(skb);
>  		if (!desc->count)
>  			break;
>  	}
> -- 
> 2.25.1
> 


