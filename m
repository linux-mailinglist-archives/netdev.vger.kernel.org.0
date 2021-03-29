Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7334D7A4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhC2S4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhC2S4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:56:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE94C061574;
        Mon, 29 Mar 2021 11:56:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so8162631pjb.4;
        Mon, 29 Mar 2021 11:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GqbdPTNTHOeEC54VEtG1smzLQCaqJlKPEaEE81/oHuc=;
        b=YP67GC6ZGZPkaGdAoeWYNiACydqSU+Nk1eCct6eyV12rPlRRvqUBchIZjYVon12kf8
         DaSHBniU++ZKHyAm9J+NniR/godHBVx8gTbNLq0VFyTnOCxXy6XRtGVWKwJhKiBQUM9E
         pZ2unajrLyAq2tNB9AFjQV7/8fycqFSDlhdgdlGdPYW4BghvFmR6UPw+8dmLWuPVaU0x
         01+e2GDMiC1ymJOffPyBwEfi3+Vxm7Rb8NZIjNnQl37tyiJe5bqbk+/9Rhl6G5minAS7
         JVvOw02tbXCw2bqbTrHLnYchW7Gj84xXNSifiH0huCBaFKEtIuM4LjSjAdVRD9bMYZXu
         EBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GqbdPTNTHOeEC54VEtG1smzLQCaqJlKPEaEE81/oHuc=;
        b=E0BMr776I5jIyJW252OdW1qA4FqwfYOBGoavGhjG1OZk0ktj0APnlHZWNabsN58LBC
         wknQWrYxxEcAp5C+av5t5pfklNrvxErdx+Bj4dQ4aXv4WIThxlzuiUVH7FUstgaQuZ0e
         8DWl+A45PCR3U87OgznYa8VOR7tSOFfC9Z9rIh45Br9+FY0AbT8D6HcdIa+cVJjlYLCR
         sd+nuPbZpJ9UCbCFvIywThuZZ7HbQkT2h8UnBFFpd7PljlxBtjLGW/FeT2Yki4JKZBgg
         LsQQRwFGBZnMHSOmg34kDl3aMNkVsN7dKSDvEU2x61EgW26pEkCytk9RaqdSDU+qfvZl
         zM4Q==
X-Gm-Message-State: AOAM5339H5CAN52fP4SE6dsCL+vs19Q2vWn284Ws+99fnbLDt7ugUCha
        1HYs23O0oaCXp8b1ntPjE+Q=
X-Google-Smtp-Source: ABdhPJw1aUIsNxy01AKe08w4M3vdAXHhxpcndYqc+PliJSFV1HYfhYFcnA8tgqVPZ6Yg5Xe9Nsj4vg==
X-Received: by 2002:a17:902:b908:b029:e6:3e0a:b3cc with SMTP id bf8-20020a170902b908b02900e63e0ab3ccmr29985505plb.68.1617044161629;
        Mon, 29 Mar 2021 11:56:01 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:e922])
        by smtp.gmail.com with ESMTPSA id o197sm18300776pfd.42.2021.03.29.11.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 11:56:00 -0700 (PDT)
Date:   Mon, 29 Mar 2021 11:55:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
Message-ID: <20210329185558.mjoikgfdp53lq2it@ast-mbp>
References: <20210319205909.1748642-1-andrii@kernel.org>
 <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
 <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp>
 <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
 <20210322175443.zflwaf7dstpg4y2b@ast-mbp>
 <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
 <CAADnVQKDOWz7fW0kxGEeLtMJLf7J5v9Un=uDXKmwhkweoVQ3Lw@mail.gmail.com>
 <CAEf4Bza-uieOvR6AQkC-suD=_mjs5KC_1Ra3xo9kvdSxAMmeRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza-uieOvR6AQkC-suD=_mjs5KC_1Ra3xo9kvdSxAMmeRg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 11:09:23PM -0700, Andrii Nakryiko wrote:
> 
> BPF skeleton works just fine without BTF, if BPF programs don't use
> global data. I have no way of knowing how BPF skeleton is used in the
> wild, and specifically whether it is used without BTF and
> .data/.rodata.

No way of knowing?
The skel gen even for the most basic progs fails when there is no BTF in .o

$ bpftool gen skeleton prog_compiled_without_dash_g.o
libbpf: BTF is required, but is missing or corrupted.

libbpf_needs_btf() check is preventing all but the most primitive progs.
Any prog with new style of map definition:
struct {
        __uint(type, BPF_MAP_TYPE_ARRAY);
        __uint(max_entries, 1);
        __type(key, __u32);
        __type(value, __u64);
} array SEC(".maps");
would fail skel gen.

bpftool is capable of skel gen for progs with old style maps only:
struct bpf_map_def SEC("maps")

I think it's a safe bet that if folks didn't adopt new map definition
they didn't use skeleton either.

I think making skel gen reject such case is a good thing for the users,
since it prevents them from creating maps that look like blob of bytes.
It's good for admins too that more progs will get BTF described map key/value
and systems are easier to debug.

Ideally the kernel should reject loading progs and maps without BTF
to guarantee introspection.
Unfortunately the kernel backward compatibility prevents doing such
drastic things.
We might add a sysctl knob though.

The bpftool can certainly add a message and reject .o-s without BTF.
The chance of upsetting anyone is tiny.
Keep supporting old style 'bpf_map_def' is a maintenance burden.
Sooner or later it needs to be removed not only from skel gen,
but from libbpf as well.

> No one is asking for that, but they might be already using BTF-less
> skeleton. So I'm fixing a bug in bpftool. In a way that doesn't cause
> long term maintenance burden. And see above about my stance on tools'
> assumptions.

The patch and long term direction I'm arguing against is this one:
https://patchwork.kernel.org/project/netdevbpf/patch/20210319205909.1748642-2-andrii@kernel.org/
How is this a bug fix?
From commit log:
"If BPF object file is using global variables, but is compiled without BTF or
ends up having only some of DATASEC types due to static linking"

global vars without BTF were always rejected by bpftool
and should continue being rejected.
I see no reason for adding such feature.

> we both know this very well. But just as a fun exercise, I just
> double-checked by compiling fentry demo from libbpf-bootstrap ([0]).
> It works just fine without `-g` and BTF.
> 
>   [0] https://github.com/libbpf/libbpf-bootstrap/blob/master/src/fentry.bpf.c

yes. the skel gen will work for such demo prog, but the user should
be making them introspectable.

Try llvm-strip prog.o
Old and new bpftool-s will simply crash, because there are no symbols.
Should skel gen support such .o as well?
I don't think so. imo it's the same category of non-introspectable progs
that shouldn't be allowed.

> Yeah, that's fine and we do require BTF for new features (where it
> makes sense, of course, not just arbitrarily).

I'm saying the kernel should enforce introspection.
sysctl btf_enforced=1 might be the answer.
