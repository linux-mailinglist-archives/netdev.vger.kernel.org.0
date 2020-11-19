Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4E42B9B8D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKSTca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:32:30 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21322 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgKSTca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:32:30 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605814307; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=RwWZTdRp2JYmVeCCf0JlQ1CPgPJ9h2sfdrzWQ+JP3NhjekGg28hq6JLvBvT2X7fPs/itmFi1sloZeC0pdxk7AqJykFoWLyzsIIsppBId/X5sLwPGnn2cWRYBpWF6BVwCKf13wb4yR5JWhCVsqYapR5NP69gQovwKFvDkAbi7N4k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605814307; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WCR+XAW1Keq97IBhr7Nlm3GBjFFoJGs0nmFksqPSAX4=; 
        b=DH+OM/BrGvFQni1CVXj67BAv/AyZPhYo1SHOOaV41ckIVa8yBcBj9kp+PFy4aBLI183iYFk4PEueEy3Q+6cdfHkk39xT0UvjMeGGnz4eB9D44VBEiVDLZmUp32Q7Vf+fOuhGfHtMo/fDTimCOJc8amHIfr7JuqwVvXUwHSGLVrU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605814307;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=WCR+XAW1Keq97IBhr7Nlm3GBjFFoJGs0nmFksqPSAX4=;
        b=dwq3OrJLTCQ3gKtqZZWzz8aeL7qQs1M7x8mzxLFhIgzO6RqTcuw0g3taSCIt8WXi
        F9q2ne9jfdE3VfyvDsYTNTYI99ha0z3vnYzZL+of9eHrQ93tvKTfABuu7wgtuRMKOXF
        GGu3VTxutfnfq1fsyIfmW+b4RknTmOHp0gfQnhP0=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605814301266759.2664420513429; Thu, 19 Nov 2020 20:31:41 +0100 (CET)
Date:   Thu, 19 Nov 2020 20:31:41 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
In-Reply-To: <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net> <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next V6] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


---- On Thu, 19 Nov 2020 19:44:13 +0100 Jakub Kicinski <kuba@kernel.org> wr=
ote ----

 > On Thu, 19 Nov 2020 14:37:35 +0100 Dmytro Shytyi wrote:=20
 > > +struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *i=
fp,=20
 > > +                           struct inet6_dev *in6_dev,=20
 > > +                           struct net *net,=20
 > > +                           const struct prefix_info *pinfo)=20
 > > +{=20
 > > +    struct inet6_ifaddr *result_base =3D NULL;=20
 > > +    struct inet6_ifaddr *result =3D NULL;=20
 > > +    struct in6_addr curr_net_prfx;=20
 > > +    struct in6_addr net_prfx;=20
 > > +    bool prfxs_equal;=20
 > > +=20
 > > +    result_base =3D result;=20
 > > +    rcu_read_lock();=20
 > > +    list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {=20
 > > +        if (!net_eq(dev_net(ifp->idev->dev), net))=20
 > > +            continue;=20
 > > +        ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->prefi=
x_len);=20
 > > +        ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->pref=
ix_len);=20
 > > +        prfxs_equal =3D=20
 > > +            ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinfo->prefi=
x_len);=20
 > > +        if (prfxs_equal && pinfo->prefix_len =3D=3D ifp->prefix_len) =
{=20
 > > +            result =3D ifp;=20
 > > +            in6_ifa_hold(ifp);=20
 > > +            break;=20
 > > +        }=20
 > > +    }=20
 > > +    rcu_read_unlock();=20
 > > +    if (result_base !=3D result)=20
 > > +        ifp =3D result;=20
 > > +    else=20
 > > +        ifp =3D NULL;=20
 > > +=20
 > > +    return ifp;=20
 > > +}=20
 > =20
 > Thanks for adding the helper! Looks like it needs a touch up:=20
=20
Understood. Thank you for pointing this out. I think I did not catch this w=
arning as my Makefile didn't include "-Wmissing-prototypes"

 > net/ipv6/addrconf.c:2579:22: warning: no previous prototype for =E2=80=
=98ipv6_cmp_rcvd_prsnt_prfxs=E2=80=99 [-Wmissing-prototypes]=20
 >  2579 | struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifad=
dr *ifp,=20
 >  |                      ^~~~~~~~~~~~~~~~~~~~~~~~~=20
 > net/ipv6/addrconf.c:2579:21: warning: symbol 'ipv6_cmp_rcvd_prsnt_prfxs'=
 was not declared. Should it be static?=20
 >=20

Hideaki Yoshifuji helped to improve this patch with suggestions. @Hideaki, =
should I add "Reported-by" tag in this case?
Jakub Kicinski also helped to find errors and help with improvement. @Jakub=
, should I add "Reported-by" tag in this case?=20

Thanks,
Dmytro SHYTYI

