Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9B64EFB3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiLPQtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiLPQtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:49:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A01C41C;
        Fri, 16 Dec 2022 08:49:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcF6NgpXDkLyFg1zWw/6akXjdWB4Rjl28yGuw2ncmL2+ndrT9VaaJAGPFLkdznMMvEPHSCoecnek169KMSyITbnHgKLdpKYe6ntMVtG5v69Ze98gz6rdpDqxQRmcyOTD6u1jH8k+e2IByURWIXmnLIn456Aj84llVb2mn8bYr3vHh1bbRWmXhOOYrBAkoaiobtaH8bWe1M2z/OFCxsiZKzTQShPxkPN61A5XIRcrmzRXYwK+OHjRjvPS+d5ZRJT0CYYScriC37h7cLpciHqq1hE22oClN4XS9FNqZTw5VCL3TMZm0cqQZU/1rewQ7xntt64GSCxO8LBU7ORdE1JxwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mb1e/vz+BHOpR9WQ7C3TrJTYCJus8ihOHDFfoYXhAI=;
 b=brcTJKJEumCCqLahEMDB7ij9nTeLfzj0noNQpOTTH/zaCrp1AFB9NNSx3RrRHbDuaU5wfxUruZ7QOdpvueaZzsgn4opCk+SYLSVmSpLoXCcxz9B+3zAx765dLyLn3F/9kXrNOSH480eAQcRI0LX8bOhns/xyGWF36EuMEHM45Kcaa0a2Xr55sS+gS59cXFnD2Z5CvIGQMuFgY+XxCZXWUhcdSQAP3yMMqmsfHFLwFj3oeQqxOWeeE8Kggj4vlfOhbhd73YIkPlGwPY+3TBOLalIdElOUM3DfW77KrDi2tbXwzZ9oF44j3+Ybk0B5UjVo34NzpxfOUtGQtP4pwFfdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mb1e/vz+BHOpR9WQ7C3TrJTYCJus8ihOHDFfoYXhAI=;
 b=A8b9doeVwJ/zYUqhxV99QlKriNiSrj8Ubi7gqZRfAYeygbNYpKLTX1uqKiSD6lMoqCfF1iadH2Q5Y8XR9tJCtXwX3zO9Mq035L9JvfnvbCnf6BtI0x20OOd7VJy06hFVkXwBB9nwxWOCup6OKLCOY7fZ0CCPK8OSXyB9euBm8VHX3PtmX8aWYFDz5q2WHRNAB5kaOA/RRLyE3ttbGMaLZrH/i1XCaNlOSLrY01qD+PlCxLTe/RAMz6+Rh9EBO4H1uTlqk6C3mEC7bQN91Edduz8qbBy4GJeiACno4SQij4zHLTbURshGrTwyCud5sh29VE2gVIlBjsTWAsCODoD6YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB8010.eurprd03.prod.outlook.com (2603:10a6:20b:43d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:49:01 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:49:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 0/4] phy: aquantia: Determine rate adaptation support from registers
