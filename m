Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B9C48550F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiAEOvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:51:17 -0500
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:59232
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241098AbiAEOvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 09:51:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdKqlmdTCWuqcdDeesE+iPhpmH7gOOhUD8g/nIQxmZ4t/yNSfxP0j/wRRq45cMs8fcfR5OtYbUzlFXatVXnPU8LXiLMiKXDudZdn1da2GMyKWAQ6nqbckkmn+PxC5h+nCuD3HhPvkAXCGL7wrJKTgJKSzWUvQ1VM31YAHJI9NeYu5lcsLVOYxxuIxPjgvdDPro6IXaDnfYqe1N/cRBK3tt7NI3YWJ2Ysrd0bnXOWVVDi1LydzaCjZxkf0xSRmBkkfs3J5Z+cfi+hmizVpRAch9ooyQyi2EVonujyRwqp4xjxZiNhOOWBm/kd9esZbGzrNCBK+T1Zc3F0uzQCF+VYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPpSY704iOygmbHpk1tXpETaXHX9g536hgdLxqsSnNE=;
 b=B3cInJii6aTx4pZbXtYeDqtzJlyTUC8XcLHQNHG0iiw8C2TDyIC+s7Hv0Uz58kEeoukpEx6u3QIjd1NoUFzWPxvK7bKcZrAd+RmncdGrbhKX0/7WmonbbzOvGCdSLgphQFoNlo4QZ/woWgjAP34pu/HiMSWFyu6oORBlTKIxqTo036PReidQhbfbIGdh/hgtMhKYJvSxtQwQu1FsuBne3CKTHv2I4XFYRTgctlGZ6UIXgFiS3tx8MEpOtwKdH8YNV5u/EkOFtpNjq1r5h59W/sVISJN4LrIuE1ZfW9lEShj3MhF5RscOA5E4OXaS5y1Fk8hkLHbIWN57JYzlLucToQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.70) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPpSY704iOygmbHpk1tXpETaXHX9g536hgdLxqsSnNE=;
 b=YGjWAjvY8PJzzwhM4GGV6Xheify5/KWgLlNIshvoKOAl5+fvaIZ/eTYdE+rDfTbOPSEMhr9lsYvmJMPsZC3hdJhpwfiDxrHkjkpzShjlQgMLZHDB0Eufi9ssqScdTL14QiPxzgokWMfSZYpPaEWtB+00zuNCtHTlG2t3+qzGf0lVrthvCjNL2b67sxak19369nPkVB12DUMqq/a9YA8JMVsqwdG0bolyUlgtvcJfYV4pPagRsYP3dMV5JP0emIbn6uviZN0Cl+PuVvwWbe1U3dB1QOCTpt7I6b2yDQnhMx8I9vCko6XJTS97HAgLy3bzGKDjRa+TIotHIL0lmPvlfg==
Received: from AS8PR07CA0017.eurprd07.prod.outlook.com (2603:10a6:20b:451::26)
 by PR3PR10MB3833.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:4a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 14:51:09 +0000
Received: from VE1EUR01FT059.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:451:cafe::ab) by AS8PR07CA0017.outlook.office365.com
 (2603:10a6:20b:451::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 14:51:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.70)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.70 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.70; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.70) by
 VE1EUR01FT059.mail.protection.outlook.com (10.152.3.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 14:51:09 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SJA.ad011.siemens.net (194.138.21.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 15:51:09 +0100
Received: from md1za8fc.ad001.siemens.net (139.25.68.217) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 15:51:08 +0100
Date:   Wed, 5 Jan 2022 15:51:06 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH 3/3] net: usb: r8152: remove unused definition
Message-ID: <20220105155106.400e0285@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105142351.8026-3-aaron.ma@canonical.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
        <20220105142351.8026-3-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.25.68.217]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 799ea994-9246-432e-7e85-08d9d05acf71
X-MS-TrafficTypeDiagnostic: PR3PR10MB3833:EE_
X-Microsoft-Antispam-PRVS: <PR3PR10MB3833F9FDB431237919649958854B9@PR3PR10MB3833.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qz0XTWRLoJHBYvS5TP1OvjbaiAcT2Q/ICmqGYAvf36gS0q9RMgvusBc5iJce8ox4tjZ8PPv4W2i1EPwpwpPhOHNNxryt3k9Sk/ijkg1jhd+RY+GA87f6P9xyg3DSN9VY8nBMxE4Do/ERNUkiLvx0mGKM+ONG9u+DYivixr8FniM7nvlUh6deWGrqoyhYDavG4XDqRbrK6IKDCyT+vYnoM2VkmEvyifaN8qXvNeBothHKebLgD0mqGrYYPmmZQbXcD02eFQ4KBtniBblP0oyMVEdV0GGCrWXdcuU17bPThbL+z0SIjQ3xPzJ3G7Wxt7SvQGlacnuID+xE9i2ayLezcH7x3Ku2tzqa+InMh33s1piILgnwYaVsVlPeGVyhzREb7HiacZpjnWYJaxQg/2jASugP5AwuRXEe/+X8VhSrDNvoOdphV51YSvIu1k9DxfTBeWpzgsfSuySPWsqO/Dkb856lN8938tC+UcudOIPqNVc9Qn3IfMRwFWMNh/hyVbggEq1/WwcWSFHlIahzIIVKbSSvoWv8mtiqywpf62XGztFTkTW/L9xIOFWlk4anWEZHtKtK9fQqNxGW+bTWdwz1qw8R3Ptnd5ZiO/GsZhvcvDMJOiHppr72T/rOE7wSzNW6dfuDJdvaKMJJyit8dirZ4Jbaj5kcrf6Iv38xuUuhiGH/EMMQaknf7NGkAbG9US4YMKc1CshuKuQoOFOjniNBDI+66TKnouPOwYpQENjhjQ45qpsRX/jFfOzFSioEgDRI8umpxL9qdAuzFwshC6p4Zw==
X-Forefront-Antispam-Report: CIP:194.138.21.70;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:hybrid.siemens.com;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(82310400004)(956004)(8936002)(55016003)(82960400001)(86362001)(54906003)(40460700001)(4326008)(44832011)(356005)(70586007)(16526019)(7596003)(5660300002)(186003)(336012)(26005)(4744005)(1076003)(2906002)(7696005)(36860700001)(316002)(83380400001)(508600001)(70206006)(9686003)(6916009)(8676002)(47076005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 14:51:09.5122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 799ea994-9246-432e-7e85-08d9d05acf71
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.70];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT059.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB3833
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed,  5 Jan 2022 22:23:51 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

Maybe add a 
Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for more Lenovo Docks")

> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 3fbce3dbc04d..be2a6a2c2445 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -773,9 +773,6 @@ enum rtl8152_flags {
>  	RX_EPROTO,
>  };
>  
> -#define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> -#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
> -
>  struct tally_counter {
>  	__le64	tx_packets;
>  	__le64	rx_packets;

