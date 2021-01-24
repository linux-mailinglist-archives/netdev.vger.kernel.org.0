Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00761301DDE
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhAXRUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:20:06 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbhAXRT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 12:19:59 -0500
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A1B911A080;
        Sun, 24 Jan 2021 12:19:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611508757;
        bh=No5fvZ99CUMOrnywlBevevlQfHfOChJlrtKzZ2sf880=; h=From:To:Date;
        b=CNJ9OpLEuQjkCyusL8QSlYU/IrxLBNLVUfbWdThc+W3TpnM9tgNuQDqJ645+WlWIT
         McfN5o3ZLP20svpJB9+twT4xbbOrTJeWCQFgp4cruyWFUEFRwwCMFo7p8KWLcltiR0
         YDiynFASoDw8HXclmEnhVEsKqxb2RFdAMPns27kvRxvpElquw+wdTmXceXFMkgkn+I
         daU5fb2oZc20958OWbQ+idWi1n7+Vjm1Tk9MN0hemp12pHtaX04ijUBDBxo6fVF+nM
         2wE1b2YsHoOAhBzNvB7UkbexqeauKSk+q2wJuFZVabkhHLeOlN9x91tc3f9PBpviH0
         j4+z/kSK/1cXA==
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E57A911A07C;
        Sun, 24 Jan 2021 12:19:16 -0500 (EST)
Received: from SIMTCSGWY01.napa.ad.etn.com (simtcsgwy01.napa.ad.etn.com [151.110.126.183])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Sun, 24 Jan 2021 12:19:16 -0500 (EST)
Received: from SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) by
 SIMTCSGWY01.napa.ad.etn.com (151.110.126.183) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Sun, 24 Jan 2021 12:19:16 -0500
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sun, 24 Jan 2021 12:19:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Sun, 24 Jan 2021 12:19:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od8h6TWYfZRjxToNHS6/6/rDmZQwOqQap1VLmNzUGblxU1G8nKgbcGw1lKUR33SmFsW0WApGVlT3OdFXOQbmBG1OMCOgNAin1lLJPBw2Y2R9M0e9h1SJU+hKNKJKRNZ8kyx//0cyGqusTj161wq6Cful2E4bGDOP0S1vEy+/jlDTCPDwdggbDxLSNKAWNoz6oVpocGSf01XxI8oaWUQ7fByX6IqAOilR44XsyzLjwPL7R8xdaFRV3j9pEGfghhx+437jUPGfvzl0YycU68Fu10hIqMwpvpjMSZE6ePpMAd+FsAQ003M+V4IS0NQLqOh/UZ6Pe41hs7+YG/MGewR6ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrnzUDF0KjoPOmmsB1VgFwz8sLsEUzQjAgtV2SjdT9Y=;
 b=oD30SGMmvWMnHRoaKOqNDXWNiXoL8jpitN75kMUJ2lD8KTAsV166Ekmt6YUb34j652vikhPPGQ8BdQjCTBU8msE2IDGvclp2o901J71QTjmRCAym+TS+r7+VyoZ6TPdM514DPl7ewCDCZG7e6nm1LSM1TUK0BW2AL3I2TRB7GZBsYLL75Pwx2e3JkFjEUjBZgmd60EcU1Ug7fl5yIQI/aSiaYw/LNkEnAdXQJYfoA6oX96o4JnhxMAz1MwzJ0gJloC6hJMsBPMZbODbh5L+wvqBccF/BY8UPEKgpbdtefjbkJhsqleay68slOPxDaMqxXaqRfHRalHHTOUgJGgBzCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrnzUDF0KjoPOmmsB1VgFwz8sLsEUzQjAgtV2SjdT9Y=;
 b=0xj+RuThPFDI4KBSvKShO/Qqwhes0Cxl6PZwg3w/fz2KQb/Mc1TmbZywu8/6XEprex9lkNHkJvXrVOKhrA8tB+O8KZqGySP1xKOp8sjbwE2LmDBUGtjwFO6VHzj5KguJp70I5S0ZRwTRxK8AzW/NYfUlNqEl1NzITmcf8NsEHe4=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1885.namprd17.prod.outlook.com (2603:10b6:301:1d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sun, 24 Jan
 2021 17:19:13 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 17:19:12 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL]  Re: [PATCH net 1/1] net: fec: Fix temporary RMII
 clock reset on link up
Thread-Topic: [EXTERNAL]  Re: [PATCH net 1/1] net: fec: Fix temporary RMII
 clock reset on link up
