Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB09A2942C3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437966AbgJTTNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:13:08 -0400
Received: from mail-eopbgr660048.outbound.protection.outlook.com ([40.107.66.48]:32400
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729336AbgJTTNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 15:13:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSMUtHf40fRdPE9POgD0yaQy0T6mBg2i13qqnbb0GyMcRoS3OsFg1jmm8PTUfyY6UZLXPkm/Lwm8s7FNkDGFd+FMe4TSfTPsuLEhNyzAH2m9GcrhyZGEl/Kio8s990ZAY7L30o5eVTWqOTnsJdXqfc/ddBDh/3cQJwkqhKZPU04X3+pkm7C+UeZ+CqtMv66j3YcKnWb3jqgyTgoT3bEoIXeOItNPzXLG6oeuIgVFEjjx/v9zJe98bqPUij61HlgrV+ljyD8sQGEeK0Mu7B3FXtroowx/vefp4okWfY1OCndx1hHKe33VUK0XAamHjRpP23DDB3kEKNSZvMgv/aSwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K8RnotXe1SK1N2u5i0oo+p69mvHdwPrCcCsDFQmMfw=;
 b=QzxxEB3ROeSkAJYmIIP0Et9WWx2I2aaeleRuL6MpVH5YsEKY8tro/bruXKRcUwaCcsDOAH/v07E5HHoIEBoCFBCxQyXKALucryxWl6oZCHn8bdz8yNvWSqIc/spOSvin4dwJ/hB18CViiY/YbAdPU545Et0icWYl2YN02FxYm+Zp+whg4HZCI+8pJNcRl/79tNDe1yVB53yHnI9fWVwsgz1ztOVynrzADUAM1Ln9MX1ONpwyRRD9zc4oqTs1kKtIfQ4AA38fYR/+MbOZ7uVE3U4yds0Ep/Wz3NKvE1wNIM7nFhFLKVUt3zcIFuqXam2c94s7XXh8G32nuzebuHUJEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K8RnotXe1SK1N2u5i0oo+p69mvHdwPrCcCsDFQmMfw=;
 b=uGHgQQzAYhzjJrRvuq0BwdlEDoWv67om4G1sDj/B4B7sjXny+w2YBmGDpXmy2bIjMi8BrYO4cuH55cQ1zGCJdX2x1lQyP+Fi6kPBtRuuwKzaN9LCIoQiELh9lyQK3iDg1c2MRtm3TWIXrbikcckOGbiB3rMYSkNWXdOIr4BLrAw=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB2142.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:10::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 19:13:05 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 19:13:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH] net: phylink: disable BMCR_ISOLATE in phylink_mii_c22_pcs_config
Date:   Tue, 20 Oct 2020 13:12:49 -0600
Message-Id: <20201020191249.756832-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::18) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 19:13:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60a495ae-22aa-4b1b-c203-08d8752c2bf3
X-MS-TrafficTypeDiagnostic: YTXPR0101MB2142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB2142705A5CB46F1B2876C12BEC1F0@YTXPR0101MB2142.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xg5Ryke/5nIZ1O+HHlkeHdBrJAbIh+Ft+PSAa8soLwy2HDiK/ektA1cD5Bm0IjEtd+c2x1XU87FS9ni1acp7hvdIyJSfryZHhc7Ry78ivjuLyo6kjtU5VNglN3UHor3vv1zl7K/qYxTBmMaYK0dVuNkczPigYkyrQiT7ZvkHCtEs9aj5mHN9BwDlNmpJV3U249lmgrkegK7/oPJhBaFS5qH9nnp1jwHFYKPfNf65fGAdCh9EOEfRSjU/eXoyBnetFo62bPeCtP4gDLmev8bWJ4kOXNJt4cfudo3UQsH/BIGDQx8Iw94fRpCROPfqefb+i9+bQ0+Z5kePphiPZ5qd2+mJ0CRpYdt+dny4fqVldo7l9Mxo6TtUqpSLXQ/a/5Ru
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39830400003)(376002)(396003)(316002)(69590400008)(66556008)(66476007)(4744005)(66946007)(1076003)(6666004)(86362001)(83380400001)(5660300002)(16526019)(186003)(4326008)(36756003)(2616005)(956004)(8676002)(6512007)(6486002)(52116002)(8936002)(6506007)(2906002)(478600001)(26005)(44832011)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /PKRB7FmfBiH9DXFXPDt0jNGkNEIqZnN0E3evdA8bYLwVuV8YMVa73iLL/Ht6xKxuXOgjGvAsVB4hiAmnN8Q/HSDJ/Lup9/9Xe7bcNi0dvEY8+V6wb8SIF+U6Y+TOU049tpcJ/WPWoyID45CQUTG7lEOnlTUbPEZj1hzQZwJ+k00sNdpImf2nVZAYYH9a0d4EwqbL87+ytXNC5O0XGHDD2hARtoq3OkJW/8MDbW20m9Fz+j20+g8Gz3btduGgtm2myjtuesmnXjN3T04kSirkbFiqcvCEq5NW078aH7hLPgqq7XVJ+IEyTZ9KyLPI3/7McN3LdBWoP7LUfXXO3sL2zXYMvpbWlnZmO0THd8dHDckMslkVa9chs6hhNsPJGdlSW51E+QIonbrZRX6+3YTkOi/5MUerPytG4Q3o6IIRHLwQ4NStimyuKOVdJ8noIgM/pDSfid5wTlC3fx9VzS5hJruRXI4H5g/g+aMudErQdtPe9tv1buGYo6sJ5KEqrRcH7I2onZeN/2XjmbwtY5yI8bo1CaJh99FcxJO1UEeyAqsNOyr95UwiXIE9Jv7PdEz1gJ74tdBfTtrh58aRphcy+z2Z+zvoECKw5nZSYgh//xudWnjjjK2dAvAUKeCAfkSk4MVbKd14On4QEYVPVOIKg==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a495ae-22aa-4b1b-c203-08d8752c2bf3
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 19:13:05.1010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucukm8QyraA6i/ucxu7Ql+6EkDroY2/Exl5GkES64Nlpnz/MZqkgaBUj6sjRCYWmOonxoLQp+jmBzlzMJLSOmUQkFQo9bl7qmBPehKUhZ0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB2142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx PCS/PMA PHY requires that BMCR_ISOLATE be disabled for proper
operation in 1000BaseX mode. It should be safe to ensure this bit is
disabled in phylink_mii_c22_pcs_config in all cases.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
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

