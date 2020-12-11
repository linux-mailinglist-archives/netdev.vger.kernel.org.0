Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4AA2D7805
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405148AbgLKOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391980AbgLKOht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:37:49 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E05C0613D6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 06:37:05 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id p5so8952165ilm.12
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 06:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJlHhFY7YpGSb/NWgpsHkRiym//oc/n7oGp6xC0++YI=;
        b=ATt6n2xzRSCOBPYNJqnfDPSM1w4dkDEyGpz0yU3WQaPHQ36ZuuiOgYy+6B1QSHYSMy
         RN7ABuPhtbt6d2A28l20fAe+to7TJeiI62SH0imBVhoY6/MENzMuX0Dmyp4vL3LujZa3
         vreiQVmlFgK9/2Iefib9XM/v4uGWXKeihehkvxaNkRk54q6j8LtDeTrmgbn6hF1m7UfW
         pKE8uexzTVU4NHqlD4os1Okz57gjFQGeDZ/R11DDvOAvPiHbGUooxzCWzAzt1dkzOeV5
         2O8FsY8bUvj6xKhoUc5t/Gloa4oepDTfkGsn9ko+8eJ6r/Zfxx4sVfrBP24K5SKHxFcj
         z1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJlHhFY7YpGSb/NWgpsHkRiym//oc/n7oGp6xC0++YI=;
        b=LLvdyGiuo4+YT0P+cCv7/LweWrAondlsjMXIQ6ubw9NbA9OC9mUMn2F3N7qEfkimGp
         iekBzyThACL1gqQTv+5F20EL6mks9AmVwl27A15TvN3TA8H8LCyBkQ+qgfwN3m1BaoJW
         VkUTr4lwXRi8T3wCR3EA6rc3eyyw2jkNujaDdtOhtcJd3ssPuLyj6cu/5iV/yC5EXs5f
         PnzW7rkRFdjazt5I64VS7aW+GGpLmhopL4LNsLCqCmjMF790Iet8Pu6qCv3HAYGnuA6E
         rAmmjDy+IAe4uEGrMfdGO1OldI9Mh9t2Ufa8dp3WFngkO8R+PDjBf6bZrJqAOY0OP/ks
         WojA==
X-Gm-Message-State: AOAM531zSV8CASwrXCI8PpZc3yY9o/hnXM2brcB4soReagOfhIecijTO
        4kGTdUaPi74xIil648V/sCwDwjsgkDvkL9Bj3yCdsQ==
X-Google-Smtp-Source: ABdhPJx4GDSLnE6X++8HaLygIbU7GOWkPLUEzAx6L7q7vDvDs7fa7NOTg9AzBA5eFeY1//1BiEyEqUEd2Wv5v7CuQYY=
X-Received: by 2002:a92:d0ca:: with SMTP id y10mr16813330ila.68.1607697424987;
 Fri, 11 Dec 2020 06:37:04 -0800 (PST)
MIME-Version: 1.0
References: <20201211112405.31158-1-sjpark@amazon.com>
In-Reply-To: <20201211112405.31158-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Dec 2020 15:36:53 +0100
Message-ID: <CANn89iKGU6_OusKfXeoT0hQN2kto2RF_RpL3GNBeB54iqvqvXw@mail.gmail.com>
Subject: Re: [PATCH v4] net/ipv4/inet_fragment: Batch fqdir destroy works
To:     SeongJae Park <sjpark@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 12:24 PM SeongJae Park <sjpark@amazon.com> wrote:
>
> From: SeongJae Park <sjpark@amazon.de>
>
> On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
> make the number of active slab objects including 'sock_inode_cache' type
> rapidly and continuously increase.  As a result, memory pressure occurs.
>

> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Jakub or David might change the patch title, no need to resend.

Thanks for this nice improvement.
