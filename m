Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE716672BF
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfGLPsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:48:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbfGLPsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:48:11 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CFUnBn004466;
        Fri, 12 Jul 2019 08:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KpeW+3zljatwGSOQ4izzN1vYpuJ5Nz+QOtwJXggjD30=;
 b=VfusoUZGL5RFdGnOaBzPZn402VKi/XEZwq1LxprvZTDnYTYkUVv80dZ1A4dp5sjSCaY/
 welJ1ET4zz4ZcgxKiL8fAFV31NjVxDM1QSgmMGCyDFhNf8Es94cLZmGamBOcTjN07IAa
 0BKycJAzmCps82NXonGxl+D32MMTXiJWz08= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpr8a914h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 08:47:50 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 12 Jul 2019 08:47:47 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 12 Jul 2019 08:47:47 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 12 Jul 2019 08:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KV33yNtiC3++X3tb+wHLeuxssLZDcjX5LYB9ympTwpyttim3xn05CnsKqpn5RExM7hNPQbzjIuM/zRTCd8PQ4+IbSW2wwcWCR7QuzpU6qGcaWsnk3QuFR9ulmwxxqDHs8BR2ZKJLY50GGuOLR7eOCCH/vSqQRogik0PK6XLfnouY50JgRvBjaNYIdRn/CxD4AJd2ZzmexFlj5zLHl/09N8U0yvIWM8xjVezpxVlSwbQaQcOCFCaWBbV6VA6v5jLuPbmEQJZknTUrZjkAK5VnAhfSKzgk7JD+V/qE9YH9gsYfXkgljwzLQ2pZs0nmmuf5iyLTvEuJqrqhUbQY3ry9oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpeW+3zljatwGSOQ4izzN1vYpuJ5Nz+QOtwJXggjD30=;
 b=iEbZi8TkkUxf1wV2jTG3gJ23B1alKwu0S6eUpozCLRClmJobXtrtm/mE7QPlavyBHbZf66BfmSbKahhukTx9LHGcKDWluUWiN1u73e0vcV29QUlBN/+h3g1jLWQ+L+2CBys3AewcYPIkSeQdXU+PORumAOrAAWm+YIsRuACwbZZ+n/+2PWw6cywFrDwRQXbaqdIK+7XXQ7WkfUYlOl9XSed0brcbHqA0wIB4BErnCnlw+eLPXRkmFBdx/EJnAvWZD3a9w5/4TEfzTCC7+EFHTbNYQrdiieIuF5r548duWlbs1VFytTIefVITxu8wW1dNcCfK+8TWQZKTYSClHoZ+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpeW+3zljatwGSOQ4izzN1vYpuJ5Nz+QOtwJXggjD30=;
 b=Rey3xSio3IjztJ80ak+tGr8tWV9taAZnwTLzWC7tBpH69waybTVPzUMRNlm1H7JdBvTahkfxTSGk7f/CFA8EXvs112ck+ALF5jvixnaoXyp7E8OGbfNn8LJzjVYe+0b6mS3ocChBBWiBV+bZighdj5Yosa5BcLKMCevStQ2d2K4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2949.namprd15.prod.outlook.com (20.178.237.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Fri, 12 Jul 2019 15:47:45 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 15:47:45 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution
 logic
Thread-Topic: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution
 logic
Thread-Index: AQHVN7VeUwERn4PcZEKaNqiZLaNaLqbGfn2AgAChNoCAAAMqAA==
Date:   Fri, 12 Jul 2019 15:47:45 +0000
Message-ID: <1563de9c-b5f6-cb15-18f6-cc01d3ddd110@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
 <20190711065307.2425636-2-andriin@fb.com>
 <ad29872e-a127-f21e-5581-03df5a388a55@fb.com>
 <CAEf4Bzb4vzwRVPegF51Kv6oqTXUAWqnhK-jAVs8SESyh74+XTA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb4vzwRVPegF51Kv6oqTXUAWqnhK-jAVs8SESyh74+XTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:302:1::27) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:9d19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dea59a8-0a02-4fc7-37fe-08d706e04885
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2949;
x-ms-traffictypediagnostic: BYAPR15MB2949:
x-microsoft-antispam-prvs: <BYAPR15MB294957A8AF18A6D21B76D8C8D3F20@BYAPR15MB2949.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(199004)(189003)(76176011)(256004)(4326008)(186003)(71190400001)(446003)(36756003)(14444005)(86362001)(71200400001)(53936002)(31686004)(6512007)(68736007)(6436002)(11346002)(6486002)(6116002)(486006)(102836004)(25786009)(46003)(66476007)(66946007)(31696002)(66556008)(64756008)(2906002)(2616005)(6916009)(66446008)(305945005)(7736002)(14454004)(478600001)(81166006)(6246003)(52116002)(8676002)(316002)(386003)(229853002)(99286004)(6506007)(53546011)(5660300002)(81156014)(54906003)(8936002)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2949;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OK8I4U6OoCbhgpF7JF9jq3wK3lYaMbTxBEja091my2OFPytvDJGkQ5GKkqDhAI6xbAjVze64mlU8acpKK0U6wGzPKRdOLb8t2prwCGNEHh67+dezzC3hE4lsoLoB2ItJzdBwhCNZaRKolbAItPB/NeV8auzcI7H1s8WjqFl3Zyv+jshpc2f3+q5fJDiH1PBMtK1RQDXS8JKbzqeo4TNUkDC9CIJmSclEyG+gan9/hihPJluXOACnBLrMcSgFvSak8SjQtFW6jmvrpAZX4sCoCaUrqj2xpAoSuUBMof50G7Gy1ODS0B99vLpA8Ajm/6elRU0S2rs88XGZYFYSBA98eMos2Z1CrELD/T1oWvtTrDoT4dtAR3mJ6WRBLkxrVOsOycY4G3UJEoqQL9DkvMOU/sJEbBIN0l/yK7VAFrAi1nc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3028EC46599EC43A5CF752C4EDD42A4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea59a8-0a02-4fc7-37fe-08d706e04885
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 15:47:45.7284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTIvMTkgODozNiBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBUaHUs
IEp1bCAxMSwgMjAxOSBhdCAxMDo1OSBQTSBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiB3cm90
ZToNCj4+DQo+Pg0KPj4NCj4+IE9uIDcvMTAvMTkgMTE6NTMgUE0sIEFuZHJpaSBOYWtyeWlrbyB3
cm90ZToNCj4+PiBCVEYgdmVyaWZpZXIgaGFzIGEgc2l6ZSByZXNvbHV0aW9uIGJ1ZyB3aGljaCBp
biBzb21lIGNpcmN1bXN0YW5jZXMgbGVhZHMgdG8NCj4+PiBpbnZhbGlkIHNpemUgcmVzb2x1dGlv
biBmb3IsIGUuZy4sIFRZUEVERUYgbW9kaWZpZXIuICBUaGlzIGhhcHBlbnMgaWYgd2UgaGF2ZQ0K
Pj4+IFsxXSBQVFIgLT4gWzJdIFRZUEVERUYgLT4gWzNdIEFSUkFZLCBpbiB3aGljaCBjYXNlIGR1
ZSB0byBiZWluZyBpbiBwb2ludGVyDQo+Pj4gY29udGV4dCBBUlJBWSBzaXplIHdvbid0IGJlIHJl
c29sdmVkIChiZWNhdXNlIGZvciBwb2ludGVyIGl0IGRvZXNuJ3QgbWF0dGVyLCBzbw0KPj4+IGl0
J3MgYSBzaW5rIGluIHBvaW50ZXIgY29udGV4dCksIGJ1dCBpdCB3aWxsIGJlIHBlcm1hbmVudGx5
IHJlbWVtYmVyZWQgYXMgemVybw0KPj4+IGZvciBUWVBFREVGIGFuZCBUWVBFREVGIHdpbGwgYmUg
bWFya2VkIGFzIFJFU09MVkVELiBFdmVudHVhbGx5IEFSUkFZIHNpemUgd2lsbA0KPj4+IGJlIHJl
c29sdmVkIGNvcnJlY3RseSwgYnV0IFRZUEVERUYgcmVzb2x2ZWRfc2l6ZSB3b24ndCBiZSB1cGRh
dGVkIGFueW1vcmUuDQo+Pj4gVGhpcywgc3Vic2VxdWVudGx5LCB3aWxsIGxlYWQgdG8gZXJyb25l
b3VzIG1hcCBjcmVhdGlvbiBmYWlsdXJlLCBpZiB0aGF0DQo+Pj4gVFlQRURFRiBpcyBzcGVjaWZp
ZWQgYXMgZWl0aGVyIGtleSBvciB2YWx1ZSwgYXMga2V5X3NpemUvdmFsdWVfc2l6ZSB3b24ndA0K
Pj4+IGNvcnJlc3BvbmQgdG8gcmVzb2x2ZWQgc2l6ZSBvZiBUWVBFREVGIChrZXJuZWwgd2lsbCBi
ZWxpZXZlIGl0J3MgemVybykuDQo+Pj4NCj4+PiBOb3RlLCB0aGF0IGlmIEJURiB3YXMgb3JkZXJl
ZCBhcyBbMV0gQVJSQVkgPC0gWzJdIFRZUEVERUYgPC0gWzNdIFBUUiwgdGhpcw0KPj4+IHdvbid0
IGJlIGEgcHJvYmxlbSwgYXMgYnkgdGhlIHRpbWUgd2UgZ2V0IHRvIFRZUEVERUYsIEFSUkFZJ3Mg
c2l6ZSBpcyBhbHJlYWR5DQo+Pj4gY2FsY3VsYXRlZCBhbmQgc3RvcmVkLg0KPj4+DQo+Pj4gVGhp
cyBidWcgbWFuaWZlc3RzIGl0c2VsZiBpbiByZWplY3RpbmcgQlRGLWRlZmluZWQgbWFwcyB0aGF0
IHVzZSBhcnJheQ0KPj4+IHR5cGVkZWYgYXMgYSB2YWx1ZSB0eXBlOg0KPj4+DQo+Pj4gdHlwZWRl
ZiBpbnQgYXJyYXlfdFsxNl07DQo+Pj4NCj4+PiBzdHJ1Y3Qgew0KPj4+ICAgICAgIF9fdWludCh0
eXBlLCBCUEZfTUFQX1RZUEVfQVJSQVkpOw0KPj4+ICAgICAgIF9fdHlwZSh2YWx1ZSwgYXJyYXlf
dCk7IC8qIGkuZS4sIGFycmF5X3QgKnZhbHVlOyAqLw0KPj4+IH0gdGVzdF9tYXAgU0VDKCIubWFw
cyIpOw0KPj4+DQo+Pj4gVGhlIGZpeCBjb25zaXN0cyBvbiBub3QgcmVseWluZyBvbiBtb2RpZmll
cidzIHJlc29sdmVkX3NpemUgYW5kIGluc3RlYWQgdXNpbmcNCj4+PiBtb2RpZmllcidzIHJlc29s
dmVkX2lkICh0eXBlIElEIGZvciAiY29uY3JldGUiIHR5cGUgdG8gd2hpY2ggbW9kaWZpZXINCj4+
PiBldmVudHVhbGx5IHJlc29sdmVzKSBhbmQgZG9pbmcgc2l6ZSBkZXRlcm1pbmF0aW9uIGZvciB0
aGF0IHJlc29sdmVkIHR5cGUuIFRoaXMNCj4+PiBhbGxvdyB0byBwcmVzZXJ2ZSBleGlzdGluZyAi
ZWFybHkgREZTIHRlcm1pbmF0aW9uIiBsb2dpYyBmb3IgUFRSIG9yDQo+Pj4gU1RSVUNUX09SX0FS
UkFZIGNvbnRleHRzLCBidXQgc3RpbGwgZG8gY29ycmVjdCBzaXplIGRldGVybWluYXRpb24gZm9y
IG1vZGlmaWVyDQo+Pj4gdHlwZXMuDQo+Pj4NCj4+PiBGaXhlczogZWIzZjU5NWRhYjQwICgiYnBm
OiBidGY6IFZhbGlkYXRlIHR5cGUgcmVmZXJlbmNlIikNCj4+PiBDYzogTWFydGluIEthRmFpIExh
dSA8a2FmYWlAZmIuY29tPg0KPj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5k
cmlpbkBmYi5jb20+DQo+Pj4gLS0tDQo+Pj4gICAga2VybmVsL2JwZi9idGYuYyB8IDE0ICsrKysr
KysrKystLS0tDQo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYuYyBiL2tlcm5l
bC9icGYvYnRmLmMNCj4+PiBpbmRleCBjYWQwOTg1OGE1ZjIuLjIyZmU4YjE1NWU1MSAxMDA2NDQN
Cj4+PiAtLS0gYS9rZXJuZWwvYnBmL2J0Zi5jDQo+Pj4gKysrIGIva2VybmVsL2JwZi9idGYuYw0K
Pj4+IEBAIC0xMDczLDExICsxMDczLDE4IEBAIGNvbnN0IHN0cnVjdCBidGZfdHlwZSAqYnRmX3R5
cGVfaWRfc2l6ZShjb25zdCBzdHJ1Y3QgYnRmICpidGYsDQo+Pj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAhYnRmX3R5cGVfaXNfdmFyKHNpemVfdHlwZSkpKQ0KPj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+Pj4NCj4+PiAtICAgICAgICAgICAgIHNpemUg
PSBidGYtPnJlc29sdmVkX3NpemVzW3NpemVfdHlwZV9pZF07DQo+Pj4gICAgICAgICAgICAgICAg
c2l6ZV90eXBlX2lkID0gYnRmLT5yZXNvbHZlZF9pZHNbc2l6ZV90eXBlX2lkXTsNCj4+PiAgICAg
ICAgICAgICAgICBzaXplX3R5cGUgPSBidGZfdHlwZV9ieV9pZChidGYsIHNpemVfdHlwZV9pZCk7
DQo+Pj4gICAgICAgICAgICAgICAgaWYgKGJ0Zl90eXBlX25vc2l6ZV9vcl9udWxsKHNpemVfdHlw
ZSkpDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4+PiArICAgICAg
ICAgICAgIGVsc2UgaWYgKGJ0Zl90eXBlX2hhc19zaXplKHNpemVfdHlwZSkpDQo+Pj4gKyAgICAg
ICAgICAgICAgICAgICAgIHNpemUgPSBzaXplX3R5cGUtPnNpemU7DQo+Pj4gKyAgICAgICAgICAg
ICBlbHNlIGlmIChidGZfdHlwZV9pc19hcnJheShzaXplX3R5cGUpKQ0KPj4+ICsgICAgICAgICAg
ICAgICAgICAgICBzaXplID0gYnRmLT5yZXNvbHZlZF9zaXplc1tzaXplX3R5cGVfaWRdOw0KPj4+
ICsgICAgICAgICAgICAgZWxzZSBpZiAoYnRmX3R5cGVfaXNfcHRyKHNpemVfdHlwZSkpDQo+Pj4g
KyAgICAgICAgICAgICAgICAgICAgIHNpemUgPSBzaXplb2Yodm9pZCAqKTsNCj4+PiArICAgICAg
ICAgICAgIGVsc2UNCj4+PiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+Pg0K
Pj4gTG9va3MgZ29vZCB0byBtZS4gTm90IHN1cmUgd2hldGhlciB3ZSBuZWVkIHRvIGRvIGFueSBh
ZGp1c3RtZW50IGZvcg0KPj4gdmFyIGtpbmQgb3Igbm90LiBNYXliZSB3ZSBjYW4gZG8gc2ltaWxh
ciBjaGFuZ2UgaW4gYnRmX3Zhcl9yZXNvbHZlKCkNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgYnRmX3Zh
cl9yZXNvbHZlKCkgbmVlZHMgYW55IGNoYW5nZS4gYnRmX3Zhcl9yZXNvbHZlDQo+IGNhbid0IGJl
IHJlZmVyZW5jZWQgYnkgbW9kaWZpZXIsIHNvIGl0IGRvZXNuJ3QgaGF2ZSBhbnkgcHJvYmxlbS4g
SXQncw0KPiBzaW1pbGFyIHRvIGFycmF5IGluIHRoYXQgaXQncyBzaXplIHdpbGwgYmUgZGV0ZXJt
aW5lZCBjb3JyZWN0bHkuDQoNCkNvcnJlY3QuIFdpdGggeW91ciBwcmV2aW91cyBwYXRjaCwgdGhl
IHJlc29sdmVkX3NpemVzWy4uXSBmb3IgdmFyIHR5cGUgDQppcyBub3QgdXNlZCwgc28gdGhhdCBp
cyB3aHkgSSBzdWdnZXN0IHRvIGp1c3Qgc2V0IGl0IHRvIDAuDQoNCj4gDQo+IEJ1dCBJIHRoaW5r
IGJ0Zl90eXBlX2lkX3NpemUoKSBkb2Vzbid0IGhhbmRsZSB2YXIgY2FzZSBjb3JyZWN0bHksIEkn
bGwgZG8NCj4gDQo+ICsgICAgICAgICAgICAgZWxzZSBpZiAoYnRmX3R5cGVfaXNfYXJyYXkoc2l6
ZV90eXBlKSB8fA0KPiBidGZfdHlwZV9pc192YXIoc2l6ZV90eXBlKSkNCj4gKyAgICAgICAgICAg
ICAgICAgICAgIHNpemUgPSBidGYtPnJlc29sdmVkX3NpemVzW3NpemVfdHlwZV9pZF07DQoNClRo
aXMgY2hhbmdlIHNob3VsZCB3b3JrIHRvbyAodG8gdXNlIGJ0Zi0+cmVzb2x2ZWRfc2l6ZXNbLi4u
XSkuDQoNCj4gDQo+IHRvIGZpeCB0aGF0Lg0KPiANCj4+IHRvIGJ0Zl9tb2RpZmllcl9yZXNvbHZl
KCk/IEJ1dCBJIGRvIG5vdCB0aGluayBpdCBpbXBhY3RzIGNvcnJlY3RuZXNzDQo+PiBzaW1pbGFy
IHRvIGJ0Zl9tb2RpZmllcl9yZXNvbHZlKCkgYmVsb3cgYXMgeW91IGNoYW5nZWQNCj4+IGJ0Zl90
eXBlX2lkX3NpemUoKSBpbXBsZW1lbnRhdGlvbiBpbiB0aGUgYWJvdmUuDQo+Pg0KPj4+ICAgICAg
ICB9DQo+Pj4NCj4+PiAgICAgICAgKnR5cGVfaWQgPSBzaXplX3R5cGVfaWQ7DQo+Pj4gQEAgLTE2
MDIsNyArMTYwOSw2IEBAIHN0YXRpYyBpbnQgYnRmX21vZGlmaWVyX3Jlc29sdmUoc3RydWN0IGJ0
Zl92ZXJpZmllcl9lbnYgKmVudiwNCj4+PiAgICAgICAgY29uc3Qgc3RydWN0IGJ0Zl90eXBlICpu
ZXh0X3R5cGU7DQo+Pj4gICAgICAgIHUzMiBuZXh0X3R5cGVfaWQgPSB0LT50eXBlOw0KPj4+ICAg
ICAgICBzdHJ1Y3QgYnRmICpidGYgPSBlbnYtPmJ0ZjsNCj4+PiAtICAgICB1MzIgbmV4dF90eXBl
X3NpemUgPSAwOw0KPj4+DQo+Pj4gICAgICAgIG5leHRfdHlwZSA9IGJ0Zl90eXBlX2J5X2lkKGJ0
ZiwgbmV4dF90eXBlX2lkKTsNCj4+PiAgICAgICAgaWYgKCFuZXh0X3R5cGUgfHwgYnRmX3R5cGVf
aXNfcmVzb2x2ZV9zb3VyY2Vfb25seShuZXh0X3R5cGUpKSB7DQo+Pj4gQEAgLTE2MjAsNyArMTYy
Niw3IEBAIHN0YXRpYyBpbnQgYnRmX21vZGlmaWVyX3Jlc29sdmUoc3RydWN0IGJ0Zl92ZXJpZmll
cl9lbnYgKmVudiwNCj4+PiAgICAgICAgICogc2F2ZSB1cyBhIGZldyB0eXBlLWZvbGxvd2luZyB3
aGVuIHdlIHVzZSBpdCBsYXRlciAoZS5nLiBpbg0KPj4+ICAgICAgICAgKiBwcmV0dHkgcHJpbnQp
Lg0KPj4+ICAgICAgICAgKi8NCj4+PiAtICAgICBpZiAoIWJ0Zl90eXBlX2lkX3NpemUoYnRmLCAm
bmV4dF90eXBlX2lkLCAmbmV4dF90eXBlX3NpemUpKSB7DQo+Pj4gKyAgICAgaWYgKCFidGZfdHlw
ZV9pZF9zaXplKGJ0ZiwgJm5leHRfdHlwZV9pZCwgTlVMTCkpIHsNCj4+PiAgICAgICAgICAgICAg
ICBpZiAoZW52X3R5cGVfaXNfcmVzb2x2ZWQoZW52LCBuZXh0X3R5cGVfaWQpKQ0KPj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgbmV4dF90eXBlID0gYnRmX3R5cGVfaWRfcmVzb2x2ZShidGYsICZu
ZXh0X3R5cGVfaWQpOw0KPj4+DQo+Pj4gQEAgLTE2MzMsNyArMTYzOSw3IEBAIHN0YXRpYyBpbnQg
YnRmX21vZGlmaWVyX3Jlc29sdmUoc3RydWN0IGJ0Zl92ZXJpZmllcl9lbnYgKmVudiwNCj4+PiAg
ICAgICAgICAgICAgICB9DQo+Pj4gICAgICAgIH0NCj4+Pg0KPj4+IC0gICAgIGVudl9zdGFja19w
b3BfcmVzb2x2ZWQoZW52LCBuZXh0X3R5cGVfaWQsIG5leHRfdHlwZV9zaXplKTsNCj4+PiArICAg
ICBlbnZfc3RhY2tfcG9wX3Jlc29sdmVkKGVudiwgbmV4dF90eXBlX2lkLCAwKTsNCj4+Pg0KPj4+
ICAgICAgICByZXR1cm4gMDsNCj4+PiAgICB9DQo+Pj4NCg==
