Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94788648CD5
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLJDbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLJDbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:07 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5AE8C685;
        Fri,  9 Dec 2022 19:30:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDVnwCkmyeJ16fXo2BtWkSgch5iUPPSS7n9QSGMq2fokq8OqbAR3fO2hy4U5U+GI2VM3QowtRfRICy+1NLFqIrcafa9De7ib9XL+7qkUET8MA/ub+vTIVOS4Jl1Z/oE7xY+1JOJ4cUtaeIcMI5oSG7dZW9ydRTHmtdDM438lI9c7zTmhNnz2ZtwkB3GrL6JDxdTXwY3rQsyba3cEGTvlS5b1pdUsy/D+uPrmq/SMyhhvX8K3vEsyy2VUoYYDNtQSVGgWi698rBYJTUKBolyNH4ALHPHPH8qI2nD9G/Z8/ZeGCyFb4H28JEA+/k2fvRNRsLzRvitb2j5m5rhak53azg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTbaH0DsX36iDid8qD8cG/g7DcgpzwDTpXFm4J3I05w=;
 b=MVZlTuSS/5ry+LPz9TbEglkH6tSjTxL4oT2Nr++u3btG32iyCvWBqyTRntUcNA9EvmPKUFREPVVGPMNs0PCpnvOqxuJxnuS2LmemW6XmTcZVVgegGVvI2NsioXPCZVELvu5gX2CLBT24aPHbXwIOKbHYZKM/Y5bt6XE+71Y5GGm36fb0d04FcH2q8DP+WxVZHU1s7m2VoBmJMq16+5jcUeJvsU4Ihplu2juLSmfiVh05hedlT7xX/dGN3ysuqXS1fYhiuV9D+ad7asBnqsNGoQQAlQZrozoQd80Y8ElmxAUzWN+11McqLUteTcR7M4n8vBkKaYlzY4JWGUfTiUeNVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTbaH0DsX36iDid8qD8cG/g7DcgpzwDTpXFm4J3I05w=;
 b=FM+M1ERXpHJYb6zhu+ooAgTmtG7EINiWsH4B1S4oxiYd2exfikwcGYTMMmWCFrk5Uid3V0vB6M3X+HCIma5fQOniElrP02NHm9Ob1LF46NeHE42dr7xvLwIpCtqLFaEpXNTv1cjRltcIiTyM+NVqvBLUUlFzK6t2p/ID6aMyVgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:30:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:30:57 +0000
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
Subject: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
Date:   Fri,  9 Dec 2022 19:30:27 -0800
Message-Id: <20221210033033.662553-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: d2c65dba-f780-4f8b-3431-08dada5ef321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4U/Hw97c+ytos/lWRsVqLB2vqW4U2o5spDT29Q5VYmDWxQyXrY/QeFgX05tGlMHa2pu8w9X/BXyE+FoahtqE9icYmoTQgw9gviaDy8oiTw+V82+nZlf1TuwIIaw6ELWyX0KTmLTlD4+X8vVB0k965QjY59lvWJkfChdknltslHAhCeHcmxy/hEisgt89kN8GdZ/wqngvsfsa28sSjqXSaV+knJ62kidjnt992bxCv2pBc68RTlqKqIA7t174Xblh0NAwEpueuoRuUXVz49d9/WhI0et0cn2zf2pxpugKWFvfRy756z2pDU/6lpcccVRgMP/7v5MZYgeIsVSc+f7TllgSmxI4f68cmK0XPCPsgWlAftjKfolFyK6WDg1PauzMNI7CRrdAZN9+DKQn8+5E3Bk5gn/ThHyJDWdAhEpUoWVuxLZIWjiUNF7hgYK/yW8BNgQnH9VPRaoso3yezrmbZlMC8DGqoSTevGug0zs+t99xIS9q0JJ0hNcrYla5OKAbvUtpCAN+12CYWUotvUp5eECqotpySRhtAeLLQHcUhHrXv3BHwRP6MxaP4zY1RJcVw63EcnDyl9iVmH8WnvgoDlb6AJ0sNBR7+41E00LlGus3U7cPkVaryl2NspD7DWf55IdTr6+AevZZvW7VNkytmhcvBPwLjJWcXOOFn+JFsI7xb8XAGnY4qJXlCi0B4PNT3ijq2Qd+AJy9Vs2W96KwKHlH4UaGzVL80R9fJukGw8c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39830400003)(451199015)(6486002)(966005)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3dqSHRpZjhTa2ZmQVhyTlJTWGIxZkVZaGtvVTVVZ2pzb1RWOHFnOEJrcGVn?=
 =?utf-8?B?ODNLc0VwbjNXbzVMNW1PQ0ZXcWtQM3pDelcrR2UzdWNITFNjR2NucG1VSEVu?=
 =?utf-8?B?UmM0aDdkbm5pYmtveXp2Mi8zQzVCRHpEbE5PeEdSZkltSDlkaW5FR3haaGRv?=
 =?utf-8?B?ZUE2Q1p1VVFlZFJJZVUxUk95Q3B0REkxcHZ3TFVEaVlCVkdlbE9LOGg2bUxa?=
 =?utf-8?B?VUU4YmFMZ3JkU2lQdGRKRXdOb0NxN2dmRm04ejZTVkpjUWFraHJmUkhzMTBs?=
 =?utf-8?B?VnVZbzc4L2VkNG1pdUR5SlYxQWptbUNLMVp1azdlYU0xajU3RFYwWWRIQ24x?=
 =?utf-8?B?eTdyeG9PN2pQaUt5bzY2Z2ozR21ua2V1QjV6Q2RCaGNEc29FdnpHZHllbWtQ?=
 =?utf-8?B?UzQxclhZVDh0TzUyR3dncjlmd2VkazV5VTZQa0VtNUJQbkNQTVBucFBabks1?=
 =?utf-8?B?YWNuNXFZcDJ0akt1SjkrV0NOT0JlZWt0RzFnYXFJTWNVcXVXRkcxeVgrZ1Y0?=
 =?utf-8?B?Yi9waVdrYWtIQTl6LzhUdGYxOWFydzEvWjVSaTNCb3lpbWRPU0VCbVdCNXRz?=
 =?utf-8?B?cHpES3FBQjUwMFlhYVRjaWcweG9hWG9FSndIbC9ZT1NGTTc4MU81aEZtdFlN?=
 =?utf-8?B?T2w0TUpBcVRzYUZZS1VUY2tZdGNUWWVNeklpcGhwbEtweVNRMXdTc3JaOWg4?=
 =?utf-8?B?R0J1cU80VldaSzRYeFBlZGNSMjhJb2RabXlqeWw0MFJRaEI1dmQxTlozL0FU?=
 =?utf-8?B?V3pSRDlaS3ZXYjBuN3NMUGlJUkpsVUhubUkvNVlWS1VYYTl5QmtGenRDaGda?=
 =?utf-8?B?Y0dXWlFxditYNjBNS1E2SW1FMjd6OXltZTNvSGk4alRkbE1oaGQ4YWRNQVds?=
 =?utf-8?B?QWdMVFJhK1BXZUhSdFhnaTlWVmROWm0zNXRndVF3RjIzc3BrNHlhTis5bUpa?=
 =?utf-8?B?NXJocGsxTTZ1NXVvYWtNWTh2WGw1MnppYjBCSTdaNzVGdTdRVTVMTEUvWkFP?=
 =?utf-8?B?RDVwV3NHUWRsZ2I5cHRGamVVM0VvTHI4bVBXVzhNNnNqakM5U0ZVWjFhcXEw?=
 =?utf-8?B?NktSb05DTGlENzBUSVByMkltQnN3SnpHWTN0VzF3NnZtQWw5Mzh2STJOb2I2?=
 =?utf-8?B?bUIvWCtPMC84U1ZkUHFMQkRNZWJ0L3RKaDdmRGZaRVNERGZSY2hMMTFqTmRa?=
 =?utf-8?B?WkEzYW9oK24zcWdhSzhkZmt4UWZRajZwUGVaaFBSNHZlbzdJR3BuYk8rUnRS?=
 =?utf-8?B?L1NUTTBYa0xrZThRYVNMb1BUdWVpa1R1Q3lyWlV2Sk1adzRrUFJ5MVlGUCtN?=
 =?utf-8?B?c3FaT0syZG43V2NBRUJRS1I2WW0ydTl4ek9uOElPVE85cEgrRC94NGlURXJY?=
 =?utf-8?B?NnM5WU9IelNzVVM4UGx4bXdIS0plSUl5SXYwWnNOcDNWYVVDb1ZuaE1QSkdY?=
 =?utf-8?B?bHdhUnF3TlVvelEzL3JEWUR6OExOQUpWUHdmNk1lMzhhRE94VlZDZ09kamRr?=
 =?utf-8?B?cFo1dWNDejllZFhFUGdKSFNoYTMrN3BiMWF0OVJPYW9FNUpuZkdKUGJVTmdl?=
 =?utf-8?B?TDM4OHJTRlBuV3RNL3pjQXF4MklBUkJKcnk1WXNzU016TGZSMDlKeGxkZ3A5?=
 =?utf-8?B?aXZLU1FrQkNFdTFUL3FUN1FDSHhCeVhJcmJ0Vm5SZUJsTjBVR1dvNnM0a0ZL?=
 =?utf-8?B?REEzUHh4V2FHcUFEU1NUNEVCK0NtN2kzTW5ybGpnNmYyWXNDd1NmUHZUbUM5?=
 =?utf-8?B?eS9HTzE3SmVrSmZFdHk4WWZySDgwVTBhOVh3OHVScVZud1IvaEpydGVkenhJ?=
 =?utf-8?B?ZGhpZk9hK0hDSVRlRFJuODlZSkkrMVI1Tmw2Y0ViWmFBcTVsRUJpTWxXQStJ?=
 =?utf-8?B?UVFKRXczYmlLSXVmSllXRmRlWUdsWUI3b3FtdVhuUnp3UGN4bUN0L3A1ajFq?=
 =?utf-8?B?dm43NWxNcUFtQ2JoSVVxQnRSOEVRVkpzZ01XUlluR0xBNEQxa3lxbXlVYk5q?=
 =?utf-8?B?QjlTTEk1Y3JxYXBnR2hieHVBbG5Uejh3T3VTbE1NZ3NtVzZ5cmNtZXJrSFZ4?=
 =?utf-8?B?VmVTL3E3cWtaVFRlQTJNUGI3RTRUcGIzSFFBQXU4UjBDbmNJbVZFTDhITldw?=
 =?utf-8?B?alQwc0dOMjd1cVppb1k4SHJWUkFCa0hrQmZiYlUzRDRGNDFnUmJWLzRDbnZK?=
 =?utf-8?B?QWc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c65dba-f780-4f8b-3431-08dada5ef321
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:30:56.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyZlhB8hzN6IFfQaqyz8zYQxueILpbE1H8krTFovvPPYemSvlJ2qhdU/daiUV1vxK2Vb17UmTD+4DEW/TcL6vfgP6KEFb9BM5Us0F7/Ggp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA switches can fall into one of two categories: switches where all ports
follow standard '(ethernet-)?port' properties, and switches that have
additional properties for the ports.

