Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632562C0B9B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgKWN14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731562AbgKWN1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:27:49 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75C2C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:27:47 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id v3so1701664ilo.5
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kDDe3GWyO6UEF6mJn5gnAALxYUKASoqyRD9EsGZkODY=;
        b=bX2IIxObLp1hMmgfM/ty9SAxNQfO2K24lmjkuvMRO6LK1/L0x1lxOfIrINY89K3uTP
         MbGbp55j+VTbk4OJR/+WhkjQ/UvFW5iSLbdNGZ8CXC2rPVjqvHgid/W1wuoiSdD2D+YK
         dP+gcc1knHFOMt2hjiJc/MJNXrDc8pbDqAQv/uaxHxN1isY8NojdXbQDVlhBVl3Fejxv
         kRaaa/e7kXEKNz1aUC5FfWMY2kdSC5SfKHFtgHINudZMH4PXd6g38sicxsItjeyLAO8t
         QzcIt0eYRSXA05DkB8mHfffVp5DaC0JVlaBWIFgftfcMpO4VAYxfO4UNdSttwz1f6/F3
         Dj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kDDe3GWyO6UEF6mJn5gnAALxYUKASoqyRD9EsGZkODY=;
        b=ndI7Yu7LcnOGrldr1Djz6O6jHwyKg9IDVleLB6ri6xWH6hcDqFXtD49zIp3l1iEHfv
         B45hfJVmg6VL5D116YR0wTcWXhAIlgueABa3bCsHOXSX8oZJIV/GUThxOY2xKG59V1qu
         7TVB8Zpn0BYghGj79Lsb/DCVXBde3Rj4d98+Kin/9GhTtXUf28wfrouoc+eENs4fp/OT
         ZO5IxNvPdRiekma5lbHiCQKJsXY3nlQ7F/gDaJoDnLdDa9Eij8s9UmBlCDdJBLj14S4T
         JVsZBizFOMVFvnf1+5n0hNWgApcjFX5F5TR4a1g2ZQrLe2COMqszVc6OtGkeZfE076cs
         eCNg==
X-Gm-Message-State: AOAM530D3qLTFi/3zIoJCh+z667GQRUn9QnEO4PINFWYh2OmT1Ypa21p
        E8Zc5JDr3BCYMKw1QOvZdKng4bUNz792PeSKIL2RKA==
X-Google-Smtp-Source: ABdhPJwhyFIEHVBwLw6LVge7D+ok0nKfMXfzBoVVSt195mhKiQ+PNWJtXTAfrVWWr2AJQTbLphrMRo7QIavfgq8p8Zk=
X-Received: by 2002:a92:cc07:: with SMTP id s7mr5510706ilp.290.1606138066786;
 Mon, 23 Nov 2020 05:27:46 -0800 (PST)
