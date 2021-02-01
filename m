Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750E30A912
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhBANuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:50:32 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6919 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhBANua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:50:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601806fd0001>; Mon, 01 Feb 2021 05:49:49 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 13:49:47 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 13:49:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYU5u0IM2AgSfsWljeXqjjFr96vawyNOvdkRDa3WGBUkWtsIbmz8w30glnlRCO5H6eDp+rWwrI8YW0lSKA7P2s74DJ+xV2rRFe0ldf/F5bGf+843/STBeBk/b8COyyXrIe9NkjzFaXZ+QUVWSSY3QXBlcoHBwzMsi7KZbZMs2xsQguOz03BZWdRWJmR847EBjpL9VEnmj1l8GNbuV+5RDQXuo6ya3ESJXKhBntZV7/M4d0OWn6QTCoqzm/vdYhdMSOfesd32JQ0kQr/sbNu9c/X6eRfTmO0P26eb+2vU3jrk1FQ+3PYXmLuzogQURbe5uRyOXQmNXjlfF54h+ZWvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yej9Dr0gkqAu/RMqgEOaGDgNDCWLpKE7MaKXurPrk+g=;
 b=QhcAcH/8YDVf7EjQm6rWrPL5jIc31Af99Aj5Qt5okfHsyLtI24YHTczfIUlmkVI6LVnDLIZoYBDdtPFJYhGQpRrlzYJFmZiEdNREcH7f0gSh17275YmB8280MHXqqBI21LRRAmEz7gtw+fie6RfpMXxEI/bedqU5AkgCrdB+RUcclLsGqYDYR5S84/cuKBuRP7m8GuleMe/orpBkGK/xRRaL6zS+j3aDXbIOpwSSYXrs82DCIeK85FeRKMh7x6cHYe1Ewc0Lrob5aV1bUlQGcFHqvakzKOgOgEbtETib4x1DtVvHecrztjhvx1nEmwd5BkcMx53s9yWnp32lAvf+Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3081.namprd12.prod.outlook.com (2603:10b6:5:38::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 1 Feb
 2021 13:49:43 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 13:49:43 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
CC:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, "Ido Schimmel" <idosch@nvidia.com>
Subject: RE: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Topic: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Index: AQHW7w/mnu6I7KMocku/Ks1pUflayqoxLNcAgAVHQjCAAjatgIABgM1wgAADnoCAAT7X8IACG5MAgAPpn6CAAJ6fAIABBzFQ
Date:   Mon, 1 Feb 2021 13:49:43 +0000
Message-ID: <DM6PR12MB45168B7B3516A37854812767D8B69@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com>
 <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
 <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
 <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
 <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
 <DM6PR12MB4516868A5BD4C2EED7EF818BD8B79@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTy2wSmBjRnbhmD6xQgy1GAdiXAxoRX7APNto4gDYUWNRw@mail.gmail.com>
In-Reply-To: <CAKOOJTy2wSmBjRnbhmD6xQgy1GAdiXAxoRX7APNto4gDYUWNRw@mail.gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [93.173.23.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15886d47-d0d0-4762-76b2-08d8c6b83ad5
x-ms-traffictypediagnostic: DM6PR12MB3081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB30811F57AB72AEC49977A84BD8B69@DM6PR12MB3081.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mHl8QjB37FsJbLQESktb45oopMQ/SrCMp87SmnW5UDhSoFKe+4YqNbfze9iwHV2RRE0zpwuGeIcx54YpaIyBhRqW7z+qmab1EkCiZ0T4pH41slo9vWhoRqHb8fttxcxsTekO9iTi6IGmvFvm5ZW7jkOrwKjHzjNH7k8UBjJJ57dY1bzC0N8OjRLe5XEQp+/MAEtW+0S1cydyCrJSTE8h1rFsG93jSynwQxvQUbh6R1zn+Sp8sRLVNyZMkuFBUJEAtkVudD/KewK4iNH2h9V0iHiC2VQDDoE1q24W/CXVvPNCzOt1kahWALhHytxH9qQSRXX94NM4mVqQ6nF6MfO52nLD9a6OK2Iu+9hYqXB/TTHn1SK4FlLOE/E8Lk9/L8ZQo8iVGBV42UfedM5LFdBjBjq8IlQ+q/l+tV3FsPvferfZR9LqvHoUc0ZSpkmPLRcJge4OzNVMGXDwUWR7a0dOrr0SMoDMj49pzhP3TsxGkpndJnBvD3JqT6D2KShRSNU1+Qe5G1yDxDTlAQPRl8QquQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(2906002)(26005)(6916009)(107886003)(54906003)(9686003)(4326008)(55016002)(66556008)(66946007)(8676002)(66446008)(66476007)(5660300002)(7696005)(53546011)(6506007)(186003)(64756008)(86362001)(33656002)(478600001)(52536014)(316002)(71200400001)(83380400001)(8936002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NnJqS2IyajFNbi9NZHpnWUpUaWk5NG8wTEJGbXNmVDdzeHBSK09DWDBBL0pS?=
 =?utf-8?B?NmRocktEWFllUWRkSDQyWTNTYjlvWnJDN1F0L0VwQnU3cnhqOFprMVRXK1FK?=
 =?utf-8?B?RUdMVVEwejhYZEhNVUhLRllJRjc2S21mVlBIbFFwU2Z4T3NRMmsxVEhtSEh3?=
 =?utf-8?B?bVJ4RFREamVRY2d2dG56cVlsUVFCZmpIcml6cmh6U044OG5Ua2M2QThNdGpn?=
 =?utf-8?B?NjV1ekNUZUNnNUFEWGF0aTJkWHV4NTQyTDJtN0pUdkMzcXNsNHpXVzlEeVl1?=
 =?utf-8?B?VjB2b3ZGanBwVXgzaFRZYmU0UzBUdlBqQTBEbmNpYWcxbVNpRGhOVzMxT1RG?=
 =?utf-8?B?STMzNHJyTXVEMjlCemtXendBcU42WDJoMXR5aUxxb3U2cUNhUklKWlZZdzNG?=
 =?utf-8?B?b05yaW9IZXk2dVFwQnVPQ3FCWnI5NE1DaEdIeVIzMVo3cVB6bndrVlVqcE14?=
 =?utf-8?B?ZlRHQkkzR1ZWRDdHME5RYlRTVUdVQTJRaG1iTXdZUGhPOVVaLzl2L0lKZXVG?=
 =?utf-8?B?bTZwbVZ3eElSS0lYOHI2dUNWYlowUE9YWjFRSHJ1cDQ2UmdjMnhDSU5lQWc2?=
 =?utf-8?B?Y2Y3Q21ycG9XNTRpcU5hQjd5SFNua05zRzd1c2E3MGRjR0xVeHQ3cWc3VXh3?=
 =?utf-8?B?T29qTUQ3Wkh1K25jMVVNWW94MW53cm9CZWNBSW5wZUxjSmVzUXQrWUZYYklD?=
 =?utf-8?B?WHkwcWkwYTArQStJbysvVUVYUTN6SER0U1gyWXFTRWtRQjZJMjhKVUlZQnhP?=
 =?utf-8?B?SHZadGR6OFZ5UjUxUE41dmxLYTBtemVaVXVvdFZKbW9QSEZESktJTXRJK3RW?=
 =?utf-8?B?NXB3b0lzL0Zld285ZTNlYlQvQVhmRmd4MWg5am9GQ050ZCtwNGtTNFE3U1lQ?=
 =?utf-8?B?Ujc2SkR5cFlSUkw0NUEzK3hZME1IeWxFTlFVeHRtbDNlc2NkdENCVlNUazV0?=
 =?utf-8?B?d0orNytuaWE5cWhCMWRhYnFZR0lVTlp5cU5FRGdoeWsrUytyckZsend3bkZ0?=
 =?utf-8?B?WU9SdUs2RnBzUGhtalIvVVdjT3I2YlBvOVEvMHNTQllEU1VYQXJsMjRMTGRq?=
 =?utf-8?B?N205dyt5UU9JZkhSVmdhN1M4dmQzQ0I5SGxmWHd3alBZeXFwTGhzc3FxRW9T?=
 =?utf-8?B?SVlPQVFmdXNlMkhYTHhVejdKZW5SZkJnNjZ0WTBqYkViaUtQTThWRWMyM283?=
 =?utf-8?B?VUhoVHZrWjAxTlM0S3Bac0UrZjR5OVNUTzNSZDJmd2IrUzV1UVdFVG5KWGYx?=
 =?utf-8?B?OGNjQnFNczhrQkUwNWphVWlVdHhBbUxvRG0rQTBoS3hmaHdpdkpOZFYvNTBZ?=
 =?utf-8?B?T3plRXk0OUlHRExaYTZvT3J1eDhjVERaU0VDWkNVVUVmdmE0STRMUTFob1I5?=
 =?utf-8?B?SkZ0ZmZpL0s5TWhNRXpaSFk5cG9qOU1uR1lkdDM3TFZ1bFJiTXZIMkFFRGpS?=
 =?utf-8?Q?mwjoVV7i?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15886d47-d0d0-4762-76b2-08d8c6b83ad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 13:49:43.4503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5gPbFQYUxpknKdUC2NSfEnvelbM62WzuOf3Bqh5FcvOfFJFvJXG0dxkvHuDsx50/42K7igDJWHGBxoIS5r2JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3081
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612187389; bh=yej9Dr0gkqAu/RMqgEOaGDgNDCWLpKE7MaKXurPrk+g=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
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
        b=kGHCQ1wWZiRTYXZyAclkROj85B/iyuQ8SYmFd/0bFWyaTSIQr9y3vIjABqLlo80Pg
         yt7QVXsIxVILQCLD2OQVbPYxfd3ymrJFu7yxtU8ih5fCJ24m1y1HKDWsyrtMFU5DUF
         aKIdkHW/d/YoHtUJTw4L4fJcontxlpjEr42PNJaL9X6TYg58ACpo9E3NV3KD0MXQTU
         IpMxW6K5Aj8iqwloiDlRyggsNLmOKonC9SC7ZCKnpUTDMkCSrVeivlmj0D9I4X3AkK
         XCfXWcsUJ9T4Ke/EoejhpIdnVF9ZtDsZB137EwaKAvUgAaRved2PwxsHbEoOFFMwqW
         T6QUPRmdleIRg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRWR3aW4gUGVlciA8ZWR3
aW4ucGVlckBicm9hZGNvbS5jb20+DQo+IFNlbnQ6IFN1bmRheSwgSmFudWFyeSAzMSwgMjAyMSA3
OjM5IFBNDQo+IFRvOiBEYW5pZWxsZSBSYXRzb24gPGRhbmllbGxlckBudmlkaWEuY29tPg0KPiBD
YzogTWljaGFsIEt1YmVjZWsgPG1rdWJlY2VrQHN1c2UuY3o+OyBuZXRkZXYgPG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEppcmkgUGlya28gPGppcmlAbnZpZGlh
LmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IGYuZmFpbmVsbGlAZ21haWwuY29t
OyBtbHhzdw0KPiA8bWx4c3dAbnZpZGlhLmNvbT47IElkbyBTY2hpbW1lbCA8aWRvc2NoQG52aWRp
YS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjMgMi83XSBldGh0b29sOiBH
ZXQgbGluayBtb2RlIGluIHVzZSBpbnN0ZWFkIG9mIHNwZWVkIGFuZCBkdXBsZXggcGFyYW1ldGVy
cw0KPiANCj4gT24gU3VuLCBKYW4gMzEsIDIwMjEgYXQgNzozMyBBTSBEYW5pZWxsZSBSYXRzb24g
PGRhbmllbGxlckBudmlkaWEuY29tPiB3cm90ZToNCj4gDQo+ID4gRWR3aW4sIGFkZGluZyB0aGUg
YSBuZXcgcGFyYW1ldGVyIHJlcXVpcmVzIGEgbmV3IHBhdGNoc2V0IGluIG15IG9waW5pb24uDQo+
ID4gSW1wbGVtZW50aW5nIHRoZSBzeW1tZXRyaWNhbCBzaWRlIG9mIHRoZSBsaW5rX21vZGUgZ2V0
LCBob3dldmVyIGNhbiBiZSBhDQo+ID4gcGFydCBvZiB0aGlzIHNldC4gQnV0LCB0aGUgcHJvYmxl
bSB3aXRoIHRoYXQgd291bGQgYmUgdGhhdCwgYXMgTWljaGFsIHNhaWQsDQo+ID4gc3BlZWQgbGFu
ZXMgYW5kIGR1cGxleCBjYW4ndCBwcm92aWRlIHVzIGEgc2luZ2xlIGxpbmtfbW9kZSBiZWNhdXNl
IG9mIHRoZQ0KPiA+IG1lZGlhLiBBbmQgc2luY2UgbGlua19tb2RlIGlzIG9uZSBiaXQgcGFyYW1l
dGVyLCBwYXNzaW5nIGl0IHRvIHRoZSBkcml2ZXINCj4gPiB3aGlsZSByYW5kb21seSBjaG9vc2lu
ZyB0aGUgbWVkaWEsIG1heSBjYXVzZSBlaXRoZXIgaW5mb3JtYXRpb24gbG9zcywgb3INCj4gPiBl
dmVuIGZhaWwgdG8gc3luYyBvbiBhIGxpbmsgbW9kZSBpZiB0aGUgY2hvc2VuIG1lZGlhIGlzIHNw
ZWNpZmljYWxseSBub3QNCj4gPiBzdXBwb3J0ZWQgaW4gdGhlIGxvd2VyIGxldmVscy4gU28sIGlu
IG15IG9waW5pb24gaXQgaXMgcmVsYXRlZCB0byBhZGRpbmcgdGhlDQo+ID4gbmV3IHBhcmFtZXRl
ciB3ZSBkaXNjdXNzZWQsIGFuZCBzaG91bGQgYmUgZG9uZSBpbiBhIHNlcGFyYXRlIHNldC4NCj4g
DQo+IE1lZGlhIGlzIGEgbGl0dGxlIHNwZWNpYWwgaW4gdGhlIHNlbnNlIHRoYXQgaXQgcGh5c2lj
YWxseSBkZXBlbmRzIG9uDQo+IHdoYXQncyBwbHVnZ2VkIGluLiBJbiB0aGF0IHNlbnNlLCBtZWRp
YSBpcyB0cnVseSByZWFkIG9ubHkuIFNldHRpbmcgaXQNCj4gd29uJ3QgY2hhbmdlIHdoYXQncyBw
bHVnZ2VkIGluLCBzbyBub3QgaGF2aW5nIGEgc2VwYXJhdGUga25vYiBmb3IgaXQNCj4gaXMgcHJv
YmFibHkgb2theSwgYXMgaXQgY2FuIGJlIGluZmVycmVkIGZyb20gdGhlIGFjdGl2ZSBsaW5rIG1v
ZGUgb24NCj4gdGhlIHF1ZXJ5IHNpZGUuDQo+IA0KPiBJIGRvbid0IHNlZSB3aHkgdGhlIGRyaXZl
ciBjYW4ndCBlcnJvciBpZiBhc2tlZCB0byBzZXQgYSBsaW5rIG1vZGUNCj4gaGF2aW5nIGFuIGlu
Y29tcGF0aWJsZSBtZWRpYT8gVGhlIGxpbmsgbW9kZXMgY29ycmVzcG9uZGluZyB0byBtZWRpYQ0K
PiB0aGF0J3Mgbm90IHBsdWdnZWQgaW4gd291bGRuJ3QgYmUgbGlzdGVkIGluIHRoZSBzdXBwb3J0
ZWQgc2V0LCBzbw0KPiB0aGVyZSdzIG5vIHJlYXNvbiB0aGUgdXNlciBzaG91bGQgZXhwZWN0IHRv
IGJlIGFibGUgdG8gc2V0IHRob3NlLg0KPiBUaGVyZSdzIG5vIGFtYmlndWl0eSBvciBpbmZvcm1h
dGlvbiBsb3NzIGlmIHlvdSByZWZ1c2UgdG8gc2V0IG1vZGVzDQo+IHRoYXQgZG9uJ3QgaGF2ZSB0
aGUgbWF0Y2hpbmcgbWVkaWEgYXR0YWNoZWQuDQo+IA0KPiBSZWdhcmRzLA0KPiBFZHdpbiBQZWVy
DQoNCk9rLCBpbGwgc2VuZCBhbm90aGVyIHZlcnNpb24gd2l0aCB0aGUgc3ltbWV0cmljYWwgc2lk
ZS4gRXRodG9vbCB3aWxsIHRyeSB0byBjb21wb3NlDQphIHN1cHBvcnRlZCBsaW5rX21vZGUgZnJv
bSB0aGUgcGFyYW1ldGVycyBmcm9tIHVzZXIgc3BhY2UgYW5kIHdpbGwgY2hvb3NlDQpyYW5kb21s
eSBiZXR3ZWVuIHRoZSBzdXBwb3J0ZWQgb25lcy4gU291bmRzIG9rPw0KDQpUaGFua3MsDQpEYW5p
ZWxsZQ0K
