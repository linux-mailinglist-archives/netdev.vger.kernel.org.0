Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB38A4FDEC4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343877AbiDLL7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353136AbiDLL6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:58:39 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30136.outbound.protection.outlook.com [40.107.3.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B81C117B;
        Tue, 12 Apr 2022 03:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hv4/xgUjrba9z0X5+QINkLnlTB5+ELbiPQPXp7Reu2se+m7KWGUVj0xAGUfXRe0U6UVg1XmRMq69Y+O2F26tPHLbrRd+Qy2ZfYlewc4mG40zsDALD4htJZsXiSHgMGewi1PzEUBgw6yv1b+MLk6vyw0oljmHkThPKOsoA9EPzr57OUTwNBRqmB0V5AOkKOUjVH6ywk4DOOub1s/vFP4gqVssfv91qR3YrLeR3ILMbEUkgoTp2R1XIR3IWXSnMusOaEmXhv/J9EavtWc1kkTnEPYNKwX+6VjoPkNz45mJUSxsvjfFCkTyZ2+Kw4dt3GhxE99Cq6m4mBezFuNe4PNrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nr6R7TtvSNV/KaCE0wzd9dlzBC51S0LKPieI2T0HSX4=;
 b=cZqSN6PA4k4XlX8EIPRwuT93WTDFLCawY1c4P8EIJR5lJwTocZngr2ZhaM10bdrSK52TfP7VEXiqX1Bra3Brn8d7xE72gcvfKWxErPgjm1dTJBNJrH+ah96LKKY+CPhgFWXAJa9sXOyzZczHcabwaLfVlzEhIVA7dOaWBprFDn2JkqiOrVQxhnDb49MiZFUCHUqNxtJMh+Oo0VQnIkc6+r/OMzJJiEELVHnS1dWkp6oP+qpcDozzaiTSrmU5hTvVBvqJdhGFGi5SfDO/G9cQH5oejPd8b73QNvB2DPPzJa71oaE3LQBuo4GlEWypuPyUy5Tdj9/QtknjZaA7T07EKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nr6R7TtvSNV/KaCE0wzd9dlzBC51S0LKPieI2T0HSX4=;
 b=tR/uU9wwEeOlNyelMKBBq+bmT+72M1wKAWdZEbJVPVTHxmY7uXg6aCnNLSJlVdYvXcnrErN9OtKZvibf+K50Uvxh9vsiw6OdNm5PjW2ydrd+WVAPHDibZHBsAaPjcTUjsCJdFDBmD+D95PC/L0XqnI1md0qOU5gkW3HQjMWgV6Y=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4215.eurprd03.prod.outlook.com (2603:10a6:20b:e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 10:50:19 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 10:50:19 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Topic: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Index: AQHYTlsZ5PP7ok0nLUG60UBEzGR+wQ==
Date:   Tue, 12 Apr 2022 10:50:19 +0000
Message-ID: <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
References: <20220411210406.21404-1-luizluca@gmail.com>
In-Reply-To: <20220411210406.21404-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47dc7c5e-cb6b-4f90-187e-08da1c723c8e
x-ms-traffictypediagnostic: AM6PR03MB4215:EE_
x-microsoft-antispam-prvs: <AM6PR03MB42151EA9B554200A9852294183ED9@AM6PR03MB4215.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: szo9kGu6pdclnoBVcBDO3oJRp5gSvcmBqXFbBECRybel7bnr1Vg/N07XIAsCG77zO+qBjAKYS6rG7z69r4zgB0GaT6xVQ8Be5+sbg2tclafiU3PnQHtA24UMaJTYR5HC67iJWy0+FLsu9c6yWkCv8eD12m0pvOQBSzzHaF7rLOvOADcbYciKmziADqmZYn2bN1Jz4Z1NfBSEB3bBLQguhLR1ksyJVMWh8HWad3qdsgqY+ZJBYdofmSutYcVcLy+H6Q/jnJGBiFEXK3krjl+EppWYD8PaVmsGNfCtaQblfX6TcbEBp2pBRy5RjFlQfotv3PKo36dKOuYm4nguiCdvOYjUImhTPT8MSAxm/sYYMuzh5MRg9ScNP5HnL0AzL09+CaLtMi12D6CgThwNo5l3ktCqs0ayQST96clNSKGdHw2ojocf/lwkoKAJMo9Q2hM+n0q+sb1lQwqObCRUKd/432gcSD//mrA44Mky9CzMgjOaBrvbBZVaR826eKmBiVsUF7iCbtl+b1oNQ5bIrqvJMwtDHvZNahnqBMdLTuyQBS1OCweFXhtX9+ek2tW992gOoTpRvU0KMPZ2IQNLBaYT5+DXEpLTxgnofYWfjZfMeoqkvGQEJUbX7Hk6y7XnpxOWE/Rc3AdgUbtuqYIJmXzTvuVo/SxPeFGGeaZINhfkMjF39HNvTmR2M1I44VDgFigLAVl6PM+OJpIJ6AxWMfbqSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(85202003)(122000001)(66574015)(508600001)(6512007)(85182001)(36756003)(6506007)(6486002)(86362001)(38070700005)(71200400001)(38100700002)(4326008)(8676002)(5660300002)(83380400001)(8976002)(2616005)(8936002)(316002)(7416002)(66556008)(54906003)(76116006)(6916009)(66946007)(64756008)(66476007)(91956017)(186003)(66446008)(26005)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elo5enlQdXB4dUlnMjBXV2hnaW1vZ0lMTUgvY2JncGdLeDJkckRXM1JFbVRK?=
 =?utf-8?B?K01Wcng2VzY0TzZ0L2ZwdDRJT2F5Vm04cS9DdFIrMUNQdWhJWm9WdmxUYmgw?=
 =?utf-8?B?N1o2K3FwNWVsM05pcHpmbEdTc2dLT2NzR0Jqcko5ckRHdlVOM0V6cXhlK3J4?=
 =?utf-8?B?eG5xcVZ6V01aOFlUNFNodzA1bTVuRk9zWk1XWmZmNXBrUGF4ZkR6NkQwMlN0?=
 =?utf-8?B?QUY4clZLWE9PZFRkOW5ZRkx2MFVTUVB1QWFOblpWZVlQbFNKZGtXT0RHZXhz?=
 =?utf-8?B?dnNURG1OY3o5UFlwYjNqT0xEbTlvR243S2hGNEdoVU83U2FsLzIzRGFMeWRT?=
 =?utf-8?B?bjVWOEZFTEJqTjlRTy9OWWV2b2E5aW1kRnBROEdnY1VQL1BoUU9vZ0cvZ3Aw?=
 =?utf-8?B?d09lTG95TEJKcVV4TVNaU296MHVNNGdwSjZydHV0bFZPeWJYSnFtNzJ5L3Jj?=
 =?utf-8?B?VmF1K2o5cDRCekJiS0Nrd3BQMFo2ZGRndWgxNjNoS0VTd0N1OTBoZTFWNzVl?=
 =?utf-8?B?Q2kvZmthK2tRVDlUbmVQSXNJMnByc3V5SHA2SEYvQ2J6Z0gwL0xoS2NrbEZs?=
 =?utf-8?B?WkE5YTU4OHRJK3NzM3NjUitsdy96TlI5S3B0SmpZcWFpOFdPZVZoY1NKUGhU?=
 =?utf-8?B?eHRrQkFRdHRlT3RzM2xBNEJGRk1Qd21GOUxIbXJDU2czSE51TWNGcHFOZURj?=
 =?utf-8?B?Z0F6bkc1emRHTXFHaU10Nm92eUxOb3FQRy92Q2E0RlRudDBMYUJDWTl4dGNu?=
 =?utf-8?B?aUVqenA1eDV0NzlrL01YZzhhcTQ4RkVmUjk2dmtvUjdUQXJZSDA5bFYvamdH?=
 =?utf-8?B?U2FzVm5ZRWdUOUZ4NTVEb1pPdEFUOHNYa0l6VEZ2UkdpTUNuWHdzdy9ScDB5?=
 =?utf-8?B?ZUNtbDljaERTYXl3eUQyeHRKajk1OTZGRXVMdFBBb2lZeUZMZE95ejJyV0Ny?=
 =?utf-8?B?N05KVHJFWklYZ1YranhNSEJoQlNucFNwb2lLZWNDdnh3TFFwYnM5dmlBRUVQ?=
 =?utf-8?B?N2VnbG1XRFRHWG80T1JZOGxleWpmWEhNYXFCT0VWVktlT2JWeXRucDRFNHU2?=
 =?utf-8?B?b0grQ0hKZFd6NnBhZHF6SGlBSlh5ampRVDBtQlYrZzFTNGQ5NUsyZUp4VTFJ?=
 =?utf-8?B?R3gvVHFwRjhsc0FGL0ZVT0NtN0IydWNkeGNHOEdDQU9jcGlFU0pidGlhZ0sx?=
 =?utf-8?B?NjJnNCtLM2tMek85bEFTT2hoWVAwL1lDMU4rWlJXNlNhTXBtcWJFU1dZUmZG?=
 =?utf-8?B?WGxUUkorRzQ5RlM4bHZaN29HYmJ1L0YyYk5JN3B2T1ZZQnZTRm16SmlHRWND?=
 =?utf-8?B?WHVkOThLSHR2YjVkb2JIVnY0UUhkWi9DZjZiZW5ZT1poM2wvQ3hJSnZxdnRy?=
 =?utf-8?B?SW9ZRGtEQ2l0UFNiWnEzZDVMN0J1NUl0ZnFiRUNEWVk3bUo1ZEVyL0NtVXhZ?=
 =?utf-8?B?Q3RpUXpabjR3a0hrbzJDY1hoalpMTGtRazQ5ZVI5QWZ3Rm9ZVFM3UjJSS0oz?=
 =?utf-8?B?TGxSZEFXTUNJRVRpUzM1dWdDV3dvaXVPU2Zjc2RhRUV5bmdsSnY5VUlRbGsx?=
 =?utf-8?B?SGVkdTQ0RXFlZllsZWIrcHY4NzBPclVwNEZPRGpEbm15TXRNMVRjMC9PVTdh?=
 =?utf-8?B?MzhlMVBiaXljeDJsa0RpcDlSWnYySjdMS0FYbnJEZVhGL0xqMG02Yk9reCtZ?=
 =?utf-8?B?L051VEsra0RKejJsYjdrbkkrdnhCTlJDY29oT1NBUjNFa01wNDhFci9PY1A2?=
 =?utf-8?B?U2NpemVuRWN1OWQ4S3V0ZFBhWk1MUDhHRE5UY2tZalc3OE85TGxVQ0pVUW8x?=
 =?utf-8?B?b0pnc3NzYTR1RU5PbCtPN21ySnNDUU5sdVdwZjc2cnZnV0VMK2N1VVVYbUVJ?=
 =?utf-8?B?OHViaTdYb0wzTzh3OGEvYXpWTTVXckx3dTIybzU3OFJCZ1dwOEMxaitFaHVB?=
 =?utf-8?B?ZnpHTzVlNDdjbW5tUDdCU1ozVC90UjdEN3lVN1VrK05qQ3R1czRTVk1aYUVH?=
 =?utf-8?B?WkFSdE14MU9ucEZ6ekFSei9rYWlIU3lpV1FHWXFCa1k4TGZocUJCTDhWTXdj?=
 =?utf-8?B?bWJPYWR6MEl4K3BqUHRlWkl3SC9DekRmeHdBL1k5bHhPMys3NDNydEp0bXgv?=
 =?utf-8?B?TGttUm0raml3M1lXSHA2VS9aTTRvT1prdHFDSG1JM2pzQlVROWY0RXdiK29O?=
 =?utf-8?B?L1RTK3J3QTh0Vy8wb3p3ODhjR2lEejBjWDBmSlZYcjhrTVdkQlptQ25kRGwy?=
 =?utf-8?B?UHA2TEVOSWRFQis5S2J0QnJiWEorbVpVNk1naDdETDNGQldwNTB3bjRJaUdn?=
 =?utf-8?B?dUNQc3p0enFYdlc2Z1dnd2JtV3dSQm1KNGpZSlU0bzVNWVhwZmFMUmdyOFUx?=
 =?utf-8?Q?Leq8+/FvkyFmhWao=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B52A1897366AA64685944B095EAD7F3F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47dc7c5e-cb6b-4f90-187e-08da1c723c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 10:50:19.3047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: puE3kuzUwbhooe+EHuFqUGEcMjoa+DP1J20zRdyYf2RxmeJAtsmMvkppo+U7GcycWpVKYnwd3hLrgPnEEMGWLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBBcHIgMTEsIDIwMjIgYXQgMDY6MDQ6MDdQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gUlRMODM2N1JCLVZCIHdhcyBub3QgbWVudGlvbmVkIGluIHRo
ZSBjb21wYXRpYmxlIHRhYmxlLCBub3IgaW4gdGhlDQo+IEtjb25maWcgaGVscCB0ZXh0Lg0KPiAN
Cj4gVGhlIGRyaXZlciBzdGlsbCBkZXRlY3RzIHRoZSB2YXJpYW50IGJ5IGl0c2VsZiBhbmQgaWdu
b3JlcyB3aGljaA0KPiBjb21wYXRpYmxlIHN0cmluZyB3YXMgdXNlZCB0byBzZWxlY3QgaXQuIFNv
LCBhbnkgY29tcGF0aWJsZSBzdHJpbmcgd2lsbA0KPiB3b3JrIGZvciBhbnkgY29tcGF0aWJsZSBt
b2RlbC4NCg0KVGhpcyBpcyBub3QgcXVpdGUgdHJ1ZTogYSBjb21wYXRpYmxlIHN0cmluZyBvZiBy
ZWFsdGVrLHJ0bDgzNjZyYiB3aWxsIHNlbGVjdCB0aGUNCm90aGVyIHN1YmRyaXZlciwgYXNzdW1p
bmcgaXQgaXMgYXZhaWxhYmxlLg0KDQpCZXNpZGVzIHRoYXQgc21hbGwgaW5hY2N1cmFjeSwgSSB0
aGluayB5b3VyIGRlc2NyaXB0aW9uIGlzIG1pc3Npbmcgb25lIGNydWNpYWwNCmJpdCBvZiBpbmZv
cm1hdGlvbiwgd2hpY2ggaXMgdGhhdCB0aGUgY2hpcCBJRC92ZXJzaW9uIG9mIHRoZSAnNjdSQiBp
cyBhbHJlYWR5DQppbmNsdWRlZCBpbiB0aGUgZHJpdmVyLiBPdGhlcndpc2UgaXQgcmVhZHMgYXMg
dGhvdWdoIHRoZSAnNjdSQiBoYXMgdGhlIHNhbWUgSUQNCmFzIG9uZSBvZiB0aGUgYWxyZWFkeS1z
dXBwb3J0ZWQgY2hpcHMgKCc2NU1CIG9yICc2N1MpLg0KDQpXaXRoIHRoZSBhYm92ZSBjbGFyaWZp
Y2F0aW9uczoNCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNl
bi5kaz4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4NCg0KPiANCj4gUmVwb3J0ZWQtYnk6IEFyxLFu
w6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJpbmM5LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBB
bmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcgICAgICAgIHwgMyArKy0NCj4gIGRyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jIHwgMSArDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9yZWFsdGVrLXNtaS5jICB8IDQgKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9LY29uZmlnIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvS2NvbmZpZw0KPiBp
bmRleCBiNzQyN2E4MjkyYjIuLjhlYjUxNDhiY2MwMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZHNhL3JlYWx0ZWsvS2NvbmZpZw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9L
Y29uZmlnDQo+IEBAIC0yOSw3ICsyOSw4IEBAIGNvbmZpZyBORVRfRFNBX1JFQUxURUtfUlRMODM2
NU1CDQo+ICAJZGVwZW5kcyBvbiBORVRfRFNBX1JFQUxURUtfU01JIHx8IE5FVF9EU0FfUkVBTFRF
S19NRElPDQo+ICAJc2VsZWN0IE5FVF9EU0FfVEFHX1JUTDhfNA0KPiAgCWhlbHANCj4gLQkgIFNl
bGVjdCB0byBlbmFibGUgc3VwcG9ydCBmb3IgUmVhbHRlayBSVEw4MzY1TUItVkMgYW5kIFJUTDgz
NjdTLg0KPiArCSAgU2VsZWN0IHRvIGVuYWJsZSBzdXBwb3J0IGZvciBSZWFsdGVrIFJUTDgzNjVN
Qi1WQywgUlRMODM2N1JCLVZCDQo+ICsJICBhbmQgUlRMODM2N1MuDQo+ICANCj4gIGNvbmZpZyBO
RVRfRFNBX1JFQUxURUtfUlRMODM2NlJCDQo+ICAJdHJpc3RhdGUgIlJlYWx0ZWsgUlRMODM2NlJC
IHN3aXRjaCBzdWJkcml2ZXIiDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRl
ay9yZWFsdGVrLW1kaW8uYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5j
DQo+IGluZGV4IDMxZTFmMTAwZTQ4ZS4uYTM2YjBkOGYxN2ZmIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiArKysgYi9kcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiBAQCAtMjY3LDYgKzI2Nyw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIHJlYWx0ZWtfbWRpb19vZl9tYXRjaFtdID0gew0KPiAg
I2VuZGlmDQo+ICAjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX0RTQV9SRUFMVEVLX1JUTDgzNjVN
QikNCj4gIAl7IC5jb21wYXRpYmxlID0gInJlYWx0ZWsscnRsODM2NW1iIiwgLmRhdGEgPSAmcnRs
ODM2NW1iX3ZhcmlhbnQsIH0sDQo+ICsJeyAuY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjdy
YiIsIC5kYXRhID0gJnJ0bDgzNjVtYl92YXJpYW50LCB9LA0KPiAgCXsgLmNvbXBhdGlibGUgPSAi
cmVhbHRlayxydGw4MzY3cyIsIC5kYXRhID0gJnJ0bDgzNjVtYl92YXJpYW50LCB9LA0KPiAgI2Vu
ZGlmDQo+ICAJeyAvKiBzZW50aW5lbCAqLyB9LA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0
ZWstc21pLmMNCj4gaW5kZXggMjI0M2QzZGE1NWIyLi5jMjIwMGJkMjM0NDggMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstc21pLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiBAQCAtNTU2LDYgKzU1NiwxMCBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCByZWFsdGVrX3NtaV9vZl9tYXRjaFtdID0g
ew0KPiAgCQkuY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjVtYiIsDQo+ICAJCS5kYXRhID0g
JnJ0bDgzNjVtYl92YXJpYW50LA0KPiAgCX0sDQo+ICsJew0KPiArCQkuY29tcGF0aWJsZSA9ICJy
ZWFsdGVrLHJ0bDgzNjdyYiIsDQo+ICsJCS5kYXRhID0gJnJ0bDgzNjVtYl92YXJpYW50LA0KPiAr
CX0sDQo+ICAJew0KPiAgCQkuY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjdzIiwNCj4gIAkJ
LmRhdGEgPSAmcnRsODM2NW1iX3ZhcmlhbnQsDQo+IC0tIA0KPiAyLjM1LjENCj4=
