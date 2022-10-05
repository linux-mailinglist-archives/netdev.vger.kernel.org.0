Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A335F54AD
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJEMkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiJEMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:40:13 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130084.outbound.protection.outlook.com [40.107.13.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1A6205E3;
        Wed,  5 Oct 2022 05:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPmb2y/Y75r+FhizPKHcMgY2NPoKwEjlRkE/0wJgMdTDq7zb6YmifWzBFeSMNMrxyQ4IWsNzSKsbrK6BIuYI1lnH+rF2oAT0O74LtYlTXBzBON1R2A7d42n0pBxUtsF1/Xr4wxChx30qtCRcaw5fXgwh0lUi/1d+qkAK5ED5qdEFfY9bSQbx2ixgRULemgycJEKMRBWAikc+PkU1h+Bd4VhihVYNLo0zmDf0aBX2Yu1qoPPLOuNl31oeNxyTyZNkYkDciLTNmoFGb+4Cx3xraILctCRLUpLbX+AcG9PQdfDYuv2xPdhUkg9ehGS+WlB19jiHczmwqAZaT+31UxLNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glkT2lgjlsY527C1LTK96Rcfbh2RFW+nBf04ti+a/aE=;
 b=cw2lljnH28deTqoco9YNuTdDNxDk3jG4nYyCaO6UT7HyGL/pzWoz2SUa37XwIvVj9U4ci0Rd3CVwa2A9+RjMKHqm5tyMHxO1DaaYM8AqUJ1sLtyB/juysDffoI2Zq+pQJEUz08yx7Z166CT/1BEYbc8287oo2KlF0RclOm1Bri0w2JTqZvN8NrziJMO0v3UHIV1uD5In86LsIvX6e5jXvN0lhFzs0RQkRoQgRr/2Xh4gZon0ZAj1VdWYn/VyJuZvw1VLJzqvlBeslZw1o9NTCSiIJ40O5Ss0m/B231CkHhR4rquuPb1lWpt0j7lcb+iTVbKnQ31YVlmi0fzRhhurBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glkT2lgjlsY527C1LTK96Rcfbh2RFW+nBf04ti+a/aE=;
 b=r3VgHluqIX09eSqY7pE1iPV7QdXkK3M8yMqYk3fGIT1hXh4Dk0p2a0IaW1WKH+8OFZjNAuEZ5X2toe3k0H6UnVg188W5AgD3o2plvFeh5QRovvd3gyy+Csw/Djt/hnLAs0Gpb5QiFTJ2pct+nRxGIYcq6DzY4CnUS8i1Krp/Td4=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM0PR04MB7025.eurprd04.prod.outlook.com (2603:10a6:208:19c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Wed, 5 Oct
 2022 12:40:08 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::d076:3c2e:4567:7187]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::d076:3c2e:4567:7187%7]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 12:40:08 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31oHQAgAC4dcCAAA2WgIAAADZwgAAi/oCAAARmwIAANVQAgAXfkgCAAX1ggIAAGiewgAAJ2QCAAYMXEA==
Date:   Wed, 5 Oct 2022 12:40:08 +0000
Message-ID: <PAXPR04MB918565DF416D879FF9232A6C895D9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
 <PAXPR04MB918584422BE4ECAF79C0295A89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <afb652db-05fc-d3d6-6774-bfd9830414d9@redhat.com>
 <PAXPR04MB9185743919EC6DDA54FAC3B7895B9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <4f7cf74d-95ca-f93f-7328-e0386348a06e@redhat.com>
 <AS8PR04MB9176281109667B36CB694763895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
 <AS8PR04MB917670AAD2045CEBC122FEE1895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB917670AAD2045CEBC122FEE1895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM0PR04MB7025:EE_
