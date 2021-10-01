Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7622541F7FC
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhJAXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhJAXDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:03:49 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5CFC061775;
        Fri,  1 Oct 2021 16:02:04 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id h2so23584957ybi.13;
        Fri, 01 Oct 2021 16:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RlfblMKoDsp+/IB/1ts+074qWeC+fOJ9hDq+pm5YCqI=;
        b=nN6y5g5GPQGKJcaPcMGFCBnD5a86JxH4WYT/yL73WER2e1G+cYmu7mG9l0uROTvQeJ
         2JemHRjQJQiS4ycgfpDI/2hR8O5jq7iDAcsksTf8AuGYo7INdYA3QE6gui1wOuziV8A8
         jJtkXY3o24rI9Bx96DHlOixKiBW2LlKVZ9cipplKReynNQjYo7++K0Lhq6w9NVqoovIJ
         syHbCF+XUC+loMAQXYE2wtRRqQcfDkKKzZxb1YVj5AcaZUTkXiJcx0cbYDy38BB4/ms0
         U4D2/dDBpy7wsLEUFLacIPAD5XfGVyJUTK8YryxSgISnI/kr5prtmqkxcqfR/DjyO3KU
         hVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RlfblMKoDsp+/IB/1ts+074qWeC+fOJ9hDq+pm5YCqI=;
        b=6LRKdTkfDpoxlv9SxAxfMyptDgUg8F6uh6dSPvowxvfiKW8ePefPRaPedXCXa1uPXC
         6XELgBatRJlVN3sfl21EehuGhjrsdy70nYzG9TTFZg56unyO5gnlWPAaViVJvl6Hb6lB
         lK8kB0fN8OM/W55eVuH5JnNtSae7ILZp9/5p6D3CkEcMfvoLLaFUzWx3oyvOfH10Sesy
         IEZccxBTr3eR5U/iiIflTEq7qtwIa5U4ABaxEx56FJIvj/sv03EkNrbl//VnyuVp1eyy
         e/RMsCr1Ss9kwDKkreuOZIRhZrIzu54bD2Hl4v9qsrfuvl1MVNi9nu1jS1eoWay5vZO7
         1Ozg==
X-Gm-Message-State: AOAM530IXsFh7yFbtdJzEv3Dvv2bxK2I9JA6lLdwCan5Br2mT7xWrPf6
        X6Rek3qHSLpOWjF0rCMgcbB3i3ZhtPFFwGtzTNE=
X-Google-Smtp-Source: ABdhPJzHWkM+MhXslYEaYqIM3ECnz9HEYkv7YepMqvBFqpiY1RYalLzLNczY20aXHEjPd+XdLvW9bX28l7zklTdJT2A=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr492597ybh.267.1633129324175;
 Fri, 01 Oct 2021 16:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-4-quentin@isovalent.com>
In-Reply-To: <20211001110856.14730-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 16:01:53 -0700
Message-ID: <CAEf4BzZ4gH2WtN2zsMe1b+jC1us14hSqoUSNCQerLqaFH5PLGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/9] tools: resolve_btfids: install libbpf
 headers when building
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
> API headers from libbpf should not be accessed directly from the
> library's source directory. Instead, they should be exported with "make
> install_headers". Let's make sure that resolve_btfids installs the
> headers properly when building.
>
> When descending from a parent Makefile, the specific output directories
> for building the library and exporting the headers are configurable with
> LIBBPF_OUT and LIBBPF_DESTDIR, respectively. This is in addition to
> OUTPUT, on top of which those variables are constructed by default.
>
> Also adjust the Makefile for the BPF selftests in order to point to the
> (target) libbpf shared with other tools, instead of building a version
> specific to resolve_btfids.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/resolve_btfids/Makefile    | 17 ++++++++++++-----
>  tools/bpf/resolve_btfids/main.c      |  4 ++--
>  tools/testing/selftests/bpf/Makefile |  7 +++++--
>  3 files changed, 19 insertions(+), 9 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>
