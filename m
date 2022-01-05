Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE3485505
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiAEOtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:49:04 -0500
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:56900
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241071AbiAEOtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 09:49:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdTBdk+HUFvW05mpl64D64R0Uxp7rSpjknvsIiyrSFwAPBJfmXCab2PDpO9EHYwXHDEVo31nloVmjibEKGpfZePj8s7f388X7OwjU+8uVOfg8QrZ+EbyAQJi8AuPceUpw48GfHqbcQKSiG/r5tBfJHJLlm9rjL5YmF5n92iwAVuMQvhtLO74X4esDhEIhQWnqzR3t/25hqrpByerpe+xsCfz4/FfD37fKUbcNVIfmoRHiEX5tbSPnSmK45gz3hPt8Mkpqdqm6fHajd0qNDqQITUMcb+snxiGGXnYHSMKkOlBneWZcNql6HNhBETv5GjQ/X3TgGc+eppXE4IARu/dVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDBOKM0VDV+dWwwPijlLW5eiXsPc22iB7Z+CJo3YO0g=;
 b=k1BOKu1fXwTVWqYKACM0/01rsMS/7LhCu4Up73PGyIO2KnwUOujrTdPjjKg+OsvYaZe+qzVWafVdYX+XYuXUnDfF4vGdh1K8CWgP1DkqVBYRGxA0phAL0uAcXIaInJmCOnKcH+o7WQR3iJARF9TZ3HirzHV8tRxAkrbcyBSv1u0QOzBwGhFJ6hxENtRhKEPzPg+pzl8dltDWACOHbwSslettKac9HJXWrz5vF6UV+YfnWAaM9Z+q5/YDk7cOHdsNB8Wf5tlfoO11AJoinWYNAqFRWBC/Eq4PP+kMadikUqjED4k6P8VlbabgxXe4M2U1VfK+L5iQMfe1q69of4uNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDBOKM0VDV+dWwwPijlLW5eiXsPc22iB7Z+CJo3YO0g=;
 b=bsu85nd6wfX8IWGTgFJ0q7F0KGfim0l1THsXRN0lsJDETAabxSRBd6ral0iT82SRJ64vIiUyiKfN2862HN+DdrYBjzlHgIApHGPHzuYQP+7l2VFRLqc+nXuR2+07FNs8JmB0rWfhmOO8IqddCcPyoQE6xGnFzzQmAi/qz1HzH4lp0WlUHKSTRzuyUZcGP98XkKirIakl/ABYAFeMtiwBFmgCVkAHpwt1nDEJRxfaO5FnSM6PpbbKNY+X0+5YA7aO902ngEnBawobHuMmrm2knACajh6vCsqb0EcCAXRI6sqGdxBgKQr3u9ShNb40cmQ8Ej6xbCEl54wjPgkCYb3t6g==
Received: from SV0P279CA0013.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:11::18)
 by AM6PR10MB3415.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:ed::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 14:49:00 +0000
