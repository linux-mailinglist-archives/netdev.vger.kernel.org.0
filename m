Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38CB28329A
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJEIyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:54:51 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:35808
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbgJEIyv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 04:54:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBII3GRSqcgRvwR4FlK3y4aFBCatAy8qTS+Mmw0KblQ37romfiGAf8GIBc8iTc/E3auwqhbCwVllU/SEBCM2z4J2l3XUxX/9NrcZtggIM4Tg8VoBYhjEfgY9aAvmEgD+iDjTbJPHuaT1arc97H6q0taZorOLjeFpaVmqsom2Qw+6VxApmpb0pQQZtjjUmH1li/14ZUEUo0MSfuvwjsqGbUPt1if3M8tlMN7ImNnbPjMyoLl76Oja9iMThNPIFL5L2GPMjJSEtYYKlDMZwUoxT793gke6h5EWQpXw4BtOYNhVkpEmGmJLMesw06Nw24JKlz+ehVCXFlyJoh+11VsiSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSfaiBjwNO3ZGs1jPHC5IhFsyin4ToQtC0CFtfn9YqE=;
 b=JLCrbNjY9TQ43uSdb0chBR2s/F1HDChYi3s9J4WMYC2CeRQPnsNrWSpH8YKL7pC/1tegAJ5FMOIupm8DnrdfFxoUiAfptAAxLEw3AXVjasFgSZfj/4Vl5QCHkdIbognjGvuwE2kKmVTOkcqnxuVuyEFa5gAOL2I5slg2+80rweyqqZ92E9DT+m+k6WMYFynEXjMJFIfzacDrRDr/L/BTqZpJ11bnSKkPLI2/rYMVn+sgvF9RHVjsGWYloCpOdDBjfhkntRMAn9PSL4ga7Nk2YoDOjE3XjCQc+8dzBYMXFoOG2irDLRJWfR98rmDCq1ZqSiC7P5U04SSUYr6Sda0RxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSfaiBjwNO3ZGs1jPHC5IhFsyin4ToQtC0CFtfn9YqE=;
 b=Yem8D/spiwFuyhZa11syteeoaDyi3/WybkTzIsYO5t6JccMHglsXfpbeAH5zXqOoYu5/PnRQD5W2PE1IzUYTfbit25/5I3DWc4bvSm6fG8V4tDpq9AXVlR5s/LfgT+6oW0nr3dqIIi1mUOeOc5VrGHtHSyaQ+r45hnHxvduhhUg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DM6PR03MB5292.namprd03.prod.outlook.com (2603:10b6:5:240::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 08:54:47 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 08:54:47 +0000
Date:   Mon, 5 Oct 2020 16:53:56 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <20201005165356.7b34906a@xhacker.debian>
In-Reply-To: <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
References: <20200930174419.345cc9b4@xhacker.debian>
        <20200930190911.GU3996795@lunn.ch>
        <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
        <20200930201135.GX3996795@lunn.ch>
        <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.74.246.114]
