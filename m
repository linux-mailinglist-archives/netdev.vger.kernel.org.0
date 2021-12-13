Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB63472116
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 07:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhLMGcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 01:32:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21723 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbhLMGch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 01:32:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639377158; x=1670913158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g8lsAMov1n2QfEqTDS6fK2ugo04BuLQro85qDecXOYI=;
  b=COoAxpo8gke76yd2FyLT1bkycqMFzQPV0DCuXScjqryB8Rz2Y0IB+2f9
   R0y3umDwOGQoCP8Rz6ltmua4nzVsdNPC/aH09jlKoSIGfEB9Riy4GvBd7
   OYiyaLFe+xw82HWV5tHVEd3Q+7zpY2LibXgY2Mui8IUd0wzTBtT8s5ye7
   CdmPEEJ/rJw7ZZG2hoDViGyUy4q/xQ55XocZ5XOUaeASYGHtUdSulsPd0
   D2N2UU6utIxJnIWSDFVVsTSe4wsT77UF3sn5SEvD0D7B0/qiuA9H02cFA
   wlNUGOWL2tCLPFYg5EjCrECeD/lJeGjNDZp4lG4nwn3w26ddsRrxFjf3A
   w==;
IronPort-SDR: F/hQNeMwiRHmxT5BBmK5ix3QBQE7EnTvlEU7eFVGfQMzL7aZbap7pzJFcBRHWCOScbt0GmzFOj
 V6i5EB4w//SbrP6V36JiXG0+6G+3NgZHg47Q+wNUQxChpujzu7iocnrlaY07JOvnvzD7Of/BZ4
 Qs9tdwtE44zRi+O/11HDBxQ9QB7ZYZi9qZcrmXFyXWk5brqRPXHJqVJzSwqFkkFh7ija0txRPr
 boBMZcTVXuMxW3bz3y7Ks34O2WGM3tKzbAj0nJqZABZjjrXZfykAS9zD9fCbETkfIJRA/gdSWA
 TxYjLYmi3nJgJfrhc9yBMiti
X-IronPort-AV: E=Sophos;i="5.88,201,1635231600"; 
   d="scan'208";a="146420111"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2021 23:32:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 12 Dec 2021 23:32:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sun, 12 Dec 2021 23:32:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/7vaEA/qwIMtW5WDcv0qELuf6PcrCpsJ1XPmxLw22XwMMV6zVzOSIyxNUALr/WEqe/ONj657X2YX0qT7NelBm8YQAUW8FSOmQr/wIBHH/kHGpHepA7EkOkKleJCRIlgfz6yGhKZ8Z8SYH39UsVtt+HK+XhRAe1VAwNjFsXmd4bgS00U0HUeV/HOia1Y2apgRHoQIqNzaNLMLlpWFLuPZPGRAZjBx4cwdJvxKQAZjNuE/6zO7w4gIKoYTmuempldhwUglntqGU76DOX8f3RUG33+rytF1d8PmW6B0qu8kNdPFkBMJcoZupWZvfhWGrjpGV24cYYjvW+v1lux9iyX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8lsAMov1n2QfEqTDS6fK2ugo04BuLQro85qDecXOYI=;
 b=P/7Rs0X/SqqbEPTqseyElNHeCo3fcXO4CIN+c9u0Vta7olz/HjO0Ikj37nvkcsl0C7A7RclE1iwjhN98Ma5DFfj6mtpBFtH0KTnIbIrgKjSWWzRCLReJSMWUXc8WloOFB8ZEQH6jL2UkhqmMKbx4KRCooyUVw1Wtb35wqkydHJIWTNDFJzFlPcrTlLG1lRRrya9D84bCdyzrsNJp3MTlL/upizPfmoTJCnVtmy77O3FxgF5LN6enrEavDQPjOH2TBZ+yibz/0G4/I6x3Rl6GjXUEuXKwZV7NnE65AHZ7hBJq9oUx7Xa7nafAHwNOz4U8NFxeXlgF/1G+c5coQR5M3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8lsAMov1n2QfEqTDS6fK2ugo04BuLQro85qDecXOYI=;
 b=cMudi+X8JNTb6vm2mFcMMhDF+I8nc91PZr4F1zJ56Tnaryn5UGAdD3GG13gqNHmQTLmfuhmA0qNG5ZPH/2f0pGtfrksR/vtosLt3k9jBp0Uk22v64duYg+iE4BYfTJPk9V+AO98TwqeD2qY9lGRgsJOJV3EtOPxJulDL1KrxtbQ=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 06:32:26 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 06:32:26 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <adham.abozaeid@microchip.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v2 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX7+sxVJKk/gSTcECp4llNXYlhjA==
