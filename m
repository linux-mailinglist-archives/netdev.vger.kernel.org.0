Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38A66752A5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjATKik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjATKii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:38:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AE5AD28;
        Fri, 20 Jan 2023 02:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674211117; x=1705747117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WjsQ/MLdYjFgAN42TLe1QjO5SAeJzpPvPFfTcn7kI10=;
  b=kLCNM9DAo0t3Qje3FcGgG8H8uRWbmPjktg7dXY6TW7AyCoVlun8xnQbP
   B63bGhShPbUUt+4oI4qlYLyesQLLmtkurybCeNH8RNAIILdxzzyyrDpMg
   RJW/8MrJCmKOiYPhzOZlw8l/S/Y4NPkqjpQ4Vg5TtDv2ap5S202LcvdX/
   CmA035hNnuEupPiIrqR6WMlCFFjShUyvlhldikugEIWQDu+5XKafuVM3e
   iOOWTu8FHLsiH1POKhsdXwQStu2FbONYJJ9jgei0msXZLjz4UP90+1rY2
   2FqEKwE0NzauGJmkvbEgiFfY6CLc0xAzA5cTV4/Gxmw7xROW2EJsYfuOV
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="133264887"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 03:38:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 03:38:35 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 03:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV54QhEcOr34nHNdbTl2N2xrF1y4HI+3RyGVGpFL+fxy7xt+ajap+py1CsYCUSxKOOkp6bgVvgY9SXj/WIShPLt4EH37zKUDebV7je2qyGVZz+KGRdYebWkBFnf1qSWTcFfvlOF1VyDsi9S059H2JqwZr9mxGHfBEmqWA7HupKlnMV6v1KdGySl+LAvY+L1Ms3VtEOkifSFWPlRXAlklwXD2wVQaQlL5BpgQu8CymzAZjgJtPVOb196o86TN2XnNQ968q9B1eJj99GLe5+2ySO9pJG5RVq170BSAe9cQ7CSpWXfNoZ56FsIQpJD7u/f3HiWZymha+bYwRWZoTcWWJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjsQ/MLdYjFgAN42TLe1QjO5SAeJzpPvPFfTcn7kI10=;
 b=UG5s2jmtRM1l9NNCKQogG1ecsK+Azho6NA4RjZ3x0A+WEb6Lq+j0IIlZVGVKBNHZnX4VllzUq5al794dY3+1X5M9qFC6+2tmdVyrYlcreHPIz3mrjzvbJdwuS97T7BJlCa+da7rMQeZ83migSfQqnhDzD9kj0ByKEPGnRmxB2FZghlZJB9Jk/9ylupQcav8LQgGD8gjVvcEDJqZtJtS1XzyCnQnQEjB4H0wwcOh9kPpsNq/rAodA/DStAkeXqd13CehA0EyLZ/Mvq7KNiZmBBiKnbJU+i1JTHYbwIy7BlEQQN6sbEMXHqf4aYQuwsMTzdpBN+6B269x+D2rYdCK14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjsQ/MLdYjFgAN42TLe1QjO5SAeJzpPvPFfTcn7kI10=;
 b=vfYAuf6OvxXiBWvqzUie6+1mS513QGNf1zajztkvhXeMH2H4yQ5V8FXPPnlYeV0Sm7zskqU3NVKSf2b+bK9i48570VdMFpy8JlyL2G9+I7eILUYtvRBdVVmfADnhEFVKL2tcvIQnRpT/vNFgORcH8lFc0UcbOBJKHymechdhDfs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 10:38:33 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 10:38:33 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <a.fatoum@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <pabeni@redhat.com>, <ore@pengutronix.de>,
        <edumazet@google.com>
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Topic: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Index: AQHZLAhN1bL1NvCdeUO6Em39hgWKCK6m4ewAgAAPk4CAAC0dgA==
Date:   Fri, 20 Jan 2023 10:38:33 +0000
Message-ID: <a453da7bd4e1a0ea1da7cb1da4fa9b2c73a10a44.camel@microchip.com>
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
         <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
         <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
