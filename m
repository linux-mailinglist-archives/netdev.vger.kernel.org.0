Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2771E865C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgE2SMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgE2SMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:12:23 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCDBC08C5C8
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:12:23 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v15so1587413ybk.2
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+untXdd8Q1TgRfqMW/LzrLvpYV7DIbqKdDLpBWZwtU=;
        b=svd+wbCVclpGzH16gM8M65x4qFSc/IBHfD//GF0SDTR0Haqe6wRlyv5d1mGYJ3gAgP
         1K/RuBL3bmQaSBkOcKX1+vrXEn7+qFSCcHxWlcH3ICl40hnk5tQuDRiS/xd3zelQWe74
         vzfVKdwN+IdEoDYDL9lhtYj8bWUK7/6yDND+7H2irBjmBsKKAi6eC1oaegSrQ3bHsi9q
         L3bXbRcGTHOEp4QDLaLvpyMFBBpsaVT2xQ0iZl2u8NlzphJxoB5V5WCr5N37RdDQvsYu
         w+uOZL2/o8dkzJKP6rzFykSCJHit7GNJssATXtNvEzifUFsYnQtDbZ48S3aJPe46NySM
         4Jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+untXdd8Q1TgRfqMW/LzrLvpYV7DIbqKdDLpBWZwtU=;
        b=GA/7Ep5GkdpcWnkJTYpuZxHfRpN8TFGqm273YWJwQ6LgJtrEsigmRMef8wZxTUZRPD
         nxThQVl+TxxGpjjBnN74MNvwt1yYVzDQrrYtNWLfSMaRPX/Igo9dRJpPlePNeET54pvG
         Rv1hPg8c4kfXyaQxcgNxlGdaz1QmjW/LohLa83XcZDl2KPWqiPxlCLF//rlRAaHqVPoj
         lnPRA54W13YPPIIHYl8vc0W5Ncm0WI0NST/JuyCPT6foM+t4GQ2vL7hHzD2a1+Q2tkpd
         LsGnlSaiEQKk2hHts8AthoE34gHzY3rBwdzDjXIcykhzwz9URSzlGU93PIxa6kQFw4Qb
         4ixQ==
X-Gm-Message-State: AOAM5303blj6aDl1o03DARh+K4LP4JS0ZDsTGPl1hkKQWbYAuyM26V31
        aSAhlFJjlYoPMlL69WT8gHD/e6sz/AaMA+re9VknVA==
X-Google-Smtp-Source: ABdhPJw3Za46WBQoDBh8gtmYUeDg3rtUPLxpth6ELpvhetb5GOwQtZwnDBhn5RpoaFo/X5yCr5IHDUV1AIzWSMcKpGU=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr15065186ybc.520.1590775942601;
 Fri, 29 May 2020 11:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200529180838.107255-1-edumazet@google.com>
In-Reply-To: <20200529180838.107255-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 May 2020 11:12:11 -0700
Message-ID: <CANn89iL1C7UmobyS-kohNE9mEnVdG_SrQEvjZr+oRcN=77UbtQ@mail.gmail.com>
Subject: Re: [PATCH net] l2tp: do not use inet_hash()/inet_unhash()
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        James Chapman <jchapman@katalix.com>,
        Andrii Nakryiko <andriin@fb.com>,
        syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 11:08 AM Eric Dumazet <edumazet@google.com> wrote:
>
> syzbot recently found a way to crash the kernel [1]
>
> Issue here is that inet_hash() & inet_unhash() are currently
> only meant to be used by TCP & DCCP, since only these protocols
> provide the needed hashinfo pointer.
>
> L2TP uses a single list (instead of a hash table)
>
> This old bug became an issue after commit 610236587600
> ("bpf: Add new cgroup attach type to enable sock modifications")
> since after this commit, sk_common_release() can be called
> while the L2TP socket is still considered 'hashed'.
>

> Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: James Chapman <jchapman@katalix.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
> ---
>

Will send a V2, I missed that ip and ipv6 modules were using a different rwlock.
