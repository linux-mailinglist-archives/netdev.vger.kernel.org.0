Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499475E6A8D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIVSTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIVSTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:19:54 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964D230F79;
        Thu, 22 Sep 2022 11:19:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso3024322pjd.1;
        Thu, 22 Sep 2022 11:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date;
        bh=XYv0F8gTYYCHry5CRK7TnpyMNzVYB64g2/OgaHgY/IA=;
        b=K8YBmnn/VBF149uYXWDMtCwfYjbQmV/FAZbMds3MbUp4HO5Yb4pH3IoHGJSAeavDf+
         8RCTxAyjCSOQzUiAMQLGKFuNLpf/59XeaI8KNyQW4ftrIa0SPRBCEEiaLM1SFLIRqCI0
         uAPLYB9IzxuKF2tA+sHCJ2LBc15nrsZUy+x4krEPO3MPYAyw9qkjEG+mUDio1ksT/NYg
         1sLHr44W2aRAoc6wvcZIIYDUqSYxuW5X4torgrQHcbuvGX3bccGA4COpINJUQzpvz3D6
         8xCgWuhHBF2fcRfNmpYzKJ3cU9T3+1CeVm3jzkZmJMvd0Kj2yFmhc04xH5UD+44tD2He
         WrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date;
        bh=XYv0F8gTYYCHry5CRK7TnpyMNzVYB64g2/OgaHgY/IA=;
        b=nBtVPZQSA3xkcHuegb4pTU9FE3IFqaOwKHDSCESXTp9pDiYglOw6wlpEe1qMufoP92
         8PvsiWW5w6A0W3PBZuRmVqfV0zJ87orfbt7glVz2CV5ACHgpNMRMHIG/acmpe9dadgrr
         mjD0XlukCAcj7Hy8aJorsCjDH4qJ/Sk84Ltsse4ib3PZ+w8THLOP1oZSz42Bea0lG53/
         LyWIQQtaD7XZ5+EQGwv147ueoATmRdW85ugDLpoCTou2fk2sdbKWBhmKh6F6mc9jm44n
         Sr9zJbZblO7DZtILq9Ials6VycpwW/ue/juxiaJZyDTRW1B1bBnGOyThBqx8VG1ova1a
         m7dQ==
X-Gm-Message-State: ACrzQf0QzwV3QGOl64C/CLn0UYL8w4uze0BGjxLjderv8HunNja7oCnY
        p8q9WCqY7TyGvZDIsUr5+zGFJRkvOoU=
X-Google-Smtp-Source: AMsMyM7o/x1sHPU7Ynw3x8BnGFUp49rmLGluJY86GW2GOt8ZU/hsHYw6SbGTQZGvLeC4jyxudbwC7Q==
X-Received: by 2002:a17:902:904b:b0:178:95cb:63d9 with SMTP id w11-20020a170902904b00b0017895cb63d9mr4413427plz.146.1663870792021;
        Thu, 22 Sep 2022 11:19:52 -0700 (PDT)
Received: from localhost ([98.97.34.132])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902d2d100b001714c36a6e7sm4415890plc.284.2022.09.22.11.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:19:51 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:19:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <632ca74533409_3c2b220835@john.notmuch>
In-Reply-To: <20220907071311.60534-1-liujian56@huawei.com>
References: <20220907071311.60534-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf] skmsg: schedule psock work if the cached skb exists
 on the psock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> In sk_psock_backlog function, for ingress direction skb, if no new data
> packet arrives after the skb is cached, the cached skb does not have a
> chance to be added to the receive queue of psock. As a result, the cached
> skb cannot be received by the upper-layer application.
> 
> Fix this by reschedule the psock work to dispose the cached skb in
> sk_msg_recvmsg function.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

Yep thanks. We have another fix coming for a similar case with ENOMEM
through backlog. I'll post here before end of week.

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  net/core/skmsg.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 188f8558d27d..ca70525621c7 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -434,8 +434,10 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  			if (copied + copy > len)
>  				copy = len - copied;
>  			copy = copy_page_to_iter(page, sge->offset, copy, iter);
> -			if (!copy)
> -				return copied ? copied : -EFAULT;
> +			if (!copy) {
> +				copied = copied ? copied : -EFAULT;
> +				goto out;
> +			}
>  
>  			copied += copy;
>  			if (likely(!peek)) {
> @@ -455,7 +457,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  				 * didn't copy the entire length lets just break.
>  				 */
>  				if (copy != sge->length)
> -					return copied;
> +					goto out;
>  				sk_msg_iter_var_next(i);
>  			}
>  
> @@ -477,7 +479,9 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  		}
>  		msg_rx = sk_psock_peek_msg(psock);
>  	}
> -
> +out:
> +	if (psock->work_state.skb && copied > 0)
> +		schedule_work(&psock->work);
>  	return copied;
>  }
>  EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
> -- 
> 2.17.1
> 


