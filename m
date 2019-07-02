Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A265DA22
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfGCBCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:02:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727239AbfGCBCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:02:03 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62MqkR1019379;
        Tue, 2 Jul 2019 16:02:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7almV7VVmeI2yk5UpMg0+bnh6HRdXgpx0szXIRWRDyE=;
 b=Y8rK9nRPba/X/UaTTrtxJ4ALsdialwVtQzn+GbKJPxxBdOXbw4hzPXfG96bIZI7c85Di
 CYkG+Awo3D157hQ86ligEkRZIAXkHILbXyFE3SLCn+k3qNsbQmufPbJs9TCed30b4iCC
 d1gyBeg8Q6lPmhFcbLfhwSAc8vrtw4bDlqA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tgcr3h4nj-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 16:02:23 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 16:02:19 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 16:02:18 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 16:02:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7almV7VVmeI2yk5UpMg0+bnh6HRdXgpx0szXIRWRDyE=;
 b=gGsnO9C3RNJMSvPfMkwuibFCgF7rxuXbPTOQJAFtSPplOEYb9/2IK0wt/yYlUDjeIFD3hXsDcN8VPMmlM5z24DsD+gHYk2zZO1MSa5wTSaplFFeJczp93vJMHeQQ18r8H8io1aIpt6DA+Z4qMD/w0ik/+6GofKs3CTkFwvq/tW4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2678.namprd15.prod.outlook.com (20.179.156.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 23:02:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 23:02:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Lawrence Brakmo <brakmo@fb.com>, netdev <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next] bpf: Add support for fq's EDT to HBM
