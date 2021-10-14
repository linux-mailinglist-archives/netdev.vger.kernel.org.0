Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C690742D11B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJNDle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhJNDle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:41:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF10DC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 20:39:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k7so14812937wrd.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 20:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HwmcCJMA/6tt4pHzmLQuSpglxm3BHvKb5wCcGMtEE3o=;
        b=UlBiG6ymzlDRQbGZjo/XDh+1dawJtnPKcbEDfQ4IjEVG+2QlkaJif/Xn5mdBWS1DE8
         Ot/hsP7iDQOUxEInYdT83U38+/cogJgwF7dNVEciL312Ihg/DB7EAlFrH2ByG1mQ6AEo
         LcTgmA/iKloF/gKgoKdRBCzQEa04Zu6r02OsyLEHYrj5WoFSslbY3scBPvpuBmmShq8q
         B/Mnvpz/ffafPRO88DMxqVioW3QcxqojIvdqZPkZQbxNXAf4cjgo5DTpZhLd+j3fm7dJ
         uf4gQ+Ccp+6Hf1/DQPjKKj8S/TEPH5Rjiyhr6Qr971FONebUZhjLaQmkYSnRVbpZdOua
         kKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HwmcCJMA/6tt4pHzmLQuSpglxm3BHvKb5wCcGMtEE3o=;
        b=aGCueKK34ifgbrdiW4HLAKFj5bqJiYNbDsEpO0eJW+rH0o6CUlfCe82hALQJhHyEXs
         JHyLZXa8u+2uWrUdPi4Cw0FryhcbJw3c1j+RMZqxmIIbK23/67hwvBzOC+Z6vw6b2hvL
         2XJPfmvZm6Zx3OLyXSCKufCjpORKrPxNEoKcCjS9xlwwAEHwzjbTOhLvtMPY5AukKbwF
         k7O8/nrdyZRzZHBjYnhtZ3wr9+/fFqZYEJPIO2I9XxmqyVBzqoUCrVmExE8SueCyxq4R
         Seq1oLZPM/PqJaNGoGF1PfhlK0xCNcSa/tvKJxow4Y9UJPZKXKt3wH0gvKUjtODByJwj
         ltXg==
X-Gm-Message-State: AOAM530EIySkcnMSgPEBYk6NakM/BqWa91pFc0681KHKTVDHRclNmjY1
        A8B0hKtNlG9yRUH3UA93w6HPAplfdepQawY0u9o=
X-Google-Smtp-Source: ABdhPJyePJ9xaR0JZOSaALE3Wdow/dnYnUgLEsYgDpSA+ERd7PVBmSHrenFYG60UQRdTasgCr7aFjvjJZKy4MPFnIz8=
X-Received: by 2002:a1c:1f06:: with SMTP id f6mr3312638wmf.8.1634182768428;
 Wed, 13 Oct 2021 20:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <61b6693f08f4f96f00cdeb2b8c78568e39f85029.1634028187.git.lucien.xin@gmail.com>
 <20211013093118.691255c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013093118.691255c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 14 Oct 2021 11:39:16 +0800
