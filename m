Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424982D1C6A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgLGVyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLGVyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:54:43 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A7C061749;
        Mon,  7 Dec 2020 13:54:03 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 91so10323323wrj.7;
        Mon, 07 Dec 2020 13:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+pK8CVsc3rcIp5ixSRppQm7NcMvGlTgpnTEyqyJntVc=;
        b=XqxMPgKJJx1lnIccuRjAvHM2WK86llsQFe1kWg/N9XcdKtDaUIvdXbmc1oPBjTNkr1
         +ARzsk80Hf0KVpA5w0dSeXV8sBXQHI5yxq2Vkyz9//Bp91aNY8Nogu73b9JrTjPKKR1V
         W4ZIUxe01wZLHWTVujnDVgmRSM0m/FBI0gflHdMVaUVCEfIvIPpzCvS7eQbOAaqoPCDE
         aqRjS/UDMHc3mmwkrDb7u8iSVv3uWxNg4l/QHAdr58HE2JbCEOWMMKtEYRhcPy4qeF7Z
         sqRker13MPfTIIMtHlIC0Tiocijh38n2SR9wq/bM182kX0hy/ideWbwGTBuVg1L/tH9q
         7NWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+pK8CVsc3rcIp5ixSRppQm7NcMvGlTgpnTEyqyJntVc=;
        b=HOPNa0x0QDWO0UhwKWkVeS66WXPX93qngD6cPM91vdCNYrkuyBW3SxujjcA+8mUkbE
         Xo2RTBudRhd9tzkUGplg5DoWwRjeF6UBAUv2L6N3P/ofJ7+3QL6ghKetsBsKH2i6j04o
         8xFGaak6i511DRHT5RemKn8qKmTffneAZSz7KS6k+CVpgijqho/dJKPEgoukq4ZfbjZa
         6TiObG4O4x2hBXG7RpTAM2IbWXGsOQuDrnL4sYefDZ74+TQDvi1x4P4KgZBVFnFCHNig
         hFzXuhn7xKvVx9RPTCeEtHzTbFukw/qL/k0eCh/u/DsRKSqbkSoUbjUFVJh0xvJrtQle
         RRMQ==
X-Gm-Message-State: AOAM5306c6y8D4pEE3XJFv6ze3Pr7MTcLIW6eZ27WidkIR/w44F2qcS3
        dmJmh6F9IGp9jpRel1wt98apodZTIM6Gg5yR
X-Google-Smtp-Source: ABdhPJzksznIhDpy/p8N5RCjccN72CQtnEJYOGUKDFJLUfwIhYvaUWOUCKk0VAmBo9lMaj6qGfi1JA==
X-Received: by 2002:adf:fb06:: with SMTP id c6mr21720568wrr.117.1607378041614;
        Mon, 07 Dec 2020 13:54:01 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id z15sm1967290wrv.67.2020.12.07.13.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:54:01 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v4 0/5] selftests/bpf: xsk selftests
Date:   Mon,  7 Dec 2020 21:53:28 +0000
Message-Id: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
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

Prerequisites setup by script test_xsk.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface
   
   Adds xsk framework test to validate veth xdp DRV and SKB modes.

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

v4 changes:
* merge xsk_env.sh into xsk_prereqs.sh
* test_xsk.sh add cliarg -c for color-coded output
* test_xsk.sh PREREQUISITES disables IPv6 on veth interfaces
* test_xsk.sh PREREQUISITES adds xsk framework test
* test_xsk.sh is independently executable
* xdpxceiver.c Tx/Rx validates only IPv4 packets with TOS 0x9, ignores
  others

Structure of the patch set:

Patch 1: Adds XSK selftests framework and test under selftests/bpf
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
 tools/testing/selftests/bpf/test_xsk.sh    |  259 +++++
 tools/testing/selftests/bpf/xdpxceiver.c   | 1074 ++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h   |  160 +++
 tools/testing/selftests/bpf/xsk_prereqs.sh |  135 +++
 5 files changed, 1633 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

-- 
2.20.1

