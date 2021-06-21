Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BAC3AF1CE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFURYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhFURYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:24:09 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDDDC061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:21:55 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v22-20020a0568301416b029044e2d8e855eso9274161otp.8
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=paxY+fK5EQubdG5RnsC1ZjKOzBaYyvh9aKCTbSxMuIg=;
        b=k9buZCcFK0A+YKxBKhQDRwPnvJ6wigsxT9C6bDyDXq8dj2ynEUKWmKZFsOsnuA18HC
         rYtI+2h+b9ji7c8K5vFsn9QrHGveinDiGlw9eb0j4iN7qx8bALUWTTxIxQ1rHoDFZ4uO
         aAKW0fK9+VH3MzQtTPWra2jMjzTu1BqwU60/khH00QVSvbionUl1Xl/Ez9IPysCHWFa2
         z+7HAdoi/U4x1jiCsR2cBXpAnNqJI+kGww19eWWa6UlY02Vhvu3ht1dE6TpsJuyaom20
         bSn6Zd5WBhn8AFmhK43lJ+HKOpUnqEkZAj/pzO/7JD2m3CpX0cJWEWMP9a9s9yBsk/AX
         kG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=paxY+fK5EQubdG5RnsC1ZjKOzBaYyvh9aKCTbSxMuIg=;
        b=iLwycKFbWLCYBV5Q3O+kUhstRemutT8NE1nAygymuYwapMVvdnh5QwlKgoxqv1UBQm
         rINnAaoYuWRghiMnVtLoAkuP8lpiyq3SqwkklWZ7nsaW6PbgCqc709H6JQZWTmIkaZ6z
         zaDvqhte5FX3aZ5pzz7vBpK/adMXNbBTHszwyx0UY7/CJeeAFnAwsJt8j07SSB3iqzFh
         TmLHgxAlINXnwlPbPzsoG2Dj7LMv+HtZcd38a6rkqqTtgDaANpSt8Czb0hwFPvBVsF1z
         lmTqetghjK3dBvpkLVP1u+YTaOXjDijKxgdEEbEAR4F2yo3lhLlQ9DvS+TZJQburSYbw
         5DLQ==
X-Gm-Message-State: AOAM532yvFiZSqsIXWqc7wbIj2rTt/y3Ar4p00IGyI2FfCbQzN819f4v
        JraJa7onFSLjuP6S9Zw0tc5GXOziTVg20FYJ+aSqCg==
X-Google-Smtp-Source: ABdhPJxGojkpA2l7BCxHo9kpNZ9FXYKuDj+k3zc4HUOf31x6t7qgIV3GxRTh6g4MFvdh7h/NMtkZe6pExwiORl8Q9Jc=
X-Received: by 2002:a05:6830:1e99:: with SMTP id n25mr21556467otr.279.1624296114776;
 Mon, 21 Jun 2021 10:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com> <20210618093529.bxsv4qnryccivdsd@steredhat.lan>
In-Reply-To: <20210618093529.bxsv4qnryccivdsd@steredhat.lan>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 21 Jun 2021 10:21:44 -0700
Message-ID: <CAP_N_Z-LmZYUMY+TyB2E9E00AisnZXcFyD_SM8SeZLB0G2u1ig@mail.gmail.com>
Subject: Re: [External] Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 2:35 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Wed, Jun 09, 2021 at 11:24:52PM +0000, Jiang Wang wrote:
> >This patchset implements support of SOCK_DGRAM for virtio
> >transport.
> >
> >Datagram sockets are connectionless and unreliable. To avoid unfair cont=
ention
> >with stream and other sockets, add two more virtqueues and
> >a new feature bit to indicate if those two new queues exist or not.
> >
> >Dgram does not use the existing credit update mechanism for
> >stream sockets. When sending from the guest/driver, sending packets
> >synchronously, so the sender will get an error when the virtqueue is ful=
l.
> >When sending from the host/device, send packets asynchronously
> >because the descriptor memory belongs to the corresponding QEMU
> >process.
> >
> >The virtio spec patch is here:
> >https://www.spinics.net/lists/linux-virtualization/msg50027.html
> >
> >For those who prefer git repo, here is the link for the linux kernel=EF=
=BC=9A
> >https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
> >
> >qemu patch link:
> >https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
> >
> >
> >To do:
> >1. use skb when receiving packets
> >2. support multiple transport
> >3. support mergeable rx buffer
>
> Jiang, I'll do a fast review, but I think is better to rebase on
> net-next since SEQPACKET support is now merged.
>
> Please also run ./scripts/checkpatch.pl, there are a lot of issues.
>
> I'll leave some simple comments in the patches, but I prefer to do a
> deep review after the rebase and the dynamic handling of DGRAM.

Hi Stefano,

Sure. I will rebase and add dynamic handling of DGRAM. I run checkpatch.pl
at some point but I will make sure to run it again before submitting. Thank=
s.

Regards,

Jiang


> Thanks,
> Stefano
>
