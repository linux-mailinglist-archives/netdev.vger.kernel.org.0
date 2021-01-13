Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B332F4B6C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbhAMMhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:37:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9166 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbhAMMhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610541441; x=1642077441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cl7gDn1nGGA2fuqkriLn1AJF8xTaanOR5rqRhb8yjR8=;
  b=B9iJTumsNpGfs5GGTc3hBkIbv5xH05JV6TQPq2Rnt6w4sUmlfBKaFvOX
   7boPaTnyqFIQhT1hCT0Bvna4EtG5/EQQ+LHFm2s22ZWcrTMVtVseKra0c
   m2CZgUYNpwYID1RJ/1YlTIInovJPqXYW1gMtVOvGeqxZfubtJN2OTXkdK
   GZjHoKfL/Z5pxbIRHYT3ARIDQ/+Pc5oDakqxpLogTQyTJxEYHUhYScC1c
   H4CrhhipJ6Sb8bO+lyRVmu8rWy8neOqKJtELVjaBQGKNDe21dSjNCv5Tt
   lZ9Gp7PaFkk7DF9sf+EgifWkkWX77hskHYm67YraxHR2xUiRb9a1Td/wU
   g==;
IronPort-SDR: UvcHaCZuyheTwSyo9kx7SmoB+lCODFS1XRjFznbVKotucmAkWRa5ZelKw4Htjnkey+2+2G9EZ7
 gAy1ycL1jOPwn0VCSHXWgiN0StVCd9+rm3hoWUtPcKmi4v7vIRKUncGg5uQKglNGq/NR0IC1ap
 sHJl8YLKuB4tGk+B8mxJUvGqZ5iKxQBuZaZCKYB2fm89r+SssLas/LCrtSKnFZ3MExSBhw+9rP
 ByBJJL90PEUk7M5gcFgu1IX5tLr8Y3NnZ3nvcC5HAhoZPm2p9WgR5C/IQiqzdS2R8toenw4GkA
 ix0=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="105287540"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 05:36:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 05:36:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 13 Jan 2021 05:36:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxxDhJwbvz4CYBFny2P7Nbv0a8j1prAO3AEET9dFOtMnSPmmNBIFGQ3Msege706mv27XLNlvJHafy2jNcfUAJjGm9x1ZqmUOWfB6hxVU3K0AXl6hOCFIJQrj/J+JF6B2+9V6fqVDJyw0CdoPElJmy4Dt8pbfmuzPxxvCRF3LobS5wW+b/Slx1I+9eVbLf+YwC5SQuA+ccqCkryaebH2tcwK4WztD+vxst9qAxk20ARHPbMk4yK1NTvwF2F/AXjQ7wUU0tA2StzUHAIjnbSpr1G+FNZFTw4RWUIHOjzX7VjIP+o1wtTT1IjKC3d6u9UcicQpc/PSmo0NQhHE2n3xAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cl7gDn1nGGA2fuqkriLn1AJF8xTaanOR5rqRhb8yjR8=;
 b=AWd5Yc5uetP65wxuc+QkRuB3ZEL8gS1iG600UrIYvNeNRbowNSDMAWwHJawZ/mSWhCGVL6gHEUpWLDAUbnwri+60Ec8B352XNH2feNeRGBzlny/vguwbmquF1OKHBRTk6d1dWb4JUECxpVRYEH+P2WRviMXyp8DK/sbFXSN1Fz//MjpJ072Fi18rDDfswPfYBlX9Af/w3SrcXJWLesIrNCiaip+2loQW8RK81MebHsh1APDJWFSGDTToxDo9zHNMyKToMrDLwRyl+djB1biMygeCxGJw/4NsSqlN44xGqrMl9LAx2U5iIIXr+tUcBt2riP6XMwimqIqcUwJzpSO19Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cl7gDn1nGGA2fuqkriLn1AJF8xTaanOR5rqRhb8yjR8=;
 b=h0FwhIa2Dmgk4Ymez8EDs/loZ4Jz+0FWBNeRUATe+C/Ot4AMy6U3S3M9TmAayEx6WiCoxKGloYwrqaLeB7w+ULeT2sIcW3zk5iPC+ASO2GPMRw30UpU89cAOgurXUHBJ2io93Dcjk6PLWQ/y9pdFPfb9irutGR/mwBqaUr4EkIA=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB2859.namprd11.prod.outlook.com (2603:10b6:5:c9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Wed, 13 Jan 2021 12:36:01 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 12:36:01 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <hkallweit1@gmail.com>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Topic: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Index: AQHW6Y6UrG2j4PiM1k2BT3XuGZuJHg==
Date:   Wed, 13 Jan 2021 12:36:01 +0000
Message-ID: <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
In-Reply-To: <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f258127-5682-4806-5dbe-08d8b7bfc918
x-ms-traffictypediagnostic: DM6PR11MB2859:
x-microsoft-antispam-prvs: <DM6PR11MB2859FD337F696002CCF1A06787A90@DM6PR11MB2859.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nqEhgu3zeAu5GmUblMBKjjh+3W4CAdGIdtNQDz0hywKG1fYcFNj3IkIFmPkyzPXXpw2ggZ+Hjwr5yZq0lsYqPg6RLM/S7hhRQy82dQYe8gnmDCM1gI7s2mSqoFRtSj3maoAo3ejNiZSAS1KTk2Mdcno5+1fF+zczSvwCwpPG5AwT+q5jpI/p0O6arr+aE6D4BdyFPB1H6DIqrnG4A3Mjh8cmCX3kgwJtrDNKl/Gev/hDt41p+/a3Xj5E8vTIJhThOav3O+mb9Gkj4a24/v3PzqOJk7Oqzx+mYmcKUgCRfdjya0Wv6aSznYtuHxWIMBawn1vIMhrht2+SrLpi+SpEztzR8xJH+KCO+WO1J/V5b9u+T86l9sC1iPfjv8gEl2fiQ3HvUtNdOW5UQNUhwWk/NUolUx3EkBnQHhz8E33Hpmi7/Nx1hCuhPgHwkvfo8LyQuLfc0v1V5JkbrNDZSMic3uH0JH3oHoeEeI82ofhR5fo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(31696002)(186003)(6486002)(66946007)(8936002)(91956017)(76116006)(83380400001)(71200400001)(26005)(6512007)(6506007)(53546011)(110136005)(31686004)(5660300002)(4326008)(54906003)(8676002)(316002)(66476007)(2906002)(2616005)(66556008)(36756003)(64756008)(66446008)(86362001)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bTZEZzFLTlQ0YU8vNmRhOUNwU2labHdyOVUvdTZwUmZzV2hnRmxEdXp2dUlO?=
 =?utf-8?B?MlNjRlFvM0J1L2c2MHNKL0xnOE5hWm5ocitBeEdKcVlicDR0OGRaRGZyc2c5?=
 =?utf-8?B?ODd6a3kxRTh1MFg2SnRLOE1Jc0R5ZmhPUU53YkpZRmRUT0QzQkVreU5pQTMz?=
 =?utf-8?B?OXBzb1IxWk9jZTNiSzJZU1hoQ0VvUFl5UnFOQVNBdUpGM3N5ZnZFd2lWMHBr?=
 =?utf-8?B?ZnZHRjNUeEYxNE5UMDZNcUo2aTFDb0JSaHFYdU5lVXYrK1FWM3BmNlc0V24w?=
 =?utf-8?B?WGt4ODBXVnlaeGJZUUd4NkNqa2VENkJoV1ZtSitFOEFPOE1LWHlCUEkzc1N1?=
 =?utf-8?B?aUpJdUtnRUZUWFNKOWF6VGRCaXBWZE5GMzRWamxKWVlJSUlkS25zZCtObzM4?=
 =?utf-8?B?TzhFUWFCejJ2bHVSdGJjL1NydDVjS1RRYnowTzFTMm5MUnpNTXZEdUVRS2dw?=
 =?utf-8?B?YVU2OStFdTlZMnMzcURvOTJTSjJEMmdaWCsvZy9OWHd6YjMrVm05d1VDdVJK?=
 =?utf-8?B?SnVwVHlXeFdMaFU2cm5Xcy9NTm8ydFo2ZDh3ZFNkL3diSXNqblJielZ1VUN4?=
 =?utf-8?B?NDc5QUovKzlOWkZuK1p2TmVNcEd0L2JGUTFxR2l6UFd4bjd5Ykp3UGRnaWNZ?=
 =?utf-8?B?S3Rvd0szRXNkZ1Jkby9lU1FaYzZPaXIzd29HN0VYZkMzUDBtZlp5cFhDNVhI?=
 =?utf-8?B?dE95QWpVTTlxa0RBV2tVOFJmeXNEOXM2MFJvOHFyUjJyVWc1cXJyRHpUbTNl?=
 =?utf-8?B?dy9mNXJSNUo5VElmdmt6NmZHcDFJd2JONVBVODcyMEhUeFJtTlVERXRad01x?=
 =?utf-8?B?NmkzTmtYMDRiZTRDeTNCemMvQk9iL0VSZGZRZ0hONXl4RDNjQm0yMi91ZnBJ?=
 =?utf-8?B?elJQY2ZRc1dROUtZYk8vayszY0x5cjZ5OXdxdjlEdzl3ZExBd1RaYSt3WjZq?=
 =?utf-8?B?WUFVajR4MDMyRWJMUDZiWjUvbUU1eHAxam1OdVFrYUl6SUVpVWhVSWpPWCtt?=
 =?utf-8?B?Q3B5Z0RNMElWQ24wMHh6VGxhYmNzZExnQWlmZldoT3g1dnJyVlRFTmNSdlZl?=
 =?utf-8?B?bVdwZXpYRkhRZzUySE1uRU4wVzJPaVhGUno1STVITzY0MGhFRFNwRzUzTWZv?=
 =?utf-8?B?ZDhoSVdkYkpVbXN5Y1V6R09FZ0svR0kwc2ttTW9lbkxkdDZ6MGtMNGJZR2NO?=
 =?utf-8?B?Q0RzT3EyMWk5M1pFak5YWFFIdGNxVWl4ZUlTeGUvR0hkN0oyNGQ4WldiM1pS?=
 =?utf-8?B?YXdmMXNOdXVIWW5WVTJPYzg1eDQ3NzBqbkhJbXdtNGlJTjJvWFQ5MmRLQjQz?=
 =?utf-8?Q?ZCt4USCGKZdNflkgX6IWUOIMO9MFq0f/GV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6762C52FCDB16499EEA1BE5815105CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f258127-5682-4806-5dbe-08d8b7bfc918
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 12:36:01.2199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YKWUI9ixvZ2gWn2JYdrkq0EUk+LVxnbAaiZHDpDZfSfSUn3bM4JTR7fhg5v5gYWEAYuh5uxNk4VFWvQAiw4jsDKe5KGNl5J2cjcnLzPgDZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEzLjAxLjIwMjEgMTM6MDksIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiAxMy4wMS4yMDIxIDEwOjI5LCBD
bGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gSGkgSGVpbmVyLA0KPj4NCj4+
IE9uIDA4LjAxLjIwMjEgMTg6MzEsIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4+PiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pg0KPj4+IE9uIDA4LjAxLjIwMjEgMTY6NDUs
IENsYXVkaXUgQmV6bmVhIHdyb3RlOg0KPj4+PiBLU1o5MTMxIGlzIHVzZWQgaW4gc2V0dXBzIHdp
dGggU0FNQTdHNS4gU0FNQTdHNSBzdXBwb3J0cyBhIHNwZWNpYWwNCj4+Pj4gcG93ZXIgc2F2aW5n
IG1vZGUgKGJhY2t1cCBtb2RlKSB0aGF0IGN1dHMgdGhlIHBvd2VyIGZvciBhbG1vc3QgYWxsDQo+
Pj4+IHBhcnRzIG9mIHRoZSBTb0MuIFRoZSByYWlsIHBvd2VyaW5nIHRoZSBldGhlcm5ldCBQSFkg
aXMgYWxzbyBjdXQgb2ZmLg0KPj4+PiBXaGVuIHJlc3VtaW5nLCBpbiBjYXNlIHRoZSBQSFkgaGFz
IGJlZW4gY29uZmlndXJlZCBvbiBwcm9iZSB3aXRoDQo+Pj4+IHNsZXcgcmF0ZSBvciBETEwgc2V0
dGluZ3MgdGhlc2UgbmVlZHMgdG8gYmUgcmVzdG9yZWQgdGh1cyBjYWxsDQo+Pj4+IGRyaXZlcidz
IGNvbmZpZ19pbml0KCkgb24gcmVzdW1lLg0KPj4+Pg0KPj4+IFdoZW4gd291bGQgdGhlIFNvQyBl
bnRlciB0aGlzIGJhY2t1cCBtb2RlPw0KPj4NCj4+IEl0IGNvdWxkIGVudGVyIGluIHRoaXMgbW9k
ZSBiYXNlZCBvbiByZXF1ZXN0IGZvciBzdGFuZGJ5IG9yIHN1c3BlbmQtdG8tbWVtOg0KPj4gZWNo
byBtZW0gPiAvc3lzL3Bvd2VyL3N0YXRlDQo+PiBlY2hvIHN0YW5kYnkgPiAvc3lzL3Bvd2VyL3N0
YXRlDQo+Pg0KPj4gV2hhdCBJIGRpZG4ndCBtZW50aW9uZWQgcHJldmlvdXNseSBpcyB0aGF0IHRo
ZSBSQU0gcmVtYWlucyBpbiBzZWxmLXJlZnJlc2gNCj4+IHdoaWxlIHRoZSByZXN0IG9mIHRoZSBT
b0MgaXMgcG93ZXJlZCBkb3duLg0KPj4NCj4gDQo+IFRoaXMgbGVhdmVzIHRoZSBxdWVzdGlvbiB3
aGljaCBkcml2ZXIgc2V0cyBiYWNrdXAgbW9kZSBpbiB0aGUgU29DLg0KDQpGcm9tIExpbnV4IHBv
aW50IG9mIHZpZXcgdGhlIGJhY2t1cCBtb2RlIGlzIGEgc3RhbmRhcmQgc3VzcGVuZC10by1tZW0g
UE0NCm1vZGUuIFRoZSBvbmx5IGRpZmZlcmVuY2UgaXMgaW4gU29DIHNwZWNpZmljIFBNIGNvZGUN
CihhcmNoL2FybS9tYWNoLWF0OTEvcG1fc3VzcGVuZC5TKSB3aGVyZSB0aGUgU29DIHNodXRkb3du
IGNvbW1hbmQgaXMNCmV4ZWN1dGVkIGF0IHRoZSBlbmQgYW5kIHRoZSBmYWN0IHRoYXQgd2Ugc2F2
ZSB0aGUgYWRkcmVzcyBpbiBSQU0gb2YNCmNwdV9yZXN1bWUoKSBmdW5jdGlvbiBpbiBhIHBvd2Vy
ZWQgbWVtb3J5LiBUaGVuLCB0aGUgcmVzdW1lIGlzIGRvbmUgd2l0aA0KdGhlIGhlbHAgb2YgYm9v
dGxvYWRlciAoaXQgY29uZmlndXJlcyBuZWNlc3NhcnkgY2xvY2tzKSBhbmQganVtcCB0aGUNCmV4
ZWN1dGlvbiB0byB0aGUgcHJldmlvdXNseSBzYXZlZCBhZGRyZXNzLCByZXN1bWluZyBMaW51eC4N
Cg0KPiBXaGF0ZXZlci93aG9ldmVyIHdha2VzIHRoZSBTb0MgbGF0ZXIgd291bGQgaGF2ZSB0byB0
YWtlIGNhcmUgdGhhdCBiYXNpY2FsbHkNCj4gZXZlcnl0aGluZyB0aGF0IHdhcyBzd2l0Y2hlZCBv
ZmYgaXMgcmVjb25maWd1cmVkIChpbmNsLiBjYWxsaW5nIHBoeV9pbml0X2h3KCkpLg0KDQpGb3Ig
dGhpcyB0aGUgYm9vdGxvYWRlciBzaG91bGQga25vdyB0aGUgUEhZIHNldHRpbmdzIHBhc3NlZCB2
aWEgRFQgKHNrZXcNCnNldHRpbmdzIG9yIERMTCBzZXR0aW5ncykuIFRoZSBib290bG9hZGVyIHJ1
bnMgZnJvbSBhIGxpdHRsZSBTUkFNIHdoaWNoLCBhdA0KdGhlIG1vbWVudCBkb2Vzbid0IGtub3cg
dG8gcGFyc2UgRFQgYmluZGluZ3MgYW5kIHRoZSBEVCBwYXJzaW5nIGxpYiBtaWdodA0KYmUgYmln
IGVub3VnaCB0aGF0IHRoZSBmaW5hbCBib290bG9hZGVyIHNpemUgd2lsbCBjcm9zcyB0aGUgU1JB
TSBzaXplLg0KDQo+IFNvIGl0JyBtb3JlIG9yIGxlc3MgdGhlIHNhbWUgYXMgd2FraW5nIHVwIGZy
b20gaGliZXJuYXRpb24uIFRoZXJlZm9yZSBJIHRoaW5rDQo+IHRoZSAucmVzdG9yZSBvZiBhbGwg
c3Vic3lzdGVtcyB3b3VsZCBoYXZlIHRvIGJlIGV4ZWN1dGVkLCBpbmNsLiAucmVzdG9yZSBvZg0K
PiB0aGUgTURJTyBidXMuDQoNCkkgc2VlIHlvdXIgcG9pbnQuIEkgdGhpbmsgaXQgaGFzIGJlZW4g
aW1wbGVtZW50ZWQgbGlrZSBhIHN0YW5kYXJkDQpzdXNwZW5kLXRvLW1lbSBQTSBtb2RlIGJlY2F1
c2UgdGhlIFJBTSByZW1haW5zIGluIHNlbGYtcmVmcmVzaCB3aGVyZWFzIGluDQpoaWJlcm5hdGlv
biBpdCBpcyBzaHV0IG9mIChhcyBmYXIgYXMgSSBrbm93KS4NCg0KPiBIYXZpbmcgc2FpZCB0aGF0
IEkgZG9uJ3QgdGhpbmsgdGhhdCBjaGFuZ2UgYmVsb25ncyBpbnRvIHRoZQ0KPiBQSFkgZHJpdmVy
Lg0KPiBKdXN0IGltYWdpbmUgdG9tb3Jyb3cgYW5vdGhlciBQSFkgdHlwZSBpcyB1c2VkIGluIGEg
U0FNQTdHNSBzZXR1cC4NCj4gVGhlbiB5b3Ugd291bGQgaGF2ZSB0byBkbyBzYW1lIGNoYW5nZSBp
biBhbm90aGVyIFBIWSBkcml2ZXIuDQoNCkkgdW5kZXJzdGFuZCB0aGlzLiBBdCB0aGUgbW9tZW50
IHRoZSBQTSBjb2RlIGZvciBkcml2ZXJzIGluIFNBTUE3RzUgYXJlDQpzYXZpbmcvcmVzdG9yaW5n
IGluL2Zyb20gUkFNIHRoZSByZWdpc3RlcnMgY29udGVudCBpbiBzdXNwZW5kL3Jlc3VtZSgpDQpm
dW5jdGlvbnMgb2YgZWFjaCBkcml2ZXJzIGFuZCBJIHRoaW5rIGl0IGhhcyBiZWVuIGNob3NlbiBs
aWtlIHRoaXMgYXMgdGhlDQpSQU0gcmVtYWlucyBpbiBzZWxmLXJlZnJlc2guIE1hcHBpbmcgdGhp
cyBtb2RlIHRvIGhpYmVybmF0aW9uIHdpbGwgaW52b2x2ZQ0Kc2F2aW5nIHRoZSBjb250ZW50IG9m
IFJBTSB0byBhIG5vbi12b2xhdGlsZSBzdXBwb3J0IHdoaWNoIGlzIG5vdCB3YW50ZWQgYXMNCnRo
aXMgaW5jcmVhc2VzIHRoZSBzdXNwZW5kL3Jlc3VtZSB0aW1lIGFuZCBpdCB3YXNuJ3QgaW50ZW5k
ZWQuDQoNCj4gDQo+IA0KPj4+IEFuZCB3b3VsZCBpdCBzdXNwZW5kIHRoZQ0KPj4+IE1ESU8gYnVz
IGJlZm9yZSBjdXR0aW5nIHBvd2VyIHRvIHRoZSBQSFk/DQo+Pg0KPj4gU0FNQTdHNSBlbWJlZHMg
Q2FkZW5jZSBtYWNiIGRyaXZlciB3aGljaCBoYXMgYSBpbnRlZ3JhdGVkIE1ESU8gYnVzLiBJbnNp
ZGUNCj4+IG1hY2IgZHJpdmVyIHRoZSBidXMgaXMgcmVnaXN0ZXJlZCB3aXRoIG9mX21kaW9idXNf
cmVnaXN0ZXIoKSBvcg0KPj4gbWRpb2J1c19yZWdpc3RlcigpIGJhc2VkIG9uIHRoZSBQSFkgZGV2
aWNlcyBwcmVzZW50IGluIERUIG9yIG5vdC4gT24gbWFjYg0KPj4gc3VzcGVuZCgpL3Jlc3VtZSgp
IGZ1bmN0aW9ucyB0aGVyZSBhcmUgY2FsbHMgdG8NCj4+IHBoeWxpbmtfc3RvcCgpL3BoeWxpbmtf
c3RhcnQoKSBiZWZvcmUgY3V0dGluZy9hZnRlciBlbmFibGluZyB0aGUgcG93ZXIgdG8NCj4+IHRo
ZSBQSFkuDQo+Pg0KPj4+IEknbSBhc2tpbmcgYmVjYXVzZSBpbiBtZGlvX2J1c19waHlfcmVzdG9y
ZSgpIHdlIGNhbGwgcGh5X2luaXRfaHcoKQ0KPj4+IGFscmVhZHkgKHRoYXQgY2FsbHMgdGhlIGRy
aXZlcidzIGNvbmZpZ19pbml0KS4NCj4+DQo+PiBBcyBmYXIgYXMgSSBjYW4gc2VlIGZyb20gZG9j
dW1lbnRhdGlvbiB0aGUgLnJlc3RvcmUgQVBJIG9mIGRldl9wbV9vcHMgaXMNCj4+IGhpYmVybmF0
aW9uIHNwZWNpZmljIChwbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcpLiBPbiB0cmFuc2l0
aW9ucyB0bw0KPj4gYmFja3VwIG1vZGUgdGhlIHN1c3BlbmQoKS9yZXN1bWUoKSBQTSBBUElzIGFy
ZSBjYWxsZWQgb24gdGhlIGRyaXZlcnMuDQo+Pg0KPj4gVGhhbmsgeW91LA0KPj4gQ2xhdWRpdSBC
ZXpuZWENCj4+DQo+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVk
aXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgZHJpdmVycy9uZXQvcGh5
L21pY3JlbC5jIHwgMiArLQ0KPj4+PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvbWlj
cmVsLmMgYi9kcml2ZXJzL25ldC9waHkvbWljcmVsLmMNCj4+Pj4gaW5kZXggM2ZlNTUyNjc1ZGQy
Li41MmQzYTA0ODAxNTggMTAwNjQ0DQo+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwu
Yw0KPj4+PiArKysgYi9kcml2ZXJzL25ldC9waHkvbWljcmVsLmMNCj4+Pj4gQEAgLTEwNzcsNyAr
MTA3Nyw3IEBAIHN0YXRpYyBpbnQga3N6cGh5X3Jlc3VtZShzdHJ1Y3QgcGh5X2RldmljZSAqcGh5
ZGV2KQ0KPj4+PiAgICAgICAgKi8NCj4+Pj4gICAgICAgdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDAp
Ow0KPj4+Pg0KPj4+PiAtICAgICByZXQgPSBrc3pwaHlfY29uZmlnX3Jlc2V0KHBoeWRldik7DQo+
Pj4+ICsgICAgIHJldCA9IHBoeWRldi0+ZHJ2LT5jb25maWdfaW5pdChwaHlkZXYpOw0KPj4+PiAg
ICAgICBpZiAocmV0KQ0KPj4+PiAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+Pj4+DQo+Pj4+
DQo+IA==
