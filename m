Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9890F305862
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhA0K1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 05:27:25 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235821AbhA0KZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 05:25:42 -0500
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DF928C0BC;
        Wed, 27 Jan 2021 05:25:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611743100;
        bh=DZ+Y9itjK2GLW8cHFcqMTRWiUveBzrmk3BHqwBNtqs4=; h=From:To:Date;
        b=B0tIpPML1377AmFTNqcHzV0FSxZBVcSqYeFglhuQNIB4FsdEgcQqU815axmMaPE/Z
         7s0+e/Y5yjPXR2MS6Gg2p8oYbVlcdzLWDh9D0m9hFzAz8dR341ZPift+QzQTk8zm5r
         HIoMhj0eFQ5Rur97kn/eBi5hy5akJH+GejD2SEp5MIz7S/2gawgJiV156DnEUg2c4f
         LouFavXqmJpn/ssyHc8CxKY5Yod8tzHCUBOcBvVzq/adRd4p6lDgBdcB5r5FvIJVfL
         mLb8IP/yjJGi9YlzvU+RpAy9SghIuy2PWSEMO6dnriCBdAwYfk8eHCzL8vnDgWRfl0
         /Z0xqz8gIcL0Q==
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 051A78C0B0;
        Wed, 27 Jan 2021 05:25:00 -0500 (EST)
Received: from LOUTCSGWY01.napa.ad.etn.com (loutcsgwy01.napa.ad.etn.com [151.110.126.83])
        by mail.eaton.com (Postfix) with ESMTPS;
        Wed, 27 Jan 2021 05:24:59 -0500 (EST)
Received: from USLTCSHYB01.napa.ad.etn.com (151.110.40.71) by
 LOUTCSGWY01.napa.ad.etn.com (151.110.126.83) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 27 Jan 2021 05:24:59 -0500
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 USLTCSHYB01.napa.ad.etn.com (151.110.40.71) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 27 Jan 2021 05:24:59 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.54) by
 hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 27 Jan 2021 05:24:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqFEwmd5zVpd/z3oQRm0Oo/Ii/60KnsRAzeVoY/Ftj9DxyK96pBp+PDJw9uFDR+cyTHxxLlDkhwArfA6G6iD20V+gVEOZ1k3OP0KOAvsEBAVX8MmRiEHqQeIa6t5wbetSLp+XPD9rsIN64IPNGXK/ZmuIkV0FgWDG06w3tQmRKsy/nwwVT/WJX94dWlTw0Qjc9RKSbfelrt+M91uPApZcBDWuEg9tN4qyoZiJbU9dpETwCpNcOl9LPzJTucFXe+OtbJt0m3iUP/OsQins8h+XGKQ5TMrZSLMyuMFqAd9FbiwcuOY6RvIqp3EOKEbefcvIppXncVBjagfjzN1laM02w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzFts0HL5pewtdT1xohSEjsaUumRJpWlyY9HP+Xeko4=;
 b=P9bcsjOxHm/FhDP612pl7l3DLw0ZfOkhCsQHl17fpObK58Hdy5nWVNzJflLt+pMJ/LuZKOLosbS8rQV2mWw0+0GJkvrShuHiGIStUmP0ban5zvl5xvbQEJMAHgDe5JtoNjq3ReByGQ0NLjot7UNMalXQpLBjMwpb4hPuza3l6HG/TpncP722dcmtStCpbntVyVPRdnoN7SHhrVRtfDvsNnmG9mjyseyKmRMlEmVkDM+Rx0dUqFCZEi47s8Pn4vPSiZWl9xpLP9o0ytGPJypuMqVHqYesmxi6akBeLiEHLd17GhZZ2K3VyvNm3lsbesWUB6teDBSnAGTj7HTi/VpffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzFts0HL5pewtdT1xohSEjsaUumRJpWlyY9HP+Xeko4=;
 b=SqRWVdfO5BjAVNbXYicokB8Q/jHhkaJcrdI+SWPrdmARB8VdPe8iIF/j0Go0qmuR+/uWbUG/J8cEPocMnPySIgCmzkMD9E/c7fDuWv/pA5ho/QvLF7A1xhvuw0945sqZJW4H/xCIdDN9knJSFS5sNjRJsJ/V60Fd4dpCK4HrtR0=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MW3PR17MB4236.namprd17.prod.outlook.com (2603:10b6:303:46::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 10:24:58 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 10:24:58 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL]  Re: [PATCH v2 net 1/1] net: fec: Fix temporary RMII
 clock reset on link up
Thread-Topic: [EXTERNAL]  Re: [PATCH v2 net 1/1] net: fec: Fix temporary RMII
 clock reset on link up
