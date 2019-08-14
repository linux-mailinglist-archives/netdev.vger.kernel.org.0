Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD38D7D8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHNQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:17:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727909AbfHNQRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:17:39 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7EGD8fl022953;
        Wed, 14 Aug 2019 09:17:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v9pBALoVkA8e+LDkKPT9mk/mWAqQW5o/V2MwR7qa+no=;
 b=pAFX90xVld7z57hQdiBgPOn/xzu135ZjJRs96ExOASiXYh44FFaKUXd8iE5enPdiA8Ut
 Rq4WammNY2fuFqmKRofpFYeLdtpwLgS7/RNyhgBKlYFjG2r3vaCWcfrY4PAVLiDMOt2h
 QRP3JlFKjKEAOCHar82pHHTtifa/evUYjaY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ucmc08dhd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 09:17:13 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 14 Aug 2019 09:17:11 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 14 Aug 2019 09:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzMDIPh361Q2hEuHaTzi2ne0lPxra401iKMCLMUC8q6q+P9swg4b28DJ7+MfJLDg0zjgF0CH1wNP1eDUqLWllSrDRmZxOvtI9m4FiIUv1lr8+1oFFS5Las5fXqOn//2Zy8sCT6MvL9kVGiWlwdRdFDedkVbQ2AgO4Nl6ttUiw1hmUbzTdX8E5KnWrRjSzIuY1c8/UALsVPwdAMTe2rpEsz+ccGrqL9ndSeBrWmbrfBN9rYC6lzrKN+aKE0ti26pXHz76L9WmecVDTxLUqkbgSZD1BBKcsg2SzsidaJNLaLsebCVtos5Sg3zRbBe4BGohHaVXnOuyaK1DEh6bKOz2nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9pBALoVkA8e+LDkKPT9mk/mWAqQW5o/V2MwR7qa+no=;
 b=UxuYrs8f7/1fzCij5+Irw7VnglcpucGQWehX8C9gwTdJfKAyp3Lvk0/xrtvg0q12vi4HTRcA5d6AkDCPWQIXOaI2IYvWZUC1pqeLBDPn3P1kCFPDrFOvhCP7Lu023JcQGynscLTVCOHFWfVnswEGssAdUW5iGAHnHC6JYqlq70ByXNpJyKBxG7X/SNMOOmkQCk8lqKRYw5n0MY3h8Xnh6mn6bzfn1lD4/edBG5TTiJjFBa6SaHTHT5HREeWb8+9Xdg2iATluGmH4yNOGSWJL40vpbh+kXfgBIQtPv5+BBAMlSQBDRCj9CsCaOpP/VDoDDvKfLtlocXuvAyk0PLt7KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9pBALoVkA8e+LDkKPT9mk/mWAqQW5o/V2MwR7qa+no=;
 b=KP2PrdBUqpiQB3oAGZlV5vnDxDnFNx8nJbLHJcxRgHeL6atnkHpSZIzhqW3TRApjDbajT+CPxS8vQz3vzw16WkvIO5+UbzXIzT/lb6tWDkDjR7Fj5mi0egs/EeLX0Z7dXwpIu1okoZcI8MA6AfRozyNSc53m65mvvtru+V6FUms=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2246.namprd15.prod.outlook.com (52.135.196.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Wed, 14 Aug 2019 16:17:09 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 16:17:09 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "john fastabend" <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Topic: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Index: AQHVUoIEKyrT2yAIekOTwiyoLftnBKb6ib+AgAAapgCAAC4GgA==
Date:   Wed, 14 Aug 2019 16:17:09 +0000
Message-ID: <8e8db765-cb2d-ca59-6712-5dd51ca83baf@fb.com>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan> <20190814115659.GC4142@khorivan>
 <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
In-Reply-To: <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0022.namprd17.prod.outlook.com
 (2603:10b6:301:14::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b5df]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 598ce849-83d5-469e-1b1e-08d720d2db88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2246;
x-ms-traffictypediagnostic: BYAPR15MB2246:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB224639C473EAF61B8BB6A35FD3AD0@BYAPR15MB2246.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(396003)(39860400002)(346002)(52314003)(199004)(189003)(102836004)(14454004)(86362001)(46003)(2616005)(99286004)(476003)(966005)(53936002)(8676002)(6306002)(31696002)(446003)(11346002)(66574012)(486006)(52116002)(76176011)(478600001)(305945005)(6506007)(386003)(25786009)(186003)(53546011)(7736002)(6246003)(110136005)(81166006)(81156014)(36756003)(66946007)(316002)(7416002)(66446008)(64756008)(66476007)(31686004)(6436002)(2906002)(66556008)(8936002)(71200400001)(71190400001)(5660300002)(6486002)(256004)(6116002)(6512007)(229853002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2246;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3CLGnUKUnJaD0B4GdWqduxUulMlW00brvpRxSnQ0daZ65kxeMCVKQHLPgm8WcFnzE0I6g/3QDyiyhh3qtku31h0ohCT9HwErBJ8F5gXbixKHRikXb+0aRqMvvw1g7POUejyr3YmmVVO9VjmheXhp2erYJXObvinzf3jW+SeiQ+heVmbFVn9dh2A56lKVz67ZxUJl6hxXJSS4OyIliGOk7JrOHBlfayBziIvtW9xhRAykSDDd+8l4mUM1Ottjek4z86q1l0TBhFQoOgQ4yWtY/Bi03nzs3zzAn2YrSkOPyuPH0on17sv2mIvxHcD6wUrkQynHkjlpbYXAkyk/Icm/O1MCETigU0kpJ2fta1IVwK74uYxFoCFpnA7JmlqzxeTE3R4QVxJXAey6ghm8l3ecCUb0oOyAC436GHXtkxtkJfk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <272FBCED56A08A4998F027F0A8B683B2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 598ce849-83d5-469e-1b1e-08d720d2db88
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 16:17:09.6804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lvm4ntFO+cipUwDsoI2oFJfam+vlZ8YzsUCS9HLsd4ZBoncAqjqEriGb/uQ3NmL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMTkgNjozMiBBTSwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gV2VkLCAx
NCBBdWcgMjAxOSBhdCAxMzo1NywgSXZhbiBLaG9yb256aHVrDQo+IDxpdmFuLmtob3JvbnpodWtA
bGluYXJvLm9yZz4gd3JvdGU6DQo+Pg0KPj4gT24gV2VkLCBBdWcgMTQsIDIwMTkgYXQgMTI6MjQ6
MDVQTSArMDMwMCwgSXZhbiBLaG9yb256aHVrIHdyb3RlOg0KPj4+IE9uIFR1ZSwgQXVnIDEzLCAy
MDE5IGF0IDA0OjM4OjEzUE0gLTA3MDAsIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4+Pg0KPj4+
IEhpLCBBbmRyaWkNCj4+Pg0KPj4+PiBPbiBUdWUsIEF1ZyAxMywgMjAxOSBhdCAzOjI0IEFNIEl2
YW4gS2hvcm9uemh1aw0KPj4+PiA8aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+IHdyb3RlOg0K
Pj4+Pj4NCj4+Pj4+IFRoYXQncyBuZWVkZWQgdG8gZ2V0IF9fTlJfbW1hcDIgd2hlbiBtbWFwMiBz
eXNjYWxsIGlzIHVzZWQuDQo+Pj4+Pg0KPj4+Pj4gU2lnbmVkLW9mZi1ieTogSXZhbiBLaG9yb256
aHVrIDxpdmFuLmtob3JvbnpodWtAbGluYXJvLm9yZz4NCj4+Pj4+IC0tLQ0KPj4+Pj4gdG9vbHMv
bGliL2JwZi94c2suYyB8IDEgKw0KPj4+Pj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
DQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYveHNrLmMgYi90b29scy9s
aWIvYnBmL3hzay5jDQo+Pj4+PiBpbmRleCA1MDA3YjVkNGZkMmMuLmYyZmM0MGY5ODA0YyAxMDA2
NDQNCj4+Pj4+IC0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+Pj4+ICsrKyBiL3Rvb2xzL2xp
Yi9icGYveHNrLmMNCj4+Pj4+IEBAIC0xMiw2ICsxMiw3IEBADQo+Pj4+PiAjaW5jbHVkZSA8c3Rk
bGliLmg+DQo+Pj4+PiAjaW5jbHVkZSA8c3RyaW5nLmg+DQo+Pj4+PiAjaW5jbHVkZSA8dW5pc3Rk
Lmg+DQo+Pj4+PiArI2luY2x1ZGUgPGFzbS91bmlzdGQuaD4NCj4+Pj4NCj4+Pj4gYXNtL3VuaXN0
ZC5oIGlzIG5vdCBwcmVzZW50IGluIEdpdGh1YiBsaWJicGYgcHJvamVjdGlvbi4gSXMgdGhlcmUg
YW55DQo+Pj4NCj4+PiBMb29rIG9uIGluY2x1ZGVzIGZyb20NCj4+PiB0b29scy9saWIvYnBmL2xp
YnBmLmMNCj4+PiB0b29scy9saWIvYnBmL2JwZi5jDQo+Pj4NCj4+PiBUaGF0J3MgaG93IGl0J3Mg
ZG9uZS4uLiBDb3BwaW5nIGhlYWRlcnMgdG8gYXJjaC9hcm0gd2lsbCBub3QNCj4+PiBzb2x2ZSB0
aGlzLCBpdCBpbmNsdWRlcyBib3RoIG9mIHRoZW0gYW55d2F5LCBhbmQgYW55d2F5IGl0IG5lZWRz
DQo+Pj4gYXNtL3VuaXN0ZC5oIGluY2x1c2lvbiBoZXJlLCBvbmx5IGJlY2F1c2UgeHNrLmMgbmVl
ZHMgX19OUl8qDQo+Pj4NCj4+Pg0KPj4NCj4+IFRoZXJlIGlzIG9uZSBtb3JlIHJhZGljYWwgc29s
dXRpb24gZm9yIHRoaXMgSSBjYW4gc2VuZCwgYnV0IEknbSBub3Qgc3VyZSBob3cgaXQNCj4+IGNh
biBpbXBhY3Qgb24gb3RoZXIgc3lzY2Fscy9hcmNoZXMuLi4NCj4+DQo+PiBMb29rcyBsaWtlOg0K
Pj4NCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9NYWtlZmlsZSBiL3Rvb2xzL2xp
Yi9icGYvTWFrZWZpbGUNCj4+IGluZGV4IDkzMTIwNjZhMWFlMy4uOGIyZjhmZjdjZTQ0IDEwMDY0
NA0KPj4gLS0tIGEvdG9vbHMvbGliL2JwZi9NYWtlZmlsZQ0KPj4gKysrIGIvdG9vbHMvbGliL2Jw
Zi9NYWtlZmlsZQ0KPj4gQEAgLTExMyw2ICsxMTMsNyBAQCBvdmVycmlkZSBDRkxBR1MgKz0gLVdl
cnJvciAtV2FsbA0KPj4gICBvdmVycmlkZSBDRkxBR1MgKz0gLWZQSUMNCj4+ICAgb3ZlcnJpZGUg
Q0ZMQUdTICs9ICQoSU5DTFVERVMpDQo+PiAgIG92ZXJyaWRlIENGTEFHUyArPSAtZnZpc2liaWxp
dHk9aGlkZGVuDQo+PiArb3ZlcnJpZGUgQ0ZMQUdTICs9IC1EX0ZJTEVfT0ZGU0VUX0JJVFM9NjQN
Cj4+DQo+IA0KPiBIbW0sIGlzbid0IHRoaXMgZ2xpYmMtaXNtPyBEb2VzIGlzIGl0IHdvcmsgZm9y
LCBzYXksIG11c2wgb3IgYmlvbmljPw0KPiANCj4gSWYgdGhpcyBpcyBwb3J0YWJsZSwgYW5kIHdv
cmtzIG9uIDMyLSwgYW5kIDY0LWJpdCBhcmNocywgSSdtIGhhcHB5DQo+IHdpdGggdGhlIHBhdGNo
LiA6LSkNCg0KU2Vjb25kIGhlcmUuIExvb2tzIGRlZmluaW5nIC1EX0ZJTEVfT0ZGU0VUX0JJVFM9
NjQgaXMgYSB3ZWxsIGtub3duDQpmaXggZm9yIDMyYml0IHN5c3RlbSB0byBkZWFsIHdpdGggZmls
ZXMgPiAyR0IuDQpJIHJlbWVtYmVyZWQgSSB1c2VkIGl0IGluIGRpc3RhbnQgcGFzdC4gVGhlIGJl
bG93IGxpbmsNCmFsc28gZXhwbGFpbnMgdGhlIGNhc2UuDQpodHRwczovL2RpZ2l0YWwtZG9tYWlu
Lm5ldC9sYXJnZWZpbGVzLmh0bWwNCg0KVGVzdGluZyBvbiBtdXNsIGlzIG5lY2Vzc2FyeSBhcyBB
cm5hbGRvJ3MgcGVyZiB0ZXN0IHN1aXRlDQppbmRlZWQgdGVzdGVkIGl0LiBQcm9iYWJseSBiaW9u
aWMgdG9vLCBub3QgcmVhbGx5IGZhbWlsaWFyIHdpdGggdGhhdC4NCg0KPiANCj4gDQo+IEJqw7Zy
bg0KPiANCj4+ICAgaWZlcSAoJChWRVJCT1NFKSwxKQ0KPj4gICAgIFEgPQ0KPj4gZGlmZiAtLWdp
dCBhL3Rvb2xzL2xpYi9icGYveHNrLmMgYi90b29scy9saWIvYnBmL3hzay5jDQo+PiBpbmRleCBm
MmZjNDBmOTgwNGMuLmZmMmQwM2I4MzgwZCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xzL2xpYi9icGYv
eHNrLmMNCj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+IEBAIC03NSwyMyArNzUsNiBA
QCBzdHJ1Y3QgeHNrX25sX2luZm8gew0KPj4gICAgICAgICAgaW50IGZkOw0KPj4gICB9Ow0KPj4N
Cj4+IC0vKiBGb3IgMzItYml0IHN5c3RlbXMsIHdlIG5lZWQgdG8gdXNlIG1tYXAyIGFzIHRoZSBv
ZmZzZXRzIGFyZSA2NC1iaXQuDQo+PiAtICogVW5mb3J0dW5hdGVseSwgaXQgaXMgbm90IHBhcnQg
b2YgZ2xpYmMuDQo+PiAtICovDQo+PiAtc3RhdGljIGlubGluZSB2b2lkICp4c2tfbW1hcCh2b2lk
ICphZGRyLCBzaXplX3QgbGVuZ3RoLCBpbnQgcHJvdCwgaW50IGZsYWdzLA0KPj4gLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBpbnQgZmQsIF9fdTY0IG9mZnNldCkNCj4+IC17DQo+PiAtI2lm
ZGVmIF9fTlJfbW1hcDINCj4+IC0gICAgICAgdW5zaWduZWQgaW50IHBhZ2Vfc2hpZnQgPSBfX2J1
aWx0aW5fZmZzKGdldHBhZ2VzaXplKCkpIC0gMTsNCj4+IC0gICAgICAgbG9uZyByZXQgPSBzeXNj
YWxsKF9fTlJfbW1hcDIsIGFkZHIsIGxlbmd0aCwgcHJvdCwgZmxhZ3MsIGZkLA0KPj4gLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgKG9mZl90KShvZmZzZXQgPj4gcGFnZV9zaGlmdCkpOw0KPj4g
LQ0KPj4gLSAgICAgICByZXR1cm4gKHZvaWQgKilyZXQ7DQo+PiAtI2Vsc2UNCj4+IC0gICAgICAg
cmV0dXJuIG1tYXAoYWRkciwgbGVuZ3RoLCBwcm90LCBmbGFncywgZmQsIG9mZnNldCk7DQo+PiAt
I2VuZGlmDQo+PiAtfQ0KPj4gLQ0KPj4gICBpbnQgeHNrX3VtZW1fX2ZkKGNvbnN0IHN0cnVjdCB4
c2tfdW1lbSAqdW1lbSkNCj4+ICAgew0KPj4gICAgICAgICAgcmV0dXJuIHVtZW0gPyB1bWVtLT5m
ZCA6IC1FSU5WQUw7DQo+PiBAQCAtMjExLDEwICsxOTQsOSBAQCBpbnQgeHNrX3VtZW1fX2NyZWF0
ZShzdHJ1Y3QgeHNrX3VtZW0gKip1bWVtX3B0ciwgdm9pZCAqdW1lbV9hcmVhLCBfX3U2NCBzaXpl
LA0KPj4gICAgICAgICAgICAgICAgICBnb3RvIG91dF9zb2NrZXQ7DQo+PiAgICAgICAgICB9DQo+
Pg0KPj4gLSAgICAgICBtYXAgPSB4c2tfbW1hcChOVUxMLCBvZmYuZnIuZGVzYyArDQo+PiAtICAg
ICAgICAgICAgICAgICAgICAgIHVtZW0tPmNvbmZpZy5maWxsX3NpemUgKiBzaXplb2YoX191NjQp
LA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBf
U0hBUkVEIHwgTUFQX1BPUFVMQVRFLA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICB1bWVtLT5m
ZCwgWERQX1VNRU1fUEdPRkZfRklMTF9SSU5HKTsNCj4+ICsgICAgICAgbWFwID0gbW1hcChOVUxM
LCBvZmYuZnIuZGVzYyArIHVtZW0tPmNvbmZpZy5maWxsX3NpemUgKiBzaXplb2YoX191NjQpLA0K
Pj4gKyAgICAgICAgICAgICAgICAgIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsIE1BUF9TSEFSRUQg
fCBNQVBfUE9QVUxBVEUsIHVtZW0tPmZkLA0KPj4gKyAgICAgICAgICAgICAgICAgIFhEUF9VTUVN
X1BHT0ZGX0ZJTExfUklORyk7DQo+PiAgICAgICAgICBpZiAobWFwID09IE1BUF9GQUlMRUQpIHsN
Cj4+ICAgICAgICAgICAgICAgICAgZXJyID0gLWVycm5vOw0KPj4gICAgICAgICAgICAgICAgICBn
b3RvIG91dF9zb2NrZXQ7DQo+PiBAQCAtMjI4LDEwICsyMTAsOSBAQCBpbnQgeHNrX3VtZW1fX2Ny
ZWF0ZShzdHJ1Y3QgeHNrX3VtZW0gKip1bWVtX3B0ciwgdm9pZCAqdW1lbV9hcmVhLCBfX3U2NCBz
aXplLA0KPj4gICAgICAgICAgZmlsbC0+cmluZyA9IG1hcCArIG9mZi5mci5kZXNjOw0KPj4gICAg
ICAgICAgZmlsbC0+Y2FjaGVkX2NvbnMgPSB1bWVtLT5jb25maWcuZmlsbF9zaXplOw0KPj4NCj4+
IC0gICAgICAgbWFwID0geHNrX21tYXAoTlVMTCwNCj4+IC0gICAgICAgICAgICAgICAgICAgICAg
b2ZmLmNyLmRlc2MgKyB1bWVtLT5jb25maWcuY29tcF9zaXplICogc2l6ZW9mKF9fdTY0KSwNCj4+
IC0gICAgICAgICAgICAgICAgICAgICAgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwgTUFQX1NIQVJF
RCB8IE1BUF9QT1BVTEFURSwNCj4+IC0gICAgICAgICAgICAgICAgICAgICAgdW1lbS0+ZmQsIFhE
UF9VTUVNX1BHT0ZGX0NPTVBMRVRJT05fUklORyk7DQo+PiArICAgICAgIG1hcCA9IG1tYXAoTlVM
TCwgb2ZmLmNyLmRlc2MgKyB1bWVtLT5jb25maWcuY29tcF9zaXplICogc2l6ZW9mKF9fdTY0KSwN
Cj4+ICsgICAgICAgICAgICAgICAgICBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfU0hBUkVE
IHwgTUFQX1BPUFVMQVRFLCB1bWVtLT5mZCwNCj4+ICsgICAgICAgICAgICAgICAgICBYRFBfVU1F
TV9QR09GRl9DT01QTEVUSU9OX1JJTkcpOw0KPj4gICAgICAgICAgaWYgKG1hcCA9PSBNQVBfRkFJ
TEVEKSB7DQo+PiAgICAgICAgICAgICAgICAgIGVyciA9IC1lcnJubzsNCj4+ICAgICAgICAgICAg
ICAgICAgZ290byBvdXRfbW1hcDsNCj4+IEBAIC01NTIsMTEgKzUzMywxMCBAQCBpbnQgeHNrX3Nv
Y2tldF9fY3JlYXRlKHN0cnVjdCB4c2tfc29ja2V0ICoqeHNrX3B0ciwgY29uc3QgY2hhciAqaWZu
YW1lLA0KPj4gICAgICAgICAgfQ0KPj4NCj4+ICAgICAgICAgIGlmIChyeCkgew0KPj4gLSAgICAg
ICAgICAgICAgIHJ4X21hcCA9IHhza19tbWFwKE5VTEwsIG9mZi5yeC5kZXNjICsNCj4+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB4c2stPmNvbmZpZy5yeF9zaXplICogc2l6ZW9m
KHN0cnVjdCB4ZHBfZGVzYyksDQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
UFJPVF9SRUFEIHwgUFJPVF9XUklURSwNCj4+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBNQVBfU0hBUkVEIHwgTUFQX1BPUFVMQVRFLA0KPj4gLSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHhzay0+ZmQsIFhEUF9QR09GRl9SWF9SSU5HKTsNCj4+ICsgICAgICAgICAg
ICAgICByeF9tYXAgPSBtbWFwKE5VTEwsIG9mZi5yeC5kZXNjICsNCj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHhzay0+Y29uZmlnLnJ4X3NpemUgKiBzaXplb2Yoc3RydWN0IHhkcF9k
ZXNjKSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBST1RfUkVBRCB8IFBST1Rf
V1JJVEUsIE1BUF9TSEFSRUQgfCBNQVBfUE9QVUxBVEUsDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB4c2stPmZkLCBYRFBfUEdPRkZfUlhfUklORyk7DQo+PiAgICAgICAgICAgICAg
ICAgIGlmIChyeF9tYXAgPT0gTUFQX0ZBSUxFRCkgew0KPj4gICAgICAgICAgICAgICAgICAgICAg
ICAgIGVyciA9IC1lcnJubzsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9z
b2NrZXQ7DQo+PiBAQCAtNTcxLDExICs1NTEsMTAgQEAgaW50IHhza19zb2NrZXRfX2NyZWF0ZShz
dHJ1Y3QgeHNrX3NvY2tldCAqKnhza19wdHIsIGNvbnN0IGNoYXIgKmlmbmFtZSwNCj4+ICAgICAg
ICAgIHhzay0+cnggPSByeDsNCj4+DQo+PiAgICAgICAgICBpZiAodHgpIHsNCj4+IC0gICAgICAg
ICAgICAgICB0eF9tYXAgPSB4c2tfbW1hcChOVUxMLCBvZmYudHguZGVzYyArDQo+PiAtICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgeHNrLT5jb25maWcudHhfc2l6ZSAqIHNpemVvZihz
dHJ1Y3QgeGRwX2Rlc2MpLA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBS
T1RfUkVBRCB8IFBST1RfV1JJVEUsDQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgTUFQX1NIQVJFRCB8IE1BUF9QT1BVTEFURSwNCj4+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB4c2stPmZkLCBYRFBfUEdPRkZfVFhfUklORyk7DQo+PiArICAgICAgICAgICAg
ICAgdHhfbWFwID0gbW1hcChOVUxMLCBvZmYudHguZGVzYyArDQo+PiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB4c2stPmNvbmZpZy50eF9zaXplICogc2l6ZW9mKHN0cnVjdCB4ZHBfZGVz
YyksDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBQUk9UX1JFQUQgfCBQUk9UX1dS
SVRFLCBNQVBfU0hBUkVEIHwgTUFQX1BPUFVMQVRFLA0KPj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgeHNrLT5mZCwgWERQX1BHT0ZGX1RYX1JJTkcpOw0KPj4gICAgICAgICAgICAgICAg
ICBpZiAodHhfbWFwID09IE1BUF9GQUlMRUQpIHsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICBlcnIgPSAtZXJybm87DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXRfbW1h
cF9yeDsNCj4+DQo+Pg0KPj4gSWYgbWFpbnRhaW5lcnMgYXJlIHJlYWR5IHRvIGFjY2VwdCB0aGlz
IEkgY2FuIHNlbmQuDQo+PiBXaGF0IGRvIHlvdSBzYXk/DQo+Pg0KPj4gLS0NCj4+IFJlZ2FyZHMs
DQo+PiBJdmFuIEtob3JvbnpodWsNCg==
