Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD70362BE1
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhDPXTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:19:04 -0400
Received: from mail-eopbgr70139.outbound.protection.outlook.com ([40.107.7.139]:18142
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230489AbhDPXTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 19:19:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JF3CuOSYYAlA2feHaE2hcLlVVt88dMjwmg7UjzpPG6eC80+w5H6PpGlDyL44HceOmTYCEwPdJTWZvZDaXYWfu9/AzxUr1UnNBgvVNw4eYK9BPEsXhxmrH33FZVq2D0waMb48MFjjcv+wdAsUQz1szGUw+hIFhWip8aHqNxBUp1AqoF0P7RZqTz0yGTeXxez/xeNflkZP2KwaSE8ywB349d8oH4gtc8wtdQd3swpnVVhSHdhiRL7dIqnyoMV10sO3xNN1qy3oZ7e8xZ69JtZBEaQyAddQUWgDPYM1Ta6ucrSZW+5/VjhPfkMh5TcXCh0/MXpRdpeIkbx1p/edExUw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPzNeU8hbunu3IuW18YM77k4Sl+bfOg1bwvBLi4WQWk=;
 b=KuDbI7pfgKpWaeDeDk8DA3ua8mCqHLku8fMKXtivsqr5L73A2kOmvItzCCf4WHB6tud5L0NJ3F8IGn92FknjfL7yiggWxwpw8Y7KshtPhVoSWIgYyjxrx2mqduX19NQuWHoB6IF/pvIsKT8VuYSjWHA0M485te3Rc1xX9CQIMH93mjKeMAQ8RMF1dXdMzPwRmQkQAOtZ/DJKPIBj40YXPKIl3FEOXf98m9kb3IQDYQcRcAhX084PHia58zJzAh+nhiFQ9R9PbApCXpJpqoNgcCHajv8ZDkfzC+A+feSE+0ESK6A7gnk4DQY3Al34QKDz3ZG/MJ7HxhCUmrUG5yYgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPzNeU8hbunu3IuW18YM77k4Sl+bfOg1bwvBLi4WQWk=;
 b=FXzPqFXh8tRPpIFw6EBBIDFfctJgd89TY0KdEg29COPNOTQPu77+rVBVXyDsUy63aWA43VGKGSJ/KmDoPgNhixvIbsEUVNSzgcj3QUnooAKZED9iDKb1d7ottQy1C+r6TGxIcjcyCzV9ZT+1+a+rp3sI3v7+XHsD9aGB6kUm+Zg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0089.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Fri, 16 Apr 2021 23:18:32 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 23:18:32 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH RESEND net-next] net: marvell: prestera: add support for AC3X 98DX3265 device
