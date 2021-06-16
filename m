Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9513AA0DD
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhFPQJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:09:28 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:1735
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231772AbhFPQJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:09:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wy4TGmOwtbQAtzosnEbiyF+HiQZuhxIAGWUf6xoLOJvE4EGOo4gWtpTUWa+6u8XNCQWGhqWDNAfFRAz9hr77v5mIII32hfr57YrDx2Nk4THO0UxLiyY8zn17Z3BKBomoZZW+aRCuuka3v5Q9Dbf/qRz/Im1Ov7FN+GTeR4yXdmWyUHCySVp7TrUWV/ciHzMAa1HGLETPzvH9tUCHxcX/1r3/2R8CDldKJLGJYYe7o5wI3YBD3sqKJih5p+hZPNZk7+bwE8vM2P3NGZOHl4/Rl19wQZCJ61P4jiI+zoQHo72Oxt2cclxUBTRN6SMSaXeWRwKc8nuo+tZXgd4XU2EBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRo+lFmy+l4L/+dLmnG8pXRnkLabtySKOg/bJMtiLos=;
 b=AjwsDAVYGeMa7XirVVtreea3WZrYdIR6kGFecUpk2o37SOmaa+bomyO+BWxC/3UAMMumzDrZ9rMl0PEUeEuJB+2S/IgsaLniw643VTxm0uJEUOoO2NZlwDiBtKx5N6YaA+z2XAXioMiudEOGsG1te1/EYnJruukoyv1mYo5ER81aZlRY+QmBQtRiKIwVf93QFM0Eb/ggi5ZaZgLTOPsYvxC2pz4dapyyXKEXx3JrWaezjkSpYpLT905lKgoyZwEarDWhPlh9xL9/V6yGNcvzXVrrDN9CdGx1j36MGaJo6M8VdVza8s2mX6//egzb49mPYQTmicapt2U747+9Xok3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRo+lFmy+l4L/+dLmnG8pXRnkLabtySKOg/bJMtiLos=;
 b=YV3gr/IKyw6MsrZl9+Z0w4fnVjrTyLWTCpZRhgLReWULw9K2hYD0Io+UH76kgvu+JIRgacN6+bZaypXkmc2rFlCa0QGyOEAn2p3htJWYYDMtwnxn8oLaTkmaTuDDqdDflT7DEWVm+9c7WHa+p0HqCuv0RHJqPYZntbqMJyuavr0=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1233.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 16:07:19 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 16:07:19 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 3/7] drivers: net: netdevsim: add devlink
 trap_drop_counter_get implementation
Thread-Topic: [PATCH net-next v2 3/7] drivers: net: netdevsim: add devlink
 trap_drop_counter_get implementation
Thread-Index: AQHXYR1pAn5iCi7wak6XE24VioxdxasWyLeAgAAB4Pk=
Date:   Wed, 16 Jun 2021 16:07:18 +0000
Message-ID: <AM0P190MB0738B2969624A9CDDCE53209E40F9@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
 <20210614130118.20395-4-oleksandr.mazur@plvision.eu>,<YMoap5Vi6ZkXgKr3@shredder>
