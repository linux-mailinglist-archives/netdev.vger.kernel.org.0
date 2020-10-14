Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCFC28DFC8
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387754AbgJNLYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:24:42 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2682 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730609AbgJNLYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 07:24:41 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f86dfec0000>; Wed, 14 Oct 2020 04:24:28 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 14 Oct
 2020 11:24:40 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.58) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 14 Oct 2020 11:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUwOzNHBgEtzA6WrS7xijOl7rGoIVsGZ3aUqrSNXE80FDUjBzvZPSjWIdGoJgWj4hdv6oDyv0Xy0rhlb1EB51cu69bi7TxnP1H88J6huH0n1NTPdG6NHLggaMcA6bPWZMDd8iqknXTPvFGEiL/wBKm5ZiAUcdUCtsmwRJSClWu1j7YWwiAZXT71ukGFQabOLt1xjnB2uSgneNycka0qpeyXXPBabhfU55f0rNigFDEKXdYLG1AWqOMtZPXyavrKafTW5YSMP3m/iH1G7TuKRhKtoWHWten+i3ortuAKrXHiXZ98j1a06E+biy9I0fAgoCBtkDSSAKr+lg+UmmpZHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5tKMqi2l+vuilkp4YffEiTtSjFsKjYXY2lbiqujIH0=;
 b=ZrmyhTIWZ3K8NTqrJT8KTbAdhWLs0cY932UVGkONLKkOKTTkyAm0eqG5Opc2gMHjdcTUegWKYhNMEY7PLr1NI9SbvKoiMl3mx0OqSZhzroIHyDcg48+rafJPzZG+XoF8pEvjNvrynkoSt0VgeJMZZbpw7yrkBcD6vps1MZ9K1NJR3GPnNV+cr8Nr5Jvn2F0LOgg2A0Ye0j59ThgTHA1Wow6lFuUzyIighe2F0Ph6EHWKIkncQG5k8sN2lXeXGsULjMXv745uosIY5dfHDhyh+pdFfiYW0gluoemKAqqlJw1aWHKqzj+CRnPGW74EKEY/A7OFW8X8Mq+/ghykjDCKLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM6PR12MB4944.namprd12.prod.outlook.com (2603:10b6:5:1ba::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.20; Wed, 14 Oct 2020 11:24:39 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a%3]) with mapi id 15.20.3477.021; Wed, 14 Oct 2020
 11:24:39 +0000
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
Subject: Re: [PATCH net-next v5 09/10] bridge: cfm: Netlink GET status
 Interface.
Thread-Topic: [PATCH net-next v5 09/10] bridge: cfm: Netlink GET status
 Interface.
Thread-Index: AQHWoKEPiIAjcZlvQ06tdqdPh/N1yKmW9/CA
Date:   Wed, 14 Oct 2020 11:24:38 +0000
Message-ID: <1253ca825551235c5fd45300f401a161f2bdd3f2.camel@nvidia.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
         <20201012140428.2549163-10-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201012140428.2549163-10-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 6df06283-3c4f-4deb-fb9a-08d87033bd12
