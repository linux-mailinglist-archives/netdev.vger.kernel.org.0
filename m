Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3998831022E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhBEBZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhBEBZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 20:25:37 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E305C0613D6;
        Thu,  4 Feb 2021 17:24:56 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k4so5174260ybp.6;
        Thu, 04 Feb 2021 17:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JU/raeYJR27PicXqCD5E08kik/ZTwMk0wIqJ2cm+620=;
        b=tZtjzKRq9ihWGI0MjFf/6vxRkHNn6a8AIA0LHZBF1ytmeRl8kOqc+p0p90mEAVDkPV
         t2t0eZNEEzFk+B+kdXNY7AYhLfH577dAtD/icpsjMzUCaul9UmZVA9MCkjz9PjnB0mi0
         8LxfypDOSkBZN2LAdcpNg5vIziQYmTyFCTFdpzXWK2SH/Z/5WNdaa0Zu+itYK1mSlAB2
         xr/Y5Le4q0BPD/Rhlx9EtrNe80MAdUYTjBALI0xh34n0Z69Ac93aYtg8klFpE8V+b9/t
         6MIAwrcwJTsgznmFal1SLNVIrSw28i/xwkO8cSPpeBZcRvIBrAaE5dtU0LDXdU44Q7jY
         aGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JU/raeYJR27PicXqCD5E08kik/ZTwMk0wIqJ2cm+620=;
        b=O49AE2/1k5sexo2r/5jsXDKM7uXPAdxd3yWe+fJauQ6NPcwBdW62jQpdJs7MrcyYOf
         rsxUa+y8w+k39X2pSJAF32LXyXIKW5Yv0B6w7yJXerWnM8uPpxAUuDxN12+PdxQugpjT
         /Dex7QavbAL/RZ8YseM628G8aseKkbnglM1RmrIxOBrE2t4kIwjPMUyftP58LS3lsNYN
         IZlqM2TQOz/qLvFckyco98uh7WGTxi6IZvkBPD2v27fJq88Z6D4JCeKxdT+m1CSr/jqu
         QVQ3SCbC46KWIOu3+VqnQ9AEUlSyrNM/exllmTFyKCV5Pk0z+qxUliWo6bsD7OjEWmeY
         uQnQ==
X-Gm-Message-State: AOAM531vYoUZ5w7TrPVN5j9L33uu9tg86VpP6r6HM3bcy3UGPeP2tmAm
        xLMXwDbnPzxKlcacWUhx5br+UDJYgyIYVripYp1Avsj2+GKE8Apa
X-Google-Smtp-Source: ABdhPJysn3NHGdFDkd1eSq92GIYy0j8F0yVhlRtC2g/GuR6/L53lWXisihLTp93qt8S6kji1B7T6sfTiPwiATncEJ7o=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr3097518ybd.230.1612488295518;
 Thu, 04 Feb 2021 17:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20210129134855.195810-1-jolsa@redhat.com> <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-4-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Feb 2021 17:24:44 -0800
Message-ID: <CAEf4BzbADQc4H5cW9x2rnZuNmXoj5BbniGngVK1Xv_bOMr-1iQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] tools/resolve_btfids: Set srctree variable unconditionally
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

On Thu, Feb 4, 2021 at 1:21 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We want this clean to be called from tree's root Makefile,
> which defines same srctree variable and that will screw
> the make setup.
>
> We actually do not use srctree being passed from outside,
> so we can solve this by setting current srctree value
> directly.
>
> Also root Makefile does not define the implicit RM variable,
> so adding RM initialization.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/resolve_btfids/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index 3007cfabf5e6..b41fc9a81e83 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -2,11 +2,9 @@
>  include ../../scripts/Makefile.include
>  include ../../scripts/Makefile.arch
>
> -ifeq ($(srctree),)
>  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
>  srctree := $(patsubst %/,%,$(dir $(srctree)))
>  srctree := $(patsubst %/,%,$(dir $(srctree)))

Is this just a weird way of doing $(abspath $(CURDIR)/../../../)? Are
there any advantages compared to a more straightforward way?

> -endif
>
>  ifeq ($(V),1)
>    Q =
> @@ -22,6 +20,7 @@ AR       = $(HOSTAR)
>  CC       = $(HOSTCC)
>  LD       = $(HOSTLD)
>  ARCH     = $(HOSTARCH)
> +RM      ?= rm
>
>  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
>
> --
> 2.26.2
>
