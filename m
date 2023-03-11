Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835016B5DB3
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCKQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjCKQO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:14:58 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2024.outbound.protection.outlook.com [40.92.103.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B9B1C7DD;
        Sat, 11 Mar 2023 08:14:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5d2+f0B5K/sDr6hrKpxs/+kpTNdvGuQn8mgMmXPoaPgSWF1O9XtKRZIlWidQEcuiT/u64wYa8UeujqJerM/Mtknc6l7LgCglCJuBixrEvNYOrvsS+u9NDFG6JG76DjrzOwPBRQOsW4xtXADTdUmOZF+wWRq/3P9NixG7xDdbJ8/rGvaag36Lx3mkK1R+nUYUz8EOGTdPAjQjDJaNVc1M8bFgKhLmXyiHyz419lpdb7EOIVydtaFCMsQfMNdJ2yNue2bPogGGtHG77p9pv7CEDC5M3rEssmeZNw/FGedHzElt3nD5UK95oNme/QxWP6ihpPDht5GcjsmkxHq//zUZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YH62y4W8TRpLgFFfd1GZTiEfiScHNviQwtGCLXE4zKo=;
 b=niGFWTdMs2Bf4arhOa9444wBCrcrAq9HJHKgdaE77w8BtqwNTj1MuccB+kfIniGFzYB2XbwFRT5pkWgHRccyu/7sy4d75QBUUw25kcGTKk303DGqp8Kga3EnH90O+Bw69bjFXRbD9To/aPPMWAoKRjabr41Sw6Uo8WwjOazssh6bWtce9ew5WnWLWyNR8lvFzT+twZDHoVWebBvbM42aeGxDCkxaRlvjgKLHatd9mvP+XlucWdMrpLqhLG/7hPJc+mHcM2mj8OEkqaoOd8oWMtfRzHoMPpUhJ5OkRp95e0WClJROv1ooO/3SY5Ae/Ohg1XIVxgFS20UvpgP32l/HRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH62y4W8TRpLgFFfd1GZTiEfiScHNviQwtGCLXE4zKo=;
 b=GzSYOBZ2ZaxJQTizsbx479iWJLgcp6GXfylKg0QZO8/zqOOH/GawoZtN5xjPlz+SXl1DY5h2OBvf/zf9jmINRMI/g5lFDAvMVuROoK7SsOmXkiyu9Em4etNVbBjuMT8Zm7FukggyFXNxJCzYe3JKUh0iN0sSWRISq+MHNnNC0ywc8ZPIMNOXV537pYa8E2x5z/WO90STTdU4TwEk6Z4xOFDauJzndw27gLH2VSufo5dpoWieGzvkR8NkkaahJtyG9+29PDyQP0Ybd0nftt2rFnwr7MHUIQ5ONN7GqNoJw5U1+68ql/shUo8K6o9xSlKIA8MSpsY0iIZArw2JsUcuzQ==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN3P287MB0719.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:104::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.23; Sat, 11 Mar 2023 16:14:51 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::945f:41d7:1db:1fd3]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::945f:41d7:1db:1fd3%9]) with mapi id 15.20.6178.021; Sat, 11 Mar 2023
 16:14:50 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Hector Martin <marcan@marcan.st>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Orlando Chamberlain <orlandoch.dev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [REGRESSION] Unable to connect to Internet since kernel 6.2.3 on
 T2 Macs
Thread-Topic: [REGRESSION] Unable to connect to Internet since kernel 6.2.3 on
 T2 Macs
Thread-Index: AQHZVDIZrgKVD5BwUUKnSeJZZ1urjK71vpoAgAACOO8=
Date:   Sat, 11 Mar 2023 16:14:50 +0000
Message-ID: <MA0P287MB02174F4D7DCE81499B843329B8BB9@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
References: <MA0P287MB02178C2B6AFC2E96F261FB2CB8BB9@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
 <e5d36d19-624e-ad0e-cd90-8b188771e41d@marcan.st>
