Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900D3CF232
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfJHFi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:38:29 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34230 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729737AbfJHFi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:38:29 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so16112967lja.1
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hXUsg3dK3YvsxOKvLbns9bJTtqXwir1uFTBiGzIm84U=;
        b=cq883m+8QBz4ytdWXpL58OnG2f5EsNhgqerq7ULMULG+RS6Sa8PxgTixQxDXZaiFs3
         qzVmvYjzcEHf4VbV4jefhAMV4XnU1gJ0qp41RY+TD0BMRIuUSUUKxZh4k4EKeIsveGfz
         lOh71pnfWm1lwQf/Bo1FJGmby3XSLCgqz1cj3gAzeCWxcdxwKbROVdlwBPte/DcIUnJI
         zb3HS6L6jMtYoQkhDVCeZZnqsbmCoam+mxraxUGEScLEr8S9gvbtaolWySFJtxBGjVZF
         lbaH3yV0EX+lL7l++LNeosQynZ37hATgxJTbWtq98TYBNbbbGu0EDCqK3ESAcO1/DV0h
         OMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hXUsg3dK3YvsxOKvLbns9bJTtqXwir1uFTBiGzIm84U=;
        b=U1M2lkrRJ/wuZbxGCXEPaHBXhDI+kOQSUQa6AeGGWlKQTiNZpOF3uQJTbv3BvVCzXp
         SZ6jMoYR08UaFxYMWh7u+QlCcDvy1DARdSwOXpzGHHuiL+jCdohGnC8KZsxE/xcr4dGd
         flmHeI1feKt44+dY4T0lSdgeyoKXDM40JNaCdH/okXzP7mvLlGaZ01rSLPPl5LDqv7KJ
         hAgXLIXruKFbjE7aWUdFr/bcQ+eYSzjfr7dm1C4tPbfZy8CEYggNTAnudyb0NSApA+Ye
         0t7fOkx1+ZDvM1GMmIeFon6slyXVVj9f8qC6WfUJMYX5bsgSVwOlu/Uh57Hy+8zC622+
         yJTw==
X-Gm-Message-State: APjAAAV1q11tTx+x8ewEmAJCkQr3QvYMKm0nqFM8x6/Jvo9muBmZtPip
        ApJVeGXiNa7JdAwqBatfdCKJ7seW4LASeano3V8=
X-Google-Smtp-Source: APXvYqztAfU0TWNyS7Mo2so/gIQcmYiVlhQF/UwmizNGrzBVIx9gbYt/rvZ3p44LXWhSSCW7MShRa0eJSDMbnts9vuE=
X-Received: by 2002:a2e:b1d0:: with SMTP id e16mr6660172lja.0.1570513107387;
 Mon, 07 Oct 2019 22:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com> <20191008053507.252202-2-zenczykowski@gmail.com>
In-Reply-To: <20191008053507.252202-2-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 7 Oct 2019 22:38:15 -0700
Message-ID: <CAHo-OowZ2_2LkeREVua6PdTojam_AZQEa0OLL80+t+2xiKSCRQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please think both these patches through.
I'm not going to claim I'm 100% certain of their correctness.

I'm confused by:
  include/net/netfilter/nf_conntrack.h:65:
  * beware nf_ct_get() is different and don't inc refcnt.

and maybe there's some subtlety to this krealloc+rcu+kmemleak thing I'm mis=
sing.

On Mon, Oct 7, 2019 at 10:35 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This reverts commit 114aa35d06d4920c537b72f9fa935de5dd205260.
>
> By my understanding of kmemleak the reasoning for this patch
> is incorrect.  If kmemleak couldn't handle rcu we'd have it
> reporting leaks all over the place.  My belief is that this
> was instead papering over a real leak.
>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/netfilter/nf_conntrack_extend.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_connt=
rack_extend.c
> index d4ed1e197921..fb208877338a 100644
> --- a/net/netfilter/nf_conntrack_extend.c
> +++ b/net/netfilter/nf_conntrack_extend.c
> @@ -68,7 +68,6 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_=
id id, gfp_t gfp)
>         rcu_read_unlock();
>
>         alloc =3D max(newlen, NF_CT_EXT_PREALLOC);
> -       kmemleak_not_leak(old);
>         new =3D __krealloc(old, alloc, gfp);
>         if (!new)
>                 return NULL;
> --
> 2.23.0.581.g78d2f28ef7-goog
>
