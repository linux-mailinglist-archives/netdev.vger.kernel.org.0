Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B024C437F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiBYLZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbiBYLZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64811DBA97;
        Fri, 25 Feb 2022 03:24:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvTp0dteQO/R5/fuvq41FnlcyCD+m9LLLPuhVrvrWoDk7y7i/FCH5Mb8zRGyTy37oaGRoH1A3TP1ExAj0UnFY+46G3BRE/pHqFduqbQKus7P5q9S79PwuT6nv6eXmu99XUAkR+s2ufU0c2TKO1kDG0V0q93ARBUPiSlYcDRsufUu9XOGMIsLXF100EYajY8HpuNQCWxtpnhzYi2VYJcVzVveZTdA9vaBxv/gVpf9w1Htbmr7ThqAbWRh/tZMX3egdCH6OnZRWV7P4+ECYuf7VsZhWJx3S4RYHKi7UlfjYlNDXsV3s7XBTx4rzMfvNGzLHBvZxOVSCcsfJ+3+3kb4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPgAmOkX5sJxMaWem9w9O563KMNa+WJAEihzAKyai/c=;
 b=Xzb6X+UQt2gXs0nSwF+dl08tSktailfhr7dcOQ8aZ9jpL0SoJOA5X4MWnLfI/Pbnxx1YJUmoIettAGLTLtQvuOREG1+lcJ9Np7TNS9AZVNA+ml7x10H4witTnnEvG/A4Q2aUxUNZp3i7f/CUjls+n0lShOVgLDNILRBBtYTrhRje/SCD2pglF0BqpeY/hBxw4Iypym/P3f64BW5grvhLICw9an518FszNibDU9fvefNXPPnqhhifOUcgKfJkxNf3hClIwHbi6KnEXasMEky0vsEYEXry2Y5WZwcgv1HBmFVYFPyBkTv03s+ccsHOfiGBOCEOJ74ePvB+HrbpMdDypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPgAmOkX5sJxMaWem9w9O563KMNa+WJAEihzAKyai/c=;
 b=fyPnLhf5/M8AJfoWgSbKwvOMGJFuzfTBaSo5mqk4ne3EuFQJwmmlbByFFCplXEylbWb6LmyL8GktjzS5Djhz8niR0cHEA3QwZgwsLsAeRbQo/+QRTQ3APdlwkI5ech3U67pdAEGQ0Ky1QFhDBQoA+BmQtflPdmOVmTZevq+BxPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN6PR11MB1428.namprd11.prod.outlook.com (2603:10b6:405:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 11:24:48 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/10] staging: wfx: remove duplicated code in wfx_cmd_send()
