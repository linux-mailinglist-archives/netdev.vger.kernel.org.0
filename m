Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8654B4BC065
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 20:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiBRToY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 14:44:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiBRToX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 14:44:23 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B981375A3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:44:05 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id a42so5757311ljq.13
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=334HlX/dJCg7Lf9UeFSBUXZeG8k9kCyhRbzHePH6JcY=;
        b=bnVQPPgFqPWhMLaIn0GjcDlqPlDNmBRKuAysfDoAAaeLMmmMso/C9r8oEqd1LjuQ+g
         OVOApa8Bzzb4XLbxkMk+N8hb1A7k27+bY1FMLzssbC5rzwM2JuueFIymOnOS3SLkuEdK
         DjXXKYGkVv+2tsIdpSiTW1cR+qARQzciX/yds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=334HlX/dJCg7Lf9UeFSBUXZeG8k9kCyhRbzHePH6JcY=;
        b=0u7OeIkHyIR0O19AqGnMQ46bLNvIOgC09Z+aVDTysVTCB7Tk8B9AoTC/wpHRYSX6EU
         n3wYdvJlOpWZf0lH6CmLBTNQrqF7exnhlspcz0mCOArGPydjeA0bzu/2NUkX+5qwBhKL
         c4qEKlsMLZS1rRGALXHZoXytGgotSQft98S2O3BCuNyBl9QR/dBXVTc5tMg0oWSD+ECw
         u5AH0ZcQqHaE2EzeIAbJ3XY98sCqF4+IpbKJq71hxBsRys5CU3DxDY6LCc9FRV2AasDD
         TEuyPZKe4PsfIb353+gnyjcOTujyFDr1P6xHHaVkb1rQF6wXBc72yVJYub5fGjVoAF5t
         JQSw==
X-Gm-Message-State: AOAM533oeFH/hZIfpvyf8fpUuxuPALG92NAawXIALOjpD/lqWvNURETf
        yHg9Jo3kqIkPl9yBtuuIJmg6g69YxOSTelnGp0v4hw==
X-Google-Smtp-Source: ABdhPJwtBlcq66g4JCYA+OeGZ0bnav1/va/3BEGgODtqou3Mpp5MUzayoo3RuGFKjfn6H9UoeTKMkoy+SRYQ1Cz7SbY=
X-Received: by 2002:a2e:990e:0:b0:240:ab6:da94 with SMTP id
 v14-20020a2e990e000000b002400ab6da94mr6732752lji.274.1645213444205; Fri, 18
 Feb 2022 11:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io> <20220215225856.671072-5-mauricio@kinvolk.io>
 <3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com>
In-Reply-To: <3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 18 Feb 2022 14:43:53 -0500
Message-ID: <CAHap4zu255wb+e6_rY9SwWtu+GiedZjnSitOCWksN98jtBu=BQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 4/7] bpftool: Implement "gen min_core_btf" logic
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 11:20 AM Quentin Monnet <quentin@isovalent.com> wro=
te:
>
> 2022-02-15 17:58 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > This commit implements the logic for the gen min_core_btf command.
> > Specifically, it implements the following functions:
> >
> > - minimize_btf(): receives the path of a source and destination BTF
> > files and a list of BPF objects. This function records the relocations
> > for all objects and then generates the BTF file by calling
> > btfgen_get_btf() (implemented in the following commit).
> >
> > - btfgen_record_obj(): loads the BTF and BTF.ext sections of the BPF
> > objects and loops through all CO-RE relocations. It uses
> > bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> > btfgen_record_reloc(), that calls one of the following functions
> > depending on the relocation kind.
> >
> > - btfgen_record_field_relo(): uses the target specification to mark all
> > the types that are involved in a field-based CO-RE relocation. In this
> > case types resolved and marked recursively using btfgen_mark_type().
> > Only the struct and union members (and their types) involved in the
> > relocation are marked to optimize the size of the generated BTF file.
> >
> > - btfgen_record_type_relo(): marks the types involved in a type-based
> > CO-RE relocation. In this case no members for the struct and union type=
s
> > are marked as libbpf doesn't use them while performing this kind of
> > relocation. Pointed types are marked as they are used by libbpf in this
> > case.
> >
> > - btfgen_record_enumval_relo(): marks the whole enum type for enum-base=
d
> > relocations.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/Makefile |   8 +-
> >  tools/bpf/bpftool/gen.c    | 455 ++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 457 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index 94b2c2f4ad43..a137db96bd56 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -34,10 +34,10 @@ LIBBPF_BOOTSTRAP_INCLUDE :=3D $(LIBBPF_BOOTSTRAP_DE=
STDIR)/include
> >  LIBBPF_BOOTSTRAP_HDRS_DIR :=3D $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
> >  LIBBPF_BOOTSTRAP :=3D $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
> >
> > -# We need to copy hashmap.h and nlattr.h which is not otherwise export=
ed by
> > -# libbpf, but still required by bpftool.
> > -LIBBPF_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nl=
attr.h)
> > -LIBBPF_BOOTSTRAP_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_BOOTSTRAP_HDR=
S_DIR)/,hashmap.h)
> > +# We need to copy hashmap.h, nlattr.h, relo_core.h and libbpf_internal=
.h
> > +# which are not otherwise exported by libbpf, but still required by bp=
ftool.
> > +LIBBPF_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nl=
attr.h relo_core.h libbpf_internal.h)
> > +LIBBPF_BOOTSTRAP_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_BOOTSTRAP_HDR=
S_DIR)/,hashmap.h relo_core.h libbpf_internal.h)
> >
> >  $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBB=
PF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
> >       $(QUIET_MKDIR)mkdir -p $@
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 8e066c747691..806001020841 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -14,6 +14,7 @@
> >  #include <unistd.h>
> >  #include <bpf/bpf.h>
> >  #include <bpf/libbpf.h>
> > +#include <bpf/libbpf_internal.h>
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> >  #include <sys/mman.h>
>
> Mauricio, did you try this patch on a system with an old Glibc (< 2.26)
> by any chance? Haven't tried yet but I expect this might break bpftool's
> build when COMPAT_NEED_REALLOCARRAY is set, because in that case gen.c
> pulls <bpf/libbpf_internal.h>, and then <tools/libc_compat.h> (through
> main.h). And libc_compat.h defines reallocarray(), which
> libbpf_internal.h poisons with a GCC pragma.
>

I just tried on Ubuntu 16.04 with Glibc 2.23 and got the error you mentione=
d.

> At least this is what I observe when trying to add your patches to the
> kernel mirror, where reallocarray() is redefined unconditionally. I'm
> trying to figure out if we should fix this mirror-side, or kernel-side.
> (I suppose we still need this compatibility layer, Ubuntu 16.04 seems to
> use Glibc 2.23).
>

I suppose this should be fixed kernel-side, I don't think it's a
particular problem with the mirror. What about only including
`<tools/libc_compat.h>` in the places where reallocarray() is used:
prog.c and xlated_dumper.c?
