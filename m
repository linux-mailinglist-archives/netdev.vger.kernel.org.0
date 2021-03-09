Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED380332807
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCIOEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCIODk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:03:40 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22703C06175F
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 06:03:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so27968789ejc.1
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ft5rd560a0W9wxTzYwRNovTAUDlXaQrOqyKdLfMHLs=;
        b=gUJlyg/5pLeWaXd2N9NNQZ8NbrIXx8As9ZuRUg03D0jpMX1dggNIiX81+CrM0dvfqV
         bETGkoHFu0y2s4uJr/WA/HDXUhVapWWNEIUrv71y8RnvHYt/ICGyDwlTeZ1CIIo6oOgf
         fbGwCWvn2RGvBtFKMRJIOga4IzaEWmx3GYa/VrBQCV2+EJdRrFPVU3FBHgAjZOOXMxNp
         P28+xHRk2mbnUGGro5CC4U5AvAjRz9sjseiZxvMA9cTsjnULKebfvYlAS6ChIaFPqTNC
         FVqUFtOIUUJoMrVQreOP7k5rAgliJ737LyGM/ozq6GVnx1qF9hBMlNDuw7ikpxEGbayK
         vT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ft5rd560a0W9wxTzYwRNovTAUDlXaQrOqyKdLfMHLs=;
        b=FLNCyGFZlrcuWWlK4+39XNHhnoPjY+D0VO+T6G3dm7nyPDHqHUcFULb8cEQ5Rr6d41
         Ib+8mP0+JWWe/N+dRA3TBI9Fj+i/lHlxAOdFtKdt1wclPde3Lf2rXCpQn+Vssnk8NUWL
         B+GuBk+UakBSHSZW+sgmMvZnCph13UFU5CJyGZzcBW0tYPGyLPQkWRhezRqRn6e+pPkQ
         NQWW+Z+vdKuz/y364kcW1SD5EdBAWb9sgcnihEwc3fW+1S5OCpPfpu7O43YPIF01neq7
         HVId58AxUXD014btBHNtLFhNWZhxf9hxQO594AwAvP7mxlM4um6Ytlkgl5g+EAWzazSy
         lPzA==
X-Gm-Message-State: AOAM532UfuHnQsZBp3r8Jz3mXW4hawxIsEb1viyr9Z7+vMFKFCQvMAv/
        wJ8XzaJ6ByJFFpgR6wNx2Rd963bGKt8=
X-Google-Smtp-Source: ABdhPJx8iX++aKb8gfncSiI4yvi91a5v3qMPzQmHnnQLAvxMPlMobotyNl32ZsTySOJssrtMydS4mA==
X-Received: by 2002:a17:906:9be1:: with SMTP id de33mr21570806ejc.320.1615298613771;
        Tue, 09 Mar 2021 06:03:33 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id t6sm8773999edq.48.2021.03.09.06.03.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 06:03:32 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so726889wmq.1
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:03:32 -0800 (PST)
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr4202330wmg.87.1615298612543;
 Tue, 09 Mar 2021 06:03:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615199056.git.bnemeth@redhat.com> <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
 <20210309062116-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210309062116-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Mar 2021 09:02:52 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdXP-nOMWjw0hML3eOhFpApZLZhgENub7fLAUn3DMHmBg@mail.gmail.com>
Message-ID: <CA+FuTSdXP-nOMWjw0hML3eOhFpApZLZhgENub7fLAUn3DMHmBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Balazs Nemeth <bnemeth@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 6:26 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Mar 08, 2021 at 11:31:25AM +0100, Balazs Nemeth wrote:
> > For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
> > set) based on the type in the virtio net hdr, but the skb could contain
> > anything since it could come from packet_snd through a raw socket. If
> > there is a mismatch between what virtio_net_hdr_set_proto sets and
> > the actual protocol, then the skb could be handled incorrectly later
> > on.
> >
> > An example where this poses an issue is with the subsequent call to
> > skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
> > correctly. A specially crafted packet could fool
> > skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.
> >
> > Avoid blindly trusting the information provided by the virtio net header
> > by checking that the protocol in the packet actually matches the
> > protocol set by virtio_net_hdr_set_proto. Note that since the protocol
> > is only checked if skb->dev implements header_ops->parse_protocol,
> > packets from devices without the implementation are not checked at this
> > stage.
> >
> > Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
> > Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
> > ---
> >  include/linux/virtio_net.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > index e8a924eeea3d..6c478eee0452 100644
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -79,8 +79,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> >               if (gso_type && skb->network_header) {
> >                       struct flow_keys_basic keys;
> >
> > -                     if (!skb->protocol)
> > +                     if (!skb->protocol) {
> > +                             const struct ethhdr *eth = skb_eth_hdr(skb);
> > +                             __be16 etype = dev_parse_header_protocol(skb);
> > +
> >                               virtio_net_hdr_set_proto(skb, hdr);
> > +                             if (etype && etype != skb->protocol)
> > +                                     return -EINVAL;
> > +                     }
>
>
> Well the protocol in the header is an attempt at an optimization to
> remove need to parse the packet ... any data on whether this
> affecs performance?

This adds a branch and reading a cacheline that is inevitably read not
much later. It shouldn't be significant.

And this branch is only taken if skb->protocol is not set. So the cost
can easily be avoided by passing the information.

But you raise a good point, because TUNTAP does set it, but only after
the call to virtio_net_hdr_to_skb.

That should perhaps be inverted (in a separate net-next patch).
