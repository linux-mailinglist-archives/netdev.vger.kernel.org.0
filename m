Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C854354F1DF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 09:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiFQH1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 03:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiFQH1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 03:27:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5964A666B0;
        Fri, 17 Jun 2022 00:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655450827; x=1686986827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/ShLoqW+Tlig7oH6SMktyjf19cHA2Wiijo+34gyTEcE=;
  b=rk3rBFFJnFUsTqRBWHI7gXsoUutcqjnzIxdf1cRJe+fpFU2wZqejtsvu
   HHUE05cLfDCvtPvTILpivj23Q/N5EOUHxSVXntXFlggmsY7PqdiMjHWRb
   k6YY+n00WAhYD0xroiobt2OJpGaCsaw0QEKTinJ9qyqEHD8hMEOhICcGE
   6SI4rWeO24nUpj3/B2yEtJsYx0L1LrkCI1mijrRGvitn0WuwMbGwiephc
   fppHHGw+2DNHDaR87JyS/cLUjploCm+BLRIVKYPLXgPCRhJfVb1IO+6EV
   Uh1bT73LKnq+To3XXbg1hPblHMB+dl5KIFeVL9Yy2+/Nw/Uat4x8tieza
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="100472668"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 00:27:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 00:27:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 00:27:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivs1wPpiDzYaPgoSk5IQX6Xvnc079V6gH/noqc3FT7Y8/OzS8ZbZyEHME5ENYGUG1T+Xe8Dr9C9HHf2Up1BS2XHIRHHtIaXI8FxOFR58ASYpmsfyAakgdCr1CE3BBkA9mbeL4OHB5CViDOrTrBXcHiTpb14YsbNcpcsMWINH/y6Ou/SJzyFlBlFcaKFqkfhxgwD9SjT3x2dce2QUKOaqCsDC9dlXlTv5/8CT2iqSXFNFNEEoUAftv2nijYbA3HdptpwrIY3yvmKEaAG5lnOVb5TcYMEWRSYEPryEaFSSKy9hTss5SmfX5A0HJbh1HQaP94r6K6M9wBUZp0ELj0e22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ShLoqW+Tlig7oH6SMktyjf19cHA2Wiijo+34gyTEcE=;
 b=MqQfEgDqF5iPPsmbARu6RGVKwUatSfm5KL/zetTeWGacL4/gH7RCl1Xgr20RvSADb9IMefhe7u9CLAVnSl6L3v8FozmfQIfzJ8fxi9lzOxQ4ktlS9tyGkKgxM/HauH9c1uwC73urvD3w3fZoyFpxJWwsWlRtOJ7RDb5IBwUjnZ1A4cOdXAMKpGd0Xn67CvuOJbB+M/LFKMlX4lIjnRhpC1ug3PCa6JNFgk6dbqMaqWdyHwe76UPPcqUjUtj/ZNXiU/3255By8uD679b+SCzAjSILFBxNjpMbYN/guB/YCOxhOS6zvx3m5NX0dUpGpH4AtA+9t4JOcErbQcxibQfQMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ShLoqW+Tlig7oH6SMktyjf19cHA2Wiijo+34gyTEcE=;
 b=icvhas1LDhkwen8FCQRXO3YZfSBIHNHjl6lZUF+rWCr/Ikpc8eG+6+/SQDHQ13B5ssLopHDn+XwZld0A7JmEbdP6YmjwpWDmInNNJqFCSLe2RK4fIF9BTodfg5LsY24832nvfXsyda0y16DUBFPAycyeovVJVQivF7ZwLPWTwF8=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by BYAPR11MB2550.namprd11.prod.outlook.com (2603:10b6:a02:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Fri, 17 Jun
 2022 07:27:04 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 07:27:03 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <o.rempel@pengutronix.de>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/1] net: macb: fix negative max_mtu size for
 sama5d3
Thread-Topic: [PATCH net-next v2 1/1] net: macb: fix negative max_mtu size for
 sama5d3
