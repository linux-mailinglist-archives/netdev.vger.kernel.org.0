Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F615597A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfFYU5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:57:36 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:20873
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbfFYU5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:57:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=IWw05QYsjLbyn3a+m78C3YWXnndsCv4NVmaBxrdpDs/YF8dhlpeXO5qE8oFRgiiwUTa5lJdgoYRDxhMvYmt1wIlnXor8NlKWy+JCHdMNkaHfWaH7zkY5ZMqPNNUTjsowk8hFQiTTM736RjLCXTWdN6DNf/5IBwXJJ6f+knlqu04=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBb+jjSr3CRXGRfR0L5n1mi0Hn9xoK8H7N+IBR70S1o=;
 b=BeVGrQyPvkQY+JpQQZglVv8qAAkGUOVegyp/oYHAebXD/oajZbeCktDa+5MbNeJH4XIhd8OMJQtfYJUvxHWysLWoFIlpFKVPc3FZxUt1fSxbYHPSdrzy27oeR2kxPilUlx8QzGghqSJRlFXH3Mg/FKukucv94rR1zPE+2ZwcojY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBb+jjSr3CRXGRfR0L5n1mi0Hn9xoK8H7N+IBR70S1o=;
 b=NqpsTzXOzDbZJFSbXpx7PPkLaDPF2ThqFwaGz/bErrvgvxFwM59tICyi5dYCiTN6oBN0YHrKw2kZ8KfqKTpJ5349GCnWCxqnPJ2k/cu82yaI4WBFpgmkGDlUFjoTrOlFTWn7QPfK6QN5zbaqb9jzbti81PDcs53thKBVrgz544w=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2696.eurprd05.prod.outlook.com (10.172.225.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 20:57:27 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 20:57:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][for-next V2 0/7] Generic DIM lib for netdev and RDMA
Thread-Topic: [pull request][for-next V2 0/7] Generic DIM lib for netdev and
 RDMA
