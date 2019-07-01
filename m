Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE395BB86
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfGAMbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:31:11 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45107 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfGAMbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:31:11 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so23218749edv.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=BjlAcWPeK16zQi8VUExy0NHk8/fo/hf5u/YTcnsBtec=;
        b=gfrzR6jrEan0H1DzNqmnF7+d8Y0WSyeiC+wAiuenkCz7GDbaanox6nDDfAskKcAblk
         cJOKczB9wtzuB4WGO+sG61IFwXIh8wIDNuql+MN/N6F4dYCz+tM9Hfi4/c9zCQWUckHD
         UEFTgi9dQsgRV7YyRuq0J3x4hm2IiXMKoXwwJhBqGNMzV+qhXiYTzvPLakDs9DPFwccP
         nbdibl73jrORRptoDN83pTHP9xkYPHgtMMN6D86GHevZbc9tsBSngDSg4siSceY47KK/
         DeCTqL1SB/evFINunME6NGo8636fH6swZjC++h3G1h/3FeE3c774KaTyaoaNwVrLzmdn
         RBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BjlAcWPeK16zQi8VUExy0NHk8/fo/hf5u/YTcnsBtec=;
        b=I5MBTSfDrDIzq3j1IVOjSoGgPOzn5DM5xArz0mU9L8JTiLXxYoOa2Dlv5gq/o+k664
         NwPhWue0eYyDbDoi9cshdyrjYPo0uoXWYSjSof4ZcT/mRHs8TNe27irrTSnLL8Spu/DG
         l+rCEiQH8/X6QohEDwhUEntz+BOw2DrWoR4gRu5tVr4SNxUCOMec6IKGuP9sRencWfLc
         1Px7Scb7AS1HzbcNWNY7a2crDQ+JXz2szifrCLeS1TVwOYo/wUyK5nocIDVoAT5F8hTG
         0DzFrZUMYxoNRZFwL7DVfTLhjOFdG49+zAxqH7QeFNYTI3vCIgM7cXFb/iv4n49I6D3G
         mEBw==
X-Gm-Message-State: APjAAAWTsDP/38/T7Wd6wGEa6T7CKECvo/nslO/5yX8WbaLluOXHKB4Z
        GkRLBWm+3oQzfs/Wj60ZFixTE4FDVP4=
X-Google-Smtp-Source: APXvYqwEi1caMvHaGqFusReBsOkgYmvVV6MIHTCcmC8fc/ieECO2pakUbgPHv7ROcKriUnsdnCY3+Q==
X-Received: by 2002:a17:906:8386:: with SMTP id p6mr22545320ejx.139.1561984269099;
        Mon, 01 Jul 2019 05:31:09 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id a3sm2099204ejn.64.2019.07.01.05.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 Jul 2019 05:31:08 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v4 0/5] Add MPLS actions to TC
Date:   Mon,  1 Jul 2019 13:30:52 +0100
Message-Id: <1561984257-9798-1-git-send-email-john.hurley@netronome.com>
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

 include/linux/skbuff.h                             |   3 +
 include/net/tc_act/tc_mpls.h                       |  29 +
 include/uapi/linux/pkt_cls.h                       |   3 +-
 include/uapi/linux/tc_act/tc_mpls.h                |  33 +
 net/core/skbuff.c                                  | 140 ++++
 net/openvswitch/actions.c                          |  81 +-
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_mpls.c                               | 413 +++++++++++
 .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
 10 files changed, 1453 insertions(+), 73 deletions(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

