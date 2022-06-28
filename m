Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F30155C379
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345166AbiF1LMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiF1LMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:12:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA2A22B252
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656414764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGi3GZ3X67AUti4hXwNYjl450hU4o5zBUg9z/I0jCK0=;
        b=OAEcAiNl+wm2Uo705sZIwbr72l+hm87mC+owfu2bNGh+2VF3qZ49UGfol7qx+WhzD15Tk8
        U7jTMhsgUeyurjDtymGFa9z6WvEJhlXV877EPGWnhgH12ZKYT+fxOxDg8tKVLHCopsuUOI
        onzEcoHDtgZmRPOoJKFSFXBQvSaKhDg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-nRIYXkyxOOCy9pTFnFSx8Q-1; Tue, 28 Jun 2022 07:12:43 -0400
X-MC-Unique: nRIYXkyxOOCy9pTFnFSx8Q-1
Received: by mail-wr1-f70.google.com with SMTP id o1-20020adfba01000000b0021b90bd28d2so1720550wrg.14
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VGi3GZ3X67AUti4hXwNYjl450hU4o5zBUg9z/I0jCK0=;
        b=JsiZPH+VcL3zuiMcuedeMFrVrJgqs4FEoWBElUFMVAyN5xRAEWD6ZbTRMWyzZKacUL
         MhccJ69RtBODH8ftnTRHf+jgUwhFrQaTe99ZyefXCtnUnhrlncy0ieFtvltDMDIpo6dW
         94Q3OxMELZtE7pp+o2AQyDVFhid4sbahVkz+SMwBz0s4T3ikytxNr7inmLjMvFWw2ohF
         qd5HcoMlh7z44pQTiHcoO6i6nBvfd3PheILhyrPMHRgL52QvlZGjHhQkVdsOc0XPnZLn
         JXNNR3fBryocHkqBC1MdbACjECHjeW5QXs32iCeQtYfiqLNbQGeRzxe6P3DHwa7K7cnj
         ev4w==
X-Gm-Message-State: AJIora9BafSDSpWTQbyzwi0/dm+BjgzrV3MmDALKEUzSaqkQ07r6E7Cf
        669tjyr14bCFrRCG3QliZk4mfwEB/OuUqi/gW8v8l1efwzH1/DFZcFRXF3gmOdXKuB9yKODjv6c
        6PWKacCponAQ81VHb
X-Received: by 2002:a5d:6d45:0:b0:21a:2f43:cb76 with SMTP id k5-20020a5d6d45000000b0021a2f43cb76mr17332901wri.254.1656414762631;
        Tue, 28 Jun 2022 04:12:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sbZ+MbBvL42Q4aR4eqg/x2m/iw0R3mnBXZESBiXIzSjoltOKUdfJU6wJqFE6fhym3e5C8VMA==
X-Received: by 2002:a5d:6d45:0:b0:21a:2f43:cb76 with SMTP id k5-20020a5d6d45000000b0021a2f43cb76mr17332882wri.254.1656414762381;
        Tue, 28 Jun 2022 04:12:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-110.dyn.eolo.it. [146.241.115.110])
        by smtp.gmail.com with ESMTPSA id a19-20020a05600c349300b0039db500714fsm17448747wmq.6.2022.06.28.04.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 04:12:41 -0700 (PDT)
Message-ID: <ecac788497ea0e4e5b725226ad8b1209dc62fa0e.camel@redhat.com>
Subject: Re: [PATCH net v3 2/2] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:12:40 +0200
In-Reply-To: <c31f454f74833b2003713fffa881aabb190b8290.1656031586.git.duoming@zju.edu.cn>
References: <cover.1656031586.git.duoming@zju.edu.cn>
         <c31f454f74833b2003713fffa881aabb190b8290.1656031586.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-24 at 09:05 +0800, Duoming Zhou wrote:
