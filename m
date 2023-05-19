Return-Path: <netdev+bounces-3910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C3A709831
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058A4281B31
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40959DDB6;
	Fri, 19 May 2023 13:28:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E33A7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:28:11 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2089.outbound.protection.outlook.com [40.107.13.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B139C2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:28:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gt05xTZrmKF/vp1XDwFlbNAzLLqY+spnn2lmdY73bRO04s4OuUpc3aOFWoi7G51ReOW2Olo/7bYH/KHpaS75hdeCaZipGAl4JiYeHamUCUipRB/cuh21gjok8fRgDI9qZ+A4FizBjBXdD0BONKr2XJoxty7wkCiGv1CSwJGtToGgUGYsNuV0jV8y2afTlYscA79T5rkTXdKcWsug/g/mjD3evoliA6MjRFaej8PUGFpExTeic9cS/oLm+XHEl/aoCM6nIQhAaEzNudt0qY8ptVSF6Dp6WAy2lDKRGDHLLl+K9n6z4wL0SeY/9x59APyRNghwNhoNyXJ/N9YDS6rdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=copsMgx9ZzXOpBWgCk4qgmJFuEOqy8XXi2ZlKGpSRCM=;
 b=h+mrU/DIyB39z1kurUvGRF7lNcig2l4woVfPQ9HviE+d2b202za4ysMdR4j2hJgFuTJPoX7kS8+lRapzDDWlKbnJiGHuO96ixvPbK4yTdQ/Z0X753VN71ICtGqC5efDUOejlxunTyI8J+6RxRu91Ni3twwGVSa1xyndPnfCmo3rVAvg7JWOxN7/9lkdeSF6ub6t4Do/FG9Tk+6+SIbuRS0t/RxpbVOIumYo9ow4+zI7Jt5+LN30huawRqDbwqS9xLKg7EFwidupfxOkt4mPZR+KMfiwltNf+3Q6e8yx6af79iPftZ2XxczNc0jGinTGeGXb1PNYMpp9RhK10vfOYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=copsMgx9ZzXOpBWgCk4qgmJFuEOqy8XXi2ZlKGpSRCM=;
 b=bWZKs/ESreDKAht5h00XpGAzauX/qperUBj/YqiRhJ6lC0VDduGzje1BRxiHDmXy7nKbhMDPnKzgC0vszrZGIh3demtu1tO46Cm4SWYRnSscm9/Y5yKZqS4ObeklcprEPRq0epDI5roOlBTZQ6fjGLd/+lRVO2W5RqC9/vbFyXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU0PR04MB9495.eurprd04.prod.outlook.com (2603:10a6:10:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:28:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:28:06 +0000
Date: Fri, 19 May 2023 16:28:02 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	=?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230519132802.6f2v47zuz7omvazy@skbuf>
References: <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf>
 <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
 <20230511161625.2e3f0161@kernel.org>
 <20230512102911.qnosuqnzwbmlupg6@skbuf>
 <20230512103852.64fd608b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512103852.64fd608b@kernel.org>
X-ClientProxiedBy: AS4P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU0PR04MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: 980c5cce-3b60-4de9-6420-08db586ce152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0rAVybTrHOv5yaTaS+/C1gro35U9ElKibxL8OZkPDiW1Z2Qv09rYH/ePELCaHneKrJSatSgexbxHNGdvjXz6724h9Tmfjk8jkNy7ZkDpR9bYFG8qHcha0WJhrwxeann7kZL6iweVUO/Tgj8bcThvUpAm3N4ewkqdTIKFLTDE8N2G4SpLvMMo6yjPqXUOmqhQS1rezUB6PZpG2aH/HcekbbP8zg4o4P89GVDHX/Nwnv2pR0AHWHR5UaGLZGDXW8zGjndg2iP/qsJAgb0kKkLeWsX57qQP8ZHe3na6+dc+Q2GkzYYO3EF9E9LDmgW+xAelogxdyIe7QttHe+YQmX1ZoA+/C6qAbE3e3RbKC1cmK5xZEBvsLnCCpLVQZwVYnceKsbf7x0qjeXPphQFDOLVzXFfIruqI5hcK8vnAp96EJF5IIapcPrTK0cg4C00E7RmAl766z2qFuR2Wh+qqrbxJL9l/JcuAy7i235YSQeCPrr/CzI2OouwMwunPPHM59W6uLm3ORri3Hu7PJr+TgsInYuL4bUMh1ZPnsDBQU3kWg8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199021)(86362001)(54906003)(316002)(6916009)(66946007)(66556008)(66476007)(966005)(4326008)(478600001)(6486002)(33716001)(8676002)(7416002)(5660300002)(2906002)(6666004)(8936002)(44832011)(38100700002)(41300700001)(186003)(9686003)(26005)(6512007)(1076003)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l6AH8e5e3lM2COkh3mMwM1ReVgkQhNUyx4xzz8l0/6p3In4MCfGcDc++fQzR?=
 =?us-ascii?Q?P45NLvGlp5KpIwTtCeETqpLEQyr739RBXYmPeOwU5JP8EtSuIELZNt4JTRte?=
 =?us-ascii?Q?lx1E2HvB/25LdaHDIPwSltmxLXHeLHzGZv4lyM9YBTax6k965RFnDus652rN?=
 =?us-ascii?Q?kj6BT2DkakHfdR147RG7x58Aa9gVOn2NklFUtxHhhSo1rEQBVR/NgPzVVdQI?=
 =?us-ascii?Q?Jh81gWdkh/PR3E9uxbrfFA5jY1hi5p3D/9OSqKdvbiFsCGH+xDnVhsbWn01y?=
 =?us-ascii?Q?iHgR4n7tTM8uAvHoy+rnOuO2kYymdf2oEEOL+N5ye3lYuHK4OY6LF5fMQDE3?=
 =?us-ascii?Q?yH8Dh2CQWzNnn6K8Z29C0rxQY2giP5W/TqWpOhxp6H1gVIjU5VfuKzwS1k5G?=
 =?us-ascii?Q?1/N6eODvSdckJ8u56k7+V6Je/lfQL6QmtNmCMPAUtUJ4aOxlLu1TZbcCEpeB?=
 =?us-ascii?Q?aWN37g6woASXlWnC/ZWCNkQnZhanh6u1g5j7lGguwAGO7tR9671pmIHLNudj?=
 =?us-ascii?Q?LVA749gGEZiGcdg4D3uts397wsq5HhV2FlyMx7I3jigH1xHWaivWfuB8jKQH?=
 =?us-ascii?Q?20rnXQ79/LTNkGtnMLYbhBFA7GGI2h9ntICu8xylRwIqageY+chQjNC6Bm8r?=
 =?us-ascii?Q?c7G89FlWnNbKkyqe28ZR14Ru3Nxze+4H6vgrTbngE8XtzrZhFYPn3vc9kcK+?=
 =?us-ascii?Q?r/cjoDskk2nvfT7DOqnxJkOGlldMGLrNj1sC/DI77I/gtHgRM13SYVP/ALeT?=
 =?us-ascii?Q?x4LIkqA+5ZMRe5orkM0ZkVZXBHcB1ywymjJdv/O8KCg7Dn1dw12y4qwEj4lW?=
 =?us-ascii?Q?czspCM/Q51H9cyC6WwPzOB1Yhh8bzU/qgyQQTLi7Z9IKSGtFDys1xw7zLhDF?=
 =?us-ascii?Q?vmuNiSATsRZXH80opp6qUcQEc5wtJqia7eySo28yjzTwsVs04OIWVkcHBMgx?=
 =?us-ascii?Q?sTQDpcFyR9wiO4inUEtF2GnON9qeHqKc9YmZjqegRmfeJ1ZZYSol2ohHRGDt?=
 =?us-ascii?Q?LwsK7VIEe0uQtexww7ts+xqoluUeVCDt/of6QGpmRyKm5sST3Kkv33VXA59C?=
 =?us-ascii?Q?60nVMNdn1C8NKHUQwLVEePhGX3YHmKjLljwmvWP7h2OLka5XM84B20VSzBl8?=
 =?us-ascii?Q?8hN/jUWhZ3CZ2s8/mEmZND++83xgtCOssVNm2o2m8v2hcznlAZzSWOiNH8xT?=
 =?us-ascii?Q?FQCUdYCpGESD05JmEJFSUjMs5/oiHCNmmiWJgRA+68MH8j2qQbdaVJe8obEK?=
 =?us-ascii?Q?rffNuxxvD4hP+lfNvVxsOofmNW9qD3ocd5fvyngoo9CXXe17sB0Xt6cOyyz4?=
 =?us-ascii?Q?FoX/89457xur1UcsjtyjQIKTTbM1cIuvnjpoU9iUbP0rUJfpYCX+IJPjSPP5?=
 =?us-ascii?Q?x8fa3Z8apP0vB9Awh8ijG9J74eOF8LHAIDBI7Fcj7Q5mXY5IvYLOzgEtbFLl?=
 =?us-ascii?Q?UkB3XBmpQhtEDDrlENoCGJvGBOR6fgNfF0WA3WdFIkv/7NIE5pY+aVEef255?=
 =?us-ascii?Q?HU1+dFXifP2lSY8OpuPez1XeDbLV7xONdICFyrhBQd+9OLyxHWLc7L/xReGS?=
 =?us-ascii?Q?S1fpsY1j/LoaO218+qLpwRc/8bCJenWcrfpzFMqre5Tqi24eTo6yl1++DE/Q?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980c5cce-3b60-4de9-6420-08db586ce152
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:28:06.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGlshxMUFe37phOJmUqK1kqHMt0DsCcwRFFcN7fAbIS7G6zhdLeMvNHemra+f7+xpkR7vxUCd6djxNbl5YNxfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 10:38:52AM -0700, Jakub Kicinski wrote:
> On Fri, 12 May 2023 13:29:11 +0300 Vladimir Oltean wrote:
> > On Thu, May 11, 2023 at 04:16:25PM -0700, Jakub Kicinski wrote:
> > > > I mean, I can't ignore the fact that there are NICs that can provide
> > > > 2-step TX timestamps at line rate for all packets (not just PTP) for
> > > > line rates exceeding 10G, in band with the descriptor in its TX
> > > > completion queue. I don't want to give any names, just to point out
> > > > that there isn't any inherent limitation in the technology.  
> > > 
> > > Oh, you should tell me, maybe off-list then. 'Cause I don't know any.  
> > 
> > I hope the examples given in private will make you reconsider the
> > validity of my argument about DMA timestamps.
> 
> I may have lost track of what the argument is. There are devices
> which will provide a DMA stamp for Tx and Rx. We need an API that'll
> inform the user about it. 
> 
> To be clear I'm talking about drivers which are already in the tree,
> not opening the door for some shoddy new HW in.

So this is circling back to my original question (with emphasis on the
last part):

| Which drivers provide DMA timestamps, and how do they currently signal
| that they do this? Do they do this for all packets that get timestamped,
| or for "some"?

https://lore.kernel.org/netdev/20230511203646.ihljeknxni77uu5j@skbuf/

If only "some" packets (unpredictable which) get DMA timestamps when
a MAC timestamp isn't available, what UAPI can satisfactorily describe
that? And who would want that?

