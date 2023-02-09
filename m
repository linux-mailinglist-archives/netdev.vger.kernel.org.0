Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0046910BA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBISwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjBISv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:51:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DCE31E31
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:51:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYnj5vD488R7i0z8f36qX+/z5xBqD+gCeV6e5yHxI1fKXcEioRuGv/NevDiiRj8cYhwX8C4yVp5Fzb00eKKpuqSBP4YwLT2yRJ3AF4sTMKg6nKhqTBbAp0HQVQcAgNBu6RNb8k5jBrIpsfqnY5PTyO88zXd0TwXi3lgIpTvNQtha9pRqQ6v3MQWQj6511QBrXJVH6pMXkWHXob//+/qlYPFHmd2/9ZvZcDQeXlnFU5GkYIW25QjaAtclaIhXTPlM5Xo07AHdczsDqrfFqVZtc0qj9dsxrpQVIJJYKyzl3vZNU6vgr+B9rs+gkKNhWaULBtEDzurIBq8SzA4UaxkI9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPxeE35c+8rewK1e6du9ciGWDV77EbaPV4F0JYJv4p4=;
 b=icE07UXSLERZIat/IKfDjNekwfGWJQuvoGWtWsacvcL7QTwoHdRq+bvDaiYhw/qzJWT57burjqfctPVlu1U1CagF9rTbhlJS0iPkPDZ+e6/9KJ6PuNBB8+fFjvHvmyFzAQCdDveGfyDOtfjJXS95a4DeZJnSZib+mkQ8V0HR284VFA4Dg1Z1UMc4N+ntzhI/15of6UoaGvhM+3aQtoOVJ1JbfX7qNXgEugB7tmqT0FeU1qPNZmfq7CE3mjVG2USG9TRTjXqYtpjAigeFnEhojNft9c1UnchMv9VC9tHTinrgT2sc4gCeGZ+Gh7TiXyU9uyVGVIhKFMhcb5xIxDcVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPxeE35c+8rewK1e6du9ciGWDV77EbaPV4F0JYJv4p4=;
 b=OtzppzjQYES5IbzYWs9PwPTNV7ylhr3SYdUawCe3KcjssyPdFGwDcMbD7NOZpdtWQq8grGQ1Dx8vzYplktK0FBieDYV2Z1Or2E51xDGOZaPORUSGHtNhWeSzgmjIUr7qsKJYHjaxwPuBeH6YXWTypflpo+tI4ixnyKnKjo3JaEs=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM9PR03MB7557.eurprd03.prod.outlook.com (2603:10a6:20b:414::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 18:51:49 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb%5]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 18:51:48 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Topic: [PATCH net-next v2] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Index: AQHZOxiIOtxkZDjSR0iQ62H7GTLQvq7G+O6A
