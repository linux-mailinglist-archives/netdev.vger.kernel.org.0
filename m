Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD6D20B409
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgFZOyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFZOyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:54:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2079FC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 07:54:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so9625855ejd.13
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 07:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2gDXTzdVA1AtC6f7X/e8XBMxBLQwwh2xVivyle+t4no=;
        b=1gyGNal56v2k2zHKur+8+SzXh3Y5Paummdk/+/nyVICcx6j3iRlrKB+3D22N+J5rpC
         q1u+rmJcrai9j2ab/l5Q16TyCufokSpzY0lXLCH/DhPeLXH4qaVNCm2D7prIiBdy5rkk
         jQrY9zXk0cscZcQwW0NSeJ9NkGa6KZp+lELV10wAVvHd3NSq4ZvjWWRsRmMu/cfyoMPf
         fVw1gryhpGVp1zwJXSPGImXgml2BRwJywG8wBFQlvIfsyYk5u5aXeO8XLsuwK0/YaiW9
         uJRXCV6xuMvrDBafdhV3MLq83nyvdW4Ef1rHpc6PpAzlhHj+y7JCg7Z1NLNDmsUc99Cw
         3ocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2gDXTzdVA1AtC6f7X/e8XBMxBLQwwh2xVivyle+t4no=;
        b=fhw6QdU6o5thH6cKliQdbh5vp3AbPS2Z6J/Vshl8/28u3+5txmR68enQExL/p/O9Gw
         69cUisQxXgk1ZeOR1iZU3Qm07PW5folQFqCGoo2oXGc/iVfSjyBf0SilNjlsj05JaHmO
         RiI7auqhMP2Hxy2wm2HqM078cYVttCstf0TDF05L7vOTn6aZuPvqv0NKhtxKPl2Lu2pj
         9rLjv0GEsFduqDGIb08sL9/nGiJxMcf5A3xQX4HzEfkAFEXcg9nHnO7PtkgEIGT4Hnxi
         so9lA22u7WNp0uhbnYg7M8iEYSe3h/HfljkG8wxmpcJIvgAV23JRTZDtSS9X95rbRTH/
         sVrw==
X-Gm-Message-State: AOAM531pxofku+IlITFaGLoaJqwPNhFaoRcc0L9N9b7+iIFhfDH8A0IS
        scxViEAGav7uCGXhhHL0bkhfNXxGKRdUTjklVJQUlA==
X-Google-Smtp-Source: ABdhPJwKYjklxTdbDvMm07soz09FG6yFQbkePh8wyCme0gdaT//qdiTUT4/J6U8+ZzhNc903/EgTaNVnLg9BENtpGAI=
X-Received: by 2002:a17:906:6a4f:: with SMTP id n15mr2835822ejs.378.1593183243488;
 Fri, 26 Jun 2020 07:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-4-justin.iurman@uliege.be> <CALx6S357pKVxE+Ys0pcJeHZAMt6rDobJk+fbrmYdk++a=NvfPA@mail.gmail.com>
 <1955578938.36591208.1593109430696.JavaMail.zimbra@uliege.be>
 <CALx6S34iWwhdb=7=EyGg=2zFFGhogixy=dMtHShwFWw+FsuGJg@mail.gmail.com> <1650548180.36993740.1593159184507.JavaMail.zimbra@uliege.be>
In-Reply-To: <1650548180.36993740.1593159184507.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 26 Jun 2020 07:53:52 -0700
Message-ID: <CALx6S36dpf1-ngPwWQFUwrF-_xiBkh0Ny7x-pZTmZC=J1Vw5=w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:13 AM Justin Iurman <justin.iurman@uliege.be> wro=
te:
>
> Tom,
>
> >> >> Implement support for processing the IOAM Pre-allocated Trace with =
IPv6,
> >> >> see [1] and [2]. Introduce a new IPv6 Hop-by-Hop TLV option
> >> >> IPV6_TLV_IOAM_HOPOPTS, see IANA [3].
> >> >>
> >> >
> >> > The IANA allocation is TEMPORARY, with an expiration date is
> >> > 4/16/2021. Note from RFC7120:
> >> >
> >> > "Implementers and deployers need to be aware that deprecation and
> >> > de-allocation could take place at any time after expiry; therefore, =
an
> >> > expired early allocation is best considered as deprecated."
> >> >
> >> > Please add a comment in the code and in the Documentation to this ef=
fect.
> >>
> >> I'll do that, thanks. What kind of comment (is there an official patte=
rn?) and,
> >> where in the Documentation should I add it?
> >>
> >> >> A per-interface sysctl ioam6_enabled is provided to accept/drop IOA=
M
> >> >> packets. Default is drop.
> >> >
> >> > I'm not sure what "IOAM packets" are. Presumably, this means an IPv6
> >> > packet containing the IOAM HBH option . Note that the act bits of th=
e
> >>
> >> Correct, the term IOAM packets is indeed a shortcut I used for IPv6 pa=
ckets
> >> containing the IOAM HBH option.
> >>
> >> > option type are 00 which means the TLV is skipped if the option isn'=
t
> >> > processed soI don't think it's correct to drop these packets by
> >> > default.
> >>
> >> Mmmh, I'd tend to disagree here. Despite the fact that the act bits ar=
e 00 for
> >> this option, I do believe it should be disabled (dropped) by default f=
or nodes
> >> that "speak IOAM". Indeed, you don't want anyone with a kernel that in=
cludes
> >> IOAM to accept IOAM packets by default, which would mean that anyone w=
ould
> >> create (potentially without being aware) an IOAM domain. And, also, to=
 avoid
