Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BDFFBB97
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfKMW0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:26:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbfKMW03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:26:29 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xADMNcCM000861;
        Wed, 13 Nov 2019 14:26:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aGUX0IHcGG+NFdZyEjq0+oaC44ycFh82Rso1LQx70WI=;
 b=H8f59KhMzsTsmnJYjNGPsLoPAXbFggLtvH+4+7ZBy03k9S4b/K65XVAEX2DpR3vmgz5D
 qN/uWYSb7IBbJYfV+zKsQC4hmohjVzGliwdu6Ed39K1BnjgjcKIiXfdyDw9S9AGfYRSa
 N/1kIcXJaXjo5uxrK71u0bDWyyDbuGvgTE4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8rgdgnde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Nov 2019 14:26:09 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 14:26:02 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 Nov 2019 14:26:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AokgzyurlhadoPk9BXR0Hh7Nb7MdpsQql0vc8Es5i/X4hisO+MsW+F/uYB89L2SgIXI+9oohV/FTwUfsiZFvCs1slURJgoSKB8cDLrtletVOHz3EPgse+vH92v7eH4DvpRgfZLifZZ9FT8n1vuXR95uavRDzPwz8uWp/6goi/Sbc16y4pcx6jfwRk2WdQGQJXcETIQNzqyunIR1qCU4TFs2CvbEb1ztqHxJLmd2G0rSmUGMMG1NPaCkrq4e8BYPELjX9Fpfh3htGNdmIVcec7acF75QtsD7P3SkhlQ+AxrIyra6HdwNZh4MhIUfD9ywwCJa/ZWlbK+r5RX2xCEPwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGUX0IHcGG+NFdZyEjq0+oaC44ycFh82Rso1LQx70WI=;
 b=oS+ZN+EM8CWQc17Xojaetkzr5mfexoU+BWDdRJM3WVZCAk1jWAXDOW9SP7qS71u36iLU1q2E5d6xROUBV49r1/nu85LgZ31Ftm6Tc0+0q8sAI527XX4u0KHZzwlBZArnVul3QYyTco0aOq05uqABLOHSq+6YeJ0oTaZ0N/c6jHgcR8ukPOt1IThD0fDLl2scCu8V37WSXp65wDcKvSKqqTm3d8kUWy4Xw4PUlmnirNVr5GjiaLDxZ27NuoZoMIgbrmYC+b8jNbW/COzTCyN+0EfEBZtGbzch8Iu0xmGs8xI0uitjeNjBootGJGDSDr66NzcZ7rsugVhLgNGcofsYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGUX0IHcGG+NFdZyEjq0+oaC44ycFh82Rso1LQx70WI=;
 b=Jw/eR8wVRQkV64msGjaG5F/pLtS1YWfQjBl7xBe2/324BnMSfIkNyScaD81ZvXMS2iVmMGg4IH4o9nJXEludiTn6+QumVn/ZaxX3gIH+HbjLXTHeLhlo/UuEJFFxswW5ZgOgqZMuqaSZWU9nY18yW0YjBZgRa9VOpr1hXFspZHk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2615.namprd15.prod.outlook.com (20.179.155.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 22:26:01 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:26:01 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>
CC:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC bpf-next 0/3] bpf: adding map batch processing support
Thread-Topic: [RFC bpf-next 0/3] bpf: adding map batch processing support
Thread-Index: AQHVlbFC7S2RDjT11Um4peJ3xLWVf6eH5EMAgAHNwwCAAAU6gA==
Date:   Wed, 13 Nov 2019 22:26:01 +0000
Message-ID: <45d9880e-de9e-abb6-b883-fecb9781738e@fb.com>
References: <20191107212023.171208-1-brianvv@google.com>
 <61f1e2f3-e0d5-cf2e-c16e-807b09bb84e7@fb.com>
 <CAMzD94TekSSCCAZD4jZiUpdfMKDqWcwdNf42b_heTGvv1K-=fg@mail.gmail.com>
