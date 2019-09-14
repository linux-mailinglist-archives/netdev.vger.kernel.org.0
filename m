Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652C7B2C7F
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfINR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 13:58:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40681 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfINR6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 13:58:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id m3so5902070wmc.5
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 10:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b4lgHWbzk8zk/b9Xrx7pI8KOuQHRy/s+cNV3hU905G0=;
        b=j5jAYyOLNW3nLm3r5rIaenDxMWo5WsH/4fwAw56fCaLvC6t4NCKLzDY7+GhOL2hKr9
         izKhGvsYkK37Xqzt0wv3rqr9SNvPqWaHO5XQXbfHuQYN/ugMiYSdzhkiUJ7+7TDck1GX
         8/RcjzRUBrpWADOp0cTPkM3QSumZI9i/1csyFwcMCPE1oc3VHO94mV8Ddz7KaRyp5ccl
         aA2FL7o9gvDkKEO3lrKaJACDSTbtKMvtBXKLVvExAjC7WCd9G7bydM9H6Q8mztyJ75Nd
         vD5GH1hmUmrZtPc50AxBI/IcfCKCmg1KsSp4tp0ANDhaFpDKQE/Xx/Zb6mr+JESUrk2W
         QMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b4lgHWbzk8zk/b9Xrx7pI8KOuQHRy/s+cNV3hU905G0=;
        b=AQku64UNYhCsPeTQpyLQgine6JKcwdtutpJp6lprhXU4McIpaSkIlFtOiDQgG7ZO0j
         f9fPF1+cVZX232bfI2f7hZGrgf1+mpac6HhX5salR6z25uVaOHXssXdXAINMoRkxDBki
         9p3Nu73JCr32NUEJMN0zOwtsghxF3SnsH1RBY0qHbdJXNqtfyaRZavevVcqV0bnhHYxc
         G1sAAMin2PZSebd1IuptC7qPBgo7G7TMH4J4ILEIOVPVJPjlFqkuS+as6IvpDBoYxCFq
         CrOeow3TCIt8rDhC436TzmdfWGcW5UQB+CJ2D28hbKNDTc8ZJelhREBQtM7A9Hk4phgP
         rmLA==
X-Gm-Message-State: APjAAAVXkZM4UbNyI3PH+dP8iDiLBvUkLMuRfjFM4yL0jbwz+/IwQE0l
        1X5qHOyD3JLhWYP1vi13vsMKM4lQ7l/ZybBwe5SkKQ==
X-Google-Smtp-Source: APXvYqxf4A6kr2iuVPZUKfI4kQZXbcEGt986KmC755/no64OkR0E0AcWGJrPtr0SMGGdQ6WANaO31dryPZo+trDIryo=
X-Received: by 2002:a05:600c:22c9:: with SMTP id 9mr8155812wmg.133.1568483883018;
 Sat, 14 Sep 2019 10:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190913232332.44036-1-tph@fb.com> <20190913232332.44036-2-tph@fb.com>
 <CADVnQykBFBU5bFLXRr_aRzxNVpNGQRtELG5kd6viGWqO0uyyng@mail.gmail.com>
In-Reply-To: <CADVnQykBFBU5bFLXRr_aRzxNVpNGQRtELG5kd6viGWqO0uyyng@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sat, 14 Sep 2019 13:57:26 -0400
Message-ID: <CACSApvZW3ANwJEpzsY4bxMD1ROiK95j3B-GBkC6T60egvXrHSw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 11:45 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Sep 13, 2019 at 7:23 PM Thomas Higdon <tph@fb.com> wrote:
> >
> > Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> > performance problems --
> > > (1) Usually when we're diagnosing TCP performance problems, we do so
> > > from the sender, since the sender makes most of the
> > > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > > From the sender-side the thing that would be most useful is to see
> > > tp->snd_wnd, the receive window that the receiver has advertised to
> > > the sender.
> >
> > This serves the purpose of adding an additional __u32 to avoid the
> > would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> >
> > Signed-off-by: Thomas Higdon <tph@fb.com>
> > ---
> > changes since v4:
> >  - clarify comment
>
> Acked-by: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for adding the new field!
