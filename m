Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD4B0872
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 07:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfILFte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 01:49:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58872 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728202AbfILFte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 01:49:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8C5nM7d019570;
        Wed, 11 Sep 2019 22:49:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=smPiQYoKrzbbuNNhnvbQ057dMzMmiXo+bB1XjeYdyOg=;
 b=GixkihDuifK1VJCxGJzEmbmpTX0XvAT5Pj4EDyCdeDUp55oPNYwsnjWgLDtIVP+bs/nn
 2ST2T+mgnxaLTn7pxb+a6xizszXrz4qhfq0cMRQRQZwo5uSsaeyFtFCSnqM9tLvHnqyR
 fYHomlOdzoQS0xQU646YEp37vR59tMY3bZE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uy72mj2g0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 22:49:26 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 22:49:16 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 22:49:15 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 22:49:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiJqppv5UB7Gy+MV2hJ0byZiGeXT1owiUe6YkjheNYTl/dy0mY6xDu5spUiFALQlgncYjZdv1nkreIwqHhGguACFqvBKQNwGVpaNjOAfqcYu01SaKWYgMxquCPx0DwIfIi3JI+HKKqEoZle5+E3pVWEOBIz7R4GwluytUB95LQcEkjxn3G6LGjRNvJp84GQUJg4M7w3+/qKa2CRF9je0Wc2aVo5cid5yYMQqpyyY8+4hmNUPxP2oG1SF1X7sdQCFAqPxVS5HFTOPE9T55A70fmz9/Pk8g8/WGNp2lpTxmg20TNfmrwSajf0CfK6WVBibivumWIOKZ+pUMKH1WmxccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smPiQYoKrzbbuNNhnvbQ057dMzMmiXo+bB1XjeYdyOg=;
 b=DX6r/Mkn4n9+Sh3VVz74nxWWnh8FFWGP69YuNL0U2xV8t1+S4bHNNjYqn84rMu/v2ToioCd50HwPKgbjaLzCBPUUnR8DmDe2HtjfBleqH5n8dTRqmq8pmnr3UEb8mpxvjyweTBtWtUBmHiXTdkdAfke3YZycfK7PcsK2b5m4IzBC+AO55FwacHN/G6gyP4Bg8vli2EeXS3XFky5OAmvvBa0y3Yut3YHSUgQmmgJd4qM9TW1ydPARTinKsnDZzd3V1R/JdcRc7cmvcTl6pSy8ZZyRtEY16onaF8dDEI/Ys+Wy7f1TSI5eatKYsCJj8qaWeg2J92gQzWsFgWZZGMVvPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smPiQYoKrzbbuNNhnvbQ057dMzMmiXo+bB1XjeYdyOg=;
 b=TG1z/yXQC2g+I8Tw8YxTueSn3KhThDnm6vYemXF7oY84oXn+fdBPKM1CSwxHa7MIFdbLQQRR7tW3Ii/TZe4RIsNrmAUNfDYqLEzyGTz6lX3BB/F17WriMF4dGmwx+dFmUHh1+Z8dgmXhAdTaTZt2bdY73QJvTWR5/0Ih5iPKmMs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3127.namprd15.prod.outlook.com (20.178.239.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.17; Thu, 12 Sep 2019 05:49:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 05:49:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
CC:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data
 from current task New bpf helper bpf_get_current_pidns_info.
Thread-Topic: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Thread-Index: AQHVZQnHC5SFgtm26kSgAiqJpjAzqqcfV1wAgABrMACAA+AVAIABbemAgACAjACAAJdbyoABaP+A
Date:   Thu, 12 Sep 2019 05:49:00 +0000
Message-ID: <7b0a325e-9187-702f-eba7-bfcc7e3f7eb4@fb.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
 <20190909174522.GA17882@frodo.byteswizards.com>
 <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
 <20190910231506.GL1131@ZenIV.linux.org.uk>
 <87o8zr8cz3.fsf@x220.int.ebiederm.org>
In-Reply-To: <87o8zr8cz3.fsf@x220.int.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:104:6::23) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::bc9c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 215f9104-2cd0-48ac-21ff-08d73744e90d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3127;
x-ms-traffictypediagnostic: BYAPR15MB3127:
x-microsoft-antispam-prvs: <BYAPR15MB312767CBC213AC8AFF78552BD3B00@BYAPR15MB3127.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(346002)(396003)(376002)(189003)(199004)(256004)(14444005)(31686004)(110136005)(316002)(8676002)(54906003)(7736002)(64756008)(86362001)(31696002)(305945005)(446003)(11346002)(2616005)(476003)(66556008)(486006)(66946007)(66446008)(386003)(6506007)(53546011)(76176011)(186003)(66476007)(46003)(102836004)(229853002)(14454004)(478600001)(36756003)(71190400001)(6486002)(71200400001)(81166006)(81156014)(8936002)(6512007)(4326008)(6436002)(6116002)(99286004)(52116002)(6246003)(25786009)(2906002)(53936002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3127;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1vbusUNQ8YHuUKpVC4lZ+wmhhr+mQX8Y4RYdR6qmA40NMzCg8+buQaETv5DRvoo3+SERoOJg5MRjpEvfrJn06RHa6ANyRzqzj+bgEhxqj8V38+MA/5wT86sORVJ12/AcVy3E6NLG9KuzPAhvh6tKj5Ijj6ocYRjtk4IwAgqAQXGsWrs1l55DkLi5ijFhFxn4S7SeMCE8EqquckUjlWcOtmrLfNxSFnoyVeVi8lOt23EqRvDSxnXuDxyTaPxcvqvSW/dFwzqM/hHeKCvWqvSTzW0Lf0AGqX0Px4XYN72iZWa05T+ngPB4RdcvuE1u3O8NVdlPnmS1kMs9E4x2eWZT1qJlxNOj25w2nl5OFWPugXBbx8Pd3bMGQFV+bOR1+oZz7nfkro7n1yPfkOecxZvmIVRjRUHIIrU1aU7ifqTee9M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6260A434B1C3B74C8D8C5431EB71C5DB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 215f9104-2cd0-48ac-21ff-08d73744e90d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 05:49:00.6498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6xZPCCWxk2GVZ0TPYH0w+KNF0UabyHe1tryqtfSbPP8IyRwFVGNDrPYORRwkrqX4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3127
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_02:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909120060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTEvMTkgOToxNiBBTSwgRXJpYyBXLiBCaWVkZXJtYW4gd3JvdGU6DQo+IEFsIFZp
cm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPiB3cml0ZXM6DQo+IA0KPj4gT24gVHVlLCBTZXAg
MTAsIDIwMTkgYXQgMTA6MzU6MDlQTSArMDAwMCwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4+Pg0K
Pj4+IENhcmxvcywNCj4+Pg0KPj4+IERpc2N1c3NlZCB3aXRoIEVyaWMgdG9kYXkgZm9yIHdoYXQg
aXMgdGhlIGJlc3Qgd2F5IHRvIGdldA0KPj4+IHRoZSBkZXZpY2UgbnVtYmVyIGZvciBhIG5hbWVz
cGFjZS4gVGhlIGZvbGxvd2luZyBwYXRjaCBzZWVtcw0KPj4+IGEgcmVhc29uYWJsZSBzdGFydCBh
bHRob3VnaCBFcmljIHdvdWxkIGxpa2UgdG8gc2VlDQo+Pj4gaG93IHRoZSBoZWxwZXIgaXMgdXNl
ZCBpbiBvcmRlciB0byBkZWNpZGUgd2hldGhlciB0aGUNCj4+PiBpbnRlcmZhY2UgbG9va3Mgcmln
aHQuDQo+Pj4NCj4+PiBjb21taXQgYmIwMGZjMzZkNWQyNjMwNDdhOGJjZWIzZTUxZTk2OWQ3ZmJj
ZTdkYiAoSEVBRCAtPiBmczIpDQo+Pj4gQXV0aG9yOiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29t
Pg0KPj4+IERhdGU6ICAgTW9uIFNlcCA5IDIxOjUwOjUxIDIwMTkgLTA3MDANCj4+Pg0KPj4+ICAg
ICAgIG5zZnM6IGFkZCBhbiBpbnRlcmZhY2UgZnVuY3Rpb24gbnNfZ2V0X2ludW1fZGV2KCkNCj4+
Pg0KPj4+ICAgICAgIFRoaXMgcGF0Y2ggYWRkZWQgYW4gaW50ZXJmYWNlIGZ1bmN0aW9uDQo+Pj4g
ICAgICAgbnNfZ2V0X2ludW1fZGV2KCkuIEdpdmVuIGEgbnNfY29tbW9uIHN0cnVjdHVyZSwNCj4+
PiAgICAgICB0aGUgZnVuY3Rpb24gcmV0dXJucyB0aGUgaW5vZGUgYW5kIGRldmljZQ0KPj4+ICAg
ICAgIG51bWJlcnMuIFRoZSBmdW5jdGlvbiB3aWxsIGJlIHVzZWQgbGF0ZXINCj4+PiAgICAgICBi
eSBhIG5ld2x5IGFkZGVkIGJwZiBoZWxwZXIuDQo+Pj4NCj4+PiAgICAgICBTaWduZWQtb2ZmLWJ5
OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2ZzL25z
ZnMuYyBiL2ZzL25zZnMuYw0KPj4+IGluZGV4IGEwNDMxNjQyYzZiNS4uYTYwM2M2ZmMzZjU0IDEw
MDY0NA0KPj4+IC0tLSBhL2ZzL25zZnMuYw0KPj4+ICsrKyBiL2ZzL25zZnMuYw0KPj4+IEBAIC0y
NDUsNiArMjQ1LDE0IEBAIHN0cnVjdCBmaWxlICpwcm9jX25zX2ZnZXQoaW50IGZkKQ0KPj4+ICAg
ICAgICAgICByZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4+PiAgICB9DQo+Pj4NCj4+PiArLyog
R2V0IHRoZSBkZXZpY2UgbnVtYmVyIGZvciB0aGUgY3VycmVudCB0YXNrIHBpZG5zLg0KPj4+ICsg
Ki8NCj4+PiArdm9pZCBuc19nZXRfaW51bV9kZXYoc3RydWN0IG5zX2NvbW1vbiAqbnMsIHUzMiAq
aW51bSwgZGV2X3QgKmRldikNCj4+PiArew0KPj4+ICsgICAgICAgKmludW0gPSBucy0+aW51bTsN
Cj4+PiArICAgICAgICpkZXYgPSBuc2ZzX21udC0+bW50X3NiLT5zX2RldjsNCj4+PiArfQ0KPj4N
Cj4+IFVtbS4uLiAgV2hlcmUgd291bGQgaXQgZ2V0IHRoZSBkZXZpY2UgbnVtYmVyIG9uY2Ugd2Ug
Z2V0IChoZWxsIGtub3dzDQo+PiB3aGF0IGZvcikgbXVsdGlwbGUgbnNmcyBpbnN0YW5jZXM/ICBJ
IHN0aWxsIGRvbid0IHVuZGVyc3RhbmQgd2hhdA0KPj4gd291bGQgdGhhdCBiZSBhYm91dCwgVEJI
Li4uICBJcyBpdCByZWFsbHkgcGVyLXVzZXJucz8gIE9yIHNvbWV0aGluZw0KPj4gZWxzZSBlbnRp
cmVseT8gIEVyaWMsIGNvdWxkIHlvdSBnaXZlIHNvbWUgY29udGV4dD8NCj4gDQo+IE15IGdvYWwg
aXMgbm90IHRvIHBhaW50IHRoaW5ncyBpbnRvIGEgY29ybmVyLCB3aXRoIGZ1dHVyZSBjaGFuZ2Vz
Lg0KPiBSaWdodCBub3cgaXQgaXMgcG9zc2libGUgdG8gc3RhdCBhIG5hbWVzcGFjZSBmaWxlIGRl
c2NyaXB0b3IgYW5kDQo+IGdldCBhIGRldmljZSBhbmQgaW5vZGUgbnVtYmVyLiAgVGhlbiBjb21w
YXJlIHRoYXQuDQo+IA0KPiBJIGRvbid0IHdhbnQgcGVvcGxlIHVzaW5nIHRoZSBpbm9kZSBudW1i
ZXIgaW4gbnNmZCBhcyBzb21lIG1hZ2ljDQo+IG5hbWVzcGFjZSBpZC4NCj4gDQo+IFdlIGhhdmUg
aGFkIHRpbWVzIGluIHRoZSBwYXN0IHdoZXJlIHRoZXJlIHdhcyBtb3JlIHRoYW4gb25lIHN1cGVy
YmxvY2sNCj4gYW5kIHRodXMgbW9yZSB0aGFuIG9uZSBkZXZpY2UgbnVtYmVyLiAgRnVydGhlciBp
ZiB1c2Vyc3BhY2UgZXZlciB1c2VzDQo+IHRoaXMgaGVhdmlseSB0aGVyZSBtYXkgYmUgdGltZXMg
aW4gdGhlIGZ1dHVyZSB3aGVyZSBmb3INCj4gY2hlY2twb2ludC9yZXN0YXJ0IHB1cnBvc2VzIHdl
IHdpbGwgd2FudCBtdWx0aXBsZSBuc2ZkJ3Mgc28gd2UgY2FuDQo+IHByZXNlcnZlIHRoZSBpbm9k
ZSBudW1iZXIgYWNjcm9zcyBhIG1pZ3JhdGlvbi4NCj4gDQo+IFJlYWxpc3RpY2FsbHkgdGhlcmUg
d2lsbCBwcm9iYWJseSBqdXN0IHNvbWUga2luZCBvZiBob3RwbHVnIG5vdGlmaWNhdGlvbg0KPiB0
byB1c2Vyc3BhY2UgdG8gc2F5IHdlIGhhdmUgaG90cGx1Z2dlZCB5b3VyIG9wZXJhdGluaW5nIHN5
c3RlbSBhcw0KPiBhIG1pZ3JhdGlvbiBub3RpZmljYXRpb24uDQo+IA0KPiBOb3cgdGhlIGhhbHdh
eSBkaXNjdXNzaW9uIGRpZCBub3QgcXVpdGUgY2FwdHVyZSBldmVyeXRoaW5nIEkgd2FzIHRyeWlu
Zw0KPiB0byBzYXkgYnV0IGl0IGF0IGxlYXN0IGdvdCB0byB0aGUgcmlnaHQgYmFsbHBhcmsuDQo+
IA0KPiBUaGUgaGVscGVyIGluIGZzL25zZnMuYyBzaG91bGQgYmU6DQo+IA0KPiBib29sIG5zX21h
dGNoKGNvbnN0IHN0cnVjdCBuc19jb21tb24gKm5zLCBkZXZfdCBkZXYsIGlub190IGlubykNCj4g
ew0KPiAgICAgICAgICByZXR1cm4gKChucy0+aW51bSA9PSBpbm8pICYmIChuc2ZzX21udC0+bW50
X3NiLT5zX2RldiA9PSBkZXYpKTsNCj4gfQ0KPiANCj4gVGhhdCB3YXkgaWYvd2hlbiB0aGVyZSBh
cmUgbXVsdGlwbGUgaW5vZGVzIGlkZW50aWZ5aW5nIHRoZSBzYW1lDQo+IG5hbWVzcGFjZSB0aGUg
YnBmIHByb2dyYW1zIGRvbid0IG5lZWQgdG8gY2hhbmdlLg0KDQpUaGFua3MsIEVyaWMuIFRoaXMg
aXMgaW5kZWVkIGJldHRlci4gVGhlIGJwZiBoZWxwZXIgc2hvdWxkIGZvY3VzDQpvbiBjb21wYXJp
bmcgZGV2L2lubywgaW5zdGVhZCBvZiByZXR1cm4gdGhlIGRldi9pbm8gdG8gYnBmIHByb2dyYW0u
DQoNClNvIG92ZXJhbGwsIG5zZnMgcmVsYXRlZCBjaGFuZ2Ugd2lsbCBsb29rIGxpa2U6DQoNCmRp
ZmYgLS1naXQgYS9mcy9uc2ZzLmMgYi9mcy9uc2ZzLmMNCmluZGV4IGEwNDMxNjQyYzZiNS4uN2U3
OGQ4OWMyMTcyIDEwMDY0NA0KLS0tIGEvZnMvbnNmcy5jDQorKysgYi9mcy9uc2ZzLmMNCkBAIC0y
NDUsNiArMjQ1LDExIEBAIHN0cnVjdCBmaWxlICpwcm9jX25zX2ZnZXQoaW50IGZkKQ0KICAgICAg
ICAgcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQogIH0NCg0KK2Jvb2wgbnNfbWF0Y2goY29uc3Qg
c3RydWN0IG5zX2NvbW1vbiAqbnMsIGRldl90IGRldiwgaW5vX3QgaW5vKQ0KK3sNCisgICAgICAg
cmV0dXJuICgobnMtPmludW0gPT0gaW5vKSAmJiAobnNmc19tbnQtPm1udF9zYi0+c19kZXYgPT0g
ZGV2KSk7DQorfQ0KKw0KICBzdGF0aWMgaW50IG5zZnNfc2hvd19wYXRoKHN0cnVjdCBzZXFfZmls
ZSAqc2VxLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpDQogIHsNCiAgICAgICAgIHN0cnVjdCBpbm9k
ZSAqaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9w
cm9jX25zLmggYi9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaA0KaW5kZXggZDMxY2I2MjE1OTA1Li43
OTYzOTgwN2U5NjAgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaA0KKysrIGIv
aW5jbHVkZS9saW51eC9wcm9jX25zLmgNCkBAIC04MSw2ICs4MSw3IEBAIGV4dGVybiB2b2lkICpu
c19nZXRfcGF0aChzdHJ1Y3QgcGF0aCAqcGF0aCwgc3RydWN0IA0KdGFza19zdHJ1Y3QgKnRhc2ss
DQogIHR5cGVkZWYgc3RydWN0IG5zX2NvbW1vbiAqbnNfZ2V0X3BhdGhfaGVscGVyX3Qodm9pZCAq
KTsNCiAgZXh0ZXJuIHZvaWQgKm5zX2dldF9wYXRoX2NiKHN0cnVjdCBwYXRoICpwYXRoLCBuc19n
ZXRfcGF0aF9oZWxwZXJfdCANCm5zX2dldF9jYiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgdm9pZCAqcHJpdmF0ZV9kYXRhKTsNCitleHRlcm4gYm9vbCBuc19tYXRjaChjb25zdCBzdHJ1
Y3QgbnNfY29tbW9uICpucywgZGV2X3QgZGV2LCBpbm9fdCBpbm8pOw0KDQogIGV4dGVybiBpbnQg
bnNfZ2V0X25hbWUoY2hhciAqYnVmLCBzaXplX3Qgc2l6ZSwgc3RydWN0IHRhc2tfc3RydWN0ICp0
YXNrLA0KICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBwcm9jX25zX29wZXJh
dGlvbnMgKm5zX29wcyk7DQoNCj4gDQo+IFVwIGZhcnRoZXIgaW4gdGhlIHN0YWNrIGl0IHNob3Vs
ZCBiZSBzb21ldGhpbmcgbGlrZToNCj4gDQo+PiBCUEZfQ0FMTF8yKGJwZl9jdXJyZW50X3BpZG5z
X21hdGNoLCBkZXZfdCAqZGV2LCBpbm9fdCAqaW5vKQ0KPj4gew0KPj4gICAgICAgICAgcmV0dXJu
IG5zX21hdGNoKCZ0YXNrX2FjdGl2ZV9waWRfbnMoY3VycmVudCktPm5zLCAqZGV2LCAqaW5vKTsN
Cj4+IH0NCj4+DQo+PiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2N1cnJlbnRfcGlk
bnNfbWF0Y2hfcHJvdG8gPSB7DQo+PiAJLmZ1bmMJCT0gYnBmX2N1cnJlbnRfcGluc19tYXRjaCwN
Cj4+IAkuZ3BsX29ubHkJPSB0cnVlLA0KPj4gCS5yZXRfdHlwZQk9IFJFVF9JTlRFR0VSDQo+PiAJ
LmFyZzFfdHlwZQk9IEFSR19QVFJfVE9fREVWSUNFX05VTUJFUiwNCj4+IAkuYXJnMl90eXBlCT0g
QVJHX1BUUl9UT19JTk9ERV9OVU1CRVIsDQo+PiB9Ow0KPiANCj4gVGhhdCBhbGxvd3MgY29tcGFy
aW5nIHdoYXQgdGhlIGJwZiBjYW1lIHVwIHdpdGggd2l0aCB3aGF0ZXZlciB2YWx1ZQ0KPiB1c2Vy
c3BhY2UgZ2VuZXJhdGVkIGJ5IHN0YXRpbmcgdGhlIGZpbGUgZGVzY3JpcHRvci4NCj4gDQo+IA0K
PiBUaGF0IGlzIHRoZSBsZWFzdCBiYWQgc3VnZ2VzdGlvbiBJIGN1cnJlbnRseSBoYXZlIGZvciB0
aGF0DQo+IGZ1bmN0aW9uYWxpdHkuICBJdCByZWFsbHkgd291bGQgYmUgYmV0dGVyIHRvIG5vdCBo
YXZlIHRoYXQgZmlsdGVyIGluIHRoZQ0KPiBicGYgcHJvZ3JhbSBpdHNlbGYgYnV0IGluIHRoZSBp
bmZyYXN0cnVjdHVyZSB0aGF0IGJpbmRzIGEgcHJvZ3JhbSB0byBhDQo+IHNldCBvZiB0YXNrcy4N
Cj4gDQo+IFRoZSBwcm9ibGVtIHdpdGggdGhpcyBhcHByb2FjaCBpcyB3aGF0ZXZlciBkZXZpY2Uv
aW5vZGUgeW91IGhhdmUgd2hlbg0KPiB0aGUgbmFtZXNwYWNlIHRoZXkgcmVmZXIgdG8gZXhpdHMg
dGhlcmUgaXMgdGhlIHBvc3NpYmlsaXR5IHRoYXQgdGhlDQo+IGlub2RlIHdpbGwgYmUgcmV1c2Vk
LiAgU28geW91ciBmaWx0ZXIgd2lsbCBldmVudHVhbGx5IHN0YXJ0IG1hdGNoaW5nIG9uDQo+IHRo
ZSB3cm9uZyB0aGluZy4NCg0KSSBjb21lIHVwIHdpdGggYSBkaWZmZXJlZW50IGhlbHBlciBkZWZp
bml0aW9uLCB3aGljaCBpcyBtdWNoIG1vcmUNCnNpbWlsYXIgdG8gZXhpc3RpbmcgYnBmX2dldF9j
dXJyZW50X3BpZF90Z2lkKCkgYW5kIGhlbHBlciBkZWZpbml0aW9uDQptdWNoIG1vcmUgY29uZm9y
bXMgdG8gYnBmIGNvbnZlbnRpb24uDQoNCmRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2hlbHBlcnMu
YyBiL2tlcm5lbC9icGYvaGVscGVycy5jDQppbmRleCA1ZTI4NzE4OTI4Y2EuLmJjMjY5MDNjODBj
NyAxMDA2NDQNCi0tLSBhL2tlcm5lbC9icGYvaGVscGVycy5jDQorKysgYi9rZXJuZWwvYnBmL2hl
bHBlcnMuYw0KQEAgLTExLDYgKzExLDggQEANCiAgI2luY2x1ZGUgPGxpbnV4L3VpZGdpZC5oPg0K
ICAjaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+DQogICNpbmNsdWRlIDxsaW51eC9jdHlwZS5oPg0K
KyNpbmNsdWRlIDxsaW51eC9waWRfbmFtZXNwYWNlLmg+DQorI2luY2x1ZGUgPGxpbnV4L3Byb2Nf
bnMuaD4NCg0KICAjaW5jbHVkZSAiLi4vLi4vbGliL2tzdHJ0b3guaCINCg0KQEAgLTQ4NywzICs0
ODksMzMgQEAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9zdHJ0b3VsX3Byb3RvID0g
ew0KICAgICAgICAgLmFyZzRfdHlwZSAgICAgID0gQVJHX1BUUl9UT19MT05HLA0KICB9Ow0KICAj
ZW5kaWYNCisNCitCUEZfQ0FMTF8yKGJwZl9nZXRfbnNfY3VycmVudF9waWRfdGdpZCwgdTMyLCBk
ZXYsIHUzMiwgaW51bSkNCit7DQorICAgICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzayA9IGN1
cnJlbnQ7DQorICAgICAgIHN0cnVjdCBwaWRfbmFtZXNwYWNlICpwaWRuczsNCisgICAgICAgcGlk
X3QgcGlkLCB0Z2lkOw0KKw0KKyAgICAgICBpZiAodW5saWtlbHkoIXRhc2spKQ0KKyAgICAgICAg
ICAgICAgIHJldHVybiAtRUlOVkFMOw0KKw0KKw0KKyAgICAgICBwaWRucyA9IHRhc2tfYWN0aXZl
X3BpZF9ucyh0YXNrKTsNCisgICAgICAgaWYgKHVubGlrZWx5KCFwaWRucykpDQorICAgICAgICAg
ICAgICAgcmV0dXJuIC1FTk9FTlQ7DQorDQorICAgICAgIGlmICghbnNfbWF0Y2goJnBpZG5zLT5u
cywgKGRldl90KWRldiwgaW51bSkpDQorICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQor
DQorICAgICAgIHBpZCA9IHRhc2tfcGlkX25yX25zKHRhc2ssIHBpZG5zKTsNCisgICAgICAgdGdp
ZCA9IHRhc2tfdGdpZF9ucl9ucyh0YXNrLCBwaWRucyk7DQorDQorICAgICAgIHJldHVybiAodTY0
KSB0Z2lkIDw8IDMyIHwgcGlkOw0KK30NCisNCitjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8g
YnBmX2dldF9uc19jdXJyZW50X3BpZF90Z2lkX3Byb3RvID0gew0KKyAgICAgICAuZnVuYyAgICAg
ICAgICAgPSBicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQsDQorICAgICAgIC5ncGxfb25seSAg
ICAgICA9IGZhbHNlLA0KKyAgICAgICAucmV0X3R5cGUgICAgICAgPSBSRVRfSU5URUdFUiwNCisg
ICAgICAgLmFyZzFfdHlwZSAgICAgID0gQVJHX0FOWVRISU5HLA0KKyAgICAgICAuYXJnMl90eXBl
ICAgICAgPSBBUkdfQU5ZVEhJTkcsDQorfTsNCg0KRXhpc3RpbmcgdXNhZ2Ugb2YgYnBmX2dldF9j
dXJyZW50X3BpZF90Z2lkKCkgY2FuIGJlIGNvbnZlcnRlZA0KdG8gYnBmX2dldF9uc19jdXJyZW50
X3BpZF90Z2lkKCkgaWYgbnMgZGV2L2lub2RlIG51bWJlcg0KaXMgc3VwcGxpZWQuIEZvciBicGZf
Z2V0X25zX2N1cnJlbnRfcGlkX3RnaWQoKSwgY2hlY2tpbmcNCnJldHVybiB2YWx1ZSAoIDwgMCBv
ciBub3QpIGlzIG5lZWRlZC4NCg0KPiANCj4gRXJpYw0KPiANCg==
