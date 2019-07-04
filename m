Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20FB5F9E1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGDOQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:16:51 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37871 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfGDOQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:16:51 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so5585019eds.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ex8dXKJ8Epkd3yYLIeEf6nBJprMcPEDpPx1N+EIdIV0=;
        b=eZ0PFRP/FuKawOUgBlvV1FbUJg9l3sKBaoZ/gRBlNLWwhA3l5QW96O3oKKudz01+P1
         AB74XTy/31H3RerqtkD6o6urHS8ZH1LrQRO1gUWquK3ZjYg2QYtRiRmK6Qog7TzIp+el
         uSOfkOcVDYK8dTvud932F+YSL2MnM06XJXfgZWYsoS3rMSDjaZXAEo3Dd1IsXMsMWpGZ
         THihfeOKoZqsJg/35v6GccctKEz27fVOyvCQqCZmUlrq6Jqc7zTrXJIrUG7kz29DVRoi
         q4XsaGsx1HYUF7dkr7b+Cd6nNcdXd+6t+mOHNS2BVt6pFW6bZ0FsgrTwGJQaVewEUHru
         UQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ex8dXKJ8Epkd3yYLIeEf6nBJprMcPEDpPx1N+EIdIV0=;
        b=FvZB5KqM4AHIlWgQSDNXWxrfekA9uB/yejFPSF7Ry51AsBrmeSdrN0j7JJrLsdjTFh
         eA9xeiaq518Ncf2PZRqxTm2nD6oI9LV9khciD9DpeQqc8HZeY1uAU9rZq1Q5utkjr1qL
         IQ6Bs0NNOYq5A9kMAqnPiJVS4TNTzgid/3mn8acjoLlZgzxBeGea45FfaRypAMeG7skh
         69QEh22PFF9azHo4qAHytiXeANGOHW3WQ3w3M7ByJsrZ65FyVm8LqT0J0QH4givgHLi2
         02bWaa+q6UJbiEWQ/qOsTR2UlaMLJUzWMdb162wk+co37/Uq1eMWbCWrRdeJGaNdEVwY
         0Q8A==
X-Gm-Message-State: APjAAAXr6fV4KmGhb5nh1uk4jZSn/F+DL1/wjRZy6ae54UylreJ4yk7K
        CRsBM0bQZcRJOqOSZb0xsI8ig3b6kfo=
X-Google-Smtp-Source: APXvYqz+F40i6+UZyn4/fQPabwzks9lnXZsM74EsAoUhHNAth7fCQVq9qWxFiKA8YF8ULtlh/lRJFQ==
X-Received: by 2002:a17:907:20b7:: with SMTP id pw23mr40345606ejb.127.1562249809647;
        Thu, 04 Jul 2019 07:16:49 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id s27sm1702705eda.36.2019.07.04.07.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:16:49 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v6 0/5] Add MPLS actions to TC
Date:   Thu,  4 Jul 2019 15:16:37 +0100
Message-Id: <1562249802-24937-1-git-send-email-john.hurley@netronome.com>
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
  selftests: tc-tests: actions: add MPLS tests

 include/linux/skbuff.h                             |   4 +
 include/net/tc_act/tc_mpls.h                       |  30 +
 include/uapi/linux/pkt_cls.h                       |   3 +-
 include/uapi/linux/tc_act/tc_mpls.h                |  33 +
 net/core/skbuff.c                                  | 169 +++++
 net/openvswitch/actions.c                          |  81 +-
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_mpls.c                               | 406 +++++++++++
 tools/testing/selftests/tc-testing/config          |   1 +
 .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
 11 files changed, 1478 insertions(+), 73 deletions(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

