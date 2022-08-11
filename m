Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3058FB29
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiHKLRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbiHKLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:17:11 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10074.outbound.protection.outlook.com [40.107.1.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ECA915DA;
        Thu, 11 Aug 2022 04:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebMvDGpGSpSEZrjaqrSX/r4ALkcCEW5HgndOI1WLZbi4nyw24W5HSU/vbN+3edBI4VnApg8MKTeNEAwEIBsrwmh5wKsyZF01/KvNbx+0JSXc7zrMGMDv62npEn4WCfZT1oiJNEJmoFONH8UnqU2I1zNmLREq5Y9Hcta4fjBt77zxBgKspGvq2aifInglRXy7r1wjIoj4yS9zTRrhrS7op06r/Klen1OKip8/UuG2+umfEYoVhZIwUVkcw8BtLYr6K7VhDb3v58+Cb+d9oPtmNfhduoTYViNejo5ZNIWHOQ3o672AQw+jxxbhXELrhmo2OMBxrukItwk7x5HS59RICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dr2XrR/j3BP9uinZGOLjgBP/Iow0OQt3Lz/p+yAB408=;
 b=ina0Tf8rG3bEerDSjtHJBYMBQXYQ/B3+W/OxHkPKwgu0bAfoWKok3wvW7MYXye5xCOm6CLkPcJ+lQkD91LSXOrPJ37VFTZVX8kPmci09G0l1nt8gzXtuYYpph3weMJWIwstFTGm3XQwyj/gCdrgqUbTxHo6WqFNQZ501sfIbBy3YNSM7jreTWIqiuE6qKCNYJ/y1wMlEiep8UMPmBP9JDiHarS2T5mUXgpnx4ycsDaktahZX0oGmu91SK+4of1lOZZVES004a3kqMV1lcIUKl6NIiyoLBSH7khqlO9MpgqLcHRxHKBzh0EN6Y5W+LmuBybX6Gre2eBcLbbX9SGiuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dr2XrR/j3BP9uinZGOLjgBP/Iow0OQt3Lz/p+yAB408=;
 b=Q3tCqcEd7OoDZRk5FzBzyf+xo/cINvn5P7wOIhjJYyqjSLoOQKzh9mdAoV6HPMahk8ZHgksXsYuhUOHuNLihE0/Yvb9sRVPzCnDSX21AsXN/lvqFw5AS2LrQPBZt3Z2lHtoAfqrt0TPc7IRxBw6eAS2HEoDi6bN6H+WTpZbpQL4=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by HE1PR0701MB2908.eurprd07.prod.outlook.com (2603:10a6:3:4f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 11:17:07 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 11:17:07 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "people@netdevconf.info" <people@netdevconf.info>,
        "lwn@lwn.net" <lwn@lwn.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "prog-committee-0x16@netdevconf.info" 
        <prog-committee-0x16@netdevconf.info>,
        "board@netdevconf.info" <board@netdevconf.info>
Subject: Re: CFS for Netdev 0x16 open!
Thread-Topic: CFS for Netdev 0x16 open!
Thread-Index: AQHYrXN0G0WknKKHuEarhKeBOwDjBK2pjOGA
Date:   Thu, 11 Aug 2022 11:17:07 +0000
Message-ID: <36665683cc5c413968db5142c4d08ac35d1af5b1.camel@ericsson.com>
References: <CAM0EoMn_4k_w_maX=0=tmiK5k1nTEWpByGP+83qiJHdM0DbigA@mail.gmail.com>
In-Reply-To: <CAM0EoMn_4k_w_maX=0=tmiK5k1nTEWpByGP+83qiJHdM0DbigA@mail.gmail.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff991e0d-2a04-4b06-4d66-08da7b8b0700
x-ms-traffictypediagnostic: HE1PR0701MB2908:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uBnRIssBjnfxadzqfpBgSvXNaGLt5N7bsQBVw5f5NWlJwh1RWbTv24wwlOFJfnX4LBovDgi2PRq4DZlpx1ZxeLMMXQ1OrfGvMce7ijA3R7h0StoH3kj8QN+Cv4Qqc5Z8wDRRDz4G6svDfTWCr3Ub1TtbYrdrCzu6xCszRdYX/nLly4ptlOYXi6P+fsSeCl18zU2t9yWxhvfSrRZMydylQwuS+pWeDGMyTgSZA/3QR0Xqm5LLfbfw8+dkNZ1fx1XjeWbnSctaZhhB1Mnsdr/eGWyVTJLeUiZSvzPeOEWEpKTZp08R55xXS93oBZNlnfnJmYg97hY/BPIQjlPvVi7pMjr9aIH0Nka6kz8z/7H4boDoMwgp3AvxB/mcJwIymQvIjjJLLkJi+dHj4khK+crJa6cewkNKDcAggnJMofrbbY7o/J6s5P1SpZCG9d13HuKuTv1jDFYfsToGChrmYCZN5+CSEs/KYkzvoOwnJyf090WMVMR6A9QSPHeWdSlFmoZtE5OIcu9kcJ+4f3bDBeXw1qarK/fq9bPgCqJldMpveMyq5grOdrQ0ztekO0CFd2V2I7wvXKg0AI7m3x7pE+khdDvNzsR+e1S1KUS2oXFNZx2WKdom/c5nQwMswcyPQEGMVWPDz/1POorGuJ1pDrC5rmVZd05iOX/J4OZbNhqkLv9LV9P6hp0Rb2pux40SRF9bFdkTKJ+VjebWfbNV/lQ9CMQwrfDJ0zptG8KRLS85FSYsBLa8vDTjzh2iFN6I23ksHX7H4Th0PAYOzgqiF59gSVvdR82cfQZZYdFvqEQPu5YYXm91p8HmlQko8ctD+V8USY/VaeH6n8YGPqjp89QCUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(86362001)(64756008)(66476007)(66446008)(76116006)(66556008)(66946007)(110136005)(54906003)(8676002)(4326008)(91956017)(8936002)(36756003)(38070700005)(122000001)(82960400001)(38100700002)(83380400001)(6512007)(6506007)(71200400001)(41300700001)(966005)(6486002)(478600001)(5660300002)(316002)(26005)(186003)(2906002)(44832011)(2616005)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmV6ekNvdGhvSjZRQjBJc0lLdGFXdlVabEFPVEE0ckd0RXpzQTF2TkhMN21F?=
 =?utf-8?B?RkFTT3A4aGY4V20wbTdYT3NwNEJNSExCUXJYa2NwaDJ1ZzhLcUVrZG9kbEIx?=
 =?utf-8?B?YWR0V0JrSUFFRUhUUkZyRENpTnViaXFYRjhoSTVoYVJWWU9OSHdNZkpkdEs4?=
 =?utf-8?B?OE9hVHdDMUhiYXUvWGlabld5RjdxWjJlekUyYUZJUnFYVEtENHF5MFBEemxI?=
 =?utf-8?B?OUFTVGp5REhuSUZpZkVXc0J1anQ3emdZVkk1SHAxTWJ0enpjRGJRdW51bVFR?=
 =?utf-8?B?QS9OY3l0OXFITHBVdUVTZlMySUdzaTFUNDdwM0ZnQkczRlhRSmxnOTNuRCsv?=
 =?utf-8?B?c3A4TzBNdHlQcHJibU9YdmRUSWk3bm1EZ3NNMGxlZm9aQzlWWXNLRmxCRU4v?=
 =?utf-8?B?RE5CREVCZmY1YXpPVm9mQXJJVlY1YVMwY1ZCdkpvcUY3MnllWC93Rmt2Zm0z?=
 =?utf-8?B?TU9ZU1BqcmFvMS84bE9NNFBOMkdLL21pUC9VZ1oreVZuc0lKYnV0NFVIZGdz?=
 =?utf-8?B?RTZScGZQSHAxTFFBRmNKN1RkQ0diK29kbFA0aUJTTDZpdk56ck9iM0NiOFdZ?=
 =?utf-8?B?Rm00ZmFGKzZwblBKTzRvWFNNcHRLbHBnVkIxVDVrQUI0U3FjTG8xckdrUFNH?=
 =?utf-8?B?WndiNDNBb0JOQ1FvNTM0bG1iak5WRzhzbWdIRSt0L1ZFN09Nc09ZakxrREpk?=
 =?utf-8?B?bTZuRlAxWTUrU0s0L1FJb1ZnTFdET09HcXhjdFNkVnMzT2NxNjVveWVuU3R5?=
 =?utf-8?B?aEhEZUVLUGZjM3VlbFoxS1FjUWFrSENVdVQ5MHJlcUp1VyszcytCVDNUMnM3?=
 =?utf-8?B?VkJrS0JzWnVSMXIxNTU2YWZtemNPUVlzRlVqbW4xNU51Rzh5UDdlRVp5Y2lZ?=
 =?utf-8?B?KzI5L0lWY0w5SE8wdWJxZDFCOUpPb0l0QjZkOFpvQkwyUXZxNVp2dDY3UWEy?=
 =?utf-8?B?dFVwRDFCbjhIWlpmTjB0Z0oweGtLanRydEQ0VmUycXR5a3hwcDVwUWpQdmg3?=
 =?utf-8?B?ZnJPWXowU3crNC9hdVluVUtKUDFMUmkzV0dzTWgwUDFyaDZEYStoc2lwOGVD?=
 =?utf-8?B?RUZGWldlNys3RWJ6TjNQVGUyeVN3Ukt6UG05L1JzVVV6d0JHSVY3YkJJbmZD?=
 =?utf-8?B?ci9JOFRwNUdMS0t2MGhlbENEYlJNTnpiSjhSTk5lMUNhNjF0azcwamVpWUgy?=
 =?utf-8?B?Tlp0bVpUQkV2U2g0TzM5cUdibForNzhTZDdpY3ZlZVhSZllLVnBiWnJBTEtP?=
 =?utf-8?B?am1WOGRNajM3SVhVWW01SUZ3alJMcFR0Ykp3dE14bDBuSGxaNFR3R04ydjRx?=
 =?utf-8?B?NzE4TkszMEFFNnoxMmRxaHlONXU0RXlzZjhIMXl6NEFRcXRQaFhMaGVwZWg5?=
 =?utf-8?B?TmVSbHhqMGxleWcxQnZXc2UyRmkyS0hHQXlKa3g5Y3BoSG1XVnVrZHN3RE1u?=
 =?utf-8?B?OGFuaEQ4anhZSndqNzV4YlpWUG1Zc2xxZENORDNOWUc2RW1oVHN2TlRvVUdo?=
 =?utf-8?B?TlVuNjNLbS95amdnR3JJaE5UeWhndjhaV05zRWZJRFZxVnlJeTQyQ2hXQTFH?=
 =?utf-8?B?ZG1raHBqRDQ3cFYrb1MzamJkcG9YWklFUkI5SW9UbWJSTVIrRC9LNEdEWVlR?=
 =?utf-8?B?Y09ZcFdjSm5EeHdYTTZlY0NyZUo3YU5NZ24yQ3hsb1c2MlBUb0ZWWXJYclJh?=
 =?utf-8?B?T3FoNDZzMFFVVXRMOVNkeUlQeU1ubVFFT3loTGd6dGZzYnBCNDNNSTBCdTdu?=
 =?utf-8?B?NGRueDVFSEo1ZmV3MEVmakN1MUJCTmZibXBoS1IrbG1JT2FMZU13cFVsZFho?=
 =?utf-8?B?OW51WjhZbWxvQzdGaFV1UGN4bkt3S3pySGRwMTZLV2xBVktOVzZhY290ZHZ1?=
 =?utf-8?B?RFRqU3kxQzJhWmFQK3l1WHJUWHl1WnNuVGlBbyszSkFvaFRRSTJ6WVRRcGpi?=
 =?utf-8?B?N24xd1NtUFJVZUtSMVZIN2pqS3JMTitxbjFFU1I1a0NldklXY0ZkSVB0SjFt?=
 =?utf-8?B?UzkyRGh2RGJ5T2VwbFd1TVZxTG1qYVUxcFRwZWNlRHhrTzBBemp0S2VXTTUz?=
 =?utf-8?B?MlF2MUhLUTRMbERoa2dacEY2Q3czbTdKTDR3MGk1UUpnR0hrNjMyclAwbHBS?=
 =?utf-8?B?WVNUaCtkZGxLSEZCazlrcjBNbnh1SXhNRnRBS0NBQVB6UE1qWm56Vll5dUw3?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E8C4171B6FA2542A62D51974B1AE9C6@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff991e0d-2a04-4b06-4d66-08da7b8b0700
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 11:17:07.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FI0hR03tst4lebptgi+oqmGrSrYdBpIaiKGWwBBV97s7zNSqp4aQVT7sSSGALFzQVBF8SLRWEowWM+DzjDsYn2jA3pmEN0vlAoEihQRTfFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2908
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBKYW1hbCENCg0KT24gVHVlLCAyMDIyLTA2LTA3IGF0IDEyOjM2IC0wNDAwLCBKYW1hbCBI
YWRpIFNhbGltIHdyb3RlOg0KPiBXZSBhcmUgcGxlYXNlZCB0byBhbm5vdW5jZSB0aGUgb3Blbmlu
ZyBvZiBDYWxsIEZvcg0KPiBTdWJtaXNzaW9ucyhDRlMpIGZvciBOZXRkZXYgMHgxNi4NCj4gDQo+
IEZvciBvdmVydmlldyBvZiB0b3BpY3MsIHN1Ym1pc3Npb25zIGFuZCByZXF1aXJlbWVudHMNCj4g
cGxlYXNlIHZpc2l0Og0KPiBodHRwczovL25ldGRldmNvbmYuaW5mby8weDE2L3N1Ym1pdC1wcm9w
b3NhbC5odG1sDQo+IA0KPiBGb3IgYWxsIHN1Ym1pdHRlZCBzZXNzaW9ucywgd2UgZW1wbG95IGEg
YmxpbmQNCj4gcmV2aWV3IHByb2Nlc3MgY2FycmllZCBvdXQgYnkgdGhlIFByb2dyYW0gQ29tbWl0
dGVlLg0KPiBQbGVhc2UgcmVmZXIgdG86DQo+IGh0dHBzOi8vd3d3Lm5ldGRldmNvbmYuaW5mby8w
eDE2L3BjX3Jldmlldy5odG1sDQo+IA0KPiBJbXBvcnRhbnQgZGF0ZXM6DQo+IENsb3Npbmcgb2Yg
Q0ZTOiBXZWQsIFNlcHQuIDcsIDIwMjINCj4gTm90aWZpY2F0aW9uIGJ5OiBUaHUsIFNlcHQuIDE1
LCAyMDIyDQo+IENvbmZlcmVuY2UgZGF0ZXM6IE9jdCAyNHRoIC0gMjh0aCwgMjAyMg0KDQpTb3Jy
eSBmb3Igc3BhbW1pbmcgaXQgaGVyZSwgYnV0IHVuZm9ydHVuYWx0ZXkgc2VlbXMgbGlrZSB0aGUN
CiJzdWJtaXNzaW9ucy0weDE2QG5ldGRldmNvbmYuaW5mbyIgYWRkcmVzcyBub3Qgd29ya2luZyAo
b3Igbm90IHlldCkuIEkNCnNlbnQgYSBxdWVzdGlvbiB0byB0aGF0IGFkZHJlc3MgYnV0IGl0IGJv
dW5jZWQgYmFjayBhbGwgb2YgbXkgbWFpbGJveGVzDQppbmNsdWRpbmcgZ21haWwgKGFzc3VtaW5n
IHRoZXJlIG11c3QgYmUgb24gdGhlIHJlY2VwaWVudCBzaWRlIGlmIGFueSkuDQoNCj4gDQo+IGNo
ZWVycywNCj4gamFtYWwgKG9uIGJlaGFsZiBvZiB0aGUgTmV0ZGV2IFNvY2lldHkpDQoNCkJlc3Qs
DQpGZXJlbmMNCg==
