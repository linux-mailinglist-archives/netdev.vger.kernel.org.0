Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3859316E5C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhBJSTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:19:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233933AbhBJSPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612980853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8BHhQnnib6OW3euOQVL0avOgwILgxfcY0AqmDLBpsB4=;
        b=fjgcuVu+5A5gPGU5fZy1YDuHfCDRZxmdwtcW/GYWLlf002JZAyCdEuaE45h7WaXKwk0vh1
        AsKMVMTyBreXeNQ/OBeRocr6LMTLClxu8OJm8ehw5pSYQ+UkCC8D48TGh3YqX7+NgzbzoZ
        lpAjx9YT42y1z6DYqPyLVEbyjV489eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-_F92rimjN8OXypxoHJ_Exg-1; Wed, 10 Feb 2021 13:14:09 -0500
X-MC-Unique: _F92rimjN8OXypxoHJ_Exg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC322100CCC0;
        Wed, 10 Feb 2021 18:14:06 +0000 (UTC)
Received: from krava (unknown [10.40.195.206])
        by smtp.corp.redhat.com (Postfix) with SMTP id C0FDB60657;
        Wed, 10 Feb 2021 18:14:02 +0000 (UTC)
Date:   Wed, 10 Feb 2021 19:14:01 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Message-ID: <YCQiaRNQFAq4lw79@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86>
 <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 09:52:42AM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 10, 2021 at 9:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> > > The resolve_btfids tool is used during the kernel build,
> > > so we should clean it on kernel's make clean.
> > >
> > > Invoking the the resolve_btfids clean as part of root
> > > 'make clean'.
> > >
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  Makefile | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Makefile b/Makefile
> > > index b0e4767735dc..159d9592b587 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
> > >    endif
> > >  endif
> > >
> > > +PHONY += resolve_btfids_clean
> > > +
> > > +resolve_btfids_clean:
> > > +     $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > > +
> > >  ifdef CONFIG_BPF
> > >  ifdef CONFIG_DEBUG_INFO_BTF
> > >    ifeq ($(has_libelf),1)
> > > @@ -1495,7 +1500,7 @@ vmlinuxclean:
> > >       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > >       $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > >
> > > -clean: archclean vmlinuxclean
> > > +clean: archclean vmlinuxclean resolve_btfids_clean
> > >
> > >  # mrproper - Delete all generated files, including .config
> > >  #
> > > --
> > > 2.26.2
> > >
> >
> > This breaks running distclean on a clean tree (my script just
> > unconditionally runs distclean regardless of the tree state):
> >
> > $ make -s O=build distclean
> > ../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> >
> 
> Can't reproduce it. It works in all kinds of variants (relative and
> absolute O=, clean and not clean trees, etc). Jiri, please check as
> well.

I can reproduce if I set O=XXX to directory that does not contain kernel build

	$ mkdir /tmp/krava
	$ make O=/tmp/krava distclean
	make[1]: Entering directory '/tmp/krava'
	../../scripts/Makefile.include:4: *** O=/tmp/krava/tools/bpf/resolve_btfids does not exist.  Stop.
	make[1]: *** [/home/jolsa/linux/Makefile:1092: resolve_btfids_clean] Error 2
	make[1]: Leaving directory '/tmp/krava'
	make: *** [Makefile:185: __sub-make] Error 2

will check on fix

jirka

