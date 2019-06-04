Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6733F6C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 08:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFDG7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 02:59:46 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:35633 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfFDG7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 02:59:45 -0400
Received: by mail-vs1-f65.google.com with SMTP id u124so2285802vsu.2;
        Mon, 03 Jun 2019 23:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ct+dj+TeFGYPRbN7w+7PHPvII+8/Y2dGCES2KKtAHHo=;
        b=pWLna89WZn7dcM0S/wyEszhw9i4En1+7H46YYKuAiZsyrpQSF3o4COvb5+H5bhIAd1
         iP2bgFXKrjjs6yPXlyiZ6okRoSYPpvJdYwTuH2wdCNjvwocfgtk9ZMGfEvAnDiP1VFNW
         /O2yw5GZdYrQmUE5cpUO4BKBzVXtVf9uM+dUwXPEXBT/8lo+MDLC3PalDHY+31PqGNDz
         e0/czIl1cLqZHj13obzr6w0y+qwTFF22q8Vd7jkfIqL6xofNIwo2dN+XZU25J+Dd/M7F
         a4IVa2eiXOoPkjj/5f6P4tClh4yMiMNRL8+TW8wLUFV7Txe0vC4S9qNjTW3UOVsjLG+g
         GX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ct+dj+TeFGYPRbN7w+7PHPvII+8/Y2dGCES2KKtAHHo=;
        b=qoqp4sv0/j0x2tokI4Zo1RSP6tF5jy4MwfXo6QScca1WszbcuJGVQKw5qcZMJ5oYKO
         kNdWyId+b/R1rF1tC3hXziCqI9NrBd87jHoiGasFIwlh5k6+7qPTV1zAhOCqxjNiOhNV
         xdEmncMntXLj99Czi3mSu0wWJIt0lmp+BL97trIFs/0rsLjn6dLPCQYrurufE69nMHHB
         Y0JubO3v9hPWPga1OVXQGn3dkFe5Nfa4gX6vCTesaI3VC0LrIcWrdEUfH6MyP72UIl02
         xZ690q5veSzIseXg1NkAsHclwVjsFXSi93emIgx0EJixyUmRCxnf83D8tXsA0Iundbl6
         iaOA==
X-Gm-Message-State: APjAAAVIWSdMVxdZm5yPnr7Jy/B0H0Ucy2vwZ7Km4NzMuIvVM+Ao6zxe
        +JP3IsN/l2Mgb8V5H7PofOEylu4eM5/e83o39veqPjrVBC0xfA==
X-Google-Smtp-Source: APXvYqxa/N1nMMBMS9cabavZ6JMxqjs1SSh6Vq4tbZKCgVAu/WWNEdbNxTR+bMGuY3wG6/Yu5dot4rhSHeeMb8IL4ns=
X-Received: by 2002:a67:ce10:: with SMTP id s16mr4055803vsl.74.1559631584400;
 Mon, 03 Jun 2019 23:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com> <CAKgHYH1=aqmOEsbH-OuSjK4CJ=9FmocjuOg6tsyJNPLEOWVB-g@mail.gmail.com>
 <a0f08b20-41ef-db53-48df-4d8f5333b6af@gmail.com>
In-Reply-To: <a0f08b20-41ef-db53-48df-4d8f5333b6af@gmail.com>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Tue, 4 Jun 2019 14:59:03 +0800
Message-ID: <CAKgHYH0pH3Otj2izYwdcGKhJhjfovi1C-Ez1g2f7P5ahzQEfyw@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I don't get your point. Why is xfrm6_transport_output() buggy?
The point is that there would be out-of-bound access in
mip6_destopt_offset() and mip6_destopt_offset(), since there is no
sanity check for offset.

There is chance that offset + sizeof(struct ipv6_opt_hdr) > packet_len.

As described in CVE-2017-9074:  "The IPv6 fragmentation implementation
in the Linux kernel through 4.11.1 does not consider that the nexthdr
field may be associated with an invalid option, which allows local
users to cause a denial of service (out-of-bounds read and BUG)".

At the same time, there are bugs in  mip6_destopt_offset() and
mip6_destopt_offset(), which is similar to CVE-2017-7542.

On Sat, Jun 1, 2019 at 1:35 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/30/19 8:04 PM, Yang Xiao wrote:
> > On Fri, May 31, 2019 at 1:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 5/30/19 8:28 AM, Young Xiao wrote:
> >>> The fragmentation code tries to parse the header options in order
> >>> to figure out where to insert the fragment option.  Since nexthdr points
> >>> to an invalid option, the calculation of the size of the network header
> >>> can made to be much larger than the linear section of the skb and data
> >>> is read outside of it.
> >>>
> >>> This vulnerability is similar to CVE-2017-9074.
> >>>
> >>> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> >>> ---
> >>>  net/ipv6/mip6.c | 24 ++++++++++++++----------
> >>>  1 file changed, 14 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
> >>> index 64f0f7b..30ed1c5 100644
> >>> --- a/net/ipv6/mip6.c
> >>> +++ b/net/ipv6/mip6.c
> >>> @@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >>>                              u8 **nexthdr)
> >>>  {
> >>>       u16 offset = sizeof(struct ipv6hdr);
> >>> -     struct ipv6_opt_hdr *exthdr =
> >>> -                                (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
> >>>       const unsigned char *nh = skb_network_header(skb);
> >>>       unsigned int packet_len = skb_tail_pointer(skb) -
> >>>               skb_network_header(skb);
> >>> @@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >>>
> >>>       *nexthdr = &ipv6_hdr(skb)->nexthdr;
> >>>
> >>> -     while (offset + 1 <= packet_len) {
> >>> +     while (offset <= packet_len) {
> >>> +             struct ipv6_opt_hdr *exthdr;
> >>>
> >>>               switch (**nexthdr) {
> >>>               case NEXTHDR_HOP:
> >>> @@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >>>                       return offset;
> >>>               }
> >>>
> >>> +             if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
> >>> +                     return -EINVAL;
> >>> +
> >>> +             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
> >>>               offset += ipv6_optlen(exthdr);
> >>>               *nexthdr = &exthdr->nexthdr;
> >>> -             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
> >>>       }
> >>>
> >>> -     return offset;
> >>> +     return -EINVAL;
> >>>  }
> >>>
> >>
> >>
> >> Ok, but have you checked that callers have been fixed ?
> >
> > I've checked the callers. There are two callers:
> > xfrm6_transport_output() and xfrm6_ro_output(). There are checks in
> > both function.
> >
> > ------------------------------------------------------------------------------
> >         hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
> >         if (hdr_len < 0)
> >                 return hdr_len;
> > ------------------------------------------------------------------------------
> >>
> >> xfrm6_transport_output() seems buggy as well,
> >> unless the skbs are linearized before entering these functions ?
> > I can not understand what you mean about this comment.
> > Could you explain it in more detail.
>
>
> If we had a problem, then the memmove(ipv6_hdr(skb), iph, hdr_len);
>  in xfrm6_transport_output() would be buggy, since iph could also point to freed memory.
>
>
>


-- 
Best regards!

Young
-----------------------------------------------------------
