Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952125FFC86
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 00:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJOWnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 18:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJOWnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 18:43:00 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4892A42D5D
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 15:42:59 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-131dda37dddso9853590fac.0
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 15:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jjmZRK2JeI4lEYVk0XMiWq6fpTkR7wRmt9bDxO5mJ2U=;
        b=A9v1MtNKxK5KfDiub6qfWSrjZ89FqMw8NRmkoTo/sCBzmus2t9EpZvxLykzj4IIIed
         k2pmMwaqETFas7yuMAuRufmCRqAx/1xnoYROfPh4HcjnaAlVvkxN01s0Pq/+hNtvkm2v
         mbmmp9usKadY0WHZNwZa4smVf6xM2tr0qkAC9d+Z3uPS0e0f7b0gypo06PxhK+vY9wrT
         lP0dYL45PJvm+Q33+mb90k7CidzLSDboPXeZ0ALFzuK7w7b/yU681eMicE5LoAd9P9bI
         kVsZhzxZwjZaoylfKluPCgLRyydZ3JBODeL08HrxbO3WlG/ynglc7SLjI773l5XBNrG5
         5tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjmZRK2JeI4lEYVk0XMiWq6fpTkR7wRmt9bDxO5mJ2U=;
        b=mW9jN8fsESmDwTRfXQ32SsQKqKNGWKRH6o5uiSnWOuufEdf3qpAwAzKY1mUxxZo0PM
         B4UeSG05WCtLHQhfUh2Piaphmy01oYHmx+wdfZXt0DgmuVVY3Szess5y0p5PLt3vRlyq
         eaXca+bpEzb1T/EFV/Xgg38YKn0iVC3oTtHnxO8DK80vJzVLwuXZ2m4JwD3YTOsFVuHi
         Zmz4fM7xklNtGSNIM3OZNj+kTJRhYXHMsCn2O/ctQJJ7RHtHPmygIXII7Z748sumQO2q
         tZJJf+Ug6DW/pGelQD0VRkvEN1JT/dl4hIOSjFBsqy1mMbngWoPP9XMZxQIdUqTskiYu
         J1CA==
X-Gm-Message-State: ACrzQf2dX+PCAHBlicYAgKemES0TW8gi0w56VqbznTlbiAlL4NNawxlo
        33EQOt4YfqGcpczYu45RIWw=
X-Google-Smtp-Source: AMsMyM6WATBKV7OGOesM47PFKbmY/4Y/vKS6+rslo7tQ96r26a0xHNd++YjFmJsC0HplJXyLAkRz2w==
X-Received: by 2002:a05:6871:286:b0:131:a317:bdad with SMTP id i6-20020a056871028600b00131a317bdadmr2419923oae.174.1665873778212;
        Sat, 15 Oct 2022 15:42:58 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:b93c:f224:f186:ee])
        by smtp.gmail.com with ESMTPSA id y15-20020a4a450f000000b004767df8f231sm2582908ooa.39.2022.10.15.15.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 15:42:57 -0700 (PDT)
Date:   Sat, 15 Oct 2022 15:42:56 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, edumazet@google.com,
        sgarzare@redhat.com, ast@kernel.org, nikolay@nvidia.com,
        mkl@pengutronix.de, cong.wang@bytedance.com
Subject: Re: net/kcm: syz issue about general protection fault in skb_unlink
Message-ID: <Y0s3cP9pzGKzwagT@pop-os.localdomain>
References: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 06:51:29PM +0800, shaozhengchao wrote:
> I found that the syz issue("general protection fault in skb_unlink")
> still happen in Linux -next branch.
> commit: 082fce125e57cff60687181c97f3a8ee620c38f5
> Link:
> https://groups.google.com/g/syzkaller-bugs/c/ZfR2B5KaQrA/m/QfnGHCYSBwAJ
> Please ask:
> Is there any problem with this patch? Why is this patch not merged into
> the Linux -next branch or mainline?
> 

Does the following patch also fix this bug? It is much smaller than the
one you refer above.

Thanks.

---------------->

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1215c863e1c4..67c4b25d351d 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1116,6 +1116,7 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
+	struct kcm_mux *mux = kcm->mux;
 	int err = 0;
 	long timeo;
 	struct strp_msg *stm;
@@ -1156,8 +1157,10 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 msg_finished:
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
+			spin_lock_bh(&mux->rx_lock);
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
 			skb_unlink(skb, &sk->sk_receive_queue);
+			spin_unlock_bh(&mux->rx_lock);
 			kfree_skb(skb);
 		}
 	}
