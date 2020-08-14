Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F63244661
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 10:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHNIVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 04:21:03 -0400
Received: from mail-eopbgr50090.outbound.protection.outlook.com ([40.107.5.90]:50247
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgHNIVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 04:21:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tnfsi7YGsYbO/at5bbGviMUtnDKilWwQJsrqRLvwRjKuCItW2s2oXBprQtJm9HGxz8hHlg+UhUqvxhPF+TW1zIvsRlnX7ezgcrmzGy4YRf72fSNM6JmNSVb65Dpuaxd3lZdX9kxZRW3eYeQ15FQrtaCvveeABP1czWTayjNyMjiT+fI9mMzYFJsl/FhX1YC7l0A1/evg1gtVV7tCGPFQYtOZBxeCSg5AwlAg6mquXdgxRms+togXdUGZKJDvUC5q/L9A345ImPs/3e4pWBV/YZZrVaCfAHKLgnoTQnOsGug0AxSXguIdtRVaku/RNP+w5PyrHGqsZsUXCdo4eWJa/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCGvYX+bK8mKlUU4zwXn7HM9+yhnrWU/yu+ipm8oSok=;
 b=AWwlMpRpjeFIhPlOeP9lZWJijSjyiHrly37oOhwCDri+0CiCaYtiexOIhVPHTTelCH5E1Fbw+9rqcsLSuSVqL67Js4BXOv47aMdCsnajXo4ANFaUnifSZtXmo8oVjq1DAPjhCsDgYKLN5LdeiqQtHZ0vnf5+jEtM6+0gkqqauvqhZ5qXTsbmWgPKe3LEytzecrRSUfJ5frpW6yR9Dy72x60Z1JxuIsuFCKvu5fkeE9BE+iUX5giAFNnm21Fb47kpgy9ZU6ta7g2TPp1EFwgAkX8FTmNtp//NmYvzZpZfdqXEeWo58hEQt9cUiyjbNVTiNQLF7K8pv3L1AlnfvFxsmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCGvYX+bK8mKlUU4zwXn7HM9+yhnrWU/yu+ipm8oSok=;
 b=P3wEfDgj8X8NA29Dof6MRibMt7ucIjYLoyqdNv1wZbkP26CTFnKqre0s3OqxCpS9bZ4SekWyF0AyS0tPPflRJUW0BE4OZjpiRZFicKNG4gqTi1Y7jIyosH1mq4U8jPNL4w/q/UZ4RHXkZL64QkYJRyjEPAr8kXKGcqOWhoPoIUk=
Authentication-Results: earth.li; dkim=none (message not signed)
 header.d=none;earth.li; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0490.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.16; Fri, 14 Aug 2020 08:20:58 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3283.018; Fri, 14 Aug 2020
 08:20:58 +0000
Date:   Fri, 14 Aug 2020 11:20:54 +0300
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
Message-ID: <20200814082054.GD17795@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813080322.GH21409@earth.li>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5P194CA0018.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::28) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5P194CA0018.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Fri, 14 Aug 2020 08:20:56 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51c096a1-cc37-49d1-78d9-08d8402af8bf
X-MS-TrafficTypeDiagnostic: HE1P190MB0490:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB049053579D5CE8877278CE0795400@HE1P190MB0490.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39830400003)(136003)(2616005)(7696005)(52116002)(4326008)(956004)(16526019)(2906002)(36756003)(186003)(26005)(55016002)(5660300002)(508600001)(8936002)(8676002)(7416002)(316002)(8886007)(44832011)(33656002)(86362001)(66476007)(66946007)(1076003)(54906003)(6916009)(66556008);DIR:OUT;SFP:1102;
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c096a1-cc37-49d1-78d9-08d8402af8bf
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 08:20:58.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZO7J1+WjDRn4zpF1gBmUDsCAAphB640t5bsmjl7zvm+0kLOHrpSLh+bg6ESvJ83M1zMuiiQcKy98IBzu04FBUjaEd4T7a5c5RF6Lrw/36o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0490
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Thu, Aug 13, 2020 at 09:03:22AM +0100, Jonathan McDowell wrote:
> On Mon, Jul 27, 2020 at 03:22:37PM +0300, Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> > 
> > The current implementation supports only boards designed for the Marvell
> > Switchdev solution and requires special firmware.
> > 
> > The core Prestera switching logic is implemented in prestera_main.c,
> > there is an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
> 
> The Prestera range covers a lot of different silicon. 98DX326x appears
> to be AlleyCat3; does this driver definitely support all previous
> revisions too? I've started looking at some 98DX4122 (BobCat+) hardware
> and while some of the register mappings seem to match up it looks like
> the DSA tagging has some extra information at least.
> 
> Worth making it clear exactly what this driver is expected to support,
> and possibly fix up the naming/device tree compatibles as a result.
> 
> J.
> 

Regarding "naming/device tree compatibles", do you mean to add
compatible matching for particular ASIC and also for common ? 

Currently 

    compatible = "marvell,prestera"

is used as default, so may be

you mean to support few matching including particular silicon too, like ?


    compatible = "marvell,prestera"
    compatible = "marvell,prestera-ac3x"

Would you please give an example ?

Thank you,
Vadym Kochan
