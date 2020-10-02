Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9893281E26
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJBWQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:16:48 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A392FC0613D0;
        Fri,  2 Oct 2020 15:16:47 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u4so2399487ljd.10;
        Fri, 02 Oct 2020 15:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqGPTwLDruLdjQOMyo3YXpB7b4xXruKaW+NIVVD0hZc=;
        b=Biz8w7TYWU2BmCVHqFyceEdKLAmhopzgHH7dO9z7f8dCVsB/z+ULhrGkmGAf/w5OJa
         mI6TXeIMsAA8fYqQaoin+VMmltrixfp9hL+GuLC4YIM24HxPRrIVgpbeWR/RvA46nmEg
         NRhyu0BfTCxDBnRNf3k++60ergxyTG5IBc7YYtqF06iKJq4Fe8Xa1Cfr8fef1ppI0u9Q
         euYPaarnohf327Ktwi2mfdnaqjoaOOQ2Rfxhz+Oszgs0cwc6WbyVk1dCHR9Rg/o7wXER
         HpK3EmaADNHCMApjRZrPKEYHmOJpqNRNwCKTAAaXJTm7gJC/zGurtQAOdwbwa8VAcHHf
         4MHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqGPTwLDruLdjQOMyo3YXpB7b4xXruKaW+NIVVD0hZc=;
        b=kbiO9sKsLs6gTT5sgomtiz1j96ZoZXgUEPDXdbbm6Z4uRLlo5yB/LAEXrLwsWZ6yf1
         3aGn3pB1Umg46k10TYUyZSViSn7R/Rz2BYb0ZPLJb3Sizy93LTyK6cca49p0g3Qtua16
         hPpCsXUOqyRWt1Mbtb25Qc2Pf7a3J9bYZAO+z+rt7zpNFeg151mbkZGU2Q1mPjoktJ9l
         P8T/Jm3BOeYMUssgp0vKqg0PY8bCMJjAzqmM3zbh9E58ZogmvZ0H5KkDB1Meapk1J/QP
         vmHQkaVYBmJPJvf7TIpLOXJ4sHzWemUSC1jzPXDkwYHrTQJ8w5FL+4ytagafbJe0ajYj
         OSxw==
X-Gm-Message-State: AOAM530K+XBgqMRgYps006edCTFmEOEQxAVnrVw7R5ti7ngWekwLFEpQ
        GqL7si4ZBQe4uMuK4qD9HKvQ/zgFObqLL5YaIDY=
X-Google-Smtp-Source: ABdhPJxadOUkwd6VjSFMQPfU8zpwIm2qXUgaLQD2hb1vfXJnv5p3GK6I35WQ0mzevNMmNMaABcLJ/2405m8fn+I7rwM=
X-Received: by 2002:a2e:7014:: with SMTP id l20mr1355149ljc.91.1601677006107;
 Fri, 02 Oct 2020 15:16:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com> <CAADnVQK8XbzDs9hWLYEqkJj+g=1HJ7nrar+0STY5CY8t5nrC=A@mail.gmail.com>
 <CA+khW7i4wpvOsJTH4AePVsm4cAOnFoxEwEqv27tEzJrwOWFqxw@mail.gmail.com>
In-Reply-To: <CA+khW7i4wpvOsJTH4AePVsm4cAOnFoxEwEqv27tEzJrwOWFqxw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Oct 2020 15:16:34 -0700
Message-ID: <CAADnVQ+UdKjHWWojmUx5K+RjUZ=DCe6LAHwhBicv-1KkuJnPVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] bpf: BTF support for ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:48 PM Hao Luo <haoluo@google.com> wrote:
>
> Ah, this is the bug in pahole described in
> https://lkml.org/lkml/2020/8/20/1862. I proposed a fix [1] but it
> hasn't reached pahole's master branch. Let me ask Arnaldo to see if he
> is OK merging it.
>
> [1] https://www.spinics.net/lists/dwarves/msg00451.html
>
> On Tue, Sep 29, 2020 at 9:36 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 4:50 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > v3 -> v4:
> > >  - Rebasing
> > >  - Cast bpf_[per|this]_cpu_ptr's parameter to void __percpu * before
> > >    passing into per_cpu_ptr.

I've rebased it myself and applied. Thanks Hao.
