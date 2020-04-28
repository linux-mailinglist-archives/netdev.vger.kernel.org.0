Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22A51BCF8F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD1WOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbgD1WOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:14:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB47C03C1AC;
        Tue, 28 Apr 2020 15:14:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id l11so18136239lfc.5;
        Tue, 28 Apr 2020 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJF14BaLVM/ADkYU+eDwCN+bZs5L8nnJTZQjJY+RWHE=;
        b=pZiZUrKu6oxh5JWQBuxE7rMCpNeubHNL4SfQ2OSbMvyeepwpMLSJmlLms72zRzG9xK
         1THbrJaYQEWJQVQU+J799OffNlnza0lbLB+sB8o887Pg7wNPeA/k95nVnxWqA0KVFpuO
         WWAj+jrGaCEr4MxbeScAyEGbNpChndnSI5ibvRArWgBkf0RSxQ1za5bpWlhAkRr/KgOk
         AH7TrAHbA1lg9TBgf5uuHPSO3JPYbWuCQ5IhV846hO4ol+wgMDISLXzRLbFXfawSmILR
         JlnrCXyeHZ+66OxzfmoUTJq+9MCsBrOxz3gj+7GxvSQ7sjaMrW5tFO0o3izgZoDg1s55
         pvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJF14BaLVM/ADkYU+eDwCN+bZs5L8nnJTZQjJY+RWHE=;
        b=dA1De0/Xki0yBe0gLiF6OvuxW76/l0Rvvpp0calYzPnIV8Acdw23+rYWwx3FRopCP3
         Je7FdyUrTqPpW5u0b2XIpL1SjY1NpxcWjqx1Ni8kDhDukx4wLTzgfdbTXBGLME8yR6nV
         cZte/EatNrdXCD8iC1wh9XCelGhWtffecRgzf4ZhvzuWegCDOqHT/OvdShPNtk+Xf7i6
         6Gy852mY7C58O5HjjxK6KRXEz+VZCM5r7arRYVe5V1Xg6r44/1/Vf8NvyrgySiCj95+b
         EIR75d0y5Q1IdkmwjzKI3TGAD3nA2v8zfVLeEu73/d8z8Cr2b0gWduBQCiDPqg2AV7wo
         RGRg==
X-Gm-Message-State: AGi0Pub/bNyM2JscImFCJIrbjZ8XtT7rKBBmjiBdRytrjOqOPYgtFFEL
        +dip3VCXi1PF6UWE5SI0i01VF6G3PMWwEobdQu9A3A==
X-Google-Smtp-Source: APiQypIt/ioRgNi4WchTJEOShSA387xTAtP0jjsE7zs7FJ7Dlp5rj/LE+zKmfmfzfjXmk+aHBkDo4A0SZphkiBauvYo=
X-Received: by 2002:a19:505c:: with SMTP id z28mr2657157lfj.174.1588112043710;
 Tue, 28 Apr 2020 15:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200427234423.998085-1-songliubraving@fb.com>
 <20200427234423.998085-4-songliubraving@fb.com> <09720b42-9858-0e2f-babf-f3cd27f648e6@fb.com>
 <76D70217-F09E-46EA-AA1B-33B883C96EB0@fb.com>
In-Reply-To: <76D70217-F09E-46EA-AA1B-33B883C96EB0@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Apr 2020 15:13:52 -0700
Message-ID: <CAADnVQ+WWa0aGNYN7yrhH38EQv=RxNKp-4fOw5XL+NjUce1oGQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 3:09 PM Song Liu <songliubraving@fb.com> wrote:
> >> +
> >> +struct {
> >> +    __uint(type, BPF_MAP_TYPE_ARRAY);
> >> +    __uint(max_entries, 1);
> >> +    __type(key, __u32);
> >> +    __type(value, __u64);
> >> +} count SEC(".maps");
> >
> > Looks like a global variable can be used here?
>
> We can use global variable. But it doesn't really matter for this test.
> Any BPF program will work here. Do we really need a v6 for this change?

yes. please.
Otherwise folks will copy paste this inefficiency into future tests.
