Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB10014077D
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgAQKJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:09:40 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34906 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAQKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:09:39 -0500
Received: by mail-pj1-f65.google.com with SMTP id s7so3077369pjc.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 02:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=T1rKYe5FEcCgcYmPy0w/sxTTA6Aq9gixOaCA+0rO1yk=;
        b=rt77WeNAiLYjR/8e6/mIqhjUP17qEQ3ExBIKqXcUgUC+K92iiqgPgUBJcO6O8kN//B
         4e83LYooiLyZHxSpvqA+vlF/LydsRcvv2biZz0t3RRmB2WXTtV6R3JsmhC7oBLuynJ7N
         l0aAOqubxov3/n6/ZtAnr7l3EInFfwFcT1jkZRyA72nwJ9RNKdJpIyMVDaYvdWycU3Mz
         BOOgCjvvk2SeDO5S3+PvTXtQYeJoaFGhOPWn4oDqhtRFvuLxYiKGb12mAqc2TKNY1NAy
         lFtD0lsYy0sNwaOEH4siK5NdQ/KKxjZLCTMesQFrGL09Z229vCQLQT53O9Ab2AifZVMf
         k3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T1rKYe5FEcCgcYmPy0w/sxTTA6Aq9gixOaCA+0rO1yk=;
        b=nIigku8me0YlijvEgBOQKzBxdFgicF0WTyjobBIeSLDrZ3+Wb9/5AHDU3sN6BsOY6b
         M+qCiSQPIXGZ6rI+FRyovtUosyTfrpbOn0WIDSwoKE1kkSyk8U2L4hx3GwMIvk81j7Ys
         AGack6p1m/Un3e7sCm+RsmeYjMjl6mS3Z6Rx5O9aw3HJZP8JE5q6LlOsou6QfoY8DDed
         QW5x15fVFcZbVmhv1iMuUkBnyQjCWuc2zlWCgZB0alYcUtny1jUlKIyIoNEZgoARgDXj
         /S//ATray2jCujuND28BwQCcK2zPyNoSh89m37wo3sb/qeGNCy4i4Y4q+EWK8Zniks4W
         Q/tA==
X-Gm-Message-State: APjAAAUopmGeNijt9JfHyNaCPumH2tHflsT9ESyMpqVBTBHpP3T1QG2G
        uofDWVq6rGGLt6fCi+OIfsT3m2SP7aHpAA==
X-Google-Smtp-Source: APXvYqw4VZ89ydeDvLHi/ygoFppZr8TudE0wGpVWTmPbMHtbjqYNXgwsAQft3OF4h02dPNBexobwsA==
X-Received: by 2002:a17:902:ba86:: with SMTP id k6mr41599178pls.96.1579255778353;
        Fri, 17 Jan 2020 02:09:38 -0800 (PST)
Received: from localhost.localdomain ([223.186.201.37])
        by smtp.gmail.com with ESMTPSA id i2sm348897pjs.21.2020.01.17.02.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 02:09:37 -0800 (PST)
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
Subject: [PATCH net-next v4 0/2] net: sched: add Flow Queue PIE packet scheduler
Date:   Fri, 17 Jan 2020 15:39:19 +0530
Message-Id: <20200117100921.31966-1-gautamramk@gmail.com>
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

For more information:
https://tools.ietf.org/html/rfc8033

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

Mohit P. Tahiliani (2):
  net: sched: pie: refactor code
  net: sched: add Flow Queue PIE packet scheduler

 include/net/pie.h              | 138 ++++++++
 include/uapi/linux/pkt_sched.h |  31 ++
 net/sched/Kconfig              |  13 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 559 +++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c            | 302 +++++++-----------
 6 files changed, 854 insertions(+), 190 deletions(-)
 create mode 100644 include/net/pie.h
 create mode 100644 net/sched/sch_fq_pie.c

-- 
2.17.1

