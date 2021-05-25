Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21F83908D5
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhEYSX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 14:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhEYSXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 14:23:25 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B145C061574;
        Tue, 25 May 2021 11:21:55 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a4so24601769ljd.5;
        Tue, 25 May 2021 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eiMXbPyZeBG/jx13ONZ4/fh0f8muodUmcHj/milF8iQ=;
        b=Ou6LgZu4cXNTamAmRMe45RHSWi5Qa9R6Bs8jinJtVM8zBz7fIZ75ozXemeTg+hb77f
         URI/+chK+9XJNdbxWWe2qMDppXxNbo3o6E2f+DxWcBtKg1nH68I7MIU8cm03pByqzLEX
         Yqp+gf3IcjqQajPWilxdK9rMt0/w2rP8T88iYbxdWO8SJz+16XKRnyOdOBEwlDmbcP90
         LP7wmbO4oXqkfaPOOsu6gCh3da2mIBuMesYGNIr+L9Y9ZrE+xztVFFiPE3e55cziNqs9
         X/CmVTUPtkC3zWzJr4H2vGFa4jGunEWOVdTUYfJcCU+FM7PSlDeHun1a6KP1T2WQTOe9
         ynVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eiMXbPyZeBG/jx13ONZ4/fh0f8muodUmcHj/milF8iQ=;
        b=aJUIRoCelUVCxhm/MN0ckpiJHWE7eT6GW0OgwrqPYCga4PJdX/CMoiOx8hGd/1m6z/
         gZMVue7YabrPZH/d70GH4SXH0CZY5pe2rRi0Yb2culH+Vr8hFZY5Q2rrq0oY0MoHA504
         +zQ2oVIR7DYm90YdgE2cRNlg0P90VHuvDExoCg8jynq8YBiFsF2SMtaFTMYMB2KruyQZ
         OAK0BoGMAjvWT0YGhab4HP++VeFnLQ3f7KrrYASkFSC5z3Sdr7rwsWnpHs0rjPQKVc6z
         uWGJvgJDAhFx2JEz166hC6AmyuvHCon4fvKckRnaLwz8pHf+EP3KOb46XEg9HSs7og69
         8wsg==
X-Gm-Message-State: AOAM533LElUfR6H9kYygckybWPWzFl4QHM2Co1c/LWErDa10x2gcTi25
        fJQ2TuF4SJsdzidd9pnECr3mJFGOHAkTK0agA80BkFBu
X-Google-Smtp-Source: ABdhPJwLJnFWv64jHhseXf48OpIzHl1VRV2iVtp16ZOgTdMBFymqeNDt8EeT23LyLYZyGjTabpQOgc2Y/9ZuDSbYUBM=
X-Received: by 2002:a05:651c:145:: with SMTP id c5mr20789488ljd.204.1621966913252;
 Tue, 25 May 2021 11:21:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com> <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
In-Reply-To: <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 May 2021 11:21:41 -0700
Message-ID: <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 9:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, May 24, 2021 at 8:16 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sun, May 23, 2021 at 9:01 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, May 21, 2021 at 2:37 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > Hi, Alexei
> > > >
> > > > On Thu, May 20, 2021 at 11:52 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > > > and helpers to operate on it:
> > > > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > > > long bpf_timer_del(struct bpf_timer *timer)
> > > >
> > > > Like we discussed, this approach would make the timer harder
> > > > to be independent of other eBPF programs, which is a must-have
> > > > for both of our use cases (mine and Jamal's). Like you explained,
> > > > this requires at least another program array, a tail call, a mandatory
> > > > prog pinning to work.
> > >
> > > That is simply not true.
> >
> > Which part is not true? The above is what I got from your explanation.
>
> I tried to write some code sketches to use your timer to implement
> our conntrack logic, below shows how difficult it is to use,

Was it difficult because you've used tail_call and over complicated
the progs for no good reason?

> SEC("ingress")
> void ingress(struct __sk_buff *skb)
> {
>         struct tuple tuple;
>         // extract tuple from skb
>
>         if (bpf_map_lookup_elem(&timers, &key) == NULL)
>                 bpf_tail_call(NULL, &jmp_table, 0);
>                 // here is not reachable unless failure
>         val = bpf_map_lookup_elem(&conntrack, &tuple);
>         if (val && val->expires < now) {
>                 bpf_tail_call(NULL, &jmp_table, 1);
>                 // here is not reachable unless failure
>         }
> }
>
> SEC("egress")
> void egress(struct __sk_buff *skb)
> {
>         struct tuple tuple;
>         // extract tuple from skb
>
>         if (bpf_map_lookup_elem(&timers, &key) == NULL)
>                 bpf_tail_call(NULL, &jmp_table, 0);
>                 // here is not reachable unless failure
>         val = bpf_map_lookup_elem(&conntrack, &tuple);
>         if (val && val->expires < now) {
>                 bpf_tail_call(NULL, &jmp_table, 1);
>                 // here is not reachable unless failure

tail_calls are unnecessary. Just call the funcs directly.
All lookups and maps are unnecessary as well.
Looks like a single global timer will be enough for this use case.

In general the garbage collection in any form doesn't scale.
The conntrack logic doesn't need it. The cillium conntrack is a great
example of how to implement a conntrack without GC.
