Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE535B710
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 23:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhDKVoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 17:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhDKVoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 17:44:04 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B78EC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:43:47 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y2so10763224ybq.13
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FUKrWmUm6UGmZJeW6a9ud8YNwvzdrhjZvxD7V4mD6Vo=;
        b=cn+jyqgK150PQ3q/GwbQ1SOr8ZDBf5iOdEM1PeUhRZj8sw657NLloMPsxWY6QES0n9
         WazorZUzJrefzZhgdf430MeM8t116ebVJOIeDeEpS8G+miDIE3nBBHjoUcDREo0HrJgg
         4oa9EdAxEFUEbs9XSQVCNj6tmCLhApIy9HRU28f4CKRgv+hap8S+LsHhj/lg7hQrzKZk
         mKDQjsz8a4iFmKy7iahLTwV6vJnKtJCFzN/vfuOKUFNEAR9bm1+LPXm4+ELkkf+JQiie
         ufgDDS4yq/zGFaDpBuGyHrMbc2XFOg1NjK0XHsiJ44LGlt477mMXxr9PUoMOxC0nHIep
         PLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FUKrWmUm6UGmZJeW6a9ud8YNwvzdrhjZvxD7V4mD6Vo=;
        b=uHwid+bE54BqVr8wAWk2Zqo90/WchwhOz6jOIjCLmqytln/yWoobDHbhR0YBW4DERv
         kDuKQ+OQS4t0OquL1VH5zVeMilF7axg3YldCethCO+3HQYmvaeDg2Qa0TOKVcFOCxRI6
         KyDenWQJIx1uup4k03774XBFJkowtVMdx90+rIg/pXauHwpTdDzUmmjx4JmblMH70kl7
         bYFpzzC1a6uJThhY/UlbSKIY+P6sumylZ8NheY+z9gq5ZNFoA5ghFyZBPjxLVwcfJXDF
         I7UWy8XOfx7JP18daPFWzypmDgD5dX3PsNwLeRkyafXx0LFXBqbL8V+sdl9BfT5pZZWD
         9wrQ==
X-Gm-Message-State: AOAM531bLxVRoO1K8psyiQhet6u2hv+PL6Ivl876NBt21EVJHtwEA5dy
        dWWUww0LDaqOQohLHSlm2uI4z2lN0XoHzV9RrG5I0w==
X-Google-Smtp-Source: ABdhPJyDnRlc9xBGI7A2RAhl0955YjEdlQKPlpajuaxqEdykHYfrWQLeYNCN/xwiWhPEf7+iGYQLJyaj1nYMHwjwXgo=
X-Received: by 2002:a25:e89:: with SMTP id 131mr10844341ybo.132.1618177425276;
 Sun, 11 Apr 2021 14:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net> <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net> <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
 <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net>
In-Reply-To: <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 11 Apr 2021 23:43:33 +0200
Message-ID: <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 11:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/11/21 2:23 PM, Eric Dumazet wrote:
> > On Sun, Apr 11, 2021 at 10:37 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> On 4/11/21 8:06 AM, Eric Dumazet wrote:
> >>> On Sun, Apr 11, 2021 at 3:43 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>>
> >>>> This patch causes a virtio-net interface failure when booting sh4 images
> >>>> in qemu. The test case is nothing special: Just try to get an IP address
> >>>> using udhcpc. If it fails, udhcpc reports:
> >>>>
> >>>> udhcpc: started, v1.33.0
> >>>> udhcpc: sending discover
> >>>> FAIL
> >>>>
> >>>
> >>> Can you investigate where the incoming packet is dropped ?
> >>>
> >>
> >> Unless I am missing something, packets are not dropped. It looks more
> >> like udhcpc gets bad indigestion in the receive path and exits immediately.
> >> Plus, it doesn't happen all the time; sometimes it receives the discover
> >> response and is able to obtain an IP address.
> >>
> >> Overall this is quite puzzling since udhcpc exits immediately when the problem
> >> is seen, no matter which option I give it on the command line; it should not
> >> really do that.
> >
> >
> > Could you strace both cases and report differences you can spot ?
> >
> > strace -o STRACE -f -s 1000 udhcpc
> >
>
> I'll give it a try. It will take a while; I'll need to add strace to my root
> file systems first.
>
> As a quick hack, I added some debugging into the kernel; it looks like
> the data part of the dhcp discover response may get lost with your patch
> in place.

Data is not lost, the payload is whole contained in skb frags, which
was expected from my patch.

Maybe this sh arch does something wrong in this case.

This could be checksuming...

Please check

nstat -n
<run udhcpc>
nstat


