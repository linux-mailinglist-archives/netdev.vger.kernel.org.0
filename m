Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44520163A65
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 03:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgBSCnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 21:43:14 -0500
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:6111
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727187AbgBSCnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 21:43:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQkgqPMEe01rmJQdr7shVPT6jEgEEr9rvTL2x5kB1O2DuQzqkEHqm1t0NsJOSQK3wHB/bwXsqGu4f6XTj3D6rjPs5clvTxn9ZCEj7RzPq7RZJ1bTTqrD41Wl5Ips6SH+NF7BeLffTnebG1Y00/R1WridfRrLeuUw1iMFMv3DfmMLx0US3lBJRBxUedha3OvcsJC/PKwQjJBfo7q8+LZJlp1lLySxVLCaClgWGxkNDb4mzoj4M+8seUf1OozSm4OpZ1ljEl5qkhNtMF0GpWt7AbsqdHOELGztIEbTrshZg9WV1slLIQe3B1ptk6ehO/o8UP7FwCQf60ru/1m3IJ10UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdhQ4Lh3ATXAUmc2EAJHVwC7BO5iK+Oyr31sAQp/L8Q=;
 b=kApvWzlyNgE7ZlCtAXhSRR+0Wo8c7xyGpOJ8ol5M9LkIPn6Gvr3xX9QbAEgImt3XBOGuWbN0N0uitz2dMh/rrrI5Gfk//LGM8bmNyVgvKyRl8KmAJKMKWvOcXLk/qGlNH74PeEUwilEXtQl3REHv/W3/a0xexsM1YORGTQwl7qqr2MNoL+hmJ001Lw3+qC6nSsjl1G/1p3mMliD7t3W/BL1TtHZHyYEM10CJLaFWAinPUsLPD1jL/w3k4e80qXKFhGP0iFNpqaEGFEBBTt9H5Q3GXy7Wh7shWkzeJn6iC+jVJ5GJymb9YqrhfFBckiVzzI498rX2Tp1jJ6Q4DkC9eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdhQ4Lh3ATXAUmc2EAJHVwC7BO5iK+Oyr31sAQp/L8Q=;
 b=DkWitlGzqUiBrgfUgw7sK4Qzy6odAfbsuV+NHH0UTF7EEmV3aP4az/CPG7gXyp23IJRz+fz06cRwYi5T7TzrNTulIBQ9aKcVidnrEioORIz720gJzHCFmCireKeKfZzlQmct0sxPNyOHgdMpIuMxKY5IonKvQmo+juFOX6HUlGs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6240.eurprd05.prod.outlook.com (20.178.122.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 19 Feb 2020 02:43:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 02:43:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Oz Shlomo <ozsh@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v3 00/16] Handle multi chain hardware misses
