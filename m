Return-Path: <netdev+bounces-3886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66991709682
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EEAD1C2127C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735058BF7;
	Fri, 19 May 2023 11:28:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8606ABF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:28:10 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2113.outbound.protection.outlook.com [40.107.94.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2837D180
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 04:28:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+i/SvemKVcepNGdnnyIvijQ8SIZuh4nYQ8KoWfW1dKIqG83QLH3QTIj+wbaADi2m8kE/ALaKpI+FZl3LFTH0nrMgEQcm3kmEMObZwMjt5AO9KoQNnqLLh49KM3h0IDQvzpnse6IUPIvi/O8QoTLcCQQCa6KuZE8XpQKP9rtu1PIyEKVTmXulz3cCPue60paTQegenj06M/gfh/mYHjQB6cDuhgPpApv0+HOWXlSxcAp45q8zuSNLCeNUOnjfwtN7xaRuiZycpJ8XMax8vrK3Y7qj/5LfIUiA6/5azW8S6Qttzo6DkJnIoCBiiHB0jnsSEG4gUA2JTeWu83f9EAEnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypH0wU6QclFYBuhW2TN6EYBuEnG7oDhub2+5WBGfPVw=;
 b=jUSzy3rInlejWcKlGH+amZZgliAkRFMOqfiUFuG5e2tlk44Vwpu/lh0bd8aXZ9Sx/Vwrz8FemNe/mkpRanzxJLC8s1fPC+DWXQTxS9HPZywOw+GDh7qyBoY+SEL/VgNy6Poyq2tQyYYANcT5SF1pKmrQiGBtx+ykEcEckGDr2c359XruW2E4WiaSQ2YbmO6S26o3SjQXsFIOcM5ci/9zrgglXgX72bj0FNkPOkdokQ/4jsmY9OF6G5eY0OvfsrU12SRE8xMqmgdvHHduVY1duvIRkTejqTPZaDQUHISX6E4w5LYGlPqQqwfrhQ0QNpSwm8lqoWOvaWg2cf+PVQdS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypH0wU6QclFYBuhW2TN6EYBuEnG7oDhub2+5WBGfPVw=;
 b=oo3MxPnk6P/oPTtV39VB4rZcPURXbQ2HO6HFJlMcVAz0o0rjRwHXDVJhjMosVC1J0a3oEfTQyNCwed663GXWY2uCNCAwmsPG6yxqHW6PR70ksQrcE7ZZwe+YEdqzHhucdMBGfawpqS9A5CcLt0vzm5L11jVjCe/7RJ6/e9N4dtI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5073.namprd13.prod.outlook.com (2603:10b6:208:33c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:28:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:28:05 +0000
Date: Fri, 19 May 2023 13:27:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
	taras.chornyi@plvision.eu, saeedm@nvidia.com, leon@kernel.org,
	petrm@nvidia.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
	alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	taspelund@nvidia.com
Subject: Re: [PATCH net-next 2/5] net/sched: flower: Allow matching on layer
 2 miss
Message-ID: <ZGddPLS4LM1LJYgc@corigine.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-3-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518113328.1952135-3-idosch@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0105.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d89c04-0c3e-430d-c8c1-08db585c1cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NtRN8Ac3a36Yv1SfeDP+3sQu3IJ0G/AdUu57388B6/10U9oSMh84qENjhK1jhKh/31Q33WYH766+o7GP99RacuwyATqHhYFCeYLewovDywCJ3pNOEBnTmtsiyuMmtS6zmx9X2vWfKom5j3j048jugeDKXtTvpIWZel8tdsQ4GJ6iPIfRP4HiavrdLp4o7QMTJsmW3Aw9IsqaiM1D0XGDPelWydRT2zNQelQ0JWPyGvEQ4OxepNyyOFA1FwqWqNFI9ksW4mtlgCY1GiuZrTD+5ljZir/w37P9uZVOWnLyPqvhmw2PHkvp+IcvbXKPkjbFyOGwTb3tmmR6oUzjIVkfCS+5GCH9NkQCHSMwcYnhJ6dZ9dqz4QHpVOizpY/6GASWNanczw+f6HRTbFQjYQEKFxy+M1qf0TAKR/zjxJbG2a5BkrnGnSPIjrtqGpgMmmMqdlny/UwRlLZ2H++15U0KLmpIE/EQM1SXfP5zzgw7LHjAd/s1cq/WfKxbyoBmtOpCiJFBZU106Xa3pxUC6JIKBU8VDs6U4irPyBsiIY3IwBtLHcpE6zlXsNWtnsop6+fK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(396003)(376002)(136003)(451199021)(66946007)(66556008)(2906002)(66476007)(4744005)(38100700002)(6512007)(6666004)(186003)(6506007)(86362001)(2616005)(6486002)(36756003)(478600001)(8936002)(8676002)(7416002)(41300700001)(44832011)(4326008)(6916009)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oU3U5Ca5qJ2Wre7KYTZNQuJcUi0ip50L0/o0b6Q5ZiIhz4/fNGn2viB/TdLf?=
 =?us-ascii?Q?/jJTOnHOFZiR3KDTEsQwSMvLgnTzXi3dnrM9j+yY0w/KWwRELeNs1u0TuWqJ?=
 =?us-ascii?Q?IGe4fAy+fMG1UTy+jd+grfb3DSUYqoNcOBiQm9ewV2VHvx0RhoQwlt99yyQ8?=
 =?us-ascii?Q?V5nVxDg4udeeKbpF0J2Y3eRHY/MK5sP9nw3k4tz0RYaTMP7jLEmWrtSAlFcV?=
 =?us-ascii?Q?/F5loFpHsEez9Kve/r4B0AWUEjV6H+hy0ajFFcIqOoefINMgc+bDvPg1Yx40?=
 =?us-ascii?Q?Rc3sMdtPx6kr/xCWrZPCteDbRwVZimk4xxEaod7BGMOiwPzyxRE8Ewsq38wO?=
 =?us-ascii?Q?XuZxfpGAQnSntKaocgBqSxWT+g1wA5ZmbDk4OCsMt60QJ1Lg6Frs3MlB2mF6?=
 =?us-ascii?Q?r6NwcxH3OamyAUcX95/0+35f3u6ewRXUM2KvZQM/PF+6LolY7sJ7QrKpw3J9?=
 =?us-ascii?Q?ycuNaVec/jEsNq7t0UuN1ExFQ88PHYYmnRBgC0QVWvUa7npQTchqGaysUJa4?=
 =?us-ascii?Q?l1Rfq+CLS25jut92ykwqcYh1N2DUvpX55KwFZpILGBVBKiY7L3DcUOLHh2uA?=
 =?us-ascii?Q?5hd3KfxT4mkI0Qt1nQcxBewhwbajwmUDLg/9cj1/15BOlWmShd+OPdk1C9zN?=
 =?us-ascii?Q?w1N1HndFZuuzS1dr0ZVKtfAkkiqweeN98/aTc+MQ5rrjUOQH0Zgd7Jqd7w54?=
 =?us-ascii?Q?nxpCeEXgtwXO4yrjkNHYNDkA0nll17JEKVqLr0vb2YPNZRjbJ1A5pQRtoOhe?=
 =?us-ascii?Q?L4bHj15NFeXi9YgB8a/KC5yylm491ba+NZ18B8eMD2HkB5nD/JvSnkPgwPpt?=
 =?us-ascii?Q?CwkemF4gMI/YDrw+/0T07QF3TKd9RfpwdIOJXEKXc4EEhhyYeiALm/184DTo?=
 =?us-ascii?Q?SjYhYxumsOh6UFv5csOpOy5UfNIzy5vEGW8nC4zLRZPYOxpSc6T13NvNDqZr?=
 =?us-ascii?Q?9JaC4/wVYgMx26K1vqWjRixwasvXf/iUAVcZffCNNrMeCk0SU/b35Oohp6dd?=
 =?us-ascii?Q?nwc16VL8+j7K5+GlAVM6CLI0uTvW/UsrvlYQUgTTX9n7nQluNFiiOgRhC4+b?=
 =?us-ascii?Q?Uwip0fU55JcBIi/LdmIUsZVX3QDgdoqqNbzXtWQ8Av9cjwFyVGHndcguBWUd?=
 =?us-ascii?Q?vD1deecVNKmSuWF+ziU6Oh5hqo3AyLlYgGP7uKu1aJL2adIDbxfXPW2HHKdt?=
 =?us-ascii?Q?TBOBzcwCwL8PVa7zPYzsqtwr4SfZ2dIJnNn8dW0SLKsO23ybbJErMTjUQVXO?=
 =?us-ascii?Q?5XV1W1ytWkaSXGNwpDDvjh/P23St6CT8VKCV5ydWtI/920zYT8f2JiAfWnPM?=
 =?us-ascii?Q?ahG9N6AUp7wkVeSY9tBinAwHSyY8v0BtfAxIppZqlB2Igzn2PPe0l93DT+NX?=
 =?us-ascii?Q?orJ9PkpdD0nnsu29UipPYIzDOLcl0cgqoa8SvinYO/YXej3Q0YFs/YeJq+/a?=
 =?us-ascii?Q?oKblU79+nbyNgKAdXpJueDpRYVfNqDlc+o/AFAzHRgnLxhQ97ebYYVXeXsMx?=
 =?us-ascii?Q?b7Dqnw5hBwVf12DIXXMPuh0NwBObcNTaxkVrkA3v0MajtUrBch/tDUj/3p5p?=
 =?us-ascii?Q?upGrgGf85Sj/PfuqNOych9dxuJHdB2hMPByg/TnTdSpQY7wZ+L6eHVFjCx4o?=
 =?us-ascii?Q?u4a3C92j51xU+RWl2Ts3X8rR2p74CD+KZD8tdN3pBau2TCMFYz7sBrTJoMw7?=
 =?us-ascii?Q?ly6RoA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d89c04-0c3e-430d-c8c1-08db585c1cdb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:28:05.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij+gHae//3CFgwLF6MgVF5LVHPt63JcETRkDG+qrHJQ+fjkCfK6MoZZ0XzY4JJB8moOWyqL7LN8qdIeTYvHo9OUDSNm6tpwZLCbP2SYnDBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 02:33:25PM +0300, Ido Schimmel wrote:
> Add the 'TCA_FLOWER_L2_MISS' netlink attribute that allows user space to
> match on packets that encountered a layer 2 miss. The miss indication is
> set as metadata in the skb by the bridge driver upon FDB/MDB lookup
> miss.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Hi Ido,

these changes look good to me.

If I was doing this I would split the flow_dissector and cls_flower
changes into separate patches: they are different, though related, things.
But I don't feel strongly about that.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

