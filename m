Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9982172C7
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgGGPnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:43:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728937AbgGGPnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594136633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZaK9QSQyYf7DIR8AVwkG+JgLWndUt2J7JTotaWNGjYE=;
        b=L+W9X+rqa4JEDyxHqudgNFSzztlRtF5y/N1qpB97EugqNHHMyM53Y36wQP4FaHeZ2ybDKr
        NA1GBu6S51Ps0+S6ST80RVQ7n7IaC188fbGa2Buiw0jWoUe4Y5cg9R61rwrbMRrRsMGZix
        CiwQoKJzqejz6jQMx4g3HFg51VIimOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-yiuHYmjxM8SoktY4QjGiFQ-1; Tue, 07 Jul 2020 11:43:49 -0400
X-MC-Unique: yiuHYmjxM8SoktY4QjGiFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FF31009613;
        Tue,  7 Jul 2020 15:43:46 +0000 (UTC)
Received: from krava (unknown [10.40.195.209])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6888910002A9;
        Tue,  7 Jul 2020 15:43:43 +0000 (UTC)
Date:   Tue, 7 Jul 2020 17:43:42 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 bpf-next 1/9] bpf: Add resolve_btfids tool to resolve
 BTF IDs in ELF object
Message-ID: <20200707154342.GG3424581@krava>
References: <20200703095111.3268961-1-jolsa@kernel.org>
 <20200703095111.3268961-2-jolsa@kernel.org>
 <CAEf4BzYL=tNo9ktTkjgcSyYi-Uj3tyZ1EydKVGVTZvQBaza-Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYL=tNo9ktTkjgcSyYi-Uj3tyZ1EydKVGVTZvQBaza-Aw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 05:34:52PM -0700, Andrii Nakryiko wrote:

SNIP

> > +$(OUTPUT)rbtree.o: ../../lib/rbtree.c FORCE
> > +       $(call rule_mkdir)
> > +       $(call if_changed_dep,cc_o_c)
> > +
> > +$(OUTPUT)zalloc.o: ../../lib/zalloc.c FORCE
> > +       $(call rule_mkdir)
> > +       $(call if_changed_dep,cc_o_c)
> > +
> > +$(OUTPUT)string.o: ../../lib/string.c FORCE
> > +       $(call rule_mkdir)
> > +       $(call if_changed_dep,cc_o_c)
> > +
> > +$(OUTPUT)ctype.o: ../../lib/ctype.c FORCE
> > +       $(call rule_mkdir)
> > +       $(call if_changed_dep,cc_o_c)
> > +
> > +$(OUTPUT)str_error_r.o: ../../lib/str_error_r.c FORCE
> > +       $(call rule_mkdir)
> > +       $(call if_changed_dep,cc_o_c)
> 
> Is Build also a Makefile? If that's the case, why not:
> 
> $(output)%.o: ../../lib/%.c FORCE
>     $(call rule_mkdir)
>     $(call if_changed_dep,cc_o_c)

hum, it is ... I'll try that

> 
> ?
> 
> > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > new file mode 100644
> > index 000000000000..948378ca73d4
> > --- /dev/null
> > +++ b/tools/bpf/resolve_btfids/Makefile
> > @@ -0,0 +1,77 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +include ../../scripts/Makefile.include
> > +
> > +ifeq ($(srctree),)
> > +srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> > +srctree := $(patsubst %/,%,$(dir $(srctree)))
> > +srctree := $(patsubst %/,%,$(dir $(srctree)))
> > +endif
> > +
> > +ifeq ($(V),1)
> > +  Q =
> > +  msg =
> > +else
> > +  Q = @
> > +  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
> > +  MAKEFLAGS=--no-print-directory
> > +endif
> > +
> > +OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> 
> Ok, so this builds nicely for in-tree build, but when I did
> out-of-tree build (I use KBUILD_OUTPUT, haven't checked specifying
> O=whatever), I get:
> 
>   LD      vmlinux
>   BTFIDS  vmlinux
> /data/users/andriin/linux/scripts/link-vmlinux.sh: line 342:
> /data/users/andriin/linux/tools/bpf/resolve_btfids/resolve_btfids: No
> such file or directory
> 
> I suspect because you are assuming OUTPUT to be in srctree? You
> probably need to adjust for out-of-tree mode.

ok, make clean did not clean resolve_btfids, so it was
still there when I tried the out of the tree build..

> 
> > +
> > +LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> > +SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
> > +
> > +BPFOBJ     := $(OUTPUT)/libbpf.a
> > +SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
> 
> [...]
> 
> > +
> > +#define BTF_IDS_SECTION        ".BTF.ids"
> 
> You haven't updated a bunch of places (cover letter, this patch commit
> message, maybe somewhere else) after renaming from .BTF_ids, please
> keep them in sync. Also, while I'm not too strongly against this name,
> it does sound like this section is part of generic BTF format (as is
> .BTF and .BTF.ext), which it is not, because it's so kernel-specific.
> So I'm mildly against it and pro .BTF_ids.

.BTF_ids it is.. I'll change all the places

> 
> > +#define BTF_ID         "__BTF_ID__"
> > +
> > +#define BTF_STRUCT     "struct"
> > +#define BTF_UNION      "union"
> > +#define BTF_TYPEDEF    "typedef"
> > +#define BTF_FUNC       "func"
> > +#define BTF_SET                "set"
> > +
> 
> [...]
> 
> > +}
> > +
> > +static struct btf *btf__parse_raw(const char *file)
> 
> I thought you were going to add this to libbpf itself? Or you planned
> to do a follow up patch later?

yes, I did not want to complicate this patchset more,
and send this change after.. also then there'll be one
more reason to make it a library function ;-)

thanks,
jirka

