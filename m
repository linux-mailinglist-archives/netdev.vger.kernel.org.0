Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5E2CF4D1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgLDTca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbgLDTc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 14:32:29 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722B8C0613D1;
        Fri,  4 Dec 2020 11:31:49 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id e81so6472580ybc.1;
        Fri, 04 Dec 2020 11:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=voQ5lfDVMzOYam6sMYIWBPLKZkkRpZtoYUdHJkVXnyo=;
        b=MgpaSnyZbEuVQ1tq48gkH3nTUILv5dbh+fQiN7sWvrAX68uet1w9mnhMN9cz6C50kr
         9B+IgSJey1l97joP0fSN4mxjNgmrbp5FWvsfhQlKveVkGX+0cAdxVnsgwStgix5ZNrej
         r7NV16O/bHOu7yCaJ7RuJPFDMCtNGV8V3RNDuBBm5K7YFOrmywpNCD7d3T/NNsUxmY3u
         Q101YMgwA5Fs2KohhE4+T0tKNriGkSL3TvqGPVnA09l5PBLBnI2/3CKvBhyz6Oj0/OuW
         SJhzjlWvzpWyUkPDs4YJ8AqiCA/xbPKCZv+3/SNKjj1Ix21C/+Q4XMg/m8ePXEP8W+KV
         RuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=voQ5lfDVMzOYam6sMYIWBPLKZkkRpZtoYUdHJkVXnyo=;
        b=qRP+rczwuRIxFn9kkamqpd6WfEWf7vPEDiXl/ev+17ImY+X1XEj2zY0QsG3XkaToAl
         XZdhCFyT/wd4A+DGlxzDbqZ8Pd/C/1Ki3B7qrfQw9yknTPOD0+WpyJVPmTLYCbeWdykX
         NiVG+2wINGi6c/lqJvYp8y3b7bpyK9AoRA4OTG+OqeT8oZYR2gONnVQi6CDRkwC1pzCq
         BT/Tde+kBvPXQRPlkpDDmvwgrbKAkNzTNA6hJEaL5q7NSyunHu8+JZg0q5imZdVV698X
         WfvnZQ+YCBD6N/Z1mB4eUQpB0dP02Du5GvtmbUet+lksOmeF9Tf+CDga7mliVR+E9f/h
         twNQ==
X-Gm-Message-State: AOAM533edABcJ7vZHCHms8RuED4+ae0iHzEt4uA99qCUaBdh94a40M2X
        JNPE40Y3JK8CAa/2Fpgeq6DgKv9OYcupOJco1hMmdvDSgMU=
X-Google-Smtp-Source: ABdhPJzfGL7HBGF2Eg+F+OK3y9ToHuBFF2CJytCQWCAM+So+BOR8xjeYlQSdcaqAnVom2SPnni0muXJlyLjALy3Dtjk=
X-Received: by 2002:a25:6a05:: with SMTP id f5mr4486304ybc.459.1607110308781;
 Fri, 04 Dec 2020 11:31:48 -0800 (PST)
MIME-Version: 1.0
References: <20201203204634.1325171-1-andrii@kernel.org> <20201203204634.1325171-11-andrii@kernel.org>
 <20201204015358.sk5zl5l73zmcu7t2@ast-mbp>
In-Reply-To: <20201204015358.sk5zl5l73zmcu7t2@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Dec 2020 11:31:37 -0800
Message-ID: <CAEf4BzbqneM9bXn646EpNAnaZr=sStqf6guBvWvf9qtyDYO9mg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 10/14] bpf: allow to specify kernel module
 BTFs when attaching BPF programs
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

On Thu, Dec 3, 2020 at 5:54 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Dec 03, 2020 at 12:46:30PM -0800, Andrii Nakryiko wrote:
> > +     if (attr->attach_prog_fd) {
> > +             dst_prog = bpf_prog_get(attr->attach_prog_fd);
> > +             if (IS_ERR(dst_prog)) {
> > +                     dst_prog = NULL;
> > +                     attach_btf = btf_get_by_fd(attr->attach_btf_obj_fd);
> > +                     if (IS_ERR(attach_btf))
> > +                             return -EINVAL;
> > +                     if (!btf_is_kernel(attach_btf)) {
> > +                             btf_put(attach_btf);
> > +                             return -EINVAL;
>
> Applied, but please consider follow up with different err code here.
> I think we might support this case in the future.
> Specifying prog's BTF as a base and attach_btf_id within it might make
> user space simpler in some cases. prog's btf covers the whole elf file.

The problem is that there is no link from BTF to bpf_prog. And
multiple instances of bpf_progs can re-use the same BTF object and the
same BTF type ID. That would need to be resolved somehow.

But keeping our options open is a good idea either way. So I'll send a
patch to switch this to -EOPNOTSUPP (I think that's the one we need to
use for user-space).

> Where prog_fd is a specific prog. That narrow scope isn't really necessary.
> So may be return ENOTSUPP here for now? With a hint that this might
> work in the future?