> >> spreading leaks.
> >>
> > I think you're convoluting whether a node processes an IOAM or whether
> > it needs to drop because it doesn't process. Yes, on a IOAM system it
> > makes sense to allow configuration at whether to process the TLV.
> > However, even when it doesn't then the TLV should be skipped and the
> > packet not dropped. We know this is the correct behavior since on a
> > system that isn't IOAM aware, i.e. all deployed nodes right now, they
> > will skip the TLV per the act bits. If we want to change the default
> > behavior, the only way to do that is to change the act bits to
> > non-zero.
>
> Makes sense, you're right indeed. But still, I'm a bit worried to enable =
it by default. That would open the door to things we don't want. We'd end u=
p in a situation where IOAM is not "privately" deployed. And, think about t=
he guy that runs a kernel with IOAM (that he does not know anything about).=
 Of course, he would not have a FW to drop IOAM. Therefore, someone could s=
imply "create" an IOAM domain with him by sending IPv6 packets with IOAM HB=
H and steel data. This is something similar to the leak problem.
>

Indeed, draft-ioametal-ippm-6man-ioam-ipv6-options-02 states: "Unless
a particular interface is explicitly enabled (i.e. explicitly
configured) for IOAM, a router MUST drop packets which contain
extension headers carrying IOAM data-fields." I believe this
requirement contradicts the option type act bits being zero. I've
posted to IOAM list about this.


> So, I think there are 2 possibilities against the above: (i) the current =
one, ie drop by default or (ii) use 01 for act bits. This topic has been wi=
dely discussed in the WG and is still open, though the trend seems to be "0=
0" with the drop-by-default compromise.
>
> > For the leakage problem, that is a firewall issue. The expectation is
> > that border devices will have rules that prevent leaking packets out
> > of their domain. This is an orthogonal mechanism that needs to be done
> > for other protocols-- SRH for instance. The filtering is simple, just
> > drop the packet when TLV matches (although I suspect most sites
> > probably just drop packets with EH at this point). This doesn't
> > require any changes to the implementation and doesn't require that
> > border devices even implement IOAM-- they just drop on pattern
> > matching.
>
> +1

Mentioned that also.

