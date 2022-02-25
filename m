Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B14C438F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiBYL0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240154AbiBYLZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:52 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A88254560;
        Fri, 25 Feb 2022 03:25:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRr/U4kiiqcLrXXOuDpej/TXsP/0jvjH7q2Os4FrjW/tOTs5rwHHmmXHIQZ3BEBoDHoffc8sO1rEm2ch1nClFAi3Uc1YXcZeli0pHEBCZiVHBm34ozAR25wIQHVC3HaBaHKjJvGY+R9+jpKdQh2XJJT3x4Jar1it141XPC+VFk+W1m8MWEFlF68WZjuUD4oXgMJjyRV5qDtbMMsn74wNufnlwhMG7JT276nm6KdgrkXck5GV6q2w955Vq3f2W0mCRvEvyWSuEc0jHc7LfxUkGiSrU93EG33dG5lDDtOCBql5HQJ4Ke/9Nso43RIFY74Z2Zp8fqHZVfTz8QJjc0o2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBF/deFcuPx3YnSCa6P/J4ZK/WddcvmsCxGDRUCsRrc=;
 b=ffkwMQKE5Y9ykmNt+hNX5ovglI53oJ9mMpxExFmWHf0I2nLBy8bQ9f6N2o1EOCfBlRyKJUOtcsHF6GKOrYjMYI3ETP8OT8gZ+VP6iVqOVQ0zg1KvaPkr1YrmKuHP+pTHmE3/XiK3N6myEs78uHHTzE05LNa3G8n3IcOYTWnksMCJCGU1VPnGAIrnu1EgFtdzZ2hjc4XKjx2NBfP/0cTLiPA8rEgV5LjnBnQJGyZtBQUskFIAFQq73O3ojHufqxw5EMEc/+6Djj8iptLxbP5lM0Zxui6B9Nl/mpREwjz3HL+W1tBOHKci4Ch1XGr+BBGfx4rnyEtiYvZp+VLN0hhRQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBF/deFcuPx3YnSCa6P/J4ZK/WddcvmsCxGDRUCsRrc=;
 b=CpWO0oyyo7Y08XNha1M3sN4xapKKoiDV2ApK2Gh58qvdvjfX+ET9tfwNhUpCQzA5ywZ7t3sAE3Xp1+r8k7hDR4oo9ZJEE7IkhvrteFyDixAL3pBjgSxbQvoLe5mdJO8wQ7BRd4yeaK6yQ/1TL46kc8coDFFmez0vIZrbAyE1h8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM6PR11MB4362.namprd11.prod.outlook.com (2603:10b6:5:1dd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 11:24:46 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:46 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/10] staging: wfx: drop useless include
