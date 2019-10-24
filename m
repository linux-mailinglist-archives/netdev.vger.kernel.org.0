Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449D4E3683
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503128AbfJXPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:23:57 -0400
Received: from mail-eopbgr00058.outbound.protection.outlook.com ([40.107.0.58]:43611
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503066AbfJXPX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 11:23:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6cOpLHsAzW19rJ1eD89gcFO3RrC+oLw405vNQAixQcNgtna7mCNCWTTD2HFM8O6zwqrgSFgkyLpO6HCZExHI1BAEXwMIM6wOQxV+H8fP39UmOybMkjy3kDAMYu1R0cX3Jxx2pWnAZhNNZ6f1CosJ+Y5yBtXsIKDc6sJj3IatnDJLmIuzhXx/PK5efsvOLMANwyjwkSQrY0PgafqQjRZ7n/ceiljeBj0mJo9oKBss8TC9255j8YmoM5a5fK2VXgEUUlZtdPqLS0RZPhlhIz+dX22MmZceMUaDwq90p9u48aTi0BFhGRYlu2T5QYJcZg6QGZWTxbUvq9K5WruTAhDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nFoFpuEpNJUTk/BKbUMc6ebyzV4WNJeM+4HZlKW7EI=;
 b=TvBdUsZlHQTQJ+8NVxL5WWLCXiCpamPZw898G11+kh9TjEmWympLxSXYPKrMB9VGt49OVO1apMuQIMj32NgW8YrBZ6AR8Dic19R9o8pOHTlKgi8dgukcDv+uH1RvSybbFL8ZYmqOpifqVAtq3aT0LQxeuYMEFI5ygOObBPwJSaDGUg2IjYXgj/xT/c+9xw7lNU/ilWmzjpAiw+H4cjwKEXthxLo+Bm0HlYLlGksuhl3u2wo4AjrphOuHjzVde8e6UesAPT+AYKxjUqKfS/fqg8Z7fH1UhuYMBg7WgTUkAbEg6/arEYns85WiWO5d1IwPDqhwoARmO0d0kPeVxF3Z+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nFoFpuEpNJUTk/BKbUMc6ebyzV4WNJeM+4HZlKW7EI=;
 b=V206+tt8LPuRmGCw+yzNOa9JWA852B3TMhg+HNFXOuSx9+KI1sW4IQRLKb/ItvH3SzAIH4y7S+Bm4RdZ9bKh7ShlBbu/gLfb/QQJDezKLW4/QVe+OJvo9zlWp/qo1zH7MPnZXGPElmjeUe56oFIwcWsgLRYGMITiYY7IGhZ4IcU=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4224.eurprd05.prod.outlook.com (10.171.182.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 15:23:52 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 15:23:52 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Jiri Pirko <jiri@resnulli.us>, Vlad Buslov <vladbu@mellanox.com>,
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuAA=
Date:   Thu, 24 Oct 2019 15:23:52 +0000
Message-ID: <vbfwocuupyz.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion>
In-Reply-To: <20191024073557.GB2233@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0299.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::23) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e8175b07-d27c-4423-444e-08d758962d11
x-ms-traffictypediagnostic: VI1PR05MB4224:|VI1PR05MB4224:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB422485508424265DCE55522CAD6A0@VI1PR05MB4224.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(189003)(199004)(229853002)(446003)(99286004)(81166006)(11346002)(25786009)(486006)(6486002)(6436002)(102836004)(26005)(386003)(2616005)(14444005)(256004)(6512007)(6506007)(71190400001)(71200400001)(36756003)(6916009)(6116002)(3846002)(4326008)(478600001)(6246003)(2906002)(476003)(8936002)(8676002)(81156014)(4001150100001)(66556008)(64756008)(66446008)(66476007)(66946007)(186003)(14454004)(5660300002)(76176011)(52116002)(316002)(66066001)(7736002)(54906003)(305945005)(86362001)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4224;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LKfPlRdzRgvAEX+zkUCgxsBDeV1LEPQ8UG0gX/PCmgA2DWnChvZvu8O+iG+Yv12gm09idqt2vmEAjmhWm37CqYNvAkoCspJoxVdYyuJ1fUUKMrUei/VbaFC92i5gI8on2wRYzZGXlvkHsYi9vCrdE1lQZFSj05OhdGxB4exd6/a373WDkEiZnHOiWR1xn6c7r2quxlX2KsfpzftVLleHabedHv1qUYStLN9wly+fQrvOy+b4tNIlwxqPI7S4YQowcVZGelRLIMKOzONMU3jQ1/zu0nu4MDW6vq253VHvbuTSZLpoOfR2mX02KB2qJpB8A9TFW9a8fpIcHBihLLP2zOx9xav2XiRZlJazIQmFZi8wxnYn2GRNGVqfKvBKqd0ZiIRKqY9bPGPfYdqBJc9cL4FSifLb0CtxfGYIbPFEvkz9374K8qdh/cizHFIVGciz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8175b07-d27c-4423-444e-08d758962d11
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 15:23:52.2368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9l4veHKnfKC5T8LpNPbrpVfiUHP0XB/QERU9XbCuhM359Zcv2E3hMTPVgBn/3VTX8yDlOzOchuie3RHXqJjiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 24 Oct 2019 at 10:35, Jiri Pirko <jiri@resnulli.us> wrote:
> Wed, Oct 23, 2019 at 04:21:51PM CEST, jhs@mojatatu.com wrote:
>>On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
>>>=20
>>> On Wed 23 Oct 2019 at 15:49, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> > Hi Vlad,
>>> >=20
>>
>>> > I understand your use case being different since it is for h/w
>>> > offload. If you have time can you test with batching many actions
>>> > and seeing the before/after improvement?
>>>=20
>>> Will do.
>>
>>Thanks.
>>
>>I think you may have published number before, but would be interesting
>>to see the before and after of adding the action first and measuring the
>>filter improvement without caring about the allocator.
>>
>>>=20
>>> >=20
>>> > Note: even for h/w offload it makes sense to first create the actions
>>> > then bind to filters (in my world thats what we end up doing).
>>> > If we can improve the first phase it is a win for both s/w and hw use
>>> > cases.
>>> >=20
>>> > Question:
>>> > Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
>>> > sense to use Could you have used a TLV in the namespace of TCA_ACT_MA=
X
>>> > (outer TLV)? You will have to pass a param to ->init().
>>>=20
>>> It is not common for all actions. I omitted modifying actions that are
>>> not offloaded and some actions don't user percpu allocator at all
>>> (pedit, for example) and have no use for this flag at the moment.
>>
>>pedit just never got updated (its simple to update). There is
>>value in the software to have _all_ the actions use per cpu stats.
>>It improves fast path performance.
>>
>>Jiri complains constantly about all these new per-action TLVs
>>which are generic. He promised to "fix it all" someday. Jiri i notice
>>your ack here, what happened? ;->
>
> Correct, it would be great. However not sure how exactly to do that now.
> Do you have some ideas.
>
> But basically this patchset does what was done many many times in the
> past. I think it was a mistake in the original design not to have some
> "common attrs" :/ Lesson learned for next interfaces.

Jamal, can we reach some conclusion? Do you still suggest to refactor
the patches to use TCA_ROOT_FLAGS and parse it in act API instead of
individual actions?

Thanks,
Vlad