>
> Justin
>
> > Tom
> >> Justin
> >>
> >> >> Another per-interface sysctl ioam6_id is provided to define the IOA=
M
> >> >> (unique) identifier of the interface.
> >> >>
> >> >> A per-namespace sysctl ioam6_id is provided to define the IOAM (uni=
que)
> >> >> identifier of the node.
> >> >>
> >> >> Two relativistic hash tables: one for IOAM namespaces, the other fo=
r
> >> >> IOAM schemas. A namespace can only have a single active schema and =
a
> >> >> schema can only be attached to a single namespace (1:1 relationship=
).
> >> >>
> >> >>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options=
-01
> >> >>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data-09
> >> >>   [3]
> >> >>   https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.=
xhtml#ipv6-parameters-2
> >> >>
> >> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> >> ---
> >> >>  include/linux/ipv6.h       |   2 +
> >> >>  include/net/ioam6.h        |  98 +++++++++++
> >> >>  include/net/netns/ipv6.h   |   2 +
> >> >>  include/uapi/linux/in6.h   |   1 +
> >> >>  include/uapi/linux/ipv6.h  |   2 +
> >> >>  net/ipv6/Makefile          |   2 +-
> >> >>  net/ipv6/addrconf.c        |  20 +++
> >> >>  net/ipv6/af_inet6.c        |   7 +
> >> >>  net/ipv6/exthdrs.c         |  67 ++++++++
> >> >>  net/ipv6/ioam6.c           | 326 +++++++++++++++++++++++++++++++++=
++++
> >> >>  net/ipv6/sysctl_net_ipv6.c |   7 +
> >> >>  11 files changed, 533 insertions(+), 1 deletion(-)
> >> >>  create mode 100644 include/net/ioam6.h
> >> >>  create mode 100644 net/ipv6/ioam6.c
> >> >>
> >> >> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> >> >> index 5312a718bc7a..15732f964c6e 100644
> >> >> --- a/include/linux/ipv6.h
> >> >> +++ b/include/linux/ipv6.h
> >> >> @@ -75,6 +75,8 @@ struct ipv6_devconf {
> >> >>         __s32           disable_policy;
> >> >>         __s32           ndisc_tclass;
> >> >>         __s32           rpl_seg_enabled;
> >> >> +       __u32           ioam6_enabled;
> >> >> +       __u32           ioam6_id;
> >> >>
> >> >>         struct ctl_table_header *sysctl_header;
> >> >>  };
> >> >> diff --git a/include/net/ioam6.h b/include/net/ioam6.h
> >> >> new file mode 100644
> >> >> index 000000000000..2a910bc99947
> >> >> --- /dev/null
> >> >> +++ b/include/net/ioam6.h
> >> >> @@ -0,0 +1,98 @@
> >> >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> >> +/*
> >> >> + *  IOAM IPv6 implementation
> >> >> + *
> >> >> + *  Author:
> >> >> + *  Justin Iurman <justin.iurman@uliege.be>
> >> >> + */
> >> >> +
> >> >> +#ifndef _NET_IOAM6_H
> >> >> +#define _NET_IOAM6_H
> >> >> +
> >> >> +#include <linux/net.h>
> >> >> +#include <linux/ipv6.h>
> >> >> +#include <linux/rhashtable-types.h>
> >> >> +
> >> >> +#define IOAM6_OPT_TRACE_PREALLOC 0
> >> >> +
> >> >> +#define IOAM6_TRACE_FLAG_OVERFLOW (1 << 3)
> >> >> +
> >> >> +#define IOAM6_TRACE_TYPE0  (1 << 31)
> >> >> +#define IOAM6_TRACE_TYPE1  (1 << 30)
> >> >> +#define IOAM6_TRACE_TYPE2  (1 << 29)
> >> >> +#define IOAM6_TRACE_TYPE3  (1 << 28)
> >> >> +#define IOAM6_TRACE_TYPE4  (1 << 27)
> >> >> +#define IOAM6_TRACE_TYPE5  (1 << 26)
> >> >> +#define IOAM6_TRACE_TYPE6  (1 << 25)
> >> >> +#define IOAM6_TRACE_TYPE7  (1 << 24)
> >> >> +#define IOAM6_TRACE_TYPE8  (1 << 23)
> >> >> +#define IOAM6_TRACE_TYPE9  (1 << 22)
> >> >> +#define IOAM6_TRACE_TYPE10 (1 << 21)
> >> >> +#define IOAM6_TRACE_TYPE11 (1 << 20)
> >> >> +#define IOAM6_TRACE_TYPE22 (1 << 9)
> >> >> +
> >> >> +#define IOAM6_EMPTY_FIELD_u16 0xffff
> >> >> +#define IOAM6_EMPTY_FIELD_u24 0x00ffffff
> >> >> +#define IOAM6_EMPTY_FIELD_u32 0xffffffff
> >> >> +#define IOAM6_EMPTY_FIELD_u56 0x00ffffffffffffff
> >> >> +#define IOAM6_EMPTY_FIELD_u64 0xffffffffffffffff
> >> >> +
> >> >> +struct ioam6_common_hdr {
> >> >> +       u8 opt_type;
> >> >> +       u8 opt_len;
> >> >> +       u8 res;
> >> >> +       u8 ioam_type;
> >> >> +       __be16 namespace_id;
> >> >> +} __packed;
> >> >> +
> >> >> +struct ioam6_trace_hdr {
> >> >> +       __be16 info;
> >> >> +       __be32 type;
> >> >> +} __packed;
> >> >> +
> >> >> +struct ioam6_namespace {
> >> >> +       struct rhash_head head;
> >> >> +       struct rcu_head rcu;
> >> >> +
> >> >> +       __be16 id;
> >> >> +       __be64 data;
> >> >> +       bool remove_tlv;
> >> >> +
> >> >> +       struct ioam6_schema *schema;
> >> >> +};
> >> >> +
> >> >> +struct ioam6_schema {
> >> >> +       struct rhash_head head;
> >> >> +       struct rcu_head rcu;
> >> >> +
> >> >> +       u32 id;
> >> >> +       int len;
> >> >> +       __be32 hdr;
> >> >> +       u8 *data;
> >> >> +
> >> >> +       struct ioam6_namespace *ns;
> >> >> +};
> >> >> +
> >> >> +struct ioam6_pernet_data {
> >> >> +       struct mutex lock;
> >> >> +       struct rhashtable namespaces;
> >> >> +       struct rhashtable schemas;
> >> >> +};
> >> >> +
> >> >> +static inline struct ioam6_pernet_data *ioam6_pernet(struct net *n=
et)
> >> >> +{
> >> >> +#if IS_ENABLED(CONFIG_IPV6)
> >> >> +       return net->ipv6.ioam6_data;
> >> >> +#else
> >> >> +       return NULL;
> >> >> +#endif
> >> >> +}
> >> >> +
> >> >> +extern struct ioam6_namespace *ioam6_namespace(struct net *net, __=
be16 id);
> >> >> +extern void ioam6_fill_trace_data(struct sk_buff *skb, int traceof=
f,
> >> >> +                                 struct ioam6_namespace *ns);
> >> >> +
> >> >> +extern int ioam6_init(void);
> >> >> +extern void ioam6_exit(void);
> >> >> +
> >> >> +#endif
> >> >> diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
> >> >> index 5ec054473d81..89b27fa721f4 100644
> >> >> --- a/include/net/netns/ipv6.h
> >> >> +++ b/include/net/netns/ipv6.h
> >> >> @@ -51,6 +51,7 @@ struct netns_sysctl_ipv6 {
> >> >>         int max_hbh_opts_len;
> >> >>         int seg6_flowlabel;
> >> >>         bool skip_notify_on_dev_down;
> >> >> +       unsigned int ioam6_id;
> >> >>  };
> >> >>
> >> >>  struct netns_ipv6 {
> >> >> @@ -115,6 +116,7 @@ struct netns_ipv6 {
> >> >>                 spinlock_t      lock;
> >> >>                 u32             seq;
> >> >>         } ip6addrlbl_table;
> >> >> +       struct ioam6_pernet_data *ioam6_data;
> >> >>  };
> >> >>
> >> >>  #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
> >> >> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> >> >> index 9f2273a08356..1c98435220c9 100644
> >> >> --- a/include/uapi/linux/in6.h
> >> >> +++ b/include/uapi/linux/in6.h
> >> >> @@ -145,6 +145,7 @@ struct in6_flowlabel_req {
> >> >>  #define IPV6_TLV_PADN          1
> >> >>  #define IPV6_TLV_ROUTERALERT   5
> >> >>  #define IPV6_TLV_CALIPSO       7       /* RFC 5570 */
> >> >> +#define IPV6_TLV_IOAM_HOPOPTS  49
> >> >
> >> > The IANA allocation is TEMPORARY, the expiration date is 4/16/2021.
> >> > Note from RFC7120:
> >> >
> >> > "Implementers and deployers need to be aware that deprecation and
> >> > de-allocation could take place at any time after expiry; therefore, =
an
> >> > expired early allocation is best considered as deprecated. It is not
> >> > IANA's responsibility to track the status of allocations, their
> >> > expirations, or when they may be re-allocated."
> >> >
> >> > The expiration date is Please add a comment here and in the
> >> > Documentation to this effect.
> >> >
> >> >>  #define IPV6_TLV_JUMBO         194
> >> >>  #define IPV6_TLV_HAO           201     /* home address option */
> >> >>
> >> >> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> >> >> index 13e8751bf24a..eb521b2dd885 100644
> >> >> --- a/include/uapi/linux/ipv6.h
> >> >> +++ b/include/uapi/linux/ipv6.h
> >> >> @@ -189,6 +189,8 @@ enum {
> >> >>         DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
> >> >>         DEVCONF_NDISC_TCLASS,
> >> >>         DEVCONF_RPL_SEG_ENABLED,
> >> >> +       DEVCONF_IOAM6_ENABLED,
> >> >> +       DEVCONF_IOAM6_ID,
> >> >>         DEVCONF_MAX
> >> >>  };
> >> >>
> >> >> diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
> >> >> index cf7b47bdb9b3..b7ef10d417d6 100644
> >> >> --- a/net/ipv6/Makefile
> >> >> +++ b/net/ipv6/Makefile
> >> >> @@ -10,7 +10,7 @@ ipv6-objs :=3D  af_inet6.o anycast.o ip6_output.o=
 ip6_input.o
> >> >> addrconf.o \
> >> >>                 route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udp=
lite.o \
> >> >>                 raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o=
 \
> >> >>                 exthdrs.o datagram.o ip6_flowlabel.o inet6_connecti=
on_sock.o \
> >> >> -               udp_offload.o seg6.o fib6_notifier.o rpl.o
> >> >> +               udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
> >> >>
> >> >>  ipv6-offload :=3D        ip6_offload.o tcpv6_offload.o exthdrs_off=
load.o
> >> >>
> >> >> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> >> >> index 840bfdb3d7bd..6c952a28ade2 100644
> >> >> --- a/net/ipv6/addrconf.c
> >> >> +++ b/net/ipv6/addrconf.c
> >> >> @@ -236,6 +236,8 @@ static struct ipv6_devconf ipv6_devconf __read_=
mostly =3D {
> >> >>         .addr_gen_mode          =3D IN6_ADDR_GEN_MODE_EUI64,
> >> >>         .disable_policy         =3D 0,
> >> >>         .rpl_seg_enabled        =3D 0,
> >> >> +       .ioam6_enabled          =3D 0,
> >> >> +       .ioam6_id               =3D 0,
> >> >>  };
> >> >>
> >> >>  static struct ipv6_devconf ipv6_devconf_dflt __read_mostly =3D {
> >> >> @@ -291,6 +293,8 @@ static struct ipv6_devconf ipv6_devconf_dflt __=
read_mostly =3D
> >> >> {
> >> >>         .addr_gen_mode          =3D IN6_ADDR_GEN_MODE_EUI64,
> >> >>         .disable_policy         =3D 0,
> >> >>         .rpl_seg_enabled        =3D 0,
> >> >> +       .ioam6_enabled          =3D 0,
> >> >> +       .ioam6_id               =3D 0,
> >> >>  };
> >> >>
> >> >>  /* Check if link is ready: is it up and is a valid qdisc available=
 */
> >> >> @@ -5487,6 +5491,8 @@ static inline void ipv6_store_devconf(struct =
ipv6_devconf
> >> >> *cnf,
> >> >>         array[DEVCONF_DISABLE_POLICY] =3D cnf->disable_policy;
> >> >>         array[DEVCONF_NDISC_TCLASS] =3D cnf->ndisc_tclass;
> >> >>         array[DEVCONF_RPL_SEG_ENABLED] =3D cnf->rpl_seg_enabled;
> >> >> +       array[DEVCONF_IOAM6_ENABLED] =3D cnf->ioam6_enabled;
> >> >> +       array[DEVCONF_IOAM6_ID] =3D cnf->ioam6_id;
> >> >>  }
> >> >>
> >> >>  static inline size_t inet6_ifla6_size(void)
> >> >> @@ -6867,6 +6873,20 @@ static const struct ctl_table addrconf_sysct=
l[] =3D {
> >> >>                 .mode           =3D 0644,
> >> >>                 .proc_handler   =3D proc_dointvec,
> >> >>         },
> >> >> +       {
> >> >> +               .procname       =3D "ioam6_enabled",
> >> >> +               .data           =3D &ipv6_devconf.ioam6_enabled,
> >> >> +               .maxlen         =3D sizeof(int),
> >> >> +               .mode           =3D 0644,
> >> >> +               .proc_handler   =3D proc_dointvec,
> >> >> +       },
> >> >> +       {
> >> >> +               .procname       =3D "ioam6_id",
> >> >> +               .data           =3D &ipv6_devconf.ioam6_id,
> >> >> +               .maxlen         =3D sizeof(int),
> >> >> +               .mode           =3D 0644,
> >> >> +               .proc_handler   =3D proc_dointvec,
> >> >> +       },
> >> >>         {
> >> >>                 /* sentinel */
> >> >>         }
> >> >> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> >> >> index b304b882e031..63a9ffc4b283 100644
> >> >> --- a/net/ipv6/af_inet6.c
> >> >> +++ b/net/ipv6/af_inet6.c
> >> >> @@ -62,6 +62,7 @@
> >> >>  #include <net/rpl.h>
> >> >>  #include <net/compat.h>
> >> >>  #include <net/xfrm.h>
> >> >> +#include <net/ioam6.h>
> >> >>
> >> >>  #include <linux/uaccess.h>
> >> >>  #include <linux/mroute6.h>
> >> >> @@ -1187,6 +1188,10 @@ static int __init inet6_init(void)
> >> >>         if (err)
> >> >>                 goto rpl_fail;
> >> >>
> >> >> +       err =3D ioam6_init();
> >> >> +       if (err)
> >> >> +               goto ioam6_fail;
> >> >> +
> >> >>         err =3D igmp6_late_init();
> >> >>         if (err)
> >> >>                 goto igmp6_late_err;
> >> >> @@ -1210,6 +1215,8 @@ static int __init inet6_init(void)
> >> >>  #endif
> >> >>  igmp6_late_err:
> >> >>         rpl_exit();
> >> >> +ioam6_fail:
> >> >> +       ioam6_exit();
> >> >>  rpl_fail:
> >> >>         seg6_exit();
> >> >>  seg6_fail:
> >> >> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> >> >> index f27ab3bf2e0c..00aee1358f1c 100644
> >> >> --- a/net/ipv6/exthdrs.c
> >> >> +++ b/net/ipv6/exthdrs.c
> >> >> @@ -49,6 +49,8 @@
> >> >>  #include <net/seg6_hmac.h>
> >> >>  #endif
> >> >>  #include <net/rpl.h>
> >> >> +#include <net/ioam6.h>
> >> >> +#include <net/dst_metadata.h>
> >> >>
> >> >>  #include <linux/uaccess.h>
> >> >>
> >> >> @@ -1010,6 +1012,67 @@ static int ipv6_hop_ra(struct sk_buff *skb, =
int optoff)
> >> >>         return TLV_REJECT;
> >> >>  }
> >> >>
> >> >> +/* IOAM */
> >> >> +
> >> >> +static int ipv6_hop_ioam(struct sk_buff *skb, int optoff)
> >> >> +{
> >> >> +       struct ioam6_common_hdr *ioamh;
> >> >> +       struct ioam6_namespace *ns;
> >> >> +
> >> >> +       /* Must be 4n-aligned */
> >> >> +       if (optoff & 3)
> >> >> +               goto drop;
> >> >> +
> >> >> +       if (!skb_valid_dst(skb))
> >> >> +               ip6_route_input(skb);
> >> >> +
> >> >> +       /* IOAM must be enabled on ingress interface */
> >> >> +       if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
> >> >> +               goto drop;
> >> >> +
> >> >> +       ioamh =3D (struct ioam6_common_hdr *)(skb_network_header(sk=
b) + optoff);
> >> >> +       ns =3D ioam6_namespace(ipv6_skb_net(skb), ioamh->namespace_=
id);
> >> >> +
> >> >> +       /* Unknown IOAM namespace, either:
> >> >> +        *  - Drop it if IOAM is not enabled on egress interface (i=
f any)
> >> >> +        *  - Ignore it otherwise
> >> >> +        */
> >> >> +       if (!ns) {
> >> >> +               if (!__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_en=
abled &&
> >> >> +                   !(skb_dst(skb)->dev->flags & IFF_LOOPBACK))
> >> >> +                       goto drop;
> >> >> +
> >> >> +               goto accept;
> >> >> +       }
> >> >> +
> >> >> +       if (ns->remove_tlv && !(skb_dst(skb)->dev->flags & IFF_LOOP=
BACK))
> >> >> +               goto remove;
> >> >> +
> >> >> +       /* Known IOAM namespace which must not be removed:
> >> >> +        * IOAM must be enabled on egress interface
> >> >> +        */
> >> >> +       if (!__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_enabled &&
> >> >> +           !(skb_dst(skb)->dev->flags & IFF_LOOPBACK))
> >> >> +               goto drop;
> >> >> +
> >> >> +       switch (ioamh->ioam_type) {
> >> >> +       case IOAM6_OPT_TRACE_PREALLOC:
> >> >> +               ioam6_fill_trace_data(skb, optoff + sizeof(*ioamh),=
 ns);
> >> >> +               IP6CB(skb)->flags |=3D IP6SKB_IOAM;
> >> >> +               break;
> >> >> +       default:
> >> >> +               break;
> >> >> +       }
> >> >> +
> >> >> +accept:
> >> >> +       return TLV_ACCEPT;
> >> >> +remove:
> >> >> +       return TLV_REMOVE;
> >> >> +drop:
> >> >> +       kfree_skb(skb);
> >> >> +       return TLV_REJECT;
> >> >> +}
> >> >> +
> >> >>  /* Jumbo payload */
> >> >>
> >> >>  static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> >> >> @@ -1081,6 +1144,10 @@ static const struct tlvtype_proc tlvprochopo=
pt_lst[] =3D {
> >> >>                 .type   =3D IPV6_TLV_ROUTERALERT,
> >> >>                 .func   =3D ipv6_hop_ra,
> >> >>         },
> >> >> +       {
> >> >> +               .type   =3D IPV6_TLV_IOAM_HOPOPTS,
> >> >> +               .func   =3D ipv6_hop_ioam,
> >> >> +       },
> >> >>         {
> >> >>                 .type   =3D IPV6_TLV_JUMBO,
> >> >>                 .func   =3D ipv6_hop_jumbo,
> >> >> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> >> >> new file mode 100644
> >> >> index 000000000000..406aa78eb504
> >> >> --- /dev/null
> >> >> +++ b/net/ipv6/ioam6.c
> >> >> @@ -0,0 +1,326 @@
> >> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >> >> +/*
> >> >> + *  IOAM IPv6 implementation
> >> >> + *
> >> >> + *  Author:
> >> >> + *  Justin Iurman <justin.iurman@uliege.be>
> >> >> + */
> >> >> +
> >> >> +#include <linux/errno.h>
> >> >> +#include <linux/types.h>
> >> >> +#include <linux/kernel.h>
> >> >> +#include <linux/net.h>
> >> >> +#include <linux/rhashtable.h>
> >> >> +
> >> >> +#include <net/addrconf.h>
> >> >> +#include <net/ioam6.h>
> >> >> +
> >> >> +static inline void ioam6_ns_release(struct ioam6_namespace *ns)
> >> >> +{
> >> >> +       kfree_rcu(ns, rcu);
> >> >> +}
> >> >> +
> >> >> +static inline void ioam6_sc_release(struct ioam6_schema *sc)
> >> >> +{
> >> >> +       kfree_rcu(sc, rcu);
> >> >> +}
> >> >> +
> >> >> +static void ioam6_free_ns(void *ptr, void *arg)
> >> >> +{
> >> >> +       struct ioam6_namespace *ns =3D (struct ioam6_namespace *)pt=
r;
> >> >> +
> >> >> +       if (ns)
> >> >> +               ioam6_ns_release(ns);
> >> >> +}
> >> >> +
> >> >> +static void ioam6_free_sc(void *ptr, void *arg)
> >> >> +{
> >> >> +       struct ioam6_schema *sc =3D (struct ioam6_schema *)ptr;
> >> >> +
> >> >> +       if (sc)
> >> >> +               ioam6_sc_release(sc);
> >> >> +}
> >> >> +
> >> >> +static int ioam6_ns_cmpfn(struct rhashtable_compare_arg *arg, cons=
t void *obj)
> >> >> +{
> >> >> +       const struct ioam6_namespace *ns =3D obj;
> >> >> +
> >> >> +       return (ns->id !=3D *(__be16 *)arg->key);
> >> >> +}
> >> >> +
> >> >> +static int ioam6_sc_cmpfn(struct rhashtable_compare_arg *arg, cons=
t void *obj)
> >> >> +{
> >> >> +       const struct ioam6_schema *sc =3D obj;
> >> >> +
> >> >> +       return (sc->id !=3D *(u32 *)arg->key);
> >> >> +}
> >> >> +
> >> >> +static const struct rhashtable_params rht_ns_params =3D {
> >> >> +       .key_len                =3D sizeof(__be16),
> >> >> +       .key_offset             =3D offsetof(struct ioam6_namespace=
, id),
> >> >> +       .head_offset            =3D offsetof(struct ioam6_namespace=
, head),
> >> >> +       .automatic_shrinking    =3D true,
> >> >> +       .obj_cmpfn              =3D ioam6_ns_cmpfn,
> >> >> +};
> >> >> +
> >> >> +static const struct rhashtable_params rht_sc_params =3D {
> >> >> +       .key_len                =3D sizeof(u32),
> >> >> +       .key_offset             =3D offsetof(struct ioam6_schema, i=
d),
> >> >> +       .head_offset            =3D offsetof(struct ioam6_schema, h=
ead),
> >> >> +       .automatic_shrinking    =3D true,
> >> >> +       .obj_cmpfn              =3D ioam6_sc_cmpfn,
> >> >> +};
> >> >> +
> >> >> +struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id=
)
> >> >> +{
> >> >> +       struct ioam6_pernet_data *nsdata =3D ioam6_pernet(net);
> >> >> +
> >> >> +       return rhashtable_lookup_fast(&nsdata->namespaces, &id, rht=
_ns_params);
> >> >> +}
> >> >> +
> >> >> +void ioam6_fill_trace_data_node(struct sk_buff *skb, int nodeoff,
> >> >> +                               u32 trace_type, struct ioam6_namesp=
ace *ns)
> >> >> +{
> >> >> +       u8 *data =3D skb_network_header(skb) + nodeoff;
> >> >> +       struct __kernel_sock_timeval ts;
> >> >> +       u64 raw_u64;
> >> >> +       u32 raw_u32;
> >> >> +       u16 raw_u16;
> >> >> +       u8 byte;
> >> >> +
> >> >> +       /* hop_lim and node_id */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE0) {
> >> >> +               byte =3D ipv6_hdr(skb)->hop_limit - 1;
> >> >> +               raw_u32 =3D dev_net(skb->dev)->ipv6.sysctl.ioam6_id=
;
> >> >> +               if (!raw_u32)
> >> >> +                       raw_u32 =3D IOAM6_EMPTY_FIELD_u24;
> >> >> +               else
> >> >> +                       raw_u32 &=3D IOAM6_EMPTY_FIELD_u24;
> >> >> +               *(__be32 *)data =3D cpu_to_be32((byte << 24) | raw_=
u32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* ingress_if_id and egress_if_id */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE1) {
> >> >> +               raw_u16 =3D __in6_dev_get(skb->dev)->cnf.ioam6_id;
> >> >> +               if (!raw_u16)
> >> >> +                       raw_u16 =3D IOAM6_EMPTY_FIELD_u16;
> >> >> +               *(__be16 *)data =3D cpu_to_be16(raw_u16);
> >> >> +               data +=3D sizeof(__be16);
> >> >> +
> >> >> +               raw_u16 =3D __in6_dev_get(skb_dst(skb)->dev)->cnf.i=
oam6_id;
> >> >> +               if (!raw_u16)
> >> >> +                       raw_u16 =3D IOAM6_EMPTY_FIELD_u16;
> >> >> +               *(__be16 *)data =3D cpu_to_be16(raw_u16);
> >> >> +               data +=3D sizeof(__be16);
> >> >> +       }
> >> >> +
> >> >> +       /* timestamp seconds */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE2) {
> >> >> +               if (!skb->tstamp) {
> >> >> +                       *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY=
_FIELD_u32);
> >> >> +               } else {
> >> >> +                       skb_get_new_timestamp(skb, &ts);
> >> >> +                       *(__be32 *)data =3D cpu_to_be32((u32)ts.tv_=
sec);
> >> >> +               }
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* timestamp subseconds */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE3) {
> >> >> +               if (!skb->tstamp) {
> >> >> +                       *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY=
_FIELD_u32);
> >> >> +               } else {
> >> >> +                       if (!(trace_type & IOAM6_TRACE_TYPE2))
> >> >> +                               skb_get_new_timestamp(skb, &ts);
> >> >> +                       *(__be32 *)data =3D cpu_to_be32((u32)ts.tv_=
usec);
> >> >> +               }
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* transit delay */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE4) {
> >> >> +               *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY_FIELD_u=
32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* namespace data */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE5) {
> >> >> +               *(__be32 *)data =3D (__be32)ns->data;
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* queue depth */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE6) {
> >> >> +               *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY_FIELD_u=
32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* hop_lim and node_id (wide) */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE7) {
> >> >> +               byte =3D ipv6_hdr(skb)->hop_limit - 1;
> >> >> +               raw_u64 =3D dev_net(skb->dev)->ipv6.sysctl.ioam6_id=
;
> >> >> +               if (!raw_u64)
> >> >> +                       raw_u64 =3D IOAM6_EMPTY_FIELD_u56;
> >> >> +               else
> >> >> +                       raw_u64 &=3D IOAM6_EMPTY_FIELD_u56;
> >> >> +               *(__be64 *)data =3D cpu_to_be64(((u64)byte << 56) |=
 raw_u64);
> >> >> +               data +=3D sizeof(__be64);
> >> >> +       }
> >> >> +
> >> >> +       /* ingress_if_id and egress_if_id (wide) */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE8) {
> >> >> +               raw_u32 =3D __in6_dev_get(skb->dev)->cnf.ioam6_id;
> >> >> +               if (!raw_u32)
> >> >> +                       raw_u32 =3D IOAM6_EMPTY_FIELD_u32;
> >> >> +               *(__be32 *)data =3D cpu_to_be32(raw_u32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +
> >> >> +               raw_u32 =3D __in6_dev_get(skb_dst(skb)->dev)->cnf.i=
oam6_id;
> >> >> +               if (!raw_u32)
> >> >> +                       raw_u32 =3D IOAM6_EMPTY_FIELD_u32;
> >> >> +               *(__be32 *)data =3D cpu_to_be32(raw_u32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* namespace data (wide) */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE9) {
> >> >> +               *(__be64 *)data =3D ns->data;
> >> >> +               data +=3D sizeof(__be64);
> >> >> +       }
> >> >> +
> >> >> +       /* buffer occupancy */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE10) {
> >> >> +               *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY_FIELD_u=
32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* checksum complement */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE11) {
> >> >> +               *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY_FIELD_u=
32);
> >> >> +               data +=3D sizeof(__be32);
> >> >> +       }
> >> >> +
> >> >> +       /* opaque state snapshot */
> >> >> +       if (trace_type & IOAM6_TRACE_TYPE22) {
> >> >> +               if (!ns->schema) {
> >> >> +                       *(__be32 *)data =3D cpu_to_be32(IOAM6_EMPTY=
_FIELD_u24);
> >> >> +               } else {
> >> >> +                       *(__be32 *)data =3D ns->schema->hdr;
> >> >> +                       data +=3D sizeof(__be32);
> >> >> +                       memcpy(data, ns->schema->data, ns->schema->=
len);
> >> >> +               }
> >> >> +       }
> >> >> +}
> >> >> +
> >> >> +void ioam6_fill_trace_data(struct sk_buff *skb, int traceoff,
> >> >> +                          struct ioam6_namespace *ns)
> >> >> +{
> >> >> +       u8 nodelen, flags, remlen, sclen =3D 0;
> >> >> +       struct ioam6_trace_hdr *trh;
> >> >> +       int nodeoff;
> >> >> +       u16 info;
> >> >> +       u32 type;
> >> >> +
> >> >> +       trh =3D (struct ioam6_trace_hdr *)(skb_network_header(skb) =
+ traceoff);
> >> >> +       info =3D be16_to_cpu(trh->info);
> >> >> +       type =3D be32_to_cpu(trh->type);
> >> >> +
> >> >> +       nodelen =3D info >> 11;
> >> >> +       flags =3D (info >> 7) & 0xf;
> >> >> +       remlen =3D info & 0x7f;
> >> >> +
> >> >> +       /* Skip if Overflow bit is set OR
> >> >> +        * if an unknown type (bit 12-21) is set
> >> >> +        */
> >> >> +       if ((flags & IOAM6_TRACE_FLAG_OVERFLOW) || (type & 0xffc00)=
)
> >> >> +               return;
> >> >> +
> >> >> +       /* NodeLen does not include Opaque State Snapshot length. W=
e need to
> >> >> +        * take it into account if the corresponding bit is set and=
 if current
> >> >> +        * IOAM namespace has an active schema attached to it
> >> >> +        */
> >> >> +       if (type & IOAM6_TRACE_TYPE22) {
> >> >> +               /* Opaque State Snapshot header size */
> >> >> +               sclen =3D sizeof_field(struct ioam6_schema, hdr) / =
4;
> >> >> +
> >> >> +               if (ns->schema)
> >> >> +                       sclen +=3D ns->schema->len / 4;
> >> >> +       }
> >> >> +
> >> >> +       /* Not enough space remaining: set Overflow bit and skip */
> >> >> +       if (!remlen || remlen < (nodelen + sclen)) {
> >> >> +               info |=3D IOAM6_TRACE_FLAG_OVERFLOW << 7;
> >> >> +               trh->info =3D cpu_to_be16(info);
> >> >> +               return;
> >> >> +       }
> >> >> +
> >> >> +       nodeoff =3D traceoff + sizeof(*trh) + remlen*4 - nodelen*4 =
- sclen*4;
> >> >> +       ioam6_fill_trace_data_node(skb, nodeoff, type, ns);
> >> >> +
> >> >> +       /* Update RemainingLen */
> >> >> +       remlen -=3D nodelen + sclen;
> >> >> +       info =3D (info & 0xff80) | remlen;
> >> >> +       trh->info =3D cpu_to_be16(info);
> >> >> +}
> >> >> +
> >> >> +static int __net_init ioam6_net_init(struct net *net)
> >> >> +{
> >> >> +       struct ioam6_pernet_data *nsdata;
> >> >> +       int err =3D -ENOMEM;
> >> >> +
> >> >> +       nsdata =3D kzalloc(sizeof(*nsdata), GFP_KERNEL);
> >> >> +       if (!nsdata)
> >> >> +               goto out;
> >> >> +
> >> >> +       mutex_init(&nsdata->lock);
> >> >> +       net->ipv6.ioam6_data =3D nsdata;
> >> >> +
> >> >> +       err =3D rhashtable_init(&nsdata->namespaces, &rht_ns_params=
);
> >> >> +       if (err)
> >> >> +               goto free_nsdata;
> >> >> +
> >> >> +       err =3D rhashtable_init(&nsdata->schemas, &rht_sc_params);
> >> >> +       if (err)
> >> >> +               goto free_rht_ns;
> >> >> +
> >> >> +out:
> >> >> +       return err;
> >> >> +free_rht_ns:
> >> >> +       rhashtable_destroy(&nsdata->namespaces);
> >> >> +free_nsdata:
> >> >> +       kfree(nsdata);
> >> >> +       net->ipv6.ioam6_data =3D NULL;
> >> >> +       goto out;
> >> >> +}
> >> >> +
> >> >> +static void __net_exit ioam6_net_exit(struct net *net)
> >> >> +{
> >> >> +       struct ioam6_pernet_data *nsdata =3D ioam6_pernet(net);
> >> >> +
> >> >> +       rhashtable_free_and_destroy(&nsdata->namespaces, ioam6_free=
_ns, NULL);
> >> >> +       rhashtable_free_and_destroy(&nsdata->schemas, ioam6_free_sc=
, NULL);
> >> >> +
> >> >> +       kfree(nsdata);
> >> >> +}
> >> >> +
> >> >> +static struct pernet_operations ioam6_net_ops =3D {
> >> >> +       .init =3D ioam6_net_init,
> >> >> +       .exit =3D ioam6_net_exit,
> >> >> +};
> >> >> +
> >> >> +int __init ioam6_init(void)
> >> >> +{
> >> >> +       int err =3D register_pernet_subsys(&ioam6_net_ops);
> >> >> +
> >> >> +       if (err)
> >> >> +               return err;
> >> >> +
> >> >> +       pr_info("In-situ OAM (IOAM) with IPv6\n");
> >> >> +       return 0;
> >> >> +}
> >> >> +
> >> >> +void ioam6_exit(void)
> >> >> +{
> >> >> +       unregister_pernet_subsys(&ioam6_net_ops);
> >> >> +}
> >> >> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.=
c
> >> >> index fac2135aa47b..da49b33ab6fc 100644
> >> >> --- a/net/ipv6/sysctl_net_ipv6.c
> >> >> +++ b/net/ipv6/sysctl_net_ipv6.c
> >> >> @@ -159,6 +159,13 @@ static struct ctl_table ipv6_table_template[] =
=3D {
> >> >>                 .mode           =3D 0644,
> >> >>                 .proc_handler   =3D proc_dointvec
> >> >>         },
> >> >> +       {
> >> >> +               .procname       =3D "ioam6_id",
> >> >> +               .data           =3D &init_net.ipv6.sysctl.ioam6_id,
> >> >> +               .maxlen         =3D sizeof(int),
> >> >> +               .mode           =3D 0644,
> >> >> +               .proc_handler   =3D proc_dointvec
> >> >> +       },
> >> >>         { }
> >> >>  };
> >> >>
> >> >> --
> > > >> 2.17.1
