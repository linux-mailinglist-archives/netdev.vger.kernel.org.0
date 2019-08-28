Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC25A0BE8
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfH1UyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:54:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbfH1UyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:54:14 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SKs2xJ006342;
        Wed, 28 Aug 2019 13:54:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cB7hDooE7gQeOytA3XQRrHajMJb0aGbxWrTxSaBet3w=;
 b=ka5zJaWZxg2m8VAyQuhBxgKLiFS/ZQnmK9jxHKYwiizhsfJ/wlPkuQrScpHqZjRa8wUC
 uA8+Z75+y8cmbwNCXZ34ydSLgE0b9AqBnVZOYKnwvxDLAOvAyI/uWrRTuNuE0LEdcfKE
 g50MCrlqzbuPviEfrcwYnS5rL8KKSB7iGdI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0j636-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 13:54:09 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 13:53:27 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 13:53:26 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 28 Aug 2019 13:53:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt1CTBxEmWYxDrfsACJUmgkS4g8o9WESt5gHYliqgP178GW6CQHTO1Wp+hqvueiTKZ1icaSmIaOSdmJQx+F0mtuiwi5WLYReUqOk/FQT4K3gaz8qjz94V5STprWQ7ucHpsJNcptMOwxbZLvixxlBjTaVgaWMWUeX5ic6odKLyzKO7To9bfXe5iKKCCgstzGaK2TS0mq5v0SlYWDgFMo0/BA9LW1M8OohILoQ/R765gbqzymWx2Px9kVI+qJ7zjjBoo0/SeGDtd+YinH8IeZIlvxVMbEx6IaQVtyGEgusmwsArEWe4PHp1q9oHlr/IxAnhMHWvxBLsD3cf3NsYJ0EIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cB7hDooE7gQeOytA3XQRrHajMJb0aGbxWrTxSaBet3w=;
 b=Mt/lQlM6nD291MwrT5Y1vTmMTpZabSF3Z6tkxut7nbz9jbTSxXVQYVN8TDDTbD3JnAE1ffzYi5TfnWym3q2Gf3Ea4eVlS8aVFlz9u4FVM7DFHp2JwXdmztoOxY4NkhnhK4FpPc8hdoc5kd5+QKdxVTlsuflL/NTHu0BzMAeXnx3C8hZ12of0fQZ57Dn/14s0/CWkR+C7paR1HrNwoSvVjUSy7ArdvwJYX/WRmXAZQaXROuy/ydkf7tK6epIo1DZcQUHawvtOZpoXZblgoACiZNY2Y61TP/NW1w0Hkjb14VLYn4yAI75vp+2CCWF9jmWvDfxKNktCFFeUD+W3JdSuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cB7hDooE7gQeOytA3XQRrHajMJb0aGbxWrTxSaBet3w=;
 b=fAh0OthlSxbV/qLouYnM+wyiDiifyyVqNTRreKBojM057XJYP7pqqlB2ItyK8BGgQip6cNrOX5zbL7dBUoY91BRM5n9oXR3iC+I0dweePAM82a8ZrgbyUsp0Wkoe/xsykYwUuZT9QD110pktPDqeAZ5ZQG89WqtjGClC7af0P/Q=
Received: from BN8PR15MB3380.namprd15.prod.outlook.com (20.179.76.22) by
 BN8PR15MB2964.namprd15.prod.outlook.com (20.178.220.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 20:53:25 +0000
Received: from BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::2d0f:9000:f400:8732]) by BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::2d0f:9000:f400:8732%7]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 20:53:25 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Topic: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Index: AQHVUgen0TRJjFwMbUCsjzJfHVP59ab5P2KAgACSqQCAAEGFAIAXCgt7gAADlwA=
Date:   Wed, 28 Aug 2019 20:53:25 +0000
Message-ID: <4faeb577-387a-7186-e060-f0ca76395823@fb.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
 <20190814005604.yeqb45uv2fc3anab@dev00>
 <9a2cacad-b79f-5d39-6d62-bb48cbaaac07@fb.com>
 <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
 <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
