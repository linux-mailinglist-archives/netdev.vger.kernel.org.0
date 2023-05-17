Return-Path: <netdev+bounces-3283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0314F7065FD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84BE4280EEA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F801168D6;
	Wed, 17 May 2023 11:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6B8AD37
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:03:49 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B822F3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:09 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-ba86ec8047bso446503276.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321348; x=1686913348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eujltd9jBxpzonTn/DXjzMPKvKSVhA7Z2bknlCXp5wQ=;
        b=o6n7r4cBh+fruvIqvymEYNWwfDVtaGlUTwwNXiTkp6B8jg+jQwJHdVfxC2Si/rJvEx
         BA0MZ/dWSC1DdDzqostNJ70NDMGsWFDJPLjwQH9kdnXQerbd1rcMBWCv894aFLN9q4Ej
         dMYo4J99QUfCzQOLSfFICA491/ZiZopixO+z+7BDM74E4roRONFi96KuSA2I1/PDXQb+
         jx1ZwBUSGFm14kM+ic73uxbsT1Z2AnqFETizVkgrHAzqkDq9ZG7D3aTr3y0Fo3mvo+Km
         5miPYYPaks5+AL4qt5STKkpUNOy5xcrevftLzffz0MumJnhJeZAj1siwBW4H3n0ZMQp9
         wpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321348; x=1686913348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eujltd9jBxpzonTn/DXjzMPKvKSVhA7Z2bknlCXp5wQ=;
        b=VIPMkpR+Bt5Ny3PugH9j+WrFP5oHwNMH5/jnORTIMScTG53OuiqHDPRnX/Vj3eRFSh
         ld7Cf0VYp92Qn6yozNwq/Wan5bkWgge3xL8SrWor6NmjT0tonhIaG15Je/pQmQyTdtaZ
         MRecz8Cancck4rwbXYeaDy/ap39DsI/CESs7/h8gsW62oXuHz6kT/pQ0zEalULdHezo6
         wCQwmFVjHZqnwRYK82bFq1Vr3Tos1eflYDebo8WnFSi4NLzFFhssj1ZOlwsXygwYWR1q
         OM8tF0vnhCzQA0ZSy9CfSyh3C9Fy+5mLrgi1OGIGFd0IeDL4cxaMYmw1ULpO24dSd+48
         XLvQ==
X-Gm-Message-State: AC+VfDxiHGNFkDdEo3jjqigCETAC34xJmvDg6WRERvSjKQzfo36pja+5
	AHkzbP4hZ8C+zqcIuAub6QaWmCB8yWKnqrr0pyw=
X-Google-Smtp-Source: ACHHUZ6d9nYRWfp9lReorWwdBZ9IdSdCaTGcninlpKytivZyGMVJIaXS9HxXLiRLbPkJP/k+2lU8cg==
X-Received: by 2002:a25:c443:0:b0:b9a:7b56:bcb4 with SMTP id u64-20020a25c443000000b00b9a7b56bcb4mr33524034ybf.42.1684321347954;
        Wed, 17 May 2023 04:02:27 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a16ab00b0074df5d787f2sm520846qkj.89.2023.05.17.04.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:27 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	mattyk@nvidia.com,
	dan.daly@intel.com,
	john.andy.fingerhut@intel.com
Subject: [PATCH RFC net-next 00/28 v2] Introducing P4TC
Date: Wed, 17 May 2023 07:02:25 -0400
Message-Id: <20230517110225.29327-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We are seeking community feedback on P4TC patches.

Apologies, I know this is a large number of patches but it is the best we could
do so as not to miss the essence of the work.
Please do note that > 50% of LOC are testcases. I should have emphasized
this last time to improve the quality of the discussions, but mea culpa.

So what has changed with version 2? We did take into consideration the
suggestions provided and added eBPF S/W datapath support. We implemented 6
approaches with eBPF (3 actually - but if you consider that we used TC and XDP
separately then it counts as 6). We ran performance analysis and presented
our results at the P4 2023 workshop in Santa Clara[see: 1, 3] on each of
the 6 vs scriptable P4TC and concluded that 2 of the approaches are sensible
(4 if you account for XDP or TC separately). The patches in this series
introduce those two modes.

mode1: the parser is entirely based on ebpf - whereas the rest of the
SW datapath stays as scriptable.
mode2: All of the kernel s/w datapath (including parser) is in eBPF.

The key ingredient for eBPF, that we did not have access to in the past, is
kfunc (it made a big difference in our decision to integrate eBPF).