In-Reply-To: <YMoap5Vi6ZkXgKr3@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.219.78.115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d3225e0-64da-4150-b8b7-08d930e0d133
x-ms-traffictypediagnostic: AM9P190MB1233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9P190MB1233DAB39CB0238CECFF1FBCE40F9@AM9P190MB1233.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ou/Uyq/OP/N9zePrIYxz1doW5WIUvff0YiCDW1Rs2hRDq+HCJiWm3eZeO1L3iWY0kg5BIv45v5uUkc+9jrgO6XOw0zT9vmEKWIqJ6aG3zrGU8t4tPhbpQndOB6noLcrwBeIV0rz3A0YGGEQWbscOFPygutpqTnF9ais6Erh/ww2ynOujDmak6Tpl9mTrgV3Nd6R1+q8dJb6dzeanhgr7oNcINehZwLNT7dwC/RSDzb5WPdszOAemx/I/n53Qv6xnLhSFqiby+yDwZ4sp2A7aoOZFqfZoX6i2Xfez5AGj35gRN5NPPSAfPEqaPts74X3urEggq2nOYl8/0JYcwW5v61dLsiGz6ZOm237/6Umkq+KPduvQ29qZGGuiNCgvw9U/2/ddrVGh8ZjeAgzHnKICDOLEBy/qRmD/9d/fQs03HolNntCujUeCaIh0VNyNS6ekCcThlPoVVwecWZ6oCLY2I5AnTuvvMbI+LL22+F1WsjAXTwflUHnQuCOknpwhoawD0RZM48/znMtBavsTdw1uMgIjW2q1qZ42XzFZ4W5EwgFoNaS+FW88YuE7IfmQ5VUwnbmE1CN0JaXwy3obLRbH1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(39830400003)(376002)(396003)(366004)(66446008)(66476007)(122000001)(91956017)(66556008)(76116006)(66946007)(8936002)(64756008)(4326008)(186003)(86362001)(2906002)(33656002)(38100700002)(26005)(54906003)(478600001)(8676002)(6916009)(55016002)(44832011)(7696005)(6506007)(316002)(71200400001)(5660300002)(4744005)(9686003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+31vYz/yi9sx3p4N64gEu3yzI+0kWc9Erk0D3nCiGjpfKcm1GHruV1U/Gh?=
 =?iso-8859-1?Q?mNi46Ikz+eikHwLgIbCNNtOhEJ8pu9V8258czZJJ1xhIxYafzu4rnC6/ro?=
 =?iso-8859-1?Q?zTmGOzLIO59RKApbK5dRzDzFq8jrIy4LmlFZPQ1bgH7bws1CwRpyU6j9j3?=
 =?iso-8859-1?Q?xCwOFTg46FhNzM98c6GO0Qt7ofhaIWilyWqYD3UmPJPdLEWQivv14xmjoE?=
 =?iso-8859-1?Q?tBRN/JY7w4CU1uzjLHb7TROMbaEVHR4wSJ82+BgSWORVDMICb3v7Ai51ae?=
 =?iso-8859-1?Q?BHLKwWp6rojJRQIoQ1pv6GojYosk3StKbbUhdkjR5SOX82gEYLcYxvejbn?=
 =?iso-8859-1?Q?Gxm7NlJtLtTYhh6WEIgcop8PrHFp4TOponi1F4d6csYW9FHom8J0J2YfY8?=
 =?iso-8859-1?Q?gxe5bL7XK9rfUDWSio9TL3uozphVt99zMRB9MoOkYbpTRHtgXvpQjUGkW6?=
 =?iso-8859-1?Q?CWY7RydCYDGbrH18M1W6S1Yfuk0Iz3EzXyco92rcry4lsrL9usQxaNfhu9?=
 =?iso-8859-1?Q?lq2j1GRvUkumuio1dMkOUeCetixDH8T/fXBy5iQd1R9zjNoc5y8jFEJBhQ?=
 =?iso-8859-1?Q?5PT1oxGlod29JC8zqxaac2Atjs0S0ITm0UJ0elzEOs3VZvc2VMkPULeQEB?=
 =?iso-8859-1?Q?OJxGZ6b5WpZAdoBAvgoS9F9ybvPp0/vvDf2tv82sDklvEqMZZf8Lz8WPlI?=
 =?iso-8859-1?Q?G8WTZrFwi2G9lYXcsT1XIJmAx9V/MtDzwAgSS7nA28swe4lbk+oTfgdaG+?=
 =?iso-8859-1?Q?XYRtsEGCfo9QHQ6/2HlmeXXAlVrRhrIkEQwVBWcbDoSYNj9Tynpx28LDJ9?=
 =?iso-8859-1?Q?rwYNLLrPfZybva0ESR6ZxdOwLG8URXZoSSrboVH1DepEC8jykhBS1n7IJj?=
 =?iso-8859-1?Q?uRPMkKsja9JmmnPknx4yAHEARdYuspwGv+/Bhl5TK/7gWjTT1vdodaMwFZ?=
 =?iso-8859-1?Q?Fp7S3ec6CmVo2WAqfTceiSk/3Rjsnfl+iNrLHJGzBYAniWvQudfEKnfqUt?=
 =?iso-8859-1?Q?iHgpH28wnUetJZ0VqX6P5KPWibhCvTFJpUsjF8NitaMhjpeWZJ2pw8MeTm?=
 =?iso-8859-1?Q?6H4+e4K/VTlBf3uhuiZqrT6ccU72flksWdXpvSzrPjAf+aojeTOq86G/BX?=
 =?iso-8859-1?Q?SqxcBCjoX0BSge/6t7tjLWz90QR8oFWOGq4LRQnEQVs8gSFWe4DfNNTtHV?=
 =?iso-8859-1?Q?ES0U5VXAsHidsdlmH2yHqYXFN1L+P5AOw825gMiSVg7gYhuHYkcGdJXWW/?=
 =?iso-8859-1?Q?f2wyBNhV/Yi7tunRHnlW1ofgGIOFvRnQrjfwk3KnXc7cgB5TNZr+pvWGaw?=
 =?iso-8859-1?Q?yjxucnsCzw5QPlHq00aCUPr1VeN2s6Y9WiYIW5dAm1Iav8I=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d3225e0-64da-4150-b8b7-08d930e0d133
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 16:07:18.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dzUwHDdAz0aHBGUqkf2CCgLELQlDw/sC8OBAAz93t5kaMhDcYpq8YM1d2eAhIw1zw2sFbzSJXaF5EbtyjHp56mYsxiGlDhP8BdhgrCVU0dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1233
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: Re: [PATCH net-next v2 3/7] drivers: net: netdevsim: add devlink t=
rap_drop_counter_get implementation =0A=
=A0=0A=
> On Mon, Jun 14, 2021 at 04:01:14PM +0300, Oleksandr Mazur wrote:=0A=
 > +=A0=A0=A0=A0 debugfs_create_bool("fail_trap_counter_get", 0600,=0A=
=0A=
> The test is doing:=0A=
=0A=
> echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get=0A=
=0A=
> And fails with:=0A=
=0A=
> ./devlink_trap.sh: line 169: /sys/kernel/debug/netdevsim/netdevsim1337//f=
ail_trap_drop_counter_get: Permission denied=0A=
=0A=
> Please fix netdevsim to instantiate the correct file and avoid submitting=
 new tests without running them first.=0A=
=0A=
Sorry for that. I've actually run the test, but the problem is during patch=
 preparation the naming convention for the counter itself changed (and i've=
 missed the debugfs file name to get changed as well), and i've run the tes=
t before it was changed.=0A=
I will send the fix, thank you.=0A=
