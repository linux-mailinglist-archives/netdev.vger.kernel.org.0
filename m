Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E272E667E07
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbjALSW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbjALSVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474571DF0D;
        Thu, 12 Jan 2023 09:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQzZn3E1eA15CmmJnd2hO3ilLzAPldD4qlvANB3cRgjIaVOkYCHITHFKnRgn9iOI7rScoqAk1DQrXjwuH/5K8/nnOw5MCBdK1HCBYuqng01jxPngYuDKWG54J+yIaQrBkndBiL6x04u7UOjsXUnu2hxWGYIowFxE+RzXqnggdAYT1QXhjWORgM0ECPHE1K02IZbRFd3mj88ZK1Qq0CTqyZqTb1P5UMV0J2VrcUNeP0AhFgeh6ySeIESDpDARnT5mxVenYBeIU4a0xz6kZuh3E7HndzapjEdkmwKHzRijGdSuKvL7FHVo2pYW2iqyB7ZpnRaEmS9/saV6GOZrqZvbDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgcvsB/5iO5X0iJM+4eZSUKv70c5yJ+4a8/DawyXhyA=;
 b=N23xJYf8zLg8GHyFjCx9vovuTEH2QokQW5iLCXAeNA7Ie4OW87AkePLZhLWknl2gVOiIql/WlTJlZLOx+qg7Fx4p8Wc1UZMKcfMyGQRn1D6KIKZdmAhj9KXFZneyIOLQe9k5ofbT9rTWaD/H/AfihG5rRMUKC91hFcO1h2ehxfeu9tI/j40bdttdzte3OfuAN8MiyfzDfz83UEe6L99eAOLn5twRhekbC0IEUES+hhtN7DtQ6mrh8Ylb9SOckGV4Y15he/GcMK6I53XqE5HcSK1wJqTJTwWywYDwR6Yw0ZrKjBNntl7/UMJ8jUZu1bhS/1VFYuzq2MIcNwE7mXlFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgcvsB/5iO5X0iJM+4eZSUKv70c5yJ+4a8/DawyXhyA=;
 b=PW8+U3/8X6q3WJLxkOTn2RNxHG87Ruq4FzpAVtThgF2OJN6QV5HUOWYE9bDNKdBUETMEIAgIzGtaIiyB/j9IQ4IjPPSpTgZSgrIwkC+W36G/ip6FBxeXsK6VmWg/x1OT9N09K4fsqeOxmjPsaodFCVQin+1mKaD68HIzbeBczLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4520.namprd10.prod.outlook.com
 (2603:10b6:510:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:54 +0000
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
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 net-next 07/10] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Thu, 12 Jan 2023 07:56:10 -1000
Message-Id: <20230112175613.18211-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 838c83f1-f3ad-4587-7969-08daf4c663be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fL/YOJFOxMIgrUry9N5rWoHQtJLSvcwFZTRaQubgBuihRydTqK9FnOLtH3tlyiGzVaSCblCMIo/7NDmtzoad0Apj+W3E9cBJtVQ6BlxahKOol96IQpUZqsidG6Lj712+bqznGo7wELeSV08ElqcapEumYfRPqxJ2cK0nxISpdlbvH8KHRltlQ/luzguwoe3M9rKdUa6y6V89V24euQuUHAvTrOPXu4bbrYNIgeB1OKUxM8ie0dBbnKQc1Ov2eezJRg5EJQRyOxBNaqv5+B66YR7gMbL5LhZC3XOefmx3vEgfkYFFqfxS473KqtJJczmh0V6jgvZ/UDw+GudImDomQk1oc7FjeUaKBkB0RyCSbZUuANCYou+QQ+45MjIChYqIRlkII1Q7eHD3yrY6szIIzy9qjaEdIamYpbLR+Svx3p2O4wsd7CFPa+DDrmk6TJu5S5Wa7UPmW60QE/YqteUjtx36XpxHNvZDe40OZgUgpSIYdvY6WNQqq0lr7j6i2+mwoM9GYAwWGNMMmmnN/3z7ZTu2YqXXzcVXmvtvKqUpxL28x7PCLQsNqUIC6NRJQ6U4Z1ey77Kao1CzED8blp9SnfO9z46PWc2qrI1pSfV4WX8a+2vwQHECE3/JNLeQivCN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39830400003)(346002)(451199015)(6486002)(478600001)(52116002)(86362001)(38100700002)(36756003)(186003)(83380400001)(2616005)(1076003)(66574015)(6512007)(6506007)(6666004)(2906002)(7406005)(66476007)(7416002)(5660300002)(66946007)(8936002)(8676002)(41300700001)(66556008)(4326008)(316002)(54906003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1JEMUR5ZHlGaFppSXZ5TjAzRHJGZkZwbGwwVndzcEVtSnhGU05jNXduN2Z4?=
 =?utf-8?B?MWZTTXMvdUt1elJoTTdrdjJ0Q1pDOFZBZjFYaWJWR3NwWGFVZG1lLzZrZEY1?=
 =?utf-8?B?SUVYWi9sc2dwRlhlbXRJWnVHdjRIZllNNFhpODdIZ0VuYWMwQWtkeCt4UnIy?=
 =?utf-8?B?UUU3SmYreWJJRnFGbUp4SVF6a3cxM3U1YkJ2LzZxbzlWN2JkK0dsSDFyVjVj?=
 =?utf-8?B?cVZUTEliTk1zeURwSDNDTm0ydWE5eXF5LzVKQjNHelMxem9WSjA0bUNnWWFK?=
 =?utf-8?B?Qi80cHlNM2VMSXpHeDArQXVUNStqQkdkWlFjdm4wSERsNVpFNWxKR0k1NXRi?=
 =?utf-8?B?Q2FHNjU2eG5QU0ZiUnFQbk9wc0czTU9aNE1Mb0NrZ29DVnR6NEZNNXVLcHps?=
 =?utf-8?B?SWx0SEhpS1VIeVdUNmxWOFFHTlB0akFuQ1FlUVRUOE1qR3UzaExaRStDNkNn?=
 =?utf-8?B?WDJac0ZuTlA4bXBiRkdJcGhxb2d4dWp2UFRHbHVVQlpRSnRMU2VlSFFPVkk1?=
 =?utf-8?B?bkxRZ1ZlWjB1TnpTaUhPMGZqTElBM1diT21STFN6YVhvc1NYRG9rUlBrVVZv?=
 =?utf-8?B?eU1RdVhxU2E4RHFBc09IMXEvUkprV3BBV1o2b3BDWnFzZDVxd2xPUm11UkNP?=
 =?utf-8?B?dVJtVzQraHd3dzJHclFnWHZtSWgwUEZaVk0xenRDZTk0WXlGOVdhcXFta1F2?=
 =?utf-8?B?T0l5VGFLc3NjRE81NGpXTXE4SkdLWHFsQUtpNE5GbVFDN0puS2xMNko5OGgv?=
 =?utf-8?B?OG0zemRMOVhlZUpnY2lsOWFrN3NqdjF6U3MxaklYWEN2WlB3ZDRad0JkUTN3?=
 =?utf-8?B?NENybnpjK3FYWkRSMEpQS1BCaWxYc2xUajZzSU55U1k4U3gveE9tbTlFUTNq?=
 =?utf-8?B?LytpTFZzV0MzLzRhTStPSEluOThnQ0Z5dzlpSysrWjhJVkZIQ3h5TWcvc0Vi?=
 =?utf-8?B?N3pYZU4xc2Z2ai9RR0dHeVBkbVdTNmtQT05Gd3h6MzREVU9iZmhWWjcySXl5?=
 =?utf-8?B?bTJJanljdU5Jb0VUR0NmbDJuSE9Pbk4zNnN0bERKQkdZL0tmN2JZYWZPcnFl?=
 =?utf-8?B?UWw0OXMyZXRwTlhxNUZwZXVXdlh0MHU1bHFPdEZkeWk0SXdKRGYrNVdqYWox?=
 =?utf-8?B?TURRdVBqclUrMXdPRUpxSzNuTk9tQUs4bXNueWdURDJtbk1PbEF6NW9WUTBr?=
 =?utf-8?B?Z2RhUWlzOU8vY0tJTHA3bE5GVnVqa2VmSTl3R25XWnFybVFhdVFMZFNYUk9u?=
 =?utf-8?B?eXZObWlIaVNIQWg4R1ptRFhXbE5CWVdTS3A5SldRL2dlSWxVbm5zTlhkR2RD?=
 =?utf-8?B?c3YzcVF4cTcxMHdBeWUyM1M0K2VwUUxlVXBUT2I0bGxWMTZ0NDNaWDhlVGRp?=
 =?utf-8?B?bUFGNFYyT3liU0RXbFIzYWdsM0k0TzNpd1V1eVB2ajVnajVHNEQ1aTZmaDY0?=
 =?utf-8?B?TmluaVlIUjFtWSs3UFZNcnZURERaekJpQjV1ZTV6anZZaE1Lck9kS084L2dE?=
 =?utf-8?B?ZU9aRE4xTzZKdmNBT3FMQnQ1U3hGMGFuVnVxV3diYzVQcDd1TVBGNWh0ZndP?=
 =?utf-8?B?ekhGb3pXZ0pLOVdqbUpYamY5TlBQSCtobEVYV1l0Z0ZwSkg0RnZJbWtuNUdW?=
 =?utf-8?B?Y3FZMnhnRWVUbnVoRDQrQy85dEtNRUNGdTVQQVVQK2dtUSttajJiLzg1eWwz?=
 =?utf-8?B?L0l0RzFrWkRMYTNWM0k2SnIxaERkb3RRc0g4QTZNZUFjSDJ4cVFsWSsxbjYw?=
 =?utf-8?B?UDMvYUxBT3A5QkgvVmFrQVlDcHJSZUZYdnJwZDFtQUhTRGF3T1U4Qi91M3B4?=
 =?utf-8?B?d09aMVhUUDJVMkdDdmowQ2tSVktlYjhPQ28vNVk5cDlDaCsxUUZHOXBlTVhu?=
 =?utf-8?B?bnBaTW9BMTZweGloSGdmSWZpU0xuOEY1b0FQcHFTd3ZsT3BEQ29wV0hwY25t?=
 =?utf-8?B?OG9ZeVp0dXRnQi9mVzAvOHBibDFzUWE1d2RvMWtUcFlqT3QxRndQOFBDRmFF?=
 =?utf-8?B?T045QTh4VmorSXV3RUwxUExUdkdzajNPU0hGMHJSL1c1VTVId1J4TWkrc0xY?=
 =?utf-8?B?azNVbmtDUm9MVzI5Qit6anRtUEFTc09FclU4aURFV0t2Z3hxQzVSSU1VRWFH?=
 =?utf-8?B?TUFWVVRza3QwS0NVdDFKZkZPWmRHMUMwY0xPdDlLR1RheU14N0U2Vm1vbitz?=
 =?utf-8?B?S2d2OGFOYVZmTUpoWm9IQlUyeGkyU01vcWl1ZEhtZGxCd0RIMzJSUzJaU0JR?=
 =?utf-8?Q?BOrIJkENqHV/Yd1N+I5ByucpbLuglvWvCOZqE8tUwo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838c83f1-f3ad-4587-7969-08daf4c663be
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:54.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5ZLyEPwKtymaLcy+LeRVwDNtnSN3HnoujGCA31wGG9tfvctbn+v4LhB/tSQwW0ouTKdVU3K5UNPliMqGqWmSdyIvOKTK8YMLJ0FVEMOxuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
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
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v7
  * No change

v4 -> v5
  * Add Rob reviewed tag

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
index 20312f5d1944..08667bff74a5 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -165,7 +165,6 @@ patternProperties:
               for user ports.
 
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

