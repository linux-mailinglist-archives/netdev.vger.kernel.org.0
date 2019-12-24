Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8492512A0DF
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 12:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfLXLsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 06:48:16 -0500
Received: from mail-eopbgr150055.outbound.protection.outlook.com ([40.107.15.55]:1893
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbfLXLsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 06:48:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0RU7Xp9v1GjNW9att+ZEDVMzXZBeucV3rOOKezrobJdrKafV2+LYSQaq71754SOf8N4/rwwOVnAUcI/5eYXf5PHGEk7qGRKpGvv5pIgFVx4GDh5+AJcgJmzQh977lzNAq6jkGn1sXmwsXRm5jj9ljrvN4V4C8VnEgU1edu3K0U0SOzR7jBVSxLl+CMmOm20esUDPjh9QOkyx0EApre1UZ1Z1PvGUkWRybdv7InySvL2phXXDPNv8/pFhoDp1kfafAbv3W5rvn1BzhQkal6pX5ygDaIrkmfzoHxyJguxd/L/FgL6zTZfTAsoeB9R2GNvsxZtFJhyLyalR9oEUH7Grg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LLCCol2ZKtE2gaElfQEs0KbGnGO1e4xYtwSastibpE=;
 b=er7yTVMLKx6seCe05qGlI1gzihTXVgiDK6qZqjIBs8Lg0nix92TcSKudsozmtep7rlZ5XGelTAU1Ik2hYiXAQOQJm0njIYJJbxurERv6UoS9tmN5PQRGyS3/QBzijyjVuwwzHbuzWX1tPtVBxPFhGwYMyuRMQ+YpcGjGDNeLZJknS280iRs/V72yiOvjBgGvhZt67gAUum71+xyZX7vZrVn4CDkDa0851uQUB96JwL0sl/hmD06YKRhwP8FpkW3mOHy3+QsXiWCkUEUDX1kAXtvsNhn7x8zo9GAdqx9X8N10GpQRaLmB6AjzUd4SyzpUHYPj3IGi2cgtb4tmWS1t+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LLCCol2ZKtE2gaElfQEs0KbGnGO1e4xYtwSastibpE=;
 b=F5S86IIsTReZW+EVGxNQ2R3YUWNHn67T7odcMw44szMqy+0ebZ5h2VygaStY8xVI8RJTdVT8eeV7iAuULSIk+ajS+t+9tVrpIxmrR8jBUMcJzYhbnQYFHBuB6ue9S86lYuXq1ODqJuihIEnHvT6s0nFL5+CINixw/k8uXFkQfNs=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3520.eurprd05.prod.outlook.com (10.170.237.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Tue, 24 Dec 2019 11:48:07 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10%5]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 11:48:07 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net 2/2] net/sched: add delete_empty() to filters and use
 it in cls_flower
Thread-Topic: [PATCH net 2/2] net/sched: add delete_empty() to filters and use
 it in cls_flower
Thread-Index: AQHVujzvXWoQGgrAT0+/xfnjdLyyZKfJK4WA
Date:   Tue, 24 Dec 2019 11:48:07 +0000
Message-ID: <vbf7e2m2bno.fsf@mellanox.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
 <a59aea617b35657ea22faaafb54a18a4645b3b36.1577179314.git.dcaratti@redhat.com>
