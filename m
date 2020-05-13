Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD371D225F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731871AbgEMWuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731523AbgEMWub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:50:31 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54896C061A0C;
        Wed, 13 May 2020 15:50:31 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u6so1386259ljl.6;
        Wed, 13 May 2020 15:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/Oigr+3uZfiLaPfc3epkA1fLtCLP5pj4EA6nPtKRSc=;
        b=nguQYG41jvXLgEprtQDdE6GosUcmgMemKIqnlJFnYAKpswtpWrij3m9IxHQf2uybjk
         YDCXvtRdVkyWV97328Fmx0UIzdICAfkJSCtgy2iJVvgEd7y6+goFlrxA3hF7tVbD293m
         Qxd6YFQZOd+kaEVycgFI3ckc6myLE/UZoEBQVHoh5SIwqUjpK9tiG0mtM99sr2xscQJ7
         GJ3QMagKYZcu/CYzlasjlUEbN/gw8sKobma0dlViXzzLCy/9WzdfnjSTJ4roo+pf8KQc
         K2ri1f2rWt4nkcV+tqzPXw/rWiYtMXdS/k49iXL0fZQzUljf5lQAUL5EBPienMqLsmz6
         3jPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/Oigr+3uZfiLaPfc3epkA1fLtCLP5pj4EA6nPtKRSc=;
        b=Qs/Vux6XASl5JOki3TI0QacvsxXJiH81pTcBfxdYZNr2fMaqekwtYcWxfER+dfCjQR
         e927IanvpvedaGyKQ7duPKu53V8W6AleDg1lWm7Da4CDA5mvQa8UBhU0gPkPLE+ErxCN
         gwzYD2fJ0cmRAmbCIfuI3iMj5JIkHfrcRbUUr3xL2at3rpwFd+PjrFq3DXdifwaByUYn
         Vk6GpAE81tYsufdnKzRNOjPEHn9ZtLTz5L3YXxIP05bNvqcElf9WON8DL64aIdU0r2rj
         QENhTw4o0Bmw8TpLhSVe/SozX44K1F3UlQepmyzFNU/7EaWQcgCEckqlFxb4fZjNm9hZ
         rHAg==
X-Gm-Message-State: AOAM530K85fiYEuyg4zxl/44nLrhwLzcgND4bRsx3UwQfVk2mH6b2l75
        2ViW15b8jzFOwRCL/a+L08uBZp60pCGYi5B0pfY=
X-Google-Smtp-Source: ABdhPJzN3ySN/Thfh2m+erEMY5/DkyOIunD3tj8A5LEQeQKv07OxjIuBwGCM5ErOhqJ4nTY4fjmjIJ6qsiCk5W+S6BQ=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr816187ljl.144.1589410229680;
 Wed, 13 May 2020 15:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com> <dc6a17197c3406d877efd98de351e57d7bbe06a5.camel@perches.com>
In-Reply-To: <dc6a17197c3406d877efd98de351e57d7bbe06a5.camel@perches.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 May 2020 15:50:17 -0700
Message-ID: <CAADnVQLPSvRCO-xxW+Rcz4bzLM-DXjSzm8AwhyogrNTufBdoNw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type printing
To:     Joe Perches <joe@perches.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 3:48 PM Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2020-05-13 at 15:24 -0700, Alexei Starovoitov wrote:
> > On Tue, May 12, 2020 at 06:56:38AM +0100, Alan Maguire wrote:
> > > The printk family of functions support printing specific pointer types
> > > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > > full details see Documentation/core-api/printk-formats.rst.
> > >
> > > This patchset proposes introducing a "print typed pointer" format
> > > specifier "%pT"; the argument associated with the specifier is of
> > > form "struct btf_ptr *" which consists of a .ptr value and a .type
> > > value specifying a stringified type (e.g. "struct sk_buff") or
> > > an .id value specifying a BPF Type Format (BTF) id identifying
> > > the appropriate type it points to.
> > >
> > >   pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
> > >
> > > ...gives us:
> > >
> > > (struct sk_buff){
> > >  .transport_header = (__u16)65535,
> > >  .mac_header = (__u16)65535,
> > >  .end = (sk_buff_data_t)192,
> > >  .head = (unsigned char *)000000007524fd8b,
> > >  .data = (unsigned char *)000000007524fd8b,
> >
> > could you add "0x" prefix here to make it even more C like
> > and unambiguous ?
>
> linux pointers are not emitted with an 0x prefix

So? This is not at all comparable to %p
