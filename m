Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506C34C9104
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 18:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbiCARBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiCARBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:01:04 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E28EC31
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 09:00:22 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id r20so22733761ljj.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 09:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dT5wSs+HWTfZqkPgoPFkPoIMGJ8+/5YQ4qeHdHytH/c=;
        b=tkbKzR1gyCcCOvJSS85VJbg+MjhpDgnmLRsftBNfY5r43laoTTUgHgNwttVmcl9PsL
         1lhUJI9eybS1EuJWs1Y4rb6WFKNKpD4I0lMuUF+BHXtE+XJMYNRcIVqAOhA0OQYgWV7v
         yuFObOGwiN9Q90BPE/UyNpgVfGRQeMYLuZnG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dT5wSs+HWTfZqkPgoPFkPoIMGJ8+/5YQ4qeHdHytH/c=;
        b=DPKdw+SwcIVuGpdh6A4/vpvl4ZwRsrpcpcna+Xl+TAJnjJ2ESBfD1BNWZ7m4UHoTXM
         Ab9RXxUFVE4QAGn2MM0KAlmioyOtkF3nqTLSMSw0BhduHlvLlZnwcdZBuRSGlyG8RdTV
         gpX4bOkWQ1SucLGT1DHU6A8lI+TmmtLWrzDqUKgB+NFt8qNfmgRzpGpMmopAZJqUf0Jq
         L+yQH97KPpgwmCxLV2LDr/3NTG4hG08xWzfLoTbvAzI7B/QHuuouvsp+4RYwywIlZEt+
         STXHLPSqZiq2yiv8U1S5awvxRxVqTSIEbrSWUcl8khUsQf5zQMwHfMILeSunJ8kNOR7j
         Z9Ig==
X-Gm-Message-State: AOAM530Ll7bDJWSeMXJF4+Vp2oYsFH5I8bNNR5imPM/fEj2mdony7Efy
        0cjkJ+6NW6U/+FsnC19eZfx1r9l4Cq0wNNHatujLNw==
X-Google-Smtp-Source: ABdhPJxYHydFv72EB0XS3qdQ38r79Sue2VYXH5Seov8t1mx/ZO2Qwb2CjZb1NfZlBG64MVBrFi0ZPzReBI7VsTL+B14=
X-Received: by 2002:a05:651c:1505:b0:246:8fe5:5293 with SMTP id
 e5-20020a05651c150500b002468fe55293mr5198972ljf.152.1646154019796; Tue, 01
 Mar 2022 09:00:19 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com> <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
 <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com>
 <87h78jxsrl.fsf@toke.dk> <CALALjgxJDF=WJBbExTn0ua5LoqHqGHe0a8MG0GifbbRptfruLQ@mail.gmail.com>
 <87a6e9dih5.fsf@toke.dk>
In-Reply-To: <87a6e9dih5.fsf@toke.dk>
From:   Joe Damato <jdamato@fastly.com>
Date:   Tue, 1 Mar 2022 09:00:08 -0800
Message-ID: <CALALjgyifKX3==tv-nx-mVFdsngVF0WEqy0tmawcWvSoPsyGNw@mail.gmail.com>
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

On Tue, Mar 1, 2022 at 3:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Joe Damato <jdamato@fastly.com> writes:
>
> > On Mon, Feb 28, 2022 at 1:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Joe Damato <jdamato@fastly.com> writes:
> >>
> >> > On Sun, Feb 27, 2022 at 11:28 PM Jesper Dangaard Brouer
> >> > <jbrouer@redhat.com> wrote:
> >> >>
> >> >>
> >> >>
> >> >> On 25/02/2022 18.41, Joe Damato wrote:
> >> >> > +#ifdef CONFIG_PAGE_POOL_STATS
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fa=
st) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_sl=
ow) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_sl=
ow_high_order) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_em=
pty) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
fill) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_wa=
ive) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
c_cached) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
c_cache_full) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
c_ring) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
c_ring_full) },
> >> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_re=
c_released_ref) },
> >> >> > +#endif
> >> >>
> >> >> The naming: "page_pool_rec_xxx".
> >> >> What does the "rec" stand for?
> >> >
> >> > rec stands for recycle.
> >> >
> >> > ethtool strings have a limited size (ETH_GSTRING_LEN - 32 bytes) and
> >> > the full word "recycle" didn't fit for some of the stats once the
> >> > queue number is prepended elsewhere in the driver code.
> >> >
> >> >> Users of ethtool -S stats... will they know "rec" is "recycle" ?
> >> >
> >> > I am open to other names or adding documentation to the driver docs =
to
> >> > explain the meaning.
> >>
> >> You could shorten the 'page_pool_' prefix to 'ppool_' or even 'pp_' an=
d
> >> gain some characters that way?
> >
> > I had considered this, but I thought that 'pp' was possibly as terse as=
 'rec'.
> >
> > If you all think these are more clear, I can send a v8 of this series
> > that changes the strings from the above to this instead:
> >
> > rx_pp_alloc_fast
> > rx_pp_alloc_slow
> > rx_pp_alloc_...
> >
> > and
> >
> > rx_pp_recyle_cached
> > rx_pp_recycle_cache_full
> > rx_pp_recycle_...
> >
> > With this name scheme, it looks like all the stat names seem to fit. I
> > have no idea if this is more or less clear to the user though :)
>
> My thinking was that at least 'pp_' is obviously opaque, so it will be
> clear to readers that if they don't know what it is they have to look it
> up. Whereas 'rec_' looks like it could be 'record' or something like
> that, and it'll make people guess (wrongly).

Fair enough.

> > I'll leave it up to the mlx5 maintainers; I am happy to do whatever
> > they prefer to get this series in.
>
> Right, but this is also going to create precedence for other drivers
> that add the page pool-based stats, so spending a bit of time agreeing
> on the colour of the bikeshed may be worthwhile here... :)

Sure, that's fine with me.

I'll give it a few days - hoping to hear back from the mellanox folks
on what they prefer before submitting a v8 with the changes I
mentioned above.

My goal is to avoid a few extra rounds of back and forth if possible :)

Thanks,
Joe
