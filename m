Return-Path: <netdev+bounces-6107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EF9714D59
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FEAC280E3C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016578F5F;
	Mon, 29 May 2023 15:47:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A378F52
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:47:42 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2088.outbound.protection.outlook.com [40.107.6.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB295D9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:47:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kC2XrcG5qSnweixLqwm04Vnz1rB2E5wrZt/lRFIWU9yNYVj37rXnU6yHCIbrVDPtJ/ujPc/Fe9hlFZCCnCrKHg2YTHnnpv5gOCpWq+xVjEmynSEmpzDdzRubHIsodVTMcsZ3a29IDeJsWKcL2vUEFFQzO5h2DG1V1xqBxE8o5mmd6wM+q9paog2I87oWp40kYPjm8Yg8OZ04rtIgGUOgqU4y5piDNOP04w5+RvbIaLopC3B/kya9ImgVliYWI2+YLl3o3RxVy+4BXcMjsX5zFZLsVKZKJNBOdlFmkW0gwqSQmxw2EcLj5m7QLI5RbRUOa1NjiKAEjgKjZTDSohKgJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63Qyc9h6DFvV3IGBseAgXM/1KEqiWtb0mFucyc9Wal0=;
 b=aqPdUPp0ntLXBv1mjbuzlSGoSuI28G3z+inSRAzQ23DCRQB9vRd1mWiI0+CNKfzN4f+pWrabJTHzAh0qJydhiYTT/TMfX9j7jXOzqc1d3XmhbV/LQBX4y+wJPiuAIuxKOGxnJ6Nox1HbvS6tpcBxI3/caX3+F9fk6meFLAzRaB/IrX5SsFAqxuJpuL1eaV75NxeJB3FwqSnA8b4hU/p7OYgYTOCsmWIE48RPXwcA84pRtX37hAl+4oKPh9r8O4CD/QR+PSnnyJO5/uUeWjSbjlnW8NtU2kz+zBhwTJ1fULk1ifsED1My5i1ELP2ZAvT6gp86b8XW97acJTOA7ByRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63Qyc9h6DFvV3IGBseAgXM/1KEqiWtb0mFucyc9Wal0=;
 b=R6soTV6bqfGM3vuIRvf4O4UW8GpPgjbjU/LQ7rMov7LNKqxk3J+xrU7V2evF0de+vvl4JtnPQO1R7DRCSFkRexAWYCAqrX9q6N/KRclEPfEdt0fUjBCl2sI0/N3F5qtIKRXsLQdLYd/KbKel7Lj206sZJ7iRKpQd8vjrsALyhl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9255.eurprd04.prod.outlook.com (2603:10a6:102:2bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Mon, 29 May
 2023 15:47:37 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 15:47:37 +0000
Date: Mon, 29 May 2023 18:47:33 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: dsa: ocelot: use
 lynx_pcs_create_mdiodev()
Message-ID: <20230529154733.3ya5qloxchv5kuwl@skbuf>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2UT6-008PAm-UO@rmk-PC.armlinux.org.uk>
 <E1q2UT6-008PAm-UO@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2UT6-008PAm-UO@rmk-PC.armlinux.org.uk>
 <E1q2UT6-008PAm-UO@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: VI1PR07CA0174.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9255:EE_
X-MS-Office365-Filtering-Correlation-Id: 842566ed-f0a0-4b37-fe6c-08db605c070a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	h/LC8NnKyIWlJOvA7jgLoqvKvZdyzC/TFFaixxqTcjeaB9v3qO4xTIqdG80LWNQf85nMbAt0vFKlPwGlq5HRtOFnlO+YSKfyx3ELk1vuBbBtKEb/o6MSJfnG3tDbPURfRBNC6u8B0HF+NjtTaSkfbRzBt3E0Fc9CTm+NCcTN5PUk3kvqilYXxdPWu56s16ZuklZj01nEaepUozyGzbUBGoZtno8cEB90YCzXosuK+G3G4eBkgSFdu0tjjhZrzIjtYNTN/b4/2zw/xdJ3hCT7uPqPZP3dzq6yRqHRFuni+Mv16uBMr/Oabb2dj4zQ1A2slqFD/OXpkCU71UlDaGvGtKxhtcHM+s8Rll6YNOFWsgDV7ejJvc+sdUj1eIWxAsV+RrmntWIuSiKFFmMcufFo4zR8LByIYA3pvP6MaSDF8HS5kAS1WFAQIhLijyN7ZUkNiEAM6ckJshy5TcqXfrCdlNb9sF4EoJVOVcNWWFIUreiI0wrJwmCqPVjPePn+AhnFa81TcjVzm5SPri2IgXUk7iK3qE97ruwZIB7MH4MO6WUJUON6CYvicmRjWY795sFs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(86362001)(5660300002)(66946007)(6666004)(316002)(66556008)(66476007)(7416002)(4326008)(33716001)(41300700001)(6486002)(8676002)(38100700002)(8936002)(54906003)(2906002)(4744005)(6512007)(6506007)(9686003)(186003)(44832011)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Px+Jzh7CK0Yrp7JjsO1X2Ac8fIOLWrt9FmSQMYHYRsPmNI/5A/81J8OPo3Ry?=
 =?us-ascii?Q?NIxrjn7gb/MQobyXgJD7w0b7YM3/e6MAGEO/sHY3sLkCupdikJsL/pqn6M5e?=
 =?us-ascii?Q?F9SCC0vya1w0be7r60x4VOOgTsVuKdP4RRC7iT10OauwUwSD3NkAm40Dc2Mp?=
 =?us-ascii?Q?+ki/Ot6cI4VfhXCsd48jMaQLKIDCef3p2EaIXvtPCk++1cBo31dy8wKQlLJD?=
 =?us-ascii?Q?TMgNO7WzI5WM+SMI4TMt5zEa2vsntKyYuWJu5bWKSJSA0Mc2Krb6SxXGaX3H?=
 =?us-ascii?Q?XynR166STuOoobu/VXt2HoAPgqMNWAr9Q1XFO/D/0wMH/30ehBu6IedUYOA9?=
 =?us-ascii?Q?UdHLXEp/QMgKaA/SpQpJo1UvwvIUxCWTZe6m7KjZZY3qWVxyN5NIP6LZMJ98?=
 =?us-ascii?Q?hXlgVcjDdmSJ+lPcH8QWqInAIk5+Hof7MyJzEUdpZ04qJ2ceDRp+WCHlO/bH?=
 =?us-ascii?Q?VDHCkLCsGkxJuY1UnRi/z5kX2XvbKrVbLkDQVmejdnK0J2Af7q5yJMFUdU9P?=
 =?us-ascii?Q?u9prjb2FjT0wKbKgOyW9j4jmQUrRA/PbJ7rZV4c/t32AhxAdKBkDfAM3lPOe?=
 =?us-ascii?Q?6DXZLBTbOWEq1tKa0nEluf2xiPjONnr1p8I2Pz6sVEglKmRQkadp3VTjR0rY?=
 =?us-ascii?Q?NaPQy2SvLHu/Swa2/iqh9dSpwurCjcxkyugcaDogW49rkGbGsNP8bRXwahjL?=
 =?us-ascii?Q?COC9JlnwiP8ZQusujcPcK72gv3XfpQzgp8/QU5ZoxlQmI3Ed8W1cFdWA0S0f?=
 =?us-ascii?Q?Ykq5CPLAYcZbSzAmQQ1fzCyaiXzZLO7RZa16wLp9WuxdvvVKiUXhWGAYQzCz?=
 =?us-ascii?Q?RYc5SWmpjsmrAfnEF3hj3rZ9VVJTNlPETZO1znKgjb1vi9XubRGmLWfx9HfW?=
 =?us-ascii?Q?6h1IjABcDZwfopmP+nqTuHCC7otmiVrqabV3HTlJQfD2XV4cHiQ613EPh/6D?=
 =?us-ascii?Q?u20NWvJwmHGIdxaAOeqrX9v1qpFthYiBkaa81gb4dWJx4s8/NCVh2tziHiw2?=
 =?us-ascii?Q?aUtjNS8N3nJ3CPIhmMxAl4iGlDVE4wMEvef9xMtgm1Ue5H7hs1pXlRWZQkTs?=
 =?us-ascii?Q?avhCCuTIm45cLTB6weY3WEYTCw+ZYwO35qVjJiIwLe56I/y/yLgDuGmJe5+8?=
 =?us-ascii?Q?aqLJPVUWNMV4Q7thNUbe+BODekpaqR0YoyUgGfY7Orh3vRAeKxeRbKHl1uO9?=
 =?us-ascii?Q?QE+cg4CFHPZCRVaOJErAB2EFN74BPFeAjs8cTnFoG7xjOuAy46p33tmdVoGV?=
 =?us-ascii?Q?cfbqa3xNN6d9SPeFQebLCrhvGt6TfV0zPEq8uHCfKV3CcED3tYRsqVLQxAxL?=
 =?us-ascii?Q?z3cwtp2HtCDVg+a6UPHybsnss4yGv0Ai6kcHwWlaDYnQWFtGmtMsnLPRGRNz?=
 =?us-ascii?Q?zjtUoe8Z0kGhigXi2KMwq02cZPmeJ45QHYyEKjU0LWpngInQo5v9tuKPLuym?=
 =?us-ascii?Q?UCB0DTkmxuT+LO9hcFPYoH37uNKo8xOORMRsNG/UPnt8dh7cy2J+PVOnGpmn?=
 =?us-ascii?Q?uF+IwWoHfoFyrvDbAg21Wu0+7VnLJKPjIDwUbghZGMJ0KPk0pvd3HAeNEqL4?=
 =?us-ascii?Q?Uu1q23nmcjjC7JH0WVgYMCAipv+WBJo7ux9ownosf8S1A1Nz1OnCz/uEXgs5?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842566ed-f0a0-4b37-fe6c-08db605c070a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 15:47:37.5837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCgPDVQM39vBoSDtZdYkKLTk3S4eqzWhW1oMkzt3BeCBax3uzFS0IUG+B0K3n3N7zXq/RM5LP0P1v0CXEjjeuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9255
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:14:44AM +0100, Russell King (Oracle) wrote:
> Use the newly introduced lynx_pcs_create_mdiodev() which simplifies the
> creation and destruction of the lynx PCS.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

