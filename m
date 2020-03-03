Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53B1177878
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCCOLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:11:46 -0500
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:51317
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbgCCOLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:11:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uw5/RFSDXZVkXKfP/HjD6hknPrV3HQnL/YzGOrAYlgDvwthnN/eucvurUkPXzHBxjCpUyyNqKIapg16UlwmVyKkuIc7w8wO53uV4p36q6AyF3o6fBT8j4fSL3P5lyuYZASuuhI/ZvfSCZbwC5xxBB15BeafG689wPotHzR+39mzTG7vl5FG4d3FIeGqGL/IoBe3XqixbZg0tZGLPWJ37xrAlbf3F/vuqlFkW8ujsZPw0PsPqmD21jNjm7vdZvTz2GqTdRrPU/gN1mDFu7JPMsmVDHMT0RCAnNW9SdQLHmVvzAb7rqzi3oD229kdFxHTgwjVn3aQmYYpOmitS4TXnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzOQC/AhBhBdGJCn1o4dNSoL14amDqH1e7Rtq44sqxM=;
 b=FHbvyXHMjXa+KVFRpNVn0mfvnc3NlcUjTcpKAKULbziqHpfXWu0Dga5tSTTs4BTIwp8tBAjZXX1gGdwIcYUHYFfp+64rRT/lb6zDQlwFK24KpaqJ5tZkZoVB0YRGLt2V0v7qfCLFkwe9alnuQNelku4cAEvsDKUuca6iETvIQ03qeTxr1fvAjHDaWTHJubfDKth9bbWaGV0i8bWnQ5Q4Atl4cRqYdOwPQg+JuiSnZOkY96hyQpQUGlTPsK00eWiqvkCyGOaPe2tmaGjfiMpTImfAwEBfThI9rJHcGn+tdPWJUjoBl1ZS/8okNL7K3K4hHxzr/e1hsVxd3OiciXJq9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzOQC/AhBhBdGJCn1o4dNSoL14amDqH1e7Rtq44sqxM=;
 b=mKphXsfHuFfOzwvEpc+YXrksH9goSgNVcx/jwahHTW4wtGX6dwKTIfA40BBwBns0l+POA+IAMCd37pDTmPkaZiHqRDJk/I0Pf1w7cugEkEEMtL25IO5AlCx9HHkm6+dlVd2fiov0NXFXpjmHP7I3OGI3Hl+kEEZepND8tl6iFPw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Tue, 3 Mar 2020 14:11:43 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:11:43 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        John Hurley <john.hurley@netronome.com>
Subject: RE: [PATCH] net: sched: fix cleanup NULL pointer exception in
 act_mirr
Thread-Topic: [PATCH] net: sched: fix cleanup NULL pointer exception in
 act_mirr
Thread-Index: AQHV8WVLBDpBKxCHmUmjTswOWXhivag26Fuw
Date:   Tue, 3 Mar 2020 14:11:43 +0000
Message-ID: <AM0PR05MB48664275E46C3C84466A61B9D1E40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200303140834.7501-1-parav@mellanox.com>
 <20200303140834.7501-3-parav@mellanox.com>
In-Reply-To: <20200303140834.7501-3-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:5121:27a4:7e98:56ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d8d78cd-347c-45d3-d4f9-08d7bf7ccd09
x-ms-traffictypediagnostic: AM0PR05MB6497:|AM0PR05MB6497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB64978B96D850ABA08CA8AEC8D1E40@AM0PR05MB6497.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(66446008)(53546011)(6506007)(52536014)(64756008)(186003)(54906003)(71200400001)(8676002)(9686003)(66556008)(81166006)(66476007)(7696005)(76116006)(81156014)(66946007)(110136005)(2906002)(5660300002)(33656002)(4744005)(86362001)(55016002)(498600001)(4326008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6497;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DvtEIdBs1aM4kPvZWHWkPdON871E7tsEbSVPccErf8tlTYNnBNpH17hilRkRHyM2xJZ01OIvxoyGpyOM41Whc1GXXR2dvXeaHIYaduBDBVazR6PeUvxuQq46YtsJsXPdg0TGGzCLGGiysgHiP1NbUSQ0g79+wTFNZDh5/tw9rpmscMVr4l8DgnuJTmf/7zqmOLcb/Z755kYYn9Smb908vILGJZRK3D9lyI8Jltg0ZS2WfkuK2XG0CJrLNvH+S04b3np7MWXUne1aO/w/COvaMxyjJtTV07m99SiApy8po/Mkaqz7kkcrX5etbaukgPwzTIWhOfP+lqWLqo7ZkVQUwk/u8WnjFy44SpfQwcurmJtTYiDTW/gs+0tldI1WHbligVdbc13sS97orZyXxKm3fs2CLTDLs24RqC9XK0sufx3/j8txCc0x2uwOxPsZToi+
x-ms-exchange-antispam-messagedata: DpIIboOtGuiyFs+BujTDrFRo1D7wpizE/MT5jWX5f87JA/iy9xSWbsXk/6jvHr8nKN9DIbxvS8eJHboDo/3mfBGsQgghnfScA8nC2iZx5/HlLqI8yp0fpS28B6cpAwpmI65ddP+lMXYX1apoMJAo7EKuOsvWWKP9Rc28Y6BNFQaf1lqwb7TC2AEYB7ld4Jc3S6nlWQuWvC2t7Zv2GlkUPw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8d78cd-347c-45d3-d4f9-08d7bf7ccd09
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:11:43.1688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InwaEvc90rxzdmJR4++uzGN/dasa1eMd4DvuJ6cfdQU1JSBaISgr534Nn7WZHAHDV9MQ3zPtXvD8IS5qllkzTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6497
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Parav Pandit <parav@mellanox.com>
> Sent: Tuesday, March 3, 2020 8:09 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> Moshe Shemesh <moshe@mellanox.com>; Vladyslav Tarasiuk
> <vladyslavt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> leon@kernel.org; John Hurley <john.hurley@netronome.com>
> Subject: [PATCH] net: sched: fix cleanup NULL pointer exception in act_mi=
rr

Please ignore the noise of this unrelated patch. Sent from wrong directory.
Sorry for the noise.
