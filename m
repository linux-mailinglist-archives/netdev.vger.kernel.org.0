Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6B269497
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgINSPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgINSPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:15:01 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F27FC06174A;
        Mon, 14 Sep 2020 11:15:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h20so556059ybj.8;
        Mon, 14 Sep 2020 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ma08YpN+pO0hWBciZeBb8sMUq8bp4nB2Wu8c3iKzAR0=;
        b=qLOMv5RwTgQZDCrzvkcDts1DvSQOnWcC2yW24ULTUjJJmPf45+Ap9+suCOHlvC/8Ki
         YACxMJvea28A0vdsmURLM1gUiJVvNeTyMe6+02i4SmUT0c/p+FGC+kbscYKplAy32Kyb
         3gPTt5lVGo4+x0hQMv200k5HIp5T2A5XNraLX3C6GLbe0xaMlwh74FHnal+fGHhpUTdf
         1klhrtKgFplSZJeHjsFO3DDEU+bbwDXzaCrBHxwJZC7ZIBMlyTlG1RQMRWrc4P4pyek/
         VOyZ8x+7zypKW97Da8oABFPj2pA4XuID39g5ChhIREeC3yBHslDTHsoPWuuau4OOCV/c
         JZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ma08YpN+pO0hWBciZeBb8sMUq8bp4nB2Wu8c3iKzAR0=;
        b=dV8YuZ2P/1eAiaB7i4y+T1dTJxkeD7UbQLtfnMdOrhlE/zMb/eHtWhWvUBoiRBMRNV
         OsF2Vv6hUa6zi1brJYdOiyJsYctmcu3SrIFnTrNqYXEGPrq1ChHKjS53fJ95ENQ8D3LE
         Rm92uSHr4TmBbMq4a8LYijA/NwGZi0THGI1W3LdLb/j2D5bYa8m+xPbRRVM+yHosLOKi
         YHlgvFoiwDEg48jJjbU8/Vx0XRiDiMySG9TPiRawR2oL34xGnroq8nArW2/28M3b0QkM
         doge7Qyixc3V0M8HjAXL10GDMCK7z3VnNplZowWS6jcP1oaFcC6CLDOECAWL2bp3Mc6q
         j52w==
X-Gm-Message-State: AOAM532bVjffC44knLMfiIkGsNSE1YznOi23Izp3QlNi7aBfrtxhivm3
        maKn7ykMJfDckp3AXOO5pftkmbFfzmnbfXRESnrCY6ux1IM=
X-Google-Smtp-Source: ABdhPJxA0Cq2mtXXCLyfphGWu7wsPfoxBrmXd1DbdN1cfa47zgGp83Hy+0dkzv8bnJAmqIqnHVVE4zlDs5Pz40lmSVI=
X-Received: by 2002:a25:e655:: with SMTP id d82mr23422446ybh.347.1600107300284;
 Mon, 14 Sep 2020 11:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200914181022.925575-1-yhs@fb.com>
In-Reply-To: <20200914181022.925575-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 11:14:49 -0700
Message-ID: <CAEf4BzZ6Y=uEFXZ5ZuR2VkV249xJT5Se0MY9-ZPKnCdY76Ed7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:10 AM Yonghong Song <yhs@fb.com> wrote:
>
> When building bpf selftests like
>   make -C tools/testing/selftests/bpf -j20
> I hit the following errors:
>   ...
>   GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>   <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
>   make[1]: *** Waiting for unfinished jobs....
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
>   ...
>
> I am using:
>   -bash-4.4$ rst2man --version
>   rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>   -bash-4.4$
>
> The Makefile generated final .rst file (e.g., bpftool-cgroup.rst) looks like
>   ...
>       ID       AttachType      AttachFlags     Name
>   \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>   (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>   (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>   (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>   (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>   (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>   (8),\n\t**bpftool-struct_ops**\ (8)\n
>
> The rst2man generated .8 file looks like
> Literal block ends without a blank line; unexpected unindent.
>  .sp
>  n SEEALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**
>  bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**
>  bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**
>  bpftool\-struct_ops**(8)n
>
> Looks like that particular version of rst2man prefers to have actual new line
> instead of \n.
>
> Since `echo -e` may not be available in some environment, let us use `printf`.
> Some comments are added in Makefile to warn that '%' is not allowed in bpftool
> man page names.
>
> Cc: Quentin Monnet <quentin@isovalent.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/bpf/bpftool/Documentation/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
> index 4c9dd1e45244..5dd68d79671e 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -40,11 +40,13 @@ see_also = $(subst " ",, \
>         $(foreach page,$(call list_pages,$(1)),",\n\t**$(page)**\\ (8)") \
>         "\n")
>
> +# using printf for portability as `echo -e` does not work in some
> +# environments. Note that bpftool man page names should not include '%'.
>  $(OUTPUT)%.8: %.rst
>  ifndef RST2MAN_DEP
>         $(error "rst2man not found, but required to generate man pages")
>  endif
> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
> +       $(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@

this doesn't have to be in "$(call ...)"?

>
>  clean: helpers-clean
>         $(call QUIET_CLEAN, Documentation)
> --
> 2.24.1
>
