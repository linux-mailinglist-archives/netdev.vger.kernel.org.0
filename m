Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927BC10A73A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKZXrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:47:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbfKZXrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:47:41 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAQNiwlb002827;
        Tue, 26 Nov 2019 15:47:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nR8t66Y4UXgoPIDPa7B6pei/wzLIL3UWkRNA6kXecgY=;
 b=cggcwCmVVy03GVu3sIZRnzNq6QbAs6xJE6CxCzmhm1SvJLsVh7iuAA6Ym5WMlwPf7jMK
 8F2yWp3Zall2B02OdL8laUbRwl/8B8rcNfwuiYaNbQSm/1kHfhkHNGFNhrBcMkVgXgzQ
 hVuV+6OH0vuzBxHALr/Z1snu1TKYolxQFvw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2whcy30dmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 15:47:23 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 26 Nov 2019 15:47:22 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 26 Nov 2019 15:47:21 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 15:47:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM1xmwCpItqmtsOY7nGnPWPVfFU1t2wCfyZkDdFy8dIG+M3BcJfCQrxEWYLqr8vq2zINiRrloKV+xQkQTAaPYeHcC5Lfl3dlKmfd3ziqas1tDWIGBU0xa7Bwrn8XkDb1WUjFWFtJV0dICnL73T16Y+Id6WkffGLKDMUzB89k+w58amWpuaIyLfpggjK6MKOpTalSUh24sdwPxLMJFnivdfo9qwo/QOlQ2L0TCSCYJ2zpjtGQW+f3todeoxWu54u5mlXfCWn9AiTWq/wF2BhLKARrIEj5lcQm/+0woU8a0+65+nU5WcrshhktKctl1Wq4MyxZGvHzm0jhyChcJpGepw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR8t66Y4UXgoPIDPa7B6pei/wzLIL3UWkRNA6kXecgY=;
 b=OJuCFVC8rD5IpYcVI0QR4hRQdjpa2BR5uAqepDoV9hzvG0AbgKGGyQZpuhXyPN9M4jesYhl/xepauGECcjsik6HJC6pRTYSPetgDSFyKYPxy7p81IQnCU5Y9j1qAZvQTVbRhyNmeDbgIL2gKhpN+5rTYcwhCAv541tDHoxKp++kDhGTo+ujm0fZia8FxEhpt6W3ca3xCl1FT5fPndQ/wcsA6s7xeitHQ+1thUWvc04IyKOFKcnn33M4dOld9Pm+ib4xUU3kKwAEggfUWCL/PXw4j4wsECiCtP6KkgkMDmbFs7ZTSmc5FLPbN9agmC9jIK3vgK9Pn6zzSoXW+oXBjBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR8t66Y4UXgoPIDPa7B6pei/wzLIL3UWkRNA6kXecgY=;
 b=bP37kkStSuIrHq6Sq/tx4WxamceF3kVepwcVqDYEGwdN74LIX72rSRkfUpBKq4C3W4g1Jw1kXCZe6CqE8qMKY9/lDjC31n5eOFhSjoex9QvsS52k9q1Ls1+pthfhqEBGvoQb2icOIOxmGLjyKPPacP9im3rQHdWoS01Lpmyud2Y=
