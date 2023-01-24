Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3F679F91
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjAXREg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAXREW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:04:22 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673373EFF0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:03:51 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id q15so13663337qtn.0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A5GPqdeH1J2uKVzmWyPaPpEVlYHdcOYe3sISuNKHkhg=;
        b=mx7OxO1k8T1n99AxnDidx1MuMOPN7raGinFKH0gmaFqC1PlLywkqhtB5NgGrzCALaq
         GeIjBJZZbHU1t3iyAwcAW5QyRoTJ7zNMo1C9p+opoTN3emce2v/GQYDQHYhxCuCLWFDL
         YQBk8fpzq2brdVeGir9ZIXNIIQWaKLjhsTjhxaZH834J5YG8UWSOcGjqGArtiTj48uql
         QDYaW9/7gjjxuEBsh/G1jX8Tu4U8BYOrfBtfEpHWM2dth30W49nVFPQJyPkeIZ8Wtq7E
         oEZqJpyXkkb/nLmiF0i1My4J6lj2Gfej+wUg9Mz5xNZDAiH8UohGpc5fj0A7XO/qPl25
         Bvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5GPqdeH1J2uKVzmWyPaPpEVlYHdcOYe3sISuNKHkhg=;
        b=W+MDph4gd6c1kuDwLxBwtFPrygCkg/SNR7LwuvWqCFN832inHSxOdxKH9ZmUzcoNRR
         DFzcLWFzauRDyeKIRYOTwZUUzoPMsxYVCRjE/fsI8Zas+qQOa541SIXhOZC+DfGOE4Jc
         Q/tdukoOCuyyxRZ+sWp6ad9AHUQNtA5JdXs+pwOhuyRaPxeNkYIY+tBnebFmW3L+2ska
         Sp+ordFSGm3ENf8tQoAXjCgGxJjnQkA1oTtjdJ0a+e0HNkpwdCXhW1M20Lrl5CZKLuU/
         0qu9YyNZtyttiDBOgl7qL6vp4j6P6XdNd1fktukarRbhO3Q7/rRba9nzqYY2GPGLpNBL
         jY3w==
X-Gm-Message-State: AFqh2kohprnOKBwXPC+o0FYK/EFW+bH61UHlljBtMgX+xzDlfNlRXxOc
        MgqFhx9IG7+KDDe1b/oMXjkX8SZtVBge7FvX81g=
X-Google-Smtp-Source: AMrXdXuBzTTLI//OfeaO8K8k1r9lmGO9Pce8n0D7mEbvb6dXpgTntw0W3abOXa3TUO7WukkqXV918g==
X-Received: by 2002:a05:622a:1b1e:b0:3ab:a047:58ee with SMTP id bb30-20020a05622a1b1e00b003aba04758eemr38994279qtb.25.1674579828714;
        Tue, 24 Jan 2023 09:03:48 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id r2-20020ac83b42000000b003b6464eda40sm1578046qtf.25.2023.01.24.09.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:03:48 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Subject: [PATCH net-next RFC 00/20] Introducing P4TC
Date:   Tue, 24 Jan 2023 12:03:46 -0500
Message-Id: <20230124170346.316866-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are seeking community feedback on P4TC patches.
Apologies, I know this is a large number of patches but it is the best we could
do so as not to miss the essence of the work. We have a few more patches but
took them out for brevity of review.

P4TC is an implementation of the Programming Protocol-independent Packet
Processors (P4) that is kernel based, building on top of many years of Linux TC
experiences:

 * P4TC is scriptable - building on and extending the implementation/deployment
   concepts of the TC u32 classifier, pedit action, etc.
 * P4TC is designed to allow hardware offload based on experiences derived from
   TC classifiers flower, u32, matchall, etc.

By "scriptable" we mean: these patches enable kernel and user space code change
independency for any P4 program that describes a new datapath. The workflow is
as follows:
  1) A developer writes a P4 program, "myprog"
  2) Compiles it using the P4C compiler. The compiler generates output in the
     form of shell scripts which form template definitions for the different P4
     objects "myprog" utilizes (objects described below in the patch list).
  3) The developer (or operator) executes the shell scripts to manifest
     the functional equivalent of "myprog" into the kernel.
  4) The developer (or operator) instantiates "myprog" via the tc P4 filter
     to ingress/egress of one or more netdevs/ports. Example:
       "tc filter add block 22 ingress protocol ip prio 6 p4 pname myprog"

