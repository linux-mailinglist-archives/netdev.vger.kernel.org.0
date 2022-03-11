Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9444D5FF0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiCKKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiCKKod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42912114FFF
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E638f1OEdnBCmu+JHoQHYxBQUP0Nn4RlkgrKl4nm6jn5EN6O6kbYVhqIVBkKWkyVBNmDOy3QYDkUncOQR3J1kWJBw0PLDl9EQ8W84cHnpX080hxEHF+18zNIqm9pusQNthphdcdGlo80ZFY1IcD3i6xzjA+eCbFcfrrQXWXXSNyKqQcqWESKxa2H86IJlRKRxWpu/rNvIycyOJWgHlp604rqt95+0rtMUHtaV24aO2pp8shZTTTAPsDpVvfLKI846H47w9ErC5OvHcKx/DloTudYuu/pIIAqCiGxO9nKlu944dhPNtbey+avFrNZF7JaPs8aSqSqacZWX+xbONZEbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTrMvmXZciFiJ0meergVtZ3qnpAvTgktw5R6qnSy8lY=;
 b=BlJGWeIl5lksUbCHOujpATWrqvctH+Q7ncY2kz/xpZEVyKAJDJvXBxiq2BuPrPIuiEMVk/8vGGZ8KgV5jVCUCV6/l4EhF6bTJ7BCfx6oZjLhblCDI2ZNVC3EUY+gXDSuJrnuYtVeeZQ92ZnCPXgcjXd+iCqtmvoKJg80P6/GfDNMSn1WlG6aMAR7r9YiOKviz+/703brUpg0LmgqrVZ6M16uBbmiQHw47jnhY9mlqr55ELREQryzA1MJWYo4C0LewMjYnTwE3tBZB1IGiO+YE6Ip3SwQjw3nZkNDGbpeNamMOo3F6BBTbEOKoIgH3EwAOwt2kAxMrFZndXvpLclHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTrMvmXZciFiJ0meergVtZ3qnpAvTgktw5R6qnSy8lY=;
 b=DbhEvQG9RBEA7SV98vUN8gKKHPHf2MEWQC5ywFfQzLxYs5ctNa+SYWFpIab+A7ZUpmliMoCthsV0KydS1sBBFnVrSXZftIwVaFPy/5OzOVganC8a4UrfTAtQ3zy4j3PyWAqnw6XdL2icVha9pGJN97B5sLkmc8dRNGdPb92QcHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 02/11] nfp: remove pessimistic NFP_QCP_MAX_ADD limits
