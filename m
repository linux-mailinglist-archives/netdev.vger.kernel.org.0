Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CDE631C47
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiKUJBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiKUJAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:55 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93483EB7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:53 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f7so15256199edc.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Zrgtw0c3wlZA/yLqn73oinTIP8rBDSYjdfY3JiqY95Y=;
        b=FX92/3g89aBBdGw8DVUZGivQJtvneU1hhd40rtHhxDy5+vjd7eQ0L87fFyeaDv8eYr
         jWTLHFoyISLLTOyo0qY/XsJZHuNONd2R315irYa7X9+iZDp2gyi8IjLrO8VVxUt0Wbq6
         nbN9rZzw8TzlT2pLFC1zrInmaOSK6bFBf2Hbw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zrgtw0c3wlZA/yLqn73oinTIP8rBDSYjdfY3JiqY95Y=;
        b=cISg8JMWIcgoVtWeivacCeU7CeQRMbTPEm8FhH7ijddrQsVa5MqjZ9s28U504yYAbl
         ckaDs75vSEy7GSO4DfUdFXUKoFnoSjoOj3klkT8aJZRF04rZLiZuhAImibHcoboBwgKa
         rtvuZYnsDFlFR5CF0OoO4N6tyngofhKnYuUE5ACCGVnk+xQNo16b87edy7CTsU0QotH9
         KyY+xrtbod3+5hjI9hQ6EJ1Cvn0xOQ19H/joXTHGq4LPFk0rJRzuqbclBnrfC7wm83C9
         HKEMHvfv3R1PlYnqFv2uioukJwmbIeH0LHTWhzK5Q5vQeN2xrEE1WGk21m+hE/bWGl2N
         l8cQ==
X-Gm-Message-State: ANoB5pk4YB2mW18WFjvuhyNDLJfwZjnB2lZ1p1ZbnBW9hYiszOtQ11l6
        ZK235JtLnP9gmFiWw9A1gRwMItCKBJOWYw==
X-Google-Smtp-Source: AA0mqf4MGMXQsd1mc/MxFUt+u3uLWv4Oy/01mFKD/PLMtVjf08N7BVrEO9u9Jr2/Zin1BUalzVCURQ==
X-Received: by 2002:a05:6402:419:b0:461:e82b:bdff with SMTP id q25-20020a056402041900b00461e82bbdffmr14717759edv.370.1669021251799;
        Mon, 21 Nov 2022 01:00:51 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id x20-20020a170906805400b007919ba4295esm4791867ejw.216.2022.11.21.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:00:51 -0800 (PST)
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
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
Date:   Mon, 21 Nov 2022 10:00:09 +0100
In-reply-to: <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
Message-ID: <871qpw8ywt.fsf@cloudflare.com>
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

On Sat, Nov 19, 2022 at 10:52 PM +09, Tetsuo Handa wrote:
> On 2022/11/19 22:03, Jakub Sitnicki wrote:
>> When holding a reader-writer spin lock we cannot sleep. Calling
>> setup_udp_tunnel_sock() with write lock held violates this rule, because we
>> end up calling percpu_down_read(), which might sleep, as syzbot reports
>> [1]:
>> 
>>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
>>  percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
>>  cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
>>  static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
>>  udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
>>  setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
>>  l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
>>  pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
>> 
>> Trim the writer-side critical section for sk_callback_lock down to the
>> minimum, so that it covers only operations on sk_user_data.
>
> This patch does not look correct.
>
> Since l2tp_validate_socket() checks that sk->sk_user_data == NULL with
> sk->sk_callback_lock held, you need to call rcu_assign_sk_user_data(sk, tunnel)
> before releasing sk->sk_callback_lock.

You're right. v2 posted:

https://lore.kernel.org/netdev/20221121085426.21315-1-jakub@cloudflare.com/
