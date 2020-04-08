Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AEA1A23C0
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDHOGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 10:06:34 -0400
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:59713
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727226AbgDHOGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 10:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EP8Utd2CtI9GdeVB9mFVOmCTRUnx8xwfSAiMYFl7VnztAP7Cri5t1R7MfHCiO+7iNHI1Ghry25iHSI/wtHgPkNGyXf1zcvMOeuIqZ4DD6lhzOARon2YtMYJTLG2GiLbWQB1v2lBZxdnbovg6mCUTQrX9Bp2EjhJxgFDR45Nn+0qvArzhjTmNbgyO6BF8xGDeSGugJ3U2OxKUM1N+qCWLmKtMoxswVAUp6fWsL3yE8vfTI3hp8yf9WfTsz175YR/088EM2G4FXDm53B8E3OwGta+OA227AlXvAKRgaNR5P4UXaHEbWKKRnQXVM9KW3GnShc4YQdNSsdLY68TKjalpwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdX5HNp81IJxATz9EsLteNsKPIduh/jGId0vrLAazpw=;
 b=BN1UvRhxCOLiRqiMvI7r9AF2FHF4R5yy00/Qp5AvZbyF6NWfoK0Pt8TvLRgF2D1E/S2SlAHKmhiSibYYReTp6dsnwdqCwgoKAI9ctLZ5qiBbilUnQZw8iwiKXxQLPqEBggkre4rUS9KtDxNuQPINDHsUjC027mBi6E+CeOAod6ywQbX6NJ2VMcPXhcKDJgdjhLRoricAZCddNFJB/fWNhFoK/2Jmqq0xyLh+apUPqMKybV5sbt0IWxIS3tTOssxPgX3kgUKwrsb4mn3OHpqG7tuTazBeD6Ajy+znh4sjSSrqil8VYSLSTMTgfrX1Z+E7UFTsKyAuf3tBwLxc1DKMvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdX5HNp81IJxATz9EsLteNsKPIduh/jGId0vrLAazpw=;
 b=saBgCdoBXvs9trMnpGT4qBsCu1bfKEbG8zsq06GREaUD6l1Bf8l9hQqhk7NnEawcf8IbIEJgLTOk2BvJm/cO52e3J/UpqLZqbrwLt5SRiHFpXxvwFBwTGsOCA6tfWPLHVxuDDThJNnFRr/FAHNNqyoEkRRoIJKHd+TacG9wML4A=
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (2603:10a6:3:6c::17)
 by HE1PR0501MB2172.eurprd05.prod.outlook.com (2603:10a6:3:26::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 8 Apr
 2020 14:06:27 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 14:06:27 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Weird behavior (bug?) with mq qdisc
Thread-Topic: Weird behavior (bug?) with mq qdisc
Thread-Index: AdYNruRJeA4EkvVBTQWP2ipOBIuLGQ==
Date:   Wed, 8 Apr 2020 14:06:27 +0000
Message-ID: <HE1PR0501MB2570BC6028E3020D84AE4E40D1C00@HE1PR0501MB2570.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea5dbc19-feeb-421b-31dd-08d7dbc6079f
x-ms-traffictypediagnostic: HE1PR0501MB2172:|HE1PR0501MB2172:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB21720F7A8784390C05934DAAD1C00@HE1PR0501MB2172.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(64756008)(66446008)(66476007)(7696005)(6506007)(26005)(8936002)(8676002)(52536014)(76116006)(66946007)(81156014)(66556008)(55236004)(186003)(4326008)(55016002)(5660300002)(9686003)(110136005)(54906003)(316002)(86362001)(478600001)(71200400001)(81166007)(33656002)(2906002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUc98h4O5FTUlbS7344HxuaAmFnKOIE10NF7VWxixeRDkH7nswqU70JXyqF9tDQSFq/hsijPy/jsSqfAlHvEgvZzJOPdfjxXf0fNzjpn0N80kPleZsnG0gf5loaNGl9E2crrhjfo0xrVsSJkrP61dshzXwKegBaGWxRtkHD376mYlGfoFybyTzv+6FBjVvUqACfJHcyC+ximOXJl7mN/8s+fJXvHzXoxm43AzEh0Vvcjaic3T5YbxID3ec6mTOum7tqd07czHBZdnEL907C7pme2COU79dLWF7gdAVZfVFv6egl83apnz6WsgxKH7coy4uv8wWNwZ7EzvxsrGeG9MMV2NS4GhxfTSaqQmByrZRVMaEWSHakhtOGIx4PSc5aeGXC5r8t6KmlMpc/Qg3r6SCuX+jZl2/Hg7ex/T9d3VVLZdmXNcZz9ts1ugw77Lr3p
x-ms-exchange-antispam-messagedata: JAtA8lifHv1d6/Gt3AetJ4Jyz4CJbmTMyBQpnbytvr7gH1Z1vLMPZqe3ch7eYLIKfIGK1/FDSYy7ypsO8YdRRTmZRsyvIZYt2TbSPlFL0qMbAyeKvzW3B7GJ/ZdeWDPUjPk4j7uC4JIUrERHF7Ugfw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5dbc19-feeb-421b-31dd-08d7dbc6079f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 14:06:27.2386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ll5B1B90U0YMVC33sW90h8wTCi57qNK5gISNiijy0CLRp+K+IUqxcyyktPjQ1VM2lEwRZGKB2FzSL1bEEDIIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Commit 95dc19299f74 ("pkt_sched: give visibility to mq slave qdiscs") by
Eric exposes mq's child qdiscs. It uses real_num_tx_queues to limit the
amount of per-queue qdiscs exposed, but it only queries that value on
attach. However, this value may be changed afterwards by ethtool -L, but
tc qdisc show will continue to show the old amount of per-queue qdiscs:

1. 8 channels, `tc qdisc show dev eth1` shows mq and 8 pfifo_fast
qdiscs.
2. Run `ethtool -L eth1 combined 4`.
3. `tc qdisc show dev eth1` shows the same.
4. Run `tc qdisc replace dev eth1 root mq`.
5. `tc qdisc show dev eth1` shows mq and 4 pfifo_fast qdiscs.
6. Run `ethtool -L eth1 combined 8`.
7. `tc qdisc show dev eth1` still shows mq and 4 pfifo_fast qdiscs.

As I understand, the purpose of the aforementioned commit is to expose
stats along with the per-queue qdiscs, and after some trivial
configuration changes we end up without stats on half of queues.

Moreover, it can be continued:

8. Run `tc qdisc replace dev eth1 parent 8001:1 pfifo`.
9. Run `tc qdisc del dev eth1 parent 8001:1`.
10. Now the qdisc for queue 0 is deleted completely.

Such behavior looks like a bug to me. When I delete the root qdisc, it
gets replaced by a sane default. I would expect that when I delete a
qdisc of a netdev queue, it would be restored to the default too.

Now, if we look at both issues at the same time, in the first case
qdiscs were missing from tc qdisc show output, but they were actually
there, and in the second case they are deleted for real, but these cases
can't be distinguished by tc qdisc show.

I would like to hear more opinions on these two issues (1. qdiscs are
not shown when the number of queues grows, 2. tc qdisc del for a queue
reverts to noop, rather than to some sane default). Any ideas about
fixing them, especially issue 1? Some kind of notification mechanism
from netif_set_real_num_tx_queues to mq or even complete reattachment of
mq when the number of queues change...

Thanks,
Max
