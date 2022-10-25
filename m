Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483AD60C2F9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJYFEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJYFEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415C9E2CE;
        Mon, 24 Oct 2022 22:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eALrMuN8FQxocoPcS3IRdRuu589MQ6bWC2OOpSDqN3ZKUtGC05F+mUNCEPRjbk9NyJSNKenCouTkBF/+X9XGtY922PRGZh0BeCB20+W08MFe3W65OTa298ZFPXsqL1o8bdlpRCSfzuxnQyq/gsIeBI2S2c7RMP5CxTlEhZY1NnKNhT+2kQGma8moTY/xBLvaT0IXDBW9TXFTsWG0Cg6fRiT4WCgLV/lALkg8FtbAU0yeDrWEk4Wn3nfKflTHAHDLXyotUxoCLTUlRxMGQE37OxZu3p76iwJsFqhLvSS5lwkQQiEBPkFxN5zPUduaApaZs4h6fOi0YrHdAxK+Y055hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwFrQdS+VqeasXNLT6D1PeP+XDlq1nWmUOrWZQdRMAA=;
 b=YhTWJJn/AkGT+5mbqXtoXW7yeGUVSnVxnmcrAfw68W1f5cy2YlEMIyaKEOYqO11gswnaJ5hiQhilxMq01GzXXzQ3Ho0s8uHe0few1fx9Oawf+rjjBgrH1xuxcZ6b2zJ2FyBrskCxqqrTRZfcHII9EYcnF2jpe4eFd0QjnWy7HguQm0LHeMW74Lx4fatA7BTylXNhQowzug7+75fuCxwy6FpcanpJBobTj5yrvSx7p123PFMPiWZXAOKMdcSwanvi0klABoSuFkejVD7RZk3hH8EFHhxdMVLHmFPMFoUY2bgd8brA698cAOxjZi0qTg1Zp8RuARv6zf3K/pmU6DEcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwFrQdS+VqeasXNLT6D1PeP+XDlq1nWmUOrWZQdRMAA=;
 b=N+UocC6yZrPU1JfUWef3hWbC8DaX1hiHu28JvJ+lu3L26OU6SkbzDynz+n9yealdh43d5qN5+VZkWe1iNleuQDED8KwBDO760rZpbCEe2qscy2vLlf/iuUQNK9iJQ7nM3q5vvkZsSX9pwhjnwEVNTpMn4RQsgpfueTLOuKnXCeo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v1 net-next 0/7] dt-binding preparation for ocelot switches
