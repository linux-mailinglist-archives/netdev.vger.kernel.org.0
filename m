Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2359E289B6B
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 00:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbgJIWDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 18:03:11 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:12414 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJIWDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 18:03:11 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80de1b0000>; Sat, 10 Oct 2020 06:03:07 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 22:03:07 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 22:03:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po4nQCTnvEM+UOUqr53ebzqqtBJOBizrrc0Ofmn22W2eshC+a2PM2CINS8E//QsCFshaYCW7CdIcFv1L3M5M1Cy+r7lUUGPPZSaRjS/8xOf3IWrpHKhLECja9hlDmoSwrdJz101SHYNjHG+aqWocKZssbW7pF2iEaXbRNYGQ+Phs8ILkOuM+b4fUcdb/bPa2Bz7TLxddjzIYtCBgkRV9I7Stc1CJwnXG0gpr7+5G0FdseL3o1jYrry/mdtLDuWNdX68vCiiWOeV+jW0NggznFFnU8BeI7ParAaEgn2VDJPsur4GQSqG1aIPamTKknnG7b3gJgKJrKuRESLaThebGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGXJ+LTQoiD5c4S0yl/em0VEkTNkD9ydxLfXiSDNQyE=;
 b=PjCkw9t9SShK7rhYqruVe5HtsO24xdshC0OCE0GhZ5KFcEtSLyMFIB6yTzSgP6bo0dmUeHJcJ7ziQHqEexQi3oldSNlghGuVl7+y2U+Q2+EQG87HRbe3ZYBipW0Wrh5e9LCdP28vQv8dqIrWwlcrU7VyyyZ4Xmn7UgXlwnb4x0W8AqTqjbPtSOuJHNWks8aQ9M1DmLS5munc7LNeh2zeGGZ5k5ntBFleIA2ybSoi05VoKnx7JsQmJutBWte04o2KC/k6UXAtl7jrv8/DsFi96M0+5B/M4Vt1Rr74C6ZYAglGw0ruWQFQcjCNnzkNdS7+Y2ZZ+1ipXEwyPEjhUSLlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM5PR1201MB0042.namprd12.prod.outlook.com (2603:10b6:4:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 22:03:05 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 22:03:05 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 10/10] bridge: cfm: Netlink Notifications.
Thread-Topic: [PATCH net-next v4 10/10] bridge: cfm: Netlink Notifications.
Thread-Index: AQHWnknoMhuGirDKQkWFMI/GROerxKmP01eA
Date:   Fri, 9 Oct 2020 22:03:04 +0000
Message-ID: <4adba273e44e0c4dbce4a32d07f79a05d3c66601.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-11-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-11-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5026a1b2-5cdc-4a35-ec30-08d86c9f1927
x-ms-traffictypediagnostic: DM5PR1201MB0042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB0042242BD58B2FF8BB85F392DF080@DM5PR1201MB0042.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0cr8EWahQRy/9qw3uaHZr1hJz/BBIEp3ZgXQZOEBb403WxNuKqRPbxl78of9Tk0nT/8fRcelV0+Dh8evGeSiVbVySsSHWqJzgmKSzKAtReMq2oictV0vMhtZscHM4IeyYTzGQ5SUuq79Wr598vEYLSECEjEgLSrSxDviUNB9aa7Zpm5cvimFQcNDQd2QQOCV1oVebSwKh2PYXCCGR6k3S/W8XFdojL3khaLM+dImDGB8vl1ZQVL5XmgOVBizvdSnlQNm8LN0RCrWff0jcEDt5TMT93duCpeaOdBQp7GHmE/Avtop0ZMl+mg55btl2AspX48FkKIussS1VX+LIdgSWACHeosvz9qayJYQ0lMtG86jYekUBydrDIijTfWVeLcf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(2906002)(66556008)(91956017)(66946007)(86362001)(6512007)(66476007)(64756008)(26005)(478600001)(83380400001)(316002)(15650500001)(8936002)(36756003)(5660300002)(186003)(110136005)(66446008)(6486002)(6506007)(76116006)(2616005)(8676002)(71200400001)(3450700001)(4326008)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: As76MbxlMveOJZM7iNk+4RHNrbLyl49LETT+J+KY3zuEe5SF1FH83v6MkKdksp9HuxBgS8PRsEWbBSpuL7xsHrpeMaGwuLMtgPZnXlijoQfKmUS/irp2GtLFuoOmqbcQdSqEqYg8QijoTve13kZjzSEnw+UtsBCzYPettQlpPSlA1jodyUK7kwH0iOTeFVWP/b9PdsBBoMBqu46NoEaGPtJFgf6ih5f52DYdQ1W3yEDe1NAFcYzE9jIrbzt02I1QswVKv6AUO2Ri/Q88f/Ot95KXLhat59RvmKDMhlkeFzR6LDeqCUn0ambAkZdp4Hz1gDQbDLA7q2JcLv/vOuJRujwsQ9uSMlvFJLcU0zpAgq+9ftB3qzaQRKFnQwrqUpv+yWdXwAQ7oblQF5ALuO0rdOoj8wdpjm74QAmJuug13xsHGnJhMq9swCRSTGFvIi+9vvDIFnQBgrNcJQ3AVyzxg486PiRhTbxQYW34EGwcGNGMdz6OorxYDGAMoDZWvv1tpPkQrOojl0LbhNLT7vscjSvvg0aRZofQBo/chJDVi9/C7XI4j3M2wJqu/gPS9Bzr6zs85CuGo5j0WdVcJCJeIC1Z/wd94xybkGgcIOMBNXmphXWK7HYG5W6b0Rl72fTh4s9Nbi2lZQSFKL1afGDK1A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3FEC92AACA203428E0E0B15D7263133@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5026a1b2-5cdc-4a35-ec30-08d86c9f1927
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 22:03:04.9172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GfFIxd3BSshOFdk2Qwtee2GaySFKtczBijYQo439TghPI9L0WJ3FBZOhSfXK4rqi4KJF3XZnInRBEO1NKuNTUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0042
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280987; bh=AGXJ+LTQoiD5c4S0yl/em0VEkTNkD9ydxLfXiSDNQyE=;
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
        b=e0VbWM+V65ck7YTFtN8Hu7PDNTw2pIHMqG+nVkA6qWB0hyhui508noLm8m7juo9NJ
         W9/c+ItBd9pNhuUHVLU/tyUkZIL1/e2IRCI0vB4XrWhs2wyGAiZiQcIWhgiNQlIfhj
         P3uGKp0e6GF+rxSj4ktVVlqcE1BEg4TLiaWBdlCd8UFFKCABstICzyoCFeKWKTNrJF
         3w7YM9EAuF5RE31QX/p43Rgi9Q2mCLBoCQq1NO0jiQnGGpUEvKUMlC3HSagIL6USm9
         GjbiPOWnnhxBebD7faoEUz8SDdiHRVtghSpJEP3j65TvgZpnqL8h/6jX7+g5Ex8A49
         ZHDHfkJIYtxiQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgTmV0bGluayBub3RpZmljYXRpb25z
