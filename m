Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4594847F2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiADSfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:35:02 -0500
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:60001
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236373AbiADSfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 13:35:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfMIaMt+ZIJxFZiAWw5nDgG8aV1bmQei7YWRAF20+Qok0mZ5dcOWWFPgAtd9RLNGb0FAQVrF6s1bOY4D2MYZ9ZTv9NozH5UsiyF/mEDARMS9iRYaVOsR8TgH0gV27TNjzYEClWC/W9ff09/cUi9hdptuVCL745by6ipx2WNGRkuqKYKS7+TlxFUlVceWkrZHKjPB6+OLfQBFkVfyZNRyaqMOGZHLpGcWf7Q0maVvcylft4KWs60KGbNwjVJa12jD3rseCaYFu6C50sAiQIUj4cKDHvMcUBN1SLiVEAvjPvkMzU5xmFwc5+x51BmG6gl+cUZGkESNOxHg/y4pp3fuPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zvDCDD5wFKKalxOxJ7/p8SZfAsbXvCiCoziHV8q/2w=;
 b=nlLHzjLxmouMNpiCNTzTZ1jGtTD9t/AjCTlY0nJIIiTJmvHV2PyYnPGBUaHcr6lL9JjsC4zVDDr6bCTbrRPTR+o3/Dp2uaQjK2f3dbk25dr+u94zT8hO21aP9RTQ1K0w5nyt4SPKpVwCYRwvGls04Pzf0/pB8AF0msXit6bHpFfjl2vLb/94tXDROBcmc/4FOGEBqW5NlA3f20FgrAZLTcTS1I9CRBd3sSAYPKpL7JnxKxHcr7baE0SvH97LnkMJC+lMnsqDr9G+eMi4MZzIe3GpkB8bAnKyh9Nnv8Hh8uz6LCByuYY31C3L+25+UYUQvpv5Bg3fozQ1IAPxHDQLzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zvDCDD5wFKKalxOxJ7/p8SZfAsbXvCiCoziHV8q/2w=;
 b=g9Y8ZpoAYOU2DkwndGu1TttTELIhHNgjQ1vwkTk4lJm0nQtOgBxnU2PzhFTM/taE46wl3imvTaRLyHGSX1t2S1EJ8dEU5LGNC/Fy0ZIB1wRK2O9zRnJD+j4o4YjM2T5B7JR/ycOKuB8kDtBF44dWV6t2pukBhJjZ3kj+yl/bPoveYu1yuWJ5VFMbTqkBwf2xX41vBsvnS1q4jCBMo8MNX6pGa6d13GQ/Zn/8PefgBCp18V5XNz2UzsFRIlxNbAoLWnb5W2lvEPDNYqc4i8h/IqtjW2CA2IFPqAriPBNHy403spkbZRy0sq9GWhCInxPoOfg4tN1shWROjW7LSn3Pfw==