Date:   Mon, 13 Dec 2021 06:32:26 +0000
Message-ID: <0eba4b4c-7c00-291a-e9a3-c8c45fe4be86@microchip.com>
References: <20211208061559.3404738-1-davidm@egauge.net>
 <20211208061559.3404738-2-davidm@egauge.net>
In-Reply-To: <20211208061559.3404738-2-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34e05464-e720-431e-dc94-08d9be025480
x-ms-traffictypediagnostic: MW5PR11MB5881:EE_
x-microsoft-antispam-prvs: <MW5PR11MB58812E60FA28EB1655B71EA387749@MW5PR11MB5881.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VEHWCFTpcTeqyuC6UrhfrnxfH5kqGMnHV91/ZrkAP2h4pXTLEX0wSk7SYpHyzE6Q9TISNWszEgKw7k/AMePo4VDUibEnp6ATAYhgmeIG3+6UrPZyevoIEf+y9wdofzed3zXLZNfDWBKpu9uZfBDOovtous6yNxQTvEOTbJK6qPiupg0z0FAS+99XU4PGYdlTRDVqei8URs1YL1I/YvaJS0GIXnAFB5CKA+dT3uRCiX2LFEAtlP/aUpyfGp7+MAzMjqKWw453Atelc/4Ne2nh+OYvOireCeNWhnz1sFE9j/EumwW3JUzRsQBaWpw+R7dnYd40IdQiYuzV7vms/cdZeQF9aO+shU0Q9z6jB25g7BUcpESL4bPH6zS8rlQWb5C9SNEPLtu7c3P4/wVBxE+ceDniC4HQZ5WJMR0CjrB3xyfVavYI2XfefLURC1cX6WgT0eaCsekP7Dz86DaFW92k0eVKSudFag8IcsXxsw7qoh/8prvbSaZZuwRD99CNCHLJ+3gOHa34TCh9/4LSXuXZnIlHnTyZRAY1ofgAFfRNcyli+L+mea6tylyNi2vDxXCTbCQC5Koi2J9Lv/+E2/IbHISUUxqRwlzLiInEPWKdfHAkkIGCoJ07h+M6allCwPP2a4IV60iJBs8j5VgScnvW+q+798R6O0owh9yA0lGv3bdP9Gjm3l30FmdKNEBY8mVku8p//EBKMhqF929UrSIItPb0DSl0LVczchwnWz+YQigaiAU5U5ckDLrCCSJmRaYsb11C1lWqebxgTdlbcLAOMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(76116006)(4326008)(508600001)(5660300002)(26005)(66946007)(122000001)(66476007)(2906002)(6636002)(64756008)(36756003)(31696002)(66556008)(38070700005)(91956017)(66446008)(6486002)(6512007)(8936002)(31686004)(71200400001)(6506007)(316002)(8676002)(110136005)(54906003)(2616005)(186003)(83380400001)(38100700002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0NmM0FjUkZFTm1CMXplYllnMklSMHpwZ2VaRVd2eTJYZjdXSzR1cm9SSlJD?=
 =?utf-8?B?TU1GY1Q2a1dSUGdhRjZFK3VnZTg1bGd0eHhQUXlJNThzNEo4djFqVjBKVTlw?=
 =?utf-8?B?SFR5SnZSWGFLUjdUcy9KQTgwczRTWVJqc3oyWjNNTlEwd2ZRamJNV3ZHSVl0?=
 =?utf-8?B?YTdXVmQxOStVZjN1UlViRnNJUmNBRGM5TVEwUXYvM0NPNUxzWFY4SklRaVpz?=
 =?utf-8?B?b1lRRXR2VFZnVWxZUHk1a0pLczlhelZZVnRYWTh3WHhHN3ppd21OOHlDUk9E?=
 =?utf-8?B?VGY3SnEvWTRRa1VJZHVqUlM5UHVlR0cxVyttUkNyRzdzNTVwR3pLQkJzM0k2?=
 =?utf-8?B?a2luVnFDVU1KYmZvdjJuNFhkYmVOK0lVUmhCTWUyaXB2czJCbWRiVDVHZ1JV?=
 =?utf-8?B?SDFpQ2ZnTjZhSW5WV1Fub2x3dUJKMktHaHdaS0dnbk1UejNrUUdHc0NhdHRp?=
 =?utf-8?B?TmhuZlYxYjg1Y0U5M0FkNHVwbHNJQWFMUlYzUFEwUUd4RVNSbUp4KzNSd09L?=
 =?utf-8?B?MUZmWGxRakJvK0U0aHFHNUFRTDhXV3o4eWFib3BJbHBuOVRHWmlWTnA4Z1Jr?=
 =?utf-8?B?dU1pT0tqTkVwL3lacUFQVlZ3N0NnQTBOS3RRS0hNdDA0Nm9sSW05cFlZdmdI?=
 =?utf-8?B?RE90V293Rjl6WVJuRkoxYVltNDhHaDFuTllhZVRIRjFEa1Y1Zmk5TEFaMjF2?=
 =?utf-8?B?OVpyb0VTTzl3UGs5NThzejFRRFcvQWMwMk8xR1dOZ01Gak9GMml5Q05nWWdY?=
 =?utf-8?B?VXdzUFp1Wmc2NzhDdm9hSjhNU0hSU3h1d1ZqbHhSaEMzdTVacVA4S1pxUkwv?=
 =?utf-8?B?NDBYbnZjTEF2Z0NGeEw2ZXhrUHFrV0F4MjRrTWdnN2NCME9INTBWQWt6VVlt?=
 =?utf-8?B?N2VBS3F3SGxwYWlzMzRRWm5DTGcxck81WXAzL0dXTVlMbFBsb2tVNXk3ZTE1?=
 =?utf-8?B?KzEwYzRJbjZWL0NzZFgrMmh4TUticTBic0JLWGc0c3BweFd5WHZMU01NenRH?=
 =?utf-8?B?M001ZmthVnFPRXhLbXFIUUVJbVNsblQ4UmJEZXgyVzY3ZEQ3c3l3cHpHbFU5?=
 =?utf-8?B?TXJSUk5FSXN1UEZBc0h1cEZtR2dlZkFRNFUxdllZaUN5S0l3R0tJb3dmYjBn?=
 =?utf-8?B?eVFNbUZBQ3Jab0hvcllJb0tUUGhrdnVTZHBFOXFHNnZ5S0Q5ZjFLeERtdlFO?=
 =?utf-8?B?Wi9FeEtIL0Y2cHJLVlppclBZemU4S0dYQ0g2bWpBajkyK055TWxPM2R0TkxX?=
 =?utf-8?B?b04vOFJrQ1Nkclo5aWRrcXlsL0czLzZoWEFZVXlhU09YeXJYOFRCY1ZXZVZq?=
 =?utf-8?B?SGhvZElCbDBvaWpaRDZ5VWlqTWJBaTY3RjNRaGhITkMrdjVGV3Z0MEU5U1FI?=
 =?utf-8?B?M1MrVTkrOEIzZjFVQ0RFYXNuWEdrampNTnlOS1FSLzBvYWlrRkNuYXNnamxW?=
 =?utf-8?B?UEt2Y2IrSmJrN3R6YlhsWHUzSTdEWWVsRk9Fd0RWNUh4S0p0aTVvNHZJZERC?=
 =?utf-8?B?RGNDRGhxN0p4bnEwVWcxdmtMNmFSNDVIYzk1VXdqbXIvNXI2WW9KMzB3OFZI?=
 =?utf-8?B?L0hTTURkYUFRODd5bTBlZTlYSnVrdy83RlZFUXMrNmk0Nm5kcVQ0MVNYZTc2?=
 =?utf-8?B?d2NValY4aFh0VjhKdHpTSFpSZ25mZVFaald1cEhydkl3Y1BUN212RURtK2Np?=
 =?utf-8?B?ajZqR2Z5bXFhb2FEQkVieE4zUHFoNmQvZnVXUklRaS8zcVVWVGgyeGp5d0t4?=
 =?utf-8?B?Zjg3Y2JpZzVmSVVxL3d5MStGSDNTc2M2b1V1VCs4Qk9MemhxakhockU3dm1m?=
 =?utf-8?B?UCtjMUwwN1MyaWZ6Wk1hNlRjQ1g0TTRtS2RaQzA4QWVQV2dTa2Y3NXlua0pr?=
 =?utf-8?B?bjBZZjRjd240TUZ2RFkvR0VRV2tCU1FPMnl3M1d4Nk50a1Z1UHBjbjRtMmtl?=
 =?utf-8?B?ZHBkdnFyU3lTM0VzNmE4YWhpd0g1ejlMUkxySS9IeCtXWUc4NzBkZTRzVjhB?=
 =?utf-8?B?a1RHWVNBNVkySGw3VThBQjRORFdNSDVkTGhnaXZVbjg2ZVZLc0Vnc00xSCsz?=
 =?utf-8?B?dFROUGsvNHBiMlBYcnltTVVTcmN5Nk0xODAramVBWHR5UzZuR0hsUis2Q0RB?=
 =?utf-8?B?bXh2VndDaGpVci9ZWDdmcDNoMnR3dVRHL0FocnhXUEZGazRNV2kyNUNFa3pp?=
 =?utf-8?B?QWF4aTI5eDQxeGY4VStPSE5OU0Nsc3cyTnRBcEtCSEZCMVJBQ2ZZU0twK1Np?=
 =?utf-8?B?NVJ6akl6clRBWFU4OGx4U3h5dFp3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9A21A12FEF6C74E859FF2631095B441@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e05464-e720-431e-dc94-08d9be025480
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 06:32:26.5264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uliZd8YOSBWrsr26JrU4Jk3ZCVxJ+NW6xI8m16IMLKKcSxFTFOFJPMXVmlgoTDxmleVMtcg1JBbFtSpkd/tXTF2WzymT91y0YWcbyxLeEJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5881
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDguMTIuMjAyMSAwODoxNiwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRm9yIHRoZSBTRElPIGRyaXZlciwg
dGhlIFJFU0VUL0VOQUJMRSBwaW5zIG9mIFdJTEMxMDAwIGFyZSBjb250cm9sbGVkDQo+IHRocm91
Z2ggdGhlIFNESU8gcG93ZXIgc2VxdWVuY2UgZHJpdmVyLiAgVGhpcyBjb21taXQgYWRkcyBhbmFs
b2dvdXMNCj4gc3VwcG9ydCBmb3IgdGhlIFNQSSBkcml2ZXIuICBTcGVjaWZpY2FsbHksIGR1cmlu
ZyBpbml0aWFsaXphdGlvbiwgdGhlDQo+IGNoaXAgd2lsbCBiZSBFTkFCTEVkIGFuZCB0YWtlbiBv
dXQgb2YgUkVTRVQgYW5kIGR1cmluZw0KPiBkZWluaXRpYWxpemF0aW9uLCB0aGUgY2hpcCB3aWxs
IGJlIHBsYWNlZCBiYWNrIGludG8gUkVTRVQgYW5kIGRpc2FibGVkDQo+IChib3RoIHRvIHJlZHVj
ZSBwb3dlciBjb25zdW1wdGlvbiBhbmQgdG8gZW5zdXJlIHRoZSBXaUZpIHJhZGlvIGlzDQo+IG9m
ZikuDQo+IA0KPiBCb3RoIFJFU0VUIGFuZCBFTkFCTEUgR1BJT3MgYXJlIG9wdGlvbmFsLiAgSG93
ZXZlciwgaWYgdGhlIEVOQUJMRSBHUElPDQo+IGlzIHNwZWNpZmllZCwgdGhlbiB0aGUgUkVTRVQg
R1BJTyBzaG91bGQgbm9ybWFsbHkgYWxzbyBiZSBzcGVjaWZpZWQgYXMNCj4gb3RoZXJ3aXNlIHRo
ZXJlIGlzIG5vIHdheSB0byBlbnN1cmUgcHJvcGVyIHRpbWluZyBvZiB0aGUgRU5BQkxFL1JFU0VU
DQo+IHNlcXVlbmNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTW9zYmVyZ2VyLVRhbmcg
PGRhdmlkbUBlZ2F1Z2UubmV0Pg0KPiAtLS0NCg0KUGxlYXNlIHNwZWNpZnkgd2hhdCBoYXZlIGJl
ZW4gY2hhbmdlZCBzaW5jZSBwcmV2aW91cyB2ZXJzaW9uIGVpdGhlciBoZXJlDQp1bmRlciAiLS0t
IiBvciBpbiBjb3ZlciBsZXR0ZXIuDQoNCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hp
cC93aWxjMTAwMC9zcGkuYyB8IDM2ICsrKysrKysrKysrKysrKysrLS0NCj4gIC4uLi9uZXQvd2ly
ZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dsYW4uYyAgICB8ICAyICstDQo+ICAyIGZpbGVzIGNo
YW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+IGluZGV4IDY0MDg1MGY5
ODlkZC4uMzcyMTVmY2MyN2UwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9t
aWNyb2NoaXAvd2lsYzEwMDAvc3BpLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWlj
cm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+IEBAIC04LDYgKzgsNyBAQA0KPiAgI2luY2x1ZGUgPGxp
bnV4L3NwaS9zcGkuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9jcmM3Lmg+DQo+ICAjaW5jbHVkZSA8
bGludXgvY3JjLWl0dS10Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvb2ZfZ3Bpby5oPg0KDQpHUElP
IGRlc2NyaXB0b3JzIGFyZSBjb3ZlcmVkIGJ5IDxsaW51eC9ncGlvL2NvbnN1bWVyLmg+DQoNCj4g
DQo+ICAjaW5jbHVkZSAibmV0ZGV2LmgiDQo+ICAjaW5jbHVkZSAiY2ZnODAyMTEuaCINCj4gQEAg
LTE1Miw2ICsxNTMsMzEgQEAgc3RydWN0IHdpbGNfc3BpX3NwZWNpYWxfY21kX3JzcCB7DQo+ICAg
ICAgICAgdTggc3RhdHVzOw0KPiAgfSBfX3BhY2tlZDsNCj4gDQo+ICtzdGF0aWMgdm9pZCB3aWxj
X3NldF9lbmFibGUoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSwgYm9vbCBvbikNCg0KSSBsaWtlZCBi
ZXR0ZXIgd2lsY193bGFuX3Bvd2VyKCkuDQoNCj4gK3sNCj4gKyAgICAgICBpbnQgZW5hYmxlX2dw
aW8sIHJlc2V0X2dwaW87DQo+ICsNCj4gKyAgICAgICBlbmFibGVfZ3BpbyA9IG9mX2dldF9uYW1l
ZF9ncGlvKHNwaS0+ZGV2Lm9mX25vZGUsICJjaGlwX2VuLWdwaW9zIiwgMCk7DQo+ICsgICAgICAg
cmVzZXRfZ3BpbyA9IG9mX2dldF9uYW1lZF9ncGlvKHNwaS0+ZGV2Lm9mX25vZGUsICJyZXNldC1n
cGlvcyIsIDApOw0KDQpUaGUgZXF1aXZhbGVudCBvZiBvZl9nZXRfbmFtZWRfZ3BpbygpLCBkZXZp
Y2UgbWFuYWdlZCwgaXMNCmRldm1fZ3Bpb2RfZ2V0X2Zyb21fb2Zfbm9kZSgpIGFuZCBjb3VsZCBi
ZSB1c2VkIG9uIGJlaGFsZiBvZiBzcGkgZGV2aWNlLg0KQnV0IEkgcHJlc3VtZSBkZXZtX2dwaW9k
X2dldCgpL2Rldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsKCkgY291bGQgYWxzbyBiZSB1c2VkDQpmb3Ig
eW91ciB1c2UgY2FzZS4NCg0KQW5kIEkgd291bGQga2VlcCB0aGUgcGFyc2luZyBqdXN0IG9uZSB0
aW1lLCBhdCBwcm9iZS4NCg0KPiArDQo+ICsgICAgICAgaWYgKG9uKSB7DQo+ICsgICAgICAgICAg
ICAgICBpZiAoZ3Bpb19pc192YWxpZChlbmFibGVfZ3BpbykpDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIC8qIGFzc2VydCBFTkFCTEUgKi8NCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZ3Bp
b19kaXJlY3Rpb25fb3V0cHV0KGVuYWJsZV9ncGlvLCAxKTsNCj4gKyAgICAgICAgICAgICAgIG1k
ZWxheSg1KTsgICAgICAvKiA1bXMgZGVsYXkgcmVxdWlyZWQgYnkgV0lMQzEwMDAgKi8NCj4gKyAg
ICAgICAgICAgICAgIGlmIChncGlvX2lzX3ZhbGlkKHJlc2V0X2dwaW8pKQ0KPiArICAgICAgICAg
ICAgICAgICAgICAgICAvKiBkZWFzc2VydCBSRVNFVCAqLw0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBncGlvX2RpcmVjdGlvbl9vdXRwdXQocmVzZXRfZ3BpbywgMSk7DQo+ICsgICAgICAgfSBl
bHNlIHsNCj4gKyAgICAgICAgICAgICAgIGlmIChncGlvX2lzX3ZhbGlkKHJlc2V0X2dwaW8pKQ0K
PiArICAgICAgICAgICAgICAgICAgICAgICAvKiBhc3NlcnQgUkVTRVQgKi8NCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgZ3Bpb19kaXJlY3Rpb25fb3V0cHV0KHJlc2V0X2dwaW8sIDApOw0KPiAr
ICAgICAgICAgICAgICAgaWYgKGdwaW9faXNfdmFsaWQoZW5hYmxlX2dwaW8pKQ0KPiArICAgICAg
ICAgICAgICAgICAgICAgICAvKiBkZWFzc2VydCBFTkFCTEUgKi8NCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZ3Bpb19kaXJlY3Rpb25fb3V0cHV0KGVuYWJsZV9ncGlvLCAwKTsNCj4gKyAgICAg
ICB9DQoNCldpdGggZ3BpbyBkZXNjcmlwdG9ycyBhcyBmYXIgYXMgSSBjYW4gdGVsbCB5b3UgZG9u
J3QgaGF2ZSB0byBleHBsaWNpdGx5DQpjaGVjayB0aGUgdmFsaWRpdHkgb2YgZ3BpbyBhcyBpdCBp
cyBlbWJlZGRlZCBpbiBncGlvZF9kaXJlY3Rpb25fb3V0cHV0KCkNCnNwZWNpZmljIGZ1bmN0aW9u
IHRodXMgdGhlIGFib3ZlIGNvZGUgbWF5IGJlY29tZToNCg0KCWlmIChvbikgew0KCQlncGlvZF9k
aXJlY3Rpb25fb3V0cHV0KGVuYWJsZV9ncGlvLCBvbik7DQoJCW1kZWxheSg1KTsNCgkJZ3Bpb2Rf
ZGlyZWN0aW9uX291dHB1dChyZXNldF9ncGlvLCBvbik7DQoJfSBlbHNlIHsNCgkJZ3Bpb2RfZGly
ZWN0aW9uX291dHB1dChyZXNldF9ncGlvLCBvbik7DQoJCWdwaW9kX2RpcmVjdGlvbl9vdXRwdXQo
ZW5hYmxlX2dwaW8sIG9uKTsNCgl9DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQgd2lsY19idXNf
cHJvYmUoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSkNCj4gIHsNCj4gICAgICAgICBpbnQgcmV0Ow0K
PiBAQCAtOTc3LDkgKzEwMDMsMTEgQEAgc3RhdGljIGludCB3aWxjX3NwaV9yZXNldChzdHJ1Y3Qg
d2lsYyAqd2lsYykNCj4gDQo+ICBzdGF0aWMgaW50IHdpbGNfc3BpX2RlaW5pdChzdHJ1Y3Qgd2ls
YyAqd2lsYykNCj4gIHsNCj4gLSAgICAgICAvKg0KPiAtICAgICAgICAqIFRPRE86DQo+IC0gICAg
ICAgICovDQo+ICsgICAgICAgc3RydWN0IHNwaV9kZXZpY2UgKnNwaSA9IHRvX3NwaV9kZXZpY2Uo
d2lsYy0+ZGV2KTsNCj4gKyAgICAgICBzdHJ1Y3Qgd2lsY19zcGkgKnNwaV9wcml2ID0gd2lsYy0+
YnVzX2RhdGE7DQo+ICsNCj4gKyAgICAgICBzcGlfcHJpdi0+aXNpbml0ID0gZmFsc2U7DQo+ICsg
ICAgICAgd2lsY19zZXRfZW5hYmxlKHNwaSwgZmFsc2UpOw0KPiAgICAgICAgIHJldHVybiAwOw0K
PiAgfQ0KPiANCj4gQEAgLTEwMDAsNiArMTAyOCw4IEBAIHN0YXRpYyBpbnQgd2lsY19zcGlfaW5p
dChzdHJ1Y3Qgd2lsYyAqd2lsYywgYm9vbCByZXN1bWUpDQo+ICAgICAgICAgICAgICAgICBkZXZf
ZXJyKCZzcGktPmRldiwgIkZhaWwgY21kIHJlYWQgY2hpcCBpZC4uLlxuIik7DQo+ICAgICAgICAg
fQ0KPiANCj4gKyAgICAgICB3aWxjX3NldF9lbmFibGUoc3BpLCB0cnVlKTsNCj4gKw0KPiAgICAg
ICAgIC8qDQo+ICAgICAgICAgICogY29uZmlndXJlIHByb3RvY29sDQo+ICAgICAgICAgICovDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xh
bi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dsYW4uYw0KPiBp
bmRleCA4MjU2NjU0NDQxOWEuLmYxZTRhYzNhMmFkNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dsYW4uYw0KPiArKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jDQo+IEBAIC0xMjUzLDcgKzEyNTMs
NyBAQCB2b2lkIHdpbGNfd2xhbl9jbGVhbnVwKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICAg
ICAgICAgd2lsYy0+cnhfYnVmZmVyID0gTlVMTDsNCj4gICAgICAgICBrZnJlZSh3aWxjLT50eF9i
dWZmZXIpOw0KPiAgICAgICAgIHdpbGMtPnR4X2J1ZmZlciA9IE5VTEw7DQo+IC0gICAgICAgd2ls
Yy0+aGlmX2Z1bmMtPmhpZl9kZWluaXQoTlVMTCk7DQo+ICsgICAgICAgd2lsYy0+aGlmX2Z1bmMt
PmhpZl9kZWluaXQod2lsYyk7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGludCB3aWxjX3dsYW5fY2Zn
X2NvbW1pdChzdHJ1Y3Qgd2lsY192aWYgKnZpZiwgaW50IHR5cGUsDQo+IC0tDQo+IDIuMjUuMQ0K
PiANCg0K
