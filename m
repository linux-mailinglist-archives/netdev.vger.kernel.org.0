Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0EF2C6A40
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbgK0Qy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:54:58 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21312 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgK0Qy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 11:54:57 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606496047; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Omo+NYH1AKjIoAw4D45cwwjAbPsjOM55fDVUkwM2TT6cPlSUKMvS25ztuJ4jQYQ1Qe6sprLBkP2xNoEls34r5azf3h5+dMNiy5DEzzxw/ugeBapE1qZtyD4NRHnkRWeVcOrPXA7iIYVAFN6hArQ5CeM7A+XNmskDh2aUu2eIzI0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606496047; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=r02Ja2Mx3U1C9KxYv3EeHLoqtdqyG6e1i28jnZLTOT4=; 
        b=We0Xs7xQ1riseypbeEPjS5OxluTdnRpBLS10FuG55RwxgIW9BexNRiWV4as37y6JkufRk03kBkrhRXiitwhBGNouviH4G8RB/6HgY5QBxSxALyeWOXJ8UFZCbl7eK8AEYgVOzIDJone/eO3N8C0VTSokUxuVHb5xBnRjcxeomP4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1606496047;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=r02Ja2Mx3U1C9KxYv3EeHLoqtdqyG6e1i28jnZLTOT4=;
        b=YK30ANgbgJxeYEgaMlgHX1NNzYpOkpg37gM6n7y5NiVrhPhq9np46ogKPdqc2UI/
        6hZDgAWwWfyUuyT9jtkzCi+5a9FBGo8naRlzrX2vgWnih8sCAeGliI2dK0vEd7ajST0
        ggP8dpDR2n0tjY79uYlg1GD40y3EpXEbahMOQdhw=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1606496042023590.1418112155035; Fri, 27 Nov 2020 17:54:02 +0100 (CET)
Date:   Fri, 27 Nov 2020 17:54:02 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Hideaki Yoshifuji" <hideaki.yoshifuji@miraclelinux.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <1760aa03c22.ec63ccb8820202.7945714352225076012@shytyi.net>
In-Reply-To: <CAPA1RqAK4z30kHLDXFkvesijs3epBr_F_3mH7swrGYGuSPtQFg@mail.gmail.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net> <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net> <CAPA1RqAK4z30kHLDXFkvesijs3epBr_F_3mH7swrGYGuSPtQFg@mail.gmail.com>
Subject: Re: [PATCH net-next V7] net: Variable SLAAC: SLAAC with prefixes of
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

Hello,

---- On Mon, 23 Nov 2020 14:26:27 +0100 Hideaki Yoshifuji <hideaki.yoshifuj=
i@miraclelinux.com> wrote ----

 > Hi,=20
 > =20
 > 2020=E5=B9=B411=E6=9C=8820=E6=97=A5(=E9=87=91) 18:28 Dmytro Shytyi <dmyt=
ro@shytyi.net>:=20
 > >=20
 > > Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (random=
ly=20
 > > generated hostID or stable privacy + privacy extensions).=20
 > > The main problem is that SLAAC RA or PD allocates a /64 by the Wireles=
s=20
 > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 vi=
a=20
 > > SLAAC is required so that downstream interfaces can be further subnett=
ed.=20
 > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, a=
nd=20
 > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to=20
 > > Load-Balancer and /72 to wired connected devices.=20
 > > IETF document that defines problem statement:=20
 > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 > > IETF document that specifies variable slaac:=20
 > > draft-mishra-6man-variable-slaac=20
 > >=20
 > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 > > ---=20
 > > diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-5.10=
.0-rc2/net/ipv6/addrconf.c=20
 > > --- net-next-5.10.0-rc2/net/ipv6/addrconf.c     2020-11-10 08:46:01.07=
5193379 +0100=20
 > > +++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c       2020-11-19 21:=
