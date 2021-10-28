Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1C543F32E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 01:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJ1Wup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 18:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhJ1Wup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 18:50:45 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF0CC061570;
        Thu, 28 Oct 2021 15:48:17 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id v7so19418799ybq.0;
        Thu, 28 Oct 2021 15:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XDEWd71UmZvxTzsArpAs2biQyjpuM8l1zS0xZFKXZuo=;
        b=oj9OIdfkOI2Y98kNfSTajt8aFypbzsW8faeMFucHfAnYq0UzOCzPqbmtwSB8+zd35B
         4DFj0nJ89tEYq8z1SofTigBscv2d86dZYF8omV5eidUILvjGAw37HiZH3yhK8bTJHSzy
         4CO0SdJPh4OlDvjLQkKPfRBIlwoqEqiW3xUqttT2zOqu67Gcv/N4FVWaj2AMtwxKMj0T
         WZBAOfhuXKD4fWeMZ7tGigOQLE6TEZniY/l2SbiRtF3juQDUKwjn5kPGVzv9kFPP5DFn
         dQ7ofjYlw+1b4Ej/Ll8dgAhkWilCjTQ24jlddv04D4dxNEstCxaHQumo7wKHdkLG1FEm
         hYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XDEWd71UmZvxTzsArpAs2biQyjpuM8l1zS0xZFKXZuo=;
        b=MvVM4dgtvFxs5q0aXGvm99qNsP3669mUpSYLQOC8lMhF4g59D6LaldpUXVAFp3KiNB
         sgqPKfBWRNv+IaJ4pKJVtTKxKKFo6EFHlbQuo/W3Evtf9wG4lhxbhRZ0U8x7Kw1dq2Mp
         qPLG5HhNxhoNrJVT4wvs/4EhJlRD2W0pgYzyuMWfKsxhGaJyV5zQwXdjKrYD26xRKyW7
         ZRt50HXi7NhwWElR9clcBEJEXc/3oXVQs716AGIH2pjIEmQW9BppRz4414AuYgTecb9K
         RM9sxJhbx/InyeCNF7Apc7wCFjt55pslCX6rX9IKJXEYqofPAQxw9z/y/47NxkJPkc03
         ceZw==
X-Gm-Message-State: AOAM53278njOreVyBrLUPle8yJowGt15lw9vsgpcPrRJCLmrZLNqcucV
        EgY8YRVQJtMsdvJTdzGWJ86p1Wkc5dIcnfprR28=
X-Google-Smtp-Source: ABdhPJwvrt6z/zBDKEids5Um8Yh8SLubIf+SYW3/VXc6c2aGbJe0JNzqEmRHJl41jQVC14AbED58uTJrlcJR1QforpQ=
X-Received: by 2002:a25:b19b:: with SMTP id h27mr8359720ybj.225.1635461296982;
 Thu, 28 Oct 2021 15:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <20211027203727.208847-3-mauricio@kinvolk.io>
 <CAEf4BzYUXYFKyWVbNmfz9Bjui4UytfQs1Qmc24U+bYZwQtRbcw@mail.gmail.com> <CAHap4zt1jFM_hMd0mqT+158f3-C8Vn0AtZHH+pK_MxxiUan5zg@mail.gmail.com>
In-Reply-To: <CAHap4zt1jFM_hMd0mqT+158f3-C8Vn0AtZHH+pK_MxxiUan5zg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 15:48:05 -0700
Message-ID: <CAEf4BzZ5QmHwD-FNgqBsJWb2j+7iZfTNe_+E6vAS-HUrwUDmjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: Implement API for generating BTF for
 ebpf objects
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Rafael David Tinoco <rafael.tinoco@aquasec.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 3:42 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> > I don't think it's necessary for libbpf to expose all these new APIs.
> > The format of CO-RE relocations and .BTF.ext is open and fixed. You
> > don't really need to simulate full CO-RE relocation logic to figure
> > out which types are necessary. Just go over all .BTF.ext records for
> > CO-RE relocations, parse spec (simple format as well) and see which
> > fields are accessed.
>
> How do you suggest to match the types for the target BTF without
> simulating the CO-RE relocation? Are you suggesting to match them only
> by name? We want to generate the minimal BTF that is needed by a given
> object. Consider that we could generate these files for thousands of
> kernels, size is very important for us. For this reason we chose to
> simulate the relocation generating only the types (and members) that
> are really needed.
>

How many unnecessary structs are matching if you match by name only?

Keep in mind, if your kernel BTF has task_struct and task_struct___2,
then CO-RE relocation will keep matching both; and that's not an error
for libbpf if all the field offsets will be consistent.

In short, I think simple name matching for trimming down BTF is
completely adequate. CO-RE relocation has to be more strict about
matching, but the subset of types that are used will be the same or
almost the same.


> > Either way, this is not libbpf's problem to solve. It's a tooling probl=
em.
>
> I agree. When I started working on this I tried to implement it
> without using the libbpf relocation logic, but very soon I realized I
> was  reimplementing the same logic. Another possibility we have
> considered is to expose this relocation logic in the libbpf API,
> however I fear it's too complicated and invasive too...
