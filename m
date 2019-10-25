Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD36E50D9
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505117AbfJYQKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:10:31 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:21158
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728051AbfJYQKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 12:10:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+R0aCjUiWVzKq6BAUxxHMNUQHHilC8Prw4O7jYd99jOwlpEbr985adHLl6e1rpGhAJ+MTFTFwPjqBb+GZh0EzcHSWudWJcEOV9Rgrvr+r5/Dovcx/4L9B6+e/OTu/DBxYrj4Ht5eNmnRoabsU5EAK7TQgCG9dnNHh2ZMD8cw2X7fAG4sQxu2Dg/jS9NUsv31/u4/gRyClf/KMN+smY6nnlRoQB4fdkDd/kdK+STZSbZSfz6BwQ1/YtgruaONS7Yll4tDSwkyPIL+dHHccvHbZhVnDzm72iSMUazabESwfycmEXJy2xIfUjcgxd0HfZEsuD7Zca5rRdImPMw8+24nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VXmPXeR5wBmcuvVYz6QchGBecxOTJdcy8ohCWRMF/g=;
 b=ibCob3LthJa7yhDODS30hiqywOYwfRmk2PJSzYBK/jO57buZluCSxZlb0wBVEDA9dd6uUL611P+Ian7h+7uYM4NUfW2ifIY+4dBoX3CQMnBmwHUqkYfDUDzI6iMrk/ZutZuY0k0DipNreWzLuKXtjtNmCwbv6YmbDUEJHQDIHdhwpm5ZlZsk2gB0OnU1X3xeH2eTslZohIbmB6YuyBW/yXzG5gxBAVCltIH0MexMAxYSW2q1VOZeZ6SaT4WuS6jsC09HLvibU52SMWR1Jv9qaP7+wF2ScJeZfMPo7gRN25JtCabcGq6HoJLHnhmTPSQ3lwZ/9trtEhVEkNXRnHkHpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VXmPXeR5wBmcuvVYz6QchGBecxOTJdcy8ohCWRMF/g=;
 b=LkM3BBD2FFb18mBeBB1aHpyhJFe4M06iFV4bg7s/Y2jZbTBd7MuM8HUpoeQrjHx0k8fvJkodERMLnysf+hJHsup0eeAoujAcQSm5w22oKxXvoF9qOGh5dUB+QY2/KgsO52HXkptAHx98AMbAlzuhDAIna7k8SLXTsOlA627GYo4=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5375.eurprd05.prod.outlook.com (20.178.10.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 25 Oct 2019 16:10:27 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 16:10:27 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAAATEA
Date:   Fri, 25 Oct 2019 16:10:26 +0000
Message-ID: <vbfpniku7pr.fsf@mellanox.com>
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
In-Reply-To: <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0330.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::30) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5e1280b-5ce9-4de3-1573-08d75965d944
x-ms-traffictypediagnostic: VI1PR05MB5375:|VI1PR05MB5375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53758B846730FBE07497B7B2AD650@VI1PR05MB5375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(199004)(189003)(446003)(25786009)(2906002)(478600001)(64756008)(186003)(6916009)(5660300002)(36756003)(4326008)(6116002)(71190400001)(71200400001)(66476007)(66556008)(2616005)(386003)(11346002)(476003)(99286004)(66946007)(3846002)(52116002)(486006)(66066001)(6506007)(4001150100001)(53546011)(26005)(76176011)(6486002)(102836004)(8936002)(6512007)(86362001)(305945005)(54906003)(8676002)(316002)(6436002)(229853002)(66446008)(6246003)(256004)(14454004)(7736002)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5375;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZSl3b3Gl8upoAbe0bbz6wIGhKQ3++bNqlKzVAXmui4bKwfRSeXp0cpFOEsG24BUiSGahHiPanxrbM4k7A2Td/LTDCgHu9a4YmMxgdeQAcnpB4IGb+VNP2a4tykBqLHUECJZJf7aiQJrXj8Ao2HXbSkNCGcoQQ4CKDStiDMc6v4wU8QGC8fYCvz+z0ZdCx63f/Fe6Treka0kofD7Wl4NW98VnvSv3HllcRanvGaSPBmzvwrZH08WaeZR8LjU0VUZopj898hkaI8UDBmBWZ+gnjvYjHtp9+/FeZmm2qeAwKjj6VHJ15WYh4bvtvZPmilNhYfghhDcuHvwrD56g0Tzxl+tsFMnjqy6wN8cd1+Zq9sB3rULJ2kkywMZ2DmO5iX9pfE7W6oLqytHjm5lJQeGSuwH8FVBn+akeFrwE75j9s0p0LxBmK09YZImJtAQKUHa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e1280b-5ce9-4de3-1573-08d75965d944
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 16:10:26.9880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JrEGX6imMvrHZ9f+c/xb7dBqOBQEucL9YunreFZ+Jp5rKXeTHRboI8RQM7SWduArpcGcXpWkXFpidgvJr9c0CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 25 Oct 2019 at 19:06, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-25 11:43 a.m., Jamal Hadi Salim wrote:
>> On 2019-10-25 11:18 a.m., Vlad Buslov wrote:
>>>
>>
>>> The problem with this approach is that it only works when actions are
>>> created through act API, and not when they are created together with
>>> filter by cls API which doesn't expect or parse TCA_ROOT. That is why I
>>> wanted to have something in tcf_action_init_1() which is called by both
>>> of them.
>>>
>>
>> Aha. So the call path for tcf_action_init_1() via cls_api also needs
>> to have this infra. I think i understand better what you wanted
>> to do earlier with changing those enums.
>>
>
> Hold on. Looking more at the code, direct call for tcf_action_init_1()
> from the cls code path is for backward compat of old policer approach.
> I think even modern iproute2 doesnt support that kind of call
> anymore. So you can pass NULL there for the *flags.

But having the FAST_INIT flag set when creating actions through cls API
is my main use case. Are you suggesting to only have flags when actions
created through act API?

>
> But: for direct call to tcf_action_init() we would have
> to extract the flag from the TLV.
> The TLV already has TCA_ROOT_FLAGS in it.
>
>
> cheers,
> jamal

