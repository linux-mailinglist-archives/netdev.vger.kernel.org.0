Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1577648CE1
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLJDcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLJDbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:13 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930308F0A7;
        Fri,  9 Dec 2022 19:31:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzUjwA9c1FKbCmXoPrGu6lNKIgyOuacAd8dezi2CEW/yPmhzScfYeE6IpRxpoebTuAB6dSp4h5mtZmuwFyBCwfcl2BIFsNGbC8cCFld3xHLYWd6JDsOtF+mschjcy2UDWEEUQ4/RzgGY8QDXaqTLXCChtq2gGyJ4pgIYYtWY72pbv1KjMOh/YwB/AbjTZZnQkq0t4kZyC/Wm8gVK7PrEnqSlbCiDnZ6FmoifOeWClNd4rJ7cw/RJ0/PU/6z+uYkqzY2SGfeCzoUOEfK+jnOKOkkvkte9Og2vYC39S3RVWzw+xA1IkfUhD47KorVLmJj4HPxlArEMjYrKx4NLqFRfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZE3fL8Tjc3uuFUuiY/RlEC3CPi47hjpPkhV3PmuaHuo=;
 b=NSFxQJERrFuYsZjkYZan30XvsxfX+6kDSKIlK0BeZR/Wlxc0C9ZbY9jnMXvVy7UmU9kyxdfpTRv97UOuTQvcebxBOTZTE1sf+TyQYfx4I24VEQrq1MDYZhhX6A6NBbbSk5Blru7wLmWV6OPGScLAn/tFcgfArggNiINf1MnRLU9+HSCW3aTVPNMpz+mCeuORSE0uSvgxZmK6T5pz1jeXmZs2C6ObBKysfdEQEb0vAuAJqqr8kuVPiGUMoUERf4R169yzh734sZ2ezeXti6uWTO6u7lCQJu1heaMZBxcgIRR+Lx2aje/NyTkprJ1xV9uftIZPlkWhV1HG8pYpAa3LFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZE3fL8Tjc3uuFUuiY/RlEC3CPi47hjpPkhV3PmuaHuo=;
 b=kba8yYKixr+4J0dBa8WdDLMeZ0tGUUrTXqTx3bXFSp4LE8EyC0zNKdXPDw2AW5nniSIkUbTJplDMRsp+OvTpu7mp6RRsK+RwuB8739zc51JOTjDGJmnEf3j7IZpHFp0M2q/H74mkV+nn+5pTNG4xiQiJZ4aUw3vhVYwI+qBqgd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:31:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:31:04 +0000
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
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 net-next 07/10] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Fri,  9 Dec 2022 19:30:30 -0800
Message-Id: <20221210033033.662553-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a78bef-4a8d-4e61-26de-08dada5ef778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CI2780FRniQBGyIfhJ3ASnsvi1iXOk60jbO5V5v3uEft5zwiq5W04sQOMfbUcnAKVUyXotexREEW4iFHnQ+REAy0+ilNUOdIDDIAdQS5Cvn3uS/qYxNuSZ5xVhz0oawfjLN9l+JqYPWocBw6Yeyj8UuVujqyZBat7RekcSjYFlV5Qx0RZQyjRJ7LKuz0gpbJmNsiXBhHN7DE2H3TrOgpcvgAsjxYXj2FVzwkywChCLs4kMAabqXuKGn/DhHr8AHiX21q7SrX4/eLqAhZmpfLv+kxvMXFQd+PPT3Y36fnXxOUcJ5luhhxi+BoNYK9FJMdZJ+PVCfUVGi3wwVlm1zmpmdYQM9C52D/Cmczs/RQchOMRLAeidhox6XxFJXQArRchRwx6klg3JCoIkmndXQskTD2//37Pug6Dh4IENDyZcrGTnE1aWoE6gN1wcms2cnFuGz2DitJJ/fsT3C/5GjHfO8NV2pPMFomZlW/rvIJzzLyd+8WEFWspH9eQdgJwe8N0ZdYk/Gj7WPvFGpgot+aZ0SOlfRDpVFaJ1HVuZR8/ojYgTRZ8UwEi6rawyaNL+tpFeozOzmhbmZkY5d8E1bihyx8wwUZx8qrbyghtRAOSrlvTe3RMtZoZg5XL8UP3IM9tDqnoJh9CN7xFK9s3LJOBEpcc7WJ3eEw9EfKDBL0d6kKTuIpA0yJ2ZL4/SMK6pPw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(66574015)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE1rcDkyeCtBMnhuQ3dTSHYxdTR4dDdMeVdlZ0UvdFhRT2FybHE0TmRDMUU1?=
 =?utf-8?B?enViUHo0VTc0d2xkTGFmSnRheVZmVm1abnNqQmFGWWZscWlFd0pjZWt2a3li?=
 =?utf-8?B?VVVGNlQ2dUZ5V0dLMnJtV2wrcWR3c0RxTWRDM0JhaWg1cDhoSXFtQWF3Q3Rr?=
 =?utf-8?B?dms4ZkpvaGNueFMvK1p3VTlHUjJmbnE5dVZXYUFHTXFKZGV3a3A0YmJvdzd3?=
 =?utf-8?B?YXJ1ZEpMMElYRTRNNW9OVjFXZk5zYnFibHRoWE9EMUJoNUtCM3V2S1ZlL1Nq?=
 =?utf-8?B?YWtUMW1udlJpQytmdzdhSnhxWXNJYmdNUXFIWHVsd2JZNkNCMnFMOUZNa3Fq?=
 =?utf-8?B?aGpkUFh4T2VEdWNpYUI1U2szTWZCYTd6eGE4d0tlWEFoMXVkMGRQQkpWREV6?=
 =?utf-8?B?R2I2TVhiZVdaWHdpWmNtN1B0bHBzbEtWcjhRRmhRenk0SGV0UVgrNmpPaFg4?=
 =?utf-8?B?cngrblJWeVB0SXZuVEUvU2lqS3lza0hRdkdIRzloK21nMWxBWFJyZ1RRclRM?=
 =?utf-8?B?eC9UcW5pOHhXR1VWSUl4Wldtd3NRZUZtNHBxaENEUTczR0cwV09BbTlKRi9R?=
 =?utf-8?B?K0RmNzBrclUwVFhMTTBkeXlNUU9sSzBtYUNWMVJIMGcvTjN5c2d2dUFWb3E5?=
 =?utf-8?B?Yktxci9DTCthZC91cUx5aWZhNGtiV0UzZFlHZ1JJc0xmNWdzSHRBUmVJd1lG?=
 =?utf-8?B?aHoxVm13UFB3YWpBcFg0SnBoMGFXRWNudjRqNTlhRTdZeFNoN2R2OUcwSmdB?=
 =?utf-8?B?QW1EOFpIbkxGR3pyaFBBZllqeGdXczBxcWhFT2t6ZU9OUjJXWDFMdW9nQzV0?=
 =?utf-8?B?TVI5YXRNNldKOUljY1pYTVo1bmhvL01lY0d3RlFzSjNMZ2t2TVU0VmJ6VzhN?=
 =?utf-8?B?cEtwd0dlSEZKc1JiYTc3bTRSOFloQXB1cW1YdTF0RjFrcEtNZzlKQnlkL0do?=
 =?utf-8?B?ck4rRDhQZ29ucTFhb1NkcEdzQUJCQTZlNlB2QXNLcVhNVmk4Y1hmbjJXeDdu?=
 =?utf-8?B?SlpSQk9xdFRhT0VYU2hyZkp0VXJWbWRCM0w5UlJtSVYyNTY2eGZYeEIwRGlw?=
 =?utf-8?B?cFlldkdLUkhSdXgvOFNmTmFhTFM4QWZxUGVZYlJvR3Y4dkJ1c2tvMytCZnRm?=
 =?utf-8?B?K0dwWlFFWWp3TkEyUTlhMW1USVlkN3Z5V2RXcVAwSG5tL0RBQTl3UEl0SEFX?=
 =?utf-8?B?ZTNHTldHajZyeUxYdExvb2J4blBhbHZZVkFPVlNHNlI3bmltRHpKOFRDcDVP?=
 =?utf-8?B?SXg4azQrM0g4WXRpMlZKRGpZZ1ZTYzRNR2JvOFZWWnExKytOM3dXTnh3dUJL?=
 =?utf-8?B?Q3FDb2h4amFucVpFVXB4QXJXMUR4elR4NXE1TXhSa0xSVWxLOEpRTzg4RWQ4?=
 =?utf-8?B?cjAydFkwcXBDQ0VtaTBrandXQlp3ZTdaRUZZZjZHNEhXMG1BbTBpQkFXWHpL?=
 =?utf-8?B?YktEU09EZzM1VGNtSnA5bHMyQjBZdzZxQ2VLS1N0eE9HUTYxeHVTdU5aUlI3?=
 =?utf-8?B?dENLSjNaa01yYlludEJxV1hsZHU5MENTVjAvd2dvTm9VZmlCc2JpVW5ZQ3dY?=
 =?utf-8?B?WVU2ZHNMcHY1Nk45UU5ZdDJBSXpxaWVmMjg5MEVPSzdBZVM5V3RuMHdvcDQ2?=
 =?utf-8?B?bjVhaFZUOGtpOEFGSzQzcnRIUmwrN3BaUFZEUHlqc0pNWjdicW5ka3VKa2Zm?=
 =?utf-8?B?K1Y3Wk1zV3NqZUVYV0lRRk03YlpSWmZ2dHVXQmlnSVdrTHVteVZkZHRJcE9x?=
 =?utf-8?B?Z1JIcVZ3blZaWUVqWmE0NlplNEk2cFVOVU0zU2tvaWFtQVF0ZGxJSEk5Z3FS?=
 =?utf-8?B?N2cxSFZYZXdkQU5kZExKaktrd0pycnBHZGxZeS9OMVNQL3piU2xUOHY5R2dQ?=
 =?utf-8?B?RVN1dGxldGJ1dWJVbzRGUlp5SEtyNnYyUGRTbkZaS2trVkx3SjJ0TlZtT28x?=
 =?utf-8?B?ZHFQd3Q0V3JNeS9XTGhoNHZveHhZUlpQbFN5QWwzZWU4S3B2cXc2L2U2allq?=
 =?utf-8?B?YWxUN0IzRklzSDEzSTA1bGJMTDkzQjJzTklwbkhtQ2owcUJpVGNsS0NSQ2w0?=
 =?utf-8?B?QTVkeUFUQXJNMXZsNWF3aDEwVDlxQ24wZmJVVkhWd2tFTDZiMmFpaHN4VkVz?=
 =?utf-8?B?a0RZSTVhZWxhakl3VkkxR1YxdEx6WmxxdW1TcVc1c1lpY0d1cDJJcmc1bXVI?=
 =?utf-8?B?T1E9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a78bef-4a8d-4e61-26de-08dada5ef778
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:31:04.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yr/tGs/0aNe4lzG6PIky7FGt+W5gjlOfIEhAI9h0WLXTr0Q7nUnxVwKb7o/eXn9/drC+eCj21MTtAhc3D9BmPa5xNtNqsh2mBNnvvujqL1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
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

