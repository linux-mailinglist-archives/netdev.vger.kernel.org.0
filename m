Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4608EE512A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633030AbfJYQ1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:27:21 -0400
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:27103
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502714AbfJYQ1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 12:27:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXjmvb2kTJJ2qu1B4JDGWeiPby7rrzbkkPymyMIr8Cpuc/cCnoG3+VI7byt3f7w46dukE4PQWIwymudfJmrc3Ma/q6lSIu3Je+F72LERuGI7aO1YWf0UV5kH3fnwoJr4vF4RD5Zf4fP1DP1iRnw/qfqWQeXtyvRHqsOVBB2Yudzak0aGBdZ5neZDxk7M0Js5IW7ndYjXKjy5P8v0csS1iBhXHOH+XELAf5f31OMoHso5A/vAIjrRG3BQAac2Hm/tMXTogO6jbiT4NSvQPWlBiO5AovFg+avhrQOaLZXfK6sADGEC5pzld5WqslJmzuBX2mbYcXV6F5FN8k1b8750SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/Ojut9R5x6GNwDR0iuLQTG/hoJCY5oEgf8FKBmCNTU=;
 b=CQkQmx5zeHR/PD9qZc0Fw05yyYfwZ8isQho80liPJjY7MPg+dfdfr/eI5Vz25402kNOvQb/tovtBc2VbtHnfNSijxZ2B4QrqZtzn83nAjbYVIdL3Qk3LjO2xnwpKK2YSsL8cAixR8NXSAltuVZ3ctSLxlfVNy4laevbEo/hVKtzTJwe8p062edN51hielbVb1mVQHupPvK5VxydVlNWwedyv/f2OKxCyO+Nip/y0bmxlmjNvxAQ88eCUb5p5dzdTMoOBDabKhX4OnrMpJxHxcTyTIlx+/ltd6Vz4VpQp8cyZMPIO9soGbo8CZPrLgiCLGgQh8B3wM0HlYpLfIe0OOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/Ojut9R5x6GNwDR0iuLQTG/hoJCY5oEgf8FKBmCNTU=;
 b=Dd17HMjCVB8UeJJhx+TZuI9dIFBZriabgvfdpdqyPrAQjSnv+SQ7FzmcrkOgFdftGutx7Qw8oSHdicdbFd3DdnUMJ+dSI1OOHJzpK4PBs8zZNPhqC4FGcHHbIRK6yosswprO3e7/J36mS/63Ce1FWUWJAJRYo3tGh2spuAtdX78=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5549.eurprd05.prod.outlook.com (20.177.203.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 25 Oct 2019 16:27:16 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 16:27:16 +0000
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
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6doLtcAgAAEK4CAABWjgIABIOyAgACCuACAAA2RAIABdMWAgAAIhYCAAAMgAIAAAvYAgAAG7gCAAAZJAIAABeSA
Date:   Fri, 25 Oct 2019 16:27:16 +0000
Message-ID: <vbfo8y4u6xq.fsf@mellanox.com>
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
x-clientproxiedby: LO2P265CA0300.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::24) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b2f0927-d58e-4c86-2574-08d75968331a
x-ms-traffictypediagnostic: VI1PR05MB5549:|VI1PR05MB5549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB554988C792A0ABA7C8C72649AD650@VI1PR05MB5549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(486006)(66066001)(26005)(229853002)(6246003)(186003)(8676002)(8936002)(54906003)(316002)(6486002)(305945005)(6506007)(102836004)(6916009)(6512007)(4001150100001)(7736002)(3846002)(386003)(53546011)(4326008)(6116002)(5660300002)(76176011)(476003)(2616005)(52116002)(66446008)(446003)(14454004)(256004)(71200400001)(81166006)(86362001)(71190400001)(99286004)(66476007)(66946007)(36756003)(6436002)(66556008)(2906002)(81156014)(11346002)(14444005)(25786009)(64756008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5549;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8F9TtMCgBTlJxvHQdW0zJJXSOKYTeoynjNdZgfrXj36Ld/NXvHYZnuM0rrNb0t/PbnExdyXA/FumKVPDhEfmO80Jm/uFCCjVmsNeLUx4efDR/a0bTaSWUmTUqhdojvI+PIhhs/kDHtSpp8REwVbI+KggDgE6XsWurNo1rr47L/0zY4a4QZkKImcQB+rK1MB54I+PwRQ3OfGK7288EdZm270rg3ec5e9lhZLlWkAWyUfw9uHr46Sf7wU+f0HfCKw6KbonKOMjj9j+CHMX7paD0Y3LLeANcknlrG/skew8VMm2nl7lsEhuuOY7TWigSpawnqXgpP2MYakXL06flhVr0fSKuXmpqZaBVFkb2NVJsenvCNO5TuSUaE01XR/YN1xEISWGGdV+3FdWVl3y2+wp760+iGCcSTxyfphz7nPp17XHo+45g9xj42pmnFkjrVdi
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2f0927-d58e-4c86-2574-08d75968331a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 16:27:16.6955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3ZOrPZDsXm2fqBEOuy+zJdRSMRftH0jV4Pbe4LhEkczi/O4LYoO2TDIc02OpII+Wajg26v6WNKZQWNbtHhe6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5549
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
>
> But: for direct call to tcf_action_init() we would have
> to extract the flag from the TLV.
> The TLV already has TCA_ROOT_FLAGS in it.

After re-reading the code I think what you suggesting is that I can
somehow parse TCA_ROOT_FLAGS in following functions:

int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *n=
la,
		    struct nlattr *est, char *name, int ovr, int bind,
		    struct tc_action *actions[], size_t *attr_size,
		    bool rtnl_held, struct netlink_ext_ack *extack)
{
	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
	struct tc_action *act;
	size_t sz =3D 0;
	int err;
	int i;

->	err =3D nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
					  extack);
	if (err < 0)
		return err;

	for (i =3D 1; i <=3D TCA_ACT_MAX_PRIO && tb[i]; i++) {
		act =3D tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
					rtnl_held, extack);
		if (IS_ERR(act)) {
			err =3D PTR_ERR(act);
			goto err;
		}
		act->order =3D i;
		sz +=3D tcf_action_fill_size(act);
		/* Start from index 0 */
		actions[i - 1] =3D act;
	}

	*attr_size =3D tcf_action_full_attrs_size(sz);
	return i - 1;

err:
	tcf_action_destroy(actions, bind);
	return err;
}

Again, I'm not too familiar with netlink, but looking at that I assume
that the code parses up to TCA_ACT_MAX_PRIO nested TCA_ACT attributes
and passes them one-by-one to tcf_action_init_1(). Are you suggesting
that it also somehow includes TCA_ROOT?

Regards,
Vlad
