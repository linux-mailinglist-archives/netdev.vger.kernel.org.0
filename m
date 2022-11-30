Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921C463CE76
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiK3Esq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiK3Esj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:48:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D4E6DFEF;
        Tue, 29 Nov 2022 20:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669783718; x=1701319718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xyr/qowOocFfcRuILMMTFJt5aqM2A4ZusM2gCevNmjs=;
  b=VLk42AUDkshwaT+PPgQckCs5GiXSZzH/t1haTYoZGkugNBJKzT58wkdM
   1q7ed27gJpuvyZhks8RKU9QvGI/TrNTBUIeKtZGYyGqtOctKYHroY7N//
   smSmokgd5fzxC90r9brmFbja9p4+kXjQV3vyNrgVVWF8LoStLBhcR9KUr
   GQOhM47oLfz+1jPVhutIAGubMLG7BQrGro0a3uxQ75sf6snr5Ookxa7yj
   B70YOt4evRfuKm0DvitEci8Dc9ulKMB6k08KuvMu6rG3eQql392Kq1Hlz
   4EmSVWIIZ1fHgkcKgHtWI6WTVFiyL5YfuTgJYAePZThP+ixY2weNOsFwb
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="125741887"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 21:48:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 21:48:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 21:48:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuNnqkq+gn5a6mdsx0Hq0ShUFf+TqClk2bkjA0a8sIVorCE1q9unjURSciuzrKsm58oo657fmWbnqqET58wIuzFjd2mFbd8VhB/aBpNIgf4NoChNK11pw8kZltzrNn+sQKM8Pnc1EugsfNpnMrcp27wsP7+7DQpTOq3EmadI/AlQr1Xh0P1jya+39Iu1BNUIAgwa/E8PXVTvQt8+0QeQmORdRxvFWdAtn65ko3mWo+zvFJizeCxkqKVbhHj6lP/fDOmOeTqVBpW552ficS/HjWv6rqQNh400faZcJybwlGrxK9Wg8H32XrpoSYel6MHPF2kILfY4IcGOj+p8PC1Udg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xyr/qowOocFfcRuILMMTFJt5aqM2A4ZusM2gCevNmjs=;
 b=l6BN7HfGpXmrJe9959EKClqcmhYs1tuJScWHcW3oU3LvybMeCtXbmKvXeN8cp/dS+hmPhDbMq8ChaW+Zsj8j6UUyZXM4pEHSglzngBwGHHH9eskB2t02Ss2GVDBHMB0geIT9l+IrYMgUSTgHpDgdgXvM/McnecbUMhh5SbA7F5EFl0sOA3d0xDmeApBOIEAEmLLmgR/rFh3YLjoaoxz4xRi9nUDT5qtGdTCdWrnsvEhPEddpgToIpK12Dh3AHjFvNU6STx4Wxx+stRDWZcNMY/uUW5I+Z1Jy8c+6lAxh5y7eeZuZuePiYUHOmoYzWw5s/uqvKXCmncHd9l9IrwtHHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xyr/qowOocFfcRuILMMTFJt5aqM2A4ZusM2gCevNmjs=;
 b=H/zH3z2fEddYarRXWfuZFwFBkH285TJhg6v+PHYkyL1VXfglTdIlWicYFOYnmc9uokxulacmz1OqYX+4OuwBr3/RXF2DHFIR2COsrZYj6yyFNWMF6yvyYx5vKdv/J6YooAN0mSCZDI1bgW6eAIoL/3U3Mp7e7/BFvhe9wibfjus=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB4774.namprd11.prod.outlook.com (2603:10b6:510:40::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 04:48:35 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:48:35 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pavan.chebbi@broadcom.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 11/12] net: dsa: microchip: ptp: add periodic
 output signal
Thread-Topic: [Patch net-next v1 11/12] net: dsa: microchip: ptp: add periodic
 output signal
Thread-Index: AQHZAxUMvqen7Moqn0qCt6IBoETj6K5VmgCAgAARrgCAATwoAA==
Date:   Wed, 30 Nov 2022 04:48:35 +0000
Message-ID: <a8d13528857151652f39ce840567fad8650139e7.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-12-arun.ramadoss@microchip.com>
         <CALs4sv1hZRRdLGCRMLZxi2GjJ2NHYu2o9j5oNf3+BpTZKpdS8g@mail.gmail.com>
         <CALs4sv2+ureQ8JttKZf0-re40fd5PzfHREnJ709DGwotsySMsw@mail.gmail.com>
