Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8BB3FF8C4
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhICCCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbhICCCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 22:02:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2D7C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 19:01:35 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i21so8810024ejd.2
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 19:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8IOrCuwVHM8noxGP7HTn7QT1zrp1duBoO6d+gZSU/ag=;
        b=qd1Tm4VYzhqgL1f3Au0zyvhyFrTm/FSndJbf52rZ+D3FR+RsX9Pgxv9T9azukUhOnU
         hH1M4w5e2izWmzaefhQbgC4Qz8s9nOib+t9RoeBlFGk4dM2/Gm08BzaaGX5h96w0qwBM
         5zAlwabdiDhpyLmwnr+Qo+pkpIu7QoXxFLNaGhmGJyw1h7esVa7Pa0u5gLIXwXWXFNtM
         DtKjRyNdsnKkN8eBD+IAB9mffR0lPxgUC8HASCFwNQ/NJrTycP+jJ1uk99OiqOQQadKA
         YwAZM7WSmOyKI2rK4/ZaMpH2EjIAqRPS9xsAYyBhcmehkK0g8m9PX3e5CN7FLHKaRqvS
         iUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8IOrCuwVHM8noxGP7HTn7QT1zrp1duBoO6d+gZSU/ag=;
        b=EcSa9fnvRVSE3GR6AZqOrOaU62t/+Yg1Xo3k+vO4bP6devRPlsk3HqohU+dfsNQAPJ
         59xUJkiT4r7SmvqaRj6PEfg3pM3SK+4iDmqZ33Z4u1rbIkhXcomUUMPalWIJCF5ZKVpt
         S1s3lO29IWfedzh81qEvT8XjgLkTQ5exG9Lm726XkQ/s+ZBh4gqx0SdBEtWyFoDJ2N2Z
         jN4tNiWpciShDCt9oHOEXpdYJ3qLR4ro5Yeq5BamzRGOQAup07C55bGhuiaDI4Y6owK/
         pZ/wB4bAZQ9PTvahw78acRAgtUE4+qm92Ip+9lgT0FWRuM/f/nCz4O1kKTJTcLTyYHA5
         7nGQ==
X-Gm-Message-State: AOAM531Dzzi1xTkw8X0YscA2d4zq70rYWl8YOI5HqIU+6J8uZFFS14Wx
        4Oq5rwEBQkBH+r5iS5lJE3y2A8ofdbjcPD+aPKM=
X-Google-Smtp-Source: ABdhPJxRPgJDpUX4If2KQK2S3lePYFsZ0H25PzIe+yFb6g8MQCg0+nLChRlPoLTgvyLZmklCw5XUYWhIg3GaJE9vakk=
X-Received: by 2002:a17:906:a59:: with SMTP id x25mr1377003ejf.33.1630634493852;
 Thu, 02 Sep 2021 19:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com> <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
