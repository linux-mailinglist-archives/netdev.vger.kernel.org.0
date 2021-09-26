Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044CA418B71
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 00:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhIZWdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 18:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhIZWdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 18:33:17 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FA3C061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 15:31:40 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y197so20288939iof.11
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 15:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GADifsxPf6rlx1ljlWjz0bNnUlI4jY8mfcIMg3D514A=;
        b=OG8yzZZmrFYl5O/xKArVGVG2e/TLj3q2TJVPAOk5V379q5MUgqK5ZbW0Zj+28w+8G4
         m3aUgc7gVFtd0OXF+VPUFGYUMJbB4tY9ZgmPNnjFdeIJ4q/6mJtZ0U+3ju+zC/9rF8Yp
         AyMoZqyc9uVW/VK+8nu7zjvRjgGhlozv4d6JPgyhTn5W2V16JAxbiKyG2tbx5N3zxTdj
         WORpaozYzcnHuacPYSzTgWZhloxKijXvxwtkKq6Re0fE8RAovekF8jNPWczFFx8bWB+a
         KZ3KTKRgMl3UVkiYUu/wEimzWHzNDnzHRdZ7BRj/JoaYeNkwMB6VMI2Xx9Xk8286Ntek
         /akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GADifsxPf6rlx1ljlWjz0bNnUlI4jY8mfcIMg3D514A=;
        b=1fctzfs6+4CM42Yk3x+m0Klc1vZqPCZMiN6E8jF8vpGlsfgQM/F3FsdAmg/apbTqal
         IuEmagHAb6e0ilQsU2N2zHdPrXyNnxv4FytIq+zr1/QnmXytu6uK75W5lWakdKagrnVc
         T5T7ZFm7VFkgmgtLJNc5VhBgMPpq7zFS/cWbob5lLfqQsvGJpFTgg+/fYVUxLWPcn3W2
         B3iSgHEr622bVxWCiV8u8A0UaXZq+V4JJa44T7BCqfGhvJgEIK9+Bi38WgWuyEB8ee2L
         8L+3wqmWx1iDsfrJJcYrJU0+oCMfqGAeqfDk0bewo7RVLxefsZn+zToTdRKi18rGgiZb
         foFA==
X-Gm-Message-State: AOAM533s/6pkzEZYtC/BEB6en/4Bas1VS2LTnDFQKyBjFBHF12JlOvE5
        vCXUkHNO0FCleiRBmKkr4IVO1SVzwlPw1ISIi80=
X-Google-Smtp-Source: ABdhPJy5tQbeFedOJoei61/V5Fw77C3V6tQPqHhEAjazRQ7UHRvHLAiWcGGRkBWZg9LQwa+SB/abrFp7mNiXyygTLX0=
X-Received: by 2002:a6b:cd43:: with SMTP id d64mr17664277iog.28.1632695499305;
 Sun, 26 Sep 2021 15:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
 <20210924132005.264e4e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAK6E8=dH8JYrKcO8tAUbzy6nT=w0eqjAZCnNwWg8qKUMqcwHbQ@mail.gmail.com>
In-Reply-To: <CAK6E8=dH8JYrKcO8tAUbzy6nT=w0eqjAZCnNwWg8qKUMqcwHbQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 26 Sep 2021 15:31:26 -0700
Message-ID: <CAA93jw5=kaQBnxWHDT8mHqWg5PkRRMX31hx77tbxzdnNyC-4Lg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: tracking packets with CE marks in BW rate sample
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luke Hsiao <lukehsiao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 4:43 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Fri, Sep 24, 2021 at 1:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 23 Sep 2021 21:17:07 +0000 Luke Hsiao wrote:
> > > From: Yuchung Cheng <ycheng@google.com>
> > >
> > > In order to track CE marks per rate sample (one round trip), TCP need=
s a
> > > per-skb header field to record the tp->delivered_ce count when the sk=
b
> > > was sent. To make space, we replace the "last_in_flight" field which =
is
> > > used exclusively for NV congestion control. The stat needed by NV can=
 be
> > > alternatively approximated by existing stats tcp_sock delivered and
> > > mss_cache.
> > >
> > > This patch counts the number of packets delivered which have CE marks=
 in
> > > the rate sample, using similar approach of delivery accounting.
> >
> > Is this expected to be used from BPF CC? I don't see a user..
> Great question. Yes the commit message could be more clear that this
> intends for both ebpf-CC or other third party module that use ECN. For
> example bbr2 uses it heavily (bbr2 upstream WIP). This feature is
> useful for congestion control research which many use ECN as core
> signals now.

I am glad a common API to this is emerging. RFC3168 compliant aqms
(fq_codel, pie, cake) can also emit multiple CE marks per RTT, and
the defined response to them is inadequate. Glad you found space!

There is also this ecn problem outstanding elsewhere, that I hope
bbrv2 has looked into?

https://www.bobbriscoe.net/projects/latency/sub-mss-w.pdf

Otherwise:

Reviewed-by: Dave Taht <dave.taht@gmail.com>


--
Fixing Starlink's Latencies: https://www.youtube.com/watch?v=3Dc9gLo6Xrwgw

Dave T=C3=A4ht CEO, TekLibre, LLC
