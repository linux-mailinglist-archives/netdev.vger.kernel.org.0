Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98134BA3A4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiBQOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:50:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbiBQOug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:50:36 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120081.outbound.protection.outlook.com [40.107.12.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5B929E957;
        Thu, 17 Feb 2022 06:50:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1iFj43jx/gm/IWsCLdYz0ptFEfVq+QzWA77BUIs7WDsO0Aka2Wm+M5L+qwmyl5JbGZt11GWMIzIe6CgAhXN4gHGjBZl45GMXlsUMfU0u6qN2Z9/2PuzIPU1pPdhti2Z7eMeyOowmbfyX7fcVHMTr9KJcthiZB6dKkWxOuhhE8HPEAjD02/6Izpigj3zV0SHvQ/kNqRQ9jiC3Zg4QuqlfKrPM2TKaLf+48Jfh69m002trqpSBUQ2F3cIE+ETAUKNp27rY9dENjcbP04K365sVRZa1z487cKms7A79OVHe11M1p+ZhnbW2n5rCVW6IV49lw/wTGeOiQ3UvwW3Vx9+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgeyDXDu7SQV40Mdto9VCOS3FU1kUYvcs5AToHoO0b8=;
 b=nIxoyep5jD9Y8mYxBksQid32eTF4D17dJOfbM8DXDPGgi8gQtak8q1r9WQwiKreMDk1kHudm/Vqync6bLTplaMUGrlyo2DA6WhsiQ4ENi3py9aYPBrULu37XyFiXrOHpsImDS64aJJWeih4XAYZdOB8hNDTWMrkOyMUrWh2DSEqYkjgxaf6ZehIMOcXcN0PIj36V+QGKK7mREUB5M8b7Zx0DIcWR/cWjuMdGchTThGT2JcMtB/oJKuIAhXxeJVnfWF4xhLiv+FC6mJJ00Zuc3oVsTlKWKaXrm1I/umHawFuav7FOfIFjIFWE0yzqsnErZWhDsxGfLKkjBw7pak1ODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB3901.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 14:50:17 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 14:50:17 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Topic: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Index: AQHYI/iaC2oW5O0iNEWmftCuskYlwayXvq8AgAAUuoA=
Date:   Thu, 17 Feb 2022 14:50:17 +0000
Message-ID: <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
In-Reply-To: <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92a1d2fb-1540-41c8-4a3c-08d9f224d017
x-ms-traffictypediagnostic: PAZP264MB3901:EE_
x-microsoft-antispam-prvs: <PAZP264MB3901DE2C7E249657C32ED871ED369@PAZP264MB3901.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DqawN9Yd7n3gbNjtrSjOiU+Oxqr0IJjDxc01TMhOoO9UJvpqEBMQSXvZurCq/h7Pc7VCz12dHrgiroxnpi04a422N8AmTbdGx1ZqsAxt+TF7s3He0c4BoPABW642sCH19pa5SLAosesuMzHGqJidxSpeJobdAcj5hOFn+w72UhXzhOzWDZ4n9BpeHA3PXUSmpggcRs/YTtAMKdW8oZzUnkA9R44eOA+5L6Crge3gdXk816xLCWapGbpY4+RAVvgMUfVBb8VBmaBeAaKUHc5Ny+zqkduJCYKovPH2C83Fbow7pd3d9SZtEvRVAWcwRTZ5zfmFfzlO+/0BjxT4uT2D1LmSGQeyhHcGbUkkMgEVUHRqVncw/0HQ0aVlxpokvt9ER9o8nuJGXUB39Fnb3J86Ku+K/y8xqY3JObQLS8iYnJQ8PDIBSFZNg07PhRwceegor+dKcn2qlAq77LI+KOcYyY/qpYXr7l2KKthdozlJphwK0AXXdIApHyatiQ8tMF6xBAfe6IpLNZxBEyrnP5gIvu/ymzCdMhKXI6dm+uXFgP8HKeAm35Yn9m/mmIPlnhj1da5WAhl+yWZTApClmLtQHld1KCEVj20tUwMEl9XJr8AcV3G82Q9wAylJ33BUFkGA54QdEHqJvEbgl1JnvIx8Ibsj/tAhHet18MdM04m4+8PTFgfPI6o0Pww7zVVGqzb3RjKnY12b+EyQVQSu949NlT/cEmUFlN96oTkcRR1jQXEcyAxe2WyY1/zRgNKZr6ezqJU0tAnfDxDQPRIEr+Ieug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(316002)(6506007)(66446008)(66946007)(64756008)(71200400001)(66476007)(66556008)(36756003)(6486002)(31686004)(76116006)(8676002)(4326008)(91956017)(508600001)(110136005)(54906003)(8936002)(186003)(26005)(83380400001)(5660300002)(44832011)(6512007)(31696002)(38070700005)(38100700002)(86362001)(2906002)(2616005)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk1LOXNuaHVlTitFMEgzajVUZzUvb0hOWGpSV0xvN3h5U1RDT0lnd0t6YWx1?=
 =?utf-8?B?cXV3Y0I3VHlORks1S2NabWpJeUxnM1V5bzd1NFBIeHppc09yR0d5c01QM0Ro?=
 =?utf-8?B?OWwrc2pnL1RCVzdlNU9Kd0dGZkovQXNhV0dIcGEzWnhIbm9ET0krekE5S3pY?=
 =?utf-8?B?TzVZVThOOW1JMFF1U2w5K1MycHNZclJqVEpJMFRGL1hYb0g2VEFKL1V3TWda?=
 =?utf-8?B?YTY0QXVjZm1lZlZlOFBuRlJCQTZKNXM2YmQrRDF2QTU2bU1SeDJ3QmRFRVVr?=
 =?utf-8?B?bXpROGJtUkVjaEcraXJUN3Bva29ocm1KRTEwdjRaWTZOTkJrdW10RzdKVWNj?=
 =?utf-8?B?ekx3QXJUK3lCYVNzS2ZOVURwN1ZLWXU5UFpWK3RTZ3pyVXpncis3MDRveVUy?=
 =?utf-8?B?M0p0TzNhaFUzSTZEL1hLM0Z4TjVWWnVrMlp4Z2FranZBOUFaTEVLQXkrQWRH?=
 =?utf-8?B?RnVaVjhTdjJwN2ljb0pTVU1QeWlTM1Z2dDh2c1pkRDhycDRvUktlNjBFamFs?=
 =?utf-8?B?QmhNMFgxQmJHS0VldjU4ZEszNXVod0xaanVlSlh2TldjMXk1NEJyZTJ1YnlH?=
 =?utf-8?B?UkJJZXFlUlhoV1JXWGY0Rk5UYXB6eEdxNnhVYm9aMWkzRmlIZUtPWFMweFBv?=
 =?utf-8?B?MlQ3akNsaGZaeXlnRFplYWlGa25JN3g4MGZTK3lWOWN3VVhhbGU3dFBCeXoy?=
 =?utf-8?B?RVJRSjRybUR3YWFWZEdscXpwcTVXZlZrdlJYTVR0SndVNG9RR3NjME9CZE9M?=
 =?utf-8?B?ZVRPYjRiN0NsR0Q5enh4dklKNGMwTi9EbUwzYVFlalNqNThYeGI3WWp6MEY0?=
 =?utf-8?B?UFBtZVYrbENCV2Z5NWV2U1RERGFrT3ZadzM4akhwUHpCeno1MXF4VXN5UFZH?=
 =?utf-8?B?Uk5OVmdhdjNJekIydjNLb204c1BJalpGWkFaYkR0K3dUcXdsK2dzQ0hHZFRy?=
 =?utf-8?B?YVhBT1N3enBvSDBHUmZjbCtpTGdMUmNKYVRPeFpxMDNMVmkzQVc3Zk5xVVJu?=
 =?utf-8?B?TzRWenFTZTQrUFBuZ01tRm81Ly91dC93V2JleWhpWnVyc3VFdy9lR2tFVXNE?=
 =?utf-8?B?SmFRcEhiKzVyZkxjL0NYWUtWa1ZBRE1nSnlwTDNRdGs3YXFVQzlnQlRINjhF?=
 =?utf-8?B?OUVBTTR2Vk11RlcxOEU1dGx4SnBuRHloWjVuTi8vU3B1U3BUMlN3emRYRGUr?=
 =?utf-8?B?VE5CcXVnbkxRUjl1ZGdseitnaUZTL1FGaWk4UmJZdXhDSUQ2Z2djZUF3SERN?=
 =?utf-8?B?YWh5akFjenRrcmJjMHdScWJlKzA2Yzk0M3pEUzRTSkFvUkZZeitPWWZsaTlN?=
 =?utf-8?B?K29za1pVb1RzOTJFZWFNSHNWNXFhdjlsSWlRMmhDQ1dybDN1MDZMcDZ1bUlW?=
 =?utf-8?B?Rm5BZ0MxVkJBV2tEQU5GdkVZZlZaZHJZbTRDUDlqMDZkY2t1OTI4MzRwUlBp?=
 =?utf-8?B?cmdkejFRSXRMUTg0dkJDcFZHVEpJa2Q1RkpKU2pxTHM1dlEwQXJ3aHlwdXZM?=
 =?utf-8?B?RWNMU3BKZklmSXNMUEpHcURQbE1JTVpyendFWjdncDFURUlaMVgrenBUUktW?=
 =?utf-8?B?V01ZRGROY0VCaU83UC93aU9kYWhUZGNYa3Axa3d6c1BDZmNzRHJBNXlRbFRs?=
 =?utf-8?B?T0FLQm9veC9iQUI2ZWREMkNsWVlpWWJDZU5IYVkwMjZVOFNnUUFTb0d4OXFW?=
 =?utf-8?B?VlFJZzdxUFc0eUFvUXhORkFvOUl4RHhVSDJkSlNWbXdydklGMTYvem85cENQ?=
 =?utf-8?B?SzFGYmtreDRTenoyclF5a0NLdXRoMHpvbkhRUFZ5S3dHRS94Qmtlc2lXNmtB?=
 =?utf-8?B?QXQwWkEzTloyRWRKM1BkZEVkcU9rUGNFcTJoOTlTbjlRQWhidzFFWjJtb1Zr?=
 =?utf-8?B?Q1BKbHBzT3pGbFRHZ0xyWmhveVo4RDludDJValhqcjROZzRhYmh5Tk42aHp4?=
 =?utf-8?B?b0RkOUdMQVVGK0FBcURDZ3BlVk13SXRRRkV6WU9RS3NmL1UxSkJvNDNaV0t4?=
 =?utf-8?B?MUxBTkhHTmh5dVJ2RmpDMVdsUUJSajRwQ2NHeVVkQ0x4c1VKb0UySHRxUGpo?=
 =?utf-8?B?cGRmUGhkenR0NkovWVloQ24rT01YMEhvRHFmNTVtTlYzZGpnNkttZHRjbjVG?=
 =?utf-8?B?c01kbHFGZVdPazEvS0tLVVVQQU8zQS9YVWo4aGs3ZDRpTURXRU1BT0xIMjRD?=
 =?utf-8?B?ZXg2U0orZFo0d09wbkVwaVVvcWNGMlppNUFKYVZTYVNBMEEyZ1RYRWdyZmor?=
 =?utf-8?Q?zM2JxZK5TO9Mnb40758hXGDKOr4C3JoYUJcJ1RBDTs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <112677A84847FA4F82987A6B6E6C45B0@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a1d2fb-1540-41c8-4a3c-08d9f224d017
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 14:50:17.2630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLI06OJqzhqdHiWpm3uuRbBhldLFiCuqy50/ltwBjNQzS6azKPzxcN4vVDCEHX+vr3zUGNBMIVTxT1CR9XdJ1Dr5hcCJh1cNi7YaYLH3pVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB3901
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkaW5nIEluZ28sIEFuZHJldyBhbmQgTmljayBhcyB0aGV5IHdlcmUgaW52b2x2ZWQgaW4gdGhl
IHN1YmpldCwNCg0KTGUgMTcvMDIvMjAyMiDDoCAxNDozNiwgRGF2aWQgTGFpZ2h0IGEgw6ljcml0
wqA6DQo+IEZyb206IENocmlzdG9waGUgTGVyb3kNCj4+IFNlbnQ6IDE3IEZlYnJ1YXJ5IDIwMjIg
MTI6MTkNCj4+DQo+PiBBbGwgZnVuY3Rpb25zIGRlZmluZWQgYXMgc3RhdGljIGlubGluZSBpbiBu
ZXQvY2hlY2tzdW0uaCBhcmUNCj4+IG1lYW50IHRvIGJlIGlubGluZWQgZm9yIHBlcmZvcm1hbmNl
IHJlYXNvbi4NCj4+DQo+PiBCdXQgc2luY2UgY29tbWl0IGFjN2MzZTRmZjQwMSAoImNvbXBpbGVy
OiBlbmFibGUNCj4+IENPTkZJR19PUFRJTUlaRV9JTkxJTklORyBmb3JjaWJseSIpIHRoZSBjb21w
aWxlciBpcyBhbGxvd2VkIHRvDQo+PiB1bmlubGluZSBmdW5jdGlvbnMgd2hlbiBpdCB3YW50cy4N
Cj4+DQo+PiBGYWlyIGVub3VnaCBpbiB0aGUgZ2VuZXJhbCBjYXNlLCBidXQgZm9yIHRpbnkgcGVy
Zm9ybWFuY2UgY3JpdGljYWwNCj4+IGNoZWNrc3VtIGhlbHBlcnMgdGhhdCdzIGNvdW50ZXItcHJv
ZHVjdGl2ZS4NCj4gDQo+IFRoZXJlIGlzbid0IGEgcmVhbCBqdXN0aWZpY2F0aW9uIGZvciBhbGxv
d2luZyB0aGUgY29tcGlsZXINCj4gdG8gJ25vdCBpbmxpbmUnIGZ1bmN0aW9ucyBpbiB0aGF0IGNv
bW1pdC4NCg0KRG8geW91IG1lYW4gdGhhdCB0aGUgdHdvIGZvbGxvd2luZyBjb21taXRzIHNob3Vs
ZCBiZSByZXZlcnRlZDoNCg0KLSA4ODliM2MxMjQ1ZGUgKCJjb21waWxlcjogcmVtb3ZlIENPTkZJ
R19PUFRJTUlaRV9JTkxJTklORyBlbnRpcmVseSIpDQotIDRjNGUyNzZmNjQ5MSAoIm5ldDogRm9y
Y2UgaW5saW5pbmcgb2YgY2hlY2tzdW0gZnVuY3Rpb25zIGluIA0KbmV0L2NoZWNrc3VtLmgiKQ0K
DQo+IA0KPiBJdCByYXRoZXIgc2VlbXMgYmFja3dhcmRzLg0KPiBUaGUga2VybmVsIHNvdXJjZXMg
ZG9uJ3QgcmVhbGx5IGhhdmUgYW55dGhpbmcgbWFya2VkICdpbmxpbmUnDQo+IHRoYXQgc2hvdWxk
bid0IGFsd2F5cyBiZSBpbmxpbmVkLg0KPiBJZiB0aGVyZSBhcmUgYW55IHN1Y2ggZnVuY3Rpb25z
IHRoZXkgYXJlIGZldyBhbmQgZmFyIGJldHdlZW4uDQo+IA0KPiBJJ3ZlIGhhZCBlbm91Z2ggdHJv
dWJsZSAoZWxzZXdoZXJlKSBnZXR0aW5nIGdjYyB0byBpbmxpbmUNCj4gc3RhdGljIGZ1bmN0aW9u
cyB0aGF0IGFyZSBvbmx5IGNhbGxlZCBvbmNlLg0KPiBJIGVuZGVkIHVwIHVzaW5nICdhbHdheXNf
aW5saW5lJy4NCj4gKFRoYXQgaXMgNGsgb2YgZW1iZWRkZWQgb2JqZWN0IGNvZGUgdGhhdCB3aWxs
IGJlIHRvbyBzbG93DQo+IGlmIGl0IGV2ZXIgc3BpbGxzIGEgcmVnaXN0ZXIgdG8gc3RhY2suKQ0K
PiANCg0KSSBhZ3JlZSB3aXRoIHlvdSB0aGF0IHRoYXQgY2hhbmdlIGlzIGEgbmlnaHRtYXJlIHdp
dGggbWFueSBzbWFsbCANCmZ1bmN0aW9ucyB0aGF0IHdlIHJlYWxseSB3YW50IGlubGluZWQsIGFu
ZCB3aGVuIHdlIGZvcmNlIGlubGluaW5nIHdlIA0KbW9zdCBvZiB0aGUgdGltZSBnZXQgYSBzbWFs
bGVyIGJpbmFyeS4NCg0KQW5kIGl0IGJlY29tZXMgZXZlbiBtb3JlIHByb2JsZW1hdGljIHdoZW4g
d2Ugc3RhcnQgYWRkaW5nIA0KaW5zdHJ1bWVudGF0aW9uIGxpa2Ugc3RhY2sgcHJvdGVjdG9yLg0K
DQpBY2NvcmRpbmcgdG8gdGhlIG9yaWdpbmFsIGNvbW1pdHMgaG93ZXZlciB0aGlzIHdhcyBzdXBw
b3NlZCB0byBwcm92aWRlIA0KcmVhbCBiZW5lZml0Og0KDQotIDYwYTNjZGQwNjM5NCAoIng4Njog
YWRkIG9wdGltaXplZCBpbmxpbmluZyIpDQotIDkwMTJkMDExNjYwZSAoImNvbXBpbGVyOiBhbGxv
dyBhbGwgYXJjaGVzIHRvIGVuYWJsZSANCkNPTkZJR19PUFRJTUlaRV9JTkxJTklORyIpDQoNCkJ1
dCB3aGVuIEkgYnVpbGQgcHBjNjRsZV9kZWZjb25maWcgKyBDT05GSUdfQ0NfT1BUSU1JU0VfRk9S
X1NJWkUgSSBnZXQ6DQogICAgIDExMiB0aW1lcyAgcXVldWVkX3NwaW5fdW5sb2NrKCkNCiAgICAg
MTIyIHRpbWVzICBtbWlvd2Jfc3Bpbl91bmxvY2soKQ0KICAgICAxNTEgdGltZXMgIGNwdV9vbmxp
bmUoKQ0KICAgICAyMjUgdGltZXMgIF9fcmF3X3NwaW5fdW5sb2NrKCkNCg0KDQpTbyBJIHdhcyB3
b25kZXJpbmcsIHdvdWxkIHdlIGhhdmUgYSB3YXkgdG8gZm9yY2UgaW5saW5pbmcgb2YgZnVuY3Rp
b25zIA0KbWFya2VkIGlubGluZSBpbiBoZWFkZXIgZmlsZXMgd2hpbGUgbGVhdmluZyBHQ0MgaGFu
ZGxpbmcgdGhlIG9uZXMgaW4gQyANCmZpbGVzIHRoZSB3YXkgaXQgd2FudHMgPw0KDQpDaHJpc3Rv
cGhl
