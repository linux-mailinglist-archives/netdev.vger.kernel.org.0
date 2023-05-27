Return-Path: <netdev+bounces-5898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29F87134D9
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CDEB1C209E5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFEC11C9E;
	Sat, 27 May 2023 12:59:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881DA20EB
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:59:18 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0BFB2;
	Sat, 27 May 2023 05:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZx7CPrwTngD51PcORJJQnWPmtr4DuK7G5aZk0cQI6LeZgGDPvxr04SaaRGUnQbH/rD1Hse3xzyElwVBnVmKX1Ux/WxlT8ll9WlzV6mcH7YNs+cs/fxvwWtMzf2xOHoKk9jNbpWrxDxl5QkhBgfo0vZOqfxKkXeqDmbRi4lXDNv1NPlo7OqpVS/GjUOVYsq5TOGSMmGOMacSofHKDhukjvNIsozlR4I+3zaG6iMAV6Fmol9iP9G/56vPSUa9K0jSMY5waH3EzX4BNA66uTM2ZHfFsAnGXFHkRIeAmAy/GX1G9gUP+SXfchCFcB4vVpn/KlgrpsyLSQUtK4kW3njYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1ZPR0fypTa4v+oR9VRgrk8dmV8nGEX8YLaKeoluXJ4=;
 b=XncVaqat4Oddyn41BvVlrF9lfi9/J7S5doJ2XU+LVnqmaBy4hApa2g1A7S9xAtDS6HRckDROVCW0p75YAJ2/Tf83MclCAcHL3x4NCBwM/EbTOmVbRasaP1rSF4SNl/chAcH1DxsnPS+m9iJE8Qy5ES2jxRhrEEBqvnJFJCRq7Bb3U469/2AxmJARO3RPGnE3IiioB6nQ9ng7omjHeHQuWNT73KyfLEsxo5AL0xga+X8gMPvylbqEXzqBIuIMw5jR65wqzz487wMy2uvsKwKjCdB/qnpYrAkZYHmUljQzlXZuvHiJfmq1TVr7qGXSykGt4LEGTY0qx9ETMsaRDuc6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1ZPR0fypTa4v+oR9VRgrk8dmV8nGEX8YLaKeoluXJ4=;
 b=DqGiJ+rfN6GrcWF+DdwS3ZV42CCStwdxl8rEY9E/fGQAQyjfhy+glpsoYlANN1rcTauvxYY2G14jp25yOfbEFgDncgLRCBZ7jhwpuWUqLVTm6JlVwsoYmEaYQCiwMloTvoFL1uJP8XGE0J8vwEnUCAyv0KgTw5AUd5WX0kufSYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5676.namprd13.prod.outlook.com (2603:10b6:a03:403::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Sat, 27 May
 2023 12:59:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 12:59:11 +0000
Date: Sat, 27 May 2023 14:59:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Sungwoo Kim <iam@sung-woo.kim>
Cc: benquike@gmail.com, davem@davemloft.net, daveti@purdue.edu,
	edumazet@google.com, happiness.sung.woo@gmail.com,
	johan.hedberg@gmail.com, kuba@kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
	pabeni@redhat.com, wuruoyu@me.com
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix use-after-free in
 l2cap_sock_ready_cb
Message-ID: <ZHH+l73YeZd9iq52@corigine.com>
References: <20230202120902.2827191-1-iam@sung-woo.kim>
 <20230526181647.3074391-1-iam@sung-woo.kim>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526181647.3074391-1-iam@sung-woo.kim>
X-ClientProxiedBy: AM4PR05CA0009.eurprd05.prod.outlook.com (2603:10a6:205::22)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: e5290033-ccbb-49f5-010b-08db5eb22ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eaPYz0i9cNrCzVfJHtXoL9K6BdocDRGJ153nX3s+6vFKManF1ckIaiWjPtSqliJr8BzjJ5/i9SYLkcTgWW4/alv5BxS+iiV6IhVo6e9ZW50WkFJiPXbAL2cfgwNDvaEPBkAvrA7rHItHVs8/nuTKlHCrgoVz0tvsbfs2UGDZc7dqnXXOsLFwOWGA1s4/LKGtOJdMu2rQJs39BjrCJji0zQcb3mc2raQBcZ8Ehz9vHU9r/s2ZORSUjTSceUtymRC3X36GcODJ3tSaIenVzmyJyDiwwVgUWZPHzxKvekGnJzQlubi3yf+BHQBf8Fqx48gc8IVfE7kLHSxAJsoCh8AbWh3d5ZQPyjW8IJIYUvfEi4rU+4BHjea13GMT91bCvNw0Tc6csK9TZ2BR8O1y3aAmSMFwOLuei5OEFNUKmKAWtugwbahP6t9gokbuWpAlZoYQEtFNjGOL7VGgnpAkr1AS00SAU+sokOKtEKQnjgQsj8kULOUixQQjzaCatQh4r0+S5JOqGsm8qaEv4YZAqkAuDqjVFjRMNnCHXwEov+dUMtTSmYCl0sI90cou7IEUCAV/R0y3XGV1jaofJ4syI6GKB1voNEYjkZHbKIPyB1ewllYyheZ4b5VMTLEYxPQjmionkucHJZ/vkJ0PTQm7UOYZcG9g4dTIy01GLGyFc2K/1X4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(376002)(346002)(136003)(366004)(451199021)(478600001)(41300700001)(6486002)(4326008)(66556008)(66476007)(8676002)(8936002)(66946007)(6916009)(5660300002)(2906002)(186003)(83380400001)(2616005)(316002)(6666004)(38100700002)(86362001)(6512007)(7416002)(36756003)(6506007)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dbhldYBIydpfK/xSkl1Rluy+wwGX5Br7Kq9KpJQ2kjAS0ulCVl+wReHHxFey?=
 =?us-ascii?Q?+Jmkc5cXO1zuympuKYUVkieIzN1pPZuNalYR15ZtGsdPu3BmLoxW8WUSqbAv?=
 =?us-ascii?Q?Rq7MxoGIWyDi/h0qvVZXlgNyb47gdiUnc0XA0SyG6oLk/GSeAE4y1F82WOGC?=
 =?us-ascii?Q?8u3Qwrvmu7yuJfEAlcxC37WBgz4d5G32H5/arMgu9UuDE9x9wkz5FWrRE+0O?=
 =?us-ascii?Q?/z5xwLKBB2mCranWIZv9oI96F1AJdzuVs+tnG73fYnRyawAlSi2678tve6Gn?=
 =?us-ascii?Q?0sI+o2gU1HmaR2T0MUmWeSOv9a8Z62GxYAhwPHtYXaAfLQVsNIgFViCLu5KT?=
 =?us-ascii?Q?EkhTOhr8sxr9ugt7KtkjabS52uDwbnoY1OLTrk2IFqsFYYxQcTGYaFULv4ev?=
 =?us-ascii?Q?X/ogoPfpwMQJB7PFM3R1cioO1BWqWNF0PUTbCFOpTg/iTfQS252zE0dTVgnG?=
 =?us-ascii?Q?hL/H6uBbQROtQikrlLq9XRp8F6Iumy7E012Js7slwby18yqcotXpNHa9DfLY?=
 =?us-ascii?Q?h70TNx+QDgg5BvFbo/aP2ZBt9XpuhpLv4i9vl8yxr+q8At9HBuGqE7cJdbO3?=
 =?us-ascii?Q?hrYvrHB9v5gprKLPRI4gBK0f+gssAYWRx6A7OTmJ5dxxoP81soI3oU7vDIGb?=
 =?us-ascii?Q?TSmQ4XgOcdIcOJuwKoPQgWHXevc0TNKz4M4rcqN/DvVgZ37bGv0gcy0eNQq7?=
 =?us-ascii?Q?zhgkKTE9tUgVKMFJjUlb1pZogrNBdpaL526GMoYTdEkKuhdEs2B2xOqixcoo?=
 =?us-ascii?Q?156YrIEy9qxFtmDdfIEUxb/geH/SSz8adbCGX/73FlxRr1V1aELxs7VwyAmv?=
 =?us-ascii?Q?WAaDrF5gUU7xudeBkBZhuUaV0P5sSCuWhXydXegx+C8ELq6XnF0im+z3Spdw?=
 =?us-ascii?Q?54mkpaVbPmISyOuY51kDGi6Fcw8fjtuCaqz/cxCVzrnmGW9huZvlmlKAYzMj?=
 =?us-ascii?Q?zLFCCMJGYht/VJAVAhgm1Z2TwEVE5vRW2NrBzaRmjTIAUYgitrXRcwDSxDdt?=
 =?us-ascii?Q?IeGS5ODZUk9mUi78WJgH94QlLfqoJoem9MY9SBa08AXndLYSbbjdt4nuKms9?=
 =?us-ascii?Q?tPHopK84Ukz0IEU7/2yxrLrQkGHIQUDYX6umzdJwb2e4k7Tx1qNhl0virIaN?=
 =?us-ascii?Q?nlCtcmpr9U5ki+fhA9MK11KkWeoKTKWJWTCpIIjUhga/AuUAtVBFexQnW0GW?=
 =?us-ascii?Q?+xnYLZ4JoL4pO3UGuXyDD3NVrlJ0Lyjm5c0chuD7wbec8tzzZ002AuTtzgmh?=
 =?us-ascii?Q?+o/9NnGawE2zwk35WkFP4v91aj/phOI/wH2eIMm9LLUkYgqikqWjrLjDfhfH?=
 =?us-ascii?Q?b3jkDKFqaLScYeGAV57FjrUvsJ4e1UtSkUS7/Fjvcxhb6h92x6BZEZzmUzq/?=
 =?us-ascii?Q?IxpH3Ks4AeJTzleiq5DahS/m3DmSeViY9G54zfyPE1VypfExOzRcTBo6r5hf?=
 =?us-ascii?Q?HVRO+kgWRi2WlkX1iNrKRL2jtkSpYC1FzWB+D9b5qOK0NlhowLYl+TOCBVjh?=
 =?us-ascii?Q?d0uawhTxGvtlAI3N4acv+yD0rnv5RLne/NXR7jQa2eKBV7xErPy9LEHgnQEz?=
 =?us-ascii?Q?462ucxyNubgOBALjHollJiS4XlGsCCP0NpFZzyl7hVa1tl7HbkNoHugCL4uZ?=
 =?us-ascii?Q?5tmtqfP7UG037ORaebdjtwH2PtvkTSUVFG7+jRWVuXHdOYkRneqWO6pX6xjU?=
 =?us-ascii?Q?P+ty6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5290033-ccbb-49f5-010b-08db5eb22ab4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 12:59:11.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ppney/tHzl+Nwimtmew19D0jpSJjg1wErtmpVn0llfodNViLDsyfAqE5sX5qZyYWrYlRWRN0luPgZQn2ALH6iAIxxIJyKkSf4IOnyEuSUXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5676
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 02:16:48PM -0400, Sungwoo Kim wrote:
> >    net/bluetooth/l2cap_sock.c: In function 'l2cap_sock_release':
> > >> net/bluetooth/l2cap_sock.c:1418:9: error: implicit declaration of function 'l2cap_sock_cleanup_listen'; did you mean 'l2cap_sock_listen'? [-Werror=implicit-function-declaration]
> 
> Fix this error
> 
> >     1418 |         l2cap_sock_cleanup_listen(sk);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >          |         l2cap_sock_listen
> >    net/bluetooth/l2cap_sock.c: At top level:
> > >> net/bluetooth/l2cap_sock.c:1436:13: warning: conflicting types for 'l2cap_sock_cleanup_listen'; have 'void(struct sock *)'
> >     1436 | static void l2cap_sock_cleanup_listen(struct sock *parent)
> >          |             ^~~~~~~~~~~~~~~~~~~~~~~~~
> > >> net/bluetooth/l2cap_sock.c:1436:13: error: static declaration of 'l2cap_sock_cleanup_listen' follows non-static declaration
> >    net/bluetooth/l2cap_sock.c:1418:9: note: previous implicit declaration of 'l2cap_sock_cleanup_listen' with type 'void(struct sock *)'
> >     1418 |         l2cap_sock_cleanup_listen(sk);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    cc1: some warnings being treated as errors
> 
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>

Hi,

I am confused about why this error occurs.
In bluetooth-next [1] I see that l2cap_sock_cleanup_listen() is defined
on line  1435 of l2cap_sock.c. And then used on line 1574.
So there should be no need for a forward declaration.

[1] a088d769ef3a ("Bluetooth: L2CAP: Fix use-after-free")

> ---
>  net/bluetooth/l2cap_sock.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index eebe25610..3818e11a8 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -46,6 +46,7 @@ static const struct proto_ops l2cap_sock_ops;
>  static void l2cap_sock_init(struct sock *sk, struct sock *parent);
>  static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
>  				     int proto, gfp_t prio, int kern);
> +static void l2cap_sock_cleanup_listen(struct sock *parent);
>  
>  bool l2cap_is_socket(struct socket *sock)
>  {
> @@ -1414,7 +1415,8 @@ static int l2cap_sock_release(struct socket *sock)
>  
>  	if (!sk)
>  		return 0;
> -
> +		

nit: The white-space on the line above was correct (no white-space)
     Now there are trailing tabs.

> +	l2cap_sock_cleanup_listen(sk);

This change may match the patch subject
but seems unrelated to the patch description.

>  	bt_sock_unlink(&l2cap_sk_list, sk);
>  
>  	err = l2cap_sock_shutdown(sock, SHUT_RDWR);
> -- 
> 2.34.1
> 
> 