The scenario where DSA ports are all standardized can be handled by
switches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.

The scenario where DSA ports require additional properties can reference
'$dsa.yaml#' directly. This will allow switches to reference these standard
definitions of the DSA switch, but add additional properties under the port
nodes.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v4 -> v5
  * Add Rob Reviewed, Arınç Acked
  * Defer the removal of "^(ethernet-)?switch(@.*)?$" in dsa.yaml until a
    later patch
  * Undo the move of ethernet switch ports description in mediatek,mt7530.yaml
  * Fix typos in commit message

v3 -> v4
  * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
    "base class" and fix commit message accordingly
  * Add the following to the common etherent-ports node:
      "additionalProperties: false"
      "#address-cells" property
      "#size-cells" property
  * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
  * Remove unnecessary newline
  * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
  * Add Reviewed and Acked tags

v3
  * New patch

---
 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      | 22 +++++++++++++++++++
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  5 +----
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 11 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 259a0c6547f3..5888e3a0169a 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - George McCollister <george.mccollister@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 1219b830b1a4..5bef4128d175 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -66,7 +66,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5efc0ee8edcb..9375cdcfbf96 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -58,4 +58,26 @@ oneOf:
 
 additionalProperties: true
 
+$defs:
+  ethernet-ports:
+    description: A DSA switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+        additionalProperties: false
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0
+
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: dsa-port.yaml#
+            unevaluatedProperties: false
+
 ...
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 73b774eadd0b..748ef9983ce2 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..20312f5d1944 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -157,9 +157,6 @@ patternProperties:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
 
         properties:
           reg:
@@ -238,7 +235,7 @@ $defs:
                       - sgmii
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       required:
         - mediatek,mcm
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 4da75b1f9533..a4b53434c85c 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Woojung Huh <Woojung.Huh@microchip.com>
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index 630bf0f8294b..4aee3bf4c2f4 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -10,7 +10,7 @@ maintainers:
   - UNGLinuxDriver@microchip.com
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..85014a590a35 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -78,7 +78,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..826e2db98974 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -13,7 +13,7 @@ description:
   depends on the SPI bus master driver.
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 1a7d45a8ad66..cfd69c2604ea 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Realtek switches for unmanaged switches
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 0a0d62b6c00e..833d2f68daa1 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -14,7 +14,7 @@ description: |
   handles 4 ports + 1 CPU management port.
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
-- 
2.25.1

