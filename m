Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C643EBFE2
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhHNCu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:50:58 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:65089
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236562AbhHNCuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6d+tuhvQUs5y2D7EnZ0Heh5ZuceFl2j8jgwCJ5iEJkbnP64PeFXUX1pooDl944a/0d08SC8MyjUW5R2DszKiYjPlJyo+OfbOz9aATXpK3jZgYOOWf8E/pc5oYITgaxKhBOwkUdWF0xj89CsZLYCBsl2uvuUlOBp4B3iuPylPvn/kHEB2BsiwzSfjQYkvHh8jU+k7FNqc/41WaUjLv8fO2hXpA9UUGFa1iXbHbqTpmutmY72+ILGQaGId336HtmVa6ORbWNZtf6RHBiDBw1ab3ojD7G7/8htqOr6pKsJQrZ6kqVIY4e40/ilRyXT3Roxjge9rPWFRDbi4OLcj4lIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiSbwUAFI4oRksMWMywyVIYPBIPT9zbCn5sqw74EWAQ=;
 b=jtf3vWGOyfbymWppNtD0ZgXDpu99m7Js1Cys3gaeQ8xW+y4vu7mBLJKs73gcesqZGERQsYhXKmxOHQ9P8lX7L2afxI1wg0t8hNrsALPVUPKK4PxDPqe5JXK+5Zq2yrRLhkDvXsW4ASbrizfQKWsOCju6XZVdC3bjDrQElwyXnCu5hBg9ntzqBxeGWmAf+GrYfIXZdUURBclm1FgR8xlnHS5kyRI+dGg2Meg89QfIf3y6Bhn+eS9VjoF0twPDoSJeKTFQ8BMAIHCS8D+f9SzufQEat15c6aARxjkkWi0+OnBo/GUuTo9w3oSlOiMg4k/PzCqoFMv/gpg9XCcMeMDG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiSbwUAFI4oRksMWMywyVIYPBIPT9zbCn5sqw74EWAQ=;
 b=RTFEb8e9dbKkI3gpdSVodRmD5TRGl/XKYR8zsXoSYn9z4Jo3FfZ9Xc6zbjUS2SbLgoWG9Sky7q4qDmk+oFQW8lmrr9FK+iGBMHOMDdaiIakJaOFabSeNhP1e9dcoXqICgL/5KUHgxxobOSVUhVtm1UfEpwIXwRlqxXMVg8pVgxY=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 04/10] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Fri, 13 Aug 2021 19:49:57 -0700
