Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2AE333019
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhCIUkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhCIUkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:40:13 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EC5C06174A;
        Tue,  9 Mar 2021 12:40:12 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id v2so16518575lft.9;
        Tue, 09 Mar 2021 12:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xx82RtkNjKUidXeOgDKcY7HvxO1Hnef7TiNr4pRn4Q=;
        b=KY0hdqLqthB5dH+OJucInorKfaNUZqtsMeGjI79ZJcssu/6Uwxf/34unEcRveOdOLH
         XPvexut7erm5Run7sxmtRmRaMW5SHEMKWUsKg37LEfKuB+m6cUGKSbOVA8Yvj/yt0nRF
         eDxSE/CCTllk3oAT60FVEVDTHS/xmNo8CR4Y7ZJso80IPVfNznNG6NdN++7Wgg13KLQQ
         vI7yKMtWoCwX/H1iIJzlFs+xdGdqmf3aF1Mbut3RrkIf9Qw5LG9LDXjYU5J4Urge9CbM
         3xuh1Yz7BkmSf65CbUnMOZcncaaQxFoNj/7KZ1tP2T2+bH+CeAacgTxrsqAQqNoJ29Qz
         if+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xx82RtkNjKUidXeOgDKcY7HvxO1Hnef7TiNr4pRn4Q=;
        b=DRhs14HaY1Rkvsbj/mOLGGeRoWcYGDJY7AyHEZhmxG6P21acVWC4e9EWAmKiz0rZGP
         MuyKQA+NojSDs+yjTWFIu/MpvTnzIqdldu2H6yJgY5SJg7aT9W7iSGFRIeUG2rRonK1L
         towSVqKJOFsS4zDfSdGC54yPWNIHg8eDfXk+ZiiXPnxs1AsqX/OACboA/9wo2tMM13b9
         czWSOwIqLn4D1CGfZUFYVF/4crOnfFhhWzrjkMjmH3Fc8yTbsQcgB63VvGr/V9/kmZ77
         jL/vv7031eMveOeEwfs6VwvQTrluVTT6Qf68bnvlXHqIYIiStnh0HInTWDX48OC6iy4+
         sSKQ==
X-Gm-Message-State: AOAM533C2HhuA28lA9z1mSdtRI4RLFh9xChOue1weJ/pksghR8YvGKvU
        0vUzyFG7JPac1qmJBMtfQ9zyXWXMNf7BLsOTZc4=
X-Google-Smtp-Source: ABdhPJxfrYj3coUqt82BUSqFQO2q2Kpjt7phXIuqG8JkXYBbSiqkWmpTstcRkHZZLj/g8GmaXszIeG7dbrBG2L3MvhI=
X-Received: by 2002:a05:6512:2254:: with SMTP id i20mr18809952lfu.534.1615322411488;
 Tue, 09 Mar 2021 12:40:11 -0800 (PST)
MIME-Version: 1.0
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home> <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
 <20210309150227.48281a18@gandalf.local.home> <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
 <20210309153504.0b06ded1@gandalf.local.home>
In-Reply-To: <20210309153504.0b06ded1@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Mar 2021 12:39:59 -0800
Message-ID: <CAADnVQJe7GQjYvdBYvG3opeAdaY2EY2vtRafSp0zZ+Pe=Nnsdg@mail.gmail.com>
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 12:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> The size of the fields and order changes all the time in various events. I
> recommend doing so *all the time*. If you upgrade a kernel, then all the bpf
> programs you have for that kernel should also be updated. You can't rely on
> fields being the same, size or order. The best you can do is expect the
> field to continue to exist, and that's not even a guarantee.

+1. Tracing bpf progs already do that.
Old style tracing progs do it based on the kernel version.
New style is using CO-RE.
