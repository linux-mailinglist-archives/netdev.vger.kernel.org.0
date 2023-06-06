Return-Path: <netdev+bounces-8565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96096724934
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06A2F1C20ADA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF2F1ED4E;
	Tue,  6 Jun 2023 16:32:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A945535C7A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:32:12 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::60c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C4126;
	Tue,  6 Jun 2023 09:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdzhoGdnhB3zjoFeMajo37aLQ59yBoE1h59LYrFrLS4fSYJolmaeFzdPPAS8ZFfXSpnLgXGB9rVwnkx27pXajeM28Efhdyxmp5NxaWcG94gtVsiV/4KMT/RwrJ5Q/fMWBzCKJfg4m6AhQMZo1X39IVooLYsf06D2aP+vtyOCWyHVR7BOzg0J9Lp9jr46o71LuZaAGMGo8GQX6lZErLKn/sH4Cx6q9GJbHATkEBx4zdzJmP+nahivPdiSNFDn60YZDrRwXGoHftyuZjqaESE178NB3zlcm/6Tehjzd/wGwwbmRX5y82MALKFgdrTlKb9wzHNKVn6nCn1s+Pzx6ShxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkrO8WfsNhZ4IswYnR1h6pUZ38ipcXRalu5M2GFFSvg=;
 b=fA2gN2cgxxQZsTPydYBl/6T4UcSNN2uynUAvi5gmWOvW8LTiZE4bg4A8BPPzNqYwy9M6pTwtzLU0U4UsQ88ozBDXY0MAfiifwD+Eq1E1hG6BPh4LhsqcPzqioPG5HySrRkTx/MLYihopdMkPR6ue9XNdjzSpjymRcVKztW3nU0QMZfRBDdK3stOBMx9sAjGmJb+tLi6YRfQOPb5YY+sXWToYgQ4ZnqJa+yXmrVpXi4aXisxCAhl8k1+1su+maFSpU+0h+LAwy0kR17k9nwekbtWxuErMyVCOI0WpKn9rZKjzucMnrKLOhhN6EAYxlYjjGGPsnfGO8jGTiDF1s0lTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkrO8WfsNhZ4IswYnR1h6pUZ38ipcXRalu5M2GFFSvg=;
 b=e+fE3LGsI90mSI77ETFxY7lxuFsVvygNupge1mmoOTRv8A5zOk5Glw0FeGJaQi94AC83k1jXGi8Ub4Jx4Dwed7JIJ0tOxcUpJxxfvkFNYvSrgDFjdWbFonpBqrXsqdbXxhHDWhF6EELvJWw4r7SIENWsYhxPicrOd5PIL1HuCys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB9046.eurprd04.prod.outlook.com (2603:10a6:20b:441::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 16:32:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 16:32:00 +0000
Date: Tue, 6 Jun 2023 19:31:56 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's
 relationship with its children
Message-ID: <20230606163156.7ee6uk7jevggmaba@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com>
 <20230605165353.tnjrwa7gbcp4qhim@skbuf>
 <CAM0EoM=qG9sDjM=F6D=i=h3dKXwQXAt1wui8W_EXDJi2tijRnw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=qG9sDjM=F6D=i=h3dKXwQXAt1wui8W_EXDJi2tijRnw@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB9046:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a49a222-fc56-485e-e61c-08db66ab8d66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uZ1eT9sY22GbJS9Baxd1SMmNHj2Bl8BS/XjONhGfPaiNq4V4J0Cvubn3fqlWA0pyizXNSjsGiUw690nRslJT0jFpI4+jvhyDPC3KgZyalb7BfXo4FA4xBUg+f4dU71w0lKH6wyVvUoxYuoUlS9fVxSAc3HeBIjKoIrBbOvIy2OSDnK/X6pjIIOrt2k3jJztVxjDWUTVzAO0aqPIYKtkPmvrxm58fuIpX7dZCRzVfG5EY6DVfeb/2XsCbuJBGHmvrlSp4AOwr1EJFdg8k4340Zxg25Yy6J4qnP4Aj+z9bW3mBetcCkGU7Vbgss7KK9yXW/qkEok+ZKbqmvh6i1fbuw3KGQTF5yp8qaX9WRlJXi07r9n0pgd1j+AXi4JciBN3vI8uwD4kVku6ARxTb5R5MR0JmDoOWVNKsB1iXk0PifqdbiCWXy8a+nh2STA37YfuTDKFxc5p1qyRbycvd18WJ+S49F5wtIDu8mmupPT+dVSTE8pCGEUdJSjjA4Ju+NN0+TSmuPMxNNkikQb6f//ySmV4XdWp5KAkgAOSLQ6uotLmGy3AO9UNRP2wcw+4kDCYE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199021)(6512007)(26005)(9686003)(1076003)(6506007)(44832011)(316002)(83380400001)(66556008)(6916009)(4326008)(66476007)(66946007)(6486002)(6666004)(186003)(33716001)(478600001)(54906003)(2906002)(5660300002)(8936002)(8676002)(86362001)(7416002)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q5TyWCX1vwV+9VAlj8qNAH/6aOVFjmkIKSmycUjXx0G6KzDPwDu5Ni0XPxZC?=
 =?us-ascii?Q?3U7XvpIkswF34IhjEw9poAtuKRD1tFkm4isYZ4grej3MUWa5DKh7HQHdUprS?=
 =?us-ascii?Q?QAyq9o7S8jxoL5bskI1+jUAjBk9TeHBWIYBOZM9ehMc7EsM7AYN4p3Q04LE+?=
 =?us-ascii?Q?kIK91ROPD8zTXrHaRawzpyynYJzkQXFpzmSx7X1oHYTvpDsI9flky6IDb/Fe?=
 =?us-ascii?Q?V+h+8CsMb3FDiQhGEObkkDvnT3K65vadzk8I7whZQdfgwnOpqCi92waNyXrY?=
 =?us-ascii?Q?Dq0xC2G796Hk6M1MjRPQRwuWgI/7YL/cEB6upNj2Svz8CvJGPgSgynHJPt7C?=
 =?us-ascii?Q?h37sDnllN3Y9mi8GSrcqbkzijQ8Bv/z3uQdeeONczZRfxY/Zt8mQEkJcfpIG?=
 =?us-ascii?Q?Kt4a40KaYL6MTjc+JDfbIGyPL2FJiFO2xLwZwNlQyVtV+FQlhF9+xUnCA+dR?=
 =?us-ascii?Q?f4RG4jOCpcLibMU3javwSazh9I/b33VZgH2YoezmXcBTgcpxcOnd8UijOxCw?=
 =?us-ascii?Q?mJHuy6hNSI6rWG/GKbJi3a1UiRFqKML8MtRd68r/JWiWfFeBoy6VeoIg+MZD?=
 =?us-ascii?Q?qNLw+OJqLPic33sqymKQ64UhjfXwrQko1sMe4llhb5dkVjmRfDDFA+D3kdon?=
 =?us-ascii?Q?OHfUx2fnaTVIRrArivsuVGoIquREFnh9c62Np07fFjEWiEjnr7DV5MmvQ5NO?=
 =?us-ascii?Q?uC7AAnFEE0vPMg0OGs2e/dEDdkwypAm5SwjQvcdJYeOYNduz2MSlEwbqCz39?=
 =?us-ascii?Q?6M7v9UqDJGZHSwe6VDc1vxYNJs3FIE/9eCxwa/tMgUQMyzA46aYC7b0sReFU?=
 =?us-ascii?Q?UCiFUzfRQFPuq/yB0X14GfBIQ85s7pUTLPiV1/iMoF2dkuXd66IG1JmLGJ8X?=
 =?us-ascii?Q?Y3gttLCgTlLvgKHVP+f9SZa8wNlwsvD8j3tbiwyIGlu24TH5bPimQQqNaFQ7?=
 =?us-ascii?Q?GhLdkE9OSFFZcfvFAsO4vcA3SK4hG4gZfJy8Sx25EYcGmK3p0EjAW9Pgh7Ve?=
 =?us-ascii?Q?PZnJ++PAke6usL51IKDlG6sNkp7eilPVuVMf7PaJwqkLtYVCJP0ZtoPzrmRV?=
 =?us-ascii?Q?d/lu9GEpHKKQBweHwZ7xXPRWC5shW4P3Fq0AQVt9sQfx0gR/fRZSZLr2NuR+?=
 =?us-ascii?Q?iR+GeYwzlD+0J3NG7BDlYJySeHfAcaZ+jaHEEpK0sEj2F+zwQ8WZxN9y/3uD?=
 =?us-ascii?Q?DHCh5nMK0qgvX2vOgNdab079pqK6gFy7Gafv1OvPf7PEOBrb1YGT9U//iF0V?=
 =?us-ascii?Q?L+z42JsrEc/KOUmG2+bmnzLyxuCd9puIQbKWE71vvkBsws/lpDofUL0c8+3o?=
 =?us-ascii?Q?6HxEWOzZowqMHO49zsJ3E8EhEjd9gsV7JdSWHUi/0vIOB0VFH9GjL7Z2qOd0?=
 =?us-ascii?Q?d4jlW6OaittGe14lED5fdKAnOjtUG3We4bQhAlV58qKFK73n0ma8N4xjnSi/?=
 =?us-ascii?Q?adcao0t9smZSlt5cfhfhAFFjSpfYoqImwVmh8RJJqot05qXcTSIiEeHQffO5?=
 =?us-ascii?Q?0In3K0EcxJ3wy3s8pYzO71EeT2IGs4iM1BqqTSJz6AeqFCYrpOGA5hc0+UBo?=
 =?us-ascii?Q?CNwm9x+QKKr7C7o4Jb0YEko3UzxrAHTF4Rw+FtxrhXCBEDFbnXbHRxgwe5z4?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a49a222-fc56-485e-e61c-08db66ab8d66
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 16:32:00.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DUlQ956gPjsQwk/hAXTEPnrOg/eiqi+P5BcBgi3PICtYcojXBsbCix7NL4dWAQhpzULOe3F0bToEzEICSZ1jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9046
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:39:32AM -0400, Jamal Hadi Salim wrote:
> 1)Just some details become confusing in regards to offload vs not; F.e
> class grafting (taprio_graft()) is de/activating the device but that
> seems only needed for offload. Would it not be better to have those
> separate and call graft_offload vs graft_software, etc? We really need
> to create a generic document on how someone would write code for
> qdiscs for consistency (I started working on one but never completed
> it - if there is a volunteer i would be happy to work with one to
> complete it).

