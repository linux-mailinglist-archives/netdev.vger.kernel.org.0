Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494DB6C3C50
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCUU4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCUU4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:56:16 -0400
X-Greylist: delayed 619 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Mar 2023 13:56:14 PDT
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1515.securemx.jp [210.130.202.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE90559CD;
        Tue, 21 Mar 2023 13:56:13 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1515) id 32LKjvWb017714; Wed, 22 Mar 2023 05:45:57 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 32LKjrLV008820; Wed, 22 Mar 2023 05:45:53 +0900
X-Iguazu-Qid: 34ts1GHAcSbOPb04Lg
X-Iguazu-QSIG: v=2; s=0; t=1679431552; q=34ts1GHAcSbOPb04Lg; m=GJopkDKijqoVPhJhiecY9/bplHLiUtq4QrVQvMOuMWQ=
Received: from imx12-a.toshiba.co.jp ([38.106.60.135])
        by relay.securemx.jp (mx-mr1510) id 32LKjpk0005876
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Mar 2023 05:45:51 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGNzF5WovWUCswR3OcHbkuTQKsNIeHbbJpeA8SMAxF3UQ6NlCgo+HKwA6bmGB+gLxnT5B4V7nxxE4ReZZB/7S+EmK+Rm1VPT5I1bN1ZXvDSHGQu0ve27noX4fX9HDrsbDZ/yf+ywrXHZjo0GmTBsGfWAeiKuEvAeye4ETeTTdvvAfC94fqVl+WoKCBFowAVDGx3+YT0I8NBI8dP/fFoeiD05OuVB2GaAJwgeaRAlCb2M5s0GtE/Nb/Hs9GXPO9+xgttOscVvFMZyUpaT3MPVktDszLd8OTuH5wVrF+4wKjqmgdJMqS/fTGLpF7uwIa9bH9i4gTMwrYPIGdsfgFcPHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqdLyfDjlF9bae7VUQ6KFS5BcRkdAW5ZDzdiRh1pUK0=;
 b=ZBvjKS/38PNLs+QlDylA9mD4FqFCknM5v7JXp0tVCMN0ffVqyC8twV/6ZVb4ryfdcT+yeTHPREit4DnxBzmQ8Q0LNXcVXX345q6CSKii5V54iM+KKj+LoPVYqaa51sQr6HLYEguB/5KVR6+J6zpQOEz/zexNvQXgZyQ4aUJF/7IqK9R5ABwDXmX8CQNDejjI8JK0XcV2/pLqqlRfN0TnpMjWTlDOZ20T0L4uHxoQ3FV2FraDWgeIWmNF9xFgDEg7lNtWNVhe9yq168Q/VtvE5x0NsIexsA2SnlrEABQwRMej+3EiEgzywvVZFoXbwW22yRptew3VhzTat/86euZ4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <robh@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <afaerber@suse.de>,
        <mani@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
        <samuel@sholland.org>, <neil.armstrong@linaro.org>,
        <khilman@baylibre.com>, <jbrunet@baylibre.com>,
        <martin.blumenstingl@googlemail.com>, <joel@jms.id.au>,
        <andrew@aj.id.au>, <rafal@milecki.pl>,
        <bcm-kernel-feedback-list@broadcom.com>, <f.fainelli@gmail.com>,
        <appana.durga.rao@xilinx.com>, <naga.sureshkumar.relli@xilinx.com>,
        <wg@grandegger.com>, <mkl@pengutronix.de>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>, <olteanv@gmail.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <tobias@waldekranz.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <heiko@sntech.de>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <richardcochran@gmail.com>,
        <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>
CC:     <krzysztof.kozlowski@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-actions@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-sunxi@lists.linux.dev>,
        <linux-amlogic@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-can@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v2] dt-bindings: net: Drop unneeded quotes
