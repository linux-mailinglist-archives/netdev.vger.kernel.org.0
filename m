Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7C1FC98D
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 11:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgFQJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 05:10:05 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:33818
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgFQJKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 05:10:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKar8ccK+a9Z73gEhS56P7WWaLVOobJnSsNB6MLCi+3yuZ+Pqik4bDVPN9nY99JUydwUjFhLeKDE3hSzj40axY/WxW2A9BibgwCgkligQqmwPBFXfgLnzh7H5ce3kJyxMngU0zqxyDFkzeQMUpL/78TXygeWRfVXZS0W9JtCHtnoe6goU6K58W720xWBItdlwCmYrliqQ6yNgq9y4GeP0L7GtQCW3T7j1dS9rCOXdbA6o3NyUARCBPesWH+P+uegjk7/8+zfNc71qi3FeiQNpQ9Rgl1Vzoc8fMyyKSm3zmXOOXONRGHomJTcQ6F+ISSJcROzm4ZAlqBdd9rQYGuYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghsglx5Qj0Pj+1kzXmrRaFLLSlgw6L4f9W4MYf1Fj5A=;
 b=Ko4L6ddCSkUU7L9cDvs+HLIFsYfzi+LNxGTxW4Nvb2XAKo2RzpIr+SGFj3evEPw1ORpvIM7sj0/T+G7oGCwdw6S4RNafB1JlG4hQYMMhUTqREiNUBPnLizPtEV3R+y5D6g+CGwWO2mxp5c4M/KE2FPkQTbBgpClY6LCAM59kRSInwJOESoNkc2FuSuicBxC5xueT6f5cS127ZW+3pGViKWadJj0b8xLSI3sckCRuTbrgX1Xjx/VFABv6yL23Y5AtCfg0dJVWz17YUj6EnRHgTbuPYiZl9x0mLXWn/RggRle/okvf5nAMB4BbwAMeLo7BcxooAkSllc4I73hfin/h1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghsglx5Qj0Pj+1kzXmrRaFLLSlgw6L4f9W4MYf1Fj5A=;
 b=KcZz2hZox+0/82sIq1arACNQH8UqSvLmGK7SZLfdslZwfq7hLdBJL5IuRpe2fqJYGCtHY5nX7fOscjQzeR/Hf5qBE7sHv+lnMA4/BjTbL3nHzFm3SzJrWIYD7SY+ct+8JGcF06UbWA76xuSUq0DTiaT3NBep4OWsCorNZ33fWSc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB3751.namprd03.prod.outlook.com (2603:10b6:a03:62::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.25; Wed, 17 Jun
 2020 09:10:01 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3088.028; Wed, 17 Jun 2020
 09:10:00 +0000
Date:   Wed, 17 Jun 2020 17:09:26 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
Message-ID: <20200617170926.5e582bad@xhacker.debian>
In-Reply-To: <e81ad573-ba30-a449-4529-d9a578ce0ee7@gmail.com>
References: <20200512184601.40b1758a@xhacker.debian>
        <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
        <20200513145151.04a6ee46@xhacker.debian>
        <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
        <20200514142537.63b478fd@xhacker.debian>
        <bbb70281-d477-d227-d1d2-aeecffdb6299@gmail.com>
        <20200515154128.41ee2afa@xhacker.debian>
        <18d7bdc7-b9f3-080f-f9df-a6ff61cd6a87@gmail.com>
        <e81ad573-ba30-a449-4529-d9a578ce0ee7@gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR0101CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::28) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR0101CA0042.apcprd01.prod.exchangelabs.com (2603:1096:404:8000::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 09:09:58 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a45b5faf-9ed8-4121-c6ca-08d8129e36b9
X-MS-TrafficTypeDiagnostic: BYAPR03MB3751:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3751063D8FE37BC004914A16ED9A0@BYAPR03MB3751.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQAzo23BxEcSGk3yR/wdZJVms8XIovhFwbw6L+PTNSmis44vIFKnTxkykXlIbcJh7kQ/ZSMSPf/iQm/Jd4hu8xDfF3wgFqsAaH5KbontZi2616E7YQ4gLhiRqaFJBteDFrI+tiIA8mtZeZSzhONjmuqEanPWcilwKod9i1r0oTYSpu/6Iw/8ff2Zcqerhkfvv1FRIzZxSXzLXMuheUTXhfuWIDq1RP3jnwHI3oQx35XUCRd4yqfiRUWgrX7K6LmuG4VJTZSnD8NgNCm/BtjUmogEeMlJq5QlhrxZoHAm8rlo3lko6ZgUArjWM6WApEAXyou01xmONB75c8vwVugWWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(136003)(39850400004)(396003)(376002)(4326008)(52116002)(66476007)(66556008)(6506007)(7696005)(316002)(66946007)(956004)(53546011)(478600001)(9686003)(55016002)(16526019)(186003)(83380400001)(26005)(86362001)(1076003)(6666004)(8936002)(8676002)(54906003)(5660300002)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7J/aQkzf1x8clHefJ1AwcG7iWFeEjeav5e2AyMBK5YmJ9l+5BJqLbimoutVbiEP9M3hr9wVLSOpo/QA0b7jGELxnDVkNYt/Z1yJzAD20mTafJuyn60/k2UML4GjDXwrfqVP5upBNUMF/91ymcYaAqljg3iQzwjUuZgJ5voGEFnAjtvOeCvjqG6MkM5zcmi/8S7xc1w5YIeRXoPXQ6x4zHfhoL5/59uME73j/DZ8L5WNQVNjXO/OibOO7+fxEUTEYaaDzq8FzUwglkRXNnD1jR70sbxH0Or0rDWGyYIvtky1D5VUPdGwPIXC1jXjPaywVrUW9yqnQkycJ2Q/29vBCtYSGzD/Eoyeb9fQzRQVx6zvV/RD9JTa+XazNpnQtDUcyx9LxwmwFiNfjSbunV/voVJDTvSGFANGsGoHmCxy4QY5pPJZMtFsw7AExi7PQlu7TvhBN04pfxnJiGAv3UsxU/y2UqCoWry+NVewEBR6H5KpF+Vx2X+svS2Q1rEXtm11j
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45b5faf-9ed8-4121-c6ca-08d8129e36b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 09:10:00.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0I5M/U3LrnN7kZFHsqfI4fJgI2uJj5lwEp5keN25Vd9kZjU7+zs2BK51GSfRn4r8qZAadmv4WioxtFgmYtaTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 19:30:38 +0200 Heiner Kallweit wrote:


> 
> 
> On 15.05.2020 18:18, Florian Fainelli wrote:
> >
> >
> > On 5/15/2020 12:41 AM, Jisheng Zhang wrote:  
> >> On Thu, 14 May 2020 21:50:53 +0200 Heiner Kallweit wrote:
> >>  
> >>>
> >>>
> >>> On 14.05.2020 08:25, Jisheng Zhang wrote:  
> >>>> On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:
> >>>>  
> >>>>>
> >>>>> On 13.05.2020 08:51, Jisheng Zhang wrote:  
> >>>>>> Hi,
> >>>>>>
> >>>>>> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
> >>>>>>  
> >>>>>>>
> >>>>>>>
> >>>>>>> On 12.05.2020 12:46, Jisheng Zhang wrote:  
> >>>>>>>> The PHY Register Accessible Interrupt is enabled by default, so
> >>>>>>>> there's such an interrupt during init. In PHY POLL mode case, the
> >>>>>>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
> >>>>>>>> calling rtl8211f_ack_interrupt().  
> >>>>>>>
> >>>>>>> As you say "it's not good" w/o elaborating a little bit more on it:
> >>>>>>> Do you face any actual issue? Or do you just think that it's not nice?  
> >>>>>>
> >>>>>>
> >>>>>> The INTB/PMEB pin can be used in two different modes:
> >>>>>> INTB: used for interrupt
> >>>>>> PMEB: special mode for Wake-on-LAN
> >>>>>>
> >>>>>> The PHY Register Accessible Interrupt is enabled by
> >>>>>> default, there's always such an interrupt during the init. In PHY POLL mode
> >>>>>> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
> >>>>>> as WOL, then the platform will see WOL active. It's not good.
> >>>>>>  
> >>>>> The platform should listen to this pin only once WOL has been configured and
> >>>>> the pin has been switched to PMEB function. For the latter you first would
> >>>>> have to implement the set_wol callback in the PHY driver.
> >>>>> Or where in which code do you plan to switch the pin function to PMEB?  
> >>>>
> >>>> I think it's better to switch the pin function in set_wol callback. But this
> >>>> is another story. No matter WOL has been configured or not, keeping the
> >>>> INTB/PMEB pin active is not good. what do you think?
> >>>>  
> >>>
> >>> It shouldn't hurt (at least it didn't hurt for the last years), because no
> >>> listener should listen to the pin w/o having it configured before.
> >>> So better extend the PHY driver first (set_wol, ..), and then do the follow-up
> >>> platform changes (e.g. DT config of a connected GPIO).  
> >>
> >> There are two sides involved here: the listener, it should not listen to the pin
> >> as you pointed out; the phy side, this patch tries to make the phy side
> >> behave normally -- not keep the INTB/PMEB pin always active. The listener
> >> side behaves correctly doesn't mean the phy side could keep the pin active.
> >>
> >> When .set_wol isn't implemented, this patch could make the system suspend/resume
> >> work properly.
> >>
> >> PS: even with set_wol implemented as configure the pin mode, I think we
> >> still need to clear the interrupt for phy poll mode either in set_wol
> >> or as this patch does.  
> >
> > I agree with Jisheng here, Heiner, is there a reason you are pushing
> > back on the change? Acknowledging prior interrupts while configuring the
> > PHY is a common and established practice.
> >  
> First it's about the justification of the change as such, and second about the
> question whether the change should be in the driver or in phylib.
> 
> Acking interrupts we do already if the PHY is configured for interrupt mode,
> we call phy_clear_interrupt() at the beginning of phy_enable_interrupts()
> and at the end of phy_disable_interrupts().
> When using polling mode there is no strict need to ack interrupts.
> If we say however that interrupts should be acked in general, then I think
> it's not specific to RTL8211F, but it's something for phylib. Most likely
> we would have to add a call to phy_clear_interrupt() to phy_init_hw().

it's specific to RTL8211F from the following two PoV:
1. the PIN is shared between INTB and PMEB.
2. the PHY Register Accessible Interrupt is enabled by default

I didn't see such behaviors with other PHYs.

Thanks
