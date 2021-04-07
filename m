Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C9357591
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243760AbhDGULJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhDGULG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:11:06 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14D8C06175F;
        Wed,  7 Apr 2021 13:10:53 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k8so18323444iop.12;
        Wed, 07 Apr 2021 13:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h96VbcSoj8mKhx2i0v1sojDZC+erMxXsZoAnXTC1WKY=;
        b=l8LKpdFlA2VRNJ9VdxaJK9DGI/Ub7HjuElhkVky7SyZdFgbyGCtVUeocZXxWWzH6Uq
         dJn34V656hOu4piWNGVwPcYuqLxsj3qOxveQEJDsXQrz0VIRhFMl3bBRRGOkC1q28OJO
         qLp78W867ZbzBQnssClDnwBUbdPkx4R9QWZ3URrSyC/YmKPxBpdpNGUeIpT1rxTYhzFC
         0Ue9SMY+Ru3SUY0Gm7U8WhHkvHjUEWWWGFD6H5BszltXe3jukNidacmXaXJ0aph81S2D
         XY3V7OdP0D1zd00dHZuvMi2FzfYBEY70YyK2a4zJYTIkYoLTHDx8iaVWEDmOePg5BNW/
         MOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h96VbcSoj8mKhx2i0v1sojDZC+erMxXsZoAnXTC1WKY=;
        b=ZVDW2eqQjM5wKDXHpr6LpXSdibmqYholWB1D2MqbJpnc5eXL0Tc2CkRwLNVfP+ii2Z
         O3tFPcSlszKT/JO/cK4PVBeveZytuq2HaZ9JlhASQ1R/WJn9pe6dZIXYANUgt7wjHD56
         /fCqfeRXQa7TOMR+3EKK3Qai0liXKmsAoKbJ5+ZQ2fVzIw/wVMD66akOz6NmUMshDne6
         UWgxa2OiOOmg6Xb7yUthqizzcdZ3BDviyJDA8Hhiog4x7ut9e+6gBK0JF3r0+X68tBdb
         rYUMz/inKEYZGCGN3sgz83k97w+VoEUADV7NJNpldhZbUbqrQHG8j99VXfSHmdtpGlcv
         sxYw==
X-Gm-Message-State: AOAM531UjRd27OjJESm4WohLqKAYbmZgyPcG7PD/27QBUPaIEtYW0ioi
        GUUYGc2CyJTQsUDwhuSkBbbjo+tKLLkRGNmVEqg=
X-Google-Smtp-Source: ABdhPJzNJNDnaBzh3jb+/hy9dLRNTHYIU+edNNiBw2/xjjUG9YXyN6JxNMmLf5dF88GpHi1ccfWeQR5HJ75vtMjDd0c=
X-Received: by 2002:a6b:e509:: with SMTP id y9mr3963308ioc.191.1617826252754;
 Wed, 07 Apr 2021 13:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185806.377576-1-pctammela@mojatatu.com>
 <CAOftzPgmZSB7oWDLLoO-NEDq3s8LdLxSXdhoaB2feScuTP-JSA@mail.gmail.com> <CAEf4BzaBJH-=iO-P6ZTj3zmycz0VESzBzpZkbVOVTvPaZ9OEaA@mail.gmail.com>
In-Reply-To: <CAEf4BzaBJH-=iO-P6ZTj3zmycz0VESzBzpZkbVOVTvPaZ9OEaA@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Wed, 7 Apr 2021 17:10:41 -0300
Message-ID: <CAKY_9u0KV0dW2_xW9g67r9YWAh9UjVpTAsEVWs3xF2htzzVAYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: clarify flags in ringbuf helpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joe Stringer <joe@cilium.io>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qua., 7 de abr. de 2021 =C3=A0s 16:58, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Wed, Apr 7, 2021 at 11:43 AM Joe Stringer <joe@cilium.io> wrote:
> >
> > Hi Pedro,
> >
> > On Tue, Apr 6, 2021 at 11:58 AM Pedro Tammela <pctammela@gmail.com> wro=
te:
> > >
> > > In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment.
> > >
> > > For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send a
> > > notification to the process if needed.
> > >
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > ---
> > >  include/uapi/linux/bpf.h       | 7 +++++++
> > >  tools/include/uapi/linux/bpf.h | 7 +++++++
> > >  2 files changed, 14 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 49371eba98ba..8c5c7a893b87 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -4061,12 +4061,15 @@ union bpf_attr {
> > >   *             of new data availability is sent.
> > >   *             If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, n=
otification
> > >   *             of new data availability is sent unconditionally.
> > > + *             If **0** is specified in *flags*, notification
> > > + *             of new data availability is sent if needed.
> >
> > Maybe a trivial question, but what does "if needed" mean? Does that
> > mean "when the buffer is full"?
>
> I used to call it ns "adaptive notification", so maybe let's use that
> term instead of "if needed"? It means that in kernel BPF ringbuf code
> will check if the user-space consumer has caught up and consumed all
> the available data. In that case user-space might be waiting
> (sleeping) in epoll_wait() already and not processing samples
> actively. That means that we have to send notification, otherwise
> user-space might never wake up. But if the kernel sees that user-space
> is still processing previous record (consumer position < producer
> position), then we can bypass sending another notification, because
> user-space consumer protocol dictates that it needs to consume all the
> record until consumer position =3D=3D producer position. So no
> notification is necessary for the newly submitted sample, as
> user-space will eventually see it without notification.
>
> Of course there is careful writes and memory ordering involved to make
> sure that we never miss notification.
>
> Does someone want to try to condense it into a succinct description? ;)

OK.

I can try to condense this and perhaps add it as code in the comment?
