Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6919F62E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfH0Wbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:31:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfH0Wbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:31:49 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7RMU5SF013432;
        Tue, 27 Aug 2019 15:30:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kqW+5K27HA/pzIEm0OmWZYdMf9I9wN/03oMNI75gypI=;
 b=AMTUisJVWMyDYzwMKDQbov7UbsAR7qvOal1HfR24e3NicQ/iDNAzcgH8rWAgEqj4pdAn
 CAjFZM0yqUs/B4+xBSJnVbZU2XpNR0ZSfG8BmwQZAe4WUCbgbyUjdd5EfrZkHnuIdYan
 78DUISaKvKzX7n4V9/QuQl/eplpN0tgggZU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2un3vjk06a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 15:30:27 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 27 Aug 2019 15:30:27 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 27 Aug 2019 15:30:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 27 Aug 2019 15:30:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jK9QgO8wTbivwfLhYB9iXv/8idvQgX00XTAq3OR3jaogzXSaJ2PY+eTkxtW95pB6Z6UG2aZ8N1w0LjR2t2HMtVtljkEMzA1i4oVU4PDFwb9gKVKWs4skayc5E4mMLT70RI9tmIq80Yt5oaR4gklxzbzqGH5ht2ZFFpdEsv9SjK+ddniTvMOoLy1WowBem+9eMfvYGTrm9TnHZCUc5YwGnUgDCSeOI8GXnzysNbDVPDP1Ne2gka0YIteXjoSkjCdyQIM9rffrE/MgQwWI0BbL9Xy/d6HNOOSM4Y7yZrZr+yyLUvwohL/hg/rSFyv2PHZb4hqTameviZtBYKYtI5ynWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqW+5K27HA/pzIEm0OmWZYdMf9I9wN/03oMNI75gypI=;
 b=m9AWJ2GFEvQxxLtH4WGRk2cQVDmrAmgXCrzeikdbzaFW+zrJnS+wiEtPWatH1pGS0EmwW6xANJ3DIoha8hUgCI8h85T8Vj9nwpeBMMXoKP21D7mEE1u5upoVjVxQnZbfY8RBKupWAU+nLwcg3Y7LXyf6lO7uBcCY90z+aBgcyze0xdsIoPNZYx6GMWO4rZ2gsq/lO/sr+9Rul2RC8w8w+RAIiMerZPPRsiFT5hKdpvRgkZaPzWWjoOyaxwtaOWWjaiODAjAO7PE/hUYp7ozojMHLz5WpH14/tCbVc88x9Dn41GMAtusdAQI+wcBKnQMq3fDiDqfZ9ikDrDGJR1NrTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqW+5K27HA/pzIEm0OmWZYdMf9I9wN/03oMNI75gypI=;
 b=QVgHxqw8g3O7Eb4GfWnDLoYk7Ghg9yS5kLyeaLmtFgjEZj9hWy9t+N/oJBNtRFskEMZ7T1NKAd500eZVKLXTksqoagPHVpF1s1olATGxnxPuAUAM0KJaAdvNqZioZGP+pj9WYG52Rj3IcKnN882TSHRU0HO8ijqvtqpoPFiUTYk=
