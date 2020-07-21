Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4202228658
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbgGUQpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgGUQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:45:39 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A88C0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:45:38 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d16so15720253edz.12
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 09:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDLw9Dcw3YPv5eg4D1cNA4KJREZ+5phRSHLKAVCSqo4=;
        b=sWaGYNFNvLHfLnFqhWw6qD05fZJ3xzg9qHpo5WavC+HOa4H9WOO8R58q/QpUclGLry
         9IL4j0cs6T2tzt1njgxmRIdcHQe5/HHEbENPKtlUivjjo0774Sk4dPYbx6pNd9sj+Hba
         BGIPr7vGf3Wz1I0ZlD9HrORuybaANBJwq3p9No8LKz53+Z00y2Qe5yTAZzt4xK0KTD14
         opOIvzeXklxODdltPMXE0N5/iPdGcCtOPo35S5qmc4oYuzfqMy8yKOjCCu2miu7Qw5xg
         SL+vKrFM9D2pcb4rxS2e3UFTvCX3US6gxaITccHPkYUeoMaMFGays+1SH64jb+4HGZ6x
         uO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDLw9Dcw3YPv5eg4D1cNA4KJREZ+5phRSHLKAVCSqo4=;
        b=rmJ7cd2AGTB4k2aba838g9LCObN38udfiSGcn1+ZqU+KFTQlY886taU8wKjpT69yRJ
         lZoiAuNFkQFA+LLEYZmWIi85dltJevgBLa6fExGTCoEx+vqbQ++6wbHxG73reKpD/cQu
         m4YaAwlglTmmJbCtZYUSqmuhF+JTjeN3LduHisT2QsRoH4arOc7jTJDaKqKiZtIDBlIn
         ZwlPuL7gmVtVo6TxY2uWsTSaYUAHb/9uu5TOXuN9wUkR/gUNeyyRbInMDr+tiI0z3QL3
         H84tb6oG5Wb6vRKpNsgqSSTqqW9ZjrtrfwF7ba7EihV2HGb5986DAZDKZnihDcke+e75
         8Elg==
X-Gm-Message-State: AOAM531z8hwoLXgGq4hDDVTApU2xjw/h2ajLY+FB4uRxmnwuymS822i4
        489wwtrpvzfRjNS/G0kSXeKYsXiglMUDQJNsHOUIdQ==
X-Google-Smtp-Source: ABdhPJwFbdgTKwMQXCY5MUgVfRS3h4/ECO4sk0mNo2dLY8J6zu/iV27GdbWz0YHGFmXds1uVOpAILDeHMdcYDWpz4wY=
X-Received: by 2002:aa7:d5cd:: with SMTP id d13mr27413638eds.370.1595349937400;
 Tue, 21 Jul 2020 09:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com> <20200715214312.2266839-3-haoluo@google.com>
 <CAEf4BzYxWk9OmN0QhDrvE943YsYd2Opdkbt7NQTO9-YM6c4aGw@mail.gmail.com>
 <CA+khW7i9wq0+2P_M46pEv-onGXL_=sW7xE=10CYeP_yjPh-Rpw@mail.gmail.com> <CAEf4BzY=6PH4YS8sX1SRFOj+6oQnfAk-f0P8+0XWMGMS+RJ0pw@mail.gmail.com>
In-Reply-To: <CAEf4BzY=6PH4YS8sX1SRFOj+6oQnfAk-f0P8+0XWMGMS+RJ0pw@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 21 Jul 2020 09:45:26 -0700
Message-ID: <CA+khW7j93gtB-e8x1-Fd9sTrOaHHD7suzVaBh9gPjnOJux+-AA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: Test __ksym externs with BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ack. Will have that in v2.

Hao

On Mon, Jul 20, 2020 at 7:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 20, 2020 at 1:28 PM Hao Luo <haoluo@google.com> wrote:
> >
> > >
> > > This should ideally look like a real global variable extern:
> > >
> > > extern const struct rq runqueues __ksym;
> > >
> > >
> > > But that's the case for non-per-cpu variables. You didn't seem to
> > > address per-CPU variables in this patch set. How did you intend to
> > > handle that? We should look at a possible BPF helper to access such
> > > variables as well and how the verifier will prevent direct memory
> > > accesses for such variables.
> > >
> > > We should have some BPF helper that accepts per-CPU PTR_TO_BTF_ID, and
> > > returns PTR_TO_BTF_ID, but adjusted to desired CPU. And verifier
> > > ideally would allow direct memory access on that resulting
> > > PTR_TO_BTF_ID, but not on per-CPU one. Not sure yet how this should
> > > look like, but the verifier probably needs to know that variable
> > > itself is per-cpu, no?
> > >
> >
> > Yes, that's what I was unclear about, so I don't have that part in
> > this patchset. But your explanation helped me organize my thoughts. :)
> >
> > Actually, the verifier can tell whether a var is percpu from the
> > DATASEC, since we have encoded "percpu" DATASEC in btf. I think the
> > following should work:
> >
> > We may introduce a new PTR_TO_BTF_VAR_ID. In ld_imm, libbpf replaces
> > ksyms with btf_id. The btf id points to a KIND_VAR. If the pointed VAR
> > is found in the "percpu" DATASEC, dst_reg is set to PTR_TO_BTF_VAR_ID;
> > otherwise, it will be a PTR_TO_BTF_ID. For PTR_TO_BTF_VAR_ID,
> > reg->btf_id is the id of the VAR. For PTR_TO_BTF_ID, reg->btf_id is
> > the id of the actual kernel type. The verifier would reject direct
> > memory access on PTR_TO_BTF_VAR_ID, but the new BPF helper can convert
> > a PTR_TO_BTF_VAR_ID to PTR_TO_BTF_ID.
>
> Sounds good to me as a plan, except that PTR_TO_BTF_VAR_ID is a
> misleading name. It's always a variable. The per-CPU part is crucial,
> though, so maybe something like PTR_TO_PERCPU_BTF_ID?
>
> >
> > Hao