Date:   Mon, 24 Oct 2022 22:03:48 -0700
Message-Id: <20221025050355.3979380-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f44eff0-33ed-4df3-a496-08dab646586b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AvFgFgtNep1LKy21acilTvJyPqb18dGtGEr0rbEhbNcrCe7HqVZ0xMgPLJlAMIyK8kdrOkDzR3b38oXVcLEMh2L6GCEjHKLzxzsMmMGouX05TkJLgM1zEiDJy96cXFfPcp6i7U6jGJjz1QHuNjUEvd7ZFlmenRNW1cz/aYgWcPG0cc1SV4CHZIFweXP1NJ++wp6b8dfUDRkF++H6J9twSMrVcWffE7XHN7uDcc1w4Cdth3MqiStvZqK+r/eoA+6G2HuSe+eycpqaboeyiFc/MQp6q8TUj609kqw3Oe4KQHeu+1F5+i+JOR8rtT010Y6s8HDccBYTbIROxH6W1im8I2kD9KOeQ2Khb7eK3Rn9RFySut4W+VoLQEZZQBzWF5h49TdXT83dHNApLzLUAHyRErmfSOHvybFD1W/lc4pJFlrzJ3smwhge8iQ5C4CHoftstOrSq1LtTJRTxj/4085RmSAsNh0lc6zJsvuzCU3Pd6EhvdEKN9oY8XriFZbzvPj7q/iZHEX/btsH848aCl7xjON9rFWZuJw5cvW6LsnF6FvGOsH7y/eHT/f4GuBNpeOIEDhj4GJ3jPcMNC5H7MRNW+BJU6UjS/WYZjJ2YW2RwBSSq5TwTOGtJ8RUllByQfztCFeHMES8ApLcang8ESs/4mywe/53vb5Nnlg9/X4aAHmsmXpPJHVwlqKmVpV1WJpBCur+l+Mu33fx9KrJnyz4kGP5lkyG2WJHSdAme5Xi8a6tHnCK1ifEc/FXaZVWlAZTHzcaIIrIVJlKYR4UeZspziwWrs3JUWggFzcV67mAarg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(966005)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLFELZhFicgQkmcrRd77c9FOVAH70o0Il/wUnlwxJbClfOLgJWD8csc4j1Do?=
 =?us-ascii?Q?um1OMqbsZai2Z75jCvxYvDAcWfFkOJ+xI1kLGdgEp9NCnjFm0FDHbpJOgV9k?=
 =?us-ascii?Q?Zko5bmgVsauazqrcIJElQeePrlHzQpnVoTK+gbXRy65rbwtLNPYiPFnediF9?=
 =?us-ascii?Q?wMcBL+nzNCx/ArxGRPsOTYFeayh8t+MURBb1B2aVvOjtsMJY0P77Wng9J7Fi?=
 =?us-ascii?Q?l6OkyUtr+/q1NcWvH6gDgstR043wT+Z0npBgggumCQP4O1yKNFJWHEXGqgbR?=
 =?us-ascii?Q?BOBZF0kcfuRaVafjrtbjjvH6I2LhBCLITzKmQDs6YO0U8a55o2DqQqziicfi?=
 =?us-ascii?Q?HTZfUSdZOqi9LjwC5Yz2lLvmv8IVJeNmJkO/ZWhHmJtk36CeQne7TirskY4G?=
 =?us-ascii?Q?js6P2EQn3yNFM/bQO3Wdh7bkNjQIp8FfFunmsn1hNdFFF6BPH4mLcsdI5HLr?=
 =?us-ascii?Q?yn9M1fI6XJPcJWc03ALNrDif3FKChkdBMlQKBvjWSuO4hEd3URyvbwipap21?=
 =?us-ascii?Q?Yzs8AgYkLBShHPeM+EvlHhjAlQLTOue6I3v0DoMTbcBkSVh1a5SdlMMkGLgp?=
 =?us-ascii?Q?Zelnh6UGVRkhrs4eiyIrVz0oUwxWEGzDhy0M3TINWnXJP3mLVp2j+752k1K6?=
 =?us-ascii?Q?4wcXI8ZGM2h8yXod15UHW9SjYbN7430nv+zRZIdH+hHqRMf811+9Hzu3zCvP?=
 =?us-ascii?Q?YsPVE4VlpxsYRWlx3IAYTO9yEY7IPPFaVLOBi5DUHrqF+c/EUm42+CeHV6pw?=
 =?us-ascii?Q?wr6KtmV+M8oxjsSDVux6VNvXLNrxGS/Slwvti2dLWsT3uT3de49MFlMID0ow?=
 =?us-ascii?Q?mh848+mpYDHMRGj6cuKF4hOg81OHTYVEcku4ewlMK+PMrPaOIwInGzGCzXfA?=
 =?us-ascii?Q?f3kEgdssziYOpfs9l8FoFDKjOUCAjJ5uFcjp/WR+OmC4VeDDMTDFHwcF7Ugv?=
 =?us-ascii?Q?hK9hyZAi2ErVVAibMUo7c4YwSodQjsIkgk44f3abZLRzvPGSppJdmbczo2Tf?=
 =?us-ascii?Q?NFLmzfVgekHlqVkCbEDdY0j+b9AGToonPGPbgwvrFaqUUvPweyOJWbVDj0w7?=
 =?us-ascii?Q?lht5t701FZt1rU8vVQgdTMw2AEaVR1NJaOnaiBSOWeBFdhPI1cLOLiUXcsfd?=
 =?us-ascii?Q?PyC4UPSZeNW6sfm/Wz/aU3zqbaEAObwS94r2V7cQkjv+GzVDxMO3QsLU4nww?=
 =?us-ascii?Q?BwzEZ61WVJqTApdi0V4RO9ENQNHccBA3zFaffO6FnYT4smAgiXj1STuj1evE?=
 =?us-ascii?Q?c9P1O31VrqzbUa5YBh6bYLPnA8mRH0LwuMVeUPij2SYMNMzyDTDOX2Ita7PR?=
 =?us-ascii?Q?lXdmc17B8th/6qyAW9vMLx1Jheq3/AGdlf5k2LIbZ66M2j2LSXJG9FOVzo/P?=
 =?us-ascii?Q?zXGrVMRAyUi84kP/CnRNiEpPby8IgW3SLXYvMZwhIbCPx9FVfOz7wJI/G9Am?=
 =?us-ascii?Q?2gHkY5B8XPZlEYKB8DLQKzXpigXtxctVqOBSJmy4ftl2Jb+Paltc8/BFZE61?=
 =?us-ascii?Q?QYFF9xVsxKm8oTdMIzF0rNN79VfHXeskniIyqs9MpTXNM8soUlZn0sha28w7?=
 =?us-ascii?Q?dGk6o3NJ/PMmT2UrrMcpT3HBTMzh4G5xeAmEJ01Kqe8b6Ahgffkovfllrhus?=
 =?us-ascii?Q?nfK2wp1bWwj7qXVnnDPNPFQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f44eff0-33ed-4df3-a496-08dab646586b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:07.6574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1WLglYjcY7UZhHoJsLJFvaBa5QuEp6N6/ih+XdC2Fcamk4El7DQ6/6U/HOOOSDMAvGvhrWS3MF5bFjH/7RtOM6ZV5LGmEELKsXYpYvGgNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches have the abilitiy to be used internally via