Thread-Topic: [PATCH net-next v3 00/16] Handle multi chain hardware misses
Thread-Index: AQHV5LAnyud6kwbVa0i6QDoYOjJZc6gh0z6A
Date:   Wed, 19 Feb 2020 02:43:08 +0000
Message-ID: <41b34b364a2656a6f3e37ba256161de477e7881d.camel@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2321bff0-4923-4e88-f8c1-08d7b4e57454
x-ms-traffictypediagnostic: VI1PR05MB6240:|VI1PR05MB6240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB62409B92504C05C2E790FE1DBE100@VI1PR05MB6240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(8936002)(26005)(186003)(8676002)(81166006)(81156014)(6486002)(6636002)(71200400001)(6512007)(6506007)(5660300002)(86362001)(4744005)(66556008)(2906002)(478600001)(2616005)(66946007)(64756008)(66446008)(91956017)(316002)(110136005)(76116006)(66476007)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6240;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQ+Mcy38FmBhCl0JvOE8D/4f1sPEcgKdX789yLPliYrLqUIkJ8FK4LdLge2mC/QZ2veoJYRe/gNDH2NMNrx2XxEbseEF0zs4VvIhpo3FpQsHiFUlci4C7fveGvO/hKfZlgHNdg6X8TY6AxStNYOHG2GKtjQZxUJIpUHcbaGVWVSC6rR0yDC0di4WnYoNoarVuF03ObxbeSNalC59p1VdbKoLVK0ggmirABxE7gUw11foqXJoAo9Bdkej2Fd3+dX6JaqVr3QEyah8d2yyxIfcVv2xRQYwECfCsB6F1nlFRn8Kpyms1mTJjzPgNvUopV5eAPfeqnTEeubB51UuZNDKfmAxi8CybrVXsnZX9vrSmf4pVZeeOAlMdhcw5YPKd5skT/7mbWn9JGdYfPpYJPE1sCF9392KwjKoAmPLrSjOuIYq+rtzzDTcmHGqzbryOeJu
x-ms-exchange-antispam-messagedata: UhN9F3kHtuePVEfGxru9VMiAwjMxfXMLbjNeDdPNh+p2l2SrpLt4j7tQpkPKqiZK2XI+1eOEEHrqSMslBgHguzBQihcPtKXU0gtRKhHUqOKtlA5ckG+vpbJblhXTslwku5JCh4xcNr0dVOaskyU77w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6EA6785F08A5F41A7A94B1CF1E68EA0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2321bff0-4923-4e88-f8c1-08d7b4e57454
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 02:43:08.6142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zU0xLlZVc276u+vAjQghlawl/xlbmMqUDqLyPRF5qkzEyfRUymG0s+H7QF44j7qxVycpy67ypxXU6hTNdYFZWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAyLTE2IGF0IDEyOjAxICswMjAwLCBQYXVsIEJsYWtleSB3cm90ZToNCj4g
SGkgRGF2aWQvSmFrdWIvU2FlZWQsDQo+IA0KPiBUQyBtdWx0aSBjaGFpbiBjb25maWd1cmF0aW9u
IGNhbiBjYXVzZSBvZmZsb2FkZWQgdGMgY2hhaW5zIHRvIG1pc3MgaW4NCj4gaGFyZHdhcmUgYWZ0
ZXIganVtcGluZyB0byBzb21lIGNoYWluLiBJbiBzdWNoIGNhc2VzIHRoZSBzb2Z0d2FyZQ0KPiBz
aG91bGQNCj4gY29udGludWUgZnJvbSB0aGUgY2hhaW4gdGhhdCB3YXMgbWlzc2VkIGluIGhhcmR3
YXJlLCBhcyB0aGUgaGFyZHdhcmUNCj4gbWF5IGhhdmUNCj4gbWFuaXB1bGF0ZWQgdGhlIHBhY2tl
dCBhbmQgdXBkYXRlZCBzb21lIGNvdW50ZXJzLg0KPiANCg0KWy4uLl0NCg0KPiBOb3RlIHRoYXQg
bWlzcyBwYXRoIGhhbmRsaW5nIG9mIG11bHRpLWNoYWluIHJ1bGVzIGlzIGEgcmVxdWlyZWQNCj4g
aW5mcmFzdHJ1Y3R1cmUNCj4gZm9yIGNvbm5lY3Rpb24gdHJhY2tpbmcgaGFyZHdhcmUgb2ZmbG9h
ZC4gVGhlIGNvbm5lY3Rpb24gdHJhY2tpbmcNCj4gb2ZmbG9hZA0KPiBzZXJpZXMgd2lsbCBmb2xs
b3cgdGhpcyBvbmUuDQo+IA0KDQpIaSBEYXZlLCANCg0KQXMgd2FzIGFncmVlZCwgaSB3aWxsIGFw
cGx5IHRoaXMgc2VyaWVzIGFuZCB0aGUgdHdvIHRvIGZvbGxvdyB0byBhIHNpZGUNCmJyYW5jaCB1
bnRpbCBhbGwgdGhlIGNvbm5lY3Rpb24gdHJhY2tpbmcgb2ZmbG9hZHMgcGF0Y2hzZXRzIGFyZSBw
b3N0ZWQNCmJ5IFBhdWwgYW5kIHJldmlld2VkL2Fja2VkLg0KDQppbiBjYXNlIG9mIG5vIG9iamVj
dGlvbiBpIHdpbGwgYXBwbHkgdGhpcyBwYXRjaHNldCB0byBhbGxvdyBQYXVsIHRvDQptb3ZlIGZv
cndhcmQgd2l0aCB0aGUgb3RoZXIgdHdvIGNvbm5lY3Rpb24gdHJhY2tpbmcgcGF0Y2hzZXRzLg0K
DQpUaGFua3MsDQpTYWVlZC4gDQo=
