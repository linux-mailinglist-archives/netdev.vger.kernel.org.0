Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1640BB6ED5
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbfIRVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:30:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41939 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfIRVaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:30:05 -0400
Received: by mail-qt1-f193.google.com with SMTP id x4so1560233qtq.8;
        Wed, 18 Sep 2019 14:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lGoxk8Izv5KBiBWqzGeBm7lOkOJH17/zAEAijmUsBFU=;
        b=kIbLTEk7J344Et4yMH6eYIH/16VIY8PwEwBjYpZ42xfhepqcT34BKVHZo2xqxoP7Hi
         oIcWjAoeIlhVr0Jp7D2nBJ0dPUkaf8p4MD63ikQt8h6o3asuGyhdn+iJLSRKhCEKYbQY
         skb9o2E5TqHgU4I94Q70i/UKz3twW3rR7yU1KbCcbTfYG/6zq5bUIolPZhuEEkV5On9s
         yUUK/IQsvdMexB61rf7lAPKuq0nUkqAqjpYE1mHpWCw7eLZ83FCSdHx5GfTYmuiusV1R
         HVtWwmtHSdlLxkyLWs+L0n7OPD3mLSvBOboTP5aT9mhPOFY68ceetPNN66bwgq39euiO
         V7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lGoxk8Izv5KBiBWqzGeBm7lOkOJH17/zAEAijmUsBFU=;
        b=gNQLUNixYMqOWZemeMwScSK0Lyu7eJvbC+bHxseOR32F95qtMTNVSjD53n1jf5VBFc
         em9lVIRh2t77XFytHPOxx3tskhYdgk0tG1grI+DUvcA2mgW6Vq4oy6BwMNJgTrQNmgaE
         08wxzjfMxlqP6WzfuzDSvG4lHR7NGt04XEyevofeobGSrhcOfAlnikBCGWqg03Ijfp8R
         Q1QMg0ltdNP4z51o/GtwXdc8P0VH9NxP7H1P8SRPa++nxHcP9fgmhl1Bpvrmkw0rO8wY
         AbsDPsUwR38g93HkLehFzLm36lsMElZZGNe82PLUS6STQaRZ7ZImFDZyCHrZdIpdv61G
         AtHQ==
X-Gm-Message-State: APjAAAXtXlGcb6kXGN4l8oW9gYi6KuZdxwJZ/lYHrhtz1s6y0AzOAjys
        Mc3CXJu04EzZFAvOwydToBmcfl4CAkb1OuwGOL0=
X-Google-Smtp-Source: APXvYqwPE8EM+Qpw3Tu4Ktol2H+k7PeVKQUh8iasB/FwUsXBNEy0xfBZYN+0sw+PiKADyhz6BlmDOtWOwvFTaoYz1rM=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr6398594qtn.117.1568842204628;
 Wed, 18 Sep 2019 14:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-10-ivan.khoronzhuk@linaro.org> <CAEf4BzbuPnxAs0A=w60q0jTCy5pb2R-h0uEuT2tmvjsaj4DH4A@mail.gmail.com>
 <20190918103508.GC2908@khorivan>
In-Reply-To: <20190918103508.GC2908@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Sep 2019 14:29:53 -0700
Message-ID: <CAEf4BzYCNrkaMf-LFHYDi78m9jgMDOswh8VYXGcbttJV-3D21w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 09/14] samples: bpf: makefile: use own flags
 but not host when cross compile
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 3:35 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Tue, Sep 17, 2019 at 04:42:07PM -0700, Andrii Nakryiko wrote:
> >On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> While compile natively, the hosts cflags and ldflags are equal to ones
> >> used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
> >> have own, used for target arch. While verification, for arm, arm64 and
> >> x86_64 the following flags were used alsways:
> >>
> >> -Wall
> >> -O2
> >> -fomit-frame-pointer
> >> -Wmissing-prototypes
> >> -Wstrict-prototypes
> >>
> >> So, add them as they were verified and used before adding
> >> Makefile.target, but anyway limit it only for cross compile options as
> >> for host can be some configurations when another options can be used,
> >> So, for host arch samples left all as is, it allows to avoid potential
> >> option mistmatches for existent environments.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  samples/bpf/Makefile | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> index 1579cc16a1c2..b5c87a8b8b51 100644
> >> --- a/samples/bpf/Makefile
> >> +++ b/samples/bpf/Makefile
> >> @@ -178,8 +178,17 @@ CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
> >>  TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
> >>  endif
> >>
> >> +ifdef CROSS_COMPILE
> >> +TPROGS_CFLAGS += -Wall
> >> +TPROGS_CFLAGS += -O2
> >
> >Specifying one arg per line seems like overkill, put them in one line?
> Will combine.
>
> >
> >> +TPROGS_CFLAGS += -fomit-frame-pointer
> >
> >Why this one?
> I've explained in commit msg. The logic is to have as much as close options
> to have smiliar binaries. As those options are used before for hosts and kinda
> cross builds - better follow same way.

I'm just asking why omit frame pointers and make it harder to do stuff
like profiling? What performance benefits are we seeking for in BPF
samples?

>
> >
> >> +TPROGS_CFLAGS += -Wmissing-prototypes
> >> +TPROGS_CFLAGS += -Wstrict-prototypes
> >
> >Are these in some way special that we want them in cross-compile mode only?
> >
> >All of those flags seem useful regardless of cross-compilation or not,
> >shouldn't they be common? I'm a bit lost about the intent here...
> They are common but split is needed to expose it at least. Also host for
> different arches can have some own opts already used that shouldn't be present
> for cross, better not mix it for safety.

We want -Wmissing-prototypes and -Wstrict-prototypes for cross-compile
and non-cross-compile cases, right? So let's specify them as common
set of options, instead of relying on KBUILD_HOSTCFLAGS or
HOST_EXTRACFLAGS to have them. Otherwise we'll be getting extra
warnings for just cross-compile case, which is not good. If you are
worrying about having duplicate -W flags, seems like it's handled by
GCC already, so shouldn't be a problem.

>
> >
> >> +else
> >>  TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
> >>  TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
> >> +endif
> >> +
> >>  TPROGS_CFLAGS += -I$(objtree)/usr/include
> >>  TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
> >>  TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
> >> --
> >> 2.17.1
> >>
>
> --
> Regards,
> Ivan Khoronzhuk
