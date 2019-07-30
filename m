Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714207A817
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfG3MTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:19:41 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:19725
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfG3MTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 08:19:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpcNA2wzNBobxeciwNbTgqtqIGui0CaFdoStSSMrpJ/kjd7Jf0bdmoxuWYvAHUU+ShOg7R6Jx4/qAN3Y/0bdJAYBtqDWvhCF6vxs7EF0pFsMeX7A6c9w1XRuIp/zYNmduYm9kjBehlMX0pFd0EtyLEDiqzypGsFKJyh8uylXoDxvjExXY4hetav5zJHxpazgFCaYaRzAuhU5eCW3NAAVUANg31/zNmq5sM0+uRhz2l4ZeYBuNsdSxVBv044xAlfYtcFO102jv4Q+Cg/Ee8Wb1972czINjzyTooR78hCT0NlWkxfvMOHggW42tb1Ra27SnBdPIioOaf5IHsJgk1CzWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7r28WI1zmhD86uBueMBy2Xz3kppo0N4zZqEukaszHk=;
 b=MuUVjwXqkOX0E1taGUdI5EbaYdsKYFe1lwSaZ0kGWy82EyoktFvlqPqx/UNKbxcQCiSzpa8OqL8cd6osmhdcKTv/S3Q0T4guCNQvZlCyieirS+mkDSusuicmVazwmsQUS0pN7JsWE6GLGX9nbIkJEgKygQzTLHXx2VOlGJ++E64zuPYj/tUMG3F24korD3i5ltMtfHz3+duwfPIxhXHomumEhK0R9H01fvmn9gEHT4Mom3gTwKKeiuYHbQSlaerl5GIs8fUT58q1zmCnAWysWybdJuZjwwUlSVSDjRIMAaSntH3KiNRzsEn9YrQCbUKVDreyGUTz/VbSS2b4OpEARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7r28WI1zmhD86uBueMBy2Xz3kppo0N4zZqEukaszHk=;
 b=opaoi4LM+GDxj7XudZ+CCFWSeFfnB8lIyVOeBba/ZrhwpCXeKbnfcFNB8MXziRDdlhVy3WvTW/dt/bRwe9vnPpp49iGx3XP/H+PGFjOgTBGHR1/PGRbOK1831FeT7ZJn4f1Yn26orhhBFvuP3ueQloTi0ScDaPwvlf87Wjd37mk=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB6652.eurprd05.prod.outlook.com (10.141.188.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 12:19:38 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 12:19:38 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Colin King <colin.king@canonical.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next][V2] mlxsw: spectrum_ptp: fix duplicated check
 on orig_egr_types
Thread-Topic: [PATCH][net-next][V2] mlxsw: spectrum_ptp: fix duplicated check
 on orig_egr_types
Thread-Index: AQHVRsyfxFiButgxYE26V2z9IDLae6bjFIEA
Date:   Tue, 30 Jul 2019 12:19:38 +0000
Message-ID: <87h873zpd3.fsf@mellanox.com>
References: <20190730114752.24133-1-colin.king@canonical.com>
In-Reply-To: <20190730114752.24133-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::41) To DB8PR05MB6044.eurprd05.prod.outlook.com
 (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8605605-f150-4440-122c-08d714e830e3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6652;
x-ms-traffictypediagnostic: DB8PR05MB6652:
x-microsoft-antispam-prvs: <DB8PR05MB66521DED1DEE429E136291EEDBDC0@DB8PR05MB6652.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(199004)(189003)(25786009)(3846002)(4326008)(76176011)(14454004)(86362001)(256004)(6116002)(305945005)(478600001)(81156014)(81166006)(66066001)(8676002)(2906002)(6512007)(11346002)(186003)(486006)(2616005)(446003)(476003)(8936002)(26005)(68736007)(71200400001)(66556008)(66476007)(316002)(64756008)(6506007)(53936002)(6486002)(102836004)(6436002)(4744005)(66946007)(386003)(52116002)(71190400001)(6916009)(5660300002)(7736002)(229853002)(6246003)(54906003)(99286004)(36756003)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6652;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xBKSAfMkD23hxHVLmhupcrgsxjRvpX9IZcvGNY8PixMorgdFRAVG+1rOG46cnUeWrvtqC1i8QCDBV24yLNoBe8aa+Zp5iSkxMkZ6+aj766z8NE0W90iqdGdhLXeZqneMmhvIT+3MTkkG6MeUWNmtNyKRKPswxgNdka7DdwWScgWmb8JIg1jhn55U0pJE9a8C2cWKbkFT85/DjmwdWAf/cpkdr3wzctBWJ4wuiae1KLLLN20sI7A2Iwf9L7pa5A4MNkpFuORBX+w/QzRwKfakWWbXX17u+3KMwIRUDpaE6tTpywF5U7Yiu2sWe3xJfojipUGNSI3yJbNfYpnCiQYS9pTjoTYQj+R20NdYBK9u/rdhjjVxs+1/CXERYp4BUnyllpcGxF/bMG9yJYr0giXV835/XFCk/fPQOYmn6FrLsow=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8605605-f150-4440-122c-08d714e830e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 12:19:38.3898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> Currently are duplicated checks on orig_egr_types which are
> redundant, I believe this is a typo and should actually be
> orig_ing_types || orig_egr_types instead of the expression
> orig_egr_types || orig_egr_types.  Fix these.
>
> Addresses-Coverity: ("Same on both sides")
> Fixes: c6b36bdd04b5 ("mlxsw: spectrum_ptp: Increase parsing depth when PT=
P is enabled")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thank you, it looks good. But can you please direct this to "net", not
"net-next"?
