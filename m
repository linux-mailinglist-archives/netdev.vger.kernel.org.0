Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A97381C9
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfFFX2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:28:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfFFX17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:27:59 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56NLx1E011965;
        Thu, 6 Jun 2019 16:27:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hEVXH+JnKCPbYU77MAOboJfukXUkY7rWIVZ4FQIcr8M=;
 b=YFqwfaFiLzlUwlnmeXN3M449BUtfMC9oMszGdZrkBkNtO8GNTYlKjtieZGonY2eIskzP
 UbCaN3S1kIwg/p203k/8PbFvhI6WkerEk8WulcErTJLxHXnddM4iCX7Bs35NBprSnXkG
 3UK1+Ap0d8sOt4iMsNjsVWkHNraBveVKF9Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2sy2kpacrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 16:27:38 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 16:27:37 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 16:27:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEVXH+JnKCPbYU77MAOboJfukXUkY7rWIVZ4FQIcr8M=;
 b=H8FFJnf+nLrjMNWGfj+C82QafeTO+X+5a+islMIEix6tojOtoUN3oogo2q1mDrrPYtRdpt08swD0lWSJ4g2+0K79jpqvHzNvQvoz4WkTTuGosuArpDGwp48USfwrUpj4FrWhfu45i2fp2Ds9Ax9lNLu5XIyyQRNMPK0bC8hzeBY=
Received: from SN6PR15MB2512.namprd15.prod.outlook.com (52.135.66.25) by
 SN6PR15MB2240.namprd15.prod.outlook.com (52.135.64.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 23:27:36 +0000
Received: from SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494]) by SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 23:27:36 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
Thread-Topic: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Thread-Index: AQHVF+6FIN4ypCqNSkaaeWcXaUexbKaFv76AgAAZLICABEsPAIAAXHQAgAAyMACAAAE1gIAAOGMAgACbgwCAAD8rgIADYXQAgAAfwACAAAbfAA==
Date:   Thu, 6 Jun 2019 23:27:36 +0000
Message-ID: <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
 <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
 <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
