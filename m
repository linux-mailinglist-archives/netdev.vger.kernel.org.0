Return-Path: <netdev+bounces-7534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E65720921
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAA6281A9A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1171DDC8;
	Fri,  2 Jun 2023 18:28:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38993156D2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:28:16 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C62197;
	Fri,  2 Jun 2023 11:28:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNOhLa38WeIs7I5b/a2gMUqR4lEFQEkWSssLRl9rJUapANu62G8jX3xNb99n7chWwkFXqQSx9FUGCuw/vXfLb9zeY9w6VB+O1yM/R273J2EH5TsrmQwLaxabDIStgwMcxcoawUX+Elk/wAVtPLPkMqesmsvEI+O23OIVZnVhzWy0Z4ryYPouCjitrnRHLKoaCU/u9jVukAlaJlF6u7VJsgSOxBs8kODe32TAWo8bXLjK/blJT5uLKweu2YV37MeEOqFgnjGftCu8qymwmMlKBVQZd8TwLNSjSwAMzOgtzZSJx78DxmvyCOVARSmdFjj513HTFg10v9ncTuoy3Moc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/omFGMbUSAIXptHSojkDa6eVe8NeEKnMmxvTjQiE8W4=;
 b=odxMEaEu72yneimRUmdPFvi3oC4I0c3edyBBwHbTFvBym68KyzW75f1SX0LolqXN80brt/u8atBcGUQ3FCe4M0ZWbY4VSY8SdoYl0Hha9gGMNNr168chnZ4nLaaqRyxNV7qQkGp13rkowgyQvkMo1Rg7oOWPZi4icZ8/aYf2jCe5g2jNpfecfmVTAZRtThY7NsbnJX+GyXWLuWBQ5Ok0Vr+hcPxpqugQuNYFyYOid/Mh2zwyA4mc3XAfIXGMe6INMYjnPW0FF2MiUea9alRNRaLzp9+EljbJyz83fB+o2sQf/23+/aB+SWZbMGA70KsIFT+/ObxRx7HpBtPniDFu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/omFGMbUSAIXptHSojkDa6eVe8NeEKnMmxvTjQiE8W4=;
 b=onaUw3XJU/PUH23w26XsLjso4VorokJaZWFeiLAmgVSvtwL+HEyhMkSMwiL4q2k0ovMku0srlsuEDSsadRUkV5+jQJXZCBh65BXCreUAUTJQgjdY1n9K8KLoWGyuaybXwAuwI63vMBGBf95CDUCqyQ3qR0XY3ichvtQDQXrjvkI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6229.namprd13.prod.outlook.com (2603:10b6:806:2fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Fri, 2 Jun
 2023 18:28:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 18:28:04 +0000
Date: Fri, 2 Jun 2023 20:27:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH net-next v3 03/11] tls/sw: Use zero-length sendmsg()
 without MSG_MORE to flush
