Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A3712C685
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 18:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfL2Rrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 12:47:51 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:25345
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731019AbfL2Rru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjoG14hazcMijh3zAYvd4bvzuYeKOSUnSJbJr9B1rUwyPfZQd2s9y8b7TZf3a0J0Q1bgK77vBQE0hyxuvqKR2QhhoJVDZJ4FesrObL2iLOZirGcI200aur1N1o9vjNHj4O6K/21tRJeUW8tlSI9uKeRvqt53ccjpFFe1yoKOQ+QkoGoTJbyF4gEjaC55KGSgrIjWqGudSOBblnNzm/XIpDFFhCZpUUGjB/x2Szs8lHdVbTdUZvQ2i3V7NeBsYADRNVxNApFP03pAv39L20Rx5mdXGQOgfwzTzJ/vJsc1oSwbDVdwit6RgCInzx5rkzt7Dg2B7HVPX0VUwHTrEBz/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcubT8f57Ax5pKDL5KpKA6clTtYXY7xU75QOucAgtds=;
 b=Pi0RNNqOvEkqfoCle50ukqHWGWEFXfLn+C8o/EOtxSonj9jxr9TNXXA41iSHsJwZoR1rqxHiwxHJMlddDl6pvD7BAtxVlzklZMk+QLxHHxZDA3N76HVQ2IG6wz+yvHUcxjLWGyQBdhwBF/li1FQnzY2VgNXObOc4cIeSveozFnUDaB/xdk7fbM1vAy+gWeTrQ1Dd7yrJhC+ZSbGNX1FyFx7dwPKeY0e4Ulsf1Ka4aqvRdCMKa2rkvh4KXua8I5zbUlUelAtUwu2cktnTqnSsl+3MhPGSBlSPhhf18egbq+5nvUb1pSQizaeWnKNV7WKuyBotNY3mXsXRX0NNX9torQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcubT8f57Ax5pKDL5KpKA6clTtYXY7xU75QOucAgtds=;
 b=FWKwhicjo/fNzaU8YvcHFucfBhwmEsjMZsufdRFw+B92yZ/hZ90okNYQ5ifSrjuYd3I7GYDpV6ed+KHvijeUSiYweFFRkGZVz8YmA4xIJDWbgL8gAYRfyxQUYEi2DK83/QmIYoNCqHlbFqh6sZ6RkiSca3li8At4gnd5vgLfgrM=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5055.eurprd05.prod.outlook.com (20.177.52.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Sun, 29 Dec 2019 17:47:46 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10%5]) with mapi id 15.20.2581.007; Sun, 29 Dec 2019
 17:47:46 +0000
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0056.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sun, 29 Dec 2019 17:47:45 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] net/sched: add delete_empty() to filters and use it
 in cls_flower
Thread-Topic: [PATCH net] net/sched: add delete_empty() to filters and use it
 in cls_flower
Thread-Index: AQHVvnAU2TKW4Bc+yU2KmxoRUdXi/w==
Date:   Sun, 29 Dec 2019 17:47:46 +0000
Message-ID: <vbfd0c7gh1d.fsf@mellanox.com>
References: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
In-Reply-To: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0056.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::20) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b627d1fd-1a5b-49a1-d163-08d78c8736d3
x-ms-traffictypediagnostic: VI1PR05MB5055:|VI1PR05MB5055:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB50553505DDF54F6000E1FC03AD240@VI1PR05MB5055.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0266491E90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(189003)(199004)(6916009)(81156014)(86362001)(16526019)(186003)(2906002)(8676002)(81166006)(36756003)(8936002)(5660300002)(4326008)(2616005)(956004)(6486002)(71200400001)(52116002)(64756008)(7696005)(66946007)(66476007)(66556008)(66446008)(26005)(54906003)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5055;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FqRIWZwMSryJvkECTzq0zskJQ9vcojwSaLvrKhdOJXubf+3/Bm+VUK82G44FheH0XHXewGR0iwahZSJxk3TN0g4U9gKPbFIK3NKXjy6aREQuSzr2+7dCUMMy/vgU5HnAwHqhxULmqgxDbY1bNtKLvvNXxXbMkdZslMLK1zc4SMp8MVDEtJ5e8jJb/xFClSIBDuf3dYhAFVNNpOVVGefRBsvghQvNde4B9+17DUmC5nYHAsCtcu/Z0EroXBbUem9rz7FA3MIokGJ0CjatL6IaZD7aeOA/u/Rwyrd2BSX6VWyHbEfJhUO4g1s8iT+2mAl5ZrbePz8mx6yb5kLibgrW/n7snS8OcVfgWSkIl1o5qKXhp3yl2LVqlNGf8zgk8UiIxOCJV8tv8SU1dS7d7QINZ602WtKFttVNqfpEJH1Dfc0QZr+1Uuyol7AA8o6vsvVo
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b627d1fd-1a5b-49a1-d163-08d78c8736d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2019 17:47:46.6068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKtNBNUUZtbV10TYf1dp26LERHi9qfY/q1pbHF15igaJ8J7QxFkjbsNdRb+EjtPIiepmyfBOy7jRkK7BM5gYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Dec 2019 at 17:36, Davide Caratti <dcaratti@redhat.com> wrote:
> Revert "net/sched: cls_u32: fix refcount leak in the error path of
> u32_change()", and fix the u32 refcount leak in a more generic way that
> preserves the semantic of rule dumping.
> On tc filters that don't support lockless insertion/removal, there is no
> need to guard against concurrent insertion when a removal is in progress.
> Therefore, for most of them we can avoid a full walk() when deleting, and
> just decrease the refcount, like it was done on older Linux kernels.
> This fixes situations where walk() was wrongly detecting a non-empty
> filter, like it happened with cls_u32 in the error path of change(), thus
> leading to failures in the following tdc selftests:
>
>  6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
>  6658: (filter, u32) Add/Replace u32 with custom hash table and invalid h=
andle
>  74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id
>
> On cls_flower, and on (future) lockless filters, this check is necessary:
> move all the check_empty() logic in a callback so that each filter
> can have its own implementation. For cls_flower, it's sufficient to check
> if no IDRs have been allocated.
>
> This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.
>
> Changes since v1:
>  - document the need for delete_empty() when TCF_PROTO_OPS_DOIT_UNLOCKED
>    is used, thanks to Vlad Buslov
>  - implement delete_empty() without doing fl_walk(), thanks to Vlad Buslo=
v
>  - squash revert and new fix in a single patch, to be nice with bisect
>    tests that run tdc on u32 filter, thanks to Dave Miller
>
> Fixes: 275c44aa194b ("net/sched: cls_u32: fix refcount leak in the error =
path of u32_change()")
> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp i=
s empty")
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Suggested-by: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

Thanks again, Davide!

Reviewed-by: Vlad Buslov <vladbu@mellanox.com>


