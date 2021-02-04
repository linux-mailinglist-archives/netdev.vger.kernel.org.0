Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FF330FD6A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhBDTzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239557AbhBDTxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:53:32 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB80C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:52:52 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p20so7570207ejb.6
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6DeozAYQKr115a0yypAtHj6ZG4ELG1Z//PjeF+Nlbe8=;
        b=l7MbuRHVSoBe1U9hi4qhR0CB5G2/c0qX9EMBhLiFftgpAmiZCqMKjTzzPO44fGoCF/
         FVfcfRUZ+NMQlebpERxWCg0C0p3MFUrKkBBLTEWM2BQ1u1COe/HWn3U0njVRLHqWXzba
         YcoO7vRF65Vf68DqRQpFSxKxNE1RS2DKErDeBhRYCZjQgyxSnfUTEoLJHfyCqvYFhA1z
         oMeIZ+Gcrmb/Eccw7OjSDi79jvHnlSBeCKWqKWD+1dq7NubJ3FjzALMJTcVu/x4l7Jdl
         LEn7sT9u622rbX5hTue0IK6lQWfSFBbBrIxnvnc4LrZPzmVxGbWaoeApFbnT3zIQ+usb
         77LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6DeozAYQKr115a0yypAtHj6ZG4ELG1Z//PjeF+Nlbe8=;
        b=npfq9MHbb6D+GIYWt44XXgXfXtjMDGOSbFspPHUrFQH4L2E/tKWAmhdi7XtsOa3wTH
         NvLpockqjkQFzKrsoJVT4SkdUgMd5lQwNNaTev1FWVj6jZqCr7cYviZDjgsa96rrTE06
         kNmqxL88eW05hXAeujWPUjGxo+IaF6r56UWIHRl87/dv4QdbOaLQ3rQY+djtC+FJ36kO
         LCRzXsRSi8gHFYi0Yc3Zpiq+Gc+kRw64AlRI6aaVpt6vPcL6CWaWFg0OSDxOqfNzidET
         LKu7mLgffBtHMyLF3xtT3ORAgmrX81F+4h8vdNL5BGP4RZLyY+XvZTS+CLyjYTPD6zd/
         LvzA==
X-Gm-Message-State: AOAM530ZS11biDl1t6B1utfLNeb8CmEAfLsGTmYuGCEZZ0qYMlfixFhw
        k03r1M5MgJjnJhvStdC5Xmc9RTo+X3dMDsWKLRc=
X-Google-Smtp-Source: ABdhPJzOfXfR2eKOErt5EJqInqODI/iF99TXn49/qCPMQZvca5j9NEZZ5zScR4jFt+hk2Y5i5g7EYT9Md0tV+IvcpjY=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr705564ejj.464.1612468371165;
 Thu, 04 Feb 2021 11:52:51 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com> <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 14:52:14 -0500
Message-ID: <CAF=yD-JwREKypTt5a2xEF7Fru19A4vzUbkpxz+my+bYe8gVL3g@mail.gmail.com>
Subject: Re: [PATCH V2 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 6:30 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Modify the icmp_rcv function to check for PROBE messages and call
> icmp_echo if a PROBE request is detected.
>
> Modify the existing icmp_echo function to respond to both ping and PROBE
> requests.
>
> This was tested using a custom modification of the iputils package and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by both IPV4 and IPV6
> addresses. It currently does not support responding to probes off the proxy node
> (See RFC 8335 Section 2).
>
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Reorder variable declarations to follow coding style
>  - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
>    net devices
> ---
>  net/ipv4/icmp.c | 98 ++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 88 insertions(+), 10 deletions(-)
>
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 396b492c804f..18f9a2a3bf59 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -983,21 +983,85 @@ static bool icmp_redirect(struct sk_buff *skb)
>
>  static bool icmp_echo(struct sk_buff *skb)
>  {
> +       struct icmp_bxm icmp_param;
>         struct net *net;
> +       struct net_device *dev;
> +       struct icmp_extobj_hdr *extobj_hdr;
> +       struct icmp_ext_ctype3_hdr *ctype3_hdr;
> +       __u8 status;

nit: please maintain reverse christmas tree variable ordering

>
>         net = dev_net(skb_dst(skb)->dev);
> -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -               struct icmp_bxm icmp_param;
> +       /* should there be an ICMP stat for ignored echos? */
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
> +
> +       icmp_param.data.icmph           = *icmp_hdr(skb);
> +       icmp_param.skb                  = skb;
> +       icmp_param.offset               = 0;
> +       icmp_param.data_len             = skb->len;
> +       icmp_param.head_len             = sizeof(struct icmphdr);
>
> -               icmp_param.data.icmph      = *icmp_hdr(skb);
> +       if (icmp_param.data.icmph.type == ICMP_ECHO) {
>                 icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -               icmp_param.skb             = skb;
> -               icmp_param.offset          = 0;
> -               icmp_param.data_len        = skb->len;
> -               icmp_param.head_len        = sizeof(struct icmphdr);
> -               icmp_reply(&icmp_param, skb);
> +               goto send_reply;
>         }
> -       /* should there be an ICMP stat for ignored echos? */
> +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +               return true;
> +       /* We currently do not support probing off the proxy node */
> +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> +               return true;

What does this comment mean?

And why does the sequence number need to be even?

> +
> +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);

Why this mask?

> +       extobj_hdr = (struct icmp_extobj_hdr *)(skb->data + sizeof(struct icmp_ext_hdr));
> +       ctype3_hdr = (struct icmp_ext_ctype3_hdr *)(extobj_hdr + 1);

It is not safe to trust the contents of unverified packets. We cannot
just cast to a string and call dev_get_by_name. Need to verify packet
length and data format.

Also below code just casts to the expected data type at some offset.
Can that be defined more formally as header structs? Like ctype3_hdr,
but for other headers, as well.

> +       status = 0;
> +       switch (extobj_hdr->class_type) {
> +       case CTYPE_NAME:
> +               dev = dev_get_by_name(net, (char *)(extobj_hdr + 1));
> +               break;
> +       case CTYPE_INDEX:
> +               dev = dev_get_by_index(net, ntohl(*((uint32_t *)(extobj_hdr + 1))));
> +               break;
> +       case CTYPE_ADDR:
> +               switch (ntohs(ctype3_hdr->afi)) {
> +               case AFI_IP:
> +                       dev = ip_dev_find(net, *(__be32 *)(ctype3_hdr + 1));
> +                       break;
> +               case AFI_IP6:
> +                       dev = ipv6_dev_find(net, (struct in6_addr *)(ctype3_hdr + 1), dev);
> +                       if(dev) dev_hold(dev);
> +                       break;
> +               default:
> +                       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               break;
> +       default:
> +               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +               goto send_reply;
> +       }
> +       if(!dev) {
> +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> +               goto send_reply;
> +       }
> +       /* RFC 8335: 3 the last 8 bits of the Extended Echo Reply Message
> +        *  are laid out as follows:
> +        *      +-+-+-+-+-+-+-+-+
> +        *      |State|Res|A|4|6|
> +        *      +-+-+-+-+-+-+-+-+
> +        */
> +       if (dev->flags & IFF_UP)
> +               status |= EXT_ECHOREPLY_ACTIVE;
> +       if (dev->ip_ptr->ifa_list)
> +               status |= EXT_ECHOREPLY_IPV4;
> +       if (!list_empty(&dev->ip6_ptr->addr_list))
> +               status |= EXT_ECHOREPLY_IPV6;
> +       dev_put(dev);
> +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> +
> +send_reply:
> +       icmp_reply(&icmp_param, skb);
>         return true;
>  }
