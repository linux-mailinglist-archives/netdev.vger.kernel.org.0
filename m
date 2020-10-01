Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D6127F714
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgJABM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:12:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgJABMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 21:12:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNn9C-00Gzfr-Mz; Thu, 01 Oct 2020 03:12:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC PATCH net-next v2 0/2] driver/net/ethernet W=1 by default
Date:   Thu,  1 Oct 2020 03:12:30 +0200
Message-Id: <20201001011232.4050282-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a movement to make the code base compile clean with W=1. Some
subsystems are already clean. In order to keep them clean, we need
developers to build new code with W=1 by default in these
subsystems. Otherwise new warnings will be added. To prove the point:

commit e666a4c668528ae1f5b8b3a2e7cb6a5be488dfbb
Merge: d0186842ec5f d0ea5cbdc286
Author: David S. Miller <davem@davemloft.net>
Date:   Fri Sep 25 16:29:00 2020 -0700

    Merge branch 'drivers-net-warning-clean'

    Jesse Brandeburg says:

    ====================
    make drivers/net/ethernet W=1 clean

Then 4 days later a new W=1 warning has added:

drivers/net/ethernet//chelsio/inline_crypto/ch_ktls/chcr_ktls.c: In function ‘chcr_ktls_cpl_set_tcb_rpl’:
drivers/net/ethernet//chelsio/inline_crypto/ch_ktls/chcr_ktls.c:684:22: warning: implicit conversion from ‘enum <anonymous>’ to ‘enum ch_ktls_open_state’ [-Wenum-conversion]
  684 |  tx_info->open_state = false;

This patchset refactors the core Makefile warning code to allow the
additional warnings W=1 adds available to any Makefile. The Ethernet
driver subsystem Makefiles then make use of this to make W=1 the
default for this subsystem.

v2:

Address the comment that we need to be able to add new W=1 compiler
flags without actually causing new warnings for builds which don't have W=1

Andrew Lunn (2):
  Makefile.extrawarn: Add symbol for W=1 warnings for today
  driver/net/ethernet: Sign up for W=1 as defined on 20200930

 drivers/net/ethernet/Makefile |  3 +++
 scripts/Makefile.extrawarn    | 34 ++++++++++++++++++----------------
 2 files changed, 21 insertions(+), 16 deletions(-)

-- 
2.28.0