In-Reply-To: <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB7524:EE_
x-ms-office365-filtering-correlation-id: 86d51b20-508c-408f-5adb-08dafad27ab0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ToFT/XZWNrcUBOI4MhwfxrVR2xfw5WbaGG+ENg0Wd41q/ijUzGX7a9OYnvrJunoFZZqFPLG127a9js26pQzBGNWKXwEZ738nwAwCNIMkXHnRUap9oH3bifuf0OQCjVsnXVyoo0nj7gDRZBPH7K5CPbniDoc07J3dTCAg7ZV1XP8C7W4YeRizOazb7WGx94MBLT0IsYyiq5VE0IOZFc5Lw1vQYX9dW4Zm5OC/bp/f3H46HzBsRGAs439IxLuBpWSIkOYuYPjUzANw16h923izNLBdH8vT0DiSmCVR0ox3pshrsCFeyE+Aykz0c0SlrSGHhjthVURlIRi2WJ6HnYBC7Waiaxak6JLb1VE09ZZseQkRs26mbq0DW/Th+ip4Yb6KIoxyFF0N8gskYmTpN6DSITldj0O3g/BZVigbm8Llz5zSIOx+SIPyH4d7b9paToX/IVqN/1WtYCK821Ls63V7f5fFW0Tc1l3+3+yuzAJNWr9usPGPtULxG+NBbHfCV+VUQPZiyFtm6AMa4sBPg6woWWiAP7SOH7XNOHJa+/NZv7xO5ZZli1WaIbP+Ll1gSjEFLMClZ/v6cESLUNDogWV5rxke6dw11OOOdGOdMkPZSG0PJkcC60YVtbZfktPm+dc4KUqO+zjD1Eakfj8yVRYKV/s8aZxvk9L7WzMIum3Rp51HnM3zF2t2wqZ8Rdw+JK7sxSMul7ADgsG9ypgR/9TYfxtJJqs/0dKU77w66iyYcuYENxJoq9XukER8aG2wnGf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199015)(36756003)(66446008)(4326008)(5660300002)(66556008)(64756008)(41300700001)(6506007)(66946007)(53546011)(83380400001)(91956017)(7416002)(66476007)(76116006)(6512007)(26005)(186003)(966005)(478600001)(6486002)(8936002)(71200400001)(316002)(86362001)(110136005)(54906003)(2616005)(38070700005)(8676002)(2906002)(122000001)(38100700002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDRIQmFRWmFiL2hoN0ZJSktNNktsTkpjaXE5Y0tVY1d6eXFSVHZFR2FpOTc2?=
 =?utf-8?B?eEcrOWI4TnR3RWRtelhEV25xU2VyVlBrS2dKM0kyMXFvcko4RlVHK3FaSHRj?=
 =?utf-8?B?dThicW41ekllQitiQW40bkUxak1oSlFVS0U1bzBUNDVrdklJV1R0SXZNZmZm?=
 =?utf-8?B?SkNMYnBBYXJqcW1YVUo4L3hjaTlrblRocTBZcmx1L3NnNUtpM2RlVHJZSkxr?=
 =?utf-8?B?KzF2THdVN2cyRGF0aTBZY2dtQzhTK1UzUEJXNnQzV1FUWVIxY1hNblhQb0F1?=
 =?utf-8?B?WjFzSzEvWVBKMGp4S2VBa09UU3FDZkkxWWMzRkxPcFU2eU9wR2NrdUFwb1FB?=
 =?utf-8?B?TUg5Mlg4dEFhTWt3V3Vpc0cyeS8zZHRlOGk4VlB0ZGFUNlJPQUM4Z3JTN25R?=
 =?utf-8?B?ZmdVazFSaHJGeWRpd3pWVWF2dnRHT1BpOEZNc3BlbUM3dGIrRW44RXBsRkMv?=
 =?utf-8?B?cHlwZlFCdkVoVEsyY3FvQml4WGpwdW1QVDl1Q2Y4WU5Ob2dqaEV3SUM1Yktx?=
 =?utf-8?B?ZUErcVVwOVFFQmx3OERJSWh0ektZMjd3b210NTIyK2ZRbm8ybkluS29Dcmlw?=
 =?utf-8?B?UWR4RHpONDc0YlJWRE9DMFZkNDd3WEhiV0RLc1E3cFoyUDlqdzYyOWQ1SWtI?=
 =?utf-8?B?aXE0TFlNWXRmV0pVWXBlU09SSFZqTzVNYS9oQWNiT2RicFBmaks2Y0RDMjNs?=
 =?utf-8?B?czNSM1hmUTF5cG5tUVllbm43M3BsQ2hPMStQaUNrdmljS0tXSVdCVFhKelZo?=
 =?utf-8?B?Q0xQYVVmemxaZFZBVldobUVTM3JuTU9tYnV5dUhzcTBmenh6S2JIRnFDS0dH?=
 =?utf-8?B?UHYyOXIzUE53T1AvTVEybmg5OFVNdkdKUlFYa2NYMTBKdkdEVVdjRFRhVnBK?=
 =?utf-8?B?ODBWKzk5U3JRWVZCRjdYOWlkY2FIdGZCb2RiTHpmMVl1OEMvL0pBcUZlZVVs?=
 =?utf-8?B?Q2w4cHV3bWxpSXpraks3ckp6cU93eStPaFlwMUpJN0x3N1lPNHJGNXo1OFc1?=
 =?utf-8?B?cE1rb0Q2WHg4K29IcENnM0I3SzZkN0hFdHdxQmNSTDk3S1lUYWp6VmxGckZz?=
 =?utf-8?B?M3NxWkxMa2dmdytGSzBhSmdoMzRDbEtTSHpONXcvWk82MmUramZ1Wk5HQyt5?=
 =?utf-8?B?eWcxSXM5MXE3YkU4azV4UnpRQ2g5d3BPWTJhOU8rQmpENXF3eUZ4TE5pd21q?=
 =?utf-8?B?MGtiRWxrODVhMmhLZkhvcVdFN2pYNThzck9uOFoyUUhxRGNSTzlTYS80cjBG?=
 =?utf-8?B?VEhudkk0Q09DSEovVDdoeXNBQUlubUlaWjBRekNkcmF4eEFWRmpQMjVqd3h2?=
 =?utf-8?B?SUVSMTlTbnVOZG0zQWNoZnBLbk5ERDlxenlyOHdLWG10Y2JkNTF3UGJVcmxE?=
 =?utf-8?B?Z2MvdjYrTU1WaTVFaFZKUVN0WWtKS2dPRmVUbmpGbUFtTlFheW1LVUFlS0dC?=
 =?utf-8?B?Q3NxK0Q2aGdHTzhNK05WRDQ3eUF5ekZ6Qk5xOVhkdzYveTAwY1RZMzlGb0xD?=
 =?utf-8?B?UHJ4amZmaTFGQUpBU2YxWXY0dVdXVzl4TS9FYVRWcGM4VlpjeWJCM2tqakV6?=
 =?utf-8?B?NVE5eWpWb1hoNG1xUldGYTZZajg2QkczTFZwRzFoVnYzaWVMR0h6QkpBdVV1?=
 =?utf-8?B?WkFtWEs2YnBkbU90d2RkOGNaeHFnSTBFK1lMSnd3M050a2tDRkpwZG5lVWly?=
 =?utf-8?B?OURUSDRzR3J5VmN5N1ArUXZFK2NKajRPUENSV1FTL1ZRSlI4U1RqOUpQRDZE?=
 =?utf-8?B?cHFsbkVZTFIzSVZPQzBDVURzOWhrOTVlbXFUZnJFeGxNYS8yQjZWNFNlUCt4?=
 =?utf-8?B?VlRIaUFnaHR4ZjEzKzZPV1dxTWM3UVVKNzFqMERJN1JPek8vWEJ3TlNOb3JN?=
 =?utf-8?B?QlpYMmxUYkJ6VnR3bk9RSVdoaUFyOUlIU2pJNlpiWkIxOC83OG10eUlEdmUx?=
 =?utf-8?B?L1p5cXNod3dPN2NyN1YyK2tQdGF2NXR0cEtXRmM2SERZKy9SQW5MRWpvVFh5?=
 =?utf-8?B?SFExdnlkUzNXc3VqUm4vOTdBakdoMXljemNMZGFGOGFnK3hGclE0R1Z2VnIr?=
 =?utf-8?B?TkNzd3lCdno5ZDlRbWpKMjNrNU9Qemg1N2pPcTB3QStiS205ZXV4TDJiTWV5?=
 =?utf-8?B?S2t4Qzhmd0g2Snh4dFlCTGZiME5DK0NQUXBXenVlbmZMSWc5ekhpbDU0THB6?=
 =?utf-8?Q?5etY+/B0zc0Nwh5OjCg/iDc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A069EAAF7761B94B920F7E4C60E34DFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d51b20-508c-408f-5adb-08dafad27ab0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 10:38:33.4175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +bpoBJ+kTSaJsly+GeEOEdy8Irj0UxztD00z60juozLFXdoFKLxBkxA0GA6eYXBNINsAx7sn6E4LkVdcvkUajoKmqwUT4T7mrLWHnhtJooE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7524
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWhtYWQsDQpPbiBGcmksIDIwMjMtMDEtMjAgYXQgMDg6NTcgKzAxMDAsIEFobWFkIEZhdG91
bSB3cm90ZToNCj4gW1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBhLmZhdG91bUBwZW5n
dXRyb25peC5kZS4gTGVhcm4gd2h5DQo+IHRoaXMgaXMgaW1wb3J0YW50IGF0IGh0dHBzOi8vYWth
Lm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+IA0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhlbGxvIEFydW4sDQo+IA0KPiBPbiAyMC4w
MS4yMyAwODowMSwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAuY29tIHdyb3RlOg0KPiA+IEhpIEFo
bWFkLA0KPiA+IE9uIFRodSwgMjAyMy0wMS0xOSBhdCAxNDoxMCArMDEwMCwgQWhtYWQgRmF0b3Vt
IHdyb3RlOg0KPiA+ID4gW1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBhLmZhdG91bUBw
ZW5ndXRyb25peC5kZS4gTGVhcm4NCj4gPiA+IHdoeQ0KPiA+ID4gdGhpcyBpcyBpbXBvcnRhbnQg
YXQgDQo+ID4gPiBodHRwczovL2FrYS5tcy9MZWFybkFib3V0U2VuZGVySWRlbnRpZmljYXRpb24g
XQ0KPiA+ID4gDQo+ID4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiA+ID4ga25vdyB0aGUgY29udGVudCBpcyBzYWZl
DQo+ID4gPiANCj4gPiA+IFN0YXJ0aW5nIHdpdGggY29tbWl0IGVlZTE2YjE0NzEyMSAoIm5ldDog
ZHNhOiBtaWNyb2NoaXA6IHBlcmZvcm0NCj4gPiA+IHRoZQ0KPiA+ID4gY29tcGF0aWJpbGl0eSBj
aGVjayBmb3IgZGV2IHByb2JlZCIpLCB0aGUgS1NaIHN3aXRjaCBkcml2ZXIgbm93DQo+ID4gPiBi
YWlscw0KPiA+ID4gb3V0IGlmIGl0IHRoaW5rcyB0aGUgRFQgY29tcGF0aWJsZSBkb2Vzbid0IG1h
dGNoIHRoZSBhY3R1YWwgY2hpcDoNCj4gPiA+IA0KPiA+ID4gICBrc3o5NDc3LXN3aXRjaCAxLTAw
NWY6IERldmljZSB0cmVlIHNwZWNpZmllcyBjaGlwIEtTWjk4OTMgYnV0DQo+ID4gPiBmb3VuZA0K
PiA+ID4gICBLU1o4NTYzLCBwbGVhc2UgZml4IGl0IQ0KPiA+ID4gDQo+ID4gPiBQcm9ibGVtIGlz
IHRoYXQgdGhlICJtaWNyb2NoaXAsa3N6ODU2MyIgY29tcGF0aWJsZSBpcyBhc3NvY2lhdGVkDQo+
ID4gPiB3aXRoIGtzel9zd2l0Y2hfY2hpcHNbS1NaOTg5M10uIFNhbWUgaXNzdWUgYWxzbyBhZmZl
Y3RlZCB0aGUgU1BJDQo+ID4gPiBkcml2ZXINCj4gPiA+IGZvciB0aGUgc2FtZSBzd2l0Y2ggY2hp
cCBhbmQgd2FzIGZpeGVkIGluIGNvbW1pdCBiNDQ5MDgwOTU2MTINCj4gPiA+ICgibmV0OiBkc2E6
IG1pY3JvY2hpcDogYWRkIHNlcGFyYXRlIHN0cnVjdCBrc3pfY2hpcF9kYXRhIGZvcg0KPiA+ID4g
S1NaODU2Mw0KPiA+ID4gY2hpcCIpLg0KPiA+ID4gDQo+ID4gPiBSZXVzZSBrc3pfc3dpdGNoX2No
aXBzW0tTWjg1NjNdIGludHJvZHVjZWQgaW4gYWZvcmVtZW50aW9uZWQNCj4gPiA+IGNvbW1pdA0K
PiA+ID4gdG8gZ2V0IEkyQy1jb25uZWN0ZWQgS1NaODU2MyBwcm9iaW5nIGFnYWluLg0KPiA+ID4g
DQo+ID4gPiBGaXhlczogZWVlMTZiMTQ3MTIxICgibmV0OiBkc2E6IG1pY3JvY2hpcDogcGVyZm9y
bSB0aGUNCj4gPiA+IGNvbXBhdGliaWxpdHkNCj4gPiA+IGNoZWNrIGZvciBkZXYgcHJvYmVkIikN
Cj4gPiANCj4gPiBJbiB0aGlzIGNvbW1pdCwgdGhlcmUgaXMgbm8gS1NaODU2MyBtZW1iZXIgaW4g
c3RydWN0DQo+ID4ga3N6X3N3aXRjaF9jaGlwcy4NCj4gPiBXaGV0aGVyIHRoZSBmaXhlcyBzaG91
bGQgYmUgdG8gdGhpcyBjb21taXQgIm5ldDogZHNhOiBtaWNyb2NoaXA6DQo+ID4gYWRkDQo+ID4g
c2VwYXJhdGUgc3RydWN0IGtzel9jaGlwX2RhdGEgZm9yIEtTWjg1NjMiIHdoZXJlIHRoZSBtZW1i
ZXIgaXMNCj4gPiBpbnRyb2R1Y2VkLg0KPiANCj4gSSBkaXNhZ3JlZS4gZWVlMTZiMTQ3MTIxIGlu
dHJvZHVjZWQgdGhlIGNoZWNrIHRoYXQgbWFkZSBteSBkZXZpY2UNCj4gbm90IHByb2JlIGFueW1v
cmUsIHNvIHRoYXQncyB3aGF0J3MgcmVmZXJlbmNlZCBpbiBGaXhlczouIENvbW1pdA0KPiBiNDQ5
MDgwOTU2MTIgc2hvdWxkIGhhdmUgaGFkIGEgRml4ZXM6IHBvaW50aW5nIGF0IGVlZTE2YjE0NzEy
MQ0KPiBhcyB3ZWxsLCBzbyB1c2VycyBkb24ndCBtaXNzIGl0LiBCdXQgaWYgdGhleSBtaXNzIGl0
LCB0aGV5DQo+IHdpbGwgbm90aWNlIHRoaXMgYXQgYnVpbGQtdGltZSBhbnl3YXkuDQoNClRoZSBL
U1o5ODkzLCBLU1o5NTYzIGFuZCBLU1o4NTYzIGFsbCBoYXMgdGhlIHNhbWUgY2hpcCBpZCAweDAw
OTg5MzAwLg0KVGhleSBiZWxvbmcgdG8gMyBwb3J0IHN3aXRjaCBmYW1pbHkuIERpZmZlcmVudGlh
dGlvbiBpcyBkb25lIGJhc2VkIG9uDQoweDFGIHJlZ2lzdGVyLiBJbiB0aGUgY29tbWl0IGVlZTE2
YjE0NzEyMSwgdGhlcmUgaXMgbm8gZGlmZmVyZW50aWF0aW9uDQpiYXNlZCBvbiAweDFGLCBkZXZp
Y2UgaXMgc2VsZWN0ZWQgYmFzZWQgb24gY2hpcCBpZCwgYWxsIHRoZSB0aHJlZSBjaGlwcw0Kd2ls
bCBiZSBpZGVudGlmaWVkIGFzIGtzejk4OTMgb25seS4gQWZ0ZXIgdGhlIGNvbW1pdCBiNDQ5MDgw
OTU2MTIsDQpLU1o4NTYzIGNoaXBzIGlzIGlkZW50aWZpZWQgYmFzZWQgb24gMHgxRiByZWdpc3Rl
ci4gDQoNCj4gDQo+IENoZWVycywNCj4gQWhtYWQNCj4gDQo+ID4gDQo+ID4gPiBjaGlwDQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBBaG1hZCBGYXRvdW0gPGEuZmF0b3VtQHBlbmd1dHJvbml4LmRlPg0K
PiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X2kyYy5j
IHwgMiArLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3o5NDc3X2kyYy5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3
N19pMmMuYw0KPiA+ID4gaW5kZXggYzFhNjMzY2ExZTZkLi5lMzE1ZjY2OWVjMDYgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfaTJjLmMNCj4gPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiA+ID4gQEAg
LTEwNCw3ICsxMDQsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZA0KPiA+ID4g
a3N6OTQ3N19kdF9pZHNbXQ0KPiA+ID4gPSB7DQo+ID4gPiAgICAgICAgIH0sDQo+ID4gPiAgICAg
ICAgIHsNCj4gPiA+ICAgICAgICAgICAgICAgICAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsa3N6
ODU2MyIsDQo+ID4gPiAtICAgICAgICAgICAgICAgLmRhdGEgPSAma3N6X3N3aXRjaF9jaGlwc1tL
U1o5ODkzXQ0KPiA+ID4gKyAgICAgICAgICAgICAgIC5kYXRhID0gJmtzel9zd2l0Y2hfY2hpcHNb
S1NaODU2M10NCj4gPiA+ICAgICAgICAgfSwNCj4gPiA+ICAgICAgICAgew0KPiA+ID4gICAgICAg
ICAgICAgICAgIC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxrc3o5NTY3IiwNCj4gPiA+IC0tDQo+
ID4gPiAyLjMwLjINCj4gPiA+IA0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXgNCj4gZS5LLiAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4g
U3RldWVyd2FsZGVyIFN0ci4gMjEgICAgICAgICAgICAgICAgICAgICAgIHwgDQo+IGh0dHA6Ly93
d3cucGVuZ3V0cm9uaXguZGUvZS8gIHwNCj4gMzExMzcgSGlsZGVzaGVpbSwgR2VybWFueSAgICAg
ICAgICAgICAgICAgIHwgUGhvbmU6ICs0OS01MTIxLTIwNjkxNy0NCj4gMCAgICB8DQo+IEFtdHNn
ZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2ICAgICAgICAgICB8IEZheDogICArNDktNTEyMS0y
MDY5MTctDQo+IDU1NTUgfA0KPiANCg==