Received: from AS9PR0301CA0055.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::25) by HE1PR1001MB0986.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:3:72::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 18:34:59 +0000
Received: from VE1EUR01FT036.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:469:cafe::4f) by AS9PR0301CA0055.outlook.office365.com
 (2603:10a6:20b:469::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 18:34:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 VE1EUR01FT036.mail.protection.outlook.com (10.152.3.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 18:34:58 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 19:34:58 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 19:34:57 +0100
Date:   Tue, 4 Jan 2022 19:34:55 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104193455.6b8a21fc@md1za8fc.ad001.siemens.net>
In-Reply-To: <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
        <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
        <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10968905-cf3f-46c9-2683-08d9cfb0e977
X-MS-TrafficTypeDiagnostic: HE1PR1001MB0986:EE_
X-Microsoft-Antispam-PRVS: <HE1PR1001MB0986C3BE22D88EAF0E808592854A9@HE1PR1001MB0986.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKA19cSbaFOpr7LgXXJjk7pBxgxHX3lvWdXQx+MR2+xwYKnNBos8BBlNCQEdEIKqRTv2x5A1guEs9IJWAz1sOgdqiY8PJR24JXe5kd4MRhy78fe3IMWrn/rrsLtqzLS6zCWbyN34is9Pw0wi4WMQE0uGAJhhYn0obWcAu18fmOHsS2y00Ny9fHZYmsmzaJz1vFM/lz02ffuK0YzQF32tV0CoXpA8uSmf9MTmy7IMaOoxgOPxJCwKpaqCrZMav0we6rK/0nR/BTIHuSig4BHc5gV0011FZ7+ZeQtmvhk3s1Npm9Y3oksCKpcqPLgmZYIHVMla0WloI7DnlaRxPSabJJE75I2H1Lx2spFBIXNa8oW4NVw0rtaItjPfsT0pHby2/GcUXp/H44djFb5IpYN2RA2KgKeoUlClqHmOkJ18ZutuRWZ5OFs6Y69v8jT6nyIQo3rV3yE+UAntv+ox1oFvlC6gyXkrXay52Y/iTqoZggBtthcCO3ATgHVmMQtcMTKzmkHeG2tJlsvkjJaan9P1m7PWv3UwFIIJgdmyQp+lE0GIUWQm/xwIe01CTzwWBqvlk942XCfEc1+YLN1wtc1ga3oojEWmpJA7Hv6enhat48CuVcv3z+B9lB53EqPZwAweOfKvm3ysyAlJro8gdvJD+uiVVQf4c1tiJDx8mQOqb7/DvKVFHXsxSHQvX7swdkBegjp+JvlscuVD7wa3nX4XUMuxDN3P43EafPgmP7DqGZ0PTwxuGzDrvQaM492Tl7ZbGDMbWv0bZb38+RqmuRMTbLLdfYrxKixBf7ycI7lNqd0=
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(7696005)(54906003)(4326008)(40460700001)(44832011)(2906002)(336012)(316002)(956004)(5660300002)(53546011)(186003)(356005)(9686003)(26005)(16526019)(82960400001)(81166007)(508600001)(55016003)(6916009)(82310400004)(83380400001)(1076003)(8936002)(86362001)(47076005)(70586007)(70206006)(8676002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 18:34:58.7260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10968905-cf3f-46c9-2683-08d9cfb0e977
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT036.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR1001MB0986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 01:40:42 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/5/22 01:07, Henning Schild wrote:
> > Am Tue, 4 Jan 2022 06:53:26 -0800
> > schrieb Jakub Kicinski <kuba@kernel.org>:
> >   
> >> On Tue, 4 Jan 2022 12:38:14 +0100 Henning Schild wrote:  
> >>> This patch is wrong and taking the MAC inheritance way too far.
> >>> Now any USB Ethernet dongle connected to a Lenovo USB Hub will go
> >>> into inheritance (which is meant for docks).
> >>>
> >>> It means that such dongles plugged directly into the laptop will
> >>> do that, or travel adaptors/hubs which are not "active docks".
> >>>
> >>> I have USB-Ethernet dongles on two desks and both stopped working
> >>> as expected because they took the main MAC, even with it being
> >>> used at the same time. The inheritance should (if at all) only be
> >>> done for clearly identified docks and only for one r8152 instance
> >>> ... not all. Maybe even double checking if that main PHY is
> >>> "plugged" and monitoring it to back off as soon as it is.
> >>>
> >>> With this patch applied users can not use multiple ethernet
> >>> devices anymore ... if some of them are r8152 and connected to
> >>> "Lenovo" ... which is more than likely!
> >>>
> >>> Reverting that patch solved my problem, but i later went to
> >>> disabling that very questionable BIOS feature to disable things
> >>> for good without having to patch my kernel.
> >>>
> >>> I strongly suggest to revert that. And if not please drop the
> >>> defines of  
> >>>> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> >>>> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:  
> >>>
> >>> And instead of crapping out with "(unnamed net_device)
> >>> (uninitialized): Invalid header when reading pass-thru MAC addr"
> >>> when the BIOS feature is turned off, one might want to check
> >>> DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking
> >>> the BIOS if the feature is wanted.  
> >>
> >> Thank you for the report!
> >>
> >> Aaron, will you be able to fix this quickly? 5.16 is about to be
> >> released.  
> > 
> > If you guys agree with a revert and potentially other actions, i
> > would be willing to help. In any case it is not super-urgent since
> > we can maybe agree an regression and push it back into stable
> > kernels.
> > 
> > I first wanted to place the report and see how people would react
> > ... if you guys agree that this is a bug and the inheritance is
> > going "way too far".
> > 
> > But i would only do some repairs on the surface, the feature itself
> > is horrific to say the least and i am very happy with that BIOS
> > switch to ditch it for good. Giving the MAC out is something a dock
> > physically blocking the original PHY could do ... but year ... only
> > once and it might be pretty hard to say which r8152 is built-in
> > from the hub and which is plugged in additionally in that very hub.
> > Not to mention multiple hubs of the same type ... in a nice USB-C
> > chain. 
> 
> Yes, it's expected to be a mess if multiple r8152 are attached to
> Lenovo USB-C/TBT docks. The issue had been discussed for several
> times in LKML. Either lose this feature or add potential risk for
> multiple r8152.
> 
> The idea is to make the Dock work which only ship with one r8152.
> It's really hard to say r8152 is from dock or another plugin one.
> 
> If revert this patch, then most users with the original shipped dock
> may lose this feature. That's the problem this patch try to fix.

I understand that. But i would say people can not expect such a crap
feature on Linux, or we really need very good reasoning to cause MAC
collisions with the real PHY and on top claim ETOOMANY of the dongles.

The other vendors seem to check bits of the "golden" dongle. At least
that is how i understand BD/AD/BND_MASK

How about making it a module param and default to off, and dev_warn if
BIOS has it turned on. That sounds like a reasonable compromise and
whoever turns it on twice probably really wants it. (note that BIOS
defaults to on ... so that was never intended by users, and corporate
users might not be allowed/able to turn that off)

MACs change ... all the time, people should use radius x509. The
request is probably coming from corporate users, and they are all on a
zero trust journey and will eventually stop relying on MACs anyways.

And if ubuntu wants to cater by default, there can always be an udev
rule or setting that module param to "on".

> For now I suggest to disable it in BIOS if you got multiple r8152.
> 
> Let me try to make some changes to limit this feature in one r8152.

Which one? ;) And how to deal with the real NIC once you picked one?
Looking forward, please Cc me.

Henning

> Aaron
> 
> 
> > MAC spoofing is something NetworkManager and others can take care
> > of, or udev ... doing that in the driver is ... spooky.
> > 
> > regards,
> > Henning  

