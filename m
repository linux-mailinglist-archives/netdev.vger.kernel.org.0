Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5CE18DDC6
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 04:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCUDIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 23:08:40 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:60836
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727158AbgCUDIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 23:08:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D07qnw/kfUXTXqYZjnMrQagefw9IH1fB8Zc1IxP02+vRwbDLwyh6KYcjgtoXk9jhi/DGIWbqLehtL9lekB8+0mRX9KBmuRbueK3rqs0e8e9IYBNk5WF11EuiuNJaZgcLzSY0AXgf2PpGiAkLeQWia6mQkP61Li0g4QkCmYCEPYLSxQLATjDpHRn13isCJph73x0B2PW+eaY9BVFpfBjhi8DpEt+AuWgot3PhP7zp+nR8e+ORJsxrpDrHAnapiFe0lT4DxnWoEeaGoYvjKPxr/Cb5uH+D8OlTvU8t3fFsQB3k6K+7GS0x+JKa9+59by/OF5gp/FAugp5ysLnaSYjfiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnR66NA74rgnV531NZ5tEBDYkjItTD4Q3bXQd4BIJ90=;
 b=ElwH4GwYwWuTmLOLweSARUDg+6FkamwLveOop4EhpEC2Chj/X8BwiQJvttlnB/6TQ4NVk7b9O5zGeS4xciGSq9znwtjcaGfv01hQ7dBZWZ+swej+r0Wgr7sh5EbbH5DE7gUQfbrqSlLW0loA6+59Xl8WRgJ+0fDh1Rvsz1tbQfUrWCuK4XU6+f5L4yA5xZ2HeuJHpKbiXKOq1UGAzbhJcOfeFKmRuKKg+B2i63X77BYPtUTzrhs8Gu6JXJJw4+ntu3Mn8hk6/rkTwWJ2iGA8plEWtiEZpmL9VMa5IUQWJXUhA897qBOCjcqn8tWw8a9Lb+GLW2fsVwwK+bfuBN2mFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnR66NA74rgnV531NZ5tEBDYkjItTD4Q3bXQd4BIJ90=;
 b=Z7XMFs51lhKASq/ROhseH3LIR1RW71i2bgAkySOqiEsWNYZuZg3Hos8YuGGnJv942h812rInubwpr5p2ZkbtXlWx9SV8mtcFy85tSlYNzKWaXTr/bhWMXxdDQV9PdLP4bAOf3TKuQm/B/eeeWYn1M5VO8sNMD8RF28N+wy6G/aU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7102.eurprd05.prod.outlook.com (20.181.33.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Sat, 21 Mar 2020 03:08:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 03:08:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: remove duplicated check chain_index in
 mlx5e_rep_setup_ft_cb
Thread-Topic: [PATCH] net/mlx5e: remove duplicated check chain_index in
 mlx5e_rep_setup_ft_cb
Thread-Index: AQHV/QRuXlHzOpdIa0GIfmgabwS+dqhSYZWA
Date:   Sat, 21 Mar 2020 03:08:35 +0000
Message-ID: <94862dacbf640516896f81a6ec2151b542b7505d.camel@mellanox.com>
References: <1584522343-5905-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1584522343-5905-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 659740c3-22d5-499f-fb2c-08d7cd452576
x-ms-traffictypediagnostic: VI1PR05MB7102:
x-microsoft-antispam-prvs: <VI1PR05MB71022BB702A1A81A536409A8BEF20@VI1PR05MB7102.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(199004)(558084003)(71200400001)(26005)(86362001)(76116006)(5660300002)(66946007)(6506007)(2906002)(6512007)(186003)(91956017)(6486002)(36756003)(66476007)(66556008)(81166006)(81156014)(8676002)(316002)(4326008)(64756008)(2616005)(6916009)(66446008)(8936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7102;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q0BMdTmOyiQ8KQpHv0VPyz6Y6Z92e1nUD8vQtCj3jvm+0A8y3i4SrUIdGZ8CWaKGL7SrownL304UXKXu9/WZH5n4XbpsLOl3nyF2A3Jazsce8yF8eCsQSF4q3AdMvoYBmjyk9zTvarwZcjy5rU33WwrUvnB+imiIUCSXWeS46XPT10WNTpiAtpu2vAA5TkBmng/TPLgOvPp6np1nLTbSbPVz11q9hDVknWlQ9vRIdqkPeVdbZPnb0oLKMB8Nnit6W6PZBWuiNxrarajHwvzSiI/TRenCdhP6sJwi7pWs3EPcD4rBLPoygfFDuDZwWihUZnXuVvDK5W+uKENnuhDF5vUAKvdY9aOR21LLW8TRbMk5wNs5QBm977G3jtaKpYpga+uQjsoRYvpOuDDPZCXMtP82fQnc9G+vnqxXUG52DGLBIeQ0qbagwmiT5GHNFIE2
x-ms-exchange-antispam-messagedata: qSD94LmNded5wNUia+qSoK/ibWbZQj6GTNmf1cIPSMiBSnUd0mVsGoUwtEd9a7WwPbLmfxaxe4+uR+8YR6thUlV8t0jm8s7ypIeS2F+j6vE/ZdBon/xUf9Y0FWjPEob1AHgfvZ9cPL0PZOcqYIKOBg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB29F7F81727074E886709F62D632855@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 659740c3-22d5-499f-fb2c-08d7cd452576
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 03:08:35.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Jbpszo00JpBfat3kae7Wjs/LDr+0zZwtwpaMxq7bonAThfusuew39fk4Jf3FpBcVRNG18NKd63jns3E3q9cTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTE4IGF0IDE3OjA1ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBUaGUgZnVuY3Rpb24gbWx4
NWVfcmVwX3NldHVwX2Z0X2NiIGNoZWNrIGNoYWluX2luZGV4IGlzIHplcm8gdHdpY2UuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiAtLS0NCg0KQXBwbGll
ZCB0byBuZXQtbmV4dC1tbHg1DQoNClRoYW5rcy4NCg0K
