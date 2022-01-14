Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A148E3D9
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiANFoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiANFoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:44:12 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F23C061574;
        Thu, 13 Jan 2022 21:44:12 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b13so31308796edn.0;
        Thu, 13 Jan 2022 21:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2WU/q1u+ncowVTyrtjZBvLYZsp0cbhNEqqLrYsYSJiE=;
        b=nTphanuLAjh3f+296Ts/L2/sCo6omPbhvjF6h3Ynd685DkQvLCxpGrfV+IIwybDo2X
         lyDcj3FumLSC4J7z5dL0OjHq5R8Dj/+nShMtt3631naRgQn/CFxVeuE2Z1FRrMfp2iLY
         xVX06Aa2YXAbXnARRl8nSHGOyK/CBhdLlM6qyz1tiHiaWcr61G/uCtO/Rx3UAaWsSmv+
         GEcjf1u2FA7831B3gGWe3kmiJKGS6K1E5SMrENYkJL6Hzxo58IRZHjhYkie9Zkte1fd0
         mOyNKaR+Yk6WxBlERZAxZbHdH9uais/3+Gb8cYps/JT2nKNqh/8oD83ODUeIo5yvZZ8j
         d0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2WU/q1u+ncowVTyrtjZBvLYZsp0cbhNEqqLrYsYSJiE=;
        b=rsvgezVf+fuwpYu5Q3M9I+5m66RSt+knfTKqdNXiJXWPuaVdBn9ma7kDfE1IJEQyxZ
         uB/hIA1GFJBDjAMK6C237noOForhqG7vMMeLqI/VjBse84Cq+PFP+4NI8Qfdn9JMTazT
         yFGbWWWGoiDhlTfd9liZiZFBmD2YOMLlnOV95U549JLV1bdf7wUgffS+SZz/ScxvmmDx
         4294lCGjF/0Do0ulx7LsbUM5wGS8J3A+et1b9DGYmcmYSqQMItcgZcjigdzwGzuUWDWo
         M0F6w6ZAmCJ/Ko2XrZeZUdtl/gxnejfF1XrDMmAqg7gjZdgOB90xg5CW1y6BsPykpJxm
         sAdg==
X-Gm-Message-State: AOAM530bUn3RS3VQogSeugA2XSelBXpt8P9F2ibxPQLBvvxbjrW0gFjT
        kACkPN+nCPHJ+qw2kIoG6/PYmrT8Mw/M7A8Kqk4MqiGRc6I=
X-Google-Smtp-Source: ABdhPJybJuvKa9LHYBmZuH0qGjLOBlYmhITGXhItw5r4EFL6cdU0GVqd0D4LnpvEqiHg/WVvtBXHH/s2bR5Gj5kINqM=
X-Received: by 2002:a17:906:4781:: with SMTP id cw1mr6550136ejc.116.1642139050856;
 Thu, 13 Jan 2022 21:44:10 -0800 (PST)
MIME-Version: 1.0
References: <20220111192952.49040-1-ivan@cloudflare.com> <CAA93jw6HKLh857nuh2eX2N=siYz5wwQknMaOtpkqLzpfWTGhuA@mail.gmail.com>
 <CABWYdi0ZHYvzzP9SFOCJhnfyMP12Ot9ALEmXg75oeXBWRAD8KQ@mail.gmail.com>
In-Reply-To: <CABWYdi0ZHYvzzP9SFOCJhnfyMP12Ot9ALEmXg75oeXBWRAD8KQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 13 Jan 2022 21:43:57 -0800
Message-ID: <CAA93jw5+LjKLcCaNr5wJGPrXhbjvLhts8hqpKPFx7JeWG4g0AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 2:56 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> On Wed, Jan 12, 2022 at 1:02 PM Dave Taht <dave.taht@gmail.com> wrote:
> > I would not use the word "latency" in this way, I would just say
> > potentially reducing
> > roundtrips...
>
> Roundtrips translate directly into latency on high latency links.

Yes, but with the caveats below. I'm fine with you just saying round trips,
and making this api possible.

It would comfort me further if you could provide an actual scenario.

See also:

https://datatracker.ietf.org/doc/html/rfc6928

which predates packet pacing (are you using sch_fq?)

>
> > and potentially massively increasing packet loss, oversaturating
> > links, and otherwise
> > hurting latency for other applications sharing the link, including the
> > application
> > that advertised an extreme window like this.
>
> The receive window is going to scale up to tcp_rmem[2] with traffic,
> and packet loss won't stop it. That's around 3MiB on anything that's
> not embedded these days.
>
> My understanding is that congestion control on the sender side deals
> with packet loss, bottleneck saturation, and packet pacing. This patch
> only touches the receiving side, letting the client scale up faster if
> they choose to do so. I don't think any out of the box sender will
> make use of this, even if we enable it on the receiver, just because
> the sender's congestion control constraints are lower (like
> initcwnd=3D10).

I've always kind of not liked the sender/reciever "language" in tcp.

they are peers.

> Let me know if any of this doesn't look right to you.
>
> > This overall focus tends to freak me out somewhat, especially when
> > faced with further statements that cloudflare is using an initcwnd of 2=
50!???
>
> Congestion window is a learned property, not a static number. You
> won't get a large initcwnd towards a poor connection.

initcwnd is set globally or on a per route basis.

> We have a dedicated backbone with different properties.

It's not so much that I don't think your backbone can handle this...

... it's the prospect of handing whiskey, car keys and excessive
initcwnd to teenage boys on a saturday night.

--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
