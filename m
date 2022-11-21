Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA59631C4D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiKUJDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKUJDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:03:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2FF6DCCE
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:03:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l24so2703734edj.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=UB1MfhNwZW6ubazXZ6eesXGjaNDuQLnoqWVlBtiJzkM=;
        b=fnLqr6bPx15rfA08GN5Fjlh4yXMkQEvaoc/8Cu/nADLEWKUGIPF1TqnCzFx8yEzr0Z
         S/Pr2VueriRrXfWEjKEzNSfh4MNPhtOeh9qFpIsDz111yURKJmVy0aA1qkcsplilUQUv
         AP9L1+4ZWQA5r6wVJZ2zqbf4G61QwYDNQYd54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UB1MfhNwZW6ubazXZ6eesXGjaNDuQLnoqWVlBtiJzkM=;
        b=GeqHZI3XT8jBacpfx8MWK1DT0D/WtNjwWQ6e0hvVNzpxjjmyDwm12YWHmlzdq2Sl2M
         9HLUTKzgfpr8St2uc/+rQH5xqdwgRNYSkInGvutoRl7EBvKd8e+NUvZRsvlKOFhcURjo
         j+mBqYBRQQY5jeDv2+L39mFQ6HxQkMx5Un5KYxuyycgOth3nltC6tAIQEdNLgu4kEU6h
         C5SPzrmneRiZSg/A5itxDyWmWseU6En+EQQkxp5WQgyxhGzxNhDbkdhOj2uGYc1CoES2
         CruNfG/VT5EFV45HxdM6YoY8vVxoqSKfwmWqiLR5/YrOlEb4rpxgL3ROs9D5N0U7G+MR
         h1vw==
X-Gm-Message-State: ANoB5pnOJXdFpCcSxHohquUIB+tv7sGZiNWW7PJOzLz01VQfqzdOjbNm
        g3kTnCdgoCweH+gmePVMazwXtA==
X-Google-Smtp-Source: AA0mqf4mzAWbnCBclDcmi2quMF6lNU3kbfwzw/p9IK4AJtu+8fct5KB1i9cH7vzAd3fVDYvR6IMzxA==
X-Received: by 2002:a05:6402:1015:b0:461:5f19:61da with SMTP id c21-20020a056402101500b004615f1961damr15235097edu.34.1669021417391;
        Mon, 21 Nov 2022 01:03:37 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id d12-20020a170906304c00b007b29a6bec28sm4772372ejd.27.2022.11.21.01.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:03:37 -0800 (PST)
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
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
Date:   Mon, 21 Nov 2022 10:00:58 +0100
In-reply-to: <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
Message-ID: <87wn7o7k7r.fsf@cloudflare.com>
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

On Sat, Nov 19, 2022 at 11:27 PM +09, Tetsuo Handa wrote:
> On 2022/11/19 22:52, Tetsuo Handa wrote:
>> On 2022/11/19 22:03, Jakub Sitnicki wrote:
>>> When holding a reader-writer spin lock we cannot sleep. Calling
>>> setup_udp_tunnel_sock() with write lock held violates this rule, because we
>>> end up calling percpu_down_read(), which might sleep, as syzbot reports
>>> [1]:
>>>
>>>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
>>>  percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
>>>  cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
>>>  static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
>>>  udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
>>>  setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
>>>  l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
>>>  pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
>>>
>>> Trim the writer-side critical section for sk_callback_lock down to the
>>> minimum, so that it covers only operations on sk_user_data.
>> 
>> This patch does not look correct.
>> 
>> Since l2tp_validate_socket() checks that sk->sk_user_data == NULL with
>> sk->sk_callback_lock held, you need to call rcu_assign_sk_user_data(sk, tunnel)
>> before releasing sk->sk_callback_lock.
>> 
>
> Is it safe to temporarily set a dummy pointer like below?
> If it is not safe, what makes assignments done by
> setup_udp_tunnel_sock() safe?

Yes, I think so. Great idea. I've used it in v2.

We can check & assign sk_user_data under sk_callback_lock, and then just
let setup_udp_tunnel_sock overwrite it with the same value, without
holding the lock.

I still think that it's best to keep the critical section as short as
possible, though.

[...]
