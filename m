Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC56B2418
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjCIM0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCIM0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:10 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2063.outbound.protection.outlook.com [40.107.117.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF2DEB886;
        Thu,  9 Mar 2023 04:26:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBL+EVgp5OUg0SzJU5Ow4m0CYzykhIFPhyGFmQkUQUo3kAxIidgPOBU2D+/FpizdGmi1N5dcrdipXo0zxlI3fSoJqBCqGvBDT1MHIrAJbVCHOLG9RJ9G2WjRXSxovMZP235dLP3/rgeHsFPtCGTU4dpioNiUrA/7xwoy+D8Vko3f/I+1VIIp3Kbww5cNWsV79a9oC177p8WAWKQrHjShfmO+WNHYZImSi+ycuBzyBOgDfAgcnpwX2Gz7e9/hGGsZBbFRG7ft5YwrfLUcjPuXXkvABIVyLvulHQi35zV/Pir8g7/QvkK+4JCBjBzlHF0qgEWz0Z2jsC+Vw8SJu/PNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYH35GGoyOy5pn5rQsQNKo8uXa85R2SxQrRK1WNnKfc=;
 b=iBEvLP+ZLisbgeeYoNL9iLpIJXRMH3KsT2kXFIyTmx4HC78L6OPK/z7V/danSRftD7RUA2ifE06bBLBhU61pzNq+xYIiDI1Aew7jJHmHEqB8qiVxzdrHYM/hD7CZ391Ohp6ClgPuVphRXqgipHB+yKyMufxJrxoFmnAPaKzoHxgbWsTmjwC1FAHODkn3PK6iZ/q8+AkNOhEtL68z7Gmhsu3bHirFLT3wvukuXI5gIIGtey/uHmtQfG9DpDqZw/NxrHobUlbbJFwZINPrz3Sr39+ExL7itXM0akVHKeDWH2lVrW6NUiM4CFh9kBSsBAEI7gTYgYqXUNTtAeCUBNoEAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYH35GGoyOy5pn5rQsQNKo8uXa85R2SxQrRK1WNnKfc=;
 b=iJfkcqMQSxYH2ugzryaLcCFt/DYMaFTpAOmn3vVDDtPuws8Prz8RR439JqSs88vRKQ/dden+0SNOQjwsRuzX6vOidGjwvM5pSWYBYx4MEWFubJV6vXOCCPruil6rrlORvTTcjhOAXYYHexAlyWEXoXbxhmPKoqbVFRXLyAdEpwj6eqSBdaiyUJlFn4bOGTzfbZTKAgp9ef+19Sj5t1d9YILzoUaAA4LqLQKUUERK2MBxhx56lbxIso2nWFoGdPpu/gVHdAfmaXtrNqDlU8fPrhr/X3PgJXrvmkpV8i3vxhSFf2NfBWMVjYb1fVGwidkXIEhmTD5pa8DxmFv2d16itg==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by TYZPR06MB5640.apcprd06.prod.outlook.com (2603:1096:400:28e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 12:26:03 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::47ae:ff02:a2c9:845c]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::47ae:ff02:a2c9:845c%3]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 12:26:03 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: RE: [PATCH] virtio_net: Use NETDEV_TX_BUSY when has no buf to send
Thread-Topic: [PATCH] virtio_net: Use NETDEV_TX_BUSY when has no buf to send
Thread-Index: AQHZUlvJVaF65+0La0G3anKk81ITKa7yRcUAgAAVJpA=
Date:   Thu, 9 Mar 2023 12:26:02 +0000
Message-ID: <TY2PR06MB3424EE070926DE5D1B2D141985B59@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20230309074952.975-1-angus.chen@jaguarmicro.com>
 <866b9077-1600-4c93-3da8-4006cbf6abe7@huawei.com>
