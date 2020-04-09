Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77DF1A39A4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgDISMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 14:12:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42988 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDISMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 14:12:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id b10so677423qtt.9;
        Thu, 09 Apr 2020 11:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SfINGAMNSPnbcTsywzPLPkIFLAeUGN4o5XJ6HHgBN7g=;
        b=LFOoRG+SoLFi68LZVEeqgGREblIvcNTCH5nf0Fge1zfKlBVxq0KJpdoO50uaTr6G3b
         1Wkl/pCdGrD9FIAAgFykd+ug43mDtzJZzi2VSXtCHBQgrE3J0gEjY3lcTH+q8MZKzOV3
         u8OD6rR53HqzmxT8ETomsoJXcIhWTj4+TELPuM1vGJaCFiE6okuyYzvbt0j5GFzYjFHd
         sPS2rhFZRLMCCUmaZu6QmDxFclMrGqOz5zBOxpIfP1d238MUJRGDHYk0AQbseQBTwjOV
         enFnvgU/p2kRi3WMNPi3WjorMxni4mCeWKtifcriAhkhTgxguJ0rhdhhQchymS17J2DQ
         O7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SfINGAMNSPnbcTsywzPLPkIFLAeUGN4o5XJ6HHgBN7g=;
        b=n+DsksuzJX2SJETtJXVR08OkegnkSCbkcb6hqFZaETUJoQ9DQ1lW+S5CeHiEoUTijV
         j5Eg1ykm4TfPCqTUQ2hQkpzBNxsgw4HR/8VEO2dSZovoavuvt3U3lDo5xvhr5hrQT0mc
         Pt6OW91DqOeTcTtuhqUTkb87DgTkX1k8M/bbA/MPrKdgrIRKVz6b5t69Cmpn7asLEVYv
         yZG4fw7nrIt8KpA3CRX6yjneH2LwBT5XV2DKi4x+3xj532Qwz9p0Qu2/91EyLDxoZj2p
         fonRIwRtaj+TzZFi3fV5XX3rB6L/NdVJTrlaHaQ8xs+OP9ILvDOqNZjB/iTTgoVDUJbn
         N6GQ==
X-Gm-Message-State: AGi0Pubd7lmYZWeu7JUeh5AERnQ3cJNc7rK8LOM/AlAjWV5MPG13OWv7
        OBELNRDjwC0zSD9x/lDk4z0Lcl8zDksqs+WKc04=
X-Google-Smtp-Source: APiQypJkrXftfHK0PfrkYgWRX9IMXPBnGKw7FdapS0URdYMkLC2sY4v3/j8AMCeSaNSQ+kbHE6bPK1eEH69ekXKGcmM=
X-Received: by 2002:ac8:4e2c:: with SMTP id d12mr602871qtw.171.1586455937926;
 Thu, 09 Apr 2020 11:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <1586240904-14176-1-git-send-email-komachi.yoshiki@gmail.com>
 <CAEf4BzZaMX=xPSkOdggX6kMa_a2eWZws9W0EiJm7Qf1x1sR+cQ@mail.gmail.com> <CAA6waGJNzgtKuNps6QZn39Nx3L0WJD3F0ikgAUh6-6ZWyMchmw@mail.gmail.com>
In-Reply-To: <CAA6waGJNzgtKuNps6QZn39Nx3L0WJD3F0ikgAUh6-6ZWyMchmw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Apr 2020 11:12:06 -0700
Message-ID: <CAEf4BzaO_m-OQVAuOkMsRC=ePWa95-V8ZpT1C9kWRzrnWZugJQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Make bpf/bpf_helpers.h self-contained
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 10:31 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> 2020=E5=B9=B44=E6=9C=887=E6=97=A5(=E7=81=AB) 15:52 Andrii Nakryiko <andri=
i.nakryiko@gmail.com>:
> >
> > On Mon, Apr 6, 2020 at 11:29 PM Yoshiki Komachi
> > <komachi.yoshiki@gmail.com> wrote:
> > >
> > > I tried to compile a bpf program including bpf_helpers.h, however it
> > > resulted in failure as below:
> > >
> > >   # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/inclu=
de/ \
> > >     -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
> > >   ...
> > >   In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
> > >   linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type na=
me '__u64'
> > >   ...
> > >
> > > This is because bpf_helpers.h depends on linux/types.h and it is not
> > > self-contained. This has been like this long time, but since bpf_help=
ers.h
> > > was moved from selftests private file to libbpf header file, IMO it
> > > should include linux/types.h by itself.
> > >
> > > Fixes: e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian,=
 tracing}.h into libbpf")
> > > Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> > > ---
> > >  tools/lib/bpf/bpf_helpers.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.=
h
> > > index f69cc208778a..d9288e695eb1 100644
> > > --- a/tools/lib/bpf/bpf_helpers.h
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -2,6 +2,7 @@
> > >  #ifndef __BPF_HELPERS__
> > >  #define __BPF_HELPERS__
> > >
> > > +#include <linux/types.h>
> > >  #include "bpf_helper_defs.h"
> >
> > It's actually intentional, so that bpf_helpers.h can be used together
> > with auto-generated (from BTF) vmlinux.h (which will have all the
> > __u64 and other typedefs).
>
> Thanks for kind comments, and I found out that it=E2=80=99s not wrong but=
 intentional.
>
> However users (like me) may not be aware of it at this point, because
> there is no related statement as far as I know. Instead of my previous
> proposal, we should add some comments (e.g., this header needs to
> include either auto-generated (from BTF) vmlinux.h or linux/types.h
> before using) to bpf_helpers.h header, IMO.

Right, documenting various things like this is a sore point with BPF
usage right now. Feel free to send a patch with such comment. Thanks!

>
> > >
> > >  #define __uint(name, val) int (*name)[val]
> > > --
> > > 2.24.1
> > >