In-Reply-To: <e5d36d19-624e-ad0e-cd90-8b188771e41d@marcan.st>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [YrLVj3Q5Ae4OHZ2qAu3w0X0fKohaKaBQ]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN3P287MB0719:EE_
x-ms-office365-filtering-correlation-id: 56799ec9-de39-4e7b-0472-08db224bbe06
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 60EH2UdVWkcDyQNUDAoNJ5dkD7WKmqxZJfYCrIjb6NQY92LeMW2ioxnFCzg9OO9B4Y7+VMSAwsb+j3ZuIjFLqkttS+vXSSGSLRI54yZjDj7CLVTjqlF26pnSFK9EETRim2b9LJOq04BltZEfa0MC78LeqY19+gOKplXSxes5jLVCoHwsfJqXJZfgFUWtVJ4xdZbRMRTz5YjEl53jAdbFq55BbcsOBG840+UD/BlvjUI8mnF8yNvoRU+B1y5LDff057m2I+X6EBk+o7RIDdYSIkKQaCpAeLmTuMqFOe3Xu1NWNesU7WprRC1nNJQ28ovnFFIy7J1aeVlzUJNpiSt3I/ol8o4z8gCR55YE2isk9yi3l5mijzSLGmKI4JHD7hroMrnNmCk8UVa99LyNQ6/9nQReCg2S9yf5NhrVztJO918gsLtDL+QjhXEn46FaNah0mQz3ZLOYZcxYGsQaZX73AgtojsMtgNsOfc3LDWQMFTdwzV0SBpSUWqc7/+EwHk5vglfMSdb1o3MW9kepQaYTFpnAmEZp5iJH01CRSkeCx+Q1iFpYqvLjyEKAkqmQcuygpZ8Yrb505jfxlsun7bp934J4vPzyQXF7xIwr0fkPH20HWoED2TAfGQr1nYXcD+xb
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGtielpZT2pYdnNHRGZoMjZnZEJ5b2c4YWdqTk5CaHFzSmxUcy9saVdwREht?=
 =?utf-8?B?UkpranE2bE53dURRcWR0R3hwSm5LZ1Y1RDUzSGgraVFkRWRRSnpxb2pVZHhM?=
 =?utf-8?B?dUpCWVoxZmRNQ29jY0NGTm9WcEx1djdzNVhFcGlvMFNWMVlNcDJOUFRPYkl5?=
 =?utf-8?B?b0dQbXo2RllDL2c2RXZmZmhyNUVzTEgybzZBTm1WMUNuRUNYd2FKVXphWnVL?=
 =?utf-8?B?U3BtUnpDWHkzeStmeXVpVGpsbm85YkdSTlVGbmtBT0ZDbDNrWXZZUEhWNHhu?=
 =?utf-8?B?c1NtL3U3UGwzYjkvOUpsa2szdVhkemVtYTlNYkhNb1pYQStUdnZ0UHFTR0x4?=
 =?utf-8?B?R0xPcStXQ0VIT05aeWpxUkJKcnY3NU1ZNjc2MTdwblU1WDlBV24yVk1ldEIz?=
 =?utf-8?B?N3BmOE5UbExaNDEwWDVrTjNxWFJ5VHV6WHluOHBENGNVY1VMcDVPSDF6WW5i?=
 =?utf-8?B?aW5VU0daR2lmT1FhU0pOYnBCdWltT3dDWnZ5VjZDbTVQRU4vUU83ZG9VL0Zm?=
 =?utf-8?B?RDIzUlF3eUVLaFh2OHhLQ0RxbzVDcmJEODY4U3VGdFJ4R1Rzb09MMW1ub1g5?=
 =?utf-8?B?QWtUT3VTaXd3dFNOUFhoUU1UcXVkd2pQSWdyTXBVMHptSWpSckl0WEhHRmh0?=
 =?utf-8?B?WE51TDBqWlJTRXdwWENqN3pXREZHb1NCaWloSjRUU1dkcGJ2SjBuT01mQlZL?=
 =?utf-8?B?Q0FLdUp3RG9IZmNtUlNmK3Y2U2prNmNpREhYczBtekRmR2EzOUpRQjhxWFR0?=
 =?utf-8?B?cVpZcGE1Y0t6YUlOaytkNWxhZGlWSW5Fei9aQnJrdTZUV3RZZjJEUDJielMv?=
 =?utf-8?B?enNsMWlCMXRaNDhHSXNUSG8venJOTkYrVnJOZU9XTTRVbEg1aU11ZjdnY21n?=
 =?utf-8?B?OTIvYm12QWNKMldsdzVKQnI1VHNUNm4wcTM5OVFWRHFJOUVrMEFxNzdFdXov?=
 =?utf-8?B?bGJuNktGLysrOGY3S0JnUXAyK0VKbjlCNDc1M08wZno3TzB4NzhXWVFmeHR4?=
 =?utf-8?B?dkJaY3ppc2hjb1I2QVBDS3NabVlVRWY0eGZEYi9LY1A1OEJQMkgzQUoxYlJt?=
 =?utf-8?B?WldJY2Zab3lrWldROXVXQ0RyYmc1cjNZS3VOSGJKSlR0TXpFMUR1aDdaN3Ft?=
 =?utf-8?B?MnJreVdwVVgrNE01QW50LzRKNERLUzVLVnF0SEVnS1o2SXJad0VVeXF4aEN2?=
 =?utf-8?B?LzJhSS9SODZQSEI3QW90cWlpL29LMGtpVVZjRUIvY21GSk54bCt1a3ZWZTRY?=
 =?utf-8?B?UkRkdUdoalI1V3YrQk42OGNSZXJ2aTFOcVEzbnBwaCt3empIRDEwZHlQQklS?=
 =?utf-8?B?OXdGdWQwN0tEK2lZV05MbU5MenllZmk4bVFGTkROd1VPa3dYa2F6UkhGUXAy?=
 =?utf-8?B?SGtkMDBNS2pYMG8zRVQvUTBFRmN1a1BVZ1hwd3RtblRvRTYvOEdHa3I5SGl5?=
 =?utf-8?B?SlVNdGRxRDY1MzdmaXd3MzlNRlJadGJ1ekRnR0FuTFpLS1Z4MThaajRGV2Ju?=
 =?utf-8?B?N3VLYitNYXJIa0ZtSUFDN1lzVFVVNm9ubXBOZDk2T09CdDZhbExMMDcvUmh1?=
 =?utf-8?B?NW41cWtsazlpV1FGZk04aVhuSVNUdm9zY1YvUjk0SzIyRkJPcEs4bmJ2VWNR?=
 =?utf-8?B?cTNoMC93UnMxRkN4a0lWeGhTTkYxVzQxL2tldXJqQTRGL2x6TkhZYUlRVytK?=
 =?utf-8?B?TXFDTm5PZjk4RnNOVWg2bFpCYVdjVHNQWVJ1VEtRcFNVaS8wWHlQckJnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-bafef.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 56799ec9-de39-4e7b-0472-08db224bbe06
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2023 16:14:50.8545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3P287MB0719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTEtTWFyLTIwMjMsIGF0IDk6MzcgUE0sIEhlY3RvciBNYXJ0aW4gPG1hcmNhbkBt
YXJjYW4uc3Q+IHdyb3RlOg0KPiANCj4g77u/T24gMTIvMDMvMjAyMyAwMC41NiwgQWRpdHlhIEdh
cmcgd3JvdGU6DQo+PiBBIHdlaXJkIHJlZ3Jlc3Npb24gaGFzIGJlZW4gYWZmZWN0aW5nIHRoZSBU
MiBNYWNzIHNpbmNlIGtlcm5lbCA2LjIuMy4gVGhlIHVzZXJzIGFyZSB1bmFibGUgdG8gY29ubmVj
dCB0byBib3RoIHdpcmVsZXNzIGFzIHdlbGwgYXMgd2lyZWQgSW50ZXJuZXQuIEFzIGZhciBhcyB3
aXJlbGVzcyBpcyBjb25jZXJuZWQsIHRoZSBwYXRjaGVzIGZvciBUMiBNYWNzIHRoYXQgaGF2ZSBi
ZWVuIHVwc3RyZWFtZWQgaW4ga2VybmVsIDYuMyBoYXZlIGJlZW4gd29ya2luZyB3ZWxsIHRpbGwg
Ni4yLjIsIGJ1dCBhZnRlciB0aGF0IHRoZSBuZXR3b3JrIGhhcyBzdG9wcGVkIHdvcmtpbmcuDQo+
PiANCj4+IEludGVyZXN0aW5nLCB0aGUgZHJpdmVyIHNob3dzIG5vIGVycm9ycyBpbiBqb3VybmFs
Y3RsLiBUaGUgd2lmaSBmaXJtd2FyZSBsb2FkcyB3ZWxsIGFuZCB0aGUgbmV0d29ya3MgZXZlbiBh
cHBlYXIgb24gc2NhbiBsaXN0LiBCdXQsIHRoZSBjb25uZWN0aW9uIHRvIGEgbmV0d29yayBmYWls
cy4gRXRoZXJuZXQvVVNCIHRldGhlcmluZyBoYXMgYWxzbyBzdG9wcGVkIHdvcmtpbmcuDQo+PiAN
Cj4+IElmIEkgeW91IG5lZWQgc29tZSBsb2dzIGZyb20gbWUsIHBsZWFzZSBkbyBhc2suDQo+PiAN
Cj4+IEFsc28sIEhlY3RvciwgSeKAmWQgbGlrZSB0byBrbm93IHdoZXRoZXIgdGhpcyBhZmZlY3Rz
IHRoZSBNMS8yIE1hY3MgYXMgd2VsbCBvciBub3QuDQo+IA0KPiBUaGlzIGlzIGFscmVhZHkgcmVw
b3J0ZWQsIGlkZW50aWZpZWQsIGFuZCBhIHBhdGNoIHN1Ym1pdHRlZC4NCj4gDQo+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LXdpcmVsZXNzLzIwMjMwMTI0MTQxODU2LjM1NjY0Ni0xLWFs
ZXhhbmRlckB3ZXR6ZWwtaG9tZS5kZS8NCj4gDQo+IC0gSGVjdG9yDQoNClRoYW5rcyBmb3IgdGhl
IHVwZGF0ZXMgSGVjdG9yLg==
