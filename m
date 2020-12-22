Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06BE2E1042
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgLVW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgLVW2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:28:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51BC0619D4
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j16so14428221edr.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXXCJxNOpCBp4NlJsQO8DVvVcVphgeVyP9t85wHs/SI=;
        b=oimSZfu1VMPjxWEhw70TDcNBIG6fxgR1bzAwf98C2g10L1UDZ3J47utDbc1Ph5WUyn
         4SZWmLKkaQTyLBySA6q36Kqa29DgbaCu7gceizudiBgdMMvETwfcIrV93VYZIDsAqG5E
         bf5IyMhupzNoOe3/9rtChrR2hekj7BbPVgJaPy58TWG/s4V9eJD4cXTOB2Lak2GeHeJx
         Wssz/+X4vF0QuU2ZneasQQ+9AAjCZpZcf3nz43jEEyetQX0Lnz3nFWZj6PD2hOqNkbit
         cSUj0pJbQ65NtqqdtbtVkBg/2CrNY5hlYfMclxYNVwG0Rax6L16puUN3eVIJLpAKcVXU
         5khw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXXCJxNOpCBp4NlJsQO8DVvVcVphgeVyP9t85wHs/SI=;
        b=JLnKDgErFjq52aEeXXmGkQzZMd5PegL4mcClx7H7vX9FgKNA8HeP4UUXnL/IVfIj0i
         bHxa7a7HeLV+qqoW7FgnvYjNEnlIH0vwPpnMiVRAmciQRXWGITzaIiYlznxZjhJl1Jnn
         a5xqz6XICUXo/e6OGl18NdZCbsLP5ihbUlWJXp5nxqjjRK/vOllIcZesb9CRdsNaK2cy
         oKaZPaOc+4Y2XZZT5ARMmD3V9njl5py7ihzDPzRo47WPwsy8DQdFR3R1FcG9q5EbM3lU
         HTcK9QkmNnDXdXoXaX7x/AW1SUXd3b3idU/FRgCX6ULK0paMhBudxeowL7CvPx5ktUf7
         L8Ag==
X-Gm-Message-State: AOAM530lhst2Z+KSlkeAtR394Y1vws6YZyY9UeqQZbKZPpxQJPQ+rRgf
        F0tWC0iOMirMX9wN2yForIkP2aerluO81FeHLAw=
X-Google-Smtp-Source: ABdhPJwNWLvK9iulefSrQge6jxzWPCWj+MJ4oUVFsWLA3hbdgLncKlmvsYqhHdKAOeiAQijS1JT2IfoWYrl6V7Cszak=
X-Received: by 2002:a05:6402:1386:: with SMTP id b6mr22298852edv.42.1608676012322;
 Tue, 22 Dec 2020 14:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-2-jonathan.lemon@gmail.com> <CAF=yD-+i9o0_+2emOVkBw2JS5JyD+17zw-tJFdHiRyfHOz5LPQ@mail.gmail.com>
 <20201222172158.4b266ljlwtsyrvcj@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201222172158.4b266ljlwtsyrvcj@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 17:26:15 -0500
Message-ID: <CAF=yD-Ky9RSZUhEFxz2SPdq6CGS-kfbUZc29=AmtzY--3SjZmA@mail.gmail.com>
Subject: Re: [PATCH 01/12 v2 RFC] net: group skb_shinfo zerocopy related bits together.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:22 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 09:43:15AM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > In preparation for expanded zerocopy (TX and RX), move
> > > the ZC related bits out of tx_flags into their own flag
> > > word.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >
> > I think it's better to expand tx_flags to a u16 and add the two new
> > flags that you need.
>
> Okay, but in that case, tx_flags is now wrong, since some of these flags
> will also be checked on the rx path.
>
>
> > That allows the additional 7 bits to be used for arbitrary flags, not
> > stranding 8 bits exactly only for zerocopy features.
> >
> > Moving around a few u8's in the same cacheline won't be a problem.
>
> How about rearranging them to form 16 bits, and just calling it 'flags'?

I thought that would be a good idea, but tx_flags is used in a lot
more places than I expected. That will be a lot of renaming. Let's
just either keep the name or add a new field.