Date:   Fri, 25 Feb 2022 12:24:01 +0100
Message-Id: <20220225112405.355599-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f87549f-f2b0-419c-cce6-08d9f8516d50
X-MS-TrafficTypeDiagnostic: DM6PR11MB4362:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB436237EEC6C63B3DC80E4776933E9@DM6PR11MB4362.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBgpbV6BpZC6E3EJnPdcqWeM/gJenatSJtCNkmnaTxYT0ek2zX4G3IosN0GkZXysLL1ul3QPgWs7LTy9fvovvmbhcqNHqQ8eVSdDRj4s9v60m4FrH2yCDJgNvCQVRSp+Nr/CZRMWfZFoWFdNsoJX/yOBlx5KJN2knCg3zD7vK3s69c/SG04bTuM3J6V2h9Yz8RoeJ0PiKZAL3dhIgqu7mLN6p9NOkcZu4jbkStKYYTrw0o9XgFZdQtJP6BTMxEtvFdBOFTadjMZlAXCWKp+7gN5Zhfc7YTaFOGKhvTCuEHJcNPm3hStkEXhGJDu88CkmMXoki38+ly6M9p3/hvo0Xa2I4cMCL0XJTb2koEEzYfTAFxmjqPgMvy5Z9iP5IcOMEt9LFY3k6zh1LpiOFYslCE9+DHsWoa/rzaJ+l0JHtF2SYICElwTEsQaZZzY+rr1ubdQZaBFGZGT0u0EhpbBbAfszFNWRq7BFhuI5WwSJC6lYbd/IfPvKyRCRM0572N7W83TmdS7IphQ+VERF0O9KPaRSa24sBqYn2ymeM8U3uBxSznYIGcidHPZGGZDllbWNs4y/3pl6KePWCum304Q6V/9Fhw82e4zSC/vciKF5h2l89r+qjuXG5FzzpJMaoS+e89OPe0bWl/XgOVtHEDMcFADMvGaWDiNSUwmBrrw32bzKYFPThAr8xyV9uLfpODFPpxnmbXsATDM7r/N/CIb+dsm9un8bO6e+zNyNNAtmx3ptiB2LAElQIZYCVyWMl2iL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(1076003)(66946007)(52116002)(8676002)(2616005)(26005)(66476007)(5660300002)(66556008)(508600001)(2906002)(83380400001)(54906003)(38100700002)(4326008)(86362001)(6486002)(8936002)(4744005)(186003)(6666004)(107886003)(36756003)(316002)(38350700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEFNcksyRWRDekR3aGZpM0YrS1BrYjRnOFJCK2JJMmpUVFZ0MHRXYlZ1VnUx?=
 =?utf-8?B?TStyRHZ0bHl3UHp2VzZWelc1ME5oWVdTVXMzdWhqZElLSlhDbWpWMXQzaFNB?=
 =?utf-8?B?Wk1ROGZwK3lMTmdFakpQYy9YQlFndzJ3ZUd2dWV3Ry80cGJDMVE3amt2UTZB?=
 =?utf-8?B?bVJJT0E4VTVuRzgyb1NmOUpIc05nczAwQTltZTR0UmVFcExmQlhDZXdObEcw?=
 =?utf-8?B?YVZwSWdqci9xVHkwVHlKUHIzYWhvSnd5Qy83V3V4d01wU2wrWDlPc29qMlFO?=
 =?utf-8?B?Mk5hazMwNkFXL0F6TlFWNHJDRjkzczMrRFNSdlJlK3J5b3dyTnVMTkJJY2Mx?=
 =?utf-8?B?TXNjWW14Z010WFdUNGxVYSt3ZTNvYUF1eDlOazJUdm5PcUpuNWRGMFUyUXdN?=
 =?utf-8?B?eCt5eHAxcGQ3UnFkSGFZemxnSlcrbHBpaVkxbTZPREtwODZ4dWEzRUVTTG1s?=
 =?utf-8?B?Syt4aXB5VTVyNUppMi9qaTNuc1loWFdvZG1Ea0dvaUtna1prd2p1bStuUW1j?=
 =?utf-8?B?bDNFazVMclZ1enhCbWo4c0RJemNNTmplUExGZHVYREJuL1l4WEFnOGtWdW04?=
 =?utf-8?B?VDdTVXFUbUdKdS9WaVZEbGk2eEFXUlExMWJmV3Q3elA3QUZvdDc2Sy9OYlkx?=
 =?utf-8?B?enFzQTB3eU9jbzZJRzdYVmlLRHB3MDNVdW1EajhNRFJ0NDlTa3VFUlBRMlJY?=
 =?utf-8?B?R0Rrd0ZRVVpySlgxeGtPMFh4S29US2pwTEtOWUNPRTJ1L3FqditYbG9Udnc5?=
 =?utf-8?B?NGdET3Rra1RMZ1E1VmpGT21RWkRzbWNPbzNLUDUraWEyZmJ0b3A3enQ5SHU2?=
 =?utf-8?B?aVB1R04xajIxTWZrUExhOXJkOXY5Sm9vdXNVVGxIN3RheWdSQlBMK3hUWXNT?=
 =?utf-8?B?ZCswcndrQW5xd2F5UXRxWXIwUTVxZGpCZk1NQVgwd1A5MHNTTktPSE01THlS?=
 =?utf-8?B?cjJxbmxEUGV4bDZLOEQ1UjZudDdhTHYvRE9Wbk9oTHQyWFhRODdyaHhiY2xL?=
 =?utf-8?B?WC9yQzRKZ1Bpckkvb1BaTTR4MFJLdTVOS3lEUTZ0dmlPdXE1bGlGeGZ0cmZh?=
 =?utf-8?B?YkliL0JveEpsUGxYL2VhZ29Ed2I5TlZHY2VUcWNtV1VXVElSVkliMGtnanNK?=
 =?utf-8?B?eDlOa0JSanR0WGtNMW91U1dGQWRNRVZtbjgxOE01aFNGai9wajlrUTJzc2xy?=
 =?utf-8?B?akhSSERKTVZPakcvOVV5U3lUblFUMm9qL2lxc2dGM0U3VjkrcnNxWWVzbkIr?=
 =?utf-8?B?S0UycW16a3hVSGVtVkxtdENBYlBFanlxVWN3M3F0Rjh4eXc1cmRVYjJ3Rnoz?=
 =?utf-8?B?MFIydFMreGxLaCsxVWpybXFjVS81WWdnd0JNZnBtUlM5bVhXMzlyd24ybUx2?=
 =?utf-8?B?Mzl4UHo2Q1c1TmhCN0Nabm5XTHBOdlREWFkvNGhTVkVwNmJHTVpzcVpXdkJm?=
 =?utf-8?B?TkI4QTJLWk8xSDF0K3Z3RGt6WkRIYnAxYmE5cHNrc3lqM2U4R3FGVWlHM2tn?=
 =?utf-8?B?dlljL2RTUmFpWXMzZGNoUWpKdk9mbXcvOFk5Y3l1M1l4aUNZVWwvOFpzWkVt?=
 =?utf-8?B?dlgvMy9OblU5aGR3L3I0V2NtS081WDVURXlCdUxTTWhIck1mRy9MVUVWZVMr?=
 =?utf-8?B?aFEvRW5RZHZlUlRkaVg2ckRCOHJ5U1FzLzhIL09tbnM3d1lwSUJVaFpzS3Uy?=
 =?utf-8?B?MFlNZlh3L0JZbkVFL29SclFkYVZYTERVMW5NVFByM2dqRmZMSFFoTDVTT2hO?=
 =?utf-8?B?N2JGRGFEdjVOSHNVZTB2SjdVdzVTeTJKRmdKRGZvRGJ2WVdGZytHdEt2SFJL?=
 =?utf-8?B?Z2Z2RWFXRzZBMElKbTNyWERjcWxHc3lCSzU5LzEzTGJDaVB3MlhxcE8rejhN?=
 =?utf-8?B?dGY1Rkw0MGJNMlNobzhqNGFMd05EYkFnZ3laRDg1dDBkdjM4K3FwNk1nVS9G?=
 =?utf-8?B?QjF3dklsVm5ncUpTczc2VEZ3WjdsQmtHTEZoV1FqYlhrTkRnTWZLdDYzelZJ?=
 =?utf-8?B?QzIyb2VWdk55MDdCUU1ISW56ekIvUGNXRmUvSDkvTXZaN2VPdndkV3NXYTBV?=
 =?utf-8?B?bUxjNTRUV3ZjbThEMVNNSTV5d3VhUnB3aXNZcWJCOXhLaWhISytDNkwwdkJz?=
 =?utf-8?B?NFFvM09hNWNCV1N5UGFpMG1EZlJyTUM0TFBRcmlCNGlUK1NacTBZMjVBbE5W?=
 =?utf-8?Q?lqo/JIRTZRP/nPNgwzhXuyc=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f87549f-f2b0-419c-cce6-08d9f8516d50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:46.2499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKaGFHRdxVkzUxsIV7nad9IA9tiIDZGwpqqVBIeGn+jZddD0B8Bcc9rVrMClqwjDYaYj5Fq8HYnfcUmQrQMgMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4362
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaWVl
ZTgwMjExLmggaXMgdXNlbGVzcyBzaW5jZSBjb21taXQgNWU5MTFjM2Q5ZGJjOSAoInN0YWdpbmc6
IHdmeDogYXZvaWQKZGVmaW5pbmcgYXJyYXkgb2YgZmxleGlibGUgc3RydWN0IikKClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCAyIC0tCiAxIGZpbGUgY2hhbmdl
ZCwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggNDQ0ZmY3
ZWQ4ODJkLi44YjkxYjFkNGE0NmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTgs
OCArOCw2IEBACiAjaWZuZGVmIFdGWF9ISUZfQVBJX0NNRF9ICiAjZGVmaW5lIFdGWF9ISUZfQVBJ
X0NNRF9ICiAKLSNpbmNsdWRlIDxsaW51eC9pZWVlODAyMTEuaD4KLQogI2luY2x1ZGUgImhpZl9h
cGlfZ2VuZXJhbC5oIgogCiBlbnVtIHdmeF9oaWZfcmVxdWVzdHNfaWRzIHsKLS0gCjIuMzQuMQoK
