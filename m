Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60824C4390
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbiBYL0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240157AbiBYLZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:52 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1F72614B4;
        Fri, 25 Feb 2022 03:25:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUTuDXh3IiS2uxMrgCDoqvuGbbbcYflVd7xeaU9i309vT2e8vGVmsFjGAr4p4c+n5zfPwkPRMiaebTexzEpq2LZMZ7AP7RgWf7LIM7vbe4zi5KR304ml+drJVXOJPMJSOR55f6fO9jgUM0y/9gZf/094j8x8S0Dfq1MhjJwChdXNbd/OZia+McC+y6ytbBhMu0rf/bhE6koxqJUp3T2wgm3u1OkkkerMCCi/sgco0wu3gu4xgSyrn4te8yqoNoFiPp5WUAD83hMZUY4MJKFX17KE8WNTJD2YqZgL3+xRKID/o4xnzpw4Ao+nKr//3+nBtcXI+kQvhcpDvJG8NiXMDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFAy+Um3O0RTckh+dCumjqPCOmK2mSPn9LLw0VQbGCk=;
 b=VHnBNIvDzJlHvgOQKy5iHKnpi34iEXwl94AC6GGuRf62G/J6EcV3wswp46AikQRVGx0ICylSMwuiGTYWTtk3loON/vB94OIUqtInPDAflaUvGWj/IM5pdik78UQQc2dKMzjiWrZehgtE0uMfcBzfPYG6CF45Kng5Vjt+GRrHg/swmHXph8RGZT4Ij8siiK06qFYhajUQ0rPD3VtJ8vuIlOGTPGvhl+3JZ/tem9gS5AEtm0tTYoOJDKZJ1zqJr4te0ePlQ/3rZCvPQajZHXZf+ULtxfUZ5juLp+rc27o5xDOJ9B1IRn7dmFI0E5YhDrtxp38yRWXzuC/8B9UoNaLucQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFAy+Um3O0RTckh+dCumjqPCOmK2mSPn9LLw0VQbGCk=;
 b=nHB9Aj8L5fxeDB/nC2s1sw5bM9tI0VOtAt1cJkAVKiNdPYZ+r2tm1kkkaVUcP/v0pU1Np/9SwwCAY/ztP05oKm7vXcpyc0CoQKp7ntm2POOkPe9IRQAlwc8b+c57ISCa7GRq8/vya5j1yaLa7F2pqM6zSBawzx5g7HTtFeQSg4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN6PR11MB1428.namprd11.prod.outlook.com (2603:10b6:405:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 11:24:54 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/10] staging: wfx: flags for SPI IRQ were ignored