memory-mapped IO or externally via SPI or PCIe. This brings up issues
for documentation, where the same chip might be accessed internally in a
switchdev manner, or externally in a DSA configuration. This patch set
is perparation to bring DSA functionality to the VSC7512, utilizing as
much as possible with an almost identical VSC7514 chip.

During the most recent RFC for internal ethernet switch functionality to
the VSC7512, there were 10 steps laid out to adequately prepare
documentation:

https://lore.kernel.org/all/20221010174856.nd3n4soxk7zbmcm7@skbuf/

The full context is quoted below. This patch set represents steps 1-7 of
the 10 steps, with the remaining steps to likely be part of what was the
original RFC.

The first two patches are specifically rewording and fixing of the MFD
bindings. I kept them in this patch set since they might cause conflicts
with future documentation changes that will be part of the net-next
tree. I can separate them if desired.



Context:

```
To end the discussion on a constructive note, I think if I were Colin,
I would do the following, in the following order, according to what was
expressed as a constraint:

1. Reword the "driver" word out of mscc,vsc7514-switch.yaml and express
   the description in terms of what the switch can do, not what the
   driver can do.

2. Make qca8k.yaml have "$ref: dsa.yaml#". Remove "$ref: dsa-port.yaml#"
   from the same schema.

3. Remove "- $ref: dsa-port.yaml#" from mediatek,mt7530.yaml. It doesn't
   seem to be needed, since dsa.yaml also has this. We need this because
   we want to make sure no one except dsa.yaml references dsa-port.yaml.

4. Move the DSA-unspecific portion from dsa.yaml into a new
   ethernet-switch.yaml. What remains in dsa.yaml is "dsa,member".
   The dsa.yaml schema will have "$ref: ethernet-switch.yaml#" for the
   "(ethernet-)switch" node, plus its custom additions.

5. Move the DSA-unspecific portion from dsa-port.yaml into a new
   ethernet-switch-port.yaml. What remains in dsa-port.yaml is:
   * ethernet phandle
   * link phandle
   * label property
   * dsa-tag-protocol property
   * the constraint that CPU and DSA ports must have phylink bindings

6. The ethernet-switch.yaml will have "$ref: ethernet-switch-port.yaml#"
   and "$ref: dsa-port.yaml". The dsa-port.yaml schema will *not* have
   "$ref: ethernet-switch-port.yaml#", just its custom additions.
   I'm not 100% on this, but I think there will be a problem if:
   - dsa.yaml references ethernet-switch.yaml
     - ethernet-switch.yaml references ethernet-switch-port.yaml
   - dsa.yaml also references dsa-port.yaml
     - dsa-port.yaml references ethernet-switch-port.yaml
   because ethernet-switch-port.yaml will be referenced twice. Again,
   not sure if this is a problem. If it isn't, things can be simpler,
   just make dsa-port.yaml reference ethernet-switch-port.yaml, and skip
   steps 2 and 3 since dsa-port.yaml containing just the DSA specifics
   is no longer problematic.

7. Make mscc,vsc7514-switch.yaml have "$ref: ethernet-switch.yaml#" for
   the "mscc,vsc7514-switch.yaml" compatible string. This will eliminate
   its own definitions for the generic properties: $nodename and
   ethernet-ports (~45 lines of code if I'm not mistaken).

8. Introduce the "mscc,vsc7512-switch" compatible string as part of
   mscc,vsc7514-switch.yaml, but this will have "$ref: dsa.yaml#" (this
   will have to be referenced by full path because they are in different
   folders) instead of "ethernet-switch.yaml". Doing this will include
   the common bindings for a switch, plus the DSA specifics.

9. Optional: rework ti,cpsw-switch.yaml, microchip,lan966x-switch.yaml,
   microchip,sparx5-switch.yaml to have "$ref: ethernet-switch.yaml#"
   which should reduce some duplication in existing schemas.

10. Question for future support of VSC7514 in DSA mode: how do we decide
    whether to $ref: ethernet-switch.yaml or dsa.yaml? If the parent MFD
    node has a compatible string similar to "mscc,vsc7512", then use DSA,
    otherwise use generic ethernet-switch?
```



Colin Foster (7):
  dt-bindings: mfd: ocelot: remove spi-max-frequency from required
    properties
  dt-bindings: mfd: ocelot: remove unnecessary driver wording
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
    reference
  dt-bindings: net: add generic ethernet-switch
  dt-bindings: net: add generic ethernet-switch-port binding
  dt-bindings: net: mscc,vsc7514-switch: utilize generic
    ethernet-switch.yaml

 .../devicetree/bindings/mfd/mscc,ocelot.yaml  |  4 +-
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 26 +---------
 .../devicetree/bindings/net/dsa/dsa.yaml      | 26 +---------
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  3 --
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 14 ++---
 .../bindings/net/ethernet-switch-port.yaml    | 44 ++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         | 51 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 36 +------------
 MAINTAINERS                                   |  2 +
 9 files changed, 107 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

