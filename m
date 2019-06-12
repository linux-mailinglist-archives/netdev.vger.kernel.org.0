Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C47426B0
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437162AbfFLMwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:52:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35514 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730492AbfFLMwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:52:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so21555775edr.2
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=5CZDhiASChEeRvpaq90YY2XiRHdt8LTxffpW/umEMhU=;
        b=FSVV6UhNhcpVLU8N5e2sIxxVcwaGZ8vRCKtC/NGyk+lIgMsQ0W2z5mvlGIKcRTSGQI
         Wg1w7QZ7VehYT1F1iNXxv1q5+VlFGD2yDAA7DTA+K9OL0kQ1sl5F3f1ZBYLyTmjY408x
         y+AHbA4h+LqGwVbFPpk+mz8XPoFWbu66QmhItIdxZvctA5sIWtngABlkbM5mYXnrRkii
         bAYjVfSShr+ke/SYbzcIgWFk0lrDtwlBkQwy/ztxgh4brveNDaWIQl8LGM9C3JCP5igu
         EWpc1NQ/B0UOONFyeZ106i4PfDp5rabfXi0lu22R5PwIklCfXKBmPvwNbZTPAolKfcSA
         5n0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5CZDhiASChEeRvpaq90YY2XiRHdt8LTxffpW/umEMhU=;
        b=JPhKyGrR/4PavN/N0EOvAlfTIGAn6p5u4bc/hqXYNdjnJwWdANTKddM3XFaqKDkPr+
         1tEBzlY3rFOhGBLWmd801dvguA04Ap38Vf/iVdC9dCDqAv96nlMIRZwjAGmep+Bp8y4f
         h2U9k6vWDaL7BZRWQNmleI4w3l9OsIwTnLkmdWeq9LOu205gX3wVvt6FcS7tJMVPqbKN
         nkxtPJIPmlaKLczNIjQyrD3KeVIEZKiH2J1qlKN8vDJKtSZ0N2bB2gkL3xRyabgjfwma
         ibwPY4OeORMpKgo+pmm9vo/FQ/bMVeNHkpUIDPqkx6VYF3c+MUIInYAO1HOmVwprG7j7
         L/RQ==
X-Gm-Message-State: APjAAAXH/mUxqo+CU9P3wWJEFKAmoCT9cc637tU4av4zh9AJTL0gE+Dl
        M+oFrI2Hosu6no1O0vT3o9BtdFl2v+8=
X-Google-Smtp-Source: APXvYqxdwvOQ202dNzm0yGpbhiX8IvfuRm/KeLzi6NOmpTUshJYNi4Nz+8rIKUA3XDiElCE5icU01Q==
X-Received: by 2002:a50:b14b:: with SMTP id l11mr61103600edd.76.1560343932487;
        Wed, 12 Jun 2019 05:52:12 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u15sm17043eja.32.2019.06.12.05.52.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 05:52:11 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 0/3] Add MPLS actions to TC
Date:   Wed, 12 Jun 2019 13:51:43 +0100
Message-Id: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces a new TC action module that allows the
manipulation of the MPLS headers of packets. The code impliments
functionality including push, pop, and modify.

Also included is a update to the IR action preparation code to allow the
new MPLS actions to be offloaded to HW.

John Hurley (3):
  net: sched: add mpls manipulation actions to TC
  net: sched: include mpls actions in hardware intermediate
    representation
  selftests: tc-tests: actions: add MPLS tests

 include/net/flow_offload.h                         |  10 +
 include/net/tc_act/tc_mpls.h                       |  91 +++
 include/uapi/linux/pkt_cls.h                       |   2 +
 include/uapi/linux/tc_act/tc_mpls.h                |  32 +
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_mpls.c                               | 450 +++++++++++++
 net/sched/cls_api.c                                |  26 +
 .../tc-testing/tc-tests/actions/mpls.json          | 744 +++++++++++++++++++++
 9 files changed, 1367 insertions(+)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

