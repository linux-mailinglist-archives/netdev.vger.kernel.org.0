Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64762C91A4
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgK3Wxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729586AbgK3Wxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:53:38 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775D3C061A47;
        Mon, 30 Nov 2020 14:52:52 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id r127so11665yba.10;
        Mon, 30 Nov 2020 14:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IVgiVGcuNuLwHmczlMBs6+awdTDl4qx6/4oj/Vf0ZOo=;
        b=r2WmhiZUBU55p7jVxU+lf6rjdNCdyj4qXLtVW/ObknkmYmyRL7x05PjzevdD1p4c/O
         ohqsuZDRbOxLioy+qwF+18DnL4WFbPD1XSiVgQ3U1tJgCB7sQnMdV2KmQ41IKNXHRgNd
         uNP1+82a+58xWV2uWsJ4yG5G2nhWrvEtayHFzFtwghNVzTdCIK0KioOCWVfPLM+qvKbF
         SaZsR/w6l5/v0day/LS0UkHRO7DvrJwyL6lYxgGEiWgwqHMBrp60MA4UJZW6eqOW5iKe
         YCaR+t2RrjeNJf+MQbMygWdn0xuaA0M39HreguO7e206Orn+e/UEq7GYOmYSIkmyU6xZ
         7r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IVgiVGcuNuLwHmczlMBs6+awdTDl4qx6/4oj/Vf0ZOo=;
        b=avO11K8twXUtMxOH5A0pQ9ud4pwmMVLyFsnkwCiRWk9zjtDNLx3Z603/3nZ7MdR/Rc
         6edLnU7yNOpmfP5Y8fjrF4pM+PBxuMSL6+DW64dz+o9TkxPwhME4yYeCRhv/BsL/Fkx6
         xw+kJKHHFAP/3QfH4ouKa/1wrlNIiQNRnKBMQoo1nP3rjLHn3qp1LbTkc1zA+Ipc0Xt2
         GM1fUXsJfM48WvPY3gB+b+aTbgppz4CYmrM/xvnKbsEwfk2C/rMdogDehyvgz94QJL2s
         FE7nuFdrDBkQGQOsmc8xkXSlIeipTdfnDIqNLl8zsnyP/nRbOsj61JQHDHz2Qg/0x9Ge
         dSAQ==
X-Gm-Message-State: AOAM533jbP9+VCHRd58A4vGZKsevOcsi4Qs/2zf8xskoYe469VLGtXme
        pvT3LsrlyjYydQHKZVvnaRjaZbaKVBYobDwJzZE=
X-Google-Smtp-Source: ABdhPJzVGG9XFN1lNFA00oqPdrdnmZG7QpgAidDjQfn/SZdgDDb/6l3upaskp9jSWIOKjrHEw1F0KFH5n5VVwEfiE88=
X-Received: by 2002:a25:2845:: with SMTP id o66mr37749996ybo.260.1606776771766;
 Mon, 30 Nov 2020 14:52:51 -0800 (PST)
MIME-Version: 1.0
References: <20201121024616.1588175-1-andrii@kernel.org> <20201121024616.1588175-6-andrii@kernel.org>
 <20201129015934.qlikfg7czp4cc7sf@ast-mbp>
In-Reply-To: <20201129015934.qlikfg7czp4cc7sf@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Nov 2020 14:52:41 -0800
Message-ID: <CAEf4BzbsN5GD62+nh7jMbdrWftATdJ57_3L_rgmG2-2=HXEV2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests/bpf: add tp_btf CO-RE reloc test
 for modules
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 5:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 06:46:14PM -0800, Andrii Nakryiko wrote:
> >
> >  SEC("raw_tp/bpf_sidecar_test_read")
> > -int BPF_PROG(test_core_module,
> > +int BPF_PROG(test_core_module_probed,
> >            struct task_struct *task,
> >            struct bpf_sidecar_test_read_ctx *read_ctx)
> >  {
> > @@ -64,3 +64,33 @@ int BPF_PROG(test_core_module,
> >
> >       return 0;
> >  }
> > +
> > +SEC("tp_btf/bpf_sidecar_test_read")
> > +int BPF_PROG(test_core_module_direct,
> > +          struct task_struct *task,
> > +          struct bpf_sidecar_test_read_ctx *read_ctx)
>
> "sidecar" is such an overused name.

How about "sidekick"? :) Its definition matches quite closely for what
we are doing with it ("person's assistant or close associate,
especially one who has less authority than that person.")?

But if you still hate it, I can call it just "bpf_selftest" or
"bpf_test" or "bpf_testmod", however boring that is... ;)


> I didn't like it earlier, but seeing that it here again and again I couldn't help it.
> Could you please pick a different name for kernel module?
> It's just a kernel module for testing. Just call it so. No need for fancy name.