Date:   Sat, 17 Apr 2021 02:17:51 +0300
Message-Id: <20210416231751.17652-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0004.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::9) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0004.eurprd04.prod.outlook.com (2603:10a6:20b:310::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 23:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9df93e5-d0f9-4155-95e6-08d9012df38a
X-MS-TrafficTypeDiagnostic: HE1P190MB0089:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00896DBAA4D10CDAE7E70F66954C9@HE1P190MB0089.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWI1aQImeIE8K5n+7M0bap0lUu5BgNrl5h78bp+8VnUfFpO5z8gjkuMmwR4/y0yw2AC2Kc+YYFaGmaHpUMbfqhASsViFj+iPRBnpDIUn4q+NBl50raC7T8ms9T+TtwmllQTsAlgQ+uiSTt5MnPsHCPAxDaeSnrgHGLVLU5pP2oQV6tJr96AA7QIR/P4bZQznSnnJBv1fxkL4MkyG8FHhhl1zv0WzyCHUcA3xH1cqU3RXX72/cjSSlrHLaie5Dn8EdBgc7AVCSYye/hPM/zaF/9sCtxSvIE9qoL7FYZCeOB1/PitGhVNMUYdczUdozIRHS94Hi0SKhL0G6DslIhsJh9odqPuxztj9tKRbb9O2/Se4dcCnpBHwas+jCIboZf94Ju8WGU0JzaphCrvotd8YwqEfKtIuQVj+njd3HX8RHpXD2WF9BvEtR9xANUTH6cXYk7rtc+H4vKuwpPCpjsPQT2OM0LZ87Y+Xy+61oGK00o8W/nLB7IfCsTXzHP7WAPu7vZrBtEgnM7nB7BM0WevxuTvQjx6OcDREytR48rLeiRNJBbcGQAKRlR0Byq4lYYZjRI8PQxkWxK5zpc2EGflJAsogOvsQbtDqOJAUPeKecoIuiQfZUNaY1oj1zzqbWOZHiWULxe/4Ot1CFbZ35vvLMMxiUljZ+rUVL+6pLhl9V+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(136003)(396003)(366004)(6486002)(38100700002)(6506007)(2906002)(86362001)(1076003)(4326008)(6512007)(478600001)(956004)(2616005)(44832011)(8676002)(4744005)(26005)(186003)(54906003)(110136005)(52116002)(16526019)(6666004)(36756003)(8936002)(66476007)(316002)(66946007)(5660300002)(38350700002)(66556008)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e/yCoT9ObNxr4xUkpQ6LzQzXPzN5MKbKr+Iyh4zVz3T6uCK5bvQhkHer5eQQ?=
 =?us-ascii?Q?Lyw72/jWIFUKkyTsxWMh2XZtYnjUJGoTvRp94SDmBvGG7F8qR/aWhXrRBvZf?=
 =?us-ascii?Q?hXthFCZn665rfCZnqT8A4k76vynRR2LyLkr89gIyfmMoyJR8WxyGOdzGfXQ5?=
 =?us-ascii?Q?pqXuRIIb0DKIJK8tSTStQXh9yBld8tzPa4WLL/fNw0EFeCiNcQf0SeI+C/UF?=
 =?us-ascii?Q?tMCEBKve9V4j38RgeQ77qLuce+JM9YfSZSl+HeOwZaQy/o5i1ahwPlhXZ9wX?=
 =?us-ascii?Q?GEtb686SAWQAS4F0qWRrxs+zYezfm/EehXHtpr0HEOwFXFj87ncLZR03/G2l?=
 =?us-ascii?Q?WIetqHMowFzbTOioBGEHTE4qwTdnOgTqeW3sK9iIdsUnikayefuKZp5zMooD?=
 =?us-ascii?Q?5efH6QQEDxy1KHDqo9RGCMTUJg2/bPFRHKHpkki3BU4SGCVCmpbeq1xTHECK?=
 =?us-ascii?Q?F99ovhvYgQzwiuXtXPnIanLcJ3GTt/sr8u4jBn2eBCkDFgV6KF66yxT6pVL+?=
 =?us-ascii?Q?U1TbMpIqLPV+nxIoWlLOL57pEPBL4+PHbcECI4qceKaseEfCSKIYl6lbldpf?=
 =?us-ascii?Q?nA5J7Gs1rUXOyu0gX5pBD/KE6XnztRi4PM/lSAnw3OFY10JYjnyHqQ5BNNo/?=
 =?us-ascii?Q?Z91n2H6L05/4m6U8RtOvtzgBpieghqovevp7XbJwwN/fKgZhW3Rry5o0PHro?=
 =?us-ascii?Q?stBDA8ljpXU3XQigPm1/WquHNIWM5vuCtaFuXVawr0JS+tml0VH07CfjyEDN?=
 =?us-ascii?Q?NMRS1LwyxP3hlV53lhEoUN18IffMWyK1NaVATXWaGXoLWaHRvqVanFd+ayiI?=
 =?us-ascii?Q?j2McydKF49Kx/AcOw0W2kKZWAzpjx9gIar0ylEqXJEPc4BmtV127I/xr2vOQ?=
 =?us-ascii?Q?ZSe9HogO+yxGYaq04TiE8kYTBzju7DlNmz79WewXIpHtcAmZEdDIedsLD3Ve?=
 =?us-ascii?Q?kankUMcmrpnh7gzdnJn9cwTkS3qAxWMgeGWGGiEjAq2/1hFyiX/WjLR+Lkd2?=
 =?us-ascii?Q?IiMukuRs2xd7gF9hDWgUagds9w0UbFxQgVmeMh+XcVjILjVcT1feyqve6cOM?=
 =?us-ascii?Q?AKMHKHWjMKkRR1+as8x6qUspKL1s9WAlHT8iguamnQlhVyHDj8NVOW/XEStO?=
 =?us-ascii?Q?WexjRPfLFfVqsCpdzx4vN1GNm4Tf+upF0CP2MltZYksUliIW4venA6uyBfJB?=
 =?us-ascii?Q?50w3PrHDaHxn9JWpcb+3A5jyYpV08ysdWrr4yK8ifaF/5kyBXFv5Eazja07W?=
 =?us-ascii?Q?jZB4s3gfl0aRm52IuL52NtjwCQ5sIhchS54eoL49OdqKVJVZtPIaJ+19Di2g?=
 =?us-ascii?Q?hJT9pQtujvdwMwc+f801Byot?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f9df93e5-d0f9-4155-95e6-08d9012df38a
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 23:18:32.2076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DQgVSopIG6MhVsi71uf/cAe1Sdv6Y5Dz6MCEgwBKsQbHfQDcjvj0/rovZ5nNU10hmhFNAdtyVXIJWzcHaP3DAi4JtZRY7vJJjerjAcLuXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Add PCI match for AC3X 98DX3265 device which is supported by the current
driver and firmware.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index be5677623455..298110119272 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -756,6 +756,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

