Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C988E1ED1
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406472AbfJWPEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:04:52 -0400
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:3589
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390431AbfJWPEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 11:04:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/C0LUvreh2lON8OfO2xglX5h8jUnyhIlhMtqR5uQT1P0L16VfnriWRumAKiJUZfaE0ygTvTtGC8TZPWi5JgIXHhISgdMeL8CKoCqxBoDjI9L043/k9pF0DtxR8c4nXiumS8rgSDI/LCfvSIGUb0/QQdwh9jYWVT/RRIYWcrwPAF+LkpRGYmVhc3T9dz7Sqbf1ZdUGynaj4+WRT+i0IpWemfsa7WjGmDm0kLs4MOKIIzgf4/nldeImb0Xdwpixz1msTPty0CDBVUNO3L2VpsYG33NVQGukTXN/w0A/6XqyUY9D/941my+E4l6FHbAvqZqSb0B5rixKfqpmH5Kwmi/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6F1J8KX0J6EL9hcayJ4NxIsH+m0N41/K12iEsL//Cg=;
 b=AOXG61bmWAZk+4EUAMOMgWoMGmdcTeKQ7QB55d/588nLU1tJpeNnQVtjjdV0mYMDqI2NpuHNcHzz2K2SkVaqEtkOUUjg7rAuFXHSQLJiIHCrVviCjhM/JIPbLVtOnVX+PxvgJ7WO1fDTNMnUyv8N9p+uJ8efU6QkbsToSVA1bmwnYS/I5Ick3sIxo4faZDkjBp+dZMSAfZ4UFy23j9GLJ0wxVT7DqAfzZKjGS62Lb7lWf9T1eehapRpsLJUxjcKfx/lLm4MH3bTbXXUi424X8U8Kd+ZmoCP6HG6AQBjK+4TKHpaydx622GoSCtLIurquks4aQTO/uQaFgHsh4fGhZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6F1J8KX0J6EL9hcayJ4NxIsH+m0N41/K12iEsL//Cg=;
 b=VigSp1WbdPfUSNmYv3fy8J8C9/XGCsfoRptraHWvGPjx4meU4iyEHDXx+WlxGawNkQfIofgGCd3KqfwFG/2aYVbtvIyvnYhb+RNQeyE75NNbtm9OGBvt3q/R6Y2tGLfJBeny/65S89kWEwpd4FDbIMNuTRoF++3R9YvJQGxdYlA=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3325.eurprd05.prod.outlook.com (10.175.244.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 15:04:47 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 15:04:46 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIAAC/qA
Date:   Wed, 23 Oct 2019 15:04:46 +0000
Message-ID: <vbf4kzzy038.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
In-Reply-To: <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0406.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::34) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b564a93f-e108-4333-4d93-08d757ca57cb
x-ms-traffictypediagnostic: VI1PR05MB3325:|VI1PR05MB3325:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3325C36DEDA75B4A223AE44DAD6B0@VI1PR05MB3325.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(199004)(189003)(53546011)(6436002)(66946007)(6486002)(305945005)(7736002)(6512007)(6116002)(386003)(3846002)(6506007)(229853002)(99286004)(26005)(102836004)(4326008)(186003)(11346002)(64756008)(5660300002)(8676002)(81166006)(14454004)(66556008)(81156014)(86362001)(66476007)(2616005)(476003)(486006)(8936002)(446003)(478600001)(66446008)(2906002)(25786009)(256004)(4001150100001)(54906003)(14444005)(316002)(36756003)(71190400001)(52116002)(71200400001)(6246003)(6916009)(66066001)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3325;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FivwiM5XM9Kqm85FdHsapKHZBKzcK1gDgNTIxHKvX+th+Z9R2xTHcWmSGgBLA7PCuDZ81+ARTtiK1MXhYnP6iXablXrJTbmfyVY1zI7UHXJzlRd8/pTlSd0LzJMUV1wI7E2Rjp/seFHzpEFUlgDqqRsDTAw5KlU2fWz1cr3PKNXUUC2yMjJvHtVxUPE9ncUFXabw8wjdxSgbjKuEdTy439cgdCrjMWgqIuRrpKhBWeSKolarMPgaHW2zJcbIp1+ydUQzZXzliMKRsTSx9qKv3FNenzN3KxgvRUKXCorKElvRu6mCtSUFTMlsudJ1U+oa5yyPFroN8AJ3ZMnfn6vI5KaLCy+yGO6G+mh9jE7EAcff2bDZ+Xj61E1gna6oyA5YFGhK3g38xzxyp4zSqJ6BfASukw5bKcZ/WXz/8h95mVCJsnL0TRjC2Tz5Mi0QiKUt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b564a93f-e108-4333-4d93-08d757ca57cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 15:04:46.8003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/ezl/OEFpfePlLL/gfJELtzTye2XcuxUWQkDLe1EN5ok0djvSUWglHHsFjfjbWq12sXdCbpcrQ58H/GwaZ7BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3325
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 23 Oct 2019 at 17:21, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
>>
>> On Wed 23 Oct 2019 at 15:49, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> Hi Vlad,
>>>
>
>>> I understand your use case being different since it is for h/w
>>> offload. If you have time can you test with batching many actions
>>> and seeing the before/after improvement?
>>
>> Will do.
>
> Thanks.
>
> I think you may have published number before, but would be interesting
> to see the before and after of adding the action first and measuring the
> filter improvement without caring about the allocator.

For filter with single gact drop action (first line in insertion rate
table in the cover letter) I get insertion rate of 412k rules/sec with
all of the actions preallocated in advance, which is 2x improvement.

>
>>
>>>
>>> Note: even for h/w offload it makes sense to first create the actions
>>> then bind to filters (in my world thats what we end up doing).
>>> If we can improve the first phase it is a win for both s/w and hw use
>>> cases.
>>>
>>> Question:
>>> Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
>>> sense to use Could you have used a TLV in the namespace of TCA_ACT_MAX
>>> (outer TLV)? You will have to pass a param to ->init().
>>
>> It is not common for all actions. I omitted modifying actions that are
>> not offloaded and some actions don't user percpu allocator at all
>> (pedit, for example) and have no use for this flag at the moment.
>
> pedit just never got updated (its simple to update). There is
> value in the software to have _all_ the actions use per cpu stats.
> It improves fast path performance.
>
> Jiri complains constantly about all these new per-action TLVs
> which are generic. He promised to "fix it all" someday. Jiri i notice
> your ack here, what happened? ;->
>
> cheers,
> jamal
