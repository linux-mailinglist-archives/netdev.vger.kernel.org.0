Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5026B9A36
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjCNPq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjCNPqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:46:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287A01A1;
        Tue, 14 Mar 2023 08:46:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfZ9VjDfc4BYaOmNfvM3jwVVA8bWjQRwSpMqrIpHFATlxkJeqSf1gPykBii4z1i1DLp70OArHoAJSktWOfAFm6IaF4CloMZwBXI2yHhoogMHj36rujv7W45pc+x//rxBcPm85gZpZDm3cIQZmfsQM458CRVIfoIitcZnsSAgRmb2pvEyREj95BffXc3DE/s+kLHDI1UOrt3GcJRLP+z15uSgedGdYdQjDoMPRcGNlZ7TbYHEhTZtCjuW0stGNqZjPb/Y4CN35lvy6Tvtr9d059+hREIuTdX5ZWJ+mKVkV02Su14JA8QrUiDyo6Xa6Qumnzd8BCJbpfncTLbhEB5REA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSEVygR0e+cT7g/SI5Milnp6h8l6VBpcnJ+LDP6ZNxE=;
 b=UY5xax05x65KMfHNbObpAyCbvRJJOPsrHEW+fYTgb1WpyyST3i9ANbt/h5OmxJWupBej8R+nqjCSxsgC6258G8tW3fkNxJC27bGXswZloXiRyTlDin938jXgh5sk2JGB2W+S4pcomOIl+SWlKNe6YwvdK5KiApyk6urD1lewwBMmw8JEVuDEEO9IapTCABNJIGu80iqTMK64pnjH7TlFRGTMBul48Gdclx68ceWF5uSvsxcKoBlNSFsihsRBdgnQSC88QqdXrCzin5neI41dUX6w+fnaDglxEnnh+5z5M9bd1nwiqB5TQtLbSOWdRMgmyYwTYDrTLPcUa5p6InVuRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSEVygR0e+cT7g/SI5Milnp6h8l6VBpcnJ+LDP6ZNxE=;
 b=m9CCiomFds9YMa44zUy3vhBZSFIJ8ou3tfvNs8DOVFpsp129tx2eRFSQ5d0XZtc1PHYzjHyl0ui1ejQ3tG7uJvEDNuilEybPSd77P2NINOVCNdElW6xRMRcTZfDxBXdsnpeFQ6ygSxtGVuhtSvc388+07DWB8bfiqL9b+gUvvmc=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:40:34 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:40:34 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v10 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v10 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZVotRGPsclWmNZ0GS/ELZRggMMQ==
Date:   Tue, 14 Mar 2023 15:40:34 +0000
Message-ID: <AM9PR04MB8603E3F3900DB13502CFCB8DE7BE9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-4-neeraj.sanjaykale@nxp.com>
 <ZBBUYDhrnn/udT+Z@corigine.com>
