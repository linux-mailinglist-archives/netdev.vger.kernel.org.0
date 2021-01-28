Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618C2307F15
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhA1UC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhA1UAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:00:40 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14315C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 11:46:39 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id p8so6366506ilg.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 11:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gd93U31QoUer1QHIVAwXnhoBfqcFLxJyDDk3L4rHCgo=;
        b=fim+Xw9QvBTK1IRc5cC9uaHGplOG/HGt6Rrggq/dVYuCatknxjEF5W0HWGoauJxUv7
         urJGFn+2kbYBPwT6U0QCiW3VQsXuhMIcMw6mvaV0SI09vR9kldf++BKCNWPiXh5UvjWH
         y86GTg0/1a2g7nJvi6/jAt20D2x8Vwy1FyVQWRvL3GSIeQ0DHaJxD8VlZrTeagzTt+MW
         aHPCn188e8DNUqF1Bc863pDbWQT8O8Fc1NJ7+QmS3OvtkLwfD4Bbcy4WX7Vf0J03a7bE
         IRtUd1avgHxTOLc7z35GwrZHltmA//QWqAKCmb/ZxRrsuffhr6K1Yg1ApszCkakFVH3G
         dmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gd93U31QoUer1QHIVAwXnhoBfqcFLxJyDDk3L4rHCgo=;
        b=eED4vRCfOE1lZXyHBvMgKbrSnWBt9TZpXNcKtuVwyNOruu7KOLyiHtCbSp+bcYacOb
         aPmaeZC/6rsFpKatXYlBKQbHnsCswlXaT/X8ADU/UXuuXPDyMW9YnIPZ7YEPRuhnqrEL
         djBOCsNorLqR3yCTye+cG0Mhac3l5JGA5VCSaqeQvLw1KluD2uX43/PRrUdlbbtYCRAv
         1EFV30Raas5bR3w6/+wxHwt3q0A0NoeBdf7IAxaHZxSo8R5NpttGMRt4r+9FRHv+gfmZ
         wqGkmFj5ssypDtaTf4h0CfT/YPt1Tz06B1xxl9J+ZxrmHlCWlHLgMVshKF5q2zaD/ax7
         1FZQ==
X-Gm-Message-State: AOAM531UM7Fz18/MIxlLJnBaD3+BmCGCSEo0Ch+6Ndx/OxOtcr7KBiP1
        iuPHvuuvvvYOI0MKnXa1m0A11fg9LCmujAxxuo4=
X-Google-Smtp-Source: ABdhPJzJoCJO4HmmpjEQKTeDb8mnApGFZDIpb+pPI2C9xP2oVlKF2s8S4wSTBHAb8K77KfAX9xnmNz9Odex69cJZMSM=
X-Received: by 2002:a05:6e02:c8e:: with SMTP id b14mr542206ile.97.1611863198344;
 Thu, 28 Jan 2021 11:46:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611825446.git.lucien.xin@gmail.com> <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
 <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com>
In-Reply-To: <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 28 Jan 2021 11:46:27 -0800
Message-ID: <CAKgT0Uchuef=e2w5grNitLM1NzsV--6QGnwvKuffMPisVAR0UA@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 6:07 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 4:29 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> > while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> > for HW, which includes not only for TCP/UDP csum, but also for other
> > protocols' csum like GRE's.
> >
> > However, in skb_csum_hwoffload_help() it only checks features against
> > NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> > packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> > NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> > to do csum.
> >
> > This patch is to support ip generic csum processing by checking
> > NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> > NETIF_F_IPV6_CSUM) only for TCP and UDP.
> >
> > Note that we're using skb->csum_offset to check if it's a TCP/UDP
> > proctol, this might be fragile. However, as Alex said, for now we
> > only have a few L4 protocols that are requesting Tx csum offload,
> > we'd better fix this until a new protocol comes with a same csum
> > offset.
> >
> > v1->v2:
> >   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
> >     if it's an UDP/TCP csum packet.
> > v2->v3:
> >   - add a note in the changelog, as Willem suggested.
> >
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/core/dev.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6df3f1b..aae116d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
> >                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> >                         skb_crc32c_csum_help(skb);
> >
> > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > +       if (features & NETIF_F_HW_CSUM)
> > +               return 0;
> > +
> > +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
>
> Should this check the specific feature flag against skb->protocol? I
> don't know if there are actually instances that only support one of
> the two flags.

The issue is at a certain point we start excluding devices that were
previously working.

All this patch is really doing is using the checksum offset to
identify the cases that were previously UDP or TCP offloads and
letting those through with the legacy path, while any offsets that are
not those two, such as the GRE checksum will now have to be explicitly
caught by the NETIF_F_HW_CSUM case and not accepted by the other
cases.
