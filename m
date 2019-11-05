Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF47F0A23
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbfKEXSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:18:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbfKEXSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 18:18:51 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5NAQPU009470;
        Tue, 5 Nov 2019 15:18:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=46SPVbuJW9CxUtmCqh8uLYeQmyDSgMTFsieyL9SZGHI=;
 b=dUlA4g3M73X89dZqWoknFwqROEdCEGq4bIqCvYI+FU81WEkoAtyA5Ogquzycewvo+8DU
 2FN7WUfe2DS2g/ndaKGxZKbqdwh2FqMiXX7fgjBYWwZAVJDd8CgUM3eBB8OOd/UPiHdj
 yhL1t571a1Ta8h2Rr05KxcDRgTrM/TxQW/U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w3ddet1a1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 15:18:03 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 5 Nov 2019 15:18:03 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 5 Nov 2019 15:18:02 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 5 Nov 2019 15:18:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR/yJUC1icDGrtYybeeKSL5TKSnrVSJJ3Ygv5yoVOtlTOeagzpozRF1pIimOKcJOat9kN02uEfkBEDeoqvTSkTwKxqyXmepJxInoYmzeBfuNIf6b2eP8oqFGchqOpco62JDoBj+v76cVnQRZArzsVGbb+e7wLgQFbxDamAKiLUEJAjCyG+1bH4K3okjsddeu1ZSTfeAqZf7XGbF4MQx81HTG4xQki4gW5EbcuozcgACkoU62mQFVaCSO9wOcyDD2fVW+Zt4bGM8QSZSYqa3F7UwpyZlDDfVI+MXXgi0WzVB+RCW7nZyIi1sSQMNwqDlYexUT3AzaL2YDQ0awb5Tdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46SPVbuJW9CxUtmCqh8uLYeQmyDSgMTFsieyL9SZGHI=;
 b=jtSgMHBsoLwocc9ct7rcSU86Rtpia8Na3eVncOTGx6U5GQELkJWYHkbzR3bJtsyhxBqItXfHh7FeT5FkcX/Q8oYEs3gqTVP2DhKx2ZjEcCiJAJvBYjL1oYBwQcesrWLXYAb7evjKpoX0QKhX8lNW5fz6hckyRzXuu4qay24nJhpefHzpe7gQkdpMj0F70g0GhlGhsE5nmWthtGZaaE18Iadfr/hP8VEyhUSvvc/VKCfci/qKV+KbjhHPw4nAb/P4nX9RsMMmhDQIe5jGgR4t2vcUZEvgsm51QN9NuLiw+fi1ppSdgt8xEQ6l6Xt761NooyWiEvbGZg1qVQ8cRrk1aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46SPVbuJW9CxUtmCqh8uLYeQmyDSgMTFsieyL9SZGHI=;
 b=HAsZjVpmWCx5YjQ5YeJSXGBf5Cd0E0caPaVnZDntiP/pSHyP7ZduvEofMNlvvikKF45J4vHF12927sd6jSfsofOvf5Z4WLXV/tBP/9XSpNgU98ti5X3Lgy7KGbjmLgdYsPO9DOnrBeDixjGsK7omZJ4xT/ViI+cfXHtMlrzm5HM=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2869.namprd15.prod.outlook.com (20.178.206.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 23:17:59 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::707c:3161:d472:18c5]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::707c:3161:d472:18c5%4]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 23:17:59 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Topic: [PATCH bpf-next 4/7] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Index: AQHVkcj3gN05b8hPR0mG8BMjU5r+Tad9GWcAgAAhiIA=
Date:   Tue, 5 Nov 2019 23:17:59 +0000
Message-ID: <2456bb02-4d26-4fce-2d5e-5abb59ba3644@fb.com>
References: <20191102220025.2475981-1-ast@kernel.org>
 <20191102220025.2475981-5-ast@kernel.org>
 <CAEf4BzbJ3Y4_rjvr9Xu2MR87Ghdx_1n=KOOaeqM_F7+OwPihRw@mail.gmail.com>
