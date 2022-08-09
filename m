Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420B458D420
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiHIG6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiHIG6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:58:01 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB171CB00;
        Mon,  8 Aug 2022 23:58:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s206so10619956pgs.3;
        Mon, 08 Aug 2022 23:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc;
        bh=sHt6+OpLKNzitfga0l45w/oMbPQSePwz72VicwoDmCQ=;
        b=f2v2o9nzZ5LlBd6VAjtCwGwENqy4VpVm47u6/7HNtQx1tzc8MleLKxZmuvE5jq3WNY
         IqyDM3xxcdxDjqcjjznPC/fYDVowQ7QkYHlI+uW29uDmKk+tsGMdS0DHD90NhEaEhlP4
         /0zGYezdNeArnMYZpT5E/lt9WmnbpASkH1H/nWWwR5kBXq/EwkdaylWLDq3r6dZ/N478
         DenlasZPZahzps6s0blw5o0FfbFqiJfOM9GgH9m3W1UPbAkQr68A/QnmXtCppfe5nkyx
         j5KLcCEPr1ImU86T4e/6jSko2y/m1eAYzAvE03UZjdMitJAuQ5T1cpZR8SjP/nGOwnXC
         742Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc;
        bh=sHt6+OpLKNzitfga0l45w/oMbPQSePwz72VicwoDmCQ=;
        b=kDabUBmflNZlvoNECObjKOOYvs1llQylvxPEyU+7ac1KeTfq5M4MuHG9JeCn5WyABf
         Zgmns0zeZWUHkjI52Q9FIBCCaDfHI0mVzIV41cZQBYHJsPg4sRXQTwlyzqy++ioEUdXq
         n00dt6IsASaTZN9RjtblpgdBTpiJt+fFdSKWxrYYv1ugSXm+oU//cUmzD8BmTAfOYdxb
         DB2o+7YCQ98ELUZFgcQCG+4Ew3F+h+43wb+mf7YF4CgavbISDp9B/uPENbX1ERZxI0ie
         SVn6o4hWLcZ4NF8Xp7mIAXtf2NXtx2qFxiZ69tvz00yMjwFIcLclT/0f6rL3puCmVJtj
         AfCg==
X-Gm-Message-State: ACgBeo0wcZXUZCONiLKj58WB+L8OcEN1LnWYwXFGvTK/U7+gICA6siGP
        ZrSVGzFGpIv7XbyuZFQ+WYs=
X-Google-Smtp-Source: AA6agR7G6PBEBFN+xtc8vOthazHP37Vll9A8hmAyRO/8JvcKxUZNLyEcoromKZgP4qHfGoWNvoCI/Q==
X-Received: by 2002:a63:1a18:0:b0:419:aa0d:4f9c with SMTP id a24-20020a631a18000000b00419aa0d4f9cmr17616230pga.389.1660028280062;
        Mon, 08 Aug 2022 23:58:00 -0700 (PDT)
Received: from localhost ([98.97.32.252])
        by smtp.gmail.com with ESMTPSA id b18-20020aa78ed2000000b0052d4487ae7fsm9758508pfr.27.2022.08.08.23.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 23:57:58 -0700 (PDT)
Date:   Mon, 08 Aug 2022 23:57:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <62f2057561774_46f04208e3@john.notmuch>
In-Reply-To: <20220728134435.99469-1-liujian56@huawei.com>
References: <20220728134435.99469-1-liujian56@huawei.com>
Subject: RE: [PATCH bpf-next] skmsg: Fix wrong last sg check in
 sk_msg_recvmsg()
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
> Fix one kernel NULL pointer dereference as below:
> 
> [  224.462334] Call Trace:
> [  224.462394]  __tcp_bpf_recvmsg+0xd3/0x380
> [  224.462441]  ? sock_has_perm+0x78/0xa0
> [  224.462463]  tcp_bpf_recvmsg+0x12e/0x220
> [  224.462494]  inet_recvmsg+0x5b/0xd0
> [  224.462534]  __sys_recvfrom+0xc8/0x130
> [  224.462574]  ? syscall_trace_enter+0x1df/0x2e0
> [  224.462606]  ? __do_page_fault+0x2de/0x500
> [  224.462635]  __x64_sys_recvfrom+0x24/0x30
> [  224.462660]  do_syscall_64+0x5d/0x1d0
> [  224.462709]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> 
> In commit 7303524e04af ("skmsg: Lose offset info in sk_psock_skb_ingress"),
> we change last sg check to sg_is_last(), but in sockmap redirection case
> (without stream_parser/stream_verdict/skb_verdict), we did not mark the
> end of the scatterlist. Check the sk_msg_alloc, sk_msg_page_add, and
> bpf_msg_push_data functions, they all do not mark the end of sg. They are
> expected to use sg.end for end judgment. So the judgment of
> '(i != msg_rx->sg.end)' is added back here.
> 
> Fixes: 7303524e04af ("skmsg: Lose offset info in sk_psock_skb_ingress")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

This is the wrong fixes tag though right? We should have,

9974d37ea75f0 ("skmsg: Fix invalid last sg check in sk_msg_recvmsg()")

Fix looks OK though although its not great we have two ways
to find the last frag now. I'm going to look at getting some better
testing in place and then see if we can get to just one check.

Assuming I'm right on the fixes tag please update that.

>  net/core/skmsg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 81627892bdd4..385ae23580a5 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  
>  			if (copied == len)
>  				break;
> -		} while (!sg_is_last(sge));
> +		} while ((i != msg_rx->sg.end) && !sg_is_last(sge));
>  
>  		if (unlikely(peek)) {
>  			msg_rx = sk_psock_next_msg(psock, msg_rx);
> @@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  		}
>  
>  		msg_rx->sg.start = i;
> -		if (!sge->length && sg_is_last(sge)) {
> +		if (!sge->length && (i == msg_rx->sg.end || sg_is_last(sge))) {
>  			msg_rx = sk_psock_dequeue_msg(psock);
>  			kfree_sk_msg(msg_rx);
>  		}
> -- 
> 2.17.1
> 


