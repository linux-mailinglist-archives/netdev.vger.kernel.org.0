Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B751761D1
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCBSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:04:15 -0500
Received: from mout-u-204.mailbox.org ([91.198.250.253]:65456 "EHLO
        mout-u-204.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgCBSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:04:14 -0500
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [91.198.250.252])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 48WSXV28YzzQlDh;
        Mon,  2 Mar 2020 18:57:30 +0100 (CET)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 48WSXV1TvtzKmkd;
        Mon,  2 Mar 2020 18:57:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1583171848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tXRVdT/O9gNAtLz27R5B8eXgmr9AIctUywabEBNSAEE=;
        b=b1yStrBmzLNk+BwKParPZigYo/OlmFqm0OewuNHujxDu6ULtEclZycA5JeYAkXsdGSvZua
        AkR8AuBKn3t2Mro6Yh5prmsRJyVykvDQhrMkQ0086eNQfBDjt4DrF84rgLKjj/MfOBzyw2
        2F9wG02yB+ht4bZFK5BX0zObBhkmRwqeE4wE0ZzwJsjMaEYdnkODTldv+gsDXyWDiGoRyJ
        He85Mw6FVsSjcd4V50mzXnk9iXEQBe6x5Be2VnfVyTY/JAJojzZybrOy4jeMv7ueIDfmHl
        MyuoTrp8bkImoC1rLbAGDYqHZTOLXYuPQC36D0T7+FI02rsaVC2IYt8yTE5C+g==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id EXx6i_5oHR4D; Mon,  2 Mar 2020 18:57:27 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net-next 0/4] selftests: Use busywait() in a couple places
Date:   Mon,  2 Mar 2020 19:56:01 +0200
Message-Id: <cover.1583170249.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Two helper function for active waiting for an event were recently
introduced: busywait() as the active-waiting tool, and until_counter_is()
as a configurable predicate that can be plugged into busywait(). Use these
in tc_common and mlxsw's qos_defprio instead of hand-coding equivalents.

Patches #1 and #2 extend lib.sh facilities to make the transition possible.
Patch #3 converts tc_common, and patch #4 qos_defprio.

Petr Machata (4):
  selftests: forwarding: lib: Add tc_rule_handle_stats_get()
  selftests: forwarding: Convert until_counter_is() to take expression
  selftests: forwarding: tc_common: Convert to use busywait
  selftests: mlxsw: qos_defprio: Use until_counter_is

 .../drivers/net/mlxsw/qos_defprio.sh          | 18 +++--------
 .../drivers/net/mlxsw/sch_red_core.sh         |  6 ++--
 tools/testing/selftests/net/forwarding/lib.sh | 17 ++++++++--
 .../selftests/net/forwarding/tc_common.sh     | 32 +++----------------
 4 files changed, 25 insertions(+), 48 deletions(-)

-- 
2.20.1

