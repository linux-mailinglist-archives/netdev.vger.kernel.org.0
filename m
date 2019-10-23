Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426BBE1BC6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405575AbfJWNIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:08:53 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:12930
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390807AbfJWNIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 09:08:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAOFlZBsU2dTE89iI7m+TYo33fl6Waj3wcTX+KhjaH9gdfWj2qPCY9ZkykFG4izdT5y50PYcuSjhfDonGJDjGssRQR9xN+hB7lMPdMnHlcydv7IAR5ae32sZqL3U/FMMv3OuAxLLJfXv8wOw0WX/yhahFMzt3PMFE4EFXkbXjhpAn09KxTuxqTWqYow8VAnrNWStAK5gGtDqdJVzaweQ3/JgOymm4k8IQTogBMtrtpKlsx0dmhCSOYerlPdPCrIMoeMFtcizGd2IMA53dSXPpBlAz3ZepxQe9bEfwYP3bFyeJhx05pZjHkFi/xj18YWZMSzXFGoEcpUBPkeElxFVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT1r8Wut/oTPvLpuQzYQ87bxLPWhm54wVprNwz2xc4g=;
 b=gMLvuiKOQZmvXs2la+TjA2NDfN2Km9rCR1Z/M5rfRTLu27tT96vHE4/tUEdKYA28V54D3QLs7KHuYEk3Iq8CVA0jnqr8O0Rx6jQHpOeOTvDsp3tqljYcw2pKqsH7aJjeRL6BbKzXCszdad1XaAK+ZZTvEM4dIIeLxoK512kvoUJhHY87JqRYcqgFz4WR7iqZ9l9AOG4FpyzLsXhB1p/NWL3/LEmgFPNQKdZQYcQFJ3jaQ4KMHJ1SPzThB4yFqJYPTG3rkUQCYjWbDFYiar7k+sSeQqRCFf/5SUu0P6Uk/YiqIHKyLvd9N03aPR+7GnN8TRRL5mZFMkX3BOhiMqS6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT1r8Wut/oTPvLpuQzYQ87bxLPWhm54wVprNwz2xc4g=;
 b=FpECHP/kyTOc1BSFnNOCQ2aoz/a8vQz8kTgI/JVDwBitx+LNC/eYEAW41lONafbgRXLwQjEHD0EmYvAy35tyqij0uoEU71l+CRKDPhLbHaGtR7Dxz5bDnm5kKw6pNyVtJ9fE10uxBTFZil6cIq8Rh/KwvZYofIoWtWwMy/Oy7DY=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5824.eurprd05.prod.outlook.com (20.178.123.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Wed, 23 Oct 2019 13:08:47 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 13:08:47 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmuiuAgAAEugCAADkq/IAAzxIAgABregCAAAGcAA==
Date:   Wed, 23 Oct 2019 13:08:47 +0000
Message-ID: <vbf5zkfy5gj.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022143539.GY4321@localhost.localdomain> <vbfmudsx26l.fsf@mellanox.com>
 <85imog63xb.fsf@mojatatu.com> <vbfk18wvued.fsf@mellanox.com>
 <1cd8ce66-cb27-b9e8-c8a6-da63c8226aae@mojatatu.com>
In-Reply-To: <1cd8ce66-cb27-b9e8-c8a6-da63c8226aae@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::29) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b988598e-c860-47b2-a1cf-08d757ba23e9
x-ms-traffictypediagnostic: VI1PR05MB5824:|VI1PR05MB5824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5824B2A5679E2F1A6E5507F2AD6B0@VI1PR05MB5824.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(199004)(189003)(8676002)(36756003)(81156014)(66446008)(6512007)(6436002)(86362001)(81166006)(229853002)(305945005)(7736002)(25786009)(66066001)(66476007)(66556008)(66946007)(64756008)(6246003)(476003)(53546011)(6486002)(8936002)(102836004)(4326008)(6506007)(386003)(54906003)(26005)(316002)(4001150100001)(99286004)(71190400001)(71200400001)(486006)(52116002)(76176011)(6116002)(2906002)(5660300002)(256004)(14454004)(446003)(6916009)(11346002)(478600001)(2616005)(186003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5824;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sZS4xKxn9mn4KWQ0ZK1RvDYgazx0dUUchhoiVYzoOJAFrmYPydGfpjyuMcG0bCL7Z17Qo5oUK+jIeRI5LtuSalUtU3NIHsvkYLq5Lx1zf2B8bUcl+cLppDkCa1PV35xmjp+U3KHVTxqBEn65XNRAzM1plMSb13/cmp96Z8eX8JH02GdgAelUafgXUjYwMOAiGDmlmRvUJ7K6tahN9NT84KKcvtnaWLfS7Aqi7cYRfj+Xg/YdvSZphuWUo6T/G32NqSPJzkS8e+2CPddq5txGLKBJsTHyKd28dKtDqrUxZefSegpqkXCjlQ0RTL+UjVVNgCthOgSU6Bue3A1bdc+VXPxgVQze417FGK0Uz65B4B86LO6j6UnxEfAUnclGRxNBc5F85IQ806NGLc6PAFvhWuyfZ9A7qlGwgA8NAjlQktEr2eX5iwsoB4mNXJQpW44
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b988598e-c860-47b2-a1cf-08d757ba23e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 13:08:47.5781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZgX9J0JcSTXW5Okz/xMtAeHRMOUpV35TYUHxr0UWCswkIbqH277Of1b28/Bfi2WtLfgbjf1ccNYGTdua8VtAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 23 Oct 2019 at 16:02, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> I shouldve read the thread backward. My earlier email was asking
> similar question to Roman.
>
> On 2019-10-23 2:38 a.m., Vlad Buslov wrote:
>>
>> On Tue 22 Oct 2019 at 21:17, Roman Mashak <mrv@mojatatu.com> wrote:
>
>> Hi Roman,
>>
>> I considered it, but didn't find good way to implement my change with
>> TCA_ROOT_FLAGS. I needed some flags to be per-action for following
>> reasons:
>>
>> 1. Not all actions support the flag (only implemented for hw offloaded
>>     actions).
>>
>>
>> 2. TCA_ROOT_FLAGS is act API specific and I need this to work when
>>     actions are created when actions are created with filters through cl=
s
>>     API. I guess I could have changed tcf_action_init_1() to require
>>     having TCA_ROOT_FLAGS before actions attribute and then pass obtaine=
d
>>     value to act_ops->init() as additional argument, but it sounds more
>>     complex and ugly.
>
> I really shouldve read the thread backwards;->
> The question is if this uglier than introducing a new TLV for every
> action.

I'm not introducing it for every action, only for minority of them.

>
> cheers,
> jamal