In-Reply-To: <CAEf4BzbJ3Y4_rjvr9Xu2MR87Ghdx_1n=KOOaeqM_F7+OwPihRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:104:3::19) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:47d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ecdd29d-5612-4b6a-dbb4-08d7624665ad
x-ms-traffictypediagnostic: BYAPR15MB2869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28693C0EE258DA747DED4FC4D77E0@BYAPR15MB2869.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(39860400002)(136003)(189003)(199004)(46003)(66476007)(186003)(6116002)(5660300002)(386003)(53546011)(6506007)(305945005)(25786009)(81156014)(8936002)(52116002)(81166006)(8676002)(76176011)(102836004)(64756008)(6436002)(14454004)(229853002)(6486002)(66446008)(66556008)(6246003)(478600001)(31696002)(66946007)(4326008)(7736002)(2906002)(6512007)(86362001)(256004)(11346002)(486006)(2616005)(31686004)(5024004)(476003)(99286004)(36756003)(71190400001)(54906003)(71200400001)(446003)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2869;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7a74lC6S3j9SowOmbxEVj5D+BIIylJkiQtoltbGTqAWrafk+gIIK8dzB6hhalD+bye++eJ4czmqEARXFMQzvmltLYhZQ7INRr9GmgkgzhM/ZWlfCSgK7pMsJtpzD6B1J7OH1+LsYLeAmIlaju0lZ3aupp2PcBIMD1S1W/jKZs9ZdzeFGOZnZW0r+pyaFOPt2CSxQM7qsdYqKtFxJNsa/UxhptMM0A3bp8+7eXt5yv9GPDvi5jIfioWzN2P2D9SaMZ0JZfuhuPhQSIC21G32eM6AHQVwq2ptX1cd99CxVD+scisp78/GYdV9BFY9W3lspBuW9NWFeXpnesEBEg9sAUOgkDhKVwCM7h10QClpx5NBcDYZClgLID9lgQ3iaFcicU4MzCHHZOuLVQIDe27v3uVOXCEp3tU4Lnxzgb4Tw68wD8fLJuHAbAPaU/beuD6Ug
Content-Type: text/plain; charset="utf-8"
Content-ID: <876C0FD3BC9FDE48A7713721DF3840E6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecdd29d-5612-4b6a-dbb4-08d7624665ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 23:17:59.1488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ie3LxOD+WinM2Z0PsGQbG8mtkYhdeqvL9KmbbbUNjei3UHqWVIPNiNM7zM8U8HNj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2869
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_08:2019-11-05,2019-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911050188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvNS8xOSAxOjE3IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIFNhdCwgTm92
IDIsIDIwMTkgYXQgMzowMyBQTSBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPiB3
cm90ZToNCj4+DQo+PiBUZWFjaCBsaWJicGYgdG8gcmVjb2duaXplIHRyYWNpbmcgcHJvZ3JhbXMg
dHlwZXMgYW5kIGF0dGFjaCB0aGVtIHRvDQo+PiBmZW50cnkvZmV4aXQuDQo+Pg0KPj4gU2lnbmVk
LW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPj4g
ICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAgMiArKw0KPj4gICB0b29scy9saWIv
YnBmL2xpYmJwZi5jICAgICAgICAgfCA1NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tDQo+PiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLmggICAgICAgICB8ICAyICsrDQo+PiAgIHRv
b2xzL2xpYi9icGYvbGliYnBmLm1hcCAgICAgICB8ICAxICsNCj4+ICAgNCBmaWxlcyBjaGFuZ2Vk
LCA1MyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS90
b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi90b29scy9pbmNsdWRlL3VhcGkvbGludXgv
YnBmLmgNCj4+IGluZGV4IGRmNjgwOWE3NjQwNC4uNjljMjAwZTZlNjk2IDEwMDY0NA0KPj4gLS0t
IGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+PiArKysgYi90b29scy9pbmNsdWRl
L3VhcGkvbGludXgvYnBmLmgNCj4+IEBAIC0yMDEsNiArMjAxLDggQEAgZW51bSBicGZfYXR0YWNo
X3R5cGUgew0KPj4gICAgICAgICAgQlBGX0NHUk9VUF9HRVRTT0NLT1BULA0KPj4gICAgICAgICAg
QlBGX0NHUk9VUF9TRVRTT0NLT1BULA0KPj4gICAgICAgICAgQlBGX1RSQUNFX1JBV19UUCwNCj4+
ICsgICAgICAgQlBGX1RSQUNFX0ZFTlRSWSwNCj4+ICsgICAgICAgQlBGX1RSQUNFX0ZFWElULA0K
Pj4gICAgICAgICAgX19NQVhfQlBGX0FUVEFDSF9UWVBFDQo+PiAgIH07DQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+
PiBpbmRleCA3YWEyYTJhMjJjZWYuLjAzZTc4NGYzNmRkOSAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xz
L2xpYi9icGYvbGliYnBmLmMNCj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+IEBA
IC0zNzQ0LDcgKzM3NDQsNyBAQCBicGZfb2JqZWN0X19sb2FkX3Byb2dzKHN0cnVjdCBicGZfb2Jq
ZWN0ICpvYmosIGludCBsb2dfbGV2ZWwpDQo+PiAgICAgICAgICByZXR1cm4gMDsNCj4+ICAgfQ0K
Pj4NCj4+IC1zdGF0aWMgaW50IGxpYmJwZl9hdHRhY2hfYnRmX2lkX2J5X25hbWUoY29uc3QgY2hh
ciAqbmFtZSwgX191MzIgKmJ0Zl9pZCk7DQo+PiArc3RhdGljIGludCBsaWJicGZfYXR0YWNoX2J0
Zl9pZF9ieV9uYW1lKGNvbnN0IGNoYXIgKm5hbWUsIF9fdTMyICpidGZfaWQsIGJvb2wgcmF3X3Rw
KTsNCj4gDQo+IEJvb2xzIGFyZSBoYXJkIHRvIGZvbGxvdyBpbiBjb2RlLCB3aHkgbm90IGp1c3Qg
cGFzc2luZyBmdWxsDQo+IGF0dGFjaF90eXBlIGluc3RlYWQ/IEl0IHdpbGwgYWxzbyBiZSBtb3Jl
IGZ1dHVyZS1wcm9vZiwgaWYgd2UgbmVlZA0KPiBhbm90aGVyIHRyaWNrLCBzaW1pbGFyIHRvICJi
cGZfdHJhY2VfIiBwcmVmaXggZm9yIHJhd190cD8NCj4gDQo+IEFsc28sIEkgaGF2ZSBhIG1pbGQg
cHJlZmVyZW5jZSBmb3IgaGF2aW5nIG91dHB1dCBhcmd1bWVudHMgdG8gYmUgdGhlDQo+IHZlcnkg
bGFzdCBpbiB0aGUgYXJndW1lbnQgbGlzdC4gRG8geW91IG1pbmQgcmVvcmRlcmluZyBzbyB0aGFy
IGJvb2wNCj4gcmF3X3RwIGlzIHNlY29uZD8NCg0KQWdyZWUgb24gYm90aCBjb3VudHMuIFNwb3R0
ZWQgYW5vdGhlciBzbWFsbCBuaXQgaW4gdGhpcyBmdW5jdGlvbg0Kd2hpbGUgdGVzdGluZyBjb3Ju
ZXIgY2FzZXMuDQpXaWxsIGZpeCB0aGlzIGFuZCBmZWVkYmFjayB0byA1LzcsIDcvNyBpbiB0aGUg
bmV4dCB2ZXJzaW9uLg0K
