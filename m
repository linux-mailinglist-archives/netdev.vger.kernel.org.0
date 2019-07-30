Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6247A67A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfG3LFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:05:31 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:52110
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730115AbfG3LFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 07:05:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXnAmTXjXOzYMhpVpemGEk61Uq3mw038zk6Rqm7zbPFvr8w6fe2Hmy2VVq6mJSH2mGMC6/Pa1+CjDnI3GGGWkfIMDJbbNR4hfJLumg28HUUhBaJ5UkblDJ7JtxLpBcd37WRVN5sFFyFtg2lKu56ra7p883rahQVMHfRd4vOfe75oJH+gjOTYcU+x/DdKyEWayI15t7e4ZBHkLoszCfdKPgUukAAqm3UKdG8Ae4O/RXy7jWcm3txDRGP283jBCQ7BV8AQsF4HmfwdsF8cIwPjiT6bLSEff1ldLuQ52gGWL0sjpS6mTgyh395614OM26fDDlm0a7qxfifXCqHQg89yiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzUa6Nh8JEemmCd2Zrquv4i0yHwlJ2B06v1l/6ToXZo=;
 b=D3IqwR1bxT7e4C6PnX+IKxTL07f86d8rNLYCloVIG9dAqA61tDxwBYF/4KuRYqxjhaGQrsyEUzPYozCZ67ctA+HpSH1690xBEkbY0n2nzftum+/SfQ9jHWxJR4vN++A5BCOh6NOgw4lcjBc3uBgG7nXUjyzzK49XJ+EU276jPnuquULbxQ7TQcyTF2UabULVjjBsvnKlEgRsYqYfpJTsagXn6YcwW41vbHdkSuXdAFRYIJJlX3hyYXhAe728oACQpt7XD3Q5ps89rpTtq2OQn64OYAcldAJDcUNboo9RoLfb1iSxSTnSriceWAQ14OII4P12MoQr/HEBYNvfDfRPjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzUa6Nh8JEemmCd2Zrquv4i0yHwlJ2B06v1l/6ToXZo=;
 b=PWLAREYltfye5Z2Sek0dtfv+NHf3Z5Xbv2fT81UVDNoE6XBfEnZkpEXSn03X6h2q/spYfUsjvEVbq3RBXq0tHi+w3jNy0oe2TSzHtAas/LWKSYPJkr6QypTOKONjc0PrLywpWdCSyADbFnTGOjkZg9JnbTqei3+rEMJkrjiTE/4=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB5979.eurprd05.prod.outlook.com (20.179.10.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 11:05:25 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 11:05:25 +0000
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
Thread-Index: AQHVRsCGQQzG+jKZokepZOkvOqeUUqbi/mGAgAABe4A=
Date:   Tue, 30 Jul 2019 11:05:25 +0000
Message-ID: <87k1bzzsss.fsf@mellanox.com>
References: <20190730102114.1506-1-colin.king@canonical.com>
 <87mugvzt1m.fsf@mellanox.com>
In-Reply-To: <87mugvzt1m.fsf@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0005.eurprd09.prod.outlook.com
 (2603:10a6:101:16::17) To DB8PR05MB6044.eurprd05.prod.outlook.com
 (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3275fe2-6427-434b-d7b4-08d714ddd2ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5979;
x-ms-traffictypediagnostic: DB8PR05MB5979:
x-microsoft-antispam-prvs: <DB8PR05MB59795D14D5B07B4C38E52081DBDC0@DB8PR05MB5979.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(51914003)(189003)(199004)(8676002)(4744005)(68736007)(2616005)(2906002)(316002)(256004)(11346002)(478600001)(229853002)(4326008)(6916009)(81156014)(81166006)(6436002)(7736002)(476003)(25786009)(86362001)(8936002)(446003)(6486002)(186003)(64756008)(5660300002)(386003)(6506007)(36756003)(66446008)(486006)(99286004)(6116002)(66556008)(71190400001)(52116002)(66476007)(102836004)(3846002)(66066001)(71200400001)(66946007)(6512007)(54906003)(53936002)(6246003)(76176011)(14454004)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5979;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: npKIYn39SNAyNt9XIgd0FO3ATjDsfqGDLSJWywvP3LckCI+RnsKl3rkeW45D0oXJpckcaiaWl4/OzgI9pMDFzHQ0O9PEA5y8yNuc3s0PX7g7d/SylFfkFV/mWgWP8pKDfpoV/Cs8n1aEpK3MDMgNyZ3K0N7MCmYbhUzG7lYk9s2dF+4V9EXq3RADEYk/VrHDdkKBfgKKtqlIoMKfKnRLcYqDuRLYUc09ZQ3ZkGfLXl6v3khxYRpuOIffBqOf8pPGOK40UyKQdARgQNQGC0/QnrthCnrV21kU5GpZ3/acTsFggyIKdcbjgw1t5BFs5OEc5bPjyfH4UjfhgyHodskR9i/tVCHcy5S0FFa9pr40p3CSVcxfb5RXly/z9z9n8GC4s3z0oFfULai7t+3M+sjt549tYPY14pIZUG4yV6Vv6bo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3275fe2-6427-434b-d7b4-08d714ddd2ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:05:25.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5979
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

However the patch should address "net", not "next". Can you please respin?
