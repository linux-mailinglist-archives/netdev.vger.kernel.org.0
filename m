Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478A362E403
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbiKQSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiKQSWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:22:35 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB051311
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:22:34 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id z192so2913414yba.0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jfw5a5L8IvV/kvGKF/DMQqdusHiCh0R6uAmQu8nYnr4=;
        b=hhaKe9nmlIc9X4Cmc8AhvoNPtHtitfsgQ7h0eCN2o7MPAQzrzYJx3f+IIL6a1Ve0dA
         a+Gl2GeZdlwbc12piw1ri0yNfOPBrcCqEoJHXdPcrE5gY+PYmkVcpnWvfJmCTn83dmSW
         PS97FcUQeBOy89fduiZRqVY8iiv8sD+jsWGf5njDs575tBaCKH7IFL1XhQPK61vTZ1Ao
         EXt6bjQr4DFr7ZBr/4kUU4xyCaUIz1KvuZbTyDlbtcPXu/rHbBCv+mBOqFJWTnBN8SkJ
         RxYk9uEkt1GsQ5cWr3PV2SlNgwG2j4Cp/UWegVlnpa8YVHUN4EWyl41cEecoL4USxfo/
         A3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jfw5a5L8IvV/kvGKF/DMQqdusHiCh0R6uAmQu8nYnr4=;
        b=goMYAponmqKfFLM+z7PqRRHkgoNL6mm4CxN50aUgY4hFT5KQgXnWV0GLVR3RtrAOVG
         +hWCZRnWHKU2DoxEvinljqCCzTRbZzQWfhA4uqbhBOjvmhz6lGl5YSBgNcZCDvkul7Tk
         g+J71UhYGFmZ7+pShlnR4vcw31gEiomKSEFH5GxZ1cvQ6Ldyg5yY8SARUdxF9WmJPPJz
         ZO/OYOnmU1buOKnZOLCUIGTbeB2wLfXh9WEpqS/3B/wlnJXhRvddNZKQn7ZlGvUNi2Zl
         04u6qPhYbjLYesQ8WIrq07t68qbMQZ5ogwyMz+WKEeD1dsmD5ZZrH3CJskyDY8mzzU8X
         z2Xg==
X-Gm-Message-State: ANoB5plZro2xnoWWD6DjJQeBGdUJ7ZHFxMaA0QKBZ9QoYIlDbRSAB5t6
        s0CvFPZR7QL7iK5hZsKQpQuiifJPdD1/3413SNiMuA==
X-Google-Smtp-Source: AA0mqf5KlD5QStHh0O7F5hQQBDfNprNdYBO58yBn4u5NkFxM4ijVuetszSLxi8cDgRzyQaJfc0pBNCtKbgDXl3I4IE0=
X-Received: by 2002:a25:e90f:0:b0:6d2:d710:7454 with SMTP id
 n15-20020a25e90f000000b006d2d7107454mr3122162ybd.407.1668709353799; Thu, 17
 Nov 2022 10:22:33 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org> <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com> <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
 <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
 <CANn89i+9XRh+p-ZiyY_VKy=EcxEyg+3AdtruMnj=KCgXF7QtoQ@mail.gmail.com>
 <CAEXW_YS-d_URqjfcasNnqf3zhCKAny8dhhLifAxtrpz1XYd_=w@mail.gmail.com>
 <CANn89i+GcVzgg56fd9iO5Ma6vSUVvJmLHTvRwPMoYKMPR4G4Lw@mail.gmail.com> <CAEXW_YSyZswszFo-J6rEFsb2mAcXLytZaFSqi1L1LpSHWfTXMQ@mail.gmail.com>
In-Reply-To: <CAEXW_YSyZswszFo-J6rEFsb2mAcXLytZaFSqi1L1LpSHWfTXMQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 10:22:22 -0800
Message-ID: <CANn89iL_m=TS92-V=rE4pvB1_Wu=etb6c2UT8AxWiKwZjiLNQA@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com,
        jiejiang@google.com, Thomas Glexiner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:18 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Thu, Nov 17, 2022 at 5:49 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Nov 17, 2022 at 9:42 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> >
> > >
> > > Yes, I agree. Your comments here have not been useful (or respectful)
> > > so I am Ok with that.
> > >
> > >  - Joel
> >
> > Well, I have discovered that some changes went in networking tree
> > without network maintainers being involved nor CCed.
> >
> > What can I say ?
> >
> > It seems I have no say, right ?
>
> Sorry, I take responsibility for that. FWIW, the rxrpc change is not
> yet in Linus's tree.
>
> Also FWIW, the rxrpc case came up because we detected that it does a
> scheduler wakeup from the callback. We did both static and dynamic
> testing to identify callbacks that do wakeups throughout the kernel
> (kernel patch available on request), as the pattern observed is things
> doing wakeups typically are for use cases that are not freeing memory
> but something blocking, similar to synchronize_rcu(). So it was a
> "trivial/obvious" change to make for rxrpc which I might have assumed
> did not need much supervision because it just reverts that API to the
> old behavior -- still probably no excuse.
>
> Again, we can talk this out no problem. But I would strongly recommend
> not calling it "crazy thing", as we did all due diligence for almost a
> year (talking about it at LPC, working through various code paths and
> bugs, 4 different patch redesigns on the idea (including the opt-in
> that you are bringing up), including a late night debugging session to
> figure this out etc).

Apologies.

For me "crazy" does not have the same meaning, apparently.

I will try to use more neutral words in the future.

>
> Just to clarify, I know you review/maintain a lot of the networking
> code and I really appreciate that (not praising just for the sake).
> And I care about the kernel too, just like you.

I had no doubts about that, really.
