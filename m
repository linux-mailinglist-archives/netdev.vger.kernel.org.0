Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F5484EBA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiAEHco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:32:44 -0500
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:16418
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231343AbiAEHcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 02:32:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXxp+Gr2WUyNh0RNVjImmW8ffaP/bXVSJ1GjGxbIqNRvZfyH3Wa1e+8/xg84/C4jk9GLTvp0TTRjuEjUI+XK0LdtFImrauLFiZSvATmg1k0QRrAYEJK9gfKXnX1Y4d/mdTYlBARbyEBWvewcle0cVQkRzdF7GyhrHUZtjflA+bg14lOibrFoiEP9ETKSqVzceMrFW+Ey/dmiqQMcLZ45IfX+8y1fseeWDj6dIqgzb8qWU3Qnbvlckt+7G2vu87kj0TSfAQw4TWpUp2YXsVkYO0myFl8xuPRSrUsE29/oojHPzorpCBD9HbHDo7cpY7XJG4Gc5WpnxTJloAX+dwzMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtRU0tBimJmnCG9+9fqhMKM0HuW2yuCvYArj4fx9Ygk=;
 b=lUG+KYDp5A+ecNi3fpzvp0a7A3yn89hKjbH/jR7RPuKlzkShayMCP6g4WR0N9UsLU31/CWK7wqqgxg3v6dRnEplZFaGU+UF5rp1IzsN5hJyBYRmpHjdHpe1lh6UHpN40+S6tLWnDEawXP/HA3n8kE+dyGTZKuo8nmod++Wf4EKyfzjUIkpfp4nTkVOcVvqHjNf0Gw3CCO6eoy6dgKOESacW4ThJ21OelXK5kDniuv4NWw1YnmR0rpNhUE2UiFFT3LeS0X5jINuIRM08+kN7Rte/QORVREorPLUdjeKSSGaGFZKetECqemr0majGR9ZpLbG6CEIBSAePc/MOZEQLmYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtRU0tBimJmnCG9+9fqhMKM0HuW2yuCvYArj4fx9Ygk=;
 b=Uc0ik5V1PzSxCYxt8HwJiTVV6PC5Vrazh4GpZilt5AjAHN6k4/EdL3fhJ1ABftAThJ0YkuAo9zxjnq9a2EPPbnczk5t4XvnOIQ1+CRMDEOINdgjOgLhr6R53LvH8SHp2lPb47R1ey2iF9A7R9m5TQmsojn26Ki3Uzg1g285id6jjNZGli8hSGcYm5lgP5cTSeQdYveZAUkvwW2mGvDzg9VAeEPJfOBEaB/EPlnfWuq0qEnFdLcOUuVTvcx3/x8GZdGfR4eKeqR9qN1G4ISF8ansImsDTBOl5tBN25ow9WOmW2BrYnIqeTc69fg18W95+L5ZRgvuSg6jWV6r7vIfrDg==
Received: from DU2PR04CA0034.eurprd04.prod.outlook.com (2603:10a6:10:234::9)
 by DB9PR10MB4348.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:229::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 07:32:40 +0000