Date:   Fri, 25 Feb 2022 12:24:02 +0100
Message-Id: <20220225112405.355599-8-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 43e7a45a-8628-4241-6cb8-08d9f8516e71
X-MS-TrafficTypeDiagnostic: BN6PR11MB1428:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1428B7E293812E55738F9AD3933E9@BN6PR11MB1428.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTEU1WqzsgbmGw1BpvjM0z4lmRwqsJXEG4W3Zp86oQ2La0v70ixL6HEVZ92j2LmQtdjGugQ1sT2evV5KpADMiVRL6pZ53juADtC/kq3vINPReecHFEQQjFMXsJXIlNacjLXqfjfgu2yUV1QxWg0Vp5CD+uMPF4D3OawjsFXV4YAqZtW6/NlJo0Rpd8UvyTtqVdyCZ3oVwqQFoHEgrWjISqbNG0128YamPkyJdlDIhrCHT7sH4eor9rHThewkmxMNT3f6c/EC2+ithBIitB1nf4T0p6CI+MSOZw5BeORbIyk26Uw5EOcbqnc27+KWiyAhouMozxSL8wH9hXnh3RLsGSt05bdpxpPtelQLw69g1EY3/yrnQzdMUd40rYtRfMs/R9AN2asmYs5d0Yw+1gfi9rScsfpO6/ZniJOEMkoSICEONdNueAAm75fZr3R6ruGUczTFiemRG8A9aehjFZ+MnM8RKdPs7r9aPocOMncdwqKwxUFUGZJZzlY3ZuYvsl44dcv0izgP04/DZE9bNcCv2mKa45ylZbVoDoCPt7a9d3x9MkAa5UPpfOTaWoU6SLxyd3+QWBoZY9UmTEBPxh08IrOv0Q3pimR1Ta7zF9ORagMgdI2GWUDNNJ2xwMCb7ZFKpllnItzq1lV4cIfo5OwM5EYE9FqKSFRz89bvk0H6E5q91B/5CCUIcIxlnKlfOMoCBI/TFRuFUnkFMp6holoq0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(36756003)(66574015)(107886003)(83380400001)(6506007)(6512007)(4744005)(8676002)(26005)(8936002)(2906002)(38350700002)(186003)(5660300002)(38100700002)(1076003)(508600001)(54906003)(66946007)(66556008)(6486002)(66476007)(52116002)(6916009)(86362001)(4326008)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0dVQm1FYXpCTHNLTzdycWp4d2trOU9INDJpUnhkZkF3SWM1ZWlBUThEK0o1?=
 =?utf-8?B?VWoyNTRWd0xVWGNpSFN3V1pGd3hiQVJDM2VUeUFJSGR1U3dTSUpaOVFYYjdk?=
 =?utf-8?B?a0U1b25jOHQrVVY0bENUM0NrYnRKZmUyTlpmakZsWHNlRDZYRjRPVEtqdCtJ?=
 =?utf-8?B?R0d3eG8wZXh0aEpZeTdqdzR1QWlROGJtZ21FRW4wNWMzNjQ0dlJqVktJNHd2?=
 =?utf-8?B?Q2ViVzArc2I3Y2J3K0drRHJINWdCaXBlbmE3MjVwU05FMmxqRGRwWHJnM1pV?=
 =?utf-8?B?Q1JMMnlkdmtyd3lpVDBDK1V5N3RkV2g2bmRhNkxFdzNyN0U3dGdFczBKdmpO?=
 =?utf-8?B?TmtsOS9wRjlaMTNleG1CVUZ5aVU3VTJ6M3ZlcGI5bXNpRjFvNkRxaDZYblVJ?=
 =?utf-8?B?QVVkTHBBTFhrOW13RmZWai9PR21Fc08yeXQ0MnBwcjIzcXdyTGZmYUt2YVIx?=
 =?utf-8?B?RDNXMzNScHdzZFZUUHBXdUVmQnZ2WUJzbFhCNmJqSGRvU0tSRUpJTG9vTzd6?=
 =?utf-8?B?YzZMT0VpT3doYWtUK2xYL1NBeXdiSkV4d1pnemlDWmY4ZWdDZysyeFRPMjRS?=
 =?utf-8?B?NnU4ckE5OXhhNkF6N2Nmakt3WWdoUU1uNG9ZNFJ5VmZWakJ0MDRzQytXL0xI?=
 =?utf-8?B?dnRWQTRSQ1JXWjkvS0p4bjdYY1ZleDZCdVMrMklNdDFnREN6d3RhdGdGZ2F5?=
 =?utf-8?B?c1NiamlXQjI0UXp5dGFkQzJBSjVObExDdmVqbzc4dEtIWm1NTnMwd29KNkZw?=
 =?utf-8?B?U3JudlJRR0J2ZzQwQStMTGpMV0JuUUxmR2d4VFFVN1YxclZLOXc5dng2TktJ?=
 =?utf-8?B?Zzk0VzN5YVhCU25VS0QyayttbDREZEFuTWZubHpEc1JMK3RZanloMTNTdFhZ?=
 =?utf-8?B?NkgvYTFMZFdOK3FSV2hpMXJ1c3BuVWg2NmRWb3NROGt2WXFCVnZkUklhc2po?=
 =?utf-8?B?Zk9sRW1WNjhVVVVBRGpFTlJ4WkRMRis3QUFBOWpqTmVVeDdBRkFuaTFoNEV3?=
 =?utf-8?B?SDBuVHZMdGJnSGl0N2p4ZFZyWXBSeHhjbUFhN0hYaStTNG9BNUR3Y1BBTEhN?=
 =?utf-8?B?UVVQdGphQ0haYVZIc0lnMitCclp4elkvSlpSS3RjT2hFRXhxMlAwUk1Tc0FD?=
 =?utf-8?B?enh2b0RiQ0wvK3ArWWh3bGVqQUtoUksxZkczVi9KTXR5dkNrWjN0ejR3TEcz?=
 =?utf-8?B?TWRaNEc5NmsyQThWZlhmMXVLUEF1dDl0dVFNaWk0cU1IYlhwMFhuRW9EOFRS?=
 =?utf-8?B?aGJwK0cxVDFLRGhhcWpFdGh1anIxdWFoenE1Mk9nVWlNZkhUSjlMUmliYVVk?=
 =?utf-8?B?YjBpTGpmbTVOeVNJcmt6ZEFYTDVNZlFoYUVIckRCUVl1Zk1JeVliaEZKS09z?=
 =?utf-8?B?dzZJUFJOai9DY2NjMUlyVG5jMm95aDlnUnVDNFkyMlFtMzZIVEFMd0NqaS9l?=
 =?utf-8?B?YTUxR29WcytjTlBTQkRtdEl2UGNnVlY1YXdDUExBSmxkUjF6NEJiTEFpa0hi?=
 =?utf-8?B?TGtJUGQ0enJNbmNaYWxMMndpKzl3UjZoVHJtVnE0YThGNmlPL3BtT3VBc0ZT?=
 =?utf-8?B?OC9WSHh2eXlIWUE2cUNxUTI5cElJN2hXK3luVjIwZTd3U3ZMWlNhNTRDekhz?=
 =?utf-8?B?WktsSS9aNWhGWFFBT0g5TWlCVkdnK2cvem0wbmRJb3RUTTZpbTluQWlla1k4?=
 =?utf-8?B?a1JhYVQvWkVVekg0ZjNja3hqYnBxQ1VIOW1UL1dBRzBpaGJWak9KaitrTFNQ?=
 =?utf-8?B?a2o5V2dRUnZRK25SZHFhQzJVTEc4dHpncnpTMTh3emxjU1duaEkzc0M1cmhL?=
 =?utf-8?B?bHFJeDduN2svQlpHbmpQS2tpNkR3dVo0WkFrVUtwd3EvVmZFUERHT25taU5O?=
 =?utf-8?B?VlJQTG9sem43c0Z3NnJIOHpNSSt4MnRHWHI0emd1dHdjd3U1cmg0Z2dBL1hx?=
 =?utf-8?B?eHVnKzNnSjA2Qm13cDF1akZrOHlEd0VUMUQ1M0ZPa1I2NUs1a3k2MHVQV0dD?=
 =?utf-8?B?eXlUNWs1cmc0RWtMbEdpdkp0VUh6VzZuZzEzbFlFcUh4ZGtKbyt5RXl6WGZM?=
 =?utf-8?B?YTNKTWVPLzdMSXpWdEVKVWJXUmVQcUJuQlVmTEpuaFk4S0hkZzhIckhWQ1F1?=
 =?utf-8?B?VFVRK29aaVhyOTV1L0dzK0V3YW9DdlBFWkNyVUhrTHc1VzY0OXNBWlFjV0dK?=
 =?utf-8?Q?yFW572Cn/KPYuUYmFbgiYWE=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e7a45a-8628-4241-6cb8-08d9f8516e71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:47.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jIB1XFM3XD5FOZL6SGWh0abpZd5nNzaOjsy4GseNf7qejiavaIYzY8qD9PL0GnsIdiwuPDDtJdZHJLoFC/YRw==
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
IGNvZGUgdG8gZXhlY3V0ZSBvbiBlbmQgb2YgdGhlIGZ1bmN0aW9uIGlzIHRoZSBzYW1lIHdoYXRl
dmVyIHRoZQpjb21tYW5kIHJlcGxpZXMgb3Igbm90LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAyMzZmOWQ2MmUzYTkuLjBi
MWVkMTJjMGU4MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC03NCw5ICs3NCw4IEBAIGludCB3Znhf
Y21kX3NlbmQoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCB3ZnhfaGlmX21zZyAqcmVxdWVz
dCwKIAlpZiAobm9fcmVwbHkpIHsKIAkJLyogQ2hpcCB3b24ndCByZXBseS4gR2l2ZSBlbm91Z2gg
dGltZSB0byB0aGUgd3EgdG8gc2VuZCB0aGUgYnVmZmVyLiAqLwogCQltc2xlZXAoMTAwKTsKLQkJ
d2Rldi0+aGlmX2NtZC5idWZfc2VuZCA9IE5VTEw7Ci0JCW11dGV4X3VubG9jaygmd2Rldi0+aGlm
X2NtZC5sb2NrKTsKLQkJcmV0dXJuIDA7CisJCXJldCA9IDA7CisJCWdvdG8gZW5kOwogCX0KIAog
CWlmICh3ZGV2LT5wb2xsX2lycSkKQEAgLTk4LDYgKzk3LDcgQEAgaW50IHdmeF9jbWRfc2VuZChz
dHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IHdmeF9oaWZfbXNnICpyZXF1ZXN0LAogCQlyZXQg
PSB3ZGV2LT5oaWZfY21kLnJldDsKIAl9CiAKK2VuZDoKIAl3ZGV2LT5oaWZfY21kLmJ1Zl9zZW5k
ID0gTlVMTDsKIAltdXRleF91bmxvY2soJndkZXYtPmhpZl9jbWQubG9jayk7CiAKLS0gCjIuMzQu
MQoK
