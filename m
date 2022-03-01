Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2644C7FB9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiCAAwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiCAAwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:52:01 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242CD10FE4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:51:21 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m14so24288682lfu.4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AHMKNwsJmZIv42C56dUYCGLQL894qM+ba23hywWTdn8=;
        b=CvrUBJC6MSgGF2nfgS8h6+bd3OM57xvy6mAQ5dDJSDF+HjBQendAmIUKlh1i1XlWJT
         tfNEvm8PWqbbhCmzwhoWSgEEDCByUvTreqcxm/q8nO2R0zzwFAgv1MrBAC9+bpiv7g/F
         pTxXnGdDTLZNGOFzq0M2d/89Pzhxwk3ItZZu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AHMKNwsJmZIv42C56dUYCGLQL894qM+ba23hywWTdn8=;
        b=msQ3Dd3u/d3XfcKsf+n3Hh9TVxURvo3DhRRC5TzyaC7eZaeZEKr4XIe9FuZsaSwTZ4
         cVC2R24Zih7PlLD+HJNpMVzNS8cj2CDMpETCmtLpR0zabXjwrnUoLrszNIijp4n0ff2E
         ig/Am45l3rfyqjqW5pAAhrxm7ck137Sj6ACQazrhVVs8jG7FDR6OkKU2Xn810OZOWDuo
         kbkMjYV2G+nSpPwVeCfUPNvwr1F/Lc0tQ2w7fWo7ypC/is0gmH+QkUfy93UNKeMy9w7z
         GMYIkKv8Dj7/+IyOx8WaiB/5of5Ij8NFgNk94ARgmfswYDIBqRuqRuaj4MPZyigjU4yz
         JWew==
X-Gm-Message-State: AOAM532RuO1mNmpa60VlYZWyQFUARyRGf4JgH3JqgSJ7n/pZ15CATwNS
        S3cg+Rfsz8IRLUQovLvxJ68UWQKST68CbDBoKVXqOg==
X-Google-Smtp-Source: ABdhPJx1XgxrxKvShJZnqXdRuXmzpPyv95vdF2irZB/EkJsngmyT6nJoPFnRQo6osF+EKqx9c8UESUZekiL9gRL6td8=
X-Received: by 2002:ac2:5b4b:0:b0:43c:795a:25a6 with SMTP id
 i11-20020ac25b4b000000b0043c795a25a6mr14461839lfp.268.1646095879481; Mon, 28
 Feb 2022 16:51:19 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com> <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
 <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com> <87h78jxsrl.fsf@toke.dk>
In-Reply-To: <87h78jxsrl.fsf@toke.dk>
From:   Joe Damato <jdamato@fastly.com>
Date:   Mon, 28 Feb 2022 16:51:08 -0800
Message-ID: <CALALjgxJDF=WJBbExTn0ua5LoqHqGHe0a8MG0GifbbRptfruLQ@mail.gmail.com>
Subject: Re: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 1:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Joe Damato <jdamato@fastly.com> writes:
>
> > On Sun, Feb 27, 2022 at 11:28 PM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >>
> >> On 25/02/2022 18.41, Joe Damato wrote:
> >> > +#ifdef CONFIG_PAGE_POOL_STATS
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast)=
 },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow)=
 },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow_=
high_order) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empty=
) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refil=
l) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waive=
) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_c=
ached) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_c=
ache_full) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_r=
ing) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_r=
ing_full) },
> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_r=
eleased_ref) },
> >> > +#endif
> >>
> >> The naming: "page_pool_rec_xxx".
> >> What does the "rec" stand for?
> >
> > rec stands for recycle.
> >
> > ethtool strings have a limited size (ETH_GSTRING_LEN - 32 bytes) and
> > the full word "recycle" didn't fit for some of the stats once the
> > queue number is prepended elsewhere in the driver code.
> >
> >> Users of ethtool -S stats... will they know "rec" is "recycle" ?
> >
> > I am open to other names or adding documentation to the driver docs to
> > explain the meaning.
>
> You could shorten the 'page_pool_' prefix to 'ppool_' or even 'pp_' and
> gain some characters that way?

I had considered this, but I thought that 'pp' was possibly as terse as 're=
c'.

If you all think these are more clear, I can send a v8 of this series
that changes the strings from the above to this instead:

rx_pp_alloc_fast
rx_pp_alloc_slow
rx_pp_alloc_...

and

rx_pp_recyle_cached
rx_pp_recycle_cache_full
rx_pp_recycle_...

With this name scheme, it looks like all the stat names seem to fit. I
have no idea if this is more or less clear to the user though :)

I'll leave it up to the mlx5 maintainers; I am happy to do whatever
they prefer to get this series in.

Thanks,
Joe