Thread-Topic: [PATCH v4 bpf-next] bpf: Add support for fq's EDT to HBM
Thread-Index: AQHVMSLvm1SzAEO44kikeasAAJc/16a38giA
Date:   Tue, 2 Jul 2019 23:02:02 +0000
Message-ID: <7f65050c-6b0d-03ac-1a90-cc052dc7cdb3@fb.com>
References: <20190702220952.3929270-1-brakmo@fb.com>
In-Reply-To: <20190702220952.3929270-1-brakmo@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0022.namprd17.prod.outlook.com
 (2603:10b6:301:14::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8eae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b74847-962c-4a33-bb89-08d6ff414b1c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2678;
x-ms-traffictypediagnostic: BYAPR15MB2678:
x-microsoft-antispam-prvs: <BYAPR15MB2678F4630D47D7D590D06E82D3F80@BYAPR15MB2678.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(366004)(396003)(376002)(199004)(189003)(186003)(256004)(7736002)(6486002)(446003)(53546011)(102836004)(229853002)(2616005)(6512007)(8936002)(11346002)(476003)(4326008)(478600001)(486006)(14444005)(305945005)(52116002)(25786009)(76176011)(110136005)(81156014)(81166006)(54906003)(316002)(53936002)(14454004)(386003)(6436002)(6506007)(6246003)(2906002)(8676002)(99286004)(68736007)(71190400001)(71200400001)(66556008)(64756008)(31696002)(6116002)(66446008)(86362001)(66476007)(66946007)(73956011)(46003)(5660300002)(36756003)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2678;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n5rsc1tfe03FPiDweFEMq803iHw7ak1EmOUi7UkH6fTAO5ba1g0wSagpBjqdec/APRZmWVNg0jIkAu9lkkeSqpsa0Q0+CAIbIzUTBewm8BXIkzE6+1rks4s72xHU4KSZeAwFudx9JL/YT4g6v42FEGadoj3kLn2iqoOjtVTGkQiFknjXfGBmF9OkLUYMDDbZgKYzpBtfztsseHiuWKoPiyTIL/GTD7XpxnsjDqyJPuL3lkL74BdaFHjyGEeOfO4ycUhpfNbg3qRS99TG8DKJq+YpSVo1HSPdBDT0NzLHw7Yzj+klgHgd5Qcu9V05QQAAj7F6Lg0C4ebieRpKgfHaw8ve6hq6Gz4jN1rte9bbDaGBET5iwcihAXHLWEwRpXHTwb9lqJaprMfFYrUnEmChkKQSYxYtdY06jKYZJm+7BUo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD9283E25CEB4A48BB9CD854ADA4F0F9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b74847-962c-4a33-bb89-08d6ff414b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 23:02:02.2951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2678
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020253
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMi8xOSAzOjA5IFBNLCBicmFrbW8gd3JvdGU6DQo+IEFkZHMgc3VwcG9ydCBmb3Ig
ZnEncyBFYXJsaWVzdCBEZXBhcnR1cmUgVGltZSB0byBIQk0gKEhvc3QgQmFuZHdpZHRoDQo+IE1h
bmFnZXIpLiBJbmNsdWRlcyBhIG5ldyBCUEYgcHJvZ3JhbSBzdXBwb3J0aW5nIEVEVCwgYW5kIGFs
c28gdXBkYXRlcw0KPiBjb3JyZXNwb25kaW5nIHByb2dyYW1zLg0KPiANCj4gSXQgd2lsbCBkcm9w
IHBhY2tldHMgd2l0aCBhbiBFRFQgb2YgbW9yZSB0aGFuIDUwMHVzIGluIHRoZSBmdXR1cmUNCj4g
dW5sZXNzIHRoZSBwYWNrZXQgYmVsb25ncyB0byBhIGZsb3cgd2l0aCBsZXNzIHRoYW4gMiBwYWNr
ZXRzIGluIGZsaWdodC4NCj4gVGhpcyBpcyBkb25lIHNvIGVhY2ggZmxvdyBoYXMgYXQgbGVhc3Qg
MiBwYWNrZXRzIGluIGZsaWdodCwgc28gdGhleQ0KPiB3aWxsIG5vdCBzdGFydmUsIGFuZCBhbHNv
IHRvIGhlbHAgcHJldmVudCBkZWxheWVkIEFDSyB0aW1lb3V0cy4NCj4gDQo+IEl0IHdpbGwgYWxz
byB3b3JrIHdpdGggRUNOIGVuYWJsZWQgdHJhZmZpYywgd2hlcmUgdGhlIHBhY2tldHMgd2lsbCBi
ZQ0KPiBDRSBtYXJrZWQgaWYgdGhlaXIgRURUIGlzIG1vcmUgdGhhbiA1MHVzIGluIHRoZSBmdXR1
cmUuDQo+IA0KPiBUaGUgdGFibGUgYmVsb3cgc2hvd3Mgc29tZSBwZXJmb3JtYW5jZSBudW1iZXJz
LiBUaGUgZmxvd3MgYXJlIGJhY2sgdG8NCj4gYmFjayBSUENTLiBPbmUgc2VydmVyIHNlbmRpbmcg
dG8gYW5vdGhlciwgZWl0aGVyIDIgb3IgNCBmbG93cy4NCj4gT25lIGZsb3cgaXMgYSAxMEtCIFJQ
QywgdGhlIHJlc3QgYXJlIDFNQiBSUENzLiBXaGVuIHRoZXJlIGFyZSBtb3JlDQo+IHRoYW4gb25l
IGZsb3cgb2YgYSBnaXZlbiBSUEMgc2l6ZSwgdGhlIG51bWJlcnMgcmVwcmVzZW50IGF2ZXJhZ2Vz
Lg0KPiANCj4gVGhlIHJhdGUgbGltaXQgYXBwbGllcyB0byBhbGwgZmxvd3MgKHRoZXkgYXJlIGlu
IHRoZSBzYW1lIGNncm91cCkuDQo+IFRlc3RzIGVuZGluZyB3aXRoICItZWR0IiByYW4gd2l0aCB0
aGUgbmV3IEJQRiBwcm9ncmFtIHN1cHBvcnRpbmcgRURULg0KPiBUZXN0cyBlbmRpbmcgd2l0aCAi
LWhidCIgcmFuIG9uIHRvcCBIQlQgcWRpc2Mgd2l0aCB0aGUgc3BlY2lmaWVkIHJhdGUNCj4gKGku
ZS4gbm8gSEJNKS4gVGhlIG90aGVyIHRlc3RzIHJhbiB3aXRoIHRoZSBIQk0gQlBGIHByb2dyYW0g
aW5jbHVkZWQNCj4gaW4gdGhlIEhCTSBwYXRjaC1zZXQuDQo+IA0KPiBFRFQgaGFzIGxpbWl0ZWQg
dmFsdWUgd2hlbiB1c2luZyBEQ1RDUCwgYnV0IGl0IGhlbHBzIGluIG1hbnkgY2FzZXMgd2hlbg0K
PiB1c2luZyBDdWJpYy4gSXQgdXN1YWxseSBhY2hpZXZlcyBsYXJnZXIgbGluayB1dGlsaXphdGlv
biBhbmQgbG93ZXINCj4gOTklIGxhdGVuY2llcyBmb3IgdGhlIDFNQiBSUENzLg0KPiBIQk0gZW5k
cyB1cCBxdWV1ZWluZyBhIGxvdCBvZiBwYWNrZXRzIHdpdGggaXRzIGRlZmF1bHQgcGFyYW1ldGVy
IHZhbHVlcywNCj4gcmVkdWNpbmcgdGhlIGdvb2RwdXQgb2YgdGhlIDEwS0IgUlBDcyBhbmQgaW5j
cmVhc2luZyB0aGVpciBsYXRlbmN5LiBBbHNvLA0KPiB0aGUgUlRUcyBzZWVuIGJ5IHRoZSBmbG93
cyBhcmUgcXVpdGUgbGFyZ2UuDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgIEFnZ3Ig
ICAgICAgICAgICAgIDEwSyAgMTBLICAxMEsgICAxTUIgIDFNQiAgMU1CDQo+ICAgICAgICAgICBM
aW1pdCAgICAgICAgICAgcmF0ZSBkcm9wcyAgUlRUICByYXRlICBQOTAgIFA5OSAgcmF0ZSAgUDkw
ICBQOTkNCj4gVGVzdCAgICAgIHJhdGUgIEZsb3dzICAgIE1icHMgICAlICAgICB1cyAgTWJwcyAg
IHVzICAgdXMgIE1icHMgICBtcyAgIG1zDQo+IC0tLS0tLS0tICAtLS0tICAtLS0tLSAgICAtLS0t
IC0tLS0tICAtLS0gIC0tLS0gLS0tLSAtLS0tICAtLS0tIC0tLS0gLS0tLQ0KPiBjdWJpYyAgICAg
ICAxRyAgICAyICAgICAgIDkwNCAgMC4wMiAgMTA4ICAgMjU3ICA1MTEgIDUzOSAgIDY0NyAxMy40
IDI0LjUNCj4gY3ViaWMtZWR0ICAgMUcgICAgMiAgICAgICA5ODIgIDAuMDEgIDE1NiAgIDIzOSAg
NjU2ICA5NjcgICA3NDMgMTQuMCAxNy4yDQo+IGRjdGNwICAgICAgIDFHICAgIDIgICAgICAgOTc3
ICAwLjAwICAxMDUgICAzMjQgIDQwOCAgNzQ0ICAgNjUzIDE0LjUgMTUuOQ0KPiBkY3RjcC1lZHQg
ICAxRyAgICAyICAgICAgIDk4MSAgMC4wMSAgMTQyICAgMzIxICA0MTcgIDgxMSAgIDY2MCAxNS43
IDE3LjANCj4gY3ViaWMtaHRiICAgMUcgICAgMiAgICAgICA5MTkgIDAuMDAgMTgyNSAgICA0MCAy
ODIyIDQxNDAgICA4NzkgIDkuNyAgOS45DQo+IA0KPiBjdWJpYyAgICAgMjAwTSAgICAyICAgICAg
IDE1NSAgMC4zMCAgMjIwICAgIDgxICA1MzIgIDY1NSAgICA3NCAgMjgzICA0NTANCj4gY3ViaWMt
ZWR0IDIwME0gICAgMiAgICAgICAxODggIDAuMDIgIDIyMiAgICA4NyAxMDM1IDEwOTUgICAxMDEg
ICA4NCAgIDg1DQo+IGRjdGNwICAgICAyMDBNICAgIDIgICAgICAgMTg4ICAwLjAzICAxMTEgICAg
NzcgIDkxMiAgOTM5ICAgMTExICAgNzYgIDMyNQ0KPiBkY3RjcC1lZHQgMjAwTSAgICAyICAgICAg
IDE4OCAgMC4wMyAgMjE3ICAgIDc0IDE0MTYgMTczOCAgIDExNCAgIDc2ICAgNzkNCj4gY3ViaWMt
aHRiIDIwME0gICAgMiAgICAgICAxODggIDAuMDAgNTAxNSAgICAgOCAxNG1zIDE1bXMgICAxODAg
ICA0OCAgIDUwDQo+IA0KPiBjdWJpYyAgICAgICAxRyAgICA0ICAgICAgIDk1MiAgMC4wMyAgMTEw
ICAgMTY1ICA1MTYgIDU0NiAgIDI2MiAgIDM4ICAxNTQNCj4gY3ViaWMtZWR0ICAgMUcgICAgNCAg
ICAgICA5NzMgIDAuMDEgIDE5MCAgIDExMSAxMDM0IDEzMTQgICAyODcgICA2NSAgIDc5DQo+IGRj
dGNwICAgICAgIDFHICAgIDQgICAgICAgOTUxICAwLjAwICAxMDMgICAxODAgIDYxNyAgOTA1ICAg
MjU3ICAgMzcgICAzOA0KPiBkY3RjcC1lZHQgICAxRyAgICA0ICAgICAgIDk2NyAgMC4wMCAgMTYz
ICAgMTUxICA3MzIgMTEyNiAgIDI3MiAgIDQzICAgNTUNCj4gY3ViaWMtaHRiICAgMUcgICAgNCAg
ICAgICA5MTQgIDAuMDAgMzI0OSAgICAxMyAgN21zICA4bXMgICAzMDAgICAyOSAgIDM0DQo+IA0K
PiBjdWJpYyAgICAgICA1RyAgICA0ICAgICAgNDIzNiAgMC4wMCAgMTM0ICAgMzA1ICA0OTAgIDYy
NCAgMTMxMCAgIDEwICAgMTcNCj4gY3ViaWMtZWR0ICAgNUcgICAgNCAgICAgIDQ4NjUgIDAuMDAg
IDE1NiAgIDMwNiAgNDI1ICA3NTkgIDE1MjAgICAxMCAgIDE2DQo+IGRjdGNwICAgICAgIDVHICAg
IDQgICAgICA0OTM2ICAwLjAwICAxMjggICA0ODUgIDIyMSAgNDA5ICAxNDg0ICAgIDcgICAgOQ0K
PiBkY3RjcC1lZHQgICA1RyAgICA0ICAgICAgNDkyNCAgMC4wMCAgMTQ4ICAgMzkwICAzOTIgIDYy
MyAgMTUwOCAgIDExICAgMjYNCj4gDQo+IHYxIC0+IHYyOiBJbmNvcnBvcmF0ZWQgQW5kcmlpJ3Mg
c3VnZ2VzdGlvbnMNCj4gdjIgLT4gdjM6IEluY29ycG9yYXRlZCBZb25naG9uZydzIHN1Z2dlc3Rp
b25zDQo+IHYzIC0+IHY0OiBSZW1vdmVkIGNyZWRpdCB1cGRhdGUgdGhhdCBpcyBub3QgbmVlZGVk
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMYXdyZW5jZSBCcmFrbW8gPGJyYWttb0BmYi5jb20+DQoN
CkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