MIME-Version: 1.0
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net> <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
In-Reply-To: <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Mon, 23 Nov 2020 22:26:27 +0900
Message-ID: <CAPA1RqAK4z30kHLDXFkvesijs3epBr_F_3mH7swrGYGuSPtQFg@mail.gmail.com>
Subject: Re: [PATCH net-next V7] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        kuznet <kuznet@ms2.inr.ac.ru>, liuhangbin <liuhangbin@gmail.com>,
        davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B411=E6=9C=8820=E6=97=A5(=E9=87=91) 18:28 Dmytro Shytyi <dmytro@=
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
> +++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c       2020-11-19 21:26:=
39.770872898 +0100
> @@ -142,7 +142,6 @@ static int ipv6_count_addresses(const st
>  static int ipv6_generate_stable_address(struct in6_addr *addr,
>                                         u8 dad_count,
>                                         const struct inet6_dev *idev);
> -

Do not remove this line.
>  #define IN6_ADDR_HSIZE_SHIFT   8
>  #define IN6_ADDR_HSIZE         (1 << IN6_ADDR_HSIZE_SHIFT)
>  /*
> @@ -1315,6 +1314,7 @@ static int ipv6_create_tempaddr(struct i
>         struct ifa6_config cfg;
>         long max_desync_factor;
>         struct in6_addr addr;
> +       struct in6_addr temp;
>         int ret =3D 0;
>
>         write_lock_bh(&idev->lock);
> @@ -1340,9 +1340,16 @@ retry:
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
> +               ipv6_addr_prefix_copy(&temp, &addr, ifp->prefix_len);
> +               memcpy(addr.s6_addr, temp.s6_addr, 16);
> +       }

I do not understand why you are copying many times.
ipv6_addr_copy(), get_random_bytes(), and then ipv6_addr_prefix_copy
is enough, no?

>         age =3D (now - ifp->tstamp) / HZ;
>
>         regen_advance =3D idev->cnf.regen_max_retry *
> @@ -2569,6 +2576,41 @@ static bool is_addr_mode_generate_stable
>                idev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GEN_MODE_RANDOM;
>  }
>
> +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifadd=
r *ifp,
> +                                                     struct inet6_dev *i=
n6_dev,
> +                                                     struct net *net,
> +                                                     const struct prefix=
_info *pinfo)
> +{
> +       struct inet6_ifaddr *result_base =3D NULL;
> +       struct inet6_ifaddr *result =3D NULL;
> +       struct in6_addr curr_net_prfx;
> +       struct in6_addr net_prfx;
> +       bool prfxs_equal;
> +
> +       result_base =3D result;
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
> +               if (!net_eq(dev_net(ifp->idev->dev), net))
> +                       continue;
> +               ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->p=
refix_len);
> +               ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->=
prefix_len);
> +               prfxs_equal =3D
> +                       ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinf=
o->prefix_len);
> +               if (prfxs_equal && pinfo->prefix_len =3D=3D ifp->prefix_l=
en) {
> +                       result =3D ifp;
> +                       in6_ifa_hold(ifp);
> +                       break;
> +               }

I guess we can compare them with ipv6_prefix_equal()
directly because the code assumes "pinfo->prefix_len" and ifp->prefix_len a=
re
equal.

> +       }
> +       rcu_read_unlock();
> +       if (result_base !=3D result)
> +               ifp =3D result;
> +       else
> +               ifp =3D NULL;
> +
> +       return ifp;
> +}
> +
>  int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev=
,
>                                  const struct prefix_info *pinfo,
>                                  struct inet6_dev *in6_dev,
> @@ -2576,9 +2618,16 @@ int addrconf_prefix_rcv_add_addr(struct
>                                  u32 addr_flags, bool sllao, bool tokeniz=
ed,
>                                  __u32 valid_lft, u32 prefered_lft)
>  {
> -       struct inet6_ifaddr *ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);
> +       struct inet6_ifaddr *ifp =3D NULL;
> +       int plen =3D pinfo->prefix_len;
>         int create =3D 0;
>
> +       if (plen > 0 && plen <=3D 128 && plen !=3D 64 &&
> +           in6_dev->cnf.addr_gen_mode !=3D IN6_ADDR_GEN_MODE_STABLE_PRIV=
ACY)
> +               ifp =3D ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, pinf=
o);
> +       else
> +               ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);
> +
>         if (!ifp && valid_lft) {
>                 int max_addresses =3D in6_dev->cnf.max_addresses;
>                 struct ifa6_config cfg =3D {

I am wondering if we should enable this feature by default at this moment
because the spec is personal internet draft and some test suites might
consider this feature violates standards.

> @@ -2657,6 +2706,91 @@ int addrconf_prefix_rcv_add_addr(struct
>  }
>  EXPORT_SYMBOL_GPL(addrconf_prefix_rcv_add_addr);
>
> +static bool ipv6_reserved_interfaceid(struct in6_addr address)
> +{
> +       if ((address.s6_addr32[2] | address.s6_addr32[3]) =3D=3D 0)
> +               return true;
> +
> +       if (address.s6_addr32[2] =3D=3D htonl(0x02005eff) &&
> +           ((address.s6_addr32[3] & htonl(0xfe000000)) =3D=3D htonl(0xfe=
000000)))
> +               return true;
> +
> +       if (address.s6_addr32[2] =3D=3D htonl(0xfdffffff) &&
> +           ((address.s6_addr32[3] & htonl(0xffffff80)) =3D=3D htonl(0xff=
ffff80)))
> +               return true;
> +
> +       return false;
> +}
> +
> +static int ipv6_gen_addr_var_plen(struct in6_addr *address,
> +                                 u8 dad_count,
> +                                 const struct inet6_dev *idev,
> +                                 unsigned int rcvd_prfx_len,
> +                                 bool stable_privacy_mode)
> +{
> +       static union {
> +               char __data[SHA1_BLOCK_SIZE];
> +               struct {
> +                       struct in6_addr secret;
> +                       __be32 prefix[2];
> +                       unsigned char hwaddr[MAX_ADDR_LEN];
> +                       u8 dad_count;
> +               } __packed;
> +       } data;
> +       static __u32 workspace[SHA1_WORKSPACE_WORDS];
> +       static __u32 digest[SHA1_DIGEST_WORDS];
> +       struct net *net =3D dev_net(idev->dev);
> +       static DEFINE_SPINLOCK(lock);
> +       struct in6_addr secret;
> +       struct in6_addr temp;
> +
> +       BUILD_BUG_ON(sizeof(data.__data) !=3D sizeof(data));
> +
> +       if (stable_privacy_mode) {
> +               if (idev->cnf.stable_secret.initialized)
> +                       secret =3D idev->cnf.stable_secret.secret;
> +               else if (net->ipv6.devconf_dflt->stable_secret.initialize=
d)
> +                       secret =3D net->ipv6.devconf_dflt->stable_secret.=
secret;
> +               else
> +                       return -1;
> +       }
> +
> +retry:
> +       spin_lock_bh(&lock);
> +       if (stable_privacy_mode) {
> +               sha1_init(digest);
> +               memset(&data, 0, sizeof(data));
> +               memset(workspace, 0, sizeof(workspace));
> +               memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr=
_len);
> +               data.prefix[0] =3D address->s6_addr32[0];
> +               data.prefix[1] =3D address->s6_addr32[1];
> +               data.secret =3D secret;
> +               data.dad_count =3D dad_count;
> +
> +               sha1_transform(digest, data.__data, workspace);
> +
> +               temp =3D *address;
> +               temp.s6_addr32[0] =3D (__force __be32)digest[0];
> +               temp.s6_addr32[1] =3D (__force __be32)digest[1];
> +               temp.s6_addr32[2] =3D (__force __be32)digest[2];
> +               temp.s6_addr32[3] =3D (__force __be32)digest[3];

I do not understand why you copy *address and then overwrite
by digest?

> +       } else {
> +               temp =3D *address;
> +               get_random_bytes(temp.s6_addr32, 16);
> +       }
> +       spin_unlock_bh(&lock);
> +
> +       if (ipv6_reserved_interfaceid(temp)) {
> +               dad_count++;
> +               if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_ret=
ries)
> +                       return -1;
> +               goto retry;
> +       }
> +       ipv6_addr_prefix_copy(&temp, address, rcvd_prfx_len);
> +       *address =3D temp;
> +       return 0;
> +}
> +
>  void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool =
sllao)
>  {
>         struct prefix_info *pinfo;
> @@ -2781,9 +2915,33 @@ void addrconf_prefix_rcv(struct net_devi
>                                 dev_addr_generated =3D true;
>                         }
>                         goto ok;
> +               } else if (pinfo->prefix_len !=3D 64 &&
> +                          pinfo->prefix_len > 0 && pinfo->prefix_len <=
=3D 128) {
> +                       /* SLAAC with prefixes of arbitrary length (Varia=
ble SLAAC).
> +                        * draft-mishra-6man-variable-slaac
> +                        * draft-mishra-v6ops-variable-slaac-problem-stmt
> +                        */
> +                       memcpy(&addr, &pinfo->prefix, 16);
> +                       if (in6_dev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GE=
N_MODE_STABLE_PRIVACY) {
> +                               if (!ipv6_gen_addr_var_plen(&addr,
> +                                                           0,
> +                                                           in6_dev,
> +                                                           pinfo->prefix=
_len,
> +                                                           true)) {
> +                                       addr_flags |=3D IFA_F_STABLE_PRIV=
ACY;
> +                                       goto ok;
> +                               }
> +                       } else if (!ipv6_gen_addr_var_plen(&addr,
> +                                                          0,
> +                                                          in6_dev,
> +                                                          pinfo->prefix_=
len,
> +                                                          false)) {
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
> @@ -3186,22 +3344,6 @@ void addrconf_add_linklocal(struct inet6
>  }
>  EXPORT_SYMBOL_GPL(addrconf_add_linklocal);
>
> -static bool ipv6_reserved_interfaceid(struct in6_addr address)
> -{
> -       if ((address.s6_addr32[2] | address.s6_addr32[3]) =3D=3D 0)
> -               return true;
> -
> -       if (address.s6_addr32[2] =3D=3D htonl(0x02005eff) &&
> -           ((address.s6_addr32[3] & htonl(0xfe000000)) =3D=3D htonl(0xfe=
000000)))
> -               return true;
> -
> -       if (address.s6_addr32[2] =3D=3D htonl(0xfdffffff) &&
> -           ((address.s6_addr32[3] & htonl(0xffffff80)) =3D=3D htonl(0xff=
ffff80)))
> -               return true;
> -
> -       return false;
> -}
> -
>  static int ipv6_generate_stable_address(struct in6_addr *address,
>                                         u8 dad_count,
>                                         const struct inet6_dev *idev)
