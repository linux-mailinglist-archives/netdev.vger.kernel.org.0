Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8714E4C4377
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbiBYLZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbiBYLZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8041DBA80;
        Fri, 25 Feb 2022 03:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAJVydU8fMGkCwJvL6GR1C9vZyJ/7wFbW0FJKNyy0d2GLDCPRWGLiiVEpIcMYfutUdelek1Eho5g4wBubljfii4ulY+rqAVFnyXEREOJVOG6LSUbtvlS/YaWtqvQVR4O6vVtxXxlk1u9eSyWL6FG/z1Dd2LBLg6Gt4z7FkA+Y3h9T7s+UQydD+1ToCfKMFPOl502dzyEClWEIIPBGOKcmsL8Bsn9pZIWTNqSOw3TVOsgFS9FSY4dES2qzp28zt2lfZhWc2UDgQjh/q7XoNla6xOtW7FPql8k+lXVmdGFH7IA0SRy01Lk3EbHkEo1tHmFUCRQ5AP2lXLdrMKvm/DVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFG80ytckh9LmzJFSxoW+PmAHRd0OhkLgBzAq1w2Oe4=;
 b=mmzt496gvDd31ZTJlZKnBfgIPcRGSpyv+ipdk7n+AKeFh98W1KCD0UWOn3jtCLFbZuUEQL6iDu6bdRhZLyL8XF4AK70Neho4dmH6sFeB+Lp37Us9BO1dTxH/oTwKRUeaUxvq36tcgTRcABj5trpNxTlTn18O8YuTkpb89ZWYoYJO3IP3eChIRJ4HxlzLntCXGWRwAWHEfP1zY9gN1q93WYij4e/hMe8xSTWNp2tN92xpM73M9WimxT30O+w+k/EZ+YHvIflfq9VA5cwPZNhcz66gOZYedp0a+vQjtJrxjxZw/DYKZxJ5pJVfqI+XYJzaYvp6gKVgu06OB36uv/Cb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFG80ytckh9LmzJFSxoW+PmAHRd0OhkLgBzAq1w2Oe4=;
 b=VI71eWw1P9nuJtXSnR/y2MmlMuPhzVki3okbWOfAHnIOO+DBgHWsstfoQjWmC3Xh75o3yyCPCNFb1H20XCGEDbtGDazX1onH2rOofmOvOh0VC0Hsp8a69BTKo2dj4O56ZhHPIKdLX0tVxGgRqMQm8aQwucG/Sam5xwj0Q9z7mwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN6PR11MB1428.namprd11.prod.outlook.com (2603:10b6:405:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 11:24:50 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/10] staging: wfx: prefer to wait for an event instead to sleep
