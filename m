Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EDF2994A2
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782050AbgJZR6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:58:19 -0400
Received: from mail-eopbgr660083.outbound.protection.outlook.com ([40.107.66.83]:58592
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1788919AbgJZR6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 13:58:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UneFe/OhahONVzsLJ8NIb6XvZLFBDc3ztrzcxeGcRYYd4e7i/PlwBGb3RcraWDpYNgeGvo/Wf4EZPp81D8zCrC+6JvCChsA281EPpgCanQa0LWtxzB6/l3Ndmvv0kB1mb4vJgoLNLIdqY1FHnSF5HsUpNVP+WjvAsEctPwPYBBRq4AQkAjuYoD1tHyyDTdRwjeSydJpu+0qWGPmHfL2+xiBvhM1qT1FN/w4j2UFmbqubepWtdnN+0m3s/7O6g66K9YMdMQ4qWsLYRgcn+y2UniO38rc2kQMFPVVqduw1q3Sto5A/cwTQkbLmDvn+SzuXE7Pu4/kZU/yixfVqQb8HAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqpfvxXRFntKoaINfYCIWQnz1630XQmxyPvgN9iZ85s=;
 b=NOyiigsiny5HL3Aa+tjNha7VfrUBnh6xs6XAUWdkE4xI3BeRIfimL/M8xb0asc2NpMDtKQOYC0MVJ++hJ1rGXz68UN3PqLghO+zkwMarxtS9NN1o/4NGzTC2kCSp1hWcGAi362j2E6yd1JPAf4Upy0ZRzNbJtq4bLLORzALhmeKTjofnqjyhbjHOpG526xBUAIu8zzfliJk0OCgP/4C3+hwKJ9v+Ndsg2zqzfmkhvHbjKbdnnWkRVsxDDLv8A8u6hDcMZGVqFuhyyNaKDl903LQrC4oSDHDhilvtkdjoCHhakxarjthYVz4Xx36BPinZrfHYLsb7rvfkVlTvFCGfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqpfvxXRFntKoaINfYCIWQnz1630XQmxyPvgN9iZ85s=;
 b=lPq8T2D+x17UXiSMOfrid7OjBYQJXE9VEeJ37tf8ZShdfcSFYVbbT4T2GM4Vfod85HSeit6t4wxP0pBi5MAGcj423lf+wDoXzuoigKdBMld7aLXFuuV+CL2bnLcVrB9TW49diOoBLWTlqP8tymHtsmtQT3vPIFFWco1kxRKSl60=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3040.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 17:58:14 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 17:58:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: phylink: disable BMCR_ISOLATE in phylink_mii_c22_pcs_config
Date:   Mon, 26 Oct 2020 11:58:02 -0600
Message-Id: <20201026175802.1332477-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0100.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::9) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0100.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 17:58:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9085409-02ad-4b5e-a94a-08d879d8b57a
X-MS-TrafficTypeDiagnostic: YTBPR01MB3040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB30405B3D6D88AA2B3F7C99F5EC190@YTBPR01MB3040.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJEPul6HPWdqGbjcfDgaf3vtkGLjRIgoFtXdvaaMBBHnzijUeImsQLL5SqlaOvidxaLweLdVNRFuFYI67SR4eqicwF/hMr35VZ6+6uh37i7NdeenPOtcB4P5moZnhlmJB2HGf1P/NhVh80PYRbSo/+JiBDXV3+13o7FwW3uNKSkCURGo6IV0Ry41IeDD7TjVsEYQJF9soNZ7VD5DeZvd+tPdwzkm010G0vZf5QnqCFJokjvIoIPLssW3fs0OO8kIThIrWVByqEepB9CG5l6ur+MHCXaOKNFIu6TGQCD9loolqx09QlhUmR+zTnXk+dF/U7tZaHOSgfGApfnYFO3YweSIFo7APG+jG7N1I0MQ+qScVJXXOaJoKHx9a1PGFfJV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39850400004)(136003)(376002)(186003)(26005)(6506007)(66556008)(36756003)(316002)(6486002)(478600001)(16526019)(4744005)(66946007)(6666004)(6512007)(69590400008)(66476007)(1076003)(107886003)(83380400001)(86362001)(2906002)(8936002)(52116002)(44832011)(4326008)(956004)(8676002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ySmpeNDxevqbMK3PsrxDKqo9ue0k1jK+RcjsQ3zvuykp+TNjq9H97i96fn7h8jGPvyNawfPxRBilmWsUmFKG+M0AgPtONrVlUdMCb07XFAjfBO3mLsaG7/JPmVYgO9rHpposGTOKGRbrbWTbBOXStisg02IM4pod4EvM0f1pQxcS3cWCzud8SmYbmc33YoRnG1GnVcFMe+ztRV5lZv8M7dajLLauF0pR4Mrq9THJuK1dSpSMf3QVz5/7Nf2cMC3kOY6pEIWNzGAeS8JTJPIUDzHQkSzuC42iU1MTh4pMvoUrVRSKsVwxCnrh5sMnYAI0diHL4naYcMxxJzw66DDbHYXHAnU1/MdGKTX6JvRLgx1r9RYawSBjwZHbYu5RMf87qjdvNTDXzPb+D8Q9vyu7jJMVYQ7RHfzU76BYG4X2XXMsh7DWGAZCYoxVP1yWql6Z8W5bi9Yf7CgVs1gXEyN2rCPu6Q32wny9b9ke2orcnNzqrzV52Dtf1/BGqbsofOyqNdwlIbqfZ1ZhTj4bbp5RBl4sN7ZQsUOMM36J3WnYCQd87iadatz5yUlIMJBBaQlxyq0rZ+JZ/qFfhI9PWa/DHr/Gmsh905WdHQu53qPfZoIp56gGFKWST7CGLO2JNTUTvJEaLoGGtpyMl4RMiGAxEw==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9085409-02ad-4b5e-a94a-08d879d8b57a
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 17:58:13.9405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOIpacQ0nCIa9wAsA/5rm3Jj58ZmySbg9Mbu/lRb0rYYOEIi+0Hsot0zrUA25L+rWfTSSAKfNbw6VZpQm37imJyiWK4JM//W2qMb0c3jBzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx PCS/PMA PHY requires that BMCR_ISOLATE be disabled for proper
operation in 1000BaseX mode. It should be safe to ensure this bit is
disabled in phylink_mii_c22_pcs_config in all cases.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---

Resubmit tagged for net-next.

 drivers/net/phy/phylink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fe2296fdda19..5d8c015bc9f2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2515,9 +2515,10 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 
 	changed = ret > 0;
 
+	/* Ensure ISOLATE bit is disabled */
 	bmcr = mode == MLO_AN_INBAND ? BMCR_ANENABLE : 0;
 	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
-			     BMCR_ANENABLE, bmcr);
+			     BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
 		return ret;
 
-- 
2.18.4

