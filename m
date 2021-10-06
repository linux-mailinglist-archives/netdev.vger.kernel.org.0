Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1942394C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbhJFIDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:03:02 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59445 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbhJFICJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:02:09 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MgiPE-1mzeQe09Yy-00h4UC; Wed, 06 Oct 2021 10:00:16 +0200
Received: by mail-wr1-f53.google.com with SMTP id v17so6010342wrv.9;
        Wed, 06 Oct 2021 01:00:15 -0700 (PDT)
X-Gm-Message-State: AOAM532JfmaH/WdZyVk5CUlhEmvhlXjXgq6BnjFnbNJrf4/ArQ+YTsIY
        0/9c+U95PMg+0d8ZVRO9dafp626jKWvOqV3Bk/E=
X-Google-Smtp-Source: ABdhPJx1B6sq1wIFIHEgKyIYlFJECGS29SE+8n1OZvj4+MxWvWc2dw4XL/yDMggL2AOkfh3x5EYDpX86eElZa6VtbDk=
X-Received: by 2002:adf:f481:: with SMTP id l1mr26668591wro.411.1633507215588;
 Wed, 06 Oct 2021 01:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211006074547.14724-1-rpalethorpe@suse.com>
In-Reply-To: <20211006074547.14724-1-rpalethorpe@suse.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 6 Oct 2021 09:59:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0COfvLvnL7WCZY6xp+y=gKhm_RakUJbR9DSbzjit3pGQ@mail.gmail.com>
Message-ID: <CAK8P3a0COfvLvnL7WCZY6xp+y=gKhm_RakUJbR9DSbzjit3pGQ@mail.gmail.com>
Subject: Re: [PATCH] vsock: Handle compat 32-bit timeout
To:     Richard Palethorpe <rpalethorpe@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, rpalethorpe@richiejp.com
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:zFREbTdf/gpkV7ecjxLpuI2dssi+Qytc7y8eXBW3+wm8Rlb2e0P
 jPK85vzx8BUixlXbsde/tqc0sor5ZufzNFWrFUNdAh+QP5vF5UChafZ9HwQ05m0uQX/Fp07
 jOnDDUrSpfMbGRKD1nCqkrWZ0w8a8/Sp659ndlXqpNTACp06pWpYBJPYsNv29H+d4++sZNh
 nKtEQK9yCZnNea+DVu5Ew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yMiMrOHZqhI=:w+0YOByp+ua492OViLE3sv
 kuxyLXbbpKHX3DkYM9UZRO31MwYtQRXl/pho9aazjirZ0Z1gZm+b/dZV7MfF8oZjZRudJrmoN
 ifg03hg7Bkigg8P8XN1LITZ1EEt7R7hBcu5yFRqrJOlz8e08AuHEiLJvxDKVy/FpY7HKIJMLe
 XmvVZP7b3hKUJ+Pnof5t+V6+Ubksi25P5d0J7lGVoAEmc8AkHT2WNJTMcW9cS2vm9rj1cSnab
 /jPK9467bNgPrczPcwV7geXipDZT5/qxpw99OkpswuOPwGZgSpBEtOdOMq0mXCJuj11UimBqp
 ribm2RMndlBUTj2WGkbaB5LF36vi7SVWxxIQJEy/vtRAPy57LB0IO4gMMklAeKsD7T+2paTaU
 ejOpKxwNZcUrGdvt/6OmOhrgIv6BdNJgU2durPEaNZOIbKmzaHwxymUMFeTjjkYu8f13GAgRE
 kDISrVoYIje7KxVVAq9JzrOQD8uXPTXzFomVmFMadUPjO6Aq1oDBOkarm4RCatrQKXuciwkz+
 iwyTxgCFmDRkl4FIvdUvLTbYjtrynn7+KvmrIjB8+w1VHy+ZzA7Nt2WUvWqlfBpkoReAKdMOQ
 3UUFK//r5cgzDg5BXDvxzPb6Hc12BMeH8baZxdfdhH0FM7v0sMBEi+Z6WGYMGyPMZPfRff/4L
 MVEeX8yoEmS5+3QVXfjsSsH0va0c2rnlmlAiip2WsWvPRI1NflPOaEHNuXLHRGIFJW2PlSGo+
 LlrQyeDa1NMmviNf6iS7aLS5bWY9/MQxBPHOneqSJVDhXKuoqMwGqwNO0CWh832xJbh6X/TSs
 jwnI460kV741cJ0PcpCzzBxIN51PVTWp/cYXlxoGao0sDwMOpMpaxpWwWLmsd9PTOppGWTVff
 8b1lRqJd7kRMBM5CMmLA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 9:48 AM Richard Palethorpe <rpalethorpe@suse.com> wrote:
>
> Allow 32-bit timevals to be used with a 64-bit kernel.
>
> This allows the LTP regression test vsock01 to run without
> modification in 32-bit compat mode.
>
> Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
>
> ---
>
> This is one of those fixes where I am not sure if we should just
> change the test instead. Because it's not clear if someone is likely
> to use vsock's in 32-bit compat mode?

We try very hard to ensure that compat mode works for every interface,
so it should be fixed in the kernel. Running compat mode is common
on memory-restricted machines, e.g. on cloud platforms and on deeply
embedded systems.

However, I think fixing the SO_VM_SOCKETS_CONNECT_TIMEOUT
to support 64-bit timeouts would actually be more important here. I think
what you need to do is to define the macro the same way
as the SO_TIMESTAMP one:

#define SO_RCVTIMEO (sizeof(time_t) == sizeof(__kernel_long_t) ? \
             SO_RCVTIMEO_OLD : SO_RCVTIMEO_NEW)
#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? \
             SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
...

to ensure that user space picks an interface that matches the
user space definition of 'struct timeval'.

Your change looks correct otherwise, but I think you should first
add the new interface for 64-bit timeouts, since that likely changes
the code in a way that makes your current patch no longer the
best way to write it.

       Arnd
