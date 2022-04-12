Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FFD4FEB47
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiDLXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiDLXTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:19:18 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30100.outbound.protection.outlook.com [40.107.3.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310785468D;
        Tue, 12 Apr 2022 16:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXBH93bcplUSJFC6mUnE9H0S8VaGbnLHfBVPS3pI1SwOopoLarSDvQl/R681lNDMq7wqZLmriR2zjQBoffdUyHIIBL5p/9rfU78FZN94NqzbkOYVScJch8cXXMpBdOlbjpl78fdiyJg3aG3tEMgFasgKIDIpwktgtdrnrk5LoSw9UjPHnk9CtLBtWZbEVfTI15gz8r7JjmPL9YTmuD0KCt5VxH1LP2WyiL6nBBVAjACvV9Hxs0NFtrq7UkZoViCyxj2KrFxPwO6Ura06zelPbhpqIQLFjt81ul7yl6eF9MYxMb9CNTs3bOwT05oB6T1DG4JpWf0ZNMK9Qam8lAcQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuyVu+VIOZ2WFbjtCYvslkFrZ+J7jnmIVB0tJ9F2PYY=;
 b=m2YkyZ0GEqaUNX1T744gBYHC00e1Z63tTJ1WktcJWR4zfsbwAxK0i3qVCFLaj4PfH66h59tPvmWh5Csddia0E2VK0LFuQgCHA0VT4ZO3a0QnBHku19hMM3BH60hLpIS5QurNmBdM96zFVk/cTUf0Vx7lJ6IMzd/Ii05LNeo7yn4ejc9M8DazprtYEQTnutKLLmUiilfuOK+1hh3A+szM0Voyqcs7mOy9i6oT8v2dtOniIgCOnXpeuHqv/CyP0FYG4z0/jO9G0GuyXNe5SD6t8CxKrF7GJK4JGVnjx1K6jH0p0QnPtix5OzbCO4o75c0/FQ1jGh8eRBEdeDoT51yqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuyVu+VIOZ2WFbjtCYvslkFrZ+J7jnmIVB0tJ9F2PYY=;
 b=PfZBWxk7sywQljku+pXdYCg6pYtTW1QBmYwQcCPttiuOmxwNH6wkyBkJ8fDP71oerCtKuzawaGNqfGrZuarZpv2p+DHu2xAQYL3W4kFu7sJrfqzn9q26R0dB86vDZkRqKi+pmrTXysIgS/5deasdEBE7S1r4BEZh32hBE8C/fEM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7335.eurprd03.prod.outlook.com (2603:10a6:20b:2eb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 23:08:07 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 23:08:06 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?utf-8?B?Sm9uYXMgRHJlw59sZXI=?= <verdre@v0yd.nl>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] mwifiex: Select firmware based on strapping
Thread-Topic: [PATCH 1/2] mwifiex: Select firmware based on strapping
Thread-Index: AQHYTsIrbE9Y2HtXs0ik+cWIWEHxaA==
Date:   Tue, 12 Apr 2022 23:08:06 +0000
Message-ID: <20220412230806.jcq2q26gglavg2e6@bang-olufsen.dk>
References: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
 <20220408075100.10458-2-andrejs.cainikovs@toradex.com>
In-Reply-To: <20220408075100.10458-2-andrejs.cainikovs@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 354e7324-5efe-4b5f-4642-08da1cd94e0d
x-ms-traffictypediagnostic: AS8PR03MB7335:EE_
x-microsoft-antispam-prvs: <AS8PR03MB73351AE8B44E4C695325EF6E83ED9@AS8PR03MB7335.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hXWIGK017OMvNoeij/r/ODcoVCWBj20K6I0qQ2HlzWfOqnKO8jwdzNHbhPNPXmIimx0XM4j5kWIl5Y29FvVA2/1rFzP66BxE+s1ttf+O6gxqEYWQZuNsQpsa1GhCRJaodwouwBkA3lcJLZmCuS0jWBhXiKh0Ux4EMi9vsmVwPPujZ8co0gdWNc/m7reCWT6lQG4bkfciBTYVTzFQMpEDAVBpYS+vcr7+U0Nt/F8ur7+DTLlEm4pK4onQxrMwzYxc5d1yx/alC6zFW9E5sCT01X9EzDLdzLtJGHZqKemdD1NMu2kZXLRmNkoAL7t/TDEmkas+w4DHi1AnPJGl0RJZJNMOzHPBCuJo2NHebL74mtWx+VAOb2AEiRDTRozv/9YEJffownbF0hrptpqSabYn7KyOS6fLg/W2AZB2z8yjjMsSJWXby1A9phKZFU/9OkVrwdn5D7JpB+Xsl54So50BO+Hathga7XU00m/jFED5//+qgRqweTQZRiZ6N5mj4iGQC2lvsfOZY2D1kvBJe2eSSd94P9tXEHMDcS5N1xg+RqAtfufdWtvHRCEjM0P3F2ehVkNgOIB4WhOSb+E9th74gYFEdDOBpA2jx6ohESxLgJ97nRN/4wh4pI9rxUZno6fz4y66dHWqxIPtkdl43cnDf2kqcu3SNMbutPz+bABlQfA7mtI2TPH1a4nRwyCwVI5k9izi1Nj4tQghkL9n6dwnYnfG4Mxk3W29JmDAkMnMWQ2MoyJhzm6ql3zlL3UMQKQYLkwQAa97KwHJcQYz69pG6lrI/CIBf22UHbfyDw7cKQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(186003)(66574015)(36756003)(2616005)(2906002)(6512007)(26005)(6506007)(85182001)(83380400001)(8676002)(122000001)(4326008)(85202003)(66946007)(66476007)(66556008)(54906003)(86362001)(64756008)(316002)(91956017)(76116006)(6916009)(66446008)(8936002)(508600001)(38070700005)(7416002)(8976002)(966005)(38100700002)(71200400001)(6486002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFQzOGd5QWg4dCtrQlJ0WVlReDk3MTJBdTd1YWx4OWNqemhSOXFVUEFpSmp0?=
 =?utf-8?B?eVcvYmRXR1FKRXJYR2tsVmVaWHE3NHYrcitCejc5VHBELzU4M2pETm90b1JF?=
 =?utf-8?B?d21GRno3ei9GU3JoZk9OUjN4VDd5MkF4OXpNMCt4L1lZZnAwbGpCYmtydy8z?=
 =?utf-8?B?eS9OWk8zYlc3ZE9HTzM2b2lPbjRCZEJza0U5TDNMak54OFZCOGQ4MVBHWVhz?=
 =?utf-8?B?SzA5V2w0eHZ5RnhrMGRUZHhMZTN5cFRleVFkMkpuYVR0b2k5NEx3TE9TdTVu?=
 =?utf-8?B?UWdUdjdwYU5ocEdnKzgrME9lbjZvbkEzaVB5eVN4MytxUWZlakpoRk4wcGZ0?=
 =?utf-8?B?R2FTVDJLWDRwZDlWMjdoMlVBMWxmUVR1UUx0Y3RNYi9QTnFIZ0NrdTIveE1D?=
 =?utf-8?B?YmUrYmQzcmtJYXRKWGVQSkhQbWdUaVdmNVN3YXg1VFk3d1h1QlZQTHYzK1hE?=
 =?utf-8?B?WURGVllDL21SVmRLTG5mUHlGbXM2WkRGVytYbmhENjBGeUQwMndsSWMwQWE0?=
 =?utf-8?B?Qm5Bb3gyWDNaWnJSQnNTQ3VLRGxTakZGVXRaK2U5dTRRaWdVbDRvV2hsd09p?=
 =?utf-8?B?bnhnczAwcFBLcHVpb3dlU2x6MUZRbmUxTHVWbU0vRDRXQmpUUkd0Y25yVTBl?=
 =?utf-8?B?NHRWWmFzUGpsZmNBOGJocmx6WVlCSGhNcXI0cW9FMFhFUk9oS1N1T1kzUm5p?=
 =?utf-8?B?VXZCTFdQMXk3bGFuREQ3a1lyVGJSVTRPTWg4ZSt3RkFpUmhpNUFGYXdTYVJO?=
 =?utf-8?B?ZmxNWk1nNVRVOGRsbkJXbkh0ZnFGSkVydVFsWjRQU0tjM0xpQUZnWHFGU2ZC?=
 =?utf-8?B?NDJ0VEErQTdsZ2ZHNmo4VUhSR3RHck5jRlhHL3VMUDJuMnFHbkcwZ1p0eUZ2?=
 =?utf-8?B?RHRoYXkxR2dDWHliSFdtZnVQVjVidEdmZG9xbHJmTGNVeDFiUnl6UnZ6emVn?=
 =?utf-8?B?SVY0WlZOblNQN1NEWHA5QjRYRVp0VzF1VFNLdFBCQTJXbXloV1I1Z2dUa0h4?=
 =?utf-8?B?VXJPdm5mV2JodHJMOFZaTk5OMjZpR2RtNFdPNUpBd1lNa2VCQWZYb1pTVW5x?=
 =?utf-8?B?bGw0WW9qQXdOUVNEYlRqeDhHd0c1bDVVdmpRM2IrY3lIaDl3QjVwQk1BbzhO?=
 =?utf-8?B?dzNkRXRLa0NLZ25OWjdUcmEwYmRsZFlCUlNpQllnTFNPUHJ6TXZ1U2xRa0k1?=
 =?utf-8?B?MFlCbnVBQXhDelVRR1lZMVl2TFZvWnBBTlZDZDNHM2JWeTB3bmUvdjgrT0NB?=
 =?utf-8?B?Z0dwTzFBNVM0U1hURlNvMzZESXlhR2k4WUVzN0trVHd2WnRZcXhVUEhzSEVK?=
 =?utf-8?B?VFMwZEczcndIUkNIOGllM0RnRmRGZlVNUEUraXZFZ1JxNW1zVWNUbG1ZWWFm?=
 =?utf-8?B?bkhRSUdDTk9qQTRNUVkzWGRwR3JTcUdiM2dkK3JJaFRldnFnWDJOVFNZa1B2?=
 =?utf-8?B?S1NaT2UycWU0Qzc1NStSQUtPTlpqU2Uyd0JnUVdPRFdLRnpqanBLMlozaFk0?=
 =?utf-8?B?VEhlMzlzQngvakZSRlBidmJ4SjFQMjBWN1hKZVkwYURLMXFlMUg4MEpWQW5o?=
 =?utf-8?B?bmYyUE9qYzNIVGJVZGZuWVBYOU54bHB5dVdsKzlxbS9SVS81WjV2blFrUGxT?=
 =?utf-8?B?bmttNHI4aXI5K2dKZE9HNk5GNEd3dXJlMlZZNlV0WGJIVEZWUFJpMitNNmhK?=
 =?utf-8?B?eVI4TWR6U3lJdEJncm5JUFA3UzJmWlBpNW1ydmYwL2FvejYyNUo4V0VMSWV4?=
 =?utf-8?B?WmV4N2IwNFVjNWxwN3U0VmlBUzZSV2pTOVRUMFBaVUgrc3hVcVNMRmNhS0NP?=
 =?utf-8?B?VHZBM1lZL0VzM0lVeitBeEc1TWZBckk3b3NrQXlUallCN2I1N1Rha1pESnRO?=
 =?utf-8?B?eHRhcWtoN2E0NklZSHA1NDlnMkpIdHlhUFpyY3I4Z3Y2VzdsaThOL0ttb3VB?=
 =?utf-8?B?a2Z0OXRWZGhIeGVGQlo3NWg0dHFLUXdyeThYMnhwOExuSzErMkhrb3FQT3Bt?=
 =?utf-8?B?WFpmM3E4empVV2JPSWZDSm41eVFqWDB5LzBVa09JWFFYY0ltM0FwUGU2SU1m?=
 =?utf-8?B?UXVub2s2NzRmWlhuSS9CN0FIRVo4REl3MmFtMXBEMTFOTzFhbEpFd3VOdHRL?=
 =?utf-8?B?ajNlR1lxbWFRVVNBS0l5T3ZmaVBBR3dpRTRLQ05qTVFEN0wrTDA1SDdZd2lD?=
 =?utf-8?B?c2RQcFBkRG9VRlFFUUtJZUlmV0tDT3lVUEJsUnlTcktkNk55OVJQdnl0YUZt?=
 =?utf-8?B?N2t4ZTFmdzZtOWovUzErY1pUdXVBM3Y0czFlZXhHVmt6L0N2cWRKS0w3U0hp?=
 =?utf-8?B?d1ZzbW1jSk4xRXROTVFiMjB5YzdJYlhtZ0IyaEZ4UDhCdGgwYThIQmdSTnpN?=
 =?utf-8?Q?U5qscfTbTosSC1Vk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26262A33C28A0443BCC0D9F1F9AC8E8A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354e7324-5efe-4b5f-4642-08da1cd94e0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 23:08:06.8539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TpBeDPGtTN2uBWdF/NceFTZLYQSQfgrKPBOkirHkQESa6Kz6xHrqjG/nTxVRqCVkmW+BFY2NS+ZxjuzMdNkpew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmVqcywNCg0KT24gRnJpLCBBcHIgMDgsIDIwMjIgYXQgMDk6NTA6NTlBTSArMDIwMCwg
QW5kcmVqcyBDYWluaWtvdnMgd3JvdGU6DQo+IFNvbWUgV2lGaS9CbHVldG9vdGggbW9kdWxlcyBt
aWdodCBoYXZlIGRpZmZlcmVudCBob3N0IGNvbm5lY3Rpb24NCj4gb3B0aW9ucywgYWxsb3dpbmcg
dG8gZWl0aGVyIHVzZSBTRElPIGZvciBib3RoIFdpRmkgYW5kIEJsdWV0b290aCwNCj4gb3IgU0RJ
TyBmb3IgV2lGaSBhbmQgVUFSVCBmb3IgQmx1ZXRvb3RoLiBJdCBpcyBwb3NzaWJsZSB0byBkZXRl
Y3QNCj4gd2hldGhlciBhIG1vZHVsZSBoYXMgU0RJTy1TRElPIG9yIFNESU8tVUFSVCBjb25uZWN0
aW9uIGJ5IHJlYWRpbmcNCj4gaXRzIGhvc3Qgc3RyYXAgcmVnaXN0ZXIuDQo+IA0KPiBUaGlzIGNo
YW5nZSBpbnRyb2R1Y2VzIGEgd2F5IHRvIGF1dG9tYXRpY2FsbHkgc2VsZWN0IGFwcHJvcHJpYXRl
DQo+IGZpcm13YXJlIGRlcGVuZGluZyBvZiB0aGUgY29ubmVjdGlvbiBtZXRob2QsIGFuZCByZW1v
dmVzIGEgbmVlZA0KPiBvZiBzeW1saW5raW5nIG9yIG92ZXJ3cml0aW5nIHRoZSBvcmlnaW5hbCBm
aXJtd2FyZSBmaWxlIHdpdGggYQ0KPiByZXF1aXJlZCBvbmUuDQo+IA0KPiBIb3N0IHN0cmFwIHJl
Z2lzdGVyIHVzZWQgaW4gdGhpcyBjb21taXQgY29tZXMgZnJvbSB0aGUgTlhQIGRyaXZlciBbMV0N
Cj4gaG9zdGVkIGF0IENvZGUgQXVyb3JhLg0KPiANCj4gWzFdIGh0dHBzOi8vc291cmNlLmNvZGVh
dXJvcmEub3JnL2V4dGVybmFsL2lteC9saW51eC1pbXgvdHJlZS9kcml2ZXJzL25ldC93aXJlbGVz
cy9ueHAvbXhtX3dpZmlleC93bGFuX3NyYy9tbGludXgvbW9hbF9zZGlvX21tYy5jP2g9cmVsX2lt
eF81LjQuNzBfMi4zLjImaWQ9Njg4YjY3YjJjNzIyMGIwMTUyMWZmZTU2MGRhN2VlZTMzMDQyYzdi
ZCNuMTI3NA0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmVqcyBDYWluaWtvdnMgPGFuZHJlanMu
Y2Fpbmlrb3ZzQHRvcmFkZXguY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21h
cnZlbGwvbXdpZmlleC9zZGlvLmMgfCAxOCArKysrKysrKysrKysrKysrKy0NCj4gIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zZGlvLmggfCAgNSArKysrKw0KPiAgMiBmaWxl
cyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3NkaW8uYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zZGlvLmMNCj4gaW5kZXggYmRlOWU0YmJm
ZmZlLi4yMzE2MGQxNzk0ODUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21h
cnZlbGwvbXdpZmlleC9zZGlvLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVs
bC9td2lmaWV4L3NkaW8uYw0KPiBAQCAtMTgyLDYgKzE4Miw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgbXdpZmlleF9zZGlvX2NhcmRfcmVnIG13aWZpZXhfcmVnX3NkODk5NyA9IHsNCj4gIAkuaG9z
dF9pbnRfcnNyX3JlZyA9IDB4NCwNCj4gIAkuaG9zdF9pbnRfc3RhdHVzX3JlZyA9IDB4MEMsDQo+
ICAJLmhvc3RfaW50X21hc2tfcmVnID0gMHgwOCwNCj4gKwkuaG9zdF9zdHJhcF9yZWcgPSAweEY0
LA0KPiArCS5ob3N0X3N0cmFwX21hc2sgPSAweDAxLA0KPiArCS5ob3N0X3N0cmFwX3ZhbHVlID0g
MHgwMCwNCg0KSSBoYWQgYSBsb29rIGF0IHRoZSBjYXJkcyBzdXBwb3J0ZWQgYnkgbXdpZmlleCwg
YW5kIGl0IHNlZW1zIHRoYXQgdGhlIFNEODk4Nw0KYWxzbyBzdXBwb3J0cyB0aGlzIHN0cmFwcGlu
ZyBkZXRlY3Rpb24gWzFdLiBDb3VsZCB5b3UgcGVyaGFwcyBhZGQgdGhlIHNhbWUNCi5ob3N0X3N0
cmFwX3tyZWcsbWFzayx2YWx1ZX0gc2V0dGluZ3MgdG8gbXdpZmlleF9yZWdfc2Q4OTg3Pw0KDQpb
MV0gaHR0cHM6Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcvZXh0ZXJuYWwvaW14L2xpbnV4LWlteC90
cmVlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL254cC9teG1fd2lmaWV4L3dsYW5fc3JjL21saW51eC9t
b2FsX3NkaW9fbW1jLmM/aD1yZWxfaW14XzUuNC43MF8yLjMuMiZpZD02ODhiNjdiMmM3MjIwYjAx
NTIxZmZlNTYwZGE3ZWVlMzMwNDJjN2JkI24xMzY0DQoNCj4gIAkuc3RhdHVzX3JlZ18wID0gMHhF
OCwNCj4gIAkuc3RhdHVzX3JlZ18xID0gMHhFOSwNCj4gIAkuc2Rpb19pbnRfbWFzayA9IDB4ZmYs
DQoNCldpdGggdGhhdCBjaGFuZ2UgYWRkZWQsIGZlZWwgZnJlZSB0byBjYXJyeSBteSBSZXZpZXdl
ZC1ieSBpbiB5b3VyIHYyIHBhdGNoOg0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFs
c2lAYmFuZy1vbHVmc2VuLmRrPg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
