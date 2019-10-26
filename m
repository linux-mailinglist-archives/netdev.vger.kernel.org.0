Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCCCE597B
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 11:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfJZJoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 05:44:18 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:24803
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbfJZJoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 05:44:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsJdLjEn6difo1OG0HD65ULVASwWVypuwAw8U9FhrLfORiYVTHE6meCvzYknyARn44CCP2zd2DhWo1pggl9Xlko8MlWAXOAS5G7D4EvoPxR/j/L5VJkZJe4fHll4h8jyrGMw58dHlrcUO1WFvYHZpN/HyY/5XbaOk5b7t4zLIcsOIa4PoQ7VrlnkqSMGyN/H4v8R/aN9BYInH+HaaN7VKN6mBiMqPg5XwUJDtbOvKrXvtcE1K3LxgheI0pg2+0Cu6z/0dGZRQdB7myYqwgUFkkGkmYABS7DBTLTzCchGsh2HL8vQ8kiFsR5cqGqCPePz62yohDgVgtuaTQl/GTHBwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuAX3sKysPvFAfwkbmZNVufYoytjsYldEwCCzqxHDKA=;
 b=mzww20D4rwKW39pHNbvbYQZwOCOUrCvIOsCq+2JQ9ChrBVQRWLB1fbwuFpWtxF0A1FrDa8bPXAIUZGlvCWg7TF7PQmHoxu0TL7KEtPpxLvMzTdAk77aV4FRlyoEW0FTWWoLk+xms+eCYdQ32/1zp3+n61L917vt+IoEA1vc2AyOKvoErz3K/jI5nX68hSJsyvSqQ6WEU6V7X4Jx9+ACUcYsUjroP4f9uL48Kdqr2DbAhQKT8uRP/TkejRU6s2HdIwHgAE0dZ6gSmSumI/GyrYJJboIx9sN29NjjiW9F1bbmfLq2FufxsIjtbREF4TvE+yaknZBR8qWo42nhjvOPgbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuAX3sKysPvFAfwkbmZNVufYoytjsYldEwCCzqxHDKA=;
 b=R/JlO9Bz/1K/yLFe4E+dFVclWoBqxuXR+5E7wW9SUKxjHjoy44ABOQbDlTy6Zr6w9SufTtZxJzfzrIw0cHb/almo0pO3Kwtli53WeAtybRblkorBddkMZxChLuZtcaK30AjtreR+Nu3wbOVx/d3gH2rsr9UXNeCPbCMI5iVP/60=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5968.eurprd05.prod.outlook.com (20.178.127.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Sat, 26 Oct 2019 09:44:13 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Sat, 26 Oct 2019
 09:44:12 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAAATEAgAAFeYCAAAZxAIAAF6UAgAAu94CAAAE3AIAAC+2AgADGwYA=
Date:   Sat, 26 Oct 2019 09:44:12 +0000
Message-ID: <vbflft7u9hy.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
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
In-Reply-To: <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0334.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::34) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d5585b54-1832-4d71-689d-08d759f90eb4
x-ms-traffictypediagnostic: VI1PR05MB5968:|VI1PR05MB5968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB596852DC219E74AE37841557AD640@VI1PR05MB5968.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(5660300002)(102836004)(11346002)(6246003)(76176011)(14454004)(4001150100001)(71200400001)(53546011)(71190400001)(2616005)(6486002)(386003)(4326008)(6506007)(229853002)(305945005)(7736002)(6436002)(186003)(36756003)(4744005)(81156014)(81166006)(486006)(256004)(54906003)(66476007)(66946007)(316002)(25786009)(6512007)(3846002)(86362001)(6116002)(52116002)(99286004)(478600001)(66066001)(64756008)(26005)(2906002)(476003)(446003)(8936002)(6916009)(66446008)(66556008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5968;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIcOgn/9Mb4CgUBt6mHK/VUoenQJzuTjrlmy+I/v1QmWLBGgPdgbOl0o7TD8GLQ+Z+tTDSuEzazsFwIwP91ObRsF9mM/C6ZvQ+zHcR2qov7UOEV4GEeCsbCjrpq6W7h9Sih58++Ml7iYFaNJP/pBoZuTgBnvsON8NiYA83UIQfKMlGFgTn9fX/TMFA99JUz9w/Tw+Ejy34S5dS5ZB2qEPY4OQ+eCfGho4u7cscIJVTeHKVGGGTN6xEMgZHQAXVygSTlqqIQ31PDQuvOKWVwq7k6h4GbxCYnBxM33F3e74w5GwUpTUR5PEtlKZxqK/924jdo5hsdaleim36l3dBSruumKjHQdYg7wxl7qkD1bADmjgtAORAMudAcV1oX4q6nFsCDqBffIbyGM+YXDyJfQl6tZ6T23o3PTDw3pQx1QmGqG0VP0IHTKC7vuxU10Ee0y
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5585b54-1832-4d71-689d-08d759f90eb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 09:44:12.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ra4lw1iPTfqyT4d+3x1l4LU2L+NfW370QR+NQQFEakop1M8nsZHj30CQ8IXkVbKgDEI+LQcDReSwlxpXHRyTzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 26 Oct 2019 at 00:52, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-25 5:10 p.m., Jamal Hadi Salim wrote:
>> On 2019-10-25 5:05 p.m., Jamal Hadi Salim wrote:
>>> +    if (!root_flags && tb[TCA_ACT_ROOT_FLAGS]) {
>>> +        rf =3D nla_get_bitfield32(tb[TCA_ACT_ROOT_FLAGS]);
>>> +        root_flags =3D &rf;
>>> +    }
>>
>>
>>
>> !root_flags check doesnt look right.
>> Hopefully it makes more sense now....
>>
>
> For completion:
> It compiled ;->
>
>
> cheers,
> jamal

Okay, I understand now what you suggest. But why not unify cls and act
API, and always have flags parsed in tcf_action_init_1() as
TCA_ACT_ROOT_FLAGS like I suggested in one of my previous mails? That
way we don't have to pass pointers around.

Regards,
Vlad
