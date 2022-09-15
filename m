Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023215B9EEF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiIOPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiIOPep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:45 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2090.outbound.protection.outlook.com [40.107.21.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA482126D;
        Thu, 15 Sep 2022 08:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neLNklXE2Z/3nzDQg067V2SPp1XlDANHt6IuSeOiK4q1XUgN3DGP21Y+v6VbrjBYhElNBN5gSyAszgbIbGow5+bsN3iKTjSyqkskbk5HLowINfmNbxK4aUjFrXn6RofQHQPouAw5HY8EPyvALfmwtSNwefLzZR5nGCC+eVudeMdgVQjifz4mZaQFLzDTclXSM05gFUcGbYcJ0c8j7Tdefta7D5RbSP4xA6MiW+ZlZqC+9shNPT8Ukz8ZObP2E7pxgxdXnsLaOFlfErXAyQmlLpo0vrqaMBrxd3EZ4GJtwaNwkv8JRgJlhk8TAH+1fu7I6d4C4QQtJevL+BiaI6bo4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZkg1p8YI0Mjmh7z1ysWwGyqzMv1ORI6dlXYGIRGmSY=;
 b=L7HIdXH8R2jmLrxPXSNHbISHjk0nKIfzcLUnh+o0WP/tOXmH7juWcssfGrnobG1S+xdld2lfxMCGJQbsNKloPdzMMPGEP7kiNWIjTgfC/4tfEyKq4GkTHAPaVIJWFe+etXDD5aQ7BHrmoGZS3oS7FCU/IESgj3Fb+ORTdNU+J91Fv3Ju4JNRbpyUtSg2ac0JPyz+2Zt4u0wltbDsBBbK7y6kGe/5Dnq+6/7iaOed+JQepMkgvYkR9NFkt0myrjYC96OB1IcMB6YfVYjxAXAM0WGUvqW6BrHLKLoS3WtPL7UAomMzx2Ccn3zRrtsXON3FiJ+TpHyi/kz3GsqEOW2aHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZkg1p8YI0Mjmh7z1ysWwGyqzMv1ORI6dlXYGIRGmSY=;
 b=kkOtqFiEctrIGRdrqoAtwbVxxhh8M1S3NH6CnuFxvc9lAw+fD+Jqlq3sP+X4ZpjCUqhsoGHph4mMdeBG+ALXKV4Hn4DMifN3+5S3iJ+xX3N8isafvZpWaF23738Th4E4p7Gup7TzV1d8W4cjXqxsVWRcUB/sGRZ3KjzrtNvHF+E=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:40 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:40 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 08/12] brcmfmac: firmware: Allow platform
 to override macaddr
Thread-Topic: [PATCH wireless-next v2 08/12] brcmfmac: firmware: Allow
 platform to override macaddr
