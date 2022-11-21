Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB83163309D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 00:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiKUXQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 18:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiKUXQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 18:16:03 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B8DC6555
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 15:16:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l24so5786313edj.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 15:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=0x2ojoXCucbYuUI+lld5ek4zs2GkVNjasksmypRJbZo=;
        b=G8+w/TQ/9BmZ9uCeAoQIh1n3lFouDQszUS0jMx76ugUq2w0EDtAKAe4973OR/7F2aT
         C/2Ig16IVwtaJ1bPkT6TR00ETcVU+/+KAEBZDc9eXBEeHecizKceFSj2+iWQE91zfjD+
         Su3DTr5O3qCXqe/M5TEfwvjWyYdl3UvRbYv9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0x2ojoXCucbYuUI+lld5ek4zs2GkVNjasksmypRJbZo=;
        b=wn/iTZ/uERL09vt4o/Q+KR1wJlDzGd+0bFQngogy9Cgq5770oqII6ASk5ogQr/KH3l
         BuigYA0Y1SnFafNBnbMkIX8vYQHLF1Aei0PXS3y5lyIy6Q3b3MaWuf94oEPpnsBAZmJZ
         u6m9SlR8psFsizUJr01MxD1RqG95f00hW82FPqacnQHbi3Ze2JtACdmJ/fTmJPqmRreU
         I4e4V7KSPLyVnQfpuyZXisAO1+8TvjQdq+6Q9PS7WyUNuuy3O6XUZdAKladoG8ZU9J+0
         V1JWDjBWq/QAC/HCT17hqU5m55vZJtN4Z0Hyh+kr2p8EfIUtVTxVvRFwdt4XkVFTzH4C
         M+4Q==
X-Gm-Message-State: ANoB5plIm8YfPUr9q2l3a/cphU+l51ieNkofPw2wubPamraCTNqs/F7B
        9jVsDZtggiOlmbXYu/Dqdf0qhhd0mOzofg==
X-Google-Smtp-Source: AA0mqf6zBEff7Zz80R980VLpZzpDM2/7kgjOn1Fm1MBxScilAeZdmxYL1OEzv6McSKgxkvW5uxS5Cg==
X-Received: by 2002:a05:6402:149:b0:458:cc1b:a273 with SMTP id s9-20020a056402014900b00458cc1ba273mr5242141edu.92.1669072559609;
        Mon, 21 Nov 2022 15:15:59 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id o7-20020aa7c7c7000000b00463c475684csm5671033eds.73.2022.11.21.15.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 15:15:59 -0800 (PST)
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Date:   Mon, 21 Nov 2022 22:55:44 +0100
In-reply-to: <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
Message-ID: <87fseb7vbm.fsf@cloudflare.com>
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

On Mon, Nov 21, 2022 at 07:03 PM +09, Tetsuo Handa wrote:
> On 2022/11/21 18:00, Jakub Sitnicki wrote:
>>> Is it safe to temporarily set a dummy pointer like below?
>>> If it is not safe, what makes assignments done by
>>> setup_udp_tunnel_sock() safe?
>> 
>> Yes, I think so. Great idea. I've used it in v2.
>
> So, you are sure that e.g.
>
> 	udp_sk(sk)->gro_receive = cfg->gro_receive;
>
> in setup_udp_tunnel_sock() (where the caller is passing cfg->gro_receive == NULL)
> never races with e.g. below check (because the socket might be sending/receiving
> in progress since the socket is retrieved via user-specified file descriptor) ?
>
> Then, v2 patch would be OK for fixing this regression. (But I think we still should
> avoid retrieving a socket from user-specified file descriptor in order to avoid
> lockdep race window.)
>
>
> struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>                                 struct udphdr *uh, struct sock *sk)
> {
> 	(...snipped...)
>         if (!sk || !udp_sk(sk)->gro_receive) {
> 		(...snipped...)
>                 /* no GRO, be sure flush the current packet */
>                 goto out;
>         }
> 	(...snipped...)
>         pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
> out:
>         skb_gro_flush_final(skb, pp, flush);
>         return pp;
> }
>

First, let me say, that I get the impression that setup_udp_tunnel_sock
was not really meant to be used on pre-existing sockets created by
user-space. Even though l2tp and gtp seem to be doing that.

That is because, I don't see how it could be used properly. Given that
we need to check-and-set sk_user_data under sk_callback_lock, which
setup_udp_tunnel_sock doesn't grab itself. At the same time it might
sleep. There is no way to apply it without resorting to tricks, like we
did here.

So - yeah - there may be other problems. But if there are, they are not
related to the faulty commit b68777d54fac ("l2tp: Serialize access to
sk_user_data with sk_callback_lock"), which we're trying to fix. There
was no locking present in l2tp_tunnel_register before that point.

>> 
>> We can check & assign sk_user_data under sk_callback_lock, and then just
>> let setup_udp_tunnel_sock overwrite it with the same value, without
>> holding the lock.
>
> Given that sk_user_data is RCU-protected on reader-side, don't we need to
> wait for RCU grace period after resetting to NULL?

Who would be the reader?

If you have l2tp_udp_encap_recv in mind - the encap_rcv callback has not
been set yet, if we are on the error handling path in
l2tp_tunnel_register.

In general, though, yes - I think you are right. We must synchronize_rcu
before we kfree the tunnel.

However, that is also not related to the race to check-and-set
sk_user_data, which commit b68777d54fac is trying to fix.
