Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33D62EA46C
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 05:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbhAEEXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 23:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbhAEEXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 23:23:52 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D610C061574
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 20:23:12 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id 6so39584838ejz.5
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 20:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Ny1CGA1s5weQ/B1wO84rC/dz7cTzYc1AUJiJgVjOdk=;
        b=S7pnjYcGR9afGW9jezfMwHAFRodT1H3h0jtVjGbrstcwPtrjgUfGGhrQJigEFMaitX
         mZkHFsHR3NGcsIv3uUMke4gZQ2Y9lrf1Ie2RU00F+4UixXuG0TVkZBZNbJ4QsxpKOi3o
         kD+xwXuXooorVi/kJD8PDH43M4WYQ/mZxMryxtlMr3aK0a6Zk1jxhnmrrAR0uqA8dB8W
         +xj8Kcrh2h/3u1DOyWVtUWafEpsxdbKFM10t6rniBGnZBw+pxIHyHpKCHsubBLVAZcdy
         ZNLXrO76LFmxQiRW274zGeZVNPyOvSHNB58Ji6fKlHPGMrWWmH8IdQ+Hx5a/HCHiSqZi
         DhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Ny1CGA1s5weQ/B1wO84rC/dz7cTzYc1AUJiJgVjOdk=;
        b=MErjXQmGrqnBZeVHNgjPD8M49ZLZRHj8SwsBUfRX21nWWsRgBaH22WXd7EAq+jr0+k
         /z85DiXCkbzwBORmyHVBoSGQM4oIOrGV/UdVUoy8I602ZDy7k25mccxl1P1xXizgZxHm
         4TbjHp3x9TtpLKi+3LvJnmkbOdAQ1FmnjR33LpHSY9VpvKcIM+r07rHLjpZ1Ty+tWp9x
         QTKwy0swwj1kOU7BXE3q26SAF+6j+8fJLC+2LCj8tdZ/tdoQ6FfcpkeUJOD4oCSWEkCD
         eYmvpPg6xGqwp9Zu0MkjLJxNrj79bstRSv6lkxUheQbnSi6bGZtetx0QSVe16mx/D5gB
         TRzg==
X-Gm-Message-State: AOAM532D4EYQqYV0HDNjfr9nkv5EkfYW4NOb5PN5noNppVPpVrGAEl2B
        4BEwOVLiTod7WSx31Q2bPscIQCPXxOSniyJg1v8=
X-Google-Smtp-Source: ABdhPJwTw/9/W9mrROHJHoGzvc0p6MJJ+Eod2MDZcAimSlbUD3ZdCTNZ2WZjiH2hPhVP9yMAK+pCG9A5Pwjnxlqd65o=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr52200331ejd.119.1609820591017;
 Mon, 04 Jan 2021 20:23:11 -0800 (PST)
MIME-Version: 1.0
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
 <CAF=yD-Jb-tkxYPHrnAk3x641RY6tnrGOJB0UkrBWrXmvuRiM9w@mail.gmail.com> <20210105041707.m574sk4ivjsxvtxi@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210105041707.m574sk4ivjsxvtxi@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 4 Jan 2021 23:22:35 -0500
Message-ID: <CAF=yD-KbkYTHG+MC5y3qOCFp=9EVsk=TPb=7RoHtVTZqnL0OyQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/12] Generic zcopy_* functions
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 11:17 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Mon, Jan 04, 2021 at 12:39:35PM -0500, Willem de Bruijn wrote:
> > On Wed, Dec 30, 2020 at 2:12 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > This is set of cleanup patches for zerocopy which are intended
> > > to allow a introduction of a different zerocopy implementation.
> > >
> > > The top level API will use the skb_zcopy_*() functions, while
> > > the current TCP specific zerocopy ends up using msg_zerocopy_*()
> > > calls.
> > >
> > > There should be no functional changes from these patches.
> > >
> > > v2->v3:
> > >  Rename zc_flags to 'flags'.  Use SKBFL_xxx naming, similar
> > >  to the SKBTX_xx naming.  Leave zerocopy_success naming alone.
> > >  Reorder patches.
> > >
> > > v1->v2:
> > >  Break changes to skb_zcopy_put into 3 patches, in order to
> > >  make it easier to follow the changes.  Add Willem's suggestion
> > >  about renaming sock_zerocopy_
> >
> > Overall, this latest version looks fine to me.
> >
> > The big question is how this fits in with the broader rx direct
> > placement feature. But it makes sense to me to checkpoint as is at
> > this point.
> >
> > One small comment: skb_zcopy_* is a logical prefix for functions that
> > act on sk_buffs, Such as skb_zcopy_set, which associates a uarg with
> > an skb. Less for functions that operate directly on the uarg, and do
> > not even take an skb as argument: skb_zcopy_get and skb_zcopy_put.
> > Perhaps net_zcopy_get/net_zcopy_put?
>
> Or even just zcopy_get / zcopy_put ?

Zerocopy is such an overloaded term, that I'd keep some prefix, at least.