In-Reply-To: <866b9077-1600-4c93-3da8-4006cbf6abe7@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|TYZPR06MB5640:EE_
x-ms-office365-filtering-correlation-id: e421615c-bd0d-4a86-f6cc-08db209972ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pL4PwRT5lJiTKlrd9EGi026v9O/tDC7/lfddky9B+AW/OXjvAIp8Yma+9qtJfJT63Wa7b/76e+u0SpKT7Y/V2hQV4mn+MsYN1WXgtxlGlLf+29O2MonWCkcwg/MT2VuESF1bt8LPZixwEwdlZ7wHaMDozrULKo3ZjUCQgcoeL3BiD5nTDQeJ2Fl5vAvQDuf/FcGEOEa8oczCt0xQXzu7Y6nqOikM0XZQWLpBmWcxBzjX9VIu9ao5TJKP+gcP1nvLX9G9vdClYWlCCvqbew5IXRUwCWCkXquNdT1FYNYXwxOBv/vN/b6AHmf6+d1O1qYEMgQ1YaRl7AOY7+TQ8/KW4XKhEo4sgdIthHsTCtB2r32Z29X8R8wPJREPqvgvUPwTZOKwOubTTsyJEYIdubRg+CIj4S47Q798eHVq+UiJqfg877+h0MOaS8pBXB01VhWER1QM8mYaCneqlphXoV5ZwSM6CXoVaBzjJ40tqG7Hv/gxaMMjBBj+MIDiBMAIJ5TMTcrqIQ/SnGZfDKc6Q7pqglx8tZYTZhDhirwZh80sXYm7LZQmHQ/Ia8mLkEZLzvyQccYS7G3qZjC05Y4dvRCS4lSfw6ad4QxlVqTTQ6DNfRlwxP6FH9kVFv7t/K0fnUFKJWWOxh8bpwuqrElK/8Qlmds0h7eNfnBPi0acvaMFyhwtxdeQgHEqYYT6tfMayMnkNo5iyrY1AVu4KIPooLa7yA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(366004)(136003)(396003)(346002)(451199018)(33656002)(54906003)(110136005)(478600001)(966005)(7696005)(316002)(5660300002)(71200400001)(7416002)(52536014)(2906002)(66476007)(8936002)(64756008)(44832011)(76116006)(66556008)(8676002)(66946007)(66446008)(41300700001)(4326008)(122000001)(186003)(38070700005)(55016003)(921005)(38100700002)(86362001)(9686003)(53546011)(26005)(6506007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rzdsam5kV0w3aVgwNjRUZHhWYWprN1Rta0czbkd6Z0Mwck42SFBnaGFoRDhZ?=
 =?utf-8?B?c0Z2c0pQQ1I0N3dpWFpua2MyeUdUNDJhb0FEWWhhUHhvdExrb2dsSXRscmhm?=
 =?utf-8?B?VUNUSWwrd0hqZGkwYkVBYTh4VW5YUit0VkQyMmJIcDE0VWJTMjZURkMzaHRx?=
 =?utf-8?B?NWxjOVlicElIYVlCUkhqRmZvVmpjdkxjRlpKSko2bUI1anErZzN3d1ZWVEtI?=
 =?utf-8?B?N2pVSFd6VzZaME5MQTQzT3lTc2xId2h4aEh1RVYrQjZCOGhiU1JMa0hUc0ha?=
 =?utf-8?B?TVlQUjdOWjBFNnMwT3JPNjA3TDg4cFZ6clJUVUptUXhDdkdETmhaTTZsa3lK?=
 =?utf-8?B?akg5L1NvcGF1d3pqWm9LRFpYYlhRa2ZLREVDdVVWaFhqeHNtRWxaUHFHMWFE?=
 =?utf-8?B?bCtyV05Rb2VxQVViYXMwVHFFZ21EOHhuTDcxTzZWbmRCZWVIR0lUK013SVM0?=
 =?utf-8?B?ZWZhNktmdXpBaWRqcTFscUNHWkZuREpjRjY0UjZxNWx2ZXZvb243dzczL0xq?=
 =?utf-8?B?S012dHdpUkhQSlFxaHVJYXI4OHBNQzVibFBMczRkNjB3azA4SVdUWHlLYXEw?=
 =?utf-8?B?LzZrMHAxTm9NU3NYMGowajNERU0weVcySDB1aVVieVcrUk1ublN1a2x0aDRw?=
 =?utf-8?B?ZU5rd0p1cWsxcnRHYnlSd3RUNnlSbFA1czVYdnRuaUpSS2F3b1BFNC9EOHdG?=
 =?utf-8?B?L3kxdzd2RHRXRUVvWGJCelBVbDdnMTgvWUpIY2VoWHBRS2lDN1I4NUZ0eEMw?=
 =?utf-8?B?UWRkWXZyUGI1U0puVGE3T3IxVEFaWjFybCt1UzV5dmFGYVZVTnhiVXpuYjNM?=
 =?utf-8?B?dmpQemx5cFV6UkdIczFKVzFZNVhiQ0pibmZrNXdsTmNJSkFzdUZ2QVFuYjl2?=
 =?utf-8?B?U2JadGVwOGF6dE9kRk5XR3RoQ0F5SCtKYm5POENwOWh1aGgwR3dKSk1qRTNr?=
 =?utf-8?B?MGl4SFlMamtlNnc0c1ZmaDRoWlJaaEVqU2w1S0VSbGhKdnJGWWI2ZldHV3Z2?=
 =?utf-8?B?UFZZek14d1Q5dmQ4bjRpVWgzdmwxdk02OUp4R3RXckFYV1pqSWw4bjVMRzBF?=
 =?utf-8?B?T3o3ODdBcm93UHpXNzlaUUpkM2MwaXZleXBGWThCTldpbE1JY2xZVzhLT1li?=
 =?utf-8?B?WkhGVGJhWnpCL3l0RmxuN3dHYnFlRG9GUG91c21JWFNOTldKWisyeXdncWhY?=
 =?utf-8?B?MjNzUjZwd2UzdGxWNjhEWDlvam9maytTSFlPOE1Ocm5Gb2xEKzMwQTJjaVY0?=
 =?utf-8?B?YlVMeUZnOTc5cEpldGlIdXFBdGh4QlJha2t2V0dIM3pjWFZ2OUt2QndTcVU5?=
 =?utf-8?B?d1RZa1RIU3ZZU1Nwa3YzbHdPYkhaZHgxaUVYek0yRTd6NlprMjFsV2JBckNz?=
 =?utf-8?B?K2kvN0p0VG12NFhkeVlycTFzNHh2VklwWXlPcTQwUUlOVkM4ZVU5cy9heEVG?=
 =?utf-8?B?UWVwU1pkZGhHbDlyMDBhV2ZNUDVZditpWjZ3VDNGUVVuVmZWYWtmaGt5QXJz?=
 =?utf-8?B?SXR0Tm10TDJMM04zaUJhdHJzQjFUYWZBMGl2NWtCa2ZDUThrOFVJY1JtRkpP?=
 =?utf-8?B?SEM1VFJPNUdQZXk0dE5jVHZpMGFLOWh6cmo0cFArUWg4WmFveGh2T3BoU2pI?=
 =?utf-8?B?allWWTNVRDB1alB1RUhidEFmUGJHMFMvYjRuZzJQOUNpTE1jbERFbUI4OG9S?=
 =?utf-8?B?Q09XSzBGYnBDQ2VJaGRWVWp5NmcyeCt4RXNvYU1TVXNvdTgvWWhCWEI2ZUh2?=
 =?utf-8?B?K2gzdUlmSnlVUjJYZlZUUDhpZDZaaVRwSW8zS2k5ZFpraHhqNkpLR1Btbnpr?=
 =?utf-8?B?UW9VN0l1Ky9SdGtZT0txcm94MkMyZ2lkeUhsOE9EbWRRZ0JSSFpiK2VIWU0y?=
 =?utf-8?B?a205WFFXSUh2bGRnb2RONVNzMDZubFdTa0kxcFJjU3NheFlxclN5VVJyNWFM?=
 =?utf-8?B?Ky9WNXp3VFNnMUFTQ2RxTitwUW9BdkVIY3RaVkZlT1Q0bjdRVm85aytrOHpS?=
 =?utf-8?B?RWZGbFAyWXp1Wm9LMFBpTEo5WTNVOGsyTVhTYzRETmVvbndwMnZLd0lOdEty?=
 =?utf-8?B?eTM3dWk3SEpqRTVOaW9yVzMxbEMvUDVXQlJjNkFnTmFlaFFHVmcwc0JVOFQ0?=
 =?utf-8?B?amZOMzRhbGxXUG9JYiswa3kvZ2U0K2FoV3R3cEpadHpXMW1aOVFlbEZkUUNY?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e421615c-bd0d-4a86-f6cc-08db209972ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 12:26:02.9685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WENaslZyIVqp/lhIvt5nTJs+UQwNGIhKHdTPSjptdFLcymGXzZZRwyOMb1gz1BlwDdBLwej7jTzZDLQgnlMOIWPHxD+2lIf/UrCzGX/YMh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5640
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWXVuc2hlbmcgTGlu
IDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggOSwgMjAy
MyA2OjUzIFBNDQo+IFRvOiBBbmd1cyBDaGVuIDxhbmd1cy5jaGVuQGphZ3Vhcm1pY3JvLmNvbT47
IG1zdEByZWRoYXQuY29tOw0KPiBqYXNvd2FuZ0ByZWRoYXQuY29tOyBkYXZlbUBkYXZlbWxvZnQu
bmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRo
YXQuY29tOyBhc3RAa2VybmVsLm9yZzsgZGFuaWVsQGlvZ2VhcmJveC5uZXQ7DQo+IGhhd2tAa2Vy
bmVsLm9yZzsgam9obi5mYXN0YWJlbmRAZ21haWwuY29tDQo+IENjOiB2aXJ0dWFsaXphdGlvbkBs
aXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZzsgWHVhbiBaaHVv
DQo+IDx4dWFuemh1b0BsaW51eC5hbGliYWJhLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
dmlydGlvX25ldDogVXNlIE5FVERFVl9UWF9CVVNZIHdoZW4gaGFzIG5vIGJ1ZiB0byBzZW5kDQo+
IA0KPiBPbiAyMDIzLzMvOSAxNTo0OSwgQW5ndXMgQ2hlbiB3cm90ZToNCj4gPiBEb24ndCBjb25z
dW1lIHNrYiBpZiB2aXJ0cXVldWVfYWRkIHJldHVybiAtRU5PU1BDLg0KPiANCj4gSXMgdGhpcyBm
aXhpbmcgdGhlIHNhbWUgb3V0IG9mIHNwYWNlIHByb2JsZW0gY2F1c2VkIGJ5DQo+IHhkcCB4bWl0
IGFzIFh1YW4gWmh1byBpcyBmaXhpbmcsIG9yIGl0IGlzIGZpeGluZyBhIGRpZmZlcmVudA0KPiBj
YXNlPw0KWWVzLCB0aGUgc2FtZSBwcmludCBpbmZvLg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbmV0ZGV2LzIwMjMwMzA4MDcxOTIxLW11dHQtc2VuZC1lbWFpbC1tc3RAa2VybmVsLg0K
PiBvcmcvVC8jbWM0YzU3NjZhNTlmYjhiZTk4OGJiNmE0ZGZhNDhmNDllNThkZjNlYTYNCj4gDQpF
bixJIGhhdmVuJ3Qgbm90aWNlZCB0aGlzIHBhdGNoIGJlZm9yZS4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEFuZ3VzIENoZW4gPGFuZ3VzLmNoZW5AamFndWFybWljcm8uY29tPg0KPiA+IC0tLQ0K
PiA+ICBkcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3ZpcnRpb19uZXQuYyBiL2RyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYw0KPiA+IGlu
ZGV4IGZiNWU2OGVkM2VjMi4uNDA5NmVhM2QyZWI2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L3ZpcnRpb19uZXQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYw0KPiA+
IEBAIC0xOTgwLDcgKzE5ODAsNyBAQCBzdGF0aWMgbmV0ZGV2X3R4X3Qgc3RhcnRfeG1pdChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLA0KPiBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiA+ICAJCQkJIHFu
dW0sIGVycik7DQo+ID4gIAkJZGV2LT5zdGF0cy50eF9kcm9wcGVkKys7DQo+ID4gIAkJZGV2X2tm
cmVlX3NrYl9hbnkoc2tiKTsNCj4gDQo+IFJldHVybmluZyBORVRERVZfVFhfQlVTWSB3aWxsIGNh
dXNlZCBzdGFjayB0byByZXF1ZXVlIHRoZSBza2INCj4gYW5kIHNlbmQgaXQgYWdhaW4gd2hlbiBz
cGFjZSBpcyBhdmFpbGFibGUsIGJ1dCB5b3UgaGF2ZSBmcmVlZCB0aGUgc2tiIGhlcmUsDQo+IGlz
bid0IHRoaXMgY2F1c2UgdXNlLWFmdGVyLWZyZWUgcHJvYmxlbT8NClllc++8jHlvdSBhcmUgcmln
aHQsIHdvdWxkIGJlIGNyYXNoIGFmdGVyIEkgdGVzdGVkIG1vcmUgdGltZXMgLkkgd2lsbCBkcm9w
IGl0LHRoYW5rIHlvdS4NCj4gDQo+ID4gLQkJcmV0dXJuIE5FVERFVl9UWF9PSzsNCj4gPiArCQly
ZXR1cm4gKGVyciA9PSAtRU5PU1BDKSA/IE5FVERFVl9UWF9CVVNZIDogTkVUREVWX1RYX09LOw0K
PiA+ICAJfQ0KPiA+DQo+ID4gIAkvKiBEb24ndCB3YWl0IHVwIGZvciB0cmFuc21pdHRlZCBza2Jz
IHRvIGJlIGZyZWVkLiAqLw0KPiA+DQo=
