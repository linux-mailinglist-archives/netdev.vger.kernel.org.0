Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E4D2EEAB8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 02:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbhAHBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 20:10:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727634AbhAHBKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 20:10:22 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10819J2n012549;
        Thu, 7 Jan 2021 17:09:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nlSxjakrvkftB36oZcT62gTfMLsP7s6VZEr/tTat104=;
 b=JAsVCzQjMpwLJuSf6wGfHc7aqYq7JVAKYkLDkvhiBvXUKRuCibaCZor/fxDLtAlqlL3J
 wo5SkY3kQfvw9rOUoij6V0OpcDCqfL1MRXnINS006Sb6WXdCNZkSjZI0GbhjBxH/tjkx
 ZId+AS2wDabGxJOif8+0wvZGdrlyYdZcMT8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35wpuv5wr2-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Jan 2021 17:09:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 7 Jan 2021 17:08:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwPJ5fVOODC9ziOA+z6LDSIksIUU0cDubgLuoHItqz14pxvEuy9C9vohYjpiQluDbKY4lq8MU3giV08pt2Z9pxSdwHYHltIpDZWysTHcyqkeFMZ4LVoX/e++/gb2qMhXkja7XfBVQTk8k16XZcxNTGcYYP4SBDL35dc2kk+IyG/goK3aqqEPc+8qhz6l6XP/cu1IAMSBkQgj76oZbzqFvOuXlO8dvE9t5kOK9+o1GOUYt8ZhU5daOzkD071kyPUncVUxMwiXQA0Vtk9CKeZ2XNKJvdeiNnXRVrLsOQr5Y6jPfbbMP9d5Ay9pQ5JvORPnhJVOfL/R1Zhf4OHarJpwdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlSxjakrvkftB36oZcT62gTfMLsP7s6VZEr/tTat104=;
 b=bRbayYOjglU7PfIb/TyZkID9Mah8gQPcoh3F04V6819BX29yc1XC3/D7lzlumbwrezZ10DvpoGKq6Nxs9Cpb3lE5yrumyive7x+At7TXkKwoDMO2QTznyRUi6U47h0Qo/uFJv9UKv/HmjK3o6MpMQ7ZQk5u6nf0ORR688lyE/1HP/jqaDd1hlSPTWOqhozKGul1AyxkWQR4ZClr5BXNvBTDBNc7tHZGax7Hd4DV+mUst/ogkwGgUURWR7L50/eOH4wY/UecXhMmMwoA36TVRy9YeqAG8Yzlriyo6MmV9CYYITg11njSY0wsm1rpVIHz/2lFgoCcZD16IEIKKJTt7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlSxjakrvkftB36oZcT62gTfMLsP7s6VZEr/tTat104=;
 b=BLdR/9ktUYkd57r98Bu0sYW83zfLVt14tX7liom0S+km1PtPxgszGSabzMxTPVygQ8bv+n+tQ+RzFa9nS9V59ckIWUDHJJyor7japGpjMAsJf1DdFQMilwZXlKbxInETrmj9MisKIlvX4ILydxH1mZcvzL3Q/zN6HwdtHmXrGfE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22; Fri, 8 Jan
 2021 01:08:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Fri, 8 Jan 2021
 01:08:48 +0000
Date:   Thu, 7 Jan 2021 17:08:39 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next v4 3/3] bpf: remove extra lock_sock for
 TCP_ZEROCOPY_RECEIVE
Message-ID: <20210108010658.eglr2ev77knejkua@kafai-mbp.dhcp.thefacebook.com>
References: <20210107184305.444635-1-sdf@google.com>
 <20210107184305.444635-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107184305.444635-4-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:b7d0]
