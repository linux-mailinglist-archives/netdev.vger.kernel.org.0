Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5273C461D9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfFNO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:59:05 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41364 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFNO7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:59:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so3907867eds.8
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=hUXS1+6dAwBQV9DzPH7pWhAMpWpPRXQq+S0O3DxyIYs=;
        b=brM6YAlatxNCSnoycunvwErls4elKP3+cEL56dR6ci4gtBKLuognb9dhj15WQ3MW44
         Orsxbu8T/06XsW9zW4zkQGgEfhA0kJKTEfw396R3QpWwUaI0I16B+G/OqKMRCgZi70Iq
         1Vxag1W+MMutBXr7xgk5ekjtgDKU2/67Dm/RdaH4WGjRhj1hdGdgA64i34DgegdMRGkI
         YAuPMnzMuVit7qANoHyEL3FRpffe0aeZ5/OW5JIG7Fa7+YxQbnrh+8MgldJc/cKUK6Po
         b9Z33VljppFS3aoHyjZlMyfutz/HCIBSVV0RtYOUbdUijo4b0B9pEwibcAHXMAykvH6s
         fW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hUXS1+6dAwBQV9DzPH7pWhAMpWpPRXQq+S0O3DxyIYs=;
        b=QDAn0/VvYJFoNaaLqmrJnGjI/LDq/wHgJIlwBPcIaFV9BWtd4IKVz+laEpckVIdkm2
         V/k06zNzn0r0veAjFzJBKcxMpjIkN8NJdN1nssqoV3KrmbAnJQrY8ZVpnb0x+AbAQ2iN
         uHT8hqIWF79C19HoGHQCcxgkEGvph7FZkxwstjJMBvg5f+iYzWWS0EAx+pEyNQCN04+s
         qReCLrysEf7OVoJguKLaDPa+eSZNk2dZxubeySd5xXKmrNLk7qr96LsmKv4wE8GEFO/Z
         AJg1gq2N8CjdoHfa9PBbdfxah+q0Vh66PQxFnVIm+/fc3kOpFHG/h8P1htJcwhDDEbGf
         bZEw==
X-Gm-Message-State: APjAAAWzjGBtTXyIvSOYYZpZgX8MxPKDfi13/0wM1Ii8RMvoqPzModsr
        /MFiBIIjquXo3mBGPV1vo9Tp3TgNj/U=
X-Google-Smtp-Source: APXvYqxBuSquuSWQIq9U4PXPG0f4vd2KJolJfuxJrL3eK1SJ1ILNFK5QCi59HXUw1ZHbTSCc7ZJA9A==
X-Received: by 2002:a50:89a2:: with SMTP id g31mr68003407edg.93.1560524342948;
        Fri, 14 Jun 2019 07:59:02 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id e4sm634713ejm.53.2019.06.14.07.59.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 07:59:02 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dcaratti@redhat.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v3 0/2] Add MPLS actions to TC
Date:   Fri, 14 Jun 2019 15:58:48 +0100
Message-Id: <1560524330-25721-1-git-send-email-john.hurley@netronome.com>
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

v2-v3:
- remove a few unnecessary line breaks (Jiri Pirko)
- retract hw offload patch from set (resubmit with driver changes) (Jiri)
v1->v2:
- ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)

John Hurley (2):
  net: sched: add mpls manipulation actions to TC
  selftests: tc-tests: actions: add MPLS tests

 include/net/tc_act/tc_mpls.h                       |  27 +
 include/uapi/linux/pkt_cls.h                       |   3 +-
 include/uapi/linux/tc_act/tc_mpls.h                |  32 +
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_mpls.c                               | 447 +++++++++++++
 .../tc-testing/tc-tests/actions/mpls.json          | 744 +++++++++++++++++++++
 7 files changed, 1264 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_mpls.h
 create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
 create mode 100644 net/sched/act_mpls.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json

-- 
2.7.4