At the moment the two modes are mutually exclusive (IOW, you get to choose one
or the other via Kconfig).

For more discussion on our requirements vs journeying the ebpf path please
scroll down to "Restating Our Requirements" and "Challenges".

__What is P4TC?__

P4TC is an implementation of the Programming Protocol-independent Packet
Processors (P4) that is kernel based, building on top of many years of Linux TC
experiences. On why P4 - see small treatise here:[4].

There have been many discussions and meetings since about 2015 in regards to
P4 over TC [2] and we are finally proving the naysayers that we do get stuff
done!

A lot more of the P4TC motivation is captured at (to be updated):
https://github.com/p4tc-dev/docs/blob/main/why-p4tc.md

__P4TC Workflow__

These patches enable kernel and user space code change _independency_ for any
new P4 program that describes a new datapath. The workflow is as follows:

  1) A developer writes a P4 program, "myprog"

  2) Compiles it using the P4C compiler. The compiler generates 3 outputs:
     a) shell script(s) which form template definitions for the different P4
     objects "myprog" utilizes (tables, registers, actions etc).
     b) i) in mode1 the parser is generated in ebpf and needs to be compiled
           into a binary.
       ii) in mode2 the parser and the rest of the sw datapath are generated
           in ebpf and need to be compiled into binaries.
     c) A json introspection file used for control plane (by iproute2).

  3) The developer (or operator) executes the shell script(s) and loads
     the ebpf program(binaries) into the kernel to manifest the functional
     s/w equivalent of "myprog" into the kernel.

  4) The developer (or operator) instantiates "myprog" via the tc P4 filter
     to ingress/egress (depending on P4 arch) of one or more netdevs/ports.
     Example mode1:
       "tc filter add block 22 ingress prio 6 p4 pname myprog \
        prog tc obj $PARSER.o section parser/tc-ingress"
     mode2 (parser is an action):
       "tc filter add block 22 ingress protocol any prio 1 p4 pname myprog \
        action bpf obj $PARSER.o section parser/tc-ingress \
        action bpf obj $PROGNAME.o section p4prog/tc"
     mode2 (parser explicitly bound and rest of sw dpath as an action):
       "tc filter add block 22 ingress protocol any prio 1 p4 pname myprog \
        prog tc obj $PARSER.o section parser/tc-ingress \
        action bpf obj $PROGNAME.o section p4prog/tc"
     mode2 (parser is at XDP, rest of sw dpath as an action):
       "tc filter add block 22 ingress protocol any prio 1 p4 pname myprog \
        prog xdp obj $PARSER.o section parser/xdp-ingress \
        action bpf obj $PROGNAME.o section p4prog/tc"
     mode2 (parser+prog at XDP):
       "tc filter add block 22 ingress protocol any prio 1 p4 pname myprog \
        prog xdp obj $PROGNAME.o section p4prog/xdp"

    see individual patches for more examples tc vs xdp etc. Also see section on
    "challenges".

Once "myprog" is instantiated one can start updating table entries that are
associated with "myprog". Example:
  tc p4runtime create myprog/mytable dstAddr 10.0.1.2/32 \
    action send_to_port param port eno1

Of course one can be more explicit and specify "skip_sw" or "skip_hw" to either
offload the entry (if a NIC or switch driver is capable) or make it available
entirely for the kernel sw dpath or in a cooperative mode between kernel and
hardware.

In this patch series we focus on s/w datapath only.

In mode 1: The packet arriving on any of the ports on block 22 will first be
exercised via the (ebpf) parser to find the offsets for the ip destination
address. This information is then fed to the scriptable engine as metainfo.
The scriptable datapath uses the dstip as a key to lookup myprog's mytable and
if it matches 10.0.1.2/32 it will be sent out eno1. On a miss mytable's default
miss action is executed.

In mode 2: The packet arriving on any of the ports on block 22 will first be
exercised via the (ebpf) parser to find the offsets for the ip destination
address.
The remainder ebpf datapath uses the result dstip as a key to (kfunc) lookup
myprog's mytable which returns the action params which are then used to execute
the action in the ebpf datapath (eventually sending out packets to eno1).
On a miss mytable's default miss action is executed.

__Description of Patches__

P4TC is designed to have no impact on the core code for other users
of TC. IOW, you can compile it out or as a module and if you dont use
it then there should be no impact on your performance.

