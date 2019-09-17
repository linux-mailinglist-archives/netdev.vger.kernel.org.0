Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5176B568D
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 21:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfIQT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 15:57:30 -0400
Received: from mail-eopbgr50043.outbound.protection.outlook.com ([40.107.5.43]:14672
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfIQT5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 15:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZOdbqW8w96sewLqdU57X3woqAQm2krA1MaHiDfkkAiG2wmk4r9PX3wP4HYFTyGp1qYSUxVbA9xrfUUp+KtEKOqF6yeTzWagSwkQDpvSq+h8q7UjVNuACFf1n2pOc3wZVHs+xX7tPhiarwHr17Ds49lT7t/xyf6V+SL0cC+FwIvEqbTMkwdI3xeyQWNFHQjfAUAvQz8p+WHOoDeRIOpWzIPElQb/+QOyspnU76yM9bGFE9wu+HLP5tbfU4fT1e2K8f5HmiuP8Coh4OVliv9K7HrFMvpvFey1A01tlAXjvAOzeZC66y1HXZQI1jn+w1WRDBmPa1DFNRErZJs/kjf+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VRZ07a3kDHT27MDqV7a4bhDVpoq5+3M2kRHUEY/D9I=;
 b=mT6giivNs+PihSrZutpqwqLamQ0FiYEIXjsCtkoo7SY2UZ3kAj08MyfCNU92GVfqlPSxwj7IBcKYHtxcFdoviBnquDh+4Fc5D303C9a/mfWCjI5bSs7pr3TqoUWwxzWImKKKmk/Z+IgaOdB1mxNtiSVG/P7q+Rm7mcK4OInas+E6Zt0PWXODbmtVsoGZs6zH7F/gQAr5pxy4iDOmDAGEfxbQmrNwaQ9LgLG3H2N5Bw4eFEHkxfPanxOiYaTMDzMBJ7XQl/KlmBKdWzYCQkaMkWEwy3v4BkSAuizJ/VjzJI77eXP8vQNFNMtYsMGDYrKQ8N8602EpxnA/AR0BnR5LqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VRZ07a3kDHT27MDqV7a4bhDVpoq5+3M2kRHUEY/D9I=;
 b=PNqaKnUMYypVUjWz/CK7ZqwXes456l15x4tNEJn4qVLYFQ35FeIiTbPxxinch//2ULlWG27FjKj/5ZKtQsFIgcKk5+PMN4uwkRpNgpjiIxRtDm6JAayRZrWoUwR8DaT6AbgqnOqksN10lp5qWgur6QLZpuoJR6Sgk7eeqv0IOhc=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3277.eurprd05.prod.outlook.com (10.170.238.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.24; Tue, 17 Sep 2019 19:57:19 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 19:57:19 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "yhs@fb.com" <yhs@fb.com>
Subject: Re: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Thread-Topic: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Thread-Index: AQHVbOfxS+4wZTnw/UG0HWKBhwV4mKcvHPGAgABs04CAAI/6AIAAMJ2A
Date:   Tue, 17 Sep 2019 19:57:19 +0000
Message-ID: <vbf8sqmd7cn.fsf@mellanox.com>
References: <00000000000029a3a00592b41c48@google.com>
 <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
 <vbfk1a7cooq.fsf@mellanox.com>
 <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::15) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8dde8f5-e7c0-4f54-10b1-08d73ba93f39
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3277;
x-ms-traffictypediagnostic: VI1PR05MB3277:|VI1PR05MB3277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB32778BAD914B5B5B49A79801AD8F0@VI1PR05MB3277.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(199004)(189003)(14444005)(26005)(305945005)(229853002)(6506007)(7736002)(386003)(6246003)(6116002)(4326008)(8676002)(186003)(476003)(446003)(2616005)(11346002)(66446008)(6512007)(6486002)(6436002)(81166006)(53546011)(3846002)(102836004)(66066001)(76176011)(25786009)(64756008)(5660300002)(256004)(99286004)(66476007)(81156014)(36756003)(86362001)(316002)(478600001)(71200400001)(71190400001)(66946007)(66556008)(8936002)(6916009)(2906002)(7416002)(54906003)(14454004)(486006)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3277;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9zHefuzZY4IU9aDpo9oquxPRaBk3LAiJxoNb7poXRUf6prz4bRSCLv47GBCsOBoSHA92n7jUr5qxMJWlfASxG6jqhnaDUrnqPmw/AKw1e53Q6lU00s8ETCqqpHMkeaZp9ceNtV/HjML0/oY/qMdF98414y3kp2k6+LVlZp2cUTtmDljLVkM2RXfZXRmB5gXlY6A/edLtolRQxDOLLXN90JgWFrI34/8HNOIlnhDFfoBWtpYLPHh/Fw3MsUAaciSgU6v8rwhOnoLCxRWKQ87C5Feq4nC65N+iAt3WsE0+/WqpC9A8/lBzwe94rVh/+sREJQ0yJC0k+8Q1/9G2v/6LH0PwFJa7bYxluNWIYyedJZea/j9pbk4ZMoZ5sAelPXUdxkV5g6zPDuOF83pykEYiq/hgxQZEWZanJdYCmoxlBbc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dde8f5-e7c0-4f54-10b1-08d73ba93f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 19:57:19.6338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V6c6dz8RCQnUp5AXeYxPLQsURMFPZ4A/VET/1X6PV/qBFFfsinGZd9NfL63SXy9G1kKujF5xlQvx/7VQhNZV0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Sep 2019 at 20:03, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Sep 17, 2019 at 1:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> Hi Cong,
>>
>> Don't see why we would need qdisc tree lock while releasing the
>> reference to (or destroying) previous Qdisc. I've skimmed through other
>> scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
>> affected. Do you want me to send patches?
>
> Yes, please do.

It looks like tbf is not affected by the bug after all. Relevant part of
code from tbf_change():

	if (q->qdisc !=3D &noop_qdisc) {
		err =3D fifo_set_limit(q->qdisc, qopt->limit);
		if (err)
			goto done;
	} else if (qopt->limit > 0) {
		child =3D fifo_create_dflt(sch, &bfifo_qdisc_ops, qopt->limit,
					 extack);
		if (IS_ERR(child)) {
			err =3D PTR_ERR(child);
			goto done;
		}

		/* child is fifo, no need to check for noop_qdisc */
		qdisc_hash_add(child, true);
	}

	sch_tree_lock(sch);
	if (child) {
		qdisc_tree_flush_backlog(q->qdisc);
		qdisc_put(q->qdisc);
		q->qdisc =3D child;
	}

It seems that qdisc_put() is redundant here because it is only called
q->qdisc =3D=3D &noop_qdisc, which is a noop.
