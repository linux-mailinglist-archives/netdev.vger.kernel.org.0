Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E7303EE1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404588AbhAZNf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:35:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9645 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392522AbhAZN07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601018760001>; Tue, 26 Jan 2021 05:26:14 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:26:14 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:26:11 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 13:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOmoKT994c9Cx3f9v4LF3A+wqpXmmSba+4FoDln0ERZK/K0sB2ZcDReXqrP6/oGe+lyrlnk2Yci0MJLeej7IeankOnpM8nhUS1m1/KDxlA3Lj1dNEguvz1klUf+48+AGW/4zUYztjy1H0d+3Zu8rXAYvWqRIOEUI/mzcGtlOS6O0p9ZD9lnL1B25SUqelGYM5F7BcdQvgSyYAe7WD8HHCnaCsldP6+TmrXZsn+QJeQh2B62IDkhLOxbpHSdqe9a/q/SBcCNmt9ZL2p9wY4qhds+Xe6EL+RCU1iG5EmT27PcuNFCA6bNZ/ACaQC7NTyDO8qxfB0gg03InEkBOFOW8cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pHs0o46eW4a1FM4QtyAwyG1ES7lq5uXSD8gdctxFLQ=;
 b=k+Q4h8b6gS8jp7hBhr6AoiGdGe00KGKR6SG9UAqMO/A5YM0Ialz2teNyTBET6E0qhiPEREoGOOdtvKAsh6V/kgyKY9daLbmpWJpCc+NLNsIn4w4ceYc6FC75qQQpNYrOW4b5nvcdH3H6C5nAoifD95qyoShrBrf8DXMfHyYqZPIdQ8j0lh71PVyqgGNJY3AEJQps3Uif8rD2FZrVseMRE0o2HavaRWOGl/hkVIw46zq32TtViKqevek3mqQ/pjbaidLX1PSb7ePgYsB1j+cmtO4H6EkTwMf/Snkv0gSKD5djNRia3CAvL40bftv0mYxViSS2pyiKha2DQR12cAyfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4819.namprd12.prod.outlook.com (2603:10b6:a03:1fd::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 13:26:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 13:26:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH iproute2-next 2/2] vdpa: Add vdpa tool
Thread-Topic: [PATCH iproute2-next 2/2] vdpa: Add vdpa tool
Thread-Index: AQHW8LGLTT19qJhe80mPlaw7nLnuRao5VFaAgACXVYA=
Date:   Tue, 26 Jan 2021 13:26:09 +0000
Message-ID: <BY5PR12MB4322CD2FF36716821AB3EB9CDCBC9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210122112654.9593-1-parav@nvidia.com>
 <20210122112654.9593-3-parav@nvidia.com>
 <dc59454f-5e8b-2fce-9837-44808df933d4@gmail.com>
