Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12EE35D17C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbhDLTxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbhDLTxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:53:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5462C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:53:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id e14so22235552ejz.11
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytdkbaL73lFIN3mq5XNXeHjVCdg3/x5SiQzakslnlq8=;
        b=uetVgCoE+DgHhYwixTxmRwHyfXkqF6ZPzX7wrPfKSTH8tsJ0y5mGy7srKwa447gLns
         4MujFavn3GK9g1vnZ/5nOQ2yr1vpawjmIGNnX9en2UJovArhVvrGE4P0KFCpLkMQLFug
         J2qvBoo5Bpxo/VeaivJRdrZY2N0hF1K3rQvjWG7R+Rt7R53EhlCfhx671LudopAhenkC
         Sxv5jIYghdlBL1xjnYiubtVP6a1BB1x+LgQG8dyl3d5miMEISIfLPR0KhGMkO1937w0/
         X32v8e63d3Ds1Rs2SfEV9pIYaFGiS3Ue2IjMzcJcfGo8J9KlCxNbjXrJ/3AFlp7YRQW8
         Uc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytdkbaL73lFIN3mq5XNXeHjVCdg3/x5SiQzakslnlq8=;
        b=qTPr5IupgcYw/aP9TYwylNC4mxK9Z9Ctmfu4pYopWJx+eDtqHboHe7Wkv3N6nvZSoe
         AlnOvlhqwZWwVAgWGbgzs4Wlpn3Z16q0IR4qiiS1ARvQbJdj0q7YKbhzCgw71cKf7QVC
         LSFEbmAOFFtUa6TF2qf/FGBnBbDf0DiLkB4wlkFwdm1p2IQo8Xk0xy3HmivlDBdnkMk9
         sKuERTj9UDngAKYB1XqlKyjkF7rq1LNa6VXmuzaUyQJmaYtFUKbVBD6aJP+mF4IEok+3
         g9L1A1xEUUZ1QfozkD/1+O6GXQu7c0vAPFlfuplNueoQnhpTjyU7FPC7ENF8ojuBkd8V
         OiNg==
X-Gm-Message-State: AOAM533o0LGFEIFBcwrzzEelG/Z+OYeP4cTWCAnMi50jqubn/O6FNbxi
        Vj0uPlkbAEtXx+GzoOJTcw07mZKGSsv+wA==
X-Google-Smtp-Source: ABdhPJzTsjA1vdlGfbI0Z6UHzesszEMWZGzrd7E5UYOmV7h1RZD3W/0RjpzlUbnQJbZJAhlJlStdQA==
X-Received: by 2002:a17:907:2662:: with SMTP id ci2mr1506910ejc.467.1618257182192;
        Mon, 12 Apr 2021 12:53:02 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id kj24sm742374ejc.49.2021.04.12.12.53.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:53:01 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso9358237wmq.1
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 12:53:00 -0700 (PDT)
X-Received: by 2002:a1c:2941:: with SMTP id p62mr680690wmp.120.1618257179874;
 Mon, 12 Apr 2021 12:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210412190845.4406-1-andreas.a.roeseler@gmail.com>
 <CA+FuTSdMpMm9nwFP2u7KDeNUfXXfmQBGMmPfE-MBJTrGs-8stA@mail.gmail.com> <f969d15083f8f7b7ba9ef001505ad2e16b0c2fdd.camel@gmail.com>
In-Reply-To: <f969d15083f8f7b7ba9ef001505ad2e16b0c2fdd.camel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 12 Apr 2021 15:52:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe8at268+yqcxS-srCiMoovYCnBr56o9C52n3HWzkqZhw@mail.gmail.com>
Message-ID: <CA+FuTSe8at268+yqcxS-srCiMoovYCnBr56o9C52n3HWzkqZhw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: pass RFC 8335 reply messages to ping_rcv
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 3:41 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> On Mon, 2021-04-12 at 15:28 -0400, Willem de Bruijn wrote:
> > On Mon, Apr 12, 2021 at 3:09 PM Andreas Roeseler
> > <andreas.a.roeseler@gmail.com> wrote:
> > >
> > > The current icmp_rcv function drops all unknown ICMP types,
> > > including
> > > ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply
> > > messages, we have
> > > to pass these packets to the ping_rcv function, which does not do
> > > any
> > > other filtering and passes the packet to the designated socket.
> > >
> > > Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the
> > > ping_rcv
> > > handler instead of discarding the packet.
> > >
> > > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > > ---
> > >  net/ipv4/icmp.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > > index 76990e13a2f9..8bd988fbcb31 100644
> > > --- a/net/ipv4/icmp.c
> > > +++ b/net/ipv4/icmp.c
> > > @@ -1196,6 +1196,11 @@ int icmp_rcv(struct sk_buff *skb)
> > >                 goto success_check;
> > >         }
> > >
> > > +       if (icmph->type == ICMP_EXT_ECHOREPLY) {
> > > +               success = ping_rcv(skb);
> > > +               goto success_check;
> > > +       }
> > > +
> >
> > Do you need the same for ICMPV6_EXT_ECHO_REPLY ?
>
> Yes, but this should be handled in icmpv6_rcv in net/ipv6/icmp.c and
> we're thinking of including all icmpv6 support for RFC 8335 (replying
> and parsing replies) in a separate patch.

Please send them together in the same patchset.

Sending ipv4 and ipv6 separately can lead to missing or subtly
differently implemented features. It's preferable to be able to review
both at the same time.