Thread-Index: AQHW8wIDc3vCXXYgKECvbNxaXxF7zao6wVyAgACFjWA=
Date:   Wed, 27 Jan 2021 10:24:57 +0000
Message-ID: <MW4PR17MB4243B47991FB151DBC4CB0AADFBB9@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <20210125100745.5090-1-laurentbadel@eaton.com>
        <20210125100745.5090-2-laurentbadel@eaton.com>
 <20210126182533.17ab52a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126182533.17ab52a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4916ea90-1406-4548-d0ec-08d8c2adcc02
x-ms-traffictypediagnostic: MW3PR17MB4236:
x-microsoft-antispam-prvs: <MW3PR17MB42368C84C1BBC35009C9C3A1DFBB9@MW3PR17MB4236.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trneCLDoaKERu6/Ow7aIWudZdLksEf9F0cXSkiLKRdf4trSukaaYTE1rz7TLH3lxoaADgDXcfxFlnU7kCuhoqJdack/Vvp3zp5wKppEF8onsSc1HmHRoPwdKWP+JnUlUzvxOqP9LfL8cdyZP6K6tdslrwX3sf0Axt8fx5/PTGJJgIJDZxPNMVM3PC3D7M2sJI5mzbX1pLp9LLsrZhaeD07HM2P8Nyc4yMHxoU9q7HQsfMm+bRkKqln5YItmGhkAkMHL5afOT4TPWDfMhD50qlAeabna7mFVELVALYmWwkRY7dzjr9HaJj6ZkrfUl/kB4VMYjujary29UelnMVp81hMK++C49St4eyIp3iLToSA2w0hMgA0vL7LCp3M0H2OtmuJsOcs6/UYXFC5rC5Ki7MVWDoceV3Q5YKSdrxvdSY4zYhJ4zx3zUd9VkXFmcgvHqpvMWsGPmig41BvwmVTK+JxYwiqHW88WdeDKkBeZMpz6tdUJ0S4gWzfAGN8mZR6RR3dgY/Ukp4ZrOGD2L5wPBsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(366004)(346002)(396003)(4744005)(64756008)(52536014)(8676002)(8936002)(71200400001)(54906003)(316002)(66556008)(6916009)(76116006)(55016002)(7696005)(33656002)(66476007)(66946007)(478600001)(5660300002)(2906002)(26005)(6506007)(4326008)(86362001)(9686003)(66446008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K1dhVmVyV25ZSWpTQXZXcFRCaUU2ak1kSDhOeU1XZ3lmQ29yWE5KNWs1TThm?=
 =?utf-8?B?ZlJESmhGcWJMWEpPQWFmWm5BNUN6bDM5QkFvczhYemtpakVXdlNuRG5kZUsr?=
 =?utf-8?B?dVJjTHNVMjRLS09XUFBPTjc2UjI1dk52YldKVEJySTZaMW04d2ZMakEzZytl?=
 =?utf-8?B?cEJxVElBS3JsemFpeTNZNGJNbmI5eWR1WU5YL3Q3VjRuemFNUVhDWmprM0k0?=
 =?utf-8?B?RXZSOGV3MWVYbXVmQjE3R084dHBjbGlyNUhaUW9vK3BrVUNBV0ljVm45SWYr?=
 =?utf-8?B?QnBMT0tJeStEa2x0clp3YkgwQUZQSEtZZDM0TW5KNlArNmtPT1YxSXJGRnpw?=
 =?utf-8?B?cGlpQ1ZGek1uNElkRm5EVElsVVN4NnJFOGNPKzFYZCtqdnhUY09obVcrbXRK?=
 =?utf-8?B?Q1g5L2MrRlZEelliRitPaGxjYXZtVnNwQ0pkRnBDYVoxTjA4eFdRT2pIVGVL?=
 =?utf-8?B?V1UxRm4waGtYWlg3VWluSmxjeXpJMDJzb3BLcmxsbFhHYmUyL3dsL2J0Zytr?=
 =?utf-8?B?ODZIUTcyNEJoa3czamVPSXQzMjhoWXZZVnFhQlZEMXRHWUJCdlNjNkVxVUQy?=
 =?utf-8?B?a3RxOTY1YkJDZmZpQTZnOWNUWjBwQnlMOGZ3RWwzb2JLOTN1b2JSQlFwbVNv?=
 =?utf-8?B?eU1Za1NhODdCR2p4WWhhMGdGK1A4ME5EV2c1RklRUGI5OUcrTm4rbStsQUlS?=
 =?utf-8?B?RC9ubGc3eFQ3SWg5cTlYUmUxQ2xCYWxXaldzQ0RpRDVQVEI2MUgweGRjSmtB?=
 =?utf-8?B?TmJKd0NYaDg0UmNqTms2TzBNWDl4WkswTEtQb0hyZGtSaFhxemdjWTdleUtT?=
 =?utf-8?B?VFR0T08zOWRxdDRVZzgyOU9LK2kvYzNFWm9ROW42c3NtL2RhbVNYeWNsc2NR?=
 =?utf-8?B?NFNPZDdQeUlod3FKMGtlR0JMWC92WHM0ME84QlFOM0V1N0VQS0J2cDArSlVz?=
 =?utf-8?B?aGhwZXRUTEZQSE1TczEvaGtWK3JOM0dEaVl2WWZrMFNkeE5rQnFzTEpXTjBJ?=
 =?utf-8?B?eHgxbnRzekdrZlE5cWplSllJSDcwNktJZTJ6bmhtTlVCNmM1WkIyQ21LZENY?=
 =?utf-8?B?TEJuYVAvVEZnUGYxTmROMVBVeVptbmdtOFgvRkNsd3ZMOTFrejhab083dVhI?=
 =?utf-8?B?VitTSGRFUlh4QTQrK21BUFNxVFJuejZlbEhGSEt0UXg3ZjhFYWZHbDVKK21M?=
 =?utf-8?B?R1IxQVBvbUVnbUZOSUdyQmNJZTZMK2ZQM0hkUWFSQTlObG5iOVRRRlhhSlkz?=
 =?utf-8?B?eTZFVmtZTUJONVRzZHRSd01Qa2JUV3dJQnVxdm1aeXBoQTU0UWdCLzJmTTlL?=
 =?utf-8?B?dTNqVm81S0RSMElNTUI3TUpWWW9FOElkS1BKZkh0aTlCbVFEZzJvWDYvWGli?=
 =?utf-8?B?ZTdWdUtKTVBJRDYxRnBWM01wVnptMlFVTmdsZk5FREY4QTk5ZWJreG40SnNT?=
 =?utf-8?Q?j9vdSQUq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4916ea90-1406-4548-d0ec-08d8c2adcc02
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 10:24:57.9488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GJSficC3TdRuNgvO86kAl7nmIqJHYfx8gFOSPg7nyKSXrNIR+cTAWrWpUBHbOTOWOIWiVTAWzN7Zbaxjx/UFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR17MB4236
X-TM-SNTS-SMTP: 9125F24BF4221D38DD57375D090A8083FBD385367C0504CAC0CD03CFFFA94BA32002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25936.006
X-TM-AS-Result: No--9.673-7.0-31-10
X-imss-scan-details: No--9.673-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25936.006
X-TMASE-Result: 10--9.673300-10.000000
X-TMASE-MatchedRID: Hlniglu/aYEpwNTiG5IsEldOi7IJyXyIPbO0S2sWaK0TeUeU5use5ij5
        3aEB5qDLJToVEF/Ob17gmadShMgim45gaMLi/XC9GUlF/M3Dxp9rLj3DxYBIN7cIt210bWgItPZ
        0go2hmmlVQLiPMNKd7WkEGYrzm1Uj+TGxWusieHLGSzOfy00X/6bwyy5bAB/9OnFMcXDYidL+Q0
        dyYkTNtlt1cL6hCLycV1uoDPGLPAhC/bXMk2XQLDuqcwBkQZRc2bNx1HEv7HAqtq5d3cxkNWmpw
        8KAb0f6OeBTwk+Bi7AFl0n/AUZJBnwbcdJesJk/iCztt6MGY7PAvpLE+mvX8g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/PiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEphbnVhcnkgMjcsIDIwMjEgMzoyNiBBTQ0KPiA+IFBIWSBwb2xsaW5nIG1vZGUuIFNp
bmNlIGFzIHBlciBJRUVFODAyLjExIHRoZSBjcml0ZXJpYSBmb3IgbGluaw0KPiB2YWxpZGl0eQ0K
PiANCj4gSSB0aGluayB5b3UgbWVhbnQgODAyLjMsIGZpeGVkIHRoYXQgdXAgYW5kIGFwcGxpZWQs
IHRoYW5rcyENCj4gDQoNCllvdSBhcmUgcmlnaHQsIEkgZ290IGNvbmZ1c2VkLiANClRoYW5rIHlv
dSBmb3IgeW91ciBwYXRpZW5jZSwgSSBhbSBvbmx5IGJlZ2lubmluZyB0byB1bmRlcnN0YW5kIGhv
dyB0aGluZ3Mgc2hvdWxkIGJlLCBhbmQgc2hvdWxkIG5vdCBiZSwgZG9uZSwgYnV0IGhvcGVmdWxs
eSBJJ2xsIGdldCB0aGVyZSBzb21lZGF5LiANCkJlc3QgcmVnYXJkcywNCkxhdXJlbnQNCg0KDQot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KRWF0b24gSW5kdXN0cmllcyBNYW51ZmFjdHVy
aW5nIEdtYkggfiBSZWdpc3RlcmVkIHBsYWNlIG9mIGJ1c2luZXNzOiBSb3V0ZSBkZSBsYSBMb25n
ZXJhaWUgNywgMTExMCwgTW9yZ2VzLCBTd2l0emVybGFuZCANCg0KLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCg0K
