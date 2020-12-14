Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7FB2DA0A7
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441124AbgLNTgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440954AbgLNTgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:36:04 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16841C0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 11:35:24 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id z12so6895213pjn.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 11:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IM5QHKKutzyCiIvXAeWPvqu8wN37b1v7Fs+9VXlsMrs=;
        b=jb6wE/w0F1qqt3oQIL7OeRbhgf1/pVO8WEHX5bPAgqEce8BbY6+N2XrHlhxX1Ou+9L
         LkH5BKfQIDUsEddQGG2HVyqpPR/8qhx4Rj0bZWvgKTD6bBRuSZYbGZ9e5NPrPe9F5rdh
         idUn+R0BuOG+kclpI6C4IGLPNLeYwUJc/wlaSZUDWdwwtdPBRWWheAp0E3+aidUdzmZ0
         DSw54TwoYACZ1P5p/+AQMfnnzPIfNCWtyIVktdgddsmGhr5a4ryIwE/W8g7jxJW4Y0Xu
         VtKXjSOlaftAucmivcLDIxmuQGRfrpWQwUQrHx5uGo0r2YvWj4iqMNE4XIipRfGygaA9
         PfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IM5QHKKutzyCiIvXAeWPvqu8wN37b1v7Fs+9VXlsMrs=;
        b=tKA/mu85nokihhu4fDlbSZwOXoklDHVk51dp+wfmDFL//P+tbdKwtu8neIHniHhc09
         9m37iDCwUV82hSE3Rze3wTTSF/jGSqFrP0bx8wpibE/w5bazFFtyNMNMwvMDiEISoN5a
         BbRRsesJERv0nL+/1slHMhNws8eg/h2ISs9bSHwLooi6B84Z2MJC44z1SsI3ermB4vQ+
         osB9atJy+rDH8qjRSBb433OVOwvpM0IZbUYzHdLa96YADYLQC0T97QPZc9FFAQNvumAY
         mMlVyQYkI+Rg1QXwqcYenjSuFnTx1GuM2UyrLuKnfMksa2a8ySfxhOg5Wa/jmzsKG9/5
         rJWg==
X-Gm-Message-State: AOAM5337Sdhyss2wZPHaeSFSPB9Kx5uKCbgT3rACpg/VhsNlaKUekXcP
        OfP+zjbGBaz7SUixl9uB3Osa24+yUAa+ho9fh0N/Pg8QbBCQ1Q==
X-Google-Smtp-Source: ABdhPJycTW4UGyWTCWn0cJUXmgnIelSuxreDPwMqzwQJh4aqqbP722LoP0RB7occT9gBW/puRW3TNgsedAGOELF7OwE=
X-Received: by 2002:a17:902:9302:b029:da:f6b0:643a with SMTP id
 bc2-20020a1709029302b02900daf6b0643amr24211875plb.33.1607974523566; Mon, 14
 Dec 2020 11:35:23 -0800 (PST)
MIME-Version: 1.0
References: <20201211152649.12123-1-maximmi@mellanox.com> <20201211152649.12123-3-maximmi@mellanox.com>
 <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com> <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
In-Reply-To: <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Dec 2020 11:35:12 -0800
Message-ID: <CAM_iQpVrQAT2frpiVYj4eevSO4jFPY8v2moJdorCe3apF7p6mA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware offload
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 7:13 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2020-12-11 21:16, Cong Wang wrote:
> > On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> >>
> >> HTB doesn't scale well because of contention on a single lock, and it
> >> also consumes CPU. This patch adds support for offloading HTB to
> >> hardware that supports hierarchical rate limiting.
> >>
> >> This solution addresses two main problems of scaling HTB:
> >>
> >> 1. Contention by flow classification. Currently the filters are attached
> >> to the HTB instance as follows:
> >
> > I do not think this is the reason, tcf_classify() has been called with RCU
> > only on the ingress side for a rather long time. What contentions are you
> > talking about here?
>
> When one attaches filters to HTB, tcf_classify is called from
> htb_classify, which is called from htb_enqueue, which is called with the
> root spinlock of the qdisc taken.

So it has nothing to do with tcf_classify() itself... :-/

[...]

> > And doesn't TBF already work with mq? I mean you can attach it as
> > a leaf to each mq so that the tree lock will not be shared either, but you'd
> > lose the benefits of a global rate limit too.
>
> Yes, I'd lose not only the global rate limit, but also multi-level
> hierarchical limits, which are all provided by this HTB offload - that's
> why TBF is not really a replacement for this feature.

Interesting, please explain how your HTB offload still has a global rate
limit and borrowing across queues? I simply can't see it, all I can see
is you offload HTB into each queue in ->attach(), where I assume the
hardware will do rate limit on each queue, if the hardware also has a
global control, why it is not reflected on the root qdisc?

Thanks!
