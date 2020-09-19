Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB18327101B
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 21:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgISTD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 15:03:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgISTD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 15:03:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJi8j-00FPah-Md; Sat, 19 Sep 2020 21:03:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC/RFT 1/2] scripts: Makefile.extrawarn: Add W=1 warnings to a symbol
Date:   Sat, 19 Sep 2020 21:02:57 +0200
Message-Id: <20200919190258.3673246-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919190258.3673246-1-andrew@lunn.ch>
References: <20200919190258.3673246-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire that subtrees can enable W=1 by default. To make
this possible, put the extra compiler flags into an exported variable,
so other Makefiles can make use of them.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 scripts/Makefile.extrawarn | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 95e4cdb94fe9..bf0de3502849 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -20,23 +20,26 @@ export KBUILD_EXTRA_WARN
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
+KBUILD_CFLAGS_WARN1 += -Wextra -Wunused -Wno-unused-parameter
+KBUILD_CFLAGS_WARN1 += -Wmissing-declarations
+KBUILD_CFLAGS_WARN1 += -Wmissing-format-attribute
+KBUILD_CFLAGS_WARN1 += -Wmissing-prototypes
+KBUILD_CFLAGS_WARN1 += -Wold-style-definition
+KBUILD_CFLAGS_WARN1 += -Wmissing-include-dirs
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wunused-but-set-variable)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wunused-const-variable)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wpacked-not-aligned)
+KBUILD_CFLAGS_WARN1 += $(call cc-option, -Wstringop-truncation)
 # The following turn off the warnings enabled by -Wextra
-KBUILD_CFLAGS += -Wno-missing-field-initializers
-KBUILD_CFLAGS += -Wno-sign-compare
-KBUILD_CFLAGS += -Wno-type-limits
+KBUILD_CFLAGS_WARN1 += -Wno-missing-field-initializers
+KBUILD_CFLAGS_WARN1 += -Wno-sign-compare
+KBUILD_CFLAGS_WARN1 += -Wno-type-limits
+
+export KBUILD_CFLAGS_WARN1
+
+ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
+KBUILD_CFLAGS += $(KBUILD_CFLAGS_WARN1)
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
 else
-- 
2.28.0

