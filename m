Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEE3163CF6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgBSGTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:19:19 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35897 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgBSGTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 01:19:19 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so12202209pgu.3;
        Tue, 18 Feb 2020 22:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kYMmqaeC95sLLgXoumsJ4VaskWIEvKldQ8wjlR06LAs=;
        b=mijcu1T6J209i78ZxMs4hXg//ACUbCmZ53xSCtlgA5YONh7aTGZv/F28gGQVjC9BX7
         cMyen/AC1+ippYmEN8Y6+mEQlAiZTEoaMbuUQEALG2gxKFGq2ngv/3D0rrGW+mVeMNU7
         HgjV7tR7eEWYw68+UGWLuCT5KVitBP8HokMsrnRkvJHM4gb4oHWzgvehy4c0udr/UJgF
         10FA/bvKD0UcJlfiXsaDt0O7JRpIPTB+VZ0O2ca9vqLtKcAVLtytdXLCRlh0UbP7Wlhx
         nZ+AHoqxnPWXY28JOJgTuQocX1syCxZfb2o+QmFS3GgwxhgGgNGuN9/ZO27AHG6gtuwI
         5gSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kYMmqaeC95sLLgXoumsJ4VaskWIEvKldQ8wjlR06LAs=;
        b=D2Y3voXGWRySc6lHwLnoEKH88CAyaNrg/A6TbX0KSmIhCJAPT0xDo+4u5wkcav3Rfq
         diqQBYukPs3DMzOZ2ibHAas3Ja1/vmCmIDJwFxsFPt5JjjwWLNisIbSyI+RtmsarpLXw
         Jiu/K0N7xGXvIV0TjiGRi90Z7gjt6SWce8j3Iu/ptpJ//Pg4ibPL9PrYgcHl2el5QRW9
         /Oc0gRnbHGyI+oRU1oKD07zHll/tYMUaQMBtfm1qcQpESG949KXHXc5hbNWk3vrQ744t
         75amb1T9BRBKbzE/aVT+MN80reP888QwX3WGyMc3jtoK/xrUvzDZERlqynLh8vPB3vIX
         vd8A==
X-Gm-Message-State: APjAAAVB0itxYPd0m9XxO+nfYThr/U7h0yqQXUS8Io2ZiWAYgujHOaxy
        noVNOekNTCw+p6yvkg5VlG0=
X-Google-Smtp-Source: APXvYqx0+Kcy7jIK6uZI1UpPfvqaC0mBcfBkcmJ79Yz5Rf1QA06rdJ5skW0G7ZmO0QD0iT14B7J3+g==
X-Received: by 2002:a63:5f4e:: with SMTP id t75mr26025637pgb.7.1582093158346;
        Tue, 18 Feb 2020 22:19:18 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm1080198pfn.49.2020.02.18.22.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 22:19:17 -0800 (PST)
Date:   Tue, 18 Feb 2020 22:19:09 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e4cd35df0f1c_404b2ac01efba5b442@john-XPS-13-9370.notmuch>
In-Reply-To: <20200217121530.754315-3-jakub@cloudflare.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
 <20200217121530.754315-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 2/3] bpf, sk_msg: Don't clear saved sock proto on
 restore
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> There is no need to clear psock->sk_proto when restoring socket protocol
> callbacks in sk->sk_prot. The psock is about to get detached from the sock
> and eventually destroyed. At worst we will restore the protocol callbacks
> and the write callback twice.
> 
> This makes reasoning about psock state easier. Once psock is initialized,
> we can count on psock->sk_proto always being set.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/skmsg.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 8605947d6c08..d90ef61712a1 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -359,13 +359,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>  					  struct sk_psock *psock)
>  {
>  	sk->sk_prot->unhash = psock->saved_unhash;
> -
> -	if (psock->sk_proto) {
> -		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> -		psock->sk_proto = NULL;
> -	} else {
> -		sk->sk_write_space = psock->saved_write_space;
> -	}
> +	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
>  }
>  
>  static inline void sk_psock_set_state(struct sk_psock *psock,
> -- 
> 2.24.1
> 

Agreed, also the next line in sk_psock_drop is to NULL user data so
the psock will no longer be attached as far as the sock is concerned.

Acked-by: John Fastabend <john.fastabend@gmail.com>
