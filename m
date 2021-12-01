Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618B8465424
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbhLARkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhLARkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:40:41 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E29CC061574;
        Wed,  1 Dec 2021 09:37:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so290404pjb.5;
        Wed, 01 Dec 2021 09:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SU/hycYSpFf1t+rfHmtzU74hh3zXq3CMqi0YestRe84=;
        b=gfhF1Nk3oI52R42qw4/FDzh3xFuGL0bKVjl9RCpfcWVR4fjxnU6GkQs0CA5Li1N3yo
         QfV9ktXcbD4TohBgDFT6ebXwGOTqnBt63vOVS3KNn3OHHuiZkhcKLSm7C/QVdHMYddFb
         PI2sM4jXqrC1cucn33GL1C4rGKnVCQrFCBXUz1OYHDBMSmZpvCE2sc3XLEu8Tpx35X1v
         Q+g9/sUb1uarkmceirhx3TK8nSjcVViogvI1tXz3lTn7pVjvFvj6/ekZUoCfGfac1Mo3
         p+VasD1nqxLxVT5nPnE0RN0U1lhI4DdwALgLeXq6asH3C/xgAVduRGDPYC/H7oTY7OmV
         Q0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SU/hycYSpFf1t+rfHmtzU74hh3zXq3CMqi0YestRe84=;
        b=x7nqENGt01LNpve4rObMdkNvKvmCb8l2Wm6MQUUwVXb/T6thD/ivxXrBQ28i7kLyVt
         GI4QvB9iVBN90256P8Wb1VM5xFBxzIqc3V2x6qUn9vLWk25cZujGD3zwVi/tCBSPaTt/
         Fpe9WTKpSPWEHWSYbNG94OvFdxLXSOm0zBYVAb3fKWwy4clQ1mVTGAMy3YYUyM8t5xwU
         vi3lJ7ycVwH04MXgPxtjnfEEuQCVcrHbTGEdflRMyENYZq0G61JHxgttdmwJR13MreXk
         X1lzUuY5CPNWCMnUzFw0PS9UqxnVuHv290voEcOHE+1Hu2d3fkGQsHdLEpWOTHSygo7B
         ZiiQ==
X-Gm-Message-State: AOAM532utux/dBmXdB/DkAxk1S/N+4l+TWiHsVlOwRDTkxEoyW4eNhgZ
        7RU230xMkzxO08aGIP2hJj4vFLe5g9H0nE+XIdE=
X-Google-Smtp-Source: ABdhPJz8W9WDxD5umtQTFbVGgcG3Mtm2mfoqjvBGqNA6YLcFyefgewxL/BJpDA75YleCCwK0SMZ52QD3HquiDhjXSx0=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr9027361pja.122.1638380239855;
 Wed, 01 Dec 2021 09:37:19 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
 <YaPFEpAqIREeUMU7@krava> <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Dec 2021 09:37:08 -0800
Message-ID: <CAADnVQ+6iMkRh3YLjJpyoLtqgzU2Fwhdhbv3ue7ObWWoZTmFmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for
 tracing programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 11:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> Hm... I'd actually try to keep kprobe BTF-free. We have fentry for
> cases where BTF is present and the function is simple enough (like <=6
> args, etc). Kprobe is an escape hatch mechanism when all the BTF
> fanciness just gets in the way (retsnoop being a primary example from
> my side). What I meant here was that bpf_get_arg(int n) would read
> correct fields from pt_regs that map to first N arguments passed in
> the registers. What we currently have with PT_REGS_PARM macros in
> bpf_tracing.h, but with a proper unified BPF helper.

and these macros are arch specific.
which means that it won't be a trivial patch to add bpf_get_arg()
support for kprobes.
Plenty of things to consider. Like should it return an error
at run-time or verification time when a particular arch is not supported.
Or argument 6 might be available on one arch, but not on the other.
32-bit CPU regs vs 64-bit regs of BPF, etc.
I wouldn't attempt to mix this work with current patches.