x-ms-traffictypediagnostic: DM6PR12MB4944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4944CE5E36BB95F5FFCE810FDF050@DM6PR12MB4944.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WFl0RKg6D9A/KKE2xT8GbMCaHKUqdj6tVOMVd8lkBfgrrvblZZZWMvMTHyarFIIPwOVmtJX6oPfN77ap7Pf5p6rByGdlwvG2A992JKBmfFb7w5SZ7dIov+lhmtgfw//g95PfaY03e79bev3nOlDbhVrcRx4dlCFNvM6ryEZJzVms6QLV6S4nCxLwmUu7gMY2RTGkq4AFNwD6VlS2GMOss/UXmeIisgW73bTp8A3pkDdxvdX/qPnz+JkeeswvFrd88fVWVDUWNewk2t6ei8cHpFWqIAzANYwXy04Z/ks59tJICHm+2x8l59H2WYl+5xEvAmkLf4OXfSOI1urHfQOzxXhj1I3vwc2WPKhK0omQRKOe/DlxaKfcu1ipAWLzRpAa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(66476007)(66946007)(6512007)(66446008)(66556008)(71200400001)(26005)(64756008)(6506007)(2616005)(3450700001)(4326008)(76116006)(91956017)(110136005)(186003)(316002)(5660300002)(83380400001)(2906002)(6486002)(36756003)(8676002)(8936002)(4001150100001)(478600001)(86362001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m3KLMrgZyrlFIiv1XblSs685RrZZqo9RBNOAjPaUFcc7szNYk0Xkzat16iZZ+Z4poLWBoAxs1VmBVJyyqVNVOwHFgadVhISU69Z/RMn2z9UgIvGXOWU6Pp1ktmQu9xXLDBZH/mh1Q9p69D8ibbvSGrJNqmlY2Hq2cjCeu7YfUd2JplR6UrYZaJqvhrRxISwfgaOjcSJuyszniPDGalVQs65apTuhwuB3qnkZFKG9lEBzW9E58I9YwGXH2QYny2GHbaIZEtZMrHEhqIZA3eVrOkQ1ZYFPxPQ42UndWOKVxmu4XReiu+BLSHJjtg9dKCLiCyJMuRehOFM7tl+B9kkqo34UOwdVsxChY4uTmCX52tcCym1dFQ96H9/73Bi1KtbjQQ7B5XB/ey9x7dXHSRwnpYJKTeER8OvslzalDa8+aAdxkxCHGnACwD81NbE2H548v33oN/rbLjgzd00NO7qbAogL5a324Rn/p6kJr4mxc+qFRTgDFlEVZUuvkO7M6xrCeX3O8AwC4h5XEu/3YdBHvm4UGWAxJ2av/kjmvKOng0F/s8n2Npoy30zfPu4XjFaMjDYKkwbb3E7vaaEUHyPhc+UQ8//nGzAO1rDFAtxFaxk/i6K81m+61ORoPfTW5bOd6S9yjXo/Y7GTu1ULI2/HxA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A621E25E5ABDA4F81E20778A180913C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df06283-3c4f-4deb-fb9a-08d87033bd12
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 11:24:38.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4cv0EX6tTyiEHmusTguayIWnk9VclcmmuJXvtWM/Oi0y8rDLP4BKZd99dh6vz4G5dOF6Ofwz9KuTmEwRJd1cGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4944
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602674668; bh=X5tKMqi2l+vuilkp4YffEiTtSjFsKjYXY2lbiqujIH0=;
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
        b=FbS6ldmVc41TmNdw6TV1hXq9ScEceUTcY3y2V1CHPE9iHIxWwuGQy38JValzvlVo/
         LE/4l433X7HyYcHnzAmtFHrFfvCszng3JkOTK1qmh7yQNDemGZGKpTTL86isYn30uN
         LElOJ7HWeDDgup6R4NOQitN+WBSqjgMMtW6wRiA+HqpXPec/vukGDM1VVhynYBcNW1
         g4Z7PumnHYbYVM/65HhQFR1R2TyYptmjj/DMz6h2daeNdc7mTPEBnjgHDuP33PB/H3
         Hko1oRQGHz3jXQjsw7LaexfXP+FQiRVMg1qm9gewPD0FtktDm1TrR9fT/e0twyYcpI
         g41AIWwilyeEw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTEyIGF0IDE0OjA0ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgQ0ZNIG5ldGxpbmsgc3RhdHVzDQo+
