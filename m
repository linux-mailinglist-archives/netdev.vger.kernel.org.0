Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E7511E933
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfLMR2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:28:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42292 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbfLMR2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:28:44 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDHNoHe028316;
        Fri, 13 Dec 2019 09:26:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0fKEfMBU7Mt+VXdVddRcRMHS6t+WSwWXJ8FX43xfjYc=;
 b=HCkliBn6Ekc2w4njlNVz9C/IR0tQKLTDpuIBKi81KCNd1usZE+BZRlQ2hffGCWffvk8p
 +6JCUkNmyJXuyKTrMyOX01WJQ7VT2CDKpQmRupfoH+EzmGW6/F3iTq7Yol0P7a+Vdv/c
 WoYwbyySBpuPvbtYUVxnpBAS6kaKq7ZHxak= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wuskg5m91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 09:26:27 -0800
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 09:26:26 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 09:26:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 09:26:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khwwBR+V2izAIW76w4mzMeaQJJBC1r7JuvJtWENYOyyQdbJVRM2cctf3biHNbuqOGApoL8zFlAFG2bpvjmAbxwWTtIkk2jlb0NU+JZVMyKnrFx6GwK41voEIqtjy80B2iTg3DNG4vlwlJBMwONcGs2R75KMGFE7haaClTP5ykf43n9elclQx7yHhOwexINdYCLJ6xac4VbziXRN2r3T5nYKjasYPlOKMWvwXJW0FbbJ7OoGtDjYlzF5uLtF7vV10003U36Ph28n53TJy1x331eD+3UGl3uBwq6SXqUPrsCfNwn+1rRRQPT4Juz9pItcMSxDitZIoMz0ZoVww8iZD+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fKEfMBU7Mt+VXdVddRcRMHS6t+WSwWXJ8FX43xfjYc=;
 b=Y2ZAjQQR5IoZW7JDrZa1gHNCdLX8bWUVjHBu9VDEdEYpSisyPXRtYIiL3cpe/P51S/5m/jNZiHs2q7IyvFZqZzdWwv+mruvnLUe8VJSLCP3j6pAdXSaAMW8r5z8hiqepyHtwjSspvtRnA2K+l1V0jnUv1bVdRgErzvHV5zQgek93b6Z1VE5aEtLKW82PAyAwUkloA/ZhId/FkXV3g0NJ2b086TEzhT5aQJ1utVbOg7j7xF6H7tSnwpzv3Sol9P29tTkjR24vVGmVfmg8frlVx+ChHvP8nwRKH1FPwaDuY5AQ89hpTTt9fJXqfu4jkXdUbXl/sSjEPWwzPh9Yj6GRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fKEfMBU7Mt+VXdVddRcRMHS6t+WSwWXJ8FX43xfjYc=;
 b=lTJXrvvXKq6l7jyo6+BrpWS2EhdJXMOJrSalMEyN0eTcdYiSHZjP2oLwtcejezqBS6y159eXqYR1vrJic1wccyDRFOBjHtY39G2PNUISQo72iE9sm91UHAAEH30evvLK4QMV1qv/6O+HQmb4nKiRChIE7RU7hcbk73NE6d7sQ10=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1595.namprd15.prod.outlook.com (10.173.222.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Fri, 13 Dec 2019 17:26:25 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 17:26:25 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup and
 lookup_and_delete batch ops
Thread-Topic: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup
 and lookup_and_delete batch ops
Thread-Index: AQHVsHMkVh4m3HefgkGiZrFDkJ92tKe4U/iA
Date:   Fri, 13 Dec 2019 17:26:24 +0000
Message-ID: <a2ce5033-fa75-c17b-ee97-8a7dcb67ab61@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-3-brianvv@google.com>
In-Reply-To: <20191211223344.165549-3-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0146.namprd04.prod.outlook.com (2603:10b6:104::24)
 To DM5PR15MB1675.namprd15.prod.outlook.com (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ade4aee5-b423-40cb-0736-08d77ff19442
x-ms-traffictypediagnostic: DM5PR15MB1595:
x-microsoft-antispam-prvs: <DM5PR15MB1595CC321AFF43F7D5CC7B4DD3540@DM5PR15MB1595.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(478600001)(8936002)(6506007)(2616005)(2906002)(66446008)(110136005)(5660300002)(316002)(6486002)(8676002)(186003)(86362001)(71200400001)(53546011)(54906003)(64756008)(66556008)(31696002)(81156014)(81166006)(6512007)(52116002)(66476007)(4326008)(31686004)(66946007)(7416002)(36756003)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1595;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTJ4hAo8VVkJAJFVOT1PXRBMo4rKJBmGi+oiJv3ujIshoP0xHpqWbgnqLIEY/VS8xLTLARm0jdER1rSZZ2skutDqjsWnLuM4xHm3UTmdyyDQSvFqH+UHw9TjKymCvOYa7Rub0bg8g91nqVUqiS3cd4CzeLNU+eQrTM3CfnwpOkVnbWHbMP7Px69bDEJWYi/QXMQlyYwNsYR1HHqBRTSxMYLkV7RLp98KzQLFM1u/7+8I50zIV9ImAi89sph+/zrUQEOXwx8Z1K+PZjnkE1dMKvcp+MYBkmRZHgJvKFCW46dsbGiXr5DvMuws+lr4zBRWvugyacoAIZmgBfPP6p69AMeg5wommcDx0bWVSU4kn39YQ7/l1Y/Q8+8ZRrrQQB73wf+iOCuR8AE9yXMOTCNlqbUernWqqpSFsnCLt7CSqhgLmRuSeIZQJBlfeRPhm+boSoO8e5+g+H3coCL0fcx9cGQXP+f+nTMFBRpkJJia8JYr0aAeCAUtsAywAE7bJr+8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACD2DC502CEB684882CC82B74DE5BDB8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ade4aee5-b423-40cb-0736-08d77ff19442
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:26:24.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l66ZmqyYaVtLkQGFQImCmSQRRTw2WRKgFsodoafue6/KkL+xxOQvY1VnxXj3ZjO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1595
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912130137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgY29t
bWl0IGludHJvZHVjZXMgZ2VuZXJpYyBzdXBwb3J0IGZvciB0aGUgYnBmX21hcF9sb29rdXBfYmF0
Y2ggYW5kDQo+IGJwZl9tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2ggb3BzLiBUaGlzIGltcGxl
bWVudGF0aW9uIGNhbiBiZSB1c2VkIGJ5DQo+IGFsbW9zdCBhbGwgdGhlIGJwZiBtYXBzIHNpbmNl
IGl0cyBjb3JlIGltcGxlbWVudGF0aW9uIGlzIHJlbHlpbmcgb24gdGhlDQo+IGV4aXN0aW5nIG1h
cF9nZXRfbmV4dF9rZXksIG1hcF9sb29rdXBfZWxlbSBhbmQgbWFwX2RlbGV0ZV9lbGVtDQo+IGZ1
bmN0aW9ucy4gVGhlIGJwZiBzeXNjYWxsIHN1YmNvbW1hbmRzIGludHJvZHVjZWQgYXJlOg0KPiAN
Cj4gICAgQlBGX01BUF9MT09LVVBfQkFUQ0gNCj4gICAgQlBGX01BUF9MT09LVVBfQU5EX0RFTEVU
RV9CQVRDSA0KPiANCj4gVGhlIFVBUEkgYXR0cmlidXRlIGlzOg0KPiANCj4gICAgc3RydWN0IHsg
Lyogc3RydWN0IHVzZWQgYnkgQlBGX01BUF8qX0JBVENIIGNvbW1hbmRzICovDQo+ICAgICAgICAg
ICBfX2FsaWduZWRfdTY0ICAgaW5fYmF0Y2g7ICAgICAgIC8qIHN0YXJ0IGJhdGNoLA0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBOVUxMIHRvIHN0YXJ0IGZy
b20gYmVnaW5uaW5nDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqLw0KPiAgICAgICAgICAgX19hbGlnbmVkX3U2NCAgIG91dF9iYXRjaDsgICAgICAvKiBvdXRw
dXQ6IG5leHQgc3RhcnQgYmF0Y2ggKi8NCj4gICAgICAgICAgIF9fYWxpZ25lZF91NjQgICBrZXlz
Ow0KPiAgICAgICAgICAgX19hbGlnbmVkX3U2NCAgIHZhbHVlczsNCj4gICAgICAgICAgIF9fdTMy
ICAgICAgICAgICBjb3VudDsgICAgICAgICAgLyogaW5wdXQvb3V0cHV0Og0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBpbnB1dDogIyBvZiBrZXkvdmFsdWUN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogZWxlbWVudHMN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogb3V0cHV0OiAj
IG9mIGZpbGxlZCBlbGVtZW50cw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKi8NCj4gICAgICAgICAgIF9fdTMyICAgICAgICAgICBtYXBfZmQ7DQo+ICAgICAg
ICAgICBfX3U2NCAgICAgICAgICAgZWxlbV9mbGFnczsNCj4gICAgICAgICAgIF9fdTY0ICAgICAg
ICAgICBmbGFnczsNCj4gICAgfSBiYXRjaDsNCj4gDQo+IGluX2JhdGNoL291dF9iYXRjaCBhcmUg
b3BhcXVlIHZhbHVlcyB1c2UgdG8gY29tbXVuaWNhdGUgYmV0d2Vlbg0KPiB1c2VyL2tlcm5lbCBz
cGFjZSwgaW5fYmF0Y2gvb3V0X2JhdGNoIG11c3QgYmUgb2Yga2V5X3NpemUgbGVuZ3RoLg0KPiAN
Cj4gVG8gc3RhcnQgaXRlcmF0aW5nIGZyb20gdGhlIGJlZ2lubmluZyBpbl9iYXRjaCBtdXN0IGJl
IG51bGwsDQo+IGNvdW50IGlzIHRoZSAjIG9mIGtleS92YWx1ZSBlbGVtZW50cyB0byByZXRyaWV2
ZS4gTm90ZSB0aGF0IHRoZSAna2V5cycNCj4gYnVmZmVyIG11c3QgYmUgYSBidWZmZXIgb2Yga2V5
X3NpemUgKiBjb3VudCBzaXplIGFuZCB0aGUgJ3ZhbHVlcycgYnVmZmVyDQo+IG11c3QgYmUgdmFs
dWVfc2l6ZSAqIGNvdW50LCB3aGVyZSB2YWx1ZV9zaXplIG11c3QgYmUgYWxpZ25lZCB0byA4IGJ5
dGVzDQo+IGJ5IHVzZXJzcGFjZSBpZiBpdCdzIGRlYWxpbmcgd2l0aCBwZXJjcHUgbWFwcy4gJ2Nv
dW50JyB3aWxsIGNvbnRhaW4gdGhlDQo+IG51bWJlciBvZiBrZXlzL3ZhbHVlcyBzdWNjZXNzZnVs
bHkgcmV0cmlldmVkLiBOb3RlIHRoYXQgJ2NvdW50JyBpcyBhbg0KPiBpbnB1dC9vdXRwdXQgdmFy
aWFibGUgYW5kIGl0IGNhbiBjb250YWluIGEgbG93ZXIgdmFsdWUgYWZ0ZXIgYSBjYWxsLg0KPiAN
Cj4gSWYgdGhlcmUncyBubyBtb3JlIGVudHJpZXMgdG8gcmV0cmlldmUsIEVOT0VOVCB3aWxsIGJl
IHJldHVybmVkLiBJZiBlcnJvcg0KPiBpcyBFTk9FTlQsIGNvdW50IG1pZ2h0IGJlID4gMCBpbiBj
YXNlIGl0IGNvcGllZCBzb21lIHZhbHVlcyBidXQgdGhlcmUgd2VyZQ0KPiBubyBtb3JlIGVudHJp
ZXMgdG8gcmV0cmlldmUuDQo+IA0KPiBOb3RlIHRoYXQgaWYgdGhlIHJldHVybiBjb2RlIGlzIGFu
IGVycm9yIGFuZCBub3QgLUVGQVVMVCwNCj4gY291bnQgaW5kaWNhdGVzIHRoZSBudW1iZXIgb2Yg
ZWxlbWVudHMgc3VjY2Vzc2Z1bGx5IHByb2Nlc3NlZC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogU3Rh
bmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQnJpYW4g
VmF6cXVleiA8YnJpYW52dkBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZb25naG9uZyBT
b25nIDx5aHNAZmIuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRlL2xpbnV4L2JwZi5oICAgICAgfCAg
MTEgKysrDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgIDE5ICsrKysrDQo+ICAga2Vy
bmVsL2JwZi9zeXNjYWxsLmMgICAgIHwgMTcyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMjAyIGluc2VydGlvbnMoKykNClsuLi5d
DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL3N5c2NhbGwuYyBiL2tlcm5lbC9icGYvc3lzY2Fs
bC5jDQo+IGluZGV4IDI1MzAyNjZmYTY0NzcuLjcwOGFhODlmZTIzMDggMTAwNjQ0DQo+IC0tLSBh
L2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+ICsrKyBiL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+IEBA
IC0xMjA2LDYgKzEyMDYsMTIwIEBAIHN0YXRpYyBpbnQgbWFwX2dldF9uZXh0X2tleSh1bmlvbiBi
cGZfYXR0ciAqYXR0cikNCj4gICAJcmV0dXJuIGVycjsNCj4gICB9DQo+ICAgDQo+ICsjZGVmaW5l
IE1BUF9MT09LVVBfUkVUUklFUyAzDQo+ICsNCj4gK3N0YXRpYyBpbnQgX19nZW5lcmljX21hcF9s
b29rdXBfYmF0Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4gKwkJCQkgICAgICBjb25zdCB1bmlv
biBicGZfYXR0ciAqYXR0ciwNCj4gKwkJCQkgICAgICB1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVh
dHRyLA0KPiArCQkJCSAgICAgIGJvb2wgZG9fZGVsZXRlKQ0KPiArew0KPiArCXZvaWQgX191c2Vy
ICp1YmF0Y2ggPSB1NjRfdG9fdXNlcl9wdHIoYXR0ci0+YmF0Y2guaW5fYmF0Y2gpOw0KPiArCXZv
aWQgX191c2VyICp1b2JhdGNoID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLm91dF9iYXRj
aCk7DQo+ICsJdm9pZCBfX3VzZXIgKnZhbHVlcyA9IHU2NF90b191c2VyX3B0cihhdHRyLT5iYXRj
aC52YWx1ZXMpOw0KPiArCXZvaWQgX191c2VyICprZXlzID0gdTY0X3RvX3VzZXJfcHRyKGF0dHIt
PmJhdGNoLmtleXMpOw0KPiArCXZvaWQgKmJ1ZiwgKnByZXZfa2V5LCAqa2V5LCAqdmFsdWU7DQo+
ICsJdTMyIHZhbHVlX3NpemUsIGNwLCBtYXhfY291bnQ7DQo+ICsJYm9vbCBmaXJzdF9rZXkgPSBm
YWxzZTsNCj4gKwlpbnQgZXJyLCByZXRyeSA9IE1BUF9MT09LVVBfUkVUUklFUzsNCg0KQ291bGQg
eW91IHRyeSB0byB1c2UgcmV2ZXJzZSBDaHJpc3RtYXMgdHJlZSBzdHlsZSBkZWNsYXJhdGlvbiBo
ZXJlPw0KDQo+ICsNCj4gKwlpZiAoYXR0ci0+YmF0Y2guZWxlbV9mbGFncyAmIH5CUEZfRl9MT0NL
KQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCWlmICgoYXR0ci0+YmF0Y2guZWxlbV9m
bGFncyAmIEJQRl9GX0xPQ0spICYmDQo+ICsJICAgICFtYXBfdmFsdWVfaGFzX3NwaW5fbG9jayht
YXApKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCXZhbHVlX3NpemUgPSBicGZfbWFw
X3ZhbHVlX3NpemUobWFwKTsNCj4gKw0KPiArCW1heF9jb3VudCA9IGF0dHItPmJhdGNoLmNvdW50
Ow0KPiArCWlmICghbWF4X2NvdW50KQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCWJ1ZiA9IGtt
YWxsb2MobWFwLT5rZXlfc2l6ZSArIHZhbHVlX3NpemUsIEdGUF9VU0VSIHwgX19HRlBfTk9XQVJO
KTsNCj4gKwlpZiAoIWJ1ZikNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICsNCj4gKwllcnIgPSAt
RUZBVUxUOw0KPiArCWZpcnN0X2tleSA9IGZhbHNlOw0KPiArCWlmICh1YmF0Y2ggJiYgY29weV9m
cm9tX3VzZXIoYnVmLCB1YmF0Y2gsIG1hcC0+a2V5X3NpemUpKQ0KPiArCQlnb3RvIGZyZWVfYnVm
Ow0KPiArCWtleSA9IGJ1ZjsNCj4gKwl2YWx1ZSA9IGtleSArIG1hcC0+a2V5X3NpemU7DQo+ICsJ
aWYgKCF1YmF0Y2gpIHsNCj4gKwkJcHJldl9rZXkgPSBOVUxMOw0KPiArCQlmaXJzdF9rZXkgPSB0
cnVlOw0KPiArCX0NCj4gKw0KPiArCWZvciAoY3AgPSAwOyBjcCA8IG1heF9jb3VudDspIHsNCj4g
KwkJaWYgKGNwIHx8IGZpcnN0X2tleSkgew0KPiArCQkJcmN1X3JlYWRfbG9jaygpOw0KPiArCQkJ
ZXJyID0gbWFwLT5vcHMtPm1hcF9nZXRfbmV4dF9rZXkobWFwLCBwcmV2X2tleSwga2V5KTsNCj4g
KwkJCXJjdV9yZWFkX3VubG9jaygpOw0KPiArCQkJaWYgKGVycikNCj4gKwkJCQlicmVhazsNCj4g
KwkJfQ0KPiArCQllcnIgPSBicGZfbWFwX2NvcHlfdmFsdWUobWFwLCBrZXksIHZhbHVlLA0KPiAr
CQkJCQkgYXR0ci0+YmF0Y2guZWxlbV9mbGFncywgZG9fZGVsZXRlKTsNCj4gKw0KPiArCQlpZiAo
ZXJyID09IC1FTk9FTlQpIHsNCj4gKwkJCWlmIChyZXRyeSkgew0KPiArCQkJCXJldHJ5LS07DQo+
ICsJCQkJY29udGludWU7DQo+ICsJCQl9DQo+ICsJCQllcnIgPSAtRUlOVFI7DQo+ICsJCQlicmVh
azsNCj4gKwkJfQ0KPiArDQo+ICsJCWlmIChlcnIpDQo+ICsJCQlnb3RvIGZyZWVfYnVmOw0KPiAr
DQo+ICsJCWlmIChjb3B5X3RvX3VzZXIoa2V5cyArIGNwICogbWFwLT5rZXlfc2l6ZSwga2V5LA0K
PiArCQkJCSBtYXAtPmtleV9zaXplKSkgew0KPiArCQkJZXJyID0gLUVGQVVMVDsNCj4gKwkJCWdv
dG8gZnJlZV9idWY7DQo+ICsJCX0NCj4gKwkJaWYgKGNvcHlfdG9fdXNlcih2YWx1ZXMgKyBjcCAq
IHZhbHVlX3NpemUsIHZhbHVlLCB2YWx1ZV9zaXplKSkgew0KPiArCQkJZXJyID0gLUVGQVVMVDsN
Cj4gKwkJCWdvdG8gZnJlZV9idWY7DQo+ICsJCX0NCj4gKw0KPiArCQlwcmV2X2tleSA9IGtleTsN
Cj4gKwkJcmV0cnkgPSBNQVBfTE9PS1VQX1JFVFJJRVM7DQo+ICsJCWNwKys7DQo+ICsJfQ0KPiAr
DQo+ICsJaWYgKCFlcnIpIHsNCj4gKwkJcmN1X3JlYWRfbG9jaygpOw0KPiArCQllcnIgPSBtYXAt
Pm9wcy0+bWFwX2dldF9uZXh0X2tleShtYXAsIHByZXZfa2V5LCBrZXkpOw0KPiArCQlyY3VfcmVh
ZF91bmxvY2soKTsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoZXJyKQ0KPiArCQltZW1zZXQoa2V5LCAw
LCBtYXAtPmtleV9zaXplKTsNCg0KU28gaWYgYW55IGVycm9yIGhhcHBlbnMgZHVlIHRvIGFib3Zl
IG1hcF9nZXRfbmV4dF9rZXkoKSBvciBlYXJsaWVyIA0KZXJyb3IsIHRoZSBuZXh0ICJiYXRjaCIg
cmV0dXJuZWQgdG8gdXNlciBjb3VsZCBiZSAiMCIuIFdoYXQgc2hvdWxkDQp1c2VyIHNwYWNlIGhh
bmRsZSB0aGlzPyBVbHRpbWF0ZWx5LCB0aGUgdXNlciBzcGFjZSBuZWVkcyB0byBzdGFydA0KZnJv
bSB0aGUgYmVnaW5uaW5nIGFnYWluPw0KDQpXaGF0IEkgbWVhbiBpcyBoZXJlIGhvdyB3ZSBjb3Vs
ZCBkZXNpZ24gYW4gaW50ZXJmYWNlIHNvIHVzZXINCnNwYWNlLCBpZiBubyAtRUZBVUxUIGVycm9y
LCBjYW4gc3VjY2Vzc2Z1bGx5IGdldCBhbGwgZWxlbWVudHMNCndpdGhvdXQgZHVwbGljYXRpb24u
DQoNCk9uZSB3YXkgdG8gZG8gaGVyZSBpcyBqdXN0IHJldHVybiAtRUZBVUxUIGlmIHdlIGNhbm5v
dCBnZXQNCnByb3BlciBuZXh0IGtleS4gQnV0IG1heWJlIHdlIGNvdWxkIGhhdmUgYmV0dGVyIG1l
Y2hhbmlzbQ0Kd2hlbiB3ZSB0cnkgdG8gaW1wbGVtZW50IHdoYXQgdXNlciBzcGFjZSBjb2RlcyB3
aWxsIGxvb2sgbGlrZS4NCg0KPiArDQo+ICsJaWYgKChjb3B5X3RvX3VzZXIoJnVhdHRyLT5iYXRj
aC5jb3VudCwgJmNwLCBzaXplb2YoY3ApKSB8fA0KPiArCQkgICAgKGNvcHlfdG9fdXNlcih1b2Jh
dGNoLCBrZXksIG1hcC0+a2V5X3NpemUpKSkpDQo+ICsJCWVyciA9IC1FRkFVTFQ7DQo+ICsNCj4g
K2ZyZWVfYnVmOg0KPiArCWtmcmVlKGJ1Zik7DQo+ICsJcmV0dXJuIGVycjsNCj4gK30NCj4gKw0K
Wy4uLl0NCg==
