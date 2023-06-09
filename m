Return-Path: <netdev+bounces-9649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 818C272A1B4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 418F72819D7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8927C20991;
	Fri,  9 Jun 2023 17:56:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67E19BA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:56:35 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2079.outbound.protection.outlook.com [40.107.247.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1C8D8;
	Fri,  9 Jun 2023 10:56:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9rmT8oBThZujBNBZLyB/oLSJVV23c4VIRHDhxPCfWPVdnAdcG2JC18zaPBp91hFdcUXoIogwDvOySr9dxiYA9mS5frg7fcfNPOOBama40ykbuKFixav2SBikESKnC6wq1wRIyJtqp6U5f+N7OWiogCEmt8L0uSnvvBhVXTE4dHdqsDUc0k1GbBsRftFYsV+COg8QsGapCAxfVhWLEFa1yJi9MkywnQVZVU6J389ZbdGDuTGKI2QGBM1hhJVVew7n4NDObfZUophb3qxxl7za8jErp5BiGeXTSWgwTpGsSXUEJl9x7ZitIFVWXle7MdNhnJz0Lqzy6gCKTjPPmTzAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aO+jXWPh7p1L91lGUjgBNeiLl7E2NA4OJUCosBLPgH0=;
 b=mM+cS4rp1zOHZsPYfgVN5/q05ZKItT6wIBAMdVfBHA+ZBPXBWCazS8/jVGUQeWWprvBw/amuHWQUpX/AOZ5QMJq+ovbjVTV4R4YkeHjKYQHsZy1oXT3UYsLY5OHUDrKNfWJsdlvY809DRpRjxzec3BICz1SzOZCwfNZpWKvMPayfadzFrgP8KJYJyjbKkWlE3a/xEmOVtfkMJtGnVXQ+dO9JKmXh8zLHEAUMV41SGhqlodxkSiAexecbXmFOLf4cu0tNSiGgDkkXX3o9luwdVk4gWrZOmpOg6YYsDB9FJ5DKP0vW32ZEUJsAD6Rbv1wlbk7uW9PpHDjNFu4R5eWszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO+jXWPh7p1L91lGUjgBNeiLl7E2NA4OJUCosBLPgH0=;
 b=H6HM9FlhpgWqFXn+eKxOmbMjGX99HUXTLeaAkhO1ZkMiw0hpGKOpzCjD4dh+pLtnZnAcyIVaMEYX7XXH4doquotwuXyklBi4u+wmsd6FTATrDZ3V9C0u1+y0xt6tQaoUkfjmi78l3fYSpRyxidFqUHFo7gdOuxQ5caMYFrB3nFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7629.eurprd04.prod.outlook.com (2603:10a6:102:f2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 9 Jun
 2023 17:56:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 17:56:28 +0000
Date: Fri, 9 Jun 2023 20:56:25 +0300
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
Subject: Re: [PATCH RESEND net-next 5/5] net/sched: taprio: dump class stats
 for the actual q->qdiscs[]
Message-ID: <20230609175625.444p6q33xq5dmwfw@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <20230602103750.2290132-6-vladimir.oltean@nxp.com>
 <CAM0EoM=P9+wNnNQ=ky96rwCx1z20fR21EWEdx+Na39NCqqG=3A@mail.gmail.com>
 <20230609121043.ekfvbgjiko7644t7@skbuf>
 <CAM0EoMmkSZCePo1Y49iMk=9oYKR8xfVDncWF0E4xRhp2ER2PRQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmkSZCePo1Y49iMk=9oYKR8xfVDncWF0E4xRhp2ER2PRQ@mail.gmail.com>
X-ClientProxiedBy: VI1PR0202CA0030.eurprd02.prod.outlook.com
 (2603:10a6:803:14::43) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca01f21-3757-435a-cd88-08db6912d9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+YtfU0wOqf/QAfmJDAQHTYEm13cueIpCQiGQUyWOouYQW83pMRovXQ0WgwQSAqBvuk8QIpJ79p6WHJqTFghRdGyHJTKaGYzLiU/gtiNxxMNj4rC88Lnq/J0ql8mDNx4fmtP/s/meTDvysQf6cVrl6LQAMbjGT7k5+8qaJ9+hA5dHUsgKV2U6bpeWIRJTO6lmblU57KMn8yqxsJ4RDTRKaaB2xQtQrOE8NIbRbk48IgIUAm2iD5GXCL60Ld/J4nQqGCMgCFMUErg978CxKisnVJkpliSWo7qDSspL0NKwzb4tGnE1FM/sVSTkmFU0u3q+Ms6i7BRbmStwerTLuS0Rbl/HXMVhZ1K0Wyv1baSWfIAZllUkUdKDnKZoe9cZ1DN/HwLxHByXFbEOOJrRRvNguKn+BSEFktwNVK4/Z6DAL+DDuI2CFoqDx2sM5geqOHF0TYpT5EOOrd+TsvqaTJSbepBoKms4yhHVKEWTgvg2UJUsV2uqs4i7xzMxDY+MQ7kzQBtXYeT175YIMrssZgOi//64jt8HiULwuR2VYf7DPm5kVuwZb5ijjT+1CJ0wYjsV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(9686003)(26005)(6506007)(1076003)(6512007)(83380400001)(86362001)(38100700002)(186003)(33716001)(41300700001)(44832011)(54906003)(5660300002)(478600001)(66946007)(8936002)(4326008)(6916009)(2906002)(8676002)(316002)(6486002)(7416002)(66476007)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GPFNndP7637i8a23tAX/l1VaM3WKs1xgNZiReIusfP2JyE9Mkubkh+HT2ph0?=
 =?us-ascii?Q?PiQyH4B80RGcQoedqH7oHYltJ2xkHyYwzLBruqXT4eGjd1e3ybS2Jrm0Cfjq?=
 =?us-ascii?Q?4TbUN5ZXpDSeJIXvd1z16IFCZP1mbep/kN6lxaJ1yOWBNm7CLRNPeheGgPHG?=
 =?us-ascii?Q?paPZufifabZBhGvgc1gyOjQdtdiR9f9kddJlspCEJXYwBS/jHIGz9Eb5Y2FQ?=
 =?us-ascii?Q?Qh3w2ZjTirH0NSq5Szpgm1NDU83ymVRKEhfnuAMU5TAQhUfALJqRmN7OByu6?=
 =?us-ascii?Q?MRMt0bhlbHvPXkuFgZUnoUO6uBjt+bhkTIWrC1ICnIw99PeyrldV0LPTjsBW?=
 =?us-ascii?Q?OwfuBYFPIG72xXo+mZZKj1aop+Uh2AaDiReNo933cfySHGSmhhW4p8p9/5ak?=
 =?us-ascii?Q?mzddsspDAgmTD5UNcu+n0brQTLrEMhgD+jLdCYaE6Xpl9Fm7F9nt5+bvEyYt?=
 =?us-ascii?Q?gfQLKxU9H7vlMVCUOiWTx3p6u5mnEKVf3Iz1kzAlqreH8iqLVsFfnIldSk3T?=
 =?us-ascii?Q?U1RyQ/SNf/P2P0O9cg70loLEOzn7qtNr8UVU/1G4frqjQ/RAOr4GmBxxFXtp?=
 =?us-ascii?Q?qyVMbZJ2joxIEx3eIyatXF1a4KXfwJ1Y9Szl2AAzktoLFhneoOPIgV9yvxcm?=
 =?us-ascii?Q?WtNdHrN9FljLAI5Nq6nxV0gWOCO7QM5Drc4WMsWT3WNL0NjrlAMwX9488Ila?=
 =?us-ascii?Q?2vj/GWWQKqbE/VPMKUXz1DVqdhERThHDaNKfpPN8Q3NMDt9iuDsd+EFQKAGO?=
 =?us-ascii?Q?SIHRldkGWl/ns0dvLYiynTofk8CNeb/ZEb/ky/dYR7c/csuGJRZAl9JydZtm?=
 =?us-ascii?Q?CKqxWAcIYvUsepQy11RAMuvy6gpROepv429vTn5iCaQ281MabmKNQHmJ56OR?=
 =?us-ascii?Q?EbbxSG1Gnfa4+e1Ub1NtMAL9/49vH66xB7n3EWAyi7+ZKNXhAi6kaLnRGeHM?=
 =?us-ascii?Q?cF3ej/OwNbUVkDION/SNHVFGy7raZ8ig3tLOGDKootnn3m+wdIS2tvkkvQHN?=
 =?us-ascii?Q?uez5lc6+WGaetylCBxEA+sMl16KSqQ1QXjRQ9UVMyqIXeQIvu6X0vJmUI+bc?=
 =?us-ascii?Q?6QZSp4ujcSpR6BoS1iK01PEne4XUNMooGA/6Nr4bz698/UgaropAEYtVy9Wh?=
 =?us-ascii?Q?r+XYM2afByrG8W3fiaXoI1eSUZo+cRyRV9xtCfGlYNeL5wOSDj5FcN5ULP0O?=
 =?us-ascii?Q?hZQ34y5rGgpl4GZQCoMxj2OVI/rus4q4wSwzXWGgl/bkPx3S9hRcgGMUC6Ff?=
 =?us-ascii?Q?vuZUWm+uSs4lvFjXV2psfCRbfP1xqgqIpLv56rZld686KlkPE2v0JV9Ikxju?=
 =?us-ascii?Q?YbOgrnV71yc7uzouBFMMj64txGeIliZTCck5XV0TDk77E2AmMmBWKVXtYP/i?=
 =?us-ascii?Q?aGmNePm8qE9smDX9n8SwHIBCzuclpp27E/dK2bqp28nEZH1py5a7f8o1P7pE?=
 =?us-ascii?Q?BnWkT5F3pbcYlrSsrQwmXEe6xOvVItMoenIOgslfNfC/7wbXIkPBoqqaJCsr?=
 =?us-ascii?Q?dSCNYRV6bo9MlTkCxELCmcI3+45MlpoUyT8xTc3GXytvAYmVpg4xL7DLWGWA?=
 =?us-ascii?Q?qsKumx+W4PptV8sWoyKCeLOMOe9nNpJb5AdZXjfoK8YTrjiu7y6pKR8W5AwS?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca01f21-3757-435a-cd88-08db6912d9a4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:56:28.6247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMNtDY4NxUdFJGgSqpe6Y0L/GPYVKCOIR3xKPVa8jrFD7xteYzAtReP33HM+3fTKsqoOvh002AByj7dSonBnmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 12:19:12PM -0400, Jamal Hadi Salim wrote:
> So it seems to me it is a transient phase and that at some point the
> backlog will clear up and the sent stats will go up. Maybe just say so
> in your commit or show the final result after the packet is gone.

I will re-collect some stats where there is nothing backlogged.

> I have to admit, I dont know much about taprio - that's why i am
> asking all these leading questions. You spoke of gates etc and thats
> klingon to me; but iiuc there's some time sensitive stuff that needs
> to be sent out within a deadline.

If sch_taprio.c is klingon to you, you can just imagine how sch_api.c
reads to me :)

> Q: What should happen to skbs that are no longer valid?
> On the aging thing which you say is missing, shouldnt the hrtimer or
> schedule kick not be able to dequeue timestamped packets and just drop
> them?

I think the skbs being "valid" is an application-defined metric (except
in the txtime assist mode, where skbs do truly have a transmit deadline).
The user space could reasonably enqueue 100 packets at a time, fully
aware of the fact that the cycle length is 1 second and that there's
only room in one cycle to send one packet, thus it would take 100
seconds for all those packets to be dequeued and sent.

It could also be that this isn't the case.

I guess what could be auto-detected and warned about is when a cycle
passes (sort of like an RCU grace period), the backlog was non-zero,
the gates were open, but still, no skb was dequeued. After one cycle,
the schedule repeats itself identically. But then do what? why drop?
it's a system issue..

