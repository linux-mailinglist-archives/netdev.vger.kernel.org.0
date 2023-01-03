Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7765C91C
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjACWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjACWFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:05:38 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2086.outbound.protection.outlook.com [40.107.104.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E818A10046;
        Tue,  3 Jan 2023 14:05:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtWL8UNS9Qf47NrmTTfo+VUaiwQOdrNGOopIrbRLnRm6NfwLPhDruqMddVFDQPiIUj0+Pz44jnKMvjI5zw4DKjUOpfBEo0HG7sBzfoqy92Xxjv6oJhuSLoPzRx/jvHLkJYHi4QEDzDJ0tJA1ZRwFh6LY6glQhrd462TZQi3kLdOfdo6TR885rdDhjSh3j/wWgHPT0WXoydrOtlVWeREkPo3BK/7xyidQhYxbHu66HAN0ho3/3NEPFqasio1905P+UcDsyXpSIcfqIGSJJoLTUHtuZWWPDr9s/7GlgUv5ZroHYQCXwQ6JmvnLhB1YJoEdph8qIhtxg2MgT7Vj0vNm/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnqUiPEiZ++ZHzbsO/JC4s/mGBZzAX19CC7VGX2cf3I=;
 b=IH8pxwx6GcoU1Rv02Hwlr1twNzT6yowjLlEnZs1d53oVQi1AWicWLIcWXQsTkdyuq7oKP/i1zPN8JaLpXhrEv/x8hSfZc8i1tncEpnd0NB0kR2jJ48VKRV8XI9G1hQX7OjIvGSV1kb8rGU8EvBh5ykGM6Zb5QVY0NWEXrSrhFCDzNRMsebKz2JKC2HqlEPdqXzVzloFSlpx1lMWNxwLdmXqbAku+4sMBT1XNVxHO/+5OZ79VZe8WjhwRNayUfFRItnsb3yr85PAZJn83dB3L60OtydYMKoipCamhY3/QmOpY7CkRda4GYvlWck7B/O5Xt08UUd9oJ1kfPDHSC4vUHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnqUiPEiZ++ZHzbsO/JC4s/mGBZzAX19CC7VGX2cf3I=;
 b=TdxmlSxb6Dn4XMFQsbo+aMWqeR7FOF1/z5vj3SlW3IJH06+Wn0y/pXIucawS5NimX8oMfbSmxf+zGfZg70ieiuLo/afnduUuseyrnEhcyFpMmmU99mRfbV2x6rVRUA8BnZP24hz6hL0i7NDXXpPH0pYptfnA07yIqVMy2KLb1Uy7EUh1UGpXTon33ZuoWLMVWkF9QujwwN9MeG3QZ9zTl8OOIQ9x/Y9jynVS+Fhamuv+qVJDzz3CIufcqAfXiZN1IFZRFI7hBBxWu7VH2Fss2aDMJZ1hWr4HX/ZbMwR2NTa0R4uVfBazWUmFYtx6kIocc3OpJtt6kPu+hxaoPMVLUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB9900.eurprd03.prod.outlook.com (2603:10a6:800:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 22:05:34 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:05:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 0/4] phy: aquantia: Determine rate adaptation support from registers
Date:   Tue,  3 Jan 2023 17:05:07 -0500
Message-Id: <20230103220511.3378316-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b8f750-83d0-43a6-eb5a-08daedd6a343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXz3BykpSC648vZI2YmDeqwMGTk///IYe+jHYs3anGedicTH7LDNpd+RU2zbkOfd2ylPdo3zxtbUm4AbrT/q02GpsVaq17lFtIsXd2shs0fzG0cBSxLQ2dXG70ZZCUt+IB4uY8QMPapBGdNwwjTqX2k882UwbKiMWQvxPnC7aa7q8W+ygujeE0r5MbEFZ3JwmJKMjiey8cT6zxPuv3OyvBHORvt/3OXXGskMjsHlKeDzy1cM64nm2YcR5zwWtVfyIHb3fA3Bnq4TpF2cC/NOmU+M4fuDAZWRBdsaM5bFxihDMlvZgYj+n+tQVZdquX7Hm5c0Njk7Z+e8uvcBPF+wYXa4i0dl/ZQz++zC1G5YQUQqxwineAquLZGAcNmisr4tK++jXvzV5uf85KLtySRMYX7Xs0affi2LYqV/kPDUMKYSxvpWE5qHShjKTq1CrqOvqNmbY95Fgs1f//RgpaxZcNCZe0dEu2H+Ag/+VLAZfcF1Q1VkrPbeg9RuHMtUdXiVyvEstFSMkraAEKj0KZijodfr0nw0o9e2voOBVC1wIKtrn8Z+L6s4p5sU0rEXrBsXjstp2npxDSTmWnUfjPkgD0iMDDNhtnlsLGV9CGtGKnD4F+W+X2NRLMivVc2PyDo0jhUosoIIM9zSo//u8knHN5nwZP5AcraihlwlPGJBqmGttnFW+tUQ/LpAb/eKxakpfjX6h59kHcC/jUv87AYaUPKWn6G0aFyzejmS3kOhi2hQSQ0jD3U6gky2OpkC8/Rc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199015)(110136005)(54906003)(26005)(186003)(52116002)(107886003)(6666004)(1076003)(2616005)(66476007)(6486002)(66556008)(66946007)(966005)(6512007)(478600001)(4326008)(83380400001)(8936002)(8676002)(5660300002)(7416002)(41300700001)(44832011)(2906002)(316002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E54oRqwDxZ08JGACYTDzTBXOrlR9n8p2fKWThJkQ5nK9kpIdAnEcd0UiuKyG?=
 =?us-ascii?Q?RDCnrck9TDeYZ9DxF+je9saHqtB35WM2lzxkTURbTpAPTc2NN9bN0n1YLD3D?=
 =?us-ascii?Q?3vXtwT1MvC5vyZ54bIH0qKwsWXXZViJFgnXdH5sSPsnocCH/gyGdJtNth/UA?=
 =?us-ascii?Q?fDTz1LXUAVI+Ggvbvd3h97C9xpspq7OVK4UuGTd5F37hRVCqJKUntKNVhMGD?=
 =?us-ascii?Q?Usl5orsnaGnjUT//75sCOFBjHS+LXT35aZhxx7Tz1YD2o26OVwywhG0Ij9HL?=
 =?us-ascii?Q?5LGTot+ERRCxShK0Q1cC4sxrujUfRnmGtP2k31+DCn0WEBiVEXY7Fk5Qzvju?=
 =?us-ascii?Q?z/9GwYCXhFrukLdJJMGtai8YxKhy2TQW3Y81Hwv6ESt3wY62h0R0x6dSvuzY?=
 =?us-ascii?Q?Y9FdrHEHaZ/PEmWUUtjQtBNuo5JtXdKBOZUMCGQq1kml1CrbHYxx7LdKgegO?=
 =?us-ascii?Q?PzBNfXcYSNAnHCFbk8YzZyqspVY4WccoKHeWdPWrtER3LEtKLgYBfP988qUR?=
 =?us-ascii?Q?S/jqxBMhyS46LoNgDrDVPvw8lW1t1oqQ7K4NeP8kz/auwfob87TW1xBVJgac?=
 =?us-ascii?Q?FbtitcJhidaVFrO8jmykoxwgZNaeqLkxVaFDtchjwBBI9pWI5VbK8XDtnSgj?=
 =?us-ascii?Q?eA2nXK558heDr18E7XuLoGMrkqPp8pLkoZmlNKQXCyFwyLvzbEsGX9woYnMi?=
 =?us-ascii?Q?8JuDvY/4XMJLqKxr2VRzXOo5bwic5Nhyp0eNNXAikeRflR2JigNEptCIbf7J?=
 =?us-ascii?Q?dRIMelOyrYKwjOetw2C6Ki60wGsjFk+ZS+di6NcPsxJs9qe+9EbX4b00N56l?=
 =?us-ascii?Q?Hwp1ggjPcOx9fIcMlU7uGAWzILacVz3Mh43wCDgb03txNqUR3Awf8I+YsTlG?=
 =?us-ascii?Q?u0qqqKwZHh76dy/7d4X078w3p/GV3mibijqBCV1aLxOdMWcTGgJwA0zl6dIQ?=
 =?us-ascii?Q?x4W3Iz5Hiqae02E6VA+kGYYUGPzC7dFnQMNl+Q1NgK+JoT6Ul2/DwPJCoooD?=
 =?us-ascii?Q?HD20vq567aw1vQV0tLGrwiWEgahCIDnvnT5NWRTsE58I8TV0078brMOhLYKS?=
 =?us-ascii?Q?GbnKgA1qUtAltfGv/1NboUZ6utb1BbwxJ46ZCU8s6Akq+bQ/4ZjLnzzCssy8?=
 =?us-ascii?Q?zd7b4r06nYcuN6L0ki/Qmu2gikRXjTCHXu4QbDtmT3+kZUGbT7LkuINcVV4U?=
 =?us-ascii?Q?n9+I3MvSa8OGj6UaLHM7mBkMpy62U5/Ta1rGStPLsNDNXmXjgbxGi11gxcGl?=
 =?us-ascii?Q?IW5M7ZulTShpWnQHP/Hnb2iohhBUUyLmtrCR02zsVCZrqIh7xeJaHhAhK6Ke?=
 =?us-ascii?Q?wubPQqYGeYutpW83Ni18gmjocVoiul1O5u52Czf0Clq0s2isD4dGyDmbZXFu?=
 =?us-ascii?Q?2ov9Zmm9zevP5gbPp0Gn/i45v3sfqA5svcYz/wVbGKg3exd2tTBEqfxHgyRR?=
 =?us-ascii?Q?2qNIx6xwyijuUuZ7hj9RVFSlZ1oY17UIfrpZpeibn3blTUkwUbp03D6s9cf6?=
 =?us-ascii?Q?ldjKRLtqxBEHEQg0Ikl4o9whvMsI5MLbHwP2bR0ffAD9iLo2Q/BhGeNPkW4L?=
 =?us-ascii?Q?GIn5OZAzh9b9Qr/02KfUpv1RtCczXapMXavgtfcf//9vshCPwXGcrc/jDzQQ?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b8f750-83d0-43a6-eb5a-08daedd6a343
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:05:34.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAnl7yACZY/9Yim8eWh4WdD8lx0kQ5I/MK4XF9MKPPCFwMUBGD8+tTd8OYjsBUnNHYBEuJxayXysyj+I4HqY7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB9900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This attempts to address the problems first reported in [1]. Tim has an
Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
10GBASE-R) when rate adapting lower speeds. This results in us
advertising that we support lower speeds and then failing to bring the
link up. To avoid this, determine whether to enable rate adaptation
based on what's programmed by the firmware. This is "the worst choice"
[2], but we can't really do better until we have more insight into
what the firmware is doing. At the very least, we can prevent bad
firmware from causing us to advertise the wrong modes.

