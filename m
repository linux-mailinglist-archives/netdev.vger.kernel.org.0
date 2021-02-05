Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C633101C5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBEAnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhBEAne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 19:43:34 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886A7C06178A;
        Thu,  4 Feb 2021 16:42:52 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id w204so5121587ybg.2;
        Thu, 04 Feb 2021 16:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D6i7Oinnx5ftOJvJSI5dtil0RLEVgRMyQjS9mzKj7sM=;
        b=YS5jRGTpXoPoyjksLLqF16ikzDGVhGlOcUWBsnn2QVmGMhBcR+mQQxsKDLUcDSZLIB
         tZB5Rys0cSHSpXQ6aNSzT9nevBwLu1k1SM4spujUxooEOO2VtjqfjfJp7OonalliTxne
         287GlUeM59y5gYfo1JRfduNPLb4lKysoN7zc7sPq7vG141IHWYrcT2gxoSHqKo0pwEdM
         qoy7Tu/ji+6qbg32RE+dlwqzo6YHK7CskroosBcV2T9dKjbwEdjlZjQFgdULrgV9/u0o
         A+a/gqXNEXAHKrIG2fT3XchnAWG6O02KXTLP1WNPgW3PuG0+4d4XhFNLu6fKRTH7eFQN
         643Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D6i7Oinnx5ftOJvJSI5dtil0RLEVgRMyQjS9mzKj7sM=;
        b=kMm+ai8m3y6xRwONn906vabsmqdTk+B3HSHAqP6iNRTxlR62e5CQPNx2A2Ek5DrVsb
         AnhsUGSSvj2kYYDhGwdeLzF4ojmUKi3drLP49RpON15Uaif19gFYeGxnAnsNsUYKG2L3
         Cm0+BoejRndvd027t4cEkk3nIzFTsRW9d8VcvE8y5l7sYYHfMq1Ziwa8gdCMbTj/E2ps
         Zj3U7fvwMyS92NMtux/SVhMK4kxdSbCvGP2TFg/xfxVCt2xezxBAWvoxHklipsviff5F
         cvPfTnQX4Ux5XNmQ37965IOVjkYdS6kbCJJL5viuO88KbPU6YynuSI4ZunFl4nPrgQnF
         74yQ==
X-Gm-Message-State: AOAM530JBZSL0LJmFcGsxE/wyjng+Fe1qtKYBuXXUN3zSNQXFFmhyliH
        8zeTcuIOdNAurVAgOoJiysXtQDIAlhpJ98j2KYFkx3KfLK9H1Q==
X-Google-Smtp-Source: ABdhPJxzbgK/gW63CT+c9eNPZCIySr18BJGzO0eJUOIZ4OWw5zmoNd8MDK7y7wLAw3/rLSOzXP9XpjgpQw8lIyvmchM=
X-Received: by 2002:a25:d844:: with SMTP id p65mr2526202ybg.27.1612485771876;
 Thu, 04 Feb 2021 16:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20210129134855.195810-1-jolsa@redhat.com> <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-3-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Feb 2021 16:42:41 -0800
Message-ID: <CAEf4Bzb+Mf-Md1-T+K0ZPUUQKX_6efJLPrLDfKqijJFPdRc02A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before removing
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 1:20 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We want this clean to be called from tree's root clean
> and that one is silent if there's nothing to clean.
>
> Adding check for all object to clean and display CLEAN
> messages only if there are objects to remove.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index b780b3a9fb07..3007cfabf5e6 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
>         $(call msg,LINK,$@)
>         $(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
>
> +clean_objects := $(wildcard $(OUTPUT)/*.o                \
> +                            $(OUTPUT)/.*.o.cmd           \
> +                            $(OUTPUT)/.*.o.d             \
> +                            $(OUTPUT)/libbpf             \
> +                            $(OUTPUT)/libsubcmd          \
> +                            $(OUTPUT)/resolve_btfids)
> +
> +clean:
> +
> +ifneq ($(clean_objects),)
>  clean: fixdep-clean

this looks a bit weird, declaring clean twice. Wouldn't moving ifneq
inside the clean work just fine?

>         $(call msg,CLEAN,$(BINARY))
> -       $(Q)$(RM) -f $(BINARY); \
> -       $(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> -       $(RM) -rf $(OUTPUT)libbpf; \
> -       $(RM) -rf $(OUTPUT)libsubcmd; \
> -       find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
> +       $(Q)$(RM) -rf $(clean_objects)
> +endif
>
>  tags:
>         $(call msg,GEN,,tags)
> --
> 2.26.2
>
