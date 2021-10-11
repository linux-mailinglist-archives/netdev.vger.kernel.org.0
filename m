Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D6C4289DB
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhJKJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 05:44:00 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:39523 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhJKJn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 05:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633945320; x=1665481320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VOwS+/vUW0iNufKOD6hxd2bpwCF3srzvAoeKa1R1Cxs=;
  b=KJiM4iZ/O0grutA6lkRhCxsqCZ9nm40osX1gmITSAhNB+iHpG4B0DPGn
   VLNP3xaaXG4bQoTVVgUZRiRK8sy5EbQtTtj2dmwkSnu7a01GM1nzGAaoV
   9A8dCFPpMmRM1GA4TB1HpbdjbGabq383W7eJrg15WzW9xcnu4trQmjwgr
   U4qy2FKu9jrdPzCYJGgSYdzUaQd2QpWwboBr/HHJvR0HgrN81B5UcMNZj
   gkcLQX8wGvwniNxvr6oETyXnawd7DXB+mhXfcwTQbo9wmdvjgoqEDRt14
   +OatJtXx29bVv8ZGWkeI1UFmafdPd5WGW5YvLK6lKDwkYQ+A3nl5/z/S1
   w==;
IronPort-SDR: l3JLoVLcZXTd0Y+yW0pOAN/4pV8MXDI+bjnSHBNE/GNfk5M4Q3ZoZvT9Ob/bNuY7ZbViu0+6kq
 rk1VaczLQ6cDbicYZTbe1cfk+eC45AxwjHYyihvXk0RbmNrFGkTKb9vLrWvZKMhnJwek3ZPIG6
 bvibuQDuoZ77uU8byGEwJHxE6SreNN5zd2durt8wc6CLOb2TpjPIHZzSUY4cuQiZqEix3Mp1HD
 hTi7ERZ1r/S+SHYNXUWMmGOP9Ec7Lrf6I/YykOempfUZw1oJR4KTH8pWoUEAuzlPTwATvNzyxY
 /SOBMecKHW2oSk1sRegGCiXA
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="135048091"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2021 02:41:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 11 Oct 2021 02:41:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Mon, 11 Oct 2021 02:41:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv7qjZTj4UmgYL3eJffbKbBMujKKkCnojx5+tV9WZRnoNFX7BvtZBN7T6k24bGNtOBt+cagJv9kQ9IWuygcsJNOhYHY2r9HqvKnIE7+L9gHCU/YTpt5MLndbvuy7vbYZtRU4OCdgARcsYNpPwMYNMMxPacVp8pawWxr9ix4khwa61+MTkrmSj8pV6QTGJNpUHa0mhYq7q4oDxZqgQbKYdXrV9lWU+LVKtbnYwjmvZROXVSbH3dUBPkXf7FQ4bHe1pVsM+MJM8ox20Jci0zj/1uxi+x3hHwTywhZFYSaaC4U6Q6M+rcvrZ4zY+ujpD88Y2Prr43jfeMb8LYHkiFGPfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOwS+/vUW0iNufKOD6hxd2bpwCF3srzvAoeKa1R1Cxs=;
 b=jC8m840AyGgdHI3NWnfxcOBAM4Z0N0kizJ+tecdXuhAOB9Vu+X5c1ENfatID3JN9G66UEQccWbvypSXXndLWYFFtA/oIZ3g4m4h+iq7E64De2LyTna7JfBNH/fw+7yiXXZEDHUvbKBCxzZPXLEH/tguhWtkCe/JNDDEtI2+lBF/JnDI+hcx1oCJhapWScBPN3VmJoSsc2covwBPzgKMYWlFNvolgxupXHZem3Uji9gcEssqm5pShkCw0zjUgyb0ROPJ7ypCBHfUUucuHuVIv8a0VzsTlQXnw5KImcE1BsOOZDnpKxQqw6BXmFMpSt+q3edkegVzSt0K3GwaE20EUtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOwS+/vUW0iNufKOD6hxd2bpwCF3srzvAoeKa1R1Cxs=;
 b=BCdWbyQ42UJaZi1TkFtv9+iFL68qmx7a0dyxkQ0y0PUXh77NoaYfj86aGKNEfa9aYbaaDIWE0zZkenJC3WmEmrxU0HJU62cyPiB8v8u0tb396sv0X0auI17xMmbKrJl3QgNBKBYxH9rwpT+3hHp4rkXT6uy2mBJRGlNEMrXyxFw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB2651.namprd11.prod.outlook.com (2603:10b6:5:c6::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Mon, 11 Oct 2021 09:41:55 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::6407:af1e:1d6e:5fe]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::6407:af1e:1d6e:5fe%7]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 09:41:55 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <kuba@kernel.org>, <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <linux-kernel@vger.kernel.org>,
        <george.mccollister@gmail.com>, <vivien.didelot@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
