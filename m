Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB02846F6
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgJFHSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:18:36 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:1249
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbgJFHSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 03:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwOm5Is0UaLS+DkdRwPpLlmyQfGkuRxE5L3iF7KBOUe/0qN5d6YIwl1Op4q07H3oAAJb2N+eCkpJ75C7h7LDqYmx1K88+0RPIGk+PyQDFEmmhdc6rCI6R2c5sxcrRduz8NXUJDyuTyxf17uviQQrsGZmauFFwi8XYqrTO+defjkHQ6xkAjmqdPhzm92fa9B41rrVtSIrBnhg/QxqlZV7cC4Caovmutv6fs3KTrEDscDjPX27CYNPeqJAz/yNhjAKQTenZBSqbl9jcoXZZ07bcHf/sQvOVunwi2MF+r+sasvQFPS5FjY4OEILUI6RH/s4rVnhFHJVDY/cIojjFwmfDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rcaKR6vVbjbGcrWIPEMbspkL3UtqGsl7JNL0rQfRfo=;
 b=cvLjjyc49Es4+Pv/Fo4dWrmHKsMnY6yR8O63m/s1NCNpzvnMA4uJgqKZQGXpGAOxvM7frqJPiTGwXI6C0sd9FxMxk3JYklBtRPgW79EkDBMc69xqppe2VVrvavQsEwa6ebu42fwBwnnLp0RjQtFmSWI+3ni/iDke3oTJXC8/jTbdMO6tfWfQRenZfAeDtxHnamKqw2J1PYrGlk3Xl1OQ+MHMKOkDfv76ODMD1HlQcLA4PVLIEMYJfTV8k4xdfJQ9fUtC3yT9a1dAlDXXzzqnFhamH0SSHrumSHWXQ2cyAGSJrkCRIWChQFx1cBhG2avOUUUn5gQXnFW4IMgsM9VhiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rcaKR6vVbjbGcrWIPEMbspkL3UtqGsl7JNL0rQfRfo=;
 b=MmRILUaUgxQUa20wnji6DAZEjwv58+yqm5nFrZomcjcS/uUy2e2CN++OlLGd9og6bCOcYBK5ZCwIEQhpYGCAq0W1aXsIM4/4o/rj+CGjErlO558w20WDd6TQ37fzSh6/1uhFsTyPnEUdp8IlxAgVFbFE+psdv/xKXdQF1OLKayg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DS7PR03MB5621.namprd03.prod.outlook.com (2603:10b6:5:2c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Tue, 6 Oct
 2020 07:18:33 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 07:18:33 +0000
Date:   Tue, 6 Oct 2020 15:17:19 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <20201006151612.6642719c@xhacker.debian>
In-Reply-To: <2e3bc015-5ceb-0583-0d65-70bb5d889952@gmail.com>
References: <20200930174419.345cc9b4@xhacker.debian>
        <20200930190911.GU3996795@lunn.ch>
        <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
        <20200930201135.GX3996795@lunn.ch>
        <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
        <20201005165356.7b34906a@xhacker.debian>
        <95121d4a-0a03-0012-a845-3a10aa31f253@gmail.com>
        <0d565005-45ad-e85f-bc79-8e9100ceaf6c@gmail.com>
        <c7cc2088-19ca-8fcc-925d-2183634da073@gmail.com>
        <2e3bc015-5ceb-0583-0d65-70bb5d889952@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.74.246.114]
