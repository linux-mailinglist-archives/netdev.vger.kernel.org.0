Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DD4484EEA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiAEHzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:55:32 -0500
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:45634
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229880AbiAEHza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 02:55:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjQS30XJR7pdq4Cf/1MoqqPzaOGy0d9nW7NOPzKcRJ7I7JFOqw7fYv9yb/hM4BzCAlWI1qj2/zbYDyi6oZvy21Z+QS54eWmFXbOdcL0fq/+J9w7SFo/npVt/v5CDCyTq/jOlYx4mIbxMCE8Quc5y5R4r+So5RzQbfAiWBwVFtZ1THTcfQ6vIAvAalK0muze0XKm2+b71mju2F6okCwCT3PJToWhVWGcUR6T9ivKKHrdlg6pCiWVlh10l/cIT9qSJWLjU7bqwxRAXatjr+1UdZFdXG9z0XVbS1DJ3mCtWz8hoCSkWT3fQ/yz0UT25VzEA8gv/pfA5OiuLTPL9zidNMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmG5A8J9BnYimQd/RqAI6NXOr+96+iOdS1mpNeDYDOk=;
 b=JbiQ2OMzpdryLE14jl52HkAcu35XD2peUdMu8mR9953WXVozNpCg5p7dS599J0gjWSEwpBZaasndyMeLVO68KJ55lJpiSO7T0kzJDIo+QEnd3/BwO0hJiDto8Bgek4qqIu4QzPF0bMY2hjeFa8ITWHIACu0Hm4TuTQs9tMp/HYMvId82PSBCqrsRXmOA6Hdlwhf2gAQrn812idy9y1/3P7ZCF+fHJiRw6So7vk0Z3uT1QSJUlyUL/tlBnPd9BPD1w8iiO7cuOlgoVR27p6fnM16UKCwd1j3c7uZAXjwyS78wupB8QVE8yFiV6MhppCyOWg+4XxXyaLfIsXw+5/Hnyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmG5A8J9BnYimQd/RqAI6NXOr+96+iOdS1mpNeDYDOk=;
 b=il7hi6YYzpoDmMf1WsTFzDoKYgFe+mFiVjK0EzSF8xDXXRBo7mv4221lSTQKQO9XXJGhtcr4p8dUnkciIGP7XLqKomc+kZJlMwIlZ8jxx2tYmj4wRo6YF6LyLOr0STQmZK8/f464LDisLOFraGJzyDVpBYB1f/8r3TVwdZgSQWInewS08FIrU9Lua/0K/TFLKvb1dYAD2uQ4jyF0xtbTELkEdEVNyGRFYy9PeAdI6dAdOsZ7DZgL19egSPOMgLUa6RWSVTVJbgTyk9gQz3rquo13wi9Oxw1i1pR7L9w7YoGOMMibZBltbCvSOoGXqxqFxAk1PBsNtJ1jbBbgsdRN3Q==
Received: from AM6PR04CA0012.eurprd04.prod.outlook.com (2603:10a6:20b:92::25)
 by PR3PR10MB3884.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 07:55:28 +0000
