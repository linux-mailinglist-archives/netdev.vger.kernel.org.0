Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F2640F5F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiLBUrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiLBUqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA61F3C28;
        Fri,  2 Dec 2022 12:46:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbNpYoUQMz+iXr6CP6HspaLyM+Rl+XyEcWlIusVIOy2a08OqTMJP/7CDoKpTTvtWfxhVi88QzYrZI1qULAeuHbhzTBmgEZFYI8xs98RTHXZNqb39Gp7mZKyHoWbBmF0wPuPHQYp8PbHrE7WpWmbdIOTcnlkGv/nhBL+cYHUk2ZkpcQEnpwChDCgX4wiW8IQztALYr1rV+D3xe+k5DE0AAS3AQ/KmKxb8Xm+3c5WwT/FE7nE8bDPgg65DKBX4+t5hDqHxcIHpBgz10V0bpPIv428fUUtm4uOSV4nLtvs1L4uZESivcI4amUyM1dk/96MtOeSTl+pmWvfsIfieXByvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jl/NCYpi16aa7JdocSQYkcxqUtpWAhrJCMBBpd96lyc=;
 b=ROkv2ughFnqPqKJTTy4cN0ov56eTrz1znyJ55oQgePj1Jb5IjKM/jsJlxUHzwGUGYbAifQhVJAD8hr1hcAp/PK8BfQEFvOOzT/BRa2DhmcF3715ERrXjscTdrD9qxw/wx94FsrlZ56ve3ROuJPZ0jpkgiqxogFW/LJ0PjKuZJi6XOgA6tKxpagd7bwG+xm5LEp0mibjw51OZy15F3DBWUXQ7JVrrZF34WqYhOm6OHjWlqDD2BNHxClyQ/7jADT2FvgiWHcXeiQJQ5dZZ6+9RorqMa75lUDZ/dxDO4NvT/BpTaDLt1ItbKeUEXFyXNBj12zJjik0GargAcTWj3ehz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl/NCYpi16aa7JdocSQYkcxqUtpWAhrJCMBBpd96lyc=;
 b=s2rwrLLUn3P8aKOUWczRoovPcIyzMfPj1ie5LY+4OKTgWl/R9bvJJSRDaGk0H/jLz1fweE17toFVhtwB2Opap7pT0dYS54+mEx9WgHgxmHymSrS7ClavoMViAEzSKR2r2Obeo4P9wVx6IRPqYU68FEQu8Hc7uNDZtfSDdWzT1rc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4944.namprd10.prod.outlook.com
 (2603:10b6:5:38d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:21 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v4 net-next 6/9] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Fri,  2 Dec 2022 12:45:56 -0800