In-Reply-To: <ZBBUYDhrnn/udT+Z@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|PA4PR04MB7744:EE_
x-ms-office365-filtering-correlation-id: b61f96cc-4fac-4f27-7e01-08db24a2739a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6BGl5JB51HkFjgStFdEqtNTxmMjelXh6gOLTYWz59oOhDrxstORjVirg5v2bBixJKcoPEDPwrV98v5/DxfC0HoIy8/+oYaqLMGFqQl+/vzc+AOpiM3wXfRM8Cv6RB4aU0IK65MpRWYgUhkUCf8w6cMu/TBKjpnv7HJPyp/LKisPM6BZr7jLb1kSAOySYy8ks4KwcoNJAGPK1Gyo4RS0B5WKqbzmSF5SsayXQMscSjSpeXv1GTom1ThAxM1b7JS9l3OR7Hnt2vqt3oktoiIhbM0HPrjxbneXtan/CFwvvwN4+aHy4XCWT6a2HEFAwsR7GGTGR7xRwjyXA7EiSI3QbBP8sqBiLPQbYcFEcNjP4ZuKNR1ke1n3eAFjzDj6vhfRbmKl2UYma3kNgPxf3OiCr/SLSjo6A6FuEBCSI/h+pYT6+VRF/Fm9Nso0BaZWYoeQG0aS/NfBHatptbGM1fbZPI1bLpb1omkCBh1isUZZcxLjC3P/d8cHJb/7ehGWP/36sqPLqy1Wykpk52+ASPJERP4GRbRzw/2zit/gXIqsRkYfp6+XaQdVjHIVUDNyFthsNdNZNsKkSQyqH8HA7193O4Yv8WuMPTl1QKaIj/izTcKZC0Na4AutmkWEb9BI8Pr8DYMFQv5IQi/B+N69Rst32DU+iZarjm8Dt8z0gLPjdj1rRdz/LgeH5t/JzayQtBO2ORlNBWa9bYYajmw5rG/eRqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199018)(6916009)(9686003)(4326008)(8936002)(5660300002)(52536014)(186003)(26005)(41300700001)(7416002)(6506007)(86362001)(33656002)(316002)(4744005)(2906002)(55236004)(83380400001)(66476007)(66556008)(64756008)(8676002)(66446008)(66946007)(7696005)(55016003)(71200400001)(54906003)(478600001)(38100700002)(38070700005)(76116006)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1FCaDFENVVrTGY5REFnNEE1djIrdWk1ZVpFa2c1V3NMNnQwbHhGZXF0ZGxp?=
 =?utf-8?B?UzM1dGs0Q0R3L2RNM3RMc0RacE9WeDdhMVc5eGdaZ1pIZXlxVTJoRWZucmJZ?=
 =?utf-8?B?My9jbTNDWUNaekowK1BsckNYVjI4SFQ3THUxY3hBcTVWTGxkejdOVkp0Q3J2?=
 =?utf-8?B?WTlPY1d0aE4wSXVqK0FEWGFYSkpDRE1pOHR5TEdlZm5odzN6MWxWV1QrSzNF?=
 =?utf-8?B?c09yWkxsd1JDNWVSS1lxTnNGS1RjVVVtUW1VVFpEQ2VMeWlXR3oremFNN0ly?=
 =?utf-8?B?R0tYK2twSlVlVU5CalVHb3hkUWRJNnJtTkVYd3ErSGM1L1IxSE15R3FDN0tn?=
 =?utf-8?B?eUJLVWNrQWdlcEFrMmFHS2h0aXJmU2U3MGNHM1M1V2swYWVzL1BxUjBLQjRa?=
 =?utf-8?B?M2JMYm1CNWh1WU1QM1RpZythTW5OejNkTzFoUEpyWWxHZEZCV1lISXA3VzhC?=
 =?utf-8?B?c3NxeEs1NjlieFhOZ0I3cFgzaWlrVFVGb1M5dDhlTDlKNUd1Z2NuSnlWSjVU?=
 =?utf-8?B?MEN5cnFhNGc5WVdYdXI1UVZ4TXFSRmtlTmlUWHJ6MmtyVkxldGNoWXllMjRj?=
 =?utf-8?B?UzVWd2I0UkJCY1piSGRZdTM3SWVHeEZlQ1JVbXVYUXBVeXNYbi9pM0IxeUx3?=
 =?utf-8?B?ek5VVUdnRFVPNlNoZXJGQzNaa3JCZXhabTN2WG1oOW12UFRIS2FzdlB3WXNF?=
 =?utf-8?B?c2xVNFZURFFmbE5aUlZ5OXhScWhhNERJZEFDa00vVmxqMWM1U0lwR0UyTDBs?=
 =?utf-8?B?MWJ5YTBrMU02UlBicHhTVU5PdENsM05uQTIycGNic0FRMjdKS2lnSWFITE8w?=
 =?utf-8?B?MCthL2NIcDdCVXF6ai9WN1RLbk5WTGRPeUpQcjJESEtvU1M5c0lFd2hYck5s?=
 =?utf-8?B?ZXVLdGxETXJ2SUJpK3hocmlDMzkyaDVBMVFvdVBVSS9naTh4TGo3VGNnV1Jr?=
 =?utf-8?B?Y3NlY2VYZVlKMnp2SnRlWHJ5NkhudUExckdUVVNuMHFxeUh2ck9DR0RXbmVy?=
 =?utf-8?B?VlNwcTVSc0QxdEJJVlVzbnp1NnVCS0ExbmJtTXdmYWd2c3lWRlp0b3hZYzF3?=
 =?utf-8?B?dFQyeG1EUlNPbU5DWmpydUNFZTY5TFFPYlRDb2tQdnNRdHVlV2NxSjVzZ3pu?=
 =?utf-8?B?REM5bkFBVW1oNHlTYUdiT2Vsd1FuUGh6ci9VZnJoL0x0SEJtc0YxdzVtaVdU?=
 =?utf-8?B?TWdLS3A4WTZ3VVY1cXJmT1FiaVVGVU01ZmRjMENRR1lEM1I4dDRpRG1jNzh1?=
 =?utf-8?B?TDUweEEyd0RleW4zTjc0WjdKL3JYcmJFZ2pDNjVBU05YZFVsdEllbkhWc1NB?=
 =?utf-8?B?YTViSVVIOHdBMVp3QWpEVWRNbXVSV0VJeGdyL1NCZDRlbG1rMGpBU2V5ZEly?=
 =?utf-8?B?WHNtZ1VMQ3Jsd1FCT3lRMHJXWnhpc0FxMUhWc0t3RTlaSkhOekZYV3F6R1ZY?=
 =?utf-8?B?WVdUdVFIejNQOGNwcUE5S1ZFYjlqdmNpbzI2dzRkaGpPTi9KVGUrY3VFampT?=
 =?utf-8?B?QSt4WWJkV21QdEpZRUtzSVB2ODZXNzJhcUxTSkNueVEvdjB3L2xxcm8yL1NF?=
 =?utf-8?B?d0Y5VVRycldoZ3QxeFBxckRyeno5bklkV1BxdTErb0o5MXVHVnVjejBtRFl0?=
 =?utf-8?B?Y0g4YUo5NlduZ1p5YkUzQTN2WFVzUCtxWUlSUWpid05IWnFiNlJ6NWFIS3o3?=
 =?utf-8?B?a1VmOWo1S0grSTNsdWZiVm1rM3Z5TkJ0ZmNqSjJYY0lkNm5Lajl6eEJWS0Vz?=
 =?utf-8?B?cm9BbmZJU2tDRjAvTGpSWE13TEhNcE43TlNha1JxaEpjRjY1YythYkpUMVB4?=
 =?utf-8?B?eW5zT0FDdXBLOVhmZ3JiVVNoZkdQeVVsdUJ6ZDhaOWV5Z25PdVc3MHo5ZjZs?=
 =?utf-8?B?UERvMGZQbi9Ec0U2dEhqOXJwQjlxK2ZDZ0Z0TXVRUzgyY1VRTzhjSUlScTBn?=
 =?utf-8?B?OStUMFRIWnozZ0Z5RUNTTTBlcjR3Snl0cjVGQUpRV09qMFJ4SFVhSWJxbVRw?=
 =?utf-8?B?VjJEL3ZtV0l0RkVDeWtmMmd5K0ZlL0w2aEVhbk00eXFXK3BwK0FucUU3VXhN?=
 =?utf-8?B?WUJFOFNuSEc2Qm90TGNsT3pPZFQyQVJ3azMrcEJibkQrTjlRYSt5aDZxd0p5?=
 =?utf-8?B?KzVNVkg1OU1DUFRhbWtSOURkcWxFb0w0VUREUG4xajFUOC9QSUFUdXpHSEtr?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61f96cc-4fac-4f27-7e01-08db24a2739a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 15:40:34.5395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tqlnv9B+EGQAz/PMz5kpY3/gh0tLQStBaG1y9drDcKp2brDHJODhVjN4JKp1fMgBtT1zf0Al+DLbV/JJ7+VMmmo9FkvIrX/ImK3LvOuZM7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2ltb24NCg0KVGhhbmsgeW91IGZvciByZXZpZXdpbmcgdGhlIHBhdGNoLiBJIGhhdmUgYSBj
