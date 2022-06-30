Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAB956133B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiF3H33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiF3H32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:29:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4D1275CA;
        Thu, 30 Jun 2022 00:29:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o18so16291733plg.2;
        Thu, 30 Jun 2022 00:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zRVMghymqEWNCijZ1LhKVUMqkFO2SHni2tD819R1BbQ=;
        b=oVYsQcFMBK+S7CWWdx4ra4+xUTOpW4TzgQ1lIViAclYrrwOeurmD3WgLq6/KwrwO/k
         Nu1Th2Vd30o2Uw431Z4zD3XAhW4SR8v1C0E+3kMLLFwquhgX/UhNf+LrsXm18SprHJhE
         XaiVtEpFnU1H+/74LgzDc8V25fbLyAtq9zMKNW+m5o43oWYO3O3hAxOXFKbyxqJwcO63
         Vo2RfXPP3zpFv3aQWAdXzpSFQ0Etj8kn10S8VCLV+ayh4+3wXwW98bE1TBza5MxYv0uR
         B7AVAtkbdr97a8cc5y1RV0VGN38fbDtptx+BSrwHylmJwqnaIMzCwVTPB9jKrP2ncEet
         EVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zRVMghymqEWNCijZ1LhKVUMqkFO2SHni2tD819R1BbQ=;
        b=kaiald2Mq/NFdX9Cg1Y/OE1vAGf2a/qjAWaLG8VXB/ZZOosRNOOMLrGWzggTeZVU3H
         tJJIVO2JHCmYbRZKBhI9CYbtFyw1qA1yqpywiVWDq1Nu+PZ2w363MAGY8wfenZkFDvbp
         3kpjJCk1gT22wo8kNBpiT9pGut1KLdOdNbxhzWnpdnw8Bd18N6eH/jsaNXcZ871jd4v3
         CMHCsSiS/HL+9BGX78UhAjYTWB5swcLAl1XkaDY+T2q5CUdIiABAfSjKJzrPaOz+QpTN
         ZD3bThuqbM483CKdKC3Ac9dtNWBQ0VXfSw5d2fa4n8elWiIFTOT3u14m3pWp8FDh8lZs
         ugpw==
X-Gm-Message-State: AJIora87LMp53NcUBxSsYQbRSD6cCx2TVEEpnajeG1QD1ayDWqJ8WbOj
        lFSVMLraHYXoiWqIs9Tgp5Y=
X-Google-Smtp-Source: AGRyM1uep8R357gO3S7rz3GYYxzmrRQUWyQCYkAAQNwlcCwXDw9+YXxLnwkAAu+VDpc75Y/TpH++lg==
X-Received: by 2002:a17:902:8f97:b0:169:5e8:d75b with SMTP id z23-20020a1709028f9700b0016905e8d75bmr14529815plo.28.1656574166986;
        Thu, 30 Jun 2022 00:29:26 -0700 (PDT)
Received: from localhost ([98.97.119.237])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7808e000000b00518e1251197sm13237474pff.148.2022.06.30.00.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 00:29:26 -0700 (PDT)
Date:   Thu, 30 Jun 2022 00:29:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <62bd50d459166_54c3b2089f@john.notmuch>
In-Reply-To: <20220628123616.186950-1-liujian56@huawei.com>
References: <20220628123616.186950-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf] skmsg: Fix invalid last sg check in sk_msg_recvmsg()
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> In sk_psock_skb_ingress_enqueue function, if the linear area + nr_frags +
> frag_list of the SKB has NR_MSG_FRAG_IDS blocks in total, skb_to_sgvec
> will return NR_MSG_FRAG_IDS, then msg->sg.end will be set to
> NR_MSG_FRAG_IDS, and in addition, (NR_MSG_FRAG_IDS - 1) is set to the last
> SG of msg. Recv the msg in sk_msg_recvmsg, when i is (NR_MSG_FRAG_IDS - 1),
> the sk_msg_iter_var_next(i) will change i to 0 (not NR_MSG_FRAG_IDS), the
> judgment condition "msg_rx->sg.start==msg_rx->sg.end" and
> "i != msg_rx->sg.end" can not work.
> 
> As a result, the processed msg cannot be deleted from ingress_msg list.
> But the length of all the sge of the msg has changed to 0. Then the next
> recvmsg syscall will process the msg repeatedly, because the length of sge
> is 0, the -EFAULT error is always returned.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  net/core/skmsg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index b0fcd0200e84..a8dbea559c7f 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  
>  			if (copied == len)
>  				break;
> -		} while (i != msg_rx->sg.end);
> +		} while (!sg_is_last(sge));
>  
>  		if (unlikely(peek)) {
>  			msg_rx = sk_psock_next_msg(psock, msg_rx);
> @@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  		}
>  
>  		msg_rx->sg.start = i;
> -		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
> +		if (!sge->length && sg_is_last(sge)) {
>  			msg_rx = sk_psock_dequeue_msg(psock);
>  			kfree_sk_msg(msg_rx);
>  		}
> -- 
> 2.17.1
> 

Looks correct to me, but I'll test it tomorrow and add a reviewed-by and
tested-by then. Thanks!
