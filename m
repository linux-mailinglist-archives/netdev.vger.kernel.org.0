Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C33D3DBE
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhGWQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWQB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:01:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED50BC061575;
        Fri, 23 Jul 2021 09:41:58 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l11-20020a7bc34b0000b029021f84fcaf75so3888255wmj.1;
        Fri, 23 Jul 2021 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKcGLfoD9TifhdJXIgESp/Ou26LogBJvsS4IIjesSJI=;
        b=Y1Z35BkdiDVnrk35+EaejDIW4grPLIYXbt4v76JCB7pUskuaO3XTH9cGqOsfK2xsW8
         BykjYwZ8gSRpYNbTBDfCfIfE/VTqixQ4CdlXZ5U7LgbKJyW0aRBCBF3/cMX3xVJmUq/A
         9id+3I7rxE86HekU3dgi/VfgQQ9QfQzWxYxo2LENdHoxWG+cfW9apC/sqdma/aansIt4
         CvHejzGxSvzBxslnxTpNwxw1VJwYwF/w6WYGms9F8+Hlxo+iylWkvgFMW88ZeNQuNyRI
         b0N+duAEWpekIRWv5T8Y64yt2vEwUzL+oRq0dedMfeQI+ip16uQyr0EiKOsN4Zf4k3Sy
         PWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKcGLfoD9TifhdJXIgESp/Ou26LogBJvsS4IIjesSJI=;
        b=idHyEmrrjMk8prpHMPR+lgWwVN+YSsSzPtEnMtmYsRy766iZtWnRhrpJrZ2AikrA8g
         jKn5eulTHlGGQJZI/ITEa0HkWS0OPaJqKTrwKSoy9fxFKOeZzLe9ybXE23qJON67r6PX
         u2QgT9sdtog6D0cDQSWZqPKWVbcijQnrgqWm4JQ3qbZv52ZkXdqn3L4B4giOK94s0t6N
         YRja640wPk36q7LlYtgSxfO9SEP2MyeRYqsDjCsO1w8gU0g83ZK2O8ZWrOPW6uZr61df
         yutDok1rkpFbfAJkDXP8ssQVHoFx6RQOiLgcSx2FU5WDznjQiVhq++atIG3yVhaxsNhq
         UN6g==
X-Gm-Message-State: AOAM532+G/ZQq48WSDqeJfyW8K5B2a9z5nGp0Jrl4sB7VXUJ1z8+Toji
        Y9YrkRyabvNTcJII1Hwq+bFA5qiK5iXfa3cPv0E=
X-Google-Smtp-Source: ABdhPJzY//oqFZ+iEmD3tqJ/d59/BYkVmE6krYc5agCgtKL0URlmz4mcJnzLzJx9Hv0HCribkUOqz2zHWl5arVgSEc8=
X-Received: by 2002:a1c:6354:: with SMTP id x81mr15528670wmb.12.1627058517517;
 Fri, 23 Jul 2021 09:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000017e9a105c768f7a0@google.com> <20210723193611.746e7071@gmail.com>
In-Reply-To: <20210723193611.746e7071@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 23 Jul 2021 12:41:46 -0400
Message-ID: <CADvbK_dkv-DDt_VSSn1NQnzrUuxPm0T2Mki46T0jdwfUxENW-Q@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, devicetree@vger.kernel.org,
        frowand.list@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>, rafael@kernel.org,
        robh+dt@kernel.org, robh@kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a fix already posted in tipc-discussion:

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9b0b311c7ec1..b0dd183a4dbc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1973,10 +1973,12 @@ static int tipc_recvmsg(struct socket *sock,
struct msghdr *m,
                tipc_node_distr_xmit(sock_net(sk), &xmitq);
        }

-       if (!skb_cb->bytes_read)
-               tsk_advance_rx_queue(sk);
+       if (skb_cb->bytes_read)
+               goto exit;
+
+       tsk_advance_rx_queue(sk);

-       if (likely(!connected) || skb_cb->bytes_read)
+       if (likely(!connected))
                goto exit;

On Fri, Jul 23, 2021 at 12:38 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Sun, 18 Jul 2021 10:15:19 -0700
> syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    ab0441b4a920 Merge branch 'vmxnet3-version-6'
> > git tree:       net-next
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=1744ac6a300000 kernel
> > config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d syz
> > repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=13973a74300000 C
> > reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ffc902300000
> >
> > The issue was bisected to:
> >
> > commit 67a3156453859ceb40dc4448b7a6a99ea0ad27c7
> > Author: Rob Herring <robh@kernel.org>
> > Date:   Thu May 27 19:45:47 2021 +0000
> >
> >     of: Merge of_address_to_resource() and
> > of_pci_address_to_resource() implementations
> >
> > bisection log:
> > https://syzkaller.appspot.com/x/bisect.txt?x=129b0438300000 final
> > oops:     https://syzkaller.appspot.com/x/report.txt?x=119b0438300000
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=169b0438300000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the
> > commit: Reported-by:
> > syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com Fixes:
> > 67a315645385 ("of: Merge of_address_to_resource() and
> > of_pci_address_to_resource() implementations")
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90
> > net/tipc/socket.c:1979 Read of size 4 at addr ffff8880328cf1c0 by
> > task kworker/u4:0/8
> >
>
> Since code accesing skb_cb after possible kfree_skb() call let's just
> store bytes_read to variable and use it instead of acessing
> skb_cb->bytes_read
>
> #syz test
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
>
>
> With regards,
> Pavel Skripkin
