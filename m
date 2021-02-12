Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA6319B8A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBLIzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:55:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53476 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBLIzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:55:36 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C8lsMS000555;
        Fri, 12 Feb 2021 00:54:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=VAII6T4wUyq+mdMDrik+Ji7WBsnAJJarMkJ9TbyVU28=;
 b=a4mnoPuH3Ft4EQgozrzFNqu7QZZ6zCZrsV4kvc++kWJswcShjzShYyd0Ea0EaJvkSQBg
 VOQJepgYegz04CVAT+uJOt9Q99Psa+YvOscC2l/j8Vg7hH8c1oqmPk4/TO0wM10Y8itn
 IFnizMVJmAKFBXV9zJzGC6W38QTY440ItNoJ1ciLBBC+anVeroSi3vg8O+whrBVDCXLg
 ZAP+FM1wxnOuklCw+HYsVZPJkfHWdg6MaP+tuWBdRUal1CGCWeh/83es0oa3FW0FwDCB
 YSWG+fHCpiN8RM2PAZjQ2yHsXH5hXnfDsR0+2h4/ub0mKdE//g/guVgZOUBItzK5Dgbm mA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqhv7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 00:54:35 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 00:54:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 00:54:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.51) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 00:54:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m42WN0ZMQrbe8N79EMTLWJlAwgUbn2BRE+mDvFq4kyXgVWjKyidnXCCnj2OWtuilD/zEqti4PX0ZQ+q+ioHCR9Z/QARGySR8SFcwdztoeyDBmyfzWDZlR1XQSYkA9QE9r0S76p7RPET0Yv0cmIDIdyKAp1Zr61F4CVZ6oqKdtuwU2C5ph7JHgscZtFNTJ9FXP1l/J5Sh/HyzhhUr5UbsKJgAjSjyskLko75txvUUJLXmMPBYGp52PunjZq59kw84gS8RC3Sdn0DT3Vdfitp3wt6NZHpVseZ7hSXDtWz5A+00pYCKUuLp8haOzmQgMj0yF0QAUIQlSJ/6Ubsp2gCnaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAII6T4wUyq+mdMDrik+Ji7WBsnAJJarMkJ9TbyVU28=;
 b=Wqxb+ElKQP6P6nLCXHX+pvoUyQhKHIW1mTbMG7ITUqsZ9jgkX/vtwgV59jkza1zzVLoaMRFmn42Onr+E3WIGTG//EJ4XNfxEQiDT6SxxpyvdFBjzYgb7kHsiakuWzJDF0ZoFJP2qRS3PtyqWPpp3dhow3vkg6Xo1Ea+4TpOSWzaO7prnikGClAZ/TQBw8r1a0i4PpoyZrgnOkLaut7hfn4dlmKmhxHCUM0GemPYxABu4W4F+64fSn3gAQNu6HJxnszO2W5Z2A8uQZO/ysWTI8XEXhtGvEybOtzYDSzFB65whUksRoN1RkVeQAVhSATPpy7NH9XaLFqezHPp7/KN0OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAII6T4wUyq+mdMDrik+Ji7WBsnAJJarMkJ9TbyVU28=;
 b=Y2woFPkNUb4jwKTRPSIq/tpG7HcxnaXQAWhLIWww098aZPrmD3Sg4GD1ZAQS7gC/2pxpVLTLKXvF/29CVdYfZxSvXOFlXxN7PlnDp/wxcLnSNf0lK75hepbM1zVJaPjfsOryngAxxtT816HLA7L2GaO+8YqPmoKsfqjnDHW1VQo=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1423.namprd18.prod.outlook.com (2603:10b6:320:26::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 08:54:32 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Fri, 12 Feb 2021
 08:54:31 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 00/15] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH v13 net-next 00/15] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHXAGOJKF0hxOrPWECmmbtkDlMuzKpTkpAAgAClgZA=
