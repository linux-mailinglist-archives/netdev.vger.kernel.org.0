Return-Path: <netdev+bounces-4286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E7170BE69
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88E7D281094
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6E1BA3B;
	Mon, 22 May 2023 12:35:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A984F13AD4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:35:51 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20727.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::727])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEF6E64;
	Mon, 22 May 2023 05:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQ9lKavhlfnER2LrrmdGW1+7IC7q8SsluSKRRVGSdDUZ5S6dJhxFwYrrTgBWpq8DocsP6oarfgjYcBqmt2aXZaFVRXz1C4/QFyb8gVPoyQzfrHwHxHsDSc6KSIK2AokTnPTLfRbi4E/BRUlkpTA/wC5Rb+G9u5dtP8gd1xUCsflAPjG/ZIPI4CkeNj5H96QSibvEKQZGjRUmhBUDQY3+UXpG0bgws+1I4XKe4VwRqTNqgndYORcf88lRvTYrDpXZveqlcNjirsjFJCohV8FRbFgGY2nCL/wbb2rRSQHO9TFDDNdJAqJumqz+Evu7L0ckukRjePAvT1WNfqmWtRTqvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HafZaPh+MyFkhRubGiI0uk2krqbFrC/TONXNFuz8q/k=;
 b=NczYqfbwiGcVCk3Zb27XsH4EGKiIYfgJCcuuyLSCgdlzDv8tvqP3FISd6K3TcHQoq6dFN9O8M4yG2UfHl0jLctI5R6gyLPQ2v22olzbSz6jDc3LbnLqU4Q2PW8Dt3VHUpiNVWnGuC9isoi+3oZVEXO4tdEUZl/4x1Al3fdKCjntI5qeQsZ2zaHYxRJhtBpj4NDtvlAnx5VWLj5x57M3XvF24X1GOLxWPvbO8Rbd90FxyVhItUzUmlWv7LbCLU6HYwUzqT7azA5t5HQ46hfF/Fdl9XpnvYXzpW0DwA2R+PCAafb1+S5iA3kQ8mq3lFRwbE2TvVNIFphq0rMc4mUyedQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HafZaPh+MyFkhRubGiI0uk2krqbFrC/TONXNFuz8q/k=;
 b=b2VyHi332YKbv/0zF4iE1f6BN0cbqFwjxh1omfL9drZvbasDFhwYX/zci06IBs4iWWV9650MBU4d12oNUJjX6OJcX3un18FIdz5ZnHU+4KM4M+E6tREeUsA4GH5wYI95/7Pr2XuVaT4xjIs8R/06zeIhU0Rutikbx9xdtGE941U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6391.namprd13.prod.outlook.com (2603:10b6:510:2ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13; Mon, 22 May
 2023 12:34:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:34:36 +0000
Date: Mon, 22 May 2023 14:34:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] 3c589_cs: Fix an error handling path in tc589_probe()
Message-ID: <ZGthVr9FppjWDA9F@corigine.com>
References: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6391:EE_
X-MS-Office365-Filtering-Correlation-Id: 2584fd1f-64da-4bef-dc49-08db5ac0e776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uFTa6gqWSe35i9/1HCrLVYUCxogoIy8MwgnVojR3T3wnmk7NKAp8k/0cz/d/1JwiTrAomiayDzRgOnEOOjdBlG6tSljfCw2qwFVbxsNqw5lARwYxwNxDe58/AtoZPrYbLFMi4PRqZQM7KDeIERSQXyzjcZTB0O2cZn9vRjZSoCBbu5UDErseoVW1g61Lw52ZtFwAHw6I8AoYEUzZaTwU7Ya0L8MxmPjouFg35Hc48q+SqPb3ulklEjxJcv6Y1HLVTKR2oq76Mn4P9pftOPsk3dd00CXcUY5t9JD/rM8NMTwgpdmRrD73wk71hhbJt/Ljeg1AA1/wws8AbYT9grDBQ5mTOyFpsgDpGkr2S2RG3JcbdjxteMMumvE2rre9ckLvYxbam3IEmIOW4SYGTCxNydFtYvHk1GyK50Ya3vDaT4fRoCD+D4DItXJlMXwMgCI2opw7fQd9DrMXQp7S7Kznjbs/qAPTn2WmQgulgvDRf81GbS+/J1FQgENHAZlcvR523yy9Uek5GB0QPzvMyVzyTf2XohZGva4rgQ5zU7A7V3WlXJfb7qWBID1d30RXIhFm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199021)(6666004)(86362001)(316002)(54906003)(478600001)(41300700001)(6486002)(66946007)(4326008)(66556008)(66476007)(6916009)(38100700002)(8676002)(8936002)(5660300002)(2616005)(36756003)(44832011)(2906002)(4744005)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gdGOuw61RfUDnmu4y/Ky80yjsab8zH+GknGm+80gLxquiW6x+vXyab+g7vHn?=
 =?us-ascii?Q?OlLa/JwPG04YtQn/lMHZy7lK2B8Z2bBjN26M6DdymNgvHxDbOvlYWmaAe2AK?=
 =?us-ascii?Q?cSG5Heym1PQHXKDQqXXpCqYtDLaShSYkONyr8+sOZ6Efvu++lKxIbgIy/e6X?=
 =?us-ascii?Q?J+Ks6CByD5d4PCXLVzxd8I3bAkJCK43jAfX4WXj5X6bMONcII6B/0z2oEqsf?=
 =?us-ascii?Q?6n961+CPN8MCiqGZgDt2xmdh5fMQ1pVy8b/C2UJqAii0AXkAViT/5OETj7o8?=
 =?us-ascii?Q?+7DIh9HwBfxdfoSTW0aohyMm5fP19i3xhEIxYTCHn1orCe7ZOYuoXRA/ZsGT?=
 =?us-ascii?Q?4cvRpnJi+n5JhPErDOBJScEnhpXgeus72bsG4yMklfoPDymwZd+MSKOKTdCX?=
 =?us-ascii?Q?XipWqZehGTxqde/KjNDvESRw+OeqHtm9PjoHTj0px6Od5zfoJrE0IU27ovZA?=
 =?us-ascii?Q?zONqV68roLeNpla9BPO13coi7K0EODGeQuQyE2ceE6OKqXj2IyETwqdSUNir?=
 =?us-ascii?Q?TA3q3MM3YIibwZKQKDl36TdWyKtiqTTbA6lZklOWFevJIaWO2chUu+ZSosWN?=
 =?us-ascii?Q?ribw/+TItj0xr5GJnutnp523EJRuurZ0QwiWPYJk9vE56luUrFNgy6eCESFd?=
 =?us-ascii?Q?QFooinRcEz4qzJHhOUkcS/KMzN/FguJCJrBHsAKlpegCdXqiGKA8SAWyaswH?=
 =?us-ascii?Q?CgG9VZjwSRpt6ycJvEsFEQuXTSZsmpbKg1uszetGeWLacG4gKwKnvo1zuJc3?=
 =?us-ascii?Q?uAqk+HZ/NRw3WghEK/Q8J68xRTkBDdwurGlAV9NP9OmrUY3vbEpAXtyt/B5Y?=
 =?us-ascii?Q?MQTQI+Ejoal2yGOouTuCNNFOQ9xVHYbcXff6B8TEqiOWS28t7MEfkUdUsHMY?=
 =?us-ascii?Q?uCK6UBOqhT7xXzTNiPGrQks6Euuftu8F667xyJAEG41K5/cWrXbXEIIhcJSv?=
 =?us-ascii?Q?zlZihhxtvFL99e5tK722cy8HBXhp8Nv2jaujpV4Pp7BzWCVIyuuYfqrSUqYm?=
 =?us-ascii?Q?mNWp2mdDscxC7X0WxE9s+L2xA0y5mgy8Bh/EQKoUfCmH2Eb5/Av4YezdWSjS?=
 =?us-ascii?Q?y0e1Y2C/KX067O7byrGAjkc4tGgHTCpKrczVrCQ39hfMdQXrXdapW+k8Ww6A?=
 =?us-ascii?Q?Uh34WO6e3tSKRsQvNHlBcYo5nzw1a4IPBlVfa+7TW9aX8rbzgPhh7mqODN3n?=
 =?us-ascii?Q?q1BuJCPfK2CNrUawTqbmE2nME9mYOTiZTsk5Zhq5kceRI3m60H4X0EU05re+?=
 =?us-ascii?Q?sFEDC+FEAG2YjVsLnj3AqOFCN/qt71ogYo/sK6qeK5l+pFlqjl+pmdf09VX0?=
 =?us-ascii?Q?83LiRzCXzYVN8exsXFlZacSMWVEPn+7kZnMU0jQ85dm5Nps4JInoJ8E+G8EG?=
 =?us-ascii?Q?tJzvwrgNwu2ho/GCUp5DzNxvBY7nvlhtpKekuLiWd7fyvWkx8GDoH5KH1DQA?=
 =?us-ascii?Q?dmU77rFkt8TeJB2sHbRbA0jVJhXOU534jP23GD7dVaGHu9GlMsYSg346ovkQ?=
 =?us-ascii?Q?ODe/IudBrzC9FBWMSsx2JJFcrsGE6BoHJm70wY65e0Q3pwnFwAKsmBGk7m13?=
 =?us-ascii?Q?/WZEGn7V9UVNqBCJY/hdg8oY2G873/ZIsqGUvgjR2NY42AUC8Nug/OIWsXaG?=
 =?us-ascii?Q?lv/Q/f4jd91spDCcUES5Yd3dZEvw4vMMRoW+65uQQ9qMpbE2r8jkXXDDD8UA?=
 =?us-ascii?Q?cEXWlQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2584fd1f-64da-4bef-dc49-08db5ac0e776
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:34:36.8691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTVNv+6DhKhh5rXvC1Cb4obATK3E4b3SkswvmVuf/oQflFZRm2Bhb6zNvBNZgp3L7FIhv8tr+ibvzIHPntCs57vv29TSXT+ILLGawbrVN2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6391
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 11:48:55AM +0200, Christophe JAILLET wrote:
> Should tc589_config() fail, some resources need to be released as already
> done in the remove function.
> 
> Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")

That commit is probably going back far enough, but I actually
suspect the problem has been there since the beginning of git history.

> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


