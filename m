Return-Path: <netdev+bounces-3931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B33670994A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 314EE281CF4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7530410950;
	Fri, 19 May 2023 14:16:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E4F107A5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:16:12 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2109.outbound.protection.outlook.com [40.107.93.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EDC1B5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQwGlE18eRHwa0Cdz34pkJYeMOH4YuAD/JS/CfIgwhqfp3cMoan/zJKYdJb391NsQyXlx+p6naU10VI7CSS1kPPcsTpxHrL3xg2R8Clw7DHQjHpKbHmRDCCKC4O5WJAtYEqLnr5MfVsoADYpIckyskjXEWYudLeEOnkGSoABhzVNe/tP/qDLMb9Oe5VzjwXh5mvs9/n4NHFEOfpa/tnslODuc8mRHczsbZh9eHdxjIqYo9/m2h8vWEZRraBzTqTRzf+SBccE5uPpzh+5MtGH67RLb3oaplJyiq96Bdj3x11ZaRF+At7/iua3dEJk6dFPojDIVyduNdFUkrtW+9jEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/3qLhcnDpgVie+eLxjuAHBNMDcHYDgujplKC6nU3hE=;
 b=fPa7FasWUEqJhGlz8ysz1av3jhBOYFmgBNq7/S+eee57lrIqJS/pQVjMIcTf+OzkZ83iGcXgW0JJOaKbMQh4f2r1knOAhnftgrf/Qci9wxrHDKVu7O76ADQRshz1aHPBS5wzb9NMETCvKvt+/wpWKcWpTDBQVqg9PNzJ8Chaq1I0F++Xpui5FsxT/3onmlkHOJCEn3s9iQe1xj1H7Zc9D/RUO2WrGL2k8Lm0QRy0qo8tr11PvTEZ1/s6xe0QVWteRxyq2dw+JFsN1v135Vzdbl29WcY6pzc0kUuG9XeMb57h+/krgV+l1gD6w6AWf3LxQ+8/FxTxenCVtTR3kjDrTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/3qLhcnDpgVie+eLxjuAHBNMDcHYDgujplKC6nU3hE=;
 b=JuV7lhQEXUYvR0wNyADUYj8l7a20eqrvykwy60o8um8ZnWSxLXEO4SdYd12PMkQy7Exe98N4+2zFrxQH3dHu+CkBrUH5hcw+EC2+164JGrmiTMQokcHDV+D98B+od+lCrE28kwz1tcLbPRfQMGTk1AmHItKW/uW+dPFIrlrNA+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5839.namprd13.prod.outlook.com (2603:10b6:303:1a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 14:15:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:15:57 +0000
Date: Fri, 19 May 2023 16:15:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: nbd@nbd.name, netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
	taras.chornyi@plvision.eu, saeedm@nvidia.com, leon@kernel.org,
	petrm@nvidia.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
	alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	taspelund@nvidia.com
Subject: Re: [PATCH net-next 3/5] flow_offload: Reject matching on layer 2
 miss
Message-ID: <ZGeElc6Cd9k2URB5@corigine.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-4-idosch@nvidia.com>
 <ZGdebBM8mxGOTovV@corigine.com>
 <ZGeDcp2A7qrKZlLk@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGeDcp2A7qrKZlLk@shredder>
X-ClientProxiedBy: AS4P190CA0050.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: 956362c0-0397-4068-66a1-08db587390b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XF++7uNb2W7hFOGlStuP+14Tflr+LplbPnmjvNhDaSVGcJlzyOgEhRR07ndCqbcRyKmzT6sk+9YnAiM1dfQdi9La745UKhAuXQmNq14FX4oMDzD7Zqh0e8iWZt9y80Dw5NELN5LXM2J1xnk6FsVUJXp9v3ZcGTh0qlAMSwtaGsGGH9o6eZjuUSqUn3yQ8VbhgYg0EftYqQveKmZJ1yuM/hdwDrgQwAkSAnJzU15RR6mD+0alvmz78yczoMWy/g2He8X7lu0F8AWz8MHhG7qe3XSJgqUQP5h0gjUr/chjjSjIssZSXuCZDbfPF61VElQdsfsUFDQP7ftop8IjDWlicbITdQo3fKC5QVFUisvC7mEiiMaKH0oZpjC8r3JvL/99Vz5KgrbzSp1kSozP9zIBw3EKI4a5NZyP2M3cYnbAfGWqMhijXJgrsHQU7RWwYNgQsRmig8OdEQX9/n5/rfNwXqQHHuSXI344Sizhqoh6arIigINmToJVlbo1vWLE4oAIM++KS6gAa6HFfntBwTsoOqA4m1XZevf0pCZ64dp9I4Odl3/8PlOliGbmGlt3UASL6a+3IfPBUZ/MRovlfUzVCndAoutpvTPQGVOp37nG2Dc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(366004)(376002)(136003)(396003)(451199021)(2906002)(7416002)(44832011)(8936002)(5660300002)(8676002)(66946007)(41300700001)(66476007)(36756003)(6916009)(316002)(6486002)(4326008)(478600001)(966005)(66556008)(6666004)(86362001)(2616005)(83380400001)(186003)(6506007)(6512007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TigxQg2hFf4NAFpZcBWMxZdAov0HUYtSgY/4QKIMT/T25wN3eDjc7obcPcLs?=
 =?us-ascii?Q?9wITdLt2Z3lhsTfuki5mZJ9Ry4KwX+wEmwf6RGDj4jPMmKyGCFvNiUg+LpO0?=
 =?us-ascii?Q?GMzxNsMHt+ztnigzfzvO4wdht2brBtc1gutZLyNMYq9LbnXVGfPsiTKm9e5f?=
 =?us-ascii?Q?F2B+bwPORQFv6eb2MEZwC8e2QATazlFB7V/l66HtJi9C9Ic5aZrZjZOQ7tNS?=
 =?us-ascii?Q?ZDG8cXKgqCJKvUpNpJkgBSXzssEk5eRaLJ7HwLIU/Hm0bq1zJI0HO2rOVlcb?=
 =?us-ascii?Q?YrCrMdReQ6pKIEP1h9pf95Z34GAuCXtRTx2svdEWQVE49g0gsKHv/JXYyr+O?=
 =?us-ascii?Q?oRFy97wvYqlEATpL1knzDJZwb2TZIsCejQUOhlmE7Ii7XeifmhaXL1g9XA8y?=
 =?us-ascii?Q?eoFBON9q0RyC673LNcA6Q6K2QFciJctsYtpudlVuLXz/DQ49cotPGjyVNzPx?=
 =?us-ascii?Q?gxWZ7ysHZv6hm2mskw/qW17K5mlsKPc6lZiDfsXjL6xKVBwIePZaAW0lekx/?=
 =?us-ascii?Q?UqwkRFnndVONBYj4PEzUFxyPJFDZ7IFXNF9EhvPEvfRd9UcHTisXEiuv2YVN?=
 =?us-ascii?Q?2TefiEGqTxAVOzITzgTceeRaC+xcp9QbvTp7A4lxR+vZfULht7A3Btyt35ms?=
 =?us-ascii?Q?OIIqhOVWKTuCDATY5mE4D0myuPdPcX2I/1mXpKQZ8mtCNd7gRFiKKzVwCcGV?=
 =?us-ascii?Q?L6ofNFkli9No3e79c/4oM+urYkNneHMzv1nDCyW3APGLHHynazXh7PUGM8NZ?=
 =?us-ascii?Q?FMLAFanGKQ3bU8zEJYlJSo4N6P1nfRVEN9Whga4b45lmIwKOnkISOqYdR8m1?=
 =?us-ascii?Q?/E8IL/58CPk2eU95KYbpZXi7lPUAEKuRr9Anngtcoh3tU3QBLAlhsML18a7S?=
 =?us-ascii?Q?uaYyaxjcJkS6sUWPgjsgL/YPqVpsIaM4JsoV+58AjyE16C9M79rFQf1/ZpuP?=
 =?us-ascii?Q?ntR/uIm5LwLqpAXSlMtM9sWt/acio6/cQYdyNoI/jYpKcYEWXDTxCTy3YxgV?=
 =?us-ascii?Q?PjOptnMJVIBG+wz2eNjlPaKjn303EXjEhSNKgVrCxZ9NseIazZh5Xw3LtZZJ?=
 =?us-ascii?Q?yJpAGGn09KjY17aYlIexVuhYmCMHm/wB4C4/rM7X6DPWKGg93lYSQcj1epd+?=
 =?us-ascii?Q?gq1JySDMoH5dr7lv3ZZKvnUn8zmzYJxD9QYTqVDDNov6CDg97NVAyp6nm4sl?=
 =?us-ascii?Q?nF1JNYO//44Mk+k6f1zCKooQt8LFfwWpe+F0bFybBi1aHO9yzz1EcQAXQvx/?=
 =?us-ascii?Q?O++1G+9yuCZKhlCFShr12dmESA0LfcPrneQpR+HZS8aYWHztzwrLgE6aT7GR?=
 =?us-ascii?Q?6EQvT0BL6K5yNPmEq1xwlEZsIXCFSvNk1pzzut9OFjL9CLpetndfc1WM6KI3?=
 =?us-ascii?Q?ByvtSdUW1LTE+otcZ1PnZsy8iQfHNAkOHVjfYN4GgY3VPm4BI5UTRo4yMPX1?=
 =?us-ascii?Q?PsSjhC5ZUG1KfzV1rbRD5tnGqELJWxj6BwHeqJAUAIlWRahta6vuxJkl6iPI?=
 =?us-ascii?Q?OG/3lvH/RdObcS90IPsrRG1SJD5wE/bRisnhCuryTBfg+NWoD9Ddk6z2HVIK?=
 =?us-ascii?Q?6HN4yox6ESnwTjWXxarS2F3M2VHeUeI7SR6bxUSEFsSvUDbfp5aoWeAQqr7v?=
 =?us-ascii?Q?4n/gk+QJuUsDNhUvADwFmAUoHGTCrIkV+300SGEVUR0AKa+sA8uFYkYuhDMp?=
 =?us-ascii?Q?/hQwXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 956362c0-0397-4068-66a1-08db587390b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 14:15:57.6887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApUbA1BALfPCky1m4p1NJ+KMH2RWMoSgfXKOqj8vvacErmUVSsCaIXQNjfTcg5Sm5SuM5DqHSyZnkB9MUHAfFHJ4zGt32H4DdTxovDKRtik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 05:10:58PM +0300, Ido Schimmel wrote:
> On Fri, May 19, 2023 at 01:33:00PM +0200, Simon Horman wrote:
> > On Thu, May 18, 2023 at 02:33:26PM +0300, Ido Schimmel wrote:
> > > Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
> > > filters that try to match on the newly added layer 2 miss option. Add an
> > > extack message to clearly communicate the failure reason to user space.
> > 
> > Hi Ido,
> > 
> > FLOW_DISSECTOR_KEY_META is also used in the following.
> > Perhaps they don't need updating. But perhaps it is worth mentioning why.
> 
> Good point.
> 
> > 
> >  * drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> 
> This driver does not seem to do anything with this key. TBH, I'm not
> sure what is the purpose of this hunk:
> 
> if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
> 	struct flow_match_meta match;
> 
> 	flow_rule_match_meta(rule, &match);
> } else {
> 	return -EOPNOTSUPP;
> }
> 
> Felix, can you comment?
> Original patch:
> https://lore.kernel.org/netdev/20230518113328.1952135-4-idosch@nvidia.com/

FWIIW, I agree with your analysis here.

> >  * drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> 
> My understanding is that this code is for netfilter offload (not tc)
> which does not use the new bit. Adding a check would therefore be dead
> code. I don't mind adding a check or mentioning in the commit message
> why I didn't add one. Let me know what you prefer.

Let's go with a comment in the commit message.
Thanks.

