Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D105341F7E3
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhJAW6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356171AbhJAW5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:57:37 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1775C061775;
        Fri,  1 Oct 2021 15:55:52 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id v10so23632796ybq.7;
        Fri, 01 Oct 2021 15:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BbdfudAXrW8/mnrrb7EAmGS3rUW5NiGxX746IanDHeE=;
        b=gzf4VmGukAxfE7acbAVoCuS0I1htg0zZHxY6lEgWN/FYd7RR88uL8DvG/3cZmmiifU
         7oB+JpGyRFIgGm2Ac9gwsOKVYo8QtXB8IZYlA/QLgbZqOy8ikizsFqaJlztS+u4QHg0w
         Oi1Bz/y9twttBr+72uFDrg0Qze7yFpvBme1eVPj9P21FS8dQLiynrgbTMqVsNJxisYdz
         RNQtNW1o2ht3agTJ+21ORj4+RV0R7QQ55ksQGjqzDF4OTa76IYrbacWRGFWbpJQsPm2Q
         0hAKdCndWXacbWU2S4x58k0CaWIkK9+xuGQK37r9e8GTN+htGPwGd4IgoiAGkGY/slAk
         m8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BbdfudAXrW8/mnrrb7EAmGS3rUW5NiGxX746IanDHeE=;
        b=ljEat5Zm3+HUjiTOBsHAh4+Tm/NIzRojCN92Jj+X0DhipF6MaCN6H1+RtpyRvUz1cs
         ZlzsaIIzg1KWUyNZKsTwbY3w8oPTtnmBDmdS1ojdiXDYyuRs4mIUrlQRYOt07iQddZb3
         6RQNGwf1RXMreqmHCrAxD18mLZzkiyvX4uBdDNSspt/FHseGfjO4AVEOrZ5FCfqLjJ02
         r5Ye4B8jH3EbuqAvPa65UXCrxz9i5ElmIVYIU7891DjuHVBA4yXpRsHpzFSGNkxCuydW
         tBhSn76otQZVPl5LI5JTivAJgJ2h1EbP1k2mLcaMowWjI8H2KNQ8q4yNaYsfMY3RCtXA
         mREA==
X-Gm-Message-State: AOAM531YaURZDEW9lvj4D3jBVSRl/V/lfO/UM6O66H90QxIR5utXu5sS
        zGDMpjRQM3Yu1/tV2yuhG6215HeVBzOAJSw/5Tg=
X-Google-Smtp-Source: ABdhPJxqaMCbudAmQr0mxFv/MOTSblrUKEPDDP5egxpcRGns/hNd7co555uuzVSTyIASZbHE+7Q8KjWLwoDnXh04Rxs=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr464966ybh.267.1633128951924;
 Fri, 01 Oct 2021 15:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-3-quentin@isovalent.com>
In-Reply-To: <20211001110856.14730-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 15:55:41 -0700
Message-ID: <CAEf4BzaEN91ju5E6YUdpT07noMafMfge+8Owvq8UPvBBQxJxJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/9] tools: bpftool: install libbpf headers
 instead of including the dir
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool relies on libbpf, therefore it relies on a number of headers
> from the library and must be linked against the library. The Makefile
> for bpftool exposes these objects by adding tools/lib as an include
> directory ("-I$(srctree)/tools/lib"). This is a working solution, but
> this is not the cleanest one. The risk is to involuntarily include
> objects that are not intended to be exposed by the libbpf.
>
> The headers needed to compile bpftool should in fact be "installed" from
> libbpf, with its "install_headers" Makefile target. In addition, there
> is one header which is internal to the library and not supposed to be
> used by external applications, but that bpftool uses anyway.
>
> Adjust the Makefile in order to install the header files properly before
> compiling bpftool. Also copy the additional internal header file
> (nlattr.h), but call it out explicitly. Build (and install headers) in a
> subdirectory under bpftool/ instead of tools/lib/bpf/. When descending
> from a parent Makefile, this is configurable by setting the OUTPUT,
> LIBBPF_OUTPUT and LIBBPF_DESTDIR variables.
>
> Also adjust the Makefile for BPF selftests, so as to reuse the (host)
> libbpf compiled earlier and to avoid compiling a separate version of the
> library just for bpftool.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile           | 27 ++++++++++++++++-----------
>  tools/testing/selftests/bpf/Makefile |  2 ++
>  2 files changed, 18 insertions(+), 11 deletions(-)
>

Looks good, but with Makefile no one can ever be sure :) Let's see how
this works in practice...

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 1fcf5b01a193..78e42963535a 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -17,16 +17,16 @@ endif
>  BPF_DIR = $(srctree)/tools/lib/bpf/

[...]

> +# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
> +# required by bpftool.
>  $(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
> -       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
> +       $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
> +               DESTDIR=$(LIBBPF_DESTDIR) prefix= \
> +               $(LIBBPF_OUTPUT)libbpf.a install_headers

s/$(LIBBPF_OUTPUT)libbpf.a/$(LIBBPF)/ ?

> +       $(call QUIET_INSTALL, bpf/nlattr.h)
> +       $(Q)install -m 644 -t $(LIBBPF_INCLUDE)/bpf/ $(BPF_DIR)nlattr.h
>
>  $(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
>         $(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \

[...]
