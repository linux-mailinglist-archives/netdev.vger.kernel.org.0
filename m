Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D88478366
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhLQCyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:54:05 -0500
Received: from mswout.fic.com.tw ([60.251.164.98]:56676 "EHLO
        mswout.fic.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLQCyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 21:54:04 -0500
Received: from spam.fic.com.tw (unknown [10.1.1.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mswout.fic.com.tw (Postfix) with ESMTPS id A7D55C022A;
        Fri, 17 Dec 2021 10:54:02 +0800 (CST)
Received: from TPEX2.fic.com.tw (TPEX2.fic.com.tw [10.1.1.106])
        by spam.fic.com.tw with ESMTP id 1BH2kJIF043758;
        Fri, 17 Dec 2021 10:46:23 +0800 (+08)
        (envelope-from KARL_TSOU@UBIQCONN.COM)
Received: from TPEX2.fic.com.tw (10.1.1.106) by TPEX2.fic.com.tw (10.1.1.106)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 10:53:17 +0800
Received: from TPEDGE1.fic.com.tw (10.1.100.44) by TPEX2.fic.com.tw
 (10.1.1.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 17 Dec 2021 10:53:17 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (104.47.26.107)
 by mailedge.fic.com.tw (10.1.100.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.17; Fri, 17 Dec 2021 10:50:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqIGS+oL+2uu1R+bWA+1OvG529d8dzt0ab/Lj+3cGfFcZJxERUJHaJF342kZhBnecF2GP0qukBGfwdRr9bIiAzdVQ1K1IW3xiRG4ytxUdxtvZAJlbtR8CKcwoI9pwq3XgOeT6X0Jj8dDxZcKjSRnsDmTlrYYI0nkx7ETkG02dR6U+lfcBywvspBwATD7WUxwenUbYPlv243a+8kIgJwhpNIhC+/JOoRmqUo1yWWq81S8bOxDi5WKOleZShxzSUX16k/9OrATILpNoKlbOknigdWLPmJUDv5900qxstXKGfj/zK1sUJzrLf56ccX6PFdbIZXo7B63x+LqnDN273/cTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsN8Az95Dslqs31vzI/CG5puj6zsPxFAVp4JwT6nY/A=;
 b=VagD+N3Mb7RIJv7Q0eaNHubhXfSQnNE4JPvQiR7pPu5HYZFhO6Knxthez8aGiMiWzxeY3I46zn8I1azoHAjW+4esTJ8zmsB3AjvYG3Mp6hjkROE6vaFWZOqQ2TYsa6ZFv50e4Sag/j+YuEaDsyXi4+Wrb3wd+u+cQxjoxKoYFAwHlNnVw65L2iSFmOLnFBbX4J34fRhqamj1GUkhmS1mP4znfE78s3yZ1GxVZNjXvgbtCs6N4xvSUsghhUzZsVvpOJx2ebqS6kdmX+lbQo8IRllqzwTSXTIa/dt8FwCmXn3ioR3FWjgAlAJ97ueO0yhoiyhanbvONeLFJkl/FNApGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ubiqconn.com; dmarc=pass action=none header.from=ubiqconn.com;
 dkim=pass header.d=ubiqconn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fico365.onmicrosoft.com; s=selector1-fico365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsN8Az95Dslqs31vzI/CG5puj6zsPxFAVp4JwT6nY/A=;
 b=HS1P7rmzoeyfIpIvXKlCK5tU2jdxCFe9R3/Ct8194Jwrb5ersSNgjno5Q4K+fKfjhF+hmIGfuJ0myk306C0fS06guK214FX/+//7NGdpeDkO1ypnyF/yoJniSOg5QVwXpbiMS0R+gnk8NETqslSruVSXV8J5ayMLjYrJkZBGHVM=
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com (2603:1096:202:28::11)
 by SG2PR03MB3594.apcprd03.prod.outlook.com (2603:1096:4:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 02:53:15 +0000
Received: from HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91]) by HK2PR03MB4307.apcprd03.prod.outlook.com
 ([fe80::8580:1c23:e8de:ba91%4]) with mapi id 15.20.4823.008; Fri, 17 Dec 2021
 02:53:15 +0000
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
Subject: Re: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Topic: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Thread-Index: AQHX8lxFF5ETxF22rUqK34URMx0EUKw052iAgAEU/Gc=
Date:   Fri, 17 Dec 2021 02:53:15 +0000
Message-ID: <HK2PR03MB430766D15AD96E3F0E52A3D3E0789@HK2PR03MB4307.apcprd03.prod.outlook.com>
References: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
 <YbsSHSmxrZZ4jhvD@lunn.ch>
In-Reply-To: <YbsSHSmxrZZ4jhvD@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 70b9ccc3-dae4-e634-144b-bd90775b255d
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=UBIQCONN.COM;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de9f3e1e-2912-4633-1f0b-08d9c1085f5e
x-ms-traffictypediagnostic: SG2PR03MB3594:EE_
x-microsoft-antispam-prvs: <SG2PR03MB35948318F11CADEE5003AB82E0789@SG2PR03MB3594.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ZuXMNTA9I3Rk8tRCZO/s76BePXOy7lHUOkcFMI0grdDveqRjXciApajW0VqpoN0VUagaOLwR/DRfRZ2k2hPmkPychIOGrZL6juzqY+5J4nkehN+UUZ4Ig9BzOB+y3pmJrxZPc7KDrLqeh321okGI/2ma7MMk6fRnWMHHt++BPo65McCp3NgnbGT/s1pUYFD+qUK2Ge4dsxw6h7ThMUGrq2SPeKf87eLw6w3E4QAPMeH8TF82ljhFa2MneyNbg8vdxAclvBEiUztfrj+6vTZ7mGklNf4HICirOVWg0lTNWhIHQFqSV00aQijdiyMBGSCp1M9qvO1cx2VC63+Qy1ipQS6fNOTSVRMol40sKb+a4oVdkqb7B1xDhEfBs6nc0XW92EDivrNOW0HMMY9tVe2/o88sk/dbjNl5fK9xgC13+cTOrT1CoKJhSYUFcxf2NXKUQMXIBd+C9uE5Pfxl7CweXOlRUsHb3ty6ShhLqSOe89OEvB6FKBXfHfdzGPIoevncKwn0B3Vz/3i2v27yDl8LwSJkUF9viWUPBIEYnCtCfBCMgESY3/pcWlY2iuOrW4oYF9v+rOyQo8rUzHFUyrTgDI7/mn68h/IT2xLscBQWczuQAYsOlHIEI1WlvFQXd6WKHdbDb04nxeYCxNJ+E4ZW9NljSfqSPYPfcyfJrX+ajDeOe6ZiwamEvaMRCqGiq4fUys8FAhk6F5H4zOA4HG6UnJXiM8UsuNsF0SlofVahqOXwZ92HdG88z4CAavuM8VD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR03MB4307.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(52536014)(7696005)(55016003)(316002)(508600001)(5660300002)(33656002)(6506007)(85182001)(53546011)(9686003)(71200400001)(83380400001)(66946007)(26005)(186003)(54906003)(64756008)(38070700005)(66556008)(66446008)(66476007)(8676002)(8936002)(4326008)(122000001)(91956017)(6916009)(2906002)(38100700002)(76116006)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlRWdDVpeW1mbWlPRFhaR0Z5THhFdXlrQzYwb2phd0FCbGUzQ3BXYTFUWW11?=
 =?utf-8?B?TFI2MkorRCtJU2s1amZ2Q3VsTUpvSUtOcTR1OVptR0YrSmwwbFNFalV6bEtG?=
 =?utf-8?B?VDI3TGJnYko1alZBeGpJOG9ITHlKeDlyTmRZU2JlV21BelRjeHkrOVhjbTg2?=
 =?utf-8?B?Rm1WU2ZiRnQ3R1MvSkVNb2hXT1RobjI1RklqM0VCMGIvckZpUDYyMW85MHJh?=
 =?utf-8?B?VXBUQ2lyM29VSFhZeUNSTlFiWFFjNWJlaGphTElOQUtTSHRxb2VyaEhMNGwv?=
 =?utf-8?B?eDlkdFRjYmxrNHVvRHpPTFBKYnBNTVBwZkJPT2JQNWszY21JZ1hlOS9KdXdj?=
 =?utf-8?B?VnNlL1RhVHN4aGpQQ24rNXU5TWdsNmUxZWEyaW1Ca2NoVUJ0VHl2cjJ3NDBt?=
 =?utf-8?B?bzFjRGZwN3IrYkZqZmU5RFFIdGt1dStEeDgrSGxURGxvVWhwUzdtSEdUbGx5?=
 =?utf-8?B?SVUwQVd5S1QySEVjZ3BEVit0OFZIdElIVUUrUm1KeTE0eSs0SDN6aVpHbHlM?=
 =?utf-8?B?eUhkQitYSzBQdjRRYnNMNlZqMWpiMFBYUGY1RTcwNWlpazc4RzJGMXVyZnhm?=
 =?utf-8?B?a2YxeUkvdzdtalE2dXJHMmhXSkkrODZZV04zMTVGa2tpUVdSTlV6dlJPdUlZ?=
 =?utf-8?B?WFBSdjZjOUdKcHd0MEVuWjFhWlU3ODdYbzYzYTVlVzU3MTdtS1k5ZFE2b1V3?=
 =?utf-8?B?ZHB1L1ZuM1duNGhvYmtIdXhhRXBUUDV5bGNCVm9nWlhZME8vU2tRKzJicU42?=
 =?utf-8?B?Sk9QM3JmUzdvZWZXM0FtMUFsOUw3bWsyY0U4bHRjMHYyWlNzZ0x5WG9tVlZ4?=
 =?utf-8?B?N0hhdkNubWZ6K0U3ek93MUZpdjAveUVnYzJsVTljM1ZvKzRrZytkU1lWTjM4?=
 =?utf-8?B?clNyMHdsSFdVNjEwUXZDK3NiakxaWFV2OTlyMEtFV2NYbFR1ZElaK0JGeDRH?=
 =?utf-8?B?QUE3Rm5keE5EVVd6b2RRVFFRYlhvSi81MUpTZkdlTnlmZlUxZmRJZlk4UzBI?=
 =?utf-8?B?V3QxdEJTdDcyZ0RkcjlORG9aejByU0wxZXgvWDl0MUVyUUU4T2F4aHlVVDAv?=
 =?utf-8?B?bll5a0NGREpMWXl6NzNJdHVYekRBV3prK1R2eFRXOFJpMCtpYUZzZlgwMllq?=
 =?utf-8?B?T3ZibnA3NVgrZVVodzlERStoZStiMG5OUXh2WUdVUE92R2MwK2NWOFVqUFRr?=
 =?utf-8?B?Y21Fa1pQTlhwUVF6c01Mbzd4WXJJN1ZtRkpHMGJBaHZpbUNFb2NQR3ZvNjEx?=
 =?utf-8?B?ek8rbzhPdDFEdWFpNktjOE9pVnRhWGhGcWRwKyt3TVBteGNUOFhMb202L3M1?=
 =?utf-8?B?YW5WQTZUR095cUY3cWZNeW8wTVh6c0czR2dseUlXR1hpNDh1bWNySERFL1lh?=
 =?utf-8?B?U1F0NkFQazZJQVpQZmVVWDYxdmYyNTQ1Q2xkSUk5SkpwekZGSXY5MFRwczNV?=
 =?utf-8?B?emh0SXVjS3E2Kzk0YXEwem95c2EvdFhBdXUxSWR4VTNJZGc4Nml0ZnRuRTVs?=
 =?utf-8?B?a0xZUWx2R3pZd3lYMUVOMGtxTGQ2b2RlK1lxYjdOYVF2emNreDc0c2JlWERD?=
 =?utf-8?B?SFF5RWpkVzM4SWVGY21GblgveHJnL1BKQ0wwdktUOCsza1RMUitNRXdubDFr?=
 =?utf-8?B?L3hnZFBJS2M4cTk3d3MyalVEY0pCSmNZK3BDaUFMNTFoNUFIOCtFUTBPNVl1?=
 =?utf-8?B?dysvWDlRVmFOOS9PRFVDSFEyM2liTGltdG5DVkZhblZLb01LNStLZm1jUGJB?=
 =?utf-8?B?S1hwdFo1WGh0Zm4vOEx5emZlbjRUdDhWWEM0cU1ubm8wM1cxV21YR1VDdVdO?=
 =?utf-8?B?TkVQdmxzOUd6VGcvWlFIQXFFaGVWYU8xdFVlMjVHWTNTclNJTWxHenQzZnIz?=
 =?utf-8?B?YXBQaWhPb3oySkdoLys4eFFlT1p1NklVWTROM3Nmc08xL3k2UHpmUFVLcXpK?=
 =?utf-8?B?aHI1bjZyMTVwRGhHc3dXaG9BZUg4WHVmT1dWRE1VbklOWHVrNHRlcGlDQ0pZ?=
 =?utf-8?B?d29RUGgyTlNnbGVscDRaTVkvbk5xSnR0dlNYaTU0MUd1ZUdtTjhEeHQvR2V5?=
 =?utf-8?B?WWFpQW9ibUZuNGwwejJWZnpDRWlDYzJRckdBcUZGNmdVQVlrQS81Mm1PTkQ4?=
 =?utf-8?B?Umh2WWZlakZDR05wNStJTUIrZWRSSFBmMnUxMFQwelE3Ty9DeHJpVWNFVTFL?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR03MB4307.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9f3e1e-2912-4633-1f0b-08d9c1085f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 02:53:15.2601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 767e8d94-d5f3-412e-b9e8-50323cd2c43c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqeiups4SGCEQYXTAn0B+ReSrAi5WSBC1BqWu6QoHrhqE8QPYD7ngRfuzGCLFHhhyras13P1F/zu/aeZ83lN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB3594
X-OriginatorOrg: ubiqconn.com
X-DNSRBL: 
X-MAIL: spam.fic.com.tw 1BH2kJIF043758
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIE1pY3JvY2hpcCBzd2l0Y2gga3N6OTg5NyBzdXBwb3J0IDcgcGh5c2ljYWwgcG9ydCwgcG9y
dCAwLzEvMi8zLzQgY29ubmVjdCB0byBzdGFuZGFyZCBSSjQ1LCBwb3J0NSBjb25uZWN0IHRvIFBI
WSB2aWEgTUlJIHRvIENQVSBhbmQgcG9ydDYgY29ubmVjdCB0byBQSFkgdmlhIFJNSUkgKFBIWSBr
c3o4MDgxKSBvbiBteSBjdXN0b20gYm9hcmQuCgpJIGFtIGZhY2luZyBhIHByb2JsZW0gdGhhdCBJ
IGFtIG5vdCBhYmxlIHRvIHZlcmlmeSBwb3J0NiB2aWEgcGluZyBjb21tYW5kIGV2ZW4gdGhvdWdo
IHRoZSBsaW5rIGlzIHVwLCBwb3J0IDAvMS8yLzMvNCBhcmUgYWxsIHdvcmtzIGZpbmUgYnkgdmVy
aWZ5aW5nIHdpdGggcGluZyBjb21tYW5kIGV4cGVjdCBwb3J0NgoKV2hlbiBJIGdvIHRocm91Z2gg
cG9ydCBpbml0aWFsaXphdGlvbiBjb2RlLCBhICJpZiBjb25kaXRpb24iIGJlbG93IHRoYXQgYXJl
bid0IGluY2x1ZGVkIHBvcnQ2IGluaXRpYWxpemF0aW9uLgoKZGV2LT5waHlfcG9ydF9jbnQgPSA1
CgojIFRoaXMgYWxsb3dzIHBvcnQgMC8xLzIvMy80IGJ1dCBub3QgNgppZiAocG9ydCA8IGRldi0+
cGh5X3BvcnRfY250KQoKIyBBZGQgb25lIG1vcmUgY29uZGl0aW9uIGlmIHBvcnQgaXMgbm90IGNw
dSBwb3J0CmlmIChwb3J0IDwgZGV2LT5waHlfcG9ydF9jbnQgfHwgIWNwdV9wb3J0KQoKIyBBZGQg
YSBpZiBjb25kaXRpb24gY2hlY2tpbmcgYW5kIHVwZGF0aW5nIGZvciBzcGVjaWZpZWQgcHJvZHVj
dCBhbmQgcG9ydCBudW1iZXIKaWYgKGRldi0+Y2hpcF9pZCA9PSAweDAwOTg5NzAwICYmIGkgPT0g
NikKClRoYW5rcwotS2FybAoKCkZyb206IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4KU2Vu
dDogVGh1cnNkYXksIERlY2VtYmVyIDE2LCAyMDIxIDY6MTcgUE0KVG86IEtBUkxfVFNPVSAo6YSS
56OKKSA8S0FSTF9UU09VQFVCSVFDT05OLkNPTT4KQ2M6IHdvb2p1bmcuaHVoQG1pY3JvY2hpcC5j
b20gPHdvb2p1bmcuaHVoQG1pY3JvY2hpcC5jb20+OyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAu
Y29tIDxVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tPjsgdml2aWVuLmRpZGVsb3RAZ21haWwu
Y29tIDx2aXZpZW4uZGlkZWxvdEBnbWFpbC5jb20+OyBmLmZhaW5lbGxpQGdtYWlsLmNvbSA8Zi5m
YWluZWxsaUBnbWFpbC5jb20+OyBvbHRlYW52QGdtYWlsLmNvbSA8b2x0ZWFudkBnbWFpbC5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0IDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsga3ViYUBrZXJuZWwu
b3JnIDxrdWJhQGtlcm5lbC5vcmc+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnIDxuZXRkZXZAdmdl
ci5rZXJuZWwub3JnPgpTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IGRzYTogbWljcm9jaGlwOiBB
ZGQgc3VwcG9ydGVkIGtzejk4OTcgcG9ydDYgCsKgCk9uIFRodSwgRGVjIDE2LCAyMDIxIGF0IDA5
OjI0OjEzQU0gKzAwMDAsIEtBUkxfVFNPVSAo6YSS56OKKSB3cm90ZToKPiBUaGlzIGZpeCBkcml2
ZXIga3N6OTg5NyBwb3J0NiB3aXRoIFBIWSBrc3o4MDgxIGJ5IGhhcmR3YXJlIHNldHVwCgpQbGVh
c2UgZXhwbGFpbiBpbiBtb3JlIGRldGFpbHMgd2hhdCB0aGUgcHJvYmxlbSBpcyB5b3UgYXJlIGZp
eGluZy4gSXQKaXMgbm90IGNsZWFyIGZyb20gdGhlIGNvZGUuCgrCoMKgIFRoYW5rcwrCoMKgwqDC
oMKgwqDCoCBBbmRyZXc=
