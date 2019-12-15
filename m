Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2836911FBA3
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 23:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLOWI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 17:08:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30138 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726260AbfLOWI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 17:08:28 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBFM3S5U000342;
        Sun, 15 Dec 2019 14:08:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6DPaZGt8Vdi5NQcN0iSeVFiMfCYG49ufF53XZVbyyoE=;
 b=JPa0DnjmAz6xRizKC37mB1sVXQxiZlUPaPVqvuv49jIbZ+mNsvFhcCNsklCue2Sr3H8e
 RtjDeYUeTo+dqq9eOrruCErUycViOMYB4iq2gzpVuv90i+k3cEYvpqBFZpABTFYAJm4v
 qcy9Cg8tlqGrDKG/0646FxO26hvyNE5iuzc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wvv9wvhgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 14:08:12 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 15 Dec 2019 14:08:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Dec 2019 14:08:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/hYGCs6d8Tp56cv6Q5xSuTxfPQGFKqq8NjRyIexzJes1iGUPb2YWmBL38lVscW2jueR6dUTxMHQoDnU2pLzGh4dfUDGAWpuiYUIT7a/qb29Sx4ciQOHvmoCFZ8Epr4sQgljSakleLpACu1aMriXKxPV1IqDC8E1Tea9AAFS8PiRqXfBK1+qgvL3jcRx7AT7+7ni6bZL2rUXph+TVt5ZCpwxrslKCpYN61+25NZXuF0DcL0e3P6/imohhw3ype51fakz6Fbmr71MR5BbLk5sNP8XwO60jkDLgL3TJiaYgFN89L1s0ZbslvbU59X7L/irwUlrMPpcs4/BMlsGFRFANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DPaZGt8Vdi5NQcN0iSeVFiMfCYG49ufF53XZVbyyoE=;
 b=C/cVQZqoiSsyRSbc6UJgR6e2iSboNTXX/U82MH+/yLtZ2UXScZKrLajiLn7erW8LdjEZTOy1ja/3H2GEsK/KaihUzAK6+b7957+mrltjtV/cPYo7sOZfWH2G1s9D6Fjn233yT+HSRmXFiVrCw296MBL7c2wyC306xz9obqyezVNW/c0Y8ydg861hTycgfFpz64C9s951RFhbgXUfWB0/GqFJK/P6d9fSprHmt8+mn8QYDL+9kzSKNnH9uAeTI59cmRwpbYBkmpL072zL5f4ae7qbZGAYwOzh/Vidoi/iE5D/Y4K5qBKsFkL0DpZn3Ed9xQC31b4zIoABgGtE8JRjKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DPaZGt8Vdi5NQcN0iSeVFiMfCYG49ufF53XZVbyyoE=;
 b=fwDSd7T3sn8A0i+NcJ7WvLH9ntfwQ+afmmwADk3ZyXz9y3ZCUqJ2CrwLvITwrZg8OseZG+OACQiw+VTku/V+MCWjEzX2MdvvwTNYuRrsSArEIzkwkCysHl85exx7slFdglpXK7yk7lk4MlNT2fb4008RZDR0EV/gSrm+UEY8V2s=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1659.namprd15.prod.outlook.com (10.175.110.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Sun, 15 Dec 2019 22:08:09 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Sun, 15 Dec 2019
 22:08:09 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Aditya Pakki <pakki001@umn.edu>
CC:     "kjlu@umn.edu" <kjlu@umn.edu>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Replace BUG_ON when fp_old is NULL
Thread-Topic: [PATCH] bpf: Replace BUG_ON when fp_old is NULL
Thread-Index: AQHVs16TPZ+OnI1FI0KP8/3dYOxfaqe7wWcA
Date:   Sun, 15 Dec 2019 22:08:08 +0000
Message-ID: <98c13b9c-a73a-6203-4ea1-6b1180d87d97@fb.com>
References: <20191215154432.22399-1-pakki001@umn.edu>
In-Reply-To: <20191215154432.22399-1-pakki001@umn.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:300:4b::24) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::fcac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b301c33-b7b4-48d6-2c15-08d781ab44ae
x-ms-traffictypediagnostic: DM5PR15MB1659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB16599CBEA050E3C708E4E852D3560@DM5PR15MB1659.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(189003)(2616005)(6512007)(66946007)(66476007)(53546011)(66556008)(2906002)(64756008)(66446008)(54906003)(4744005)(6486002)(4326008)(186003)(71200400001)(52116002)(6506007)(8936002)(5660300002)(6916009)(81156014)(81166006)(86362001)(478600001)(31696002)(31686004)(8676002)(36756003)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1659;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qm7lvJI12UK7Zq0gkWdekZsGdsSb8Fs/ywFjV3tgsP+CxEFuwaBR7HAgpdqYglXj6m1Y3HPFyykT25vPISj3qJscsc3EXxVW1z+bSBjPGnXGru+aE7CvbN3mhr3yXcw7J+DOmYf/bTRqhRfnf20/LN3w7ycvpYdpR2BGloDYkA3d+m+Z4VIlZAc/pbmlz/3DAzd2UXOo3YL78cmvsopDqwGNaEtkQ42yPePeGHnlduUdlUkCdCqw3DRVK+M0KRjPOnRp2dti1gyBxdCGPAumoTd1qhrqKsNlhlBmNJ+mO+EoyCA9si3SZY0nRBvfLywYqH0S5HrHQvSxH4EGsRRCv5TUNResAmIiHIO7cGR7C1L68LglT07Xxrzp+tcBPy7P/jhI4XabLphzkqKj+J7G1JYkc89/nqUiX70E3Mq8GVobKAHmOprc4ny/7bFKDcm
Content-Type: text/plain; charset="utf-8"
Content-ID: <51F8FA48EBAEDD41953C1930BF1D1617@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b301c33-b7b4-48d6-2c15-08d781ab44ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 22:08:09.0599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+a+d0+tjeBFpXf4gUz5kadOdaQYdhXm0m5Ewc8byq1bFiIJ0i8B59hYW+4VcDLF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1659
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_06:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=750
 suspectscore=0 spamscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE1LzE5IDc6NDQgQU0sIEFkaXR5YSBQYWtraSB3cm90ZToNCj4gSWYgZnBfb2xk
