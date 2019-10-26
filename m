Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE18CE5E12
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJZQm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 12:42:28 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:26014
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfJZQm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 12:42:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaxSEKbwJx56rxAPTG6BS1GtFYx9Gvdm7tM6yv02KTwiI6R1cei/0fcy6NfIbS2aSTmvUSnCG++/qkZvORFeF0C0ksWp6ehDUOjM24s321CP48k6IBDArmnlwc+4ea6vMzccri4wOSQyt8+fY6K31KWO7QI74XPCASS15Dh53qZk71wYd/1oo1KQ48lqv6JxsluECyVyqwl5mTpsSNZvanxg/OPa6llp5sl1lrtG7zuubmdbVzwnTtRmBssnjVv14PF/YHMbviVELbCbacT4PxK4JKZAXdTT/+VTGM15FdHb0IJPViygmQYg4NcE/wNWVdDuRRfgzSwCgPfFC764Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R28ZGcqeYUO7Xe6hqdmG8efc7xRPhOzCOwyASjx6ya4=;
 b=b2RtXZGdB5Bt9RVUPBNjz5WzvgUsBcF/ir5pjhJCgiHQxjDC39LnhGAyByYSNOe0RcsG8A+8/al3vz0OBkj9b1EuWBvAyAvyfQo6jrQF3/zbCd2flgXdABzJFIbo8L5to8uUMqf6afK365snkjZyZE0YrzeX6FEvWxhmVmP1nSwavGMUEtHTFynOnOxfgeaOUj97T4cTtle3x/TeU+hy46I8Ezgd6RWTLg0GO6vu0tTHHX+mlkcdTP0+s5bKaWgwLNedCN0XjN9neaPW2IMC4LSj4uDQm/r2naVBISOXOWsU8fVKvRmXpZEe/FwhHDkJk1ibTD1Ca/Mgd8Tg7lyVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R28ZGcqeYUO7Xe6hqdmG8efc7xRPhOzCOwyASjx6ya4=;
 b=StUqiVIoky9YXQihNjIHRyjbEAcuSgT9Y0siazILYA2Kijpzd/4aGgzPnpNSeiv0lKst3aTfZkgwuYzJaFuLP69jupzT3db0wV/ZoWFGWLeerGiJ1Gb+5Y0Hr0tkNWDu8wVFuTowVYPyouYUtgF7upwfDg/ZAY4s7Ye6yy2rzGk=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3181.eurprd05.prod.outlook.com (10.170.238.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Sat, 26 Oct 2019 16:42:23 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Sat, 26 Oct 2019
 16:42:23 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Roman Mashak <mrv@mojatatu.com>, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAAATEAgAAFeYCAAAZxAIAAF6UAgAAu94CAAAE3AIAAC+2AgADGwYCAAC1LAIAAKRI9gAAUhoCAAAnwgA==
Date:   Sat, 26 Oct 2019 16:42:22 +0000
Message-ID: <vbfk18rtq52.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
 <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
 <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
 <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
 <vbflft7u9hy.fsf@mellanox.com>
 <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
 <85eeyzk185.fsf@mojatatu.com>
 <2e0f829f-0059-a5c6-08dc-a4a717187e1a@mojatatu.com>
In-Reply-To: <2e0f829f-0059-a5c6-08dc-a4a717187e1a@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0086.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::26) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 78a16238-41eb-4c9a-5e0c-08d75a3379a6
x-ms-traffictypediagnostic: VI1PR05MB3181:|VI1PR05MB3181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3181E2E9B0DC47FF09D3CBF4AD640@VI1PR05MB3181.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39850400004)(366004)(189003)(199004)(71200400001)(4001150100001)(71190400001)(66446008)(64756008)(66556008)(66946007)(66476007)(26005)(7736002)(66066001)(256004)(25786009)(14444005)(486006)(305945005)(2616005)(476003)(2906002)(186003)(11346002)(446003)(3846002)(54906003)(6116002)(86362001)(316002)(99286004)(6486002)(14454004)(6916009)(53546011)(386003)(6246003)(6506007)(6436002)(6512007)(52116002)(36756003)(5660300002)(229853002)(76176011)(81156014)(8676002)(81166006)(102836004)(478600001)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3181;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o5J/8oDBCL7+s/V+xl5bsGtvbe8XaPSu0KeVCxZRuUTiLyQV05aOwyPqJag2qliQdOieykQghTc6YADGVTqmKoPCbuTnkvGE7eFN5RWBO3jrj0n/FxjgjCXm0/Sr8AzDiVokJet4EZ6bR/rQY0Vmy94XxksemjbUUa6LL0mU8tFnKbOdSzml1Ukt49z7G9ejGsHFx3NSmugt++XVRniu5qDzkGBWp/D1B3Y1vqHWLiHFFtMhOpplSmEQRUbgT6kaQkyGCCWewTcylpBI+cJGOAjcLePiG4/5ASR1BuqrkdvlN6DlDkcNwBK7Pn+2wpNQNEVSgKBFyNUvu7TD2U1kooiuDFMIljlNVtD/Z8vdT1wporR1Itnhf+4tJC2OiPpPCPBWuIRZzVARIpJkGFZsq/V6fC96iLVz2JhQYE1+9AWvnrgZO/d0g7fBqA1/jUF4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a16238-41eb-4c9a-5e0c-08d75a3379a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 16:42:22.9311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8jAkyW7S5UyLov7eF1bgcmBATZR0lVFH61OJsZBCv0PcnX1DD0mNjrVhTfM/JlBBKvRVPk5qPzMpReDq/MsaIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 26 Oct 2019 at 19:06, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-26 10:52 a.m., Roman Mashak wrote:
> [..]
>>
>> But why do we need to have two attributes, one at the root level
>> TCA_ROOT_FLAGS and the other at the inner TCA_ACT_* level, but in fact
>> serving the same purpose -- passing flags for optimizations?
>>
>>
>> The whole nest of action attributes including root ones is passed as 3rd
>> argument of tcf_exts_validate(), so it can be validated and extracted at
>> that level and passed to tcf_action_init_1() as pointer to 32-bit flag,
>> admittedly it's ugly given the growing number of arguments to
>> tcf_action_init_1(). With old iproute2 the pointer will always be NULL,
>> so I think backward compatibilty will be preserved.
>
> Note: we only call tcf_action_init_1() at that level for very
> old policer api for backward compatibility reasons. I think what
> would make sense is to be able to call tcf_action_init()(the else
> statement in tcf_exts_validate()) from that level with a global flag
> but for that we would need to introduce something like TCA_ROOT_FLAGS
> under this space:
> ---
> enum {
>         TCA_UNSPEC,
>         TCA_KIND,
>         TCA_OPTIONS,
>         TCA_STATS,
>         TCA_XSTATS,
>         TCA_RATE,
>         TCA_FCNT,
>         TCA_STATS2,
>         TCA_STAB,
>         TCA_PAD,
>         TCA_DUMP_INVISIBLE,
>         TCA_CHAIN,
>         TCA_HW_OFFLOAD,
>         TCA_INGRESS_BLOCK,
>         TCA_EGRESS_BLOCK,
>         __TCA_MAX
> };
> ---
>
> which would be a cleaner solution but would require
> _a lot more code_ both in user/kernel.
> Thats why i feel Vlad's suggestion is a reasonable compromise
> because it gets rid of the original issue of per-specific-action
> TLVs.
>
> On optimization:
> The current suggestion from Vlad is a bit inefficient,
> example, if was trying to batch 100 actions i now have 1200
> bytes of overhead instead of 12 bytes.
>
> cheers,
> jamal

Hmm, yes, this looks quite redundant. At the same time having basically
same flags in two different spaces is ugly. Maybe correct approach would
be not to add act API at all and only extend tcf_action_init_1() to be
used from cls API? I don't see a use for act API at the moment because
the only flag value (skip percpu allocation) is hardware offloads
specific and such clients generally create action through cls new filter
API. WDYT?

Regards,
Vlad
