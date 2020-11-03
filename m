Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40FD2A3BB7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKCFOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgKCFOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:14:52 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49474C0617A6;
        Mon,  2 Nov 2020 21:14:52 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id m188so13787151ybf.2;
        Mon, 02 Nov 2020 21:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d56GQML4wOLaTJG2TMDSKj1+46fVeag/+bM9XCLXNNU=;
        b=sqclr1Pvhr9PiHCCRFTT+hbnoSDH8UfoFP25z8ifg7TtZJomUI5TFUOZuCsNDo4SWH
         h65yQ1Jc+V00f+wOY/8dh+fsDJMpHnJeukUMs7O+Cx8qleirfZkKLbZRugCn9cq079qz
         xCIgoeCzKq6B+taSVEd3h+vilINqDkZmQ6grYszgd7ODcBKP3Vd7YF8fa9BwE80OEIYf
         qP0nTbGQRPxeUHYPXVFSGgZvC0jrVWt7dGg6N/4xD9O8DI4rzfoABNIaXxjJ24MG7xkI
         XfFyNDE6swuJANNy8e8hqfgQIH4uHKVu1ZnRij5/HM7SKIkmSQdcErJIrYAUPR+0e+Dj
         CFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d56GQML4wOLaTJG2TMDSKj1+46fVeag/+bM9XCLXNNU=;
        b=WDKkkxVE5uEwlONvl8TtE5kJ4UHcHdLj+liUNNt3P9wNLO78P3T6tWqqm0NNitzOQo
         CreneaS/jGA0mc10pOT294tOh9WizdQKRAflz8pT+rz/A1t7w3c2TWcaYeNpjX+zYRpa
         YHAba9KhTPqo4GLgJEc0EGRA522wz2yix1sITtbGBeN7Xm7yin2YOVe5ejmZ9t4YXT69
         hAkwzrX+26qc0hnhj/M96NZqzhnk/L0ErziQzoYShjNtaIEFcXiiWvCoL0X6deukgwSD
         BevQPZ/LBAGCLL9u1PpWaMsCB+4t8NQ2L3rUdcNKE4SiIoA023C5h/iajjGm+cFShsLV
         FvKw==
X-Gm-Message-State: AOAM5318fbqkjXGtjx6OvBqqLTmbruZiI0bQ6UIuoMd1bAa3eGXQaKVd
        Lwn+tPJIsDFfLtD9HRgJU0VM3QClr+vS1vtNqjI=
X-Google-Smtp-Source: ABdhPJzP0eI7aujRRSQbPQF6f+9noa0B8qB6Ew/j7iolIqdFGJuYc61H3jf/yPE6IXVYzsztjuGRqgga2/5QGmmcglw=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr25758024ybg.459.1604380491522;
 Mon, 02 Nov 2020 21:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-7-andrii@kernel.org>
 <507AB3B7-50BF-43CA-82CA-7C24CD5DF8A4@fb.com>
In-Reply-To: <507AB3B7-50BF-43CA-82CA-7C24CD5DF8A4@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 21:14:39 -0800
Message-ID: <CAEf4BzbZtoyFYbQnF7WvyT2xRcbZCPO5u61wzxaz-h42z4WPNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/11] selftests/bpf: add checking of raw type
 dump in BTF writer APIs selftests
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 4:08 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > From: Andrii Nakryiko <andriin@fb.com>
> >
> > Add re-usable btf_helpers.{c,h} to provide BTF-related testing routines. Start
> > with adding a raw BTF dumping helpers.
> >
> > Raw BTF dump is the most succinct and at the same time a very human-friendly
> > way to validate exact contents of BTF types. Cross-validate raw BTF dump and
> > writable BTF in a single selftest. Raw type dump checks also serve as a good
> > self-documentation.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> with a couple nits:
>
> [...]
>
> > +
> > +/* Print raw BTF type dump into a local buffer and return string pointer back.
> > + * Buffer *will* be overwritten by subsequent btf_type_raw_dump() calls
> > + */
> > +const char *btf_type_raw_dump(const struct btf *btf, int type_id)
> > +{
> > +     static char buf[16 * 1024];
> > +     FILE *buf_file;
> > +
> > +     buf_file = fmemopen(buf, sizeof(buf) - 1, "w");
> > +     if (!buf_file) {
> > +             fprintf(stderr, "Failed to open memstream: %d\n", errno);
> > +             return NULL;
> > +     }
> > +
> > +     fprintf_btf_type_raw(buf_file, btf, type_id);
> > +     fflush(buf_file);
> > +     fclose(buf_file);
> > +
> > +     return buf;
> > +}
> > diff --git a/tools/testing/selftests/bpf/btf_helpers.h b/tools/testing/selftests/bpf/btf_helpers.h
> > new file mode 100644
> > index 000000000000..2c9ce1b61dc9
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/btf_helpers.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright (c) 2020 Facebook */
> > +#ifndef __BTF_HELPERS_H
> > +#define __BTF_HELPERS_H
> > +
> > +#include <stdio.h>
> > +#include <bpf/btf.h>
> > +
> > +int fprintf_btf_type_raw(FILE *out, const struct btf *btf, __u32 id);
> > +const char *btf_type_raw_dump(const struct btf *btf, int type_id);
> > +
> > +#endif
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/testing/selftests/bpf/prog_tests/btf_write.c
> > index 314e1e7c36df..bc1412de1b3d 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_write.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
> > @@ -2,6 +2,7 @@
> > /* Copyright (c) 2020 Facebook */
> > #include <test_progs.h>
> > #include <bpf/btf.h>
> > +#include "btf_helpers.h"
> >
> > static int duration = 0;
> >
> > @@ -11,12 +12,12 @@ void test_btf_write() {
> >       const struct btf_member *m;
> >       const struct btf_enum *v;
> >       const struct btf_param *p;
> > -     struct btf *btf;
> > +     struct btf *btf = NULL;
>
> No need to initialize btf.
>
> >       int id, err, str_off;
> >
> >       btf = btf__new_empty();
> >       if (CHECK(IS_ERR(btf), "new_empty", "failed: %ld\n", PTR_ERR(btf)))
> > -             return;
> > +             goto err_out;
>
> err_out is not needed either.

eagle eye ;) fixed both

>
> [...]
