Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4EE2AF1C1
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKNMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgKKNMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:12:00 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC1C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:12:00 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id dj6so835414qvb.3
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=/W7GvreXakq3KKENAD14bEENonCuT2QBpLr+vZNyDdI=;
        b=tj/qPHnv/ayDVEmAqdA18U3qHCdY1DA35vc/KTLsrCBuIR09VdtatsGArIvY2Lla9J
         602XtspILlm8fagjfWD4aYQyZOKYID+bheTNzEuQ9UjM/PEHAQqa9Ajp8Q6gzinlMdHU
         mi2+tVAQT9cye3hyBjf5pAvqixGpsgMNqXIQTusvxb6BdiRyqRp6DXVm/WAyU9x8sHFV
         BpzfKwKK4er9vesVLU836UACw3zjIW7BJr+OKtYHOw7PjAxzm1IvysF3pE3/9j0cXz3+
         HHnRhxF54aoebmkgljEdc1bEndAEo77liM6Hhy8/sPji+uqA9i4mk91vJFdEeiKtg+Rb
         x/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=/W7GvreXakq3KKENAD14bEENonCuT2QBpLr+vZNyDdI=;
        b=OGDhJLZTvy93XV9Wslood7/R2SyqqKrbXj0CC/FmGbcOIoJBmvdvEAE6twjwHYx8Dq
         bD2L0bRYnp2iT/AJe22qtMHVxfV53DrIKHFsvzOF/em0WcFmwxjbLjfott81s3HiQsWU
         Spp3Tyj4ev5KmT/waTJhiAK7vJy2jyAINJpP/zZ/nvE06Fn5ymQvI/FW8ZQGRhozlLvg
         oS8iLxPFpQguh2NI0rC8LlicWL+tBQGaViOh3ONpHPqHVIDR5EP1U07aa3H0FoyXEgY3
         9TE6bcljCQXDPdXNxiRMtdfglN3wLgcol7hdfPy3kfb0EHbSJ7fgtFVoy4vy14oIay2i
         oaWA==
X-Gm-Message-State: AOAM530GgHCQnJZS3XzBGKwlT+xVVKeywkDD3JhXL+R3FKMqJ35HrHcg
        UWVhXWQtKlmeYhjkyT7qIipHUF19gZdsPYsWczNFhg==
X-Google-Smtp-Source: ABdhPJyOEw2mofCqFBA6XQfzpGuecD/O4uijixejPXs9UJu8uU1/bNEkycowdNLdtoawirfJHyVdiqGYIpe4RPVk9gc=
X-Received: by 2002:a0c:8d8b:: with SMTP id t11mr25274361qvb.13.1605100318985;
 Wed, 11 Nov 2020 05:11:58 -0800 (PST)
MIME-Version: 1.0
References: <00000000000088487805a116880c@google.com> <00000000000000c55c05a3813a66@google.com>
In-Reply-To: <00000000000000c55c05a3813a66@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:11:47 +0100
Message-ID: <CACT4Y+a0QfyMHLv0RP-=ihAUNpJpAVJbHFUWa6RT_0RupBE31g@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in tcindex_change
To:     syzbot <syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 9:05 PM syzbot
<syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit 0d1c3530e1bd38382edef72591b78e877e0edcd3
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Mar 12 05:42:28 2020 +0000
>
>     net_sched: keep alloc_hash updated after hash allocation
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a956d7e00000
> start commit:   ac309e77 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
> dashboard link: https://syzkaller.appspot.com/bug?extid=ba4bcf1563f90386910f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1771b973e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1248a61de00000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: net_sched: keep alloc_hash updated after hash allocation
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: net_sched: keep alloc_hash updated after hash allocation
