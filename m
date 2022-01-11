Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD248B381
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbiAKRR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:17:56 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:7776
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344274AbiAKRQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:16:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXjrXIz6J4iagDqWJQx0iH+LaP7xC6YJQHNw/mH3zwk2Yd4hpoWNyJ7dGUcmYk8ERgYabvkeBjErR9MZpNppjdx3ALRYZrvoegMzL8zm8lgJNd0oVb9DHutMMCKW9InuTYqZFJvwq8xCVxQwiCDXbGz8bHfSHtA+FhaOgBlZLz1IEjMBQhaMox+GFPhaULdOEoxC6T7YFT7pkhabNvvFYT7ARCi6BCGbof6+wuxS0kwJ4qOU+MixNC5YoVXnRXBrfsqJcTEixi8yqlRsaycIehCya+hsI6F3hPHRKloQRlw3oVOw2jq++PC4LIXYbrrmEp0VLz6DXIf6K18vFSUDwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUV4Qx2xAHfWPtLqC0k6XS5ZsZqHukeuq3nR01y+l7Q=;
 b=W9zR//A6FsCWqSvURGMOyoWbK8+q2ofyTpmLx6oVxTzKUUmY1+4XAsQkDDxB6oUmpfAkqRu+a/IOUiAGZVD7mk+QaEEuPqnAPKRObxbAwvj8kgYFCOPB0UlzDAornj+bpc6KXdpEx7iqEO2esDbTIRWDs7YOEB/NX0ji9vivERF6nz+qA35dNUPYGRw+3/9OTSV2jOjaOJ4WPPbZOiqyn/KUyeiYwdIPM4icibYkMIeOuavi/7G5gcMlaBcl/aNizgSdc6fpdZOAut7yh0YSeZNrXE+6tDlN6mAtE8cZPaQy2771L0KrW4YZ1fa0U9NzXk57FrNNVhTX1i68GF4yaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUV4Qx2xAHfWPtLqC0k6XS5ZsZqHukeuq3nR01y+l7Q=;
 b=A1tRelJK5CgqwqgCy4VhH/YJfyBGnDK/nLIIQ92ODh7jvk7G3SDAin8CwUKPxr/Wd71s3fkHrIEzqJYiCigzEy4Xz06WY66rEhgqNhcLbJ/vNpgtqJOL6CnOGx8hwmMwPVThBUQyqo8Fqm0ksD40ZQm/M1E3/5qJLQHka3AujeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 17:15:39 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:15:39 +0000
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
Subject: [PATCH v9 20/24] wfx: add scan.c/scan.h
Date:   Tue, 11 Jan 2022 18:14:20 +0100
Message-Id: <20220111171424.862764-21-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 147edad4-c244-4975-4107-08d9d525fd2c
X-MS-TrafficTypeDiagnostic: PH0PR11MB5657:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5657CBEA49B06F189A1CD19B93519@PH0PR11MB5657.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKj/+/2fLJtkYGc0hR+nOz8EDTiwaJp61czX9lF70o5Y7fthxPHLA/wripFoA1k45pHip7jHPy5tnfoQMR+wwOq/mpkryhIgriiY9WkN5wMEosL90+a90JPR5XgamrfTCz8VvEIwfFGHIzoprw+rIRPocnlCHmxRS8SgVfkkxPHPeIdOLIQX3hpN2s8TtlxKfrm01mD/rQQNwLOg5uuSodtI13SYF0D0ftSTB7pI/T1AXsfpemup0x/AqCahRq3ArCZ7yWEiKf7cweeym6rmeUzz1mJ1naT+U/0s5fRV/1V8crgN/x5dPsXJBSjXj3h4SO8UIsdhUgBX89CCAywLCYdb2zbnphltGVKoUU+IxMHBsb61WNPahdGkVeHCPTnYuDH8IDf+i/GFY9vanP1C7dHKlQWMhg8YiKSh5u7pajt4zm6kQX3TDD2UqBkI9JZ4jiHja+w5B/w41xv64/FcMq1KZ+cFA59A1LwTLmUjTcDmLvhQ9dSYQ1wNCu4H8yyiXU7unc94m8jvw0k/A/yMWAsJHRV43Ssw5SuY1BQKkR3MpTBCsFw2XmElha24ndxMWzpH8rVTvh2cNUzfFbK+hw/t2mQJel7axGaQHVFty2IJZ6q5CTTWPWXSD/OmpHwwSOrPLozDbq7CMnPJO9ZD+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(66574015)(86362001)(5660300002)(8936002)(7416002)(6916009)(8676002)(83380400001)(1076003)(6486002)(36756003)(38100700002)(186003)(66946007)(6666004)(2616005)(4326008)(2906002)(316002)(107886003)(66556008)(66476007)(54906003)(6512007)(508600001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGJ0RUNwbjU0cHNTK3UwWmxRUTU0NDlpUWhCNTAzRnJnb2NHYVA2WS85UGQz?=
 =?utf-8?B?VU5Sc0EwRnU3QkdQaTVwbUtheVd6TzJjVXpBMTdxWWFpRG1HKzZLZk0yeFFa?=
 =?utf-8?B?dmx5OVdKdmVXNzlWZEREUUlCR1ZnQXdoZlNranpZWjBta1FUSy9mR2hOQnQr?=
 =?utf-8?B?UGdjUXJEZ3RoQXdoNzVmcGFYd1BHQkR2ZzhEbFRoQnVXbmU2MFZkaDRQOTcx?=
 =?utf-8?B?Y1FKdFFPeFdNaGwyVkpmeEZqR1dQVDNjeWkrc3F3NkgwQVFxYXcwMlFPb2E2?=
 =?utf-8?B?NlhRcWZNVkYrTkNDc3o1RVNKNEREaVVENUxGVkFGbTVnY3l6T1RyTTZYL1BI?=
 =?utf-8?B?MWZrQVdyblYxWjhBeWRweGsvTy92ZVVYbmpOcVZVcnhuK3pabVFWN0htNmtp?=
 =?utf-8?B?YXF2SDNxZXZnR1dnaFVWVGdybXI3SSs4aWI3V2xzRmk4UzV6VXBEMmlQS2cw?=
 =?utf-8?B?K1huN2FObkExeG9aMStyYzI2eStpci8vNXRXc3orQURHTytHQkNsUDd4MExv?=
 =?utf-8?B?eXYzNFhhOForOHZXYVBaS2doTC9tYWc2RjQ2S1MwbldJRzQzU2ZyT3R2SUZa?=
 =?utf-8?B?ck1VSlpSeE1TL3ZUamcxVUcxeTRyQ3dJRE9xMGlvTWpmUzM1SFRBYTJOY2N1?=
 =?utf-8?B?YURad0ZTU295NkVuNmwzdy9OQVFFRmdZUWlsZ3BCMEgvR0dGMVZ1dC9LUDhC?=
 =?utf-8?B?enZvM3BRekpXR1BCMTIvTDRaR3BpT21sRHpyMWw1MmRnVnd5aEh5Z2xCYXZo?=
 =?utf-8?B?SVNKWXdHVnUrbi9tcEsvZW1yTGZFOW9sSVZucGJCSTZKM0R2cnRxcnZzcG9n?=
 =?utf-8?B?ZHYyWUJZWGRoN3Q5Q0l2c2R3c201Z3MxaE9hRSt0V3ViYVh4bzV5dTMyL1pC?=
 =?utf-8?B?ZEtnYXYrVDVmTUR0VlIxaVFsQWNsN1drOEZycFBuaGVSRWpDUE9yTHpvQWFp?=
 =?utf-8?B?d2VQc2VvL09OV1R6S1FQZnRxR3E5alNOanJxbXVNRkpwbkQwL1JYSFdUT0tS?=
 =?utf-8?B?VjhVcmJBa0E1bXNXcWo5TGJOSUZqRnNuSnlka3VGL2NLaTJLLzVDYm9XNzRI?=
 =?utf-8?B?bkFGNnFvb05KRDJmN0Rud09nZEUzamJxeVZkUGVHaGNFU2p6RHFSRG5aRGtx?=
 =?utf-8?B?NEo1WThUMW5HS3JiRkxjWmx5ZnI0UGUzWGNOY0lBUlUxUDY0aFN5dW1NbU9M?=
 =?utf-8?B?TEhsSTBKZE0rRVBldGh6R2dCMkdjdmNpNy9md3UrZEwzdUIycEpMYk5RdjZX?=
 =?utf-8?B?STBYLzM3R0VOYjU0cVhTRFYvQ0w1aEhTWHA0dlNjTnBPR2VVMHBzOFRxVHhz?=
 =?utf-8?B?V3lnbkIvRkVtWkhUcG1zQ04rZTBkelVBVWR1WmJZTlVDRWhjOUZ5MVhMTjJJ?=
 =?utf-8?B?N05LcW9BZFhoZ2ZGbmxHTHBJeUpoQmZUVGNpV1BHSXNneGZGcktHUVZyVW1V?=
 =?utf-8?B?bDhwZW5OOHpNKzEvRER0TjV6VmgrL2FuRis4NDU0RldrdFZvaWRnZ2NoUFJa?=
 =?utf-8?B?YXNNekhUcUtEQndHWVdkYVp6RXp2bDczRTZuZk5SbVp3V1BiaFp0eEJ4Qkpu?=
 =?utf-8?B?VncvVE9PZWR0bHIrK05yUVlyRlpIVXZvOVhyOS9YTExOOExucVdLU3hTcWo0?=
 =?utf-8?B?ZGZpeGY5cml0ZURmdE5tTnhEZzM0RDljcXlmVE1BN1Vmb0lhajRjbTNCSlNh?=
 =?utf-8?B?ck9XY0xVaDIySFZNQXhCWDJqaU9wOThIL0RtdXg0Uk1Semh1cHlWVE5MUU5D?=
 =?utf-8?B?UUo3TFczTlU3UThCS3J2NmY3dVN3YkNRTU55ZkdGQmduVEdOS0Y5YmFOd1lC?=
 =?utf-8?B?M0t0YXNma0J2bEZVTUMxVXBjVnNTMHhWcjJKaGVXUHRnNTA4VWxRcFZXS0hy?=
 =?utf-8?B?cEhPaFF0MWpnazJHVjVJT1hWdStDYXBjY210MDQwVTJxc01iK050THcwQmE4?=
 =?utf-8?B?N2lDL2pXc2ZtbmNvNFpjRk04dGZJeHdzRWd3ZHVYSnI3RnhtbkY1cy9FclZR?=
 =?utf-8?B?dnJsVG96SlFXYnV2aWd2b0xScG1YcE4wdmZsTWVkS0FJY04ycGh5T3dQb0ZK?=
 =?utf-8?B?WC9MMm5zZDZ0MklMdy9GSlJQVERkYTNyVjgwTUpiUnpFT1ZCeFpEV1U0ZE91?=
 =?utf-8?B?K2dJN2hsSGI1QjVUQ2YyTmd0RDd2NU94SWdkUlVwRTJkbkV3c3FVbmpVaWlp?=
 =?utf-8?B?SzFJWk41anhOQStvVTl0VXZSY01hMWMvRHk2MElxc3BhdGFVK01GS2VxTnVz?=
 =?utf-8?Q?bVhFkQqvet9JZQUv/CJlCy/rizpc88FKhkbFndzCRQ=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147edad4-c244-4975-4107-08d9d525fd2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:15:38.9708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3nftuR3nQLjWM/MVsJBzRNFa6cvqz26YvfMOS7WMd43iVs+olJ6lfVw2NeB01j1vraalPl1XyuUfH8SFbK6ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jIHwgMTQ0ICsrKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nh
bi5oIHwgIDIyICsrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTY2IGluc2VydGlvbnMoKykKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5oCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwpuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjdmMzRmMGQzMjJmOQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jCkBAIC0wLDAgKzEsMTQ0IEBACisvLyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5CisvKgorICogU2NhbiByZWxhdGVk
IGZ1bmN0aW9ucy4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNvbiBMYWJv
cmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24KKyAqLwor
I2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAic2Nhbi5oIgorI2luY2x1ZGUg
IndmeC5oIgorI2luY2x1ZGUgInN0YS5oIgorI2luY2x1ZGUgImhpZl90eF9taWIuaCIKKworc3Rh
dGljIHZvaWQgd2Z4X2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZF9jb21wYXQoc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsIGJvb2wgYWJvcnRlZCkKK3sKKwlzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9pbmZv
IGluZm8gPSB7CisJCS5hYm9ydGVkID0gYWJvcnRlZCwKKwl9OworCisJaWVlZTgwMjExX3NjYW5f
Y29tcGxldGVkKGh3LCAmaW5mbyk7Cit9CisKK3N0YXRpYyBpbnQgdXBkYXRlX3Byb2JlX3RtcGwo
c3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSkK
K3sKKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOworCisJc2tiID0gaWVlZTgwMjExX3Byb2JlcmVxX2dl
dCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmLT5hZGRyLCBOVUxMLCAwLCByZXEtPmllX2xlbik7
CisJaWYgKCFza2IpCisJCXJldHVybiAtRU5PTUVNOworCisJc2tiX3B1dF9kYXRhKHNrYiwgcmVx
LT5pZSwgcmVxLT5pZV9sZW4pOworCXdmeF9oaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYsIHNr
YiwgSElGX1RNUExUX1BSQlJFUSwgMCk7CisJZGV2X2tmcmVlX3NrYihza2IpOworCXJldHVybiAw
OworfQorCitzdGF0aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0
cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwgaW50IHN0YXJ0X2lkeCkKK3sKKwlpbnQg
aSwgcmV0OworCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hfc3RhcnQsICpjaF9jdXI7CisK
Kwlmb3IgKGkgPSBzdGFydF9pZHg7IGkgPCByZXEtPm5fY2hhbm5lbHM7IGkrKykgeworCQljaF9z
dGFydCA9IHJlcS0+Y2hhbm5lbHNbc3RhcnRfaWR4XTsKKwkJY2hfY3VyID0gcmVxLT5jaGFubmVs
c1tpXTsKKwkJV0FSTihjaF9jdXItPmJhbmQgIT0gTkw4MDIxMV9CQU5EXzJHSFosICJiYW5kIG5v
dCBzdXBwb3J0ZWQiKTsKKwkJaWYgKGNoX2N1ci0+bWF4X3Bvd2VyICE9IGNoX3N0YXJ0LT5tYXhf
cG93ZXIpCisJCQlicmVhazsKKwkJaWYgKChjaF9jdXItPmZsYWdzIF4gY2hfc3RhcnQtPmZsYWdz
KSAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQorCQkJYnJlYWs7CisJfQorCXdmeF90eF9sb2NrX2Zs
dXNoKHd2aWYtPndkZXYpOworCXd2aWYtPnNjYW5fYWJvcnQgPSBmYWxzZTsKKwlyZWluaXRfY29t
cGxldGlvbigmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7CisJcmV0ID0gd2Z4X2hpZl9zY2FuKHd2aWYs
IHJlcSwgc3RhcnRfaWR4LCBpIC0gc3RhcnRfaWR4KTsKKwlpZiAocmV0KSB7CisJCXdmeF90eF91
bmxvY2sod3ZpZi0+d2Rldik7CisJCXJldHVybiAtRUlPOworCX0KKwlyZXQgPSB3YWl0X2Zvcl9j
b21wbGV0aW9uX3RpbWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIDEgKiBIWik7CisJaWYgKCFy
ZXQpIHsKKwkJd2Z4X2hpZl9zdG9wX3NjYW4od3ZpZik7CisJCXJldCA9IHdhaXRfZm9yX2NvbXBs
ZXRpb25fdGltZW91dCgmd3ZpZi0+c2Nhbl9jb21wbGV0ZSwgMSAqIEhaKTsKKwkJZGV2X2RiZyh3
dmlmLT53ZGV2LT5kZXYsICJzY2FuIHRpbWVvdXQgKCVkIGNoYW5uZWxzIGRvbmUpXG4iLAorCQkJ
d3ZpZi0+c2Nhbl9uYl9jaGFuX2RvbmUpOworCX0KKwlpZiAoIXJldCkgeworCQlkZXZfZXJyKHd2
aWYtPndkZXYtPmRldiwgInNjYW4gZGlkbid0IHN0b3BcbiIpOworCQlyZXQgPSAtRVRJTUVET1VU
OworCX0gZWxzZSBpZiAod3ZpZi0+c2Nhbl9hYm9ydCkgeworCQlkZXZfbm90aWNlKHd2aWYtPndk
ZXYtPmRldiwgInNjYW4gYWJvcnRcbiIpOworCQlyZXQgPSAtRUNPTk5BQk9SVEVEOworCX0gZWxz
ZSBpZiAod3ZpZi0+c2Nhbl9uYl9jaGFuX2RvbmUgPiBpIC0gc3RhcnRfaWR4KSB7CisJCXJldCA9
IC1FSU87CisJfSBlbHNlIHsKKwkJcmV0ID0gd3ZpZi0+c2Nhbl9uYl9jaGFuX2RvbmU7CisJfQor
CWlmIChyZXEtPmNoYW5uZWxzW3N0YXJ0X2lkeF0tPm1heF9wb3dlciAhPSB3dmlmLT52aWYtPmJz
c19jb25mLnR4cG93ZXIpCisJCXdmeF9oaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3dmlmLT52
aWYtPmJzc19jb25mLnR4cG93ZXIpOworCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CisJcmV0
dXJuIHJldDsKK30KKworLyogSXQgaXMgbm90IHJlYWxseSBuZWNlc3NhcnkgdG8gcnVuIHNjYW4g
cmVxdWVzdCBhc3luY2hyb25vdXNseS4gSG93ZXZlciwKKyAqIHRoZXJlIGlzIGEgYnVnIGluICJp
dyBzY2FuIiB3aGVuIGllZWU4MDIxMV9zY2FuX2NvbXBsZXRlZCgpIGlzIGNhbGxlZCBiZWZvcmUK
KyAqIHdmeF9od19zY2FuKCkgcmV0dXJuCisgKi8KK3ZvaWQgd2Z4X2h3X3NjYW5fd29yayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IHdmeF92aWYgKnd2aWYgPSBjb250YWlu
ZXJfb2Yod29yaywgc3RydWN0IHdmeF92aWYsIHNjYW5fd29yayk7CisJc3RydWN0IGllZWU4MDIx
MV9zY2FuX3JlcXVlc3QgKmh3X3JlcSA9IHd2aWYtPnNjYW5fcmVxOworCWludCBjaGFuX2N1ciwg
cmV0LCBlcnI7CisKKwltdXRleF9sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKKwltdXRl
eF9sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOworCWlmICh3dmlmLT5qb2luX2luX3Byb2dyZXNzKSB7
CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgImFib3J0IGluLXByb2dyZXNzIFJFUV9KT0lO
Iik7CisJCXdmeF9yZXNldCh3dmlmKTsKKwl9CisJdXBkYXRlX3Byb2JlX3RtcGwod3ZpZiwgJmh3
X3JlcS0+cmVxKTsKKwljaGFuX2N1ciA9IDA7CisJZXJyID0gMDsKKwlkbyB7CisJCXJldCA9IHNl
bmRfc2Nhbl9yZXEod3ZpZiwgJmh3X3JlcS0+cmVxLCBjaGFuX2N1cik7CisJCWlmIChyZXQgPiAw
KSB7CisJCQljaGFuX2N1ciArPSByZXQ7CisJCQllcnIgPSAwOworCQl9CisJCWlmICghcmV0KQor
CQkJZXJyKys7CisJCWlmIChlcnIgPiAyKSB7CisJCQlkZXZfZXJyKHd2aWYtPndkZXYtPmRldiwg
InNjYW4gaGFzIG5vdCBiZWVuIGFibGUgdG8gc3RhcnRcbiIpOworCQkJcmV0ID0gLUVUSU1FRE9V
VDsKKwkJfQorCX0gd2hpbGUgKHJldCA+PSAwICYmIGNoYW5fY3VyIDwgaHdfcmVxLT5yZXEubl9j
aGFubmVscyk7CisJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOworCW11dGV4X3VubG9j
aygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CisJd2Z4X2llZWU4MDIxMV9zY2FuX2NvbXBsZXRl
ZF9jb21wYXQod3ZpZi0+d2Rldi0+aHcsIHJldCA8IDApOworfQorCitpbnQgd2Z4X2h3X3NjYW4o
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCisJCXN0
cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpod19yZXEpCit7CisJc3RydWN0IHdmeF92aWYg
Knd2aWYgPSAoc3RydWN0IHdmeF92aWYgKil2aWYtPmRydl9wcml2OworCisJV0FSTl9PTihod19y
ZXEtPnJlcS5uX2NoYW5uZWxzID4gSElGX0FQSV9NQVhfTkJfQ0hBTk5FTFMpOworCXd2aWYtPnNj
YW5fcmVxID0gaHdfcmVxOworCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnNjYW5fd29yayk7CisJcmV0
dXJuIDA7Cit9CisKK3ZvaWQgd2Z4X2NhbmNlbF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQoreworCXN0cnVjdCB3ZnhfdmlmICp3dmlm
ID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKKworCXd2aWYtPnNjYW5fYWJvcnQg
PSB0cnVlOworCXdmeF9oaWZfc3RvcF9zY2FuKHd2aWYpOworfQorCit2b2lkIHdmeF9zY2FuX2Nv
bXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgbmJfY2hhbl9kb25lKQoreworCXd2aWYt
PnNjYW5fbmJfY2hhbl9kb25lID0gbmJfY2hhbl9kb25lOworCWNvbXBsZXRlKCZ3dmlmLT5zY2Fu
X2NvbXBsZXRlKTsKK30KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93
Zngvc2Nhbi5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmgKbmV3IGZp
bGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi43OGUzYjk4NGYzNzUKLS0tIC9kZXYv
bnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uaApAQCAtMCww
ICsxLDIyIEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisv
KgorICogU2NhbiByZWxhdGVkIGZ1bmN0aW9ucy4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTct
MjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwg
U1QtRXJpY3Nzb24KKyAqLworI2lmbmRlZiBXRlhfU0NBTl9ICisjZGVmaW5lIFdGWF9TQ0FOX0gK
KworI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCitzdHJ1Y3Qgd2Z4X2RldjsKK3N0cnVjdCB3
ZnhfdmlmOworCit2b2lkIHdmeF9od19zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KTsKK2ludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4
MDIxMV92aWYgKnZpZiwKKwkJc3RydWN0IGllZWU4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSk7Cit2
b2lkIHdmeF9jYW5jZWxfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGll
ZWU4MDIxMV92aWYgKnZpZik7Cit2b2lkIHdmeF9zY2FuX2NvbXBsZXRlKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLCBpbnQgbmJfY2hhbl9kb25lKTsKKworI2VuZGlmCi0tIAoyLjM0LjEKCg==