b21tZW50IGJlbG93Og0KDQo+IA0KPiA+ICtzZW5kX3NrYjoNCj4gPiArICAgICAvKiBQcmVwZW5k
IHNrYiB3aXRoIGZyYW1lIHR5cGUgKi8NCj4gPiArICAgICBtZW1jcHkoc2tiX3B1c2goc2tiLCAx
KSwgJmhjaV9za2JfcGt0X3R5cGUoc2tiKSwgMSk7DQo+ID4gKyAgICAgc2tiX3F1ZXVlX3RhaWwo
Jm54cGRldi0+dHhxLCBza2IpOw0KPiA+ICsNCj4gPiArICAgICBidG54cHVhcnRfdHhfd2FrZXVw
KG54cGRldik7DQo+ID4gK3JldDoNCj4gPiArICAgICByZXR1cm4gMDsNCj4gPiArDQo+ID4gK2Zy
ZWVfc2tiOg0KPiA+ICsgICAgIGtmcmVlX3NrYihza2IpOw0KPiA+ICsgICAgIGdvdG8gcmV0Ow0K
PiANCj4gbml0OiBJIHRoaW5rIGl0IHdvdWxkIGJlIG5pY2VyIHRvIHNpbXBseSByZXR1cm4gMCBo
ZXJlLg0KPiAgICAgIEFuZCByZW1vdmUgdGhlIHJldCBsYWJlbCBlbnRpcmVseS4NCj4gDQo+ID4g
K30NCj4gDQpXZSBuZWVkIHRvIHJldHVybiBmcm9tIHRoaXMgZnVuY3Rpb24gd2l0aG91dCBjbGVh
cmluZyB0aGUgc2ticywgdW5sZXNzICJnb3RvIGZyZWVfc2tiIiBpcyBjYWxsZWQuDQpJZiBJIHJl
bW92ZSB0aGUgcmV0IGxhYmVsIGFuZCByZXR1cm4gYWZ0ZXIga2ZyZWVfc2tiKCkgaXQgY2F1c2Vz
IGEga2VybmVsIGNyYXNoLg0KS2VlcGluZyB0aGlzIGNoYW5nZSBhcyBpdCBpcy4NCg0KUGxlYXNl
IGxldCBtZSBrbm93IGlmIHlvdSBoYXZlIGFueSBmdXJ0aGVyIHJldmlldyBjb21tZW50cyBvbiB0
aGUgdjExIHBhdGNoLg0KDQpUaGFua3MsDQpOZWVyYWoNCg==
