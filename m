Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66F056562E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiGDMxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiGDMxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:53:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B4412632
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:53:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjetBXdnkru6tYSQktk5Dnsh5MOLsW8deed6TMdFLRh8Sp2xIFgc0D64BcHbaLvbyTjLxUrhmgEkqGBHge7Z8DZ2Ckr8tjCqNkwOLA/2i1m4p3EcdFs8OjnIdlI6xw6OmI7Z0djiH4SXWRQwXANhozJAGz1YTox6lLJGf3eHJkwqrRkOI25ZuvnJAO3gqrr+pSIkFp90oPnoEoQFhSreq/C96ulCOklvRTRBbMHfkIIVKQKfM56gMEf/Es96D9oiv7XQW12Tkyr0gAJn0Qp6iL6nYtpO1zJJxQpGHin/e1iwODO6+QUfMEi81y/f2kcFv95fYKGVJ+CBIqm7ymBWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naLuoGTljRMuPkFfZO+AbuY52tc4JqapbO3R6J4+Xw4=;
 b=e4mg7SOBt2Ub8jW6jxqLTWAeyVxf07S+T3cCrd37mVCvXw7ZjL/Ws9VmWpABOiwAhibg8+FafAW2kQ/jEPclADf4CP+4fjZvJT0i4s0xxUmRZK5D3NpN+Z5Yh1T7OZC9n4TVkA9vsqhwH99VGTP9qc/ljn+2qO3AszsfY3fWCrqEs3z0UYo02hRh7AmpnGapPWVRJcc3kXxncXT8plRriF7VvDVe18ELt/jiaCt2gb8C+gvxYi+6CbfbcPL5KO5ZYQGC+DV+T4NsOpP0iSeUr6pf6oS9IeyTZxriryKQNUrBaLbJgM9NLnxSKV81jVrYeZbEjz/AxAKF70j9HIcZUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naLuoGTljRMuPkFfZO+AbuY52tc4JqapbO3R6J4+Xw4=;
 b=D1HMhJm4H+1WQd/so1Vj510rExE0Nmq+LWYDY29yOKV8GjeaUYUmzS1bqOQxmKRcLTiRQ6u4LJanfsntfMvtiW7vZ85rKs//6aw0qN6lX+V7xIhCWLATVLMHJD0nrxmJu/m2vIjcO0pGSEwwuTmJWSsf4EoabPMa6nvGI7rVhh3dbuCYiXyNpJjHtZbkitsDtAbjC+YJgQAnLb7dRG57Mt+ALA+NnRYwrEnauDqO2Fm8SMcLXdwkN2Y3PyohrrK1EQnsklQn4pBlDqsvt1BjX5vxNRyzfFtKPUcd7o9lzeGFlzs1worXoLum1K0FP4OXUA4rACNkQ92PfSmtXDKcaA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB6277.namprd12.prod.outlook.com (2603:10b6:8:a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 12:53:00 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 12:53:00 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQggAOY1gCAAIePkA==
