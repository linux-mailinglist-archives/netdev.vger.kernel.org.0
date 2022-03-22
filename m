Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12444E3B03
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiCVIqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiCVIqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:46:20 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2118.outbound.protection.outlook.com [40.107.255.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23772711;
        Tue, 22 Mar 2022 01:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avH1gGocdIpKCdZCo/WtjAE8yibg3HKIE1w76mtP/IJb7kGS2Gj09RQAbfY4nlk6EXOcPVgOvE8vZur3TYiTc2ckEdm0Wl2je04Zj40EElUh0p9g7d0imCWjpyxHS2MM7mO+hrUWzWSyOteg3/aHcf3oTyLX2yf6SQ5q02GAsz4wgSBYwgnMm0MilXzZfXgXeXezr7iezHqryN722E1eeDLP18i8GJGnYc089SHHhNp42AcfH1oBgIffPO8sooGKmKtdtFeGJnpg5aA00TSy1JPgy7zneLoTj0nik4wLlL5g9bFD6J9XZtDpui1zoE+3ASz0D36m6uFj1l00W0I5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmXKVN3I9jRMSBIIYS+DqdALFSePutZDFAu+NcHF6Og=;
 b=K2HIt8/8ZwB/RL1zQDVdkzqHIDoc0LwBrigJ0HylVk0yLvjSZnbFBwgPMfvNOfGq1AmD9D0KnH+nqrjj6h01j5LBFkXs2k4bezzSYfh7hkXI+Cb4mg8zpsoWnd9DkhGd2y+w1BEa5gjPjjkkvhdf3e+iqXEFYObWX4XT5Sj0YICLKlJoaW/Zj5m6uTpOnxnXym5SNwRPxAxUh0KDY7yNRnOklUNv72wq2bnFN4wJS4wL+78wNYDICCR0YI7fcuT+Wkxwt4hov1B/jlfeBC0t8XkA7wSb2dEtqpzLTU0zj0Zs1p92OuD7uviDFwz8YAd38ACVEtlc7gJ/g5/CErbeGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmXKVN3I9jRMSBIIYS+DqdALFSePutZDFAu+NcHF6Og=;
 b=AwApGpPAsi6TcGPzRsJQqiZpqtJvGUUkOm3DF0/Fq9qj0541JwPgYQzY//i9gsmlueaiVDfxLZwCXgqglaAcQ4tGAoRq39/4v4R8wgSoHViclXQYyGASt8sNJ5WP+ziiR6o0xzvlk+ItUwWHeGNxh44/FSnlC9LBzXzilfXzoyTHcoS7ro8p23/Kq4q5MNLj09ufLlQndVHcMkxhxsZ9Yr740EgzEVIN/blzdO9wZe93+bO/k9W1aWQrwjzHFebWDOt2UVCAYui8zzZpoSXPUPe02EV4dDShPbPVcBlg+nuOPu0jTQqqW2LxiNUsHwrSWC2yzH2a4J8Y4AZKMoFPJg==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by HK0PR06MB2081.apcprd06.prod.outlook.com (2603:1096:203:4c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 22 Mar
 2022 08:44:45 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 08:44:43 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Topic: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Index: AQHYPQnwNYsxHNQRykGxCSuH1L0VZ6zJ/XGAgACv7MCAAGlkAIAAAHBQ
Date:   Tue, 22 Mar 2022 08:44:43 +0000
Message-ID: <HK0PR06MB2834EDCF527EE9DE79C1A6AE9C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
 <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
 <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
 <216b98d5-a254-4527-c569-9f3397811e70@kernel.org>
In-Reply-To: <216b98d5-a254-4527-c569-9f3397811e70@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02d5f37d-2d45-452c-7c2a-08da0be0364a
x-ms-traffictypediagnostic: HK0PR06MB2081:EE_
x-microsoft-antispam-prvs: <HK0PR06MB208117A959A6ECD320127A149C179@HK0PR06MB2081.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wb0tm3uQHDm+j1EIm/8R2fyawC0/Oy7q8nTYgMK0cf8qPaFU+AUYR4da03W/BtTvLyIODr7zfvfn+Ugfi/aGWQIgceRMGCfwIt7p5MtS+kqNX2xLvR+PnDcrl3y2vCjs8a+S64k6UxxHaMRhq8R01Itb9JYdEMwpr+dtkY6xDf9TGdP9mx0ApWyjXlr1oePyEfDyBqfORzP2en1Dt0YxMLHp85ERpvAaoZt1yrmVBc66eya4YeomocKNAOpwcZnLjJhF2LrBBma1A15z17JfjNWUk61z6DDI/5g11nWdrA4T2NF4rkHLcgcCaQvRSYYHY9rRM+zQz8hFWkpWsK7u5baXM105y2UqGuBnOhYTKGmWe64QTxmtTHKaEfwDAf09bspR4rlhsm0dKUgtG19HLV4btb52yZakFCSExGtzXYYPxOJuK4lsbifKactKmrySC9zvaafCVLWD2uFESkYlcZY59ZYYQmL8AZxTOoMCrnYPcDEvU/mQ6325A/8FjQqC55Ti1mGjbEEv+kpOLLDF09+/bpU+vpl2J6GHPsHWKzg0k0KQOvp3ENEreDB/A5EJUsPmafwTBeY1iM96Vxm6jpJE3fEcaTCUeJ8Bf+3EEI8VVnuIF7cqjwLMfrm7t5e7UXAU2HHHFeyVfGThbH1E5kED5kiAhUGHPEl9HyP4jksqhp1WJz6Bew0IXhNWurmFG/NspstUdvi02tesIa37z0uCZWvETcHEgzBwcvCUlEc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(39840400004)(136003)(376002)(346002)(8676002)(53546011)(186003)(26005)(66446008)(33656002)(66476007)(64756008)(9686003)(55016003)(66556008)(6506007)(71200400001)(38070700005)(8936002)(7416002)(2906002)(5660300002)(66946007)(4326008)(76116006)(52536014)(86362001)(7696005)(38100700002)(54906003)(122000001)(921005)(508600001)(83380400001)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3dGN1Y2T0pZYyszeUNxKytYUWZoRHBPTTJWbFVpZ0RDYkU2a1hZUTBFTlkx?=
 =?utf-8?B?TWNSbUZxbnJySDRxWlVJcU9uQ3RQa1QwWkhRa1dDWjMyQnd6MVlFQzlUSW1T?=
 =?utf-8?B?bUpCaU9ERmxTNXhxOE50TXZGdlAzcFRmZTErL3NxR0JUR2Z0aTlsOUpIU3Y4?=
 =?utf-8?B?Zmw0bFF5VFhwekNZSkZ4bTl5aHU1Snh6Y2ZMMHg0SWhaTkpPZGFHUjlzaVlS?=
 =?utf-8?B?WFFjdUNtN1dFVG5CZUR0cjhiUHhHeXozdFd4SVY1K1d3d0QzOEppbXZ3dGVG?=
 =?utf-8?B?dlcrelZtMjNNT0RNdEdaMGlwWXdHSmpBbFpBWDBEeE5TV0lnMHRDU2tqUnlo?=
 =?utf-8?B?Z1dEdjRlNy9QRHNhcFVKTEpKSzlVUXlRcFphRmlhREtQV3FnaXVXM3h5bU91?=
 =?utf-8?B?RzBITVpybnNVb1JsNmJnQ05SUDUwQWN2M09lUkM4c2FUL1d3d3haOWtwU3U0?=
 =?utf-8?B?Slh0VXEzZFdKVmRiQUY3c0pydWFFTkoyL3hJV3RCN2VMNDd6d3RQaFZDNUZ0?=
 =?utf-8?B?c0hqdmx4b3hEU0x3cEo4KzBGTUhmZk1EOVQ3Y0xrNjQ1Nllxd1gyN3lSVGlT?=
 =?utf-8?B?QnRsYjVPVEwvZE01TnhJUmVUeHVJcFEwU0Yvb3JZamtqem1nczFzQzN1UHpI?=
 =?utf-8?B?OVgrWU9TTnhoMmtVanZsNXdKSzhNMlIwYWZRcDFya2lkZDF4S3drSUpNRHJn?=
 =?utf-8?B?WHN1WVNTVnR2WTI3WjIrVVljYTIzd2ZPdlA2b2c4ejlYN0NRSzdoYVJQbVZY?=
 =?utf-8?B?ODF3V0JFVVo1TEwvZzJ1c2NUek5UNGlzcVBKYTFGWTNvTDloeVBTY0srTTZn?=
 =?utf-8?B?MmxzREVPKzZJbTJhd2FSREV5Wjg2RkhyeUlHTE01eXduZlQ1elpmdFlOZjFV?=
 =?utf-8?B?NkhFSVhFNVpYTWFHeFplZXdlaTFMd1FPb3lhRjBWaXFBeXFSTDNjamdxcFZU?=
 =?utf-8?B?TkhINXBLS0RGREIwN2ZxRGVCQ1JjRm1oa2FPQ1dYU1dyWUx4YlNDYnlvbE10?=
 =?utf-8?B?OVR1ZksyOU40emZYOTN1dHdOWEI5VlJWZGdLZW8wcE1JVHA3UGhiRkJUbzRw?=
 =?utf-8?B?aG1MaGgrdnpDWmc2Rmc4VlNVcXh2SWFnT0F6MFpnSTF2VWRzazlNZ29VRWI1?=
 =?utf-8?B?dDN3NU0xRFlPdy96eUN2OHloM1J2REZxWlEzOGh2ajU2WTBHakExVEV6Z0o2?=
 =?utf-8?B?eUFqZ3hwMkFLSjM4TUs4ZkhidmtxRHNZTEZ6UHdUN0U2SkUxVG1jU1dQMGtj?=
 =?utf-8?B?c3RJeXcwZkhGVlNmTEdSMzVnNWtBTnlxZXFxRmYycm9xRUxJQnlKMUhDUUFu?=
 =?utf-8?B?bVdSYy90MllseHNxZEloOWJYbnN3dWV5em44L2NIYmRhVW4wanZKUFprRDRj?=
 =?utf-8?B?WklKRytTN3d3K1gweWpsbE5IaThTOThZM21uelRxZlVSZnpzVks1T3dUNmtF?=
 =?utf-8?B?bndOQ2hYcmM3OVVDWXFleXVlUUljeHd0V2JBUm9iVkRSQlVmTWpuT3NJNEky?=
 =?utf-8?B?Ymd0ODBhRGt6TjY1ZTQrZEpWTjdBcWk2QktHcHRUU3B5emJVcy9ZZGkxL0g2?=
 =?utf-8?B?c0RpT1JJa2N5NmNvREtPZHkycTc2ZXVsWGNoYjZTWFlJMjVKbm9nL1ZNVzk5?=
 =?utf-8?B?YzdZK0oyU0MxcGM0a3N0WnpPbXRmVGJNdlBjMDJqZ2x6eHdXRDA0eWVuMFI3?=
 =?utf-8?B?TVcxeHlkZWdhV2I5OUlzUUo1T24wcThYdXdYbXFQN3RMYWEwWmc3SStRc0xz?=
 =?utf-8?B?ZGE2NHRwN1J3SmRVMWl0SHhsOHl3YUZFNlBva1ZSNVV2ZU5uSmJ2bG4xZVl2?=
 =?utf-8?B?Wk9tcUZrVVF3cDJtaFZTWDNIa3lsekx0TlBSUTBwMUFpRnU0djJOQitJRWx3?=
 =?utf-8?B?LzdrTndrZ3h5TGROOHQyS3NmckNkUk5OYWJrb2sxbjN3eUl6VEhJM0tlTitO?=
 =?utf-8?B?MFFmY1o4VWRmV3JiZWgvOFdNSjhGSVcyNDFHV0tJbXl2Qy9XNnNRUlIzOW45?=
 =?utf-8?B?OFJIRjlsWUFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d5f37d-2d45-452c-7c2a-08da0be0364a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 08:44:43.5121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyyRvDBND13T1tXWeuuh6uaq9CjcUNAgOR9PsicWe1+uEeizwBhT1fstLDzmM3N6J4H0IDpJUlrgoiUWqetxKdo5mNK+6dKy7U65lC/crPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IFttYWlsdG86a3J6a0BrZXJuZWwub3JnXQ0KPiBTZW50OiAyMDIy5bm0M+aciDIy5pelIDQ6NDAg
UE0NCj4gVG86IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+OyByb2JoK2R0
QGtlcm5lbC5vcmc7DQo+IGpvZWxAam1zLmlkLmF1OyBhbmRyZXdAYWouaWQuYXU7IGFuZHJld0Bs
dW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGludXhAYXJtbGludXgub3JnLnVrOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29t
OyBwLnphYmVsQHBlbmd1dHJvbml4LmRlOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4g
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1hc3BlZWRAbGlzdHMu
b3psYWJzLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZw0KPiBDYzogQk1DLVNXIDxCTUMtU1dAYXNwZWVkdGVjaC5jb20+OyBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMy8zXSBBUk06IGR0czog
YXNwZWVkOiBhZGQgcmVzZXQgcHJvcGVydGllcyBpbnRvIE1ESU8NCj4gbm9kZXMNCj4gDQo+IE9u
IDIyLzAzLzIwMjIgMDM6MzIsIER5bGFuIEh1bmcgd3JvdGU6DQo+ID4+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEtyenlzenRvZiBLb3psb3dza2kgW21haWx0bzprcnpr
QGtlcm5lbC5vcmddDQo+ID4+IFNlbnQ6IDIwMjLlubQz5pyIMjHml6UgMTE6NTMgUE0NCj4gPj4g
VG86IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+OyByb2JoK2R0QGtlcm5l
bC5vcmc7DQo+ID4+IGpvZWxAam1zLmlkLmF1OyBhbmRyZXdAYWouaWQuYXU7IGFuZHJld0BsdW5u
LmNoOw0KPiA+PiBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOyBk
YXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+PiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQu
Y29tOyBwLnphYmVsQHBlbmd1dHJvbml4LmRlOw0KPiA+PiBkZXZpY2V0cmVlQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOw0KPiA+PiBsaW51eC1h
c3BlZWRAbGlzdHMub3psYWJzLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4g
Pj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogQk1DLVNXIDxCTUMtU1dAYXNwZWVk
dGVjaC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjIgMy8zXSBBUk06IGR0czogYXNwZWVkOiBhZGQgcmVzZXQgcHJvcGVydGllcw0KPiA+PiBp
bnRvIE1ESU8gbm9kZXMNCj4gPj4NCj4gPj4gT24gMjEvMDMvMjAyMiAxMDo1NiwgRHlsYW4gSHVu
ZyB3cm90ZToNCj4gPj4+IEFkZCByZXNldCBjb250cm9sIHByb3BlcnRpZXMgaW50byBNRElPIG5v
ZGVzLiAgVGhlIDQgTURJTw0KPiA+Pj4gY29udHJvbGxlcnMgaW4NCj4gPj4+IEFTVDI2MDAgU09D
IHNoYXJlIG9uZSByZXNldCBjb250cm9sIGJpdCBTQ1U1MFszXS4NCj4gPj4+DQo+ID4+PiBTaWdu
ZWQtb2ZmLWJ5OiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPg0KPiA+Pj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4NCj4gPj4gUGxlYXNlIGRlc2NyaWJlIHRo
ZSBidWcgYmVpbmcgZml4ZWQuIFNlZSBzdGFibGUta2VybmVsLXJ1bGVzLg0KPiA+DQo+ID4gVGhh
bmsgeW91IGZvciB5b3VyIGNvbW1lbnQuDQo+ID4gVGhlIHJlc2V0IGRlYXNzZXJ0aW9uIG9mIHRo
ZSBNRElPIGRldmljZSB3YXMgdXN1YWxseSBkb25lIGJ5IHRoZQ0KPiBib290bG9hZGVyICh1LWJv
b3QpLg0KPiA+IEhvd2V2ZXIsIG9uZSBvZiBvdXIgY2xpZW50cyB1c2VzIHByb3ByaWV0YXJ5IGJv
b3Rsb2FkZXIgYW5kIGRvZXNuJ3QNCj4gPiBkZWFzc2VydCB0aGUgTURJTyByZXNldCBzbyBmYWls
ZWQgdG8gYWNjZXNzIHRoZSBIVyBpbiBrZXJuZWwgZHJpdmVyLg0KPiA+IFRoZSByZXNldCBkZWFz
c2VydGlvbiBpcyBtaXNzaW5nIGluIHRoZSBrZXJuZWwgZHJpdmVyIHNpbmNlIGl0IHdhcyBjcmVh
dGVkLA0KPiBzaG91bGQgSSBhZGQgYSBCdWdGaXggZm9yIHRoZSBmaXJzdCBjb21taXQgb2YgdGhp
cyBkcml2ZXI/DQo+ID4gT3Igd291bGQgaXQgYmUgYmV0dGVyIGlmIEkgcmVtb3ZlICIgQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmciPw0KPiANCj4gVGhpcyByYXRoZXIgbG9va3MgbGlrZSBhIG1p
c3NpbmcgZmVhdHVyZSwgbm90IGEgYnVnLiBBbnl3YXkgYW55IGRlc2NyaXB0aW9uDQo+IG11c3Qg
YmUgaW4gY29tbWl0IG1lc3NhZ2UuDQoNClRoYW5rIHlvdS4gSSB3aWxsIHJlbW92ZSAiIENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnIiBhbmQgYWRkIG1vcmUgZGVzY3JpcHRpb24NCmluIGNvbW1p
dCBtZXNzYWdlIGluIFYzLg0KDQo+IA0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YN
Cg==
