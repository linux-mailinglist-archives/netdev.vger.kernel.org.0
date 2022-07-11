Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D785156D2B8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGKBtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKBtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:49:41 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130071.outbound.protection.outlook.com [40.107.13.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AEA13F75;
        Sun, 10 Jul 2022 18:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWLCJf8mWYq0iCMmQddSF3WwxAUfDzxifF3iCNaqB5FasHlCbxmOF8jkgdAFiB14dWmEvzgzhmwxy7XXWk6Trde1ep15D9RayPwi5N2s6mYrQw+4bT7rIn2MkUom7zlLISAslG6CneexTGrf3vRkjd0J+YK1mY2dRezeYTDE4n7/lZUMBpZLgbUYPGvylcDCQy2KK6kuSc+dPlnn9EQuq5Nugjb7VsS2LVdlUO0w7wAlnH3awMX+MjyzHMsP5jfusrb12s6vvUg2E399nJgRPgibimF9SFQdwiC6Q+mLzqllmHHey38V7SoUYISAo29lz8Et+ZhVWbXM1w24WpWIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CJkZ61v3bdULjq3lXajsSde+/uwLER/90rib5xlmAM=;
 b=gxA1KWMyAcsBM4tIdBLnUNYyruP+HtpVnQ4fM2+xb6ak5TNPmqRf6nUwqnY2lSw3Wh7+vjdrEPA0zEGKNs7cSZsCnpstr8fsVmw+RDajAQSO6T5zgDRq6hyng6gvafzcj1IaTWhVyDtICKKANwG9IjxHuKBcG/BIr4NsHaT/VZOZUEFJZygXsIQcupBKuxdN5BVMVy8XBtA5GUok+yvmmTGRIoRT4VGF57/x5swK03lz7TuiXi2VRXXSlzUY2h5omtQtnVPrlNKdjqf+Ld18QooxTqw2NQ7cvMAVXN0A1KKc9tXBw5x3hTfykRq2gJlqS+quJEInclUDRafhv3cEyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CJkZ61v3bdULjq3lXajsSde+/uwLER/90rib5xlmAM=;
 b=P/qUmntDmYY/CjQjbs9ZkLHChguWH4SEhjKgeafIeKiHeSCQrDteTmxyKMGsqjkoNOTdRFTeJvIfoCsmz/oIviI0oHrE/tlZULXbd1A1UlxvkKkrOOXoihs8mvZlXiDDnnGyJZ+juvy55Kb058DPwJplg0UNHDWvCBS6lEzC0gI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6673.eurprd04.prod.outlook.com (2603:10a6:208:16a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 01:49:35 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 01:49:35 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V2 0/3] Add the fec node on i.MX8ULP platform
Date:   Mon, 11 Jul 2022 19:44:31 +1000
Message-Id: <20220711094434.369377-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b907d0b-9425-4496-8389-08da62df9b35
X-MS-TrafficTypeDiagnostic: AM0PR04MB6673:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEEjK92liVyHJqyoJ2FGIKgOYip8W6DB3EWri5WTggfLTjrkjpGEJU/ygCxpVnrbnnwguLg0tBnqwFLO2Q9wLCUSdD1TPcTkO1b2U44hxQzfKNnPbxcUvgbnEB+XPby/5snw5p7HkdjfkqvSr9dZymDgiAcjsmNAJuplEJ8YaeSriYQhSHE26StrOcH4NwQOmAfVCqQnHWtLdrxbeZxkYEQBXXvbvrwT+LbT2cnOC0i2AL5BHlmGUJCPbB1QQIPMB/YoZx3DnCRZ3LpsarmNuyXhsc/2M1yCX+/NiUMp3vH6AcvH7stD/wtWHeG4HWDf0zTLC34nIScMH5Dd4miAqonDTptkJNCzpVBFIXCzAMI0nsk7vVO3NvewIPVJjTTtTZYCshXna/FBC1E4Yx/bcN9cBF0YtifdBSfgICY+AOiVVJd3OFqFxCdv7p48zS7IcXNN5DdxJoUtReNBJCc7G5B3lAiMS5CEJsfCbfi1RtCrgoD19smCq/56sJJT71lwIqWAxygDbqoVdOswhltJEV7Vo3BMFEHpAvwZOeQ1nvEZeRKxkbwjSazoK5LZChXaVpvyoEdhr0KuHK00mOmpenkiFLoiBCuDt91FlyY1/4SZyfqO5EABaZfHd5XlvtU7A9pRzAuzKJlt443QKRMMMi1amOvPV8uzk0pGhdO4nx4BZLi1oniPO3RwShOxKuFJA9QtI1kr7ytAdpHDjmAMQNW9eAN+YR+UzW9jYmBJRiRPezvbJBiOSY5jQYeLo5ZTA0ouInkSckzEbHqKtHandZ13omrM2qXBrHmlV1zwPho0Du66M7Zwquu/WbNrFjwf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(66946007)(66476007)(66556008)(6512007)(86362001)(8936002)(186003)(6666004)(8676002)(1076003)(4326008)(52116002)(6506007)(41300700001)(26005)(478600001)(6486002)(2616005)(38350700002)(316002)(38100700002)(2906002)(36756003)(44832011)(5660300002)(4744005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sYmf1v1IaYvWU6spK8qfbQtos8jIbeekpzY8/sB2HmKji7Vmio4tkssMvE5S?=
 =?us-ascii?Q?Z0qceLooUR0xNOTwFZKUOy2PvSwKUfiWfeJtlIDpxT2OiqX3512M2txzA5Lk?=
 =?us-ascii?Q?MycLbm5wlYYRQCK0RWgCDzjCDXazWvRszvCgrLkj74K9HdHEteZ4EuZfGB3m?=
 =?us-ascii?Q?Glz7oSJ9xNBAddZex63QhvchfpefsQvsNqMWI5pvxjEBdrPGnay1lqayoM9r?=
 =?us-ascii?Q?VvSifEEWi+wmXyUvjOirwwcviZTzmRBK4ZZxFPmqTCZsm7DFfZvXa5aAh5wz?=
 =?us-ascii?Q?3XBVAwdzpqLPen8gvo1K47yC8R29N71VxPWE1HOg3aBHumUZl6KoqOoMvqEp?=
 =?us-ascii?Q?1DVz7vhyubz6EKEQ7fPTCmYg80rDCmitUs82cjwNgev7+nNbOGT9LYVtvnie?=
 =?us-ascii?Q?XqxbJiMnyaiTRSW2RAtBvUczeggF3r1eIx1ATX4axaEy5isfahqy+cLXaYwv?=
 =?us-ascii?Q?w2S54boQqix3LL56Q0D7ZOXToqqsbsv51e86MYVb6bU40GRb4Kcr28swwQz6?=
 =?us-ascii?Q?Odd35xsyo6xcEfwR83ASmX2NOgxxbZNrknaUYCl/U4jHicaT1I0cmATMmjki?=
 =?us-ascii?Q?st1jSJwgz3wexJhv+/RD3E1hHbixGQ1XBaO9AZdwXkmKM8km2un/ybEyDVHX?=
 =?us-ascii?Q?eMy3J786MVissb0CW0Oy5TYS0Xk3lmh9em2HXMGnhtsST3kvFvVd2Rz5+Pj2?=
 =?us-ascii?Q?Q5ozbGSLbqBJ5YOrogWBhPA3SfiUGVt1RfvUwJi3Bg1LvJHzJC87ZlqQwY7+?=
 =?us-ascii?Q?VXMIAof8jakzsWnYExts+Wd6msAwVEVCxS6M/n52l/XOMSzpp+V9sDACbPTv?=
 =?us-ascii?Q?gVdcLC4l4Dj6N9OYUwkmf+5v+VgRt6pzl4tNewM3JhyxdFnqZQIWSNycRxs8?=
 =?us-ascii?Q?PbxRGiaNMcI78JWzMt92UqZ5wenytTJULA9ayt99QPTqWS4HdLWLHN/ehx0Z?=
 =?us-ascii?Q?4whmTNSt2xRDVpHifFMHvaxp0venpdKFlmWqOHhaOK8Xg1Dxc4o6+EhK7ELg?=
 =?us-ascii?Q?aHKlPFSCwPJh0a0eUZF1iF0ag4QG5Nvs0rSO5CJwrNtXhle46bWNy9WHeARO?=
 =?us-ascii?Q?qk6P34n1qZ0eMhCwgcvDu9DWIo/khdZvHzQCvAWuxS2H21kSFqmiL4oftnPf?=
 =?us-ascii?Q?UakoLkJ23rqvExVH0MTWPTS/qGsEI8enJVTRSZ9USdvNxHd5h0ZU0IEPVqMI?=
 =?us-ascii?Q?Hk/+aOO8YmHXJlBQKWCAbAGvXPXoFQl5DZNpXsBEnFdo3iYjzZ0DLt6DggHM?=
 =?us-ascii?Q?1MQqdBAapOzdAqu8s0oxLhABZoiYJvUhjiyi1Z3gvEtEcpCDVqfMWi5HsvKi?=
 =?us-ascii?Q?rBnvcJA5Mu2YO1Dt0oqXUqon7gSumty9eAXAuZkMq4mtNEhiyu2GtsHt/07t?=
 =?us-ascii?Q?Yjr30P0akvCC0u1Ut7q+P6ecQNWK+ShVMbDVZiuB8+1csOsBkUb4EgPp2Msj?=
 =?us-ascii?Q?hCkmKd7cnSUI98Umz7nVH/45SxihxfMdndhAU8n6iTIPe6hsAJL46LVENQHI?=
 =?us-ascii?Q?S0hbfiWPYq6NvP043sG9gMxzAGYKhQWFdOlbKA86Le/yIgcQrrYyG2CE9fwW?=
 =?us-ascii?Q?3iJPIGuR5AKpEsAZPQHRQSNNPJBYYYa6LORgBBx/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b907d0b-9425-4496-8389-08da62df9b35
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 01:49:35.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcc788dcOVlS03l17T+A7Ak64DZXeQDjIp7fQu61NE5dQOivauVvFWjzg4o4apo4g6IYnjhECF9/fF5AaFI4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6673
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the fec node on i.MX8ULP platfroms.
And enable the fec support on i.MX8ULP EVK boards.

Wei Fang (3):
  dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
  arm64: dts: imx8ulp: Add the fec support
  arm64: dts: imx8ulp-evk: Add the fec support

 .../devicetree/bindings/net/fsl,fec.yaml      |  5 ++
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi    | 11 ++++
 3 files changed, 73 insertions(+)

-- 
2.25.1

