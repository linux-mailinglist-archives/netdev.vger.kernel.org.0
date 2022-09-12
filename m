Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826E65B5F8C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiILRvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILRvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:51:16 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA1620180;
        Mon, 12 Sep 2022 10:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Og9mO7hQFjaDl6RUBoeJ+tEe42J8ChbIPmIme2tn775EsOJjvCGLhcfFMPX1E4pOrlxBCqE4ZGJHZWHsxGyaxGKSDyMcqUV/I0mS1BZJWDX8H9MwqbQsTjXQVAzmnBROBM1A4DA1sdTGdqakeQrBEiexDny3fiNLR+fKrHfNbvO38Ith0rPhTzDIvICCsPemaLbjwjCmQxuDyXbYdELEO27r+T/KoQ3Ag+FIGXc3pIfrNKalstsTkE8dbGio3qeIaqsA+5kGrnqqh1VhUBQ25Y2HXHPKPJIijJRRIFFiW6lacQQji3pollPCpjBGahpHZdMj4NlUqKzKMLjSw//Xgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1rYEA0wToTLOz1wurSJMr3voKK79USIQen3JOPEz9M=;
 b=cLSMZDQqw9SSJJvL5ENBXFBMx4AL42xWc5aW4MWVEhocUDd2Gs4lsjGPjSRqqfRJ18upLSY6Zwj1SpxHidQomtZdsTv+56i37jpabDmOFAwj7HKzIPmJIWGa24+eUlPOKsT98EGDboz4OiDt88MxuHZE0P224503Z6805ULavlVCB5ipAy7XvR+18a24/UXWTZp6GRWmd/ArL9h+SndQInHp86UhmgiwlHumsjeMqM9nkHeAucbdMbGKAWcUxZudG2h6Y4DVi2z2QT+yA6hnYJVcumJYhzuRGJL4vz424AQQecbcFTZJDnm7y/IBAuXOKnZfccooF6ZFpE2nGtUxYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1rYEA0wToTLOz1wurSJMr3voKK79USIQen3JOPEz9M=;
 b=CBscDcr1MdYo16EVsIiPfFhu4L4kBL378AeagthYJxGMOrUxWFlTrJttXo1ImGCG93OGAigGZXz28GxVki/qO/u4KdB70PECbq2IMncN54RG2AKKh1jLii53pBRCY1qv2poXM6h4tkrL475KRqnjtkSvy4vH7mo9+5H70NQctVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8687.eurprd04.prod.outlook.com (2603:10a6:102:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:51:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:51:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH net-next 0/3] Remove label = "cpu" from DSA dt-bindings
