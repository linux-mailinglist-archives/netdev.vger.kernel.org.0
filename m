Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549133B2292
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWVkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:40:20 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4357FC061756
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:38:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bg14so6160178ejb.9
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7A75PYQPstSkDln3oGCgNr/KN8kclBIpLJFx887/AY=;
        b=sr9nbxUhPH+vQ9Zpc+rGbSgbjV4pA4bsAjPRjyew7ZJCEeVwabMp6dloXltTRwNDvw
         F9td0m8Ue3IA0/aDatl+GJrPaJTGLxqfEUZ1cMPpOnqBJCemh+HbQbLyWVa+1BRUutWZ
         n/oNYcQU7SKbPdI8Mr2/2MS4ER+H4YcKRiPmQ/DNP24/Is6i42mqZJzvMstUgWJj9flx
         LNkCvSct2ir3aPpBU4I8o4kT1YlVNZXHo1vPtBwGRKbPPhJP6Va94Dw5rnQ8AWh6b6Ir
         h8mHLDy1im7Prwa6hRRxCWSIEMxe89mQfS7C4QvkGZsiXLGw2urYy8V7jA4zyW6/lfDO
         LqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7A75PYQPstSkDln3oGCgNr/KN8kclBIpLJFx887/AY=;
        b=ezrNT4kEtQDIqBvaENVixkYyQ6YDhHnL7c+l39sWcVq5OiVaiQCj317I5ROVYLLC4z
         LnRXIWWf1NImVXt+X4jwbG4kT1xh9laApI4+6iNZqVQjFlnNPN2JLsbskhNq0QCJjhyr
         qR4+DX7d79gmWGzbOTdsUH5H5Kz1Kb+5D5rLFWzWA1B2Y05b+8yfaHVka8RnxdgKo9VW
         IRBV4CrpdWKHqfatlE7d/Bb4Smle27F705IGyza8Oyzp8HvA6W8AouVM3jW3XX3IJLvg
         Dm3ygdHrgUFb/S9jgGgTbJ1jsEn987kvHfcIgBT6rge0lAFVdZF3A/Mbf8r4JFxAUXeF
         gLzQ==
X-Gm-Message-State: AOAM5328yu4tMIAhF4Pd5AD7WSPFORq6MLO+sqtO9fpvzL4rKifpao7l
        uGqo3+USMJU5TAPcXVtcvGAjU6s4y4Y=
X-Google-Smtp-Source: ABdhPJwFayZR5JmSltgbfm7rTYlBhHs29GSLuhEPA+WH9GqfVdSMutqcJLUgbzEFAoMJXaz2EksCNw==
X-Received: by 2002:a17:906:9a4f:: with SMTP id aj15mr1950827ejc.197.1624484279856;
        Wed, 23 Jun 2021 14:37:59 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id a1sm705715edt.16.2021.06.23.14.37.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:37:59 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso4884222wmg.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:37:58 -0700 (PDT)
X-Received: by 2002:a7b:c351:: with SMTP id l17mr154866wmj.120.1624484278321;
 Wed, 23 Jun 2021 14:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <7eb62f437120d8686f50811a2aebd7c0f7f73ced.1624358016.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <7eb62f437120d8686f50811a2aebd7c0f7f73ced.1624358016.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Jun 2021 17:37:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSethFwxSpqLhhdRMkQYnWcQ7YE6SDRQPza5Q72bZw3C3A@mail.gmail.com>
Message-ID: <CA+FuTSethFwxSpqLhhdRMkQYnWcQ7YE6SDRQPza5Q72bZw3C3A@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 11:39 AM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
> and adds functionality to respond to ICMPV6 PROBE requests.

How come this was missing from the original patch series that
introduced the same for IPv4? Did we miss that?

Anyway, makes sense to add to complete the feature.

> Add a sysctl to enable responses to PROBE messages, and as
> specified by section 8 of RFC 8335, the sysctl defaults to disabled.
>
> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
> icmpv6_echo_reply handler.
>
> Modify icmpv6_echo_reply to build a PROBE response message based on the
> queried interface.
>
> This patch has been tested using a branch of the iputils git repo which can
> be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |   6 ++
>  include/net/netns/ipv6.h               |   1 +
>  net/ipv6/icmp.c                        | 129 ++++++++++++++++++++++++-
>  3 files changed, 133 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index b0436d3a4f11..c4bf6e297b64 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2471,6 +2471,12 @@ echo_ignore_anycast - BOOLEAN
>
>         Default: 0
>
> +echo_ignore_all - BOOLEAN
> +        If set to one, then the kernel will respond to RFC 8335 PROBE
> +        requests sent to it over the IPv6 protocol.
> +
> +       Default: 0
> +

Copied wrong comment, this should be icmp_echo_enable_probe?

Or are you suggesting adding both? IPv4 has an echo_ignore_all while
IPv6 does not. But this feature does not require adding one? Unlike
the enable_probe toggle.

Also, perhaps no need for a separate ipv6 version of the existing ipv4 sysctl.

