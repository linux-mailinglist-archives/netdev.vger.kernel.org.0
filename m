Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6FDA6F2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 10:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408144AbfJQIJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 04:09:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34644 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392887AbfJQIJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 04:09:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so1547624lja.1
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 01:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=+BHeK/F5ybMDXFZ+AEaCcGCTfMIh3DPn6Dqiw81kHjE=;
        b=POWdzom6/TY1uJIxOGrqZoCLQ+/GJyt5+x7zpCT6cU0P30gUN5NoDvGNpTGCncee4N
         J9wDvZ56na6rZbjug8MI6b/Y54VFeDL16SGgBjvIConmvFAQAZFKn2Lqti/5aOkgtRMH
         1lxP1tHdP2yiVAACMXoSSPy3hR7wQeJCN73QI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=+BHeK/F5ybMDXFZ+AEaCcGCTfMIh3DPn6Dqiw81kHjE=;
        b=ZL4qJ3Td/ie+xTzVuFcMZ28EcfN0DJmME6upYpJpWs4ZSbI0QBHpkoth3UJUq78H+I
         fnFzaBFwSrtBL6uGeEFN+zdjueF9VQ4fR8Sf8SgHZchqTAMoa+wPz/YFDV42S7s1g1/6
         iAOutV89QT59vC4PaD/f/2LUbv33BkEWKecettfkHNBHO3dfopFomT5evmRrxOu4UmUY
         5/meESz4XJecHYWv9yEjy/dGpjlg0/wAZfTKrvYWD19DSglKkt2jXKRjurdRwHIaIRAR
         EqzR0/FGLK8SZ9zuDq5urniTXtpWiDzbeWR70FxUxzadnJ8gCET/niqD25Jkg0+ksBYu
         9KCA==
X-Gm-Message-State: APjAAAW0IAjAWRJCJ/evDfmo4l3/yJnGqgXYDs1KMHD2dMDOHMzsqO2C
        BeTtO0dtlm5ay601XIwslX16Xg==
X-Google-Smtp-Source: APXvYqx80xepcfirbyBDnpnxq8/YGv3RwNzcvHown+88cfYl4xKqMD35oihs3np2nEYxwtWyvGeLGg==
X-Received: by 2002:a2e:3016:: with SMTP id w22mr1605919ljw.117.1571299741096;
        Thu, 17 Oct 2019 01:09:01 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id t24sm657920ljc.23.2019.10.17.01.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 01:09:00 -0700 (PDT)
References: <20191016060051.2024182-1-andriin@fb.com> <CAADnVQJKESit7tDy0atn0-Q7Se=kLhkCWGAmRPJSVPdNAS8BVg@mail.gmail.com> <CAEf4BzZaSznrp0xLZ6Skpt3yuompUJU6XV863zSOPQfq4VL-UA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 0/7] Fix, clean up, and revamp selftests/bpf Makefile
In-reply-to: <CAEf4BzZaSznrp0xLZ6Skpt3yuompUJU6XV863zSOPQfq4VL-UA@mail.gmail.com>
Date:   Thu, 17 Oct 2019 10:08:59 +0200
Message-ID: <877e53oktg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 08:52 AM CEST, Andrii Nakryiko wrote:
> On Wed, Oct 16, 2019 at 9:28 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Oct 16, 2019 at 4:49 AM Andrii Nakryiko <andriin@fb.com> wrote:
>> >
>> > This patch set extensively revamps selftests/bpf's Makefile to generalize test
>> > runner concept and apply it uniformly to test_maps and test_progs test
>> > runners, along with test_progs' few build "flavors", exercising various ways
>> > to build BPF programs.
>> >
>> > As we do that, we fix dependencies between various phases of test runners, and
>> > simplify some one-off rules and dependencies currently present in Makefile.
>> > test_progs' flavors are now built into root $(OUTPUT) directory and can be run
>> > without any extra steps right from there. E.g., test_progs-alu32 is built and
>> > is supposed to be run from $(OUTPUT). It will cd into alu32/ subdirectory to
>> > load correct set of BPF object files (which are different from the ones built
>> > for test_progs).
>> >
>> > Outline:
>> > - patch #1 teaches test_progs about flavor sub-directories;
>> > - patch #2 fixes one of CO-RE tests to not depend strictly on process name;
>> > - patch #3 changes test_maps's usage of map_tests/tests.h to be the same as
>> >   test_progs' one;
>> > - patch #4 adds convenient short `make test_progs`-like targets to build only
>> >   individual tests, if necessary;
>> > - patch #5 is a main patch in the series; it uses a bunch of make magic
>> >   (mainly $(call) and $(eval)) to define test runner "skeleton" and apply it
>> >   to 4 different test runners, lots more details in corresponding commit
>> >   description;
>> > - patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
>> >   BPF programs;
>> > - patch #7 cleans up test_libbpf.sh/test_libbpf_open superseded by test_progs.
>> >
>> > v3->v4:
>> > - remove accidentally checked in binaries;
>>
>> something really odd here.
>> Before the patchset ./test_progs -n 27 passes
>> after the patch it simply hangs.
>> Though strace -f ./test_progs -n 27 passes.
>> Any idea?
>
> Interesting. For me test_progs -n27 passes by itself, whether with or
> without Makefile changes. But when run together with #8
> flow_dissector_reattach, it fails with
> "(prog_tests/sockopt_inherit.c:28: errno: Network is unreachable) Fail
> to connect to server", even without Makefile changes. It doesn't hang,
> but the test has server and client threads being coordinated, so I
> wouldn't be surprised that under some specific timing and error
> conditions it can hang.
>
> I bisected this failure to f97eea1756f3 ("selftests/bpf: Check that
> flow dissector can be re-attached"), that's when
> flow_dissector_reattach test was added. So apparently there is some
> bad interaction there.
>
> So I suspect my Makefile changes have nothing to do with this, it
> would be really bizarre...
>
> Jakub, do you mind checking as well?

This is my fault. flow_dissector_reattach test is not returning to the
netns we started in. Sorry about the oversight. Let me post a fix.

-Jakub
