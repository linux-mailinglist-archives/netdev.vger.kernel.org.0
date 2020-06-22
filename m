Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7362037D6
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgFVNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:22:15 -0400
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:36935
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728164AbgFVNWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:22:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHQAyEXo5uBc32apLxUtG87cIEY6csY4seMHSsXzco8MZiHEkS4jMWGYR8R9OvLy8vS8nnn8IONjIulElYgOjfea6Q9CK8She/3wfxhMFHbUipir9MqNJbQUsk0jOsDyoiro/xT++Qey9CdXdvzTI5tr/sNsvPoZES90MzGAm52WGhtvPiATIKhts1Xn6z3MkNwIlLhJyLDnUXfTJcuY8EfTGQEfE0lH+lg4vJuU/pTS5kO/HJioQZycQPuH825hGNQKB2NJIJCKhCJipYtFU41jix2pILBWdBb3j2x4TwOkjngom5Z90S6MhU6Ge7Tl/8O0xxgeWJow5g3IeO/qAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2xGnW3fj7RI8BcdoBY5lQRxvH3WzUvYPM2b3eGs+nU=;
 b=njGYCqSao7w75vVUKAs44k3er5zNqDBZ5EjT6z/ItWjMvpTgvYOd1R9c8vnSIJwsOtTZ/nr+heA0Y/EkikUM+262xbzqJgefPiLwhKun0M/N0a0muN3RW+iKGwqqOr2ET3syXleYDcUDcDOa9KHbbyHFPK5W0akwRD6nhuc6BT2KOOy2h+Hk71tpEaTfUNYT0oDAFCm89u4xtrKyi5PU8SXbh9MA9QTVSnq3uvTHpNPce7y8+nwpJlP1UL/VBZlYXBoU4x3s5BUJjxHQM4YSMArRBMdanCUR+DCnmeLbf+E55w3EEaHoVZx33SGXN7Ei+3DmhKVPrhDOeVX2HLnoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2xGnW3fj7RI8BcdoBY5lQRxvH3WzUvYPM2b3eGs+nU=;
 b=hkVzuY2ap+nIWoB09DN+4Ms5hJGr7ofIefa6X6rIrlAbFs0FypwlDoK7RB6SMBvfEt8iiDpe2kj88htxMerzjGZlyJ8TtZwixVJA8CytXp8QDPcIrlyWQ9IozETahbRWzCD597ydLceDX2grDlAltxSuzX7+aCcjM+pO8VAksz8=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6177.eurprd04.prod.outlook.com (2603:10a6:208:13f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 13:22:10 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:22:10 +0000
Date:   Mon, 22 Jun 2020 18:52:00 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45
 devices
Message-ID: <20200622132200.GB5822@lsv03152.swis.in-blr01.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
 <20200617174451.GT1551@shell.armlinux.org.uk>
 <20200617185120.GB240559@lunn.ch>
 <20200617185703.GW1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617185703.GW1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR01CA0162.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::18) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0162.apcprd01.prod.exchangelabs.com (2603:1096:4:28::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 13:22:06 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6116cdab-6aec-4708-73c9-08d816af43fb
X-MS-TrafficTypeDiagnostic: AM0PR04MB6177:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6177069AAE4D25B001920E0AD2970@AM0PR04MB6177.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Q3JwwZ0bKB2c53kymxe+/NhiB0z5TXaj8RX8qRVZrV7zmrD6kZuWGsUiLN4jjiZXf1QsqUo5+I+zttf5dhk5ApaN/o6g3zbNvHz1VQaArCrifThi+fwfKSfiWwEI5H0OICigxGHmGca6PVryBHSHjmsmyIRh/4HosqkIT8LUhdxIW0q7B7iap6FdnyJJfhOuyh02c9oQguHK2rqpG2AUM3hlanISWWkqVWNQFJ0kKKxL0kaUTW9ubr4MG8YnLFJ4LAbm5SDFxghuFxhUOZvUuq/3xNjLYkU0R7X38b963f7z5VQzvn4aYp2Xd/i1nB5dLp80Mzfi7UUJfng0ALy9RrHY2Hlx+nHsGb17YRowszGLaPLB66GQHCnrCA1KAFv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(8936002)(956004)(52116002)(7696005)(8676002)(33656002)(44832011)(9686003)(86362001)(55016002)(55236004)(316002)(26005)(6506007)(54906003)(4326008)(16526019)(186003)(478600001)(5660300002)(1076003)(1006002)(66476007)(66946007)(6666004)(2906002)(83380400001)(66556008)(6916009)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /gOLdtO5f32lyI/ehjMoIbtLZhMz81Pa3SQE8+nnjor2ICL4YfBZq9Mnj08AgRacW62KGuyBckROvAWRxDvgqdfoJJxCkGmrRIMwoiZhG5zxYELTh4q+P2npfHYZZ63rk9ZZY6O/615YavtG0TjkH5n2L5n0Y3o6Atj/+bSQ/luHk/fiXxOAGWT5YmFFr1eH9s7leY2vqMNH56H9Z+DD2CpH0umhv6Ot+E7Mt7rhcfiH464PCZ5A95SjHI+iD8vFe0ClCLr9Q0H35Jba65yj+phqpkNbqPKyZHaEnbih0R2QQIg1mjHoZcAF9wvrslblhQr+11rHjiC+jqgtbRvysfxoP1pa98qximSEHs6NyUaQN2LCN0RyG/Qn28DZezuSZKnGnvYAOf9qvn6wZQ2bdNzwYXMd2l4HdgqpTLLj2FlrXNHteA05+r9OTC4lNayLYB3XdUmR4GyR5Vz1FHRxsdSCAp1vWWRRclSzbG9Usk3NfswN5zAXJmybufaV7sdO
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6116cdab-6aec-4708-73c9-08d816af43fb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:22:09.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1C6lfn6AQIWPYMNj3w6r+LqvHSXqHwZGn6Eb5C5ZuPOyJm2pp/M9r5Wr1oLAItzu38wp2L++MLZoIBNDwa4OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 07:57:03PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 08:51:20PM +0200, Andrew Lunn wrote:
> > > > +	/* bus capabilities, used for probing */
> > > > +	enum {
> > > > +		MDIOBUS_C22 = 0,
> > > > +		MDIOBUS_C45,
> > > > +		MDIOBUS_C22_C45,
> > > > +	} probe_capabilities;
> > > 
> > > I think it would be better to reserve "0" to mean that no capabilities
> > > have been declared.  We hae the situation where we have mii_bus that
> > > exist which do support C45, but as they stand, probe_capabilities will
> > > be zero, and with your definitions above, that means MDIOBUS_C22.
> > > 
> > > It seems this could lock in some potential issues later down the line
> > > if we want to use this elsewhere.
> > 
> > Hi Russell
> > 
> > Actually, this patch already causes issues, i think.
> > 
> > drivers/net/ethernet/marvell/mvmdio.c contains two MDIO bus master
> > drivers. "marvell,orion-mdio" is C22 only. "marvell,xmdio" is C45
> > only. Because the capabilites is not initialized, it will default to
> > 0, aka MDIOBUS_C22, for the C45 only bus master, and i expect bad
> > things will happen.
> > 
> > We need the value of 0 to cause existing behaviour. Or all MDIO bus
> > drivers need reviewing, and the correct capabilities set.
> 
> Yes, that's basically what I was trying to say, thanks for putting it
> more clearly.

Prior to this patch, below code which is for C22 was executed in this path.
	phydev = get_phy_device(bus, addr, false);
Doesn't this mean that MDIOBUS_C22 = 0, doesn't break anything?

I think for DT cases, there wasn't autoprobing for PHYs and this path wasn't
taken.

Regards
Calvin
