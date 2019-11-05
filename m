Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04E4F0141
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389740AbfKEPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:25:02 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:42670 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389240AbfKEPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:25:01 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4B982C0EAE;
        Tue,  5 Nov 2019 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572967501; bh=j5LkLCVjkmz7ZRgWfNi5N2Vq823hQt6sfArnQD1+kIU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ElH4CnOIB/t/R9nG4VKxfbEcpxD96zuhKGqvtEUkfFors+onXg2oel4GbAfWIkg+i
         1I47PnXithnEIpn7Co66aovXom/0kEGcqwUyH9pyfA9f43RgQZmgnykpNcqLHBaPj5
         nVhYPGNgiN+H6jKb+Qo7fuTCGOdatoZjlDG9KKYERl6S09FR6tkLQMMVCb0Q1dT6ip
         rF9aPP/dceG0KoSnAUmFWKEvHaVQgNyD846Kmk8VwAHxobjedz7ayO2GOca2i5xgrR
         gbyf71yFhGH02+LFBu19NqRrXCKW992M2u/KxcML38W5N2Qglfgtp/+fGf1S0GCuRF
         o+9IIZTln2H9Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id ED0BEA007B;
        Tue,  5 Nov 2019 15:25:00 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 5 Nov 2019 07:24:56 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 5 Nov 2019 07:24:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdb/qP4Gc1xagh0grtdUU+fIJcskB3RmpgwpxLJgaQxNRra1xg9VXG1KkdnQ1/BEFsir6vs9FLPhg5N4mTZ3OhqhMpuEKfBSpufzzhcbOmWayJotaYPkysug3RKH1IDlAUHxLYxYh7DnMFymvpl2oYE5sJCkpyVcTUvH2f+fWSGHpRuwbGeUzk1W+xH70ONyc5wwDBlvPIEUD7k1l86eUXS73mmCFTsTg/gNMjD5PIJScvJQlTkzfv433iZ+0n7Z8hlt7DL1esR01DxQkF8KBdfRmXDPwJ1IaNko/lpYnZK1/s9GftJomTJs/Xx615qT5N/pdfVoZRPz6op0GL55iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5LkLCVjkmz7ZRgWfNi5N2Vq823hQt6sfArnQD1+kIU=;
 b=dDkx/PVy9YsYo9uEOGV8hDhHoVLI6HGbxB8CIZu1dhzUMykoy7Nhy7UZLLQBcz/Nl/K+/pQaJisRABqaFnzxMUo94/YEzlDVT3votRGLc7VTZeGzJAWitEpmoKlT/OUcE+ijNIrdu/pH3G6rGWAosL5xF3xywMZAbC23DBjZKtFUsz0i+ugmJ3FhNiSn0AziLhlfcS52JduVQpUAGQ3EbNvtOMtDVfE0ip1UoXU+PIHYeb3A5zYvcmfoS8/CwFuoQpohYT+UwAxcKbxn2OfVcnIFOt3T/NrwXjtRmzmlkP4TL9HKcCxEWfU/CUBobLOHPdYUBNngUtDSc3JiqPsizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5LkLCVjkmz7ZRgWfNi5N2Vq823hQt6sfArnQD1+kIU=;
 b=XFSLYtpFxoavaF+iaCnUB95TIKVvD0WHsdNogsxSc4O7r72qW0HOH5lmY7Qai3g9roNxM5gc5YUdLgjr4cRTAoz27HQOhqz5JlaM/QYrHKLfKzWFWY7RWuPScU1BgPZjmOW/bbAalvQVELFoxpN4E7HB10RqsIKQUyfKkUXKWYs=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3585.namprd12.prod.outlook.com (20.178.212.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 15:24:54 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2430.020; Tue, 5 Nov 2019
 15:24:54 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Josh Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: USO / UFO status ?
Thread-Topic: USO / UFO status ?
Thread-Index: AdWPLBeus8XJlFS/Sue5aUntLc/tSwALvOGAAANGMQAAGxmwMAEF6g7Q
Date:   Tue, 5 Nov 2019 15:24:53 +0000
Message-ID: <BN8PR12MB326627EECB503FD44760CF05D37E0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB326699DDA44E0EABB5C422E4D3600@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+FuTSdVsTgcpB9=CEb=O369qUR58d-zEz5vmv+9nR+-DJFM6Q@mail.gmail.com>
 <99c9e80e-7e97-8490-fb43-b159fe6e8d7b@akamai.com>
 <BN8PR12MB3266E16EB6BAD0A3A1938426D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266E16EB6BAD0A3A1938426D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ac7cbba-cc28-45be-efa8-08d762044f0c
x-ms-traffictypediagnostic: BN8PR12MB3585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB358513EE547997E3D563EC4CD37E0@BN8PR12MB3585.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(39860400002)(346002)(136003)(189003)(199004)(55016002)(76176011)(6246003)(71200400001)(476003)(7696005)(66476007)(102836004)(5660300002)(110136005)(66066001)(229853002)(54906003)(26005)(9686003)(76116006)(8676002)(81166006)(186003)(81156014)(66946007)(52536014)(8936002)(3846002)(6116002)(305945005)(478600001)(6506007)(107886003)(6436002)(316002)(99286004)(486006)(66556008)(64756008)(66446008)(14454004)(74316002)(7736002)(446003)(11346002)(86362001)(25786009)(33656002)(256004)(2906002)(4326008)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3585;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yfphxVJ7IejPMVLyXm+VZxl5/vs70d+fdVfXrTNPjjy0+18XqeNT3OyyJGBJ0U1yvS5OrMISW7iwEMbG9lk6r5fORiXM22TGXnLT/XUr4laqtJnlZi4M4ebZ9TK5MJbkVqjEGO6iewC1yd5kG00rCipl5rqI51YR0HpwUFJdlDzzsiVj3vnJYGxTAP9bSpf/Br/WxVQfHLSHTckztUrtHNXGmXb6q6V8bn3GgKb4Ca4l31oYZ4RentSOGoNNlGwfEF9mx64QITgGava9gYISsYYOqn+uYKJ3Eg4lI019vabdyHdmEStZYEcvjFjjoqkv+k+0+PEs/fj5pSeRx1gqJT5wBVQjHG2CLK4yOSMhJv0C5N7SP/rNJf2CY6MXG5VBtUXyLvkEoRF1GgpjYlrCxk4z76RA82Wz3AuQPfLzuAPobTzEOhBrjUoyoLCxBDp7
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac7cbba-cc28-45be-efa8-08d762044f0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 15:24:53.9634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CrP4cE6ArCiPjgDrI3KMJIJ1wVytW3S4Q1ZFNODeJAeZGvOS44S0x05eRyvvOS6+02ftZ+vdsAi0kg0eCwWYCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3585
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBPY3QvMzEvMjAx
OSwgMTA6MjA6MzcgKFVUQyswMDowMCkNCg0KPiBXZWxsLCBJJ20gbW9yZSBpbnRlcmVzdGVkIGlu
IGltcGxlbWVudGluZyBpdCBpbiBzdG1tYWMuIEkgaGF2ZSBzb21lIEhXIA0KPiB0aGF0IHN1cHBv
cnRzIFVTTyBhbmQgVUZPLg0KDQpIaSBKb3NoLA0KDQpVc2luZyB5b3VyIHNjcmlwdCB0aGVzZSBh
cmUgdGhlIHJlc3VsdHMgSSBnZXQ6DQpTaXplID0gMTQ3Mg0KdWRwIHR4OiAgICAgOTYgTUIvcyAg
ICA2ODU5NCBjYWxscy9zICA2ODU5NCBtc2cvcw0KdWRwIHR4OiAgICAgOTUgTUIvcyAgICA2ODAx
OCBjYWxscy9zICA2ODAxOCBtc2cvcw0KdWRwIHR4OiAgICAgOTUgTUIvcyAgICA2ODAzNSBjYWxs
cy9zICA2ODAzNSBtc2cvcw0KdWRwIHR4OiAgICAgOTUgTUIvcyAgICA2Nzg4MCBjYWxscy9zICA2
Nzg4MCBtc2cvcw0KdWRwIHR4OiAgICAgOTUgTUIvcyAgICA2Nzg4NyBjYWxscy9zICA2Nzg4NyBt
c2cvcw0KdWRwIHR4OiAgICAgOTUgTUIvcyAgICA2Nzc4OSBjYWxscy9zICA2Nzc4OSBtc2cvcw0K
dWRwIHR4OiAgICAgOTUgTUIvcyAgICA2Nzk3NyBjYWxscy9zICA2Nzk3NyBtc2cvcw0KdWRwIHR4
OiAgICAgOTUgTUIvcyAgICA2ODMyNSBjYWxscy9zICA2ODMyNSBtc2cvcw0KdWRwIHR4OiAgICAg
OTUgTUIvcyAgICA2ODAxOCBjYWxscy9zICA2ODAxOCBtc2cvcw0KdWRwIHR4OiAgICAgOTUgTUIv
cyAgICA2NzkyNiBjYWxscy9zICA2NzkyNiBtc2cvcw0KU2l6ZSA9IDI5NDQNCnVkcCB0eDogICAg
MTA3IE1CL3MgICAgMzgxNTEgY2FsbHMvcyAgMzgxNTEgbXNnL3MNCnVkcCB0eDogICAgMTA2IE1C
L3MgICAgMzgwNjIgY2FsbHMvcyAgMzgwNjIgbXNnL3MNCnVkcCB0eDogICAgMTA3IE1CL3MgICAg
MzgxMTQgY2FsbHMvcyAgMzgxMTQgbXNnL3MNCnVkcCB0eDogICAgMTA2IE1CL3MgICAgMzc5MTYg
Y2FsbHMvcyAgMzc5MTYgbXNnL3MNCnVkcCB0eDogICAgMTA2IE1CL3MgICAgMzgwNTQgY2FsbHMv
cyAgMzgwNTQgbXNnL3MNCnVkcCB0eDogICAgMTA2IE1CL3MgICAgMzc5NDQgY2FsbHMvcyAgMzc5
NDQgbXNnL3MNCnVkcCB0eDogICAgMTA2IE1CL3MgICAgMzgwNjQgY2FsbHMvcyAgMzgwNjQgbXNn
L3MNCnVkcCB0eDogICAgMTA2IE1CL3MgICAgMzgxMDYgY2FsbHMvcyAgMzgxMDYgbXNnL3MNCnVk
cCB0eDogICAgMTA2IE1CL3MgICAgMzgwNDIgY2FsbHMvcyAgMzgwNDIgbXNnL3MNCnVkcCB0eDog
ICAgMTA3IE1CL3MgICAgMzgxMTkgY2FsbHMvcyAgMzgxMTkgbXNnL3MNClNpemUgPSA1ODg4DQp1
ZHAgdHg6ICAgIDEwOCBNQi9zICAgIDE5MzI4IGNhbGxzL3MgIDE5MzI4IG1zZy9zDQp1ZHAgdHg6
ICAgIDEwOCBNQi9zICAgIDE5MjkwIGNhbGxzL3MgIDE5MjkwIG1zZy9zDQp1ZHAgdHg6ICAgIDEw
OCBNQi9zICAgIDE5Mjg3IGNhbGxzL3MgIDE5Mjg3IG1zZy9zDQp1ZHAgdHg6ICAgIDEwOCBNQi9z
ICAgIDE5MzAwIGNhbGxzL3MgIDE5MzAwIG1zZy9zDQp1ZHAgdHg6ICAgIDEwOCBNQi9zICAgIDE5
NDAxIGNhbGxzL3MgIDE5NDAxIG1zZy9zDQp1ZHAgdHg6ICAgIDExMSBNQi9zICAgIDE5ODAzIGNh
bGxzL3MgIDE5ODAzIG1zZy9zDQp1ZHAgdHg6ICAgIDExMSBNQi9zICAgIDE5Nzk4IGNhbGxzL3Mg
IDE5Nzk4IG1zZy9zDQp1ZHAgdHg6ICAgIDExMCBNQi9zICAgIDE5NzIzIGNhbGxzL3MgIDE5NzIz
IG1zZy9zDQp1ZHAgdHg6ICAgIDExMCBNQi9zICAgIDE5NzM0IGNhbGxzL3MgIDE5NzM0IG1zZy9z
DQp1ZHAgdHg6ICAgIDEwOCBNQi9zICAgIDE5MjU4IGNhbGxzL3MgIDE5MjU4IG1zZy9zDQpTaXpl
ID0gMTE3NzYNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgIDk5OTcgY2FsbHMvcyAgIDk5OTcgbXNn
L3MNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgMTAwMjcgY2FsbHMvcyAgMTAwMjcgbXNnL3MNCnVk
cCB0eDogICAgMTEyIE1CL3MgICAgMTAwMjcgY2FsbHMvcyAgMTAwMjcgbXNnL3MNCnVkcCB0eDog
ICAgMTEyIE1CL3MgICAgMTAwMjggY2FsbHMvcyAgMTAwMjggbXNnL3MNCnVkcCB0eDogICAgMTEy
IE1CL3MgICAgMTAwMjYgY2FsbHMvcyAgMTAwMjYgbXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3Mg
ICAgIDk5NzUgY2FsbHMvcyAgIDk5NzUgbXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgMTAw
MjYgY2FsbHMvcyAgMTAwMjYgbXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgMTAwMjcgY2Fs
bHMvcyAgMTAwMjcgbXNnL3MNCnVkcCB0eDogICAgMTEwIE1CL3MgICAgIDk4ODIgY2FsbHMvcyAg
IDk4ODIgbXNnL3MNCnVkcCB0eDogICAgMTExIE1CL3MgICAgIDk5MTkgY2FsbHMvcyAgIDk5MTkg
bXNnL3MNClNpemUgPSAyMzU1Mg0KdWRwIHR4OiAgICAxMTEgTUIvcyAgICAgNDk4MCBjYWxscy9z
ICAgNDk4MCBtc2cvcw0KdWRwIHR4OiAgICAxMTIgTUIvcyAgICAgNTAyMSBjYWxscy9zICAgNTAy
MSBtc2cvcw0KdWRwIHR4OiAgICAxMTEgTUIvcyAgICAgNDk3NiBjYWxscy9zICAgNDk3NiBtc2cv
cw0KdWRwIHR4OiAgICAxMTIgTUIvcyAgICAgNTAxNiBjYWxscy9zICAgNTAxNiBtc2cvcw0KdWRw
IHR4OiAgICAxMTIgTUIvcyAgICAgNTAwOCBjYWxscy9zICAgNTAwOCBtc2cvcw0KdWRwIHR4OiAg
ICAxMTEgTUIvcyAgICAgNDk2NiBjYWxscy9zICAgNDk2NiBtc2cvcw0KdWRwIHR4OiAgICAxMTEg
TUIvcyAgICAgNDk3MyBjYWxscy9zICAgNDk3MyBtc2cvcw0KdWRwIHR4OiAgICAxMTIgTUIvcyAg
ICAgNTAxOCBjYWxscy9zICAgNTAxOCBtc2cvcw0KdWRwIHR4OiAgICAxMTIgTUIvcyAgICAgNTAw
OCBjYWxscy9zICAgNTAwOCBtc2cvcw0KdWRwIHR4OiAgICAxMTIgTUIvcyAgICAgNTAwOCBjYWxs
cy9zICAgNTAwOCBtc2cvcw0KU2l6ZSA9IDQ3MTA0DQp1ZHAgdHg6ICAgIDExMiBNQi9zICAgICAy
NTE1IGNhbGxzL3MgICAyNTE1IG1zZy9zDQp1ZHAgdHg6ICAgIDExMiBNQi9zICAgICAyNDk5IGNh
bGxzL3MgICAyNDk5IG1zZy9zDQp1ZHAgdHg6ICAgIDExMSBNQi9zICAgICAyNDg4IGNhbGxzL3Mg
ICAyNDg4IG1zZy9zDQp1ZHAgdHg6ICAgIDExMSBNQi9zICAgICAyNDgyIGNhbGxzL3MgICAyNDgy
IG1zZy9zDQp1ZHAgdHg6ICAgIDExMSBNQi9zICAgICAyNDkwIGNhbGxzL3MgICAyNDkwIG1zZy9z
DQp1ZHAgdHg6ICAgIDExMiBNQi9zICAgICAyNDk1IGNhbGxzL3MgICAyNDk1IG1zZy9zDQp1ZHAg
dHg6ICAgIDExMSBNQi9zICAgICAyNDg1IGNhbGxzL3MgICAyNDg1IG1zZy9zDQp1ZHAgdHg6ICAg
IDExMSBNQi9zICAgICAyNDg5IGNhbGxzL3MgICAyNDg5IG1zZy9zDQp1ZHAgdHg6ICAgIDExMiBN
Qi9zICAgICAyNTAxIGNhbGxzL3MgICAyNTAxIG1zZy9zDQp1ZHAgdHg6ICAgIDExMiBNQi9zICAg
ICAyNTA3IGNhbGxzL3MgICAyNTA3IG1zZy9zDQpTaXplID0gNjE4MjQNCnVkcCB0eDogICAgMTEy
IE1CL3MgICAgIDE5MTIgY2FsbHMvcyAgIDE5MTIgbXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3Mg
ICAgIDE5MDQgY2FsbHMvcyAgIDE5MDQgbXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgIDE5
MDQgY2FsbHMvcyAgIDE5MDQgbXNnL3MNCnVkcCB0eDogICAgMTExIE1CL3MgICAgIDE4OTYgY2Fs
bHMvcyAgIDE4OTYgbXNnL3MNCnVkcCB0eDogICAgMTExIE1CL3MgICAgIDE4ODQgY2FsbHMvcyAg
IDE4ODQgbXNnL3MNCnVkcCB0eDogICAgMTExIE1CL3MgICAgIDE4ODQgY2FsbHMvcyAgIDE4ODQg
bXNnL3MNCnVkcCB0eDogICAgMTEyIE1CL3MgICAgIDE5MDQgY2FsbHMvcyAgIDE5MDQgbXNnL3MN
CnVkcCB0eDogICAgMTEyIE1CL3MgICAgIDE5MDggY2FsbHMvcyAgIDE5MDggbXNnL3MNCnVkcCB0
eDogICAgMTEyIE1CL3MgICAgIDE5MTYgY2FsbHMvcyAgIDE5MTYgbXNnL3MNCnVkcCB0eDogICAg
MTEyIE1CL3MgICAgIDE5MTMgY2FsbHMvcyAgIDE5MTMgbXNnL3MNCg0KRG8geW91IGtub3cgaWYg
dGhlc2UgYXJlIGluLWxpbmUgd2l0aCB0aGUgcmVtYWluaW5nIDFHIE5JQ3MgPw0KDQotLS0NClRo
YW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
