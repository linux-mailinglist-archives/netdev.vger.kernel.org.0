Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6EE6C79C9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjCXI3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCXI3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:29:43 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2119.outbound.protection.outlook.com [40.107.15.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38B413D5D;
        Fri, 24 Mar 2023 01:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFxD0YJjUGDfGTsTAoTaTTCtgDiej+1zVFq/Jm1rtWTCCRLXTiP0cSwqJrKzXmCW5Fpxe1tu+uC2mrixnVEe0Jb5AuTe8PRUC05HXLbYjhnvXXrdV9rCBf4wT2qRyRxHEFKUj7Fqys0zi72vbi4wr3WiaU0m9G92JBMV/Yfcp3lrMXg9nH8flPp3Qhpn6pkMHquPIFXDcIeIxj4cIx2TRaZK9IwtlkMA0d7ytUMaG8FA55+TKSyZqvMjFpXjyOp0z579F/5lhhyVKC7M+CHb2mrua2myy/qlcwX12dFmNPQ9/ASo53rwe+1oTbmw+CqDGmEr3cuXI9gE26IyBe6VQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQIH7sOkjdv9mv0odQ7OVpdraBMa9gtdgsGFW3GTAFg=;
 b=bbVAaAmkF53ntYWAif1NVNHFikrAA3/kRZdpqPqbPwCD8bcJsa7OpoWktzt/hDx3F2X/wFW+/Hn1qze+o8+RyxJBYGXX73amEsVCOC0/OOeKhn6odnxplVSh3rHbpA+KvQUk8mNBXbRqByPb98lFrGiVBx+L3bCrkJYH3HGmGZ7QJP2oW9G0efDCwakN71Lt5CtH/DB1Mp03pywQ4aDtRyVtSqTLbbmLl0BiLqN7RvMY8ZJHB/3JQo/XfZMMtw4yUkWYcLR3lc5IxoADYa99LsODI8gJm8NoHcvKIGg39k/Wi2dLM4/tWORo+D+y+/K//UHv8V2pveEf8bvThGRtyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQIH7sOkjdv9mv0odQ7OVpdraBMa9gtdgsGFW3GTAFg=;
 b=oKhL91wMaKzh7Z6bxWjZCm0I4ihWhRjiB5dk7FHVmrD3GR9ZzHHaboxqqMGi+z/ENibYhx8yQ3nxcoSUNozpsh3t0t74WuqkA9mj9T9fERm/jL/MvZa3ydglS5zU9Ul5C3Uqbl9rB74wwIBJ5sGumTbvJvSvfhapkl5cGEZpXys=
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com (2603:10a6:208:15a::12)
 by AS2PR02MB9341.eurprd02.prod.outlook.com (2603:10a6:20b:57b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 08:29:37 +0000
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e]) by AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e%5]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 08:29:37 +0000
From:   Paul Geurts <paul.geurts@prodrive-technologies.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Topic: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Index: AQHZXYGKZkP5DojDLUOZ1w48EuKvyK8IkhcAgAA4scCAAA+tgIAAE+gAgACrYAA=
Date:   Fri, 24 Mar 2023 08:29:37 +0000
Message-ID: <AM0PR02MB5524E0D52BCBE7F1123FB7FCBD849@AM0PR02MB5524.eurprd02.prod.outlook.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
 <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
 <c54fe984-371a-da06-6dcf-da239a26bd5f@gmail.com>
 <CAKR-sGe3dwv846fE1-JMgGsB01Ybs6LWYTrZs5hP1xc+o+dc7A@mail.gmail.com>
