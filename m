Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A843946E3A3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhLIIEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLIIEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:04:21 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207FDC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:00:48 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v203so11757581ybe.6
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 00:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7QisQKK1jSa5VBzzUpw4VqQ+Yo7QjjIW3wdQF4URmw=;
        b=Vl59z+wTmb6FbQD/I9ZwPHiBEM/lXxuW8TxSSP4y7e1uoYYq//OM/iivAArTV2P+zY
         5Ftz+rh7CU9XR8SBJ2DvICoeuuSpXBos6YuFAZoVcEXRqpdTqm5aLbk0b8AClbhZCixJ
         QPjL6iIyL4BPA6Ej4DLSzTRROcW9CW1HreAzEvhBLNTvUlP6XYrv0YUFw1NYLu3mghdP
         WKVyRNY5T7NG9hWoaAQUsiI2nk1Td06AshHLHgmkkdZkeV6tYImfKc01AZQVWlhQEcDq
         6Ggn339PycTJXhDSI3o6saQ1co5EHBqy3zaeqdeMx6srPAx9yS+H6bDItvMYYOXGtLli
         brnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7QisQKK1jSa5VBzzUpw4VqQ+Yo7QjjIW3wdQF4URmw=;
        b=etCbpdQ8YLSLvGfXNa0tYbFOjlTm+1TfoaZyqoPu8LKYKAjBakkH5aIHAfTfHsoJ2t
         5xLBFplHlWdqm+1XlcGeSy7Tpzj3edCQuniv1L0eZ+d4mlplQ/osANyXHZaBB3SU8MUn
         4Za3YuBrpz8ThSN+g87oATDQ/xilpDr9fADjT6uLWMG6d6ZrLI0rGISpJ0ykM6BORH5j
         YQFOKpX+d78JmBC1AECU8b05YDtuUBSVcwB6QsLQSBPZjTDVSMuHp5Xhpznwm1xiHzuF
         fh2Q8w5VkInAIQMvu5ckDK2OdS7NVHhgZ51F5wqLMcM7PXwVPCXOJT/kgalt7ovepLEU
         zrGg==
X-Gm-Message-State: AOAM530gHk+iQQ8SZL7zg+fx8g0MJyKwKjouEoKwil41Q7Eqf8vIdl4a
        VjHMiD5K9koPpGGhalnSHN0KgeqpBEc/2wJpKP1XWg==
X-Google-Smtp-Source: ABdhPJwp/iEmqGtD204Mgm0Jb27/zMhKXrbP4fJ+A5MVaVdM+TuS6YX4wice54QbfNFRggUNSAvXrf/HpuRllMy0FcQ=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr4640258ybt.156.1639036847016;
 Thu, 09 Dec 2021 00:00:47 -0800 (PST)
MIME-Version: 1.0
References: <20211209013250.44347-1-kuniyu@amazon.co.jp>
In-Reply-To: <20211209013250.44347-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Dec 2021 00:00:35 -0800
Message-ID: <CANn89iJ12OugQTv4JHwVWKtZp88sbQKXD61PvnQWOo3009tTKQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] tcp: Warn if sock_owned_by_user() is true in tcp_child_process().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> While creating a child socket from ACK (not TCP Fast Open case), before
> v2.3.41, we used to call bh_lock_sock() later than now; it was called just
> before tcp_rcv_state_process().  The full socket was put into an accept
> queue and exposed to other CPUs before bh_lock_sock() so that process
> context might have acquired the lock by then.  Thus, we had to check if any
> process context was accessing the socket before tcp_rcv_state_process().
>

I think you misunderstood me.

I think this code is not dead yet, so I would :

Not include a Fixes: tag to avoid unnecessary backports (of a patch
and its revert)

If you want to get syzbot coverage for few releases, especially with
MPTCP and synflood,
you  can then submit a patch like the following.

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17..19da6e442fca 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -843,6 +843,9 @@ int tcp_child_process(struct sock *parent, struct
sock *child,
                 * in main socket hash table and lock on listening
                 * socket does not protect us more.
                 */
+
+               /* Check if this code path is obsolete ? */
+               WARN_ON_ONCE(1);
                __sk_add_backlog(child, skb);
        }
