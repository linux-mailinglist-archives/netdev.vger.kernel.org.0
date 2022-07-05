Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004515679F3
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiGEWJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiGEWJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:09:46 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9622F1AF18;
        Tue,  5 Jul 2022 15:09:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bk26so4359115wrb.11;
        Tue, 05 Jul 2022 15:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Zg5q/VXEiWeb/pXQCCTFDP9y8Gvp8FRLldc0QCZv4AI=;
        b=ZU6bipR481bm2ae3vMtN6mipLVYaDNSDPQZQLEmj0Mn8hsU8HH1IKIBjZ3M5ueBunq
         KI9gMQCRSELDH9WEyU9YFQFAeSOLjl0ly0o1pK48a8kcaJDYySMntanZA9+VkIDnPE2l
         Xuo59ysS/ozmw3oQ/F7NXSxWRFlck50xaKrXLzMr6W5k7XIHkeLUbkR4jc3rkfCynbvc
         r+FsEc9QJy7bllXfZDXjnq3Ph9+lmOxxgxcpjSOthTsTxISB//0Nib4cQs9jK18H0Kzv
         MBXFAiRAomuyXIT8K2nDprh4KWCVry9gipWtiwOuv57j3RIc0/uiwx5HFnxXe6fRa2Ib
         GvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Zg5q/VXEiWeb/pXQCCTFDP9y8Gvp8FRLldc0QCZv4AI=;
        b=T40iFyNxlMdaicSEmuC976+S4Pu/tDJLsG3tozf48yzaddg8cBRsgfhyY/YUQjHaiH
         ffEAyAqGKhpDQ3ckELC7V7z/qIK2+FcQvqClgSDtKXAjep4EQXWYP+BorH/vf6qiKxvm
         RT/lzXnO1dhKIc/4E+8RniN1qOd888q8nk+5rdgeyJCDr+PWcZbHzTPbzI+yAm/2Vzg6
         gU76xySzqZMLlqfcwjrwnxec8UvK3SI11+zlEcJLippQZ5z2qXwiOO31Hxlb7owUL7Bd
         lvQx3ARMK1EyDtjbAezPBKtJvDsN+FxLn3CtNoPul0H+puIsoPxZ8vLUeLjj61n8HgWV
         SXiA==
X-Gm-Message-State: AJIora8AVJn8OovmDdgkJEQA3gXyi3+MuVQGDOvE6nVnL4iwpO5q8vzK
        MOWdUaOSU0rRx4LZu3p4ywGsXK+80/DLpQ==
X-Google-Smtp-Source: AGRyM1spewhz4dluzGnJQgWMz2+3u3a5Gk6ZaHJy5Lki4t1oO1JzEWsckJ2QKE43vwYsCNTs6+CS/g==
X-Received: by 2002:a5d:4d92:0:b0:21d:6f02:d971 with SMTP id b18-20020a5d4d92000000b0021d6f02d971mr7069632wru.300.1657058982067;
        Tue, 05 Jul 2022 15:09:42 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q13-20020adff50d000000b0021d64a11727sm9087871wro.49.2022.07.05.15.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 15:09:41 -0700 (PDT)
Message-ID: <6943e4a8-0b19-c35a-d6e5-9329dc03cc3e@gmail.com>
Date:   Tue, 5 Jul 2022 23:09:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
 <20220628225204.GA27554@u2004-local>
 <2840ec03-1d2b-f9c8-f215-61430f758925@gmail.com>
 <ee35a179-e9a1-39c7-d054-40b10ca9a1f3@kernel.org>
 <e453322f-bf33-d7c5-26c2-06896fb1a691@gmail.com>
