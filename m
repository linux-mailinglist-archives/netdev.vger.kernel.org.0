Return-Path: <netdev+bounces-11781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F0B373470D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 578291C209A7
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 16:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4905243;
	Sun, 18 Jun 2023 16:43:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312391386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 16:43:22 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA97E4C;
	Sun, 18 Jun 2023 09:43:21 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-6300afaa43bso8475616d6.3;
        Sun, 18 Jun 2023 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687106600; x=1689698600;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBYSMIfVNe+e3QEh8TVSmb5vDV7wnLuHaPeZvqfS6CY=;
        b=O9+clZi1I7Q2D1/148JPWZ6FRaUXR76yXW7hKnWfbu+//s8ivOGfLVXwfMlXCpPhQn
         Fr0Foq5QI1gmd6v+7XUMkQT4jk4mw4tEZS/7Vc5ItcsMXPyIE60fCu+vTUcx0VUVXWos
         dP91NGU7Ak6fQDOj91Rxo9Lat83m2JqRkCI3s3eC3Hbbml9ElTeH6n3l9F2xW4Mqv+zC
         krc5FIvo3kbT80oXASGH9uXiXMLTv8tvmpcEH1tp9YueBbzemvloGczhOl/KtMd83mRx
         cJVQUCbZiQKjbxDULyPV+ILROWx94QmTyORWYZtd8RKnbYWT3pUjUX+G0PCUvOuEccJe
         +NXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687106600; x=1689698600;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IBYSMIfVNe+e3QEh8TVSmb5vDV7wnLuHaPeZvqfS6CY=;
        b=OfaL3v8vXz7EW0Nti0se58f6SpSJ9CJHQg/WYFUGzVSvwxwPIJCxbwf74i8wXxMNti
         9JoixpkeT6P/f0yeAjOZq6/RvujFQ/IGnO087YDubJSA0rw8DistRSdtSHAl8DMmEDId
         P/xHb59jTjqBZbOAi/eK3kDkRAMrDf6Yr4R/ur/DoMSSFUT2mHD/GUzyQd/FHCbHirPn
         xsIjafG818a41JyLUds6dmir3cHSrjx7nAkZr5Ut2eB9W4zjj5zRzRjHGsTvAQ3y1A/X
         DAP3jeVEpYLtKVbdUANBea3FqxT4+/s3ROJNUO+Ju2tWNG/sV4O56XR+k8Gr8WQ3+lSq
         4aHw==
X-Gm-Message-State: AC+VfDz2MO2kwVcq12pTiJAlEDQBTtdaPk9YFobCzoTgi7Q8BqfZC/o9
	ZHA61NSeSQOj35atCX0WD60=
X-Google-Smtp-Source: ACHHUZ5vAKSFUxtIEZrqdP7lnIVdO8BAAmNZswyf0pFWotHoIo+NzKaBjqBthMB99jVyHERDnfYhUw==
X-Received: by 2002:a05:6214:410:b0:61b:79ab:7129 with SMTP id z16-20020a056214041000b0061b79ab7129mr11581461qvx.37.1687106599991;
        Sun, 18 Jun 2023 09:43:19 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id h2-20020a0cf442000000b00623927281c2sm9511953qvm.40.2023.06.18.09.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 09:43:19 -0700 (PDT)
Date: Sun, 18 Jun 2023 12:43:19 -0400
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
 Menglong Dong <imagedong@tencent.com>
Message-ID: <648f3427306bd_33cfbc2943a@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230617121146.716077-2-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
 <20230617121146.716077-2-dhowells@redhat.com>
Subject: RE: [PATCH net-next v2 01/17] net: Copy slab data for
 sendmsg(MSG_SPLICE_PAGES)
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
> If sendmsg() is passed MSG_SPLICE_PAGES and is given a buffer that contains
> some data that's resident in the slab, copy it rather than returning EIO.
> This can be made use of by a number of drivers in the kernel, including:
> iwarp, ceph/rds, dlm, nvme, ocfs2, drdb.  It could also be used by iscsi,
> rxrpc, sunrpc, cifs and probably others.
> 
> skb_splice_from_iter() is given it's own fragment allocator as
> page_frag_alloc_align() can't be used because it does no locking to prevent
> parallel callers from racing.  alloc_skb_frag() uses a separate folio for
> each cpu and locks to the cpu whilst allocating, reenabling cpu migration
> around folio allocation.
> 
> This could allocate a whole page instead for each fragment to be copied, as
> alloc_skb_with_frags() would do instead, but that would waste a lot of
> space (most of the fragments look like they're going to be small).
> 
> This allows an entire message that consists of, say, a protocol header or
> two, a number of pages of data and a protocol footer to be sent using a
> single call to sock_sendmsg().
> 
> The callers could be made to copy the data into fragments before calling
> sendmsg(), but that then penalises them if MSG_SPLICE_PAGES gets ignored.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Alexander Duyck <alexander.duyck@gmail.com>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: David Ahern <dsahern@kernel.org>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Menglong Dong <imagedong@tencent.com>
> cc: netdev@vger.kernel.org
> ---
> 
> Notes:
>     ver #2)
>     - Fix parameter to put_cpu_ptr() to have an '&'.
> 
>  include/linux/skbuff.h |   5 ++
>  net/core/skbuff.c      | 171 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 173 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 91ed66952580..0ba776cd9be8 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -5037,6 +5037,11 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
>  #endif
>  }
>  
> +void *alloc_skb_frag(size_t fragsz, gfp_t gfp);
> +void *copy_skb_frag(const void *s, size_t len, gfp_t gfp);
> +ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
> +			     ssize_t maxsize, gfp_t gfp);
> +
>  ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
>  			     ssize_t maxsize, gfp_t gfp);
>

duplicate declaration

(no need to respin just for this, imho)