We do make core kernel changes. Patch #1 introduces new "dynamic" actions
that can be created on "the fly" based on the P4 program requirement.
This patch makes a small incision into act_api which shouldnt affect the
performance of the existing actions. Patches 2-8 are minimalist enablers for
P4TC and have no effect the classical tc action.

The core P4TC code implements several P4 objects.

1) Patch #9 introduces P4 data types which are consumed by the rest of the code
2) Patch #10 introduces the concept of templating Pipelines. i.e CRUD commands
   for P4 pipelines.
3) Patch #11 introduces the concept of P4 user metadata and associated CRUD
   template commands.
4) Patch #12 introduces the concept of P4 header fields and associated CRUD
   template commands.
5) Patch #13 introduces the concept of action templates and associated
   CRUD commands.
6) Patch #14 introduces the concept of P4 table templates and associated
   CRUD commands for tables
7) Patch #15 introduces the concept of table _runtime control_ and associated
   CRUD commands.
8) Patch #16 introduces the concept of P4 register templates and associated
   CRUD commands for registers.
9) Patch #17 introduces the concept of dynamic actions commands that are
    used by actions (see patch #13).
10) Patch #18 introduces the TC classifier P4 used at runtime. Only with
    mode1 support.
11) Patches #19-26 are control tests for the different objects
12) Patch #27 introduces mode2 and associated kfunc (currently only for table
    objects, but more available that we left out for brevity).

__Testing__

Speaking of testing - we have about 400 tdc test cases. This number is growing.
These tests are run on our CICD system on pull requests and after commits are
approved. The CICD does a lot of other tests including:
checkpatch, sparse, 32 bit and 64 bit builds tested on both X86, ARM 64
and emulated BE via qemu s390. We trigger performance testing in the CICD
to catch performance regressions (currently only on the control path, but in
the future for the datapath).
Syzkaller runs 24/7 on dedicated hardware, originally we focussed only on memory
sanitizer but recently added support for concurency sanitizer. Before main
releases we put the code via coverity. All of this has helped find bugs and
ensure stability before new releases.
In addition we are working on a tool that will take a p4 program, run it through
the compiler, and generate permutations of traffic patterns via symbolic
execution that will test both positive and negative datapath code paths. The
test generator tool is still work in progress and will be generated by the P4
compiler.
Note: We have other code that test parallelization etc which we are trying to
find a fit for in the kernel tree.

__Restating Our Requirements__

Our original intent was to target the TC crowd for both s/w and h/w offload.
Essentially developers and ops people deploying TC based infra.
More importantly the original intent for P4TC was to enable the ops folks.

With TC we get whole "familiar" package of match-action pipeline abstraction ++:
from the control plane to the tooling infra, netlink messaging to s/w and h/w
symbiosis, the autonomous kernel control, etc. The advantage is that we have a
singular vendor-neutral interface via the kernel using well understood
mechanisms based on deployment experience.

1) Supporting expressibility of universe set of P4 progs

It is a must to support 100% of all possible P4 programs. In the past the eBPF
verifier had to be worked around and even then there are cases where we couldnt
avoid path explosion when branching is involved. Kfunc-ing solves these issues
for us. Note, there are still challenges running all potential P4 programs at
the XDP level - the solution to that is to have the compiler generate XDP based
code only if it possible to map it to that layer.

2) Support for P4 HW and SW equivalence.

This feature continues to work even in the presence of eBPF as the s/w
datapath. There are cases of square-hole-round-peg scenarios but
those are implementation issues we can live with.

3) Operational usability

By maintaining the TC control plane (even in presence of eBPF s/w datapath)
runtime aspects remain unchanged. So for our target audience of folks
who have deployed tc including offloads - the comfort zone is unchanged.

There is some loss in operational usability because we now have more knobs:
the extra compilation, loading and syncing of binaries, etc.
IOW, I can no longer just ship someone a shell script in an email to
say go run this and "myprog" will just work.

4) Operational and development Debuggability

If something goes wrong, the tc craftsperson is now required to have additional
knowledge of eBPF code and process. This applies to both the operational person
as well as someone who wrote a driver. We dont believe this is solvable.

5) Opportunity for rapid protoyping of new ideas

During the P4TC development phase something that came naturally was to often
handcode the template scripts because the compiler backend (which is P4 arch
specific) wasnt ready to generate certain things. Then you would read back the
template and diff to ensure the kernel didnt get something wrong. So this
started as a debug feature. During development, we wrote scripts that
covered a range of P4 architectures which required no kernel code changes.

