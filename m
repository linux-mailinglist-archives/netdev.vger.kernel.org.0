Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76184369C03
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhDWVYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhDWVYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:24:06 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E9BC061574;
        Fri, 23 Apr 2021 14:23:28 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a25so43861994ljm.11;
        Fri, 23 Apr 2021 14:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06QpjWYb7DiOltb42IDplNjEQEY7iBsneRgAjl/ONFw=;
        b=j+zQcnYcEiaqZ1S3Lpb/R9UalXzdAP1KX+vxbTrEVPUkD/kEXkzkEQiqe+rXEqD3Ei
         mmyfU+xbb6okvIpvPdUoEk5cuDPZ+F2wqJh9bmiu4voGrAJz3WwZnP456obHSMrzTnam
         UGE2aJw+Bj5RzsJO0wEM1Mbj4m8FcNnOm+2sTGVUb4IUsPVf4VpqIjC52GRXrYIBrRmC
         O+rHTfWi8jUNl5NddMDYLdmcY6uv6/AXeH125Wwg+hEU8ITXEITkAq0ZX9JyPf6NebCS
         yjSOgsTEJc7zWLnHrJM+AfqIrHz3cQUV5fKUiSvDKTKAk/Sjge6ykbToVPFb7nSl786P
         wAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06QpjWYb7DiOltb42IDplNjEQEY7iBsneRgAjl/ONFw=;
        b=gYb/9h42vmZN99NLqY2LSHG2LQMav/jv/6NkYzUcP+kCmAjhh44DqE2/H6OdJAi5Jx
         YPobROH6fldIseU0Xi0hpJGeLGtnFbydEKSG/6zLwWId73Pv6xDe1UUmtQE/PVqimSSG
         PCoUJVWegw1OrC8SyxU/htb0vVxuj5Q+HNYDquwu4BcEAVJp7gNIthzamqFHhQR7xJd8
         fXdjfSOK7ktb9C7Z6f6ruCJRDkMiUx2Ok5ArNk8NmAJv2dUUkrUYwiWmQLFP+SeFFRVq
         1nLZ/EzwCs1+iWDqO0ZsqfkmDrWsc+cqvFr74xIfXW4uW+aY7BsY2TJIJeURnRL2uO3x
         XwHA==
X-Gm-Message-State: AOAM532eHgGffu5pyKasWF0XqvtU6TdMs6fhDlrVU+LYYq44kk0/IUSM
        YCFTFaTmMOEG3D9iTcRB1OycJeWYXRFktymfec0=
X-Google-Smtp-Source: ABdhPJxnLoKLA+V80pCouPj9Q6yty7J1Gql/VEfwzG8hbXcjtL18dH5nl3iQ+MNrI4C5qV2tsV0M9GH3+wc+sC+9K6Y=
X-Received: by 2002:a2e:6c0d:: with SMTP id h13mr3842852ljc.486.1619213007208;
 Fri, 23 Apr 2021 14:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210423181348.1801389-1-andrii@kernel.org> <20210423181348.1801389-18-andrii@kernel.org>
 <5d96d205-1483-95a4-dc36-798fef934f72@fb.com>
In-Reply-To: <5d96d205-1483-95a4-dc36-798fef934f72@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 14:23:15 -0700
Message-ID: <CAADnVQ+20NcPHKYyMpAYr6SQ2fuvr4yqu5eiY90hL8J9-t1L9w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 17/18] selftests/bpf: add map linking selftest
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 11:54 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> > Add selftest validating various aspects of statically linking BTF-defined map
> > definitions. Legacy map definitions do not support extern resolution between
> > object files. Some of the aspects validated:
> >    - correct resolution of extern maps against concrete map definitions;
> >    - extern maps can currently only specify map type and key/value size and/or
> >      type information;
> >    - weak concrete map definitions are resolved properly.
> >
> > Static map definitions are not yet supported by libbpf, so they are not
> > explicitly tested, though manual testing showes that BPF linker handles them
> > properly.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> [...]
> > +
> > +SEC("raw_tp/sys_exit")
> > +int BPF_PROG(handler_exit1)
> > +{
> > +     /* lookup values with key = 2, set in another file */
> > +     int key = 2, *val;
> > +     struct my_key key_struct = { .x = 2 };
> > +     struct my_value *value_struct;
> > +
> > +     value_struct = bpf_map_lookup_elem(&map1, &key_struct);
> > +     if (value_struct)
> > +             output_first1 = value_struct->x;
> > +
> > +     val = bpf_map_lookup_elem(&map2, &key);
> > +     if (val)
> > +             output_second1 = *val;
> > +
> > +     val = bpf_map_lookup_elem(&map_weak, &key);
> > +     if (val)
> > +             output_weak1 = *val;
> > +
>
> There is an extra tab in the above line. There is no need for new
> revision just for this. If no new revision is needed, maybe
> the maintainer can help fix it.

Sorry. I applied without it. Pls fold the fix in some of the future patches.