In-Reply-To: <CAKR-sGe3dwv846fE1-JMgGsB01Ybs6LWYTrZs5hP1xc+o+dc7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR02MB5524:EE_|AS2PR02MB9341:EE_
x-ms-office365-filtering-correlation-id: 304b67f4-3506-446a-2163-08db2c41e7cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzwg9TpdfYKwNLlf4aJ3lLW7x9ay+PO3Hy0TSzcbY5dlU3fsRzVS4EC50POQFOh2J6xvJm8ZLOCNqywzAyFVZPe5VwBJSxTKhhC2yDS+Z6byG/26giXtxTYTnb0XfdRaPdtUgBeayItbZgNVqTNABEQyVJGXWKU6NrFjCaq3DKxxpNdZNGI1C5B7Zdu3GwvJ84Z3NVPscGt0a17qyL8pfRp6Jt06VooJKi2F5hKVsFnT+QtfKU8bbqGXNRpP4q6hSpzkorhR6GBWdyQ9p99MufdlzYmC4JrCmnjA7SqPOkwQX/EBe3uLzWCshUE77eZXBz9D+hCGYkt/vEYEEFlQcAkVj0sBQ8ltw/cQeVUGKcIFxJguLMx5hNiZ810eisyuhFCpTb+UNoGXo4w4hjBsUjtQoX9rfu5d2JPFoH4bHSSzx3TvOe4Z2r2eMnZ9hyXQT3LOyDhUIogofemCsDl4DOAbdJfGBQKeZOWS/MB6kI9aMIysxiuO4buMxBtrCCA/0DMn7rERGFZXswaxrx8vm5IX/TX/XE8X7XMO3fHEsUbAPaTzma+gUeTxv6zFAwlIxwjF8C3J/3e/imVNYttFA8OkJngKzQ6bAjyR8HNwq6azB74+aiUfnXB1K2Lc7nt3ZqqD+Ox55uHhk3+wEdmPLid04FIC0cG38JiBsUlSbwNR8wja1wPREh40nJqLZJEPfgyZ7hI07v9k8ONzobOM+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5524.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39850400004)(396003)(346002)(136003)(451199018)(33656002)(8936002)(52536014)(64756008)(4326008)(66446008)(8676002)(76116006)(66556008)(122000001)(66946007)(66476007)(71200400001)(7696005)(478600001)(316002)(110136005)(54906003)(41300700001)(5660300002)(7416002)(2906002)(44832011)(66574015)(38070700005)(83380400001)(86362001)(55016003)(38100700002)(53546011)(186003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VER4QTdFVWhiSE9lalBmQlYxNlg0QURmZFN6MHhhSm55QlFLRk54RFVNalpC?=
 =?utf-8?B?Y3FJazl1V01ZdUJoYTVndVN5TTZ0QWV4bnprK2RtWkRYWkFjbVZZeFFPZnoz?=
 =?utf-8?B?eUtVaXVBYWMxdDdkV3BTTFhXLzRLeXk5L2JaNjg3VGN5Nnp5Qm56Vlk4MFhE?=
 =?utf-8?B?clRETk01S2JpczFwNGhTT0FXUHJqQVkzN1QrRkM0aDRqOGFnaFBMSENOTTkw?=
 =?utf-8?B?cW9iajRpczcyZWgybGtxM0VsWEFjN1BpQTk1MUZCMVdncmNrZkxSTFVmT0l0?=
 =?utf-8?B?NzF4SCtpYmFYK3N0OW8rTWU3STNrcjJkc3o1RHVpbTMzVTRudlpLQVMvTjFu?=
 =?utf-8?B?aTFYMUFGaHZka3hqMFFDZW5wY2dwME9TUmtLRWZpNEhMUmNuczVqc0ZNTWdw?=
 =?utf-8?B?Q0hvRTVBVHhHUlJCdGV4clNGdHcySFdPZTI3U2VRMXl2L1JYTVd1eEYrbG50?=
 =?utf-8?B?UTJSWmNKWGdHd1hCYUkzcGRvZktVcHZSZlZHMzg2bUg2UmtWZ1JPMlNZZklt?=
 =?utf-8?B?dXBZbU1VV2lXcFVRNm10Z2V1NEZiU3FXeWxDQTdqKzNiMDh2aS9CWlRWU1hD?=
 =?utf-8?B?U3VJWnUrT2RhYW1JaDkzczU0ZGJqLzZMZXVENmRlVnhUaVBkc0h4T1cyS0g3?=
 =?utf-8?B?czhRNGdlNlk3ZEMyTSs5VXhOc3gyZXg0T3RDcHpibFJ1c1JsQ2dnK2ZDOUZ6?=
 =?utf-8?B?QXk3OFNRSHBnSWtQUzFMSWFqNUFpTlNkRjcrYUFMcWhPUGlDcXcyVXBOZWd0?=
 =?utf-8?B?NjlReGtBdXpFSzNTZ2o3ZnRiYjc5a2tPY2xSSi9DeFNOaFJVc0pOVjcwM3N6?=
 =?utf-8?B?RTVRMXc3aHRhY1ovK0dXQXVVaFJGT1paYVJtbHFCK00xUjc5Zzd2ZXZRaWtq?=
 =?utf-8?B?cysyUzQzZ2tMR1pTOVZxaFlzckl0OWhVNmI1N3VlcG5rV0RybGYrSkwxdXBi?=
 =?utf-8?B?VXJTd1dMZ2lNbEZwdm1YTGcxd05KWjZiWDBBUjFvOUUrTnhBVjVFQzFkdmh6?=
 =?utf-8?B?MGZiZjZrRThyWVpJYjJaTDh6djRkZnF6YjQ1NHloODFnVzFlRjdPVlU3QjNs?=
 =?utf-8?B?dkc5bnV4SkxBMzZBMXYrSjYzNFZ6Y0JjNWVaY0ZhelFVYVNYVkNaeWFacldY?=
 =?utf-8?B?WU11djF1ZGRkNXYrdkEwek1uM3htemxaS0w3c3ZlVkpPTEVnMDZRazB5UHFp?=
 =?utf-8?B?cUxCanc5MU1uMURiTlFXMzVJY3NMLzVBZG5FQVpSL3RQSHhZaWJMaWFBZk95?=
 =?utf-8?B?c3NNWjIxaFFiem9FZlR4WFA4UEp2NGY1d2VjVkNOaUxzUU1xNkMvNVNzS05V?=
 =?utf-8?B?bVVJYjU4OXlsMW43UUVSZHFiQmlMVzE0VUVHU1IwbVQ5UWM1VjNnbFlEQ1Nj?=
 =?utf-8?B?T1VNRlYzNFBKZmoyeHBOZzVBOC9KU09VNzlob1ZTZTVHYkp5clJDNjdZOU56?=
 =?utf-8?B?VFMrZFE5cVJnSVh6dll5Vi9rZXVNUlM0Zmw1Q0R6T1dRMnE1OUxYQy9RRU9n?=
 =?utf-8?B?Q1I3eWVZTXZMZGlmQndQNy9NV1Z4MENJWlcxWlpkMkNhcGt3SmVzMXZSUjF3?=
 =?utf-8?B?TUpPQ1lQMlRDTkNTN2J3TEhCTUMrTitwbit4enBRVU1ubG9BZXg5OCtGRjhv?=
 =?utf-8?B?TjFXekxsbGdDM3Q3dDhxczByb3RSSDFrMGxpMnVMVVV3b2tQOEZKczY4VFBT?=
 =?utf-8?B?YzZZb3NnY0F6K1hxb2ZUVm5aa0YrRVVxRUsreDlEZ2RDUEpUdjdYMURvV2lj?=
 =?utf-8?B?SGtnRWFIR3gxWmtvUDd1ZHJXdDczMk8vTVpUYWpzc3g2NFVGUGJsT3FUWHEv?=
 =?utf-8?B?TTNieU1VOHYxSDdQNHdkS3hrUmNGU2JHV0VwTjVIRnF5S1BWZGhlU2lWeFZi?=
 =?utf-8?B?WW5mOHc5ZlpHVCs3Z1ZaZnVSQzFzOVpOTXo5alRWbWFEZW5zc3p3a2RLb1VF?=
 =?utf-8?B?R2hrTzhlbDhpTFhBZmxOVk5GZXV6ZzNuWldVZzFNTm1iaGdTVUVSN2hubjNK?=
 =?utf-8?B?Z1R0MEhuM3NUc0hoRXRSVXRheUU0NGdiMmlQcmpIMUJZNHNZakhDSVhrQ3lY?=
 =?utf-8?B?UjdKekRzUVVsOUN3Y0wzK1ZXdHV0c3djd3NJbFZGbUJwSUluYWdyLzRadktp?=
 =?utf-8?B?bDJqaExBZm43VWlGQUpoNHMvMmtrQW5vYk8rMzk5SE1XT0sxbXJYcXdpQlhj?=
 =?utf-8?Q?aZSuJFFjBR72xALfSSidvZg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 304b67f4-3506-446a-2163-08db2c41e7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 08:29:37.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HSYrUhTUXJflKNqF7VzkVaVRxGwQLEZg/mpyzbj3toWbtf1EZIqxV3I1RO+GXqKwSsR2v68370MDMjZJJTV46oK2h9xt31wB/erd8RSrDt13CkzmXGFn20UlDQSTr/0U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR02MB9341
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiDDgWx2YXJvIEZlcm7DoW5kZXog
Um9qYXMgPG5vbHRhcmlAZ21haWwuY29tPg0KPiBTZW50OiBkb25kZXJkYWcgMjMgbWFhcnQgMjAy
MyAyMzoxMw0KPiBUbzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+
IENjOiBQYXVsIEdldXJ0cyA8cGF1bC5nZXVydHNAcHJvZHJpdmUtdGVjaG5vbG9naWVzLmNvbT47
DQo+IGpvbmFzLmdvcnNraUBnbWFpbC5jb207IGFuZHJld0BsdW5uLmNoOyBvbHRlYW52QGdtYWls
LmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBr
ZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBr
cnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBuZXQ6IGRzYTogYjUzOiBtZGlvOiBhZGQg
c3VwcG9ydCBmb3IgQkNNNTMxMzQNCj4gDQo+IEVsIGp1ZSwgMjMgbWFyIDIwMjMgYSBsYXMgMjI6
MDIsIEZsb3JpYW4gRmFpbmVsbGkNCj4gKDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4pIGVzY3JpYmnD
szoNCj4gPg0KPiA+IE9uIDMvMjMvMjMgMTM6MTAsIFBhdWwgR2V1cnRzIHdyb3RlOg0KPiA+ID4+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPj4gRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+ID4gPj4gU2VudDogZG9uZGVyZGFnIDIzIG1hYXJ0
IDIwMjMgMTc6NDMNCj4gPiA+PiBUbzogw4FsdmFybyBGZXJuw6FuZGV6IFJvamFzIDxub2x0YXJp
QGdtYWlsLmNvbT47IFBhdWwgR2V1cnRzDQo+ID4gPj4gPHBhdWwuZ2V1cnRzQHByb2RyaXZlLXRl
Y2hub2xvZ2llcy5jb20+OyBqb25hcy5nb3Jza2lAZ21haWwuY29tOw0KPiA+ID4+IGFuZHJld0Bs
dW5uLmNoOyBvbHRlYW52QGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+PiBl
ZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0K
PiA+ID4+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8u
b3JnOw0KPiA+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC0NCj4gPiA+PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gPj4gU3Vi
amVjdDogUmU6IFtQQVRDSCAyLzJdIG5ldDogZHNhOiBiNTM6IG1kaW86IGFkZCBzdXBwb3J0IGZv
cg0KPiA+ID4+IEJDTTUzMTM0DQo+ID4gPj4NCj4gPiA+PiBPbiAzLzIzLzIzIDA1OjE4LCDDgWx2
YXJvIEZlcm7DoW5kZXogUm9qYXMgd3JvdGU6DQo+ID4gPj4+IEZyb206IFBhdWwgR2V1cnRzIDxw
YXVsLmdldXJ0c0Bwcm9kcml2ZS10ZWNobm9sb2dpZXMuY29tPg0KPiA+ID4+Pg0KPiA+ID4+PiBB
ZGQgc3VwcG9ydCBmb3IgdGhlIEJDTTUzMTM0IEV0aGVybmV0IHN3aXRjaCBpbiB0aGUgZXhpc3Rp
bmcgYjUzDQo+ID4gPj4+IGRzYQ0KPiA+ID4+IGRyaXZlci4NCj4gPiA+Pj4gQkNNNTMxMzQgaXMg
dmVyeSBzaW1pbGFyIHRvIHRoZSBCQ001OFhYIHNlcmllcy4NCj4gPiA+Pj4NCj4gPiA+Pj4gU2ln
bmVkLW9mZi1ieTogUGF1bCBHZXVydHMgPHBhdWwuZ2V1cnRzQHByb2RyaXZlLXRlY2hub2xvZ2ll
cy5jb20+DQo+ID4gPj4+IFNpZ25lZC1vZmYtYnk6IMOBbHZhcm8gRmVybsOhbmRleiBSb2phcyA8
bm9sdGFyaUBnbWFpbC5jb20+DQo+ID4gPj4+IC0tLQ0KPiA+ID4+PiAgICBkcml2ZXJzL25ldC9k
c2EvYjUzL2I1M19jb21tb24uYyB8IDUzDQo+ID4gPj4gKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0NCj4gPiA+Pj4gICAgZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfbWRpby5jICAgfCAg
NSArKy0NCj4gPiA+Pj4gICAgZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfcHJpdi5oICAgfCAgOSAr
KysrKy0NCj4gPiA+Pj4gICAgMyBmaWxlcyBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQ0KPiA+ID4+Pg0KPiA+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNh
L2I1My9iNTNfY29tbW9uLmMNCj4gPiA+Pj4gYi9kcml2ZXJzL25ldC9kc2EvYjUzL2I1M19jb21t
b24uYw0KPiA+ID4+PiBpbmRleCAxZjliMjUxYTU0NTIuLmFhYTA4MTNlNmY1OSAxMDA2NDQNCj4g
PiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMNCj4gPiA+Pj4gKysr
IGIvZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMNCj4gPiA+Pj4gQEAgLTEyODIsNiAr
MTI4Miw0MiBAQCBzdGF0aWMgdm9pZCBiNTNfYWRqdXN0X2xpbmsoc3RydWN0DQo+ID4gPj4+IGRz
YV9zd2l0Y2gNCj4gPiA+PiAqZHMsIGludCBwb3J0LA0KPiA+ID4+PiAgICAgaWYgKGlzNjN4eChk
ZXYpICYmIHBvcnQgPj0gQjUzXzYzWFhfUkdNSUkwKQ0KPiA+ID4+PiAgICAgICAgICAgICBiNTNf
YWRqdXN0XzYzeHhfcmdtaWkoZHMsIHBvcnQsIHBoeWRldi0+aW50ZXJmYWNlKTsNCj4gPiA+Pj4N
Cj4gPiA+Pj4gKyAgIGlmIChpczUzMTM0KGRldikgJiYgcGh5X2ludGVyZmFjZV9pc19yZ21paShw
aHlkZXYpKSB7DQo+ID4gPj4NCj4gPiA+PiBXaHkgaXMgbm90IHRoaXMgaW4gdGhlIHNhbWUgY29k
ZSBibG9jayBhcyB0aGUgb25lIGZvciB0aGUgaXM1MzF4NSgpDQo+ID4gPj4gZGV2aWNlIGxpa2UN
Cj4gPiA+PiB0aGlzOg0KPiA+ID4+DQo+ID4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9iNTMvYjUzX2NvbW1vbi5jDQo+ID4gPj4gYi9kcml2ZXJzL25ldC9kc2EvYjUzL2I1M19jb21t
b24uYw0KPiA+ID4+IGluZGV4IDU5Y2RmYzUxY2UwNi4uMWM2NGI2Y2U3ZTc4IDEwMDY0NA0KPiA+
ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jDQo+ID4gPj4gKysrIGIv
ZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMNCj4gPiA+PiBAQCAtMTIzNSw3ICsxMjM1
LDcgQEAgc3RhdGljIHZvaWQgYjUzX2FkanVzdF9saW5rKHN0cnVjdCBkc2Ffc3dpdGNoDQo+ID4g
Pj4gKmRzLCBpbnQgcG9ydCwNCj4gPiA+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHR4X3BhdXNlLCByeF9wYXVzZSk7DQo+ID4gPj4gICAgICAgICAgIGI1M19mb3JjZV9saW5rKGRl
diwgcG9ydCwgcGh5ZGV2LT5saW5rKTsNCj4gPiA+Pg0KPiA+ID4+IC0gICAgICAgaWYgKGlzNTMx
eDUoZGV2KSAmJiBwaHlfaW50ZXJmYWNlX2lzX3JnbWlpKHBoeWRldikpIHsNCj4gPiA+PiArICAg
ICAgIGlmICgoaXM1MzF4NShkZXYpIHx8IGlzNTMxMzQoZGV2KSkgJiYNCj4gPiA+PiBwaHlfaW50
ZXJmYWNlX2lzX3JnbWlpKHBoeWRldikpIHsNCj4gPiA+PiAgICAgICAgICAgICAgICAgICBpZiAo
cG9ydCA9PSBkZXYtPmltcF9wb3J0KQ0KPiA+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
b2ZmID0gQjUzX1JHTUlJX0NUUkxfSU1QOw0KPiA+ID4+ICAgICAgICAgICAgICAgICAgIGVsc2UN
Cj4gPiA+Pg0KPiA+ID4+IE90aGVyIHRoYW4gdGhhdCwgTEdUTSENCj4gPiA+PiAtLQ0KPiA+ID4+
IEZsb3JpYW4NCj4gPiA+DQo+ID4gPiBJIHRoaW5rIHRoZSBvbmx5IHJlYXNvbiBpcyB0aGF0IHRo
ZSBCQ001MzEzNCBkb2VzIG5vdCBzdXBwb3J0IHRoZQ0KPiA+ID4gUkdNSUlfQ1RSTF9USU1JTkdf
U0VMIGJpdCwgd2hpY2ggaXMgc2V0IGluIHRoZSBvcmlnaW5hbCBibG9jay4gSQ0KPiA+ID4gYWdy
ZWUgUHV0dGluZyBhIGlmIHN0YXRlbWVudCBhcm91bmQgcmdtaWlfY3RybCB8PQ0KPiA+ID4gUkdN
SUlfQ1RSTF9USU1JTkdfU0VMOyB3b3VsZCBwcmV2ZW50IGEgbG90IG9mIGNvZGUgZHVwbGljYXRp
b24uDQo+ID4gPiBfaG93ZXZlcl8sIGFmdGVyIGxvb2tpbmcgYXQgaXQgYWdhaW4sIEkgZG9u4oCZ
dCB0aGluayB0aGUgZGV2aWNlIGRvZXMNCj4gPiA+IG5vdCBzdXBwb3J0IHRoZSBiaXQuIFdoZW4g
bG9va2luZyBhdCB0aGUgZGF0YXNoZWV0LCBUaGUgc2FtZSBiaXQgaW4NCj4gPiA+IHRoZSB0aGlz
IHJlZ2lzdGVyIGlzIGNhbGxlZCBCWVBBU1NfMk5TX0RFTC4gSXQncyB2ZXJ5IHVuY29tbW9uIEZv
cg0KPiA+ID4gQnJvYWRjb20gdG8gbWFrZSBzdWNoIGEgY2hhbmdlIGluIHRoZSByZWdpc3RlciBp
bnRlcmZhY2UsIHNvIG1heWJlDQo+ID4gPiB0aGV5IEp1c3QgcmVuYW1lZCBpdC4gRG8geW91IHRo
aW5rIHRoaXMgY291bGQgYmUgdGhlIHNhbWUgYml0Pw0KPiA+DQo+ID4gWWVzLCBJIHRoaW5rIHRo
aXMgaXMgZXhhY3RseSB0aGUgc2FtZSBiaXQsIGp1c3QgbmFtZWQgZGlmZmVyZW50bHkuDQo+ID4g
V2hhdCBzdHJpa2VzIG1lIGFzIG9kZCBpcyB0aGF0IG5laXRoZXIgb2YgdGhlIDUzMTE1LCA1MzEy
NSBvciA1MzEyOA0KPiA+IHdoaWNoIGFyZSBndWFyZGVkIGJ5IHRoZSBpczUzMXg1KCkgY29uZGl0
aW9uYWwgaGF2ZSBpdCBkZWZpbmVkLg0KPiANCj4gSWYgdGhpcyBpcyB0cnVlIHRoZW4gd2UgY2Fu
IHNhZmVseSBhZGQgNTMxMzQgdG8gaXM1MzF4NSgpIGNvbmRpdGlvbmFsIGFuZCByZXVzZQ0KPiB0
aGUgZXhpc3RpbmcgY29kZS4NCj4gDQo+ID4gLS0NCj4gPiBGbG9yaWFuDQo+ID4NCj4gDQo+IC0t
DQo+IMOBbHZhcm8NCg0KV2l0aCB0aGUgYml0IHNldCBvbiBteSBkZXZpY2UsIGV2ZXJ5dGhpbmcg
a2VlcHMgd29ya2luZyBqdXN0IGZpbmUuIEkgaW5kZWVkIHRoaW5rDQpUaGlzIGlzIGp1c3QgdGhl
IHNhbWUgYml0LiBJIGhhdmUgcmVxdWVzdGVkIHNvbWUgY2xhcml0eSBmcm9tIG91ciBGQUUgYXQN
CkJyb2FkY29tLiBXZSBjb3VsZCB3YWl0IGZvciB0aGVpciBhbnN3ZXIgKHdoaWNoIGNvdWxkIHRh
a2UgYSB3aGlsZSksIG9yIGp1c3QNCmFzc3VtZSBzZXR0aW5nIHRoaXMgYml0IGlzIGZpbmUgYW4g
cHVzaCB0aGUgcGF0Y2hlcy4gSSdsbCBsZWF2ZSB0aGF0IHVwIHRvIHlvdS4NCg0KLS0tDQpQYXVs
DQo=
