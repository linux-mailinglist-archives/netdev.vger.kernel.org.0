Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F63FF8E8
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345968AbhICCmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345668AbhICCml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 22:42:41 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF19C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 19:41:41 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a25so8986504ejv.6
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 19:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B9QmCXUqb1oN3dmhWjbEgVxV7kyzf0Zyloo3Z4hXWkU=;
        b=fPKFj3MHDdAiqTnf06PtW1kWsb7bsyP//xrStfuV60ag6tiRcXjMV73ie71Q/mEcFK
         nSyxB5Fn9ObYQkR/MEEx/h/OYU1BEZ1lYmCPmGM4PzcNcKmrduRokYndFv9iUJgTMYbs
         pJOwUCZz0OeD8up0qKmmvmX8u9pdA09f3Z777Z81Uii416f873w7hfeD+LNZnAAo1zMh
         27HpDulH/Q83P3YBhNOuWxgl4tT5jlIe9MCp1uW296taeYqi29FSb0sJKd6B99Fp3ae1
         kCpAwQHxomdu1jK/ZbtfHOnhuEPkQh9Bs8yz35xxdbq50H/1dU+LjekBs8wadXtWiWO/
         gYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B9QmCXUqb1oN3dmhWjbEgVxV7kyzf0Zyloo3Z4hXWkU=;
        b=N7FKEeyfNPHi035bju0CI/+5pG9ttoE3hO9TghGIpL9IOSJ/j+TMEDn+epgaCOMemW
         aibCiJkANXX6qyP74Wa4KhcYS+3nhU2+v2heGphACiQTa3ceus3y4ARzHDb9zA29k+nv
         /tvlFzRbUCvPPiNvo4SXN+7Iends2KD5lepdEufG0MJMiglSD0Ol7qNsrtk13GsWpKSq
         h3AcD1GFzh+u6zaQJxz1haxmqqEtM51kk4TJc1aKfRrZ5x7FwfxxTbTCT8LWHgfLFBzm
         1NiPcSrXkjDW6d9IfTkvv00unCjG9AN6Gy7sK4sfNHKg66/cJfYqsPCl4nDF+4/6qr92
         JRgg==
X-Gm-Message-State: AOAM531kjBQiFCixiZSXY6kTuWdIkIKnl2EuGv9sDrKIIatVC1bUWHIf
        eamTWzRr0EEc36xd7/fAvlpgcH87bwCKxQ==
X-Google-Smtp-Source: ABdhPJxJwG1MXPu+TbAYpjA8dJfil8Wlf4qgnXFuqSguCGYXWPHJxPlzzs8eAK+UxjcWij9Va4P+Xg==
X-Received: by 2002:a17:907:8693:: with SMTP id qa19mr1457764ejc.95.1630636899658;
        Thu, 02 Sep 2021 19:41:39 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id ly7sm1947440ejb.109.2021.09.02.19.41.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 19:41:38 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id t15so6015008wrg.7
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 19:41:38 -0700 (PDT)
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr729632wrn.327.1630636897644;
 Thu, 02 Sep 2021 19:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com> <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
