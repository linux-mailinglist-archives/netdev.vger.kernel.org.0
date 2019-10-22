Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901A9E06C7
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731983AbfJVOwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:52:42 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:27525
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbfJVOwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 10:52:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRaTitrIDjZsboe/pA//aRubhdhukUwbwSTnS9/l3vhM7YKcj6PGsHRAqssOVrSRB7WspLHPqpl8adTEN6jmngdgeTK5fwMlTi2LKsC4mlAk8wZyJDYR93I1yx8iSx1LDVOnIqy9Wo5F4+A4YbPUmmtdsTGhMvHwPs6UWQLUUOhxzmUn5syuTxf6tBl1glFqXeIkgsMZFC8zm4lG4QlzdnrKj8ExYR4IUuIt3+PMwmNTp81BB7KOUUPQ1w7nQqA8jxRCjeNh1caOOgS+WLMJJMatq886jiZ2g42zKRQhdy8mbYbjf/APQdrkMU+Zx6Y2JQScl8TPoL+i0wEG8qAulA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9HjGA9FyoX7c6odwKvkjV4tB5yzZOdAjUCVwVHmpt8=;
 b=VrS2ZOWI7UjZzT982bIyQbOMXehg+VxNCzN5b5czp9jxW0JHQ0BPQs/uqTDRROzFUtkLx1x3n4zibXIkXoX5ZYc/xMjQMcMDF+KgYwhr+Krn2UhKzW7DGLj5uvHcwYhh5Em6m8bvRfMCiKSGpuPKclWGkDhAJrm7P6x2wQWklm+K1G2bcLhJ6OxweHVjilDd4frJX85r11p7EkhfcdSnYH4N1CBdnCdUGN9zL0XVFFeh8uQ82NSyQ9QRUab8bNkpZvxN8U1AUrfPBS5z4M9LR8gAwTV4AoFZkGV+9bGwlwMdgikkcOT9bgpw0QmH3hMtiYjaR9K+JB0Nbd/nFwgzmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9HjGA9FyoX7c6odwKvkjV4tB5yzZOdAjUCVwVHmpt8=;
 b=Vt93NWOxZBo6in/y5Yt4eoNrKPcCBHAzfUcL+JvB8yPYcCXY92Gbgo2ZUgITdjGxzkcRK5TL0GbizIjvtqjsjZ34d6iTEjwtnE7qWaaKzgohZt7qGqrrEm0De2tV1CXJ3Gyp92wqpXXarsz1jMr7UVE1RdR9bQZ4rqx5uEhLb0I=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5664.eurprd05.prod.outlook.com (20.178.120.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Tue, 22 Oct 2019 14:52:38 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 14:52:37 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmuiuAgAAEugA=
Date:   Tue, 22 Oct 2019 14:52:37 +0000
Message-ID: <vbfmudsx26l.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022143539.GY4321@localhost.localdomain>
In-Reply-To: <20191022143539.GY4321@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0405.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::33) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69e48d20-c6a8-4a86-a73b-08d756ff7af7
x-ms-traffictypediagnostic: VI1PR05MB5664:|VI1PR05MB5664:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB566467849BAC63E78B35A722AD680@VI1PR05MB5664.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(189003)(199004)(76176011)(54906003)(52116002)(446003)(11346002)(25786009)(71200400001)(186003)(3846002)(6116002)(81156014)(8936002)(81166006)(8676002)(2616005)(5660300002)(99286004)(316002)(102836004)(386003)(26005)(6506007)(486006)(476003)(7736002)(305945005)(66946007)(66476007)(66556008)(6916009)(6246003)(2906002)(86362001)(14444005)(36756003)(256004)(478600001)(14454004)(4326008)(71190400001)(66446008)(64756008)(6436002)(6486002)(66066001)(6512007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5664;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XX6brcFIo2Ju/rLzbtt2UY/FnPly2jd8U2upNuHXUYFk782p+izP2ghVI/JBJ49zwC+XPwaJ08g3/OH6KlBYkQTUfvhJkd4/evAsU/YCMFFRJtomU0fEUardviBAl/CL942YNiiG1tYmdwQ9jAQ5gYDTjnpCBlB5ieBVD8lE3FfsC8gGutJEXusAYFlRo/v8TZwAYUMc+7UGpckfhMWzboS/mLl+EbNERhXe2308APZY2wWxOuU+5ozv+NWzHB2ncSNUvi3u++BZl9CdxNhxr4awzvQiUzT5wTe81tLY/63qmvpyxW45yb5VyOermWzkmQKwi25JA5py5lCAUMxpJyr02XdP1Hfaa53fUyph4V9H6gKA7ZEcbZYPsXwmnEeActKKAlGR/CgnrtFX/EN9E172U+ekuh36903hFQ1wusPWyShVoOTpPhWoLM0kPGaA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e48d20-c6a8-4a86-a73b-08d756ff7af7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 14:52:37.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TuU792+WlJ5fotpD+yTnRV1ZOKIimH3ghUay+egkSGcOv7XU+l1c9gsGAt70ULVNHoZCvMsYdxtq+MjZQr9YlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5664
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 22 Oct 2019 at 17:35, Marcelo Ricardo Leitner <mleitner@redhat.com> =
wrote:
> On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>> Currently, significant fraction of CPU time during TC filter allocation
>> is spent in percpu allocator. Moreover, percpu allocator is protected
>> with single global mutex which negates any potential to improve its
>> performance by means of recent developments in TC filter update API that
>> removed rtnl lock for some Qdiscs and classifiers. In order to
>> significantly improve filter update rate and reduce memory usage we
>> would like to allow users to skip percpu counters allocation for
>> specific action if they don't expect high traffic rate hitting the
>> action, which is a reasonable expectation for hardware-offloaded setup.
>> In that case any potential gains to software fast-path performance
>> gained by usage of percpu-allocated counters compared to regular integer
>> counters protected by spinlock are not important, but amount of
>> additional CPU and memory consumed by them is significant.
>
> Yes!
>
> I wonder how this can play together with conntrack offloading.  With
> it the sw datapath will be more used, as a conntrack entry can only be
> offloaded after the handshake.  That said, the host can have to
> process quite some handshakes in sw datapath.  Seems OvS can then just
> not set this flag in act_ct (and others for this rule), and such cases
> will be able to leverage the percpu stats.  Right?

The flag is set per each actions instance so client can chose not to use
the flag in case-by-case basis. Conntrack use case requires further
investigation since I'm not entirely convinced that handling first few
packets in sw (before connection reaches established state and is
offloaded) warrants having percpu counter.

>
>> allocator, but not for action idr lock, which is per-action. Note that
>> percpu allocator is still used by dst_cache in tunnel_key actions and
>> consumes 4.68% CPU time. Dst_cache seems like good opportunity for
>> further insertion rate optimization but is not addressed by this change.
>
> I vented this idea re dst_cache last week with Paolo. He sent me a
> draft patch but I didn't test it yet.

Looking forward to it!

>
> Thanks,
> Marcelo
