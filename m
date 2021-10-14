Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D707F42D15E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhJNEKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:10:02 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FF5C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:07:58 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r18so15121135wrg.6
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTVzJxAkjyR3NBT4j7rmrlqsPo96rithaisY7shIe4U=;
        b=fLsFSTmUpV71FjYD6tSEhoS/GZOL8cYM7BgdaNTGthGecvWe5y9hIcP4nb9Gy9+VHT
         uVfuk5m7no6klORjOZsoXui8SnrM/jb9FaEAfBX4UJmg9j6vOyc4RS1qPiAk0gw+EV70
         uAbVkp+YHBHZeAWtWThLaYc7vbUjTJTJpKoqIIaYvo/24edMtghjPT3jJ8pNdlEX/rEI
         FmCxdVaOAx4i9ED4a8QWfMqtnapR+VnlZtU1cCt7pyZw91p4CVg1NMLRoHM12AdY20Nc
         ZdtzkyNUodLDHZEZA3aXmNwF8DOULBNGIEtvEe1M0eaIfZ7PVqWpp6JqPAhKfpwDJUmZ
         cCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTVzJxAkjyR3NBT4j7rmrlqsPo96rithaisY7shIe4U=;
        b=NBD+Znx4JkpAPf0XAsVKolyWsZsWYrDiKuyFOvKlk/ggJO4oepovIEZJllegLvTS5Q
         ICA6zS/oUGxcklwWL1BZi+VoBKzA6J62sh/cxvBw5WmVgSbLK+/EmMaWN8osE02stCYg
         H3StKnKVkXi5qXh5RqyXAWHrXRl50FJVKNn+vGv8bjvFC8p7ztBl08m/A1xYIW4mgclj
         mfSvZJBUqifZFxfAQmmCotrdQDgSkZx33JWjP4irNZ4uoAnLVYe2FWVcKeTrcRBBlY6k
         7shHDllXmEG4t0CFxOYD7qOU8cne00T+Kb5G0iTSy3tvjBGAZNe+QSyfZfEPgDGN2/50
         KeBw==
X-Gm-Message-State: AOAM532NI7MV//On1TIbw8esBscEVWCyeIztd8juKeSLi4YSym/ufpBh
        Y0gBsI5tdQ6nY7HGW6BbDwLMN4iZkZuitkKMGxFDF+aSZf8=
X-Google-Smtp-Source: ABdhPJywVvun5pdmkmHaM73nMcBzvexCZddgtgupShU1xwIQRw4rf8M9VDGRA4vOq1Eoh2Xukftl/PfA4Ifh/GoPwZw=
X-Received: by 2002:a1c:4c19:: with SMTP id z25mr3371730wmf.4.1634184477197;
 Wed, 13 Oct 2021 21:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <61b6693f08f4f96f00cdeb2b8c78568e39f85029.1634028187.git.lucien.xin@gmail.com>
 <20211013093118.691255c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_eTAEE7dKK7gtxUfuJONHULF5GW+bZmAXM7V06LxKOB_w@mail.gmail.com> <CADvbK_eEhyF9sY6ia5B0yfRtfRHHwia3OfcdfE8fUnSjsATGXw@mail.gmail.com>
