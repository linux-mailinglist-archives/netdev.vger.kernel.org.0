Return-Path: <netdev+bounces-6243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA5A7154F3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1FFA28105E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE8563B2;
	Tue, 30 May 2023 05:36:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AA53D74
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:36:51 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2048.outbound.protection.outlook.com [40.107.114.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FEFAD;
	Mon, 29 May 2023 22:36:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feIxW3po2dtVCcFTMLwRh2mBQVc/PZPymiAzB42i2joe+G8CBiUg8RO/qvcuy0EjYo3lIrOxsd2n0vmX2eg/FZ56Vcrd8R5Rg6vwrPMiswg72j1dW1XvlGFaICBQ5OYIblya0/VxZR/XQDZacPcXyIXMiCWsuYK2lKR+ASjdNZ/lrWIGlW2A5Q00SJVerqqtdoU/RIc+guO5eWeXYZ9oU1i611ur9Svt9RUzaEux0UU63eizH4onEhMW4bjqzIq2U8eHx0zoR0jfx+SUBcE6kXFZAq2di/NPJVso5XOWQIHDuGPkSDmYu0DSVhYYEr2QKRDSK/8TTS7nuIlhxcC6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkj4lxc9clhHb7XfmeIhxucIqooNnwO/emd5hMXww7Y=;
 b=f1pAwJQHXD1r+MMTNHggN2++Xlox1bws9oFIJvM7QnkKji9GxIiglQ+lPCOTLaiaRR7y8H27EclOQv5+/9dOK9FE9Z5kFrXhZuavhOG4GXzvnPaiyrvVc/6OPLaLde6XpVMl08r+qMYpfg1vP5bJ9g7dcmCEMAcI5MXaQRZmZyeVdEVYQcUQJ/tQdLsftO+vOuHOux5eBC8u4rDybDl4Xa4rcl6Gsfi+J/Mzahm4NM7R+DOGbIlVTb3xe3WmHuL5bzHUiRnHvvIpn2q0eksVSWe61hvQeBX//4H8JZBEeclPmat1XxQD7YCAtTg6E4rVrRFCwBLx3GcaDXTErVOt9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkj4lxc9clhHb7XfmeIhxucIqooNnwO/emd5hMXww7Y=;
 b=gNT+/lhLJHv8J7+sf4QB4Y1Yq9cfi5WgT6/eI2RzhWy3AXzfJIl5Oii2kHd8UKMIzDii6VkM7mMzAEnqAPVApihFqtMsA4mDsPoEYLKurlcIKLtJUl3xIpnTob7X/AUIYi9M5he+BFI7M7xljLTAgyzgdm8toV/5CNivhbQnd/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by TYWPR01MB11894.jpnprd01.prod.outlook.com (2603:1096:400:3fc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 05:36:46 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 05:36:46 +0000
Message-ID: <1bb924e1-37ee-db64-a7b3-8873b13a1a91@sord.co.jp>
Date: Tue, 30 May 2023 14:36:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: [PATCH net-next 1/2] dt-bindings: net: adin: document a phy link
 status inversion property
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:405:1::36) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|TYWPR01MB11894:EE_
X-MS-Office365-Filtering-Correlation-Id: 0325b231-075f-4b02-7f8b-08db60cfdbac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	H1dwqUt1o0V2yC/VDXTQdvTWzo66hwbRxmUlKWiimRL13Oi65EePLvx49KY+3eWULH4Pem9KdxsnMQxQe/HOYHED7ZvnC5oIZNvgRzj7KAksfMBRKEwiAKlvkgm0iM2MWLvx3s+xC9voLal+0UzItHsOfNWKk091cS+TwOablhKaeI5W9d4obCbVUqbWX0MoD7jZDvM9nJ2OxGNl6NSP4BqKAobxGH17c8NA6tN8pkboNUnlJfrXTgowAQFU6YJuctk6jTTbeTjVX2+TiprJBKwxNWyDj0iqOMar7pb8KjQBZixzSv8jmPUAAStOQ5MrnVFvoK90D1toapp1I0lyRe+DAln6XC4ePOCaGEOIone1ly9yYZmy2bK4fIezJ/8+Hn3DBETmcOWnog0ImLeDf6/AJxyYvL0u4YJfbYeR5799L1uQ/eQ8VVM2Jc9TKf2Zk3YsddGa6bZXqhfeU9N7ELUykWPDWPnKm8DFye7EU7pdti9TH2Rr2gtWgHoyTbXqFwy6JFWgxFBUfDgfL8ZvNrFtRzUcz7PbS1tAXbykqvNrh7naK1utcJ/Xm9ed78ir7NKjvKEEwtgQcUNZ7JHOy9hwTmUsiKJqzSaQUw6dl4CEA/lvtP7Cy9JAqWw4G4ODyDFB8t/0bUrlD02W1ojFxg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39850400004)(451199021)(478600001)(8676002)(8936002)(54906003)(41300700001)(5660300002)(86362001)(6486002)(316002)(31686004)(4326008)(66476007)(66556008)(66946007)(6512007)(44832011)(31696002)(6506007)(26005)(186003)(2616005)(83380400001)(4744005)(2906002)(36756003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDFsN1FaT0xzQ3cyZGRTSUhrczlwbGdhT1Y5L1Fkd0k3M2ZTamFjTVFmSFZt?=
 =?utf-8?B?RVlZR0x0TnBTVzVqTTBDanJSbUxlK2NUZWo3RjhMWTQxc1VXa1Z1dHJHL3NM?=
 =?utf-8?B?SldZeTZxbWJKcTBwdnhVY1lHaTZQbGVaamtRa2x1aDd1ZnUrN0dnSzlwODZk?=
 =?utf-8?B?WTV4VEpCbTE2Q2Q0eDRhY3FZVVlvcDBZaWtEakowQ1VocVlTOElHa2N6YlJD?=
 =?utf-8?B?b2VrOVlVNFRNVlMxLzZic01ONjlhenBrK05sRnRKaCtRYmZjVzRTeXc4VG42?=
 =?utf-8?B?TWtGNzhCN3JDQlhzaFlpQU1tRmhaQ2ZVWFN4VDY2czNvWHVTNjZmZWM5RnBW?=
 =?utf-8?B?bWpCLzRlNGwrRVYwWHlTZ0hHSFBjdlc2d1VGQjhNOFcvSmJUb29LU0RPVnJG?=
 =?utf-8?B?bWFUdWk0eHlRTWZMQUFxZ0pQVE8rQUkzcWZYUS83UXRLUmRRK3puT2hmcEhS?=
 =?utf-8?B?cWZINkljdDNMcHZjaVFaN2NiTXltWmVjV3hYZmpIV0lKSTFURG9TWDZndU82?=
 =?utf-8?B?eEJWN2VyOHFJTFpLRkZPZWMrc2RmZEVQOWpQMU5BREI0ZnI1QlFRK2R1R1pv?=
 =?utf-8?B?cXhDd1NkcmZKSTE1ZWFLcnNYdk8rN0JRTTJuKzNzdUlKTjJZWVFoaWZZU2ta?=
 =?utf-8?B?R3pralhVWkdMK21xb2k3ZERIcHNCcUt0b1FTTzNWbzZpMCs3cUxDb3cxd2FY?=
 =?utf-8?B?eGY1VzQ2ZTExUlk5TUFacWhwL3JUYkJuSUQ3eWExZ3YyTWVwTVZ5L2hCbUZQ?=
 =?utf-8?B?UkpvQzkvTW9RYWtMU2RJcndYMGlWRExOSnVpeHY2UHlIV0EyazBJNlhsWTlI?=
 =?utf-8?B?ZlgwMzBCaUtpR2VCVjVSMnVydGNPeC9kYlEvK1pLTEdNSkpDbjhEaytVeHhu?=
 =?utf-8?B?bWRKd3B3UHgyMHo1ZXBtL2Z4M0tNQWdKU2hLZXhVQmRTZnU5Wmc5aGlaL2VV?=
 =?utf-8?B?dzRZbnc0d3JqTjllZWR4UElZc1RObVpVOUxwb2JXUEppa2gwWGdobXBjSmRz?=
 =?utf-8?B?Tjc0OFRNcjNhNFQzNmp6YURZR2FWYVU3LzdQdCtRWkVBL2JCcmJVM0QrY2Ex?=
 =?utf-8?B?YTdwL2NJUnVqYk5TWGl4K2FqMElGaUdGOUw4UzZiK2hIMFF3ajduMG5zTC8y?=
 =?utf-8?B?OWhGaTFyMVB2QWpPRWJtdEpJNUZMZnJCK2hXRithMERLVUVxV0NyMGt5c0lv?=
 =?utf-8?B?a0NFeWdtSHhoU1YwNmU4UjFyUGwrN3FYT3ExM2t6a011Y1lUVW9KcVBxR08z?=
 =?utf-8?B?ei92RUVhMHNScFh0UlRmWGlJUGdjdEJwejNVbks1eStwL25qNUxEbVpYWnll?=
 =?utf-8?B?YXZzSWJ3OE11VzE2WG1KYlJYeENRNE1nU2s3SCt5a2dYdmxNc3RpZnFyZGpi?=
 =?utf-8?B?MnMxcDlXMnZBWFdIL21hZ1hhR0FleXBvck91Q1ZLWDkvK202Wi9MbTg3c1RB?=
 =?utf-8?B?aVlNSWg4MUVqelYvRm5zMm1KdTcyZGVYeVFwQ3Z6blc4WThqRm9Eazl4Y0pl?=
 =?utf-8?B?U0NiKzQ4ZVloTUJUbjIrbjJVNzNYYzRpRzRsWHBkUHVaM0FpbVVJUFo0cnFV?=
 =?utf-8?B?Y20xbWR2Y0hGN0g3aUpoRHYydWRQQWdBZjhTdUVFSlVEOE10ZFRHOVhKdGdz?=
 =?utf-8?B?SFd5em5YZUd4UGhiNXgwTFJlaFdrZGFXTForN2tmSElqNG43bC9GYWJPUUZ1?=
 =?utf-8?B?OVBubHpIRlRtQ3FvRzNSeHFZNWpDdmUxaFRESENYMTlRZ2dtanNvOFhtZTVO?=
 =?utf-8?B?cWtYRHFFMkVsMXdlLys4cFdZMDBpcFRvVFN0K0JSVU9KSTBQZ3BSL3NaekFT?=
 =?utf-8?B?R1dFOFlVa2JFQWROWU1YcmF3UDJLdkFTck5WNC9LY0JzYVcvWUQyeks0bnlF?=
 =?utf-8?B?VDA3N2N3SkV1emFGc2RscGF0RE5tWFZjbS96eStUMEpKQzArZXp6dmd4MFBo?=
 =?utf-8?B?ekZxUWNGU0Ewa1RFODlGUllhc0ZtWHYxYVlubTNSc3BuRUFqZzEvSllWd0Zi?=
 =?utf-8?B?ZjFxUmhHTVRQalBJRTVWVTJTeEsxY29wbWZRVWt0MW1ud1NzUVIvSUl0S0VF?=
 =?utf-8?B?NWJ5elpnNy8vcjg1akdtQkoySkJZNjZUZHhQVklhVDhyb084c3JFZytkQzAx?=
 =?utf-8?B?dUlsUWZ3SGg4TUUwQTczd2VsNVR1MGp0dFZlY2xWMGwwZ1YyT2NSVWNKakor?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 0325b231-075f-4b02-7f8b-08db60cfdbac
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 05:36:46.4506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgHnO4NnizGvKyyeCbgz0GOalhYagcEfjTY6OUy9umfY5TUVwYbTcd6EWRRN0Zl3VqgvNb1CTP9g6MIXI96BTwFK77a4BQafzzYLHjWvJsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11894
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ADIN1200/ADIN1300 supports inverting the link status output signal
on the LINK_ST pin.

Add support for selecting this feature via device-tree properties.

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 929cf8c0b0fd..cd4a1461da1f 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -52,6 +52,11 @@ properties:
     description: Enable 25MHz reference clock output on CLK25_REF pin.
     type: boolean
 
+  adi,link-stat-inv:
+    description: Enable the link status output signal on the LINK_ST pin to be
+      inverted, meaning that link up is indicated by setting LINK_ST low.
+    type: boolean
+
 unevaluatedProperties: false
 
 examples:
-- 
2.30.2