>         memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
> -       tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
> +       if (probe)
> +               tmp_hdr.icmp6_type = ICMPV6_EXT_ECHO_REPLY;
> +       else
> +               tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;

Instead of this block repeated three times, can do replace the boolean
probe variable with a type variable and pass that in all three cases
unconditionally.

> +       if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST &&
> +           net->ipv6.sysctl.icmpv6_echo_enable_probe)
> +               goto build_probe_reply;

Cannot be reached, as the sysctl is already tested earlier in this function?

> +send_reply:
>         if (ip6_append_data(sk, icmpv6_getfrag, &msg,
>                             skb->len + sizeof(struct icmp6hdr),
>                             sizeof(struct icmp6hdr), &ipc6, &fl6,
> @@ -806,6 +833,89 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>         icmpv6_xmit_unlock(sk);
>  out_bh_enable:
>         local_bh_enable();
> +       return;
> +build_probe_reply:
> +       /* We currently only support probing interfaces on the proxy node
> +        * Check to ensure L-bit is set
> +        */
> +       if (!(ntohs(icmph->icmp6_dataun.u_echo.sequence) & 1))
> +               goto out_dst_release;
> +       /* Clear status bits in reply message */
> +       tmp_hdr.icmp6_dataun.u_echo.sequence &= htons(0xFF00);
> +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
> +       /* Size of iio is class_type dependent.
> +        * Only check header here and assign length based on ctype in the switch statement
> +        */
> +       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr), &_iio);
> +       if (!ext_hdr || !iio)
> +               goto send_mal_query;
> +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
> +               goto send_mal_query;
> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> +       status = 0;
> +       dev = NULL;
> +       switch (iio->extobj_hdr.class_type) {
> +       case ICMP_EXT_ECHO_CTYPE_NAME:
> +               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> +               if (ident_len >= IFNAMSIZ)
> +                       goto send_mal_query;
> +               memset(buff, 0, sizeof(buff));
> +               memcpy(buff, &iio->ident.name, ident_len);
> +               dev = dev_get_by_name(net, buff);
> +               break;
> +       case ICMP_EXT_ECHO_CTYPE_INDEX:
> +               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +                                        sizeof(iio->ident.ifindex), &_iio);
> +               if (ident_len != sizeof(iio->ident.ifindex))
> +                       goto send_mal_query;
> +               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> +               break;
> +       case ICMP_EXT_ECHO_CTYPE_ADDR:
> +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                iio->ident.addr.ctype3_hdr.addrlen)
> +                       goto send_mal_query;
> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> +               case ICMP_AFI_IP:
> +                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +                                                sizeof(struct in_addr), &_iio);
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                        sizeof(struct in_addr))
> +                               goto send_mal_query;
> +                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
> +                       break;
> +               case ICMP_AFI_IP6:
> +                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +                                        sizeof(struct in6_addr))
> +                               goto send_mal_query;
> +                       dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> +                       if (dev)
> +                               dev_hold(dev);
> +                       break;
> +               default:
> +                       goto send_mal_query;
> +               }
> +               break;
> +       default:
> +               goto send_mal_query;
> +       }
> +       if (!dev) {
> +               tmp_hdr.icmp6_code = ICMP_EXT_CODE_NO_IF;
> +               goto send_reply;
> +       }
> +       /* Fill bits in reply message */
> +       if (dev->flags & IFF_UP)
> +               status |= ICMP_EXT_ECHOREPLY_ACTIVE;
> +       if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
> +               status |= ICMP_EXT_ECHOREPLY_IPV4;
> +       if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
> +               status |= ICMP_EXT_ECHOREPLY_IPV6;
> +       dev_put(dev);
> +       tmp_hdr.icmp6_dataun.u_echo.sequence |= htons(status);

This whole block is copied almost (?) verbatim from icmp_echo. Can we
avoid duplication?

> +       goto send_reply;
> +send_mal_query:
> +       tmp_hdr.icmp6_code = ICMP_EXT_CODE_MAL_QUERY;
> +       goto send_reply;
>  }
>
>  void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
> @@ -912,6 +1022,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
>                         icmpv6_echo_reply(skb);
>                 break;
>
> +       case ICMPV6_EXT_ECHO_REQUEST:
> +               if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
> +                       icmpv6_echo_reply(skb);


> +               break;
> +
>         case ICMPV6_ECHO_REPLY:
>                 success = ping_rcv(skb);
>                 break;
> @@ -1198,6 +1313,13 @@ static struct ctl_table ipv6_icmp_table_template[] = {
>                 .mode           = 0644,
>                 .proc_handler = proc_do_large_bitmap,
>         },
> +       {
> +               .procname       = "echo_enable_probe",
> +               .data           = &init_net.ipv6.sysctl.icmpv6_echo_enable_probe,
> +               .maxlen         = sizeof(u8),
> +               .mode           = 0644,
> +               .proc_handler = proc_dou8vec_minmax,

                .extra1         = SYSCTL_ZERO,
                .extra2         = SYSCTL_ONE
