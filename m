Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D346B09BA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCHNrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjCHNrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:47:01 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823905943D;
        Wed,  8 Mar 2023 05:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lluqqL21y1iszo3vuU2y/8/CpMN1qR1XbcxyJHZYsD6WhQfoQGmuQ5AMolQ9ZjJM5Ld9/bj+CwecpXjCv2LtwtqWIOViG51YJYRGfs2qdMblA7pj0aMCRCcxaW+qdUjdMIfP1aPTYYvNfkHxjPoXk2UyakpFg7RMWVKotjMeSsggaQel3LES2XTvpPCHzQF3/8ctKSmXdfuVU/CE1Y97VOgiMRKNJukAUBfO1NT3bEdPs/wYQ0FeKoAicN02AY9hPRL6/9Ccc5ln+alIbVAttuOfG8swuepvwmC0hDJVvP/IKehB5EAdoqyces7LyJZPqp4wLeijITK6iaM6Adwcdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcK9xSb2zaANciGGhEVpzTOlzm2/JjuyRBJL9RK51q0=;
 b=cEnvtwCuCxQmrbExTkAry67JkxZH1vHcH1qu8f75k21sWwzxlgKZCTliWUWFft/a13EiX2hVElSL8u+Mdluw76BDmtRtV0h9jZT9J030oIsnDJ6QgE/4I0cJQLUtd9SLv22gK0LvMQgw0nk1HnpDWAL7L3l/8ekLvWhw68nzYzCcTvIsS+fELxZEn/FwrPEEvwF/JEUKC+pB/tc3ebBBYwLlTgi0ZhY0No+c13GLQiRbZQAe7+0b6SETme+kKmfmEuUZkoFKHVYY3V6WOqCjbwu0gVuitjR53I2SuI7YBdMld5i9cPdlCgcyJpQukwvtrnquiUIor7/IGeJFw94XlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcK9xSb2zaANciGGhEVpzTOlzm2/JjuyRBJL9RK51q0=;
 b=lmDsNj4QnYOFIuqVP/hOGzkAJAKMBxh4WbuX2nRX0TDkt7FHsf9vgO2sCPvkTz5cE/g+Y8hNbM8lAnseWVsT+37JJr7A57o421KNMTDkHVVO5UvoNQa9cQQ1a6aZ4cFW9E/5/pQJvqSf6NoeDNa9c1aXILssSFyp3YoWh87mxzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9136.eurprd04.prod.outlook.com (2603:10a6:150:27::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Wed, 8 Mar
 2023 13:46:47 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 13:46:47 +0000
Date:   Wed, 8 Mar 2023 15:46:42 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <20230308134642.cdxqw4lxtlgfsl4g@skbuf>
References: <cover.1678201958.git.daniel@makrotopia.org>
 <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
 <ZAhzDDjZ8+gxyo3V@shell.armlinux.org.uk>
 <ZAh7hA4JuJm1b2M6@makrotopia.org>
 <ZAiCh8wkdTBT+6Id@shell.armlinux.org.uk>
 <ZAiFOTRQI36nGo+w@makrotopia.org>
 <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAiJqvzcUob2Aafq@shell.armlinux.org.uk>
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b61cc8-bc44-43d2-30cd-08db1fdb8fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axJmadEfPfQuLjZU8ctP5lqT10vckbkomD2N7pO49kkC8ymvWbQRwWUAO4FC5cLSmb9GIbqaDDhjzOTtKBJLeMGuO+hu5rM5xpOg1xGOexOOnClqlmRUlNCB6ogWgjfQrjFyvQi1/dkypLJ2hVIaH5ep+YU2YucRzFBjyHo0whsV0x0rUC1tPWGzyEA7uehaLYCpg94sGT6jrOM1zoNhEQZrqgXLLXTx+cT4x2W9ICyd9WaLgM0TXYVx6hKhuEWkH1IDVIc7ucK4VNoLqW28omaqyecKPNSj7BHkIM1vFEcWclcxSpfmL0U1cF/eGv6cVHflw9riB/BbmgiOxm4T7RLOF0+J7N+elUZixMHYjYc58skPdaPbfiMfpbKgDwqqAWFIWA6tAzoXmM0SUcD1nKRpClIVWPnuiS9/oLWkoXYomvTl52LWmPm4BgRx1KT6JILA9pko2OnQcvSDmTZYMjz/Shq2KCePH+d7CShG8GemR/CP3rDaD4E7+xwR8duo/fnM9TCqaPV0P8mN66bLD0GJR7sOPjh45cX5bpehH7QDdh1nqEHjWDntJH9YewmoRsn41tjGPzUz6HGhKPP0JPsNLobg7JKNlY5FkXkmPAxoHuqtOQNhwraTodD+UdkU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199018)(86362001)(38100700002)(2906002)(7416002)(5660300002)(44832011)(8676002)(6916009)(4326008)(66476007)(8936002)(66556008)(66946007)(41300700001)(33716001)(9686003)(186003)(83380400001)(478600001)(316002)(6506007)(6486002)(6512007)(6666004)(1076003)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xd4RH9+57gpOYCM4UYN5A4jICU9bNSlL++FpMUPtBxag7W/5FTK/9OaYslnA?=
 =?us-ascii?Q?ainqsBVabEktcafAq0KXay1W8DUgjZLjuwkXmwWDn/0DHgbI+n45wGu+Rmsq?=
 =?us-ascii?Q?49MU5thgsJxC+qtBQvsgZQz4r4/jJ6xdViDwhU9tRKleqU6sLGlRqp1UOSm4?=
 =?us-ascii?Q?89yHSmNMCMILfcBxXK1U85OJxFf2pTRaSkCSmKNF/CL6JBG50xPTd+HqLSXu?=
 =?us-ascii?Q?UU6ICb879mhzZD2adXBVomnolV+FBjYKKZvQZmWWPEWP2cOSBBICr7l5FKGV?=
 =?us-ascii?Q?thox78APxVA/36nFJtQz0GBkXD+S8cRsW7hTVRw0Izbsmqr59hY/lenmCN+t?=
 =?us-ascii?Q?s4cpemCZAFJv4RUVnWsuvqktno6mQPaUDujjQbYQn9wf9ewg4W88nWk4SJfd?=
 =?us-ascii?Q?yNGXr06midVhPqkVD6zNHUxDgjdddYPImvLPWxTtlvBiLFXJB0FczJBcK7C0?=
 =?us-ascii?Q?tcLS6acrJSEjhK58NFmje8v50WftYzYatCooRAank+m9if5ObwCQTEh7Le8F?=
 =?us-ascii?Q?0BPBMt5VST96NXLKaikgMNPKC9Zja4+f1bekYgcovSh5CU+G/8ZPREyvDTsf?=
 =?us-ascii?Q?b99y+N0r3/LMVhCenLDrfuUBYpG9HYX0dOfCF5YqjqlOw80B/3ez9kTIRugD?=
 =?us-ascii?Q?ThjgBknanJy/hGVhZkrepui6KcrOzyaTqJ+rPgq8mYHPbcF9ReEvfrX2ZB+f?=
 =?us-ascii?Q?kvT27fAo6U3NG8W0XrOzob3ueGi6iEk5vxdrZ2gXACGclDlBK7EHmzBYR2Pq?=
 =?us-ascii?Q?/RQ4O8RcrrlhRujUt6dSyKE0CPRex6e5C8ivURCR/geWT31MZj2AiCeP9EWd?=
 =?us-ascii?Q?GmlrZbS5y/OSERRWLg+zOispt5guT6v7qmlneTlf6MIFjJBpzISU4L8sWGLq?=
 =?us-ascii?Q?hVn3EXESwmwltLKkx/LV+gpM1eQjg8ERAV4f1Ce3l1SBRMJEZUPHJlClayrB?=
 =?us-ascii?Q?asExNfitx2DugU2sKQ/E+zKSjRgfaTkfuZzDbTzMLZOE6Bv0xP9VvJ/muir6?=
 =?us-ascii?Q?nLQhFPZC5COrrMc7cx7zLRt0WRGM+Ov3ClXogAnBvN83Nwcl7bmt3bhJY7lX?=
 =?us-ascii?Q?izRVFsg2XMBLjMlLcyHcB3Kc2awu28IG/bE9liuNh8MPrIt1+quik6oiYn4G?=
 =?us-ascii?Q?iqAu/5VlCmSbwtuIidtSpb5ns3CKKImQ+hakGdf1MXCiENr8U4t6pYn9sKIA?=
 =?us-ascii?Q?1FE5y3iUrPujEF+EngaK0h2GN/zkm9ijgMvN1JGNjZKdlNLknVZF2aye7qQS?=
 =?us-ascii?Q?9EDTlBqXcPs1QuOnzrInI3F4F9iBrqja4mBFgQT/DsnIRLO3StN9wlwKs7xd?=
 =?us-ascii?Q?3yxQpxwQFrpKo28qr5xXXPsLpuqnJ9kjJtJ1VRRbVNQ21W/C90K5+AHf63uj?=
 =?us-ascii?Q?nMK6lObQBnVFMunWcyUj+/BAXJP4qBNTekuOdIzE7SNpq9RfpTjwrE8Mmpcp?=
 =?us-ascii?Q?qWbO7f7M5eNgUxF/H2PhGruBYg5j/BNGj0QL5s3sW0YJNde15hjrF/3Mhvu1?=
 =?us-ascii?Q?6rYxYMt0QOtKSIUmTCUj6nS7MhsG0s328K6XXLDt6J/Ug1TlhEKCN6BjjEvQ?=
 =?us-ascii?Q?zKfC4tm25XlpHnGMZusk8JC1maI5DXTnjew48UplN05V4vDtbu7bGON0wj5E?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b61cc8-bc44-43d2-30cd-08db1fdb8fb9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:46:47.4509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKsC2KXrh5NUz3NLYkyNAbg2cntCXM2rKrpO2IlmSRIZuAdS4B2H9M/qzmExOR2szlcFXAUffr0g5NJx+xW9pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 01:12:10PM +0000, Russell King (Oracle) wrote:
> So, what I would want to do is to move the decision about whether
> the PCS should enable in-band into the phylink core code instead
> of these random decisions being made in each PCS.
> 
> At that point, we can then make the decision about whether the
> ethtool autoneg bit should affect whether the PCS uses inband
> depending on whether the PCS is effectively the media facing
> entity, or whether there is a PHY attached - and if there is a PHY
> attached, ask the PHY whether it will be using in-band or not.
> 
> This also would give a way to ensure that all PCS adopt the same
> behaviour.
> 
> Does that sound a reasonable approach?
> 
> Strangely, I already have some patches along those lines in my
> net-queue branch. See:
> 
> net: phylink: add helpers for decoding mode
> net: use phylink_mode_*() helpers
> net: phylink: split PCS in-band from inband mode
> 
> It's nowhere near finished though, it was just an idea back in
> 2021 when the problem of getting rid of differing PCS behaviours
> was on my mind.

Having looked at those patches
(http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=a632167d226cf95d92cd887b2f1678e1539833b1)
and seen the way in which they are incomplete, could you sketch here how
do you see an actual pcs_validate() implementation making use of the new
"mode" argument?

I'd expect there to be some logic which changes the "mode", if the PCS
validation with the existing one fails... or?