Date:   Fri, 12 Feb 2021 08:54:31 +0000
Message-ID: <CO6PR18MB387348F61E697A8BB3593781B08B9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <161308442026.22878.3631243118969933506.git-patchwork-notify@kernel.org>
In-Reply-To: <161308442026.22878.3631243118969933506.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91aa9bac-bfb9-4a9c-043d-08d8cf33d06b
x-ms-traffictypediagnostic: MWHPR18MB1423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB142352313764AB9CBB2D0DFBB08B9@MWHPR18MB1423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pL4OdNRPSkI3UeISP+PHbOeCpza9c4MAhkpyYds4xQeEl03D5rtczILxHVmb6HfIT9UWKm7d90ySyI9C6ulxL6k4avkiZ6iNmDbKllkGfaTSLYzdgQYJfI34oIW5xAOb3htlE+R9YU5DIXYogE7erAiZItW13tKkK/vGgpKs2Wpq9hWVszvou2RCKjYchqWPgcoRN0IwLaSobi6z6z//PS01rVZBHHsVPY7sg0lP6Y7V+yqyrrIfyMiiTQzAsGaJGGvddKmCsHHJkeQhM3Z8Y5sRMzkX9ZQPROLMMmOeibsNM1MeRS9OP42AsiY2BlqG3dHeigKkX5eL9hqnZ8qtHFe8WtGDo75CK3OClLXhAPW1WQJr5nkE30XQkg6kfdeFHIPRb2hGQuw2X+ubLLYAyt5X9dqa3CaI0eBDe2ynMUXZehHZ02mbkGCaisGTDkelXe2mMY5KSRaUXnBqRgJBOv+lCYXltHuWfKmW3WbvKu9/QFEKql5pKcPvUqMj4IiMFUamuoW/CLGVV4VTFAduTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(136003)(396003)(346002)(5660300002)(186003)(76116006)(33656002)(66946007)(7696005)(64756008)(26005)(54906003)(52536014)(66556008)(7416002)(316002)(6506007)(66446008)(66476007)(71200400001)(9686003)(83380400001)(2906002)(8936002)(86362001)(4326008)(55016002)(478600001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z25ScGMyZmlveWNNWEtHT2JGdEh4bkNzbTdacThUbHpYRlJ4OGV6czN0ZUZp?=
 =?utf-8?B?Z09wR25BVkozQXYyVVI4emFMRHU4cUl2QmRQSUZQTWJKcC9FWnZVVllscHZK?=
 =?utf-8?B?VncvamhhNWRaVnFHT3NGeEhVcVYzMkJWSkF0VmtqSGpoRG9LMW0yd3JCTGcx?=
 =?utf-8?B?RkNRTXIyaWF2bWJJZEdGa1BIREk5bEVMbUdFSXFuV2tVN0l4SkQwUDR3OVZo?=
 =?utf-8?B?YllFN0Qxdk9BQXFEUGRnbXBMeWxEU0l2alpESFNlUFlQdVNwLzFxRDlteDEw?=
 =?utf-8?B?TzZ3SUNrTXR0d1lNR2tBN0k0V2hLRlJsbkhDQndKeTNoZnVpRm5yN3laVUkv?=
 =?utf-8?B?UVlycU5CWHVrQWN0dnRkM09IR2Fkdi9sNnlHTUF3S0I1anVHa2RvWDhKODdr?=
 =?utf-8?B?emdjYXlwbDJtODBWOTVtcmo4R1hrSktrOGhXSGZxUnZ4VkpvYndRTUlVbHBU?=
 =?utf-8?B?UmRpS3pHZkl2S1p1bEM5Rm5Ta0JlSVQ5OUFSUHZ6RzcyZVNZRlhrSXdvN2s1?=
 =?utf-8?B?aUpxVkFQYXR6NFhVUS92OVpFQm16M2RCRlVCQm41WUN1TCt6QzFMWWhrUHdP?=
 =?utf-8?B?cWc3Mm81WkFkRThxMXA5VUZVNUUvT2lwb3Z1bUFnQnk2a2t0SU1zNjREajV0?=
 =?utf-8?B?NFkvRmQ1WDR2QmlLTytIclhic25Edm5ubG0zVUJxZDNiNS92WEpITFZ6c2FB?=
 =?utf-8?B?dzJxSVRzWmdlRG1BenZQcDhIZDlYVE0yWmdQRWJGYjBidHpNYmlDV3greFJL?=
 =?utf-8?B?bVRiNGRwK0pDMnNrWUEyMDVuK2MxSFFYSWo3bWV6MUdZN0dVOXdQa1dlbWtv?=
 =?utf-8?B?Qzh3ZmRFL3hZUlBYN2Q1K3BlS3JWdk9EVzFVNGI0M3JubkNaSFI0K0lCdWdv?=
 =?utf-8?B?TW4vNmNiZ0xhaUd2QU02cnQ4QTA0WWwxanZlYU9DNWxmUDk0aUk3VGRQY2FH?=
 =?utf-8?B?MDZhZ3MvVWJoQVpaK0pnK3JWTlZFWWcra3JaajNocUtZbkpLamxZWmk1RTNP?=
 =?utf-8?B?Tk1VOWZVakNXUDNzTGtMMHlOcFZvcHNqVnFZUVhkV2tKTzl0NEdTRWt3VUxv?=
 =?utf-8?B?dWFwOVdEWXB5Z3IxVnRaWVYyd09mSkltZmdhQWV0NCt2VFlPM3A0c0hJempP?=
 =?utf-8?B?NEpKMG5CRFdGa1VyVU5FUjQxMU5RdW8reXp6TStBYWYyV2ZBMDg3YzdEdTdF?=
 =?utf-8?B?NUlaa0Q5LzZwajcvanptNXNRV042WFVzTm9aYVk2L01jWFRRWlR0VUFUYVFo?=
 =?utf-8?B?eEExVTdFeXhuK3k3ZS9kZXJlS3ZuUXI1by9ob2JlVllTUkx1NDlVN2JGcm96?=
 =?utf-8?B?UWhtamJyNlZiOXdFK2JuQVEvZEt2MVE5WlFtbkc0VXEwNkNGM3k0d2Q2eVQv?=
 =?utf-8?B?TEhNRTRDYXhiYnhnNFdTTXAybmhYUWthZjZjWTA3bDlqWXF6UWI5d1hYL2dm?=
 =?utf-8?B?WFhVa3ZnUFFRNVRobWhRT2hSTzFIMnBSM2dNRDI2RjlKR1FDQVRYMzJFWGFD?=
 =?utf-8?B?RWRScVVQcERSQ0NTYUxybGZsTWtiMnZqeFpJeHpoTFlDNy9NbTd0K2JSZTVW?=
 =?utf-8?B?cjVJemFHQk1JblpweC9SZklOYm1nR1dhVW1OMkkvQzFNTklGMVdyQlFRQmtL?=
 =?utf-8?B?ZDZoTWdDNVQ5aE84ckhRaXJlMVh1V3A1TWtVTHFqMElHL0JSZU9xV211YS9O?=
 =?utf-8?B?S055U3lqb1hRUkhtQkNWdGFvbEZYRk8vNy80NHpvdkV6MXplWmRKbExEMnVZ?=
 =?utf-8?Q?4jWaJw4Xef40e64Ozo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91aa9bac-bfb9-4a9c-043d-08d8cf33d06b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 08:54:31.8168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMiAFuakLd6l3NwimmAq6DqnxyDdV7AZ/unY4+W50v+IMfwLSmCPmP3Mk2pHJC6qJreIUGAWxsjxa3uAvF1MWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_02:2021-02-12,2021-02-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+IEhlbGxvOg0KPiANCj4gVGhpcyBzZXJpZXMgd2FzIGFwcGxpZWQg
