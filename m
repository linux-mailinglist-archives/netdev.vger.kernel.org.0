Return-Path: <netdev+bounces-6812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F8171849A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73BA328157D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE4E154A5;
	Wed, 31 May 2023 14:18:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1A14A9B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:18:25 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::60c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49F71BD7;
	Wed, 31 May 2023 07:18:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKgqPCoZyZTz9OxjfqK3e6EeHeUC398CRVtRK7KPPUH7z8VGljCvKJF55Sg5P8szbGaHkzueU7dbffrxLKYLpJxlsec03VeYlVVG5ESYjb7T6SOBncz1iVxGJ4N7wIwmWPPpUj2yjHDFG4DJ0gxbjOv6uurbaAUVa2kHaGc6BO06OUJHRQ3VfKXtJnSBB1vNvFCGV7JVLKloAmGAtRlL2DDQ1CRaGbZqdHmt8N3dl6btpTTrbvj9C++7sytUvJL2dLGe6YyNMoLCrbYz45TuSaS9o0YwhKAhM71ysuZLyCNtMBuykFTxkgzkdDqVlQPipYh2bdLVmiGcXG3r1Aje9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkj4lxc9clhHb7XfmeIhxucIqooNnwO/emd5hMXww7Y=;
 b=kCXwnHYlWAj73bsjGvMxBf7KONjhTxNylB1xr66oqAelpjb1yJ7fK9fZVytkTjwudqiBo78mzXJ8imBtTvLgVD7hzxdVSAUjnwPzTbto64J7VexPZ8eO6gNLIjAjVDS4Bi1qZCQZsBTlYiIDMORphgqI99H2XrUKZBYa+rBuL8oX7hB198Sr6vxCd2pUBUiWRr22dyXtyHiOHM6aTcjdnuaUpj6gPh+WHcBvaFlt/cpeZ3F3VVVnlxNuhQA0sZ1qh5M2b1MfrM1JCrghCDGx2CS2TXICzI2UdGnJBVr+fEmOpMs/j+YcWlvux5b/sW15UWP+J6V+yiGZSINxVk/6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkj4lxc9clhHb7XfmeIhxucIqooNnwO/emd5hMXww7Y=;
 b=YEUbYtGZIfwkXJU9qfEJrj3p21nYXBOhuO3uzO+IFx5TD/QB/SlJtcWBEB/NembZTgQe966y9vVUIrW3HhwDdNXJ+2rGDDpABWA3RUov/s+tlveszpmGGxf6Z/jt1WL5WAs34zEXH2XZwFs+1mzTIVM/BL+p1eHUGEig3tf+y2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by OSZPR01MB8138.jpnprd01.prod.outlook.com (2603:1096:604:1a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 13:57:57 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 13:57:57 +0000
Message-ID: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
Date: Wed, 31 May 2023 22:57:55 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
To: netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Horatiu Vultur <horatiu.vultur@microchip.com>
Content-Language: en-US
Subject: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy link
 status inversion property
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:404:56::27) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|OSZPR01MB8138:EE_
X-MS-Office365-Filtering-Correlation-Id: 824a1794-cae9-47c7-2c60-08db61df09ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zpztyfQ6e1S25M3pvr/5A0v6p1i5Y6vGJcntvMgeQpK4nZ6aC57drTdJmCkSkqq84iy25KN/dznwXwZQ/UMCYZGtl/mQZFHQfbn+07Z8HDgaIVpa8xDa9VK48LJIECm2tDKsa9xVwpOXWXbXagtomUOK7cUz9svEj5gUPFKgf12n5XvLPBFVrJcrPBa1HGzvi/qTO/OtNnscJS+SUQfzLU4zIq+gUgGNOhvadFZ3p+bzpk0IIELtQnUZapKHDzXqEJ0ijIBE7p5k9iZI9AHOkZroaDXiGIZXzBVQPXX6HFSMT+EMdZG3HiQwh0b1e2Os4sYG/J2Gu5DSMWnYVGN6FXGFIcfnOJT+TAT4kL9vxf90BatrNSXumkTqeTFL1fW/y12YCPNDVB5v1jAFoI2yJRyyf3AJ42x5+ip75v4TPxXgKbViG80WDzJ+SGCSiy0exkWCj/BBqjlFrHKjOFJs6oKOrW/oemfWtLOGzrd3yh83dzKqbGQtbTu2UiuBgs6i5Rjo5EKOxuKAWLoe14ovFKz/sQvOm4SpJMrqnZNfVbCTf7e/hFmJDKRJ+eWOPDvfcDkHqS+7cY4T+gu/GEwF6zqmM4oAB8Qh4Gv4bBHiuqRh67mzBQ0tVkds4bbx+Gr7iKH5+xISRLWzGHmgMsskLQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39850400004)(346002)(396003)(366004)(136003)(451199021)(83380400001)(38100700002)(41300700001)(31686004)(6512007)(6506007)(186003)(2616005)(26005)(6486002)(478600001)(8676002)(54906003)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(8936002)(44832011)(7416002)(86362001)(4744005)(2906002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nmt3U25yQ1hKd05OUmp5ZHRlZTZpNEF4WVRjQWltc0h0NE42UTNQVldEQzdV?=
 =?utf-8?B?SG44cEtsTUxlVnFrYWNsSVNtRVVPYjZLQzdYWVFaT3IwdzBsVjV0NGo5WDZh?=
 =?utf-8?B?TXlWSHlKVnBWYXpPZkZGZjNQbm1PbkRHa2ZrbFQ1NUpSbVc3SFBzTkFYV0Jw?=
 =?utf-8?B?eHpnT05sczVucExUWGpNbThEZVFNeitJYzFNS2tQRmVHZE5FWGdQTmYzRG9K?=
 =?utf-8?B?VW9XOU9kZVV1NFZhNStBRWh6bUJORkhlMEttYk8zY2RzL2FValNoSDFBcCts?=
 =?utf-8?B?NHh5Y3FDUkc0cElQQkxUL0VOclFKbjZBZUh1OVJSdzhRWklwSDE2SENhc0Z0?=
 =?utf-8?B?MyttTGVPVnMzSmZjUlhlb1pveENjK3lsZWh5c3lFcHcyQWlvOUV3cXcyRkNo?=
 =?utf-8?B?cU5yMDRwU0lKZmxpaHQxS0lJZDZSc1k5WmJkNzVKQlMyVjF1cDd5M2tjRDZW?=
 =?utf-8?B?Z2FBOVgveENpQ3RwUTUwMStEN0FYbUJzVDVYQks4VjhhNXdRMFF6VWJ3b0xV?=
 =?utf-8?B?MnJzS0QyRHgyVkJjdko5NElZTms1S3gwZzBGQUgrTXg5VFdOei9FRitINWxG?=
 =?utf-8?B?eGxvWFNIaERtdnRTY3U1Q05LeHRMblErclRzWmRXWWMrUlRoRDlyZGZlRmI3?=
 =?utf-8?B?YWZRakQyZ0dKMVZwcWFsRDlOejlkMGVOM29lZXNTT2IveWJmV09IZS8wV0JD?=
 =?utf-8?B?R0U4blFiZHlRbTBRNUc5RU9PVUFQcTcvUTVCQklMcXMwSU9ad3QvQllKWi9K?=
 =?utf-8?B?Y0QxWnEvYW9xMnB0MjN4Z0Y3WFN0VDkyVmpXYmhiTkp2R3VNbkZvOWhPempr?=
 =?utf-8?B?dXZIWm8zUEQ5N0ZSYnhnU0RLcGoydE1KYk5adkdiYS9pK0xMSnRLY2NkMnha?=
 =?utf-8?B?S3NlNy9XbkZWWGdnZTlLL0k2ZjI4bEQwazAxS0ZmY3VSekFNYU5GT2NyRGVZ?=
 =?utf-8?B?bTNMQ1lzM01qREJSREQxSmx3TU11TFgxNnhZQVpMZ0ZLaE1uMEIyNVlzb2VL?=
 =?utf-8?B?OUdGU3oyL0gvUGYyc1lyT2xnZnFBRFlOZ085RlBZVGFiNXVTN2QvWFVweWhE?=
 =?utf-8?B?elBjRnE1NWZUU0Ird3ozY1h2T2lONXYycnNlSTJjNWFsNlhPUlNXd1A1dEVi?=
 =?utf-8?B?OE5DalFNbENrYjBqVnVTN2dFa2lGRXlweUV5SDNONVFoYzNhZ3JhVzZPbVFF?=
 =?utf-8?B?U3VaekVBb3pPUENvbFpnYjBBWFhtUUVjRVp3aGZNYTNCZlJmUzFOM0IzRkNh?=
 =?utf-8?B?ZnRIRms0UnE0MlFhNkJkdVhNTUY1aHlWR1RCQ3dqN3NlSHRhRkx3ckdDaGlP?=
 =?utf-8?B?M3BZcDBNRllyZlduQlplUGprMDF0bW1scCtUSSsrMlBrMGtoR0pOK3lNcWJ6?=
 =?utf-8?B?QkRyZEZQQThta0MvcFNmSTNPTjNlaktMNkNoUXFDa1lOaGE0anJLSVN1dURw?=
 =?utf-8?B?ei9mWFEydkFRcGovTkcrZ05UVUZBbmY4NjVOUnk2Rnk1VVNiSUJTZGZFdWN4?=
 =?utf-8?B?WDlXTXB1THRDSTdZS3NnSXFxWUpFZEJ4cjArTmxWM3BHZ09XdmF2Z0dydjkr?=
 =?utf-8?B?YUVkaUx1NFI2WU54ZHE3VllNa1J5a1A3dkZ1aC9ZVC9uQ0ZrK1NRQktIZGJn?=
 =?utf-8?B?RE54V3VCVlUxTUNvYmZqZWowK0EybysxSG9TdGNWdUl5S1ZEajN0cnJlaGlM?=
 =?utf-8?B?elNXM3VxNldSYVpNVjVVNXl6N2hPMkpOaG1keTJndWRicHFTMWVLWDdoZlpK?=
 =?utf-8?B?cXVzL3lFc2IxNEZPeTNPcmNQdGg2MWxnVlQ5enBNY3QvdFdORXdudEk1K1lE?=
 =?utf-8?B?VDV4SFZvQ2hXVnRYUzdkNEtPVmwxU1MyNlpGZ2U2NnNnVnk5MzM2ZDhrY0ZW?=
 =?utf-8?B?eUFaOVRReGtveVovSHYweDYrTEVwV1U1d2JYNW1FN1RyZ2FneklnZXhyOWFt?=
 =?utf-8?B?cEtmYi9Rc1lKK3hFTlNaTVBCUTBDRHdSOTl2cFhrVXhaVUdEWk1rMnBiMnRL?=
 =?utf-8?B?M2E4YWNBaDRGcitCQ3hJLzV3dTFXT1VlNFlZbzUvc0hMSjVBWkNoTXc4TFdh?=
 =?utf-8?B?UU9GaXVKQ0tkL2xxbWp3RzI4U0JHdHRjSXFhUnE0UTdoLzkzck00RVFVSmtU?=
 =?utf-8?B?R3BDTGpIdEdneFFqZVJVVTErdTk2UkkzbTJHWWhUbWxqRUd4Q0xtY2hQa2pY?=
 =?utf-8?B?bWc9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 824a1794-cae9-47c7-2c60-08db61df09ab
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 13:57:57.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ADhBd3jgJzq6XPK7HF3ADxbWh87Cyq7VDrlzHQ0MauH1/7Cszm+DLOVzHex+AspLspAxTJIuRq0lQtnnYJngomvCwJCalWH8UefUso6ZKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
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


