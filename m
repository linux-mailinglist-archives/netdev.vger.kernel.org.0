Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F891AE676
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgDQUHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:07:22 -0400
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:12773
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730573AbgDQUHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:07:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhAI4ttjLXvLvQLHkl9GIWpVs859y/jA8+G/Sx7bE9ViVV8geVwaUiW3H97BX/zPHopE2kDuLskzK4hyFu+A+Y5jvU2+iPQWtaJkecuwm8P1S1jRQat7S69BE6BOkDlWckFujUBvljTvErDFclDtVZXIFS+zuZQqhgTQTiUQqwHSPvdn6lxrKc9ZZizZXukk7FrgNfZUnyw0XqP6qgGWJvEeEpHBPcEw8ujbkxvF0DyXLqe6+iuSm18gxqsGbzVRm9lDz73KMp3ZSq0bb6U/9DLUqpPCkd7xDrJgNgLKTPeu2FwSeynttdMnrZQnq4QsbVMM76rBlVQ15htvk+pnnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GwEgSulrP4Nghlw8OO20TCr145kK9+j6WbLr7NlmcE=;
 b=Pmf6ef4aQut05fP6+PTCoJeYIg349cEIIRzh4rrOHWqwlJ6elrVoIjPqr6OqH2MMOipRIcOUdVZmLEm5H8Pele6DEwijtVbBnjOr9tfAVG/fVBd7wghA4BZBUkOjslLAPUzUBwFMl8+kHZe4Fbe4JXn0VJnZX2+w/lTdIZ0FayJgpoANR+WcDngjpI1K2CLPChsKO9bc0uw4+NwlVKy+bKyQgGmer6EEzdRK5lBpZ8BbhF+7WUdxG75RnDcy6A2rrsRQfNYGvrx7jjafOMK87Vq75+DxDhhtfBe7IsMfNls/b8OFnKeBGLbSZR1ipupjgoVv/6JbyvTXDZXYPmz0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GwEgSulrP4Nghlw8OO20TCr145kK9+j6WbLr7NlmcE=;
 b=t0sfYbthM9pfdUzthwGpjX5qEPJzfSVsOwK1aRH5gSWB5R4GwBej1P1jiYee+vtgl00cUVrpvuBc1dm90c3XZy5w9p8UOTHKR7i1WsUwRVLDzw7iriz15xgLqx5WOmuG4711H1mJtxLwW3cXNM5TrmqzZPwN9XJmniXLe/ekbwk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5917.eurprd05.prod.outlook.com (2603:10a6:803:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Fri, 17 Apr
 2020 20:07:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 20:07:16 +0000
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
Subject: [RFC PATCH v2 1/3] Kconfig: Introduce "uses" keyword
Date:   Fri, 17 Apr 2020 13:06:25 -0700
Message-Id: <20200417200627.129849-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0100.namprd05.prod.outlook.com (2603:10b6:a03:e0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.9 via Frontend Transport; Fri, 17 Apr 2020 20:07:10 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1493a089-ef3b-4bf2-be3a-08d7e30aebe5
X-MS-TrafficTypeDiagnostic: VI1PR05MB5917:|VI1PR05MB5917:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB591718CD85CCEF4F65BC1AD4BED90@VI1PR05MB5917.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(8676002)(7416002)(26005)(6666004)(478600001)(86362001)(2906002)(81156014)(52116002)(4326008)(186003)(16526019)(36756003)(956004)(5660300002)(2616005)(54906003)(1076003)(316002)(66556008)(66946007)(66476007)(6506007)(8936002)(6512007)(6486002)(966005)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SllO1p/qRzzh0x2F4yDWUf1hJCy5n4oP0BJYrYYBsZrJJMaxEC+j4qnVVrSmmQXNX/tXDC/ALjLYoqrBK7tbx+ktxZ2281jKWmCIshmSA2NMr+antHK5uUW/VfjSpiWVTtW9cb++Oa4WztPyvf/EcTBd1Y6M0Fgfjwebk1OV6WD0Nl8YYs+nstyDb4+66y7pOyvSLtpHsPgdh8Z2gUjYWLCcNTm0A/AK2vIQwrxWpH0rw6IWG8LTPmeHRBzHhi0HW9Vg5qlfAwEX2W+Vnop8WDIR8Lhv8tAJ/PJB2omEs0g7UakRamfVBB6sP9WA0jTbw7Chqcf+adR51mQaXL4qAd8k0kK39te1+nI2O1XL1SLT5J0WKcvqgcahSy/0pBJS45Q3hHLlaJW70JRg73eosbDWEENXYUPhZoTGRMSR4OOHAqBVcG+x1bscOQq1PMC+asKZCcstcmoF7B0UkYIpcN4SBsIf7oqb5Xh85GBNRUcRPcK9B5tqKJX9V8rFFAF3gGwVpwyDiK3Nw6/tgWGEa7e5Uv2F8UCAjHD56u8DldYgu7TEus1LFt1VFcN0GN7O2mnny4swvUgEg+lI/rU48g==
X-MS-Exchange-AntiSpam-MessageData: zKaOXgsJIKy0QS+qqr44jBQ/DTBHAMzAYIU1voG7lbnPjiREyyABIdiXhgQ5KRItNi+hokJRYIq2ikaie5yNxP0zncrZwPn75isnF16xYztSqjcV0SNoCSiTzfy+OhnpkEAvXaGW5J2A29TVWCWhPw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1493a089-ef3b-4bf2-be3a-08d7e30aebe5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 20:07:16.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDFlQ799+nlqI+IMtsJGZ5DL0nTwFBwIVGrf/rbz+Ki2AjOqBIqaBeTZ2J3S6kPeC8qdX0l3HhWzm+BW3ij7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the changes to the semantics of the imply keyword [1], which now
will not force any config options to the implied configs any more.

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

V2: - Fix double free due to single allocation of sym expr.
    - Added a 3rd patch to convert to new keyword treewide.

 Documentation/kbuild/kconfig-language.rst | 10 ++++++++++
 scripts/kconfig/expr.h                    |  1 +
 scripts/kconfig/lexer.l                   |  1 +
 scripts/kconfig/menu.c                    |  4 +++-
 scripts/kconfig/parser.y                  | 16 ++++++++++++++++
 scripts/kconfig/symbol.c                  |  2 ++
 6 files changed, 33 insertions(+), 1 deletion(-)

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
index 708b6c4b13ca..0356ecbaf87d 100644
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
@@ -418,6 +423,17 @@ depends: T_DEPENDS T_ON expr T_EOL
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
 };
 
+/* uses symbol: depends on symbol || !symbol */
+uses: T_USES symbol T_EOL
+{
+	struct expr *symexpr1 = expr_alloc_symbol($2);
+	struct expr *symexpr2 = expr_alloc_symbol($2);
+
+	menu_add_dep(expr_alloc_two(E_OR, symexpr1, expr_alloc_one(E_NOT, symexpr2)));
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

