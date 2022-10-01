Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11B75F1F72
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJAUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiJAUj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 16:39:59 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425412B616
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 13:39:56 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id s63so578289vsb.13
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 13:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=n+oAZ+26+9oKtdVwjCMaNdHhyc8tS7zik7S9KdugGyw=;
        b=e0qsWFnYTw0z2QDqzOuPKwa3e+qBUyoxAAzhF7NR4xVV6svcHBt5e5fuD+b3Lf01/q
         qQDBh0M/7tAqk+kB1gVdaSh2yJxC4teC/3pG6C/6ToGWf9sQPVmVIhiX4QmhWxSVo3Z+
         S2l7SSNnUdxeK0dx7efYlgVfLjus0FrmdsJiiHHtKKB1BrNe3U8wNTX7FcmK9oUqIWef
         DGO1gnI5GyN5e6e4hRImCX3A9hPBrYRssxITwlsc4fcRhF60aqeqfJwNpXUhi3IYcWxp
         nQVG77E08wmt2mnkyhL7ASkpdlULuficE+EvkX+bKO8kd0fWmn8BFTg0QW1PLsG/E5Vr
         5ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=n+oAZ+26+9oKtdVwjCMaNdHhyc8tS7zik7S9KdugGyw=;
        b=bLR0UDpzGfYS0ujf5FJyDo6ioxgJfv6dRVAnLz4nP4ut/7T1VU8+oehk+Xp8YeamDI
         BU06qtGESbxn3B3pKeZRr06Rvo0TDRWNNlEQpPQZKA2i19wJ1l8J20RXEhpOPWeXxmX/
         nyHZFT6koX4Zsd2T5wk5FT9uHm2IZb6+EUnjxCrzOX2h24UTOchY6hsWOt29EumaCG1R
         yf6k0n5M3YZB3+uOlJJ2Y0trHGkbEwQj1IhAQCus4X/ZAXco1ZUSdTnz89nl1F6myVYz
         H4sV94cuHm8q0G7mHnYBg7QuKt6/NnNx+2830AwtBj5S6mHmBFu7fKA4bwGqz7sKOC74
         qoeg==
X-Gm-Message-State: ACrzQf1omAy5/iVyyW4BL/nVu/k5IxhJTXvrcQ2TkRSMb3ZI+cE7eHL/
        ex+PVfydx9lZb1dpoxz269q9vfUteJg=
X-Google-Smtp-Source: AMsMyM4N5uiI/NQW2y9WGAhoQiVwzqWxaWHfKUuH+RCKjir590D9/1rgPs2ALjjcMVE1gGn+mqNMvw==
X-Received: by 2002:a05:6102:1c2:b0:398:1c8a:ba4e with SMTP id s2-20020a05610201c200b003981c8aba4emr6483506vsq.31.1664656795153;
        Sat, 01 Oct 2022 13:39:55 -0700 (PDT)
Received: from t14s.localdomain ([200.146.228.250])
        by smtp.gmail.com with ESMTPSA id f45-20020ab049f0000000b0039f6146ffeasm4498046uad.24.2022.10.01.13.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 13:39:54 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id C5DE3417901; Sat,  1 Oct 2022 17:39:50 -0300 (-03)
Date:   Sat, 1 Oct 2022 17:39:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Yzillil1skRfQO+C@t14s.localdomain>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
 <YziJS3gQopAInPXw@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YziJS3gQopAInPXw@pop-os.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 11:39:07AM -0700, Cong Wang wrote:
> On Thu, Sep 29, 2022 at 11:35:05AM +0800, Hangbin Liu wrote:
> > In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> > made cls could log verbose info for offloading failures, which helps
> > improving Open vSwitch debuggability when using flower offloading.
> > 
> > It would also be helpful if "tc monitor" could log this message, as it
> > doesn't require vswitchd log level adjusment. Let's add the extack message
> > in tfilter_notify so the monitor program could receive the failures.
> > e.g.
> > 
> 
> I don't think tc monitor is supposed to carry any error messages, it
> only serves the purpose for monitoring control path events.

But, precisely. In the example Hangbin gave, it is showing why the
entry is not_in_hw. That's still data that belongs to the event that
happened and that can't be queried afterwards even if the user/app
monitoring it want to. Had it failed entirely, I agree, as the control
path never changed.

tc monitor is easier to use than perf probes in some systems. It's not
uncommon to have tc installed but not perf. It's also easier to ask a
customer to run it than explain how to enable the tracepoint and print
ftrace buffer via /sys files, and the output is more meaningful for us
as well: we know exactly which filter triggered the message. The only
other place that we can correlate the filter and the warning, is on
vswitchd log. Which is not easy to read either.

Thanks,
Marcelo
