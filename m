Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0226A227D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjBXTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBXTpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:45:25 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978C92DE5C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:45:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d30so1633842eda.4
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a6XJ4bJS5vos0L9L8BVvF+8Nuw4Y4G4sJTgJeqMIGVQ=;
        b=PKYUM0ZXqnmDqLQqi2S+LP8kz2ULQSLkvuVmr02BlJ6DqJzwQLxBui5t8UK4nAQVOu
         /93KASQPUXWYs+8gqCGvI5rF7Z66KOWND9DYXTdbwUKYxDpGmE349B6EVrmA3Mpax2+G
         QZs428TFZlUxH5KL0JA0rG3nCLRoIpdujLEQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6XJ4bJS5vos0L9L8BVvF+8Nuw4Y4G4sJTgJeqMIGVQ=;
        b=XH2QzKfTO7MTNsMUc4RUw7dx/FlCr72/D7z4t/w4URNiE6LEZRUHPxN+zjZPO7geyA
         00Uyoj9XTsJUS7GGi9WGZS+TTm3KMAXAbBb2aft0/pjTsw9nsY6BSlWJ3DZIcZRT9DDe
         Ejc6VoAmWwnTuKUOVjmMQZMfaIuxfkJpmhXTCuMQHzm+xjgaT/XwxO5xPMKF7icx47H6
         fyPaWE3gVdlzFylqvSaivOTwbhAIng+RFXX0TAstbqGC7V6fI5RFfk+eD7MrzKRAuSb1
         2T7cYsgNjPIC0wQa5Q8TVyne7pf1ieAeJpo3YgE9hmgKYkdv8lU76bbOSeIfScSDnc9M
         TjlQ==
X-Gm-Message-State: AO0yUKUL2UYhYs+AjGyhflXNIFBtv21X1ir4p88sxefs17mOsm0I0JRd
        nyvbRFf8LiOOdkzjxtPbHZBkJ0s7GSN2YyxImE3aBA==
X-Google-Smtp-Source: AK7set+JSDdMD7s8/nphJheZAeGzGwuxG5r04ZdbaNoxajI97Y2SLXSx1FmiDqK4hJfNd/8+BsL+RQ==
X-Received: by 2002:aa7:c441:0:b0:4a2:588f:b3c5 with SMTP id n1-20020aa7c441000000b004a2588fb3c5mr18028726edr.21.1677267915550;
        Fri, 24 Feb 2023 11:45:15 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id jz19-20020a17090775f300b008b17cc28d3dsm10289424ejc.20.2023.02.24.11.45.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:45:15 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id ec43so1543175edb.8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:45:14 -0800 (PST)
X-Received: by 2002:a50:f694:0:b0:4ad:6d57:4e16 with SMTP id
 d20-20020a50f694000000b004ad6d574e16mr8110634edn.5.1677267914696; Fri, 24 Feb
 2023 11:45:14 -0800 (PST)
MIME-Version: 1.0
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
 <dff29d82-9c4b-1933-c1c1-a3becf2a0f1f@lwfinger.net>
In-Reply-To: <dff29d82-9c4b-1933-c1c1-a3becf2a0f1f@lwfinger.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 11:44:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=whwDRefJJq0K8bXXSNY3-Zy8=Z3ZiKYh2mOOvfT-MqNhA@mail.gmail.com>
Message-ID: <CAHk-=whwDRefJJq0K8bXXSNY3-Zy8=Z3ZiKYh2mOOvfT-MqNhA@mail.gmail.com>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 7:45 AM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> Although this patch will stop the log spamming that I see, it will not provide
> much information upstream for fixing the problems.

Generally, I think we've been happy with the "warn once".

Does it mean that if *multiple* different programs do this, we only
get a warning for the first one? Yes. But *users* don't actually care.
They can't do much about it.

And the people who *can* do things about it - ie the distro
maintainers - generally just need to be aware of, and fix, just one or
two cases anyway. If there are many more than that, then the warning
is bogus anyway, because deprecation is clearly the wrong thing.

So I personally think that "warn once" is much better than the "keep
some big array of names around" so that you can warn multiple times
patch I saw flying past.

That said, I would *not* object to "keep a single word of hashed bits"
around kind of model.  In fact, I've wanted something like that for
other situations.

So it might be interestring to have a "warn_once_per_comm()" thing,
that basically has a u32-sized "these hashes have been warned about",
and it does something like

 - hash current 'comm[]' contents

 - if the hash bit is not set in that single word, then warn, and set the bit.

IOW, it would turn a "warn_once()" into a "warn at most 32 times, and
at most once per comm[]" thing.

And it would use no more space for the "did I already warn" than just
a plain "warn_once()" does.

The hash doesn't need to be all that smart, and we would want it to be
fairly low-overhead. No need to make it some complicated
cryptographically secure hash. It could literally be something like

        u32 hash_comm(struct task_struct *t, unsigned int bits)
        {
                /* No need for locking, we're just hashing anyway */
                u32 val = READ_ONCE(*(u32 *)t->comm);
                return hash_32(val, bits);
        }

and then the "pr_warn_once_per_comm()" would do something like

        static u32 warned_mask;
        u32 mask = hash_comm(current, 5);
        if ((mask & warned_mask) == 0) {
                warned_mask |= mask;   // thread data race - we don't care
                pr_warn(..)
        }

which is all fairly simple and straightforward and not horribly inefficient.

You *could* improve on it further by having some kind of timed
rate-limiting, where every 24 hours you'd clear the warning mask, so
that you'd warn about these things once a day. That *can* be useful
for when people just don't notice the warning the first time around,
and "once a day" is not a horribly problem that fills up the logs like
the current situation does.

But again - I personally think even just a pr_warn_once() is likely
good enough. Because all I want is to not have that horrible
log-flushing behavior.

                 Linus