Past submissions may be found at [3, 4].

[1] https://lore.kernel.org/netdev/CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com/
[2] https://lore.kernel.org/netdev/20221118171643.vu6uxbnmog4sna65@skbuf/
[3] https://lore.kernel.org/netdev/20221114210740.3332937-1-sean.anderson@seco.com/
[4] https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/

Changes in v5:
- Add missing PMA/PMD speed bits
- Don't handle PHY_INTERFACE_MODE_NA, and simplify logic

Changes in v4:
- Reorganize MDIO defines
- Fix kerneldoc using - instead of : for parameters

Changes in v3:
- Update speed register bits
- Fix incorrect bits for PMA/PMD speed

Changes in v2:
- Move/rename phylink_interface_max_speed
- Rework to just validate things instead of modifying registers

Sean Anderson (4):
  net: phy: Move/rename phylink_interface_max_speed
  phy: mdio: Reorganize defines
  net: mdio: Update speed register bits
  phy: aquantia: Determine rate adaptation support from registers

 drivers/net/phy/aquantia_main.c | 136 ++++++++++++++++++++++++++++++--
 drivers/net/phy/phy-core.c      |  70 ++++++++++++++++
 drivers/net/phy/phylink.c       |  75 +-----------------
 include/linux/phy.h             |   1 +
 include/uapi/linux/mdio.h       | 118 ++++++++++++++++++---------
 5 files changed, 282 insertions(+), 118 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