Date:   Fri, 16 Dec 2022 11:48:47 -0500
Message-Id: <20221216164851.2932043-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7c6d38-75ae-48fc-20bb-08dadf856ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1SlicjhlXMO1RAC4tsJH5vYR7VeQNxIEV81DSDaC/qAtA5qeCm4k1gQE6/mMR4vgEBEuo0dRwWEwXCWnkmB5pzF98xJ/ciVhOad0Ov1cCktSZncaMIR0dpuX71jHQ6Adg717zWb5WrKC0Usrn2wPHU3hHt4nJMnjmjF1JD/B5hg1W6vLwHBWauLhPRSjqcE7ZfhbPSe8ah+LtkM2ptGQNYOYTfmXoaEBPIVobVzu7ci2Mn30MpQraitfkAEKZ5AxPRvgbwy2DtUtME74p7ymCBEhTAobFND5H9t86Nhx780rNXwTuUgy4PyDq4NFeGmQ/a2b3n1PUPGzPvnE1RJB6m+ndOYbjZCYAB8S+WLnJ3LUYCrSpDuY+0EUtN7L+1S0n6ohcbuvbKiYBr3WdtrP2TbguO/2tmcSQRR0hSJXe6lYByGKPblxl8yUya8IpZD6poHTZ3vJaC8GtUUo+X8qcdiK0ds/ddCdugdkqMmaDuaG3RiVr9Du8/QthHkwbatSCXz4rsgd9fsSPas5VwSw5CFD+o5n+8fHupq/FUQUPid/bCL6GBZl/nyCg9m4DDDWvKWd0yvColur38u4ax0IH5skK/QiRiWIofdVp9shy16Oy79fwYYaKv7OtNXzCVHhwTis4U7MslvlwF40ODWXU/EzBfznIY08Pz/EIqI9v3POBxNzAj7aAdXmibtMVwHmWBJeFX2v7gpp04E5dpL+etBq27mR+XHkcHJMZIPnJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39850400004)(451199015)(2616005)(1076003)(86362001)(83380400001)(36756003)(38350700002)(44832011)(38100700002)(316002)(41300700001)(2906002)(8936002)(66476007)(66556008)(66946007)(4326008)(5660300002)(8676002)(7416002)(186003)(52116002)(478600001)(107886003)(26005)(6486002)(6512007)(54906003)(6506007)(6666004)(966005)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5VoSnTqtnyzXjNu4S14W6PhzYL1+U+D/+mjGvHQTNunkJ8eUYyZk23etHl8S?=
 =?us-ascii?Q?D5VOvYXU0qtsVP9Bz7HWIwj7Pb90f/cr9k05RRdGRjlvTwAt2fK7/lI3OtCq?=
 =?us-ascii?Q?eUtptA+OC3cS2WdEReAscOMs9pgFY2ZzY6ZMDTF5m35bfT4DgBtpXKO1ljzn?=
 =?us-ascii?Q?ATOG4//Opb6EfkkQ9YFOd+owBYo80THaeY0iL+IT1Zunw71YQDIozC3ib4Ef?=
 =?us-ascii?Q?AC8T+QkeHIKMM+g2dCbxAxa1PfF+vlUD4GLh8LroC0kS5bCv9hatmjh0HBBy?=
 =?us-ascii?Q?gg3NJ9I6WfhlIoUWZv3gDCtDF0MsKXYx939nJN02cNWyF1bBAiSsC03fNwhZ?=
 =?us-ascii?Q?SG5SW7BSTpLx9pVgZxP0fEpnxPUJsvqQ0oOXj6paf9TpsHfGNaZxuUFtAltf?=
 =?us-ascii?Q?ymAeWG+oW6Ra8XHw2rB5kstI97k3sVXKNmu1jYv5M0RE8WvzP+Hx/1UDG4EM?=
 =?us-ascii?Q?EYDS23zOugm0ghy+7EiynTqvRar7ulvxeH1wW3yGKyzLPV9qiXT9zTfT4O/t?=
 =?us-ascii?Q?/f59UiAHO8MCFGEKfSRcC3FCLgBuESPKRJtbx7jK07Gwfloc5htjcrA2rMy1?=
 =?us-ascii?Q?hvKlX0+lrYvJcQNQY1FVBkDrcZHnH7HQU3hkEJugZnHJ1j11L+3WodsA6DWO?=
 =?us-ascii?Q?LNwA4qIXRAteOpr4eE9UC7rfBVr65mSjePhpujlq2o7gqNKg6Jqb9El2MKg/?=
 =?us-ascii?Q?eWlgmmD5ozAmKNq9ENX52qicecU6Al3EhNF92O6d2haFuC5yHkWDX6LsD1Lk?=
 =?us-ascii?Q?FvrPv7Py2cBtRM369qNNcydp5vRdkT7i4xAywxN6mQ6F8pClmaEO0ZTNkT7O?=
 =?us-ascii?Q?n0TnmBW4utHmKoeYwjN8YtLf8fPcwVM4OBROK5WIJj2oLaQ3/xJBLMoOFde5?=
 =?us-ascii?Q?ipuT+8zuKYfuYLg8ELE590xXZXyfL1f0A/03iXpyZ/5+X50P5h5xrUjygFSJ?=
 =?us-ascii?Q?xsRuLVrUiR6gLPBhplHBlCnTIMq08CArELl5CiU+4mZ7n28BUgC+T3+f2qSu?=
 =?us-ascii?Q?dO8sGpeDgQCHfdq1eF1X49xXeIeKBgz5Shwj/ufleur4Hk3LY6TdLgodsLN/?=
 =?us-ascii?Q?LHXhimjFKSOQPbruf+vZe27/Xw5ebPqOtTPLvwqtyxaBSvIEncPzJptYy51p?=
 =?us-ascii?Q?MNpXybI0sq/wgMBi5wZYEtJbm2yXB7+Ft2UL8NZK5K3KY0pBmCj6afxYFwX6?=
 =?us-ascii?Q?wAx69qF4u6skNQy0CrDuCkd6nNWgapp7dzfzUy5+pbZavbg91xpdo79C+dU7?=
 =?us-ascii?Q?pVdvfakEHSDEnbzFN+SkQ8Nd9NuUy74Vj8+HDHkMai8pL5OhqrYdo5aonpJN?=
 =?us-ascii?Q?IYy0RDBgEfrLqybe9AslecUn6wiYGvh4wDeyTFZomLOBsSdydSRgy6aHBK2s?=
 =?us-ascii?Q?uoX5tG1HWBEv4b/4447vPaRM3ZzPml8BJvGZwwoKCfgXI/8dVToQZd4IeLzt?=
 =?us-ascii?Q?xAwyGihBFnKQq9N7OkNs7uHAuPyu0rcze4ElS85CSyBseQsBtUgWlcNwYbN4?=
 =?us-ascii?Q?vM+iGsaM/UKf8R2IKe02q9XVIUtHB8iN+uH2ZbL1/+j3cbNs6R6dYs3JPnuM?=
 =?us-ascii?Q?ewIHT5viMcZStDebpoqJK4UPbBaSSbE+4dypp2G8YOqFUB63R0sTmiY2xIVP?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7c6d38-75ae-48fc-20bb-08dadf856ee5
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:49:01.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Utphqaw1pzzIO2ROs5srVC+U0Wm0KTljd+B2wMQMM88NxBf6nu0078cnhDw/5M3USfEbSYVpqFnPqC2i6EAC+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

 drivers/net/phy/aquantia_main.c | 160 ++++++++++++++++++++++++++++++--
 drivers/net/phy/phy-core.c      |  70 ++++++++++++++
 drivers/net/phy/phylink.c       |  75 +--------------
 include/linux/phy.h             |   1 +
 include/uapi/linux/mdio.h       | 109 ++++++++++++++--------
 5 files changed, 299 insertions(+), 116 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

