Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9B4567E9
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhKSCRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:17:48 -0500
Received: from mail-bn8nam12on2136.outbound.protection.outlook.com ([40.107.237.136]:3680
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229830AbhKSCRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 21:17:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiXwfg+Vl+GCYaG6E9wH7dMvRqyySWfps8tVRoXt/3VwY3Pro6DD6Agt21LoQb+h7O+qzswv1ZHi6OIidQAj1+vvtrcOlvZC86TujOkgN3Tl86QUBxZAaihkjkyfk+/shNOJcahFRANKSCONaMAI6xvnp3lKXmUaD/PT6MQhObi7Ynja1/FyA2CgTRdEfmVzZJkw0CRhlUw9SDR8imivPp4v/QtLBPwyvnk29p1YsvsZdlDxEJHs/jbAtnJ7PfnWIsv9wskvFkJO0opmp1HtLuSvBBvs48jGSfc63XJ6ynSHmrX02trHJWx2FKEBQ6CclRQMuaMX40+c38B3WPvE3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTRZQP9bPX6qJGRsKDH+KwEEcqt7DVAAaW1vJJTacng=;
 b=HWiapboQh/nBcVFKsbIhGQkOq705jZmRlcHolpw17BMMdp6pcqca6kMEiH1YytBiMdw2P3nePO4ei/KA/uP2d4GW8gk5D6HzoqzWJkxkWIY510ReV/FZyj7FdInBz9kZnzMsdrE+hjahnnZy9YX+BLX0hyNMeHoigkouDX6fPZ8LiIjk5hRiXTKva0qsam+UnWwZSqUx9jVTiK5+daNykI2SqaidxLFeBm4n77TbAB1CP8YrS54jDpKqgN3urI603AFR0El5Qgcc7eFYfyIuHxE6oQcVTIImjVzr1TikF+Ru105pAKPPUS6yxFGkofClSBHPYG0g3HbbXKKJM3H98w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTRZQP9bPX6qJGRsKDH+KwEEcqt7DVAAaW1vJJTacng=;
 b=Wzetzxsu+JemVOlyckCg7RlkkIsuiu10uhGo5FQKnB63XrmjKoM+K5X5Wi8TsO15FJP1+NUGkqYvqWG9x4F0tdFhOOvDpPKioR1C+fByXuUfm7KryJKfhc3ICGtbT/eMDbgwB0LJFW7FfuPZ9hQeKfyGNtFoJAVq81wkKSoJMEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW5PR10MB5805.namprd10.prod.outlook.com
 (2603:10b6:303:192::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 02:14:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 02:14:43 +0000
Date:   Thu, 18 Nov 2021 18:14:37 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Message-ID: <20211119021437.GA1155@DESKTOP-LAINLKC.localdomain>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <CACRpkdaFmFFpYrreFsD6XRPAoivDPK1nSfAVKacNG8bWUR7rHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaFmFFpYrreFsD6XRPAoivDPK1nSfAVKacNG8bWUR7rHQ@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0152.namprd04.prod.outlook.com
 (2603:10b6:303:85::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MW4PR04CA0152.namprd04.prod.outlook.com (2603:10b6:303:85::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 02:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ccc7744-2d60-4b11-f09b-08d9ab02597c
X-MS-TrafficTypeDiagnostic: MW5PR10MB5805:
X-Microsoft-Antispam-PRVS: <MW5PR10MB5805A3DC7A2469AEF0393696A49C9@MW5PR10MB5805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVhQvekhGe8UzjvDsdtV1Kq1p1WEJmR+c/D8iTa+pQooQc7X8UWUWNHlIfOGI3ns78rEDs/PpMM/dBwihejxkOkNghxVHDYYYjRr0kw2fYHFds3zKa/RVtxYfCSdSy96OtzC0UDJTmr2jO0vj50RNSOa9rVeOL2r4NpEQIZR3Ovwd4wKYsa05dkItM+BFfA1ST/NB7NkbKWjB4Zkzrs/v50OA4zNMeLD4IH7rB6CSDkWPYqY915Jcxt6ZmoBr6kTyNgVO/v84kCIcVf6yolxS5ig3+cFgp9Tupjv2HpBwwY/jwZ4+u6BuEB1zTQPdKCg8CKMOCmj2DSOP634r6lsJmPpBfjVJY9O9cD9t+F4MBDziKPE8nUskYyBtr8jIy7AK50reiYUG8x1w93qIW4lKOapsTVzlCz56z+ecXnwC7MEBC4JHHkq51vq1HPvsY8+0F9zdTplajpfzvg0sjM1+uZsJZmLDmqRWjppj0/0Y7RV0Bjf0WDUgLS6WKIQIxvhjsADq1+vmkh70JjO9Jc9cq6abTd6avy7byq5bmtf6sxEyfzuBQcoOMVpz+WLkDZjAg2DXSi2jVRI8JACeZ0/PhAXJ3sv3lkOwQWs2jbJF/ouYtMz/WPczSeyD6Q+xlNH35URWyGm6amxshgy0BiTOyAS2T9aQguRLkkDqtmu1kod+D8icatjHaag3EBLRF5TS71pdFd7sKdSVQfwirWrwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(136003)(39830400003)(7416002)(55016002)(52116002)(54906003)(7696005)(508600001)(2906002)(1076003)(26005)(4326008)(86362001)(5660300002)(6666004)(38100700002)(8676002)(38350700002)(33656002)(53546011)(66574015)(66476007)(66556008)(6506007)(44832011)(186003)(8936002)(316002)(66946007)(9686003)(83380400001)(956004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTc4WXBwaFhTUmZJWGQxeEMrb3ZhNlY5WmFPVVErVnhQMTZrMHYzV1U3aGNS?=
 =?utf-8?B?UUI1ZHZoVXFRcWEzekswY3NKak4wckROb0VWMGZ2VmkxamV0eEduV29HY0RR?=
 =?utf-8?B?S1o2ZHBzcllRT2FhUFlnZkU4NlJkcFkwYnZYdk9zbW8wYzVGNXhJSEF6amh5?=
 =?utf-8?B?SWhGam4ybmxoamQ3dlZlditRUlg5aVlSTVhsY3BtczlORUdUczkzck4ydmNX?=
 =?utf-8?B?K1UwWWkvVmY1YVpzVWpIQ1F0UXlRejlIL2ZMdjZ3WlRXdDBlVi9wckRhYllJ?=
 =?utf-8?B?S0hvMEg3dnJpRTdiUHhzUUtSKzZCM3YvbzJpL3l5SjR0RzFSbUhaaFdSNXdp?=
 =?utf-8?B?SzhDWVIvcThGSHJYSTdmRk1MTVoya0xoVitYMUhGN08vNUVneGVTRjRxaW1H?=
 =?utf-8?B?UTJkOExLRk4yWHhVaFIyRjVMRE11bWhVeFlQQkFpTHNDRTAwNmRGVkJCSkF6?=
 =?utf-8?B?ZG80UUVmZkNEbmJGOVVQbStjNmYwOUU1eDRDTXkxUlYzVEhuRFNXMVRST0Y5?=
 =?utf-8?B?RDdGdVNmclBKQmlEV2Z1bVRhYkNyclVrUldQSkxrVGkwQUFoY1V0R2FhK1Q5?=
 =?utf-8?B?aWd4cUVndlhRd1Y0UHl6cEw0SCtISzJ2RzdSYUNZdjh4Q2wzVG52UDlRNG8x?=
 =?utf-8?B?VjlpczZSMGdpOXJRWlQ3dysvVWFTWlJTYkRWWEJuK20ySXNKbnJaem1pRGNo?=
 =?utf-8?B?RUY1Q1M0NCtJUURxaHRUUGFWbzIwL0xycmthUExpcG5UZFhVWHQ4MmtCZVAr?=
 =?utf-8?B?WXp0a3hkSkY3Y1JUblpPV0xhUWVpdWhTWnU5VUdSa0tCRXdhUjZaRFBPNVJx?=
 =?utf-8?B?RHpoWFBtbmg5MTJPWXUvdmx4SnEwWWhiZmVKYjg0V01JZVlXL2U3NnhReWsv?=
 =?utf-8?B?Z1hYRXJYYmNaMmU4UnV0MUZXQVRYU1lKYUJuTSsrWjdqZ2N4anNueUJtMzRn?=
 =?utf-8?B?Uk1hRkpuZ0lmQUpXUCtCdytMQ0NiU3FpU0UrNWtVZjNHQzgxYlcyRXJYRHM5?=
 =?utf-8?B?bkI5ZUl3UThLa2x6VW9TVU00SjFzQmlMV014cWZ5NUppa3p0U2JaZDhIUG5x?=
 =?utf-8?B?RzB1QVhoUHdySitRS3NacCtXaGVhWGVlY3F1Ky8rOHBHVnp3bG5ycTR4TlRz?=
 =?utf-8?B?Uk50ckNtQmhOU1VwSWlCVUFkc28xeVhCTytYS1BCTzFORUlqODRnWDZORkdS?=
 =?utf-8?B?eHdYS3VxOWFpNktGYlY4VXFLUjcwVjIyZml0SVN5M3dRbEQ2cUFVZjhOdlMz?=
 =?utf-8?B?SGhud29HUUt1YUZFc2V4QUNYWndvN3RjRUZKbFNTbFZlSVltVkVuVktObUxz?=
 =?utf-8?B?UmRKaldLN3NNQUNlT2RyYXhQNkkydnhNMlk2T0syOVIyYStaUm14bTJ5ZlJs?=
 =?utf-8?B?NzhWY0NhNGd5UWRZR3BMZk1CUXJXMTZVdDk3aGNBdkgrQVo4QkVCSVg0T0ZO?=
 =?utf-8?B?UUZORGkwTTJJUXl6VGdPT0RKTDFPU2dTZWl6QzRacEF5TTdpc09qbTYrclcy?=
 =?utf-8?B?SWdHTy9wNzFmdmd5OThFWnhzL0hUMTZRUFhVemxhakd1WG1YREowRWltdEFT?=
 =?utf-8?B?Ti8xUjR4NlN5OEIxVnc0VnBWbTVvRGFjYjhsTHdiMU9qZ2owRWRlb2oxSGdZ?=
 =?utf-8?B?V2ttdnRZdW53Qk1OeTZYUXp5VWZxYmFzendTckI2TWQxRDZ1Z1o5VThrelJN?=
 =?utf-8?B?ZFgvY3BrWkZJSkh1OUxPeTUzTnlCNTUzT2gvY09meGFxUHpRUkErZS9ETXlK?=
 =?utf-8?B?ZDV2VXN2OXpnMFpwVUltUXhSVzMvZVRCeTNpNytTalpSbENDYldHSlB2TFo5?=
 =?utf-8?B?NDZELzZYcUZLWmR4a3FZdmJrWFozSERnRXJEYXZoS2pob0tCbGlULzc4QnBw?=
 =?utf-8?B?QzF4aFF6ald0QkZuRU5Fa2FQUDJmcTR2SURTaVF6cllxc2NyV0RReDVZTVJy?=
 =?utf-8?B?ZmZYNGNHYkRpaWdVWG1pdGNlS1lZUEdpTmZkVmVqRzNodnl4TUtVc0hCU0R4?=
 =?utf-8?B?QmlkVUhzdStRdTVWaERVUVVYY3RvWDhwRTZhNHVzZTdaMnlWSlE0MEowNXBj?=
 =?utf-8?B?aXM3ekc3L1owWWl3cjFxeDIzUVZkVEQwTU9mWDdmWis0MDNkajBleHZiZEtC?=
 =?utf-8?B?dDJhaG1DUjg3NWRDQ3o5c1hUVWxpOTFnamo0dVJxV0p0Q3dZOU5IU3pVNWJF?=
 =?utf-8?B?MWxpeDJubDd4UDNMaDFyV0FpSTFuR05BUk5sN2ZPQXdXaEd5SlhrUDFuWG1Z?=
 =?utf-8?B?UC94QUllTVh3SFNWeW1Zc3Z1UmR3PT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccc7744-2d60-4b11-f09b-08d9ab02597c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:14:43.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zpqeQF/FJWwSJhwu6xGJltgkQiwP3twYc2TGTX0I/O7XDxNB4d7uXnxid+qJts5tKC9dybjWGwmZRFP4eonvRRZiYKy5P4buMR60OLzzJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Fri, Nov 19, 2021 at 02:58:47AM +0100, Linus Walleij wrote:
> Hi Colin,
> 
> nice work!

Thanks :)

> 
> On Tue, Nov 16, 2021 at 7:23 AM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> 
> >   pinctrl: ocelot: combine get resource and ioremap into single call
> >   pinctrl: ocelot: update pinctrl to automatic base address
> >   pinctrl: ocelot: convert pinctrl to regmap
> >   pinctrl: ocelot: expose ocelot_pinctrl_core_probe interface
> >   pinctrl: microchip-sgpio: update to support regmap
> >   device property: add helper function fwnode_get_child_node_count
> >   pinctrl: microchip-sgpio: change device tree matches to use nodes
> >     instead of device
> >   pinctrl: microchip-sgpio: expose microchip_sgpio_core_probe interface
> 
> Can these patches be broken out to its own series and handled
> separately from the DSA stuff or is there build-time dependencies?

These should all be able to be a separate series if I did my job right. 
Everything should have no functional change except for this:

> >   pinctrl: ocelot: update pinctrl to automatic base address

Fortunately this was tested by Clément and didn't seem to have any
ill-fated side effects. 

I assume this isn't something I wouldn't want to submit to net-next...
is there a different place (tree? board? list?) where those should be
submitted?

> 
> Yours,
> Linus Walleij
