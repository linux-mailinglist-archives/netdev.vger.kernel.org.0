Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA635E162
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhDMO2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhDMO2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:28:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85DC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:27:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id mh2so4696299ejb.8
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xyev31+WcNN02Wrv0KFEbnCXwG8/Z0iBfRYSMrxwfZs=;
        b=NL3dNcPgyuxWknocdzGBe7ZQtcdfnP1EudVrACIWJGBWtdqzTYGK2eTwksx9JbNcdF
         i/VLZZlHdHuiddQ/SLhZHZTCuWK3uq7/1Ip59/EGQN6k5wChlcIeTPwpiNSheE27vrTV
         ovbpfdRUGOwctkXGpwJP+8flGeGko6u8aeNcUIg/CP+XEIXtrQbywo9QyRwOmc6JOxYL
         uypwKi6l7mI2lTW0o+IqVKSLHYyQ/GAS7V4CbZKKZB7QWWcO8YikpW4Huj29NR0zt1OP
         YHTOlcEoFHg1GfhqXYaPMQWyiugzTmtSxcVEHU2Eo6uwN5VsEBHPBMrFu9WlQ8lGSr6G
         F8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xyev31+WcNN02Wrv0KFEbnCXwG8/Z0iBfRYSMrxwfZs=;
        b=My5tXux0esN+DLhycKEOvfHildIa8XMY1jAGgUaykwTi3wUjAIJ0RtRwb6Wiz6Plsd
         WVx8bVMkXoXAPHAKVeaQEeCGm7Kmp1t8by9CN/xBlOr4kqjFVOidB+lZekPhRyRO53a6
         OsvdTFSvTwHYDGaKFY3NlnnVFPtLS/NX5/8PWBb56JXALQYTHoSBCQ+272/teJZYhV1k
         81vSivlJw8hDqmipE6zwOPCzU0RHhjnCaulD+zJNCKJaR2rkMRHPBFnlqIfwWH+tnp4L
         8hI6GqVai4vanGQedv0M3j5PbYduZiZkF2DJWZxMS69aSLDuwqTtnoHBBFTVD0hgBPX+
         H5kA==
X-Gm-Message-State: AOAM532f1DWs2qPPYtA0omOSx+7rQWk8dICKwR2SF7AgZSQUkzdPwyuf
        hDFb235BlZTmFFin0JoV/j6hdRnURqYn/A==
X-Google-Smtp-Source: ABdhPJw9zOq86ya1aL7e5bcs2UlENsdQ1edKBA7jDnOZPjTveZ4yHoL9mIlBnE8RMsTvfjBPUXs9hA==
X-Received: by 2002:a17:906:eb49:: with SMTP id mc9mr23082966ejb.67.1618324077404;
        Tue, 13 Apr 2021 07:27:57 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id s5sm4927408ejq.52.2021.04.13.07.27.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:27:56 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id w4so12943980wrt.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:27:55 -0700 (PDT)
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr37881708wrj.50.1618324075500;
 Tue, 13 Apr 2021 07:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20170424174930.82623-1-willemdebruijn.kernel@gmail.com>
 <20170424174930.82623-6-willemdebruijn.kernel@gmail.com> <20210413010354-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210413010354-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 10:27:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe_iy=vDze=MSca1iRJX+WR=PjG-HoFZ2GBpFaCxE33Fg@mail.gmail.com>
Message-ID: <CA+FuTSe_iy=vDze=MSca1iRJX+WR=PjG-HoFZ2GBpFaCxE33Fg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/5] virtio-net: keep tx interrupts disabled
 unless kick
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 1:06 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Apr 24, 2017 at 01:49:30PM -0400, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Tx napi mode increases the rate of transmit interrupts. Suppress some
> > by masking interrupts while more packets are expected. The interrupts
> > will be reenabled before the last packet is sent.
> >
> > This optimization reduces the througput drop with tx napi for
> > unidirectional flows such as UDP_STREAM that do not benefit from
> > cleaning tx completions in the the receive napi handler.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  drivers/net/virtio_net.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 9dd978f34c1f..003143835766 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1200,6 +1200,9 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >       /* Free up any pending old buffers before queueing new ones. */
> >       free_old_xmit_skbs(sq);
> >
> > +     if (use_napi && kick)
> > +             virtqueue_enable_cb_delayed(sq->vq);
> > +
> >       /* timestamp packet in software */
> >       skb_tx_timestamp(skb);
>
>
> I have been poking at this code today and I noticed that is
> actually does enable cb where the commit log says masking interrupts.
> I think the reason is that with even index previously disable cb
> actually did nothing while virtqueue_enable_cb_delayed pushed
> the event index out some more.
> And this likely explains why it does not work well for packed,
> where virtqueue_enable_cb_delayed is same as virtqueue_enable_cb.
>
> Right? Or did I miss something?

This was definitely based on the split queue with event index handling.

When you say does not work well for packed, you mean that with packed
mode we see the consequences of the race condition when accessing vq
without holding __netif_tx_lock, in a way that I did not notice with
split queue with event index, right?

Thanks for looking into this and proposing fixes for this issue and the
known other spurious tx interrupt issue.