Date:   Thu, 9 Feb 2023 18:51:48 +0000
Message-ID: <20230209185147.lsyrxzjlz65mohy3@bang-olufsen.dk>
References: <20230207171557.13034-1-luizluca@gmail.com>
In-Reply-To: <20230207171557.13034-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AM9PR03MB7557:EE_
x-ms-office365-filtering-correlation-id: 6250487c-d5b3-4021-6d76-08db0aceb2e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ICHMmP8zJCQmA69NVQk2lPVNmXebDwNG1bw7qe9+qc61qZbjXxd6Rh0oj7DccoRd07N08d6UJ3myAC11iRg568NUydQJrXUZcIG/U8ImzmJWUtDkpHROWLxwO6GSJAaSOoABJtVDCGnOKXIVeXrqtfeAOlWFHXMh+LV5LvmxAwmR5QskYiDPBPhMp8/flhVvAC0Ar5NtvX8kmXOMZ+iEbmyN2UpYEmRGSq/HnD/9MrdH3ozYpK0dHoPhVtWRdGd+hfYkNXpLV7sA1TTvY1MVIbRZQGSk5UonVz3Vd2IXHFf+fbHJ1ABVz8DnNW7FmYWDnjTeiweAWeGfu+agzI80ck64L3RMFcYd7P7SY9Pjbb4+4SulAxms84NOJBbVKPFvTRkMrVp/hde5hiNQ7MEBJTisja9QT8j31Cpp/N3Un5xf9K4qha3K8X2/3LZn+d5tHp3n+N8kj6W1sq6KG9NCmbwD8X3VqQMh8y8nery8lDkI6u52xjT9gH2PwtN+Ia2FmgYrkeWFWyRLAcIcwIyW/4fGmwH4V3Y5foQtpnWn3BHRDj1g5Mw3D0J9uYitZReGaY2hGrXavRDFMfo5R9CLhk1jTK8DM5sXN+icasJ/pha17lQed85ErHPXFA8Yw7xy0A9qsZsuP5kUZVKfe21NJFaLKhZktLZjfbZy1HAEcFqC0W4YTN2cuVjtmDcL+zox97mvlcaF9F9UYtm+CoLhKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199018)(2906002)(85202003)(36756003)(85182001)(71200400001)(83380400001)(122000001)(2616005)(8976002)(38070700005)(7416002)(86362001)(64756008)(66446008)(66476007)(91956017)(66556008)(76116006)(54906003)(316002)(8676002)(6916009)(5660300002)(8936002)(4326008)(66946007)(38100700002)(26005)(1076003)(6506007)(186003)(6512007)(41300700001)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzJ2c3RuREZFNkh3UGNzdlQzczR6RytFK0tZUTlGRVhjcnIrdDIvOFErN3Qz?=
 =?utf-8?B?OVBUNzY0TW5EbVcxc25iL2N0MTd5MVhOcEliWkpqa0FVZ2hEdXFsNm5SMytL?=
 =?utf-8?B?dlB2UEJmWXVySnJtMVFvNjBWbzdOZ2hEdUh0cU1SV1FLMndLdFA1MlhzMzNq?=
 =?utf-8?B?NnhqYUlRdVI0VmdVY0RIU0dVcGI0eElLQkJDOC9GL25sUVcwMnZuZkRXa2RV?=
 =?utf-8?B?WGVQcDhjWCs3blV4SmdHTzR5ejVwVmhQTVFSQUF4RVJ6VmNwbHNUSGlwaDFC?=
 =?utf-8?B?bUVEcGZMM2hMbncrSlBNcWR1eVRWYjluMFUrU3ZJaWFzdnJTU3F2SXJWbklt?=
 =?utf-8?B?ajRPVjVQeVdQVDg3K3BucTdFQmFGakk2TnhnRk90VkFDcEluTFdGVDRNTmNx?=
 =?utf-8?B?RlhiNHdaVE9tMUw5c1R1QjNybklEZmFTNDFKR1A0b0pIY09MUmh2S2FLeGtv?=
 =?utf-8?B?b2gwR3YzK2ZtT2xPMEkwM21Va0RXbTNTa3NLbXJyWUFZcjBpdTNPaG4yMmhx?=
 =?utf-8?B?RlpMbm9LTzdNcFpsM3g2T1AxWVVVUnRkeXVRWUQrbThjbVU0Nmw2dUFaZVRV?=
 =?utf-8?B?ZjNENjdsQU9hSXZWRjQ2YTgzdVN3SVpPN1Qrb2l4Um5HZnJkK0tZOC81OUdN?=
 =?utf-8?B?Q1lISytJMUp5M2I5dUdNdmZoVmJQNVRzV3ZxdEwzMG13Z2I5eXpSYXZnRCs2?=
 =?utf-8?B?SmNmMTBTbXhSeUFKVWxwdWtoQnI2bWw1WW9aNUN0bCtPaE5rdURtdDVZR3Jm?=
 =?utf-8?B?QTVDZFhaTVFtSTN3dGNONDFwZWVTdHI3T0NFUlIzamNpSzM3dVlmMnRLM1Jm?=
 =?utf-8?B?STk0LzAxRU9KSm9odEZEcFpLTlpyMndFdTYwbUFqRzdiT0lsOFpkdVJvNkFK?=
 =?utf-8?B?a2tvSUFrTzU3SUtSRUZiMjRFUnJmK2dQZGRSdURCWUZOczhhMlpGK0Z2U3U2?=
 =?utf-8?B?QXlac2x2dTd0ZHNBenI2ekRpdTM3MGprci9Fc3o2YUg1Y05nMmZTRE9LVUcw?=
 =?utf-8?B?aDJkNE5rbmZCRDdXWkZ5M0FlRXlLcVdUTUhYSGptbFRTYk1VVjk3UlpReVFl?=
 =?utf-8?B?azRBQ0FWVDFyUXpqTzd1ZFBWWExTdHR4U2gzZ0NtbCt3eFc2MXE5aFVaTUdz?=
 =?utf-8?B?OWg1MXJScEdUVGZqa2JuUEJLVGI1WmJueWIzNjFGRG4wRjJWalMwWFdWY3lU?=
 =?utf-8?B?dm9za2ptZ2xSNGFldURBOTluOEhHS05aRHEwNFB6MHZIRjR1RzBDRG9Od2dp?=
 =?utf-8?B?clFZQ0hMeHFZNytCWDVWdEp1WlRZM0gweTNFZ2dPRXFvQlkxNGhPYi9qU3NZ?=
 =?utf-8?B?N21HN24wamI2dUlxZHg0ajdpRlorZ1NNUmxaSmpod0g2UDJIb0pBUTRPSnk2?=
 =?utf-8?B?UHFnSjBZUkVjdGlKSXIrN2JFYjU2cU9GTlZKdXUrbU5HbjVrUDVlTjVmWmR6?=
 =?utf-8?B?NUNCTVV4NW1XNk9LeWxpTkV5dnhSSGErSWRwaVl3VmdPR2w4emxUV0VXN2JV?=
 =?utf-8?B?dmdEcUdLa1Urakh0ZDF6L0xuUXZXMGtHelRhQnFEZlNxTEEveStJa1p1Ukp1?=
 =?utf-8?B?NEkrK0RsTk11b0dCeHZkT0VRcXFUMVBTbW43M3FvbUNRWEphazZCMy9sU29F?=
 =?utf-8?B?ZHJaTTdlOTZzZnM3cGZLNnBxMzVjcUFnSjk0VEFRdjNLY2lqeXROQVF1aURE?=
 =?utf-8?B?aldSNUdzbzFDaGlTSDFzdHNFVUJZOWQra1lQOThlaEtGc0JuaWZrcjIwclFL?=
 =?utf-8?B?ZDB5ZVBKTDNZelJTb0hXc28zY0hLUnJLZHhkdC9rRys4cGJCTWxWdGlKZXla?=
 =?utf-8?B?Z3JpckVWdzZxWGJXd2hreWxIdmJ0VHZVOXM5djMwSlFpZ3hNRk1RdzRSYlRT?=
 =?utf-8?B?Tkt4Zm9udC96eGxFaEVDS3lIMkZsN04rVUtIMnRXZDdGb2JPTU1WVmNzS1dv?=
 =?utf-8?B?YmhTeDV1WWlrRTJFT1BZRHN3NktDOERtVXBac0JDRmpvSkpXV3Q0dUZ6OFBm?=
 =?utf-8?B?blNjMGdtWVBEcHZHbllDWVlScXFQNG1ISFZnT05BZHJXTmRWSXdIQ1p1R1ln?=
 =?utf-8?B?cTZKYzNyV3hNdEdRYWlDcThIZDIydm1HY0RyaE1FZXo1aU4rRzljeVplcTR6?=
 =?utf-8?B?TWdSU3VpdXVhSXo0TGdXODRHMCt0QkEzR0daOE9la1hOTFRTRzhzZEZNZlBE?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD593152D70093429BB843C5F8716CF1@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6250487c-d5b3-4021-6d76-08db0aceb2e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 18:51:48.3574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lZKF8KbiyhZYTZbszxJAeHlbCqGNGPgO/rT7hZ1dqZpMyoN5wGhuSiu/zgLlxcXVt24c0UsuPVrisl6ZYRl+IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBGZWIgMDcsIDIwMjMgYXQgMDI6MTU6NThQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gcnRsODM2NW1iIHdhcyB1c2luZyBhIGZpeGVkIE1UVSBzaXpl
