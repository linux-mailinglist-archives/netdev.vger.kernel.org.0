Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B024A78EE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346994AbiBBTuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346983AbiBBTue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:50:34 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17653C061714;
        Wed,  2 Feb 2022 11:50:34 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id x6so268949ilg.9;
        Wed, 02 Feb 2022 11:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=reFpY/nGEqbODh2C3Y1S9N9DI33hc54Qf2pLCwPc5Lc=;
        b=VXgajZ+4M55hMA9KfW8qel22D5zpO8LMLO/7Na8AqeVmOMEdxS2E5r+aHk4ZrY1ZiX
         OptZ5J+Dib4AihcIUQpQjmG0VwKTBQl8bijXPHHtolYbn30QIY6VHsLoonXdydkJ5ZoH
         m/7+ARO01Wq8q1zx1KH/cpZEpen6qzuX75fXQ8DZXPhm4lxcAd7Q1xxK3XiORd0SECFs
         aQ91byqjYllBQbj2iy3GtK1llrdoKtmUDrq3SRCekv7ic3UvjMiZwfBY7CafOptYlgNh
         lG8m0xIryoen/2/1zpTbQl9XtrfkHMzXyAoOVVrPLiKgXxwsKMgUJ0J2Wl9iGBKveFrS
         h+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=reFpY/nGEqbODh2C3Y1S9N9DI33hc54Qf2pLCwPc5Lc=;
        b=ql616+yZ/4l7lHoAME+dKVyOYgC7BjTsMZUmSpWFb5GpN8du/Qll73l+LyQZvCgfe5
         m2f07+EhfiOCjhJL31NF7Wtq+cYm1tDG5DF0IjVnDGCycuLZJE+wAoUPpF2oDpjDv06s
         m2axw6GGVR2OkhvjBGw7IOtsIq/q7WjWeKX8PxxsffzwcdacCSkHtP/18ipUE38is2Os
         SDeJngUqvPclv6McJcVCDW/iEjWqv70me5q6TDk3mhu0JI0Ia6QzLo3v0JHAcuQjiqnz
         Y/bmfpcBlCuZE4YFpeECcWDGJR8LHfqYuBPK5zZ0l0XuAaMdxaKSLuP7z1FxlvMzpQqT
         np2w==
X-Gm-Message-State: AOAM533mAlahpw4XLHv/nGuNsfVewmKJZ/KdYtyZ010WCHgYXTkoR4oN
        i01WqonqIZjvrShkvtZgEzrEYB/nT3Du1lr+08M=
X-Google-Smtp-Source: ABdhPJwSBox0u3RfcOb/n7tzGCrw9ura9DRPCKY7Woc+BGKYOBB7j5TujoaYpiJiSCw9WwUgp/kn+UTZqPky92ybYMI=
X-Received: by 2002:a05:6e02:1bc7:: with SMTP id x7mr17619061ilv.98.1643831433071;
 Wed, 02 Feb 2022 11:50:33 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-10-mauricio@kinvolk.io>
 <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com>
In-Reply-To: <CAHap4zsWqpTezbzZn7TOWvFA4c2PbSum4vY1_9YB+XSfFor21g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 11:50:21 -0800
Message-ID: <CAEf4BzZipPWByN-JND=Djhhw+vpEjQScxJEPW5QTyWXozecfcg@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 3:23 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Fri, Jan 28, 2022 at 5:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > This commit implements some integration tests for "BTFGen". The goal
> > of such tests is to verify that the generated BTF file contains the
> > expected types.
> >
>
> This is not an exhaustive list of test cases. I'm not sure if this is
> the approach we should follow to implement such tests, it seems to me
> that checking each generated BTF file by hand is a lot of work but I
> don't have other ideas to simplify it.
>
> I considered different options to write these tests:
> 1. Use core_reloc_types.h to create a "source" BTF file with a lot of
> types, then run BTFGen for all test_core_reloc_*.o files and use the
> generated BTF file as btf_src_file in core_reloc.c. In other words,
> re-run all test_core_reloc tests using a generated BTF file as source
> instead of the "btf__core_reloc_" #name ".o" one. I think this test is
> great because it tests the full functionality and actually checks that
> the programs are able to run using the generated file. The problem is
> how do we test that the BTFGen is creating an optimized file? Just
> copying the source file without any modification will make all those
> tests pass. We could check that the generated file is small (by
> checking the size or the number of types) but it doesn't seem a very
> reliable approach to me.

I think this second run after minimizing BTF is a good idea. I
wouldn't bother to check for "minimal BTF" for this case.

> 2. We could write some .c files with the types we expect to have on
> the generated file and compare it with the generated file. The issue
> here is that comparing those BTF files doesn't seem to be too
> trivial...

But I would add few realistic examples that use various combinations
of CO-RE relocations against Linux types. Then minimize BTF and
validate that BTF is what we expect.

As for how to compare BTFs. I've been wanting to do something like
btf__normalize() API to renumber and resort all the BTF types into
some "canonical" order, so that two BTFs can be actually compared and
diffed. It might be finally the time to do that.

The big complication is your decision to dump all the fields of types
that are used by type-based relocations. I'm not convinced that's the
best way to do this. I'd keep empty struct/union for such cases,
actually. That would minimize the number of types and thus BTF in
general. It also will simplify the logic of emitting minimized BTF a
bit (all_types checks won't be necessary, I think).

As I also mentioned in previous patches, for types that are only
referenced through pointer, I'd emit FWD declaration only. Or at best
empty struct/union.

With all that, after btf__minimize() operation, comparing BTFs would
be actually pretty easy, because we'll know the order of each type, so
using the
VALIDATE_RAW_BTF() (see prog_tests/btf_dedup_split.c) the tests will
be easy and clean.


One last thing, let's not add a new test binary (test_bpftool), let's
keep adding more tests into test_progs.

>
> Do you have any suggestions about it? Thanks!
