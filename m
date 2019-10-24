Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A73E3A97
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503982AbfJXSFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:05:12 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:39199
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503978AbfJXSFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtQAUGSqVTJM8f8HTQy4nIF0R9W3AuZpTJNLzZpW9vZRDUSYxwW1QSYmBm26sV1E5Ftxef7R6TmItOwiAH/JT0qvpXAL/TI5F1WF7NMPXMXJHrP91FRfhPMLKyd2gSHDnsjnKX03cLsIuBSD1AE6RQgqz6Gk+XsMR0nD0vU7pf7QfVzJNOgMuioyFYs+rN53mQKDHH4aB6Y8RWogSyHq9R4ym+jVu9VHVxJew8pqkRBh3sqM5bGUFITE78S2FyzMDmhSp3pFVdOFQO5qaaqqrghE0iuVeOoroAEAiRw3kTYqwC02UcQP6fGewQ/x8s0QeQ+b0SJdsqnDWX/59lJdTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0IJApxbP1dKulzLDYPozE0dFHHAuPUtANUuSdPOfwM=;
 b=h8PJYs3Kj8lH7swpjbZdX59XLHvz/8qGQ0L8iEC2CMtbxdIM9mM0efGK5bPds9drwjHztB7w4asxV2VUd7KVbGpVNJ46UCkkf1XNS/amxIQuNW1Ez1y4Y6qFT99WVWWmnZFA/5EMcpf3LCI+NwSZxp7bJHMPPF1g8QAlDSLzAkHv+PzYYuMxPMbxEJNmHMtjzQN76KUA/li5ZOwhqundYEfqqa/8CbFVNNG1ptqmZ42iPTY/kBEnhyuSiPQRXx/VrldPRiNJbZjVSPG108rPS3wTmQ22IL2zj+b/zv8fR6Ga+Ze1bZpEFvyM2peXXhQSi92Pn5h0Gbot/ht0k0X3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0IJApxbP1dKulzLDYPozE0dFHHAuPUtANUuSdPOfwM=;
 b=GmE0KYV82pF0jdLlJZ+Cf/DiMMCmrXSih9hBCn+U/8+60ndBT7Su7l+usUsnDVBYSODtMgl1zltZTXryF8ejGxaY7Satbg8gAcgB+71LjLKatnqhmipa3ABzTKjsNDv2cxAiG5xaCqgOSU6FwcCnlD8wWXqVffsPnIjBLILFz38=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5455.eurprd05.prod.outlook.com (20.177.201.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 18:05:08 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 18:05:08 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIAACQIAgAAJDQCAAA1uAA==
Date:   Thu, 24 Oct 2019 18:05:08 +0000
Message-ID: <vbfsgni6mun.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbfv9se6qkr.fsf@mellanox.com>
 <200557cb-59a9-4dd7-b317-08d2dac8fa96@mojatatu.com>
In-Reply-To: <200557cb-59a9-4dd7-b317-08d2dac8fa96@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0394.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::22) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71209957-24c4-4144-309f-08d758acb482
x-ms-traffictypediagnostic: VI1PR05MB5455:|VI1PR05MB5455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB545562E0CB0010C10972348BAD6A0@VI1PR05MB5455.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(26005)(316002)(446003)(6512007)(3846002)(478600001)(6486002)(25786009)(54906003)(229853002)(14454004)(186003)(6436002)(99286004)(6916009)(4001150100001)(66066001)(8676002)(66476007)(66556008)(64756008)(66446008)(2616005)(102836004)(66946007)(11346002)(2906002)(52116002)(6246003)(7736002)(81156014)(81166006)(8936002)(476003)(76176011)(6116002)(5660300002)(53546011)(486006)(305945005)(36756003)(4326008)(256004)(86362001)(6506007)(386003)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5455;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6x9fmkZsAdJgb6+v/TNna5kUomjGAVeun3jjxuU4YScRQSO7+dV8NKdsKYlSluY03DorifrF3dzcvCmI3TVK1Bo6MeF/k8t/UH1OEPCoOJSBeqpbWa1UHEzELUvf955QZu4r8HJFKnTRTSmIsTsdNaX45l8QmEQMp9ZArQjzf5FxBp51IrULmTQR9rvb3YTjzDpoItvfGM+d23dfM/SUBtM6KYvj6NAcI8Wd659B3dk5Kf/6lfS/UMwcSQ5nCHPJEhGEPvxCboUHWLk4gUjGsKAZVvwx6CIrPeY/gRGmKym3LMXmaRe3+yh56iQhlhxCQDqU+gHEpqEShZj0B8b8nbeuY94fnynUwEXMHKzvIwrAGn2hnYuB2usPE0levcp7bPd9Y5+aayJOWvWQILzNmdiOD6FGYjAeXs14MQe6OnceEhdzYqSG4xP8HYq1P+nh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71209957-24c4-4144-309f-08d758acb482
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 18:05:08.3254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zud18aqbrHs1pXR1xs775pRfWl/h9Hj2fvdaVhl1jHcWYmIHOFYJtSQpTSFI+f9x5IqNI3/sM52WKNpO2aj8jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5455
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 24 Oct 2019 at 20:17, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Hi Vlad,
>
> On 2019-10-24 12:44 p.m., Vlad Buslov wrote:
>
>>
>> Well, I like having it per-action better because of reasons I explained
>> before (some actions don't use percpu allocator at all and some actions
>> that are not hw offloaded don't need it), but I think both solutions
>> have their benefits and drawbacks, so I'm fine with refactoring it.
>>
>
> I am happy you are doing all this great work already. I would be happier =
if you
> did it at the root level. It is something that we have been
> meaning to deal with for a while now.
>
>> Do you have any opinion regarding flag naming? Several people suggested
>> to be more specific, but I strongly dislike the idea of hardcoding the
>> name of a internal kernel data structure in UAPI constant that will
>> potentially outlive the data structure by a long time.
>
> Could you not just name the bit with a define to say what the bit
> is for and still use the top level flag? Example we have
> a bit called "TCA_FLAG_LARGE_DUMP_ON"

Yes, of course. I was talking strictly about naming of
TCA_ACT_FLAGS_FAST_INIT flag value constant.

>
> cheers,
> jamal

