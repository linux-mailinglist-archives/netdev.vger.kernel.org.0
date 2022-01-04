Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4034846AB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbiADRHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:07:21 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:19562
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230311AbiADRHU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:07:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNiYi8e/EbnfWvCEYugDL+5Qc9TcHYo80DFxUY4zgDDe39JxJ7iKWGD9A9XVMjMXjVAphMcNIuy6Ab5NJGok0mXy3PKrcmhTnHQ2fxbu40htZPrbvRJFst0DTFRgGdnAEjOV+KQxBm4WxuxkanUfNK+yTTuky7jV4YyVLOamBRuuXSt/rQgy5au6LpiUfg1BUlv/Dv1KYonb+qeDUcQdhnRdWbpznicQEksimcc8MfjUpsItvPy9qa/eoNWda6IH95ImroybGjLj8nJms6jMX2Hbabt/1cQTlsn+0Pdi3ADfp422+sSwJR15+MSHuaQo1TvCBW/E/DHqta0DbmMD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkzOv9FS08M/QQBh/jfjHY5z4Ru3eH9gwXtCrhXlXAw=;
 b=PdcR6iX9Lth3wViatcoBoGtFZ8CejWgCocnKzw+48ispD3s9mGxzv2cbl6W5vIgeSPwxrukqgpUllvU99Uv/9y8KgyUzan8QyUadFL7nIAHWmi/PI3GRqZPRqj0i8TLobbCHo+Y8ya8hPSBtsIpMrSifC/6S8iesKRp2pZBNwR1J1G9/j/+u4ZYOEYReJsCnx4goE5BilOfE3brfPw3k+o7Ji0CKyPVNnJf7gshrKrsg0BJwv7wVzfYUuUUDcs3IVICPpivZGHQJhrI4JMw4CeCXfiUJQWzgr9Q/Bqyd0esacwMb5+cCFF5SYSDOO7SYRVryiGIeIw2DqKxD0PIn9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkzOv9FS08M/QQBh/jfjHY5z4Ru3eH9gwXtCrhXlXAw=;
 b=FTlGlDQ83D13SqXDif+KknFa2uQo5cQddyk6Q5by7nXB+lPoB7cGppZlqbxqXAfbGwb57Kg4zgHHXNI5ApJungz5PZPiNnztbstlrsZ+aRLBfMR6mh43GBRCweXL2ofBdX78PWnC8UfcqOm0oj5zDOOpUJHkzpYd9fDUID2rJVtIIJ7HcVvB463adrMi8/p8cPNevToi6BAmne0bYDhHceBn7RVi7IrNI1tASuejYfRSaOWyCYolUgTTTOnGiSL5MaQ7pKxF2NjplR3uI6BEm8UTK/2mVhZcJG18HMnZzsoObHDkn3/e2NF0UuXp8JpuPxHm5Y6GvIXeECPmbWAgPQ==
Received: from DB9PR06CA0016.eurprd06.prod.outlook.com (2603:10a6:10:1db::21)
 by DB8PR10MB2809.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 17:07:18 +0000
