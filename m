Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A86454FE
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLGH6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLGH6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:58:24 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D271837B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:58:23 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3b10392c064so178099107b3.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 23:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YsEzFVYWNb3PSDqX7gS5EcXxQ26G4nv0tvB50of4rR4=;
        b=bl0LUe4BpedaJkvYgS3xhG2L/TRZR7Kr+X+zOk4HQGtaQuG5wOLRHc5Cmq4KZfoWVc
         Wy98e/8RQunRXYgCxyXqGQqOWeTjgpWDEag2U3fSI0w8shSBSXf7+ciCl6oRPcce3mlL
         qiPusHjOGl33yPEreHDFoaozVg5vnc8B4PbsWg5vSMAvjpnOn3vLdQLW+iB+Q9JoqjKz
         rzi0DufB/Vo+a5NK/wToL/hx1FjNKyQ3sWyFYq/J+7KhgKKagMuW64zLwcXh0ZdcHqI1
         YGmb7lzZn+wO7foQRYQwu6xLEEnGA6alh2eD4O8DpQZIhqSkOR9dmoMp13OCiJMTUkQw
         k5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YsEzFVYWNb3PSDqX7gS5EcXxQ26G4nv0tvB50of4rR4=;
        b=2UuqoWuG8sFg8CQUhKdqKBLbw1MpYYNCks2/k7/n4waZvsgDaIH3wV4j3K1N+ZPXHZ
         YXStudch6Vm0cpKxcbjP0BXDDGZrQSBg2FbcIe7Dm2/g3cA0reD3EFP8oQVFfrmc5ywp
         ZFiMsRQknoUWIRg4y7WB6IwGzlFmSCapL/68BEleiEYZWBbBs+MYwFJs3O+z5EgVmtUi
         FlJJLGw0WunUj5D43Cz2ozP+2uR1qV9tNTAYJkUddyIp6n6EottvqwhXRn04Ih96ngzy
         McQ6jHUL6FGFq34iuOUr77kVkVOapTpIDCfPznMHUM/WwYdOYmPeewRoOik87BwOyR9v
         Flqw==
X-Gm-Message-State: ANoB5pn7GWuDd+6BReYsogPaP8VbmQYPLUmSYfkZ/kXA9gD5Y5kLZVGN
        3y6V4DJ035Fm7rsNBKHQDGHSHAzYw4pb+/Uo+3JySQ==
X-Google-Smtp-Source: AA0mqf6J9chWLNqURxSv/bkiORvCD6QhQ2HABa8D/n90JoAuxIa5UCEjPDppjQ5IskzLdHp8YPNuS4CxUPZIovb05bE=
X-Received: by 2002:a81:a8a:0:b0:37e:6806:a5f9 with SMTP id
 132-20020a810a8a000000b0037e6806a5f9mr5115644ywk.47.1670399902402; Tue, 06
 Dec 2022 23:58:22 -0800 (PST)
MIME-Version: 1.0
References: <20221205184742.0952fc75@kernel.org> <202212071527223155626@zte.com.cn>
In-Reply-To: <202212071527223155626@zte.com.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 08:58:11 +0100
Message-ID: <CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
To:     yang.yang29@zte.com.cn
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, liu3101@purdue.edu, wujianguo@chinatelecom.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tedheadster@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 8:28 AM <yang.yang29@zte.com.cn> wrote:
>
> On Tue, 6 Dec 2022 10:47:07 +0800 (CST) kuba@kernel.org wrote:
> > But are you seeing actual performance wins in terms of throughput
> > or latency?
>
> I did a test and see 7~8% of performance difference with small and big
> netdev_budget. Detail:
> 1. machine
> In qemu. CPU is QEMU TCG CPU version 2.5+.
> 2. kernel
> Linux (none) 5.14.0-rc6+ #91 SMP Tue Dec 6 19:55:14 CST 2022 x86_64 GNU/Linux
> 3. test condition
> Run 5 rt tasks to simulate workload, task is test.sh:
> ---
> #!/bin/bash
>
> while [ 1 ]
> do
>       ls  > /dev/null
> done
> ---
> 4. test method
> Use ping -f to flood.
> # ping -f 192.168.1.201 -w 1800
>
> With netdev_buget is 500, and netdev_budget_usecs is 2000:
> 497913 packets transmitted, 497779 received, 0% packet loss, time 1799992ms
> rtt min/avg/max/mdev = 0.181/114.417/1915.343/246.098 ms, pipe 144, ipg/ewma 3.615/0.273 ms
>
> With netdev_budget is 1, and netdev_budget_usecs is 2000:
> 457530 packets transmitted, 457528 received, 0% packet loss, time 1799997ms
> rtt min/avg/max/mdev = 0.180/123.287/1914.186/253.883 ms, pipe 147, ipg/ewma 3.934/0.301 ms
>

Sure, but netdev_budget set to 1 is extreme, don't you think ???

Has anyone used such a setting ?

> With small netdev_budget, avg latency increases 7%, packets transmitted
> decreases 8%.
>
> > Have you tried threaded NAPI? (find files called 'threaded' in sysfs)
>
> Thanks, we had researched on threaded NAPI, much applaud for it!
> But we think someone maynot use it because some kinds of reasons.
> One is threaded NAPI is good for control, but maynot good for
> throughput, especially for those who not care real-time too much.
> Another reason is distribution kernel may too old to support
> threaded NAPI?
>
> >Well, we can't be sure if there's really nobody that uses them :(
>
> As we still retain netdev_budget*, and there maybe some using it,
> should it be improve? Netdev_budget* are sysctl for administrator,
> when administrator adjust them, they may want to see the effect in
> a direct or easy way. That's what this patch's purpose.

We prefer not changing /proc file format as much as we can, they are
deprecated/legacy.

Presumably, modern tracing techniques can let you do what you want
without adding new counters.

I think that a per-cpu counter is old-fashioned, and incurs a cost for
the vast majority of users who will
never look at the counters.
