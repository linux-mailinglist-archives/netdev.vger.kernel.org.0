Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172A25BA1A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgICF3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgICF3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:29:07 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55433C061244;
        Wed,  2 Sep 2020 22:29:07 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s92so1333342ybi.2;
        Wed, 02 Sep 2020 22:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqSzJ+G6e3sItDAMEGO8323I5vOUOvMlVHBhDl0yekQ=;
        b=Uk2NZA9Y6bbWDzHmEYkTzTD/xekG9voY1J+n9mxwJ4+ALoTFqBDICwWpq6/R+8d+vI
         yKCWrlEc+RcRxR3jzOIM+5iVImoeONAuAtwQ886mTRXRSKLTxi72QVmk+Z2XiPbs5h1h
         VXZv6V43lZAjfsmo6SLg07Ny7wUmdid/vL6t1QPmvUUb+WxS6lAYMrBZ13TanFWpqCvb
         5xJzdmSdqh4ImXo7ktkMBsD0h+baSJC807sNKiYPjnq0MpaEO61VfpQf63jxb5Ay2D8e
         D16buykU7kxpt9LOprHiTIn4btydJJnTm+gVRCjI9YGkhQHG2r5PzJD3oDZAa3earEbs
         V4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqSzJ+G6e3sItDAMEGO8323I5vOUOvMlVHBhDl0yekQ=;
        b=Dh7lL/axoK5opqXooztNcw6KbnAQavckdRF3StNaMHzrV7qgGliFvE/N/Kz0LjbkCK
         gKDHVWsR+Ri5UuOIFvlREzxT2LaKdPn13efzoVAFuws/Y4yk4c81ndrllhaWqn+5BUcu
         3JSgmLDdqN+9bA6/qlV+uSo8QrixFqbVdPfX/w4Hg9d7BTi5WPL4CTM6PH3Z/9Ee62QP
         lSVHWuw7YegQtjfEOCgiZSrte6Y8r9UHQPgS/GoZPxDbhsKktVYlyUBBjD8cTIMndWrI
         jzBOzPX1iwj6VazuMJ4cG8gQPJORPFb/go50c39rFJ9N90So2AbpDxOtq9AE8fvwIY/k
         4dFg==
X-Gm-Message-State: AOAM530R0u3kvkeHoRbk6uCFNAhbuPCkPl5q14YO3Ntl4f+2H9XcWwod
        lZIJRBcT1q6hZW5UJ91XEP5lQidHEEQ1f9NX0Uw=
X-Google-Smtp-Source: ABdhPJwyqZJvbDAyTq+F1ByuHXoZFOv7/Zgl1IH0ZUPttHP9J3S/Wq8QCE9p5aRb7dcXCiRDjcSSkakeTBxoLKQ0Ma8=
X-Received: by 2002:a25:824a:: with SMTP id d10mr442313ybn.260.1599110946446;
 Wed, 02 Sep 2020 22:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200831224933.2129891-1-brho@google.com>
In-Reply-To: <20200831224933.2129891-1-brho@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 22:28:55 -0700
Message-ID: <CAEf4BzauvG-1ED3jtgsYdjNULq5O3pVbO7GCakZR9tP5_6zUzQ@mail.gmail.com>
Subject: Re: [RFC PATCH] libbpf: Support setting map max_entries at runtime
To:     Barret Rhoden <brho@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 4:03 PM Barret Rhoden <brho@google.com> wrote:
>
> The max_entries for a BPF map may depend on runtime parameters.
> Currently, we need to know the maximum value at BPF compile time.  For
> instance, if you want an array map with NR_CPUS entries, you would hard
> code your architecture's largest value for CONFIG_NR_CPUS.  This wastes
> memory at runtime.
>
> For the NR_CPU case, one could use a PERCPU map type, but those maps are
> limited in functionality.  For instance, BPF programs can only access
> their own PERCPU part of the map, and the maps are not mmappable.
>
> This commit allows the use of sentinel values in BPF map definitions,
> which libbpf patches at runtime.
>
> For starters, we support NUM_POSSIBLE_CPUS: e.g.
>
> struct {
>         __uint(type, BPF_MAP_TYPE_ARRAY);
>         __uint(max_entries, NUM_POSSIBLE_CPUS);
>         __type(key, u32);
>         __type(value, struct cpu_data);
> } cpu_blobs SEC(".maps");
>
> This can be extended to other runtime dependent values, such as the
> maximum number of threads (/proc/sys/kernel/threads-max).
>
> Signed-off-by: Barret Rhoden <brho@google.com>
> ---

libbpf provides bpf_map__set_max_entries() API exactly for such use
cases, please use that.

>  tools/lib/bpf/bpf_helpers.h |  4 ++++
>  tools/lib/bpf/libbpf.c      | 40 ++++++++++++++++++++++++++++++-------
>  tools/lib/bpf/libbpf.h      |  4 ++++
>  3 files changed, 41 insertions(+), 7 deletions(-)
>

[...]
