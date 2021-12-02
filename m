Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CA1465C52
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhLBDBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhLBDBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:01:43 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33C3C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:58:17 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g17so69227586ybe.13
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78PHn77LAmjIiUtxuGHawuHvS1eSCmxYWfTTBrmMsrU=;
        b=tZDt32JHhlujgV2Uqsjl4yKpebdEYZ5BbDYDITSeCL+MawRUHhzOHVJiQkqnN7qQK1
         bInTqTd95dtU8MUbhcIEJrE9Y4bY8LoJPGqS9tGAeCIC5g9CEYaiEnnoismyOg1uP9wG
         Gj48mUQ/79Y4Ljt9K8+f53Oi0/+h1v5n6TrGO0NcKKDLE8IscgNwjYFiCcE1cWaKtCE0
         SaFkHHZpWoCSzidvo5AAmupobgvVvnjgJSbBgu2zvl3/rBE2O97CxKFEbmJUBuC4COXH
         BFOzFCYjtx+yGS5IT2yILplScJzwnVzKNGP314n1lPtxSUSo8oAeFNyOgoMfCICrkHmG
         x1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78PHn77LAmjIiUtxuGHawuHvS1eSCmxYWfTTBrmMsrU=;
        b=aKzM0mRXRTmiOnwaXLoXfwwgDbBjOgdKr6oNKYLg+oYZFlprdg2Fn1Xk7f3+RnNPq5
         22jtwL/ntaxDZ+TAHiyGuqple+f4xPOQxj9KxJUBnComGOfakpZVsQX3hOPY4yuJBKJO
         p8Z+bN1xndQaL4hUWdIaPGOq/pkfX5+ascEk/Vps/ZmmktGslaWoJ0K033/RS9s3gu+p
         HUsnfumY2f2/1LMPJojAJVgH/fhWZKadOfnNraFj44XL0ijTlulqIHpoBbV0D5MPHkma
         7GXkt2VFi5pHnKy6tmrDLvs/l81L2mAOfRVmFIEbsT7tp8w99uSa7JlqgaHF6uNZapnI
         prLA==
X-Gm-Message-State: AOAM533wl+bLMw9TX/hTWuCU+f0xoCW7svjLHExbuhzfUkOdAOR02VXU
        762JOZ0NoZn/9KfrjiFDF3lGwqGr7y35buv1pU5bH8Do1Io=
X-Google-Smtp-Source: ABdhPJy1v7u8yafDQKpj9ZzaF+nCxGR1slr80Bgapd4o9tl/J7mYhO2VbB+3C1LZ57zt6/NyRXgnCK96VNFyN2jrTNU=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr12556684ybt.156.1638413896568;
 Wed, 01 Dec 2021 18:58:16 -0800 (PST)
MIME-Version: 1.0
References: <20211202022635.2864113-1-eric.dumazet@gmail.com> <0369c4e8-e19d-d376-06f1-3742da0cc003@gmail.com>
In-Reply-To: <0369c4e8-e19d-d376-06f1-3742da0cc003@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Dec 2021 18:58:05 -0800
Message-ID: <CANn89iLh_n686bwDWhkiq9J0iqjmBNCDh8SVB+tHWUnqiOH+OA@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: convert fib_num_tclassid_users to atomic_t
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 6:42 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/1/21 7:26 PM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Before commit faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
> > changes to net->ipv4.fib_num_tclassid_users were protected by RTNL.
> >
> > After the change, this is no longer the case, as free_fib_info_rcu()
> > runs after rcu grace period, without rtnl being held.
> >
> > Fixes: faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: David Ahern <dsahern@kernel.org>
> > ---
> >  include/net/ip_fib.h     | 2 +-
> >  include/net/netns/ipv4.h | 2 +-
> >  net/ipv4/fib_frontend.c  | 2 +-
> >  net/ipv4/fib_rules.c     | 4 ++--
> >  net/ipv4/fib_semantics.c | 4 ++--
> >  5 files changed, 7 insertions(+), 7 deletions(-)
> >
>
> Thanks, Eric. Was this found by syzbot or code inspection?
>

Code inspection, while plumbing my dev_hold_track() and dev_put_track() helpers.


> Reviewed-by: David Ahern <dsahern@kernel.org>
>
>