> When the link layer connection is broken, the rose->neighbour is
> set to null. But rose->neighbour could be used by rose_connection()
> and rose_release() later, because there is no synchronization among
> them. As a result, the null-ptr-deref bugs will happen.
> 
> One of the null-ptr-deref bugs is shown below:
> 
>     (thread 1)                  |        (thread 2)
>                                 |  rose_connect
> rose_kill_by_neigh              |    lock_sock(sk)
>   spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
>   rose->neighbour = NULL;//(1)  |
>                                 |    rose->neighbour->use++;//(2)
> 
> The rose->neighbour is set to null in position (1) and dereferenced
> in position (2).
> 
> The KASAN report triggered by POC is shown below:
> 
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> ...
> RIP: 0010:rose_connect+0x6c2/0xf30
> RSP: 0018:ffff88800ab47d60 EFLAGS: 00000206
> RAX: 0000000000000005 RBX: 000000000000002a RCX: 0000000000000000
> RDX: ffff88800ab38000 RSI: ffff88800ab47e48 RDI: ffff88800ab38309
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed1001567062
> R10: dfffe91001567063 R11: 1ffff11001567061 R12: 1ffff11000d17cd0
> R13: ffff8880068be680 R14: 0000000000000002 R15: 1ffff11000d17cd0
> ...
> Call Trace:
>   <TASK>
>   ? __local_bh_enable_ip+0x54/0x80
>   ? selinux_netlbl_socket_connect+0x26/0x30
>   ? rose_bind+0x5b0/0x5b0
>   __sys_connect+0x216/0x280
>   __x64_sys_connect+0x71/0x80
>   do_syscall_64+0x43/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This patch adds lock_sock() in rose_kill_by_neigh() in order to
> synchronize with rose_connect() and rose_release().
> 
> Meanwhile, this patch adds sock_hold() protected by rose_list_lock
> that could synchronize with rose_remove_socket() in order to mitigate
> UAF bug caused by lock_sock() we add.
> 
> What's more, there is no need using rose_neigh_list_lock to protect
> rose_kill_by_neigh(). Because we have already used rose_neigh_list_lock
> to protect the state change of rose_neigh in rose_link_failed(), which
> is well synchronized.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes since v2:
>   - v2: Fix refcount leak of sock.
> 
>  net/rose/af_rose.c    | 6 ++++++
>  net/rose/rose_route.c | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index bf2d986a6bc..5caa222c490 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -169,9 +169,15 @@ void rose_kill_by_neigh(struct rose_neigh *neigh)
>  		struct rose_sock *rose = rose_sk(s);
>  
>  		if (rose->neighbour == neigh) {
> +			sock_hold(s);
>  			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
>  			rose->neighbour->use--;
> +			spin_unlock_bh(&rose_list_lock);
> +			lock_sock(s);
>  			rose->neighbour = NULL;
> +			release_sock(s);
> +			spin_lock_bh(&rose_list_lock);

I'm sorry, I likely was not clear enough in my previous reply. This is
broken. If a list is [spin_]lock protected, you can't release the lock,
reacquire it and continue traversing the list from the [now invalid]
same iterator.

e.g. if s is removed from the list, even if the sock is not de-
allocated due to the addtional refcount, the traversing will errnously
stop after this sock, instead of continuing processing the remaining
socks in the list.

A possible alternative, not even build-tested would be:
---
diff --git a/include/net/rose.h b/include/net/rose.h
index 0f0a4ce0fee7..090db11d528f 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -145,6 +145,7 @@ struct rose_sock {
 	struct rose_facilities_struct facilities;
 	struct timer_list	timer;
 	struct timer_list	idletimer;
+	struct rose_sock	*dl_next;
 };
 
 #define rose_sk(sk) ((struct rose_sock *)(sk))
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 5caa222c490e..01f3c50f0921 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -162,25 +162,32 @@ static void rose_remove_socket(struct sock *sk)
  */
 void rose_kill_by_neigh(struct rose_neigh *neigh)
 {
-	struct sock *s;
+	struct rose_sock *del_list = NULL;
+	struct sock *s, *tmp;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, &rose_list) {
+	sk_for_each_safe(s, tmp, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->neighbour == neigh) {
-			sock_hold(s);
-			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
-			rose->neighbour->use--;
-			spin_unlock_bh(&rose_list_lock);
-			lock_sock(s);
-			rose->neighbour = NULL;
-			release_sock(s);
-			spin_lock_bh(&rose_list_lock);
-			sock_put(s);
+			__sk_del_node(s);
+			s->dl_next = del_list;
+			del_list = s;
 		}
 	}
 	spin_unlock_bh(&rose_list_lock);
+
+	while (del_list) {
+		s = del_list;
+		del_list = s->dl_next;
+
+		lock_sock(s);
+		rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
+		rose->neighbour->use--;
+		rose->neighbour = NULL;
+		release_sock(s);
+		sock_put(s);
+	}
 }
 
 /*
---

Paolo