In-Reply-To: <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:104:6::29) To SN6PR15MB2512.namprd15.prod.outlook.com
 (2603:10b6:805:25::25)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:ad4f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cc5e29b-af44-4874-4018-08d6ead68ede
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR15MB2240;
x-ms-traffictypediagnostic: SN6PR15MB2240:
x-microsoft-antispam-prvs: <SN6PR15MB22404F62C73CC3FDF7463584D7170@SN6PR15MB2240.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(366004)(396003)(136003)(199004)(189003)(11346002)(66446008)(64756008)(68736007)(66556008)(73956011)(66946007)(66476007)(76176011)(2616005)(36756003)(6486002)(25786009)(446003)(478600001)(316002)(31696002)(186003)(6116002)(8936002)(2906002)(86362001)(5660300002)(71200400001)(71190400001)(46003)(99286004)(53936002)(81156014)(6512007)(81166006)(6246003)(53546011)(256004)(14454004)(52116002)(486006)(305945005)(8676002)(110136005)(6506007)(386003)(4326008)(31686004)(54906003)(229853002)(6436002)(102836004)(476003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR15MB2240;H:SN6PR15MB2512.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O0S8sMv81sh6XiaiESo+eHqQkGFxqtpPKUctCBhj6A1SWSIipqyr0HdNd1Bh66Q/Q+nZU91CQhrIrPpMKTfbOs1piqAEAtGh5pjDC5TBCMD6CxLBBerFpBC31xVNtOisW8/OcmTkzLxHm+4UV3AY4Rb35PFDx4uZDVCk7rHGjHGryYy1jKBCbY6L8LT0J4sCCBpZ6Gm1TMd+jGFlqtaeNH90Zdp9jtoQXi5DX9rsmhVyRL0PTzIYDDahN2TY5N2rL/76DVRacxcUKlyHSXZObvRpFPSq1Y1dbB3f1H9t2Y7srxpnMKlc3GFYV/3m2YEWNdjI0A4Pmj+xx0r4HVmCcAUG1quGn1WHm3SWEyOhDtoxbeU5Q0J4YMJR6FuF5OIk++gwm+Spbx16T8ypGJdm51Ro3q7VcjrRJYUI4QsieF0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7F71223002B4A4CBC6F40767E620E65@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc5e29b-af44-4874-4018-08d6ead68ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 23:27:36.3503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2240
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi82LzE5IDQ6MDIgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4+IHN0cnVjdCB7DQo+
PiAgICAgICAgICBpbnQgdHlwZTsNCj4+ICAgICAgICAgIGludCBtYXhfZW50cmllczsNCj4+IH0g
bXlfbWFwIF9fYXR0cmlidXRlX18oKG1hcChpbnQsc3RydWN0IG15X3ZhbHVlKSkpID0gew0KPj4g
ICAgICAgICAgLnR5cGUgPSBCUEZfTUFQX1RZUEVfQVJSQVksDQo+PiAgICAgICAgICAubWF4X2Vu
dHJpZXMgPSAxNiwNCj4+IH07DQo+Pg0KPj4gT2YgY291cnNlIHRoaXMgd291bGQgbmVlZCBCUEYg
YmFja2VuZCBzdXBwb3J0LCBidXQgYXQgbGVhc3QgdGhhdCBhcHByb2FjaA0KPj4gd291bGQgYmUg
bW9yZSBDIGxpa2UuIFRodXMgdGhpcyB3b3VsZCBkZWZpbmUgdHlwZXMgd2hlcmUgd2UgY2FuIGF1
dG9tYXRpY2FsbHkNCj4gSSBndWVzcyBpdCdzIHRlY2huaWNhbGx5IHBvc3NpYmxlIChub3QgYSBj
b21waWxlciBndXJ1LCBidXQgSSBkb24ndA0KPiBzZWUgd2h5IGl0IHdvdWxkbid0IGJlIHBvc3Np
YmxlKS4gQnV0IGl0IHdpbGwgcmVxdWlyZSBhdCBsZWFzdCB0d28NCj4gdGhpbmdzOg0KPiAxLiBD
b21waWxlciBzdXBwb3J0LCBvYnZpb3VzbHksIGFzIHlvdSBtZW50aW9uZWQuDQoNCmV2ZXJ5IHRp
bWUgd2UncmUgZG9pbmcgbGx2bSBjb21tb24gY2hhbmdlIGl0IHRha2VzIG1hbnkgbW9udGhzLg0K
QWRkaW5nIEJURiB0b29rIDYgbW9udGgsIHRob3VnaCB0aGUgY29tbW9uIGNoYW5nZXMgd2VyZSB0
cml2aWFsLg0KTm93IHdlJ3JlIGFscmVhZHkgMSsgbW9udGggaW50byBhZGRpbmcgNCBpbnRyaW5z
aWNzIHRvIHN1cHBvcnQgQ08tUkUuDQoNCkluIHRoZSBwYXN0IEkgd2FzIHZlcnkgbXVjaCBpbiBm
YXZvciBvZiBleHRlbmRpbmcgX19hdHRyaWJ1dGVfXw0Kd2l0aCBicGYgc3BlY2lmaWMgc3R1ZmYu
IE5vdyBub3Qgc28gbXVjaC4NCl9fYXR0cmlidXRlX18oKG1hcChpbnQsc3RydWN0IG15X3ZhbHVl
KSkpIGNhbm5vdCBiZSBkb25lIGFzIHN0cmluZ3MuDQpjbGFuZyBoYXMgdG8gcHJvY2VzcyB0aGUg
dHlwZXMsIGNyZWF0ZSBuZXcgb2JqZWN0cyBpbnNpZGUgZGVidWcgaW5mby4NCkl0J3Mgbm90IGNs
ZWFyIHRvIG1lIGhvdyB0aGlzIG1vZGlmaWVkIGRlYnVnIGluZm8gd2lsbCBiZSBhc3NvY2lhdGVk
DQp3aXRoIHRoZSB2YXJpYWJsZSBteV9tYXAuDQpTbyBJIHN1c3BlY3QgZG9pbmcgX19hdHRyaWJ1
dGVfXyB3aXRoIGFjdHVhbCBDIHR5cGUgaW5zaWRlICgoKSkNCndpbGwgbm90IGJlIHBvc3NpYmxl
Lg0KSSB0aGluayBpbiB0aGUgZnV0dXJlIHdlIG1pZ2h0IHN0aWxsIGFkZCBzdHJpbmcgYmFzZWQg
YXR0cmlidXRlcywNCmJ1dCBpdCdzIG5vdCBnb2luZyB0byBiZSBlYXN5Lg0KU28uLi4gVW5sZXNz
IHNvbWVib2R5IGluIHRoZSBjb21tdW5pdHkgd2hvIGlzIGRvaW5nIGZ1bGwgdGltZSBsbHZtIHdv
cmsNCndpbGwgbm90IHN0ZXAgaW4gcmlnaHQgbm93IGFuZCBzYXlzICJJIHdpbGwgY29kZSB0aGUg
YWJvdmUgYXR0ciBzdHVmZiIsDQp3ZSBzaG91bGQgbm90IGNvdW50IG9uIHN1Y2ggY2xhbmcrbGx2
bSBmZWF0dXJlLg0K