Message-Id: <20221202204559.162619-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: b297dc20-bdb0-44cb-d9d7-08dad4a642ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fx8al0o4fwoVCz5iG7RZkILFpqPQ3Y9cNyAG3G/Jlr8NMSBNo1F3E6o5mJN9/lUdfkI7RncrPu8smVsGWoODJN6EPhtduFjwl00VDs+uoVEKbhAhriR/8pR28HIeV+FYirJAlw3eQJOu0EI5ilL5EJ7rVbxQvZfXSinGz7885s31AG2fYQfdLDycmUl7dKIWWQi3tPOkhzp+1dNy+Z2GZhwUq0nF8PlgojH+ci1dBAL+cS4yVpLsQqbbEPYL6HzdlScO4PfXpGwFl4eBcMawxZvxmYmg43vEYtV3WgEenNWlbmUlwIEY2g41g4yH92Bp9Y0Bac48tyPblR31cm0BeMB/rca9eJw+MOfLgmjhVmpYuMPbnKRw7ZwUNpK2nfM+6/eSZqlmYCIS7KdvZHYrgS4uo6ZlOwp/wxLdPeDpnhLSZFRjeIRQX9HycOKutLVePasye0zdM6tyiuIvjdncA/A0ol2bnQPXgPLsxDbtkzgvYvWTDLCU9F67qK/ReKD0SWUEUBzRD390icjSaV85FDOZWyOVQkbb4Ghu7LQdIzvj6TvEpc/G1LOXvd2E6tvDR+BVb8GBckN8wyD5WYQD+J5TW811UpZTfoAb8Kz/YBKtM3TCwqqKB95HA+9IrEtCrx85wYAoL048dGBHB3JMj7WduZwpHeUmvneXmx+Hq9MAxLgtkz7t3CpD50xODnrS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(376002)(346002)(136003)(366004)(451199015)(38100700002)(38350700002)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6512007)(316002)(4326008)(54906003)(44832011)(5660300002)(66574015)(7416002)(7406005)(83380400001)(2906002)(41300700001)(36756003)(2616005)(1076003)(8936002)(478600001)(6506007)(6666004)(6486002)(86362001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWU1MWppNmIzZHVCSStTYWZGZ1doV3lYV0xTV3llOFE0ZGtIdVFWT05WZ1lz?=
 =?utf-8?B?V3hVMWx3MTI2ZHlrUFdNVndEdEU5RC9icEFaN1ZPZk8zM0cxODNSVGM3SW9T?=
 =?utf-8?B?Yk52Rmhnbi9qaEFSWUpxNnVkV21LTnhwZ3A5V3VSSzJ3bGxRQ3VrYlJ3TU1y?=
 =?utf-8?B?K1ZQdUFyc3ZrYjJBSUYyV01Vb0lBWVhUNzk2QlR1Z1RobDJ0U0hPbDdWRjBM?=
 =?utf-8?B?a2J5a2NrZU4vM0QvcmcvaW9EQ3JNUmttMmtZTUhlbG9lTEpkbTFIR0IrbmdF?=
 =?utf-8?B?MU9scFJweXlBL0kvSklwVWc2ZUh4RC9KVGZJVENhNXhhMXhCUWFvbEhTdkhI?=
 =?utf-8?B?bVcyL0wvanBOT2ZtWmloYmw0ellvRkQ3eml1MERpSFJMcDBKZTBrQnh2bnJu?=
 =?utf-8?B?VFZjNUlRNGRhR2c2ODZIT3ZUY24vYm03MzduYU9jQStIcG5TdG9HWFhkS2lJ?=
 =?utf-8?B?c1pnQ2JLeW02VEFyc0hPdzI5MFMwc3RYM0IyTDhTZmwwY2QzZG5PZjdzZ0hp?=
 =?utf-8?B?RDF2Y3VNdzRleGUybUFYTkY2cGtweDlKYVU5ZXdJcm15Z0JoVUo2d282K2lV?=
 =?utf-8?B?T0F3S0lpS0ZMTkEzM2NjT2hlQzdVK1NZejlFcFFKa3U5eEc3QnNYSFJackNr?=
 =?utf-8?B?Y0JJRnFKem1UcWlOekV2S2lsVGpKbUV4ZGpRbjJWa0JpWjRla1RqTGtDSm5s?=
 =?utf-8?B?UEQ1aXp5MTlkYnVxSy9NK0pMdmhsdU9hcUc3WE9WWlNJZUZWN2gzdTFmTUJY?=
 =?utf-8?B?VUg2TEh4UXlmNlUxcGRJZ2RWN09IbVNHZlFya2V4SXdSS25sWGFUeTRUOWxW?=
 =?utf-8?B?QnprNE9kbFBEU2FLcUUvYy9QUTNIM0ZrZGh4UmZhVG9CdGljQlRqNjVJQzZ5?=
 =?utf-8?B?bUNEZTRFbld2Q3M2cllMbm84ZDg3ZFJpSGRITmhVQzE3ZStadHliaU5LVm5T?=
 =?utf-8?B?TXZ6YkJrTVBsOHlINDdMckpIWDdpbVgvQndOY0dmZkNxbG5GVGhlUHlFZ084?=
 =?utf-8?B?ek1JMTdTT3R3b3c5dm9KSlNRTFhvcWw0NGxrMmpWdndTck5hc3A0aXBlY2lk?=
 =?utf-8?B?M1AvRFRPbytDWWtPN3NSOXFGUWlEaWZ2dFhwSk1sZ1N6d3UwalA4THlaQkxr?=
 =?utf-8?B?U2ZIMEIzeWhzMjlQeWN0dlNCRXhYM01GRFcwTldrelNpRVl5WHloVzRPTS9m?=
 =?utf-8?B?bnR1NjR2U21BWjZKcWtxL2kyY2k5dEM4OGFUcHF3dEQ5OTV3Ymg5aytwYXZ0?=
 =?utf-8?B?aW1pcDlGUFB4c1lJbmU4Ykw5MmVYdzFFZm9JK004MkZrUzhiek85SjBhSmV6?=
 =?utf-8?B?dHZSSEs0bkdJeXVXMGFZbTZLV2QrRkhycmI4ZDFzTmJhR3VFNDd1c3RvN0g5?=
 =?utf-8?B?YWw5U20rSlRoUDcydk00aEp0NmRoblVINUJldmtJdTBhME1PRkliSXNkT2NB?=
 =?utf-8?B?KzBuTXJjaEJNdkVGSW9Vay9ab01WODRGajdIbG1SS243dEJMTSsxZUtmd3FF?=
 =?utf-8?B?MnVxUHUwSjNKOGQrMVdteWZSZVVkMjlTN0xyWUYrNDd4WW14Z3A0L3doSG5N?=
 =?utf-8?B?bGVwMjIrK2U2K21GU0lLdThNT0FiV1U5OXlBSHZPTGJxeHV1cGpVTU0zLzNY?=
 =?utf-8?B?SEJCcVhQbEpNVWlIeTNvSk1QelpYQUt0V2dEOFFzZDkzNjhlcXk0R1dtaGpR?=
 =?utf-8?B?cU00YUltR01NV0dweG9JekduNWRROXYxajBWVEVXcUNpTDZ4ODloaG9TNUlB?=
 =?utf-8?B?dHgzazQzSXdmMkk1Um41K0hNeVk2UUdVYVgwVlJ0VFVLNkIvMkFxYmZROUpV?=
 =?utf-8?B?c0ZpeTh2bDBKYWRYWmlXTUJLcThJVjNhUFN1dXd0TXh4eTVyYjVndElDZmpL?=
 =?utf-8?B?SzJvUGZYMk92ZFVCTEdsOUxGZTlrTUNrcmhOWkc3ZlhBaUV5WmN6UEFCNExj?=
 =?utf-8?B?THIzd0VjVWhCdllhUmFXN1cyQmlSODNiSUdIYlk0OTlmU3NlQ0dTczdXSmlC?=
 =?utf-8?B?VkNmckd1NWNGTk9ZNE5XQ0pkMHRIdkxnbExvemtpTE0zRHFzMlVIQnZMQjlk?=
 =?utf-8?B?akQ5ZzBKcHh5cTRNUHFVVTVYOTAxdW9kRVlPZDJDQm5PYWNBUnhnQ3ZzeUx0?=
 =?utf-8?B?a0FvOFRPZ3NtTWIrY3ArMmpKVE9XVkpPa05WdmNwMFhyWnJqb09VdVd1Sko5?=
 =?utf-8?B?Mnc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b297dc20-bdb0-44cb-d9d7-08dad4a642ad
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:17.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odBkeUmeCiy12b8eBiTd/HWQ3b7Pq+IYTU5wedAfQLdGgtA2TjKEX7uF9wY+rG2nbvXFvEl8zo/Eaa3QruKL5JaVQRff3+0W8S9JXzLWxNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
the binding isn't necessary. Remove this unnecessary reference.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3
  * Keep "unevaluatedProperties: false" under the switch ports node.

v1 -> v2
  * Add Reviewed-by

---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index b815272531fa..b65e55be3ae2 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -157,7 +157,6 @@ patternProperties:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

