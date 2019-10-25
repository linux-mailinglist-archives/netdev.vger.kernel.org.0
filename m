Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312F1E4F01
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409292AbfJYO0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:26:41 -0400
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:17477
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404022AbfJYO0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 10:26:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDELyLMP/xaIQwr6vdz4wYDO5T6ZpFWPGjKXW1U3fHLYM1peswddEgCuH6hm8KF0mffPG8Tx0TSILl2NL8NhXYyyM8IhGHdk7/8jyNZ805/ui5XLLIEqmy5MO/MuWPOvOCj5DxPaSqdcH5L3oBV7rif48MIZc/qcUuN/qUTnO8+cK3ciDs4+YZOBjSuh9zmBjPbLimez45S/LpQBmamUHDN+odcIXIUM/VkDNhScMdANpqDFz0LTB9eGkgduTPUTf89zpdA6GvswIRlo2Ye+06Lks/TpEt/+76sMTAOj5CsS//mMzFE6aJHngRHJWU8CI26nhef7ww2I1iJDhYfcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvwOK5pyXXplXs2bnDpnE69ZK67oEZU9oZ1LBDkcSIY=;
 b=eK1bSvb3R1UoezlBExcBEFWtO0Pmd7Jt6AjciOeMf0asyv8BuJOeGK2wCmNCpi8+if5QcDIMIF3ASD/kfWOeZvfjb1Y4uITbmM1W2c6GQ/T/AFCYOBUHzUlCf9MiW9bVeVkROycwjIyia/7p31CdyD/BHlUA3MTWOF7+TskRsYWs8BAgCicAAWab8+zM4z8hrA6Pmi6XLt2cNHgQ3OdjISXEJMaNpMIIJodcZHToUQseH/VAseBy6kUSFe3Uz7NKn5eJPTaypBWIsvaSMPQH5Qgb4+265vCCSFOy0J04OOuZJ66YI3hBuAtlsCOr27+MVt6zgZp0IvY8kFDyQGuDOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvwOK5pyXXplXs2bnDpnE69ZK67oEZU9oZ1LBDkcSIY=;
 b=P4jWk9xMYEK4RwQbqZYoHQ4hr45c6rrsf4T79J2lcBbNdQMZ7KNbcb9ieINbUvybupx4l4uwNNVKqZIi6q8/gtg3/zvLtIR9ldyy9YRlpRzoB4YOv3r9S0bED84s8k8IUf0D15YeXE6A05K/jvKD7jSr/0hucIQg9bofWNWn8SE=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6527.eurprd05.prod.outlook.com (20.179.26.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 25 Oct 2019 14:26:37 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 14:26:37 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWA
Date:   Fri, 25 Oct 2019 14:26:37 +0000
Message-ID: <vbftv7wuciu.fsf@mellanox.com>
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
x-clientproxiedby: LO2P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::29) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 454e8670-8a34-4f94-1907-08d7595757ef
x-ms-traffictypediagnostic: VI1PR05MB6527:|VI1PR05MB6527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6527FE0562EE0403A40A5E63AD650@VI1PR05MB6527.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(189003)(199004)(8676002)(478600001)(6916009)(53546011)(71200400001)(6506007)(386003)(2906002)(26005)(6512007)(8936002)(229853002)(81156014)(71190400001)(36756003)(6436002)(4326008)(6246003)(256004)(81166006)(6486002)(66556008)(99286004)(66446008)(4001150100001)(102836004)(25786009)(76176011)(66476007)(86362001)(64756008)(66946007)(3846002)(5660300002)(6116002)(7736002)(476003)(11346002)(446003)(2616005)(54906003)(186003)(14454004)(14444005)(66066001)(486006)(305945005)(52116002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6527;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EjjxxeUPGMF9QeXe/MQ+bfpXqTzX9kl+FrDyfempcEMkhnsF3SIl5j+qLLj2OjTF3Tf943uJtL/UxI7yjWTpb5paq4a8yWCc+kGj19hTBH0mKSVDnqOo24+Kiiz0wv7YUijOjc53vLGojiosQtRoIcMRMhek3ys1FmtkN5HSzBGCUTfvUtY3Xqv2TlB3erRo+/kLnTWKzN0r5xRDIouKUK6Srv3hqrOR2vH7z6GFBrxRnA3gjQ3cvT8b+uc5xjMm6EDop3Cev3S1YPrWlmWLNEHaKOVHZi84cCw/Z7r6HOVQu+253wnIg69fos2EZmj+uMWf+WZ0Vy0p8r8xoi2yCP/qwRJU+9cnNEqaF9jfv/9P7AdGn2ecYvHN/uNKUcQ57Fcz9xndBZe/lQBRWKOaHaqp30eBH9w9uhHvN4u64ANbL5OgK7Pc8LYJEEuY0Fvl
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454e8670-8a34-4f94-1907-08d7595757ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 14:26:37.1267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zpfy9mOeQ9XOAnyN9IP5q+UdRKIChgY2ns7KopCOPaOqC23dSISMbra71OM66+RvohBlElXcAKfXd1E77Ig3TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6527
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

Hi Jamal,

I've been trying to re-design this change to use high level TLV, but I
don't understand how to make it backward compatible. If I just put new
attribute before nested action attributes, it will fail to parse when
older client send netlink packet without it and I don't see
straightforward way to distinguish between the new attribute and
following nested action attribute (which might accidentally have same
length and fall into allowed attribute range). I don't have much
experience working with netlink, so I might be missing something obvious
here. However, extending existing action attributes (which are already
conveniently parsed in tcf_action_init_1() function) with new optional
'flags' value seems like straightforward and backward compatible
solution.

Rough outline in code:

2 files changed, 6 insertions(+), 2 deletions(-)
include/uapi/linux/pkt_cls.h | 1 +
net/sched/act_api.c          | 7 +++++--

modified   include/uapi/linux/pkt_cls.h
@@ -16,6 +16,7 @@ enum {
 	TCA_ACT_STATS,
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
+	TCA_ACT_FLAGS,
 	__TCA_ACT_MAX
 };
=20
modified   net/sched/act_api.c
@@ -852,6 +852,7 @@ struct tc_action *tcf_action_init_1(struct net *net, st=
ruct tcf_proto *tp,
 	char act_name[IFNAMSIZ];
 	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct nlattr *kind;
+	u32 flags =3D 0;
 	int err;
=20
 	if (name =3D=3D NULL) {
@@ -877,6 +878,8 @@ struct tc_action *tcf_action_init_1(struct net *net, st=
ruct tcf_proto *tp,
 				goto err_out;
 			}
 		}
+		if (tb[TCA_ACT_FLAGS])
+			flags =3D nla_get_bitfield32(tb[TCA_ACT_FLAGS]).value;
 	} else {
 		if (strlcpy(act_name, name, IFNAMSIZ) >=3D IFNAMSIZ) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
@@ -915,10 +918,10 @@ struct tc_action *tcf_action_init_1(struct net *net, =
struct tcf_proto *tp,
 	/* backward compatibility for policer */
 	if (name =3D=3D NULL)
 		err =3D a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, ovr, bind,
-				rtnl_held, tp, extack);
+				rtnl_held, tp, flags, extack);
 	else
 		err =3D a_o->init(net, nla, est, &a, ovr, bind, rtnl_held,
-				tp, extack);
+				tp, flags, extack);
 	if (err < 0)
 		goto err_mod;


WDYT?

Regards,
Vlad