In-Reply-To: <e453322f-bf33-d7c5-26c2-06896fb1a691@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 15:03, Pavel Begunkov wrote:
> On 7/5/22 03:28, David Ahern wrote:
>> On 7/4/22 7:31 AM, Pavel Begunkov wrote:
>>> If the series is going to be picked up for 5.20, how about we delay
>>> this one for 5.21? I'll have time to think about it (maybe moving
>>> the skb managed flag setup inside?), and will anyway need to send
>>> some omitted patches then.
>>>
>>
>> I think it reads better for io_uring and future extensions for io_uring
>> to contain the optimized bvec iter handler and setting the managed flag.
>> Too many disjointed assumptions the way the code is now. By pulling that
>> into io_uring, core code does not make assumptions that "managed" means
>> bvec and no page references - rather that is embedded in the code that
>> cares.
> 
> Core code would still need to know when to remove the skb's managed
> flag, e.g. in case of mixing. Can be worked out but with assumptions,
> which doesn't look better that it currently is. I'll post a 5.20
> rebased version and will iron it out on the way then.

Incremental looks like below. Probably looks better. What is slightly
dubious is that for zerocopy paths it leaves downgrading managed bit
to the callback unlike in most other places where it's done by core.
Also knowing upfront whether the user requests the feature or not
sounds less convoluted, but I guess it's not that important for now.

I can try to rebase and see how it goes


diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2d5badd4b9ff..2cc5b8850cb4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1782,12 +1782,13 @@ void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
  			   bool success);
  
  int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length);
+			    struct iov_iter *from, struct msghdr *msg,
+			    size_t length);
  
  static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
  					  struct msghdr *msg, int len)
  {
-	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
+	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, msg, len);
  }
  
  int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index ba84ee614d5a..59b0f47c1f5a 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -14,6 +14,8 @@ struct file;
  struct pid;
  struct cred;
  struct socket;
+struct sock;
+struct sk_buff;
  
  #define __sockaddr_check_size(size)	\
  	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
@@ -66,16 +68,13 @@ struct msghdr {
  	};
  	bool		msg_control_is_user : 1;
  	bool		msg_get_inq : 1;/* return INQ after receive */
-	/*
-	 * The data pages are pinned and won't be released before ->msg_ubuf
-	 * is released. ->msg_iter should point to a bvec and ->msg_ubuf has
-	 * to be non-NULL.
-	 */
-	bool		msg_managed_data : 1;
  	unsigned int	msg_flags;	/* flags on received message */
  	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
  	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
  	struct ubuf_info *msg_ubuf;
+
+	int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
+			    struct iov_iter *from, size_t length);
  };
  
  struct user_msghdr {
diff --git a/io_uring/net.c b/io_uring/net.c
index a142a609790d..b7643f267e20 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -269,7 +269,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
  	msg.msg_controllen = 0;
  	msg.msg_namelen = 0;
  	msg.msg_ubuf = NULL;
-	msg.msg_managed_data = false;
  
  	flags = sr->msg_flags;
  	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -617,7 +616,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
  	msg.msg_controllen = 0;
  	msg.msg_iocb = NULL;
  	msg.msg_ubuf = NULL;
-	msg.msg_managed_data = false;
  
  	flags = sr->msg_flags;
  	if (force_nonblock)
@@ -706,6 +704,60 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  	return 0;
  }
  
