Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA154C9BBC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbiCBDH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbiCBDHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:07:52 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2060.outbound.protection.outlook.com [40.92.98.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F84AEF29
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 19:07:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeaYkLPgE1C2FaA39y5rRyZfaEuAZxw8ST6/6DXVwekI5V7LSlNrJZ32ytv9CB2iqZ07Qg8niB0zy7AinZrsiWQUUX5joYoXrSbXdl/idpjzXjIbHoxtCSBBKEzngnRF+8Iz2pb6cBa+XgyTuG8QT1Kqq2uRDob2Nv8ZT61HU905G6JyxhpGt876uuduCsH/p3tEuWSVsIDqhUZz+qwrvFuzqgrOX6cNU/5zhYbGIoYIdaQAJ5tdeH5TZ1zN/JP6GEJl1MIIgrLppUdrEGla/BYou28ft0ZL1ns59TJg5qajDmI55AbSc6uLReOklDzTHBLsQ7KEeG0Xplz22YVC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zw2ceKutNMUpQewDzx6W67c4TDiC7iPVATcmvOFQg5U=;
 b=TsHPJfEs0Y6r3czNrXouyFc6l/JuqFyjpofJ1E5mtFgqfx9A55uykluRbh/mIFOLhfcwF9Ob7WPOAp+KuBqtaWGCH9pxx0AvaXHH/RrtBEYRyUpVpFyYMaZf7mmNZ7op2fs20ok8aKq2D/82nugJ/o8B/AjIm4Xgt7gJPKuQ/fdXuhFtbPdhU0oOwdO8EosS9/HxS+R9H4hyJUZzaFaTgIjwxqe6Hp39FGXH/9GQE/mtGRm9BKvf7aRzTmNctpw3zexNXmtAop0HnbDGDuA0nIAXqT82biJ0cq/wWsXpWuswZtzPJOK0/zKeD3UMkCw5XOtialAZHuzjxqja+D1mGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw2ceKutNMUpQewDzx6W67c4TDiC7iPVATcmvOFQg5U=;
 b=nPiwfc0NxcBAaqUb5QOIqSx64UBYUlYtEnIroGl8mEy2KfnhxQBOHoMFjc6oHlSOI2z0K3d05rrH1qhZPeGK6Df403WIsVAMSuG3fNVDu3NfM/4nT5CK2hwn3pCp+z13uLvqeUUAxV6puhSuxITryZieMqsxMqxLs7SrKeAPuhu+DgNnzLlhTWeyzyuPZscn0hBXmoIZf1wucsjI5LPY3idiBsfczlwwDDGzDGSGCiGkViNbQwmqowNglOxWHlbmY+bX8I67P0ogKY2Bqc3xrCgnbyPMywLNrzkuiWo4j02o3ZrEzBrq21D1EW3DeQqOzNOtxQgCopN1fDYGRiJgpA==
Received: from TYCPR01MB7578.jpnprd01.prod.outlook.com (2603:1096:400:f7::11)
 by TYAPR01MB3039.jpnprd01.prod.outlook.com (2603:1096:404:84::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 03:07:06 +0000
Received: from TYCPR01MB7578.jpnprd01.prod.outlook.com
 ([fe80::d9c7:4aeb:8efc:bb38]) by TYCPR01MB7578.jpnprd01.prod.outlook.com
 ([fe80::d9c7:4aeb:8efc:bb38%5]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 03:07:06 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Shangyan Zhou <sy.zhou@hotmail.com>
Subject: [PATCH] rdma: Fix res_print_uint()
Date:   Wed,  2 Mar 2022 11:06:41 +0800
Message-ID: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [Ofg2ti8CblRW8oYVdhJVnPAXHNGhabLG]
X-ClientProxiedBy: HK2PR03CA0047.apcprd03.prod.outlook.com
 (2603:1096:202:17::17) To TYCPR01MB7578.jpnprd01.prod.outlook.com
 (2603:1096:400:f7::11)
X-Microsoft-Original-Message-ID: <20220302030641.6658-1-sy.zhou@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ae2a747-2fd6-4c09-6dd1-08d9fbf9bb8e
X-MS-Exchange-SLBlob-MailProps: 0RSV28T7LqSCdSIKPv6dH3E6AZoV1wCPRtJ6188iwaqJPrhG5a3evJ0OfTs86F43XjCUmaZWG/Z2ocxCmQgcKPP4/pS0Asyfn+JDmNZNkXqSRTD1MpvVKnUbDQM4ozWb7P3R3mSf8pynFeF/by0U28ee59VzLrVmRvCJAhHpyqeKQQiRFRKdypfmrvZWulx0tjWQ72ATDUHy6X5X1nPki8LJ1mlf/x2w3niuJ/yNiu0lvgyWz/RAcaRJpPTGgQ09pFsxIgS+988iDDCYj1qqcIVX15FYoiGbbwKIJP+mHWxHWzameiua1OKwtH/NU6bg7mC18xcZrFjAhjebfq5FnhhZQQOemtpAff7+rkx7/r2HendokkJitNuew1HqZJC5tP9MnsqbNnSxC7B9ONI6xmf+VN+p+j0UA8D9WHbrsvjynlgMCgBEztE3+WqgNQkO4LkgZ5kRF9CTGas8k8vRATfMIUQesdOk4EN117ptaEN3cBtOgU3URwBd7dleXRNrihvDcwA0+xU1yphr0WvN47d3aO2c0bLOTriinvR1dQDUP2XV4YgQtw6sqilTxKPRCB9ySSDCUouPfYtZ1NbQiKcyt+nsj9ayMn4l0NsbFfVrf2tvPd/Qq2tzc0HNTdlJjeCNl+FINo9rA8GG9FzD/j0vaZfzQ/sDEdeECxcAmrSwLqKmmwU/3bWCujOSHtiH
X-MS-TrafficTypeDiagnostic: TYAPR01MB3039:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SWejS5dYA99Pqty9E+VMXdVhDUNHgLWsiJsyRAlt2LyeSlrTGpCf2kjf4pe9MlDEa2UCYaVDsVswwdGlBRJN81aypKzjfo4RxJxSOf+C0dCzhkoYVf2joybLWKaxshzdHpZbxrSgtEMUaOTZ+I3p6B0wtORKzQ4Kjm8FfTuPuxjHqZ55/RNwEHOfgQpC/iMa5UKFFBI1+SOaCE00MUQpE3bAsMrxy6Qt4jn9FDQ4erS5INJnkeU5A3j9cH27tPrcEAc0NPpOssXmpT11l8o4VaPbEkUlIY3zlNNNbGKcRXqyh19R69a4YPCOT9hzycnW5zcaFPYIrDXDoeKIKETIBXiD8zDtv7mHPRmwQTjB1Ztq5v2+hPaucEWwreRMQx3uolQ4T/4mAXptZXMmYYLgxFJ2mVm31xbtSRbANNlmeYR9PtJzh/KtS1Y6uodyqc4FUGoKvkMFKFWq4EDA4oMrfOw10V0v9RSTvMJMpt5rEr8h0vx/LxiUSNcyA3qi8PwPhq8W8eDM4o+X1Nz36FMzuprnZoUMfIdN1s/wZCTS3k/2ZjYNex15JKN8QxxlrxePLYNqfGr66OiBwVOrFQc9TA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ld/nBPyUgUwo5r9dFsdJqZTEbCQBgJoPgeS1dONCD6xPyyaOvJPiPUCR5p5U?=
 =?us-ascii?Q?YnsWt2fNdqBYyoyTDwXfa8xgrrBsIAjyPWWAV1X58kd1D8lIUEIThRH98N3o?=
 =?us-ascii?Q?eIA8RUMp3VEI6FQ2RsjKHH2igJN9L6c7f8QZLKSxtYsBOSB+5vbw3f5YQ7pI?=
 =?us-ascii?Q?ayMAXCupm5ZBPc89INwUXEiYJ18kq4KskzZb5dQwNRSZqT5fV3Cv9HS5wNHL?=
 =?us-ascii?Q?biPoh6VTHXzXrGcq6oLKxTmD3StlmcU1Pz52mX2LwX+AwQt3SZepWcdA8cTq?=
 =?us-ascii?Q?qeHOM9UdCLV5D5KC0JXS/qxOgP84On16k4Cuf4KgbIIljOZ6EAMQZTsWIzL4?=
 =?us-ascii?Q?BqRAhkZ5173iKQZq5GGL2pgEVuTmVby1B+zjvCm+T0Tcnw/uBO6nC+VDUhzt?=
 =?us-ascii?Q?IccUAFMvReuUa6hJlz5oK+RDSnElmOS+GNs93cRrQszgFrU4hJR0fqT/FTnj?=
 =?us-ascii?Q?PZ07Fj1Vihl9uu+eJmul9XclEkhhtxao6TdsG3C3eVvW1AjnjPPw01ZS5vTh?=
 =?us-ascii?Q?LirvlCk+TD2DNDG3tGKlqDf2Fr01ujifexJ/OPyfEH7flIC6g/uoOSBn+9Qt?=
 =?us-ascii?Q?1HjxevFUa3qHRLj1Ue8chc4vu1MAR83fpE6Q5ZI0/AOfnZ5wuefrWxHHwj9Y?=
 =?us-ascii?Q?VqMq6rnr8msJKotUrFPwN34vkUvdrtXAoYF83dQPwz+Wii4Vth6gGRtSjFg9?=
 =?us-ascii?Q?4EPNny0I6Qe04o+qOMo2YElgsCjCJPLvRhxbDqNqWbvKTlgchcJB3jKwLpit?=
 =?us-ascii?Q?f2Li7p+gGDz4WekGIeQYqkf/KN5IRDcCygXON/k7ifaSd4ZPNiBmrXG2UBp0?=
 =?us-ascii?Q?n3DuL+MQDeQ0D75VtPh1hDHXzsoM0Z+glFjYuKHEnzwhRcCDqn1uRP/KmMgu?=
 =?us-ascii?Q?JqztjXbmsqRySotjHxtySlxcECDTnfTWSqO+qoeIq0g/3y6KAn5j9WJEZCvF?=
 =?us-ascii?Q?HhMgRZhWbHQQu8bcD8COXA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae2a747-2fd6-4c09-6dd1-08d9fbf9bb8e
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB7578.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 03:07:06.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print unsigned int should use "%u" instead of "%d"

Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
---
 rdma/res.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index 21fef9bd..832b795d 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 	if (!nlattr)
 		return;
 	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
-	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
+	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %u ", val);
 }
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
-- 
2.20.1

