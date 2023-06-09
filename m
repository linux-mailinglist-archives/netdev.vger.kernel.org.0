Return-Path: <netdev+bounces-9656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C94B72A221
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AFB51C20A8C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C6F2106F;
	Fri,  9 Jun 2023 18:26:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8E20991
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:26:07 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2091.outbound.protection.outlook.com [40.107.102.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4622D35B7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:26:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qvv69MtDPBcW4bMVw25A/1R9y1RSauB3rdGJL5XJENIeSVuqXoyhqWthv5Fos2qLkhk8I6jUpg2+Ztrsi6qKGYQ5tXLr67cv6rRn38qPCiJFW7LTsV1vot/LrS1j2++zRyDbmz/luYdLp+dpdIhDxjLZU/RqCzE0H3dVrjTq70qMAR9BrEqEj4bO0sLCJgBxexJX4VA8wbqJo7+MsbEJXKh1fZ0WscfniB5gnVLpfQ8bLHvjcYnk2GU/Sjbgj10qdBPZaEVmqWycZyFuZ3HLcOv4ZLGbVnTKqoeZqVjDpuSD0nXmNWPiveQBz+eeqnns/WSqdnoi4Yi3DsGDP6yblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+d/ASo/qzZxzTbtKQY95yRBdSnJDBd5ebapTsNyfoM=;
 b=DNY6MkhnlFEKsyNYRFiU1T5Q9IU3eiHeIk337cyYTPD2Ave+zKgHhpbWBPyA2VQUx7+mRJyaNGZaP225EIDysUEIBixC3LkPGhoIdOSowc/u2ee0xhMUEUHwmWBkH6O9lL02/GEUr6iguV3dlQ3ZvFzbkcx85CiC4KVlXr/yF67XOPOoU2IjB9p14Dn1MUWGSjGfFwQGPIou17vuhQ9hqQeqCUET3HBs0Xn3yiLyO62D6h8vBjb3gqHIfBMxCRhIVaJD9uoIZ4YRO5pKrkowaCV1Ugy2zh8ets0Fee8+yncU5r3Ik1RnM67oPk4aw3m6jDha4QlYQfG3kUhkpdefyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+d/ASo/qzZxzTbtKQY95yRBdSnJDBd5ebapTsNyfoM=;
 b=E3X+jjWEsYv/d0jww/KwGg8Ux7gJVghWrvBUPralEDA0W2h5j1fJ1C03Bmsk14B1uiexpDgQEv6Z+fjScQ5XiJmetnWXgy+U3bbiOWXRhLNTwEVOVSoT1tz1UYZD/c2tG433xO7whgMJS0uamKaSOD6c2FBW/8MHFgytFhjzDKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5417.namprd13.prod.outlook.com (2603:10b6:806:230::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 18:25:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 18:25:57 +0000
Date: Fri, 9 Jun 2023 20:25:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 3/4] net: mvneta: convert to phylink EEE
 implementation
Message-ID: <ZINurNycA5yacMvq@corigine.com>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9W-00DI8m-Jo@rmk-PC.armlinux.org.uk>
 <ZIMw4XoCg/4biVN9@corigine.com>
 <ZIM3wP3TjvigZP6r@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIM3wP3TjvigZP6r@shell.armlinux.org.uk>
X-ClientProxiedBy: AS4P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b148cce-1a01-401f-7e4b-08db6916f760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2lYQqRSlXqq9o/fuVs2wfxKETSFik2YdyEOCkk3vd/sCeVci06mwia0HIPw2n4VRXQYJ4Jja2QDSE3ljt1scwKnlRv7Bw8KG7rIf1gd5q2axOxMK2K3Thy6fyQgVSdI5gJoZL8qPHmaPv7vbTGfqtgpclBL49+U46ZScFw4X3XSvXuj22rmxO0vE9bfwzvK56bo063Jhkqw1ga6NW5wdjGntK38txw+KngHCeCP9yRBnzuGeFtwjJ22/Gtddfp6BFg82x4jQVKX85nOuK0m3tUv3oEsfvyoin741qK8zO0HwzvAt1f7T+qPp5enVENhwdShVVYZF7Pyh95msAFpOErHVOFr4xnA9RFpSU5StGkK1EJbxK5Lajjv+sKz6jFOzzKqnNkWghKYgx1vx/I4uIn/+RNX10UonjCCJbWucpVyRnfoTF6kvi/ubdsUN0lhoDWQgiqKVgUWfapLQobY9+ySab5JmGfwUaL2b937GxnXN2VzyHo71LyxYxY7A91GnxsyGjNjcZUgP3DvLBzj1HcQL/6iyVZLMSpIQ738++t9+4r2zZh1ILX4bKxxR3J6M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(136003)(376002)(396003)(451199021)(66476007)(4326008)(6916009)(66946007)(66556008)(5660300002)(7416002)(54906003)(41300700001)(8936002)(8676002)(36756003)(44832011)(316002)(478600001)(2906002)(6666004)(38100700002)(6486002)(86362001)(186003)(6506007)(6512007)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n1YoaCHwAm7vxK7hWs54BrTtd0zH3f/jf63Mg/hdA/YBDjS2+TKlJ5qGA+6K?=
 =?us-ascii?Q?+GbUgnuWUNJHvmul+kISkK/D88yJrHr7Jkerl8MCsyXeDwEj5fe0KIJdjjpa?=
 =?us-ascii?Q?3Xb76iJMC2aJpuSBpMbemp7BKw6QfGGEsc4RaQXTzXSqwucEEzB00q596Hlw?=
 =?us-ascii?Q?PmoPXP+Yt3kANZZR486tx4qYJV6Lo1UFdP9MtxGJlmxnGT3VcvY7ZnRJLLyK?=
 =?us-ascii?Q?+0kVLxAx2ZyM+UpdrZpfx3VkosfetxjJeLc6bd+ftr3+Qh/pTAQve9t06NVj?=
 =?us-ascii?Q?t7Caxa9I6nHSbsT+nRk7xzdnaWVy2pMdaj/E4VxYOiikAPEHGRh175AQ3npy?=
 =?us-ascii?Q?GOBnefIT2DFq0+B1Ab5/2I1YqRnMMswZpx8hrPeLlmstnfb3met4SZtZrh/C?=
 =?us-ascii?Q?QkQ6YYWHXHt9PCPor98qmnN/oLXm1AOxExN1eBkiXSdZLuS7UbbzsO18HKG3?=
 =?us-ascii?Q?juCRCY/70x65z5dy61YQ/N6nep6yZS1UNc6XP7f+xhF0pjxMC1kH3YyBzg53?=
 =?us-ascii?Q?kRR0WqjPVJx4iPW+S+efVjo1EgIppdcq3A3pp9zARNNWWkMk+phfIB/oguW+?=
 =?us-ascii?Q?yK0RBLOtKv3iPMYcHt9OxGuLqFGOHzU2TzoWjiaYC4yUutdgja1nfEhDhX6v?=
 =?us-ascii?Q?iPsjM0UTlDSjVDt2o3CVgpvsQ9zdS1IwFNesINcCWDdtoLX5X8K8KfXLY79c?=
 =?us-ascii?Q?Pb8S+n/ARXueHYZAqftpqffbDKrtz8XE84oILrg36AQGG0llesTYi5OFnY82?=
 =?us-ascii?Q?GL/lxjBv/4O0FgGDmKExe1x4U6ZiJ68jL4l9O3B6FONPoWXniJvNfFtPubTx?=
 =?us-ascii?Q?h0IR0zlY6w8S+Ipyg/93kW9U95gM9CXeK4D+woACdm747sGv0U8ZdfAW7evf?=
 =?us-ascii?Q?jEWxmroRj1PRvaCEEcGbW8bDuuFSOeMaaiLMjekb/KdWgcYBEs6noEhKzaa6?=
 =?us-ascii?Q?+SBaXR2S2qimMhWg6iy1ZJJqFp4icWRpkN9/Yfzholg0m59oGK4h7ac78qzn?=
 =?us-ascii?Q?A5l+ukp/CZWmbHV7St/4C5lVKKrLHL5qYW1oyrUda0qiDjpGk5MOEiABjzMU?=
 =?us-ascii?Q?r1q9iNVa7RPnvzhGnvHrb0W9uHQCiwuBjtkKeZvhxB+xVz34UvU2j0BeQ8Ju?=
 =?us-ascii?Q?IBYmQQKgj+mZyT9XIOunoX6R+K94zsVvOiOOgjRIiOCSnVxweUp+YSCVcEJC?=
 =?us-ascii?Q?wlIqVgJ5r+1tov8Nk2wetXPsV2+BIbOPpP9S/KnPNsAw47TBkgO2tfYAYpD0?=
 =?us-ascii?Q?Sn1Czu/+PGiCuV2j43WsrMeZ5XnjA2EHrzWcsTbzwSbJj9qGb1voK8eFaZqV?=
 =?us-ascii?Q?qozCCfiMZeQV56Fa2qG6E01mr7xL9qCZ3XdMh1HClMguf1a0key8ox8ZmoU8?=
 =?us-ascii?Q?nD+rAl3SlYG0PPAYqdQJ6eokL+dR/E0hRLtnLbK7zUthDk5gYlLN2VqOiMrg?=
 =?us-ascii?Q?ZmcG4CeeCLTdA4cJcqCJL+z3D6WK+ExIftpos3GPU9HHBfmf4vH3zZ0Ane3I?=
 =?us-ascii?Q?xlDItj+XIp2VtXlc0IKipiST+9Gx3RQIaIC2fXDzkAQXjHWxL4l/gfNDJmfF?=
 =?us-ascii?Q?fxTisVuW3sgvrf1UoNowkT/aJL4WuDqFr5naHV3ltNfceWay2jzTAglx2GQB?=
 =?us-ascii?Q?+7gkdffSDA5IU7Yea9FAXUZKSoHwTbYRAWLVsXt50ohYCEkKfQQWnucNY+Uc?=
 =?us-ascii?Q?GL1a1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b148cce-1a01-401f-7e4b-08db6916f760
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 18:25:57.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kk7sgASY31qpqF8bq/IuOPrHeAZQl5jTzP1ilEjg9qpTR5tpJ8IOaJXGv+SnHdKupU6Kf5JuTtoXk8qPNGOdD/NqpPLvZZIe7zZc9Q2/DpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5417
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 03:31:28PM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 09, 2023 at 04:02:09PM +0200, Simon Horman wrote:
> > On Fri, Jun 09, 2023 at 10:11:26AM +0100, Russell King (Oracle) wrote:
> > > Convert mvneta to use phylink's EEE implementation, which means we just
> > > need to implement the two methods for LPI control, and adding the
> > > initial configuration.
> > > 
> > > Disabling LPI requires clearing a single bit. Enabling LPI needs a full
> > > configuration of several values, as the timer values are dependent on
> > > the MAC operating speed.
> > > 
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/ethernet/marvell/mvneta.c | 95 +++++++++++++++++----------
> > >  1 file changed, 61 insertions(+), 34 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > index e2abc00d0472..c634ec5d3f9a 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -284,8 +284,10 @@
> > >  					  MVNETA_TXQ_BUCKET_REFILL_PERIOD))
> > >  
> > >  #define MVNETA_LPI_CTRL_0                        0x2cc0
> > > +#define      MVNETA_LPI_CTRL_0_TS                0xff << 8
> > 
> > Hi Russell,
> > 
> > maybe GENMASK would be useful here. If not, perhaps (0xffUL << 8)
> 
> Why "unsigned long" when the variable we use it with is u32, which is
> defined as "unsigned int" ?

Fair point. What I actually wanted to ask is if the logic
that uses this works without parentheses. Probably I'm missing
something obvious and it does. But it looked odd to me.

