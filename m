Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7C130087A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbhAVQTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729608AbhAVQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:18:42 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33451C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:18:02 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e22so12108385iog.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k7aFdZLlLkKadaaLgSOzC0pYwBp2DvRtsE6eIRlG/L4=;
        b=uhU6OTUbrIKzj4xk3+jcmodex87T07GUFw1Knfk5JLPO0zMjv7UwmbihNrRt0jZBkO
         Gv/j+gx1ZJZ+/4YeljbaVBCRfNS2fWgr/zpV5C7apSxCHWIaUS4NMaYII5HUUGO7EuTq
         /IMQ4W60oAThy4sn+cu09nQMhpQQyLjZWh326QYQCgOZ+n9zag/t/308gZHIM4xNxB9d
         /1QDCcyO5y0VmxIKRBzk39dm6KYRDaAGKK/zTV7RoodPo0GOTRNgV2ocRhSpUUN3APZW
         su5d6Qo2UD5z/DN8AJ46cY/myz4cPtm5Ty/k2sUs7s+cQ9ryhdLvfEih5EYlt2sJwkbg
         0AxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k7aFdZLlLkKadaaLgSOzC0pYwBp2DvRtsE6eIRlG/L4=;
        b=Ztctsn0QKvCbwm91y1be/zxiL37SAIQh36RQxx2KqC+XfThUyU8HwEDeHZURnC+xus
         OqwuSKibS5z+xqeui3Jo5Or4uavppIVyCsJ6kgqRPYwn2cckdvW8mTcYX+sqt6YEgT/d
         Qn4FzbG9VRe+UNpLKvZE4Pjucxb4uvXCpBPboHXnl1AfUaz8OlOVWnZ0JQ+Ndr2BD7yx
         5hJF2M0+Vj2OKEB8n1pamGTQU/ShSWqcTIegg0abDxSNU0GzgMEvpX2+IuBoFd9ptz9p
         re5UByCgWg6x6jyg8ScWdWprZU5Hz6vGpVzoU74+JyLGfKBzCg2G4tOzL88DZqw266a9
         tl5w==
X-Gm-Message-State: AOAM533neUhXdNUGTRiBsdms1Jhiv3Z3yDxBwTjP/jQ9soF0BxB5K8dU
        Lwi2Bek1ZNQnxQhdsPMYYNQnjQgWxgwIcf+QDWM=
X-Google-Smtp-Source: ABdhPJxPEGt/Xq/Wyo/diZSm6cCUpopj66B+C6CuxTrsQHxCeT2vXOKS8qhuMWDzwa1uBHxhzW9g15XL0DwK4r5dcmg=
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr481287ils.64.1611332281479;
 Fri, 22 Jan 2021 08:18:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611218673.git.lucien.xin@gmail.com> <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
 <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
 <CAKgT0Ucb6EO45+AxWAL8Vgwy4e7b=88TagW+xE-XizedOvmQEw@mail.gmail.com> <CADvbK_c0ByOxha_+afNP_UqdVcKmuQjbp1S47j+4Zjvu+aBPLw@mail.gmail.com>
