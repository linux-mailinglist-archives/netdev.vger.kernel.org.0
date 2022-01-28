Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5049F14E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345552AbiA1Cx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345549AbiA1Cx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:53:26 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D623C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:53:26 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id m6so14431672ybc.9
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZSEsahTaMIlSofqaMZHvrGxDpUIJ7LxbR4idGwpdew=;
        b=GjOTsPDJ93PhRReYYYL5QaX/G6LbckIbbxfENXB+nMNkcnTfI82ElvaQVQwxLvvZ8o
         YawOPfZq8G5hKWVpPaGU9INFBQKv69tO4uEZKc2RlHGxPpli1b7YP8NAN0hvCcbEgitg
         SJltmsme+M2ycoqwgoTxSLyVDnWgBClMZkltzZlLLD5UlIdwAVQickOtQUyWfN5Q6C5p
         jw4cGjqzevSZDW3T/vwInaescNrnv8quUqOTBuD9rAGYqe9gjedAYmKuK6TONv/CCDXL
         E4e8nqyX7E9moZPTFBM+IAEcyHTm52WokhjjCJAQ7kmj8JXCfqbQUKG3ONH4hDp70gRl
         fEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZSEsahTaMIlSofqaMZHvrGxDpUIJ7LxbR4idGwpdew=;
        b=J5X6NLUlgKe0wAJ4IWTWsWC/TlUJxHVeTCdVY8dYpHbLXVLc6QvfrKtUjJq4dv4b5T
         +0FweTnnv0ig3Fn9D4z+OK1ZJv+MECmuz3abww3X1+0JRbL5WuWS1IlYeDq7pY9/7HKJ
         cArFQzJE1CvqBchuFHacK1xeSqp/ifGEbOPWlt0807I0en8i8vFlvCE4txTFiZO0ROeS
         Agspuw2O0KBERdnrFOGxB4tk5WU3yJfX5No7NOD6CMNaTXR9L7TeZ0VYwg1X45y2upzD
         m18Oh63gO1/tzBMoWwMauLwbxtK+Vu716tciIvQA+ULe6e6OD0Eewkz4epVB67lzrlvR
         xDpg==
X-Gm-Message-State: AOAM531RTwy27QknCxHFwZeAShB6eRIsaUfvbLT0UXsM9R0e1q5ntcdD
        +rHvE3+iVWuxrYgx+XbEWCY6xSQM0QXoGEgf2loolQ==
X-Google-Smtp-Source: ABdhPJzf7c9PkzJz25VZAlwf3/CGlrXvPil3n5mlFwSgExkN4czsiChb2H83zO+Cy9bJb04apCSkp5l8W+EjiV959uQ=
X-Received: by 2002:a25:d80f:: with SMTP id p15mr10191044ybg.753.1643338405485;
 Thu, 27 Jan 2022 18:53:25 -0800 (PST)
MIME-Version: 1.0
References: <20220128014303.2334568-1-jannh@google.com> <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
 <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
 <CANn89iKmCYq+WBu_S4OvKOXqRSagTg=t8xKq0WC_Rrw+TpKsbw@mail.gmail.com> <CAG48ez2wyQwc5XMKKw8835-4t6+x=X3kPY_CPUqZeh=xQ2krqQ@mail.gmail.com>
In-Reply-To: <CAG48ez2wyQwc5XMKKw8835-4t6+x=X3kPY_CPUqZeh=xQ2krqQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Jan 2022 18:53:14 -0800
Message-ID: <CANn89iKVQBDoAwx+yuJ0P0OAV59bav_abh87BA6n7JuzMKMtCQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dev: Detect dev_hold() after netdev_wait_allrefs()
To:     Jann Horn <jannh@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 6:48 PM Jann Horn <jannh@google.com> wrote:

> When someone is using NET_DEV_REFCNT_TRACKER for slow debugging, they
> should also be able to take the performance hit of
> CONFIG_PCPU_DEV_REFCNT and rely on the normal increment-from-zero
> detection of the generic refcount code, right? (Maybe
> NET_DEV_REFCNT_TRACKER should depend on !CONFIG_PCPU_DEV_REFCNT?)

NET_DEV_REFCNT_TRACKER is not slow, I think it has neglectable cost really.
(I could not see any difference in my tests)

Also getting a trap at the exact moment of the buggy dev_hold_track()
is somewhat better than after-fact checking.

In your case, linkwatch_add_event() already uses dev_hold_track() so
my proposal would detect the issue right away.

>
> My intent with the extra check in free_netdev() was to get some
> limited detection for production systems that don't use
> NET_DEV_REFCNT_TRACKER.

Understood
