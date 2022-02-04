Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139534AA0E8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiBDUHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiBDUGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:06:31 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30281C06175A;
        Fri,  4 Feb 2022 12:05:55 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e8so5749043ilm.13;
        Fri, 04 Feb 2022 12:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vewvo9URC2TGbxYKSnRoevndSWbxtndwxBbEgRgV2PA=;
        b=DcADCEqePRULABPpQih8H5A34CrmluUBW8yP9uVoYDhsm5oUzAbc4ruI6uMM10ecV+
         WUp14nqrooyPnpATQMlxkLH4/V1j1HkoViZxz2pw6A9B4koyc3JOPlF/hI7m+QArUWBi
         l26qneLY7HBa5qESzYttFYvZjpEVD/MFntpL/NPQBkeq5MwOnn/+GwahOGxsKSBlQS6x
         pC+R4GyehsFCk+of8g4o5W60o8n742c9DsyO7XZKuFKmqVPfR9SPZRR6lgWlwLY4KU2X
         yKx/gKbmMUbsixcrLgEgYRMtHYs0wYeU0N88V0fwrpl4/DtRHyBgf64NodMXDsZp5aR6
         e/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vewvo9URC2TGbxYKSnRoevndSWbxtndwxBbEgRgV2PA=;
        b=P7Sxus2TWnRiSJD3aZ9RJosx9E6OxLaDsdN4XuGYu/x9vtZ8LJPt6vUPfmapBkLFrd
         fYzOR8E40JUV20HHGA4nFyyFVpLVF9N61VhxiW3OrL43qO6sA/27ztXdxLNyzJiZQb9n
         nkVAnPIahxwqolpwuaBGS9KHN12VcWwU8hT1hvMQ06MWZXCjpfpT8YfrSdpOqU5dXG0H
         St9hqLoKLVCiayU8u1vdXxIF3qbXQoj8vG9akK2p6kPwixUo03B72NynhP7xpzg+lDck
         bH+1ojddcYLNr0PvUMMfnO7LGhrJJyaIlYSC7NXjkVFg4tZAwPNiTpch4OSwUy/BTD4+
         VFVg==
X-Gm-Message-State: AOAM530crHqX8no3vnuhXGC1fAxKKcN7BdAhF+4nAzWBB4zIsy2dWfHb
        k4jO2RW1+/B/sTvXRY7E81BHT5ldLC0y/p/UlI8SeV4m
X-Google-Smtp-Source: ABdhPJw/HjQ8G6HT82k+Bj4knc0BJq0R8ftmT0MmsGU3xskZvdHri2SkT6XcaMPy/tp21+oZokQZxkuX9EVACKm6jaA=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr402406ili.239.1644005154554;
 Fri, 04 Feb 2022 12:05:54 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-10-mauricio@kinvolk.io>
 <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com>
 <CAEf4BzZipPWByN-JND=Djhhw+vpEjQScxJEPW5QTyWXozecfcg@mail.gmail.com> <CAHap4zsiCucKjxWU8NhLGKTxYHoh_wHwjirOcSfMwNF38axDcQ@mail.gmail.com>
In-Reply-To: <CAHap4zsiCucKjxWU8NhLGKTxYHoh_wHwjirOcSfMwNF38axDcQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 12:05:43 -0800
Message-ID: <CAEf4BzbEUg7vxYXKNbnOFoa_EBRmASiLd+LCCCDdihSoYddCyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 9/9] selftest/bpf: Implement tests for bpftool
 gen min_core_btf
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 1:17 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Wed, Feb 2, 2022 at 2:50 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 3:23 PM Mauricio V=C3=A1squez Bernal
> > <mauricio@kinvolk.io> wrote:
> > >
> > > On Fri, Jan 28, 2022 at 5:33 PM Mauricio V=C3=A1squez <mauricio@kinvo=
lk.io> wrote:
> > > >
> > > > This commit implements some integration tests for "BTFGen". The goa=
l
> > > > of such tests is to verify that the generated BTF file contains the
> > > > expected types.
> > > >
> > >
> > > This is not an exhaustive list of test cases. I'm not sure if this is
> > > the approach we should follow to implement such tests, it seems to me
> > > that checking each generated BTF file by hand is a lot of work but I
> > > don't have other ideas to simplify it.
> > >
> > > I considered different options to write these tests:
> > > 1. Use core_reloc_types.h to create a "source" BTF file with a lot of
> > > types, then run BTFGen for all test_core_reloc_*.o files and use the
> > > generated BTF file as btf_src_file in core_reloc.c. In other words,
> > > re-run all test_core_reloc tests using a generated BTF file as source
> > > instead of the "btf__core_reloc_" #name ".o" one. I think this test i=
s
> > > great because it tests the full functionality and actually checks tha=
t
> > > the programs are able to run using the generated file. The problem is
> > > how do we test that the BTFGen is creating an optimized file? Just
> > > copying the source file without any modification will make all those
> > > tests pass. We could check that the generated file is small (by
> > > checking the size or the number of types) but it doesn't seem a very
> > > reliable approach to me.
> >
> > I think this second run after minimizing BTF is a good idea. I
> > wouldn't bother to check for "minimal BTF" for this case.
> >
>
> Right. Do you want this to be part of this series or can we merge later o=
n?

