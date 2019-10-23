Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048E1E1126
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 06:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfJWEm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 00:42:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731450AbfJWEm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 00:42:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9MLZ8PE004774;
        Tue, 22 Oct 2019 21:42:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iAa/wUCcVwLzrA6qOiHwYNZmCVS9gc9j1SmUujff5ZE=;
 b=pG/Iog/DXay/7CTe154sEJgVP0+ZdCwEgxxkwDlJptBg7iwAdwaua3hc/M37+3OVCJP/
 piEbf+NKprtfKGIiuauTjxx2zgDNS7VqjjKrs5CzEDML0c5po1azEkr0N/jicLI2EysS
 jUF+WQHgz/gkcHMd+Bk8fAsFLA8CpsloyUY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vt9tehfak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 21:42:43 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 22 Oct 2019 21:42:42 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 21:42:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUE6pMKTbqxIHLYaYX5cqptzHOjBY7UqCgnD7HbkXdP7t705G6jsKT96mJLN6f2Sz3dN6sZ7avmGQVzJqOWbXZJjYNOkIa8D/Qk0rh0vhKaMEQPLeoX5/c1zp61GzyfqbAw7HseL/qfXHPzIqXK3jWaVsaj31Z89h3JXuc1MJfGms8DpsqUk0ajmrkM9wQa2rcqcBQn1yYONN+APRPp4lnkrbX1NFP1R0/FWt0lJbPt0FI+pTUazO3HDGK1zdV1AIOzx/zRkY5GrBKFERhc6NQdtIBFr7XsUyhGVdu5mJ2GpynTKsNlj2CSfWRSm1JA8lfAQBI1FK5lYvbVGrssL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAa/wUCcVwLzrA6qOiHwYNZmCVS9gc9j1SmUujff5ZE=;
 b=KUf+6ANYIPsXLK6W83TIQFh78hTo/R928H17zyFdN4rv0aFtpSDgB37GbXwwQcZZUlCOO1DBlnVl+0mtBTLxy3NOCsOwgWDI5bBMkIAE+nonu3X5/88gFfrATd5PTFcEwful2OApT0MmAe8wUidZqopqLpqh+iSip/OczkC0qddDnTT/Qnhc6TM9tfkmS6ILwUFmt6IUcNJibZXLYxsLu+Hw+rFwbV8wlDyzgEhCrXKemtOtjPkh6FGAyL/YEkeM+yGCSB5UMFqHiM1/8s4dTC/G8poSvYM7bry3wdnWYuQt8KIcSRkUYUN2r1VC4aOJikHHAdm6SOYj7W4zbHAZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAa/wUCcVwLzrA6qOiHwYNZmCVS9gc9j1SmUujff5ZE=;
 b=GZxtRT/89f4aQb1tAE/kH22TWSQAGMz7VYe45HOynMRBc0PNVdelg1J5OeZt9tQwaSn0aT5TxJS8JgvBh/VwFRd8vwRHpeoWPuocyw4T8SYpoCZ6DraYXE5IAEa4aV2+Da1cfpL0zpe3se+hl5XYy3EnuDs9vJFKTjxxsxOVXDY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3494.namprd15.prod.outlook.com (20.179.59.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 04:42:41 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 04:42:41 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
Thread-Topic: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault
 with llc -march=bpf
Thread-Index: AQHViUIqi4sk0mO0YEWOHQh6nT3c5adngjuAgAAPcwCAABRhgA==
Date:   Wed, 23 Oct 2019 04:42:41 +0000
Message-ID: <c854894e-6c0a-6d49-4d7f-ae81a34b5711@fb.com>
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
 <6fddbb7c-50e4-2d1f-6f88-1d97107e816f@fb.com>
 <CAJ2QiJLONfJKdMVGu6J-BHnfNKA3R+ZZWfJV2RNrmUO90LPWPQ@mail.gmail.com>
In-Reply-To: <CAJ2QiJLONfJKdMVGu6J-BHnfNKA3R+ZZWfJV2RNrmUO90LPWPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:180::46) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9b83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8aaa5601-9345-46c3-c8e7-08d757737015
x-ms-traffictypediagnostic: BYAPR15MB3494:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <BYAPR15MB3494467900C9F082D53D49A1D36B0@BYAPR15MB3494.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(53754006)(2906002)(31696002)(19273905006)(8936002)(86362001)(6506007)(386003)(53546011)(6246003)(6116002)(186003)(4326008)(11346002)(36756003)(46003)(5660300002)(446003)(2616005)(476003)(486006)(256004)(81166006)(102836004)(66476007)(66556008)(64756008)(66446008)(66946007)(52116002)(81156014)(71190400001)(316002)(6436002)(54906003)(478600001)(71200400001)(99286004)(966005)(6306002)(6512007)(25786009)(229853002)(7736002)(305945005)(76176011)(8676002)(6916009)(14454004)(31686004)(6486002)(562404015)(563064011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3494;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9/jJBE1aE8nkx3IziffZRM96oFrGikAD/3KGdaRpTEyt9nr9kz1y0cqdkTlt3/EUd0bL3Vc+e8WXrJx6PvBNnOKiN+TZ6CXtYcKN2CC3z/pCPH1O3HiK8WtPDtqEU+7g/4WTGWfIV67sbianIOeccMd9Bo7FoGovbT4QGLycEaSRmv0CSqPL6WYZJn0BgA48ehIIKfPM4VbhLcHmS8aVnyn3KjslK2guYFQUlYAmqBot2y41F7OtLFKZZMUCCSJY1zIUp05BCIeODZ19m0YI1R1F5cocHq8MRsZ+JPO8o8mgQ41IWbs9G8ECMl6DFHiz4VDMznncOCpqG9SBa9xFPEsypWHQGe5ZEQSRTZvfcFHoB/ICdzvvVebU6vSFXfmuAUemFSwUgMszFZjLWDHHYCNUPtc9M+eeVgmzcSizy0QTPfYV7833A6HxPJsAkbduKub/zFwI3ZMrfhg4NMM4oKWzL2ObAvutwKNtSMdFZcY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <27E4AD0D0822EA4281D2B15BFF3B2ADD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aaa5601-9345-46c3-c8e7-08d757737015
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 04:42:41.2814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UD+N8NHZ0pewKvEmY+4d9mIzOzxclPN1FU7fHlAvEfMK4WEYnAJNiqiDVTmM8D9U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3494
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_06:2019-10-22,2019-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910220185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDg6MjkgUE0sIFByYWJoYWthciBLdXNod2FoYSB3cm90ZToNCj4gVGhh
bmtzIFlvbmdob25nIGZvciByZXBseWluZy4NCj4gDQo+IA0KPiANCj4gT24gV2VkLCBPY3QgMjMs
IDIwMTkgYXQgODowNCBBTSBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiB3cm90ZToNCj4+DQo+
Pg0KPj4NCj4+IE9uIDEwLzIyLzE5IDY6MzUgUE0sIFByYWJoYWthciBLdXNod2FoYSB3cm90ZToN
Cj4+Pg0KPj4+ICAgIEFkZGluZyBvdGhlciBtYWlsaW5nIGxpc3QsIGZvbGtzLi4uDQo+Pj4NCj4+
PiBIaSBBbGwsDQo+Pj4NCj4+PiBJIGFtIHRyeWluZyB0byBidWlsZCBrc2VsZnRlc3Qgb24gTGlu
dXgtNS40IG9uIHVidW50dSAxOC4wNC4gSSBpbnN0YWxsZWQNCj4+PiBMTFZNLTkuMC4wIGFuZCBD
bGFuZy05LjAuMCBmcm9tIGJlbG93IGxpbmtzIGFmdGVyIGZvbGxvd2luZyBzdGVwcyBmcm9tDQo+
Pj4gWzFdIGJlY2F1c2Ugb2YgZGlzY3Vzc2lvbiBbMl0NCj4+DQo+PiBDb3VsZCB5b3UgdHJ5IGxh
dGVzdCBsbHZtIHRydW5rIChwcmUtcmVsZWFzZSAxMC4wLjApPw0KPj4gTExWTSA5LjAuMCBoYXMg
c29tZSBjb2RlcyBmb3IgQ09SRSwgYnV0IGl0IGlzIG5vdCBmdWxseSBzdXBwb3J0ZWQgYW5kDQo+
PiBoYXMgc29tZSBidWdzIHdoaWNoIGFyZSBvbmx5IGZpeGVkIGluIExMVk0gMTAuMC4wLiBXZSBp
bnRlbmQgdG8gbWFrZQ0KPj4gbGx2bSAxMCBhcyB0aGUgb25lIHdlIGNsYWltIHdlIGhhdmUgc3Vw
cG9ydC4gSW5kZWVkIENPUkUgcmVsYXRlZA0KPj4gY2hhbmdlcyBhcmUgbW9zdGx5IGFkZGVkIGR1
cmluZyAxMC4wLjAgZGV2ZWxvcG1lbnQgcGVyaW9kLg0KPj4NCj4gDQo+IGNhbiB5b3UgcGxlYXNl
IGhlbHAgbWUgdGhlIGxpbmsgdG8gZG93bmxvYWQgYXMNCj4gImh0dHBzOi8vdXJsZGVmZW5zZS5w
cm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcHJlcmVsZWFzZXMubGx2bS5vcmdfJmQ9
RHdJQmFRJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPURBOGUxQjVyMDczdklxUnJGejdNUkEm
bT0tNmswZjdpS1pPNTRrSExLQmpZZFVfN3BEbENoNjFIZHR5V1EtZDQzendVJnM9N2Zib2JGaUM2
MTlfOVByNWIxRmJyS3ZvSGw2c2c3OU5aYzNyUWdOV2ExUSZlPSAiIGRvZXMgbm90IGhhdmUgTExW
TS0xMC4wLjAgcGFja2FnZXMuDQoNCmxsdm0gMTAgaGFzIG5vdCBiZWVuIHJlbGVhc2VkLg0KQ291
bGQgeW91IGZvbGxvdyBMTFZNIHNvdXJjZSBidWlsZCBpbnNuIGF0IA0KaHR0cHM6Ly9naXRodWIu
Y29tL2lvdmlzb3IvYmNjL2Jsb2IvbWFzdGVyL0lOU1RBTEwubWQ/DQoNClNwZWNpZmljYWxseToN
CmdpdCBjbG9uZSBodHRwOi8vbGx2bS5vcmcvZ2l0L2xsdm0uZ2l0DQpjZCBsbHZtL3Rvb2xzOyBn
aXQgY2xvbmUgaHR0cDovL2xsdm0ub3JnL2dpdC9jbGFuZy5naXQNCmNkIC4uOyBta2RpciAtcCBi
dWlsZC9pbnN0YWxsOyBjZCBidWlsZA0KY21ha2UgLUcgIlVuaXggTWFrZWZpbGVzIiAtRExMVk1f
VEFSR0VUU19UT19CVUlMRD0iQlBGO1g4NiIgXA0KICAgLURDTUFLRV9CVUlMRF9UWVBFPVJlbGVh
c2UgLURDTUFLRV9JTlNUQUxMX1BSRUZJWD0kUFdEL2luc3RhbGwgLi4NCm1ha2UNCm1ha2UgaW5z
dGFsbA0KZXhwb3J0IFBBVEg9JFBXRC9pbnN0YWxsL2JpbjokUEFUSA0KDQo+IA0KPiAtLXBrDQo+
IA0K
