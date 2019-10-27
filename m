Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03E5E61AA
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 09:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfJ0IcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 04:32:17 -0400
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:26197
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfJ0IcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 04:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y05fLIOPlVWtIjd5YxdczVl3AUN20f57lAEngRYZPXB5ShGfYvr2FNCvlKW4vMQr+ZAtwp/br4H+xO82PHG3Y0wTMW6ngSqMDs8dRKSWkXtmRCMGntymr4yZ40iEEHYWMkUbXX36T09qkurzvjEr1OUJMX4ik3QqMfHMnaKOGRw+9yXFe7CPuHkhMuenLjfATrwdbtRu0T3RDRChok8/itpgj+mYTfoi5rfICeTSaIvvITwVOlbpSMVxtHCXHnYzfeAwIoicETpdCZsWTdFQM1psw4yzuO/7M9gjaOpEZIY0v5FLRl9GdIj+SXOPJfp8IElAY2CTh06+HytLrKMbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4fGY9hLY6ZLBP03XxvECxlWrQjdNi0jFDqS1HnmUSk=;
 b=JXwEgL1uXe8mHGbllCDytHZwLxRvKhQysZZXzHc0zph3K2Qwf4EzlV890t0q5vPZavg4b/ad4BO/6XOtidulcIETrqpglm64YXsJsWs27Ll37XZAK8DS+eqcU5cw/7NJtrsLeRlaTRMci7EWAoBN/P+yzr/CPwnXB+09AG7BZfRIPKpe5JPIkjgebLanPz1oy6gY0m6s1qWhiAU9dqf6Tn2rTAbuxSj7orz4G49X7d1lRShUW540pEknp+00MyVBBcYcRnPoMeGUK1Lh5NTNzfSoYGzhjUkmKusO/urXRUaZvx3gbuEGsmfvdfW8/VKSMRQpJdlU044fmPbDNy8XvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4fGY9hLY6ZLBP03XxvECxlWrQjdNi0jFDqS1HnmUSk=;
 b=boTCCVhL/tNPqeJLHlRvpzNj+daVBdXBowcYVSJMWOMF6HjUmBo/DfhxxpFFnRTWBwrAnltNaGrWnmouZoVvJwjdMefbpIJNlcfWuyLFbKpMlTAWhIKiRGlGILFOoN4UZk6/hulGInN4IocE5StjLmBg+zPlGs2Z2JLciR8xJio=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5807.eurprd05.prod.outlook.com (20.178.122.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Sun, 27 Oct 2019 08:31:32 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Sun, 27 Oct 2019
 08:31:32 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>,
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAAATEAgAAFeYCAAAZxAIAAF6UAgAAu94CAAAE3AIAAC+2AgADGwYCAAC1LAIAAKRI9gAAUhoCAAAnwgIAAIG6AgADow4A=
Date:   Sun, 27 Oct 2019 08:31:32 +0000
Message-ID: <vbfimoatwrk.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
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
 <vbfk18rtq52.fsf@mellanox.com>
 <7c1efa70-bf63-a803-0321-610a963dcd9c@mojatatu.com>
In-Reply-To: <7c1efa70-bf63-a803-0321-610a963dcd9c@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0259.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::31) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e96e9f2-076b-4cfd-deb8-08d75ab8125d
x-ms-traffictypediagnostic: VI1PR05MB5807:|VI1PR05MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58075621C9DEE9C8749DF435AD670@VI1PR05MB5807.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0203C93D51
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39850400004)(396003)(366004)(199004)(189003)(71190400001)(8676002)(86362001)(229853002)(486006)(186003)(76176011)(4001150100001)(3846002)(52116002)(6916009)(8936002)(6436002)(386003)(26005)(6486002)(53546011)(81156014)(81166006)(102836004)(99286004)(66066001)(6246003)(316002)(305945005)(7736002)(6116002)(14454004)(71200400001)(25786009)(64756008)(66556008)(66476007)(54906003)(5660300002)(66446008)(66946007)(36756003)(2906002)(478600001)(4326008)(11346002)(446003)(5024004)(14444005)(256004)(476003)(2616005)(6512007)(6506007)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5807;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xqT3IxtvwYr0aaZ4AxmB+GyII/hQJqqzAxWhnIiBOCqeFbmsTfKQxXNlkTyDeYHKZokHhl6cTaeVgqKG3H3Xdj0jUYpRzf7Ogmzb9QWpLX4W3eV1XZk7DU83Yn0mI4EOXKu5Xd46hlHEz8cuHthntZiJfUYBmz2cmKKMwi8ujZwPEO+SnHRL5uXruqatqV9ArgkQVAlg6Q75LVQg9E/MealYUj6/ARQS5MxN6BV2vHt43YoKLpx0bezPwZP5097RYYr3puC1nS98oKUi9gVhHCfR3cDQ3JDsyHPMQY69sVSCZL9/9r+Z2OqmHovcKkfyOPV0IMcxfh1y1Q/7ArsLV5XQxk9BTwKcFXK1+90pTyz9wiprlSNqvbeD3nLTFmjLd/4coRWDhRtiq7R7r32ncUPw47YR7g9OtSMI08imjjZFjepP25F6cDE6m9QvmyQO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e96e9f2-076b-4cfd-deb8-08d75ab8125d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2019 08:31:32.6297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: omYSGekY5vdkUYcNrwc04MA1QeOarYWwG+FcF6Jt1va4s01R4Ip66roS9LMi3R/O3rBPa+RTSu1LF6DJq50+GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 26 Oct 2019 at 21:38, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-26 12:42 p.m., Vlad Buslov wrote:
>>
>> On Sat 26 Oct 2019 at 19:06, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>> Hmm, yes, this looks quite redundant.
>
> It's legit.
> Two different code paths for two different objects
> that can be configured independently or together.
> Only other thing that does this is FIB/NH path.
>
>> At the same time having basically
>> same flags in two different spaces is ugly. Maybe correct approach would
>> be not to add act API at all and only extend tcf_action_init_1() to be
>> used from cls API? I don't see a use for act API at the moment because
>> the only flag value (skip percpu allocation) is hardware offloads
>> specific and such clients generally create action through cls new filter
>> API. WDYT?
>>
>
> I am not sure if there is a gain. Your code path is
> tcf_exts_validate()->tcf_action_init()->tcf_action_init_1()
>
> Do you want to replicate the tcf_action_init() in
> cls?
>
> cheers,
> jamal

No, I meant that we don't need to change iproute2 to always send new
TCA_ACT_ROOT_FLAGS. They can be set conditionally (only when user set
the flag) or only when creating filters with actions attached (cls API).
Such approach wouldn't introduce any additional overhead to netlink
packets when batch creating actions.

Regards,
Vlad
