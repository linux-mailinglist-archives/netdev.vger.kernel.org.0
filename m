Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145B2E1BB9
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405514AbfJWNEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:04:45 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:4473
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404732AbfJWNEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 09:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOkEtDZDq43QbZYh5JgfQKcsl+jM1dPuHtCwkOrporlKq/EC2pYKnL4kqANY3/GY/BuH/mshYahMYomsKqvsF8RxEXCUhY9Pii3MLt+emfu+6nW5ML0PiqJRzem7cBpQQB7cAqjRzzQ3TwmLV3MhWvEfQ2XnNQ+oFb/xKc5K58fF+bnbs/UbELMXJZoxFbrbAYsUtnv0NUcnLz0FyoYyJwOWyDNkvnFwJCQfTpidQ+xARgiUtIzBACcHFG8l9vWCLH4RsACN3KUnLk1L1+Y8yI+nn7mMJqu5ir+jPi/MLKxgpMEjVv24ogvwQtR2rJzCGcmv/8ZAmwZwU2KweyK7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DC6eXFZn11GXrVjDTNa/2coRtSgih6L3OoyvSyPAx8=;
 b=ZOKVVVR1tcxquzXf1CmLaiVApXB+cBut3D4LXL6pnauWqzrOxv+uxwGTUPAwF4YP+3gK51X5VnZZwmkCR+weDGTOSSdNFwHA5PcYfehDQokjVhhE5qNEW2MEYhiHy/3eGFvRnEY8UtMQeMH3xQgzvr+IO3ruuTScTIOf1u0UlOXXv/7HUOl8mVUVxyRUIC+aMGedeZs8byDPoS68aqn6qZ/FJQEN3f6gDjyGTFwcBIwSBcUhq9fy+uC3gJ9mGpTqZz/90sTQgDK6EtKOUvLAnsWxVPzfS4NZ1+YKDzOS6rkHu6pGdHOgLlDHMH02RnlsnYEDIzeDq7HsR80kXvghVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DC6eXFZn11GXrVjDTNa/2coRtSgih6L3OoyvSyPAx8=;
 b=Hkcp+FCPkPYyiXlPOJ3SU7CIxROtddbCEOMfoTIk1NgoSZVSwrER94mO9CzPOKu046Go4XKHf+S2m/TanV5snpadtZpQ6aZ52cwDNDuZFcTAexZOXXL1ethNRgQHXQCoQ8lQnp8Nm/G4PdT2kXaOffc07MQ+Z3M8H9esI4kO8wg=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4285.eurprd05.prod.outlook.com (52.133.12.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Wed, 23 Oct 2019 13:04:28 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 13:04:28 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4A=
Date:   Wed, 23 Oct 2019 13:04:28 +0000
Message-ID: <vbf7e4vy5nq.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
In-Reply-To: <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0044.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::32) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24d3d647-40b0-4a0f-f9bc-08d757b9899d
x-ms-traffictypediagnostic: VI1PR05MB4285:|VI1PR05MB4285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42856F070CF557D91F49F9BBAD6B0@VI1PR05MB4285.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(256004)(6512007)(6246003)(6916009)(4326008)(305945005)(7736002)(4001150100001)(8676002)(8936002)(14444005)(81166006)(6436002)(229853002)(6486002)(2906002)(81156014)(25786009)(66066001)(5660300002)(486006)(446003)(11346002)(2616005)(64756008)(66476007)(52116002)(186003)(66556008)(71190400001)(66446008)(26005)(76176011)(6506007)(53546011)(386003)(71200400001)(3846002)(6116002)(86362001)(102836004)(476003)(14454004)(478600001)(316002)(99286004)(66946007)(54906003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4285;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wpjYM0u7HGM8gh+wfk+/5HccoTQwhYQgkuoRYOGPuJgBcdsVS2JC9U/673yP2OxM8HZAX+GJ/RsU+310aIVNMFGmDDn2nHC3/xq5tuY3gpTcY6W9WIN8KkjulxnOZtRIx8BPjAMlQJUY12YzocVEgldzUgP6xp85uCcelxGxybY8iFAMBtzdedE5cdw//4U0u14LgS84jgfMIdSuu3oWMc40CDrqAmHR4hPpQN+ZXFEWZAZoeTRfwaNRhFPQQgQGGQh9DL2vtVUhum9bPwILOAy1oK1uV0ecjkPmTl88LqIq2HJYWtnIQVivXxt10vCzDURUR767z3e4W1UlFOPc9uxRF8MsnrlLxPWqZrReU/4i1f8DDFf89rx+9QGt0/wkJ+7S5Dlb1dUbSqU06vRdAoRHwwidtgHrZOO47R3v7BeOAdtgsuzu0fYc2wMfg6TW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d3d647-40b0-4a0f-f9bc-08d757b9899d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 13:04:28.7061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCmZ9jMNtNxxCeYhKpAHDXxy06VNhlINen2bZTaY0F6/LtMN87ghtxCWVy14soLk5mcjAqG4BEcUrA6qYUd8og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 23 Oct 2019 at 15:49, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Hi Vlad,
>
> On 2019-10-22 10:17 a.m., Vlad Buslov wrote:
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
> Great to see this becoming low hanging on the fruit tree
> after your improvements.
> Note: had a discussion a few years back with Eric D.(on Cc)
> when i was trying to improve action dumping; what you are seeing
> was very visible when doing a large batch creation of actions.
> At the time i was thinking of amortizing the cost of that mutex
> in a batch action create i.e you ask the per cpu allocator
> to alloc a batch of the stats instead of singular.
>
> I understand your use case being different since it is for h/w
> offload. If you have time can you test with batching many actions
> and seeing the before/after improvement?

Will do.

>
> Note: even for h/w offload it makes sense to first create the actions
> then bind to filters (in my world thats what we end up doing).
> If we can improve the first phase it is a win for both s/w and hw use
> cases.
>
> Question:
> Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
> sense to use Could you have used a TLV in the namespace of TCA_ACT_MAX
> (outer TLV)? You will have to pass a param to ->init().

It is not common for all actions. I omitted modifying actions that are
not offloaded and some actions don't user percpu allocator at all
(pedit, for example) and have no use for this flag at the moment.

>
> cheers,
> jamal
