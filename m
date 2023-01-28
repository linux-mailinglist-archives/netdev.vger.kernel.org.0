Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919B767F99B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjA1QkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjA1QkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:40:20 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3000FEB56;
        Sat, 28 Jan 2023 08:40:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPGqAzRFa+ow9q8pJHRDKlkpjbMfMQY3apDI+3PT4vn4yxhNdbe7SQqd1cPMu9uwJ0ei5MhppLCzK7prtnhy3Hjls6DJovE//W/Zn33aPVT8GYSKxUaGAV2TjVpebA+mxZTHgUpzEK9TlAPXDRBEiY1Mk9LgipC3132L1PET5Pk/JoBER8cSh2Vt5vYfCqe21AniLSW+xzgP172S6Yo1T5OD2GSOcya8beYjEmhZC9en8R9QdTf1zf4YjtX2SbHfthIwLO3k1ZrSqbea3jILzr3MgoJZZbIna3UyXti744gQLRqVAbWDuVfuIVTqEK3byAjVRmbFGenviDAiVxalPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFqgFyLisrSKcT8mGFa0rC2dDYzCl1GzuUq+OfXHmWM=;
 b=ce93HItgZ/k5y/XQcVGF9z1ZMRtsbLjKMQBbCHABp1RHoOB8v6ONhe0sEzdOunoEBit6v7dpU+iWrWwQwkiHNo03vpA/UETMnEpZFJ31MhevFVsiGlCayL85CNzLG68rx4bam687RmCLp/x/1ysxErvANb0aZRqKTYVB736uqAkbLqR6NUKv41sWl8GUlZxX7yPjFQxefWQyYhP8Xw7SD0V0v3N8YfQDxmXdHVy0W5gDV7lv5f06juFEhn6tH+mQT1UaV9yga57Uwz+qV/4knV/n/f1JrDYxDKbN0yS3n10IhkLcVr0zHfwhCFia+dpVMPypDPNclZ2llPa44FAF3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFqgFyLisrSKcT8mGFa0rC2dDYzCl1GzuUq+OfXHmWM=;
 b=SoXixXaC9eS+HFFxYgx9/OkhvNJQ06vN3/F7lxJaN0x0bzJRDgPwhlpR+02YMsezmIr7rrn7zXXazU4CPpLOfA8t6+1Ub1raBZmPx2q7/nTEghwkEHzVVbmaPJ1K3OILyMvpS6FcBUZmdLjbio6yZBfCtbh2ep7MBSDFTOXhWcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4937.namprd13.prod.outlook.com (2603:10b6:510:79::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Sat, 28 Jan
 2023 16:40:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:40:15 +0000
Date:   Sat, 28 Jan 2023 17:40:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/tls: tls_is_tx_ready() checked list_entry
Message-ID: <Y9VP6Hw7jH0VelUX@corigine.com>
References: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c9ddbe5-fd0a-4a2b-9dbd-08db014e555e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gskjjbi8UtzN5SMKbIQDMbp2HH3XKEYaMv3OCtbg318vvjpxhdY4iCQo3WXJt9ZUgR+7xVskzV3/bTXzNv9W9kbaoWZPMa1rBjI8beqpbNYTh7kJ+Sbc06/0I04lvM74cPWk0xcmQ/qI5CM/FyLNnKecX7xEA3UlTbdFFyRI8AGUg66Xn9rWgFBjsrPku8LNSk203cSq1giXhFwAdUbT+tPSsbq7PwaYtmE9fdgRuhKozowZlfEKFialLtq+5+YI/ShQqrWKX+Vt9RRSXsIumkl4U6IEUC0Rsch1NjUmpr4L6HUwWpBZd3thzX8h/oVfWaikBPkriyNFDOWiykQ5+SjvkJiMCF5i4x8qgO8Zg58zowVZHxkQuJZ/ef1vwoju9FTGfyb8FEiHDVRxrMEpVSMETx/OLQy0RfaonBjpSPXHnqqLP47OEs1YUwgVjhfxull61XDZ0P6VynshLERdt9djw7E+aVuEbCMvMyzjy00KDuXUqev49uy9AvysKb+0mO5froC9wSxktZDBULqSU5R9OuK02RBvD6ufqVSEj+nOSRi7kUeszfeP99f9/snFZ3EVPHFD2FNy+zPDWICkRzuMCGbgClRIo6B08FJYTckZqggtTNh+SMH4NcRiaQF/m4ojUA4IO1HF8Ym3Z2yUSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(376002)(346002)(136003)(396003)(451199018)(8936002)(316002)(6506007)(86362001)(478600001)(6666004)(38100700002)(6486002)(2616005)(186003)(6512007)(44832011)(36756003)(54906003)(7416002)(5660300002)(2906002)(83380400001)(66476007)(66946007)(66556008)(8676002)(6916009)(41300700001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PagqR6aa7VW2PDD34DW4VfbdUqQVpyDZAfESCw6yeKvMnOUJ8hCFn09QOsP/?=
 =?us-ascii?Q?cewWIoVwE01SsH1Ll7auYl4MVsY16ODEniRy+nd6qYlhWeJMLj0reGVP5Gho?=
 =?us-ascii?Q?DJDVWT0ymO1GLCztPGEegYDWeyCzsvKTzqbGwpgyzbioeSWZk8Q+Iu58N7hn?=
 =?us-ascii?Q?7pt2tNR09/xU87NtDvjE9VfIlRqAHiASzhE7bPvoPSYmOzW6IOWonBDmE7SO?=
 =?us-ascii?Q?4QoIzb69TOoPmsUAKNMBUKqgCCy9W0dzp9w6daXNCo52VvIVtW33fh60g9HA?=
 =?us-ascii?Q?6UZkLo/QVDh+YSvqxMvFJDEuKNy6DTbKVxH4KRGyDbDrMPvJIsVP+F+5wOaC?=
 =?us-ascii?Q?+TX2YX+4O4tEf8KX2x5altQ6I5wUpOq6i7tAWoXBngmB+Vu7eU+HCvVK7WdO?=
 =?us-ascii?Q?wjcbMa6MkSTKBp825w/ZWtoeM5kQ6h2fkiXfmPGtNvYqT7khxM8Wq2I3G51y?=
 =?us-ascii?Q?1sO3tTy1lcBY2K67I3vNEiFjkU3VPi6LE1FXPWsrubndKAnSIdGTWLJ3KJh8?=
 =?us-ascii?Q?bhLAH9/q88m5x0gz0aH6Re7DlB4UUOX3+BABE8ZSF73XF5JN832g7B9yNLP4?=
 =?us-ascii?Q?uQyfvuGxnp8VJ40vkFPkxuDKSOQK8ONYUDcrLh1ItceoDyh21AN/vk8yr5+S?=
 =?us-ascii?Q?8B08z3PBXpr8PTYXtCvrs+vNwf2iOOG0Op9OQEJSh70NlFfib+N+HMqWgek1?=
 =?us-ascii?Q?H+5zqOUokthwQxQKxPJziT09BGW7umbASbM/WTVHWFut1Zl0iWBRibUNinzO?=
 =?us-ascii?Q?Js6rLMOtzwYbTw2hblT1/cnFs3wcNkQLw4X/oC0pJCFWtskkUchq9720hsox?=
 =?us-ascii?Q?Pl1dm5nJFH7CRT1gXUtgQjIvNeQBwkjjv9b72HMGzPSnPFsj1I5p01lxdz3L?=
 =?us-ascii?Q?79WFQutp95uqtcFbthSz7el3Ydp3TBbmfOdeYhyrOKQ6s0EzNRawxlZhBDNF?=
 =?us-ascii?Q?LiZlP2QY7AvNF5WCoapfMn1KRySuzUHhlRLwjQ8RyeR4DkeqZuJRY3sxKJDY?=
 =?us-ascii?Q?OGltNG+lGKo8EtavHef6jF7qUmjWVMbp04w8TRs56B9eiZxHRFUfz+cVEK+l?=
 =?us-ascii?Q?EvSiv45z6fopXrMGvaG3m3CIV41LPHrV7FcnL4fEF4F2DZJxctU+Spxy+sUm?=
 =?us-ascii?Q?5H4Vb6GmY+2sU27TysI7psIYsRzThdu401hXVrlU+MHcPgfx/0X6P/EY48CE?=
 =?us-ascii?Q?QFIZnO2GNFd3bMju5c+hl5Md4AqLSk3QkfhloNPlmQrPAiNWDRgjbZTl71Ao?=
 =?us-ascii?Q?ZAdm2rcTxeVSVZseZsUu17TqsXz/2RStuxJcqi/qK/kmMOG+SL9wHJNDNDIA?=
 =?us-ascii?Q?XVkXhoVKOEG39A7ZWP2L+xzOFlw1cTKR4XR6GA86bufIjUHNUkThSpCOqZD6?=
 =?us-ascii?Q?8HxGgfgyUIwkwobqf8Gq5BbkMHnqy1EnkZmN1AsI+OxgMID1hENWmC/ORMll?=
 =?us-ascii?Q?qsNSR3fM81Q14NHOLhB27udys0JdbXBsqyazACmrQ5FSkcespv6+jAa8EeF/?=
 =?us-ascii?Q?BcxaqUuVsgALlKYikYmzu4h6XZQECbrYBlImuDqbhCN0GSRjMb3fmC/VpT7r?=
 =?us-ascii?Q?7FW1lp2NnVJCJmd3htuH8bMCmNFM7n1LN3kzyMfBrsadOKuVReQ0c9unj+ly?=
 =?us-ascii?Q?V+PCnxGirz55ROOftQNy768aw+xpFC4NyAGdJj6BIlAHiFNPHXDIIBElyTdW?=
 =?us-ascii?Q?jfxl0w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9ddbe5-fd0a-4a2b-9dbd-08db014e555e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:40:15.6429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJzcP+4OGBXNeyuEH2W7ZHyOQfbwU/CU3YkslMG89MKvx6hfhLS9phTDwijZ/1ByR26CcsnEp1jZsB9jaNorEeXCZU3utypr9FZg46wc4kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 04:29:17PM +0000, Pietro Borrello wrote:
> tls_is_tx_ready() checks that list_first_entry() does not return NULL.
> This condition can never happen. For empty lists, list_first_entry()
> returns the list_entry() of the head, which is a type confusion.
> Use list_first_entry_or_null() which returns NULL in case of empty
> lists.
> 
> Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
>  net/tls/tls_sw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 9ed978634125..a83d2b4275fa 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2427,7 +2427,7 @@ static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
>  {
>  	struct tls_rec *rec;
>  
> -	rec = list_first_entry(&ctx->tx_list, struct tls_rec, list);
> +	rec = list_first_entry_or_null(&ctx->tx_list, struct tls_rec, list);
>  	if (!rec)
>  		return false;

Hi Pietro,

I agree this is correct.

However, given that the code has been around for a while,
I feel it's relevant to ask if tx_list can ever be NULL.
If not, perhaps it's better to remove the error path entirely.
