Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE80E3653
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503017AbfJXPSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:18:05 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:9956
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389313AbfJXPSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 11:18:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyZuT0DQv+FF4vOrkzGP8Qc+0xeWusyMx35XK+YfJ3FtkhNWsMJswqqYkR80QpMEcTFY/hQSPO1uIjzMn5OpdhBZJZ41sXWnmSQY4D8LCwG9bycvkHEc9aZ4egJEE2nJRgxwA2SH4NHzTinOPVOiXD6l+ZnGP/rmFxZG4zijAnkdVUpnXhPShGeeXwDdan7VoE4r+eIzIh1NLPZMoNtjHG+E9685vQwJrE2U4pj7DXRBBPAWXEXskRui9a3k40qrb+Av49t33RpmAcOFsDcLgsanwFMmN4lNZvoQ5jPnMJNZxihg+0AxD5XxSYIAgnQ2EuKpHwqB/MA+pjDzEPv9yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbKMGQQIylXpnhBUm+i6Stp3MUN0pAm4w+tefVSppYI=;
 b=HyN6dXW3CQFy9FqKR64TkUxBWlNwP4QYamDPgTe1YOLQ1hW4YA+u3/bCzpZs7gbrJ4cNBJOQUpHvjZwjeeJewv7zpw/nvMvBzCCEe+rZJAohSq0Ex9sXo2CubQBL64Nh0GAHh01Lgip7V2nQ7JVR4WpoTMu6SMnrJyswCtjRaTrompXaCnv2y5nCRiCS+twX0vrWXBVuyfseDTahHJqA1AEXJEwKO6i4zSt4jn3hMMyJ8IxHnVfXT4M0KOx3ni9A3SRXH4JapJlVIZYcKfnISuxl6l0dDgei8mIXhG0lfjNFuxeX7yQ3R8kFaURdktBBw8QyBXROQzBcRkgbKcqfwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbKMGQQIylXpnhBUm+i6Stp3MUN0pAm4w+tefVSppYI=;
 b=jnJsxBKQ3VoIywbnqN3pK0vaDwmTe20GVjmwQ8foq3hTHafZxkoxhhJpEEs1To4jcMXfE4A5vZbKX4/d9pGxUA9Cy2R6tKsg1/z7zAjFSkJ5UjMN8BTpYuI4T0ahLIQNe9NTH7q8Ueju58lyFDA2fTayNHYOkjzWdZn0k0Pbvhc=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3423.eurprd05.prod.outlook.com (10.175.244.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Thu, 24 Oct 2019 15:18:00 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 15:18:00 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmxUYAgAAKWoCAABWbgIADA/gAgAABcYA=
Date:   Thu, 24 Oct 2019 15:18:00 +0000
Message-ID: <vbfy2xauq8s.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain> <vbflftcwzes.fsf@mellanox.com>
 <20191022170947.GA4321@localhost.localdomain>
 <CAJieiUiDC7U7cGDadSr1L8gUxS6QiW=x9+pkp=8thxbMsMYVCQ@mail.gmail.com>
In-Reply-To: <CAJieiUiDC7U7cGDadSr1L8gUxS6QiW=x9+pkp=8thxbMsMYVCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0041.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::29)
 To VI1PR05MB5295.eurprd05.prod.outlook.com (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4850233a-a210-4958-785c-08d758955b65
x-ms-traffictypediagnostic: VI1PR05MB3423:|VI1PR05MB3423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB34233C75E42E1965F82634BCAD6A0@VI1PR05MB3423.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(199004)(189003)(66946007)(14454004)(66476007)(64756008)(6512007)(66556008)(66446008)(14444005)(3846002)(76176011)(256004)(36756003)(71190400001)(26005)(25786009)(2906002)(99286004)(53546011)(71200400001)(229853002)(6436002)(102836004)(6486002)(8936002)(86362001)(316002)(6506007)(6116002)(386003)(478600001)(6916009)(66066001)(81166006)(81156014)(8676002)(5660300002)(476003)(2616005)(4326008)(54906003)(486006)(6246003)(11346002)(7736002)(186003)(305945005)(52116002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3423;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O3jEHHNS9dVpauHQQUI8VlQw/jKzlkNIE3/Cah/ztfCoOFqti+Ahz00NNeNQfFBCfmal4xf+NKCzgwQT2SU4xoOjWnx/C8xs5vavIA94WFkwW9ZASdtHu07atp6BlXpsQCDyhi+QO8s6k5T3ZvSo3w2r3cFlZ7DxVtaNRFZ00QLRS3xdFjYY78cVMFF3RuTQymJWV6OnxirGyz9bWgB4itjbt6Gi3Iy75a3tk7q+NUSxjgI/A7IVUkCMChYpd6Q+2G0QM2qBbNWbQ+A32DGiBscugdEdowH04VdXFCPOc3Ff74/PHU0jptOow14NONbWOkIdM025AtziQfHk4P8Z9OfOVvPx3SmIldcsjR4xpFnI6TknfTpgdfXKGaDfo65dNIIVP4gnSXQJA3YQjYbC9/JwstswZgvf4sV8bg1sTp2WBOooAVS1yhCToVE3hthE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4850233a-a210-4958-785c-08d758955b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 15:18:00.5261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SP5Ocbn5tXKWefKicZUxVbl3tl2My4Ak3TRbQzvmTs8C+tNmK942ISqVkJ0vBKIsb1lk4SGYHdwrHLEwyvhcrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3423
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 24 Oct 2019 at 18:12, Roopa Prabhu <roopa@cumulusnetworks.com> wrote=
:
> On Tue, Oct 22, 2019 at 10:10 AM Marcelo Ricardo Leitner
> <mleitner@redhat.com> wrote:
>>
>> On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
>> >
>> > On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redhat.=
com> wrote:
>> > > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>> > >> - Extend actions that are used for hardware offloads with optional
>> > >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action fla=
g and
>> > >>   update affected actions to not allocate percpu counters when the =
flag
>> > >>   is set.
>> > >
>> > > I just went over all the patches and they mostly make sense to me. S=
o
>> > > far the only point I'm uncertain of is the naming of the flag,
>> > > "fast_init".  That is not clear on what it does and can be overloade=
d
>> > > with other stuff later and we probably don't want that.
>> >
>> > I intentionally named it like that because I do want to overload it wi=
th
>> > other stuff in future, instead of adding new flag value for every sing=
le
>> > small optimization we might come up with :)
>>
>> Hah :-)
>>
>> >
>> > Also, I didn't want to hardcode implementation details into UAPI that =
we
>> > will have to maintain for long time after percpu allocator in kernel i=
s
>> > potentially replaced with something new and better (like idr is being
>> > replaced with xarray now, for example)
>>
>> I see. OTOH, this also means that the UAPI here would be unstable
>> (different meanings over time for the same call), and hopefully new
>> behaviors would always be backwards compatible.
>
> +1, I also think optimization flags should be specific to what they optim=
ize.
> TCA_ACT_FLAGS_NO_PERCPU_STATS seems like a better choice. It allows
> user to explicitly request for it.

Why would user care about details of optimizations that doesn't produce
visible side effects for user land? Again, counters continue to work the
same with or without the flag.
