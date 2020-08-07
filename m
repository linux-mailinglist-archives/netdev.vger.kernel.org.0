Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9F23EA51
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgHGJ0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgHGJ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:26:19 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC03DC061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 02:26:18 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q75so1264087iod.1
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YmwBZHu96k734pkgaSori9Me7crrhXz7Nayey0uT6m0=;
        b=rs1Bfu9nD1QxRHCA0LV+9+gcpcltg087KlRg8nFBXG2+bSDDu+MlgV17Ms84atGy1G
         Y3WP+QM78nnD3onhBTbg8wP/Kw8qjrYqR3iHLsqnvpn78t1dgohLVVtA7XinNUwlwMR3
         oNJrb0125ttAgOmy9JKYoPVe2IMsORq8NDRlUVzTIJs4KqmxMaa/W3Gb+MwA6Cy4js3/
         bMksqf7eMhyYgGMUd3UGKvsYa8Q8U0e6GVJxxZR276MElr2EAOFZAr2g7Nx5gH56cnxq
         9c7lV6tYPKjREP0iDbILX0H9DFXt+pvx0KNHIPZ/fopXxTibWiNkZs3pgH0JfmS59Lh9
         mdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YmwBZHu96k734pkgaSori9Me7crrhXz7Nayey0uT6m0=;
        b=RGfqt60FkGbj+cU1KB19SHzwhE0mEZ9S59qze8za+Tqvfnk+brviTjv4ypqKyJEWgL
         eD+H5cYk0zyU4B8S+xO8qPootkTw6kOkUszOEmHgg6vUFzng+uyFUB48p5uikc2ulCya
         ew3p8FUYo43cOa+ak4GFEbWWiuxXiOyHhyjpsaavKuvTfxmjCt4/ctsUXTGWHWuDHCzx
         QFrALJvzDmLV6Z90DZQydWv7LTbEaWX8Nu8epzfzWgnc/5wmiIlQx7oIV92rzJcPL2er
         btNYEsJArHak3JM55Jun3ioQrjQ5ExGV+EUK6RquMw0sfSXFya4pCQhAAkcWr/5TqMJp
         nl/Q==
X-Gm-Message-State: AOAM532xA7Vlj2NfvcGUnElp6hpaN/ARkeeElZQLfjJH0fxs6MBlmgo7
        qOrkriowTJu1xSd/utOF5bdkuHt+NiE0n4laJ1ceJQ==
X-Google-Smtp-Source: ABdhPJwPinl0nxm69uud/aSZ0ZrX7+T5AEz9pu2s0ulXplxeyE1Bk7gt8P/rt/pr8KSn4UsKhj7N2FoP6GT8Lo3/cJU=
X-Received: by 2002:a05:6638:1690:: with SMTP id f16mr3785589jat.91.1596792378138;
 Fri, 07 Aug 2020 02:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com> <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com>
In-Reply-To: <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Fri, 7 Aug 2020 18:25:20 +0900
Message-ID: <CAPA1RqAFkQG-LBTcj80nt4CbWnE7ni+wgCBJU3-up7ROoR9-3w@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     David Ahern <dsahern@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B48=E6=9C=886=E6=97=A5(=E6=9C=A8) 23:03 David Ahern <dsahern@gma=
il.com>:
>
> On 8/6/20 2:55 AM, Xin Long wrote:
> > On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> > <hideaki.yoshifuji@miraclelinux.com> wrote:
> >>
> >> Hi,
> >>
> >> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien.xin=
@gmail.com>:
> >>>
> >>> This is to add an ip_dev_find like function for ipv6, used to find
> >>> the dev by saddr.
> >>>
> >>> It will be used by TIPC protocol. So also export it.
> >>>
> >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>> ---
> >>>  include/net/addrconf.h |  2 ++
> >>>  net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
> >>>  2 files changed, 41 insertions(+)
> >>>
> >>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> >>> index 8418b7d..ba3f6c15 100644
> >>> --- a/include/net/addrconf.h
> >>> +++ b/include/net/addrconf.h
> >>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *=
addr,
> >>>
> >>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *=
dev);
> >>>
> >>> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_a=
ddr *addr);
> >>> +
> >>
> >> How do we handle link-local addresses?
> > This is what "if (!result)" branch meant to do:
> >
> > +       if (!result) {
> > +               struct rt6_info *rt;
> > +
> > +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> > +               if (rt) {
> > +                       dev =3D rt->dst.dev;
> > +                       ip6_rt_put(rt);
> > +               }
> > +       } else {
> > +               dev =3D result->idev->dev;
> > +       }
> >
>
> the stated purpose of this function is to find the netdevice to which an
> address is attached. A route lookup should not be needed. Walking the
> address hash list finds the address and hence the netdev or it does not.
>
>

User supplied scope id which should be set for link-local addresses
in TIPC_NLA_UDP_LOCAL attribute must be honored when we
check the address.

ipv6_chk_addr() can check if the address and supplied ifindex is a valid
local address.  Or introduce an extra ifindex argument to ipv6_dev_find().

--yoshfuji