Thread-Index: AQHW8NFJ2W7NxfmT+EahdlqMbNsaQao0brgAgAKZQqA=
Date:   Sun, 24 Jan 2021 17:19:12 +0000
Message-ID: <MW4PR17MB42431340BC28D1AD1D51F31CDFBE9@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <20210122151347.30417-1-laurentbadel@eaton.com>
        <20210122151347.30417-2-laurentbadel@eaton.com>
 <20210122173632.25db0d09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122173632.25db0d09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4615ef32-9c69-4c56-0868-08d8c08c2b6b
x-ms-traffictypediagnostic: MWHPR1701MB1885:
x-microsoft-antispam-prvs: <MWHPR1701MB1885CB99F30A168DAEDDEF35DFBE9@MWHPR1701MB1885.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D4nuRWBz365DkEy72XGFPiU6Q0YwlXxUB26Vmn1TUDGIPdcCdUKyp4FWqeQ39LX31/5C6MDRr7UsBIwEwiz5OzRsxnBV5ZZBOcUAODi9imez/xkhRJ+Kk7qsLkBhcpfTugyug5OTyfTSwwYhqKtZ80n+ndu2CgsRERDbHh31pQ9OUHYbcAc8xQ+sKRs5BG5CwYo9B0fRtRmm7xiyKPCJU2ZDljhTE+SjDCKOV129Q5A/qrEikqvsnUZOHhCNy4RnM9aehgEhhqbYIByX0Z0xUdqnH4i2QRiRYN8RImVfl5U2r1FWg4djsLVcuUaIKMPgM1nqWFSgXcqFKfG7S1uxfFmv7GvMmi0ySuimVd9/qmna6fboczyRb6hccTJyBf5foJz7vo61B57zj+YXKqttNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39860400002)(376002)(5660300002)(83380400001)(33656002)(2906002)(71200400001)(316002)(4326008)(7696005)(186003)(55016002)(66556008)(66446008)(4744005)(64756008)(66476007)(8676002)(86362001)(26005)(66946007)(52536014)(54906003)(76116006)(8936002)(6916009)(9686003)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WkdEdVRaU2RYaGVpaW14bmZyUmlIUTZQYWQzVTc1cEhFWlZmTmFlWFBuTnZs?=
 =?utf-8?B?Y1prU05yWDByRW80Yy81MnV3c1JCTUJteHpXOENmR2VyUUJjQU41czVQUVFX?=
 =?utf-8?B?RTJVOHFOaEllaE5waWpUN25UcnBndFBlV3dabWIreFVOTFlzZDBsbkNER2RS?=
 =?utf-8?B?UERrbWl3N1EzVTZkSzROWFA5MTBPSWVPenJNRDRMSEJJV20yN1Rmd3RwRjFj?=
 =?utf-8?B?VzNrUTJVU2l3TkNGSHhVSk9tS0s0N1hDa0VhVEpUeVpTNW1uR1NqWUhWZVVQ?=
 =?utf-8?B?d3BTbW5BT09Cb1piM0ZGeE9jUnRkS1F1cHh2a0wra1pHNTdMTnRHWVYwZ3RP?=
 =?utf-8?B?WG5rMU1lUmJUUE5pQzY2ekVFay9uQWFkVFlrbzIxL0pUazJ5cW9QQlphTHJJ?=
 =?utf-8?B?UmR4aUJtaVFxS0twd1d5dkkzNkZFQjBaMHpSeG5sQS9VTlNyaU90ZDVFVVps?=
 =?utf-8?B?eHRWT1pibWhzWHJaUUI1emZCbGYwanVLbnh6SnEyTldDYks0a2toWm5BcXNw?=
 =?utf-8?B?OTRqUG5JaEdXYlpjSUgxdFdJRGpxTzIySVZiWVE0b1JXWUFKR0czOGNMV3pz?=
 =?utf-8?B?OEdUT3UzMjgyV1liZEVTZmsxYmkraElNVG50UzEwa240UG9QWmZGdzlhMS9k?=
 =?utf-8?B?SHVwM0lzbGM4VldyQWR1V25vRmxoYjQyT3YyS1Foc2dxV05aeXRwVjE0WFRN?=
 =?utf-8?B?SnQ1R1l1K1hUSjhWODN6VWQvUjJyc2hUVU8velpicEgwRCtZRnFLb3VRMVIv?=
 =?utf-8?B?R09sTnVKanFNcEwwa0xyUFN4TE1idjRUd0VMakM3dFFuc1ViVFRBK1hTSURv?=
 =?utf-8?B?RDFvcFR3Z2pGNnBRb0JDamtaNlhuK2VHaXEzNmYwVDVPdHh0MUJEcDJNTEZj?=
 =?utf-8?B?WWpUeEhqZHBqL2JZVGIxWEJ2a3RYRm4xa3VXZWZKSk9ZSFlPMjBXN1ZxY2pD?=
 =?utf-8?B?dzUyYjE2OWtVMTFaVncyZy9oNno1R2JlSDJkcmVvR1A4bGpVejdiL3M2WG1n?=
 =?utf-8?B?Y2JMZXZQaFU4U0plV2hjc29oc1hucjJtS0NMZy8ySEkrVmlVQ0prcEYzYmdh?=
 =?utf-8?B?NmRONHFtazJkY09rZHJJYm1PV1VLb2FVSUgyMW1Ub3pFOHBDODdTelhDS01t?=
 =?utf-8?B?S3RJcGR3WlRwbXFrMUxnbUdNQXZ0c2lsRVhSWVRjN0JXcGEwWTM3WUNoMWFP?=
 =?utf-8?B?Mi9CN3U1TnlBbHNneGs5ZEI0NEZvcERBSW9KbHBlQWNTZkE3bHlNLzBpSDl2?=
 =?utf-8?B?TWFwcXFxWnBEK080b1h0ajBwclp2aDRWaFpzZXg2UmttUkNEd21sclVkMDEx?=
 =?utf-8?B?eVZCc1B6TXNkdE9NVlhLNXQ1TEZxL01kV3FnNzhmdnU5Q2FhZm9XVzE3MXkx?=
 =?utf-8?B?N09zYWR2TGJLZTZwM1FRdk5lVjBKM3Vvak1OYm1IWE1ITEYxOEl5NkZ4T1py?=
 =?utf-8?Q?on2xvRvL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4615ef32-9c69-4c56-0868-08d8c08c2b6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 17:19:12.7353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yq+LP/dn6DXNOtWVrqxtWrA6mLlnoNwbaukFIIZMha+3XGojZpbU9UplM+qz+YhGKi7GjOos3LUSjQfMsGf5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1885