Thread-Index: AQHYghujmRNc+iZ92km0qfGK3yoJmw==
Date:   Fri, 17 Jun 2022 07:27:03 +0000
Message-ID: <de66722b-9832-e9dc-008a-5baece0c7afa@microchip.com>
References: <20220617071607.3782772-1-o.rempel@pengutronix.de>
In-Reply-To: <20220617071607.3782772-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43a58a79-4e62-4fc8-0d7a-08da5032c677
x-ms-traffictypediagnostic: BYAPR11MB2550:EE_
x-microsoft-antispam-prvs: <BYAPR11MB2550683FAC883F1311BF048087AF9@BYAPR11MB2550.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9JZ+0/KnloeGHMuc3X+XKRf8cPue9PF/Xe4Qhl412GFUcVq3z2U+VhnFpxF5JGX2PfMx77QpsUlBjPUMyddCnyyf1wxwefYBpEVgnPb19A4xzbBLVwuokMcCahP+YLJ58MCJcc15ywfjwxMV8DcnKantirZxVhBlZ5AwDbUXmCGqbhCRe2EfRzYhEmTdJ40aMc6MilXfhB0havkI9BQ2vNHkUkQOlMVl7SLUh3OLh0PTZ+x7asWYuZsTbZL1wukpSKd4SB03rPBizuA2ZiT5EclxdvAeLpXUryVEgebwlWQdp5OjzgWfIBVlg6UdYkbPrFXkPorE9BqSewV55lEOLP6T9wbYYdy+k3UwcsDSywV9RyFe0cy+Yy2Llv+wXXIRTT9Sc4c/2EgKaIYyJ7/9T48PdgMlXIDIFu3CekL06wGcSsKh/CEqA6NstpYuS52qxPUsySer9DhUw0vM1tRWdjONqBExyWVqnq5z4tkUTx/WL6yFl1G8IC+5nkJljSH8YtFRY7JWf950ICQ9OeCnX7mcl44pxkZJtg9vHzNkqIezNpExR88dpmFR34kfyVhPG373PlTG01PJ7eQANgfDPhKEFuVB17xmXmV4b0Wyw4UyKHm0cFx5fcrndaqQV0z+F7Bvze4vwOBYhcupU/rpVS1ESr854gSL/JcCWlkS45Rj3ASS/lf7s0FzJAg+YW75Gj2rQrzdDUIdmDmP8bykNrL5WTUwRvDp27ar1em1c1MvWywIIK9cEicTiQeNLLmLmAiAozo9x7QA7EwOua6VNv4+hyhmObuIw8kS2B2gDo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(64756008)(66446008)(66556008)(8936002)(122000001)(91956017)(316002)(54906003)(186003)(66476007)(4326008)(66946007)(5660300002)(38070700005)(2906002)(86362001)(8676002)(31696002)(6486002)(53546011)(6506007)(38100700002)(498600001)(83380400001)(36756003)(71200400001)(26005)(31686004)(6512007)(110136005)(76116006)(2616005)(138113003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ky9YY1pUc3NsZzRyZ29oQ0RyNHVjcGhkbnUrWGJVajZBb1lGM0dkd2NOL2Mr?=
 =?utf-8?B?VTQzSWQ5M1N6dnlnNG5aQ01sUjBVK05udDFMWXQxdUgwWnVTcWl0STZ6Yk85?=
 =?utf-8?B?M3ZLa1FiMWttWStrYnZZbnVNZGhFVkxQZVRnZXpyait2NnpxVzN0eHNNOFVu?=
 =?utf-8?B?UHlBNXkwRmxUd3RWWXM5Y0hteDdzaXV2SWFrS053SXJiVDQ0VFV1bVNXWDIy?=
 =?utf-8?B?cm9CUW1iSFlVQWE1bS9uV2FieDVMUGZTaDM2bkhINm5tWWlLNHVDRjhmYzlz?=
 =?utf-8?B?bFI5WmF1bjU3TVVPKytOWFJvNkMzWVVUYTdCa2lhbDI3UVZoNW5JYytRTmZN?=
 =?utf-8?B?OW54RGZUenZaMjJmMnVqbEdJaFJvQWVQOHlsdWJERGZZSFpaQ3RVeTBxTlVY?=
 =?utf-8?B?SGNmUS9yM1lUb05FVTRBazg2VWVIWFVDNTFPYWtvNjNOOFZDb3I4YllzTXNS?=
 =?utf-8?B?Z1NCcEJmV1Y5NWZPRE8wd29vMjRicGhaazEzMzA5K0ozRWcwZUVKUG1uQ1BB?=
 =?utf-8?B?bU15dDFKbEs1dmJBZklZNnZnV0JLQS9kdHhhOTdRVkhtNzdLcHZ1UENrcEJH?=
 =?utf-8?B?MVczSE81N2dpNFFYVTJYUTJWcm83ZVczSmxXMWpza2lReGR6N2FuN2JTZm9p?=
 =?utf-8?B?eUxBcWpBZU96UDV1a2R4dUJ6R1hyQXg3YkROYXlKS1d4OWxzQ1BVREVock9U?=
 =?utf-8?B?K3BDME5KSmw5ZHg4cnFKNWJnemsrRS9QdkRTeWhFdHRzR2pxLzBNZDdKZWlh?=
 =?utf-8?B?dzdqbDhDcEdyZVh1a1pqSHlsSk9UcFFtek45R0xkR2szdk96OE5jREJCSkFY?=
 =?utf-8?B?UEIyVUtVbS9FcG1RNVRxeEViTHdMWlJMRFg2S2FPSDNEUHZzWHd4dHUzU0xq?=
 =?utf-8?B?TE9yejZKTTlBMjRMREhzYWkwM2k3MDNmbG5NTjZBeTlLNHcvbjJaVFdvajc1?=
 =?utf-8?B?S0YzaXo2cXllU1d2MGtEY0hhRjlyZUFubDdSUVcwWDZ3SHIxZ3dwNWlUY2cw?=
 =?utf-8?B?bEQ3TmlicFZMK1hxTkZxbGhHNkNMa1Q5S3c2RkF5bDVMd3BRUVNkZDlWeCtL?=
 =?utf-8?B?bWpTcFFVSTdheXY1RU96eldIOXJPWU5vdWY3K0ZGVWk4K3plemYrVHp0UFVn?=
 =?utf-8?B?TW82SE5ZWGM4KzExcHhQYUZETUp5dSsrZ284SVJIQWNmT0xJMXdlR2VLL3dh?=
 =?utf-8?B?aWdDTTErU0dBZkNrQlZxZ282NE1ySWI1N1hPdW1yaWV0SmpVU2VPaWRYRXNj?=
 =?utf-8?B?RHQ0azdWODFTSW9ERmRUOHI2b0FaSDgwQlk0TS84ekRqZzg4c0cwbVZKT29a?=
 =?utf-8?B?c1NRazdWSUtiRm5jVWVmUXhlL0JtcktVQlRSQlZycVVTL0FPTkowa3V1Vnpy?=
 =?utf-8?B?S3pvMFBlK3AwSVl5bVJWd2twZkdUNXhRNVd2bThxRlVsU2V6Sjh3RU85amRO?=
 =?utf-8?B?am9SL0NyMGNld29YWm9Nd0EyNk5GSU1aemZhMm4rakpTZTk5aXhXQlFaUWlS?=
 =?utf-8?B?RmJicEg5UkVYaXQrWjVtU1pSUlpBOTdQTGZMNUZBSmppVnRDZUlnSGlhdXBk?=
 =?utf-8?B?VG1zQkNNRyt4UHZMOXlHU29KN1l6RCsrOFJodUR6YVl1TldTUkxKeFdZTm05?=
 =?utf-8?B?VzNiMEMybWxXbHM2SlBZaUNwY2pnenp3c1dXZmVpRVZROXNaUTFLeDVTNng2?=
 =?utf-8?B?aGtpdE5KbkY3ams2YkxFUTBGS3JJbDk0b2FoSFE2QU1BTWhyRFF1ZEF2cGdV?=
 =?utf-8?B?RktyUFcybU10VVJkYVNoRFNZYTcycU90b1U5cTQvZFRiaWRVNnArV1htaHNh?=
 =?utf-8?B?enFzdEJSdk9kRnV6cU1RZzMveTRFMmxURTNBdzdtTitmVUs0QUhNV1lnVlE4?=
 =?utf-8?B?ZWh5cUpFRmdhWlkzR2V5MVc0bWUxdUk0SFNVVEE5Zzd2Skg2M3FCamRmWGx1?=
 =?utf-8?B?dC9CSHp1NXNxN1hPVjg5b0ZHbUwyTzFCSDYyckFUbFkyVHppeHFJVEt0cGF1?=
 =?utf-8?B?aG5LbytJbUhwRFpEQ2thMER5YWw0NUFVTitVOWc0dGxJWDdUSkk0VGxhODdM?=
 =?utf-8?B?OVRtSlJDVU1jODJiV1dPSTZ3ckltZ1VNRjh0QXN4aXBick10Z1BqWE5ROERF?=
 =?utf-8?B?Y3poYk9RUXo5cm5qZllIRHkxQnFsSnQyaWVwQVRpK05uMnFEVXMzc1JNR2Fr?=
 =?utf-8?B?bFNIVUVyTmFpYlh0QStON00rc0hpMUgyaWVvSm50eHJnWlNqK01Cd0hJUDNk?=
 =?utf-8?B?eEIxVitleDJnTitrQ0duN2xXYnNVT0JqRTFaMXdoazR1eTBMR0pJTDA1bTUy?=
 =?utf-8?B?K3N0MCs0UDRmVmJ0UmZiWjZVWStEUllxTlRjeFFMZUNxNm5rTkszTm4rWURG?=
 =?utf-8?Q?mIiljIft+zdOkpWU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F40EF8B4655A9945A7DC2B469022B1D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a58a79-4e62-4fc8-0d7a-08da5032c677
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 07:27:03.4155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYLm+HDe+jRQgEUUWet8fAUE4ooUBTvoKiHyIzXnimb5kTfl1sqUlPUEFytlXj6Jr++qhV0jmsWUVMQ7I0SrgxcmIRKvxeXY6QIRAmkJKZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2550
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTcuMDYuMjAyMiAxMDoxNiwgT2xla3NpaiBSZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSk1MIHJlZ2lzdGVyIG9uIHByb2JlIHdpbGwg
cmV0dXJuIHplcm8gLiBUaGlzIHJlZ2lzdGVyIGlzIGNvbmZpZ3VyZWQNCj4gbGF0ZXIgb24gbWFj
Yl9pbml0X2h3KCkgd2hpY2ggaXMgY2FsbGVkIG9uIG9wZW4uDQo+IFNpbmNlIHdlIGhhdmUgemVy
bywgYWZ0ZXIgaGVhZGVyIGFuZCBGQ1MgbGVuZ3RoIHN1YnRyYWN0aW9uIHdlIHdpbGwgZ2V0DQo+
IG5lZ2F0aXZlIG1heF9tdHUgc2l6ZS4gVGhpcyBpc3N1ZSB3YXMgYWZmZWN0aW5nIERTQSBkcml2
ZXJzIHdpdGggTVRVIHN1cHBvcnQNCj4gKGZvciBleGFtcGxlIEtTWjk0NzcpLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KDQpS
ZXZpZXdlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+
DQoNCg0KPiAtLS0NCj4gY2hhbmdlcyB2MjoNCj4gLSBwcm9wZXJseSBkZXNjcmliZSBmYWlsIHJl
YXNvbg0KPiAtIHNpbXBsaWZ5IG1heF9tdHUgbG9naWMNCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgNCArKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGQ4OTA5OGY0ZWRlOC4uZDBlYThkYmZhMjEzIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTQ5
MTMsOCArNDkxMyw4IEBAIHN0YXRpYyBpbnQgbWFjYl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpwZGV2KQ0KPiANCj4gICAgICAgICAvKiBNVFUgcmFuZ2U6IDY4IC0gMTUwMCBvciAxMDI0
MCAqLw0KPiAgICAgICAgIGRldi0+bWluX210dSA9IEdFTV9NVFVfTUlOX1NJWkU7DQo+IC0gICAg
ICAgaWYgKGJwLT5jYXBzICYgTUFDQl9DQVBTX0pVTUJPKQ0KPiAtICAgICAgICAgICAgICAgZGV2
LT5tYXhfbXR1ID0gZ2VtX3JlYWRsKGJwLCBKTUwpIC0gRVRIX0hMRU4gLSBFVEhfRkNTX0xFTjsN
Cj4gKyAgICAgICBpZiAoKGJwLT5jYXBzICYgTUFDQl9DQVBTX0pVTUJPKSAmJiBicC0+anVtYm9f
bWF4X2xlbikNCj4gKyAgICAgICAgICAgICAgIGRldi0+bWF4X210dSA9IGJwLT5qdW1ib19tYXhf
bGVuIC0gRVRIX0hMRU4gLSBFVEhfRkNTX0xFTjsNCj4gICAgICAgICBlbHNlDQo+ICAgICAgICAg
ICAgICAgICBkZXYtPm1heF9tdHUgPSBFVEhfREFUQV9MRU47DQo+IA0KPiAtLQ0KPiAyLjMwLjIN
Cj4gDQoNCg==
