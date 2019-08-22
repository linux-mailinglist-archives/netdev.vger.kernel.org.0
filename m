Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7499155
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfHVKsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:48:39 -0400
Received: from mail-eopbgr30115.outbound.protection.outlook.com ([40.107.3.115]:23838
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387863AbfHVKsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:48:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZgBI+rWw1WTUHfW0Lhh3Ih00zCgucF7LniA2FFj4dwevli/wAeFN5IPjFACTlAy6NCU/Tp3dX3wRIcdYeydFt0Kbxjwt1Fqw5oNp2nsS1bShhGLHqS7D9FKYck2dFgsq2fzTS8OmwtnRQltqF5yFLeCVdKtJWwC7W4CR2UgikiJT047jwui3YrX/fljGBX3m9KTrhjU0TLWnY5Q6VL+lGP9BUEr2qp1xPLwizW1pfG/9ktsN2iZ0OI7dKF19+mel4LnVTsV8fQ/7d9UqE2N8pA0R5N9P0z0sEZu75pLZiwWppraeldgUcLljkXsgGBqnWVgY1/3K2w/opv+N2KgAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8061+pWOAWMG/aEWCfTKVajft5j6ws/czcxe2ntfIE=;
 b=ZPylva0RoEUgOp4m5VUHnt0VnsmacDzdvDfppR0yecop3mO4RJ/9J/ps2WS8GzI9hWE4+wkk+JoLzOrw9f2M/W+eYd49jU7D8ubFFt4r5XIcrRbmlg0pkHQyslvU56QrGeift65ErmuJRlpMK5e6/WDUa14hBKCF7XldwVzC1cehi3XVAnzN9cXfqGU1qYIJjzWByYAHALMjTom++2V3v2Lv2Rnyo97GCTAcCoTWuqFklWLva9VEJtnHq9kkk1GwNJK7ycQQUbHew1xY27HP7+Rd49tQiP5IpQhQI4iaBmKQbTI4u8vl0dmLbNfDAtEPZHunW8PqjGxnVtuNBkdR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8061+pWOAWMG/aEWCfTKVajft5j6ws/czcxe2ntfIE=;
 b=GVnQ73ZZVhYwrsuj4lTx4iKMu8HgfafHWcMM7RsTOsig8dfwthgHI+TQwdyhzzMUKO6tHDrStQHjYojB1bUvZ6u0k2rQWYJHS6lE/LaZNYJH/LjRAoM0kgWjw/xyB2VWB6W/wDzGJJiIL+0nA20CVv417OTpu1/5bez1tpGCYA8=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB2655.eurprd08.prod.outlook.com (10.175.245.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 10:48:34 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:48:34 +0000
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
        Johannes Berg <johannes.berg@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Hurley <john.hurley@netronome.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Li RongQing <lirongqing@baidu.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Patrick Talbert <ptalbert@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Safonov <dima@arista.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: [PATCH 3/3] netlink: use generic skb_set_owner_r()
Thread-Topic: [PATCH 3/3] netlink: use generic skb_set_owner_r()
Thread-Index: AQHVWNckwYnZD5Cn0Uy1mCccXO+Yag==
Date:   Thu, 22 Aug 2019 10:48:33 +0000
Message-ID: <1566470851-4694-4-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: 4d220a7e-fb9e-48ee-5343-08d726ee4724
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB2655;
x-ms-traffictypediagnostic: VI1PR08MB2655:
x-ld-processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB2655232A0F5726EF3686992F8AA50@VI1PR08MB2655.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39840400004)(199004)(189003)(2616005)(99286004)(66476007)(66946007)(66556008)(5660300002)(476003)(64756008)(76176011)(6116002)(66446008)(446003)(8936002)(3846002)(478600001)(6506007)(11346002)(386003)(81166006)(7406005)(81156014)(44832011)(316002)(52116002)(8676002)(5024004)(305945005)(6486002)(256004)(5640700003)(86362001)(71200400001)(6512007)(102836004)(14454004)(7736002)(6436002)(186003)(7416002)(486006)(50226002)(66066001)(2906002)(6916009)(36756003)(2501003)(53936002)(2351001)(71190400001)(25786009)(4326008)(54906003)(26005)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2655;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ltZ7CxgBCfmTyr+JmBQvxY2ZlAcBonEDFXHvFZa7/FLFNPl2ugmaFkmF1i6wVYXW+9c2RkYpqUTKuWTILB4XpJ2cnsgvu+K6wzABWlmBzVcRqsw0z+ZdX5gSH4FfCzmm+E+FqNXLdE9DwwHB0jwxwVq2rcg2wXG3ca8VE7+mtnvnVm4JYA0omm/dRgWXpDDUQ/fDdyr8A5O0n9ga7ubz5xortdjnE5QAQUDMW+lB3lZxdSaW1VR1ymBEN9HizQCXhDapXEeV3JpUuLKfKRmJ3aILpdXHscALXL1AN7HBsrFamgYQMcvsCjk4nnsUPyaLavljDvrMCcSt4wFqUDYcz38ItOIIubo4LGQBgvVeXJg62KblNXDRVLDrW1bUGPoMpT78ibsGFv6KmnbHrC6olD50kNNv44S210cky6Yzgss=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d220a7e-fb9e-48ee-5343-08d726ee4724
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:48:33.9476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBDoF0ecr3MSAfZleHyVooCozqTm7YuXEOWeQsKkNIVCwd85GnBUVI3REbWMzvRagK4SmYyFfOX6eFBQZFvX1xXS5Mdpu6cxdvDcAK7HtKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since skb destructor is not used for data deallocating,
netlink_skb_set_owner_r() almost completely repeates generic
skb_set_owner_r(). Thus, both netlink_skb_set_owner_r() and
netlink_skb_destructor() are not required anymore.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 net/netlink/af_netlink.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 04a3457..b0c2eb2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -358,21 +358,6 @@ static void netlink_rcv_wake(struct sock *sk)
 		wake_up_interruptible(&nlk->wait);
 }
