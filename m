Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83120609A87
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJXGbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiJXGbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:31:14 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70F45B07C
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:31:12 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id t186so9947305yba.12
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 23:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YL8/YQZkg0smeVQbpzhQExhm+ki4d4kEGLs07CFx0sI=;
        b=I5XXb7u0o/1XWbdXDaLunCz6/t8XCW7NrO7Xa1kgiJcfoCGrkXJo2P6izC18NuwZdJ
         bEXGj648zTqdR6Ynkz2FvNlUHgmpsJpSY/fTerTvA9//WM0GYGiIZwxs2TbbuAoRQDYV
         SAWa8FfAvgCoiFmeYEnVfSRDPy6tNVlWGzsKj0Y/E0xFD/7BEm3Al01YiXODJg1+De+0
         TZzXYJ/RnsRwtTunP/6AFS5UW4NvC8R1mkjqphPteKyxzfBIDPK9CwgU+Z8l3EOcNG/I
         BJGa9BeKD9AduUZs8OVW9AXzEJ99XuPSTSoTg27DjUaMlICTkzzVQGDG0FitZB+PGCMP
         lepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YL8/YQZkg0smeVQbpzhQExhm+ki4d4kEGLs07CFx0sI=;
        b=P85ii0Q+LFWTXv/cjGDrMfXB++DefUbiG7BMyNAaoRkVoCqw9u7aRHa0j56iiSU4yp
         fV69klxw2lY19y84O06SV8dobRKucOw48Yp0PFbhqH87AYC/m7ROR6sdfFbQ6sYP1PAR
         WHG9eW9/lUqcp/dq3kZNGq4PgUHjRdmT8yPQp25bDmArA2XW/o1HrOeiB7T9CQ4bHHa5
         /8P0eA/XK0uvAmFeI/1neETM1yviw7YOWboqWtl7QO3TsUgZWAuJc/jc2sIbN5lG82wC
         c7JqeaJBmTrhviqNmCKdH+KbFSJAP4I+KR7OrvQrP4CYILJuHGedAQwWYK/+STIolMkW
         SbNw==
X-Gm-Message-State: ACrzQf10cLH0WPW1JcQgbt5QCV2MtrW11P2tiDujdTl8MdQwnkPMV88U
        DfPZxtnNnQFc9Ut+EGVARDg2zk8q9oc4vUYMn9i3dA==
X-Google-Smtp-Source: AMsMyM5mRCTSxrDEGtkUFWeZgVR1hNdtpCoL8rF4E+k9Xx4F60uPmsnH9I7TyJtwVjBZUuSWr16JAXBBDRyiB+3Qwvg=
X-Received: by 2002:a25:d914:0:b0:6cb:13e2:a8cb with SMTP id
 q20-20020a25d914000000b006cb13e2a8cbmr2899839ybg.231.1666593071630; Sun, 23
 Oct 2022 23:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fd9a4005ebbeac67@google.com> <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com> <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
In-Reply-To: <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Oct 2022 23:31:00 -0700
Message-ID: <CANn89i+JY3PA_p5t3FrCeO+tAo3YuYOtnkeOeyYvBcqKhpgNZQ@mail.gmail.com>
Subject: Re: [v2 PATCH] af_key: Fix send_acquire race with pfkey_register
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 11:06 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Oct 23, 2022 at 10:21:05PM -0700, Eric Dumazet wrote:
> >
> > Are you sure we can sleep in mutex_lock() ?
> >
> > Use of GFP_ATOMIC would suggest otherwise :/
>
> Good point.  Acquires are triggered from the network stack so
> it may be in BH context.
>
> ---8<---
> With name space support, it is possible for a pfkey_register to
> occur in the middle of a send_acquire, thus changing the number
> of supported algorithms.
>
> This can be fixed by taking a lock to make it single-threaded
> again.  As this lock can be taken from both thread and softirq
> contexts, we need to take the necessary precausions with disabling
> BH and make it a spin lock.
>
> Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
> Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index c85df5b958d2..4e0d21e2045e 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -23,6 +23,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/spinlock.h>
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>  #include <net/xfrm.h>
> @@ -39,6 +40,7 @@ struct netns_pfkey {
>         atomic_t socks_nr;
>  };
>  static DEFINE_MUTEX(pfkey_mutex);
> +static DEFINE_SPINLOCK(pfkey_alg_lock);
>
>  #define DUMMY_MARK 0
>  static const struct xfrm_mark dummy_mark = {0, 0};
> @@ -1697,11 +1699,11 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
>                 pfk->registered |= (1<<hdr->sadb_msg_satype);
>         }
>
> -       mutex_lock(&pfkey_mutex);
> +       spin_lock_bh(&pfkey_alg_lock);
>         xfrm_probe_algs();
>
>         supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);

s/GFP_KERNEL/GFP_ATOMIC/

> -       mutex_unlock(&pfkey_mutex);
> +       spin_unlock_bh(&pfkey_alg_lock);
>
>         if (!supp_skb) {
>                 if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
> @@ -3160,6 +3162,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>                 (sockaddr_size * 2) +
>                 sizeof(struct sadb_x_policy);
>
> +       spin_lock_bh(&pfkey_alg_lock);
>         if (x->id.proto == IPPROTO_AH)
>                 size += count_ah_combs(t);
>         else if (x->id.proto == IPPROTO_ESP)
> @@ -3171,8 +3174,10 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>         }
>
>         skb =  alloc_skb(size + 16, GFP_ATOMIC);
> -       if (skb == NULL)
> +       if (skb == NULL) {
> +               spin_unlock_bh(&pfkey_alg_lock);
>                 return -ENOMEM;
> +       }
>
>         hdr = skb_put(skb, sizeof(struct sadb_msg));
>         hdr->sadb_msg_version = PF_KEY_V2;
> @@ -3228,6 +3233,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>                 dump_ah_combs(skb, t);
>         else if (x->id.proto == IPPROTO_ESP)
>                 dump_esp_combs(skb, t);
> +       spin_unlock_bh(&pfkey_alg_lock);
>
>         /* security context */
>         if (xfrm_ctx) {
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