X-ClientProxiedBy: TYCPR01CA0118.jpnprd01.prod.outlook.com
 (2603:1096:405:4::34) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYCPR01CA0118.jpnprd01.prod.outlook.com (2603:1096:405:4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Mon, 5 Oct 2020 08:54:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f745486c-dae2-4e8c-2f22-08d8690c4fc7
X-MS-TrafficTypeDiagnostic: DM6PR03MB5292:
X-Microsoft-Antispam-PRVS: <DM6PR03MB5292737EB93E4FF3D61114D7ED0C0@DM6PR03MB5292.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hx8piUoPc3wfgRIz8sZFrDsSYBGWSf+9y63LsY1c85hKK0mUx+r+foPc1H02aJgHgYOVAAyoeoQW8CJJSrfx99WSxTzd8NdgnpbEd8P2v6SPVHYnm+3yk+xiRgse+oMluIQzPxKFLvSJQ56OXbL9ay7KrxgTiwsJSwPiX6GekgNpQo3v8M2KA+vMkp2v1Z8UU8zR9+Mm3Qratj9s/sZjo9mOeYYZbMi5ygs8Qiws7wURyPC3Fh67YUhBr7jAxKL5RDOFHFGk+CjKZEBpwu5h40n7AMyvQQUuy7LGFxORzflGJ4yVzbd/CZN1+1zw0sGb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(366004)(346002)(376002)(136003)(1076003)(8936002)(86362001)(2906002)(6916009)(83380400001)(6666004)(5660300002)(66946007)(54906003)(66476007)(66556008)(52116002)(186003)(26005)(956004)(16526019)(4326008)(6506007)(7696005)(53546011)(478600001)(55016002)(9686003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FrlmHqJQU8cCMm95Oh/kdPKmjmpccPawwezKmGaFIhOxsBNnvrrb8Lngt1+6+RCMdgEcJOvLYD8APrlLKAPeqd+xAnDH6x3L2cTXyQUmMgyXq9QNd6jsyr/YIQ/G6z1De/RMnfiHVMAqsG4EmAbDixq2XMxUcxqwSIyJ8tLi1vLQuXPGkiEE+PtDXGRa1ZfwQpMua/dRIcs/UK5pdLy4tBZRTn/OSqw3S6Qb8/GnPGmQjc//qJNx2UnzThiA1b68RxQwby34K8yoGSbI0RO0mOsXBfTmVo+40KFERL2CcXYL9fVvoA+ZSfFekuYyUc9lZkq1+JYXnEdixg+rUKaXXvfc4Y0Pq3+ApYKcCXlNzJCtV6kGGlwLkKJ1qH8Y4UzcNzTAvErFuQ8qB6ZhF7cdR2JLs7PEXcU8R9IqtkchktJwFpil/aGeRC/ihudomIPQpnsdtUUTl+QcT6aAv8/KeaKUvWk8cwGexjoMGzxIlFhIGetfHD2q8SJ2LzjacHPp2sdvvtcfzp3UzJ6sL9iWRxfh5WjaZxg2fzJzvCOg1/TqPlhPreRTWPWkLvEPyPM9gm84+y4oedAHonqN7rzvJcOL2HC6XzkIZKyxdqyNLQjFwVoSFisG4MEr0FMDLpdyRAb889k8q33cLNVzEPFhFg==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f745486c-dae2-4e8c-2f22-08d8690c4fc7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 08:54:47.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uj04q38Zzy8nXS4/iwgQpm60Ea6TcWAS+FJh6Am7jXo8ijbdcJ91DpD4HpuFtIHemgoSBb70y7r1NLOIhYTDdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5292
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 13:23:29 -0700 Florian Fainelli wrote:


> 
> On 9/30/2020 1:11 PM, Andrew Lunn wrote:
> > On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:  
> >>
> >>
> >> On 9/30/2020 12:09 PM, Andrew Lunn wrote:  
> >>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:  
> >>>> Hi,
> >>>>
> >>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
> >>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
> >>>> the phy is "isolated". To make the PHY work normally, I need to move the
> >>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
> >>>> enabled in system shutdown case, to support this, I want to add shutdown hook
> >>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
> >>>> there any elegant solution?  
> >>>  
> >>>> Or we can break the assumption: ethernet can still send/receive pkts after
> >>>> enabling WoL, no?  
> >>>
> >>> That is not an easy assumption to break. The MAC might be doing WOL,
> >>> so it needs to be able to receive packets.
> >>>
> >>> What you might be able to assume is, if this PHY device has had WOL
> >>> enabled, it can assume the MAC does not need to send/receive after
> >>> suspend. The problem is, phy_suspend() will not call into the driver
> >>> is WOL is enabled, so you have no idea when you can isolate the MAC
> >>> from the PHY.
> >>>
> >>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
> >>> you need to watch out for ordering. Is the MDIO bus driver still
> >>> running?  
> >>
> >> If your Ethernet MAC controller implements a shutdown callback and that
> >> callback takes care of unregistering the network device which should also
> >> ensure that phy_disconnect() gets called, then your PHY's suspend function
> >> will be called.  
> >
> > Hi Florian
> >
> > I could be missing something here, but:
> >
> > phy_suspend does not call into the PHY driver if WOL is enabled. So
> > Jisheng needs a way to tell the PHY it should isolate itself from the
> > MAC, and suspend is not that.  
> 
> I missed that part, that's right if WoL is enabled at the PHY level then
> the suspend callback is not called, how about we change that and we
> always call the PHY's suspend callback? This would require that we audit

Hi all,

The PHY's suspend callback usually calls genphy_suspend() which will set
BMCR_PDOWN bit, this may break WoL. I think this is one the reason why
we ignore the phydrv->suspend() when WoL is enabled. If we goes to this
directly, it looks like we need to change each phy's suspend implementation,
I.E if WoL is enabled, ignore genphy_suspend() and do possible isolation;
If WoL is disabled, keep the code path as is.

So compared with the shutdown hook, which direction is better?

Thanks in advance,
Jisheng

> every driver that defines both .suspend and .set_wol but there are not
> that many.
> 
> Adding an additional callback to the PHY driver does not really scale
> and it would require us to be extra careful and also plumb the MDIO bus
> shutdown.
> --
> Florian

