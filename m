Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E12463EAA
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 20:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhK3Tg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 14:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhK3Tg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 14:36:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAFFC061574;
        Tue, 30 Nov 2021 11:33:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so19088938pja.1;
        Tue, 30 Nov 2021 11:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5j01hsMPKatw6J9LHgeBzeOI5eEAQWOSckfd+vDINY=;
        b=iuZ6AuNS7MOGEn3ec90iQbwYyCJRaUKQ1YBAj1MNYztpNiGfeVdePuMNmt+e7GJNjh
         iNX9vjRXuXknsNaenWk3zi0ucqxVMAr7sMSe6wra3ifAmFZDySVImiIs3wsvNX9fMwcC
         cqxpXA81t/aTbqvBq4foIBWVO1cwBZowDSyg2f3OjAotJum5VcsiDUTCCZtpYJAY//xV
         MJvRSH/qo6R5/SHx1fPtGVJebIz/LC5+uTW4eddBi0PjIkv0tHIOhatYr9nCVFWZmxdl
         Eh7ae4pl1vZQrm/ihWgqIj38H4PAYzIbGLnqq+h2AX7g38yG9wcf8zIw/KGAtQi+PyF5
         If/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5j01hsMPKatw6J9LHgeBzeOI5eEAQWOSckfd+vDINY=;
        b=dRSDq5uteO+WVOeB3kUEwGMh/LfGl9xwTA6v4vic7Ve7X5kw6oZaPtk+BS8hF+xK5I
         HJZbCtnq9YsnGwQ0KKrQprAQySLtTAPpm4XXBqeaI/95jF3a37i7ERmmXezu9lQLxNih
         wPdjB3hD3hwA8euSIdQK+YdusZqtERv7ffeDl5Fo+LUtc1ngty8X2mLXu+w0o/m1SZMX
         j/saFR2q0A/wu9G/YjmRY/D3cf54x5w9PDBPjY/oDS/SGRyvbQ71LTLVD2hawNw8usGf
         xGT+Ks5X+vvwW5/RdXCClFfBP9bPsDcepJ3CyWi6xL7F45c96ffGzIaMJed1+Y4+rCbA
         b//A==
X-Gm-Message-State: AOAM5310XJ2hyS28+w65Oe2nnYkA2uVeb0fHIXzunV/e9AVPlHj3qsJF
        9/YjVDwtI0SN2J+IUh1OGXnqOZleGfYas4BE4wg=
X-Google-Smtp-Source: ABdhPJxKJZ/Q+/rIlw1C7glnp2AXNKSBRuea6fJX6dqLGqUaXI33f583yqTPZWagtJf3Bo+J32GSO11HUmItts5/n1w=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr1218321pja.122.1638300786367;
 Tue, 30 Nov 2021 11:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20211102101536.2958763-1-houtao1@huawei.com> <915a9acd-1831-2470-1490-ec8af4770e28@huawei.com>
In-Reply-To: <915a9acd-1831-2470-1490-ec8af4770e28@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Nov 2021 11:32:54 -0800
Message-ID: <CAADnVQJCBnxOoVC9H=73OvKFwTUv5+aKCLix25eU1Kg6pOkXtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] clean-up for BPF_LOG_KERNEL log level
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 3:48 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi Alexei,
>
> Could you please pick the patchset for v5.16 ?

Sorry it got lost in patchwork.
Please resubmit.

> On 11/2/2021 6:15 PM, Hou Tao wrote:
> > Hi,
> >
> > There are just two clean-up patches for BPF_LOG_KERNEL log level:
> > patch #1 fixes the possible extra newline for bpf_log() and removes
> > the unnecessary calculation and truncation, and patch #2 disallows
> > BPF_LOG_KERNEL log level for bpf_btf_load().
> >
> > Comments are welcome.
> >
> > Regards,
> > Tao
> >
> > Change Log:
> > v3:
> >   * rebased on bpf-next
> >   * address comments from Daniel Borkmann:
> >     patch #1: add prefix "BPF: " instead of "BPF:" for error message
> >     patch #2: remove uncessary parenthesis, keep the max buffer length
> >               setting of btf verifier, and add Fixes tag.
> >
> > v2: https://www.spinics.net/lists/bpf/msg48809.html
> >   * rebased on bpf-next
> >   * patch #1: add a trailing newline if needed (suggested by Martin)
> >   * add patch #2
> >
> > v1: https://www.spinics.net/lists/bpf/msg48550.html
> >
> > Hou Tao (2):
> >   bpf: clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
> >   bpf: disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
> >
> >  include/linux/bpf_verifier.h |  7 +++++++
> >  kernel/bpf/btf.c             |  3 +--
> >  kernel/bpf/verifier.c        | 16 +++++++++-------
> >  3 files changed, 17 insertions(+), 9 deletions(-)
> >
>
