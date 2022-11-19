Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0146630EF1
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 14:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiKSNS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 08:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKSNS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 08:18:26 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D23893CCE
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:18:21 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i10so19172854ejg.6
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=sNHumfZH7GIktEkQKKet5fI7knMtfYNzJTKk2+gwKao=;
        b=PDskm6HmKQbALBxhOOVdb+wmr4uEO00XhXVWPwkCSwVPEeWl8bfEncvs4ubMW/wc3x
         PlIG39l3n/ZpaIeeHkZtXxCQHqWKm7tdGWrbVFErNTU0KlugJot0d8ALxJ5sZ9oSLHEr
         LvSO/stwz/mGPahKgcCxNwtbvQGqkU7zeqGEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNHumfZH7GIktEkQKKet5fI7knMtfYNzJTKk2+gwKao=;
        b=VEg5GMpo0BvjFgGsVtcdUOjaT5XjZkpr6SLe8wJKRoBHSXEqpBhcHbZaune2Md3GNc
         SCt66c7ggdPhfNpU98bX1+WHPqSwYUBcytXJ49rLz5o/ad3ODiHkIQrYn3sz4ySfvf5f
         OWlqQRl8d1ozFIi+gJgfZx7z/0GnvEIBhSPhzJbR5cpMwHAl2scMIQg0s7xY4yFR7bvI
         6TeFSHiaYAflmsDg+RT94E6C1y8pKERFd3zN2ZbtbgYlxP5IrnZUspB3s87DXYnxeTA5
         zTvtQQPLP3XSiNfnFDTPQ+Ckhdbg+C90NfgnRWN3mra0n4kuYGD3xHXLvMySWU+HWsQ9
         /0PA==
X-Gm-Message-State: ANoB5pnvfFaDrl4bo+hIJaFpNvyLeVbWxkz82asyX2Y8T61HxyDEyVJD
        jCLJzFKPVyLAoTt7N/lQ78oRtw==
X-Google-Smtp-Source: AA0mqf7GkBarWULpzNKtOfaxKfY0pwLRrSxO6mjOTnc9ITXA8v+797S3lTwxk9rIpDOhX+ouuV4Q4g==
X-Received: by 2002:a17:907:b689:b0:78c:f5a1:86bf with SMTP id vm9-20020a170907b68900b0078cf5a186bfmr9244459ejc.245.1668863899621;
        Sat, 19 Nov 2022 05:18:19 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id kx21-20020a170907775500b0078128c89439sm2868812ejc.6.2022.11.19.05.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 05:18:19 -0800 (PST)
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
 <87zgconn3g.fsf@cloudflare.com>
 <c4685015-ee4f-598c-0e2f-70e0737f4685@I-love.SAKURA.ne.jp>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Date:   Sat, 19 Nov 2022 14:13:07 +0100
In-reply-to: <c4685015-ee4f-598c-0e2f-70e0737f4685@I-love.SAKURA.ne.jp>
Message-ID: <87cz9julph.fsf@cloudflare.com>
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

On Sat, Nov 19, 2022 at 07:08 PM +09, Tetsuo Handa wrote:
> On 2022/11/19 2:50, Jakub Sitnicki wrote:
>> Thanks for the patch, Tetsuo.
>> 
>> As Eric has pointed out [1], there is another problem - in addition to
>> sleeping in atomic context, I have also failed to use the write_lock
>> variant which disabled BH locally.
>> 
>> The latter bug can lead to dead-locks, as reported by syzcaller [2, 3],
>> because we grab sk_callback_lock in softirq context, which can then
>> block waiting on us if:
>
> Below is another approach I was thinking of, for reusing existing locks is prone
> to locking bugs like [2] and [3].
>
> I couldn't interpret "Write-protected by @sk_callback_lock." part because
> it does not say what lock is needed for protecting sk_user_data for read access.

sk_user_data is RCU-protected on reader-side. But we still need to
synchronize writers.

> Is it possible to use a mutex dedicated for l2tp_tunnel_destruct() (and optionally
> setup_udp_tunnel_sock_no_enable() in order not to create l2tp_tunnel_register_mutex =>
> cpu_hotplug_lock chain) ?

No, we need to a common lock to synchronize with other users in the net
stack (reuseport groups, sockmap/psock to name a couple).

> By the way I haven't heard an response on
>
>   Since userspace-supplied file descriptor has to be a datagram socket,
>   can we somehow copy the source/destination addresses from
>   userspace-supplied socket to kernel-created socket?
>
> at https://lkml.kernel.org/r/c9695548-3f27-dda1-3124-ec21da106741@I-love.SAKURA.ne.jp
> (that is, always create a new socket in order to be able to assign lockdep class
> before that socket is used).

This is a drive by fix for me to l2tp, so I might not be the best person
to ask, but I will take a look at the thread.

[...]
