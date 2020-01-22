Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704021453E1
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAVLfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:35:46 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40549 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVLfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:35:46 -0500
Received: by mail-pl1-f196.google.com with SMTP id s21so2861883plr.7
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ovoa59W81J5aV+2NXHNssCS8XsgXJX3FRNdJ4NrD1ik=;
        b=dodXvnkYKKNORyApuxxwwLuvwRhvLltw2hIMt9nGQyT804RvDGsLc0LFo43bLAhSzX
         IGKFp1vA34o23a4WRYMkAaA/Bb8dPEddM289FQ+LLWkkURi4gjoY/yKAU3m8C8hMKWFk
         QSjZt/tictLiRQOb9yW/WLcqbd0gDsh6x7tY8C7sZNGP7e+F+fXcMrAoF0Ih/4a36PtY
         DjI9QhG1vFLWs5UDVFDCq0T2JHu8YybfG21PwFR8dUOZk+TvXdF+G7A7YwFHFtpgx0sk
         sKzqlWRvYobMyySYq6IZtauScJ/u461VrggLT4aptpTmH2AwdHwUeW7r4pumLv8N+g2N
         PK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ovoa59W81J5aV+2NXHNssCS8XsgXJX3FRNdJ4NrD1ik=;
        b=OXAlQwsyB4C3IPQBgNZ3CPO+q/T3tofB0cy3jgCyePRMY8W00yoQBQObtjeaWaeDIV
         Q00MwandAcAbQC2RuMiMxYX77W2qXWWPBrt4E5VHqCqnv5SFuqvdOjfYP4aFm7JOPJ2X
         8ZTzR8OBweSishuEgJDZPeENpcGUop6jbWPiyzv2t/isAJ1h4oKbgGp3Broc3G7pBGMD
         nGK7ak6BwWvnhYU/sZ4lsTTUrhkHAH/anNGcBkmNIvC30HiIBjFkuG+3gfhpM/bGrTbD
         R2hLz3eUwOyCIgRMSY/bCnzQdwDWAqZ8xlaJ6yppaXxO20QcTCwaZTFwk/TRudpmh8I1
         ZXJQ==
X-Gm-Message-State: APjAAAWlSJBFma0GTa3bRCISd27QGaAJDdIeIeYfbhtvNaeKeL7h+3YA
        PbyIQVoiMROOzbWNLAL6CED+Nz3Gcfhy/XqL
X-Google-Smtp-Source: APXvYqzgYWWxsZYHAHvBraQd9gnihF+GkLaiQIxcRMv18i8HAqcfQyrbnjLZ9ojEw+xauAN9Gf2gbw==
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr9992621plo.203.1579692945258;
        Wed, 22 Jan 2020 03:35:45 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:35:44 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH net-next v6 00/10] net: sched: add Flow Queue PIE packet scheduler
Date:   Wed, 22 Jan 2020 17:05:23 +0530
Message-Id: <20200122113533.28128-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Ramakrishnan <gautamramk@gmail.com>

Flow Queue PIE packet scheduler

This patch series implements the Flow Queue Proportional
Integral controller Enhanced (FQ-PIE) active queue
Management algorithm. It is an enhancement over the PIE
algorithm. It integrates the PIE aqm with a deficit round robin
scheme.

FQ-PIE is implemented over the latest version of PIE which
uses timestamps to calculate queue delay with an additional
option of using average dequeue rate to calculate the queue
delay. This patch also adds a memory limit of all the packets
across all queues to a default value of 32Mb.

 - Patch #1
   - Creates pie.h and moves all small functions and structures
     common to PIE and FQ-PIE here. The functions are all made
     inline.
 - Patch #2 - #8
   - Addresses code formatting, indentation, comment changes
     and rearrangement of structure members.
 - Patch #9
   - Refactors sch_pie.c by changing arguments to
     calculate_probability(), [pie_]drop_early() and
     pie_process_dequeue() to make it generic enough to
     be used by sch_fq_pie.c. These functions are exported
     to be used by sch_fq_pie.c.
 - Patch #10
   - Adds the FQ-PIE Qdisc.

For more information:
https://tools.ietf.org/html/rfc8033

Changes from v5 to v6
 - Rearranged struct members according to their access pattern
   and to remove holes.

Changes from v4 to v5
 - This patch series breaks down patch 1 of v4 into
   separate logical commits as suggested by David Miller.

Changes from v3 to v4
 - Used non deprecated version of nla_parse_nested
 - Used SZ_32M macro
 - Removed an unused variable
 - Code cleanup
 All suggested by Jakub and Toke.

Changes from v2 to v3
 - Exported drop_early, pie_process_dequeue and
   calculate_probability functions from sch_pie as
   suggested by Stephen Hemminger.

Changes from v1 ( and RFC patch) to v2
 - Added timestamp to calculate queue delay as recommended
   by Dave Taht
 - Packet memory limit implemented as recommended by Toke.
 - Added external classifier as recommended by Toke.
 - Used NET_XMIT_CN instead of NET_XMIT_DROP as the return
   value in the fq_pie_qdisc_enqueue function.

Mohit P. Tahiliani (10):
  net: sched: pie: move common code to pie.h
  pie: use U64_MAX to denote (2^64 - 1)
  pie: rearrange macros in order of length
  pie: use u8 instead of bool in pie_vars
  pie: rearrange structure members and their initializations
  pie: improve comments and commenting style
  net: sched: pie: fix commenting
  net: sched: pie: fix alignment in struct instances
  net: sched: pie: export symbols to be reused by FQ-PIE
  net: sched: add Flow Queue PIE packet scheduler

 include/net/pie.h              | 138 ++++++++
 include/uapi/linux/pkt_sched.h |  31 ++
 net/sched/Kconfig              |  13 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 561 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 289 ++++++-----------
 6 files changed, 848 insertions(+), 185 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