X-TM-SNTS-SMTP: 9C5D190F004F03146F160177AC0755D304CFF9A71FE4EBD15A2722A292CF4A552002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25932.001
X-TM-AS-Result: No-2.265-7.0-31-10
X-imss-scan-details: No-2.265-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25932.001
X-TMASE-Result: 10-2.265400-10.000000
X-TMASE-MatchedRID: e7Ukgmbx2cwpwNTiG5IsEldOi7IJyXyIypNii+mQKrGqvcIF1TcLYIwb
        hRWEqDwPtjMsSbrxcYGfzSlgaxxZi3I5WT4U/MvX72Rb2bEJC+0wjY20D2quYv5RW979ljm0M4G
        bsSC9BfX+x3dQ/lCKY5RehsBUYvv8uN97CnnNSwFVnniKh7YTC6lmjFq8ZmGOO312fKgjq4mjxY
        yRBa/qJQXykAZYKIINDV8DVAd6AO/dB/CxWTRRu/558CedkGIve4IUhIbe14YjKhbLJ1PWEmk+I
        O8TjNJAKNpt9JhT22lTA5L/bTrcE2p1UXP1MJrc5JfISFPj292p9IXnEONupsd+znRCU8eKSKzP
        g7NLjpYVrF5acJLxmyW9IBbILc6d46pgtcXT03Xyd7w6XNKfQVqAtPM/2FFilExlQIQeRG0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jOiBJbiBmdW5j
dGlvbiDigJhmZWNfcmVzdGFydOKAmToNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2ZlY19tYWluLmM6OTU4OjQ2OiB3YXJuaW5nOiBzdWdnZXN0DQo+IHBhcmVudGhlc2VzIGFyb3Vu
ZCDigJgmJuKAmSB3aXRoaW4g4oCYfHzigJkgWy1XcGFyZW50aGVzZXNdDQo+ICAgOTU4IHwgICAg
ICAoZmVwLT5xdWlya3MgJiBGRUNfUVVJUktfTk9fSEFSRF9SRVNFVCkgJiYgZmVwLT5saW5rKSB7
DQo+ICAgICAgIHwgICAgICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
Xn5+fn5+fn5+fn5+DQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHRha2luZyB0aGUgdGltZSB0
byByZXZpZXc7IEknbSBzb3JyeSwgSSBzaG91bGQgaGF2ZSBjYXVnaHQgdGhlIHdhcm5pbmcsIEkg
d2lsbCBmaXggdGhpcyBhc2FwLiANCg0KQmVzdCByZWdhcmRzLA0KDQpMYXVyZW50DQoNCg0KLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkVhdG9uIEluZHVzdHJpZXMgTWFudWZhY3R1cmlu
ZyBHbWJIIH4gUmVnaXN0ZXJlZCBwbGFjZSBvZiBidXNpbmVzczogUm91dGUgZGUgbGEgTG9uZ2Vy
YWllIDcsIDExMTAsIE1vcmdlcywgU3dpdHplcmxhbmQgDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQoNCg==