In-Reply-To: <dc59454f-5e8b-2fce-9837-44808df933d4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 498e31ba-abe9-46e3-c230-08d8c1fdf152
x-ms-traffictypediagnostic: BY5PR12MB4819:
x-microsoft-antispam-prvs: <BY5PR12MB48190B4E98CFBA31EBFD83F7DCBC9@BY5PR12MB4819.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4dUQbM6uItEMfy7hQAwPqa5afOdURUeZg1Vi7D0aXKOnaYDbUBVaacEZh8FrNO7SRZw8CIgZqIzNjqywzR//std36aulyF4x3UFTPQ8IbSJG1b0V3Mqm9kLzoRN3VCWXha/a54X3SbeiXlhquTeO2mtzSb8PnXu9rWFUvzT+GnPG2p8Gu1AdRLvshhPpCGHo07sNdQz/Izi0fUNGoSFcNrSi9xwLwyL85SC2D3yI5MlXUD0NAVWd8/9b1IXw8PP8UAKAe5wCWOZMQLEths0ysZmbuh5XbEeIJABtHSyohBgBYT+Wwe4luDn4DFI4MafkBlIT0YupACFL75X/3gohZDPuZ0651XYgHbT1gZO2dli3zr3+/tMJ5QvSc9w9G0tzAr3KbET57X+JjkiJsctdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(86362001)(9686003)(316002)(5660300002)(7696005)(8936002)(71200400001)(33656002)(6506007)(53546011)(110136005)(8676002)(66446008)(64756008)(66556008)(66476007)(66946007)(52536014)(76116006)(2906002)(83380400001)(26005)(55016002)(478600001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?d3RTbFpQbUdlTnhNanpyaGlBeExOVnhyRUNKSlV1YjVxQkRzd0NySFBOcDkx?=
 =?utf-8?B?RFJpSUNUS1lLZ1hYUWQ3YnN5dmJRajVmR2V6WXZKWTVCYnVvajZpeVlRdTdl?=
 =?utf-8?B?ZUlRQXVZd1preng2WWZ4TzE3L1ptZStGamdXT1NHSGJEM003UHQ0OVRJeHUv?=
 =?utf-8?B?eWRpZENTVzBhZW1ocGdlSlVwTXg3V1NzK2h2a2RFZ0l3UEZQOXRmZkR4OFFy?=
 =?utf-8?B?SkZ3UGplaGFDRFNJakxGd2I3UlZVbUh1V0VJMmUxNGVOOENkQklUZ2t1Mmo1?=
 =?utf-8?B?bWRVZFB2SWpZclNjTEZQbURuZ3JWKzFRVGdXY2p0R2pETXB3N3lnRThzT1lI?=
 =?utf-8?B?RXRPMGEva01CeFBiOXpJSnpaR3Y3N3RmT1RYaExXeDB6aDJSb0hNMExmTFh4?=
 =?utf-8?B?Rlp5SzJ1bTdSVm5pK0NvcWpJN1JxMi9majB4QVhtUjZ4cEM0YUt3M0x5SWFQ?=
 =?utf-8?B?RitoZVZiRW5wUERJRHBJaHdEeWNrcGdqb2dCVW9EZHhKcDFpNlFtZDB3Nk12?=
 =?utf-8?B?YWFIeTFJUUtHNG1YakphSjNPdWl2VjNHTitQQWJnOE1NZzRRMFBmMlUzKzg0?=
 =?utf-8?B?RlNyTEUzWUNtczE2aEgrQlhUcko4OElHL3Y1b3pldFVPbW9LNklDQ1JweGdR?=
 =?utf-8?B?bmhmYno2RVlmcm93eE13UnhVR1RNNTJFSmRtU0t3MENGODZpQTZHbVBHcmFD?=
 =?utf-8?B?NkE0UEN1YVlLQzN1Z3E0SThhOG5HVVc4Q09NZTQ4dnBpTmV4UFhaS2QxZVRN?=
 =?utf-8?B?T1EwcXpVa2EyM0NMdU1IR0cxc0xnNHNsUzlwVUN0OGJMRTJoY0pMbHY3UEJY?=
 =?utf-8?B?SjJNRG11UzlTbVRhRnZ3Mm91dFVRR2ZzS0F2VGJlZHVKa2FBNEhrY3hvWm8y?=
 =?utf-8?B?Z0VFK25XL1V0YmtCVVQ3c2pHKzJkM3MzR0IzcHR5eGNFNUh4RGtXMUNDR0dz?=
 =?utf-8?B?TTNNb01rdVo1TDFSbkQxVFhvSkUvL2toT1RiSjliNng4V1JRcnQrL09MQk5a?=
 =?utf-8?B?bXdyMDRnZXJnUE8vZHhTRE5Sbnk3SnI5UWhDaER0WURVd3NJd09CS0FCVmRN?=
 =?utf-8?B?cDQydE9keStNNTZFQS91dncyNyszSFVpeXUxQ3J3Tjh1bEllcHQ4dk5ZTXJj?=
 =?utf-8?B?QnhCN05ydll3eTZHaGxrMUdydFBsSm1hRW1ZN01DWWZUeEhkNVNVdlFtQ3BC?=
 =?utf-8?B?Q2h5djB4UUY5ZjYwUnBnSG5UamJITXZVcDNCc0lWNDVUN2NEN3ZDYzEydWFR?=
 =?utf-8?B?cnIyWmdYeGpTUVgwbnRDdDBqSW4vRFNCRFo5V3VVQXpEdWl1dXRHcjZ1UG0y?=
 =?utf-8?B?Tk5Za1VSR0FJMXdHUXJKaDduVEM0Vk9wT2JvSmVFbUJ4dkQ1QjRjbXdjeStI?=
 =?utf-8?B?ZHhkOGJQSGVReHBOK0JNT0hHL1JXRzYzN0JkaVhxMmR2T3J4bjhxcCtGdXZF?=
 =?utf-8?Q?anpXdTg5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498e31ba-abe9-46e3-c230-08d8c1fdf152
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 13:26:09.1080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bIvnsp2oATgPzpM25gstIYUwUaVNfqmKCGSL3SFOLd/tO7Qy0GtrpbPAKYXgFZAsdYmyN1a+mTRlz1vxGkYyRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4819
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611667575; bh=4pHs0o46eW4a1FM4QtyAwyG1ES7lq5uXSD8gdctxFLQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=A4ofysvhPHrPEzHg/yiE2HC+JKn+sSikaDXdysOvX8MiZduhtbzP9JtgzYQTAzq9H
         wThYXDbF2D9y25Lqso5Q4fCPYZuYrKh4MHvFNNjuxMsO6JgpFOaa/syFZMEAtD+y46
         deV7W+oVlXfucBJylWpDGKuqECAqYzcVH2PDWlsOBKmtoqX4nG2rhow+6QSDNxE//w
         JamtLbdMEmcWBjFmpb++BVh0fA2TPeAS9vnWiEYuUkEJoD4Xv4hUBduUtW9ACilf/C
         r9M5GacrJZu3uXLKH5/fl3xIwzu7cK7URvcjUV9tkXbW/A2lyqkoAPBmAlgaqstKoE
         dEaE3MWcI2Xvg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKYW51YXJ5IDI2LCAyMDIxIDk6NTMgQU0NCj4gDQo+IExvb2tzIGZpbmUuIEEgZmV3IGNv