In its basic form it boils down to the old adage of a niche DSL script vs a
compiled general purpose language such as eBPF. Given our target audience who
know P4/TC, and understand our hooks, the shell script whose command set is more
aligned to P4 is a natural fit compared to handcoding eBPF.

Over time the debug feature morphed into: start by handcoding scripts then
read it back and generate the P4 code.
It means one could start with the template scripts outside of the constraints
of a P4 architecture spec(PNA/PSA) or even within a P4 architecture then test
some ideas and eventually feed back the concepts to the compiler authors or
modify or create a new P4 architecure and share with the P4 standards folks.

To summarize in presence of eBPF: The debugging idea is still alive.
One could dump with proper tooling(bpftool for example) the loaded eBPF code
and be able to check for differences.
The concept of going back from whats in the kernel to P4 is a lot more difficult
to implement mostly due to scoping of DSL vs general purpose. It may be lost.
We have been thinking of ways to use BTF and embedding annotations in the eBPF
code and binary but more thought is required and we welcome suggestions.

6) Performance

It is clear you gain better performance for the sw datapath with eBPF. Refer to
our results for the tests we did[1].
Note: for computationaly complex programs this value diminishes i.e the
gap between XDP and TC eBPF or even in some cases scriptable approach is not
prominent; however, we do acknowledge there is an observable performance gain
as expected (compiled vs interpreted approach).

__Challenges__

1) When we have either the parser or part/whole of s/w datapath running in XDP
   then we need to make sure that the instantiation at the TC level is aware.
   For this we reason we need a mechanism for ensuring that the XDP program
   stays alive. Unfortunately we dont have a clean way of doing this at the
   moment i.e the program could be removed under us. It would be useful to have
   a refcount mechanism where the program cant be unbound from a port/netdev.

2) Concept of tc block in XDP is tedious to implement.

3) Right now we are using "packed" construct to enforce alignment in kfunc data
   exchange; but we're wondering if there is potential to use BTF to understand
   parameters and their offsets and encode this information at the compiler
   level.

4) At the moment we are creating a static buffer of 128B to retrieve the action
   parameters. If you have a lot of table entries and individual(non-shared)
   action instances with actions that require very little (or no) param space
   a lot of memory is wasted. If we can have dynamic pointers instead for
   kfunc fixed length parametrization then this issue is resolvable.

5) See "Restating Our Requirements" #5.
   We would really appreciate ideas/suggestions, etc.

__References__

[1]https://github.com/p4tc-dev/docs/blob/main/p4-conference-2023/2023P4WorkshopP4TC.pdf
[2]https://github.com/p4tc-dev/docs/blob/main/why-p4tc.md#historical-perspective-for-p4tc
[3]https://2023p4workshop.sched.com/event/1KsAe/p4tc-linux-kernel-p4-implementation-approaches-and-evaluation
[4]https://github.com/p4tc-dev/docs/blob/main/why-p4tc.md#so-why-p4-and-how-does-p4-help-here

