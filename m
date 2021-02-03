Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE5E30E453
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhBCUni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:43:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:64612 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhBCUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612384975; x=1643920975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uP//dlXgz2mL33SNmC66PnZEe6nTyUz4voOX0AN5VCo=;
  b=YICuR+zlW2q2WMtO41HXg2V9B1VbTB7dbYIQ7HnUVttx1UsuZDS+upGW
   +kIKZN19w4QvogdRN/j5LwVVvzkk+HxRsHgKhl5qj+0mfsPB+Lz99Knsj
   n5tvWR4IjrDRhoQvZV96L4TOY1RVrDH/pkBbVSUhd/JraFpYyuisGWc8t
   LMNB+OJgf1/mXW7TCVkhTLBxkh51cUv+uF6maS0qpz1Sq6+b1EF8ucUz8
   +ZANz71VuqFNvV9RbttzqXPaP+eH+MkzxOz22waUrC1pJzq+7357r0DnR
   ras0lz+sESus4BACyRjLraiPt85mRrRL+dVoStKZN0TmstbMH2cIVZSO6
   Q==;
IronPort-SDR: VS1H8j3oJm/qDquJ8SVPIGLcRLV5GX66s+jgmdwv3cvBqfR84pSYOtXL+nc5jNGZlflSs1gVOt
 mvfaNHkPHe4vD+2cWimpB3zoiD8Q8xFdq5NHtQebUaKVWa/dfIPnn5RFzD/gscVJ4KVueXutY3
 JM6pD/hyFoSxN1hMqf5+Oq1eoL1deXa1bXB0xF5lA8a34OL6zEdHyuBbLArT/WQAY3sbdmMUQh
 gHLoEuyA/9Mlm7XqoKqyS2Pks3GdstUMxhTYl9xpvPdfLlqL2KK2WiCyFMZJK1d5+xUSjt9wdw
 7IE=
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="113708435"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2021 13:41:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 13:41:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 3 Feb 2021 13:41:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3cPIwuwpNKmHkYmqrSYQyP6hUPtpcLhKRhkMpeQCYOMGE1PG3pnkVk+XfQiRFApliSKqjDbRez1fAo6+gPvK8WxDGdp1F6jKcGl/CLjCPCxw8k+4odKzFTgxRCKiOHmtP5+Xsbl3xNuB2kn5P4GTknegC6bk1RoAbgrULIZ0s2W6TvK/AtToyiy4GjPB3kxJ3WzAUbkCvQfJois1xr+4HJteSlUCWdS2bkHEpM9VTrBj219XvNWrxeRQCVlUWYEzJFJyGPxD7MR0WL1wiN6ochkNnZh8tnvN4kcvqWBeRF9vAwy33aYPYROGGvkthy1CCap8IAYOpzrFUkS9UxnWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uP//dlXgz2mL33SNmC66PnZEe6nTyUz4voOX0AN5VCo=;
 b=I6ontEIASFCij4FFWXpP4zVKxUCpWEl7WAeI9K6ptX/kcF1hK2BoiAsU7zPnJ02ZRnNe6mP6hUDgbnNXkFZxdI7wNYYe2Dgg94D5cjOGU69C6Yq6j2To1T8VM8IntjGoLxxB9Q+vTz7czmpMAT0mQhMH7sHiFoFIa+r6kVi0+UydIT+b5kbwjiPXn36Z6jrU06w4P4eFVB8o8YIJ0RuABBuRqS1PhAd5qvt9M+nnL8mFmRvFRyqnfCc/tSQF7J0ZRA3rNQPzRVutlHMZsUdbLE6/xk8jyAc3wArqt6Boo/SXzsnYhucPx2Mw6E/iWmUIRbrSGHl2vRGNtQCqN4Ru6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uP//dlXgz2mL33SNmC66PnZEe6nTyUz4voOX0AN5VCo=;
 b=vbsJKYPuOHld/lU2XdfvgZnMyrTlY0eXTJUIEiQKZqTO/GwpXlOPwCqTjV0rZCBHc9ZseZNJW5Wzr1mwMWz9mOt1rE2s7RX1lCIlafptRheQ3gCRpGbjQpTb6XFMRfXVoDbQamnRSefgLdeJDLhs3kVgrd5qZXYyOi7IxJV3EZk=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB4144.namprd11.prod.outlook.com (2603:10b6:208:13a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 3 Feb
 2021 20:41:35 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3805.025; Wed, 3 Feb 2021
 20:41:35 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <rtgbnm@gmail.com>,
        <sbauer@blackbox.su>, <tharvey@gateworks.com>,
        <anders@ronningen.priv.no>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Topic: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Index: AQHW9nhaCkvjLk51A0iB0GiaIb00V6pBUlxwgACLTYCAAbrREIADNkSAgAAVk+CAAAQygIAAAq9g
Date:   Wed, 3 Feb 2021 20:41:35 +0000
Message-ID: <MN2PR11MB36623F8CE310A8CD6BD0398DFAB49@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
 <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVK5=vggym5LiqvjiRVTSWscc=CgX6UPOBkZpknuLC62Q@mail.gmail.com>
 <MN2PR11MB366281CC0DE98F16FE1F1D62FAB49@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiX1+hkygO3+Z9gsbzVY5b1ahFTG3QH7C1YNEjy6rgox-w@mail.gmail.com>
In-Reply-To: <CAGngYiX1+hkygO3+Z9gsbzVY5b1ahFTG3QH7C1YNEjy6rgox-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a7a34db-fe6b-4745-ea51-08d8c8841900
x-ms-traffictypediagnostic: MN2PR11MB4144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB414474513184D872F18F0EC5FAB49@MN2PR11MB4144.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rWCe66x6roPRr3T0iD/tYsvSFIyoRlQhQfIQigF/AxdCiY1Ximd8BxfYA54joTNuJs390L0vV1Fc8ebB/OWQU1xTJSA0a5V4LmEu/UvX+T+4kNURysdctAJX+xbtvhEDrvG+B0/GotbTSsB5v0IWlk5oWdxK3SyqqwI9kS8cq3r2YWphrXMJ2LYJIzWbOFp6K4hwx5kvM4hiGgcCEialflF5i2g5WqtdREodCWv12k/xMJcVLCU+VH4CYwE4Wv03nLQi9kmQeZF9Br6MABOxjYL1qi62KQ7qiZd/pKGByUEiVWWNN9ZFZwV1JWSk90ta5matqex1rRgaqogQAU9dfmW2KWUlDmJddx4IPdh9PiiaH3q8pqUMku0/dyLC+9qhKLHKX++zbYFh1t1wpJnkH9wRB81wTyo2+rHCqHV9J0SQf36kJItn0oweHm4bk45m9p97XMeDk+yC8/jX04JOq+KWhd3xHPSZvN2HLeI1eHvQz5pwuoNzTZiqiZCGhAvf+HGArQi6/a6z2NlAD0jhAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(66476007)(86362001)(2906002)(52536014)(5660300002)(66946007)(7696005)(76116006)(4744005)(7416002)(26005)(4326008)(71200400001)(55016002)(54906003)(66556008)(478600001)(316002)(186003)(6506007)(33656002)(53546011)(66446008)(9686003)(83380400001)(64756008)(8936002)(6916009)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Znp3TWMxWHdEQnhYTmhEeWpwSWhRbGFySVZ2bVRBdU5iVmdjOXNPOE9YTkdR?=
 =?utf-8?B?OENucUt5NEN0SkdyRXdLNjZqSWV6SHJsRndUVGFZeEwwTHlzR25sZE55cHUw?=
 =?utf-8?B?QzB3MGZOQVlRQUZBdXFuQVNYUDJIM3QwWi9QVHJNTDNaenptMlhjbFFxSW82?=
 =?utf-8?B?b0d5TXpId2JyM1Jtd3hXcHpEUVI0Mjd0djhZOW9vdGNXL0hOYmJHc01aNnM2?=
 =?utf-8?B?UWlkZjlZbmtYWUdaTE9teFdnTFJKVXYvcWYvMUNYcFpkNTFVcUJIdWVIb2Yy?=
 =?utf-8?B?a1lJWFdHUHhoZHBZV0locHhYVklURzQ4WmZ2S09TZGthSnVXamZCOWZPWnU5?=
 =?utf-8?B?bzBlNEg4eUxEUWp3bG5RWVNHZ3ZhZWdXWnBJOGpLSEZVK1ZGTGVWaUl1OS9p?=
 =?utf-8?B?NFUwQnFyeWRjekE4em5wQmVmS0JTSkRTMExLOWpOU1pCYndkWUdIYWlmY0JY?=
 =?utf-8?B?dVVsT1FmaVh1dXZLVXQxMjlueWpDSXdOUThZS1VkSVpyYXB4clpPQk5SK1RU?=
 =?utf-8?B?RFlvNk5XUmNkdlI3SkEvQ010dGFHT1g4SmYyaWRhWHB4bTdsdHVDcmlGRFYz?=
 =?utf-8?B?UEVKbFZGVnk4a203dlpPaFRseWJ4SFhFNkFFNU5tR0RvMXZHZkJlZjZSTGlz?=
 =?utf-8?B?d0JMZnRzWmt6dVlZbndmQTVTa1pnOXRKNHY5OHZSK2t6NTYvMythOVJUakdK?=
 =?utf-8?B?dnFWTzFIT0ZhaWI2VUc4UjQ1TUVtUW1vcFN6bjBuakdIQ1JKMTZidjZtN00z?=
 =?utf-8?B?NWJ4SzRMNVM0YnhvekxJbEtNcjdjUmljYXNPdk5abitXa2ZTODBTUGxXbnAv?=
 =?utf-8?B?SnAxRXNmdVVYbWhsY2N4dzRlQWJHTTJwZzBEdUtiZmx3WVBiTHBKZUpSczFa?=
 =?utf-8?B?aVR0WHE0RW5vaXVlMzJoODBCQ3BIaFZueGhSWWMxb01pcmIwQUw2Ylk2cXd0?=
 =?utf-8?B?OWlaWnducDF3dk1Db0pBZEdhT20xRTk3OHVla0JWSGVBNklJU1czWUkwNWNR?=
 =?utf-8?B?VWIyM1NRTm8yTEJCU1lLR2Q1SEwzT0J1SjJ1QVpDcTNKb1RxR2RaaGMxa2Zi?=
 =?utf-8?B?ZjJDUnB1d1ZnVm1XNnpjalNKNFloSGdZNUF2MHZuclhRRXJib1JRbVNDME9G?=
 =?utf-8?B?UllVWi9iQmhPNjlwYVRIV0h1UEl3eFRtTmk5bUdSOFRSakVZRlVHRXo5S1dY?=
 =?utf-8?B?bEgxYkpGNzA5SHE3ZmU4T0ZSL1liWVkvOS9vNFpNRzYyRFN0Q01zSWsvRG14?=
 =?utf-8?B?SGZ1cDJIMEFRWkxrUmtFbWlxZGZTUUpvdTQ3MmxKcUpJS2w1ZFpoRFBPejBY?=
 =?utf-8?B?K0RkU1pOTkhBUHl6M2hyeVBnYVJKL3duRmJZTERSdm5LZXJVak1UK0haeVo5?=
 =?utf-8?B?TkxYZ2Q0bGRST2oxdGJSYkczVXlpaDJnY3hoaUFoNWhHWmlydVF5OGU0ZXp3?=
 =?utf-8?B?d3BHRS81V2NKa1F1ellKNXV4M0pyMytHaGtlc0hTMWhPcGxWTEU5SlM2SkUz?=
 =?utf-8?B?ck96Ti9acjZqWitibWhUbWlIekZ3Q3drQmN3U2RiK1JQK1FKN2t0RUNJcmFz?=
 =?utf-8?B?OTY2c2k3MWtwYzgwc0tSdHJ0dGUrTzNHSi9ocjY1TmZuODI0RGVXcGY0eUR6?=
 =?utf-8?B?a2NYTFJuUmlGYzI3VkxWbCtIUUVpbEVIWWJ0ZTRrUktMRDN0d00yRktzcTVW?=
 =?utf-8?B?MDZ6dklvVFBWd0pzWjlOdlJ0VXVHY002STJQaWVMamIwNGdaakJUUnNSRmhU?=
 =?utf-8?Q?pSKGDIuGQPJRjm+TEs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7a34db-fe6b-4745-ea51-08d8c8841900
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 20:41:35.2984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bRS0eLc7PIxsmNUP5Nh0cIRtzvvyA93TxelPI1CdS9sG/sd2AsQ+KtRCBl3llufFEX7LVKQNOh3Zzt+6VT6nsLzz/H8GKpqkJH29k5qnp8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIEZlYiAzLCAyMDIxIGF0IDM6MTQgUE0gPEJyeWFuLldoaXRlaGVhZEBtaWNyb2No
aXAuY29tPiB3cm90ZToNCj4gPg0KPiA+IFdlIGNhbiB0ZXN0IG9uIHg4NiBQQy4gV2Ugd2lsbCBq
dXN0IG5lZWQgYWJvdXQgYSB3ZWVrIGFmdGVyIHlvdSByZWxlYXNlDQo+IHlvdXIgbmV4dCB2ZXJz
aW9uLg0KPiA+DQo+IA0KPiBUaGF0J3MgZ3JlYXQuIElmIHlvdSBoYXZlIGFueSBzdWdnZXN0aW9u
cyBvbiBob3cgSSBjYW4gaW1wcm92ZSB0ZXN0aW5nIG9uIG15DQo+IGVuZCwgZmVlbCBmcmVlIHRv
IHJlYWNoIG91dC4NCg0KSWYgeW91IGFyZSBhYmxlLCBpbiBhZGRpdGlvbiB0byBiYXNpYyByeCBh
bmQgdHggaXBlcmYgdGVzdHMsIEkgd291bGQgcmVjb21tZW5kIFBUUCB0ZXN0cy4NClBUUCByZWxp
ZXMgb24gdGhlIHRpbWUgc3RhbXBzIGV4dHJhY3RlZCBmcm9tIHRoZSBleHRlbnNpb24gZGVzY3Jp
cHRvcnMsIHdoaWNoIGlzIGRpcmVjdGx5IGluIHRoZSBSWCBwYXRoIHlvdSBhcmUgbW9kaWZ5aW5n
Lg0KDQpJZiB5b3UgYXJlIG5vdCBhYmxlLCB3ZSB3aWxsIGF0IGxlYXN0IGNvdmVyIHRoYXQgZm9y
IHg4NiBQQy4NCg0KVGhhbmtzLA0KQnJ5YW4NCg0K
