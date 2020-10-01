Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36527F710
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgJABMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:12:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJABMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 21:12:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNn9C-00Gzft-OE; Thu, 01 Oct 2020 03:12:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1 warnings for today
Date:   Thu,  1 Oct 2020 03:12:31 +0200
Message-Id: <20201001011232.4050282-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201001011232.4050282-1-andrew@lunn.ch>
References: <20201001011232.4050282-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a movement to try to make more and more of /drivers W=1
clean. But it will only stay clean if new warnings are quickly
detected and fixed, ideally by the developer adding the new code.

To allow subdirectories to sign up to being W=1 clean for a given
definition of W=1, export the current set of additional compile flags
using the symbol KBUILD_CFLAGS_W1_20200930. Subdirectory Makefiles can
then use:

subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)

To indicate they want to W=1 warnings as defined on 20200930.

Additional warnings can be added to the W=1 definition. This will not
affect KBUILD_CFLAGS_W1_20200930 and hence no additional warnings will
start appearing unless W=1 is actually added to the command
line. Developers can then take their time to fix any new W=1 warnings,
and then update to the latest KBUILD_CFLAGS_W1_<DATESTAMP> symbol.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 scripts/Makefile.extrawarn | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 95e4cdb94fe9..957dca35ae3e 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -20,24 +20,26 @@ export KBUILD_EXTRA_WARN
 #
 # W=1 - warnings which may be relevant and do not occur too often
 #
-ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
-
-KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
-KBUILD_CFLAGS += -Wmissing-declarations
-KBUILD_CFLAGS += -Wmissing-format-attribute
-KBUILD_CFLAGS += -Wmissing-prototypes
-KBUILD_CFLAGS += -Wold-style-definition
-KBUILD_CFLAGS += -Wmissing-include-dirs
-KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
-KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
-KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
-KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
+KBUILD_CFLAGS_W1_20200930 += -Wextra -Wunused -Wno-unused-parameter
+KBUILD_CFLAGS_W1_20200930 += -Wmissing-declarations
+KBUILD_CFLAGS_W1_20200930 += -Wmissing-format-attribute
+KBUILD_CFLAGS_W1_20200930 += -Wmissing-prototypes
+KBUILD_CFLAGS_W1_20200930 += -Wold-style-definition
+KBUILD_CFLAGS_W1_20200930 += -Wmissing-include-dirs
+KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wunused-but-set-variable)
+KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wunused-const-variable)
+KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wpacked-not-aligned)
+KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wstringop-truncation)
 # The following turn off the warnings enabled by -Wextra
-KBUILD_CFLAGS += -Wno-missing-field-initializers
-KBUILD_CFLAGS += -Wno-sign-compare
-KBUILD_CFLAGS += -Wno-type-limits
+KBUILD_CFLAGS_W1_20200930 += -Wno-missing-field-initializers
+KBUILD_CFLAGS_W1_20200930 += -Wno-sign-compare
+KBUILD_CFLAGS_W1_20200930 += -Wno-type-limits
+
+export KBUILD_CFLAGS_W1_20200930
+
+ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
-KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
+KBUILD_CPPFLAGS += $(KBUILD_CFLAGS_W1_20200930) -DKBUILD_EXTRA_WARN1
 
 else
 
-- 
2.28.0

