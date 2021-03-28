Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984E434BD6B
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhC1RBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhC1RBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:01:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F2C061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:01:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bf3so11692484edb.6
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lpwxk4fiTpvadLU2dHihJc0tXmGLlcT9AttCk+DiUg=;
        b=i8LPEpScrrwOTZp4W0Jpe/jpYhfMtQCtVo1eHFoH7fxc7+nEtlm2gcqCdZuPgUrtsh
         gL4U7reAaZnIA4aLHUUfKVpDAQwV0gB/skHLaSMUrF5NxWCBRKA7DHYztzzvAhNSX5jt
         yqRKW2oRoBue5Jrg0JxrAc/zR6TyQUE501aHP871Yy23/X/6pCtfodfT+jeoNfMLZMEY
         3LaHKvbbE//JY9oPwKkOQEK5YrNtAAahXnv6XDtZRzS79iN+E/6QwGKXbJf+sKuPJQiv
         +JFRc5zGDD5m1FUemd8pNkG3auIy7QK4h3XVfSD0rneztwWG8xZBU9LYQTtCoPjr6Jgf
         BIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lpwxk4fiTpvadLU2dHihJc0tXmGLlcT9AttCk+DiUg=;
        b=uHGZ3nA4lOEvHrKyAF024Z730sCkfd3mqR8nuyQ+LHpTuPt+8dIK3iYsXQyZg7nFPN
         Pxs6Ps8+07tvnoa0jEhdI6SJsJX7wpfvVY5cZCMvLKDHMteGaQ9BC928jWBh/ecufHhD
         DZqr1rKx7Zn2BIJDnosRgENjcbUUq0WX0I1DOEdx8Cx5xmTDMCq/wL3loHEYFrFvFnCT
         Opd+lxS+tmiVJywY5Zo/5SjKxEdA/t3o3vut4BV805hb7Lb9NwcER4KSfu7YspVw4B9i
         jHV9KR6PmbloXs5SCXJMEptRDpSjcxZFVcqqfb3Ma6MbCtZaxM1UtlY9zK6EMYqo/ig8
         0hlw==
X-Gm-Message-State: AOAM53160JuiPrtdTWlkxlwKjr24PHn0SS5RZ6pZ9eRaht3bUtJt5mVe
        LX9PpJCDA+DKk9qVNnTIPIKQybcP6OE=
X-Google-Smtp-Source: ABdhPJxdqMaZzX1oTjWbAyYQb+3j3eber+FAodglAF6E0YLXbIIxnKlj+5N7emAT2cikhQyXu9Zi5w==
X-Received: by 2002:a05:6402:168c:: with SMTP id a12mr25333211edv.344.1616950866176;
        Sun, 28 Mar 2021 10:01:06 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id ld19sm6901358ejb.102.2021.03.28.10.01.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 10:01:05 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so5471839wmi.3
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:01:04 -0700 (PDT)
X-Received: by 2002:a1c:6855:: with SMTP id d82mr12077070wmc.169.1616950864146;
 Sun, 28 Mar 2021 10:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com> <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Mar 2021 13:00:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeBRCDcu7uKp9=7UZWR3zmSrk41ArqrseW9jHYgK+WPpg@mail.gmail.com>
Message-ID: <CA+FuTSeBRCDcu7uKp9=7UZWR3zmSrk41ArqrseW9jHYgK+WPpg@mail.gmail.com>
Subject: Re: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 2:20 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Modify the icmp_rcv function to check PROBE messages and call icmp_echo
> if a PROBE request is detected.
>
> Modify the existing icmp_echo function to respond ot both ping and PROBE
> requests.
>
> This was tested using a custom modification to the iputils package and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by
> both IPV4 and IPV6 addresses. It currently does not support responding
> to probes off the proxy node (see RFC 8335 Section 2).
>
> The modification to the iputils package is still in development and can
> be found here: https://github.com/Juniper-Clinic-2020/iputils.git. It
> supports full sending functionality of PROBE requests, but currently
> does not parse the response messages, which is why Wireshark is required
> to verify the sent and recieved PROBE messages. The modification adds
> the ``-e'' flag to the command which allows the user to specify the
> interface identifier to query the probed host. An example usage would be
> <./ping -4 -e 1 [destination]> to send a PROBE request of ifindex 1 to the
> destination node.
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

>  static bool icmp_echo(struct sk_buff *skb)
>  {
> +       struct icmp_ext_hdr *ext_hdr, _ext_hdr;
> +       struct icmp_ext_echo_iio *iio, _iio;
> +       struct icmp_bxm icmp_param;
> +       struct net_device *dev;
> +       char buff[IFNAMSIZ];
>         struct net *net;
> +       u16 ident_len;
> +       u8 status;
>
>         net = dev_net(skb_dst(skb)->dev);
> -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -               struct icmp_bxm icmp_param;
> +       /* should there be an ICMP stat for ignored echos? */
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
> +
> +       icmp_param.data.icmph      = *icmp_hdr(skb);
> +       icmp_param.skb             = skb;
> +       icmp_param.offset          = 0;
> +       icmp_param.data_len        = skb->len;
> +       icmp_param.head_len        = sizeof(struct icmphdr);
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
> -       return true;
> +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +               return true;
> +       /* We currently only support probing interfaces on the proxy node
> +        * Check to ensure L-bit is set
> +        */
> +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> +               return true;
> +       /* Clear status bits in reply message */
> +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
> +       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);

This requires that the packet holds a full sizeof(_iio) that is
capable of storing an ipv6 address regardless of the class_type. That
is not required by the spec, I assume.

If not requiring that, do have to do bounds checking for each
individual case, e.g., that an ifname fits in the packet if that may
be shorter than IFNAMSIZ.

> +       if (!ext_hdr || !iio)
> +               goto send_mal_query;
> +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
> +               goto send_mal_query;
> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);

As asked in v3: this can have negative overflow?

> +       status = 0;
> +       dev = NULL;
> +       switch (iio->extobj_hdr.class_type) {
> +       case EXT_ECHO_CTYPE_NAME:
> +               if (ident_len >= IFNAMSIZ)
> +                       goto send_mal_query;
> +               memset(buff, 0, sizeof(buff));
> +               memcpy(buff, &iio->ident.name, ident_len);
> +               dev = dev_get_by_name(net, buff);
> +               break;
> +       case EXT_ECHO_CTYPE_INDEX:
> +               if (ident_len != sizeof(iio->ident.ifindex))
> +                       goto send_mal_query;
> +               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> +               break;
> +       case EXT_ECHO_CTYPE_ADDR:
> +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                iio->ident.addr.ctype3_hdr.addrlen)
> +                       goto send_mal_query;
> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> +               case ICMP_AFI_IP:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                        sizeof(struct in_addr))
> +                               goto send_mal_query;
> +                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
> +                       break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +               case ICMP_AFI_IP6:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                        sizeof(struct in6_addr))
> +                               goto send_mal_query;
> +                       rcu_read_lock();
> +                       dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> +                       if (dev)
> +                               dev_hold(dev);
> +                       rcu_read_unlock();

This rcu read-size critical is not needed, because the entire receive
path is wrapped in such a section. See, for instance,
netif_receive_skb_core.

Either that, or the __in_dev_get_rcu and rcu_deference below would
require a similar critical section.
