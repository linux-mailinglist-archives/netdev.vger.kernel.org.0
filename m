Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4A8C51D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfHNA2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:28:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49686 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbfHNA2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:28:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7E0OGcm029058;
        Tue, 13 Aug 2019 17:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jFdt7DY+JxSKXbuavpO++GqVTF3JMAP6AqhQ9EANsHc=;
 b=ihw0UEUy+OdhmB77Y/hvln2JalVllKZPLa5GEr1ttDCuCDwOpkXwGpgpCHZnp1eKBxkg
 hMB5Rk6TO8gR+UWjiWOg/WB9YV0FK/mDnM6UWk9fTMbm5Hilaghv8U4exXDM5a7S+RB6
 TQWVfCjlQr6lIluTV34idC9F3N3gu+D91qM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc1d81q1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 17:28:28 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 13 Aug 2019 17:28:27 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Aug 2019 17:28:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a64aEiR03ngekjrV0cIPxc/x4+kJcJUIQ8jwzIZX+2cSmry5i6gb5wffT8zJUQXlgte3bKi3Egw3mh6Tmz7cFuI/TfDd3Nokvs1atrb59G/7lygnDrR5JBuGwbYJ5ezk7Evu5qiqcsgCY7hulLB+AbpLbgmiVR79Rep0/yjbKSQtvqOVRYQoGFh/tBILvmhfwZowlG2E99/1DF7cyRm0PDtBrk1udgAHgTANtg93sPZdg7CquzLY4f0yFskfBEMkxXIjS/4Wk1vI0Ei1EtkGkCGnZeps6O2JaDBnO7lE6RzTJ/RxrQkjzMS9ZxJUxzhW4i9Ho5oPgRRLKT+iAwVm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFdt7DY+JxSKXbuavpO++GqVTF3JMAP6AqhQ9EANsHc=;
 b=W8rW3qtTQo0Zj74VlsYO9XWvVQwx44XR6RWW06VdHBdVkItDrxIX4lTvPwM1NuxrIohTx5fAx4J4SbIyrl3LXgNFnzgQS+S0zBuRzOq7v8T105FqvAXRhuVDk54bfx5EQ+lV9nX+U7rzDKhZFhHLXzpjeWqbflWnZhJN2DG4N9yjNVlnWbEw4e8jy7BnmLKPvM/kozzbE8jY/apV6D+GJ3eSUFKgiUZsYHB1YaZ89Yqa2oTf7TacmGSBnbS8i8HrXrgyHqV1gcPb7SJnxgwko5i2u/Zr4gJWJTaXC4HuWHvK/H88TE/kxX94rZ+TTQB4POKbEfBZKml4H9zMgMNQdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFdt7DY+JxSKXbuavpO++GqVTF3JMAP6AqhQ9EANsHc=;
 b=EnlMl3VMoISkhIOrZBI6grLV/nQ94/hsXuRjWWdT4WybnXI6pTytNRmyNHujDOLEG/YgX+koO2HSVS5Fqtn2RS2Q+Z6G1Fhz42BYCsYUikGbWhh2bb70jstnuQp1o9J8kbuLT+4dmxLzOWSRCEHM9EaMmbmFEhYeXJh4MyBoCzU=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1942.namprd15.prod.outlook.com (10.172.182.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 00:28:26 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1%9]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 00:28:26 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Topic: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Index: AQHVUi5Ju+2OlijuzEGK9AnOiFXIR6b5ygEA
Date:   Wed, 14 Aug 2019 00:28:26 +0000
Message-ID: <20190814002824.GA29281@rdna-mbp>
References: <20190813232408.1246694-1-andriin@fb.com>
In-Reply-To: <20190813232408.1246694-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0054.namprd14.prod.outlook.com
 (2603:10b6:300:81::16) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::722a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cde389a4-85be-48a0-74d3-08d7204e529c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1942;
