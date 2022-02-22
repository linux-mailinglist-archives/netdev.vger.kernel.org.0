Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F624BEE8B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbiBVATr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:19:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiBVATn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:19:43 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00134.outbound.protection.outlook.com [40.107.0.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C52558A;
        Mon, 21 Feb 2022 16:19:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfSUNWj8k9hg2wrcPLSYI0AeWd4YEr9O4KSHmJQNsQ2oKPTVx4wbttbmwmAFloliy5jIw4gJOFokxeWdVe6ejLjutf1i/AAioV2Qyomq3MbNMp/+6XK3L1PdRBt+aWBv/dCDWDL1GLG6+a/EFTK7AjaByy4wtxYwgcii3SPGR31GOjmg7TSrPxSDlzfXik418LOzR36ywCnxYS8775gcA2LblRyE/LJn8Hd9h+f+Vb+h0YQHF0+0IbpuTzHbeD4U3UZ06ftV+D5p6uR8J1P4wFiwfV6/pBkhaFqaSGdyQbrwiIHF+85RC9zGpFRGheINaohHYucMp4hnF/Rb/Ox1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUV8YwdM+yEyv77U3/eQN4iJXCfBxdX1QQ6KtuLgMR8=;
 b=Uv3JOOS042oUw2Bgzasy4S41sPLECaJmft4jDOA7S/Avj6YF8N9w8Ua+y9A26SInLUVQ04DaL3ewjK2c6RtC6KbKoMMk7o4DG1Xirx+buN3yAaFbdi+SZ4GVCFxOCU6RjJJJ5XkNUcww57jS5x4c22NQHcuPUC3euYn/cM7xz0YyFRD4zX8qoC1FCNzO42suK8YB1FtB2yzGohQFmPq6TKjrxO3QfOhSn1585Jalcdy8hLEVpsCfRVq7kHEBzm3njocz1IaDtDHX+FiBHT29mbgvb2pJi6eoxmZh+bs8XjYp8Cznx4sbPSdz4MGdbkpvQfqwNBWviC78tPxeLdN06w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUV8YwdM+yEyv77U3/eQN4iJXCfBxdX1QQ6KtuLgMR8=;
 b=tVVrLgHW7VKXo4todgGLlbuVQxk1L3IKZ86pizj+adqE/GjaTpQT6UBr2kNh5EK1em+rNx6+Skg/jsI2dXJLVGaO7IgelIu1mpLCaop1+ujCigHkXhx9uSm5DTYv4YSv/hbnRfeiGg/IxcKWxUbkDc1Dc4i8FLhxhxE56Y5n9xg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PR2PR03MB5468.eurprd03.prod.outlook.com (2603:10a6:101:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Tue, 22 Feb
 2022 00:19:14 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 00:19:14 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Topic: [PATCH v2 net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Index: AQHYJ1OBxovBrGQhCk+6HBi+K6ksGg==
Date:   Tue, 22 Feb 2022 00:19:14 +0000
Message-ID: <871qzviwhp.fsf@bang-olufsen.dk>
References: <20220221184631.252308-1-alvin@pqrs.dk>
        <20220221184631.252308-3-alvin@pqrs.dk>
        <CACRpkdaFgPfv3ybV8HZh7_WaL3AJ6PkUk8Op1D7O3frvpsxNWQ@mail.gmail.com>
In-Reply-To: <CACRpkdaFgPfv3ybV8HZh7_WaL3AJ6PkUk8Op1D7O3frvpsxNWQ@mail.gmail.com>       (Linus
 Walleij's message of "Tue, 22 Feb 2022 00:21:21 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bb77520-e7d5-4e35-1b94-08d9f598f525
x-ms-traffictypediagnostic: PR2PR03MB5468:EE_
x-microsoft-antispam-prvs: <PR2PR03MB54689DA3BF8AE34047E87841833B9@PR2PR03MB5468.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FAUDsPpZMhZy42EUOSGpacZ2Em3swDlfmalSB3SgBCgIp/R1Liqi8EboGmggh3MIlHwULAzVyRKLCjUgiBdkWKuAJ2cjlGH1n0HAR/9jyaSL1jInyJGnj016g9AXws2CbxyrTxe1C04WR/H1g1gFXOt96JT3SyVjKtNcvQ8levB+Zwd0k9IFNmRHtlOmZL3OXXfFHBr0dfIhQvKboCRCH45qzI0gtzdYctz+aAt2U0zNTXDeBuyw9LWVU5gn6frH7OTvKXhVhQrpTuIAXmZtmmNoJA9toGRC5MBZ8ebDkumCoEhMcOI7Wm4TW1dm2VPdFLbDJH8ap/OZViWsfUo6/TzYJZzB15kB/IbySV3qG5Ax9MIizEb2yTpKgm0PQTfNNahT1B9qCXYvogo3hGVz+Ix53yOVPP5ZlYPxyF23akBKxdWwTArsD4k8zDK3WsAeMROZd+do+5knx5cDmtuGe/S4f2yMWUSzM5CWQzw4HSiaLcuJIIx5BlJYajQk96uQ/+3djb2IeW8wtYMOk5k4hjM+ud9U9sl3wbWBe240EFP3AVQUyb5ld3MvgHWEmN4fuiRhhrbQVrFRjt7lBf9YcFX2cel6XLtJRRYDIhUmRkN71R2aAzhr3v185JKIX23fR0gx6Zabv0sOmzDHiaArzdKXuZ9EFLlUoMfdpE4289VEUzClFdU/XXowbzJrF49hvcO9hgPryLBLTH9Ti7rwmFBH1w7Xjh6zCPLyX9wdyWVCn27h7xCjZ8QpssoTSZuo/sP0rer7/e8LQfl+Ayfrkr5CrNcDvwaOvVAzuyo4m5o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(85202003)(83380400001)(66476007)(36756003)(85182001)(66946007)(186003)(64756008)(26005)(66556008)(66574015)(122000001)(2906002)(7416002)(54906003)(6916009)(2616005)(76116006)(86362001)(38070700005)(53546011)(38100700002)(8936002)(8976002)(5660300002)(71200400001)(4326008)(6506007)(91956017)(8676002)(508600001)(6486002)(966005)(6512007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2lzVng1TVdKemYzNlBLdEdDc1NoS3VVYk9tU1ZjWkFkZ3h3dHB1OGptWlkv?=
 =?utf-8?B?K254eEZveGlXS2lJZjlrRDMxenFBS0VhRGRNTzdQVk9CaWtXTk5RTUM4eEZo?=
 =?utf-8?B?cGdRMXYyZjlNREF3U0R5aklGV21XVVNEc2pCN2pRcVlPYWZEMnRoTWc0eVVE?=
 =?utf-8?B?SG51azB0cG9PYWsyVkZmMlVTcHlKdEc3QldZaVNZWjhsR3lLdmVTWFZDK0FR?=
 =?utf-8?B?SWJFWXhWblFpb0tnR0xIdWI2eHNxZ0JaZnRtNVpqZFhhSkNhN01ZNUJpbmRl?=
 =?utf-8?B?U3k0clZDWlJ1MU9HZEZQL3M0WHBoTjNqUmtPTDljVkxOL203Ukd3VmFaZUJY?=
 =?utf-8?B?MlMvWDZMMUpqNTg2bERGeUtQZjBGQy9jYUhFcGszTE1jYVg2bnJwQ2J0TUtp?=
 =?utf-8?B?Vk9Va3BuMzB4Y2wyNlhGZWczWitsb2dHOWFGam5vNGtsdFdqMGpQL0d3WlJX?=
 =?utf-8?B?ditSNDMwYjRYNmxDelBYaVJodlNXbG9hMnRVN2tEL0hueTdyMnlmb29NbXRj?=
 =?utf-8?B?OS9WNHhKNElCTDY0eTdLN1oyaWlDbUZzODJiTXhrOXBsYkRqdk5PWXlsSFNB?=
 =?utf-8?B?Ym5BZTJHSTJzMjlscGpuZEgxTmpHbHI0LzFiUkZCYldnT01xWXpJNGJERHhk?=
 =?utf-8?B?SHcvV1pLaVNlUVJNN3RFOVhnU1RDaHV3dU9NUmRKRnl0Ym9qT3d4ZVcwZ29q?=
 =?utf-8?B?V0dLOHNrNUtVODUxNWNTY2lzdkV1RCs4aTFOVFJ1NzAxZ2VzN003RjMzVzhY?=
 =?utf-8?B?Uk8wMmsremZPVUZRU085R05DT3RlcnhRZ2VrMm5FUE5tT1RsR29SenlkdVNS?=
 =?utf-8?B?Uk1CMVpzWk1taVlrRlROcTl4S0k2Sm1abjZONDBZZ1N1YWJEZ3l5TWxvekps?=
 =?utf-8?B?RGRXcE4rWC9lVjdBK0lpV05oWm05cVhIRmNmL0pBOUhZYzNDdEY4WkNpejNj?=
 =?utf-8?B?NkRZaXFiWWgxVzVFeFljS3hwbFBndW9UNlY5eWFCckNHWUljcFNBUkZKOXZu?=
 =?utf-8?B?TnRnQkRUaDVTVm1LTlE0UFAzL1lZeEdqMERuS2FQMXliMjhVQW13by9pQk1G?=
 =?utf-8?B?TEk1RzVyZHZqMTk4OUJoTDBicWlTeEtSTWtSRytwRjBDcGsvblExUkpDVUEv?=
 =?utf-8?B?TGZCN0I2RnJvN1kyeERBZGorQ0ZRUDRjamlTejRPbm5mRmttZi9PVXNQUjNk?=
 =?utf-8?B?Y1NVSHd0eEZ5NkQ3SCt2QUNQQ1NTYmFkSWU3eGZXd1BIUi9DSWVKVFlmdkVG?=
 =?utf-8?B?TUd5bXRSRjJad25xMDgwU0pBY3NpZGZCUWU3ditGYi91NmtOUTBBYnRZT0tw?=
 =?utf-8?B?aTdENU9LdGNzUnJuYWU4TnlYNGZ5UGVaSVN3SXBtVENqdHFNeXZJWVZybzBO?=
 =?utf-8?B?cG9UZnJFMlpra3czMURjRnVzOHEzWVVYODA2MXkySkhOa1h5WjdjVVZKbmtG?=
 =?utf-8?B?ZEVnZlhiR0k4ZG5HZzNQMmVESlp3Ny9DSmZpYXVUR3hJVWo1NDBqSzNaVUtk?=
 =?utf-8?B?UHVwbjVxRXRGeGJRaEVqbjVHUWoyR25uLzdhSnh0b1BwM1lEa3c3T2k4WnNC?=
 =?utf-8?B?VVlGMmozenVYeFZ4Rjc3amZaTjlYSkhBM2x2bVNXWFl4VmloNThucmNkak1E?=
 =?utf-8?B?QjdXZklzZVdiLzdLbTA5VzZIem16d3FLVkx1Wis1TENnYVF2dEpKczBHY1hD?=
 =?utf-8?B?eWR0enJ2WTl0L21vY3hjNE1Dc29NVlBPV2RtUjltSm5kUlVXV3FYVWhWbitK?=
 =?utf-8?B?M1MvRnFzMlpqN2EyRnkvVnlqTVlUNUQ4VVNFTTJ5OHdPSlFtZVBNcko5dGxy?=
 =?utf-8?B?RlRCQlRIeU0xalNydFpETkc4aGJDZzBZQ1FhM09xK2gxUHdGL0VROWQySGtw?=
 =?utf-8?B?amN6a2FnSldJVVJ5UTdNM0RRdGFRUnZEbHA4TlJkT0EyYzhua1N2bU8wcDh0?=
 =?utf-8?B?QkFzRi9TajRLb1RRWlhDVENTU01wWmZQblR3cVRGRVhscDQ0WUVHS0JRR1JR?=
 =?utf-8?B?WitXYzVjMHpxTEJhMVJjTDJiaG0xOFdscUpjN1c2Vk02TU9yRVdEaUJpVTZR?=
 =?utf-8?B?UGhacER5TTVFdkxMeEc4YXorcDJEdXd6bzJjYkFLRTdRRFd3d2tTTVVFUWJT?=
 =?utf-8?B?c2Q2TTBlUEc4SnFodW00dlhYZFo2RFZ5NkFVcWJsTk1rckF2UW1idFByaFFH?=
 =?utf-8?Q?wiXU5ll3fvP2FNsOOwjboP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63481B288D8A9A43BCF23A3AE878FEAC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb77520-e7d5-4e35-1b94-08d9f598f525
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 00:19:14.6007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MopEUe4Mk26L6hIxMSPZs/fXYl7FDpoYTIPWotaGaqm7DMl+n5UOCufHZVkVQTYYlXFNgD8q9lGMmIOFp/04A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR03MB5468
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGludXMsDQoNCkxpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4gd3Jp
dGVzOg0KDQo+IE9uIE1vbiwgRmViIDIxLCAyMDIyIGF0IDc6NDYgUE0gQWx2aW4gxaBpcHJhZ2Eg
PGFsdmluQHBxcnMuZGs+IHdyb3RlOg0KPg0KPj4gUmVhbHRlayBzd2l0Y2hlcyBpbiB0aGUgcnRs
ODM2NW1iIGZhbWlseSBjYW4gYWNjZXNzIHRoZSBQSFkgcmVnaXN0ZXJzIG9mDQo+PiB0aGUgaW50
ZXJuYWwgUEhZcyB2aWEgdGhlIHN3aXRjaCByZWdpc3RlcnMuIFRoaXMgbWV0aG9kIGlzIGNhbGxl
ZA0KPj4gaW5kaXJlY3QgYWNjZXNzLiBBdCBhIGhpZ2ggbGV2ZWwsIHRoZSBpbmRpcmVjdCBQSFkg
cmVnaXN0ZXIgYWNjZXNzDQo+PiBtZXRob2QgaW52b2x2ZXMgcmVhZGluZyBhbmQgd3JpdGluZyBz
b21lIHNwZWNpYWwgc3dpdGNoIHJlZ2lzdGVycyBpbiBhDQo+PiBwYXJ0aWN1bGFyIHNlcXVlbmNl
LiBUaGlzIHdvcmtzIGZvciBib3RoIFNNSSBhbmQgTURJTyBjb25uZWN0ZWQNCj4+IHN3aXRjaGVz
Lg0KPg0KPiBXaGF0IEkgd29ycnkgYWJvdXQgaXMgd2hldGhlciB3ZSBuZWVkIHRvIGRvIGEgc2lt
aWxhciBwYXRjaCB0bw0KPiBydGw4MzY2cmJfcGh5X3JlYWQoKSBhbmQgcnRsODM2NnJiX3BoeV93
cml0ZSgpIGluDQo+IHJ0bDgzNjZyYi5jPw0KDQpVbmZvcnR1bmF0ZWx5IEkgZG8gbm90IGhhdmUg
dGhlIGhhcmR3YXJlIHRvIHRlc3QgcnRsODM2NnJiLmMsIHNvIEkgY2FuDQpvbmx5IHNwZWN1bGF0
ZS4gQnV0IEkgZ2F2ZSBzb21lIGhpbnRzIGluIHRoZSBjb21taXQgbWVzc2FnZSB3aGljaCBtaWdo
dA0KaGVscCBpbiBjaGVja2luZyB3aGV0aGVyIG9yIG5vdCBpdCBpcyBhbiBpc3N1ZSBvbiB0aGF0
IGhhcmR3YXJlIGFzDQp3ZWxsLiBUaGUgY29kZSBmb3IgcnRsODM2NnJiX3BoeV9yZWFkKCkgbG9v
a3Mgc2ltaWxhciwgYnV0IHNpbmNlIHRoaXMgaXMNCmEgcXVpcmsgb2YgdGhlIGhhcmR3YXJlIGRl
c2lnbiwgaXQgY291bGQgYmUgdGhhdCBpdCBpcyBub3QNCm5lY2Vzc2FyeS4gVGhlIG9ubHkgd2F5
IGlzIHRvIHRlc3QuDQoNCklmIHlvdSBvciBzb21lYm9keSBlbHNlIGNhbiBjb25maXJtIHRoYXQg
aXQgaXMgYW4gaXNzdWUgZm9yIFJUTDgzNjZSQiBhcw0Kd2VsbCwgSSB3aWxsIGhhcHBpbHkgc2Vu
ZCBhIHBhdGNoIHRvIHRoZSBsaXN0IGZvciB0ZXN0aW5nLiBZb3UgY2FuIGZvcg0KZXhhbXBsZSB0
cnkgc3BhbW1pbmcgUEhZIHJlZ2lzdGVyIHJlYWRzIHdpdGggcGh5dG9vbCB3aGlsZSBhbHNvIHJl
YWRpbmcNCm9mZiBzd2l0Y2ggcmVnaXN0ZXJzIHZpYSByZWdtYXAgZGVidWdmcy4gU2VlIGFsc28g
dGhlIGRpc2N1c3Npb24gaW4gWzFdLg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0
ZGV2Lzg3OHJ1a2liNGYuZnNmQGJhbmctb2x1ZnNlbi5kay8NCg0KPg0KPiBBbmQgd2hhdCBhYm91
dCB0aGUgdXBjb21pbmcgcnRsODM2NyBkcml2ZXI/DQoNCklzIHRoaXMgYSBoeXBvdGhldGljYWwg
ZHJpdmVyIG9yIGhhdmUgSSBtaXNzZWQgc29tZXRoaW5nIG9uIHRoZSBsaXN0PyBJZg0KeW91IG1l
YW4gdGhlIGNoYW5nZXMgTHVpeiBoYXMgc2VudCBmb3IgbmV0LW5leHQsIHRoZW4gaXQgaXMgY292
ZXJlZCBieQ0KdGhpcyBzZXJpZXMuIFRob3NlIHN3aXRjaGVzIChSVEw4MzY3UywgUlRMODM2N1JC
PykgYXJlIGluIHRoZSBzYW1lDQpmYW1pbHkgYXMgdGhlIFJUTDgzNjVNQi1WQyBhbmQgYXJlIHN1
cHBvcnRlZCBieSBydGw4MzY1bWIuYy4NCg0KPg0KPj4gVG8gZml4IHRoaXMgcHJvYmxlbSwgb25l
IG11c3QgZ3VhcmQgYWdhaW5zdCByZWdtYXAgYWNjZXNzIHdoaWxlIHRoZQ0KPj4gUEhZIGluZGly
ZWN0IHJlZ2lzdGVyIHJlYWQgaXMgZXhlY3V0aW5nLiBGaXggdGhpcyBieSB1c2luZyB0aGUgbmV3
bHkNCj4+IGludHJvZHVjZWQgIm5vbG9jayIgcmVnbWFwIGluIGFsbCBQSFktcmVsYXRlZCBmdW5j
dGlvbnMsIGFuZCBieSBhcXVpcmluZw0KPj4gdGhlIHJlZ21hcCBtdXRleCBhdCB0aGUgdG9wIGxl
dmVsIG9mIHRoZSBQSFkgcmVnaXN0ZXIgYWNjZXNzIGNhbGxiYWNrcy4NCj4+IEFsdGhvdWdoIG5v
IGlzc3VlIGhhcyBiZWVuIG9ic2VydmVkIHdpdGggUEhZIHJlZ2lzdGVyIF93cml0ZXNfLCB0aGlz
DQo+PiBjaGFuZ2UgYWxzbyBzZXJpYWxpemVzIHRoZSBpbmRpcmVjdCBhY2Nlc3MgbWV0aG9kIHRo
ZXJlLiBUaGlzIGlzIGRvbmUNCj4+IHB1cmVseSBhcyBhIG1hdHRlciBvZiBjb252ZW5pZW5jZSBh
bmQgZm9yIHJlYXNvbnMgb2Ygc3ltbWV0cnkuDQo+Pg0KPj4gRml4ZXM6IDRhZjI5NTBjNTBjOCAo
Im5ldDogZHNhOiByZWFsdGVrLXNtaTogYWRkIHJ0bDgzNjVtYiBzdWJkcml2ZXIgZm9yIFJUTDgz
NjVNQi1WQyIpDQo+PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvQ0FKcTA5
ejVGQ2dHLStqVlQ3dXhoMWEtMENpaUZzb0tvSFlzQVdKdGlLd3Y3TFhLb2ZRQG1haWwuZ21haWwu
Y29tLw0KPj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2Lzg3MXF6d2ptdHYu
ZnNmQGJhbmctb2x1ZnNlbi5kay8NCj4+IFJlcG9ydGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmlu
Yy51bmFsQGFyaW5jOS5jb20+DQo+PiBSZXBvcnRlZC1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUg
THVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQWx2aW4gxaBpcHJh
Z2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPg0KPiBUaGlzIGlzIGEgYmVhdXRpZnVsIHBhdGNo
LiBFeGNlbGxlbnQgam9iLg0KPiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2Fs
bGVpakBsaW5hcm8ub3JnPg0KDQpUaGFuayB5b3UgTGludXMgZm9yIHlvdXIga2luZCB3b3Jkcy4N
Cg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
