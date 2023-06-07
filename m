Return-Path: <netdev+bounces-8874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF2B72628B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214E02812DB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C89F370CA;
	Wed,  7 Jun 2023 14:17:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABFB34448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:17:41 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BA41BCA;
	Wed,  7 Jun 2023 07:17:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f739ec88b2so31133805e9.1;
        Wed, 07 Jun 2023 07:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686147457; x=1688739457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZZLmevYUEc06R0pP7aZ/xgDeyhqxmONqX6ci5XoNRmU=;
        b=g+3zr6toBDBwVsDINaUVbMpLqxk4SsxuRlwY3qSUwUEgUNof6il4s9sF6Hqvu/bm4t
         yvCexhZ+HHQZDfGarGZWJ3hDKhcALNAqaDXYwiOLBsd7ZQiVGGdk2BFYzY/Crz37rKP7
         y/MquDsEYHt7Dy+k3u3LxbWDWbCHFOzzxO0r5hlfDxpmCMXT+/MnaFB4eRZKFut4OqV+
         NjOth59E+M6eO1/Mdj+Yf/Hpnj7l9uApVxEuEuzwp9CF2L5GVNMo37QDAfMI1OCyEz1V
         7FhlkU9+BS3qAXpVWEdUJpKXIbZDwKrlhyr9W2R99LHy2THqeQzX4uj91Gvez9i33wX1
         EXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686147457; x=1688739457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZLmevYUEc06R0pP7aZ/xgDeyhqxmONqX6ci5XoNRmU=;
        b=L0Dijp1QdoK/Nl4Lgw9uyg6ed4Bql8eAb2bfi14jO9EYgCkzbKbIJftstIdl3Ve1+h
         Q3vxubX2UrjK/0iG7mWfIoGNUXAddChqUoKqTMI49PsJBCmjHgg71mxjb7zq4UtGsq3B
         As9Ol0rm2yjO3TPysOWz6NE/0B3tl//kr2tsrxdkyAbrxxtfxISK+61E5EnSChNJtTgh
         c2GufJmfvrnNtvWDIxnkhvJjKD/hTIZn1ysZjjW2qcvTr8cT/CoFOvF0p+aoTo9tztA+
         qlsO/snpzKO4LcMQ5+EfSTpgEn2FDMJwpwQTS9KgODad9VstIoQX2qiT9pEkCr4YvqLU
         gsMg==
X-Gm-Message-State: AC+VfDwNRGlu6X1ofDqB6x3xqwZxzZb3WZCs2yDIVV99LflGHqP6/yg9
	Yvc7IG8GXxzsWukmlD/0ltM=
X-Google-Smtp-Source: ACHHUZ7YFuFXcnTXGAupei4bKMADHVzt9HGOX4Sj50dCEZrY8dm2di7tUBSwpEniTiBcJTiPI8yjzA==
X-Received: by 2002:a7b:c8d1:0:b0:3f4:239c:f19 with SMTP id f17-20020a7bc8d1000000b003f4239c0f19mr4801078wml.36.1686147457245;
        Wed, 07 Jun 2023 07:17:37 -0700 (PDT)
Received: from [192.168.0.107] ([77.126.161.239])
        by smtp.gmail.com with ESMTPSA id y8-20020a7bcd88000000b003f4ecf1fcbcsm2302109wmj.22.2023.06.07.07.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 07:17:36 -0700 (PDT)
Message-ID: <4c49176f-147a-4283-f1b1-32aac7b4b996@gmail.com>
Date: Wed, 7 Jun 2023 17:17:30 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v10 08/16] tls: Inline do_tcp_sendpages()
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 Chuck Lever III <chuck.lever@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, Gal Pressman <gal@nvidia.com>,
 ranro@nvidia.com, samiram@nvidia.com, drort@nvidia.com,
 Tariq Toukan <tariqt@nvidia.com>
References: <20230522121125.2595254-1-dhowells@redhat.com>
 <20230522121125.2595254-9-dhowells@redhat.com>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230522121125.2595254-9-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,WEIRD_PORT autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 22/05/2023 15:11, David Howells wrote:
> do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
> so inline it, allowing do_tcp_sendpages() to be removed.  This is part of
> replacing ->sendpage() with a call to sendmsg() with MSG_SPLICE_PAGES set.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Boris Pismenny <borisp@nvidia.com>
> cc: John Fastabend <john.fastabend@gmail.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---

Hi,

My team spotted a new degradation in TLS TX device offload, bisected to 
this patch.

 From a quick look at the patch, it's not clear to me what's going wrong.
Please let us know of any helpful information that we can provide to 
help in the debug.

Regards,
Tariq

Reproduce Flow:
client / server test using nginx and  wrk (nothing special/custom about 
the apps used).

client:
/opt/mellanox/iproute2/sbin/ip link set dev eth3 up
/opt/mellanox/iproute2/sbin/ip addr add 11.141.46.9/16 dev eth3

server:
/opt/mellanox/iproute2/sbin/ip link set dev eth3 up
/opt/mellanox/iproute2/sbin/ip addr add 11.141.46.10/16 dev eth3

client:
/auto/sw/regression/sw_net_ver_tools/ktls/tools/x86_64/nginx_openssl_3_0_0 
-p /usr/bin/drivertest_rpms/ktls/nginx/
/opt/mellanox/iproute2/sbin/ss -i src [11.141.46.9]

server:
/auto/sw/regression/sw_net_ver_tools/ktls/tools/x86_64/wrk_openssl_3_0_0 
-b11.141.46.10 -t4 -c874 -d14 --timeout 5s 
https://11.141.46.9:20443/256000b.img

client:
dmesg
/auto/sw/regression/sw_net_ver_tools/ktls/tools/x86_64/nginx_openssl_3_0_0 
-p /usr/bin/drivertest_rpms/ktls/nginx/ -s stop


