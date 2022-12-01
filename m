Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8563E81A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLADBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLADBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:01:20 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2543B8EE78;
        Wed, 30 Nov 2022 19:01:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 124so675823pfy.0;
        Wed, 30 Nov 2022 19:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5SYxpBI7GimwE3d7ybl3wRGWGVGzAUnabS54e7bxDY=;
        b=QVmCUwKUAtJKgzojk+tHegMuxgfZ1SSDWXFRGkmqn1+O+CvXy5OKQ2XFdG1CeVd7Bo
         Bwbe7nQD6X0NpDYd/EBkW6AMTYounrQR2fi+XR/b3pZvEagupxVrwB3+DgZj3B4UKlXu
         jdBApbJrwR48BDnyY5UZKowEW19kZTBNcz3ksSYpYMH7QE2nAXpbjPhQMdtZL6CyYH92
         fT5mGigSjNfpY4wRo+NjgIAlYFWB42VCfUz/pFh1im9ss6HoBvCBDyQsdUDO+jDAripp
         Tibq0M95/oqjOpk/p9KLZEbr4ewHdPq5L9vDSauevls9E6JoJ+aSy9t3zGaqq5C97PnT
         tz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5SYxpBI7GimwE3d7ybl3wRGWGVGzAUnabS54e7bxDY=;
        b=wRpdcG3p2h/gkMXSldZiyewvTWVRJLwuzM5KX7Zv9IZ4Qkewx5sTkw4gq+EbMWT44n
         CHzlQyiGTLn2Hs5cfkM0xcHmufxAkFkGcsY9pH8aONJ3NCtcxMI6u+RQoWAcyeceACi6
         ksgxwryIiY4jmn74hyiWCSLFxYn3DCfVz0xYgSJAR8fJwJoceEMrks+BgaLHVyvjUypA
         mfaNzukK5Q7jNR7kw/f8aeosOMmLHnsChDTrvoyMtrJImHfFPqsz7m/eTLuytYh166TG
         4Vh3p0F9qbTAB9zNb02zfg0pN0/xJ3miCi/Z9gMRacmRtlSxYK8KPHLvXpmxhsA3Pt1A
         7xuA==
X-Gm-Message-State: ANoB5pkJ3o0yO9jKTevMYAcBbha8FguzQR8gFjRP5/k11v5rniSb0hpG
        4tRCz9kXAK97Z51EbAdAJHg=
X-Google-Smtp-Source: AA0mqf6ld2dBOXvxM8gmaV26TPOYSydDpIAYlOMokeBJQCBRwOIp1gl+JZcMGRsk1U30PeUXcUXnjQ==
X-Received: by 2002:a62:3882:0:b0:56b:9ce2:891f with SMTP id f124-20020a623882000000b0056b9ce2891fmr50778852pfa.43.1669863674575;
        Wed, 30 Nov 2022 19:01:14 -0800 (PST)
Received: from MBP (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id j5-20020a17090a3e0500b00218fb211778sm3742075pjc.41.2022.11.30.19.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 19:01:13 -0800 (PST)
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org> <m2r0xli1mq.fsf@gmail.com>
 <Y4b1MQaEsPRK+3lF@codewreck.org> <m2o7sowzas.fsf@gmail.com>
 <Y4c5N/SAuszTLiEA@codewreck.org> <m2a6487f23.fsf@gmail.com>
 <Y4dcAGM+0xzOgSCa@codewreck.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Thu, 01 Dec 2022 10:26:12 +0800
In-reply-to: <Y4dcAGM+0xzOgSCa@codewreck.org>
Message-ID: <m28rjr6d5f.fsf@gmail.com>
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

> Schspa Shi wrote on Wed, Nov 30, 2022 at 09:15:12PM +0800:
>> >> If the req was newly alloced(It was at a new page), refcount maybe not
>> >> 0, there will be problem in this case. It seems we can't relay on this.
>> >> 
>> >> We need to set the refcount to zero before add it to idr in p9_tag_alloc.
>> >
>> > Hmm, if it's reused then it's zero by definition, but if it's a new
>> > allocation (uninitialized) then anything goes; that lookup could find
>> > and increase it before the refcount_set, and we'd have an off by one
>> > leading to use after free. Good catch!
>> >
>> > Initializing it to zero will lead to the client busy-looping until after
>> > the refcount is properly set, which should work.
>> 
>> Why? It looks no different from the previous process here. Initializing
>> it to zero should makes no difference.
>
> I do not understand this remark.
> If this is a freed request it will be zero, because we freed the request
> as the refcount hit zero, but if it's a newly allocated request then the
> memory is uninitalized, and the lookup can get anything.

Here is my misunderstanding. I thought you meant that there would be a
loop on the client side to wait for the refcount to become a non-zero
value. Actually, there is no such loop.

>
> In that case we want refcount to be zero to have the check in
> p9_tag_lookup to not use the request until we set the refcount to 2.
>
>
>> > Setting refcount early might have us use an re-used req before the tag
>> > has been changed so that one cannot move.
>> >
>> > Could you test with just that changed if syzbot still reproduces this
>> > bug? (perhaps add a comment if you send this)
>> >
>> 
>> I have upload a new v2 change for this. But I can't easily reproduce
>> this problem.
>
> Ah, I read that v2 as you actually ran some tests with this, sorry for
> the misuderstanding.
>
> Well, it's a fix anyway, so it cannot hurt to apply...


-- 
BRs
Schspa Shi
