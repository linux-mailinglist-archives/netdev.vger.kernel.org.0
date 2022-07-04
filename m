Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7C564E30
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiGDHEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiGDHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:04:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1509E1A0;
        Mon,  4 Jul 2022 00:04:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/+Joh0BSXE/IKvQhz2BMEpzXbdsi3HDnp2y4Ae767X5plcEGxOYofa3GspEjcrnXr1iwrYkmYoMzfiKem2VYzWt4msO9+HLylXLzCPYUrO7tTrttLgs/T/uk5lPMdS2jCFBHM9lQa8sv1sy9SjA/HCtdzdXMIxrwmFk3HxYg7P6xglpZEWjKJaDMs636HlEUm2XTd+I18e/Ijemx+EnKQlhLQi3bYzG8UHsHIESJ7Z0Y+uVzbtKamEmuJ+BIkNO5c8Xhr9dMLCZimb637qlglQHGcJGKA1yOo1PznPWEFKxJL7He2iRx+mnIrmXpRie3pztZEnO7j8n4a+x3f0Cvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifJW4RHg5XzG4UnwEaoNyRGFJ4tWSxY0wKtL+s0eL6k=;
 b=VEUsyadpUgzwj5E/p/Bk3hUL32tMRF7fyyN3rJvmK09luFcSFAkbXe+/DHBARHdGpCmbCsTrZzT1QfEBLuHz1qBkweaveGdMytOnZtigOLn1GBI63N2shDOm5tdVqvXyZ2v3949Q+zaD2vcKHq2SeXuitN3Fc7n/BpqowMjMyoBviQda9a5+THo7B1ZjonwGDuU0OHzUpzkFPxWqZETKa456UxUdEkKUBjEsC58kWg+bN/cw0u1N6Lue87AXzmVFoxczt44q3LxdWtJskNRuCxi2HSNXYV4wPNW+v8KhhTL0Smpo7RIzUWrdoYwz6bkCCcxh7wrrNnm78RLMF7mcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifJW4RHg5XzG4UnwEaoNyRGFJ4tWSxY0wKtL+s0eL6k=;
 b=fmxPNUftbmMqM/PsN1j+c4t7lJq4tEyMOxhVBIzjdJEloJN7gUn/mDeMMxjFzUDcssR5fdTD0xBdK/Br3lx6GHaUHlBjFlJpGPRUPKM0McY8s6O2//FZ6bUQbzYzAkOLGDYu9UQGb8K+xmsNp4zsBLdegMISCH3UoMVgywvQqjE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BL1PR03MB6088.namprd03.prod.outlook.com (2603:10b6:208:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 07:04:36 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 07:04:36 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
