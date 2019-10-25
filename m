Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24942E50CD
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504292AbfJYQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:08:41 -0400
Received: from mail-eopbgr00080.outbound.protection.outlook.com ([40.107.0.80]:57732
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729004AbfJYQIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 12:08:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KINvdpKQqqZBTd37NUcDNd25JFDSrY9Ca0cL71BfqUD8Mo0FsKjj+lx4V65HwfTjfJ/bwyuFQoQhNhglMQgtGJJlEp/1/p24wBnN2vGqs78ah8mORtxUUk8F/Y5Awk74pkkCoCkyj2h9ofuEsglB6iXVKWbdn1kyBHPTvsTTP4l0HMAz0Pj+wVZncmluyvAcSqcrAQ4XjQfBgGH+xRolNeqkYACNeLBwTTRHhoF79bVWJBrZihrsenNorIvXunyPN7iBdnab2eLn8YOUuQGOYBGq/eFyRTn3tFck64L4XqOui77QvGeVsxeRewkrXFwRaHJpTlzCicSddWmble491w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCq4NTvl14m/sIyLBtR1QJgcRIcplPHs4mZ12Ll+yGg=;
 b=AGozviqHEZzbMXwZw0FAkfxKA9Ww2MxkIlZR8Eqlfkq7yeYz3B0CsQXmq8kdb2rKWWDjinzjM6ndpvc30Z92Mli6QViFmnURB7OacXoqted2WT6Er5jnw+mk5f6UhXWzxFdeQF/6bTfOLjiE4C1rHdMfrnvou5141p4fAm4vWL1QEZgbm0vgN8lLxtffiu0KtHMZTLrr7atYLH/MgjQepjqt4L0rHRLDa/n7aGFefE2ozsibyGfvtzESiEKhnxAkPnvNALCKsgBC/DqEXkPpaEfFXPkls52dBm9fBHrFQLoitmORKGXbVCkMrn7dEBEQ9B+gYe5TX1FMaWs42Rp4yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCq4NTvl14m/sIyLBtR1QJgcRIcplPHs4mZ12Ll+yGg=;
 b=qJg1t06tj9tQ4TMxjv2965RNu9BOgJqLXkiFBBMQMwkaWN1A1Ire0ghkxt44QYkkUWOS4RS2ZTzx8CosKbuMGGhOnkQBMYxeUsb7CobyeUWqpvkKYpEherQWagyfnqBZmquQ+UX9bdrvJ+ysG5TBFdfDwp6JYlEJ2wnoYgKjPf4=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5343.eurprd05.prod.outlook.com (20.178.11.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Fri, 25 Oct 2019 16:08:36 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 16:08:36 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAb2gA==
Date:   Fri, 25 Oct 2019 16:08:36 +0000
Message-ID: <vbfr230u7su.fsf@mellanox.com>
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
In-Reply-To: <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0479.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::35) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8900c638-7fc1-43e5-9c52-08d759659784
x-ms-traffictypediagnostic: VI1PR05MB5343:|VI1PR05MB5343:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5343FB2E43F30102C7B66CD3AD650@VI1PR05MB5343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(199004)(189003)(66446008)(26005)(8676002)(6916009)(6506007)(6436002)(316002)(86362001)(52116002)(256004)(99286004)(446003)(476003)(6246003)(2616005)(11346002)(486006)(36756003)(6486002)(25786009)(386003)(53546011)(66066001)(76176011)(54906003)(2906002)(229853002)(66476007)(102836004)(66556008)(66946007)(5660300002)(71190400001)(186003)(64756008)(4326008)(71200400001)(14454004)(4001150100001)(7736002)(6116002)(81166006)(81156014)(305945005)(8936002)(3846002)(478600001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5343;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kHJDQFLAKwzXsT5/RvkmnGoSEMcqe8CJUm5YWkIj5EGULZ7JjK/EUGVpqFXCl1JaJQ62TLLuM9abP+xgVTeI4lPIU5PteUJvRyz1FtqOwZ+X5EiX6uALk6y9YFdOJPp3z0PT9YqjfgaaOcKKX/54FG+9yfjVubLntU49BszkiqE4YUtG7aNuzrQRIUmGg93XLApGS90GgF/PMIdANIOlcqavS8YlBHoxFW4cyAy1Qs1YUsIrcYbP3+wev8mXQYSbtelN+z4Ye86NSAzC58ibTXOIH75vqxSROBCVip7uMvfMnWeCWMW0tx7KRomqv8FQyZXq/QHGrBFPSbLk2c7UFB9CteONlQh6Ci79mQM31DRGNBET3TiG0qtQlrhtABPz277jcegRI8WiQ7T8WNDAjrEL746kjwFHUn6xOGiMB7mjhZFS1vC8sYHzZu4yIe3B
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8900c638-7fc1-43e5-9c52-08d759659784
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 16:08:36.7272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VPnCro8X8vxUKj/sLfZF1NiYhDcQArGZpIZZJz1t1DrwfVQmublgA09iMWISO3hGP42eQSwbCb1j8aLQgs49pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 25 Oct 2019 at 18:43, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-25 11:18 a.m., Vlad Buslov wrote:
>>
>
>> The problem with this approach is that it only works when actions are
>> created through act API, and not when they are created together with
>> filter by cls API which doesn't expect or parse TCA_ROOT. That is why I
>> wanted to have something in tcf_action_init_1() which is called by both
>> of them.
>>
>
> Aha. So the call path for tcf_action_init_1() via cls_api also needs
> to have this infra. I think i understand better what you wanted
> to do earlier with changing those enums.
>
> This is fixable - we just need to have the classifier side also take a
> new action root flags bitfield (I can send a sample). To your original

Trying to add this infra to cls API leads back to my original question:
how do I do it in backward compatible manner? I assume that we can't
break users of RTM_NEWTFILTER.

> comment, it is ugly. But maybe "fixing it" is pushing the boundaries
> and we should just go on and let your original approach in.
> My only worry is, given this is uapi, if we go back to your original
> idea we continue to propagate the bad design and we cant take it back
> (all the tooling etc would be cast for the next 5 years even if we
> did fix it in a month). Thoughts?

I don't see anything particularly ugly with extending either
action-specific attributes or TCA_ACT_* attributes, so its hard for me
to reason about problems with current approach :)

>
> cheers,
> jamal