x-ms-traffictypediagnostic: CY4PR15MB1942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1942D0B8DAD809F1C929F8DBA8AD0@CY4PR15MB1942.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(396003)(376002)(39860400002)(366004)(136003)(189003)(199004)(8676002)(14444005)(476003)(7736002)(186003)(305945005)(33656002)(4326008)(256004)(1076003)(6862004)(102836004)(33716001)(46003)(446003)(6116002)(11346002)(386003)(6506007)(486006)(76176011)(52116002)(14454004)(25786009)(316002)(5660300002)(6512007)(99286004)(71200400001)(229853002)(71190400001)(6486002)(64756008)(81166006)(478600001)(81156014)(53936002)(6436002)(86362001)(6636002)(54906003)(66446008)(66946007)(2906002)(66476007)(6246003)(8936002)(9686003)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1942;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OyiCYMQr3adFAGP8qr9SKtWkrIDnFj88qtEgo/2rAGeMncOfND+DF/4DeKVNhGC8Zi7/emcAue2xawCmmkJp2GKxzwVOMq7nyAuaQdus4znDDN9RXhgrzvZSakN1Grm5vP+dNmhRlxBSYQV9iwelyN287leBJAozo1ZKEes46LivbYHKFdmIX2U5dg3D5H5FCojGYgEKsodockZOeFajKpxqaVLbYPHB3udiI/46B/WoXVBSqBOykj1VwctewE5H48rNb91O5eTCh9054TpynGvsBNwnBpb2bnUSdjiFD6Qo6dvNrp6vaZjSvWXUcNyeFuR4D/ckTQ6UugDw0lZDcPUP/aQuaWIb0w6b1TFBRSbo8jgcBOee+QUB7v3MqDXNz9to0A6znOT6GqKCQITUAMSJCM9NXYXmSmRfb1UaG/Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D86202907FDD2E45BFAD01C3AAE2324E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cde389a4-85be-48a0-74d3-08d7204e529c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 00:28:26.4026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YtRHEl3wzOhH3RInq0Cuz+Up6vRqA9pfhrjOTTNwtlKalL2TBzSmcMjCjzolSYDA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1942
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4gW1R1ZSwgMjAxOS0wOC0xMyAxNjoyNCAt
MDcwMF06DQo+IEN1cnJlbnRseSBsaWJicGYgdmVyc2lvbiBpcyBzcGVjaWZpZWQgaW4gMiBwbGFj
ZXM6IGxpYmJwZi5tYXAgYW5kDQo+IE1ha2VmaWxlLiBUaGV5IGVhc2lseSBnZXQgb3V0IG9mIHN5
bmMgYW5kIGl0J3MgdmVyeSBlYXN5IHRvIHVwZGF0ZSBvbmUsDQo+IGJ1dCBmb3JnZXQgdG8gdXBk
YXRlIGFub3RoZXIgb25lLiBJbiBhZGRpdGlvbiwgR2l0aHViIHByb2plY3Rpb24gb2YNCj4gbGli
YnBmIGhhcyB0byBtYWludGFpbiBpdHMgb3duIHZlcnNpb24gd2hpY2ggaGFzIHRvIGJlIHJlbWVt
YmVyZWQgdG8gYmUNCj4ga2VwdCBpbiBzeW5jIG1hbnVhbGx5LCB3aGljaCBpcyB2ZXJ5IGVycm9y
LXByb25lIGFwcHJvYWNoLg0KPiANCj4gVGhpcyBwYXRjaCBtYWtlcyBsaWJicGYubWFwIGEgc291
cmNlIG9mIHRydXRoIGZvciBsaWJicGYgdmVyc2lvbiBhbmQNCj4gdXNlcyBzaGVsbCBpbnZvY2F0
aW9uIHRvIHBhcnNlIG91dCBjb3JyZWN0IGZ1bGwgYW5kIG1ham9yIGxpYmJwZiB2ZXJzaW9uDQo+
IHRvIHVzZSBkdXJpbmcgYnVpbGQuIE5vdyB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSB0aGF0IG9uY2Ug
bmV3IHJlbGVhc2UNCj4gY3ljbGUgc3RhcnRzLCB3ZSBuZWVkIHRvIGFkZCAoaW5pdGlhbGx5KSBl
bXB0eSBzZWN0aW9uIHRvIGxpYmJwZi5tYXANCj4gd2l0aCBjb3JyZWN0IGxhdGVzdCB2ZXJzaW9u
Lg0KPiANCj4gVGhpcyBhbHNvIHdpbGwgbWFrZSBpdCBwb3NzaWJsZSB0byBrZWVwIEdpdGh1YiBw
cm9qZWN0aW9uIGNvbnNpc3RlbnQNCj4gd2l0aCBrZXJuZWwgc291cmNlcyB2ZXJzaW9uIG9mIGxp
YmJwZiBieSBhZG9wdGluZyBzaW1pbGFyIHBhcnNpbmcgb2YNCj4gdmVyc2lvbiBmcm9tIGxpYmJw
Zi5tYXAuDQoNClRoYW5rcyBmb3IgdGFraW5nIGNhcmUgb2YgdGhpcyENCg0KDQo+IENjOiBBbmRy
ZXkgSWduYXRvdiA8cmRuYUBmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlr
byA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAgdG9vbHMvbGliL2JwZi9NYWtlZmlsZSAgIHwg
MTIgKysrKystLS0tLS0tDQo+ICB0b29scy9saWIvYnBmL2xpYmJwZi5tYXAgfCAgMyArKysNCj4g
IDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUgYi90b29scy9saWIvYnBmL01ha2Vm
aWxlDQo+IGluZGV4IDkzMTIwNjZhMWFlMy4uZDlhZmM4NTA5NzI1IDEwMDY0NA0KPiAtLS0gYS90
b29scy9saWIvYnBmL01ha2VmaWxlDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4g
QEAgLTEsOSArMSwxMCBAQA0KPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKExHUEwtMi4x
IE9SIEJTRC0yLUNsYXVzZSkNCj4gICMgTW9zdCBvZiB0aGlzIGZpbGUgaXMgY29waWVkIGZyb20g
dG9vbHMvbGliL3RyYWNlZXZlbnQvTWFrZWZpbGUNCj4gIA0KPiAtQlBGX1ZFUlNJT04gPSAwDQo+
IC1CUEZfUEFUQ0hMRVZFTCA9IDANCj4gLUJQRl9FWFRSQVZFUlNJT04gPSA0DQo+ICtCUEZfRlVM
TF9WRVJTSU9OID0gJChzaGVsbCBcDQoNCk5pdDogU2hvdWxkIGl0IGJlIExJQkJQRl9WRVJTSU9O
PyBJTU8gaXQncyBtb3JlIGRlc2NyaXB0aXZlIG5hbWUuDQoNCj4gKwlncmVwIC1FICdMSUJCUEZf
KFswLTldKylcLihbMC05XSspXC4oWzAtOV0rKSBceycgbGliYnBmLm1hcCB8IFwNCj4gKwl0YWls
IC1uMSB8IGN1dCAtZCdfJyAtZjIgfCBjdXQgLWQnICcgLWYxKQ0KDQpJdCBjYW4gYmUgZG9uZSBz
aW1wbGVyIGFuZCBJTU8gdmVyc2lvbnMgc2hvdWxkIGJlIHNvcnRlZCBiZWZvcmUgdGFraW5nDQp0
aGUgbGFzdCBvbmUgKGp1c3QgaW4gY2FzZSksIHNvbWV0aGluZyBsaWtlOg0KDQpncmVwIC1vRSAn
XkxJQkJQRl9bMC05Ll0rJyBsaWJicGYubWFwIHwgY3V0IC1kXyAtZiAyIHwgc29ydCAtbnIgfCBo
ZWFkIC1uIDENCg0KDQo+ICtCUEZfVkVSU0lPTiA9ICQoZmlyc3R3b3JkICQoc3Vic3QgLiwgLCQo
QlBGX0ZVTExfVkVSU0lPTikpKQ0KPiAgDQo+ICBNQUtFRkxBR1MgKz0gLS1uby1wcmludC1kaXJl
Y3RvcnkNCj4gIA0KPiBAQCAtNzksMTUgKzgwLDEyIEBAIGV4cG9ydCBwcmVmaXggbGliZGlyIHNy
YyBvYmoNCj4gIGxpYmRpcl9TUSA9ICQoc3Vic3QgJywnXCcnLCQobGliZGlyKSkNCj4gIGxpYmRp
cl9yZWxhdGl2ZV9TUSA9ICQoc3Vic3QgJywnXCcnLCQobGliZGlyX3JlbGF0aXZlKSkNCj4gIA0K
PiArTElCQlBGX1ZFUlNJT04JPSAkKEJQRl9GVUxMX1ZFUlNJT04pDQo+ICBWRVJTSU9OCQk9ICQo
QlBGX1ZFUlNJT04pDQo+IC1QQVRDSExFVkVMCT0gJChCUEZfUEFUQ0hMRVZFTCkNCj4gLUVYVFJB
VkVSU0lPTgk9ICQoQlBGX0VYVFJBVkVSU0lPTikNCj4gIA0KPiAgT0JKCQk9ICRADQo+ICBOCQk9
DQo+ICANCj4gLUxJQkJQRl9WRVJTSU9OCT0gJChCUEZfVkVSU0lPTikuJChCUEZfUEFUQ0hMRVZF
TCkuJChCUEZfRVhUUkFWRVJTSU9OKQ0KPiAtDQo+ICBMSUJfVEFSR0VUCT0gbGliYnBmLmEgbGli
YnBmLnNvLiQoTElCQlBGX1ZFUlNJT04pDQo+ICBMSUJfRklMRQk9IGxpYmJwZi5hIGxpYmJwZi5z
byoNCj4gIFBDX0ZJTEUJCT0gbGliYnBmLnBjDQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBm
L2xpYmJwZi5tYXAgYi90b29scy9saWIvYnBmL2xpYmJwZi5tYXANCj4gaW5kZXggZjlkMzE2ZTg3
M2Q4Li40ZTcyZGY4ZTk4YmEgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1h
cA0KPiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5tYXANCj4gQEAgLTE4NCwzICsxODQsNiBA
QCBMSUJCUEZfMC4wLjQgew0KPiAgCQlwZXJmX2J1ZmZlcl9fbmV3X3JhdzsNCj4gIAkJcGVyZl9i
dWZmZXJfX3BvbGw7DQo+ICB9IExJQkJQRl8wLjAuMzsNCj4gKw0KPiArTElCQlBGXzAuMC41IHsN
Cj4gK30gTElCQlBGXzAuMC40Ow0KDQpJJ20gbm90IHN1cmUgdmVyc2lvbiBzaG91bGQgYmUgYnVt
cGVkIGluIHRoaXMgcGF0Y2ggc2luY2UgdGhpcyBwYXRjaCBpcw0KYWJvdXQga2VlcGluZyB0aGUg
dmVyc2lvbiBpbiBvbmUgcGxhY2UsIG5vdCBhYm91dCBidW1waW5nIGl0LCByaWdodD8NCg0KDQo+
IC0tIA0KPiAyLjE3LjENCj4gDQoNCi0tIA0KQW5kcmV5IElnbmF0b3YNCg==
