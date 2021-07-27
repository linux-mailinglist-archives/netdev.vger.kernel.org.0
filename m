Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30B73D75B2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhG0NSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbhG0NSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF683C061757;
        Tue, 27 Jul 2021 06:18:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b9so14344949wrx.12;
        Tue, 27 Jul 2021 06:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hseTPeOuWoQZCzp4T+8xs/PPj4x/QmGmh/W2U5WUemg=;
        b=e2/qE5+zJy4a/KUgNh9xnP28gzMM4Kng4XTviknNV5Op13DhovHqim71nKXdmsoKdU
         1B6gjiAQAol7zB+kD2CcBUUb4poDNm+KsnjbqnBthKbceVQaS1VSbpdA/fLC8ANW6Vje
         BnPoaTOSqf+TLTM37wHy6fMH7sFxgTPfHSGEX4dQ8X/RMSSD7osF8xIvG6qBBj+9Nx1a
         CzrucEsDNKXRRwfZzbwsr4P9QEkGMYQxb6QJ9gLBNi64jFq9SGyJUag/e2QpimfUvfeZ
         YBtGyBjiCpQfYGS5p8jI8cUhjuyNc7BZpwy7ynW44UZfGznsBOZVyuzgl/g2xzbjCktE
         wckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hseTPeOuWoQZCzp4T+8xs/PPj4x/QmGmh/W2U5WUemg=;
        b=X+dTA9/lgXSpq5u0Zf/XVqNSSoDUZLDc7SfgbW5pHt9561WYtYL7mrXLLkh0xxuVfs
         v+eI4kVQ/daPP7Aym2MQd9ERzFb2B2wC/g5C8sbi1XLxehnqggOm/gU7h6JJj4YaQ3B3
         74VIGkQFY3gBD9+Gzfb+sVk+/5e/c6ARO27Ldzwrv9HYYJMP9MhX5dRCGKeS4uwqL9hW
         QWcPECXveRRvL/g96xYa51CKWVBXw24yuv386M1YMa8iSG9PtpyONa4HZ2UjBZw/EQGu
         wcf0A5iYWKag3i7dbe5aJUs91Pxl1hdE95lDUV0n1vnUMAhAY/kX3ub+VWKPl1Zuiwwv
         AVQA==
X-Gm-Message-State: AOAM530+2/Z6mRl5J9YzJut0FkPBlV1RuQN6f4k92oTOBSluBm738llD
        fsC+8B8Y67OWHacnLcYvSSE=
X-Google-Smtp-Source: ABdhPJwIvJtL31PV1WGQWvpHEmYBLIFYFOpH9KBxjnr4noQA6hZRFExrHBYhQx9ifXsV/9Jh8yxTVQ==
X-Received: by 2002:adf:a2c3:: with SMTP id t3mr23867253wra.223.1627391887323;
        Tue, 27 Jul 2021 06:18:07 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:06 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 00/17] selftests: xsk: various simplifications
Date:   Tue, 27 Jul 2021 15:17:36 +0200
Message-Id: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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

Thanks: Magnus

Magnus Karlsson (17):
  selftests: xsk: remove color mode
  selftests: xsk: remove the num_tx_packets option
  selftests: xsk: remove unused variables
  selftests: xsk: set rlimit per thread
  selftests: xsk: return correct error codes
  selftests: xsk: simplify the retry code
  selftests: xsk: remove end-of-test packet
  selftests: xsk: disassociate umem size with packets sent
  selftests: xsk: rename worker_* functions that are not thred entry
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
 tools/testing/selftests/bpf/xdpxceiver.c   | 635 +++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h   |  61 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 315 insertions(+), 421 deletions(-)


base-commit: 793eccae89bb495cfb44dceeaa13044160c49611
--
2.29.0
