Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0799153
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbfHVKsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:48:31 -0400
Received: from mail-eopbgr30116.outbound.protection.outlook.com ([40.107.3.116]:35547
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbfHVKsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:48:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnENphKlyeuLFbPi1TYJK8z841Y0uPeUtrlLKOW9hwWr8AYbOJ3T840U+OVKFfZfCA8PU7rbxQimHZqXawFFH6j6gaEoRdA1xCX+oMEAij9P1CSfVPB/ylTSoG61X4rtjC7BRKm8dWuUaX1lkT4oHyjE7lnt/VJcx05iK4Y1NJmDMUavfONzQVNQ3+XYfjjuYzClNvdx4WmcJzEOCNaOKRlY3TKBClfyzRpghUJEuLl1stmJa9Mn5fJFKi+9BH1Z6qi9QYqQ9DiufW4CoFKEpb55xdg1aAc6pJz6jDL5/xPKPVyuBu6+1Z0/WXPyONY2UjpOjZ3jIAxDH6Ph5hBfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfTa33g5ZatRTEUQyX5Vl2JhKhlNI6d1gj0uhhdwg9A=;
 b=TNm451kgQM/y/MTT3kBujTM/OM0tQA92v5HSmMUICtoj0CsYhtOSEBoRrHZ+9Ys9skPfxiWssgVCxxAKL52mC3D52UdVe3BwmhTSNmIlA2SctGrwD6r6CtaJVpCiiHGtWJhpcsejobZz6aeIu8HBUQVL/fKZ7vTWqU344gpQRXmNtpTZW0gornUXUTH0SqO38c37QgEmRriEqnZ2N2ybcGWUjvTHD35LvA0ASR8J+jAVdvhLW3LhRXDXW0b9bKB74F2yQJ41ivjjSj5Np3hz2e2W6iTdTu7MMXYB7Y6L0cQux3Dw8O8ixuqFh0jVR4bZavsOmDGdEwxza158d3qTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfTa33g5ZatRTEUQyX5Vl2JhKhlNI6d1gj0uhhdwg9A=;
 b=NJ4qV9KTj17RZUCJEQtiUnAaJq79BECWUBNamYDHualj4MNHF/tLbVzokS3P0lqRD+nUriwYFbt0khkGepUrIu/JjaN4LwqsyB6MZR3a9WO++nghUeEQI12iJMzipKRWey61a1bJdc4kLoAReaQ/tX08FhjT13RtZWhMkAt7rA4=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB2655.eurprd08.prod.outlook.com (10.175.245.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 10:48:27 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:48:27 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Denis Lunev <den@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        "jan.dakinevich@gmail.com" <jan.dakinevich@gmail.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Alexey Kuznetsov (C)" <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Christian Brauner <christian@brauner.io>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        John Hurley <john.hurley@netronome.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Patrick Talbert <ptalbert@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Safonov <dima@arista.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: [PATCH 2/3] netlink: always use vmapped memory for skb data
Thread-Topic: [PATCH 2/3] netlink: always use vmapped memory for skb data
Thread-Index: AQHVWNcggH+/9Hb6pEiE6Ef0u5yieA==
Date:   Thu, 22 Aug 2019 10:48:27 +0000
Message-ID: <1566470851-4694-3-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1566470851-4694-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1566470851-4694-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0202CA0033.eurprd02.prod.outlook.com
 (2603:10a6:3:e4::19) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1b3218a-f7e0-42a8-e229-08d726ee4346
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB2655;
x-ms-traffictypediagnostic: VI1PR08MB2655:
x-ld-processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB26554BFE40027216E7F25BDC8AA50@VI1PR08MB2655.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39840400004)(199004)(189003)(2616005)(99286004)(66476007)(66946007)(66556008)(5660300002)(476003)(64756008)(76176011)(6116002)(66446008)(446003)(8936002)(3846002)(478600001)(6506007)(11346002)(386003)(81166006)(7406005)(81156014)(44832011)(316002)(52116002)(8676002)(14444005)(5024004)(305945005)(6486002)(256004)(5640700003)(86362001)(71200400001)(6512007)(102836004)(14454004)(7736002)(6436002)(186003)(7416002)(486006)(50226002)(66066001)(2906002)(6916009)(36756003)(2501003)(53936002)(2351001)(71190400001)(25786009)(4326008)(54906003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2655;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iS4JV1ybZKELsJooNev80z55Kej37h1j6FL+XRTQ8dGVAN3jZ7hRsnvquogUIowAEkRuPy4BFobMkaaR/8Pw8BGRpmjpp7oBdCUIh/pqZ5s8hxm6g6xz0HGo41Mwr+DvqR0rnc5/QPCK42oQQm+j+QLZV4wjB52+pwjvwJ3byyKDKlHhvAp2GrPxcB/X/1FYs+wShOdpa2Bpvn7klnrBmkBEKX2GcqM+2yOqkHFHLy1aWxGwD1rkk8lhE6c5LvYyofeOninneq1+M/aBdzT9DXBzrOU/tNgAW7zpi8S1EP5F5wh3UJEUd5LM5/EZIs0lP5wGgICCxGCVk1xI9+t0pjJ5n6+Blx+qaSSxQIJMt4KL6k6eYxhAVCXeOH9XqriEbyZ9tuDHfe8GitwD9EJunhS3cgFhGdHynWXQIi9cEks=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b3218a-f7e0-42a8-e229-08d726ee4346
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:48:27.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1hjL1+LG2HRpyg+orzpUeRCylw7bDgJLvOD0v52qPHdw3ffSSx5Tfn+Cw0Wi9mQvB4xIrVuKVe3GO0roopyor0+qnCJPvnKVoxijncajmso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't make an exception for broadcast skb and allocate buffer for it in
the same way as for unicast skb.

 - this makes needless calling of special destructor to free memory
   under ->head,

 - ...then, there is no need to reassign this destructor to cloned skb,

 - ...then, netlink_skb_clone() become equal to generic skb_clone()
   and can be dropped.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 include/linux/netlink.h   | 16 ----------------
 net/ipv4/fib_frontend.c   |  2 +-
 net/netfilter/nfnetlink.c |  2 +-
 net/netlink/af_netlink.c  | 16 +++-------------
 4 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 205fa7b..daacffc 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -146,22 +146,6 @@ int netlink_attachskb(struct sock *sk, struct sk_buff =
*skb,
 void netlink_detachskb(struct sock *sk, struct sk_buff *skb);
 int netlink_sendskb(struct sock *sk, struct sk_buff *skb);
=20
-static inline struct sk_buff *
-netlink_skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
-{
-	struct sk_buff *nskb;
-
-	nskb =3D skb_clone(skb, gfp_mask);
-	if (!nskb)
-		return NULL;
-
-	/* This is a large skb, set destructor callback to release head */
-	if (is_vmalloc_addr(skb->head))
-		nskb->destructor =3D skb->destructor;
-
-	return nskb;
-}
-
 /*
  *	skb should fit one page. This choice is good for headerless malloc.
  *	But we should limit to 8K so that userspace does not have to
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index e8bc939..cbbd75d 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1371,7 +1371,7 @@ static void nl_fib_input(struct sk_buff *skb)
 	    nlmsg_len(nlh) < sizeof(*frn))
 		return;
=20
-	skb =3D netlink_skb_clone(skb, GFP_KERNEL);
+	skb =3D skb_clone(skb, GFP_KERNEL);
 	if (!skb)
 		return;
 	nlh =3D nlmsg_hdr(skb);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abbb45..6ae22c9c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -311,7 +311,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, st=
ruct nlmsghdr *nlh,
 replay:
 	status =3D 0;
=20
-	skb =3D netlink_skb_clone(oskb, GFP_KERNEL);
+	skb =3D skb_clone(oskb, GFP_KERNEL);
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 90b2ab9..04a3457 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -360,13 +360,6 @@ static void netlink_rcv_wake(struct sock *sk)
=20
 static void netlink_skb_destructor(struct sk_buff *skb)
 {
-	if (is_vmalloc_addr(skb->head)) {
-		if (!skb->cloned ||
-		    !atomic_dec_return(&(skb_shinfo(skb)->dataref)))
-			vfree(skb->head);
-
-		skb->head =3D NULL;
-	}
 	if (skb->sk !=3D NULL)
 		sock_rfree(skb);
 }
@@ -1164,13 +1157,12 @@ struct sock *netlink_getsockbyfilp(struct file *fil=
p)
 	return sock;
 }
=20
-static struct sk_buff *netlink_alloc_large_skb(unsigned int size,
-					       int broadcast)
+static struct sk_buff *netlink_alloc_large_skb(unsigned int size)
 {
 	struct sk_buff *skb;
 	void *data;
=20
-	if (size <=3D NLMSG_GOODSIZE || broadcast)
+	if (size <=3D NLMSG_GOODSIZE)
 		return alloc_skb(size, GFP_KERNEL);
=20
 	size =3D SKB_DATA_ALIGN(size) +
@@ -1183,8 +1175,6 @@ static struct sk_buff *netlink_alloc_large_skb(unsign=
ed int size,
 	skb =3D __build_skb(data, size);
 	if (skb =3D=3D NULL)
 		vfree(data);
-	else
-		skb->destructor =3D netlink_skb_destructor;
=20
 	return skb;
 }
@@ -1889,7 +1879,7 @@ static int netlink_sendmsg(struct socket *sock, struc=
t msghdr *msg, size_t len)
 	if (len > sk->sk_sndbuf - 32)
 		goto out;
 	err =3D -ENOBUFS;
-	skb =3D netlink_alloc_large_skb(len, dst_group);
+	skb =3D netlink_alloc_large_skb(len);
 	if (skb =3D=3D NULL)
 		goto out;
=20
--=20
2.1.4

