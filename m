Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4755C141947
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 20:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgART5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 14:57:45 -0500
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:52099
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbgART5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 14:57:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0u7kQslKLvWUmzXC30z5GbqVFnOue29x+fqsifQawWpEr4XD7j+oeLrf1UQxC8NRAus+R69y+c8aiNIl//kbsCCHA+Q6p4x1i+8UXq5IIvzzYagqtJG+goncUr6Z51PAp5oxsjByqqBeJWskZPYvo3sfZd/1d5ueRJtWXyHo1kpGt5kKArvi5tUrqCqARLVwJvLMUsAFAifcw1L1NqBGA4L5ramVBwTID55TpSxTYSkHw/3OVAPElLtrADFPWGTfH1m4EGfKpCBkhGgrMRofTLoN7Ma2nHoJAVBRFG6sreQuC0hcaTphuHUgU+mGEPhXMRSaC3aAa1wj8y5nNiHJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNM4zjhoVuWqcF6RCfGwVEaCrThCDiQ11Fa2S439AzA=;
 b=TIQ4UoFC2bx/8ukJ0j84JmETF1/9Dms/jbrgTO4iPTOSCQ4Ho1Mp8NjmWj7V9Pb3V6bgAtb58WcuH+H/BOQK4x84v4hZVtDiVI+wKGxhkM/w4OFIKOmCJwM+nGA6FTTgeKb8YsavvFekke1lk+hbcdCTqq7qfrhzTz3gYZm0Yx0LhKgNMknfIrtu1e/9KrFh1KzyqSLVvCImyBfTsIPPWbQBwPCa8iUNnZtEQmG/CQ/FsUKi/EaeqUd7nvjcfce9Y+8fleM/CtWFmujHSq9qBLEQosCLDTaTuEK4Aef+yoR3x4EhqFvMRN2/vz+P3Dp/EqaiTU2QZmwjR6OP/gZSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNM4zjhoVuWqcF6RCfGwVEaCrThCDiQ11Fa2S439AzA=;
 b=RYxmS631Z2GebeF5Y+rIjzQBU/E4sparGeEnshx0v9mCyb2YRF/q7/yDAMX3tFyNv+yhpMUWjuKte1dR85LgBPro5Hpf0ML1ajXO/EAhvGAOyUNfX/whMj25f6rNEatyj5GbISBU8bjzD3b4btUB19CDLZih8QJwMjo2TXr5ZSg=
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com (52.134.107.161) by
 DB7PR05MB5739.eurprd05.prod.outlook.com (20.178.105.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Sat, 18 Jan 2020 19:57:38 +0000
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6]) by DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6%3]) with mapi id 15.20.2644.024; Sat, 18 Jan 2020
 19:57:37 +0000
Received: from [10.0.0.7] (141.226.210.24) by FR2P281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Sat, 18 Jan 2020 19:57:36 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Thread-Topic: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Thread-Index: AQHVyvM49OAL4RHfXUeZhKhHIzGBuKfr04GAgAGxSoCAAI+cgIACyMEA
Date:   Sat, 18 Jan 2020 19:57:37 +0000
Message-ID: <3fd6912b-ec94-195f-5996-8f0d505eec64@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
 <1579017328-19643-4-git-send-email-moshe@mellanox.com>
 <20200115070145.3db10fe4@cakuba.hsd1.ca.comcast.net>
 <2f7a4d81-6ed9-7c93-1562-1df4dc7f9578@mellanox.com>
 <20200116172633.5d873c17@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200116172633.5d873c17@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
