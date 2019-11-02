Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4E4ECC2E
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfKBAMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:12:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727025AbfKBAMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572653563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xS0gGjv6iMlxX4rkF9w/Sr3jIbDT7i0xNvkGl3SCIG4=;
        b=HZdaFd0WDuDxi4qjdplTe2Ms7MDLCJwR/cvIxAJLHvp68sWPE5gdgC/tA8Gs5m9jaZRqtM
        w8PtTdu4EEh87AF1lOheh3h2CvoNb5BIr5sGfmXRuTGi9BB2QVRJPj6E3w4boYmS7eejBb
        s0/KbuHDqAAycN2y6frvRt61CMk5wzE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-Kx9ax-G5OriqGdQ4FKxR5g-1; Fri, 01 Nov 2019 20:12:38 -0400
Received: by mail-wm1-f69.google.com with SMTP id g17so4862644wmc.4
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 17:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPhKHvT3az+LN4tzL4Ab13kYC7t6UbHWZLXwUYXDHsw=;
        b=m0BGkPwv4AyAGRWxy/VRm8jURzoDBU8Imq/Im21/91Q8V54gF5h/7UJmkUShqitcs5
         2jVhElVt0BIfZrFuCW8ErVz6lrj4wS/TLO2UfVhyZ3WmDIS3ixiDtPjcWr4t4r2upFgz
         RlUoMOeINTyrup/x0A4ogPirdEdbWXCAx8tKBAq+XUimBoOkzan2JAlDj46Hnj9CZuq7
         adQFEnYWQ6C5GGOQNdeWB1sUWFSshDJWplXIS+HQgw9/aVMzVZa+pUoD7DT+/Jlis6IB
         hCfQ0UGgAr68T5UovsHyDwQdXbf0LgHo0svXSkVDAmfLrcKwJJoKJ9J9XS3G8Gi7Y/w9
         Famw==
X-Gm-Message-State: APjAAAV1Lq4ZEDEq1nrxpBFNgy2dGbrACEKTlNm/rdzhgdLLDq1IH+Es
        zgZ7UejiFNFxbnI9XgRxB3rf8L+Tp/upeE1t3G63w8T1w/HdgwI8M6lGG4f6XK4FPaZzfZtX4mN
        I+QvAll7mbPTzsVlJ
X-Received: by 2002:a1c:650b:: with SMTP id z11mr12398837wmb.149.1572653556959;
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzGzwlL1BmpHGqMa5YujOM+Ri+mxFUH/onLw/RykU/GB1adIBjHhPV9XtS1itc2Amri94aT9g==
X-Received: by 2002:a1c:650b:: with SMTP id z11mr12398815wmb.149.1572653556671;
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
Received: from raver.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id c14sm8323774wru.24.2019.11.01.17.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:12:36 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] icmp: remove duplicate code
Date:   Sat,  2 Nov 2019 01:12:04 +0100
Message-Id: <20191102001204.83883-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: Kx9ax-G5OriqGdQ4FKxR5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same code which recognizes ICMP error packets is duplicated several
times. Use the icmp_is_err() and icmpv6_is_err() helpers instead, which
do the same thing.

ip_multipath_l3_keys() and tcf_nat_act() didn't check for all the error typ=
es,
assume that they should instead.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/ipv4/netfilter/nf_socket_ipv4.c     | 10 +---------
 net/ipv4/route.c                        |  5 +----
 net/ipv6/route.c                        |  5 +----
 net/netfilter/nf_conntrack_proto_icmp.c |  6 +-----
 net/netfilter/xt_HMARK.c                |  6 +-----
 net/sched/act_nat.c                     |  4 +---
 6 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_so=
cket_ipv4.c
index 36a28d46149c..c94445b44d8c 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -31,16 +31,8 @@ extract_icmp4_fields(const struct sk_buff *skb, u8 *prot=
ocol,
 =09if (icmph =3D=3D NULL)
 =09=09return 1;
=20
-=09switch (icmph->type) {
-=09case ICMP_DEST_UNREACH:
-=09case ICMP_SOURCE_QUENCH:
-=09case ICMP_REDIRECT:
-=09case ICMP_TIME_EXCEEDED:
-=09case ICMP_PARAMETERPROB:
-=09=09break;
-=09default:
+=09if (!icmp_is_err(icmph->type))
 =09=09return 1;
-=09}
=20
 =09inside_iph =3D skb_header_pointer(skb, outside_hdrlen +
 =09=09=09=09=09sizeof(struct icmphdr),
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 621f83434b24..dcc4fa10138d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1894,10 +1894,7 @@ static void ip_multipath_l3_keys(const struct sk_buf=
f *skb,
 =09if (!icmph)
 =09=09goto out;
=20
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_REDIRECT &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB)
+=09if (!icmp_is_err(icmph->type))
 =09=09goto out;
=20
 =09inner_iph =3D skb_header_pointer(skb,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a63ff85fe141..3f3085ab2832 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2291,10 +2291,7 @@ static void ip6_multipath_l3_keys(const struct sk_bu=
ff *skb,
 =09if (!icmph)
 =09=09goto out;
=20
-=09if (icmph->icmp6_type !=3D ICMPV6_DEST_UNREACH &&
-=09    icmph->icmp6_type !=3D ICMPV6_PKT_TOOBIG &&
-=09    icmph->icmp6_type !=3D ICMPV6_TIME_EXCEED &&
-=09    icmph->icmp6_type !=3D ICMPV6_PARAMPROB)
+=09if (!icmpv6_is_err(icmph->icmp6_type))
 =09=09goto out;
=20
 =09inner_iph =3D skb_header_pointer(skb,
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_con=
ntrack_proto_icmp.c
index 097deba7441a..c2e3dff773bc 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -235,11 +235,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 =09}
=20
 =09/* Need to track icmp error message? */
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_SOURCE_QUENCH &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB &&
-=09    icmph->type !=3D ICMP_REDIRECT)
+=09if (!icmp_is_err(icmph->type))
 =09=09return NF_ACCEPT;
=20
 =09memset(&outer_daddr, 0, sizeof(outer_daddr));
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index be7798a50546..713fb38541df 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -239,11 +239,7 @@ static int get_inner_hdr(const struct sk_buff *skb, in=
t iphsz, int *nhoff)
 =09=09return 0;
=20
 =09/* Error message? */
-=09if (icmph->type !=3D ICMP_DEST_UNREACH &&
-=09    icmph->type !=3D ICMP_SOURCE_QUENCH &&
-=09    icmph->type !=3D ICMP_TIME_EXCEEDED &&
-=09    icmph->type !=3D ICMP_PARAMETERPROB &&
-=09    icmph->type !=3D ICMP_REDIRECT)
+=09if (!icmp_is_err(icmph->type))
 =09=09return 0;
=20
 =09*nhoff +=3D iphsz + sizeof(_ih);
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 88a1b79a1848..855a6fa16a62 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -206,9 +206,7 @@ static int tcf_nat_act(struct sk_buff *skb, const struc=
t tc_action *a,
=20
 =09=09icmph =3D (void *)(skb_network_header(skb) + ihl);
=20
-=09=09if ((icmph->type !=3D ICMP_DEST_UNREACH) &&
-=09=09    (icmph->type !=3D ICMP_TIME_EXCEEDED) &&
-=09=09    (icmph->type !=3D ICMP_PARAMETERPROB))
+=09=09if (!icmp_is_err(icmph->type))
 =09=09=09break;
=20
 =09=09if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph) +
--=20
2.23.0

