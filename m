Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493E82B1B3F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKMMin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgKMMim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:38:42 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0DDC0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:38:42 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id y17so8348722ilg.4
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JZ87/R2nr7BDJywDkG4VTTNvSyQnQEx9n5aSWV3oeOQ=;
        b=DjjBMxKekjCqU3EXk5TpmsK9ZBs+J3FGVclsSRxYdCcdY4MuGtwrA4oLfzEYSrw9mI
         R2duZ7E0h5bhfH+FdFjfPCiGLk0fmDgK0veTbB4hqCdjO7hS+VwiCyy6eAtVN5GeIb1v
         pmv6FPlWvRj3RHI2Q/9hRv7l4qeCg21iR0h3P95AE8ViU9hh9t8d8CXSO0UTJSisaSfM
         D7EaHH9UoDOfP/cna/xZTwFIlL6rxIg2SzPJgT0evmNilMtiDDqnxz8UIjpQ4bG0dnOU
         F3+cTyJhXop7sF3lSV5yZEHj6acFM9rdDA48v356asioQ/hCjsxtxj9xAhPq1U4W7ZBa
         EXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JZ87/R2nr7BDJywDkG4VTTNvSyQnQEx9n5aSWV3oeOQ=;
        b=AsCHBwRfvmRh1sQ9H+d5HI+ag/nZjxchfYY400+utsoi75vA/OReaQpGymjxrs6TY0
         CYXVCTP7AnYE8dwHpgJDAfKiMp2kgOeh9W1IKeYb0jsmJXj8Eu5yYgNpOCK7MJmZ+5D8
         k8cI9O16CXDhNLdq5ObfDu9uE9NiCDTVFKUR5QO6zxN0zoaZeBLWwfHK4GZqC0Vx2KgY
         n51PHaHWZmsxUZX7egWzoU0JsU6W+qGeaZoMAytaBbYz+9LLcgNfoxkHOPNH9L7WRLIJ
         QKhNO2oQ1wGZNrK600wFqYzMVzgUx9QxUe622SeG/Xzb4LkevtbD7J9dhzLW9l5l3TEW
         rZVA==
X-Gm-Message-State: AOAM531Em3YqeBx6ZPfKM/S+YUVXsvnUx1ACv0Ry9yNXMA0xe0LvrRzS
        XyW7aSilEFrWqoH6O/WN+/KlVqR/47XXKa0LXePhi4b2W6Q=
X-Google-Smtp-Source: ABdhPJwmLug/Wjulsu/3sEdFIudr0S/dzoOiZ4Njn/Mvj6bSrMrI+NxcF+DSPtZmE/mZ0br2W0c8KhEs+9CJmYyrEsc=
X-Received: by 2002:a05:6e02:ce:: with SMTP id r14mr1778186ilq.240.1605271121632;
 Fri, 13 Nov 2020 04:38:41 -0800 (PST)
