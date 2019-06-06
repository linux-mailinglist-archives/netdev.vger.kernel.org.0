Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1008937EFB
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFFUwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:52:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45610 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfFFUwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:52:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x56Khov1030006;
        Thu, 6 Jun 2019 13:51:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Hvms6yyx88vesmvny3EGQroVRDArB55xkvHiPLxl6dE=;
 b=PQykSZ1Kjuo4hKgpivClfsyXvYaJ6otms3dy0Zj00297RKNx4wThXpIjrjIf+TVqEfJm
 KV1e9WxkBJTjqMklPeiniCUYWd1WYW+pLthROXHVGFScN/BvSECTkd1l2bTUggUD7SMK
 aBDfb0isC5b8iaKkw6n+U/2t1v0aNNuABwM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2sy71g0tj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 13:51:53 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 13:51:52 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 13:51:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 13:51:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hvms6yyx88vesmvny3EGQroVRDArB55xkvHiPLxl6dE=;
 b=a7nzqYzhvuD7h7ZtTxLZNgPNsGBZD+HOrlDrw84stFH8CaSc/+iv9lr5qHe3Wx254MbURZTjqvWVB0+MfvA11V7UbUcO5WQdo91IDLIdXqtkdYtPX8Id4Z+mFFhGitjoE9cRjF7cqk+qKlLZmOLX3PucXE74H2BxPGDv9AMLoa4=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1831.namprd15.prod.outlook.com (10.174.54.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.23; Thu, 6 Jun 2019 20:51:50 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb%2]) with mapi id 15.20.1943.018; Thu, 6 Jun 2019
 20:51:50 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        Martin Lau <kafai@fb.com>, "m@lambda.lt" <m@lambda.lt>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Topic: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Index: AQHVHHUuKmeVn8eTnkeGX10FyBqYwaaPKYQA///w4gA=
Date:   Thu, 6 Jun 2019 20:51:50 +0000
Message-ID: <20190606205148.GB50385@rdna-mbp.dhcp.thefacebook.com>
References: <20190606143517.25710-1-daniel@iogearbox.net>
 <20190606204554.GA50385@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190606204554.GA50385@rdna-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0055.namprd19.prod.outlook.com
 (2603:10b6:300:94::17) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:877]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a493de8-8c1e-4dbe-ddec-08d6eac0cc6f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1831;
