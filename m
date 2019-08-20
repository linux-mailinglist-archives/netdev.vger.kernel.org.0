Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F363096C30
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfHTW1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:27:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbfHTW1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:27:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7KMMe41014214;
        Tue, 20 Aug 2019 15:27:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dNtvJsoonkPXQxDIGzwnTUDSIAOj83fABO4FY2cD2CM=;
 b=XmQCkUIB+yzSIJ1V6fIU08PbInMxkvyo2EHTYsIvjQWOs+PiWisLT8jzsigolsVg7+GA
 dfQ/OUjlGt3syerWXFridsHDIyrkxW6YPM0p19YiTnRtbv1aReVkdgjWDANXd9gpppFf
 9yUKpChzj+2cIE5yosn1DmOuXw+TiMOsQmw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ugn13hbbu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 15:27:27 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 15:27:25 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 15:27:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIN0+xoVZWAPkTOzNqZaixb17c2M2MrdHPIYzbXpAO6t+U20f4sJQT84TyEcNj6IFrBpO0bCTRaDxsXF1Tcq+q8QZdPG+TtxQAOR9cF33RUY9pCYDDa7/hYO158kqAg1hISA54l+AnaLa2vsdgpWeksLVDoAgflA4Zyt6NiGbPXFhKGLQN10py4k2cQLDQFxZTnsfOWUzC0ef5jDEJu+Cd1c0mC8Xu5golhjrOe4SVFpnAXYO0GyzJyo8w5FtUoENMBgGFmtd1cs0ZlUF+ajQJMHBxnlnD+lX33CV4ZFT/vGF9lSoa5/xY6hiV/mCV9cE+GtEqQ5DOnbYXk94vxvxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNtvJsoonkPXQxDIGzwnTUDSIAOj83fABO4FY2cD2CM=;
 b=V9E9qf33bznOlIumC9gGfZjxYOitU+NahjEj4efV/6foRKAKHoEbMGmkPeiJ87wPFks16ZRYpbvm+mU3nNS9rMXhuHUyZ2SJnEwASyIA9FrXyVIkC425TVaWvIioZM3aZdkhAhr69QIp4sGtkLBOAe0hxK36zLpk6CCN6GT30R1RO7MajrU7DASxcUmgaNiuvnyVZi9W5b7+PzoXvd3j4DbKlIEaFsOiU6c6PLWu7N6d4eEG3xwudRhLY4uX6L9YFFtF+oiWZP1j1chzjBDSzFoCQx44dPtWw7XM4/CnknnftrHKiTiQi1GN+5v+3wcXMmseB8HhS9hZoZAfulnxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNtvJsoonkPXQxDIGzwnTUDSIAOj83fABO4FY2cD2CM=;
 b=WlmDNHj/TCChDVZKY2mXlgsYschpjQeswTSgFPzULVwDsFXZwPMQzmq5XqZqlLQK7PqLoM7ILHLlGpIfGBZvAgxu4k8kYaEbIaKnkqly2OR7eiJ6DHF21GonPw7GcLHpb6b10JZ5RG9ZR8c5xwYd2lb28K56jOAAVePbrI4vNSw=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) by
 MW2PR1501MB2154.namprd15.prod.outlook.com (52.132.150.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 22:27:24 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::a1a5:e638:47cb:2e96]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::a1a5:e638:47cb:2e96%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 22:27:24 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
