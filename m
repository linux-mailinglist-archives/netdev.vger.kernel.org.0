Return-Path: <netdev+bounces-11739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A5373418F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 16:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C19428173F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16DE947F;
	Sat, 17 Jun 2023 14:08:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCAC1117
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 14:08:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2134.outbound.protection.outlook.com [40.107.92.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD01F173D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:08:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSmwx/kRep2ccUDS8oHnSMmMp8oMf3V+f90iX7w4+I5x0Ni5plR7jR1z16MUBCC8lSeAs/zxtq5YkvTRb5/EXSMpHgC7OwdPk0kQXPK9Xpe8UtgsQ/SfA9P2qMvJRYbhWrFDX5Uz1XWwpByifk9doKTfZ9JdUkBZVfIdA3mJX4R/0JHnBdo2hFDT35tnwU53QFTSTU5D+Mw4da15SLjXXwuH56qR5CbVJc3Prd7AYsAiCkuUifufiipHY3fmAUMJU0Y+8rqinlGG/JJ/rjQvWYic5WIy10kazSo7dIO6uNVO/yHjbuJABelVwPJSUfIIAzewHxad14226XAqYOgB7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLH3SSicidlqcIL0qwcbZSViF1QjaMK8TrAfbYa3exI=;
 b=fw8kXBHUuPJNmCLMXDSSD47UGlzpzy6RMD6yat2szX7mn8BcoloLNZuT8t0+7P90UmOFaEBwPK6Gcc/I2aFV5K4biy+AwoE/7Amj8q6t/4brFJey2ijBY7sD3GrpMHMdZ5cXCATKzdS3DhxyEmUlPD1XCKcCC4giBefXvdXC0W4JPAtLyS8bvjeF7Hy0xWjh3FdKYkRVQIb7WVYSmmhWNaCrrLwrS1acoL6eFN+GoSWZJGNxq3tLh7Faiec6WRwjIF8mq07QKuGldNTJli9/G370Zvn+W4+g6zDZlR8k8FYym8xSxEwPxvptuGIZPqHvQIXVfgw0l8go2ohmpTztQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLH3SSicidlqcIL0qwcbZSViF1QjaMK8TrAfbYa3exI=;
 b=QrmH49rGMeYgI51o66ycbJse5ODVPcOEfkVlHMUteEqX75Qwz7aqicDsvTU9ocM5rKXMNpxOjnpdNLPj0wTPxQzGfH/1uMYXlzqGDyxlpBfnhPpulW3PXNR5d68KO4zK2YwfE6dBY9D/knyk4mKpuGAX20YElAXg4biiva8gezg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4583.namprd13.prod.outlook.com (2603:10b6:408:12f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Sat, 17 Jun
 2023 14:08:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.031; Sat, 17 Jun 2023
 14:08:14 +0000
Date: Sat, 17 Jun 2023 16:08:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Boris Pismenny <boris.pismenny@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 4/4] net/tls: implement ->read_sock()
Message-ID: <ZI2+SDzKwK7i8Nw6@corigine.com>
References: <20230614062212.73288-1-hare@suse.de>
 <20230614062212.73288-5-hare@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614062212.73288-5-hare@suse.de>
X-ClientProxiedBy: AM0PR01CA0079.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4583:EE_
X-MS-Office365-Filtering-Correlation-Id: 758b7d36-3e23-4a0e-b472-08db6f3c4a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cA+zv3qr1cAvc3qg5+Na3NyDK5mkMvojZGKAxKaNfsS46FwivnELRZoiguxZaIFcpfHSiNKxU8pZLTbM99jRYR8ymzlaDTNjvcHaHfJ7CYxYpdMmA9B7UPIZIGefExCvUG+8r1LtvEH46g5rki6Vjsw15lkeq0yF/rDaMEcA7yjsVh/v02g0Kri2NzKhZ6tb57WfNcYXgh7YYVOCdnFCt/d0SOq+bOJAQ7mUaDY94bLT6LtWUsh1muegraQxLMdoDHV3wu2oYuIYffZXFWKqYaRb39O4XySOBKkd8le+/HPze+PCBv6L5y1n4wIYgJdmpCXF1xChYgIEXvUZuQWeOKKPoJG7ue+sjNoQ7ScWIpoU9v4A+sayakoE4T1cyPIyjp+WOFre76EHcLJU54ABpko+2YqcRPwybz1pijz/tCgw3SaeonG+7AOLz5MvpFu25oZHlJUmn2FL0UAehGdCbjSIvnSAtbKf4fNa/6aT0GJGaUWWlrRd8Pvhv5v074utmKGEME1vialCc/vnsrXA/GXLGzT0uql6C/QVpt2Jatvk5vnVry5wAiSDioLOO+StyGAI+eX4VyNi1FQhJNtOrBJKG/Anr3GwhAxRUz3w9SztJKjYjE7Qgx6+YCfgdEMZv7hn5FGTawTtP6G7D1a7xxq3CYv0XIQV1KkoqrqAPnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39830400003)(396003)(136003)(376002)(451199021)(478600001)(66556008)(66476007)(6916009)(66946007)(4326008)(36756003)(6666004)(54906003)(316002)(86362001)(83380400001)(6506007)(6512007)(186003)(2616005)(6486002)(38100700002)(8936002)(8676002)(41300700001)(5660300002)(2906002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4TYTL7NlZ7CxF6kJQ360r7aKdPLQ/1WYA5ZF7DRkOcj+nPaf3wdH11Fu+6ju?=
 =?us-ascii?Q?iCtwATQPKBxZqKmXyk8kZ6TMY6DrcfAg0Jy09ZIlcRoTnIUVwt/HoUTjXcGO?=
 =?us-ascii?Q?n7zXkZdUsfxKLARyiX04JwPaNQWyvWywypRZL19y3GXBYf4jnyjJ9xXI5tgP?=
 =?us-ascii?Q?6yJGEwOp7B4yYzyJv6PHb6HBQpU6mnb+pLRd9MY+Z5g5NdtFECzw3m/RiU+H?=
 =?us-ascii?Q?p9yv3W9efN061ZtuGowCNPk5+Eo82XXMz6FUM5oxSVXToL8ZOfX6Zjg/5/iK?=
 =?us-ascii?Q?Deh4kRzYqh3EcSv+5NYsbKA4qptLHb2QIZ01F+g0K1UMpcRpQqfjoWOkBr0t?=
 =?us-ascii?Q?7mk6honkNNMAZ/dKiMVtP+aNsXOC2W8izoHmNN5CChnlSMe/mutsAYv1FKii?=
 =?us-ascii?Q?NUfg+jY+PG8STWJWtpJztjxoc5du9StppKlrnRBvW6jfdjFAkqJTqB6XhlwG?=
 =?us-ascii?Q?PxYkwzA4IvKujEvE0dm+FAQ3l4EhNls2SUF29O+mg2IfWMk5x8wawA4zcb17?=
 =?us-ascii?Q?Yg8sAoq3zWI+RYfNRh3ahW3GyRiY6uNLqm+os5IZKWQa3QRx0Az8L7XrrycU?=
 =?us-ascii?Q?gh2tUFaVPzL4lT937WByJJvYWlU4BVYwlDuTnMveedAkHKegD+uTe+RNlhRN?=
 =?us-ascii?Q?fcW9+KluhfmiKvsFqVOuZCs7Qp+3Ts5XnhZTM3Et6ifbikwAboDoMlaXPmoU?=
 =?us-ascii?Q?1Hn0uK/yUZCiL85S8BJT4fDXYAmlDkfVqe9fkoYIwF/V+ZFMJ0LdaR0B90b2?=
 =?us-ascii?Q?xvqcUUZhU/hQeRYjpyIMq/cgDyvtC93gDxBwpq45xnyqZBjE5Y7RYnVpQ5O9?=
 =?us-ascii?Q?VmCzEocusO7aGrSGMLOXPYUXxWuNg0hO6vv4vG+P9afCwHiYigE5T7Z8WKU6?=
 =?us-ascii?Q?mRiaJehEKj8hPhWDkLe8PnQDxCotIyEn44SV+oKw3ixzJfjR59fLO/yJxdTS?=
 =?us-ascii?Q?MKWF6d+pHPHU4X/HihJnFsJ1YJPTjo+2qywTHTQD47ekQD3evVxuizhQe5f0?=
 =?us-ascii?Q?uueUgfWrGjjKSmx4Rc9rZXXi6e7xYdA0XCieiS6vAwCl+nJVFSHReLUOwuZu?=
 =?us-ascii?Q?f4M5ZbHW4gyZ4DrB1Yn/7g1vXOpXbJq2Xwe8xMi6mD7IrGRQuMR6Bf86t1Um?=
 =?us-ascii?Q?MWevhO+dd5J2XN/MKkJoFjvXFByBFdaWNm3mPDvExy8WI0GVEKUwshktDni2?=
 =?us-ascii?Q?lka/OgbK3MMVGHL/+gsGqo8XW0wcHCLZOwReNUiRxDbsluQdSW6SMO/H2qjk?=
 =?us-ascii?Q?7EYI7ZE+Uet6gCZ5h/Jvu2zN97201eGNjBSImOOQ3T4F8e2gmp+0XKfYeHNO?=
 =?us-ascii?Q?rzCcdsX8nDJFKO4vR2+tl4ZzfVUDMkK0ZiW2+jMPcHvdXGhWPU5D7S/zrZ4t?=
 =?us-ascii?Q?9CoGbgI0gZNNWH7vXxFuy/9yZZP4qZwSPuXjQAdD+zgUEVab11sHbIya/3JL?=
 =?us-ascii?Q?xIUDbVNp1+Rn8lPWokEjC0qZIk5Ly8ozHXuNyC6q19lN6AU3KbODHQnCq8Hz?=
 =?us-ascii?Q?rBgoEVmY2JIq31Aw0zlOpCkyiA9rvhyMDWSgFIf9PHjnVQuFugpS8jdOBDhU?=
 =?us-ascii?Q?9yOdcssfybWgczPuCA+OOR+pw3RvK/mNO0T45/J97zgT/F9eqNnV+g5ZC0eB?=
 =?us-ascii?Q?KPVccqrNJRj+GnYiH/goV/FTlfNrSb8wKCF7YTM7zwLkVYMJY+eYtSY4vStD?=
 =?us-ascii?Q?w6dU6A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758b7d36-3e23-4a0e-b472-08db6f3c4a64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2023 14:08:14.2868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nCSO4lPo0jM5WRdio78iTWwpl//xMWyo693KS0a6aJ4hPW0eSdFk/y8XlT5KExfH4IYlmiuhiWehWkyJMbe01tUiFDaj7eJ1vu/7svr1XI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4583
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ Dan Carpenter

On Wed, Jun 14, 2023 at 08:22:12AM +0200, Hannes Reinecke wrote:

...

> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 47eeff4d7d10..f0e0a0afb8c9 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2231,6 +2231,77 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>  	goto splice_read_end;
>  }
>  
> +int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		     sk_read_actor_t read_actor)
> +{
> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
> +	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> +	struct strp_msg *rxm = NULL;
> +	struct tls_msg *tlm;
> +	struct sk_buff *skb;
> +	ssize_t copied = 0;
> +	int err, used;
> +
> +	if (!skb_queue_empty(&ctx->rx_list)) {
> +		skb = __skb_dequeue(&ctx->rx_list);
> +	} else {
> +		struct tls_decrypt_arg darg;
> +
> +		err = tls_rx_rec_wait(sk, NULL, true, true);
> +		if (err <= 0)
> +			return err;
> +
> +		memset(&darg.inargs, 0, sizeof(darg.inargs));
> +
> +		err = tls_rx_one_record(sk, NULL, &darg);
> +		if (err < 0) {
> +			tls_err_abort(sk, -EBADMSG);
> +			return err;
> +		}
> +
> +		tls_rx_rec_done(ctx);
> +		skb = darg.skb;
> +	}
> +
> +	do {
> +		rxm = strp_msg(skb);
> +		tlm = tls_msg(skb);
> +
> +		/* read_sock does not support reading control messages */
> +		if (tlm->control != TLS_RECORD_TYPE_DATA) {
> +			err = -EINVAL;
> +			goto read_sock_requeue;
> +		}
> +
> +		used = read_actor(desc, skb, rxm->offset, rxm->full_len);
> +		if (used <= 0) {
> +			err = used;
> +			goto read_sock_end;
> +		}
> +
> +		copied += used;
> +		if (used < rxm->full_len) {
> +			rxm->offset += used;
> +			rxm->full_len -= used;
> +			if (!desc->count)
> +				goto read_sock_requeue;
> +		} else {
> +			consume_skb(skb);
> +			if (desc->count && !skb_queue_empty(&ctx->rx_list))
> +				skb = __skb_dequeue(&ctx->rx_list);
> +			else
> +				skb = NULL;
> +		}
> +	} while (skb);
> +
> +read_sock_end:
> +	return copied ? : err;

Hi Hannes,

I'm of two minds about raising this or not, but in any case here I am
doing so.

Both gcc-12 [-Wmaybe-uninitialized] and Smatch warn that err may be
used uninitialised on the line above.

My own analysis is that it cannot occur: I think it is always the case
that either copied is non-zero or err is initialised. But still
the warning is there. And in future it may create noise that may
crowds out real problems.

It also seems to imply that the path is somewhat complex,
and hard to analyse: certainly it took my small brain a while.

So I do wonder if there is a value in ensuring err is always set to
something appropriate, perhaps set to -EINVAL above the do loop.

I guess that in the end I decided it was best to put this thinking in the
open. And let you decide.

> +
> +read_sock_requeue:
> +	__skb_queue_head(&ctx->rx_list, skb);
> +	goto read_sock_end;
> +}
> +
>  bool tls_sw_sock_is_readable(struct sock *sk)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(sk);
> -- 
> 2.35.3
> 
> 

