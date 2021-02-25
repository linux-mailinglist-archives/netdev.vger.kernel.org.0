Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2632549E
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBYRkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhBYRkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:40:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08114C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 09:39:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mm21so9962829ejb.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 09:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mihD8r81aCYQW13FsvC3Ji1BeGcMeoivotLwR8x6ZWI=;
        b=p+dXu5ojrh4X8L7W4eq2pO5a/G+E6/oqOHV3KgBSrNdujACS+JbmAtD3MQ+rla+tJ+
         8gZz3nCtcuVSM908lwLWQC7E3M2CWB6uDALbiZTwdv66YiVXYdvJ9i5K/LTxYAdsKGFj
         xCcIuBUM8cRxzuudi/LUG/adjzfFZqoECLkoxSHk9iVm14FRpGMtE0M5EaYgL+rWDMVq
         wHAyzaU/TERQ2lt03aqzdcVf5HMTZ5ngccATbWRvHAsTQmhoh9/VG1TuoGBCMXsYg8aD
         j69B7/OF/qib7qiUloPSazHNdgf30F09BAzRWO/moKaAHHInoXgWIaHlK/pHjBD4aAXH
         kZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mihD8r81aCYQW13FsvC3Ji1BeGcMeoivotLwR8x6ZWI=;
        b=hmgNV1fBjYJAlal0Rk6p+clAtVIg7EQiPVw13jI1fMfxGhn9N5lPZmhdTJ36Z8NGB+
         cquwAsUOx/Cth7zSzJecnJyV86EGAar4g0N2NzLXIPapT33oFw7uykw3oVMO0VwPRMEt
         dxaeVKtO/FPAqX1KBuafGnCIZfJNZP3pwJN3UqPGcgHBCDjujTrDQbe9moV1W9gx41D0
         gNZhAZhPJdIMiz4FSU/E/XYiOXVzrs1LGKBbcKRkeVB/uHDkiO5FqC5tMuosDV2iThG2
         IxjvnQY1aEete+X+UyfuAs6B6jSfTsCXpxTV2KuAdcnmlrH8Z9TfaAT5bDLApMBM4E65
         R9cw==
X-Gm-Message-State: AOAM5335zjKd43H/+/uxCUsNIMubJdP19S6+x5l5RKdFQSNkF2AvSvOv
        VJVlktzrG7yrm5hzaCxEn8eEz/fh5Q8=
X-Google-Smtp-Source: ABdhPJy8aLaSlVsr0GPahlkGP1Omdbeko5CU+43TimkS+qCRc3u54mJfCfuUWQcNEQ7S02ggjG5/wg==
X-Received: by 2002:a17:906:2312:: with SMTP id l18mr1477664eja.468.1614274766419;
        Thu, 25 Feb 2021 09:39:26 -0800 (PST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id bx2sm1262797edb.80.2021.02.25.09.39.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 09:39:25 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id t15so6054393wrx.13
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 09:39:25 -0800 (PST)
X-Received: by 2002:a5d:6cab:: with SMTP id a11mr4609140wra.419.1614274764724;
 Thu, 25 Feb 2021 09:39:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
 <7bff18c2cffe77b2ea66fd8774a5d0374ff6dd97.1613583620.git.andreas.a.roeseler@gmail.com>
 <CA+FuTSeo5uqtU0b0AP5hm9C72qN8PdT4C-fV2YTun33YbX9Ssg@mail.gmail.com> <ba994c253956420744cbbf06f77af09b580a98d3.camel@gmail.com>
In-Reply-To: <ba994c253956420744cbbf06f77af09b580a98d3.camel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 25 Feb 2021 12:38:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe1KsAywsiW2+mib=C7e+AQi0cnynxEPeXzt7w79=msOg@mail.gmail.com>
Message-ID: <CA+FuTSe1KsAywsiW2+mib=C7e+AQi0cnynxEPeXzt7w79=msOg@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 6:21 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> On Sun, 2021-02-21 at 23:49 -0500, Willem de Bruijn wrote:
> On Wed, Feb 17, 2021 at 1:14 PM Andreas Roeseler
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
> > wireshark. It supports IPV4 probing by name, ifindex, and probing by
> > both IPV4 and IPV6
> > addresses. It currently does not support responding to probes off the
> > proxy node
> > (See RFC 8335 Section 2).
> >
> > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > ---
> > Changes since v1:
> >  - Reorder variable declarations to follow coding style
> >  - Switch to functions such as dev_get_by_name and ip_dev_find to
> > lookup
> >    net devices
> >
> > Changes since v2:
> > Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
> >  - Add verification of incoming messages before looking up netdev
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >  - Include net/addrconf.h library for ipv6_dev_find


> > +               if (!buff)
> > +                       return -ENOMEM;
> > +               memcpy(buff, &iio->ident.name, ident_len);
> > +               dev = dev_get_by_name(net, buff);
> > +               kfree(buff);
> > +               break;
> > +       case EXT_ECHO_CTYPE_INDEX:
> > +               if (ident_len != sizeof(iio->ident.ifIndex)) {
>
> this checks that length is 4B, but RFC says "If the Interface
> Identification Object identifies the probed interface by index, the
> length is equal to 8 and the payload contains the if-index"
>
> ident_len stores the value of the identifier of the interface only,
> i.e. it stores the length of the iio minus the length of the iio
> header. Therefore, we can check its size against the expected size of
> an if_Index (4 octets)

Great. Thanks for clarifying.

> > @@ -1096,7 +1200,6 @@ int icmp_rcv(struct sk_buff *skb)
> >         if (icmph->type > NR_ICMP_TYPES)
> >                 goto error;
> >
> > -
> >         /*
> >          *      Parse the ICMP message
> >          */
> > @@ -1123,6 +1226,7 @@ int icmp_rcv(struct sk_buff *skb)
> >
> >         success = icmp_pointers[icmph->type].handler(skb);
> >
> > +success_check:
> >         if (success)  {
> >                 consume_skb(skb);
> >                 return NET_RX_SUCCESS;
> > @@ -1136,6 +1240,13 @@ int icmp_rcv(struct sk_buff *skb)
> >  error:
> >         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
> >         goto drop;
> > +probe:
> > +       /*
> > +        * We can't use icmp_pointers[].handler() because the codes
> > for PROBE
> > +        *   messages are 42 or 160
> > +        */
>
> ICMPv6 message 160 (ICMPV6_EXT_ECHO_REQUEST) must be handled in
> icmpv6_rcv, not icmp_rcv. Then the ICMPv4 message 42 can be handled in
> the usual way.
>
>
> You are correct that we should handle ICMPV6_EXT_ECHO_REQUEST in the
> icmpv6.c file, but shouldn't we still have a special handler for the
> ICMPv4 message? The current icmp_pointers[].handler is an array of size
> NR_ICMP_TYPES + 1 (or 19 elements), so I don't think it would be a good
> idea to extend it to 42.

Interesting. So almost all numbers between NR_ICMP_TYPES (18) and 42
are deprecated:

  https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml

Eventually we might get more extensions after 42. So you can go either way.
The table is the clean approach. But I see the practical point of extending it
for one case, too. The current branch approach looks fine to me.