Thread-Topic: [PATCH v2] dt-bindings: net: Drop unneeded quotes
Thread-Index: AQHZW4UUv62gNfnH206QhJKcONRYbq8FtEnw
Date:   Tue, 21 Mar 2023 20:45:48 +0000
X-TSB-HOP2: ON
Message-ID: <TYWPR01MB9420194A9C7EA41A70CF8DA892819@TYWPR01MB9420.jpnprd01.prod.outlook.com>
References: <20230320233758.2918972-1-robh@kernel.org>
In-Reply-To: <20230320233758.2918972-1-robh@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toshiba.co.jp;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB9420:EE_|OS7PR01MB12044:EE_
x-ms-office365-filtering-correlation-id: 96ba23e0-473b-4755-b5be-08db2a4d4031
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z1ZwMtYkY7bz8w0l6jU6Bj/ja6M1dAVRNbWM69ZJ3N+xwokw62f+kv8jPMQrgaAsEJkXwAZ5meHpTL5NXscFQGu7KRHT78on2swFnp7MilUAVn4sNEUu/xGg2FrhqdezANXc/dtyohbuW/OAR97cmkpaA5zGPFeLfQRyV0lKoOSNVACixqvtoJ3KzjwrxhWwdd6TD+Pu1u8easABBDK01aJ70006hhQx+dKReDdINFXI0PzOXjpgMs/UzVM4ZDIzt9j4omyOyBa1oBScNmowE35bK8Pm8isavEJeV4jrYoEtLYTzMHpghm83NOLVYpW4buHq9U1Zyi1MRLhUAjzgMDtT2iGX70rrV0KJXB3SiurxJq8pCYDapAiDxqCi81xOTcoWKvpHyyMVrWwjFouEWZ45kXO2kKv69++DRaO0iWZe0WgVhpTOpT0LiF3O1OFaN49ZBZ017v5r+154HZG0MxCXu0aXoks7sZrvDhQHDPBa54t0np1qVBGpvon/TG27o5Z3OU26KCQtTPuFX+i/UxOOwgLLf9+TUgCLEoaS+nFR+NiBu/CTOXW4eg9BbzGVx9r41wigVXCwisIW/D2YafkBdlvf6g7p0PS9h+UR4CmM+znSK+BQIHRRrRCl++Mh/gjUyS/P3n3UeElM3IcjTadHoqb47Jx98z1QcdWitBvyu4nSEINrJQi4qF0eOIElp+9IqPZevt4xtd5zyVrWLT9GHntzyMjutQZuqDkyntg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB9420.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(52536014)(8936002)(5660300002)(7366002)(41300700001)(7416002)(7406005)(921005)(55016003)(33656002)(86362001)(38100700002)(122000001)(38070700005)(2906002)(4326008)(83380400001)(478600001)(6506007)(7696005)(9686003)(71200400001)(186003)(26005)(53546011)(55236004)(54906003)(110136005)(316002)(8676002)(66946007)(76116006)(64756008)(66446008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0U2TjV3azNvLzYrZnpiMDBuWS90bWFtV2cvUTlWb1BRTXhLR0FITEdaQTZG?=
 =?utf-8?B?TFA5K3NaT2tXYXI5U2xROHF3dFdSRWFxNWY2NUtncFhhSmhmOXJ5VU9YblpD?=
 =?utf-8?B?WE5DNW5jQzVZcDVwbnc2UjdiMVBmT1ZvTGRHQ3h4OXBmYXM2MFBsS0lzRlh5?=
 =?utf-8?B?MllWWmhWQ09XUVZnckwxVUR3WmowRUlZS21iZStnSFMvakZFaTk4aVdudUNx?=
 =?utf-8?B?bUgvVjR1OCtkUUFoYXlBKzMrN3JUREZaR3VyMUkwUmxNVGw5SWIzWkhONlhK?=
 =?utf-8?B?OGozcUk1ZTJ4OVMxZmxTN1NiNlJGSTZnZk02bkdyb01RY3J0Zm91VnptUnc4?=
 =?utf-8?B?VExraTE1SmVJU1k0NFFFWHFZOGNVRm16RXR4REc5MVNXUmpBMEZXN2dCRlR1?=
 =?utf-8?B?VXVydkx1NTE3U05qYmQ4V25tWHRaaEF1QnppQ2FXcDlwaGUwOTVlTE9IZmpQ?=
 =?utf-8?B?YUJSSlBZOFlsR3FaSTlDNXNneS9yOEVSS29pNkErU3hxOWpIeS9MQ3RXNGND?=
 =?utf-8?B?SUVxTmZWV3JJMUhrRi90WXJLclU0TVZsU2RkWm5aaVFad08wN2FrclJSbGtM?=
 =?utf-8?B?a1Y5dXR2YmRZd0RDZ2xUWjhVclNTemFOWE95WS9uYXhkTFF4QVpiMFVjamhV?=
 =?utf-8?B?eHUwdzQ0b0JMUlJZcFQ3eWZKdU9TdS9QdHVpWVM0U09TUkpTbzZZaFA1RHBz?=
 =?utf-8?B?OGtZelFlaG92U2lmM2sxQ3dOT3Jka0E3SmRDVGFZRzJaZHFRNmphU1c1T3hh?=
 =?utf-8?B?d1FBOGRvZHFMUXZsTlhTNlVBaWFIZjIzVkw1TlQxeWJVRXBnbHN6MlVaMGti?=
 =?utf-8?B?MHczNkJ3ZVJ4RE1mYkZpRlNMeEw2emt4QjFScGo3ZUZHVS9GUWdCeE00SGxv?=
 =?utf-8?B?YkFUd2wyS2R0TXZLUnFoU3lZcHhmbEJvVlZVMHhpdkwxdHVVOUpUSXJkcFpN?=
 =?utf-8?B?cHdHeWY5dGlZNU91ZnhoUnZNY2VWekM5VXhValpzQVo5ZWh5bWhGWFNwZ3JT?=
 =?utf-8?B?b3YyQlZlZk9EQ0J1MWVFR01yT2dtNnBmNTR2VXNqRWlUUTBlcHVjODUranNX?=
 =?utf-8?B?NzJINU1uN2FqdGJCaXZWYU9rQTloOVZyWmtkZ3NwVGZ4aVhmV0x5MmFldmQv?=
 =?utf-8?B?V1VucHRRNWV2N0ZUOG5rUnBkQmJzOEQyaFUzM1JKNzR0R05Hek4xK21KbFdZ?=
 =?utf-8?B?eSt3enQzUTVSenIrRXVtTHNoT3NEOVFoS0pXcXN1MzFZVnJlVVdUSG1UYmZ4?=
 =?utf-8?B?cDVIRS9UemtHSExoaWlWN0xWZ2czNENxNmZweDVvUFZVVUNOUVl5UHNwWlBi?=
 =?utf-8?B?V3BabUNNNFpjMEZRQW5KQmVSV29yZnlYcEt1d0kwczVCV2lpRFJ0RHlIazI4?=
 =?utf-8?B?RlQrVkFrMmM0NVhHSnQwdm92OE9GYndvY2VBYTl0aDJNcTgvN29iWElFNDZv?=
 =?utf-8?B?MmhQMXVLbTF3eC9uY3JWeWhjNVpoWXYyWlNiM0hOY1dLVHc5Si9HNHQ1YXJE?=
 =?utf-8?B?OXN2YW9QL0xTSFRpTlk4VXJkb1VSRndSZC94bVczRHJ0dU15cGpob2t5c0dw?=
 =?utf-8?B?OUJkMmdIQjJJWWdtOGJZU01FYUtxbHE4YzdFRERiWnJuWjZISzJWdXhRTlh2?=
 =?utf-8?B?elY1ci80N3cwSmJZUlRqWXF1Qk41dWZ4TWcxTTZnQnNoMDV1czkyTGVZMjRE?=
 =?utf-8?B?VTNHUHdZMkxoRldrT21kRjhwZFM5UDAxNjBraG84VmF5a0FjVU9CaDJlK2hw?=
 =?utf-8?B?aC84VVVIRDY5Qk1BU21XSUN2OWk4TTFBUVNxenJFTG9yeDVhQmtrV1F4eUFP?=
 =?utf-8?B?eDAwU05KN2craFNhS3NVRTBWb0FiajFBT2Y4ZTJBU0pCdzd2UktqQnFTTnpD?=
 =?utf-8?B?VUFlQStqWFREYnBKLzBjdnp3dmw1MFdWUWRpbnRnUzE3eDlua0llSXdrOVps?=
 =?utf-8?B?NDBVRC9LZFRiTHluOXZGeFBONUlvMmZ5UThlZjF6L2FPbHpiUWd4Z3RQVmtE?=
 =?utf-8?B?NjRYL2FQQzMydzJDbHFFSUttTXlzbklTUnFCVHAwYUFSMXIvbzNleGY4Z2k2?=
 =?utf-8?B?dkpIS3NoYlVZQTFySCszSTlZdU1BTUF0NmV5R0hxNHYwY1hxNjlmTVZUK0VS?=
 =?utf-8?B?bkthYWRSZ1pUS2VyV0N2Ri9yM2cyL010bW9iSXBPWjdtOFB2LzFMRldINjBD?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB9420.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ba23e0-473b-4755-b5be-08db2a4d4031
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 20:45:48.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KpEsiHDaIhsQsenpiBkK53itYSBGaU6jZLE77JXL85CjAvoLJkbfuyVJOd0TjbPA7N5KWe0ubNWz2GEZdJlJl83HVJfnO/5cMb12SR1K7fAtBo6wKXT4p3RULZTjhH5O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB12044
X-OriginatorOrg: toshiba.co.jp
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYiBIZXJy
aW5nIDxyb2JoQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDIxLCAyMDIzIDg6
MzggQU0NCj4gVG86IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMg
RHVtYXpldA0KPiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+OyBQYW9sbyBBYmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBLcnp5c3p0b2Yg
S296bG93c2tpDQo+IDxrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc+OyBBbmRyZWFz
IEbDpHJiZXIgPGFmYWVyYmVyQHN1c2UuZGU+Ow0KPiBNYW5pdmFubmFuIFNhZGhhc2l2YW0gPG1h
bmlAa2VybmVsLm9yZz47IENoZW4tWXUgVHNhaQ0KPiA8d2Vuc0Bjc2llLm9yZz47IEplcm5laiBT
a3JhYmVjIDxqZXJuZWouc2tyYWJlY0BnbWFpbC5jb20+OyBTYW11ZWwNCj4gSG9sbGFuZCA8c2Ft
dWVsQHNob2xsYW5kLm9yZz47IE5laWwgQXJtc3Ryb25nDQo+IDxuZWlsLmFybXN0cm9uZ0BsaW5h
cm8ub3JnPjsgS2V2aW4gSGlsbWFuIDxraGlsbWFuQGJheWxpYnJlLmNvbT47IEplcm9tZQ0KPiBC
cnVuZXQgPGpicnVuZXRAYmF5bGlicmUuY29tPjsgTWFydGluIEJsdW1lbnN0aW5nbA0KPiA8bWFy
dGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT47IEpvZWwgU3RhbmxleSA8am9lbEBqbXMu
aWQuYXU+Ow0KPiBBbmRyZXcgSmVmZmVyeSA8YW5kcmV3QGFqLmlkLmF1PjsgUmFmYcWCIE1pxYJl
Y2tpIDxyYWZhbEBtaWxlY2tpLnBsPjsNCj4gQnJvYWRjb20gaW50ZXJuYWwga2VybmVsIHJldmll
dyBsaXN0DQo+IDxiY20ta2VybmVsLWZlZWRiYWNrLWxpc3RAYnJvYWRjb20uY29tPjsgRmxvcmlh
biBGYWluZWxsaQ0KPiA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBBcHBhbmEgRHVyZ2EgS2VkYXJl
c3dhcmEgcmFvDQo+IDxhcHBhbmEuZHVyZ2EucmFvQHhpbGlueC5jb20+OyBOYWdhIFN1cmVzaGt1
bWFyIFJlbGxpDQo+IDxuYWdhLnN1cmVzaGt1bWFyLnJlbGxpQHhpbGlueC5jb20+OyBXb2xmZ2Fu
ZyBHcmFuZGVnZ2VyDQo+IDx3Z0BncmFuZGVnZ2VyLmNvbT47IE1hcmMgS2xlaW5lLUJ1ZGRlIDxt
a2xAcGVuZ3V0cm9uaXguZGU+OyBNaWNoYWwNCj4gU2ltZWsgPG1pY2hhbC5zaW1la0B4aWxpbngu
Y29tPjsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsNCj4gVmxhZGltaXIgT2x0ZWFuIDxv
bHRlYW52QGdtYWlsLmNvbT47IEhlaW5lciBLYWxsd2VpdA0KPiA8aGthbGx3ZWl0MUBnbWFpbC5j
b20+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az47IFRvYmlhcw0KPiBXYWxk
ZWtyYW56IDx0b2JpYXNAd2FsZGVrcmFuei5jb20+OyBMYXJzIFBvdmxzZW4NCj4gPGxhcnMucG92
bHNlbkBtaWNyb2NoaXAuY29tPjsgU3RlZW4gSGVnZWx1bmQNCj4gPFN0ZWVuLkhlZ2VsdW5kQG1p
Y3JvY2hpcC5jb20+OyBEYW5pZWwgTWFjaG9uDQo+IDxkYW5pZWwubWFjaG9uQG1pY3JvY2hpcC5j
b20+OyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBBbmR5DQo+IEdyb3NzIDxhZ3Jvc3NA
a2VybmVsLm9yZz47IEJqb3JuIEFuZGVyc3NvbiA8YW5kZXJzc29uQGtlcm5lbC5vcmc+Ow0KPiBL
b25yYWQgRHliY2lvIDxrb25yYWQuZHliY2lvQGxpbmFyby5vcmc+OyBIZWlrbyBTdHVlYm5lcg0K
PiA8aGVpa29Ac250ZWNoLmRlPjsgTWF4aW1lIENvcXVlbGluIDxtY29xdWVsaW4uc3RtMzJAZ21h
aWwuY29tPjsNCj4gQWxleGFuZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNv
bT47IGl3YW1hdHN1IG5vYnVoaXJvKOWyqeadvg0KPiDkv6HmtIsg4pah77yz77y377yj4pev77yh
77yj77y0KSA8bm9idWhpcm8xLml3YW1hdHN1QHRvc2hpYmEuY28uanA+OyBSaWNoYXJkDQo+IENv
Y2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT47IE1hdHRoaWFzIEJydWdnZXINCj4gPG1h
dHRoaWFzLmJnZ0BnbWFpbC5jb20+OyBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubw0KPiA8YW5n
ZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiBDYzogS3J6eXN6dG9mIEtv
emxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPjsNCj4gbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWFybS1rZXJu
ZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtYWN0aW9uc0BsaXN0cy5pbmZyYWRlYWQub3Jn
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zdW54aUBsaXN0cy5saW51
eC5kZXY7DQo+IGxpbnV4LWFtbG9naWNAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtYXNwZWVk
QGxpc3RzLm96bGFicy5vcmc7DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFy
bS1tc21Admdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1yb2NrY2hpcEBsaXN0cy5pbmZyYWRlYWQu
b3JnOw0KPiBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29tOw0KPiBsaW51
eC1tZWRpYXRla0BsaXN0cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFtQQVRDSCB2Ml0gZHQt
YmluZGluZ3M6IG5ldDogRHJvcCB1bm5lZWRlZCBxdW90ZXMNCj4gDQo+IENsZWFudXAgYmluZGlu
Z3MgZHJvcHBpbmcgdW5uZWVkZWQgcXVvdGVzLiBPbmNlIGFsbCB0aGVzZSBhcmUgZml4ZWQsDQo+
IGNoZWNraW5nIGZvciB0aGlzIGNhbiBiZSBlbmFibGVkIGluIHlhbWxsaW50Lg0KPiANCj4gQWNr
ZWQtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+ICMgZm9yIGJpbmRp
bmdzL25ldC9jYW4NCj4gUmV2aWV3ZWQtYnk6IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRv
Zi5rb3psb3dza2lAbGluYXJvLm9yZz4NCj4gQWNrZWQtYnk6IEplcm5laiBTa3JhYmVjIDxqZXJu
ZWouc2tyYWJlY0BnbWFpbC5jb20+DQo+IEFja2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFN0ZWVuIEhlZ2VsdW5kIDxTdGVlbi5I
ZWdlbHVuZEBtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSb2IgSGVycmluZyA8cm9i
aEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gdjI6DQo+ICAtIEFsc28gZHJvcCBxdW90ZXMgb24gVVJM
cw0KPiAtLS0NCg0KW3NuaXBdDQoNCj4gIC4uLi9iaW5kaW5ncy9uZXQvdG9zaGliYSx2aXNjb250
aS1kd21hYy55YW1sICAgfCAgNCArKy0tDQoNCkFja2VkLWJ5OiBOb2J1aGlybyBJd2FtYXRzdSA8
bm9idWhpcm8xLml3YW1hdHN1QHRvc2hpYmEuY28uanA+ICMgZm9yIGJpbmRpbmdzL25ldC90b3No
aWJhLHZpc2NvbnRpLWR3bWFjLnlhbWwNCg0KQmVzdCByZWdhcmRzLA0KICBOb2J1aGlybw0K

