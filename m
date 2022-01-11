Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643E448B324
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbiAKRPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:15:22 -0500
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:39649
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343976AbiAKRPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:15:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dM/wHbJ+r2byu/8ipPlVmVDGY1f4XNxDIxjT1S0IGf6wEAKxTSxVvnKF037sR7ppcUtmqDZxygRtBdSp9NbBMQETc2aKCRh3zr2k1wlpESrh1xlO+DzdpTczfS+aJ7KF7/2d2fas832WQA29010YOGlSWUJyLN+JuixTjkMOuCXIW+twkOeJZNi2MPhNvJrqIoZFYKs50TIWEshh6AWFDk9Hy4laPigjFSC1+ZFfWzVqqB52dY8iA4lEOv9QiOeM3AF/41FVt2PkCa7PdAHXShQbiWbOf5d7ZI+lda5hRyQhmF+AXQXJvqJZZ303qGNgNzv2vmRnzDtkg7AJcqDEZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxafUeTrjRBMOvhFqc7T9fokBdFCRRo28IEbjW9kUoQ=;
 b=ON7GEZwwBM4qunA8Dr0mzo5Cy/BJy0eC+n7fDP1HlI8A9svpyiiMYMG/CS5fqBtmWjYIkv+2Bea8F6IgqOAAdpr2Sndu6tbBQR7m7RYFDdnL12Zp3mdxHndvDqucmMBv7/A+OXj32+AGy/fu2F2m6+PT5l1JtqzAkZ5Mzc76unf5vms0sJbDkoaUdfxz+BX5XgxgTTzN5mJcaS0JrwjtuDDSi0xubgG7w+xeeU3icp2j9AICmN5YpDfnUzdPPTCZCxWGC4/GwWnoiz1/KjR90SUgGR45OSpzga9WoutT7qpaq3UqlIx7p2eCUAMC4/1dDOA+NC/LVHF3jtB9e+k7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxafUeTrjRBMOvhFqc7T9fokBdFCRRo28IEbjW9kUoQ=;
 b=RXT49z8bmI/DmuhO4QVTfhmlS0mkbqmC2HXd73IFHnK0Xrgr4HE+nbsty8RzGyqzhLxJLpXkaZ187qP7zmuJ4vA25uppUDL9XfRSZ+m5w+k62l/xNuEXf6tmtwZvYU+wA+YgB2Uk0iWXDT3s/xBwvQtWU+O00CcMJCs613R3myc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 17:15:02 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:15:02 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v9 06/24] wfx: add bus.h
