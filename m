Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3A32275B2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgGUCiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgGUCh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:37:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D92C061794;
        Mon, 20 Jul 2020 19:37:58 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so17894188qkc.6;
        Mon, 20 Jul 2020 19:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWS6zbF9VWo5oMAvQTBUWggBuwxufh05HWBlDSCFVtY=;
        b=lvbZO6T4S0JGTmIHngm7LcUDDSa7cYxUCD/N7eSe0bUJv9CdFNjPXhhBoqTZPHDm2G
         Yod4c9r3tNdUZKWAR0wIjfUxWrKIS4FlBhq1adqROQ9WbF9gMJ3ZqBgFnuyZ6fSkCjG1
         Uw99uZr155ulZEFn/20xJq4H2IVG5Ib4JPsgnakUPJiPqLvJNda9NHHAb2tNQBAlSe6l
         p/pbm1/C5XMUmsaI8hqn69uppLen6jZrMKWQZbGqsLL6jfLH2RmnozMAC5fmiVO8uBjG
         ukBg+OfAgtBvaQZ5IBveUACxNIVSMeDwFkl2z2ZgyQ2dpOpYHqdZb5qoVnRmaQ5acHmE
         8E8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWS6zbF9VWo5oMAvQTBUWggBuwxufh05HWBlDSCFVtY=;
        b=YFLOM1o2K78pLptfRK/ahpRffofGP0UhlWp/BY1gtlhZsOpykc97743XVgu3Arpwih
         3IL24LPddu3EDeHeW+UbkDsosaOi8LS937XQmbb1Vv6sqQvcM5BmL3jw/8yM7oTx05Ka
         yfQkQmWXldfTKWyfnienTutv14fK0IOP3EPGeEAhIHBKeoGUWFdbOjD0+tU598mytN9f
         z+pK+3XJFiiMaHAalxsAE4+oC5pQl00UDX+nMew0N7yamKMgogzzTF9zrz6hsL3c6Wq7
         I9efb0tfxnphAsGO+MHmc3lQg7OEREYLHM8hPs7F8VF9dZoMZ9CuNxCQl3dMxBhQCc7K
         CTSw==
X-Gm-Message-State: AOAM531QiS0eSnLFMG/wnfF8k08dcaQy+yAh2LZZOiD+INkiqeOomtxF
        8UtZTCfalHSoRwklj3+lgHTUx1i6aG2+BU7OWj0=
X-Google-Smtp-Source: ABdhPJxKgcEN3NO4mCS8ShSobjtP7cd5qUzLj6nTuBVhG2NvdlUW5ewWYlMxI9s9TVnBnlaVeKdGCU5zYmXf3rChzPk=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr25752391qkg.437.1595299077929;
 Mon, 20 Jul 2020 19:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com> <20200715214312.2266839-3-haoluo@google.com>
 <CAEf4BzYxWk9OmN0QhDrvE943YsYd2Opdkbt7NQTO9-YM6c4aGw@mail.gmail.com> <CA+khW7i9wq0+2P_M46pEv-onGXL_=sW7xE=10CYeP_yjPh-Rpw@mail.gmail.com>
In-Reply-To: <CA+khW7i9wq0+2P_M46pEv-onGXL_=sW7xE=10CYeP_yjPh-Rpw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jul 2020 19:37:47 -0700
Message-ID: <CAEf4BzY=6PH4YS8sX1SRFOj+6oQnfAk-f0P8+0XWMGMS+RJ0pw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: Test __ksym externs with BTF
To:     Hao Luo <haoluo@google.com>
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

On Mon, Jul 20, 2020 at 1:28 PM Hao Luo <haoluo@google.com> wrote:
>
> >
> > This should ideally look like a real global variable extern:
> >
> > extern const struct rq runqueues __ksym;
> >
> >
> > But that's the case for non-per-cpu variables. You didn't seem to
> > address per-CPU variables in this patch set. How did you intend to
> > handle that? We should look at a possible BPF helper to access such
> > variables as well and how the verifier will prevent direct memory
> > accesses for such variables.
> >
> > We should have some BPF helper that accepts per-CPU PTR_TO_BTF_ID, and
> > returns PTR_TO_BTF_ID, but adjusted to desired CPU. And verifier
> > ideally would allow direct memory access on that resulting
> > PTR_TO_BTF_ID, but not on per-CPU one. Not sure yet how this should
> > look like, but the verifier probably needs to know that variable
> > itself is per-cpu, no?
> >
>
> Yes, that's what I was unclear about, so I don't have that part in
> this patchset. But your explanation helped me organize my thoughts. :)
>
> Actually, the verifier can tell whether a var is percpu from the
> DATASEC, since we have encoded "percpu" DATASEC in btf. I think the
> following should work:
>
> We may introduce a new PTR_TO_BTF_VAR_ID. In ld_imm, libbpf replaces
> ksyms with btf_id. The btf id points to a KIND_VAR. If the pointed VAR
> is found in the "percpu" DATASEC, dst_reg is set to PTR_TO_BTF_VAR_ID;
> otherwise, it will be a PTR_TO_BTF_ID. For PTR_TO_BTF_VAR_ID,
> reg->btf_id is the id of the VAR. For PTR_TO_BTF_ID, reg->btf_id is
> the id of the actual kernel type. The verifier would reject direct
> memory access on PTR_TO_BTF_VAR_ID, but the new BPF helper can convert
> a PTR_TO_BTF_VAR_ID to PTR_TO_BTF_ID.

Sounds good to me as a plan, except that PTR_TO_BTF_VAR_ID is a
misleading name. It's always a variable. The per-CPU part is crucial,
though, so maybe something like PTR_TO_PERCPU_BTF_ID?

>
> Hao
