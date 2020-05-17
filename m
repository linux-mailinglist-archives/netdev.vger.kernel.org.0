Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643CF1D6B68
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgEQR1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgEQR1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 13:27:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD757C061A0C;
        Sun, 17 May 2020 10:27:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d7so6313874eja.7;
        Sun, 17 May 2020 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrODtRB0VLzrBc0RiUggWA8TbcBvamughhphUXIIDnI=;
        b=OWcozBcrckvqmx+/XIfmse8QLxEeqmaWyCOO/jKLQLj2TDXXN5IjwpwhtWPEpKu5m3
         lQY52URCBLhpuUfdfIGaIpaQDVF4zFJCqR0PTg4iiKzQ0+Kx0gG08Hi+kd3h/pijJ6tf
         Np05CwEE8luF6DnxGe8VnCkd2Lh9cCWujTZ4Gz5N2DTXxbUe8oUH5992ti5GaiBTAHkT
         9s5Bec0nurKDvb2cn6JggXx5PjrE/DxC8I4J0iUu+cq9JuyDumAlTfwajMgJWcRX1RF0
         Noca6ySUEHVbe04JrXZwJI4+yCVfaZS0UJFeVGnTOK2HB8RDsmAwS2ldA7Qu5HV7oITV
         fabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrODtRB0VLzrBc0RiUggWA8TbcBvamughhphUXIIDnI=;
        b=j9yxwUmZh1/1pmYtC4ZHIEUb7GZD6w1JT9aseV2AHz9EkbSOiQz5sopuIBIxj9CO0r
         h87egjZaba6jmbFmmlJsf2FidRSo3KzXR+J7TkAD6M/sqa3kL1O8dqDIMgbDbb/HTKP0
         tGtN4elWxJVjp61lPYnETacr8fB/3F5EFyfSVTWKTnAlXAz3lNST4wzfmcC72U3HgIlS
         eziKko2LW+k8p5I1eDvC1U5CEyLwE4dMluKs/FphXCIZQFSAken1UlP/4tL6qes6fLLW
         InsyQSCyztnZI/eAfN0IXcPX4FXea4XepMtRjtpmuFqkoUtkAifj/F5/2GuOCRd0656w
         0AzA==
X-Gm-Message-State: AOAM532kqBO5azVYu5T7lBfobNG0Q4xqasSm4/9EV2lPd9Khw6UQauwt
        s1g/9BMWw/jTIHQVC09ElU/nVKfsxNoI+g/kGnY=
X-Google-Smtp-Source: ABdhPJwWHN0CABb2lA8LG/MSvk2r7IdvC3Y1JevSk4pFpxDUpN3q1KLVeCkKlTTl9oMdIZZrnKHaKLUD5WupPI0iOKc=
X-Received: by 2002:a17:907:39b:: with SMTP id ss27mr9661079ejb.209.1589736438146;
 Sun, 17 May 2020 10:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200515013556.5582-1-kim.andrewsy@gmail.com> <alpine.LFD.2.21.2005152044380.3860@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.21.2005152044380.3860@ja.home.ssi.bg>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Sun, 17 May 2020 13:27:06 -0400
Message-ID: <CABc050G5HRaTNp1r0P7HahAUu+RA_Gk2XZBbjDWQsQ40O4VGyw@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: expire no destination UDP connections
 when expire_nodest_conn=1
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

Thanks for getting back to me, that makes sense.

Would you be opposed to trying to expire all UDP connections matching
a deleted destination only if expire_nodest_conn=1?
Even today with `expire_nodest_conn=1`, many packets could be dropped
if there are many requests from a single client
trying to reuse client ports matching a deleted destination. Setting
`expire_nodest_conn=1` and reducing the UDP timeout
helps but deleting all connections when the destination is deleted
seems more efficient.

Looking forward to hearing your thoughts,

Andrew Sy Kim


On Fri, May 15, 2020 at 2:07 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Thu, 14 May 2020, Andrew Sy Kim wrote:
>
> > When expire_nodest_conn=1 and an IPVS destination is deleted, IPVS
> > doesn't expire connections with the IP_VS_CONN_F_ONE_PACKET flag set (any
> > UDP connection). If there are many UDP packets to a virtual server from a
> > single client and a destination is deleted, many packets are silently
> > dropped whenever an existing connection entry with the same source port
> > exists. This patch ensures IPVS also expires UDP connections when a
> > packet matches an existing connection with no destinations.
> >
> > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > ---
> >  net/netfilter/ipvs/ip_vs_core.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index aa6a603a2425..f0535586fe75 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -2116,8 +2116,7 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> >               else
> >                       ip_vs_conn_put(cp);
>
>         Above ip_vs_conn_put() should free the ONE_PACKET
> connections because:
>
> - such connections never start timer, they are designed
> to exist just to schedule the packet, then they are released.
> - noone takes extra references
>
>         So, ip_vs_conn_put() simply calls ip_vs_conn_expire()
> where connections should be released immediately. As result,
> we can not access cp after this point here. That is why we work
> just with 'flags' below...
>
>         Note that not every UDP connection has ONE_PACKET
> flag, it is present if you configure it for the service.
> Do you have -o/--ops flag? If not, the UDP connection
> should expire before the next jiffie. This is the theory,
> in practice, you may observe some problem...
>
> > -             if (sysctl_expire_nodest_conn(ipvs) &&
> > -                 !(flags & IP_VS_CONN_F_ONE_PACKET)) {
> > +             if (sysctl_expire_nodest_conn(ipvs)) {
> >                       /* try to expire the connection immediately */
> >                       ip_vs_conn_expire_now(cp);
> >               }
>
>         You can also look at the discussion which resulted in
> the last patch for this place:
>
> http://archive.linuxvirtualserver.org/html/lvs-devel/2018-07/msg00014.html
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
