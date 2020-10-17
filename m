Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0652910E4
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 11:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437763AbgJQJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 05:16:11 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13366 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437753AbgJQJQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 05:16:10 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8ab64d0000>; Sat, 17 Oct 2020 02:15:57 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 17 Oct
 2020 09:16:09 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 17 Oct 2020 09:16:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgK1BwyqWH7wbcIdmPD3n6Oaehf/yQXIJ0Bca1JLfRaqCIcvJZJwUOxCUESg5cQhdcaa7vhOfLO1/CRQlpwO7cuCm28vvd7rgfhCnaOMZ8NFxajMdZQKDpGzlPuofbo/bvhM4v+Cl7oxPdxyvXRxzo5bZEu81yLt84pJWpyuQuQZFpHfvdfxSNBn6wKqbksBEJJBiCAU3wgM/BDVuZN77QlaoV+EIwBxND+8yjXXCpyJLCk37YoUL/d+EziDbtMSvywCO/3XzI/hg4rfuWzUp6Pz77Qjnk5ZvCAtjn57edqgLJCIg3IwhoBRpvBl1cxmQW2hNhxkAzJoI5sgqRkMag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYm3McOhz567XXcpsQYjJjpgQGzsOY/tHxK0ptLsQ10=;
 b=Q+valwN8qA5OI22Ct1sihGyv0ZYsysLk18u4HXA9wgg6shna1j6SOs/C5gzIMYdx0APSX14jgX+g51XpVRZAJtGmYAPOR7BazPhUvUNnHpQoUx0evUnZHoTufAG54sR4S3hgdjXemy9fVp7+gTwcSTNfJSzKdryuztKqZ+mwWGaEDjap2lEKWBBVg/r123us+uzUgTIBTSzhlVvfdxOKb+5z7M/gtLFqsY44ww/Etz1jbn8dHkHXel9eQlTRW7IcdgKbPMAW5Oe2k416Vz6dt+cmleVETW93e1v4U5/Y+gEw20mgt7TDdgDtvhT7T4dKNpidQqmHdxQ4PhQyEz02Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM6PR12MB3306.namprd12.prod.outlook.com (2603:10b6:5:186::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.25; Sat, 17 Oct 2020 09:16:07 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a%3]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 09:16:07 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "idosch@idosch.org" <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>, mlxsw <mlxsw@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] nexthop: Fix performance regression in nexthop
 deletion
Thread-Topic: [PATCH net] nexthop: Fix performance regression in nexthop
 deletion
