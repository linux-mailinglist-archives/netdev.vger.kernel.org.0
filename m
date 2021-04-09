Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0E3590E2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhDIA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhDIA0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 20:26:39 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB973C061760;
        Thu,  8 Apr 2021 17:26:27 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r193so4142059ior.9;
        Thu, 08 Apr 2021 17:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qAptFUU90Znoha/E9NINSsAXDHdY41JcMDe7P0BQ2Yg=;
        b=lqAGPuzRmQzOkMzEJ9f0AoMW+aNm0bys8BXHQIwaHKHGSBML0IDUTzNKKH3ch1XqPN
         VkmHxyqWhT2OmqMAtrliPhTJ6RJcf/6sOgYJAPjLBUEQyviZpLUpWz4Z+e0ckkD2vcVa
         5W0omj+G0zkx55JP5i1w7lhfz/R1whTl8FBuFc4nC1Ro9gVNSmxuxo3BNVpjBzUDdWS4
         A9jR/+pguoo3iuT9N1vfW6GmBcF7VBOB4o4bdZzYAz6XdkV/YPxrcF4jDfQitgBUy7R1
         Pm8f+g/fhldAB12N62U06LPaFa3RxMq+Xhjgn6FFXepOdE/8jXjXP1b5PUttC9zE+HCI
         hD4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qAptFUU90Znoha/E9NINSsAXDHdY41JcMDe7P0BQ2Yg=;
        b=cb6winHOUCxqUO0Y7qRKBapePl4LQiGVW+PYHxr8oSaZEYK2aR8RWdwWQkYkYiM2qQ
         6HwqJDXmMw2Mfg+nDfKpP0Q4MLFc54dwKa2GYfVoYmljOPl8Jk+X1dwpJXmr08EY0w/+
         tGSv0wwp9GE3T/mbT1SGK1mHmH2a3vFxA4gECVR//4m2dNzgIdorp2c8rkykTKwChRf1
         7v+ltOzLhcDUd6ghzIK21B9dBLB1Qs0aRIj3nHOU/6kFbA9wd2cMVf6LMgCl+nn9bYqW
         FpG2wNUaK+/b05tnCsJK7sX9XzoF4ux3P9u0BSom6KL2NLrQb+8T8N7O7gBIDaenNyDv
         DKhg==
X-Gm-Message-State: AOAM530jk4m5PROt1Yf3yiT9YV8wpx0WEgBwzjCxxcDzVZHculn/TeaI
        Uy/GXtKGQi7v012ksMFjygA=
X-Google-Smtp-Source: ABdhPJwNBeyYBBhR5PYARBaEDWRkA3HCI5UnZZMdpyf1XJ8WKww02UwfsAbdyg7KmbNmVeWgO9ichw==
X-Received: by 2002:a6b:8b0e:: with SMTP id n14mr9145619iod.199.1617927987114;
        Thu, 08 Apr 2021 17:26:27 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id k11sm455905ilv.73.2021.04.08.17.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 17:26:26 -0700 (PDT)
Date:   Thu, 08 Apr 2021 17:26:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606f9f2b26b1a_c8b9208a4@john-XPS-13-9370.notmuch>
In-Reply-To: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
References: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] sock_map: fix a potential use-after-free in
 sock_map_close()
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
> The last refcnt of the psock can be gone right after
> sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
> The reason why I placed sk_psock_stop() there is to avoid RCU read
> critical section, and more importantly, some callee of
> sock_map_remove_links() is supposed to be called with RCU read lock,
> we can not simply get rid of RCU read lock here. Therefore, the only
> choice we have is to grab an additional refcnt with sk_psock_get()
> and put it back after sk_psock_stop().
> 
> Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/sock_map.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index f473c51cbc4b..6f1b82b8ad49 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1521,7 +1521,7 @@ void sock_map_close(struct sock *sk, long timeout)
>  
>  	lock_sock(sk);
>  	rcu_read_lock();

It looks like we can drop the rcu_read_lock()/unlock() section then if we
take a reference on the psock? Before it was there to ensure we didn't
lose the psock from some other context, but with a reference held this
can not happen.

> -	psock = sk_psock(sk);
> +	psock = sk_psock_get(sk);
>  	if (unlikely(!psock)) {
>  		rcu_read_unlock();
>  		release_sock(sk);
> @@ -1532,6 +1532,7 @@ void sock_map_close(struct sock *sk, long timeout)
>  	sock_map_remove_links(sk, psock);
>  	rcu_read_unlock();
>  	sk_psock_stop(psock, true);
> +	sk_psock_put(sk, psock);
>  	release_sock(sk);
>  	saved_close(sk, timeout);
>  }
> -- 
> 2.25.1
> 


