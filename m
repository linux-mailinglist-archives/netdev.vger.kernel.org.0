Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C5635E9F9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 02:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348213AbhDNAZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 20:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbhDNAZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 20:25:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2235EC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 17:25:32 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w3so28734424ejc.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 17:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofSqlHpW6OFplG5zBNJarpd/OG8vwHX3fcGfky7GKO0=;
        b=dxa74v3bbEU8fPB51j4N5OHFA0e4Jood31bfZu3Zyw+E9i26JicVK/KgeU+5fNAg2R
         hSulCM6IKyOz2B4C9YqptpLd7jOX5eMmaIAlICeYa59pPmOuk7INhA4gyDD0NJSvxq+z
         qqqipidRUa3pzJQp+TrJ5mFRD6GkdgzysqvlcDRc3Pn4vLdVH4m7qVAwTzN3mcGc0dfE
         CT43k1TkupQmXY9+uX3i0ovCNDI7or0OG+BqM6b0F9lzL4Py6cwdOcD6/pK8uSEnaI+f
         nSORpiArXm7CR6JxjpHDw/v7FuZkwj8I0Ozaw5P3OoSzsJ2umPB6vuiOrlrkaNmTN9Qd
         DK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofSqlHpW6OFplG5zBNJarpd/OG8vwHX3fcGfky7GKO0=;
        b=DuTQ4CEmuATVwNQkcMHM6SRs9g2HOFCqAGw2NwxyMjivKXxpF9SmJTDtlOAMLr2Awk
         uTcgtssGGhwxE+g7aj4FxGA15XdGyoCCRoo/V/r+tfaKaXzUxBND5bscgqptZTp346lt
         xX43rgsaRHnEX0xnst8aau/nTyxJUEM3LIjx3v+QIKKg4wxICypBNBp3aE++MXP7awAA
         6B9lF9BZkgdtGi3JOdSTuR3i5yTgPMKkQ9HoQ0JWTQyNAWZuk3+ejdVmJXJIuyZZGVw4
         K+mxAUq8yBTmlQ2JGOMt6vjT6iaWa6VsIWA6nRQiv+jh+pyeaobwbB82bTtFWVHSYC4C
         F5zw==
X-Gm-Message-State: AOAM531s9SaOVSmWv/0uNKSjqGk6x+o5VEoGTwA495XWqmf+eNwPfX1N
        xFU6Ksfy3Pi5YAebE3z/yFQi92sJgfgIXA==
X-Google-Smtp-Source: ABdhPJx16RRaz2jI4XHGM8lOcbg3b8MlXzo6O8PUkFQdWubCG3Sd/Z17g0ISZBf6f9nc08uxSd3wyQ==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr34358423eje.30.1618359929878;
        Tue, 13 Apr 2021 17:25:29 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id d1sm8912515eje.26.2021.04.13.17.25.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 17:25:28 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso9614279wmq.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 17:25:28 -0700 (PDT)
X-Received: by 2002:a7b:cb05:: with SMTP id u5mr230396wmj.183.1618359927443;
 Tue, 13 Apr 2021 17:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210413054733.36363-1-mst@redhat.com> <20210413054733.36363-2-mst@redhat.com>
 <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
 <20210413153951-mutt-send-email-mst@kernel.org> <CA+FuTSd7qagJAN0wpvudvi2Rvxn-SvQaBZ1SU9rwdb1x0j1s3g@mail.gmail.com>
 <20210413180830-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210413180830-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 20:24:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTScdzwb1pi=-ms+QNMboJsqOdNddUdqTznbMzRo7PQ3bFg@mail.gmail.com>
Message-ID: <CA+FuTScdzwb1pi=-ms+QNMboJsqOdNddUdqTznbMzRo7PQ3bFg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >
> > >
> > > but even yours is also fixed I think.
> > >
> > > The common point is that a single spurious interrupt is not a problem.
> > > The problem only exists if there are tons of spurious interrupts with no
> > > real ones. For this to trigger, we keep polling the ring and while we do
> > > device keeps firing interrupts. So just disable interrupts while we
> > > poll.
> >
> > But the main change in this patch is to turn some virtqueue_disable_cb
> > calls into no-ops.
>
> Well this was not the design. This is the main change:
>
>
> @@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
>
>         if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
>                 vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> -               if (!vq->event)
> +               if (vq->event)
> +                       /* TODO: this is a hack. Figure out a cleaner value to write. */
> +                       vring_used_event(&vq->split.vring) = 0x0;
> +               else
>                         vq->split.vring.avail->flags =
>                                 cpu_to_virtio16(_vq->vdev,
>                                                 vq->split.avail_flags_shadow);
>
>
> IIUC previously when event index was enabled (vq->event) virtqueue_disable_cb_split
> was a nop. Now it sets index to 0x0 (which is a hack, but good enough
> for testing I think).

So now tx interrupts will really be suppressed even in event-idx mode.

And what is the purpose of suppressing this operation if
event_triggered, i.e., after an interrupt occurred? You mention " if
using event index with a packed ring, and if being called from a
callback, we actually do disable interrupts which is unnecessary." Can
you elaborate? Also, even if unnecessary, does it matter? The
operation itself seems fairly cheap.

These should probably be two separate patches.

There is also a third case, split ring without event index. That
behaves more like packed ring, I suppose.


> > I don't understand how that helps reduce spurious
> > interrupts, as if anything, it keeps interrupts enabled for longer.