26:39.770872898 +0100=20
 > > @@ -142,7 +142,6 @@ static int ipv6_count_addresses(const st=20
 > >  static int ipv6_generate_stable_address(struct in6_addr *addr,=20
 > >                                         u8 dad_count,=20
 > >                                         const struct inet6_dev *idev);=
=20
 > > -=20
 > =20
 > Do not remove this line.=20
[Dmytro]
Understood.

 > >  #define IN6_ADDR_HSIZE_SHIFT   8=20
 > >  #define IN6_ADDR_HSIZE         (1 << IN6_ADDR_HSIZE_SHIFT)=20
 > >  /*=20
 > > @@ -1315,6 +1314,7 @@ static int ipv6_create_tempaddr(struct i=20
 > >         struct ifa6_config cfg;=20
 > >         long max_desync_factor;=20
 > >         struct in6_addr addr;=20
 > > +       struct in6_addr temp;=20
 > >         int ret =3D 0;=20
 > >=20
 > >         write_lock_bh(&idev->lock);=20
 > > @@ -1340,9 +1340,16 @@ retry:=20
 > >                 goto out;=20
 > >         }=20
 > >         in6_ifa_hold(ifp);=20
 > > -       memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);=20
 > > -       ipv6_gen_rnd_iid(&addr);=20
 > >=20
 > > +       if (ifp->prefix_len =3D=3D 64) {=20
 > > +               memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);=20
 > > +               ipv6_gen_rnd_iid(&addr);=20
 > > +       } else if (ifp->prefix_len > 0 && ifp->prefix_len <=3D 128) {=
=20
 > > +               memcpy(addr.s6_addr32, ifp->addr.s6_addr, 16);=20
 > > +               get_random_bytes(temp.s6_addr32, 16);=20
 > > +               ipv6_addr_prefix_copy(&temp, &addr, ifp->prefix_len);=
=20
 > > +               memcpy(addr.s6_addr, temp.s6_addr, 16);=20
 > > +       }=20
 > =20
 > I do not understand why you are copying many times.=20
 > ipv6_addr_copy(), get_random_bytes(), and then ipv6_addr_prefix_copy=20
 > is enough, no?=20
[Dmytro]

I do not see any definition of ipv6_addr_copy() in v5.10-rc5.

Indeed we can try do "if case" something like this:
if (ifp->prefix_len > 0 && ifp->prefix_len <=3D 128) {
               get_random_bytes(addr.s6_addr, 16);=20
               ipv6_addr_prefix_copy(&addr, &ifp->addr, ifp->prefix_len); =
=20
}=20

 > >         age =3D (now - ifp->tstamp) / HZ;=20
 > >=20
 > >         regen_advance =3D idev->cnf.regen_max_retry *=20
 > > @@ -2569,6 +2576,41 @@ static bool is_addr_mode_generate_stable=20
 > >                idev->cnf.addr_gen_mode =3D=3D IN6_ADDR_GEN_MODE_RANDOM=
;=20
 > >  }=20
 > >=20
 > > +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_if=
addr *ifp,=20
 > > +                                                     struct inet6_dev=
 *in6_dev,=20
 > > +                                                     struct net *net,=
=20
 > > +                                                     const struct pre=
fix_info *pinfo)=20
 > > +{=20
 > > +       struct inet6_ifaddr *result_base =3D NULL;=20
 > > +       struct inet6_ifaddr *result =3D NULL;=20
 > > +       struct in6_addr curr_net_prfx;=20
 > > +       struct in6_addr net_prfx;=20
 > > +       bool prfxs_equal;=20
 > > +=20
 > > +       result_base =3D result;=20
 > > +       rcu_read_lock();=20
 > > +       list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {=
=20
 > > +               if (!net_eq(dev_net(ifp->idev->dev), net))=20
 > > +                       continue;=20
 > > +               ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo=
->prefix_len);=20
 > > +               ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinf=
o->prefix_len);=20
 > > +               prfxs_equal =3D=20
 > > +                       ipv6_prefix_equal(&net_prfx, &curr_net_prfx, p=
info->prefix_len);=20
 > > +               if (prfxs_equal && pinfo->prefix_len =3D=3D ifp->prefi=
x_len) {=20
 > > +                       result =3D ifp;=20
 > > +                       in6_ifa_hold(ifp);=20
 > > +                       break;=20
 > > +               }=20
 > =20
 > I guess we can compare them with ipv6_prefix_equal()=20
 > directly because the code assumes "pinfo->prefix_len" and ifp->prefix_le=
n are=20
 > equal.=20

[Dmytro]
 Understood.=20

 > > +       }=20
 > > +       rcu_read_unlock();=20
 > > +       if (result_base !=3D result)=20
 > > +               ifp =3D result;=20
 > > +       else=20
 > > +               ifp =3D NULL;=20
 > > +=20
 > > +       return ifp;=20
 > > +}=20
 > > +=20
 > >  int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *=
dev,=20
 > >                                  const struct prefix_info *pinfo,=20
 > >                                  struct inet6_dev *in6_dev,=20
 > > @@ -2576,9 +2618,16 @@ int addrconf_prefix_rcv_add_addr(struct=20
 > >                                  u32 addr_flags, bool sllao, bool toke=
nized,=20
 > >                                  __u32 valid_lft, u32 prefered_lft)=20
 > >  {=20
 > > -       struct inet6_ifaddr *ifp =3D ipv6_get_ifaddr(net, addr, dev, 1=
);=20
 > > +       struct inet6_ifaddr *ifp =3D NULL;=20
 > > +       int plen =3D pinfo->prefix_len;=20
 > >         int create =3D 0;=20
 > >=20
 > > +       if (plen > 0 && plen <=3D 128 && plen !=3D 64 &&=20
 > > +           in6_dev->cnf.addr_gen_mode !=3D IN6_ADDR_GEN_MODE_STABLE_P=
RIVACY)=20
 > > +               ifp =3D ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, p=
info);=20
 > > +       else=20
 > > +               ifp =3D ipv6_get_ifaddr(net, addr, dev, 1);=20
 > > +=20
 > >         if (!ifp && valid_lft) {=20
 > >                 int max_addresses =3D in6_dev->cnf.max_addresses;=20
 > >                 struct ifa6_config cfg =3D {=20
 > =20
 > I am wondering if we should enable this feature by default at this momen=
t=20
 > because the spec is personal internet draft and some test suites might=
=20
 > consider this feature violates standards.=20

[Dmytro]
1. By default the /64 plen is send by the router in RA.=20
plen =3D=3D/64 is default behaviour for me.=20
We are NOT replacing plen =3D=3D /64 with this patch.=20
Variable SLAAC is more like an additional functionality.
If and only IF router sends plen !=3D64 the patch functionality MAY be acti=
vated otherwise it is "dormant".

2. After a discussion with my colleague we come up with the next ideas:

- the implementation of IIDs whose length is arbitrary. The RFC7217, as
implemented here optionally, allows for IIDs of any length. The IETF
consensus status of that RFC is on the Standards Track,=20
and the status is "PROPOSED STANDARD" (the next consensus level that
this RFC could head for is DRAFT STANDARD; preceding levels through
which the document already went successfully: are Individual Draft
submission, WG adoption, Last Call, AUTH48, published).

- the linux kernel supports IPv6 NAT in the mainline - 'masquerading'.
The feature IPv6 NAT is not supported at all by the IETF: the
consensus level is something like complete rejection. Yet it is fully
supported in the kernel.=20

- the openbsd (not freebsd) implementations already support RFC 7217
IIDs of arbitrary length: send an RA with plen 65 and the receiving
Host will form an IID of length 63 and an IPv6 address. Why linux would
not allow this?

3. Possible solutions:
3.a) enable this feature as additional functionality, only when plen !=3D64=
, and keep it "dormant" by default.

3.b) Add sysctl net.ipv6.conf.enp0s3.variable_slaac =3D 1

3.c) A possibility is that this feature will be present in the make menucon=
fig.


 > > @@ -2657,6 +2706,91 @@ int addrconf_prefix_rcv_add_addr(struct=20
 > >  }=20
 > >  EXPORT_SYMBOL_GPL(addrconf_prefix_rcv_add_addr);=20
 > >=20
 > > +static bool ipv6_reserved_interfaceid(struct in6_addr address)=20
 > > +{=20
 > > +       if ((address.s6_addr32[2] | address.s6_addr32[3]) =3D=3D 0)=20
 > > +               return true;=20
 > > +=20
 > > +       if (address.s6_addr32[2] =3D=3D htonl(0x02005eff) &&=20
 > > +           ((address.s6_addr32[3] & htonl(0xfe000000)) =3D=3D htonl(0=
xfe000000)))=20
 > > +               return true;=20
 > > +=20
 > > +       if (address.s6_addr32[2] =3D=3D htonl(0xfdffffff) &&=20
 > > +           ((address.s6_addr32[3] & htonl(0xffffff80)) =3D=3D htonl(0=
xffffff80)))=20
 > > +               return true;=20
 > > +=20
 > > +       return false;=20
 > > +}=20
 > > +=20
 > > +static int ipv6_gen_addr_var_plen(struct in6_addr *address,=20
 > > +                                 u8 dad_count,=20
 > > +                                 const struct inet6_dev *idev,=20
 > > +                                 unsigned int rcvd_prfx_len,=20
 > > +                                 bool stable_privacy_mode)=20
 > > +{=20
 > > +       static union {=20
 > > +               char __data[SHA1_BLOCK_SIZE];=20
 > > +               struct {=20
 > > +                       struct in6_addr secret;=20
 > > +                       __be32 prefix[2];=20
 > > +                       unsigned char hwaddr[MAX_ADDR_LEN];=20
 > > +                       u8 dad_count;=20
 > > +               } __packed;=20
 > > +       } data;=20
 > > +       static __u32 workspace[SHA1_WORKSPACE_WORDS];=20
 > > +       static __u32 digest[SHA1_DIGEST_WORDS];=20
 > > +       struct net *net =3D dev_net(idev->dev);=20
 > > +       static DEFINE_SPINLOCK(lock);=20
 > > +       struct in6_addr secret;=20
 > > +       struct in6_addr temp;=20
 > > +=20
 > > +       BUILD_BUG_ON(sizeof(data.__data) !=3D sizeof(data));=20
 > > +=20
 > > +       if (stable_privacy_mode) {=20
 > > +               if (idev->cnf.stable_secret.initialized)=20
 > > +                       secret =3D idev->cnf.stable_secret.secret;=20
 > > +               else if (net->ipv6.devconf_dflt->stable_secret.initial=
ized)=20
 > > +                       secret =3D net->ipv6.devconf_dflt->stable_secr=
et.secret;=20
 > > +               else=20
 > > +                       return -1;=20
 > > +       }=20
 > > +=20
 > > +retry:=20
 > > +       spin_lock_bh(&lock);=20
 > > +       if (stable_privacy_mode) {=20
 > > +               sha1_init(digest);=20
 > > +               memset(&data, 0, sizeof(data));=20
 > > +               memset(workspace, 0, sizeof(workspace));=20
 > > +               memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->a=
ddr_len);=20
 > > +               data.prefix[0] =3D address->s6_addr32[0];=20
 > > +               data.prefix[1] =3D address->s6_addr32[1];=20
 > > +               data.secret =3D secret;=20
 > > +               data.dad_count =3D dad_count;=20
 > > +=20
 > > +               sha1_transform(digest, data.__data, workspace);=20
 > > +=20
 > > +               temp =3D *address;=20
 > > +               temp.s6_addr32[0] =3D (__force __be32)digest[0];=20
 > > +               temp.s6_addr32[1] =3D (__force __be32)digest[1];=20
 > > +               temp.s6_addr32[2] =3D (__force __be32)digest[2];=20
 > > +               temp.s6_addr32[3] =3D (__force __be32)digest[3];=20
 > =20
 > I do not understand why you copy *address and then overwrite=20
 > by digest?=20

[Dmytro]
Originally it comes from "ipv6_generate_stable_address()".
it is present there because only 64bits of temp are replaced by digest.
In this case, we replace 128 bits thus I agree: it is misleading. I will fi=
x that.


 > > +       } else {=20
 > > +               temp =3D *address;=20
 > > +               get_random_bytes(temp.s6_addr32, 16);=20
 > > +       }=20
 > > +       spin_unlock_bh(&lock);=20
 > > +=20
 > > +       if (ipv6_reserved_interfaceid(temp)) {=20
 > > +               dad_count++;=20
 > > +               if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_=
retries)=20
 > > +                       return -1;=20
 > > +               goto retry;=20
 > > +       }=20
 > > +       ipv6_addr_prefix_copy(&temp, address, rcvd_prfx_len);=20
 > > +       *address =3D temp;=20
 > > +       return 0;=20
 > > +}=20
 > > +=20
 > >  void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bo=
ol sllao)=20
 > >  {=20
 > >         struct prefix_info *pinfo;=20
 > > @@ -2781,9 +2915,33 @@ void addrconf_prefix_rcv(struct net_devi=20
 > >                                 dev_addr_generated =3D true;=20
 > >                         }=20
 > >                         goto ok;=20
 > > +               } else if (pinfo->prefix_len !=3D 64 &&=20
 > > +                          pinfo->prefix_len > 0 && pinfo->prefix_len =
<=3D 128) {=20
 > > +                       /* SLAAC with prefixes of arbitrary length (Va=
riable SLAAC).=20
 > > +                        * draft-mishra-6man-variable-slaac=20
 > > +                        * draft-mishra-v6ops-variable-slaac-problem-s=
tmt=20
 > > +                        */=20
 > > +                       memcpy(&addr, &pinfo->prefix, 16);=20
 > > +                       if (in6_dev->cnf.addr_gen_mode =3D=3D IN6_ADDR=
_GEN_MODE_STABLE_PRIVACY) {=20
 > > +                               if (!ipv6_gen_addr_var_plen(&addr,=20
 > > +                                                           0,=20
 > > +                                                           in6_dev,=
=20
 > > +                                                           pinfo->pre=
fix_len,=20
 > > +                                                           true)) {=
=20
 > > +                                       addr_flags |=3D IFA_F_STABLE_P=
RIVACY;=20
 > > +                                       goto ok;=20
 > > +                               }=20
 > > +                       } else if (!ipv6_gen_addr_var_plen(&addr,=20
 > > +                                                          0,=20
 > > +                                                          in6_dev,=20
 > > +                                                          pinfo->pref=
ix_len,=20
 > > +                                                          false)) {=
=20
 > > +                               goto ok;=20
 > > +                       }=20
 > > +               } else {=20
 > > +                       net_dbg_ratelimited("IPv6: Prefix with unexpec=
ted length %d\n",=20
 > > +                                           pinfo->prefix_len);=20
 > >                 }=20
 > > -               net_dbg_ratelimited("IPv6 addrconf: prefix with wrong =
length %d\n",=20
 > > -                                   pinfo->prefix_len);=20
 > >                 goto put;=20
 > >=20
 > >  ok:=20
 > > @@ -3186,22 +3344,6 @@ void addrconf_add_linklocal(struct inet6=20
 > >  }=20
 > >  EXPORT_SYMBOL_GPL(addrconf_add_linklocal);=20
 > >=20
 > > -static bool ipv6_reserved_interfaceid(struct in6_addr address)=20
 > > -{=20
 > > -       if ((address.s6_addr32[2] | address.s6_addr32[3]) =3D=3D 0)=20
 > > -               return true;=20
 > > -=20
 > > -       if (address.s6_addr32[2] =3D=3D htonl(0x02005eff) &&=20
 > > -           ((address.s6_addr32[3] & htonl(0xfe000000)) =3D=3D htonl(0=
xfe000000)))=20
 > > -               return true;=20
 > > -=20
 > > -       if (address.s6_addr32[2] =3D=3D htonl(0xfdffffff) &&=20
 > > -           ((address.s6_addr32[3] & htonl(0xffffff80)) =3D=3D htonl(0=
xffffff80)))=20
 > > -               return true;=20
 > > -=20
 > > -       return false;=20
 > > -}=20
 > > -=20
 > >  static int ipv6_generate_stable_address(struct in6_addr *address,=20
 > >                                         u8 dad_count,=20
 > >                                         const struct inet6_dev *idev)=
=20
 >=20
