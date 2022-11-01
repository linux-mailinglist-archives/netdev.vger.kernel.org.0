Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B605D6152A6
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiKAUBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAUBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:01:43 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127121BEA0;
        Tue,  1 Nov 2022 13:01:43 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h193so5657483pgc.10;
        Tue, 01 Nov 2022 13:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUKWrM4Gt5kR3Edh8OwJyz3lpjjexPnO/+xegmkZfyc=;
        b=YqGi2tyncckrxphp3Z/xkBeqft2LVqgsPhTfnr3at3jg1MqAioAH9tuxyeDGDGLZN/
         gFT1E5lA4Aq6MMnqhM0MccWFEDP8+OsjNPt+uK/5DG3I5GftKmliDArRVgS9/4DYh2he
         TXKYuylFKf+3F/Y2EGp2GEP6rzwXUF4aySKiTYpYis28frpvuLZVtzUtol+TJoErWNz1
         dXKG7vNrDmmW5BRnOe575gN9edGDyeG6QW73iDp11MKa/FpXjRZ9hyB/MBP2452DHHL6
         BPy0tmg61Ie6ClHaxABcye0mpojjYAsXdmDugv3wz9u7P6/ArIv0nR3zCnmIUrALUUW6
         kNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yUKWrM4Gt5kR3Edh8OwJyz3lpjjexPnO/+xegmkZfyc=;
        b=tcP6dp7K5FYniD5XbCisVegLwTMtjpUBGLmMqcmZXQxYUIsVv7rIRdeZ0j4fxRpm6/
         C6YCOKJ82YF3HvA0nPiJ0tkLu+GJsGHznKKTyF3AbEldyJfT7rBPbU4LCMhi+MIZF8/X
         Po/w6fT8heeX5D8eT3UqH91ECmF/9zEBwZBi1C0G04UDJTz8DdFHo70QdfWC8vWqZL+r
         /LVdp+ErSOeX9iRkgAe1vzWEdaYmq3xxByOi2AgjP1kig4Miim1pEOkUNoItC6Mi8Dws
         0RcqazNiT+q1F3oGHLZ/mJ22nxkrm1vLOd2YECK+8GyJCnw3lkcPhypTZXX7+TqPO46i
         8GeQ==
X-Gm-Message-State: ACrzQf0c3uVSJHTg5jL7KL10cMKXewD5E5NiSVwc7FjhxQEqMRqH8rcT
        L27sfK5fs5nPPxf6Rnqzsuk=
X-Google-Smtp-Source: AMsMyM7TYPyi835IQz2i5y4zaD+KaXpR3TuNvtVyOt7LASUtWez0HDemsUW0cuAi2geyY+F4Wqr6IA==
X-Received: by 2002:a63:914a:0:b0:46f:7e1c:6584 with SMTP id l71-20020a63914a000000b0046f7e1c6584mr18351678pge.562.1667332902429;
        Tue, 01 Nov 2022 13:01:42 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id fa20-20020a17090af0d400b002137030f652sm6470935pjb.12.2022.11.01.13.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:01:41 -0700 (PDT)
Date:   Tue, 01 Nov 2022 13:01:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <63617b2434725_2eb7208e1@john.notmuch>
In-Reply-To: <87bkprprxf.fsf@cloudflare.com>
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com>
 <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain>
 <87bkprprxf.fsf@cloudflare.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
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

Jakub Sitnicki wrote:
> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
> >> > On 10/17, Cong Wang wrote:
> >> >> From: Cong Wang <cong.wang@bytedance.com>
> >> >
> >> >> Technically we don't need lock the sock in the psock work, but we
> >> >> need to prevent this work running in parallel with sock_map_close().
> >> >
> >> >> With this, we no longer need to wait for the psock->work synchronously,
> >> >> because when we reach here, either this work is still pending, or
> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
> >> >> the first case asynchronously, and we need to bail out the second case
> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
> >> >
> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >> >
> >> > This seems to remove the splat for me:
> >> >
> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
> >> >
> >> > The patch looks good, but I'll leave the review to Jakub/John.
> >> 
> >> I can't poke any holes in it either.
> >> 
> >> However, it is harder for me to follow than the initial idea [1].
> >> So I'm wondering if there was anything wrong with it?
> >
> > It caused a warning in sk_stream_kill_queues() when I actually tested
> > it (after posting).
> 
> We must have seen the same warnings. They seemed unrelated so I went
> digging. We have a fix for these [1]. They were present since 5.18-rc1.
> 
> >> This seems like a step back when comes to simplifying locking in
> >> sk_psock_backlog() that was done in 799aa7f98d53.
> >
> > Kinda, but it is still true that this sock lock is not for sk_socket
> > (merely for closing this race condition).
> 
> I really think the initial idea [2] is much nicer. I can turn it into a
> patch, if you are short on time.
> 
> With [1] and [2] applied, the dead lock and memory accounting warnings
> are gone, when running `test_sockmap`.
> 
> Thanks,
> Jakub
> 
> [1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/

Cong, what do you think? I tend to agree [2] looks nicer to me.

@Jakub,

Also I think we could simply drop the proposed cancel_work_sync in
sock_map_close()?

 }
@@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
-	sk_psock_put(sk, psock);
+	sk_psock_stop(psock);
 	release_sock(sk);
+	cancel_work_sync(&psock->work);
+	sk_psock_put(sk, psock);
 	saved_close(sk, timeout);
 }

The sk_psock_put is going to cancel the work before destroying the psock,

 sk_psock_put()
   sk_psock_drop()
     queue_rcu_work(system_wq, psock->rwork)

and then in callback we

  sk_psock_destroy()
    cancel_work_synbc(psock->work)

although it might be nice to have the work cancelled earlier rather than
latter maybe.

Thanks,
John
