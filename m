Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03851984B0
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfHUTlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:41:25 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:60897
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727448AbfHUTlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 15:41:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlOQmQWihPegCCn5WOhVfclUT7TuQovLuWkq4Sbrra3dzm5KiBAJ33zX9/oVoQKiZTauy67DezTyUsKtTMWTEyN7Q55UWfwn3j8YxKssxRoONjVzWrElvABPmpConcF42pSh2xvuOnOXJrAr84UQ4YajrJ4f8jPNQzHM1caTzJl9DyusGBy9uSwZEHMTWNfOdsKSkvJvaL1YowRHZLGghGPzs8WY3Kx+v3xrzum2PMY4feb3Y4V0umFcsqlBGPzzDDKt+HrcmlwIeLXUE1kqbzApFy4hK4qCaT4wWfYYm4GFIQw6byCJm/34SQzrTvL6OSov0+5JEMQ8J/QrRU5uGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRQzaJYpuya29xzizlpZ3Q3DwNhitIs0xpYTRUv5Au0=;
 b=dYX2LXbAaLuTpXFX7GPV/kqJ9AOc58n1lLMbN5bCxNsonEfbmtBACV5U8v6jYYmfr5UcF7hjVHDcwwzbmzi+w53LuYf0unBgdoPz5KnnLHc4wP7D0U/G9U7avrAFiHWKc1Keenc45XjfQeKPE2L7SABTvDBe7eK0KpT3MKhYiT1SSwaXufLXCfxchpPtyP/7nY91UU8MaMpG4mnlNjZvBDg2h9xi0dVm7wSCU7HDvqZ1zFq8JvL37pv2mG0rRXv+tEYRwQrfIK8XLKE3pdOQWhKP8O+iuU0HA6qRuutGLrt0ZZapZRHnn7awTlIsT9v1vw66SB4yQ2lk6ajj0y/FGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRQzaJYpuya29xzizlpZ3Q3DwNhitIs0xpYTRUv5Au0=;
 b=MgaSjQRPXWnDwTWayYYrwTpxdXS3bEQFb4XqG51j9yoyStFN0Wh0qE45VpKAhIY58kLDRfelsWfZbuJ0nlTAHUhW1cxOzy8CqmfAJL71nk7uNH0kgYmc6vGkg9kG858TGOxAbKr3Zy82ChJ2gPWJNII7TKA80L+08wJ0VU/GFrg=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6015.eurprd05.prod.outlook.com (20.178.127.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 19:41:20 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 19:41:19 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 33/38] act_api: Convert action_idr to XArray
Thread-Topic: [PATCH 33/38] act_api: Convert action_idr to XArray
Thread-Index: AQHVV6dCKtyxJ3XT10S6ChuxsDU5ZacGAXuA
Date:   Wed, 21 Aug 2019 19:41:19 +0000
Message-ID: <vbfpnky4884.fsf@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-34-willy@infradead.org>
In-Reply-To: <20190820223259.22348-34-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53b66fdb-c352-4bcb-6a6c-08d7266f89e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB6015;
x-ms-traffictypediagnostic: VI1PR05MB6015:
x-microsoft-antispam-prvs: <VI1PR05MB6015EA37CFEEBF855961C95AADAA0@VI1PR05MB6015.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(189003)(199004)(6512007)(7736002)(186003)(3846002)(6436002)(6116002)(81156014)(2616005)(476003)(486006)(11346002)(446003)(229853002)(86362001)(8936002)(6506007)(5660300002)(6916009)(6486002)(8676002)(81166006)(14444005)(305945005)(256004)(71200400001)(71190400001)(2906002)(14454004)(36756003)(52116002)(64756008)(66446008)(66476007)(4326008)(102836004)(66946007)(66556008)(99286004)(478600001)(76176011)(53936002)(6246003)(386003)(66066001)(316002)(26005)(25786009)(13506002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6015;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: seDJXm5GPeb6Bf0hVw/pddNSp2JwBWzdmE6pcgIU8wtrGpDXJzP/rx/TLQ3RGSU8OyjYigDF0ZQfOCA9RrZ5wbU5DXXSu0QNh4mJog9y01ywcQLmZ/is2mn3kr5llS6PPbDOz9/OWRbkGjYYHCceEEWqoGSFVBBOhSLswQUSJ2CbnVdEOVyEl/ebeU3tYssANrM/o9vL15WnzH6LhBpOaUkLd7hDo3uEsxG1U+L9l0wn19KdwkXY3fRdKzFeWgZVTP3XnpZjHi2IETszzWETxZ2a7xyHjHgpuDaklR1uEZIwfr0AyIOjbGCY2lNho6H4rZuKpF5dREr/Se+ss0O45CC/hIAcGxyg9rMRYvteJbi1ITPpXilZFnwqkUfUqWa6l0rzxE7+buuShqvuDSZnTTFe7bhkbcwko2SCELP4QTI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b66fdb-c352-4bcb-6a6c-08d7266f89e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 19:41:19.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxyoBo/J0Ru5pxNDaqc2zCiJXrniEBonaQR3EXY0fdNncqLodkQOIUTI1yqMzVcd3yWBa/VNA3WYD8or6zukdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6015
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 21 Aug 2019 at 01:32, Matthew Wilcox <willy@infradead.org> wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Replace the mutex protecting the IDR with the XArray spinlock.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/act_api.h |   6 +-
>  net/sched/act_api.c   | 127 +++++++++++++++++-------------------------
>  2 files changed, 53 insertions(+), 80 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h

[...]

> @@ -290,10 +283,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinf=
o, struct sk_buff *skb,
>  	struct nlattr *nest;
>  	int n_i =3D 0;
>  	int ret =3D -EINVAL;
> -	struct idr *idr =3D &idrinfo->action_idr;
>  	struct tc_action *p;
> -	unsigned long id =3D 1;
> -	unsigned long tmp;
> +	unsigned long index;
> =20
>  	nest =3D nla_nest_start_noflag(skb, 0);
>  	if (nest =3D=3D NULL)
> @@ -301,18 +292,18 @@ static int tcf_del_walker(struct tcf_idrinfo *idrin=
fo, struct sk_buff *skb,
>  	if (nla_put_string(skb, TCA_KIND, ops->kind))
>  		goto nla_put_failure;
> =20
> -	mutex_lock(&idrinfo->lock);
> -	idr_for_each_entry_ul(idr, p, tmp, id) {
> +	xa_lock(&idrinfo->actions);
> +	xa_for_each(&idrinfo->actions, index, p) {
>  		ret =3D tcf_idr_release_unsafe(p);

I like the simplification of reusing builtin xarray spinlock for this,
but the reason we are using mutex here is because the following call
chain: tcf_idr_release_unsafe() -> tcf_action_cleanup() -> free_tcf() ->
tcf_chain_put_by_act() -> __tcf_chain_put() -> mutex_lock(&block->lock);