Subject: [PATCH 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Mon,  4 Jul 2022 09:04:07 +0200
Message-Id: <20220704070407.45618-3-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::23)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36404a02-9182-4dc0-0047-08da5d8b71bd
X-MS-TrafficTypeDiagnostic: BL1PR03MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWSZeG9tkFy6cV2BBhkvbX9KO5M+o0VrSgyEyINU8uSvTnsxjQG0l3YpgrFvjbK1+owJMEXCI8ToymdETenL9UXh+oXhhNAc0iKqYQ1LJ8EoInLJ4eSEVXeXjLMRswoMrfzlvJVPN8pHZuR9L9NR7fejv9MZwqhLM/JBYrAC4nApT91bxkkU2S0xtFk+rchp6KcSoEzaMpcHSh4r7Fk4uGTeWtI0OAEpe+heMbYHj9qa/oy/J7x5RpRCJajjcmZLk9YQXIpyAVtkjx+jCYV0YBkWHG4I8eBqasmqylW5LJLsOAZkh1azCH3m/23B3DwdRFjMtk4HN8Q6d3DJVA2d9/NvZE3u77MHwDjlOnILwJkPjVdylAiZUcy/PZ+yQEQ2xivqmEsFubzXgaH6Fz5+bxRgeBIGX4ivsRrWKUyppkRLOZBIDV06lxc5/vlzSY/3v/NGoeEJeVjb3aKOVepfM8XBU7tjUpU8heGcZ6T+gzseRpDNWfVlBKJMYkc0j4OWnO3swevwK/jDk2O6/bNBVS1SyPxTxsBZcW2cZbgMr/fRfYYJ88FnbTqNe7cTlo8F3qOzZGECKQzoq6cFp3EooHKZo/cvDTbR3nw0wy/E/geZ1FeA5IXSQLBopZWIHnGEvplVwt90q3MolBmwnEk0UWf59Z9V4FiWhvs9Wshf19SxoCaJqojBNXxq6GTQba5yj89Vp67yjbrOHwvsVlVEHTZVw/CJbUArCKabZgWywPY1wm8/ssIqFTmssxCPXNf9tvatZD/io+5PtvKKy95Yf7C0X6GfnMYel1A3xTYUn87P1idixfaJTewwtTlQewex
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(136003)(396003)(39850400004)(8936002)(66946007)(4326008)(38350700002)(38100700002)(41300700001)(4744005)(316002)(36756003)(6916009)(186003)(6506007)(52116002)(107886003)(2616005)(2906002)(6486002)(83380400001)(478600001)(6512007)(86362001)(8676002)(66476007)(6666004)(5660300002)(66556008)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzNWL3h6RkdGTVdldWZWY2NjcFI2WXpxNzU5NlUwNmh3NVRoanZxOUQ0ODBk?=
 =?utf-8?B?aTlIbVpiYnR6bWdmeFp2ZVJlQldSUkYwZGUzWDEzY3NiYzE0QW1GKzZ5K0Yw?=
 =?utf-8?B?MW5qM0NjcWpQb2hFRkdaOUVCUTVFZ0plZzNuczdqajM1REdjNzhMU2dNWWd0?=
 =?utf-8?B?NWlzZkRla2thWFd5UTNXWkZpSUozMXlLR2hKMHFibExFOTFsbGR5d2Y1dk5i?=
 =?utf-8?B?RDNnSGUydkh6UFN2Mkg1M0xlOFp1dUhhdGhLQ3lHaFFPMWtrUjMvNWlqamt1?=
 =?utf-8?B?NlRKVVgydTZXeTFlQ21qTEJuODRMbm1zN3pIVExENWFwWXpvd3B2ZFg0L2Fk?=
 =?utf-8?B?cTZNaEk5MFAvNHJIRDhQeHlDSENSWmZCRDZvbTViT2grckVHa1RtVkxHOVF5?=
 =?utf-8?B?Z2JGc0t0Si9ReTN6azlIdzhnejJKTUpHUWtSZzNHZnc5bW1mSkdxTmM0bnlN?=
 =?utf-8?B?RnpZMkpSdUlGQ3o1SXFJYkJ1RDI2S1R0NHFtSStyUUJDTlFYNUdpVTZzNWVj?=
 =?utf-8?B?Y2JlWjArcGtoKzBKOXpxd0RSYWppaU94Yk83ckxESnc1UG9pUG12NW8raXlL?=
 =?utf-8?B?TnBXMncwQTVzOVkyT05YdExGd0ZiWUN0RzMwRGRlYS9oQTB0THVnU3FmMmY0?=
 =?utf-8?B?ZmFXdFU4eC9YazdJdnN0cVlXSXlrc3pHYjBXZ0ZLdVJJRmlOVWtQUGFKT0hx?=
 =?utf-8?B?YklRSzhqNmhnNlNQdFV2T2VQc0VZZitHMEdSYXdnM2dKQ0dITkc0OGVUcW9L?=
 =?utf-8?B?YjhJV1ZBakpPUmgxSUFMMWpva2RKaDhubk1pK3BXWHlKZ2JPWEFlbXBFdXN2?=
 =?utf-8?B?QzVxL2s5TVVnZlM2QkRaMmdYWHVTUW8ydHVnTDcxWFljbTdtQ1VlS3ZMNzV4?=
 =?utf-8?B?NzFpV2tQM0dNc0RxblQ4MG8zcDFPTVVldVZ3Q1hSSFUyN0ttRjJEY2hmcnpt?=
 =?utf-8?B?ZzhNT3ZlSmdvRjdENS9tQlgwNTJaUkl2WExzSUdUWUZRQkxPUkdDQ1pVYTBa?=
 =?utf-8?B?TXdNb1NVUmdLQzBWamd5RWllMlRPVFdkSUN3d1BlcnMwNXhtYURERER2N0dV?=
 =?utf-8?B?akdtc05vYWM1SFRJUGpMQUcwdEdvbTMwQ2xsMWJRSlJJRzJVZTN5NkFxK2ZK?=
 =?utf-8?B?dW1lTCtwWm1iSUdGODlkbmdhUzZzMWpDbEFvWDRqTzJhWHpsOElMeTI3VjBN?=
 =?utf-8?B?Z1hTcmlhSU4xa3NLOFpxL3NjcEJEbG9CL2loVHBCSml5Nkp3VDUwOHFjZzJK?=
 =?utf-8?B?aEo1V2o5OGhBcnpGUjlGcm8yVTJpNy9sZm1BM09hZnJuTHRHUmVWL0FQZTdM?=
 =?utf-8?B?aGhmdG44cUNHa3dSb1hDNDlRRU1valB4d3JMWDMrUkFzUEJTVWM5WHdaQmhM?=
 =?utf-8?B?MHMrelhQTDlLSCtFUkdkQVZVNzRGWWlYR3QxVDJETWVYaGxkVVRWck5BcVZz?=
 =?utf-8?B?MlNaL1IwQkE4Z2lYUkVTaVNjRzMvVy9ZMk1aMzc0QVRXSnBwLzlyQVIzQkFH?=
 =?utf-8?B?NW03MjR4dTBLeEIxa0M3b3Zpb2pURjJVOW5xQ2txMXVJTXVSNjl6cUdnRC85?=
 =?utf-8?B?TCtENnNxZWNMcXBKOEZabE1xNVZKK2JRWTBQL0RyWGQ0SkU1eFZRbmcvakFJ?=
 =?utf-8?B?MEt5N0VqaHFadlR1Z3NCYWRBYlQvVjA0TWN3K1RtNkxTV3NjWk5Cc2hLeXgz?=
 =?utf-8?B?d1ZsOGNRaDRTdmwwcW9LVVZGNHlMUGlzMWtQUVNsNTYyMFJ6RGFRRUpQS3hS?=
 =?utf-8?B?WHFKK2JNdW9JcE5IdjFWcGRzc1BIcjVaak0vZnlYWHUvbmRxdnhlTmZYajl6?=
 =?utf-8?B?Q0dqUU1ReHBDa25OMGFkNnI1dEgzZlFzaVh3dXFuQU42WmlkaDRyeVNPSnpi?=
 =?utf-8?B?ZXNOakgzWlVYRU1iZzZTbHNtMldxVEphZEpLS0xMZDRxY2J3RFRZTzlOVnF1?=
 =?utf-8?B?K0kyczFOQ2dqK0ZZbHNzVEFJTHpWUVlLMllEckphUCtTZ0pieHBWbEhJcTJJ?=
 =?utf-8?B?SHZEVjd3MFd3elRYaHBFc0pWYnA2SnFycUdvUWtJenQ0enRsVUxGY2JneE1l?=
 =?utf-8?B?dXNKSHpHV3Y4T3B2cWhoM2IwNk8wMWtmRkJMbDFCSzUyMHBCMldJN0JtKzFM?=
 =?utf-8?Q?3le8xuVdr0TJIElkFNBKBO8BV?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36404a02-9182-4dc0-0047-08da5d8b71bd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 07:04:31.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y76em8430qLAl/K085BEMTm87yf6ffIPLT7NW+91dSyoYx0aZTxnQoICaudq6toOOBcL7BEwHys+H6vIpquopg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DisplayLink ethernet devices require NTB buffers larger then 32kb in order to run with highest performance.

Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
---
 include/linux/usb/cdc_ncm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index f7cb3ddce7fb..2d207cb4837d 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -53,8 +53,8 @@
 #define USB_CDC_NCM_NDP32_LENGTH_MIN		0x20
 
 /* Maximum NTB length */
-#define	CDC_NCM_NTB_MAX_SIZE_TX			32768	/* bytes */
-#define	CDC_NCM_NTB_MAX_SIZE_RX			32768	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_TX			65536	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_RX			65536	/* bytes */
 
 /* Initial NTB length */
 #define	CDC_NCM_NTB_DEF_SIZE_TX			16384	/* bytes */
-- 
2.36.1