CC:     "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAA==
Date:   Tue, 20 Aug 2019 22:27:23 +0000
Message-ID: <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
In-Reply-To: <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:65ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88369bf2-8bb1-49d4-1a77-08d725bd9304
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MW2PR1501MB2154;
x-ms-traffictypediagnostic: MW2PR1501MB2154:
x-ms-exchange-purlcount: 5
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2154ECDF36183BCDB780981FC4AB0@MW2PR1501MB2154.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(346002)(376002)(136003)(199004)(189003)(36756003)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(305945005)(2906002)(14454004)(7736002)(11346002)(2616005)(476003)(486006)(33656002)(6116002)(4326008)(53936002)(86362001)(478600001)(6246003)(25786009)(966005)(81166006)(81156014)(8676002)(8936002)(446003)(316002)(6506007)(102836004)(7116003)(46003)(229853002)(186003)(6436002)(6486002)(256004)(5660300002)(71190400001)(71200400001)(6306002)(6512007)(76176011)(110136005)(99286004)(53546011)(3480700005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2154;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CYnw1481N7dBJ/By7NM+sGDAtUiLBBfoqUJ3MPLIjt69GX+S92Q+JnG+c89JaNnP7v9/+jv00KX+HjHYkQvxmA6nkZVHtQ8UcJh7Pvk5AbxRxH2ZDiSB0qhy8ZscsVu8efvl4E6HTApgsZpNwHrZoq8aIM5HQuNSKnNm/gAoF/m7Nak+Wyef/6y3SKii/ksJ+SrTYq1Q4XpeOQXvMDSnGBvoQilVxPD9s1tIL9D6mnn+ViZSUWnIhbt/Y+bYmoCsB9zs+pTB6qecOlMahLhWGb08o7MTIFCKSX1+hrsZpugCT5njdV/doHm7xns8eNjkbxrPgk97L157/BrvSFfo+BLlGIQF8H/Dp38pNlGv2L998zlE/wRlcGOHZQDTl1S9kkqTnV+jDVEyxBAdl6GpVEyNsy5CwhjjZhOLpl+fzVk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A73FC9F2E5DB44F934ADB9485F6BD27@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 88369bf2-8bb1-49d4-1a77-08d725bd9304
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 22:27:23.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwHV/1mqV/FY1laxXnGEYGIrQcS4c84Jx3zAcLwuXQ/iU0W9b/lcyl+Ep6VnCgPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2154
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDgvMTkvMTksIDExOjA4IEFNLCAiSnVsaWEgS2FydHNldmEiIDxoZXhAZmIuY29t
PiB3cm90ZToNCg0KICAgIE9uIDgvMTMvMTksIDExOjI0IEFNLCAiQW5kcmlpIE5ha3J5aWtvIiA8
YW5kcmlpLm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQogICAgDQogICAgICAgIE9uIFR1ZSwg
QXVnIDEzLCAyMDE5IGF0IDU6MjYgQU0gSmlyaSBPbHNhIDxqb2xzYUByZWRoYXQuY29tPiB3cm90
ZToNCiAgICAgICAgPg0KICAgICAgICA+IE9uIE1vbiwgQXVnIDEyLCAyMDE5IGF0IDA3OjA0OjEy
UE0gKzAwMDAsIEp1bGlhIEthcnRzZXZhIHdyb3RlOg0KICAgICAgICA+ID4gSSB3b3VsZCBsaWtl
IHRvIGJyaW5nIHVwIGxpYmJwZiBwdWJsaXNoaW5nIGRpc2N1c3Npb24gc3RhcnRlZCBhdCBbMV0u
DQogICAgICAgID4gPiBUaGUgcHJlc2VudCBzdGF0ZSBvZiB0aGluZ3MgaXMgdGhhdCBsaWJicGYg
aXMgYnVpbHQgZnJvbSBrZXJuZWwgdHJlZSwgZS5nLiBbMl0NCiAgICAgICAgPiA+IEZvciBEZWJp
YW4gYW5kIFszXSBmb3IgRmVkb3JhIHdoZXJlYXMgdGhlIGJldHRlciB3YXkgd291bGQgYmUgaGF2
aW5nIGENCiAgICAgICAgPiA+IHBhY2thZ2UgYnVpbHQgZnJvbSBnaXRodWIgbWlycm9yLiBUaGUg
YWR2YW50YWdlcyBvZiB0aGUgbGF0dGVyOg0KICAgICAgICA+ID4gLSBDb25zaXN0ZW50LCBBQkkg
bWF0Y2hpbmcgdmVyc2lvbmluZyBhY3Jvc3MgZGlzdHJvcw0KICAgICAgICA+ID4gLSBUaGUgbWly
cm9yIGhhcyBpbnRlZ3JhdGlvbiB0ZXN0cw0KICAgICAgICA+ID4gLSBObyBuZWVkIGluIGtlcm5l
bCB0cmVlIHRvIGJ1aWxkIGEgcGFja2FnZQ0KICAgICAgICA+ID4gLSBDaGFuZ2VzIGNhbiBiZSBt
ZXJnZWQgZGlyZWN0bHkgdG8gZ2l0aHViIHcvbyB3YWl0aW5nIHRoZW0gdG8gYmUgbWVyZ2VkDQog
ICAgICAgID4gPiB0aHJvdWdoIGJwZi1uZXh0IC0+IG5ldC1uZXh0IC0+IG1haW4NCiAgICAgICAg
PiA+IFRoZXJlIGlzIGEgUFIgaW50cm9kdWNpbmcgYSBsaWJicGYuc3BlYyB3aGljaCBjYW4gYmUg
dXNlZCBhcyBhIHN0YXJ0aW5nIHBvaW50OiBbNF0NCiAgICAgICAgPiA+IEFueSBjb21tZW50cyBy
ZWdhcmRpbmcgdGhlIHNwZWMgaXRzZWxmIGNhbiBiZSBwb3N0ZWQgdGhlcmUuDQogICAgICAgID4g
PiBJbiB0aGUgZnV0dXJlIGl0IG1heSBiZSB1c2VkIGFzIGEgc291cmNlIG9mIHRydXRoLg0KICAg
ICAgICA+ID4gUGxlYXNlIGNvbnNpZGVyIHN3aXRjaGluZyBsaWJicGYgcGFja2FnaW5nIHRvIHRo
ZSBnaXRodWIgbWlycm9yIGluc3RlYWQNCiAgICAgICAgPiA+IG9mIHRoZSBrZXJuZWwgdHJlZS4N
CiAgICAgICAgPiA+IFRoYW5rcw0KICAgICAgICA+ID4NCiAgICAgICAgPiA+IFsxXSBodHRwczov
L3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xpc3RzLmlvdmlz
b3Iub3JnX2dfaW92aXNvci0yRGRldl9tZXNzYWdlXzE1MjEmZD1Ed0lCYVEmYz01VkQwUlR0TmxU
aDN5Y2Q0MWIzTVV3JnI9elVyRFlfU3BfNVBxY0d0UlFQTmVEQSZtPXByWVZEaXUzLWFIMW8yUFdI
NFpjUDdsRVFSQ1FBY1R3Y1dQckpydGFyb1Emcz1kWUFjMmpMaEZnMHd0Q1pfbXMySEY1YldBTm9I
ekEzVU11ZzVUTkNlQnRFJmU9IA0KICAgICAgICA+ID4gWzJdIGh0dHBzOi8vdXJsZGVmZW5zZS5w
cm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGFja2FnZXMuZGViaWFuLm9yZ19zaWRf
bGliYnBmNC4xOSZkPUR3SUJhUSZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj16VXJEWV9TcF81
UHFjR3RSUVBOZURBJm09cHJZVkRpdTMtYUgxbzJQV0g0WmNQN2xFUVJDUUFjVHdjV1BySnJ0YXJv
USZzPWxxMU1wRi1idDZ5NlpFdEZjNTdlVC1CT193TUJ4OHVVQkFDSm9vV2JVWWsmZT0gDQogICAg
ICAgID4gPiBbM10gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0
dHAtM0FfX3JwbWZpbmQubmV0X2xpbnV4X1JQTV9mZWRvcmFfZGV2ZWxfcmF3aGlkZV94ODYtNUY2
NF9sX2xpYmJwZi0yRDUuMy4wLTJEMC5yYzIuZ2l0MC4xLmZjMzEueDg2LTVGNjQuaHRtbCZkPUR3
SUJhUSZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj16VXJEWV9TcF81UHFjR3RSUVBOZURBJm09
cHJZVkRpdTMtYUgxbzJQV0g0WmNQN2xFUVJDUUFjVHdjV1BySnJ0YXJvUSZzPU5vb2xZSEw1N0cy
S2h6RTc2OGlXZHk2djVMRDJHZkpReXFQbXRqeTE5NkUmZT0gDQogICAgICAgID4gPiBbNF0gaHR0
cHM6Ly9naXRodWIuY29tL2xpYmJwZi9saWJicGYvcHVsbC82NA0KICAgICAgICA+DQogICAgICAg
ID4gaGksDQogICAgICAgID4gRmVkb3JhIGhhcyBsaWJicGYgYXMga2VybmVsLXRvb2xzIHN1YnBh
Y2thZ2UsIHNvIEkgdGhpbmsNCiAgICAgICAgPiB3ZSdkIG5lZWQgdG8gY3JlYXRlIG5ldyBwYWNr
YWdlIGFuZCBkZXByZWNhdGUgdGhlIGN1cnJlbnQNCiAgICAgICAgPg0KICAgICAgICA+IGJ1dCBJ
IGxpa2UgdGhlIEFCSSBzdGFiaWxpdHkgYnkgdXNpbmcgZ2l0aHViIC4uIGhvdydzIGFjdHVhbGx5
DQogICAgICAgID4gdGhlIHN5bmMgKGluIGJvdGggZGlyZWN0aW9ucykgd2l0aCBrZXJuZWwgc291
cmNlcyBnb2luZyBvbj8NCiAgICAgICAgDQogICAgICAgIFN5bmMgaXMgYWx3YXlzIGluIG9uZSBk
aXJlY3Rpb24sIGZyb20ga2VybmVsIHNvdXJjZXMgaW50byBHaXRodWIgcmVwby4NCiAgICAgICAg
UmlnaHQgbm93IGl0J3MgdHJpZ2dlcmVkIGJ5IGEgaHVtYW4gKHVzdWFsbHkgbWUpLCBidXQgd2Ug
YXJlIHVzaW5nIGENCiAgICAgICAgc2NyaXB0IHRoYXQgYXV0b21hdGVzIGVudGlyZSBwcm9jZXNz
IChzZWUNCiAgICAgICAgaHR0cHM6Ly9naXRodWIuY29tL2xpYmJwZi9saWJicGYvYmxvYi9tYXN0
ZXIvc2NyaXB0cy9zeW5jLWtlcm5lbC5zaCkuDQogICAgICAgIEl0IGNoZXJyeS1waWNrIHJlbGV2
YW50IGNvbW1pdHMgZnJvbSBrZXJuZWwsIHRyYW5zZm9ybXMgdGhlbSB0byBtYXRjaA0KICAgICAg
ICBHaXRodWIncyBmaWxlIGxheW91dCBhbmQgcmUtYXBwbGllcyB0aG9zZSBjaGFuZ2VzIHRvIEdp
dGh1YiByZXBvLg0KICAgICAgICANCiAgICAgICAgVGhlcmUgaXMgbmV2ZXIgYSBzeW5jIGZyb20g
R2l0aHViIGJhY2sgdG8ga2VybmVsLCBidXQgR2l0aHViIHJlcG8NCiAgICAgICAgY29udGFpbnMg
c29tZSBleHRyYSBzdHVmZiB0aGF0J3Mgbm90IGluIGtlcm5lbC4gRS5nLiwgdGhlIHNjcmlwdCBJ
DQogICAgICAgIG1lbnRpb25lZCwgcGx1cyBHaXRodWIncyBNYWtlZmlsZSBpcyBkaWZmZXJlbnQs
IGJlY2F1c2UgaXQgY2FuJ3QgcmVseQ0KICAgICAgICBvbiBrZXJuZWwncyBrYnVpbGQgc2V0dXAu
DQoNCkhpIEppcmksDQpJJ20gY3VyaW91cyBpZiB5b3UgaGF2ZSBhbnkgY29tbWVudHMgcmVnYXJk
aW5nIHN5bmMgcHJvY2VkdXJlIGRlc2NyaWJlZA0KQnkgQW5kcmlpLiBPciBpZiB0aGVyZSBpcyBh
bnl0aGluZyBlbHNlIHlvdSdkIGxpa2UgdXMgdG8gYWRkcmVzcyBzbyBGZWRvcmENCmNhbiBiZSBz
d2l0Y2hlZCB0byBsaWJicGYgYnVpbHQgZnJvbSB0aGUgZ2l0aHViIG1pcnJvcj8NCg0KVGhhbmsg
eW91DQogICAgICAgIA0KICAgICAgICA+DQogICAgICAgID4gdGhhbmtzLA0KICAgICAgICA+IGpp
cmthDQogICAgICAgIA0KDQo=
