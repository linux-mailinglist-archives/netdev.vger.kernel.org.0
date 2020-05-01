Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62691C0DFC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 08:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEAGWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 02:22:36 -0400
Received: from mail-eopbgr50134.outbound.protection.outlook.com ([40.107.5.134]:3259
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728126AbgEAGWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 02:22:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8pIPZQoFNe0I2Q10II40xRBu17Pb0KGY4dptjrW6mdj2GK3vkQ/wie9D/c96VIuX3IM92thlGQokQpyWUQlAM0gCct8YUW1cJ2HgQvfKKMl97w0O+6VoNlAtqOdPIPgTFJIwMscKVdZAY3/dxqae0lyNw2jAr3GR2lf5vHPBTclzo5vngKQAU9XSIE0PvevQbhnPQJ/lqGe/ZiCcqrukfdw6sNnCdg2XnbGnA0e8lBmPjIwBop69wKooJb/MRVYPeRE7ADCz6yyNywwKd1OZCz7l6f6uDtlE4ZdhKXocwjRbxEqrvlpdkvC+wGBgV+O37+LBBd1ypw13AGJk3NDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPQqHtly8N8Bt56jYP/QXXvSKq8/eZFKAH53OkzYif8=;
 b=I8g7mcJw+VQypV3BeQDHqaMpoZOlIlTAm+N7YdHkjrPh7sPv5Bt83Q4tSH0kI51DKgFspDr0hM27qnp1jBoQCxZTW7EvorRnGP1pvTwUTiKONSoI2oGByheGQyvinDWH6dyatJH16Phw+CI3IWHe5L5NzCBQIkTXI7NOejHhgvp6ByQ9wKLvytjqFhmZl9djthf+N9NpszhODB74/M+aO92iIlLaqUwz6gZr1LAmNIrexvaEZWuemCADI/TNcEgg8kkCz9L3iHPJHaerdQqY8CjRtpkAPuGOymckoBXZWUHFJftmWdJ/NkE4Ez403Lfoc8dVZiq9QVnwgP33M8U4bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPQqHtly8N8Bt56jYP/QXXvSKq8/eZFKAH53OkzYif8=;
 b=iaiRzrXSVeMY8UAWJCA0bI5o6HePLzCUUXWPWiwtzOdKSP3V7z7T8hvvDa1MOTe7PTh0RbSAJIaRVzxPXrFs6ddJwNEYcLuB6j3zkHQJ8dpulkMYXe80cC6BCMzQvetl3JLZLG1oWUqecr6r3q4ZcLHgBZVKYM2w+pb/y2A4UHk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0063.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:9a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 06:22:32 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 06:22:32 +0000
Date:   Fri, 1 May 2020 09:22:23 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200501062223.GA15217@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200501000015.GC22077@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501000015.GC22077@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR05CA0023.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::36) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:20b:2e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 06:22:30 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d46df56-81aa-41eb-f675-08d7ed9807c0
X-MS-TrafficTypeDiagnostic: VI1P190MB0063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB006339440441789DF1295E6E95AB0@VI1P190MB0063.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IrxnzRBdtRjFL99b3a15VPHXix/Zldhk60PxCvE2h6cHZlxsnjGvVdLIyf47cBlu8oVnYWSv3yP8r4qd7R1q0z0j6lBHKqWJd6ILn8Ft+6TvG23n15qsmb1w/A7kW1i8618QRxMTGcZxkh5QDK/S1ItQ8e8tP4yobhbfZ+FDrCfDhyc0Odi/lCz+2m1jOADADH1Mj3XfBUVGhjQfkA/8ncuLuf7QXyYB9BoYYrv9thta7dL16QgYRgLYmwrtjeYZkypqIgsk7dUoDxlaZXmlP473y0YlN63JVXwH+33io0uQOappUhpifMXTXpGtNa57tXqmjOAn/DN44py7DlckS8/KhFlsBWZdlUz28b4KTK+bP6bd9PBolTKkDAFsR2BQqz7iGHGxvt2/Jhq1RYfrB7ZCZo3TPfaOPHOlmVqQun+B9bfGpuJoJIw4FNrU3wU1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(39830400003)(346002)(136003)(396003)(186003)(2906002)(6666004)(44832011)(5660300002)(8936002)(55016002)(8886007)(4326008)(16526019)(1076003)(2616005)(956004)(66556008)(66946007)(66476007)(33656002)(6916009)(7696005)(508600001)(52116002)(86362001)(316002)(26005)(8676002)(36756003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: f6QQ0CSi6sYs0YKIuqPEgGLDxdxguOLgXolSZRLmXHrm27Nu1FTQ4W8px30y8v3s8rzYKEiPmEW6/bt4pOZeggzyEsgnt+wYAthi6C8Es2k7Q/x2KrQB/BWK2QANzsEFoHWs+aZpYLlFI8FHaRpm0lVQeCsznxoUEmuv7hQPYGIqircPFNjPL9q2PIPUxLmrUNPYBqmnGhaRgHpLseumgD7bcSR71TlUJchj+9Zegbto0DSaXGYLqRFDY2/rt69jstv11D9beEEVrd4biAlBCgps6daGY9yYjrjqQxbmgeoVXoeKjpGytNbG/B3Allu52sltx7iGbc0rG2cpejDO7yvXD1k8DBjidnuvrFEWGrKr40vSTm3x/evmmAmJ13blNojW/wwuJlyvo3P35457OSl1XhTKHaJ9utbFQ6hFcMLvbqiyL2+3atuMg+L3FkXVLFQz9rkqzkpQFoGJ7R89B65vN1FlYoJm1DCbIgSL2hSRFTXAeBGfxrQquY9uLcyi3D0AMmZZp5IFoffC461OPyiTSB45bG9dHGC/j3CtCV1pva8X0Zu1QrMbHSJs9ulPkN732fwhy5tE1HRzONCRxNWngMIsjvH8ZVdNSSz8vsp2h1rd3gzHbMI/lZtnJZP3GwCnaqECXo3gB+HKhc7HrOSdf+RyTCX4oCMRjcGVCLPKo4MgZuD3G0gJUHc/GiP52DHC3K9i1zkXHNUrGs8NkHRoYCWdMcnBODPF7gR/yar5JQMOlfrv7jS4vvYy1dJT+iJbVKlyT/ib20OV9s4NcK30WQKOUbRwgNP1pvR0Ti8=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d46df56-81aa-41eb-f675-08d7ed9807c0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 06:22:32.1840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+m8mEZx4x7JD1r48WNE5VTBqmXZNDH2JQBKEYnkfO4E8cWgsAg9DrZZVKSJFCVbVfm4KhjJSht1lkimv2QZB0iB1MwRxVZA+z+XrRm+lbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0063
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, May 01, 2020 at 02:00:15AM +0200, Andrew Lunn wrote:
> On Fri, May 01, 2020 at 02:20:49AM +0300, Vadym Kochan wrote:
> > Add PCI interface driver for Prestera Switch ASICs family devices, which
> > provides:
> > 
> >     - Firmware loading mechanism
> >     - Requests & events handling to/from the firmware
> >     - Access to the firmware on the bus level
> > 
> > The firmware has to be loaded each time device is reset. The driver is
> > loading it from:
> > 
> >     /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
> > 
> > The full firmware image version is located within internal header and
> > consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> > hard-coded minimum supported firmware version which it can work with:
> > 
> >     MAJOR - reflects the support on ABI level between driver and loaded
> >             firmware, this number should be the same for driver and loaded
> >             firmware.
> > 
> >     MINOR - this is the minimum supported version between driver and the
> >             firmware.
> > 
> >     PATCH - indicates only fixes, firmware ABI is not changed.
> > 
> > Firmware image file name contains only MAJOR and MINOR numbers to make
> > driver be compatible with any PATCH version.
> 
> Hi Vadym
> 
> What are the plans for getting the firmware into linux-firmware git
> repo?
> 
> 	Andrew

Well, what is the procedure ? I was thinking that probably after
conceptual part will be approved and I will send official PATCH series
along with the firmware image to the linux-firmware ?

Regards,
Vadym Kochan
