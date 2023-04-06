Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F8C6D964F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbjDFLvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbjDFLul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:50:41 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2080.outbound.protection.outlook.com [40.107.14.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF15113E2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2B5Wzj23gnt3K+7BLY0j/5lnIyYf+cofY+Dv9J0JndKR8vcR1EOuawFq1Q3SAw02ZKuzxK/s2VaIUlZAOtRTmEAqiw3ZuiZAVtWBEKi/isc5zIR/uqVKBy9sUFTYKVt70q/ZST2bm8BDXiVduhg5lFSo2EA35oelFTQlU0Bgr4cGl5YRaq9bljYEV55ZEhduO8XjeSpOL5a2d1OllT9vQ6Hug89FVr8Cy00xlALhQk+nWbepWMkuTvTAT9f5POIjHVwctHP/hBWo74iuepcXf7DmZveR6OdL7gKIw0LsB1o+cazD8d7st55I8YCInDyWL4iBYwyJBDnlDdDDyXYuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYVY+HogQGg+W0DTd6mOBNzaiYO0NDyh0N8ZZfH+UvI=;
 b=Ll1H+wU3kZpPwTmO25NcApWWcFi/0vA0P1R/OtWiL9DqyrHaW4xWJS8+fMr1dogl7kOPimZK3qElCF+NYmze7kOMtkLiUZWkR0CLpLfcYxeSuZu2FU20R3nkNXMJztFltLc8pPP6wHC1zC6H5JrOFoTXPgDlBZaSeXoDSSU7a/iaWSCSNvgGDEA1hNa2zy5E3yivNFywvG921ZRaf3cuB9+fjusXwzcpbGadYkLtvYfPj+TuLu1aQh++ZuvzNL7V9s5WPSz2Gswg0M2ZA1kLXx88CjFxTq8V4oBYRGL4nXUhuwKRN01dRXyi5xhVFdi1eD5XUlS2pAnP8yjg5azTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYVY+HogQGg+W0DTd6mOBNzaiYO0NDyh0N8ZZfH+UvI=;
 b=bnGzXMEruHuagyIU8yIITajJv2O4IpwLg2DKDKyS6N248475+Mc0/X62mZMU6ZJzAxhktxUi1WL6baD1VAq54TYvRMlmF+UAg52t3sHWVJbkrrQsLqVLPJ/qxdiMAVnPyBOStq2iTCmZdo7oueiC/SWh6dGlNvLvpt+kEVJf3W8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by PAXPR04MB8375.eurprd04.prod.outlook.com (2603:10a6:102:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 11:45:14 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 11:45:13 +0000
Date:   Thu, 6 Apr 2023 14:45:04 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230406114504.5d6sgg653hw5an7f@skbuf>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
 <20230405200705.565jqcen5wd3zo4a@skbuf>
 <20230405200852.k7cfnjv442mxoscm@skbuf>
 <ZC5vn9lNyUgWwlaR@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC5vn9lNyUgWwlaR@corigine.com>
X-ClientProxiedBy: FR2P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::7) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|PAXPR04MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d651656-703e-4a32-6e9e-08db3694626e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLmpTXeYYAgnYUXa3Pnaa/dyKFqEMMnQp0rrAgihOB3mu7yl44GAnsd2n0ob0f5ByuL0GvCEk1k+hftPtIT/TyC545Ob5oZheyIYKrZ5r4LQtFYLJ+w4PRR0NT5oE00wUgUa89mHyZ5eC8WtD7mDbVRPfr4IHRLpm3c3x7doCO61EfVztePrJZZ/UGnSku10KEg1YATFz/xk9u0QwsrVN+hn8iim80YY5RFAUjHC6f9C/xSsaz9gItNdHJJAGYYbZbpSvSwt9u5/qoITqsndJJcLCyRUwFF2PN/N7xU0dbGCys5JeENdfic8qu95iDEmA6yBoG7TgC6Cd9Ofwq6Lw6ZQUkVcyejqZO8Q1RJDucpitlE2+i/F78I1gYd+sHwJ+dcKl03rDmNB2NytO6bMlcsKbPaMiiywydcftyGO7s3aqbT+XiFdzkeDMurp1Y0WutCwaPfsHcpZyHGDcgzR4ECspPPNXv/OtF8sbiODAb7Btkfm74//XefLoEkuuJ7o2qJrU6D2qMomOGkK8sJwoXMb2rzph8MUs4EeyxBzBCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(478600001)(6666004)(6486002)(186003)(316002)(54906003)(1076003)(6512007)(9686003)(6506007)(26005)(966005)(44832011)(2906002)(4744005)(41300700001)(33716001)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(4326008)(6916009)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9LI0siolkqP9IKsGYX1GcXmeC/4DwR83TBC9heXmu0SQKWfQTlLN3/4DzH/w?=
 =?us-ascii?Q?R8QECfsqdLhjCuWLgOO83lQN+Z5FUZs49pyqWTBJokEfOwDtsNl3eyvxIHOg?=
 =?us-ascii?Q?1yazAE2bVzkziprv3B71vNgyub92FKYt4UCydkO0ShOMHGTPeB4dZaKyN7lY?=
 =?us-ascii?Q?P1PYHWqOgBZRWThLLsFQMZD6AsgEMBfkpu95vHOdyX0jG2dMXaXHJm5rD8dF?=
 =?us-ascii?Q?BipPU/HJ5dLPMxBHrgCcJMZeJKCIthM2p4Co81jfQq5/OQ7gXkOxIiccHTZA?=
 =?us-ascii?Q?IOcZCRugpPOlYlR86TVsa5BRfiiNsAqtyiAuk3JGrNzFa9bU7bPaCrRxZUFB?=
 =?us-ascii?Q?5cbJ5BKqwPHsu7NoxVXJGyxSCaxSc0H8QD/tXrUfpyo1VFM8jMxTNHP+lm6k?=
 =?us-ascii?Q?M1cARdrjUqADRCGShs+jzXAD2pg4FLaOIN25wZ2r9cqtN5aMBJlbt00EDrso?=
 =?us-ascii?Q?sRbtdRrfQElUwzl47sLIHiOdFjVWqVO5L9QGwXnF/u+VbRjPSZZIweRXC+61?=
 =?us-ascii?Q?CzaFF38wff2IjAmqlqYtUBJTkKqTmE2ZVeJq+rx/U9qPqnrfhXEOOAPe4zwh?=
 =?us-ascii?Q?/JXKNhx3UELK+p3GgcOlVKUVv5Iczu2+4mgv+3tOmGGGM3m3q1P09IiXKjTG?=
 =?us-ascii?Q?qmJDIOYQefmbahPkCJUoFSd1EhWNtWNai+PDCdDN1BVlwWjI72PGHa01BgMx?=
 =?us-ascii?Q?NIwN9RlRJPN+uR9QWE56SAq74r2yWh/RM3tkFz2yEFKVnvF+TCSVIxnvaV6k?=
 =?us-ascii?Q?dyO0LvLL0KEDmCOAGkM50shTXKsDxYPS8KgguUJlgHPge6rBeYcA4asr+e34?=
 =?us-ascii?Q?TmnFT36NFsZu1Hsxbu822ejCMvTUwFUyJ3q8K3gG8wGSItqmPunFt1b1g4Wc?=
 =?us-ascii?Q?VLqtcQRB1MxXBxVF0ZjlQrKLBmhp4njLOm7idJr/qaXjefe39P6FjLOqauHH?=
 =?us-ascii?Q?+S8ezmAbxuw4BVwwvcslaco8e1eZ2TcWGnPawbR3u+WjHC73W7zxHFkEkTpe?=
 =?us-ascii?Q?hmSpzwofwLkpNIjsFaTFIKFC5AwG9OgUtBVMuzmFsUEh7prX5dM7LGdFB+ZV?=
 =?us-ascii?Q?sc9k9B8qytjTn4FlK/pcEkifiYXqCA+EzRHBYcPqBIHOU4josSb1rpOFYIkO?=
 =?us-ascii?Q?ZFiCguSeecEFPnNIlbU3pV/fZJv/1ngz4SCFcdXxNwMWqubL7oM54rJMm+Fc?=
 =?us-ascii?Q?nL9n3/jVnHNe+dUt2NVFPlj+GfFrsGojvI7lpSZWctlGfitvJEH7eFcDJhz1?=
 =?us-ascii?Q?IiQigqDrOxZ9o4sgnRUDbQpRLTbI0n6AFrNS6JT08VuSRvanQtYuluwOOB54?=
 =?us-ascii?Q?twqLeY7SOhceyNjcLspLgc8utJ8k6y6YNF+ibhBugzWADz1ZD2s8LNXi25K7?=
 =?us-ascii?Q?tz5U4/AS9rzxEJl48bbK7XOlJRznF+t3Sed7A6HfU0eU/GjbaJ5Lz/W+7UJX?=
 =?us-ascii?Q?pwzu7MnWrXdntWJ0P5XrXyddFBHLs3FXITa6Ub+frXE6bxHI27FSrj3q3EEz?=
 =?us-ascii?Q?ksq0EvpcrRgqtSTT0G5CqpR/dEdk7nC8z2QOvhdFx1nq9Lp8SWeA7TVM8vIB?=
 =?us-ascii?Q?bkuHJMWXTTG+sf/TBMdPJi8APu4T0hzJG7tiiWtmETdXiKFh2ay6ELQgNni1?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d651656-703e-4a32-6e9e-08db3694626e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 11:45:13.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpM1Wk9vi6+xfSxARFj03U9rdBum5CNotE3xqxhX3KEARqE6ImguBbn22FqZqfn85EtdMbrCMv8irtxEtkhW0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8375
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 09:07:11AM +0200, Simon Horman wrote:
> On Wed, Apr 05, 2023 at 11:08:52PM +0300, Vladimir Oltean wrote:
> > On Wed, Apr 05, 2023 at 11:07:05PM +0300, Vladimir Oltean wrote:
> > > On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> > > > nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.
> > > > nit: clang-16 tell me that extack is now unused in this function.
> > > 
> > > Thanks, all good points. Thank clang-16 on my behalf!
> > 
> > Perhaps I shouldn't have left it there. I'll start looking into setting
> > up a toolchain with that for my own builds.
> 
> I did this a few weeks back using the toolchain at the link below.
> It was quite a simple process. And well worth the effort.
> 
> https://mirrors.edge.kernel.org/pub/tools/llvm/

Thanks, I did set this up yesterday, using Documentation/kbuild/llvm.rst
as a guide.