x-ms-office365-filtering-correlation-id: 5aaf7f24-2cd3-4b66-3203-08daa6cebc9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXjDbyis/y5VIRHmxMA7OL0b/9666T9kcpbe4aNLVv2MKAZX8DApIiSrWoe8XrJfIuTC4Icaum+YgPHa/1t9wTihr5Ny+g4VyyRPj3uXTIhZliNjm721AL71+nquG4JrDyP5cykeZkcAY/gxMnfTYkrP2WHiukRtgaLGNLUt+mDMiIE6grGPmDp0RrgF76KHqmuK2mFGN0lwmZ14c15J20vpHkEA+edaoOUtYfFL20CWLCiAwSWlPdsSJiyQZyHsE3f8vQYEkAd4qoGfhTIS7xq2F/dMcNuJUs8idypZhzbE8vCorcOFTl2i4ul4VByGJyS9ZHDkAJJhmXYoZ1zVOopJPrNntZLxFDhMJdAXn33o16xT2GTGYdJDFbQh2l3QB/Jxy+RqgYTvdcUsx4HohhBG5MYDGQCTnjJVD/nbM0DGjpzx0xAJvRelGV0FEfpzaiXZUkiLVKc1IPtiHA1Sp/MJ4/cwylJ0UTe0k2XxVmoXhjJLZsmVirjMmvDyqt/Sq1ApP4b++Sr9hdT4sZ/ta+MTYxnUFpvx2LsOa9IFG3CZiIvBLGibISrOtoXw81MfelKYlLE6sI0sXcjOLqOIrb2BtblJ6hrlZmy218E/DAJvTdEFSCCp4sQP8ys329a+Nn49OBAHBGfILSSDk8yiTLrmymq6tG0yAbxMF5ZCYM7S9bUE2HdlGaF0OqlHdsQpXRBHvFBnUEEVZrzGztegfXbTf2pGDtqII704NRYpSoGt7EzbVAtqx1sVu4BuWEq9AqPHm1Lc9JJ1i1uov/oIfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(316002)(8676002)(76116006)(66476007)(66556008)(66946007)(66446008)(64756008)(4326008)(38100700002)(38070700005)(110136005)(41300700001)(33656002)(71200400001)(55016003)(7416002)(44832011)(86362001)(54906003)(52536014)(122000001)(8936002)(5660300002)(2906002)(478600001)(6506007)(53546011)(186003)(9686003)(26005)(7696005)(55236004)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0hScXl3M3c1QTZpMWxIcnBJTWZoMVlvWFZRUjZrSHI1VGtPSjhSY2JmcHBy?=
 =?utf-8?B?YmdOSGZpMEFNb3NoRk5XOVlPSWpsV2dYVHg0ZkdoSEJvdzIySEF6YXhaNFhM?=
 =?utf-8?B?bEtwQmFzS0VBcCtUTUNnam5lZEdFTVlCckJrV1FESzg5dXVyelM3ZmorMHFQ?=
 =?utf-8?B?Nko3ZU5QSVpqTzBBNGdKcjNkNzZWVXR2cUM5Vzl1SkV0Z3lPZG1MYVRieCt2?=
 =?utf-8?B?UWpnSmM0dDN6RDdYcXRpMndEQ2hrRlJ5SUJHM1VuRHBQcVA0T2NFLzBPaXpp?=
 =?utf-8?B?cjdlcjBSdDZBT0svM3l5UVZTVGxwbVpsb3VySER1TGNCSmZKZnBvdml2dEJS?=
 =?utf-8?B?dUxqSnU3RGJ5dDF2SVk4STJvM1F3d21WbVllc0xuZk8yT1k5aUpJYi8wZ0lU?=
 =?utf-8?B?QStPMGV6V21aeTRoNzd1OE5VMEEwL285VFB0UE9IMlNUTmNQSWIyTklXaUpD?=
 =?utf-8?B?L3ZQT1kxRnhzMktJL0wxVENCWVB6YXEwc0NwMVFWcDB4dFUyS1JPWGhxNUls?=
 =?utf-8?B?d3JuVml4TENzdmsrTWtuUDBVVm9ZRml3WHpmNXNXR3BteG1UV0h1VE9uRWhj?=
 =?utf-8?B?TGtvUTJxOWJ4Qm10YzE3aVd2b0NaS1BsWjd3VTNab1B5bWF6YjdoWFNvYVJB?=
 =?utf-8?B?cXB2Q08vYk9ubVBJaTdocmdCMHpHaW9KZXd5aXBhemdiNHVnbStHYldGMTkx?=
 =?utf-8?B?VUYwb0I1Q051aXQ5WGlCcTZtSW1vVzMzeVdLb0pqMVc4eFBJVlhkc2hheUJ0?=
 =?utf-8?B?dFB5M3VSME9BVktSYkFoRWgraUN2alBLclVCcjRjemlDWEsrcjdKbEs3QkQr?=
 =?utf-8?B?dWNpNEdTZjJEek1SUFp1Mit6UXJ5VHRjVUtEaGxqR1hGTUVsR0ExR255UC9N?=
 =?utf-8?B?V2JiMWxCQzdpbW56c0UvSUpaNkxtcVVFcURtVmtuVEJyS2drOTNHVThwcHkw?=
 =?utf-8?B?dmxsZkZON21GRkVWWHhOR0c0SWdNWC9zd1pXVks1M1QyenYxYWhWdmZGd2dz?=
 =?utf-8?B?SWN3akVqYzUyTkFwdFk1Q2NTMDJEUkttbXJqNmxRWEwrbko4YXV4WjFHcjdN?=
 =?utf-8?B?SDZVWldRcTBubXJibWNid1pENndXQXQrbjg3NlhlUGJ5R1BZQlllanFXbTYx?=
 =?utf-8?B?QTRTZnp4cmRqUXZUVmtuWUd2eHphZDk1eGp0akxIaGkza3R3Q2piaDQvVzFu?=
 =?utf-8?B?ZUE1UE1IQVg2aU9sL2VaN2RFMUEyb0VoY3RiSlZIMkduUWNYWVZzeDY3V25R?=
 =?utf-8?B?MUxxNW9nR3NhTlNqYkVuSlFzL3JmcjMrY2hoT1ZYTDBrVjJ5WFphNi85Q0s4?=
 =?utf-8?B?cFh4RjNrd0hlc280T3hyczJzMjVJMm5xQTY5Y1V1eU95cjZCdEtuOThqVC8z?=
 =?utf-8?B?b3dON3JveEpOaHFMMGptbkpYUmNBTTJoRTNvdmVKMkhhM0dBWUIrR1VqaUpI?=
 =?utf-8?B?bHBvdHV5RGNsbEFadEJxS1B3SEpBWUJVd3NhRzBXbFhQZEwyM1pFczNlRWVK?=
 =?utf-8?B?VFMzS2NkT2lrZW0rejdNNDZyNVVRNk1RYldsN3dQbVNwZDBwaWVXMWxQb3pW?=
 =?utf-8?B?ZmkxTmFmZEhFSnNkT1hjTXdVZVpOWjBBTUdkbmNobE04TkFXSE5hK1VxVlph?=
 =?utf-8?B?c09aeEttR0NkeDduOXUzOXFLZzN5bnNBZmFlakRZQ2txc01ITzc5ejRIZHpJ?=
 =?utf-8?B?MGt2ZjdLcTVBL3FsSktVZDFjWG5ITW1QLzVyS21UOFFxb1FKUmdYdEtOZDQv?=
 =?utf-8?B?YlorMzBTQ2kwN0I3bklqbTZMVUp0Uk1FR1hIcTFOSDkxNTZkZk9HbGxXcTFx?=
 =?utf-8?B?QXFZYkY2bFdwWU9uQWlIand3RVZXRFFOZzJIZzdVUmVNYk5KaDBOcFp4V1Vo?=
 =?utf-8?B?SmgrNEZhU0RWMDNYekh5K01HMjdmN1J4T0NjQUVqZG4wbS90OEVha2VFSU4x?=
 =?utf-8?B?UUNoZU16NlNWZ1NwTFZDOHhZMWlJTDFkRkVQbFpJeEpPOE5Wa2VOSmpxL2hz?=
 =?utf-8?B?VlcreDJlVm1xbXg0enZPTE9tS3VFMTNQR0t0bHhyTWdyanBGRldBRGtGc1Fp?=
 =?utf-8?B?bS8vTlJUT1RKUWRIOTlFakppTHBOUVQ5cmZjVklSV1JmYzc0YnUxYWl6Rmdn?=
 =?utf-8?Q?CHSS/QzL1vEYCZyb+U8phqy5C?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aaf7f24-2cd3-4b66-3203-08daa6cebc9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 12:40:08.3926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A8b69dpBJ++DxyZoEzbUuH0mTE7ib6T/mpllwPTYHI3mdtGL5z3En4phDCZ/xxZsMOj105AWpuUnwp71qwXdEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmVzcGVyLA0KDQpIZXJlIGlzIHRoZSBzdW1tYXJ5IG9mICJ4ZHBfcnhxX2luZm8iIHRlc3Rp
