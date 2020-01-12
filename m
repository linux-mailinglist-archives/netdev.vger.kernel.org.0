Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3481386D8
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 15:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbgALOwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 09:52:10 -0500
Received: from mail-eopbgr50073.outbound.protection.outlook.com ([40.107.5.73]:62067
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733008AbgALOwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 09:52:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+Ky9qzeGH9uX9RXFKCSHv1M6ySC/4Al3NBV1q9j12pAmh+8OL1laX+vTyZLc9PtTFvGXFF/SW0QveK025C/3+8oKkJTdnFwvs0LmHnOJ56391D8XMPZcbAt3sMGuyS5RnIw/02DItXLm+6OavvXt5tmrqI18KRflgBXlkVOQ/dwPA8rDfe6KYnNzKcNHYQX4KrxtWouzuFu/GOSQqtUu+GL6wXJ4NYYjkDnJVnCJ+5JXN+zYsrrtsAS0Affjk2BTX8WV2Bmuql42U8qi8aMAO73EdAIAFQzWx58Dxe689WYHjk+z6LC6TlOl/nuvBYllNqsTYv7zwIW34uSpH309Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaBZKjl0+xevyKgHuHQTCvXwADTCKv+sFZptq5hCvfo=;
 b=ekvrNWPEPP/g8ibotgk3ZnEkXIsZyIfT9zASMxfVhCcclvH2YQh8B3BNTtrZe3i7c7j85w2mh3/2bcWCHkY+R9uQYcQIgwFykDR7d8N+XyTXdf+i1r66sxzd5kwT7dYNhuHioXNm2mGRWE5ACC2qE8pUbxUZ/ChQFzGwijcReW2shTCVNCzgkw8dPkIfcD9FdxqxjapD34Gktklse3Fl/DVLeVjxuqoD31oEOXGuvaVLB0i5jRouSmyN3N9JFANN8Pejo9sWByXBkPnQWlMy2oDyxmPqAf1Ak85nfV4Wev246nAT6XRmcK0X/XpC/PxoGN+AfChoP+K3uD5EXt1vLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaBZKjl0+xevyKgHuHQTCvXwADTCKv+sFZptq5hCvfo=;
 b=hC0ZDAHY8ZkJyVJxrA3Fpixc5OHeqK8ObeXAJ4e1ZyIlnElKiHAxz7IhbFO2LIG14IT2eqXtXbgJbAQugtwMC0Yc2+v8VL5MIe/K72w5jjgQZGCz5zNC994sMmFOSXnomAcF8uI+WNhXRjiJRLfKZ5iN2QOpMJgZtE40/YWMyTc=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6492.eurprd05.prod.outlook.com (20.179.43.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Sun, 12 Jan 2020 14:52:05 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::10ee:7a73:5c2e:8dbb]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::10ee:7a73:5c2e:8dbb%2]) with mapi id 15.20.2623.014; Sun, 12 Jan 2020
 14:52:04 +0000
Received: from [10.80.2.90] (193.47.165.251) by AM0PR07CA0014.eurprd07.prod.outlook.com (2603:10a6:208:ac::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.5 via Frontend Transport; Sun, 12 Jan 2020 14:52:04 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
Thread-Topic: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
Thread-Index: AQHVxyJCRMOGWtv5n0KbE6/1MTn7NafkpA8AgAJ9XYA=
Date:   Sun, 12 Jan 2020 14:52:04 +0000
Message-ID: <06f47070-d8c2-7d9a-6801-f611e224c950@mellanox.com>
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
 <20200110.165048.1993854113044478081.davem@davemloft.net>
In-Reply-To: <20200110.165048.1993854113044478081.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::27) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21c579b6-ea29-4456-861b-08d7976efd3b
x-ms-traffictypediagnostic: DBBPR05MB6492:
x-microsoft-antispam-prvs: <DBBPR05MB6492F4066B8C80EE5D8BDA9BAE3A0@DBBPR05MB6492.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02801ACE41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(186003)(2906002)(16526019)(71200400001)(53546011)(52116002)(26005)(2616005)(956004)(16576012)(54906003)(478600001)(31686004)(110136005)(4326008)(81156014)(81166006)(316002)(6486002)(8936002)(8676002)(66476007)(31696002)(4744005)(5660300002)(66556008)(86362001)(66946007)(66446008)(64756008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6492;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aj9h40px8dAjiVCzVMU00u25Ae4B7M8tTbay7kAyIxwDh/gumvwoeLfY/uJ/IJH4AjTM08nfCEPLFLzsB0cHGxWUIOj1omgDLMGqDGf6FA1jbOsD6m3gGkQXg7ypynaD2yE2PjWUnC9GORmD//DxNbAvUrTVoYcwHLJ9c8+UodqevpBd/UpPZkhv1l8XY9s6tyxGOEI+fF+LVDJKfDM3KGFSSR+XYK+OYwEk6aNR9agve/pm6zsXxldVLZ9Uv5YoappiDsLPE+WpykLRu1+H8WGepv9/Qm5QmMxJMKzyOpKRjpG9XQ7PFtZ4LWp+ptQILBuvoSMfno7z3HxdB1SeoaVMvbKYZHMnsQT6D3K/tEDmmEgkTUSfavfzjIZw39ATNtO/9zoJUYBaD+R4whpuaZgfqWHHAvCZy7kwgBDvkP1mOvLMENEr4SeEqGdnDpAY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7D7DE447D56C84BBD766B3507933044@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c579b6-ea29-4456-861b-08d7976efd3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2020 14:52:04.8177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19mihl/y493ZAZ4g00t70UAAkV3orNwkkWRamUwYLtLlvbsf4fnRue6N0nBe9z28rOwyWJ6GJ3ExYXECb4jSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6492
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTEvMjAyMCAyOjUwIEFNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZyb206IEpv
bmF0aGFuIExlbW9uIDxqb25hdGhhbi5sZW1vbkBnbWFpbC5jb20+DQo+IERhdGU6IFRodSwgOSBK
YW4gMjAyMCAxMToyMzoxNyAtMDgwMA0KPiANCj4+IE9uIG1vZGVybiBoYXJkd2FyZSB3aXRoIGEg
bGFyZ2UgbnVtYmVyIG9mIGNwdXMgYW5kIHVzaW5nIFhEUCwNCj4+IHRoZSBjdXJyZW50IE1TSVgg
bGltaXQgaXMgaW5zdWZmaWNpZW50LiAgQnVtcCB0aGUgbGltaXQgaW4NCj4+IG9yZGVyIHRvIGFs
bG93IG1vcmUgcXVldWVzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEpvbmF0aGFuIExlbW9uIDxq
b25hdGhhbi5sZW1vbkBnbWFpbC5jb20+DQo+IA0KPiBUYXJpcSBldCBhbC4sIHBsZWFzZSByZXZp
ZXcuDQo+IA0KDQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29t
Pg0KDQpSZWdhcmRzLA0KVGFyaXENCg0K