Date:   Mon, 4 Jul 2022 12:53:00 +0000
Message-ID: <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
In-Reply-To: <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 690e5685-df61-4479-9eee-08da5dbc2034
x-ms-traffictypediagnostic: DM4PR12MB6277:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vg78TYno0edp5mBnIiFvo+M3Lul7WFvgHOTlyEN0KIxkYGDg1DmlEu4nPqeLWp92THIf+9UGctT/BQvM+pcCR+Y04upIqGZ3ASo9buHTCAAfaA+EXjrgFO5N+6XyNSkmWxIBvzyTt7Va4nZtks+DLJIOeVI2bdAiPbx0QnuCAPWCiLR8UPrp3fDnGMnZAOI4oD1O8cyObKOAaf+w6SwguuvPPdSRQmjoXVMF1Tf0In8jiJ63tauyLmqbMn3pBNQM6YrEgTMqvcknVvXgSAEfM/XUYF1LhRHUtMPzwYOyudHofS9Ugs+hu5ukm8Y4OdOWwN5FKmBprIgaHSbbgYvIh0R52DxROBfkM4QEgfDw0PD3zEPEFNiAnOsQob1wPr2ZvwIOjLnQS23K2afRE2eGAk8D8zysNvtudz44ylQ5EhAWYo0OxiLu0XUFRmAZaa6HPpiiDD2qGGmRtQ6DcAoMFZAQWqDBNlqwll7RJi7cYIgnfVYV2dKQmyOW/ktn8hMcruQpHSff3eRAZNVoOfnB59A3VoChNER40SiZc30jGYJRII0OOmAlUMmwk+55H4+j5I94r18wLZ+8cKnRZzVR4k8VazFegITWEQTey1+BhPPKwPQQTlqA61p08o+di+7/fAAGqwPzJflwYsgzn67I+vsNSSeEFbuU6qWD0aY21K+E+oLkSWay9NvgXsnwu0LwzkCb2Ovt939KpmunmrBiH8P9lCORa7cRKCWGtjKZmaDFg5wyO0eEI86y/uU/SyqTlyZJij4s/8g9kyOqld61uzgArREXkM2QEqWuSmKJ+mOTrig/g4Iq5Sj0walQqm+6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(26005)(9686003)(55016003)(66946007)(66446008)(8676002)(66556008)(64756008)(71200400001)(66476007)(4326008)(86362001)(122000001)(2906002)(41300700001)(33656002)(8936002)(54906003)(76116006)(5660300002)(316002)(110136005)(38100700002)(6506007)(186003)(38070700005)(7696005)(478600001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N09UbGRYS01qWVdEMzRvR3liVVNJaWJKWG5qQTJlUTYya1JDM2xpc0tSMi85?=
 =?utf-8?B?eExMMTREUEFzRHF6eExRZU1MaXBOUW4xS0RGM29hanpnUXlDbWVoVldEMDdR?=
 =?utf-8?B?Y1VWandJN1c1Z0Y3OTgySVAwRjk4anhtbG9PTDRFeTg4UCs0YU9tMDB2N2Jv?=
 =?utf-8?B?NlVVR1ZhY2dUa2drNkV5ZEZ0citWV3FOU2dSSm5pUFV3R3FGRDJGWHVFaUlw?=
 =?utf-8?B?NXk1WHVjUU9oSVQwOUdJdDlVQ3ovaWJJcmtMNDdza1hQNmJ5WjdZWVFQV296?=
 =?utf-8?B?N0k4WFFVWDVLN2hRRndnaXM0em8vTkNvR2thVUNGcWh3ZjhvSHkwRWlmZVpj?=
 =?utf-8?B?cDM0R3A4TkJMUTdvdlVRNzZqODJ5dGNrMjlSeTdxVkpsU2xRTS9rRVp0dDdB?=
 =?utf-8?B?Z1kwTTdlbnNxZFY0a3NzU2dVL0ZiRElBR2JXeWlObWExVExYZkJTRDVCVFFX?=
 =?utf-8?B?Z1dZMHJqa3pFQlNWYnNSOGxvak5KNUU0dlZIQmlSdXZnK3E5WG9jVElLUmZl?=
 =?utf-8?B?SFlISU95VjRlZ3BmL3lhLzhoRmdBTndUMjhpMmo1NlREVmFTajRqYTJlVmcv?=
 =?utf-8?B?MUNSNTM1OU1WaXpzNFlWOEdBVE13WDAvM0JSZFZMT3AvMS9XT0xRTCt2TzdY?=
 =?utf-8?B?bHQ3UnEveDcrUndjM0N0T0R6b1NFaTE3cjZYNGhDb1RwS0l3ZVJYNHZ0UWFz?=
 =?utf-8?B?MGJyMjd0cXhFWU9YNzFEdEozRFc3RGdFNDV2UTFLcHpibFBnaUJxWHRBdHJi?=
 =?utf-8?B?d2J4Q0FuTnhGUklERVE3MnlsekpSK2dSV24xMkphVzBXdDJXQlZXY3VnZU1E?=
 =?utf-8?B?bUg4NGFiYWtMemIvYnJUZ1lSZG0zVGV0ZC8vamlKYjl6eWpBK3FYQWk0aFRw?=
 =?utf-8?B?M1RpTm1jNlAyTkF4cDJXMnY2My9CdUNlUXF1UW9jdUdhUTBSdGg1bFc3SDZV?=
 =?utf-8?B?ekVheWJKd0hZTnFLTlFqbkNxR0cxVHQ3NlVubjJuTUJwcVdaNit4WUVJVVNQ?=
 =?utf-8?B?bjRpUnZvdkZtNlVlb1RQYllRcnkzWEJISlY4TjF2TnB2U0RyNjhadzQwOGJz?=
 =?utf-8?B?bldiRnQxNkZMODZQZlJBbEU3MWhGWFh4UXV0VjRNaDdhSmRBS1dVajdGdUww?=
 =?utf-8?B?ZWlQd2xSTGt6ekcxaW9zUlo0VXRYU0FKYXZaZjZUNzgvc09XTko2dlpoNXpu?=
 =?utf-8?B?R01NZFNsTzlNUTFVYnM1cEIwZk9JbnFxVy9XSVdNRjh1bWV1V0RnWE03TmIz?=
 =?utf-8?B?TUxRVC82cHhpNmNCVkZweWZmd3RWQkp4emF0SXU3R1lhUWc4dGRZYnU1eXF1?=
 =?utf-8?B?OElFL25BVjhSbVJFZ3NON0VUeVZqZzkzbGZ3UWNNbjlYQTg4Qkl1NGY5Rk1R?=
 =?utf-8?B?ZjFZakNzTnkrcGtadUFMRENkMFpUQi9kTHdpaTRXUVNIUkRHS1NUaEcxNXBq?=
 =?utf-8?B?SUQzc3greFZDeXhqcUk1ckdZNHlXckgzaXZLTjNrQXRtQXl1TTNXNlR6VTl3?=
 =?utf-8?B?M3hCNmFxY3RhNlFsUENncUFmSUUvRzV2bkFyTmZGTEpIUkZUWG1QMmgvbE1T?=
 =?utf-8?B?TkFkQTJ2UVUxTzM0THZPb0hVVGdBWmJsMm94Q0tPQkUyd0pIZGJ1anRaM3N2?=
 =?utf-8?B?djRDdW9QRU9QT0w3YmFOMUR6YkxyM0VUa2NoVmY5cTRuR1dud3VpVkN6Ni9m?=
 =?utf-8?B?RXJMTHVYWkRPTU91QU14UGdlcW5mZVhlRkNwbkNCZUhzYXUzM3lqRjJFOENr?=
 =?utf-8?B?OXprZHd6dUxXdW1CejYycXZIdW1RaWZnV2F2bG5zTzBvdXlwdTJqK29iT05v?=
 =?utf-8?B?WlBrMkdzRE1OeURhUklybGlUWEFkbFh4TG5QOUFVVjg4bjEyMGdXMTJmKzlP?=
 =?utf-8?B?eCtDdHB5T3lzSFMwV2J5YVJGL2hLdDNTTDFaRHNvNUZnbW81Y1pZN2F5eTQ1?=
 =?utf-8?B?a2IxTzNtcURBcC9DaCtQdHRhNkZHalVJbW5Zc0ZRMDBLOTBMN0s0Y09wN1hw?=
 =?utf-8?B?TTlmWlVRVmR3UVlRaE9haEFHUHQvdHNhMGpkQjZjeE5DSGU4V1ZjL3c3SzZB?=
 =?utf-8?B?NFZ5UGVmclF5aWpCUGRwZUhzZ0N4dkhIQUZVN016OVNtMXZPclJuOVJ2a1or?=
 =?utf-8?Q?c2fI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690e5685-df61-4479-9eee-08da5dbc2034
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 12:53:00.1588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: meKfjOyqHIpwpHdgxA87AfOtdxRVbbFloR2nMWHn9G1m+x3kitRJX9OCUUGFI0/uMGwlP5qXMRscrbpX7kEcnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6277
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgSnVseSA0LCAyMDIyIDEyOjQ3IEFNDQo+IA0KPiANCj4g5ZyoIDIwMjIvNy8yIDA2OjAyLCBQ
YXJhdiBQYW5kaXQg5YaZ6YGTOg0KPiA+DQo+ID4+IEZyb206IFpodSBMaW5nc2hhbiA8bGluZ3No
YW4uemh1QGludGVsLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBKdWx5IDEsIDIwMjIgOToyOCBB
TQ0KPiA+Pg0KPiA+PiBUaGlzIGNvbW1pdCBhZGRzIGEgbmV3IHZEUEEgbmV0bGluayBhdHRyaWJ1
dGlvbg0KPiA+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLiBVc2Vyc3Bh
Y2UgY2FuIHF1ZXJ5DQo+IGZlYXR1cmVzDQo+ID4+IG9mIHZEUEEgZGV2aWNlcyB0aHJvdWdoIHRo
aXMgbmV3IGF0dHIuDQo+ID4+DQo+ID4+IEZpeGVzOiBhNjQ5MTdiYzJlOWIgdmRwYTogKFByb3Zp
ZGUgaW50ZXJmYWNlIHRvIHJlYWQgZHJpdmVyIGZlYXR1cmUpDQo+ID4gTWlzc2luZyB0aGUgIiIg
aW4gdGhlIGxpbmUuDQo+ID4gSSByZXZpZXdlZCB0aGUgcGF0Y2hlcyBhZ2Fpbi4NCj4gPg0KPiA+
IEhvd2V2ZXIsIHRoaXMgaXMgbm90IHRoZSBmaXguDQo+ID4gQSBmaXggY2Fubm90IGFkZCBhIG5l
dyBVQVBJLg0KPiA+DQo+ID4gQ29kZSBpcyBhbHJlYWR5IGNvbnNpZGVyaW5nIG5lZ290aWF0ZWQg
ZHJpdmVyIGZlYXR1cmVzIHRvIHJldHVybiB0aGUgZGV2aWNlDQo+IGNvbmZpZyBzcGFjZS4NCj4g
PiBIZW5jZSBpdCBpcyBmaW5lLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBpbnRlbnRzIHRvIHByb3Zp
ZGUgZGV2aWNlIGZlYXR1cmVzIHRvIHVzZXIgc3BhY2UuDQo+ID4gRmlyc3Qgd2hhdCB2ZHBhIGRl
dmljZSBhcmUgY2FwYWJsZSBvZiwgYXJlIGFscmVhZHkgcmV0dXJuZWQgYnkgZmVhdHVyZXMNCj4g
YXR0cmlidXRlIG9uIHRoZSBtYW5hZ2VtZW50IGRldmljZS4NCj4gPiBUaGlzIGlzIGRvbmUgaW4g
Y29tbWl0IFsxXS4NCj4gPg0KPiA+IFRoZSBvbmx5IHJlYXNvbiB0byBoYXZlIGl0IGlzLCB3aGVu
IG9uZSBtYW5hZ2VtZW50IGRldmljZSBpbmRpY2F0ZXMgdGhhdA0KPiBmZWF0dXJlIGlzIHN1cHBv
cnRlZCwgYnV0IGRldmljZSBtYXkgZW5kIHVwIG5vdCBzdXBwb3J0aW5nIHRoaXMgZmVhdHVyZSBp
Zg0KPiBzdWNoIGZlYXR1cmUgaXMgc2hhcmVkIHdpdGggb3RoZXIgZGV2aWNlcyBvbiBzYW1lIHBo
eXNpY2FsIGRldmljZS4NCj4gPiBGb3IgZXhhbXBsZSBhbGwgVkZzIG1heSBub3QgYmUgc3ltbWV0
cmljIGFmdGVyIGxhcmdlIG51bWJlciBvZiB0aGVtIGFyZQ0KPiBpbiB1c2UuIEluIHN1Y2ggY2Fz
ZSBmZWF0dXJlcyBiaXQgb2YgbWFuYWdlbWVudCBkZXZpY2UgY2FuIGRpZmZlciAobW9yZQ0KPiBm
ZWF0dXJlcykgdGhhbiB0aGUgdmRwYSBkZXZpY2Ugb2YgdGhpcyBWRi4NCj4gPiBIZW5jZSwgc2hv
d2luZyBvbiB0aGUgZGV2aWNlIGlzIHVzZWZ1bC4NCj4gPg0KPiA+IEFzIG1lbnRpb25lZCBiZWZv
cmUgaW4gVjIsIGNvbW1pdCBbMV0gaGFzIHdyb25nbHkgbmFtZWQgdGhlIGF0dHJpYnV0ZSB0bw0K
PiBWRFBBX0FUVFJfREVWX1NVUFBPUlRFRF9GRUFUVVJFUy4NCj4gPiBJdCBzaG91bGQgaGF2ZSBi
ZWVuLA0KPiBWRFBBX0FUVFJfREVWX01HTVRERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLg0KPiA+IEJl
Y2F1c2UgaXQgaXMgaW4gVUFQSSwgYW5kIHNpbmNlIHdlIGRvbid0IHdhbnQgdG8gYnJlYWsgY29t
cGlsYXRpb24gb2YNCj4gPiBpcHJvdXRlMiwgSXQgY2Fubm90IGJlIHJlbmFtZWQgYW55bW9yZS4N
Cj4gPg0KPiA+IEdpdmVuIHRoYXQsIHdlIGRvIG5vdCB3YW50IHRvIHN0YXJ0IHRyZW5kIG9mIG5h
bWluZyBkZXZpY2UgYXR0cmlidXRlcyB3aXRoDQo+IGFkZGl0aW9uYWwgX1ZEUEFfIHRvIGl0IGFz
IGRvbmUgaW4gdGhpcyBwYXRjaC4NCj4gPiBFcnJvciBpbiBjb21taXQgWzFdIHdhcyBleGNlcHRp
b24uDQo+ID4NCj4gPiBIZW5jZSwgcGxlYXNlIHJldXNlIFZEUEFfQVRUUl9ERVZfU1VQUE9SVEVE
X0ZFQVRVUkVTIHRvIHJldHVybg0KPiBmb3IgZGV2aWNlIGZlYXR1cmVzIHRvby4NCj4gDQo+IA0K
PiBUaGlzIHdpbGwgcHJvYmFibHkgYnJlYWsgb3IgY29uZnVzZSB0aGUgZXhpc3RpbmcgdXNlcnNw
YWNlPw0KPg0KSXQgc2hvdWxkbid0IGJyZWFrLCBiZWNhdXNlIGl0cyBuZXcgYXR0cmlidXRlIG9u
IHRoZSBkZXZpY2UuDQpBbGwgYXR0cmlidXRlcyBhcmUgcGVyIGNvbW1hbmQsIHNvIG9sZCBvbmUg
d2lsbCBub3QgYmUgY29uZnVzZWQgZWl0aGVyLg0K
