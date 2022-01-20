Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C956B494E29
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbiATMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiATMrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:47:13 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26457C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:47:13 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id i7-20020a9d68c7000000b0059396529af8so7394067oto.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rk7eQPMzlV6sL8ptWJnuutQSsSki+JiFQv8LSNSPdm4=;
        b=kn7w5zPV84gKF8nAIY2Paqm2J/0ZA7+MIuI/7PhqrLKvBED+NZCrVfQNxvlKujs6+f
         3X40Utng69tVjygwq8tFZfhPVHQVoZ7zKNA5RviVVKZHsxVgPI/q07GYJ8UeW8b/gq0e
         lfdqU7uefntu2amaJhfH85KGrgftrrLj/9j7MPfO48vWU5MjyKMw06Fj1Oe5F6FLd58n
         sPr8RBZyCoITAU6TgJxRV4HKvToNV6kRIicf+M2F27a3vcKSgLxfeigsVWHgj7Sxw/Ft
         wCsrmRf8jSsQZjD/1D8KZgt9DDslJBy9Ug2I4Srea0mWmAMQ0fLFc3ZXgIYFj+PMD1iV
         9i7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rk7eQPMzlV6sL8ptWJnuutQSsSki+JiFQv8LSNSPdm4=;
        b=1IAj1QayINgb+3HLfPRsLFBXEoYky25DZ72GtJmWJm8YmG9RXEEWQN0TY3yGFAdCTy
         QBYCuM5gRt46jQF5RR48PoRHe4zZo92sDeFKpL2sQEFvNeM5zlSZtae7MRmAk2ZpGrdT
         6rLG5aATNl0o2mc4rYm9wuULlLS28uxqEb8+LHeXHfzYA6thAhErB23pDw+MGITq9kDN
         7kjLIhio4pO3lgZAqURU/VlUREbDIdTpccLdWLfKy1ZoO9NLRumD+AIAVxW5P0arIGCb
         rE5A5EH1na64U4VQUabPVxOCAXEXK1jvtnxiAPpp/gJdddKZG/fw3UOUL90S0PEdR/XP
         c9HA==
X-Gm-Message-State: AOAM531C8zJXjd1/XR+QZ3vjkYQx4JsoKTWn7M7zOr2kiAVx747hxXrd
        c5tQccVx36fMjO6wHlTkWihTr7Dw4g8Hqpv8NIW57g==
X-Google-Smtp-Source: ABdhPJxPoWJV9ghspjD7dWEKg1fSTyeC1ZWtdKPmP4tt0pi3XBbfF96GwhfuBtTqtjHWm8lm0KM8jcPjyhS5/93y144=
X-Received: by 2002:a05:6830:244c:: with SMTP id x12mr26369761otr.194.1642682832288;
 Thu, 20 Jan 2022 04:47:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c5c09805d313d03e@google.com> <000000000000b5085105d5f2c7ab@google.com>
In-Reply-To: <000000000000b5085105d5f2c7ab@google.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 20 Jan 2022 13:47:00 +0100
Message-ID: <CANpmjNN2BW-qPvVroCDho4zvq8h+VFh2RSBaFyCxQUZdqozz5A@mail.gmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in tipc_crypto_start
To:     syzbot <syzbot+73a4f2b28371d5526901@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, fw@strlen.de, hoang.h.le@dektech.com.au,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tipc-discussion@lists.sourceforge.net, yajun.deng@linux.dev,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 at 18:33, syzbot
<syzbot+73a4f2b28371d5526901@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit f845fe5819efc4111c456c102f15db6d9ed3406e
> Author: Hoang Le <hoang.h.le@dektech.com.au>
> Date:   Fri Dec 17 03:00:59 2021 +0000
>
>     Revert "tipc: use consistent GFP flags"
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b09d88700000
> start commit:   28a2686c185e selftests: Fix IPv6 address bind tests
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=221ffc09e39ebbd1
> dashboard link: https://syzkaller.appspot.com/bug?extid=73a4f2b28371d5526901
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1066ce9db00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1398fc6db00000
>
> If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Revert "tipc: use consistent GFP flags"
