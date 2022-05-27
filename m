Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CAB536828
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351978AbiE0UiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiE0UiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 16:38:08 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150058.outbound.protection.outlook.com [40.107.15.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F31213274A;
        Fri, 27 May 2022 13:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PErZTFrFl7ePUOygzCFhowv29nA1Beo/cx8jm0DU6kSNMz/tcpL/UUn+9+K/gUd/AawzhEQXazUH8fnsblmSeNz4eHLLC42YhGQy+r30PH9T9hoOKj9Tz8qxaX07w7dBHm6AIwc/b0JprJXPY49u+R27dqTdVcUOu4mr/knyMNVCXk7PfcfDKMbEyWSYNyOLsCmaM74jcJWCWV0kmqAZXphInlhA95E7kBXI1HOOAm4PVfbg/nmwHU2fMsM6iu8gMPRXDzgKwQSNnlorrmRveKj9VaBIRP1mbX5/h9xffmZf9SHqS1+GWyIgkRyW8YtfyF2Ba2Pi0q4AcLYeigiXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRcH+ZmE5W9Vc10LDeQGMmpbV4BLIkGkSWz4na06TyU=;
 b=Gk2cVCLiYjvI++ge6n67H7bWL78DrSzykMIGyYwndYfyzpAU27nSLbausH02BUYJ2QAxSnOxh9eepFCQ7OZQajDoeJ+E+J4QgZPDxYeFwt9fFXtmqD7rf4g1db48R0kGXGtIGSUgYbi4gPNMzzdBUymGM7rVX0nil6vQDAlaX2znbEqgG3YaM9RDfAvG3v2uhkBNhboIA63wgpAVgjLYBa7CpiVjkJi9/ABW+NMQ+wXTxHt7lIKCn9z/X2JmvG62ifbM58HrEmir2U5HQUAVTVgJWq05wC8CuhPEAedqpuIyxhUafR3uvSSOApAHeg4+vDDqFOdaBLIilYt0QPwTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRcH+ZmE5W9Vc10LDeQGMmpbV4BLIkGkSWz4na06TyU=;
 b=FeSOgDUDxXzQzV0voy7dFiGK8QrCAwDRBC5A9kSBoHQ+bVVCzSNprpYBqlquJaMvJ4KQACGURvCrVNiLDw8vTERcPoLVzCXL/T2/j9rsJecYzQ9ia0BRJS1GWR2CUZ6ITLVdr+64gMLR8SSv+WXrmgbqES0GzRt5YTDhAv8BG4LJMwgbTg/ZhBedO5Qd3t8AuwjVvztou9ejFFwMz79J7f3bUU5Y5eZs8I1/Sj5/ybzvBD/f/fiZxNK9QhdkvcFl8mmPfC/worhs++ZSE80d5SVTaS9zRfHKgE45mu+6hA2xHmW8pVHZDGLxIyuVO9qx2bha7FkzZlH1+vB/hr8Fcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR0302MB3377.eurprd03.prod.outlook.com (2603:10a6:208:b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Fri, 27 May
 2022 20:38:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.013; Fri, 27 May 2022
 20:38:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] net: dpaa: Convert to SPDX identifiers
Date:   Fri, 27 May 2022 16:37:47 -0400
Message-Id: <20220527203747.3335579-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:208:d4::45) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2410d06f-8637-451b-d73a-08da4020cbac
X-MS-TrafficTypeDiagnostic: AM0PR0302MB3377:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0302MB33779D35DB9A2AC8D84AA7B096D89@AM0PR0302MB3377.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QT4EL+nrtKrReL5sQhwWSQFLXZe7WTEPLWCvt7C8uCqTi8+Z7BD4V75tZbzdJZgb6Kvd8jokf8WT4fd5VvNyQCk/1W5IUc+WzX+QbYVv0VI6RZEeSeTJxOjQdjtkze8Ici/Fe0yxCWBoYMzPrctwW7TXjxuaxu+d1jAPqLAJVhzfqL0G49pv7aW1DKlgVjfVL21Q1KkCWY8APupaHDhoAepVfZOKN94v4RIBYA1174eS3P9j+zjwjL8t1fnzpV4avZ7LXXeGXqJ+CiU4TmatmKFTnMiP6wRev36qiqC+3/6dVTTVr32G314vsa5Ctsf7hYikhfifgN0aVm8cCBxcYv6JqPbpb631g4e+lw+l/ZGlBKoXET6D5NVm33LRrxBUELjwTUqLxKRwrrIZEl6mYPZnowIVLREtUeDhe2s3N5Uvk+Wo8IqtiIz0KpvHKRynEXM6zMl6I0pvmSlseg58h2FRwgEi+7xYTD3w2vE0a9AUj33hU5J4mxfV5Qm6GgB7GkDq8RW5tuQC924fSRGU0NV0PVo1BC8MfR84C2NPfSD5a4A06qmjboRp6uysVnwlQ0g7lVOSJ+8+UlK+DoeVHXVeFpNHX/kG877p4u8is7Mj+ckVd/JPyvWaotqnHPhybCj6WSwchMMrK22CIgPS+ZUPl5g3rC8oJY/gr0YTDY3WwqRE35ZiRRMGXZ0e1HeMowJjoV4AtTymRRS1xXdBwr1VpD76bAZiG5JSYmSHtsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(107886003)(110136005)(54906003)(2616005)(83380400001)(66476007)(38100700002)(1076003)(38350700002)(5660300002)(6506007)(6666004)(86362001)(316002)(8936002)(44832011)(30864003)(2906002)(36756003)(6486002)(186003)(508600001)(6512007)(26005)(8676002)(66946007)(52116002)(4326008)(66556008)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TAuYGw9zsbsvaD4gID6yR2eMLKFDam2xHqlIquXYy302LSgHu8DA9974K4I4?=
 =?us-ascii?Q?awizEjwPbrjoRtU5hu5RNR+WK9ME8so8/kOvm4PCGVmelMudmb3zNocOfXNz?=
 =?us-ascii?Q?oxYWEIqxwa6U2Wbz8/pDZjpYaRwvMhRII3HfRg4v4BwZa9IbcxPk/rVnwNzK?=
 =?us-ascii?Q?mA3XPSLGBUWkJzHiX1skpVKew/GIBQ/oWqcSVx7vcjderZaI1hwWb51eEEvH?=
 =?us-ascii?Q?eLtuyDNNfmp3z9c21u0uP6FxzvtercmC5IOvtBtjfp61/kByTQuX2kDDUQ8K?=
 =?us-ascii?Q?ugeFkggpdaPIUnRu4gJ2U+UvxM9GbOaRXslkE+UVcLn+NBiXPGPdk1iNC0/l?=
 =?us-ascii?Q?XSD+b2MiRUYwwrARBfIoazZmA2LI24aAiJVL2WkV5Kk4M6r4bWebYe3yCgjA?=
 =?us-ascii?Q?Ls+QQBz/GUZaBTYWwT3XIA3PPDOewfNjXfcKI+dn01irx80++gosfOURFd9j?=
 =?us-ascii?Q?RKNB1HPeKgrJhNIVMer2sKY6V44P7oHXoNPqaFrSh1sv7M9jucTIdLQksTw4?=
 =?us-ascii?Q?X6S5UtrSiYelDLV9RxxcZWyfVGXHSywTnLPueKwjB+wJDw+urU5N65pWs9TB?=
 =?us-ascii?Q?5RpTV6c9NYzQanPcB9IlobcziG3AnRuNdtrRBQ3h5cD/p5DMHoP8XPO2NIQa?=
 =?us-ascii?Q?fEK7nijXjoMUYL2nwExYIp3cZBokQDrYnGIx8oaQSxut5dSgOe7wBz/MwmtH?=
 =?us-ascii?Q?YoXyKLbFf/7AkZTI2ucp6aa4vMDvf+x63NGFctG7cTgMclM8YyjIZ2D+pzxR?=
 =?us-ascii?Q?G7dUASHKEmQQ2H7kq2MizzvxykvlZu6cWdDuwqdpzB+xAi7WtTie/s5daVI9?=
 =?us-ascii?Q?ZA1iq4kVgMjKw12u00GMoAou7477QrZjBigarevGhACqCFKR2wmrPgvlpcnx?=
 =?us-ascii?Q?J8/krjZgTSdMvxAf4TipOfYTxv2iEq6DiEBGVOtFIcsfAk71gL1GBEjjdCnD?=
 =?us-ascii?Q?XoasoejtKqTwxWEJmDx5FQKd1nDC9mctCude1cNydH5WarpHMC7TFAUzg64f?=
 =?us-ascii?Q?+/AXjTe+/4VwyswMlprtBvskqOXIj8W4LqJBhgg/oVopyPzpq7lEPTMzOp+J?=
 =?us-ascii?Q?l/wtlyl7QAKDyduSphFJbvbkpNlHT4tW3y+Ywpi4M3+BCYw7fkMQ5A/z2NTm?=
 =?us-ascii?Q?Zzfqw6Fw+Xa8Z+adFak3KDY4JtgiDTz/kiv6nLQdatmZRaWLyIxZBPcwfwUu?=
 =?us-ascii?Q?/PjwFFdzxRSJJzr3PIPtkYZFPjC97xm1ds507qt3rq/gAAnIryEH8STd8nIi?=
 =?us-ascii?Q?BA/QcPDFgSrIcFgpVjMF0VJdC9llawjRSkTo4jXfspWPrAXqMh4z/zmjB0yu?=
 =?us-ascii?Q?p2Q36qBLFbuXYkBVQfSNvaiAS1txDWac6ryexdzrnKIN52AzjrrW9bCpnqX3?=
 =?us-ascii?Q?w7GufMCPFYuNI4C1UJHKG0u9b4bNmuFgm7PalzYDBFlA6mGog2fnuBwPYr/0?=
 =?us-ascii?Q?W93Bv3at1i4doDBMk7VAit54lGMOSA/J4YH9L1j7DKh78Gpc0g/nK5+b4b5M?=
 =?us-ascii?Q?9BDX82itvoFvUTL8rJwtPrYd8LUBvgiLeubIeL68Obrv++4hR1OIN9elf/pp?=
 =?us-ascii?Q?sIO4hyLIKZIur4bktSKLtA/uM4t121K/1ln0EkR2Qs/VAflQHWt3oEEevAdR?=
 =?us-ascii?Q?4rHZAyNnx+yiKxrF1iNNdMX+YvGzsBIUldtaZzGsxyG4wH4RUlPt14AnvPsX?=
 =?us-ascii?Q?zfkkPSgRL2OL6ZI732bUyD5Vf2QRNvNRMLxwTWbxOrjUG83eKdi+jHGetdkl?=
 =?us-ascii?Q?uqFeIKvufew0DYsWjUjZsvFkaK/LN8A=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2410d06f-8637-451b-d73a-08da4020cbac
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 20:38:02.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: or36gKpblTvr2nRFvNrbwFsQQ8mXoYbZT9kMrflAycgdVTyy3OXbZVEBCG1r2StlnD7sMazky5Q9cZMr7FqUrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3377
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts these files to use SPDX idenfifiers instead of license
text.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 31 ++----------------
 .../net/ethernet/freescale/dpaa/dpaa_eth.h    | 31 ++----------------
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  | 32 ++-----------------
 .../ethernet/freescale/dpaa/dpaa_eth_trace.h  | 32 ++-----------------
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    | 32 ++-----------------
 5 files changed, 15 insertions(+), 143 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 685d2d8a3b36..906d392da4e3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1,32 +1,7 @@