Date:   Mon, 12 Sep 2022 20:50:55 +0300
Message-Id: <20220912175058.280386-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8687:EE_
X-MS-Office365-Filtering-Correlation-Id: ecfe269f-9037-47d0-bd95-08da94e760ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lnXG3TE984kLVhJSVmeEpNsq1cbQp3uBPU4URqJ+1e1BrMBY1nL5x0jGAln+RM1/z7OsmFHdbSBT0hKnof7TFX0V1wiWHclqv52gGCR/7oOW1xHetf/WbbdmdjpFhwP4nn2Mw+rbrGB+YJNdZfMY0q7tdCHcC7TXjjKzuoAm44n9IJ+ySafAZv97dm98csa2MnVy+WbIG0Tqes1M2hHfLoVRIvf2JK1iuG9oDuK+Xm1X4QsERQ6nKkqCc4Zxlud1aG8gpwMPhlx0QuLJkN3vnk6q9QVmALud4PMJchvqKk+5ffieQkd6Hwac0fkaAn/QPMqLbGuurxq/d6fw2NN8HP3d9mW9Hmfgi4YsYvTaMUxs72QoBLiNtGtqriVs3sKxngpadMWkzXzA0pZJCN/wAlPJXnD5EEeCFXKOKjp0b2Rj+l2Hfn3fY+guyQgdtks3RYX/5qzrvRfpKmF0yMZ947T8geuYBcSZ14jbHxCIvupoavdzJQ0GxecMAZQC8D2z3kavijUo+V36G2E3q65MWmqxEAdmPjVnDzQE36HI712fN5ZqvGifDcz38q98QWjndu2mvhvCAkizHVg4Mx3do+NmJNxYfxmRby+RQkAFH6If3JUW23YxXx5dFYQu5+bMmiR8KR1nq3i4khKu5c7hV8YxYrdUrKXCGHyRwe1S29cFa2uAmXswfswEGk9Rjc/b7zNwZp5Ft3CtbPWPH7CVhVK6KDQpRKrt8fMLvUn5nxER9RwWQ3MxxqZ2NyQldLcIC3MaLbGMOk5ofrbBzF39PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(83380400001)(186003)(1076003)(6486002)(26005)(5660300002)(8936002)(6506007)(7406005)(52116002)(86362001)(41300700001)(478600001)(6666004)(2906002)(8676002)(38100700002)(2616005)(44832011)(54906003)(66946007)(38350700002)(66556008)(36756003)(7416002)(316002)(4326008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vkUP/bbzW9k5puzhgIQJRMzEqIx5O73QGIC+9lzBWFput1DqSQ9o5nosAIHg?=
 =?us-ascii?Q?lOpwDAyPkwnUWYsBmbl9uaQKkY10JgawPuOrZhIrT+i6iUJJfzJWSLDDzleU?=
 =?us-ascii?Q?PY4GsvhB4QjJN5kTFZ0C/IfVZ81TSK23fABtvOyPqk7BmFjcCZq2quIpyJ66?=
 =?us-ascii?Q?bPIUPhSGivUysBsiUhTObTKeSTJl8j3H6VA2F2LVTBnjFEAvnSAigUlnjRTN?=
 =?us-ascii?Q?84mtdHHfeJrT469ujNiV0sCXClSkKoUZtG1RodrXn3fKaP9kL04U7EBxvwzt?=
 =?us-ascii?Q?hyh9clDaTHs64+yrY8OKdJ8ogzTGlkjKCV2wMrniXDzR2hubyqAkUcZEcmTR?=
 =?us-ascii?Q?J/OOzvqiXyBC3hSvSul6xQB0JVdEnTu8C3VJbQzUE2TeThJoeIyKQMcVhV9r?=
 =?us-ascii?Q?86UR2N5njuUrVLC+eOVkJxS8VSLkA1YtmdtKie3uBpg1kZJ/EWKx9b25mwnp?=
 =?us-ascii?Q?VDFpohWv9Qy7b+LLmV2Y0ZpRmJ9RDuLqfzFmGwWyhCPBC6vtHurAVcMiXxHw?=
 =?us-ascii?Q?ePEOVnKpHLTEzrkmx4QTXmJ3w2J1OJMstz6tOKq0kAeSIzG7gf7scT+bqeHl?=
 =?us-ascii?Q?OFnzftXEUXqYe78t+a561G+6Ev+Th7AquR3ibE94x12laG5THXm4L/SvUWDc?=
 =?us-ascii?Q?v4eeQ3k+Ekis/xUaTYyZn+90YPuWs8lHAsCb93W2Sn78MYYFA+tufW7hMWQ7?=
 =?us-ascii?Q?VEEsEMYVx+n2soOrQEduFL/cuVRpZt26NrWrvzbw0+Q2ItLtrI+dcum0rzfD?=
 =?us-ascii?Q?cJuw7Ql+quYj7BUKXUiQugCvAVvQQvlfaxg+EmwuZ01E5LYWAiLHrVHSCeQy?=
 =?us-ascii?Q?u0UTRwQAqKbD9iYd5yfNvr5l11Mb50/C+GuvVJYuYVkqBd+nFKAujPCkYynA?=
 =?us-ascii?Q?n9t22UU0zky8QPM7XUn+BzhVLNbOIM3Al6zDOQIsGny97xAKDU4hWI2lEKOl?=
 =?us-ascii?Q?NsYIqR+J1NyNsR8QlYYPgFoAqAFJW6yM8kS5w66J3yF3Id3Jy5xXbx3/e8Gd?=
 =?us-ascii?Q?icFKN5S4busagQX2v2VqZZySDILZVo2I3aO9xdTod7amOGeMALzr/fmFCT1C?=
 =?us-ascii?Q?jwNO+24ovFGTUrRjU2/AsvI0XV+AJMOQH4qCToPYDG//29vRKS1nocUPzJQw?=
 =?us-ascii?Q?5wl9wE2iMf8J4EWfPdcqQpvG4dFRpX69J5o7Tst6o0Us5OGbeSt3Ephb5tKP?=
 =?us-ascii?Q?pPhbAeW4sMpTnb45GbwUEFPzsi8NWc/jNRTD4VduKvcY5VRB87CX9P/Ak4pN?=
 =?us-ascii?Q?2dan4p379bA5Cjl39SHpo/EqokQ1cnHJg1K+SdBO7snBZ6lYgRhRATJX0lrH?=
 =?us-ascii?Q?r8BsB+HGjJH0vLi++qlPeabGWNP5mTqcLBvuxB+lZ5JAq6cyT1JwFixWQ4Mu?=
 =?us-ascii?Q?J4lELFCBxPIlLd4mhHvM+0VeMo5i/Ikd5D8tX+NU4NzycaUh9UOgk6OyBlFM?=
 =?us-ascii?Q?+yd7D7FircLo20GyvXbF+Q1ekY3T224OAMiCjaW95TuqThCaqeh/DFgJeD/0?=
 =?us-ascii?Q?EL5rM5N+UjNkJ6VGpff186yvXC/yJkD0VRBNc3bm48GyEq9xHJpJctQjOFy6?=
 =?us-ascii?Q?fSECv3WaqZgk+wn+XAqkGRgOXXc6J0LkZK/ZGr9ZIaj4L5HJ4NFVyOn4qG+H?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfe269f-9037-47d0-bd95-08da94e760ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:51:11.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqNAZROk92iOOZIJLNrxXgXENB3p7PMnraE2hio9+B0Jh1aDEuhYXaWgI+WlpJwy9c7XHmrPDUj7Q1Cys8rUCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8687
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in more detail in patch 1/3, label = "cpu" is not part of
DSA's device tree bindings, yet we have some checks in the dt-schema for
mt7530 which are written as if it was.

Reformulate those checks, and remove all occurrences of this seemingly
used, but actually unused, property from the binding examples.

Vladimir Oltean (3):
  dt-bindings: net: dsa: mt7530: replace label = "cpu" with proper
    checks
  dt-bindings: net: dsa: mt7530: stop requiring phy-mode on CPU ports
  dt-bindings: net: dsa: remove label = "cpu" from examples

 .../devicetree/bindings/net/dsa/ar9331.txt    |  1 -
 .../bindings/net/dsa/arrow,xrs700x.yaml       |  1 -
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 --
 .../net/dsa/hirschmann,hellcreek.yaml         |  1 -
 .../devicetree/bindings/net/dsa/lan9303.txt   |  2 --
 .../bindings/net/dsa/lantiq-gswip.txt         |  1 -
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 22 +++----------------
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 --
 .../devicetree/bindings/net/dsa/qca8k.yaml    |  3 ---
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 --
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  1 -
 .../bindings/net/dsa/vitesse,vsc73xx.txt      |  2 --
 12 files changed, 3 insertions(+), 37 deletions(-)

-- 
2.34.1

