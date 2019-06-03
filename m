Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0504032B5E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfFCJEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:04:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46603 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfFCJEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 05:04:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id z19so8406597qtz.13;
        Mon, 03 Jun 2019 02:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8r4FSN4UDrJ/GP59YgwlloK95fa6BM/zE+ejcDiRuGg=;
        b=pMhtfVT4cNHQlpw8g70V+bDuUUb0WX7N62uD5xPpUXmSnH/jY6qzcUXZ8bhQ0uW8cJ
         X0t+WOSqmIgAbut0PIuTVeR8WIG+BoAh8bMTRco8D3L1E4LRKN8dolplZqK3XYthSamL
         YazMihrh0fo5+rt7Lzp3D/5pnJoW+yngP1JRe6p+mX/8tkkipRMk+e/DUZHSxuadr0eu
         KtCpD751/ZXWfC/eFVvzwlA5K1Y97W6fAHgM/TcAcA11y+RcSB/iLwJ7xx3Uy31T9snN
         FXSJxrIDhZXdIq4/E5jCntypLGGdVTcVcqUW4yxKNsz6mi51IebvE3PZkTnAFs557ioC
         +J4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8r4FSN4UDrJ/GP59YgwlloK95fa6BM/zE+ejcDiRuGg=;
        b=E4wwfs6BbJrLjI6R8ynzFXFJeSnuuQPXgUhb3+r0eFVL+7JujwXvLoZUpWLqKlcnke
         Pu/JVlxZ8dbCWZO5NJZIr4AaU3NBrt3IKVDLjmiiqKpBt3hfeuE4JIlrWJx8FQ+LguYP
         cmQf2HAvPgDfQYK/AYAvxYHCA5qY3VI/ZPd3Ztxt0LP52um8nnftmowvl78KUQUhiS2W
         q5yBTX7YSx07bbel7leduw55HnzFZUZGWBVtiHUVTuGc4ju0SPL6FmOWgi3jKXk/sOSc
         ByXnHaE5B5HW57JZTx9tfGcx8mnGWheGmFfjmR436zxOwsna+QLdaTAA6Hkpp0jC/jXm
         hnMg==
X-Gm-Message-State: APjAAAUL/gY9MGQ7/Srn0Y9Hy7l67jzYNo5ksdCzYoSCvwA1cFZORzcL
        Lo8pbWSS6kVyYyth8Cror7/zIsCayvVyBS5uFM4=
X-Google-Smtp-Source: APXvYqxyK3IYs6dS9nbgeNLwEoBokBVCpRAvfzdj7H1OCTkcxNZUx9kXacWaadffhmLdor7gdeBHUUmJZfrVkqt3TTU=
X-Received: by 2002:a0c:d0b6:: with SMTP id z51mr7718998qvg.3.1559552687749;
 Mon, 03 Jun 2019 02:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com> <20190601125717.28982f35@cakuba.netronome.com>
In-Reply-To: <20190601125717.28982f35@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Jun 2019 11:04:36 +0200
Message-ID: <CAJ+HfNix+oa=9oMOg9pVMiVTiM5sZe5Tn6zTE_Bu6gV5M=B7kQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Jun 2019 at 21:57, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:
> > > +   if (!bpf_op || flags & XDP_FLAGS_SKB_MODE)
> > > +           mode = XDP_FLAGS_SKB_MODE;
> > > +
> > > +   curr_mode = dev_xdp_current_mode(dev);
> > > +
> > > +   if (!offload && curr_mode && (mode ^ curr_mode) &
> > > +       (XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE)) {
> >
> > if i am reading this correctly this is equivalent to :
> >
> > if (!offload && (curre_mode != mode))
> > offlad is false then curr_mode and mode must be DRV or GENERIC ..
>
> Naw, if curr_mode is not set, i.e. nothing installed now, we don't care
> about the diff.
>
> > better if you keep bitwise operations for actual bitmasks, mode and
> > curr_mode are not bitmask, they can hold one value each .. according to
> > your logic..
>
> Well, they hold one bit each, whether one bit is a bitmap perhaps is
> disputable? :)
>
> I think the logic is fine.
>

Hmm, but changing to:

       if (!offload && curr_mode && mode != curr_mode)

is equal, and to Saeed's point, clearer. I'll go that route in a v3.

> What happened to my request to move the change in behaviour for
> disabling to a separate patch, tho, Bjorn? :)

Actually, I left that out completely. This patch doesn't change the
behavior. After I realized how the flags *should* be used, I don't
think my v1 change makes sense anymore. My v1 patch was to give an
error if you tried to disable, say generic if drv was enabled via
"auto detect/no flags". But this is catched by looking at the flags.

What I did, however, was moving the flags check into change_fd so that
the driver doesn't have to do the check. E.g. the Intel drivers didn't
do correct checking of flags.
