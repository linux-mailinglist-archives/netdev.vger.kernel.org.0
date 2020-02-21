Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF1168925
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgBUVS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:18:56 -0500
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:27874
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbgBUVSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:18:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3IQ2wKBnanBSOC5OpHhH1kiQGBTxV2Fhu9w0ezsfnG8+jSzQ4k8t13nYCjwoH018kjjZnOB2ElIdsXRoYeEViqOgRikcdza+FPaHp3oJqA0at7immKiACRgyE2mej/h3IWMOJnTCGA2DHl1ACBMJ6UOA3qMWVriboJZaE+lnY+wbhsmfXK6bWQdIGvPiJAd2QO+RM2itDN5/9b5ApmYyyiQbZq9te0SgldYBQ88+0tetLUWmlLw/W6eTJTlcWDq2bTMwlcvqaSOaW3Ro5R6njLudYIyj75QkpC6oLR5frXS5P/zkaP1qBikJNlasH2ztZnfAEYvzAZZNMSHu6bvVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylySu8SNz5xzwJ1nUeCiylVqkldI7YdMgzthFSn9zSM=;
 b=MfGzZC81KydXhszmfXyaSJXdemIGGmvUAcjwFIzaNhBxL/fmdq5V/B9pCyvcSkXqOYfMIqvl3CKMXvE5k66WBLl5FHn2lvG9sV7QZsmMN2yPdUaaP9i21rsx9oI4puj1w4V+wtpf+vr423cmhmxgzvQHofUQhWuQSmzyIfGbrukJvaXhywTBxXKHJorH8r2r872OjGJA26F+Udc4famhnoO4vIrP7wh4XBpJsy07N58BHS49jrucXe/2MfgX3ccDKCFLPSDs+wcmOfRQxEIaoUFHkULLyoWwN8M1euJgydK2QYMZ2mYze8OJ7jJcvDI7x7Gf2yRnK4C7XoGPCwiwmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylySu8SNz5xzwJ1nUeCiylVqkldI7YdMgzthFSn9zSM=;
 b=iucAm4bnp6fRCS+eI00TcvN4CE1Shzg2dZzJtky0LD2cWtAxuMl3WuUT97DcjpswlZjieyfgl8nFcSJEpNFwQSvCr+zSD9xcKb7TmetHM9c/Zj82FsYWvB9WAwrPmjKx/QgqIzXlKhPHEtCYj/+SCFnux/G2qH+QRJ/h1CtNUVU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5455.eurprd05.prod.outlook.com (20.177.63.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 21 Feb 2020 21:18:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:18:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 6/7] net/mlxfw: Add reactivate flow support to
 FSM burn flow
Thread-Topic: [PATCH net-next 6/7] net/mlxfw: Add reactivate flow support to
 FSM burn flow
Thread-Index: AQHV55UUl3+0pqx360O1hrNERl4EzagjnIMAgAKNT4A=
Date:   Fri, 21 Feb 2020 21:18:51 +0000
Message-ID: <530b50907a437d22eefdf1c26a35cf2dce373afb.camel@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
         <20200220022502.38262-7-saeedm@mellanox.com>
         <20200219222026.296b3780@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200219222026.296b3780@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98d8aaed-1c3e-4da9-4475-08d7b713a664
x-ms-traffictypediagnostic: VI1PR05MB5455:|VI1PR05MB5455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5455450246A683416F3B4795BE120@VI1PR05MB5455.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(199004)(189003)(81166006)(66446008)(71200400001)(8676002)(64756008)(66476007)(66556008)(8936002)(4326008)(2906002)(81156014)(36756003)(2616005)(66946007)(5660300002)(26005)(6916009)(6486002)(478600001)(91956017)(558084003)(6512007)(316002)(186003)(86362001)(54906003)(76116006)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5455;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zvud7Wrm0AQ/VbsMrSIHQxZvbqiCyIgkR4OnS2ZRQyPMpONg7Y06pOJ8tAHNv2M/OqRb1RzIl9hQiT7wRzl+Tjqzrl3SqAOS21ObzWdkTGBIw3WRf3gFs4p6tPyk0lA29XfoutFDN0lCzjWA8GmGhVHslsLzF06vR99zNIFOVJM/tD6i0GInROoSO2GS8zt+isBHQI9xV7TYgR/yaoeB6fJbfSf4vFuPbGibwvtjnoGRqqnmqrnMgf3C+sldmPCbbPUyNr+IGeqt+WTAR4yJL+q2hUZpsHhjJVm1h1wAy/M8crailGN8QKqhFIpIyZ7/zFp/keznZYEV3Z5KqCwp1JfwlWDPiBIZqu4b7CYvVRUeN5T35Lbn6NrQXTw7T2kjCQcl23EcFJOZDGRJWMmEVlCLJw+OsMu1rcT2dnM+VoqHZIDiFpde+F0aNe4UQldR
x-ms-exchange-antispam-messagedata: DOZHNt4BvL036mTyYGidyY16eKVS4bEAuF7BJfJikCV4y/li6E2NgUXhOhzwATnJbloeMGD+Yas1e2F9WYEk2Ms/8U6pRF746yPMumB8qwcUxfz1oWhGzWKjBd9S7P4tRx81FoLUYdJ8wD22e8d6ZA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <254FC49A1CAE9B45ACC2F8EB55C04448@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d8aaed-1c3e-4da9-4475-08d7b713a664
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:18:51.9185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwJRgpQsjNXkZzIcDHubXLr9k1vSwP4YRI/F/clMUphHHZgFsBlnCDH/nM6GMUvtdTRY+4WLKaHGBMu8AKAFGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5455
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAyLTE5IGF0IDIyOjIwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMCBGZWIgMjAyMCAwMjoyNTo1NSArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiArCQkJCSAgICAgICJGU00gY29tcG9uZW50IHVwZGF0ZSBmYWlsZWQsIEZXDQo+ID4g
cmVhY3RpdmF0ZSBpcyBub3Qgc3VwcG9lcnRlZCIsDQo+IA0KPiBzdXBwb3J0ZWQNCg0KVGhhbmtz
ICEgd2lsbCBmaXggdGhpcy4NCg==
