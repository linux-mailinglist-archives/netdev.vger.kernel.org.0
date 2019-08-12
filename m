Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1230C8A6D0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfHLTF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:05:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33022 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbfHLTF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 15:05:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CIwHlo022431;
        Mon, 12 Aug 2019 12:04:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SIV40Vq43aAZ2U29GBQysO3m5aNuZAQk7RWZyGI62X8=;
 b=oDUpfVSJmcFHv8LzzIXDr8+NFrHF1LbiAaYG0TWaGHDwnA+KV1AqdWCWzlU3nuyxC4tJ
 wRbYdCVvJWWIvfBg4ULONQ+T/pcxrWhcNZE77Mf7EIVAn70GF6g4ly4D8Vs4k4/pv07K
 hmHtkcvS6mGf95d8pQBy5CQRe/VHpaUe6tc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ubdsbr1qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Aug 2019 12:04:23 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 12:04:22 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Aug 2019 12:04:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IybXWHJYAeYG5DviBk8ZCz9pWXxVeem559wJxNdXD4wVdjQMurv8VxbLNCW/IFi9VcjBYm/5TIZvmE9qEsfigXfxAGVVNw4wvzuLgQ4/RXBxDwLu+QTv8hQ7HCBqJnmRr1yvbgde+gWAPEoCE2j7j8OfciCrlgi/AYpuFHBDte+CSXHvRKhAQArfKJpODaC1xBZfZGR0YyP98eefp325Qk+lL38/yRSf7vza+nuXr6X6RP8qkjSFIxuksud29m4RCXL3lmKKkgro/n5zGBcTbrMvvCsq/7sDRP+norc4+Ey57Ao5c1icDgZY6X6fQWbgVIeO+5jBgX29w3fGXj1jkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIV40Vq43aAZ2U29GBQysO3m5aNuZAQk7RWZyGI62X8=;
 b=S0k8XFdkKntrgXKjBtJgEVci85PrUHljnarIVqU4H4aX3xEkvbKpBYHb4pSU0arBKBC4LZUPO1/lv4TMojWia52dVv+bwIqZKPdX2DYoQz7llaHScOSyu57c0SoRe3WnHoQR2ckYMGXjK8DTTGbeSTHOmd6CEsu+7Kd4hFgjUqlzbgBnSmfMf2IuhhJzm2C3FXCxHeWBLBMthKA1UuOPM000iz+8kinzA+l+7Yk2wK+pabfDpDFJ/mggFEEi4o+Gdtxr6KHfnkTUFPA7d2rjVfigs6QcdMeF/Gm5OYrIEqYbuZFV+GBLnBZTqj3RnMkFYyU/Q9euNfp0+HJM9ETu1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIV40Vq43aAZ2U29GBQysO3m5aNuZAQk7RWZyGI62X8=;
 b=PQTTKJPTmAQjY8pxmFBdG7bPyVTSijemXpfRMFzrOWNx12umvZkfQgJJo1sM/EHpiQq1KqeprWDkwOhFsxOhWYCdRfXRTT7EnscM+Ui3jDZfDTl9JbKJ3YJv04iQB3VdRgut7fwiI5z+z6qn7T3le9ywMoGFntgWNiIrTUQCOKE=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) by
 MW2PR1501MB2044.namprd15.prod.outlook.com (52.132.150.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Mon, 12 Aug 2019 19:04:12 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::a1a5:e638:47cb:2e96]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::a1a5:e638:47cb:2e96%4]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 19:04:12 +0000