Thread-Topic: [PATCH net] net: dsa: microchip: Added the condition for
 scheduling ksz_mib_read_work
Thread-Index: AQHXvCCnkzXGFHZoKEuIrMeVE1ikDavJINMAgABNDQCABCJQgA==
Date:   Mon, 11 Oct 2021 09:41:55 +0000
Message-ID: <601a427d9d73ef7aa85e50770cce38ecd6e84463.camel@microchip.com>
References: <20211008084348.7306-1-arun.ramadoss@microchip.com>
         <YWBOeP3dHFbEdg8w@lunn.ch>
         <20211008113402.0aed1d2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008113402.0aed1d2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7538890a-14d7-4435-dd92-08d98c9b5cef
x-ms-traffictypediagnostic: DM6PR11MB2651:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB265154FA3CD937FCD6B74174EFB59@DM6PR11MB2651.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MBH/2+oDfkrqYaSMMz6MpYU+f1wdM3KFQcx4DCLZepyPMCnLtwoL2dwgIS//HlU8+xsEymhuXcVcTBeciSCUpl/8Xn19NSxJjaBoN5D2Y7EU4QCl8zvrsB5YemUWBtl4Df+q+szpqsqm0BZuL04YNB8mYq0VTOt+cYPwzp52Tr50dEs/AxLRKowPjdN6hD+jSdUKTQRavmlY2DIT0ZBKiW1drfH6M2OadnG2VPW8Aswfmu8PAOc/ZCeRdlnPxwyn14Tl9FimOBgPYjxn7jmoBmd7WDYvipMqh2PeSujn9fbSaBlCYbdGDMULSz5OttLAguxe3iROVcLIW9pk8I5sYYVEWxl70MI97Kat2xq/qOSv1g104KS7yAiwS+YlIt24frcs43RaXL+lv5YP9O1624cai6tGyKYOm10VZd5a3F1Uk4GS9d+I6GrF4FLhQufb2jJCFxu7fT2PQTj2p/UVTsVdWv7JfhCtJQXMGOYJBc3OI8CTLmyCmCdjTGi2jbLRaC821JoIMM8cnVePm+/CJUkp9c+xqKgyyixacCusCoZX1Ujku5Lz6LlDXrqOTFAnBpCCYorQpDRzMrKK1Fct8EAnzFeYDb/BTvFQKsix4IvHXpo+LareRUifEugSAfrbCnEWSQwW/zlOMBpbBju8OW+cucbMo0KLgSLcq9SbGqNz4taZIC/fVgHJ14byEvEHbDpwgppF7rmYC4DxEMjjkRgdi83l8nIDalqhhJLzhsaNj+cF2yA8yKTvf1T3bIJSGA22jOrvleGymS0JS6R9H1TxMmyI2WKQT8bvEZmXh7HjUm7e03f7Oah46NCe5QHxgWFBnEVX3XXLGAUJM0Tq/xcTph9ZP9b/5A8z05iUtik=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(2616005)(86362001)(66446008)(66556008)(64756008)(4326008)(38100700002)(122000001)(66946007)(508600001)(66476007)(91956017)(76116006)(966005)(2906002)(38070700005)(36756003)(6512007)(186003)(26005)(6486002)(316002)(8676002)(8936002)(5660300002)(110136005)(54906003)(6506007)(71200400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVJabW1xZmJBUUE3OUtJazA0S1JUbWRGREpHWXNsWjZQMGNVR0ZLcUNIa2s2?=
 =?utf-8?B?bCtEMkdqRWswTHVCZWRaU2xmMmtuT0MyZ0QrajJicnBsRHRFSEVEUEFocFBu?=
 =?utf-8?B?RSsvbGZJc0dpV3JqWTJOT0pzQ1dyR0hSTW5Wa21XVkpDZGxKd3o0eXZXTDJF?=
 =?utf-8?B?elVwTUFtR21BOW5qQmJ5K1pSQUV5VHd5LytyMWZkV0p2N0MvcEluNko4S2cy?=
 =?utf-8?B?cjdlT3lxaDFpaXRFS3o1K2FkWjFJRnpwaUtVWkNzQmQ5TkNXTThpVnlhK3RB?=
 =?utf-8?B?MTVYd1hsS3JtNzI1OXpaV3FOam1hczFRNmVFd0dXTGw1cUpPbGZsc2VQazFE?=
 =?utf-8?B?TDNDcW96aHZyS292Q2ZiNnNPSjJwaUpjeWxqQ2s4TWJ1Vy9nR3ovYytsbmV2?=
 =?utf-8?B?d2IxcjJ5WUQ5Rk1JU1ZZTkRDSEwzbjdWSHpKbElwYnRBZVIwMnV0MTBkblJO?=
 =?utf-8?B?ajVJaVp2dXZSSDE0bXVkODFmczVTcVpOQUUzWjdTTk5DbDdlZGJFTGhlVjdK?=
 =?utf-8?B?WG9RTjBoajF4eTZqL1paQXBsSFkzNHhZS3RHSWJ6eDlSVDJpTVhTa0FUS2ww?=
 =?utf-8?B?clhUclpya3hTSGZRQnBVRVJONnRFY3Q2emdIb2xSWnZTZHRGUndmM2hDYVpm?=
 =?utf-8?B?T3dMbzU4aDdJMVV0RkpuTVpJNm1mUG84aVkzMGxZVDNvTk1FVWFwZmttS0w5?=
 =?utf-8?B?V0laQlQ3azNrOEVaaXB3Q3FuQ0hLeHJ5RVNaRkdXT0FhZkcxR3NpLzRzbUU2?=
 =?utf-8?B?R3I4bklONm0vYm0rSHhtRGhIUjcxSXhPYkd2Ty9Dd29uaXpTZTd6ZFlNb1Rn?=
 =?utf-8?B?b2t0MXBZWXdRUnFRbmVTSE16azI1cTU3bUV1MVhOSUdRVlNta2huWitEeGtZ?=
 =?utf-8?B?MkIvTGprOHg2dEpmLzI3NHB0Um5WMXkvOGlmUFRNT2lnQjBXZTdsTHdyc2Mz?=
 =?utf-8?B?UW1pb055R1NjUHArMXV6VjFKYkN2cHgzZjZmMVZJSSs1MmZDQzR6aSsxNEoz?=
 =?utf-8?B?TmdSbnczMWdzYituTUdiRkR5N3Y4dHdIYk4yYWRMeGRobzIyOGpydUVRK2Q4?=
 =?utf-8?B?V1UrM0xBbERVZXI0dVJWZ0RIbStlRW9WZ3p5LzNpZjc3b0l5OERUV3crWmR3?=
 =?utf-8?B?cW94YWQ2UTd6Tm5RZ0pJeEJNRnN1TTdxSGk5bmRRYnMrK3JhbnNITGp2em40?=
 =?utf-8?B?WHptNnVDcU9PbTNTODdJdkhXanpuYjNXckx3aG12OWU2WjlEcGxidGl3QmN2?=
 =?utf-8?B?L0R0dzRYYUZzWFhzVzlGcUNlY2pDZTc2SUZtZ0JPZGV5ZUJadTR1UngzSlVa?=
 =?utf-8?B?d0t6cFR3RDVlcXpZTWUvWFVpQmZhb1RDTlVvNjkxalA1Q0czQkZIYTlDdU9Q?=
 =?utf-8?B?aS9xeEFVcHhJWVJLTUxaRkFXYkJ1NE52aHpKNkJPQnBhaWZPMEN3MjlDK2ZF?=
 =?utf-8?B?TGZnVnAxcE96RFl3VDA0K0hKakhtcTRETk84NVNRanJYMFRyM2N4eWYzbWdE?=
 =?utf-8?B?Z09GOXp5czJEbkYxQkNGMTQ3RTFIaHNlRUNUUU9HV3lvQkxCU294M2xRVE1w?=
 =?utf-8?B?bVRBenNTYU4zR25IeW83bUpnOXh1bHZjc3FqOG5ubW1VK1UwbGs5VDJKVyt6?=
 =?utf-8?B?eXNqeDJiZVFQWVZ2TzJHZVlGU3RHSDMwTFNwSGZkUVQxNHJWT3hGc2tQcUx2?=
 =?utf-8?B?OCs5dE1MdERJZndkWDA1WDF0U1UxZFA5cnZOczJ4VlZXZDJPUjNBWldYdURE?=
 =?utf-8?Q?EO4RQ/Zrf68Iq7feJTklDl8IDpvpaAga3H2eG2h?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD09BE3772966940AFB2CA3B7A48850E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7538890a-14d7-4435-dd92-08d98c9b5cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 09:41:55.5709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WOZE9UT3YveY+CnCQ6rjHvfUf5CoxWBizDZwPQHyLzjv2WSzvJpw8+nntL1MzLHvpKtcypQpW0o008+XoZsFZrbC1iU7CcPUcQRlGTeIPn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTEwLTA4IGF0IDExOjM0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIDgg
