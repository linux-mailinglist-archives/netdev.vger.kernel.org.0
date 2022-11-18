Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F5962F8DB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbiKRPGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiKRPGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:06:33 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924B897ABC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:04:57 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-37063f855e5so52169027b3.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=exSk6xorl9oyQFjF7CiJoMi//g7qWrG7w97KB261pwk=;
        b=N2hjPK9Bupvkb0PD0+Pz3CF5IGm3LDGvI44NS3/98Jz/7smI8A3thNw565btDBBlxN
         28XBq97dMtazzAOxvn/DBzbt1CPO+cP1UX5Ob7ASkuzAfgkw0ocUR0uiKsdUtr/VvFrO
         3hB9G6wXeBkXj/4HGHF063DZD5ZLrNP1YkjxedSna7d+S1e8Io5LsuAdjuGu/B6GyTcY
         quL1hjQq41CbzgBInLuMWim0i6KEiKHfSu4TY4Fu3IMdc4RrKvJ727QdwI8W72zEe1Uk
         Jwb9L6tTDEkx9vtpDBA10O30sRPRnZQGUBM4rL62IK44Pt+gnB6ck3zaZjoL6AjcPBWE
         bWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=exSk6xorl9oyQFjF7CiJoMi//g7qWrG7w97KB261pwk=;
        b=rto/Z0jw6KE1tP7mkyzKALBKDKyGuu6/YJRheyRqyuj7OndvXEs09y3hNO+1mVRHI4
         0z7zsHqHBMOj6CHxJDZA6Cp6OTTbAsbxARe1KyH4TBhOhirh/7Cp+MhHwrYiFi+MUfMW
         KRDVOPKEL9GM6vRFWqN3Hd6mggP5YuqFGzDgHrZ/7HKH/V90y3rl95miuA4Hq6vRTbQN
         5vOlVUG/popUH0sPQk+XJnypOcJVXhicJIPgw/8zpIbmnN3VgK9noAvArqgNBzaoiMJm
         xXxUHDvbi1CbD9QUwygZ8VRlhNwKApRNqP5J6CO6fpVG8agPAlwf3qaQ3pW4r2NDfpru
         s/bA==
X-Gm-Message-State: ANoB5pmXRDAekqmnB8tfkseWI29KQuSpaUtk5ApJfBMaY2aS7nubiy76
        gwVKXeOC4RBkPFhPcyYiHpEHuar6aE8u3siR0z2AkA==
X-Google-Smtp-Source: AA0mqf7obY/45XG8gCfPMv2RKSPagLz7v5yRlEy7aKdSLUHpxh2z/XqZO6sA+2NxXPO75h3+xvRpGS+qbL3Xr+0D5qg=
X-Received: by 2002:a05:690c:a92:b0:36c:aaa6:e571 with SMTP id
 ci18-20020a05690c0a9200b0036caaa6e571mr6714252ywb.467.1668783896213; Fri, 18
 Nov 2022 07:04:56 -0800 (PST)
MIME-Version: 1.0
References: <0000000000004e78ec05eda79749@google.com> <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com> <32329c44-1dd6-9ded-3165-811a4e7e0a66@I-love.SAKURA.ne.jp>
In-Reply-To: <32329c44-1dd6-9ded-3165-811a4e7e0a66@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Nov 2022 07:04:44 -0800
Message-ID: <CANn89iJu3NzBS+bQHJ_X427SAVgr2HB=fBr8MADhD_hAqKmhHw@mail.gmail.com>
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
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

On Fri, Nov 18, 2022 at 5:19 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2022/11/18 21:36, Eric Dumazet wrote:
> > Please look at recent discussion, your patch does not address another
> > fundamental problem.
> >
> > Also, Jakub was working on a fix already. Perhaps sync with him to
> > avoid duplicate work.
>
> I can't afford monitoring all mailing lists. Since a thread at syzkaller-bugs group
> did not get that information, I started this work. Please consider including
> syzbot+XXXXXXXXXXXXXXXXXXXX@syzkaller.appspotmail.com into the discussions so that
> we can google for recent discussions (if any) using mail address as a keyword.
>

This is not going to happen.

The discussion happened before the reports were made public.

No more than 7 syzbot reports are attached to the same root cause.

We deal with hundreds of syzbot reports per week, there is no way we
can retroactively find all relevant netdev@ threads.

If you can not afford making sure you are not wasting your time, this
is your call.
