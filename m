Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E882AAEAB
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 02:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgKIBQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 20:16:21 -0500
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:11552
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727979AbgKIBQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 20:16:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwioGlPhMHsEsN/6uQzicLIEoCb6nPDOfGkdOjMms0iiGo8zLsb1FGXzznHDSdtcp5seDZ9go+uQP5KtjBZQ3UT0xP0muQvKoJtmjHIqm7RZ8VXkiBsN7gp6dvF+dZbBRR8ADrliOVKcPVRNUp2/uL2BN2qspcLda66qFJk5U2SuRtLC1L3GfZneGWXDb8TpiWjoP/0GDmQCmnQvq3i0/GgBa934QtRONe2kGSNJaJNLGN2qPTY4OSmI+uVwpnsrTitelNFSmDE/9DEHhf9xYLNx/+I8SDhHBNXKMNAq1z6vIpw4KrgDkT23xocNI82/UJHLLqw015BykXjSNBxPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xVe+WQzH30dC68dxJpxSyHWq19rbkGT2IAhPtvbaaI=;
 b=QCQdlHwyDCOjKSyjok6EEPDsAf9VPDHG3b207x+yYp9d8S6SteUcuyTMGDTSAG428msqAmZB3OS13UX4qfe73d4sn1yrekfvbma2gL/Z+9qCpXVP4mtLW69O3rvjIzFuhSox2E/jFqmvYSVwsqOZjrzhj+ES2+s5MfHZ75Tvs0TNHmfpyuN5FV0BRMy8y9XX9dzAiAxAGnx9PxvbY+p5rLJbreBI/IUlc/0H7246KUnnAMrhGYTTZb/JoZA9+NZ1bn71hGQ9tD7/kzufpuLqrxrdCNkdISjAKiKsYrBaXd43gYncjiD2NzHXVDunjfd81oXsc82Y7kXpYMdIgB/ZMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xVe+WQzH30dC68dxJpxSyHWq19rbkGT2IAhPtvbaaI=;
 b=ZaDxyc6TR510bCLqJFoaJLKc9DYYPaO50hcmjLlkH2v5AKPjiun5bigLwXmoG54cFbZPbBlpky1kOPKBhFmP90FvDHfw/PtlK724eUpG/iNM0T+t9TRLWvqFsj5iosa6ETIB4vgWL9NJYH8mOf2KlXl+P3DYiVZmeswSTuQmDTY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SA0PR03MB5516.namprd03.prod.outlook.com (2603:10b6:806:bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 01:16:18 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.024; Mon, 9 Nov 2020
 01:16:18 +0000
Date:   Mon, 9 Nov 2020 09:16:05 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: microchip_t1: Don't set .config_aneg
Message-ID: <20201109091605.3951c969@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY5PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::23) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY5PR17CA0010.namprd17.prod.outlook.com (2603:10b6:a03:1b8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 01:16:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c82c805-ad20-4e7c-922b-08d8844d0f4e
X-MS-TrafficTypeDiagnostic: SA0PR03MB5516:
X-Microsoft-Antispam-PRVS: <SA0PR03MB55165D6CA53E6D8F4FCBE163EDEA0@SA0PR03MB5516.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLk/AvpJMhdFnwymLp3v1LFpUEQ82kOrxF4oUWbPj6GzoOJXMzGycitHsb6Jb5pkrZ4Ftv8bviG2uzaFOw87a53ytc3/GteojQhMWZXgPmFApdBxlVbPJyJIrsu+EbZujzygQBGha1jMNkZ8XBACxCPnwD9ghWKI6M83r2gGkCUbD9+oxfTyvpJRI4GGBwYEt0+YtAXyl8+Ikdf8nKzWlxJ75sdYWcFL4tY8oH1J2O8XPlljlQsGcMs2BH1X8d7/ZfqQ2+hrJxVfWkEvuLTNkaIlWVqz8uVs5V5W5si+5z+7sN3UX+/nBqSrVPZYFZKiVLU7I699IYaWFG/qDld3JVa6EPy8c/NcPU0O4iTmVCMznRWlq5rKMnprgWASecLG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(396003)(376002)(136003)(66476007)(66556008)(5660300002)(66946007)(478600001)(86362001)(2906002)(110136005)(83380400001)(9686003)(6666004)(55016002)(956004)(7696005)(26005)(52116002)(316002)(8676002)(8936002)(1076003)(6506007)(4326008)(4744005)(186003)(16526019)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MUguJkUiyHiBpkwSjWgY9VqNc3ZHCoqB7+Vvo+ITRuYf0Uvz0DjP37lXLC7QqLla6SFHx7fGu4Cfe3r34rI2AcSepBlmdYzTcoyJRrmebjHMy8Tbst0gME2jpzKQTY7Ml3Winp2gs9/jON2ZxGodDp7hOENJ39Dzt9uGi0oRe0ot3IXHNeOTQz+coemFN8X1/TS+TG5ka7Oj8Y3PHjdVVzDBKwJzxn5aSYP47oiaNRn75H1EEksvtAzxzWSJGK7g8mA580fugdWZHLQWtOVnsdFG3vVlajDHrUm+6ZEPGWMaQv5UHZAXicniuHoyuesbJtiO5A2UWiw6MrqEmMQlN6ryvIxP+u9SPNCRXL+Gs89UfasOTimVLcvN9jBDVdKrcBytmtPGY/3/DoEbvUV3vNTxwSSUhXC5J9jiN7iZGeeyK5QoTHWX8LxIKxLiiYbZWM6zCPTNqtQOlvdVrr+ie1At1NQGd1oOZ1SIVHyl+BxIzPCiEGa9jTOi8GMcohxQ59ijZnetdBN8xovNL8VGLeRsXYD9L4060uINuja+i0fu6iOPE0AeMgxS3J4ODLRO/IyKCAL93Y7KGHW5GntmSqmsBcVVAgnTIym+phZNMM69yCodY7KfSgBtzNVsXd8OsgEElEuSpHj6QTpGVH8Vaw==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c82c805-ad20-4e7c-922b-08d8844d0f4e
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 01:16:18.0589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgP7ldeE7f2zgEVW76x6ArCXdpYlFh4+edvH+8gdsjvl5MxqOc+JIbAxDuc+SYHQxD2T8ecs1pArcG3yyxKH9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR03MB5516
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .config_aneg in microchip_t1 is genphy_config_aneg, so it's not
needed, because the phy core will call genphy_config_aneg() if the
.config_aneg is NULL.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/microchip_t1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index fed3e395f18e..1c9900162619 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -219,7 +219,6 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.features       = PHY_BASIC_T1_FEATURES,
 
 		.config_init	= lan87xx_config_init,
-		.config_aneg    = genphy_config_aneg,
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
-- 
2.29.2

