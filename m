Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0666F55
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfGLM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:56:17 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41678 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGLM4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:56:16 -0400
Received: by mail-lf1-f68.google.com with SMTP id 62so1542456lfa.8
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 05:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U8JelDTPii7RGHoiquSk+sGR/pDg+4xXvLkAF8ahtZQ=;
        b=fUDrB8kE/v6rR4yK6uhfirbeXC0QgR/e4Qn7VKWDnDmoLIgARPcO6Yk7mSoja0IY7M
         oFmlnk8fcuuAcdymYl2MLqHImYntORMmfudAdzSZZ9zjrbsoHKpNGDgGEj3z/Hbc5MuL
         MGYVBHdbVZVPXzwUfBTSwimpycfWgGG+uPoLuyAQcoUZjNLPkQ2ZEDkYOGWftOTzQr5x
         WmMhU7R9NzZ4pBHW2AfKChkhlBaEzgvRsd1PTjo4xZKzYOdxBCCgVvdoXaqaoqJaKhQo
         4BWWxr6hENhq99VO7An0RkIEQQZ6FKq5cYu/+EuNSUyhoKTBzFfte/sxpoftIazguxnb
         Zj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U8JelDTPii7RGHoiquSk+sGR/pDg+4xXvLkAF8ahtZQ=;
        b=EiITuJqfjaO5HS7nj3Z3xJT0UWQV/myBWkKWq99rHrowQv30W5pVFnnCGowPVH0aFU
         q3JvzYk07S+a37uXeyVLNUjChsxt+QrnwC2NSyXINFwh8r0urWhgm7t7qnByFFCaGc2v
         HMmFrcY2p1kLc1YBLS0wN7/MrVy8RS45scOgenFgfvyvS44nzfdRCC8vKjAIc0tc6LHr
         kACz2PV/rO2UWTCjehNHqpr6Jo7YzoI5n3dt4qAEFvEL+gctqcmFbyb7v9ugTY9Pgz9h
         sJbkbtk3b2t1yjw8sgvaZ6ZarYVDuJioEe+iTBlqoaTy+wlgkru22upfPOG6iGQo/wQB
         Pq0g==
X-Gm-Message-State: APjAAAXYPYDD+nRmJYJ95ysYOLyi8lWAz6ZPHQayza5WdlYh88lS1sXZ
        4qH5V9eyk2J+61BEN9s18MwZhNvaBgElcTuk5yKrsA==
X-Google-Smtp-Source: APXvYqw97l1oeAA2+th/9cKGGPMGUMu4Ml9+uL71lRvQVwbk2RAIAa9B6Jp9obemUhw5bFYiue963wi+HIWBf7wLYYo=
X-Received: by 2002:a05:6512:29a:: with SMTP id j26mr771352lfp.44.1562936174798;
 Fri, 12 Jul 2019 05:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190709040007.1665882-1-andriin@fb.com> <b4b00fad-3f99-c36a-a510-0b281a1f2bd7@fb.com>
In-Reply-To: <b4b00fad-3f99-c36a-a510-0b281a1f2bd7@fb.com>
From:   Matt Hart <matthew.hart@linaro.org>
Date:   Fri, 12 Jul 2019 13:56:03 +0100
Message-ID: <CAH+k93ExQpYy+g+WUNvv+bDDzDcJR-2WYongJqv4WbMcPV=sRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix ptr to u64 conversion warning on
 32-bit platforms
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 at 05:30, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/8/19 9:00 PM, Andrii Nakryiko wrote:
> > On 32-bit platforms compiler complains about conversion:
> >
> > libbpf.c: In function =E2=80=98perf_event_open_probe=E2=80=99:
> > libbpf.c:4112:17: error: cast from pointer to integer of different
> > size [-Werror=3Dpointer-to-int-cast]
> >    attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe_pa=
th */
> >                   ^
> >
> > Reported-by: Matt Hart <matthew.hart@linaro.org>
> > Fixes: b26500274767 ("libbpf: add kprobe/uprobe attach API")
> > Tested-by: Matt Hart <matthew.hart@linaro.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>
>

How do we get this merged? I see the build failure has now propagated
up to mainline :(

> > ---
> >   tools/lib/bpf/libbpf.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ed07789b3e62..794dd5064ae8 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4126,8 +4126,8 @@ static int perf_event_open_probe(bool uprobe, boo=
l retprobe, const char *name,
> >       }
> >       attr.size =3D sizeof(attr);
> >       attr.type =3D type;
> > -     attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe=
_path */
> > -     attr.config2 =3D offset;                 /* kprobe_addr or probe_=
offset */
> > +     attr.config1 =3D ptr_to_u64(name); /* kprobe_func or uprobe_path =
*/
> > +     attr.config2 =3D offset;           /* kprobe_addr or probe_offset=
 */
> >
> >       /* pid filter is meaningful only for uprobes */
> >       pfd =3D syscall(__NR_perf_event_open, &attr,
> >