Thread-Index: AQHVK5iYkivo34mkiUCAxIaWOP9/Xg==
Date:   Tue, 25 Jun 2019 20:57:27 +0000
Message-ID: <20190625205701.17849-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc3aa3c2-b809-4651-b541-08d6f9afbaed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2696;
x-ms-traffictypediagnostic: DB6PR0501MB2696:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2696E738BA511604AEFCFE13BEE30@DB6PR0501MB2696.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(6512007)(66476007)(186003)(86362001)(305945005)(3846002)(26005)(6116002)(68736007)(7736002)(102836004)(50226002)(99286004)(14444005)(53936002)(6636002)(1076003)(2906002)(5660300002)(6436002)(64756008)(14454004)(66556008)(25786009)(486006)(6306002)(52116002)(73956011)(71190400001)(6486002)(6506007)(81166006)(71200400001)(386003)(66946007)(256004)(81156014)(66446008)(478600001)(4326008)(66066001)(8676002)(107886003)(2616005)(36756003)(316002)(476003)(8936002)(110136005)(54906003)(41533002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2696;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sg8sD6sLh489xc70wbIswVuQU8SE5g0DvJ6dTdFlbnl0ZXidaVGzNkglgK4NkKGHpPd8n2Sg92Q7yJR9GnePPxlWXcxXbeYxMAdQevyJa8OMj2F/lNBsgxesIR5EqazgeT5rzz0AE3JztQcxjuIKkn6Cc6TINc1BRcs4avs6pXtV+jwFSTayvtODrF9hE81zdmNsY0xVqmTN5KaYUEfUkYH3uIaj7ethpU18pyt4IjYEF0dTmz9ud/3kahGwmQMdm8sY60huDsgRuf2Vqo4K9c1TnJaV8bCLP/8sc4d3D/5d21iX/lRdBVwknDjJoAKvfTgmLdkmHCYz86UxGC1nRL4Bc+4EMyxzVXE7R6VNLOH12AiCwOr6HC3jFgxiugoGfyDe1RrGnWhsKIxsZ4zPnPBjDNXT0mM+EgqtOXJ/mC8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3aa3c2-b809-4651-b541-08d6f9afbaed
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 20:57:27.5091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwgRG91ZyAmIEphc29uDQoNClRoaXMgc2VyaWVzIGltcHJvdmVzIERJTSAtIER5bmFt
aWNhbGx5LXR1bmVkIEludGVycnVwdA0KTW9kZXJhdGlvbi0gdG8gYmUgZ2VuZXJpYyBmb3IgbmV0
ZGV2IGFuZCBSRE1BIHVzZS1jYXNlcy4NCg0KRnJvbSBUYWwgYW5kIFlhbWluOg0KDQpGaXJzdCA3
IHBhdGNoZXMgcHJvdmlkZSB0aGUgbmVjZXNzYXJ5IHJlZmFjdG9yaW5nIHRvIGN1cnJlbnQgbmV0
X2RpbQ0KbGlicmFyeSB3aGljaCBhZmZlY3Qgc29tZSBuZXQgZHJpdmVycyB3aG8gYXJlIHVzaW5n
IHRoZSBBUEkuDQoNClRoZSBsYXN0IDMgcGF0Y2hlcyBwcm92aWRlIHRoZSBSRE1BIGltcGxlbWVu
dGF0aW9uIGZvciBESU0uDQpUaGVzZSBwYXRjaGVzIGFyZSBpbmNsdWRlZCBpbiB0aGlzIHB1bGwg
cmVxdWVzdCBhbmQgdGhleSBhcmUgcG9zdGVkDQpmb3IgcmV2aWV3IHZpc2liaWxpdHkgb25seSwg
dGhleSB3aWxsIGJlIGhhbmRsZWQgYnkgdGhlIHJkbWEgdHJlZSBsYXRlcg0Kb24gaW4gdGhpcyBr
ZXJuZWwgcmVsZWFzZS4NCg0KRm9yIG1vcmUgaW5mb3JtYXRpb24gcGxlYXNlIHNlZSB0YWcgbG9n
IGJlbG93Lg0KDQpPbmNlIHdlIGFyZSBhbGwgaGFwcHkgd2l0aCB0aGUgc2VyaWVzLCBwbGVhc2Ug
cHVsbCB0byBuZXQtbmV4dCBhbmQNCnJkbWEtbmV4dCB0cmVlcy4NCg0KdjEgZm9yIHJlZmVyZW5j
ZTogDQooaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtbmV0ZGV2Jm09MTU1OTc3NzA4MDE2MDMw
Jnc9MikNCg0KQ2hhbmdlcyBzaW5jZSB2MjoNCi0gYWRkZWQgcGVyIGliIGRldmljZSBjb25maWd1
cmF0aW9uIGtub2IgZm9yIHJkbWEtZGltIChTYWdpKQ0KLSBhZGQgTkwgZGlyZWN0aXZlcyBmb3Ig
dXNlci1zcGFjZSAvIHJkbWEgdG9vbCB0byBjb25maWd1cmUgcmRtYSBkaW0gKFNhZ2kvTGVvbikN
Ci0gdXNlIG9uZSBoZWFkZXIgZmlsZSBmb3IgRElNIGltcGxlbWVudGF0aW9ucyAoTGVvbikNCi0g
dmFyaW91cyBwb2ludCBjaGFuZ2VzIGluIHRoZSByZG1hIGRpbSByZWxhdGVkIGNvZGUgaW4gdGhl
IElCIGNvcmUgKExlb24pDQotIHJlbW92ZWQgdGhlIFJETUEgc3BlY2lmaWMgcGF0Y2hlcyBmb3Jt
IHRoaXMgcHVsbCByZXF1ZXN0XA0KDQpUaGFua3MsDQpTYWVlZC4NCg0KLS0tDQpUaGUgZm9sbG93
aW5nIGNoYW5nZXMgc2luY2UgY29tbWl0IGNkNmM4NGQ4ZjBjZGM5MTFkZjQzNWJiMDc1YmEyMmNl
M2M2MDViMDc6DQoNCiAgTGludXggNS4yLXJjMiAoMjAxOS0wNS0yNiAxNjo0OToxOSAtMDcwMCkN
Cg0KYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoNCiAgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xpbnV4LmdpdCB0YWdz
L2Jsay1kaW0tdjINCg0KZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVwIHRvIDM5OGMyYjA1YmJl
ZTIxY2MxNzJkZmZmMDE3YzAzNTFkNGQxNGUwNGM6DQoNCiAgbGludXgvZGltOiBBZGQgY29tcGxl
dGlvbnMgY291bnQgdG8gZGltX3NhbXBsZSAoMjAxOS0wNi0yNSAxMzo0Njo0MCAtMDcwMCkNCg0K
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KR2VuZXJpYyBESU0NCg0KRnJvbTogVGFsIEdpbGJvYSBhbmQgWWFtaW4gRnJpZG1h
bg0KDQpJbXBsZW1lbnQgbmV0IERJTSBvdmVyIGEgZ2VuZXJpYyBESU0gbGlicmFyeSwgYWRkIFJE
TUEgRElNDQoNCmRpbS5oIGxpYiBleHBvc2VzIGFuIGltcGxlbWVudGF0aW9uIG9mIHRoZSBESU0g
YWxnb3JpdGhtIGZvcg0KZHluYW1pY2FsbHktdHVuZWQgaW50ZXJydXB0IG1vZGVyYXRpb24gZm9y
IG5ldHdvcmtpbmcgaW50ZXJmYWNlcy4NCg0KV2Ugd2FudCBhIHNpbWlsYXIgZnVuY3Rpb25hbGl0
eSBmb3Igb3RoZXIgcHJvdG9jb2xzLCB3aGljaCBtaWdodCBuZWVkIHRvDQpvcHRpbWl6ZSBpbnRl
cnJ1cHRzIGRpZmZlcmVudGx5LiBNYWluIG1vdGl2YXRpb24gaGVyZSBpcyBESU0gZm9yIE5WTWYN
CnN0b3JhZ2UgcHJvdG9jb2wuDQoNCkN1cnJlbnQgRElNIGltcGxlbWVudGF0aW9uIHByaW9yaXRp
emVzIHJlZHVjaW5nIGludGVycnVwdCBvdmVyaGVhZCBvdmVyDQpsYXRlbmN5LiBBbHNvLCBpbiBv
cmRlciB0byByZWR1Y2UgRElNJ3Mgb3duIG92ZXJoZWFkLCB0aGUgYWxnb3JpdGhtIG1pZ2h0DQp0
YWtlIHNvbWUgdGltZSB0byBpZGVudGlmeSBpdCBuZWVkcyB0byBjaGFuZ2UgcHJvZmlsZXMuIFdo
aWxlIHRoaXMgaXMNCmFjY2VwdGFibGUgZm9yIG5ldHdvcmtpbmcsIGl0IG1pZ2h0IG5vdCB3b3Jr
IHdlbGwgb24gb3RoZXIgc2NlbmFyaW9zLg0KDQpIZXJlIHdlIHByb3Bvc2UgYSBuZXcgc3RydWN0
dXJlIHRvIERJTS4gVGhlIGlkZWEgaXMgdG8gYWxsb3cgYSBzbGlnaHRseQ0KbW9kaWZpZWQgZnVu
Y3Rpb25hbGl0eSB3aXRob3V0IHRoZSByaXNrIG9mIGJyZWFraW5nIE5ldCBESU0gYmVoYXZpb3Ig
Zm9yDQpuZXRkZXYuIFdlIHZlcmlmaWVkIHRoZXJlIGFyZSBubyBkZWdyYWRhdGlvbnMgaW4gY3Vy
cmVudCBESU0gYmVoYXZpb3Igd2l0aA0KdGhlIG1vZGlmaWVkIHNvbHV0aW9uLg0KDQpTdWdnZXN0
ZWQgc29sdXRpb246DQotIENvbW1vbiBsb2dpYyBpcyBpbXBsZW1lbnRlZCBpbiBsaWIvZGltL2Rp
bS5jDQotIE5ldCBESU0gKGV4aXN0aW5nKSBsb2dpYyBpcyBpbXBsZW1lbnRlZCBpbiBsaWIvZGlt
L25ldF9kaW0uYywgd2hpY2ggdXNlcw0KICB0aGUgY29tbW9uIGxvZ2ljIGluIGRpbS5jDQotIEFu
eSBuZXcgRElNIGxvZ2ljIHdpbGwgYmUgaW1wbGVtZW50ZWQgaW4gImxpYi9kaW0vbmV3X2RpbS5j
Ii4NCiAgVGhpcyBuZXcgaW1wbGVtZW50YXRpb24gd2lsbCBleHBvc2UgbW9kaWZpZWQgdmVyc2lv
bnMgb2YgcHJvZmlsZXMsDQogIGRpbV9zdGVwKCkgYW5kIGRpbV9kZWNpc2lvbigpLg0KLSBESU0g
QVBJIGlzIGRlY2xhcmVkIGluIGluY2x1ZGUvbGludXgvZGltLmggZm9yIGFsbCBpbXBsZW1lbnRh
dGlvbnMuDQoNClByb3MgZm9yIHRoaXMgc29sdXRpb24gYXJlOg0KLSBaZXJvIGltcGFjdCBvbiBl
eGlzdGluZyBuZXRfZGltIGltcGxlbWVudGF0aW9uIGFuZCB1c2FnZQ0KLSBSZWxhdGl2ZWx5IG1v
cmUgY29kZSByZXVzZSAoY29tcGFyZWQgdG8gdHdvIHNlcGFyYXRlIHNvbHV0aW9ucykNCi0gSW5j
cmVhc2VkIGV4dGVuc2liaWxpdHkNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KVGFsIEdpbGJvYSAoNik6DQogICAgICBs
aW51eC9kaW06IE1vdmUgbG9naWMgdG8gZGltLmgNCiAgICAgIGxpbnV4L2RpbTogUmVtb3ZlICJu
ZXQiIHByZWZpeCBmcm9tIGludGVybmFsIERJTSBtZW1iZXJzDQogICAgICBsaW51eC9kaW06IFJl
bmFtZSBleHRlcm5hbGx5IGV4cG9zZWQgbWFjcm9zDQogICAgICBsaW51eC9kaW06IFJlbmFtZSBu
ZXRfZGltX3NhbXBsZSgpIHRvIG5ldF9kaW1fdXBkYXRlX3NhbXBsZSgpDQogICAgICBsaW51eC9k
aW06IFJlbmFtZSBleHRlcm5hbGx5IHVzZWQgbmV0X2RpbSBtZW1iZXJzDQogICAgICBsaW51eC9k
aW06IE1vdmUgaW1wbGVtZW50YXRpb24gdG8gLmMgZmlsZXMNCg0KWWFtaW4gRnJpZWRtYW4gKDEp
Og0KICAgICAgbGludXgvZGltOiBBZGQgY29tcGxldGlvbnMgY291bnQgdG8gZGltX3NhbXBsZQ0K
DQogTUFJTlRBSU5FUlMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
IDMgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9LY29uZmlnICAgICAgICAgICAg
ICB8ICAgMSArDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYmNtc3lzcG9ydC5jICAg
ICAgICAgfCAgMjAgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9iY21zeXNwb3J0
LmggICAgICAgICB8ICAgNCArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQv
Ym54dC5jICAgICAgICAgIHwgIDEyICstDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20v
Ym54dC9ibnh0LmggICAgICAgICAgfCAgIDQgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9h
ZGNvbS9ibnh0L2JueHRfZGVidWdmcy5jICB8ICAgNiArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL2JueHQvYm54dF9kaW0uYyAgICAgIHwgICA5ICstDQogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYyAgICAgfCAgMTggKy0NCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5oICAgICB8ICAgNCArLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9LY29uZmlnICAgIHwgICAxICsNCiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaCAgICAgICB8ICAxMCAr
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9kaW0uYyAgIHwg
IDE0ICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5j
ICAgfCAgIDQgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
bWFpbi5jICB8ICAyMiArLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90eHJ4LmMgIHwgIDEwICstDQogaW5jbHVkZS9saW51eC9kaW0uaCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAzNjYgKysrKysrKysrKysrKysrKysrDQogaW5jbHVkZS9saW51
eC9uZXRfZGltLmggICAgICAgICAgICAgICAgICAgICAgICAgICAgfCA0MTggLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQogbGliL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgIDggKw0KIGxpYi9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAxICsNCiBsaWIvZGltL01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgOSArDQogbGliL2RpbS9kaW0uYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgODMgKysrKw0KIGxpYi9kaW0vbmV0X2RpbS5jICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTkwICsrKysrKysrKysNCiAyMyBmaWxlcyBjaGFu
Z2VkLCA3MjggaW5zZXJ0aW9ucygrKSwgNDg5IGRlbGV0aW9ucygtKQ0KIGNyZWF0ZSBtb2RlIDEw
MDY0NCBpbmNsdWRlL2xpbnV4L2RpbS5oDQogZGVsZXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbGlu
dXgvbmV0X2RpbS5oDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGxpYi9kaW0vTWFrZWZpbGUNCiBjcmVh
dGUgbW9kZSAxMDA2NDQgbGliL2RpbS9kaW0uYw0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIvZGlt
L25ldF9kaW0uYw0K
