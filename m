Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F744369E53
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 03:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhDXBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 21:13:53 -0400
Received: from mail-dm6nam11on2109.outbound.protection.outlook.com ([40.107.223.109]:36769
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232106AbhDXBNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 21:13:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAcXS2E5R/+5+eC4gstXlhnR3UOTIloYDROgbkhPGvrVkaner0mqsM+gLZTrnqI62JdXIPRd7o4vqoqu3i51kjm8c4Urg7mG3cpE1Rhd4heRcfORW78yyltTDK4QTiDLp5AsrEh5UYxh64TE7aGe/akzKQsKLGKp1Mc4sIGe+hHfFb6rvpNKH1TAklRpYoCbLD4UceBkUh/kwd1My2zGK0UushxC1JpN/Y5i8jMPf7qQTL/QsLKapyo3M9nJz8ktbnMHgMTVq4JTKJU3d3Xk32CkKZRJ3s8d1tSDKL3i882XNkGjESP+VEbPFv7QlluT+Srkdcd4OWcQP2gx/VKzfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzGvOjKP6F/9YTvJ+TZA9U7Qr5vOkMijlQLyF7KDOvY=;
 b=V+KwMXnS1cAuaTU/G7eWBVQcfHWbg4LwMQOxuLL36IGo+xyd6AHgw/oTEpDwmANRHmaLN9D0PpQi7v1N6IJKU945Ya78YQg7oNkrVCrJkHIEc4/43BjYrSqVPlE/JZfkl5bVhbkzbft94WI8iqixOkLDC3kCK7RFsU2a6zTv2izZVMgoZOy3e80Hy2qPiyEVhdvKnRQIQB8TvVbK4Ftwy9R7KbaaAOaxN1uPNmvDYoKN+RGBIdVbIw0s/W65/vWGcpUUypjSE7631RrKHwKSENLyg19N1LLMU2KIANuU3HuhhNcd0qmAWMi1nVSK4Yrb1Rzv0FZL1PMLUE2+4N1uYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzGvOjKP6F/9YTvJ+TZA9U7Qr5vOkMijlQLyF7KDOvY=;
 b=XNKeoY2SU+QbNqDj8Lz6xU8FKOnlKiil3anQOeRCKVt2WQnbd5hsURug9kEEhD4ztSzEF3DB0gv9UvQpezPbrt4gWefjhd3hrU7NIDwJ3X6zP4mnb3dj7Sb1VceqeedZ72RQqjwfdFl18aFgY1QcB5Xkj5AknmFTmyVNfYvma/0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1105.namprd21.prod.outlook.com
 (2603:10b6:207:37::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.18; Sat, 24 Apr
 2021 01:13:05 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962%4]) with mapi id 15.20.4087.022; Sat, 24 Apr 2021
 01:13:05 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Joseph.Salisbury@microsoft.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next][REPOST] hv_netvsc: Make netvsc/VF binding check both MAC and serial number