In-Reply-To: <CADvbK_eEhyF9sY6ia5B0yfRtfRHHwia3OfcdfE8fUnSjsATGXw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 14 Oct 2021 12:07:45 +0800
Message-ID: <CADvbK_fos6qA309JrEqK6LyUPidRhi1ZGSXTH4+G+a0=yc0EyQ@mail.gmail.com>
Subject: Re: [PATCH net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 11:59 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Oct 14, 2021 at 11:39 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Thu, Oct 14, 2021 at 12:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 12 Oct 2021 04:43:07 -0400 Xin Long wrote:
> > > > In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> > > > step by step and skb_header_pointer() return value should always be
> > > > checked, this patch fixes 3 places in there:
> > > >
> > > >   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
> > > >     from skb by skb_header_pointer(), its len is ident_len. Besides,
> > > >     the return value of skb_header_pointer() should always be checked.
> > > >
> > > >   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
> > > >     skb_header_pointer(), and also do the return value check for
> > > >     skb_header_pointer().
> > > >
> > > >   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
> > > >     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
> > > >     then check its return value and ident_len.
> > > >     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
> > > >     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
> > > >     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
> > > >     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
> > > >     sizeof(struct in_addr)" or "ident_len".
> > > >
> > > > Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >
> > > > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > > > index 8b30cadff708..818c79266c48 100644
> > > > --- a/net/ipv4/icmp.c
> > > > +++ b/net/ipv4/icmp.c
> > > > @@ -1061,38 +1061,48 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> > > >       dev = NULL;
> > > >       switch (iio->extobj_hdr.class_type) {
> > > >       case ICMP_EXT_ECHO_CTYPE_NAME:
> > > > -             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> > > >               if (ident_len >= IFNAMSIZ)
> > > >                       goto send_mal_query;
> > > > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > +                                      ident_len, &_iio);
> > > > +             if (!iio)
> > > > +                     goto send_mal_query;
> > > >               memset(buff, 0, sizeof(buff));
> > > >               memcpy(buff, &iio->ident.name, ident_len);
> > > >               dev = dev_get_by_name(net, buff);
> > > >               break;
> > > >       case ICMP_EXT_ECHO_CTYPE_INDEX:
> > > > -             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > -                                      sizeof(iio->ident.ifindex), &_iio);
> > > >               if (ident_len != sizeof(iio->ident.ifindex))
> > > >                       goto send_mal_query;
> > > > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > +                                      ident_len, &_iio);
> > > > +             if (!iio)
> > > > +                     goto send_mal_query;
> > > >               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> > > >               break;
> > > >       case ICMP_EXT_ECHO_CTYPE_ADDR:
> > > > -             if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > > -                              iio->ident.addr.ctype3_hdr.addrlen)
> > > > +             iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > +                                      sizeof(iio->ident.addr.ctype3_hdr), &_iio);
> > > > +             if (!iio || ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > > +                                      iio->ident.addr.ctype3_hdr.addrlen)
> > > >                       goto send_mal_query;
> > > >               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> > > >               case ICMP_AFI_IP:
> > > > +                     if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
> > > > +                             goto send_mal_query;
> > > >                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > -                                              sizeof(struct in_addr), &_iio);
> > > > -                     if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > > -                                      sizeof(struct in_addr))
> > > > +                                              ident_len, &_iio);
> > > > +                     if (!iio)
> > > >                               goto send_mal_query;
> > > >                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
> > > >                       break;
> > > >  #if IS_ENABLED(CONFIG_IPV6)
> > > >               case ICMP_AFI_IP6:
> > > > -                     iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> > > > -                     if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > > -                                      sizeof(struct in6_addr))
> > > > +                     if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
> > > > +                             goto send_mal_query;
> > > > +                     iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > > +                                              ident_len, &_iio);
> > > > +                     if (!iio)
> > > >                               goto send_mal_query;
> > > >                       dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> > > >                       dev_hold(dev);
> > >
> > > If I'm reading this right we end up with the same skb_header_pointer
> > > call 4 times, every path ends up calling:
> > >
> > >  skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) + ident_len, &_iio);
> > >
> > > and looks like the skb does not get modified in between so these calls
> > > are equivalent.
> > This looks much clearer.
> >
> > I was worrying that ident_len might be too big, and ident_len should be verified
> > before calling skb_header_pointer(ident_len).
> > But it should be okay as skb_header_pointer() will return NULL if ident_len is
> > too big.
> >
> > Will post v2 with the suggestion, thanks!
> >
> > >
> > > So why don't we instead consolidate the paths:
> > >
> > > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > > index 8b30cadff708..efa2ec1a85bf 100644
> > > --- a/net/ipv4/icmp.c
> > > +++ b/net/ipv4/icmp.c
> > > @@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> > >         if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
> > >                 goto send_mal_query;
> > >         ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> > > +       iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> > > +                                sizeof(iio->extobj_hdr) + ident_len, &_iio);
> > > +       if (!iio)
> > > +               goto send_mal_query;
> > > +
> [a]
>
> > >         status = 0;
> > >         dev = NULL;
> > >         switch (iio->extobj_hdr.class_type) {
> > >         case ICMP_EXT_ECHO_CTYPE_NAME:
> > > -               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> > >                 if (ident_len >= IFNAMSIZ)
> > >                         goto send_mal_query;
> > >                 memset(buff, 0, sizeof(buff));
> > > @@ -1069,8 +1073,6 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> > >                 dev = dev_get_by_name(net, buff);
> > >                 break;
> > >         case ICMP_EXT_ECHO_CTYPE_INDEX:
> > > -               iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > -                                        sizeof(iio->ident.ifindex), &_iio);
> > >                 if (ident_len != sizeof(iio->ident.ifindex))
> > >                         goto send_mal_query;
> > >                 dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> > > @@ -1081,18 +1083,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> > >                         goto send_mal_query;
> But, here is another check:
>                 if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
>                                  iio->ident.addr.ctype3_hdr.addrlen)
>                         goto send_mal_query;
>
> Thinking if ident_len < sizeof(iio->ident.addr.ctype3_hdr),
> iio->ident.addr.ctype3_hdr.addrlen
> access could be overflow. So we may do: if (ident_len <
> sizeof(iio->ident.addr.ctype3_hdr)) check
> before calling skb_header_pointer() in the place [a] above, like:
>
>         ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
>         if (ident_len < 4) /* 4 is the minimal size for any class_type */
>                 goto send_mal_query;
>         iio = skb_header_pointer(skb, sizeof(_ext_hdr),
>                                  sizeof(iio->extobj_hdr) + ident_len, &_iio);
>         if (!iio)
>                 goto send_mal_query;
>
> what do you think?
Sorry, seems doing the check,

        case ICMP_EXT_ECHO_CTYPE_ADDR:
-               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+               if (ident_len < sizeof(iio->ident.addr.ctype3_hdr) ||
+                   ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
                                 iio->ident.addr.ctype3_hdr.addrlen)
                        goto send_mal_query;

right here makes more sense.

>
> > >                 switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> > >                 case ICMP_AFI_IP:
> > > -                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> > > -                                                sizeof(struct in_addr), &_iio);
> > > -                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > -                                        sizeof(struct in_addr))
> > > +                       if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
> > >                                 goto send_mal_query;
> > >                         dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
> > >                         break;
> > >  #if IS_ENABLED(CONFIG_IPV6)
> > >                 case ICMP_AFI_IP6:
> > > -                       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> > > -                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> > > -                                        sizeof(struct in6_addr))
> > > +                       if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
> > >                                 goto send_mal_query;
> > >                         dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> > >                         dev_hold(dev);
> > > --
> > > 2.31.1
> > >
