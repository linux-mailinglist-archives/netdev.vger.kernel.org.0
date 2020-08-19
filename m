Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C4824A6EE
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHSTbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSTbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:31:10 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A85C061757;
        Wed, 19 Aug 2020 12:31:10 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x2so13936366ybf.12;
        Wed, 19 Aug 2020 12:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ziAriBUKyH7IkszWBq/xOqvjPZXaDswTd4xrGlRf2M=;
        b=BNndTF2lL85tNPjkxlknag90CkHNw7/DSlAryWFE9jExpfyKFdSydP5sK95o+/GQr5
         tA6/mm2oig9WgTOuzFer3eDCGhsUBHYD7vAvobnVqMrIpIxgD9wa4m40uZ6zVWEuEWmM
         zb8MElmQ3tB5ITEMc6egjZMy+clebjJDwSxZJK435cATG6MVjMMJIEd/TKyusn5lDPW+
         8ewNgtRTDt0hXl7S5BvpqDIR/R6s8AX9iY7r3bfvpnexRbwlwXAHs30XqEvJ8xpa2Wk/
         G0jEsDrqMS77Wf+8ecnlAcev1tbdiGGg2oJlvIvyfcl/XSm3WyQCFpfWUParJnwyTvbg
         QRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ziAriBUKyH7IkszWBq/xOqvjPZXaDswTd4xrGlRf2M=;
        b=CMx07Bp5lmC5va5hGXIuoKbVruOl95PWtg4oOjN/2stoQ9WHSGuM7MwLyCP9feuUEh
         ewtgbtL0BjA6yrtXfAICtP0twGMTB26a+h+tI8Ky8VXb/3nRdTXi9O5YI61cQFUNzuQb
         e2F2EXIGpfrmGl6QeVl7GQiOmMD3YtDIg1zzrcWCqbzJcNf6QVAsCNe7mR7hf11OCEDJ
         CcZgbEHwyfY3Oyh943K45mxdthXexsShtUq+tFi4cjQl6iKmEPbeL+5ThPvif3wJaN9T
         CseKCf76B8T5HF/v/v9j9K4WpU/ULsT7Wn93JWDMGV0Vd9IUvFB5aee96NGX6qrhm07r
         /2Wg==
X-Gm-Message-State: AOAM532Zb5fS5PZPw2baYfVpNHID62SxDnScsY/c9MlGHl/P5j5bmC2w
        cGPzOMKDJIU7ydcQLmGcD5Tz795F0uE5hFGajx4=
X-Google-Smtp-Source: ABdhPJxeRyTEqg3TpkoORnTHJbfXhCoegSyxwPkoYvkXtdad7D8FDze1mCNc0bQlyroBYIc0Nvm45kS4Cqt3cle5LUE=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr34272934ybq.27.1597865469313;
 Wed, 19 Aug 2020 12:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200819052849.336700-1-andriin@fb.com> <20200819052849.336700-4-andriin@fb.com>
 <077f60a0-c457-15a1-ba5e-b2ec37457fcf@fb.com>
In-Reply-To: <077f60a0-c457-15a1-ba5e-b2ec37457fcf@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 12:30:58 -0700
Message-ID: <CAEf4BzZ3QMTJ7r3FKV0ufA8PjOOobM7cHooi=ZGrDk7A-dN3_g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/5] selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 9:43 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> > Add tests for BTF type ID relocations. To allow testing this, enhance
> > core_relo.c test runner to allow dynamic initialization of test inputs.
> > If __builtin_btf_type_id() is not supported by Clang, skip tests.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/core_reloc.c     | 168 +++++++++++++++++-
> >   .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
> >   ...tf__core_reloc_type_id___missing_targets.c |   3 +
> >   .../selftests/bpf/progs/core_reloc_types.h    |  40 +++++
> >   .../bpf/progs/test_core_reloc_type_based.c    |  14 --
> >   .../bpf/progs/test_core_reloc_type_id.c       | 107 +++++++++++
> >   6 files changed, 316 insertions(+), 19 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___missing_targets.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > index b775ce0ede41..ad550510ef69 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > @@ -3,6 +3,9 @@
> >   #include "progs/core_reloc_types.h"
> >   #include <sys/mman.h>
> >   #include <sys/syscall.h>
> > +#include <bpf/btf.h>
> > +
> > +static int duration = 0;
> >
> >   #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
> >
> [...]
> > +
> > +typedef struct a_struct named_struct_typedef;
> > +
> > +typedef int (*func_proto_typedef)(long);
> > +
> > +typedef char arr_typedef[20];
> > +
> > +struct core_reloc_type_id_output {
> > +     int local_anon_struct;
> > +     int local_anon_union;
> > +     int local_anon_enum;
> > +     int local_anon_func_proto_ptr;
> > +     int local_anon_void_ptr;
> > +     int local_anon_arr;
> > +
> > +     int local_struct;
> > +     int local_union;
> > +     int local_enum;
> > +     int local_int;
> > +     int local_struct_typedef;
> > +     int local_func_proto_typedef;
> > +     int local_arr_typedef;
> > +
> > +     int targ_struct;
> > +     int targ_union;
> > +     int targ_enum;
> > +     int targ_int;
> > +     int targ_struct_typedef;
> > +     int targ_func_proto_typedef;
> > +     int targ_arr_typedef;
> > +};
> > +
> > +/* preserve types even if Clang doesn't support built-in */
> > +struct a_struct t1 = {};
> > +union a_union t2 = {};
> > +enum an_enum t3 = 0;
> > +named_struct_typedef t4 = {};
> > +func_proto_typedef t5 = 0;
> > +arr_typedef t6 = {};
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int test_core_type_id(void *ctx)
> > +{
> > +#if __has_builtin(__builtin_btf_type_id)
>
> __builtin_btf_type_id is introduced in llvm11 but has issues for the
> following case:
>     - struct t { ... } is defined
>     - typedef struct t __t is defined
> both "struct t" and "__t" are used in __builtin_btf_type_id in the same
> function. This is a corner case but it will make the test failure with
> llvm11.
>
> I suggest to test builtin __builtin_preserve_type_info here with a
> comment to explain why. This will available test failure with llvm11.
>

ok, makes sense, will add comment and switch

>
> > +     struct core_reloc_type_id_output *out = (void *)&data.out;
> > +
> > +     out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> > +     out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> > +     out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> > +     out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> > +     out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> > +     out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> > +
> > +     out->local_struct = bpf_core_type_id_local(struct a_struct);
> > +     out->local_union = bpf_core_type_id_local(union a_union);
> > +     out->local_enum = bpf_core_type_id_local(enum an_enum);
> > +     out->local_int = bpf_core_type_id_local(int);
> > +     out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> > +     out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> > +     out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> > +
> > +     out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> > +     out->targ_union = bpf_core_type_id_kernel(union a_union);
> > +     out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> > +     out->targ_int = bpf_core_type_id_kernel(int);
> > +     out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> > +     out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> > +     out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);
> > +#else
> > +     data.skip = true;
> > +#endif
> > +
> > +     return 0;
> > +}
> > +
>
> empty line at the end of file?