Message-ID: <ZHo0rNlhJCRE4msb@corigine.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
 <20230602150752.1306532-4-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602150752.1306532-4-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR03CA0029.eurprd03.prod.outlook.com
 (2603:10a6:208:14::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df24a4c-9294-449c-1c80-08db63971aa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0pccWMTGMPIoMQq1OSRwiZcyts5oez+ixC7ok/dMOQFPUImmlXJ1NNVIhLx5GF0yWKhgM2eumBMRmM/V3MmN1lQ9LjmgnZCBwBKiVUVaZkbuToqY5dtIhNIXQu/CUpw3R31BhxZtxbWwg85Sac2r8a0BDXzNbcUQ80BLd4dtQi9Oq7ioMyhq4ZeqXpQnsVolNKr6aQInK8mDBdvVEcalzc9Arc7U4zd4qa3Iin2zYiZyFtEt7qtBG46JfR7q3bR6R3J+5lD7m4d1RnGneoW+FF8uRCOsR8+laSYKBcB3OIhAceqZePF4ZlbAUPDd5Qj6+0qzqn6Cpflitov2Z/4n2NK7gZBoXaRMwEPYyBrndQmxPnivOTuQxrsuMoxtQs4Log0zHT/95HkE21q/Fi+CGvdfNjEaOFHSJQSjiBxp8FPJ9F8nMCV8ZI15Jx14+uDuPq6nOUhWyAc34nMfXpyessUCzFXDhoCpUXjGQCZLAIHmiWj1G63IwAeo1kG50Uzo/PrwoQ2+2yVqxPD6GlGtdk25fSdaXnR5CiS75u8WTXAvRgubIm6pOOhwUTxWiXqVjIhVk1gWMAitIR96oHd+ua2aK6gzarvuWecE2cqJwRM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(136003)(346002)(376002)(366004)(451199021)(38100700002)(2616005)(66476007)(83380400001)(66556008)(66946007)(478600001)(6916009)(54906003)(86362001)(4326008)(2906002)(6666004)(6512007)(26005)(186003)(316002)(6506007)(6486002)(41300700001)(7416002)(5660300002)(8936002)(8676002)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1qC7WuyXtUe7VX0dKFMwJ/RlaStJOW+6C1cwIKWIHi4ogUdZp4LoELlNQH+M?=
 =?us-ascii?Q?qgXx/FxLk7wrU6LXMALpar78aufHzYF0PlRCgKGIEzX0fTrwV1F4Y/2zblDa?=
 =?us-ascii?Q?BhZxmJ9jE7O99zT/4t7rSAQTAy//+eaCjYPsIQbMIZxn/FfnahuhJLgLip8Z?=
 =?us-ascii?Q?MofzOt2Qd4EZS1jkKBw2GnbFQcnxXO4kyilEqVjE207BIGhcmwnmYky84HNU?=
 =?us-ascii?Q?kuvvyMpoWUGwUcLDVDv5ZxqyqxxGshn/Yfj96LUoXTw0Bg62kLCtIkvfqiDp?=
 =?us-ascii?Q?Fw7sRO77qvlEjaacdu5NEN8+1/1Ft3h4sZnX6JWdX9hnmdiAX05X1BMgPCuw?=
 =?us-ascii?Q?vtbAioaBknu9izwWDyU4J+wbhXRz8KWmvRArUuY3kIj6+D7znrcwKPm7vK0+?=
 =?us-ascii?Q?w3VkmvS8wIC6COInAoeDroeUIVF09YHnR9fA+AR0/UTFLfUPwRw6OHoZFzfb?=
 =?us-ascii?Q?qjPC4lhigC1V3C9+p3qmijzYH393BBXnQUDUeiapVg/QZ54oUu6LxqGVlYpF?=
 =?us-ascii?Q?6wPygv0wnyG6fORG8LNfl0Qp5iIvnUknPDvhCTBEFyFqwOq3Pd4acb/D4Xyj?=
 =?us-ascii?Q?tr2K6Oi5lI/KAXsoAqOtd65OlQnH5+UKROYXe86KfwBKlcrne64uxJNJVF5E?=
 =?us-ascii?Q?M1pSW3kC2WBbUvtY5NfLBOgci4vJrlHhd1TSh4IYKlnWTWaZ0/QJOVcCwTYA?=
 =?us-ascii?Q?Gj8JsWsYebm+lg80pugMluQ1ghYuaq9D5ehqGY4PSag8c24dUtnuiMdikSSx?=
 =?us-ascii?Q?USjBg6Yj6GxG+XxZlLMMf/CpnL4zA/Jem+qYVUXglySsvKIbb3+KCgwNBFKm?=
 =?us-ascii?Q?zUAJXHu3le5vFv7YVijr2dTlFoWnRgzq0ElJtjPcwMrTYfnH0yXRMV7LynDE?=
 =?us-ascii?Q?0FMm2FJU/WoQeJbIQ43jIEtweWzxpdEEiM3YwbBecE8j/4Cv1e1D3pSGFIgB?=
 =?us-ascii?Q?v5NJ8qThNQidVl4E8+9gNMlG4B+LNRayoDohBZKiv6D53Ds/kJm8uY28WvBA?=
 =?us-ascii?Q?UlIe9DfwqnSZEipaPVlwAJeN0t/rmAydJDsgv99SiXVprRRtI/pPLY6uyygs?=
 =?us-ascii?Q?WaF/3K20ZFXuNNw/qaKywaRhvphpGSr5qaleKkvJl13RUnziRx7oxJxRbnp1?=
 =?us-ascii?Q?+MGaFLArMtmmN/yDhzrpg5ucnZedG4vrZjpQJSUZv6OzJHtszL7B/jIH4JvY?=
 =?us-ascii?Q?i6Rriq6dXjz5oax/cJmhCIGdY+McqwNdZEy7fb8bveW76GlPpidO5awCCIZK?=
 =?us-ascii?Q?HzPDvqJxgH6n7LlEUWVvAehtC2YgxuaM19fB2jMTKpl8Coe4arIIPPNQnucw?=
 =?us-ascii?Q?qBRPwTrZLfHDBNmEanwQlBo/Cfvs9e6pne+jNs7QRqmN9NOsWfva7z3kyv0S?=
 =?us-ascii?Q?N/D9Ccem5EL0CjrllxsiriMTrQ1PmCwXrk1lDFTaYztC3x75uv+SjHJehrfk?=
 =?us-ascii?Q?eI1SOfgZgVpR13kUirNIkTOIXQaPq9+sNoOcqqqDqrACjGYE+QtMmS4PwMxd?=
 =?us-ascii?Q?L+ZhcilAREpkiE44QLfRiuKMUnE9Ks+WxlewN1XDJ+qUGbhQDHeuCtH7lEfI?=
 =?us-ascii?Q?fhE6mbdvRsW2mO/ZshORYynY7eAASNeAfOOqiBCeJope1u8nGPLokD7MfdM7?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df24a4c-9294-449c-1c80-08db63971aa4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 18:28:04.5948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xVjArJE5raITSxEdKBC7Zqz01UqXjzdyszhemFYwW7xl6kPqwpR2d4m4xsMRYNURw5Y+gzrARhQyZF72VyD1sVZMaMHqQSz3lNgnZsz/2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6229
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ dan Carpenter

On Fri, Jun 02, 2023 at 04:07:44PM +0100, David Howells wrote:
> Allow userspace to end a TLS record without supplying any data by calling
> send()/sendto()/sendmsg() with no data and no MSG_MORE flag.  This can be
> used to flush a previous send/splice that had MSG_MORE or SPLICE_F_MORE set
> or a sendfile() that was incomplete.
> 
> Without this, a zero-length send to tls-sw is just ignored.  I think
> tls-device will do the right thing without modification.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Chuck Lever <chuck.lever@oracle.com>
> cc: Boris Pismenny <borisp@nvidia.com>
> cc: John Fastabend <john.fastabend@gmail.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  net/tls/tls_sw.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index cac1adc968e8..6aa6d17888f5 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -945,7 +945,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  	struct tls_rec *rec;
>  	int required_size;
>  	int num_async = 0;
> -	bool full_record;
> +	bool full_record = false;
>  	int record_room;
>  	int num_zc = 0;
>  	int orig_size;
> @@ -971,6 +971,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		}
>  	}
>  
> +	if (!msg_data_left(msg) && eor)
> +		goto just_flush;
> +

Hi David,

the flow of this function is not entirely simple, so it is not easy for me
to manually verify this. But in combination gcc-12 -Wmaybe-uninitialized
and Smatch report that the following may be used uninitialised as a result
of this change:

 * msg_pl
 * orig_size
 * msg_en
 * required_size
 * try_to_copy

>  	while (msg_data_left(msg)) {
>  		if (sk->sk_err) {
>  			ret = -sk->sk_err;
> @@ -1082,6 +1085,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		 */
>  		tls_ctx->pending_open_record_frags = true;
>  		copied += try_to_copy;
> +just_flush:
>  		if (full_record || eor) {
>  			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
>  						  record_type, &copied,
> 
> 

