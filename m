Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06982664
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfHEUx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:53:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22134 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727460AbfHEUx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:53:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Kn32x009801;
        Mon, 5 Aug 2019 13:53:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=92UjBeBqXfOU5fT9n0NQ7OknYqJtp55Kv8J/xGaB8mg=;
 b=YnqsCC1CBf5Qi02gICB5Mz/VgGTCLtRtZ58426MeiYe1h0Fywqr/tW+4rqqejaFQFCKp
 XehPFZR8rUBRbnsknneVaXzpes8HkWoIUYw37RNgnajesvrX40dvTgo/QLM3ZVm0a4Kh
 w8s4s31ib9DomEWd97hVDV3feBtpm7Jcq44= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6tcq0b9n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 13:53:11 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 5 Aug 2019 13:53:09 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 5 Aug 2019 13:53:09 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 5 Aug 2019 13:53:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEBdXZM9ZBNfIkezoS3ewH3R3byJTSS9pvFflaDloKhyIYjw8F/LRcTJGvGDAm+gTg6OmcYQyzc9zjqKomI5HvnICMJ99mrLSrG5CG7XQD/xYaiE7dzUcav9CXSWXbWj/UswhE64SPluOjZ0ip8a8snzNff3L3WlK4U6DAVWJnojnCO7ENE/vHvz1v8/mJaiHRLjgllqw0slo3jum6O4PAmGgCLeHPjKGZeLxlG4unTITjlK9JHDfibAzrwgcXbIYyGsLiGmjidzaaTZe/DMxdR46PU9UQ1O7Rso9KkktJWifqQmX8fGzZmreG/yrMo1wPAuSJGmWRjNe7svsJOSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92UjBeBqXfOU5fT9n0NQ7OknYqJtp55Kv8J/xGaB8mg=;
 b=CKurnJ7gIL0+1NRagB2uGhaH6z/eFnLoaKdDYmS+V6CJ5DeTG4zwA2NwdTJJZ3IQQbcRF8LAHjEzWd6ctvozSZwikyJDCh7UL9CXl0kI1T+VOEMDJpVAUq+xzJz3Kud8Eajv94F0mva2BJVS4lvXbFMC2Rwpdf97KX/VaGe/RtImJ62PQB+/aJV/NcW7pvO+5AztF5oKYcjH6JFsRqXqWwRZvm0NJUtOYx0EUV4mSF50nB9iCQaDwuUsmGQahzjNg9bcVcTSe3k5pRqC0zPhuD8K2bDwWmGw19Hl18Hc5KcK0ZIf47HSj3yOG7QS3KGTl4VAgJDOhGaVwzL/F9aDRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92UjBeBqXfOU5fT9n0NQ7OknYqJtp55Kv8J/xGaB8mg=;
 b=QJZcNhbwhZ42gmHSimLzbXe+7Cc1AeDov3/47KpF4eqCaG/p7M31KObs1afHOmw73CbZkESfLlCSeSc/vbFRSxWPTdeWWyrkgTJNYUABF4jCnvkXnhZe8DkJDAyI9LocBWxZpIEQf9Y+bGK4LkxQLuit9xwK2C975Ez3Tw5xV5s=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2485.namprd15.prod.outlook.com (52.135.194.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 5 Aug 2019 20:53:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288%5]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 20:53:06 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Topic: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Index: AQHVSYrDb/QIQrR8ikOzTWdQvhl3r6bs+ZyAgAAFNYCAAA2lgA==
Date:   Mon, 5 Aug 2019 20:53:06 +0000
Message-ID: <f3ccc18f-7c25-a4e8-3d3d-c9f0bdf453ea@fb.com>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-2-ast@kernel.org>
 <CAEf4Bzb==_gzT78_oN7AfiGHrqGXdYK+oEamkxpfEjP5fzr_UA@mail.gmail.com>
 <db0340a8-a4d7-f652-729d-9edd22a87310@fb.com>
