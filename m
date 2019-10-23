Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0065E123E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389026AbfJWGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:38:37 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:3736
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728697AbfJWGig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 02:38:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHKUVFcKN+opZzFp91L/JN/9hT0ztvifYmBBWqEyfCnSdqF27l5MYNAB1+ytqj0MjIYa3OTnPibmt5RvgTnAUfXQrZuw2SyoxhxM9TfIYIbqYNrQthiaYndjEQDyDN0xGvSDJkp1Se2FbehooagutuePNWpQJ7JjuN4FTKT3PRm7WO/1ukuO+/jEVjPzUEbwGHwLb7tp4dS+72EdXhmIeKyQLxb8feH84KIM7GLYcf7uqz4JTRNYXA/+wtBmVn4EqbvEpvfdSG7040J3nZzDpv+TatxoZxTUGh8XsiIokNISXp9WHgExzNSDVzIj6K3u9uzZCGGQ1vNKs1XFideXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkdGJI6IQngHIAeLb7LKooOitNShcBWTl2PwXrAKE/o=;
 b=Rf9NvZoUrzqLVmIkiPf0C/Yooetr5MqH1fiDKwNTb3gYFJHY58RcsnOJYTeF2D4AbBNhtM/OkvRCDfDlACaykNNgH9hEXZuZsBrWIP2SghaaDZFIGgVZDrSp3poGHhmKWgrxk2MmvS1qgtbF7mJNd4b1jbSfnZvpnU2tOGbh3q1jERZBcfumCdnMzz9uCD+QpURwXCfpKyP5qciVII9iAt/ur9nQj2QEGP2g0MO+2p3/GSUAhfFHSfzpioABkz1dNAkJFT4AyU7irEwRhyej7IHQ8BA4DIuRA+WX6vmNleXzfqcoDIGhM5AmVh060KlxZ8V8owrJxfWm9yX8/bZnYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkdGJI6IQngHIAeLb7LKooOitNShcBWTl2PwXrAKE/o=;
 b=SZxGnwUd/TUIrU7NiCW90ollYMplaubYFrfZovAbZyOVvrFY48+699zaUoRzpaqEY1rnG+Hy+TS8EC2WfqgtXxOseMlIt765RR/3H/rfI3qMipM+902r5TlIEOgav3v5Ej0zKoNwYRaLTzkmtwWL8ODkbOvzdPvfl96opCoShsI=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4240.eurprd05.prod.outlook.com (52.133.14.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 06:38:32 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 06:38:32 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Roman Mashak <mrv@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmuiuAgAAEugCAADkq/IAAzxIA
Date:   Wed, 23 Oct 2019 06:38:32 +0000
Message-ID: <vbfk18wvued.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022143539.GY4321@localhost.localdomain> <vbfmudsx26l.fsf@mellanox.com>
 <85imog63xb.fsf@mojatatu.com>
In-Reply-To: <85imog63xb.fsf@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0365.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::17) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70cec1fc-e0cb-42cf-9e16-08d757839f39
x-ms-traffictypediagnostic: VI1PR05MB4240:|VI1PR05MB4240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42402B854BE8E6F2D4760900AD6B0@VI1PR05MB4240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(189003)(199004)(8936002)(86362001)(4326008)(6246003)(8676002)(81156014)(71190400001)(71200400001)(54906003)(6512007)(81166006)(36756003)(229853002)(6486002)(386003)(26005)(76176011)(52116002)(25786009)(11346002)(99286004)(446003)(6436002)(102836004)(2616005)(316002)(486006)(476003)(6506007)(186003)(256004)(66066001)(2906002)(66946007)(7736002)(305945005)(6916009)(5660300002)(66476007)(14454004)(478600001)(14444005)(66446008)(6116002)(3846002)(64756008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4240;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r8IzPEW/erZ0AA43eytazC/cObsxgLEjqFPZKCt04+7PLvkTsJRkaN2tuFdK4JXE1E+8l9wgSsNWvsqjDf//5NqSVONHR686sSQ24YMN0ABwzcXCx+QL8k/gImEf1RMOo/V6CbSKKYhdqw9Yt7vD+jo2yfK9TxkZe77Qcw0u14mDOkUj91ClFL/b0zADyncWNPqZyIvEgBqW5sDmy+cHXO2F/fun2jTniy7VnbBVWp2lMclVju5pFAZiGdi6VlRalfLb/BF8udsKck6GHxEp6Ut3o/8K2PsQDKWkU9mu78cao1nxlg0inMSHZ2qlIlRcaTSTBqxqSRnI4odEdRT82v7i0h6m2yFouzVMPrkbIXAWhVC0kh2cH0xoWmbN31Sjd9K30JI2C/fQm38ug+f5dx+Kr0eCXHdbzrq35XOJg05tHOILAck5oIOjbqtFpqgL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cec1fc-e0cb-42cf-9e16-08d757839f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 06:38:32.3508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jMbsPXiDnbSwRgEM2qD6HvMM9BhAsNSNALtzTPvw0v/7KrgpCbbb9C/BmtEJ6G1SkUXys6Nmrdycu2W+8tFw8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 22 Oct 2019 at 21:17, Roman Mashak <mrv@mojatatu.com> wrote:
> Vlad Buslov <vladbu@mellanox.com> writes:
>
>> On Tue 22 Oct 2019 at 17:35, Marcelo Ricardo Leitner <mleitner@redhat.co=
m> wrote:
>>> On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>>>> Currently, significant fraction of CPU time during TC filter allocatio=
n
>>>> is spent in percpu allocator. Moreover, percpu allocator is protected
>>>> with single global mutex which negates any potential to improve its
>>>> performance by means of recent developments in TC filter update API th=
at
>>>> removed rtnl lock for some Qdiscs and classifiers. In order to
>>>> significantly improve filter update rate and reduce memory usage we
>>>> would like to allow users to skip percpu counters allocation for
>>>> specific action if they don't expect high traffic rate hitting the
>>>> action, which is a reasonable expectation for hardware-offloaded setup=
.
>>>> In that case any potential gains to software fast-path performance
>>>> gained by usage of percpu-allocated counters compared to regular integ=
er
>>>> counters protected by spinlock are not important, but amount of
>>>> additional CPU and memory consumed by them is significant.
>>>
>>> Yes!
>>>
>>> I wonder how this can play together with conntrack offloading.  With
>>> it the sw datapath will be more used, as a conntrack entry can only be
>>> offloaded after the handshake.  That said, the host can have to
>>> process quite some handshakes in sw datapath.  Seems OvS can then just
>>> not set this flag in act_ct (and others for this rule), and such cases
>>> will be able to leverage the percpu stats.  Right?
>>
>> The flag is set per each actions instance so client can chose not to use
>> the flag in case-by-case basis. Conntrack use case requires further
>> investigation since I'm not entirely convinced that handling first few
>> packets in sw (before connection reaches established state and is
>> offloaded) warrants having percpu counter.
>
> Hi Vlad,
>
> Did you consider using TCA_ROOT_FLAGS instead of adding another
> per-action 32-bit flag?

Hi Roman,

I considered it, but didn't find good way to implement my change with
TCA_ROOT_FLAGS. I needed some flags to be per-action for following
reasons:

1. Not all actions support the flag (only implemented for hw offloaded
   actions).

2. TCA_ROOT_FLAGS is act API specific and I need this to work when
   actions are created when actions are created with filters through cls
   API. I guess I could have changed tcf_action_init_1() to require
   having TCA_ROOT_FLAGS before actions attribute and then pass obtained
   value to act_ops->init() as additional argument, but it sounds more
   complex and ugly.

Regards,
Vlad
