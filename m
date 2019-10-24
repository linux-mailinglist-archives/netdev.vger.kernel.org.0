Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD7DE3879
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436782AbfJXQpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:45:25 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:12000
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390181AbfJXQpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 12:45:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Er0ZKKssyb1JHaj0Kcksbuut4WJtGsRhFA2yX+rQRxhlh//alZhks+mURx2eWHXVDg3hwNTr4EBymjGCtDtgR+g75Acvr/e+oBxJygPcFIcqtqYpS5AyccKyLXXoJNz1ZvLm6PsVx8focfJEoyRZsxORRdRLQJmnTTMwrviro9fqn/3wKXOtT1DGBkh8ZbZBfcN/fSflFcIbyrdU2zT8sGuMtj0sJUCDdie0nN6ulCJsE8G5Feq3Rt/m8zchM5ZpvSiCKGKFsXHsfgOP8/R63W6X7SeMiI8KwJC9SyMty0jHTJqwyT/PPg/Z6ZOZYHR+Ndn+AwELNo2KFGwwjUcxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHi6/3RZQHiAcaqmMkrav1PjQiGcAgXWPVVz82MFRPI=;
 b=bCcA4kb0oGxhOatt7Obk0KQAn/rve2+fw8cD73E4n/nasHwmw7WTONFfRqRitujKq7zRsUfFxosqZbfNUboYlaDjBzqy0AWb8DtRIgu/zJWhNWxhawU/gZwfbSt6ZX8O5c05MYeI87zZDL4TBRw6zfGvOMNrR9rCwRPPzQ3tOscI6ttDpRFDovo0H+0p5bYYKSbOcpxvom3iyDP1KY4qEUpTmvseMzIU3FP5kZJDiJhV/0sitBYd3aHSqCCfYl96wmAsCpMDaUcty+q4vT+2yC5Ao+/53tWrl64VniT+cnpBsot1a84NtTCNqlfZ3SrzaSYkWkzn4UYTgj/1aZRA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHi6/3RZQHiAcaqmMkrav1PjQiGcAgXWPVVz82MFRPI=;
 b=KXON0PdYejG0839cZ+HTJJEM4js2IWVwYuZLC24IlJJQ6eGyOslGj5ZvRioRZkJ/DYMoH3MKsdrDPfaSQjAg8X8U7SMKnQZm46+Ai5JvzIwX94zagN7eBup2jB34QKNjXWGzi+lE5iscy3Bs38j5YAW6OBgaGQsiJ+at0fnnMRs=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4239.eurprd05.prod.outlook.com (52.134.123.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Thu, 24 Oct 2019 16:44:40 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 16:44:40 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIAACQIA
Date:   Thu, 24 Oct 2019 16:44:40 +0000
Message-ID: <vbfv9se6qkr.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
In-Reply-To: <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0232.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::28) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 379d6f5e-2539-4545-d3d2-08d758a17716
x-ms-traffictypediagnostic: VI1PR05MB4239:|VI1PR05MB4239:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42393C3B2B176C217E804E50AD6A0@VI1PR05MB4239.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(71190400001)(36756003)(6246003)(6436002)(4326008)(6116002)(86362001)(6916009)(3846002)(4001150100001)(6486002)(2906002)(71200400001)(478600001)(5660300002)(26005)(76176011)(64756008)(486006)(66446008)(476003)(11346002)(186003)(256004)(66476007)(66556008)(386003)(6506007)(53546011)(66946007)(305945005)(7736002)(446003)(52116002)(66066001)(25786009)(99286004)(6512007)(81166006)(81156014)(8936002)(8676002)(229853002)(14444005)(2616005)(316002)(54906003)(14454004)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4239;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lDpDLxWjBHgXj+a9nSd7wBPQhAYF+uc4AqgyoMqThmI82Z3KBFEEGmK/P1jJ4a2roFB10X42HjkPjc4EFmGqOyyZe7n3IU9ZYl+dkoVYRxFoaWUIYrWchm5MyH9Rp1JkKHstV0cIfXQNgM20WMU68qQQBc2BlKRj507kXIy/0bsbk+lUdPjjGpbr26wprGxcYAq8vdHz6Zznd2IPtgrdIH3V/IMh2CeVo1CMq1tkImLaKdJ72crqOvEJf9ylJLp5+ZtbgaChwBHQ/PUWRR6nlWlUOIOD0a753FCr5qavZhvteXNP4ftBVqCAToe97Ex4wZm96wY21cfAgLEdJ5DnRxSnnUqB7DisswOXRdkYlwWgiuWUMMoUJYWYl46/QascwFYfYB+wn4Ur10z+r2lrjrCXx/sVGwdeoSRrJOQ/y3UTiwJIxKtcg5zshvrz29h
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379d6f5e-2539-4545-d3d2-08d758a17716
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 16:44:40.8337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNEm9k1EzwklWxj9bGGKnv9rezlERZGbdbrDpbKTz5Jvlk2wBYCWJ3UvT/4umRVap6Tu6GZ3TWXrfivtLfl0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4239
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 24 Oct 2019 at 19:12, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2019-10-24 11:23 a.m., Vlad Buslov wrote:
>> On Thu 24 Oct 2019 at 10:35, Jiri Pirko <jiri@resnulli.us> wrote:
>>> Wed, Oct 23, 2019 at 04:21:51PM CEST, jhs@mojatatu.com wrote:
>>>> On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
>>>>>
>
> [..]
>>>> Jiri complains constantly about all these new per-action TLVs
>>>> which are generic. He promised to "fix it all" someday. Jiri i notice
>>>> your ack here, what happened? ;->
>>>
>>> Correct, it would be great. However not sure how exactly to do that now=
.
>>> Do you have some ideas.
>>>
>>>
>>> But basically this patchset does what was done many many times in the
>>> past. I think it was a mistake in the original design not to have some
>>> "common attrs" :/ Lesson learned for next interfaces.
>>
>
> Jiri, we have a high level TLV space which can be applied to all
> actions. See discussion below with Vlad. At least for this specific
> change we can get away from repeating that mistake.
>
>> Jamal, can we reach some conclusion? Do you still suggest to refactor
>> the patches to use TCA_ROOT_FLAGS and parse it in act API instead of
>> individual actions?
>>
>
> IMO this would certainly help us walk away from having
> every action replicate the same attribute with common semantics.
> refactoring ->init() to take an extra attribute may look ugly but
> is cleaner from a uapi pov. Actions that dont implement the feature
> can ignore the extra parameter(s). It doesnt have to be TCA_ROOT_FLAGS
> but certainly that high level TLV space is the right place to put it.
> WDYT?
>
> cheers,
> jamal

Well, I like having it per-action better because of reasons I explained
before (some actions don't use percpu allocator at all and some actions
that are not hw offloaded don't need it), but I think both solutions
have their benefits and drawbacks, so I'm fine with refactoring it.

Do you have any opinion regarding flag naming? Several people suggested
to be more specific, but I strongly dislike the idea of hardcoding the
name of a internal kernel data structure in UAPI constant that will
potentially outlive the data structure by a long time.