Once "myprog" is instantiated one can start updating table entries that are
associated with "myprog". Example:
  tc p4runtime create myprog/mytable dstAddr 10.0.1.2/32 prio 10 \
    action send param port type dev port1

Of course one can be more explicit and specify "skip_sw" or "skip_hw" to either
offload the entry (if a NIC or switch driver is capable) or make it purely run
entirely in the kernel or in a cooperative mode between kernel and user space.

Note: You do not need a compiler to create the template scripts used in
step #3. You can hand code them - however, there will be cases where you have
complex programs that would require the compiler.
Note2: There are no binary blobs being loaded into the kernel, rather a bunch
of "policies" to activate mechanisms in the kernel.

There have been many discussions and meetings since about 2015 in regards to
P4 over TC and now that the market has chosen P4 as the datapath specification
lingua franca we are finally proving the naysayers that we do get stuff done!

P4TC is designed to have very little impact on the core code for other users
of TC. We make one change to the core - to be specific we change the
implementation of action lists to use IDR instead of a linked list (see patch
#1); however, that change can be considered to be a control plane performance
improvement since IDR is faster in most cases.
The rest of the core changes(patches 2-9) are to enable P4TC and are minimalist
in nature. IOW, P4TC is self-contained and reuses the tc infrastructure without
affecting other consumers of the TC infra.

The core P4TC code implements several P4 objects.

1) Patch #10 implements the parser, kparser, which is based on Panda to allow
   for a scriptable approach for describing the equivalence to a P4 parser.
2) Patch #11 introduces P4 data types which are consumed by the rest of the code
3) Patch #12 introduces the concept of templating Pipelines. i.e CRUD commands
   for P4 pipelines.
4) Patch #13 introduces the concept of P4 user metadata and associated CRUD
   template commands.
5) Patch #14 introduces the concept of P4 header fields and associated CRUD
   template commands. Note header fields tie into the parser from patch #10.
6) Patch #15 introduces the concept of action templates and associated
   CRUD commands.
7) Patch #16 introduces the concept of P4 table templates and associated
   CRUD commands for tables
8) Patch #17 introduces the concept of table _runtime control_ and associated
   CRUD commands.
9) Patch #18 introduces the concept of P4 register templates and associated
   CRUD commands for registers.
9) Patch #19 introduces the concept of dynamic actions commands that are
    used by actions (see patch #15).
11) Patch #20 introduces the TC P4 classifier used at runtime.

Speaking of testing - we have about 400 tdc test cases (which are left out
from this patch series). This number is growing.
These tests are run on our CICD system after commits are approved. The CICD does
a lot of other tests including:
checkpatch, sparse, 32 bit and 64 bit builds tested on both X86, ARM 64
and emulated BE via qemu s390. We trigger performance testing in the CICD
to catch performance regressions (currently only on the control path, but in
the future for the datapath).
Syzkaller runs 24/7 on dedicated hardware, and before main releases we put
the code via coverity. All of this has helped find bugs and ensure stability.
In addition we are working on a tool that will take a p4 program, run it through
the compiler, and generate permutations of traffic patterns that will test both
positive and negative code paths. The test generator tool is still work in
progress and will be generated by the P4 compiler.

There's a lot more info for the curious that we are leaving out for the sake
of brevity. A good starting point is to checkout recent material on the subject.
There is a presentation on P4TC as well as a workshop that took place in
Netdevconf 0x16), see:
https://netdevconf.info/0x16/session.html?Your-Network-Datapath-Will-Be-P4-Scripted
https://netdevconf.info/0x16/session.html?P4TC-Workshop

Jamal Hadi Salim (26):
  net/sched: act_api: change act_base into an IDR
  net/sched: act_api: increase action kind string length
  net/sched: act_api: increase TCA_ID_MAX
  net/sched: act_api: add init_ops to struct tc_action_op
  net/sched: act_api: introduce tc_lookup_action_byid()
  net/sched: act_api: export generic tc action searcher
  net/sched: act_api: create and export __tcf_register_action
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
  selftests: tc-testing: add P4TC pipeline control path tdc tests
  selftests: tc-testing: add P4TC metadata control path tdc tests
  selftests: tc-testing: add P4TC action templates tdc tests
  selftests: tc-testing: add P4TC table control path tdc tests
  selftests: tc-testing: add P4TC table entries control path tdc tests
  selftests: tc-testing: add P4TC register tdc tests
  MAINTAINERS: add p4tc entry

