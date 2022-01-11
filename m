Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A111748B312
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343966AbiAKRPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:15:02 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:36192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343859AbiAKROx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:14:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8dJ/7vjtTMpHHpeF98x1tiBfqIZvODArdPJBlejZRlV2zUmSmBmxzRsUSQT4VDEAkExHy1cZuyN+TcpjwpOdVzW4KAcZXowTO7i/MsMjshlWviC8R7t28aboWG/KATydR6UKEhn/lxqHf4GUd5mwf1sRFywKsFKmzpeDTXzSRRSQkebmXc2qylw9AaeY7zgGHB4hWdqwUsOztJPXH+rePB9E0JCihqgnKl5V62yOsnGvfvEsrTVQ4BRRBMO/PiFJWZvpp3xC5JRoaKU7aEqKUkdiCHFulJPjBatRY1HC7sf6vqfWigRkplCH4t0AViygIlDuYMAFkoQ3twNYSXcRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2H/jcPaC9cTFyGGtm0LDIXJQEuv9bvw+S8ayYT2YZI=;
 b=FHgCiSiLGl+5OneNGthZKJcRLzktN6XR42O0FGg0tkkcFR/T5QOz6PNerM9PXh86SMIMOscYyYg2B77B3exBqO9JpVxNZg+4up3aUn78G1pp6+o4oogIfsOgK/Rpn49epCSghu/KXDwVsr8N6N80KIxRpqjvh4BfzvX5Tm5Tz+Xj7efTzXJNHBCdAWleYOV8Ea9o6+Z/FuZs/EDGDUOSa3mwSuKnsbuT+HUOEbU4DpdNDP3wEDPUQToh7ivVqWjWKINPKm7MdryomigV9YAVI/AZq2Ob7iTx8wBbf7va65yvFmZ+rDh0yMvWiOR917C9AlEedfsHgqPfBBj9Jaos0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2H/jcPaC9cTFyGGtm0LDIXJQEuv9bvw+S8ayYT2YZI=;
 b=IoWa6zH3/JWiP5n+4SuBi4anesOy9IK2UKyOFpuQDwrIqEUYdFrg9yuZ+gCc8G/rySrSuAjB/aLrooOoEmtl5HVpzVIzjFnaF30iNSVCpWAb1YAIwDx9lNA3CAlypBwni9gzYWUp/HR+qvz0Ix+5oHqsf43b9mEiH7dqeq4ZuPg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 17:14:51 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:14:51 +0000
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
Subject: [PATCH v9 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Tue, 11 Jan 2022 18:14:02 +0100
Message-Id: <20220111171424.862764-3-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 19aeb6f2-d335-49fa-957d-08d9d525e0dd
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5595D00F371A3D5D5F6CCFFA93519@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQ2Y1mV2kmrwjRp4AzOnAtBS2vibKBAWtQWaZyYx09PTCofhJIF+DiTG72unknBPBgJIVXLl6gHQs0e5cGbkR69KduqE+yamNr/tuQP6poNI8NvNCOm9W7q26BaWc7HTuBVNVK+dOCn4NxGXa/LHe+Ud2SjLhf9kb0SgnaoE3Eh+AeAp9ISTn33SYxXNjeHqnlQ6vgwMiG4YMYrIVUN3+RXVgphwL/wJ6oEyLjXtA4uFDmymVl9q//vdJllFux4FX48sGVoe0U4HmWfpai0nQ4wtTEAnGGijTuqw4gdbK6xahhwkr5mwUxnyn9P8RRdZH86L01h7kBH6fiLPSiLVnC5cCIw11ca5oDEnDFa05yf2J+YjYdS6jlvXg9e1WoZlJtGtZ2D9srsABLX7hfHSuv1l3qQLWOrCj0UDLlLInye9yfE0xcZbaOEJbFQUFDToMfRjX87xNfbkydb48/T9nejwPQq/6JIDGDgFqd7I6aU/Nd/G/fLAbyEkKsv0si80JigjN4HIapVdYRSg5JxnIIQ7e9+hwZrSVIoGG1s7iLV5pEssk4i8eba07Epr8ZEZNKflCJRTbjT8X4IO6ajDU5jWRe6Q7/tEcA2kwMwFswgD7BidtNQli6n0aEBLgtdMRfFY5nfhym4UYAmjyrUpgzpkxWvGw6LuoILafZh16yxxmaONbPX7jJi/QFZt1ArrQWRRFOz1lJM0sI47Mpci8kdqMFmr1hrVUgc9qqAePmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(6512007)(2906002)(107886003)(8936002)(2616005)(7416002)(6666004)(38100700002)(6506007)(4326008)(66476007)(8676002)(54906003)(6916009)(316002)(66556008)(52116002)(86362001)(186003)(5660300002)(6486002)(966005)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEp4SmNZZ01OcUdGcmJxdDRLdFNRQWhHZFNEQWNZeWYwWmRURWFRMFpQS2Zp?=
 =?utf-8?B?SlVyNmZsL3lsSkdaUWZtd2pNUXVNS3ZoNW1NRnNtT2hjb09oUmRhK3dxR3Fl?=
 =?utf-8?B?L1c4RzZKYmNnTzUwbGMwVm5qazlKSFpCelN1eG94QTV3RjJMKzBPb0M4Zmpw?=
 =?utf-8?B?dTJnMy9kSmRSMzB0V2tjc0tNbitXVzBKVEFHbG9hUm84Rzd4cUN3QzIzbGkx?=
 =?utf-8?B?NlZCdHRTUHpvNWRYdVlQdFFrZFhjNkk4RGRRcVIzbEdSMFA3MFV5eTZlMUFV?=
 =?utf-8?B?SmxUd2s1dGpMU2FhOXMwNHlPOVFPN1loNGdkbWprTGhORGdTNGl3cXJtejZv?=
 =?utf-8?B?eTN5Yzg1ZkJIajNFQVE3SVo4YTZheGRBdFpIa01qeDV2NzM1MjVuWUJyNy92?=
 =?utf-8?B?LzJJRUp0RzkzeUUyVGtvT3BYUTcxbGZKVFMrZ2ZJd3NzQTlURWs3NFhCNXQ3?=
 =?utf-8?B?Z0tYWEdGdjRjZUErMjNVQXhBNHA4ME9wUDh3UzMwYWdmZGIwMHRtRTFscG5S?=
 =?utf-8?B?bjR0MmhKSTRZZXFMb0dtV3JWclBmb0IwK0RrdzZQTUdybGxlbWVhWGdFWWNq?=
 =?utf-8?B?andpTzhobUxKT1RVTmpoYzhCN0JnVk10Z1UrR2JsdFVnOW1lUUxJcko1WkUv?=
 =?utf-8?B?QnNOcFBlQ0toU3VzWjlXVWFpY1ZnVkxiY0draDNtWlQ3amx5amtzQlZ2VXFk?=
 =?utf-8?B?clhJcWVZeWpSM2M2WDBQLzBqTWlobDB4MGIzT0RjQWFiTEpabkI3YTdBczNR?=
 =?utf-8?B?TE9OTC9adWtEdVhrdkdvRThOVEhCQkkwQ1JKK1JoSXVtV3hPTTdTNE9ZR2dO?=
 =?utf-8?B?bnZ5YzZWNVlvTnNSeEo1Y3NBYWZiYXgrazN4NUcya1k4RmtxaUhFczNBdU1x?=
 =?utf-8?B?UUVJK2h5aGF1WVNtUFRnTkI4V3JWYVdreUdEQmhsUGFjV2VBVlFGU2t6eW9h?=
 =?utf-8?B?Y21QT2NldHBLbDI4OGVIOUJvRW1VaVBGaGMxT0FJQ3FOY2orNGZ4c21tazJ3?=
 =?utf-8?B?UmIydGVOdjdKRFFQalJSenk1eHBhdVJhTmhvVUlCSy9OZWRrVm9IWjZleFpi?=
 =?utf-8?B?OExyK01Ua2dHN2NzWm5ja3dPcG5VVzZxMm5BM0FUemhVQ0o3QjBMdG1JZld0?=
 =?utf-8?B?TlQ1NmMzREplWnNpQ2JlcjZybk1ua3F0aGlhVDdMcjZ3Vmg4VVBmK3lMOTRR?=
 =?utf-8?B?TDZURmpEY09RU2RxVlA3b21DY3hnUEdmZkJOVHdJSXU5R1BIY3psaitCRXZq?=
 =?utf-8?B?LzAxa3BySFJyam1vUkJYZW9RVDBMa3ZmU0JDZmE4cCtla0hreXRpTnRRaVN3?=
 =?utf-8?B?WmR4WG5BOHNTSHBhR3RSRTVZWXZzZk01b0VBeUxxRTJTek1UVWt2cTdoOHhj?=
 =?utf-8?B?RFU3M2dsbTZ0aFBVRE1FYjExaVhHeWF3QUZhWlpwUGkyYU8ySVZzeVBSNk5q?=
 =?utf-8?B?T2xLMmY5bG9yaGRYK2ZoYkh3eGIzRmN0YVRWMWlZN1dyQUF4YUZjZ2RHMjMv?=
 =?utf-8?B?U2tHUk1nYnl3Q2FZalZEbEs5VjJEV1ZLeUFMT09RUUx1em4vcGxOQXRjQUph?=
 =?utf-8?B?VHZYVFVuV1IvTWxCeGs3SVkwWlVjenRScStGU2JMVnpBOGhxcFhJQURsY1BS?=
 =?utf-8?B?U1dQRzFkWVJ1N2k5MlE1L1NhcEx1TkZZSFpnMU13eVFmbmxVQ3p1aDVwM0ZP?=
 =?utf-8?B?UnJiRnlXWjdSNnJZbHRxVlVTOGR5a0FCdTNWZ1QxZmprc2ZnTU1GTk02Q2xj?=
 =?utf-8?B?RHc5SmF5a3BQNlBvc0ttbGhUb0FOdEJId1FWK01FcHRFN0h6aGNIRDB5aDJ4?=
 =?utf-8?B?SEluZ0pPRGJzeDhVRkRLUjNncEVhWFJHTE5MemVZemIxWFNIb3lEa0NmTSt5?=
 =?utf-8?B?S21LZCtxOTk3MTRjc0tJd0tidzVkUGJ6VGxLVGh5eVlHSnB0VUdkZkp6WVRD?=
 =?utf-8?B?T2NPYXZ1Z2krcEJzWHFmQTJHNVJoaTdzRmxlT1JseVI2eStDcU53MDBPcm5s?=
 =?utf-8?B?R1dGZlVwTkJQMFYvQ0FzOENDWDNwOVF3S2R1dGJVUU5jTXhoNS84WU5uNEVp?=
 =?utf-8?B?V0FVK0pidHNJamdidU9BVW80dkpWYk9PN2YzdzZJaGdHOFM5cDZxYXRhbldt?=
 =?utf-8?B?cGw4S2NmMkQ5bGM4QXFkQk1rRVNndlpJMDF5N2NrcmxzbFNUZnlrQ1JLZmda?=
 =?utf-8?B?Y0swU1FkL2NhbTJKWGJoYUtSSHdKZmRjVk9kT2JDWWdBL0YyV0c4am9ROFNj?=
 =?utf-8?Q?Mh0wbYMyeBr/q1UN4D/bYRCRp+CH51Gzk3bitvZKgg=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19aeb6f2-d335-49fa-957d-08d9d525e0dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:14:51.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOx+wyAryQ5O9Gp4I7oCHmnP+c9f/yMktnM0jOyILvfScNyDF8CTsNABuwUpHfj2Fd2pfkoO1EpMxutnRkUR/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUHJl
cGFyZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSB3ZnggZHJpdmVyIGluIHRoZSBrZXJuZWwuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogLi4uL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgICAgIHwgMTM4
ICsrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzOCBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93
aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbCBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCm5ldyBm
aWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uZDEyZjI2Mjg2OGNmCi0tLSAvZGV2
L251bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTAsMCArMSwxMzggQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IChHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlKQorIyBDb3B5cmlnaHQgKGMpIDIw
MjAsIFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCislWUFNTCAxLjIKKy0tLQorCiskaWQ6IGh0
dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwj
Ciskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMK
KwordGl0bGU6IFNpbGljb24gTGFicyBXRnh4eCBkZXZpY2V0cmVlIGJpbmRpbmdzCisKK21haW50
YWluZXJzOgorICAtIErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KKworZGVzY3JpcHRpb246ID4KKyAgU3VwcG9ydCBmb3IgdGhlIFdpZmkgY2hpcCBXRnh4eCBm
cm9tIFNpbGljb24gTGFicy4gQ3VycmVudGx5LCB0aGUgb25seSBkZXZpY2UKKyAgZnJvbSB0aGUg
V0Z4eHggc2VyaWVzIGlzIHRoZSBXRjIwMCBkZXNjcmliZWQgaGVyZToKKyAgICAgaHR0cHM6Ly93
d3cuc2lsYWJzLmNvbS9kb2N1bWVudHMvcHVibGljL2RhdGEtc2hlZXRzL3dmMjAwLWRhdGFzaGVl
dC5wZGYKKworICBUaGUgV0YyMDAgY2FuIGJlIGNvbm5lY3RlZCB2aWEgU1BJIG9yIHZpYSBTRElP
LgorCisgIEZvciBTRElPOgorCisgICAgRGVjbGFyaW5nIHRoZSBXRnh4eCBjaGlwIGluIGRldmlj
ZSB0cmVlIGlzIG1hbmRhdG9yeSAodXN1YWxseSwgdGhlIFZJRC9QSUQgaXMKKyAgICBzdWZmaWNp
ZW50IGZvciB0aGUgU0RJTyBkZXZpY2VzKS4KKworICAgIEl0IGlzIHJlY29tbWVuZGVkIHRvIGRl
Y2xhcmUgYSBtbWMtcHdyc2VxIG9uIFNESU8gaG9zdCBhYm92ZSBXRnguIFdpdGhvdXQKKyAgICBp
dCwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIGR1cmluZyByZWJvb3QuIFRoZSBtbWMtcHdyc2Vx
IHNob3VsZCBiZQorICAgIGNvbXBhdGlibGUgd2l0aCBtbWMtcHdyc2VxLXNpbXBsZS4gUGxlYXNl
IGNvbnN1bHQKKyAgICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1jL21tYy1w
d3JzZXEtc2ltcGxlLnlhbWwgZm9yIG1vcmUKKyAgICBpbmZvcm1hdGlvbi4KKworICBGb3IgU1BJ
OgorCisgICAgSW4gYWRkIG9mIHRoZSBwcm9wZXJ0aWVzIGJlbG93LCBwbGVhc2UgY29uc3VsdAor
ICAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9zcGkvc3BpLWNvbnRyb2xsZXIu
eWFtbCBmb3Igb3B0aW9uYWwgU1BJCisgICAgcmVsYXRlZCBwcm9wZXJ0aWVzLgorCitwcm9wZXJ0
aWVzOgorICBjb21wYXRpYmxlOgorICAgIGFueU9mOgorICAgICAgLSBjb25zdDogc2lsYWJzLHdm
MjAwICAgICMgQ2hpcCBhbG9uZSB3aXRob3V0IGFudGVubmEKKyAgICAgIC0gY29uc3Q6IHNpbGFi
cyxicmQ0MDAxYSAjIFdHTTE2MFAgRXZhbHVhdGlvbiBCb2FyZAorICAgICAgLSBjb25zdDogc2ls
YWJzLGJyZDgwMjJhICMgV0YyMDAgRXZhbHVhdGlvbiBCb2FyZAorICAgICAgLSBjb25zdDogc2ls
YWJzLGJyZDgwMjNhICMgV0ZNMjAwIEV2YWx1YXRpb24gQm9hcmQKKworICByZWc6CisgICAgZGVz
Y3JpcHRpb246CisgICAgICBXaGVuIHVzZWQgb24gU0RJTyBidXMsIDxyZWc+IG11c3QgYmUgc2V0
IHRvIDEuIFdoZW4gdXNlZCBvbiBTUEkgYnVzLCBpdCBpcworICAgICAgdGhlIGNoaXAgc2VsZWN0
IGFkZHJlc3Mgb2YgdGhlIGRldmljZSBhcyBkZWZpbmVkIGluIHRoZSBTUEkgZGV2aWNlcworICAg
ICAgYmluZGluZ3MuCisgICAgbWF4SXRlbXM6IDEKKworICBzcGktbWF4LWZyZXF1ZW5jeTogdHJ1
ZQorCisgIGludGVycnVwdHM6CisgICAgZGVzY3JpcHRpb246IFRoZSBpbnRlcnJ1cHQgbGluZS4g
VHJpZ2dlcnMgSVJRX1RZUEVfTEVWRUxfSElHSCBhbmQKKyAgICAgIElSUV9UWVBFX0VER0VfUklT
SU5HIGFyZSBib3RoIHN1cHBvcnRlZCBieSB0aGUgY2hpcCBhbmQgdGhlIGRyaXZlci4gV2hlbgor
ICAgICAgU1BJIGlzIHVzZWQsIHRoaXMgcHJvcGVydHkgaXMgcmVxdWlyZWQuIFdoZW4gU0RJTyBp
cyB1c2VkLCB0aGUgImluLWJhbmQiCisgICAgICBpbnRlcnJ1cHQgcHJvdmlkZWQgYnkgdGhlIFNE
SU8gYnVzIGlzIHVzZWQgdW5sZXNzIGFuIGludGVycnVwdCBpcyBkZWZpbmVkCisgICAgICBpbiB0
aGUgRGV2aWNlIFRyZWUuCisgICAgbWF4SXRlbXM6IDEKKworICByZXNldC1ncGlvczoKKyAgICBk
ZXNjcmlwdGlvbjogKFNQSSBvbmx5KSBQaGFuZGxlIG9mIGdwaW8gdGhhdCB3aWxsIGJlIHVzZWQg
dG8gcmVzZXQgY2hpcAorICAgICAgZHVyaW5nIHByb2JlLiBXaXRob3V0IHRoaXMgcHJvcGVydHks
IHlvdSBtYXkgZW5jb3VudGVyIGlzc3VlcyB3aXRoIHdhcm0KKyAgICAgIGJvb3QuIChGb3IgbGVn
YWN5IHB1cnBvc2UsIHRoZSBncGlvIGluIGludmVydGVkIHdoZW4gY29tcGF0aWJsZSA9PQorICAg
ICAgInNpbGFicyx3Zngtc3BpIikKKworICAgICAgRm9yIFNESU8sIHRoZSByZXNldCBncGlvIHNo
b3VsZCBkZWNsYXJlZCB1c2luZyBhIG1tYy1wd3JzZXEuCisgICAgbWF4SXRlbXM6IDEKKworICB3
YWtldXAtZ3Bpb3M6CisgICAgZGVzY3JpcHRpb246IFBoYW5kbGUgb2YgZ3BpbyB0aGF0IHdpbGwg
YmUgdXNlZCB0byB3YWtlLXVwIGNoaXAuIFdpdGhvdXQgdGhpcworICAgICAgcHJvcGVydHksIGRy
aXZlciB3aWxsIGRpc2FibGUgbW9zdCBvZiBwb3dlciBzYXZpbmcgZmVhdHVyZXMuCisgICAgbWF4
SXRlbXM6IDEKKworICBzaWxhYnMsYW50ZW5uYS1jb25maWctZmlsZToKKyAgICAkcmVmOiAvc2No
ZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9zdHJpbmcKKyAgICBkZXNjcmlwdGlvbjogVXNl
IGFuIGFsdGVybmF0aXZlIGZpbGUgZm9yIGFudGVubmEgY29uZmlndXJhdGlvbiAoYWthCisgICAg
ICAiUGxhdGZvcm0gRGF0YSBTZXQiIGluIFNpbGFicyBqYXJnb24pLiBEZWZhdWx0IGRlcGVuZHMg
b2YgImNvbXBhdGlibGUiCisgICAgICBzdHJpbmcuIEZvciAic2lsYWJzLHdmMjAwIiwgdGhlIGRl
ZmF1bHQgaXMgJ3dmMjAwLnBkcycuCisKKyAgbG9jYWwtbWFjLWFkZHJlc3M6IHRydWUKKworICBt
YWMtYWRkcmVzczogdHJ1ZQorCithZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UKKworcmVxdWly
ZWQ6CisgIC0gY29tcGF0aWJsZQorICAtIHJlZworCitleGFtcGxlczoKKyAgLSB8CisgICAgI2lu
Y2x1ZGUgPGR0LWJpbmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5n
cy9pbnRlcnJ1cHQtY29udHJvbGxlci9pcnEuaD4KKworICAgIHNwaTAgeworICAgICAgICAjYWRk
cmVzcy1jZWxscyA9IDwxPjsKKyAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAg
d2lmaUAwIHsKKyAgICAgICAgICAgIGNvbXBhdGlibGUgPSAic2lsYWJzLGJyZDQwMDFhIiwgInNp
bGFicyx3ZjIwMCI7CisgICAgICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAg
ICAgICAgICAgcGluY3RybC0wID0gPCZ3ZnhfaXJxICZ3ZnhfZ3Bpb3M+OworICAgICAgICAgICAg
cmVnID0gPDA+OworICAgICAgICAgICAgaW50ZXJydXB0cy1leHRlbmRlZCA9IDwmZ3BpbyAxNiBJ
UlFfVFlQRV9FREdFX1JJU0lORz47CisgICAgICAgICAgICB3YWtldXAtZ3Bpb3MgPSA8JmdwaW8g
MTIgR1BJT19BQ1RJVkVfSElHSD47CisgICAgICAgICAgICByZXNldC1ncGlvcyA9IDwmZ3BpbyAx
MyBHUElPX0FDVElWRV9MT1c+OworICAgICAgICAgICAgc3BpLW1heC1mcmVxdWVuY3kgPSA8NDIw
MDAwMDA+OworICAgICAgICB9OworICAgIH07CisKKyAgLSB8CisgICAgI2luY2x1ZGUgPGR0LWJp
bmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1cHQt
Y29udHJvbGxlci9pcnEuaD4KKworICAgIHdmeF9wd3JzZXE6IHdmeF9wd3JzZXEgeworICAgICAg
ICBjb21wYXRpYmxlID0gIm1tYy1wd3JzZXEtc2ltcGxlIjsKKyAgICAgICAgcGluY3RybC1uYW1l
cyA9ICJkZWZhdWx0IjsKKyAgICAgICAgcGluY3RybC0wID0gPCZ3ZnhfcmVzZXQ+OworICAgICAg
ICByZXNldC1ncGlvcyA9IDwmZ3BpbyAxMyBHUElPX0FDVElWRV9MT1c+OworICAgIH07CisKKyAg
ICBtbWMwIHsKKyAgICAgICAgbW1jLXB3cnNlcSA9IDwmd2Z4X3B3cnNlcT47CisgICAgICAgICNh
ZGRyZXNzLWNlbGxzID0gPDE+OworICAgICAgICAjc2l6ZS1jZWxscyA9IDwwPjsKKworICAgICAg
ICB3aWZpQDEgeworICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJzaWxhYnMsYnJkODAyMmEiLCAi
c2lsYWJzLHdmMjAwIjsKKyAgICAgICAgICAgIHBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7Cisg
ICAgICAgICAgICBwaW5jdHJsLTAgPSA8JndmeF93YWtldXA+OworICAgICAgICAgICAgcmVnID0g
PDE+OworICAgICAgICAgICAgd2FrZXVwLWdwaW9zID0gPCZncGlvIDEyIEdQSU9fQUNUSVZFX0hJ
R0g+OworICAgICAgICB9OworICAgIH07CisuLi4KLS0gCjIuMzQuMQoK
