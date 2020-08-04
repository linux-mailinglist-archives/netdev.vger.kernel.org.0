Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D120723B578
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgHDHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgHDHRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:17:03 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78852C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 00:17:03 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id x2so955481vkd.8
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 00:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nVX0JhU76pnmY/8wzV7FqPHk6jzvHulpADQL8bNDX7Q=;
        b=sj1GZSK0N25ZpYSCO+Ho3um/k1jO7fCMSpqkD9Uez9+/j3Q2s9OJqHfGrAwWSb5oeq
         z2Wvq6Aq0UoEPStIgzU63dlwhlVmmUYJZm80v6IjaiXAyQYS+Cwe5Ti6fmWnvgZlFrvU
         bia9S0nAh0O1UzDcuOhXjPEzE8tXqz6YvFp7qBDz2zW/fiIT+kVknOfTvXfH3qxbKBCN
         9hUxOl6Wae+RhM7jnjsszmWWvx1AeWcXcgzh0ACHBYgX4x9cV6IGYIONRtPdIZOywCmV
         7t2eN+SqI+stCuUOXM2lh1hhO6QT6U0A11BZrTwdLV9/mnnP9Lw28DFJKKzv1zGx2d/9
         RzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nVX0JhU76pnmY/8wzV7FqPHk6jzvHulpADQL8bNDX7Q=;
        b=p2vlEENiaC3MXnSHoM9s0WJTttxgRjVu+sHv+T0Tl6CrIfT+0UucDoUKyRLgQAa+q9
         VX9MpDl6gPWljk/gK9uHEADBp3T4ijLmwRlWmapO5+NHWl3QpXy15qhJmFXS+N3ojh2Y
         ESn1nxRwSp65Wh1lRfp8HUuAYq6YsiNX0YCQ3KkzZYvW5RY6S7yAiY1Wofk1SC4CvhWf
         QEZgyWRbjkPBIth9yYgCmzhu6a7kxAqWhsjWQYdo1ZtjyAUvK86Ggn6+xFkGJKeX4iQU
         WQED5y5EoaBPx2NfifC1GlmTw7kxZ6BQ8yTcCj2q727D65SPtoSgIFqISGblelUNixDm
         OTFA==
X-Gm-Message-State: AOAM532MAcU0saHUctRPAflU6u/PNCMANdIENWhOaTfTXF4W/cHRKFWM
        FQP12s+WsORjMNBxTI92GhpJUkDtWMM=
X-Google-Smtp-Source: ABdhPJypU1ogszuHonHtAc50rUmMiDQgfUQIFl+PI3b6FLhxY1lBxpOMYQqVefsNP1Oc3ksjyXQuSQ==
X-Received: by 2002:a05:6122:2d1:: with SMTP id k17mr13880103vki.20.1596525421692;
        Tue, 04 Aug 2020 00:17:01 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id w17sm2600018uam.7.2020.08.04.00.17.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 00:17:00 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id r63so12598547uar.9
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 00:17:00 -0700 (PDT)
X-Received: by 2002:ab0:5595:: with SMTP id v21mr4188296uaa.108.1596525419583;
 Tue, 04 Aug 2020 00:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
 <20200803084106.050eb7f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a25ddc6-adaa-d17d-50f4-8f8ab2ed25eb@wanadoo.fr> <69b4c4838cb743e24a79f81de487ac2e494843ef.camel@perches.com>
 <639bc995-9d51-3cb7-a9d1-9979ecd9c912@wanadoo.fr>
In-Reply-To: <639bc995-9d51-3cb7-a9d1-9979ecd9c912@wanadoo.fr>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 4 Aug 2020 09:16:22 +0200
X-Gmail-Original-Message-ID: <CA+FuTSf4hKkS4n5ncLFaBZjGtzVrnneztGmYpzPnwD+xs-scnQ@mail.gmail.com>
Message-ID: <CA+FuTSf4hKkS4n5ncLFaBZjGtzVrnneztGmYpzPnwD+xs-scnQ@mail.gmail.com>
Subject: Re: [PATCH] gve: Fix the size used in a 'dma_free_coherent()' call
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Joe Perches <joe@perches.com>, Jakub Kicinski <kuba@kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        David Miller <davem@davemloft.net>,
        Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 9:50 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 03/08/2020 =C3=A0 21:35, Joe Perches a =C3=A9crit :
> > On Mon, 2020-08-03 at 21:19 +0200, Christophe JAILLET wrote:
> >> Le 03/08/2020 =C3=A0 17:41, Jakub Kicinski a =C3=A9crit :
> >>> On Sun,  2 Aug 2020 16:15:23 +0200 Christophe JAILLET wrote:
> >>>> Update the size used in 'dma_free_coherent()' in order to match the =
one
> >>>> used in the corresponding 'dma_alloc_coherent()'.
> >>>>
> >>>> Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engi=
ne Virtual NIC")
> >>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >>>
> >>> Fixes tag: Fixes: 893ce44df5 ("gve: Add basic driver framework for Co=
mpute Engine Virtual NIC")
> >>> Has these problem(s):
> >>>     - SHA1 should be at least 12 digits long
> >>>       Can be fixed by setting core.abbrev to 12 (or more) or (for git=
 v2.11
> >>>       or later) just making sure it is not set (or set to "auto").
> >>>
> >>
> >> Hi,
> >>
> >> I have git 2.25.1 and core.abbrev is already 12, both in my global
> >> .gitconfig and in the specific .git/gitconfig of my repo.
> >>
> >> I would have expected checkpatch to catch this kind of small issue.
> >> Unless I do something wrong, it doesn't.
> >>
> >> Joe, does it make sense to you and would one of the following patch he=
lp?
> >
> > 18 months ago I sent:
> >
> > https://lore.kernel.org/lkml/40bfc40958fca6e2cc9b86101153aa0715fac4f7.c=
amel@perches.com/
> >
> >
> >
>
> Looks like the same spirit.
> I've not tested, but doesn't the:
>     ($line =3D~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
> at the top short cut the rest of the regex?
>
> I read it as "the line should have something that looks like a commit id
> of 12+ char to process further".
>
> So smaller commit id would not be checked.
> Did I miss something?
>
>
> Basically, my proposal is to replace this 12 by a 5 in order to accept
> smaller strings before checking if it looks well formatted or not.

My attempt from a few years ago: https://lore.kernel.org/patchwork/patch/91=
1726/
