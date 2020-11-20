Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB92BAAAF
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgKTNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgKTNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:00:44 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C992C0613CF;
        Fri, 20 Nov 2020 05:00:44 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id o15so9958979wru.6;
        Fri, 20 Nov 2020 05:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YrVsl77v5RNxUEy41ZltptpT1I1IuhiAow2CCvYm/oU=;
        b=FUE6BYKWeAe99FY0tXXcBVFU8+15IPNBEimyfGdMReEdhx0NtZH8izu2WPfj+KO1GL
         vfEYrLwK20jSaU+1R9CuI3f2SavbO8BC6iUHu7Vr9MdapEbWxkS/U2+rmaXc+IomToUR
         kK4UgMnjdWquuIw6ZrrVUON04MWqpLScvQpqaHFHp8ITxrv9eM0sfz82d6zcM3k9MSBP
         TAwsfSZ6fXff2wIxVbAIqZ31VKnv7YiHhQG1jg4o7+YXVzIGrOEG9TN3Gu9o1KLik3Rr
         wMqAQjRMTh3QsjxkEQOcdzX4n05MHM1hH8cGkxsmeHSPMavlMKkrRMzKwH8jFhc6twRj
         w3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YrVsl77v5RNxUEy41ZltptpT1I1IuhiAow2CCvYm/oU=;
        b=QHypDm7Lqm/lfVExtNKYIQhLoXqONB9r711L5TYK4yIayAiHOpDZwRqghusfR9Dkd/
         64hN9i0CdNZS5auRf+SSQPRXutOwMZ2wmX8H048KPg+DmJ5O0eVQFJGC+7Z2pFHHhW9s
         k7U0cg8QGbyXB+TCkIRbHpdvyu/HRfbwxeSVWAS0FO8FUq1dXP6nOMWp124ONAnP/T9B
         Nq76t+Our9AziDncnWj/3G9jR8pJngXVjxUJAilk7Wo0Ym9QD1Q3UhmM1tT5s4SqfcQA
         VBBqBPrJ1K36gyxyocSG1h69cro7FWi301h7UbPD20dQsTkRwxhyoLpORyH51BO1ZkZf
         r93g==
X-Gm-Message-State: AOAM532iuUDB7Ibq8tscm/36Rnaz53orrZpaSo6oF/+2dcKdmBiyTzb2
        nOUModdtXt2jIGgjHD0YNwtENcJh0+EXZNmGvgQ=
X-Google-Smtp-Source: ABdhPJxAZWJtipjhs2JU9ZAazaiRGPpeDpEw6BxxDAR42F0jPu4BnxvVoNU6ubheBSdXvghn6f+eXQ==
X-Received: by 2002:adf:814f:: with SMTP id 73mr15670252wrm.174.1605877242467;
        Fri, 20 Nov 2020 05:00:42 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id b8sm4074238wmj.9.2020.11.20.05.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:00:41 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 0/5] selftests/bpf: xsk selftests
Date:   Fri, 20 Nov 2020 13:00:21 +0000
Message-Id: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds AF_XDP selftests based on veth to selftests/bpf.

# Topology:
# ---------
#                 -----------
#               _ | Process | _
#              /  -----------  \
#             /        |        \
#            /         |         \
#      -----------     |     -----------
#      | Thread1 |     |     | Thread2 |
#      -----------     |     -----------
#           |          |          |
#      -----------     |     -----------
#      |  xskX   |     |     |  xskY   |
#      -----------     |     -----------
#           |          |          |
#      -----------     |     ----------
#      |  vethX  | --------- |  vethY |
#      -----------   peer    ----------
#           |          |          |
#      namespaceX      |     namespaceY

These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
Ethernet interfaces.

The test program contains two threads, each thread is single socket with
a unique UMEM. It validates in-order packet delivery and packet content
by sending packets to each other.

Prerequisites setup by script test_xsk_prerequisites.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
     that is read by test scripts - filenames prefixed with test_xsk_
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface

The following tests are provided:

1. AF_XDP SKB mode
   Generic mode XDP is driver independent, used when the driver does
   not have support for XDP. Works on any netdevice using sockets and
   generic XDP path. XDP hook from netif_receive_skb().
   a. nopoll - soft-irq processing
   b. poll - using poll() syscall
   c. Socket Teardown
      Create a Tx and a Rx socket, Tx from one socket, Rx on another.
      Destroy both sockets, then repeat multiple times. Only nopoll mode
	  is used
   d. Bi-directional Sockets
      Configure sockets as bi-directional tx/rx sockets, sets up fill
	  and completion rings on each socket, tx/rx in both directions.
	  Only nopoll mode is used

2. AF_XDP DRV/Native mode
   Works on any netdevice with XDP_REDIRECT support, driver dependent.
   Processes packets before SKB allocation. Provides better performance
   than SKB. Driver hook available just after DMA of buffer descriptor.
   a. nopoll
   b. poll
   c. Socket Teardown
   d. Bi-directional Sockets
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Total tests: 8

Flow:
* Single process spawns two threads: Tx and Rx
* Each of these two threads attach to a veth interface within their
  assigned namespaces
* Each thread creates one AF_XDP socket connected to a unique umem
  for each veth interface
* Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
* Rx thread verifies if all 10k packets were received and delivered
  in-order, and have the right content

v2 changes:
* Move selftests/xsk to selftests/bpf
* Remove Makefiles under selftests/xsk, and utilize selftests/bpf/Makefile

Structure of the patch set:

Patch 1: This patch adds XSK Selftests framework under selftests/bpf
Patch 2: Adds tests: SKB poll and nopoll mode, and mac-ip-udp debug
Patch 3: Adds tests: DRV poll and nopoll mode
Patch 4: Adds tests: SKB and DRV Socket Teardown
Patch 5: Adds tests: SKB and DRV Bi-directional Sockets

Thanks: Weqaar

Weqaar Janjua (5):
  selftests/bpf: xsk selftests framework
  selftests/bpf: xsk selftests - SKB POLL, NOPOLL
  selftests/bpf: xsk selftests - DRV POLL, NOPOLL
  selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
  selftests/bpf: xsk selftests - Bi-directional Sockets - SKB, DRV

 tools/testing/selftests/bpf/Makefile          |   15 +-
 .../bpf/test_xsk_drv_bidirectional.sh         |   23 +
 .../selftests/bpf/test_xsk_drv_nopoll.sh      |   20 +
 .../selftests/bpf/test_xsk_drv_poll.sh        |   20 +
 .../selftests/bpf/test_xsk_drv_teardown.sh    |   20 +
 .../selftests/bpf/test_xsk_prerequisites.sh   |  127 ++
 .../bpf/test_xsk_skb_bidirectional.sh         |   20 +
 .../selftests/bpf/test_xsk_skb_nopoll.sh      |   20 +
 .../selftests/bpf/test_xsk_skb_poll.sh        |   20 +
 .../selftests/bpf/test_xsk_skb_teardown.sh    |   20 +
 tools/testing/selftests/bpf/xdpxceiver.c      | 1056 +++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h      |  158 +++
 tools/testing/selftests/bpf/xsk_env.sh        |   28 +
 tools/testing/selftests/bpf/xsk_prereqs.sh    |  119 ++
 14 files changed, 1664 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_nopoll.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_poll.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_prerequisites.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_poll.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_teardown.sh
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
 create mode 100755 tools/testing/selftests/bpf/xsk_env.sh
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

-- 
2.20.1