Date:   Fri, 25 Feb 2022 12:24:05 +0100
Message-Id: <20220225112405.355599-11-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 255d334f-be68-4d56-ad79-08d9f85171dc
X-MS-TrafficTypeDiagnostic: BN6PR11MB1428:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB14281D8DF6442776E638A711933E9@BN6PR11MB1428.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0noAKHnapktj4wFOAkKphno8mUiWBhORw6/IEbvltzBnVVL4jc0BVvCqo1qGU/gZlKoSsNROeYGj9U2H+iNaqQQThfE38vZg136fcH3h9jU72/HGmgG5pADge/7vLvqOlpRliYEKUcuc3KlL/NAMzKXuijlDDMF3aK+um6gc7XRzB/lyhMJahWz9D7bCBTrFR9ZixBoIwuAqbdwzwsINgTnkZZHI/fBQYu/kt1r9qFoWt1u8Uyopm5I27YiNKQt2LJitJaJIJabv2eujeOnX1bd1ZtMvd1dXGrnCluC985s2Kyfet3iXV85kEjI0TwaQdOHEgY0dhuUxhitDO5kYCjxVIECURr8GHzmiqBq03fLaH2+3OgyxqBmC2YZ+/AVmkzq5KXejJeq+b/4phD6OWuTgvHre+1t5HJWdL437/0ntEwB7nKXwQcK1RPhHrS3QRvLkEw+UeMNqxzLKl6uL3hLwg7YjvX+adCzdTZTm5fldNtyx2qV8/zXq7wtCX53AHhVpV4gbFRXFxVaHCD+5nED5Dsx3NI3CLj97YKwE+0M8VG/HNbvVY7HRRg2DIjMY8xKq73S+zeBxBvt0K1nVn1TBtvXujjlei6kFSQ6+9n1UoEWvCkeDcTsiXZaHYM33hJvdumiK8iZBJZRLNYdnOkhEQAm/mQyjmA5YV9hXkqJeaJwAlJca9xYjYlIEuAFFNydoUIkBDZ6XtBv0ZGqFnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(36756003)(66574015)(107886003)(83380400001)(6506007)(6512007)(4744005)(8676002)(26005)(8936002)(2906002)(38350700002)(186003)(5660300002)(38100700002)(1076003)(508600001)(54906003)(66946007)(66556008)(6486002)(66476007)(52116002)(6916009)(86362001)(4326008)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3hlQlBpNTBqNVViNW1LMkQzQmc0bkF2V2dJdjJkQ0lLQmJHSG9iT0NRN1p1?=
 =?utf-8?B?WHNiTHV4RUlBU3ZkVGZ3WDhKSjB2S1N0VVNBYzVpZWpTM21mMWVpZ2VjMFRI?=
 =?utf-8?B?WVNwZmVkMy82Uk0xbWVMOTF0Tk1mWWwyVjVtd004YnF6ZXpsQWZXRzBWS011?=
 =?utf-8?B?d21JV3hoTVRteUFWSDAybEVnbUVubFl4WG9IY1pKYU55b1BZclphYjRaK2Q0?=
 =?utf-8?B?SWIxT1duZ0hQbU41aGZ2OURHeUxWWVJhbzFsUURLZkhaK3lpT29RTXB6c0tQ?=
 =?utf-8?B?aHYwbGRwenkvUURoeTFKZ0QzVVdjZm5VVENjVnZnV2I2cFFEbVZMMVNVelF6?=
 =?utf-8?B?ckZFbUlFNi9GK1gvMlFmWUVtcnYwcHlvdUJ2SEFwbmpCa2cyZThFRXFjSWU5?=
 =?utf-8?B?bHpzZTRUZnloNkRhRUJBN2d6QmtKSE1rcjY1ckR1bnJPUTZ6eXBIU011Q0NW?=
 =?utf-8?B?bGRHS3JKWUJaTlBlVExQSFUwL1VNRDVtbzdyS0FPU1BJcnpEVlVYR0Q3S2pa?=
 =?utf-8?B?eVZweFViMlJBRkV3Wmh6dmNvRy9DM2ZkMnVobjRTVmljemt1alpHYTQzUlNj?=
 =?utf-8?B?QXhmY2FQTEtrWW8vNmJveUhpZ0svcHRKa0cyR2I0VXAyVEw5OXAzb0p2MWpw?=
 =?utf-8?B?NWFqa3Jhc0JiQVpSdHFvY2RYV1h1SEJyWVUwRFJxc080b082ZjdCeUl5RGdv?=
 =?utf-8?B?cFZkVlpoVmtOUm9UaEprN2dyUHhrRlN6QlFFOGtTaUU0Q2ZmRms1UDhzdmw4?=
 =?utf-8?B?WjRCWThGSGw3cTU4WTh4d01WYzF6Q2R3SDdLUFFYcUl0WnVjSTExSDdiMFpN?=
 =?utf-8?B?ZHgxT0xCWTV4OVVGUzM1Nk1YN0pSV3dKWitQYzdGYWRMeS9QNUV1YWlWN0pG?=
 =?utf-8?B?MHNPeU9id2JDalRrTTcrOXI5T1BhZVViWWhGL3BYb0hNUzdmajlHT0M2SWkv?=
 =?utf-8?B?TGovdTJXWXoyck9IQ0VuejVsNFloOFZLelVXMkt3NU5ma2xwY0VPSDJqeTh6?=
 =?utf-8?B?T3dEY2JBT1Z0ODN4RGkzL0E5OUJTRUJOS3RoekI1NDRmM0Q3bHoyTVNJdVY4?=
 =?utf-8?B?VDFUTythQSttTHZJK29BaE1ZN3RNWWtUQnBLN1d6NXMrLzk1NVRlU083SjNr?=
 =?utf-8?B?anFzWEw2aGpoVzJUbUIvK1pZUGw5dEJuY09PQkVkZFNNQnNXLy9wdFBqQ3VJ?=
 =?utf-8?B?MVdsQkdGbjYzU0pscllLVGhESU9PQmNxZnhSbU92amFBcTJRYzRNTERVbElm?=
 =?utf-8?B?d0t2cE5EUVlleXNXeTNEVWdlWFEzczlxRGlpZkNqaUpLMkVpQ282ODNyVGpo?=
 =?utf-8?B?a0JSZVFkcmZ4bExlLzJrZC9MWmVpZDh4aXZESlZYbzN2RUFlRldZVEwrVGtD?=
 =?utf-8?B?bWZRR09mTEFjS255T21jRXFVTHMxSnMwQk1sWXVLSmNOazFuTFcyTlZRL0do?=
 =?utf-8?B?WUtwVG9vQ1V0TXhsNkhZdzBTQnZVc3UzQjUyK1RyWTE3MlErSk52TmtlbVp0?=
 =?utf-8?B?NkI0YnJ5bzRiaW5zV0RtMS8wK0hwMUc0RmZQT0FGMHIvbDN2SzBaT1F4dXA4?=
 =?utf-8?B?WjBlcGc0dXNzNDc3WDIyaGxHcnN3dm5qeFBvNHdJTDZVNy9sMFNOSklWMkxO?=
 =?utf-8?B?eWVZK0ZmZGtPVXBjdC95UDV6ZXRBV3pKUjV5cnljZi9TL0tvb0xDamVuZ2hW?=
 =?utf-8?B?dHA0TkF0Zk53aXNzd2RIeG8yTjQrbXdlOGtZdGJOYVNESVhNd3hqMk1zc2Vy?=
 =?utf-8?B?eXErMGhwQUh2WWVyOTM2YXh4SnFhNGppTFJ3VUxkTVUzVk9Qb0ZNMk1aN0JX?=
 =?utf-8?B?OU83RHAyY04wYXJpSFBUelhZT0NJdTJIOEI4QTVOdGxZbUxtOXJwdTh5ZDRH?=
 =?utf-8?B?TnN0RVYveXgyRmdxdGlwcW9iYlFFeXZNSy9WYVlYek5Sc01WOGpJQWd3aTZt?=
 =?utf-8?B?YlA1MXc2clFtVGpvOURUbHRybTZ2Z2s5KzZhdTVFL1RyeFRiMU9MNi9pNTNv?=
 =?utf-8?B?czBWeGtmMThBbnZZMFViRHNOYkpMWGMyT2tXRHNTb0VjeGQvVVJxMW94QTFR?=
 =?utf-8?B?NmtLdVpxNkN4Wk1IYlc0enE4aTA0QXJwbEhseFVBMVVBcEdNaFFZcW8vQlgr?=
 =?utf-8?B?WkhzeVNsdEIrMFF2ajhyTnc2cnNKdWhDcENuZkoydkI1b2VLRCszZ2tuYysx?=
 =?utf-8?Q?ghQbmkzCrd8Mwl6suGTJjx4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255d334f-be68-4d56-ad79-08d9f85171dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:53.8631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxwSQXMgrVnJInIGZ5a+ZeUQ1A9JvIuFvjWcXs6yP1KzbFy6GRrkDqCvUW++8PDvtQhhUcFWRRUsA2yUe/6g2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1428
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZsYWdzIGRlY2xhcmVkIGluIHRoZSBEVCB3ZXJlIG5vdCBmb3J3YXJkZWQgdG8gcmVxdWVzdF9p
cnEoKS4KCkZpeGVzOiBhN2VmYjYyNTA5ZDggKCJzdGFnaW5nOiB3Zng6IHVzZSB0aHJlYWRlZCBJ
UlEgd2l0aCBTUEkiKQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMgfCAy
ICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvYnVzX3NwaS5jCmluZGV4IGEwYTk4YzA3NGNiNS4uYmIzMWY4YTAwNWJmIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2J1c19zcGkuYwpAQCAtMTYyLDcgKzE2Miw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NwaV9pcnFfc3Vi
c2NyaWJlKHZvaWQgKnByaXYpCiAJCWZsYWdzID0gSVJRRl9UUklHR0VSX0hJR0g7CiAJZmxhZ3Mg
fD0gSVJRRl9PTkVTSE9UOwogCXJldHVybiBkZXZtX3JlcXVlc3RfdGhyZWFkZWRfaXJxKCZidXMt
PmZ1bmMtPmRldiwgYnVzLT5mdW5jLT5pcnEsIE5VTEwsCi0JCQkJCSB3Znhfc3BpX2lycV9oYW5k
bGVyLCBJUlFGX09ORVNIT1QsICJ3ZngiLCBidXMpOworCQkJCQkgd2Z4X3NwaV9pcnFfaGFuZGxl
ciwgZmxhZ3MsICJ3ZngiLCBidXMpOwogfQogCiBzdGF0aWMgaW50IHdmeF9zcGlfaXJxX3Vuc3Vi
c2NyaWJlKHZvaWQgKnByaXYpCi0tIAoyLjM0LjEKCg==
