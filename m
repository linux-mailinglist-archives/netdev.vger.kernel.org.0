Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207556482
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfFZIZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:25:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbfFZIZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 04:25:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q8KtY0001435;
        Wed, 26 Jun 2019 01:25:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RQMbeuuPXA53Nf21zMd3W/PWdzejKLylDsJ2vGA0f8s=;
 b=LU3qaoNBRMbTTXFeUqyT8ibVOn17JOoOUDHSoorsoUgdqvKPTy48pXQIUlqYghwqeJR4
 BwZgG6VqUS//GdbcPiz5Zez/yi1ThQUXcFA8vLgNRTF9xl7praptAIrv7y1GgKajYsJN
 zUNxqfyss8PrzLC1H8HEVgeJmSlzU6uZ9Qhs5SYX+gwp7NiZnuVrR/KEKG+W8zvW3DDz
 NzIEPsNHfm1DxpIK9noMAukWqWiTRJPgd8e6TnVi8nstGC+sQgwUjNQU/rHOXQ9Ps07p
 niws6RfE6u8FFSMA/v19JYJoLV19yoIebPZukIr/p0Av0H/Nyi88rNYN7oQGQ0DST1N1 5w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tc3s6rasw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 01:25:12 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 01:25:10 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 01:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=MW04jy8o+JdlTviQv5G68QMLQuY+ULketDrPc/uvOtljtt/X7EJ7diZM5UPopA4lCH/BUWVv2MeQ/1Y8Ihr98qnCFE7ZaIxgk+9SFB0tSvqCbxryOW+Dn45T0Oy6CGL/M5+nHh2ov9YiBiFdVyUILbtWJBxSyQKlRU3v2ILlCnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQMbeuuPXA53Nf21zMd3W/PWdzejKLylDsJ2vGA0f8s=;
 b=Y1KSbwHakC8/5eUjz+ui+QviUIS8eCibGTClXe+LYf1hZwmO5sK1EOROnf227VG8SctNr1ugoUiTPavJcRPas4u9vOW9RtRNuFW9eXnQ0m60ibtfDJEtg0BZ8SzEtULQW+mVrhUhWirpQepCDmkJVEzh5n1bHmis0o7FtlHNRiM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQMbeuuPXA53Nf21zMd3W/PWdzejKLylDsJ2vGA0f8s=;
 b=vUr2fqWo4RYTtDtQ3uUZ54wocPskZsXPluC82n+cS41ezBvq2zpERiPKUen5724CA0vdSAm66sW/t8Y8xGnP0VRBHEomz0xhTM30WbMbEaaTh7k43rsaaSmcYewJ9vTkJm9eUMVqpXtZHyp9GoHqA6U37xEGoL07wNFYWiyQxtk=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3104.namprd18.prod.outlook.com (10.255.86.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 08:25:05 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2008.017; Wed, 26 Jun 2019
 08:25:05 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Guilherme Piccoli <gpiccoli@canonical.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Topic: [EXT] [PATCH V2] bnx2x: Prevent ptp_task to be rescheduled
 indefinitely
Thread-Index: AQHVKtuKWtZij+tbmkeKy4o7e84z7aarpxRggACtvgCAAH3HgIAAsinw
Date:   Wed, 26 Jun 2019 08:25:05 +0000
Message-ID: <MN2PR18MB2528569269272880338B8E4CD3E20@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190624222356.17037-1-gpiccoli@canonical.com>
 <MN2PR18MB2528BCB89AC93EB791446BABD3E30@MN2PR18MB2528.namprd18.prod.outlook.com>
 <CAHD1Q_y7v5fVeDRT+KDimQ-RBJMujMCL2DPvdBh==YEJ3+2ZaQ@mail.gmail.com>
 <CAHD1Q_y5wWqOkPaC+JsuGMfBHbwPHbQF93Y-+06Nck=HKrif2g@mail.gmail.com>
In-Reply-To: <CAHD1Q_y5wWqOkPaC+JsuGMfBHbwPHbQF93Y-+06Nck=HKrif2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3856335-6fbb-487c-c4db-08d6fa0fcafc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3104;
x-ms-traffictypediagnostic: MN2PR18MB3104:
x-microsoft-antispam-prvs: <MN2PR18MB31041C7534AB2C87A0A2C015D3E20@MN2PR18MB3104.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(136003)(366004)(376002)(199004)(189003)(13464003)(51874003)(102836004)(6116002)(26005)(229853002)(4326008)(3846002)(186003)(66066001)(74316002)(76176011)(7696005)(25786009)(8676002)(99286004)(53546011)(55236004)(81156014)(6506007)(6436002)(107886003)(53936002)(2906002)(6246003)(55016002)(81166006)(71200400001)(71190400001)(9686003)(7736002)(305945005)(256004)(14444005)(76116006)(8936002)(476003)(446003)(11346002)(486006)(86362001)(66446008)(64756008)(14454004)(52536014)(478600001)(66556008)(66476007)(66946007)(73956011)(68736007)(5660300002)(33656002)(2501003)(316002)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3104;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8I2d/1Ksf/pDfDuyEPqeZyg8dWiqSYvXhxD5up7k8kFjo78E96H7XCkkzG90bfo7rK1wiutga70sPTgYKwUplJIv2TPUVOESQGlcbzQUh7pgdMgN+ly0s+jzHF06pIAy0k0hDC+sizO79fhJnRwzpPgNfOyQM43GQnDYLfFk041qC8PkFx5zQqxlKie38NCmYscozS7q2QySrb5iVWj2ZxMer4TEnLGUdt0/pC75swVn9fLdff/NJyf0Toxhy6F9PT33KrUbdClQ78FRbixZnMj3DQnSWEPkTAITKZC3q/he2dWEyjhnUVfrORTQfSPi9PcnKrlTAt6UTlxFs7Pd5roRkdaykY0SLJKK/sYx33jVRfybnxFLDSsrqTW9JCgOkE2XSj2PYW/2RrQy7iFvSS4coQZ8KVY01R4n2d9XfBk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3856335-6fbb-487c-c4db-08d6fa0fcafc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 08:25:05.5411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3104
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHdWlsaGVybWUgUGljY29saSA8
Z3BpY2NvbGlAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDI2LCAyMDE5
IDE6NTYgQU0NCj4gVG86IFN1ZGFyc2FuYSBSZWRkeSBLYWxsdXJ1IDxza2FsbHVydUBtYXJ2ZWxs
LmNvbT47DQo+IGpheS52b3NidXJnaEBjYW5vbmljYWwuY29tDQo+IENjOiBHUi1ldmVyZXN0LWxp
bnV4LWwyIDxHUi1ldmVyZXN0LWxpbnV4LWwyQG1hcnZlbGwuY29tPjsNCj4gbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtFWFRdIFtQQVRDSCBWMl0gYm54Mng6IFByZXZlbnQgcHRwX3Rhc2sgdG8gYmUgcmVzY2hl
ZHVsZWQNCj4gaW5kZWZpbml0ZWx5DQo+IA0KPiBTdWRhcnNhbmEsIGxldCBtZSBhc2sgeW91IHNv
bWV0aGluZzogd2h5IGRvZXMgdGhlIHJlZ2lzdGVyIGlzIHJlYWRpbmcgdmFsdWUNCj4gMHgwIGFs
d2F5cyBpbiB0aGUgVFggdGltZXN0YW1wIHJvdXRpbmUgaWYgdGhlIFJYIGZpbHRlciBpcyBzZXQg
dG8gTm9uZT8gVGhpcyBpcw0KPiB0aGUgbWFpbiBjYXVzZSBvZiB0aGUgdGhyZWFkIHJlc2NoZWR1
bGUgdGhpbmcuDQoNClRoZSByZWdpc3RlciB2YWx1ZSBvZiB6ZXJvIGluZGljYXRlcyB0aGVyZSBp
cyBubyBwZW5kaW5nIFR4IHRpbWVzdGFtcCB0byBiZSByZWFkIGJ5IHRoZSBkcml2ZXIuDQpGVyB3
cml0ZXMvbGF0Y2hlcyB0aGUgVHggdGltZXN0YW1wIGZvciBQVFAgZXZlbnQgcGFja2V0IGluIHRo
aXMgcmVnaXN0ZXIuIEFuZCBpdCBkb2VzIHRoZSBsYXRjaGluZyBvbmx5IGlmIHRoZSByZWdpc3Rl
ciBpcyBmcmVlLg0KSW4gdGhpcyBjYXNlIHVzZXIvYXBwIGxvb2sgdG8gYmUgcmVxdWVzdGluZyAg
dGhlIFRpbWVzdGFtcCAodmlhIHNrYi0+dHhfZmxhZ3MpIGZvciBub24tcHRwIFR4IHBhY2tldC4g
SW4gdGhlIFR4IHBhdGgsIGRyaXZlciBzY2hlZHVsZXMgYSB0aHJlYWQgZm9yIHJlYWRpbmcgdGhl
IFR4IHRpbWVzdGFtcCwNCiAgIGJueDJ4X3N0YXJ0X3htaXQoKQ0KICAgew0KICAgICAgICBpZiAo
dW5saWtlbHkoc2tiX3NoaW5mbyhza2IpLT50eF9mbGFncyAmIFNLQlRYX0hXX1RTVEFNUCkpIA0K
ICAgICAgICAgICAgICAgICAgICAgICAgc2NoZWR1bGVfd29yaygmYnAtPnB0cF90YXNrKTsNCiAg
IH0NCkZXIHNlZW0gdG8gYmUgbm90IHRpbWVzdGFtcGluZyB0aGUgcGFja2V0IGF0IGFsbCBhbmQg
ZHJpdmVyIGlzIGluZGVmaW5pdGVseSB3YWl0aW5nIGZvciBpdC4NCg0KPiANCj4gT2YgY291cnNl
IHRoaXMgdGhyZWFkIHRoaW5nIGlzIGltcG9ydGFudCB0byBmaXgsIGJ1dCBJIHdhcyBkaXNjdXNz
aW5nIHdpdGggbXkNCj4gbGVhZGVyIGhlcmUgYW5kIHdlIGFyZSBjdXJpb3VzIG9uIHRoZSByZWFz
b25pbmcgdGhlIHJlZ2lzdGVyIGlzIGdldHRpbmcgMHgwLg0KPiANCj4gVGhhbmtzIGluIGFkdmFu
Y2UsDQo+IA0KPiANCj4gR3VpbGhlcm1lDQo=
