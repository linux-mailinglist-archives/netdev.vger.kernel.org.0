Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492F4284A7B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgJFKuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:50:24 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:22331 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 06:50:23 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c4bfb0000>; Tue, 06 Oct 2020 18:50:35 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 10:50:35 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 10:50:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOTIVDsI0f0UoUqqLt3nruJcVn+eBXygbIIS+bKQnDAKc8kAEdrjjgI41Bk8IJAspo0k85CPCPW31WRw7Gi2mVMmefqI+HKJFHUy8K1xeMYH6znszAj9flPHgcydzXKwvuFAa0AellwXM5TMdZCGXulVolJ1wX3Czg6GpgrsYco32cZ4QwxebpaOMgUlkxqJ93bjLTG/9qLJ/RcOc2ihcSnuo0FzkXiaQg5RfM9/UfL+jC4mPIxu1mEM4cYH6sjt8HuPcmb4+GuYMbgqvroOE/xqooLcxWQ/cE/sSyDSWEsPsf+UCq3HpgfHWWOtuYQ2OdoDxrV7WJfkZNS8bVNI7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7s6z5gy1pZhuAIIVBcJ6Jtlz2QAR95SIenqWufVAEc=;
 b=ggy+TKe6PoqN9WTYAYD9DyFYwHWXQdv5BZEJjXDl01M2fcaLHzTRbEWM3zlJx+Qe9aTew7WSlnAskZBQIKKCwfIRnzlauHNxYe/pGd/6ekBGgAAZK6roCPL4/4lndIBv28jNsESA3LhLCcPGoFxbtecOsdF51i7aLJxpYtWGV5ms7UlW93OpUfnoTzQPgMNPA90CK1AJ+Ie6WuLwfHt7JyJAzLIxqmgTsYcFjdpktuI1NyHrezvTR8m4DsPnzr2CG2115B1gco1Og/usRreHlD4+7YIj0S+fOxIwNT0X9Ocoxdy+WnOCy4VVuR1l4qk/4HEsreX9v1As4G6a13p6/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3994.namprd12.prod.outlook.com (2603:10b6:5:1cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 6 Oct
 2020 10:50:33 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 10:50:33 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface
 implementation
Thread-Topic: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface
 implementation
Thread-Index: AQHWl95MgESlOxQP00e0G+IClpdO06mCst2AgAZORwCAAWwlAA==
Date:   Tue, 6 Oct 2020 10:50:33 +0000
Message-ID: <fb313c83e6ac750d4bcdf96d2b2d7ebe4ae98dd6.camel@nvidia.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
         <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
         <20201001124929.GM8264@nanopsycho>
         <20201005130712.ybbgiddb7bnbkz6h@ws.localdomain>
In-Reply-To: <20201005130712.ybbgiddb7bnbkz6h@ws.localdomain>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3785a594-a815-4e75-8eb4-08d869e5a672
x-ms-traffictypediagnostic: DM6PR12MB3994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3994307443E2A4627ED5665BDF0D0@DM6PR12MB3994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNUkMj5No0RYaRPAvbqo/3CQF0geU5mnWZi/Y7cCdpCMxZox1ibtMvb/l6TsJ+y/3fUHJ7LO3sRYk47ugfI/qyqvpVuxoF+bsZo3gACRrONkuqzgmpK8Km19CKXYdqWmnnvbCfXWFFi5QO3E8V7yY+Z+JFS6oZ0yGix67qw6U+3UaO5iE+EJxISoISD4wE7tN4NOsW20g7PNqzRV4VwFg/CVBOcC/PMU98WWtHx46jfdDN/nCvMbXUg+sYPS2oe8zrpcFY/HTJ7OANp/xRSquCO6g7cdsPGQFADl6PeGvKKPtZMIvQap+y9UbvGqHo8kr6VGIgxBSjib+bipolo+cQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(91956017)(186003)(6512007)(478600001)(53546011)(6506007)(66556008)(26005)(7416002)(64756008)(66476007)(2616005)(71200400001)(66946007)(66446008)(110136005)(6486002)(86362001)(36756003)(3450700001)(5660300002)(76116006)(8676002)(4326008)(8936002)(83380400001)(54906003)(2906002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Qq0+WzXjk1JgpSlopD7FyXD3ju+DDsXNUdItNgKdEzcHM8VpLl29nR6H8gZBLVPOUXYxIZj3CTleVgY5OwTC+R4/BFuBUVNAd96cazZcRvAAV2D5krdSB29JyWP5pgzkG84pjp++IKY2MeBZyCN7aecuVdTxGnb8Fr+r8AABPoAs16IavFeW0i7xSFWFRQlpHlKUVdRbSAwIm9orBKKOkkT+SW95WFTG+rniElWUkRv+Q2caLpRG485YlEl//Hr39hYseukuSWyojYv8RsjW1Ro+gVNRzCK4ZBGeT7L26IJoYQTS+gSeI2OQ12YUpbLVw31HT0lJsP82Dv/UorUPoUppaMquZU4nfwHfb3PYn0ABSHfYU8jULhd8cS7UdwV+XSJc8ak8kf6KC5jsvOoz/ez+Zn4s9hTsnDlDi22hCSQAYjVOuhZ+45NxC9Ge/PUtgvMiMfyO12fBBlMqndtlE6nuGvKARqZ6QyoA3RWhnnqzoxBgo0o2uHD84+PtKW8QunFwV/K8qc90i2dZibDJ/OHaH5LzVYvhl4GeUoQHloIQ3cHi+PqKncxm6/4xXbPFtIR9J9sX/U2Pc5Dnjq3R291hzfoBnBcHwOJCefxDhCbtJ8e91ldUJZEauaUNUd4i5rPI6Lr9yMOUoaLY1h4F+A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <11B75A87304983429E8F4FD190217A53@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3785a594-a815-4e75-8eb4-08d869e5a672
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 10:50:33.3068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lEad7gcj+g5lE6KdCEPWJY95wt5aCQrIwrdUwkFToK0PJ0/KpdHAQZ8u8jQID6HvmiPRfAcROoAKS6yDZIcGlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3994
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601981435; bh=I7s6z5gy1pZhuAIIVBcJ6Jtlz2QAR95SIenqWufVAEc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=PegHcIiEFm1q1KDR2w4XWOqCRAz3HdfU8Rv4JQQwV9akzoinHiF5zHGEnkgYEVl6H
         Gx1GWa6Gl0NDmO9XEwHmjBCYXEhUNbtCbsEPyWbHtMVd7EWeaoTGTakpTuaRe2KZya
         fm2XO518eBzmeSU3eBdJbfXIWtFhveZ1FQ0SuP1DiEQKYa5OoO7mXS6+b++mKMl+X9
         IUFGVmixHwIIMjWKRC17dnxSWc70dCM8iig1NUM3Io2dukvD6hTRqXncb3FguMOONS
         zBkXPu2Po0p819JvVVQ6WmfMVl6WnZyOzN9f5oZsZ43+wnPI6pdI//M6vOsBNbijIl
         TAX9D/TYAg6JQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTA1IGF0IDE1OjA3ICswMjAwLCBBbGxhbiBXLiBOaWVsc2VuIHdyb3Rl
Og0KPiBIaSBKaXJpDQo+IA0KPiBPbiAwMS4xMC4yMDIwIDE0OjQ5LCBKaXJpIFBpcmtvIHdyb3Rl
Og0KPiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiA+IA0KPiA+IFRodSwg
T2N0IDAxLCAyMDIwIGF0IDEyOjMwOjE4UE0gQ0VTVCwgaGVucmlrLmJqb2Vybmx1bmRAbWljcm9j
aGlwLmNvbSB3cm90ZToNCj4gPiA+IFRoaXMgaXMgdGhlIGRlZmluaXRpb24gb2YgdGhlIENGTSBz
d2l0Y2hkZXYgaW50ZXJmYWNlLg0KPiA+ID4gDQo+ID4gPiBUaGUgaW50ZXJmYWNlIGNvbnNpc3Qg
b2YgdGhlc2Ugb2JqZWN0czoNCj4gPiA+ICAgIFNXSVRDSERFVl9PQkpfSURfTUVQX0NGTSwNCj4g
PiA+ICAgIFNXSVRDSERFVl9PQkpfSURfTUVQX0NPTkZJR19DRk0sDQo+ID4gPiAgICBTV0lUQ0hE
RVZfT0JKX0lEX0NDX0NPTkZJR19DRk0sDQo+ID4gPiAgICBTV0lUQ0hERVZfT0JKX0lEX0NDX1BF
RVJfTUVQX0NGTSwNCj4gPiA+ICAgIFNXSVRDSERFVl9PQkpfSURfQ0NfQ0NNX1RYX0NGTSwNCj4g
PiA+ICAgIFNXSVRDSERFVl9PQkpfSURfTUVQX1NUQVRVU19DRk0sDQo+ID4gPiAgICBTV0lUQ0hE
RVZfT0JKX0lEX1BFRVJfTUVQX1NUQVRVU19DRk0NCj4gPiA+IA0KPiA+ID4gTUVQIGluc3RhbmNl
IGFkZC9kZWwNCj4gPiA+ICAgIHN3aXRjaGRldl9wb3J0X29ial9hZGQoU1dJVENIREVWX09CSl9J
RF9NRVBfQ0ZNKQ0KPiA+ID4gICAgc3dpdGNoZGV2X3BvcnRfb2JqX2RlbChTV0lUQ0hERVZfT0JK
X0lEX01FUF9DRk0pDQo+ID4gPiANCj4gPiA+IE1FUCBjb2ZpZ3VyZQ0KPiA+ID4gICAgc3dpdGNo
ZGV2X3BvcnRfb2JqX2FkZChTV0lUQ0hERVZfT0JKX0lEX01FUF9DT05GSUdfQ0ZNKQ0KPiA+ID4g
DQo+ID4gPiBNRVAgQ0MgY29maWd1cmUNCj4gPiA+ICAgIHN3aXRjaGRldl9wb3J0X29ial9hZGQo
U1dJVENIREVWX09CSl9JRF9DQ19DT05GSUdfQ0ZNKQ0KPiA+ID4gDQo+ID4gPiBQZWVyIE1FUCBh
ZGQvZGVsDQo+ID4gPiAgICBzd2l0Y2hkZXZfcG9ydF9vYmpfYWRkKFNXSVRDSERFVl9PQkpfSURf
Q0NfUEVFUl9NRVBfQ0ZNKQ0KPiA+ID4gICAgc3dpdGNoZGV2X3BvcnRfb2JqX2RlbChTV0lUQ0hE
RVZfT0JKX0lEX0NDX1BFRVJfTUVQX0NGTSkNCj4gPiA+IA0KPiA+ID4gU3RhcnQvc3RvcCBDQ00g
dHJhbnNtaXNzaW9uDQo+ID4gPiAgICBzd2l0Y2hkZXZfcG9ydF9vYmpfYWRkKFNXSVRDSERFVl9P
QkpfSURfQ0NfQ0NNX1RYX0NGTSkNCj4gPiA+IA0KPiA+ID4gR2V0IE1FUCBzdGF0dXMNCj4gPiA+
ICAgICAgIHN3aXRjaGRldl9wb3J0X29ial9nZXQoU1dJVENIREVWX09CSl9JRF9NRVBfU1RBVFVT
X0NGTSkNCj4gPiA+IA0KPiA+ID4gR2V0IFBlZXIgTUVQIHN0YXR1cw0KPiA+ID4gICAgICAgc3dp
dGNoZGV2X3BvcnRfb2JqX2dldChTV0lUQ0hERVZfT0JKX0lEX1BFRVJfTUVQX1NUQVRVU19DRk0p
DQo+ID4gPiANCj4gPiA+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVs
dHVyQG1pY3JvY2hpcC5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVu
ZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3JvY2hpcC5jb20+DQo+ID4gDQo+ID4gWW91IGhhdmUg
dG8gc3VibWl0IHRoZSBkcml2ZXIgcGFydHMgYXMgYSBwYXJ0IG9mIHRoaXMgcGF0Y2hzZXQuDQo+
ID4gT3RoZXJ3aXNlIGl0IGlzIG5vIGdvb2QuDQo+IEZhaXIgZW5vdWdoLg0KPiANCj4gV2l0aCBN
UlAgd2UgZGlkIGl0IGxpa2UgdGhpcywgYW5kIGFmdGVyIE5payBhc2tlZCBmb3IgZGV0YWlscyBv
biB3aGF0IGlzDQo+IGJlaW5nIG9mZmxvYWQsIHdlIHRob3VnaHQgdGhhdCBhZGRpbmcgdGhpcyB3
b3VsZCBoZWxwLg0KPiANCj4gVGhlIHJlYXNvbiB3aHkgd2UgZGlkIG5vdCBpbmNsdWRlIHRoZSBp
bXBsZW1lbnRhdGlvbiBvZiB0aGlzIGludGVyZmFjZQ0KPiBpcyB0aGF0IGl0IGlzIGZvciBhIG5l
dyBTb0Mgd2hpY2ggaXMgc3RpbGwgbm90IGZ1bGx5IGF2YWlsYWJsZSB3aGljaCBpcw0KPiB3aHkg
d2UgaGF2ZSBub3QgZG9uZSB0aGUgYmFzaWMgU3dpdGNoRGV2IGRyaXZlciBmb3IgaXQgeWV0LiBC
dXQgdGhlDQo+IGJhc2ljIGZ1bmN0aW9uYWxpdHkgY2xlYXJseSBuZWVkcyB0byBjb21lIGZpcnN0
Lg0KPiANCj4gT3VyIHByZWZlcmVuY2UgaXMgdG8gY29udGludWUgZml4aW5nIHRoZSBjb21tZW50
cyB3ZSBnb3Qgb24gdGhlIHB1cmUgU1cNCj4gaW1wbGVtZW50YXRpb24gYW5kIHRoZW4gZ2V0IGJh
Y2sgdG8gdGhlIFN3aXRjaERldiBvZmZsb2FkaW5nLg0KPiANCj4gVGhpcyB3aWxsIG1lYW4gZHJv
cHBpbmcgdGhlIGxhc3QgMiBwYXRjaGVzIGluIHRoZSBzZXJpZS4NCj4gDQo+IERvZXMgdGhhdCB3
b3JrIGZvciB5b3UgSmlyaSwgYW5kIE5paz8NCj4gDQo+IC9BbGxhbg0KPiANCg0KU291bmRzIGdv
b2QgdG8gbWUuIFNvcnJ5IEkgd2FzIHVucmVzcG9uc2l2ZSBsYXN0IHdlZWssIGJ1dCBJIHdhcyBz
aWNrIGFuZA0KY291bGRuJ3QgZ2V0IHRvIG5ldGRldkAuIEknbGwgcmV2aWV3IHRoZSBzZXQgdG9k
YXkuDQoNCkNoZWVycywNCiBOaWsNCg0K
