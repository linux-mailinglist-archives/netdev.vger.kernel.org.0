Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A231044E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBEFCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhBEFCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 00:02:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F01C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 21:01:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m12so2975214pjs.4
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 21:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8nfjFzqBt4Y2yA0w2sVIDxBZ/HbWlT+uCvwHdu0bBZQ=;
        b=K/AkARuVOF+InzuXadP+56WHjj+tof/T1n78bFkIcyKO2/L0A5Ip6+fWUo039hAIc8
         NU+1C+6fYpljuFYmG57lPuUNlAr8RI+7XiFyqdyNMDgf08rezLicYDqa03noXdnp2ecK
         kCryPkIuO7SM2RN4FKvh0WZ4FFK2/BfCVXCUQhSDPJGUsNFR+FUpeVanylKQFSMuve3W
         uOJzYPoOqWNTD7kRXMW7r0M5cqT/KGXfPPRDG0XRmPItCz8hZPtQ/NrCYTDv6XPUu0dP
         XP7rrNsze9OOTVGEMZC/GHmT16zEp08uv7/W+XvTfQoseRQHDpoHl/WC0qdBQUbgsMtM
         4PeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8nfjFzqBt4Y2yA0w2sVIDxBZ/HbWlT+uCvwHdu0bBZQ=;
        b=FcqcwaFy7au4bLLXk/NvMjG+G2gxGY+vWcgHtVRMjWx1mF1irf33Rpza317ZzGd6xE
         2KkL21LW2LDLiq1YYWUG5r+D9UxMG6yJtIE+WuiHb00vaWRnuLTbzKQi3KIrhFZUjBHj
         NbhkfWtEiHEh2/tv8zVbjuaeSpNE7GcfiHMgxCT9Sz5UCFbNi/gptY5zz+bxsrLZi9Wd
         Nu+qmWjY32Z+MDtUwzvsp+BivUBF3etsWEEjZtfk7hQ3fh7dClL/OhO0i+hctUBQauMZ
         CUVAX1JVWeLzdNGchr5VflEN7SQwlo4K97y5ptZ7NpafVFKjbaLgmQMjGclRKEBWAp9K
         jyNQ==
X-Gm-Message-State: AOAM530anlw7kZjNq6XBZKk/cr29PgdCdkodYZrUBh/R8Bif0WGdLn6r
        sAAmX9qrIoE3JD6QBkn2XXQ=
X-Google-Smtp-Source: ABdhPJwrNWwE4fy9BNoa+C022YXIZQbTFJXOfPCrAPOm+zjW7plzbwG9sL5XJSAevwCBm/lNi4kCuQ==
X-Received: by 2002:a17:903:185:b029:e1:8692:90bc with SMTP id z5-20020a1709030185b02900e1869290bcmr2395831plg.75.1612501312177;
        Thu, 04 Feb 2021 21:01:52 -0800 (PST)