Thread-Index: AQHYyRiqHvX4T1zX+0an70+iU68Fnw==
Date:   Thu, 15 Sep 2022 15:34:40 +0000
Message-ID: <20220915153438.zt7hs3yuates7na7@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7x-0064vN-Cm@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7x-0064vN-Cm@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: 8d60180c-66b6-474d-9ea6-08da972fce47
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SX0ggyuGGFYisCPc0DJigIIAeFql2Eg/eVFZq/oBiDEn7tCnQgwryJBiDSEBOYyto6CHCBMqQrvB8PvKeEWzKKBt+xLVnqVp9pTPHqVsphNTJa2pYydWl82yvlM5XiWb6HYAxMLmAbfzMGrqo/dA94X19qUteTDE0AHWzO7uX8aVCNMVhn/kXtIcbvoWubEIWNjdiw1BJU2MfAVE81hg404quBUo1PPhAjI1gPVptMkwWcUBirX3eXeqXD5E7IJCB3HvthvrUt7oAuGquHMxW7GRcM+NiOM50zx2AH/ncSffKwUTW77edbrwPpetlyl0ZimIdUnvy52LvAcr+w5B7Nou00k0UudTb5aQ2AzhWqt/2qkaM3i8TJB7xWtX1M7MCm5MfzX4lCffyxGdz198Sn7YwWdTiyHrv3wSP6au3vn19goPuqsjNZF9+KAIDfAlpqxwCuHfTwklbxTqvP6Dv3oo+yGnOqH1DPnZX3+tffHwWCIj8awgyojZOngolYek1jP5dHIQ4x7xh/al/Otxp15OwVljXr9mQdn7wZ/Ajo2HnDEQkqmc388xac4ioc+XcmAosabfz3y32X2K1tD5+JC/GW/Dh86xYmZJO1aWwbRq/t+eVOmmzPGQxfWcm7YSkKTrphsudMasO4v1OaTgI/zecJcyQpAaSdFrxXQQ0rOdOx7IErPkMzJK4eKixGPYjuCV8qSMCvhE/A5y/zErn9/bhRtooW8P5fN+hfamvWdREzIe6fcxHrDWtJe1DrUX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(66574015)(38070700005)(85182001)(83380400001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUw2Mk9KSFJOd0JjS2NXT3Z6cHNZZlFndFIwc0IxSVhjVzFaSFNVTmI5TmZZ?=
 =?utf-8?B?aDljSUFraC9zM2NkOVpydHhsQUd6OEplem9VcEYyMWsrQ0lsZXhvMkp6QlFi?=
 =?utf-8?B?K2VNaEtCV2s1Y09VL1FTR0pCTW1XT0JTZS9hUXBtWVpPTVlkeEE0dzVXeU83?=
 =?utf-8?B?ZCthSGo1VHVTOEJ6bHo0Qmczb3V2bFhGalNrMmFyWDltOFlkd3MwN0EybW5S?=
 =?utf-8?B?SEdCZXJWWFBQd1Irb0Zvcnk3NXptdTRtSFEwVjVSNk14bCtVdmVVUDdvTWZJ?=
 =?utf-8?B?VkZuaUpjYmZCdkViR3dxVWRydXU5QW1tMGZNbTI0Y01FeFlCd1VqV08rN2g5?=
 =?utf-8?B?NW5peUJPN0lQcUlXUWNad2U4MDJuQ3pYZTRzTHV3QUVVckdMWFFtWmFwTGtQ?=
 =?utf-8?B?VFlBWXFzNVRvT3hvQ2NueTFTVkJZcmR0UktXaHlpVUFGb1hIMFZwV2dzWHlO?=
 =?utf-8?B?anRldktxd2Z3bVc3YVFYSU9wNmNBVEJkS1UxSEhISFZKNWs5NUZyLzQ5Vkds?=
 =?utf-8?B?aHQ2bzlpM3ZnOUtwM0s0UHp3S2l1SDE1MFNGeEJJemJmK2VlMmZDYkZuY3M3?=
 =?utf-8?B?R2I1cXlFYS9heFcxTG5sY21ndzhyS0VxYktqMCs4c2Z1Y1p0ckRhUjVwTVZm?=
 =?utf-8?B?ajc1dE94ZmZjeFpkSjhPeXpnRWtOOXBzMjgwenh0aDlLWkRXOVhxazgxSE9P?=
 =?utf-8?B?RGlseVg4QWJyRlYxVEdvT1FrazFwdk44WEh0VVdBSThPYVNWekF4dXcvVGxi?=
 =?utf-8?B?d0p4UTZybnFnS1hlTE56OUdPMzllcW9kY1kySExNVnNlbllpOWhDL2ZQdUJE?=
 =?utf-8?B?SjJjY21ac1BBN01UL0FPZVY3Q3JhS0wvTDlGbnFWRUpWMkVBSnVlb3BURkpJ?=
 =?utf-8?B?bWlqSHN3bi8wUmpjUGJxNXpaRU9uTHB1cFVXdW9lOEY5L0RRVHJ4TStFTm5I?=
 =?utf-8?B?Yzk0M252U25hR3pjREhkN3BHcUJRSHl4b2ovcFZnTU4yR3dXdjh1WXV2d3Qv?=
 =?utf-8?B?Q3M3M1F6UFU0VDhoSEJ5UWN1VkRyM1ppeHkyOUNtelZ0TVRTZkxFMThHbUFo?=
 =?utf-8?B?M0E4NjU1SmF2R0tBM3JvMWFhMW9XZkNkZTcxeUY3R25qYlphNFVqMTRhaGdW?=
 =?utf-8?B?SjdMU3ZnN01laU4yTi9nYXFEMVlaYjlyT21hbTYwazBaWG1jdm5QNzhkMjBo?=
 =?utf-8?B?NGkxSHpOL0pxYnZ0bTJyb1lLSDFmdTNnS2REdkRlOVBEdlNVdEVnQ0ZlZHVa?=
 =?utf-8?B?bzBDeWY2M0ZTZEFuMVZRR2VGTmpOMWhUelBCSG1ibWFwU1FSZGp4Z1RMSHVT?=
 =?utf-8?B?azNERnFSRnI3L3VSeW1hb29EN3FQUTlYYkV0c3FnVDJhSFEvZnZIcFdjeDZO?=
 =?utf-8?B?U0EwQzZZaWhBMUhpeDM1My8wcWExcHdCYzFOQ3FuRjYrZWVZR3luVk1pN2lz?=
 =?utf-8?B?dDhqOHM1RWZqVVRWVG9BbXhHd2g2Y2M3ZTFvamxaN29SdWdMNUpIamVVK1cz?=
 =?utf-8?B?ZDg4YnhoUEFHb3lETlcrVndlSFkwenEwT2xpMm9uSTc4a2M3RVpmM2N1MjJH?=
 =?utf-8?B?dlhBb1JWOVMwZ0UzeWpMN2poQWY1cW9waUt0Ky9GVmd5SlZ6RXBZKzliR0pB?=
 =?utf-8?B?eld4UXkyUUd3U1h4S0R4RUhnTG91a1Vta0dLN0duM0JwMGNKdFFxYUtNMWFR?=
 =?utf-8?B?dy9YSGNlWGRLY0xXcDBrbURxSjBaRUdZNkp6R0dGUmRIYkdoVDljSFNkeGs2?=
 =?utf-8?B?U2hOKzlzbkpPK3JzbHZTTkQxUVY5dEhOVHg2RWNYZDVyTFhCNzBoMTZqaURY?=
 =?utf-8?B?VG5DMDc2b0FsOE5IZWo3TXBWT2FQbHhlL3VGZjBya3lFWHpXUVdpM3g3emtC?=
 =?utf-8?B?N0xJM0RwN0p0RGliWmxtcW9TZXdJZENGNFJXbUZNRXpuVDhkeGN3eGxPRHJq?=
 =?utf-8?B?Rzg1MHZ4TklWblNIcnZnQUtxb0hSR2dwSnROZXJhTDMybDBMeHhDZkFhSVFr?=
 =?utf-8?B?SkNrVjYvQkdnNnU2Ymg1cnkyS2FGVTRkVXZaUmdDakZVS2hFUVNyTUhNVEg0?=
 =?utf-8?B?Y0toaHJEZDNFTVZMblh4ZWg1OS9EYUdobTFpazNRVWFIYlFVRkVoR0NnbllB?=
 =?utf-8?Q?JOkQ1CtLfTy+CEA4SnycrFd89?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FDCD6B466AD3C498263DC73B8C80FD3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d60180c-66b6-474d-9ea6-08da972fce47
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:40.5935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VRY6JqPvjElgnaeRk53fZc2njLvf8gtNaDW+tdm3HAS3rlCgjTQlBGBrmyuKL5egVfY5wk8QJleECk1POi+0jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTM6MTdBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gT24g
RGV2aWNlIFRyZWUgcGxhdGZvcm1zLCBpdCBpcyBjdXN0b21hcnkgdG8gYmUgYWJsZSB0byBzZXQg
dGhlIE1BQw0KPiBhZGRyZXNzIHZpYSB0aGUgRGV2aWNlIFRyZWUsIGFzIGl0IGlzIG9mdGVuIHN0
b3JlZCBpbiBzeXN0ZW0gZmlybXdhcmUuDQo+IFRoaXMgaXMgcGFydGljdWxhcmx5IHJlbGV2YW50
IGZvciBBcHBsZSBBUk02NCBwbGF0Zm9ybXMsIHdoZXJlIHRoaXMNCj4gaW5mb3JtYXRpb24gY29t
ZXMgZnJvbSBzeXN0ZW0gY29uZmlndXJhdGlvbiBhbmQgcGFzc2VkIHRocm91Z2ggYnkgdGhlDQo+
IGJvb3Rsb2FkZXIgaW50byB0aGUgRFQuDQo+IA0KPiBJbXBsZW1lbnQgc3VwcG9ydCBmb3IgdGhp
cyBieSBmZXRjaGluZyB0aGUgcGxhdGZvcm0gTUFDIGFkZHJlc3MgYW5kDQo+IGFkZGluZyBvciBy
ZXBsYWNpbmcgdGhlIG1hY2FkZHI9IHByb3BlcnR5IGluIG52cmFtLiBUaGlzIGJlY29tZXMgdGhl
DQo+IGRvbmdsZSdzIGRlZmF1bHQgTUFDIGFkZHJlc3MuDQo+IA0KPiBPbiBwbGF0Zm9ybXMgd2l0
aCBhbiBTUk9NIE1BQyBhZGRyZXNzLCB0aGlzIG92ZXJyaWRlcyBpdC4gT24gcGxhdGZvcm1zDQo+
IHdpdGhvdXQgb25lLCBzdWNoIGFzIEFwcGxlIEFSTTY0IGRldmljZXMsIHRoaXMgaXMgcmVxdWly
ZWQgZm9yIHRoZQ0KPiBmaXJtd2FyZSB0byBib290IChpdCB3aWxsIGZhaWwgaWYgaXQgZG9lcyBu
b3QgaGF2ZSBhIHZhbGlkIE1BQyBhdCBhbGwpLg0KPiANCj4gUmV2aWV3ZWQtYnk6IExpbnVzIFdh
bGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogSGVjdG9y
IE1hcnRpbiA8bWFyY2FuQG1hcmNhbi5zdD4NCj4gU2lnbmVkLW9mZi1ieTogUnVzc2VsbCBLaW5n
IChPcmFjbGUpIDxybWsra2VybmVsQGFybWxpbnV4Lm9yZy51az4NCj4gLS0tDQo+ICAuLi4vYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Zpcm13YXJlLmMgICAgfCAzMSArKysrKysrKysrKysr
KysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNt
ODAyMTEvYnJjbWZtYWMvZmlybXdhcmUuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29t
L2JyY204MDIxMS9icmNtZm1hYy9maXJtd2FyZS5jDQo+IGluZGV4IDM3MWMwODZkMWY0OC4uYzEw
OWUyMGZjNWM2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9i
cmNtODAyMTEvYnJjbWZtYWMvZmlybXdhcmUuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZmlybXdhcmUuYw0KPiBAQCAtMjEsNiArMjEs
OCBAQA0KPiAgI2RlZmluZSBCUkNNRl9GV19OVlJBTV9ERVZQQVRIX0xFTgkJMTkJLyogZGV2cGF0
aDA9cGNpZS8xLzQvICovDQo+ICAjZGVmaW5lIEJSQ01GX0ZXX05WUkFNX1BDSUVERVZfTEVOCQkx
MAkvKiBwY2llLzEvNC8gKyBcMCAqLw0KPiAgI2RlZmluZSBCUkNNRl9GV19ERUZBVUxUX0JPQVJE
UkVWCQkiYm9hcmRyZXY9MHhmZiINCj4gKyNkZWZpbmUgQlJDTUZfRldfTUFDQUREUl9GTVQJCQki
bWFjYWRkcj0lcE0iDQo+ICsjZGVmaW5lIEJSQ01GX0ZXX01BQ0FERFJfTEVOCQkJKDcgKyBFVEhf
QUxFTiAqIDMpDQo+ICANCj4gIGVudW0gbnZyYW1fcGFyc2VyX3N0YXRlIHsNCj4gIAlJRExFLA0K
PiBAQCAtNTcsNiArNTksNyBAQCBzdHJ1Y3QgbnZyYW1fcGFyc2VyIHsNCj4gIAlib29sIG11bHRp
X2Rldl92MTsNCj4gIAlib29sIG11bHRpX2Rldl92MjsNCj4gIAlib29sIGJvYXJkcmV2X2ZvdW5k
Ow0KPiArCWJvb2wgc3RyaXBfbWFjOw0KDQogIENDIFtNXSAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Zpcm13YXJlLm8NCmRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9maXJtd2FyZS5jOjYzOiB3YXJuaW5nOiBG
dW5jdGlvbiBwYXJhbWV0ZXIgb3IgbWVtYmVyICdzdHJpcF9tYWMnIG5vdCBkZXNjcmliZWQgaW4g
J252cmFtX3BhcnNlcicNCg0KT3RoZXJ3aXNlIGxvb2tzIE9LIGFuZCB5b3UgY2FuIGFkZA0KDQpS
ZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KDQoNCj4g
IH07DQo+ICANCj4gIC8qDQo+IEBAIC0xMjEsNiArMTI0LDEwIEBAIHN0YXRpYyBlbnVtIG52cmFt
X3BhcnNlcl9zdGF0ZSBicmNtZl9udnJhbV9oYW5kbGVfa2V5KHN0cnVjdCBudnJhbV9wYXJzZXIg
Km52cCkNCj4gIAkJCW52cC0+bXVsdGlfZGV2X3YyID0gdHJ1ZTsNCj4gIAkJaWYgKHN0cm5jbXAo
Jm52cC0+ZGF0YVtudnAtPmVudHJ5XSwgImJvYXJkcmV2IiwgOCkgPT0gMCkNCj4gIAkJCW52cC0+
Ym9hcmRyZXZfZm91bmQgPSB0cnVlOw0KPiArCQkvKiBzdHJpcCBtYWNhZGRyIGlmIHBsYXRmb3Jt
IE1BQyBvdmVycmlkZXMgKi8NCj4gKwkJaWYgKG52cC0+c3RyaXBfbWFjICYmDQo+ICsJCSAgICBz
dHJuY21wKCZudnAtPmRhdGFbbnZwLT5lbnRyeV0sICJtYWNhZGRyIiwgNykgPT0gMCkNCj4gKwkJ
CXN0ID0gQ09NTUVOVDsNCj4gIAl9IGVsc2UgaWYgKCFpc19udnJhbV9jaGFyKGMpIHx8IGMgPT0g
JyAnKSB7DQo+ICAJCWJyY21mX2RiZyhJTkZPLCAid2FybmluZzogbG49JWQ6Y29sPSVkOiAnPScg
ZXhwZWN0ZWQsIHNraXAgaW52YWxpZCBrZXkgZW50cnlcbiIsDQo+ICAJCQkgIG52cC0+bGluZSwg
bnZwLT5jb2x1bW4pOw0KPiBAQCAtMjA5LDYgKzIxNiw3IEBAIHN0YXRpYyBpbnQgYnJjbWZfaW5p
dF9udnJhbV9wYXJzZXIoc3RydWN0IG52cmFtX3BhcnNlciAqbnZwLA0KPiAgCQlzaXplID0gZGF0
YV9sZW47DQo+ICAJLyogQWRkIHNwYWNlIGZvciBwcm9wZXJ0aWVzIHdlIG1heSBhZGQgKi8NCj4g
IAlzaXplICs9IHN0cmxlbihCUkNNRl9GV19ERUZBVUxUX0JPQVJEUkVWKSArIDE7DQo+ICsJc2l6
ZSArPSBCUkNNRl9GV19NQUNBRERSX0xFTiArIDE7DQo+ICAJLyogQWxsb2MgZm9yIGV4dHJhIDAg
Ynl0ZSArIHJvdW5kdXAgYnkgNCArIGxlbmd0aCBmaWVsZCAqLw0KPiAgCXNpemUgKz0gMSArIDMg
KyBzaXplb2YodTMyKTsNCj4gIAludnAtPm52cmFtID0ga3phbGxvYyhzaXplLCBHRlBfS0VSTkVM
KTsNCj4gQEAgLTM2OCwyMiArMzc2LDM3IEBAIHN0YXRpYyB2b2lkIGJyY21mX2Z3X2FkZF9kZWZh
dWx0cyhzdHJ1Y3QgbnZyYW1fcGFyc2VyICpudnApDQo+ICAJbnZwLT5udnJhbV9sZW4rKzsNCj4g
IH0NCj4gIA0KPiArc3RhdGljIHZvaWQgYnJjbWZfZndfYWRkX21hY2FkZHIoc3RydWN0IG52cmFt
X3BhcnNlciAqbnZwLCB1OCAqbWFjKQ0KPiArew0KPiArCWludCBsZW47DQo+ICsNCj4gKwlsZW4g
PSBzY25wcmludGYoJm52cC0+bnZyYW1bbnZwLT5udnJhbV9sZW5dLCBCUkNNRl9GV19NQUNBRERS
X0xFTiArIDEsDQo+ICsJCQlCUkNNRl9GV19NQUNBRERSX0ZNVCwgbWFjKTsNCj4gKwlXQVJOX09O
KGxlbiAhPSBCUkNNRl9GV19NQUNBRERSX0xFTik7DQo+ICsJbnZwLT5udnJhbV9sZW4gKz0gbGVu
ICsgMTsNCj4gK30NCj4gKw0KPiAgLyogYnJjbWZfbnZyYW1fc3RyaXAgOlRha2VzIGEgYnVmZmVy
IG9mICI8dmFyPj08dmFsdWU+XG4iIGxpbmVzIHJlYWQgZnJvbSBhIGZpbA0KPiAgICogYW5kIGVu
ZGluZyBpbiBhIE5VTC4gUmVtb3ZlcyBjYXJyaWFnZSByZXR1cm5zLCBlbXB0eSBsaW5lcywgY29t
bWVudCBsaW5lcywNCj4gICAqIGFuZCBjb252ZXJ0cyBuZXdsaW5lcyB0byBOVUxzLiBTaG9ydGVu
cyBidWZmZXIgYXMgbmVlZGVkIGFuZCBwYWRzIHdpdGggTlVMcy4NCj4gICAqIEVuZCBvZiBidWZm
ZXIgaXMgY29tcGxldGVkIHdpdGggdG9rZW4gaWRlbnRpZnlpbmcgbGVuZ3RoIG9mIGJ1ZmZlci4N
Cj4gICAqLw0KPiAgc3RhdGljIHZvaWQgKmJyY21mX2Z3X252cmFtX3N0cmlwKGNvbnN0IHU4ICpk
YXRhLCBzaXplX3QgZGF0YV9sZW4sDQo+IC0JCQkJICB1MzIgKm5ld19sZW5ndGgsIHUxNiBkb21h
aW5fbnIsIHUxNiBidXNfbnIpDQo+ICsJCQkJICB1MzIgKm5ld19sZW5ndGgsIHUxNiBkb21haW5f
bnIsIHUxNiBidXNfbnIsDQo+ICsJCQkJICBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICB7DQo+ICAJ
c3RydWN0IG52cmFtX3BhcnNlciBudnA7DQo+ICAJdTMyIHBhZDsNCj4gIAl1MzIgdG9rZW47DQo+
ICAJX19sZTMyIHRva2VuX2xlOw0KPiArCXU4IG1hY1tFVEhfQUxFTl07DQo+ICANCj4gIAlpZiAo
YnJjbWZfaW5pdF9udnJhbV9wYXJzZXIoJm52cCwgZGF0YSwgZGF0YV9sZW4pIDwgMCkNCj4gIAkJ
cmV0dXJuIE5VTEw7DQo+ICANCj4gKwlpZiAoZXRoX3BsYXRmb3JtX2dldF9tYWNfYWRkcmVzcyhk
ZXYsIG1hYykgPT0gMCkNCj4gKwkJbnZwLnN0cmlwX21hYyA9IHRydWU7DQo+ICsNCj4gIAl3aGls
ZSAobnZwLnBvcyA8IGRhdGFfbGVuKSB7DQo+ICAJCW52cC5zdGF0ZSA9IG52X3BhcnNlcl9zdGF0
ZXNbbnZwLnN0YXRlXSgmbnZwKTsNCj4gIAkJaWYgKG52cC5zdGF0ZSA9PSBFTkQpDQo+IEBAIC00
MDQsNiArNDI3LDkgQEAgc3RhdGljIHZvaWQgKmJyY21mX2Z3X252cmFtX3N0cmlwKGNvbnN0IHU4
ICpkYXRhLCBzaXplX3QgZGF0YV9sZW4sDQo+ICANCj4gIAlicmNtZl9md19hZGRfZGVmYXVsdHMo
Jm52cCk7DQo+ICANCj4gKwlpZiAobnZwLnN0cmlwX21hYykNCj4gKwkJYnJjbWZfZndfYWRkX21h
Y2FkZHIoJm52cCwgbWFjKTsNCj4gKw0KPiAgCXBhZCA9IG52cC5udnJhbV9sZW47DQo+ICAJKm5l
d19sZW5ndGggPSByb3VuZHVwKG52cC5udnJhbV9sZW4gKyAxLCA0KTsNCj4gIAl3aGlsZSAocGFk
ICE9ICpuZXdfbGVuZ3RoKSB7DQo+IEBAIC01MzgsNyArNTY0LDggQEAgc3RhdGljIGludCBicmNt
Zl9md19yZXF1ZXN0X252cmFtX2RvbmUoY29uc3Qgc3RydWN0IGZpcm13YXJlICpmdywgdm9pZCAq
Y3R4KQ0KPiAgCWlmIChkYXRhKQ0KPiAgCQludnJhbSA9IGJyY21mX2Z3X252cmFtX3N0cmlwKGRh
dGEsIGRhdGFfbGVuLCAmbnZyYW1fbGVuZ3RoLA0KPiAgCQkJCQkgICAgIGZ3Y3R4LT5yZXEtPmRv
bWFpbl9uciwNCj4gLQkJCQkJICAgICBmd2N0eC0+cmVxLT5idXNfbnIpOw0KPiArCQkJCQkgICAg
IGZ3Y3R4LT5yZXEtPmJ1c19uciwNCj4gKwkJCQkJICAgICBmd2N0eC0+ZGV2KTsNCj4gIA0KPiAg
CWlmIChmcmVlX2JjbTQ3eHhfbnZyYW0pDQo+ICAJCWJjbTQ3eHhfbnZyYW1fcmVsZWFzZV9jb250
ZW50cyhkYXRhKTsNCj4gLS0gDQo+IDIuMzAuMg0KPg==
