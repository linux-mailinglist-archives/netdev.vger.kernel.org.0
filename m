Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD562738F9
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgIVC5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIVC5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 22:57:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C15C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so11104642pfc.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SX0MD16g6As2uSb3prg8RGI6VNIsgIuzkxNzXyaHvWQ=;
        b=NGNl6usJj9JrZersth/Z2WKrSz45Gh3jbrdSZX72zVUoWjwbBG20UKPGQvPl/ISyPn
         uzXfl66NEw8QKhrFn1v8mG9HQV4rRFYcEjJzM3rwgDQYUPZPjm3DZwt3SCgGKgz0/E5y
         9x9mnbbf901cZiCeHd5eCdwLUGvPvQJ2SpThPrKXWiMwtPIp0UbzbY2FzvTpi8H+FwOW
         /2uZjz44asPLzoNy6b9gADD/6oseX/5jY4eHYUn97YgsbJqTMkmdyx2AXslg7qbTddji
         zzP3t6qGtRMo8yYVfP141laf2rUj1e+rLITETWro5jZ+BNt0t6Y3mrGVMQLPdZt0CBc+
         /SXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SX0MD16g6As2uSb3prg8RGI6VNIsgIuzkxNzXyaHvWQ=;
        b=KwT9+NMt3pVCf6QADsIzK8iotZBUifksDpu1REOCU2ZsZxozNxFhwgqkczyzAObUFJ
         Oq8unug91XQB3YdIB/i+dw61cXYtGHEStgsWHhBTCHm1WuLaHGcIK29R0crSlnyqeMI6
         6L7PYx2wwbWvdCXief0l+wII9/zCdpOXIBYvVpUeI/VNMD6nqy36UVUfnkr9PjNys5lc
         E1S4yiW4BEdG5Ddnc2lbhGn1ubXmN84aUc588q6B3hmd/uIixrhu0e41IlthvveLk+07
         dRqFLLDKFoBCR+Pl1o7oRd2uPiVkbSIOCptBDiYKFH69Uw0j9SK+KJOh/JTKyFQlXPhH
         0Nfg==
X-Gm-Message-State: AOAM5318A46zqCKO584eZaShhe4NrRDNxV/Ncw6MvFdGu6JutQPwNF1L
        im+KwX/S6UpwHTHSWP9TWAY=
X-Google-Smtp-Source: ABdhPJzrb/HxumHP9e5KTeF5D9y39k7i4d4xb7kMzKdujhGyE5Cnt3LLLE0BwSrF8IvrmBekG/FUbA==
X-Received: by 2002:a63:160b:: with SMTP id w11mr1916147pgl.110.1600743442752;
        Mon, 21 Sep 2020 19:57:22 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id 64sm13425349pfg.98.2020.09.21.19.57.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 19:57:22 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     jiri@resnulli.us, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next v3 PATCH 0/2] Introduce mbox tracepoints for Octeontx2
Date:   Tue, 22 Sep 2020 08:27:03 +0530
Message-Id: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
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


v3 changes:
 Removed EXPORT_TRACEPOINT_SYMBOLS of otx2_msg_send and otx2_msg_check
 since they are called locally only

v2 changes:
 Removed otx2_msg_err tracepoint since it is similar to devlink_hwerr
 and it will be used instead when devlink supported is added.



Subbaraya Sundeep (2):
  octeontx2-af: Introduce tracepoints for mailbox
  octeontx2-pf: Add tracepoints for PF/VF mailbox

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  11 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |  12 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  | 103 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   6 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 9 files changed, 146 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h

-- 
2.7.4