From:   Julia Kartseva <hex@fb.com>
To:     "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        "Alexei Starovoitov" <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAA==
Date:   Mon, 12 Aug 2019 19:04:12 +0000
Message-ID: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:7533]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9135d1b6-dd04-4b7f-6b3c-08d71f57dcde
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MW2PR1501MB2044;
x-ms-traffictypediagnostic: MW2PR1501MB2044:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2044261E3E71E6074A0988C4C4D30@MW2PR1501MB2044.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39860400002)(199004)(189003)(305945005)(33656002)(46003)(14454004)(966005)(7736002)(6506007)(186003)(102836004)(66946007)(76116006)(66476007)(66446008)(64756008)(66556008)(81166006)(81156014)(8676002)(99286004)(4326008)(478600001)(3480700005)(7116003)(2906002)(2201001)(71190400001)(71200400001)(8936002)(53376002)(25786009)(486006)(5660300002)(36756003)(86362001)(256004)(6436002)(6306002)(316002)(110136005)(476003)(54906003)(2616005)(53936002)(2501003)(6116002)(6486002)(6512007)(133083001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2044;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o0V+mRaoqaNNPt/GPDu0LSSuxFEWw3EJM7nAWKBRcy4kSqXWqmPD2gFFuCcg/HBGwY4nhtXhAxgBM3VZBOW+7MHsaDorXkuBA7MBKJv4HNvVKkrW8nCddIcEFkkQBOrz/Equq+IH/QaeCjTjkwY5TN5oyBTU4MpsZ06LFaTaKyNws8xarr3mG6E9Qvk0JWIUkyv7dEhC70ShI/mXAwxlyVuH8/Kf979sPaO/rKONJ3MVDDybCDmDCTvehvpEjc6T80Yz9/nExeps5KNeU6KxdIkghiIvBqLYxvmAytFTCfQ/8DZKkCnAWv2SiLENVV7jHYCmUm2JZVVewbtMToKHf3mf/AMBRUBKI/UxtgQewcBdZlWaf4jUm72I1Y6P4m2WdGJZTUsZXtJU63hElcbU0JfQaxG/d5uQautrvqoH/bU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7AE306890A6C24799ECF865A849D785@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9135d1b6-dd04-4b7f-6b3c-08d71f57dcde
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 19:04:12.2505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N0E6imA/eYeUppgCbFBIgh2MODdU567Cqq4czrvQmozLFQO0BY6t1HW8fnNWa8lO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2044
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120197
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSB3b3VsZCBsaWtlIHRvIGJyaW5nIHVwIGxpYmJwZiBwdWJsaXNoaW5nIGRpc2N1c3Npb24gc3Rh
cnRlZCBhdCBbMV0uDQpUaGUgcHJlc2VudCBzdGF0ZSBvZiB0aGluZ3MgaXMgdGhhdCBsaWJicGYg
aXMgYnVpbHQgZnJvbSBrZXJuZWwgdHJlZSwgZS5nLiBbMl0NCkZvciBEZWJpYW4gYW5kIFszXSBm
b3IgRmVkb3JhIHdoZXJlYXMgdGhlIGJldHRlciB3YXkgd291bGQgYmUgaGF2aW5nIGENCnBhY2th
Z2UgYnVpbHQgZnJvbSBnaXRodWIgbWlycm9yLiBUaGUgYWR2YW50YWdlcyBvZiB0aGUgbGF0dGVy
Og0KLSBDb25zaXN0ZW50LCBBQkkgbWF0Y2hpbmcgdmVyc2lvbmluZyBhY3Jvc3MgZGlzdHJvcw0K
LSBUaGUgbWlycm9yIGhhcyBpbnRlZ3JhdGlvbiB0ZXN0cw0KLSBObyBuZWVkIGluIGtlcm5lbCB0
cmVlIHRvIGJ1aWxkIGEgcGFja2FnZQ0KLSBDaGFuZ2VzIGNhbiBiZSBtZXJnZWQgZGlyZWN0bHkg
dG8gZ2l0aHViIHcvbyB3YWl0aW5nIHRoZW0gdG8gYmUgbWVyZ2VkDQp0aHJvdWdoIGJwZi1uZXh0
IC0+IG5ldC1uZXh0IC0+IG1haW4NClRoZXJlIGlzIGEgUFIgaW50cm9kdWNpbmcgYSBsaWJicGYu
c3BlYyB3aGljaCBjYW4gYmUgdXNlZCBhcyBhIHN0YXJ0aW5nIHBvaW50OiBbNF0NCkFueSBjb21t
ZW50cyByZWdhcmRpbmcgdGhlIHNwZWMgaXRzZWxmIGNhbiBiZSBwb3N0ZWQgdGhlcmUuDQpJbiB0
aGUgZnV0dXJlIGl0IG1heSBiZSB1c2VkIGFzIGEgc291cmNlIG9mIHRydXRoLg0KUGxlYXNlIGNv
bnNpZGVyIHN3aXRjaGluZyBsaWJicGYgcGFja2FnaW5nIHRvIHRoZSBnaXRodWIgbWlycm9yIGlu
c3RlYWQNCm9mIHRoZSBrZXJuZWwgdHJlZS4NClRoYW5rcw0KDQpbMV0gaHR0cHM6Ly9saXN0cy5p
b3Zpc29yLm9yZy9nL2lvdmlzb3ItZGV2L21lc3NhZ2UvMTUyMQ0KWzJdIGh0dHBzOi8vcGFja2Fn
ZXMuZGViaWFuLm9yZy9zaWQvbGliYnBmNC4xOQ0KWzNdIGh0dHA6Ly9ycG1maW5kLm5ldC9saW51
eC9SUE0vZmVkb3JhL2RldmVsL3Jhd2hpZGUveDg2XzY0L2wvbGliYnBmLTUuMy4wLTAucmMyLmdp
dDAuMS5mYzMxLng4Nl82NC5odG1sDQpbNF0gaHR0cHM6Ly9naXRodWIuY29tL2xpYmJwZi9saWJi
cGYvcHVsbC82NA0KDQoNCg==
