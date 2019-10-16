Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E15DA27A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391546AbfJPXwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:52:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35570 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728701AbfJPXwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:52:21 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GNm519030829;
        Wed, 16 Oct 2019 16:52:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cdnGgw+TRSmlmNEyggJfLxV+ncZJ3CjJADRiFguB53c=;
 b=bgBd6IuyQBfCFml07xLeV1EBcnmvg//qVMpQphxm+8l3mew82CEDE5TnFgCop72Imo66
 eKrAMEgeyOmnBdqKEweF0fT/X5It8aErK2D4QhIA9nBWfmlJlNSNXkrc5UddYlUXGtpj
 4IouSf4nsM0pJoHVLKg4W4WRBCyk/7EJj+4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnfbc0ck5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Oct 2019 16:52:05 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 16:52:04 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Oct 2019 16:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WITlkStJ+W2lCFoyKl8xPpLxSpTlibVtsASIcmrAu6+FkFxS8/YVxlBAeUaQtOGvLUrBkOxk8O3vfL172+CTenliHvsRgWOLnihFGo0ZAvaFlcJaMgyMccfJjZr0uSYasPviWIqQNKHng9OzGRsgqSmtvYpcK1oz0w3ExjfrcsZRWPqwxMYiwgLDk5uRdlVx8QjvfEBv2582y0oINKRmIFp0M/gXK51cULTKwvG2daXk8PGS6KRZF9pjHUaKC66+QwKbytsSlflkheCyCr7x+sYzJWuPw9E5ESzIBmZ8gGk/MvPnlePkaooOkKrOzb03/s14HsqgkjJRgfN1Y2SfrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdnGgw+TRSmlmNEyggJfLxV+ncZJ3CjJADRiFguB53c=;
 b=jFp7+6uiFZvJuFkVn4vKrTWECoEkvsmgmeJ7OnELsgr6jW/nvD0t0Ube7rUCKkz75+oPhnNQVKSXI6yums+tpL/scqjv4hsUGl7k3NTntuC0pTL7t2N0MsZki1Dm1hEKsPGItQMSue3eu/ZLVkR1nNelOtwyb0iXXPELwSk+Js3QY/jVGgDA/3Yc7KgTuW+QkJwoh7LprPKqMcJfPzdzACvxMQ/XLcXhGD6AfWjof7Enn28dc8EP2TV3ppICRIUv/B4VOZSGK3qdwNBrE7A36sSOrGHMF4ShYWz/o1PwuCX2QK+cNb6VcZSoSN5JbbAzW0jC8SnMVErt3WqNcssQsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdnGgw+TRSmlmNEyggJfLxV+ncZJ3CjJADRiFguB53c=;
 b=bDIzU1ngr3CkvCjmax/SSLnUE1HSZOhVaHm7XwA6JUPjsSwyzZyaRnoDXSnc6lWccY5BfM6VbIZFhwJKHMA6iMQEizjf5l8mumjtcC2K1sSKgbluxXF5p05TpyP9sY3iPbAo9VNLJ3qdpvoRBEyWy9MIvzW7kv/YNTu+i8LVJTg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2565.namprd15.prod.outlook.com (20.179.155.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Wed, 16 Oct 2019 23:52:02 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 23:52:02 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context
 access via BTF
Thread-Topic: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context
 access via BTF
Thread-Index: AQHVg9FyCA6/hSjOr02AyGwXDVpZ9Kddx9eAgAABsQCAAAtIgIAAHPKA
Date:   Wed, 16 Oct 2019 23:52:02 +0000
Message-ID: <543e4e69-ecc6-835b-7634-4c7d60d2c06d@fb.com>
References: <20191016032505.2089704-1-ast@kernel.org>
 <20191016032505.2089704-7-ast@kernel.org>
 <04fab556-9eda-87ec-8f8c-defcab25a80e@iogearbox.net>
 <CAADnVQLry-vV_nNUFNaWtO_iFPfvq5-vpqiONHq6r0_6pVt26g@mail.gmail.com>
 <bb504159-48b1-93fc-8c38-5cef6b36e4d1@iogearbox.net>
In-Reply-To: <bb504159-48b1-93fc-8c38-5cef6b36e4d1@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:101:1f::20) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e4fe581-182c-48d7-a42c-08d75293d753
x-ms-traffictypediagnostic: BYAPR15MB2565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2565C76B5B8E52B92B21F589D7920@BYAPR15MB2565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(66476007)(5024004)(31686004)(256004)(14444005)(186003)(66946007)(66446008)(8676002)(76176011)(2906002)(36756003)(6436002)(52116002)(4326008)(81166006)(6506007)(316002)(102836004)(66556008)(53546011)(81156014)(99286004)(110136005)(386003)(54906003)(476003)(25786009)(86362001)(64756008)(305945005)(486006)(7736002)(6486002)(2616005)(6246003)(11346002)(31696002)(446003)(46003)(6512007)(71190400001)(71200400001)(229853002)(478600001)(5660300002)(14454004)(6116002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2565;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DRHPlbF9rJOOWbRLM9MAFDqBOpI1rMJlJbXJsnMCmjxB0PFyMYkrlY8U0nGdPMDre5rmmGQQkHYQKMzSw9UbnTSXtaAVPjTzavS5Jcq1kfjU+a79Ae4qITag0mWr6BducdpH3jhlo6MiWvbwTypnALS5BIBO/MAVfANhnXklJJZaE3loCux0sZz4W5Wiq+GcPGSYmgK63YrhX4AikRlUzQ6mzQVkL+N13hUDyQ69Wgo1DX26NlCRop7hnjZo1k8xUXkYKBZ+aDqxzxXvRGjoCtQmfl46GvdEzQctKlywD4SkPPws8Jhr+tHl4ykaXhMPjSEufe/Rq62g29KH52YgU5ucrwtpZs9ZFK7il8b/J86ynv3g0p+uWmn/hIrJuxezXpvBsBnQprMRTy7G6XvCxvPOCPQfux6ls5bTCwwKRqE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88E9E1811A90344A824E9B61211253EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4fe581-182c-48d7-a42c-08d75293d753
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 23:52:02.4726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1OMQjkF+JSrs8kKhrBprmLM4DJPh2WdkaonHpi2PmGwqhCXQIWZoZFD584pWSrw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160196
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTYvMTkgMzowOCBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAxMC8xNi8x
OSAxMToyOCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gT24gV2VkLCBPY3QgMTYs
IDIwMTkgYXQgMjoyMiBQTSBEYW5pZWwgQm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PiAN
Cj4+IHdyb3RlOg0KPj4+IE9uIDEwLzE2LzE5IDU6MjUgQU0sIEFsZXhlaSBTdGFyb3ZvaXRvdiB3
cm90ZToNCj4+Pj4gbGliYnBmIGFuYWx5emVzIGJwZiBDIHByb2dyYW0sIHNlYXJjaGVzIGluLWtl
cm5lbCBCVEYgZm9yIGdpdmVuIHR5cGUgDQo+Pj4+IG5hbWUNCj4+Pj4gYW5kIHN0b3JlcyBpdCBp
bnRvIGV4cGVjdGVkX2F0dGFjaF90eXBlLg0KPj4+PiBUaGUga2VybmVsIHZlcmlmaWVyIGV4cGVj
dHMgdGhpcyBidGZfaWQgdG8gcG9pbnQgdG8gc29tZXRoaW5nIGxpa2U6DQo+Pj4+IHR5cGVkZWYg
dm9pZCAoKmJ0Zl90cmFjZV9rZnJlZV9za2IpKHZvaWQgKiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwg
DQo+Pj4+IHZvaWQgKmxvYyk7DQo+Pj4+IHdoaWNoIHJlcHJlc2VudHMgc2lnbmF0dXJlIG9mIHJh
d190cmFjZXBvaW50ICJrZnJlZV9za2IiLg0KPj4+Pg0KPj4+PiBUaGVuIGJ0Zl9jdHhfYWNjZXNz
KCkgbWF0Y2hlcyBjdHgrMCBhY2Nlc3MgaW4gYnBmIHByb2dyYW0gd2l0aCAnc2tiJw0KPj4+PiBh
bmQgJ2N0eCs4JyBhY2Nlc3Mgd2l0aCAnbG9jJyBhcmd1bWVudHMgb2YgImtmcmVlX3NrYiIgdHJh
Y2Vwb2ludC4NCj4+Pj4gSW4gZmlyc3QgY2FzZSBpdCBwYXNzZXMgYnRmX2lkIG9mICdzdHJ1Y3Qg
c2tfYnVmZiAqJyBiYWNrIHRvIHRoZSANCj4+Pj4gdmVyaWZpZXIgY29yZQ0KPj4+PiBhbmQgJ3Zv
aWQgKicgaW4gc2Vjb25kIGNhc2UuDQo+Pj4+DQo+Pj4+IFRoZW4gdGhlIHZlcmlmaWVyIHRyYWNr
cyBQVFJfVE9fQlRGX0lEIGFzIGFueSBvdGhlciBwb2ludGVyIHR5cGUuDQo+Pj4+IExpa2UgUFRS
X1RPX1NPQ0tFVCBwb2ludHMgdG8gJ3N0cnVjdCBicGZfc29jaycsDQo+Pj4+IFBUUl9UT19UQ1Bf
U09DSyBwb2ludHMgdG8gJ3N0cnVjdCBicGZfdGNwX3NvY2snLCBhbmQgc28gb24uDQo+Pj4+IFBU
Ul9UT19CVEZfSUQgcG9pbnRzIHRvIGluLWtlcm5lbCBzdHJ1Y3RzLg0KPj4+PiBJZiAxMjM0IGlz
IGJ0Zl9pZCBvZiAnc3RydWN0IHNrX2J1ZmYnIGluIHZtbGludXgncyBCVEYNCj4+Pj4gdGhlbiBQ
VFJfVE9fQlRGX0lEIzEyMzQgcG9pbnRzIHRvIG9uZSBvZiBpbiBrZXJuZWwgc2ticy4NCj4+Pj4N
Cj4+Pj4gV2hlbiBQVFJfVE9fQlRGX0lEIzEyMzQgaXMgZGVyZWZlcmVuY2VkIChsaWtlIHIyID0g
Kih1NjQgKilyMSArIDMyKQ0KPj4+PiB0aGUgYnRmX3N0cnVjdF9hY2Nlc3MoKSBjaGVja3Mgd2hp
Y2ggZmllbGQgb2YgJ3N0cnVjdCBza19idWZmJyBpcw0KPj4+PiBhdCBvZmZzZXQgMzIuIENoZWNr
cyB0aGF0IHNpemUgb2YgYWNjZXNzIG1hdGNoZXMgdHlwZSBkZWZpbml0aW9uDQo+Pj4+IG9mIHRo
ZSBmaWVsZCBhbmQgY29udGludWVzIHRvIHRyYWNrIHRoZSBkZXJlZmVyZW5jZWQgdHlwZS4NCj4+
Pj4gSWYgdGhhdCBmaWVsZCB3YXMgYSBwb2ludGVyIHRvICdzdHJ1Y3QgbmV0X2RldmljZScgdGhl
IHIyJ3MgdHlwZQ0KPj4+PiB3aWxsIGJlIFBUUl9UT19CVEZfSUQjNDU2LiBXaGVyZSA0NTYgaXMg
YnRmX2lkIG9mICdzdHJ1Y3QgbmV0X2RldmljZScNCj4+Pj4gaW4gdm1saW51eCdzIEJURi4NCj4+
Pj4NCj4+Pj4gU3VjaCB2ZXJpZmllciBhbmFseXNpcyBwcmV2ZW50cyAiY2hlYXRpbmciIGluIEJQ
RiBDIHByb2dyYW0uDQo+Pj4+IFRoZSBwcm9ncmFtIGNhbm5vdCBjYXN0IGFyYml0cmFyeSBwb2lu
dGVyIHRvICdzdHJ1Y3Qgc2tfYnVmZiAqJw0KPj4+PiBhbmQgYWNjZXNzIGl0LiBDIGNvbXBpbGVy
IHdvdWxkIGFsbG93IHR5cGUgY2FzdCwgb2YgY291cnNlLA0KPj4+PiBidXQgdGhlIHZlcmlmaWVy
IHdpbGwgbm90aWNlIHR5cGUgbWlzbWF0Y2ggYmFzZWQgb24gQlBGIGFzc2VtYmx5DQo+Pj4+IGFu
ZCBpbi1rZXJuZWwgQlRGLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92
b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPj4+DQo+Pj4gT3ZlcmFsbCBzZXQgbG9va3MgZ3JlYXQh
DQo+Pj4NCj4+PiBbLi4uXQ0KPj4+PiAraW50IGJ0Zl9zdHJ1Y3RfYWNjZXNzKHN0cnVjdCBicGZf
dmVyaWZpZXJfbG9nICpsb2csDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgY29uc3Qgc3RydWN0IGJ0Zl90eXBlICp0LCBpbnQgb2ZmLCBpbnQgc2l6ZSwNCj4+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbnVtIGJwZl9hY2Nlc3NfdHlw
ZSBhdHlwZSwNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1MzIg
Km5leHRfYnRmX2lkKQ0KPj4+PiArew0KPj4+PiArwqDCoMKgwqAgY29uc3Qgc3RydWN0IGJ0Zl9t
ZW1iZXIgKm1lbWJlcjsNCj4+Pj4gK8KgwqDCoMKgIGNvbnN0IHN0cnVjdCBidGZfdHlwZSAqbXR5
cGU7DQo+Pj4+ICvCoMKgwqDCoCBjb25zdCBjaGFyICp0bmFtZSwgKm1uYW1lOw0KPj4+PiArwqDC
oMKgwqAgaW50IGksIG1vZmYgPSAwLCBtc2l6ZTsNCj4+Pj4gKw0KPj4+PiArYWdhaW46DQo+Pj4+
ICvCoMKgwqDCoCB0bmFtZSA9IF9fYnRmX25hbWVfYnlfb2Zmc2V0KGJ0Zl92bWxpbnV4LCB0LT5u
YW1lX29mZik7DQo+Pj4NCj4+PiBNb3JlIG9mIGEgaGlnaC1sZXZlbCBxdWVzdGlvbiB3cnQgYnRm
X2N0eF9hY2Nlc3MoKSwgaXMgdGhlcmUgYSByZWFzb24gDQo+Pj4gdGhlIGN0eA0KPj4+IGFjY2Vz
cyBpcyBvbmx5IGRvbmUgZm9yIHJhd190cD8gSSBwcmVzdW1lIGtwcm9iZXMgaXMgc3RpbGwgb24g
dG9kbyANCj4+PiAoPyksIHdoYXQNCj4+PiBhYm91dCB1cHJvYmVzIHdoaWNoIGFsc28gaGF2ZSBw
dF9yZWdzIGFuZCBjb3VsZCBiZW5lZml0IGZyb20gdGhpcyANCj4+PiB3b3JrLCBidXQgaXMNCj4+
PiBub3QgZml4ZWQgdG8gYnRmX3ZtbGludXggdG8gc2VhcmNoIGl0cyBjdHggdHlwZS4NCj4+DQo+
PiBPcHRpbWl6ZWQga3Byb2JlcyB2aWEgZnRyYWNlIGVudHJ5IHBvaW50IGFyZSBvbiBpbW1lZGlh
dGUgdG9kbyBsaXN0DQo+PiB0byBmb2xsb3cgdXAuIEknbSBzdGlsbCBkZWJhdGluZyBvbiB0aGUg
YmVzdCB3YXkgdG8gaGFuZGxlIGl0Lg0KPj4gdXByb2JlcyAtIEkgaGF2ZW4ndCB0aG91Z2ggYWJv
dXQuIExpa2VseSBuZWNlc3NhcnkgYXMgd2VsbC4NCj4+IE5vdCBzdXJlIHdoYXQgdHlwZXMgdG8g
Z2l2ZSB0byBwdF9yZWdzIHlldC4NCj4+DQo+Pj4gSSBwcmVzdW1lIEJQRl9MRFggfCBCUEZfUFJP
QkVfTUVNIHwgQlBGXyogd291bGQgbmVlZCBubyBhZGRpdGlvbmFsIA0KPj4+IGVuY29kaW5nLA0K
Pj4+IGJ1dCBKSVQgZW1pc3Npb24gd291bGQgaGF2ZSB0byBkaWZmZXIgZGVwZW5kaW5nIG9uIHRo
ZSBwcm9nIHR5cGUuDQo+Pg0KPj4geW91IG1lYW4gZm9yIGtwcm9iZXMvdXByb2Jlcz8gV2h5IHdv
dWxkIGl0IG5lZWQgdG8gYmUgZGlmZmVyZW50Pw0KPj4gVGhlIGlkZWEgd2FzIHRvIGtlZXAgTERY
fFBST0JFX01FTSBhcyBub3JtYWwgTERYfE1FTSBsb2FkIGFzIG11Y2ggYXMgDQo+PiBwb3NzaWJs
ZS4NCj4gDQo+IEFncmVlLCBtYWtlcyBzZW5zZS4NCj4gDQo+PiBUaGUgb25seSBkaWZmZXJlbmNl
IHZzIG5vcm1hbCBsb2FkIGlzIHRvIHBvcHVsYXRlIGV4dGFibGUgd2hpY2ggaXMNCj4+IGFyY2gg
ZGVwZW5kZW50Lg0KPiANCj4gV291bGRuJ3QgeW91IGFsc28gbmVlZCB0byBzd2l0Y2ggdG8gVVNF
Ul9EUyBzaW1pbGFybHkgdG8gd2hhdCANCj4gcHJvYmVfa2VybmVsX3JlYWQoKQ0KPiB2cyBwcm9i
ZV91c2VyX3JlYWQoKSBkaWZmZXJlbnRpYXRlcz8NCg0KTm8uIEkgZG9uJ3QgdGhpbmsgd2Ugc2hv
dWxkLg0KSGVyZSB3ZSdyZSByZWFkaW5nIG9ubHkga2VybmVsIG1lbW9yeSBhbmQgc2hvdWxkbid0
IGJlDQptZXNzaW5nIHdpdGggYWRkcl9saW1pdC4NCk5vIHN0YWMvY2xhYyBhbmQgbm8gYWNjZXNz
X29rKCkgZWl0aGVyLg0KSXQncyBrZXJuZWwgbWVtb3J5IGJlaW5nIHJlYWQuDQpzZXRfZnMoS0VS
TkVMX0RTKSBtYXR0ZXJzIHdoZW4gYWNjZXNzX29rKCkgYW5kIGdldHVzZXIoKQ0KYXJlIHVzZWQg
YnkgY2FsbGVlIHRoYXQgbm9ybWFsbHkgdGFrZSB1c2VyIGFkZHJlc3MNCndoaWxlIGNhbGxlciBp
cyBwYXNzaW5nIGtlcm5lbCBhZGRyZXNzLg0KSGVyZSBpcyBubyBzdWNoIHRoaW5nLg0KDQo=