Received: from DB5EUR01FT026.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:1db:cafe::c4) by DB9PR06CA0016.outlook.office365.com
 (2603:10a6:10:1db::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 17:07:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 DB5EUR01FT026.mail.protection.outlook.com (10.152.5.2) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 17:07:18 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 18:07:18 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 18:07:17 +0100
Date:   Tue, 4 Jan 2022 18:07:15 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Aaron Ma <aaron.ma@canonical.com>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
        <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38753eba-a235-41f5-7dc0-08d9cfa4aa30
X-MS-TrafficTypeDiagnostic: DB8PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DB8PR10MB2809977A3F4D61CC5CB551A8854A9@DB8PR10MB2809.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VsltuRCghmDkREJ3ArHwczhKY77tb2wTCTwvpu8LuvCEEMN1ocuw6gF73cWzFVvmbiQ+LHGi7kn2xIO6oFivqiaSpd74ITtKUzT0PNJ9stwPL751yXMrf8jSp4X3OUHE3hes6o7+7byf2Nqj5aLI116VKdutRJYF3PSLut74TJRb+MzhTssUU978mKFWJQvckt796eJ59Y7A5rPw7N6UidyWx7LcBb4Ps4LJMosyRo9pOgwNJ8jiGlMWfutGrdKv8fuvCJii0Gc1ukO2mAi2JrHui97y3nEnHvpcBny2BKbULOesM17ED7u7gh69hi8aZmtaB17VqtO2YzuLvkfctndgtA1SN/pnz+a2NQ2u4462Q3EktLMm6C2/168SR2YosxccsauWcfTUAfmprHvpjUogGnytXvVL4TScSaHR/MUP/KTcPbJ/mqe6f39FmjJu82yJmPEooaGTN/4G2pISY4QOYpZxMv0T2ZeyMm9hMkmEBe3y6Nu326mFCN7ZaYpD8nF1dsBZuskCpqP6gQIQZVApuoA9Yaccs4VONMxa1au7ABK1hJgJkHu0HkRT/el/19e4b4eoE04lNWuxF3smSv2ZcnDEln9ST5LtUpFpOIT0zhTM20HaukNbGlY06cZrBFvzVScJGka32NW91aXawhQmKnHyNDv60QeL2k0R8BlQiLR5UcwKKMJ8wRHu9i3lEAyd8a9uWxhpgESC1h495TMA0kE13LSK+eFetQi92PLrORjHX7LhWwKW1/rWEV7GFQjg60znbvnEqDEV+rD+/PCuHmpvkhiSJqHYSUKduVU=
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(26005)(55016003)(83380400001)(9686003)(2906002)(36860700001)(70586007)(70206006)(16526019)(47076005)(186003)(7696005)(54906003)(6916009)(356005)(5660300002)(86362001)(8676002)(82310400004)(1076003)(8936002)(4326008)(40460700001)(956004)(81166007)(336012)(44832011)(498600001)(82960400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:07:18.5745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38753eba-a235-41f5-7dc0-08d9cfa4aa30
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT026.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB2809
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Tue, 4 Jan 2022 06:53:26 -0800
schrieb Jakub Kicinski <kuba@kernel.org>:

> On Tue, 4 Jan 2022 12:38:14 +0100 Henning Schild wrote:
> > This patch is wrong and taking the MAC inheritance way too far. Now
> > any USB Ethernet dongle connected to a Lenovo USB Hub will go into
> > inheritance (which is meant for docks).
> > 
> > It means that such dongles plugged directly into the laptop will do
> > that, or travel adaptors/hubs which are not "active docks".
> > 
> > I have USB-Ethernet dongles on two desks and both stopped working as
> > expected because they took the main MAC, even with it being used at
> > the same time. The inheritance should (if at all) only be done for
> > clearly identified docks and only for one r8152 instance ... not
> > all. Maybe even double checking if that main PHY is "plugged" and
> > monitoring it to back off as soon as it is.
> > 
> > With this patch applied users can not use multiple ethernet devices
> > anymore ... if some of them are r8152 and connected to "Lenovo" ...
> > which is more than likely!
> > 
> > Reverting that patch solved my problem, but i later went to
> > disabling that very questionable BIOS feature to disable things for
> > good without having to patch my kernel.
> > 
> > I strongly suggest to revert that. And if not please drop the
> > defines of 
> > > -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> > > -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:    
> > 
> > And instead of crapping out with "(unnamed net_device)
> > (uninitialized): Invalid header when reading pass-thru MAC addr"
> > when the BIOS feature is turned off, one might want to check
> > DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking
> > the BIOS if the feature is wanted.  
> 
> Thank you for the report!
> 
> Aaron, will you be able to fix this quickly? 5.16 is about to be
> released.

If you guys agree with a revert and potentially other actions, i would
be willing to help. In any case it is not super-urgent since we can
maybe agree an regression and push it back into stable kernels.

I first wanted to place the report and see how people would react ...
if you guys agree that this is a bug and the inheritance is going "way
too far".

But i would only do some repairs on the surface, the feature itself is
horrific to say the least and i am very happy with that BIOS switch to
ditch it for good. Giving the MAC out is something a dock physically
blocking the original PHY could do ... but year ... only once and it
might be pretty hard to say which r8152 is built-in from the hub and
which is plugged in additionally in that very hub.
Not to mention multiple hubs of the same type ... in a nice USB-C chain.

MAC spoofing is something NetworkManager and others can take care of,
or udev ... doing that in the driver is ... spooky.

regards,
Henning
