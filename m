Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C11640F4C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiLBUqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiLBUqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:20 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F88E174E;
        Fri,  2 Dec 2022 12:46:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2zTsdpp0VienMyDmLQmjqYJZpd39IGFWmfdBJdUmb6imTaBuCcQjAKXFywuxMdJvY8Vg2nGnReQGhJ8h7So3vbe5FXMUB7qNy+jFWzpTi5DnmLRI3O+zBLAbH18RvM8RI6BX7SlJyV+iqptITgn9Ztqv9lhkNQoWMbcHhi47XJeN0fYWkKSWE3q4BbvwdPqxe9iqpD1eeqpW5iZjJ4wHCSZb1txDsbBS0xilP1DeTNl8NrweOm+SDEnuydNgeBGUUlw2JCvF50F4IHMI7q4cLyzBwPMIXPegDo4+oC/Yb6+PjunhWvldZMnIATaOuTOCQhXOi9Kdpa+FhTNXZAXdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqowWdbwrOBX+gL8pv46Sj6JX66PJp7cdXQee/ebLmw=;
 b=lqByfXl75wNKuuQzTHVS55CsnByIALuFrOjwOadjcrjcngG40BsM1FlM22PzkAC/8vobPOtKY7eZ7LBFwy6peH3EAbv/AFeHCCgKcMY0JwobxsXBgum7LCN7XDg0zYMiYClO6z2uvUNDXBys8VkRazoauV/RtblOIYRmGa82Vzj+9XrCz2lt+jz1/prb6fr0UGOhfZBcBpd+ohZiVdwvU+r2D4gVbPqJInxsygB8CYrmWh/IH9Yyq7QjyO2YiBABW8odYyqMldavDJVNtq4Cg/re9a9aGRmAJY7CDF17FzOQ7T8Pk+6D0xaA7gyYS55G09kr4SAtx6L/GD/1e12syw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqowWdbwrOBX+gL8pv46Sj6JX66PJp7cdXQee/ebLmw=;
 b=dyrxCHYVYh3I5sT7ndT/QMM1Zhw53hrYL7NAO/HyYkVgN35vwYNkjJg1u9y7la7PALNfK0c+LMdrT7H9010aUrLBVqlwpL86k22F/QDo5+Pp8XrSRCoXVYViKcacuFwC/N6/6RFZ05S+QiRzlV5JKYkHIsT5Jy9/yfo4kqQqnPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL3PR10MB6258.namprd10.prod.outlook.com
 (2603:10b6:208:38d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:46:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:15 +0000
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
Subject: [PATCH v4 net-next 2/9] dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from switch node
Date:   Fri,  2 Dec 2022 12:45:52 -0800
Message-Id: <20221202204559.162619-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BL3PR10MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a05f89c-9101-4505-e71b-08dad4a640aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrGJkOnfC0vDie/RXJZXihtKyamLqcHoj7C47c87+m8BYElrhAN5jNtd65hwnLyHZusedtPnPbR0xu38+eSbgKsjYlB62hMPnSVR6onSBKZJdrrI9cyKl6n5jwIpWIbR5ENuZ9F5VAZXilCu1k/M6qU9zrdRITxhUZ57TmOAR/DYRpQntyLJmKINGs29S0urR1dwIGqyBYYGS4LHhmfJHW7X6Y9Hovo0d2a3KR31tFatvo/iCP7WWQIIZb0/1y5mgZh0H1msaHzll32p1Pb8eo1foQLmpIvwCuWYBWdi08ql0HI6NkrXApVxFMx8PpGcWWKu3rByM89uNKfiGF3Aj5ngKxzbOTBXLL2a5SCRr9M7lrPFLAMtsfqVhg/Za2SCd15oVunfiO9fTRIVhSPOWdpZ9sZL5UzjwZoYOuaZ81ssngJdVMb145UHL2g68dmE3BCo3TLpRgEbi9UEEYFKE+AAlqhLOF3h3/kukImLXskBHUh7whF08s3fF+JQcAupEVLY2CDma75VNzE1A5Rr9cof/76YbCSwrjU4IS/RCJVHLTqxVCBwz1spJmD0REYIx2kV9IjhJfnxAHT76L9rfAd1z0VY4tFgwOdxyuRVOSD9usZVlmSQcH0Ww1KwX5PmK8UxWqrUHjDDh/zWGVuORGsaQKr/uSOj34GEG4CyJUeh6oXNca4U40fcv8j3SQIXvQMkq//BK6njlHZog7T7rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199015)(36756003)(86362001)(6512007)(54906003)(6486002)(6506007)(52116002)(44832011)(478600001)(7416002)(5660300002)(41300700001)(6666004)(7406005)(66556008)(316002)(4326008)(2906002)(8676002)(66946007)(66476007)(8936002)(38100700002)(38350700002)(1076003)(26005)(186003)(2616005)(83380400001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgeH1Y3qMhsF9BdRjczL/xzkklQczvKsPL37GN7lSRQWLT2Nruwi8k92N8fT?=
 =?us-ascii?Q?ibNtAIN1B9O4MPINsojGhLq7baVO++4u1SwAol+cxQ4kvDyk5U+M0yHjeNV/?=
 =?us-ascii?Q?xQY+cmTJDAB295bc8ffpT3MvgTKwcjAZAmiLhUUPZdsf7foRn93fnZ+26PXd?=
 =?us-ascii?Q?HgldgTEz5wQdWB+U2BuY3J2WZdEox5Airo+OKbbU9JyX++MVWaqyfSg8Uro5?=
 =?us-ascii?Q?QXIQ2RolFE/M0mV/vOiIsmC3IoDGHx7FylPHJiIeT6oNycI3B2cJbDf1klaV?=
 =?us-ascii?Q?tvyjVd8v8IZ4Knr5GHAcWi/Nj5FkWh5GhmMQO90Hnz0aUheCVMNaIu+96jKz?=
 =?us-ascii?Q?9kbHoKu5+1kZqwvLbv/OlBX02e6mvm2tGnZmWyKWjz5rqzYUufvrX3XJyih2?=
 =?us-ascii?Q?uLoW8eemCIeS7R7r7K75k+CVDziw5KoC8tKC/E8t1zIW7tjVOkabiAY1/uYj?=
 =?us-ascii?Q?N3Y9EQs97MB/Aq4PaMbURFGhziC2JIiQq9QDC+Z+9uqdtLUjSIsoBvUm01Ju?=
 =?us-ascii?Q?KBKqFC7LHpOLOeT22IfVCMQrI8nQwfXkm5VBUCVArhLpAOWdi96VHEhe26JK?=
 =?us-ascii?Q?NvpRjVBdG5tsizS2fcSCJ7blC4ls248XoXTW466Nkkaue4bXB/+6iwS/6F/4?=
 =?us-ascii?Q?IHPaq8LcRmhQCNt/kfQAn4VQpntxRdWjCJlAZqE0D/dHVzQdW6zijXZBZGN1?=
 =?us-ascii?Q?qvw/Es1gygbYCyDmQD4Q0loxeoTNznY8QmtaShYXZhGvENBFBup5ntIi6gaJ?=
 =?us-ascii?Q?VXQEg9Y4v3EvKFnPT+YX8n9ld8aUBshwXGTtMOLLjsd/LrOSv30uKC/Z7YIj?=
 =?us-ascii?Q?7VvcHYPV/WwQzbWNdTL0KXL8S0fc3keyWJZ8Pw+RYTQP2geURFMP4cv/ZFgB?=
 =?us-ascii?Q?tT80DBZMNp6/KIwMbjv4LgdyjI+UGUzGJXCjHpZC5+8EydSKJe3hJyhgQNz0?=
 =?us-ascii?Q?PEG3Tkzw7HXn5Q2mVAt7KH5NW/BOloEgznv9xwoZxVusdHnboketopAfRMto?=
 =?us-ascii?Q?UQxgFu3WHQ/MPqVkAq9zHQu+MorLHQ6xTO7JkxoTmiFecKzIDpIV41ZeFpAY?=
 =?us-ascii?Q?3tL0tSVWEW6Uhjw8rZK08VhzBmc/k4Iu4kt7Jz4Yt+u+cbjDDiZ/sGM07wxM?=
 =?us-ascii?Q?Z49+pc+MVtM43uINJWPnLRHEKga7E0zz0pSIr4RnLdterXA3hYvadQQn28LE?=
 =?us-ascii?Q?Jg9qMweQHeP+ZoO1vWjfd/IAT3QdJy86JleFpzdMIO4jTeMq620b6vt6UO3t?=
 =?us-ascii?Q?j3ZnkptlFNaOGJpv1f68bpPAjuqQXzliMIYSWgC5Abe4MoH9W4vFA64utc55?=
 =?us-ascii?Q?VMwDyjJTfDnJL9scHPyxlepBAbBhNbULF6cjL2G4iz4caqA7Xtr0kFBpNREV?=
 =?us-ascii?Q?vQFj8QDF5zYiRsJaJAMOTaQZxcdcdm1mkL8Op2l4Ni3TQvsSuYr0c6Bd8s9+?=
 =?us-ascii?Q?B/0KMEEaiBeZsL5Xsp+hsHgtd42Srgs0RLCCw8ELWeEARarr6A3EvcAtUaxy?=
 =?us-ascii?Q?pQxeFmdJeXsXR4iaykMfPVO+SJM7v3DrwRdu66kaOOL/N7RkxEudKv4bim+y?=
 =?us-ascii?Q?3VIVPDQYFfotfwdpLFR9KGuKUAAfyxfIGrUJjE4t2PYIlSYQ9cCYI+GqOpIk?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a05f89c-9101-4505-e71b-08dad4a640aa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:14.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7ozENhH506lFku4DXYGfm1/kDv62IA6f6Y5nX3XzGVUBZUhQLgzMNHbiQwulgA3ZAlHrsanDIjtdY0ugSP2nglMFIaEzXPXeB0GQE6IAC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6258
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

