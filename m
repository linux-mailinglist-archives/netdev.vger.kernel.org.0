Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E46618F91
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKDEwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDEwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0B20F69;
        Thu,  3 Nov 2022 21:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMgNW9zU9ZwMZVsBcP16T36QpytJzhE6ZsVqZx0xB3zVFFK6WtVY1hsWkoijIt2SE0wzRW+qCyyD/Q3ImYi4Rv1i1k4GOctTEAEkxRaqDU7BkpQHNuAQeC8qMcrGi1Xoiha+km7cYMqIRE9ZHwalfiEexWdb7UI8++ZGdDrLuFljFNq9I4AoqErQokZsAL7uIjACVpJaNTjAD7NqM9NN6jDrVryFX1Aqp5I2ocIlBUC2vCNQhfil6W1FOOC97Rsydh1CKy8NO5b6IhIYG6YRCyu1eufxDQ/QdkOi/5RhUZ72oUNWPPj9JkcBIZxFKJM9bJvBFLnVufO1ulroS/Ifng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFkstsAjF2HZsft3kh4I2WvApenJcnSOsmWoyY2jZVE=;
 b=VIdpQeSn+ljLNIaSi3WdVvWEbj8WoV1SiyrcaIyjoD7t8bE3SoCTMe6+TDjTYgRj4GygLKeLLLz5HGZEDQUGgaDbOvF1giFzpOuu87nb9czh5acpBr533rO/HLKFG/UicQijFssqeF5ohGrB065kaw5wneciumSp2itwLs8KuKmMd5cAerRBlr33u+LK01SA8z7rk0htjcyXAr+vMO8pIeJkGyS5uOQCpngFfY5Vzp6qMjn5uitrxDmZ7HLNQrI9GQKUuz7I7Pc+NaM/2+oEI9+pWPdhVDJqFgm/E3RUCpxH4ZpTM89RYMgTb2YUAukIK/VWsKlKsABGgBsJHWz0NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFkstsAjF2HZsft3kh4I2WvApenJcnSOsmWoyY2jZVE=;
 b=PjQ8WeFmjV6J6ssCrbdHLfH0A2e/Ut3k9n9xeP1l4ixFmFlj+wnh7pVgrWguz11SNBEG/RoXkAuG01ExajuI2NSf2cC7RznZgsmXDo+Q/hFJm5BFnWfUguI0v2NelTKZ+zaM51gOz9xT/fg3FA/H5864vCrGriVw7yGRMr3hNAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:15 +0000
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
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 net-next 0/6] dt-binding preparation for ocelot switches
Date:   Thu,  3 Nov 2022 21:51:58 -0700
Message-Id: <20221104045204.746124-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: a24eda6b-5a37-49d4-4765-08dabe20581c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oYpn623zXY0C/gwFix5u+0XQ7cKuLyG04yeDO4FHr73aOVbgBCK8xAo3ifarK8rtV4gTzrJ+2CCJ040qHSk2H0ZwecduSqzAtoNeE7CxWjXUHHI596wP4bYOG2GQyaciX4NcVFGu2DW2rv/A7GGgxd8zLpsFOebORzc8yT1bIU8U8qnulRvUo3kUv4tNyumz40AAwFhiXnE3sj6flNDPOoDLqJ0aM/GGeU2MLnVpTvUmDRupee5AsZmn45tBMxO541RDcpzdcKWXsnTLAZovg1HXmzPKXI0KE0zTB0WIH8anAsNVFcKggbTRYuHp8j/1ghfL4DrkSzQCqEdCl+7WtgoqRv/Jn/NREc66XEAbsBTpBFucq/OQ6UcH3z+1so4Px7QLLhn6a+OVA6f77CULJSqZYufSvxRaFWSMXkDktBXXsUYBsh/jReHiPc0JfD39HcKDGN6/QAufpI3WkBoKuv0IQKuN5Pf0HwPOU01lH0j+udo0oiJuaq+FcGE8EwGCTdag0qS5tgMdIDngBErEkRmogH2OXJbjNjA105606NqXjVbU+bqZlQV/U2ZmU0Ec8OLXIIsw9i2XLCWhOvfsYhtOLTLHVFJB0njZkdj/FWprAo/IGkZSLI69wcDjIfq6w4RXb/9EbZpB2BetqX0B9NRODt8MzX5eJPzxUd038jz2yR9ptw2tevlq0WBJYirEXj3RUY6d0OkaBY/GXcCN2ed1WTL1e9XpmkMIt/hwK+IViMzRf0iuP1Cqh/4zLLVgo4EUITLJNsONNTjHNcmnHEnpdII7GxNzuw3BNvUd+VA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(966005)(54906003)(52116002)(66476007)(44832011)(6486002)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWlJN0tVK1BQZG1TQVdQNkRFVTZ2OU9ZYWtBMG9Nd1pjZW13Yk1sK0hZcUJW?=
 =?utf-8?B?MXh1ZVpsa1F3bXc4MWR3bDlOZGNBNWxHZU1HbGtmdTJ0dFY5TG1wcGl6ZDdD?=
 =?utf-8?B?ZFUxSTFNTGtlMWZTMmUvOEhwK2tIVURLTmQ4Vk5IVnY3blhkVlk4N3NJNk8x?=
 =?utf-8?B?MnBzSGJ1enlicWxLMTlpOHFYMEVmdXNNWUw4WmFnMkxxeW5HeW12ZDBJUmtE?=
 =?utf-8?B?YkZkSnpObnFrVFhFRGxwNWVOK2VVNGpySitKNjRGdXhaWEZkYTB4YjU0RHJD?=
 =?utf-8?B?V3NUOHVOcW9jcWVJdVlOd2UrRE52aFN1OUhjZHBuK1NyYjVENmZDVnNaOHVo?=
 =?utf-8?B?RndYaUp2TVBJSzREdWw0b1U5aFIvRW0rbDVRYzNDb0VFTC9OTk5oZThQYm5I?=
 =?utf-8?B?TTlmS1RwRTlTaWlJLzBIdG1LZ29rd0YybnVMWVZCcEpRQjQ3U1JkRHNOakFX?=
 =?utf-8?B?Z1ZQV3YyU3RaaE9veDh4VHBNQzFyelllMmVycVp4YW1VZFZEc2dYQ2pycmpV?=
 =?utf-8?B?dG45djdnMW01dzIzZ0xuSnErQUNMd3M0S0E0L3BtRzhEZDY3aGNUVEpRVElN?=
 =?utf-8?B?MFYyYys4emJnYlFxRVpsYURPaHdYTDNiSWpocUZrZG93cGFHQlpEVFpyQ0My?=
 =?utf-8?B?STFDUHZkbE9kLytRa2JDSG5aWlc4Nk9EdDlCbXV0bml3bE15MWdCVlR1Szlr?=
 =?utf-8?B?anlmNisvUE5jZENVbnZqUEN1bFJZYllFWnRpaWY5d2syeXZmSWh3Qm0vWXdG?=
 =?utf-8?B?VmRVYmFmTVhqQjUyb0c5NlU1dmdmMnVuZFoxdXhYcUMyeklVTHk4NlNMMTkz?=
 =?utf-8?B?RmVqZXhxbVJYL3ZFb3JrZ0tJZXRJcWR3OUVDdHV0dVJiYVVWUjl2b3JlWjM3?=
 =?utf-8?B?S0JNWmk0UU0wS3BYY3dEOGFKS2hmczJvL2VpNldXK1dRTHZCdVI1aW1pMDlZ?=
 =?utf-8?B?ZTFJUEl4cHI0ZWtsTFNXdzFXTVFzTFNBNFpHbzh0NHA4alpSemtpNmI2WjFG?=
 =?utf-8?B?eXJKWk5oek9QTXNUbUhwbjloak85ZG1NUkkzNFN6QmFwaUdRNUJ5aDF6WFVY?=
 =?utf-8?B?Q3kzVEdPU1gwVTAxeUdqYlJTM1M4SFhvVlkxenNYK3FMaEdyY0ZXNHZXUTdl?=
 =?utf-8?B?OVdwVjFXOXRGNmZtdEEvYXpIVFBxeXd4R0hpMkdiY2tubWhoMnluZ2ZLMHdI?=
 =?utf-8?B?ZG1kMVJVVit6WGJGemR0U2pRRWJVRHlRMmRWem1SbTc3eTdURnNKTFMxVC9u?=
 =?utf-8?B?SFQ1c1B3YXJnYjlEWXY2VS9OZFRtN2lUWDFVazQrdjNSMHdCY2FIbHVKdUoz?=
 =?utf-8?B?R0NDNVZ5Q0VHY1dOVVo3cys1MFpERDdvWFVIcWgxdHBWQnNXdFBwYTI4NDNj?=
 =?utf-8?B?Y294TVlxaFdNYmtXdkhTSm1XS2pJQTBKNEw5Nm91YUhWTkdBOG9OMEhQVm9w?=
 =?utf-8?B?WEFjR2hSd2NBSEZaOGYwMml6V0ZHVE9rcXQ1UmhFdGpxRlVCQnZ3MzdHZlNY?=
 =?utf-8?B?KytUTFRCMFYwcVc4Y2QzVFZUaUE0MEJDVkh0YXdaN0xDZzRjTStxaExpNmNr?=
 =?utf-8?B?R0lGZElFQ3FwZGo1MGorZmpFM0tCa3ovcXJaN0YwV3d6dkY3dUNFRldpakxk?=
 =?utf-8?B?MFUraEl2NDY5M25USFo1NXpvNi9VYmpxWUdadCszQTdoOFBSWjU0Nm1EYkd1?=
 =?utf-8?B?amlkZDhLWldmbldhU3A4dkdBaTh5dytHMkZtcUlMczFQWWJqNkN4WUNIV2FP?=
 =?utf-8?B?Y211RzA3VHpiODhrOXhGNDgvaWsrSkM2NE5qU1RBdFlJVVNUWGF1empuRGV3?=
 =?utf-8?B?L0hHYmcxUWlUeCtENDdYRVpBZFA1enc5eHBHTE1QTTNjWGJ1LzVXWFduaVZv?=
 =?utf-8?B?Uis3cnlKd0RDYXJEY25naEx0NHNFTmM2U2o5SjZ2QXZOYkRXWlhCb0Zod1hF?=
 =?utf-8?B?RUtkMk9rNGZxMUdPUzIrMDRhZThuNHpKajBocjVMNkJicklyS3RnQkk4anpI?=
 =?utf-8?B?OGNVcHRVZ2VYQnVma2RWVkJZSzNwQVZBcUxsSTY4TGRIL21Hd3VMUjEwc3Ur?=
 =?utf-8?B?MW1wa01UdkI4WCtoVW5YYlRuM0Y4ZWFnZC9PcjVzc1FUSEdHcG9mK2EwY0N1?=
 =?utf-8?B?ZW9NeHBkbzIwcVB5K3h1MnBBMERCblRZZ2s2YUdrV1FXSmFHb2VCTXFKa1dq?=
 =?utf-8?B?eFE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24eda6b-5a37-49d4-4765-08dabe20581c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:15.6262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO4cLDkgnryZwp9FFdUoZjpXq29jTrabxd6pIw7fnfUrL+mgKkDlQfZseZCQAjheuW4AJbxX/X1vQsnJXVvbI7v+fOHEybYyIgPYDcMVOqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
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

---

v1 -> v2
  * Two MFD patches were brought into the MFD tree, so are dropped
  * Add first patch 1/6 to allow DSA devices to add ports and port
    properties
  * Test qca8k against new dt-bindings and fix warnings. (patch 2/6)
  * Add tags (patch 3/6)
  * Fix vsc7514 refs and properties

---


Colin Foster (6):
  dt-bindings: net: dsa: allow additional ethernet-port properties
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
    reference
  dt-bindings: net: add generic ethernet-switch
  dt-bindings: net: add generic ethernet-switch-port binding
  dt-bindings: net: mscc,vsc7514-switch: utilize generic
    ethernet-switch.yaml

 .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +---------
 .../devicetree/bindings/net/dsa/dsa.yaml      | 26 +---------
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  3 --
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 18 +++----
 .../bindings/net/ethernet-switch-port.yaml    | 44 ++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         | 51 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 40 ++-------------
 MAINTAINERS                                   |  2 +
 8 files changed, 112 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

