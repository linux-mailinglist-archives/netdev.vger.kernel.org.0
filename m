Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF585998E8
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347715AbiHSJhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347163AbiHSJho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:37:44 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2055.outbound.protection.outlook.com [40.107.104.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F9BF0763;
        Fri, 19 Aug 2022 02:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mg1aCyZX6o3XCajGVYPhxvwv8xUQU5nGz5SaCK/HjbLqKcn8xVkWZFWncNPv1rhcl4X06AuZbv1gxL2VqBNlScw2EVy5vKvKFPwma/uK5VDLgnID05V+Lg3uUhLLy6Io5UcCggMFViOFg+yBy0lnCegweiv+DJfT5gHNr4ENBYRgJyzBbQHXeVV4yfOCRUA9VdBNLitb61qT/QpSOvI8cKolJMQo8CFV/kZhVeB7nAS9FQWW711oig++TNJA1wNPFfytCIb7YERNxVqC2oDxwh7lunT9g4BTEYX+JTR8riE+H33DL43WmUZq3tw5VB37u+mbQWuCgrCLUCpwmwzd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msjk3lopFrHbEy5kcA81PedrvfcoF1WNrR2ipMraDEk=;
 b=Q6FXXh5CFVa3xJ+GqV30Zpz0LnWRTfrO6nsWrx4Fty756E2cBX9NrUiMh2zpDkPuKckzLll9sIqTjASAsalJUI3ErTagx1VeOfhNI+/XqyOgNY83AGdfW981UjFwBjlknyDt9CltpLVYIJ14Fwb1seDeRx6IWv1a3wDDxSlIEaDO9CKoOLK8gTKtbrT3irHGmQoJczjzrwFrHljMr5SlKmpBiZWFcQ0YbFsXshs2cd90oTT9kukpHUo2qYb9EEkKMIWYfeNqQa3Y1BH8tlstl9IFvh//sfojzKT5CTFRly560oODa7g43/W/jmRFwEexqvuTlgZgBwlfYQPLq1dzgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msjk3lopFrHbEy5kcA81PedrvfcoF1WNrR2ipMraDEk=;
 b=CdqJ6AI87UWFIpQYcyCzBnwcFQq6OK2TCDoMoy6ZLsvZXvejdekscaLkedr5Tna6rgaK0UmQH0l9Xh0KFQ/fFGcBwyvNqsICMFy98hnt+R/Oe6uzzl1l+hwuOuH/7JZjnNPM5B/w0Iag9Zt46ivQfZfgn7a0NcLrAlmQH28ktL4=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU2PR04MB8997.eurprd04.prod.outlook.com (2603:10a6:10:2e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 09:37:40 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 09:37:40 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in
 property
Thread-Topic: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add
 nxp,refclk_in property
Thread-Index: AQHYs5/32SQ3bZviJ0GFr1ZJ6a4HB6218MqAgAABedA=
Date:   Fri, 19 Aug 2022 09:37:40 +0000
Message-ID: <DB9PR04MB81064199835C0E44B997DE06886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
 <20220819074729.1496088-2-wei.fang@nxp.com>
 <f0f6e8af-4006-e0e8-544b-f2f892d79a1f@linaro.org>
In-Reply-To: <f0f6e8af-4006-e0e8-544b-f2f892d79a1f@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f7d0bb6-1cdd-4c00-125a-08da81c675db
x-ms-traffictypediagnostic: DU2PR04MB8997:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yA2lm/VRgP0Fx9zJIckvbMTUiln/lKNkeu/akMx5B5F8szAFjqyshy5/nIVBj6VW6BvS7ckAynOR7dHevUoWZEwuRr3LvGMxg6Soj9V44aOuk80c/Ah1k0IfPQHTt8WMlB1Zkc5qGO+nGjnP6ir0TDkuIfgXJQILCRhD0tnyfF0s3+fkgwEO51/42dvMBHMR44ipICs/7TLeqZTt3+wjt8GKjQ6+E8N7ktkBzj3r0yRXJO4OrnDnZ5uudHlHLYMpeTkAH0VuP46Ho9BvKlgwJYkOxEx2zbdo61vlpK4x5oVN2vUQR8K1aCkSnjYhU4ps7G8y9EQMNm5XzZWB7bjOZDp+egOaA91E3IBSPHm72mxWpXbL+JIIPNV0ZLFvDrl7QmSHMsh/WVqgpVgMOCTZPRm0NipHsxH2LM8sFlhBx8ZDw+kg3d0Hs34oPnFWnf/TEPxEcPMCsAsnpfSJjwfhqmxrCj29fLAQjwYFXAbi2aB6qerO4yD6Io/ZwVKMvBA3WgzYyf9wvxVsbAYNh3V3uoC9gjZK99ekuA1ym/gDq44GmK1cM8gYOX2iDtRguhamUv7KiUTFx7stGqyc6OmNzbnKESMxgqxskqyeJbuN+JFc3JfpR/gqo3gRpioZDkdEIS2ImMtNDlsM/by/5JJ5B8BF4W4ddtAu1L1Wqg7+QbdHx87ULFxdZQ2U/an8KbJrHH46rMyY32iBXisHDNIZVg7Nnpal148XXLoxdrYwwYDif0BMXsj28Pml/LmZX8rvFIOS9XKdzHgfDAadp/mJishXM6ZU4eVK+j3j2LRzsvE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(54906003)(76116006)(5660300002)(4326008)(66556008)(110136005)(55016003)(316002)(66446008)(2906002)(52536014)(64756008)(7416002)(8676002)(66946007)(122000001)(66476007)(38100700002)(44832011)(33656002)(86362001)(38070700005)(921005)(478600001)(26005)(41300700001)(7696005)(6506007)(9686003)(71200400001)(53546011)(8936002)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L29xUHhOM0xnV0dDcVZYdko5Y2l6OVhMNTAyK2ZzNFZva3NoeUVFWWdvZ0I2?=
 =?utf-8?B?eXNGS1h0bi9Ec0ZUblZyQ2pLMEg3dWZabTZTU2tqQ3Y3Rnk0TDBDTk90UW5L?=
 =?utf-8?B?UTFDL09tYXEyK2l1WEFIM04wb1BESytlS3I4RVp1RDdXMmR0YmZlWHd4RDYr?=
 =?utf-8?B?dVZOb1FYK08xTzJuYWtpanIrOGpkZ0d2L1lIM1ZrSzlDUjZkV0dpNkZsOWxv?=
 =?utf-8?B?TXZEV0hsR2ZKbE1NQU5INU42STltVGhzbldMZTNuRVZPK09DMVBYQXRlWFpR?=
 =?utf-8?B?TVNDK3kyc2Q3K1pKZG9NYXJzbzBZc0FleXl3U3dIdXpLL0VhT3h3NmcrUjlT?=
 =?utf-8?B?QVFIR1NORlZRTk12TGlFZWVlUGRPRXo0cURiZjZtcXJlcGlValpSdmdnNVVz?=
 =?utf-8?B?eGJyQ1AxSVRJUE5NZHdzYjVVY3pHdkQrc2NKWjR1SWxyV21reUZRdTUyaEI1?=
 =?utf-8?B?YUJLdnBiM1U2aldNT1BWTy9RckZxTlJqVHk3cDgrS1BIVlJlUEVabUpiR1Rq?=
 =?utf-8?B?NW8zQXZhUWt3ODk5YXlQaVQ1UElIZWFMQUU3Nis2dDQ5bzdzUCs4bS9Ec0V5?=
 =?utf-8?B?ZjRvRlRDUUpOYUp4SUNwc1dVSURFdSt2bUQzeWdWV21zOEhqbWJFM3U4RENR?=
 =?utf-8?B?cEQ0QWQ0RXJGa2NFM05vZTJyUGlRTHpBL3JjeGdYVS9tNm1zdkpoQm9MNU1P?=
 =?utf-8?B?Z1J3S2hvR3E1TFdzdE1qN2laUUduOE51YW0wMmFlV0dBdm5uZUNsWkdlZ05t?=
 =?utf-8?B?OFJQRlpjRXBqdnVSYklwbnIzcGFlYkQvdUswZnp1bXV0UkU1ZEVoa0Z0bkZG?=
 =?utf-8?B?cWZHRUZha1QwRC9jOWFrdDNOR1BEM2FlRURSV3c4VFk2RWRDZ0RtblBRb3o0?=
 =?utf-8?B?czNJZ0xOY2JaWGRWK3NUcGlTUGdQNzVSTTRQMlBGMjBGeWo1TkJKMjhibDlq?=
 =?utf-8?B?TDd6eHhtaC9TZktIYXRyUTdESll3bWk1SUpvWEVnNFVEbEdmRGtIZGpYcFdj?=
 =?utf-8?B?YmdsdnJzNCtRdk5JRTlhV3hZOFZ1NUxWQ2trSHJ2SnpEVEVpcDFMWlNiZzNK?=
 =?utf-8?B?Qm5PeFVxNmFtbU9oYTR3TlFrQmRiUjZVZmx3TXRwWklrendRaDRzMlBXREVu?=
 =?utf-8?B?Wkpnd2tYdlBJL0JST0Nqbk9pemk3WXdSa2tEZHNnVVZPckhIU1kxZnVUWG44?=
 =?utf-8?B?ejRCdEtxMWxoTEdTOTZJZ21POUx1Z2FkZHB6UEY5eHRIc3hJMitWc3d5bVFi?=
 =?utf-8?B?UGw2Vy9Jd3VSdGF6cFAxRHpCbHN5THpXcHRUdmVsOWNub2htYlJVcjBGbzBz?=
 =?utf-8?B?YkZoNTMxOHJob3lFL3FJOVpacUI0S1lId2JVTGcyS2tUalFtTmVkT240b3h1?=
 =?utf-8?B?NGVWNnNKVE1JTllWQ2hvQ0RCWmhoa3JrZWRGS0k5RGU2MXp4dS9MeXJMbUVa?=
 =?utf-8?B?em1LTjUrRUtVcy8xeGZHVXczMTAvUWZscmJWUHpwbDRZRVJGOEtnQW1TckZF?=
 =?utf-8?B?Uk53VTQ1UFpMU0RHbjRZV285VDdQVTdLM0tTMjBPd1NwUEQ1MncvTDA3bGZr?=
 =?utf-8?B?Mllrc2FxTDcxQlJ6ZnRpd05LNHh0VmR1ZG0xUGFZQjhvRFo2d0tJNFlwOFVE?=
 =?utf-8?B?d0xEbVBWQU1zZExhb0dyVjZ1dXJrenlBamtuTnVkZW1UNU5sL2tPR1lSNlhT?=
 =?utf-8?B?bkt0djJYUDh2RDRCblJEK2NUVFNKYUN0UnFPaXp3aHlScURhc0NpZzBGeDJ6?=
 =?utf-8?B?dFlqd1pNL1huZkh2cDRvVU1iTmxQLzBINDd2WVptNHVXenYzWVIvZ1RxdG40?=
 =?utf-8?B?ZlgvVmVJcm1BQlZaRGcyelU5Z0d4MUwwYnB3SXNtVDduZlBCdjE1aFZwSWpk?=
 =?utf-8?B?eE5qSWVMdk1wSWVHTnc1ekRnc2ZIdlpjNFhPNkkzelBNdjZxVWlzT2VBUU9v?=
 =?utf-8?B?TkNCYnZIZFpQNGthOFFhdmxxNEo5RGJIdHNnM0dmbkZlK0tZdkxmbXVrdkRF?=
 =?utf-8?B?UkpMdVBqUkNQUnhCNHg1Rm5DV2JQM25NRVkyS0F3ZGUrZEdhbkxzNk1XRngz?=
 =?utf-8?B?MGg2dnRBUW9MSHdOczJSMk1HWlpQU2t5Q3ZpN3BzSnlVUHhlaU9VRTVFcGRa?=
 =?utf-8?Q?inOI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7d0bb6-1cdd-4c00-125a-08da81c675db
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 09:37:40.6833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qolgzdXMq9UPadKR6A4VrwnkG5se8Rg8qnzeIRRr8FyF3SlIze8uV5UC4IT0WONGCNyJQE8nIEecUNuR+NnU8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8997
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIy5bm0OOac
iDE55pelIDE3OjE0DQo+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFi
ZW5pQHJlZGhhdC5jb207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3Nr
aStkdEBsaW5hcm8ub3JnOyBhbmRyZXdAbHVubi5jaDsNCj4gZi5mYWluZWxsaUBnbWFpbC5jb207
IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51eC5vcmcudWsNCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8y
XSBkdC1iaW5kaW5nczogbmV0OiB0amExMXh4OiBhZGQgbnhwLHJlZmNsa19pbg0KPiBwcm9wZXJ0
eQ0KPiANCj4gT24gMTkvMDgvMjAyMiAxMDo0Nywgd2VpLmZhbmdAbnhwLmNvbSB3cm90ZToNCj4g
PiBGcm9tOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPg0KPiA+IFRKQTExMHggUkVG
X0NMSyBjYW4gYmUgY29uZmlndXJlZCBhcyBpbnRlcmZhY2UgcmVmZXJlbmNlIGNsb2NrIGludHB1
dA0KPiA+IG9yIG91dHB1dCB3aGVuIHRoZSBSTUlJIG1vZGUgZW5hYmxlZC4gVGhpcyBwYXRjaCBh
ZGQgdGhlIHByb3BlcnR5IHRvDQo+ID4gbWFrZSB0aGUgUkVGX0NMSyBjYW4gYmUgY29uZmlndXJh
YmxlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+
DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ueHAsdGphMTF4eC55
YW1sICAgIHwgMTcgKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDE3IGlu
c2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L254cCx0amExMXh4LnlhbWwNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvbnhwLHRqYTExeHgueWFtbA0KPiA+IGluZGV4IGQ1MWRhMjRm
MzUwNS4uYzUxZWU1MjAzM2U4IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvbnhwLHRqYTExeHgueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbnhwLHRqYTExeHgueWFtbA0KPiA+IEBAIC0zMSw2
ICszMSwyMiBAQCBwYXR0ZXJuUHJvcGVydGllczoNCj4gPiAgICAgICAgICBkZXNjcmlwdGlvbjoN
Cj4gPiAgICAgICAgICAgIFRoZSBJRCBudW1iZXIgZm9yIHRoZSBjaGlsZCBQSFkuIFNob3VsZCBi
ZSArMSBvZiBwYXJlbnQgUEhZLg0KPiA+DQo+ID4gKyAgICAgIG54cCxybWlpX3JlZmNsa19pbjoN
Cj4gDQo+IE5vIHVuZGVyc2NvcmVzIGluIHByb3BlcnRpZXMuDQo+IA0KU29ycnksIEl0J3MgZmly
c3QgdGltZSBmb3IgbWUgdG8ga25vdyB0aGlzLg0KDQo+ID4gKyAgICAgICAgdHlwZTogYm9vbGVh
bg0KPiA+ICsgICAgICAgIGRlc2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgICAgICBUaGUgUkVGX0NM
SyBpcyBwcm92aWRlZCBmb3IgYm90aCB0cmFuc21pdHRlZCBhbmQgcmVjZWl2Y2VkDQo+ID4gKyBk
YXRhDQo+IA0KPiB0eXBvOiByZWNlaXZlZA0KPiANCj4gPiArICAgICAgICAgIGluIFJNSUkgbW9k
ZS4gVGhpcyBjbG9jayBzaWduYWwgaXMgcHJvdmlkZWQgYnkgdGhlIFBIWSBhbmQgaXMNCj4gPiAr
ICAgICAgICAgIHR5cGljYWxseSBkZXJpdmVkIGZyb20gYW4gZXh0ZXJuYWwgMjVNSHogY3J5c3Rh
bC4gQWx0ZXJuYXRpdmVseSwNCj4gPiArICAgICAgICAgIGEgNTBNSHogY2xvY2sgc2lnbmFsIGdl
bmVyYXRlZCBieSBhbiBleHRlcm5hbCBvc2NpbGxhdG9yIGNhbiBiZQ0KPiA+ICsgICAgICAgICAg
Y29ubmVjdGVkIHRvIHBpbiBSRUZfQ0xLLiBBIHRoaXJkIG9wdGlvbiBpcyB0byBjb25uZWN0IGEg
MjVNSHoNCj4gPiArICAgICAgICAgIGNsb2NrIHRvIHBpbiBDTEtfSU5fT1VULiBTbywgdGhlIFJF
Rl9DTEsgc2hvdWxkIGJlIGNvbmZpZ3VyZWQNCj4gPiArICAgICAgICAgIGFzIGlucHV0IG9yIG91
dHB1dCBhY2NvcmRpbmcgdG8gdGhlIGFjdHVhbCBjaXJjdWl0IGNvbm5lY3Rpb24uDQo+ID4gKyAg
ICAgICAgICBJZiBwcmVzZW50LCBpbmRpY2F0ZXMgdGhhdCB0aGUgUkVGX0NMSyB3aWxsIGJlIGNv
bmZpZ3VyZWQgYXMNCj4gPiArICAgICAgICAgIGludGVyZmFjZSByZWZlcmVuY2UgY2xvY2sgaW5w
dXQgd2hlbiBSTUlJIG1vZGUgZW5hYmxlZC4NCj4gPiArICAgICAgICAgIElmIG5vdCBwcmVzZW50
LCB0aGUgUkVGX0NMSyB3aWxsIGJlIGNvbmZpZ3VyZWQgYXMgaW50ZXJmYWNlDQo+ID4gKyAgICAg
ICAgICByZWZlcmVuY2UgY2xvY2sgb3V0cHV0IHdoZW4gUk1JSSBtb2RlIGVuYWJsZWQuDQo+ID4g
KyAgICAgICAgICBPbmx5IHN1cHBvcnRlZCBvbiBUSkExMTAwIGFuZCBUSkExMTAxLg0KPiANCj4g
VGhlbiBkaXNhbGxvdyBpdCBvbiBvdGhlciB2YXJpYW50cy4NCj4gDQo+IFNob3VsZG4ndCB0aGlz
IGJlIGp1c3QgImNsb2NrcyIgcHJvcGVydHk/DQo+IA0KPiANClRoaXMgcHJvcGVydHkgaXMgdG8g
Y29uZmlndXJlIHRoZSBwaW4gUkVGX0NMSyBvZiBQSFkgYXMgYSBpbnB1dCBwaW4gdGhyb3VnaCBw
aHkgcmVnaXN0ZXIsDQppbmRpY2F0ZXMgdGhhdCB0aGUgUkVGX0NMSyBzaWduYWwgaXMgcHJvdmlk
ZWQgYnkgYW4gZXh0ZXJuYWwgb3NjaWxsYXRvci4gc28gSSBkb24ndCB0aGluayBpdCdzIGENCiJj
bG9jayIgcHJvcGVydHkuDQo=
