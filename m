Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2544C690423
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBIJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBIJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:50:18 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2087.outbound.protection.outlook.com [40.107.241.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAEF34C11;
        Thu,  9 Feb 2023 01:50:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8MrloSrA14djWORZwbqyZsIRYAK2N9KLtDi96bgYs4OCe+7hv4vRGxt+GNl/tT3Bvuv5Kg6KJDZMzNqnZUHnId+F0sg3bWaZw58+NKRWCJX1ujmcv3IUGPNNgiVbrGSgDCiRX/ZJ58MBg0Nrr4H8ZuNVlGLhPP3OyeehAaeTyKOwH0YhrY8jQ8cu723fyPfhCjgI5va1VX9XqRuDFStQOuLx75SAshbFD55HzEGwZaVFDBtJ2LP+6X7Ll6IBZhiVYg/HL1g/Dl4rhUVmgYw9h9YvQ5r8tY4Q+n+lo/iy3bLB5LGu5NWgyUri5Jjf8rpo/18sh0K1hmwTNBftOK7sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbQDycB3yCj3fDKfXHckidCGcu0xfJ9Ud6rYn7EDieo=;
 b=i2SShjhCLnoSvCiEEv9jBf9Mgz5VYwCfD3NTcvnZJaYvZI0CjUCtmXVxenjt4gtkgpC49GaikVU/duJLAfh1dnpnrjLegcg3efv7XvlwMpB9QWg9Fnvxa4tm/G1WsbLSwvumZGF66iwNFuNiJTNnpoXiowT6i71n05VXa89YGbU32tdyWhAN9s3MF5u9JLAY9RDMgW0OGbYuTs6zeKPQwVNFeNZS4xIEBfiaa88w+rbTxx87/xD54iYOZe6c1M0PMYqouTzEE34AOoRJDIhRo3L1gffu3zLl8r4Cb+DVxMZm5T149x9i1SoJKhlr3c/uaCo8dsDTqwQhO6veuxwYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kococonnector.com; dmarc=pass action=none
 header.from=kococonnector.com; dkim=pass header.d=kococonnector.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=KoCoConnector.onmicrosoft.com; s=selector2-KoCoConnector-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbQDycB3yCj3fDKfXHckidCGcu0xfJ9Ud6rYn7EDieo=;
 b=RT2sDAZAXr3iVRd+HF80eQCDqx1kZZDKfWF3fcXCdIbUyw7kWWtyzMlSRW4kXOX8WzX/QZfmRFg1f0Re8vw1mVPm/Zdm2RUi6Ahk/f41Uw85EBP2M0yJ5I3p+0MaUMpuixCL+uR1vxZSLRFW1FM3/kG39YYxiqDcGfPHMeiINuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kococonnector.com;
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com (2603:10a6:20b:281::9)
 by AS8PR09MB6065.eurprd09.prod.outlook.com (2603:10a6:20b:569::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 09:50:12 +0000
Received: from AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641]) by AM9PR09MB4884.eurprd09.prod.outlook.com
 ([fe80::e9ab:975f:f6cf:e641%3]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 09:50:12 +0000
From:   Oliver Graute <oliver.graute@kococonnector.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Graute <oliver.graute@kococonnector.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC] linux: net: phy: realtek: changing LED behaviour for RTL8211F
Date:   Thu,  9 Feb 2023 10:44:05 +0100
Message-Id: <20230209094405.12462-1-oliver.graute@kococonnector.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To AM9PR09MB4884.eurprd09.prod.outlook.com
 (2603:10a6:20b:281::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR09MB4884:EE_|AS8PR09MB6065:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a3ee8b2-0c38-43e0-6dd6-08db0a8309b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/w4JqZ0icF76pujTPTT0WSPpsFzj0yf7bp0Ip+ShtWSNpu5PbuTMa6I4K40VCsw+WqE/jFTHx1GXzuF/MiF0JyRclF0qY7BOWL9mRRq3/3fEI57NCy+9qUJN38i1pNLFH7UhcEXzuXMQuQFJJH240yHeeV3g9lFQzJqVzNtNQ0o1lRp1wW4/kgUuuUApZJTFseJ/+LdId8YMtwYJL6NPcavC/S/ymFf+a+HCjH05UoK2EIHSeQutP/rbd3ztoCvBQpjp4sh4zX0ZoihZYIi/XSVaOE4anzEZohKtOamfj3MlFIiWKNK2EDcLJQfgMGXhm5MSbRHAGI7B9Ugo5XzOxgGiP4/kn13qRoqFLbsY7+ipk3m66/juSARlxkIq3c40QNBz/eJurE8uc3H9U+jiyU7BRrNjkseYow/BP8gMf+LoqXl4Y/nVusq309IDExAlPLsVINeivU786xTbOdFNIyBwIcF8fWSg7VMG6bT32YoXDh9qmgf+8+aETOyrjm86HMe80tOcTP1A4jzS+vqw9Tr/csbe8BKLIHAguy+CyYdhUw2ctZ4IheLDn9BZOfWlxMbpk6RULqF4GCaRT60w2LU5yg7p+1+VmSUpmB2a22Bil24BkJTg/Xe2U2qeo7JnvXbHhfXs+44Mdrm4YjpU6MX/Ek/qPbfuxjmZtWNzWML8yCw8ItDjKSd3KUvgEITDFXLQuyTrnVuwNp8DnL3Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR09MB4884.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(39830400003)(376002)(451199018)(44832011)(5660300002)(4744005)(2906002)(86362001)(8936002)(6916009)(66556008)(41300700001)(66946007)(66476007)(4326008)(8676002)(36756003)(52116002)(6666004)(1076003)(6506007)(186003)(6512007)(26005)(478600001)(38100700002)(6486002)(2616005)(38350700002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xYiY31sqHWSQxb951Wfonxt1tnwxResJz9KmKh+HCzaph0LLMcUZS4VphhyB?=
 =?us-ascii?Q?Zmw4a1a2ygEPHGogBHzZxhA5Q5ZjRb+MMVkS9AMrv4xV7saoOoGn1MNrg5wW?=
 =?us-ascii?Q?iaWhClDMoHUo18lEDqr30kLnrV+IcstOOvVhrTn8njpGVY1UirwhP78MeAOY?=
 =?us-ascii?Q?ahBPFUekMmLnBw29ZBjTBP8jXF0DtiRTJLNoc/lKYtLc+uBOx/WX8xHt0hyr?=
 =?us-ascii?Q?VsUoahJkk2tcwFi9CS0ZJJQ2Lcj54dR5Im4AQr0g88U1Elb00a6VgtWgaITY?=
 =?us-ascii?Q?0H4GWLC8S21FTBR9+Q3trEJsBkpk0PUJZ1riUq65aN3OB+ryjqo0iTeIys8h?=
 =?us-ascii?Q?jDwm/AvQ6uMo/4v4Bo+X3gZW8Uprs6AiN14aEfORLnNycYB81iA5bQHluhpg?=
 =?us-ascii?Q?J6n0rHAHooZGlWaJpkexSaHAdUcU6Uxwf1R9UigV8/rBNkG9SBoaMgck9+n2?=
 =?us-ascii?Q?hc8pvKGTvlFIqjD1Zm61d6O/CmoHkcm1o8I+MsDisIUvqY8t4lisGBOsxkms?=
 =?us-ascii?Q?T+5f+5v3cdVxW8dKtXFq4gCiuMc1wTg+/9EwyAa0uzHWfNaS+9OKco4G9gm3?=
 =?us-ascii?Q?NAD8QK7ffzazctenW/z8QpWt/+wq5DgzGXDJ7oYdl/p7BmKKzNew6rB4qA5y?=
 =?us-ascii?Q?zu8Xz3U4IphKqIsw4dM9bjvWP8lNs98plUKdpMONwdvUY0aW1vbdBiHjjZF0?=
 =?us-ascii?Q?XEmIIyrKDnnRAi5LC95uLhtHRj+4oa7ZBkbgUeBuiMLWZvXGbstG9280hgqn?=
 =?us-ascii?Q?JBki+wkuGkGDhI8g/I3WTsFKJN7/7RogRXYH0Wf0e+NjqjMOb2IAnIubyrDY?=
 =?us-ascii?Q?2GPZUzBt0vbvdPR5HUPc5l6B21fTDYNmzX6FtW3cLbUvdarevy9IVzlJxcnw?=
 =?us-ascii?Q?p8ijCfBfSu/Imqu0G+hAOeFy5ol0IBAgnU65VJHaPCTN2pyqNp7JBe2FoIoR?=
 =?us-ascii?Q?IlNry9vgZxzv1wLeyislsZJ4fEBeXFtslk8WXrfWbFx+oQyMr/DrGTVV+IYp?=
 =?us-ascii?Q?UyWr7FKmi9XcPSquz1u9WW1W0PpgcKRVZou64rq9idoFtaCtLVGZfBsHbAf+?=
 =?us-ascii?Q?xv0WF0gTbTVm5og6OXw+NRkTZRh8ADwrkb6k9GenMp3NvIeDVUmj9ZvnK6ZN?=
 =?us-ascii?Q?esukqeXXh1idlwHuzIdrzyYGrBwcxA+INtSPfpeYrheu024akYW5EB6gpVea?=
 =?us-ascii?Q?FiXbfR1EKTmc+n0abha2X760a/g0GvslmSAfZSfx1S6j3bERX2n7b65Lf+/v?=
 =?us-ascii?Q?tAZ7UHgPNFmLCt/ybC0KFU0pjCmW92ftLSueE/yC/qIGg0qgO1lvOq7naILh?=
 =?us-ascii?Q?K8k/58PXivZZtj7I+b9TNSd2NKsZaq+vINY/kHZaZ/Oj9sPWmsWBedFGEu5t?=
 =?us-ascii?Q?OSddkT8YvNsuGFx4KSYssWdAaWRKPS12IVTyZ/BHfliNwVKN4LoFL/Bv7UWx?=
 =?us-ascii?Q?SFTsAoIlAJ3VZOKEsdFLx/MV1a+HJCQ9iuvC6yiIwvEzEjv0k3ZMapCXb/X3?=
 =?us-ascii?Q?EOO36IplWx+2uWUtUCZf2lQP4e0MVPK613WgIJeFmmtzACKLUlQuoBcPzKsv?=
 =?us-ascii?Q?DKgZQyR1kyTm/9TU5hJeemQ7syCBXi0E2qmct+aXi+nUXK+wYyw78LlkQC0J?=
 =?us-ascii?Q?he12YCPrcd0h6/ZwlkxInS4=3D?=
X-OriginatorOrg: kococonnector.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3ee8b2-0c38-43e0-6dd6-08db0a8309b6
X-MS-Exchange-CrossTenant-AuthSource: AM9PR09MB4884.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:50:12.5500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 59845429-0644-4099-bd7e-17fba65a2f2b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1KYzHGWzHiEW913bRPdA6x1BxYLDjRJ3/84dsn5/bClFImHM37B6bnQBK6JLjmjHuVzoIrXWB3nyG15ymXpC6gsAZY9h0QLP3DtyFqAMto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR09MB6065
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enable the LEDs for network activity and 100/1000Link for the RTL8211F

Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
---
 drivers/net/phy/realtek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..5c796883cad3 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -416,6 +416,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 		}
 	}
 
+        phy_write(phydev, RTL821x_PAGE_SELECT, 0xd04);
+        phy_write(phydev, 0x10, 0x15B);
+
+        phy_write(phydev, RTL821x_PAGE_SELECT, 0x0);
+
 	return genphy_soft_reset(phydev);
 }
 
-- 
2.17.1

