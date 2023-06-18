Return-Path: <netdev+bounces-11782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF62D73470F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65AF12810C1
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 16:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A4A539A;
	Sun, 18 Jun 2023 16:47:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD01386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 16:47:59 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F85E4D;
	Sun, 18 Jun 2023 09:47:57 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3fde0f72f61so6433411cf.1;
        Sun, 18 Jun 2023 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687106877; x=1689698877;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPsd3RxvSK9akU38J5qW4D3wDnVV1+TTrRbY+MUugj8=;
        b=Cfj0sc49fEerL20hzENwz8PtcItwwSbnaClH5NS/pVHzmM/dvwLvhEaT6FYCNl0dmR
         OKA9zNJyQSpEsphH2tw/CmB52MYtdWASeDtaWkyUm3LzO0GqY0RFWBEMNwQKgRY1gte/
         hFMC/AS9uLs82RUEb9AvmdAHt4dHGLIlvQtI1Qr2qE9QAJ1KEPOoriAEOnrDHQkQ+d6+
         gYyzxf6y0xuGX7Gw8XirNiB3R4dTioKlXECEhHMm60fL4/KIEzIlvrrC3HawxafPHOPi
         CkcKx2T+h62Q42tysZQtLYJz8kH1cDimH+ATSgv62GnlbyeLcPaoPKDyV/U0EqAyz9T6
         O39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687106877; x=1689698877;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VPsd3RxvSK9akU38J5qW4D3wDnVV1+TTrRbY+MUugj8=;
        b=boQ01BGe1/oC/WG8lsbbjORthDN8D0VDe5CMTNBh+1KPok2aREFdQ5GY9GEJIA5QT4
         Sk1LGIrdyys3a+q0ORaRuNQYJ7k3SUuO1SSI4KWe5D6orSho3s0HUyR8fhDtmXzaWo63
         k/vt04PGsywOzdhkquyZuSVxplBfkSKGT/j45vW8hyVW0yuvL7Kv/lxjS0/kIzorCBaw
         vo7BsrEt0gpgA42A4S7f/GQMfJ0FrB4U7ZouFH5pyOD/62cMTEP8+YmWFnK4L5VlFJVw
         QYqohund5qtkavUuKZiHDRPLfPcaq8WEsx9X1L3K3a3t62osnpcZUDz00GVzAijDcgx3
         a67w==
X-Gm-Message-State: AC+VfDyH/snbO3+4jXb/Dlp5NNDI3Y3uGovNgAnMF2TxgdIwsF6SGdWo
	/k3nZq9OzN5riTw0Z2q6BvU=
X-Google-Smtp-Source: ACHHUZ6JDA42tEVXmLhshxtfb/9NVBPcW7rIpixWMOPq33WSJX3rYKh2qwYXdHkZVaM5I6lap7+ZYQ==
X-Received: by 2002:a05:622a:195:b0:3f8:2a37:20f with SMTP id s21-20020a05622a019500b003f82a37020fmr15741005qtw.34.1687106876943;
        Sun, 18 Jun 2023 09:47:56 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id bc14-20020a05622a1cce00b003fe8a96fb3bsm571571qtb.54.2023.06.18.09.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 09:47:56 -0700 (PDT)
Date: Sun, 18 Jun 2023 12:47:56 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: David Howells <dhowells@redhat.com>, 
 netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, 
 Alexander Duyck <alexander.duyck@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 David Ahern <dsahern@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 Jens Axboe <axboe@kernel.dk>, 
 linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 Keith Busch <kbusch@kernel.org>, 
 Jens Axboe <axboe@fb.com>, 
 Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, 
 Chaitanya Kulkarni <kch@nvidia.com>, 
 linux-nvme@lists.infradead.org
Message-ID: <648f353c55ce8_33cfbc29413@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230617121146.716077-11-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
 <20230617121146.716077-11-dhowells@redhat.com>
Subject: RE: [PATCH net-next v2 10/17] nvme: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

David Howells wrote:
> When transmitting data, call down into TCP using a single sendmsg with
> MSG_SPLICE_PAGES to indicate that content should be spliced rather than
> performing several sendmsg and sendpage calls to transmit header, data
> pages and trailer.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Keith Busch <kbusch@kernel.org>
> cc: Jens Axboe <axboe@fb.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Sagi Grimberg <sagi@grimberg.me>
> cc: Chaitanya Kulkarni <kch@nvidia.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-nvme@lists.infradead.org
> cc: netdev@vger.kernel.org
> ---
> 
> Notes:
>     ver #2)
>      - Wrap lines at 80.
> 
>  drivers/nvme/host/tcp.c   | 46 ++++++++++++++++++++-------------------
>  drivers/nvme/target/tcp.c | 46 ++++++++++++++++++++++++---------------
>  2 files changed, 53 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index bf0230442d57..6f31cdbb696a 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -997,25 +997,25 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
>  	u32 h2cdata_left = req->h2cdata_left;
>  
>  	while (true) {
> +		struct bio_vec bvec;
> +		struct msghdr msg = {
> +			.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
> +		};
>  		struct page *page = nvme_tcp_req_cur_page(req);
>  		size_t offset = nvme_tcp_req_cur_offset(req);
>  		size_t len = nvme_tcp_req_cur_length(req);
>  		bool last = nvme_tcp_pdu_last_send(req, len);
>  		int req_data_sent = req->data_sent;
> -		int ret, flags = MSG_DONTWAIT;
> +		int ret;
>  
>  		if (last && !queue->data_digest && !nvme_tcp_queue_more(queue))
> -			flags |= MSG_EOR;
> +			msg.msg_flags |= MSG_EOR;
>  		else
> -			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
> +			msg.msg_flags |= MSG_MORE;
>  
> -		if (sendpage_ok(page)) {
> -			ret = kernel_sendpage(queue->sock, page, offset, len,
> -					flags);
> -		} else {
> -			ret = sock_no_sendpage(queue->sock, page, offset, len,
> -					flags);
> -		}
> +		bvec_set_page(&bvec, page, len, offset);
> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
> +		ret = sock_sendmsg(queue->sock, &msg);
>  		if (ret <= 0)
>  			return ret;
>  
> @@ -1054,22 +1054,24 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>  {
>  	struct nvme_tcp_queue *queue = req->queue;
>  	struct nvme_tcp_cmd_pdu *pdu = nvme_tcp_req_cmd_pdu(req);
> +	struct bio_vec bvec;
> +	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES, };
>  	bool inline_data = nvme_tcp_has_inline_data(req);
>  	u8 hdgst = nvme_tcp_hdgst_len(queue);
>  	int len = sizeof(*pdu) + hdgst - req->offset;
> -	int flags = MSG_DONTWAIT;
>  	int ret;
>  
>  	if (inline_data || nvme_tcp_queue_more(queue))
> -		flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
> +		msg.msg_flags |= MSG_MORE;
>  	else
> -		flags |= MSG_EOR;
> +		msg.msg_flags |= MSG_EOR;
>  
>  	if (queue->hdr_digest && !req->offset)
>  		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
>  
> -	ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
> -			offset_in_page(pdu) + req->offset, len,  flags);
> +	bvec_set_virt(&bvec, (void *)pdu + req->offset, len);
> +	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, len);
> +	ret = sock_sendmsg(queue->sock, &msg);
>  	if (unlikely(ret <= 0))
>  		return ret;
>

    struct bio_vec bvec;
    struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES | ... };

    ..

    bvec_set_virt
    iov_iter_bvec
    sock_sendmsg

is a frequent pattern. Does it make sense to define a wrapper? Same for bvec_set_page.

