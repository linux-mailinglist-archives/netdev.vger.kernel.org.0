Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4018C1CD2CE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 09:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgEKHj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 03:39:29 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:6144
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728564AbgEKHj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 03:39:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR4TlL2xGffxYgUtqKP9LsRSodprz3v/xWzmU9kWAwZ0o2sTmNQG3OE0irJJM4Rjr7CKRIwagZlw1M+g2Ow7zQAVadVubp9SHSQhZF0KgxD9riSuoskHW6ndq6bpQ+6pS0YnSynqfl9EtX2+BtqlLIrcXf7B05w4tvSSIACGglfGFEd4xS+k6uc+yqmuY/L+4znFbaYbKOZuqF9COpRQMoPCuvfeS9dzU4hSqVkeCMM2pa9bIPgGYdCOukGXXBqEyS6CR36Mfl17k6685dizhMQ1iQcq3zSCcKacxbAJ6HdajGrn+Sdvgl8j8vFF/jpjPbFYYot+KoMsEVElWJj7XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m5QxZ+QonAKIeBDhhCF+PHH4T0n5bZ/Y4NjCqvwh5Y=;
 b=DvfZdv6xoZgEqvsp+tRlU+DR/T8Vq7iMooednthp1bi2gMBgFROX6tUpAsC0znHW6yiMzo+Um0MASKEyDConIaOvTBccf3bPLMsZoIK4j6NEhiVKhgEXdvBzj3l1i5txNBKGEdga49683oXaZV58wi8GETAgZEwle8O/5Q6TpIHoqwXVLhSq3pk4pJXxURqYTcg5RRAxHhtZk573iqtqtEEI7jlfkpZEOb7B6A/zCoKHz+Aj+aYvru2Nrkp1eEblcoUfXFyzlZdkKmPkDrv3QohpiQxtyYw5y9r5wlRivOJBa0dXANhzWJG7RdVRQhXt9XIy6qLZOUWtf9/iR23YGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m5QxZ+QonAKIeBDhhCF+PHH4T0n5bZ/Y4NjCqvwh5Y=;
 b=hm8VOOLHBtpBLJmQKMMLYLINEXTk4tNML/Bm8Ok6esVd+38YcAsznI0Qo/6AUMEx7yGvVhVJvy8oLmWWDIG2B1a05rmIWHVdJuKWtDXsHnUmAppJbI//1iGH0ZqXW53g27EU7QX2AIzVerpF8x/9vJrWO9h8MSRK4HMHD7sz9yA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4194.eurprd04.prod.outlook.com (2603:10a6:208:66::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Mon, 11 May
 2020 07:39:26 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 07:39:26 +0000
Date:   Mon, 11 May 2020 13:09:12 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200511073912.GB12725@lsv03152.swis.in-blr01.nxp.com>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0247.apcprd06.prod.outlook.com
 (2603:1096:4:ac::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0247.apcprd06.prod.outlook.com (2603:1096:4:ac::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 07:39:19 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7d926ff-e79f-4eb8-006d-08d7f57e6daf
X-MS-TrafficTypeDiagnostic: AM0PR04MB4194:|AM0PR04MB4194:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB41946D5B226BB3FB1F3A788BD2A10@AM0PR04MB4194.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/CIjRd7XrEsty0U0aL9MLiOSAjBofgmAVsp2Kuok/kmDA0md0OVlNEDqJe52+lXO0viykniklQYf1oAjhaUn+XVO13TqThpW68ffWTx5329Unt4xO69OpBBp+HwhpNlhkqn2mPKaQjSKTiwZpElNRxq+Z+jEE78L0vXuwMveW/t7Uz7+5SC9+S1G1LRJo+qs1rpPFpOabpFzP8ySRY9S/JDSGyxr50uX7PoGoQWO4pLRglDUzR7qeFayPbrAVamacw+B7bqAPNh2Lel0zPQkZq3gS1wWixrHL7Q/d4vNiYYPDP8+izj4imwxz3hQIwYqXEMsC4LLm7tbz5meN/634WvrV5gqLt07tsQXQXRWn+NLranqw51lHKtqcr58Y73+r9+kADOL8bmHrR8FMmZIH/Pzp7O46yHVJolmm+FngJPWdMhaHeNxEMXFqvCegf3TjczJ0lb1ZZa8WFw9iIIgg2LGpcyqVOZLszzD4SAu4FxrpN4Coa/7b3s1sk0aiPSyvZlLeLihKhpia/OteeuBEfV+hWho/nsT9i7cmUb1fRvLS8WopNlYhno86ORpgvV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(33430700001)(33656002)(55236004)(26005)(1006002)(6666004)(53546011)(6506007)(956004)(4326008)(44832011)(6916009)(478600001)(316002)(54906003)(7416002)(66556008)(9686003)(66476007)(4744005)(66946007)(7696005)(8676002)(186003)(33440700001)(55016002)(86362001)(52116002)(1076003)(2906002)(16526019)(8936002)(5660300002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9ckdkpFCil8z+UEF2QIVdvqkn7+V8nW7RuvBUxHiFm3YpNK2Y/2bVUykuCzGJGnn/4NAqZ+fAKXhrGJFO4FcwKm8+xKkKJiOZ5v8dm4MbFdCiq87iP6N9El0O1cuyr/h9Fl9LxtpdRvTHq8VfASets/8jwJlvEerDXoG/I4iZe601nBZw0m13e92h9BDjNauaoh62WmqJ+PLgtwjS/uiT86K3CGiPxDB1p5pTB2V9KR+SNeEM6FA5B6Qp+IWCGAbHE4MlgTwDET0cSWdggN7IKFwOzLwjlHcCMCH0UchT5giO+G5s15aWZh1Zl6Op8GIKD+Ok9ibdar4HQAh1Z8BjRXZNG8iGb3cFkxV0VKdC8dBc8msu4rNSEPlC9VbLzvYwIvQJe8Ql1rcr1G3rFMEbypvSIPGIiZ3/QF7AvEKFk98KojY8ZFs0vl8cjTyRsqbWdb0jwj4GfCpNGYFk7F9eP6CS4DEnaNOFZHqLgObIKg=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d926ff-e79f-4eb8-006d-08d7f57e6daf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 07:39:25.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYP7UTQj2kVsZ+YxDo5+llv6ER4IzxC6fW2HV3IMw4cnN9WQrpkuhQAjR1GAvtF+qZtPJLj/vcNzSyhiRTL2qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:48:33PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/8/20 3:27 PM, Andrew Lunn wrote:
> > > > There is a very small number of devices where the vendor messed up,
> > > > and did not put valid contents in the ID registers. In such cases, we
> > > > can read the IDs from device tree. These are then used in exactly the
> > > > same way as if they were read from the device.
> > > > 
> > > 
> > > Is that the case here?
> > 
> > Sorry, I don't understand the question?
> 
> I was asking in general, does this machine report the ID's correctly. More
> directed at Calvin, but part of it is the board vendor too. So I suspect no
> one can really answer "yes", despite that seeming to be the case.

I had tested RGMII PHYs(AR8035) with c22 using mdiobus_register. Vendor ID was
read out correctly while autoprobing.

AQR107(c45) PHYs that were connected gave back 0x00. This is expected
because the MDIO bus is configured to talk c22.

Regards
Calvin
