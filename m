Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70C4AE624
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiBIAj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiBIAj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:39:29 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B20C061576;
        Tue,  8 Feb 2022 16:39:27 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y84so1319715iof.0;
        Tue, 08 Feb 2022 16:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YvdgdZPu8X2JxF35aY7XOUFxDoXmluHF8hlVweX1af8=;
        b=gU708QnxL5cnOd6ZzusLpzOLe71X6171fQKLZQ3xM0sfUlI5bRsrF7G+jNcOtfVGxj
         OSrR2SoxQXVbgS72bJux2OcW3F9ok/EWQ4k/wE9igpetIyLZ2AiuqMhI0WVaY2XyccVa
         IsRUykJFOCUKdFyIssk/yJLjKVTZIW45YFMPxPaShTfG5dfZdkEpZbv856ePphIAgtMY
         aRdhzkVzXHNGZB/wZY1eI6gbJbjSQs03YdS3sHwDz7q8w6Zopp9DoemPUB2J7xnTGzwh
         944fgFsHjXXF+59uMA5XfPjTOaL7QFWpIw/FX3tqZpr9e5xoEv6ITQvFrf5zdOK4UV9B
         L5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YvdgdZPu8X2JxF35aY7XOUFxDoXmluHF8hlVweX1af8=;
        b=5w1L89SFvqtRXVPPVaPX6SbPRoeEC3sARwGBvStWOxogw9E8FpK3QohzvkAQKdhtTI
         NENyLvk753i9hQMXVUilOi8ZgJ+wG8NjD+Xkj79vJEzNWte+iaLlCv/6acDJzoTDT0fC
         vOWl66PS3rpiJoKg4hnrjsT4GLPGGtQMlejWN+L263d9C2kE4ZtUNR6L4utdPHn9P4BV
         I0flPpeZsxVMBbWJkGykwo4qLI5zxlvQB/+x0ndDSA/SLkxdUhyOULpk+oMqJGE5N00b
         W6F49/qG8ocxnkJZMOjmrqnFrcADNzvEJzIYUSJ4Hym3d7vp1NEnV5ZQ8hji35dbh6Ya
         NNNQ==
X-Gm-Message-State: AOAM532MQqbEBT98NlHdTYrjNO3uJ2ocJo+mErfGaj+XiR/emOrn2c8/
        /kHYrLsKbhNcxfHkguysfbBfVDiOi0ql7Ej/mdY+gqrW3ds=
X-Google-Smtp-Source: ABdhPJzkhQUiMbIkH9HebSRwp4NzCGGbOaiDSRi+1lPnhICmOUSK6918Xegqj2Xwu2JMEzc45iPrLcv0hvxK0shV7EU=
X-Received: by 2002:a02:2422:: with SMTP id f34mr3338476jaa.237.1644367167019;
 Tue, 08 Feb 2022 16:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20220208120648.49169-1-quentin@isovalent.com> <20220208120648.49169-4-quentin@isovalent.com>
