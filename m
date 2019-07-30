Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4177A6AD
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfG3LMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:12:41 -0400
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:10727
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfG3LMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 07:12:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQOlQhIv8p8kocslHiMJmdv/9U2mh+dzmW7ZtqbDuBAmeG8j2zoaqTCE7x9rDlKkT8RqMyxEHPxNy+WkvacUEAjhJrO9OC10H1UEFqdHopfroqz8K1uQips1JOOEohNkcnl6tcaqM3hnz5dZy46H1f+FQbcseb8XkyiX3KQQbFlSrZbL6cC3WSBEZ+RSqVbKV8MofusBdVeq8D89ZuJ+x4OmgPCE0bCSQ/mnob7gGQC9cy9ompFDH64Tg4jepql06ke4ofcCQwZNfH6lPvfhprhAP8HfHxzltqXEorX1aY4TQuqxi3GirEoKBEeJW/FgRy7bWfbR9zb1kF6ypXVhqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C/xFAnnnvYJ78naSRzS2h/X32Skvt+DiXTgt1NaBHo=;
 b=jLBHdLHyQkZJpz9DDoDCsZFqfcgWdzmqgEALisJIstWRueMey6CRzTEHSI8qmuC7GlnZg1fJMxHosxMx+dQYLb1ypoI4+SgzX76Vb8jif5QgyzfQp9ozWghZrgwn+b50aYUU5lakA9kvzoTTHE5m8Q73IZocAsJ6/caPpxSzye5O2YkhXu/PUH/y2/H/PKZOv4YL52/WQ9ILgSuaG3dEgZgxvzGx7Bn6mgvhceyHzvjTPql0Rs9hIChw4Pt4t5QWuEB60NtyUwMsK7aPvdUUkP8vEZeGFQpv0fv3nYc0M5yLSvkTCf6cE19u7ZAIIShTHMsSSZoYReDe0WbATDlekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C/xFAnnnvYJ78naSRzS2h/X32Skvt+DiXTgt1NaBHo=;
 b=engVDig3G879Ch+SQHNwwGyec/QvNSZ4y8O4K9cjEGRaqD77HUOh5l52gqooz9HqyOlXN0mmuPB10pxK5UI2TMux/OkMpnpRXMrLhCt9Vd6JzZKPZGQSIhJ3KlbwXgw7Ncxhke3WAZVbxAi47AoLeILD8L8ojbSbqZQABi1AnQQ=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB5930.eurprd05.prod.outlook.com (20.179.12.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 11:12:36 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 11:12:36 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Colin King <colin.king@canonical.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] mlxsw: spectrum_ptp: fix duplicated check on
 orig_egr_types
Thread-Topic: [PATCH][next] mlxsw: spectrum_ptp: fix duplicated check on
 orig_egr_types
Thread-Index: AQHVRsCGQQzG+jKZokepZOkvOqeUUqbi/mGAgAADfIA=
Date:   Tue, 30 Jul 2019 11:12:35 +0000
Message-ID: <87imrjzsgu.fsf@mellanox.com>
References: <20190730102114.1506-1-colin.king@canonical.com>
 <87mugvzt1m.fsf@mellanox.com>
In-Reply-To: <87mugvzt1m.fsf@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0012.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::24)
 To DB8PR05MB6044.eurprd05.prod.outlook.com (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b62426-364c-4e1d-7680-08d714ded352
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5930;
x-ms-traffictypediagnostic: DB8PR05MB5930:
x-microsoft-antispam-prvs: <DB8PR05MB5930F1AB8D49A98068B71577DBDC0@DB8PR05MB5930.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(51914003)(43544003)(189003)(199004)(6246003)(86362001)(54906003)(81156014)(66946007)(6916009)(66556008)(64756008)(66446008)(8936002)(6436002)(6486002)(6512007)(53936002)(478600001)(26005)(229853002)(3846002)(6116002)(316002)(186003)(66476007)(99286004)(4744005)(71190400001)(36756003)(25786009)(7736002)(11346002)(446003)(52116002)(2616005)(68736007)(305945005)(476003)(386003)(6506007)(14454004)(5660300002)(8676002)(486006)(66066001)(256004)(4326008)(81166006)(71200400001)(2906002)(102836004)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5930;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vgOKyVsW6l6StAsrsDyfH6MjB2IbcV3S6Rj6Bfv8lJdr69GTOZSgTA+ikC/6fJiV2RObvQCJ3QGim9qVLeBA/r76tn1up2XFSerbLg+fKaHKHq6ll03IHTiwQOngekvdBMM6LncDRtkdhSz7Vm0EI0DqNGPZPgm0+k8JbKZJ1B1rhpwxbJAaEb74ndZQQHBfw00UUOoLDk+CpfvvLeJa/bJgfL2yeTSy9VE2dgy4J7N3+NHbuxiGHesOTqRUJKwXLIlzPT/Y+jHS/t78gmYjXrWrplJ2IS58FnTiEkdBxoyJRMsUMHUlJDy+UN2eQ3pkRHpxiOiwdb0FusgGpFHaE+7YCaO3NZ+tnIaFiSWvPYxXjyPj1KXRGDyD0/Zli1p5i5yEWz6ivv1LRAxh5S5WUFZBc979SB/wzHWrkC7AXtU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b62426-364c-4e1d-7680-08d714ded352
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:12:35.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5930
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@mellanox.com> writes:

> Colin King <colin.king@canonical.com> writes:
>
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently there is a duplicated check on orig_egr_types which is
>> redundant, I believe this is a typo and should actually be
>> orig_ing_types || orig_egr_types instead of the expression
>> orig_egr_types || orig_egr_types.  Fix this.
>
> Good catch, yes, there's a typo. Thanks for the fix!
>
>> Addresses-Coverity: ("Same on both sides")
>> Fixes: c6b36bdd04b5 ("mlxsw: spectrum_ptp: Increase parsing depth when P=
TP is enabled")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
> Reviewed-by: Petr Machata <petrm@mellanox.com>

I see that there is an identical problem in the code one block further.
Can you take care of that as well, please? Or should I do it?