Date:   Tue, 11 Jan 2022 18:14:06 +0100
Message-Id: <20220111171424.862764-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b6f776f-a68f-409b-84ce-08d9d525e714
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5595B2A15C7EF5ACA6D6B33993519@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFu5/+mammcpkxV9VVa+rulshgXANJKYCsDJlSTibhTUTuuOponEfi2crYKB6MysLlPRaduZVz6x9kE2bd3JGLsHwswtiKdjAOHpULkSFaKbWecD3aVNDE7Rn+NaawjvQ1SBJsW1X4qtBeZ3QjDf8pFOa0+b7lz7GCg5ptIVkZWFeVcpXYgsJ+iRvvoSOUlumSpHdYF7iip2rOsTj1Of6N5lXHBIcrwI0jjvERAmac+W6sRxObb8R0sV4fJgTUvVzorzzPy+Ikn9hD/vpX3lNbO9SUGk5vtw6jKBrk8nHymQ43Xc7iIflghVwv+62e0srfNbqiSgBKQ8tNeCEO0WkgF1Drc8ZZAvI1f+xKBXFtFwIFPa3vGZOwefyKQPMLs8UsepME6S78cWFKY1AHTFSV6Pd9GRs2FutTzQmOMmAqGRlU4/FCtFlIr5Oe5oPQSXNYfM40o9rSpdB7Wxva8XH4/tpsrchq406A3h7kQ6czf81k+iBVEkPVLxcd9gVbH39a07CWfeWfC8p+3BDarol3PWt6O61gEMgMXDtWbvBKCgrcEykci5CaloBELHfRYtWpplhF7m+Z/bMxjkMjOK+dWtOHOPyhnPM0aiygY4t15G0B2jy/AciDPQ3JwvGPcUoCnSnkuPPh/FXyVwWQsb7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(6512007)(2906002)(107886003)(66574015)(8936002)(2616005)(7416002)(38100700002)(6506007)(4326008)(66476007)(8676002)(54906003)(6916009)(316002)(66556008)(83380400001)(52116002)(86362001)(186003)(5660300002)(6486002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDU2L01MOTh2dXQ1VkVMNnhXS1hUVlZpemRLVkFpcFpWa2Y3N2dnc29ibXl1?=
 =?utf-8?B?UDI1MXg2aVRranVvM0xUTjMveDhHQzVMSkl6Q1EzTHhlSDZFeTl1azNXZ0lF?=
 =?utf-8?B?RjdOZHZkcGZuZ0wyVFpybTRFbTBvQU0zdEJFTG5NcnNkc1orem1sNGNoZ0pq?=
 =?utf-8?B?eTNpZld2UmZqL3lGVEY0eGRNU2h6V0dTN3NOSlpZaUN6YUlZZmlLM0dNRUE2?=
 =?utf-8?B?N2ptY2RHUGVsdGdJSUVobnlEd3BFbUZ1SmpGWkU1YzlxU3h0bS90S0srMmdV?=
 =?utf-8?B?dmtOVXVidWxRQXd5Mmp4d212a2RqczU1RkovelUwdWxrNmMvTHpuR0lkY2U1?=
 =?utf-8?B?eGl2VWFkWHVSbGcybjMxZ29FeWFFQ3pwVDVpTXlOczVuSWhyVS9haUJ0bHA2?=
 =?utf-8?B?OUN5Rmd4OWpvdzJzemNjODlLaEd3QVJML1BqV2Z3NDBZaFZwcWFHTUJQRnM5?=
 =?utf-8?B?UllqTUxhaEZxRGo2ZFJxZWVzSWpKL0Rydm5OdzVBa0x1QzZ6WlVZa2xrYnhr?=
 =?utf-8?B?ci9RMm1OSW8yOTNVOFg3NW42R1hUSDF4dS9VVVpOcjFtU1B3TmtBUVJWUk5L?=
 =?utf-8?B?TDdib1VLZHV1MlYyaG9NUlc2b29BYVJ6YnV2WDVqTHBGZWtGREJmUzNMUWRq?=
 =?utf-8?B?b3NPeGEyNUxicFlEWk5aSHU4ZHhQaVpZdVVFcGxmb2FGOVc4Ym91ZkQySDg4?=
 =?utf-8?B?Lzd6bnBLS3pLd08yem1YYTlZNVIvcDV4R2ZFTWdESWtrOTRWZWRBZTM4Nnc0?=
 =?utf-8?B?MDNLZ0Ivd2FXTkNTZWZhaktZcVVpcEp2T01QeXE5QmVVcyt1cTN5OGduYnBs?=
 =?utf-8?B?eitHWVkwcHRFTDdJNmlSZGFGVVROcXdvK0Z1VURyZXVaUzJXYXdkYytKNUJB?=
 =?utf-8?B?bDBiVGhMdStPcXBmcWhZQ2hVUHhkOU03aGFPZTNlM01XZGZ1bDlOY1BmaWNX?=
 =?utf-8?B?bGhlM1p6OUcxOUZpb1RESVhlSjF0MDRwemxmYk1MRkdad2dvdjFaRDlrWFJv?=
 =?utf-8?B?aEJWNjNMU0FUUjNkWkdDQlBQR2xtQVVRRWhRbDlDOFIxKzRrMVV5QU5uYWg0?=
 =?utf-8?B?c2xKYnMvMmpXU2VvV3I1dDExd3lZd2hHT1pCRHZDMi9vWHY0YnI5QU9PclM1?=
 =?utf-8?B?SU1WL2QxeXV0Nzl3L3E0czR4VXJJcHNXMSsrcm9NNW1XQ0cyekd4QkswNDAx?=
 =?utf-8?B?NVNPSGI2VnhCZUJQQmFydUFNWGorUFZIempMaFlCeTdmaWVoaUcvVjM1Q2Js?=
 =?utf-8?B?NVBHbGkzYnNQYlBxcjZaUUJwNE8zR2dqcnZuMGE3MGwxK1VtRCtlcDNRZENX?=
 =?utf-8?B?RWVRbU1hcW9PVEJ0eWVsM1NEU0VTWW5rTWUyUHhVRDQ1ZkJaWGxtSkgyRzRm?=
 =?utf-8?B?WkFHeXB6bGQ5K0pyQkdyRzhFS1hXOExQZUZDeDRCdlRvUElQYmNaaUZHWDNQ?=
 =?utf-8?B?WkhPdXZ4NGVGUnYrL09uOVAyWUxPRkNMTXVVWGlpUk1LSjgyS0ZvS3VubWVB?=
 =?utf-8?B?RS8wdk1mS09DVVloUkl1RXdudTRsaVpLTG96RnhSaVpTWHFES08vV1QwVk9Q?=
 =?utf-8?B?L1hkUzhRb3FnRkEzQk9xeU9xSW5hc3NLWjkyZUpETEdLK3hiSlFia1FDUDlJ?=
 =?utf-8?B?OUI1V1pvUWhybFNGenlCOHFhMmRQdzdRWlNJa1YraXpGZVZ3WkpNWFF0b2tQ?=
 =?utf-8?B?M2paTFpwcVB6eDhyWGlsb0t6RUVnUmdVM1JkS3pjUzNoNTQ5VmtQV0hHTWRE?=
 =?utf-8?B?R3o2eW1aOWNTU2d5d2h6OVlUQVh2dGJ0VlJBSk1saXY5SlMvNnVPZ3hMTGlX?=
 =?utf-8?B?dC9kZEozaXhiYlplbzdpRnpUTy9TSXE2SnJIb285KzZrV0lpRTNUNktyZVRy?=
 =?utf-8?B?N3p0ZFVWNTV1UTZ5TUZ1Uy9jZm9IQlZOb2dObjJDeGs1YmpzZTFpR0dQMXFw?=
 =?utf-8?B?MW9TNXIxdHhzYWZyY1RyMW03aThuaS9CU3VlR3Y4S3JMdG16VzRQVFlqN3dq?=
 =?utf-8?B?VVVNZ3ZmYUs2blYwSzZ1MGgyY1VpNnJUOE5GbVRBdFFSOFFPbUNxalltYTFX?=
 =?utf-8?B?VERYdUZsK1NQaEFjK1lHV0x3bDZGaGJMcnNmdzd2c3N2MXo1R1FxdGpOR3hi?=
 =?utf-8?B?a0pqelJpdU5GMXk4ajFpdnh5UUlGY0FrOTNveGNROXErWGplUWtKNzloUkZ1?=
 =?utf-8?B?WU5sRUNRNmFwVVBjM1RjR2xhNnNYTSszZ0xBOUNJSVJsNDJjOEU2cHp1ZndC?=
 =?utf-8?Q?oB8oLnEU2WlC7SWPFgwHHxFtvkQeyxh8Fjgnx23p8Y=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6f776f-a68f-409b-84ce-08d9d525e714
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:15:01.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4alXcw2LrU+1JeJbO5hx4Cm9GJkzOetGyGZFObpygBu8u/Y8KXQ+sB6zFhZG0q8uQLQXZKSaYbbqrURIMHthHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggfCAzNiArKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2J1cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAwMDAwMC4uY2NhZGZkZDY4NzNjCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaApAQCAtMCwwICsxLDM2IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogQ29tbW9uIGJ1cyBh
YnN0cmFjdGlvbiBsYXllci4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNv
biBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24K
KyAqLworI2lmbmRlZiBXRlhfQlVTX0gKKyNkZWZpbmUgV0ZYX0JVU19ICisKKyNpbmNsdWRlIDxs
aW51eC9tbWMvc2Rpb19mdW5jLmg+CisjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgorCisjZGVm
aW5lIFdGWF9SRUdfQ09ORklHICAgICAgICAweDAKKyNkZWZpbmUgV0ZYX1JFR19DT05UUk9MICAg
ICAgIDB4MQorI2RlZmluZSBXRlhfUkVHX0lOX09VVF9RVUVVRSAgMHgyCisjZGVmaW5lIFdGWF9S
RUdfQUhCX0RQT1JUICAgICAweDMKKyNkZWZpbmUgV0ZYX1JFR19CQVNFX0FERFIgICAgIDB4NAor
I2RlZmluZSBXRlhfUkVHX1NSQU1fRFBPUlQgICAgMHg1CisjZGVmaW5lIFdGWF9SRUdfU0VUX0dF
Tl9SX1cgICAweDYKKyNkZWZpbmUgV0ZYX1JFR19GUkFNRV9PVVQgICAgIDB4NworCitzdHJ1Y3Qg
d2Z4X2h3YnVzX29wcyB7CisJaW50ICgqY29weV9mcm9tX2lvKSh2b2lkICpidXNfcHJpdiwgdW5z
aWduZWQgaW50IGFkZHIsIHZvaWQgKmRzdCwgc2l6ZV90IGNvdW50KTsKKwlpbnQgKCpjb3B5X3Rv
X2lvKSh2b2lkICpidXNfcHJpdiwgdW5zaWduZWQgaW50IGFkZHIsIGNvbnN0IHZvaWQgKnNyYywg
c2l6ZV90IGNvdW50KTsKKwlpbnQgKCppcnFfc3Vic2NyaWJlKSh2b2lkICpidXNfcHJpdik7CisJ
aW50ICgqaXJxX3Vuc3Vic2NyaWJlKSh2b2lkICpidXNfcHJpdik7CisJdm9pZCAoKmxvY2spKHZv
aWQgKmJ1c19wcml2KTsKKwl2b2lkICgqdW5sb2NrKSh2b2lkICpidXNfcHJpdik7CisJc2l6ZV90
ICgqYWxpZ25fc2l6ZSkodm9pZCAqYnVzX3ByaXYsIHNpemVfdCBzaXplKTsKK307CisKK2V4dGVy
biBzdHJ1Y3Qgc2Rpb19kcml2ZXIgd2Z4X3NkaW9fZHJpdmVyOworZXh0ZXJuIHN0cnVjdCBzcGlf
ZHJpdmVyIHdmeF9zcGlfZHJpdmVyOworCisjZW5kaWYKLS0gCjIuMzQuMQoK