Thread-Index: AQHWo+H2JjMRpuiskEybcUPbxgAlnKmbhIUA
Date:   Sat, 17 Oct 2020 09:16:07 +0000
Message-ID: <35a2112e324988ec5565818b62ca7c9104badf9b.camel@nvidia.com>
References: <20201016172914.643282-1-idosch@idosch.org>
In-Reply-To: <20201016172914.643282-1-idosch@idosch.org>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 137fb0fc-66de-49df-67c1-08d8727d47ed
x-ms-traffictypediagnostic: DM6PR12MB3306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB330627C2234810A53C938A96DF000@DM6PR12MB3306.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xzw+if32ahSGHsECmI3HgWSUStCmZqOaZ/xk7bQLrk0cZ7db0SQApCbD7ZfVIX5EPr4ZfD3fkL9WHJllj3yhuuhEIs0ncUxTBYXlWQ6D/AE+QzqgGzzFs9eC50pLqmC/3dieqgxYHtOcD8sAB2dtvqZvkb+bry5G+JA0VoFER/0lR2AEoBD13mGbYTXj+/mk1cw3SFA634+YpEF4kM7vt3rAQFW9loY1LTKbTDVeLPDmsIHkYlFR1RPxTF2dCcx0YGSQG0MDCsGNI23NHV9Qy7oXKICfw1clZMCGMsoGZA2Y2s3X/fZ3I3rEiMX2B3Mm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(6486002)(26005)(6506007)(186003)(36756003)(6512007)(8936002)(8676002)(66476007)(110136005)(478600001)(64756008)(54906003)(83380400001)(66556008)(86362001)(71200400001)(66446008)(91956017)(66946007)(76116006)(3450700001)(5660300002)(107886003)(2906002)(2616005)(4001150100001)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i8LBoAAddoDHk+pZ4q4439r43e+M84bvwgFOUs6HpoX6DEepua9sEZueYJkTctlNpTnSwmCONQU1PhFqE/lHg4V0tRBAMOcdLl5HuTxYVhsY7Df9V15FVPFaEXs3UVLoOk9uvoxs1IbdBlhVoj6Ky6fvloKCu6TYQh+DPpk+9uPRGTmcQNpAi0j1OhIUQor2lPP5XhUntrpLqMHq5h4Ad5M6NrlqpXCF6n91xuiO7tkTCiAuzc3JVio7/EqbzSD46bAx2yKaN9lAt/P2D5lrrlifm7v3VagsR53Hr3zl4XaZJ7nRRf5XyPiw3a6OaYudAga4MRXumVwyv1pgZLpZLQwHOVzTMhC9dxRfNXB1kweEUO4aOTl87xoPcHctiabXmym149m/8v+qshxBeUdo+NG4AgkDLtWPKg/buFoJ7xypybFcyhoFanFDX4VE21kZK+1wu9+BxDF0669B4uksepHNu27raC7EB70DlRgyj+hMVA1uAl5lKhNkvFF9YbsHuJyTDqr8Z9KXCP17H0Bivfrqh0enaqHRYqDqs4jUQ8EHfLecEd4JGNwK3vD0A7MV7jod4pHQV4P/fOQrDXzQYNiMVNetMTvO++cl9eXElJoP+FmGtZmEy2oFHljS/ClzuNKo402sgr7vihL/SirQiQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <21EFAEC6CEB49142883657C55938AE0F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137fb0fc-66de-49df-67c1-08d8727d47ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 09:16:07.4595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ys+VaPfS/pnPfeYEohnGQiGEe+zpULawtN0euXFt13txtpeKCPAja59xz0/RgUgSwin6/B67mF1Ccg4wllzfIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3306
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602926157; bh=YYm3McOhz567XXcpsQYjJjpgQGzsOY/tHxK0ptLsQ10=;
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
        b=nFCs3HJpnKxJkfRRxRKn1Olefc/+4O2dtiUOvIp/38qagy4V5zes7xSHHOZX4TdPN
         AoS9oOR8g+cUkeuxXM86C3bO7zEYy6W9oU7V/iEB5OReM7PfPuRVa5sjoh5bYC7Dl3
         iOFdlXzfzNWsy97ky4C6Av0UiG7wAKXGMQvmI0sptyBHbt644LZsOmWX4dx7cTL40v
         4kYSp4b/mfYJx/QJjEBvDSFLE1U9qDcyyKvuuZPXlqRm12Yl0OgJP6O7m6Qx48X/G3
         6xMCTybHQRXQGnzIG2DNewHNxaaOOUNaAxEjXKYNy6sabMkPPEit/cNEYpnNsEtGk7
         V1bueWZEQIBnA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTE2IGF0IDIwOjI5ICswMzAwLCBJZG8gU2NoaW1tZWwgd3JvdGU6DQo+