In-Reply-To: <a59aea617b35657ea22faaafb54a18a4645b3b36.1577179314.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0182.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::26) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 65ea6b49-68bf-4c7c-7e62-08d788672486
x-ms-traffictypediagnostic: VI1PR05MB3520:|VI1PR05MB3520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3520AD56ADBA11D613DCE10BAD290@VI1PR05MB3520.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(52116002)(71200400001)(5660300002)(8676002)(81156014)(6512007)(36756003)(6916009)(498600001)(6506007)(81166006)(8936002)(26005)(2616005)(66946007)(86362001)(6486002)(66446008)(2906002)(54906003)(66476007)(66556008)(64756008)(186003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3520;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sdpyPuDclRkk4ERVdDjt++DpnkdPknk72WkZ2Y9D7cxH3X1SsoIHjkbcde9/isU47Cbg7ztiuA+kxHWZl0MZVqCc9wBLykjcbkQG2wezbhVh4Ea+hYvRgyiny4j727xdNwsZunVxbcXCOIU7nNDmDf5ZwxqpoV/tAoh2lIUzW6RWxlRflDdrQe/kL1ncZo7oaHqE4jNrSBS+nYdTufe3uTAkSXvLmI10DFLNULGj6w/yl+FuaaPeRdkv0jAe9FEsOIbes3yNRDOkfgIzmkFtQsZfBO5Em4HUlSCl+xJXfhuyBx9TsIzb67A4HeWEKBoi0XItw+ur4BgoH6QCuZnFs2LMjm5G31TSA65/r42VZ6tLJbvIZZlbr+8pvkVwbhhTtv8dbJFggvj5O92eMLH92/DVY9HgyzoTN9ljgi1l4gWa5F9x3EYMPPeqUVVjqAeY
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ea6b49-68bf-4c7c-7e62-08d788672486
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2019 11:48:07.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zlOlNRdOvxAENs0FO6JXEFFFn3zSaENLsZSATDbp/iIlrhXNpf+2dKV8epgUxLLVuKSrD9MkJ/RKQygnjBZqIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3520
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 24 Dec 2019 at 11:30, Davide Caratti <dcaratti@redhat.com> wrote:
> on tc filters that don't support lockless insertion/removal, there is no
> need to guard against concurrent insertion when a removal is in progress.
> Therefore, we can avoid taking the filter lock and doing a full walk()
> when deleting: it's sufficient to decrease the refcount.
> This fixes situations where walk() was wrongly detecting a non-empty
> filter on deletion, like it happened with cls_u32 in the error path of
> change(), thus leading to failures in the following tdc selftests:
>
>  6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
>  6658: (filter, u32) Add/Replace u32 with custom hash table and invalid h=
andle
>  74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id
>
> On cls_flower, and on (future) lockless filters, this check is necessary:
> move all the check_empty() logic in a callback so that each filter
> can have its own implementation.
>
> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp i=
s empty")
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Suggested-by: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/sch_generic.h |  2 ++
>  net/sched/cls_api.c       | 29 ++++-------------------------
>  net/sched/cls_flower.c    | 23 +++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 25 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 144f264ea394..5e294da0967e 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -308,6 +308,8 @@ struct tcf_proto_ops {
>  	int			(*delete)(struct tcf_proto *tp, void *arg,
>  					  bool *last, bool rtnl_held,
>  					  struct netlink_ext_ack *);
> +	bool			(*delete_empty)(struct tcf_proto *tp,
> +						bool rtnl_held);

Hi Davide,

Thanks again for fixing this!

Could you add a comment to TCF_PROTO_OPS_DOIT_UNLOCKED flag with
something like "Classifiers implementing this flag are expected to
define tcf_proto_ops->delete_empty(), otherwise hard to debug race
conditions can occur during classifier instance deletion with concurrent
filter insertion."? My original intention was not to require unlocked
classifiers to implement any new APIs but since it is no longer the case
it is better if we document it.

>  	void			(*walk)(struct tcf_proto *tp,
>  					struct tcf_walker *arg, bool rtnl_held);
>  	int			(*reoffload)(struct tcf_proto *tp, bool add,
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 6a0eacafdb19..7900db8d4c06 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -308,33 +308,12 @@ static void tcf_proto_put(struct tcf_proto *tp, boo=
l rtnl_held,
>  		tcf_proto_destroy(tp, rtnl_held, true, extack);
>  }
>
> -static int walker_check_empty(struct tcf_proto *tp, void *fh,
> -			      struct tcf_walker *arg)
> -{
> -	if (fh) {
> -		arg->nonempty =3D true;
> -		return -1;
> -	}
> -	return 0;
> -}
> -
> -static bool tcf_proto_is_empty(struct tcf_proto *tp, bool rtnl_held)
> -{
> -	struct tcf_walker walker =3D { .fn =3D walker_check_empty, };
> -
> -	if (tp->ops->walk) {
> -		tp->ops->walk(tp, &walker, rtnl_held);
> -		return !walker.nonempty;
> -	}
> -	return true;
> -}
> -
>  static bool tcf_proto_check_delete(struct tcf_proto *tp, bool rtnl_held)
>  {
> -	spin_lock(&tp->lock);
> -	if (tcf_proto_is_empty(tp, rtnl_held))
> -		tp->deleting =3D true;
> -	spin_unlock(&tp->lock);
> +	if (tp->ops->delete_empty)
> +		return tp->ops->delete_empty(tp, rtnl_held);
> +
> +	tp->deleting =3D true;
>  	return tp->deleting;
>  }
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 0d125de54285..e0316d18529e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2773,6 +2773,28 @@ static void fl_bind_class(void *fh, u32 classid, u=
nsigned long cl)
>  		f->res.class =3D cl;
>  }
>
> +static int walker_check_empty(struct tcf_proto *tp, void *fh,
> +			      struct tcf_walker *arg)
> +{
> +	if (fh) {
> +		arg->nonempty =3D true;
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static bool fl_delete_empty(struct tcf_proto *tp, bool rtnl_held)
> +{
> +	struct tcf_walker walker =3D { .fn =3D walker_check_empty, };
> +
> +	spin_lock(&tp->lock);
> +	fl_walk(tp, &walker, rtnl_held);
> +	tp->deleting =3D !walker.nonempty;

I guess we can reduce this code to just:

spin_lock(&tp->lock);
tp->deleting =3D idr_is_empty(&head->handle_idr);
spin_unlock(&tp->lock);

> +	spin_unlock(&tp->lock);
> +
> +	return tp->deleting;
> +}
> +
>  static struct tcf_proto_ops cls_fl_ops __read_mostly =3D {
>  	.kind		=3D "flower",
>  	.classify	=3D fl_classify,
> @@ -2782,6 +2804,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostl=
y =3D {
>  	.put		=3D fl_put,
>  	.change		=3D fl_change,
>  	.delete		=3D fl_delete,
> +	.delete_empty	=3D fl_delete_empty,
>  	.walk		=3D fl_walk,
>  	.reoffload	=3D fl_reoffload,
>  	.hw_add		=3D fl_hw_add,