Received: from DB5EUR01FT006.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:234:cafe::19) by DU2PR04CA0034.outlook.office365.com
 (2603:10a6:10:234::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 07:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 DB5EUR01FT006.mail.protection.outlook.com (10.152.4.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 07:32:40 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:32:40 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 08:32:39 +0100
Date:   Wed, 5 Jan 2022 08:32:38 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 280548fe-ee68-488b-32a1-08d9d01d8e3c
X-MS-TrafficTypeDiagnostic: DB9PR10MB4348:EE_
X-Microsoft-Antispam-PRVS: <DB9PR10MB43480A171EDB8D1929A598F9854B9@DB9PR10MB4348.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQtZFwDpf8HNmqvGKseEjum9t+V/fOEXJ5x4iwsA7UcWJ6nHKHMafMwez+gTewa/ZTUyLC+ZF9nqRBL9UzNBtPLjOHfyPoctIaOzdmVpkmBoKN3H5tIfqBFoIZ7A7AwJlAio0moQoZ93d5KbT3zP4c2xcBQUlw8W/2GSJ7DKju99ny7tEuniDugKl9zWWLZWm2O3hx84Yma31LNbmydld34/qaFZ0Liq3gCesVzAdhISzGYTDkJXMkSAdV67iskDUTIbzNaQ+8Jt3YOB9b0CAP4vNI0+Fm5Y4xusbk9Qq49/L1qdhTDuohKL82aHQlyBpn9o6jBl5Bu5WkHkyVLiSePpI3+sFP/d6bUeQ7dB7N5IqbDyoF4PP5owj1tZacZZ8m6suISg5Pr9OpPHMprHBRxWL13Y+kx6EiETq9nQDhqctA8lcQwyFc3SQ72rMjJ9v9yTPkk+SWFfZiAcpkvdUdUz3SGBE1YYGJMg64V4O6uMCrAVdz+eC8bmGy4GPX2BOZXU6tmj0WorXH7Jik8vkII9CtjIxCLtn/O+JW4oxouTHW7YWkV0AuykF3EZQXPXIm69O/5nmm671o/3S4M+l//JayVHlxp7XXgwMx1wi3Zz915KuDHO7udv8MUqIGaeE7mEH9mvtS9wRXdXKHfYmZynKujLF+kU04Y9WppyFugTm8H88zUIbZ7YYx1I2U4SG7BKJnuyClK7+R0JC4SRDK7RxIHw+2BGe/d50JIfmM4BxKk+SHH+6pzfmJtA6IHyYD7sTyfhgo16oHjFCMGJRJAJyexwKlscCWqz2+Y8hlw=
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(81166007)(508600001)(44832011)(316002)(2906002)(5660300002)(36860700001)(7696005)(8936002)(70586007)(82310400004)(16526019)(55016003)(82960400001)(356005)(40460700001)(186003)(54906003)(4326008)(26005)(86362001)(8676002)(47076005)(336012)(6916009)(70206006)(83380400001)(956004)(1076003)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 07:32:40.7949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 280548fe-ee68-488b-32a1-08d9d01d8e3c
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT006.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB4348
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 08:23:55 +0100
schrieb Henning Schild <henning.schild@siemens.com>:

> Hi Aaron,
> 
> if this or something similar goes in, please add another patch to
> remove the left-over defines.
> 
> Am Wed,  5 Jan 2022 14:17:47 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> 
> > When plugin multiple r8152 ethernet dongles to Lenovo Docks
> > or USB hub, MAC passthrough address from BIOS should be
> > checked if it had been used to avoid using on other dongles.
> > 
> > Currently builtin r8152 on Dock still can't be identified.
> > First detected r8152 will use the MAC passthrough address.
> > 
> > Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> > ---
> >  drivers/net/usb/r8152.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> > index f9877a3e83ac..77f11b3f847b 100644
> > --- a/drivers/net/usb/r8152.c
> > +++ b/drivers/net/usb/r8152.c
> > @@ -1605,6 +1605,7 @@ static int
> > vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
> > *sa) char *mac_obj_name; acpi_object_type mac_obj_type;
> >  	int mac_strlen;
> > +	struct net_device *ndev;
> >  
> >  	if (tp->lenovo_macpassthru) {
> >  		mac_obj_name = "\\MACA";
> > @@ -1662,6 +1663,15 @@ static int
> > vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
> > ret = -EINVAL; goto amacout;
> >  	}
> > +	rcu_read_lock();
> > +	for_each_netdev_rcu(&init_net, ndev) {
> > +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> > +			rcu_read_unlock();
> > +			goto amacout;  
> 
> Since the original PCI netdev will always be there, that would disable
> inheritance would it not?
> I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME)) is
> needed as well.
> 
> Maybe leave here with
> netif_info()
> 
> And move the whole block up, we can skip the whole ACPI story if we
> find the MAC busy.

That is wrong, need to know that MAC so can not move up too much. But
maybe above the is_valid_ether_addr

Henning

> > +		}
> > +	}
> > +	rcu_read_unlock();  
> 
> Not sure if this function is guaranteed to only run once at a time,
> otherwise i think that is a race. Multiple instances could make it to
> this very point at the same time.
> 
> Henning
> 
> >  	memcpy(sa->sa_data, buf, 6);
> >  	netif_info(tp, probe, tp->netdev,
> >  		   "Using pass-thru MAC addr %pM\n", sa->sa_data);
> >  
> 