Date:   Fri, 11 Mar 2022 11:42:57 +0100
Message-Id: <20220311104306.28357-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0642eb92-2a88-4b16-bd4e-08da034bf7e5
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1184143AA6C0C51FBEB1ECD7E80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AxHfpwucCpOtk1ULtVG8Fg24kcvfiXhwTpKZpnu7j4ONZcvXR1PghEdZvcR1a4iZXjvEnqhUyRNYs5MBFg8eEtywgPEU106sw7r2kbo1uuo44w8Fj5n7wg0SG4Wv/yOWsqsJFJgt58yp7PYi4QBd5kYqIErDOxhG3T5D5jRIb/BJHUEsdHUzpNgEgzZ8mbLKj6DOvol1Ldycb2JX2udmosfK7LO2n1hAIpW6raBGWcDPahTFT3c/HjB/vj6tYKRA3Cl+dyG+MpKqcogkKMYRPk458Ml7mDT2StExGrDCLmbo7ApQt/FKfPx16uOBYayUZW5rpHLBFr2YnjryTKIho7CrHuk8RkcA0oIMeNymkTpbLnqHJHMnYIQsXQZeBYaSwlpdtzSU1f9I+c52v9DmHF88oMevPagh4ErpZ2jRLVQHGmGQrVSfhOBUFv2RghsrSf4GSGvisEscyLl+XIpv/Ln+kdLTwNmshsvK14rlog6buXyksDjMGdc1YE90XAGX8ZQVoP2ExFxzLrK+dlyNTddoXG88Y5eSyAROZeyCHpIieYKaq+H9080ikFQoQPji1pFYLmn1bgIYB6hNWYDxM/jX+hwoaaStZj3Tg7ukssCQVX1JBCh5jjTXJUifddOk2A45Nss4HtmwhywnujycYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GVw/lzpOw1GhAydnPtHW1JSRcCwZM7LVoiG4zuFnIrt4RrI0uR/b9KPgd8ur?=
 =?us-ascii?Q?EuDXY6bcQO67Lx+vMTE2tNZjaQ7zwCg3yLteUxrCeFoiDRVXCVqjw0310ODy?=
 =?us-ascii?Q?dtJHFbgQMmlG0FppIwcRs9RW6o7VSMuSVFtLgkujnndbwhlaAgb36BZqLd07?=
 =?us-ascii?Q?ZFL7migqORkmrQogHGBb2qZDj+AoeKcc/4n2bbNhE5YcUXsZG8QHw68F6Gfc?=
 =?us-ascii?Q?ImgfaajSZLgPT44+x2IzdBdHe5JX/DSXDd5cq6fD/RLUrhBZ2ACWjLRYhFIG?=
 =?us-ascii?Q?5xrwZ3n+rhb/4TKRQ6Ir7okVNhCjghnvfVu8Qpjw0AzCHLINqQZU1azjMqgZ?=
 =?us-ascii?Q?Ux7GYm37Z36GLFeRvEQC/B1xUFc0EjhbES8GT6eib75tQPKJ51OPrmnUIsmT?=
 =?us-ascii?Q?2fF7PaAPy2dapySa+FaXdqOKTPhOyFvIa+ESGkTOfBQCgX6sS7gFkmUag0Xe?=
 =?us-ascii?Q?0ZIcxu9C5792yVjOf3eoZPnP7EX2WQKQLGoyhmwWi66vG30MHCXdZ6lLouqs?=
 =?us-ascii?Q?ii/X177HZQcrhw0kyZFXwsJzuLT1vlznLkQahp/Z8HorwjcyAde9sQ0VA2tx?=
 =?us-ascii?Q?6LX5H+mqKWPPE5VpMXIjZxmluyX6c1Fy4pUbICL63WbH2Wuo5Ashx4UUxsRe?=
 =?us-ascii?Q?ITrguho86CyZpkrJVbWKyh7v2jn2eeJNN6TjXPtf1BJCCksCtrwYbVcl72U2?=
 =?us-ascii?Q?Ec8yA/vYWcWqOWxizgpP4bPe6YjHvosJ8nP51EIvndtz4/Rjf+vQ4gX2LhGI?=
 =?us-ascii?Q?1kDHQFVAPQjHcKVpFRFgi6NGIaqKqa4Fs7X9m+bO7cOlbXblNFOF6scjCi39?=
 =?us-ascii?Q?YaAmZPAToeute2pwK16PugcSdzDPacoUAJHo7JVIQbdyxl75/0DMpm3ycQj0?=
 =?us-ascii?Q?F03tjEKFYJoYHHVIKDCtexOAUb0nNfhAlEyjLlgNRykDFubHcumHwVMdbxqN?=
 =?us-ascii?Q?pjP3jZsXaxjJWOm07g9yujLL/9SbremKHwRMVAMkb921urnsSdKTb9H/Jbkd?=
 =?us-ascii?Q?cQlulZx7JWw7YBcP80qh6rLZqL2QrAuqCp+Bkl/7ZLAL2a2lNpuSbl6XkWj7?=
 =?us-ascii?Q?5B02pOc1ck/nWRPCSlc5loPuxthu2zlPHZwZ1KJgHZMurKkAOkwPQJbIXvec?=
 =?us-ascii?Q?2cqraRBhl8bay5dhU2WnyefsiYWRbCRD+NZgv05Yp3EtE47gNp91MJMBFUkw?=
 =?us-ascii?Q?yfdPjODhWiIj4d5os1tH3iAxuh7lZntGoaIFpzq9IEdvJHylrFZ7OhCbnbGo?=
 =?us-ascii?Q?8zs7sScjaakY/MTv4FEqVzDxHdtX5c1wcgh/Jf4RIzpGjfRAomlDAjvacYiG?=
 =?us-ascii?Q?hMS+epI2SpxLFstWujCg+ontDKm+te75Cupt16aF4V5We6G3aDE5B1wocCX7?=
 =?us-ascii?Q?GpVq7AwvvUzIwTV+pMOzfUEM0KtFHn4zmjcb3TppIEIwEAGGuyH66wQQzp8Q?=
 =?us-ascii?Q?T7uTlAoO/TKHY9Jrv7lk6YpfEOX4V1am49ITwGuRTOXcSbgYa5LWX/7IOD7M?=
 =?us-ascii?Q?oguwa+BAGBXvi/RsDenZZGlHAbRQauWmhX7/dd3rCxBu2E+wSd29F4gpmA?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0642eb92-2a88-4b16-bd4e-08da034bf7e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:24.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HukZPK424GgIryq23xMr/x8q/lVYeaT+K40dC8m7qtEIYZ2MU1HxqoTd6x4ghMeuhkzRShqrHenPKqHlXjkyDu56IWfPY6+qteiOTf0jGfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christo du Toit <christo.du.toit@netronome.com>