IGlzIE5VTEwgaW4gYnBmX3Byb2dfcmVhbGxvYywgdGhlIHByb2dyYW0gZG9lcyBhbiBhc3NlcnRp
b24NCj4gYW5kIGNyYXNoZXMuIEhvd2V2ZXIsIHdlIGNhbiBjb250aW51ZSBleGVjdXRpb24gYnkg
cmV0dXJuaW5nIE5VTEwgdG8NCj4gdGhlIHVwcGVyIGNhbGxlcnMuIFRoZSBwYXRjaCBmaXhlcyB0
aGlzIGlzc3VlLg0KDQpDb3VsZCB5b3Ugc2hhcmUgaG93IHRvIHJlcHJvZHVjZSB0aGUgYXNzZXJ0
aW9uIGFuZCBjcmFzaD8gSSB3b3VsZA0KbGlrZSB0byB1bmRlcnN0YW5kIHRoZSBwcm9ibGVtIGZp
cnN0IGJlZm9yZSBtYWtpbmcgY2hhbmdlcyBpbiB0aGUgY29kZS4NClRoYW5rcyENCg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWRpdHlhIFBha2tpIDxwYWtraTAwMUB1bW4uZWR1Pg0KPiAtLS0NCj4g
ICBrZXJuZWwvYnBmL2NvcmUuYyB8IDMgKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvY29y
ZS5jIGIva2VybmVsL2JwZi9jb3JlLmMNCj4gaW5kZXggNDllMzJhY2FkN2Q4Li40YjQ2NjU0ZmIy
NmIgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvY29yZS5jDQo+ICsrKyBiL2tlcm5lbC9icGYv
Y29yZS5jDQo+IEBAIC0yMjIsNyArMjIyLDggQEAgc3RydWN0IGJwZl9wcm9nICpicGZfcHJvZ19y
ZWFsbG9jKHN0cnVjdCBicGZfcHJvZyAqZnBfb2xkLCB1bnNpZ25lZCBpbnQgc2l6ZSwNCj4gICAJ
dTMyIHBhZ2VzLCBkZWx0YTsNCj4gICAJaW50IHJldDsNCj4gICANCj4gLQlCVUdfT04oZnBfb2xk
ID09IE5VTEwpOw0KPiArCWlmICghZnBfb2xkKQ0KPiArCQlyZXR1cm4gTlVMTDsNCj4gICANCj4g
ICAJc2l6ZSA9IHJvdW5kX3VwKHNpemUsIFBBR0VfU0laRSk7DQo+ICAgCXBhZ2VzID0gc2l6ZSAv
IFBBR0VfU0laRTsNCj4gDQo=
