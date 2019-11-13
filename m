Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39A0FA685
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfKMCfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:35:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727113AbfKMCfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:35:03 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAD2XX3c026199;
        Tue, 12 Nov 2019 18:34:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XQ9CsvG/foLywG+a7CbPVdVKH/XTRfLAzeyLP4i0v74=;
 b=caewdhJHnTgAmKECWVvgqp3sIaqtNUCliESXUGVMpBaUc90sAEqA9StSd1jCRWZhJhp0
 3HrhBRioCRrlgmk3NB39wIRzn9cV5OnGBjl/yIdpWvBJRHtE36y8P6pvTvg9NDApxaFB
 oqCKFx6gy3klPUdiI5ghlrC/EMjpRnt3DD0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w7pqywq05-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Nov 2019 18:34:42 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 18:34:37 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 18:34:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4v8uqAHU9Dt0+5BnBx3+EzHXtia3ESCiQ/UUZaaoD+Obe11UzwrxsrK+PkbQWJpSchugU7InlYm+qSqzg4ubDVTqqqbNef7wy9iz7ZXswER1EgUDNDF52P9T9ym8SFKDnAVI5mhKiNOVxBvm0JFXxdC0n7pB4zc9X9rmevcdUPVsVNjOQQ0TY00m9kKKq2xdTCsEOCxC6fotWHh2DfcNU+TAS0na9tEQ2WFf0AOI6lVq9Cj6LI9g4KDej05FmgF2TuU4AwSUM/fLxmMzpmh4SQthiGsoq5mH791GYlkQUuc6Yo/0vzlmrt/hSx/Xk8FNClrY/2rLjcxxZVJWCeCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ9CsvG/foLywG+a7CbPVdVKH/XTRfLAzeyLP4i0v74=;
 b=kCccCzVSvjNhx6L2Jut9FjEx01qfBZsaNMZf/b9/xuZ+VofPbMbn+AwqFrNUJP3pFqOHaEyytNqRJskmbFnFmD+Z4ta/f1pPoC3vCmqEo1pXzRoRGC1c2eFJcZf2W9ILFuRRkuwOdxXxXy/ikBfljJJR7pgata3NSyOCVgFo7WbNOGcyOTbEYzmVTdHH4HtxwGUIoQkoGiwAcr0x9Fvrlo7VuC+7Tu2oTBl5+ouTrUnpwh2q7pXLjZ/N14L80UNdAXZbBQ9wWbt1eaPT1RBdfw9/P/HF3Fh0iz2s01ewR1b1htoX0j2OErjlOIvWAKaKdDOqhXFn4Kh9T35xgWbWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ9CsvG/foLywG+a7CbPVdVKH/XTRfLAzeyLP4i0v74=;
 b=HS1HZuqRj/f3RuxM3FNAuCu39ABzmLfsuynP7mi6j22czNI6j18YsJxll6m2jCGKpBvJkYX3Tmfn+EYI9bPACaSdX36dR0pWc9aaog6uBR5GeUGldxFYg00KsN3h3W57tFhrkC6VW0B6tOMzZC0tZvlMSh8iyGu8iNnbeFV95Fs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3366.namprd15.prod.outlook.com (20.179.58.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 02:34:36 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 02:34:36 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Petar Penkov" <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC bpf-next 0/3] bpf: adding map batch processing support
Thread-Topic: [RFC bpf-next 0/3] bpf: adding map batch processing support
Thread-Index: AQHVlbFC7S2RDjT11Um4peJ3xLWVf6eIamAA
Date:   Wed, 13 Nov 2019 02:34:36 +0000
Message-ID: <61f1e2f3-e0d5-cf2e-c16e-807b09bb84e7@fb.com>
References: <20191107212023.171208-1-brianvv@google.com>
In-Reply-To: <20191107212023.171208-1-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:300:13d::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a2b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 178f486c-6736-4674-000e-08d767e20640
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR15MB336690FE952413B2C3C7C8D0D3760@BYAPR15MB3366.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39860400002)(396003)(189003)(199004)(2616005)(486006)(386003)(71190400001)(76176011)(53546011)(99286004)(446003)(7736002)(31696002)(31686004)(6506007)(476003)(102836004)(25786009)(36756003)(2906002)(305945005)(46003)(4326008)(86362001)(6436002)(6116002)(71200400001)(11346002)(66476007)(66556008)(64756008)(7416002)(229853002)(316002)(14454004)(66446008)(186003)(478600001)(8936002)(8676002)(966005)(81156014)(81166006)(6246003)(6306002)(14444005)(256004)(5660300002)(66946007)(6512007)(6486002)(110136005)(52116002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3366;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBnHBa8llCs+s/gzPpwnKr4+TK/pbbpsIJaIxStN6nTRLlPzqGV5CYTjdeGNx4i/pOhs8Rz3cZiRpTJj5Fr2C+/KPoh5zE5xTxZ0HXFWYw3x4QwPN0499n7KBYmBr9XGPmCA0zuxQ1ewhn+rz2CNqKfSmgw4pvqRzkxc/+azAMmAk2/QFk6mQSWcUq3wGlYVtm/wD9O3l1BMLhaopRP5Kja1gXHq83J7peCrGzRCbc3ZZWaW0lXNCnp6+RTwfBXVI7/G6qXgpfc27Npl3Uc3P21NFhg3YU8p9N7H1SwK3ti6OR2XAw/U2SawGzEpVDSZT5fPDeNhnIOEE6hjOi5NBpdmkt989lDPUwY0au0wL979Czgiyheotjpkyr3ZB01dmy30kKrGrpVUr8w6YTf5duAMp48430iJO1bPoODpx2e5Gf8bAY4NoX26zTN0Fxie9Q3IkJuJ0qRKSWwXukz3cWZrqjjj8ovtbKjCaC0Hcao=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7A77EBD04B9AE4F8DB5E4E73E972278@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 178f486c-6736-4674-000e-08d767e20640
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 02:34:36.4749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Yr0IO0U7Z6Y/bGaSpFvlOFi5CpVlgpqjtYnBZYLdjjoXm3/E/ImUiHLR0HRpC2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_10:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 clxscore=1011 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzcvMTkgMToyMCBQTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gVGhpcyBpcyBh
IGZvbGxvdyB1cCBpbiB0aGUgZWZmb3J0IHRvIGJhdGNoIGJwZiBtYXAgb3BlcmF0aW9ucyB0byBy
ZWR1Y2UNCj4gdGhlIHN5c2NhbGwgb3ZlcmhlYWQgd2l0aCB0aGUgbWFwX29wcy4gSSBpbml0aWFs
bHkgcHJvcG9zZWQgdGhlIGlkZWEgYW5kDQo+IHRoZSBkaXNjdXNzaW9uIGlzIGhlcmU6DQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDE5MDcyNDE2NTgwMy44NzQ3MC0xLWJyaWFudnZA
Z29vZ2xlLmNvbS8NCj4gDQo+IFlvbmdob25nIHRhbGtlZCBhdCB0aGUgTFBDIGFib3V0IHRoaXMg
YW5kIGFsc28gcHJvcG9zZWQgYW5kIGlkZWEgdGhhdA0KPiBoYW5kbGVzIHRoZSBzcGVjaWFsIHdl
aXJkIGNhc2Ugb2YgaGFzaHRhYmxlcyBieSBkb2luZyB0cmF2ZXJzaW5nIHVzaW5nDQo+IHRoZSBi
dWNrZXRzIGFzIGEgcmVmZXJlbmNlIGluc3RlYWQgb2YgYSBrZXkuIERpc2N1c3Npb24gaXMgaGVy
ZToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMTkwOTA2MjI1NDM0LjM2MzU0MjEt
MS15aHNAZmIuY29tLw0KPiANCj4gVGhpcyBSRkMgcHJvcG9zZXMgYSB3YXkgdG8gZXh0ZW5kIGJh
dGNoIG9wZXJhdGlvbnMgZm9yIG1vcmUgZGF0YQ0KPiBzdHJ1Y3R1cmVzIGJ5IGNyZWF0aW5nIGdl
bmVyaWMgYmF0Y2ggZnVuY3Rpb25zIHRoYXQgY2FuIGJlIHVzZWQgaW5zdGVhZA0KPiBvZiBpbXBs
ZW1lbnRpbmcgdGhlIG9wZXJhdGlvbnMgZm9yIGVhY2ggaW5kaXZpZHVhbCBkYXRhIHN0cnVjdHVy
ZSwNCj4gcmVkdWNpbmcgdGhlIGNvZGUgdGhhdCBuZWVkcyB0byBiZSBtYWludGFpbmVkLiBUaGUg
c2VyaWVzIGNvbnRhaW5zIHRoZQ0KPiBwYXRjaGVzIHVzZWQgaW4gWW9uZ2hvbmcncyBSRkMgYW5k
IHRoZSBwYXRjaCB0aGF0IGFkZHMgdGhlIGdlbmVyaWMNCj4gaW1wbGVtZW50YXRpb24gb2YgdGhl
IG9wZXJhdGlvbnMgcGx1cyBzb21lIHRlc3Rpbmcgd2l0aCBwY3B1IGhhc2htYXBzDQo+IGFuZCBh
cnJheXMuIE5vdGUgdGhhdCBwY3B1IGhhc2htYXAgc2hvdWxkbid0IHVzZSB0aGUgZ2VuZXJpYw0K
PiBpbXBsZW1lbnRhdGlvbiBhbmQgaXQgZWl0aGVyIHNob3VsZCBoYXZlIGl0cyBvd24gaW1wbGVt
ZW50YXRpb24gb3Igc2hhcmUNCj4gdGhlIG9uZSBpbnRyb2R1Y2VkIGJ5IFlvbmdob25nLCBJIGFk
ZGVkIHRoYXQganVzdCBhcyBhbiBleGFtcGxlIHRvIHNob3cNCj4gdGhhdCB0aGUgZ2VuZXJpYyBp
bXBsZW1lbnRhdGlvbiBjYW4gYmUgZWFzaWx5IGFkZGVkIHRvIGEgZGF0YSBzdHJ1Y3R1cmUuDQo+
IA0KPiBXaGF0IEkgd2FudCB0byBhY2hpZXZlIHdpdGggdGhpcyBSRkMgaXMgdG8gY29sbGVjdCBl
YXJseSBmZWVkYmFjayBhbmQgc2VlIGlmDQo+IHRoZXJlJ3MgYW55IG1ham9yIGNvbmNlcm4gYWJv
dXQgdGhpcyBiZWZvcmUgSSBtb3ZlIGZvcndhcmQuIEkgZG8gcGxhbg0KPiB0byBiZXR0ZXIgc2Vw
YXJhdGUgdGhpcyBpbnRvIGRpZmZlcmVudCBwYXRjaGVzIGFuZCBleHBsYWluIHRoZW0gcHJvcGVy
bHkNCj4gaW4gdGhlIGNvbW1pdCBtZXNzYWdlcy4NCg0KVGhhbmtzIEJyaWFuIGZvciB3b3JraW5n
IG9uIHRoaXMuIFRoZSBnZW5lcmFsIGFwcHJvYWNoIGRlc2NyaWJlZCBoZXJlDQppcyBnb29kIHRv
IG1lLiBIYXZpbmcgYSBnZW5lcmljIGltcGxlbWVudGF0aW9uIGZvciBiYXRjaCBvcGVyYXRpb25z
DQpsb29rcyBnb29kIGZvciBtYXBzIChub3QgaGFzaCB0YWJsZSwgcXVldWUvc3RhY2ssIGV0Yy4p
DQoNCj4gDQo+IEN1cnJlbnQga25vd24gaXNzdWVzIHdoZXJlIEkgd291bGQgbGlrZSB0byBkaXNj
dXNzIGFyZSB0aGUgZm9sbG93aW5nczoNCj4gDQo+IC0gQmVjYXVzZSBZb25naG9uZydzIFVBUEkg
ZGVmaW5pdGlvbiB3YXMgZG9uZSBzcGVjaWZpY2FsbHkgZm9yDQo+ICAgIGl0ZXJhdGluZyBidWNr
ZXRzLCB0aGUgYmF0Y2ggZmllbGQgaXMgdTY0IGFuZCBpcyB0cmVhdGVkIGFzIGFuIHU2NA0KPiAg
ICBpbnN0ZWFkIG9mIGFuIG9wYXF1ZSBwb2ludGVyLCB0aGlzIHdvbid0IHdvcmsgZm9yIG90aGVy
IGRhdGEgc3RydWN0dXJlcw0KPiAgICB0aGF0IGFyZSBnb2luZyB0byB1c2UgYSBrZXkgYXMgYSBi
YXRjaCB0b2tlbiB3aXRoIGEgc2l6ZSBncmVhdGVyIHRoYW4NCj4gICAgNjQuIEFsdGhvdWdoIEkg
dGhpbmsgYXQgdGhpcyBwb2ludCB0aGUgb25seSBrZXkgdGhhdCBjb3VsZG4ndCBiZQ0KPiAgICB0
cmVhdGVkIGFzIGEgdTY0IGlzIHRoZSBrZXkgb2YgYSBoYXNobWFwLCBhbmQgdGhlIGhhc2htYXAg
d29uJ3QgdXNlDQo+ICAgIHRoZSBnZW5lcmljIGludGVyZmFjZS4NCg0KVGhlIHU2NCBjYW4gYmUg
Y2hhbmdlZCB3aXRoIGEgX19hbGlnbmVkX3U2NCBvcGFxdWUgdmFsdWUuIFRoaXMgd2F5LA0KaXQg
Y2FuIHJlcHJlc2VudCBhIHBvaW50ZXIgb3IgYSA2NGJpdCB2YWx1ZS4NCg0KPiAtIE5vdCBhbGwg
dGhlIGRhdGEgc3RydWN0dXJlcyB1c2UgZGVsZXRlIChiZWNhdXNlIGl0J3Mgbm90IGEgdmFsaWQN
Cj4gICAgb3BlcmF0aW9uKSBpLmUuIGFycmF5cy4gU28gbWF5YmUgbG9va3VwX2FuZF9kZWxldGVf
YmF0Y2ggY29tbWFuZCBpcw0KPiAgICBub3QgbmVlZGVkIGFuZCB3ZSBjYW4gaGFuZGxlIHRoYXQg
b3BlcmF0aW9uIHdpdGggYSBsb29rdXBfYmF0Y2ggYW5kIGENCj4gICAgZmxhZy4NCg0KVGhpcyBt
YWtlIHNlbnNlLg0KDQo+IC0gRm9yIGRlbGV0ZV9iYXRjaCAobm90IGp1c3QgdGhlIGxvb2t1cF9h
bmRfZGVsZXRlX2JhdGNoKS4gSXMgdGhpcw0KPiAgICBvcGVyYXRpb24gcmVhbGx5IG5lZWRlZD8g
SWYgc28sIHNob3VsZG4ndCBpdCBiZSBiZXR0ZXIgaWYgdGhlDQo+ICAgIGJlaGF2aW91ciBpcyBk
ZWxldGUgdGhlIGtleXMgcHJvdmlkZWQ/IEkgZGlkIHRoYXQgd2l0aCBteSBnZW5lcmljDQo+ICAg
IGltcGxlbWVudGF0aW9uIGJ1dCBZb25naG9uZydzIGRlbGV0ZV9iYXRjaCBmb3IgYSBoYXNobWFw
IGRlbGV0ZXMNCj4gICAgYnVja2V0cy4NCg0KV2UgbmVlZCBiYXRjaGVkIGRlbGV0ZSBpbiBiY2Mu
IGxvb2t1cF9hbmRfZGVsZXRlX2JhdGNoIGlzIGJldHRlciBhcw0KaXQgY2FuIHByZXNlcnZlcyBt
b3JlIG5ldyBtYXAgZW50cmllcy4gQWx0ZXJuYXRpdmVseSwgZGVsZXRpbmcNCmFsbCBlbnRyaWVz
IGFmdGVyIGxvb2t1cCBpcyBhbm90aGVyIG9wdGlvbi4gQnV0IHRoaXMgbWF5IHJlbW92ZQ0KbW9y
ZSBuZXcgbWFwIGVudHJpZXMuIFN0YXRpc3RpY2FsbHkgdGhpcyBtYXkgb3IgbWF5IG5vdCBtYXR0
ZXIgdGhvdWdoLg0KDQpiY2MgZG9lcyBoYXZlIGEgY2xlYXJfdGFibGUgKGNsZWFyX21hcCkgQVBJ
LCBidXQgbm90IGNsZWFyIHdobyBpcyB1c2luZyBpdC4NCg0KU28sIEkgZGlkIG5vdCBoYXZlIGEg
Y29uY3JldGUgdXNlIGNhc2UgZm9yIGRlbGV0ZV9iYXRjaCB5ZXQuDQpJIHRlbmQgdG8gdGhpbmsg
d2Ugc2hvdWxkIGhhdmUgZGVsZXRlX2JhdGNoIGZvciBBUEkgY29tcGxldGVuZXNzLA0KYnV0IG1h
eWJlIG90aGVyIHBlb3BsZSBjYW4gY29tbWVudCBvbiB0aGlzIGFzIHdlbGwuDQoNCk1heWJlIGlu
aXRpYWwgcGF0Y2gsIHdlIGNhbiBza2lwIGl0LiBCdXQgd2Ugc2hvdWxkIHN0aWxsIGVuc3VyZQ0K
dXNlciBpbnRlcmZhY2UgZGF0YSBzdHJ1Y3R1cmUgY2FuIGhhbmRsZSBiYXRjaCBkZWxldGUgaWYg
aXQgaXMNCm5lZWRlZCBsYXRlci4gVGhlIGN1cnJlbnQgZGF0YSBzdHJ1Y3R1cmUgc2hvdWxkIGhh
bmRsZSB0aGlzDQphcyBmYXIgYXMgSSBrbm93Lg0KDQo+IA0KPiBCcmlhbiBWYXpxdWV6ICgxKToN
Cj4gICAgYnBmOiBhZGQgZ2VuZXJpYyBiYXRjaCBzdXBwb3J0DQo+IA0KPiBZb25naG9uZyBTb25n
ICgyKToNCj4gICAgYnBmOiBhZGRpbmcgbWFwIGJhdGNoIHByb2Nlc3Npbmcgc3VwcG9ydA0KPiAg
ICB0b29scy9icGY6IHRlc3QgYnBmX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaCgpDQo+IA0K
PiAgIGluY2x1ZGUvbGludXgvYnBmLmggICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyMSAr
DQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgICAgICAgICAgICAgICAgIHwgIDIy
ICsNCj4gICBrZXJuZWwvYnBmL2FycmF5bWFwLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
IDQgKw0KPiAgIGtlcm5lbC9icGYvaGFzaHRhYi5jICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDMzMSArKysrKysrKysrDQo+ICAga2VybmVsL2JwZi9zeXNjYWxsLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgNTczICsrKysrKysrKysrKysrLS0tLQ0KPiAgIHRvb2xzL2luY2x1ZGUvdWFw
aS9saW51eC9icGYuaCAgICAgICAgICAgICAgICB8ICAyMiArDQo+ICAgdG9vbHMvbGliL2JwZi9i
cGYuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDU5ICsrDQo+ICAgdG9vbHMvbGliL2Jw
Zi9icGYuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEzICsNCj4gICB0b29scy9saWIv
YnBmL2xpYmJwZi5tYXAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKw0KPiAgIC4uLi9tYXBf
dGVzdHMvbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoLmMgICB8IDI0NSArKysrKysrKw0KPiAg
IC4uLi9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2hfYXJyYXkuYyAgICAgICB8IDExOCArKysr
DQo+ICAgMTEgZmlsZXMgY2hhbmdlZCwgMTI5MiBpbnNlcnRpb25zKCspLCAxMjAgZGVsZXRpb25z
KC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9t
YXBfdGVzdHMvbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoLmMNCj4gICBjcmVhdGUgbW9kZSAx
MDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL21hcF90ZXN0cy9tYXBfbG9va3VwX2Fu
ZF9kZWxldGVfYmF0Y2hfYXJyYXkuYw0KPiANCg==
