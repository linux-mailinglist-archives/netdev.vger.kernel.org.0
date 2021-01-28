Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38878307F1C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhA1UFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhA1UDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:03:07 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D86C0612F2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:00:49 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id rv9so9568962ejb.13
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVYxkIXR5C7fneWNkrQE3GL7vPjbECyzuI9fgtyiYCU=;
        b=itINokjPFMBgQUziE99U7xI39GqFaQemDQYU9jQ+DO4dTfdnvgEhPLLacGMdwbjAXz
         LGXkZNU+2BLq/y+JxpWfp72z+gvPpMbqIYzfT1Zz8PvFp1leubYk6SWXppZOHXWWiCju
         ZCsQjk9k3SXq5pEyWnDxvAOHprx12/nBW7UAyAl9ZkJxBSDmsQ+gUavFjRQGHQifNnVH
         //H3SsnC8GcUYF6m0xz4SEtOlv3TmgBi5SUCMFczOeyyXQwpKE/oigYMecPTWPIvWZvM
         OMSB7C5CLwsXDqVKeCAvFyUh1XCgdCHwa+Hd9hH9HtoMCJegJvXA8dMwaKYxVB6V42x8
         vFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVYxkIXR5C7fneWNkrQE3GL7vPjbECyzuI9fgtyiYCU=;
        b=e7GtnCe49s1JiDn0QcVbPly7mL+8X9N1+Z2quQmyLUftVkG+J09jWsqYQfS6Z7h4Ba
         3EaDW2eL9oct2PFuqXlMIVTqZWnvC86jRB2jmiOgR4DpzOQgFx0nCujbKpu4gSX5K6kO
         /FkFoNgytKvEDwAz0d9lmCavVGyH2eivvwN2L5DmLPKHz0pyyoGTX8czmwrp0Tr/n9Mw
         AKykUAt0zo6NLtxXT17XoYdm28ZqCxqjboE1UbJYuwl2HCMCwxKcVtm+sdRqUxGWgN6l
         ovXhsOq0QgGxBMVO6wKLIF+HJhEM7tjMzVWo5H9c6EVl+EoK1eQx2iXoteUgj7c9x8eV
         mWpw==
X-Gm-Message-State: AOAM5338TP8O/24uxOZRtIIj+aVNs+8G1a8n+jD4ytDRPe22BC9WbhtQ
        EQYRUpT67xHfIfJ6uXqCc/ZqEZHYPWTqhcBi9qE=
X-Google-Smtp-Source: ABdhPJwXN/V1k3dFYVygNF4dGCWU2em9JKlflzeDqwkTXLLUl2WsMntUveOY/HtczP0MkCOC6QQyPoTB5QK+tZoFuSA=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr1103474ejd.119.1611864048005;
 Thu, 28 Jan 2021 12:00:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611825446.git.lucien.xin@gmail.com> <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
 <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com> <CAKgT0Uchuef=e2w5grNitLM1NzsV--6QGnwvKuffMPisVAR0UA@mail.gmail.com>
In-Reply-To: <CAKgT0Uchuef=e2w5grNitLM1NzsV--6QGnwvKuffMPisVAR0UA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 15:00:12 -0500
Message-ID: <CAF=yD-LdPESYBjWW0tTccduB1NA_2wSPjXRTUHCRqsVyAxYyRQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
To:     Alexander Duyck <alexander.duyck@gmail.com>
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

On Thu, Jan 28, 2021 at 2:46 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 6:07 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 4:29 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> > > while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> > > for HW, which includes not only for TCP/UDP csum, but also for other
> > > protocols' csum like GRE's.
> > >
> > > However, in skb_csum_hwoffload_help() it only checks features against
> > > NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> > > packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> > > NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> > > to do csum.
> > >
> > > This patch is to support ip generic csum processing by checking
> > > NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> > > NETIF_F_IPV6_CSUM) only for TCP and UDP.
> > >
> > > Note that we're using skb->csum_offset to check if it's a TCP/UDP
> > > proctol, this might be fragile. However, as Alex said, for now we
> > > only have a few L4 protocols that are requesting Tx csum offload,
> > > we'd better fix this until a new protocol comes with a same csum
> > > offset.
> > >
> > > v1->v2:
> > >   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
> > >     if it's an UDP/TCP csum packet.
> > > v2->v3:
> > >   - add a note in the changelog, as Willem suggested.
> > >
> > > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/core/dev.c | 13 ++++++++++++-
> > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 6df3f1b..aae116d 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
> > >                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > >                         skb_crc32c_csum_help(skb);
> > >
> > > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > > +       if (features & NETIF_F_HW_CSUM)
> > > +               return 0;
> > > +
> > > +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
> >
> > Should this check the specific feature flag against skb->protocol? I
> > don't know if there are actually instances that only support one of
> > the two flags.
>
> The issue is at a certain point we start excluding devices that were
> previously working.
>
> All this patch is really doing is using the checksum offset to
> identify the cases that were previously UDP or TCP offloads and
> letting those through with the legacy path, while any offsets that are
> not those two, such as the GRE checksum will now have to be explicitly
> caught by the NETIF_F_HW_CSUM case and not accepted by the other
> cases.

I understand. But letting through an IPv6 packet to a nic that
advertises NETIF_F_IP_CSUM, but not NETIF_F_IPV6_CSUM, is still
incorrect, right?
