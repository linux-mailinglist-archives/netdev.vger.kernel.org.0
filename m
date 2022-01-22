Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA449695D
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiAVCMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiAVCMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:12:49 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A86C06173B;
        Fri, 21 Jan 2022 18:12:48 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e8so10311190plh.8;
        Fri, 21 Jan 2022 18:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vbq1CoirrIPc/irYdIqF32Z75Ao16SkyouajMFOz9FE=;
        b=hy/xNnpzOFNea8Q6Wrdt/st/MManOdmnlsLv24Mr072ketpMDL/QyeRvfcj9kK3N/R
         ifg9+wcz3giZqJv3TtCp8HgGj64XgE2Qj6tnAJtr254tdP3JKj1nHIeduCxOerGMOyxz
         V/I30zsqQdFwxqG0SXF95PF9/lsxw/JhkE51PpUyQVmCSkCUhGXwQq/IS3Hoz9U/KMdf
         u3iiEKniKq/t/LHBwp61IhIbtXAW63UQ0NlWBMZUfbsPfKxAODzeTDcxzzILA6RBo+OJ
         sUPsZ+gAIuUbr5tnitXqUyuhGDxe7FQiF17cG192XkaujmZXPxMeO14Q28/RCn2XYuZI
         9pYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vbq1CoirrIPc/irYdIqF32Z75Ao16SkyouajMFOz9FE=;
        b=OXtFNApv58T8w8MrgSH+4SEJ68oAVVxrlVwg+UYtJaihUtk1Jo3NOvHElrOj3MajO6
         0J7Cy2cl9Qerzc7Y6qjO8Rr0v5h5+5o2ErCWevFNoA5i2Jh/p3dSnFcbLjf5XdzeoYNE
         oEuEzRgWcH7xCKy5MIWbIoDbCM1aAWRILrv0Yhqgs49lcS2FFZqnOqEBGIJKjcgFVCh5
         1utUyCxmH5Up/4Ar5kK8sCCzfUxShFVC1QM+VGIo/JxPCnLCobOgVhi0TfUJvMT7voFB
         +DKvqIVBkI+08vVrhz50KRSo1+x2ttXr0N35wc5ZkRuP7cOn6U4+IEvjXD60sirvpeVw
         zu5w==
X-Gm-Message-State: AOAM533jNcTmi7SA6PVUg2/akU6K5S1QuEXcvbq4RX3c3bjP7KLfBLEL
        yBGQvEibPQzHfVFM/+QdGkdTSzwneU3JtbQsIyE=
X-Google-Smtp-Source: ABdhPJzg3Qxw4vg11oNRbqos68K+7QUDYY9hez2n8l1egAmvgXV2BVdI6vc9JMhmI6jNSsLt6kiqI/LQjZcd+e+wprM=
X-Received: by 2002:a17:902:ec82:b0:14a:30bd:94bf with SMTP id
 x2-20020a170902ec8200b0014a30bd94bfmr5964697plg.78.1642817568290; Fri, 21 Jan
 2022 18:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
In-Reply-To: <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 18:12:37 -0800
Message-ID: <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 5:30 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 21, 2022, at 5:12 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jan 21, 2022 at 5:01 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> In this way, we need to allocate rw_image here, and free it in
> >> bpf_jit_comp.c. This feels a little weird to me, but I guess that
> >> is still the cleanest solution for now.
> >
> > You mean inside bpf_jit_binary_alloc?
> > That won't be arch independent.
> > It needs to be split into generic piece that stays in core.c
> > and callbacks like bpf_jit_fill_hole_t
> > or into multiple helpers with prep in-between.
> > Don't worry if all archs need to be touched.
>
> How about we introduce callback bpf_jit_set_header_size_t? Then we
> can split x86's jit_fill_hole() into two functions, one to fill the
> hole, the other to set size. The rest of the logic gonna stay the same.
>
> Archs that do not use bpf_prog_pack won't need bpf_jit_set_header_size_t.

That's not any better.

Currently the choice of bpf_jit_binary_alloc_pack vs bpf_jit_binary_alloc
leaks into arch bits and bpf_prog_pack_max_size() doesn't
really make it generic.

Ideally all archs continue to use bpf_jit_binary_alloc()
and magic happens in a generic code.
If not then please remove bpf_prog_pack_max_size(),
since it doesn't provide much value and pick
bpf_jit_binary_alloc_pack() signature to fit x86 jit better.
It wouldn't need bpf_jit_fill_hole_t callback at all.
Please think it through so we don't need to redesign it
when another arch will decide to use huge pages for bpf progs.

cc-ing Ilya for ideas on how that would fit s390.
