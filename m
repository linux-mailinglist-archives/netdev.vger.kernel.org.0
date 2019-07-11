Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87565261
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfGKHYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:24:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47836 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbfGKHYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 03:24:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B7JtMY014057;
        Thu, 11 Jul 2019 00:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=9GEWR3ma0aV5pVcMFTgyBaaPH0yIt33FIg4iWHUlpSw=;
 b=ZYID+SJPmLN5nY1NP4KUDdrygQuX4MsPmXKtNQjk9gseODhYShKfdwE3VqFCIIC5UD/n
 t0zUyDopg7FQQsvpRjwxMURIzwvp0DUxtDnlbDmiNZ4+1fnnFki7/EQSGjNMYbXNuSau
 nk3ABxXIwsOy3UUEbsN3c+Hl06tP3FUav5IHUJ8nvH1IArd7yEXyHgu6bKbOrr3k/6pF
 kPNWUC5bMUeDs2JlRQ4DdunItpRsFdeRkY135oJd1zUU5ve8G3DpP+2CxjOJzcZaUMMs
 09+wsmPFgEUiGqNACL+spDKTPtc+1wTXsGmj9NhFXcDK2Vr4O/oQsNBdoGHkv50ceX/9 oQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tnys9g6ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 00:23:56 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 11 Jul
 2019 00:23:54 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 11 Jul 2019 00:23:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GEWR3ma0aV5pVcMFTgyBaaPH0yIt33FIg4iWHUlpSw=;
 b=M8CRHzCys6XI3V8aIB8UxpjNvqyaPvWE2FhqFoHZeDuS3Mv3GvDP2bGPktedPRhvzTUEyYmmVm0804Tx6fi6yioNgxv2DDq6PUC421EyXjbLi2EeNOIu8R+TTCLw8AvQKX2lXpj6mL68GLgM1nYrTJiwnCrmmkNfQiTtaHQy5A4=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3168.namprd18.prod.outlook.com (10.255.236.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 11 Jul 2019 07:23:45 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 07:23:45 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Gal Pressman <galpress@amazon.com>,
        Ariel Elior <aelior@marvell.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sleybo@amazon.com" <sleybo@amazon.com>
Subject: RE: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Thread-Topic: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Thread-Index: AQHVNmFEi5cj5CRQsk6/b2TwF5IUvKbDdo2AgAGPmIA=
Date:   Thu, 11 Jul 2019 07:23:44 +0000
Message-ID: <MN2PR18MB3182002AE99C080D95901622A1F30@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <7b2f2205-6b5d-c9e7-2d59-296367e517ac@amazon.com>
In-Reply-To: <7b2f2205-6b5d-c9e7-2d59-296367e517ac@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3bc832-bdd1-434c-1270-08d705d0b568
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3168;
x-ms-traffictypediagnostic: MN2PR18MB3168:
x-microsoft-antispam-prvs: <MN2PR18MB31685750E245BAE43D4BDBBDA1F30@MN2PR18MB3168.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(189003)(199004)(64756008)(66556008)(66476007)(66446008)(66946007)(5660300002)(2201001)(68736007)(25786009)(76116006)(8676002)(6436002)(478600001)(55016002)(81156014)(316002)(3846002)(71200400001)(71190400001)(81166006)(4744005)(52536014)(4326008)(86362001)(6116002)(256004)(2906002)(446003)(486006)(11346002)(74316002)(33656002)(110136005)(186003)(14454004)(54906003)(476003)(26005)(305945005)(2501003)(6246003)(7736002)(9686003)(6506007)(53546011)(76176011)(53936002)(8936002)(66066001)(229853002)(7696005)(102836004)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3168;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y+ZyuFT0wVwNqp5akyCfNk72/iAYdqCQ8g6jr2jsDOSfbozeyoh1atAHBf1oKeI/KZ7BU3JMZw3yc0W5mHV/UoxSDyiwutcIhimpQnIdHe4z0J8ezeCmkgsXP4RoX7z/LM/qInrrnwU+DVIhl0NOkYRtmRAvsWhhgG0kdgDKM0w8RX5IOfDhlcDiHku7ccpD3Ctx7fPhYpcRyiv83RAdyJhQxroH7YY0z7FL27XGzFNg0VAZlrap0vdPP72Xnz+5jv0B2FKM1mDnhgt59k+SdJlC/lTL9o9ezYorEFKI2cS/hXIL+OBKzaTgraOpMoguguWMkFD1FykJbb8xgPdGng3swK/CL29gmMLHbtpG3QyKNh0Kg9bWAgH0Bh97B0V91+gSbwsnBFUeViuNB4/NUNkjFZkI7ySqDRgkDLGiaXw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3bc832-bdd1-434c-1270-08d705d0b568
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 07:23:44.8458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3168
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBsaW51eC1yZG1hLW93bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtcmRtYS0NCj4g
b3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgR2FsIFByZXNzbWFuDQo+IA0KPiBP
biAwOS8wNy8yMDE5IDE3OjE3LCBNaWNoYWwgS2FsZGVyb24gd3JvdGU6DQo+ID4gVGhpcyBwYXRj
aCBzZXJpZXMgdXNlcyB0aGUgZG9vcmJlbGwgb3ZlcmZsb3cgcmVjb3ZlcnkgbWVjaGFuaXNtDQo+
ID4gaW50cm9kdWNlZCBpbiBjb21taXQgMzY5MDdjZDVjZDcyICgicWVkOiBBZGQgZG9vcmJlbGwg
b3ZlcmZsb3cNCj4gPiByZWNvdmVyeSBtZWNoYW5pc20iKSBmb3IgcmRtYSAoIFJvQ0UgYW5kIGlX
QVJQICkNCj4gPg0KPiA+IFRoZSBmaXJzdCB0aHJlZSBwYXRjaGVzIG1vZGlmeSB0aGUgY29yZSBj
b2RlIHRvIGNvbnRhaW4gaGVscGVyDQo+ID4gZnVuY3Rpb25zIGZvciBtYW5hZ2luZyBtbWFwX3hh
IGluc2VydGluZywgZ2V0dGluZyBhbmQgZnJlZWluZyBlbnRyaWVzLg0KPiA+IFRoZSBjb2RlIHdh
cyB0YWtlbiBhbG1vc3QgYXMgaXMgZnJvbSB0aGUgZWZhIGRyaXZlci4NCj4gPiBUaGVyZSBpcyBz
dGlsbCBhbiBvcGVuIGRpc2N1c3Npb24gb24gd2hldGhlciB3ZSBzaG91bGQgdGFrZSB0aGlzIGV2
ZW4NCj4gPiBmdXJ0aGVyIGFuZCBtYWtlIHRoZSBlbnRpcmUgbW1hcCBnZW5lcmljLiBVbnRpbCBh
IGRlY2lzaW9uIGlzIG1hZGUsIEkNCj4gPiBvbmx5IGNyZWF0ZWQgdGhlIGRhdGFiYXNlIEFQSSBh
bmQgbW9kaWZpZWQgdGhlIGVmYSBhbmQgcWVkciBkcml2ZXIgdG8NCj4gPiB1c2UgaXQuIFRoZSBk
b29yYmVsbCByZWNvdmVyeSBjb2RlIHdpbGwgYmUgYmFzZWQgb24gdGhlIGNvbW1vbiBjb2RlLg0K
PiA+DQo+ID4gRWZhIGRyaXZlciB3YXMgY29tcGlsZSB0ZXN0ZWQgb25seS4NCj4gDQo+IEZvciB0
aGUgd2hvbGUgc2VyaWVzOg0KPiBUZXN0ZWQtYnk6IEdhbCBQcmVzc21hbiA8Z2FscHJlc3NAYW1h
em9uLmNvbT4NCg0KVGhhbmtzIEdhbCENCg0K