X-ClientProxiedBy: TYAPR03CA0016.apcprd03.prod.outlook.com
 (2603:1096:404:14::28) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR03CA0016.apcprd03.prod.outlook.com (2603:1096:404:14::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Tue, 6 Oct 2020 07:18:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9637d4a0-7ec6-4ef4-25ff-08d869c8086e
X-MS-TrafficTypeDiagnostic: DS7PR03MB5621:
X-Microsoft-Antispam-PRVS: <DS7PR03MB5621FA117D52BBB92F13F287ED0D0@DS7PR03MB5621.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9z07g9OTzPPsKcGoiz7PAtjhVEVFaaG1u1ysvyjnS2nwP+WvecYbN+uiqYDDPERV1/2CMMISMk4WFsw8rKwOAQv6/lEOf2FCXeZuMfFFQMIrAXon1/Fj2GwrwZNmbdv/8qKTo3tNRDOxM8Vw0dQznM6bjRssuFlKoqGIZTM2uBqa3pxyj0+dgFMQh89IwfKBEro6BBFkMhB8iVum4SBcC3eobVziYjlCzOkPWNlbV85ZwqpHoQqx6Q4RQHC+wvLNOhcSCo3RePSo/flX4V3uBZguyQ/HuiuO1PL5+Y34sElbVoUxrvtgn7JlV2+5HrXD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(16526019)(478600001)(86362001)(6916009)(83380400001)(6666004)(7696005)(1076003)(6506007)(53546011)(52116002)(186003)(8936002)(8676002)(55016002)(9686003)(2906002)(26005)(316002)(956004)(66946007)(66476007)(54906003)(5660300002)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G+AifHCWRYRy9ej4ZKg/qOJppO3Ru+Iya5nRT1g3kny69TJJ7BkvTJWRfosgRAANglb9I21kfSLzUidPG3o76vkCgYkVDEIdoG0Lfo7GYxi3o1yLkoOuUK853vr//EpJHGMpq4EFPOyQAmRqUdiUewrPSFSYH7hCmUDWBn95Xc6SAKgupgyyKYSax8jpSt97ZimTxHWvbxa75aKoqAQIw6qVht6xhKkxnXDCxfUoWy+/NnIqIg90E9pa5BWuHE8hCet3ES4cY1N6KZpxBrwdE6TqDhJYAD7n+7e+hIMU2ihyn/1ZWaKGzlBer4WhMnCBUbieVps0doDSQREihDE+00jI4OJfRWLsg4/Tn9jBIo3+HeXcveoDHw36LFK6gLxvgtRbdhIWFJdPvhrG0MHJ7CkYw2EysUAyI9AQeLF1o87hCZ62Xei4CCe7f6+z9l/pRd3TrultdU1K425RDxxlhvaLKO8q0eSPAHqfhICm7mYPz+AXz4m8xjDzutIKsl4/crO5DeG9HDhTxvuHCkNA6ZkpwDuK1d3Ds6I+acvY6MYWID7oweF7z2EdW7ZkC+WyjBnGJ0YFHiQ5+iZHtPcMNnIJAnUUK4p2pCGenThFhqNcczjrLYU2nOOj2+PQWkWu51x70uJ4DmDhrmFq5aMrDA==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9637d4a0-7ec6-4ef4-25ff-08d869c8086e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2020 07:18:33.0775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Luijqsd3gqmsQHypunE9KtTh1AATXX0b0dQ/xAmM2Ew8+dJPqmnbCXHH01vBW+b7jjdCE31mZyOyAlXbzkdTng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR03MB5621
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 07:45:10 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:


> 
> On 05.10.2020 18:00, Florian Fainelli wrote:
> >
> >
> > On 10/5/2020 8:54 AM, Heiner Kallweit wrote:  
> >> On 05.10.2020 17:41, Florian Fainelli wrote:  
> >>>
> >>>
> >>> On 10/5/2020 1:53 AM, Jisheng Zhang wrote:  
> >>>> On Wed, 30 Sep 2020 13:23:29 -0700 Florian Fainelli wrote:
> >>>>
> >>>>  
> >>>>>
> >>>>> On 9/30/2020 1:11 PM, Andrew Lunn wrote:  
> >>>>>> On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:  
> >>>>>>>
> >>>>>>>
> >>>>>>> On 9/30/2020 12:09 PM, Andrew Lunn wrote:  
> >>>>>>>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:  
> >>>>>>>>> Hi,
> >>>>>>>>>
> >>>>>>>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
> >>>>>>>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
> >>>>>>>>> the phy is "isolated". To make the PHY work normally, I need to move the
> >>>>>>>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
> >>>>>>>>> enabled in system shutdown case, to support this, I want to add shutdown hook
> >>>>>>>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
> >>>>>>>>> there any elegant solution?  
> >>>>>>>>  
> >>>>>>>>> Or we can break the assumption: ethernet can still send/receive pkts after
> >>>>>>>>> enabling WoL, no?  
> >>>>>>>>
> >>>>>>>> That is not an easy assumption to break. The MAC might be doing WOL,
> >>>>>>>> so it needs to be able to receive packets.
> >>>>>>>>
> >>>>>>>> What you might be able to assume is, if this PHY device has had WOL
> >>>>>>>> enabled, it can assume the MAC does not need to send/receive after
> >>>>>>>> suspend. The problem is, phy_suspend() will not call into the driver
> >>>>>>>> is WOL is enabled, so you have no idea when you can isolate the MAC
> >>>>>>>> from the PHY.
> >>>>>>>>
> >>>>>>>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
> >>>>>>>> you need to watch out for ordering. Is the MDIO bus driver still
> >>>>>>>> running?  
> >>>>>>>
> >>>>>>> If your Ethernet MAC controller implements a shutdown callback and that
> >>>>>>> callback takes care of unregistering the network device which should also
> >>>>>>> ensure that phy_disconnect() gets called, then your PHY's suspend function
> >>>>>>> will be called.  
> >>>>>>
> >>>>>> Hi Florian
> >>>>>>
> >>>>>> I could be missing something here, but:
> >>>>>>
> >>>>>> phy_suspend does not call into the PHY driver if WOL is enabled. So
> >>>>>> Jisheng needs a way to tell the PHY it should isolate itself from the
> >>>>>> MAC, and suspend is not that.  
> >>>>>
> >>>>> I missed that part, that's right if WoL is enabled at the PHY level then
> >>>>> the suspend callback is not called, how about we change that and we
> >>>>> always call the PHY's suspend callback? This would require that we audit  
> >>>>
> >>>> Hi all,
> >>>>
> >>>> The PHY's suspend callback usually calls genphy_suspend() which will set
> >>>> BMCR_PDOWN bit, this may break WoL. I think this is one the reason why
> >>>> we ignore the phydrv->suspend() when WoL is enabled. If we goes to this
> >>>> directly, it looks like we need to change each phy's suspend implementation,
> >>>> I.E if WoL is enabled, ignore genphy_suspend() and do possible isolation;
> >>>> If WoL is disabled, keep the code path as is.
> >>>>
> >>>> So compared with the shutdown hook, which direction is better?  
> >>>
> >>> I believe you will have an easier time to add an argument to the PHY driver suspend's function to indicate the WoL status, or to move down the check for WoL being enabled/supported compared to adding support for shutdown into the MDIO bus layer, and then PHY drivers.  
> >>
> >> Maybe the shutdown callback of mdio_bus_type could be implemented.
> >> It could iterate over all PHY's on the bus, check for WoL (similar to
> >> mdio_bus_phy_may_suspend) and do whatever is needed.
> >> Seems to me to be the most generic way.  
> >
> > OK and we optionally call into a PHY device's shutdown function if defined so it can perform PHY specific work? That would work for me.  
> 
> If suspend and shutdown procedure are the same for the PHY, then we may not
> need a shutdown hook in phy_driver. This seems to be the case here.
> I just wonder what the actual use case is, because typically MAC drivers
> call phy_stop (that calls phy_suspend) in their shutdown hook.

Thank you all, I will follow this direction and send out an RFC for review.

Thanks a lot,
Jisheng
