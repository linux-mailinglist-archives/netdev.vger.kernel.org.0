Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286AB2C47C2
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731280AbgKYSiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgKYSiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:38:24 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91062C0613D4;
        Wed, 25 Nov 2020 10:38:23 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id t4so2873689wrr.12;
        Wed, 25 Nov 2020 10:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ILPp3EC0bGPZc7QAejnetDCG1gvARXf7a++EJ/QnaI=;
        b=R878PtjX4MvoBt6ZyO6OJ7jLqKgjxV2WZW14owpwkqguShHRV19ADdCIRJhOPYl6vm
         GfxAqbbnSRmuA/IpwhuZdFfI8uh0MBnmchtn0eWon8/NHP6IIqu18ItyJ5tOAJo2XYqk
         7rFxh40DCx4cO7uO8/gXH/SMKtkxuVGS2xrIj2hRqiTLJlfLZC0AwiEEeH5iCnPSoi/v
         P/xQxlZUJebn/fMWcjxQFwIePhu2dwOXHx87amBomHk6fhIaGDscL+mUpghK+h1vFFos
         qssKerebbweMOMRxn8LTPFHqbgSb4t6bUs+7m2VaQwglcwv21sxiEEDqdVJjRuRqlYVi
         pLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ILPp3EC0bGPZc7QAejnetDCG1gvARXf7a++EJ/QnaI=;
        b=UDKSI26mbUgUk3Qq1LLpDVF3JJ8Kos7u9osfuJe2qUfn8+jpWSxzX+zdqRmLKgpW8c
         iw241FGEGH0bC5WqGtq5UvLbRxG694epzGUtqeWiLeYisVHZCuVNyTIumHUUw6dAxhR0
         0tB3vXXqVrpGRh/VMb3SPkjRAgfne5OtHi85Nrlg8A7NmPQwBhTP+KPhME5O0TC72Q+F
         IrwBTo1MYD4xBrSX7lzgqqUzAEf4n46HwtcXtfAgjDjH/RO211BZjEprBSuo17SndGL+
         pmyqJHFAXl8FM+B7GmdmxjlKRLAZEG5j1A9VlVkOFeAIEJ9d1b8QgVOuN2npMZW6V+Xr
         KC0g==
X-Gm-Message-State: AOAM5336zWkgNyDi3QLHmK+E0A/Yp9oYr+/23oLQ448WjKPQ2L78nv4S
        OYBr2bKWZr9wsD+sh7wa4b4r4sW5K32yHuEL
X-Google-Smtp-Source: ABdhPJw7wmxu9KycGGcV15TkTcMTep714zKA77Xf2wtQpa9pqdRrhyoTRe5B7oJGvhOrjwq1XzY+5Q==
X-Received: by 2002:adf:e6c8:: with SMTP id y8mr5679091wrm.414.1606329501759;
        Wed, 25 Nov 2020 10:38:21 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id h2sm5830035wrv.76.2020.11.25.10.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:38:20 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com,
        yhs@fb.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 0/5] selftests/bpf: xsk selftests
Date:   Wed, 25 Nov 2020 18:37:44 +0000
Message-Id: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Prerequisites setup by script test_xsk.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
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

v3 changes:
* merge all test scripts test_xsk_*.sh into test_xsk.sh

This patch set requires applying patch from bpf stable tree:
commit 36ccdf85829a by Björn Töpel <bjorn.topel@intel.com>
[PATCH bpf v2] net, xsk: Avoid taking multiple skbuff references

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

 tools/testing/selftests/bpf/Makefile       |    7 +-
 tools/testing/selftests/bpf/test_xsk.sh    |  238 +++++
 tools/testing/selftests/bpf/xdpxceiver.c   | 1056 ++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h   |  158 +++
 tools/testing/selftests/bpf/xsk_env.sh     |   28 +
 tools/testing/selftests/bpf/xsk_prereqs.sh |  119 +++
 6 files changed, 1604 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
 create mode 100755 tools/testing/selftests/bpf/xsk_env.sh
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

-- 
2.20.1

