Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7221D27A9
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgENGZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:25:54 -0400
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:57318
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgENGZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 02:25:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nH4VJU4GpMcShBDe2cydRolcesvo8O818Q1IDsOpD68OQl0BaUp9rC2833Pub2OCMuFYi+0Bs53rhJJbFEqb/3SW19mOfPCPjhN7JIhMn8wBnDVQD5VMsfGRxoo73W/HMeBF4i0vTEvkak5ju+uAz4LH51G/Ft1FAuJzCz/L1fJZjC+K9p7LruxVdwx6xgBCRCWey6xGWuDm5L15BkBnQvSd7mTu4dQkCMgMHSr5hcCKoT1NXI0ZJo1/qfBsZFHVBvMh4Mc0Bp+mmmhhapoK7FToJ6Wb1m9nYsYujtjX0lqvdjSUBeHLcJUuXZ+KYreQYxxSF5SEyFyjdV4RG7RPpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YymO3BIupnGtTYTQ49XfA48VI4dYr/owG15o9j1INSM=;
 b=mIcw3pwbvvnanH4hNDq7+lidTzV5SzaOJw4lns0VtPwRfss+F+r8yeO8F4MKoI5rur7ZFaVCO2RkZYLNYnW861fOlYMCB8gNhq4djZX4NpeIed2uuXMNd+9rNz8x+RXzbZlpyy2rPt92iGm2byQ49dQMilZBUFWveu5NBLxyRD0lCelR0t3dIkFw0/wySokGrsvgyJVU6J3oDXghBJPi8Art8N+IyivowmoSgLbB7zoWTAXoibnec9wOwgth94EO8/z9kobmDUDCeQK1ihCVg08aYYgncctgnthf7RrqKpsRNWXTMZsgv72NxDJqy5PMSkzvfn7UTtw2jejk33nnXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YymO3BIupnGtTYTQ49XfA48VI4dYr/owG15o9j1INSM=;
 b=HuwulxSNJ/N6Yl1mHM5+Z9oNCJhGrl4rt8mpaRJYoVP5+E8G4eHnYY8uUccAJ3bZUcxenjLZd792ujOTP1DM7qp+MXsgWv0ajYpy6VMV0gBXtHSHjTxCJOFImeHQ8QWBAQsmxMK/yI3ENJCIt3F9coOpicNZ2z9jlmdoBdg/1gg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4901.namprd03.prod.outlook.com (2603:10b6:a03:12f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Thu, 14 May
 2020 06:25:50 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d8fb:de22:43b7:fcb7%7]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 06:25:50 +0000