In-Reply-To: <CAMzD94TekSSCCAZD4jZiUpdfMKDqWcwdNf42b_heTGvv1K-=fg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0005.namprd02.prod.outlook.com
 (2603:10b6:301:74::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:aa2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b02e441-a8a4-4b43-5ce7-08d7688876bc
x-ms-traffictypediagnostic: BYAPR15MB2615:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR15MB261525079009AC0E52D2BCA2D3760@BYAPR15MB2615.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6436002)(14454004)(6486002)(71190400001)(71200400001)(6306002)(2906002)(6512007)(36756003)(966005)(478600001)(476003)(229853002)(2616005)(4326008)(305945005)(7736002)(6246003)(11346002)(446003)(46003)(99286004)(14444005)(256004)(31696002)(66446008)(66556008)(64756008)(86362001)(66476007)(66946007)(8676002)(6116002)(53546011)(31686004)(25786009)(316002)(186003)(54906003)(8936002)(81166006)(81156014)(6916009)(5660300002)(386003)(76176011)(102836004)(486006)(7416002)(6506007)(52116002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2615;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0H1JUgrE1LMKOcwIP75JDoIs5F/SEumXHKgEHRhp3LDDBmo7LJyewwiBECXaSn3lBngrBSi9ILsKmdT3h9FwFlDwcoxWp1weKkctro0nk9TwuyR29HMLMUAz9IVsVzEohHDODNxlzNFW1P3BnuHxhoSB/0r85eTht25jA1VCsrJdmGIPS5u+iY+3hfwSSzp5T2STgt0IR8+bXiwbIL2WShrPp1gYdQjpW14ndOQIUfFw7WZTVLkKyH/3xmT9VBLTt2HveMg0WTvNLFizeoWwPj6mTbkk2uhcznpUpc1vNYPM0XCktCHqok2G9N6wbs4t8cGoKUNecnrspEVDjoa0E9vrLeImLvCPVNHFkkstLqjU+lS1hY8dJ2KgvWEPJxlDUzPH1dNGFTcXA1BdllP6WGj0FHOnqNsCuz/wMYUuVAc+5kTWujGLFDKjeeu84FkJWmN1dsyfqpLTcwsdSbGOGImH2r0fZTdPdYVbjKsySTU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <881E049B2326AB4F82D4FB9859DDC2D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b02e441-a8a4-4b43-5ce7-08d7688876bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:26:01.4780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lHz6k/kk3s1RieMOQcrZhM1Bw27wZjS1KYbT5DRPTLonmxgrpY7xjaRACCwczX++
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2615
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-13_05:2019-11-13,2019-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzEzLzE5IDI6MDcgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IEhpIFlvbmdo
b25nLA0KPiANCj4gVGhhbmtzIGZvciByZXZpZXdpbmcgaXQhIEknbSBwcmVwYXJpbmcgdGhlIGNo
YW5nZXMgYW5kIHdpbGwgc3VibWl0IHRoZW0gDQo+IHNvb25lci4NCj4gDQo+IEFzIGZvciB0aGUg
cmlnaHQgd2F5IHRvIG1hbmFnZSBhdXRob3IgcmlnaHRzLCBkb2VzIGFueW9uZSBrbm93wqB3aGF0
IHRoZSANCj4gY29ycmVjdCBhcHByb2FjaCBpcz8gU2hvdWxkIEkgdXNlIFlvbmdob25nJ3MgcGF0
Y2ggYW5kIGFwcGx5IHRoZSANCj4gZXh0ZW5kZWQgc3VwcG9ydCBpbiBkaWZmZXJlbnQgcGF0Y2hl
cyAoaS5lLiBzdXBwb3J0IHBlcl9jcHUgbWFwcywgY2hhbmdlIA0KPiBiYXRjaCBmcm9tIHU2NCB0
byBfX2FsaWduZWRfdTY0LCBldGMpIG9yIGl0IGlzIGZpbmUgdG8gYXBwbHkgdGhlIGNoYW5nZXMg
DQo+IGluIHBsYWNlIGFuZCB3cml0ZSBib3RoIHNpZ24tb2Zmcz8NCg0KVGhlIGxvZ2ljIGZsb3cg
b2YgdGhlIHBhdGNoIHNldCBpcyBtb3N0IGltcG9ydGFudC4NCllvdSBjYW4gYWRkIG1lIGFzIGNv
LXNpZ25vZmYgaWYgeW91IHJldXNlIHNpZ25pZmljYW50IHBvcnRpb24gb2YgbXkgY29kZS4NCg0K
PiANCj4gVGhhbmtzLA0KPiBCcmlhbg0KPiANCj4gT24gVHVlLCBOb3YgMTIsIDIwMTkgYXQgNjoz
NCBQTSBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tIA0KPiA8bWFpbHRvOnloc0BmYi5jb20+PiB3
cm90ZToNCj4gDQo+IA0KPiANCj4gICAgIE9uIDExLzcvMTkgMToyMCBQTSwgQnJpYW4gVmF6cXVl
eiB3cm90ZToNCj4gICAgICA+IFRoaXMgaXMgYSBmb2xsb3cgdXAgaW4gdGhlIGVmZm9ydCB0byBi
YXRjaCBicGYgbWFwIG9wZXJhdGlvbnMgdG8NCj4gICAgIHJlZHVjZQ0KPiAgICAgID4gdGhlIHN5
c2NhbGwgb3ZlcmhlYWQgd2l0aCB0aGUgbWFwX29wcy4gSSBpbml0aWFsbHkgcHJvcG9zZWQgdGhl
DQo+ICAgICBpZGVhIGFuZA0KPiAgICAgID4gdGhlIGRpc2N1c3Npb24gaXMgaGVyZToNCj4gICAg
ICA+DQo+ICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAxOTA3MjQxNjU4MDMuODc0
NzAtMS1icmlhbnZ2QGdvb2dsZS5jb20vDQo+ICAgICAgPg0KPiAgICAgID4gWW9uZ2hvbmcgdGFs
a2VkIGF0IHRoZSBMUEMgYWJvdXQgdGhpcyBhbmQgYWxzbyBwcm9wb3NlZCBhbmQgaWRlYSB0aGF0
DQo+ICAgICAgPiBoYW5kbGVzIHRoZSBzcGVjaWFsIHdlaXJkIGNhc2Ugb2YgaGFzaHRhYmxlcyBi
eSBkb2luZyB0cmF2ZXJzaW5nDQo+ICAgICB1c2luZw0KPiAgICAgID4gdGhlIGJ1Y2tldHMgYXMg
YSByZWZlcmVuY2UgaW5zdGVhZCBvZiBhIGtleS4gRGlzY3Vzc2lvbiBpcyBoZXJlOg0KPiAgICAg
ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMTkwOTA2MjI1NDM0LjM2MzU0MjEtMS15
aHNAZmIuY29tLw0KPiAgICAgID4NCj4gICAgICA+IFRoaXMgUkZDIHByb3Bvc2VzIGEgd2F5IHRv
IGV4dGVuZCBiYXRjaCBvcGVyYXRpb25zIGZvciBtb3JlIGRhdGENCj4gICAgICA+IHN0cnVjdHVy
ZXMgYnkgY3JlYXRpbmcgZ2VuZXJpYyBiYXRjaCBmdW5jdGlvbnMgdGhhdCBjYW4gYmUgdXNlZA0K
PiAgICAgaW5zdGVhZA0KPiAgICAgID4gb2YgaW1wbGVtZW50aW5nIHRoZSBvcGVyYXRpb25zIGZv
ciBlYWNoIGluZGl2aWR1YWwgZGF0YSBzdHJ1Y3R1cmUsDQo+ICAgICAgPiByZWR1Y2luZyB0aGUg
Y29kZSB0aGF0IG5lZWRzIHRvIGJlIG1haW50YWluZWQuIFRoZSBzZXJpZXMNCj4gICAgIGNvbnRh
aW5zIHRoZQ0KPiAgICAgID4gcGF0Y2hlcyB1c2VkIGluIFlvbmdob25nJ3MgUkZDIGFuZCB0aGUg
cGF0Y2ggdGhhdCBhZGRzIHRoZSBnZW5lcmljDQo+ICAgICAgPiBpbXBsZW1lbnRhdGlvbiBvZiB0
aGUgb3BlcmF0aW9ucyBwbHVzIHNvbWUgdGVzdGluZyB3aXRoIHBjcHUgaGFzaG1hcHMNCj4gICAg
ICA+IGFuZCBhcnJheXMuIE5vdGUgdGhhdCBwY3B1IGhhc2htYXAgc2hvdWxkbid0IHVzZSB0aGUg
Z2VuZXJpYw0KPiAgICAgID4gaW1wbGVtZW50YXRpb24gYW5kIGl0IGVpdGhlciBzaG91bGQgaGF2
ZSBpdHMgb3duIGltcGxlbWVudGF0aW9uDQo+ICAgICBvciBzaGFyZQ0KPiAgICAgID4gdGhlIG9u
ZSBpbnRyb2R1Y2VkIGJ5IFlvbmdob25nLCBJIGFkZGVkIHRoYXQganVzdCBhcyBhbiBleGFtcGxl
DQo+ICAgICB0byBzaG93DQo+ICAgICAgPiB0aGF0IHRoZSBnZW5lcmljIGltcGxlbWVudGF0aW9u
IGNhbiBiZSBlYXNpbHkgYWRkZWQgdG8gYSBkYXRhDQo+ICAgICBzdHJ1Y3R1cmUuDQo+ICAgICAg
Pg0KPiAgICAgID4gV2hhdCBJIHdhbnQgdG8gYWNoaWV2ZSB3aXRoIHRoaXMgUkZDIGlzIHRvIGNv
bGxlY3QgZWFybHkgZmVlZGJhY2sNCj4gICAgIGFuZCBzZWUgaWYNCj4gICAgICA+IHRoZXJlJ3Mg
YW55IG1ham9yIGNvbmNlcm4gYWJvdXQgdGhpcyBiZWZvcmUgSSBtb3ZlIGZvcndhcmQuIEkgZG8g
cGxhbg0KPiAgICAgID4gdG8gYmV0dGVyIHNlcGFyYXRlIHRoaXMgaW50byBkaWZmZXJlbnQgcGF0
Y2hlcyBhbmQgZXhwbGFpbiB0aGVtDQo+ICAgICBwcm9wZXJseQ0KPiAgICAgID4gaW4gdGhlIGNv
bW1pdCBtZXNzYWdlcy4NCj4gDQo+ICAgICBUaGFua3MgQnJpYW4gZm9yIHdvcmtpbmcgb24gdGhp
cy4gVGhlIGdlbmVyYWwgYXBwcm9hY2ggZGVzY3JpYmVkIGhlcmUNCj4gICAgIGlzIGdvb2QgdG8g
bWUuIEhhdmluZyBhIGdlbmVyaWMgaW1wbGVtZW50YXRpb24gZm9yIGJhdGNoIG9wZXJhdGlvbnMN
Cj4gICAgIGxvb2tzIGdvb2QgZm9yIG1hcHMgKG5vdCBoYXNoIHRhYmxlLCBxdWV1ZS9zdGFjaywg
ZXRjLikNCj4gDQo+ICAgICAgPg0KPiAgICAgID4gQ3VycmVudCBrbm93biBpc3N1ZXMgd2hlcmUg
SSB3b3VsZCBsaWtlIHRvIGRpc2N1c3MgYXJlIHRoZQ0KPiAgICAgZm9sbG93aW5nczoNCj4gICAg
ICA+DQo+ICAgICAgPiAtIEJlY2F1c2UgWW9uZ2hvbmcncyBVQVBJIGRlZmluaXRpb24gd2FzIGRv
bmUgc3BlY2lmaWNhbGx5IGZvcg0KPiAgICAgID7CoCDCoCBpdGVyYXRpbmcgYnVja2V0cywgdGhl
IGJhdGNoIGZpZWxkIGlzIHU2NCBhbmQgaXMgdHJlYXRlZCBhcyBhbiB1NjQNCj4gICAgICA+wqAg
wqAgaW5zdGVhZCBvZiBhbiBvcGFxdWUgcG9pbnRlciwgdGhpcyB3b24ndCB3b3JrIGZvciBvdGhl
ciBkYXRhDQo+ICAgICBzdHJ1Y3R1cmVzDQo+ICAgICAgPsKgIMKgIHRoYXQgYXJlIGdvaW5nIHRv
IHVzZSBhIGtleSBhcyBhIGJhdGNoIHRva2VuIHdpdGggYSBzaXplDQo+ICAgICBncmVhdGVyIHRo
YW4NCj4gICAgICA+wqAgwqAgNjQuIEFsdGhvdWdoIEkgdGhpbmsgYXQgdGhpcyBwb2ludCB0aGUg
b25seSBrZXkgdGhhdCBjb3VsZG4ndCBiZQ0KPiAgICAgID7CoCDCoCB0cmVhdGVkIGFzIGEgdTY0
IGlzIHRoZSBrZXkgb2YgYSBoYXNobWFwLCBhbmQgdGhlIGhhc2htYXANCj4gICAgIHdvbid0IHVz
ZQ0KPiAgICAgID7CoCDCoCB0aGUgZ2VuZXJpYyBpbnRlcmZhY2UuDQo+IA0KPiAgICAgVGhlIHU2
NCBjYW4gYmUgY2hhbmdlZCB3aXRoIGEgX19hbGlnbmVkX3U2NCBvcGFxdWUgdmFsdWUuIFRoaXMg
d2F5LA0KPiAgICAgaXQgY2FuIHJlcHJlc2VudCBhIHBvaW50ZXIgb3IgYSA2NGJpdCB2YWx1ZS4N
Cj4gDQo+ICAgICAgPiAtIE5vdCBhbGwgdGhlIGRhdGEgc3RydWN0dXJlcyB1c2UgZGVsZXRlIChi
ZWNhdXNlIGl0J3Mgbm90IGEgdmFsaWQNCj4gICAgICA+wqAgwqAgb3BlcmF0aW9uKSBpLmUuIGFy
cmF5cy4gU28gbWF5YmUgbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gNCj4gICAgIGNvbW1hbmQgaXMN
Cj4gICAgICA+wqAgwqAgbm90IG5lZWRlZCBhbmQgd2UgY2FuIGhhbmRsZSB0aGF0IG9wZXJhdGlv
biB3aXRoIGENCj4gICAgIGxvb2t1cF9iYXRjaCBhbmQgYQ0KPiAgICAgID7CoCDCoCBmbGFnLg0K
PiANCj4gICAgIFRoaXMgbWFrZSBzZW5zZS4NCj4gDQo+ICAgICAgPiAtIEZvciBkZWxldGVfYmF0
Y2ggKG5vdCBqdXN0IHRoZSBsb29rdXBfYW5kX2RlbGV0ZV9iYXRjaCkuIElzIHRoaXMNCj4gICAg
ICA+wqAgwqAgb3BlcmF0aW9uIHJlYWxseSBuZWVkZWQ/IElmIHNvLCBzaG91bGRuJ3QgaXQgYmUg
YmV0dGVyIGlmIHRoZQ0KPiAgICAgID7CoCDCoCBiZWhhdmlvdXIgaXMgZGVsZXRlIHRoZSBrZXlz
IHByb3ZpZGVkPyBJIGRpZCB0aGF0IHdpdGggbXkgZ2VuZXJpYw0KPiAgICAgID7CoCDCoCBpbXBs
ZW1lbnRhdGlvbiBidXQgWW9uZ2hvbmcncyBkZWxldGVfYmF0Y2ggZm9yIGEgaGFzaG1hcCBkZWxl
dGVzDQo+ICAgICAgPsKgIMKgIGJ1Y2tldHMuDQo+IA0KPiAgICAgV2UgbmVlZCBiYXRjaGVkIGRl
bGV0ZSBpbiBiY2MuIGxvb2t1cF9hbmRfZGVsZXRlX2JhdGNoIGlzIGJldHRlciBhcw0KPiAgICAg
aXQgY2FuIHByZXNlcnZlcyBtb3JlIG5ldyBtYXAgZW50cmllcy4gQWx0ZXJuYXRpdmVseSwgZGVs
ZXRpbmcNCj4gICAgIGFsbCBlbnRyaWVzIGFmdGVyIGxvb2t1cCBpcyBhbm90aGVyIG9wdGlvbi4g
QnV0IHRoaXMgbWF5IHJlbW92ZQ0KPiAgICAgbW9yZSBuZXcgbWFwIGVudHJpZXMuIFN0YXRpc3Rp
Y2FsbHkgdGhpcyBtYXkgb3IgbWF5IG5vdCBtYXR0ZXIgdGhvdWdoLg0KPiANCj4gICAgIGJjYyBk
b2VzIGhhdmUgYSBjbGVhcl90YWJsZSAoY2xlYXJfbWFwKSBBUEksIGJ1dCBub3QgY2xlYXIgd2hv
IGlzDQo+ICAgICB1c2luZyBpdC4NCj4gDQo+ICAgICBTbywgSSBkaWQgbm90IGhhdmUgYSBjb25j
cmV0ZSB1c2UgY2FzZSBmb3IgZGVsZXRlX2JhdGNoIHlldC4NCj4gICAgIEkgdGVuZCB0byB0aGlu
ayB3ZSBzaG91bGQgaGF2ZSBkZWxldGVfYmF0Y2ggZm9yIEFQSSBjb21wbGV0ZW5lc3MsDQo+ICAg
ICBidXQgbWF5YmUgb3RoZXIgcGVvcGxlIGNhbiBjb21tZW50IG9uIHRoaXMgYXMgd2VsbC4NCj4g
DQo+ICAgICBNYXliZSBpbml0aWFsIHBhdGNoLCB3ZSBjYW4gc2tpcCBpdC4gQnV0IHdlIHNob3Vs
ZCBzdGlsbCBlbnN1cmUNCj4gICAgIHVzZXIgaW50ZXJmYWNlIGRhdGEgc3RydWN0dXJlIGNhbiBo
YW5kbGUgYmF0Y2ggZGVsZXRlIGlmIGl0IGlzDQo+ICAgICBuZWVkZWQgbGF0ZXIuIFRoZSBjdXJy
ZW50IGRhdGEgc3RydWN0dXJlIHNob3VsZCBoYW5kbGUgdGhpcw0KPiAgICAgYXMgZmFyIGFzIEkg
a25vdy4NCj4gDQo+ICAgICAgPg0KPiAgICAgID4gQnJpYW4gVmF6cXVleiAoMSk6DQo+ICAgICAg
PsKgIMKgIGJwZjogYWRkIGdlbmVyaWMgYmF0Y2ggc3VwcG9ydA0KPiAgICAgID4NCj4gICAgICA+
IFlvbmdob25nIFNvbmcgKDIpOg0KPiAgICAgID7CoCDCoCBicGY6IGFkZGluZyBtYXAgYmF0Y2gg
cHJvY2Vzc2luZyBzdXBwb3J0DQo+ICAgICAgPsKgIMKgIHRvb2xzL2JwZjogdGVzdCBicGZfbWFw
X2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoKCkNCj4gICAgICA+DQo+ICAgICAgPsKgIMKgaW5jbHVk
ZS9saW51eC9icGYuaMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKg
IDIxICsNCj4gICAgICA+wqAgwqBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmjCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgMjIgKw0KPiAgICAgID7CoCDCoGtlcm5lbC9icGYvYXJy
YXltYXAuY8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIMKgNCArDQo+
ICAgICAgPsKgIMKga2VybmVsL2JwZi9oYXNodGFiLmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCB8IDMzMSArKysrKysrKysrDQo+ICAgICAgPsKgIMKga2VybmVsL2JwZi9z
eXNjYWxsLmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8IDU3Mw0KPiAg
ICAgKysrKysrKysrKysrKystLS0tDQo+ICAgICAgPsKgIMKgdG9vbHMvaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5owqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfMKgIDIyICsNCj4gICAgICA+wqAgwqB0
b29scy9saWIvYnBmL2JwZi5jwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqB8wqAgNTkgKysNCj4gICAgICA+wqAgwqB0b29scy9saWIvYnBmL2JwZi5owqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAgMTMgKw0KPiAgICAgID7CoCDCoHRvb2xz
L2xpYi9icGYvbGliYnBmLm1hcMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHzCoCDC
oDQgKw0KPiAgICAgID7CoCDCoC4uLi9tYXBfdGVzdHMvbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2Jh
dGNoLmPCoCDCoHwgMjQ1ICsrKysrKysrDQo+ICAgICAgPsKgIMKgLi4uL21hcF9sb29rdXBfYW5k
X2RlbGV0ZV9iYXRjaF9hcnJheS5jwqAgwqAgwqAgwqB8IDExOCArKysrDQo+ICAgICAgPsKgIMKg
MTEgZmlsZXMgY2hhbmdlZCwgMTI5MiBpbnNlcnRpb25zKCspLCAxMjAgZGVsZXRpb25zKC0pDQo+
ICAgICAgPsKgIMKgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ICAgICB0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvbWFwX3Rlc3RzL21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaC5jDQo+ICAgICAg
PsKgIMKgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ICAgICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvbWFwX3Rlc3RzL21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaF9hcnJheS5jDQo+ICAgICAg
Pg0KPiANCg==
