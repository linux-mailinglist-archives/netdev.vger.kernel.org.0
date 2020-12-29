Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E477D2E6CFF
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 02:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgL2BYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 20:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgL2BYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 20:24:48 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D11BC0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:24:08 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id q10so6363807vsr.13
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2a5OK9SG8uiwL6oCqh8QCSJ6wAjCRpa+IqBksvjIEo=;
        b=qPdGtihtFbUnrVsjgdK4pEYgia8WaQCs6UHV+fLsBle8vJ5EI//QBVzUdOo26CMtmA
         JwwbTGzRLfWsZEcr1R7oILmbaiWNla0C7l2VfEWaO4AJqteBDQ1wXTNWaKGFrTB5QVBP
         +R8vtTxhtjE6oegOFX70W5Ue7zMbFoDkaZhy7+60uXY32qIzo7fTy5E9uREWlNfhrNte
         wpGbAhJUBoF3Y+GLLA+oQeQ4nrh9RfFHENej3Q+T5mQ0BrNpyL+kbDFMS5BvF4Q5UWmi
         ssL3Fyzu4uhuMvbpZ3/5bej95gQbd89PzzRKMds4GukuESbJFsSlgXQtRx39zODUSgB+
         qbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B2a5OK9SG8uiwL6oCqh8QCSJ6wAjCRpa+IqBksvjIEo=;
        b=Oct9g7vUYVQWK/PoPAOhK+48E233SMz/AnIt9t5mW3EtzR8s7Xi/14ixst+oDlELIw
         cw/WsQe53GqsdiS0Z8T/foS2n6bjLC7r3ldG66mDoc288CqhTuRsioau8bovjenAERQs
         OZOUuDK5AcflTzAUjAOrOTnDd8EyQBfI6qa/VIBNghzl6VlROEKJ6OHppD323JnoOnqk
         gviEVKi7ZwqaPRItc/zRPYRNQuK6OyF82aWHpcVGbRfKPBcxWP5ly+giH8vxp5TxwQDV
         G4v6PoggpkhzOKQTcUJXxsTHLVqpoMWA08HkZwcgd17+BFc/yvMsFJ9QZBpxQQUTQjBq
         YDww==
X-Gm-Message-State: AOAM530VcvapkWPwyoR+igOH+QaCNQWrk+Rwdpug5FNIK8/1WK8DlUqc
        tBjs9kNQG80v0mVJWW+jTsORnw8MjcI=
X-Google-Smtp-Source: ABdhPJz1c7/Bax6l1QDnMF3+Xa6BSzWWWz/mXBqvb4tQRRy19dtoD87Y0Hlk5cJOawMVvZIjAmfJ/w==
X-Received: by 2002:a67:ef43:: with SMTP id k3mr29566790vsr.44.1609205046831;
        Mon, 28 Dec 2020 17:24:06 -0800 (PST)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id s128sm5571333vkg.25.2020.12.28.17.24.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 17:24:06 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id a31so1461681uae.11
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:24:06 -0800 (PST)
X-Received: by 2002:ab0:59af:: with SMTP id g44mr31119147uad.37.1609205045560;
 Mon, 28 Dec 2020 17:24:05 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-2-willemdebruijn.kernel@gmail.com> <20201228163359-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228163359-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 20:23:29 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeoZBQdeT9h0WxzX_wtn0DXYiH7A_EAKXyVpDtMhjW+KQ@mail.gmail.com>
Message-ID: <CA+FuTSeoZBQdeT9h0WxzX_wtn0DXYiH7A_EAKXyVpDtMhjW+KQ@mail.gmail.com>
Subject: Re: [PATCH rfc 1/3] virtio-net: support transmit hash report
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 4:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:31AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Virtio-net supports sharing the flow hash from host to guest on rx.
> > Do the same on transmit, to allow the host to infer connection state
> > for more robust routing and telemetry.
> >
> > Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
> > and updates these fields on error with sk_rethink_txhash. This feature
> > allows the host to make similar decisions.
> >
> > Besides the raw hash, optionally also convey connection state for
> > this hash. Specifically, the hash rotates on transmit timeout. To
> > avoid having to keep a stateful table in the host to detect flow
> > changes, explicitly notify when a hash changed due to timeout.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > index 3f55a4215f11..f6881b5b77ee 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >                                        * Steering */
> >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> >
> > +#define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> >  #define VIRTIO_NET_F_RSC_EXT   61    /* extended coalescing info */
> > @@ -170,8 +171,15 @@ struct virtio_net_hdr_v1_hash {
> >  #define VIRTIO_NET_HASH_REPORT_IPv6_EX         7
> >  #define VIRTIO_NET_HASH_REPORT_TCPv6_EX        8
> >  #define VIRTIO_NET_HASH_REPORT_UDPv6_EX        9
> > +#define VIRTIO_NET_HASH_REPORT_L4              10
> > +#define VIRTIO_NET_HASH_REPORT_OTHER           11
>
> Need to specify these I guess ...
> Can't there be any consistency with RX hash?
> Handy for VM2VM ...

Agreed. Unfortunately the skb hash does only distinguishes between L4
and not. And for many purposes that is sufficient.

Implementing the existing flags would require flow dissection, at cpu cost.

I did add the flags to the same field, so that the less specific .._L4
and .._OTHER are valid rx-hash values as well.
