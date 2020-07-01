Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEB210124
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgGAAxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGAAxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:53:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49804C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:53:17 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m81so23177974ioa.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 17:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NWyDt/lpeERYlfs2pzUiPCe/BkvxwSTLrujZWFXfW00=;
        b=HMhSj1cabhds3/WHQe0mymLaU3TIAuOLbG+OhFeqQ1gBcKnVWzxSPLKtdFlEoR0RbL
         COb0ylDjJYBBS3/iGhi6XJwBIyA84yDRNIzrc3m4jkuu3kOO1ZOPi+nU6NSNVTtYx9jD
         4aIXTUhCbQd/teoGbSkXD+p5WlpaH9YqLsaHVqckak6XfrhXBekpOTbmy/osqYL+Rn+C
         RVJvftDB0iPAIS94ektjZkUkKty3a7CTyH3YdFqzL1dZDfaGTFI6mSEeopspFxhd9sXl
         MQZVld9deRMQJwzy2rEAfZOephGQtsYPS7To5wWQMf+GPUCrFJ33KhZ7/7IcXfGHePaF
         NWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NWyDt/lpeERYlfs2pzUiPCe/BkvxwSTLrujZWFXfW00=;
        b=BeNjCwmjlaW+z7cFKfncQEv/w3tBjHvKKBY6OszEOyOY3df0HDvO+eGzR7CyaVYT6n
         /hkVZChe9Sm58zbqzVrXKgcsA00Yl9AujjpYWQdktKqpQwjCBchfxyBR983srBjzJiET
         KcHF+L7KfOxStBXgwmz74oj48jJGzhpcijgGjRofnuOVMCK74oKwbsX/yfKUnZdt6tLh
         nefcuvxpyiraCorXP2OgXd2ptC5jie5UWJV1U4lsKjeIKyKjelYi7wff0AKUlFusif5B
         0oqTn9n0rRZ5ypldtDibVi8kACh+tjSnVKFa18JNRz8MrOhRBSdOAjwQ/dvJmBxQ+dKn
         bs8w==
X-Gm-Message-State: AOAM532uYwdtBx8n63b4jODqBBdnA0LAt3Jju41yrVnu7HgUlNvmbn4u
        SADXS0Th1mbXWLfWZNX4Ni9NsOmt/bhMK/plbhuUBA==
X-Google-Smtp-Source: ABdhPJywTEpQbGSAYRMr8C62cDkY1n4VP4RBYSndmVGbyFeXOV2Mit76TYyt7FS0iq4MVwprZ6JoCPZFF6D2Bt2R9Is=
X-Received: by 2002:a6b:1496:: with SMTP id 144mr24543456iou.6.1593564796383;
 Tue, 30 Jun 2020 17:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200630234101.3259179-1-edumazet@google.com>
In-Reply-To: <20200630234101.3259179-1-edumazet@google.com>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Wed, 1 Jul 2020 09:52:07 +0900
Message-ID: <CAPA1RqChMXe-o_eqc3VN3vT7wtY3Bz-SKzp6ZU2PQ3SykACgXA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B47=E6=9C=881=E6=97=A5(=E6=B0=B4) 8:41 Eric Dumazet <edumazet@go=
ogle.com>:
:
> We only want to make sure that in the case key->keylen
> is changed, cpus in tcp_md5_hash_key() wont try to use
> uninitialized data, or crash because key->keylen was
> read twice to feed sg_init_one() and ahash_request_set_crypt()
>
> Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  net/ipv4/tcp.c      | 7 +++++--
>  net/ipv4/tcp_ipv4.c | 3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881dd=
6dc2910a1236263 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
>
>  int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig=
_key *key)
>  {
> +       u8 keylen =3D key->keylen;
>         struct scatterlist sg;

ACCESS_ONCE here, no?

--yoshfuji

>
> -       sg_init_one(&sg, key->key, key->keylen);
> -       ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
> +       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> +
> +       sg_init_one(&sg, key->key, keylen);
> +       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
>         return crypto_ahash_update(hp->md5_req);
>  }
>  EXPORT_SYMBOL(tcp_md5_hash_key);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff=
40516f79e6fdf7f 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union tcp=
_md5_addr *addr,
>         if (key) {
>                 /* Pre-existing entry - just update that one. */
>                 memcpy(key->key, newkey, newkeylen);
> +
> +               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() =
*/
> +
>                 key->keylen =3D newkeylen;
>                 return 0;
>         }
> --
> 2.27.0.212.ge8ba1cc988-goog
>
