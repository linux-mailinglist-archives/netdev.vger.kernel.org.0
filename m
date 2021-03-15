Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020CA33B3E4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCONZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:25:42 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:61153
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229731AbhCONZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:25:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbIMC2V0p9nQfRhy2patAyVKQhxc1gGEUIVzRLlJIeF4ETXWUTgEBGOUR3H2lzui1BfC8/0t+f/Hjw0B6icIkUDBKfIszb3arrM53qxLtqkCT6SjIOLvlWoFlqONxcLPr4Tc2du7+EJeNb2AUC1eC4LvDe4dAaZWTphHk/gg7aqFJ00H2aTxKahp1asa7dEtNJvz984rU+X7n063p6wPgS9eUTKFl+d6v9F8JFag+ZxirqxyVTtKmyUZHvGZiWXfc3CxzN4YRmG7zmks7LIEg0+zynjUX/5pEfeikH/4pODUTZTO+X+mkgeXamHP/PXl9MJXXBHBO8qzuCwo9NL0mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D/2thDw/uCJVBZ6swCuZb4GsLE8cd5HHfCliFfZmJA=;
 b=EMEw2UK1qn/JLnZ9xvO7bCs3VcQG4/GFoZotmjDXZLMdH1prpN48wKu3HKBkXFPxFKickppY8zZ1pPSBlZiiLn1EouSTSgiTnQzsC8ZoyCvwm7V38vKcNhWnjqk7nvOFsucuX0+FmLjeVaqFM89RGwNKucj4VasC0eZhHf6x1L79/AroD9WTRRYtYglYrKSws3GETjDaNMiLGhDiO0QQZ7MdzpMVV/83IGvh+4Ex8ux/bPRfEESC0DBF+lDCoHD5qonssRpIObA0ckMkWMsuPDVIKaRQYg+Cui/VKtJS05jf9BYHojWw1bgjSPhYHuQO08dlHG7yua81PtX7y3rgUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D/2thDw/uCJVBZ6swCuZb4GsLE8cd5HHfCliFfZmJA=;
 b=DbbsYINfqyu6AhqF4Ah0wSIpFg5uJyMJd32eFR4dtuRZREmb1mj/fqzcOTqpxszG8Z+iwPI74sRK2lbMhz0WPTc+WRvqEFldBcb4NhgMT6cisMAJwOy5arFgoR4u3ALAsx26cB1axah6z88T8RtuoyCsX09MKF4n7hSS9S7dRXM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:25:27 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:25:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Mon, 15 Mar 2021 14:24:39 +0100