+static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
+			   struct iov_iter *from, size_t length)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int frag = shinfo->nr_frags;
+	int ret = 0;
+	struct bvec_iter bi;
+	ssize_t copied = 0;
+	unsigned long truesize = 0;
+
+	if (!shinfo->nr_frags)
+		shinfo->flags |= SKBFL_MANAGED_FRAG_REFS;
+
+	if (!skb_zcopy_managed(skb) || !iov_iter_is_bvec(from)) {
+		skb_zcopy_downgrade_managed(skb);
+		return __zerocopy_sg_from_iter(sk, skb, from, NULL, length);
+	}
+
+	bi.bi_size = min(from->count, length);
+	bi.bi_bvec_done = from->iov_offset;
+	bi.bi_idx = 0;
+
+	while (bi.bi_size && frag < MAX_SKB_FRAGS) {
+		struct bio_vec v = mp_bvec_iter_bvec(from->bvec, bi);
+
+		copied += v.bv_len;
+		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
+		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
+					   v.bv_offset, v.bv_len);
+		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
+	}
+	if (bi.bi_size)
+		ret = -EMSGSIZE;
+
+	shinfo->nr_frags = frag;
+	from->bvec += bi.bi_idx;
+	from->nr_segs -= bi.bi_idx;
+	from->count = bi.bi_size;
+	from->iov_offset = bi.bi_bvec_done;
+
+	skb->data_len += copied;
+	skb->len += copied;
+	skb->truesize += truesize;
+
+	if (sk && sk->sk_type == SOCK_STREAM) {
+		sk_wmem_queued_add(sk, truesize);
+		if (!skb_zcopy_pure(skb))
+			sk_mem_charge(sk, truesize);
+	} else {
+		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
+	}
+	return ret;
+}
+
  int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
  {
  	struct sockaddr_storage address;
@@ -740,7 +792,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
  	msg.msg_control = NULL;
  	msg.msg_controllen = 0;
  	msg.msg_namelen = 0;
-	msg.msg_managed_data = 1;
+	msg.sg_from_iter = io_sg_from_iter;
  
  	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
  		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
@@ -748,7 +800,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
  		if (unlikely(ret))
  				return ret;
  	} else {
-		msg.msg_managed_data = 0;
  		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
  					  &msg.msg_iter);
  		if (unlikely(ret))
diff --git a/net/compat.c b/net/compat.c
index 435846fa85e0..6cd2e7683dd0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -81,7 +81,6 @@ int __get_compat_msghdr(struct msghdr *kmsg,
  
  	kmsg->msg_iocb = NULL;
  	kmsg->msg_ubuf = NULL;
-	kmsg->msg_managed_data = false;
  	*ptr = msg.msg_iov;
  	*len = msg.msg_iovlen;
  	return 0;
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 3c913a6342ad..6901dcb44d72 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -613,59 +613,14 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
  }
  EXPORT_SYMBOL(skb_copy_datagram_from_iter);
  
-static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
-				   struct iov_iter *from, size_t length)
-{
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	int frag = shinfo->nr_frags;
-	int ret = 0;
-	struct bvec_iter bi;
-	ssize_t copied = 0;
-	unsigned long truesize = 0;
-
-	bi.bi_size = min(from->count, length);
-	bi.bi_bvec_done = from->iov_offset;
-	bi.bi_idx = 0;
-
-	while (bi.bi_size && frag < MAX_SKB_FRAGS) {
-		struct bio_vec v = mp_bvec_iter_bvec(from->bvec, bi);
-
-		copied += v.bv_len;
-		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
-		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
-					   v.bv_offset, v.bv_len);
-		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
-	}
-	if (bi.bi_size)
-		ret = -EMSGSIZE;
-
-	shinfo->nr_frags = frag;
-	from->bvec += bi.bi_idx;
-	from->nr_segs -= bi.bi_idx;
-	from->count = bi.bi_size;
-	from->iov_offset = bi.bi_bvec_done;
-
-	skb->data_len += copied;
-	skb->len += copied;
-	skb->truesize += truesize;
-
-	if (sk && sk->sk_type == SOCK_STREAM) {
-		sk_wmem_queued_add(sk, truesize);
-		if (!skb_zcopy_pure(skb))
-			sk_mem_charge(sk, truesize);
-	} else {
-		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
-	}
-	return ret;
-}
-
  int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length)
+			    struct iov_iter *from, struct msghdr *msg,
+			    size_t length)
  {
  	int frag;
  
-	if (skb_zcopy_managed(skb))
-		return __zerocopy_sg_from_bvec(sk, skb, from, length);
+	if (unlikely(msg && msg->msg_ubuf && msg->sg_from_iter))
+		return msg->sg_from_iter(sk, skb, from, length);
  
  	frag = skb_shinfo(skb)->nr_frags;
  
@@ -753,7 +708,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
  	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
  		return -EFAULT;
  
-	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U);
+	return __zerocopy_sg_from_iter(NULL, skb, from, NULL, ~0U);
  }
  EXPORT_SYMBOL(zerocopy_sg_from_iter);
  
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7e6fcb3cd817..046ec3124835 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1368,7 +1368,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
  	if (orig_uarg && uarg != orig_uarg)
  		return -EEXIST;
  
