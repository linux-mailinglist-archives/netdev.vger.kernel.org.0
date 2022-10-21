Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7B607926
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiJUOEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiJUOD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:03:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33602623CB;
        Fri, 21 Oct 2022 07:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=KDoD2IE+MUlni7T7kyV4UWRH47WVTnKjkmkAexRNrnU=; b=IRTDugDvKHavhU006V/cmVxXWv
        GlQHaDDtaIj5+OhCZxQt78Qp8heBOEJfQ5EinUZJe2Njqh/WxW3BtNscya/GtR/Kq0pP9fStIol5Q
        ilaUtfvlv4eYAHR8uH1vhuo5KhObEjgIpPeArEIyCUFihRM9GrNVK92dvuUfZbN2JmyckBYzdUaNs
        xjL1VIIHUkrgC0S0NDlL7JLJiEmGivgJKqw4EYCi005cQNILDcD0+wqAZSt2yxxWCWNiZLTEIkDmI
        XPaJjL/E9ueoXGvraEfz/j7gWvltOmnoqDE1MtkZy205A7cRcqmTeOQIxScQtLZAEFTE4JLeocuCM
        pkw0oBFns7f8GifXaKtWpIviK493IKDGuYU705RPuZyX8P0L7VAhmt/8QI/GkY8Pbj+jE1sM7AVSA
        JijS/3yvPmAdxVCFVwtvDrc7ONscHfOT3xf6nr9bjBS/D0K9j341IDuXr7z8GVtJvvgCpHXg1Gxhx
        SvAplElQR4LH2L544azf6KTF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olscs-005AH6-Vh; Fri, 21 Oct 2022 14:03:55 +0000
Message-ID: <11755fdb-4a28-0ea5-89a4-d51b2715f8c2@samba.org>
Date:   Fri, 21 Oct 2022 16:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
 <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
 <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
 <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
 <3e56c92b-567c-7bb4-2644-dc1ad1d8c3ae@samba.org>
 <273f154a-4cbd-2412-d056-a31fab5368d3@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <273f154a-4cbd-2412-d056-a31fab5368d3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.10.22 um 13:09 schrieb Pavel Begunkov:
> On 10/21/22 10:36, Stefan Metzmacher wrote:
>> Hi Pavel,
> [...]
>>> Right, I'm just tired of back porting patches by hand :)
>>
>> ok, I just assumed it would be 6.1 only.
> 
> I'm fine with 6.1 only, it'd make things easier. I thought from
> your first postings you wanted it 6.0. Then we don't need to care
> about the placing of the copied/used flags.
> 
>>>> Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
>>>> flag...
>>
>> Do you still want an opt-in flag to get IORING_CQE_F_COPIED?
>> If so what name do you want it to be?
> 
> Ala a IORING_SEND_* flag? Yes please.
> 
> *_REPORT_USAGE was fine but I'd make it IORING_SEND_ZC_REPORT_USAGE.
> And can be extended if there is more info needed in the future.
> 
> And I don't mind using a bit in cqe->res, makes cflags less polluted.

So no worries about the delayed/skip sendmsg completion anymore?

Should I define it like this, ok?

#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)

See the full patch below...

metze

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d69ae7eba773..32e1f2a55b70 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,10 +296,24 @@ enum io_uring_op {
   *
   * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
   *				the buf_index field.
+
+ * IORING_SEND_NOTIF_REPORT_USAGE
+ *				If SEND[MSG]_ZC should report
+ *				the zerocopy usage in cqe.res
+ *				for the IORING_CQE_F_NOTIF cqe.
+ *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
+ *				(at least partially).
   */
  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
  #define IORING_RECV_MULTISHOT		(1U << 1)
  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
+
+/*
+ * cqe.res for IORING_CQE_F_NOTIF if
+ * IORING_SEND_ZC_REPORT_USAGE was requested
+ */
+#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)

  /*
   * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 56078f47efe7..1aa3b50b3e82 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -939,7 +939,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

  	zc->flags = READ_ONCE(sqe->ioprio);
  	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_SEND_ZC_REPORT_USAGE))
  		return -EINVAL;
  	notif = zc->notif = io_alloc_notif(ctx);
  	if (!notif)
@@ -957,6 +958,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  		req->imu = READ_ONCE(ctx->user_bufs[idx]);
  		io_req_set_rsrc_node(notif, ctx, 0);
  	}
+	if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
+		io_notif_to_data(notif)->zc_report = true;
+	}

  	if (req->opcode == IORING_OP_SEND_ZC) {
  		if (READ_ONCE(sqe->__pad3[0]))
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..4bfef10161fa 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
  		__io_unaccount_mem(ctx->user, nd->account_pages);
  		nd->account_pages = 0;
  	}
+
+	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
  	io_req_task_complete(notif, locked);
  }

@@ -28,6 +32,13 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
  	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
  	struct io_kiocb *notif = cmd_to_io_kiocb(nd);

+	if (nd->zc_report) {
+		if (success && !nd->zc_used && skb)
+			WRITE_ONCE(nd->zc_used, true);
+		else if (!success && !nd->zc_copied)
+			WRITE_ONCE(nd->zc_copied, true);
+	}
+
  	if (refcount_dec_and_test(&uarg->refcnt)) {
  		notif->io_task_work.func = __io_notif_complete_tw;
  		io_req_task_work_add(notif);
@@ -55,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
  	nd->account_pages = 0;
  	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
  	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	nd->zc_report = nd->zc_used = nd->zc_copied = false;
  	refcount_set(&nd->uarg.refcnt, 1);
  	return notif;
  }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index e4fbcae0f3fd..6be2e5ae8581 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -15,6 +15,9 @@ struct io_notif_data {
  	struct file		*file;
  	struct ubuf_info	uarg;
  	unsigned long		account_pages;
+	bool			zc_report;
+	bool			zc_used;
+	bool			zc_copied;
  };

  void io_notif_flush(struct io_kiocb *notif);