x-originating-ip: [141.226.210.24]
x-clientproxiedby: FR2P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::17) To DB7PR05MB4204.eurprd05.prod.outlook.com
 (2603:10a6:5:18::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9f12e91d-5729-49ee-4fc2-08d79c50aa9d
x-ms-traffictypediagnostic: DB7PR05MB5739:
x-microsoft-antispam-prvs: <DB7PR05MB5739F99FB95835C6831928B0D9300@DB7PR05MB5739.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0286D7B531
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(376002)(136003)(346002)(396003)(199004)(189003)(4326008)(2906002)(36756003)(31686004)(2616005)(16526019)(53546011)(26005)(956004)(186003)(5660300002)(52116002)(8676002)(6486002)(478600001)(8936002)(81156014)(81166006)(6916009)(316002)(66946007)(66446008)(64756008)(86362001)(71200400001)(16576012)(31696002)(66556008)(66476007)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5739;H:DB7PR05MB4204.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSBr/X33QfLxG7b9LO/8V1yxiupgYawrPQJlZy8SxipKk6KXtzg8eYpTC0JckctWgexanrLjUuYD5a/b3dHrqpB7FhIMIsbHOUqf0uKFpieDi2jxSMGbwhyBhQUxSbmW7y+Q4TRkcEiTsX8gUpHnUJZ24K8TiPCoJ2J4k2YtCi2RKVJnBlcnjKoGFKcv+f49K8fSOFxiMXWWIfch/VFEIg3+HRoKkW5x5oGHxYqMp4b0Hw9q1bDN3GvBk24nfnvEpA9PupueT6eclLdZKMXPkWPCY+DsmjuCKavEPhTkqihyvUb9EYRpXmOoRqGQtg2GRlMURWYLbuAhGXBpHZEjuIFO1wab/ydUpp+2zlywDOrWhL9tiuR1dxShMj8HLWnUInA1KJJ9q6Ze0vDG4eRub877np+fFZ+eJanYJgK0aWvG665TRZ/s9fWF+e50CzJd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <10909E28B44B9846940166D110387883@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f12e91d-5729-49ee-4fc2-08d79c50aa9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2020 19:57:37.4594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aW+0dc8SbI+WKvAy92g7v9orHUPxh+cd0cEgrRlxtMv/M7uA90z/FCSRnK3Me7cme7/XERtfE7ghzYR5Mgnx/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE3LzIwMjAgMzoyNiBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFRodSwg
MTYgSmFuIDIwMjAgMTQ6NTI6MzUgKzAwMDAsIE1vc2hlIFNoZW1lc2ggd3JvdGU6DQo+Pj4gSWYg
bXVsdGlwbGUgZGV2aWNlcyB1bmRlciBvbmUgYnJpZGdlIGFyZSBhIHJlYWwgY29uY2VybiAob3Ig
b3RoZXJ3aXNlDQo+Pj4gaW50ZXJkZXBlbmRlbmNpZXMpIHdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8g
bWFyayB0aGUgZGV2aWNlcyBhcyAicmVsb2FkDQo+Pj4gcGVuZGluZyIgYW5kIHBlcmZvcm0gdGhl
IHJlbG9hZHMgb25jZSBhbGwgZGV2aWNlcyBpbiB0aGUgZ3JvdXAgaGFzIHRoaXMNCj4+PiBtYXJr
IHNldD8NCj4+IEFsbCBtbHg1IGN1cnJlbnQgZGV2aWNlcyBzdXBwb3J0IFBDSSAtIEV4cHJlc3Mg
b25seS4NCj4+DQo+PiBQQ0ktRXhwcmVzcyBkZXZpY2Ugc2hvdWxkIGhhdmUgaXRzIG93biBQQ0kt
RXhwcmVzcyBicmlkZ2UsIGl0IGlzIDF4MQ0KPj4gY29ubmVjdGlvbi4NCj4+DQo+PiBTbyB0aGUg
Y2hlY2sgaGVyZSBpcyBqdXN0IHRvIHZlcmlmeSwgYWxsIGZ1bmN0aW9ucyBmb3VuZCB1bmRlciB0
aGUNCj4+IGJyaWRnZSBhcmUgZXhwZWN0ZWQgdG8gYmUgdGhlIHNhbWUgZGV2aWNlIGZ1bmN0aW9u
cyAoUEZzIGFuZCBWRnMpLg0KPiBBaCwgZ29vZCwgSSBjb3VsZG4ndCBjb25maXJtIHRoYXQgUENJ
ZSBmYWN0IHdpdGggZ29vZ2xlIGZhc3QgZW5vdWdoIDopDQo+IFRoZSBjaGVjayBzb3VuZHMgZ29v
ZCB0aGVuLCB3aXRoIHBlcmhhcHMgYSBzbWFsbCBzdWdnZXN0aW9uIHRvIGFkZA0KPiBhIGhlbHBl
ciBpbiBQQ0llIGNvcmUgaWYgaXQncyBhbHJlYWR5IGRvbmUgYnkgdHdvIGRyaXZlcnM/IENhbiBi
ZSBhcw0KPiBhIGZvbGxvdyB1cC4uDQoNCk9LLCB3ZSB3aWxsIGZvbGxvdyB1cC4NCg0KV2UgYXJl
IHByZXBhcmluZyBsYXJnZXIgc2VyaWVzIGZvciBGVyB1cGdyYWRlIHJlc2V0IHRoYXQgcmVsaWVz
IG9uIHRoaXMgUkZDLg0KDQpTdWNoIHNoYXJlZCBmdW5jdGlvbiBzaG91bGQgZ28gdG8gcGNpZSBz
dWJzeXN0ZW0sIHdlIHdpbGwgZm9sbG93IHVwIHdpdGggDQppdCBmb3IgYm90aCBkcml2ZXJzIG9u
Y2UgdGhlIGZ1bGwgbWx4NSBzb2x1dGlvbiBpcyB1cHN0cmVhbS4NCg0K
