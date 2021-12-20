Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812F347A3E5
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 04:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhLTDYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 22:24:41 -0500
Received: from mswout.fic.com.tw ([60.251.164.98]:37388 "EHLO
        mswout.fic.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbhLTDYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 22:24:40 -0500
Received: from spam.fic.com.tw (unknown [10.1.1.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mswout.fic.com.tw (Postfix) with ESMTPS id 22227C037D;
        Mon, 20 Dec 2021 11:24:38 +0800 (CST)
Received: from TPEX1.fic.com.tw (TPEX1.fic.com.tw [10.1.1.107])
        by spam.fic.com.tw with ESMTP id 1BK3HQm0002327;
        Mon, 20 Dec 2021 11:17:26 +0800 (+08)
        (envelope-from KARL_TSOU@UBIQCONN.COM)
Received: from TPEX1.fic.com.tw (10.1.1.107) by TPEX1.fic.com.tw (10.1.1.107)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 11:24:31 +0800
Received: from TPEDGE1.fic.com.tw (10.1.100.44) by TPEX1.fic.com.tw
 (10.1.1.107) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 20 Dec 2021 11:24:31 +0800
Received: from APC01-HK2-obe.outbound.protection.outlook.com (104.47.124.53)
 by mailedge.fic.com.tw (10.1.100.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.17; Mon, 20 Dec 2021 11:21:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGNAzngYThFnL/0L9fneh0io46xSof910vjCEel2KqEkGDIr9GZyVdaQL3z1InG/bOr/9IBeBUTR/7hw3wILJ2ZzY8/LQUw2scAGjRMgKQJgATFmA+vzTEszZd2VTXh4TMtjmwlViVQ2NGEN9eAk6o0HH4Vnjn8NRO33f93eutxyJymNjSEqPlBxASpH+rr3bUa+UC+bPo1pCkZgQgMzjJI8/SlKIvJlFi0X9lDw0CqUdN/8R47OVqYEGEVw4F5eexVW5cpQsbeTEiGv5Djp2ARqlMkwELx9OEh8ThvKh7GJqUF/PXmIxVpBTEq4HlBhB7UOdp1aG6FeI2FgcX+e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q46FzuYG9K20aWzAYglSD1O1Shk3P8qMY1d1StH71Gk=;
 b=bs8+3oBfs7Pw6aczdo89XqOc/m6TinTClInd9LdZHkctUBuvWIAxq0ALTs7veq1SihBNNSjlxxTjwFGsHXlx6+E0DFL+a9LGctX5NHeWUzakWt+h0su7WIxOhgSWDfftdqwStpMoMG+i7ebqyJfkMu8v9VUMW1o3vRQLLDFhAGP0HKqocuCkUjhukpcJ9Oy/g/ZhIoqL1LX81ytJbPjNeq1R10waBu8RhK2AOUPi9SnkH2GpHdwLs7FeX1Or/w4cFxdjf4cVxKP7+ivOGJhmr8xloX1SJBV7Dj37n7fRJfkNVR5rnH+M7d99qcM+iWaRwUNEAmeqbHS7wOeutSa4Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ubiqconn.com; dmarc=pass action=none header.from=ubiqconn.com;
 dkim=pass header.d=ubiqconn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fico365.onmicrosoft.com; s=selector1-fico365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q46FzuYG9K20aWzAYglSD1O1Shk3P8qMY1d1StH71Gk=;
 b=gktHUUESyBKJGqhQDzGm5LA0rdNz1NwatTCFJHQcEyInMXshi6LLiQkalq87FoLdsMKpERH3Cr/8BfdqKk+BsnsojIpAMMyqDgjarBllLPdWQyg0keVQHtCtQl5DWR9YC6fzmDNbcNaB07dYK488Eaj8V2+xVU17hdOoUWFIWGg=
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com (2603:1096:202:28::11)
 by KL1PR03MB5570.apcprd03.prod.outlook.com (2603:1096:820:51::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Mon, 20 Dec
 2021 03:24:30 +0000
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91]) by HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91%4]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 03:24:30 +0000
From:   =?utf-8?B?S0FSTF9UU09VICjphJLno4op?= <KARL_TSOU@UBIQCONN.COM>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Topic: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Index: AQHX8lxFF5ETxF22rUqK34URMx0EUKw052iAgAEU/GeAAHflAIAEQbGw
Date:   Mon, 20 Dec 2021 03:24:30 +0000
Message-ID: <HK2PR03MB4307A5C2636F20F352FAB557E07B9@HK2PR03MB4307.apcprd03.prod.outlook.com>
References: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
 <YbsSHSmxrZZ4jhvD@lunn.ch>
 <HK2PR03MB430766D15AD96E3F0E52A3D3E0789@HK2PR03MB4307.apcprd03.prod.outlook.com>
 <YbxfCkstuBOVI2e0@lunn.ch>
In-Reply-To: <YbxfCkstuBOVI2e0@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=UBIQCONN.COM;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 438a85d6-5659-4e1f-1ef4-08d9c3683c2b
x-ms-traffictypediagnostic: KL1PR03MB5570:EE_
x-microsoft-antispam-prvs: <KL1PR03MB5570914E666551D18E14A601E07B9@KL1PR03MB5570.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zkYbpglZYT23oR9GGb3L6ikUmssMZbDC17MVywDJshBM+yBmZFvXED3Ut5NXO40WRdExOTlKP0eQ20RuFAL6wdCT8Bl30EL/cCXEJvcSjOqktMQtomNMYQxJYO+Kv+Tf92A4lBt43gT97ZdKBxfnZswzkAkcO4ocFF/OtLjwJg2OT7V+u+bQJ3R64AGyCpPIjlPdBfz/bzspPs3/vKcwTIGYYguu0f6CT/iRBSkl5+BAUooXUEzVv22aG82O3wB9j1FctcSX0ugzm42Lje9r8isEQeTFgHy0+CchfXw6ou9XtoBAgT/Fh38O7ymcYZk37tjYSLr/tZjcYTSojaj7TnELjemM4f7kiuQOgCEIDlsqA59iB0xtFUAP5npML8hQOmuRGhiX29O/rMKlqCU6cxDXWTW77KtxH3cjF0fO4mCKNcKUF4lTBY0OpPNIpRa/yNlWBFcy/qV7h8IL6wGSM8PkzpV+UGvoNCERKgYmkNh/JBBVNb7O1dLxVqkE6qPs32hMU0M2tDOmWldX/w49lBIc5uGabhBiEAzMjj3YvxDWPMEKs6aSRwTvR0CPJTIHx3pBeBaznIWzJ8tIUHMuElUg+Y55vR2pDDqiGO12Spa89UHy06VHZxazk9JjH6VUy7vGJvx/fL2No4zxbxZGwWYZNCbaYNnY4h0r68ScwXYPWSCKoxwAICc047zhwqVMgvfT8SAxGKJXWdn6zScXYYz7RvS6Xs+pFN/XP533eLQaVhlcuXI6aVfCkRcO55/U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR03MB4307.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(83380400001)(4326008)(64756008)(8936002)(186003)(9686003)(66556008)(66476007)(66446008)(86362001)(33656002)(85182001)(55016003)(26005)(53546011)(6506007)(2906002)(8676002)(316002)(122000001)(38100700002)(6916009)(508600001)(71200400001)(5660300002)(7696005)(52536014)(54906003)(76116006)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkNTNEY1MlJ3elpyMS9DejZkVXBQU2JBd3d2QUs2d2o3d1ZrTnhSVENLblB6?=
 =?utf-8?B?ZmtONzZzem5BUElUUzIzSFZ5T1puSU56M0RKQmxzY2o2QmhiMDRrVFltcDNU?=
 =?utf-8?B?aEg5TkRlNHRGWTZwUlN1d2M2Y3NMRXVSYm1wcGtodjhzQnF0SS9RY2pDUGpv?=
 =?utf-8?B?L2R2cTVzNnlIekFDdWp6OGZhdnVGMmNFeG0rakx5TVFOZzlJUHQ5SVFERmI4?=
 =?utf-8?B?TVhERVZ3Wk9GbWVlamI1UWgxdVEvRmE5U0RsSVdXdG5UQU8waXp0VFFJcWpH?=
 =?utf-8?B?b1lrSG1HcGs5aUxpYUovUzNiWFhVZkx2YytoZ2N3dGNTUkdVdk5NbFgzNFRL?=
 =?utf-8?B?clNWWUhuSG5TdkxtVWR2TzBhYzYrWEhGOTRaaGlCQWQrZTdIbm9UYnRtSk9n?=
 =?utf-8?B?YWUwNG9mdTczbjMxNFpJSUxYMndHeUdEV2F3S0pweVh1QzYxLzR0Y0FoczZp?=
 =?utf-8?B?YnNNRjE2eUkySExvekJoRS8wMW5vWjZmWkhmaE0xUDNkSGQralNucmVIZ2NM?=
 =?utf-8?B?elJmQkNJNHhxZVZaNFArOEFjUTZGNTJsM09tcFF3QU5ZdFdiVkw3SG4zM0FQ?=
 =?utf-8?B?cFFIdzFSS3ErM1FYY1oveEFLOWRaZU9WSnFjYjdPZXFMVmpLeHpaZHBSb3E5?=
 =?utf-8?B?NXZ5RzhENCtnSWNrUldXM0hvOWE2Qm9qTDR4cG1USTYzRkptTkJ1RUFpUjJZ?=
 =?utf-8?B?TmxFV3JCaVRuMzVweEZ6TFdqSm5LMDVkdklRNlQ0QnNVMVJkb3F4Nk1LMzM0?=
 =?utf-8?B?WnE2UlBrZXF3K1FzZlpOWisyTlFmMHZTWEhVUk9wVGltc1hYYjlMUGJNb09F?=
 =?utf-8?B?ZVJPVDJZR1g1bFUxRXRBRXcydDVlZ01HWlY1TzVnZ2RPRFMyMlVxMXZLY0Uw?=
 =?utf-8?B?a0dTUWk1eEdsUzJBZGlSaFE2TVRNRDhBUHRmaWxEV2RQK3BIZVBqQ3I2Qm5L?=
 =?utf-8?B?dXRFSmhVQjNyZnhQT211Y0hCTUYvUGhKK3NZdlI1T3NaSFVBT29RQXg1OWtO?=
 =?utf-8?B?M3R2UE8yUVRPOHF3dXlvSGtEZmdTNTFMNm9WMjhvcUJXczRnMUxBZHZXTUNP?=
 =?utf-8?B?Tkc5SE9rSyt2TmxaRmxwNjRUbW1tSTNSZmhUQTRXeFQzOUJzTWNITTlyUHd3?=
 =?utf-8?B?b0JCKy9MTzA5Zm5Ya2RtS2lCWlVPY3QwTTgrWUZEVVZQb05qZCszM1AxTXZz?=
 =?utf-8?B?VUlkT090Y3J1WFphTE9VTXRJYURwVnVSRlVWVE9VM2diVE1jaE1oOXlnd2FV?=
 =?utf-8?B?bjhnVFdSR0krekcvY0crSHZ0cFNRMGZCVzloYld1TmZ1WE1qZ095QlBTYi9n?=
 =?utf-8?B?b3dQTjhla0FuWHdCb2pWUzJJVmttcEorWU5rRGlQRmhLZUZkVFpIeDRUbnZC?=
 =?utf-8?B?RjEwNDNVbTZaR0JTNHBpUnVaTnVoNW0wdGNXK1RFQUpwNThaa3ZXc3orNHNs?=
 =?utf-8?B?TGo0Z3QyNGFoZm53SlBBeHhKOFBtdmh3dUdNUmsxZ01iakhqYWxqeFJhcFkv?=
 =?utf-8?B?OGwvTnBOZHZ1djR6YTB5dENCZDZhdDRMYTNtYk84S3N6TE9Lc3pTMjVaNUJ1?=
 =?utf-8?B?SVBtek1FMHY1VmI3RmcvaVkrLzZLbm1Pdlc2dW1SV1FuZWNNamVxdVRUQ2pT?=
 =?utf-8?B?K0NJTWt3VE8wUUN1Kzk0bllaQm5XdVh5dnM4NnFIOUMzcWxMUVU2Q0Z5cThG?=
 =?utf-8?B?MEVWOWEyNzhlekIyc0RwQ1A4SlYyZTBmc3IycU94elgrSkEzWS9vMXczM3Qx?=
 =?utf-8?B?YTNKaWtqUFo4ekh1OEg3RlAwNDE5SXRqOXQxeVNzcFJaTFdVN2Z0UVZPZWYr?=
 =?utf-8?B?QnZpbmtwaDY3djI5SUdHZTFrOFBZNWdHeUt0bituVFhNT1BNb1V3cUxpL0VO?=
 =?utf-8?B?aTZZY3NabXJJREY2MTlBVWRuajlLTU9vOTUzSkFoc0tWbVhyUTlHTjVCY0Vp?=
 =?utf-8?B?eGUzOWFkWlEyMFVvWVk5VVlST2hiczJwdTZRTWF5QXQzK3hidlFULzVCbjJm?=
 =?utf-8?B?TlhHWmU4UE41eE5JMlN1bkdOdG5GdHBNYWNmYktrN2lpSVlya3hnUHllbFlW?=
 =?utf-8?B?NFpkWWcvU0RocFFHK0ZzZ0dsTUh0Y000ZXhXVXRZSkhOQUtYWUJXaGxaTS9m?=
 =?utf-8?B?S3pteWlBSlJTZk50b2RiRnUyS2xZS0F6K2Vhelc5U293dThGdUpsOEYzTnh0?=
 =?utf-8?Q?CscJ+sG0oCf15TQBdyao3h8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR03MB4307.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438a85d6-5659-4e1f-1ef4-08d9c3683c2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 03:24:30.2328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 767e8d94-d5f3-412e-b9e8-50323cd2c43c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N2nOm7l1/HN3u+SYCocTdD2bbiW9GoHhyyt1cSkF0hV1e61kzp+lRkFiafiKoPA5fj1CWIt0yapbOzzSuFnZ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB5570
X-OriginatorOrg: ubiqconn.com
X-DNSRBL: 
X-MAIL: spam.fic.com.tw 1BK3HQm0002327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgMTcsIDIwMjEgNTo1OCBQTQ0KPiBU
bzogS0FSTF9UU09VICjphJLno4opIDxLQVJMX1RTT1VAVUJJUUNPTk4uQ09NPg0KPiBDYzogd29v
anVuZy5odWhAbWljcm9jaGlwLmNvbTsgVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsNCj4g
dml2aWVuLmRpZGVsb3RAZ21haWwuY29tOyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgb2x0ZWFudkBn
bWFpbC5jb207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IGRzYTogbWljcm9j
aGlwOiBBZGQgc3VwcG9ydGVkIGtzejk4OTcgcG9ydDYNCj4gDQo+IE9uIEZyaSwgRGVjIDE3LCAy
MDIxIGF0IDAyOjUzOjE1QU0gKzAwMDAsIEtBUkxfVFNPVSAo6YSS56OKKSB3cm90ZToNCj4gPiBU
aGUgTWljcm9jaGlwIHN3aXRjaCBrc3o5ODk3IHN1cHBvcnQgNyBwaHlzaWNhbCBwb3J0LCBwb3J0
IDAvMS8yLzMvNA0KPiBjb25uZWN0IHRvIHN0YW5kYXJkIFJKNDUsIHBvcnQ1IGNvbm5lY3QgdG8g
UEhZIHZpYSBNSUkgdG8gQ1BVIGFuZA0KPiBwb3J0NiBjb25uZWN0IHRvIFBIWSB2aWEgUk1JSSAo
UEhZIGtzejgwODEpIG9uIG15IGN1c3RvbSBib2FyZC4NCj4gDQo+IFBsZWFzZSBkb24ndCB0b3Ag
cG9zdC4gQWxzbywgd3JhcCB5b3VyIGVtYWlscyBzbyBsaW5lcyBhcm91bmQgNzANCj4gY2hhcmFj
dGVycy4NCj4gDQo+ID4gSSBhbSBmYWNpbmcgYSBwcm9ibGVtIHRoYXQgSSBhbSBub3QgYWJsZSB0
byB2ZXJpZnkgcG9ydDYgdmlhIHBpbmcNCj4gPiBjb21tYW5kIGV2ZW4gdGhvdWdoIHRoZSBsaW5r
IGlzIHVwLCBwb3J0IDAvMS8yLzMvNCBhcmUgYWxsIHdvcmtzDQo+IGZpbmUNCj4gPiBieSB2ZXJp
Znlpbmcgd2l0aCBwaW5nIGNvbW1hbmQgZXhwZWN0IHBvcnQ2DQo+ID4NCj4gPiBXaGVuIEkgZ28g
dGhyb3VnaCBwb3J0IGluaXRpYWxpemF0aW9uIGNvZGUsIGEgImlmIGNvbmRpdGlvbiIgYmVsb3cN
Cj4gdGhhdCBhcmVuJ3QgaW5jbHVkZWQgcG9ydDYgaW5pdGlhbGl6YXRpb24uDQo+IA0KPiBUaGlz
IGluaXRpYWxpemF0aW9uIGlzIGZvciB0aGUgaW50ZXJuYWwgUEhZcy4gVGhleSBoYXZlIHRvIGV4
aXN0LiBFeHRlcm5hbA0KPiBQSFlzIHRoZSBzd2l0Y2ggZHJpdmVyIHNob3VsZCBub3QgYXNzdW1l
IGV4aXN0LiBZb3Ugbm9ybWFsbHkgY29ubmVjdA0KPiB0byB0aGUgQ1BVIGRpcmVjdGx5LCBub3Qg
dmlhIGJhY2sgdG8gYmFjayBQSFlzLiBBbnkgdGhlcmUgY291bGQgYmUNCj4gYm9hcmRzIHdoaWNo
IHVzZSBwb3J0IDYgZGlyZWN0IHRvIHRoZSBDUFUgd2l0aG91dCBhIFBIWS4gU28gdGhpcw0KPiBj
aGFuZ2UgYXMgaXMsIGlzIHdyb25nLg0KPiANCj4gWW91IHNob3VsZCBiZSB1c2luZyBhIHBoeS1o
YW5kbGUgaW4gRFQgZm9yIHBvcnQ2LCBvciBwb3J0NSwgdG8gaW5kaWNhdGUNCj4gaWYgYSBQSFkg
aXMgY29ubmVjdGVkIHRvIHRoZSBwb3J0LiBEbyB5b3UgaGF2ZSB0aGlzIHByb3BlcnR5Pw0KPiAN
Cj4gCSBBbmRyZXcNCg0KSSB1bmRlcnN0YW5kIGhvdyB0byB1c2UgcGh5LWhhbmRsZSBpbiBEVC4g
QnV0IGl0IHNlZW1zIERTQSBpbiBrZXJuZWwgNS4xMC55IGRvZXNuJ3Qgc3VwcG9ydCBjb25uZWN0
aW5nIHRvIGV4dGVybmFsIFBIWXMgY29ycmVjdD8NCkkgaGF2ZSBiZWVuIHN0dWR5aW5nIHBhcnNl
IERUIGNvZGUgaW4gbmV0L2RzYS9kc2EyLmMNCg0KDQoNCg0KDQo=