T2N0IDIwMjEgMTU6NTg6MTYgKzAyMDAgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gT24gRnJpLCBP
Y3QgMDgsIDIwMjEgYXQgMDI6MTM6NDhQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiA+IFdoZW4gdGhlIGtzeiBtb2R1bGUgaXMgaW5zdGFsbGVkIGFuZCByZW1vdmVkIHVzaW5nIHJt
bW9kLCBrZXJuZWwNCj4gPiA+IGNyYXNoZXMNCj4gPiA+IHdpdGggbnVsbCBwb2ludGVyIGRlcmVm
ZXJyZW5jZSBlcnJvci4gRHVyaW5nIHJtbW9kLA0KPiA+ID4ga3N6X3N3aXRjaF9yZW1vdmUNCj4g
PiA+IGZ1bmN0aW9uIHRyaWVzIHRvIGNhbmNlbCB0aGUgbWliX3JlYWRfd29ya3F1ZXVlIHVzaW5n
DQo+ID4gPiBjYW5jZWxfZGVsYXllZF93b3JrX3N5bmMgcm91dGluZS4NCj4gPiA+IA0KPiA+ID4g
QXQgdGhlIGVuZCBvZiAgbWliX3JlYWRfd29ya3F1ZXVlIGV4ZWN1dGlvbiwgaXQgYWdhaW4gcmVz
Y2hlZHVsZQ0KPiA+ID4gdGhlDQo+ID4gPiB3b3JrcXVldWUgdW5jb25kaXRpb25hbGx5LiBEdWUg
dG8gd2hpY2ggcXVldWUgcmVzY2hlZHVsZWQgYWZ0ZXINCj4gPiA+IG1pYl9pbnRlcnZhbCwgZHVy
aW5nIHRoaXMgZXhlY3V0aW9uIGl0IHRyaWVzIHRvIGFjY2VzcyBkcC0+c2xhdmUuIA0KPiA+ID4g
QnV0DQo+ID4gPiB0aGUgc2xhdmUgaXMgdW5yZWdpc3RlcmVkIGluIHRoZSBrc3pfc3dpdGNoX3Jl
bW92ZSBmdW5jdGlvbi4NCj4gPiA+IEhlbmNlDQo+ID4gPiBrZXJuZWwgY3Jhc2hlcy4NCj4gPiAN
Cj4gPiBTb21ldGhpbmcgbm90IGNvcnJlY3QgaGVyZS4NCj4gPiANCj4gPiANCmh0dHBzOi8vd3d3
Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L2NvcmUtYXBpL3dvcmtxdWV1ZS5odG1sP2hpZ2hs
aWdodD1kZWxheWVkX3dvcmsjYy5jYW5jZWxfZGVsYXllZF93b3JrX3N5bmMNCj4gPiANCj4gPiBU
aGlzIGlzIGNhbmNlbF93b3JrX3N5bmMoKSBmb3IgZGVsYXllZCB3b3Jrcy4NCj4gPiANCj4gPiBh
bmQNCj4gPiANCj4gPiANCmh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L2Nv
cmUtYXBpL3dvcmtxdWV1ZS5odG1sP2hpZ2hsaWdodD1kZWxheWVkX3dvcmsjYy5jYW5jZWxfd29y
a19zeW5jDQo+ID4gDQo+ID4gVGhpcyBmdW5jdGlvbiBjYW4gYmUgdXNlZCBldmVuIGlmIHRoZSB3
b3JrIHJlLXF1ZXVlcyBpdHNlbGYgb3INCj4gPiBtaWdyYXRlcyB0byBhbm90aGVyIHdvcmtxdWV1
ZS4NCj4gPiANCj4gPiBNYXliZSB0aGUgcmVhbCBwcm9ibGVtIGlzIGEgbWlzc2luZyBjYWxsIHRv
IGRlc3Ryb3lfd29ya2VyKCk/DQo+IA0KPiBBbHNvIHRoZSBjYW5jZWxfZGVsYXllZF93b3JrX3N5
bmMoKSBpcyBzdXNwaWNpb3VzbHkgZWFybHkgaW4gdGhlDQo+IHJlbW92ZQ0KPiBmbG93LiBUaGVy
ZSBpcyBhIHNjaGVkdWxlX3dvcmsgY2FsbCBpbiBrc3pfbWFjX2xpbmtfZG93bigpIHdoaWNoIG1h
eQ0KPiBzY2hlZHVsZSB0aGUgd29yayBiYWNrIGluLiBUaGF0J2QgYWxzbyBleHBsYWluIHdoeSB0
aGUgcGF0Y2ggaGVscHMNCj4gc2luY2UNCj4ga3N6X21hY19saW5rX2Rvd24oKSBvbmx5IHNjaGVk
dWxlcyBpZiAoZGV2LT5taWJfcmVhZF9pbnRlcnZhbCkuDQpJbiB0aGlzIHBhdGNoLCBJIGRpZCB0
d28gdGhpbmdzLiBBZGRlZCB0aGUgaWYgY29uZGl0aW9uIGZvcg0KcmVzY2hlZHVsaW5nIHRoZSBx
dWV1ZSBhbmQgb3RoZXIgaXMgcmVzZXR0ZWQgdGhlIG1pYl9yZWFkX2ludGVydmFsIHRvDQp6ZXJv
Lg0KQXMgcGVyIHRoZSBjYW5jZWxfZGVsYXllZF9xdWV1ZV9zeW5jKCkgZnVuY3Rpb25hbGl0eSwg
Tm93IEkgdHJpZWQgcm1vZA0KYWZ0ZXIgcmVtb3ZpbmcgdGhlIGlmIGNvbmRpdGlvbiBmb3IgcmVz
aGVkdWxpbmcgdGhlIHF1ZXVlLGtlcm5lbCBkaWRuJ3QNCmNyYXNoLiBTbywgY29uY2x1ZGVkIHRo
YXQgaXQgaXMgbm90IHJlYXJtIGluIGtzel9taWJfcmVhZF93b3JrICBpcw0KY2F1c2luZyB0aGUg
cHJvYmxlbSBidXQgaXQgaXMgZHVlIHRvIHNjaGVkdWxpbmcgaW4gdGhlDQprc3pfbWFjX2xpbmtf
ZG93biBmdW5jdGlvbi4gVGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgZHVlIHRvIHRoZQ0KZHNhX3Vu
cmVnaXN0ZXJfc3dpdGNoLiBEdWUgdG8gcmVzZXR0aW5nIG9mIHRoZSBtaWJfcmVhZF9pbnRlcnZh
bCB0bw0KemVybyBpbiBzd2l0Y2hfcmVtb3ZlLCB0aGUgcXVldWUgaXMgbm90IHNjaGVkdWxlZCBp
biBtYWNfbGlua19kb3duLCBzbw0Ka2VybmVsIGRpZG4ndCBjcmFzaC4NCg0KQW5kIGFsc28sIGFz
IHBlciBzdWdnZXN0aW9uIG9uIGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygpIGlzDQpzdXNwaWNp
b3VzbHkgcGxhY2VkIGluIHN3aXRjaF9yZW1vdmUuIEkgdW5kbyB0aGlzIHBhdGNoLCBhbmQgdHJp
ZWQganVzdA0KYnkgbW92aW5nIHRoZSBjYW5jZWxpbmcgb2YgZGVsYXllZF93b3JrIGFmdGVyIHRo
ZSBkc2FfdW5yZWdpc3Rlcl9zd2l0Y2gNCmZ1bmN0aW9uLiBBcyBleHBlY3RlZCBkc2FfdW5yZWdp
c3Rlcl9zd2l0Y2ggY2FsbHMgdGhlDQprc3pfbWFjX2xpbmtfZG93biwgd2hpY2ggc2NoZWR1bGVz
IHRoZSBtaWJfcmVhZF93b3JrLiBOb3csIHdoZW4NCmNhbmNlbF9kZWxheWVkX3dvcmtfc3luYyBp
cyBjYWxsZWQsIGl0IGNhbmNlbHMgYWxsIHRoZSB3b3JrcXVldWUuIEFzIGENCnJlc3VsdCwgbW9k
dWxlIGlzIHJlbW92ZWQgc3VjY2Vzc2Z1bGx5IHdpdGhvdXQga2VybmVsIGNyYXNoLg0KDQpDYW4g
SSBzZW5kIHRoZSB1cGRhdGVkIHBhdGNoIGFzIHYxIG9yIG5ldyBwYXRjaCB3aXRoIHVwZGF0ZWQg
Y29tbWl0DQptZXNzYWdlIGFuZCBkZXNjcmlwdGlvbi4NCg0K