Pratyush Khan (2):
  net/kparser: add kParser
  net/kparser: add kParser documentation

 Documentation/networking/kParser.rst          |   327 +
 .../networking/parse_graph_example.svg        |  2039 +++
 MAINTAINERS                                   |    14 +
 include/linux/rtnetlink.h                     |    12 +
 include/linux/skbuff.h                        |    17 +
 include/net/act_api.h                         |    17 +-
 include/net/kparser.h                         |   110 +
 include/net/p4tc.h                            |   665 +
 include/net/p4tc_types.h                      |    61 +
 include/net/sch_generic.h                     |     5 +
 include/net/tc_act/p4tc.h                     |    25 +
 include/uapi/linux/kparser.h                  |   674 +
 include/uapi/linux/p4tc.h                     |   510 +
 include/uapi/linux/pkt_cls.h                  |    17 +-
 include/uapi/linux/rtnetlink.h                |    14 +
 net/Kconfig                                   |     9 +
 net/Makefile                                  |     1 +
 net/core/skbuff.c                             |    17 +
 net/kparser/Makefile                          |    17 +
 net/kparser/kparser.h                         |   418 +
 net/kparser/kparser_cmds.c                    |   917 ++
 net/kparser/kparser_cmds_dump_ops.c           |   586 +
 net/kparser/kparser_cmds_ops.c                |  3778 +++++
 net/kparser/kparser_condexpr.h                |    52 +
 net/kparser/kparser_datapath.c                |  1266 ++
 net/kparser/kparser_main.c                    |   329 +
 net/kparser/kparser_metaextract.h             |   891 ++
 net/kparser/kparser_types.h                   |   586 +
 net/sched/Kconfig                             |    20 +
 net/sched/Makefile                            |     3 +
 net/sched/act_api.c                           |   156 +-
 net/sched/cls_p4.c                            |   339 +
 net/sched/p4tc/Makefile                       |     7 +
 net/sched/p4tc/p4tc_action.c                  |  1907 +++
 net/sched/p4tc/p4tc_cmds.c                    |  3492 +++++
 net/sched/p4tc/p4tc_hdrfield.c                |   625 +
 net/sched/p4tc/p4tc_meta.c                    |   884 ++
 net/sched/p4tc/p4tc_parser_api.c              |   229 +
 net/sched/p4tc/p4tc_pipeline.c                |   996 ++
 net/sched/p4tc/p4tc_register.c                |   749 +
 net/sched/p4tc/p4tc_table.c                   |  1636 ++
 net/sched/p4tc/p4tc_tbl_api.c                 |  1895 +++
 net/sched/p4tc/p4tc_tmpl_api.c                |   609 +
 net/sched/p4tc/p4tc_types.c                   |  1294 ++
 net/sched/p4tc/trace.c                        |    10 +
 net/sched/p4tc/trace.h                        |    45 +
 security/selinux/nlmsgtab.c                   |     8 +-
 .../tc-tests/p4tc/action_templates.json       | 12378 ++++++++++++++++
 .../tc-testing/tc-tests/p4tc/metadata.json    |  2652 ++++
 .../tc-testing/tc-tests/p4tc/pipeline.json    |  3212 ++++
 .../tc-testing/tc-tests/p4tc/register.json    |  2752 ++++
 .../tc-testing/tc-tests/p4tc/table.json       |  8956 +++++++++++
 .../tc-tests/p4tc/table_entries.json          |  3818 +++++
 53 files changed, 62001 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/networking/kParser.rst
 create mode 100644 Documentation/networking/parse_graph_example.svg
 create mode 100644 include/net/kparser.h
 create mode 100644 include/net/p4tc.h
 create mode 100644 include/net/p4tc_types.h
 create mode 100644 include/net/tc_act/p4tc.h
 create mode 100644 include/uapi/linux/kparser.h
 create mode 100644 include/uapi/linux/p4tc.h
 create mode 100644 net/kparser/Makefile
 create mode 100644 net/kparser/kparser.h
 create mode 100644 net/kparser/kparser_cmds.c
 create mode 100644 net/kparser/kparser_cmds_dump_ops.c
 create mode 100644 net/kparser/kparser_cmds_ops.c
 create mode 100644 net/kparser/kparser_condexpr.h
 create mode 100644 net/kparser/kparser_datapath.c
 create mode 100644 net/kparser/kparser_main.c
 create mode 100644 net/kparser/kparser_metaextract.h
 create mode 100644 net/kparser/kparser_types.h
 create mode 100644 net/sched/cls_p4.c
 create mode 100644 net/sched/p4tc/Makefile
 create mode 100644 net/sched/p4tc/p4tc_action.c
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
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/action_templates.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/pipeline.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/table.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json

