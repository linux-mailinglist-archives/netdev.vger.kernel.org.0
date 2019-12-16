Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7300F12094A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfLPPGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:06:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34899 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfLPPGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:06:33 -0500
Received: by mail-lj1-f194.google.com with SMTP id j6so7199682lja.2;
        Mon, 16 Dec 2019 07:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sXR+XaSEkLPT9kSH7VKAdCwPpWDQkSMLm1IXHrgrdUw=;
        b=GTdiXbgTt30q2Juxsw9eIwtN5mS+t2RYeiFJWzg8c/cG4tqz61JS4mLgVIESdeZbuw
         FrruhKLZmY9p5erdrlJ6Caiuq0kEhSCgMCkwesJw+nSCy4FGm5d+6+jNDilBnKA9P28G
         Q6thA3mJmmc3xG4QqX4ObbQ0vabDnGVg1JGWq1rjqkEmcIRpy9tkbhpJ2hm4HR8hzfdC
         WeeBMMIoiQ8hRmrLMzS4IiBueyp0ExrRg7+vf2vLetSOZKJiS/S7kRm1IcvtEsVBEkgU
         Nr8Gw5vZQmW1ANiT7qejsRXxHw1ccCzCH68hcjhbnBOEvi7R8qBBpFzkcyl3v6LWzX9y
         bB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sXR+XaSEkLPT9kSH7VKAdCwPpWDQkSMLm1IXHrgrdUw=;
        b=cAqIKZVGqw1VjdZRrfSeMn74hK+T55rMgNGMohxMXUtBp7+OoVLGYA5Xts/xOQeT1F
         H1fmlohGx54JhbDrpbWSXYdpkBlM20mxeoY6b2zJ/dvxQiAFGEnTIO1t2xRUCSbGu913
         MYIyFycrWvg2Op2xZUE+FBpMjcLQg1XiRzvaVzCejQ9zD6KhdSRixIdFcfPYKLN1bQys
         FTfDbm/o+K+h6IqtQ19Mvxp9ura1VaFlmaEkgxydT6wvMTkYiR2OlSXEUZKdC4kIlk+6
         eZRQVngXBCMP7FZqCyRtKa2/jvTPDQwVDhPxBrcNJStqzAVLFK6qB9PK/dvbmV6aOHH4
         vuCw==
X-Gm-Message-State: APjAAAVQdp7EYNtSpGY4kO/yKPZWExTaVVVvwdTWcB19fLc7uma9feh3
        jD/GCc/Ex189GZl4pcSrSQkcdfuM7gW35NtRFeM=
X-Google-Smtp-Source: APXvYqzn2XixlkwVfQZL19vcyNzrwovTiJEzwIjVzbOs9E8SaAz89Yt6AhH35bETgvqCq84Hl1uirYxSRRStY7v9OXY=
X-Received: by 2002:a2e:999a:: with SMTP id w26mr20227802lji.142.1576508790901;
 Mon, 16 Dec 2019 07:06:30 -0800 (PST)
MIME-Version: 1.0
References: <20191216110742.364456-1-toke@redhat.com> <71b7ba89-7780-8ce1-1b30-67ae6ebc214c@gmail.com>
In-Reply-To: <71b7ba89-7780-8ce1-1b30-67ae6ebc214c@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 07:06:19 -0800
Message-ID: <CAADnVQKhFzGpA0F_rB4uMh25rbNSXeOTMeTKK8QfokevAK9nGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Attach XDP programs in driver mode
 by default
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 7:01 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/16/19 4:07 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > When attaching XDP programs, userspace can set flags to request the att=
ach
> > mode (generic/SKB mode, driver mode or hw offloaded mode). If no such f=
lags
> > are requested, the kernel will attempt to attach in driver mode, and th=
en
> > silently fall back to SKB mode if this fails.
> >
> > The silent fallback is a major source of user confusion, as users will =
try
> > to load a program on a device without XDP support, and instead of an er=
ror
> > they will get the silent fallback behaviour, not notice, and then wonde=
r
> > why performance is not what they were expecting.
> >
> > In an attempt to combat this, let's switch all the samples to default t=
o
> > explicitly requesting driver-mode attach. As part of this, ensure that =
all
> > the userspace utilities have a switch to enable SKB mode. For those tha=
t
> > have a switch to request driver mode, keep it but turn it into a no-op.
> >
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  samples/bpf/xdp1_user.c             |  5 ++++-
> >  samples/bpf/xdp_adjust_tail_user.c  |  5 ++++-
> >  samples/bpf/xdp_fwd_user.c          | 17 ++++++++++++++---
> >  samples/bpf/xdp_redirect_cpu_user.c |  4 ++++
> >  samples/bpf/xdp_redirect_map_user.c |  5 ++++-
> >  samples/bpf/xdp_redirect_user.c     |  5 ++++-
> >  samples/bpf/xdp_router_ipv4_user.c  |  3 +++
> >  samples/bpf/xdp_rxq_info_user.c     |  4 ++++
> >  samples/bpf/xdp_sample_pkts_user.c  | 12 +++++++++---
> >  samples/bpf/xdp_tx_iptunnel_user.c  |  5 ++++-
> >  samples/bpf/xdpsock_user.c          |  5 ++++-
> >  11 files changed, 58 insertions(+), 12 deletions(-)
> >
>
> Acked-by: David Ahern <dsahern@gmail.com>

Applied. Thanks
