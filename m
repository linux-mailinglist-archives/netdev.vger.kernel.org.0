Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF91AD3FB
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 03:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgDQBM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 21:12:28 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:6126
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgDQBMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 21:12:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjXz6/ZVqlUF+EofsHgGwTp0iRJM1h4aU19u7AeRLQL5B8ufcrzKfUKwDqlCmrnxy/AfWA5uRrcS+yj7IoFrWHEUIlggDT/ZC2PeCAJ7JGnebG8buNaQkF3pr+I/ABIojJ0Y54mmNbTK1dKig6UvuY1X3zUMdEMUsqdZNWr8gSMeC0TigMhbDTSmGIwMfvA0uzprnAxCUAbBkZW8MD+mKj9zfTpRgWKZTL2aqbenpxy/ulT0pw13oG9ZEUlQUAbUJh5KSqooJu4jFV85dIjWG6Yq+XHUqHhbm1U26unaH9n4V7NE/Z91JakWz8Y0xz9WKa7wu5wvuYQJqXUgiAcUEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKcO74LyHepa6b+2cACzDbUQkFCy/yrHXhAejZAEkM8=;
 b=XEbnGnUTrfNLZ6QSBL3zza5LwybfEOoyfyZ0YiMm867QewrG2P4tkjXLiG7iO7uHYzGEURUA0gQDYEw3LhqYihjx++EQuqGNGWy+mM6TQI3spRAtznEVNIizkLvxuWtHR2UasBb7tCH5I6y4S75AULl9Zeb6R5nG6zI31pYGLlUki/kR4J4n9FL0YCFUmkMRHUeuhQB8TkrJWOzEKhubdEHvCRiNqJEjp8qhZXwSsVYtEi72d3UGj5VQlMkJrkJOB7TonozRARzaIU2GGiqsC+1lSsKnKT+VwU5shO/NMHL+PmzwKbJWi9fQZYpk/9h9uOgB8xx9Zt9rvKYmvE6mOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKcO74LyHepa6b+2cACzDbUQkFCy/yrHXhAejZAEkM8=;
 b=XFCYqCJG0vT1Q7ppYbjw+kj8M1EyqwA+fV75AMA7Z77U1TrRL4w5Ztr8TfhHxyb4QOBMApthPU/ab2YCbUMNS8BqSjHZl/1W14OVznkVEF1xX/A7aH5WLdIZBR5a9HayEq2lzdEMljFa2UF2p5SaZQ0J8Urft+xZTRMJc9ffHDQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6237.eurprd05.prod.outlook.com (2603:10a6:803:d8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Fri, 17 Apr
 2020 01:12:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 01:12:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, leon@kernel.org,
        kieran.bingham+renesas@ideasonboard.com, jonas@kwiboo.se,
        airlied@linux.ie, jernej.skrabec@siol.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Date:   Thu, 16 Apr 2020 18:11:45 -0700
Message-Id: <20200417011146.83973-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:a03:117::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0041.namprd08.prod.outlook.com (2603:10b6:a03:117::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Fri, 17 Apr 2020 01:12:16 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 294d7ada-5e3f-4669-67b3-08d7e26c6097
X-MS-TrafficTypeDiagnostic: VI1PR05MB6237:|VI1PR05MB6237:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6237AFAD4DDBC5BD585D97C0BED90@VI1PR05MB6237.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(966005)(4326008)(6512007)(316002)(66556008)(6666004)(86362001)(54906003)(26005)(66476007)(7416002)(6486002)(478600001)(36756003)(186003)(1076003)(2906002)(5660300002)(52116002)(16526019)(66946007)(8676002)(956004)(81156014)(6506007)(8936002)(2616005)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mAnNW2zm100S9L+yY+PobH7atlyV0zqjjIAVUdyugq4rMih65Ycga3HDDmRSkMiT6ptzlwnUBHsikijSXP5djma7+9J/Ql6WAW/Bpqkr2i56wcolBdNfZQqi0TMpoXA+tr16PhBFW706r6lAph/1xSlzRZz0HbKEQKXZSeSegD5AM8/ZixG6kxMo+dtV4XxFlyKTZMvDjzCGvLxBp5CkMiaXeoM3BZ92GaTD17ejwNcG/tNFE4j7v74FEHpgFVHUohWgpdg4kWkm/vbuW28jYcQUeTBZPQrfdGwqEBntdyxSUFUPB0mdpCeE6aAi+fkRMRf8aTJlyFHZIWtHtMhNlrWjUsCXZ0T3A7bf3dw/AmqqoW8iJdh2jmP8uxfk0Nuf/h2apeo1B55a160SR//56ORSbXFCj1IC26C2E2jshTs+NxK2N3Uvgs+IRSBX58Qg0EiDEkKXZL0kadlfKKk+3q/VgYip6RC9OmWA4t8yYheAzGZMcJjaYktRqBO/nkgs2urOlcLkIlE6iQ93GBEFzjkAD/NpsoXs0yiH5nfiHJ/GzsgQ2ebKYuqTN6B8OWmheEzfpok3DwiGx0ArnhWuzA==
X-MS-Exchange-AntiSpam-MessageData: Wei2iZ2mfLvGeCzZKzLhDTDjDOfjqcyheR6htXKTxYeNuuPZaFUC4hoStlPXGpaiY1k19q7ar0EEaFO7zn4e5yDkTOm4YYJ7dmH46QIs4D/C8v/YLxcCzF5ZmT312YSxmC53kcB6t5aPM8l8POe4qA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294d7ada-5e3f-4669-67b3-08d7e26c6097
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 01:12:20.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnhA70Drt5q0fctTj03b5t2Lh0X4FxenDvI7vIcUR89hbGTxsQQgX3fv/vzwRd17hQTrY5Zgs7gtlVn2Yq2hpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the changes to the semantics of imply keyword [1], which now
doesn't force any config options to the implied configs any more.

A module (FOO) that has a weak dependency on some other modules (BAR)
is now broken if it was using imply to force dependency restrictions.
e.g.: FOO needs BAR to be reachable, especially when FOO=y and BAR=m.
Which might now introduce build/link errors.

There are two options to solve this:
1. use IS_REACHABLE(BAR), everywhere BAR is referenced inside FOO.
2. in FOO's Kconfig add: depends on (BAR || !BAR)

The first option is not desirable, and will leave the user confused when
setting FOO=y and BAR=m, FOO will never reach BAR even though both are
compiled.

The 2nd one is the preferred approach, and will guarantee BAR is always
reachable by FOO if both are compiled. But, (BAR || !BAR) is really
confusing for those who don't really get how kconfig tristate arithmetics
work.

To solve this and hide this weird expression and to avoid repetition
across the tree, we introduce new keyword "uses" to the Kconfig options
family.

uses BAR:
Equivalent to: depends on symbol || !symbol
Semantically it means, if FOO is enabled (y/m) and has the option:
uses BAR, make sure it can reach/use BAR when possible.

For example: if FOO=y and BAR=m, FOO will be forced to m.

[1] https://lore.kernel.org/linux-doc/20200302062340.21453-1-masahiroy@kernel.org/

Link: https://lkml.org/lkml/2020/4/8/839
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/kbuild/kconfig-language.rst | 10 ++++++++++
 scripts/kconfig/expr.h                    |  1 +
 scripts/kconfig/lexer.l                   |  1 +
 scripts/kconfig/menu.c                    |  4 +++-
 scripts/kconfig/parser.y                  | 15 +++++++++++++++
 scripts/kconfig/symbol.c                  |  2 ++
 6 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
index a1601ec3317b..8db8c2d80794 100644
--- a/Documentation/kbuild/kconfig-language.rst
+++ b/Documentation/kbuild/kconfig-language.rst
@@ -130,6 +130,16 @@ applicable everywhere (see syntax).
 	bool "foo"
 	default y
 
+- uses dependencies: "uses" <symbol>
+
+  Equivalent to: depends on symbol || !symbol
+  Semantically it means, if FOO is enabled (y/m) and has the option:
+  uses BAR, make sure it can reach/use BAR when possible.
+  For example: if FOO=y and BAR=m, FOO will be forced to m.
+
+  Note:
+      To understand how (symbol || !symbol) is actually computed, please see `Menu dependencies`_
+
 - reverse dependencies: "select" <symbol> ["if" <expr>]
 
   While normal dependencies reduce the upper limit of a symbol (see
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 5c3443692f34..face672fb4b4 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -185,6 +185,7 @@ enum prop_type {
 	P_CHOICE,   /* choice value */
 	P_SELECT,   /* select BAR */
 	P_IMPLY,    /* imply BAR */
+	P_USES,     /* uses BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_SYMBOL,   /* where a symbol is defined */
 };
diff --git a/scripts/kconfig/lexer.l b/scripts/kconfig/lexer.l
index 6354c905b006..c6a0017b10d4 100644
--- a/scripts/kconfig/lexer.l
+++ b/scripts/kconfig/lexer.l
@@ -102,6 +102,7 @@ n	[A-Za-z0-9_-]
 "default"		return T_DEFAULT;
 "defconfig_list"	return T_DEFCONFIG_LIST;
 "depends"		return T_DEPENDS;
+"uses"			return T_USES;
 "endchoice"		return T_ENDCHOICE;
 "endif"			return T_ENDIF;
 "endmenu"		return T_ENDMENU;
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index e436ba44c9c5..e26161b31a11 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -274,7 +274,9 @@ static void sym_check_prop(struct symbol *sym)
 			break;
 		case P_SELECT:
 		case P_IMPLY:
-			use = prop->type == P_SELECT ? "select" : "imply";
+		case P_USES:
+			use = prop->type == P_SELECT ? "select" :
+				prop->type == P_IMPLY ? "imply" : "uses";
 			sym2 = prop_get_symbol(prop);
 			if (sym->type != S_BOOLEAN && sym->type != S_TRISTATE)
 				prop_warn(prop,
diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
index 708b6c4b13ca..c5e9abb49d29 100644
--- a/scripts/kconfig/parser.y
+++ b/scripts/kconfig/parser.y
@@ -57,6 +57,7 @@ static struct menu *current_menu, *current_entry;
 %token T_DEF_BOOL
 %token T_DEF_TRISTATE
 %token T_DEPENDS
+%token T_USES
 %token T_ENDCHOICE
 %token T_ENDIF
 %token T_ENDMENU
@@ -169,6 +170,7 @@ config_option_list:
 	  /* empty */
 	| config_option_list config_option
 	| config_option_list depends
+	| config_option_list uses
 	| config_option_list help
 ;
 
@@ -261,6 +263,7 @@ choice_option_list:
 	  /* empty */
 	| choice_option_list choice_option
 	| choice_option_list depends
+	| choice_option_list uses
 	| choice_option_list help
 ;
 
@@ -360,6 +363,7 @@ menu_option_list:
 	  /* empty */
 	| menu_option_list visible
 	| menu_option_list depends
+	| menu_option_list uses
 ;
 
 source_stmt: T_SOURCE T_WORD_QUOTE T_EOL
@@ -384,6 +388,7 @@ comment_stmt: comment comment_option_list
 comment_option_list:
 	  /* empty */
 	| comment_option_list depends
+	| comment_option_list uses
 ;
 
 /* help option */
@@ -418,6 +423,16 @@ depends: T_DEPENDS T_ON expr T_EOL
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
 };
 
+/* uses symbol: depends on symbol || !symbol */
+uses: T_USES symbol T_EOL
+{
+	struct expr *symexpr = expr_alloc_symbol($2);
+
+	menu_add_dep(expr_alloc_two(E_OR, symexpr, expr_alloc_one(E_NOT, symexpr)));
+	printd(DEBUG_PARSE, "%s:%d: uses: depends on %s || ! %s\n",
+	       zconf_curname(), zconf_lineno(), $2->name, $2->name);
+};
+
 /* visibility option */
 visible: T_VISIBLE if_expr T_EOL
 {
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 3dc81397d003..422f7ea47722 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1295,6 +1295,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "choice";
 	case P_SELECT:
 		return "select";
+	case P_USES:
+		return "uses";
 	case P_IMPLY:
 		return "imply";
 	case P_RANGE:
-- 
2.25.2

