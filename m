Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B095D3EE9BB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhHQJ31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbhHQJ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:27 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724DC061764;
        Tue, 17 Aug 2021 02:28:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id q11-20020a7bce8b0000b02902e6880d0accso1405155wmj.0;
        Tue, 17 Aug 2021 02:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLoxXMvD3wH0HnG5g/R91tYNAKMhdE8zYPs9l4BI0Gc=;
        b=eXrGC2a2zuXsVLCYE3clo644WLpgYkedic5vAUPUxnLqnRCQ+ayqNGRjR9/JsDwqDy
         Ak2Jhl0PREAV2G0TLIOJl3MfIqatOix34VLQ4SzympOI5gPlf+wn6dC0L5WxBA6lSFoi
         8CKOgNRzysdZI4NaeRoIlNtCua5eb8EGkj1hmM4ZKJSvHgIRiCPitN6suyLiDJeh898P
         MGKkdlY2PEtbnOpDJpw04mN+dvajjV/XZQ+3CPkgoKgJVFVIGn7geW5kmQRUw5OnZhAK
         3XoW5mXIfi0sZUSt0p25jt4Kqr6HsaXvdPgUnP+wtZDFyPErZhjXnFbQIerQgEvZunt6
         SjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SLoxXMvD3wH0HnG5g/R91tYNAKMhdE8zYPs9l4BI0Gc=;
        b=it9WiQ3ntf6WCba1XltXHxsSVTXGqxC8lJu5yDGea4a037w6ILXuZbdB8nKCvDVwo5
         IrbiWrdlbGwq4I6zjCci4Rh7kHGt2xcQ7NGgoTgrw3euaLOBWG1pgKcd1ABrZdmKsQY9
         vw3haRAs3/UiXI5fEV6M3/k6vJe4NIndj+aJ7glnPmFOg69l9rRDpMVXxzUN+gTdZGt7
         HPYX0aduNPTcRaxfCL3YB/uVo9sZhYUvLixuFZE9HR4DDqo866oKKQzHuMASPjTE/H6d
         4pPHLjAuUAa9tpuX8ZICZEktJr6JrIrHD8gsrv3WgEzc4oSbuXajXNcSHzO/VGzypptw
         kqUw==
X-Gm-Message-State: AOAM532FwT7d+4uvQCwvi0vudoVy6+pKxEFK3vX1IMcyS49OJpkh7AHB
        62wMdXmC3pTHeQOwNEHeW2k=
X-Google-Smtp-Source: ABdhPJyTyhpXfftZ82jfZe88pOo1QyCMwVpOTFi8myqcc+PHY3OsxR7mSDhZ3SWF7pVtjVLi9rl7AQ==
X-Received: by 2002:a05:600c:1c1f:: with SMTP id j31mr2247282wms.66.1629192532968;
        Tue, 17 Aug 2021 02:28:52 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:28:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 00/16] selftests: xsk: various simplifications
Date:   Tue, 17 Aug 2021 11:27:13 +0200
Message-Id: <20210817092729.433-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set mainly contains various simplifications to the xsk
selftests. The only exception is the introduction of packet streams
that describes what the Tx process should send and what the Rx process
should receive. If it receives anything else, the test fails. This
mechanism can be used to produce tests were all packets are not
received by the Rx thread or modified in some way. An example of this
is if an XDP program does XDP_PASS on some of the packets.

This patch set will be followed by another patch set that implements a
new structure that will facilitate adding new tests. A couple of new
tests will also be included in that patch set.

v1 -> v2:

* Dropped the patch with per process limit changes as it is not needed
  [Yonghong]
* Improved the commit message of patch 1 [Yonghong]
* Fixed a spelling error in patch 9

Thanks: Magnus

Magnus Karlsson (16):
  selftests: xsk: remove color mode
  selftests: xsk: remove the num_tx_packets option
  selftests: xsk: remove unused variables
  selftests: xsk: return correct error codes
  selftests: xsk: simplify the retry code
  selftests: xsk: remove end-of-test packet
  selftests: xsk: disassociate umem size with packets sent
  selftests: xsk: rename worker_* functions that are not thread entry
    points
  selftests: xsk: simplify packet validation in xsk tests
  selftests: xsk: validate tx stats on tx thread
  selftests: xsk: decrease batch size
  selftests: xsk: remove cleanup at end of program
  selftests: xsk: generate packet directly in umem
  selftests: xsk: generate packets from specification
  selftests: xsk: make enums lower case
  selftests: xsk: preface options with opt

 tools/testing/selftests/bpf/test_xsk.sh    |  10 +-
 tools/testing/selftests/bpf/xdpxceiver.c   | 626 +++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h   |  61 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 310 insertions(+), 417 deletions(-)


base-commit: 3c3bd542ffbb2ac09631313ede46ae66660ae550
--
2.29.0
