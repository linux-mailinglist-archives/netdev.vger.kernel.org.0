Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2704A2AEF45
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKKLMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgKKLMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:12:18 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57721C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:12:18 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id n132so1271714qke.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WblSjW7Hy1Qg/G9ygaqee8dLuPciIb0PMDRXWK2yB3I=;
        b=mnoXeYYU9FZvxitCgz+s3IfMrgwI92vcPOfjlpLHfCKQ0i916WWDlzOVGj5faz2D9+
         JXDBkB6Sqv5zDJCTOyJP86i9c7z/OeJz1YDk1McIBYw9hrCsly2glRfgS4dDw9xmC1vj
         NPO/Y3ydEZHxMbD++b7hkNodPdDlqOxg74S5UE2qyakpVvg/pNP5O2Hsi0wHiKa8ur1V
         QqScNUC3sx+DtFLhy2H2G+PKibPl3zNqX2JQhIwKceYMlWbMggEJPSUOMIr5d3LM9+eT
         AuXp2vy8WuYE8VhaYajRR/fikF2jfNaJWD51CG3aYsWb886PT2kBX8r/XrWSnvAIwEMs
         4wrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WblSjW7Hy1Qg/G9ygaqee8dLuPciIb0PMDRXWK2yB3I=;
        b=q1iwsvZhA4P3/yVShN+OtAIzLEPrAFRVsPLcos+SDZ+Gv3WrR/LnJMqaSPyFB/Ry5/
         3rEuAFIRsNMoXhlg0JBbnva61s7H4DRLdPKFI3RI6D/4fMnGk4hYGT1446eZlAdY1G21
         L33itNFa5RcwqMGkau1g+V1VTs6LyKxjfh3a0xOnOK8mE8aIoeYEsZzX5d0UeDH6pz9e
         i4FOk5nFEnqQwaPAIHjOKKVDLrwzvjoQk4Y0+9nv7TQjphaLtdar6HUJ/bBnavgQlyDD
         cHlLq7HlP5Gk98D+91Z8o+iNqEW9/in4foI+N4UP8g0PbTs18K0EcrmVTJ1DZOTWEc5j
         5kuQ==
X-Gm-Message-State: AOAM5302NlPAlOhaBTOjCvsrID1x5U+8Oh7xC9kFwZ3hBswQMfG7Q5h1
        hcUtLK1R/TSylLxuISDpnPbK0iUPD7Q35TrkdbDEdA==
X-Google-Smtp-Source: ABdhPJytmEudtqCvqu9Cia4M/vz8rvbh5JQqeb7dFN0b5G22lRbkjrL2sa5NNnZ0sXR/eE6YVQcWrXHOQaQh0zml8/Q=
X-Received: by 2002:a05:620a:15ce:: with SMTP id o14mr25226279qkm.231.1605093137327;
 Wed, 11 Nov 2020 03:12:17 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a48f9e05aef6cce1@google.com> <000000000000b4227e05b3aa8101@google.com>
In-Reply-To: <000000000000b4227e05b3aa8101@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 12:12:06 +0100
Message-ID: <CACT4Y+Zy=m_K=rHpzi09tOd6YuQe6Dzk9vLvNoZk8Oo1hVG55g@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in exit_group
To:     syzbot <syzbot+1a14a0f8ce1a06d4415f@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, mareklindner@neomailbox.ch,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        netdev <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 12:03 PM syzbot
<syzbot+1a14a0f8ce1a06d4415f@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri Oct 16 12:21:14 2020 +0000
>
>     afs: Fix cell removal
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b65c3a500000
> start commit:   34d4ddd3 Merge tag 'linux-kselftest-5.9-rc5' of git://git...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a14a0f8ce1a06d4415f
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c6642d900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132d00fd900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: afs: Fix cell removal
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: afs: Fix cell removal
