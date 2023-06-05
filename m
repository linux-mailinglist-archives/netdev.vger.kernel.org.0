Return-Path: <netdev+bounces-8077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FF7722A03
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 142E8281326
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EE6200B8;
	Mon,  5 Jun 2023 14:50:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6632A10FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:50:31 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20703.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::703])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C898FF4;
	Mon,  5 Jun 2023 07:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDT4Up6us2wDQkNfH9nY9tIZbYxAmA9HlzHF4B2QlsScFXJOLf2BUmNzC2bQ0QP3LPW/cVPLQEGNbs0jeHre5mGa65kl9WxbA6NE+cCUO+XqRtpIARwQgcHEV9UhX+C/RJiNP8RrgTdKRr1Z2BkCK4++vQR0UA/5rMTX0wlaGBV8cHhGZSjb9nJEYOu21y5j50hTfIyx4EbIYzUPLs1IhNj79SEdv8yjLAC0SgHIDN35o8cDWQdrVvevkg8V3E6LbU2PhyGWb2Csjh6Jkgg5RccUI354S5y1q2m/hPaT3RhrHbQZOlg7pxnF1iosrQ1nIcYRln/Nz6TY5Z3TIUjv8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0Lqbt8ble/NChODwwCaMGvDxdiT+CRU8csEPHRvCE4=;
 b=dfrZVubqTrMtV8LvhynDyj4h/u3oMVydbUCcY/mRea+jW0i2cKx9hMJqpxHtqL3CJ11++OsBiHRWOK/7RuoNXq4/Lgy0kb8wcKIzzB+CSuodkpKaUWCyyk+XyffEUEbSRA1CwulT4tpyceKTm0JDkSGrepM1k/30NRZb6S1rqKgnP17y7oXL3de6MY/JcsuqzcCD/7WKU6CiM7tE1cheLFpPcWOVuEOAyMeDOS0d1dGq9OZgWabYsybpiJxeyuGjpzWS8qlQrYfPP49ladIi3NZtbH/sgNy4E3sWS/885Laq1qWPSqqGHS4L5C0BCvBaDr/CTnlLPKcMYe6MmYjvUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0Lqbt8ble/NChODwwCaMGvDxdiT+CRU8csEPHRvCE4=;
 b=hz7x51N4dBm09lbzvotEJdWqn804c+p22SySdFy5oX1IwopH3uWOgpkaaqwZ7mqfnSnYqZTxg0Mivo1ISyuKpFPT050nn+v4Ti2v11bZd3qhjhRHjwD58rh44Hsoc8zK/QUV6UVff69qvHEk/P7ywHoGxLi0Sox1OdwcSCTp3GY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4692.namprd13.prod.outlook.com (2603:10b6:208:324::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 14:50:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 14:50:21 +0000
Date: Mon, 5 Jun 2023 16:50:14 +0200
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
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 03/11] splice, net: Use
 sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Message-ID: <ZH32Jp1Iop8FaDtC@corigine.com>
