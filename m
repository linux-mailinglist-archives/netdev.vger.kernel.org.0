Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B979A3FE0
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfH3Vqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:46:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728053AbfH3Vqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:46:44 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7ULkXSC026210;
        Fri, 30 Aug 2019 14:46:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UX2IPoburKePrP/3CLUcNqSNVNV0TyoSz192aq88egQ=;
 b=LrO2e/umvU3SDJQntX6s5+V5AmMtLE6KTifxNGTjd44mUsNYeLTy/3l3PmZvrMYkfRMF
 sRVhRi2wtWah2Se4BR5UP5Vl38KlvlpRtmYViZ/tUMsROFfOdgszGDwMar74xFtRNdav
 LR93wTzOzPZXbj1fN1YmhVorLbmmAPYZy6Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uq0s6bcev-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Aug 2019 14:46:34 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Aug 2019 14:46:07 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Aug 2019 14:46:07 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 14:46:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mci+vKFivBd6j/+i5gBbbLijLfltWLAQce6OJmsRPMAC00HFp8h0m9rlQVQtr2O7ENtw0/4hLFgMt/sIdczfO/1EN+A0SXZCiOrdL9UaGG8SNr+tvqA09cSlKrI3z7z74sraSwUK6Dz3pioWPTrbjnSm86zwxJY6qFiJnmUg5yz8Gk9mWUYELOfo7ZTaCyIYUMsbo7JQN1uKwHa/VsZMs5Xo8rkIkkeovYT2azywlUxFKO36sm92VEpOf7g7rflb5DgBRHgUg+VIXpy5UZruuE42wpf7ydgA10MQi2zgObkYl7UQrl4FRo4z7ohRfRRbs6zgT6l8NEU70LyDXYUtug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX2IPoburKePrP/3CLUcNqSNVNV0TyoSz192aq88egQ=;
 b=B4WwB2T1ydQQO4QRsGvQlifuqtO32QS8hPTz9Ukc1e2Ul/pcMKEDUzq6zuHVuyFYp8w3TY0Vq1BKgC8yxDNCn4E95Bzv1AnLKgdnThiaGmntRrrFCs5mv/kUrB5QegipyBvPNUQS4BDqk0Hgk/fM8l16Gn7SWvTLYa2QBbK4I9uh4g9w9pWRvAmalHdTtOc0/EMoaVN5JuzZdd40jCMrJUKhKOPW6qpXvRImgxZwO5qJtRXxClsP9QyZB+ILUMr579v7t/XX+JHhbPSdjPt1faWiMnlsfva6uWs7Y9x5gLLbFuShQRjhhni0AkIWGgdU3nV0peJ99nA9zIK6Q6jhlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX2IPoburKePrP/3CLUcNqSNVNV0TyoSz192aq88egQ=;
 b=ZAFey0U5S/OmyyU0dq78wcMBXoTqL2H+eeKe53Bq14VMJN1BWg97REAXeaIIkhs1KIrelRV4qg5znvHPQRqBHQoktnGM1CYjvu/OCWC3xepRsI51sM/ki51bFGXX5oKfaTZHTMvLs7K3YNOhLVknUbRpW3n1SJO5mVFdGk/g61c=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3607.namprd15.prod.outlook.com (52.132.228.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Fri, 30 Aug 2019 21:46:05 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 21:46:05 +0000
From:   Ben Wei <benwei@fb.com>
To:     Terry Duncan <terry.s.duncan@linux.intel.com>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
Subject: RE: [PATCH] ncsi-netlink: support sending NC-SI commands over Netlink
 interface
Thread-Topic: [PATCH] ncsi-netlink: support sending NC-SI commands over
 Netlink interface
Thread-Index: AdVZRhK7FBH7PA61Tj6DiPuS9P29HgGM2h4AAACIDLA=
Date:   Fri, 30 Aug 2019 21:46:05 +0000
Message-ID: <CH2PR15MB3686CCC22840AD848796D6CAA3BD0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB36860EECD2EA6D63BEA70110A3A40@CH2PR15MB3686.namprd15.prod.outlook.com>
 <0da11d73-b3ab-53f6-f695-30857a743a7b@linux.intel.com>
In-Reply-To: <0da11d73-b3ab-53f6-f695-30857a743a7b@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:6945]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 407d7b55-9fee-4b89-ed3b-08d72d9375d6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3607;
x-ms-traffictypediagnostic: CH2PR15MB3607:
x-microsoft-antispam-prvs: <CH2PR15MB3607938569BE56D9BD259310A3BD0@CH2PR15MB3607.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(199004)(189003)(256004)(478600001)(7736002)(52536014)(4744005)(74316002)(2201001)(305945005)(7696005)(102836004)(53546011)(86362001)(6506007)(316002)(76176011)(229853002)(5660300002)(110136005)(81166006)(8676002)(81156014)(8936002)(2906002)(6246003)(6436002)(55016002)(9686003)(53936002)(25786009)(99286004)(46003)(66446008)(14454004)(71190400001)(33656002)(446003)(486006)(186003)(64756008)(11346002)(476003)(66946007)(66556008)(66476007)(71200400001)(76116006)(6116002)(14444005)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3607;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SW/N1FCuBLowG9Z7edXpVUOhxfLpkHnX7+KhwxilCdrlmQXIuF6cyczfc13pzEZyj6dnFy0iGN56AfPuBKVTEof9p3BSCl+HTcTEyu32PRQmmlvtdlw0UAXQ69F+iTBqJlpHi2pDifP5C+ECb4PJb+Cc7I6RALEMeU6KWQFPHP/jHUsEjTr02wFJJ8DDgzY09oEvQqQKMRvkdkW/bi4OzA3ZsD79Y2sQhBDwuHw+hdJG2nBcBA7eMbitkLetuJvo9dW78s7adxHN94azNO9v7BMIx6ZFwSARFq5rLYj/GzUmMfnfzXEjtLT+D/PuzaAly4dpu1Ao9HQQLXW4rub3buu38dcD1gEyv6ZyIx4c4PdYBeIaD6wneQwA9hrcHA9tFKH/Z0IGU1c0kbgP0C+op6sy7C+uq4c1jIC3/VArBN4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 407d7b55-9fee-4b89-ed3b-08d72d9375d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 21:46:05.4347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZLziPJA7vYK4AYhXNZ4OhaIn9Rxb12j91XLp/GmqOLf/HSjSXWtYpR3Wh7vqZG2W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3607
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiA4LzIyLzE5IDU6MDIgUE0sIEJlbiBXZWkgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBleHRl
bmRzIG5jc2ktbmV0bGluayBjb21tYW5kIGxpbmUgdXRpbGl0eSB0byBzZW5kIE5DLVNJIGNvbW1h
bmQgdG8ga2VybmVsIGRyaXZlcg0KPiA+IHZpYSBOQ1NJX0NNRF9TRU5EX0NNRCBjb21tYW5kLg0K
PiA+IA0KPiA+IE5ldyBjb21tYW5kIGxpbmUgb3B0aW9uIC1vIChvcGNvZGUpIGlzIHVzZWQgdG8g
c3BlY2lmeSBOQy1TSSBjb21tYW5kIGFuZCBvcHRpb25hbCBwYXlsb2FkLg0KPiA+IA0KPg0KPiBU
aGFuayB5b3UgZm9yIHBvc3RpbmcgdGhpcyBCZW4uDQo+IFNvbWV0aGluZyBsb29rcyBvZmYgb24g
dGhpcyBuZXh0IGxpbmUgYnV0IGl0IGxvb2tzIGZpbmUgaW4geW91ciBwdWxsIA0KPiByZXF1ZXN0
IGluIHRoZSBnaXRodWIuY29tL3NhbW1qL25jc2ktbmV0bGluayByZXBvLg0KPg0KPiA+ICtzdGF0
aWMgaW50IHNlbmRfY2Ioc3RydWN0IG5sX21zZyAqbXNnLCB2b2lkICphcmcpIHsgI2RlZmluZQ0K
PiA+ICtFVEhFUk5FVF9IRUFERVJfU0laRSAxNg0KPiA+ICsNCg0KWWVzIEkgdGhpbmsgbXkgZW1h
aWwgY2xpZW50IHdhcyBub3QgY29uZmlndXJlZCBjb3JyZWN0bHkgZm9yIHBsYWluIHRleHQgc28g
aXQncyByZW1vdmluZyBjZXJ0YWluIGxpbmUgYnJlYWtzLg0KSG9wZWZ1bGx5IEkgaGF2ZSB0aGlz
IGZpZ3VyZWQgb3V0IG5vdyBzbyBteSBmdXR1cmUgcGF0Y2hlcyB3b24ndCBoYXZlIHRoaXMgaXNz
dWUuDQoNCj4NCj4gRG8geW91IGhhdmUgcGxhbnMgdG8gdXBzdHJlYW0geW91ciB5b2N0byByZWNp
cGUgZm9yIHRoaXMgcmVwbz8NCg0KWWVzIEkgc3VyZSBjYW4gdXBzdHJlYW0gdGhlIHJlY2lwZSBm
aWxlLiBJIGhhZCB0byBtYWtlIGxvY2FsIGNoYW5nZXMgdG8gYnVpbGQgbmNzaS1uZXRsaW5rIGZv
ciBteSBCTUMgcGxhdGZvcm0uDQpJcyB0aGVyZSBhIGdyb3VwIEkgbWF5IHN1Ym1pdCBteSByZWNp
cGUgdG8/IA0KDQpUaGFua3MsDQotQmVuDQo=
