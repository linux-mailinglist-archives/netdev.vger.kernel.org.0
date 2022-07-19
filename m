Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B530579463
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiGSHkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiGSHkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:40:20 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130058.outbound.protection.outlook.com [40.107.13.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F9DBE36
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:40:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXOGn0uYIeT0CdYgHnsMkRh6aV3+OziQZx+V/eqBgOoc9N3jsHP12VqLjlcvGi1ScOgh3QAK9OU1t172myoC6FhF/4JUvERrNo0gNM91laqUi95GvZxNLrbYJVXMuTNXOHNh7sRPMpEKJ9RdYSCSDn/kHcRXh3C7H/OJDnfsNj2JTYbSoR06KqhOlQ8Ny2cKJSddrNdNMsjA8zg+53YnleYO0wCP0DTJYdHdaD1BW5WvrfwXQ8I5Q8UhCh2khRNAFqs8gEuCNorAQ8zjiz8ImAZp+TaiCCHbSvvpe+5ALRXLCVJgbNyWmnHyOt6ju/niNznJmOV7RWVYrSawRUMCBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxtmaN0h29UXGvIBdieAGNqC7sA21l3KOHEf7zeqqFg=;
 b=FqIXv/54lvUhbUyHlVzNS3KzB0OxGZoY8ZiFW80Wvmqr+72DwUazRWPmKiSLt+wA1YHsPaBBd1EHJ3b1TPhzQGd3JBaYNY4A1DaRS1ReuALOVk8/swgd6dBROeJ9zYrQu3YDwsCtuTpyfUkv1gfeYipxWjSgCqnBTEZ8CuHMcBWwKAXlqSyFP/6l6JVdrs5hZ01K3IgCATiZxIYsQMVgLZzobZUDLTaft/MGUDMnsJHwAqz/B1g+HUItKfvUMuMqL4hK1kaVwaLSpLg20hBnBvU/pc8u58SPXJMhjftaiULRqh16yJH5lFG84d5zE3KsLRs8kB7mDOA1qEoM9dqNwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxtmaN0h29UXGvIBdieAGNqC7sA21l3KOHEf7zeqqFg=;
 b=Q2Enr+oCm6ovig/uIhDS/paUdx7JBgIh16FRpkbZfNFgMu2jCjWW1GZ87MYp6L6rZwraeC19Ahv/2FbW0QA3xSnCF7lO290Bd+Xk04NBHJt8cE5XbVqxm/O+f0cdBesFv7e7q6uwrtB0DOStFqQFXkJEAA7I2hvHEwLgmxSc8L0=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM6PR07MB4898.eurprd07.prod.outlook.com (2603:10a6:20b:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.16; Tue, 19 Jul
 2022 07:40:16 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5458.016; Tue, 19 Jul 2022
 07:40:16 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2Cowk2gAGTfACAARs4gA==
Date:   Tue, 19 Jul 2022 07:40:16 +0000
Message-ID: <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <87tu7emqb9.fsf@intel.com>
In-Reply-To: <87tu7emqb9.fsf@intel.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96732b34-34a6-47f0-db76-08da6959ec72
x-ms-traffictypediagnostic: AM6PR07MB4898:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FCPWRRe23DL9jeCmCGqOqq6ZP9UVM0gwuTpwg0hIUvnrJx+kZzSkjWztHtobUKr1dtZ1m9qncaVAkRRj/yjGnO6pDM/fKZ3rRhDebTtjB6qWD9elNQCvjF/m0cs6tOqSlqlGravz/qr6qpMvOfx7Htp0s7LS5lDHmhLU2E837rYJ5mJY5Y68P4LTcR7sHfLvzoFZTFi3hpmuD2YiVyYd9Vk+bkgj9AViN+A8eNY3FEexS7MQw2hG+jbuCrLPVDVFrrPbZFuVlgl236L8YnGkJ0hEVfs/5jlVBdFLCrLTntVQh8FfONmY8IJo8AwUN49GGdthG+xioioYXQZPN3ciDPfWdqrS+39oCnXtEhwX+wrfGHLmR989/KLRacW78PBtDUGsTb+tYbS6zNCHeAgsnhP8Z5cHhE3MF26do0VDnnjX6EQZmVxuzDwxl8sqrNSUepjMPsIoAOOc5BCEP+91NEtaUGiiP3YADg0iLrct+MLwhtzEt80xmJFVGSxIzQOKF7ecHKC19yEQJvR+7zw30m/ok813JbbqeHeqbp+snDeyjXNtXKa/5yRz0ejw3Hll2lukroi+B9xpuq/0oBzFQOQ6JDo1ZS2d+gmeDoYHugNIwRuEGFLlPZusPxysWsd9NNSzhyvzOLfJj/glFylpy9S41RywdrmrYtX9/TndTulf7OE2uonvih7ReKWXPuwvYe7T+RHKbpDlqlAVH6PzC2rXhA0u35CVevXIxZ1Ge3qw9NXxj5EWyOn0pYuUHDfVjJoffSDrNcMdHioH7WN4hLcQUutxC0q1r3OtFq41PFxxBKEVxvpOIUKMg6BBJo7A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(66446008)(4326008)(66476007)(66556008)(66946007)(64756008)(186003)(478600001)(8676002)(2616005)(36756003)(6506007)(6486002)(83380400001)(8936002)(26005)(6512007)(41300700001)(316002)(38070700005)(82960400001)(71200400001)(122000001)(44832011)(5660300002)(2906002)(110136005)(91956017)(76116006)(54906003)(86362001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3FZU0lkZENYNWJpRitPTTVWU2FtQVpMMHdKOFZOa0QvbzhrTTRQVzNvV29p?=
 =?utf-8?B?ZjFTTVBFUy9EQ2pBS2FzaGFFRmZEN3UyUE1UWUR0a3ZwN0FmNHFhODVtUWVl?=
 =?utf-8?B?dlJWTlpTbzVTK0E2SGF4RUE0YmduclMvWDFGYkxsU2RMc0xjVnhYSFJwdEx5?=
 =?utf-8?B?bW01bnhnTUhibHk4am91cVlFcGhzTm40ZEV2T0NHYTE2dXJVdDNEN1JDU29P?=
 =?utf-8?B?OUsrc29uTTlYMU9FaGRra1VIUUluVWZha0dOVkRMdlp6YlkxcGs5SnlVYmVO?=
 =?utf-8?B?UUtyR05uQ2k5TGwrZ21KRlNBUEI1MSt4dUlrSjdXQ3VabVBjNkorZU5uTVF0?=
 =?utf-8?B?YTNlZ1J3bHVLZDJCdXAyTG53a2dGK0ZvRTA3U3dsdURLWUVrU21rZUVtRnE1?=
 =?utf-8?B?TmEyMnR5MlhrZzJyUTJmeCsrZXJ5VDNPcXZqaVNpTk05eFFmcGEvaDNnYzh3?=
 =?utf-8?B?bkh3cnlVdmVlNE5IOEt1cHh3bnFXMm90YWdvbE5RWWVhREJMVEpPS2R4bFBO?=
 =?utf-8?B?Qm9ad2p3YXk2Y2xOQUF5a0lFY09vOCttd0hTMVc1czIyMEx6Mm9lOFJsUTZy?=
 =?utf-8?B?UTAyMDZib3VMYTBqUjMxV0hWbWJJVUFGcndxSnduTUN6dGdUaFFhZVh3czRO?=
 =?utf-8?B?RW5VMDVnK0U0SXRyVko4eDBYQXVSY0lvVms2WkN3TXQ0NlQrUXBZb0k3c1Zz?=
 =?utf-8?B?N2pOSDJmRFpVUWdzbW1mSEI0VDVJOHdGV3FLTm5aSytMM3R1dk5VQ003Ylho?=
 =?utf-8?B?bXpIY0g2UWYrWkFWdU1waExPTE9ucjFWOG0zSytQWDhyQlI1OXppWGcxd25U?=
 =?utf-8?B?dUcwalo3ekNBMUkvUnF2aGlmTFQyMHA3SWN0Q2tpeEZBL3JjbkxYbzVhMHQ2?=
 =?utf-8?B?UGFFV0x0WlJJNnQweVBXS2FRV251RysvYTlhRE8rNzdIZVAzWEVCR1RMRW1B?=
 =?utf-8?B?dEwrakV1eVJvbFE0OW9obWZyN0V2NWxhWE8zMUlBQjZvTmF2cWptZi9kWlNG?=
 =?utf-8?B?VFlvUVdraVNPaXVucXc3dEhVcWdZV29pbndHR1ZoaWVGQ3VYZmt2N21rNjBC?=
 =?utf-8?B?VXh4S2s2aVB2R1hiZkdCeVZCNkJiMWlzU0NxNnRJeUh6YTZsVFNFbExuSG5H?=
 =?utf-8?B?SUF1OFJYWWg3ZE5adTBJTjhGbk9hdHpDQXRpWlpQektxZCswLyt4c0Y1ZlVL?=
 =?utf-8?B?U3JwTzQ1UXlFczFnTk9xeDBMemc2NjZqR2R6TWx3UjJaTEQzRGRUSSsxUTdy?=
 =?utf-8?B?djlKNFo4dXlLd0NsazlhT0tGM2I0WU1zKzVBVEpvUFRJTEx4TVlkaVNpSHYw?=
 =?utf-8?B?cjdtT3RQVlBjQTVuSzgxcnZrUHBZUnNVQURNeEx5S3R4bFQrSDJSMXozbXA3?=
 =?utf-8?B?V25RQzBob2FxQ2pWSVJyenU2OGsvbmJTa2FTdE91My9sU2JJZlJscmpNRENo?=
 =?utf-8?B?NVh2aXR6bFlaTDY1Z0pmM25GcmZBSUc2VG1lWmh0WHRxUWpJSkhrRTBWMHhk?=
 =?utf-8?B?Z0hhRXd5Z1pZNk1TTzNZRDVrRHlOTGkxOFVOWkdtN09rcGtjNWtrcCtEYVFl?=
 =?utf-8?B?VU9Fc0R1ZVlLYmVMVmxTQS8ySHFjczNpZnNBM09rcVYrS1NMM1FpZFd3eFZn?=
 =?utf-8?B?a3NCZENHWWc1TDFLeVVQYzZGcGg2dENBNCtmZ083d2NtQ3YyTDdQQzQvcjhs?=
 =?utf-8?B?NEk3SlFkY1pLUlFMVi9pbmlqR1Vua0tFMGhyUW44SG54aVpTazhrUzdvNjF6?=
 =?utf-8?B?dWxUS1doZ2xYNThicGFkdHhNMlVyMXBvRElyM1dWNVBVY0E3SVNPY09Xa0x5?=
 =?utf-8?B?UnMzb0xncGI0U2c5RE1yUStObHZ5QXNZZkVvOWI4dDJMTlJFVHNMdm56Nlcz?=
 =?utf-8?B?dVhCQ1FYTHNQMFAzYmZuWTFxampSNkptLysvaG50Zm1RUno2R093MExMT29k?=
 =?utf-8?B?bWJzR1pOZGdaR04xRy9RcmV4NDBCSEdudUtRZWE1NUE2VGIvMTY0NVA1aXVB?=
 =?utf-8?B?cTJGRUJ3NWl6THU2UVJaaG45RzY3dXhXbjd5WHo3U1pRK1RQclNsblV0WlBW?=
 =?utf-8?B?eVZYRlZQdDgwT2dwL3QzY290WXRZVi9qRitWSUgzOHVVZmtxb0wzRW50d0ly?=
 =?utf-8?B?b1JZZVJxWUtSaTNSczhQOC9NU05OZk5nK0hCYmR2dUV4RVF0TmRIYUhwcjRW?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68E8E6460552984980AAFC7B5AF2C520@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96732b34-34a6-47f0-db76-08da6959ec72
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 07:40:16.5677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zIi7StsmC0Re3HOBaIn64lgRBhZB2gdCFqDdG8EdnYM7Jm08UFQhiKRBmoqR5GE9238faFYyuj9qgxGEI9tzniEQnKth20EIpMv2wMekpjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB4898
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMhDQoNCk9uIE1vbiwgMjAyMi0wNy0xOCBhdCAxMTo0NiAtMDMwMCwgVmluaWNp
dXMgQ29zdGEgR29tZXMgd3JvdGU6DQo+IEhpIEZlcmVuYywNCj4gDQo+IEZlcmVuYyBGZWplcyA8
ZmVyZW5jLmZlamVzQGVyaWNzc29uLmNvbT4gd3JpdGVzOg0KPiANCj4gPiAoQ3RybCtFbnRlcidk
IGJ5IG1pc3Rha2UpDQo+ID4gDQo+ID4gTXkgcXVlc3Rpb24gaGVyZTogaXMgdGhlcmUgYW55dGhp
bmcgSSBjYW4gcXVpY2tseSB0cnkgdG8gYXZvaWQgdGhhdA0KPiA+IGJlaGF2aW9yPyBFdmVuIHdo
ZW4gSSBzZW5kIG9ubHkgYSBmZXcgKGxpa2UgMTApIHBhY2tldHMgYnV0IG9uIGZhc3QNCj4gPiBy
YXRlICg1dXMgYmV0d2VlbiBwYWNrZXRzKSBJIGdldCBtaXNzaW5nIFRYIEhXIHRpbWVzdGFtcHMu
IFRoZQ0KPiA+IHJlY2VpdmUNCj4gPiBzaWRlIGxvb2tzIG11Y2ggbW9yZSByb2JvdXN0LCBJIGNh
bm5vdCBub3RpY2VkIG1pc3NpbmcgSFcNCj4gPiB0aW1lc3RhbXBzDQo+ID4gdGhlcmUuDQo+IA0K
PiBUaGVyZSdzIGEgbGltaXRhdGlvbiBpbiB0aGUgaTIyNS9pMjI2IGluIHRoZSBudW1iZXIgb2Yg
ImluIGZsaWdodCIgVFgNCj4gdGltZXN0YW1wcyB0aGV5IGFyZSBhYmxlIHRvIGhhbmRsZS4gVGhl
IGhhcmR3YXJlIGhhcyA0IHNldHMgb2YNCj4gcmVnaXN0ZXJzDQo+IHRvIGhhbmRsZSB0aW1lc3Rh
bXBzLg0KPiANCj4gVGhlcmUncyBhbiBhZGl0aW9uYWwgaXNzdWUgdGhhdCB0aGUgZHJpdmVyIGFz
IGl0IGlzIHJpZ2h0IG5vdywgb25seQ0KPiB1c2VzDQo+IG9uZSBzZXQgb2YgdGhvc2UgcmVnaXN0
ZXJzLg0KPiANCj4gSSBoYXZlIG9uZSBvbmx5IGJyaWVmbHkgdGVzdGVkIHNlcmllcyB0aGF0IGVu
YWJsZXMgdGhlIGRyaXZlciB0byB1c2UNCj4gdGhlDQo+IGZ1bGwgc2V0IG9mIFRYIHRpbWVzdGFt
cCByZWdpc3RlcnMuIEFub3RoZXIgcmVhc29uIHRoYXQgaXQgd2FzIG5vdA0KPiBwcm9wb3NlZCB5
ZXQgaXMgdGhhdCBJIHN0aWxsIGhhdmUgdG8gYmVuY2htYXJrIGl0IGFuZCBzZWUgd2hhdCBpcyB0
aGUNCj4gcGVyZm9ybWFuY2UgaW1wYWN0Lg0KDQpUaGFuayB5b3UgZm9yIHRoZSBxdWljayByZXBs
eSEgSSdtIGdsYWQgeW91IGFscmVhZHkgaGF2ZSB0aGlzIHNlcmllcw0KcmlnaHQgb2ZmIHRoZSBi
YXQuIEknbGwgYmUgYmFjayB3aGVuIHdlIGRvbmUgd2l0aCBhIHF1aWNrIHRlc3RpbmcsDQpob3Bl
ZnVsbHkgc29vbmVyIHRoYW4gbGF0ZXIuDQo+IA0KPiBJZiB5b3UgYXJlIGZlZWxpbmcgYWR2ZW50
dXJvdXMgYW5kIGZlZWwgbGlrZSBoZWxwaW5nIHRlc3QgaXQsIGhlcmUgaXMNCj4gdGhlIGxpbms6
DQo+IA0KPiBodHRwcyUzQSUyRiUyRmdpdGh1Yi5jb20lMkZ2Y2dvbWVzJTJGbmV0LW5leHQlMkZ0
cmVlJTJGaWdjLW11bHRpcGxlLXRzdGFtcC10aW1lcnMtbG9jay1uZXcNCj4gDQo+IA0KPiBDaGVl
cnMsDQoNCkJlc3QsDQpGZXJlbmMNCg==