Multiple writes cause intermediate pointer values that do not
end on complete TX descriptors.

The QCP peripheral on the NFP provides a number of access
modes.  In some access modes, the maximum amount to add must
be restricted to a 6bit value.  The particular access mode
used by _nfp_qcp_ptr_add() has no such restrictions, so the
"< NFP_QCP_MAX_ADD" test is unnecessary.

Note that trying to add more that the configured ring size
in a single add will cause a QCP overflow, caught and handled
by the QCP peripheral.

Signed-off-by: Christo du Toit <christo.du.toit@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h | 32 ++------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 437a19722fcf..f6b718901831 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -814,41 +814,15 @@ enum nfp_qcp_ptr {
 	NFP_QCP_WRITE_PTR
 };
 
-/* There appear to be an *undocumented* upper limit on the value which
- * one can add to a queue and that value is either 0x3f or 0x7f.  We
- * go with 0x3f as a conservative measure.
- */
-#define NFP_QCP_MAX_ADD				0x3f
-
-static inline void _nfp_qcp_ptr_add(u8 __iomem *q,
-				    enum nfp_qcp_ptr ptr, u32 val)
-{
-	u32 off;
-
-	if (ptr == NFP_QCP_READ_PTR)
-		off = NFP_QCP_QUEUE_ADD_RPTR;
-	else
-		off = NFP_QCP_QUEUE_ADD_WPTR;
-
-	while (val > NFP_QCP_MAX_ADD) {
-		writel(NFP_QCP_MAX_ADD, q + off);
-		val -= NFP_QCP_MAX_ADD;
-	}
-
-	writel(val, q + off);
-}
-
 /**
  * nfp_qcp_rd_ptr_add() - Add the value to the read pointer of a queue
  *
  * @q:   Base address for queue structure
  * @val: Value to add to the queue pointer
- *
- * If @val is greater than @NFP_QCP_MAX_ADD multiple writes are performed.
  */
 static inline void nfp_qcp_rd_ptr_add(u8 __iomem *q, u32 val)
 {
-	_nfp_qcp_ptr_add(q, NFP_QCP_READ_PTR, val);
+	writel(val, q + NFP_QCP_QUEUE_ADD_RPTR);
 }
 
 /**
@@ -856,12 +830,10 @@ static inline void nfp_qcp_rd_ptr_add(u8 __iomem *q, u32 val)
  *
  * @q:   Base address for queue structure
  * @val: Value to add to the queue pointer
- *
- * If @val is greater than @NFP_QCP_MAX_ADD multiple writes are performed.
  */
 static inline void nfp_qcp_wr_ptr_add(u8 __iomem *q, u32 val)
 {
-	_nfp_qcp_ptr_add(q, NFP_QCP_WRITE_PTR, val);
+	writel(val, q + NFP_QCP_QUEUE_ADD_WPTR);
 }
 
 static inline u32 _nfp_qcp_read(u8 __iomem *q, enum nfp_qcp_ptr ptr)
-- 
2.30.2