Received: from aroeseler-ly545.local (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id b12sm163713pfr.178.2021.02.04.21.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 21:01:51 -0800 (PST)
Message-ID: <2d6da285c746a0f95c1e1cc56c2a5aa59f1ea5c0.camel@gmail.com>
Subject: Re: [PATCH V2 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Date:   Thu, 04 Feb 2021 23:01:50 -0600
In-Reply-To: <CAF=yD-JwREKypTt5a2xEF7Fru19A4vzUbkpxz+my+bYe8gVL3g@mail.gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
         <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
         <CAF=yD-JwREKypTt5a2xEF7Fru19A4vzUbkpxz+my+bYe8gVL3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-02-04 at 14:52 -0500, Willem de Bruijn wrote:
> On Wed, Feb 3, 2021 at 6:30 PM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
> > 
> > Modify the icmp_rcv function to check for PROBE messages and call
> > icmp_echo if a PROBE request is detected.
> > 
> > Modify the existing icmp_echo function to respond to both ping and
> > PROBE
> > requests.
> > 
> > This was tested using a custom modification of the iputils package
> > and
> > wireshark. It supports IPV4 probing by name, ifindex, and probing
> > by both IPV4 and IPV6
> > addresses. It currently does not support responding to probes off
> > the proxy node
> > (See RFC 8335 Section 2).
> > 
> > 
> > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > ---
> > Changes since v1:
> >  - Reorder variable declarations to follow coding style
> >  - Switch to functions such as dev_get_by_name and ip_dev_find to
> > lookup
> >    net devices
> > ---
> >  net/ipv4/icmp.c | 98 ++++++++++++++++++++++++++++++++++++++++++++-
> > ----
> >  1 file changed, 88 insertions(+), 10 deletions(-)
> > 
> > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > index 396b492c804f..18f9a2a3bf59 100644
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -983,21 +983,85 @@ static bool icmp_redirect(struct sk_buff
> > *skb)
> > 
> >  static bool icmp_echo(struct sk_buff *skb)
> >  {
> > +       struct icmp_bxm icmp_param;
> >         struct net *net;
> > +       struct net_device *dev;
> > +       struct icmp_extobj_hdr *extobj_hdr;
> > +       struct icmp_ext_ctype3_hdr *ctype3_hdr;
> > +       __u8 status;
> 
> nit: please maintain reverse christmas tree variable ordering
> 
> > 
> >         net = dev_net(skb_dst(skb)->dev);
> > -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> > -               struct icmp_bxm icmp_param;
> > +       /* should there be an ICMP stat for ignored echos? */
> > +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> > +               return true;
> > +
> > +       icmp_param.data.icmph           = *icmp_hdr(skb);
> > +       icmp_param.skb                  = skb;
> > +       icmp_param.offset               = 0;
> > +       icmp_param.data_len             = skb->len;
> > +       icmp_param.head_len             = sizeof(struct icmphdr);
> > 
> > -               icmp_param.data.icmph      = *icmp_hdr(skb);
> > +       if (icmp_param.data.icmph.type == ICMP_ECHO) {
> >                 icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> > -               icmp_param.skb             = skb;
> > -               icmp_param.offset          = 0;
> > -               icmp_param.data_len        = skb->len;
> > -               icmp_param.head_len        = sizeof(struct
> > icmphdr);
> > -               icmp_reply(&icmp_param, skb);
> > +               goto send_reply;
> >         }
> > -       /* should there be an ICMP stat for ignored echos? */
> > +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> > +               return true;
> > +       /* We currently do not support probing off the proxy node
> > */
> > +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> > +               return true;
> 
> What does this comment mean?
> 
> And why does the sequence number need to be even?

RFC 8335 Section 2 specifies that the ICMP Extended Echo Request
messages use a modified sequence number field, as follows.
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     Type      |     Code      |          Checksum             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           Identifier          |Sequence Number|   Reserved  |L|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
The L-bit is set if the probed interface resides on the proxy node. We
only support probing interfaces that lie on the proxy node since it
simplifies the response handler and, if we wanted to know the status of
an interface on another node, we could simply probe that node instead.
This line ensures that the L-bit is set to 1.

I'll clarify the wording of the comment.

> 
> > +
> > +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> > +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> 
> Why this mask?

This clears the status fields of the reply message to avoid sending old
data back to the probing host.

> 
> > +       extobj_hdr = (struct icmp_extobj_hdr *)(skb->data +
> > sizeof(struct icmp_ext_hdr));
> > +       ctype3_hdr = (struct icmp_ext_ctype3_hdr *)(extobj_hdr +
> > 1);
> 
> It is not safe to trust the contents of unverified packets. We cannot
> just cast to a string and call dev_get_by_name. Need to verify packet
> length and data format.
> 

Great catch, I will work on adding this into the next version.

> Also below code just casts to the expected data type at some offset.
> Can that be defined more formally as header structs? Like ctype3_hdr,
> but for other headers, as well.
> 

Will do.

> > +       status = 0;
> > +       switch (extobj_hdr->class_type) {
> > +       case CTYPE_NAME:
> > +               dev = dev_get_by_name(net, (char *)(extobj_hdr +
> > 1));
> > +               break;
> > +       case CTYPE_INDEX:
> > +               dev = dev_get_by_index(net, ntohl(*((uint32_t
> > *)(extobj_hdr + 1))));
> > +               break;
> > +       case CTYPE_ADDR:
> > +               switch (ntohs(ctype3_hdr->afi)) {
> > +               case AFI_IP:
> > +                       dev = ip_dev_find(net, *(__be32
> > *)(ctype3_hdr + 1));
> > +                       break;
> > +               case AFI_IP6:
> > +                       dev = ipv6_dev_find(net, (struct in6_addr
> > *)(ctype3_hdr + 1), dev);
> > +                       if(dev) dev_hold(dev);
> > +                       break;
> > +               default:
> > +                       icmp_param.data.icmph.code =
> > ICMP_EXT_MAL_QUERY;
> > +                       goto send_reply;
> > +               }
> > +               break;
> > +       default:
> > +               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> > +               goto send_reply;
> > +       }
> > +       if(!dev) {
> > +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> > +               goto send_reply;
> > +       }
> > +       /* RFC 8335: 3 the last 8 bits of the Extended Echo Reply
> > Message
> > +        *  are laid out as follows:
> > +        *      +-+-+-+-+-+-+-+-+
> > +        *      |State|Res|A|4|6|
> > +        *      +-+-+-+-+-+-+-+-+
> > +        */
> > +       if (dev->flags & IFF_UP)
> > +               status |= EXT_ECHOREPLY_ACTIVE;
> > +       if (dev->ip_ptr->ifa_list)
> > +               status |= EXT_ECHOREPLY_IPV4;
> > +       if (!list_empty(&dev->ip6_ptr->addr_list))
> > +               status |= EXT_ECHOREPLY_IPV6;
> > +       dev_put(dev);
> > +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> > +
> > +send_reply:
> > +       icmp_reply(&icmp_param, skb);
> >         return true;
> >  }


