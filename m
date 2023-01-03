Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5065BA3F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbjACFPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236745AbjACFO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA053B869;
        Mon,  2 Jan 2023 21:14:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1kCFA44z+6NPVPMjdm3f7o0D8NAHJLwbp5lgRvL1RBw3mY80CpkRC9+CSgx1bbKpqsxn4glQL47rMkMxGuc0FEBiqKqMsuabelM91IiYlrnfQ+AV1r5fC2zil84rPpVFA8UCiGPoH0PuDh3EFfGcLM6Tj6ulcqFd/jnQ0/gIUUBn/mIZ4PeecL/4aDBXhoaUJvI8mK5OD/lApeOA2Q5NUEcuOUhDyL4y03xgmSM/ckT0FNRSYaX+xug27ZMMPYhshqrhfPZXObNs3Umgpx1MYSrHUZQh0qlTTxKOFVtnMCxG/WzKjCU6d1Oi8LZpi90lQktb2EMrSiAGc2rCmZGlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMYv2XkRaYdt1gOb1GmhZsmGjMGM4WRVrU9cU6JbUf8=;
 b=iIwKgk3NuW+5QnI3IYaA76KxXWuxhEAqZ4VpIHog5VkheB0LJq3LldV2FLFZQh2/ZaSj+N9lZbvGsFXOlGRcT1hItl7SKbOhPQX5WhDLuYxwWv8zihqXHlvJUWKB68jzbQYBRcSHORkCnPQOOHKaZC7cO+FIBTXSTB3cwwPBCgz13EaFU8g+Le7a6HQq9SnapRrdJzwhEL458gclvKAUPh+L2v5fDmIgHzQhLRy6iZ58W1MRRJW4QOQg+vJ04ASPZnDMlWA/VZfLXDG7LzTcBAeoVjCVmL+9qiA5OIFDlnM3/Fz4CFvIT3fRYHbvaefxUUkOPuJIQDVgKk8FjNSl+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMYv2XkRaYdt1gOb1GmhZsmGjMGM4WRVrU9cU6JbUf8=;
 b=sywMcczDxkOhl/xOG6LUPvVSpanF1F8bijYq/6E/lOO4suH0PCsMsSbSz+XwO7k5xm4cwfdPaMCXVHU0HBKkbn2hyVGYGW3U41iiZmM7IsLeVpWNMcdGAMOK4fHhLOXlHUGIrZFDG5Y2xA/v1rLIF9CreuvmDBXhJflISSBHgqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:23 +0000
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
Subject: [PATCH v6 net-next 04/10] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
Date:   Mon,  2 Jan 2023 21:13:55 -0800
Message-Id: <20230103051401.2265961-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7a8987-bf67-4562-99d7-08daed49603a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHeJh2XnS+GZEV4paiGuD5efa65sYmtIKvMJpx07QJm3YZQAav0rGhFKQzl+Rib21hZ8nEWX7xxL/u7IfRExouib/Ks6upfCqEG5Vr1O8+fFVqzdrLnPH/2gYgSKUO9hn3XEyXv0/tsMQYZPSgKDpyIjybbzUS6HRPTWb/wVbRjBtTQDIJ4YCxG0r/NuCGF7LW74e7Y1TrrTKY4KO/zcnDf8+APOY6FZuSG0OW3re5QJQx7yBhFf6tF2yZ1sVq8HF7KaPloKrRfRJDfgQR/y1qcUNnYBBQo2P8FS58aW3MGbyHs54f/+Z6QMjHHtYzvgWb/y4EiCW+47FP8PKpy0uB0+vEVEQNAgdoAsuLjMf8xGhImJcpgxZLg/YtaeXIU1ZWV6EZc6MBIDasZ6fxw7n4R6U2eP1RubVFM0K79vbH+VMiElQ0QjpsGC82uE1mJKdv5Z9tUsLJ8UXfB/Xn2F0dH+YbwAMdcJLM7i8eA7USt+nIJwLj3vpe7vtJsd3unUfNiHdDEpwaox84uJ6zORvKCJwPJdJUOogMDr7YK6idZL2XCF/wG9bmdDBPqBBCWjdoivbO+roBsdXKZCnOLUq2LlZ1oXzt2G5491Lm+RZP/+vs0t7fRFe5F/ELtUaHQXIzrR/WgUCV3lRAktz2YDDZJrFpheXi8pySPF2Z8O3ZoPW2SbKfl97eqf8fzsIBWOhqHFvibm3ayYGrpr8FhVBdkVDSulnx/XjFVvFlPsC7qPwG0NafxUOwgZHfVJlsuo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(966005)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnZQWXFqbjJqQzU3Q2xHY01TUFd0Uy9ZelhFRE9FRnlzMWNENXNRMzJFSWpa?=
 =?utf-8?B?TFk4WG9GQzZNZ3Y2Nmk0TXBkaDVMYU1ZTFpmRVZteHlIZDdhT1dncnIxNWgw?=
 =?utf-8?B?YlBaYUtySy93bTBmb3VsU294aStqamw1NUw2Zno4dnhiWjFYYStzNFlGQi9D?=
 =?utf-8?B?eWNMSWowMHRJaUdKRlhTdzhzbUFWbktQeEJEMWtmSWpRN0dxb1BkNWFLTG5K?=
 =?utf-8?B?b0hSVktCOGQ3TGhHMzZaTkJwYVBVazhxd3doRjdvbm4rQnhua1BkUXBjaE1N?=
 =?utf-8?B?ZGdCeGR5Yzk5WTRMQytGb3RTaU9CY0thdHllUzI0RmxqTGRZeXdNeWR6WVN3?=
 =?utf-8?B?ampRWVcyazYyWUpVY0Jtemttb2lDY0tvUm9jTzBOYU5vUWl2TnREdjBjVzVl?=
 =?utf-8?B?OU5HRFVZTHpVY1ErK2RXWWJ5cEhtN2RCNEQxYlFXYlY3VXpKS0VCWllXZWlT?=
 =?utf-8?B?SUpMajBoR25EUUUzdWZrUDdXLzRQeWlGQWg4Mm81ZFZobkxwNUt0QjREK2dY?=
 =?utf-8?B?dEplUDVWQzMvV3FyM3RIckkvRVM1S0kwS0UxYld3QUpaWHc4dHRkTnIyVjVu?=
 =?utf-8?B?dGpBQm5hSTZjZVBlQXgvbW5FT3V4bzVTS21oSjBucmx4YVFIZmtyQkRJZ1Rk?=
 =?utf-8?B?M1NjV3BOUVdIcXFXV05xNnk2YjlTbEpmaWd0NldGMFZZK1ViWFI0NDJCNldX?=
 =?utf-8?B?VmdwdWZxTjE5RzBXZC94R2tkVDVDcitqem81T1RSU1lVQ2xycElIa0oxeVNG?=
 =?utf-8?B?VW1zeGxHU3Nxem1lY2pQVnovdXVnOG9WeG80dDVrd3NBeitKVFhRUlA1czIz?=
 =?utf-8?B?eURGVWcyYWV0YU80WFROUXg2YjRsVENOa1ZySWVHUnhPSE1KK2hTYVRCT1Rk?=
 =?utf-8?B?VmhJdUxsbDdkRGJaTm9kbVpPbHh3YnZXVzlqeThCeTE5RktTdUdseDZqTjJT?=
 =?utf-8?B?bGhPaUY0RzlXeHNCUDkvR1BFRytaZk5XSW1Pbnk4Q3cva3ZUZGJjV3hQREc0?=
 =?utf-8?B?ckhzSjJUMTBTaVZlcTA5YzQweC8waFJQVXlXRDN6T0JiUDFrSUxXdUZKNHYy?=
 =?utf-8?B?dkVIR0JpQTMvTTRpd0JrZGFuQ2Y2UWVMbEZ1TUY4SGRhQ21Tc3B5Yy8rcjd4?=
 =?utf-8?B?NWF6UEw0TVFpZVdURWhlbk1ULzIvM0k1dEcvaUd5WWxXQ3Q2b0FIRW1uZkQx?=
 =?utf-8?B?MEpJaUM2RmlvSmFoYjlYWC9qZjMvNEM1WWhpYTBEVXlTdUNidXRJUFFxMGFh?=
 =?utf-8?B?NlgzaXMzYlhHZkNOemV3UmEwYlBKUytOTjZlWWlYNFhtUG10elNESEg0TGJH?=
 =?utf-8?B?ZGQwQ0VBdlBWRHBrT3ZXM2FJSjZMRG5PQUVYTlRnNENSalMyVWFvbjdFY2di?=
 =?utf-8?B?Z0dndllGMzE2NFhnbjkva09vSDFNQy9IWHhnbUZKNTkwcUx2dnlyNGJ3NmpL?=
 =?utf-8?B?WnFGb1A1NUJlUnR2WXFsSWIzdUxBUFVMVEpVYVN0aVFMWllUQzlKdnVCS0dZ?=
 =?utf-8?B?aWlpSm1kVzYwc3FIVWlnMWV2ODM1alU1dGt2N2gyRjBZTTFweG5kU2Y4ZTRs?=
 =?utf-8?B?UVlNS05ZMDJGbGpDdElmZkxhbGQ4dlFxQVpKQlhlUUo3S2dETzcvZnJydlhJ?=
 =?utf-8?B?UTByeXMvLzUxRldmV1JGT0tFaVRTYUJ2MVVLZjJHZm5OWHhkMWZYL0VUakw1?=
 =?utf-8?B?MEJwOWlNWlpPOENkYkl0bktLbFJxU3crYmJUVzAvUGM5WjNJUG1CdzFDbStu?=
 =?utf-8?B?Z2hXK0NtdmxZZ0loaVJCeFdHcWlLUFNTUzBMMVZFVVpIY29vR1hkMWgzaWRX?=
 =?utf-8?B?NGFONzcxNnFBbytsek9QUUw2WXpXOHl2dW11STRLSmRDYm4yaWc0c2psdlhk?=
 =?utf-8?B?eG1wK0NyRzdKZEp6bk5RUEpIM0FGdHpXN3NiVWtXOUovcng5OWxUd0dEOHFT?=
 =?utf-8?B?bE53UkRrZldLTWxLYTZ3L3J2K3YzZURSMnFDeDVoK2ltaVRzWmdNVkcxWitW?=
 =?utf-8?B?b1l0YWttOTgzUkc2V05aa25POHgxZnhnUUQxUXdyVUVXN3hndU43ckV5ZEQy?=
 =?utf-8?B?RXdHOFZkRTNURUFhQzdkUGNIdXI0emJSb1ExaHlLaGFaQWhTMGFta1B2OHdN?=
 =?utf-8?B?TUh0T3BncHdndEs4UGprdDJUUlFSQ093cTFRMjVma1JyQmUyTU9WY2ZuREdq?=
 =?utf-8?Q?9bACTW4/7CIWBz1Y7xMWj88=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7a8987-bf67-4562-99d7-08daed49603a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:23.1226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DJmpt/7wWeFxGJGhXH1Obpa5vBF9mNSvLhEtopiAlM9KnKwfCT0xdWv2kc5hv72XGyjVjzmQWU9lxmwwXpjAf5M1+ZR6HnX2I2+hUF1dBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
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

v5 -> v6
  * No change

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
index 2a6d126606ca..9565a7402146 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch
 
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
index e189fcc83fc4..efaa94cb89ae 100644
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
index 447589b01e8e..4021b054f684 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch
 
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
index b34de303966b..8d7e878b84dc 100644
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
index 347a0e1b3d3f..fe02d05196e4 100644
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
index df98a16e4e75..9a64ed658745 100644
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

