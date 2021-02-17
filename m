Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919CA31DD6C
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhBQQdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:33:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:47626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234256AbhBQQdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 11:33:44 -0500
IronPort-SDR: k6QvVZ2MiOqRWe0RY+HOJQVvrJLoDvzcqaxSdd4L/SKD4Drz3cryT83BWvwOW4TZKvxmJZaC4D
 a/tnntu3fhZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="183315331"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="183315331"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 08:33:00 -0800
IronPort-SDR: C/qIPTxjLjaopDisyjZvaCXkiImZTfyo5SVs9COqNbmpZQ3jiTHLNHVKKrbA1ijWUAP0s8DreX
 rhd+0mgKFdTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="494184853"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 17 Feb 2021 08:32:59 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 0/4] selftests/bpf: xsk improvements and new stats tests
Date:   Wed, 17 Feb 2021 16:02:10 +0000
Message-Id: <20210217160214.7869-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to improve the xsk selftest framework by:
1. making the default output less verbose
2. adding an optional verbose flag to both the test_xsk.sh script and xdpxceiver app.
3. adding a 'debug' flag to the test_xsk.sh script which enables debug mode in the app.
4. changing how tests are launched - now they are launched from the xdpxceiver app
instead of the script.

Once the improvements are made, a new set of tests are added which test the xsk
statistics.

The output of the test script now looks like:

./test_xsk.sh
PREREQUISITES: [ PASS ]
1..10
ok 1 PASS: SKB NOPOLL 
ok 2 PASS: SKB POLL 
ok 3 PASS: SKB NOPOLL Socket Teardown
ok 4 PASS: SKB NOPOLL Bi-directional Sockets
ok 5 PASS: SKB NOPOLL Stats
ok 6 PASS: DRV NOPOLL 
ok 7 PASS: DRV POLL 
ok 8 PASS: DRV NOPOLL Socket Teardown
ok 9 PASS: DRV NOPOLL Bi-directional Sockets
ok 10 PASS: DRV NOPOLL Stats
# Totals: pass:10 fail:0 xfail:0 xpass:0 skip:0 error:0
XSK KSELFTESTS: [ PASS ]

This series applies on commit b646acd5eb48ec49ef90404336d7e8ee502ecd05


Ciara Loftus (3):
  selftests/bpf: expose debug arg to shell script for xsk tests
  selftests/bpf: restructure xsk selftests
  selftests/bpf: introduce xsk statistics tests

Magnus Karlsson (1):
  selftest/bpf: make xsk tests less verbose

 tools/testing/selftests/bpf/test_xsk.sh    | 129 ++------
 tools/testing/selftests/bpf/xdpxceiver.c   | 350 +++++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h   |  53 +++-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
 4 files changed, 309 insertions(+), 253 deletions(-)

-- 
2.17.1

