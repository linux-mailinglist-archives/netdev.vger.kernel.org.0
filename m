Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC14346A592
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348423AbhLFTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245331AbhLFTZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:25:16 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06894C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:21:48 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n26so11105035pff.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lsDthcgvaio6IGTjYDxSSKJq9fq5eFyA1KW+ahQyxME=;
        b=C47LMa+VGIjfxrrwdw2t9WutG6DpFXNVE/qxd9lPYKcmBiojpon4ooC3HZ4hJV6UpX
         w1oq60RaIe9H0n+SArGA6KM7d1K4+gCju/l56tkgoxMcO2eT2W+W1yaSvN4ZlYhr0yc+
         /2wa6got3vuBLmsjQ1GZ9ydI7Mqu5DR8//Bhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lsDthcgvaio6IGTjYDxSSKJq9fq5eFyA1KW+ahQyxME=;
        b=ojBEw9pN87T11L9shBRonvLIN9vFkGW7FOXnbjc699ppemdiHEsfXlcgB1SI4qA186
         0lZzPhRMzFdMLO17ZuFUDk1RjRF+kX4oWQtRe41K0TDdFu/f/9pWniFaJ3iipzamLELQ
         EdNXRT6CxXYNQvNXc4/chqlPjgtz7xbgJ0HzijcckVrFHhPVlNB2BYFMMFTN4+UvjsCr
         HQQ3jj+ukiTMP/4AVrtsgleMuVpJia1FZ/HDecegsxsx+2UhyF4QXc75naUvCUxzt7r7
         UDflKFDODJAn3VUhx70mVV5sHaEJ5kDn49o5OnISdEGf9ybFGjATnnyx9tOPGdDDps2y
         R80Q==
X-Gm-Message-State: AOAM5335L03249QoyIisBc9io5fCMEbvV+jUEaamUpC1omko3itpy0Jz
        avHDTOE1mYGgOdHGhfnjrjfz3HckL67hmFZT244wLw==
X-Google-Smtp-Source: ABdhPJxVFTAS+BssVmAdeMvSGMreR3rP86V3xWFCBgpvPDRSr9XGLbJLVJduC1L3lSz+9mGJszffoYHm3xogTDewGxI=
X-Received: by 2002:a62:4e0a:0:b0:4a0:4127:174b with SMTP id
 c10-20020a624e0a000000b004a04127174bmr39203419pfb.41.1638818507548; Mon, 06
 Dec 2021 11:21:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638272238.git.lorenzo@kernel.org> <df855fe05b80746fa7f657fce78b24d582f133cb.1638272239.git.lorenzo@kernel.org>
 <88f9b4e9-9074-a507-426d-7c947f1e2b13@redhat.com>
In-Reply-To: <88f9b4e9-9074-a507-426d-7c947f1e2b13@redhat.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Mon, 6 Dec 2021 13:21:36 -0600
Message-ID: <CAC1LvL1U1=Qb9Em5=uwC=RQw0pKPQ+dCdURgURbLgGAJkXm0eg@mail.gmail.com>
Subject: Re: [PATCH v19 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:11 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
> On 30/11/2021 12.53, Lorenzo Bianconi wrote:
> > XDP_REDIRECT is not fully supported yet for xdp multi-buff since not
> > all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
> > so disable it for the moment.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   net/core/filter.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index b70725313442..a87d835d1122 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4189,6 +4189,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >       struct bpf_map *map;
> >       int err;
> >
> > +     /* XDP_REDIRECT is not fully supported yet for xdp multi-buff since
> > +      * not all XDP capable drivers can map non-linear xdp_frame in
> > +      * ndo_xdp_xmit.
> > +      */
> > +     if (unlikely(xdp_buff_is_mb(xdp)))
> > +             return -EOPNOTSUPP;
> > +
>
> This approach also exclude 'cpumap' use-case, which you AFAIK have added
> MB support for in this patchset.
>
> Generally this check is hopefully something we can remove again, once
> drivers add MB ndo_xdp_xmit support.
>

What happens in the future when a new driver is added without (in its intial
version) MB ndo_xdp_xmit support? Is MB support for ndo_xdp_xmit going to be a
requirement for a driver (with ndo_xdp_xmit) to be accepted to the kernel?

I'm not arguing against removing this check in the future, I'm just wondering
if we need a different mechanism than outright prohibiting XDP_REDIRECT with MB
to protect against the redirected device not having MB support?

>
> >       ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
> >       ri->map_type = BPF_MAP_TYPE_UNSPEC;
> >
> >
>
