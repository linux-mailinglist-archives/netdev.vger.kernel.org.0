Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D24AC2F4
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392885AbfIFXVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 19:21:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732131AbfIFXVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:21:21 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86NIsfb024301;
        Fri, 6 Sep 2019 16:21:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Hw6hQPW4OP/D9tS1OUQA6A7G4+92qOdzh0f7fl8nFmY=;
 b=WJH86Yvj93F6ApRaeXAEejl+wGZfD4s+zFDd2JG5j1zHt0kHlJTGxDqup10GXBrx/XOj
 II1LG6OU0Spn4zcTsC1KwTIohiVQWANmDh6FdLjht8cw6JJ264fB1KfbFiUbFjgNUmAf
 gFMXLVP8bImOs1h4iI1KWpLYxzMbUgnAD2E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uusepjcet-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Sep 2019 16:21:16 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Sep 2019 16:21:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Sep 2019 16:21:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ywo/p+9wI/PINKDdZ4eNUqv77qEY2ZAH6kBm0gpVN2kg8hNSdAFtoOUObbRNwiTSEQR4M4KxRHC03NbRts/FV1NBS3/94JG97L0km8GiqBogC/ir7yG06eKWpDyt0wdJ9xZQ0lse5b/hthGMk1Hpo2t3M8EK8VUTKKGuSa7jLv4Pl/75CoPNsORXI0GXZnwOr32KyWB+2VGmGBl5qYPt/DmyeYZnLgk9/mQtY82cSaK81+fgIxVBWEvIKBvERGk/o+jdilLYXQVSgyLqhmoxHGa9ikJsw0yCUAgPZQwuo6zxsN+LdiyZvxMimZoDvYk/LY8cMinQRTMGfBg3NEUZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hw6hQPW4OP/D9tS1OUQA6A7G4+92qOdzh0f7fl8nFmY=;
 b=bDkGXuUKnTu60nNHK3IqUE32gD/nZPHrH6Wgb2mv9ROaQVQGFj/P7fjuUH+XD3ie47bgSszSntyCo6ca1GWL0r0XU/gyAS7jVYqG8dpWTk9rDzFRStmFfmRs3BGfBW2raXdW6fJLkyS0ba7+QslHtghoahTnQVmKzLmvEHa/Un3tuZ7EjUUInOxucbRgPTMglb27ytD1e5o5JK1dNdY0di3sUkKTCZMYSBbLaPR5c2uU4pBCFEmYKNHPQrNnYfNDeD52xHiQtuZepa6p4njtoLt1g5EMRuqZ4k3viqKXsf21CcQEhw2udNlNbawWLOSsKEloqJYrvJicr2nqWNyDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hw6hQPW4OP/D9tS1OUQA6A7G4+92qOdzh0f7fl8nFmY=;
 b=WS0NLugMY6VV2EPeZTOflx1admmFqfyRpxxNGJN4V0TjgGWY5lHbkpUfLi2ltr8ocBtCu4a2nRWi7hlRVjbAsqO1qK0nA5PrTtOCoRUyp5xK3KFqXegqEVx0DzQEGV4jd4BXl4HhUdZrjPOgpLBWu2DuXTx0f97brihtstBydb0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3032.namprd15.prod.outlook.com (20.178.238.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Fri, 6 Sep 2019 23:21:14 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 23:21:14 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Neira <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data
 from current task New bpf helper bpf_get_current_pidns_info.
Thread-Topic: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Thread-Index: AQHVZQnGeSoLbPhhakeR04Y7iQ7xbQ==
Date:   Fri, 6 Sep 2019 23:21:14 +0000
Message-ID: <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
In-Reply-To: <20190906160020.GX1131@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0046.namprd20.prod.outlook.com
 (2603:10b6:300:ed::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:810]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33520fb-971e-403d-9b80-08d73320e952
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3032;
x-ms-traffictypediagnostic: BYAPR15MB3032:
x-microsoft-antispam-prvs: <BYAPR15MB30328D429F8066C347A692C5D3BA0@BYAPR15MB3032.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39860400002)(136003)(366004)(199004)(189003)(46003)(76176011)(486006)(66946007)(66476007)(66556008)(66446008)(99286004)(6116002)(14454004)(86362001)(305945005)(2906002)(31686004)(64756008)(8936002)(81156014)(81166006)(478600001)(7736002)(31696002)(8676002)(4326008)(6436002)(25786009)(53546011)(5660300002)(102836004)(186003)(6246003)(110136005)(6506007)(54906003)(386003)(256004)(446003)(2616005)(14444005)(11346002)(52116002)(71200400001)(6486002)(71190400001)(229853002)(6512007)(316002)(36756003)(53936002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3032;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mb5P/dzp6F7267MFDdO7xulabYqLZemPY1t01F5IUenq38PIP4i5m7irkBZ7F8YG4jSho4fFOdDjlvqZy/dJx1DA86KprgDUWPVfQh5BRBAJiChpUzKMny+QrmdFFTFJnqtDfy1ZRhoGfmzxY3THvF1Myuhqd0BocKiURSkR0KzaT9R5TuFu3rptBibf3tD0E1VmRtzDmluKbt3mAZVmjsvkgA+ERNFC3KEHM6DXUah0H2Ok4PBfV2RH5ji041SCaSeouGoSO57YN5JD5/s4dp6p9z+azMpreIpCNIRd4Mya877Dr+PGQ3sV8vi8QZXNPlw56lRozNEck3ToRJGhS7zZLPrirziXeQsjdi9G2uESA+rhZEd5mUaoO1Y8gVTeYPVwxpJxsMX81DhEH5mXw65oqJQsKmRXsWQqKhvJtK4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <12D7324D6D689043BDAE05BE8BD5A6E3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c33520fb-971e-403d-9b80-08d73320e952
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 23:21:14.6417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /mYuiKKiWNaJZbJuYIfs0algPtL4F6TwJ8aOFq5N5xK/3irh5eNS1PJG54bxRfKW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3032
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_11:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1011
 bulkscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060226
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNi8xOSA5OjAwIEFNLCBBbCBWaXJvIHdyb3RlOg0KPiBPbiBGcmksIFNlcCAwNiwg
MjAxOSBhdCAwNDo0Njo0N1BNICswMTAwLCBBbCBWaXJvIHdyb3RlOg0KPiANCj4+PiBXaGVyZSBk
byBJIGJlZ2luPw0KPj4+IAkqIGdldG5hbWVfa2VybmVsKCkgaXMgdGhlcmUgZm9yIHB1cnBvc2UN
Cj4+PiAJKiBzbydzIGtlcm5fcGF0aCgpLCBkYW1uaXQNCj4+DQo+PiBPaCwgYW5kIGZpbGVuYW1l
X2xvb2t1cCgpICpDQU4qIHNsZWVwLCBvYnZpb3VzbHkuICBTbyB0aGF0DQo+PiBHRlBfQVRPTUlD
IGFib3ZlIGlzIGNvbXBsZXRlbHkgcG9pbnRsZXNzLg0KPj4NCj4+Pj4gKw0KPj4+PiArCWlub2Rl
ID0gZF9iYWNraW5nX2lub2RlKGtwLmRlbnRyeSk7DQo+Pj4+ICsJcGlkbnNfaW5mby0+ZGV2ID0g
KHUzMilpbm9kZS0+aV9yZGV2Ow0KPiANCj4gSW4gdGhlIG9yaWdpbmFsIHZhcmlhbnQgb2YgcGF0
Y2hzZXQgaXQgdXNlZCB0byBiZSAtPmlfc2ItPnNfZGV2LA0KPiB3aGljaCBpcyBhbHNvIGJsb29k
eSBzdHJhbmdlIC0geW91IGFyZSBub3QgYXNraW5nIGZpbGVuYW1lX2xvb2t1cCgpDQo+IHRvIGZv
bGxvdyBzeW1saW5rcywgc28geW91J2QgZ2V0IHRoYXQgb2Ygd2hhdGV2ZXIgZmlsZXN5c3RlbQ0K
PiAvcHJvYy9zZWxmL25zIHJlc2lkZXMgb24uDQo+IA0KPiAtPmlfcmRldiB1c2UgbWFrZXMgbm8g
c2Vuc2Ugd2hhdHNvZXZlciAtIGl0J3MgYSBzeW1saW5rIGFuZA0KPiBuZWl0aGVyIGl0IG5vciBp
dHMgdGFyZ2V0IGFyZSBkZXZpY2Ugbm9kZXM7IC0+aV9yZGV2IHdpbGwgYmUNCj4gbGVmdCB6ZXJv
IGZvciBib3RoLg0KPiANCj4gV2hhdCBkYXRhIGFyZSB5b3UgcmVhbGx5IHRyeWluZyB0byBnZXQg
dGhlcmU/DQoNCkxldCBtZSBleHBsYWluIGEgbGl0dGxlIGJpdCBiYWNrZ3JvdW5kIGhlcmUuDQpU
aGUgdWx0aW1hdGUgZ29hbCBpcyBmb3IgYnBmIHByb2dyYW0gdG8gZmlsdGVyIG92ZXINCihwaWRf
bmFtZXNwYWNlLCB0Z2lkL3BpZCBpbnNpZGUgcGlkX25hbWVzcGFjZSkNCnNvIGJwZiBiYXNlZCB0
b29scyBjYW4gcnVuIGluc2lkZSB0aGUgY29udGFpbmVyLg0KDQpUeXBpY2FsbHksIHBpZCBuYW1l
c3BhY2UgaXMgYWNoaWV2ZWQgYnkgbG9va2luZyBhdA0KL3Byb2Mvc2VsZi9ucy9waWQ6DQotYmFz
aC00LjQkIGxzbnMNCiAgICAgICAgIE5TIFRZUEUgICBOUFJPQ1MgICBQSUQgVVNFUiBDT01NQU5E
DQo0MDI2NTMxODM1IGNncm91cCAgICAgNDQgIDgyNjEgeWhzICAvdXNyL2xpYi9zeXN0ZW1kL3N5
c3RlbWQgLS11c2VyDQo0MDI2NTMxODM2IHBpZCAgICAgICAgNDQgIDgyNjEgeWhzICAvdXNyL2xp
Yi9zeXN0ZW1kL3N5c3RlbWQgLS11c2VyDQo0MDI2NTMxODM3IHVzZXIgICAgICAgNDQgIDgyNjEg
eWhzICAvdXNyL2xpYi9zeXN0ZW1kL3N5c3RlbWQgLS11c2VyDQo0MDI2NTMxODM4IHV0cyAgICAg
ICAgNDQgIDgyNjEgeWhzICAvdXNyL2xpYi9zeXN0ZW1kL3N5c3RlbWQgLS11c2VyDQo0MDI2NTMx
ODM5IGlwYyAgICAgICAgNDQgIDgyNjEgeWhzICAvdXNyL2xpYi9zeXN0ZW1kL3N5c3RlbWQgLS11
c2VyDQo0MDI2NTMxODQwIG1udCAgICAgICAgNDQgIDgyNjEgeWhzICAvdXNyL2xpYi9zeXN0ZW1k
L3N5c3RlbWQgLS11c2VyDQo0MDI2NTMyMDA4IG5ldCAgICAgICAgNDQgIDgyNjEgeWhzICAvdXNy
L2xpYi9zeXN0ZW1kL3N5c3RlbWQgLS11c2VyDQotYmFzaC00LjQkIHJlYWRsaW5rIC9wcm9jL3Nl
bGYvbnMvcGlkDQpwaWQ6WzQwMjY1MzE4MzZdDQotYmFzaC00LjQkIHN0YXQgL3Byb2Mvc2VsZi9u
cy9waWQNCiAgIEZpbGU6IOKAmC9wcm9jL3NlbGYvbnMvcGlk4oCZIC0+IOKAmHBpZDpbNDAyNjUz
MTgzNl3igJkNCiAgIFNpemU6IDAgICAgICAgICAgICAgICBCbG9ja3M6IDAgICAgICAgICAgSU8g
QmxvY2s6IDEwMjQgICBzeW1ib2xpYyBsaW5rDQpEZXZpY2U6IDRoLzRkICAgSW5vZGU6IDM0NDc5
NTk4OSAgIExpbmtzOiAxDQpBY2Nlc3M6ICgwNzc3L2xyd3hyd3hyd3gpICBVaWQ6ICgxMjgyMDMv
ICAgICB5aHMpICAgR2lkOiAoICAxMDAvICAgdXNlcnMpDQpDb250ZXh0OiB1c2VyX3U6YmFzZV9y
OmJhc2VfdA0KQWNjZXNzOiAyMDE5LTA5LTA2IDE2OjA2OjA5LjQzMTYxNjM4MCAtMDcwMA0KTW9k
aWZ5OiAyMDE5LTA5LTA2IDE2OjA2OjA5LjQzMTYxNjM4MCAtMDcwMA0KQ2hhbmdlOiAyMDE5LTA5
LTA2IDE2OjA2OjA5LjQzMTYxNjM4MCAtMDcwMA0KICBCaXJ0aDogLQ0KLWJhc2gtNC40JA0KDQpC
YXNlZCBvbiBhIGRpc2N1c3Npb24gd2l0aCBFcmljIEJpZWRlcm1hbiBiYWNrIGluIDIwMTkgTGlu
dXgNClBsdW1iZXJzLCBFcmljIHN1Z2dlc3RlZCB0aGF0IHRvIHVuaXF1ZWx5IGlkZW50aWZ5IGEN
Cm5hbWVzcGFjZSwgZGV2aWNlIGlkIChtYWpvci9taW5vcikgbnVtYmVyIHNob3VsZCBhbHNvDQpi
ZSBpbmNsdWRlZC4gQWx0aG91Z2ggdG9kYXkncyBrZXJuZWwgaW1wbGVtZW50YXRpb24NCmhhcyB0
aGUgc2FtZSBkZXZpY2UgZm9yIGFsbCBuYW1lc3BhY2UgcHNldWRvIGZpbGVzLA0KYnV0IGZyb20g
dWFwaSBwZXJzcGVjdGl2ZSwgZGV2aWNlIGlkIHNob3VsZCBiZSBpbmNsdWRlZC4NCg0KVGhhdCBp
cyB0aGUgcmVhc29uIHdoeSB3ZSB0cnkgdG8gZ2V0IGRldmljZSBpZCB3aGljaCBob2xkcw0KcGlk
IG5hbWVzcGFjZSBwc2V1ZG8gZmlsZS4NCg0KRG8geW91IGhhdmUgYSBiZXR0ZXIgc3VnZ2VzdGlv
biBvbiBob3cgdG8gZ2V0DQp0aGUgZGV2aWNlIGlkIGZvciAnY3VycmVudCcgcGlkIG5hbWVzcGFj
ZT8gT3IgZnJvbSBkZXNpZ24sIHdlDQpyZWFsbHkgc2hvdWxkIG5vdCBjYXJlIGFib3V0IGRldmlj
ZSBpZCBhdCBhbGw/DQo=