In-Reply-To: <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 Sep 2021 19:01:22 -0700
Message-ID: <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 2:45 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Sep 2, 2021 at 5:17 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Sep 2, 2021 at 1:30 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Thu, Sep 2, 2021 at 4:25 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
> > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > >
> > > > > From: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > Only test integrity of csum_start if checksum offload is configured.
> > > > >
> > > > > With checksum offload and GRE tunnel checksum, gre_build_header will
> > > > > cheaply build the GRE checksum using local checksum offload. This
> > > > > depends on inner packet csum offload, and thus that csum_start points
> > > > > behind GRE. But validate this condition only with checksum offload.
> > > > >
> > > > > Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> > > > > Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > ---
> > > > >  net/ipv4/ip_gre.c | 5 ++++-
> > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > > > > index 177d26d8fb9c..09311992a617 100644
> > > > > --- a/net/ipv4/ip_gre.c
> > > > > +++ b/net/ipv4/ip_gre.c
> > > > > @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
> > > > >
> > > > >  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
> > > > >  {
> > > > > -       if (csum && skb_checksum_start(skb) < skb->data)
> > > > > +       /* Local checksum offload requires csum offload of the inner packet */
> > > > > +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> > > > > +           skb_checksum_start(skb) < skb->data)
> > > > >                 return -EINVAL;
> > > > > +
> > > > >         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
> > > > >  }
> > >
> > > Thanks for taking a look.
> > >
> > > > So a few minor nits.
> > > >
> > > > First I think we need this for both v4 and v6 since it looks like this
> > > > code is reproduced for net/ipv6/ip6_gre.c.
> > >
> > > I sent a separate patch for v6. Perhaps should have made it a series
> > > to make this more clear.
> >
> > Yeah, that was part of the reason I assumed the ipv6 patch was overlooked.
>
> I was in two minds only because a series should come with a cover
> letter and thus one extra email added to the firehose. But this makes
> clear the value. Will just do that in the future.
>
> > > > Second I don't know if we even need to bother including the "csum"
> > > > portion of the lookup since that technically is just telling us if the
> > > > GRE tunnel is requesting a checksum or not and I am not sure that
> > > > applies to the fact that the inner L4 header is going to be what is
> > > > requesting the checksum offload most likely.
> > >
> > > This test introduced in the original patch specifically protects the
> > > GRE tunnel checksum calculation using lco_csum. The regular inner
> > > packet path likely is already robust (as similar bug reports would be
> > > more likely for that more common case).
> >
> > I was just thinking in terms of shaving off some extra comparisons. I
> > suppose it depends on if this is being inlined or not. If it is being
> > inlined there are at least 2 cases where the if statement would be
> > dropped since csum is explicitly false. My thought was that by just
> > jumping straight to the skb->ip_summed check we can drop the lookup
> > for csum since it would be implied by the fact that skb->ip_summed is
> > being checked. It would create a broader check, but at the same time
> > it would reduce the number of comparisons in the call.
>
> Most GRE tunnels don't have checksums and csum is likely in a register,
> as function argument, so it likely is the cheaper test?
>
> More functional argument: if !csum, the GRE tunnel does not care about
> the integrity of csum_start. So I think that it should not read it at all.

The problem as I see it is that it is just passing the problem on.
Adding the check to the GRE drivers only really fixes one spot that
exposes the issue. In this case it was triggered because the lco_csum
was causing issues. What happens when one of these packets makes it
down to hardware and it has to deal with the malformed csum_start? I
suspect we end up potentially causing issues where Tx metadata could
be malformed resulting in a dropped packet at the best case, and
kernel panics at the worst.

> > > > Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
> > > > the path triggering this should be fixed rather than us silently
> > > > dropping frames. We should be figuring out what cases are resulting in
> > > > us getting CHECKSUM_PARTIAL without skb_checksum_start being set.
> > >
> > > We already know that bad packets can enter the kernel and trigger
> > > this, using packet sockets and virtio_net_hdr. Unfortunately, this
> > > *is* the fix.
> >
> > It sounds almost like we need a CHECKSUM_DODGY to go along with the
> > SKB_GSO_DODGY in order to resolve these kinds of issues.
> >
> > So essentially we have a source that we know can give us bad packets.
> > We really should be performing some sort of validation on these much
> > earlier in order to clean them up so that we don't have to add this
> > sort of exception handling code all over the Tx path.
>
> Agreed with the concern. I've been arguing for validation at kernel
> entry of virtio_net_hdr. As an optional feature, if nothing else:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210616203448.995314-3-tannerlove.kernel@gmail.com/
>
> But unless we accept the cost of full parsing to identify the
> transport headers, we cannot predict at that stage whether the field
> is bogus, let alone whether it might trigger a bug later on. We do
> basic validation: csum_start is verified to be within the skb linear,
> so not totally out of bounds.
>
> That the offset is not just bogus, but causes a bug appears to be a
> rare exception peculiar to the GRE tunnel. Only it pulls the outer
> header (in ipgre_xmit), applies lco_csum and can so trigger negative
> overflow, as far as I could tell. That's why we decided to add the
> limited check local to that code.
>
> I'm not sure how we would use CHECKSUM_DODGY in practice.

The issue is drivers with NETIF_F_HW_CSUM would be expecting a
reasonable csum_start and csum_offset. If the hardware is only
advertising that and we are expecting it to offload the checksum we
should probably be doing some sort of validation on user derived
inputs to make sure that they aren't totally ridiculous as is the case
here where the original issue was that the csum_start wasn't even in
the packet data.

Would it maybe make sense to look at reverting the earlier fixes and
instead updating skb_partial_csum_set so that we cannot write a
csum_start value that is less than the start of skb->data? That way we
are addressing this at the source instead of allowing the garbage data
to propagate further down the stack and having to drop it at the
driver level which is going to have us playing whack a mole trying to
fix it where it pops up. It seems like we are already validating the
upper bounds for these values in that function so why not validate the
lower bounds as well?