Can be done separately, probably, but it shouldn't be a lot of code
(just call bpftool and use its output as input to core_reloc tests
again). Should be a generic part of core_reloc.c selftest.

>
> > > 2. We could write some .c files with the types we expect to have on
> > > the generated file and compare it with the generated file. The issue
> > > here is that comparing those BTF files doesn't seem to be too
> > > trivial...
> >
> > But I would add few realistic examples that use various combinations
> > of CO-RE relocations against Linux types. Then minimize BTF and
> > validate that BTF is what we expect.
> >
>
> What do you mean by "realistic examples"? Aren't the BPF programs
> (that use core_reloc_types.h) I added in this commit good enough for
> this test?

Realistic as in using real kernel types. core_reloc_types.h are
synthetic. Both are useful, but seeing big task_struct compressed to
just few relevant fields and CO-RE relocations still working would be
very convincing.

>
> > As for how to compare BTFs. I've been wanting to do something like
> > btf__normalize() API to renumber and resort all the BTF types into
> > some "canonical" order, so that two BTFs can be actually compared and
> > diffed. It might be finally the time to do that.
> >
> > The big complication is your decision to dump all the fields of types
> > that are used by type-based relocations. I'm not convinced that's the
> > best way to do this. I'd keep empty struct/union for such cases,
> > actually. That would minimize the number of types and thus BTF in
> > general. It also will simplify the logic of emitting minimized BTF a
> > bit (all_types checks won't be necessary, I think).
> >
> > As I also mentioned in previous patches, for types that are only
> > referenced through pointer, I'd emit FWD declaration only. Or at best
> > empty struct/union.
> >
> > With all that, after btf__minimize() operation, comparing BTFs would
> > be actually pretty easy, because we'll know the order of each type,
>
> Why do we know the order of each type? I think the order of the types
> in the generated BTF files depends on:
> 1. The order or the relocations on the BPF object. (I'm not sure if
> the compiler generates them in the same order as they appear in the
> code)
> 2. BTFGen implementation: types are added recursively and there is
> also a hashmap in between.
> 3. How bpftool is invoked. bpftool gen min_core_btf ... OBJ1 OBJ2 vs
> bpftool gen min_core_btf ... OBJ2 OBJ1.
>

Hm.. the order of CO-RE relocations doesn't have any bearing on
resulting BTF. btf__normalize() will make sure that order is
"canonical", which makes two BTFs comparable. E.g., all INTs will go
before STRUCTS, and within INTs they will be sorted by name, then
size, etc. That kind of an idea. So equivalent BTFs after
normalization will end up with exactly the same contents (except,
probably, for the string section, but we won't be comparing name_off
as integers, rather strings that they point to; details).

> What I'm saying is that given a source BTF file and a BPF object I
> don't know what is the order of the output BTF file. I know we could
> run the test, check the generated output and use it for the test but
> it seems like "cheating" to me...
>
> Am I missing something?

Probably that the whole point of btf__normalize() is to ensure
canonical order, see above.

>
> > so
> > using the
> > VALIDATE_RAW_BTF() (see prog_tests/btf_dedup_split.c) the tests will
> > be easy and clean.
> >
> >
> > One last thing, let's not add a new test binary (test_bpftool), let's
> > keep adding more tests into test_progs.
> >
>
> Will do.
>
> > >
> > > Do you have any suggestions about it? Thanks!