IGdldCBpbmZvcm1hdGlvbiBpbnRlcmZhY2UuDQo+IA0KPiBBZGQgbmV3IG5lc3RlZCBuZXRsaW5r
IGF0dHJpYnV0ZXMuIFRoZXNlIGF0dHJpYnV0ZXMgYXJlIHVzZWQgYnkgdGhlDQo+IHVzZXIgc3Bh
Y2UgdG8gZ2V0IHN0YXR1cyBpbmZvcm1hdGlvbi4NCj4gDQo+IEdFVExJTks6DQo+ICAgICBSZXF1
ZXN0IGZpbHRlciBSVEVYVF9GSUxURVJfQ0ZNX1NUQVRVUzoNCj4gICAgIEluZGljYXRpbmcgdGhh
dCBDRk0gc3RhdHVzIGluZm9ybWF0aW9uIG11c3QgYmUgZGVsaXZlcmVkLg0KPiANCj4gICAgIElG
TEFfQlJJREdFX0NGTToNCj4gICAgICAgICBQb2ludHMgdG8gdGhlIENGTSBpbmZvcm1hdGlvbi4N
Cj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19JTkZPOg0KPiAgICAgICAgIFRo
aXMgaW5kaWNhdGUgdGhhdCB0aGUgTUVQIGluc3RhbmNlIHN0YXR1cyBhcmUgZm9sbG93aW5nLg0K
PiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lORk86DQo+ICAgICAgICAgVGhp
cyBpbmRpY2F0ZSB0aGF0IHRoZSBwZWVyIE1FUCBzdGF0dXMgYXJlIGZvbGxvd2luZy4NCj4gDQo+
IENGTSBuZXN0ZWQgYXR0cmlidXRlIGhhcyB0aGUgZm9sbG93aW5nIGF0dHJpYnV0ZXMgaW4gbmV4
dCBsZXZlbC4NCj4gDQo+IEdFVExJTksgUlRFWFRfRklMVEVSX0NGTV9TVEFUVVM6DQo+ICAgICBJ
RkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19JTlNUQU5DRToNCj4gICAgICAgICBUaGUgTUVQIGlu
c3RhbmNlIG51bWJlciBvZiB0aGUgZGVsaXZlcmVkIHN0YXR1cy4NCj4gICAgICAgICBUaGUgdHlw
ZSBpcyB1MzIuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19PUENPREVfVU5FWFBf
U0VFTjoNCj4gICAgICAgICBUaGUgTUVQIGluc3RhbmNlIHJlY2VpdmVkIENGTSBQRFUgd2l0aCB1
bmV4cGVjdGVkIE9wY29kZS4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJvb2wpLg0KPiAg
ICAgSUZMQV9CUklER0VfQ0ZNX01FUF9TVEFUVVNfVkVSU0lPTl9VTkVYUF9TRUVOOg0KPiAgICAg
ICAgIFRoZSBNRVAgaW5zdGFuY2UgcmVjZWl2ZWQgQ0ZNIFBEVSB3aXRoIHVuZXhwZWN0ZWQgdmVy
c2lvbi4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJvb2wpLg0KPiAgICAgSUZMQV9CUklE
R0VfQ0ZNX01FUF9TVEFUVVNfUlhfTEVWRUxfTE9XX1NFRU46DQo+ICAgICAgICAgVGhlIE1FUCBp
bnN0YW5jZSByZWNlaXZlZCBDQ00gUERVIHdpdGggTUQgbGV2ZWwgbG93ZXIgdGhhbg0KPiAgICAg
ICAgIGNvbmZpZ3VyZWQgbGV2ZWwuIFRoaXMgZnJhbWUgaXMgZGlzY2FyZGVkLg0KPiAgICAgICAg
IFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+IA0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BF
RVJfU1RBVFVTX0lOU1RBTkNFOg0KPiAgICAgICAgIFRoZSBNRVAgaW5zdGFuY2UgbnVtYmVyIG9m
IHRoZSBkZWxpdmVyZWQgc3RhdHVzLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gICAg
IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19QRUVSX01FUElEOg0KPiAgICAgICAgIFRo
ZSBhZGRlZCBQZWVyIE1FUCBJRCBvZiB0aGUgZGVsaXZlcmVkIHN0YXR1cy4NCj4gICAgICAgICBU
aGUgdHlwZSBpcyB1MzIuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfQ0NN
X0RFRkVDVDoNCj4gICAgICAgICBUaGUgQ0NNIGRlZmVjdCBzdGF0dXMuDQo+ICAgICAgICAgVGhl
IHR5cGUgaXMgdTMyIChib29sKS4NCj4gICAgICAgICBUcnVlIG1lYW5zIG5vIENDTSBmcmFtZSBp
cyByZWNlaXZlZCBmb3IgMy4yNSBpbnRlcnZhbHMuDQo+ICAgICAgICAgSUZMQV9CUklER0VfQ0ZN
X0NDX0NPTkZJR19FWFBfSU5URVJWQUwuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9T
VEFUVVNfUkRJOg0KPiAgICAgICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgUkRJLg0KPiAg
ICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0Nf
UEVFUl9TVEFUVVNfUE9SVF9UTFZfVkFMVUU6DQo+ICAgICAgICAgVGhlIGxhc3QgcmVjZWl2ZWQg
Q0NNIFBEVSBQb3J0IFN0YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5cGUg
aXMgdTguDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfSUZfVExWX1ZBTFVF
Og0KPiAgICAgICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgSW50ZXJmYWNlIFN0YXR1cyBU
TFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTguDQo+ICAgICBJRkxBX0JS
SURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfU0VFTjoNCj4gICAgICAgICBBIENDTSBmcmFtZSBoYXMg
YmVlbiByZWNlaXZlZCBmcm9tIFBlZXIgTUVQLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAo
Ym9vbCkuDQo+ICAgICAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklE
R0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lORk8uDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVF
Ul9TVEFUVVNfVExWX1NFRU46DQo+ICAgICAgICAgQSBDQ00gZnJhbWUgd2l0aCBUTFYgaGFzIGJl
ZW4gcmVjZWl2ZWQgZnJvbSBQZWVyIE1FUC4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJv
b2wpLg0KPiAgICAgICAgIFRoaXMgaXMgY2xlYXJlZCBhZnRlciBHRVRMSU5LIElGTEFfQlJJREdF
X0NGTV9DQ19QRUVSX1NUQVRVU19JTkZPLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJf
U1RBVFVTX1NFUV9VTkVYUF9TRUVOOg0KPiAgICAgICAgIEEgQ0NNIGZyYW1lIHdpdGggdW5leHBl
Y3RlZCBzZXF1ZW5jZSBudW1iZXIgaGFzIGJlZW4gcmVjZWl2ZWQNCj4gICAgICAgICBmcm9tIFBl
ZXIgTUVQLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICAgICAgV2hl
biBhIHNlcXVlbmNlIG51bWJlciBpcyBub3Qgb25lIGhpZ2hlciB0aGFuIHByZXZpb3VzbHkgcmVj
ZWl2ZWQNCj4gICAgICAgICB0aGVuIGl0IGlzIHVuZXhwZWN0ZWQuDQo+ICAgICAgICAgVGhpcyBp
cyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lO
Rk8uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9l
cm5sdW5kQG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhv
cmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4
L2lmX2JyaWRnZS5oIHwgIDI5ICsrKysrKysrKw0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L3J0bmV0
bGluay5oIHwgICAxICsNCj4gIG5ldC9icmlkZ2UvYnJfY2ZtX25ldGxpbmsuYyAgICB8IDEwNSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIG5ldC9icmlkZ2UvYnJfbmV0bGlu
ay5jICAgICAgICB8ICAxNiArKysrLQ0KPiAgbmV0L2JyaWRnZS9icl9wcml2YXRlLmggICAgICAg
IHwgICA2ICsrDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDE1NCBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQ0KPiANCj4gDQoNCkFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5
QG52aWRpYS5jb20+DQoNCg0K