X-ClientProxiedBy: MW4PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:303:8f::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b7d0) by MW4PR03CA0027.namprd03.prod.outlook.com (2603:10b6:303:8f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23 via Frontend Transport; Fri, 8 Jan 2021 01:08:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94848c0c-7249-4e95-10b3-08d8b371f443
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3256DB96186F6C506FEA0CDFD5AE0@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HG/aEMjloVgCW5DQCllLR25b01HxRgfuEQWsi7hOL1QRZO9crPQdA3EbT8ZOLhu0WVy0HzENvWLb0n8nUfpJhEwWkysvyorxAU7tvL0bKI/Ksez/3/c7oyaQ6WIuh4xiNNQL9f6FdJ5RvcfxruiYL+IxEEeoHuH/q/4yXpIZRentvgaIhpQ4dmFNVKux9SaK63fEnDLDhrRtqf88S6JM2/Mii4mH1hqt70jwjWeo7rmoIBxfsI6vnyUx0NSccufuXZoU+tD4V6Saml8tEP0himBbMzcG5/pUSJdzJhcsMxHlFM7KmCTx+zR6t1GCr7Ygjmq2O+dg91P17IJBgVZXs/5vcefKeMaXsAqqVEfNLX91uyKHG45c6rkKK5qlwZxBrsowSi8PZwqXzMwPNTeaWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(366004)(396003)(55016002)(8676002)(1076003)(16526019)(186003)(6666004)(6506007)(66946007)(66476007)(8936002)(86362001)(5660300002)(316002)(54906003)(9686003)(4326008)(83380400001)(6916009)(2906002)(52116002)(478600001)(7696005)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RZMLg1iKDk8BXqMu3Er1av7LviL4Npq4zHEeoxP5I2Elr9ioctz2rV2jQtzY?=
 =?us-ascii?Q?4Y9in8Pm8ORdzfm0MFhz90vYUnALQ8o4zGMh269AAiW5TFn+/gAgIouSgILA?=
 =?us-ascii?Q?81uB+g4OTUMIkSYVGNzywA0ymw1SYKsYZSkFRkveKsMVF5aKUGUUcbCVNB9V?=
 =?us-ascii?Q?6CsGCKe+kePYtoZ2Fq9XEmY/J8m4+zMc0Z2RcOCxf7AVzCpLr4/es0Y40OTQ?=
 =?us-ascii?Q?XX+sJCHcTL/1Yw9KVYpUf6NfsHgLsncp1a/DW1PcywST+bRfrOishTRaTJHN?=
 =?us-ascii?Q?PSqn0h8VWMtS+3qqFeHX1JosPiRlNnQAZBTz5nYH0g3aSOS1SatKjlylhGxj?=
 =?us-ascii?Q?RRQ4pnpiomkVQRQ4UjwH28VANNp4LHMFOOZKMpqkof7XuNTh5dYxFGzGavhz?=
 =?us-ascii?Q?e6z+yR7VHK6rm70sSIEgzHeuDV7p/BDbxVu2r0tUtfC2Qakwip3YQGzAHZSd?=
 =?us-ascii?Q?+3sO4MoX04ghcYIeh2XvjuNsBwXPnvc3asIern0+vLoiCFUfduqZ6C85yFgX?=
 =?us-ascii?Q?F/ki6Cw5c1gCiV1wsaqjpy/Osm2f6Zdc6wS2veRdHaqz06g+D0WgJeMzmljp?=
 =?us-ascii?Q?iyvptLswMLVZVJgrKMAPMhnu0pwHHsdjd8L+IU9/aTGa47vz4RjRTJi7N93k?=
 =?us-ascii?Q?lJZLVFNHKuuuwx1YxIdb2Jnphm27yK2DwZygEWHB/zdQluvNzsf1y4PRRVkS?=
 =?us-ascii?Q?K+HAOnTz/huvnzd6GHfL1azI5hDjyzo95N+VJ+vmZ3js0AK4DYLffPDoL2o3?=
 =?us-ascii?Q?uuyCNlHzebB2nigGuWJH5aZiW5t5LfSMj+fTZFuBr1j1PG3/F60TEJbXetHG?=
 =?us-ascii?Q?eWfYT43xy2Pa+HKqiHLpsT5zVeinr1mmNm7cDR8XlsmdxBXnWNv0p888gbW8?=
 =?us-ascii?Q?Ui/btRk+tNf83YBA4gYngMcJi6KYQYOxnNci5UyJWlJBZO2cI0BDdNE+VFsv?=
 =?us-ascii?Q?g2+Ul1SC83gStVqLIFcF64mVqwSUJdWURZakQRqR2jHMUEKt82QNXfw7Fxyf?=
 =?us-ascii?Q?yn0Kw9Vpy//VVP0M5bAGkFuvZA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 01:08:48.2877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 94848c0c-7249-4e95-10b3-08d8b371f443
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hx+QCB5cQxYL9xNp6H5zsamoNn5YYQEOgv3Gg3yjy+YZrCw3rJZYAGmtrXz4PRLL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_11:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:43:05AM -0800, Stanislav Fomichev wrote:
> Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> call in do_tcp_getsockopt using the on-stack data. This removes
> 2% overhead for locking/unlocking the socket.
> 
> Also:
> - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
> - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32 bytes
>   (let's keep it to help with the other options)
> 
> (I can probably split this patch into two: add new features and rework
>  bpf_sockopt_buf; can follow up if the approach in general sounds
>  good).
> 
> Without this patch:
>      1.87%     0.06%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> 
> With the patch applied:
>      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/bpf-cgroup.h                    | 25 ++++-
>  include/linux/filter.h                        |  6 +-
>  include/net/sock.h                            |  2 +
>  include/net/tcp.h                             |  1 +
>  kernel/bpf/cgroup.c                           | 93 +++++++++++++------
>  net/ipv4/tcp.c                                | 14 +++
>  net/ipv4/tcp_ipv4.c                           |  1 +
>  net/ipv6/tcp_ipv6.c                           |  1 +
>  .../selftests/bpf/prog_tests/sockopt_sk.c     | 22 +++++
>  .../testing/selftests/bpf/progs/sockopt_sk.c  | 15 +++
>  10 files changed, 147 insertions(+), 33 deletions(-)
>

[ ... ]

> @@ -454,6 +469,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>  #define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
>  				       optlen, max_optlen, retval) ({ retval; })
> +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
> +					    optlen, retval) ({ retval; })
>  #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
>  				       kernel_optval) ({ 0; })
>  
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 54a4225f36d8..8739f1d4cac4 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1281,7 +1281,10 @@ struct bpf_sysctl_kern {
>  	u64 tmp_reg;
>  };
>  
> -#define BPF_SOCKOPT_KERN_BUF_SIZE	64
> +#define BPF_SOCKOPT_KERN_BUF_SIZE	32
It is reduced from patch 1 because there is no
need to use the buf (and copy from/to buf) in TCP_ZEROCOPY_RECEIVE?