x-ms-traffictypediagnostic: CY4PR15MB1831:
x-microsoft-antispam-prvs: <CY4PR15MB18314442C28F8822AD58AF3FA8170@CY4PR15MB1831.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(14454004)(81156014)(6246003)(8676002)(81166006)(86362001)(6506007)(9686003)(186003)(68736007)(256004)(5660300002)(386003)(316002)(99286004)(6512007)(6116002)(5024004)(102836004)(4326008)(76176011)(33656002)(52116002)(14444005)(7736002)(1076003)(8936002)(6916009)(305945005)(561944003)(25786009)(66946007)(71190400001)(53936002)(71200400001)(54906003)(486006)(66556008)(46003)(478600001)(446003)(64756008)(476003)(66476007)(11346002)(66446008)(229853002)(73956011)(2906002)(6486002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1831;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zHuSG87sPDhan36HcPcho0ZSuZet5BNX1r9fovNtx4eXhISqj0GWpjtE4rxOn7hlOeSM3FheQ5Iwb2Ci0q4O/N2EgWNu5Ktha5KJZ/WO3u6J47PQhn1aPnjfSvduzCPswUm+hudcb3cs8gOWsunloN8JwQKraPYg+nGD2IXuJ1U0tItEE85GVeKl8PDiINmpfq99jVWPgPAKqQ7YlENcP3p3kb+5i7Q62lrUmIVymBGOLUfY8itPMRApqCJB9rwpvx6is9Jw5ZePO+m6f3Iv8ogmJfyvs34ecxoJUk2h3i85ZNoW19w+avFRRO2D7GOqyJ+eF0GWuAUJaZMaDt2QCz47aq2hjd+5Tsda4z1rE5CmBM1wIIcYHRJFLFyjitS88D0XcusKQlf2hY5Xg9VWw8dc4C5mVyJWUTxQ8GioJyU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D854A141E1133447BC0ED16A6B08B7BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a493de8-8c1e-4dbe-ddec-08d6eac0cc6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 20:51:50.8571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdna@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1831
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmV5IElnbmF0b3YgPHJkbmFAZmIuY29tPiBbVGh1LCAyMDE5LTA2LTA2IDEzOjQ1IC0wNzAw
XToNCj4gRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4gW1RodSwgMjAxOS0w
Ni0wNiAwNzozNiAtMDcwMF06DQo+ID4gUGxlYXNlIHJlZmVyIHRvIHRoZSBwYXRjaCAxLzQgYXMg
dGhlIG1haW4gcGF0Y2ggd2l0aCB0aGUgZGV0YWlscw0KPiA+IG9uIHRoZSBjdXJyZW50IHNlbmRt
c2cgaG9vayBBUEkgbGltaXRhdGlvbnMgYW5kIHByb3Bvc2FsIHRvIGZpeA0KPiA+IGl0IGluIG9y
ZGVyIHRvIHdvcmsgd2l0aCBiYXNpYyBhcHBsaWNhdGlvbnMgbGlrZSBETlMuIFJlbWFpbmluZw0K
PiA+IHBhdGNoZXMgYXJlIHRoZSB1c3VhbCB1YXBpIGFuZCB0b29saW5nIHVwZGF0ZXMgYXMgd2Vs
bCBhcyB0ZXN0DQo+ID4gY2FzZXMuIFRoYW5rcyBhIGxvdCENCj4gPiANCj4gPiB2MSAtPiB2MjoN
Cj4gPiAgIC0gU3BsaXQgb2ZmIHVhcGkgaGVhZGVyIHN5bmMgYW5kIGJwZnRvb2wgYml0cyAoTWFy
dGluLCBBbGV4ZWkpDQo+ID4gICAtIEFkZGVkIG1pc3NpbmcgYnBmdG9vbCBkb2MgYW5kIGJhc2gg
Y29tcGxldGlvbiBhcyB3ZWxsDQo+ID4gDQo+ID4gRGFuaWVsIEJvcmttYW5uICg0KToNCj4gPiAg
IGJwZjogZml4IHVuY29ubmVjdGVkIHVkcCBob29rcw0KPiA+ICAgYnBmOiBzeW5jIHRvb2xpbmcg
dWFwaSBoZWFkZXINCj4gPiAgIGJwZiwgYnBmdG9vbDogZW5hYmxlIHJlY3Ztc2cgYXR0YWNoIHR5
cGVzDQo+ID4gICBicGY6IGFkZCBmdXJ0aGVyIG1zZ19uYW1lIHJld3JpdGUgdGVzdHMgdG8gdGVz
dF9zb2NrX2FkZHINCj4gPiANCj4gPiAgaW5jbHVkZS9saW51eC9icGYtY2dyb3VwLmggICAgICAg
ICAgICAgICAgICAgIHwgICA4ICsNCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAg
ICAgICAgICAgICAgICAgIHwgICAyICsNCj4gPiAga2VybmVsL2JwZi9zeXNjYWxsLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICA4ICsNCj4gPiAga2VybmVsL2JwZi92ZXJpZmllci5jICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDEyICstDQo+ID4gIG5ldC9jb3JlL2ZpbHRlci5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+ID4gIG5ldC9pcHY0L3VkcC5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ID4gIG5ldC9pcHY2L3VkcC5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ID4gIC4uLi9icGZ0b29s
L0RvY3VtZW50YXRpb24vYnBmdG9vbC1jZ3JvdXAucnN0ICB8ICAgNiArLQ0KPiA+ICAuLi4vYnBm
dG9vbC9Eb2N1bWVudGF0aW9uL2JwZnRvb2wtcHJvZy5yc3QgICAgfCAgIDIgKy0NCj4gPiAgdG9v
bHMvYnBmL2JwZnRvb2wvYmFzaC1jb21wbGV0aW9uL2JwZnRvb2wgICAgIHwgICA1ICstDQo+ID4g
IHRvb2xzL2JwZi9icGZ0b29sL2Nncm91cC5jICAgICAgICAgICAgICAgICAgICB8ICAgNSArLQ0K
PiA+ICB0b29scy9icGYvYnBmdG9vbC9wcm9nLmMgICAgICAgICAgICAgICAgICAgICAgfCAgIDMg
Ky0NCj4gPiAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgICAgICAgICAgIHwg
ICAyICsNCj4gPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc29ja19hZGRyLmMg
IHwgMjEzICsrKysrKysrKysrKysrKystLQ0KPiA+ICAxNCBmaWxlcyBjaGFuZ2VkLCAyNTAgaW5z
ZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pDQo+IA0KPiB0b29scy9saWIvYnBmL2xpYmJwZi5j
IHNob3VsZCBhbHNvIGJlIHVwZGF0ZWQ6IHNlY3Rpb25fbmFtZXMgYW5kDQoNCkFuZCB0b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9zZWN0aW9uX25hbWVzLmMgYXMgd2VsbC4NCg0KPiBi
cGZfcHJvZ190eXBlX19uZWVkc19rdmVyLiBQbGVhc2UgZWl0aGVyIGZvbGxvdy11cCBzZXBhcmF0
ZWx5IG9yIHNlbmQNCj4gdjMuIE90aGVyIHRoYW4gdGhpcyBMR01ULg0KPiANCj4gQWNrZWQtYnk6
IEFuZHJleSBJZ25hdG92IDxyZG5hQGZiLmNvbT4NCj4gDQo+IC0tIA0KPiBBbmRyZXkgSWduYXRv
dg0KDQotLSANCkFuZHJleSBJZ25hdG92DQo=
