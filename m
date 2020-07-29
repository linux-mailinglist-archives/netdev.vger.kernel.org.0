Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC030231C3E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgG2Jkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:40:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33607 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbgG2Jka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596015629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k7LhEO6XCqGVUuc17BRfAuaIUsyKpv0HJUC9DTzz2Oc=;
        b=TBOgzEkJTgQo//lafpsD2+YcX7VTZCWYb3AUeLD+sK5OHWPc+APplrl8iDAH6XtH6Wyr+m
        AhiHk5H5i+Wddoj+I6qCr2loiVc6PJ+Cu7Sywitrm27vK5zGbhA6/V0izvFqw4VViwEx6g
        O/8wORLJ8g/o68NCkp6bowfY6djS3gI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-BvkA2al6PM-3e_K-fN-tmQ-1; Wed, 29 Jul 2020 05:40:25 -0400
X-MC-Unique: BvkA2al6PM-3e_K-fN-tmQ-1
Received: by mail-wm1-f71.google.com with SMTP id s2so460282wmj.7
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 02:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7LhEO6XCqGVUuc17BRfAuaIUsyKpv0HJUC9DTzz2Oc=;
        b=pGVM61NImMnpHAdyjtIy5dtFR4Jc/XY7i1aqavdTM5d+H0kRHOf6c1f388QKHKUk7l
         rHOuHD3mH/+uU2y1lQpl2xy4ZYnAD9jHd+QH98VfnVsD6ZCtuJnQ93taETKpu1T1eVy8
         wcpur1kIIFkQawJ2aKODVAhYyvHSEFTWCE9TsN5cccskA1ORqKAwiIJR/c5O7ggsZm+g
         2jwrymKVLptLHtAbmK7WxXFoadghHOTQPR9S59jFfbNlzyIUabU15h0STFgZAroF3YAe
         oJEH8w3Vt15IUq8s5/yqRpuXcYKTjHLKrewmvfQiv/BR0X6WA38Q40vCVxhq8/DMk3Nc
         mwxQ==
X-Gm-Message-State: AOAM53237DFlZvDkqYDLSxvMtxJFJWzLAoOR7N8Isly4fQ/UM+qAfQI5
        apIM98mWVrqN5nG/bp2RzHYw97nmXa4+jE5OQet2wOxO6U53HwQVB5hNAA91X8KNAVEX1YKPYqW
        /Rpuzw7pz23uUNxv6
X-Received: by 2002:adf:9c8c:: with SMTP id d12mr28254564wre.369.1596015622990;
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSgh6jDxOdFmcD7rlJpBZFVipNvyIVfH2WgoMjLbmLGCkqivl8DMGS+QOpLJ4wheZJRWE1WQ==
X-Received: by 2002:adf:9c8c:: with SMTP id d12mr28254546wre.369.1596015622705;
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
Received: from steredhat.lan ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id x2sm534205wrg.73.2020.07.29.02.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
Date:   Wed, 29 Jul 2020 11:40:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, decui@microsoft.com, jhansen@vmware.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com,
        stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: general protection fault in vsock_poll
Message-ID: <20200729094018.x6rr2jlzh3ne4pgx@steredhat.lan>
References: <00000000000099052605aafb5923@google.com>
 <00000000000093b5dc05ab90c468@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000093b5dc05ab90c468@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 01:59:05AM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 408624af4c89989117bb2c6517bd50b7708a2fcd
> Author: Stefano Garzarella <sgarzare@redhat.com>
> Date:   Tue Dec 10 10:43:06 2019 +0000
> 
>     vsock: use local transport when it is loaded
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6489b100000
> start commit:   92ed3019 Linux 5.8-rc7
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1416489b100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1016489b100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=84f076779e989e69
> dashboard link: https://syzkaller.appspot.com/bug?extid=a61bac2fcc1a7c6623fe
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15930b64900000
> 
> Reported-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
> Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

I'll take a look.

At first glance it seems strange, because if sk_state is TCP_ESTABLISHED,
the transport shouldn't be NULL, that's why we didn't put the check.

Stefano