Patch 1 is still desired (and kept in this set) because it may still
benefit other optname?

> +struct bpf_sockopt_buf {
> +	u8		data[BPF_SOCKOPT_KERN_BUF_SIZE];
> +};
>  
>  struct bpf_sockopt_kern {
>  	struct sock	*sk;
> @@ -1291,7 +1294,6 @@ struct bpf_sockopt_kern {
>  	s32		optname;
>  	s32		optlen;
>  	s32		retval;
> -	u8		buf[BPF_SOCKOPT_KERN_BUF_SIZE];
It is better to pick one way to do thing to avoid code
churn like this within the same series.

>  };
>  
>  int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len);
> diff --git a/include/net/sock.h b/include/net/sock.h
> index bdc4323ce53c..ebf44d724845 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1174,6 +1174,8 @@ struct proto {
>  
>  	int			(*backlog_rcv) (struct sock *sk,
>  						struct sk_buff *skb);
> +	bool			(*bpf_bypass_getsockopt)(int level,
> +							 int optname);
>  
>  	void		(*release_cb)(struct sock *sk);
>  
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 78d13c88720f..4bb42fb19711 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -403,6 +403,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
>  		      struct poll_table_struct *wait);
>  int tcp_getsockopt(struct sock *sk, int level, int optname,
>  		   char __user *optval, int __user *optlen);
> +bool tcp_bpf_bypass_getsockopt(int level, int optname);
>  int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>  		   unsigned int optlen);
>  void tcp_set_keepalive(struct sock *sk, int val);
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index adbecdcaa370..e82df63aedc7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -16,7 +16,6 @@
>  #include <linux/bpf-cgroup.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
> -#include <uapi/linux/tcp.h> /* sizeof(struct tcp_zerocopy_receive) */
Can the patches be re-ordered a little to avoid code churn like this
in the same series?

