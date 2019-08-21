Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5F4982FA
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfHUSdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:33:23 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:25664
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729221AbfHUScK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 14:32:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9CTMHAjSA6Fm6I7uKwEyDHMEdCSJzMs+4kjkKwYkI00/Ydmkefc1Hc8hQFdDLwAYyxcZEaO7aKge1FqoZy/4aCQbNPgexB+am+ZfNpcneXUvdko2YAv1bAoZWLqbGtmjHrS4Abh/HVaaizRzlOU3TxXCeKLLm1VNfnnn1nhmvTFZsyYqHFevzOtaIUvsI+O3fYK4AaL6wLVPC2UXFIxMToZpSAeq5SMcn4G2ICEUVU4Zj0h740CJLaGhEGdrHoNpZnSlPqR7Bc2QMZkvfzw7mvxyBBMXMMx4wYEt/naJIoEJzKH3RX1GxndE/AeDJ7CLamD8fkl75cYf25sBzvokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUQhP8iKZnHEhN50GNtnHFOFCS6KyfBbTlgHIm+tBos=;
 b=Pgmg7Nx/jFx451UoSm8fIpurwDmi3zb3J9c8KJ9JsQ3IuLSehggI7+K1ebzIF3LE1AKwqygcAS64wcXKmADGJOPLOZEqkfQreoGdCH6wsHfZPA5aEegAlEPs6Kg+5Y5fyFtpGEh6QMY9v3IRUx9tK6/I9K+sWttXnH1RmeXiTVshXuF3Nx/0aslyd3FChmBUzFxYbbS6lJaOBAZsa2Ui0NqZjDbh9xUgSrIK5MSwcIfq+BOxqBoh98wXo7oqXEQbRlE7x+yG+LaBi9uZhkGx5er2l7x5sDjLNoZPE/xininvD6ia61Wm1vM3J0VUNSxLqtFZjyOHJrfPkthPZE1DrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUQhP8iKZnHEhN50GNtnHFOFCS6KyfBbTlgHIm+tBos=;
 b=akgOyjv9w9QK1WPo1gWUXd4MGyX5gdsSKYMXKPSYrGSj6r+Kfx2Is5D37N/YyBrBRsQT+pSX0EqPKJMY7hZJffOfRt56CMJqKZ9pCprM90fTueMqfQNFieWNHSDD/eGeUlQZwEHpl5BmYJ4AtkBP8Eu7Ny9J2xcASiSCi6QPBWY=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6144.eurprd05.prod.outlook.com (20.178.205.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 18:32:07 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 18:32:07 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 30/38] cls_flower: Use XArray list of filters in fl_walk
Thread-Topic: [PATCH 30/38] cls_flower: Use XArray list of filters in fl_walk
Thread-Index: AQHVV6dL3RIPnYsHzU+/CzMAuXpPSacF7iWA
Date:   Wed, 21 Aug 2019 18:32:07 +0000
Message-ID: <vbfsgpu4bfg.fsf@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-31-willy@infradead.org>
In-Reply-To: <20190820223259.22348-31-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::32) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b75a2482-2405-4990-318c-08d72665dede
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6144;
x-ms-traffictypediagnostic: VI1PR05MB6144:
x-microsoft-antispam-prvs: <VI1PR05MB614494E1E1CFF2E797180553ADAA0@VI1PR05MB6144.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(189003)(199004)(186003)(5660300002)(8676002)(81156014)(81166006)(36756003)(6916009)(6246003)(486006)(102836004)(99286004)(478600001)(86362001)(25786009)(66476007)(3846002)(8936002)(64756008)(66556008)(66446008)(71190400001)(6116002)(71200400001)(53936002)(386003)(6506007)(76176011)(66946007)(2906002)(316002)(6436002)(11346002)(7736002)(446003)(66066001)(26005)(305945005)(14444005)(5024004)(4326008)(6486002)(256004)(476003)(52116002)(2616005)(6512007)(229853002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6144;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8ili54LMjDe7kL2SPWlP22MYhQ8R+TO+l/zBfKcTIkQxMxGliTiKazKK4lmIAm8RLmoXDepyxvJZaFwOgRjM3aPjuAHb1YnDwxvxCf2G6xTv/iVlaixNzvVevJ0YFt6s45Yo0IgqKzgdp7cglAYLLsVTEK1VvDail+ApmOXc9jGB2548cBoudQ72oQr5caNq/1ja+KqbTFWE/b6itRQ6EwsmSCkNKXv29uG32QVd0z0HD9YoEOOlFI9VqJIbTkbK3bRvasOea2QIqBrFrIud3rdI1TIzffuK3OWp0t55hAFLapxO6tod4vss66J9MiFqCgVUZIxoFu3kfDdGNx69C/6vzlIcjEx7BGi6qGuU4qUhifV89hXVJkDb/NGGrYgBddyGMcbM1/5wLGpSMKF6TrtN8Syy7Pv+Nfb8/cQSixM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b75a2482-2405-4990-318c-08d72665dede
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 18:32:07.0709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ScKEcF6C/XUL6EOSyZ+YUyTSbTJ1VXoYdQjsYFOjhhV7VepenphdAIaak82dmgZiZSKyhpywr1FjoU4KIYtb8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 21 Aug 2019 at 01:32, Matthew Wilcox <willy@infradead.org> wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Instead of iterating over every filter attached to every mark, just
> iterate over each filter.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/sched/cls_flower.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 54026c9e9b05..2a1999d2b507 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -575,18 +575,15 @@ static void fl_destroy(struct tcf_proto *tp, bool r=
tnl_held,
>  		       struct netlink_ext_ack *extack)
>  {
>  	struct cls_fl_head *head =3D fl_head_dereference(tp);
> -	struct fl_flow_mask *mask, *next_mask;
> -	struct cls_fl_filter *f, *next;
> +	struct cls_fl_filter *f;
> +	unsigned long handle;
>  	bool last;
>
> -	list_for_each_entry_safe(mask, next_mask, &head->masks, list) {
> -		list_for_each_entry_safe(f, next, &mask->filters, list) {
> -			__fl_delete(tp, f, &last, rtnl_held, extack);
> -			if (last)
> -				break;
> -		}
> +	xa_for_each(&head->filters, handle, f) {
> +		__fl_delete(tp, f, &last, rtnl_held, extack);
> +		if (last)
> +			break;
>  	}
> -	xa_destroy(&head->filters);
>
>  	__module_get(THIS_MODULE);
>  	tcf_queue_work(&head->rwork, fl_destroy_sleepable);

What is the motivation for this change? You substitute O(n) iteration
over linked list with O(nlogn) iteration over xarray without any
apparent benefit.
