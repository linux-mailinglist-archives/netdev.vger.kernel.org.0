Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC0B48AA
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbfIQH6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:58:42 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:59852 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727321AbfIQH6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:58:42 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 08E38C015B;
        Tue, 17 Sep 2019 07:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568707121; bh=Y5bUMqv5jwbpV9UegJZZHS+hSw4raqgWLmSgAaYDtl4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=J8mafqGJT0Uz5J0jVfE982mhKM6VZEBV5MNOHsyTf9ujK/ZBFK+0KEpioQ4Lafgql
         CXIK+HiCC7iYzG/ATEbiFhslz6M30YrWAKy+EbumZAnkBpVzQjZ3u1vsfu8YIRxyE3
         EnpRVogvjYSHilVPWU17arnJBoFAVTjTAuwZOWX6Jy2OaEh0jcrbagwJMokp/O34h+
         2Iffj5/djngnlhuzs52poVKZ6qaS6jpCe7F0UW+Ls1sSpvyVZnesMEkxttmIGB3tPc
         tkjxaENYu4sv3c4NWrvJO43lw5aQAkQZVdg1WN+9DLbl0YFzqqWwZ9u+yT74VosGxT
         YQe96GjfxDSGw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 29DBBA0069;
        Tue, 17 Sep 2019 07:58:40 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Sep 2019 00:58:39 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Sep 2019 00:58:39 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 17 Sep 2019 00:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ED/I4tyYZmSn3eiFbCzGXX8GuBI5ahBBA+6ZSm4ofeR4PSxmC7yoftOBqqi90QKY+9o77Cqiyxhtal+WxCtvo5ouxNxJXrfpCJOlAJPlgrBmOBz6IvdusaZu367HAwxqy5KpYx9etPQKGiwkF4nReQZxVBcY/Mz6ZDlhMGUmnkFZqyo8ogd41QBz4P37/r5XBtWR/KxZGoW+qwjCK2v9O9Sp8ZANZEeADtKqX9VtXg2tpVCzBtUi1GziWGeuD98S9zdsdznKyUrixml/KBO8o2SjcKu1k6CJr72tSBpTTEN+wQ1df0QdndPDUMBkRkPgADcYJHLDGeLl0tfshCtMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws4UVhSaCSBi+yAXVoOt1me84lASVrf/l5Ag2GOo7QI=;
 b=Eq25AdZBJZ0iebf2ctBGC5N6Id+XZxYsJRCIlCLNlAKNR1DfNgvkgVXVHxGiLPV37BCizagrPjfE9mWwR9yMnsSkY+E/MgJ7W8do7o7RrOeIe25meDNYRV5jzC6x0W9jrexnXpV6AI+ZwLoze8xBxV4zI74rcSZwTb81mctppKc/XzFMq2Sqegh/kcuGqd2+IQ9VVxhYG+lDAK3gnvLFrT5p4zNfCjtudlRCjOAfUh0R5DYlUON0LnFVAWCP0rqRmx25AE2cGqbK/vd4FvHCu9IQYsENnrFEKnfwDwla46Dv2dsZ3SSDglUAMH2SrV05+zednzHSQx5UCp6ic3gJ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws4UVhSaCSBi+yAXVoOt1me84lASVrf/l5Ag2GOo7QI=;
 b=H29uE6uN5s39XNs8380nw/HgMhoRCQqiuETLb7MajFnPhMwu+ZYhGBy9cKfLckqyBYpj4wTD6o/tIGRNUlLvf/PmKa/8aovNID9ZGoiDhrFUXiT2d9EDzNmskXpFeG6UL++vmVRUb1GvlbChfpvuy0zl0k9fSvKTo+ux9wx+uIA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3571.namprd12.prod.outlook.com (20.178.208.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Tue, 17 Sep 2019 07:58:36 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 07:58:36 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: -Wsizeof-array-div warnings in ethernet drivers
Thread-Topic: -Wsizeof-array-div warnings in ethernet drivers
Thread-Index: AQHVbSoo2sCm+b6KbUmq34Z8Q4HTw6cvgEig
Date:   Tue, 17 Sep 2019 07:58:36 +0000
Message-ID: <BN8PR12MB3266AFAFF3FAAA9C10FB1C1FD38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190917073232.GA14291@archlinux-threadripper>
In-Reply-To: <20190917073232.GA14291@archlinux-threadripper>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a50742a3-8d51-473a-a78e-08d73b44d848
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3571;
x-ms-traffictypediagnostic: BN8PR12MB3571:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB3571EE7E26EA7201A3FFA46BD38F0@BN8PR12MB3571.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:58;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(366004)(39860400002)(199004)(53754006)(189003)(66946007)(110136005)(71190400001)(14444005)(71200400001)(6116002)(9686003)(6306002)(7736002)(7416002)(26005)(446003)(55016002)(52536014)(76176011)(99286004)(102836004)(486006)(33656002)(305945005)(81156014)(25786009)(186003)(74316002)(8676002)(81166006)(3846002)(86362001)(14454004)(966005)(11346002)(256004)(316002)(8936002)(54906003)(6246003)(6506007)(7696005)(4326008)(5660300002)(478600001)(66066001)(229853002)(66476007)(76116006)(476003)(2906002)(66556008)(64756008)(66446008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3571;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2fLs5v2cjOMaI6F/Bb34uwvmQ1qy+JP5lvBTr01QmQVDZvRGa/NLylGJ67m1fgQYUzQLFKJMwkGML+ZPyCNfi5v1BI7+mwnopj71Lw5Yr5MawxLEsB2K3gfbd+vOt+mLRGLDlOO26wurVUH40W+SZJYZNhojOK2omWgN97CB7eaC1PdH4lqZUV/6a+BcdF77PYR4lneOx6vgvG3GUpICSzegX85z9mhaOm1nBsjE1j31bXSE0/g19HuoM44YDJSVGRLOe3TgcqpjH+z6aU7Agcxfhnmz98VABzAhNyMbvosoVI+T+y/CLmxQf0AxJwDD9JD7kqcM49uDR9GFmUZZpHMkayTCMxuOAlkNwdsRVwoLiW2/IisptFsdlUmpIPrfl2LCAsWi5z4hlbo1zcEabCWEhvGvkObtCdT0XR/4VMs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a50742a3-8d51-473a-a78e-08d73b44d848
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 07:58:36.7340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0JdiBlAyNYr1V6e+rc8+GhmyexvDwkHRyUkTDMioy/qF/T3A7w9vkU14Qrj5DpU6el8Z2Vyrua85z6aPM5OE3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3571
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Sep/17/2019, 08:32:32 (UTC+00:00)

> Hi all,
>=20
> Clang recently added a new diagnostic in r371605, -Wsizeof-array-div,
> that tries to warn when sizeof(X) / sizeof(Y) does not compute the
> number of elements in an array X (i.e., sizeof(Y) is wrong). See that
> commit for more details:
>=20
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_llvm_ll=
vm-2Dproject_commit_3240ad4ced0d3223149b72a4fc2a4d9b67589427&d=3DDwIBAg&c=
=3DDPL6_X_6JkXFx7AXWqB0tg&r=3DyaVFU4TjGY0gVF8El1uKcisy6TPsyCl9uN7Wsis-qhY&m=
=3DXFx3a9bS-B05voQh4LJquxHuP4TOowjC82tcMo4gPz0&s=3DNpzuPgHoSG2p4Mg6ko4MgHHV=
3TpTwEGm2XNTyw-s3XY&e=3D=20
>=20
> Some ethernet drivers have an instance of this warning due to receive
> side scaling support:
>=20
>=20
> ../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: warning: expression
> does not compute the number of elements in this array; element type is
> 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned int')
> [-Wsizeof-array-div]
>         unsigned int key_regs =3D sizeof(pdata->rss_key) / sizeof(u32);
>                                        ~~~~~~~~~~~~~~  ^
> ../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: note: place
> parentheses around the 'sizeof(u32)' expression to silence this warning
>=20
>=20
> ../drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c:537:36: warning:
> expression does not compute the number of elements in this array;
> element type is 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned
> int') [-Wsizeof-array-div]
>         for (i =3D 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
>                                 ~~~~~~~~  ^
> ../drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c:537:36: note:
> place parentheses around the 'sizeof(u32)' expression to silence this
> warning
>=20
>=20
> ../drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c:2329:49: warning:
> expression does not compute the number of elements in this array;
> element type is 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned
> int') [-Wsizeof-array-div]
>         unsigned int key_regs =3D sizeof(pdata->rss_key) / sizeof(u32);
>                                        ~~~~~~~~~~~~~~  ^
> ../drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c:2329:49: note: place
> parentheses around the 'sizeof(u32)' expression to silence this warning
>=20
>=20
> What is the reasoning behind having the key being an array of u8s but
> seemlingly converting it into an array of u32s? It's not immediately
> apparent from reading over the code but I am not familiar with it so I
> might be making a mistake. I assume this is intentional? If so, the
> warning can be silenced and we'll send patches to do so but we want to
> make sure we aren't actually papering over a mistake.

This is because we write 32 bits at a time to the reg but internally the=20
driver uses 8 bits to store the array. If you look at=20
dwxgmac2_rss_configure() you'll see that cfg->key is casted to u32 which=20
is the value we use in HW writes. Then the for loop just does the math=20
to check how many u32's has to write.

---
Thanks,
Jose Miguel Abreu
