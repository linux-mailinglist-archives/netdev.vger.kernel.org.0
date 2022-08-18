Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE375986DC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344139AbiHRPGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344008AbiHRPGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:06:48 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2126.outbound.protection.outlook.com [40.107.21.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD3472699
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:06:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ7219JhqyBpvmHsUKDocIKL83L1f3te6Ish9VKXFYAePEDrm6JlqDaT8xlFu7UgVdsA1jk11p+U/raDAecNWdPu1+l1R5Pwiybo9LZRwS+csCYN+BgTJ9uCvClVSlBHyWfQDLyGPAkpgNrgTminpja1t2MOSP1ye3XiZViKnZO1EwsmMs6ac7MOtl5Cg4pxu+CXDnoDiyc+j3zNP7s/hXHjw1uW3szFdG8vKnXEP33zjYnNSbnVUSQhy08TYh2mP87UKDTeR8ekMVRVMpSskbPU3ggc8MrzhPFafKJ9fudbkzumWPsgVqQaAZA8iqZvagZEaQK7z9Pp2Dzv5/doOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwbBkJCfLSnOTasPAaB83wEUxjEbt8uwcK85T0vErwc=;
 b=RlPn5QF51ypI6yNLsru53fpEct9CTwmGUXdadwq3/CRdtgzE/d6hPk+W2ozFyJDxbOQmaLGm+ltA5LcbPInWql/MVTgCyHcj4cTgil1L0WfjmHCDvcZ804+d07EaDmHABNNvNxvyynFt4MERCbQMdeeo9nxdZTx2zywOe124tQSTJSkpJjyyUZg3jPcVw0OW4ty4qZdttwI3lhRSe+zgdmB8oN7e40jVYcqc5qF0XvgpDxYPKP5UIzpFARgWsku3ysKpfQySQR2UERF6yGQdjmxfsYYZCM4sSZm9Vb2NTKNkn7rF/B3aP5EvzDArRhZJGwZxavcG1OKOOfAZ5H8XCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwbBkJCfLSnOTasPAaB83wEUxjEbt8uwcK85T0vErwc=;
 b=HL4BHNzFnPw3fsuZ/JtacAbO2j26eqZJcj4Dpzkwb/xj0byJxdyjRW5djN/qYBzPDHQ2AdQ4RAiEyd+GaDRID9FFQWS/Cn2GnDezW+Vq+OoTQybmm5UEf0JFOIFmUHLTYutYUQmqoF8CAYTvmyawSJR8t01IdyyQ+T+6r6tvawQ=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by AS8PR03MB6887.eurprd03.prod.outlook.com (2603:10a6:20b:29f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:06:44 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Thu, 18 Aug 2022
 15:06:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Topic: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Index: AQHYsw9zHhN3dtpaN0uEx4R4ZuVmoa20wiIA
Date:   Thu, 18 Aug 2022 15:06:44 +0000
Message-ID: <20220818150644.ic6pf5arbh34lr5z@bang-olufsen.dk>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55cd8fcf-14ef-4bff-f298-08da812b43b3
x-ms-traffictypediagnostic: AS8PR03MB6887:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hN3RWLRwBQcjYiVjMKuU71k/Or9h6YPgruMzUGyAopjkaMeipfLUt2yrJ5kOMo9FcPxm0MNH/7yMhUrO4QR25gbTXQ4bXkYCcTVaLifTwRyEBe5uQ0OJ+KW23q4bVqZ4qclQ0+nYcVR4/54WUnv4OdSQOaRdLt4TB3eRIWpKT9SSWs4QC60jkfYqU7VeOM/C3gztRl+fRE5/UtU0My3SJJc1PpYT6uHmjXBlCTTpg5ClbZD0pN5Eg5p77ZmGq3DKlfA2V7oNM0QxOUyNG1Hy2BUKqY7UAzePw1HeK6KM7awkRQPj109ojO7ARA5MAclMk4K8d4MVtc9FWfK+qJ2gexEPmeMiFJXUvMDBg3Wuvn/en5YkGjbg5ttJ/puTnNGM6xCnZCThEURb1x9IRDTY58Ax2ylTJ20cdUk3v4+SnMeuRe1We1rR5kTKuL2wdD07ivs+fKWJjvTggBqmcZfWxj5+GF0x0yTYPgkszkn0cPEzerEFJoMuTXHj6/NbdhEYZBsZaeIl8hVg2PmIfg04hLvTBS1nvKedgDc40sNaMcPjXHkA86hpQ3D9F6RCm5kbsxdFUnzMscKNmDhhcq4/vX/mbqBsLbnbLQMMGXSxLyZ/T6XE2uZEasl7gqiOnX8fkvkyrxL4DjhlcfG0zdcLigxKawnEZBSB7BHjrGnMnmqvkQiLwTjPu/PFl5ewinAeP9ZNqCM0NTlrbWhaKf0DYJW21Dfjxv4VXRdodfl3HUUrUM+UOS/IR36QTKH3pxql+uWsD07SPVDCXzHkNU2dbQN/MkXW1ngtJj/+iOR8iJI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(366004)(136003)(39850400004)(41300700001)(38100700002)(122000001)(85182001)(85202003)(36756003)(8676002)(83380400001)(54906003)(316002)(64756008)(66556008)(91956017)(76116006)(66946007)(6916009)(66446008)(4326008)(2616005)(186003)(66574015)(1076003)(38070700005)(66476007)(6506007)(8976002)(8936002)(2906002)(966005)(6486002)(7416002)(5660300002)(71200400001)(86362001)(478600001)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVJsYVRNemtUUW5ZL0k2VGJ1Uk1rbGVRVHhYb3Nxd1RXd1NVMXZHRitGbFVE?=
 =?utf-8?B?a1hjSU1obWgvQysyUytXWFB0cmpuczZva1pnQUtjaUhDYUhuVmUzSktSaWVh?=
 =?utf-8?B?aElISm5tL3pENmFMYnFUSEUxSC9VbkRwV3E3SkdJeWs2dXV4YjNaNlVqK3lC?=
 =?utf-8?B?aUNuQVlsU3dtY0hYbzJiOHZuallyamhyTEs1cy9PbXZxdkg1U2ZQOCtTVncw?=
 =?utf-8?B?SVA0RDBxRlZ0b296U3Rmc09VN2s3cE5sSmFjZXNuTW9VUEoyRmJ6NFk0NGln?=
 =?utf-8?B?QU4xS0o4d0VJNGFRWWIwbkQ3RjFtcGZ2TmJoV2FVSEdCbkFpMW9ObDFxc1B3?=
 =?utf-8?B?VXRzSzl2emVsYW9IbzRVK0YrQU1sZUxRR3FESHFnZFJBVjMzVUlGRFRaRkti?=
 =?utf-8?B?OFlMYWNWUWxvM3hZZVJEL1RMbWlOR3BZbUFsK2ZLV0RKSUFKcndVY25Zd28w?=
 =?utf-8?B?RjV6TVJUbXRjbFZ2bW1mYnRGWWdva1UvZEViVXdOUGZRODUzM0tsUTM0VE13?=
 =?utf-8?B?TGRKeUpSRll0Yld6OTRaOXdtd0hZKzZ5aFZObWxsVGNLQlZ1UCtXZE1VTUhT?=
 =?utf-8?B?OWNtOVhRR2FwMnp4ZnlmUExmTnQ5TXU0ZmJFUlo2clN0azJnSjA1UHkva2lV?=
 =?utf-8?B?ajhtMW0xRVZ2eUJCK3VuVzAyWm5ZZWd0VzB3NjhtakNBZlUwSnFuQlFIWlFV?=
 =?utf-8?B?TEFORExnbjVwaGhINkQrVmhoMFhTaDRtd1MzaEI4MFo1TTlwenVtQ3JRMytZ?=
 =?utf-8?B?ZHYzdDhWYXhTWlIvMTJrKzRlNnN3ejJlaDFYeE00VjhqYzZVUmFIQ21WMTNl?=
 =?utf-8?B?UG9zRnRmc1A4QjJtUUFzNEtpUlBkUWN0M1Q0bGFmY3dSZGdoUHFBQmNpcXRI?=
 =?utf-8?B?RlhGcmxIRk9YT2NLWXZ3dFdsd0NOaDhEYks3dWhCaWVvK1JsZXJCclhKdGtx?=
 =?utf-8?B?OXEzTUZQTmcwTzBKU0I3a2M4VVVqeFFlWGtwcUsxT3ZENWFwWC9jclR6WnpU?=
 =?utf-8?B?Y0lBUDg1U2hYMGhrSVVpeXJINmtzb2FyeFJlMG1UbGxBaGZrSzU2YjI0OFNB?=
 =?utf-8?B?UTF2VW1RTTFlZ0ZzM200TUNKdXk4aFNycUlVMkpjOVJsRi9aRGczaVQxYXB5?=
 =?utf-8?B?NFpSQm82cXQyVW5jNTB6bExQbW93R2w4VXBSNS9qQ1B6cXdlMndPeEM5ZmM1?=
 =?utf-8?B?VnhCTnpUdVVmY1F1UG43T3U2VUhLN2IvTXRKSkp5MkFHMFUzQmEzSmcvbzhx?=
 =?utf-8?B?dSsyeHhTMVN6U3ZtVzhHVDFtVXNwZkxURkJDL09sTWhBdkhFTy9rdWcxNEpD?=
 =?utf-8?B?Wit6UCtIeTB3MWdHaE45T0s2RDBYdDUwYlUwUGFRR1kvSjI2U3BYZWF3YzhD?=
 =?utf-8?B?UkZCN3BtbWkyd0NLZHMxWTRrNmNSNC9QZU1WZnA5MG1nRzhhdjY5MjhvaEdR?=
 =?utf-8?B?c1dTWDdiQzVHSUp4U1NML2FIV2FGTlYyTFNjR0k4cXVOQ3hZV3FIOWtJMWFY?=
 =?utf-8?B?VmpNZFJLaWdiclNPWXk0SjRzZmVBREJWTGtJTWJDT2Erd3JnYk4xUFFOcUNn?=
 =?utf-8?B?RUROWlQ4WjArRjFZcDZvT3FrOG5Fcmp5SjIza3BEWmI1WXFMUEdaemJFNWhH?=
 =?utf-8?B?QkhWajBBTXhDbjk3VHhReFZmMG44MHdPTmtVVFpHWmxYWkFhbm5LWkxhQnpE?=
 =?utf-8?B?WVJ6SG52TitJQkZxZW83TkVjem1Sb2hhMUMrM01URkRncUpTbVROeDZUQ3U1?=
 =?utf-8?B?bmhMSit1MCtCZWVoWjUrRCtuQk1JZDE4QjVuZXE5Z0F2a1BFNmZON0ZnWGM1?=
 =?utf-8?B?eDdleXBlVE5hODNwaGVha0o3WXZ2Ylc1VzFvMnZZS0U1TmFhQnRaYlMzZEJF?=
 =?utf-8?B?bVdYeG96NHdyalNTdHFHdzdGcjhvVUVBZ3RZUThIUnlqM2lFTjNUMDA3YXUz?=
 =?utf-8?B?cDdvOGY5b0lPbDdKTTF0ZkV3QlFmMklPK0lRd0pKSlYzQzZOQVJ5SzFaSldt?=
 =?utf-8?B?V1JKc1h0MFVvdFpjMEJiUk4zaWFYNDBaK2pzMnlTQzk1Umd6YjlONU8yY2R3?=
 =?utf-8?B?bUNtdUp4M1B3QTFmOVZKRUxGTk9oNStUdG95T1BlYTc5RW9NWDI0V0I4VTI5?=
 =?utf-8?B?U2VPTkdBMFZyV21WdHBtUUlaWTNzWEVNNXMvZThLempnTnVhOGlDdEJvaVFj?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <413C6D1877408F47851CD3CF94DB29AB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cd8fcf-14ef-4bff-f298-08da812b43b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 15:06:44.5164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lT8u5WRZqRsKyGEHhVcNbU4NVHjrWH0/5hWd5CmtpWpCjwORmLdYoSzVxdQB2m2t1XfFNgXG98TdR7MVu6Rnpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6887
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgMDU6MzI6NTBQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBEU0EgaGFzIG11bHRpcGxlIHdheXMgb2Ygc3BlY2lmeWluZyBhIE1BQyBjb25u
ZWN0aW9uIHRvIGFuIGludGVybmFsIFBIWS4NCj4gT25lIHJlcXVpcmVzIGEgRFQgZGVzY3JpcHRp
b24gbGlrZSB0aGlzOg0KPiANCj4gCXBvcnRAMCB7DQo+IAkJcmVnID0gPDA+Ow0KPiAJCXBoeS1o
YW5kbGUgPSA8JmludGVybmFsX3BoeT47DQo+IAkJcGh5LW1vZGUgPSAiaW50ZXJuYWwiOw0KPiAJ
fTsNCj4gDQo+ICh3aGljaCBpcyBJTU8gdGhlIHJlY29tbWVuZGVkIGFwcHJvYWNoLCBhcyBpdCBp
cyB0aGUgY2xlYXJlc3QNCj4gZGVzY3JpcHRpb24pDQo+IA0KPiBidXQgaXQgaXMgYWxzbyBwb3Nz
aWJsZSB0byBsZWF2ZSB0aGUgc3BlY2lmaWNhdGlvbiBhcyBqdXN0Og0KPiANCj4gCXBvcnRAMCB7
DQo+IAkJcmVnID0gPDA+Ow0KPiAJfQ0KPiANCj4gYW5kIGlmIHRoZSBkcml2ZXIgaW1wbGVtZW50
cyBkcy0+b3BzLT5waHlfcmVhZCBhbmQgZHMtPm9wcy0+cGh5X3dyaXRlLA0KPiB0aGUgRFNBIGZy
YW1ld29yayAia25vd3MiIGl0IHNob3VsZCBjcmVhdGUgYSBkcy0+c2xhdmVfbWlpX2J1cywgYW5k
IGl0DQo+IHNob3VsZCBjb25uZWN0IHRvIGEgbm9uLU9GLWJhc2VkIGludGVybmFsIFBIWSBvbiB0
aGlzIE1ESU8gYnVzLCBhdCBhbg0KPiBNRElPIGFkZHJlc3MgZXF1YWwgdG8gdGhlIHBvcnQgYWRk
cmVzcy4NCj4gDQo+IFRoZXJlIGlzIGFsc28gYW4gaW50ZXJtZWRpYXJ5IHdheSBvZiBkZXNjcmli
aW5nIHRoaW5nczoNCj4gDQo+IAlwb3J0QDAgew0KPiAJCXJlZyA9IDwwPjsNCj4gCQlwaHktaGFu
ZGxlID0gPCZpbnRlcm5hbF9waHk+Ow0KPiAJfTsNCj4gDQo+IEluIGNhc2UgMiwgRFNBIGNhbGxz
IHBoeWxpbmtfY29ubmVjdF9waHkoKSBhbmQgaW4gY2FzZSAzLCBpdCBjYWxscw0KPiBwaHlsaW5r
X29mX3BoeV9jb25uZWN0KCkuIEluIGJvdGggY2FzZXMsIHBoeWxpbmtfY3JlYXRlKCkgaGFzIGJl
ZW4NCj4gY2FsbGVkIHdpdGggYSBwaHlfaW50ZXJmYWNlX3Qgb2YgUEhZX0lOVEVSRkFDRV9NT0RF
X05BLCBhbmQgaW4gYm90aA0KPiBjYXNlcywgUEhZX0lOVEVSRkFDRV9NT0RFX05BIGlzIHRyYW5z
bGF0ZWQgaW50byBwaHktPmludGVyZmFjZS4NCj4gDQo+IEl0IGlzIGltcG9ydGFudCB0byBub3Rl
IHRoYXQgcGh5X2RldmljZV9jcmVhdGUoKSBpbml0aWFsaXplcw0KPiBkZXYtPmludGVyZmFjZSA9
IFBIWV9JTlRFUkZBQ0VfTU9ERV9HTUlJLCBhbmQgc28sIHdoZW4gd2UgdXNlDQo+IHBoeWxpbmtf
Y3JlYXRlKFBIWV9JTlRFUkZBQ0VfTU9ERV9OQSksIG5vIG9uZSB3aWxsIG92ZXJyaWRlIHRoaXMs
IGFuZCB3ZQ0KPiB3aWxsIGVuZCB1cCB3aXRoIGEgUEhZX0lOVEVSRkFDRV9NT0RFX0dNSUkgaW50
ZXJmYWNlIGluaGVyaXRlZCBmcm9tIHRoZQ0KPiBQSFkuDQo+IA0KPiBBbGwgdGhpcyBtZWFucyB0
aGF0IGluIG9yZGVyIHRvIG1haW50YWluIGNvbXBhdGliaWxpdHkgd2l0aCBkZXZpY2UgdHJlZQ0K
PiBibG9icyB3aGVyZSB0aGUgcGh5LW1vZGUgcHJvcGVydHkgaXMgbWlzc2luZywgd2UgbmVlZCB0
byBhbGxvdyB0aGUNCj4gImdtaWkiIHBoeS1tb2RlIGFuZCB0cmVhdCBpdCBhcyAiaW50ZXJuYWwi
Lg0KPiANCj4gRml4ZXM6IDJjNzA5ZTBiZGFkNCAoIm5ldDogZHNhOiBtaWNyb2NoaXA6IGtzejg3
OTU6IGFkZCBwaHlsaW5rIHN1cHBvcnQiKQ0KPiBMaW5rOiBodHRwczovL2J1Z3ppbGxhLmtlcm5l
bC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjMyMA0KPiBSZXBvcnRlZC1ieTogQ3JhaWcgTWNRdWVl
biA8Y3JhaWdAbWNxdWVlbi5pZC5hdT4NCj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFu
IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzel9jb21tb24uYyB8IDggKysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdh
IDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCg0KU29tZSBxdWljayBncmVwcGluZyBzaG93cyBhdCBs
ZWFzdCBhIGZldyBvdGhlciBkcml2ZXJzIHdoaWNoIGRvIG5vdCBzZXQNClBIWV9JTlRFUkZBQ0Vf
TU9ERV9HTUlJIGZvciB0aGVpciBwb3J0cyB3aXRoIGludGVybmFsIFBIWToNCg0KICAgIGJjbV9z
ZjINCiAgICBhcjkzMzEgKCopDQogICAgbGFudGlxX2dzd2lwDQoNClNob3VsZCB0aGVzZSBiZSAi
Zml4ZWQiIHRvbz8gT3Igb25seSBpZiBzb21lYm9keSByZXBvcnRzIGEgcmVncmVzc2lvbj8NCg0K
KCopIEkgbm90ZSB0aGF0IGFyOTMzMSBvdWdodCBub3QgdG8gcmVseSBvbiBEU0Egd29ya2Fyb3Vu
ZHMsIHBlciB5b3VyDQpvdGhlciBwYXRjaHNldCwgc28gSSB0aGVyZSBpcyBhY3R1YWxseSBubyBu
ZWVkIHRvICJmaXgiIHRoYXQgb25lLCBzaW5jZQ0KdGhlIG5ldyB2YWxpZGF0aW9uIHlvdSBhcmUg
aW50cm9kdWNpbmcgd2lsbCByZXF1aXJlIGEgcGh5LW1vZGUgdG8gYmUNCnNwZWNpZmllZCBmb3Ig
dGhvc2Ugc3dpdGNoZXMnIHBvcnRzIGFueXdheS4NCg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmMNCj4gaW5kZXggZWQ3ZDEzN2NiYTk5Li43NDYxMjcyYTZkNDEgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IEBAIC04MDMsOSAr
ODAzLDE1IEBAIHN0YXRpYyB2b2lkIGtzel9waHlsaW5rX2dldF9jYXBzKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQsDQo+ICAJaWYgKGRldi0+aW5mby0+c3VwcG9ydHNfcmdtaWlbcG9y
dF0pDQo+ICAJCXBoeV9pbnRlcmZhY2Vfc2V0X3JnbWlpKGNvbmZpZy0+c3VwcG9ydGVkX2ludGVy
ZmFjZXMpOw0KPiAgDQo+IC0JaWYgKGRldi0+aW5mby0+aW50ZXJuYWxfcGh5W3BvcnRdKQ0KPiAr
CWlmIChkZXYtPmluZm8tPmludGVybmFsX3BoeVtwb3J0XSkgew0KPiAgCQlfX3NldF9iaXQoUEhZ
X0lOVEVSRkFDRV9NT0RFX0lOVEVSTkFMLA0KPiAgCQkJICBjb25maWctPnN1cHBvcnRlZF9pbnRl
cmZhY2VzKTsNCj4gKwkJLyogQ29tcGF0aWJpbGl0eSBmb3IgcGh5bGliJ3MgZGVmYXVsdCBpbnRl
cmZhY2UgdHlwZSB3aGVuIHRoZQ0KPiArCQkgKiBwaHktbW9kZSBwcm9wZXJ0eSBpcyBhYnNlbnQN
Cj4gKwkJICovDQo+ICsJCV9fc2V0X2JpdChQSFlfSU5URVJGQUNFX01PREVfR01JSSwNCj4gKwkJ
CSAgY29uZmlnLT5zdXBwb3J0ZWRfaW50ZXJmYWNlcyk7DQo+ICsJfQ0KPiAgDQo+ICAJaWYgKGRl
di0+ZGV2X29wcy0+Z2V0X2NhcHMpDQo+ICAJCWRldi0+ZGV2X29wcy0+Z2V0X2NhcHMoZGV2LCBw
b3J0LCBjb25maWcpOw0KPiAtLSANCj4gMi4zNC4xDQo+
