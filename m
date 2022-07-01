Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAEE562B14
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 07:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiGAFvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 01:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiGAFvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 01:51:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9C6B265;
        Thu, 30 Jun 2022 22:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656654697; x=1688190697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RHvtENx0OIVebGu5FIKCGZ0s3dXNItuBPpgJ+zkZuRI=;
  b=XHPInBg+zusKYuIoxssRelqgW8MGIkAXVk3/IlaOvJRPWqtszLkDpvaC
   nGBOkETRmnW0zH/g+mVTawF+ZZVH34r26UNos2XE+7dVk1a4EqeYUzSFX
   YMvZmUDjzHAiaVddnsjKPeytgEbO6cTh6n8ZT2MroZM2qgCzlZis0dURs
   WY+4A2390VMp1fVA/ZIk6K3DrAGW3uEpilAPFo4hrUT7z8Kq3CGdTrGF5
   JBXvgFWnRzGpi9AYkNqlascLcTxXdLqVHTTNrtX09slYcFQM2dZ6PAESe
   5KnXAOgbZ4IP0nQRBv4Xx62dkOmNnS0cM75UVDPePqsaWotvWECNjmfwX
   A==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="165954615"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 22:51:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 22:51:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 22:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4gu4+wQNXDr46whhVbXPhMdt0aJ7xaE+0I2YAN4bR1IIx0hnFPfFN9t7bu10/TtaRlCGimZdurcbVgDngYIAuw/Kb6wtmAjPHJykT5QikTHi9GHx+xUtEV8fbt27PQVbaiPvdxGfZjyJhirGlbJ2EkGhb3T4miI25So7dKsnRZZ+3ifGDzVxiiCzTT8rCxe5n1Ms+hHCB/EJbXHpUTbdMzk9PeMyDILwuBmGDe65oHZk5o66L7p2Ir7CicxWeW1EEECXZ5vod2Pg8If2gQRLXuIPbUT9To2wNdpcodFYBx8/3DpH0ASglM1PDv5YrNpmWusXqxhqUMjnsRYRnc8Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHvtENx0OIVebGu5FIKCGZ0s3dXNItuBPpgJ+zkZuRI=;
 b=Ti6RnZwPn4wHg28h9lLzpsVE+BNm187fqFyFp4jduA5OpvUfZIuIRRA3didCBTxQkMLBzb/5dfVDrls+DS40HIeOKG6gLMGMBmvSXPpLrCA0+zzNibocAQH62vgiAgZLwQax+68fn2r/FRt2OX2ZznvIvcfIzY/OhWgI1e25xH0bcOCW4nU8xL0gY0f1JuzoNWzhy8fsgDgaJnnkWXm61/Xhl9N3zJ3dGF9VsCJgkco2Kp2cAXuRCD/qx+JOhomqiNNIAw69heuz4ZKJyMjlkf+BLzjoS2qXj9hwkxC13DwGWOy+4UIkQcpLRgo1eT5eqYUaTfQ4P7gZP5IX66QxzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHvtENx0OIVebGu5FIKCGZ0s3dXNItuBPpgJ+zkZuRI=;
 b=jY1tCwyEusrSxAcLB105h5VIcXjBQmydLzHo/u5rXefaLHSc3Ji7yJpjBd6p21mcQesPslLHOZLScDu5iIglYG8LPRtIUuMof8SmlAJHaDXj/APmVJp9rHTytxrWL7SlkBwDR0dUkWHLTjqCf3ay48KhqhP90RD+85WXYppwckM=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CO1PR11MB5025.namprd11.prod.outlook.com (2603:10b6:303:9e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Fri, 1 Jul 2022 05:51:33 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 05:51:33 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <ast@kernel.org>, <bpf@vger.kernel.org>, <olteanv@gmail.com>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <andrii@kernel.org>, <songliubraving@fb.com>,
        <f.fainelli@gmail.com>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <yhs@fb.com>,
        <davem@davemloft.net>, <kafai@fb.com>
Subject: Re: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Thread-Topic: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Thread-Index: AQHYjGt2EVBpKmmXeEimAK9I8lVU1a1n0muAgAEx+oA=
Date:   Fri, 1 Jul 2022 05:51:33 +0000
Message-ID: <4cf0a3ba409dcb0768150c2a1a181753dddc595b.camel@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
         <20220630102041.25555-11-arun.ramadoss@microchip.com>
         <Yr2KuQonUBo74As+@shell.armlinux.org.uk>
In-Reply-To: <Yr2KuQonUBo74As+@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd93cafc-c584-4937-df01-08da5b25c0e2
x-ms-traffictypediagnostic: CO1PR11MB5025:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyd0tt9z5hCowgsGpOT1qxSZlU5/YRBK00XEtgi8FRHyqrmcbOjJJQh0w6I3lluDi+HJ4USFPb3TZq6GgzTcthbhWAYLxzVUuRoOJ64JvOHlkQh+ay44i+lpX+uJrcT4hNEtmaPljN9318tHwc9KrbzwIOAGfBF/py59Y6a7qH7wQ7i5tcrAvtejfp+V+7EFjB7wX2JCM52U9JTRy/mxC2a5yDTzm9WImQJGh9azlU12fHqT4pv48zjTAaFLXiWE2oIBGrsPAFSSRsYtcwFq845hCdcyJexDM/5CVDvcJwanwOsJYtYKqarv85hX2EhgxUH4EUaeUqkvLrHNY7YbZd/Gfe1ctKNsAWAPKpPvldQQeRYd7A9TFXNGgs0/yLGSthtUL1r9rxa7km+Sqg/V23XBzq/+RYoQNH190p5VUbXHp55H1nVhoqs1CV658tWDEnvY0+e4bPkU0YiE9kN0baDS3X6yIzrTgdsDFpwW932NDOjYz2tZ+7wxV4pOcRQt7bcyw0UVeAZxsF0ZOE0KfkxcAFxqKqy6OHxgjWxRTpwp1L17DrQnQ7O21DKhFcSuolAgJNNYMS1RBUD8p+LAh8DhjENRVaBoEktCoydVOCYpTLjF2NujLbwhGZKHZlmzYMTC5DQ/Z79vuNzAzIxPqyl9TsJd9MyLNUvgswxM1euEViLbnyskBLaC02k9g465aa5QkDM4Gzu1TqwVkNvMy2hxqxTLTaRbY311xvY8mOz6kXhAvm1BKsW4qDCzgsBmBZ10CFA0eEiD9LREuyeK+a+EhCTb6laB6/WOn/DW4yKHdp9lLka4FVWLJ2pmMk1mkCHHyecrP+xPRmaYB0uViDLIzacVX6oSswzSaKM+WRNpPNJuXBrbKK5A1imJ3z3S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(366004)(39860400002)(6486002)(41300700001)(26005)(54906003)(966005)(6506007)(6512007)(5660300002)(6916009)(71200400001)(186003)(2616005)(8676002)(316002)(64756008)(66476007)(4326008)(91956017)(2906002)(8936002)(76116006)(7416002)(66556008)(66446008)(83380400001)(66946007)(38100700002)(122000001)(36756003)(478600001)(86362001)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWhpMkRaSmRpb1NRL2RKR0VpbEhMQzhKaWtiQWtMRkI5dE1uSlUyeHJJbWxw?=
 =?utf-8?B?cXVXbk43MDE5VWs4NUYwbG44MStSM1BUaHQzdnVJdGcySnIwUm5hNGRZblFm?=
 =?utf-8?B?dHF4ZmlqcFB5cm9pQ2Zpd0NQZHFIQzFsWHByNWJYNzhSSWxFYURTYUp2a1lZ?=
 =?utf-8?B?VnhQM0xBYVdEeE1hdExFOWJ1N2FkUWgxS3NoNG5SN1k0RUN5U0RpMXZqK1Z5?=
 =?utf-8?B?eDdXTXdQVVdyeUVXMnhKcTVwMkJXcmZtR3JZdXVtMEl4TUtoSkVmUDJYeG9L?=
 =?utf-8?B?blZ0cy9oMXcwUjhnL0pldGFXMENHekpLcDlZTGtwcWcyVlFQR3FxMVJ3Rm95?=
 =?utf-8?B?MlZBVmw4WW5GOHBFaEtCQmpwZDZEZERJcWltZ1Mxd25QbHdnSjViUm9nVkV1?=
 =?utf-8?B?b0R1TXJkU0ZLZUhnVlVFaGUrdlczUERLbFRoSUJZV21tamtEU0g4R2htcVBK?=
 =?utf-8?B?cXg1WDI4UkhLN2tmZE94VXk1MmRQb2hlamRLRGZma21aSmoya01yU1Y4UzZu?=
 =?utf-8?B?cyt3WmpXZXNOSDlibHBKYnFibCtBS054R0NvcDZhTS85SlBMNWpBY1JVTU95?=
 =?utf-8?B?cXFDWkV3TStTZGV1Ukk0TlR0VFA0c2E3R2Vyc0kzV2N4bGNnWkptUW93YlJE?=
 =?utf-8?B?cllYZUYxaGUwRzZnemgyR2djMytUN2YrSWxPNVJGZUExdXJkQ2ZQdEozRlJ5?=
 =?utf-8?B?Tm9kSzFPQStQaElyWWR0ci9TdFV0VVIzejdLeS9VRll3a0lkVktkdzhMWHB1?=
 =?utf-8?B?eENwMWNKaElQcTFQNkUreFpzcmpTYUFrc0lXZEJ0MGtWQmk4Q3FiWDlzT3Vn?=
 =?utf-8?B?ZkgrUTFLYkxMa0NTWVd3L3lQZ0lrSWpXZUJPUEZ4TU1iMk1TM296eS82Vktu?=
 =?utf-8?B?ZTdSYmdFZmZ5S2xMVHlKNVA5TG5RbGh5L0dDOHdKMnU3Z2dFbVlxQnVsemsy?=
 =?utf-8?B?Qk9sZ2FmTVB3VkpoV2dtT2xpWGgrOHRzRThCY0NJeXVQdExTMU9xYmZBL1BX?=
 =?utf-8?B?Q3V0cHZ5dGJPR3NtazN6YzIrWThMUDBYRzlseENsREN4VnArV2NLNXlMcHFF?=
 =?utf-8?B?U2hnbUZzczhwTGxvb0NFdFNnbXFmM2pPckpnME5Va0JKQ01odm16VjduTncy?=
 =?utf-8?B?SFVkSFVxRFc3VWNvSUgxaWs3VDVjR1AzMUx4U3lyb0tXYTkveXdkd3VlSFNa?=
 =?utf-8?B?VUZKMnNnUW9DVytoNDVzSlJSQTRSVjFlSnpsZUhwcXNLcE1NcUtFNU5ENHJk?=
 =?utf-8?B?MmdNWmFnd3hqYnlEOU1ZY3dwWFhUR1NrOXlSb3E2RFFpajU2SkkxMWJXamlK?=
 =?utf-8?B?bUlGMGp0Y2dzRFFiS2lTaVJ4eUZXWnl4eDZzSWtROE1hY2lSZTk1ZnFWbW82?=
 =?utf-8?B?ZzBzMGQvNklwajhycVluKzJuYndTeGdsU3MvZ0tSNE5SREtlS3VSZG96NHl1?=
 =?utf-8?B?Sjg0Q2xlUVI3U2pmTEQzNGFBOGhmSjdVU3psci9QSTM4Q3VCUmZObCtJcy9Q?=
 =?utf-8?B?ZUY1K0dZcDVxSnpPRVJhVS9uRkQ1a1FyUXB4TnQzRDhaZWMvMUdVTm9Dbm1j?=
 =?utf-8?B?S0VoMmlPQW5RWjlndDRlNnhBWEI1UzNjQTdrZFBGaEpSTmcrWktyZllCaUxT?=
 =?utf-8?B?RXptbVNhVy82cUlOUnpBeGE3WmNmbi96ZGNNaVljdW5xQkdNUVpod0xBWmFj?=
 =?utf-8?B?TjFxeC8xZ1VIU00rR3MwVFNmYlNCc3VaOCtFby9xU1UyKzZQNUFldXl1QzJk?=
 =?utf-8?B?RWw2SGRnRXIyejN5TFBPR2VGVGJNWlNoYmQrYjFwcVFCaGtId0hZSDc0cE5C?=
 =?utf-8?B?N3ovQ0w2TjNXaVVCNUNvLzBIZDZGMGxyR1JrcUhHOXczMEFsTWQ2ZlV4UTRI?=
 =?utf-8?B?ajlLdWMvYXo4VEx2TmQyTFAvenBCNXdOQTBqbmo1WEIzT1BmbnkrR2Q4V3Zh?=
 =?utf-8?B?Lzh2aDVoeHMxUEsrUjhNbTJOVGNUSEVvRU94ZzRkaWk3T2FvNHVWSHRUOFM4?=
 =?utf-8?B?WUtFakhvd0tEWEtCK2IwSHprb1ZtK0YxTDFBR1lWVHordTZncVpRQWt4SCs4?=
 =?utf-8?B?MUdGWjJJckVBbWdaYmdFWXI1RUtMNlpPZEM5RHUwZFM1allkMEtpNVRKUDdC?=
 =?utf-8?B?OVhoN0x1UGliY05lQnhnM0MvMVpZalpTSVZQS2p4eDZzWERjQU5FbzhWTXRF?=
 =?utf-8?Q?e8+8Cr1+rL8asi80b4yiR08=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF8658E651DE4B46B1E410CAB41FBB9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd93cafc-c584-4937-df01-08da5b25c0e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 05:51:33.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGCu78e4TKKwlBEzDVg0vV+SnAcTU1xSkUJ4atTIScZRNaHI490NO4UEZyX8gHYttctQLf+SRBf0iPKSA/ZiJoFPUX1rcqkOL1AOBnG9Fzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5025
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsbCwNClRoYW5rcyBmb3IgdGhlIHJldmlldyBjb21tZW50LiANCg0KT24gVGh1LCAy
MDIyLTA2LTMwIGF0IDEyOjM2ICswMTAwLCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgd3JvdGU6DQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVGh1LCBKdW4g
MzAsIDIwMjIgYXQgMDM6NTA6MzhQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4gPiBU
aGUgaW50ZXJuYWwgcGh5IG9mIHRoZSBMQU45Mzd4IGFyZSBjYXBhYmxlIG9mIDEwME1icHMgc3Bl
ZWQuIEFuZA0KPiA+IHRoZQ0KPiANCj4gR29vZCBFbmdsaXNoIGdyYW1tYXIgc3VnZ2VzdHMgbmV2
ZXIgdG8gc3RhcnQgYSBzZW50ZW5jZSB3aXRoICJBbmQiLg0KDQpPay4gSSB3aWxsIHVwZGF0ZSB0
aGUgZGVzY3JpcHRpb24uDQoNCj4gDQo+ID4geE1JSSBwb3J0IG9mIHN3aXRjaCBpcyBjYXBhYmxl
IG9mIDEwLzEwMC8xMDAwTWJwcy4NCj4gDQo+IC4uLiBhbmQgc3VwcG9ydHMgZmxvdyBjb250cm9s
Pw0KPiANCj4gPiArdm9pZCBsYW45Mzd4X3BoeWxpbmtfZ2V0X2NhcHMoc3RydWN0IGtzel9kZXZp
Y2UgKmRldiwgaW50IHBvcnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBwaHlsaW5rX2NvbmZpZyAqY29uZmlnKQ0KPiA+ICt7DQo+ID4gKyAgICAgY29uZmlnLT5tYWNf
Y2FwYWJpbGl0aWVzID0gTUFDXzEwMEZEOw0KPiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5pbmZv
LT5zdXBwb3J0c19yZ21paVtwb3J0XSkgew0KPiA+ICsgICAgICAgICAgICAgLyogTUlJL1JNSUkv
UkdNSUkgcG9ydHMgKi8NCj4gPiArICAgICAgICAgICAgIGNvbmZpZy0+bWFjX2NhcGFiaWxpdGll
cyB8PSBNQUNfQVNZTV9QQVVTRSB8DQo+ID4gTUFDX1NZTV9QQVVTRSB8DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTUFDXzEwMEhEIHwgTUFDXzEwIHwNCj4g
PiBNQUNfMTAwMEZEOw0KPiANCj4gQW5kIFNHTUlJIHRvbz8gKFdoaWNoIHNlZW1zIHRvIGJlIGEg
Z2l2ZW4gYmVjYXVzZSBmcm9tIHlvdXIgbGlzdCBpbg0KPiB0aGUNCj4gc2VyaWVzIGNvdmVyIG1l
c3NhZ2UsIFNHTUlJIHBvcnRzIGFsc28gc3VwcG9ydCBSR01JSSkuDQoNCk5vLCBTR01JSSBwb3J0
IGRvZXMgbm90IHN1cHBvcnQgdGhlIFJHTUlJLiBJIGhhdmUgbWVudGlvbmVkIGluIHRoZQ0KY292
ZXIgbWVzc2FnZSB0aGF0IExBTjkzNzMgaGFzIDIgUkdNSUkgYW5kIDEgU0dNSUkgcG9ydC4gTm8g
b3RoZXIgcGFydA0KbnVtYmVyIGhhcyBTR01JSSBwb3J0Lg0KDQo+IA0KPiBUaGFua3MuDQo+IA0K
PiAtLQ0KPiBSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBzOi8vd3d3LmFybWxpbnV4Lm9yZy51ay9k
ZXZlbG9wZXIvcGF0Y2hlcy8NCj4gRlRUUCBpcyBoZXJlISA0ME1icHMgZG93biAxME1icHMgdXAu
IERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg==
