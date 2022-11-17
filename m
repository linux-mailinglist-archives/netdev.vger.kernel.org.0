Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DFC62D79D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiKQJ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiKQJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:58:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E75A6DB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:57:18 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z18so1757982edb.9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=U25kKEptb9pJlM8R4VKy1NNUUpW/KsvoS3ux9OOQkFU=;
        b=iLBBrcj+KAH5LLe3UpgATIHpSs1Rv7cMVJRV6CbP9xEVppSSvhihtjUwqM1OFhG8n4
         Pu0kNHufaMSgn80zuQye6FjMUIQuP+tkbQ+XaG+GiZdDkaVWGFl9fKzmbCoP++Upgz5m
         RLXFgDrEp0Lq/nT6d426Cw8D37OVUPNyY7P1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U25kKEptb9pJlM8R4VKy1NNUUpW/KsvoS3ux9OOQkFU=;
        b=CW54wECv7eqZ9YBzQ/TPi4DIa58180skrMCBPKiZh93T0XQu1I+91W/pSCcARFm2Yc
         Cv+X9SDh11UcSBNxiWK8fog7P/XtXs5eCj0FXwNrRfm0/vomTuZecSQQBFbZX7lNDFRE
         PqYQINdgwHI2vJSdcStHlodWoimdavLCBFGuwZO02y9jXEAEQv5vxkqtuYX1ifKodhXj
         O3pfPl3Ilh4nTt8iwyXTnZMcvIon3oIa+HWzks3grRYNJkmsiTBYhP7oxPuoHVVbxWfv
         nL9dioKj7uqx8LGYBVzM9/882tjAI3ban3SPIeM5N7Hhv/q2PZ2JEyAAQcg1qMiz0XCM
         FPwQ==
X-Gm-Message-State: ANoB5pl39O1axk9QBcHuchWd+YHS9zrbohGVAdTG+MdY11YaCeEXWR6l
        r2OChAu+flynaIW+cP5jhIEpWQ==
X-Google-Smtp-Source: AA0mqf7HDpEhoWrsf1kc/TJvhEEra55tb/ArGgXSGKKRkH2zDjOESb9MPZBA0c4BtlhxOGWPEypdXw==
X-Received: by 2002:aa7:c3c2:0:b0:457:791d:8348 with SMTP id l2-20020aa7c3c2000000b00457791d8348mr1474120edr.306.1668679037078;
        Thu, 17 Nov 2022 01:57:17 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id a14-20020a170906684e00b007acc5a42e77sm149518ejs.88.2022.11.17.01.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 01:57:16 -0800 (PST)
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
 <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Thu, 17 Nov 2022 10:55:45 +0100
In-reply-to: <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
Message-ID: <87wn7t29ac.fsf@cloudflare.com>
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

On Thu, Nov 17, 2022 at 01:40 AM -08, Eric Dumazet wrote:
> On Thu, Nov 17, 2022 at 1:07 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>> >
>> > Hello:
>> >
>> > This patch was applied to netdev/net.git (master)
>> > by David S. Miller <davem@davemloft.net>:
>> >
>> > On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
>> > > sk->sk_user_data has multiple users, which are not compatible with each
>> > > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>> > >
>> > > l2tp currently fails to grab the lock when modifying the underlying tunnel
>> > > socket fields. Fix it by adding appropriate locking.
>> > >
>> > > We err on the side of safety and grab the sk_callback_lock also inside the
>> > > sk_destruct callback overridden by l2tp, even though there should be no
>> > > refs allowing access to the sock at the time when sk_destruct gets called.
>> > >
>> > > [...]
>> >
>> > Here is the summary with links:
>> >   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
>> >     https://git.kernel.org/netdev/net/c/b68777d54fac
>> >
>> >
>>
>> I guess this patch has not been tested with LOCKDEP, right ?
>>
>> sk_callback_lock always needs _bh safety.
>>
>> I will send something like:
>>
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
>> 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
>> *tunnel, struct net *net,
>>         }
>>
>>         sk = sock->sk;
>> -       write_lock(&sk->sk_callback_lock);
>> +       write_lock_bh(&sk->sk_callback_lock);
>
> Unfortunately this might still not work, because
> setup_udp_tunnel_sock->udp_encap_enable() probably could sleep in
> static_branch_inc() ?
>
> I will release the syzbot report, and let you folks work on a fix, thanks.

Ah, the problem is with pppol2tp_connect racing with itself. Thanks for
the syzbot report. I will take a look. I live for debugging deadlocks
:-)