Message-ID: <CADvbK_eTAEE7dKK7gtxUfuJONHULF5GW+bZmAXM7V06LxKOB_w@mail.gmail.com>
Subject: Re: [PATCH net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 12 Oct 2021 04:43:07 -0400 Xin Long wrote:
> > In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> > step by step and skb_header_pointer() return value should always be
> > checked, this patch fixes 3 places in there:
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
> >     from skb by skb_header_pointer(), its len is ident_len. Besides,
> >     the return value of skb_header_pointer() should always be checked.
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
> >     skb_header_pointer(), and also do the return value check for
> >     skb_header_pointer().
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
> >     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
> >     then check its return value and ident_len.
> >     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
> >     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
> >     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
> >     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
> >     sizeof(struct in_addr)" or "ident_len".
> >
> > Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > index 8b30cadff708..818c79266c48 100644
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -1061,38 +1061,48 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> >       dev = NULL;
> >       switch (iio->extobj_hdr.class_type) {
> >       case ICMP_EXT_ECHO_CTYPE_NAME:
> > -             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> >               if (ident_len >= IFNAMSIZ)
> >                       goto send_mal_query;
> > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > +                                      ident_len, &_iio);
> > +             if (!iio)
> > +                     goto send_mal_query;
> >               memset(buff, 0, sizeof(buff));
> >               memcpy(buff, &iio->ident.name, ident_len);
> >               dev = dev_get_by_name(net, buff);
> >               break;
> >       case ICMP_EXT_ECHO_CTYPE_INDEX:
> > -             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > -                                      sizeof(iio->ident.ifindex), &_iio);
> >               if (ident_len != sizeof(iio->ident.ifindex))
> >                       goto send_mal_query;
> > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > +                                      ident_len, &_iio);
> > +             if (!iio)
> > +                     goto send_mal_query;
> >               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> >               break;
> >       case ICMP_EXT_ECHO_CTYPE_ADDR:
> > -             if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > -                              iio->ident.addr.ctype3_hdr.addrlen)
> > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > +                                      sizeof(iio->ident.addr.ctype3_hdr), &_iio);
> > +             if (!iio || ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > +                                      iio->ident.addr.ctype3_hdr.addrlen)
> >                       goto send_mal_query;
> >               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> >               case ICMP_AFI_IP:
> > +                     if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
> > +                             goto send_mal_query;
> >                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > -                                              sizeof(struct in_addr), &_iio);
> > -                     if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > -                                      sizeof(struct in_addr))
> > +                                              ident_len, &_iio);
> > +                     if (!iio)
> >                               goto send_mal_query;
> >                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
> >                       break;
> >  #if IS_ENABLED(CONFIG_IPV6)
> >               case ICMP_AFI_IP6:
> > -                     iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> > -                     if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > -                                      sizeof(struct in6_addr))
> > +                     if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
> > +                             goto send_mal_query;
> > +                     iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > +                                              ident_len, &_iio);
> > +                     if (!iio)
> >                               goto send_mal_query;
> >                       dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> >                       dev_hold(dev);
>
> If I'm reading this right we end up with the same skb_header_pointer
> call 4 times, every path ends up calling:
>
>  skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) + ident_len, &_iio);
>
> and looks like the skb does not get modified in between so these calls
> are equivalent.
This looks much clearer.

I was worrying that ident_len might be too big, and ident_len should be verified
before calling skb_header_pointer(ident_len).
But it should be okay as skb_header_pointer() will return NULL if ident_len is
too big.

Will post v2 with the suggestion, thanks!

>
> So why don't we instead consolidate the paths:
>
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 8b30cadff708..efa2ec1a85bf 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
>         if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
>                 goto send_mal_query;
>         ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> +       iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> +                                sizeof(iio->extobj_hdr) + ident_len, &_iio);
> +       if (!iio)
> +               goto send_mal_query;
> +
>         status = 0;
>         dev = NULL;
>         switch (iio->extobj_hdr.class_type) {
>         case ICMP_EXT_ECHO_CTYPE_NAME:
> -               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
>                 if (ident_len >= IFNAMSIZ)
>                         goto send_mal_query;
>                 memset(buff, 0, sizeof(buff));
> @@ -1069,8 +1073,6 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
>                 dev = dev_get_by_name(net, buff);
>                 break;
>         case ICMP_EXT_ECHO_CTYPE_INDEX:
> -               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> -                                        sizeof(iio->ident.ifindex), &_iio);
>                 if (ident_len != sizeof(iio->ident.ifindex))
>                         goto send_mal_query;
>                 dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> @@ -1081,18 +1083,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
>                         goto send_mal_query;
>                 switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
>                 case ICMP_AFI_IP:
> -                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> -                                                sizeof(struct in_addr), &_iio);
> -                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> -                                        sizeof(struct in_addr))
> +                       if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
>                                 goto send_mal_query;
>                         dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
>                         break;
>  #if IS_ENABLED(CONFIG_IPV6)
>                 case ICMP_AFI_IP6:
> -                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> -                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> -                                        sizeof(struct in6_addr))
> +                       if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
>                                 goto send_mal_query;
>                         dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
>                         dev_hold(dev);
> --
> 2.31.1
>