In-Reply-To: <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0047.namprd20.prod.outlook.com
 (2603:10b6:300:ed::33) To BN8PR15MB3380.namprd15.prod.outlook.com
 (2603:10b6:408:a8::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::a6a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6461320-05d4-4680-5f27-08d72bf9c53c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB2964;
x-ms-traffictypediagnostic: BN8PR15MB2964:
x-microsoft-antispam-prvs: <BN8PR15MB2964FAA557452A093B054120D3A30@BN8PR15MB2964.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(51914003)(52314003)(199004)(189003)(52116002)(66476007)(8676002)(46003)(5660300002)(66556008)(66946007)(25786009)(66446008)(8936002)(64756008)(6116002)(4326008)(53936002)(5024004)(6436002)(86362001)(6486002)(31696002)(486006)(316002)(11346002)(6246003)(71200400001)(2616005)(478600001)(6512007)(31686004)(14454004)(446003)(229853002)(54906003)(2906002)(81156014)(256004)(305945005)(76176011)(386003)(6506007)(186003)(99286004)(36756003)(53546011)(81166006)(14444005)(476003)(1411001)(71190400001)(6916009)(7736002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2964;H:BN8PR15MB3380.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1Czu+sumI8xUpGp9i2LeDLaQWiX6ulrIdWYek6C6IeLoNA4ssVWyamaKX6fkc9pfvn9ZcV1lo6/wqeUrCTXWzG/NCtgraAm9JR5qr89FTPTzdGDHOGRSY84crwhUz21i2bGI3Kl5ahNSTGySrvqywDMuaOLxbuTHfS6pkMXtO4ahl+wKPBbUSoy5hk1kgoqvsiQPukuwBVEOd0Rl1GAFOjr3brH3QRvhzxZFM/ExjhPCVyqAr0JTIdROECD+bj3bgHRgMpyGtAkB0AglRhEgztVtf/hfMLyiN1lqi05hns7ogzs/eZwbpQdqJ2P5PRRMXMMmd9R1HJo/8lTGpXHDZ8RaAZkLDZTDKuvarfqQ5VrH3MlDQHWOPSPyfhqT5pmgjUxU4LNWA2AHukHrTlzyPLFensLK2/r9oYzaK+LHSJ4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0AF444AAEBD664190E2C16177AB680B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6461320-05d4-4680-5f27-08d72bf9c53c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 20:53:25.4612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5tGcPyGYlPKJOrhgOAI/LbMuElqQfxp23UNmuC0rGSmT3hqkZNCanwIQv0vvg9i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2964
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908280203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjgvMTkgMTozOSBQTSwgQ2FybG9zIEFudG9uaW8gTmVpcmEgQnVzdG9zIHdyb3Rl
Og0KPiBZb25naG9uZywNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHBvaW50ZXIsIEkgZml4ZWQgdGhp
cyBidWcsIGJ1dCBJIGZvdW5kIGFub3RoZXIgb25lIHRoYXQncyB0cmlnZ2VyZWQNCj4gbm93IHRo
ZSB0ZXN0IHByb2dyYW0gSSBpbmNsdWRlZCBpbiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Rlc3RfcGlkbnMuDQo+IEl0J3Mgc2VlbWVkIHRoYXQgZm5hbWUgd2FzIG5vdCBjb3JyZWN0bHkg
c2V0dXAgd2hlbiBwYXNzaW5nIGl0IHRvIGZpbGVuYW1lX2xvb2t1cC4NCj4gVGhpcyBpcyBmaXhl
ZCBub3cgYW5kIEknbSBkb2luZyBzb21lIG1vcmUgdGVzdGluZy4NCj4gSSB0aGluayBJJ2xsIHJl
bW92ZSB0aGUgdGVzdHMgb24gc2FtcGxlcy9icGYgYXMgdGhleSBhcmUgbW9zdGx5IGVuZCBvbiAt
RVBFUk0gYXMNCj4gdGhlIGZpeCBpbnRlbmRlZC4NCj4gSXMgb2sgdG8gcmVtb3ZlIHRoZW0gYW5k
IGp1c3QgZm9jdXMgdG8gZmluaXNoIHRoZSBzZWxmIHRlc3RzIGNvZGU/Lg0KDQpZZXMsIHRoZSBz
YW1wbGVzL2JwZiB0ZXN0IGNhc2UgY2FuIGJlIHJlbW92ZWQuDQpDb3VsZCB5b3UgY3JlYXRlIGEg
c2VsZnRlc3Qgd2l0aCB0cmFjcG9pbnQgbmV0L25ldGlmX3JlY2VpdmVfc2tiLCB3aGljaCANCmFs
c28gdXNlcyB0aGUgcHJvcG9zZWQgaGVscGVyPyBuZXQvbmV0aWZfcmVjZWl2ZV9za2Igd2lsbCBo
YXBwZW4gaW4NCmludGVycnVwdCBjb250ZXh0IGFuZCBpdCBzaG91bGQgY2F0Y2ggdGhlIGlzc3Vl
IGFzIHdlbGwgaWYgDQpmaWxlbmFtZV9sb29rdXAgc3RpbGwgZ2V0IGNhbGxlZCBpbiBpbnRlcnJ1
cHQgY29udGV4dC4NCg0KPiANCj4gQmVzdHMNCj4gDQo+IE9uIFdlZCwgQXVnIDE0LCAyMDE5IGF0
IDAxOjI1OjA2QU0gLTA0MDAsIGNhcmxvcyBhbnRvbmlvIG5laXJhIGJ1c3RvcyB3cm90ZToNCj4+
IFRoYW5rIHlvdSB2ZXJ5IG11Y2ghDQo+Pg0KPj4gQmVzdHMNCj4+DQo+PiBFbCBtacOpLiwgMTQg
ZGUgYWdvLiBkZSAyMDE5IDAwOjUwLCBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiBlc2NyaWJp
w7M6DQo+Pg0KPj4+DQo+Pj4NCj4+PiBPbiA4LzEzLzE5IDU6NTYgUE0sIENhcmxvcyBBbnRvbmlv
IE5laXJhIEJ1c3RvcyB3cm90ZToNCj4+Pj4gT24gVHVlLCBBdWcgMTMsIDIwMTkgYXQgMTE6MTE6
MTRQTSArMDAwMCwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gT24g
OC8xMy8xOSAxMTo0NyBBTSwgQ2FybG9zIE5laXJhIHdyb3RlOg0KPj4+Pj4+IEZyb206IENhcmxv
cyA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4NCj4+Pj4+Pg0KPj4+Pj4+IE5ldyBicGYgaGVscGVy
IGJwZl9nZXRfY3VycmVudF9waWRuc19pbmZvLg0KPj4+Pj4+IFRoaXMgaGVscGVyIG9idGFpbnMg
dGhlIGFjdGl2ZSBuYW1lc3BhY2UgZnJvbSBjdXJyZW50IGFuZCByZXR1cm5zDQo+Pj4+Pj4gcGlk
LCB0Z2lkLCBkZXZpY2UgYW5kIG5hbWVzcGFjZSBpZCBhcyBzZWVuIGZyb20gdGhhdCBuYW1lc3Bh
Y2UsDQo+Pj4+Pj4gYWxsb3dpbmcgdG8gaW5zdHJ1bWVudCBhIHByb2Nlc3MgaW5zaWRlIGEgY29u
dGFpbmVyLg0KPj4+Pj4+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJhIDxjbmVp
cmFidXN0b3NAZ21haWwuY29tPg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+ICAgICBmcy9pbnRlcm5hbC5o
ICAgICAgICAgICAgfCAgMiAtLQ0KPj4+Pj4+ICAgICBmcy9uYW1laS5jICAgICAgICAgICAgICAg
fCAgMSAtDQo+Pj4+Pj4gICAgIGluY2x1ZGUvbGludXgvYnBmLmggICAgICB8ICAxICsNCj4+Pj4+
PiAgICAgaW5jbHVkZS9saW51eC9uYW1laS5oICAgIHwgIDQgKysrDQo+Pj4+Pj4gICAgIGluY2x1
ZGUvdWFwaS9saW51eC9icGYuaCB8IDMxICsrKysrKysrKysrKysrKysrKysrKystDQo+Pj4+Pj4g
ICAgIGtlcm5lbC9icGYvY29yZS5jICAgICAgICB8ICAxICsNCj4+Pj4+PiAgICAga2VybmVsL2Jw
Zi9oZWxwZXJzLmMgICAgIHwgNjQNCj4+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4+Pj4+PiAgICAga2VybmVsL3RyYWNlL2JwZl90cmFjZS5jIHwg
IDIgKysNCj4+Pj4+PiAgICAgOCBmaWxlcyBjaGFuZ2VkLCAxMDIgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCj4+Pj4+Pg0KPj4+IFsuLi5dDQo+Pj4+Pj4NCj4+Pj4+PiArQlBGX0NBTExf
MihicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5mbywgc3RydWN0IGJwZl9waWRuc19pbmZvICosDQo+
Pj4gcGlkbnNfaW5mbywgdTMyLA0KPj4+Pj4+ICsgICAgc2l6ZSkNCj4+Pj4+PiArew0KPj4+Pj4+
ICsgICBjb25zdCBjaGFyICpwaWRuc19wYXRoID0gIi9wcm9jL3NlbGYvbnMvcGlkIjsNCj4+Pj4+
PiArICAgc3RydWN0IHBpZF9uYW1lc3BhY2UgKnBpZG5zID0gTlVMTDsNCj4+Pj4+PiArICAgc3Ry
dWN0IGZpbGVuYW1lICp0bXAgPSBOVUxMOw0KPj4+Pj4+ICsgICBzdHJ1Y3QgaW5vZGUgKmlub2Rl
Ow0KPj4+Pj4+ICsgICBzdHJ1Y3QgcGF0aCBrcDsNCj4+Pj4+PiArICAgcGlkX3QgdGdpZCA9IDA7
DQo+Pj4+Pj4gKyAgIHBpZF90IHBpZCA9IDA7DQo+Pj4+Pj4gKyAgIGludCByZXQ7DQo+Pj4+Pj4g
KyAgIGludCBsZW47DQo+Pj4+Pg0KPj4+Pg0KPj4+PiBUaGFuayB5b3UgdmVyeSBtdWNoIGZvciBj
YXRjaGluZyB0aGlzIS4NCj4+Pj4gQ291bGQgeW91IHNoYXJlIGhvdyB0byByZXBsaWNhdGUgdGhp
cyBidWc/Lg0KPj4+DQo+Pj4gVGhlIGNvbmZpZyBpcyBhdHRhY2hlZC4ganVzdCBydW4gdHJhY2Vf
bnNfaW5mbyBhbmQgeW91DQo+Pj4gY2FuIHJlcHJvZHVjZSB0aGUgaXNzdWUuDQo+Pj4NCj4+Pj4N
Cj4+Pj4+IEkgYW0gcnVubmluZyB5b3VyIHNhbXBsZSBwcm9ncmFtIGFuZCBnZXQgdGhlIGZvbGxv
d2luZyBrZXJuZWwgYnVnOg0KPj4+Pj4NCj4+Pj4+IC4uLg0KPj4+Pj4gWyAgIDI2LjQxNDgyNV0g
QlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQNCj4+
Pj4+IC9kYXRhL3VzZXJzL3locy93b3JrL25ldC1uZXh0L2ZzDQo+Pj4+PiAvZGNhY2hlLmM6ODQz
DQo+Pj4+PiBbICAgMjYuNDE2MzE0XSBpbl9hdG9taWMoKTogMSwgaXJxc19kaXNhYmxlZCgpOiAw
LCBwaWQ6IDE5MTEsIG5hbWU6IHBpbmcNCj4+Pj4+IFsgICAyNi40MTcxODldIENQVTogMCBQSUQ6
IDE5MTEgQ29tbTogcGluZyBUYWludGVkOiBHICAgICAgICBXDQo+Pj4+PiA1LjMuMC1yYzErICMy
ODANCj4+Pj4+IFsgICAyNi40MTgxODJdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMg
KGk0NDBGWCArIFBJSVgsIDE5OTYpLA0KPj4+Pj4gQklPUyAxLjkuMy0xLmVsNy5jZW50b3MgMDQv
MDEvMg0KPj4+Pj4gMDE0DQo+Pj4+PiBbICAgMjYuNDE5MzkzXSBDYWxsIFRyYWNlOg0KPj4+Pj4g
WyAgIDI2LjQxOTY5N10gIDxJUlE+DQo+Pj4+PiBbICAgMjYuNDE5OTYwXSAgZHVtcF9zdGFjaysw
eDQ2LzB4NWINCj4+Pj4+IFsgICAyNi40MjA0MzRdICBfX19taWdodF9zbGVlcCsweGU0LzB4MTEw
DQo+Pj4+PiBbICAgMjYuNDIwODk0XSAgZHB1dCsweDJhLzB4MjAwDQo+Pj4+PiBbICAgMjYuNDIx
MjY1XSAgd2Fsa19jb21wb25lbnQrMHgxMGMvMHgyODANCj4+Pj4+IFsgICAyNi40MjE3NzNdICBs
aW5rX3BhdGhfd2FsaysweDMyNy8weDU2MA0KPj4+Pj4gWyAgIDI2LjQyMjI4MF0gID8gcHJvY19u
c19kaXJfcmVhZGRpcisweDFhMC8weDFhMA0KPj4+Pj4gWyAgIDI2LjQyMjg0OF0gID8gcGF0aF9p
bml0KzB4MjMyLzB4MzMwDQo+Pj4+PiBbICAgMjYuNDIzMzY0XSAgcGF0aF9sb29rdXBhdCsweDg4
LzB4MjAwDQo+Pj4+PiBbICAgMjYuNDIzODA4XSAgPyBzZWxpbnV4X3BhcnNlX3NrYi5jb25zdHBy
b3AuNjkrMHgxMjQvMHg0MzANCj4+Pj4+IFsgICAyNi40MjQ1MjFdICBmaWxlbmFtZV9sb29rdXAr
MHhhZi8weDE5MA0KPj4+Pj4gWyAgIDI2LjQyNTAzMV0gID8gc2ltcGxlX2F0dHJfcmVsZWFzZSsw
eDIwLzB4MjANCj4+Pj4+IFsgICAyNi40MjU1NjBdICBicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5m
bysweGZhLzB4MTkwDQo+Pj4+PiBbICAgMjYuNDI2MTY4XSAgYnBmX3Byb2dfODM2MjcxNTRjZWZl
ZDU5NisweGU2Ni8weDEwMDANCj4+Pj4+IFsgICAyNi40MjY3NzldICB0cmFjZV9jYWxsX2JwZisw
eGI1LzB4MTYwDQo+Pj4+PiBbICAgMjYuNDI3MzE3XSAgPyBfX25ldGlmX3JlY2VpdmVfc2tiX2Nv
cmUrMHgxLzB4YmIwDQo+Pj4+PiBbICAgMjYuNDI3OTI5XSAgPyBfX25ldGlmX3JlY2VpdmVfc2ti
X2NvcmUrMHgxLzB4YmIwDQo+Pj4+PiBbICAgMjYuNDI4NDk2XSAga3Byb2JlX3BlcmZfZnVuYysw
eDRkLzB4MjgwDQo+Pj4+PiBbICAgMjYuNDI4OTg2XSAgPyB0cmFjaW5nX3JlY29yZF90YXNraW5m
b19za2lwKzB4MWEvMHgzMA0KPj4+Pj4gWyAgIDI2LjQyOTU4NF0gID8gdHJhY2luZ19yZWNvcmRf
dGFza2luZm8rMHhlLzB4ODANCj4+Pj4+IFsgICAyNi40MzAxNTJdICA/IHR0d3VfZG9fd2FrZXVw
LmlzcmEuMTE0KzB4Y2YvMHhmMA0KPj4+Pj4gWyAgIDI2LjQzMDczN10gID8gX19uZXRpZl9yZWNl
aXZlX3NrYl9jb3JlKzB4MS8weGJiMA0KPj4+Pj4gWyAgIDI2LjQzMTMzNF0gID8gX19uZXRpZl9y
ZWNlaXZlX3NrYl9jb3JlKzB4NS8weGJiMA0KPj4+Pj4gWyAgIDI2LjQzMTkzMF0gIGtwcm9iZV9m
dHJhY2VfaGFuZGxlcisweDkwLzB4ZjANCj4+Pj4+IFsgICAyNi40MzI0OTVdICBmdHJhY2Vfb3Bz
X2Fzc2lzdF9mdW5jKzB4NjMvMHgxMDANCj4+Pj4+IFsgICAyNi40MzMwNjBdICAweGZmZmZmZmZm
YzAzMTgwYmYNCj4+Pj4+IFsgICAyNi40MzM0NzFdICA/IF9fbmV0aWZfcmVjZWl2ZV9za2JfY29y
ZSsweDEvMHhiYjANCj4+Pj4+IC4uLg0KPj4+Pj4NCj4+Pj4+IFRvIHByZXZlbnQgd2UgYXJlIHJ1
bm5pbmcgaW4gYXJiaXRyYXJ5IHRhc2sgKGUuZy4sIGlkbGUgdGFzaykNCj4+Pj4+IGNvbnRleHQg
d2hpY2ggbWF5IGludHJvZHVjZSBzbGVlcGluZyBpc3N1ZXMsIHRoZSBmb2xsb3dpbmcNCj4+Pj4+
IHByb2JhYmx5IGFwcHJvcHJpYXRlOg0KPj4+Pj4NCj4+Pj4+ICAgICAgICAgICBpZiAoaW5fbm1p
KCkgfHwgaW5fc29mdGlycSgpKQ0KPj4+Pj4gICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FUEVS
TTsNCj4+Pj4+DQo+Pj4+PiBBbnl3YXksIGlmIGluIG5taSBvciBzb2Z0aXJxLCB0aGUgbmFtZXNw
YWNlIGFuZCBwaWQvdGdpZA0KPj4+Pj4gd2UgZ2V0IG1heSBiZSBqdXN0IGFjY2lkZW50YWxseSBh
c3NvY2lhdGVkIHdpdGggdGhlIGJwZiBydW5uaW5nDQo+Pj4+PiBjb250ZXh0LCBidXQgaXQgY291
bGQgYmUgaW4gYSBkaWZmZXJlbnQgY29udGV4dC4gU28gc3VjaCBpbmZvDQo+Pj4+PiBpcyBub3Qg
cmVsaWFibGUgYW55IHdheS4NCj4+Pj4+DQo+Pj4+Pj4gKw0KPj4+Pj4+ICsgICBpZiAodW5saWtl
bHkoc2l6ZSAhPSBzaXplb2Yoc3RydWN0IGJwZl9waWRuc19pbmZvKSkpDQo+Pj4+Pj4gKyAgICAg
ICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+Pj4+Pj4gKyAgIHBpZG5zID0gdGFza19hY3RpdmVfcGlk
X25zKGN1cnJlbnQpOw0KPj4+IFsuLi5dDQo+Pj4NCg==
