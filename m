Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A793C3E11
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhGKQrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:47:25 -0400
Received: from mail-bn7nam10on2114.outbound.protection.outlook.com ([40.107.92.114]:16576
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229660AbhGKQrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:47:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Egz3HVx7ib8SSi7kCc/vdUTO8lA7Ermtj4hFa6RiRGQSYHMJod13BWQ0k/pwOtk+0wvgAmTaiR3INx4GPfpbppnbzTTEXwnRfhVS+97trUsMVk0rJmYBtAN2TKmh0tVY1YTst4CJbFDOgKwG6OJvER4XjOUsOqfTRXUIyFUe5VtD3P52rkxSsXmAdLGkV2K9uN2jyZv7zUqUiUAJg8+/sNyWimTFd2c0gKUV/hibZhAPJCvuP1iu+rPDFAj+gP1BCsPLOdWAX1PciqMR1FhuwyI5e0/Swn68V0ek+AfzNbbQur83sL+U+h4M0UaDaaAc7910HtxRgr+KJhqcyh+OGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnJvz+cUn/nV6LFlFBUYcpCIUZ36C9FBelt9VatCsEM=;
 b=h8vwXVhuN7jjdfBDpFPvLRdeZRZTHHAY2AGRRAhR6EsKPnpKyKrHoTfejSrBHJCoceZ9u4Nu3F6X4kTwnq2egGeyn5N4uRnM6R1hFW2S+dwscfFRipXgsQV0wv/ZhQGYJiX5cgdEEioKuKm8FA/hMeS907Uejq4eLhUHc3YF2X5O9qpzj0sc0A1TNgRrDYtTEbti4qwqFLdQOvIG5d4WqKPzSQFvKUYyzsgU78vz8PEP82VRPdip50z5vydZg32i66hcc2r/FhWPmfqlVcRzoBP5SMYEhpqZAVlr6ayR6//xCocjFcC5GvwqaBKoEossurbY0XBtiVFkzUwkkrjMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnJvz+cUn/nV6LFlFBUYcpCIUZ36C9FBelt9VatCsEM=;
 b=QJwFEOhwQ751vaHQPQ6HLbV0C0ohQKrT/RDMXqte/+vRXDJMsdwz9vHKutvgPeyWaDNC+v/0L07zCU8zxRvvIXs22hdCWhhbt1cvWxyXhY3t+0idy3pEeQYr5kJmd4KuZgXi0YKt/FKWMRDPQakeAxTZy6IUZ91srVF/xKTgMt8=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4611.namprd10.prod.outlook.com
 (2603:10b6:303:92::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Sun, 11 Jul
 2021 16:44:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:44:36 +0000
Date:   Sun, 11 Jul 2021 09:44:33 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 0/8] Add support for VSC7511-7514 chips
 over SPI
Message-ID: <20210711164433.GD2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <YOn8qSYqEufgfuJa@piout.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOn8qSYqEufgfuJa@piout.net>
X-ClientProxiedBy: MWHPR21CA0060.namprd21.prod.outlook.com
 (2603:10b6:300:db::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR21CA0060.namprd21.prod.outlook.com (2603:10b6:300:db::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.3 via Frontend Transport; Sun, 11 Jul 2021 16:44:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60b4eb95-b76b-4688-faed-08d9448b2ad7
X-MS-TrafficTypeDiagnostic: CO1PR10MB4611:
X-Microsoft-Antispam-PRVS: <CO1PR10MB461154CD61BD3DE44A1DC039A4169@CO1PR10MB4611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NmTRQC62f+V+74p0wsrufrVeBNMdmOLR+CGtcjEdtQwppTRXa5PqN6c4XQ+VpcMqYmvNhl2dfVvFjCNfIHFalRS+Vj0BihHUyFmNrSH1ATZ4GD8RXtQ+0OXc1IzUZX2WZZdH92t+w/dO+NLUsf5LNGyKb8qjZFIsnX4cc1pwn1U85p+NHOwbncPYJ8ix1atbCBo8cjJgmDB4PspTCovwYv/xTYr7trtAoK6YMU7I8kpWZaht/PPhUhebFkJqCOJ/vnMsCAQUQFWcboqULbWhYOk6t9JYYkxDXXTYe2fF2N2PaqaD4LeEeyYNMdbNpl5Cr7hRDHegprl4zZmrsyYqz+ZbUPSmQjCzVTWdzZmh43NvcEqI9yFI9TQPzXeWkBf4C7XEI6bRD2pFRpdF783KfoyYpUMzn9df0sgheNfSg4LK+pMZL+9TsltiFpVek0CbXOig/UNWlo/g0LqFiRMPpHTfT7lEtGOlvp1urPib0xTLaWNNk9h2ph32GPEerwL7ZoFRH44IqZYKF/nqVVDNlavOZsERsxXelmnLwJcUmfxnN6ut4SE0xmpAIabofD60ZElePhPM38A9DPDn+2p6xGKplCxzj6kmNy3ra7R3GMGVts2/7JNhW/z/6nMA5Wh/komDibMs9MjPvaHGPYu6dbHYCNXhu/gELKO0QVBOLSpYwqaR85lk/1WJNEgyDH27ysFB2RUcwv7JSntRG+L7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39840400004)(66556008)(66476007)(26005)(956004)(478600001)(55016002)(8676002)(9576002)(86362001)(33656002)(52116002)(6496006)(38350700002)(316002)(66946007)(2906002)(9686003)(44832011)(33716001)(8936002)(4326008)(38100700002)(1076003)(186003)(4744005)(5660300002)(6916009)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i9xXpt9twD17Y9JMzqQF4UZ2H/y+zjOIHtWzZJOUpTYBsR4yw/U6SSyWhDMp?=
 =?us-ascii?Q?+Hyb56s9J5XYmQjZ9uiaEy491rO9CQNMq8JxXGOn8dAPp3+/qgk4frHs+gle?=
 =?us-ascii?Q?rIpoKJAmIHBelTa4fpeyCLL8M0JPfzIG4UOrbxRBPl6aAKCmWEkBNqly7r4J?=
 =?us-ascii?Q?Lrfq+m+XFyCdwbg34eF7V8+7RKSJJgjzfHxCXLq2rHlysyUjgVzivvJQpBDv?=
 =?us-ascii?Q?gFWrTzbnphpM8ITTxMkgd29hX16tirf2PAmbibvl+SG4wP6F+1fAeZ945bGC?=
 =?us-ascii?Q?h8heGau6+x1tCegyG/CSefGmDjdb8OhR6ewRk77bIfPO9sTHxhK7d9LyOMfR?=
 =?us-ascii?Q?wmHAh4WpvD6XSIzSNEUqg3RaiDaQE7RJMrtlNmUY1hJX1jyvsO6eB/6C2tib?=
 =?us-ascii?Q?qK3pu0aVqGgu41t1vq6C65yvA0LSgsPeH+rRVIqxb0g/FqKAVGzJyv4GA1vJ?=
 =?us-ascii?Q?ADOfnjVSxOyjsLnKlDETdo+6yBu5OVg/AHRQK2PIGz74zWHkNu33ls4m+i2H?=
 =?us-ascii?Q?my3FGSjKqJwB98w6/H7G5wBHjKrgAn+42WkhlWaRAnfd1OJWFcLATscsTrWS?=
 =?us-ascii?Q?WLZyyDmNYNtiEIk1jF5y8PNr1L6OX5Zx8vy/CGhPfAQyAyTiuwPcLdie9ZQL?=
 =?us-ascii?Q?PdqkMKRlqbI3R6MC5k2+Dh70YOo5PBeugg9ge0Apte2eYzLAN3AQ65RaCOKf?=
 =?us-ascii?Q?ZqHR99RA9BVNuLgnP8VUbmqnWOltIBIRzujpYvYn4cpYSH1hX004JhWP9KwB?=
 =?us-ascii?Q?tycLPs5WKbgQZ5DrD/aptfAom8oDYsVcKRtjmoQunPhpEJmhkFTFaAh2DfZG?=
 =?us-ascii?Q?7TNT8imZ8E2ZGbKm7DEzxIzXbBVscNWvQU9LYFaPzD1sH79nYLypvRh4bNvE?=
 =?us-ascii?Q?n4pmt6aqpCM0nBlXt7VMm/XZgxIWUhkU43BPQTF3mJxBFEUXnMl8f4kR1O1j?=
 =?us-ascii?Q?iEX0VB3vCSxUCP1xKuJ4Vi9jSFkNKrDYWbP382sSpyaoJImVsFmDuYS6RCnQ?=
 =?us-ascii?Q?5cDv+/4/DWsRyxNuF6/TjiNCrae+dY54RCTnGMFUdpVbFh6o+UADDsXrmV/E?=
 =?us-ascii?Q?6oER6v05XVt+N45PvYGwlL7hLXHY4ycmV5WrQ4Fi/ANDB6dptlKv7yovsDrs?=
 =?us-ascii?Q?KPUyE2W/C0rz3meuoGFZJeimrb59G4Tln1r9eTZsf8KlrsMQWvtBHxd+OBAC?=
 =?us-ascii?Q?Zsx+WnDHcukjYvU9kCehioNKQMSJ6BLy4B7cfRQoKFGBOPa/ers6skj94lL9?=
 =?us-ascii?Q?jVAbEI58g+UaBbMREjpdkhBVFxzaA3WuEB2fBIfwcs0vNqNAY2HfmcW6h7bJ?=
 =?us-ascii?Q?i4Mrz8Qc8e6wvWCU7bLErmuW?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b4eb95-b76b-4688-faed-08d9448b2ad7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:44:36.2934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rI87RapiD+6r9szL1nL9tN8PZZhyP3AtHaVWQP3N70P+z4WbKT5Ve3Tro04eaqPuHbYUkmlCe5Ig/+uYJy6BGKK36zwMUb7MBdFKLMtZlzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:01:45PM +0200, Alexandre Belloni wrote:
> On 10/07/2021 12:25:54-0700, Colin Foster wrote:
> > Add support for configuration and control of the VSC7511, VSC7512, VSC7513, and
> > VSC7514 chips over a SPI interface. The intent is to control these chips from an
> > external CPU. The expectation is to have most of the features of the
> > net/ethernet/mscc/ocelot_vsc7514 driver.
> > 
> > I have tried to heed all the advice from my first patch RFC. Thanks to everyone
> > for all the feedback.
> > 
> > The current status is that there are two functional "bugs" that need
> > investigation:
> > 1. The first probe of the internal MDIO bus fails. I suspect this is related to
> > power supplies / grounding issues that would not appear on standard hardware.
> 
> Did you properly reset the internal phys? mdio-mscc-miim.c does that.

That code looks familiar to what I wrote, but the mdio-mscc-miim.c
implementation has the 500ms delay. That might be all I need...