-	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len);
+	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, msg, len);
  	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
  		struct sock *save_sk = skb->sk;
  
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3fd1bf675598..df7f9dfbe8be 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1241,18 +1241,7 @@ static int __ip_append_data(struct sock *sk,
  			skb->truesize += copy;
  			wmem_alloc_delta += copy;
  		} else {
-			struct msghdr *msg = from;
-
-			if (!skb_shinfo(skb)->nr_frags) {
-				if (msg->msg_managed_data)
-					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
-			} else {
-				/* appending, don't mix managed and unmanaged */
-				if (!msg->msg_managed_data)
-					skb_zcopy_downgrade_managed(skb);
-			}
-
-			err = skb_zerocopy_iter_dgram(skb, msg, copy);
+			err = skb_zerocopy_iter_dgram(skb, from, copy);
  			if (err < 0)
  				goto error;
  		}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 05e2f6271f65..634c16fe8dcd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1392,18 +1392,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
  			 * zerocopy skb
  			 */
  			if (!skb->len) {
-				if (msg->msg_managed_data)
-					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
  				skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
-			} else {
-				/* appending, don't mix managed and unmanaged */
-				if (!msg->msg_managed_data)
-					skb_zcopy_downgrade_managed(skb);
-				if (!skb_zcopy_pure(skb)) {
-					copy = tcp_wmem_schedule(sk, copy);
-					if (!copy)
-						goto wait_for_space;
-				}
+			} else if (!skb_zcopy_pure(skb)) {
+				copy = tcp_wmem_schedule(sk, copy);
+				if (!copy)
+					goto wait_for_space;
  			}
  
  			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 34eb3b5da5e2..897ca4f9b791 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1796,18 +1796,7 @@ static int __ip6_append_data(struct sock *sk,
  			skb->truesize += copy;
  			wmem_alloc_delta += copy;
  		} else {
-			struct msghdr *msg = from;
-
-			if (!skb_shinfo(skb)->nr_frags) {
-				if (msg->msg_managed_data)
-					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
-			} else {
-				/* appending, don't mix managed and unmanaged */
-				if (!msg->msg_managed_data)
-					skb_zcopy_downgrade_managed(skb);
-			}
-
-			err = skb_zerocopy_iter_dgram(skb, msg, copy);
+			err = skb_zerocopy_iter_dgram(skb, from, copy);
  			if (err < 0)
  				goto error;
  		}
diff --git a/net/socket.c b/net/socket.c
index 0963a02b1472..ed061609265e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2107,7 +2107,6 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
  	msg.msg_controllen = 0;
  	msg.msg_namelen = 0;
  	msg.msg_ubuf = NULL;
-	msg.msg_managed_data = false;
  	if (addr) {
  		err = move_addr_to_kernel(addr, addr_len, &address);
  		if (err < 0)
@@ -2174,7 +2173,6 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
  	msg.msg_iocb = NULL;
  	msg.msg_flags = 0;
  	msg.msg_ubuf = NULL;
-	msg.msg_managed_data = false;
  	if (sock->file->f_flags & O_NONBLOCK)
  		flags |= MSG_DONTWAIT;
  	err = sock_recvmsg(sock, &msg, flags);
@@ -2414,7 +2412,6 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
  
  	kmsg->msg_iocb = NULL;
  	kmsg->msg_ubuf = NULL;
-	kmsg->msg_managed_data = false;
  	*uiov = msg.msg_iov;
  	*nsegs = msg.msg_iovlen;
  	return 0;