In-Reply-To: <db0340a8-a4d7-f652-729d-9edd22a87310@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:300:95::21) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:8a30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c7ae47a-ddef-4125-bdc3-08d719e6ea36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2485;
x-ms-traffictypediagnostic: BYAPR15MB2485:
x-microsoft-antispam-prvs: <BYAPR15MB2485837B18AD2883ABB0999CD7DA0@BYAPR15MB2485.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(53546011)(305945005)(52116002)(102836004)(31696002)(6506007)(6116002)(76176011)(186003)(99286004)(5660300002)(25786009)(4326008)(46003)(256004)(476003)(386003)(446003)(11346002)(66446008)(66556008)(486006)(110136005)(2616005)(81156014)(86362001)(66476007)(53936002)(64756008)(54906003)(316002)(7736002)(66946007)(8676002)(14454004)(6512007)(6436002)(6246003)(8936002)(6486002)(31686004)(71200400001)(36756003)(71190400001)(478600001)(2906002)(229853002)(81166006)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2485;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ayrhzMUmZ+615ssujDzs4ZUi/6NJqoeuo0XFFZ64lrEfZkKJk3Vh5/omGOdQyR2UhkCnXxRRnLFKOjP9X5OjUIkMgBtNljaMyxxWoMFHpxbfYilHUECmwnbpS/O2/kMGBPF2q/rRswhJQ+SV1JkVoYEJg+Hx3vekCIqG5pblcHKHnHr6VoUub3MEtMxSDksNEx8Xsass7RM63hMxZbv0h4W/2kTnijS5xUZG1zFIVbQgTf69SZ296Tzso5xNPI7si94ZvDbUbqrQeF55cRdFavAsYr7hQSw2hYrlLkOQH9hLnSiQT8LoJ8LYuxV9cZdBjNYOOKa6PXbw1jyyeGaDeN+OmGfSDPIJDjZk3/pZwu3qS986dmN4I65uXG5W8nsOFMCve6pQcVxQ3ob1AcMn6f/mC/PibF97QATGVCQYZd0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22321BFE3D605E4B91B49F75D2FC2109@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7ae47a-ddef-4125-bdc3-08d719e6ea36
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 20:53:06.0711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2485
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050210
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC81LzE5IDE6MDQgUE0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+IA0KPiANCj4gT24gOC81
LzE5IDEyOjQ1IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiBPbiBTYXQsIEF1ZyAzLCAy
MDE5IGF0IDg6MTkgUE0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4gd3JvdGU6
DQo+Pj4NCj4+PiBBZGQgYSB0ZXN0IHRoYXQgcmV0dXJucyBhICdyYW5kb20nIG51bWJlciBiZXR3
ZWVuIFswLCAyXjIwKQ0KPj4+IElmIHN0YXRlIHBydW5pbmcgaXMgbm90IHdvcmtpbmcgY29ycmVj
dGx5IGZvciBsb29wIGJvZHkgdGhlIG51bWJlciBvZg0KPj4+IHByb2Nlc3NlZCBpbnNucyB3aWxs
IGJlIDJeMjAgKiBudW1fb2ZfaW5zbnNfaW5fbG9vcF9ib2R5IGFuZCB0aGUgcHJvZ3JhbQ0KPj4+
IHdpbGwgYmUgcmVqZWN0ZWQuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92
b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPj4+IC0tLQ0KPj4+ICAgIC4uLi9icGYvcHJvZ190ZXN0
cy9icGZfdmVyaWZfc2NhbGUuYyAgICAgICAgICB8ICAxICsNCj4+PiAgICB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ3MvbG9vcDQuYyAgICAgfCAyMyArKysrKysrKysrKysrKysrKysr
DQo+Pj4gICAgMiBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspDQo+Pj4gICAgY3JlYXRl
IG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9sb29wNC5jDQo+
Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVz
dHMvYnBmX3ZlcmlmX3NjYWxlLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190
ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KPj4+IGluZGV4IGI0YmU5NjE2MmZmNC4uNzU3ZTM5NTQw
ZWRhIDEwMDY0NA0KPj4+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rl
c3RzL2JwZl92ZXJpZl9zY2FsZS5jDQo+Pj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL3Byb2dfdGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMNCj4+PiBAQCAtNzEsNiArNzEsNyBAQCB2
b2lkIHRlc3RfYnBmX3ZlcmlmX3NjYWxlKHZvaWQpDQo+Pj4NCj4+PiAgICAgICAgICAgICAgICAg
ICB7ICJsb29wMS5vIiwgQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVCB9LA0KPj4+ICAgICAg
ICAgICAgICAgICAgIHsgImxvb3AyLm8iLCBCUEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UIH0s
DQo+Pj4gKyAgICAgICAgICAgICAgIHsgImxvb3A0Lm8iLCBCUEZfUFJPR19UWVBFX1JBV19UUkFD
RVBPSU5UIH0sDQo+Pj4NCj4+PiAgICAgICAgICAgICAgICAgICAvKiBwYXJ0aWFsIHVucm9sbC4g
MTlrIGluc24gaW4gYSBsb29wLg0KPj4+ICAgICAgICAgICAgICAgICAgICAqIFRvdGFsIHByb2dy
YW0gc2l6ZSAyMC44ayBpbnNuLg0KPj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvcHJvZ3MvbG9vcDQuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9sb29wNC5jDQo+Pj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+PiBpbmRleCAwMDAwMDAwMDAw
MDAuLjNlN2VlMTRmZGRiZA0KPj4+IC0tLSAvZGV2L251bGwNCj4+PiArKysgYi90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvbG9vcDQuYw0KPj4+IEBAIC0wLDAgKzEsMjMgQEANCj4+
PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+PiArLy8gQ29weXJpZ2h0
IChjKSAyMDE5IEZhY2Vib29rDQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPg0KPj4+ICsj
aW5jbHVkZSA8bGludXgvcHRyYWNlLmg+DQo+Pj4gKyNpbmNsdWRlIDxzdGRpbnQuaD4NCj4+PiAr
I2luY2x1ZGUgPHN0ZGRlZi5oPg0KPj4+ICsjaW5jbHVkZSA8c3RkYm9vbC5oPg0KPj4+ICsjaW5j
bHVkZSA8bGludXgvYnBmLmg+DQo+Pj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5oIg0KPj4+ICsN
Cj4+PiArY2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIpID0gIkdQTCI7DQo+Pj4gKw0KPj4+
ICtTRUMoInNvY2tldCIpDQo+Pj4gK2ludCBjb21iaW5hdGlvbnModm9sYXRpbGUgc3RydWN0IF9f
c2tfYnVmZiogc2tiKQ0KPj4+ICt7DQo+Pj4gKyAgICAgICBpbnQgcmV0ID0gMCwgaTsNCj4+PiAr
DQo+Pj4gKyNwcmFnbWEgbm91bnJvbGwNCj4+PiArICAgICAgIGZvciAoaSA9IDA7IGkgPCAyMDsg
aSsrKQ0KPj4+ICsgICAgICAgICAgICAgICBpZiAoc2tiLT5sZW4pDQo+Pj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcmV0IHw9IDEgPDwgaTsNCj4+DQo+PiBTbyBJIHRoaW5rIHRoZSBpZGVhIGlz
IHRoYXQgYmVjYXVzZSB2ZXJpZmllciBzaG91bGRuJ3Qga25vdyB3aGV0aGVyDQo+PiBza2ItPmxl
biBpcyB6ZXJvIG9yIG5vdCwgdGhlbiB5b3UgaGF2ZSB0d28gb3V0Y29tZXMgb24gZXZlcnkgaXRl
cmF0aW9uDQo+PiBsZWFkaW5nIHRvIDJeMjAgc3RhdGVzLCByaWdodD8NCj4+DQo+PiBCdXQgSSdt
IGFmcmFpZCB0aGF0IHZlcmlmaWVyIGNhbiBldmVudHVhbGx5IGJlIHNtYXJ0IGVub3VnaCAoaWYg
aXQncw0KPj4gbm90IGFscmVhZHksIGJ0dyksIHRvIGZpZ3VyZSBvdXQgdGhhdCByZXQgY2FuIGJl
IGVpdGhlciAwIG9yICgoMSA8PA0KPj4gMjEpIC0gMSksIGFjdHVhbGx5LiBJZiBza2ItPmxlbiBp
cyBwdXQgaW50byBzZXBhcmF0ZSByZWdpc3RlciwgdGhlbg0KPj4gdGhhdCByZWdpc3RlcidzIGJv
dW5kcyB3aWxsIGJlIGVzdGFibGlzaGVkIG9uIGZpcnN0IGxvb3AgaXRlcmF0aW9uIGFzDQo+PiBl
aXRoZXIgPT0gMCBvbiBvbmUgYnJhbmNoIG9yICgwLCBpbmYpIG9uIGFub3RoZXIgYnJhbmNoLCBh
ZnRlciB3aGljaA0KPj4gYWxsIHN1YnNlcXVlbnQgaXRlcmF0aW9ucyB3aWxsIG5vdCBicmFuY2gg
YXQgYWxsIChvbmUgb3IgdGhlIG90aGVyDQo+PiBicmFuY2ggd2lsbCBiZSBhbHdheXMgdGFrZW4p
Lg0KPj4NCj4+IEl0J3MgYWxzbyBwb3NzaWJsZSB0aGF0IExMVk0vQ2xhbmcgaXMgc21hcnQgZW5v
dWdoIGFscmVhZHkgdG8gZmlndXJlDQo+PiB0aGlzIG91dCBvbiBpdHMgb3duIGFuZCBvcHRpbWl6
ZSBsb29wIGludG8uDQo+Pg0KPj4NCj4+IGlmIChza2ItPmxlbikgew0KPj4gICAgICAgZm9yIChp
ID0gMDsgaSA8IDIwOyBpKyspDQo+PiAgICAgICAgICAgcmV0IHw9IDEgPDwgaTsNCj4+IH0NCj4g
DQo+IFdlIGhhdmUNCj4gICAgICB2b2xhdGlsZSBzdHJ1Y3QgX19za19idWZmKiBza2INCj4gDQo+
IFNvIGZyb20gdGhlIHNvdXJjZSBjb2RlLCBza2ItPmxlbiBjb3VsZCBiZSBkaWZmZXJlbnQgZm9y
IGVhY2gNCj4gaXRlcmF0aW9uLiBUaGUgY29tcGlsZXIgY2Fubm90IGRvIHRoZSBhYm92ZSBvcHRp
bWl6YXRpb24uDQoNCnllcC4NCldpdGhvdXQgdm9sYXRpbGUgbGx2bSBvcHRpbWl6ZXMgaXQgZXZl
biBtb3JlIHRoYW4gQW5kcmlpIHByZWRpY3RlZCA6KQ0KDQo+Pg0KPj4NCj4+IFNvIHR3byBjb21w
bGFpbnM6DQo+Pg0KPj4gMS4gTGV0J3Mgb2JmdXNjYXRlIHRoaXMgYSBiaXQgbW9yZSwgZS5nLiwg
d2l0aCB0ZXN0aW5nIChza2ItPmxlbiAmDQo+PiAoMTw8aSkpIGluc3RlYWQsIHNvIHRoYXQgcmVz
dWx0IHJlYWxseSBkZXBlbmRzIG9uIGFjdHVhbCBsZW5ndGggb2YgdGhlDQo+PiBwYWNrZXQuDQo+
PiAyLiBJcyBpdCBwb3NzaWJsZSB0byBzb21laG93IHR1cm4gb2ZmIHRoaXMgcHJlY2lzaW9uIHRy
YWNraW5nIChlLmcuLA0KPj4gcnVubmluZyBub3QgdW5kZXIgcm9vdCwgbWF5YmU/KSBhbmQgc2Vl
IHRoYXQgdGhpcyBzYW1lIHByb2dyYW0gZmFpbHMNCj4+IGluIHRoYXQgY2FzZT8gVGhhdCB3YXkg
d2UnbGwga25vdyB0ZXN0IGFjdHVhbGx5IHZhbGlkYXRlcyB3aGF0IHdlDQo+PiB0aGluayBpdCB2
YWxpZGF0ZXMuDQoNCnRoYXQncyBvbiBteSB0b2RvIGxpc3QgYWxyZWFkeS4NClRvIGRvIHByb3Bl
ciB1bml0IHRlc3RzIGZvciBhbGwgdGhpcyBzdHVmZiB0aGVyZSBzaG91bGQgYmUgYSB3YXkNCnRv
IHR1cm4gb2ZmIG5vdCBvbmx5IHByZWNpc2lvbiwgYnV0IGhldXJpc3RpY3MgdG9vLg0KQWxsIG1h
Z2ljIG51bWJlcnMgaW4gaXNfc3RhdGVfdmlzaXRlZCgpIG5lZWQgdG8gYmUgc3dpdGNoYWJsZS4N
CkknbSBzdGlsbCB0aGlua2luZyBvbiB0aGUgd2F5IHRvIGV4cG9zZSBpdCB0byB0ZXN0cyBpbmZy
YS4NCg==
