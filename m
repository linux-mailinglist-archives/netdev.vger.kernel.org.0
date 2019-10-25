Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4976FE4FF0
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440614AbfJYPS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:18:58 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:49637
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439061AbfJYPS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 11:18:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnEJhXJb/14TDAkZqpcjA/uwYZFZYw0lVlKYMH488o8VohfTcgNJUPpAeD3+53DPSnH+KafGjCGQR89gyWh0D76XTFSbJYOhAuFhRAwmMmOsXbT5kjxjZOkgj1E7DPWSJ12tVZn5UUKLK4BJ9d3FGjQ/f1iAJzWpyxPkC574HJueSECOpbLG3pifEDvhH5ABF6e0OjmnLfEOfGr1k2hzdwxQZNqiv4wcX5mdZGgg7RFn8gb2m9H+N0cHa+fnraaZiEgxka90txzlr4HoBRXPilyTcLMsaZp21ZSiyw3oVqJv9uPsxNY7F3nU2+k1pfPPcq9olA1Lljp9RSzsqmOa/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEanw8AvG+JgSfm1pCupCEmmE5+hjnlOTc0sOAepWYE=;
 b=Enwyh+3HQjy45MsizvwgM79OJ6vHa2ie0IhIYKmWY3qxMgmplZvAQeADUjvwKMK125WCFMMW+YtMXlapoTCJU/CxYCzl5gJ7mIibtsmK65pk1gIpGdhLo66FoO7KPm4lxqhkxzT5fhPF7zXgsJpuLaLM6/7oSA8HgnlcxZaS88H4oXhoKetFlR8Peqz/0che+KUWDERFFrTAlMtD1Sy6HpKKGsuoMghvM4E99FKypDWZNqTJp1rI1pZKalp3Phuqjql9BzYioJzXTaNvM6G+woucWhiYPGzkG/mbsyCHGxNGgjrwypbdjhCGwZwKRAYf+GEW3T/SctLWUDTv8CrcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEanw8AvG+JgSfm1pCupCEmmE5+hjnlOTc0sOAepWYE=;
 b=Vv1SoXLcY5XyuiMx0Be5pA4Co6fI8oxbxqeTLLYAVZgKN2S+2ZexaO65Um9BKUjfRHyaKMdTOshoVpFWbnn6BEfmytxT4soHFBsumtl6w6jG5p2Ae23JnSz747xiYI6cIK+nSjz5vCLbHrLugxiqVeJT3WOho4XUN+entjJEZ7k=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Fri, 25 Oct 2019 15:18:54 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 15:18:54 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYA
Date:   Fri, 25 Oct 2019 15:18:53 +0000
Message-ID: <vbfsgngua3p.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
In-Reply-To: <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0398.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::26) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 906e1a2f-e54e-4545-5e1a-08d7595ea5ac
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135B3C58C4CDB78F97676C2AD650@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(189003)(199004)(446003)(316002)(6916009)(4001150100001)(2906002)(476003)(2616005)(4744005)(36756003)(99286004)(11346002)(25786009)(478600001)(52116002)(76176011)(86362001)(81166006)(81156014)(66066001)(229853002)(256004)(54906003)(8676002)(6436002)(6512007)(6246003)(66476007)(66946007)(64756008)(66556008)(8936002)(4326008)(66446008)(71190400001)(386003)(7736002)(53546011)(3846002)(6116002)(102836004)(486006)(6506007)(71200400001)(26005)(5660300002)(305945005)(186003)(14454004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /S73FQgrumcyISU5Z5gbDcupfpCrCsWeHunNTJmkVMyNrDzqyx/VV/MiYp0JAoyl3CcSr/zbPHC3QH4aLqj0ydW6RMhzqyqyCpJ/ICfKDsiF19QOMMt56PzP3e7J3h/DV94o62DZXibStu4rO598spt0hwA/CXchIleQkODCHMkN9Be75QyIk/0SlbkCg96H/o/uh+QZt0FJYsvxpPJJahpWSDIAgfpelsY3XGazA0O1hUO+ammkDe7StFbtlLtwmoeQ47+KVVFKENXvsV6Jkad5YXAAXa8K4K8QZd1YU9RMqpvBdMeobf9pjpau2pY84H8M85wF535uLz1ECeql1CFx7gdnsag2fQQ37yXEYa2E6UJL8A44lCY2K68btiiODEnAAucnUujJY5Pep4+G/+qhQo1Uq6EJTqUziqx6fdu85F3LbYxov9/jziJk7aOo
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906e1a2f-e54e-4545-5e1a-08d7595ea5ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 15:18:53.9518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rp0vdFfeJzlY5RBhEmf5dpysUaB9vGA3/Q5YOKZwxoidaCg/y76rJk54Klv+S+2apsamI1yTstVNqnWegiEMtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 25 Oct 2019 at 18:08, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-25 10:57 a.m., Jamal Hadi Salim wrote:
>> On 2019-10-25 10:26 a.m., Vlad Buslov wrote:
>
>>
>> I think i understand what you are saying. Let me take a quick
>> look at the code and get back to you.
>>
>
> How about something like this (not even compile tested)..
>
> Yes, that init is getting uglier... over time if we
> are going to move things into shared attributes we will
> need to introduce a new data struct to pass to ->init()
>
> cheers,
> jamal

The problem with this approach is that it only works when actions are
created through act API, and not when they are created together with
filter by cls API which doesn't expect or parse TCA_ROOT. That is why I
wanted to have something in tcf_action_init_1() which is called by both
of them.