In-Reply-To: <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 2 Sep 2021 22:40:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
Message-ID: <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:01 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Sep 2, 2021 at 2:45 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Sep 2, 2021 at 5:17 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Thu, Sep 2, 2021 at 1:30 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Thu, Sep 2, 2021 at 4:25 PM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
> > > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > > >
> > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > >
> > > > > > Only test integrity of csum_start if checksum offload is configured.
> > > > > >
> > > > > > With checksum offload and GRE tunnel checksum, gre_build_header will
> > > > > > cheaply build the GRE checksum using local checksum offload. This
> > > > > > depends on inner packet csum offload, and thus that csum_start points
> > > > > > behind GRE. But validate this condition only with checksum offload.
> > > > > >
> > > > > > Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> > > > > > Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > ---
> > > > > >  net/ipv4/ip_gre.c | 5 ++++-
> > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > > > > > index 177d26d8fb9c..09311992a617 100644
> > > > > > --- a/net/ipv4/ip_gre.c
> > > > > > +++ b/net/ipv4/ip_gre.c
> > > > > > @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
> > > > > >
> > > > > >  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
> > > > > >  {
> > > > > > -       if (csum && skb_checksum_start(skb) < skb->data)
> > > > > > +       /* Local checksum offload requires csum offload of the inner packet */
> > > > > > +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> > > > > > +           skb_checksum_start(skb) < skb->data)
> > > > > >                 return -EINVAL;
> > > > > > +
> > > > > >         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
> > > > > >  }
> > > >
> > > > Thanks for taking a look.
> > > >
> > > > > So a few minor nits.
> > > > >
> > > > > First I think we need this for both v4 and v6 since it looks like this
> > > > > code is reproduced for net/ipv6/ip6_gre.c.
> > > >
> > > > I sent a separate patch for v6. Perhaps should have made it a series
> > > > to make this more clear.
> > >
> > > Yeah, that was part of the reason I assumed the ipv6 patch was overlooked.
> >
> > I was in two minds only because a series should come with a cover
> > letter and thus one extra email added to the firehose. But this makes
> > clear the value. Will just do that in the future.
> >
> > > > > Second I don't know if we even need to bother including the "csum"
> > > > > portion of the lookup since that technically is just telling us if the
> > > > > GRE tunnel is requesting a checksum or not and I am not sure that
> > > > > applies to the fact that the inner L4 header is going to be what is
> > > > > requesting the checksum offload most likely.
> > > >
> > > > This test introduced in the original patch specifically protects the
> > > > GRE tunnel checksum calculation using lco_csum. The regular inner
> > > > packet path likely is already robust (as similar bug reports would be
> > > > more likely for that more common case).
> > >
> > > I was just thinking in terms of shaving off some extra comparisons. I
> > > suppose it depends on if this is being inlined or not. If it is being
> > > inlined there are at least 2 cases where the if statement would be
> > > dropped since csum is explicitly false. My thought was that by just
> > > jumping straight to the skb->ip_summed check we can drop the lookup
> > > for csum since it would be implied by the fact that skb->ip_summed is
> > > being checked. It would create a broader check, but at the same time
> > > it would reduce the number of comparisons in the call.
> >
> > Most GRE tunnels don't have checksums and csum is likely in a register,
> > as function argument, so it likely is the cheaper test?
> >
> > More functional argument: if !csum, the GRE tunnel does not care about
> > the integrity of csum_start. So I think that it should not read it at all.
>
> The problem as I see it is that it is just passing the problem on.
> Adding the check to the GRE drivers only really fixes one spot that
> exposes the issue. In this case it was triggered because the lco_csum
> was causing issues. What happens when one of these packets makes it
> down to hardware and it has to deal with the malformed csum_start? I
> suspect we end up potentially causing issues where Tx metadata could
> be malformed resulting in a dropped packet at the best case, and
> kernel panics at the worst.
>
> > > > > Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
> > > > > the path triggering this should be fixed rather than us silently
> > > > > dropping frames. We should be figuring out what cases are resulting in
> > > > > us getting CHECKSUM_PARTIAL without skb_checksum_start being set.
> > > >
> > > > We already know that bad packets can enter the kernel and trigger
> > > > this, using packet sockets and virtio_net_hdr. Unfortunately, this
> > > > *is* the fix.
> > >
> > > It sounds almost like we need a CHECKSUM_DODGY to go along with the
> > > SKB_GSO_DODGY in order to resolve these kinds of issues.
> > >
> > > So essentially we have a source that we know can give us bad packets.
> > > We really should be performing some sort of validation on these much
> > > earlier in order to clean them up so that we don't have to add this
> > > sort of exception handling code all over the Tx path.
> >
> > Agreed with the concern. I've been arguing for validation at kernel
> > entry of virtio_net_hdr. As an optional feature, if nothing else:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210616203448.995314-3-tannerlove.kernel@gmail.com/
> >
> > But unless we accept the cost of full parsing to identify the
> > transport headers, we cannot predict at that stage whether the field
> > is bogus, let alone whether it might trigger a bug later on. We do
> > basic validation: csum_start is verified to be within the skb linear,
> > so not totally out of bounds.
> >
> > That the offset is not just bogus, but causes a bug appears to be a
> > rare exception peculiar to the GRE tunnel. Only it pulls the outer
> > header (in ipgre_xmit), applies lco_csum and can so trigger negative
> > overflow, as far as I could tell. That's why we decided to add the
> > limited check local to that code.
> >
> > I'm not sure how we would use CHECKSUM_DODGY in practice.
>
> The issue is drivers with NETIF_F_HW_CSUM would be expecting a
> reasonable csum_start and csum_offset. If the hardware is only
> advertising that and we are expecting it to offload the checksum we
> should probably be doing some sort of validation on user derived
> inputs to make sure that they aren't totally ridiculous as is the case
> here where the original issue was that the csum_start wasn't even in
> the packet data.
>
> Would it maybe make sense to look at reverting the earlier fixes and
> instead updating skb_partial_csum_set so that we cannot write a
> csum_start value that is less than the start of skb->data? That way we
> are addressing this at the source instead of allowing the garbage data
> to propagate further down the stack and having to drop it at the
> driver level which is going to have us playing whack a mole trying to
> fix it where it pops up. It seems like we are already validating the
> upper bounds for these values in that function so why not validate the
> lower bounds as well?

skb_partial_csum_set verifies that csum_start is within bounds
at the time it is called. The offset passed from userspace is
an unsigned int added to skb_headroom(skb), so >= skb->data.

The issue is with ipgre_xmit calling skb_pull. Only then does it
become out of bounds. From what I saw, pulling headers like
that is very rare in the transmit path. Indeed, I did not see it in
any other tunnels. We could instrument each of these directly,
but at non-trivial cost.

The negative underflow and kernel crash is very specific to
lco_csum, which calculates the offset between csum_offset
and transport_offset. Standard checksum offset doesn't.

One alternative fix, then, would be to add a negative overflow
check in lco_csum itself.

That only has three callers and unfortunately by the time we hit
that for GRE in gre_build_header, there no longer is a path to
cleanly dropping the packet and returning an error.

I don't find this bad input whack-a-mole elegant either. But I
thought it was the least bad option..