Date:   Fri, 23 Apr 2021 18:12:35 -0700
Message-Id: <20210424011235.18721-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:1:3e1a:d2bb:2892:d4c9]
X-ClientProxiedBy: MW4PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:303:6b::14) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:1:3e1a:d2bb:2892:d4c9) by MW4PR04CA0069.namprd04.prod.outlook.com (2603:10b6:303:6b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 01:13:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fc4f950-498c-40bf-1836-08d906be1cd7
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB1105B1E3C9992F3EEC17902FBF449@BL0PR2101MB1105.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fk8FFnJr5cGqNDN6HYn6Q9YF1bkAT1jmmJyaTXwd3mfzoKrc3hsI0HIz6/kXj4H5hyMOnwNBRIUH3lEVP5jnIwvUWo5LiSEFs1h2UTZO+U4VKHTVUTZta3uRx9EOxaPXBFEkjFUH/sg/HgFHXf1hnVEoHGV88qCr8FGfw/KeKlqSx8Ny48iTeDQb8dczt/E1TnrqyV68ZixsH5iin4EFNhtTd0aYmg+BI1KpiPxype7zscKieowkouaDUdFGx2OOQi9YuHUaCsH1a6T8kUoWF2Tspy0mN75tKf2oYWKbphcbqeS6rMqUJy2pBtFJCFGDpnGnldpsJlOpyqsXb1GdUEgbL2s7ffcrV5hTq9THu5YHwhm2qWfloOP10YT4HF9Qn/mSvEuKHXAjp9gz72QgTqG0UhMGvtsVKoouOxPVexjfr8zj3O8APtXAcajNiz7+xHFweiF8ENf8OPyAOtwc+8HlGZ2/c8zMilZBjpdGa8BA8mtAesAoU7cadO9UfREe+AAKPljGhiAzuMn2xHLd3qFo9CyxexuLuPYlkL8MgZLEKJX9MgbAu8RzEJYwF2T6jEZl+KK8sQnKi0potS2QFgGFALnzh21991xLth+3kojaUDJXdnRI0ESPmbZDK6wU7S/WYPefhTHlo+DiN8z+rc1Mzkfad2kb2QCPZ0Bdi2svEoM7kH299xfNAmoM01CliZ6HoEmIwA14pZbx4JJL9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(38100700002)(6486002)(478600001)(66946007)(10290500003)(7696005)(966005)(921005)(186003)(52116002)(66476007)(2906002)(16526019)(107886003)(3450700001)(7416002)(2616005)(86362001)(8936002)(82950400001)(6666004)(316002)(36756003)(6636002)(82960400001)(1076003)(4326008)(5660300002)(83380400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RA9OEafTP1VgVCTdKI24F5vrbipaGKUFrEas9mE4FmkOsTgUwJ0k9TZPoGYi?=
 =?us-ascii?Q?6w01hfLIVEK/R0YwNKjxG6wnIScgOivNn3E+bVjNLYlqSs5ezcHOotwTjV+u?=
 =?us-ascii?Q?EqzUU8m3nJnMZyCdN7sh8UB23YKGRO+5sNNexKECvmetOygZbq2MIIxtnytV?=
 =?us-ascii?Q?W09tQIN5tVdwd0JBFdQKO5fvEeb5xZMFd4vkic1l8M1GHQnh5rAYuIbUoedw?=
 =?us-ascii?Q?YmruWfqv4JkjmOBjK6WlSjcMPq0yqjdEeMVk950ZK70UixE4hEpzWX6Up+NO?=
 =?us-ascii?Q?L6UK3kAzu6hDtl1QXcK2xi3VHaEvVjrGToR4umUEPOVp6B5QmWz2KUXrODhP?=
 =?us-ascii?Q?oDfgm/vF/dnilhLFSUli7oPLez+Q1PUld9XDoSAePPYGTr1mVsRfLEch3zL4?=
 =?us-ascii?Q?JUosQA7cXEBknQImMXAAe1g/qM8EAbB4kAyDDIk/h46GRH+EhvSyOdSBv/f4?=
 =?us-ascii?Q?u0NvKfSK0vUhRxjnIVxXG+jGZsZJ2bYR+oH/TM23dB6S5B4FesxusfPQT21r?=
 =?us-ascii?Q?XENRrEs9DI265aBibKRjr83QNPRQQ+IFvPLBsIXED4PPknwSI+q6oPB9XrqG?=
 =?us-ascii?Q?Mu1XPF+WpJ22MFq5o3fUPIYVnfBxt62JIA9YBr755D+BuuKGjonUTG8hmAv7?=
 =?us-ascii?Q?sFDC7tqhpMr4CBOSLb8FqNsDwj4Y5AA+MY25sdBO3K7iu1stmGwvZCa32MGv?=
 =?us-ascii?Q?wanoAriBOP1Ie6+FsnVodAskT8l5HfaQvmFI258p1lSe4WS0oXvtT402iYVc?=
 =?us-ascii?Q?//0Hxo57gRTR5bUhMeGmDPjjvkz/+UbdXOJ0tMKC0nfKK0ZvBkmYbSLbs9iz?=
 =?us-ascii?Q?3RlqH/IG8lVwTBfNHg8baDo+eyh0kQG2HHCvpfiRZy8wVWq56QCXO3QjBV9g?=
 =?us-ascii?Q?n9SlaqHOLXxG07C8hV4c3rPlQTmGZ3Zgk2aXRjhYFirfEkagxnvi/aPoL/Oa?=
 =?us-ascii?Q?Dbm0aJpIbINskpRTIofzswblLZr3cHvlQ3Qrqm5AfTZBEmSe5pC9gLDCHcyZ?=
 =?us-ascii?Q?4XXfF2OQkzzh4E6sR4fsofF8K3wEUC72OBJ50GnFRkWv6C7e/XfOBViAkIWf?=
 =?us-ascii?Q?VTFqUJKLgdiVYizAXqrkVcLL5rmfIpcqvoUGRpkAC5JyNK3NfyyakGxQ3CCP?=
 =?us-ascii?Q?/o7sQ7PI67r66f6jP1ugGzZ2MKA+Oy82nrFUUVpv2gD8kJEBfGBIlxuMwWcJ?=
 =?us-ascii?Q?1InhZL62xtDJsKbnqaE2MlGAJnf5TeUDmSttf64VIxYtwoyBy+F7k/1KyUFi?=
 =?us-ascii?Q?bKgDdEsWhEAcszII1tBah9ntzcfz7nuEoWfLEIXmbSZFxrp88vNnMXl2W5Bo?=
 =?us-ascii?Q?/FSemJi6EQDwF6tCGoBUdcCR2pLJL4yMoB6e6H87J01GEU5CqnyWKNpZhwIY?=
 =?us-ascii?Q?1n+SFC5oDI7ouc0QzkwObkvWeYqN?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc4f950-498c-40bf-1836-08d906be1cd7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 01:13:05.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1AuvxvAAXstW8PvTlFR+FjSvXBt3gIRJ7KJGhlDI4p3vuShDtEXB+eNyzT7B2msyQzVvlyc/90ZkQA4amDSkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the netvsc/VF binding logic only checks the PCI serial number.

The Microsoft Azure Network Adapter (MANA) supports multiple net_device
interfaces (each such interface is called a "vPort", and has its unique
MAC address) which are backed by the same VF PCI device, so the binding
logic should check both the MAC address and the PCI serial number.

The change should not break any other existing VF drivers, because
Hyper-V NIC SR-IOV implementation requires the netvsc network
interface and the VF network interface have the same MAC address.

Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Co-developed-by: Shachar Raindel <shacharr@microsoft.com>
Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

This patch was posted on 4/16 as 
"[PATCH v8 net-next 1/2] hv_netvsc: Make netvsc/VF binding check both MAC and serial number".

The patchwork link says its State is "Accepted":
https://patchwork.kernel.org/project/netdevbpf/patch/20210416201159.25807-2-decui@microsoft.com/
but I don't see it in the latest net-next tree, so let me repost it.

BTW, the other patch has been in the net-next for 4 days:
"[PATCH v8 net-next 2/2] net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)"


 drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7349a70af083..f682a5572d84 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2297,6 +2297,7 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 {
 	struct device *parent = vf_netdev->dev.parent;
 	struct net_device_context *ndev_ctx;
+	struct net_device *ndev;
 	struct pci_dev *pdev;
 	u32 serial;
 
@@ -2319,8 +2320,17 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 		if (!ndev_ctx->vf_alloc)
 			continue;
 
-		if (ndev_ctx->vf_serial == serial)
-			return hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ndev_ctx->vf_serial != serial)
+			continue;
+
+		ndev = hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ndev->addr_len != vf_netdev->addr_len ||
+		    memcmp(ndev->perm_addr, vf_netdev->perm_addr,
+			   ndev->addr_len) != 0)
+			continue;
+
+		return ndev;
+
 	}
 
 	netdev_notice(vf_netdev,
-- 
2.25.1

