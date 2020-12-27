Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A592E31CE
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 17:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgL0QP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 11:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgL0QP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 11:15:56 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35833C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 08:15:16 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id j59so2653242uad.5
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 08:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugCtwc9jOsjvCYwPqmUtpkMD0fT1gDohpp6pZ42Mgkc=;
        b=DxZFHYJxRaC3jfLqloT4l/55ndD2c1UNNfOoLVeex/3ztD/ITXxR1bs8Ptkqu9ulw/
         t1EZ0IbUj8yxhZEuS3VDTu5l5axtkWnTY3Dqdbhc5Wa/ufbT27oMyM1mYCTa0PIIzfkp
         v1GEo6oIO0CBhg0Mpea4A1/viMJfmhFp5n/KhLZ9P4+ZYziNiv2VKDvP2iJFeXR+BB/o
         /JdSsAXg9nO8dDTxWm+qErgEbh5QQI/tjzRdwU/YdvojO4e89iwLq+Mwcw3IIEO03z3S
         R9DdWnO65IzyXM9Lv9yn9P5nDUON4YzyXPe+JwjAgJVkxYSeDRZQCDhKdUdY3RIpzR47
         I0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugCtwc9jOsjvCYwPqmUtpkMD0fT1gDohpp6pZ42Mgkc=;
        b=tOyeL8+z1nzcdvcTTuDDm8pSidiChA1MBjJNzNyAVZ+pne/1Y1usF1wxhMWChL+fkF
         QQNlSX6DeENZhTtiX0DGTjiyusVUWWUrNoFXyRJOW8nGyU4IldTG/o1+CPs80wz65j5R
         spb+LxPYAQZ7uytMzdpZUISaMozDaktV5uHxbHwlCjF47xIK+nf77C9uUZGVLFJNUXMf
         8j70GdyBjemuc4lru8XFckeFCOELMa8dlBaYNyYGbcmYS22FcMpa6ETAiVagjQDEGnJi
         LPjNJDX+sxjAn7IJO6aGA3Gvfnx3z5z7X3kdt0ocOgU0e8kmj+GRI7Uc1wRY/QTeaFjR
         lqMw==
X-Gm-Message-State: AOAM5339A6EhVbxb4mO1O9j6iKXaQQYoZ4B0i9hJpUrg5N4W6TN06R/k
        EFVrAIg2j+VzvIjMG0BJrPeuGek2u/Q=
X-Google-Smtp-Source: ABdhPJw/uatVpbcQwvmaRUWb3BeSv/DMCztxnvNaQ8JTW/rIHIlR4UZPhM/Rxjl3rcBzUXjXdlDL0Q==
X-Received: by 2002:ab0:3004:: with SMTP id f4mr27606441ual.105.1609085714303;
        Sun, 27 Dec 2020 08:15:14 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id f11sm2733884vsh.25.2020.12.27.08.15.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Dec 2020 08:15:13 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id f29so2665610uab.0
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 08:15:13 -0800 (PST)
X-Received: by 2002:ab0:2:: with SMTP id 2mr15371239uai.108.1609085712576;
 Sun, 27 Dec 2020 08:15:12 -0800 (PST)
MIME-Version: 1.0
References: <1608881065-7572-1-git-send-email-wangyunjian@huawei.com> <20201227062220-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201227062220-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 27 Dec 2020 11:14:35 -0500
X-Gmail-Original-Message-ID: <CA+FuTScnt=jVt2+sagtYUXxTrc7RieKc=YyCdp+0zuS9jCiNuA@mail.gmail.com>
Message-ID: <CA+FuTScnt=jVt2+sagtYUXxTrc7RieKc=YyCdp+0zuS9jCiNuA@mail.gmail.com>
Subject: Re: [PATCH net v5 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 27, 2020 at 6:26 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Dec 25, 2020 at 03:24:25PM +0800, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently the vhost_zerocopy_callback() maybe be called to decrease
> > the refcount when sendmsg fails in tun. The error handling in vhost
> > handle_tx_zerocopy() will try to decrease the same refcount again.
> > This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> > when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
> >
> > Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
>
> Are you sure about this tag? the patch in question only affects
> tun, while the fix only affects vhost.

That was my suggestion. But you're right. Perhaps better:

Fixes: bab632d69ee4 ("vhost: vhost TX zero-copy support")

That introduces the actual block that releases the buffer on error:

"
                err = sock->ops->sendmsg(NULL, sock, &msg, len);
                if (unlikely(err < 0)) {
+                       if (zcopy) {
+                               if (ubufs)
+                                       vhost_ubuf_put(ubufs);
+                               vq->upend_idx = ((unsigned)vq->upend_idx - 1) %
+                                       UIO_MAXIOV;
+                       }
"