In-Reply-To: <CALs4sv2+ureQ8JttKZf0-re40fd5PzfHREnJ709DGwotsySMsw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB4774:EE_
x-ms-office365-filtering-correlation-id: 7f6081a3-81af-4424-d697-08dad28e23ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5WJSvRJC9y167gCF4D6DozFcHp/FUdhL36UTuRgs5IVOhsLRCOWrj9iOG+LH9sMhGDKRkTPouKGMTezp/p/BHDZx/HxQsYC3dBDji8IfpVxRVnHeN5ux9+wZTkhiFYxBj+r+j6206OLGc+92CrFWENg/8IW98OyrokZUaA1ukvQ5Nwd3xauhX1dFno6ZWpGuFAsKuIbbY51S1Au8G7KU8deADrf+uXDAcyMZPOXc4iHs8sSOBoYHntVO1wb+olGMmJMvypTUlpM6XIaILFHDEdtW6rGfVqUJ0KrOp7E957a1GnirbcfuUyetQPSGWl+bE1NNQRVu90MxlwgL5IPwF4sY64NGCI76b6pee2+Hhvy9pr664xOIVOV0ae5ANsUvbuqCFUnCaiAViaoModxteOffrjkcVFI3X+EoZGNsalj4jZ30RzllagkZzfYdSPBICI52OziEIvStQPfDmE/lENL3KBhzpiTg9HoMmZN+eoPwYdFQyXbincPkAj6NfJbn1MWD23ychIGM+tQm9XrF++l4oxb1zIk+eRRpqqNQ4vhsTiuMoA54vob2MFNKIBz5i0zLV8OSXlQ7RxaP2M7hxFcQfA1r4XKfBoOYCbPJjlB6WX3CvPy9ga8q/6r8iotmLPaWvYMK1ZuRTdDhjGK053xnFJzRuoEpywmg9LfOde+jQZXnOnsSCePAm7PxMpTStxd7BWkJfmASC1jIdFiaBxi7Sw0mBJw+25jTbZp2Ks=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(5660300002)(7416002)(6916009)(54906003)(2616005)(26005)(6512007)(41300700001)(66946007)(91956017)(76116006)(66556008)(4326008)(8676002)(64756008)(66446008)(66476007)(122000001)(36756003)(38100700002)(8936002)(2906002)(38070700005)(4001150100001)(186003)(71200400001)(86362001)(316002)(6506007)(6486002)(53546011)(83380400001)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUg1eUFuVTlpZ2QwK3d3NDZkdDlQb2FzaUM2YjBFaTcxK1ZJSWREUlMzTk1l?=
 =?utf-8?B?MWlsZlA1RXhIbG9NMmFSVTlIOGJzdnZOckI4dWRsLytIMUxlTk5NK1VyMUtY?=
 =?utf-8?B?elBIMHJoSU9ZYnhGV3hScE5UQ2Z2ZVJnRlVaN1o5aERBRUZsNDJNN2g4UXdD?=
 =?utf-8?B?dnlHbTFHMldGQklTSmxZUDRpV09zc1hPZWh0KzhqQnRwZUh0TG1hWkdrZTV6?=
 =?utf-8?B?Tm1tSVQ4Y29tMHNwRm1pL2EyQ0w0WUtqWTdFR2ZXWVlqTmtSaFFKYlFIRzll?=
 =?utf-8?B?M21Dbm9FZUhFaDQ2dWNKaUo1TWhmc01Oa3hHeDBkREUveDdHV012R0F3a05i?=
 =?utf-8?B?aEp3bHhrUVR2NFJ3SXA4RWJZVklXdlhzc3JuZnlCeGtqdGZmdktGQVZkYkZI?=
 =?utf-8?B?MGR3RFdnemtzQXloVmRvZVB6amVJT29jTENPUDg4UGgwRU1GUGlNRUt0QVZ2?=
 =?utf-8?B?NDhxSmNsVVJlU0d3TlFLK0FXRGJuNytMNk92NjBrekNMS0g0L0J2cHl0YnFw?=
 =?utf-8?B?TWRDeUlkUkxYUHJmV1hwQ1AybVRXbllQTGx3a2xpNE05RmU0OHdUVUNPcndm?=
 =?utf-8?B?ZCs3eHIxM1lWdC84QzZ3RTRTME14OExLaFJuMXM0K25UbVZ2SmYyWlZCNGpp?=
 =?utf-8?B?T0FEZm0yei82TTlBOUJSMHhjRXcvWFkzdXA1K2h5SndMM04rNS93Y2orWXIv?=
 =?utf-8?B?YWNsN2duNzIzY2V4cXVuYmFiSTFKUTBmT1NTdDZOVHl6MlYrdURSV0lublVV?=
 =?utf-8?B?WWdFZGM3MjBsSXdZVHNaekwwOVhlQS9yM3NldjBVTFQ0b0l0NGRkbXpHMXZM?=
 =?utf-8?B?N0MzeGhxUG1yRWdYb09zcVBsOTNSRFBhc2IyYm9UcFNQNXlXUWxwcm5saDQ4?=
 =?utf-8?B?NjBzZ0ovWDl3NWpCTEFVS1IxMmpNM0FsU3F3UXJnY1FoaHNKQXFxTmU1NHQv?=
 =?utf-8?B?cXV3VGJ1RDdXUkJIZ3VNV0IrT01yRzRqcHl2S1BtTytNOGVIVnY0cStaeGdQ?=
 =?utf-8?B?K0xUQmU3TWcwdjVNTm5laTJld3R5NGtOYy9GZEg2Rk8yUHF3YXBNYWdNODZ2?=
 =?utf-8?B?ems5UVdRenB6WHA5TVRyK1gzK2hPQlIzendEcVF1Wnd0aCt5Nms4TVNwNXJE?=
 =?utf-8?B?RU9uL2tRY3VNbGxMNDdtOXVHdExoZ0RCc28zbFcvUzJyZ1FTM2R0OU5YYXJq?=
 =?utf-8?B?ck95NmhONjZiNzlEaVNBVnVZSzBuazNSc1EyVEsvSHRQbzEwSGFEakVNVS80?=
 =?utf-8?B?TU1zd3NQWWxGUWJLNmtjMlNqVTUyUmVUK2IrNDFvZTU2UmpzZHVzUlg4Qkp1?=
 =?utf-8?B?Qm8wUVZWbml3ZGFrZThWbjdnSmhmUU9iY0c1RTR3S1hYOFZEZDRYSmxvbVB2?=
 =?utf-8?B?QmgxRUlJazV5U2pSLzVpT0UyWWs4YjJXN0pzVkdZdy9VWnJ2NWJqM3VpNEE3?=
 =?utf-8?B?TUpuRldlMWVOV29ia0VrZ2hReUVxYnR4QkRJZWhhcmxNZFUvTDVCSUpuRjFW?=
 =?utf-8?B?V0F1WVFSdkUza0N3ZG0vMHc1OXFHL3V6UVRBQXRCMmZxUEhtUE5PTCtGc3Yr?=
 =?utf-8?B?QVpyV0NDU3FXKzIxV2RYalg3SU1jemJSekovYnBCdjdFN2JZcVN6a2FUNld1?=
 =?utf-8?B?dXZkN0I4akxUajJrNTgxUS9hbGF1bWQzVXVYNk5aVW5YVi9XYW52dUFVRG51?=
 =?utf-8?B?cnFUMlZYMm4zT3ArdkY4YzJwbDhuVUNub0lMUVdZM3FNbXJ4U3ZGeUlwY1NK?=
 =?utf-8?B?cTdKbURkd2lYYi9YU1JIWmY3TEkvZ1hzUlhQbWZPZmZBN1NKZlhCU0d4U0NU?=
 =?utf-8?B?RFp3dFlYNkRHUHRtak1MN2tDek56MFNjb1RodjRDelhNNXRBTU0rN2lrZm1V?=
 =?utf-8?B?QUhWVm55Z3FZcXgzRERnM255ZEFQUHlxVlZva1BQS2ZxODFJWTUrRW1rQXg3?=
 =?utf-8?B?bUNlUGRQQ2svYWF4R3ZiUmhDTXRMRERUNTI3MDd3MUs2WEdnWGp0QmZmTHg4?=
 =?utf-8?B?eldjMUgzb1RDZ3B4RXJoV2FjdzdLSGhZam1Lblg1WHIwZGZoQWpxUEJRdGVh?=
 =?utf-8?B?V2R5M1k0TFJyYkNSTElNeXYxeGRUNHkxenVUNk9wNjhZUE0vdlBtcng1Tzh0?=
 =?utf-8?B?M0JqNUdzZ3lhTUZaSFp6c20rYm1qcGkwelcwOWtnMFFlREdidHEyQmVybVQ3?=
 =?utf-8?Q?PBEsQIieVVvn0S+9/X/Bd0s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EFFE1D35C679E49B99DDF66BDED52DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6081a3-81af-4424-d697-08dad28e23ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 04:48:35.2357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1B1EqzRDWMGEUoLGAScdAZYbiVnHQFjAgoTpmCHdFY+aRcafmIMQ7eEvR/kg4noRq8TfWxLFqh/sBam2e+3ZJUZ6/MnZxGvl7+b+ErHoZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4774
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTI5IGF0IDE1OjI3ICswNTMwLCBQYXZhbiBDaGViYmkgd3JvdGU6DQo+
IE9uIFR1ZSwgTm92IDI5LCAyMDIyIGF0IDI6MjMgUE0gUGF2YW4gQ2hlYmJpIDwNCj4gcGF2YW4u
Y2hlYmJpQGJyb2FkY29tLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCBOb3YgMjgsIDIw
MjIgYXQgNDowNSBQTSBBcnVuIFJhbWFkb3NzDQo+ID4gPGFydW4ucmFtYWRvc3NAbWljcm9jaGlw
LmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gPiArc3RhdGljIGludCBrc3pfcHRwX2VuYWJsZShzdHJ1
Y3QgcHRwX2Nsb2NrX2luZm8gKnB0cCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
c3RydWN0IHB0cF9jbG9ja19yZXF1ZXN0ICpyZXEsIGludCBvbikNCj4gPiA+ICt7DQo+ID4gPiAr
ICAgICAgIHN0cnVjdCBrc3pfcHRwX2RhdGEgKnB0cF9kYXRhID0gcHRwX2NhcHNfdG9fZGF0YShw
dHApOw0KPiA+ID4gKyAgICAgICBzdHJ1Y3Qga3N6X2RldmljZSAqZGV2ID0gcHRwX2RhdGFfdG9f
a3N6X2RldihwdHBfZGF0YSk7DQo+ID4gPiArICAgICAgIHN0cnVjdCBwdHBfcGVyb3V0X3JlcXVl
c3QgKnJlcXVlc3QgPSAmcmVxLT5wZXJvdXQ7DQo+ID4gPiArICAgICAgIGludCByZXQ7DQo+ID4g
PiArDQo+ID4gPiArICAgICAgIHN3aXRjaCAocmVxLT50eXBlKSB7DQo+ID4gPiArICAgICAgIGNh
c2UgUFRQX0NMS19SRVFfUEVST1VUOg0KPiA+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXF1ZXN0
LT5pbmRleCA+IHB0cC0+bl9wZXJfb3V0KQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
cmV0dXJuIC1FSU5WQUw7DQo+ID4gDQo+ID4gU2hvdWxkIGJlIC1FT1BOT1RTVVBQID8gSSBzZWUg
c29tZSBvdGhlciBwbGFjZXMgd2hlcmUgLUVPUE5PVFNVUFANCj4gPiBpcw0KPiA+IG1vcmUgYXBw
cm9wcmlhdGUuDQo+ID4gDQo+ID4gPiArDQo+ID4gPiArICAgICAgICAgICAgICAgbXV0ZXhfbG9j
aygmcHRwX2RhdGEtPmxvY2spOw0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldCA9IGtzel9wdHBf
ZW5hYmxlX3Blcm91dChkZXYsIHJlcXVlc3QsIG9uKTsNCj4gPiA+ICsgICAgICAgICAgICAgICBt
dXRleF91bmxvY2soJnB0cF9kYXRhLT5sb2NrKTsNCj4gPiA+ICsgICAgICAgICAgICAgICBicmVh
azsNCj4gPiA+ICsgICAgICAgZGVmYXVsdDoNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gDQo+IE9LIEkgcmVhbGx5IG1lYW50IGhlcmUuDQoNCk9rLiBJIHdpbGwgdXBk
YXRlIC1FSU5WQUwgdG8gLUVPUE5PVFNVUFAuDQoNCj4gDQo+ID4gPiArICAgICAgIH0NCj4gPiA+
ICsNCj4gPiA+ICsgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiAg
LyogIEZ1bmN0aW9uIGlzIHBvaW50ZXIgdG8gdGhlIGRvX2F1eF93b3JrIGluIHRoZSBwdHBfY2xv
Y2sNCj4gPiA+IGNhcGFiaWxpdHkgKi8NCj4gPiA+ICBzdGF0aWMgbG9uZyBrc3pfcHRwX2RvX2F1
eF93b3JrKHN0cnVjdCBwdHBfY2xvY2tfaW5mbyAqcHRwKQ0KPiA+ID4gIHsNCj4gPiA+IEBAIC01
MDgsNiArODIzLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwdHBfY2xvY2tfaW5mbw0KPiA+ID4g
a3N6X3B0cF9jYXBzID0gew0KPiA+ID4gICAgICAgICAuYWRqZmluZSAgICAgICAgPSBrc3pfcHRw
X2FkamZpbmUsDQo+ID4gPiAgICAgICAgIC5hZGp0aW1lICAgICAgICA9IGtzel9wdHBfYWRqdGlt
ZSwNCj4gPiA+ICAgICAgICAgLmRvX2F1eF93b3JrICAgID0ga3N6X3B0cF9kb19hdXhfd29yaywN
Cj4gPiA+ICsgICAgICAgLmVuYWJsZSAgICAgICAgID0ga3N6X3B0cF9lbmFibGUsDQo+ID4gPiAr
ICAgICAgIC5uX3Blcl9vdXQgICAgICA9IDMsDQo+ID4gPiAgfTsNCj4gPiA+IA0K
