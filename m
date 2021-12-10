Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482ED4702F9
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbhLJOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:41:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242267AbhLJOlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639147080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XKxiU3MgedSihivIPXfbGZmn05XT0xvG+ufQk1N+WQ=;
        b=O2v3khXqlqGhprArHCm+j3cE7iMVHDmEY6q8e601cym6gAbQKZDz7LQLmQ5298kCXSTw2i
        dAxA2xCiwtZizXNbbLJ/zjGAIVLm8/Zv8aoHI96uZvISMZL4k4HR7+tl+ZfBWGeze4n7EU
        p1DJ4rH0LwkcGByCCryOKcKmnYLQ0zI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-_1jnQ7XwMFOqZt4HBVE0Ug-1; Fri, 10 Dec 2021 09:37:59 -0500
X-MC-Unique: _1jnQ7XwMFOqZt4HBVE0Ug-1
Received: by mail-qk1-f199.google.com with SMTP id u8-20020a05620a454800b00468482aac5dso10396675qkp.18
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:37:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7XKxiU3MgedSihivIPXfbGZmn05XT0xvG+ufQk1N+WQ=;
        b=53DD9+hpjMKoa0BVNHz4U9tQFfS4+crU8qdnZgbmXbOAodpUd6JNU7sLp45uAYlZnb
         CHV2Nk3Y5Hh2heWLsvEbbOQrMuCgP7IriKyHc1UA2FSU8W82avZwrKB38+o4gYlfbdFM
         aGs/Xwc/6unTHgxsERbEJD8uA0VCsuz8yOhm7hh3I17TR7Rcy7b4ZzDRe4QEJcUHwME6
         WJIYHYJvd8VkjRsGJEW8PjDq4izu7cyMNj+jA/d98HsMEbDqR/afp45d5XwBWsjaH6ZF
         Tnyoj3xIfzj2hQ5RxiWdlFYs1/ZsCG49S5afeVkemHrxIliCWNrwJzOVSTWHOH4bZvPR
         AIPw==
X-Gm-Message-State: AOAM532N5CQvAsVV3werUPQuxzL4oXlECxSHC9XnzHjp8w4bCXAtEKEu
        YKJ1N7Y77jMux1PL4KgwUoOlkUaiMEh+cMjj/dc89HUDSMo9ckpt8K9R3JTQ95kOzmWrn0o0pSM
        ksFkth/SZzjW9H8oP
X-Received: by 2002:a05:622a:48e:: with SMTP id p14mr26872967qtx.553.1639147078954;
        Fri, 10 Dec 2021 06:37:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmHHLdtzJvWqOcnVU8AcC3NlrCPmChU0xnKTY5iq+BqjhLk/HYFTvIUg/aaHe9l0TjIZv9Bg==
X-Received: by 2002:a05:622a:48e:: with SMTP id p14mr26872944qtx.553.1639147078722;
        Fri, 10 Dec 2021 06:37:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-237-50.dyn.eolo.it. [146.241.237.50])
        by smtp.gmail.com with ESMTPSA id l17sm1224892qkj.85.2021.12.10.06.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:37:58 -0800 (PST)
Message-ID: <d94b3f8903fe743583cbee16ac60528bd77b1be6.camel@redhat.com>
Subject: Re: [syzbot] general protection fault in inet_csk_accept
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Date:   Fri, 10 Dec 2021 15:37:54 +0100
In-Reply-To: <CANn89iKJY21Y3MZMXBpVqNm6BhudgfE+c-v7EU8gMUcbEFVs+A@mail.gmail.com>
References: <0000000000004c679505d2c8c1d4@google.com>
         <CANn89iKJY21Y3MZMXBpVqNm6BhudgfE+c-v7EU8gMUcbEFVs+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-10 at 03:13 -0800, Eric Dumazet wrote:
> On Fri, Dec 10, 2021 at 3:09 AM syzbot
> <syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com> wrote:
> > 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    2a987e65025e Merge tag 'perf-tools-fixes-for-v5.16-2021-12..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=166f73adb00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=221ffc09e39ebbd1
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e4d843bb96a9431e6331
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16280ae5b00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1000fdc5b00000
> > 
> > The issue was bisected to:
> > 
> 
> Note to MPTCP maintainers, I think this issue is MPTCP one, 

Indeed it is, thanks for the head-up!

> and the bisection result shown here seems not relevant.

yep.

> The C repro is however correct, I trigger an immediate crash.

The repro is not triggering here - but I'm using a different kconfig.
Still the repro itself gives a good hint on the root cause. I'm testing
a patch with syzbot.

Thanks!

Paolo


