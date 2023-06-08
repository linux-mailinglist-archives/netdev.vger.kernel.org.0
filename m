Return-Path: <netdev+bounces-9182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7694727D1F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECA3728161C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F6DC120;
	Thu,  8 Jun 2023 10:44:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A03763CF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:44:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2129.outbound.protection.outlook.com [40.107.93.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1455271D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:44:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUNdZS3nQSZmVY1AXaFHbxx5yFKHTgJocMNywzjbqF0oxry5NEuXOzhCfspb6QdYq9kM8cjQyUP2C0vHECPfadY3otjYYMKKN/1FoBprwp6L260gg+iP7azy3WkU8DOcuBFxZs6A57ByqDttK0l+4pK9ypaY7wtpXXakNsjpdUsK2X3Tx1/7ywSa8zwFKYJv1s6OG1LsnzmDnooZNOvxzKzrT2eEUuEi9q9/KWholNunp/EJckVan3XupXoQHMiRQua07F3ekEfacyMQBVI7o8f3HHdO6r0mwz5K6pPyUV0/e2om3oekMLKJL9c5AJK7kImunfuB0qUtjEwft3cpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fxorc9J18u/d0kRlB3gKYirFFfxr/guR2B+6z6S6j8=;
 b=JXv7EZjcMY3MAl8wR/hANa7ZiDJ0qAzMJ5Zs5RPYnddrudLZMZPoqIGMHrPO2d4bObLuLfVg5XkRZrE1JRQ4PUZWMkGfKVaGJwPd5v92nIn1pJVTAwR0vBaug6Hj5LyNwlwRGDB8SGt3FtceXNTxZ74DZr2Zax8rK7XNySGzkl4ppP8ecksdNrtvdXuGEm23ZH9gzgEvg5yYmr5Cm5dvYl4xJWYAtIYLfoUsZQcNFj90/o7Mhl/VtIYUukbcgTzG9TojHF1gQccEKUmqGou2+B1Du4+A6R8z/mVk/8LI/kVOi2I+w+hr12X7dWa3xXYznZE6xbnc4Z7Phgn6iPlR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fxorc9J18u/d0kRlB3gKYirFFfxr/guR2B+6z6S6j8=;
 b=oW8BvqprhcRszdIg8/+JN9WOBBHr62Eln3F9nnBagYgBG3iz4pRMdkYDISyPxxy2IU2/0+K5DB4sSk/LuWna3ggc2Q6ffFkE8gVIfwzatrypW1Fk/HXPTztyq7jGb69K85FV1J1vhde8a2sHfpJiRDCyIy1YDDdCL8FzSYqEBNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4803.namprd13.prod.outlook.com (2603:10b6:a03:36d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 10:44:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:44:55 +0000
Date: Thu, 8 Jun 2023 12:44:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us
Subject: Re: [PATCH net 2/3] net/sched: act_ipt: add sanity checks on skb
 before calling target
Message-ID: <ZIGxIWNUsCDg0J0U@corigine.com>
References: <20230607145954.19324-1-fw@strlen.de>
 <20230607145954.19324-3-fw@strlen.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607145954.19324-3-fw@strlen.de>
X-ClientProxiedBy: AM0PR04CA0083.eurprd04.prod.outlook.com
 (2603:10a6:208:be::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4803:EE_
X-MS-Office365-Filtering-Correlation-Id: 50da3266-9372-44e8-52d7-08db680d65c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hpOCyFiSnf/4tsesv+UywdXU/ggbvfU5bcrGYvLKB9fMPYiLKJSTeiOX+fMeztLYWZyLwQ/MqHX9DlcwahlN5P9Old93NupzCxfbcE9lfQY+e/s/AqCI+iF4PGg+rqeSBxSNoVrvtOlRE/0+osKk2jdS94dUStONoFRFpDBl8bAvESqFIWD1k2xj2HJqzJoNGRuRREpnimbTVhU8nCZAgjIFG7J7/uo/WrDBgsKhR2coLPCnKzKB7h8xtH5clW8Be/OKMAAZrEaEqlwqMLzqBDAdHEXRefUfw0RJqQKqH+pHu/jms6I28PtAI2VaqlIEE4t2WGJm1hYG+dvvklHtczntTwQk8dGxYQ1SMmtSydE8GIeB4oGNdbrnbLK0VuirhdYbmjpbBw5MptsR/EGCorem76t7fcinN98x2oc/G5A5FKpFfAGojvdifWB/KUFVMicFXmNYgODFXX54BJh3nH32VZV/itxXesu3n2CJ/Cssh47ej3RBQ4Nvi3U9fGHbMTPjeQV8IzmRstkDzIRiH6rm0Or4xDEVqiEhJRB6mvSiPSpDOJqFLqKE+XKfObN7w2ZMPPqKUImVf9JI1HfZ/Pcn8gIR48RiRoNigeTdpwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39840400004)(136003)(376002)(451199021)(6512007)(186003)(6506007)(41300700001)(5660300002)(36756003)(44832011)(4326008)(66476007)(66556008)(6666004)(66946007)(8676002)(8936002)(2616005)(478600001)(2906002)(86362001)(4744005)(6916009)(6486002)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z4Hy5DviccTv6uBVdOjG1HPAiAluWoO+Fc4/ctu6+d5RO3lN4qIKh6jcW3VQ?=
 =?us-ascii?Q?j3KVn1frhJQtURd27RAim05lAGmS81ijsSGNRQAwZdtL8xuc3SmpOkrRp7hJ?=
 =?us-ascii?Q?takvUt2ikB1JiWrZZrDKxPAKNiliEsjZ/YaBiKsL+GI6+j94RPDaBcSwwoar?=
 =?us-ascii?Q?33z6v3l/vVrhDS+Fk0X1ucMOlzi4Pldc0a0S6qxffwCMvGMB/HKSdeM7Owu2?=
 =?us-ascii?Q?vwUgEZVHIfDz5U8QXiMIy68CwTweCvBFVhAArB9HL9meFOkd7itAQZOnR8GH?=
 =?us-ascii?Q?+ydIxDz1nQZZXxLlGuOswi/5LKF8L/J3wsTcAs2LvLy16lAE4aY3eoGaAggQ?=
 =?us-ascii?Q?2XBl4U/N8ITsPYBilAloUhf8YDr3PN3kBplbMbRc54gA/5tfpEXwRek5HQIL?=
 =?us-ascii?Q?yr85P1T4E8UZueJ9phRJMP83OxaS75B6zFmaZKr89d0uMFfB1IkLUvWnY8Of?=
 =?us-ascii?Q?jW4D9/2zKQJ6jpPFM83y56twE7pV49iGQT876I0qg2reuqNpznH1SNeLTfo7?=
 =?us-ascii?Q?kuaj0+k/bzBqQ6j+2WvbUfY0eJkpvkehDNUAAvnnbL+T2yH36KN46H00fmP5?=
 =?us-ascii?Q?aKU7G13YYuNz2qUpcQpQwE85LMJumft0BmFKGLoahrK4bgUgJ5ZbpHIY1aIN?=
 =?us-ascii?Q?xkNxcKHHpTh4OrZ6tXZ727IyzS8QtKCvTNulQ5iycSVap/mraC7K8/dsKpgB?=
 =?us-ascii?Q?f1DxaYxcO6SJbVhQT01Mk9aPtgarUEmZnNhwV290Sye64lx7MMq2SALNXd5f?=
 =?us-ascii?Q?tqeQBpErJoZmbFvm1Mf0KipsiA7Cg8Wbeq1NeRPAC+6Obn3kO7rwFMR4VGk+?=
 =?us-ascii?Q?s1Y++RowGz6b60CRa2E9g4nZdEmb9FFol1A2kDGLdJVBmZUoltSQNVQb/iB/?=
 =?us-ascii?Q?psNd0K8PILZJljaPKXv1ytvaNDF85bDVX4iu7CnIFZxONL4DCYpJsIRwq9dc?=
 =?us-ascii?Q?6bQNIXGg1wR+rUgMFGm/pqzfI/gZKXiZzykc+jWZEH5EpBm46CKEALLOo8qM?=
 =?us-ascii?Q?hA6hk8UPIb5oP4DHIKM0lmwdkPIpEJXuN9SKelm34Iua5tcpyeuHI7Rkj2Wa?=
 =?us-ascii?Q?OqQNbUan/tO9PNTFRv4qHOF7COwEI8dbPoE7cqhZZMdcWJX7rSt+UpKXSMvm?=
 =?us-ascii?Q?OanXUzbhQeKQIJuY4MqlN8vPqbAPD5SOFS9WUq6YI5+atzQe2hicDIle+1IP?=
 =?us-ascii?Q?ijkAJhXK1tWbKd06Q2wG0yMomcW3vf/rUuZZGdIL6wDBz06dl4uIphkCxeU/?=
 =?us-ascii?Q?lWGYu/RXnFb70QpgSw8JbbJuBj40CxmSDjYjkWvXmfiRTC9erjpdLqDWKXcL?=
 =?us-ascii?Q?Fy+E1e81KYV5Q06e/fQwx7W7qb+b8VqgA2/HgDEuDlOAhC0mmdUsuylOGEVc?=
 =?us-ascii?Q?racEqKRGCv64lODoCnkVZOi+v0tucJcbWrk/uHuRGwowLYh4vscB958UqjiT?=
 =?us-ascii?Q?efcpgGcrJJdrZBIpCLlkiwpmejFTwCwxJv9HnYAU5v+nfmzTiHfxyOCEB2i7?=
 =?us-ascii?Q?Cu3eAgKwcZbRfnh2Eb6SRy3ZXIbzXvUfQjtwCiVlFLAIsYrn2YzXD9rnOwp4?=
 =?us-ascii?Q?1NcxGmgaqLbUOgiKm0fFua6m36R7s0lYxYDZZYaj0+/e0FsvjvG9NHkOsuhh?=
 =?us-ascii?Q?MONV0vCrDskwYR+E9l5eAS/WCXIgRRCftHB9xZHMMTqVB2sdSmc74kEUa2OH?=
 =?us-ascii?Q?tU+o2g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50da3266-9372-44e8-52d7-08db680d65c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:44:55.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uU6LA4am/5Q81DBz7POCHnJHFVL8sbzljEGtokPeaxXLsnwyEr38To6c91x7GyrS299zPCra5DemZmrf9i9W04w86vN/sCMngvrKSR8J/ZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4803
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:59:53PM +0200, Florian Westphal wrote:
> Netfilter targets make assumptions on the skb state, for example
> iphdr is supposed to be in the linear area.
> 
> This is normally done by IP stack, but in act_ipt case no
> such checks are made.
> 
> Some targets can even assume that skb_dst will be valid.
> Make a minimum effort to check for this:
> 
> - Don't call the targets eval function for non-ipv4 skbs.
> - Don't call the targets eval function for POSTROUTING
>   emulation when the skb has no dst set.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