It feels like this patch 3 should be the first patch instead.
The current patch 1 should be the second patch
but it can still use the tcp_mmap to show potential
benefit for other optnames.

>  
>  #include "../cgroup/cgroup-internal.h"
>  
> @@ -1299,7 +1298,8 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
>  	return empty;
>  }
>  
> -static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
> +			     struct bpf_sockopt_buf *buf)
>  {
>  	if (unlikely(max_optlen < 0))
>  		return -EINVAL;
> @@ -1311,18 +1311,11 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  		max_optlen = PAGE_SIZE;
>  	}
>  
> -	if (max_optlen <= sizeof(ctx->buf)) {
> +	if (max_optlen <= sizeof(buf->data)) {
>  		/* When the optval fits into BPF_SOCKOPT_KERN_BUF_SIZE
>  		 * bytes avoid the cost of kzalloc.
> -		 *
> -		 * In order to remove extra allocations from the TCP
> -		 * fast zero-copy path ensure that buffer covers
> -		 * the size of struct tcp_zerocopy_receive.
>  		 */
> -		BUILD_BUG_ON(sizeof(struct tcp_zerocopy_receive) >
> -			     BPF_SOCKOPT_KERN_BUF_SIZE);
> -
> -		ctx->optval = ctx->buf;
> +		ctx->optval = buf->data;
>  		ctx->optval_end = ctx->optval + max_optlen;
>  		return max_optlen;
>  	}
> @@ -1336,16 +1329,18 @@ static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
>  	return max_optlen;
>  }
>  
> -static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx,
> +			     struct bpf_sockopt_buf *buf)
>  {
> -	if (ctx->optval == ctx->buf)
> +	if (ctx->optval == buf->data)
>  		return;
>  	kfree(ctx->optval);
>  }
>  
> -static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx)
> +static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
> +				  struct bpf_sockopt_buf *buf)
>  {
> -	return ctx->optval != ctx->buf;
> +	return ctx->optval != buf->data;
>  }
>  
>  int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
> @@ -1353,6 +1348,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  				       int *optlen, char **kernel_optval)
>  {
>  	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	struct bpf_sockopt_buf buf = {};
>  	struct bpf_sockopt_kern ctx = {
>  		.sk = sk,
>  		.level = *level,
> @@ -1373,7 +1369,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  	 */
>  	max_optlen = max_t(int, 16, *optlen);
>  
> -	max_optlen = sockopt_alloc_buf(&ctx, max_optlen);
> +	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
>  	if (max_optlen < 0)
>  		return max_optlen;
>  
> @@ -1419,7 +1415,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  			 * No way to export on-stack buf, have to allocate a
>  			 * new buffer.
>  			 */
> -			if (!sockopt_buf_allocated(&ctx)) {
> +			if (!sockopt_buf_allocated(&ctx, &buf)) {
>  				void *p = kzalloc(ctx.optlen, GFP_USER);
>  
>  				if (!p) {
> @@ -1436,7 +1432,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
>  
>  out:
>  	if (ret)
> -		sockopt_free_buf(&ctx);
> +		sockopt_free_buf(&ctx, &buf);
>  	return ret;
>  }
>  
> @@ -1445,15 +1441,20 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
>  				       int __user *optlen, int max_optlen,
>  				       int retval)
>  {
> -	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> -	struct bpf_sockopt_kern ctx = {
> -		.sk = sk,
> -		.level = level,
> -		.optname = optname,
> -		.retval = retval,
> -	};
This change looks unnecessary?

> +	struct bpf_sockopt_kern ctx;
> +	struct bpf_sockopt_buf buf;
> +	struct cgroup *cgrp;
>  	int ret;
>  
> +	memset(&buf, 0, sizeof(buf));
> +	memset(&ctx, 0, sizeof(ctx));
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	ctx.sk = sk;
> +	ctx.level = level;
> +	ctx.optname = optname;
> +	ctx.retval = retval;
> +
