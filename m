Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BD5306D9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfEaDFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:05:08 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40394 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEaDFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:05:07 -0400
Received: by mail-vs1-f68.google.com with SMTP id c24so5782886vsp.7;
        Thu, 30 May 2019 20:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Tw6MfE3P1bGwhttusOX/dvsaJqtQKxURFmXarqN8Wk=;
        b=dkhdpTV768kkp6B70tjzxMcFbZIA1qkLLrYjL4RMf8a3fMP1pJQAV/EVPTzSNNtRYV
         FUWPb7etlnoUShlILHe5PsYv8oULi7U2zG+aIlAceqOi0Z/mMZKTJFs4qPMNIfcX+rzo
         ob5XwpUnHizhWxqTmRlqcwe/wBnzJc94gVvnHWylSwNfpoJ4Lt+Ck9otZpgdbXF8dewW
         3tZMdngZx4eAMJrXkZxgIAA9NTyA5narqpOkzH/dFpeiW/BwC21IHx9uVp1DYV7Ai/wV
         Xe3MZHPwDIiDjMC7lSBwpFgxXLKuuOa9+YDuCMrbd3l4L1JuZHS2F3vTyk/P3dm1unbB
         N/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Tw6MfE3P1bGwhttusOX/dvsaJqtQKxURFmXarqN8Wk=;
        b=TQ4hccSjXlk4ZIIY3aERzOf1AdEzwMvueza1QRDPXXXoihw/+atsj5W8xuXHiitbt+
         53LmgUkr+Pi1q9tLeIqzJJ0gvFwTUgTWgfuLf45wapAHeKaF6o3zA9cRnEfuX+x2ZYT1
         57nfW+0omWahce/HOg9EifIMDGfiiEoqKbTepPL3NRdrPTN56Ipza1LqlIwEOIv0DyHj
         el8oJZ1ttjnfGHD7ivHryZJp/9mkd7jVxIiUI4yx8ztnHuPy9zlqfB7/ph2Ni/X0mINF
         B2zI9xaT8IrYbml6SzfVCVK0uV88aN/eSTYqZKQ4WZEtnqDe928ppbIqqGw6i2ID3E2u
         JpSA==
X-Gm-Message-State: APjAAAU4flBgZ1JttPeU25DJv7KEbHqHCmdRFhYdDIlN5mpwS1SkB3gI
        YgeE0g/ZSDr/vpkcDsohpbopCYnCXra9KTVTbLk=
X-Google-Smtp-Source: APXvYqzHV1lKMwk+FNM7dfPB5Sz5hARr3Ws8DrzHmkVGhE5KL1j7TfX0wr0G1wdCZo7XKBNHhRdZkGJkonEozHZfCVM=
X-Received: by 2002:a67:d68e:: with SMTP id o14mr4444883vsj.140.1559271906887;
 Thu, 30 May 2019 20:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com> <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
In-Reply-To: <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Fri, 31 May 2019 11:04:22 +0800
Message-ID: <CAKgHYH1=aqmOEsbH-OuSjK4CJ=9FmocjuOg6tsyJNPLEOWVB-g@mail.gmail.com>
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

On Fri, May 31, 2019 at 1:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/30/19 8:28 AM, Young Xiao wrote:
> > The fragmentation code tries to parse the header options in order
> > to figure out where to insert the fragment option.  Since nexthdr points
> > to an invalid option, the calculation of the size of the network header
> > can made to be much larger than the linear section of the skb and data
> > is read outside of it.
> >
> > This vulnerability is similar to CVE-2017-9074.
> >
> > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > ---
> >  net/ipv6/mip6.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
> > index 64f0f7b..30ed1c5 100644
> > --- a/net/ipv6/mip6.c
> > +++ b/net/ipv6/mip6.c
> > @@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >                              u8 **nexthdr)
> >  {
> >       u16 offset = sizeof(struct ipv6hdr);
> > -     struct ipv6_opt_hdr *exthdr =
> > -                                (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
> >       const unsigned char *nh = skb_network_header(skb);
> >       unsigned int packet_len = skb_tail_pointer(skb) -
> >               skb_network_header(skb);
> > @@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >
> >       *nexthdr = &ipv6_hdr(skb)->nexthdr;
> >
> > -     while (offset + 1 <= packet_len) {
> > +     while (offset <= packet_len) {
> > +             struct ipv6_opt_hdr *exthdr;
> >
> >               switch (**nexthdr) {
> >               case NEXTHDR_HOP:
> > @@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
> >                       return offset;
> >               }
> >
> > +             if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
> > +                     return -EINVAL;
> > +
> > +             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
> >               offset += ipv6_optlen(exthdr);
> >               *nexthdr = &exthdr->nexthdr;
> > -             exthdr = (struct ipv6_opt_hdr *)(nh + offset);
> >       }
> >
> > -     return offset;
> > +     return -EINVAL;
> >  }
> >
>
>
> Ok, but have you checked that callers have been fixed ?

I've checked the callers. There are two callers:
xfrm6_transport_output() and xfrm6_ro_output(). There are checks in
both function.

------------------------------------------------------------------------------
        hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
        if (hdr_len < 0)
                return hdr_len;
------------------------------------------------------------------------------
>
> xfrm6_transport_output() seems buggy as well,
> unless the skbs are linearized before entering these functions ?
I can not understand what you mean about this comment.
Could you explain it in more detail.

>
> Thanks.
>
>
>