bW1lbnRzIGJlbG93IGFyb3VuZCBjb2RlIHJlLXVzZS4NCj4gDQo+IE9uIDEvMjIvMjEgNDoyNiBB
TSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS92ZHBhL3ZkcGEuYyBiL3Zk
cGEvdmRwYS5jIG5ldyBmaWxlIG1vZGUgMTAwNjQ0IGluZGV4DQo+ID4gMDAwMDAwMDAuLjk0MjUy
NGI3DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL3ZkcGEvdmRwYS5jDQo+ID4gQEAgLTAs
MCArMSw4MjggQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjArDQo+
ID4gKw0KPiA+ICsjaW5jbHVkZSA8c3RkaW8uaD4NCj4gPiArI2luY2x1ZGUgPGdldG9wdC5oPg0K
PiA+ICsjaW5jbHVkZSA8ZXJybm8uaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2dlbmV0bGluay5o
Pg0KPiA+ICsjaW5jbHVkZSA8bGludXgvdmRwYS5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvdmly
dGlvX2lkcy5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvbmV0bGluay5oPg0KPiA+ICsjaW5jbHVk
ZSA8bGlibW5sL2xpYm1ubC5oPg0KPiA+ICsjaW5jbHVkZSAibW5sX3V0aWxzLmgiDQo+ID4gKw0K
PiA+ICsjaW5jbHVkZSAidmVyc2lvbi5oIg0KPiA+ICsjaW5jbHVkZSAianNvbl9wcmludC5oIg0K
PiA+ICsjaW5jbHVkZSAidXRpbHMuaCINCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgZ19pbmRlbnRf
bGV2ZWw7DQo+ID4gKw0KPiA+ICsjZGVmaW5lIElOREVOVF9TVFJfU1RFUCAyDQo+ID4gKyNkZWZp
bmUgSU5ERU5UX1NUUl9NQVhMRU4gMzINCj4gPiArc3RhdGljIGNoYXIgZ19pbmRlbnRfc3RyW0lO
REVOVF9TVFJfTUFYTEVOICsgMV0gPSAiIjsNCj4gDQo+IFRoZSBpbmRlbnQgY29kZSBoYXMgYSBs
b3Qgb2YgcGFyYWxsZWxzIHdpdGggZGV2bGluayAtLSBpbmNsdWRpbmcgaGVscGVycyBiZWxvdw0K
PiBhcm91bmQgaW5kZW50X2luYyBhbmQgX2RlYy4gUGxlYXNlIHRha2UgYSBsb29rIGF0IGhvdyB0
byByZWZhY3RvciBhbmQgcmUtDQo+IHVzZS4NCj4gDQpPay4gRGV2bGluayBoYXMgc29tZSBtb3Jl
IGNvbnZvbHV0ZWQgY29kZSB3aXRoIG5leHQgbGluZSBldGMuDQpCdXQgSSB3aWxsIHNlZSBpZiBJ
IGNhbiBjb25zb2xpZGF0ZSB3aXRob3V0IGNoYW5naW5nIHRoZSBkZXZsaW5rJ3MgZmxvdy9sb2dp
Yy4NCg0KPiA+ICsNCj4gPiArc3RydWN0IHZkcGFfc29ja2V0IHsNCj4gPiArCXN0cnVjdCBtbmxf
c29ja2V0ICpubDsNCj4gPiArCWNoYXIgKmJ1ZjsNCj4gPiArCXVpbnQzMl90IGZhbWlseTsNCj4g
PiArCXVuc2lnbmVkIGludCBzZXE7DQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHZk
cGFfc29ja2V0X3NuZHJjdihzdHJ1Y3QgdmRwYV9zb2NrZXQgKm5sZywgY29uc3Qgc3RydWN0DQo+
IG5sbXNnaGRyICpubGgsDQo+ID4gKwkJCSAgICAgIG1ubF9jYl90IGRhdGFfY2IsIHZvaWQgKmRh
dGEpIHsNCj4gPiArCWludCBlcnI7DQo+ID4gKw0KPiA+ICsJZXJyID0gbW5sX3NvY2tldF9zZW5k
dG8obmxnLT5ubCwgbmxoLCBubGgtPm5sbXNnX2xlbik7DQo+ID4gKwlpZiAoZXJyIDwgMCkgew0K
PiA+ICsJCXBlcnJvcigiRmFpbGVkIHRvIHNlbmQgZGF0YSIpOw0KPiA+ICsJCXJldHVybiAtZXJy
bm87DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJZXJyID0gbW5sdV9zb2NrZXRfcmVjdl9ydW4obmxn
LT5ubCwgbmxoLT5ubG1zZ19zZXEsIG5sZy0+YnVmLA0KPiBNTkxfU09DS0VUX0JVRkZFUl9TSVpF
LA0KPiA+ICsJCQkJICAgZGF0YV9jYiwgZGF0YSk7DQo+ID4gKwlpZiAoZXJyIDwgMCkgew0KPiA+
ICsJCWZwcmludGYoc3RkZXJyLCAidmRwYSBhbnN3ZXJzOiAlc1xuIiwgc3RyZXJyb3IoZXJybm8p
KTsNCj4gPiArCQlyZXR1cm4gLWVycm5vOw0KPiA+ICsJfQ0KPiA+ICsJcmV0dXJuIDA7DQo+ID4g
K30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgZ2V0X2ZhbWlseV9pZF9hdHRyX2NiKGNvbnN0IHN0
cnVjdCBubGF0dHIgKmF0dHIsIHZvaWQNCj4gPiArKmRhdGEpIHsNCj4gPiArCWludCB0eXBlID0g
bW5sX2F0dHJfZ2V0X3R5cGUoYXR0cik7DQo+ID4gKwljb25zdCBzdHJ1Y3QgbmxhdHRyICoqdGIg
PSBkYXRhOw0KPiA+ICsNCj4gPiArCWlmIChtbmxfYXR0cl90eXBlX3ZhbGlkKGF0dHIsIENUUkxf
QVRUUl9NQVgpIDwgMCkNCj4gPiArCQlyZXR1cm4gTU5MX0NCX0VSUk9SOw0KPiA+ICsNCj4gPiAr
CWlmICh0eXBlID09IENUUkxfQVRUUl9GQU1JTFlfSUQgJiYNCj4gPiArCSAgICBtbmxfYXR0cl92
YWxpZGF0ZShhdHRyLCBNTkxfVFlQRV9VMTYpIDwgMCkNCj4gPiArCQlyZXR1cm4gTU5MX0NCX0VS
Uk9SOw0KPiA+ICsJdGJbdHlwZV0gPSBhdHRyOw0KPiA+ICsJcmV0dXJuIE1OTF9DQl9PSzsNCj4g
PiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCBnZXRfZmFtaWx5X2lkX2NiKGNvbnN0IHN0cnVj
dCBubG1zZ2hkciAqbmxoLCB2b2lkICpkYXRhKSB7DQo+ID4gKwlzdHJ1Y3QgZ2VubG1zZ2hkciAq
Z2VubCA9IG1ubF9ubG1zZ19nZXRfcGF5bG9hZChubGgpOw0KPiA+ICsJc3RydWN0IG5sYXR0ciAq
dGJbQ1RSTF9BVFRSX01BWCArIDFdID0ge307DQo+ID4gKwl1aW50MzJfdCAqcF9pZCA9IGRhdGE7
DQo+ID4gKw0KPiA+ICsJbW5sX2F0dHJfcGFyc2UobmxoLCBzaXplb2YoKmdlbmwpLCBnZXRfZmFt
aWx5X2lkX2F0dHJfY2IsIHRiKTsNCj4gPiArCWlmICghdGJbQ1RSTF9BVFRSX0ZBTUlMWV9JRF0p
DQo+ID4gKwkJcmV0dXJuIE1OTF9DQl9FUlJPUjsNCj4gPiArCSpwX2lkID0gbW5sX2F0dHJfZ2V0
X3UxNih0YltDVFJMX0FUVFJfRkFNSUxZX0lEXSk7DQo+ID4gKwlyZXR1cm4gTU5MX0NCX09LOw0K
PiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGZhbWlseV9nZXQoc3RydWN0IHZkcGFfc29j
a2V0ICpubGcpIHsNCj4gPiArCXN0cnVjdCBnZW5sbXNnaGRyIGhkciA9IHt9Ow0KPiA+ICsJc3Ry
dWN0IG5sbXNnaGRyICpubGg7DQo+ID4gKwlpbnQgZXJyOw0KPiA+ICsNCj4gPiArCWhkci5jbWQg
PSBDVFJMX0NNRF9HRVRGQU1JTFk7DQo+ID4gKwloZHIudmVyc2lvbiA9IDB4MTsNCj4gPiArDQo+
ID4gKwlubGggPSBtbmx1X21zZ19wcmVwYXJlKG5sZy0+YnVmLCBHRU5MX0lEX0NUUkwsDQo+ID4g
KwkJCSAgICAgICBOTE1fRl9SRVFVRVNUIHwgTkxNX0ZfQUNLLA0KPiA+ICsJCQkgICAgICAgJmhk
ciwgc2l6ZW9mKGhkcikpOw0KPiA+ICsNCj4gPiArCW1ubF9hdHRyX3B1dF9zdHJ6KG5saCwgQ1RS
TF9BVFRSX0ZBTUlMWV9OQU1FLA0KPiBWRFBBX0dFTkxfTkFNRSk7DQo+ID4gKw0KPiA+ICsJZXJy
ID0gbW5sX3NvY2tldF9zZW5kdG8obmxnLT5ubCwgbmxoLCBubGgtPm5sbXNnX2xlbik7DQo+ID4g
KwlpZiAoZXJyIDwgMCkNCj4gPiArCQlyZXR1cm4gZXJyOw0KPiA+ICsNCj4gPiArCWVyciA9IG1u
bHVfc29ja2V0X3JlY3ZfcnVuKG5sZy0+bmwsIG5saC0+bmxtc2dfc2VxLCBubGctPmJ1ZiwNCj4g
PiArCQkJCSAgIE1OTF9TT0NLRVRfQlVGRkVSX1NJWkUsDQo+ID4gKwkJCQkgICBnZXRfZmFtaWx5
X2lkX2NiLCAmbmxnLT5mYW1pbHkpOw0KPiA+ICsJcmV0dXJuIGVycjsNCj4gPiArfQ0KPiA+ICsN
Cj4gPiArc3RhdGljIGludCB2ZHBhX3NvY2tldF9vcGVuKHN0cnVjdCB2ZHBhX3NvY2tldCAqbmxn
KSB7DQo+ID4gKwlpbnQgZXJyOw0KPiA+ICsNCj4gPiArCW5sZy0+YnVmID0gbWFsbG9jKE1OTF9T
T0NLRVRfQlVGRkVSX1NJWkUpOw0KPiA+ICsJaWYgKCFubGctPmJ1ZikNCj4gPiArCQlnb3RvIGVy
cl9idWZfYWxsb2M7DQo+ID4gKw0KPiA+ICsJbmxnLT5ubCA9IG1ubHVfc29ja2V0X29wZW4oTkVU
TElOS19HRU5FUklDKTsNCj4gPiArCWlmICghbmxnLT5ubCkNCj4gPiArCQlnb3RvIGVycl9zb2Nr
ZXRfb3BlbjsNCj4gPiArDQo+ID4gKwllcnIgPSBmYW1pbHlfZ2V0KG5sZyk7DQo+ID4gKwlpZiAo
ZXJyKQ0KPiA+ICsJCWdvdG8gZXJyX3NvY2tldDsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4g
PiArDQo+ID4gK2Vycl9zb2NrZXQ6DQo+ID4gKwltbmxfc29ja2V0X2Nsb3NlKG5sZy0+bmwpOw0K
PiA+ICtlcnJfc29ja2V0X29wZW46DQo+ID4gKwlmcmVlKG5sZy0+YnVmKTsNCj4gPiArZXJyX2J1
Zl9hbGxvYzoNCj4gPiArCXJldHVybiAtMTsNCj4gPiArfQ0KPiANCj4gVGhlIGFib3ZlIDQgZnVu
Y3Rpb25zIGR1cGxpY2F0ZSBhIGxvdCBvZiBkZXZsaW5rIGZ1bmN0aW9uYWxpdHkuIFBsZWFzZSBj
cmVhdGUgYQ0KPiBoZWxwZXIgaW4gbGliL21ubF91dGlscy5jIHRoYXQgY2FuIGJlIHVzZWQgaW4g
Ym90aC4NCj4gDQpXaWxsIGRvLg0KDQo+ID4gKw0KPiA+ICtzdGF0aWMgdW5zaWduZWQgaW50IHN0
cnNsYXNoY291bnQoY2hhciAqc3RyKSB7DQo+ID4gKwl1bnNpZ25lZCBpbnQgY291bnQgPSAwOw0K
PiA+ICsJY2hhciAqcG9zID0gc3RyOw0KPiA+ICsNCj4gPiArCXdoaWxlICgocG9zID0gc3RyY2hy
KHBvcywgJy8nKSkpIHsNCj4gPiArCQljb3VudCsrOw0KPiA+ICsJCXBvcysrOw0KPiA+ICsJfQ0K
PiA+ICsJcmV0dXJuIGNvdW50Ow0KPiA+ICt9DQo+IA0KPiB5b3UgY291bGQgbWFrZSB0aGF0IGEg
Z2VuZXJpYyBmdW5jdGlvbiAoZS5nLiwgc3RyX2NoYXJfY291bnQpIGJ5IHBhc3NpbmcgJy8nIGFz
DQo+IGFuIGlucHV0Lg0KPiANClllcy4NCg0KPiA+ICsNCj4gPiArc3RhdGljIGludCBzdHJzbGFz
aHJzcGxpdChjaGFyICpzdHIsIGNvbnN0IGNoYXIgKipiZWZvcmUsIGNvbnN0IGNoYXINCj4gPiAr
KiphZnRlcikgew0KPiA+ICsJY2hhciAqc2xhc2g7DQo+ID4gKw0KPiA+ICsJc2xhc2ggPSBzdHJy
Y2hyKHN0ciwgJy8nKTsNCj4gPiArCWlmICghc2xhc2gpDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7
DQo+ID4gKwkqc2xhc2ggPSAnXDAnOw0KPiA+ICsJKmJlZm9yZSA9IHN0cjsNCj4gPiArCSphZnRl
ciA9IHNsYXNoICsgMTsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+IA0KPiBzaW1pbGFybHkg
aGVyZS4gSWYgeW91IHN0YXJ0IHdpdGggdGhpbmdzIGxpa2UgdGhpcyBpbiBsaWIvdXRpbHMgeW91
IG1ha2UgaXQgZWFzaWVyIGZvcg0KPiBmb2xsb3cgb24gdXNlcnMgdG8gZmluZC4NCj4gDQpXaWxs
IGRvLg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0K
