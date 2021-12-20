Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3435B47A52B
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 07:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbhLTGx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 01:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbhLTGx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 01:53:57 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB6CC06173F
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 22:53:57 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so11410451otl.8
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 22:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mCjlLyB/hr7kOH2wdl8Y3S5J5sgaMUYSj4diCluHMU=;
        b=QCiUOGRFKDvoAPrOxdicBzRpKxywBtYA3FQVyizYrOJkRSVA8w8pRkXf9iNvfomRK0
         acRbCx+cWJNMbZgeNL0Pom3e8omIogIKSyvXhQdIxd0+aHLfKECNJwRNmH87OgNDODBa
         39eF6wXCU3QgVQtz+ycyjZ4MGZKUmVhRhUsArkqVOVBsrqLwP2uc2pLQ2gyJZ8PFgUb2
         sjp1PHpOzZybjTMxADWbZ5tQg3/BpJc9pNTBc6QzpNYTC1Bsq2+W0G/F9mhz4mcbAKpR
         TbnEMxrIHpm10T1awgd5ZpC3MdnixLz1ZN5ORE8PHTawS/dlfXGc1uL9/Tcyj+Mx6qX2
         RgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mCjlLyB/hr7kOH2wdl8Y3S5J5sgaMUYSj4diCluHMU=;
        b=O9IHt4T9MaHbDgm4cfn/rfF9PgRzW3RhUcFbtn/3wsvBg8h/IBEVk26WMbiAqfR85V
         1I2YVQIi/2XFvFW63ecm3Su5TIP+6msmOkXV7VsyqP63NDnAKrv+BXmwl5Pek+hY06Zr
         baEF8+k/gp/PK/xxhuETVZqTgxzoNxoriCHzl9ezRSkHHR+8hGTqXWEyFWtNVeS5BakZ
         8+0mJdKUwhl1ihPo85WP3DyMTM9eS2KIuoQDMb/EtgU3QHSkitBcBTsrOBfwfcgnahNd
         Q5kjyuyC+wYvSM7G+Z8yaMKj3rNuTTXLahBYa1r4tCKaFAQ/l8mGUGPjKx1zlfzjqEFp
         4zyQ==
X-Gm-Message-State: AOAM533ypQ4AVe2gL4kZuVJIRcGJYelr8IJhpPkdYtUBkHZvei5L0339
        O9jpDX4f+pmoHDfcLT8vb2jS3IYuhuCwAZamoWfZUZc62AA+0Q==
X-Google-Smtp-Source: ABdhPJwXQ439oJ+c9KcQ4qYRzZ3F1IaIYlQnSzexr/F3/DP6FANIf6NjLWY5QeEfUHIfws3WidVmc5gaEE42wwbiLOo=
X-Received: by 2002:a05:6830:2425:: with SMTP id k5mr10268366ots.319.1639983236347;
 Sun, 19 Dec 2021 22:53:56 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000a337b05bb76ff8b@google.com> <000000000000ba831905d367af3e@google.com>
In-Reply-To: <000000000000ba831905d367af3e@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 20 Dec 2021 07:53:45 +0100
Message-ID: <CACT4Y+aPM1nYBMi7QWswWCzPb1a9tb1BA3cznXuDo=sFB2hPsg@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in disconnect_work
To:     syzbot <syzbot+060f9ce2b428f88a288f@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, phind.uet@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Dec 2021 at 09:46, syzbot
<syzbot+060f9ce2b428f88a288f@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2
> Author: Nguyen Dinh Phi <phind.uet@gmail.com>
> Date:   Wed Oct 27 17:37:22 2021 +0000
>
>     cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ad179db00000
> start commit:   f40ddce88593 Linux 5.11
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=51ab7ccaffffc30c
> dashboard link: https://syzkaller.appspot.com/bug?extid=060f9ce2b428f88a288f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1217953cd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13baa822d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type
