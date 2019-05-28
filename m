Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4202C82F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfE1N4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:56:19 -0400
Received: from mail-eopbgr690074.outbound.protection.outlook.com ([40.107.69.74]:52558
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbfE1N4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 09:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netapp.onmicrosoft.com; s=selector2-netapp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0W8T4BpWAtdMtyfpkle4UMS9AzTyvJN7M+sMAirythY=;
 b=T873an8ha2UvsdBQ5JoXPu1D1dH6Tl9RuZymq+/0Jcbhbb4yef0wYNHArVdFeMFHw2VLJaWWRE22YHjXZeARN22Sf8xMTmNPDiR8rdu+8RDbjIspO94ElV/5qRh9VwZ3HwhorgcAqeCr7CxSpMaumRr/gTeTsy0TPaCZ9bSrvug=
Received: from BN8PR06MB6228.namprd06.prod.outlook.com (20.178.217.156) by
 BN8PR06MB5858.namprd06.prod.outlook.com (20.179.138.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Tue, 28 May 2019 13:56:15 +0000
Received: from BN8PR06MB6228.namprd06.prod.outlook.com
 ([fe80::bc27:e0e1:e3e2:7b52]) by BN8PR06MB6228.namprd06.prod.outlook.com
 ([fe80::bc27:e0e1:e3e2:7b52%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 13:56:15 +0000
From:   "Schumaker, Anna" <Anna.Schumaker@netapp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>
CC:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] xprtrdma: Use struct_size() in kzalloc()
Thread-Topic: [PATCH net-next] xprtrdma: Use struct_size() in kzalloc()
Thread-Index: AQHUuP5mCuK2SP21dES5S/AwZU1LhKXJa7UAgFhvo4CAWCJ1AIAAD8iAgAADGQCABzePAA==
Date:   Tue, 28 May 2019 13:56:15 +0000
Message-ID: <5e8c92372afae86af71564a357691b3e4283640a.camel@netapp.com>
References: <07CB966E-A946-4956-8480-C0FC13E13E4E@oracle.com>
         <ad9eccc7-afd2-3419-b886-6210eeabd5b5@embeddedor.com>
         <70ca0dea-6f1f-922c-7c5d-e79c6cf6ecb5@embeddedor.com>
         <20190523.163229.1499181553844972278.davem@davemloft.net>
         <c8d7982b-cf18-adc0-aa70-81b8ee5ae780@embeddedor.com>
In-Reply-To: <c8d7982b-cf18-adc0-aa70-81b8ee5ae780@embeddedor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anna.Schumaker@netapp.com; 
x-originating-ip: [23.28.75.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5baf4eb-56cc-41ed-9928-08d6e3744032
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR06MB5858;
x-ms-traffictypediagnostic: BN8PR06MB5858:
x-microsoft-antispam-prvs: <BN8PR06MB5858DAAAC8C0A17337163EB5F81E0@BN8PR06MB5858.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(54094003)(199004)(81156014)(81166006)(305945005)(86362001)(8676002)(99286004)(256004)(7736002)(316002)(118296001)(6436002)(478600001)(71200400001)(6116002)(486006)(58126008)(71190400001)(25786009)(14454004)(102836004)(3846002)(4744005)(229853002)(6512007)(6486002)(72206003)(91956017)(76116006)(66066001)(66476007)(66556008)(66946007)(73956011)(66446008)(64756008)(2501003)(76176011)(110136005)(36756003)(6246003)(68736007)(53936002)(4326008)(8936002)(53546011)(6506007)(11346002)(2906002)(186003)(446003)(476003)(2616005)(26005)(54906003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR06MB5858;H:BN8PR06MB6228.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: netapp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D6SlFqNg8slk/PtaTgl+xN8XNoLweBUb4/DXWbwwGCDVT/CkMUJtK2V0ZkU+a2XgxhgXQi46cFuP6NMt/3IBrUamUGRNMVEMVI8FEu9etEcdQj+ESEfhwSJ9P7pNMYmQvEVSs67OY4IFucseIxrTgiMDP5TKkFa4IghQEWfiDIocxe7yj1Tl8h0WzvYxWxsQ1gQxC7I4aaN/9uRu/ZRtglqJJ7Du53SAvlFwsIaUNdh3uwl9f1b5MLzPALjznfCUdeQdWlnZZpKmKbPlY+65MGpjvEPhIWk782o4LAfq2AVmXHicT5ptt6hAlGNjI9dejzE5q2plAHhjWyoLm9GyNRwGx9eLBk9QVSaAKkvdt9Ugz0f0063gM7FF/kmeobhNK7pFJpWD1vU6fLBk+e3bn4Q4F8SgnXujyjNUDwLhP08=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8CF9004DFB06941858E82FF4FAF7539@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5baf4eb-56cc-41ed-9928-08d6e3744032
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 13:56:15.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjschuma@netapp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR06MB5858
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMTktMDUtMjMgYXQgMTg6NDMgLTA1MDAsIEd1c3Rhdm8gQS4gUi4gU2lsdmEg
d3JvdGU6DQo+IA0KPiBPbiA1LzIzLzE5IDY6MzIgUE0sIERhdmlkIE1pbGxlciB3cm90ZToNCj4g
PiBGcm9tOiAiR3VzdGF2byBBLiBSLiBTaWx2YSIgPGd1c3Rhdm9AZW1iZWRkZWRvci5jb20+DQo+
ID4gRGF0ZTogVGh1LCAyMyBNYXkgMjAxOSAxNzozNjowMCAtMDUwMA0KPiA+IA0KPiA+ID4gSGkg
RGF2ZSwNCj4gPiA+IA0KPiA+ID4gSSB3b25kZXIgaWYgeW91IGNhbiB0YWtlIHRoaXMgcGF0Y2gu
DQo+ID4gDQo+ID4gVGhlIHN1bnJwYy9uZnMgbWFpbnRhaW5lciBzaG91bGQgdGFrZSB0aGlzLiAg
SSBuZXZlciB0YWtlIHBhdGNoZXMgaW4gdGhhdA0KPiA+IGFyZWEuDQo+ID4gDQo+IA0KPiBZZXAu
IENodWNrIGp1c3QgbGV0IG1lIGtub3cgdGhhdCBBbm5hIGlzIHdobyB0YWtlIHRoZXNlIHBhdGNo
ZXMuDQo+IA0KPiBIb3BlZnVsbHksIHNoZSB3aWxsIHRha2UgdGhpcyBvbmUgc29vbi4NCg0KSSd2
ZSBhcHBsaWVkIHRoaXMgdG8gcHVzaCBvdXQgbGF0ZXIgaW4gdGhlIHdlZWsuIFRoYW5rcyBmb3Ig
cG9pbnRpbmcgaXQgb3V0IHRvDQptZSENCg0KQW5uYQ0KDQo+IA0KPiBUaGFua3MNCj4gLS0NCj4g
R3VzdGF2bw0K
