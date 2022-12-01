Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951CB63F0A6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiLAMex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiLAMew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:34:52 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F673B8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 04:34:51 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3bf4ade3364so15824207b3.3
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 04:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xh33RakEW13LUwUL2e9VL/yLHoD9aqDpzZITRCOvqTk=;
        b=A2OjnZ+LyU3gZ+/pT5aETYLXAfxuU9IGwHh3/P7mJZfq6i6/Ubaevad+FF1GqtDR5x
         Uhi/KkFm3iErxWNhPuObLDOYs44q8xpvjJvCFbFCofMsEq82FYJ3lr0ty6fj8h4G8yJF
         etdeosUyHflJFxFyTqo5i7MgnX5/DzW1QBNcGVp8VQWfWv9TEu2ciBybE5KcvREsWGAD
         Lsoy1vtfe/cMHyRYTc0vlhgegZzG46gdm2Obd9nBgDLWF85HKOfePl4KOk4TLhe4wdvx
         UwF9Hmz0kzhRwuihamqHoekcUY0QAA7d2BiqqOvFBiBJW6lAqkSQSaKvOHB4OY+A8xVh
         uEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xh33RakEW13LUwUL2e9VL/yLHoD9aqDpzZITRCOvqTk=;
        b=H3Qm9GDErTgSfHMeD43mwiyOGQd3aS/CTK5D6l9zpFkBXtF9pi4MlM432VzJmHlKMd
         fGxNG0oY+Y2ktL7qrUP0fZIL2vYOJXzv2dQsDa/XPDt3QF6gUD+QcjWt6T8TDm77F1fH
         tYNI8Iiu3a24PEB59r4Hm3GLesBMbkveQvxgIMfIi1xEFAqGlQq/7RQ5fviqTZ7vMTdZ
         od6sWHVPVwO5nujVKJQHqOrqn4+SduwKFVtqOrsoUohpyQSCMeT8GQGi/xANbWfj/N9Q
         VGPQUAH7KTYGVv7Y9eIexEqS24AyF0seKpZLtPzf7dXy+XKx2GPh8yrk4P61ab161TSa
         flXQ==
X-Gm-Message-State: ANoB5pmVhZf20IZLuVgMyld29ZnqpMan+pvRc/ceZ+J32ZVkUld4tIuE
        1eCu67PYqFovPHGXO8R2vr09mW/80WhYtWd+W5wAiaT52LY=
X-Google-Smtp-Source: AA0mqf4euFrUdUVZK2eq70fgNUjXAQe/wBpbROblbeoZfeDRNSJcVLnxUbQ9fwbsETT9izJO5aJ22tcyrrsyItP8CQk=
X-Received: by 2002:a81:a094:0:b0:3ba:721f:b37c with SMTP id
 x142-20020a81a094000000b003ba721fb37cmr30425409ywg.457.1669898090510; Thu, 01
 Dec 2022 04:34:50 -0800 (PST)
MIME-Version: 1.0
References: <20221128154456.689326-1-pctammela@mojatatu.com> <2e0a2888c89db8226578106b0a7a3eeda7c94582.camel@redhat.com>
In-Reply-To: <2e0a2888c89db8226578106b0a7a3eeda7c94582.camel@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 1 Dec 2022 07:34:39 -0500
Message-ID: <CAM0EoM=5GZJMrEk8-T+rp+jFHzPy7jDqV_ogQ2p57x0KmnDvnQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] net/sched: retpoline wrappers for tc
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 6:05 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-11-28 at 12:44 -0300, Pedro Tammela wrote:

[..]

> > We observed a 3-6% speed up on the retpoline CPUs, when going through 1
> > tc filter,
>
> Do yu have all the existing filters enabled at build time in your test
> kernel? the reported figures are quite higher then expected considering
> there are 7th new unlikely branch in between.
>

That can be validated with a test that compiles a kernel with a filter under
test listed first then another kernel with the same filter last.

Also given these tests were using 64B pkts to achieve the highest pps, perhaps
using MTU sized pkts with pktgen would give more realistic results?

In addition to the tests for 1 and 100 filters...

> Also it would be nice to have some figure for the last filter in the if
> chain. I fear we could have some regressions there even for 'retpoline'
> CPUs - given the long if chain - and u32 is AFAIK (not much actually)
> still quite used.
>

I would say flower and bpf + u32 are probably the highest used,
but given no available data on this usage beauty is in the eye of
the beholder. I hope it doesnt become a real estate battle like we
have in which subsystem gets to see packets first or last ;->

> Finally, it looks like the filter order in patch 1/3 is quite relevant,
> and it looks like you used the lexicographic order, I guess it should
> be better to sort them by 'relevance', if someone could provide a
> reasonable 'relevance' order. I personally would move ife, ipt and
> simple towards the bottom.

I think we can come up with some reasonable order.

cheers,
jamal
