Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134B12449BA
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgHNM1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 08:27:55 -0400
Received: from mail-eopbgr140111.outbound.protection.outlook.com ([40.107.14.111]:31456
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbgHNM1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 08:27:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUjyrEpFMfmxGwZi3JbrQqbEaCK3J+YpIhUbainevp2YShae9enQs7yiX1IkgT0+7199avCOLsC9cxpivRHtyqbRwuwvlS30vlh5kIauHG4yp6yQYHdlEL10pPVjp8D60CVrt9OUYuONPiigEikOzh9BuZnlYB8y19iiRcWfBXmpMjazycMcpVjn8oAgkZaA5kAt1BpVXTwgYHZ6dGAapT2eqcOj1l8U0A1NL/i8obGFIl99c5kol37QWuRDz6i+8EW+dEUqyx8S3GCq0TqXphNg4twZKMxKZGiPJ0llldjS6PUJN90r2DComaSYmizyotmHWTZpyal/9Z2YQJdKOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ludUcZZnmjYNVxKyAICb2QB4M8t0iF9X30zSnu98QfY=;
 b=lo12hp+dEmpoSoiOkSDDxzzlHWXUfVgHNsUxzTST7dOQzOJ/iQHj9YeDb/DTssA7dAebp/HrkYkyC2hPLL5AEFYmr4FllDPEejmIX6v1E9N8r1XI4R5aPZLCpGnocD022AH54dWNyl8titN4UFQiutXNTZYnFxAlblPBHCBBIPe8LvFeMQpwzXUxzakDrKAR8xNy9CCmsbJDfDIQtp72OhuZiG2hy3lA18xrzo+X2Slou+MNctBTdoFjdnf5o3TrPed/PhjFrg7OdLITePag5J67p1BbO07wQl+f0sLbc2NqW6zXFyTcoofkgM6eZsN7Vtn6Q1wzODlz/hx1HpcAag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ludUcZZnmjYNVxKyAICb2QB4M8t0iF9X30zSnu98QfY=;
 b=LUdX5IAYF/LYHsYv8SVtO62CPk57me63XJrWrRRY9vqwNi4XIdNTKRFdP749vUKOPZw53/E7FJJI27VttVh1lH14R9hGAkDku1aU/skDIa8JqbM1A5eUJJbDbd7ZPGG49W72GH7sousoNjxHewUAz+ipCZMstr9ywHOf9agVJWI=
Authentication-Results: earth.li; dkim=none (message not signed)
 header.d=none;earth.li; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0361.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.16; Fri, 14 Aug 2020 12:27:49 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3283.018; Fri, 14 Aug 2020
 12:27:49 +0000
Date:   Fri, 14 Aug 2020 15:27:44 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200814122744.GF17795@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814120536.GA26106@earth.li>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR1001CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::31) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR1001CA0054.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 12:27:47 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af997fac-a920-4a16-dde5-08d8404d74d9
X-MS-TrafficTypeDiagnostic: HE1P190MB0361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0361654E568F6B66132858AA95400@HE1P190MB0361.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PixtPe28l4V8yqiiUKUoqKYiqAt/Kr+P46ntn1LOS1tbdDdEW4kaVio9HCTWj/wVsWiCXPWVP2EtwwuiUh/BOnsHUPUxZXbV6kkhYlLR0ROPWINRNyUomaZDQxUB2HwJdugnrj5P1A/jTBf4SvCQTu1BQa8BX717/0IdFqGTkoyuxiYG75v+wATxjgv6d3apViW7tRLIlWjD2CnOiX3XEm6GqXtaOBax40RORmWJg1mjDXzAyThWW4P/yEfaapIXkSZuC+Tq0GAXnrV/dM4aoumnc3mmHVVGFXhHBA/dYk2OpXZwxGnranujD9GabQ05SUEMiONInohbLhxQUd/pUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(39830400003)(376002)(8936002)(956004)(7696005)(52116002)(33656002)(2616005)(6666004)(186003)(1076003)(316002)(54906003)(83380400001)(6916009)(508600001)(2906002)(7416002)(36756003)(86362001)(5660300002)(8886007)(8676002)(16526019)(4326008)(66556008)(66476007)(66946007)(55016002)(44832011)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fqP8B1dyYbj53bdlkNqarVGJ2NY5lBZAvrbMykf1pDd8g5Us4mLWk9uk2ZIjzgw1DCxbSjA3dLpbN9t6xyrvMvl0EcoqS6pLFaLl3/LuwsDUSHc1VkeJlLDJLvpjBQkyX1djXBLvMZ69SXxIPRLNWGfhqzshLhkiL8HPpqg0CSWLHVbQ3QA4g5zlu1qILYHaJQs0y43grMxjFjkGD+aWf9MgzyXYHa7mxYaZSWn3bYQWxjBJdykFfP/4e1/bnoKZPCItU4+xEE3IaR7CBMunqQZmjer3/z//szFpsEGxNWn5MOyJwiktkSmtgsi/nKFUyJrs4r9PtNXFjibrnz4N4M68sUH1FelaXoSD0pcvDwDWJUmX0RJ5ZwhAT94zch/ojFUTPMP8ZEKEcJBwkJFMTLY5XETonuje42I6HeDxsfPtf9IsMrvxI+FNCjHiEiD1XBv4oYJq+o6TLISDNG/RBbC8KieUlbowO8gtDeINKXIPyZqYeiKdAglSV7d5zj5R7tEHxCbJUyguOpoEH7FN6Gexsl2PpzBzZUDAjQoQ5/sR3UYVNHcotkuVWWSzXx37EvXK3GgcLvfyxgrAOg/h0y3+iWCDOSHCMFS4SsETRPk+n+T0KZhI9ezTFwVnUzN5QgY2jw3JyB/gtlxfmtzFZA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: af997fac-a920-4a16-dde5-08d8404d74d9
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 12:27:49.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKa3/eYSIBy01TmBmL9rQAYexPir5ENJYQ8QF57TZ3x3gIJ0fc/hVrPwqixa86aUZsqBO2Opl1Jfhva4eGnIDuM1x+YJCsEO76wpi7nb7eI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0361
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 01:05:36PM +0100, Jonathan McDowell wrote:
> On Fri, Aug 14, 2020 at 11:20:54AM +0300, Vadym Kochan wrote:
> > On Thu, Aug 13, 2020 at 09:03:22AM +0100, Jonathan McDowell wrote:
> > > On Mon, Jul 27, 2020 at 03:22:37PM +0300, Vadym Kochan wrote:
> > > > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > > > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > > > wireless SMB deployment.
> > > > 
> > > > The current implementation supports only boards designed for the Marvell
> > > > Switchdev solution and requires special firmware.
> > > > 
> > > > The core Prestera switching logic is implemented in prestera_main.c,
> > > > there is an intermediate hw layer between core logic and firmware. It is
> > > > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > > > related logic, in future there is a plan to support more devices with
> > > > different HW related configurations.
> > > 
> > > The Prestera range covers a lot of different silicon. 98DX326x appears
> > > to be AlleyCat3; does this driver definitely support all previous
> > > revisions too? I've started looking at some 98DX4122 (BobCat+) hardware
> > > and while some of the register mappings seem to match up it looks like
> > > the DSA tagging has some extra information at least.
> > > 
> > > Worth making it clear exactly what this driver is expected to support,
> > > and possibly fix up the naming/device tree compatibles as a result.
> > > 
> > Regarding "naming/device tree compatibles", do you mean to add
> > compatible matching for particular ASIC and also for common ? 
> > 
> > Currently 
> > 
> >     compatible = "marvell,prestera"
> > 
> > is used as default, so may be
> > 
> > you mean to support few matching including particular silicon too, like ?
> > 
> > 
> >     compatible = "marvell,prestera"
> >     compatible = "marvell,prestera-ac3x"
> > 
> > Would you please give an example ?
> 
> AFAICT "Prestera" is the general name for the Marvell
> enterprise/data-centre silicon, comparable to the "LinkStreet"
> designation for their lower end switching. The mv88e* drivers do not
> mention LinkStreet in their compatible strings at all, choosing instead
> to refer to chip IDs (I see mv88e6085, mv88e6190 + mv88e6250).
> 
> I do not have enough familiarity with the Prestera range to be able to
> tell what commonality there is between the different versions (it
> appears you need an NDA to get hold of the programming references), but
> even just looking at your driver and the vendor code for the BobCat it
> seems that AlleyCat3 uses an extended DSA header format, and requires a
> firmware with message based access, in comparison to the BobCat which
> uses register poking.
> 
> Based on that I'd recommend not using the bare "marvell,prestera"
> compatible string, but instead something more specific.
> "marvell,prestera-ac3x" seems like a suitable choice, assuming that's
> how these chips are named/generally referred to.
> 
> Also I'd expand your Kconfig information to actually include "Marvell
> Prestera 98DX326x" as that's the only supported chip range at present.
> 

Yes, Prestera covers more range of devices. But it is planning to cover
other devices too, and currently there is no device-specific DTS
properties which are used in this version, but only the generic one -
since only the MAC address node.

I mean that if there will be other Prestera devices supported then it
will require to extend the DTS matching string in the driver just to
support the same generic DTS properties for new device.

Anyway I will rise and discuss this question.

Thanks,
