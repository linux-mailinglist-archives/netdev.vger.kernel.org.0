Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6713F71D6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbhHYJij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhHYJii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA836C061757;
        Wed, 25 Aug 2021 02:37:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so4122825wms.4;
        Wed, 25 Aug 2021 02:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCjailXWTklH+rl3mEefR7rVerhGQG4k3Be6UPNkS48=;
        b=NtC7ROG1OPkEPTTYr3Y5o7N8mG4bGG3uf2MAhl2XJn4PicNVVnQ+gwwqFcL1y9+RLw
         9jp42CrsxePe9MEy6nEaLHjCFtQ9hX5KP601XeGFsy/oEP+PA211bpgxdi9aiDZgOFjs
         izkYdBDnoS4YndmazFSc++CB8tZSYHl5aGoHqiBxvUjViH2bQbwh/yN+sFvuPp7b9Rcy
         boGjvqXGviir9I8hDmt5Jz0UPhmRtEdXYP64KSohHk9vb8oOkBv2Oegw0wAN1Xz8A6IH
         ssW399yvS2CgH3civGmMXNP/Q1oWL6qC/AFjw7KkFbz3XrPkcDmQqGNDZIuMe7p7BXhY
         51rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCjailXWTklH+rl3mEefR7rVerhGQG4k3Be6UPNkS48=;
        b=dy4AP9e+NuYIMColErvJPS3QjQfJHV+XHXNcVLHr7nK951+LgQ5Z5riOmMssydURKe
         bnbCxvq/YZZTxX9Ko9DkT23SbmCG0fH2pS6WY5roykb7LVIDn5hNjK82NNJ/FLV4HCdM
         SiOWAcyWSEeNhOc0lq+6nRZMcrsGjivcKmQ3341f4k2l1rakjglSlq0C+gaPAMzsBfU2
         qKnbjDP4WbtXsF93Ciq+v33PhvXTko0VqH2n2wivpZsXjMtOFOTcC6uiQ0Q26xNd22C7
         GYfTYcgIKArEu0dBQ5bfIc9MPvGo2B7M5yAnvTH+lH9BdIMZkJDDi2AmDQqtciYQgQlz
         2ujA==
X-Gm-Message-State: AOAM5323ej90KxBuEnh7sEoRxLHx0w8vf30XmSRQl0YCyjAtrpqAXw9N
        R+zLX8lUFtrlO7RWcPV16Fc=
X-Google-Smtp-Source: ABdhPJyKEMbUh2Lquw+70lXsBn7rLEuimt6xtmYX0J+42e+y6gRzbV+51L6xgcPJfPb66vlXoR0tRQ==
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr8463288wms.27.1629884271504;
        Wed, 25 Aug 2021 02:37:51 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:51 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 00/16] selftests: xsk: various simplifications
Date:   Wed, 25 Aug 2021 11:37:06 +0200
Message-Id: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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

v2 -> v3:

* Reworked patch 12 so that it now has functions for creating and
  destroying ifobjects. Simplifies the code. [Maciej]
* The packet stream now allocates the supplied buffer array length,
  instead of the default one. [Maciej]
* pkt_stream_get_pkt() now returns NULL when indexing a non-existing
  packet. [Maciej]
* pkt_validate() is now is_pkt_valid(). [Maciej]
* Slowed down packet sending speed even more in patch 11 so that slow
  systems do not silenty drop packets in skb mode.

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
  selftests: xsk: decrease sending speed
  selftests: xsk: simplify cleanup of ifobjects
  selftests: xsk: generate packet directly in umem
  selftests: xsk: generate packets from specification
  selftests: xsk: make enums lower case
  selftests: xsk: preface options with opt

 tools/testing/selftests/bpf/test_xsk.sh    |  10 +-
 tools/testing/selftests/bpf/xdpxceiver.c   | 681 ++++++++++-----------
 tools/testing/selftests/bpf/xdpxceiver.h   |  63 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 356 insertions(+), 428 deletions(-)


base-commit: 3bbc8ee7c363a83aa192d796ad37b6bf462a2947
--
2.29.0