In-Reply-To: <CADvbK_c0ByOxha_+afNP_UqdVcKmuQjbp1S47j+4Zjvu+aBPLw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 22 Jan 2021 08:17:50 -0800
Message-ID: <CAKgT0UfxD1ZyKbcw0ZLOtDtbKBQaQUXPdpUEqxDiaKKR4CRdhA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: add CSUM_T_IP_GENERIC csum_type
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 7:18 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, Jan 22, 2021 at 2:13 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, Jan 21, 2021 at 12:46 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > This patch is to extend csum_type field to 2 bits, and introduce
> > > CSUM_T_IP_GENERIC csum type, and add the support for this in
> > > skb_csum_hwoffload_help(), just like CSUM_T_SCTP_CRC.
> > >
> > > Note here it moves dst_pending_confirm field below ndisc_nodetype
> > > to avoid a memory hole.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  include/linux/skbuff.h |  5 +++--
> > >  net/core/dev.c         | 17 +++++++++++++----
> > >  2 files changed, 16 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index 67b0a01..d5011fb 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -224,6 +224,7 @@
> > >
> > >  #define CSUM_T_INET            0
> > >  #define CSUM_T_SCTP_CRC                1
> > > +#define CSUM_T_IP_GENERIC      2
> > >
> > >  /* Maximum value in skb->csum_level */
> > >  #define SKB_MAX_CSUM_LEVEL     3
> > > @@ -839,11 +840,11 @@ struct sk_buff {
> > >         __u8                    vlan_present:1;
> > >         __u8                    csum_complete_sw:1;
> > >         __u8                    csum_level:2;
> > > -       __u8                    csum_type:1;
> > > -       __u8                    dst_pending_confirm:1;
> > > +       __u8                    csum_type:2;
> > >  #ifdef CONFIG_IPV6_NDISC_NODETYPE
> > >         __u8                    ndisc_nodetype:2;
> > >  #endif
> > > +       __u8                    dst_pending_confirm:1;
> > >
> > >         __u8                    ipvs_property:1;
> > >         __u8                    inner_protocol_type:1;
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 3241de2..6d48af2 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3617,11 +3617,20 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
> > >  int skb_csum_hwoffload_help(struct sk_buff *skb,
> > >                             const netdev_features_t features)
> > >  {
> > > -       if (unlikely(skb_csum_is_sctp(skb)))
> > > -               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > > -                       skb_crc32c_csum_help(skb);
> > > +       if (likely(!skb->csum_type))
> > > +               return !!(features & NETIF_F_CSUM_MASK) ? 0 :
> > > +                      skb_checksum_help(skb);
> > >
> > > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > > +       if (skb_csum_is_sctp(skb)) {
> > > +               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> > > +                      skb_crc32c_csum_help(skb);
> > > +       } else if (skb->csum_type == CSUM_T_IP_GENERIC) {
> > > +               return !!(features & NETIF_F_HW_CSUM) ? 0 :
> > > +                      skb_checksum_help(skb);
> > > +       } else {
> > > +               pr_warn("Wrong csum type: %d\n", skb->csum_type);
> > > +               return 1;
> > > +       }
> >
> > Is the only difference between CSUM_T_IP_GENERIC the fact that we
> > check for NETIF_F_HW_CSUM versus using NETIF_F_CSUM_MASK? If so I
> > don't think adding the new bit is adding all that much value. Instead
> > you could probably just catch this in the testing logic here.
> >
> > You could very easily just fold CSUM_T_IP_GENERIC into CSUM_T_INET,
> > and then in the checks here you split up the checks for
> > NETIF_F_HW_CSUM as follows:
> If so, better not to touch csum_not_inet now. I will drop the patch 1/3.
>
> >
> >  if (skb_csum_is_sctp(skb))
> >     return !!(features & NETIF_F_SCTP_CRC) ? 0 : skb_crc32c_csum_help(skb);
> >
> > if (skb->csum_type) {
> >     pr_warn("Wrong csum type: %d\n", skb->csum_type);
> >     return 1;
> > }
> >
> > if (features & NETIF_F_HW_CSUM)
> >     return 0;
> >
> > if (features & NETIF_F_CSUM_MASK) {
> >     switch (skb->csum_offset) {
> >     case offsetof(struct tcphdr, check):
> >     case offsetof(struct udphdr, check):
> >             return 0;
> >     }
> Question is: is it reliable to check the type by skb->csum_offset?
> What if one day there's another protocol, whose the checksum field
> is on the same offset, which is also using the CSUM_T_IP_GENERIC?

I'd say we are better off crossing that bridge once we get there. For
now we only have a few L4 protocols that are requesting Tx checksum
offload, and I suspect that in many cases they probably won't care
about the actual protocol when it comes to the checksum since the L4
checksum is usually pretty straight forward with it consisting of just
needing to know the start of the transport header and the offset to
place it at based on the protocol.