References: <20230605124600.1722160-1-dhowells@redhat.com>
 <20230605124600.1722160-4-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605124600.1722160-4-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR03CA0098.eurprd03.prod.outlook.com
 (2603:10a6:208:69::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4692:EE_
X-MS-Office365-Filtering-Correlation-Id: 681c2313-d569-4b1f-19dc-08db65d42fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vsdtqJta2yVT93iNXAvTWciNVnRCSyRtky23T/+tqLySDVeWOD6Ejln7Psfk9ZO6ZGma3W3TKnBYP6ZFaH8BSVHhDg1ahlUo+8wU9D8uquuh8gYKas3XxZ65bQi9uUb9QGpvUdbv1QW9+s5eJb4FcolYTPEs/51xYQhSudbgAqsCNs3d8mmG81M0wrDWY9YrJGj20SHiexkdhE2//ywrwT1EexM3En1pfvi6Jih1GCz28kzILL0BhMKFbuoFDzj4F/mZABM7uzHfT5WdceFjIYQzr8b9eqxeSSua8DimaQOgip49xhNVQJeJvhfn4xnUbXPldmj7G6QOIqYwgKhfnjnssbxnpHvv82mwM2Mdm7EhGwN7fh42h5AHt3qgY7M/MBfh4RhAi3GcYRuwfEz4+5xw/9dIaZYVHvW91NpezYn7V0fm2DK7qRvL6cU4kR66MGiNCy1ctnu1ef0L3PQOrC0cD3k4Tmr/QIzwH82KSmGCUbb3Q4rE3BsXiEubCCyCK6hWMOFVeLVXfPhUViEXZw1N4/s2iNynNPNWRSqb2DuPg+T9ADD3kpfYVTtpoH+R87SgMv1KZRlaFZpcZ9/8xkoNedcWrSnhbpig41O/1Q0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(39840400004)(346002)(451199021)(83380400001)(7416002)(44832011)(54906003)(478600001)(8676002)(8936002)(41300700001)(316002)(66476007)(66946007)(66556008)(5660300002)(38100700002)(6916009)(86362001)(4326008)(6486002)(36756003)(6666004)(2906002)(6512007)(186003)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3j7qU7nBqxfa7u7F/HPXtjwosK6qv/dHF1UdQ06AROJETzxmx4VUySCuT6Sg?=
 =?us-ascii?Q?lm8vg7M1ZzN5x/Zc96YsIOfvB16nlkkTPxgiwayAMpZtPkpCNAseRfJv+AlB?=
 =?us-ascii?Q?lXwci7T+r9eAwJubzWDrlhSLKfFjDb4Uu7BtoZ7HVGXzYqniefyeWe4Lp6Pf?=
 =?us-ascii?Q?8GMdZAzbxzFtaFipuBNPwGHqVKVCcc+d8F3NEZl4LZ/Mw4BQzKFbKGtwlKxd?=
 =?us-ascii?Q?rv3WMtSGORelIhPA+yr6S8H0QvvJFXY0Nhj3QYutzBKFYEnbL4mP+OQwuKWG?=
 =?us-ascii?Q?JRmTbMSsozS79jrrtEl9uk1ioUPMltv6G/teSJc3l6JIXTFqeKsUQobf5NUZ?=
 =?us-ascii?Q?zqR8Mh4Db5DD8otrOc+SlCCBWFuBmmD337nyAK2Xbdx4P7tdWHpDcpLFrq8B?=
 =?us-ascii?Q?cvdq7QchDGGTuplRnmqt2lln6flpzqGzpDIxlNgj7/X0oQDibjJ4HQCogIN7?=
 =?us-ascii?Q?d1CnWf/2orMUlrdUBXBZxqPQwamwmHgcPSo9blc25CvMAUiBnXGEVWgTUKXC?=
 =?us-ascii?Q?ZqMM4zwpaZXcQ7o/7KkHHJ2UpO38kYH9by2LFE7egahvd7NdcyCQ6JZ1q3zX?=
 =?us-ascii?Q?Y8k9ogohnOKokbOCkVllkL3llmAs9W9nXYUzF8mdHVm/IKK4opZ76UojoX2p?=
 =?us-ascii?Q?sSjyHk7fhGeHdRRFtWvOTC9CIp4ThnMME+HM60ENgUTuhxI2eRvxsWW6c33r?=
 =?us-ascii?Q?LcnImEj1KIEjMVF4DaYMandWIxpZwwnR8UsmPcJmpcVLBShyi3F2SHImWyaA?=
 =?us-ascii?Q?Lf0jpdzaoFTmem3Aafn/Ozojo/FqKxSSYNvr2DT7Hq9MeE7EHqN0mY+d9Wym?=
 =?us-ascii?Q?wqF0lVuKVTDT7Z/DjHEHvVLIaPxVQyW5PZ/0/Bj+o0W+HJCv1PXoHuy0Yh6v?=
 =?us-ascii?Q?4par7adY1M3F5+J5dXUc2QvcuzQ0OZ8Q0UIFwyySAiOScx5yUyUcfNUnHb1u?=
 =?us-ascii?Q?ywqoJtrkjmFxOrAefMhjgDItSmAS7sG+UyBfePyIa7Hwma7iE+OmIqlDWC3z?=
 =?us-ascii?Q?65Rg9dxKBZ9cluqgkEa5hq+3aKNjMz6Qxx/0G8hn9D/PPMPdp27LfuicXxW7?=
 =?us-ascii?Q?K+21g41rCnE0I7vTwla9RzA609Cx4tf4ORespTjGe/lTTAElMgBN0bua2EfQ?=
 =?us-ascii?Q?VmZf7FYJ5e4UVUm2vIUFLpVrr6JLX1EKVC1f2jPGxrRha9w9WaiKQ5FWD0s/?=
 =?us-ascii?Q?HaCkjv/arvFf2lrmhsiHrL9FcIxpT/3e8twyaHxY3d5JrCKt0FbHwezMJwo6?=
 =?us-ascii?Q?wSfqTSVyj9QfZKXQB3hwSyxYY6vCqwrgUfIlqB7keicMk9HS6a/8PSl9dVqm?=
 =?us-ascii?Q?d6IfMUi5bGE57ydp49vRluM+U/vuYGP1dhxjrkGWnMG2PMuSS3g8GvqHGGVD?=
 =?us-ascii?Q?gPtt9FeIpQiuoI3JG9YS7CbFexaArXGtCdAD6TO++LZ+6aJI8G6uB9uYMFtt?=
 =?us-ascii?Q?0w1svCso2J0b0tluINKiOtnWi8w1nJcoWYrzthvGrTBb0NDqp/INLV2wCweq?=
 =?us-ascii?Q?cn6fk8FMUFzRJqCcOtWdrSgYpylvKnv2qPjUpXsvKIULv5uZskzXrkOG7osC?=
 =?us-ascii?Q?lKo1lCHK66gv1qnOgrE96dIVFCqAfw/j3RJ7Y43vwNipGyhcPVjxslbkdzab?=
 =?us-ascii?Q?sTtwBhexXnst8egT9WgXnAmUphPuTTqZta8eRY+ChGBGjhasrR19K4ApHJMS?=
 =?us-ascii?Q?V+uA5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681c2313-d569-4b1f-19dc-08db65d42fcd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 14:50:21.5424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIfUpE2+iBpCvi7+VtnVyobQPnk9L7Ltqno4yHC11FdiBMQavbioSos4D7tpckDnwCiCgIg1Cu2HpEhlHKj9jCnjhRmnSVsMRnucvnvzLDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 01:45:52PM +0100, David Howells wrote:

...

> @@ -846,13 +824,131 @@ EXPORT_SYMBOL(iter_file_splice_write);
>   *    is involved.
>   *
>   */
> -ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
> -				loff_t *ppos, size_t len, unsigned int flags)
> +ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
> +			 loff_t *ppos, size_t len, unsigned int flags)
>  {
> -	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendpage);
> -}
> +	struct socket *sock = sock_from_file(out);
> +	struct bio_vec bvec[16];
> +	struct msghdr msg = {};
> +	ssize_t ret;
> +	size_t spliced = 0;
> +	bool need_wakeup = false;
> +
> +	pipe_lock(pipe);
> +
> +	while (len > 0) {

Hi David,

I'm assuming the answer is that this cannot occur,
but I thought I should mention this anyway.

If the initial value of len is 0 (or less).

...

> +
> +out:
> +	pipe_unlock(pipe);
> +	if (need_wakeup)
> +		wakeup_pipe_writers(pipe);
> +	return spliced ?: ret;

Then ret will be used uninitialised here.

> +}
> +#endif
>  
>  static int warn_unsupported(struct file *file, const char *op)
>  {

...