I would be a happy reader of that document. I haven't studied whether
dev_deactivate() and dev_activate() are necessary for the pure software
data path, where the root taprio is also directly attached to the netdev
TXQs and that fact doesn't change across its lifetime.

> 2) It seems like in mqprio this qdisc can only be root qdisc (like
> mqprio)

so far so good

> and you dont want to replace the children with other types of
> qdiscs i.e the children are always pfifo? i.e is it possible or
> intended for example to replace 8001:x with bfifo etc? or even change
> the pfifo queue size, etc?

no, this is not true, why do you say this?

> 3) Offload intention seems really to be bypassing enqueue() and going
> straigth to the driver xmit() for a specific DMA ring that the skb is
> mapped to. Except for the case where the driver says it's busy and
> refuses to stash the skb in ring in which case you have to requeue to
> the appropriate child qdisc/class. I am not sure how that would work
> here - mqprio gets away with it by not defining any of the
> en/de/requeue() callbacks

wait, there is a requeue() callback? where?

> - but likely it will be the lack of requeue that makes it work.

Looking at dev_requeue_skb(), isn't it always going to be requeued to
the same qdisc it was originally dequeued from? I don't see what is the
problem.

My understanding of the offload intention is not really to bypass dequeue()
in general and as a matter of principle, but rather to bypass the root's
taprio_dequeue() specifically, as that could do unrelated work, and jump
right to the specific child's dequeue().

The child could have its own complex enqueue() and dequeue() and that is
perfectly fine - for example cbs_dequeue_soft() is a valid child dequeue
procedure - as long as the process isn't blocked in the sendmsg() call
by __qdisc_run() processing packets belonging to unrelated traffic
classes.