Received: from VE1EUR01FT051.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:92:cafe::e3) by AM6PR04CA0012.outlook.office365.com
 (2603:10a6:20b:92::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 07:55:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 VE1EUR01FT051.mail.protection.outlook.com (10.152.3.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 07:55:27 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:55:27 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:55:26 +0100
Date:   Wed, 5 Jan 2022 08:55:25 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
In-Reply-To: <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
        <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
        <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f693d0-4931-42d7-f59d-08d9d020bd24
X-MS-TrafficTypeDiagnostic: PR3PR10MB3884:EE_
X-Microsoft-Antispam-PRVS: <PR3PR10MB38844E31D612ECD9676FCB06854B9@PR3PR10MB3884.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EulOrU0A6GHe3K5QWwzsNbrNWHH/iZyWAY0I9kH/bC1N8WRATwb2huNlSEqAKAjGuZmi8m8pqn4d8XXbav8DPCNLwEjdRDJJMtJ7bcyvqaKROoYhz23WrJV9Yb6ypceI3kwXzrDWPO59qOi57jJisdnPGwpfRJ/HSyVumvzX8TTnIlU1PX31X/amVjYPfJ8qVgCkZwXOCns7nPP0WYGpPwe5+Pv9wvfYXEgXrE3H1tvG7CdALbQ9fy94fG9ZyfQnoTozuJ5xO/mX+XSv7aqyb74w2xo1hV5KitsURu68zAz3shSzobx7eOPf3c8OVTakAhT0RRxYnoEQGeBBNqghzC0WOIiH6vLXeofQUAmBM/HWl64yJ07jENd/3XC5EWNNe/MkBdxSRSIH3HXl8LDuCLWMozdDEl0gBBW7TQ90Zomdo9Few8vcp+MPcS5LNcg+MNEOa7HudpyiC7z7Zbbzku4HzOUwz470s13MTdlMg3kGKCkqRiAvRu/m167CKQIuQxjxMUfa7lV4xuU+Mf+2cda3ZrAORvrJpzjYGiFfZ8guqX/6yWAn7EdU3n4lSzl8KqnEe+k0WU83ctpLbO2iVmjfkxnTJGHV+OkBobAQPYfJMgcm9QkqiBALmzqzhpJTIZuTW8MyTjTt14tPPJkyuOgDk3jTeLPS1TREioXl4ThGYBklWSbT7sX4X9ShKtSckJO5Vkqn3c3ZurI8VwStd3X58rkUcC5cBFErwwYVHuQXOxX4+PnAyQqnJHUWVPWtujIjtorzaW7DBewzHWcYN3SMMDJsN+6juYzSFY+nalQ=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(40460700001)(6916009)(83380400001)(54906003)(1076003)(336012)(4326008)(36860700001)(8676002)(86362001)(44832011)(316002)(26005)(82310400004)(5660300002)(55016003)(9686003)(7696005)(70586007)(2906002)(81166007)(8936002)(16526019)(70206006)(356005)(508600001)(186003)(53546011)(82960400001)(47076005)(956004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 07:55:27.9948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f693d0-4931-42d7-f59d-08d9d020bd24
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT051.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB3884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 15:38:51 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/5/22 15:32, Henning Schild wrote:
> > Am Wed, 5 Jan 2022 08:23:55 +0100
> > schrieb Henning Schild <henning.schild@siemens.com>:
> >   
> >> Hi Aaron,
> >>
> >> if this or something similar goes in, please add another patch to
> >> remove the left-over defines.
> >>  
> 
> Sure, I will do it.
> 
> >> Am Wed,  5 Jan 2022 14:17:47 +0800
> >> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>  
> >>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> >>> or USB hub, MAC passthrough address from BIOS should be
> >>> checked if it had been used to avoid using on other dongles.
> >>>
> >>> Currently builtin r8152 on Dock still can't be identified.
> >>> First detected r8152 will use the MAC passthrough address.
> >>>
> >>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> >>> ---
> >>>   drivers/net/usb/r8152.c | 10 ++++++++++
> >>>   1 file changed, 10 insertions(+)
> >>>
> >>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> >>> index f9877a3e83ac..77f11b3f847b 100644
> >>> --- a/drivers/net/usb/r8152.c
> >>> +++ b/drivers/net/usb/r8152.c
> >>> @@ -1605,6 +1605,7 @@ static int
> >>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
> >>> *sa) char *mac_obj_name; acpi_object_type mac_obj_type;
> >>>   	int mac_strlen;
> >>> +	struct net_device *ndev;
> >>>   
> >>>   	if (tp->lenovo_macpassthru) {
> >>>   		mac_obj_name = "\\MACA";
> >>> @@ -1662,6 +1663,15 @@ static int
> >>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
> >>> *sa) ret = -EINVAL; goto amacout;
> >>>   	}
> >>> +	rcu_read_lock();
> >>> +	for_each_netdev_rcu(&init_net, ndev) {
> >>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> >>> +			rcu_read_unlock();
> >>> +			goto amacout;  
> >>
> >> Since the original PCI netdev will always be there, that would
> >> disable inheritance would it not?
> >> I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME))
> >> is needed as well.
> >>  
> 
> PCI ethernet could be a builtin one on dock since there will be TBT4
> dock.

In my X280 there is a PCI device in the laptop, always there. And its
MAC is the one found in ACPI. Did not try but i think for such devices
there would never be inheritance even if one wanted and used a Lenovo
dock that is supposed to do it.

Maybe i should try the patch but it seems like it defeats inheritance
completely. Well depending on probe order ...

regards,
Henning


> >> Maybe leave here with
> >> netif_info()
> >>  
> 
> Not good to print in rcu lock.
> 
> >> And move the whole block up, we can skip the whole ACPI story if we
> >> find the MAC busy.  
> > 
> > That is wrong, need to know that MAC so can not move up too much.
> > But maybe above the is_valid_ether_addr  
> 
> The MAC passthough address is read from ACPI.
> ACPI read only happens once during r8152 driver probe.
> To keep the lock less time, do it after is_valid_ether_addr.
> 
> > 
> > Henning
> >   
> >>> +		}
> >>> +	}
> >>> +	rcu_read_unlock();  
> >>
> >> Not sure if this function is guaranteed to only run once at a time,
> >> otherwise i think that is a race. Multiple instances could make it
> >> to this very point at the same time.
> >>  
> 
> Run once for one device.
> So add a safe lock.
> 
> Aaron
> 
> >> Henning
> >>  
> >>>   	memcpy(sa->sa_data, buf, 6);
> >>>   	netif_info(tp, probe, tp->netdev,
> >>>   		   "Using pass-thru MAC addr %pM\n",
> >>> sa->sa_data); 
> >>  
> >   

