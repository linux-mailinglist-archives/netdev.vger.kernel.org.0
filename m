Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5986035E0F9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbhDMOJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhDMOJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:09:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB70C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:09:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v6so24872651ejo.6
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5CizpbO31FtejMNYjXuvc8L275/b2XFa53SLVJcUKq0=;
        b=d7rHSyX5FYqvYlUwaaFx6Cem28DMQMUp8Wv0FRZ9jb0O8CwlLq01rbCgyEQxp7Gs30
         lKPsSc8nvZeDxcR0U+wzjIqCeG2udUGUvSL4Qh/O0Zwq28I1bh2gdzZFrqe9d3072Qdj
         Q3URSx5mp2RCWFS0xm67XKNz8HjPomZ75ooaa9No/dlBf14Q53mxMbQ8Lhdso/91oPqw
         kM21HVpgFwLl7ZiMlaTP7ouOzx49Imb8zIalR/JaD4KAHedjiAI5P9xQp0um2fX8Yq/E
         9ysXejvNssC6iiF5ReY9A/m0mfi3FvuqBM9W4/QtLkVFMwqcwysapMh1n6YotvsA5udo
         PykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5CizpbO31FtejMNYjXuvc8L275/b2XFa53SLVJcUKq0=;
        b=ukj/Gf0pJAD2pa/pqE9ZVFp0g+TPOD0AdNnFY5xbS2uKaoPaVjG87z49Gnnyhy7YmH
         U9YmEv0UdadMdM7397k5fXZrK0TAa/TS8Xcyk+XsoonORavPV1CxPIen4IDXDnyO2csY
         XALuwtz0UAI98had/5WiebsYqwFeNFCYoySl4fvNvUWKs783ceLF8lJTLCTAb/ISLHdh
         d3R3YZO/WhBdCWPzza4E+kq85SxRBVwOqsoyhBdl6LxH43iH8zALFzEhzsunJUA3GPqs
         bxAxWxBb1PnIpqjnoS1MaO/DFOudn4L01Je8prqhRWN5rR/DTvphVNW7vU0pVMS52Swj
         ZoKA==
X-Gm-Message-State: AOAM5333AkW6+tKWp6rf96VisHg774WvZg0XcoffF80WYq91MQHgjaHj
        /d8G4leIKS2prPJron8KRZ5opOYJcY8tmA==
X-Google-Smtp-Source: ABdhPJz7UbTh+OFfGGeIUGNUtKmPNlF1hISC7eK1IUpbb7BegToAN3MLVYuKRapf0kAsodMzvqgR3w==
X-Received: by 2002:a17:906:c058:: with SMTP id bm24mr32836729ejb.335.1618322953851;
        Tue, 13 Apr 2021 07:09:13 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id nb35sm7907842ejc.6.2021.04.13.07.09.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:09:13 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id h4so7583840wrt.12
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:09:12 -0700 (PDT)
X-Received: by 2002:a5d:510d:: with SMTP id s13mr37397046wrt.12.1618322952421;
 Tue, 13 Apr 2021 07:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210413054733.36363-1-mst@redhat.com> <20210413054733.36363-3-mst@redhat.com>
 <43db5c1e-9908-55bb-6d1a-c6c8d71e2315@redhat.com>
In-Reply-To: <43db5c1e-9908-55bb-6d1a-c6c8d71e2315@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 10:08:34 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdt6udHb7V4Xcj=OQ3M-iRazgOMWJinCbLJyof=ttB=Cw@mail.gmail.com>
Message-ID: <CA+FuTSdt6udHb7V4Xcj=OQ3M-iRazgOMWJinCbLJyof=ttB=Cw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/4] virtio_net: disable cb aggressively
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 4:53 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/13 =E4=B8=8B=E5=8D=881:47, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
> > There are currently two cases where we poll TX vq not in response to a
> > callback: start xmit and rx napi.  We currently do this with callbacks
> > enabled which can cause extra interrupts from the card.  Used not to be
> > a big issue as we run with interrupts disabled but that is no longer th=
e
> > case, and in some cases the rate of spurious interrupts is so high
> > linux detects this and actually kills the interrupt.
> >
> > Fix up by disabling the callbacks before polling the tx vq.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/net/virtio_net.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 82e520d2cb12..16d5abed582c 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1429,6 +1429,7 @@ static void virtnet_poll_cleantx(struct receive_q=
ueue *rq)
> >               return;
> >
> >       if (__netif_tx_trylock(txq)) {
> > +             virtqueue_disable_cb(sq->vq);
> >               free_old_xmit_skbs(sq, true);
> >               __netif_tx_unlock(txq);
>
>
> Any reason that we don't need to enable the cb here?

This is an opportunistic clean outside the normal tx-napi path, so if
disabling the tx interrupt here, it won't be reenabled based on
napi_complete_done.

I think that means that it stays disabled until the following start_xmit:

        if (use_napi && kick)
                virtqueue_enable_cb_delayed(sq->vq);

But that seems sufficient.
