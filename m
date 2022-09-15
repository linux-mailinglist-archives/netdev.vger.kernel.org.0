Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A255B9EE9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiIOPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIOPea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:30 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2103.outbound.protection.outlook.com [40.107.21.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D043E57;
        Thu, 15 Sep 2022 08:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpCfx7zj/kCainUw7BYDJUZPzrpD28xZsSuJHrh5wD1626NAT+yG3cFylD3pLASkidlHrHpsormzSggvma9BvBye4LspQmCAcBZR/Y3QJvSrfqA3lcYm9lzv0wyMfPUwcgR/nbsTjMyk6zvYySPgPrKbgtswO3t8+LavvG59IsY/J/6I8EoBq1glNM0eL/vcZMzPIjpzBqQWsmb+H41Nw5PhnKR3CRzHAJyzpuQi8sT3oZYSIzEcjVc66JPVZzYankPT2saRBox5sI6m/E2XMQ0jaOfnXWtR01dAy+FGzQ48BCfsbN/7zNEiyvPhx7UELNOfx+2ztkBJ4xDYWvvqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUNG2IA/xugvGV4mQ3fdZ18U2UqA6FeBD6Chlirp+Vw=;
 b=PFL9lzvATelGaCACu/I0jiNidhCFbNt5fR1yUK5WMZ72wcw4y2MAJ5BuxiISWQ5kbsyO9qILCBxe70k8E3r2T267Xzo2WBUUTNgGeLvFAj6C7nLP6oj3c7/Pp6j9NmvGTefmdMlImSRACMd/ejrtrMoRo1LV6FD0/zbaoPKwKp3z9wtZb20XF6aFx3h9zKuelaanF5JH4Hmhv2RcrUNZsYKf0b27mr8smqpz2vjPMPSiHNTEQccWZBhaRYKrbI/BE7HIvp2cl5e8eqETrLMWNpcbVGNT6Zk/JGBejKktLHAW2Znju36S/sNP8fY5Oxwb7zoYnTJqaHDelbJGPeaUDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUNG2IA/xugvGV4mQ3fdZ18U2UqA6FeBD6Chlirp+Vw=;
 b=Yy9Q5oh+JaI35mr6I1WqxkCm3+Fq0ArRWUTZik9FfiK/shKQKxsOVlM9szT3G9k/v6lG9w1D4Kujod4X4Qm2barmHPnFSMBjRWQPJIaG3jvrSiZ6wQPSIV3+az4gIpKdIAOvZt7J4wzJU1RcuYwWl//UYXC79sMEfQGiFM0H8Ik=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:26 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:26 +0000
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
Subject: Re: [PATCH wireless-next v2 07/12] brcmfmac: pcie: Perform firmware
 selection for Apple platforms
Thread-Topic: [PATCH wireless-next v2 07/12] brcmfmac: pcie: Perform firmware
 selection for Apple platforms
Thread-Index: AQHYyRijSoo+S+4Mi0qJepHsVBcK9A==
Date:   Thu, 15 Sep 2022 15:34:26 +0000
Message-ID: <20220915153425.6ugzqhvhtr55v25w@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7s-0064vH-81@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7s-0064vH-81@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: 26f7c22a-82ec-427a-ae3c-08da972fc615
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Myja7zCeAxdZKNkzDS5Y3SSmFlLLHvy8wOE/oLbCzcONIQ+9DsDsKdTvwPePGaOSBylfRjLCFqQEhqIiihJ4ehyH01kD8YYloCvFHktvs/QGyOJ2XD7k7KseiD94bcrjAPgy8xtxG5v7hF/TBMzj78tnjc+chA3ZDc+ycbMmcSPDQcciCpZcdIDUHyI7zbhIqIBl3QCWgKgfqqYz9Itnovahaq4z3qh15zTZvYQeGugx/BF+pBZKgEO75EoPCOY7lpKq5TYCDOn8LNQlLmvzbOuJegtvw1GeR8khjQC1FtmMIkSCcT3fJlb/vozQDwOLWxw+Eho8sejCBj92zUUxcrsZLN58Gn+zBG+7JYbL+aJ0c209N2eby0GjviiLh/nLGBhvdWn2dTRg/UoG8q4to2tydVK1zujdLn/4jfVfsTSmCPte/29wB7JY9OrZdqBrja5UHUl4YPUtrSFJfJOep9S6QpFCMle3XVqXwHf99wYvErVeTnJvIQJbCN2tgVtzb1E56QyCsv7klcPkx+7ecYFDTZ6/ZHpYqtJ47La24isLZ3nr2G965H+yLuel/mvnc0fDs0BUhS8J3zZnHD6/cfRKm2YxlNpLvPmIPSOguh/0oz8Aabt92aa6A6bcig+dui+/En/WrjtevihVE7NtfvxrILNpZ5VCIgEVBRSzjnFbeQ6tPW3YVyYBwe2MdEnXqsDtGfP983l1o5BPdYSkJg9kFa2RRnE9JImOJEZUvE4jqw3wq9lsMNAIo+3DtH2f3qV1gWiUNqKgosM4EYAMyvtcNK1zu4Fp1/gdZtA1lhw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(47660400002)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(19627235002)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(66574015)(38070700005)(85182001)(83380400001)(26005)(478600001)(7416002)(186003)(46800400005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmNCMXZlcFB4KzU3MEYvQlc0R0NLS29JalNoQ0VLVG8vYllvclk3Q1RWNmR1?=
 =?utf-8?B?Q1prTjZyaUY1NnhUbGNxakg2TTdLY2ZEUG9IbTJWNGxXaWVBKy9Eb0FjMFJB?=
 =?utf-8?B?aGJma0F4V0lBdnpFME50QnF1M2EwbFZmYTBJdGpLRTZDTDZ5dk04Vkdnem43?=
 =?utf-8?B?cEtiUjM5c2gxMTF4ZXpsdmRDcGtBT1lFa0FWRUFtK2FJUHdXQzIvb3Z3RGZ0?=
 =?utf-8?B?UEd6L1VyVEpCMU9VYW1NMjU4NTB6OFFSeThCTDRFRkVSSUV1WHNiRHFHTFV1?=
 =?utf-8?B?R2pOTDdvaXhwa0l1eE1zd29GbGZoWXlDUlFsK2ZHSGo5MU1McFg2b254Sm5X?=
 =?utf-8?B?OThCcUFrUG12UWRsSmxGTGoxMkg1azFjZXBWV1Bxb3lTbTVGUUlhKzQ2aWdE?=
 =?utf-8?B?K1BCcVM0Rlg3Um1pY1NnN1hLeEFYVWZ3UngvQlk1UURkcUtaQ0ZpMlk5RFYz?=
 =?utf-8?B?Vlo2UDkzVVlnVWh0a2J6TVI2ZVc1N3AySXpvem05Z3kwdEhWSk8xNkdOUWdr?=
 =?utf-8?B?cVRNSGFQNU1TRXU3eGI4SGYrakQzclphU1RDTVNrRCtFK1c4OG5MbGx4UnIx?=
 =?utf-8?B?N2dvU3UwVElxQUVYS2tnZkpibHovN0F6SGQwTUlscVYxMEJDNnpRb2dXS1ht?=
 =?utf-8?B?UGxmRTdIcC9hT2xjWVN3SS8rRW1GQllCUWVwdVB4NUwyWStIUUhQdmZSMUZ2?=
 =?utf-8?B?enpBMnZFNTA2Und3eTJpcUhsaDlHNjZEUlVzcUZBQVo3bkhYZVBMekl0bXZt?=
 =?utf-8?B?MmcrQ2Z2Z3VJeWFDT3BXRFlJNUozb2ZqSFBCN1Y2T2JGcHJkZG1QNWlFR2lE?=
 =?utf-8?B?WXRjRG9jdWYyb0QrUjNadmpGZkJKMjVVY1FYelErVisyU08xV3h2Uk50My9s?=
 =?utf-8?B?UEdyUWhHWFJjQXlFOHQyRENENlBIS2ZCMTQzREhqQTcweHJkanRod0dXZmdw?=
 =?utf-8?B?czlzMGt2U1FZTitCMkZqNmhzZEp4NEpDQ3U3Q2NpU2RwR1c5YzFiMHlvZ3pD?=
 =?utf-8?B?dzhVekxESEwwK21BMFJWc0xHVllqU01BeUZYVSt4Q0dPNElaWDI0ZUU0M09s?=
 =?utf-8?B?Njl1cUV0aUt3YWpuTDJ0QVY2TzdNN1d4MDR6MVJDYkt5WVRJV2k4QXA3UWRa?=
 =?utf-8?B?WjVMQmM2L29oZTJid2JWNlRpMFFQTFlrYnVQemtEL2IyaHdIYzA3Vm16ZUhM?=
 =?utf-8?B?dlgybW1BS1c1OHdLenE0NlhtcHpZK01Hb2U3VHVjQnRYa1VjVmFIMDN2TEwz?=
 =?utf-8?B?NmtNQUVFT014S1dJNHJISUs3STRkRGhhaUlqelhRVFdzTHFqUEIvdHNqWS9T?=
 =?utf-8?B?c0MzK1hCYVRoQ3ZmVzJTOFRqbVROd2JMeEJCZzhsa0JhbGUrVHI4RU9PZXhs?=
 =?utf-8?B?YVR1NHJaaFYrU1owOU9WSER6NFZjN3grNm5ZbUlYRUo3a3hFSW5tUFFQSUJk?=
 =?utf-8?B?V05sWVczWXoycHRFUE5qa2o4REFxdWV3eTc5NUdLS3BkRC9ZZ1ZjM00wenV6?=
 =?utf-8?B?WXZmakxDY2FQRmVRTkw0VENsOG9PUEVtZ0tvZW40NENhWEE4Y29Mc3k0dThm?=
 =?utf-8?B?eklwUTFFeWJ3YkRtZmhSMzdRYzNLdDNBVjREY2c2a0NoNEZBVzBQNm41YjlV?=
 =?utf-8?B?eXFGODEzcjk3R0xNTmxTeDF5Nk5FYXNpQ2M3TzBaMXQwMG1IQk1oS1gzeXN1?=
 =?utf-8?B?ejRZdDEzSlFudmV6a1ZLRTBOMFBFejVteHdIN0hNTzdZUjZzYlQ0c0xnZjNV?=
 =?utf-8?B?b1NjZGt4TzB2MENtSng0ZWQ3MW1kUFRXOFF1b3p1eEZEOTZObVAvaERRd2Qz?=
 =?utf-8?B?UXd6SkZURVA0ZEEwSGx3emhESCtYeUdVNEhJYU15RXVVaDNPcCs3eG5TdHQx?=
 =?utf-8?B?b0tSRXNRb0ZDbWFZajQzMHBxd3pNV2hBYTRkUEVmVDNxd3M1akx4bTI0KzVK?=
 =?utf-8?B?d3ZMbWJ2aGZOcGM3bVFnTENlbXl6Vk1UdFZHOXdCYXIxVnhPZEJPYjRhTklv?=
 =?utf-8?B?Nnl5cStlSWhjRng4aDZXM0RRaHV2MUkrUTI5aUwvcElhellBSFF4aFRlZzc5?=
 =?utf-8?B?YmZsNlJGY25rbzZLcHdNUTVWeCs3d1BpRTNiZkQrc08ydytvZTRjRUdBNVpF?=
 =?utf-8?Q?IuR9DSkH6ovM0+8CxR2kd+rbS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C033F9E2103019438B1A0AA56455784A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f7c22a-82ec-427a-ae3c-08da972fc615
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:26.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udv7568rAyratSgkqWRnVb1Hh7ieWD1fy56RrLgtpAyqC1roajtGeX84Sh925S+H9ieq8Gyy5qCuypM6MiTgMg==
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

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTM6MTJBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gT24g
QXBwbGUgcGxhdGZvcm1zLCBmaXJtd2FyZSBzZWxlY3Rpb24gdXNlcyB0aGUgZm9sbG93aW5nIGVs
ZW1lbnRzOg0KPiANCj4gICBQcm9wZXJ0eSAgICAgICAgIEV4YW1wbGUgICBTb3VyY2UNCj4gICA9
PT09PT09PT09PT09PSAgID09PT09PT0gICA9PT09PT09PT09PT09PT09PT09PT09PT0NCj4gKiBD
aGlwIG5hbWUgICAgICAgIDQzNzggICAgICBEZXZpY2UgSUQNCj4gKiBDaGlwIHJldmlzaW9uICAg
IEIxICAgICAgICBPVFANCj4gKiBQbGF0Zm9ybSAgICAgICAgIHNoaWtva3UgICBEVCAoQVJNNjQp
IG9yIEFDUEkgKHg4NikNCj4gKiBNb2R1bGUgdHlwZSAgICAgIFJBU1AgICAgICBPVFANCj4gKiBN
b2R1bGUgdmVuZG9yICAgIG0gICAgICAgICBPVFANCj4gKiBNb2R1bGUgdmVyc2lvbiAgIDYuMTEg
ICAgICBPVFANCj4gKiBBbnRlbm5hIFNLVSAgICAgIFgzICAgICAgICBEVCAoQVJNNjQpIG9yIEFD
UEkgKHg4NikNCj4gDQo+IEluIG1hY09TLCB0aGVzZSBmaXJtd2FyZXMgYXJlIHN0b3JlZCB1c2lu
ZyBmaWxlbmFtZXMgaW4gdGhpcyBmb3JtYXQNCj4gdW5kZXIgL3Vzci9zaGFyZS9maXJtd2FyZS93
aWZpOg0KPiANCj4gICAgIEMtNDM3OF9fcy1CMS9QLXNoaWtva3UtWDNfTS1SQVNQX1YtbV9fbS02
LjExLnR4dA0KPiANCj4gVG8gcHJlcGFyZSBmaXJtd2FyZXMgZm9yIExpbnV4LCB3ZSByZW5hbWUg
dGhlc2UgdG8gYSBzY2hlbWUgZm9sbG93aW5nDQo+IHRoZSBleGlzdGluZyBicmNtZm1hYyBjb252
ZW50aW9uOg0KPiANCj4gICAgIGJyY21mbWFjPGNoaXA+PGxvd2VyKHJldik+LXBjaWUuYXBwbGUs
PHBsYXRmb3JtPi08bW9kX3R5cGU+LVwNCj4gCTxtb2RfdmVuZG9yPi08bW9kX3ZlcnNpb24+LTxh
bnRlbm5hX3NrdT4udHh0DQo+IA0KPiBUaGUgTlZSQU0gdXNlcyBhbGwgdGhlIGNvbXBvbmVudHMs
IHdoaWxlIHRoZSBmaXJtd2FyZSBhbmQgQ0xNIGJsb2Igb25seQ0KPiB1c2UgdGhlIGNoaXAvcmV2
aXNpb24vcGxhdGZvcm0vYW50ZW5uYV9za3U6DQo+IA0KPiAgICAgYnJjbWZtYWM8Y2hpcD48bG93
ZXIocmV2KT4tcGNpZS5hcHBsZSw8cGxhdGZvcm0+LTxhbnRlbm5hX3NrdT4uYmluDQo+IA0KPiBl
LmcuDQo+IA0KPiAgICAgYnJjbS9icmNtZm1hYzQzNzhiMS1wY2llLmFwcGxlLHNoaWtva3UtUkFT
UC1tLTYuMTEtWDMudHh0DQo+ICAgICBicmNtL2JyY21mbWFjNDM3OGIxLXBjaWUuYXBwbGUsc2hp
a29rdS1YMy5iaW4NCj4gDQo+IEluIGFkZGl0aW9uLCBzaW5jZSB0aGVyZSBhcmUgb3ZlciAxMDAw
IGZpbGVzIGluIHRvdGFsLCBtYW55IG9mIHdoaWNoIGFyZQ0KPiBzeW1saW5rcyBvciBvdXRyaWdo
dCBkdXBsaWNhdGVzLCB3ZSBkZWR1cGxpY2F0ZSBhbmQgcHJ1bmUgdGhlIGZpcm13YXJlDQo+IHRy
ZWUgdG8gcmVkdWNlIGZpcm13YXJlIGZpbGVuYW1lcyB0byBmZXdlciBkaW1lbnNpb25zLiBGb3Ig
ZXhhbXBsZSwgdGhlDQo+IHNoaWtva3UgcGxhdGZvcm0gKE1hY0Jvb2sgQWlyIE0xIDIwMjApIHNp
bXBsaWZpZXMgdG8ganVzdCA0IGZpbGVzOg0KPiANCj4gICAgIGJyY20vYnJjbWZtYWM0Mzc4YjEt
cGNpZS5hcHBsZSxzaGlrb2t1LmNsbV9ibG9iDQo+ICAgICBicmNtL2JyY21mbWFjNDM3OGIxLXBj
aWUuYXBwbGUsc2hpa29rdS5iaW4NCj4gICAgIGJyY20vYnJjbWZtYWM0Mzc4YjEtcGNpZS5hcHBs
ZSxzaGlrb2t1LVJBU1AtbS50eHQNCj4gICAgIGJyY20vYnJjbWZtYWM0Mzc4YjEtcGNpZS5hcHBs
ZSxzaGlrb2t1LVJBU1AtdS50eHQNCj4gDQo+IFRoaXMgcmVkdWNlcyB0aGUgdG90YWwgZmlsZSBj
b3VudCB0byBhcm91bmQgMTcwLCBvZiB3aGljaCA3NSBhcmUNCj4gc3ltbGlua3MgYW5kIDk1IGFy
ZSByZWd1bGFyIGZpbGVzOiA3IGZpcm13YXJlIGJsb2JzLCAyNyBDTE0gYmxvYnMsIGFuZA0KPiA2
MSBOVlJBTSBjb25maWcgZmlsZXMuIFdlIGFsc28gc2xpZ2h0bHkgcHJvY2VzcyBOVlJBTSBmaWxl
cyB0byBjb3JyZWN0DQo+IHNvbWUgZm9ybWF0dGluZyBpc3N1ZXMuDQo+IA0KPiBUbyBoYW5kbGUg
dGhpcywgdGhlIGRyaXZlciBtdXN0IHRyeSB0aGUgZm9sbG93aW5nIHBhdGggZm9ybWF0cyB3aGVu
DQo+IGxvb2tpbmcgZm9yIGZpcm13YXJlIGZpbGVzOg0KPiANCj4gICAgIGJyY20vYnJjbWZtYWM0
Mzc4YjEtcGNpZS5hcHBsZSxzaGlrb2t1LVJBU1AtbS02LjExLVgzLnR4dA0KPiAgICAgYnJjbS9i
cmNtZm1hYzQzNzhiMS1wY2llLmFwcGxlLHNoaWtva3UtUkFTUC1tLTYuMTEudHh0DQo+ICAgICBi
cmNtL2JyY21mbWFjNDM3OGIxLXBjaWUuYXBwbGUsc2hpa29rdS1SQVNQLW0udHh0DQo+ICAgICBi
cmNtL2JyY21mbWFjNDM3OGIxLXBjaWUuYXBwbGUsc2hpa29rdS1SQVNQLnR4dA0KPiAgICAgYnJj
bS9icmNtZm1hYzQzNzhiMS1wY2llLmFwcGxlLHNoaWtva3UtWDMudHh0ICoNCj4gICAgIGJyY20v
YnJjbWZtYWM0Mzc4YjEtcGNpZS5hcHBsZSxzaGlrb2t1LnR4dA0KPiANCj4gKiBOb3QgcmVsZXZh
bnQgZm9yIE5WUkFNLCBvbmx5IGZvciBmaXJtd2FyZS9DTE0uDQo+IA0KPiBUaGUgY2hpcCByZXZp
c2lvbiBub21pbmFsbHkgY29tZXMgZnJvbSBPVFAgb24gQXBwbGUgcGxhdGZvcm1zLCBidXQgaXQN
Cj4gY2FuIGJlIG1hcHBlZCB0byB0aGUgUENJIHJldmlzaW9uIG51bWJlciwgc28gd2UgaWdub3Jl
IHRoZSBPVFAgcmV2aXNpb24NCj4gYW5kIGNvbnRpbnVlIHRvIHVzZSB0aGUgZXhpc3RpbmcgUENJ
IHJldmlzaW9uIG1lY2hhbmlzbSB0byBpZGVudGlmeSBjaGlwDQo+IHJldmlzaW9ucywgYXMgdGhl
IGRyaXZlciBhbHJlYWR5IGRvZXMgZm9yIG90aGVyIGNoaXBzLiBVbmZvcnR1bmF0ZWx5LA0KPiB0
aGUgbWFwcGluZyBpcyBub3QgY29uc2lzdGVudCBiZXR3ZWVuIGRpZmZlcmVudCBjaGlwIHR5cGVz
LCBzbyB0aGlzIGhhcw0KPiB0byBiZSBkZXRlcm1pbmVkIGV4cGVyaW1lbnRhbGx5Lg0KPiANCj4g
UmV2aWV3ZWQtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4g
U2lnbmVkLW9mZi1ieTogSGVjdG9yIE1hcnRpbiA8bWFyY2FuQG1hcmNhbi5zdD4NCj4gU2lnbmVk
LW9mZi1ieTogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxybWsra2VybmVsQGFybWxpbnV4Lm9yZy51
az4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZz
ZW4uZGs+DQoNCj4gIC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jICAgICAg
ICB8IDQxICsrKysrKysrKysrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzOSBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9wY2llLmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQo+IGluZGV4IDc2Y2E4
MzUzNzhiYi4uM2ZiNTkwYTZlMDNiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9wY2llLmMNCj4gQEAgLTIwNjgs
OCArMjA2OCw0NSBAQCBicmNtZl9wY2llX3ByZXBhcmVfZndfcmVxdWVzdChzdHJ1Y3QgYnJjbWZf
cGNpZWRldl9pbmZvICpkZXZpbmZvKQ0KPiAgCWZ3cmVxLT5kb21haW5fbnIgPSBwY2lfZG9tYWlu
X25yKGRldmluZm8tPnBkZXYtPmJ1cykgKyAxOw0KPiAgCWZ3cmVxLT5idXNfbnIgPSBkZXZpbmZv
LT5wZGV2LT5idXMtPm51bWJlcjsNCj4gIA0KPiAtCWJyY21mX2RiZyhQQ0lFLCAiQm9hcmQ6ICVz
XG4iLCBkZXZpbmZvLT5zZXR0aW5ncy0+Ym9hcmRfdHlwZSk7DQo+IC0JZndyZXEtPmJvYXJkX3R5
cGVzWzBdID0gZGV2aW5mby0+c2V0dGluZ3MtPmJvYXJkX3R5cGU7DQo+ICsJLyogQXBwbGUgcGxh
dGZvcm1zIHdpdGggZmFuY3kgZmlybXdhcmUvTlZSQU0gc2VsZWN0aW9uICovDQo+ICsJaWYgKGRl
dmluZm8tPnNldHRpbmdzLT5ib2FyZF90eXBlICYmDQo+ICsJICAgIGRldmluZm8tPnNldHRpbmdz
LT5hbnRlbm5hX3NrdSAmJg0KPiArCSAgICBkZXZpbmZvLT5vdHAudmFsaWQpIHsNCj4gKwkJY29u
c3Qgc3RydWN0IGJyY21mX290cF9wYXJhbXMgKm90cCA9ICZkZXZpbmZvLT5vdHA7DQo+ICsJCXN0
cnVjdCBkZXZpY2UgKmRldiA9ICZkZXZpbmZvLT5wZGV2LT5kZXY7DQo+ICsJCWNvbnN0IGNoYXIg
KipidCA9IGZ3cmVxLT5ib2FyZF90eXBlczsNCj4gKw0KPiArCQlicmNtZl9kYmcoUENJRSwgIkFw
cGxlIGJvYXJkOiAlc1xuIiwNCj4gKwkJCSAgZGV2aW5mby0+c2V0dGluZ3MtPmJvYXJkX3R5cGUp
Ow0KPiArDQo+ICsJCS8qIEV4YW1wbGU6IGFwcGxlLHNoaWtva3UtUkFTUC1tLTYuMTEtWDMgKi8N
Cj4gKwkJYnRbMF0gPSBkZXZtX2thc3ByaW50ZihkZXYsIEdGUF9LRVJORUwsICIlcy0lcy0lcy0l
cy0lcyIsDQo+ICsJCQkJICAgICAgIGRldmluZm8tPnNldHRpbmdzLT5ib2FyZF90eXBlLA0KPiAr
CQkJCSAgICAgICBvdHAtPm1vZHVsZSwgb3RwLT52ZW5kb3IsIG90cC0+dmVyc2lvbiwNCj4gKwkJ
CQkgICAgICAgZGV2aW5mby0+c2V0dGluZ3MtPmFudGVubmFfc2t1KTsNCj4gKwkJYnRbMV0gPSBk
ZXZtX2thc3ByaW50ZihkZXYsIEdGUF9LRVJORUwsICIlcy0lcy0lcy0lcyIsDQo+ICsJCQkJICAg
ICAgIGRldmluZm8tPnNldHRpbmdzLT5ib2FyZF90eXBlLA0KPiArCQkJCSAgICAgICBvdHAtPm1v
ZHVsZSwgb3RwLT52ZW5kb3IsIG90cC0+dmVyc2lvbik7DQo+ICsJCWJ0WzJdID0gZGV2bV9rYXNw
cmludGYoZGV2LCBHRlBfS0VSTkVMLCAiJXMtJXMtJXMiLA0KPiArCQkJCSAgICAgICBkZXZpbmZv
LT5zZXR0aW5ncy0+Ym9hcmRfdHlwZSwNCj4gKwkJCQkgICAgICAgb3RwLT5tb2R1bGUsIG90cC0+
dmVuZG9yKTsNCj4gKwkJYnRbM10gPSBkZXZtX2thc3ByaW50ZihkZXYsIEdGUF9LRVJORUwsICIl
cy0lcyIsDQo+ICsJCQkJICAgICAgIGRldmluZm8tPnNldHRpbmdzLT5ib2FyZF90eXBlLA0KPiAr
CQkJCSAgICAgICBvdHAtPm1vZHVsZSk7DQo+ICsJCWJ0WzRdID0gZGV2bV9rYXNwcmludGYoZGV2
LCBHRlBfS0VSTkVMLCAiJXMtJXMiLA0KPiArCQkJCSAgICAgICBkZXZpbmZvLT5zZXR0aW5ncy0+
Ym9hcmRfdHlwZSwNCj4gKwkJCQkgICAgICAgZGV2aW5mby0+c2V0dGluZ3MtPmFudGVubmFfc2t1
KTsNCj4gKwkJYnRbNV0gPSBkZXZpbmZvLT5zZXR0aW5ncy0+Ym9hcmRfdHlwZTsNCj4gKw0KPiAr
CQlpZiAoIWJ0WzBdIHx8ICFidFsxXSB8fCAhYnRbMl0gfHwgIWJ0WzNdIHx8ICFidFs0XSkgew0K
PiArCQkJa2ZyZWUoZndyZXEpOw0KPiArCQkJcmV0dXJuIE5VTEw7DQo+ICsJCX0NCj4gKw0KDQpT
cHVyaW91cyBuZXdsaW5lPw0KDQo+ICsJfSBlbHNlIHsNCj4gKwkJYnJjbWZfZGJnKFBDSUUsICJC
b2FyZDogJXNcbiIsIGRldmluZm8tPnNldHRpbmdzLT5ib2FyZF90eXBlKTsNCj4gKwkJZndyZXEt
PmJvYXJkX3R5cGVzWzBdID0gZGV2aW5mby0+c2V0dGluZ3MtPmJvYXJkX3R5cGU7DQo+ICsJfQ0K
PiAgDQo+ICAJcmV0dXJuIGZ3cmVxOw0KPiAgfQ0KPiAtLSANCj4gMi4zMC4yDQo+
