Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D2135E3DA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245277AbhDMQ12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:27:28 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:46064 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244786AbhDMQ11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:27:27 -0400
Received: from pps.filterd (m0209326.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DG9mth019574;
        Tue, 13 Apr 2021 16:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=TzgmIrKocDTugP6dAJe90Ya7xmPmD/tMAeZ7bZo11ck=;
 b=lQh6vDVOd9Wo5K9O5wxqWZxtP62KDvFOGlBhWmeSCzJyLFMnF1oATVgezl3JFq87hUDu
 26tWFlJU1wMHJuumiF112+BFpIejwNKFzGopf/aGQy3uuTKbq44nCpbC2dka1HOql0Ni
 VAl9G52XluhDVN9dhMeJ4UDsMEItn2VTJ1xmdR8+IFDNsNrEHMPOnoSY2oq4dMs+us15
 0aE0uDCvzFVLJvYKkNJaA5QG8vfGc2SmvjzVC19+HP+VAQd96HwOBHsqDTJrjvE8icQI
 C8hxZBNWoEQYimBTs8LMjN1h7lX52JAm1vTZoCI8wJOSSRjRN/FhpfNzhhrjtijq0sq6 Hw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx08-001d1705.pphosted.com with ESMTP id 37u27m25d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 16:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTVLBIgXHXIDMnM3AEOzmZIsW4u4KQ6fYp+Kn+WkFJoIK7oJ1jnAChG45y5/LsRQRDvCOCPO3WSEbSUq5SUrFzr53Bu3dS/Cfaw1nBg+X9EscyEFyFZBjZwmWExPfW1VjRUvqm6xH5Ss+kqIg8yXSz1B647+oUzlgLh+z4SC13ebxQ84uEhEghP8HtD57Pm9xsL4VVVIacFnj1zjrBUe0MSDIpLIMUaQSFYLEjnR6gVVtMRKYKQ+A4LJZEGub6fIXiIr8Ednt2grQ2HprDcYLrtiHC5sQcSqVU35gGLxZ4hnnPKupxl8EfApDVo3EG2UqTUU3zcs2yDwu+bmOUHF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzgmIrKocDTugP6dAJe90Ya7xmPmD/tMAeZ7bZo11ck=;
 b=CJqxdeeozA489b2pGlF14VfzajF58Gm9t5vEtNNBF26i20J6l1gShPh/xGR8seb5UcnpgPDqWeLNI+X7qNmklRi/YNcbmV/LXlxhG01zq5aHhQIJ7uPffAzVL1l5BG3DeZEgj2o/mYWeNjqix0RyDxbhXYDlK2uDyW2vIN/Joad2Aidi43wWp4f/JJanmM3ZER3nI56rv9OYOXcrmBuaxIiWu2oFHUo37PF8DXBRFKqyGtXjJjsJSAAK5CGJi/bjvaoCcRr2H6CoozSAgqC0RG1hzAZFTtCWdW/L+8gKsXKVBLVZ0skoP88S1TJAEQSFQa7FIBzFW9wUMAjIRnnfcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BN7PR13MB2499.namprd13.prod.outlook.com (2603:10b6:406:ac::18)
 by BN0PR13MB4743.namprd13.prod.outlook.com (2603:10b6:408:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6; Tue, 13 Apr
 2021 16:10:27 +0000
Received: from BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6]) by BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6%7]) with mapi id 15.20.3999.016; Tue, 13 Apr 2021
 16:10:27 +0000