Date:   Fri, 25 Feb 2022 12:24:03 +0100
Message-Id: <20220225112405.355599-9-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9991364d-8612-4a67-545c-08d9f8516fa0
X-MS-TrafficTypeDiagnostic: BN6PR11MB1428:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1428E780F4C68D028A57405F933E9@BN6PR11MB1428.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+q80jbDTT74yumiQqauKqJYz+rrhGyI1fMfhWteCFBJeHfoRCrynEAj2MXya8AR37OjBOpG7on0xEu2lzNBvUOr2vqLC+lbp50ji+sNGaSBccA537jCNTaMiKYt4e0py3sJjjYJvw1ltot4dbhkNSm/u3WPkOE+CH1SM5QnhuAIofmBWKt3EV6HLGE9XQk+KSXrlU/3O0ri82lFD5TI4HtbW9aSyT5c1zoU3ZwIjQiYKEQDiCBtbM7p2iptwA2dG48oTY3riliBqfKf0ZaUvUMP3SJINWduXIZqZrdTf8+8ThYBt4sE1yoghzyU+q7h6yb5kHX9opfcr0pPBQGJaFpZzdN4HZu0jDJJJl5OqkvatT7vMXcHQn4j6DLgHfqsG1gYxT8X/jrRgggvdvKbupWVCVs0XIZQptepAU2xFyUyn7/EY2XLjBhncE9SBQXVwyPs3DomWBL7fuMx2nI5yR+H5xV0p3NcpFBtV9UPuAwRV3OSrNK2Wsu8XFxA2gmg9Tmv6DwXG9en1R0B1hHFRof51lMhgqZCLx3AGL9uk5U4hl0WVFS6Qz9awQjXcEqx/2sIUlvBaeC67dfW3h10UY6FXtiUIb3m6MIPJuc9yDqgjFQvNg+VwgLjVj8g0vGWgztznJt8/zfTLkNtKXZB0YvLLNFDqB3I7dlXNtEkoZEjpBpbUrojekjd7Pga22vLqhnMd83AEMGBeAhDukRyPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(36756003)(66574015)(107886003)(83380400001)(6506007)(6512007)(4744005)(8676002)(26005)(8936002)(2906002)(38350700002)(186003)(5660300002)(38100700002)(1076003)(508600001)(54906003)(66946007)(66556008)(6486002)(66476007)(52116002)(6916009)(86362001)(4326008)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?by82anJ2RWdLZFBLY0tQaVBybFM1TDBBdnV6cE9ETndrdGU5dGgrRVZFN0E2?=
 =?utf-8?B?ZDBmeXhlc0g5ZWkxcTI2YlA1cG00Tm5ZWTI4Sk9JaVUxRzRNQXB6anhTcURk?=
 =?utf-8?B?clhXUVZvSWZYb2YzdVBZbzJmaXI3THF6Tk8zNW0ydVJGN24rWXJyN3YxeEtu?=
 =?utf-8?B?a3lzOEl6eWllZXBUajk1TzJ6S05qdDdtVmdqYzN2bUVNQjJRaGZoKzBaZS82?=
 =?utf-8?B?dnpoWDVpRkltM3ZGMHJONUd2eE1VeFhScWxxNFNjNkUrSUgvRmQ0N3BEN2Y2?=
 =?utf-8?B?U24wdEI5RmEwUk1uNVFGdWZSUXZhcmNrVXBGSmN5ZXpXR0Z3MlVkcDg1MGtB?=
 =?utf-8?B?VGhPWHl0bGxwU1FYSmxsVkl5dHJZRzJJMmtmL3ZIK2ErVE9JbDNqMkF4OVBw?=
 =?utf-8?B?QkRxbFBFRU5INkY4M0VpdjRobnR6aC9CZjZDQWU0SjZuTXZRL2prUm9MZTdp?=
 =?utf-8?B?NmVEcktJYkNYV1FMdnBTQjhXRGgwZDVKcXBudEhPbSs3VW1ZM0hYQlFhRmkx?=
 =?utf-8?B?T0IwZG9Ob3NYbnNXSWNVQUh1OTR6NFVCVmNxMWV5V0szeG9zc2Z6b3UrQXpv?=
 =?utf-8?B?akNxSC9HSGlXU0xDcm9FNlozRCtFTDFSR1dSVzJraXYrSTd4d3U4OTllWGF4?=
 =?utf-8?B?bVVablhaOTZlSzFodTRnN1ArdVp0VytrYjdFS1Q5R1Y2dTh4MGZhVE91aEJ6?=
 =?utf-8?B?T2hRUm91WHh6TDd5ZTJBV1p3U2NYZTdETFJEMkZOZHVjU3M5VXZoMmZVSmZQ?=
 =?utf-8?B?dGxka2FXV204WDFaMjczcm1pcjRMZzVxcWV0ZDZ4RmJ1M3hEZ2NmWHJTdlI5?=
 =?utf-8?B?Rm5xYTZ3VkRsN1RVbnJyeXlhakNDRnpKNytTQXpvRER2TXZrVWMrTVYvS2VW?=
 =?utf-8?B?UUIxcElpNWxoZi9yMmlocStJRTVaRzN0K0ZGR3B1VW9qY0locU1DWFVTWVBR?=
 =?utf-8?B?THhmQzRhRnlmOHJ3ODV0RzhqSFFCbjZNVFpDak4xci93Y3NzVEkwZVFBRnU1?=
 =?utf-8?B?b0tTTzhlbG11RVdSKzE3aFhJS0F0Qlh4dE43ZENHc0Z6bHFjK0Z4SW1kRVJm?=
 =?utf-8?B?b2hBZThKd3A3QnR1N3FxSk5paktrTE9XRkxPcnJNbkJicXUzR216RVI1R3RS?=
 =?utf-8?B?Wll6TWFjVVRUc2U1OVJnNEk5WXZiTlhWQTZLVXhlSU5oNHgwQldoNDVpT1lV?=
 =?utf-8?B?clVGT1RnUFNGc3VoZ0tIbVRWaE5rWWtXRGgva0l4R09SSk5jSVoyQ2ErdXAy?=
 =?utf-8?B?bjc0WWFCSzR0Zy9SV3o5dXRGWndlbXdRMzlFV3NuSjcrZXRWaW4zVzU5OGlp?=
 =?utf-8?B?NGdGbUFRTWRBNkIzTVZ3REVsRHRnMkJDYkVOQ3pvd0NxVHVaNlZFcHZzTS9i?=
 =?utf-8?B?YWFBdmN3V3gvcE1OOTZ0Z1doQTNZN2ZpcG1qaG0ySkFUZEM0WTZkczZyZks3?=
 =?utf-8?B?enJ5MVBDSkhWR28rRHY0RS9JWUxYWkNmWHNsWGJrSGNEVmV6dmxWTkV2dGx4?=
 =?utf-8?B?R0JoN0pTSEUxV0h5SkluRklZZmYyMlhHU091OSsycHNpMnYyS1RWL1ozM2J0?=
 =?utf-8?B?Um1vTmpvc2MvMitUSlp0MlB1WGtjNVZNZ1JrVmp6Z1BiSkY0TG9KZk5Xd2JV?=
 =?utf-8?B?WDMyYm9abWZZb3hzUXQwU0draUVOQm9xWkV2c3dpUWVLeWIzbmttcnhpcUxv?=
 =?utf-8?B?Nks1dC9UNGwrV2N0UzgvN3ZqT1NuVzlud3ZWZWtPcUIzSm1ackpram1PTDFY?=
 =?utf-8?B?OHF2STUwdFRXMTl5RFpIZldKV3dFMXFhUkxSNGlOOFRCQWd5UXp2MVdzeHZS?=
 =?utf-8?B?NlA2YW5QbGYrR3hyLzUxVlNpRkltVEI2MFp0TUQ1d0FPc3pLU0hQNTlrVXNL?=
 =?utf-8?B?ZkhLVEErNlNxbnBLbmhFbUQ5eDBDMEF1d1dUeTlzU0gzYVlXazB1cTBwMzZI?=
 =?utf-8?B?SjlYa2htQnlKelFKNmVnMy9jQndBdk5wVjYyS3Y0ZEUxU3c3Yy9XRDR0YW9w?=
 =?utf-8?B?bUhNc2MwaFVobWtHZTlzVFVLUmNicFVsaTI4dVJob1E1akh0S1JBVHJrSnJC?=
 =?utf-8?B?OVpuQjc5eFlleVpGNldkNVQvV2lHOEcyWVNhUkNRcHhlVElmYzR1NlFrdlk4?=
 =?utf-8?B?NzJsT2VyeEwrN29OV3RaUXd5Z0hxcmJpTWppWVVqSkZDNXQ3b3A5V2tuWC9M?=
 =?utf-8?Q?yLCVPLKp2WkaCH5m/u4S3bs=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9991364d-8612-4a67-545c-08d9f8516fa0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:50.0953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHi4xf5+fn3lZgAz08MANi+D4XdrD7wTQE1bJLO9RgyA2TFk/XP6TOowpeYxUKuCJf0cBexxOf++ZjKdJZkxeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1428
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBwb3NzaWJsZSBpdCBpcyBiZXR0ZXIgdG8gd2FpdCBmb3IgYW4gZXhwbGljaXQgZXZlbnQgaW5z
dGVhZCBvZiB3YWl0CmFuIGFyYml0cmFyeSBhbW91bnQgb2YgdGltZS4KClNpZ25lZC1vZmYtYnk6
IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDBiMWVkMTJj
MGU4My4uYWUzY2M1OTE5ZGNkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTcyLDggKzcyLDggQEAg
aW50IHdmeF9jbWRfc2VuZChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHdmeF9oaWZfbXNn
ICpyZXF1ZXN0LAogCXdmeF9iaF9yZXF1ZXN0X3R4KHdkZXYpOwogCiAJaWYgKG5vX3JlcGx5KSB7
Ci0JCS8qIENoaXAgd29uJ3QgcmVwbHkuIEdpdmUgZW5vdWdoIHRpbWUgdG8gdGhlIHdxIHRvIHNl
bmQgdGhlIGJ1ZmZlci4gKi8KLQkJbXNsZWVwKDEwMCk7CisJCS8qIENoaXAgd29uJ3QgcmVwbHku
IEVuc3VyZSB0aGUgd3EgaGFzIHNlbmQgdGhlIGJ1ZmZlciBiZWZvcmUgdG8gY29udGludWUuICov
CisJCWZsdXNoX3dvcmtxdWV1ZShzeXN0ZW1faGlnaHByaV93cSk7CiAJCXJldCA9IDA7CiAJCWdv
dG8gZW5kOwogCX0KLS0gCjIuMzQuMQoK