IEZyb206IElkbyBTY2hpbW1lbCA8aWRvc2NoQG52aWRpYS5jb20+DQo+IA0KPiBXaGlsZSBpbnNl
cnRpb24gb2YgMTZrIG5leHRob3BzIGFsbCB1c2luZyB0aGUgc2FtZSBuZXRkZXYgKCdkdW1teTEw
JykNCj4gdGFrZXMgbGVzcyB0aGFuIGEgc2Vjb25kLCBkZWxldGlvbiB0YWtlcyBhYm91dCAxMzAg
c2Vjb25kczoNCj4gDQo+ICMgdGltZSAtcCBpcCAtYiBuZXh0aG9wLmJhdGNoDQo+IHJlYWwgMC4y
OQ0KPiB1c2VyIDAuMDENCj4gc3lzIDAuMTUNCj4gDQo+ICMgdGltZSAtcCBpcCBsaW5rIHNldCBk
ZXYgZHVtbXkxMCBkb3duDQo+IHJlYWwgMTMxLjAzDQo+IHVzZXIgMC4wNg0KPiBzeXMgMC41Mg0K
PiANCj4gVGhpcyBpcyBiZWNhdXNlIG9mIHJlcGVhdGVkIGNhbGxzIHRvIHN5bmNocm9uaXplX3Jj
dSgpIHdoZW5ldmVyIGENCj4gbmV4dGhvcCBpcyByZW1vdmVkIGZyb20gYSBuZXh0aG9wIGdyb3Vw
Og0KPiANCj4gIyAvdXNyL3NoYXJlL2JjYy90b29scy9vZmZjcHV0aW1lIC1wIGBwZ3JlcCAtbngg
aXBgIC1LDQo+IC4uLg0KPiAgICAgYidmaW5pc2hfdGFza19zd2l0Y2gnDQo+ICAgICBiJ3NjaGVk
dWxlJw0KPiAgICAgYidzY2hlZHVsZV90aW1lb3V0Jw0KPiAgICAgYid3YWl0X2Zvcl9jb21wbGV0
aW9uJw0KPiAgICAgYidfX3dhaXRfcmN1X2dwJw0KPiAgICAgYidzeW5jaHJvbml6ZV9yY3UucGFy
dC4wJw0KPiAgICAgYidzeW5jaHJvbml6ZV9yY3UnDQo+ICAgICBiJ19fcmVtb3ZlX25leHRob3An
DQo+ICAgICBiJ3JlbW92ZV9uZXh0aG9wJw0KPiAgICAgYiduZXh0aG9wX2ZsdXNoX2RldicNCj4g
ICAgIGInbmhfbmV0ZGV2X2V2ZW50Jw0KPiAgICAgYidyYXdfbm90aWZpZXJfY2FsbF9jaGFpbicN
Cj4gICAgIGInY2FsbF9uZXRkZXZpY2Vfbm90aWZpZXJzX2luZm8nDQo+ICAgICBiJ19fZGV2X25v
dGlmeV9mbGFncycNCj4gICAgIGInZGV2X2NoYW5nZV9mbGFncycNCj4gICAgIGInZG9fc2V0bGlu
aycNCj4gICAgIGInX19ydG5sX25ld2xpbmsnDQo+ICAgICBiJ3J0bmxfbmV3bGluaycNCj4gICAg
IGIncnRuZXRsaW5rX3Jjdl9tc2cnDQo+ICAgICBiJ25ldGxpbmtfcmN2X3NrYicNCj4gICAgIGIn
cnRuZXRsaW5rX3JjdicNCj4gICAgIGInbmV0bGlua191bmljYXN0Jw0KPiAgICAgYiduZXRsaW5r
X3NlbmRtc2cnDQo+ICAgICBiJ19fX19zeXNfc2VuZG1zZycNCj4gICAgIGInX19fc3lzX3NlbmRt
c2cnDQo+ICAgICBiJ19fc3lzX3NlbmRtc2cnDQo+ICAgICBiJ19feDY0X3N5c19zZW5kbXNnJw0K
PiAgICAgYidkb19zeXNjYWxsXzY0Jw0KPiAgICAgYidlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3
ZnJhbWUnDQo+ICAgICAtICAgICAgICAgICAgICAgIGlwICgyNzcpDQo+ICAgICAgICAgMTI2NTU0
OTU1DQo+IA0KPiBTaW5jZSBuZXh0aG9wcyBhcmUgYWx3YXlzIGRlbGV0ZWQgdW5kZXIgUlROTCwg
c3luY2hyb25pemVfbmV0KCkgY2FuIGJlDQo+IHVzZWQgaW5zdGVhZC4gSXQgd2lsbCBjYWxsIHN5
bmNocm9uaXplX3JjdV9leHBlZGl0ZWQoKSB3aGljaCBvbmx5IGJsb2Nrcw0KPiBmb3Igc2V2ZXJh
bCBtaWNyb3NlY29uZHMgYXMgb3Bwb3NlZCB0byBtdWx0aXBsZSBtaWxsaXNlY29uZHMgbGlrZQ0K
PiBzeW5jaHJvbml6ZV9yY3UoKS4NCj4gDQo+IFdpdGggdGhpcyBwYXRjaCBkZWxldGlvbiBvZiAx
NmsgbmV4dGhvcHMgdGFrZXMgbGVzcyB0aGFuIGEgc2Vjb25kOg0KPiANCj4gIyB0aW1lIC1wIGlw
IGxpbmsgc2V0IGRldiBkdW1teTEwIGRvd24NCj4gcmVhbCAwLjEyDQo+IHVzZXIgMC4wMA0KPiBz
eXMgMC4wNA0KPiANCj4gVGVzdGVkIHdpdGggZmliX25leHRob3BzLnNoIHdoaWNoIGluY2x1ZGVz
IHRvcnR1cmUgdGVzdHMgdGhhdCBwcm9tcHRlZA0KPiB0aGUgaW5pdGlhbCBjaGFuZ2U6DQo+IA0K
PiAjIC4vZmliX25leHRob3BzLnNoDQo+IC4uLg0KPiBUZXN0cyBwYXNzZWQ6IDEzNA0KPiBUZXN0
cyBmYWlsZWQ6ICAgMA0KPiANCj4gRml4ZXM6IDkwZjMzYmZmYTM4MiAoIm5leHRob3BzOiBkb24n
dCBtb2RpZnkgcHVibGlzaGVkIG5leHRob3AgZ3JvdXBzIikNCj4gU2lnbmVkLW9mZi1ieTogSWRv
IFNjaGltbWVsIDxpZG9zY2hAbnZpZGlhLmNvbT4NCj4gLS0tDQo+ICBuZXQvaXB2NC9uZXh0aG9w
LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IA0KDQpMb29rcyBnb29kLg0KQWNrZWQtYnk6IE5pa29sYXkgQWxla3NhbmRyb3Yg
PG5pa29sYXlAbnZpZGlhLmNvbT4NCg0KDQo=
