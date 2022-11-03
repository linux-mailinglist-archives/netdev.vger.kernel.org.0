Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311386188C6
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKCTbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCTbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:31:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9098211C21
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 12:31:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z18so4592327edb.9
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=YE1Kp09sLNyKpfsmwx6JUQ7q7fbxLdhezTdAhjlnhQU=;
        b=pC1voNXN6UQeNvDsX19drxlZGlNxicakJZUp1D7TOo5RCHDRZkfdIg/BNNQNTtD3n5
         ovyD/ElHOjtOhrcLJsv47YkW3irji7kfcnyZAUde3Yf6nTiCvRWNN+ApIkvM91St65np
         QNDxTH6JEL9lQ4C1V9bs/I5v2fOnPvjv3Y3PM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YE1Kp09sLNyKpfsmwx6JUQ7q7fbxLdhezTdAhjlnhQU=;
        b=i5mQGw3eHWYVi1eb0caOQ/91iaF7tA263lx5Zrso4yA1+jEbtqRS+5emU0I0AfvGHq
         qUmmlGQnA9TnNCvOoYOi0ncJf35in+79Rf4U2UOqz9spdiMr5zDq7D9zEgrGadN+vpQJ
         /OraVx9eNhL1ozE3xAhlbol0qcwAsYmRxI8qZkMXg8OauCjLnYK4xXebetSZxNvG+r+F
         jxxjr7LTKoLAaDEdVtHHZM6foC3AF/zrbWoFSStZG2FEjGsGJcpXCrJ/JsaiEoJ7ONXU
         1zqjCpoU0N4XGIN3q8Ku/M5UGTHHisvMnbL1WT6ktXR/rkXFmbH+Ig/95JN+OwP28STK
         jsgQ==
X-Gm-Message-State: ACrzQf2YNj5NnJNFvUwzEbvSi1rZtdmjHIFom3cwf5T/jJO3lKAMkoPX
        gvnZYvHrj6QIzykxmZdBu61Vgg==
X-Google-Smtp-Source: AMsMyM6e5jCPRrkIAGXQadd/BUIlSqjsSNl7C5UBe3zUID0suaG7XA140Dnjg94Y3qOebSXHD0IS0A==
X-Received: by 2002:aa7:cf83:0:b0:463:1b7d:e318 with SMTP id z3-20020aa7cf83000000b004631b7de318mr27082294edx.4.1667503861009;
        Thu, 03 Nov 2022 12:31:01 -0700 (PDT)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id kv5-20020a17090778c500b00780f6071b5dsm835246ejc.188.2022.11.03.12.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:31:00 -0700 (PDT)
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
 <Y07sxzoS/s6ZBhEx@google.com> <87eduxfiik.fsf@cloudflare.com>
 <Y1wqe2ybxxCtIhvL@pop-os.localdomain> <87bkprprxf.fsf@cloudflare.com>
 <63617b2434725_2eb7208e1@john.notmuch>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>, sdf@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Date:   Thu, 03 Nov 2022 20:22:04 +0100
In-reply-to: <63617b2434725_2eb7208e1@john.notmuch>
Message-ID: <87a6574yz0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 01:01 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Fri, Oct 28, 2022 at 12:16 PM -07, Cong Wang wrote:
>> > On Mon, Oct 24, 2022 at 03:33:13PM +0200, Jakub Sitnicki wrote:
>> >> On Tue, Oct 18, 2022 at 11:13 AM -07, sdf@google.com wrote:
>> >> > On 10/17, Cong Wang wrote:
>> >> >> From: Cong Wang <cong.wang@bytedance.com>
>> >> >
>> >> >> Technically we don't need lock the sock in the psock work, but we
>> >> >> need to prevent this work running in parallel with sock_map_close().
>> >> >
>> >> >> With this, we no longer need to wait for the psock->work synchronously,
>> >> >> because when we reach here, either this work is still pending, or
>> >> >> blocking on the lock_sock(), or it is completed. We only need to cancel
>> >> >> the first case asynchronously, and we need to bail out the second case
>> >> >> quickly by checking SK_PSOCK_TX_ENABLED bit.
>> >> >
>> >> >> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
>> >> >> Reported-by: Stanislav Fomichev <sdf@google.com>
>> >> >> Cc: John Fastabend <john.fastabend@gmail.com>
>> >> >> Cc: Jakub Sitnicki <jakub@cloudflare.com>
>> >> >> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> >> >
>> >> > This seems to remove the splat for me:
>> >> >
>> >> > Tested-by: Stanislav Fomichev <sdf@google.com>
>> >> >
>> >> > The patch looks good, but I'll leave the review to Jakub/John.
>> >> 
>> >> I can't poke any holes in it either.
>> >> 
>> >> However, it is harder for me to follow than the initial idea [1].
>> >> So I'm wondering if there was anything wrong with it?
>> >
>> > It caused a warning in sk_stream_kill_queues() when I actually tested
>> > it (after posting).
>> 
>> We must have seen the same warnings. They seemed unrelated so I went
>> digging. We have a fix for these [1]. They were present since 5.18-rc1.
>> 
>> >> This seems like a step back when comes to simplifying locking in
>> >> sk_psock_backlog() that was done in 799aa7f98d53.
>> >
>> > Kinda, but it is still true that this sock lock is not for sk_socket
>> > (merely for closing this race condition).
>> 
>> I really think the initial idea [2] is much nicer. I can turn it into a
>> patch, if you are short on time.
>> 
>> With [1] and [2] applied, the dead lock and memory accounting warnings
>> are gone, when running `test_sockmap`.
>> 
>> Thanks,
>> Jakub
>> 
>> [1] https://lore.kernel.org/netdev/1667000674-13237-1-git-send-email-wangyufen@huawei.com/
>> [2] https://lore.kernel.org/netdev/Y0xJUc%2FLRu8K%2FAf8@pop-os.localdomain/
>
> Cong, what do you think? I tend to agree [2] looks nicer to me.
>
> @Jakub,
>
> Also I think we could simply drop the proposed cancel_work_sync in
> sock_map_close()?
>
>  }
> @@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
>  	saved_close = psock->saved_close;
>  	sock_map_remove_links(sk, psock);
>  	rcu_read_unlock();
> -	sk_psock_stop(psock, true);
> -	sk_psock_put(sk, psock);
> +	sk_psock_stop(psock);
>  	release_sock(sk);
> +	cancel_work_sync(&psock->work);
> +	sk_psock_put(sk, psock);
>  	saved_close(sk, timeout);
>  }
>
> The sk_psock_put is going to cancel the work before destroying the psock,
>
>  sk_psock_put()
>    sk_psock_drop()
>      queue_rcu_work(system_wq, psock->rwork)
>
> and then in callback we
>
>   sk_psock_destroy()
>     cancel_work_synbc(psock->work)
>
> although it might be nice to have the work cancelled earlier rather than
> latter maybe.

Good point.

I kinda like the property that once close() returns we know there is no
deferred work running for the socket.

I find the APIs where a deferred cleanup happens sometimes harder to
write tests for.

But I don't really have a strong opinion here.

-Jakub