Received: from CY4PR15MB1206.namprd15.prod.outlook.com (10.172.182.17) by
 CY4PR15MB1560.namprd15.prod.outlook.com (10.172.162.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Tue, 26 Nov 2019 23:47:07 +0000
Received: from CY4PR15MB1206.namprd15.prod.outlook.com
 ([fe80::685e:e18b:36d6:e36f]) by CY4PR15MB1206.namprd15.prod.outlook.com
 ([fe80::685e:e18b:36d6:e36f%8]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 23:47:07 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for vmlinux
 BTF
Thread-Topic: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for
 vmlinux BTF
Thread-Index: AQHVpLEys+bl2TgVWEaJTkl587y446eeG06AgAACc4CAAAB4AA==
Date:   Tue, 26 Nov 2019 23:47:06 +0000
Message-ID: <02a27e2f-d269-0b04-a4ef-ebb347e3c918@fb.com>
References: <20191126232818.226454-1-sdf@google.com>
 <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
 <20191126234523.GF3145429@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20191126234523.GF3145429@mini-arch.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0103.namprd15.prod.outlook.com
 (2603:10b6:101:21::23) To CY4PR15MB1206.namprd15.prod.outlook.com
 (2603:10b6:903:114::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:49cd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db4f1b1a-2937-415c-a0cb-08d772caf213
x-ms-traffictypediagnostic: CY4PR15MB1560:
x-microsoft-antispam-prvs: <CY4PR15MB156087CEE4E19F9EBB7C714FC6450@CY4PR15MB1560.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(8936002)(2616005)(86362001)(66946007)(81156014)(81166006)(58126008)(52116002)(65806001)(110136005)(66446008)(5660300002)(2906002)(14444005)(316002)(386003)(6116002)(65956001)(66476007)(6436002)(6486002)(11346002)(36756003)(99286004)(14454004)(229853002)(446003)(6506007)(31696002)(256004)(54906003)(8676002)(25786009)(478600001)(71190400001)(64756008)(71200400001)(46003)(66556008)(4326008)(31686004)(76176011)(186003)(305945005)(102836004)(6512007)(53546011)(7736002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1560;H:CY4PR15MB1206.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aKUXfbTzguAp/5lu/F6WoAzywztl1lzQrd88rgT9tZl/lCKfJaRqEvl+Q7QgmBobN3e6fdFPFQIuk/MEjoVpcltEkFCYbsWrlDTp/GCprXWULQ+HqSu8sz1HVIktSUMHvJea9tsZLi/LKcn5ns7o7MyttXF+Gc5nf9JkiZ7qLBdkBU1cykakUO7B82Cg7UcgKqV2/10w22Pmf9F0IsGnorlAZG8HmUeNdkK6RYyiXuvPo9p38CKr9qlah1jrXsxymGDrDy57bVTEV3bepjFs6iUyb+mDPwhfR5II+gTMyX+TDCjHW6oI49BmlR0lZ5uoyZ1tJAL/N8tZiK5L2vPD3bXRcHL4ez/byg7zUpy6RLUvMflafq9gZSzl1PFFIfK8U9DZZwHDxNWZUK0xrRaSYdAu0n09GhSrXfc/IGpuJm7wzjP62kxSGB0AoUqMLIPS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3CAD2BD695E5E4CBBEE724249ECE9CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db4f1b1a-2937-415c-a0cb-08d772caf213
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 23:47:06.8896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFr4dX3WEpEsV+OBB4swEaYkqjxY+Wbq4SoiVRHGPOOQ/Z9a+V4i4JRdNLwMuxlD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1560
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_08:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1011 impostorscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjYvMTkgMzo0NSBQTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBPbiAxMS8y
NiwgSm9obiBGYXN0YWJlbmQgd3JvdGU6DQo+PiBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+
Pj4gSWYgdm1saW51eCBCVEYgZ2VuZXJhdGlvbiBmYWlscywgYnV0IENPTkZJR19ERUJVR19JTkZP
X0JURiBpcyBzZXQsDQo+Pj4gLkJURiBzZWN0aW9uIG9mIHZtbGludXggaXMgZW1wdHkgYW5kIGtl
cm5lbCB3aWxsIHByb2hpYml0DQo+Pj4gQlBGIGxvYWRpbmcgYW5kIHJldHVybiAiaW4ta2VybmVs
IEJURiBpcyBtYWxmb3JtZWQiLg0KPj4+DQo+Pj4gLS1kdW1wLXNlY3Rpb24gYXJndW1lbnQgdG8g
YmludXRpbHMnIG9iamNvcHkgd2FzIGFkZGVkIGluIHZlcnNpb24gMi4yNS4NCj4+PiBXaGVuIHVz
aW5nIHByZS0yLjI1IGJpbnV0aWxzLCBCVEYgZ2VuZXJhdGlvbiBzaWxlbnRseSBmYWlscy4gQ29u
dmVydA0KPj4+IHRvIC0tb25seS1zZWN0aW9uIHdoaWNoIGlzIHByZXNlbnQgb24gcHJlLTIuMjUg
YmludXRpbHMuDQo+Pj4NCj4+PiBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvY2hhbmdlcy5yc3Qgc3Rh
dGVzIHRoYXQgYmludXRpbHMgMi4yMSsNCj4+PiBpcyBzdXBwb3J0ZWQsIG5vdCBzdXJlIHRob3Nl
IHN0YW5kYXJkcyBhcHBseSB0byBCUEYgc3Vic3lzdGVtLg0KPj4+DQo+Pj4gdjI6DQo+Pj4gKiBl
eGl0IGFuZCBwcmludCBhbiBlcnJvciBpZiBnZW5fYnRmIGZhaWxzIChKb2huIEZhc3RhYmVuZCkN
Cj4+Pg0KPj4+IENjOiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPj4+IENjOiBK
b2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPg0KPj4+IEZpeGVzOiAzNDFk
ZmNmOGQ3OGVhICgiYnRmOiBleHBvc2UgQlRGIGluZm8gdGhyb3VnaCBzeXNmcyIpDQo+Pj4gU2ln
bmVkLW9mZi1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4+PiAtLS0N
Cj4+PiAgIHNjcmlwdHMvbGluay12bWxpbnV4LnNoIHwgNyArKysrKystDQo+Pj4gICAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4NCj4+PiBkaWZmIC0t
Z2l0IGEvc2NyaXB0cy9saW5rLXZtbGludXguc2ggYi9zY3JpcHRzL2xpbmstdm1saW51eC5zaA0K
Pj4+IGluZGV4IDA2NDk1Mzc5ZmNkOC4uMjk5OGRkYjMyM2UzIDEwMDc1NQ0KPj4+IC0tLSBhL3Nj
cmlwdHMvbGluay12bWxpbnV4LnNoDQo+Pj4gKysrIGIvc2NyaXB0cy9saW5rLXZtbGludXguc2gN
Cj4+PiBAQCAtMTI3LDcgKzEyNyw4IEBAIGdlbl9idGYoKQ0KPj4+ICAgCQljdXQgLWQsIC1mMSB8
IGN1dCAtZCcgJyAtZjIpDQo+Pj4gICAJYmluX2Zvcm1hdD0kKExBTkc9QyAke09CSkRVTVB9IC1m
ICR7MX0gfCBncmVwICdmaWxlIGZvcm1hdCcgfCBcDQo+Pj4gICAJCWF3ayAne3ByaW50ICQ0fScp
DQo+Pj4gLQkke09CSkNPUFl9IC0tZHVtcC1zZWN0aW9uIC5CVEY9LmJ0Zi52bWxpbnV4LmJpbiAk
ezF9IDI+L2Rldi9udWxsDQo+Pj4gKwkke09CSkNPUFl9IC0tc2V0LXNlY3Rpb24tZmxhZ3MgLkJU
Rj1hbGxvYyAtTyBiaW5hcnkgXA0KPj4+ICsJCS0tb25seS1zZWN0aW9uPS5CVEYgJHsxfSAuYnRm
LnZtbGludXguYmluIDI+L2Rldi9udWxsDQo+Pj4gICAJJHtPQkpDT1BZfSAtSSBiaW5hcnkgLU8g
JHtiaW5fZm9ybWF0fSAtQiAke2Jpbl9hcmNofSBcDQo+Pj4gICAJCS0tcmVuYW1lLXNlY3Rpb24g
LmRhdGE9LkJURiAuYnRmLnZtbGludXguYmluICR7Mn0NCj4+PiAgIH0NCj4+PiBAQCAtMjUzLDYg
KzI1NCwxMCBAQCBidGZfdm1saW51eF9iaW5fbz0iIg0KPj4+ICAgaWYgWyAtbiAiJHtDT05GSUdf
REVCVUdfSU5GT19CVEZ9IiBdOyB0aGVuDQo+Pj4gICAJaWYgZ2VuX2J0ZiAudG1wX3ZtbGludXgu
YnRmIC5idGYudm1saW51eC5iaW4ubyA7IHRoZW4NCj4+PiAgIAkJYnRmX3ZtbGludXhfYmluX289
LmJ0Zi52bWxpbnV4LmJpbi5vDQo+Pj4gKwllbHNlDQo+Pj4gKwkJZWNobyA+JjIgIkZhaWxlZCB0
byBnZW5lcmF0ZSBCVEYgZm9yIHZtbGludXgiDQo+Pj4gKwkJZWNobyA+JjIgIlRyeSB0byBkaXNh
YmxlIENPTkZJR19ERUJVR19JTkZPX0JURiINCj4+DQo+PiBJIHRoaW5rIHdlIHNob3VsZCBlbmNv
dXJhZ2UgdXBncmFkaW5nIGJpbnV0aWxzIGZpcnN0PyBNYXliZQ0KPj4NCj4+ICJiaW51dGlscyAy
LjI1KyByZXF1aXJlZCBmb3IgQlRGIHBsZWFzZSB1cGdyYWRlIG9yIGRpc2FibGUgQ09ORklHX0RF
QlVHX0lORk9fQlRGIg0KPj4NCj4+IG90aGVyd2lzZSBJIGd1ZXNzIGl0cyBnb2luZyB0byBiZSBh
IGJpdCBteXN0aWNhbCB3aHkgaXQgd29ya3MgaW4NCj4+IGNhc2VzIGFuZCBub3Qgb3RoZXJzIHRv
IGZvbGtzIHVuZmFtaWxpYXIgd2l0aCB0aGUgZGV0YWlscy4NCj4gV2l0aCB0aGUgY29udmVyc2lv
biBmcm9tIC0tZHVtcC1zZWN0aW9uIHRvIC0tb25seS1zZWN0aW9uIHRoYXQgSQ0KPiBkaWQgaW4g
dGhpcyBwYXRjaCwgYmludXRpbHMgMi4yNSsgaXMgbm8gbG9uZ2VyIGEgcmVxdWlyZW1lbnQuDQo+
IDIuMjEgKG1pbmltYWwgdmVyc2lvbiBmcm9tIERvY3VtZW50YXRpb24vcHJvY2Vzcy9jaGFuZ2Vz
LnJzdCkgc2hvdWxkIHdvcmsNCj4ganVzdCBmaW5lLg0KDQpZZWFoLCBpbnN0ZWFkIGl0J3MgYmV0
dGVyIHRvIG1lbnRpb24gdGhhdCBwYWhvbGUgdjEuMTMrIGlzIHJlcXVpcmVkLg0KDQo+IA0KDQo=
