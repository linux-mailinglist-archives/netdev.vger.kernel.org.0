Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D6BFC8CF
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKNOWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:22:48 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:63108
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbfKNOWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 09:22:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvH58/je8iUkSIp3cyHAmzbog9c6juh4k/sBtZ0EVWHIaGff7bQeQh0/XabpzE4q4bEg7XWQkbvXJNIDCWcga8shLBF7FH9Qnda4XGqVYFsetrGrSj4rjJYQeNu41/BmvEdBLgXIT1tBrtu+aCY6wuOLpaOucDEYWy7ft6utFG4Dc4XfzCa4lKWTMmLS32m4z2qwqmlqVYkfRxWcHx7LpYnOSibuVTS8d7oFSO/rxkMnxcfXGFaAR1Rbsn7zIDQqglu4QpVMx+6s14CpHhlNtrESuCWW38qhhWZrNZ7iYWwPEzzcbI3vsm7AUdepo84H9PtaI1DPDV54w8dlv04gCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2PVr5mPwg9xTS+CYuS+/rqtZAyzFzUxEicKgIZWZG4=;
 b=BNPTgK0vxTtVNGonalsUyyAZ26ZHGeATHE2cyJa2OljZCpdOHUa8OYaddSNL8x0cuOuGJ6MMKJYCZLS60MAFnOWmYZjlHBQeJVs+4SrBLBW2JqFEe7gRbJ716D30EEx2F5IXClpayBh4iyEnabTjuJ+E2Q7ZbZAT38r/KMNosP2l22PvwgjnEaGPHF+NkuPzCuU0h6faN/5kkv/KwHd2hTTC8XDANmQmCW2t2l1X64mlWkP7Fba/ExgCS/8wi7YnQSuQTj78SFBq3hDvmpECLuy8jgLU0XjwnKbOcRSGv8V360DdoDv4KfGGTPRVlow8cDMfHZjNmH9+YpowRm5Xwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2PVr5mPwg9xTS+CYuS+/rqtZAyzFzUxEicKgIZWZG4=;
 b=AlXsRw50yRwt5qIh0Bnv/fzAqGjLoAPDc1sCuuSs29Er/626dvugXneYPJqpCoPOwZAlEwRndTm5g/NK/Lg2t9/EISNDoue8hu1zT6XE0ey7sufxjkM55CKjmChCNclOy7Q2xOrm8M7/PM17dfIbKaSNPcKfbE6I9ClU9s7wNFM=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB4117.eurprd05.prod.outlook.com (52.135.160.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Thu, 14 Nov 2019 14:22:44 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 14:22:44 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Aaron Conole <aconole@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
Thread-Topic: [PATCH net 2/2] act_ct: support asymmetric conntrack
Thread-Index: AQHVlniNxzp9LPfrD0GENV4CQylisqeKwQAA
Date:   Thu, 14 Nov 2019 14:22:44 +0000
Message-ID: <6917ebfa-6361-5294-d91b-b3c6dd1e8cf5@mellanox.com>
References: <20191108210714.12426-1-aconole@redhat.com>
 <20191108210714.12426-2-aconole@redhat.com>
In-Reply-To: <20191108210714.12426-2-aconole@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To AM6PR05MB4198.eurprd05.prod.outlook.com (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d4ff9c7-b459-42fc-82a1-08d7690e1d0b
x-ms-traffictypediagnostic: AM6PR05MB4117:|AM6PR05MB4117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB4117CA8D134E2463F9BCC622B5710@AM6PR05MB4117.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:214;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(189003)(199004)(6116002)(99286004)(66476007)(2906002)(110136005)(4326008)(31686004)(26005)(478600001)(54906003)(66556008)(66446008)(65956001)(486006)(386003)(8676002)(476003)(2616005)(8936002)(53546011)(81166006)(5660300002)(64756008)(36756003)(6506007)(107886003)(25786009)(11346002)(6246003)(229853002)(446003)(58126008)(71200400001)(66066001)(65806001)(71190400001)(256004)(14444005)(316002)(31696002)(6512007)(81156014)(66946007)(186003)(7736002)(305945005)(6436002)(86362001)(52116002)(76176011)(2501003)(14454004)(102836004)(3846002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4117;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OVUNG4RwfVsc9hfzDmylZHwMgX5HQfmefRmEogST6dQth5fZ4yixgFsWv0KDwnlt3uIGHeCfop3zZTS3XtJumU0OEBsZlpxI2V31+cNcCb4NDzZ2BgWPLbDcb1/dg2tE5LN6SwTwPrLYs3kcbI0Pc1dfrglY7BZJc4rf0WxZpKqkw97BIBjopNZG2xi1S5ogBdn5ZnyiVzKkDci2XcbggQW1egHRSQPlPMoZGIYM+VOc0OGkO7VAx65iqEwdTp5VDgjbXLFhpNeWxj6WwKsf3WVTZKkisqyROsvNN1uS8rOQjuEWKw1eUmqivo6Uky0KxjX1raAZApm7efdULeLn9SoBMx8hkvybww1hWxiP1pojP3l8SoTlfr8AFu8jzzGjPIbSf15cjsvza6NKxPeBaI4PoFJZE2j9S0LgdDo18LxOICMPdKJyF0FRiNdIGwRC
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <19C208C90B108349A20FC184A6A1E8A9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4ff9c7-b459-42fc-82a1-08d7690e1d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 14:22:44.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/6xh+3Y2y9WT5O3pQaqZQi9ObJRWATcu1P+JrPXhSIixcls0lYtqrUC/a1CmZhAHQ7FWZ9glKIUrAl5VaSQJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019-11-08 11:07 PM, Aaron Conole wrote:
> The act_ct TC module shares a common conntrack and NAT infrastructure
> exposed via netfilter.  It's possible that a packet needs both SNAT and
> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> this because it runs through the NAT table twice - once on ingress and
> again after egress.  The act_ct action doesn't have such capability.
>=20
> Like netfilter hook infrastructure, we should run through NAT twice to
> keep the symmetry.
>=20
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>=20
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
>  net/sched/act_ct.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index fcc46025e790..f3232a00970f 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  			  bool commit)
>  {
>  #if IS_ENABLED(CONFIG_NF_NAT)
> +	int err;
>  	enum nf_nat_manip_type maniptype;
> =20
>  	if (!(ct_action & TCA_CT_ACT_NAT))
> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  		return NF_ACCEPT;
>  	}
> =20
> -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	if (err =3D=3D NF_ACCEPT &&
> +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> +		if (maniptype =3D=3D NF_NAT_MANIP_SRC)
> +			maniptype =3D NF_NAT_MANIP_DST;
> +		else
> +			maniptype =3D NF_NAT_MANIP_SRC;
> +
> +		err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	}
> +	return err;
>  #else
>  	return NF_ACCEPT;
>  #endif
>=20

+paul
