Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5B9914B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387793AbfHVKsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:48:12 -0400
Received: from mail-eopbgr150121.outbound.protection.outlook.com ([40.107.15.121]:33286
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732494AbfHVKsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:48:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqnp9Z/eeJWIiQO2tp86Gcv8yCatLp6U/QCxd8YfXnAWOIkk+weDYdu2jgAaOkiVLIVMsX6Hr5+hZd/LzJxQBMZZ4VIeMpSY3H9s7ggwUbqh481FJIy4IuLeoWyuW8+CtDkgge3bGBH8r5eSyyHJnzQVBKVpaGDKLpx8/tbpGh8z97TsKS3WgIqgLeh/4/8ctQTb4or08de3zZ6R0kUZ/cUvJLPhTQJ7ngGbrM9djehIWF4IIKW45chE8O+rW8noH2VwHY7pkxLOal8bLgeeZKP+kw4OWksryXIFD6tK2Eh5vKroQF0+MZJF5GGwCtDKwyG4QltDjK072XGhtU0MbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPvVUob0c0d1S+fmQT9H6gkk2lxFy0seicc/ClTLuso=;
 b=VzghZ9dXYBh6A4qcrSolMPBm6ocgVh2dfwN8BJgz+YLmlAYhvxfOl874D7yj3v16nm8eJ7sH0mvoT9hJg3CpmfPogSxLlvjUT0GkCWlGPs71sDIeKee2jUM4FMKHJDjJO64CSnZKlBbUHEW1x8G9VvO5s1ajblkLVSKg1oSdso+s4mq2cPCk8gGl53i/5C/Xgn2SLphudxLV7wphK9AcDxe50H57z9cv9aZWKt7D0tz1gqfqRxCBjaXkh51TBnmXpLeeQ8AmYiMA/R4dQYUXzzencMxcZVHm6N5KWrKued12ciukPTANTzH1tMPMzmE07mBZZCVbXSwW52yXZeJrsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPvVUob0c0d1S+fmQT9H6gkk2lxFy0seicc/ClTLuso=;
 b=P1Y0ZkSh6Zq1R5QuDtdd48M1fg0zWldYl7qksRSJHozMl5o8KQ3bAge7CRtWQLXAEGFc2lYQM7loX23+fDE8kr/7isAeJu4E6gDsgM3QqDWuspBgf8N9wqErgV531+UnHVgEv5ofwdEemNWNhl0IXU3B8alg1Aj9x2vEuNNYPqQ=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB2655.eurprd08.prod.outlook.com (10.175.245.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 10:48:08 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:48:08 +0000
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
        Stephen Hemminger <stephen@networkplumber.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Patrick Talbert <ptalbert@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Safonov <dima@arista.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: [PATCH 0/3] rework netlink skb allocation
Thread-Topic: [PATCH 0/3] rework netlink skb allocation
Thread-Index: AQHVWNcVBzufB0ixBkav/5yACjs/iw==
Date:   Thu, 22 Aug 2019 10:48:08 +0000
Message-ID: <1566470851-4694-1-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: f7f3b429-3346-40df-56a6-08d726ee37e1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB2655;
x-ms-traffictypediagnostic: VI1PR08MB2655:
x-ld-processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB26559CD07CE0CE988AFD5A318AA50@VI1PR08MB2655.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39840400004)(199004)(189003)(2616005)(99286004)(66476007)(66946007)(66556008)(5660300002)(476003)(64756008)(6116002)(66446008)(8936002)(3846002)(478600001)(6506007)(386003)(81166006)(7406005)(81156014)(44832011)(316002)(52116002)(8676002)(14444005)(305945005)(6486002)(256004)(5640700003)(86362001)(71200400001)(6512007)(102836004)(14454004)(7736002)(6436002)(186003)(7416002)(486006)(50226002)(66066001)(4744005)(2906002)(6916009)(36756003)(2501003)(53936002)(2351001)(71190400001)(25786009)(4326008)(54906003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2655;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LDyzR3zFN40v8lkANxiMle0FU1hl5xtt/dMWarNJVdcXtLXRJPZ6EiWUYPzVU48A5mx3hMo9CynUm8hPv6ZpLT7VsDhQucQr5WnShWS8PY35ghia7ckPyx20TRVvOzSnIeN8Gw7usI0sX9Lg7a2EHzkzF6Qy3fk6Hbp2JByUnP4pf5QVWaf0yIa4xIAAGPH3X3vRQR4lqtjgtXw4066HMd5GzYbvHIxaem8emX1O4TYTWKT9a3c3EjsAN/1/Fb2NM5+nFOAWMFCZULoYzwxfDENDhWm0oTCNkYtfsdQbx7vvfVPCte++Gb3WKe8iMxoPzKGM5hhNiQqEZP3qAIwitslwkpqpxZ1/nS4vh/drbPyr6XgewT5Hy48Xu5BoE0RfSPHDa8ubaGUKbaSjpyCWx49IWN02ZACqy5WchTuRbLs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f3b429-3346-40df-56a6-08d726ee37e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:48:08.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwMgAaZ387mInRd+RVR4jj4ndd0WETZn+pffh7M+KPeghSXVZLfobfASlBhhG7O7YEvzblVWR+zrPSgTtTpUk48NnunB7eIeZeuuTxJuxMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, userspace is able to initiate costly high-order allocation in=20
kernel sending large broadcast netlink message, which is considered=20
undesirable. At the same time, unicast message are safe in this regard,=20
because they uses vmalloc-ed memory.

This series introduces changes, that allow broadcast messages to be=20
allocated with vmalloc() as well as unicast.

Jan Dakinevich (3):
  skbuff: use kvfree() to deallocate head
  netlink: always use vmapped memory for skb data
  netlink: use generic skb_set_owner_r()

 include/linux/netlink.h   | 16 ----------------
 net/core/skbuff.c         |  2 +-
 net/ipv4/fib_frontend.c   |  2 +-
 net/netfilter/nfnetlink.c |  2 +-
 net/netlink/af_netlink.c  | 39 +++++++--------------------------------
 5 files changed, 10 insertions(+), 51 deletions(-)

--=20
2.1.4

