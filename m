Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD562284216
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 23:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgJEVXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 17:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJEVXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 17:23:01 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CE9C0613CE;
        Mon,  5 Oct 2020 14:23:01 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id y198so7661116qka.0;
        Mon, 05 Oct 2020 14:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z7TnmFsBGzLXCT4IMNVtknnYVbU6bIgBYeID7vKtezo=;
        b=gPf9OLwn317X9ROd0P3pd+rJHTYd5HYr/u1cJX7//pqFgj4UvYsPeHQvnMTL8/ZMYB
         pgMvPvV8wqsfICwQaYpRKt8v0ZrRQ9+Ba4saxbqoSjnpBLPJR4VkFObMo7GHd7PsUiwh
         pzP1PiObjXSmzuuM1ZRQPuDdq3XPLsdYAdTSloFSziZzKSYE4zhqKw21T86rroZY/eH0
         4MnfL9jteTBNv6K8C6cclpUTkhBXQxaJH+/mY+gFk0N6Gk17htSTrEPnUUBh6NPQUNIR
         o12iwk7AvqMeDjrpCKRp/lvAZGp0kb+iPUwX+J/BNQppTKcpYBcLwNzYcES7/kSn9Km4
         tV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z7TnmFsBGzLXCT4IMNVtknnYVbU6bIgBYeID7vKtezo=;
        b=B5fR0mkAxQIGMF9AyPBLLdAZ54y2SI3rDZ8lfoF8c4Zx8bFHLBLsZ4LwUFtJTKNbez
         upfaC+I1GWWWjNlDh76ki+seR4Ivhmo/xgoYSpLXGo9Tt6J7qHCtKYsCEoT20NAH0nsd
         VHsyVOfpHVs3h4peaymIrrNxqvcJiBdS9BFGqYF9Sf+ngrpqaTrtpadLuj4XlqpOpAcn
         UFyJEePqVoUiyerREmO8mlTGQqowX1xltkQgvDoqIe2jINtd2y7ZBrTUzcomUWi4gTKw
         J2pFRdRyWFyE+mDBnqTvk2bAwRQzysaH5D8fuMwcDgM40tywFzQEvcdwKOxj7DVI5UcY
         ww6g==
X-Gm-Message-State: AOAM530NqfiQ6cCHepZDLLMu/ohm6zRXfsTgT2kzNohtHDoHk5iegv54
        a2h7QoLJrWMVcwk36l65+WjB1YA5mrx34Z35Ngo=
X-Google-Smtp-Source: ABdhPJzJUUCramNOHAM1/aa9xJ1fxHPDqe6w4BT24l2SSHlcc78EEGQB4ycQxAisbfg3Cv7rwzodwqDoFdC6ZttoFEU=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr2641643ybg.260.1601932980320;
 Mon, 05 Oct 2020 14:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com> <20201003085505.3388332-3-liuhangbin@gmail.com>
In-Reply-To: <20201003085505.3388332-3-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Oct 2020 14:22:49 -0700
Message-ID: <CAEf4BzbfpZBStaQoBr-Zdsb8RAF4f5sGEj7aWr+yLB+Hdbq3jA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 2/3] libbpf: check if pin_path was set even map fd exist
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 1:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Say a user reuse map fd after creating a map manually and set the
> pin_path, then load the object via libbpf.
>
> In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
> return 0 if there is no pinned map in map->pin_path. Then after
> checking if map fd exist, we should also check if pin_path was set
> and do bpf_map__pin() instead of continue the loop.
>
> Fix it by creating map if fd not exist and continue checking pin_path
> after that.
>
> v2: keep if condition with existing order
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>

[...]