IG9mIDE1MzYsIHByb2JhYmx5IGluc3BpcmVkIGJ5DQo+IHJ0bDgzNjZyYiBpbml0aWFsIHBhY2tl
dCBzaXplLiBEaWZmZXJlbnQgZnJvbSB0aGF0IGZhbWlseSwgcnRsODM2NW1iDQo+IGZhbWlseSBj
YW4gc3BlY2lmeSB0aGUgbWF4IHBhY2tldCBzaXplIGluIGJ5dGVzIGFuZCBub3QgaW4gZml4ZWQg
c3RlcHMuDQo+IE5vdyBpdCBkZWZhdWx0cyB0byBWTEFOX0VUSF9ITEVOK0VUSF9EQVRBX0xFTitF
VEhfRkNTX0xFTiAoMTUyMiBieXRlcykuDQo+IA0KPiBEU0EgY2FsbHMgY2hhbmdlX210dSBmb3Ig
dGhlIENQVSBwb3J0IG9uY2UgdGhlIG1heCBtdHUgdmFsdWUgYW1vbmcgdGhlDQo+IHBvcnRzIGNo
YW5nZXMuIEFzIHRoZSBtYXggcGFja2V0IHNpemUgaXMgZGVmaW5lZCBnbG9iYWxseSwgdGhlIHN3
aXRjaA0KPiBpcyBjb25maWd1cmVkIG9ubHkgd2hlbiB0aGUgY2FsbCBhZmZlY3RzIHRoZSBDUFUg
cG9ydC4NCj4gDQo+IFRoZSBhdmFpbGFibGUgc3BlY3MgZG8gbm90IGRpcmVjdGx5IGRlZmluZSB0
aGUgbWF4IHN1cHBvcnRlZCBwYWNrZXQNCj4gc2l6ZSwgYnV0IGl0IG1lbnRpb25zIGEgMTZrIGxp
bWl0LiBIb3dldmVyLCB0aGUgc3dpdGNoIHNldHMgdGhlIG1heA0KPiBwYWNrZXQgc2l6ZSB0byAx
NjM2OCBieXRlcyAoMHgzRkYwKSBhZnRlciBpdCByZXNldHMuIFRoYXQgdmFsdWUgd2FzDQo+IGFz
c3VtZWQgYXMgdGhlIG1heGltdW0gc3VwcG9ydGVkIHBhY2tldCBzaXplLg0KPiANCj4gTVRVIHdh
cyB0ZXN0ZWQgdXAgdG8gMjAxOCAod2l0aCA4MDIuMVEpIGFzIHRoYXQgaXMgYXMgZmFyIGFzIG10
NzYyMA0KPiAod2hlcmUgcnRsODM2N3MgaXMgc3RhY2tlZCkgY2FuIGdvLg0KDQpUaGlua2luZyBh
Ym91dCBpdCwgSSdtIHN1cmUgd2h5IHlvdSB3b3VsZCB0ZXN0IHRoaXMgd2l0aCA4MDIuMVENCnNw
ZWNpZmljYWxseS4gTWF5YmUgeW91IGNhbiBlbGFib3JhdGUgb24gaG93IHlvdSB0ZXN0ZWQgdGhp
cz8NCg0KPiANCj4gVGhlcmUgaXMgYSBqdW1ibyByZWdpc3RlciwgZW5hYmxlZCBieSBkZWZhdWx0
IGF0IDZrIHBhY2tldCBzaXplLg0KPiBIb3dldmVyLCB0aGUganVtYm8gc2V0dGluZ3MgZG9lcyBu
b3Qgc2VlbSB0byBsaW1pdCBub3IgZXhwYW5kIHRoZQ0KPiBtYXhpbXVtIHRlc3RlZCBNVFUgKDIw
MTgpLCBldmVuIHdoZW4ganVtYm8gaXMgZGlzYWJsZWQuIE1vcmUgdGVzdHMgYXJlDQo+IG5lZWRl
ZCB3aXRoIGEgZGV2aWNlIHRoYXQgY2FuIGhhbmRsZSBsYXJnZXIgZnJhbWVzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29t
Pg0KPiAtLS0NCj4gDQo+IHYxLT52MjoNCj4gLSBkcm9wcGVkIGp1bWJvIGNvZGUgYXMgaXQgd2Fz
IG5vdCBjaGFuZ2luZyB0aGUgYmVoYXZpb3IgKHVwIHRvIDJrIE1UVSkNCj4gLSBmaXhlZCB0eXBv
cw0KPiAtIGZpeGVkIGNvZGUgYWxpZ25tZW50DQo+IC0gcmVuYW1lZCBydGw4MzY1bWJfKGNoYW5n
ZXxtYXgpX210dSB0byBydGw4MzY1bWJfcG9ydF8oY2hhbmdlfG1heClfbXR1DQo+IA0KPiAgZHJp
dmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMgfCA0MyArKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2
NW1iLmMgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBpbmRleCBkYTMx
ZDhiODM5YWMuLmMzZTBhNWI1NTczOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3Jl
YWx0ZWsvcnRsODM2NW1iLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2
NW1iLmMNCj4gQEAgLTk4LDYgKzk4LDcgQEANCj4gICNpbmNsdWRlIDxsaW51eC9vZl9pcnEuaD4N
Cj4gICNpbmNsdWRlIDxsaW51eC9yZWdtYXAuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9pZl9icmlk
Z2UuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9pZl92bGFuLmg+DQo+ICANCj4gICNpbmNsdWRlICJy
ZWFsdGVrLmgiDQo+ICANCj4gQEAgLTI2Nyw2ICsyNjgsOCBAQA0KPiAgLyogTWF4aW11bSBwYWNr
ZXQgbGVuZ3RoIHJlZ2lzdGVyICovDQo+ICAjZGVmaW5lIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5f
UkVHCTB4MDg4Qw0KPiAgI2RlZmluZSAgIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSwkweDNG
RkYNCj4gKy8qIE5vdCBzdXJlIGJ1dCBpdCBpcyB0aGUgZGVmYXVsdCB2YWx1ZSBhZnRlciByZXNl
dCAqLw0KPiArI2RlZmluZSBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX01BWAkweDNGRjANCg0KQWdh
aW4sIHRoZSBtYXggaXMgMHgzRkZGIHBlciB0aGUgYXV0b21hdGljYWxseSBnZW5lcmF0ZWQgcmVn
aXN0ZXIgbWFwDQpmcm9tIHRoZSB2ZW5kb3IgZHJpdmVyLiBVbmxlc3MgeW91IGhhdmUgZXZpZGVu
Y2UgdG8gdGhlIGNvbnRyYXJ5LiBQbGVhc2UNCmZpeCB0aGlzLg0KDQo+ICANCj4gIC8qIFBvcnQg
bGVhcm5pbmcgbGltaXQgcmVnaXN0ZXJzICovDQo+ICAjZGVmaW5lIFJUTDgzNjVNQl9MVVRfUE9S
VF9MRUFSTl9MSU1JVF9CQVNFCQkweDBBMjANCj4gQEAgLTExMzUsNiArMTEzOCwzNiBAQCBzdGF0
aWMgdm9pZCBydGw4MzY1bWJfcGh5bGlua19tYWNfbGlua191cChzdHJ1Y3QgZHNhX3N3aXRjaCAq
ZHMsIGludCBwb3J0LA0KPiAgCX0NCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCBydGw4MzY1bWJf
cG9ydF9jaGFuZ2VfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICsJCQkJ
ICAgICBpbnQgbmV3X210dSkNCj4gK3sNCj4gKwlzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2ID0g
ZHMtPnByaXY7DQo+ICsJaW50IGZyYW1lX3NpemU7DQo+ICsNCj4gKwkvKiBXaGVuIGEgbmV3IE1U
VSBpcyBzZXQsIERTQSBhbHdheXMgc2V0cyB0aGUgQ1BVIHBvcnQncyBNVFUgdG8gdGhlDQo+ICsJ
ICogbGFyZ2VzdCBNVFUgb2YgdGhlIHNsYXZlIHBvcnRzLiBCZWNhdXNlIHRoZSBzd2l0Y2ggb25s
eSBoYXMgYSBnbG9iYWwNCj4gKwkgKiBSWCBsZW5ndGggcmVnaXN0ZXIsIG9ubHkgYWxsb3dpbmcg
Q1BVIHBvcnQgaGVyZSBpcyBlbm91Z2guDQo+ICsJICovDQo+ICsNCg0KU3B1cmlvdXMgbmV3bGlu
ZS4NCg0KPiArCWlmICghZHNhX2lzX2NwdV9wb3J0KGRzLCBwb3J0KSkNCj4gKwkJcmV0dXJuIDA7
DQo+ICsNCj4gKwlmcmFtZV9zaXplID0gbmV3X210dSArIFZMQU5fRVRIX0hMRU4gKyBFVEhfRkNT
X0xFTjsNCg0KSSdtIHN0aWxsIG5vdCBjb252aW5jZWQgdGhhdCB0aGlzIGlzIGNvcnJlY3QuIGRz
YV9tYXN0ZXJfc2V0dXAoKSBzZXRzDQp0aGUgbWFzdGVyIE1UVSB0byBFVEhfREFUQV9MRU4gKyBk
c2FfdGFnX3Byb3RvY29sX292ZXJoZWFkKHRhZ19vcHMpIGJ5DQpkZWZhdWx0LiBTbyBldmVuIGlm
IHlvdSB3YW50ZWQgdG8gbWFrZSBzcGFjZSBmb3IgODAyLjFRLXRhZ2dlZCBwYWNrZXRzDQp3aG9z
ZSBwYXlsb2FkIHdhcyAxNTAwIGJ5dGVzLCB0aGV5IHdvdWxkbid0IG1ha2UgaXQgcGFzdCB0aGUg
bWFzdGVyLCBhcw0KdGhleSBhcmUgNCBvY3RldHMgdG9vIGJpZyBmb3IgaXRzIE1UVS4gT3Igd2hh
dCBhbSBJIG1pc3Npbmc/DQoNCk9uIHRoZSBvdGhlciBoYW5kLCBzaW5jZSB3ZSBhcmUgdGFsa2lu
ZyB0b3RhbCBmcmFtZSBzaXplIGhlcmUsIHNob3VsZG4ndA0KeW91IHNob3VsZCBhbHNvIGNvbXBl
bnNhdGUgZm9yIHRoZSBDUFUgdGFnICg4IGJ5dGVzKT8gRGlkIHlvdSBjaGVjaw0KdGhpcz8gRm9y
IGV4YW1wbGUsIG1heWJlIHRoZSBzd2l0Y2ggYXBwbGllcyB0aGUgZnJhbWUgc2l6ZSBjaGVjayBh
ZnRlcg0KcG9wcGluZyB0aGUgQ1BVIHRhZyBhbmQgdGhhdCdzIHdoeSB5b3UgZG9uJ3QgYWRkIGl0
Pw0KDQpJIHRoaW5rIHRoZSBjb21tZW50IGluIGRzYS5oIGlzIGhlbHBmdWw6DQoNCgkvKg0KCSAq
IE1UVSBjaGFuZ2UgZnVuY3Rpb25hbGl0eS4gU3dpdGNoZXMgY2FuIGFsc28gYWRqdXN0IHRoZWly
IE1SVSB0aHJvdWdoDQoJICogdGhpcyBtZXRob2QuIEJ5IE1UVSwgb25lIHVuZGVyc3RhbmRzIHRo
ZSBTRFUgKEwyIHBheWxvYWQpIGxlbmd0aC4NCgkgKiBJZiB0aGUgc3dpdGNoIG5lZWRzIHRvIGFj
Y291bnQgZm9yIHRoZSBEU0EgdGFnIG9uIHRoZSBDUFUgcG9ydCwgdGhpcw0KCSAqIG1ldGhvZCBu
ZWVkcyB0byBkbyBzbyBwcml2YXRlbHkuDQoJICovDQoJaW50CSgqcG9ydF9jaGFuZ2VfbXR1KShz
dHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KCQkJCSAgIGludCBuZXdfbXR1KTsNCglp
bnQJKCpwb3J0X21heF9tdHUpKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQpOw0KDQoN
Ck15IGJpZCB3b3VsZCBiZToNCg0KCWZyYW1lX3NpemUgPSBuZXdfbXR1ICsgOCArIEVUSF9ITEVO
ICsgRVRIX0ZDU19MRU47DQoNCndoZXJlIHRoZSA4IGlzIGZvciB0aGUgQ1BVIHRhZy4NCg0KPiAr
DQo+ICsJZGV2X2RiZyhwcml2LT5kZXYsICJjaGFuZ2luZyBtdHUgdG8gJWQgKGZyYW1lIHNpemU6
ICVkKVxuIiwNCj4gKwkJbmV3X210dSwgZnJhbWVfc2l6ZSk7DQo+ICsNCj4gKwlyZXR1cm4gcmVn
bWFwX3VwZGF0ZV9iaXRzKHByaXYtPm1hcCwgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9SRUcsDQo+
ICsJCQkJICBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX01BU0ssDQo+ICsJCQkJICBGSUVMRF9QUkVQ
KFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSywNCj4gKwkJCQkJICAgICBmcmFtZV9zaXplKSk7
DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbnQgcnRsODM2NW1iX3BvcnRfbWF4X210dShzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0KQ0KPiArew0KPiArCXJldHVybiBSVEw4MzY1TUJfQ0ZH
MF9NQVhfTEVOX01BWCAtIFZMQU5fRVRIX0hMRU4gLSBFVEhfRkNTX0xFTjsNCj4gK30NCj4gKw0K
PiAgc3RhdGljIHZvaWQgcnRsODM2NW1iX3BvcnRfc3RwX3N0YXRlX3NldChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgCQkJCQkgdTggc3RhdGUpDQo+ICB7DQo+IEBAIC0xOTgw
LDEwICsyMDEzLDggQEAgc3RhdGljIGludCBydGw4MzY1bWJfc2V0dXAoc3RydWN0IGRzYV9zd2l0
Y2ggKmRzKQ0KPiAgCQlwLT5pbmRleCA9IGk7DQo+ICAJfQ0KPiAgDQo+IC0JLyogU2V0IG1heGlt
dW0gcGFja2V0IGxlbmd0aCB0byAxNTM2IGJ5dGVzICovDQo+IC0JcmV0ID0gcmVnbWFwX3VwZGF0
ZV9iaXRzKHByaXYtPm1hcCwgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9SRUcsDQo+IC0JCQkJIFJU
TDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSywNCj4gLQkJCQkgRklFTERfUFJFUChSVEw4MzY1TUJf
Q0ZHMF9NQVhfTEVOX01BU0ssIDE1MzYpKTsNCj4gKwkvKiBTZXQgcGFja2V0IGxlbmd0aCBmcm9t
IDE2MzY4IHRvIDE1MDArMTQrNCs0PTE1MjIgKi8NCg0KVGhpcyBjb21tZW50IGlzIG5vdCB2ZXJ5
IGhlbHBmdWwgSU1PLi4uDQoNCj4gKwlyZXQgPSBydGw4MzY1bWJfcG9ydF9jaGFuZ2VfbXR1KGRz
LCBjcHUtPnRyYXBfcG9ydCwgRVRIX0RBVEFfTEVOKTsNCj4gIAlpZiAocmV0KQ0KPiAgCQlnb3Rv
IG91dF90ZWFyZG93bl9pcnE7DQo+ICANCj4gQEAgLTIxMDMsNiArMjEzNCw4IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2NW1iX3N3aXRjaF9vcHNfc21pID0gew0K
PiAgCS5nZXRfZXRoX21hY19zdGF0cyA9IHJ0bDgzNjVtYl9nZXRfbWFjX3N0YXRzLA0KPiAgCS5n
ZXRfZXRoX2N0cmxfc3RhdHMgPSBydGw4MzY1bWJfZ2V0X2N0cmxfc3RhdHMsDQo+ICAJLmdldF9z
dGF0czY0ID0gcnRsODM2NW1iX2dldF9zdGF0czY0LA0KPiArCS5wb3J0X2NoYW5nZV9tdHUgPSBy
dGw4MzY1bWJfcG9ydF9jaGFuZ2VfbXR1LA0KPiArCS5wb3J0X21heF9tdHUgPSBydGw4MzY1bWJf
cG9ydF9tYXhfbXR1LA0KPiAgfTsNCj4gIA0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBkc2Ffc3dp
dGNoX29wcyBydGw4MzY1bWJfc3dpdGNoX29wc19tZGlvID0gew0KPiBAQCAtMjEyNCw2ICsyMTU3
LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkc2Ffc3dpdGNoX29wcyBydGw4MzY1bWJfc3dpdGNo
X29wc19tZGlvID0gew0KPiAgCS5nZXRfZXRoX21hY19zdGF0cyA9IHJ0bDgzNjVtYl9nZXRfbWFj
X3N0YXRzLA0KPiAgCS5nZXRfZXRoX2N0cmxfc3RhdHMgPSBydGw4MzY1bWJfZ2V0X2N0cmxfc3Rh
dHMsDQo+ICAJLmdldF9zdGF0czY0ID0gcnRsODM2NW1iX2dldF9zdGF0czY0LA0KPiArCS5wb3J0
X2NoYW5nZV9tdHUgPSBydGw4MzY1bWJfcG9ydF9jaGFuZ2VfbXR1LA0KPiArCS5wb3J0X21heF9t
dHUgPSBydGw4MzY1bWJfcG9ydF9tYXhfbXR1LA0KPiAgfTsNCj4gIA0KPiAgc3RhdGljIGNvbnN0
IHN0cnVjdCByZWFsdGVrX29wcyBydGw4MzY1bWJfb3BzID0gew0KPiAtLSANCj4gMi4zOS4xDQo+
