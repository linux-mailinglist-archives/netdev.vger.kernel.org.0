Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D452E90E1
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 08:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbhADHWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 02:22:32 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7552 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbhADHWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 02:22:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff2c20f0000>; Sun, 03 Jan 2021 23:21:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 07:21:51 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 4 Jan 2021 07:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhAjcUzHz6fFWlY6o+sOnITGS534OBATvSec1M6DWzhI1t3/HcnD7zMVBnqSN10UFxyy82AOrZItFwDw/NVIBGPP3A2VqcLcrrIzFQLmTc3pwl7xOsBOFmkjZaFf1JP/xVY/Vo7MarUzp1KVJgNQpEFZoUw3x5pbmesO1o7QCofgMfCGcP8IeQwaIl/P9xrsySPwHAHURcq3yz2ouaefq/VL/HHbRyepfMT7FLIrI93eydNKnC1+0TAdpOSkY+BOHqBkOJiZYXEDNc+nMl0+dAvbypPrtNLTaL9qgawdUpAkMTP0B3dy2Za0jBzw2hX18YJBicI2Ax8pR6HFnuEcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNuubdsWK54nAf+/QKZFO9ZRJY+jlFDkiZC8kaVNLHI=;
 b=SluqO/OUwadsg57vth/8GRZdyYfofe+us9ASQlZRzeUEs3PGDM6KeOPrVjeGeaQ4MMUI1lSZxlxOuzPAG/DeN1Lc77PqsSXsC5JGwCj0ddnhXSCE74dtiigEgiEPF6NbGYXhVg79XW5f1XUmoYY91qXnr75uuzews+Ex5OSVbT3lGiagopkcwHZuAjsp3Xxa9G3zJQCWrsKOFfPOfRIQ1TXeKC5uJ38dP4DXYrRaEMq64BhW7sEJ9H0QR9WV9pZTIHBOvkFP12PwPAtOE964/0yuRJ0mK9stJXmbWwRPByaIyKrmdz5Q7FSQNuszldyhEgEzAqUIzhCUC0Dvwk4DWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3908.namprd12.prod.outlook.com (2603:10b6:a03:1ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 07:21:50 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 07:21:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW4ko9h0JE1/siD0Ci/a57He1kKKoXC0cAgAAD48A=
Date:   Mon, 4 Jan 2021 07:21:50 +0000
Message-ID: <BY5PR12MB43227F9431227959051B90B1DCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-8-parav@nvidia.com>
 <ea07c16e-6bc5-0371-4b53-4bf4c75d5af8@redhat.com>
In-Reply-To: <ea07c16e-6bc5-0371-4b53-4bf4c75d5af8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.203.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c28f715e-319b-4e37-2780-08d8b081673d
x-ms-traffictypediagnostic: BY5PR12MB3908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB390873C49549C4DABD0DE996DCD20@BY5PR12MB3908.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZGmgMoWeQQuCpkMBstQIKkQC5rvwaLuxS3wxZzDHonXIMb6LG7JZ9AkJSnoBSDiOpDMUu6aVFLZZsGIYjsULYZJh7PClNGB7X4COlonRKZ5f08o8dL5K6nwAM/qXCvRaqJDiqqd5+ipPghm0i4sS4uVSiChruvgYjCxAfVsgn+ztCTTdIgbl9LGRAyz25NM1NfQKW4FQ3jlXKBxIE2CbbbS31pi4ppY9IK0eomSgid6pHs97QTyvMQsxIkXAHBE+V3k9tS0DEIPR7oDHR4busnp3cQpB0WB39n+J/W9u9HakRiNJa9OMLLoTsW6t5k5GZacAVGFIh+nl6jrOJ5jTfr8KkHB93A4nwJufPQjOARY6PzUYohrpA9Y6crFa+wAglhIe1lxkEDixfQ2U6PK3SA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(8936002)(7696005)(4326008)(478600001)(33656002)(186003)(6506007)(55236004)(66446008)(64756008)(66476007)(66556008)(26005)(52536014)(8676002)(2906002)(76116006)(71200400001)(110136005)(66946007)(55016002)(9686003)(86362001)(316002)(5660300002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c09mNnJpRkdSLzQ1eVBKUHRwRlJyRlBxMnpwNkF1c25uL0ZEMWdmYUlOZUJt?=
 =?utf-8?B?N0hrWlVZMU56NHRiQi9lc0lGUDZEYk4reVpTR2YydVBlV3hXellBM3ZwV0My?=
 =?utf-8?B?aERaS2xtelJVOHI1akdsR0hSL3JZRWNUMVdvT0FGSkxWUEFPR3BMcW4wdUI0?=
 =?utf-8?B?OVBpQjdnZWNKaWdSNjhjVlhaL0QyT0xIMHhwRm5Gb2ZUWmxmWFUvdXlLeEZW?=
 =?utf-8?B?WTR6MGhpa1BvWGsrTTQwWUtiSWNSRmJRM3VHUGFnelJhMHlYb29yaVhrdTdO?=
 =?utf-8?B?WmhDNzY0L2dNRld1b1dja1Z5dzAxRDFJMGZjb2xwWk9Bc21xYmh0RkNMNWhP?=
 =?utf-8?B?Mmd4Y1QvNCs3WnpSSHZTTzQrTzg0Z1BKTzFGaHVCN2RhZzVGMHZGdWZ0WWRM?=
 =?utf-8?B?MmM2UVpqcnZUU3dId1lsVHVRZVhJK0g0bHpPdTBQb0hkMG94UlNNSi9CRVVN?=
 =?utf-8?B?U3FmanVqRitLKzh6c1dWN0VxNUlGZmc3eTYxMU05NE1hQmk0cEFMMHE4TWV1?=
 =?utf-8?B?bnRtL3hDWDVQb0VSMjF1d0lRNFBKSG9nWE5xUEpoNzlvR2dxMjlmVzNBdnlp?=
 =?utf-8?B?b2gwNmkyUlFlOVVVRFZkc3BhUGJnU01kbUhhbWVabHhMbis4Qm1xb2JwQnZJ?=
 =?utf-8?B?OVM2cDBVb01Xd3F1akhzbzhPKzl5Z0tXOU5xRmk4aUlRTnZDVVZ2NWhFcXhn?=
 =?utf-8?B?c21ta2ZxdmdCRFJkQnUxcjlDS1gvOUZRemlYemh6bTJLZVBSQkVnV3dkWEZI?=
 =?utf-8?B?bk1FcDBZUUtIZGtSZnRzMmVQNlBmeGY0MmwxVWJncG9Pc1pIOEhicHhkNDJs?=
 =?utf-8?B?akdHNWxsT09SRXJVMk1WYVB6Z0t4YzBudy9PZDViMEFsVm55QTE2bFlocXAz?=
 =?utf-8?B?N2UvWmQwZGo2Sm5Dc0JsWlNMemV5TXU1ZUt6bTZZQXgvVlhEbEZZS1EvL0xP?=
 =?utf-8?B?dGsvODBHcDhLZHB6YS9XMW1tQi9XMDhqY0dFMDFQMFlUYzhkdnBnQ2l0eGJN?=
 =?utf-8?B?RWRJR2U1eFFqWDJySjlRbVgxenpUM0NUSHdKeHVXUTB2VW5wYUx4ZmRiZTBX?=
 =?utf-8?B?NVpzUTd3YlVmWFNQUHM5VlZLN3RoWkVTNlIzeWtPUjRmTGw5SGVOYmY4eFY3?=
 =?utf-8?B?eVpHVW80ZGZxd2x3ZnhlTU5hQjVuMXJ5SHpENGVKb0UrMHh0RnFyS1k5SWVi?=
 =?utf-8?B?TGtROStIWTRibm03Q3JlTGJ1MjcwdHA2SlhDL0lZWlhseStWM2EzcUFNVG1l?=
 =?utf-8?B?emNxMXR3cnorME5kc1RENU1qYUtVb3FBa1E2NkdUenprYWtDRU92V3dlZ0hG?=
 =?utf-8?Q?xgmpeV9wp5hTY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28f715e-319b-4e37-2780-08d8b081673d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 07:21:50.1907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 00elCwzPkDO1IQP7yLqEtfOY1WoFT+x9XMmm6zp6S2zSOWStIHM5u3zsH4AgEzzb8Vq9h60DTKl/zv23Wu79kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3908
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609744911; bh=DNuubdsWK54nAf+/QKZFO9ZRJY+jlFDkiZC8kaVNLHI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=DrPVYGYtdaTRJ0ausN5wv5/+kcodaSx/Ls7QxfDCpNQyDakqD5NMPt5fDlPHU3VDF
         g5nKjQqm+2M4nuzO6LNqp3EBeSXz6wb9IgYwOk2jwpYYe799CKTlMLODibSNt6uWjf
         GSQi5+C1odwR8mfHmFYaYPA/8UgbayzjXvs44Rs6z1QGpIPqxT39IspwG48lZ6+1OY
         W1VGz45Pg0IqyPliYRvSw58yARdAi8TVJsVPBNfhRd/owp/rK1kTqBkv502aOO2JtI
         FqNfMvG8BWpHZXuE8hzWO1U14QCkPsR4cx+6OYdAn4FpRoKSEv7YiooA31ALabtO6A
         wezB7vxA5EAPA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogTW9u
ZGF5LCBKYW51YXJ5IDQsIDIwMjEgMTI6MzUgUE0NCj4gDQo+IE9uIDIwMjEvMS80IOS4iuWNiDEx
OjMxLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gICBzdGF0aWMgaW50IF9faW5pdCB2ZHBhc2lt
X25ldF9pbml0KHZvaWQpDQo+ID4gICB7DQo+ID4gICAJaW50IHJldCA9IDA7DQo+ID4gQEAgLTE3
Niw2ICsyNjQsOCBAQCBzdGF0aWMgaW50IF9faW5pdCB2ZHBhc2ltX25ldF9pbml0KHZvaWQpDQo+
ID4NCj4gPiAgIAlpZiAoZGVmYXVsdF9kZXZpY2UpDQo+ID4gICAJCXJldCA9IHZkcGFzaW1fbmV0
X2RlZmF1bHRfZGV2X3JlZ2lzdGVyKCk7DQo+ID4gKwllbHNlDQo+ID4gKwkJcmV0ID0gdmRwYXNp
bV9uZXRfbWdtdGRldl9pbml0KCk7DQo+ID4gICAJcmV0dXJuIHJldDsNCj4gPiAgIH0NCj4gPg0K
PiA+IEBAIC0xODMsNiArMjczLDggQEAgc3RhdGljIHZvaWQgX19leGl0IHZkcGFzaW1fbmV0X2V4
aXQodm9pZCkNCj4gPiAgIHsNCj4gPiAgIAlpZiAoZGVmYXVsdF9kZXZpY2UpDQo+ID4gICAJCXZk
cGFzaW1fbmV0X2RlZmF1bHRfZGV2X3VucmVnaXN0ZXIoKTsNCj4gPiArCWVsc2UNCj4gPiArCQl2
ZHBhc2ltX25ldF9tZ210ZGV2X2NsZWFudXAoKTsNCj4gPiAgIH0NCj4gPg0KPiA+ICAgbW9kdWxl
X2luaXQodmRwYXNpbV9uZXRfaW5pdCk7DQo+ID4gLS0gMi4yNi4yDQo+IA0KPiANCj4gSSB3b25k
ZXIgd2hhdCdzIHRoZSB2YWx1ZSBvZiBrZWVwaW5nIHRoZSBkZWZhdWx0IGRldmljZSB0aGF0IGlz
IG91dCBvZiB0aGUNCj4gY29udHJvbCBvZiBtYW5hZ2VtZW50IEFQSS4NCg0KSSB0aGluayB3ZSBj
YW4gcmVtb3ZlIGl0IGxpa2UgaG93IEkgZGlkIGluIHRoZSB2MSB2ZXJzaW9uLiBBbmQgYWN0dWFs
IHZlbmRvciBkcml2ZXJzIGxpa2UgbWx4NV92ZHBhIHdpbGwgbGlrZWx5IHNob3VsZCBkbyBvbmx5
IHVzZXIgY3JlYXRlZCBkZXZpY2VzLg0KSSBhZGRlZCBvbmx5IGZvciBiYWNrd2FyZCBjb21wYXRp
YmlsaXR5IHB1cnBvc2UsIGJ1dCB3ZSBjYW4gcmVtb3ZlIHRoZSBkZWZhdWx0IHNpbXVsYXRlZCB2
ZHBhIG5ldCBkZXZpY2UuDQpXaGF0IGRvIHlvdSByZWNvbW1lbmQ/DQo=
