Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808DD414CC8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbhIVPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:15:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhIVPPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 11:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632323626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5EPOrsCXJCI2JISUvTnGCdXaDuxLEQ6pf0yprZLLbiA=;
        b=ADZAaOT96xhV0Oknm7vsH1YAgCeWkuVpxfqPL7IQJ0DUk3fsvVp6C1Sum0KwqOfKlegBAv
        B0pB1l2wlCaM17Fo0u8doJic4xAYd0GI4ALN1LMMsi5GiV4nqjKrPQhkwWHF3+u1L9QZUI
        QR6KMJuOj3TmJkFpBDrBr2YhVDVJAFo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-8rOTL5a3OA218Hr1X4t7KQ-1; Wed, 22 Sep 2021 11:13:45 -0400
X-MC-Unique: 8rOTL5a3OA218Hr1X4t7KQ-1
Received: by mail-wr1-f70.google.com with SMTP id u10-20020adfae4a000000b0016022cb0d2bso2445404wrd.19
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 08:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5EPOrsCXJCI2JISUvTnGCdXaDuxLEQ6pf0yprZLLbiA=;
        b=gtCxIcJb40doINZxel9wmQ12cxXbxvBWsHxWmY4y05HQF9QM15y/baqBJK5KvGEaJD
         5nqnLxfMGozumLY1hyl2rvzrJoQzLyTvB91OID1YvFRZesjrkWxiz01L4sRf/oqL+npr
         46HV0aYG71YUUCMAwq6lg3CpW24ljBnEI1Y4i1sFHEU2BPvdQy/tBBGxTQmlChLR9Vye
         WDLeO6E7aGrVf74kKHimjAFpvBFsPX6hRl1hYs7J9CbPNmrNQ+teYkKQ9xcOqjIDvTWI
         MvUYV6pJtV1T5Jb1870vMP3AuVadlvZbG/il0ixeBCNnAs+ZZHwFt2na1xN3gtsPlEOh
         bYxg==
X-Gm-Message-State: AOAM5317fboasni814Q1R0+b+jpco4VTgjsSsdzB0W//NKVC8DH0Ls1L
        6HEirO+snXErlBiwOWYHUQIWWEi+3UcPW2hCaECtzz9YHdTHVjY/6Pl/sKnEvMVxXgbXSEEwZNq
        thi7o1rQwY2ODZIC2
X-Received: by 2002:a05:6000:1569:: with SMTP id 9mr26412wrz.337.1632323624402;
        Wed, 22 Sep 2021 08:13:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvnvC1X46a60tAUJjRFUNeH9O76Z4tTvV4A0XH/5wYBwm8hZIYhzLdFFgPJ1WG9X83xkic8A==
X-Received: by 2002:a05:6000:1569:: with SMTP id 9mr26378wrz.337.1632323624166;
        Wed, 22 Sep 2021 08:13:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-102-46.dyn.eolo.it. [146.241.102.46])
        by smtp.gmail.com with ESMTPSA id m4sm6559554wml.28.2021.09.22.08.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:13:43 -0700 (PDT)
Message-ID: <89d72aca4e30335a03322612cf164420be11d8eb.camel@redhat.com>
Subject: Re: [syzbot] INFO: rcu detected stall in sys_recvmmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     syzbot <syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com>,
        axboe@kernel.dk, christian.brauner@ubuntu.com, davem@davemloft.net,
        dkadashev@gmail.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Date:   Wed, 22 Sep 2021 17:13:42 +0200
In-Reply-To: <0000000000003216d705cc8a62d6@google.com>
References: <0000000000003216d705cc8a62d6@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-09-21 at 17:13 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1f77990c4b79 Add linux-next specific files for 20210920
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1383891d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ab1346371f2e6884
> dashboard link: https://syzkaller.appspot.com/bug?extid=3360da629681aa0d22fe
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1625f1ab300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17eb1b3b300000
> 
> The issue was bisected to:
> 
> commit 020250f31c4c75ac7687a673e29c00786582a5f4
> Author: Dmitry Kadashev <dkadashev@gmail.com>
> Date:   Thu Jul 8 06:34:43 2021 +0000
> 
>     namei: make do_linkat() take struct filename
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f5ef77300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f5ef77300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13f5ef77300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com
> Fixes: 020250f31c4c ("namei: make do_linkat() take struct filename")

I'm unsure why the bisection points to this commit. This looks like an
MPTCP specific issue, due to bad handling of MSG_WAITALL recvmsg()
flag.

I'll test a fix with syzbot to confirm the above.

Cheers,

Paolo

