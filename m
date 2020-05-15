Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A788C1D4747
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 09:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgEOHlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 03:41:47 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:29120
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbgEOHlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 03:41:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdUY6jlTJ5KaKp9qGZh6cQ66GbxQxACNN2ZvqIfZLkqNSmmyyBjm5EwnhNCfsarHZiausOVaqZUq27vBwQRD3doX0zyi/gPbECyM9tP4GMainKAPNOmr6y3TpT7uNdkDBw8m1mHNGZMRac5nOFTvLBZftNcwmDoj9UMj6kxNS2eo4ayaIx6RYJOSLpUrlU9Ufpxt5/OUze08GEBXsgxXlP8DBWveJUFaBbQezqI34XC0mrSpNLXP8xOzOVKINato4RsJwRtG0ulzFbo1iFZJ3EVHvxHobfhcHwNR3BXFRx7WW/WGF2eZQ7/ByRE3IBgmzQi2EHeYObnqq1Kj2j0fjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LzCY4Vt9EbsDcEH/Uyvj0lC5IOIjlQuD/6fkFpBqis=;
 b=fCtfRZSID+XVJ6kQqILuX+jH9qOATgcIH4T8iqdZ8X4CSNDj+NtMfCvi8ml5MGypCdrc2+xhHLOOdiolM5eX1MIq7pqUNkflcnp7qptyGzWb/WjRMgkTIom8oIq1TokV+zKkbiUl4fVHKRFMKStGq74gJUhu3vG4FU1c7089czUy8oFH1oR85NjCZUpVEvMvQNOFsr5LIYIBfECGUUKBSv0/ZZTLKG8pmN6WjdSuNQFfehyg3sIbirax3f6d8MKgmDY01DmHTpKXxndRbQNEkXJ0f8kW08ffs6xHmyNRdpXnRc3eNYt5OEq+E4MSS6iPezUbuEOlEqruo87Zjtzuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LzCY4Vt9EbsDcEH/Uyvj0lC5IOIjlQuD/6fkFpBqis=;
 b=enCxyWRRuznnjvsFmdDKm+MaVM4v7sDbUEvqgd4wJXAULGNiWqZodxAljmg2SG/P1ElGpKi762lZRawo76rec7zQe1HLQgxfgysulTpqyRADTiB0HtIyW79ObCwJUiKpIZ3pzyYBX3wym6KvewXUpX/V4PpDUOpDoGkwxIuIZyk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB3557.namprd03.prod.outlook.com (2603:10b6:a02:b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Fri, 15 May
 2020 07:41:38 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3000.016; Fri, 15 May 2020
 07:41:38 +0000
Date:   Fri, 15 May 2020 15:41:28 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
Message-ID: <20200515154128.41ee2afa@xhacker.debian>
In-Reply-To: <bbb70281-d477-d227-d1d2-aeecffdb6299@gmail.com>
References: <20200512184601.40b1758a@xhacker.debian>
        <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
        <20200513145151.04a6ee46@xhacker.debian>
        <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
        <20200514142537.63b478fd@xhacker.debian>
        <bbb70281-d477-d227-d1d2-aeecffdb6299@gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0123.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::15) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0123.jpnprd01.prod.outlook.com (2603:1096:404:2d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 07:41:36 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34aaf94a-fe4c-428a-0bdf-08d7f8a36683
X-MS-TrafficTypeDiagnostic: BYAPR03MB3557:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3557C306158D60EB7EF9BD64EDBD0@BYAPR03MB3557.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9lcGHNR2at01wrX5bHU4IhKUSlb0BAzCid90qKFoZ9Xe76a5xR5NbMHOyV06V4ov6TnYXPG0Ttc7nuDKkkVjweW47J4/4J7J1m/lHkoslj78Cqbqmp5tzqBBym+g/vIUlgsUYjodxcP+6iEK3294yybM2Z7vUeVoMvXHV0nu/QIekdHnMiVT4nTH4AFk1f9PDlfcJg5nG5kAztRF0KT3E1LsqmQm3ydzK4qCe9cSEyUW1d5FB9ofkzS3JMG8K7RxBCz/4y7lp2qQKa4sguN7dWWUY/J0Ew/jTeVFTteicmJlbFeCs2yIn0bWVEWOFLkTlee1cphocnpYQ9fNEI3uKF1M5FLeg9jIbOg6xKoawGbkZBTvHP7qjPZerLbMEieLfG6pPSEmaZu6SB352LVqO0vnaUCnezgi9NJUdRP9+WVRDh493CbP1jZL/4xCx2Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(55016002)(66556008)(52116002)(7696005)(86362001)(53546011)(2906002)(66946007)(6506007)(6666004)(186003)(16526019)(66476007)(8676002)(8936002)(4326008)(26005)(6916009)(1076003)(9686003)(54906003)(478600001)(956004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XB/UZ07WXCMfMzhrg5J4TMcM19E5znJrq5UndsG3K0JwR56iDMPiPT1/y/9JlkoZsV+FBDiYRekswnbB1oKCBGH+qA7ZgEe5TSf5FU+naZ3l3+TwoNPlLij1NRD8sxu4+6xqqml/SE3e3+ocfwMAPUt/0bX1I3ZIPecdqWufUz865OKhRGFMJGvmqQ2LFklVul5tR9xQIJvzE+o8nDJl7n95ju44ib3AhmQwR/LLJriiyE2tC0qsmLzoVxM4b5gltfTAQqsK16ADu4oTZ96hlEBDFDuxQ73GjUY+IuD7SMO1xvemfrsilztI+zkun5oMOgLhECvLajhar3YubVFGTOp92oSjlgxG6OM7cWpRfW19qe5UPbGk7x6XWVKXdCOkay6fKAT9AXIgPOZSNu6tpTMACKVtlJlZV7qqNRI2F98Q663Lvbwt8x9Bh/nq2/mIiklV0kSVNJ14N7Y7PUqDDVuPCfDsVe7purZ674xMNyFxbo0qjMae1QeepKlVHqoE
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34aaf94a-fe4c-428a-0bdf-08d7f8a36683
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 07:41:38.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhxAUPtNV2qZ4IbdB224kqS3hztAlw19bmLuoAR5CzjRwx7kIgbZ7wYGaWCB/flX0brozqIWpgRPg+TTxosjIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3557
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 21:50:53 +0200 Heiner Kallweit wrote:

> 
> 
> On 14.05.2020 08:25, Jisheng Zhang wrote:
> > On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:
> >  
> >>
> >> On 13.05.2020 08:51, Jisheng Zhang wrote:  
> >>> Hi,
> >>>
> >>> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
> >>>  
> >>>>
> >>>>
> >>>> On 12.05.2020 12:46, Jisheng Zhang wrote:  
> >>>>> The PHY Register Accessible Interrupt is enabled by default, so
> >>>>> there's such an interrupt during init. In PHY POLL mode case, the
> >>>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
> >>>>> calling rtl8211f_ack_interrupt().  
> >>>>
> >>>> As you say "it's not good" w/o elaborating a little bit more on it:
> >>>> Do you face any actual issue? Or do you just think that it's not nice?  
> >>>
> >>>
> >>> The INTB/PMEB pin can be used in two different modes:
> >>> INTB: used for interrupt
> >>> PMEB: special mode for Wake-on-LAN
> >>>
> >>> The PHY Register Accessible Interrupt is enabled by
> >>> default, there's always such an interrupt during the init. In PHY POLL mode
> >>> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
> >>> as WOL, then the platform will see WOL active. It's not good.
> >>>  
> >> The platform should listen to this pin only once WOL has been configured and
> >> the pin has been switched to PMEB function. For the latter you first would
> >> have to implement the set_wol callback in the PHY driver.
> >> Or where in which code do you plan to switch the pin function to PMEB?  
> >
> > I think it's better to switch the pin function in set_wol callback. But this
> > is another story. No matter WOL has been configured or not, keeping the
> > INTB/PMEB pin active is not good. what do you think?
> >  
> 
> It shouldn't hurt (at least it didn't hurt for the last years), because no
> listener should listen to the pin w/o having it configured before.
> So better extend the PHY driver first (set_wol, ..), and then do the follow-up
> platform changes (e.g. DT config of a connected GPIO).

There are two sides involved here: the listener, it should not listen to the pin
as you pointed out; the phy side, this patch tries to make the phy side
behave normally -- not keep the INTB/PMEB pin always active. The listener
side behaves correctly doesn't mean the phy side could keep the pin active.

When .set_wol isn't implemented, this patch could make the system suspend/resume
work properly.

PS: even with set_wol implemented as configure the pin mode, I think we
still need to clear the interrupt for phy poll mode either in set_wol
or as this patch does.
