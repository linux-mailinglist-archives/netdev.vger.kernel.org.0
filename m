Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E405AE1256
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbfJWGmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:42:52 -0400
Received: from mail-eopbgr50075.outbound.protection.outlook.com ([40.107.5.75]:47918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727194AbfJWGmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 02:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr4uwMEusBTrlN7LuXfTL2jUSkJrRP6p0QTuoES7fIiQ/bpV6Qhj5D0bvxoHu792FE+1MCiyIVq/Ki9f24KB6XsfmHzARx44iHpTKjJCQ0iGKqDKOWbF1gs9eva8gO7cBkbXOi+jCoxbhkh1B6wbjOqtOmvNaVESa9qDc7rkcTzQP0v0/NppeUPludU0sf1p7XWNAFOThZduG5cU/90w/fbMpK6o8RmVd1C4JUV15vqgaYpudib29BOrzE9UH8xHyeV08/T4payhj6PkbsCh1yya4h+GfhzIAqeubj91/AdSrG9jF59jNvumUUCluEx05Yo683Qe49YH4QnAedCiEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyzByeITDsNzNBEO5rf++ImhSl+gTVQRBKP/wOXyUkI=;
 b=WgpirVmOp99iJ7BFJMvkLNnt8dHvIjGkskWN4+DYZwwQYsVCYsgAXWnkBy1paMdrq4YNoFS/ic8CII4wnLWMUhk2LwcpAI4W4paYU3l3gBqfUY88esxIzPu4SXHfGbBY4rXCw6Vb3fOE3hX06cphp1RiIM7qDwsGY/qKvx48LInUzmrxXVeyiMqLBGTTMdEFDlcGxKvsGix78u/wscv/VNn+EoiI0XnXCK+k64sFNfTYsDMlyHIoM3e8Do6V8Xn9uNWjlkvRpRhZc0dRmdEjvYG5WhtQFxNCuvJpeZpPOYIq4tAbrKrOFLrcS1vV/pTJWFvgWLefDzWCbsZ10EOm3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyzByeITDsNzNBEO5rf++ImhSl+gTVQRBKP/wOXyUkI=;
 b=jRvspjR4NZS5q3YvadVsFArJU1Xksc5cp2Gcvblyyoxy0TDdnqSOkTyHWrArUPVMWp0jYmhQiSysXZgysV58yR0hNZ8z5023qK7nxpoIwTDiEZ9qU9V4XbuteGidc8xS72mRKcVottHPViS91afSfOBScG9drib+XgLyk7yIpGk=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4240.eurprd05.prod.outlook.com (52.133.14.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 06:42:06 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 06:42:06 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmxUYAgAAKWoCAABWbgIAA4vKA
Date:   Wed, 23 Oct 2019 06:42:06 +0000
Message-ID: <vbfimogvu84.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain> <vbflftcwzes.fsf@mellanox.com>
 <20191022170947.GA4321@localhost.localdomain>
In-Reply-To: <20191022170947.GA4321@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0148.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::16) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11db9da6-cf06-4ca6-6131-08d757841f39
x-ms-traffictypediagnostic: VI1PR05MB4240:|VI1PR05MB4240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42400B2B450989DCFEBA34A3AD6B0@VI1PR05MB4240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(52314003)(189003)(199004)(8936002)(86362001)(4326008)(6246003)(8676002)(81156014)(71190400001)(71200400001)(54906003)(6512007)(81166006)(36756003)(229853002)(6486002)(386003)(26005)(76176011)(52116002)(25786009)(11346002)(99286004)(446003)(6436002)(102836004)(2616005)(316002)(486006)(476003)(6506007)(186003)(256004)(66066001)(2906002)(66946007)(7736002)(305945005)(6916009)(5660300002)(66476007)(14454004)(478600001)(14444005)(66446008)(6116002)(3846002)(64756008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4240;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V1hjQqBN5BeVvw3EfJpuyljBnfQs8P0nNsyy3ajjtVsvVW/dwzdLigCh/LY+6S6Is9yp8qUYCLpj6vPVdtxlURl9nOYY7twTyXB1Zawej50e7lpS1XTrPyHosP9jSskTnLmd1/S4jryXumoGrtc1OVGQUOtI1QGK6T90JEJc+OUy8KC4ZvenXSrW1aQGLzFd6+GOJBLLLwE5PWGceGzgR97k9tvzJv+RLs7oN1ilciPj6tEu7nrLjSO3pVhWApGBgX3qnQCS493PzRE85IYp1j37ttBwYgdgc1wWjg0nzTlZnZzmpbPAKEX5VvJ6rxjLBCv+6+xkXREYFUepE4nUfwHsMoi4Sj11TEPVSG9mD0MK7cLlbILRo2dG8cHdYhdSZwmNrLfqQ0fgaK35W8jAiUYauTG03MAIBuGZgAbXcUg/Ljtd5CWWjRijFycQ9G/N
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11db9da6-cf06-4ca6-6131-08d757841f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 06:42:06.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCj2wUpAa/5K8BSssfDz6lZD/mISfRICC1zTnTSjErbkrGy85x3OGZGfQ50GFaukYSn/GP2iPmz8klRzd1lf9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 22 Oct 2019 at 20:09, Marcelo Ricardo Leitner <mleitner@redhat.com> =
wrote:
> On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
>>
>> On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redhat.co=
m> wrote:
>> > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>> >> - Extend actions that are used for hardware offloads with optional
>> >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action flag =
and
>> >>   update affected actions to not allocate percpu counters when the fl=
ag
>> >>   is set.
>> >
>> > I just went over all the patches and they mostly make sense to me. So
>> > far the only point I'm uncertain of is the naming of the flag,
>> > "fast_init".  That is not clear on what it does and can be overloaded
>> > with other stuff later and we probably don't want that.
>>
>> I intentionally named it like that because I do want to overload it with
>> other stuff in future, instead of adding new flag value for every single
>> small optimization we might come up with :)
>
> Hah :-)
>
>>
>> Also, I didn't want to hardcode implementation details into UAPI that we
>> will have to maintain for long time after percpu allocator in kernel is
>> potentially replaced with something new and better (like idr is being
>> replaced with xarray now, for example)
>
> I see. OTOH, this also means that the UAPI here would be unstable
> (different meanings over time for the same call), and hopefully new
> behaviors would always be backwards compatible.

This flag doesn't change any userland-visible behavior, just suggests
different performance trade off (insertion rate for sw packet processing
speed). Counters continue to work with or without the flag. Any
optimization that actually modifies cls or act API behavior will have to
use dedicated flag value.

>
>>
>> Anyway, lets see what other people think. I'm open to changing it.
>>
>> >
>> > Say, for example, we want percpu counters but to disable allocating
>> > the stats for hw, to make the counter in 28169abadb08 ("net/sched: Add
>> > hardware specific counters to TC actions") optional.
>> >
>> > So what about:
>> > TCA_ACT_FLAGS_NO_PERCPU_STATS
>> > TCA_ACT_FLAGS_NO_HW_STATS (this one to be done on a subsequent patchse=
t, yes)
>> > ?
>> >
>> >   Marcelo
>>
