Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0B466944
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376374AbhLBRmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:42:54 -0500
Received: from mail-eopbgr150139.outbound.protection.outlook.com ([40.107.15.139]:25990
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376400AbhLBRmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 12:42:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQt5u/DeKyRR1sp4+fnsY8hIvTUvmLT+W2wilrHrZhtGhkkcSIuRsgElINKQHE4A0+F1Qb3G8NX4DA6AS250of9GUX6iuaIuJKoqXm7XtIp2M85aUhSrHq56/OAql4ktZPp7rSYrGwbz+GI6QfcagdHnqpsRLWGvOKty6jJ4mlrxJk7NvcXiLKwwO7y+nbiPSPJu1HyYUXSApr+DXsEbB+2JqGJdGRedNOWZhUOMEwv2BIneMuWRlhOlMDgFlF40cEnE6xL5e39/V2Dget8z4Huc/w0ERoau9n19i8WbkkEzYsauDBaQyt8VaUi+r2JvBCs+cuUeHJMhCBePR1pjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBWes7pdeJRoOqwd0OsVGp76hvKwLdGZmk0kLpvTxt0=;
 b=cf2gXrjyuj9f44ZR0lmE7Dkh0Cky8LNaRzemid9Cx0vGb3tAmO4jLlVxndYa7nZYE40ii4j0TqRGIOssVpsU6owmvyKY5GZPD2ROZwld0WvGakbVXNRHu2XgDmaSgpEauwEWXa1xpo3Ew5+JfosjWaz2xROxZ+necVlOkbII0yyDCk+tuxUH6lsvV+2qK2ATiaJH1vaKEGwClK0/nqicEjByFxPx+Q1f3T4ASgt3QjWiHYxfO832H9rfPyYGuMP40iIwvjCQLi09Z5BRWnZ+2evcSPpyG+VTpS1Spv/C0DHWZ7mGYapEyDOEZtX6Sz7OpgRaGCJFDDHNW9UGSyJiXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBWes7pdeJRoOqwd0OsVGp76hvKwLdGZmk0kLpvTxt0=;
 b=dZB4CfoFVcaDVtpKOvlpzJ+tY7ggq2or/VKL+mwM6gtE7xOWrEB4NuVStMNTG99Lx4ZUBDPc+RWb6B+pZpOcxpdo6pdD33D8kOFsJbZen0MmOSdq1YXo92uNVcOM3iK3f6bywsGg0xjjdz4ex7sM3pAs5ZN50hxsZXDR2ujHjts=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0608.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 2 Dec
 2021 17:39:24 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 17:39:24 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: prestera: flower template support
Thread-Topic: [PATCH net-next] net: prestera: flower template support
Thread-Index: AQHX55R72e0BLdbnYk+svnQj9X0JyKwfdDOAgAAAvSA=
Date:   Thu, 2 Dec 2021 17:39:24 +0000
Message-ID: <VI1P190MB0734C11D7BCDA57437264E698F699@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <1e86c2c7-eb84-4170-00f2-007bed67f93a@mojatatu.com>
In-Reply-To: <1e86c2c7-eb84-4170-00f2-007bed67f93a@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16b293e8-265e-4cf7-0b6e-08d9b5baae5a
x-ms-traffictypediagnostic: VI1P190MB0608:
x-microsoft-antispam-prvs: <VI1P190MB0608F657D6FE51E083D5DCFE8F699@VI1P190MB0608.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+zTNlPEjcu+lUXWyRvzp+GqRGst07b3bdGqNffFsMxPH3cQDmkY0HEj/gdI/NmDAFILq75gscPdl+0+C8y0FF6rgbcb8+5hge/1p4+hIVg5o5yaLzg1t50o3H6mn6wk775VL6sHjkx7sHMOLuFv9829SB0yQ3fEMCfNGqIR7GovkQO8234xv+MOr9NLv99zqux4VeATf52ZtD54eBDxwtyCyo2n/t58UOV5kt2nl3DuMEss5/X2gpTubU57vsS2PDacBUQls2b+F6LUzNCgechLk1B6yeiToNfpGvw25O/a58tOHmS8sWnNHcVJWP59x53yW5XqHCD58OSgqSK68cYNoXBYiURJxAsnoBsw8foXO8/H5UuhHJxfmA1eMfb/hGlUbCyv4WzudwR6QstdvtdPZbHh1g1bxBgJVssF906YkOWY6WlZSoJSqJL2vll9s+omD275f6CFS+xPULsElUv41jGz1QFbhfar5K6h6y5AUoARiBSZ+j2syW/7xnHHG0wASXz8kDanQGc/Rqi5PSEMO/Lu6GKF7gwYoj98XgDJsI/O2ZieVEIo6K7v8438NKloQEM1DKyvK9fz5/FkM1kf5t7OVbsClmO1dBgGprvIqG4A+LmbgfoM0fBfCDE+wAX54QG4BbgPY0DgfpYhY5cqhdJHc3UpKD57HrB1JTvYj6C+IsYgsksr2iVjgwSNHiQj76oFg1vC20Kr11lyyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39830400003)(346002)(26005)(110136005)(54906003)(33656002)(66446008)(66946007)(66476007)(66556008)(64756008)(44832011)(8676002)(38070700005)(55016003)(508600001)(9686003)(186003)(5660300002)(6506007)(316002)(8936002)(4326008)(52536014)(2906002)(7696005)(38100700002)(76116006)(122000001)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUZIZWxmVEVWazNXWEEwdnBLakVReUQ5NElzWmh1ME9yaUYrUTJGVm1DTllF?=
 =?utf-8?B?WWU3YnpDbXV4ZVY5OWU1ckMzZzFCbWpxQjQxT0FUOW9LN0d0VFdoNDdSeC9P?=
 =?utf-8?B?M3RRWjQwWUJ0SGRnQWFtbUFMNUUxMHpWK2NwZGxpNE5Db09jbm4xeTZEbDFq?=
 =?utf-8?B?Qnk2cVh3NFlYOEhTOHBwdTdwdm90VHBKdEFBNHljMHYxaXBZNTJlakc1UXlQ?=
 =?utf-8?B?LzJKUEhXL3I1ZC8xclVwYkwzVjZHTTF0ZFRpYXd1Qy9JM3NZM1ZkQTA4VzVH?=
 =?utf-8?B?d3ZaZWRoNi9YSmpwQm1qRDdrZ3VuZ2RkekFrdUNvSnhsWTFwSWZUbCtOUStG?=
 =?utf-8?B?ZTNtNDg5cFlKREJ6MlVDaG5Za1lXYzF4UThmRC9CRXdKUzNoT3Q5enNyR2ZD?=
 =?utf-8?B?UHU2WENoQ21iSklSeXdseXZZS2tkUlpuajVuRXM2NFMvdTZhekJmOGltRHdk?=
 =?utf-8?B?c3piMFhoZEl3bVY4RzNDWXdDcWd1NVZ4bDFFb1UrOGdvS3RESlE0ZmlIZ3R6?=
 =?utf-8?B?VlJTTFJmWGxqd0o1SENJWmw1VHc4M25INkRBVFJQVElESTBJNW5EelErMkti?=
 =?utf-8?B?ZWFTNVRxbEFWTjFpNlZSVmUxakNVcWgzOXJLNEl4MXZ3ZlYydUFkVkovdkdv?=
 =?utf-8?B?RVNvSldLZWNUaXdDbmJ4a2s5MUNBa2dUbjJJaXVsQXBUOUdjSGpWenY5azhS?=
 =?utf-8?B?UjQxM0NDQU1BcWpVTlR5Nk5zbFZENVRSV1lhcm1PMldIZkU1U0xrYUFFdHFt?=
 =?utf-8?B?YnpaYjJSUEdWUkJJU1ZVdlRlRXdlYUZzNk1QVVZtSFNiaFV6d2k0cEZ3SmE5?=
 =?utf-8?B?UXBVRkdWWXk3dUQ3YVI2eHNQV0Vmc0NBZUROL2lQU3dEUXZ6YnMyK3FwbXdX?=
 =?utf-8?B?Q2VsUVVadWFqeWZSNDFJNUFBR2MrbVk0emRwby9NajZ5cUNkR1dNbzRFZ0lP?=
 =?utf-8?B?ZVlCUThqdlluZXBMa0hyTXVzWFNsMmw1dWJHT0lDdEVhRGYwSGwxT3h6ZFMy?=
 =?utf-8?B?UCs5bEVqWUNuUEpoTnBKb3FqcU9FM2kzK0NHN0pXRGk4RlY3bmlFclkzNm5G?=
 =?utf-8?B?cFhGZlVncWFXbTFUUWtwVkgydHM5Z3pkaHErVS9kK3hRcTBNSUdtaytNWlFr?=
 =?utf-8?B?aDY5NmVFc2l3SWc3VTNIT1ZEdm5pK09nc2Y0Q0pobTRnSVh1bVgyaDVyT3g0?=
 =?utf-8?B?UVZPOXFMZll4V0JIVURwR1VsdU1Hd1pIQWJqVE9xVXh5RFRxNXF4VWs1NENl?=
 =?utf-8?B?YTI5eFdzU1c5MTNPRExKN2EvcmhSSGhibllLNitkT0k5NTBCRDZubi9uTWJC?=
 =?utf-8?B?YmlVa2pOUHdtdDVPdTA5OEhWYUVmc3NQNXZmTlEvVk93ODN5KzV2NjI3YVFF?=
 =?utf-8?B?anhKMzRpaXZXWEZsdUV6d3F5L3QzaXk5ZmJXWHhJbFRLS1g1TG9MNGNONXBR?=
 =?utf-8?B?UjFReGZ6dktVRmVTU3FVZDAxL0pFM09pSkRGZGpabTVzbm5uZUJ3WGxGK09E?=
 =?utf-8?B?MEFkajYzazBPY2hkZ3ZSTFBLWldwdy9XUGxWYXQ4R1BzK2NwZHh6UmZ4RWFE?=
 =?utf-8?B?MUtRVGFzeWlnL2x0SFZuQ1JTeEw0VDVndnRBdG9MT3hmamJpYWhGMk0yUUw4?=
 =?utf-8?B?NlFKbTlvcjRDU2VYaTNZSCthb2Z1MlM5eXM4V0dNenlqRkNWa3o4SkJBRHUx?=
 =?utf-8?B?N096ZlAreDdlNlc2VUxLTXlnMkJtNGZOSjNlVFJSWEJRU1FFSHFrRFpVYXl0?=
 =?utf-8?B?NHhKZVFJNUhoZ2FPa1VkaGRTRnU2UXNvVThGK2hWQjdBL1lyYS9Id2NiN3dI?=
 =?utf-8?B?dDA0a1hUWUp6K1V0NmRlVDRjZEJkNnQ4RUlZZ3kyOVJyM1J5U1pQeFJacEYv?=
 =?utf-8?B?VlFJNWhxdmhkUTFWT1RDY04vOWtHQ3JvUHRqWEdjZy9valpWQzhGTE5YYjFS?=
 =?utf-8?B?aUYxQXg3eE9ITHAzOFZ6T3dsTk5XMWJUY3FJMGxvRnVkY0tobDh6SkFtQnQy?=
 =?utf-8?B?NzJuMU1GZDhLVEc5eThFa210VzFPZzFGeGhPMFN0VGhsYjFrSnlKSEFYQ3BY?=
 =?utf-8?B?TzFKMUUwcnJyOHRXNEhIWkpMZGxCZWxuNEx6MGFvZkFKT3FjZjNrNGllVFVm?=
 =?utf-8?B?NjNxSU1EQ1Rrb0trSkk4UFYyMklpWUZTYVNDM3ozUzBDa1lVOGlleDM3a2Y0?=
 =?utf-8?B?NDRUek9ReG9CMzlKaFdubjNER29wRVc5TlJ4WEhnSDRGWFNRZHMrTkhtV290?=
 =?utf-8?B?cnBsTENHQ2NVM2pCYlgxZHpBSWFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b293e8-265e-4cf7-0b6e-08d9b5baae5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 17:39:24.2162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t666OhkjGf2ukwuIhXIOFGp32tkPeNe42+wYCWPFgtXmse6PcspreJX9PgrkUulNpQNYsgQDjvxEGD7wLbX/10fecFygQjq7tQt4eJOyMTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0608
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsDQoNCj4NCj4gPiBGcm9tOiBWb2xvZHlteXIgTXl0bnlrPHZteXRueWtAbWFydmVs
bC5jb20+DQo+ID4gDQo+ID4gQWRkIHVzZXIgdGVtcGxhdGUgZXhwbGljaXQgc3VwcG9ydC4gQXQg
dGhpcyBtb21lbnQsIG1heCBUQ0FNIHJ1bGUgc2l6ZSANCj4gPiBpcyB1dGlsaXplZCBmb3IgYWxs
IHJ1bGVzLCBkb2Vzbid0IG1hdHRlciB3aGljaCBhbmQgaG93IG11Y2ggZmxvd2VyIA0KPiA+IG1h
dGNoZXMgYXJlIHByb3ZpZGVkIGJ5IHVzZXIuIEl0IG1lYW5zIHRoYXQgc29tZSBvZiBUQ0FNIHNw
YWNlIGlzIA0KPiA+IHdhc3RlZCwgd2hpY2ggaW1wYWN0cyB0aGUgbnVtYmVyIG9mIGZpbHRlcnMg
dGhhdCBjYW4gYmUgb2ZmbG9hZGVkLg0KPiA+IA0KPiA+IEludHJvZHVjaW5nIHRoZSB0ZW1wbGF0
ZSwgYWxsb3dzIHRvIGhhdmUgbW9yZSBIVyBvZmZsb2FkZWQgZmlsdGVycy4NCj4gPiANCj4gPiBF
eGFtcGxlOg0KPiA+ICAgIHRjIHFkIGFkZCBkZXYgUE9SVCBjbHNhY3QNCj4gPiAgICB0YyBjaGFp
biBhZGQgZGV2IFBPUlQgaW5ncmVzcyBwcm90b2NvbCBpcCBcDQo+ID4gICAgICBmbG93ZXIgZHN0
X2lwIDAuMC4wLjAvMTYNCj4gDQo+ICJjaGFpbiIgb3IgImZpbHRlciI/DQoNCnRjIGNoYWluIGFk
ZCAuLi4gZmxvd2VyIFt0ZW1wYWx0ZV0gaXMgdGhlIGNvbW1hbmQgdG8gYWRkIGV4cGxpY2l0bHkg
Y2hhaW4gd2l0aCBhIGdpdmVuIHRlbXBsYXRlDQoNCnRjIGZpbHRlciAuLi4gaXMgdGhlIGNvbW1h
bmQgdG8gYWRkIGEgZmlsdGVyIGl0c2VsZiBpbiB0aGF0IGNoYWluDQoNCj4gDQo+ID4gICAgdGMg
ZmlsdGVyIGFkZCBkZXYgUE9SVCBpbmdyZXNzIHByb3RvY29sIGlwIFwNCj4gPiAgICAgIGZsb3dl
ciBza2lwX3N3IGRzdF9pcCAxLjIuMy40LzE2IGFjdGlvbiBkcm9wDQo+IA0KPiBZb3UgYXJlIG5v
dCB1c2luZyB0YyBwcmlvcml0eT8gQWJvdmUgd2lsbCByZXN1bHQgaW4gdHdvIHByaW9yaXRpZXMg
KHRoZSAwLjAuMC4wIGVudHJ5IHdpbGwgYmUgbW9yZSBpbXBvcnRhbnQpIGFuZCBpbiBjbGFzc2lj
YWwgZmxvd2VyIGFwcHJvYWNoIHR3byAgZGlmZmVyZW50IHRhYmxlcy4NCj4gSSBhbSB3b25kZXJp
bmcgaG93IHlvdSBtYXAgdGhlIHRhYmxlIHRvIHRoZSBUQ0FNLg0KPiBJcyB0aGUgcHJpb3JpdHkg
c29ydGluZyBlbnRpcmVseSBiYXNlZCBvbiBtYXNrcyBpbiBoYXJkd2FyZT8NCg0KS2VybmVsIHRj
IGZpbHRlciBwcmlvcml0eSBpcyB1c2VkIGFzIGEgcHJpb3JpdHkgZm9yIEhXIHJ1bGUgKHNlZSBm
bG93ZXIgaW1wbGVtZW50YXRpb24pLg0KDQo+IA0KPiBjaGVlcnMsDQo+IGphbWFsDQoNClJlZ2Fy
ZHMsDQogIFZvbG9keW15cg0K
