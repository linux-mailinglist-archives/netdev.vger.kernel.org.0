Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F2522466
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 20:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfERSJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 14:09:56 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39021 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbfERSJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 14:09:56 -0400
Received: by mail-yw1-f65.google.com with SMTP id w21so4091548ywd.6
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qKwzC7+9dFa3APPTisEwxUdLiJEcokybHIkZLdfOQgU=;
        b=HP7uv2G7guSKmSVG8Z2PpC8Q+y2qv/S3jM8lQOSq9E99UtkRMLaGCEbmDtZmmoTKcM
         QsW3HaNs5Tk7fgkVGcrd9zXcUelxRpyODQASlHI5iOlWQgWWLe2MRIWPFjN29t3xBQ2q
         RL3ZJZ2LCdn5+vlWgchQhwy6oIZBPpu74IygxLQZmRjHIFNdljrHw6D8I3io0p/TBdH6
         nxVTHk8LTLglio3bcxaIXANCsFPUCU+C6NRxvHlDh+GMOWfK84aD07IiJbv3x/xCt7cg
         0AChUF9PLPlwcR6AORccDuXoMAsLg9GgjF/D2RHJu7T6sLUIwM/uHv453rPenfwkfNEz
         wyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qKwzC7+9dFa3APPTisEwxUdLiJEcokybHIkZLdfOQgU=;
        b=VGi21esxT6fhMeCqFKCbVpsNqAkWE/OfPBnnAiskNqCds5vXeGXH09wJy/UxhXVL1v
         jeC0VVfiw/0lb7n7QewJyuw82xsBY3N+1Vfgxa4vFPvSEXHDfM3SBxKxhsrhRSF7NEXb
         RuVOuoQQus0Obfl05TOEwquq+qTjZdH0qi+5zoW9lDiLYfgMbkcghWNd5p25LMgc1NRY
         Bu0FdbagXxgmr79bH0ikjBl5XhRO8V9b0Z81Uhl2gKRultD3KgT65q98UKrNdAK0+Q8P
         Z9CKR1H/FJHarPcGAqvC53InIyPRUeAXdohfNc6NKZ3gXiyCIAT++Lm57Zn9tlkUJPA2
         gMQQ==
X-Gm-Message-State: APjAAAWIKAVY0X6R5FcWYJXfHnbCxJcWgIKItYucX+srSY3oYTIxL+k0
        Ate4FgHAzj0S1E5XzxjNW8kVrU5B
X-Google-Smtp-Source: APXvYqzeoyzhW1h+ik5An7CIg5lClafRpTYkn6mkWDEb4+61PBRi/xzzLRTFOhjpjllylf6VgGyuxg==
X-Received: by 2002:a81:b649:: with SMTP id h9mr14257339ywk.233.1558202994279;
        Sat, 18 May 2019 11:09:54 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id i66sm3785705ywa.29.2019.05.18.11.09.52
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 11:09:52 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id a3so788572ybr.6
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 11:09:52 -0700 (PDT)
X-Received: by 2002:a25:6ec1:: with SMTP id j184mr7425869ybc.441.1558202991919;
 Sat, 18 May 2019 11:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014e65905892486ab@google.com>
In-Reply-To: <00000000000014e65905892486ab@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 18 May 2019 14:09:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
Message-ID: <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
Subject: Re: INFO: trying to register non-static key in rhashtable_walk_enter
To:     syzbot <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, jon.maloy@ericsson.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>, hujunwei4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 3:34 AM syzbot
<syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b7e608a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.

All these five rhashtable_walk_enter probably have the same root cause.

Bisected to commit 7e27e8d6130c (" tipc: switch order of device
registration to fix a crash"). Reverting that fixes it.

Before the commit, tipc_init succeeds. After the commit it fails at
register_pernet_subsys(&tipc_net_ops) due to error in

  tipc_init_net
    tipc_topsrv_start
      tipc_topsrv_create_listener
        sock_create_kern

On a related note, in tipc_topsrv_start srv is also not freed on later
error paths.
