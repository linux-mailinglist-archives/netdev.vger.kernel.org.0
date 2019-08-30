Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD8A30EE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfH3H0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:26:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbfH3H0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:26:20 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U7Msu9031271;
        Fri, 30 Aug 2019 00:25:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B5lhDcFLCVxuTrfGDbc+8muLtjKXtkLWiym8c/cDQhU=;
 b=mWekS3Bl0m1FzferwntttqNqxwkk/m453oWWD365ooJnX80cTAJtgWUqs8GtEIh8AvQo
 AhuVyO60x7vzwl/R8s7wR6qPocIOHeJf94qrCUsMDqpdk54IIXSG19xOUXIUq81eVybK
 6d/qEWPvWVrffImrt4eONOIi079tUS0VVGI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2upfdvcesj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 00:25:57 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 00:25:57 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 00:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dq6K8P3ZFBKrcJ+ZUErRPQCXpJWutIBkgIRIc9qYVvUlHHVFilkN4ww33ghOtujbVJZriZsH8YXOKie48oh82SH3LZfJeI2974XsUUz0OY6MYgDeeBzVfoS0uJx8N759aATVtWEFCbUkGdPrm3qbddfC1sqmnYJh5gnfSDgz59AWShgUZxhGkSlA1vcGCdgJ1E+6qcMIGw48n+hdDtqEKVnZP/lptVVg7d2mquFwMHFUTIPJofqU2xwXM3VTk12z3jXYJuZm9swbGC7xqtYITxKmx2nJHq7/rMG1RSPjBXJAYDsUNRdUqgjZByPGFplTB5hj13gkiB1iV4pfv6r7GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5lhDcFLCVxuTrfGDbc+8muLtjKXtkLWiym8c/cDQhU=;
 b=AXQDe5eeU4FyNI58C70mLdMZc7MH00408j3W6fHt3lTCSqGz9a5EMXJRGGnTzg08Lwhpa9QrxmfI4PWzCRqa3kzrHE2mUPEvfnnyKvpQylPu9hNEBE3ySSb1HKkjgbDGtInAB/zYBaHIwhp3rGDkde5zNYMNtzBOcy4HpUyATPLrTP6N81by2d6CLbBHovoNElPYaVuGK7tJpUM+cTqSSiPkZ84je5ABFCe2YMm8F7/1eu4Y67Q43egEChW6Zaqr9nay4dWETLcEJiXkSSZtLi8jG4Zod6WlrltEEzNjOAVYTTQmKUNSs/sPmxB7WUfb/dPxATTTxlA9jhLaaNPAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5lhDcFLCVxuTrfGDbc+8muLtjKXtkLWiym8c/cDQhU=;
 b=GshWykuADSpHaWZrnoyOUJfevKi17Yu7bXAxuL4KDMvDbx85ounDGjdNFVYquGT61kVq1gEG2bO+Xkve2KBrlpYGXYJQl5wAFamkHvSQ1+oO9dXF7CF949olzgw9IxSWugUKA1P2qTbKFWf0SXWh/L6twX4ZFpEQfg+mwg3PXuE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3110.namprd15.prod.outlook.com (20.178.239.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Fri, 30 Aug 2019 07:25:55 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 07:25:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Topic: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Index: AQHVXjVV7RBe3Y+1zUuAbrXegepHf6cSdccAgADWGgA=
Date:   Fri, 30 Aug 2019 07:25:54 +0000
Message-ID: <a3422ffd-e9f2-af77-a92d-81393a9f4fc7@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
In-Reply-To: <20190829113932.5c058194@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:104:6::11) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5364]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96a6fbc6-a75a-41aa-7a00-08d72d1b4b2b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3110;
x-ms-traffictypediagnostic: BYAPR15MB3110:
x-ms-exchange-purlcount: 6
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB311067B5841343BAAC99D526D3BD0@BYAPR15MB3110.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(396003)(39850400004)(376002)(189003)(199004)(66446008)(71200400001)(71190400001)(66946007)(5660300002)(64756008)(66556008)(6486002)(8676002)(81166006)(81156014)(229853002)(4326008)(102836004)(53546011)(6506007)(46003)(386003)(66476007)(8936002)(476003)(2616005)(486006)(11346002)(446003)(7736002)(186003)(256004)(14444005)(478600001)(25786009)(99286004)(14454004)(6116002)(86362001)(52116002)(54906003)(966005)(305945005)(6636002)(110136005)(2906002)(6246003)(31696002)(6512007)(6436002)(316002)(31686004)(76176011)(36756003)(6306002)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3110;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vFfJfdau7blLVo3nJWtlCK9hLNIbYVN7DL7L/Qa1yB6f4oC3pwXgzN9lbwjFCkH+EF1UcCIaBdBc2b9rZcdXi7hhzCq9TbcrE/YW4QRMYQLiEzDZ6vuC/lf0eiaYasZYKWxAib5V9KiRZpeeJlTxqiEi8L/K2BOSu+sVuxYzQZYTP1hsFdOjoaQju2S2ef/YuCMpaNYykON/+rq1TRt9b0/3uycY73BpGteOK/lQQskHTJgtACSCymHkwgM7b7YR8IC6zUMNtgOlX+nt8Ru79ITV1HT6Xh4Jle2eSZhZ4MbysaaiJhPa3DWLocPV6fM79nHnUaaLXJuWG3EZlTxSnVXB73wB0wG/LABN+guUgfm08xsf0d4vzfSTwQNnDevuHqCqszNGztpj3UD67fQekf/pIel2w3iebs/YbAVUtfI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B937738043D3944680EBC303778BA1C5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a6fbc6-a75a-41aa-7a00-08d72d1b4b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 07:25:54.7470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sgEjE6GfEWYJftqgXEqOTSibbxzdQKtf1h+OS8QKHiWhJk4LA1RXbzj4Iu6P1n+a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3110
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300078
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjkvMTkgMTE6MzkgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBXZWQs
IDI4IEF1ZyAyMDE5IDIzOjQ1OjAyIC0wNzAwLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gQnJp
YW4gVmF6cXVleiBoYXMgcHJvcG9zZWQgQlBGX01BUF9EVU1QIGNvbW1hbmQgdG8gbG9vayB1cCBt
b3JlIHRoYW4gb25lDQo+PiBtYXAgZW50cmllcyBwZXIgc3lzY2FsbC4NCj4+ICAgIGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2JwZi9DQUJDZ3BhVTN4eFg2Q01NeEQrMWtuQXBpdnRjMmpMQkh5c0RY
dy0wRTliUUVMMHFDM0FAbWFpbC5nbWFpbC5jb20vVC8jdA0KPj4NCj4+IER1cmluZyBkaXNjdXNz
aW9uLCB3ZSBmb3VuZCBtb3JlIHVzZSBjYXNlcyBjYW4gYmUgc3VwcG9ydGVkIGluIGEgc2ltaWxh
cg0KPj4gbWFwIG9wZXJhdGlvbiBiYXRjaGluZyBmcmFtZXdvcmsuIEZvciBleGFtcGxlLCBiYXRj
aGVkIG1hcCBsb29rdXAgYW5kIGRlbGV0ZSwNCj4+IHdoaWNoIGNhbiBiZSByZWFsbHkgaGVscGZ1
bCBmb3IgYmNjLg0KPj4gICAgaHR0cHM6Ly9naXRodWIuY29tL2lvdmlzb3IvYmNjL2Jsb2IvbWFz
dGVyL3Rvb2xzL3RjcHRvcC5weSNMMjMzLUwyNDMNCj4+ICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9p
b3Zpc29yL2JjYy9ibG9iL21hc3Rlci90b29scy9zbGFicmF0ZXRvcC5weSNMMTI5LUwxMzgNCj4+
ICAgICAgDQo+PiBBbHNvLCBpbiBiY2MsIHdlIGhhdmUgQVBJIHRvIGRlbGV0ZSBhbGwgZW50cmll
cyBpbiBhIG1hcC4NCj4+ICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9pb3Zpc29yL2JjYy9ibG9iL21h
c3Rlci9zcmMvY2MvYXBpL0JQRlRhYmxlLmgjTDI1Ny1MMjY0DQo+Pg0KPj4gRm9yIG1hcCB1cGRh
dGUsIGJhdGNoZWQgb3BlcmF0aW9ucyBhbHNvIHVzZWZ1bCBhcyBzb21ldGltZXMgYXBwbGljYXRp
b25zIG5lZWQNCj4+IHRvIHBvcHVsYXRlIGluaXRpYWwgbWFwcyB3aXRoIG1vcmUgdGhhbiBvbmUg
ZW50cnkuIEZvciBleGFtcGxlLCB0aGUgYmVsb3cNCj4+IGV4YW1wbGUgaXMgZnJvbSBrZXJuZWwv
c2FtcGxlcy9icGYveGRwX3JlZGlyZWN0X2NwdV91c2VyLmM6DQo+PiAgICBodHRwczovL2dpdGh1
Yi5jb20vdG9ydmFsZHMvbGludXgvYmxvYi9tYXN0ZXIvc2FtcGxlcy9icGYveGRwX3JlZGlyZWN0
X2NwdV91c2VyLmMjTDU0My1MNTUwDQo+Pg0KPj4gVGhpcyBwYXRjaCBhZGRyZXNzZXMgYWxsIHRo
ZSBhYm92ZSB1c2UgY2FzZXMuIFRvIG1ha2UgdWFwaSBzdGFibGUsIGl0IGFsc28NCj4+IGNvdmVy
cyBvdGhlciBwb3RlbnRpYWwgdXNlIGNhc2VzLiBGb3VyIGJwZiBzeXNjYWxsIHN1YmNvbW1hbmRz
IGFyZSBpbnRyb2R1Y2VkOg0KPj4gICAgICBCUEZfTUFQX0xPT0tVUF9CQVRDSA0KPj4gICAgICBC
UEZfTUFQX0xPT0tVUF9BTkRfREVMRVRFX0JBVENIDQo+PiAgICAgIEJQRl9NQVBfVVBEQVRFX0JB
VENIDQo+PiAgICAgIEJQRl9NQVBfREVMRVRFX0JBVENIDQo+Pg0KPj4gSW4gdXNlcnNwYWNlLCBh
cHBsaWNhdGlvbiBjYW4gaXRlcmF0ZSB0aHJvdWdoIHRoZSB3aG9sZSBtYXAgb25lIGJhdGNoDQo+
PiBhcyBhIHRpbWUsIGUuZy4sIGJwZl9tYXBfbG9va3VwX2JhdGNoKCkgaW4gdGhlIGJlbG93Og0K
Pj4gICAgICBwX2tleSA9IE5VTEw7DQo+PiAgICAgIHBfbmV4dF9rZXkgPSAma2V5Ow0KPj4gICAg
ICB3aGlsZSAodHJ1ZSkgew0KPj4gICAgICAgICBlcnIgPSBicGZfbWFwX2xvb2t1cF9iYXRjaChm
ZCwgcF9rZXksICZwX25leHRfa2V5LCBrZXlzLCB2YWx1ZXMsDQo+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICZiYXRjaF9zaXplLCBlbGVtX2ZsYWdzLCBmbGFncyk7DQo+PiAg
ICAgICAgIGlmIChlcnIpIC4uLg0KPj4gICAgICAgICBpZiAocF9uZXh0X2tleSkgYnJlYWs7IC8v
IGRvbmUNCj4+ICAgICAgICAgaWYgKCFwX2tleSkgcF9rZXkgPSBwX25leHRfa2V5Ow0KPj4gICAg
ICB9DQo+PiBQbGVhc2UgbG9vayBhdCBpbmRpdmlkdWFsIHBhdGNoZXMgZm9yIGRldGFpbHMgb2Yg
bmV3IHN5c2NhbGwgc3ViY29tbWFuZHMNCj4+IGFuZCBleGFtcGxlcyBvZiB1c2VyIGNvZGVzLg0K
Pj4NCj4+IFRoZSB0ZXN0aW5nIGlzIGFsc28gZG9uZSBpbiBhIHFlbXUgVk0gZW52aXJvbm1lbnQ6
DQo+PiAgICAgICAgbWVhc3VyZV9sb29rdXA6IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNoIDEw
LCB0aW1lIDM0Mm1zDQo+PiAgICAgICAgbWVhc3VyZV9sb29rdXA6IG1heF9lbnRyaWVzIDEwMDAw
MDAsIGJhdGNoIDEwMDAsIHRpbWUgMjk1bXMNCj4+ICAgICAgICBtZWFzdXJlX2xvb2t1cDogbWF4
X2VudHJpZXMgMTAwMDAwMCwgYmF0Y2ggMTAwMDAwMCwgdGltZSAyNzBtcw0KPj4gICAgICAgIG1l
YXN1cmVfbG9va3VwOiBtYXhfZW50cmllcyAxMDAwMDAwLCBubyBiYXRjaGluZywgdGltZSAxMzQ2
bXMNCj4+ICAgICAgICBtZWFzdXJlX2xvb2t1cF9kZWxldGU6IG1heF9lbnRyaWVzIDEwMDAwMDAs
IGJhdGNoIDEwLCB0aW1lIDQzM21zDQo+PiAgICAgICAgbWVhc3VyZV9sb29rdXBfZGVsZXRlOiBt
YXhfZW50cmllcyAxMDAwMDAwLCBiYXRjaCAxMDAwLCB0aW1lIDM2M21zDQo+PiAgICAgICAgbWVh
c3VyZV9sb29rdXBfZGVsZXRlOiBtYXhfZW50cmllcyAxMDAwMDAwLCBiYXRjaCAxMDAwMDAwLCB0
aW1lIDM1N21zDQo+PiAgICAgICAgbWVhc3VyZV9sb29rdXBfZGVsZXRlOiBtYXhfZW50cmllcyAx
MDAwMDAwLCBub3QgYmF0Y2gsIHRpbWUgMTg5NG1zDQo+PiAgICAgICAgbWVhc3VyZV9kZWxldGU6
IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNoLCB0aW1lIDIyMG1zDQo+PiAgICAgICAgbWVhc3Vy
ZV9kZWxldGU6IG1heF9lbnRyaWVzIDEwMDAwMDAsIG5vdCBiYXRjaCwgdGltZSAxMjg5bXMNCj4+
IEZvciBhIDFNIGVudHJ5IGhhc2ggdGFibGUsIGJhdGNoIHNpemUgb2YgMTAgY2FuIHJlZHVjZSBj
cHUgdGltZQ0KPj4gYnkgNzAlLiBQbGVhc2Ugc2VlIHBhdGNoICJ0b29scy9icGY6IG1lYXN1cmUg
bWFwIGJhdGNoaW5nIHBlcmYiDQo+PiBmb3IgZGV0YWlscyBvZiB0ZXN0IGNvZGVzLg0KPiANCj4g
SGkgWW9uZ2hvbmchDQo+IA0KPiBncmVhdCB0byBzZWUgdGhpcywgd2UgaGF2ZSBiZWVuIGxvb2tp
bmcgYXQgaW1wbGVtZW50aW5nIHNvbWUgd2F5IHRvDQo+IHNwZWVkIHVwIG1hcCB3YWxrcyBhcyB3
ZWxsLg0KPiANCj4gVGhlIGRpcmVjdGlvbiB3ZSB3ZXJlIGxvb2tpbmcgaW4sIGFmdGVyIHByZXZp
b3VzIGRpc2N1c3Npb25zIFsxXSwNCj4gaG93ZXZlciwgd2FzIHRvIHByb3ZpZGUgYSBCUEYgcHJv
Z3JhbSB3aGljaCBjYW4gcnVuIHRoZSBsb2dpYyBlbnRpcmVseQ0KPiB3aXRoaW4gdGhlIGtlcm5l
bC4NCj4gDQo+IFdlIGhhdmUgYSByb3VnaCBQb0Mgb24gdGhlIEZXIHNpZGUgKHdlIGNhbiBvZmZs
b2FkIHRoZSBwcm9ncmFtIHdoaWNoDQo+IHdhbGtzIHRoZSBtYXAsIHdoaWNoIGlzIHByZXR0eSBu
ZWF0KSwgYnV0IHRoZSBrZXJuZWwgdmVyaWZpZXIgc2lkZQ0KPiBoYXNuJ3QgcmVhbGx5IHByb2dy
ZXNzZWQuIEl0IHdpbGwgc29vbi4NCj4gDQo+IFRoZSByb3VnaCBpZGVhIGlzIHRoYXQgdGhlIHVz
ZXIgc3BhY2UgcHJvdmlkZXMgdHdvIHByb2dyYW1zLCAiZmlsdGVyIg0KPiBhbmQgImR1bXBlciI6
DQo+IA0KPiAJYnBmdG9vbCBtYXAgZXhlYyBpZCBYWVogZmlsdGVyIHBpbm5lZCAvc29tZS9wcm9n
IFwNCj4gCQkJCWR1bXBlciBwaW5uZWQgL3NvbWUvb3RoZXJfcHJvZw0KPiANCj4gQm90aCBwcm9n
cmFtcyBnZXQgdGhpcyBjb250ZXh0Og0KPiANCj4gc3RydWN0IG1hcF9vcF9jdHggew0KPiAJdTY0
IGtleTsNCj4gCXU2NCB2YWx1ZTsNCj4gfQ0KPiANCj4gV2UgbmVlZCBhIHBlci1tYXAgaW1wbGVt
ZW50YXRpb24gb2YgdGhlIGV4ZWMgc2lkZSwgYnV0IHJvdWdobHkgbWFwcw0KPiB3b3VsZCBkbzoN
Cj4gDQo+IAlMSVNUX0hFQUQoZGVsZXRlZCk7DQo+IA0KPiAJZm9yIGVudHJ5IGluIG1hcCB7DQo+
IAkJc3RydWN0IG1hcF9vcF9jdHggew0KPiAJCQkua2V5CT0gZW50cnktPmtleSwNCj4gCQkJLnZh
bHVlCT0gZW50cnktPnZhbHVlLA0KPiAJCX07DQo+IA0KPiAJCWFjdCA9IEJQRl9QUk9HX1JVTihm
aWx0ZXIsICZtYXBfb3BfY3R4KTsNCj4gCQlpZiAoYWN0ICYgfkFDVF9CSVRTKQ0KPiAJCQlyZXR1
cm4gLUVJTlZBTDsNCj4gDQo+IAkJaWYgKGFjdCAmIERFTEVURSkgew0KPiAJCQltYXBfdW5saW5r
KGVudHJ5KTsNCj4gCQkJbGlzdF9hZGQoZW50cnksICZkZWxldGVkKTsNCj4gCQl9DQo+IAkJaWYg
KGFjdCAmIFNUT1ApDQo+IAkJCWJyZWFrOw0KPiAJfQ0KPiANCj4gCXN5bmNocm9uaXplX3JjdSgp
Ow0KPiANCj4gCWZvciBlbnRyeSBpbiBkZWxldGVkIHsNCj4gCQlzdHJ1Y3QgbWFwX29wX2N0eCB7
DQo+IAkJCS5rZXkJPSBlbnRyeS0+a2V5LA0KPiAJCQkudmFsdWUJPSBlbnRyeS0+dmFsdWUsDQo+
IAkJfTsNCj4gCQkNCj4gCQlCUEZfUFJPR19SVU4oZHVtcGVyLCAmbWFwX29wX2N0eCk7DQo+IAkJ
bWFwX2ZyZWUoZW50cnkpOw0KPiAJfQ0KPiANCj4gVGhlIGZpbHRlciBwcm9ncmFtIGNhbid0IHBl
cmZvcm0gYW55IG1hcCBvcGVyYXRpb25zIG90aGVyIHRoYW4gbG9va3VwLA0KPiBvdGhlcndpc2Ug
d2Ugd29uJ3QgYmUgYWJsZSB0byBndWFyYW50ZWUgdGhhdCB3ZSdsbCB3YWxrIHRoZSBlbnRpcmUg
bWFwDQo+IChpZiB0aGUgZmlsdGVyIHByb2dyYW0gZGVsZXRlcyBzb21lIGVudHJpZXMgaW4gYSB1
bmZvcnR1bmF0ZSBvcmRlcikuDQoNCkxvb2tzIGxpa2UgeW91IHdpbGwgcHJvdmlkZSBhIG5ldyBw
cm9ncmFtIHR5cGUgYW5kIHBlci1tYXAgDQppbXBsZW1lbnRhdGlvbiBvZiBhYm92ZSBjb2RlLiBN
eSBwYXRjaCBzZXQgaW5kZWVkIGF2b2lkZWQgcGVyLW1hcCANCmltcGxlbWVudGF0aW9uIGZvciBh
bGwgb2YgbG9va3VwL2RlbGV0ZS9nZXQtbmV4dC1rZXkuLi4NCg0KPiANCj4gSWYgdXNlciBzcGFj
ZSBqdXN0IHdhbnRzIGEgcHVyZSBkdW1wIGl0IGNhbiBzaW1wbHkgbG9hZCBhIHByb2dyYW0gd2hp
Y2gNCj4gZHVtcHMgdGhlIGVudHJpZXMgaW50byBhIHBlcmYgcmluZy4NCg0KcGVyY3B1IHBlcmYg
cmluZyBpcyBub3QgcmVhbGx5IGlkZWFsIGZvciB1c2VyIHNwYWNlIHdoaWNoIHNpbXBseSBqdXN0
DQp3YW50IHRvIGdldCBzb21lIGtleS92YWx1ZSBwYWlycyBiYWNrLiBTb21lIGtpbmQgb2YgZ2Vu
ZXJhdGUgbm9uLXBlci1jcHUNCnJpbmcgYnVmZmVyIG1pZ2h0IGJlIGJldHRlciBmb3Igc3VjaCBj
YXNlcy4NCg0KPiANCj4gSSdtIGJyaW5naW5nIHRoaXMgdXAgYmVjYXVzZSB0aGF0IG1lY2hhbmlz
bSBzaG91bGQgY292ZXIgd2hhdCBpcw0KPiBhY2hpZXZlZCB3aXRoIHRoaXMgcGF0Y2ggc2V0IGFu
ZCBtdWNoIG1vcmUuDQoNClRoZSBvbmx5IGNhc2UgaXQgZGlkIG5vdCBjb3ZlciBpcyBiYXRjaGVk
IHVwZGF0ZS4gQnV0IHRoYXQgbWF5IG5vdA0KYmUgc3VwZXIgY3JpdGljYWwuDQoNCllvdXIgYXBw
cm9hY2ggZ2l2ZSBlYWNoIGVsZW1lbnQgYW4gYWN0aW9uIGNob2ljZSB0aHJvdWdoIGFub3RoZXIg
YnBmIA0KcHJvZ3JhbS4gVGhpcyBpbmRlZWQgcG93ZXJmdWwuIE15IHVzZSBjYXNlIGlzIHNpbXBs
ZXIgdGhhbiB5b3VyIHVzZSBjYXNlDQpiZWxvdywgaGVuY2UgdGhlIGltcGxlbWVudGF0aW9uLg0K
DQo+IA0KPiBJbiBwYXJ0aWN1bGFyIGZvciBuZXR3b3JraW5nIHdvcmtsb2FkcyB3aGVyZSBvbGQg
Zmxvd3MgaGF2ZSB0byBiZQ0KPiBwcnVuZWQgZnJvbSB0aGUgbWFwIHBlcmlvZGljYWxseSBpdCdz
IGZhciBtb3JlIGVmZmljaWVudCB0byBjb21tdW5pY2F0ZQ0KPiB0byB1c2VyIHNwYWNlIG9ubHkg
dGhlIGZsb3dzIHdoaWNoIHRpbWVkIG91dCAodGhlIGRlbGV0ZSBiYXRjaGluZyBmcm9tDQo+IHRo
aXMgc2V0IHdvbid0IGhlbHAgYXQgYWxsKS4NCg0KTWF5YmUgTFJVIG1hcCB3aWxsIGhlbHAgaW4g
dGhpcyBjYXNlPyBJdCBpcyBkZXNpZ25lZCBmb3Igc3VjaA0KdXNlIGNhc2VzLg0KDQo+IA0KPiBX
aXRoIGEgMk0gZW50cnkgbWFwIGFuZCB0aGlzIHBhdGNoIHNldCB3ZSBzdGlsbCB3b24ndCBiZSBh
YmxlIHRvIHBydW5lDQo+IG9uY2UgYSBzZWNvbmQgb24gb25lIGNvcmUuDQo+IA0KPiBbMV0NCj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMTkwODEzMTMwOTIxLjEwNzA0LTQtcXVl
bnRpbi5tb25uZXRAbmV0cm9ub21lLmNvbS8NCj4gDQo=
