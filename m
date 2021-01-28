Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5B3080AB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhA1Vn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhA1Vm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:42:58 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7FC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:42:18 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id 16so7197647ioz.5
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGCQ3khyuxhb1Yeuk4SaOcx+oIrqYYgkWcEDxOFw1JQ=;
        b=Bb+U+vI9mDdkO7tv7PKvECpfTQP3b8rG40q0MYpuH4qNDkfKmo7hpyqfYsquyHNtu7
         u82E95Ay8tRQveiblRMbMzt7EXoFMYzdijRKHat0XXSpamepe3lg8pNqHIJLcl7v6haS
         qdkZd9EnR0iF1eEfAWXEERNPlI+fpeqm5QexUeeS88KHUc9bDSIq0osoNRdieGTIOoiW
         EcxWN5Ny1LV6glU47RSB8MQo0Ma2jOCxZk9py/WklRTMzMWk5TwvxQ3LkVFF9WEI8NFX
         9/knkQ+V3gKrJZjli2aeYARBNtfJCM2r2xMqD9p+seBYFmIvkhXbXzDZVmi7Ef0BP6aQ
         ecoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGCQ3khyuxhb1Yeuk4SaOcx+oIrqYYgkWcEDxOFw1JQ=;
        b=MgSC0f0lNQT8Tf3QxboxGbs1X44ljeW4hSIGj3jJGYwLZiU8Fkg+tUW29zC4Y/Fp/n
         9etMGSjLo0cg5kLbcmmxIpxNSZvqw7Q41cJU7XeL9OpJ3z/i2P0j0DHbpqBHg287A+gL
         oPD++peOaJVKz1IzY3nURmzJCBGWyU+ZR5sAh1dAa5Y/7Jqt09vgw8zYGrx0M2lhNQBT
         RxJNjxnANXzDk7mjnflSBSf726jLuz0aH5DBmYXo3OEiwky1EzLcREsKVAFV5cWMLkPv
         SGrtEKp/QBOT+mP8Ie7ZmKBIER3/AzYI4nDh0J96tyej9sSjViLAXUpDBdh+Ma7MFMmt
         CREg==
X-Gm-Message-State: AOAM531IrOeMPBpHnknf7/J74jBMaCX3gRQLppAMmm4uTz4rDgHATVN5
        sDrb4cU25dPjQ7U5gOqKjkQsr8hs91mln6EeHeY=
X-Google-Smtp-Source: ABdhPJwk/vAuPOctyDT2HOneVroJ3OJUa9kXVLb7nXy4XU8ez5f3RIC8O5lAUDl1KcoIpLWLP3DAAt8FnHQA0Ggu4Go=
X-Received: by 2002:a6b:e716:: with SMTP id b22mr1655638ioh.138.1611870137261;
 Thu, 28 Jan 2021 13:42:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611825446.git.lucien.xin@gmail.com> <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
 <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com>
 <CAKgT0Uchuef=e2w5grNitLM1NzsV--6QGnwvKuffMPisVAR0UA@mail.gmail.com> <CAF=yD-LdPESYBjWW0tTccduB1NA_2wSPjXRTUHCRqsVyAxYyRQ@mail.gmail.com>
In-Reply-To: <CAF=yD-LdPESYBjWW0tTccduB1NA_2wSPjXRTUHCRqsVyAxYyRQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 28 Jan 2021 13:42:06 -0800
Message-ID: <CAKgT0Uf_-kCDNefVJ4ODpemD=BqyKGXEqdUBt7jS_iMZun80Ug@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 12:00 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 2:46 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 6:07 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Thu, Jan 28, 2021 at 4:29 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> > > > while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> > > > for HW, which includes not only for TCP/UDP csum, but also for other
> > > > protocols' csum like GRE's.
> > > >
> > > > However, in skb_csum_hwoffload_help() it only checks features against
> > > > NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> > > > packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> > > > NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> > > > to do csum.
> > > >
> > > > This patch is to support ip generic csum processing by checking
> > > > NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> > > > NETIF_F_IPV6_CSUM) only for TCP and UDP.
> > > >
> > > > Note that we're using skb->csum_offset to check if it's a TCP/UDP
> > > > proctol, this might be fragile. However, as Alex said, for now we
> > > > only have a few L4 protocols that are requesting Tx csum offload,
> > > > we'd better fix this until a new protocol comes with a same csum
> > > > offset.
> > > >
> > > > v1->v2:
> > > >   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
> > > >     if it's an UDP/TCP csum packet.
> > > > v2->v3:
> > > >   - add a note in the changelog, as Willem suggested.
> > > >
> > > > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/core/dev.c | 13 ++++++++++++-
> > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 6df3f1b..aae116d 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
> > > >                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > > >                         skb_crc32c_csum_help(skb);
> > > >
> > > > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > > > +       if (features & NETIF_F_HW_CSUM)
> > > > +               return 0;
> > > > +
> > > > +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
> > >
> > > Should this check the specific feature flag against skb->protocol? I
> > > don't know if there are actually instances that only support one of
> > > the two flags.
> >
> > The issue is at a certain point we start excluding devices that were
> > previously working.
> >
> > All this patch is really doing is using the checksum offset to
> > identify the cases that were previously UDP or TCP offloads and
> > letting those through with the legacy path, while any offsets that are
> > not those two, such as the GRE checksum will now have to be explicitly
> > caught by the NETIF_F_HW_CSUM case and not accepted by the other
> > cases.
>
> I understand. But letting through an IPv6 packet to a nic that
> advertises NETIF_F_IP_CSUM, but not NETIF_F_IPV6_CSUM, is still
> incorrect, right?

That all depends. The problem is if we are going to look at protocol
we essentially have to work our way through a number of fields and
sort out if there are tunnels or not and if so what the protocol for
the inner headers are and if that is supported. It might make more
sense in that case to look at incorporating a v4/v6 specific check
into netif_skb_features so we could mask off the bit there.

The question i would have is how has this code been working up until
now without that check? If we are broken outright and need to add it
then maybe this should be deemed more of a fix and pushed for net with
the added protocol bit masking added.