dG8gbmV0ZGV2L25ldC1uZXh0LmdpdCAocmVmcy9oZWFkcy9tYXN0ZXIpOg0KPiANCj4gT24gVGh1
LCAxMSBGZWIgMjAyMSAxMjo0ODo0NyArMDIwMCB5b3Ugd3JvdGU6DQo+ID4gRnJvbTogU3RlZmFu
IENodWxza2kgPHN0ZWZhbmNAbWFydmVsbC5jb20+DQo+ID4NCj4gPiBBcm1hZGEgaGFyZHdhcmUg
aGFzIGEgcGF1c2UgZ2VuZXJhdGlvbiBtZWNoYW5pc20gaW4gR09QIChNQUMpLg0KPiA+IFRoZSBH
T1AgZ2VuZXJhdGUgZmxvdyBjb250cm9sIGZyYW1lcyBiYXNlZCBvbiBhbiBpbmRpY2F0aW9uIHBy
b2dyYW1tZWQNCj4gaW4gUG9ydHMgQ29udHJvbCAwIFJlZ2lzdGVyLiBUaGVyZSBpcyBhIGJpdCBw
ZXIgcG9ydC4NCj4gPiBIb3dldmVyIGFzc2VydGlvbiBvZiB0aGUgUG9ydFggUGF1c2UgYml0cyBp
biB0aGUgcG9ydHMgY29udHJvbCAwIHJlZ2lzdGVyDQo+IG9ubHkgc2VuZHMgYSBvbmUgdGltZSBw
YXVzZS4NCj4gPiBUbyBjb21wbGVtZW50IHRoZSBmdW5jdGlvbiB0aGUgR09QIGhhcyBhIG1lY2hh
bmlzbSB0byBwZXJpb2RpY2FsbHkgc2VuZA0KPiBwYXVzZSBjb250cm9sIG1lc3NhZ2VzIGJhc2Vk
IG9uIHBlcmlvZGljIGNvdW50ZXJzLg0KPiA+IFRoaXMgbWVjaGFuaXNtIGVuc3VyZXMgdGhhdCB0
aGUgcGF1c2UgaXMgZWZmZWN0aXZlIGFzIGxvbmcgYXMgdGhlDQo+IEFwcHJvcHJpYXRlIFBvcnRY
IFBhdXNlIGlzIGFzc2VydGVkLg0KPiA+DQo+ID4gWy4uLl0NCj4gDQo+IEhlcmUgaXMgdGhlIHN1
bW1hcnkgd2l0aCBsaW5rczoNCj4gICAtIFt2MTMsbmV0LW5leHQsMDEvMTVdIGRvYzogbWFydmVs
bDogYWRkIENNMyBhZGRyZXNzIHNwYWNlIGFuZCBQUHYyLjMNCj4gZGVzY3JpcHRpb24NCg0KTmV4
dCB3ZWVrIEkgd291bGQgcHJlcGFyZSBzbWFsbCBwYXRjaCBzZXJpZXMgdG8gYWRkcmVzcyBSdXNz
ZWxsIEtpbmcgY29tbWVudHMuDQoNClRoYW5rcywNClN0ZWZhbi4NCg==
