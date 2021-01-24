Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1013301AA8
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbhAXIh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:37:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19877 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAXIhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:37:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600d31920000>; Sun, 24 Jan 2021 00:36:34 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Jan
 2021 08:36:33 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Jan
 2021 08:36:29 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 24 Jan 2021 08:36:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbZau3GXIq68TjWvr54AEKHPyr9Wh26mNZuVZJUqEKFhAIG0sILGS3y76U37kkU704ypvC8onZ+RzSCu46X77K8q50+7G9DKaGf3dufBplm/LGNBT16g8AAtkyWID9nJ8IkE+hbTZfdwPeySNxPgS7LqOZ5VDZwPjYUIX6dqIwbpRy/NjPurs5rUCJYXQtBVwKKUEseYvLqdapUfRQmzkU34Z27IQhfwbR1yThDxtGakrJ8wkcNEaSSQEN4XpZh1Kdgm2NidBTyWA6Ma6lr/TVIEoxT9q1Kt2wAiOjsyaL/WiIvvesmOT6Rs8GMTFs7TONrCqMNhYPqVAI6vxcBhYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3+tsc662dVy2SnJyHgUehM31dnKbtl1mshXB7hecMo=;
 b=FLUYfwf1g4ap+5LdZIjLjpGMAiuldhLMuODoZ8yRyVpsRazgVZ7uE7s5DpCASq3gTbfw2xndEj0QOFCvXRTHvsz6cyjNQeNUXM3LTCkCM1CEXqrmyKgHzxqdD32e6WQCCoj9RKmGKMNcILdYWXW5jlYbcdA6qD4L7m1UmQrCeF+Yvhw7sCUWRhXTtNegbdQUhI39rcbIc97O/lKnggG6Q1pu6wZ6GLDKkdCzwRUcWyDkhEfc67KrBFCuIbdehBfg7qXXLN9PZBFTI8c1ioMRtxUwldR/1OB63CO7LgKicHzpow70lFqMwlu8hPFUjLuMOiXIQLYcmNPPiEq+2k4Ixw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB4960.namprd12.prod.outlook.com (2603:10b6:5:1bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sun, 24 Jan
 2021 08:36:26 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 08:36:26 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
CC:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Topic: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Index: AQHW7w/mnu6I7KMocku/Ks1pUflayqoxLNcAgAVHQjA=
Date:   Sun, 24 Jan 2021 08:36:26 +0000
Message-ID: <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com>
 <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
In-Reply-To: <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8116969a-9b74-4e64-1243-08d8c0432384
x-ms-traffictypediagnostic: DM6PR12MB4960:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4960BB6CFAC68E76D31BD329D8BE9@DM6PR12MB4960.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SJKOgz2i4uLyFl3Wp1FoanQ1T61IzKkE1iQTbN0ZoyE0NjkCtyHW0RHAnFxF+H+ozPgN1jdU+LP2kVdD6cScLKQhAxvE/ismJhO6dsG0Q7CPqkgNfCetRI3Mp0U0Tx0VhZfuKzQAOCleZe69wGQsJ2gqRBkKlP/TNFiQgrwFJf4x4ADf/L+q1VHYa7VumnRP/S0yDjQtFK9OzTzkiF0SwoZFwyaVNv20NBUMbVbROSoXOUlx2X1VT1fHk+8ijkdPLuz3bkkZPYodBc+VD4mE95WRxdCDew8jlQcSsSTQiPInLRgYwhiQARAaKvOGdAGP8upUyVd582WFchvKRZDLiRXupUcyOSDjLTDyUoZboEDXbIYLMkhjZFWxwiE9uNZms6EJ3G87a/SZnj3xFuRQoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(136003)(346002)(376002)(316002)(71200400001)(6916009)(478600001)(83380400001)(107886003)(7696005)(86362001)(76116006)(53546011)(52536014)(26005)(33656002)(66556008)(66476007)(66946007)(66446008)(6506007)(64756008)(8936002)(9686003)(55016002)(5660300002)(4326008)(186003)(2906002)(8676002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZUcyUmZTQWNWVDZQeUlhUmw2bU5DZHlDRVo5bkIrcTdXbG5pYTh0NXYyOE1W?=
 =?utf-8?B?c3pLVFgyMTlvYlBUa1JhTkRvU3lUb3krRkdxT0dBaFFVWndpSFdJK3A4bGdU?=
 =?utf-8?B?WEZ4ampvVWxFYjJYdHE1K0xESFBVbHFjd2d4RlFsNzZ1ZUFTako2dnZJWnk2?=
 =?utf-8?B?dkdQT1RBYnNNTlBQRnNncHFmenYwOFVUTVZKRDMyWnVWMFZCYUtuQnZhNU1k?=
 =?utf-8?B?Q01ZQWtTdkwxWDk5WDNxb2xMT2VuUUV6RDdsSmg3eEUvNXIzRHI1bXhpVDRD?=
 =?utf-8?B?UFJ1MUx0TnhxMDNOM3AzcXd4Y2lNNVRhSGx0Y0ExNWZyT3BlaEJvVnlSNzdK?=
 =?utf-8?B?Nk9UeHJVSWFrZFd3eWx2YWsyYXdnaGR4cElpYUtjWVhTdVRiSlMveFBjNStD?=
 =?utf-8?B?LzcrTm0rRTcvT1N6bU9IeXNnL2djaHBmdHNoNjg4cFAwLzJOV0RIakVFRDBH?=
 =?utf-8?B?STZxcFBNWHNZVVEvOS9zTmh2a3hjd1Y0M25IYWlaeXZyQUVxM0J1MHlSTElX?=
 =?utf-8?B?N0FrZEtGeXRGcTdTQmRvanVLSDVYS3QyM21oUHlSblRvS0IvangzS1k0eU5R?=
 =?utf-8?B?azlXVGtZUGUxUlkremt1Z2xBYnhtZ3RjZVUvZmhmUVN5QlB0TWR5LzB5VzBB?=
 =?utf-8?B?VnRXQTFwVUJFMXk2MlNoem05bFVhRkVSTzhHd0t2NWZRUnV2RWhsOXlMR1BP?=
 =?utf-8?B?OUhvSEdZMWpONEltNm1jQ1NhUUJEVVdKZ3RocjdabU9qL3lUSVNPbkJsaDdF?=
 =?utf-8?B?RGdPYnlYbnZ0WVRsWmpqbHdMWS9lb2h0UW9jRFVjTFlwd3FHcnVpTHdVUWt4?=
 =?utf-8?B?OTRqbzg0dThheHR0dlY2VVdqZ3l4UjNWLzJaK3o0M205UHB5ZEZEb3ZJK1NN?=
 =?utf-8?B?VllXL29PaXhWbUFKRytvc3RBOEN3aEJjR25nanU2Z01lZVIzeW5sTFZ0dE5N?=
 =?utf-8?B?dTVkQnE1UVU3VkZYaWlCQ3dDM0xUbEpQTko3TlRqUzR4MlRXaGt0a1pBZGRr?=
 =?utf-8?B?RmlEM1JlU1BOaXE0cDNSaUpGbVFpekRFOW5vaWxwSElGUVlLcklBNkJDSXdE?=
 =?utf-8?B?WXVMa3pHSXVtZ2IwRHo2b3BHTk1Da0YrZEVhc3BiWnpzUzdFVkNHbjZjWVdh?=
 =?utf-8?B?a0Y3SWFZL2hmZEhnZDAwM2dSOU1Od0dXUmQ3VWEzUk05UmswYzdYQUsxcXZu?=
 =?utf-8?B?MS85NjRhelU4a0dNbGE3Ti9ZR2xRdzFDbFVyYWgxVmg0SG9oVmljcURkWFZ1?=
 =?utf-8?B?K3lNZG1RZWZNQ1JCSlJJVThsR1RLVXE3TVhjN0wzcjYxblYzOC9ZLzROOE1k?=
 =?utf-8?B?SngvNE9RckkvOFpFYUR4VWdmekpvSWVXSDdXYVpXM04zUDJtNTlablNxeStQ?=
 =?utf-8?B?NDc4YnRZWVZJMmFYcUpiU3VCa1NZRndLSVFNeUl4WmFWVjYwUnB3THRxNVlR?=
 =?utf-8?Q?A7dSVIVk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8116969a-9b74-4e64-1243-08d8c0432384
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 08:36:26.3069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1intgYdaqYcpQT9cpKZWaWFYP4l7jzu/H6L0yU+sgBnuW9tBElXJF5uujEDaWvjW+yPXDTsKU7TMzqTbGyOPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4960
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611477394; bh=V3+tsc662dVy2SnJyHgUehM31dnKbtl1mshXB7hecMo=;
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
        b=X4SNTD+UU/2i87emfLmnyI8cf+Z8grYvaqIpjJeb2hrpyxBTDEFGHSA0yBll4AP/4
         bVt3e9aOBoaUm05nyrUBAKRdRGMD4jNJta/vM6hFCwHXGW44fPffRVG9RCFpUt+oAH
         uC/uamXxcfGpU2xoZTaSwaVW32/JGDpQIqqwLRvLf9OdnAGBZSsyX44EZaIYR8EzG3
         t/qOCrKorHUlBaU2WybEg5zweumO3rDQWtaypSw10/bOVAeOYR5FjOoW2p9gkc1tVq
         O8j9lvTscn1+Mbzzqqt5UV5w7J1W7RXLTwAuC68I9f2Mygmdc3hf/ZqN4/XGjjrjyg
         RVPGTnoQIgR0A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRWR3aW4gUGVlciA8ZWR3
aW4ucGVlckBicm9hZGNvbS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDIxLCAyMDIx
IDE6MzkgQU0NCj4gVG86IERhbmllbGxlIFJhdHNvbiA8ZGFuaWVsbGVyQG52aWRpYS5jb20+DQo+
IENjOiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBEYXZpZCBTIC4gTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEpp
cmkgUGlya28NCj4gPGppcmlAbnZpZGlhLmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5j
aD47IGYuZmFpbmVsbGlAZ21haWwuY29tOyBNaWNoYWwgS3ViZWNlayA8bWt1YmVjZWtAc3VzZS5j
ej47IG1seHN3DQo+IDxtbHhzd0BudmlkaWEuY29tPjsgSWRvIFNjaGltbWVsIDxpZG9zY2hAbnZp
ZGlhLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyAyLzddIGV0aHRvb2w6
IEdldCBsaW5rIG1vZGUgaW4gdXNlIGluc3RlYWQgb2Ygc3BlZWQgYW5kIGR1cGxleCBwYXJhbWV0
ZXJzDQo+IA0KPiBPbiBXZWQsIEphbiAyMCwgMjAyMSBhdCAzOjIxIEFNIERhbmllbGxlIFJhdHNv
biA8ZGFuaWVsbGVyQG52aWRpYS5jb20+IHdyb3RlOg0KPiANCj4gPiArICAgICAgIGxpbmtfa3Nl
dHRpbmdzLT5saW5rX21vZGUgPSAtMTsNCj4gPiArICAgICAgIGVyciA9IGRldi0+ZXRodG9vbF9v
cHMtPmdldF9saW5rX2tzZXR0aW5ncyhkZXYsIGxpbmtfa3NldHRpbmdzKTsNCj4gPiArICAgICAg
IGlmIChlcnIpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBlcnI7DQo+ID4gKw0KPiA+ICsg
ICAgICAgaWYgKGxpbmtfa3NldHRpbmdzLT5saW5rX21vZGUgIT0gLTEpIHsNCj4gPiArICAgICAg
ICAgICAgICAgbGlua19pbmZvID0gJmxpbmtfbW9kZV9wYXJhbXNbbGlua19rc2V0dGluZ3MtPmxp
bmtfbW9kZV07DQo+ID4gKyAgICAgICAgICAgICAgIGxpbmtfa3NldHRpbmdzLT5iYXNlLnNwZWVk
ID0gbGlua19pbmZvLT5zcGVlZDsNCj4gPiArICAgICAgICAgICAgICAgbGlua19rc2V0dGluZ3Mt
PmxhbmVzID0gbGlua19pbmZvLT5sYW5lczsNCj4gPiArICAgICAgICAgICAgICAgbGlua19rc2V0
dGluZ3MtPmJhc2UuZHVwbGV4ID0gbGlua19pbmZvLT5kdXBsZXg7DQo+ID4gKyAgICAgICB9DQo+
IA0KPiBXaHkgaXNuJ3QgdGhpcyBhbHNvIGhhbmRsZWQgdXNpbmcgYSBjYXBhYmlsaXR5IGJpdCBh
cyBpcyBkb25lIGZvcg0KPiBsYW5lcz8gSXMgbGlua19tb2RlIHJlYWQtb25seT8gU2hvdWxkIGl0
IC8gd2lsbCBpdCBhbHdheXMgYmU/IElmIG5vdCwNCj4gY2FuIGRyaXZlcnMgYWxzbyBkZXJpdmUg
dGhlIG90aGVyIGZpZWxkcyBpZiBhc2tlZCB0byBzZXQgbGlua19tb2RlPw0KDQpUaGUgbGlua19t
b2RlIHBhcmFtIGlzIG9ubHkgZm9yIGRlcml2aW5nIGFsbCB0aGUgc3BlZWQsIGxhbmVzIGFuZCBk
dXBsZXggcGFyYW1zIGluIGV0aHRvb2wgaW5zdGVhZCBvZiBkZXJpdmluZyBpbiBkcml2ZXIgYW5k
IHRoZW4gcGFzc2luZyBlYWNoIGluZGl2aWR1YWwsIGFzIE1pY2hhbCBhc2tlZC4NCg0KPiBUaGF0
IHdvdWxkIGJlIGVhc3kgZW5vdWdoLiBXaHkgZG9uJ3Qgd2Ugc2ltcGx5IGFsbG93IHVzZXIgc3Bh
Y2UgdG8gc2V0DQo+IGxpbmsgbW9kZSBkaXJlY3RseSB0b28gKGluIGFkZGl0aW9uIHRvIGJlaW5n
IGFibGUgdG8gY29uc3RyYWluIGxhbmVzDQo+IGZvciBhdXRvbmVnIG9yIGZvcmNlZCBzcGVlZHMp
Pw0KDQpJdCBpcyBhbHJlYWR5IHBvc3NpYmxlIHRvIGRvIHVzaW5nICdhZHZlcnRpc2UnIHBhcmFt
ZXRlci4gDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IEVkd2luIFBlZXINCg0K