Date:   Thu, 14 May 2020 14:25:37 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
Message-ID: <20200514142537.63b478fd@xhacker.debian>
In-Reply-To: <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
References: <20200512184601.40b1758a@xhacker.debian>
        <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
        <20200513145151.04a6ee46@xhacker.debian>
        <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0147.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::15) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0147.jpnprd01.prod.outlook.com (2603:1096:404:7e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Thu, 14 May 2020 06:25:48 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ad48af3-9bfb-436b-8fb4-08d7f7cfa55c
X-MS-TrafficTypeDiagnostic: BYAPR03MB4901:
X-Microsoft-Antispam-PRVS: <BYAPR03MB490192790D55381C0AB9CA44EDBC0@BYAPR03MB4901.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17P23RtqGDRIElW6CbVvWSGB+Gzj2HpFTfkcdKfZjMWq1lkc6BcBp2UACTJhlyosCdQgP3mRq6hjG9Yt5DO5wG3HXO8HZRx/TReBbhw9r0yrWOU2cFszyg8+Qitui64gzqsliL2WsxGktE9DCybbjARjXoyVRdWv2SAY4rg3usJe76h89qqegaHM/VXKhyGPd9CVY/eq90cw+CL9CTHvQ8ZETbarCH2Hnyo7cFQ2ncYAEOc1wNrpA3gVDX0qubzNvBvVvHp3/4rL8MBx1Q5Tw49SJMeVO7LPB0/k8i5/cD+WvfVYPPU101QJeICyH+Tea5NAgSpDZfid6zBYKwQD/zeLsPn/kdllmXU9B1KoY/bAevUtbyrvbj5SuoX+xw3tPvLuRmtWPabjSsI3OVHLjjHRkcQfUxQPYIj3ggE0PRfBLaMlFaWJnwbCum/9qOKo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(39860400002)(396003)(346002)(376002)(6666004)(26005)(55016002)(316002)(52116002)(956004)(8936002)(53546011)(7696005)(4326008)(86362001)(186003)(6916009)(9686003)(5660300002)(54906003)(2906002)(1076003)(66476007)(8676002)(6506007)(16526019)(66556008)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GTU+eSW1I5556M08lnQERvPyzb89DD3yeG21kO/i/GUgsSNjUYiR6AxKxFsbkGs6lmSg/TvJXBL9ZqqFUho3nJ3Cwl3D9oYh0qPC55VcUrTHVB5D8TFYCHc3dPXOs1XXbGZyN/se7tothuWzJh8fCETKjNLUtc65wDlFMbDR7LwXNzgJsnMuXZ7NzFxMK2WwInoddDurNogUpjO/HV+fMg9rIIPAKiYacymC8qLjEuQgeyzwLaDeTfo+zAKa3FaZtMMBuY5VulFrk2IFLxPNCMEwMG6jbeWpeNvs+EM+p5Tm1Vpa/iv4jU75HE5yHaZBSCF1+srgA+SYZ/9shL5pb/MA2Vdlqr/ZRMjPG5SBNnOqlcvGJApmPohteXGBwSC0MF2YZ0/8oEJ2Tav8Jbro7f9QC8n9Xbl4Zk6cErOztuHpvCfr00ujVOtXzeDRBrSxnkIl5DQVketXa42eLgMMRC9qtnGwG0z4h9X/vFKnFt5X286X/vPE/Ifat1nxG4B3
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad48af3-9bfb-436b-8fb4-08d7f7cfa55c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 06:25:50.2261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiUYxmJkCEvVAKnhylbm83+7TJN/Ev13fsI2KYvx7+fHuxXR1gK6k8Z4E85zU8DrBFGjJd2tHyD2XPeOb5VV1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4901
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 20:45:13 +0200 Heiner Kallweit wrote:

> 
> On 13.05.2020 08:51, Jisheng Zhang wrote:
> > Hi,
> >
> > On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
> >  
> >>
> >>
> >> On 12.05.2020 12:46, Jisheng Zhang wrote:  
> >>> The PHY Register Accessible Interrupt is enabled by default, so
> >>> there's such an interrupt during init. In PHY POLL mode case, the
> >>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
> >>> calling rtl8211f_ack_interrupt().  
> >>
> >> As you say "it's not good" w/o elaborating a little bit more on it:
> >> Do you face any actual issue? Or do you just think that it's not nice?  
> >
> >
> > The INTB/PMEB pin can be used in two different modes:
> > INTB: used for interrupt
> > PMEB: special mode for Wake-on-LAN
> >
> > The PHY Register Accessible Interrupt is enabled by
> > default, there's always such an interrupt during the init. In PHY POLL mode
> > case, the pin is always active. If platforms plans to use the INTB/PMEB pin
> > as WOL, then the platform will see WOL active. It's not good.
> >  
> The platform should listen to this pin only once WOL has been configured and
> the pin has been switched to PMEB function. For the latter you first would
> have to implement the set_wol callback in the PHY driver.
> Or where in which code do you plan to switch the pin function to PMEB?

I think it's better to switch the pin function in set_wol callback. But this
is another story. No matter WOL has been configured or not, keeping the
INTB/PMEB pin active is not good. what do you think?

> One more thing to consider when implementing set_wol would be that the PHY
> supports two WOL options:
> 1. INT/PMEB configured as PMEB
> 2. INT/PMEB configured as INT and WOL interrupt source active
> 
> >  
> >> I'm asking because you don't provide a Fixes tag and you don't
> >> annotate your patch as net or net-next.  
> >
> > should be Fixes: 3447cf2e9a11 ("net/phy: Add support for Realtek RTL8211F")
> >  
> >> Once you provide more details we would also get an idea whether a
> >> change would have to be made to phylib, because what you describe
> >> doesn't seem to be specific to this one PHY model.  
> >
> > Nope, we don't need this change in phylib, this is specific to rtl8211f
> >
> > Thanks,
> > Jisheng
> >  
> Heiner