Received: from DM5PR1501MB2053.namprd15.prod.outlook.com (52.132.130.27) by
 DM5PR1501MB2117.namprd15.prod.outlook.com (52.132.130.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 22:30:25 +0000
Received: from DM5PR1501MB2053.namprd15.prod.outlook.com
 ([fe80::44df:6484:b008:705e]) by DM5PR1501MB2053.namprd15.prod.outlook.com
 ([fe80::44df:6484:b008:705e%3]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 22:30:25 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQA=
Date:   Tue, 27 Aug 2019 22:30:24 +0000
Message-ID: <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
In-Reply-To: <20190826064235.GA17554@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::fba1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a99c3a44-66f6-4a5b-a8bf-08d72b3e27b8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR1501MB2117;
x-ms-traffictypediagnostic: DM5PR1501MB2117:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1501MB2117131A257B040D39DAA01BC4A00@DM5PR1501MB2117.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(6116002)(86362001)(256004)(4744005)(7736002)(14454004)(966005)(486006)(476003)(6636002)(2616005)(36756003)(66946007)(64756008)(66476007)(66556008)(53936002)(3480700005)(91956017)(66446008)(4326008)(8676002)(81156014)(81166006)(6246003)(8936002)(71190400001)(110136005)(54906003)(99286004)(33656002)(2906002)(76116006)(186003)(5660300002)(7116003)(305945005)(25786009)(446003)(478600001)(229853002)(6306002)(6436002)(6512007)(46003)(6486002)(102836004)(316002)(76176011)(71200400001)(53546011)(6506007)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR1501MB2117;H:DM5PR1501MB2053.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MJZCZciRGUpp2yI3mrryt2nh3OBS7c6IwTi9/+xjoILVCgvvrRm446RCSm0891XhEZOtMNt96GTBOpW4/lnERlhTHBrniE+EOvRdT8daagovt2R/eIBHEvkdXkPt29n5mLq+tTIG3zD8jiY5nOoNIhUzfqqwp9H0cxLGa5FTwtB/Tl/L+GRz8SDU1wQpS/MAApDxdaseTvRV9+wMF9XJgiSBgYkSmtthf3vJOXjgvJIOWnGzzsUQHqyx9KJzajHFeONhfTp8BmGsCu8XvvkZKr8Mx4onBRQhoCFQlBea4H7fPl/xGnJ0pa8foeakiVUn8GcspDZnQPg1c3u2cefFGEX6DzMsvKLGBNmn7z2rUpA0HB8FK4nO2RobMUJV8D+9pvADBJa9nUh1qRZmJq7rTfauzH21Ad3p7uUoJ9NJuC0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A5AB1E2FEC0D549AE55C101BE9578E9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a99c3a44-66f6-4a5b-a8bf-08d72b3e27b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 22:30:24.8525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wk2G97FmoonXZ6cGCd2DNj/ILHLNtaKL7SNJHHMRdfKjW899kXnSvX81647IFGIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2117
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-27_04:2019-08-27,2019-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 clxscore=1011 phishscore=0 mlxlogscore=630 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908270212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yNS8xOSwgMTE6NDIgUE0sICJKaXJpIE9sc2EiIDxqb2xzYUByZWRoYXQuY29tPiB3cm90
ZToNCg0KPiBPbiBGcmksIEF1ZyAyMywgMjAxOSBhdCAwNDowMDowMVBNICswMDAwLCBBbGV4ZWkg
U3Rhcm92b2l0b3Ygd3JvdGU6DQo+ID4gDQo+ID4gVGVjaG5pY2FsbHkgd2UgY2FuIGJ1bXAgaXQg
YXQgYW55IHRpbWUuDQo+ID4gVGhlIGdvYWwgd2FzIHRvIGJ1bXAgaXQgb25seSB3aGVuIG5ldyBr
ZXJuZWwgaXMgcmVsZWFzZWQNCj4gPiB0byBjYXB0dXJlIGEgY29sbGVjdGlvbiBvZiBuZXcgQVBJ
cyBpbiBhIGdpdmVuIDAuMC5YIHJlbGVhc2UuDQo+ID4gU28gdGhhdCBsaWJicGYgdmVyc2lvbnMg
YXJlIHN5bmNocm9uaXplZCB3aXRoIGtlcm5lbCB2ZXJzaW9ucw0KPiA+IGluIHNvbWUgd2hhdCBs
b29zZSB3YXkuDQo+ID4gSW4gdGhpcyBjYXNlIHdlIGNhbiBtYWtlIGFuIGV4Y2VwdGlvbiBhbmQg
YnVtcCBpdCBub3cuDQo+DQo+IEkgc2VlLCBJIGRvbnQgdGhpbmsgaXQncyB3b3J0aCBvZiB0aGUg
ZXhjZXB0aW9uIG5vdywNCj4gdGhlIHBhdGNoIGlzIHNpbXBsZSBvciB3ZSdsbCBzdGFydCB3aXRo
IDAuMC4zDQoNClBSIGludHJvZHVjaW5nIDAuMC41IEFCSSB3YXMgbWVyZ2VkOg0KaHR0cHM6Ly9n
aXRodWIuY29tL2xpYmJwZi9saWJicGYvY29tbWl0LzQ3NmUxNTgNCkppcmksIHlvdSdkIGxpa2Ug
dG8gYXZvaWQgcGF0Y2hpbmcsIHlvdSBjYW4gc3RhcnQgdy8gMC4wLjUuDQpBbHNvIGlmIHlvdSdy
ZSBwbGFubmluZyB0byB1c2UgKi5zcGVjIGZyb20gbGliYnBmIGFzIGEgc291cmNlIG9mIHRydXRo
LA0KSXQgbWF5IGJlIGVuaGFuY2VkIGJ5IHN5bmNpbmcgc3BlYyBhbmQgQUJJIHZlcnNpb25zLCBz
aW1pbGFyIHRvDQpodHRwczovL2dpdGh1Yi5jb20vbGliYnBmL2xpYmJwZi9jb21taXQvZDYwZjU2
OA0KDQoNCg==
