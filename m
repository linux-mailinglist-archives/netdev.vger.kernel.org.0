Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C146F4D2B77
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiCIJKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiCIJKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:10:14 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2138.outbound.protection.outlook.com [40.107.22.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2514F9B6;
        Wed,  9 Mar 2022 01:09:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI6Qt7c43QKP8OBBEzzhZ/k6WuYPyiOmvLsSdBSBoR1pR7uxVNcCRLol0T0SJg4DJW5vFbPUmZPIoHYsl6SFllI5l/Zevj9ZoycXo43ML1iH+S81KKo3E47coElgZt8omvVco1GWXXauKKtoSNDBYdLFOH4vUIcCrd3ESEGZTgaGx6216As8uDVV4l7s87aaSMKg4uBHl9OWM6NRn1f5LlFrC0EPzXivZBGOYpWMguXjaLPNuuMxjvUtVz+h4ffmxY7WfjdDFbe2RSFtp99I6WXVGezjEDQqBtaZKLgxhHfUt3M1EVf0fuk33VxDU+69gi77qkTjcE/iy8yRMxOvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61/vt371PnuljbO2PurvE1Gu0mL45PQUFKNoaXoD74o=;
 b=V92OkoEj71PHX6iw+hknXoRi0HkGDsQ7iQE8yfSprTqXBlsUhWOOYED2SXlRoxV1LajqBOloLBsdeM1Vi7CY+tXGArf5P5RJSztsxLlnF5KiB4rcNQL965sgcSXq7yRInWavDBAY7DfEZ6agXsxhRC1j+MR6THHK1IrAczphrs4ahr5g88eRoLJaG6DZc0T0NqruNRB0T1AED83rX89rX4WRbJaKNKPC5fFZb4ha2+dCV3eoTP1qpDyS9T2b6T0ZMK8mPcDS6sZ8Lrt3NhAnMUwuYh8HtK/XZEZHTYo72WWhRJRU1Zs2k8LfYhY1AxEM/PMXzjG8GF+D4bSKyZESXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61/vt371PnuljbO2PurvE1Gu0mL45PQUFKNoaXoD74o=;
 b=PicJvfz5PeekgheOxAUeeuSs/4/VDCVHnUcesrShlAirPXW43vNIjD6ZZncshpSu0R99hcu7cT3hvlu0oBk1r5F/tewMJqQ2r+8W3/QyWC9pX6Pr8MXBWkp6vCVrT5RkvxKTvTbu552PhlEI8DZHFV4xtyCGMMla/CuYEXOoFfE=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5783.eurprd03.prod.outlook.com (2603:10a6:20b:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.18; Wed, 9 Mar
 2022 09:09:12 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 09:09:12 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA
 ROUTER CHIPS
Thread-Topic: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA
 ROUTER CHIPS
Thread-Index: AQHYMtePq4apdtZHJUi3TbaEb+Vb7Q==
Date:   Wed, 9 Mar 2022 09:09:12 +0000
Message-ID: <87v8wnbih4.fsf@bang-olufsen.dk>
References: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220308103027.32191-1-lukas.bulwahn@gmail.com> (Lukas Bulwahn's
        message of "Tue, 8 Mar 2022 11:30:27 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e971d245-9425-4064-cebf-08da01ac7a61
x-ms-traffictypediagnostic: AM6PR03MB5783:EE_
x-microsoft-antispam-prvs: <AM6PR03MB5783EE627EF75E09BFF84623830A9@AM6PR03MB5783.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TRirw97aTMI0yz7QLotr9BQI3dY3WFwUohNXSSTjzMeraz0tngMR2WqUgz+r9UOF8rGCojXQdG+WAaBz5sqRfE56dp0MEL7yr3VO3ucf462Q3qHJJ2DXuB8E7qsO5b+a2dL1uRCkkmuYfEQLAWlLx0ep0m7rNAZX/EOkCwHZcG2OZ1ti2JguKDuj+U+QRXsIgsPqzPg6KNl3pgcb7DExirCkUfnu2HUD7DgweG5OYv2J61oTXJs44DIPaE1zDrVHJzWZJUD6Xnf7V+VUNGuLbc3FWy9tlrMGf0gFtwsFVVuxjapT6Ecw4AG68jCncfmZ/JTSOdXi6XZwGAY0R4lMqMoOS8BXsv3o9fSV2nlRiFEPWHsjlWWC9eQPByB2Ry2vXde07HdKWrzCIXbBXzPTdswcZ8kpw4a2n9JupJeRuH/mDZ+hI7jCRdUKDStpPrKceJYgJiPOlH0j3aEMnMAouCYTruM/255daMSNbLWlhKJ+tuoDGoGZkIMXCQUQ7v9YLe6OGRDW48V50RsYp9Tg4n4xdKTbFpJVEK7u3LCJ1zrPtSr7EIxdn/wf/ScGdhC381X4GPUwCNXunyDXyNfvTZZFNKaS5yRKJYAC9S456/wyJiWZzwfiX6BsUcmhiwT8cIrLa7NMyBrl+MChxE3CiDniH5hBwYCAeljnQPvOHqHPSGK8S4bdJtNNGFC1uyuaxH+zQkELE9NEBJwgcER/Pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4744005)(6512007)(6506007)(8936002)(8976002)(6486002)(7416002)(508600001)(2906002)(71200400001)(85182001)(8676002)(4326008)(83380400001)(36756003)(6916009)(91956017)(26005)(316002)(2616005)(186003)(38100700002)(66476007)(66446008)(64756008)(66556008)(122000001)(66946007)(76116006)(66574015)(38070700005)(85202003)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkRvZWVKNkFwTFROVy9JSUhlWTVuMEpyekpVdkQ1TnZYZFlxNDYrT2RjSmlL?=
 =?utf-8?B?Nng1dTBNRHcvNlJwbHZBUjJmdWEzbFcySjlrU29ad0pmT3N2UzdYWjhCWEdo?=
 =?utf-8?B?ejQ4Z29yb2c0djBrczFYUllROG5RaXJraGcrUkJUVGljbmEwYm5URlB2ZXow?=
 =?utf-8?B?ZFg1T2d6VXN3N083U2xBaVBiemtPN001SkhadnZMTFl0NUtXN1hPVHdsWm9B?=
 =?utf-8?B?aVlpckZ0aWEwODF6czdlRmpXT0tKVXEzWXExU1FFU2x4eldKMUFLelFCOC9Z?=
 =?utf-8?B?L0tiU01GTGM1RDBEalZtMGk0cEtMdVBuVlFZWWNvOXZrUGlyNVpDTVg1dUlY?=
 =?utf-8?B?c0taQW9hWlVka2djdjl0YW95YlJsT3JKb2dvUkZNb1VQeXRnd3NSRk5NQTVi?=
 =?utf-8?B?VWF6WEloUG9aWTludlVKSUJwN0NKWkowcXlQbm1Rb25UN1NKakc3ZmR6UzFB?=
 =?utf-8?B?bVRqSmVNN0NKNXQvM0QxK1dGcWgrM3dFcnExR3NjaVpoelhic1pESFhDTWdw?=
 =?utf-8?B?aGJrRlEzNzRHNS84TTk5dlJzMGtlSGRHU3RmRUo4K1dFbGxFcmk1TzUrNUt5?=
 =?utf-8?B?Zy9SR2x4MytuVFVtM2lGRmZMSkRXUy9WNEZVa1BjYVUzR2VjNXEwYWdrUlZa?=
 =?utf-8?B?QVE3RXZDbit0czVYWFZaa3FGK2V4NXRmczk2ZTJxd293OXdpSmFBV082dURF?=
 =?utf-8?B?QWFldjdHcWZ1TnErTkQ3RzBmUjl6RzNCU2dWNTZtNTgzTFlmYW82M3hOSVBk?=
 =?utf-8?B?Ykg5Q2hJT0JiZEU4TWN5Wnl3TnJhbysrdjlhYmx2OXdMNndpQ08rckJDRzJi?=
 =?utf-8?B?VkJaN1ZINnhtQzhaQ0FLMmdXT3NydStVU3AzbWdNT1dLU1lRT1IzV3ZHME0w?=
 =?utf-8?B?ZTZ5SFlJaTJnZm5IR3FJOEFNSkFYYmI1bTFUK081NkJZZWU1YXpORjJGQnFk?=
 =?utf-8?B?RlA3bnlxaCtvR2VuTUtWM1dpbVpMWnNQTlBOK1hnNUpyc1o1bVYzLzhPNTQz?=
 =?utf-8?B?NzYzOUcyc1lBK04wa3ZlQUJmZDU5QlhJdjM0bXJLSnRSOEJhb1dvS2ZkWG1w?=
 =?utf-8?B?bDJMTXU3bGIrT0NkZ1lXVHhOdUVNNXEzZ2M0YzI4TkFQQ0FxZ2tyWEdwbm83?=
 =?utf-8?B?SC9oZWIrT292eEU1YnRoZE5ZS24zY0RlVnN6MVhQcHJwZFRWKzROWlA5VWhP?=
 =?utf-8?B?UEF2YVUreHVBOGppaGNDdnlnZmV3bDIzcHhPWEYybHQ3RWs4SWlBeWJ5dDVz?=
 =?utf-8?B?MTFCajJuWUk3UUk2ay9oSm12Vk5DYzJIWnltdHlONU5jQnBPUkVXSm1pZDc3?=
 =?utf-8?B?SEMyKzVVUmpSZElrbmRrZ1FEUGFRTDNpVFowWE1lQmF4dG5abXc2VnRhQnkz?=
 =?utf-8?B?R3dObkNydkFjUTVPQ3VOYkxyTysydm11RUM0T2ZwYlRiMVJqS0Z0WWxoWHZt?=
 =?utf-8?B?eXhXNStUZ2pwUkRCTjQ2eHN3YVpLMkRzR0MxRUoxSURGa2JlRWY5RTNMcXM4?=
 =?utf-8?B?VWticUg3SllzZ08xTng1ZFM1WDNjV2o2Z0lWY2wyZW5WaEdQd05lbHc5djBz?=
 =?utf-8?B?UXZvckFMMzVlZUVuRUwxN3dSTzJUWTdpRGRObTlhRGlvSTdmOHM1T1FJZ3pw?=
 =?utf-8?B?YnZ1NnQwYUxxZExKSzNyNytNZ3V2VGRQNWhmaUR3THBqMVZ1RHFVWWwzc1ZE?=
 =?utf-8?B?b3ArNHJlOG13V1J6ekNOVFdtMGs5OEFERU96bUdQMElyVjV5SUUrYm9HYmd5?=
 =?utf-8?B?TjRwTVpUTkVIbVFRd21yQU5GQkxzMHE5SDRrSWZSaTNsS3pBbDdzaTRxWEdt?=
 =?utf-8?B?Rk9SZGZUcFhoait3dXo5UURGNG81VjJPQ2ZYQk50UGN1VW1kWWVOd2FiVDR5?=
 =?utf-8?B?YnRMcEV4L2pIak1GcVIzOFc4bXRGYlZZNWI4RU5EMTJTazlxS1FVQVBqMW4w?=
 =?utf-8?B?d09vMEpKcmhkSGNiM1M1bkRoay8wM0Q3VTh3UHVWOVRNclNXdVQxZUFyMG9R?=
 =?utf-8?B?TGEvV3pJRWR3RXdFN1NoMEhscmw5UnA3M2hyZEczMEJDMElSYU0wL3ZlQ25H?=
 =?utf-8?B?UDl4UzQySVdFaTZWTFVrcEFlQmc1Q1UwNUFkZWxmUTlkelhVUnN6SmFmZ2JQ?=
 =?utf-8?B?eXdBSWZheTJlZUYvbHA1YS9XdXlISlR6RDhtcEJDbS9HU2NVOWRpU0FoT2VL?=
 =?utf-8?Q?l50i4tElz/I2lmc6Moz12Go=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9CFB6A05F2F5F4F8B2B304E39737AF3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e971d245-9425-4064-cebf-08da01ac7a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 09:09:12.4485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQgb5JXjJpVkM/iY49zecAshcGp6kmydhA2SrWaAx+aJPKJPKZ2LVfdevZ+ZzcP7LfrlMl7PTGakUuJOgKeA/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVrYXMgQnVsd2FobiA8bHVrYXMuYnVsd2FobkBnbWFpbC5jb20+IHdyaXRlczoNCg0KPiBDb21t
aXQgNDI5YzgzYzc4YWIyICgiZHQtYmluZGluZ3M6IG5ldDogZHNhOiByZWFsdGVrOiBjb252ZXJ0
IHRvIFlBTUwNCj4gc2NoZW1hLCBhZGQgTURJTyIpIGNvbnZlcnRzIHJlYWx0ZWstc21pLnR4dCB0
byByZWFsdGVrLnlhbWwsIGJ1dCBtaXNzZWQgdG8NCj4gYWRqdXN0IGl0cyByZWZlcmVuY2UgaW4g
TUFJTlRBSU5FUlMuDQo+DQo+IEhlbmNlLCAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwgLS1z
ZWxmLXRlc3Q9cGF0dGVybnMgY29tcGxhaW5zIGFib3V0IGENCj4gYnJva2VuIHJlZmVyZW5jZS4N
Cj4NCj4gUmVwYWlyIHRoaXMgZmlsZSByZWZlcmVuY2UgaW4gUkVBTFRFSyBSVEw4M3h4IFNNSSBE
U0EgUk9VVEVSIENISVBTLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWthcyBCdWx3YWhuIDxsdWth
cy5idWx3YWhuQGdtYWlsLmNvbT4NCj4gLS0tDQo+IGFwcGxpZXMgY2xlYW5seSBvbiBuZXh0LTIw
MjIwMzA4DQo+DQo+IERhdmlkLCBwbGVhc2UgcGljayB0aGlzIG1pbm9yIG5vbi11cmdlbnQgY2xl
YW4tdXAgcGF0Y2ggZm9yIG5ldC1uZXh0Lg0KPg0KPiAgTUFJTlRBSU5FUlMgfCAyICstDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KUmV2aWV3ZWQt
Ynk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4=
