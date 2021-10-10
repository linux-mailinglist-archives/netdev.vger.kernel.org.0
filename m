Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03E42800F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhJJIit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 04:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhJJIir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 04:38:47 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B872EC061570;
        Sun, 10 Oct 2021 01:36:48 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 14E51C01F; Sun, 10 Oct 2021 10:36:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1633855004; bh=PygQilpGLXQp/m5q/cQ5cIzutlJQqkg4SJFesAi9P8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BjD87zYPLFsw77E2js0UYi4S9wKRWWd9PrAtqwW8xFXt3YJ+lwTMbmOVNJoO/NSCF
         kkTf9o9Qh3ghTlXUcB38odq9rzL+/XLxWyyUDDv/ryCsavJdsRtRn3tD0UWe/Znat8
         c0wM+Egt8eBDVQqVbJsndS/zhEiko04uSWLp/uYAWaFuQ+OToQVUka3E+qgRUPHEQg
         zh1hoGvBFLnZlz1FIMsz+2w3CIKzaCc0ss+TTfOh4rYjwrk/Sv9WQvfGytBb5gSyiH
         usyR/LCjpQ6cJgGZdo3Y04ZNMzXxSuwuSf4mfQYD5+D5iwa9oyKSyYK/Aj6D/tGXbU
         H/kn9ywBz53gA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=5.0 tests=SORTED_RECIPS,
        UNPARSEABLE_RELAY autolearn=no version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 29F4AC01F;
        Sun, 10 Oct 2021 10:36:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1633855003; bh=PygQilpGLXQp/m5q/cQ5cIzutlJQqkg4SJFesAi9P8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZJxMa5/7JNeCyd0S8Fm3XyI59WOFsyPlo9o2wGxHSqP9WGQYJ/SrATCy1QtsVlwj
         FQWj7adpuKzkit//dY7FO31RRagywr0LLYB+BrxNHKLObxBm4HQxuoU8EORxtmqyvB
         w7XfAHZTdQM/QsFhaUe6nqajDDQ46u81ePrhdMnkjmMIZdl0rR2PJoErI2Pd0CNfKE
         upAO8W0tJjUs2KqGUiNeF2fMrDTkRjJJRsLFpWCEzPtgMMEqx98tBCrg3bIExEN9hb
         QAlB0F6dbC7iiJUdXVsELVH6rqON6LArRZqNuiPWXPB8p64ctqCHHAfZl8aKA0TDSJ
         ncWNUTThWRqHg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1d23b4bb;
        Sun, 10 Oct 2021 08:36:36 +0000 (UTC)
Date:   Sun, 10 Oct 2021 17:36:21 +0900
From:   asmadeus@codewreck.org
To:     syzbot <syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, ericvh@gmail.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KMSAN: uninit-value in p9pdu_readf
Message-ID: <YWKmBWfBS3oshQ/z@codewreck.org>
References: <000000000000baddc805cdf928c3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000baddc805cdf928c3@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Question for people who know about KMSAN: which of the backtrace or the
'Local variable' message should I trust?

syzbot wrote on Sat, Oct 09, 2021 at 10:48:17PM -0700:
> =====================================================
> BUG: KMSAN: uninit-value in p9pdu_vreadf net/9p/protocol.c:147 [inline]
> BUG: KMSAN: uninit-value in p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
>  p9pdu_vreadf net/9p/protocol.c:147 [inline]
>  p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
>  p9pdu_vreadf net/9p/protocol.c:198 [inline]
>  p9pdu_readf+0x2080/0x4fc0 net/9p/protocol.c:526
>  p9_client_stat+0x2b3/0x710 net/9p/client.c:1724
>  v9fs_mount+0xc14/0x12c0 fs/9p/vfs_super.c:170

would be 'len' in p9pdu_vreadf, which has to be set as far as I can understand:
> uint16_t len;
> 
> errcode = p9pdu_readf(pdu, proto_version,
>                                 "w", &len);
> if (errcode)
>         break;
> 
> *sptr = kmalloc(len + 1, GFP_NOFS);

with relevant part of p9pdu_readf being:
> case 'w':{
>                int16_t *val = va_arg(ap, int16_t *);
>                __le16 le_val;
>                if (pdu_read(pdu, &le_val, sizeof(le_val))) {
>                        errcode = -EFAULT;
>                        break;
>                }
>                *val = le16_to_cpu(le_val);
>        }
> ...
> return errcode;

e.g. either len or errcode should be set...

But:
> Local variable ----ecode@p9_check_errors created at:
>  p9_check_errors+0x68/0xb90 net/9p/client.c:506
>  p9_client_rpc+0xd90/0x1410 net/9p/client.c:801

is something totally different, p9_client_rpc happens before the
p9pdu_readf call in p9_client_stat, and ecode is local to
p9_check_errors, I don't see how it could get that far.

Note that inspecting p9_check_errors manually, there is a case where
ecode is returned (indirectly through err = -ecode) without being
initialized, so I will send a patch for that at least, but I have no
idea if that is what has been reported and it should be trivial to
reproduce so I do not see why syzbot does not have a reproducer -- it
retries running the last program that triggered the error before sending
the report, right?

-- 
Dominique Martinet | Asmadeus
