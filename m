Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE8717474B
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgB2OS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:18:28 -0500
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbgB2OS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 09:18:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KePDrTXF16e9pi6opDAyZBeR88RbNgnOLwyNolnFQtZD8PdsudY+U04/7XMUiAQ/eytyu1/fUSwrDGHbyIfiOmGBfg8MwAyniZ+2ph0CiFxDW7PWfcvCr0aPK9xi1bIhw9BBuDkvfGLiRHnnl80+A3Jr1owKeKkDYZiIfdG3fwNb9XNfw79TzJTtHb7wdivMGWLqwoVHKRbKsTm0hKz/Lft4C11/i8diZz+d0LeF1+z2PGs0EVX23yiHr/VVyYpcVo0dCEU9tOhjufGiNR0O+p0kfJPKkOEoK6NPPtExlzL0J1BiGj0HOVGarxPiA5KPFz6oWviiqVvG711CdVplaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UFWc0Cs3KEAUlnImys8xoBl/Mq8qnqpKSiTwySbEbU=;
 b=YlRya0uCn17sMTZmbfq0AjiwcGma82tNKgnxVaDlaqjNgVZBP5/9JeXsVh2ezXvBiOGFQ2NlnC4rIpOZvd4f/qCjDhJC+NhOT4mippgyAZga/5CZXRbGBgbLoVakbhoTlOg06gDo3YSaZQBlB0bhy33LRgT8tehEo0FYWuafRizu+f2IRkpJD7Wy2Br4ZiQIRfLoHFO6NmBwNPYgkyndfMYun5axluNStmYpTKo81PHn1L2brNHnjn8Eby9vbGOo9ebNlRD9tCjqHTBAmmYiQquS0y+/tjEFhHbZiB+CGJt/perO4wQ8PA5F9bzP7E9DUKDG2umeqTU9dm8Q15JwlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UFWc0Cs3KEAUlnImys8xoBl/Mq8qnqpKSiTwySbEbU=;
 b=OdSu0cQZXBC72iW1Ed7c0+WOwDf6U+GZIoDE2Q8/uRtMlhst1SSbytVPn+LtNycN4fs7VW0jnx4+yryCbZh5dQ4/bpQ5bE3cMNebzY4IDRh/1doiRADvalnWsXM811dnxKXT2GvXbwMFQoQOwHh7PVyUcsOdT6DqXB8yOZ5U+Ro=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6182.eurprd05.prod.outlook.com (20.178.94.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Sat, 29 Feb 2020 14:18:22 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.018; Sat, 29 Feb 2020
 14:18:22 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
Thread-Topic: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
Thread-Index: AQHV6j7PiZxqrDuXxUqjtd5mQU+zuKgyQNQT
Date:   Sat, 29 Feb 2020 14:18:22 +0000
Message-ID: <AM6PR05MB5096E1B2D9F7B8DF3FA97A65CFE90@AM6PR05MB5096.eurprd05.prod.outlook.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>,<1582458307-17067-7-git-send-email-paulb@mellanox.com>
In-Reply-To: <1582458307-17067-7-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-originating-ip: [5.29.240.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b8a328f-865b-4a9a-a007-08d7bd223bd9
x-ms-traffictypediagnostic: AM6PR05MB6182:|AM6PR05MB6182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6182EEE60726800114DE7429CFE90@AM6PR05MB6182.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 03283976A6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(189003)(199004)(5660300002)(64756008)(66446008)(8936002)(66946007)(66556008)(66476007)(86362001)(110136005)(8676002)(76116006)(558084003)(52536014)(81156014)(81166006)(7696005)(33656002)(6506007)(316002)(2906002)(26005)(9686003)(478600001)(55016002)(6636002)(186003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6182;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pojay8oQSzNCvA52rLhYwiFsUW+XAx7Vx+/40VzwrqM+e8MbWNtr9mDryHijsc9OKHzlLDEvf5JhRwkdI5kL1lnK8vHlBX+KaxBiQC+i8DBD/bp4oAQ6I0Hc5zMzLZ+X4oVVda8Iv6NYhOvpv6zc23nW1lNxRC+Eho+rxBLoI2v7t+X0uD6pMLxmpE/4Ga0hPwauXUBurEJ4tkssNc/XGigCw3LmkV/E5CSzJ83UUTwFhX7ZeIy0EUEJWnTScF63+4IN2oyI6hloyFz0kdxl6sHDCDX2AYTX9sdfT9Q6RttWJ9Sa+u6e34nbqc53opmFQ0g/VWRL1tA/vbPHog8OhsqBnCMtmd5ek2s1anzHa8b4pqua4HTawcsV230llsQb3qonrj92lrWJYEB84+q6x61XC/vi1UtC9lXM/sN04bAhzxZd/YnnjLe3sX2/NVd6
x-ms-exchange-antispam-messagedata: kdeatWGt14iSewAB2cPlVQICsF4A8E9SMcKguEGxiSGHZOxHe51coicAH0sX2o4a0xHclQhoE2nTXGR00jxo5EDxqDAKuWhSzSdZytutsXQn/mx5AB+bVDIeUildEI52TmMknygPSzvqTNbOUxnzkw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8a328f-865b-4a9a-a007-08d7bd223bd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2020 14:18:22.4901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9F5Kgca9Nj9pRSke5AVAreoRxiYoqvX/nVpcXU92Rxe35KMdW5VnRAd/16thHCPyqkSw5ZDiKpiFK0WkBSNqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will be sending v2 shortly, thanks for the comments=
