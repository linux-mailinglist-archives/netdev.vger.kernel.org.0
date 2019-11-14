Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFBDFC8D7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKNOY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:24:26 -0500
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:34428
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726516AbfKNOYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:24:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBxzPlPOpfbO4oNfl2kOELjWalZx6Q2ujcWXD8PmKKPqpc0Prdwhm4hG7zXe0KocOSJ1JvU0gK3bYEhbSTI2qngv5Fy66C/gUZBCXjc6HYxbO2ctqhxWswU0mB0IndkKjhVcbN6CRJjuqdkQrD3Yuuxwq4jeAJagLxGZTilFLxK/kwVdf/wlA4ZiqbmYMiAEuQSUFQnKgAjpKcc/VqDKs1FblmQtcItv0a5D9tFdu5RP8nvNVz+fiaQ78arj1g2OytlNkMqfEzCCGP6Iz6qvzku8PXgNaKjiQVdi6X0hyROnKq4AHumKHfPMQweJT0F1Y5u6YThk37MZfwS6nnylEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mvj1tshMyPRe2Mj/4FPUKVpXM2acXIZhFLChFSagnpM=;
 b=dUiI5Xamd1fJ2Aq+gn3zU7kJDSL1JcghB/HooZNEiBtjFsyzZf3FUAwCCeN6uonUJ5MYFkqpzj0FTxHc086ssiZsVN4ozPy/kzECSAyLvlZgekk1VmCkYWECDK8Ea/uxDnCf5g6iQ0YD4bcX0fEg/atEPmwFhMaihKeBKmff5gLfpU1MpqShcLIGWB/eiiwwPBrJjTXa1JDhKwWdbpO7XCWvzGXmEPRQMnrAKQKzwxqI2/SIfB9BKxgbvnFo9TJ1B25bpAX54KS00o+iCPFJqZEq0qP2FH5x0tugfZnfhuUrx9VqmSLnPK8JGpo1rzlqit/a5BlHU+X9FEnkuntJKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mvj1tshMyPRe2Mj/4FPUKVpXM2acXIZhFLChFSagnpM=;
 b=cbJtVbv5ezFnkxVtdRvVHYNqNu9cJsp19yopxFTvR52sIGkygX9joVdyi4lwBgtCd2Jc4PUfp7mQSvjj/OpdaJd70+rWagvucK23tZNFchPt4iGnRIVF2CBbNi8nd8iLcdfdA9n4iezgGCgUTatHO3J/NW3Ig/ql2TgbwluSUzI=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3473.eurprd05.prod.outlook.com (10.170.126.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 14:24:21 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2451.023; Thu, 14 Nov 2019
 14:24:21 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>, Aaron Conole <aconole@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
Thread-Topic: [PATCH net 2/2] act_ct: support asymmetric conntrack
Thread-Index: AQHVmvb7TMewQ/3jDU63p12bNulUv6eKuHSA
Date:   Thu, 14 Nov 2019 14:24:21 +0000
Message-ID: <80993518-9481-02ca-7705-7417717365c1@mellanox.com>
References: <20191108210714.12426-1-aconole@redhat.com>
 <20191108210714.12426-2-aconole@redhat.com>
 <6917ebfa-6361-5294-d91b-b3c6dd1e8cf5@mellanox.com>
In-Reply-To: <6917ebfa-6361-5294-d91b-b3c6dd1e8cf5@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0116.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::21) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d549cbd-75bc-4ad0-f640-08d7690e561c
x-ms-traffictypediagnostic: AM4PR05MB3473:|AM4PR05MB3473:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB34737E54AE9E08257DAEE33ECF710@AM4PR05MB3473.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(396003)(39850400004)(376002)(189003)(199004)(386003)(71200400001)(446003)(31696002)(86362001)(7736002)(52116002)(76176011)(6512007)(229853002)(6486002)(14444005)(6246003)(71190400001)(11346002)(6436002)(305945005)(2501003)(478600001)(25786009)(476003)(486006)(2616005)(66066001)(4326008)(256004)(3846002)(2906002)(6116002)(110136005)(64756008)(66446008)(66946007)(66476007)(66556008)(31686004)(5660300002)(102836004)(99286004)(186003)(14454004)(53546011)(6506007)(26005)(316002)(54906003)(8936002)(36756003)(8676002)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3473;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A9sCDFo8O5n2OqCLnugQoL6RVNjQ6NGCVZMwFhp4u+7lR+FeA2twA7sm0SwIkrvhMfroWq/HWXaDdwp1gDfSIHzs0/PA7joVWAfT/9wIcYU7i2nEyX84mkdvmYeONlTmEqzWxS3HDEDycdDSe75hhmEuXR58TFxEpnZsW8lkBIiKGXXEQjg3OgvKGWJLgVWbwvssMRTlTkYPgb8JEUFqmS7W7UB0LRRC44wtrEb7tl13wuOiZ+SgIb4sT3bkxJJ2fW1zISaHUWHz5SgSP1Klc9P61+Pb4BeF6f3W/ICpp4uqSwPKBQYOk+mhxbuLX0gZCs8B0adQYvt8p3XlnQCI9L92Pd2TwV9T6Hz9T/3nV2jx1HGoazOTBX04Ztomgb+jd/iExL0KiaUj1Nlg/125+vk0ZrjlWxy+O4PWIrQq12ylLQFjmHACZVDJZH+Hr2Vy
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <A0A8BDAD30E8EC43965DB091E59A9266@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d549cbd-75bc-4ad0-f640-08d7690e561c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 14:24:21.3978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4S/pY2gSCjK2DaWFStCDgWDH/hV4dCMkfy1oQo9CGJKIvow2Zpzvp6WgSkA6ECbObTnxcf1ZzwTFf8nbyMWNmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3473
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/2019 4:22 PM, Roi Dayan wrote:
>
> On 2019-11-08 11:07 PM, Aaron Conole wrote:
>> The act_ct TC module shares a common conntrack and NAT infrastructure
>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>> this because it runs through the NAT table twice - once on ingress and
>> again after egress.  The act_ct action doesn't have such capability.
>>
>> Like netfilter hook infrastructure, we should run through NAT twice to
>> keep the symmetry.
>>
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>>
>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> ---
>>   net/sched/act_ct.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index fcc46025e790..f3232a00970f 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>   			  bool commit)
>>   {
>>   #if IS_ENABLED(CONFIG_NF_NAT)
>> +	int err;
>>   	enum nf_nat_manip_type maniptype;
>>  =20
>>   	if (!(ct_action & TCA_CT_ACT_NAT))
>> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>   		return NF_ACCEPT;
>>   	}
>>  =20
>> -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +	err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +	if (err =3D=3D NF_ACCEPT &&
>> +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
>> +		if (maniptype =3D=3D NF_NAT_MANIP_SRC)
>> +			maniptype =3D NF_NAT_MANIP_DST;
>> +		else
>> +			maniptype =3D NF_NAT_MANIP_SRC;
>> +
>> +		err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +	}
>> +	return err;
>>   #else
>>   	return NF_ACCEPT;
>>   #endif
>>
> +paul

Hi Aaron,

I think I understand the issue and this looks good,

Can you describe the scenario to reproduce this?


Thanks,

Paul.



