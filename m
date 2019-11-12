Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE577F93E6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKLPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:18:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727224AbfKLPS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:18:27 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xACF3Van007364;
        Tue, 12 Nov 2019 07:18:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k1meyRZz/w/FGTt40Epwtu5H3FnwGEKYpr8FcbCEH1Y=;
 b=dkskIT+/JyRJWjSMz1F0nH+3QzJdvDuQKum/GElAH7/L16wHi5v8aVQT24BZA6Lwb5eC
 6CVIb9f/qsQgGerE8/0JztN5ohOGbPQR3AIGaVqZVVA73QOYpjgXLzxHPzDmhtu8CCkh
 LxTd/drForad/EJcZ2MP3BZXdr+AW0lfgw4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w7pr2jeky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Nov 2019 07:18:23 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 12 Nov 2019 07:18:22 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 12 Nov 2019 07:18:22 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 07:18:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXw5d9ZwsxkHwcyZYhSxyHcrIIT9jVzSN+floT6CJKYd+K/O7c1gHXj80LmWb7akR3uEaieOrdDxmMJjzEd/IP4B24kt2opbo/vCbeIVBTLYFlFhRzc4GFy/V2HUY6adAFfaVyn97NVVoA2eLxKZVEEzDZK90P8ijKthOxVFZLOH74xQedsg1ag6iEKqG2dlMkF7oNxyRAbozsWH+KUIV0f5bU1uoaBIdrVBizuGp4qn3XoIe6FXmGprUy8tt1KpZCOacw47fvHFlnrV7yJIsie1pJ/7iMYj3EX/ml0eXSGRHoTXNPE8QgD2BFWmK+E3SyULYkYbu7aztzcM9ttiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1meyRZz/w/FGTt40Epwtu5H3FnwGEKYpr8FcbCEH1Y=;
 b=GPixfGS/GeeT6ND1KFzgcWtk9oG5KUpLDu3nsvcfDZD5P/QIWduwPmu59sIDGC66j//rqs6kSwh6T10lwSMCVPq5IHul8hSDGcQ2zvsGF/uCMX37kJ/f7Puxcxv00AGixewJP9/B6byClAFGvgYC9+yql2uMrMKZZSM8cPOp+rCgwb7ytOd4ovd7nedrFVpcC3Wpv5a/0sCBFQykxfoCO4hOi/8X4wH9sxmL8Gf2dAZyCvZ1M/DCel/TFnR2p/y6nJBGmEw18u9xPyiPVtGk+nby2gKGHBZRssZoX1u3z0jtXvpPrQ0XgZGRQ8DXjCBEH4hM0wCyYkr77PZqzqrkGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1meyRZz/w/FGTt40Epwtu5H3FnwGEKYpr8FcbCEH1Y=;
 b=j+p/Oi2Zm6Uyzqqt003gQPuoTmaIOo9ksc981/4w+tSoclVZxf+BHKnNoKKKFlK4FDC80GBJHf6YzbCaKJMnViC9rk46JudV9EOeuWaGiJtTdnMlW6zI0YIp88fVa5LqBt6PnWgveraPi7TJvk5b/hLbh6SqWX0YKCy/uGtrx3o=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2616.namprd15.prod.outlook.com (20.179.154.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 15:18:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 15:18:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [Review Request] Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Topic: [Review Request] Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Index: AQHViQ10L4Sk4Hu3bUSGIRdEQH4YW6dnizGAgAitNYCABLXngIAS2D8A
Date:   Tue, 12 Nov 2019 15:18:20 +0000
Message-ID: <4b323ffc-0b04-a00e-0e39-734dee0e2578@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-2-cneirabustos@gmail.com>
 <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
 <63882673-849d-cae3-1432-1d9411c10348@fb.com>
 <01acf191-f1aa-bf01-0945-56e4f37af69b@fb.com>
In-Reply-To: <01acf191-f1aa-bf01-0945-56e4f37af69b@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:300:ed::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9256]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fcb438d-39a5-4b09-c9d3-08d767838d3f
x-ms-traffictypediagnostic: BYAPR15MB2616:
x-microsoft-antispam-prvs: <BYAPR15MB26162B4335F1D19E678BAC3FD3770@BYAPR15MB2616.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(81166006)(31686004)(8676002)(2616005)(476003)(52116002)(8936002)(46003)(71200400001)(71190400001)(446003)(14444005)(486006)(256004)(11346002)(99286004)(1730700003)(31696002)(53546011)(6916009)(7736002)(2906002)(54906003)(102836004)(81156014)(316002)(305945005)(2351001)(76176011)(186003)(86362001)(6506007)(386003)(5660300002)(14454004)(6486002)(6436002)(5640700003)(478600001)(2501003)(6246003)(6512007)(66556008)(66446008)(64756008)(66946007)(36756003)(66476007)(4326008)(6116002)(229853002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2616;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UrEDf25u9wegDDdENTvdobpSFLMF9ffp6Nbkl1h8TQ1nqPwIuNKnpSzM4nyK2q6o/LGRTsAzir9xu6Jrdk89huea8AWWNpgP0I3csicDi3nS3aD+uCLvKePMQszItMooUmUzTCqocru8W/n3JzlnlSesZuJoqmiN1FnWFT0UEtLOGZsxAxwFrohjrhQofNmd3LVYj/WDRYXA2uDWq/Txz9s50VcE2FPXSWKR+pOf52MwUrjsqai3+28ys0iI+9DuWeYFL+FPdEeOAJoGXVhAc2R1UwGwLnvZ73LHJmubT4Y3rDWUiWwAW8kbn/sJc0+itE2leB7jD5YMmTWRZn2N9RQU98a5h5pwvWhJf3C2xl9Z/Gkq3zD6rZZGzfCUxsCqDDZWdyH703JpsG9PxsumOpWX2n/b2Kx8hsfVWKwZiIAVgPK0/6oV2ylhqhlqVjDS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E1546F2C4FA3E4792BCA38A63B37171@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcb438d-39a5-4b09-c9d3-08d767838d3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 15:18:20.6737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UwVKFWhpI7h2dK3V5ypPv5fP4OldTbY0uuQ5xhxMh+XHVx04J7h4cWTFN3f3TQ4y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2616
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_04:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 mlxscore=0 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911120133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYywNCg0KcGluZyBhZ2Fpbi4gQW55IGNvbW1lbnQgb24gdGhpcyBwYXRjaD8NCg0KT24gMTAv
MzEvMTkgMzozMSBQTSwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4gDQo+IEVyaWMsDQo+IA0KPiBJ
biBjYXNlIHRoYXQgeW91IG1pc3NlZCB0aGUgZW1haWwsIEkgYWRkZWQgIltSZXZpZXcgUmVxdWVz
dF0iDQo+IGFuZCBwaW5nZWQgYWdhaW4uIEl0IHdvdWxkIGJlIGdvb2QgaWYgeW91IGNhbiB0YWtl
IGEgbG9vaw0KPiBhbmQgYWNrIGlmIGl0IGxvb2tzIGdvb2QgdG8geW91Lg0KPiANCj4gVGhhbmtz
IQ0KPiANCj4gDQo+IE9uIDEwLzI4LzE5IDg6MzQgQU0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+
PiBQaW5nIGFnYWluLg0KPj4NCj4+IEVyaWMsIGNvdWxkIHlvdSB0YWtlIGEgbG9vayBhdCB0aGlz
IHBhdGNoIGFuZCBhY2sgaXQgaWYgaXQgaXMgb2theT8NCj4+DQo+PiBUaGFua3MhDQo+Pg0KPj4N
Cj4+IE9uIDEwLzIyLzE5IDg6MDUgUE0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+Pj4NCj4+PiBI
aSwgRXJpYywNCj4+Pg0KPj4+IENvdWxkIHlvdSB0YWtlIGEgbG9vayBhdCB0aGlzIHBhdGNoIHRo
ZSBzZXJpZXMgYXMgd2VsbD8NCj4+PiBJZiBpdCBsb29rcyBnb29kLCBjb3VsZCB5b3UgYWNrIHRo
ZSBwYXRjaCAjMT8NCj4+Pg0KPj4+IFRoYW5rcyENCj4+Pg0KPj4+IE9uIDEwLzIyLzE5IDEyOjE3
IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+Pj4+IG5zX21hdGNoIHJldHVybnMgdHJ1ZSBpZiB0
aGUgbmFtZXNwYWNlIGlub2RlIGFuZCBkZXZfdCBtYXRjaGVzIHRoZSBvbmVzDQo+Pj4+IHByb3Zp
ZGVkIGJ5IHRoZSBjYWxsZXIuDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IENhcmxvcyBOZWly
YSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCj4+Pj4gLS0tDQo+Pj4+IMKgwqDCoCBmcy9uc2Zz
LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTQgKysrKysrKysrKysrKysNCj4+Pj4g
wqDCoMKgIGluY2x1ZGUvbGludXgvcHJvY19ucy5oIHzCoCAyICsrDQo+Pj4+IMKgwqDCoCAyIGZp
bGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKykNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2Zz
L25zZnMuYyBiL2ZzL25zZnMuYw0KPj4+PiBpbmRleCBhMDQzMTY0MmM2YjUuLmVmNTljZjM0NzI4
NSAxMDA2NDQNCj4+Pj4gLS0tIGEvZnMvbnNmcy5jDQo+Pj4+ICsrKyBiL2ZzL25zZnMuYw0KPj4+
PiBAQCAtMjQ1LDYgKzI0NSwyMCBAQCBzdHJ1Y3QgZmlsZSAqcHJvY19uc19mZ2V0KGludCBmZCkN
Cj4+Pj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+Pj4+IMKgwqDC
oCB9DQo+Pj4+ICsvKioNCj4+Pj4gKyAqIG5zX21hdGNoKCkgLSBSZXR1cm5zIHRydWUgaWYgY3Vy
cmVudCBuYW1lc3BhY2UgbWF0Y2hlcyBkZXYvaW5vIA0KPj4+PiBwcm92aWRlZC4NCj4+Pj4gKyAq
IEBuc19jb21tb246IGN1cnJlbnQgbnMNCj4+Pj4gKyAqIEBkZXY6IGRldl90IGZyb20gbnNmcyB0
aGF0IHdpbGwgYmUgbWF0Y2hlZCBhZ2FpbnN0IGN1cnJlbnQgbnNmcw0KPj4+PiArICogQGlubzog
aW5vX3QgZnJvbSBuc2ZzIHRoYXQgd2lsbCBiZSBtYXRjaGVkIGFnYWluc3QgY3VycmVudCBuc2Zz
DQo+Pj4+ICsgKg0KPj4+PiArICogUmV0dXJuOiB0cnVlIGlmIGRldiBhbmQgaW5vIG1hdGNoZXMg
dGhlIGN1cnJlbnQgbnNmcy4NCj4+Pj4gKyAqLw0KPj4+PiArYm9vbCBuc19tYXRjaChjb25zdCBz
dHJ1Y3QgbnNfY29tbW9uICpucywgZGV2X3QgZGV2LCBpbm9fdCBpbm8pDQo+Pj4+ICt7DQo+Pj4+
ICvCoMKgwqAgcmV0dXJuIChucy0+aW51bSA9PSBpbm8pICYmIChuc2ZzX21udC0+bW50X3NiLT5z
X2RldiA9PSBkZXYpOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICsNCj4+Pj4gwqDCoMKgIHN0YXRp
YyBpbnQgbnNmc19zaG93X3BhdGgoc3RydWN0IHNlcV9maWxlICpzZXEsIHN0cnVjdCBkZW50cnkg
DQo+Pj4+ICpkZW50cnkpDQo+Pj4+IMKgwqDCoCB7DQo+Pj4+IMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L3Byb2NfbnMuaCBiL2luY2x1ZGUvbGludXgvcHJvY19ucy5oDQo+Pj4+IGluZGV4
IGQzMWNiNjIxNTkwNS4uMWRhOWYzMzQ4OWYzIDEwMDY0NA0KPj4+PiAtLS0gYS9pbmNsdWRlL2xp
bnV4L3Byb2NfbnMuaA0KPj4+PiArKysgYi9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaA0KPj4+PiBA
QCAtODIsNiArODIsOCBAQCB0eXBlZGVmIHN0cnVjdCBuc19jb21tb24gDQo+Pj4+ICpuc19nZXRf
cGF0aF9oZWxwZXJfdCh2b2lkICopOw0KPj4+PiDCoMKgwqAgZXh0ZXJuIHZvaWQgKm5zX2dldF9w
YXRoX2NiKHN0cnVjdCBwYXRoICpwYXRoLCANCj4+Pj4gbnNfZ2V0X3BhdGhfaGVscGVyX3QgbnNf
Z2V0X2NiLA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2b2lk
ICpwcml2YXRlX2RhdGEpOw0KPj4+PiArZXh0ZXJuIGJvb2wgbnNfbWF0Y2goY29uc3Qgc3RydWN0
IG5zX2NvbW1vbiAqbnMsIGRldl90IGRldiwgaW5vX3QgDQo+Pj4+IGlubyk7DQo+Pj4+ICsNCj4+
Pj4gwqDCoMKgIGV4dGVybiBpbnQgbnNfZ2V0X25hbWUoY2hhciAqYnVmLCBzaXplX3Qgc2l6ZSwg
c3RydWN0IA0KPj4+PiB0YXNrX3N0cnVjdCAqdGFzaywNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBwcm9jX25zX29wZXJhdGlvbnMgKm5zX29wcyk7DQo+
Pj4+IMKgwqDCoCBleHRlcm4gdm9pZCBuc2ZzX2luaXQodm9pZCk7DQo+Pj4+DQo=
