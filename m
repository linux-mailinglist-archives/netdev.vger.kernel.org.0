Return-Path: <netdev+bounces-11911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D49735185
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AEC281030
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DCBC8C5;
	Mon, 19 Jun 2023 10:08:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E6C13C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:08:20 +0000 (UTC)
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B905213D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:08:19 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3fde9bfb3c8so216121cf.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687169299; x=1689761299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sc9cJ6usscm6Ij2tQjnNdZlm85wrZazMfBi//urMko4=;
        b=MB/K51c4OvvhQqEdFScFEhKv86Sx+OoRDgl6LnByrRNcI+KEtwH0qYyMmCI/0pqIuI
         h3Vci0bo7z8H2Tvc+MYx8vaBMWVx0bKrRrPgd636nQJTLowPBm2U2bGOH+nSOJJAKdnB
         FRLUBYC+XJwEhxO1Mkbo1O5fEyi+vWwsypu5iZnsAD8Za/8rtBUZJaXmj848eKRKBR3a
         TlvwRZ9QmQJZftJ5c9A0vX8fFIWr4LYHnaUc9Ciq3W0R7nkCz7eUgsGxsWw/p7xvMmlz
         P3bakp8ebGg+uukalg1Vs3BVehnhJ2hezWwOJKnzDj5Cw86yzqRZXvH/vnnNOlywZDde
         zhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687169299; x=1689761299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sc9cJ6usscm6Ij2tQjnNdZlm85wrZazMfBi//urMko4=;
        b=MXywg/l82U2TwreYUFJSUKZAVdHrJqe/hcSp6D3WOv8Ba45lSv548DWVbPWiGaDct0
         yPl4fb4kN63X2sfbkC0gi3OTXSHFcJi9o7NZwOMb+hW5DLpkoQQgsXCF1aaZkCphRpD6
         yQHH0UJiKyNgMUZ1GRCVhW3qKdpve9K5lx+YzKqvsSkyM+AQ7NWiMbt9z5enrqSySYya
         sPdlLQndmssInqbwF8w1D6t6IUoZGxR8G65ELPQTuEGrRCGk4efs0iNnZwlMvUF8GvLm
         p/9hIWbsEp3aOPQFxEeOeMqWunD6qtIupUOvFhicDBduC//hZYEzQ6QHLPi5cPHuyiDh
         6J3A==
X-Gm-Message-State: AC+VfDzxKs6FiX/M6Nk+k2tf9bNSLAEnn8Z1ZciMz8KylHdDIJe62qgD
	El/1c/gtE96Xj3xfw76eEpqJf3a0DBEgNAKxoZZnqfa/SKH6IuIB8z4=
X-Google-Smtp-Source: ACHHUZ6DXozSYx4P4n9OspYAxsZSyNwGnGWiAr7oC/mIlQO5JIaYJtuZVYyz/Bwbl52/VZU2z8SqimCjlDFsfQobdL0=
X-Received: by 2002:ac8:5992:0:b0:3f5:2006:50f1 with SMTP id
 e18-20020ac85992000000b003f5200650f1mr908051qte.12.1687169298618; Mon, 19 Jun
 2023 03:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230619082547.73929-1-wuyun.abel@bytedance.com>
In-Reply-To: <20230619082547.73929-1-wuyun.abel@bytedance.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 19 Jun 2023 12:08:07 +0200
Message-ID: <CANn89i+deprQWB0dmsUD1sRmy1VQCQwKnZUkLu_AEGV=ow=PKQ@mail.gmail.com>
Subject: Re: [PATCH net-next] inet: Save one atomic op if no memcg to charge
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 10:26=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com>=
 wrote:
>
> If there is no net-memcg associated with the sock, don't bother
> calculating its memory usage for charge.
>
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>  net/ipv4/inet_connection_sock.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_s=
ock.c
> index 65ad4251f6fd..73798282c1ef 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -706,20 +706,24 @@ struct sock *inet_csk_accept(struct sock *sk, int f=
lags, int *err, bool kern)
>  out:
>         release_sock(sk);
>         if (newsk && mem_cgroup_sockets_enabled) {
> -               int amt;
> +               int amt =3D 0;
>
>                 /* atomically get the memory usage, set and charge the
>                  * newsk->sk_memcg.
>                  */
>                 lock_sock(newsk);
>
> -               /* The socket has not been accepted yet, no need to look =
at
> -                * newsk->sk_wmem_queued.
> -                */
> -               amt =3D sk_mem_pages(newsk->sk_forward_alloc +
> -                                  atomic_read(&newsk->sk_rmem_alloc));
>                 mem_cgroup_sk_alloc(newsk);
> -               if (newsk->sk_memcg && amt)
> +               if (newsk->sk_memcg) {
> +                       /* The socket has not been accepted yet, no need
> +                        * to look at newsk->sk_wmem_queued.
> +                        */
> +                       amt =3D sk_mem_pages(newsk->sk_forward_alloc +
> +                                          atomic_read(&newsk->sk_rmem_al=
loc));
> +
> +               }
> +
> +               if (amt)
>                         mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
>                                                 GFP_KERNEL | __GFP_NOFAIL=
);

This looks correct, but claiming reading an atomic_t is an 'atomic op'
is a bit exaggerated.

