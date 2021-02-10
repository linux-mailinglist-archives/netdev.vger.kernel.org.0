Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E400316EEF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhBJSkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234369AbhBJSiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:38:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFDA864E0D;
        Wed, 10 Feb 2021 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612982242;
        bh=54mO/ww9NbxzFeHwlaXWWgMTv9uIHLgqlJhNXIa/PRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsbSZJbCOYJJRsGCt29PRIwTKNz8Et8X2fXf4pxOiLwee23RqqXdL2Nlg70t27Plm
         WjhtxFT7Xo1+KqYUr+fb117rdwBdjJLWlWHMwpdRjwQ80V1K0C8xcGmnYhvX9WvSeu
         iK7Vm3V1cuyvcOc2smUT2CK7m+617OQxve4REoE3qOg1MPQwPvqFyUpr4fEp38GOtR
         IvZ1tz5Ksi2g/PfikRNrkIwEEasKPB0awv+mtbTnWWa3Zuhf+fFQdqQK7fZGvjDPyh
         mLQrk0WubhAFnYpvzDbf7C1X/95jIX3R4V3AnO2Uv3/qKlde7p9Ql98+ey4rwpXWbb
         mRtCzbvHjSbmg==
Date:   Wed, 10 Feb 2021 11:37:20 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20210210183720.GA4030070@ubuntu-m3-large-x86>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86>
 <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86>
 <YCQmCwBSQuj+bi4q@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCQmCwBSQuj+bi4q@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 07:29:31PM +0100, Jiri Olsa wrote:
> On Wed, Feb 10, 2021 at 11:02:15AM -0700, Nathan Chancellor wrote:
> > On Wed, Feb 10, 2021 at 09:52:42AM -0800, Andrii Nakryiko wrote:
> > > On Wed, Feb 10, 2021 at 9:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
> > > >
> > > > On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> > > > > The resolve_btfids tool is used during the kernel build,
> > > > > so we should clean it on kernel's make clean.
> > > > >
> > > > > Invoking the the resolve_btfids clean as part of root
> > > > > 'make clean'.
> > > > >
> > > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >  Makefile | 7 ++++++-
> > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Makefile b/Makefile
> > > > > index b0e4767735dc..159d9592b587 100644
> > > > > --- a/Makefile
> > > > > +++ b/Makefile
> > > > > @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
> > > > >    endif
> > > > >  endif
> > > > >
> > > > > +PHONY += resolve_btfids_clean
> > > > > +
> > > > > +resolve_btfids_clean:
> > > > > +     $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > > > > +
> > > > >  ifdef CONFIG_BPF
> > > > >  ifdef CONFIG_DEBUG_INFO_BTF
> > > > >    ifeq ($(has_libelf),1)
> > > > > @@ -1495,7 +1500,7 @@ vmlinuxclean:
> > > > >       $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> > > > >       $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
> > > > >
> > > > > -clean: archclean vmlinuxclean
> > > > > +clean: archclean vmlinuxclean resolve_btfids_clean
> > > > >
> > > > >  # mrproper - Delete all generated files, including .config
> > > > >  #
> > > > > --
> > > > > 2.26.2
> > > > >
> > > >
> > > > This breaks running distclean on a clean tree (my script just
> > > > unconditionally runs distclean regardless of the tree state):
> > > >
> > > > $ make -s O=build distclean
> > > > ../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > > >
> > > 
> > > Can't reproduce it. It works in all kinds of variants (relative and
> > > absolute O=, clean and not clean trees, etc). Jiri, please check as
> > > well.
> > > 
> > 
> > Odd, this reproduces for me on a completely clean checkout of bpf-next:
> > 
> > $ git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> > 
> > $ cd bpf-next
> > 
> > $ make -s O=build distclean
> > ../../scripts/Makefile.include:4: *** O=/tmp/bpf-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > 
> > I do not really see how this could be environment related. It seems like
> > this comes from tools/scripts/Makefile.include, where there is no
> > guarantee that $(O) is created before being used like in the main
> > Makefile?
> 
> right, we need to handle the case where tools/bpf/resolve_btfids
> does not exist, patch below fixes it for me
> 
> jirka

Yes, this seems to work fine for me as well.

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> diff --git a/Makefile b/Makefile
> index 159d9592b587..ce9685961abe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1088,8 +1088,14 @@ endif
>  
>  PHONY += resolve_btfids_clean
>  
> +resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
> +
> +# tools/bpf/resolve_btfids directory might not exist
> +# in output directory, skip its clean in that case
>  resolve_btfids_clean:
> -	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> +ifneq (,$(wildcard $(resolve_btfids_O)))
> +	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
> +endif
>  
>  ifdef CONFIG_BPF
>  ifdef CONFIG_DEBUG_INFO_BTF
> 
