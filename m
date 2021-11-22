Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8AC45934E
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbhKVQtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:49:03 -0500
Received: from mail-dm6nam12on2100.outbound.protection.outlook.com ([40.107.243.100]:6848
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230406AbhKVQtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:49:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jab4HZKn8RuZefgwOfMJkJDC4GGd4esMnbNLiw7Zq1crnRptQ1l06nyuxkwi+ojQnaMGZNAjiaZGK8YZqcsrUY09hXrE3hBCwD9uoodGSEaPUcTg2mrtwI5sW+Vbb7XBswMCNTZTenbod83D5c0bD2nVFhbbfxsm38XUIRDYqTKMzo6b6YhEYRADGgVtm7Jd1LjGzFjPqR1jhP4/6y42/PK2KfmChKyl7E/rRFCxWPkeOKsZP2yv6Q+88rnf96PH8LBJe7zDt/90dmNm40l3+2+daRx6lov1Moj5cKzo+FFh7QRXs2iW5fK8Cxkx4vyYgbQ48/fFbQLCElRPekZDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqT6wjzI+L/0yuQ4SjWWs8RmeH/fGLuxkTsaPtjxW/k=;
 b=P6ASWxsykHHG2jFQL22qPlwGrPu7DFg1QGEwI+IkxOejerPQ2KKz5YSrrFHN/1PMRjx1w7AsGtdzxKDsBjvTq3hC0yuVuvwvtGOIHMFIU4fFyyGb4aUgqe4J3leHa+Xi3kaJo+tdUAfdTzFK/bPLdcHVo6ebZYn9uQIg4H5YUibaKbJGQdCBOzqoL5Cqi5hK+2BiJ13v/J3mkUn0lMeli14v/7OqVHmYul6FIcWCl6EK/Jxn0+4CQl5OdqOat+3y4uhDznhQy7zBabI3QZFapQkhIUZVA/gWVjGED6Dxu761U8hCHkehrnHvPgkDU7apBnRP06WyBJsngm7LolEvpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqT6wjzI+L/0yuQ4SjWWs8RmeH/fGLuxkTsaPtjxW/k=;
 b=hBH4xlTwAR3aiv/NDGJECccHnEdQQ9LoMHPIaBFPFea5FQDNKkIoggxUK/dAQ4IGFmpEHRbaDPd6VDb/Aq88636IR8C5/2q9quyQHd0pZFgcX6dKjkTFlFPBnP0Un1PmnpZiCkIvoHxk7qnkLakHQYYQwRXT2AVIuSBqIflioK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2350.namprd10.prod.outlook.com
 (2603:10b6:301:2f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 16:45:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 16:45:53 +0000
Date:   Mon, 22 Nov 2021 08:45:56 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Message-ID: <20211122164556.GC29931@DESKTOP-LAINLKC.localdomain>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-4-colin.foster@in-advantage.com>
 <20211121171901.nodvawmwxp6uwnim@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121171901.nodvawmwxp6uwnim@skbuf>
X-ClientProxiedBy: MW3PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:303:2a::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from DESKTOP-LAINLKC.localdomain (96.93.101.165) by MW3PR06CA0009.namprd06.prod.outlook.com (2603:10b6:303:2a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24 via Frontend Transport; Mon, 22 Nov 2021 16:45:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 051e86dd-5196-48b8-fd0b-08d9add78c1b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2350:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2350EBBB441DBA581AC07A06A49F9@MWHPR1001MB2350.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2A0oWC9kf2CUXw8mtzvMMFS/TLAuWfIYGHdgvm14zRLVRwBmQGHMIDWuD2ywyfq/Fx1GUOLpke8v13/zqH08FlLaAXoAdw51PAaNzAbTNQWQlzr93xWk6+bt/DVxgH+5jlLE1WTzGvXIdBx2InP+Vr0LjImF4SLoZNtfkXE1uetHzqPSCK5H6Fyo85vlV+ZCBTrsDL2QLQPE5LYtcEl7ZdKxBK2v/dqRI3y+zc1LqpwFDx2gCLJx0OtWH6edd20t0oDjpyxhgqCMJHRps74NBGfQqvqT4Afe51hP9MsQDKQg5pOxIEReoN9c1a9DtoQd6H97sWXReMx7m7jSn6pQTx3MUjeUoEMk9JGNpZDi99VglaAUVZGknxzu9noc5aLmunjaU+c+lUjrcTqnNjz3ArFUoNa2KIfTRnZ7O09RgMcxmRnFsRtWcBVQlz0dAVsEE5zVmhMFMXnV2pv/HylslTU9pIERD3vfsm3N/DOduHZ8gcxxlwf2RLLe7QY2DD2A9fyNL971W9D/TMvHg25uwjEYmRu5iGt24G3pschy4tbgDKtwq5ok+cxdiDcTw5VkrlJBcHLkuHBidWGdWTm/WJ0v8gE6xaKpS1f4BYOt3Zg0CtkXlECE9hX18sQXNvH6gJ+VazjEYQeICQY44xWUrSRQfNFOyILztZsgQvQzqopUfCoqCfUS+obiVDmckyc0t1ghPoOWorTHQVtUaj1S9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(366004)(376002)(39830400003)(52116002)(38350700002)(316002)(38100700002)(8936002)(1076003)(4744005)(54906003)(8676002)(186003)(55016002)(9686003)(6506007)(6916009)(83380400001)(2906002)(86362001)(508600001)(956004)(5660300002)(33656002)(7696005)(4326008)(26005)(7416002)(66946007)(44832011)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hkgn+0ANjyvcBdaT3RFDWBfsOyvKvKUerPjYwdAPb3aCjD+GhJiWFWYb7Qfr?=
 =?us-ascii?Q?V2JpLcvY3HckOekhiJeelXwZrUHB98OGpbM4Ox27H8o4iYD019raEVqRIDHJ?=
 =?us-ascii?Q?WX/dSndN6Ls+pHC5HR7fQRI+d/RrXD/DiEfU/GitW2USEo8j+lOsaGlXYS4U?=
 =?us-ascii?Q?mOjFM1s21uLqTCVcepRzqn1HkovvZHbwqAziNHgvm7E+rv/qETNMjauybYRZ?=
 =?us-ascii?Q?1RMX7GYD9aCXA8gE1QFEX8TAKGuPeu4HNCHQw7FEQSZKp0jGMMgRp1aWt0bS?=
 =?us-ascii?Q?hn6gjTEaxjZeXcW4Ifn3bmQIlYcyw6VmVwsbiCi+3qLJu2B02KASJuFXrBUW?=
 =?us-ascii?Q?tY9thfmFyjPuUUsHuSXwsfa/l7MqecNhDz70FR5wLusnWscyJXGuq72btV6l?=
 =?us-ascii?Q?IvgpmBkmBJOYiRpW/4VmH+J51Np3It8p0eJSYNjyFkxLsZtvJWJZZxX/fAX3?=
 =?us-ascii?Q?6xDMX67BIHDrfUaORKkTGBqHRObkeBzsgHP6O6sR/Ubym+jA8NILYKGS8aV3?=
 =?us-ascii?Q?6iGbdBic4OK44LyX4Kch7dIGAahS0dh75PW3cSUbBMoKh6DW+b3aYByNE2rC?=
 =?us-ascii?Q?tBaypbOb0NeJTOebL0PLXRjz8t9Hv/4EFga6HnXZ3hsXvdP2AlhgUT1qOGZs?=
 =?us-ascii?Q?wFMf4G+cwE7E8DCzr5MRBP3oI8sxNjlKbrNgPLuYjYdKMU30o2qaBEnV8J39?=
 =?us-ascii?Q?YAsxnrm04JTsuAelDerHN721X1Y3RifS3Dsib++8LVWxNJUnJFSGcFsuTDvp?=
 =?us-ascii?Q?8iJCSrzPhmdcSc90IwEn6Xazk2pQALgRQhkbW9DHfUmYRqSj8Nj6bn53Gf+c?=
 =?us-ascii?Q?XpvTus+Wbudf1HCdlWiBXPZePP9/7hCF30fQSlM95sakVSGRZoQf2kQh6JvX?=
 =?us-ascii?Q?DhZBabcpCH3AHFHN+STb1wHlM2QF7gCo/142YwDD//lLeEnGNt0W/NbVBJNT?=
 =?us-ascii?Q?6yDc6B/D2oLpjCQxS0n/pWkg2RQuXz8C1bgO2n0XUtpoNINy/JHh2ILgVgfN?=
 =?us-ascii?Q?1qTb6Rf2VeEwUP4jr1DsnPbhcah/rl7Akc4Pwbs0kZT8Tz4F4Gm8ulqppx6c?=
 =?us-ascii?Q?LuRzhzAewAPf5fjOAtrTdpLNCBnzF6adbo0u7F6ty4Y5kJ91eZWINXyfBa7q?=
 =?us-ascii?Q?Rl1Kn6k2gtynnBkyG6LaqLrORREqVyCk9SCxnbKtuM3O/Dg7MOwtCsY4DbKr?=
 =?us-ascii?Q?xkcSe6kkjaRys6EBKE1Rk6gTjUgosPNC4KzcQQUKR6tOtOY1g+Fufg+Plq4O?=
 =?us-ascii?Q?bVXpBTIrmPyH7r4bx7mECyKpVuq/60OgZF61/LgIJ/kAYNA4SLXXM8Ad2uEN?=
 =?us-ascii?Q?3n0C3QXp4e3Xmi3Oqwzlih8oCZ52Qtf39e/qk/oL73m8bZW+7rjdiCMBXiAs?=
 =?us-ascii?Q?o2Jb5M9v/v59ITXYADxCCZaYa6k3T3Lcztfpoh4EEK+ocrwZ82kfr/at+ozb?=
 =?us-ascii?Q?YjavFX4EMeoZ52crGmKZFpHRB2BwEIx00OCvbH31iRY2QJVxAifdl55C1+2g?=
 =?us-ascii?Q?AlOPaX//Pt7IvDehQEPD/5AOc6EOVAia3Z3PTYUovYq9mI31O3Cjja8Be/ra?=
 =?us-ascii?Q?rxKWoMOxVNRAgOJAeX7G395McRm4QZ6+KVB4qYCB0om6xpVLdPsSw57CBDnG?=
 =?us-ascii?Q?qZyZ7qhO0saXp+46ojeJBY1W94xPnhWQaIIyuPfdh4bNDXDhIWChVGqY6vj8?=
 =?us-ascii?Q?IoT/s6//HdWZHikH1Howje69rZI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051e86dd-5196-48b8-fd0b-08d9add78c1b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 16:45:53.1713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3ZDTmhK3FlSBwvRGsoER/Vz03RpL7XnpK0eVxo75C1vqeVItBJdkI3+mv7wbMMVs8Qx+k8LhkB8T1wVSbQUmv/PIlMBZnnPe9AHQmpWer4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2350
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:19:02PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 19, 2021 at 02:43:10PM -0800, Colin Foster wrote:
> > Add an interface so that non-mmio regmaps can be used
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> What is your plan with treating the vsc7514 spi chip as a multi function
> device, of which the DSA driver would probe only on the Ethernet switch
> portion of it? Would this patch still be needed in its current form?

I don't have this fully mapped out, so I'm not positive. I think it
would be needed though. Felix and Ocelot need regmaps and will need to
get them from somewhere. The VSC7512 switch driver will need to provide
the regmap directly (current form) or indirectly (by requesting it from
the MFD parent).

I'll be looking more into MFD devices as well. The madera driver seems
like one I'd use to model the VSC751X MFD after - just from a brief look
around the drivers/mfd directory.
