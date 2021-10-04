Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9428A421974
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhJDVwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:52:20 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:39557
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhJDVwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 17:52:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEL3R0ay9CmHYBep4e5DLBmzJnjwytC3BDGeg72Gw0yQoTerGkQ7OpGUvnMnmaQ5MIvfd4ak1B7tY8+JIbQJtP2XMh31Cstz5s3yO+arC9bVhSMsc8WQVYuBObHBy2Rtw5KY5hPXJzVkVnFxCyT+Gzw1q46nnMhOUo5KNTluE0VawGVbNHq55+YILewHs0IhvlteiSx8Tb3FxHnQ/yQ0CeoNbQMAzCpMqeogxWsgPkANjzYoPAAV1tIthu12rF+A6Bqb8FGgpn3XUUcTArKUMqWELg9NgQJe8eX4lYoYKkML366DS+kXOxp+aBkhqUFOJ/59f5yjuvfX0P+oJoRtww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mxsf7ryfNRgKipgUBTsTB1H0rHbBbNQhLarQvGr/QZ0=;
 b=YIkTuGCvKjkHJWVRs8ReCpJtWpTIoJCKHGzobJ6BqSEFgfyfIQc2xV3uoQj3Is8SRGG+Wv1DyIazSeFS2E9lUAjtXjQDCWBs3HXLz/Eod1xDpvrtW83+FO9p0aFaGasS1HimLldFDid2UJXVKwUhIG2idqMgolCKHUEUIPA2mGC5Hf6kTcayScCtShbtNfpwRYneaFmD6j25rBHgXekZ0AD9YyqrQ+pyyFR087+MHAiOStcvbnK3+I/rV704SMLo5lT/YaCUBOHGNRxH8oXqtjdyKfo1mB7+u0PBOSwj0E4wL8RElDBHRWzCLHrxH74N6A1lST78TxWIlfI01OPO6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mxsf7ryfNRgKipgUBTsTB1H0rHbBbNQhLarQvGr/QZ0=;
 b=jutWCBp2u11IZi0/ll6sKUE8AS3O7RI4fi+PxG4QdpwHVNgn4yhgyhwm7Tkqrw9wKWmIS3UIPsyAKIEN5cT5XtUijd+Rq0LdU/8qVckLm2TNtoONUUlYjipz72GIM4iMafH9Lg8CvLF//FZ5mYtn3UBkukcwKHriUfKGYqqyqW0=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5577.eurprd03.prod.outlook.com (2603:10a6:10:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Mon, 4 Oct
 2021 21:50:27 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 21:50:27 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net PATCH] net: sfp: Fix typo in state machine debug string