From:   <Tim.Bird@sony.com>
To:     <alexei.starovoitov@gmail.com>, <yang.lee@linux.alibaba.com>
CC:     <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Topic: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Index: AQHXMErV8JcfI63Nok6Yi06yGd1P+6qyj46AgAAONpA=
Date:   Tue, 13 Apr 2021 16:10:27 +0000
Message-ID: <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
In-Reply-To: <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=sony.com;
x-originating-ip: [136.175.96.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5026152-e973-4986-871d-08d8fe96a6f5
x-ms-traffictypediagnostic: BN0PR13MB4743:
x-microsoft-antispam-prvs: <BN0PR13MB47437E1F5A1D35B60410C551FD4F9@BN0PR13MB4743.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gukdu51KGhoEZEnAOYX9Zdmf+modY4qS3iphO0d+pLj8h+iPFP3hxeCf0pvtV6pefNV0XhcUvIKUsT/VQcomqjhLUTos5DqmQewZpIXDY5VofmaaXaPrKsVW6hINsD7l2TvNiZ+l5PD8nK6pewXfmIUs9o5xpM1m92U5X3W6/R9yww2XNzOtR2lbRkcXZmgiTWIZ5KQ3j4YL8rkaycd0FdawLZ5XKlMsg1VA4PjIKRD9xnaic34JNpseYBuA0j77FNhDz2HLvLMrfHURHQgjmjbXs8GzjzzIJOJnufGk1Fz7nEHTl3d0tswYQ/VZ1Vo5pR/5KoXbFwqfXFEWA82JImjfQvNF2BE98maa2AAArj7Lj5JNepPUYZsgYN8yamIKJ3m1cEMjIWEUW213yrzogHrXn0ItffZOppGg/6LVs/2lGPpLCIOIXTNPPcvzg75t3ILNIcwJt/4HOPhB1NwhS5D1w5vKzyE+M2DXXCt8hRIqcYhn+UnuulYmdT0+y4DkgDt4tfLH/c3rCvGZF6BPkIq8ZfFWWElAJXJ58pErsD9oN1Ax9sLG3/ISglu0/0X+SByExmKpjWe/AgYRUV/e79PgC6xJfKUzvjhNkbfSwc0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR13MB2499.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(186003)(5660300002)(86362001)(6506007)(66476007)(2906002)(53546011)(52536014)(64756008)(66446008)(71200400001)(66556008)(76116006)(66946007)(83380400001)(9686003)(26005)(478600001)(8676002)(33656002)(8936002)(4326008)(110136005)(38100700002)(54906003)(7696005)(55016002)(122000001)(316002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Yy9ZTkQrcjFFdSt1cXROc2lXeEZmRUFoVGMvS1Y0MHVjUk9SRGVmMllXb2Fp?=
 =?utf-8?B?cVMxSGZOMUdqUThZK0w5RjBTY0p4RUdBbXFoQWQxeFZhQjBETjBmNFZMOWxl?=
 =?utf-8?B?eTRYNnZiV1hsOWg0dEhycjBnanVWQzF2VkxKeVFDVzV1TWk0aGR4d0hWMHNX?=
 =?utf-8?B?azdXZERweWdFanRCdVd1SmF5c3h6R2pnRE1DNjdGY2F2YzgrMDl3Y1BNWmgz?=
 =?utf-8?B?M1pHS09LR2ZwTEZacGJXWWRoQm9ib2FTbjZhQ2xSUHRwWmRHbzc0c1U5YlZo?=
 =?utf-8?B?MWhHcWd0a3pBc1M1bTUwT3p3M2g4VVo0eFFTUDVuUFEybFBSa2NzNUxhRFgr?=
 =?utf-8?B?NitpMFpqZGlFaFJYV2w0OFFsLzlCVHAxdjk3dHZhQlUrazNxV2Z1cEp5Mnhu?=
 =?utf-8?B?TTJXSEcwb1hvRUtaY204UTEwUjBKcTdQZlNRSTBrV2lqNW1yZEw0QzFLZ1dG?=
 =?utf-8?B?K0NsMEE3Sm5hOE9uSXN1aDVkOFBobHBGak8yOWgzK0hoMGtxcjJsVVRxb2M5?=
 =?utf-8?B?VE5idy9reUhzZjRFYzRrY2o1K2JDWXd5d2NJeUJCdFM0ckhoWlU5SEVOSUhO?=
 =?utf-8?B?dEl3b1dhWUYxTEFMZk1HSDZQem5MbzVGeE1JUU5ncklKSkNwbW9pSE1veUZh?=
 =?utf-8?B?Mnp6ZGVEc1B2cW1tRVQzWXJRbmU0N3J2Ym9GK2pISHRFNVdGNWRWOUNVZnJH?=
 =?utf-8?B?eHJWV0tncHFuRi96K3ZQNWFCd3FzZ2F3eEtlN0tlUmdBSlB4RXcwM3BLTjA0?=
 =?utf-8?B?aEhIendQaHlOT0hFNXdvU1h2eWVLNS9uZWh6ZlN6cVJtQWxxR1RRcmJuYjZ1?=
 =?utf-8?B?QUYrQk1Ra0xlY2QyYUV1VGs0L0NlMVFaOXJoSktNdWNocnltOEpnMUhsVHdJ?=
 =?utf-8?B?NEJKbXRvaGMxRHEzTVpwN3lWY3dDZXkxNmcrd0lxeHppcXdFQUkveUU2RVR4?=
 =?utf-8?B?Sm5OYTZNVXpjYVJYQnp5RnpDZFNBR2orbzgwZGhHN1h2UkRmN0V0WnMrYXd2?=
 =?utf-8?B?clpBTkFCWjlCQ1VvTUdXWThiTE9WVHdoWThwWjdvZ2ZqdDVqZjl2dS92ZTRx?=
 =?utf-8?B?by9zMUU1WnVYRkloOGRxdk5DTE9YUzltU0poR0NxMmg4WllaZ2RBNnMzUEh3?=
 =?utf-8?B?emt3aC8rbWdZTjlGMm5qSXJ2KzJMRmxXTDZIRzh5di9XbkVQRkRaZTBFS2Ez?=
 =?utf-8?B?M1JDRDlUbm9TYUUyL1QwZGxVaFRaNkRHdzFSYzd2QzZvemd0ODloM1dKNGVV?=
 =?utf-8?B?UjRGZXV2bVU2UitpOVNjT2x3WmJGbllzenJXWmUrVlV2d1dLSjE1bDA3WVMr?=
 =?utf-8?B?WStsckg2cHpPOGY4MFVLSWVaMWg5VTRZbkVmNS8venhLb0VqU1g1dlNnTzJC?=
 =?utf-8?B?eGRWaTNqM2ZYL2ZHaGdrWDVuaUxEQUJVVGZPWUdIeXhaZ3ZLRERUbW9laHBp?=
 =?utf-8?B?T0UyZ3V5ZEpzUm5zSFVJYW5wWWltc1NZK0tDNW5EZDZKeUZucXkyRlRpREd4?=
 =?utf-8?B?ZXlNQWF1QndacVFoSkxJa21yWm9IL2NjNmUxMHM2UHdJN0R3YmRENmdCRHk0?=
 =?utf-8?B?amVGMkNvdTdwcnIzWXZ3by9hTlFpaXVhSkMvdEZSdlJqcnNZMkwwVForS2hT?=
 =?utf-8?B?UUxNYm1vcFVidGx2enE0OGhHZkR5VjNwUXF0U3BpVU1Jb2xIYUVEdEhTdGxS?=
 =?utf-8?B?b1M4TE15NXFkaUQzOEF5c3dWaFFmaGZtWmUwUGxDZk5waXQ1WmNHRVQ2R3JO?=
 =?utf-8?Q?g799eZgtRE89qQAoYWVOHDPnYFDPuO4h4RMEOI7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR13MB2499.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5026152-e973-4986-871d-08d8fe96a6f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 16:10:27.1494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2RWjCYVbbl8Zn4SZFBBhKILxxouyW1BfC+5CURQSuUjngXUL6IYUvHggzS30Uw+RTbyH8BwGC2EpkbSemiFxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4743
X-Proofpoint-ORIG-GUID: lO5rh5s6CfdW5lLO98Ct66kyO975Z9Pk
X-Proofpoint-GUID: lO5rh5s6CfdW5lLO98Ct66kyO975Z9Pk
X-Sony-Outbound-GUID: lO5rh5s6CfdW5lLO98Ct66kyO975Z9Pk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_09:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGVpIFN0YXJvdm9p
dG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiANCj4gT24gVHVlLCBBcHIgMTMs
IDIwMjEgYXQgMjo1MiBBTSBZYW5nIExpIDx5YW5nLmxlZUBsaW51eC5hbGliYWJhLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPiBGaXggdGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmdzOg0KPiA+
IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjE4OTo3
LTExOiBXQVJOSU5HDQo+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0KPiA+
IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjM2MTo3
LTExOiBXQVJOSU5HDQo+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0KPiA+
IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjM4Njox
NC0xODogV0FSTklORw0KPiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4g
PiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaDo0MDI6
MTQtMTg6IFdBUk5JTkcNCj4gPiBjb21wYXJpbmcgcG9pbnRlciB0byAwLCBzdWdnZXN0ICFFDQo+
ID4gLi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6NDMz
OjctMTE6IFdBUk5JTkcNCj4gPiBjb21wYXJpbmcgcG9pbnRlciB0byAwLCBzdWdnZXN0ICFFDQo+
ID4gLi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6NTM0
OjE0LTE4OiBXQVJOSU5HDQo+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0K
PiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjYy
NTo3LTExOiBXQVJOSU5HDQo+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0K
PiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjc2
Nzo3LTExOiBXQVJOSU5HDQo+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0K
PiA+DQo+ID4gUmVwb3J0ZWQtYnk6IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIExpIDx5YW5nLmxlZUBsaW51eC5hbGliYWJhLmNv
bT4NCj4gPiAtLS0NCj4gPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2Zp
bGVyLmluYy5oIHwgMjIgKysrKysrKysrKystLS0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oIGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oDQo+ID4gaW5kZXgg
NDg5NmZkZjguLmEzMzA2NmMgMTAwNjQ0DQo+ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oDQo+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oDQo+ID4gQEAgLTE4OSw3ICsxODksNyBAQCBz
dGF0aWMgSU5MSU5FIHZvaWQgcG9wdWxhdGVfYW5jZXN0b3JzKHN0cnVjdCB0YXNrX3N0cnVjdCog
dGFzaywNCj4gPiAgI2VuZGlmDQo+ID4gICAgICAgICBmb3IgKG51bV9hbmNlc3RvcnMgPSAwOyBu
dW1fYW5jZXN0b3JzIDwgTUFYX0FOQ0VTVE9SUzsgbnVtX2FuY2VzdG9ycysrKSB7DQo+ID4gICAg
ICAgICAgICAgICAgIHBhcmVudCA9IEJQRl9DT1JFX1JFQUQocGFyZW50LCByZWFsX3BhcmVudCk7
DQo+ID4gLSAgICAgICAgICAgICAgIGlmIChwYXJlbnQgPT0gTlVMTCkNCj4gPiArICAgICAgICAg
ICAgICAgaWYgKCFwYXJlbnQpDQo+IA0KPiBTb3JyeSwgYnV0IEknZCBsaWtlIHRoZSBwcm9ncyB0
byBzdGF5IGFzIGNsb3NlIGFzIHBvc3NpYmxlIHRvIHRoZSB3YXkNCj4gdGhleSB3ZXJlIHdyaXR0
ZW4uDQpXaHk/DQoNCj4gVGhleSBtaWdodCBub3QgYWRoZXJlIHRvIGtlcm5lbCBjb2Rpbmcgc3R5
bGUgaW4gc29tZSBjYXNlcy4NCj4gVGhlIGNvZGUgY291bGQgYmUgZ3Jvc3NseSBpbmVmZmljaWVu
dCBhbmQgZXZlbiBidWdneS4NClRoZXJlIHdvdWxkIGhhdmUgdG8gYmUgYSByZWFsbHkgZ29vZCBy
ZWFzb24gdG8gYWNjZXB0DQpncm9zc2x5IGluZWZmaWNpZW50IGFuZCBldmVuIGJ1Z2d5IGNvZGUg
aW50byB0aGUga2VybmVsLg0KDQpDYW4geW91IHBsZWFzZSBleHBsYWluIHdoYXQgdGhhdCByZWFz
b24gaXM/DQoNCj4gUGxlYXNlIGRvbid0IHJ1biBzcGVsbCBjaGVja3MsIGNvY2NpY2hlY2ssIGNo
ZWNrcGF0Y2gucGwgb24gdGhlbS4NCg0KIC0tIFRpbQ0KDQo=