MIME-Version: 1.0
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
In-Reply-To: <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Fri, 13 Nov 2020 21:38:02 +0900
Message-ID: <CAPA1RqC+wgi+fQ4A3GiwnLpGZ=5PfDF7kZUKkoYyXA2FN+4oyw@mail.gmail.com>
Subject: Re: [PATCH net-next V4] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     kuba <kuba@kernel.org>, kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B411=E6=9C=8813=E6=97=A5(=E9=87=91) 10:57 Dmytro Shytyi <dmytro@=
shytyi.net>:
>
> Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (randomly
> generated hostID or stable privacy + privacy extensions).
> The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
> carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
> SLAAC is required so that downstream interfaces can be further subnetted.
> Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
> assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to
> Load-Balancer and /72 to wired connected devices.
> IETF document that defines problem statement:
> draft-mishra-v6ops-variable-slaac-problem-stmt
> IETF document that specifies variable slaac:
> draft-mishra-6man-variable-slaac
>
> Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
> ---
> diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-5.10.0-=
rc2/net/ipv6/addrconf.c
> --- net-next-5.10.0-rc2/net/ipv6/addrconf.c     2020-11-10 08:46:01.07519=
3379 +0100
> +++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c       2020-11-13 02:30:=
25.552724864 +0100
> @@ -1315,10 +1322,14 @@ static int ipv6_create_tempaddr(struct i
>         struct ifa6_config cfg;
>         long max_desync_factor;
>         struct in6_addr addr;
> -       int ret =3D 0;
> +       int ret;
> +       struct in6_addr net_mask;
> +       struct in6_addr temp;
> +       struct in6_addr ipv6addr;
> +       int i;
>
>         write_lock_bh(&idev->lock);
> -
> +       ret =3D 0;
>  retry:
>         in6_dev_hold(idev);
>         if (idev->cnf.use_tempaddr <=3D 0) {
> @@ -1340,9 +1351,26 @@ retry:
>                 goto out;
>         }
>         in6_ifa_hold(ifp);
> -       memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
> -       ipv6_gen_rnd_iid(&addr);
>
> +       if (ifp->prefix_len =3D=3D 64) {
> +               memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
> +               ipv6_gen_rnd_iid(&addr);
> +       } else if (ifp->prefix_len > 0 && ifp->prefix_len <=3D 128) {
> +               memcpy(addr.s6_addr32, ifp->addr.s6_addr, 16);
> +               get_random_bytes(temp.s6_addr32, 16);
> +
> +               /* tranfrom prefix len into mask */
> +               ipv6_plen_to_mask(ifp->prefix_len, &net_mask);
> +
> +               for (i =3D 0; i < 4; i++) {
> +                       /* network prefix */
> +                       ipv6addr.s6_addr32[i] =3D addr.s6_addr32[i] & net=
_mask.s6_addr32[i];
> +                       /* host id */
> +                       ipv6addr.s6_addr32[i] |=3D temp.s6_addr32[i] & ~n=
et_mask.s6_addr32[i];
> +               }
> +
> +               memcpy(addr.s6_addr, ipv6addr.s6_addr32, 16);
>

ipv6_addr_copy() and then ipv6_addr_prefix_copy()

+       }
>         age =3D (now - ifp->tstamp) / HZ;
>
>         regen_advance =3D idev->cnf.regen_max_retry *
> @@ -2576,9 +2604,57 @@ int addrconf_prefix_rcv_add_addr(struct
>                                  u32 addr_flags, bool sllao, bool tokeniz=
ed,
>                                  __u32 valid_lft, u32 prefered_lft)
>  {
> -       struct inet6_ifaddr *ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);
> +       struct inet6_ifaddr *ifp =3D NULL;
>         int create =3D 0;
>
> +       if ((in6_dev->if_flags & IF_RA_VAR_PLEN) =3D=3D IF_RA_VAR_PLEN &&
> +           in6_dev->cnf.addr_gen_mode !=3D IN6_ADDR_GEN_MODE_STABLE_PRIV=
ACY) {
> +               struct inet6_ifaddr *result =3D NULL;
> +               struct inet6_ifaddr *result_base =3D NULL;
> +               struct in6_addr net_mask;
> +               struct in6_addr net_prfx;
> +               struct in6_addr curr_net_prfx;
> +               bool prfxs_equal;
> +               int i;
> +
> +               result_base =3D result;
> +               rcu_read_lock();
> +               list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list=
) {
> +                       if (!net_eq(dev_net(ifp->idev->dev), net))
> +                               continue;
> +
> +                       /* tranfrom prefix len into mask */
> +                       ipv6_plen_to_mask(pinfo->prefix_len, &net_mask);
> +                       /* Prepare network prefixes */
> +                       for (i =3D 0; i < 4; i++) {
> +                               /* Received/new network prefix */
> +                               net_prfx.s6_addr32[i] =3D
> +                                       pinfo->prefix.s6_addr32[i] & net_=
mask.s6_addr32[i];
> +                               /* Configured/old IPv6 prefix */
> +                               curr_net_prfx.s6_addr32[i] =3D
> +                                       ifp->addr.s6_addr32[i] & net_mask=
.s6_addr32[i];
> +                       }
> +                       /* Compare network prefixes */
> +                       prfxs_equal =3D 1;
> +                       for (i =3D 0; i < 4; i++) {
> +                               if ((net_prfx.s6_addr32[i] ^ curr_net_prf=
x.s6_addr32[i]) !=3D 0)
> +                                       prfxs_equal =3D 0;
> +                       }

ipv6_prefix_equal()

> +                       if (prfxs_equal && pinfo->prefix_len =3D=3D ifp->=
prefix_len) {
> +                               result =3D ifp;
> +                               in6_ifa_hold(ifp);
> +                               break;
> +                       }
> +               }
> +               rcu_read_unlock();
> +               if (result_base !=3D result)
> +                       ifp =3D result;
> +               else
> +                       ifp =3D NULL;
> +       } else {
> +               ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);
> +       }
> +
>         if (!ifp && valid_lft) {
>                 int max_addresses =3D in6_dev->cnf.max_addresses;
>                 struct ifa6_config cfg =3D {
> @@ -2781,9 +2857,35 @@ void addrconf_prefix_rcv(struct net_devi
>                                 dev_addr_generated =3D true;
>                         }
>                         goto ok;
> +               goto put;
> +               } else if (((in6_dev->if_flags & IF_RA_VAR_PLEN) =3D=3D I=
F_RA_VAR_PLEN) &&
> +                         pinfo->prefix_len > 0 && pinfo->prefix_len <=3D=
 128) {
> +                       /* SLAAC with prefixes of arbitrary length (Varia=
ble SLAAC).
> +                        * draft-mishra-6man-variable-slaac
> +                        * draft-mishra-v6ops-variable-slaac-problem-stmt
> +                        * Contact: Dmytro Shytyi.
> +                        */
> +                       memcpy(&addr, &pinfo->prefix, 16);
> +                       if (in6_dev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GE=
N_MODE_STABLE_PRIVACY) {
> +                               if (!ipv6_generate_address_variable_plen(=
&addr,
> +                                                                        =
0,
> +                                                                        =
in6_dev,
> +                                                                        =
pinfo->prefix_len,
> +                                                                        =
true)) {
> +                                       addr_flags |=3D IFA_F_STABLE_PRIV=
ACY;
> +                                       goto ok;
> +                       }
> +                       } else if (!ipv6_generate_address_variable_plen(&=
addr,
> +                                                                       0=
,
> +                                                                       i=
n6_dev,
> +                                                                       p=
info->prefix_len,
> +                                                                       f=
alse)) {
> +                               goto ok;
> +                       }
> +               } else {
> +                       net_dbg_ratelimited("IPv6: Prefix with unexpected=
 length %d\n",
> +                                           pinfo->prefix_len);
>                 }
> -               net_dbg_ratelimited("IPv6 addrconf: prefix with wrong len=
gth %d\n",
> -                                   pinfo->prefix_len);
>                 goto put;
>
>  ok:
> @@ -3264,6 +3366,118 @@ retry:
>         return 0;
>  }
>
> +static void ipv6_plen_to_mask(int plen, struct in6_addr *net_mask)
> +{
> +       int i, plen_bytes;
> +       char bit_array[7] =3D {0b10000000,
> +                            0b11000000,
> +                            0b11100000,
> +                            0b11110000,
> +                            0b11111000,
> +                            0b11111100,
> +                            0b11111110};
> +
> +       if (plen <=3D 0 || plen > 128)
> +               pr_err("Unexpected plen: %d", plen);
> +
> +       memset(net_mask, 0x00, sizeof(*net_mask));
> +
> +       /* We set all bits =3D=3D 1 of s6_addr[i] */
> +       plen_bytes =3D plen / 8;
> +       for (i =3D 0; i < plen_bytes; i++)
> +               net_mask->s6_addr[i] =3D 0xff;
> +
> +       /* We add bits from the bit_array to
> +        * netmask starting from plen_bytes position
> +        */
> +       if (plen % 8)
> +               net_mask->s6_addr[plen_bytes] =3D bit_array[(plen % 8) - =
1];
> +       memcpy(net_mask->s6_addr32, net_mask->s6_addr, 16);
> +}

I don't think we need this function.
If needed, we could introduce ipv6_addr_host() (like ipv6_addr_prefix())
in include/net/ipv6.h.