bmcuDQoNCiAgICAgICAgICAgICAgc2tiX21hcmtfZm9yX3JlY3ljbGUgICAgICAgICAgIHBhZ2Vf
cG9vbF9yZWxlYXNlX3BhZ2UNCg0KICAgICAgICAgICAgIE5hdGl2ZSAgICAgICAgU0tCLU1vZGUg
ICAgICAgICAgIE5hdGl2ZSAgICAgICAgICBTS0ItTW9kZQ0KWERQX0RST1AgICAgIDQ2MEsgICAg
ICAgICAgIDIyMEsgICAgICAgICAgICAgIDQ2MEsgICAgICAgICAgICAgMTAySw0KWERQX1BBU1Mg
ICAgIDgwSyAgICAgICAgICAgIDExM0sgICAgICAgICAgICAgIDYwSyAgICAgICAgICAgICAgNjJL
DQoNCg0KVGhlIGZvbGxvd2luZyBhcmUgdGhlIHRlc3RpbmcgbG9nLg0KDQpUaGFua3MsDQpTaGVu
d2VpDQoNCiMjIyBza2JfbWFya19mb3JfcmVjeWNsZSBzb2x1dGlvbiAjIyMNCg0KLi94ZHBfcnhx
X2luZm8gLS1kZXYgZXRoMCAtLWFjdCBYRFBfRFJPUCAtLXJlYWQNCg0KUnVubmluZyBYRFAgb24g
ZGV2OmV0aDAgKGlmaW5kZXg6MikgYWN0aW9uOlhEUF9EUk9QIG9wdGlvbnM6cmVhZA0KWERQIHN0
YXRzICAgICAgIENQVSAgICAgcHBzICAgICAgICAgaXNzdWUtcHBzDQpYRFAtUlggQ1BVICAgICAg
MCAgICAgICA0NjYsNTUzICAgICAwDQpYRFAtUlggQ1BVICAgICAgdG90YWwgICA0NjYsNTUzDQoN
Ci4veGRwX3J4cV9pbmZvIC1TIC0tZGV2IGV0aDAgLS1hY3QgWERQX0RST1AgLS1yZWFkDQoNClJ1
bm5pbmcgWERQIG9uIGRldjpldGgwIChpZmluZGV4OjIpIGFjdGlvbjpYRFBfRFJPUCBvcHRpb25z
OnJlYWQNClhEUCBzdGF0cyAgICAgICBDUFUgICAgIHBwcyAgICAgICAgIGlzc3VlLXBwcw0KWERQ
LVJYIENQVSAgICAgIDAgICAgICAgMjI2LDI3MiAgICAgMA0KWERQLVJYIENQVSAgICAgIHRvdGFs
ICAgMjI2LDI3Mg0KDQouL3hkcF9yeHFfaW5mbyAtLWRldiBldGgwIC0tYWN0IFhEUF9QQVNTIC0t
cmVhZA0KDQpSdW5uaW5nIFhEUCBvbiBkZXY6ZXRoMCAoaWZpbmRleDoyKSBhY3Rpb246WERQX1BB
U1Mgb3B0aW9uczpyZWFkDQpYRFAgc3RhdHMgICAgICAgQ1BVICAgICBwcHMgICAgICAgICBpc3N1
ZS1wcHMNClhEUC1SWCBDUFUgICAgICAwICAgICAgIDgwLDUxOCAgICAgIDANClhEUC1SWCBDUFUg
ICAgICB0b3RhbCAgIDgwLDUxOA0KDQouL3hkcF9yeHFfaW5mbyAtUyAtLWRldiBldGgwIC0tYWN0
IFhEUF9QQVNTIC0tcmVhZA0KDQpSdW5uaW5nIFhEUCBvbiBkZXY6ZXRoMCAoaWZpbmRleDoyKSBh
Y3Rpb246WERQX1BBU1Mgb3B0aW9uczpyZWFkDQpYRFAgc3RhdHMgICAgICAgQ1BVICAgICBwcHMg
ICAgICAgICBpc3N1ZS1wcHMNClhEUC1SWCBDUFUgICAgICAwICAgICAgIDExMyw2ODEgICAgIDAN
ClhEUC1SWCBDUFUgICAgICB0b3RhbCAgIDExMyw2ODENCg0KDQojIyMgcGFnZV9wb29sX3JlbGVh
c2VfcGFnZSBzb2x1dGlvbiAjIyMNCg0KLi94ZHBfcnhxX2luZm8gLS1kZXYgZXRoMCAtLWFjdCBY
RFBfRFJPUCAtLXJlYWQNCg0KUnVubmluZyBYRFAgb24gZGV2OmV0aDAgKGlmaW5kZXg6MikgYWN0
aW9uOlhEUF9EUk9QIG9wdGlvbnM6cmVhZA0KWERQIHN0YXRzICAgICAgIENQVSAgICAgcHBzICAg
ICAgICAgaXNzdWUtcHBzDQpYRFAtUlggQ1BVICAgICAgMCAgICAgICA0NjMsMTQ1ICAgICAwDQpY
RFAtUlggQ1BVICAgICAgdG90YWwgICA0NjMsMTQ1DQoNCi4veGRwX3J4cV9pbmZvIC1TIC0tZGV2
IGV0aDAgLS1hY3QgWERQX0RST1AgLS1yZWFkDQoNClJ1bm5pbmcgWERQIG9uIGRldjpldGgwIChp
ZmluZGV4OjIpIGFjdGlvbjpYRFBfRFJPUCBvcHRpb25zOnJlYWQNClhEUCBzdGF0cyAgICAgICBD
UFUgICAgIHBwcyAgICAgICAgIGlzc3VlLXBwcw0KWERQLVJYIENQVSAgICAgIDAgICAgICAgMTA0
LDQ0MyAgICAgMA0KWERQLVJYIENQVSAgICAgIHRvdGFsICAgMTA0LDQ0Mw0KDQouL3hkcF9yeHFf
aW5mbyAtLWRldiBldGgwIC0tYWN0IFhEUF9QQVNTIC0tcmVhZA0KDQpSdW5uaW5nIFhEUCBvbiBk
ZXY6ZXRoMCAoaWZpbmRleDoyKSBhY3Rpb246WERQX1BBU1Mgb3B0aW9uczpyZWFkDQpYRFAgc3Rh
dHMgICAgICAgQ1BVICAgICBwcHMgICAgICAgICBpc3N1ZS1wcHMNClhEUC1SWCBDUFUgICAgICAw
ICAgICAgIDYwLDUzOSAgICAgIDANClhEUC1SWCBDUFUgICAgICB0b3RhbCAgIDYwLDUzOQ0KDQou
L3hkcF9yeHFfaW5mbyAtUyAtLWRldiBldGgwIC0tYWN0IFhEUF9QQVNTIC0tcmVhZA0KDQpSdW5u
aW5nIFhEUCBvbiBkZXY6ZXRoMCAoaWZpbmRleDoyKSBhY3Rpb246WERQX1BBU1Mgb3B0aW9uczpy
ZWFkDQpYRFAgc3RhdHMgICAgICAgQ1BVICAgICBwcHMgICAgICAgICBpc3N1ZS1wcHMNClhEUC1S
WCBDUFUgICAgICAwICAgICAgIDYyLDU2NiAgICAgIDANClhEUC1SWCBDUFUgICAgICB0b3RhbCAg
IDYyLDU2Ng0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNoZW53ZWkg
V2FuZw0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDQsIDIwMjIgODozNCBBTQ0KPiBUbzogSmVz
cGVyIERhbmdhYXJkIEJyb3VlciA8amJyb3VlckByZWRoYXQuY29tPjsgQW5kcmV3IEx1bm4NCj4g
PGFuZHJld0BsdW5uLmNoPg0KPiBDYzogYnJvdWVyQHJlZGhhdC5jb207IERhdmlkIFMuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldA0KPiA8ZWR1bWF6ZXRAZ29vZ2xl
LmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaQ0KPiA8
cGFiZW5pQHJlZGhhdC5jb20+OyBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPjsg
RGFuaWVsIEJvcmttYW5uDQo+IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD47IEplc3BlciBEYW5nYWFy
ZCBCcm91ZXIgPGhhd2tAa2VybmVsLm9yZz47IEpvaG4NCj4gRmFzdGFiZW5kIDxqb2huLmZhc3Rh
YmVuZEBnbWFpbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVs
QHZnZXIua2VybmVsLm9yZzsgaW14QGxpc3RzLmxpbnV4LmRldjsgTWFnbnVzIEthcmxzc29uDQo+
IDxtYWdudXMua2FybHNzb25AZ21haWwuY29tPjsgQmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVs
Lm9yZz47IElsaWFzDQo+IEFwYWxvZGltYXMgPGlsaWFzLmFwYWxvZGltYXNAbGluYXJvLm9yZz4N
Cj4gU3ViamVjdDogUkU6IFtFWFRdIFJlOiBbUEFUQ0ggMS8xXSBuZXQ6IGZlYzogYWRkIGluaXRp
YWwgWERQIHN1cHBvcnQNCj4gDQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+IEZyb206IFNoZW53ZWkgV2FuZw0KPiA+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgNCwg
MjAyMiA4OjEzIEFNDQo+ID4gVG86IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGpicm91ZXJAcmVk
aGF0LmNvbT47IEFuZHJldyBMdW5uDQo+IC4uLg0KPiA+IEkgaGF2ZW4ndCB0ZXN0ZWQgeGRwX3J4
cV9pbmZvIHlldCwgYW5kIHdpbGwgaGF2ZSBhIHRyeSBzb21ldGltZSBsYXRlciB0b2RheS4NCj4g
PiBIb3dldmVyLCBmb3IgdGhlIFhEUF9EUk9QIHRlc3QsIEkgZGlkIHRyeSB4ZHAyIHRlc3QgY2Fz
ZSwgYW5kIHRoZQ0KPiA+IHRlc3RpbmcgcmVzdWx0IGxvb2tzIHJlYXNvbmFibGUuIFRoZSBwZXJm
b3JtYW5jZSBvZiBOYXRpdmUgbW9kZSBpcw0KPiA+IG11Y2ggaGlnaGVyIHRoYW4gc2tiLSBtb2Rl
Lg0KPiA+DQo+ID4gIyB4ZHAyIGV0aDANCj4gPiAgcHJvdG8gMDogICAgIDQ3NTM2MiBwa3Qvcw0K
PiA+DQo+ID4gIyB4ZHAyIC1TIGV0aDAgICAgICAgICAgICAgKHBhZ2VfcG9vbF9yZWxlYXNlX3Bh
Z2Ugc29sdXRpb24pDQo+ID4gIHByb3RvIDE3OiAgICAgNzE5OTkgcGt0L3MNCj4gPg0KPiA+ICMg
eGRwMiAtUyBldGgwICAgICAgICAgICAgIChza2JfbWFya19mb3JfcmVjeWNsZSBzb2x1dGlvbikN
Cj4gPiAgcHJvdG8gMTc6ICAgICA3MjIyOCBwa3Qvcw0KPiA+DQo+IA0KPiBDb3JyZWN0aW9uIGZv
ciB4ZHAyIC1TIGV0aDAJKHNrYl9tYXJrX2Zvcl9yZWN5Y2xlIHNvbHV0aW9uKQ0KPiBwcm90byAw
OiAgICAgICAgICAwIHBrdC9zDQo+IHByb3RvIDE3OiAgICAgMTIyNDczIHBrdC9zDQo+IA0KPiBU
aGFua3MsDQo+IFNoZW53ZWkNCg0K
