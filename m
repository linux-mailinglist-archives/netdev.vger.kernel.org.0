Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEBF9914E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbfHVKsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:48:24 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:28901
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732494AbfHVKsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxAen7Vm1cfF10TzSDtb45yT8WLHXtVA8Wh2hyj2sDjdnorhx0MQlziUhF61sct5n5u/klGJOsYyG8ya7vMzPuH0LftpWBrjrB/AS09dGA2qlztAGJu5VwiMTrLP2hwvEOf0X2Y6AT6RPryJl0Ig5EoVog7+3CNh0TCbuUBnsbTbJluBcbfAcDFuGK0vGgwwcYmTuqkEwfnCOSXTy+ROnwALPUuaEl7k7+kUzBKo8isYQk3PAwy83nCQI9JzOPn2J4o1/mF94QLeL6H3Iw9XkSXUquwfe135ADCzcQ1fjXwKarHKGHnvUNMQCDW5qMQeZtQo3ejxdHfeEfOl1Der3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oy5NYcz3YQGqvFickTPE8rCmOxQ89LZUxr844/KmZNM=;
 b=FEzb9CZ278z+jhgr0b7u1C+i+fn970AhrcRO6octEgW8nDRnctISkOp7UUfanPfkfGcd1sYVwfmhhVjQNpcywSVqELDN722jO5xJVTpbtRK0/3/WSQnDh5s/0neqVUtTMDO4StDgtxcBNq0NQXucwYYE6RiZrM1WHlKYiFN8jvJgziNOMFFlprj08W7FwTfiKskK5x5CQdXP5b7FpjyHly0ULzIy5fEmwD+bVOmrb1a0suTKvYCV82ezpS52Lj2K6oGjaciI4qJZxS1B3hAraLvLbdZYM6ZUPAhv5nCJYnd58P7lXLYEoL3NW8r/EwYmYdA9fbPz5umniMNCTMpc9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oy5NYcz3YQGqvFickTPE8rCmOxQ89LZUxr844/KmZNM=;
 b=jMIar1D2P64kdjKefaust0B9RDQuWa9HhNTMtFCimtZD8HrO1yvg6+1KLjo02zSqGq2C7BJQ/fTrCTqmVn54+qwFQcQ+v868K1vKnWTMnwviSXuRPlrq2YhMawz3EBlOmI6GpuwTE8prY1GLElHE8foXhVE8oXZY/WHWM9hjEfU=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB2655.eurprd08.prod.outlook.com (10.175.245.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 10:48:21 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:48:21 +0000
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
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Safonov <dima@arista.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: [PATCH 1/3] skbuff: use kvfree() to deallocate head
Thread-Topic: [PATCH 1/3] skbuff: use kvfree() to deallocate head
Thread-Index: AQHVWNcdcW9hJpbjDk+c7UQh7Uz2bw==
Date:   Thu, 22 Aug 2019 10:48:20 +0000
Message-ID: <1566470851-4694-2-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: d8e63a31-fb84-4303-09cc-08d726ee3f5a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB2655;
x-ms-traffictypediagnostic: VI1PR08MB2655:
x-ld-processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB265596A089F010FD015BA3C18AA50@VI1PR08MB2655.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39840400004)(199004)(189003)(2616005)(99286004)(66476007)(66946007)(66556008)(5660300002)(476003)(64756008)(76176011)(6116002)(66446008)(446003)(8936002)(3846002)(478600001)(6506007)(11346002)(386003)(81166006)(7406005)(81156014)(44832011)(316002)(52116002)(8676002)(14444005)(305945005)(6486002)(256004)(5640700003)(86362001)(71200400001)(6512007)(102836004)(14454004)(7736002)(6436002)(186003)(7416002)(486006)(50226002)(66066001)(4744005)(2906002)(6916009)(36756003)(2501003)(53936002)(2351001)(71190400001)(25786009)(4326008)(54906003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2655;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UHHTZcFqySgOVJovfa0w9Sj/ITak35cK9UAZ2Fvzba89LtatmcrFK+GHIV2XcbzZQmGH46QSRHm/ofpYk8eLJMkzIiuOhj7jX+JdT3qQlUC5A3xM/BTW3FCQkVVbde+CC46fk2KQG4IXdowHCpSILQ5tL0N3soNTtggTV8qAAbbvAr7pV0elrXmMGXaoLETJvNQMF3FWQ+gaGZygafqyySLm41eb83ZX6PLlV134XqcJko6FqYrHAC3Hd8zh2XHlhTwmdTOJOv90ZyYoHEb0iRXeu52FxhppcobQeALZVr2hZftYy0deW0uLJ8HXyAe9jDaNPtkogYqaSHTjUdBRXbIMfb8VACQXWAquEudK1zZ8BgBVLW3lVAN++0sUHtcVXS0YSD3kk5dMemPe50ABLXWl7ffWIa7CLvbCK94JVPk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e63a31-fb84-4303-09cc-08d726ee3f5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:48:20.7679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVjgoroen6d7WOd/8/B3goNY/NUoTzvYJzaua2514YxEVV69uL03o/QlYjfm1rPhHBRZhH9V08lBsrN0VP9A2o3A4mfQpon5dvbhOz2kOCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb buffer was allocated using vmalloc() it will make simple its
further deallocation.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0338820..55eac01 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -588,7 +588,7 @@ static void skb_free_head(struct sk_buff *skb)
 	if (skb->head_frag)
 		skb_free_frag(head);
 	else
-		kfree(head);
+		kvfree(head);
 }
=20
 static void skb_release_data(struct sk_buff *skb)
--=20
2.1.4

