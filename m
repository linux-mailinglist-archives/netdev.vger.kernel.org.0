Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EC343A948
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhJZAfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbhJZAfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 20:35:24 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93819C061745;
        Mon, 25 Oct 2021 17:33:01 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id o12so26354063ybk.1;
        Mon, 25 Oct 2021 17:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajp0vnUsNHr1DDvD8ewIEIf12ziKI02EakyjRsZ2xeA=;
        b=H9p2Sw4fnBqzBiIl2xeHOVdwGny93WqLq8jpi7g2UIas6G6oVowwNuAgB4c/gWtgql
         fmDxJmYloUCnmG0vD1ekLCxkE+2vRMF157dDB5vYC1OSU7yALGa4fVTfXb/S4WXZqQd2
         wk0bHBTr0MW43zZvqbEstzp22ApMdcuoJ8XzBr6lSX0xY0UFCaBnyXp9QrKr8exUJbxF
         wSfNZmw2T0yEYuzflUxtdwDxSnc0wIBUHWhkNr3CS4VjMZIXUOln7nA0Mwl97Wk5rOtf
         TpmtR9egUGmOmhhaYxt2mN4wh4446hU9F+mBipJ+nI4Dc/PPAB94D7RQMkTmrrQbLXgP
         mXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajp0vnUsNHr1DDvD8ewIEIf12ziKI02EakyjRsZ2xeA=;
        b=XNyzwmrJaarFyBAic/1qxUQvayw2Omt+oquN5JJHgHiTldfIWxOu2Z457OeZM1LBGe
         yJ3Yfz5MexlFXe0wczRSfazQiiqhYaootfLoYd5DbuK7FlVDhSOLjOAjilch8bw2krUJ
         ++NbP70oJAlNZIJvNiKV7Q9P5na9ckF3dbkUx/h40gI/Jw8Zg1WkociAvBHJBusMKOAs
         ADj89OyQto/2StFFpURcE4fWDPQLm9QuCnB5qAH0D0pcvkMXTIBX7CRrwT/kqvR0DWTL
         sikGSgUy6wzhMP3HRaqSg7VrzKT79haTLmrMTL46Hs95F0GjKz7CaPLP/plSQDAtaHPq
         eN+w==
X-Gm-Message-State: AOAM532LcQsN0g+QwdgZM67ww/dgEzD6+6LGl/CmW7SftwTNER+cI40g
        w1Eq+a6E0d4wuckD7CMPWQEo+zzZcgjVhEBsZ0LYk4m2RvY=
X-Google-Smtp-Source: ABdhPJy/9U+w3EAziMZGHcVn17rcC2qN6gdAEpPiwVcnV3k1gpQcEiPEjAURizUmiMV/4NFO6PtQftuUXEV2xLFgiXI=
X-Received: by 2002:a25:8749:: with SMTP id e9mr19990448ybn.2.1635208380829;
 Mon, 25 Oct 2021 17:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211023205154.6710-1-quentin@isovalent.com>
In-Reply-To: <20211023205154.6710-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 17:32:49 -0700
Message-ID: <CAEf4BzZWaA1yunTjfcvwZ_UU2vLrVnqwzJMFCj9qEbGDsLmBPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] bpftool: Switch to libbpf's hashmap for
 referencing BPF objects
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 1:52 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> When listing BPF objects, bpftool can print a number of properties about
> items holding references to these objects. For example, it can show pinned
> paths for BPF programs, maps, and links; or programs and maps using a given
> BTF object; or the names and PIDs of processes referencing BPF objects. To
> collect this information, bpftool uses hash maps (to be clear: the data
> structures, inside bpftool - we are not talking of BPF maps). It uses the
> implementation available from the kernel, and picks it up from
> tools/include/linux/hashtable.h.
>
> This patchset converts bpftool's hash maps to a distinct implementation
> instead, the one coming with libbpf. The main motivation for this change is
> that it should ease the path towards a potential out-of-tree mirror for
> bpftool, like the one libbpf already has. Although it's not perfect to
> depend on libbpf's internal components, bpftool is intimately tied with the
> library anyway, and this looks better than depending too much on (non-UAPI)
> kernel headers.
>
> The first two patches contain preparatory work on the Makefile and on the
> initialisation of the hash maps for collecting pinned paths for objects.
> Then the transition is split into several steps, one for each kind of
> properties for which the collection is backed by hash maps.
>
> v2:
>   - Move hashmap cleanup for pinned paths for links from do_detach() to
>     do_show().
>   - Handle errors on hashmap__append() (in three of the patches).
>   - Rename bpftool_hash_fn() and bpftool_equal_fn() as hash_fn_for_key_id()
>     and equal_fn_for_key_id(), respectively.
>   - Add curly braces for hashmap__for_each_key_entry() { } in
>     show_btf_plain() and show_btf_json(), where the flow was difficult to
>     read.
>
> Quentin Monnet (5):
>   bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
>   bpftool: Do not expose and init hash maps for pinned path in main.c
>   bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
>   bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
>   bpftool: Switch to libbpf's hashmap for PIDs/names references
>
>  tools/bpf/bpftool/Makefile |  12 ++--
>  tools/bpf/bpftool/btf.c    | 132 +++++++++++++++++--------------------
>  tools/bpf/bpftool/common.c |  50 ++++++++------
>  tools/bpf/bpftool/link.c   |  45 ++++++++-----
>  tools/bpf/bpftool/main.c   |  17 +----
>  tools/bpf/bpftool/main.h   |  54 +++++++--------
>  tools/bpf/bpftool/map.c    |  45 ++++++++-----
>  tools/bpf/bpftool/pids.c   |  90 ++++++++++++++-----------
>  tools/bpf/bpftool/prog.c   |  45 ++++++++-----
>  9 files changed, 262 insertions(+), 228 deletions(-)
>
> --
> 2.30.2
>

Applied to bpf-next, thanks.
