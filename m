Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4B2176DEE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCCESP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:18:15 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45666 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCCESP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:18:15 -0500
Received: by mail-qt1-f193.google.com with SMTP id a4so1823694qto.12;
        Mon, 02 Mar 2020 20:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XPKK/hU3aHPG/+2ANZF19WdvXhXKC9hTWxK85q4zBkQ=;
        b=tkGgWiDThqDhYRrBO6Zx8MLNeAdpqRTE+x+v051kBpK0Y1rw1gwKtqpJGBC1lBl8uA
         k/3i2akzztiBvjUaqREF+T+S73lUmLJVQqQDIhLLgUrvaEKfE04r5hnoXHX1Ahc9V6Mz
         RwuT0vtfTVbPsk6PsnSqOp/bbNu+Sp+mbvdoiI/jdA7a5a/I5VE++Hjcz1Jcm7uuwTCj
         D2vysWyEH4AnRhZoaD15oDVSYdUWwrqHLBLznwkwuFtk3xUYpzD1pIjtMsx8KReafWFJ
         INIZq9UXGkcSQQnPbvMe4etbyf2CqRMN2KkJgOogsQI9F8y1wUbaUqmQNMSTEWgdTWNc
         Wsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XPKK/hU3aHPG/+2ANZF19WdvXhXKC9hTWxK85q4zBkQ=;
        b=lnJ4eWZ9puXsKpnKYUkl5TSHX5HTVhpl6rJD7wwNbhHHWTL3aNHWWEYXti+NdIc9tT
         Dh+WZ7s9wIAS/yyTBr2rbI3T6U1Bp9Ma+lLMn4B+/N8XwqUQ1bg85tVWNI9uvaHl0u3l
         glCEztL0aqIv3Yh2t10EfGgFaumieciSjrU1/jAXg94HKUioQNVoEWLObHCVPmtkebY7
         h4iPLoib5qWK9+mWFNwufP47u5Frg0M+sevu+A5P9jZTPufU6iv6y2BqrKe87lsg3k4w
         uV92eIXSL4GwMdhuVj9p0Lwwsi6uumEBGFnluQ+Uicm3hwH5QHnKXxCZ+wynIojWByrP
         Aedg==
X-Gm-Message-State: ANhLgQ0sV1DCIu5xpV7geLDMgU0vYOjUWB1XvktgtsbO2GTvW+mbahYW
        E0KDWszSvIzugLrd5ubZXYnS8Diczkrgyd1eQ+Y=
X-Google-Smtp-Source: ADFU+vvCzFuIdRF/K4mbelbKZuqIn2NIaK7w+gNU+MjfyV0m257G1mTyIUzi0PRRd0205bVtUHXYQ2enuF74459+HFE=
X-Received: by 2002:ac8:4581:: with SMTP id l1mr2724534qtn.59.1583209093367;
 Mon, 02 Mar 2020 20:18:13 -0800 (PST)
MIME-Version: 1.0
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-2-andriin@fb.com>
 <20200303025035.si6agnvywvcgxj3s@ast-mbp>
In-Reply-To: <20200303025035.si6agnvywvcgxj3s@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 20:18:02 -0800
Message-ID: <CAEf4BzbMH0DPDn+CZGU7ybzwpJnDfosLB09VvrOmBGx2FERT0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 6:50 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Feb 28, 2020 at 02:39:46PM -0800, Andrii Nakryiko wrote:
> >
> > +int bpf_link_new_fd(struct bpf_link *link)
> > +{
> > +     return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
> > +}
> ...
> > -     tr_fd = anon_inode_getfd("bpf-tracing-prog", &bpf_tracing_prog_fops,
> > -                              prog, O_CLOEXEC);
> > +     tr_fd = anon_inode_getfd("bpf-tracing-link", &bpf_link_fops,
> > +                              &link->link, O_CLOEXEC);
> ...
> > -     tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
> > -                              O_CLOEXEC);
> > +     tp_fd = anon_inode_getfd("bpf-raw-tp-link", &bpf_link_fops,
> > +                              &raw_tp->link, O_CLOEXEC);
>
> I don't think different names are strong enough reason to open code it.
> I think bpf_link_new_fd() should be used in all cases.

Oh, this got simplified from initial implementation after few rounds
of refactorings and I didn't notice that now I can just use
bpf_link_new_fd() here. Will update.