-/* Copyright 2008 - 2016 Freescale Semiconductor Inc.
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * Copyright 2008 - 2016 Freescale Semiconductor Inc.
  * Copyright 2020 NXP
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index daf894a97050..35b8cea7f886 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -1,31 +1,6 @@
-/* Copyright 2008 - 2016 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
+/*
+ * Copyright 2008 - 2016 Freescale Semiconductor Inc.
  */
 
 #ifndef __DPAA_H
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index ee62d25cac81..4fee74c024bd 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -1,32 +1,6 @@
-/* Copyright 2008-2016 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * Copyright 2008 - 2016 Freescale Semiconductor Inc.
  */
 
 #include <linux/init.h>
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
index 409c1dc39430..889f89df9930 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
@@ -1,32 +1,6 @@
-/* Copyright 2013-2015 Freescale Semiconductor Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later */
+/*
+ * Copyright 2013-2015 Freescale Semiconductor Inc.
  */
 
 #undef TRACE_SYSTEM
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 5750f9a56393..73f07881ce2d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -1,32 +1,6 @@
-/* Copyright 2008-2016 Freescale Semiconductor, Inc.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *	 notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *	 notice, this list of conditions and the following disclaimer in the
- *	 documentation and/or other materials provided with the distribution.
- *     * Neither the name of Freescale Semiconductor nor the
- *	 names of its contributors may be used to endorse or promote products
- *	 derived from this software without specific prior written permission.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * Copyright 2008 - 2016 Freescale Semiconductor Inc.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.35.1.1320.gc452695387.dirty

