Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77903400D3C
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 23:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhIDVzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 17:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhIDVzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 17:55:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF20CC061575
        for <netdev@vger.kernel.org>; Sat,  4 Sep 2021 14:53:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r7so3922445edd.6
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 14:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xe9yI6vfEmbm9xWPHyQgQ7TftVgQ0YOLP1Y7tbdTVVM=;
        b=INE2N6e5XwPPzwmeZ1QzC+mtTIpanYw2AOca5i5Ug4asPbuvPPimwYCXPOmqBFi9Zr
         dSIUoF1LlKa7SGPrsKzLN37i3jbPmvLsQ9h8YV3YymqlTat+GqXyC3qseBrRVFtCzZ9v
         o7JWeXZIrnLwTEig573okD5zvdUK2wVOthC+44x2rl0i0dhJqIfD+0w0ma2QwKqD2BKG
         MbxNVTVtECmJ0My7dXMpdGZLv8qC7HLslwSTlbzRcYDDNhEYiwpxFDbliMwXH56mwpeb
         JnQKwl75PyZZWPZVRq2Jvy3dpthepmxzyc9mx7vhvLZVqsjNwTiNn67+3ZDlSHdHOsLV
         GHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xe9yI6vfEmbm9xWPHyQgQ7TftVgQ0YOLP1Y7tbdTVVM=;
        b=Vo4ggsC6chB0C90yil36OxJoEX+qswTzVYXi/Dq3843ATSCXAlBRb7Ryk5BJONWgK3
         Ddd/V0zGDhNXuoLvaUcdYmCPZs34CFR0jHfblX869YwDNsYBIjPihTGYAmSx0wo0WWps
         3tHDUAeXx8L+UFTw015ID5IIhLhsciyM11YVawR2dj46Gue0yuY72Gnw//+7kms0UBKp
         /sBlMHcnFF7LSjmjTSU/lL+s3k3xwvUbRHwvs9q99g0H+pp+it6NR2TMMS/kzMdsxOk0
         Zl0Vnk3Nt3+zKzTWYZGHqQm3KEwzWRGRYn9Q557Ipq9FFga1OsNO0NaqOChvExvEDVQr
         JgmA==
X-Gm-Message-State: AOAM531/mgo459Zt0AG/90uNuqB3QVBZnMAckymuSCoKMOAizAhG6La9
        8Q6+rsdsA/bARclZdCtmONKb5ScaqoiTLYsoFKo=
X-Google-Smtp-Source: ABdhPJymKZLz4Cnhgz8EmqEaRSJmulTa1dg4saGydgPyCvhT2V1aMwzDBLeZxTYs+Kjuq5gqfjVct1LsWIDEi0dU9jc=
X-Received: by 2002:a05:6402:28b3:: with SMTP id eg51mr5917378edb.31.1630792437188;
 Sat, 04 Sep 2021 14:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
 <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
 <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
 <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com>
 <CAKgT0Ud5ZFQ3Jv4DAFftf6OkhJe5UxEcuVTJs-9HYk8ptCt9Uw@mail.gmail.com> <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
In-Reply-To: <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 4 Sep 2021 14:53:45 -0700
Message-ID: <CAKgT0UecD+EmPRyWEghf8M_qrv8JN4iojqv2eZc-VD_OZDzB-g@mail.gmail.com>
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

