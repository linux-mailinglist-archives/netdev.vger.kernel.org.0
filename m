Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47F33080EA
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhA1WGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhA1WGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:06:41 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837BEC061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:06:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j13so8426812edp.2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CR+t+L4XsXtO6JZcerEf8r5reCBYrDZonmntLNVy5lY=;
        b=nWHwxR/eC49K5KFfHRK/4XSl54gIWVcYI8ygiFlxxg2B1nIC5/oR3FCvFNqOxtAXck
         gVKokDn61BJ0xus4flUJAdqRU+Y2F25yMtmVk+daFRcFpCmyYYe0efwYtgjbJd8BpAH7
         WRyGYscQF48fBXMN/IYJdfNSVkEGmFjbutHr/nTmxyZJInd2z3+TsBb6MueLVNswaJDS
         wPshgbzAuuM2YJlv33WDo0lq7wbcw9D1EMr9pmBBv4d1cjaFVDcWNSac6mD5VOyUF6Jd
         d30PNdOSsnqqwdwM/B1EgWXULfA26Uzo57pZL4hdrYIx+sUV6L6wLx9HehXXCRGPvhAC
         IqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CR+t+L4XsXtO6JZcerEf8r5reCBYrDZonmntLNVy5lY=;
        b=IK83pEK7woi2yJlx0dISxTEbXmLhdaONhQtWhD1k8l2AOSwqjfWL2cu6KxC5tZ9nQN
         iaDgrqtC6lBqOwCzhEiOshPrTXr/GH53QpXfPvTg6knV+HbTVqfkguGcab2GaB9PsrDW
         tFH7sVolqPBME2bzJj4YeZb8XGIFFTb0mxxAwRLIrJtKcLJQAFatdP99BV49UKhu4dmC
         xv4T/hiaJMmKRVeS9neQuVFF1SbltYVXhKnCMvwUHaMDuIPNmOWLJ4q1K+XhnczkRmod
         tqwYA/Ly/Qp/cyCdrr8KCPEkzN5cbkQgFdUsjHIC8D6o4tOuKIjkzBZFxgN0y+79bCx6
         8H6A==
X-Gm-Message-State: AOAM531yYgIJaEp6iyZY6/KA1DN7hq79NKxSTNaahNDMdMv7RAGBg0Ui
        cI3vfbv9BKHfrDk7/2w5sAUvk/KCN40REKRL/BA=
X-Google-Smtp-Source: ABdhPJx7vZVEWUzD2uKry9zEZcxGYvWBEzGjvo9nQQEqc2nohtmGFF0DietxYGX3dPHjNfTIRin+yQQG+SL+kcQo90U=
X-Received: by 2002:a05:6402:318e:: with SMTP id di14mr1886203edb.223.1611871560254;
 Thu, 28 Jan 2021 14:06:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611825446.git.lucien.xin@gmail.com> <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
 <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com>
 <CAKgT0Uchuef=e2w5grNitLM1NzsV--6QGnwvKuffMPisVAR0UA@mail.gmail.com>
 <CAF=yD-LdPESYBjWW0tTccduB1NA_2wSPjXRTUHCRqsVyAxYyRQ@mail.gmail.com> <CAKgT0Uf_-kCDNefVJ4ODpemD=BqyKGXEqdUBt7jS_iMZun80Ug@mail.gmail.com>
In-Reply-To: <CAKgT0Uf_-kCDNefVJ4ODpemD=BqyKGXEqdUBt7jS_iMZun80Ug@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 17:05:24 -0500
Message-ID: <CAF=yD-LOLF05-+gkKzcXyJiLr6wHieZ5pp-Qw4jbB=2C4cXkGw@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 4:42 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 12:00 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 2:46 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Thu, Jan 28, 2021 at 6:07 AM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Thu, Jan 28, 2021 at 4:29 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> > > > > while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> > > > > for HW, which includes not only for TCP/UDP csum, but also for other
> > > > > protocols' csum like GRE's.
> > > > >
> > > > > However, in skb_csum_hwoffload_help() it only checks features against
> > > > > NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> > > > > packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> > > > > NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> > > > > to do csum.
> > > > >
> > > > > This patch is to support ip generic csum processing by checking
> > > > > NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> > > > > NETIF_F_IPV6_CSUM) only for TCP and UDP.
> > > > >
> > > > > Note that we're using skb->csum_offset to check if it's a TCP/UDP
> > > > > proctol, this might be fragile. However, as Alex said, for now we
> > > > > only have a few L4 protocols that are requesting Tx csum offload,
> > > > > we'd better fix this until a new protocol comes with a same csum
> > > > > offset.
> > > > >
> > > > > v1->v2:
> > > > >   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
> > > > >     if it's an UDP/TCP csum packet.
> > > > > v2->v3:
> > > > >   - add a note in the changelog, as Willem suggested.
> > > > >
> > > > > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > ---
> > > > >  net/core/dev.c | 13 ++++++++++++-
> > > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index 6df3f1b..aae116d 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
> > > > >                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > > > >                         skb_crc32c_csum_help(skb);
> > > > >
> > > > > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > > > > +       if (features & NETIF_F_HW_CSUM)
> > > > > +               return 0;
> > > > > +
> > > > > +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
> > > >
> > > > Should this check the specific feature flag against skb->protocol? I
> > > > don't know if there are actually instances that only support one of
> > > > the two flags.
> > >
> > > The issue is at a certain point we start excluding devices that were
> > > previously working.
> > >
> > > All this patch is really doing is using the checksum offset to
> > > identify the cases that were previously UDP or TCP offloads and
> > > letting those through with the legacy path, while any offsets that are
> > > not those two, such as the GRE checksum will now have to be explicitly
> > > caught by the NETIF_F_HW_CSUM case and not accepted by the other
> > > cases.
> >
> > I understand. But letting through an IPv6 packet to a nic that
> > advertises NETIF_F_IP_CSUM, but not NETIF_F_IPV6_CSUM, is still
> > incorrect, right?
>
> That all depends. The problem is if we are going to look at protocol
> we essentially have to work our way through a number of fields and
> sort out if there are tunnels or not and if so what the protocol for
> the inner headers are and if that is supported. It might make more
> sense in that case to look at incorporating a v4/v6 specific check
> into netif_skb_features so we could mask off the bit there.
>
> The question i would have is how has this code been working up until
> now without that check? If we are broken outright and need to add it
> then maybe this should be deemed more of a fix and pushed for net with
> the added protocol bit masking added.

Fair enough. I agree that this patch does not make anything worse, as
it actually tightens the rules.