In-Reply-To: <20220208120648.49169-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Feb 2022 16:39:16 -0800
Message-ID: <CAEf4BzaH1OKZpJ8-CC4TbhGmYe+jv_0iqOTwhOG9+98Lze9Lew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpftool: Update versioning scheme, align
 on libbpf's version number
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 4:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Since the notion of versions was introduced for bpftool, it has been
> following the version number of the kernel (using the version number
> corresponding to the tree in which bpftool's sources are located). The
> rationale was that bpftool's features are loosely tied to BPF features
> in the kernel, and that we could defer versioning to the kernel
> repository itself.
>
> But this versioning scheme is confusing today, because a bpftool binary
> should be able to work with both older and newer kernels, even if some
> of its recent features won't be available on older systems. Furthermore,
> if bpftool is ported to other systems in the future, keeping a
> Linux-based version number is not a good option.
>
> Looking at other options, we could either have a totally independent
> scheme for bpftool, or we could align it on libbpf's version number
> (with an offset on the major version number, to avoid going backwards).
> The latter comes with a few drawbacks:
>
> - We may want bpftool releases in-between two libbpf versions. We can
>   always append pre-release numbers to distinguish versions, although
>   those won't look as "official" as something with a proper release
>   number. But at the same time, having bpftool with version numbers that
>   look "official" hasn't really been an issue so far.
>
> - If no new feature lands in bpftool for some time, we may move from
>   e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
>   versions which are in fact the same.
>
> - Following libbpf's versioning scheme sounds better than kernel's, but
>   ultimately it doesn't make too much sense either, because even though
>   bpftool uses the lib a lot, its behaviour is not that much conditioned
>   by the internal evolution of the library (or by new APIs that it may
>   not use).
>
> Having an independent versioning scheme solves the above, but at the
> cost of heavier maintenance. Developers will likely forget to increase
> the numbers when adding features or bug fixes, and we would take the
> risk of having to send occasional "catch-up" patches just to update the
> version number.
>
> Based on these considerations, this patch aligns bpftool's version
> number on libbpf's. This is not a perfect solution, but 1) it's
> certainly an improvement over the current scheme, 2) the issues raised
> above are all minor at the moment, and 3) we can still move to an
> independent scheme in the future if we realise we need it.
>
> Given that libbpf is currently at version 0.7.0, and bpftool, before
> this patch, was at 5.16, we use an offset of 6 for the major version,
> bumping bpftool to 6.7.0.
>
> It remains possible to manually override the version number by setting
> BPFTOOL_VERSION when calling make.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
> Contrarily to the previous discussion and to what the first patch of the
> set does, I chose not to use the libbpf_version_string() API from libbpf
> to compute the version for bpftool. There were three reasons for that:
>
> - I don't feel comfortable having bpftool's version number computed at
>   runtime. Somehow it really feels like we should now it when we compile

Fair, but why not use LIBBPF_MAJOR_VERSION and LIBBPF_MINOR_VERSION to
define BPFTOOL_VERSION (unless it's overridden). Which all seems to be
doable at compilation time in C code, not in Makefile. This will work
with Github version of libbpf just as well with no extra Makefile
changes (and in general, the less stuff is done in Makefile the
better, IMO).

Version string can also be "composed" at compile time with a bit of
helper macro, see libbpf_version_string() implementation in libbpf.


>   it. We link statically against libbpf today, but if we were to support
>   dynamic linking in the future we may forget to update and would have
>   bpftool's version changing based on the libbpf version installed
>   beside it, which does not make sense.
>
> - We cannot get the patch version for libbpf, the current API only
>   returns the major and minor version numbers (we could fix it, although
>   I'm not sure if desirable to expose the patch number).
>
> - I found it less elegant to compute the version strings in the code,
>   which meant malloc() and error handling just for printing a version
>   number, and having a separate case for when $(BPFTOOL_VERSION) is
>   defined, whereas passing a macro from the Makefile makes things
>   straightforwards.
> ---
>  tools/bpf/bpftool/Makefile | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 83369f55df61..8dd30abff3d9 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -7,14 +7,21 @@ srctree := $(patsubst %/,%,$(dir $(srctree)))
>  srctree := $(patsubst %/,%,$(dir $(srctree)))
>  endif
>
> +BPF_DIR = $(srctree)/tools/lib/bpf
> +
> +# bpftool's version is libbpf's with a fixed offset for the major version.
> +# This is because bpftool's version was higher than libbpf's when we adopted
> +# this scheme.
> +BPFTOOL_MAJOR_OFFSET := 6
> +LIBBPF_VERSION := $(shell make -r --no-print-directory -sC $(BPF_DIR) libbpfversion)
> +BPFTOOL_VERSION ?= $(shell lv="$(LIBBPF_VERSION)"; echo "$$((${lv%%.*} + $(BPFTOOL_MAJOR_OFFSET))).$${lv#*.}")
> +
>  ifeq ($(V),1)
>    Q =
>  else
>    Q = @
>  endif
>
> -BPF_DIR = $(srctree)/tools/lib/bpf
> -
>  ifneq ($(OUTPUT),)
>    _OUTPUT := $(OUTPUT)
>  else
> @@ -39,10 +46,6 @@ LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>  LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
>  LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
>
> -ifeq ($(BPFTOOL_VERSION),)
> -BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
> -endif
> -
>  $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
>         $(QUIET_MKDIR)mkdir -p $@
>
> --
> 2.32.0
>