>
> dhcp discover response with patch in place (bad):
>
> virtio_net virtio0 eth0: __udp4_lib_rcv: data 0x8ca4cc44 head 0x8ca4cc00 tail 0x8ca4cc4c len 556 datalen 548 caller ip_protocol_deliver_rcu+0xac/0x178
> 00000000: 70 c1 a9 8c 00 00 00 00 00 00 00 00 20 ee c3 7b 34 00 e0 7b 08 00 00 00 00 00 00 00 00 00 00 00  p........... ..{4..{............
> 00000020: 60 c8 ff ff ff ff ff ff 52 55 0a 00 02 02 08 00 45 10 02 40 00 00 00 00 40 11 6c 9c 0a 00 02 02  `.......RU......E..@....@.l.....
> 00000040: ff ff ff ff 00 43 00 44 02 2c e1 21 00 00 00 00 f0 6f a4 7b 00 00 80 00 ff ff ff ff 7f 45 4c 46  .....C.D.,.!.....o.{.........ELF
>                       ^^ udp header
>                                   ^^^^^ UDP length (556)
>                                               ^^ start of UDP data (dhcp discover reply)
> 00000060: 01 01 01 00 00 00 00 00 00 00 00 00 02 00 2a 00 01 00 00 00 b0 6e 40 00 34 00 00 00 2c f6 0a 00  ..............*......n@.4...,...
> 00000080: 17 00 00 00 34 00 20 00 08 00 28 00 16 00 15 00 06 00 00 00 34 00 00 00 34 00 40 00 34 00 40 00  ....4. ...(.........4...4.@.4.@.
> 000000a0: 00 01 00 00 00 01 00 00 04 00 00 00 04 00 00 00 03 00 00 00 34 01 00 00 34 01 40 00 34 01 40 00  ....................4...4.@.4.@.
> 000000c0: 15 00 00 00 15 00 00 00 04 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00 00 00 40 00 00 00 40 00  ..........................@...@.
> 000000e0: 1c e2 0a 00 1c e2 0a 00 05 00 00 00 00 00 01 00 01 00 00 00 38 ef 0a 00 38 ef 4b 00 38 ef 4b 00  ....................8...8.K.8.K.
> 00000100: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00  ................................
> 00000120: b8 00 00 00 00 4c f9 8f 24 02 00 00 36 00 00 00 50 e5 74 64 88 e0 0a 00 88 e0 4a 00 88 e0 4a 00  .....L..$...6...P.td......J...J.
> 00000140: 2c 00 00 00 2c 00 00 00 04 00 00 00 04 00 00 00 51 e5 74 64 00 00 00 00 00 00 00 00 00 00 00 00  ,...,...........Q.td............
> 00000160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 00000180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 00000200: 1c 63 5a 8c 00 3e a4 8c 88 f9 50 8c 0c ce a4 8c 0c ce a4 8c 24 81 a1 8c 00 00 00 00 1c 5c 5a 8c  .cZ..>....P.........$........\Z.
> 00000220: 04 b8 a5 8c 01 00 00 00 03 00 00 00                                                              ............
>
> dhcp discover response with patch reverted (ok):
>
> virtio_net virtio0 eth0: __udp4_lib_rcv: data 0x8ca4ca44 head 0x8ca4ca00 tail 0x8ca4cb00 len 556 datalen 368 caller ip_protocol_deliver_rcu+0xac/0x178
>                                                               ^^^^^^^^^^      ^^^^^^^^^^                 ^^^
> 00000000: 4c bd ab 8c 00 00 00 00 00 00 00 00 20 2e 85 7b 34 00 e0 7b 08 00 00 00 00 00 00 00 00 00 00 00  L........... ..{4..{............
> 00000020: 40 9a ff ff ff ff ff ff 52 55 0a 00 02 02 08 00 45 10 02 40 00 00 00 00 40 11 6c 9c 0a 00 02 02  @.......RU......E..@....@.l.....
>                                                                 ^^^^^ ip length (576)
> 00000040: ff ff ff ff 00 43 00 44 02 2c 06 18 02 01 06 00 e6 fd ce 5b 00 00 00 00 00 00 00 00 0a 00 02 0f  .....C.D.,.........[............
>                       ^^ udp header
>                                   ^^^^^ UDP length (556)
>                                               ^^ start of UDP data
> 00000060: 0a 00 02 02 00 00 00 00 52 54 00 12 34 56 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ........RT..4V..................
> 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 00000100: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00  ................................
> 00000120: b8 00 00 00 00 4d f9 8f 70 01 00 00 ea 00 00 00 50 e5 74 64 88 e0 0a 00 88 e0 4a 00 88 e0 4a 00  .....M..p.......P.td......J...J.
> 00000140: 2c 00 00 00 2c 00 00 00 04 00 00 00 04 00 00 00 51 e5 74 64 00 00 00 00 00 00 00 00 00 00 00 00  ,...,...........Q.td............
> 00000160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 00000180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 000001e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
> 00000200: 00 00 00 00 00 00 00 00 06 00 01 00 54 cc a4 8c 08 00 00 00 02 00 00 00 00 00 00 00 01 00 00 00  ............T...................
> 00000220: 08 00 00 00 00 00 00 00 14 cd a4 8c                                                              ............
