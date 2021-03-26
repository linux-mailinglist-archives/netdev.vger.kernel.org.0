Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1138434AE5B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhCZSOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhCZSOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:14:15 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FB2C0613AA;
        Fri, 26 Mar 2021 11:14:15 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id g38so6696827ybi.12;
        Fri, 26 Mar 2021 11:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7jCXw5WhLD4gFwSc47Z8JTVPcESTWmnce5WlZ5xDsXw=;
        b=M/KMGzwkT5ztwEONqvZ2mccfYiPnkZwWXGvvB7SnvJYgDSxVlvyOfy0roWdv/oUQPb
         NHjYpejp0DpguLaNoNJHmHSt6V2zFwGbi0HmGorzgGEPMmFMJSf4gmYXDfcIYGTuTcZY
         t+bIGMvm/AoolKhuQ74bX97AJdNI2NmC6KJRDhuCGFllbpoqapS+u/SXr+wKX2OalXph
         MQmkHWGQZqpwh8ND1uWT25TDNuE6lAndRsztWqCpQWKOBuR+12iP8zOkQ8NDbubsU2LE
         fDnafC+SJ+1jUDtrHCf8tkEMuNVNSAgSXC3it4sIb4XpgU4bOkcmdiOh9c+3NlyjdMZ+
         F7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7jCXw5WhLD4gFwSc47Z8JTVPcESTWmnce5WlZ5xDsXw=;
        b=p6o+DPZb+729Aut9tEdxU6W8j8wYgcuM82uJf20Pe9vp6MGTsnGbXG33gDCPwoQLPf
         v9aO2jN8UF7EdSf1UcSwexOQZdiiqQ43CGvCf0bS3PwY5SIrxoYLKZyF/uPpc0BTKCA8
         nVuH7mse26PlxvLWCLeSgcKsnRda/nq7i22uHKo2kfbwmNqGTAvorY+nrYU0IFt23tOF
         RAr1i6VEeIT1rN6/vUdtQUJ3DBx1lYkouGtc7R8JPRWWG/WjDRQ7yizFlBo5EoyPPSZ6
         7LujwT8OpEV3+eL3smKTs6gqX1VCMB98aKBfp+hNPZlEqXNtmbGFr/ngnjxcUVObgvcf
         23+g==
X-Gm-Message-State: AOAM5306GyZn3w+x8QZpwRIScQrBxBUmwZgaTJ87Vd2g3GTk6VdRmrlB
        xVT4yN/8A9JHRlF3uLidivrjofwJgT+jc3rJPum9gjWevJk=
X-Google-Smtp-Source: ABdhPJy7y8LfgpzxLfxt0+hBYhrQpknZNwwZsZtDpaRmkahve8A0x3SzZyQ/F/GZQv1T4DW4tngn7SJEbLWoXDlDALw=
X-Received: by 2002:a25:9942:: with SMTP id n2mr20755555ybo.230.1616782454425;
 Fri, 26 Mar 2021 11:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210325211122.98620-1-toke@redhat.com> <20210325211122.98620-2-toke@redhat.com>
 <CAEf4BzaxmrWFBJ1mzzWzu0yb_iFX528cAFVbXrncPEaJBXrd2A@mail.gmail.com> <87lfaacks9.fsf@toke.dk>
In-Reply-To: <87lfaacks9.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 11:14:03 -0700
Message-ID: <CAEf4BzaucswGy+LiXQC0q_zgQEOTtRJ3GQtaeq7CwJJW9EzGig@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf/selftests: test that kernel rejects a TCP
 CC with an invalid license
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- Andrii

On Fri, Mar 26, 2021 at 2:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Mar 25, 2021 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> This adds a selftest to check that the verifier rejects a TCP CC struc=
t_ops
> >> with a non-GPL license.
> >>
> >> v2:
> >> - Use a minimal struct_ops BPF program instead of rewriting bpf_dctcp'=
s
> >>   license in memory.
> >> - Check for the verifier reject message instead of just the return cod=
e.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 44 ++++++++++++++++++=
+
> >>  .../selftests/bpf/progs/bpf_nogpltcp.c        | 19 ++++++++
> >>  2 files changed, 63 insertions(+)
> >>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_nogpltcp.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/too=
ls/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> >> index 37c5494a0381..a09c716528e1 100644
> >> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> >> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> >> @@ -6,6 +6,7 @@
> >>  #include <test_progs.h>
> >>  #include "bpf_dctcp.skel.h"
> >>  #include "bpf_cubic.skel.h"
> >> +#include "bpf_nogpltcp.skel.h"
> >
> > total nit, but my eyes can't read "nogpltcp"... wouldn't
> > "bpf_tcp_nogpl" be a bit easier?
>
> Haha, yeah, good point - my eyes also just lump it into a blob...

thanks

>
> >>
> >>  #define min(a, b) ((a) < (b) ? (a) : (b))
> >>
> >> @@ -227,10 +228,53 @@ static void test_dctcp(void)
> >>         bpf_dctcp__destroy(dctcp_skel);
> >>  }
> >>
> >> +static char *err_str =3D NULL;
> >> +static bool found =3D false;
> >> +
> >> +static int libbpf_debug_print(enum libbpf_print_level level,
> >> +                             const char *format, va_list args)
> >> +{
> >> +       char *log_buf;
> >> +
> >> +       if (level !=3D LIBBPF_WARN ||
> >> +           strcmp(format, "libbpf: \n%s\n")) {
> >> +               vprintf(format, args);
> >> +               return 0;
> >> +       }
> >> +
> >> +       log_buf =3D va_arg(args, char *);
> >> +       if (!log_buf)
> >> +               goto out;
> >> +       if (err_str && strstr(log_buf, err_str) !=3D NULL)
> >> +               found =3D true;
> >> +out:
> >> +       printf(format, log_buf);
> >> +       return 0;
> >> +}
> >> +
> >> +static void test_invalid_license(void)
> >> +{
> >> +       libbpf_print_fn_t old_print_fn =3D NULL;
> >> +       struct bpf_nogpltcp *skel;
> >> +
> >> +       err_str =3D "struct ops programs must have a GPL compatible li=
cense";
> >> +       old_print_fn =3D libbpf_set_print(libbpf_debug_print);
> >> +
> >> +       skel =3D bpf_nogpltcp__open_and_load();
> >> +       if (CHECK(skel, "bpf_nogplgtcp__open_and_load()", "didn't fail=
\n"))
> >
> > ASSERT_OK_PTR()
> >
> >> +               bpf_nogpltcp__destroy(skel);
> >
> > you should destroy unconditionally
> >
> >> +
> >> +       CHECK(!found, "errmsg check", "expected string '%s'", err_str)=
;
> >
> > ASSERT_EQ(found, true, "expected_err_msg");
> >
> > I can never be sure which way CHECK() is checking
>
> Ah, thanks! I always get confused about CHECK() as well! Maybe it should
> be renamed to ASSERT()? But that would require flipping all the if()
> statements around them as well :/

Exactly, it's the opposite of assert (ASSERT_NOT %-), that
CHECK(!found) is "assert not not found", right?) and it throws me off
every. single. time. Ideally we complete the set of ASSERT_XXX()
macros and convert as much as possible to that. We can also have just
generic ASSERT() for all other complicated cases.

>
> -Toke
>