On Sat, Sep 4, 2021 at 2:40 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, Sep 4, 2021 at 11:37 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Sat, Sep 4, 2021 at 7:46 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Fri, Sep 3, 2021 at 7:27 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Fri, Sep 3, 2021 at 12:38 PM Willem de Bruijn
> > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > >
> > > >
> > > > <snip>
> > > >
> > > > > > whereas if the offset is stored somewhere in the unstripped data we
> > > > > > could then drop the packet and count it as a drop without having to
> > > > > > modify the frame via the skb_pull.
> > > > >
> > > > > This is a broader issue that userspace can pass any csum_start as long
> > > > > as it is within packet bounds. We could address it here specifically
> > > > > for the GRE header. But that still leaves many potentially bad offsets
> > > > > further in the packet in this case, and all the other cases. Checking
> > > > > that specific header seems a bit arbitrary to me, and might actually
> > > > > give false confidence.
> > > > >
> > > > > We could certainly move the validation from gre_handle_offloads to
> > > > > before skb_pull, to make it more obvious *why* the check exists.
> > > >
> > > > Agreed. My main concern is that the csum_start is able to be located
> > > > somewhere where the userspace didn't write. For the most part the
> > > > csum_start and csum_offset just needs to be restricted to the regions
> > > > that the userspace actually wrote to.
> > >
> > > I don't quite follow. Even with this bug, the offset is somewhere userspace
> > > wrote. That data is just pulled.
> >
> > Sorry, I was thinking of the SOCK_DGRAM case where the header is added
> > via a call to dev_hard_header().
> >
> > > > > > Maybe for those
> > > > > > cases we need to look at adding an unsigned int argument to
> > > > > > virtio_net_hdr_to_skb in which we could pass 0 for the unused case or
> > > > > > dev->hard_header_len in the cases where we have something like
> > > > > > af_packet that is transmitting over an ipgre tunnel. The general idea
> > > > > > is to prevent these virtio_net_hdr_to_skb calls from pointing the
> > > > > > csum_start into headers that userspace was not responsible for
> > > > > > populating.
> > > > >
> > > > > One issue with that is that dev->hard_header_len itself is imprecise
> > > > > for protocols with variable length link layer headers. There, too, we
> > > > > have had a variety of bug fixes in the past.
> > > > >
> > > > > It also adds cost to every user of virtio_net_hdr, while we only know
> > > > > one issue in a rare case of the IP_GRE device.
> > > >
> > > > Quick question, the assumption is that the checksum should always be
> > > > performed starting no earlier than the transport header right? Looking
> > > > over virtio_net_hdr_to_skb it looks like it is already verifying the
> > > > transport header is in the linear portion of the skb. I'm wondering if
> > > > we couldn't just look at adding a check to verify the transport offset
> > > > is <= csum start? We might also be able to get rid of one of the two
> > > > calls to pskb_may_pull by doing that.
> > >
> > > Are you referring to this part in the .._NEEDS_CSUM branch?
> > >
> > >                 if (!skb_partial_csum_set(skb, start, off))
> > >                         return -EINVAL;
> > >
> > >                 p_off = skb_transport_offset(skb) + thlen;
> > >                 if (!pskb_may_pull(skb, p_off))
> > >                         return -EINVAL;
> > >
> > > skb_partial_csum_set is actually what sets the transport offset,
> > > derived from start.
> >
> > Ugh, I had overlooked that as I was more focused on the
> > skb_probe_transport_header calls in the af_packet code.
> >
> > So we can have both the transport offset and the csum_start in a
> > region that gets stripped by the ipgre code. Worse yet the inner
> > transport header will also be pointing somewhere outside of the
> > encapsulated region when we pass it off to skb_reset_inner_headers().
> >
> > Maybe it would make sense to just have the check look into the
> > transport offset instead of csum start as that way you are essentially
> > addressing two possible issues instead of one, and it would
> > effectively combine multiple checks as the uninitialized value is ~0
> > which should always be greater than "skb_headroom + tunnel->hlen +
> > sizeof(struct iphdr)". I think you mentioned before placing a check
> > just before you make the call to skb_pull in the GRE transmit path.
> > Doing that we would at least reduce the impact as it would only apply
> > in the header_ops case in ipgre_xmit instead of being applied to all
> > the transmit paths which don't perform the pull.
>
> Do you mean
>
>         if (dev->header_ops) {
> +               int pull_len = tunnel->hlen + sizeof(struct iphdr);
> +
>                 if (skb_cow_head(skb, 0))
>                         goto free_skb;
>
>                 tnl_params = (const struct iphdr *)skb->data;
>
> +               if (pull_len > skb_transport_offset(skb))
> +                       goto free_skb;
> +
>                 /* Pull skb since ip_tunnel_xmit() needs skb->data pointing
>                  * to gre header.
>                  */
> -               skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
> +               skb_pull(skb, pull_len);
>                 skb_reset_mac_header(skb);
>
> plus then
>
>  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>  {
> -       /* Local checksum offload requires csum offload of the inner packet */
> -       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> -           skb_checksum_start(skb) < skb->data)
> -               return -EINVAL;
> -
>         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM :
> SKB_GSO_GRE);
>  }

Yes, this is what I was thinking. We will also need an IPv6 version of
this as well, and may want to add a comment clarifying that this is to
prevent us from pointing inner offsets at pulled headers.

It lets us drop the csum, ipsummed, and csum_start checks in favor of
just the skb_transport_offset comparison which should be a net win
since it reduces the number of paths the code is encountered in, and
reduces the number of checks to just 1.
