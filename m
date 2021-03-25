Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333CA349446
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhCYOiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhCYOiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:38:46 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153A0C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:38:46 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g20so1976129qkk.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJUrsPHlio3JZDEBLKNlEUXkniP4F7lnf24NzR1mbLw=;
        b=lKZ8QuF18WDpT7W9a2yKlxN4G7kfUM69JW3rqA87rSSq0FtpIrCbEJdORZVFqLlpSw
         YDNLUUTrULctDfIjO28Tx7jVIQEOUDTpV7es4dn4jOOHs2aft4crqkOrWYXNd32d3Jr/
         mGKilLKcm2vOWLfOLyyFgb25XUQbFvOYXskHS+Pu0moiXyl4ihclRDaBfgHk/VaolSfx
         oZ5Z7c6tpor6qlFeonXapMRSxodQHD9YLcZwOVeDHtqjQn5FRZr4NvUNzcJXlHHrz0Dv
         g+Am1z9Y8pwB5oYlvdV3KKAwlQpPzubbw8R5pS5x1nmPof5NaQirybtEeJfzMz/omwQ5
         WhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJUrsPHlio3JZDEBLKNlEUXkniP4F7lnf24NzR1mbLw=;
        b=smaNgTtnLA53Uiyi4R4PQcxEx61GlxcWS0KaLiFLpEzoL3Y1gJZYqeZB3IOjK2tWJo
         xtqO2rFiZjtRJ75VWfLgZXiFGZ/kVYDMs+4SXerxIiUGQKAYuBbpKi743AIhVO+29bF+
         YbVjm6dJOEMe+VAtLj5BKFSShIHpCGKpElQXJnNLwjLpCq56Oo3/Ej07FxQXUtULy/0z
         MnIfFPrVZJ554G6uEntcqIpaP8PJiH/xV+PQ+KBSz5WZb85fWnktwKZJ6ebD2a+/HcY3
         srWNl5RxSohJ3Xtp+0otKqMTxHHfOd6kEEmrnQeecU+AOlyRVXfGYOrYRh1Ksy/vIzZC
         nx5Q==
X-Gm-Message-State: AOAM530nUrHu0Ov/ovQazlSw77vn80jcVstekyyx2kbwkXc9R1MuImzK
        234o7yt3HrdpqHGkmaEvDRd/iXyGoCpSSbMBOjrSjA==
X-Google-Smtp-Source: ABdhPJxVrstil2bf/cM7b2H+ldMMGkb/IlmTk+CjUI3v8NAm7L7nuJQ8KMrRPgHA1ct4kILqKAKUnU4iUI2Ju+Skui0=
X-Received: by 2002:a37:a7cb:: with SMTP id q194mr8523499qke.350.1616683125044;
 Thu, 25 Mar 2021 07:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210325103105.3090303-1-dvyukov@google.com> <651b7d2d-21b2-8bf4-3dc8-e351c35b5218@gmail.com>
In-Reply-To: <651b7d2d-21b2-8bf4-3dc8-e351c35b5218@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 25 Mar 2021 15:38:31 +0100
Message-ID: <CACT4Y+ad6bwMbQ6OwrdypCsNRvYTMtMf0KR2EpVOhPOZvnxeNA@mail.gmail.com>
Subject: Re: [PATCH] net: change netdev_unregister_timeout_secs min value to 1
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 3:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 3/25/21 11:31 AM, Dmitry Vyukov wrote:
> > netdev_unregister_timeout_secs=0 can lead to printing the
> > "waiting for dev to become free" message every jiffy.
> > This is too frequent and unnecessary.
> > Set the min value to 1 second.
> >
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
>
> Please respin your patch, and fix the merge issue [1]

Is net-next rebuilt and rebased? Do I send v4 of the whole change?
I cannot base it on net-next now, because net-next already includes
most of it... so what should I use as base then?

> For networking patches it is customary to tell if its for net or net-next tree.
>
> [1]
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4bb6dcdbed8b856c03dc4af8b7fafe08984e803f..7bb00b8b86c6494c033cf57460f96ff3adebe081 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10431,7 +10431,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>
>                 refcnt = netdev_refcnt_read(dev);
>
> -               if (refcnt &&
> +               if (refcnt != 1 &&
>                     time_after(jiffies, warning_time +
>                                netdev_unregister_timeout_secs * HZ)) {
>                         pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
