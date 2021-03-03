Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CEB32C3EF
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353086AbhCDAJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842513AbhCCIGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 03:06:16 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B4FC061356;
        Tue,  2 Mar 2021 23:56:17 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m1so5291481wml.2;
        Tue, 02 Mar 2021 23:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RBLhxuP0FB1FYDX0AaweN9vB+2psJPwvGQLdI0MwHS8=;
        b=muD1HjbK4kM6y9RuW8+tAGEQ4Hz+bQEPJq19mcEUzqGBhKIG+a+H2syEwD/yfDxlne
         bS7GYyr7s7oC7iHhcvL7rXDe83zcWGlP98XYeMvjmdqX7VPHMVCbp96Oarm8Mf6/9K8g
         sb3F2J98SoxS6x2fc88kP5dKWiBpAX4oEDOF22WjNKz+CFn0Frxt3SyxYbhSq7nWmnUg
         7mqpRbasJAIL0pXkZN+r8Hdo5NwuxTWTWmBQYTv+atMUsrGcGIv0cHWEBF0K0i4Bekze
         xWui0OEvmXhBSe+kMQFcWT1T93PUZAQ1FkHFIpECUx/WGvsZ550um3Ta80uSUbXeP5YS
         aCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RBLhxuP0FB1FYDX0AaweN9vB+2psJPwvGQLdI0MwHS8=;
        b=tXHnnY3DTwfxmkKO+uDcekWiSkaBvgxDxbDqxCeSbwlIH1od7FNsidDy/Br3tVl4uS
         ikgdgHHwnedUAyMxrFx0NGxl7kbo7JiN1j/1EGw+QdsIbTFIG2/EgVIABhqiBeKSqYA8
         I75Zp4xBHURDgVbBX0ROKZNBW6rfaQlAIgp9y0ZAu74cfwmq7Anq5GhYCJlagvsAJe+M
         SYT4tVXZ4vPt72p+i02WSlZNTAVbc8gTGs/ix03Zps5A9NPat3vedcGHhbOnasMugviW
         C7RdO3/uZe/lHAgatN5poOu4GLr21krRb3YTKez7qJIN5DVclUA6bcQ69yUr0ZA1DbDN
         WCJg==
X-Gm-Message-State: AOAM53042i27uDbDVDaS5oeqqEMSMfdgWLJvWOuV5QXBHffk3GL8tPWl
        rhIhozbz1jn8eIACDe8dhFkFgawHqHBvPAV1Gfg=
X-Google-Smtp-Source: ABdhPJwey4QPkurKONqcpTvnGm+YzyEGsL1YeXqvKhK52hqSKst3C5TraCYlOyu4QFkcdP3fzmpSR8oT5pYprWqO6os=
X-Received: by 2002:a1c:b687:: with SMTP id g129mr7920310wmf.165.1614758176228;
 Tue, 02 Mar 2021 23:56:16 -0800 (PST)
MIME-Version: 1.0
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-2-bjorn.topel@gmail.com> <87mtvmx3ec.fsf@toke.dk>
 <939aefb5-8f03-fc5a-9e8b-0b634aafd0a4@intel.com> <87zgzlvoqd.fsf@toke.dk>
In-Reply-To: <87zgzlvoqd.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Mar 2021 08:56:04 +0100
Message-ID: <CAJ+HfNgf2jxL3fGL=ksAM4O3QC2evM-g=+VPBNZ1D-4qyzb4AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] xsk: update rings for load-acquire/store-release
 semantics
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        paulmck@kernel.org, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 11:23, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>
> > On 2021-03-01 17:08, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >>
> >>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>>
> >>> Currently, the AF_XDP rings uses smp_{r,w,}mb() fences on the
> >>> kernel-side. By updating the rings for load-acquire/store-release
> >>> semantics, the full barrier on the consumer side can be replaced with
> >>> improved performance as a nice side-effect.
> >>>
> >>> Note that this change does *not* require similar changes on the
> >>> libbpf/userland side, however it is recommended [1].
> >>>
> >>> On x86-64 systems, by removing the smp_mb() on the Rx and Tx side, th=
e
> >>> l2fwd AF_XDP xdpsock sample performance increases by
> >>> 1%. Weakly-ordered platforms, such as ARM64 might benefit even more.
> >>>
> >>> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-tru=
ck/
> >>>
> >>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>> ---
> >>>   net/xdp/xsk_queue.h | 27 +++++++++++----------------
> >>>   1 file changed, 11 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> >>> index 2823b7c3302d..e24279d8d845 100644
> >>> --- a/net/xdp/xsk_queue.h
> >>> +++ b/net/xdp/xsk_queue.h
> >>> @@ -47,19 +47,18 @@ struct xsk_queue {
> >>>     u64 queue_empty_descs;
> >>>   };
> >>>
> >>> -/* The structure of the shared state of the rings are the same as th=
e
> >>> - * ring buffer in kernel/events/ring_buffer.c. For the Rx and comple=
tion
> >>> - * ring, the kernel is the producer and user space is the consumer. =
For
> >>> - * the Tx and fill rings, the kernel is the consumer and user space =
is
> >>> - * the producer.
> >>> +/* The structure of the shared state of the rings are a simple
> >>> + * circular buffer, as outlined in
> >>> + * Documentation/core-api/circular-buffers.rst. For the Rx and
> >>> + * completion ring, the kernel is the producer and user space is the
> >>> + * consumer. For the Tx and fill rings, the kernel is the consumer a=
nd
> >>> + * user space is the producer.
> >>>    *
> >>>    * producer                         consumer
> >>>    *
> >>> - * if (LOAD ->consumer) {           LOAD ->producer
> >>> - *                    (A)           smp_rmb()       (C)
> >>> + * if (LOAD ->consumer) {  (A)      LOAD.acq ->producer  (C)
> >>
> >> Why is LOAD.acq not needed on the consumer side?
> >>
> >
> > You mean why LOAD.acq is not needed on the *producer* side, i.e. the
> > ->consumer?
>
> Yes, of course! The two words were, like, right next to each other ;)
>
> > The ->consumer is a control dependency for the store, so there is no
> > ordering constraint for ->consumer at producer side. If there's no
> > space, no data is written. So, no barrier is needed there -- at least
> > that has been my perspective.
> >
> > This is very similar to the buffer in
> > Documentation/core-api/circular-buffers.rst. Roping in Paul for some
> > guidance.
>
> Yeah, I did read that, but got thrown off by this bit: "Therefore, the
> unlock-lock pair between consecutive invocations of the consumer
> provides the necessary ordering between the read of the index indicating
> that the consumer has vacated a given element and the write by the
> producer to that same element."
>
> Since there is no lock in the XSK, what provides that guarantee here?
>
>
> Oh, and BTW, when I re-read the rest of the comment in xsk_queue.h
> (below the diagram you are changing in this patch), the text still talks
> about "memory barriers" - maybe that should be updated to
> release/acquire as well while you're changing things?
>

Make sense! I'll make sure to do that for the V2!

Bj=C3=B6rn

> -Toke
>
