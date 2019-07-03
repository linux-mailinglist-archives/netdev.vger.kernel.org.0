Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8945D8FF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGCAcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:32:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45391 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCAcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:32:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so281595edv.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ad+yqaAhKn13Irl6cWq5+CTJ5Qw1NrmcQnP1sqNMYPs=;
        b=B36xeNgQxXpy141uRR1m4TpIJE1AaDJGK146sT/gVs3W26uvtIu3kLfmDllI8574mQ
         ayq9mo8i8jtXi0ymOL9dpY2eQfVm6KtDtFb3AYU/oGC8IUK3U790JeKVwRSHM51Gs0kn
         PTtas7p/2pK/KhXBaLczpNj0ZsqJp++8/btE+iagmeIib0z4Yrq5ZsorWItLfkMCKvCD
         r8ZWi65jrdQndyS89gdOfkoJOxKihu85Jo4+eO5Dep4jUq75kpUN0thiCvKD/JLpuP2Z
         79sJQ5sOWCyR1bEOa3MV+U1Shz7DwvwdFDnZY7YmbGHW7pITkM9KVjYDooA66RX4+u0+
         abHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ad+yqaAhKn13Irl6cWq5+CTJ5Qw1NrmcQnP1sqNMYPs=;
        b=fF2odPATVE2+ghkLMawjV1v9U60v3hcmUspanUOZTN9nZRbAyHsCUP/hEUkcUIo+G1
         rypqvnYD2axCSKwwkx+iVcAoObidUnsLKbtQTvtZE6jaAVbPiZaQYbce7Z9dtypUKtUV
         IEQ0GDtNtfn+FI3HpkkzvkLhyWpz1EGQY5+2+66T9wkCfxUVgX88COPAj0HFeJvFxgUU
         AkUKVu7rsinMba0pJ0djdnS1Dj1cscqw87kpeRuRDpg6WCnqrGXn+ywDfvg40/mRxa5B
         +1GO8SKtu1lMG3DkqX7RkZwOVIB0+ye2py/vqpRxDdDmj/nhSSyCQNNMXHksEsMm6aMX
         6Ttg==
X-Gm-Message-State: APjAAAWIKCualzrAnx+AiSgoPJvG9MuYiFFZNCVBjIbWFnJhVQGXcVsW
        qbi33aaogte7G6anmUqiVCN9F2nm6Uk=
X-Google-Smtp-Source: APXvYqyjZ0e98Hzj08QZgKXorw8Rq83nv+pjsb+cY5ek6O1B1rNLq7d4urg2KHamTyy46OFqC5/Sfg==
X-Received: by 2002:a50:95a1:: with SMTP id w30mr39123480eda.177.1562113554119;
        Tue, 02 Jul 2019 17:25:54 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id h10sm168768eda.85.2019.07.02.17.25.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 17:25:53 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v5 0/5] Add MPLS actions to TC
Date:   Wed,  3 Jul 2019 01:25:26 +0100
Message-Id: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
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
 .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
 10 files changed, 1477 insertions(+), 73 deletions(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