Message-Id: <20210315132501.441681-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 085d7ee6-ba6d-42cb-f402-08d8e7b5cc3b
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB509949CD9C860BDA38B7F823936C9@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FlRJIyvIBEhpRMmaX5LLnHOM6T0Z16MnErF5eHYCLPZ0H16poKRcxCtfWG5nECZ5HAYa4EXlzBXaAEeL4V2n+Wwnic/HbRAMuXO2mGdqxBOJFINx45K7iJjbic8IzpisvtBOr+mt+bpRoU2+bNX2QBhh+ct2nERtfHg4XkLdCKQJCXfPqb23AywnnJTDy23OQt7SGZxOsi31iNF8BtlClPr4WsaC+f1Rf32UXDiy5fEU1jwjrxSW7xKnABXSy4q1SI/OU8Dp51ZIgH8vIMLU/ah9QapJtRlTE80wWHnWTYt/7j+wl4WJ4cAnIfU4z160wToP9GDFsqo/q14H6KCVZuiIWE4l/s1dytKfJAZc/Z16OPQOROigAX/C9U5SOED7GALhBzLg803q0uAwsymQ7WlQbxyrE7HBUIY0CWfGjPkeH5l3srEE5ogBbmad/0u8NC9tsh4N8u44Z1ZOgC/cA5qk4P3ciCNEz558x3h7uCcKdcz0qgof7AK6CaKOJlMIgWdBlug6aT4y1yApTSZ4G2JKcGneWYms3COxdVneZMxB5DZZpw1mG48MT0sQiys9+FD0IQg8ibJI4J+B5U+ZAFcrli+ZExfjZegGEqn4mQTq0daCagQBbXHKeQNHyCD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39850400004)(376002)(366004)(186003)(7416002)(966005)(2616005)(107886003)(4326008)(478600001)(16526019)(66476007)(86362001)(66946007)(54906003)(66556008)(8936002)(316002)(5660300002)(8676002)(1076003)(52116002)(7696005)(6666004)(36756003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THVKK3dEOEtTUTgzOEpkNDVFU2JqNU5yUzVNNlhwU3V0bzJiSzlYS2NjWWNk?=
 =?utf-8?B?WmlpSk9RM0dkbTR0NEhWZmpyRzE3OEFBN3lENStyNmxsMUY2aHIxcW5XV0RS?=
 =?utf-8?B?NVg2aGFKa1p6cExWRm1UZkdJdEIrWlFEeDhGREJuYXAybEtiYitacm8yckFw?=
 =?utf-8?B?WW9ZSC9PdEllQUxPcE5qMUkwcEdrVmFNd0xocEQxUlA0b3BYSlhTSWcwbEhj?=
 =?utf-8?B?OS9GMkVWUFBnOExTYzB5V1hDZ0Qva05qaXZ0ZHBDbjIzN3gyditzb2lUNnZo?=
 =?utf-8?B?YWNqVGt2UmY1emRuQ3RjZHR3ZENhQW1uQitjc1dEcDUxUVllcGd0eGp6aHdR?=
 =?utf-8?B?ZWtZMGM3TmJaQWFkWFpUaTlTcFZYa3FKejhWYk5LZmltMC9yMGtVR2dTem9F?=
 =?utf-8?B?aEt3aGwzbTRzWWNid0VtVTZrckR1dWdOdUMwQlIxWVZoOHhuNVlrUW0xWHN6?=
 =?utf-8?B?SE9jZ0NjTHAvMEREeUxkdm1IYytVR3BZa1dFbUVBRnkvSW5WaVIyNVpOck12?=
 =?utf-8?B?UHpjMFhRM1lzcHIxamh1ODh1OUFiTHJWUUovQWh3MmRaYVNvT3RnV2hZMTVa?=
 =?utf-8?B?UE5JTEtSaWkvNDRaTGhEc3VidWpBWW9RUndCc2xsK2o0RTk5UFY4aUEveXJk?=
 =?utf-8?B?WHUrZjVDbWlldFVBMEVwemJBODRuN05PNUJLVzlONFM3R3VXOGNYRkEzQlBP?=
 =?utf-8?B?TERGaXgwVnU3T290UWhMaHBXUEZoKzhienMvWVBmVmFINWRLTmhCdm1lY3FK?=
 =?utf-8?B?b251bG1LQnlWdDQ0UmNPZVBmV3R1S1I2SVZ4MHBkaEJYUDRFTEYyaFA4eTJH?=
 =?utf-8?B?RER3YjExQXdzR3ZCcERmUzlZei84NXhaWWZZdGVKRThYY1NGd2NndXBPWkxG?=
 =?utf-8?B?NVNtenNicGUxSWs2bzRsWW96c2ZQSlJ3UGZtMDRvVGxIcE9scCtjQ3hPUWhC?=
 =?utf-8?B?dFdVaUZId0xzb0t5MFA3aC9sSGs0a2ZpdmNxT1Zab21meWtQeDVMWTFQVXN2?=
 =?utf-8?B?NVZxMXJQdkFZNE1EbGkxUWdFc2d6a2crZENzNTBNb3NGUW52dWo2YWtzSjhh?=
 =?utf-8?B?bHIxcFpENGJpa004WWY3Snl6di9la3ExR21QOUROdGxtWENhZWtLUnNDMSt3?=
 =?utf-8?B?bTBYaGNCUjZRMnQyRXovZzVCbE5JV25iOGFXRWJSUzhTbG1YWkJyQUJqRmx4?=
 =?utf-8?B?Z21Mc00yMzhyYUpyWUN5ZUhtSm1kQWtFU1NIU1Jkc2liY1B4QS8vUWQvaDlN?=
 =?utf-8?B?R2RGa3hGZkU5NC82Y1J5czVmVmVhWFN2aHlMbmdMQ0ZQV3p5NXQycWFHckhi?=
 =?utf-8?B?aCtXNENBakRqazlHcitLd1VRbTAyK29UaG04S3VtT3ZqcjVpSTlocTdwU1dL?=
 =?utf-8?B?VU1vMkxkWnBFUnhETElNU3Q0Yml1RElJcm4zVkhKSHpaSXdNTjhkRWt3Yk94?=
 =?utf-8?B?KzVocGRndkd0d2hRVGNEdUdPYUZsODhZQ2pITGZiM2paMTIrT05lbTNzOXhG?=
 =?utf-8?B?cTdueEhkNFlzT28zRDZPMTlHTzJ6VTR4VUlnVlVVRFZtY2dpMGJ3WThyK2NI?=
 =?utf-8?B?aW5EbDYzUCtVRG9jSHdzeHdaVUJqeThhTnB3Zk4zZFd1QWkvellTUWl4R2lu?=
 =?utf-8?B?cm1hQ2c2TWhCM2NUeUFkaW1Od09mTEFnTmNIVEJUQkJLV3ppVnhxcEMvL2xI?=
 =?utf-8?B?Q21SQnFIRlF5U3JMVWVHU09iQklZdS81bGpIcEl2T0R4bTBSUGIvLysreS9O?=
 =?utf-8?B?UUh4SDJnMTVMSXdMZ3YzWVN1U3IrTXZDOVhld3dVeWR1dXVXNk9Fd1NJKytP?=
 =?utf-8?B?MWMzMWFOT000ZkxjUGlLQW5JamVTblNTUmI4dWszL1NiRGFCMWM0K0RPWEQv?=
 =?utf-8?Q?CkJUqPqIcAFa/?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085d7ee6-ba6d-42cb-f402-08d8e7b5cc3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:25:27.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pTplrBbun4NsJeIfCUunDsqd5HkeoBdOiF0rdbYViHy1ZStH9Oq/OGHmgQQpeCbtaPqm298iAgGg3b5gisTWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUHJl
cGFyZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSB3ZnggZHJpdmVyIGluIHRoZSBrZXJuZWwuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogLi4uL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgICAgIHwgMTMz
ICsrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzMyBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93
aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbCBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCm5ldyBm
aWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uOWU3MTI0MGVhMDI2Ci0tLSAvZGV2
L251bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTAsMCArMSwxMzMgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50
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
d3JzZXEtc2ltcGxlLnR4dCBmb3IgbW9yZQorICAgIGluZm9ybWF0aW9uLgorCisgIEZvciBTUEk6
CisKKyAgICBJbiBhZGQgb2YgdGhlIHByb3BlcnRpZXMgYmVsb3csIHBsZWFzZSBjb25zdWx0Cisg
ICAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3NwaS9zcGktY29udHJvbGxlci55
YW1sIGZvciBvcHRpb25hbCBTUEkKKyAgICByZWxhdGVkIHByb3BlcnRpZXMuCisKK3Byb3BlcnRp
ZXM6CisgIGNvbXBhdGlibGU6CisgICAgY29uc3Q6IHNpbGFicyx3ZjIwMAorCisgIHJlZzoKKyAg
ICBkZXNjcmlwdGlvbjoKKyAgICAgIFdoZW4gdXNlZCBvbiBTRElPIGJ1cywgPHJlZz4gbXVzdCBi
ZSBzZXQgdG8gMS4gV2hlbiB1c2VkIG9uIFNQSSBidXMsIGl0IGlzCisgICAgICB0aGUgY2hpcCBz
ZWxlY3QgYWRkcmVzcyBvZiB0aGUgZGV2aWNlIGFzIGRlZmluZWQgaW4gdGhlIFNQSSBkZXZpY2Vz
CisgICAgICBiaW5kaW5ncy4KKyAgICBtYXhJdGVtczogMQorCisgIHNwaS1tYXgtZnJlcXVlbmN5
OiB0cnVlCisKKyAgaW50ZXJydXB0czoKKyAgICBkZXNjcmlwdGlvbjogVGhlIGludGVycnVwdCBs
aW5lLiBUcmlnZ2VycyBJUlFfVFlQRV9MRVZFTF9ISUdIIGFuZAorICAgICAgSVJRX1RZUEVfRURH
RV9SSVNJTkcgYXJlIGJvdGggc3VwcG9ydGVkIGJ5IHRoZSBjaGlwIGFuZCB0aGUgZHJpdmVyLiBX
aGVuCisgICAgICBTUEkgaXMgdXNlZCwgdGhpcyBwcm9wZXJ0eSBpcyByZXF1aXJlZC4gV2hlbiBT
RElPIGlzIHVzZWQsIHRoZSAiaW4tYmFuZCIKKyAgICAgIGludGVycnVwdCBwcm92aWRlZCBieSB0
aGUgU0RJTyBidXMgaXMgdXNlZCB1bmxlc3MgYW4gaW50ZXJydXB0IGlzIGRlZmluZWQKKyAgICAg
IGluIHRoZSBEZXZpY2UgVHJlZS4KKyAgICBtYXhJdGVtczogMQorCisgIHJlc2V0LWdwaW9zOgor
ICAgIGRlc2NyaXB0aW9uOiAoU1BJIG9ubHkpIFBoYW5kbGUgb2YgZ3BpbyB0aGF0IHdpbGwgYmUg
dXNlZCB0byByZXNldCBjaGlwCisgICAgICBkdXJpbmcgcHJvYmUuIFdpdGhvdXQgdGhpcyBwcm9w
ZXJ0eSwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIHdpdGggd2FybQorICAgICAgYm9vdC4gKEZv
ciBsZWdhY3kgcHVycG9zZSwgdGhlIGdwaW8gaW4gaW52ZXJ0ZWQgd2hlbiBjb21wYXRpYmxlID09
CisgICAgICAic2lsYWJzLHdmeC1zcGkiKQorCisgICAgICBGb3IgU0RJTywgdGhlIHJlc2V0IGdw
aW8gc2hvdWxkIGRlY2xhcmVkIHVzaW5nIGEgbW1jLXB3cnNlcS4KKyAgICBtYXhJdGVtczogMQor
CisgIHdha2V1cC1ncGlvczoKKyAgICBkZXNjcmlwdGlvbjogUGhhbmRsZSBvZiBncGlvIHRoYXQg
d2lsbCBiZSB1c2VkIHRvIHdha2UtdXAgY2hpcC4gV2l0aG91dCB0aGlzCisgICAgICBwcm9wZXJ0
eSwgZHJpdmVyIHdpbGwgZGlzYWJsZSBtb3N0IG9mIHBvd2VyIHNhdmluZyBmZWF0dXJlcy4KKyAg
ICBtYXhJdGVtczogMQorCisgIHNpbGFicyxhbnRlbm5hLWNvbmZpZy1maWxlOgorICAgICRyZWY6
IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3N0cmluZworICAgIGRlc2NyaXB0aW9u
OiBVc2UgYW4gYWx0ZXJuYXRpdmUgZmlsZSBmb3IgYW50ZW5uYSBjb25maWd1cmF0aW9uIChha2EK
KyAgICAgICJQbGF0Zm9ybSBEYXRhIFNldCIgaW4gU2lsYWJzIGphcmdvbikuIERlZmF1bHQgaXMg
J3dmMjAwLnBkcycuCisKKyAgbG9jYWwtbWFjLWFkZHJlc3M6IHRydWUKKworICBtYWMtYWRkcmVz
czogdHJ1ZQorCithZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UKKworcmVxdWlyZWQ6CisgIC0g
Y29tcGF0aWJsZQorICAtIHJlZworCitleGFtcGxlczoKKyAgLSB8CisgICAgI2luY2x1ZGUgPGR0
LWJpbmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1
cHQtY29udHJvbGxlci9pcnEuaD4KKworICAgIHNwaTAgeworICAgICAgICAjYWRkcmVzcy1jZWxs
cyA9IDwxPjsKKyAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAgd2lmaUAwIHsK
KyAgICAgICAgICAgIGNvbXBhdGlibGUgPSAic2lsYWJzLHdmMjAwIjsKKyAgICAgICAgICAgIHBp
bmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7CisgICAgICAgICAgICBwaW5jdHJsLTAgPSA8JndmeF9p
cnEgJndmeF9ncGlvcz47CisgICAgICAgICAgICByZWcgPSA8MD47CisgICAgICAgICAgICBpbnRl
cnJ1cHRzLWV4dGVuZGVkID0gPCZncGlvIDE2IElSUV9UWVBFX0VER0VfUklTSU5HPjsKKyAgICAg
ICAgICAgIHdha2V1cC1ncGlvcyA9IDwmZ3BpbyAxMiBHUElPX0FDVElWRV9ISUdIPjsKKyAgICAg
ICAgICAgIHJlc2V0LWdwaW9zID0gPCZncGlvIDEzIEdQSU9fQUNUSVZFX0xPVz47CisgICAgICAg
ICAgICBzcGktbWF4LWZyZXF1ZW5jeSA9IDw0MjAwMDAwMD47CisgICAgICAgIH07CisgICAgfTsK
KworICAtIHwKKyAgICAjaW5jbHVkZSA8ZHQtYmluZGluZ3MvZ3Bpby9ncGlvLmg+CisgICAgI2lu
Y2x1ZGUgPGR0LWJpbmRpbmdzL2ludGVycnVwdC1jb250cm9sbGVyL2lycS5oPgorCisgICAgd2Z4
X3B3cnNlcTogd2Z4X3B3cnNlcSB7CisgICAgICAgIGNvbXBhdGlibGUgPSAibW1jLXB3cnNlcS1z
aW1wbGUiOworICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAgICAgICBwaW5j
dHJsLTAgPSA8JndmeF9yZXNldD47CisgICAgICAgIHJlc2V0LWdwaW9zID0gPCZncGlvIDEzIEdQ
SU9fQUNUSVZFX0xPVz47CisgICAgfTsKKworICAgIG1tYzAgeworICAgICAgICBtbWMtcHdyc2Vx
ID0gPCZ3ZnhfcHdyc2VxPjsKKyAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47CisgICAgICAg
ICNzaXplLWNlbGxzID0gPDA+OworCisgICAgICAgIHdpZmlAMSB7CisgICAgICAgICAgICBjb21w
YXRpYmxlID0gInNpbGFicyx3ZjIwMCI7CisgICAgICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRl
ZmF1bHQiOworICAgICAgICAgICAgcGluY3RybC0wID0gPCZ3Znhfd2FrZXVwPjsKKyAgICAgICAg
ICAgIHJlZyA9IDwxPjsKKyAgICAgICAgICAgIHdha2V1cC1ncGlvcyA9IDwmZ3BpbyAxMiBHUElP
X0FDVElWRV9ISUdIPjsKKyAgICAgICAgfTsKKyAgICB9OworLi4uCi0tIAoyLjMwLjIKCg==
