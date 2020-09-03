Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FF325BB7C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgICHSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 03:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICHSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 03:18:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2460C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 00:18:31 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 5so1399588pgl.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 00:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eP1VEzBZzt4J34HhNTkA04cTJhKkMZ3aln3cpKFeUE8=;
        b=WkLfxIIFGtN8ltwPWHVwtqg4WYHb+N6sFGJ6auqAHm0S1pbsqIdqhhmUG/0N+iNnbV
         VFZBxf8mCN5calOwogdIuS8lVFFjiwX5tiABWGEewoiH/NwnpRlEQzQL35yNZB4ZlsWE
         MOOWoJtIW3ePaci04VdY8WPBf3rOs1XH4dQ8WCL1p2iF0Qo4ge9jcDCKzPEvx6Qpp4Do
         DIraDt0CI7vFfyf271vvP9eO3fpMiQtO9y/xyC6xytdCrbwH96SuezuFWbAe0vuwj0aR
         Jjvk5NieUPUBxtnZMFK82rybtBN7vcv6hVLRwdAm3TDHEMc8U8eza0L9b1t3XpNi9bU1
         5bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eP1VEzBZzt4J34HhNTkA04cTJhKkMZ3aln3cpKFeUE8=;
        b=rfTS3zMHF2AKZV3eQMzvA30pz4Ql4rLV4HpCRXl3pwf7julyq0iwIM0Km9UGgaRf7w
         1HdV2BTYTc5Q7fBkYGyrCiElr0LZMBSsdYxprH8cSiqCHHXXQotPOfkqhumPKdBZ6e9n
         OLurRGWUN/ehLnGh59yFP5Jsr+ZJAq1tkkVuiqnCjFLiSLvX9u+xiYyaOYnbkwnql0l6
         4DyKUpdkcVDw1S60Mu5Z6cuQqfM10Hvx2UhsElb5i5mXPmdkMBVyHftHrcm4R6nQEqAI
         LH5Do2l1i3aBcRFsIZSRvHwm9zoBLGnol5a54CeJnM+OFyQXCuWaDFc0CpOgewmJ1RHh
         7s7w==
X-Gm-Message-State: AOAM532YuJ5YeDQ5rReSYT6TKA1kp6+WZLa0i68ZWp/0rRuMLzu9Koua
        h8H8djmVeoAThEIIbXkxD/A=
X-Google-Smtp-Source: ABdhPJzwYD6JvadHQQlRaez3OVxP7Q5coV6AFr6WIR2CPoPX5aPH7VFJZdaLX95CKNXj5m8zkTqSUw==
X-Received: by 2002:a63:338b:: with SMTP id z133mr1842769pgz.226.1599117511090;
        Thu, 03 Sep 2020 00:18:31 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id x5sm1506266pgf.65.2020.09.03.00.18.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 00:18:30 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
Date:   Thu,  3 Sep 2020 12:48:16 +0530
Message-Id: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

This patchset adds tracepoints support for mailbox.
In Octeontx2, PFs and VFs need to communicate with AF
for allocating and freeing resources. Once all the
configuration is done by AF for a PF/VF then packet I/O
can happen on PF/VF queues. When an interface
is brought up many mailbox messages are sent
to AF for initializing queues. Say a VF is brought up
then each message is sent to PF and PF forwards to
AF and response also traverses from AF to PF and then VF.
To aid debugging, tracepoints are added at places where
messages are allocated, sent and message interrupts.
Below is the trace of one of the messages from VF to AF
and AF response back to VF:

~ # echo 1 > /sys/kernel/tracing/events/rvu/enable
~ # ifconfig eth20 up
[  279.379559] eth20 NIC Link is UP 10000 Mbps Full duplex
~ # cat /sys/kernel/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 880/880   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        ifconfig-171   [000] ....   275.753345: otx2_msg_alloc: [0002:02:00.1] msg:(0x400) size:40

        ifconfig-171   [000] ...1   275.753347: otx2_msg_send: [0002:02:00.1] sent 1 msg(s) of size:48

          <idle>-0     [001] dNh1   275.753356: otx2_msg_interrupt: [0002:02:00.0] mbox interrupt VF(s) to PF (0x1)

    kworker/u9:1-90    [001] ...1   275.753364: otx2_msg_send: [0002:02:00.0] sent 1 msg(s) of size:48

    kworker/u9:1-90    [001] d.h.   275.753367: otx2_msg_interrupt: [0002:01:00.0] mbox interrupt PF(s) to AF (0x2)

    kworker/u9:2-167   [002] ....   275.753535: otx2_msg_process: [0002:01:00.0] msg:(0x400) error:0

    kworker/u9:2-167   [002] ...1   275.753537: otx2_msg_send: [0002:01:00.0] sent 1 msg(s) of size:32

          <idle>-0     [003] d.h1   275.753543: otx2_msg_interrupt: [0002:02:00.0] mbox interrupt AF to PF (0x1)

          <idle>-0     [001] d.h2   275.754376: otx2_msg_interrupt: [0002:02:00.1] mbox interrupt PF to VF (0x1)


Subbaraya Sundeep (2):
  octeontx2-af: Introduce tracepoints for mailbox
  octeontx2-pf: Add tracepoints for PF/VF mailbox

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  14 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |  15 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  | 115 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   6 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 9 files changed, 162 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h

-- 
2.7.4