Date:   Mon,  4 Oct 2021 17:50:02 -0400
Message-Id: <20211004215002.1647148-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0440.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::25) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0440.namprd13.prod.outlook.com (2603:10b6:208:2c3::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Mon, 4 Oct 2021 21:50:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0049523e-ef36-4694-2f00-08d98780f9cc
X-MS-TrafficTypeDiagnostic: DB8PR03MB5577:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR03MB557784869C517BCC3012196C96AE9@DB8PR03MB5577.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sgpf1NFnQVX58cWm5wcFT69NhjFZNUv6Z8RJMupTM2yfm3m3X8DYWgv5lGdopSivkNjyY1uhxidlfnCVMP0DUWIlkwkHN326ltkOD76IFSKTfYRxXKyIrUPRNFORzkhepM4hCNgjZUd0MHG2LBVood9XpQ2W4p0c6yNN6sZnDKDk6wW3qoKjD92BLcbdm2CaJ79mMvrpMgn204jPant/dkV5ExMnJXqGSON0VaumvQaIv6xfcGa/X2cs6F0BVhtO/LkICQSNlzceRVi0q1Cf6opiSj0GqYNjAuA4e9RYowo+a2NMEP+Np7U9a3OMx4vOHA+CAxWYDepUcvXlKNPKIIX3ObaobPyUxlf+k1mgGHagpUy8zhPRrWOXrg55E0ddbiEEIY0k8EaNFkXeNXNuazamFjeepmdd8GCakUBYKNWegiKONPMuNK5v7Uai8K7lSxWQ3rzFTLRQF2pNOpSlYQetdkESE89UhAnJmrz3mrH7SPU6eCg5MbxDF6qoa6LJXMbdkWruh02ezlrTLgsTWFz2tJ1iCMmGu7jnVPmMWhkAJcXu3YPuq9wVELi7wxgXSHlDVEbLcbjWlfQm3/LQed6OdzN2SRLgl7td7QZyEkKPACMwIHvyyumXSM7mRmVFjZ4IKUkAFx9I/iNENHfBNTWw0g7uJgun7nZRrG4eVVAstDQWSx08BNlOUgPZ0rjFMM0PbdiQOz0GamHpLLoWHYONxfGm3baLojPmW8oxKcXPuiquNQbFf2lL2pJzjGro4ly942yA+tzXMIdfdL5rbbLc4rWghgdUTJ3uUzFphmQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(5660300002)(6506007)(26005)(8936002)(66946007)(38100700002)(1076003)(66476007)(52116002)(66556008)(186003)(6512007)(54906003)(508600001)(4326008)(2616005)(956004)(36756003)(6666004)(86362001)(44832011)(966005)(4744005)(8676002)(2906002)(316002)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DWd6f1j1LCVhE749wP2Rajs9ma6E461Siejx4/ZIEh6St8mSTsidbZDO1rHH?=
 =?us-ascii?Q?Yl0hW+aJddaQBalsArnahONQXav91k/zVWgLJUpt0pohiD51vE/90LFRXswz?=
 =?us-ascii?Q?NdGCeKxkXkHdTfBwIyjKvec6uK82AF3TJZrTtQspup7GeUVT05K3y8HvV1OP?=
 =?us-ascii?Q?NBWCg8blAclLJ9BYrziZ6GDVNwFZltX0AimAHKNSNP/G1wDFOv/+l8G50AoP?=
 =?us-ascii?Q?DTtB3Okh1yGnCRRx+ZMoy6PTOQqgXPWMIMKqHehy2Dw5s5HuPuj879VYhhfn?=
 =?us-ascii?Q?NJWcY5hzHngy/wxaVGmzDcuMP8dcvFyAPh2dxw165a/MA2OaQiQfkwguDTrX?=
 =?us-ascii?Q?+1R4iy/rGnwHCMaqQ3vorXTuR3kDOtu8bTHfP8zX9/0WsDTyu3u9cDmIAu6+?=
 =?us-ascii?Q?QjCoY19mwmQkif1s/QNDYXJnvW/pw8wnlmt5qimTezI+/4Moa+MH3wxdUkPb?=
 =?us-ascii?Q?8OHgr8wd9B/fmOFpaU5H7/3T8d8uQGVc/SF0QbdfwVaV3sdxxICSpGg4kEGg?=
 =?us-ascii?Q?Fx4WdlqQVp7XKG3cFk7R6GvADQuFOrF3hepqwbOEtvsS9IGhOT4jUwNH9o6i?=
 =?us-ascii?Q?gcnh4BT3upRiBUYUmhD+muKRpGiFFCYsFKTJ8dVxtTvWsDWB6WXRoxxy7A2+?=
 =?us-ascii?Q?lE8f7Lok+gCOZpEwuMZj/5vnuclfDosIkRrlE6wV36cH3edONfYC+Rn4YjxN?=
 =?us-ascii?Q?7JKhwxKftYatBtJa39sUOKtOngbJwJ+GhoerGcMl+A5Yc5l4qUw8bQRnnWM5?=
 =?us-ascii?Q?M5zWF1eWGYc0owThsGOhOnvJeDIk8GjrCkRhwtEzjITmEqatnCXn3AH3xSrG?=
 =?us-ascii?Q?ODLenEaEL5JEe7rdjVvGUDsAEv3Thl+s1OZ4PuxcrhwCDXGMWsms0Eo6ozjo?=
 =?us-ascii?Q?VvQ+sMEKFlfuVWgc2WFtk4++/gEXFEQMKTV40VpmpwSzTmjyiA56DGiBDBvu?=
 =?us-ascii?Q?KvJXsO9kH5Ta/RfJzI0rzBTd7q+U8PC2/SvFmTei4GiVRpLRliGEBt9giuvE?=
 =?us-ascii?Q?yDtgnYFNt9HluoMnLG7DCpc44tbpseSukW2HOhNUZjXk6b0cf99efhUTRfSG?=
 =?us-ascii?Q?rK7d5d8hby7Rvbe0bu3eZ8KJ3YlEC80WlWD08XpccHAyNr+YQQBAyXEg0tYz?=
 =?us-ascii?Q?OVVfL/rM9y/1ycPa3malicHrrj2UyhUH+B69y1YXLEeJ/Ed54oYbKPLN1MwV?=
 =?us-ascii?Q?iKnqAZ4l2ZUAseAZcODk4+8uuqJ3m6+IRszwuNjKWMtplCOGmyox6CZ9agLH?=
 =?us-ascii?Q?ezxFLir8R9lKhlW9DGohf5hzuE3gQJlXtuNXjQ7TewpbW+fzHn07VQCkesh7?=
 =?us-ascii?Q?S3gkdmHZI1YcmlA6JTCm6YDm?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0049523e-ef36-4694-2f00-08d98780f9cc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 21:50:26.9651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBXu8t0Qs9erogCgydBMfcZBIcmysDiLvqkKXQ1mCpeptKOWfYHhlY6+HhZQng0Fn3awVQjKP4eQMh1puuPi/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The string should be "tx_disable" to match the state enum.

Fixes: 4005a7cb4f55 ("net: phy: sftp: print debug message with text, not numbers")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
This was first submitted as [1], but has been submitted separately, per
request.

[1] https://lore.kernel.org/netdev/YVtypfZJfivfDnu7@lunn.ch/T/#m0b62cbe7804eb8df8dc69944ec3824274ae1b0c1

 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34e90216bd2c..ab77a9f439ef 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -134,7 +134,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
 	[SFP_S_REINIT] = "reinit",
-	[SFP_S_TX_DISABLE] = "rx_disable",
+	[SFP_S_TX_DISABLE] = "tx_disable",
 };
 
 static const char *sm_state_to_str(unsigned short sm_state)
-- 
2.25.1

