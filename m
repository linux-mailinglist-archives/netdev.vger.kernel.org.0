Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF401607464
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiJUJqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiJUJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:46:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0614A106E02;
        Fri, 21 Oct 2022 02:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=iURgOKzIT0lIt/UAxzMGuixwGl1kUCZMNROcMf25h/w=; b=D37I1dfX3S/Q+Y2aX5iOf93snB
        uDwFV3ZCNjdKPNJHqXm5A8OzRD5wdGMU+w2btVDBeyHGJClbS4ZSTR7dgUOUNTP7y8sFbaU25K5Jh
        OwEPkTkLoPiCjYXz1htACQWsJdMjAxDZr5XHgShWfBGDu+FCsq0d/HADxnOwicvF3NyO+o67N5wF4
        1ZWewWbzFGjNHtTpJ9CE6eDRjlTgxv+u6sbl77kwME2+XuccrR0eg7wCYHtuAaBJbz4V6DRbjhrBA
        xjcVo0ilEuqIweMFdAyBrFipozEDCU3+/B6IcfIsdcTL4h/zfhdUPmJLaxOiPscP8aTyUyO0AS4cD
        ayUonJHINtFElbbvc/Xn5uo7A6XC+EwltTu1WZGNH86vzDqdDOhHCFy3eneV1yWwiw+Y5qaBgRfot
        +MLCJMR9SvFkdALQ3SJzRb+oqgT6HtQuHgFL1Xgb2oeoKpCDG+htP2hMkv8vNucLlWPAP0m8/HBqP
        YTbkelRGMkYoRuHBVSobg4St;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olob6-0058kc-U6; Fri, 21 Oct 2022 09:45:48 +0000
Message-ID: <a5bf4d77-0fad-1d3f-159f-b97128f58af2@samba.org>
Date:   Fri, 21 Oct 2022 11:45:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
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
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.10.22 um 11:27 schrieb Pavel Begunkov:
> On 10/21/22 09:32, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>>>>> Experimenting with this stuff lets me wish to have a way to
>>>>>> have a different 'user_data' field for the notif cqe,
>>>>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>>>>> easier and would avoid some complexity in userspace...
>>>>>> As I need to handle retry on short writes even with MSG_WAITALL
>>>>>> as EINTR and other errors could cause them.
>>>>>>
>>>>>> What do you think?
>>>>
>>>> Any comment on this?
>>>>
>>>> IORING_SEND_NOTIF_USER_DATA could let us use
>>>> notif->cqe.user_data = sqe->addr3;
>>>
>>> I'd rather not use the last available u64, tbh, that was the
>>> reason for not adding a second user_data in the first place.
>>
>> As far as I can see io_send_zc_prep has this:
>>
>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>                  return -EINVAL;
>>
>> both are u64...
> 
> Hah, true, completely forgot about that one

So would a commit like below be fine for you?

Do you have anything in mind for SEND[MSG]_ZC that could possibly use
another u64 in future?

metze

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 738d6234d1d9..7a6272872334 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -300,6 +300,7 @@ enum io_uring_op {
  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
  #define IORING_RECV_MULTISHOT		(1U << 1)
  #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_SEND_NOTIF_USER_DATA	(1U << 3)

  /*
   * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 735eec545115..e1bc06b58cd7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -938,7 +938,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  	struct io_ring_ctx *ctx = req->ctx;
  	struct io_kiocb *notif;

-	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
+	if (unlikely(READ_ONCE(sqe->__pad2[0]))
  		return -EINVAL;
  	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
  	if (req->flags & REQ_F_CQE_SKIP)
@@ -946,12 +946,19 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

  	zc->flags = READ_ONCE(sqe->ioprio);
  	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_SEND_NOTIF_USER_DATA))
  		return -EINVAL;
  	notif = zc->notif = io_alloc_notif(ctx);
  	if (!notif)
  		return -ENOMEM;
-	notif->cqe.user_data = req->cqe.user_data;
+	if (zc->flags & IORING_SEND_NOTIF_USER_DATA)
+		notif->cqe.user_data = READ_ONCE(sqe->addr3);
+	else {
+		if (unlikely(READ_ONCE(sqe->addr3)))
+			return -EINVAL;
+		notif->cqe.user_data = req->cqe.user_data;
+	}
  	notif->cqe.res = 0;
  	notif->cqe.flags = IORING_CQE_F_NOTIF;
  	req->flags |= REQ_F_NEED_CLEANUP;