Received: from HE1EUR01FT043.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:f10:11:cafe::44) by SV0P279CA0013.outlook.office365.com
 (2603:10a6:f10:11::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 14:49:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 HE1EUR01FT043.mail.protection.outlook.com (10.152.0.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 14:49:00 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 15:48:59 +0100
Received: from md1za8fc.ad001.siemens.net (139.25.68.217) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 15:48:59 +0100
Date:   Wed, 5 Jan 2022 15:48:57 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH 1/3] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105154857.3ee15748@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105142351.8026-1-aaron.ma@canonical.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.25.68.217]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d6db1ce-16e9-403d-dbbb-08d9d05a828a
X-MS-TrafficTypeDiagnostic: AM6PR10MB3415:EE_
X-Microsoft-Antispam-PRVS: <AM6PR10MB3415E264846A98E44C057D62854B9@AM6PR10MB3415.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ji4G4XWTf0wgAI9hK6txvFcTBVKLAcHuzkjrlul9cRzuIILZyjgH3nYh2DrOL6wH9Ti6ThMt9pUsRPXkW+xU60o/e/bWbnei7k3Iv+w/4xBaC+j+mrVsuEMjcrufrinYBeitLQXLyCUuUiTIIlQ5Df+OX9Wz0uWW74IskXKgIynMJbxiU7bDTQtdCt0cL4QRUGvNiGIdsTer7itxbWJRm9MhrbQ1MeF+8NbYlJyGsNCTB8l9p8ZWzKvGhoyhmaWNk1+V6hPvlLUJTCx6Pz5RKDxh4/kOgTU7gqW51qWbrpcCtRQmhqXxSa3AZ60+FCItWyl3EEav5/t5pTKTj1XEKTM7avvNzYj5C8IRnuDyLaXRTLzWo4sYhV7s6YsPP2NE9TALhdBN40t/89q1HwQrD0N21myRdLPzAPyJXhqspt5NaFuwnFWevlusiodzFVlqJfzVHQGLE+6aryp0PaGH7qlN75CVzVtNgrXwA+ns1Iczi88FfwMIbajNSdyqdiBj5E0sSMgN7b5A4qdY8pvHoUIfbI5YAXyTs5sv6hPBGBjt7BKHReDU96cpSH+6neI3yZAskgM4sFXvNVl53rqYF1BA6q81BtVAznCCscmul7rh9BOs/0j2b6a3U0BB3MVQltcfKVedbDNca/m9DAz0wAyw++OA/lhFFkPTN2CT0xSQHledvBeb5Nvg5R8RDK+bnG5X6LRQcsyI6OXK1giipOtC87BSTSSwNBoPMSrVBDPHKUVct0A1O5uOqw3CPRyr8FFn1GM4SFd5UGkjwzbwdj7pWLiLFxBrf7m5Pl1K53s=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(83380400001)(26005)(316002)(16526019)(8676002)(9686003)(70206006)(36860700001)(186003)(70586007)(47076005)(7696005)(956004)(356005)(2906002)(6916009)(5660300002)(86362001)(8936002)(82310400004)(54906003)(81166007)(336012)(4326008)(1076003)(40460700001)(55016003)(44832011)(82960400001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 14:49:00.4470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6db1ce-16e9-403d-dbbb-08d9d05a828a
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT043.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR10MB3415
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No cover letter?

I think p1 and 2 should be squashed.

Am Wed,  5 Jan 2022 22:23:49 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
> 
> Skip builtin PCI MAC address which is share MAC address with
> passthrough MAC.
> Check thunderbolt based ethernet.
> 
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index f9877a3e83ac..91f4b2761f8e 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -25,6 +25,7 @@
>  #include <linux/atomic.h>
>  #include <linux/acpi.h>
>  #include <linux/firmware.h>
> +#include <linux/pci.h>
>  #include <crypto/hash.h>
>  #include <linux/usb/r8152.h>
>  
> @@ -1605,6 +1606,7 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa) char *mac_obj_name;
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> +	struct net_device *ndev;

reverse xmas tree

>  
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
> @@ -1662,6 +1664,18 @@ static int
> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
> ret = -EINVAL; goto amacout;
>  	}
> +	rcu_read_lock();
> +	for_each_netdev_rcu(&init_net, ndev) {
> +		if (ndev->dev.parent && dev_is_pci(ndev->dev.parent)
> &&
> +
> !pci_is_thunderbolt_attached(to_pci_dev(ndev->dev.parent)))
> +			continue;
> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> +			rcu_read_unlock();

ret = -EBUSY; or anything but 0, otherwise you get a random MAC from a
calling stack.

Henning

> +			goto amacout;
> +		}
> +	}
> +	rcu_read_unlock();
> +
>  	memcpy(sa->sa_data, buf, 6);
>  	netif_info(tp, probe, tp->netdev,
>  		   "Using pass-thru MAC addr %pM\n", sa->sa_data);

