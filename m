Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900EF441979
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhKAKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:10:44 -0400
Received: from mail-dm6nam10on2131.outbound.protection.outlook.com ([40.107.93.131]:9504
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232191AbhKAKKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 06:10:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hE2HDbholVPzLuB3/lNMcssruPqEq96GGspGmMV/SakbsLGc6jFl4JvH+zSDjOn2D/x6WGochGA6wKeq7EStE6W+MoV8gm8xmgoO4qHO8FYa2yHKO4u3Ifv4WFNsHQYhhWt/8b+UcTkfIusAb4/F9gTzcyyyx64YLHBlDLCjtKVwCeOsA/3us+N5dR++o+9vM8MpwIT//cMbBAvBz3VXxQpKM/D3Ghv+DOdwcTOEXrPe8WYPozUu/rLVv1o9De2grFvCam9fKWuVgv4CfTrOrYm0c3dgorMycANPbyn3+rQ7A0EqtOVwnQTod9wHreZGXNf2sHGJtb6DkNvcevRa3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwk9peLGy7PFzif7keOSz2ppgWv8YM0qmjdsWwglEwk=;
 b=BGst5U+AakTY6q8wL5XcjE0crj+TcId90ecBA/boiOYVHCEM8kRZ1Yr2wf4xBCkVyk9vxg2sCmVba8KJ+nKJChb1dcIPJTHsOe0nrFUfUtb+XC9x6+jWwG1WY7fZVDYqz/Z1r0xtyZqNDl+PqWruIAenC86UhuHZqHpT2/28ArgXqom/oon4INEjoJ0rTynsUsjzwA45BNBcz8ismlAZN/omtnky785hdW/8LuxvgIKj3Mvw8aa/HIgsPun3kTXzLEv7fZ6+nxRCckZEcfYrUQ6snyFnC8Itq54o1wE4hsPBFtV6d6qGLWX0RsU/dJ8VFgwim2QsPd41J8Rvy45OLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwk9peLGy7PFzif7keOSz2ppgWv8YM0qmjdsWwglEwk=;
 b=ABt1VokBmcTGiBq2jVJKiNGO7xzZgYV4FgH8NPe5cMFAtSZoI4puPnqb7jZYXEknfE5/qur7HoGeArYVPayeuq0q8Q7zSfo9g0Y/xeg3ku6Q/fp836xy5CwN5X0Bz1BLu/puVMpEIKT4V5mcA5jRBFY+nREVuKy3Frcgk2tKLv0=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB4538.namprd13.prod.outlook.com (2603:10b6:5:76::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.9; Mon, 1 Nov
 2021 10:07:50 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.009; Mon, 1 Nov 2021
 10:07:50 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [RFC/PATCH net-next v3 5/8] flow_offload: add process to update
 action stats from hardware
Thread-Topic: [RFC/PATCH net-next v3 5/8] flow_offload: add process to update
 action stats from hardware
Thread-Index: AQHXy+v3GkGmPf7/Wk6HXpPjilqCdKvqOCMAgAQ++7A=
Date:   Mon, 1 Nov 2021 10:07:50 +0000
Message-ID: <DM5PR1301MB2172C3781B8A963F6A165DE7E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-6-simon.horman@corigine.com>
 <ygnho877ah8n.fsf@nvidia.com>
In-Reply-To: <ygnho877ah8n.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5332e5d1-5f0c-4d75-8417-08d99d1f7642
x-ms-traffictypediagnostic: DM6PR13MB4538:
x-microsoft-antispam-prvs: <DM6PR13MB45381074198FF0422411282FE78A9@DM6PR13MB4538.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AyMZNnrf5MYZIj/RdiZx7S39xg9QMiPaoN7M542vnsRn74XgYlszu+tDoq33rD09yq+QC3SUKQzXmk7PQkPDZlK7upkBnZHVnFHgswduZp78pBT8pjIsO9aWCapVncQobSofYlsmtHV3d87Hf/3LNs5e3XAFo3IVAiC2BMbPhzAApuZMbHXLv7PMj2PQAfwy1YueHGaLZ9joWQKWqFXWd47Q0ngQy23RFwql2j7aw19AZRbn9GBKT0ygzNOcFzs0Ppb5MbSsGI+uYKnDTSqHViwUtzwmroOUZSw/xEJ6c3OUt+PYLPXDvZRjpiltTLoTfehjJ6xaHQevTUdmUT9gTzZBNLAJEVEoUA5RM5rqiGU0b2SWglHS+6SiHmTqAjKmrkZDrbTOFzThM1Xg8XveenftPYYm3NQ2ldB3y1tctam3mHt2hFeWdb2purA7k7N02jDmW8mtGZ70yMJ2sVDx+M+U9vzJbNKqfWihGZqF/pCuCg7ZDcPIFVkk2o9v4Y3T943p1WaJdQlF0CiBmajLsu3msHdG20ZQeK7BHhfKd9tKWKi2eGiZfLI4reQnTm9ddiY9db/xNaGV9qg5joLXri5m/ba0FQgJU2kB6URx29xXyITihc4m6ef6F04NM6gbSpIo8vhf+1l4TQpkaziV5QVeXRIMLGhxd5fRrGed3+OA73eea/cxixQt0GuTR+VUbsWROWT1LpIDFWfXyfpXEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39830400003)(346002)(396003)(376002)(64756008)(66446008)(38100700002)(33656002)(76116006)(38070700005)(122000001)(6636002)(186003)(66476007)(66556008)(508600001)(26005)(66946007)(2906002)(52536014)(316002)(107886003)(83380400001)(110136005)(15650500001)(54906003)(71200400001)(5660300002)(86362001)(6506007)(4326008)(7696005)(9686003)(55016002)(44832011)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWZDbm1JM3pVSW5HMmMwblFMb1lTRHNJbkcvTXBZTHQrTEhuOFRBa2EwWUsw?=
 =?utf-8?B?eWRYQngycWZhK0JXTkxsaVJTU1RNbjZ0bHUzekQ3dVJxejE2WkNRQTdvcFUx?=
 =?utf-8?B?ZFNmM1Nxa0dIMHZ0T1gwQTlpMjZ6RFc4dFR5ZUtmWDg2RmU0d0QrY1lrNWxr?=
 =?utf-8?B?M291WnNnTFo4SiswK2pOUm5CcWdld3MwY3hvRnFSNjdidnZvZk4zSlUwZktl?=
 =?utf-8?B?Qm10OUx1N1hBZ0FCWjVBVGRmTFhlMEJGS3kyYUhnSkNWVmdaM1NOOUsvdTRh?=
 =?utf-8?B?NmV5SWViWEtLODFIajBHNzZZenVzSGJJZ0pxeSswa1pEamI5aEVZUERFOHZC?=
 =?utf-8?B?OXIrTnA5Yk95YlNBUzhwNWZrYU1mN1lWTnp4RmM4WUhZWGYyNkZ1R1NzRmRu?=
 =?utf-8?B?RjdTYXlFUC96cXdTYVF5cWV0b09PNHVEM0V3Nk80ZFVqV09YQXBtOHRvNVNE?=
 =?utf-8?B?QXpxdEJDWEt0T0F2QnovdWQwcEUvK1lqZHB3WUE4aGdzYVFXVXg0M245Zkgv?=
 =?utf-8?B?WTNuTEhLRmp5dGZtYUJJc3NQSGs0MFZ0cUpFS0wvTURHMkNtR2RMOCtCSDcy?=
 =?utf-8?B?dHZIOVljekVmaDVPS0lJTWNJTFAvR0xpaDJMQ0gvMEY2dnRCRmpXRXdHL2Jt?=
 =?utf-8?B?MUU1K05WZWNCS05JQlhIRFpOWjl3c0NKeEVENG4wU0svajFNVlF6cmE5eGVz?=
 =?utf-8?B?dFZBRVgwNmhadUh3eUNGZ202ZHBKekx5SzRQWllMWE1GYVZlUHZERllsZVJM?=
 =?utf-8?B?YTdBOGYxRXB1SjMyM2dsVnhkVUpuNDU1SWdBaWlxQkw0Zk9UZGZWeE1RNnRY?=
 =?utf-8?B?VjQyYnUzZVJpUmdhTk55K0NaUDRvWWpNM0hrSGZTbHQxZWZOdzlLZkF4K2Fr?=
 =?utf-8?B?aS8razNoc2FQUW5NbG40M3NJOGxMdjB0VHFOcTBBSWF5MDNlTGxNUit2U0F0?=
 =?utf-8?B?NXp4cWJCOGcrMGZYcGlzdkdqNnU4SUVIMEIrdGdFeGlTYnl4T0pHdlB5NS8y?=
 =?utf-8?B?eTZQZFZsTml5bGJ4TiszZCtVZ1ZheGlUVG9NT1JtR2pBenVLdEFqNnlpeGdq?=
 =?utf-8?B?U09pMUFMRTIzTythaTM5akVBSjdsMnFPWnhQMkwrSkVvN3lpcnR3UlpONHdu?=
 =?utf-8?B?UC9zM1l5WDJJLzNYNzB1QzQ4d1VmWjVqTmQ5OEl6L0M2TWVyK3dsY0ZJWTRp?=
 =?utf-8?B?U090SDFDSmhPbFlIZ1l3Z3dFN3hEeWY1RlVKKy9rQjBMOFRYK0tvczFtNEV4?=
 =?utf-8?B?ZlJhZTVJclN2cnNYaXlwWmdySk8yWVhrb3VYeXpwRTJSWWIzMzVKRDZoVFY0?=
 =?utf-8?B?Z2tDYTBVL2tiMUlyYUxpdFJxUlVrY2VSTGRPYkdYbmVIbG9Od1RKdU1La25t?=
 =?utf-8?B?OHZMQlpuVUEvZysxSWxhVmVpdTNLWmh1SzY5YncxRmltRzA5VDhORml6RXFG?=
 =?utf-8?B?STlhaGMrOWtZVHpvb1hYTzFtYUtKdFlGQUQrSTcvYStpbFhVbThkUzlCNlgw?=
 =?utf-8?B?NUhpMWF6aDBLSy93bUdxZjJISGpJMlBWVFZEMUJwZzAwbVdIc2l4ZWJKVW5n?=
 =?utf-8?B?TWU1VzRTYUJjem8vdFo1cDlXclAxNTdjbVpPSWJVdmIzM1hrazVWZGZwR3Nu?=
 =?utf-8?B?ZmxVUmFLQXN5aXAxbDdyUld6WnVQbmhHckNUM1c3bDI3Lzc1bDBFUkwzb3ZV?=
 =?utf-8?B?SlVaMG1xSDRJbWJQcVRHTzlrVitJZmc3NnN1Z0daU1dra0NEMTh5djF4OFVp?=
 =?utf-8?B?VlFHdWJoblArNzZMMlVLdmIrLy8rRXJqbFFjWGNsMkc4TXNnWlNuZ3BidGlZ?=
 =?utf-8?B?bEVOUmMzQSsvSnEyYzJ3QjJZN3lNN0RSNlZDQlJsRXlOOWJXbXZnY2ZDaTFv?=
 =?utf-8?B?U2kyOUlqSGUzOG5LYXBnT2VDMkFOUytuTTFMWGtNd2t2ZE1aUzYyenlYaEdU?=
 =?utf-8?B?aFZ6b3lOV3ZIU0V4Tm5rLzVlTVc0RmFMVUlocG9IRjlsWUhIdXZFMmNIbW9R?=
 =?utf-8?B?RTA0ZTVTamI1Q3h0Q2tlOEJsSzBPbm5RTmU5SjQybSt3eC9ZOXRsZ3V5c04r?=
 =?utf-8?B?b2pxTUxSaE42MmRTWWVSamZqeUwvcWd1S1IxdXcrL0FtYTFYemVSZlYwaXVm?=
 =?utf-8?B?RmVNWTFaQnhJMFdGMlM1b1R3alBEWm5GZ2JZalAvTGtPZnY5LzFnZ1hHNGM3?=
 =?utf-8?B?Y0J3TVNURXR4NkREQllQN2JJTWljb0lGd3hrKzNWM2o0dFd3SFJXcDRtQWQ0?=
 =?utf-8?B?bXBrazZsS1MxdXdsbDQ3U2luek5nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5332e5d1-5f0c-4d75-8417-08d99d1f7642
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 10:07:50.2623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HH4pl1HSDD0rCfTp8orxHqX6tmXfjlbD5uMNv0VZc/8sGjxIS8NTOG5HXnIqv9d/8fcmo75Y5l/7095rfGYjGwzsTKqP1yOgLq4uImP6btA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gT2N0b2JlciAzMCwgMjAyMSAxOjExIEFNLCBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG52aWRpYS5j
b20+IHdyb3RlOg0KPk9uIFRodSAyOCBPY3QgMjAyMSBhdCAxNDowNiwgU2ltb24gSG9ybWFuIDxz
aW1vbi5ob3JtYW5AY29yaWdpbmUuY29tPg0KPndyb3RlOg0KPj4gRnJvbTogQmFvd2VuIFpoZW5n
IDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4NCj4+IFdoZW4gY29sbGVjdGluZyBzdGF0
cyBmb3IgYWN0aW9ucyB1cGRhdGUgdGhlbSB1c2luZyBib3RoIGJvdGggaGFyZHdhcmUNCj4+IGFu
ZCBzb2Z0d2FyZSBjb3VudGVycy4NCj4+DQo+PiBTdGF0cyB1cGRhdGUgcHJvY2VzcyBzaG91bGQg
bm90IGluIGNvbnRleHQgb2YgcHJlZW1wdF9kaXNhYmxlLg0KPg0KPkkgdGhpbmsgeW91IGFyZSBt
aXNzaW5nIGEgd29yZCBoZXJlLg0KVGhhbmtzLCB3ZSB3aWxsIGZpeCBpdCBpbiBuZXh0IHBhdGNo
Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEJhb3dlbiBaaGVuZyA8YmFvd2VuLnpoZW5nQGNvcmln
aW5lLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IExvdWlzIFBlZW5zIDxsb3Vpcy5wZWVuc0Bjb3Jp
Z2luZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1hbkBj
b3JpZ2luZS5jb20+DQo+PiAtLS0NCj4+ICBpbmNsdWRlL25ldC9hY3RfYXBpLmggfCAgMSArDQo+
PiAgaW5jbHVkZS9uZXQvcGt0X2Nscy5oIHwgMTggKysrKysrKysrKy0tLS0tLS0tDQo+PiAgbmV0
L3NjaGVkL2FjdF9hcGkuYyAgIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gIDMgZmlsZXMgY2hhbmdlZCwgNDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMo
LSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvYWN0X2FwaS5oIGIvaW5jbHVkZS9u
ZXQvYWN0X2FwaS5oIGluZGV4DQo+PiA2NzEyMDhiZDI3ZWYuLjgwYTlkMWU3ZDgwNSAxMDA2NDQN
Cj4+IC0tLSBhL2luY2x1ZGUvbmV0L2FjdF9hcGkuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQvYWN0
X2FwaS5oDQo+PiBAQCAtMjQ3LDYgKzI0Nyw3IEBAIHZvaWQgdGNmX2FjdGlvbl91cGRhdGVfc3Rh
dHMoc3RydWN0IHRjX2FjdGlvbiAqYSwNCj51NjQgYnl0ZXMsIHU2NCBwYWNrZXRzLA0KPj4gIAkJ
CSAgICAgdTY0IGRyb3BzLCBib29sIGh3KTsNCj4+ICBpbnQgdGNmX2FjdGlvbl9jb3B5X3N0YXRz
KHN0cnVjdCBza19idWZmICosIHN0cnVjdCB0Y19hY3Rpb24gKiwgaW50KTsNCj4+IGludCB0Y2Zf
YWN0aW9uX29mZmxvYWRfZGVsKHN0cnVjdCB0Y19hY3Rpb24gKmFjdGlvbik7DQo+PiAraW50IHRj
Zl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzKHN0cnVjdCB0Y19hY3Rpb24gKmFjdGlvbik7DQo+PiAg
aW50IHRjZl9hY3Rpb25fY2hlY2tfY3RybGFjdChpbnQgYWN0aW9uLCBzdHJ1Y3QgdGNmX3Byb3Rv
ICp0cCwNCj4+ICAJCQkgICAgIHN0cnVjdCB0Y2ZfY2hhaW4gKipoYW5kbGUsDQo+PiAgCQkJICAg
ICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpuZXdjaGFpbik7IGRpZmYgLS1naXQNCj4+IGEvaW5j
bHVkZS9uZXQvcGt0X2Nscy5oIGIvaW5jbHVkZS9uZXQvcGt0X2Nscy5oIGluZGV4DQo+PiA0NGFl
NTE4MmE5NjUuLjg4Nzg4YjgyMWY3NiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L3BrdF9j
bHMuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQvcGt0X2Nscy5oDQo+PiBAQCAtMjkyLDE4ICsyOTIs
MjAgQEAgdGNmX2V4dHNfc3RhdHNfdXBkYXRlKGNvbnN0IHN0cnVjdCB0Y2ZfZXh0cw0KPj4gKmV4
dHMsICAjaWZkZWYgQ09ORklHX05FVF9DTFNfQUNUDQo+PiAgCWludCBpOw0KPj4NCj4+IC0JcHJl
ZW1wdF9kaXNhYmxlKCk7DQo+PiAtDQo+PiAgCWZvciAoaSA9IDA7IGkgPCBleHRzLT5ucl9hY3Rp
b25zOyBpKyspIHsNCj4+ICAJCXN0cnVjdCB0Y19hY3Rpb24gKmEgPSBleHRzLT5hY3Rpb25zW2ld
Ow0KPj4NCj4+IC0JCXRjZl9hY3Rpb25fc3RhdHNfdXBkYXRlKGEsIGJ5dGVzLCBwYWNrZXRzLCBk
cm9wcywNCj4+IC0JCQkJCWxhc3R1c2UsIHRydWUpOw0KPj4gLQkJYS0+dXNlZF9od19zdGF0cyA9
IHVzZWRfaHdfc3RhdHM7DQo+PiAtCQlhLT51c2VkX2h3X3N0YXRzX3ZhbGlkID0gdXNlZF9od19z
dGF0c192YWxpZDsNCj4+IC0JfQ0KPj4gKwkJLyogaWYgc3RhdHMgZnJvbSBodywganVzdCBza2lw
ICovDQo+PiArCQlpZiAodGNmX2FjdGlvbl91cGRhdGVfaHdfc3RhdHMoYSkpIHsNCj4+ICsJCQlw
cmVlbXB0X2Rpc2FibGUoKTsNCj4+ICsJCQl0Y2ZfYWN0aW9uX3N0YXRzX3VwZGF0ZShhLCBieXRl
cywgcGFja2V0cywgZHJvcHMsDQo+PiArCQkJCQkJbGFzdHVzZSwgdHJ1ZSk7DQo+PiArCQkJcHJl
ZW1wdF9lbmFibGUoKTsNCj4+DQo+PiAtCXByZWVtcHRfZW5hYmxlKCk7DQo+PiArCQkJYS0+dXNl
ZF9od19zdGF0cyA9IHVzZWRfaHdfc3RhdHM7DQo+PiArCQkJYS0+dXNlZF9od19zdGF0c192YWxp
ZCA9IHVzZWRfaHdfc3RhdHNfdmFsaWQ7DQo+PiArCQl9DQo+PiArCX0NCj4+ICAjZW5kaWYNCj4+
ICB9DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9hY3RfYXBpLmMgYi9uZXQvc2NoZWQv
YWN0X2FwaS5jIGluZGV4DQo+PiA2MDRiZjE5MjNiY2MuLjg4MWM3YmE0ZDE4MCAxMDA2NDQNCj4+
IC0tLSBhL25ldC9zY2hlZC9hY3RfYXBpLmMNCj4+ICsrKyBiL25ldC9zY2hlZC9hY3RfYXBpLmMN
Cj4+IEBAIC0xMjM4LDYgKzEyMzgsNDAgQEAgc3RhdGljIGludCB0Y2ZfYWN0aW9uX29mZmxvYWRf
YWRkKHN0cnVjdCB0Y19hY3Rpb24NCj4qYWN0aW9uLA0KPj4gIAlyZXR1cm4gZXJyOw0KPj4gIH0N
Cj4+DQo+PiAraW50IHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzKHN0cnVjdCB0Y19hY3Rpb24g
KmFjdGlvbikgew0KPj4gKwlzdHJ1Y3QgZmxvd19vZmZsb2FkX2FjdGlvbiBmbF9hY3QgPSB7fTsN
Cj4+ICsJaW50IGVyciA9IDA7DQo+PiArDQo+PiArCWlmICghdGNfYWN0X2luX2h3KGFjdGlvbikp
DQo+PiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+PiArDQo+PiArCWVyciA9IGZsb3dfYWN0aW9u
X2luaXQoJmZsX2FjdCwgYWN0aW9uLCBGTE9XX0FDVF9TVEFUUywgTlVMTCk7DQo+PiArCWlmIChl
cnIpDQo+PiArCQlnb3RvIGVycl9vdXQ7DQo+PiArDQo+PiArCWVyciA9IHRjZl9hY3Rpb25fb2Zm
bG9hZF9jbWQoJmZsX2FjdCwgTlVMTCwgTlVMTCk7DQo+PiArDQo+PiArCWlmICghZXJyICYmIGZs
X2FjdC5zdGF0cy5sYXN0dXNlZCkgew0KPj4gKwkJcHJlZW1wdF9kaXNhYmxlKCk7DQo+PiArCQl0
Y2ZfYWN0aW9uX3N0YXRzX3VwZGF0ZShhY3Rpb24sIGZsX2FjdC5zdGF0cy5ieXRlcywNCj4+ICsJ
CQkJCWZsX2FjdC5zdGF0cy5wa3RzLA0KPj4gKwkJCQkJZmxfYWN0LnN0YXRzLmRyb3BzLA0KPj4g
KwkJCQkJZmxfYWN0LnN0YXRzLmxhc3R1c2VkLA0KPj4gKwkJCQkJdHJ1ZSk7DQo+PiArCQlwcmVl
bXB0X2VuYWJsZSgpOw0KPj4gKwkJYWN0aW9uLT51c2VkX2h3X3N0YXRzID0gZmxfYWN0LnN0YXRz
LnVzZWRfaHdfc3RhdHM7DQo+PiArCQlhY3Rpb24tPnVzZWRfaHdfc3RhdHNfdmFsaWQgPSB0cnVl
Ow0KPj4gKwkJZXJyID0gMDsNCj4NCj5FcnJvciBoYW5kbGluZyBoZXJlIGlzIHNsaWdodGx5IGNv
bnZvbHV0ZWQuIFRoaXMgbGluZSBhc3NpZ25zIGVycj0wIHRoaXJkIHRpbWUgKGl0IGlzDQo+aW5p
dGlhbGl6ZWQgd2l0aCB6ZXJvIGFuZCB0aGVuIHdlIGNhbiBvbmx5IGdldCBoZXJlIGlmIHJlc3Vs
dCBvZg0KPnRjZl9hY3Rpb25fb2ZmbG9hZF9jbWQoKSBhc3NpZ25lZCAnZXJyJyB0byB6ZXJvIGFn
YWluKS4NCj5Db25zaWRlcmluZyB0aGF0IGVycm9yIGhhbmRsZXIgaW4gdGhpcyBmdW5jdGlvbiBp
cyBlbXB0eSB3ZSBjYW4ganVzdCByZXR1cm4NCj5lcnJvcnMgZGlyZWN0bHkgYXMgc29vbiBhcyB0
aGV5IGhhcHBlbiBhbmQgcmV0dXJuIHplcm8gYXQgdGhlIGVuZCBvZiB0aGUNCj5mdW5jdGlvbi4N
Cj4NClRoYW5rcywgd2Ugd2lsbCBjaGFuZ2UgYXMgeW91ciBzdWdnZXN0aW9uLg0KPj4gKwl9IGVs
c2Ugew0KPj4gKwkJZXJyID0gLUVPUE5PVFNVUFA7DQo+DQo+SG1tIHRoZSBjb2RlIGNhbiByZXR1
cm4gZXJyb3IgaGVyZSB3aGVuIHRjZl9hY3Rpb25fb2ZmbG9hZF9jbWQoKQ0KPnN1Y2NlZWRlZCBi
dXQgJ2xhc3R1c2VkJyBpcyB6ZXJvLiBTdWNoIGJlaGF2aW9yIHdpbGwgY2F1c2UNCj50Y2ZfZXh0
c19zdGF0c191cGRhdGUoKSB0byB1cGRhdGUgYWN0aW9uIHdpdGggZmlsdGVyIGNvdW50ZXIgdmFs
dWVzLiBJcyB0aGlzIHRoZQ0KPmRlc2lyZWQgYmVoYXZpb3Igd2hlbiwgZm9yIGV4YW1wbGUsIGlu
IGZpbHRlciBhY3Rpb24gbGlzdCB0aGVyZSBpcyBhbmQgYWN0aW9uIHRoYXQNCj5jYW4gZHJvcCBw
YWNrZXRzIGZvbGxvd2VkIGJ5IHNvbWUgc2hhcmVkIGFjdGlvbj8gSW4gc3VjaCBjYXNlICdsYXN0
dXNlZCcgY2FuDQo+YmUgemVybyBpZiBhbGwgcGFja2V0cyB0aGF0IGZpbHRlciBtYXRjaGVkIHdl
cmUgZHJvcHBlZCBieSBwcmV2aW91cyBhY3Rpb24gYW5kDQo+c2hhcmVkIGFjdGlvbiB3aWxsIGJl
IGFzc2lnbmVkIHdpdGggZmlsdGVyIGNvdW50ZXIgdmFsdWUgdGhhdCBpbmNsdWRlcyBkcm9wcGVk
DQo+cGFja2V0cy9ieXRlcy4NCj4NClRoYW5rcywgd2Ugd2lsbCBjb25zaWRlciBpZiBpdCBtYWtl
IHNlbnNlIHRvIG9ubHkganVkZ2UgcmV0dXJuIHZhbHVlIGVyciBmcm9tIHRjZl9hY3Rpb25fb2Zm
bG9hZF9jbWQuDQo+PiArCX0NCj4+ICsNCj4+ICtlcnJfb3V0Og0KPj4gKwlyZXR1cm4gZXJyOw0K
Pj4gK30NCj4+ICtFWFBPUlRfU1lNQk9MKHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzKTsNCj4+
ICsNCj4+ICBpbnQgdGNmX2FjdGlvbl9vZmZsb2FkX2RlbChzdHJ1Y3QgdGNfYWN0aW9uICphY3Rp
b24pICB7DQo+PiAgCXN0cnVjdCBmbG93X29mZmxvYWRfYWN0aW9uIGZsX2FjdDsNCj4+IEBAIC0x
MzYyLDYgKzEzOTYsOSBAQCBpbnQgdGNmX2FjdGlvbl9jb3B5X3N0YXRzKHN0cnVjdCBza19idWZm
ICpza2IsDQo+c3RydWN0IHRjX2FjdGlvbiAqcCwNCj4+ICAJaWYgKHAgPT0gTlVMTCkNCj4+ICAJ
CWdvdG8gZXJyb3V0Ow0KPj4NCj4+ICsJLyogdXBkYXRlIGh3IHN0YXRzIGZvciB0aGlzIGFjdGlv
biAqLw0KPj4gKwl0Y2ZfYWN0aW9uX3VwZGF0ZV9od19zdGF0cyhwKTsNCj4+ICsNCj4+ICAJLyog
Y29tcGF0X21vZGUgYmVpbmcgdHJ1ZSBzcGVjaWZpZXMgYSBjYWxsIHRoYXQgaXMgc3VwcG9zZWQN
Cj4+ICAJICogdG8gYWRkIGFkZGl0aW9uYWwgYmFja3dhcmQgY29tcGF0aWJpbGl0eSBzdGF0aXN0
aWMgVExWcy4NCj4+ICAJICovDQoNCg==
