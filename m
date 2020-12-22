Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D162E106F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 00:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgLVW52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgLVW52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:57:28 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F233C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:56:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g24so14447876edw.9
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMlTOH0Mx0ISmGiq4H79vMY9g5aGKqlyflgk/f8xC2s=;
        b=kClIXGOXcjECjT634imvhxDiL34WdRdZGQiZ1mx1y4wBS94f5NCvgv9vlAtcTymK32
         r8Fs9S2IhxZ52kD4CfVot0uaaHWCgaIAF6TP0jp8KptXvlMjfpz1H61g3webVS59Edco
         mP+pkyr/ZR+RwF1EW+cJZZsFJdJP1mBfUTVm1gLlcL6PqbVgKIRYVPU+xhWaBwywqU3q
         lmd3FjCEam5pa1U68vcSFFFvshp3r+Hp4a3ngav1AWgCmEllk6jCGzZkZvJ14d37nlUb
         S9YPdr1iwqPPMPuAiEwRF/Ba0cqYKfWSuSnkDtsYTcG2sEMzDjBw9FpPUJq5UHuZ99wJ
         tFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMlTOH0Mx0ISmGiq4H79vMY9g5aGKqlyflgk/f8xC2s=;
        b=oldcMTOiE0Yv/k+cSPul3qup6dUa17Od+UYnY8yCP3t1pbNqUOyMnVP1utxTQyPjUb
         msgouSfxlwGoVTQDvFH0OYJ44l2re5HJMSnIHKoX7fMZpBbG7ASlkaUPxsAfOPWDUa/F
         90ZeAi14w1o48rezdCpf25TjKQQMSDK/icXxBM0f7DAa3Ux6/hfypSNCV+ir2zXEzagl
         ZA7pfCsMMgwJf99wgBfRHOvQzABhsR0rMx+PsLfzQ4M4RtfbD2/TfD5Igx/PVsJ23HZF
         IMluUtIgzCeNGTrwc5kqAVtj+U/vrNlxZ4XT5b9KxsXM8aEmmoHNtQUXYoCMxLl6GfH3
         KYPw==
X-Gm-Message-State: AOAM531mUdrHSBlU0xx3QKGYuVJjZ5A8rGT/1fZkZXY4+cNzN1BZamJu
        5/Vxxttj2Zmfwl2hqNKQq87FBTAflq9y1cQyi+k=
X-Google-Smtp-Source: ABdhPJwPXh3AthRBiyvQtV5FsQB4rVHMC9cvsJbYMRB5GyAjAhr31//GRehiMmC+P6osxgDqk7nbQjXsFbCb4kghhYI=
X-Received: by 2002:aa7:c603:: with SMTP id h3mr17795176edq.254.1608677806454;
 Tue, 22 Dec 2020 14:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-2-jonathan.lemon@gmail.com> <CAF=yD-+i9o0_+2emOVkBw2JS5JyD+17zw-tJFdHiRyfHOz5LPQ@mail.gmail.com>
 <20201222172158.4b266ljlwtsyrvcj@bsd-mbp.dhcp.thefacebook.com>
 <CAF=yD-Ky9RSZUhEFxz2SPdq6CGS-kfbUZc29=AmtzY--3SjZmA@mail.gmail.com> <20201222224011.tk6iykdcg4d5f4yb@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201222224011.tk6iykdcg4d5f4yb@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 17:56:09 -0500
Message-ID: <CAF=yD-J+KAM-Rs-C_jHtmBDL=wOOYYB6yP0t9dYWv-MXfo87BA@mail.gmail.com>
Subject: Re: [PATCH 01/12 v2 RFC] net: group skb_shinfo zerocopy related bits together.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 5:40 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 05:26:15PM -0500, Willem de Bruijn wrote:
> > On Tue, Dec 22, 2020 at 12:22 PM Jonathan Lemon
> > <jonathan.lemon@gmail.com> wrote:
> > >
> > > On Tue, Dec 22, 2020 at 09:43:15AM -0500, Willem de Bruijn wrote:
> > > > On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > > >
> > > > > From: Jonathan Lemon <bsd@fb.com>
> > > > >
> > > > > In preparation for expanded zerocopy (TX and RX), move
> > > > > the ZC related bits out of tx_flags into their own flag
> > > > > word.
> > > > >
> > > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > >
> > > > I think it's better to expand tx_flags to a u16 and add the two new
> > > > flags that you need.
> > >
> > > Okay, but in that case, tx_flags is now wrong, since some of these flags
> > > will also be checked on the rx path.
> > >
> > >
> > > > That allows the additional 7 bits to be used for arbitrary flags, not
> > > > stranding 8 bits exactly only for zerocopy features.
> > > >
> > > > Moving around a few u8's in the same cacheline won't be a problem.
> > >
> > > How about rearranging them to form 16 bits, and just calling it 'flags'?
> >
> > I thought that would be a good idea, but tx_flags is used in a lot
> > more places than I expected. That will be a lot of renaming. Let's
> > just either keep the name or add a new field.
>
> Hmm, which?  I went with "add new field" = zc_flags.  I can rename this
> to something else if that's too specific.  Suggestions?

Just flags, for now? High order bit is to not move and rename all the
existing flags for the sake of it. Name itself is less important.
