Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218D465BA39
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjACFO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbjACFOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F806153;
        Mon,  2 Jan 2023 21:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+7T8Wip6t3W+jtm1MiL1qm6OU9lqZKWaGjN/hu1ec8wQCxNo3kO5uLEQ5/jvx737C0felv92IxXEDItsF8FXgcQuzbjc1ZmypPtpJScRuZaiYobAmUzkcGW+7v0Xkr/GvMpy/z1fVoGwtFJGrhj+j2IAYJvENjUSOk9ulhdTJuIDFLSqirXisakO/hIOoVAbhIgyv4Tz3yKbHmQtxLtwCB3Ro1G4JYXpNLCx5JKnYs6MAA+5wB6VVRazBV8jumNgCX1RKF4xnIqUkx/JhKOiHkwHMbR8QA0F7g20q4Uz1yMox8WjxoHvasp0RGn28tskPItwPHcHZGsUSIoxi0wrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJ8K2tvAGhzzLbzLoqRjcnqtFg/nHVWLfcuYKJsRClE=;
 b=duc8gKeYaLZL0XihORMHmQ6PoTW7lM9fS9Zad8Q7OIpCQGAmgEc+trBtkPogaf8fJnfjhuCDrHG9IzAruLS17l5ItBaMboQh9A8Gcose/EGSCQ0ZTjvJkYntPvyo83C2KolaHR+qnuPZNvDnXcrXB95zfEVXXT94/vPsdd8WFVqBXgTKna1BlsZuyoft/h55HX2uF4LIdFDvixXt+NEf1etZkKd+AblPItMW+6qFCoODVAHASmjzVM0f1FrnsMwWGluDam6KeQpEtuD/Bd7EavE7fdD2csnUWn93YGxe1UxYojRY8Jcy8jxB7kAILrgf+1m005IGvZzx1WNkLPhXNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJ8K2tvAGhzzLbzLoqRjcnqtFg/nHVWLfcuYKJsRClE=;
 b=bkMJAkU9Ddd4UTWYM24w9P8QlnjYG9I9ZHIxhVmF6b6r8a4N3J3u/r4PvDQeQnajNHvbu1yS/YzFKE91icSixb2xxK9byUMoXOTLy5/2gm26tMzVIelMGYHgPicryfAdXCEXaJa5BprChYZhEC7CEc2SqCOCeranaXcVdXjSVjw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:21 +0000
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
Subject: [PATCH v6 net-next 03/10] dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from switch node
Date:   Mon,  2 Jan 2023 21:13:54 -0800
Message-Id: <20230103051401.2265961-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ffd4ed-4132-4008-d67a-08daed495eec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Np0YGuFWS+ODRzmFfql7WYBwilOfyE1HfHHO5UmIoeO047yfyss9PD4yCqM6FVkYB7ErL9N+EAeWUDXcWZkPCH7YofP5AoW5+A+cZWrqgnr/gDLvNYI1LXY7f2IJ+dSx8x3tKBu7C52UneQzP0LVUkYCWni67A/l6dcsVkVTJrXdiwJiI+TH9zyDz7EFvf20wujxcwGU/LnMafEfLXNOrfNvhK3qxLDvGXcHqw4QMNNN771O6aX1qjgz4bTjXornJsyNantoDGot3H20f27ZT8FnwWNhjq0U1tYkLaJOUFzcplYAr0RHReskjIlYquI7P31L8NRvv5Sgc4bT7iiWweb//nVCGCWDjFRtMF73td5BQcapglNkdEK8RUYI7AOAfVTFbYSDNuBHowUuP2kRgvOzc81Yf2SYqJxHp4klIOr0vwR66GwDBVp7R6/brZkDq34aV4yV9akyqNkfU66uJNCizQtDTpPmzUWMIlpD/o8Gb5fayay5yksV1rXFV72l8LDzA7pqTLwNBQQPAKf/Yv2/Lp/5Clq0IB3sckyHVjdYtFCc93/BiCf2vxep77hcHq0e17V4NbwQibdhZV8w4sudyDFErqChvqrGHpP+OVagSTH+CVgELAVRl1MzGSdngYpom300J8G40O1DbtgI1wBf3QA5ovHJAf8AdZPjFqQ/vM1EYO/hDt6NjyIVZrTLKhAN9e6zioqZCxMR+odADZ0tsjE37Cy4foRbX40FLhrdgzm6PzssVa9dZ8JNxt5C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MElAR/ZUgxMR9JPaqYa+rFLzTOF51l4an/1e1wodDvu3KsSPzZufpxWrx7zg?=
 =?us-ascii?Q?MwAjK0bLCXMy+vM+vmKO801Vx+vh5kTS8XggVkwme4i6Xb35Kb40ILTXAoxO?=
 =?us-ascii?Q?Zi62Qiy1rI5X89VWNMqGBR/zRMpywP2gfwqrcLoyJ9TjO0SmYnnQhptkqW82?=
 =?us-ascii?Q?qRRDVR2yzFZHP6mEHd5Fhvj3YNpaPuBLe69bgx93nqemcFh3ilJlPIesZ3UY?=
 =?us-ascii?Q?5IYLmX7cxO8uzGPaKkwJpuAybirx2ys0hbofuAv8Re8hX7QxcUZwI/+hX4zZ?=
 =?us-ascii?Q?qOrry6DiR4Twt2TcPVdrkvr39ljwXW2O6+WOs7Z3AF3O9NiIk+zrzHw2ZEgn?=
 =?us-ascii?Q?qHXaHKf7bJdIcpPg/9ES5sHDSMEaTKIqhRworXLlzt7W24mvkgqpWjmhB/Fn?=
 =?us-ascii?Q?y+6oJ0XhKi8Ra4X4VRBaKK4lTNwni8NUb6uONE4iBwsHH1h1ipvgtYBVK63Y?=
 =?us-ascii?Q?WpxtyyHV/Xigcmpp3ogNhaMpwDOEeE/W2j4j2mvKc9ulWkv3dQrfr/D7a5Ne?=
 =?us-ascii?Q?7KZDAEqmib4y9wocCoweiADTE4co3yBuHhU8ECg7HmbQzDkGR7ZRAP2Hv/FK?=
 =?us-ascii?Q?qfUf6MyKF6N5shANFh9gsWDQqCq30UeomF3e+sWL11IbMlEZwbuJ3Xe0X3BG?=
 =?us-ascii?Q?7Q7nUETkIFpJA568GL+vjAYtg8DYJO/uD+Q1xtEldVBKn09fSim0rYeQl4oh?=
 =?us-ascii?Q?fICuOQNAadKHmNsXHiwvtz82pSsuHV4uHpoiWHG0vvkz1j+qZzQDUKUqIw/0?=
 =?us-ascii?Q?9hHOqddfxSzWgfFL9rpd9vfK9ROheXPSivN83v9AZazlZc1RHzgYnMPnTsIs?=
 =?us-ascii?Q?2GErdByyACWsoaEhxlaksHQ1JoSbTzmDfztIjLGYBuA5HuDqrMHMNZ5AYTZg?=
 =?us-ascii?Q?8KbeCt860q9Y1CapMHkFbDDNXRSD60UGAe3wBkefwGYb1ku14AbNks0wXMhK?=
 =?us-ascii?Q?3RerPsce3PgPy2pjUzk83ZYB6fG3rg8uzRS2wddHlg+RCJVa+zud3jftCpZc?=
 =?us-ascii?Q?OnxXCEjcEYFK7/m4aw037nZEtHM1eGNeM3bcpRzdUOxHw4N4/TcpFmxNnqOx?=
 =?us-ascii?Q?2V34sFMlRQ2cxI7igiVOQ+rdY9boYLGqCZFo/IMwhx31IQ4tLDc1aUKT8WMi?=
 =?us-ascii?Q?6D/kXS9nfrbCcejCI+fEDnQ/ScQiYiMXpiQ1Xc/Elnso78+fzB0WogsCYXwG?=
 =?us-ascii?Q?Tmq1yq6aPqIflguNN7JBekq2uuBc6yaiTF0rA1ddWqLSeGmIq6JplGc3sCBn?=
 =?us-ascii?Q?la2gPmtcfm2xiFRN3Ak+xAHMGQUihH2OAq6qgOZBEBgv+LDDZnns5MrQo9OV?=
 =?us-ascii?Q?qHZXjbDIagFHtsAxzNfq58KIg+Knb1/8igeW3zupg7sVrInQFZh+t/LBSYkn?=
 =?us-ascii?Q?nZYlQ3vEITTA01NC4107D5nzwuauek5A0qD+l9hXmryjXADjHy9rewA3ul/R?=
 =?us-ascii?Q?ukoJNmpmxie0D3W89O+iLsI/Biurm02ElPOOcHSaH5TxhMcFqCY6nycVuELO?=
 =?us-ascii?Q?hOq2uyclKFnuHVVu7PF3zTjoM3Gk1rZ+ncUeTazWL9VceKCzOUzv8pB7T1gb?=
 =?us-ascii?Q?2ZRMfMTdfRqlPn/I0isvclvNr4fr9j1InCNUNjJpjSfiiWFTJCfc3+85/bKH?=
 =?us-ascii?Q?2dQShB3VuNaPmJz90g7u1RI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ffd4ed-4132-4008-d67a-08daed495eec
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:20.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEaq8+vN0wnGQ7e6cUsuUNKUmtU7lcFgkUJge52c7F3tHllF4gEYvBCRZOV0T4OnhEHWKZNaXdgdGI3m468Hikdcd0Se2zaB+BJ6hOKwRS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The children of the switch node don't have a unit address, and therefore
should not need the #address-cells or #size-cells entries. Fix the example
schemas accordingly.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v4 -> v6
  * No change

v3 -> v4
  * Add Reviewed tags

v3
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 978162df51f7..6fc9bc985726 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -148,8 +148,6 @@ examples:
 
         switch@10 {
             compatible = "qca,qca8337";
-            #address-cells = <1>;
-            #size-cells = <0>;
             reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
             reg = <0x10>;
 
@@ -209,8 +207,6 @@ examples:
 
         switch@10 {
             compatible = "qca,qca8337";
-            #address-cells = <1>;
-            #size-cells = <0>;
             reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
             reg = <0x10>;
 
-- 
2.25.1

