Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3D121E93
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLPWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:52:34 -0500
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:5377
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbfLPWwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 17:52:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuDM3renKmngPk8NwNuuI8+qUC37IMxGN6fMQXOYJlSjXaisIyylsbNRcX6r2ASrv7YDDqcvZKh4ptcqdhIE9pOTPnhf37tLOrToZFc1588z2MTmWECs8civ7IF2bFb2M/dIrBarrZZoZf80RGr148qfAZsEedzQ4+OD+uYXb2Di79/vam/w7ob9czfuyQgY0i8/ErgM3NPeDLneYU0GK7wZW5YcUI0gAuStrcs249CbhtvhYITnzc9ZtUkK7+RwD9gwVH/+qDb299xYwQR7oS6xuFnU6OwFrbMyioKl1o0ulMydFUYCLUpIIHFHpgMyuRG9uyrrQgb7YSoYbQh7BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7RAXNdZN4S3XzOI5suq+llupLzsi9dfYIVJLo3E4Z0=;
 b=gNI3ERztDrknVW38YrAHXBh4jtVsFPgINVogUcwW0r0AxVO9ZoGEQ/ZT83+x+Q5Tu1vWAubJ/yHrtI0Kr7QkyCmwqDMFOn+frqSat4Z1HWaC66rL7wI8yeJ0s+vrPDP7J+8wUEzxEE5dftE4glH97qbp18zU35EsO65UFi/2Ienkt5xSkHTWtL/OV4tCJwnuVHePu46dlzIW/6rvwzuGEJ1mW/ZCpiW21nJKePapWI5OV8vhdAD6A20IKU61C4Ij6OrEwSTmIMWDRLLEEQumfoPhFsPrSjjCDMnQdiii9s3o22NpIL1GRZqy0yV0ZROsfpym+Lq3VTU4BxSCmPojig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7RAXNdZN4S3XzOI5suq+llupLzsi9dfYIVJLo3E4Z0=;
 b=VVZESuob32PytX9J/va5PLvn9hPHapFwNuk6QN1Gzx69bzCHRcwYeylzvZ5mA6avufYaxo+Ny5IHsyInmuZ856P/BriDz7T+5JsM6OEE2dYPPdonWoUtYPW4+/fbWp/T3xAf66ZQi8+f7OK3+VCKDT/1X5EWrMo2lmufFCwWBoY=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB4311.eurprd05.prod.outlook.com (52.135.168.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Mon, 16 Dec 2019 22:52:30 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::e8d3:c539:7550:2fdd%6]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 22:52:30 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Topic: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Thread-Index: AQHVr871nDBB5hrvy0ak2C7+9Ay1lae1Oa8AgAAB1gCAABOZgIAACO8QgAArtYCAAAxfkIAAC50AgABVJmCAAOJ/gIAAIpgggABa3ACAABH7IIAA/jMAgAAW14CABMvNgIAAB5GA
Date:   Mon, 16 Dec 2019 22:52:30 +0000
Message-ID: <AM6PR05MB5142B1D44D6190BBDE19F7E0C5510@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212175418.3b07b7a9@cakuba.netronome.com>
        <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191213100828.6767de6e@cakuba.netronome.com>
        <AM6PR05MB51422CE9C249DB03F486CB63C5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
 <20191216124441.634ea8ea@cakuba.netronome.com>
In-Reply-To: <20191216124441.634ea8ea@cakuba.netronome.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ae377e91-dd13-47f4-8bd0-08d7827aa165
x-ms-traffictypediagnostic: AM6PR05MB4311:|AM6PR05MB4311:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB4311FA62F3239F48CEDB9D19C5510@AM6PR05MB4311.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(13464003)(2906002)(6916009)(33656002)(64756008)(53546011)(6506007)(26005)(86362001)(76116006)(66556008)(7696005)(316002)(54906003)(478600001)(4326008)(81156014)(8936002)(71200400001)(9686003)(5660300002)(66476007)(52536014)(81166006)(66446008)(186003)(55016002)(8676002)(107886003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4311;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWatwnONs+GHFlTRF2L2Ps3wW7S0hugCGgTCLtFh/JaXvtl2KPThp0AJ9y+qaQgTKVw/O2WaaHfaVsOuudgkKuIiv5Jo4GpGIWv8f2iEDK5xkl2fsTLO0iEgtLto8xWUeJ9KBeNVdK/vvfrzGZA2fsP6ZGRteVr8VNNsYzpDbO4cR8JvJCENKhYNosXeAQVfYQBmFtrO9XdfvTSydgOeIkzfolRRKq3vX1ypgKHvnhtVMTnQiz7LoLZCESPXV9iLCIoij0Reseu2mNHOTB/ElYHUEsRWycMmPrY9njwM6oilE4a4dh7k2PHF96CQ9h6ithOeXgLVQtGQMSWFzIUP5eUv9caJ9swIFVWhUDT4VPKXl+GUbZ+OQUD+lzWfhSZWfSlm8SGZPv5x5aJr0Xw6hKmdfHKD5th2KWWVroQWB2Z7T14u/ek+FtcBVvwHqddO58opcje8BpHlo/afBJueom/8J/yDyuOHH9TDgOcETecR7TU7Jwxy2AufQWkUIiIK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae377e91-dd13-47f4-8bd0-08d7827aa165
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 22:52:30.0592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ms0Jq4GTSDnNMHoLSNyy/F+WJQUQr5TMDCqo6uKP/i8aAonhQf/f1STP+YlfGexz3uI1WLWk50c9MFB7VmSfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Monday, December 16, 2019 12:45 PM
> To: Yuval Avnery <yuvalav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> <andy@greyhouse.net>; Daniel Jurgens <danielj@mellanox.com>
> Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
>=20

> The ip-link API will suddenly start returning errors which may not be
> expected to the user space. So the question is what the user space is you=
're
> expecting to run/testing with? _Some_ user space should prove this design
> out before we merge it.
>=20
> The alternative design is to "forward" hosts ip-link requests to the NIC =
CPU
> and let software running there talk to the cloud back end.
> Rather than going
>   customer -> could API -> NIC,
> go
>   customer -> NIC -> cloud API
> That obviously is more complex, but has the big advantage of nothing on t=
he
> host CPU having to change.

I will try to summarize your comments:
1. There will always be encapsulation, therefore network management shouldn=
't care what MACs customers use.
2.  Customer is always requesting MAC, it never simply acquires it from the=
 NIC.
     There is always going to be an entity running on the host setting MACs=
 to VFs.

Is that correct?





