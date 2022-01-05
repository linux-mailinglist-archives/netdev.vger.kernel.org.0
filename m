Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88B5484EB0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiAEHYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:24:00 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:53377
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231343AbiAEHYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 02:24:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkisdptsalBFx/z3pCO3Frs4hUPcTIb+aH5IhYxSdf1u6phP9fjhl0kUS8p6lSSTP8RaDQhvDnzz9r0m+lawK3QTw8OxcLTeArv2T79XjCJ13NL6cul0iZCXBYvqw+g65Alztan4GKThBMU7jKQrLCljlqAzevYgOgHuujgrIFDw9eZf29etaIxEZ6O0D465rNy/siARge228Fold8vNXTp/4id3VrWFU2Mm3nojH12bBlHteAIDzQekqkC8biooF+5m7L3d3d2CVVous6P1mX+6KvY8V60VzJVZALUNUVemzda/SVV3dM4hSYWm+ADxI9ch87Mkfabx1eQ44CXhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2LJO0USAmyU16zDTnalXq6gMPPNPfBgbfeF8dDSb3M=;
 b=PDhuOWh+3yLYsOlFuJ6TQFY5CmqdBWAUSdATbtkHSv1O4iJpQHqcNz5DDbIb8d8aj6765eZd7hXwdSkqodWO/4LSs+70n/QJFWdN5F/vWxVbquPdhAE9MYDsfqLyx3l4rdQzlYzWEDnsAYB+MpSVZazw5OXWHhbxCPhv2tfZ4Knr4EWHmKuiB2kvjEGa7dEQEVdMA2MJiODBNrfNBz9E6Z0s0HiRlC2TXZQtoLzQRg+7ru4nHVAXnMYgnB3NKaWu/Yr+QWxZlrlKx6H9Olok7G0SKF0riwqBZRlqVYo+rEnEVvrc3WjHuHpZRi0nQ0N2a1D4J50gAUGla5enGvm5Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2LJO0USAmyU16zDTnalXq6gMPPNPfBgbfeF8dDSb3M=;
 b=oeKSX3uJ8AIYhhpEaj3QpeofYvXIueFeOAF1IKjUItBf+nX14fDoZqBPNtHEmpY41BOnCpD1tElcjVyOGoUQ1tzkkatqnn2/X/9UhtiGap/v3T8rb/NIcJsHB8hvVta2sX/jmCbui253CI4aAumwl8egQ6oggnptxRDH07nERUzkPjkdVnMWuH3IJ7ygFCmWGi3xTvtsQnGMyDCnH5wxGmQHRB6aoxhXkRhGh2yevclOvhaQJMQPpuSDVJXUYWO1/5ruyRbAdfSWk5qYDEin/MfD++/8yoGPgGdG4e2XH1/KCd9oaDVtj9IHiOZy1FYWJGLHhnYQ3sqJUDm6eVsNTw==
Received: from AS8PR04CA0099.eurprd04.prod.outlook.com (2603:10a6:20b:31e::14)
 by AS4PR10MB5370.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 07:23:58 +0000
Received: from VE1EUR01FT031.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:31e:cafe::e7) by AS8PR04CA0099.outlook.office365.com
 (2603:10a6:20b:31e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 07:23:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 VE1EUR01FT031.mail.protection.outlook.com (10.152.2.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 07:23:57 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:23:57 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:23:56 +0100
Date:   Wed, 5 Jan 2022 08:23:55 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105061747.7104-1-aaron.ma@canonical.com>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d7ebaba-bf0e-476c-fde9-08d9d01c5680
X-MS-TrafficTypeDiagnostic: AS4PR10MB5370:EE_
X-Microsoft-Antispam-PRVS: <AS4PR10MB5370BE8F23CD26A3730857AE854B9@AS4PR10MB5370.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtPbFeJOxfLofvT++0wlEWADryh0tbKlHc4KmR7GwqWfNLY9olplccac1nwyf/CbfYwcMRnS/zi5Gk77dqbmBoi4wFWZR65mIHpYlBCw6Gztv1z3T7+myP5kyXIpuS5mFiy94rhZ6oRNUz286inXWZKv01uD/1OHVukD1+W6G2zH1vUghtSey2Nh4ty7Tc/qfx/OSZ7iJwYlY8c0JSQ9YBTZEXuVvOdoYAjHcqSLXc8G/UP89KTAaE4yLGSZs0ayu1w8Ry+FRoi6GIdcl1OobTzt6NsXTp4T6GdmuB6gy6yHS2Ap6qIyDRXRHvcnDB93nO24fkz1tUaG9v70xUI/XnDiFzS6pf9WrgwHtpjeVscaj8CVSAQiJpCuMlaeLiNwMxVHaWY7/mIz7BkD/+DKUL+0LQfc0sJ2crlxM1e2d+v47zwBO7XCf/hGnflRsGqVV4m1PcaLqcjCanPvt0HOrKlwVenhMgczOmBHHhQXTO9OlMy07VshXq/6WFMgMiR/gXqwJBU6G/K80NaN0O90NtjtDQm5Y72FgMSMDtAPf649dbdNBvckhQyig67taQ+UHzHi/ouqIqmaoP8rPVlhAarJkFypA5tknQqvxbeVFBbzD9kHNUfyOxzFcsJ6hd1GabJf5zEQq4S7TAqhhgOGSavmxi6f1D4RkCVg3Y+FlOJgUB/0vKAuhxyUuV+PNNNWy1VwrO1sj53CAEFlKeBHcLnPVCFYAPc5J7bEIMF7A1laaifqI/osLMwXjV/xEiIuncGUtmtUrPeEYgOOsKJd/gth/p/jPlyh/4Hcu1FQWdE=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(316002)(44832011)(4326008)(70206006)(70586007)(5660300002)(1076003)(2906002)(6916009)(8676002)(54906003)(86362001)(26005)(186003)(16526019)(956004)(7696005)(508600001)(8936002)(83380400001)(9686003)(356005)(36860700001)(55016003)(82960400001)(47076005)(82310400004)(81166007)(40460700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 07:23:57.7966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7ebaba-bf0e-476c-fde9-08d9d01c5680
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT031.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR10MB5370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aaron,

if this or something similar goes in, please add another patch to
remove the left-over defines.

Am Wed,  5 Jan 2022 14:17:47 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
> 
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index f9877a3e83ac..77f11b3f847b 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1605,6 +1605,7 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa) char *mac_obj_name;
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> +	struct net_device *ndev;
>  
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
> @@ -1662,6 +1663,15 @@ static int
> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
> ret = -EINVAL; goto amacout;
>  	}
> +	rcu_read_lock();
> +	for_each_netdev_rcu(&init_net, ndev) {
> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> +			rcu_read_unlock();
> +			goto amacout;

Since the original PCI netdev will always be there, that would disable
inheritance would it not?
I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME)) is
needed as well.

Maybe leave here with
netif_info()

And move the whole block up, we can skip the whole ACPI story if we
find the MAC busy.

> +		}
> +	}
> +	rcu_read_unlock();

Not sure if this function is guaranteed to only run once at a time,
otherwise i think that is a race. Multiple instances could make it to
this very point at the same time.

Henning

>  	memcpy(sa->sa_data, buf, 6);
>  	netif_info(tp, probe, tp->netdev,
>  		   "Using pass-thru MAC addr %pM\n", sa->sa_data);