-- 
2.34.1


Jamal Hadi Salim (19):
  net/sched: act_api: change act_base into an IDR
  net/sched: act_api: increase action kind string length
  net/sched: act_api: increase TCA_ID_MAX
  net/sched: act_api: add init_ops to struct tc_action_op
  net/sched: act_api: introduce tc_lookup_action_byid()
  net/sched: act_api: export generic tc action searcher
  net/sched: act_api: create and export __tcf_register_action
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

Pratyush Khan (1):
  net/kparser: add kParser

 include/linux/rtnetlink.h           |   12 +
 include/linux/skbuff.h              |   17 +
 include/net/act_api.h               |   17 +-
 include/net/kparser.h               |  110 +
 include/net/p4tc.h                  |  665 +++++
 include/net/p4tc_types.h            |   61 +
 include/net/sch_generic.h           |    5 +
 include/net/tc_act/p4tc.h           |   25 +
 include/uapi/linux/kparser.h        |  674 +++++
 include/uapi/linux/p4tc.h           |  510 ++++
 include/uapi/linux/pkt_cls.h        |   17 +-
 include/uapi/linux/rtnetlink.h      |   14 +
 net/Kconfig                         |    9 +
 net/Makefile                        |    1 +
 net/core/skbuff.c                   |   17 +
 net/kparser/Makefile                |   17 +
 net/kparser/kparser.h               |  418 +++
 net/kparser/kparser_cmds.c          |  917 +++++++
 net/kparser/kparser_cmds_dump_ops.c |  586 +++++
 net/kparser/kparser_cmds_ops.c      | 3778 +++++++++++++++++++++++++++
 net/kparser/kparser_condexpr.h      |   52 +
 net/kparser/kparser_datapath.c      | 1266 +++++++++
 net/kparser/kparser_main.c          |  329 +++
 net/kparser/kparser_metaextract.h   |  891 +++++++
 net/kparser/kparser_types.h         |  586 +++++
 net/sched/Kconfig                   |   20 +
 net/sched/Makefile                  |    3 +
 net/sched/act_api.c                 |  156 +-
 net/sched/cls_p4.c                  |  339 +++
 net/sched/p4tc/Makefile             |    7 +
 net/sched/p4tc/p4tc_action.c        | 1907 ++++++++++++++
 net/sched/p4tc/p4tc_cmds.c          | 3492 +++++++++++++++++++++++++
 net/sched/p4tc/p4tc_hdrfield.c      |  625 +++++
 net/sched/p4tc/p4tc_meta.c          |  884 +++++++
 net/sched/p4tc/p4tc_parser_api.c    |  229 ++
 net/sched/p4tc/p4tc_pipeline.c      | 1024 ++++++++
 net/sched/p4tc/p4tc_register.c      |  749 ++++++
 net/sched/p4tc/p4tc_table.c         | 1636 ++++++++++++
 net/sched/p4tc/p4tc_tbl_api.c       | 1898 ++++++++++++++
 net/sched/p4tc/p4tc_tmpl_api.c      |  609 +++++
 net/sched/p4tc/p4tc_types.c         | 1294 +++++++++
 net/sched/p4tc/trace.c              |   10 +
 net/sched/p4tc/trace.h              |   45 +
 security/selinux/nlmsgtab.c         |    8 +-
 44 files changed, 25884 insertions(+), 45 deletions(-)
 create mode 100644 include/net/kparser.h
 create mode 100644 include/net/p4tc.h
 create mode 100644 include/net/p4tc_types.h
 create mode 100644 include/net/tc_act/p4tc.h
 create mode 100644 include/uapi/linux/kparser.h
 create mode 100644 include/uapi/linux/p4tc.h
 create mode 100644 net/kparser/Makefile
 create mode 100644 net/kparser/kparser.h
 create mode 100644 net/kparser/kparser_cmds.c
 create mode 100644 net/kparser/kparser_cmds_dump_ops.c
 create mode 100644 net/kparser/kparser_cmds_ops.c
 create mode 100644 net/kparser/kparser_condexpr.h
 create mode 100644 net/kparser/kparser_datapath.c
 create mode 100644 net/kparser/kparser_main.c
 create mode 100644 net/kparser/kparser_metaextract.h
 create mode 100644 net/kparser/kparser_types.h
 create mode 100644 net/sched/cls_p4.c
 create mode 100644 net/sched/p4tc/Makefile
 create mode 100644 net/sched/p4tc/p4tc_action.c
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

-- 
2.34.1

