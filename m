Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A012D3024
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgLHQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgLHQrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 11:47:02 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F90C061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 08:46:22 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z5so17485965iob.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 08:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NvpbqwbPJki2u8VsrxrP9+nMQ2t6nxTE6Aeuf056+CU=;
        b=qL7wV2ElMGzCdEyF4OrnjGJY+VvXg4ee0SZft3iCc5YuqvO5Spr9m3GfOWUex8bzEA
         2UnerZu1bpMRVBw/bdxi6O6Zi69soxpA0o0VflBQQ8eJwktW9DqzvM/qXNflDGpyzi+A
         3d37qKuJNHUQdhLYqpp0YFxbZBp8Yo2mgJHsXK859NLJ16ew+Oa+GjdPzRtmuXuqe/AV
         tqD7/t11ssLYYvwgvvnjVFyw+c3yW7URfhUhZcC7EnUUw/fKf3mhqjvMnN3pzLMP8xTs
         DOF+/lLL8cHA6jUSYMTVEBhoVi6gDs1KJV6LPDR9qLBEp434U3TqvrL8pMo0Vzr9wa9c
         V1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NvpbqwbPJki2u8VsrxrP9+nMQ2t6nxTE6Aeuf056+CU=;
        b=a0Wp/FY/UoIw7PzLpwWPDX0ZqcGGG/Evoz1oKwEqnqKpK5jjXNIf6H1KqCP3HAgmhn
         MIMJjSz/XrDtl9IACTjT++G560bTfJmgia94w0jbmZuHsp38Gsx5eugfyIQqKp+2oqfQ
         U3ciRjGQNMeKzk7X34JvME4gmuFQA3c/EzPBZ9/BhELv8xf1OXvzcbQ7dfPO+ImOOF8H
         VCm2AZrGXAcINhQQgrVxwpFRcYSiuDfimV5g1ITm2hCTdTDraWsrdKE40jgUMkAciRu8
         Kmrq8dgWuXRX0HgehZRSYVEfGjNjrpP+c2mWkFnV1qlcoARRaydrAYWnF+/EFufgSXio
         Pe2g==
X-Gm-Message-State: AOAM5307FIFQ+yMLX1P1WkeGzYXjwPuyUrsxrtcIKISPvYkxitO6Yw2J
        y2/sT9amoJKQrafRp8Fjpq3BAK2W0KnORhJQ2ro/aw==
X-Google-Smtp-Source: ABdhPJzew/YVp2s6Q135ZQnN7YOuOVr2Hy+7Vo/6yudu68zhD5wD2uYRgbBfe4ItoKtQy8SieGlW/NROk/h1xgqjIO0=
X-Received: by 2002:a5d:9f0b:: with SMTP id q11mr22564943iot.157.1607445981502;
 Tue, 08 Dec 2020 08:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com> <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com>
 <170D5DF4-443F-47F6-B645-A8762E17A475@amazon.com> <CANn89iK_dheHnVjbtg=QkgF=Ng8dYMGfL2RR_3NRv8gwfbgaAQ@mail.gmail.com>
 <40735F4F-7BEC-4342-A9B1-A8780727C94A@amazon.com>
In-Reply-To: <40735F4F-7BEC-4342-A9B1-A8780727C94A@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Dec 2020 17:46:10 +0100
Message-ID: <CANn89iJJcW6PerA=aOXH-5gMHBgHF6hgA6tsem2XxYi=Vmsz-Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 5:28 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
>     >Please try again, with a fixed tcp_rmem[1] on receiver, taking into
>     >account bigger memory requirement for MTU 9000
>
>     >Rationale : TCP should be ready to receive 10 full frames before
>     >autotuning takes place (these 10 MSS are typically in a single GRO
>    > packet)
>
>     >At 9000 MTU, one frame typically consumes 12KB (or 16KB on some arch=
es/drivers)
>
>    >TCP uses a 50% factor rule, accounting 18000 bytes of kernel memory p=
er MSS.
>
>     ->
>
>     >echo "4096 180000 15728640" >/proc/sys/net/ipv4/tcp_rmem
>
>
>
> >diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> >index 9e8a6c1aa0190cc248b3b99b073a4c6e45884cf5..81b5d9375860ae583e08045f=
b25b089c456c60ab
> >100644
> >--- a/net/ipv4/tcp_input.c
> >+++ b/net/ipv4/tcp_input.c
> >@@ -534,6 +534,7 @@ static void tcp_init_buffer_space(struct sock *sk)
> >
> >        tp->rcv_ssthresh =3D min(tp->rcv_ssthresh, tp->window_clamp);
> >       tp->snd_cwnd_stamp =3D tcp_jiffies32;
> >+       tp->rcvq_space.space =3D min(tp->rcv_ssthresh, tp->rcvq_space.sp=
ace);
> >}
>
> Yes this worked and it looks like echo "4096 140000 15728640" >/proc/sys/=
net/ipv4/tcp_rmem is actually enough to trigger TCP autotuning, if the curr=
ent default tcp_rmem[1] doesn't work well with 9000 MTU I am curious to kno=
w  if there is specific reason behind having 131072 specifically   as  tcp_=
rmem[1]?I think the number itself has to be divisible by page size (4K) and=
 16KB given what you said that each Jumbo frame packet may consume up to 16=
KB.


I think the idea behind the value of 131072 was that because TCP RWIN
was set to 65535, we had to reserve twice this amount of memory ->
131072 bytes.

Assuming DRS works well, the exact value should matter only for
unresponsive applications (slow to read/drain the receive queue),
since DRS is delayed for them.