Jamal Hadi Salim (28):
  net: sched: act_api: Add dynamic actions IDR
  net/sched: act_api: increase action kind string length
  net/sched: act_api: increase TCA_ID_MAX
  net/sched: act_api: add init_ops to struct tc_action_op
  net/sched: act_api: introduce tc_lookup_action_byid()
  net/sched: act_api: export generic tc action searcher
  net/sched: act_api: add struct p4tc_action_ops as a parameter to
    lookup callback
  net: introduce rcu_replace_pointer_rtnl
  p4tc: add P4 data types
  p4tc: add pipeline create, get, update, delete
  p4tc: add metadata create, update, delete, get, flush and dump
  p4tc: add header field create, get, delete, flush and dump
  p4tc: add action template create, update, delete, get, flush and dump
  p4tc: add table create, update, delete, get, flush and dump
  p4tc: add table entry create, update, get, delete, flush and dump
  p4tc: add register create, update, delete, get, flush and dump
  p4tc: add dynamic action commands
  p4tc: add P4 classifier
  selftests: tc-testing: add JSON introspection file directory for P4TC
  selftests: tc-testing: Don't assume ENVIR is declared in local config
  selftests: tc-testing: add P4TC pipeline control path tdc tests
  selftests: tc-testing: add P4TC metadata control path tdc tests
  selftests: tc-testing: add P4TC action templates tdc tests
  selftests: tc-testing: add P4TC table control path tdc tests
  selftests: tc-testing: add P4TC table entries control path tdc tests
  selftests: tc-testing: add P4TC register tdc tests
  p4tc: add set of P4TC table lookup kfuncs
  MAINTAINERS: add p4tc entry

 MAINTAINERS                                   |    14 +
 include/linux/bitops.h                        |     1 +
 include/linux/filter.h                        |     3 +
 include/linux/rtnetlink.h                     |    12 +
 include/net/act_api.h                         |    21 +-
 include/net/p4tc.h                            |   774 +
 include/net/p4tc_types.h                      |    87 +
 include/net/sch_generic.h                     |     5 +
 include/net/tc_act/p4tc.h                     |    32 +
 include/uapi/linux/p4tc.h                     |   526 +
 include/uapi/linux/pkt_cls.h                  |    22 +-
 include/uapi/linux/rtnetlink.h                |    14 +
 net/core/filter.c                             |    10 +
 net/sched/Kconfig                             |    27 +
 net/sched/Makefile                            |     3 +
 net/sched/act_api.c                           |   189 +-
 net/sched/cls_api.c                           |     2 +-
 net/sched/cls_p4.c                            |   514 +
 net/sched/p4tc/Makefile                       |    11 +
 net/sched/p4tc/p4tc_action.c                  |  2000 +++
 net/sched/p4tc/p4tc_bpf.c                     |   149 +
 net/sched/p4tc/p4tc_cmds.c                    |  3641 +++++
 net/sched/p4tc/p4tc_hdrfield.c                |   618 +
 net/sched/p4tc/p4tc_meta.c                    |   880 ++
 net/sched/p4tc/p4tc_parser_api.c              |   146 +
 net/sched/p4tc/p4tc_pipeline.c                |  1160 ++
 net/sched/p4tc/p4tc_register.c                |   746 +
 net/sched/p4tc/p4tc_table.c                   |  1865 +++
 net/sched/p4tc/p4tc_tbl_api.c                 |  2152 +++
 net/sched/p4tc/p4tc_tmpl_api.c                |   598 +
 net/sched/p4tc/p4tc_types.c                   |  1354 ++
 net/sched/p4tc/trace.c                        |    11 +
 net/sched/p4tc/trace.h                        |    45 +
 security/selinux/nlmsgtab.c                   |     8 +-
 .../introspection-examples/example_pipe.json  |    92 +
 .../tc-tests/p4tc/action_templates.json       | 12332 ++++++++++++++++
 .../tc-testing/tc-tests/p4tc/metadata.json    |  2652 ++++
 .../tc-testing/tc-tests/p4tc/pipeline.json    |  3212 ++++
 .../tc-testing/tc-tests/p4tc/register.json    |  2752 ++++
 .../tc-testing/tc-tests/p4tc/table.json       |  8896 +++++++++++
 .../tc-tests/p4tc/table_entries.json          |  4183 ++++++
 .../selftests/tc-testing/tdc_config.py        |     2 +
 42 files changed, 51732 insertions(+), 29 deletions(-)
 create mode 100644 include/net/p4tc.h
 create mode 100644 include/net/p4tc_types.h
 create mode 100644 include/net/tc_act/p4tc.h
 create mode 100644 include/uapi/linux/p4tc.h
 create mode 100644 net/sched/cls_p4.c
 create mode 100644 net/sched/p4tc/Makefile
 create mode 100644 net/sched/p4tc/p4tc_action.c
 create mode 100644 net/sched/p4tc/p4tc_bpf.c
 create mode 100644 net/sched/p4tc/p4tc_cmds.c
 create mode 100644 net/sched/p4tc/p4tc_hdrfield.c
 create mode 100644 net/sched/p4tc/p4tc_meta.c
 create mode 100644 net/sched/p4tc/p4tc_parser_api.c
 create mode 100644 net/sched/p4tc/p4tc_pipeline.c
 create mode 100644 net/sched/p4tc/p4tc_register.c
 create mode 100644 net/sched/p4tc/p4tc_table.c
 create mode 100644 net/sched/p4tc/p4tc_tbl_api.c
 create mode 100644 net/sched/p4tc/p4tc_tmpl_api.c
 create mode 100644 net/sched/p4tc/p4tc_types.c
 create mode 100644 net/sched/p4tc/trace.c
 create mode 100644 net/sched/p4tc/trace.h
 create mode 100644 tools/testing/selftests/tc-testing/introspection-examples/example_pipe.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/action_templates.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/pipeline.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/table.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json

-- 
2.34.1


