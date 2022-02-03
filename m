Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA014A8FAE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354591AbiBCVRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348776AbiBCVRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:17:23 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4CAC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:17:22 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id bx31so5852936ljb.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 13:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bRfkm7GrbFMoJBuqK0ida1mpkefkGdsknjo4++yLasA=;
        b=FbHqN0P9rw8Q0BybW2zMN3/iAfqsRvXrJ0fm8sm7m6s2D6ZhBmUQpkrHYsRB+r/sV/
         CmgchEvSDsrSY1xqpUbc9+yq4MOxBs9q5USemSuerei3lb0nVu+oPox0LFMKjMpIenGc
         QQLLBicS659vsfWsYpyIDF4SfLdgeK8NT1n4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bRfkm7GrbFMoJBuqK0ida1mpkefkGdsknjo4++yLasA=;
        b=XWQHAjBuYgsA53D9VgqlX5Qw2HgSDRRcSvWFH/G8R4bG0b3t0/oC4OXVwWo3/gdKfX
         41fq3d8sdrHmCOpL0MRLbyCZBcAhBnSBpEJ43CjnkEqzVpEzsQUfly322BgMQSsFPpGs
         4+S2itHShdxGrXU6GNWWH6ApXY7f7phGRFDOoXw4QE+X/oK/LmNYgs4QcqkvLVF7vMRY
         XHrDjzbi/qSAcbqm/8Q310idCuwBsMj3DmZlytCrSGGfFLsir2QHRy7kksUc8hyOzu+3
         Q6MzUFHp4DjTxQn9dzwe0jXZCQ6VLebpThoBUVDR4Nn8cH8LY3bbxOKCioyXIJTZ3Wvs
         B3cw==
X-Gm-Message-State: AOAM533gYtNAhfTPit873i64IVOeuhzu5/7jgv7zpwD3uHgpIXGmFXCv
        eCdBqhXeuZlu/7ma0Gy/9EYRVBM3t2b/wWHrfcCiOw==
X-Google-Smtp-Source: ABdhPJwI/FQ/A34LE1OPELMCwYQPioB5eE3RDTq1WzznT3jPKZdTtcD8jmNuPeoQFmFu66hx5z0zfg3iIg7mBPrKqt0=
X-Received: by 2002:a2e:b8d6:: with SMTP id s22mr24667013ljp.218.1643923040997;
 Thu, 03 Feb 2022 13:17:20 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-10-mauricio@kinvolk.io>
 <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com> <CAEf4BzZipPWByN-JND=Djhhw+vpEjQScxJEPW5QTyWXozecfcg@mail.gmail.com>
In-Reply-To: <CAEf4BzZipPWByN-JND=Djhhw+vpEjQScxJEPW5QTyWXozecfcg@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 16:17:09 -0500
Message-ID: <CAHap4zsiCucKjxWU8NhLGKTxYHoh_wHwjirOcSfMwNF38axDcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 9/9] selftest/bpf: Implement tests for bpftool
 gen min_core_btf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 2:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 3:23 PM Mauricio V=C3=A1squez Bernal
> <mauricio@kinvolk.io> wrote:
> >
> > On Fri, Jan 28, 2022 at 5:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk=
.io> wrote:
> > >
> > > This commit implements some integration tests for "BTFGen". The goal
> > > of such tests is to verify that the generated BTF file contains the
> > > expected types.
> > >
> >
> > This is not an exhaustive list of test cases. I'm not sure if this is
> > the approach we should follow to implement such tests, it seems to me
> > that checking each generated BTF file by hand is a lot of work but I
> > don't have other ideas to simplify it.
> >
> > I considered different options to write these tests:
> > 1. Use core_reloc_types.h to create a "source" BTF file with a lot of
> > types, then run BTFGen for all test_core_reloc_*.o files and use the
> > generated BTF file as btf_src_file in core_reloc.c. In other words,
> > re-run all test_core_reloc tests using a generated BTF file as source
> > instead of the "btf__core_reloc_" #name ".o" one. I think this test is
> > great because it tests the full functionality and actually checks that
> > the programs are able to run using the generated file. The problem is
> > how do we test that the BTFGen is creating an optimized file? Just
> > copying the source file without any modification will make all those
> > tests pass. We could check that the generated file is small (by
> > checking the size or the number of types) but it doesn't seem a very
> > reliable approach to me.
>
> I think this second run after minimizing BTF is a good idea. I
> wouldn't bother to check for "minimal BTF" for this case.
>

Right. Do you want this to be part of this series or can we merge later on?

> > 2. We could write some .c files with the types we expect to have on
> > the generated file and compare it with the generated file. The issue
> > here is that comparing those BTF files doesn't seem to be too
> > trivial...
>
> But I would add few realistic examples that use various combinations
> of CO-RE relocations against Linux types. Then minimize BTF and
> validate that BTF is what we expect.
>

What do you mean by "realistic examples"? Aren't the BPF programs
(that use core_reloc_types.h) I added in this commit good enough for
this test?

> As for how to compare BTFs. I've been wanting to do something like
> btf__normalize() API to renumber and resort all the BTF types into
> some "canonical" order, so that two BTFs can be actually compared and
> diffed. It might be finally the time to do that.
>
> The big complication is your decision to dump all the fields of types
> that are used by type-based relocations. I'm not convinced that's the
> best way to do this. I'd keep empty struct/union for such cases,
> actually. That would minimize the number of types and thus BTF in
> general. It also will simplify the logic of emitting minimized BTF a
> bit (all_types checks won't be necessary, I think).
>
> As I also mentioned in previous patches, for types that are only
> referenced through pointer, I'd emit FWD declaration only. Or at best
> empty struct/union.
>
> With all that, after btf__minimize() operation, comparing BTFs would
> be actually pretty easy, because we'll know the order of each type,

Why do we know the order of each type? I think the order of the types
in the generated BTF files depends on:
1. The order or the relocations on the BPF object. (I'm not sure if
the compiler generates them in the same order as they appear in the
code)
2. BTFGen implementation: types are added recursively and there is
also a hashmap in between.
3. How bpftool is invoked. bpftool gen min_core_btf ... OBJ1 OBJ2 vs
bpftool gen min_core_btf ... OBJ2 OBJ1.

What I'm saying is that given a source BTF file and a BPF object I
don't know what is the order of the output BTF file. I know we could
run the test, check the generated output and use it for the test but
it seems like "cheating" to me...

Am I missing something?

> so
> using the
> VALIDATE_RAW_BTF() (see prog_tests/btf_dedup_split.c) the tests will
> be easy and clean.
>
>
> One last thing, let's not add a new test binary (test_bpftool), let's
> keep adding more tests into test_progs.
>

Will do.

> >
> > Do you have any suggestions about it? Thanks!