IG91dCBvZiBDRk0uDQo+IA0KPiBOb3RpZmljYXRpb25zIGFyZSBpbml0aWF0ZWQgd2hlbmV2ZXIg
YSBzdGF0ZSBjaGFuZ2UgaGFwcGVucyBpbiBDRk0uDQo+IA0KPiBJRkxBX0JSSURHRV9DRk06DQo+
ICAgICBQb2ludHMgdG8gdGhlIENGTSBpbmZvcm1hdGlvbi4NCj4gDQo+IElGTEFfQlJJREdFX0NG
TV9NRVBfU1RBVFVTX0lORk86DQo+ICAgICBUaGlzIGluZGljYXRlIHRoYXQgdGhlIE1FUCBpbnN0
YW5jZSBzdGF0dXMgYXJlIGZvbGxvd2luZy4NCj4gSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RB
VFVTX0lORk86DQo+ICAgICBUaGlzIGluZGljYXRlIHRoYXQgdGhlIHBlZXIgTUVQIHN0YXR1cyBh
cmUgZm9sbG93aW5nLg0KPiANCj4gQ0ZNIG5lc3RlZCBhdHRyaWJ1dGUgaGFzIHRoZSBmb2xsb3dp
bmcgYXR0cmlidXRlcyBpbiBuZXh0IGxldmVsLg0KPiANCj4gSUZMQV9CUklER0VfQ0ZNX01FUF9T
VEFUVVNfSU5TVEFOQ0U6DQo+ICAgICBUaGUgTUVQIGluc3RhbmNlIG51bWJlciBvZiB0aGUgZGVs
aXZlcmVkIHN0YXR1cy4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIuDQo+IElGTEFfQlJJREdF
X0NGTV9NRVBfU1RBVFVTX09QQ09ERV9VTkVYUF9TRUVOOg0KPiAgICAgVGhlIE1FUCBpbnN0YW5j
ZSByZWNlaXZlZCBDRk0gUERVIHdpdGggdW5leHBlY3RlZCBPcGNvZGUuDQo+ICAgICBUaGUgdHlw
ZSBpcyBOTEFfVTMyIChib29sKS4NCj4gSUZMQV9CUklER0VfQ0ZNX01FUF9TVEFUVVNfVkVSU0lP
Tl9VTkVYUF9TRUVOOg0KPiAgICAgVGhlIE1FUCBpbnN0YW5jZSByZWNlaXZlZCBDRk0gUERVIHdp
dGggdW5leHBlY3RlZCB2ZXJzaW9uLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxBX1UzMiAoYm9vbCku
DQo+IElGTEFfQlJJREdFX0NGTV9NRVBfU1RBVFVTX1JYX0xFVkVMX0xPV19TRUVOOg0KPiAgICAg
VGhlIE1FUCBpbnN0YW5jZSByZWNlaXZlZCBDQ00gUERVIHdpdGggTUQgbGV2ZWwgbG93ZXIgdGhh
bg0KPiAgICAgY29uZmlndXJlZCBsZXZlbC4gVGhpcyBmcmFtZSBpcyBkaXNjYXJkZWQuDQo+ICAg
ICBUaGUgdHlwZSBpcyBOTEFfVTMyIChib29sKS4NCj4gDQo+IElGTEFfQlJJREdFX0NGTV9DQ19Q
RUVSX1NUQVRVU19JTlNUQU5DRToNCj4gICAgIFRoZSBNRVAgaW5zdGFuY2UgbnVtYmVyIG9mIHRo
ZSBkZWxpdmVyZWQgc3RhdHVzLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxBX1UzMi4NCj4gSUZMQV9C
UklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX1BFRVJfTUVQSUQ6DQo+ICAgICBUaGUgYWRkZWQgUGVl
ciBNRVAgSUQgb2YgdGhlIGRlbGl2ZXJlZCBzdGF0dXMuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFf
VTMyLg0KPiBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfQ0NNX0RFRkVDVDoNCj4gICAg
IFRoZSBDQ00gZGVmZWN0IHN0YXR1cy4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJvb2wp
Lg0KPiAgICAgVHJ1ZSBtZWFucyBubyBDQ00gZnJhbWUgaXMgcmVjZWl2ZWQgZm9yIDMuMjUgaW50
ZXJ2YWxzLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19FWFBfSU5URVJWQUwuDQo+
IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19SREk6DQo+ICAgICBUaGUgbGFzdCByZWNl
aXZlZCBDQ00gUERVIFJESS4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJvb2wpLg0KPiBJ
RkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfUE9SVF9UTFZfVkFMVUU6DQo+ICAgICBUaGUg
bGFzdCByZWNlaXZlZCBDQ00gUERVIFBvcnQgU3RhdHVzIFRMViB2YWx1ZSBmaWVsZC4NCj4gICAg
IFRoZSB0eXBlIGlzIE5MQV9VOC4NCj4gSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lG
X1RMVl9WQUxVRToNCj4gICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgSW50ZXJmYWNlIFN0
YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFfVTguDQo+IElGTEFf
QlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19TRUVOOg0KPiAgICAgQSBDQ00gZnJhbWUgaGFzIGJl
ZW4gcmVjZWl2ZWQgZnJvbSBQZWVyIE1FUC4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJv
b2wpLg0KPiAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZN
X0NDX1BFRVJfU1RBVFVTX0lORk8uDQo+IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19U
TFZfU0VFTjoNCj4gICAgIEEgQ0NNIGZyYW1lIHdpdGggVExWIGhhcyBiZWVuIHJlY2VpdmVkIGZy
b20gUGVlciBNRVAuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFfVTMyIChib29sKS4NCj4gICAgIFRo
aXMgaXMgY2xlYXJlZCBhZnRlciBHRVRMSU5LIElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRV
U19JTkZPLg0KPiBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfU0VRX1VORVhQX1NFRU46
DQo+ICAgICBBIENDTSBmcmFtZSB3aXRoIHVuZXhwZWN0ZWQgc2VxdWVuY2UgbnVtYmVyIGhhcyBi
ZWVuIHJlY2VpdmVkDQo+ICAgICBmcm9tIFBlZXIgTUVQLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxB
X1UzMiAoYm9vbCkuDQo+ICAgICBXaGVuIGEgc2VxdWVuY2UgbnVtYmVyIGlzIG5vdCBvbmUgaGln
aGVyIHRoYW4gcHJldmlvdXNseSByZWNlaXZlZA0KPiAgICAgdGhlbiBpdCBpcyB1bmV4cGVjdGVk
Lg0KPiAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZNX0ND
X1BFRVJfU1RBVFVTX0lORk8uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVu
ZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3Jh
dGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgbmV0
L2JyaWRnZS9icl9jZm0uYyAgICAgICAgIHwgNDggKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ICBuZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5rLmMgfCAyNSArKysrKysrKy0tLS0tDQo+ICBuZXQv
YnJpZGdlL2JyX25ldGxpbmsuYyAgICAgfCA3MyArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tDQo+ICBuZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCAgICAgfCAyMiArKysrKysrKysr
LQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNDcgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0p
DQo+IA0KDQpBY2tlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xheUBudmlkaWEuY29t
Pg0KDQo=
