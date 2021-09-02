Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548883FF5C5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbhIBVqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347494AbhIBVqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:46:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578B2C061760
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 14:45:21 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id me10so7640565ejb.11
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 14:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qh2S7YaIDr62VBei6pZQmoLcvk12QivoXi1z2/5Xbuk=;
        b=ZuvDgjJEjGYd8VdUNBtszY4lAxXj9jkvD0OwVvw3V997rNjePOm8u84HL0nEZeDhrD
         zxIwyryUNCBw2alK6+XRHYeuzTQ8NwgJMpajO0RFEJ65g9wpDxREV58B+S6OJvMY6oOG
         TFeQce0/FQW1jWB0N6T9iznKzEeiBxjELhUPB6v//qkKE2NtMMU+xyBJPe6PP5zBf1Ba
         fDwGiKg5sDdkF3F46p+GEzvoUv5CC8Y2EA05Shs5Anqk0sCQ4pGMm3UNBxFUt8K51tIo
         0R8TVzMP0d860tlXuvVnRYrv2lnrjnauuJ//VuTNzk0DVRelwgEPRiuku48mr2qcNCr1
         8JUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qh2S7YaIDr62VBei6pZQmoLcvk12QivoXi1z2/5Xbuk=;
        b=Y8tsmBtMuOnArX6ZyOM3wcplaa15voCmXHzUU4tA3GLEG8herNkveUIx+5ittKO/BT
         MWBXhiHRR58iBPl1tqeBdFfZO9ELDqjOQKQo4bdtl9eYE2lt7AvM1KUDBHCuHzoGZ783
         +5zA0PIkWzRc4jciXHQMoRMTBZLN0ObRvhnsVzo5FVE2AQlGlgSWveC5hMkR63YRjbEH
         dkxqQsCRpjo+8KX2S9sOHOZCJS9W5tA4A3fOu1GK+KCwhJ4G44a0J0oBpqfTSRpXjjoY
         +00L+l4w2OuOw4fFodv0AshBYMLIFyfrDROUDvGWqZIkmTPhue4swsJW7qu9idk3xsJl
         Gkvg==
X-Gm-Message-State: AOAM532lFc1zD3WrASMX5SCIQmr6WuEMk9FTxL1HPcKFXgRuo1IJgagF
        eL3XyQsaeXvnmWh96W76exP+0p7vqhVn9Q==
X-Google-Smtp-Source: ABdhPJxupp4BCqysGY8B+8ioljMT6lGtdrsk0NuHsQmKBavGz1uCRe1hAWPSqN54quqUQGi2Kwaw2Q==
X-Received: by 2002:a17:906:1146:: with SMTP id i6mr330416eja.12.1630619119850;
        Thu, 02 Sep 2021 14:45:19 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id mf2sm1698665ejb.76.2021.09.02.14.45.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 14:45:19 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id u16so5173368wrn.5
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 14:45:19 -0700 (PDT)
X-Received: by 2002:adf:9e4d:: with SMTP id v13mr310570wre.419.1630619118560;
 Thu, 02 Sep 2021 14:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com> <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
In-Reply-To: <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 2 Sep 2021 17:44:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
Message-ID: <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
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

On Thu, Sep 2, 2021 at 5:17 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Sep 2, 2021 at 1:30 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Sep 2, 2021 at 4:25 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > Only test integrity of csum_start if checksum offload is configured.
> > > >
> > > > With checksum offload and GRE tunnel checksum, gre_build_header will
> > > > cheaply build the GRE checksum using local checksum offload. This
> > > > depends on inner packet csum offload, and thus that csum_start points
> > > > behind GRE. But validate this condition only with checksum offload.
> > > >
> > > > Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> > > > Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > ---
> > > >  net/ipv4/ip_gre.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > > > index 177d26d8fb9c..09311992a617 100644
> > > > --- a/net/ipv4/ip_gre.c
> > > > +++ b/net/ipv4/ip_gre.c
> > > > @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
> > > >
> > > >  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
> > > >  {
> > > > -       if (csum && skb_checksum_start(skb) < skb->data)
> > > > +       /* Local checksum offload requires csum offload of the inner packet */
> > > > +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> > > > +           skb_checksum_start(skb) < skb->data)
> > > >                 return -EINVAL;
> > > > +
> > > >         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
> > > >  }
> >
> > Thanks for taking a look.
> >
> > > So a few minor nits.
> > >
> > > First I think we need this for both v4 and v6 since it looks like this
> > > code is reproduced for net/ipv6/ip6_gre.c.
> >
> > I sent a separate patch for v6. Perhaps should have made it a series
> > to make this more clear.
>
> Yeah, that was part of the reason I assumed the ipv6 patch was overlooked.

I was in two minds only because a series should come with a cover
letter and thus one extra email added to the firehose. But this makes
clear the value. Will just do that in the future.

> > > Second I don't know if we even need to bother including the "csum"
> > > portion of the lookup since that technically is just telling us if the
> > > GRE tunnel is requesting a checksum or not and I am not sure that
> > > applies to the fact that the inner L4 header is going to be what is
> > > requesting the checksum offload most likely.
> >
> > This test introduced in the original patch specifically protects the
> > GRE tunnel checksum calculation using lco_csum. The regular inner
> > packet path likely is already robust (as similar bug reports would be
> > more likely for that more common case).
>
> I was just thinking in terms of shaving off some extra comparisons. I
> suppose it depends on if this is being inlined or not. If it is being
> inlined there are at least 2 cases where the if statement would be
> dropped since csum is explicitly false. My thought was that by just
> jumping straight to the skb->ip_summed check we can drop the lookup
> for csum since it would be implied by the fact that skb->ip_summed is
> being checked. It would create a broader check, but at the same time
> it would reduce the number of comparisons in the call.

Most GRE tunnels don't have checksums and csum is likely in a register,
as function argument, so it likely is the cheaper test?

More functional argument: if !csum, the GRE tunnel does not care about
the integrity of csum_start. So I think that it should not read it at all.

> > > Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
> > > the path triggering this should be fixed rather than us silently
> > > dropping frames. We should be figuring out what cases are resulting in
> > > us getting CHECKSUM_PARTIAL without skb_checksum_start being set.
> >
> > We already know that bad packets can enter the kernel and trigger
> > this, using packet sockets and virtio_net_hdr. Unfortunately, this
> > *is* the fix.
>
> It sounds almost like we need a CHECKSUM_DODGY to go along with the
> SKB_GSO_DODGY in order to resolve these kinds of issues.
>
> So essentially we have a source that we know can give us bad packets.
> We really should be performing some sort of validation on these much
> earlier in order to clean them up so that we don't have to add this
> sort of exception handling code all over the Tx path.

Agreed with the concern. I've been arguing for validation at kernel
entry of virtio_net_hdr. As an optional feature, if nothing else:
https://patchwork.kernel.org/project/netdevbpf/patch/20210616203448.995314-3-tannerlove.kernel@gmail.com/

But unless we accept the cost of full parsing to identify the
transport headers, we cannot predict at that stage whether the field
is bogus, let alone whether it might trigger a bug later on. We do
basic validation: csum_start is verified to be within the skb linear,
so not totally out of bounds.

That the offset is not just bogus, but causes a bug appears to be a
rare exception peculiar to the GRE tunnel. Only it pulls the outer
header (in ipgre_xmit), applies lco_csum and can so trigger negative
overflow, as far as I could tell. That's why we decided to add the
limited check local to that code.

I'm not sure how we would use CHECKSUM_DODGY in practice.
