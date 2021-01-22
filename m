Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D40300865
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbhAVQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:13:52 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729544AbhAVQNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 11:13:35 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69094A4025;
        Fri, 22 Jan 2021 11:12:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611331972;
        bh=ar+fQCpLXFWA4WFXA9R2LPP9IYAbxw0r9KD1s3DF5sY=; h=From:To:Date;
        b=O+4AnBRRNhz+kJw7d5NjbNG+HYX+1v2TcfRCYvIfKaqW4YM7u9sNPLLKuiJiNzFky
         ruWiyH4IP1zCMsqwj7iT/1Eta8uMHE0WsDh4bmI5nm0tMwA6/5f8lU0efRpEDpv6AG
         Sp8VXvgXxq6Xi5Cw8dea8oj4AdB9vFyR/gKQhrHBgbx9QbtgAyNh/HlQFLiilE2l1T
         60/FNBtfKkbmzp/u9y1abQMSRZz6hN4Ao5/jQglTwOORIsOPK4x9hA74b80XhmTabT
         ZuBHTLnAD8iO0sOAVU0EL7hyPoyHxNLpBZAAWFecVSBbKSiGpcxyjoqdWvmXxjdU5e
         YDg4zopmKm8Yg==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62FE5A4023;
        Fri, 22 Jan 2021 11:12:52 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 11:12:52 -0500 (EST)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Fri, 22 Jan 2021 11:12:51 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 22 Jan 2021 11:12:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 22 Jan 2021 11:12:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWY/oAbLOdvrsGvRrzvKMp4iQ5xsr5MXxMG/k/WBauY8ftZSBuAmO0XeZcrHE99ZkiO3jEqeV8CnB477bQrLbgE1EMre6JiaVr/1CEaL7gmFiv8n2TsxD2BbyGJXBGNfEM+XhPZplTWgWiPq7nxTT1MxzZHHb/8qqUCB7jZ36/NEH6MYn9YdAz+B2AwIQJ50ruynjzKyc/jMqfB5JoLrqEEWHPpjfcLDu9/SVnqSd+ee4kDkfv8LlFTCcxyw8EbBTCnEdhOoAAoIG3BHZYx+hX1jRuhZe0jgTCpreN5BJblu5o+Gudq9h44fZ5SJbqTDzteIszP72vCb2dFOJTa/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROdxyS0EtR/aZWbTTYhq8LKe/7O40SwGO0NwAf34uWE=;
 b=LwDSng93RKeSnkMyd0kW1j4W6HSDGB6BHCSju5seXC989YqizXAikxCq2h/Mhmb8/t2RFHgxTZpi0hMvD8Z3w26PYLrRidj35OVYgwsPI9ULHlhngTmbEWEGKzocezz3VKV1v4A9jPCBA8FTyc1bzRm1EW+F10Bok8EkSwc3pCIDoaXm4/4Efe3Trt7Q4OWe2NS6v3u34INruahWhDHlYsfRNXaDQewOy/kqtlLn+6pvl3Q7HMluLyJk8lj+S6tB/LpcK3SvaCpjg6/JAI+tLPsrAJm4s2olor6e1EtMdP9X4li3S01kqVkYAE4tXMhVP6W9yjsR9i+W1nWPI2xu6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROdxyS0EtR/aZWbTTYhq8LKe/7O40SwGO0NwAf34uWE=;
 b=4rJmiwy2lEY/Tm6doct9YOsLPAyS19hlWp4qyqH7gWJFascDIYJR4egql0y215CVIdRNEqSeqbzNssKQ23smnriUu7qavpTLCxGGQMoVw3uwQyc6LJ9xHSQJGDPrgCkOj5HhqamogBYYKAfc9v6jcWLODcSkF59PYrHmF0HzmIY=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR17MB1951.namprd17.prod.outlook.com (2603:10b6:300:84::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 16:12:50 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 16:12:50 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [EXTERNAL]  Re: [PATCH net 0/1] net: phy: Fix interrupt mask loss
 on resume from hibernation
Thread-Topic: [EXTERNAL]  Re: [PATCH net 0/1] net: phy: Fix interrupt mask
 loss on resume from hibernation
Thread-Index: AQHW8Mvg64BxrUQ6QkGpUgfrkq65AKozwnaAgAAMSWA=
Date:   Fri, 22 Jan 2021 16:12:49 +0000
Message-ID: <MW4PR17MB42439B9C628356447B5088F3DFA09@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <20210122143524.14516-1-laurentbadel@eaton.com>
 <32cbb60d-67f3-765a-d51e-48d74c0785d6@gmail.com>
In-Reply-To: <32cbb60d-67f3-765a-d51e-48d74c0785d6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f68812bf-1f3f-4b95-4650-08d8bef09099
x-ms-traffictypediagnostic: MWHPR17MB1951:
x-microsoft-antispam-prvs: <MWHPR17MB1951890F6D8FB81731B52459DFA09@MWHPR17MB1951.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xT6OODpzoNNvW0CxRK3bC0u2GX/vO14zA5jlNBNNO9FgZa2WepLSS70QF4msmjVAgVTQIzZlWUR+vvxhHdf74jMJqm3GQ6BuRQ0d8JE63QLW9n9JLpyZiW6aagJFm9btU8+hr3Ys4oCmj0YZO2yTAhk74WiKo1e6X9mbJoeYw2s3um/p1DmVFUuURgvKSlCj2tYZoKWnBuErQBvybSVPEXcCkuc4QguT0N1q+mcUIMLm1hPOAjzAgkYuSHV381B/1UwK8K3blAC+xDRLO48UlZ08uwJILkyGCtTNmt1znufGXabKcvgVXopTsPkLeVc5ZDoUqVGs4ntdmquMRTh58qXCSKzJxRzeE0murXZF9o0ukhHANcHTejUQ+uv6iQe79vfMNmNuZTpJvXAvMMik641cj81Bci9cHRCzz8SZHwD9nIW+2GxxddfR6wt0BpbY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(39860400002)(376002)(55016002)(5660300002)(76116006)(9686003)(52536014)(921005)(83380400001)(64756008)(66556008)(66476007)(66446008)(7416002)(66946007)(33656002)(26005)(7696005)(186003)(6506007)(316002)(71200400001)(2906002)(8676002)(478600001)(86362001)(110136005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aXV6YWhyZVlrbFc0MjROclR4aHJyMGppMXczVUNSODZwaXZvQXY4UitHRTJU?=
 =?utf-8?B?bEFhRWhVcTRnRXNkYi9DWTA4eEVlNWVWcGRVZDBScUZtenJ5WHhxU28raHB0?=
 =?utf-8?B?UFA5RmNaT2kvRVE5S3RwL1M4d0kxa1JzeHlUS1BQem5WdVlNTm1icDYvTlIx?=
 =?utf-8?B?RnZyRVpMY2g4d3hHMjRndlhuS1pRNFdBaUlLY1M3R3J0ZXJucmJPWEk5Sm9I?=
 =?utf-8?B?VEhUdnFaQURTdnBDUXkwbmZsYkhiYW1FZ1IwVjJWMkRkbitXTzc1OXg4R3BY?=
 =?utf-8?B?MVY2WHZUaVB1VXJ1NUw5dTZzcjRXUTJrdDFVY0U0eFBkVGhtcWpyQXl6bUNs?=
 =?utf-8?B?WG5reTlEUGRMa2NtbCtCOUJTN1VSVTNaZmhrSFFkT3pIM0pBTVFQa0tSbmRk?=
 =?utf-8?B?M3p4OEJCMTRJTmdVYnhieG1qcmN5bXMxS3hMVFJNVFBxOUJMd1BSZkRSSVp2?=
 =?utf-8?B?Qk0xRVkwRWZvTDU4SDBtWnByQkV2eXRPZEc2QjM4MzdpbEVvcWJ1YW12WjJP?=
 =?utf-8?B?THFaaEE0UVI0RUFncVZjS2grQndPclI2bjdlQzhUU0ZXOW1QQWRQNFJVSmJw?=
 =?utf-8?B?WHpqMVlHMkU2WU1TNk9KUjFkQ3N1ZWhDaUR5RGYyamQxcUFibjNKaUo0RVZv?=
 =?utf-8?B?OEYyNlhpSXpkcU5ycGFaVWZscWU4MFROcnp1TGFvUWNybC94VHRjM3BxMWRh?=
 =?utf-8?B?emhDbXNROWlTRm9PVmFibmhHR25icE9rMm9ZTGRVenhORjZPcmNmR2pIYkxH?=
 =?utf-8?B?OU1yQ1ZiQTROeUliMDI1SU9vcXQzdkZ6NmpLQSsrbkVGMEpwaG44cVFLQlNK?=
 =?utf-8?B?aFdFV1lnUHQzMFpYYVpwN1prbTVaVDI1emVMQmVTZUQ0cmdrL3F5N29jb2Ns?=
 =?utf-8?B?dTZWdmRIdURTaWxrbDcya296UFZDc1hoZU5ORXJHVTZUY212WXpwNEJDVWdi?=
 =?utf-8?B?S3FDaWRjMzNTUEt2WWlKQ1Q4eEszSlg1WkNlYTR1eXlrbkVVQkFLU2VndGxm?=
 =?utf-8?B?dzJvRld1NGQ0bm1qSVBwcmdpNXlVbDU5QXNFakVrTklnMEgvUGZxMExQbEk0?=
 =?utf-8?B?ZUliTWd2cUJSNEtYU3RJMW14ZW44WUZWN2p3Mm5FU3NnMWIvaTAwb3VQV05i?=
 =?utf-8?B?b1R0L1djYlowNmQyUGhOajdyZEVPSURPL2Q2UGR1U01SckY1UGlnYW9VVlJy?=
 =?utf-8?B?MEZlZnpMZjNwOXNxbExoL0NoaXFWYzlaN01OdldkYkU4c1FMVzM3MHBCZ2NZ?=
 =?utf-8?B?NmdVMDFlcXcrQVRXVFFPVWFBNmk5bFpSMkk3QzBJekRtcEswWmMzUlRXNlk1?=
 =?utf-8?B?U3JmL2poTFp1Ly8rOGt4WjJkdWdCb0hsSkdqYUh1dWExaXdoK2VQY2NaUWwz?=
 =?utf-8?B?KzVwUGRsbmJ5VWtQbk5vbVdMUmVkbElPUXF4V0E1Y3NoTjNNZ21ucUpNckZC?=
 =?utf-8?Q?GVLmEy5c?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f68812bf-1f3f-4b95-4650-08d8bef09099
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 16:12:49.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJahOHB+kltTMXlxxUs/bkI6IvkWUSBuNPhd4me4IZxmvFRFIL7uZLSvl9xxwopmWA/SxGMa8R0MntQj/fU/XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR17MB1951
X-TM-SNTS-SMTP: 9E16D91659A8AE540D0CFA528D2D6D45452C6C3CCDF510DDBAE5D57180A102832002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25928.001
X-TM-AS-Result: No--2.202-7.0-31-10
X-imss-scan-details: No--2.202-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25928.001
X-TMASE-Result: 10--2.202400-10.000000
X-TMASE-MatchedRID: tRtxWm8/OsEpwNTiG5IsEldOi7IJyXyIypNii+mQKrGqvcIF1TcLYEa+
        4Fduu7BiI+fHiMcknh3zDxVAoaU7urSw/pyY1ik4Lyz9QvAyHjqkpLxVvVhtnZ3zgovq0sbmf6O
        +FEJQpgDMXqzUcZzd05MfUJb9OR2qjKjbY8QyhYVxoP7A9oFi1kloPruIq9jTsS0sZEB7c8bJCS
        jEYuHdXG4xLhk/yLgSnO6WlpwwDXiyl+gKyy/g7xlJRfzNw8afE02Pr4CkNSN0rxNYA09+9qDSF
        bNSvOcnBMrhelRQ6bXbwQrKnCuU2Ll7A3O5D6aX/sUSFaCjTLx44oLbIRXS7vdt0QHl1BcpCMkz
        RYtEwm1WCSKTdQ2CeZGTpe1iiCJqfJ5/bZ6npdiujVRFkkVsm/dg9x7aI8AwgHkd7eDDNMVYINQ
        3w62qao/IyRvrqUkjPhvGO2tnDn+gcI5OqsCpz8lY63vICnhsx9LyAasqP9CLiaqag9ZB4h3Gm5
        R2h/Q7LjnH09LU/owIi37pJqP4+7/Oj7BAzdYuDfWVvHtiYgM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/PiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiBTZW50
OiBGcmlkYXksIEphbnVhcnkgMjIsIDIwMjEgNDoyMCBQTQ0KDQo+IFRoZSAob3B0aW9uYWwpIHNv
ZnR3YXJlIHJlc2V0IGlzIGRvbmUgdmlhIHNvZnRfcmVzZXQgY2FsbGJhY2suDQo+IFNvIGlmIHRo
ZSBQSFkgaW4gcXVlc3Rpb24gbmVlZHMgc3BlY2lhbCB0cmVhdG1lbnQgYWZ0ZXIgYSBzb2Z0IHJl
c2V0LA0KPiB3aHkgbm90IGFkZCBpdCB0byB0aGUgc29mdF9yZXNldCBjYWxsYmFjaz8NCg0KVGhh
bmsgeW91IHZlcnkgbXVjaCBmb3IgdGhlIGZhc3QgcmVwbHkuIFRoaXMgbWFrZXMgc2Vuc2UsIEkg
d2lsbCANCm1vZGlmeSB0aGUgcGF0Y2ggaW4gdGhpcyBkaXJlY3Rpb24uIA0KIA0KPiBUaGlzIHNv
dW5kcyB0byBtZSBsaWtlIGEgbG93ZXIgbGV2ZWwgZHJpdmVyIChlLmcuIGZvciBHUElPIC8gaW50
ZXJydXB0DQo+IGNvbnRyb2xsZXIpIG5vdCByZXN1bWluZyBwcm9wZXJseSBmcm9tIGhpYmVybmF0
aW9uLiBTdXBwb3NlZGx5IHRoaW5ncw0KPiBsaWtlIGVkZ2UvbGV2ZWwgaGlnaC9sb3cvYm90aCBh
cmUgc3RvcmVkIHBlciBpbnRlcnJ1cHQgbGluZSBpbiBhDQo+IHJlZ2lzdGVyIG9mIHRoZSBpbnRl
cnJ1cHQgY29udHJvbGxlciwgYW5kIHRoZSBjb250cm9sbGVyIHdvdWxkIGhhdmUgdG8NCj4gcmVz
dG9yZSB0aGUgcmVnaXN0ZXIgdmFsdWUgb24gcmVzdW1lIGZyb20gaGliZXJuYXRpb24uIFlvdSBt
YXkgd2FudCB0bw0KPiBoYXZlIGEgbG9vayBhdCB0aGF0IGRyaXZlci4NCg0KSSB0aGluayB5b3Ug
YXJlIHJpZ2h0LCB0aGUgZ3Bpby1teHMgZHJpdmVyIGhhcyBubyBQTSBvcGVyYXRpb25zLCBzbyAN
CmlmIGl0IHJlc3BvbnNpYmxlIGZvciByZXN0b3JpbmcgdGhlIGludGVycnVwdCBsZXZlbCwgbm8g
d29uZGVyIGl0IA0KZG9lc24ndC4gVGhpcyB3b3VsZCByZXF1aXJlIGltcGxlbWVudGluZyB0aGUg
UE0gb3BzLCB3aGljaCB3b3VsZCANCnRha2Ugc29tZSBhZGRpdGlvbmFsIHdvcmssIEknbGwgc2Vl
IGlmIEkgY2FuIGdldCBhcm91bmQgdG8gZG9pbmcgdGhpcy4NCiANCkJlc3QgcmVnYXJkcywNCg0K
TGF1cmVudA0KDQoNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkVhdG9uIEluZHVz
dHJpZXMgTWFudWZhY3R1cmluZyBHbWJIIH4gUmVnaXN0ZXJlZCBwbGFjZSBvZiBidXNpbmVzczog
Um91dGUgZGUgbGEgTG9uZ2VyYWllIDcsIDExMTAsIE1vcmdlcywgU3dpdHplcmxhbmQgDQoNCi0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCg==