[root@c-141-46-1-009 ~]# dmesg
------------[ cut here ]------------
WARNING: CPU: 1 PID: 977 at net/core/skbuff.c:6957 
skb_splice_from_iter+0x102/0x300
Modules linked in: rpcrdma rdma_ucm ib_iser libiscsi 
scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib 
ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink 
nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 
auth_rpcgss oid_registry overlay mlx5_core zram zsmalloc fuse
CPU: 1 PID: 977 Comm: nginx_openssl_3 Not tainted 
6.4.0-rc3_for_upstream_min_debug_2023_06_01_23_04 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:skb_splice_from_iter+0x102/0x300
Code: ef 48 8b 55 08 f6 c2 01 0f 85 54 01 00 00 8b 0d 98 cf 5f 01 48 89 
ea 85 c9 0f 8f 4c 01 00 00 48 8b 12 80 e6 02 74 48 49 89 dd <0f> 0b 48 
c7 c1 fb ff ff ff 45 01 65 70 45 01 65 74 45 01 a5 d0 00
RSP: 0018:ffff8881045abaa0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88814370fe00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffea00051123c0 RDI: ffff88814370fe00
RBP: ffffea0005112400 R08: 0000000000000011 R09: 0000000000003ffd
R10: 0000000000003ffd R11: 0000000000000008 R12: 0000000000002e6e
R13: ffff88814370fe00 R14: ffff8881045abae8 R15: 000000000000118f
FS:  00007f6e23043740(0000) GS:ffff88852c880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000009c6c00 CR3: 000000013b791001 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:

  ? kmalloc_reserve+0x86/0xe0
  tcp_sendmsg_locked+0x33e/0xd40
  tls_push_sg+0xdd/0x230
  tls_push_data+0x673/0x920
  tls_device_sendmsg+0x6e/0xc0
  sock_sendmsg+0x38/0x60
  sock_write_iter+0x97/0x100
  vfs_write+0x2df/0x380
  ksys_write+0xa7/0xe0
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f6e22f018b7
Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e 
fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 
f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007ffdb528a2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000004000 RCX: 00007f6e22f018b7
RDX: 0000000000004000 RSI: 00000000025cdef0 RDI: 0000000000000028
RBP: 00000000020103c0 R08: 00007ffdb5289a90 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000025cdef0
R13: 000000000204fca0 R14: 0000000000004000 R15: 0000000000004000

---[ end trace 0000000000000000 ]---



>   include/net/tls.h  |  2 +-
>   net/tls/tls_main.c | 24 +++++++++++++++---------
>   2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 6056ce5a2aa5..5791ca7a189c 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -258,7 +258,7 @@ struct tls_context {
>   	struct scatterlist *partially_sent_record;
>   	u16 partially_sent_offset;
>   
> -	bool in_tcp_sendpages;
> +	bool splicing_pages;
>   	bool pending_open_record_frags;
>   
>   	struct mutex tx_lock; /* protects partially_sent_* fields and
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index f2e7302a4d96..3d45fdb5c4e9 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -125,7 +125,10 @@ int tls_push_sg(struct sock *sk,
>   		u16 first_offset,
>   		int flags)
>   {
> -	int sendpage_flags = flags | MSG_SENDPAGE_NOTLAST;
> +	struct bio_vec bvec;
> +	struct msghdr msg = {
> +		.msg_flags = MSG_SENDPAGE_NOTLAST | MSG_SPLICE_PAGES | flags,
> +	};
>   	int ret = 0;
>   	struct page *p;
>   	size_t size;
> @@ -134,16 +137,19 @@ int tls_push_sg(struct sock *sk,
>   	size = sg->length - offset;
>   	offset += sg->offset;
>   
> -	ctx->in_tcp_sendpages = true;
> +	ctx->splicing_pages = true;
>   	while (1) {
>   		if (sg_is_last(sg))
> -			sendpage_flags = flags;
> +			msg.msg_flags = flags;
>   
>   		/* is sending application-limited? */
>   		tcp_rate_check_app_limited(sk);
>   		p = sg_page(sg);
>   retry:
> -		ret = do_tcp_sendpages(sk, p, offset, size, sendpage_flags);
> +		bvec_set_page(&bvec, p, size, offset);
> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> +
> +		ret = tcp_sendmsg_locked(sk, &msg, size);
>   
>   		if (ret != size) {
>   			if (ret > 0) {
> @@ -155,7 +161,7 @@ int tls_push_sg(struct sock *sk,
>   			offset -= sg->offset;
>   			ctx->partially_sent_offset = offset;
>   			ctx->partially_sent_record = (void *)sg;
> -			ctx->in_tcp_sendpages = false;
> +			ctx->splicing_pages = false;
>   			return ret;
>   		}
>   
> @@ -169,7 +175,7 @@ int tls_push_sg(struct sock *sk,
>   		size = sg->length;
>   	}
>   
> -	ctx->in_tcp_sendpages = false;
> +	ctx->splicing_pages = false;
>   
>   	return 0;
>   }
> @@ -247,11 +253,11 @@ static void tls_write_space(struct sock *sk)
>   {
>   	struct tls_context *ctx = tls_get_ctx(sk);
>   
> -	/* If in_tcp_sendpages call lower protocol write space handler
> +	/* If splicing_pages call lower protocol write space handler
>   	 * to ensure we wake up any waiting operations there. For example
> -	 * if do_tcp_sendpages where to call sk_wait_event.
> +	 * if splicing pages where to call sk_wait_event.
>   	 */
> -	if (ctx->in_tcp_sendpages) {
> +	if (ctx->splicing_pages) {
>   		ctx->sk_write_space(sk);
>   		return;
>   	}
> 
> 

