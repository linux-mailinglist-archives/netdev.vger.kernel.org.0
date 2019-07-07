Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63761525
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfGGOCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 10:02:16 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39740 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGGOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 10:02:16 -0400
Received: by mail-ed1-f67.google.com with SMTP id m10so12176556edv.6
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 07:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=uCTC2Cr0Rb4iqThZijng8/iwuG/CfuXmWRd1cfjQWso=;
        b=coWYkS8BOBBVfKECeEbwM0RFWVZdnNo1666igwBtcovU2dKxwTRLkijrXamtduvtuO
         f2/rpQecDg8XazwtYYVINrE6IMtGxrGLi6OEAFrgzcmnYu99cagMgzTLBZxdewpFY1r4
         yGG3AGDBy8V9a/dDuy0xXFbdTYUkwYlRwIdnoRqGhLOSWswktaoW/SoV7kkV1ZfXZE6N
         o/y67HI1QXRhKd05yniHjcSeLCzuU8PmZTdH+H7M2m9Oqeuxq91VG0MYIWPgX+FrPXJH
         4jLvsfD8IJPsYFQiaiRDiuG+emV1caNO9T/ofr+HWJSBYuJKdcmQ8JzSWYegxG5oVhZY
         KUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uCTC2Cr0Rb4iqThZijng8/iwuG/CfuXmWRd1cfjQWso=;
        b=nKdW/ammuE0hQhKk/JYOnnpfbkSvbfpNTDzO3MRZHkogxg38eqlvHvivJR5eQfHjFD
         JuqWNZ0n37B1S0pfRuanU6WFSufDfMfaFtsLBL0DbT2HmpKa8O0rH5HxNXqyA0P36IrV
         Y6QRv7vratfiUrflBJWi41lS9a0YXJrZCSWWGKyvm1M7qJxZgD5UoYYtfrIL7GxIeZzc
         G/gT0KgEbwL7dBIStQrSgOCvFZHbOqcKtfbeXjrPn2E8wLTuzSdCxPLWxmSByT3aaeJB
         WdvkaaYkb0lYhWFkvBsncx9faJKjpGcPgYi3it5jgu9/igVfp/68NsOXgo29rKmqAnmJ
         gDOQ==
X-Gm-Message-State: APjAAAX35mh2DEMIW/eMJMbL8Ovdw3/5CMn4FIcjlwTvb3PT37co4KXj
        OEfx7k0OYynzxoQJBlQSC4gcbEutDqM=
X-Google-Smtp-Source: APXvYqxlXqMWo+OMTiQoWkD9qe7inrTyYs9pCll46oyi5nzCWSO96yj7hzBY0kdLU+dQHQZYLnPMgg==
X-Received: by 2002:a50:9832:: with SMTP id g47mr14498843edb.282.1562508134248;
        Sun, 07 Jul 2019 07:02:14 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t2sm4673327eda.95.2019.07.07.07.02.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 07 Jul 2019 07:02:13 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v7 0/5] Add MPLS actions to TC
Date:   Sun,  7 Jul 2019 15:01:53 +0100
Message-Id: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces a new TC action module that allows the
manipulation of the MPLS headers of packets. The code impliments
functionality including push, pop, and modify.

Also included are tests for the new funtionality. Note that these will
require iproute2 changes to be submitted soon.

NOTE: these patches are applied to net-next along with the patch:
[PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
This patch has been accepted into net but, at time of posting, is not yet
in net-next.

v6-v7:
- add extra tests for setting max/min and exceeding range of fields -
  patch 5 (Roman Mashak)
v5-v6:
- add CONFIG_NET_ACT_MPLS to tc-testing config file - patch 5
  (Davide Caratti)
v4-v5:
- move mpls_hdr() call to after skb_ensure_writable - patch 3
  (Willem de Bruijn)
- move mpls_dec_ttl to helper - patch 4 (Willem de Bruijn)
- add iproute2 usage example to commit msg - patch 4 (David Ahern)
- align label validation with mpls core code - patch 4 (David Ahern)
- improve extack message for no proto in mpls pop - patch 4 (David Ahern)
v3-v4:
- refactor and reuse OvS code (Cong Wang)
- use csum API rather than skb_post*rscum to update skb->csum (Cong Wang)
- remove unnecessary warning (Cong Wang)
- add comments to uapi attributes (David Ahern)
- set strict type policy check for TCA_MPLS_UNSPEC (David Ahern)
- expand/improve extack messages (David Ahern)
- add option to manually set BOS
v2-v3:
- remove a few unnecessary line breaks (Jiri Pirko)
- retract hw offload patch from set (resubmit with driver changes) (Jiri)
v1->v2:
- ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)

John Hurley (5):
  net: core: move push MPLS functionality from OvS to core helper
  net: core: move pop MPLS functionality from OvS to core helper
  net: core: add MPLS update core helper and use in OvS
  net: sched: add mpls manipulation actions to TC
  tc-tests: actions: add MPLS tests

 include/linux/skbuff.h                             |    4 +
 include/net/tc_act/tc_mpls.h                       |   30 +
 include/uapi/linux/pkt_cls.h                       |    3 +-
 include/uapi/linux/tc_act/tc_mpls.h                |   33 +
 net/core/skbuff.c                                  |  169 +++
 net/openvswitch/actions.c                          |   81 +-
 net/sched/Kconfig                                  |   11 +
 net/sched/Makefile                                 |    1 +
 net/sched/act_mpls.c                               |  406 ++++++++
 tools/testing/selftests/tc-testing/config          |    1 +
 .../tc-testing/tc-tests/actions/mpls.json          | 1088 ++++++++++++++++++++
 11 files changed, 1754 insertions(+), 73 deletions(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

