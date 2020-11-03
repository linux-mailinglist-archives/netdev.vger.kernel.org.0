Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F862A4CA9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgKCRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgKCRYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:19 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA096C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:18 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g12so19344730wrp.10
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5waWch5DfbeJ99kzw2cUqjwTl2DYjMssW5khvUSgq2w=;
        b=XX0MtFAeQlhIUtmtgoHO5iCXTIHz2Os0iBcD3sUghfWoSWX5C+SmEZvbZIjsOQgWZU
         GHs84xYTQsCSqUydkOVg5lKP3dpLjrau2DIra76ANaYt9eljZYNqXxtuz0Mha340jQyL
         5cO2LIk06IH8kH8VnOMZghYz2B9VCKcnZ1eVGXpjnWnqt2TOEtll7CbXglZ1SQhVbsnD
         V/+YaPY8oGugmGc4415yK2Bh+6OzWcV0iJuLIzgRx2nRReD075tdY3nTgRIMqjpsacZg
         ZzqmSiHVGQHqQQmC2a5xf2H8e/9WQSwX0vJf3nEWRit7wbo4twwef+084Kv20VNXT/7O
         Kmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5waWch5DfbeJ99kzw2cUqjwTl2DYjMssW5khvUSgq2w=;
        b=bnP6536i8tpvRFDfesiKKjugrOzR5nbnUbG3oOEXG/JHWGU+wMsAXywQKjKBvxtmF4
         HsqVrPxnhbJ5weIbqRHXUozTP030GQQ3YOvGGA6MqVhpNhcZ17S2rLHUKCHCchCTeMYl
         zEYFjL0ko0Snwpr9tgdj+otlp882oQVst+r1GXFhygo1uzQuFCQX0z1cu356B+dIRs2u
         //KQp+KNhzhrCovAFJ+kMVpl9kp8z0NWSVvxDrIeNPzRpU+46i1nTm1muKB8CtBTXz6K
         F4w7t0M7jpZeBKkhqopAULgM4c4WOK/BdBA8J85konNBW+s8yPNJwygGcmxaj1pDuV2Z
         LLIQ==
X-Gm-Message-State: AOAM531nSMjEWF1k4eF6ZXVA1mSekFM8LsFRINehapYTDsRmug+BMZTM
        5Y9MHrjpHBkdPAu7qywGrakKcHE0+KJLq/LV
X-Google-Smtp-Source: ABdhPJznn+N2QQIRpQ60Y58HrPFPLxs/vVEM4EdvO5ejGVW/FkQt+mUXKl61nWqavdx8oaZQuIHq4g==
X-Received: by 2002:adf:e650:: with SMTP id b16mr28248837wrn.350.1604424257147;
        Tue, 03 Nov 2020 09:24:17 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:16 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/16] selftests: net: bridge: add tests for MLDv2
Date:   Tue,  3 Nov 2020 19:23:56 +0200
Message-Id: <20201103172412.1044840-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This is the second selftests patch-set for the new multicast functionality
which adds tests for the bridge's MLDv2 support. The tests use full
precooked packets which are sent via mausezahn and the resulting state
after each test is checked for proper X,Y sets, (*,G) source list, source
list entry timers, (S,G) existence and flags, packet forwarding and
blocking, exclude group expiration and (*,G) auto-add. The first 3 patches
factor out common functions which are used by IGMPv3 tests in lib.sh and
add support for IPv6 test UDP packet, then patch 4 adds the first test with
the initial MLDv2 setup.
The following new tests are added:
 - base case: MLDv2 report ff02::cc is_include
 - include -> allow report
 - include -> is_include report
 - include -> is_exclude report
 - include -> to_exclude report
 - exclude -> allow report
 - exclude -> is_include report
 - exclude -> is_exclude report
 - exclude -> to_exclude report
 - include -> block report
 - exclude -> block report
 - exclude timeout (move to include + entry deletion)
 - S,G port entry automatic add to a *,G,exclude port

The variable names and set notation are the same as per RFC 3810,
for more information check RFC 3810 sections 2.3 and 7.

Thanks,
 Nik

Nikolay Aleksandrov (16):
  selftests: net: bridge: factor out mcast_packet_test
  selftests: net: lib: add support for IPv6 mcast packet test
  selftests: net: bridge: factor out and rename sg state functions
  selftests: net: bridge: add initial MLDv2 include test
  selftests: net: bridge: add test for mldv2 inc -> allow report
  selftests: net: bridge: add test for mldv2 inc -> is_include report
  selftests: net: bridge: add test for mldv2 inc -> is_exclude report
  selftests: net: bridge: add test for mldv2 inc -> to_exclude report
  selftests: net: bridge: add test for mldv2 exc -> allow report
  selftests: net: bridge: add test for mldv2 exc -> is_include report
  selftests: net: bridge: add test for mldv2 exc -> is_exclude report
  selftests: net: bridge: add test for mldv2 exc -> to_exclude report
  selftests: net: bridge: add test for mldv2 inc -> block report
  selftests: net: bridge: add test for mldv2 exc -> block report
  selftests: net: bridge: add test for mldv2 exclude timeout
  selftests: net: bridge: add test for mldv2 *,g auto-add

 .../selftests/net/forwarding/bridge_igmp.sh   | 211 ++-----
 .../selftests/net/forwarding/bridge_mld.sh    | 558 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 107 ++++
 3 files changed, 721 insertions(+), 155 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mld.sh

-- 
2.25.4

