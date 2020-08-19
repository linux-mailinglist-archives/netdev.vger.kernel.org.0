Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E21C24A384
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgHSPs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgHSPs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:48:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD85220639;
        Wed, 19 Aug 2020 15:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597852138;
        bh=M+KmLvjZXimpBFj9/QwTW6ppu9PIQJ7dauQO7HVxdsQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=agAmgtUPMIWENJAki83v0ilnSFnKZPItSyS7xLAaljX4C64Iu/cA8Zuh4izqsGOrM
         qp2NfsywEVraFZ6KIJbtXTU5sa6bRTVb6bX7ZoLCWRoOhfd1iCiuwOaTIaqKyOTL5c
         5XKg1OWe3L2zQSZASVuzy1HoK/7EyZWYGgecLvaI=
Date:   Wed, 19 Aug 2020 08:48:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/6] bpf: sockmap: merge sockmap and sockhash
 update functions
Message-ID: <20200819084856.01716806@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819092436.58232-3-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
        <20200819092436.58232-3-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 10:24:32 +0100 Lorenz Bauer wrote:
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -559,10 +559,12 @@ static bool sock_map_sk_state_allowed(const struct =
sock *sk)
>  	return false;
>  }
> =20
> -static int sock_map_update_elem(struct bpf_map *map, void *key,
> -				void *value, u64 flags)
> +static int sock_hash_update_common(struct bpf_map *map, void *key,
> +				   struct sock *sk, u64 flags);
> +
> +int sock_map_update_elem(struct bpf_map *map, void *key,
> +			 void *value, u64 flags)
>  {
> -	u32 idx =3D *(u32 *)key;
>  	struct socket *sock;
>  	struct sock *sk;
>  	int ret;

net/core/sock_map.c:565:5: warning: no previous prototype for =E2=80=98sock=
_map_update_elem=E2=80=99 [-Wmissing-prototypes]
  565 | int sock_map_update_elem(struct bpf_map *map, void *key,
      |     ^~~~~~~~~~~~~~~~~~~~