Message-Id: <20210814025003.2449143-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a012fac0-e8a5-4d7b-f83c-08d95ece3fed
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB20302FF397D11CA51F089DD7A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4poMkRthp0E0h46nUsAryT6uS65fnZhrdJRQ5B9dicyrToH2BtdV/o1ymMzy96EFnfTAxXq7QZxHgftMbTjzXaIsVh8AcfWTRn49xEY52Ywrw/2+tLl/iHg2vqrX7jdGWp3+9iXFWKZPA2OgpknaQZsONj8fdGcy9J2PPsOBKZDgjd6rsp+QYpDgKMS68it+Xjz3avNxbi6dvhV5Yh/dBRpMhd/gxJSyDb7pGh/4PCZH/EvBofVMVxRYjJfUXojAwDwZsdCY0RthHusAS75wGVNkk4dG16uL+Fyaam7Gr14vP6qBwsvEUpJ8Y7TqqLG+IguE8H7p5O5mw8QdkeI8ilnB7egZ5jekhPY7KZSdVkJRIrvQpZ4phBYaRDpNjZE7bBB5sfGrY3tJq0iHm27cd4JFoyUyEl3t4zLmOtzsh32xHnvSn542/W9+AdLdkaVMp1u4OY7oCsIhxgcAyzJ/3ELbfAMdR6cSM8YkDKmcHiHBZ4gfHkE4C1jD4JWObe3AocQ4VGiIrEBvKUV5ETJqiXfzJ89wv71SwHLCXkpn2NJdnu5wC7HPVgVRlRcxaClJk7HhG3jZCeLkTdT0mCgWXQf9Twj908zKQEXY22llIQLAYjXXdnD6aX2cGWyOdr3O3bq2gg/PzmVUUbHGGzZ8XkfcfJKjAzjAigE1hc+b8nurmLp5aJjk3I+yEDsAW1b07y+XgTPLGJBTGX20cKHVQHH/g4jIT0xZPVStqDDfy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(4744005)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOcbCxoxcjKcY4wcwCrXEGLNCDAyuh6jpTmEFinlVfDdRNYi/5NSvf1u/zM/?=
 =?us-ascii?Q?posbO/MWAgIkrh6pZs5JOwTR4UCKgUvyZVtYvU/wwrBVPkVNvWa7eAkCM5F9?=
 =?us-ascii?Q?kF6oxtyjSrmZpPmvZCrx52nJFihV7hJaCwUJ9DQ+qmcZc+RdufrxVQoIc2/T?=
 =?us-ascii?Q?ofiV4J7nTeqRoXM2sTP+70gMtL+NBlwnatJ3XW4H9m2OWxivU/SAWWWbPsoa?=
 =?us-ascii?Q?O5BMCYztmWbCyrssDOZAF13PIQw3yQKBcVkcxKKDw+BLbSYDp1rpoBwFAMfD?=
 =?us-ascii?Q?LtvlCV576gtT8SrQzWJAkc+SnEFthFsFLMl/etYOQobOukXKjd7znxYKHb9e?=
 =?us-ascii?Q?PSbIoRM/teIXJehls8SuwDDMWwVNI/xGJTmmea54o7CT00dDLhcTO/2uLYjz?=
 =?us-ascii?Q?oMLVtC8RXlrPgjES11TyL1KrAHEmRZRUSMmS6fI/fRk8thCpRfVhkhpALPx4?=
 =?us-ascii?Q?QEScmq0kvAiqoPpqWrN2hFtCHNUcVvRV1Dyr8ZKoSR42I2C0QRXJs/iZsC0b?=
 =?us-ascii?Q?SUO77mWloJ/ibpXxzfgSft7X+6JiFLO22pZhaH8tx0Zz+9uts0ZVgi2aYDLr?=
 =?us-ascii?Q?0ang8/ENdbg52Y/KzfDmSSTME8TV5+E6kEKMiR16KjHC8dsCoOMF0H4mT79B?=
 =?us-ascii?Q?oHgOO3FG7OewtMFjGpb85ebjh+xp8rfz9FNOoMyzf1MAjLGdA+DdcLEp2iGA?=
 =?us-ascii?Q?pI9+ydQetq3Jva062t8f/jePGK60rFAAf6FEc+0qB4gWF99o9zUsLeYPwMSa?=
 =?us-ascii?Q?X1yI9qcWFhXvMnuz3mf65oBVaPYKsuMQR1/Rn1Ou3sb6bZUhiWeZy+HAF7+a?=
 =?us-ascii?Q?49xMIycK1pJDyVNH8OiTn6f7EI1YqrwN79XCNFhfNOrRzGpVEpAXSySYmwa1?=
 =?us-ascii?Q?ucTLpLBQeC7w96NwtLzsfcHrukG068GeViR78xq1sYFWm4RvrLtSjzrZGpfs?=
 =?us-ascii?Q?Cw2mNTWox9h08suXd6gEuIbsf7A8fV1VGgKS9Pizr7wQ4Q44mDWX2qk9zrVz?=
 =?us-ascii?Q?bD++aQh/zVVFdHL6ZLN2tg/z4Ea+Fc9XoxDcVnIH3E9EL2nXj2ggm0yTZhJE?=
 =?us-ascii?Q?hQIRYoMySeCh3XUHjgmoIOirMvPC+epp2sq6+/O4T5uqUPdnNiMwvTIA3Sue?=
 =?us-ascii?Q?r8JVl/nhbzA5/wFRgi0ogu7rLgKM9Wn1VKhM4xUFdt7+auI17r1niRea/wVV?=
 =?us-ascii?Q?aSKXHvVL1q8ZWpIERyqgJ7km8AsLD/b3qRL+328WcfY0gdRq68MvatG7ZCAp?=
 =?us-ascii?Q?7NbXxBjuTogiVtkZ2mWiAroNCspDpDkr6QCPVlBcq6hpSfjARgEKh4AjEwp7?=
 =?us-ascii?Q?2FXH2OY14zfyj/kBpUuTRnKE?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a012fac0-e8a5-4d7b-f83c-08d95ece3fed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:18.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72xN17mfP/7jHXkiLMLbMeN39nB9id01Xxd9MfDIkqUFiEaF6cvwp+cqSVIpSl5GrqbHczsEGIPTv8BSluQyR3MNgEdGkcpfOIAa2+hF8+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ce607fbaaa3a..74ae322b2126 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -852,7 +852,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