=20
-static void netlink_skb_destructor(struct sk_buff *skb)
-{
-	if (skb->sk !=3D NULL)
-		sock_rfree(skb);
-}
-
-static void netlink_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
-{
-	WARN_ON(skb->sk !=3D NULL);
-	skb->sk =3D sk;
-	skb->destructor =3D netlink_skb_destructor;
-	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
-	sk_mem_charge(sk, skb->truesize);
-}
-
 static void netlink_sock_destruct(struct sock *sk)
 {
 	struct netlink_sock *nlk =3D nlk_sk(sk);
@@ -1225,7 +1210,7 @@ int netlink_attachskb(struct sock *sk, struct sk_buff=
 *skb,
 		}
 		return 1;
 	}
-	netlink_skb_set_owner_r(skb, sk);
+	skb_set_owner_r(skb, sk);
 	return 0;
 }
=20
@@ -1286,7 +1271,7 @@ static int netlink_unicast_kernel(struct sock *sk, st=
ruct sk_buff *skb,
 	ret =3D -ECONNREFUSED;
 	if (nlk->netlink_rcv !=3D NULL) {
 		ret =3D skb->len;
-		netlink_skb_set_owner_r(skb, sk);
+		skb_set_owner_r(skb, sk);
 		NETLINK_CB(skb).sk =3D ssk;
 		netlink_deliver_tap_kernel(sk, ssk, skb);
 		nlk->netlink_rcv(skb);
@@ -1367,7 +1352,7 @@ static int netlink_broadcast_deliver(struct sock *sk,=
 struct sk_buff *skb)
=20
 	if (atomic_read(&sk->sk_rmem_alloc) <=3D sk->sk_rcvbuf &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
-		netlink_skb_set_owner_r(skb, sk);
+		skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);
 		return atomic_read(&sk->sk_rmem_alloc) > (sk->sk_rcvbuf >> 1);
 	}
@@ -2227,7 +2212,7 @@ static int netlink_dump(struct sock *sk)
 	 * single netdev. The outcome is MSG_TRUNC error.
 	 */
 	skb_reserve(skb, skb_tailroom(skb) - alloc_size);
-	netlink_skb_set_owner_r(skb, sk);
+	skb_set_owner_r(skb, sk);
=20
 	if (nlk->dump_done_errno > 0) {
 		cb->extack =3D &extack;
--=20
2.1.4

