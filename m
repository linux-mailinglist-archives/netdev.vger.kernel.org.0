Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D81066AE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKVG4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:56:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41342 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbfKVG4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 01:56:50 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAM6qgMB010770;
        Thu, 21 Nov 2019 22:56:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JPz062nzyimp2ukwviHrG14bzmP83Q5TsnPYOjfEft8=;
 b=fnqN1sU2H0FdVIlSsBpNPz1jZz7gZ88JyDsQkrk0qld2gzQz6SGdOW70CZN3TegG0sos
 hIOO/sZFuwUDg2NpD8nvEfM1t42kf/qtO6n7w2EqSNs7wCLXjqQmj3KJ6Qtj51Hrkg3C
 jKsp0UFsdQ3pd806N+eY7vYaKjeni9NXgJk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wdtbk4vp6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 22:56:31 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 22:56:29 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 22:56:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0m49OaYMeaW+y6CRRyTcRGMCtlCg2q6ynYq//kVbZxdf2rX2atl3/4s9zl/N09LHYOtUsFJ55uJfOv5NYhh3vAx8C49fOGtrE774gcwMieIjQ/7rgCQ8F3DUZyB9u+ECLx1Cygi5x9EHPsd/3SL6Qq0l+w1Bkz/KL/oqsTm1v+o/ffN1X+7TWW64Qm/E/+PK/IxGVY6+FqV9moimYHIsOvoHvFR3kiLiH5u6Y9wnRcKmAFFzywvuATkkQUs4LS1IGbcDVPpip+D/54qRUoOs9a96mz3HyslTRv4pWuWHBDiqKpB1Tcj8oNMp1s0lxA9KHhqvEyh+tXalbnMGE+NFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPz062nzyimp2ukwviHrG14bzmP83Q5TsnPYOjfEft8=;
 b=XzZCE2vCrSRbqWnpokZGQJHcZAARZeubX+hSl5nyW3ofL1Gb7W5CzAFQnXcwKKAmbq4NwnQ9RMPCFTIfeMtiQTML3llDNb17RVc1GoqalNtphpY+TaKkBEl/ugpnzsBAbcLHT/D/zQL43YV1T5ODUGFPguUKQJKRK9ETkmPQmCkXegM+A62dsgzVTt/R4GqHEMakiglYtut9s0vDWkmH/lgrYpN0sgfphsDpOZCMyGlXAUNUUAkOoxk2qqXOoJA0C2Bl2NWFJPBgMPuQ0zJc1nNI7Zwjdq5ALThhiV4QCQyhVstTtnk8V9iDY4zuS490aPzOk+S6hHDFacupKA52tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPz062nzyimp2ukwviHrG14bzmP83Q5TsnPYOjfEft8=;
 b=DO7kwTBiSRT6DZculmwdxjLULukQuVohg+vbQBM0wf3ypSF/KSxw5y+Rqid85tDgCxmAb8+IB6pef94Rjd3/2Wb9wyuqeg5bROVumzznRnzU1JFO9vjd1xz+3zsBhys6986+BSsk6NrzKiiG4MoRmttm+hNyc/OHcQcrsGStxmM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3077.namprd15.prod.outlook.com (20.178.239.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 06:56:28 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 06:56:28 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>
CC:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
Thread-Topic: [PATCH v2 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
Thread-Index: AQHVnw/6zUZCp1egDkKYUdXR4CKbu6eV7O4AgADGWACAABKBgA==
Date:   Fri, 22 Nov 2019 06:56:28 +0000
Message-ID: <f32ff58f-e455-1084-725d-3492fd68e28e@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-4-brianvv@google.com>
 <47ebff4c-1cb6-c136-b4a8-19dfe47a721f@fb.com>
 <CAMzD94SW6vr4V69mL3wNdLb9-O0y_z_Q6KehwuRw81WQ414bqA@mail.gmail.com>
In-Reply-To: <CAMzD94SW6vr4V69mL3wNdLb9-O0y_z_Q6KehwuRw81WQ414bqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:104:5::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::42ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dccb108-2105-46f2-76a7-08d76f19193e
x-ms-traffictypediagnostic: BYAPR15MB3077:
x-microsoft-antispam-prvs: <BYAPR15MB3077E6C12F440B90D7E82B48D3490@BYAPR15MB3077.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(39860400002)(366004)(136003)(189003)(199004)(76176011)(54906003)(14454004)(31686004)(86362001)(229853002)(71190400001)(81166006)(305945005)(36756003)(6486002)(71200400001)(478600001)(31696002)(316002)(25786009)(7736002)(6116002)(66446008)(64756008)(7416002)(66946007)(66476007)(66556008)(8936002)(52116002)(2906002)(256004)(446003)(386003)(8676002)(6512007)(14444005)(46003)(6246003)(6436002)(11346002)(5660300002)(6916009)(15650500001)(102836004)(99286004)(81156014)(53546011)(2616005)(186003)(6506007)(4326008)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3077;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dgviLeQNhGLyMFt881xbPwrE1rOvV10JF8CD7Osb4ISYZ1Eswzxql2vyR3keNyx76sr+NiPK+hJI58jtjBK8k4z3QBoCFDx5lrjbYUA37raXCIVGz7lqdOxCbAdxNwdIUwJXY6I357dP1R0/MXROKu7XfyviOf/wEbNHH7pxHhCBD1xGEyw59b2CIgGpiiplaH+tO0r9GBv9lWgQxCD5a8MgRoSM3tzD7ztNYCRgIan16hwiCR+8Nllg6Q5Qva6ZxPnPx4HznpX1gypqd0ij2a08l95oq10mtsAiDOrssdKIwuiS+HsYcXkV67oJLJUFgZa0TIiPaaAHcG9jhmC73WMK1eGODuyLSDoKKha0ae3srvUc3zhiGzBgDQo9pziF9yfIt0v3MOo42VchzR9cMsQl2WsJ6a7cs3e5syD7haD8FLt84yboS8drvf5keZZh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8F715B569DDFB418959830D37508470@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dccb108-2105-46f2-76a7-08d76f19193e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 06:56:28.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMPDauhX8fd5lQHLFmXYEiiifc9wauU4eHfmK8IiWX49NIBGbBYfxQjz89QoifXI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3077
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzIxLzE5IDk6NTAgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IEFDSyB0byBh
bGwgdGhlIG9ic2VydmF0aW9ucywgd2lsbCBmaXggaW4gdGhlIG5leHQgdmVyc2lvbi4gVGhlcmUg
YXJlDQo+IGp1c3QgMiB0aGluZ3MgbWlnaHQgYmUgY29ycmVjdCwgUFRBTC4NCj4gDQo+IE9uIFRo
dSwgTm92IDIxLCAyMDE5IGF0IDEwOjAwIEFNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdy
b3RlOg0KPj4NCj4+DQo+Pg0KPj4gT24gMTEvMTkvMTkgMTE6MzAgQU0sIEJyaWFuIFZhenF1ZXog
d3JvdGU6DQo+Pj4gVGhpcyBjb21taXQgYWRkcyBnZW5lcmljIHN1cHBvcnQgZm9yIHVwZGF0ZSBh
bmQgZGVsZXRlIGJhdGNoIG9wcyB0aGF0DQo+Pj4gY2FuIGJlIHVzZWQgZm9yIGFsbW9zdCBhbGwg
dGhlIGJwZiBtYXBzLiBUaGVzZSBjb21tYW5kcyBzaGFyZSB0aGUgc2FtZQ0KPj4+IFVBUEkgYXR0
ciB0aGF0IGxvb2t1cCBhbmQgbG9va3VwX2FuZF9kZWxldGUgYmF0Y2ggb3BzIHVzZSBhbmQgdGhl
DQo+Pj4gc3lzY2FsbCBjb21tYW5kcyBhcmU6DQo+Pj4NCj4+PiAgICAgQlBGX01BUF9VUERBVEVf
QkFUQ0gNCj4+PiAgICAgQlBGX01BUF9ERUxFVEVfQkFUQ0gNCj4+Pg0KPj4+IFRoZSBtYWluIGRp
ZmZlcmVuY2UgYmV0d2VlbiB1cGRhdGUvZGVsZXRlIGFuZCBsb29rdXAvbG9va3VwX2FuZF9kZWxl
dGUNCj4+PiBiYXRjaCBvcHMgaXMgdGhhdCBmb3IgdXBkYXRlL2RlbGV0ZSBrZXlzL3ZhbHVlcyBt
dXN0IGJlIHNwZWNpZmllZCBmb3INCj4+PiB1c2Vyc3BhY2UgYW5kIGJlY2F1c2Ugb2YgdGhhdCwg
bmVpdGhlciBpbl9iYXRjaCBub3Igb3V0X2JhdGNoIGFyZSB1c2VkLg0KPj4+DQo+Pj4gU3VnZ2Vz
dGVkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4NCj4+PiBTaWduZWQtb2Zm
LWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4+IC0tLQ0KPj4+ICAgIGluY2x1ZGUv
bGludXgvYnBmLmggICAgICB8ICAxMCArKysrDQo+Pj4gICAgaW5jbHVkZS91YXBpL2xpbnV4L2Jw
Zi5oIHwgICAyICsNCj4+PiAgICBrZXJuZWwvYnBmL3N5c2NhbGwuYyAgICAgfCAxMjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+Pj4gICAgMyBmaWxlcyBjaGFuZ2Vk
LCAxMzcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvYnBmLmggYi9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+Pj4gaW5kZXggNzY3
YTgyM2RiYWM3NC4uOTZhMTllMWZkMmI1YiAxMDA2NDQNCj4+PiAtLS0gYS9pbmNsdWRlL2xpbnV4
L2JwZi5oDQo+Pj4gKysrIGIvaW5jbHVkZS9saW51eC9icGYuaA0KPj4+IEBAIC00Niw2ICs0Niwx
MCBAQCBzdHJ1Y3QgYnBmX21hcF9vcHMgew0KPj4+ICAgICAgICBpbnQgKCptYXBfbG9va3VwX2Fu
ZF9kZWxldGVfYmF0Y2gpKHN0cnVjdCBicGZfbWFwICptYXAsDQo+Pj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5pb24gYnBmX2F0
dHIgX191c2VyICp1YXR0cik7DQo+Pj4gKyAgICAgaW50ICgqbWFwX3VwZGF0ZV9iYXRjaCkoc3Ry
dWN0IGJwZl9tYXAgKm1hcCwgY29uc3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+Pj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgdW5pb24gYnBmX2F0dHIgX191c2VyICp1YXR0cik7DQo+
Pj4gKyAgICAgaW50ICgqbWFwX2RlbGV0ZV9iYXRjaCkoc3RydWN0IGJwZl9tYXAgKm1hcCwgY29u
c3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgdW5pb24gYnBmX2F0dHIgX191c2VyICp1YXR0cik7DQo+Pj4NClsuLi5dDQo+Pj4gKw0KPj4+
ICsgICAgICAgICAgICAgcHJlZW1wdF9kaXNhYmxlKCk7DQo+Pj4gKyAgICAgICAgICAgICBfX3Ro
aXNfY3B1X2luYyhicGZfcHJvZ19hY3RpdmUpOw0KPj4+ICsgICAgICAgICAgICAgcmN1X3JlYWRf
bG9jaygpOw0KPj4+ICsgICAgICAgICAgICAgZXJyID0gbWFwLT5vcHMtPm1hcF9kZWxldGVfZWxl
bShtYXAsIGtleSk7DQo+Pj4gKyAgICAgICAgICAgICByY3VfcmVhZF91bmxvY2soKTsNCj4+PiAr
ICAgICAgICAgICAgIF9fdGhpc19jcHVfZGVjKGJwZl9wcm9nX2FjdGl2ZSk7DQo+Pj4gKyAgICAg
ICAgICAgICBwcmVlbXB0X2VuYWJsZSgpOw0KPj4+ICsgICAgICAgICAgICAgbWF5YmVfd2FpdF9i
cGZfcHJvZ3JhbXMobWFwKTsNCj4+PiArICAgICAgICAgICAgIGlmIChlcnIpDQo+Pj4gKyAgICAg
ICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+ICsgICAgIH0NCj4+PiArICAgICBpZiAoY29weV90
b191c2VyKCZ1YXR0ci0+YmF0Y2guY291bnQsICZjcCwgc2l6ZW9mKGNwKSkpDQo+Pj4gKyAgICAg
ICAgICAgICBlcnIgPSAtRUZBVUxUOw0KPj4NCj4+IElmIHByZXZpb3VzIGVyciA9IC1FRkFVTFQs
IGV2ZW4gaWYgY29weV90b191c2VyKCkgc3VjY2VlZGVkLA0KPj4gcmV0dXJuIHZhbHVlIHdpbGwg
YmUgLUVGQVVMVCwgc28gdWF0dHItPmJhdGNoLmNvdW50IGNhbm5vdCBiZQ0KPj4gdHJ1c3RlZC4g
U28gbWF5IGJlIGRvDQo+PiAgICAgIGlmIChlcnIgIT0gLUVGQVVMVCAmJiBjb3B5X3RvX3VzZXIo
Li4uKSkNCj4+ICAgICAgICAgZXJyID0gLUVGQVVMVA0KPj4gPw0KPj4gVGhlcmUgYXJlIHNldmVy
YWwgb3RoZXIgcGxhY2VzIGxpa2UgdGhpcy4NCj4gDQo+IEkgdGhpbmsgd2hhdGV2ZXIgdGhlIGVy
ciBpcywgY3AgY29udGFpbnMgdGhlIHJpZ2h0IGFtb3VudCBvZiBlbnRyaWVzDQo+IGNvcnJlY3Rs
eSB1cGRhdGVkL2RlbGV0ZWQgYW5kIHRoZSBpZGVhIGlzIHRoYXQgeW91IHNob3VsZCBhbHdheXMg
dHJ5DQo+IHRvIGNvcHkgdGhhdCB2YWx1ZSB0byBiYXRjaC5jb3VudCwgYW5kIGlmIHRoYXQgZmFp
bHMgd2hlbiB1YXR0ciB3YXMNCj4gY3JlYXRlZCBieSBsaWJicGYsIGV2ZXJ5dGhpbmcgd2FzIHNl
dCB0byAgMC4NCg0KVGhpcyBpcyB3aGF0IEkgbWVhbjoNCiAgIGVyciA9IC1FRkFVTFQ7IC8vIGZy
b20gcHJldmlvdXMgZXJyb3INCiAgIGlmIChjb3B5X3RvX3VzZXIoJnVhdHRyLT5iYXRjaC5jb3Vu
dCwgJmNwLCBzaXplb2YoY3ApKSkNCiAgICAgZXJyID0gLUVGQVVMVDsNCiAgIHJldHVybiBlcnI7
DQpVc2VyIHNwYWNlIHdpbGwgbm90IHRydXN0IHVhdHRyLT5iYXRjaC5jb3VudCBldmVuIGNvcHlf
dG9fdXNlcigpDQppcyBzdWNjZXNzZnVsIHNpbmNlIC1FRkFVTFQgaXMgcmV0dXJuZWQuDQoNClRo
ZXJlIGFyZSB0d28gd2F5cyB0byBhZGRyZXNzIHRoaXMgaXNzdWUgaWYgcHJldmlvdXMgZXJyb3Ig
aXMgLUVGQVVMVCwNCiAgIDEuIGRvIG5vdCBjb3B5X3RvX3VzZXIoKSBhbmQgcmV0dXJuIC1FRkFV
TFQsIHdoaWNoIGlzIEkgc3VnZ2VzdGVkDQogICAgICBpbiB0aGUgYWJvdmUuDQogICAyLiBnbyBh
aGVhZCB0byBkbyBjb3B5X3RvX3VzZXIoKSBhbmQgaWYgaXQgaXMgc3VjY2Vzc2Z1bCwgY2hhbmdl
DQogICAgICByZXR1cm4gdmFsdWUgdG8gc29tZXRoaW5nIGRpZmZlcmVudCBmcm9tIC1FRkFVTFQg
dG8gaW5kaWNhdGUNCiAgICAgIHRoYXQgdWF0dHItPmJhdGNoLmNvdW50IGlzIHZhbGlkLg0KDQpJ
IGZlZWwgaXQgaXMgaW1wb3J0YW50IHRvIHJldHVybiBhY3R1YWwgZXJyb3IgY29kZSAtRUZBVUxU
IHRvDQp1c2VyIHNvIHVzZXIga25vd3Mgc29tZSBmYXVsdCBoYXBwZW5zLiBSZXR1cm5pbmcgb3Ro
ZXIgZXJyb3IgY29kZQ0KbWF5IGJlIG1pc2xlYWRpbmcgZHVyaW5nIGRlYnVnZ2luZy4NCg0KPiAN
Cj4+DQo+Pj4gK2Vycl9wdXQ6DQo+Pg0KPj4gWW91IGRvbid0IG5lZWQgZXJyX3B1dCBsYWJlbCBp
biB0aGUgYWJvdmUuDQo+Pg0KPj4+ICsgICAgIHJldHVybiBlcnI7DQo+Pj4gK30NCj4+PiAraW50
IGdlbmVyaWNfbWFwX3VwZGF0ZV9iYXRjaChzdHJ1Y3QgYnBmX21hcCAqbWFwLA0KPj4+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHVuaW9uIGJwZl9hdHRyICphdHRyLA0KPj4+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgIHVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIpDQo+
Pj4gK3sNCj4+PiArICAgICB2b2lkIF9fdXNlciAqdmFsdWVzID0gdTY0X3RvX3VzZXJfcHRyKGF0
dHItPmJhdGNoLnZhbHVlcyk7DQo+Pj4gKyAgICAgdm9pZCBfX3VzZXIgKmtleXMgPSB1NjRfdG9f
dXNlcl9wdHIoYXR0ci0+YmF0Y2gua2V5cyk7DQo+Pj4gKyAgICAgdTMyIHZhbHVlX3NpemUsIGNw
LCBtYXhfY291bnQ7DQo+Pj4gKyAgICAgaW50IHVmZCA9IGF0dHItPm1hcF9mZDsNCj4+PiArICAg
ICB2b2lkICprZXksICp2YWx1ZTsNCj4+PiArICAgICBzdHJ1Y3QgZmQgZjsNCj4+PiArICAgICBp
bnQgZXJyOw0KPj4+ICsNCj4+PiArICAgICBmID0gZmRnZXQodWZkKTsNCj4+PiArICAgICBpZiAo
YXR0ci0+YmF0Y2guZWxlbV9mbGFncyAmIH5CUEZfRl9MT0NLKQ0KPj4+ICsgICAgICAgICAgICAg
cmV0dXJuIC1FSU5WQUw7DQo+Pj4gKw0KPj4+ICsgICAgIGlmICgoYXR0ci0+YmF0Y2guZWxlbV9m
bGFncyAmIEJQRl9GX0xPQ0spICYmDQo+Pj4gKyAgICAgICAgICFtYXBfdmFsdWVfaGFzX3NwaW5f
bG9jayhtYXApKSB7DQo+Pj4gKyAgICAgICAgICAgICBlcnIgPSAtRUlOVkFMOw0KPj4+ICsgICAg
ICAgICAgICAgZ290byBlcnJfcHV0Ow0KPj4NCj4+IERpcmVjdGx5IHJldHVybiAtRUlOVkFMPw0K
Pj4NCj4+PiArICAgICB9DQo+Pj4gKw0KPj4+ICsgICAgIHZhbHVlX3NpemUgPSBicGZfbWFwX3Zh
bHVlX3NpemUobWFwKTsNCj4+PiArDQo+Pj4gKyAgICAgbWF4X2NvdW50ID0gYXR0ci0+YmF0Y2gu
Y291bnQ7DQo+Pj4gKyAgICAgaWYgKCFtYXhfY291bnQpDQo+Pj4gKyAgICAgICAgICAgICByZXR1
cm4gMDsNCj4+PiArDQo+Pj4gKyAgICAgZXJyID0gLUVOT01FTTsNCj4+PiArICAgICB2YWx1ZSA9
IGttYWxsb2ModmFsdWVfc2l6ZSwgR0ZQX1VTRVIgfCBfX0dGUF9OT1dBUk4pOw0KPj4+ICsgICAg
IGlmICghdmFsdWUpDQo+Pj4gKyAgICAgICAgICAgICBnb3RvIGVycl9wdXQ7DQo+Pg0KPj4gRGly
ZWN0bHkgcmV0dXJuIC1FTk9NRU0/DQo+Pg0KPj4+ICsNCj4+PiArICAgICBmb3IgKGNwID0gMDsg
Y3AgPCBtYXhfY291bnQ7IGNwKyspIHsNCj4+PiArICAgICAgICAgICAgIGtleSA9IF9fYnBmX2Nv
cHlfa2V5KGtleXMgKyBjcCAqIG1hcC0+a2V5X3NpemUsIG1hcC0+a2V5X3NpemUpOw0KPj4NCj4+
IERvIHlvdSBuZWVkIHRvIGZyZWUgJ2tleScgYWZ0ZXIgaXRzIHVzZT8NCj4+DQo+Pj4gKyAgICAg
ICAgICAgICBpZiAoSVNfRVJSKGtleSkpIHsNCj4+PiArICAgICAgICAgICAgICAgICAgICAgZXJy
ID0gUFRSX0VSUihrZXkpOw0KPj4+ICsgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4+PiAr
ICAgICAgICAgICAgIH0NCj4+PiArICAgICAgICAgICAgIGVyciA9IC1FRkFVTFQ7DQo+Pj4gKyAg
ICAgICAgICAgICBpZiAoY29weV9mcm9tX3VzZXIodmFsdWUsIHZhbHVlcyArIGNwICogdmFsdWVf
c2l6ZSwgdmFsdWVfc2l6ZSkpDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+
ICsNCj4+PiArICAgICAgICAgICAgIGVyciA9IGJwZl9tYXBfdXBkYXRlX3ZhbHVlKG1hcCwgZiwg
a2V5LCB2YWx1ZSwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGF0dHItPmJhdGNoLmVsZW1fZmxhZ3MpOw0KPj4+ICsNCj4+PiArICAgICAgICAgICAgIGlmIChl
cnIpDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+ICsgICAgIH0NCj4+PiAr
DQo+Pj4gKyAgICAgaWYgKGNvcHlfdG9fdXNlcigmdWF0dHItPmJhdGNoLmNvdW50LCAmY3AsIHNp
emVvZihjcCkpKQ0KPj4+ICsgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsNCj4+DQo+PiBTaW1p
bGFyIHRvIHRoZSBhYm92ZSBjb21tZW50LCBpZiBlcnIgYWxyZWFkeSAtRUZBVUxULCBubyBuZWVk
DQo+PiB0byBkbyBjb3B5X3RvX3VzZXIoKS4NCj4+DQo+Pj4gKw0KPj4+ICsgICAgIGtmcmVlKHZh
bHVlKTsNCj4+PiArZXJyX3B1dDoNCj4+DQo+PiBlcnJfcHV0IGxhYmVsIGlzIG5vdCBuZWVkZWQu
DQo+Pg0KPj4+ICsgICAgIHJldHVybiBlcnI7DQo+Pj4gK30NCj4+PiArDQo+Pj4gICAgc3RhdGlj
IGludCBfX2dlbmVyaWNfbWFwX2xvb2t1cF9iYXRjaChzdHJ1Y3QgYnBmX21hcCAqbWFwLA0KPj4+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCB1bmlvbiBicGZfYXR0
ciAqYXR0ciwNCj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5pb24g
YnBmX2F0dHIgX191c2VyICp1YXR0ciwNCj4+PiBAQCAtMzExNyw4ICszMjMxLDEyIEBAIHN0YXRp
YyBpbnQgYnBmX21hcF9kb19iYXRjaChjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4+Pg0K
Pj4+ICAgICAgICBpZiAoY21kID09IEJQRl9NQVBfTE9PS1VQX0JBVENIKQ0KPj4+ICAgICAgICAg
ICAgICAgIEJQRl9ET19CQVRDSChtYXAtPm9wcy0+bWFwX2xvb2t1cF9iYXRjaCk7DQo+Pj4gLSAg
ICAgZWxzZQ0KPj4+ICsgICAgIGVsc2UgaWYgKGNtZCA9PSBCUEZfTUFQX0xPT0tVUF9BTkRfREVM
RVRFX0JBVENIKQ0KPj4+ICAgICAgICAgICAgICAgIEJQRl9ET19CQVRDSChtYXAtPm9wcy0+bWFw
X2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoKTsNCj4+PiArICAgICBlbHNlIGlmIChjbWQgPT0gQlBG
X01BUF9VUERBVEVfQkFUQ0gpDQo+Pj4gKyAgICAgICAgICAgICBCUEZfRE9fQkFUQ0gobWFwLT5v
cHMtPm1hcF91cGRhdGVfYmF0Y2gpOw0KPj4+ICsgICAgIGVsc2UNCj4+PiArICAgICAgICAgICAg
IEJQRl9ET19CQVRDSChtYXAtPm9wcy0+bWFwX2RlbGV0ZV9iYXRjaCk7DQo+Pg0KPj4gQWxzbyBu
ZWVkIHRvIGNoZWNrIG1hcF9nZXRfc3lzX3Blcm1zKCkgcGVybWlzc2lvbnMgZm9yIHRoZXNlIHR3
byBuZXcNCj4+IGNvbW1hbmRzLiBCb3RoIGRlbGV0ZSBhbmQgdXBkYXRlIG5lZWRzIEZNT0RFX0NB
Tl9XUklURSBwZXJtaXNzaW9uLg0KPj4NCj4gSSBhbHNvIGdvdCBjb25mdXNlZCBmb3IgYSBtb21l
bnQsIHRoZSBjaGVjayBpcyBjb3JyZWN0IHNpbmNlIGlzIHVzaW5nDQo+ICchPScgbm90ICc9PScN
Cj4gaWYgKGNtZCAhPSBCUEZfTUFQX0xPT0tVUF9CQVRDSCAmJg0KPiAgICAgICAgICAgICAgISht
YXBfZ2V0X3N5c19wZXJtcyhtYXAsIGYpICYgRk1PREVfQ0FOX1dSSVRFKSkgew0KPiANCj4gc28g
YmFzaWNhbGx5IHRoYXQgbWVhbnMgdGhhdCBjbWQgaXMgdXBkYXRlLGRlbGV0ZSBvciBsb29rdXBf
YW5kX2RlbGV0ZQ0KPiBzbyB3ZSBjaGVjayBtYXBfZ2V0X3N5c19wZXJtcy4NCg0KSSBtaXNzZWQg
dGhpcy4gVGhhbmtzIGZvciBleHBsYW5hdGlvbiENCg==
