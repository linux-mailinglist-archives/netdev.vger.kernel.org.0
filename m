Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA024233C28
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgG3X3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:29:51 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:55950
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728846AbgG3X3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:29:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKqkL27Yal+MLpqdtoP0Zj2P1oYc/kOm2m27M/TRMImocfnzmWH/8mYddfU+xOPfZi5/ldgzI8NI4VjYm7wEIO6ej2F+uIreWxXy/r9JnGP7jzuJMedDfDmb/c7Vrx3Se2jW0sxrd+5dkg5BT7ZOsYh1wrIpoSmePAAsdsGRzhgI2YQgM5V2ORMzI2TXXfkcTp9VfxCyFLvGfr+RM5M2BbbRtMuTPbiIxhSbREJlBF+b+kVlfXghLOYk9N8+Z/Z1BCbM/saNWmgN1TanegJa8ukimLW3pv2WxPQCKk3gxVEnLN7E8FNl89PLwGsEujKpx1jNzHx7I4qtGljEmV2CBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaCf820zOreZkYuoN3M30O55h0AXLYnKIVAP7gLm3ao=;
 b=PBnqQIKW0A+/QPMLLf+Hy7YlfLTkFnEzd0QHlRlpSUFoDwxq1qas5dOl4aaDtjeUtMjzbvZ2BKBDHwD2Bfx52CJeuCnHEdfRKwV7QYh6yCw48bIJf2J38LWaQ+R0pHF/Mk2mbBqvi9HRTyFaZLw4hEsa+d6SdSB/PONkSm9/hmyi2iaOCKby3JRHU3xCa322uZJZhsPPZ0rD2yPhI416N0UaH6zoOScDHDP58mc9WQY5rnUbt5qsD/FaGJ4fQjcb85NOTwndtEBYcC0W4wzq7Y13ZGmJWZ8tR83CtEWv68c0I4c0KQ1r86DIV4tONtLOpRf6g9sevSHCM4PEu1wwLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaCf820zOreZkYuoN3M30O55h0AXLYnKIVAP7gLm3ao=;
 b=mlWQL0Z1oEJkclSpgZFJMSetERasv87CXgX5ptf+6F6ty90BuJpu7VOrVdUF8PnHL4MM1XrvryXTuyOQbIe7KrlUE87gEtB7df6n4NPRpVOQojdbeq/G2YIrJYAHT3kDEDYt1KnoxAWFzUEJkmEOB5Q8BSQxeP57X3H5UFW9dB0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Thu, 30 Jul
 2020 23:29:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Thu, 30 Jul 2020
 23:29:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Topic: [PATCH net-next v3 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Index: AQHWZSjG9InJULdNPEWuKiDGdQb8yKkgyEoA
Date:   Thu, 30 Jul 2020 23:29:46 +0000
Message-ID: <ab088c0172834f645b14f86ae74b8570c12d891f.camel@mellanox.com>
References: <20200728214759.325418-1-kuba@kernel.org>
In-Reply-To: <20200728214759.325418-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 13f4f6aa-e62a-458a-6b46-08d834e0721a
x-ms-traffictypediagnostic: VI1PR05MB5376:
x-microsoft-antispam-prvs: <VI1PR05MB5376818C104FB11524A74EB5BE710@VI1PR05MB5376.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LUjNIz5WZp7EJxgxq/mMiw1rOyS5iPvq5AWW5RqFfoQF8V4V2oxfLqAtSqL7YPrzcSFLkK3O7SuweEt2VaMgLAudcFVBh6F1pUmgKZeKJlDfmlzfybpkuSKUA3fZk1PQ5U4MsOek+61YZFmcjWIAdhV+eYPH8HVdgYxJAC/GmH3nxYlM9U3Ah6oSHM+94X5pSuHxowgUnqGlYRxehxzRML7tSWtzKBm8sak3uWGwmdgtHwP743XiWLBWObCcb+421JIIRrY5lwewq7FSRuQIUQuGDU7a+6u3vdafUlUBSRijoeqZTWqbbfere9WeXmsf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(54906003)(36756003)(6486002)(6506007)(86362001)(8936002)(26005)(8676002)(6916009)(316002)(2616005)(186003)(2906002)(6512007)(478600001)(91956017)(71200400001)(66446008)(66556008)(64756008)(5660300002)(66476007)(76116006)(4326008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ukYDcc2SjeL8xocOYofhYb33pm9EXxXJ78TNIrO+xhJFvalsAAk3dO5q0ax+HW6+4P+4eZ5qOcj6E73ht6PYVdPmDckqeowD5+z45hg0fWLrzx6meE6G7G2XTLpvvkqom4EyTuJk7owxiF5+4qhILJ6K4iaRqR3E/38xT0p7PnjMHjg8jIZr4qg9bS0uKZpArdFXrifLV239/mqogzXRRfs+ADX9pqPwr0BJzbt6W6Z3PU8Sf/P49rnvw92pgmcJWJOfcVjiLbtokG3rcEdYOznsCn0qCvv8l4MahPTAkLscpxUDVm659/GSKokiNtbj25xN0LUrMxjD+QdB21LaM58DLZihij6mnz9PE9p8iSDduv0u+dy0pHw6GMbCUhSPuzKqegO7StDjdYtS/Q3pMKV8f6DL5pTO64gpBBGPgEBEGzO0mqnar7DuKOBVn3Em4RFBStcaiX4EHkWJ4RXhDMjbji4X/CwU2hxtbuzZfQg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <99CD03B91B2B374E91A109C66317A5DD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f4f6aa-e62a-458a-6b46-08d834e0721a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 23:29:46.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: juWbDcOl/6w70h48u2b3+t78fSh4TY6z6yIuMc9RVOH560naMEcx56ZlLTriCmi/fy3Z+8Xk2fPv1yoa10juWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDE0OjQ3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGhpcyBzZXQgY29udmVydHMgbWx4NSB0byB0aGUgbmV3IGluZnJhc3RydWN0dXJlLg0KPiAN
Cj4gV2UgbmVlZCBhIHNtYWxsIGFtb3VudCBvZiBzcGVjaWFsIGhhbmRsaW5nIGFzIG1seDUgZXhw
ZWN0cyBJQU5BIFZYTEFODQo+IHBvcnQgdG8gYWx3YXlzIGJlIHByb2dyYW1tZWQgaW50byB0aGUg
ZGV2aWNlLiBldGh0b29sIHdpbGwgc2hvdyBzdWNoDQo+IHBvcnRzIGluIGEgc2VwYXJhdGUsIHR5
cGUtbGVzcywgZmFrZSB0YWJsZSwgYXQgdGhlIGVuZDoNCj4gDQo+IFR1bm5lbCBpbmZvcm1hdGlv
biBmb3IgZXRoMDoNCj4gICBVRFAgcG9ydCB0YWJsZSAwOiANCj4gICAgIFNpemU6IDcNCj4gICAg
IFR5cGVzOiB2eGxhbg0KPiAgICAgTm8gZW50cmllcw0KPiAgIFVEUCBwb3J0IHRhYmxlIDE6IA0K
PiAgICAgU2l6ZTogMQ0KPiAgICAgVHlwZXM6IG5vbmUgKHN0YXRpYyBlbnRyaWVzKQ0KPiAgICAg
RW50cmllcyAoMSk6DQo+ICAgICAgICAgcG9ydCA0Nzg5LCB2eGxhbg0KPiANCj4gU2FlZWQgLSB0
aGlzIHNob3VsZCBhcHBseSBvbiB0b3Agb2YgbmV0LW5leHQsIGluZGVwZW5kZW50bHkgb2YNCj4g
dGhlIEludGVsIHBhdGNoZXMsIHdvdWxkIHlvdSBtaW5kIHRha2luZyB0aGlzIGluIGZvciB0ZXN0
aW5nDQo+IGFuZCByZXZpZXc/IEknbGwgcG9zdCB0aGUgbmV0ZGV2c2ltICYgdGVzdCBvbmNlIElu
dGVsIHBhdGNoZXMNCj4gcmUtZW1lcmdlLg0KPiANCj4gdjM6IC0gYWRkIG1pc3NpbmcgaW5jbHVk
ZS4NCj4gdjI6IC0gZG9uJ3QgZGlzYWJsZSB0aGUgb2ZmbG9hZCBvbiByZXBycyBpbiBwYXRjaCAj
Mi4NCj4gDQo+IEpha3ViIEtpY2luc2tpICgyKToNCj4gICB1ZHBfdHVubmVsOiBhZGQgdGhlIGFi
aWxpdHkgdG8gaGFyZC1jb2RlIElBTkEgVlhMQU4NCj4gICBtbHg1OiBjb252ZXJ0IHRvIG5ldyB1
ZHBfdHVubmVsIGluZnJhc3RydWN0dXJlDQo+IA0KDQpUaGUgdHdvIHBhdGNoZXMgYXJlIGFwcGxp
ZWQgdG8gbmV0LW5leHQtbWx4NS4NCg0KbWx4NSBwYXRjaCB3YXMgc2xpZ2h0bHkgbW9kaWZpZWQg
dG8gbW92ZSB1ZHBfdHVubmVsIG5ldGRldiBzcGVjaWZpYyANCmJpdHMgZnJvbSBtbHg1L2NvcmUv
bGliL3Z4bGFuLmMgdG8gbWx4NS9jb3JlL2VuX21haW4uYy4NCkpha3ViIGFscmVhZHkgQWNrbm93
bGVkZ2UgdGhpcyBjaGFuZ2UuDQoNClRoYW5rcywNClNhZWVkLg0K
