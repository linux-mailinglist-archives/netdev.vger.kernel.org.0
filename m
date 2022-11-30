Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA563D253
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbiK3JqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiK3JqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:46:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9186A1D337;
        Wed, 30 Nov 2022 01:46:01 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d3so11149694plr.10;
        Wed, 30 Nov 2022 01:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=+w/tU+ayhTwkehfOK8SHtMU808QnEhUkne08i443iwo=;
        b=GPiGiD4M+pymUFT990D5jqPZdlbcZSruG5C354xy/PsGPCT3F6u/R/Dz2aVF7yIAnW
         czJFIxQzc1HdNjo66a9ChzO6vFKiaXy6Fbb7qqHZEsPJtGbDmwZWpN8K3w5Jstwm878s
         d4WZW1cr2lzKsiA8WK324+hGyXSogk56VD06B8nLIxIDu8iK28uYExiYS9b0/04Sy7HU
         vaAVlLNCEj2LL8xAug1LgidmEWOhMuRWrDOzXuHJHraTUcXIjv2Ke72ytlb9Jn8YmZsd
         5vnS/CxQ+jFG5ohQu4+3Ms1zE1PEoqW1rwSsw+rO6tgkJYOH87b2+2hDYJakqmEogbzO
         rqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+w/tU+ayhTwkehfOK8SHtMU808QnEhUkne08i443iwo=;
        b=rlKeUnKd4yT2PhfjBdJBQydOHkuM7mLRgfycVXYkvyjYy0zjoBWTz/DqPCu+v6VG0E
         kSGnYt1nOMmgDvqfL8SsVlSlL0N6sGQWhTiXdfvQ2/+4Y6oyQUECq7zMwFa+2lD0YmBt
         Y09FDPGxT2JkZdRY1Y4cXzWQpBSEmtBo4k+NlIFJNlzB7DbtG1dcXlZ3NQoFN5DjEVRU
         h6wdz5MAGMBrXBCLUsHU9r2E0it3cqamLaBQzCKuTQdGFKbiLBLU8gLTXJGPvpSQpPxB
         0/EbH2+tRUjSibGvBg1EGK/RVL7BRIZ08ZcyqbQpj1dR+YQdYmu/saIAqefXGZKmEKAI
         Lwpw==
X-Gm-Message-State: ANoB5pkuLwmavdY0LkJTeM31ZPnbNjixPRjfWv9gQC1nUZxPRBRZvX4u
        5yVk0XsTCVMAKoRK5Oj3bUw=
X-Google-Smtp-Source: AA0mqf7tK9vXUEqI2FDTGVCOJFqDEG4Yorq6ZMneFnQ17ErDPUBAP+TM8MzmjoFH33rAZdYV4XG9fA==
X-Received: by 2002:a17:90b:3c0a:b0:213:5de3:13e with SMTP id pb10-20020a17090b3c0a00b002135de3013emr70472277pjb.6.1669801560993;
        Wed, 30 Nov 2022 01:46:00 -0800 (PST)
Received: from MBP ([39.170.101.209])
        by smtp.gmail.com with ESMTPSA id 24-20020a631358000000b004393f60db36sm676368pgt.32.2022.11.30.01.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 01:46:00 -0800 (PST)
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org> <m2r0xli1mq.fsf@gmail.com>
 <Y4b1MQaEsPRK+3lF@codewreck.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Wed, 30 Nov 2022 16:14:32 +0800
In-reply-to: <Y4b1MQaEsPRK+3lF@codewreck.org>
Message-ID: <m2o7sowzas.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


asmadeus@codewreck.org writes:

> (fixed Christophe's address, hopefully that will do for good...)
>
> Schspa Shi wrote on Wed, Nov 30, 2022 at 10:22:44AM +0800:
>> > I'm happy to believe we have a race somewhere (even if no sane server
>> > would produce it), but right now I don't see it looking at the code.. :/
>> 
>> And I think there is a race too. because the syzbot report about 9p fs
>> memory corruption multi times.
>
> Yes, no point in denying that :)
>
>> As for the problem, the p9_tag_lookup only takes the rcu_read_lock when
>> accessing the IDR, why it doesn't take the p9_client->lock? Maybe the
>> root cause is that a lock is missing here.
>
> It shouldn't need to, but happy to try adding it.
> For the logic:
>  - idr_find is RCU-safe (trusting the comment above it)
>  - reqs are alloced in a kmem_cache created with SLAB_TYPESAFE_BY_RCU.
>  This means that if we get a req from idr_find, even if it has just been
>  freed, it either is still in the state it was freed at (hence refcount
>  0, we ignore it) or is another req coming from the same cache (if

If the req was newly alloced(It was at a new page), refcount maybe not
0, there will be problem in this case. It seems we can't relay on this.

We need to set the refcount to zero before add it to idr in p9_tag_alloc.

>  refcount isn't zero, we can check its tag)

As for the release case, the next request will have the same tag with
high probability. It's better to make the tag value to be an increase
sequence, thus will avoid very much possible req reuse.

>  The refcount itself is an atomic operation so doesn't require lock.
>  ... And in the off chance I hadn't considered that we're already
>  dealing with a new request with the same tag here, we'll be updating
>  its status so another receive for it shouldn't use it?...
>
> I don't think adding the client lock helps with anything here, but it'll
> certainly simplify this logic as we then are guaranteed not to get
> obsolete results from idr_find.
>
> Unfortunately adding a lock will slow things down regardless of
> correctness, so it might just make the race much harder to hit without
> fixing it and we might not notice that, so it'd be good to understand
> the race.


-- 
BRs
Schspa Shi
