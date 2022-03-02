Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1437C4CA1B0
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbiCBKFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbiCBKE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:04:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F8F606CC;
        Wed,  2 Mar 2022 02:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646215452; x=1677751452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Wzn++lJurRutF5rby/Xewg4HoOmXwfKOXv6PpAME9Zc=;
  b=CLUCvppFrbc0K3ueUt96RxJ7BJVPjrXg8N5A7e9ZbSd9Gv1aK+rNwdCO
   5UpMc76IyKhELbvKtKC1Qyv0zs82BaQCnAPAxzY0hy+tqIWRivDq4nsgg
   jz/taWDaUONHUR2hMTYpzAj3FJZ42XXBZw0ILQ5URYrTL8hgLcOJ3d6ZD
   ++heFsakwmNUROOaL/m3uqGRgMeo6MBcNL2/aANrPBQ35LTu1q2lSDCyL
   ddCaCoVRP8u0Cu0seORAv3X0jHT4gjh9ruOS9uWNN/aWmvfhkJJpALR2Q
   NUfb2vhyjgPornVWkVqYNCblHGrJ5haV9wrnc9AtWFXpRstwBNF4e/mYN
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,148,1643698800"; 
   d="scan'208";a="164196080"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Mar 2022 03:04:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Mar 2022 03:04:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 2 Mar 2022 03:04:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY+IhOYt4OP4RYXBt20AnAFYOMknWhK/oOmJTVW3tF5+8LL3fYvfLjnkk7IaGhHj0/5sFXd76hmfpD7PAJifmyamJ1foeFQx7xf69548fclBq07lKi/GyGTgEeRLLpcWirEXayr/ZVR592KuEuqxczWrKO6FjoUXZBZUgxasvv5d7IUbT6Z0Jy8tudO/0G3lr0ZZsMhRW7HFppxesEjryRMwbXkQNB6hWg9lPCYk/Jg/j41L84E4MWWUWVWQ+sLQF2zsiBg45eyiQCyhGq8sKLXBVsJ1ZCwE5qJgYGaNm5PlBvqXNW+ibNFQ8nKcTglF3hoJfyVSdCBskyg7VJ+gdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wzn++lJurRutF5rby/Xewg4HoOmXwfKOXv6PpAME9Zc=;
 b=NSuNH2p9yGnSpFl/H9kCKG6loOZePFrDcn4492PNmQ/aPPhrpAPqogxO6g8kXS2YKMzmsu4stO6xw6O4zHOzkRX2f9E8CHyD6I6jkIEhF5Ti9iJ2RN0/u2PJ8+mEDBFWJfzfEc7QuhfUdSUKpO5n849J9azm0FJzgemysnedHkcoHX2EvaxiyA5R1bgTJ2UTkhD3DTaxKjXs71o1Cch2cc5lmhwIPOfgBRPO+hVAfRcxdJ57DKGNZh6vKq8iDwjqsnDI45fqYOqaU3Y8269fAE/Z7MfTxAD15McslUKV5V5//xLgGiy2YhBLpnAwub1DSi4bh+gRelmJRpuID1iOTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wzn++lJurRutF5rby/Xewg4HoOmXwfKOXv6PpAME9Zc=;
 b=dl6DdRbEaPCiHGfLfrCyipcHoT29am7wFeVH2/Ysu0I27gOqfloy0LlXVjIz1Xpc2mNlgNdP6irSD73mYoUOnixbT631XdC+u0dbmQYP1Qeiu6tVY0atI0uI7LxPm7qBtto3ClUljm2ULEQjb/4XJjpK2AmqAk/nsaSl3vHnwWo=
Received: from BN6PR11MB0067.namprd11.prod.outlook.com (2603:10b6:405:62::33)
 by DM6PR11MB4659.namprd11.prod.outlook.com (2603:10b6:5:2a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 10:04:07 +0000
Received: from BN6PR11MB0067.namprd11.prod.outlook.com
 ([fe80::f9f1:3d24:83ad:d748]) by BN6PR11MB0067.namprd11.prod.outlook.com
 ([fe80::f9f1:3d24:83ad:d748%6]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 10:04:07 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next 1/4] net: phy: used the genphy_soft_reset for
 phy reset in Lan87xx
Thread-Topic: [RFC PATCH net-next 1/4] net: phy: used the genphy_soft_reset
 for phy reset in Lan87xx
Thread-Index: AQHYLeROcUXYFc5aiUylnSi5/LGqxKyr3ekA
Date:   Wed, 2 Mar 2022 10:04:07 +0000
Message-ID: <a7c3b0d4a8001146b774a4b831be860afded533c.camel@microchip.com>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
         <20220228140510.20883-2-arun.ramadoss@microchip.com>
         <Yh7iJpT0H1+3RncS@lunn.ch>
In-Reply-To: <Yh7iJpT0H1+3RncS@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0654d1bf-2e7f-406e-d0e2-08d9fc33fd34
x-ms-traffictypediagnostic: DM6PR11MB4659:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4659F6EE66809B0870B4E4AAEF039@DM6PR11MB4659.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2aGCi01Myx4j/GbUvwMLZUXQfPdq6txfGFs37eEMP+1//gnoEY3UVeoAsFToU59bFjMEkl2pm3Y1/5HSuLajb9pJGwqo14qnA8y7tVxeJqmWHlwtku2iBLUccpNKztWUQv+YGiVsBv5uAWuIg6p6W0D7t6R75Z+wBBbYtRKXyYISDv2SURW1/zGLRrzI7uDhGzvTpthRV2mVMphNpLUrkPzlvcQ4DV+sJZs+Z+D2NRfiq7mfkyuatHpFvuQt5/NO6flZO75qajMnxEkCvp5rtuRh/RCHkh6H5XKyHd9i/ndDhZbSSYXyczAFekKQTnOs3kMASYoBXVo/n0wi/1WtiP1lyh6RChBzPsJg12dN68WcySQjM30WZufF8P9hMqAHP2qub6wnUNl17VGcNIqjq70pP6hXc2Bo4PmxajJc59X9iYwNaM7odq17CPq+tNmMcLi/Sc2sWxOCzuCPPDLC2pcE6sVYJI2ru2/ftFWfB7N9ot8Q+G9046b3nCeX0q23a+MHweg8C2O2l8XDYGP5j0ibmWhGJ8zXl5/UgsjI502oJKmEpGSIabSLVTyIi2cIqBdKbpX49wg8RbDrvsTdu0w0fQe5bwW4PHPgv0owLKb0etkoAqvOHA4GcibBXYYecEMzPs4TnvVnetupa333d+Fl7UZywaAKnWI8dqt+Hdii4ndo8MXFhqUsn7feq9rXVyTpVp7Sj6W5du+XpCvV0N3qMgFnxmnqMI6XYuVbpNE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB0067.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(38100700002)(6512007)(122000001)(55236004)(83380400001)(186003)(2616005)(26005)(5660300002)(6916009)(54906003)(316002)(8936002)(71200400001)(6486002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(508600001)(36756003)(91956017)(66946007)(76116006)(86362001)(38070700005)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjQ3YlRxOEpXVjRRbVIvb2U2cUZkd1Vkeno1S2dPVGhVZmVqR1gwdEUyQ2hF?=
 =?utf-8?B?QjlFVTFkbUppdDJYWFR4OCtOcXFZdUJidDFHRittSEZiNEpBWUdHbk1nelpM?=
 =?utf-8?B?WVBGSlFvR3o3T3R3YXBhZUNmSDc0T0NEcXU1WjFUNlphT2lqSTZqRGRDdkdi?=
 =?utf-8?B?MXpFQXhFanM1WjRNeG5ZU3liRDREdHNBTGNxSnAvUElLU293T0F6dThtUHda?=
 =?utf-8?B?V3AvSlpnV2QwSHRJQUlQck16RXozeTFTMDdtZE1CM0hjZjhTajJsYmp0U0U4?=
 =?utf-8?B?bU0xMUhTcmdBRy9HUGk0bkRKMHNTWmJMSi9pTGRidTRvQUhla3pxWGNiUi9C?=
 =?utf-8?B?ckJhVTIzdVlqWGhaTi93b0p5aFd6bkZKalBkVEVZeDdiRFBSZ2Qxdnk5SjhC?=
 =?utf-8?B?Z3Q4Qjh1VnRWTEVmZXJMR3QzMDBIK21wekFtamsyMXAwTTV1eDdKWWw5dWow?=
 =?utf-8?B?SXlldWFkbVpIVDRPKzVHZ05ZNEdkVVhOS0NrclArakFUN2p0ck9xb1lYaENv?=
 =?utf-8?B?OWtwU3JpbnNGbnNrMk1sVWVWTFV1UTlhZ2g3WWd6LzNLZllLbi8wY1A2c24y?=
 =?utf-8?B?WXBpVHdIZkhDYldmUFNJeEczcFBXczRzWGNBVDROSENhNHIyOW1ZTU1TUWdK?=
 =?utf-8?B?cnNSZk9GdjFEM1A5YmtxUlp3QVdlYWVnem5QMWZjUXB3dEpWcGkyUjQ0dThG?=
 =?utf-8?B?U2NOWEZuMmxRVngyUllqRmNTSUprTDVJZzkyMWl3QXltMUYweXJCMjFHMytJ?=
 =?utf-8?B?UGpQNm9sa0V2UW80WHJrbUx6ZHNaaVJkU2F4TEtXRkN3N29NODZVRUF4cStM?=
 =?utf-8?B?RjFLWWcyTk9YUWk4eFFucGJsUUdPN0cwQkVEY2NZL3pRWnVudi84WlJBMVdv?=
 =?utf-8?B?OWgrdUhNNC9ld2hYRUNLdzVOSDdXOS9KKzZMTGR2NFZuSUFlczhlTDQrRWVB?=
 =?utf-8?B?cHUrT2didGJvNjE3TFVFTHQzK3ZCQkc1Nk1DNGpGdEd4QmkrL01XQ09NR1ZS?=
 =?utf-8?B?WDJBSmo3Z2xCbEVJSm5IcjRHTjZjNUVsbXNKOXhUOXM0RGhTUEE3aHI3VVV4?=
 =?utf-8?B?RXFmK2Zkc3VQNUdSK3dxdHBseXlJSzd6Nkt2ZTdROG1GV1JtOHU1VWdpc3lo?=
 =?utf-8?B?WnpISm1ldzRpWXZFbWZkY1FJS3p6Sk5EZkJDNHhoQUVwSEFXanhTVW5Oc2gr?=
 =?utf-8?B?MzdiVFZhbGtuaGlRNE14Uk81NmR1MFZSN2xiSWFkMmhPc21rUUoxTXUwMmRY?=
 =?utf-8?B?S1plWmMwV3JqMlRVUm1lUHhJSUxaNDJXTTlvQkNURHBVTzZjT3ZZTnFVckll?=
 =?utf-8?B?YmJIa1BhT3dOODQ2eE85RTRDTzlvT09RWjVVaUNWZk9nTStMVmlyV0NRYlpX?=
 =?utf-8?B?Q2FIN1B5cU5xYi9IT0dwVktpYlpHYmx6anUyUWhua2VLOUJtL1Y3Z3lrVWxR?=
 =?utf-8?B?S0g4cFNHYnBsZUw2Y0ZpZDB2RXltMUxaSEZiUTd3bWltaEdzOU4vaGQ5dmFE?=
 =?utf-8?B?TFBCeGt1WXp4TnNFeFU2VGRnMW93T092aWtuY2huOHI2eXp5dW9xamU5S2N0?=
 =?utf-8?B?T2pEcGJOYmxpUlFzQ2gwZEZwakpXTEovb2VYMm4yL3lDSmJEaUJuT2hxenBQ?=
 =?utf-8?B?d2pVaU8zS0kzN2dlSjIvOXRtTHFWS29VRnVYeFJJZWhVTEF1eUlZcDlqbnRi?=
 =?utf-8?B?aUZnbWZzWDloZEI1WEk2WjlKQ3gwTHdTSGVYbXhyZ3JtTzA4WUZaME1LTGJ5?=
 =?utf-8?B?a29vK2xiTVB4b0J4cGlTYlBaMmM3Mmp6UTRldENQUlVjNmZ4Tm8yb3diRnh4?=
 =?utf-8?B?QkhEL2ZYdkc1TU9ja2ZLT0d2bmw0bk5DWFQvaWZpWGdDSlZic0RDUmFDdHhV?=
 =?utf-8?B?S2czUDN1UkYxQnRibjBtcEliVHRDQzNqUGR1TEhZNXRPbDRteDFQYjRSOURt?=
 =?utf-8?B?RUJxVnpneGV5T0p3WVgyaWNCMlVCL2paVG5aMWY4RFllL2VRQ0pzMXlkZ1FY?=
 =?utf-8?B?ZWFiZnZMellNVFNwanBzTHR2ODB0K2VHUWpVVlRCUVErQU1Hak9CaDB5VDEw?=
 =?utf-8?B?bXFQcTlYaFpnQ2pHQUZUUDdYQTAxVTJlYmo3b3BQV2JSUlBISlNKeUh3TEtk?=
 =?utf-8?B?NkJvcDZxVHlDYlZDNVBJZkJPUnFRUHBVWktMMGJySS9rTUlrNjhXejF4WSt4?=
 =?utf-8?B?U2pqWVFUd0V4NkY5c3BEcjNsSVU3SmVDQkkrNzUvekdyM3k0bXlKTnBxQlVt?=
 =?utf-8?Q?vasggFvOdp7exml+u4fiAqU19wvC1ljfQfVHehEW4Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E6F707C0E194344A5C2AD82145EB45B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB0067.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0654d1bf-2e7f-406e-d0e2-08d9fc33fd34
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 10:04:07.0327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diqf5SMtnw+3EllhbfNtrSHbC6Shprr7tzu+KsBF86d2Fit5HEAVo3TlTMK6oRbDF7b0t+iuUgdaKilaxlXcEi45OS+CFnL3W6ExqYOkXDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4659
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTAyIGF0IDA0OjE5ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBNb24sIEZlYiAy
OCwgMjAyMiBhdCAwNzozNTowN1BNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+IFJl
cGxhY2VkIGN1cnJlbnQgY29kZSBmb3Igc29mdCByZXNldHRpbmcgcGh5IHRvIGdlbnBoeV9zb2Z0
X3Jlc2V0DQo+ID4gZnVuY3Rpb24uIEFuZCBhZGRlZCB0aGUgbWFjcm8gZm9yIExBTjg3eHggUGh5
IElELg0KPiANCj4gSGkgQXJ1bg0KPiANCj4gUGxlYXNlIGRvbid0IG1peCBtdWx0aXBsZSB0aGlu
Z3MgaW4gb25lIHBhdGNoLg0KPiANCj4gTG9va2luZyBhdCB0aGUgYWN0dWFsIHBhdGgsIHlvdSBo
YXZlOg0KPiANCj4gPiArI2RlZmluZSBMQU44N1hYX1BIWV9JRCAgICAgICAgICAgICAgICAgICAg
ICAgMHgwMDA3YzE1MA0KPiA+ICsjZGVmaW5lIE1JQ1JPQ0hJUF9QSFlfSURfTUFTSyAgICAgICAg
ICAgICAgICAweGZmZmZmZmYwDQo+IA0KPiBQYXJ0IG9mIG1hY3JvcyBmb3IgUEhZIElELg0KPiAN
Cj4gPiArDQo+ID4gIC8qIEV4dGVybmFsIFJlZ2lzdGVyIENvbnRyb2wgUmVnaXN0ZXIgKi8NCj4g
PiAgI2RlZmluZSBMQU44N1hYX0VYVF9SRUdfQ1RMICAgICAgICAgICAgICAgICAgICAgKDB4MTQp
DQo+ID4gICNkZWZpbmUgTEFOODdYWF9FWFRfUkVHX0NUTF9SRF9DVEwgICAgICAgICAgICAgICgw
eDEwMDApDQo+ID4gQEAgLTE5NywyMCArMjAwLDEwIEBAIHN0YXRpYyBpbnQgbGFuODd4eF9waHlf
aW5pdChzdHJ1Y3QgcGh5X2RldmljZQ0KPiA+ICpwaHlkZXYpDQo+ID4gICAgICAgaWYgKHJjIDwg
MCkNCj4gPiAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4gPiANCj4gPiAtICAgICAvKiBTb2Z0
IFJlc2V0IHRoZSBTTUkgYmxvY2sgKi8NCj4gPiAtICAgICByYyA9IGFjY2Vzc19lcmVnX21vZGlm
eV9jaGFuZ2VkKHBoeWRldiwgUEhZQUNDX0FUVFJfQkFOS19TTUksDQo+ID4gLSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAweDAwLCAweDgwMDAsIDB4ODAwMCk7DQo+ID4gLSAg
ICAgaWYgKHJjIDwgMCkNCj4gPiAtICAgICAgICAgICAgIHJldHVybiByYzsNCj4gPiAtDQo+ID4g
LSAgICAgLyogQ2hlY2sgdG8gc2VlIGlmIHRoZSBzZWxmLWNsZWFyaW5nIGJpdCBpcyBjbGVhcmVk
ICovDQo+ID4gLSAgICAgdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDApOw0KPiA+IC0gICAgIHJjID0g
YWNjZXNzX2VyZWcocGh5ZGV2LCBQSFlBQ0NfQVRUUl9NT0RFX1JFQUQsDQo+ID4gLSAgICAgICAg
ICAgICAgICAgICAgICBQSFlBQ0NfQVRUUl9CQU5LX1NNSSwgMHgwMCwgMCk7DQo+ID4gKyAgICAg
LyogcGh5IFNvZnQgcmVzZXQgKi8NCj4gPiArICAgICByYyA9IGdlbnBoeV9zb2Z0X3Jlc2V0KHBo
eWRldik7DQo+ID4gICAgICAgaWYgKHJjIDwgMCkNCj4gPiAgICAgICAgICAgICAgIHJldHVybiBy
YzsNCj4gPiAtICAgICBpZiAoKHJjICYgMHg4MDAwKSAhPSAwKQ0KPiA+IC0gICAgICAgICAgICAg
cmV0dXJuIC1FVElNRURPVVQ7DQo+IA0KPiBTb2Z0IHJlc2V0Lg0KPiANCj4gPiANCj4gPiAgICAg
ICAvKiBQSFkgSW5pdGlhbGl6YXRpb24gKi8NCj4gPiAgICAgICBmb3IgKGkgPSAwOyBpIDwgQVJS
QVlfU0laRShpbml0KTsgaSsrKSB7DQo+ID4gQEAgLTI3Myw2ICsyNjYsOSBAQCBzdGF0aWMgaW50
IGxhbjg3eHhfY29uZmlnX2luaXQoc3RydWN0DQo+ID4gcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+
ICB7DQo+ID4gICAgICAgaW50IHJjID0gbGFuODd4eF9waHlfaW5pdChwaHlkZXYpOw0KPiA+IA0K
PiA+ICsgICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICBwaHlkZXZfZXJyKHBoeWRl
diwgImZhaWxlZCB0byBpbml0aWFsaXplIHBoeVxuIik7DQo+ID4gKw0KPiANCj4gQSBuZXcgZXJy
b3IgbWVzc2FnZS4NCj4gDQo+ID4gICAgICAgcmV0dXJuIHJjIDwgMCA/IHJjIDogMDsNCj4gPiAg
fQ0KPiA+IA0KPiA+IEBAIC01MDYsMTggKzUwMiwxNCBAQCBzdGF0aWMgaW50DQo+ID4gbGFuODd4
eF9jYWJsZV90ZXN0X2dldF9zdGF0dXMoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwNCj4gPiAN
Cj4gPiAgc3RhdGljIHN0cnVjdCBwaHlfZHJpdmVyIG1pY3JvY2hpcF90MV9waHlfZHJpdmVyW10g
PSB7DQo+ID4gICAgICAgew0KPiA+IC0gICAgICAgICAgICAgLnBoeV9pZCAgICAgICAgID0gMHgw
MDA3YzE1MCwNCj4gPiAtICAgICAgICAgICAgIC5waHlfaWRfbWFzayAgICA9IDB4ZmZmZmZmZjAs
DQo+ID4gLSAgICAgICAgICAgICAubmFtZSAgICAgICAgICAgPSAiTWljcm9jaGlwIExBTjg3eHgg
VDEiLA0KPiA+ICsgICAgICAgICAgICAgLnBoeV9pZCAgICAgICAgID0gTEFOODdYWF9QSFlfSUQs
DQo+ID4gKyAgICAgICAgICAgICAucGh5X2lkX21hc2sgICAgPSBNSUNST0NISVBfUEhZX0lEX01B
U0ssDQo+IA0KPiAybmQgcGFydCBvZiB0aGUgUEhZIElEIG1hY3Jvcy4NCj4gDQo+ID4gKyAgICAg
ICAgICAgICAubmFtZSAgICAgICAgICAgPSAiTEFOODd4eCBUMSIsDQo+IA0KPiBBIGNoYW5nZSBp
biBuYW1lLg0KPiANCj4gPiAgICAgICAgICAgICAgIC5mbGFncyAgICAgICAgICA9IFBIWV9QT0xM
X0NBQkxFX1RFU1QsDQo+ID4gLQ0KPiA+ICAgICAgICAgICAgICAgLmZlYXR1cmVzICAgICAgID0g
UEhZX0JBU0lDX1QxX0ZFQVRVUkVTLA0KPiA+IC0NCj4gPiAgICAgICAgICAgICAgIC5jb25maWdf
aW5pdCAgICA9IGxhbjg3eHhfY29uZmlnX2luaXQsDQo+ID4gLQ0KPiA+ICAgICAgICAgICAgICAg
LmNvbmZpZ19pbnRyICAgID0gbGFuODd4eF9waHlfY29uZmlnX2ludHIsDQo+ID4gICAgICAgICAg
ICAgICAuaGFuZGxlX2ludGVycnVwdCA9IGxhbjg3eHhfaGFuZGxlX2ludGVycnVwdCwNCj4gPiAt
DQo+IA0KPiBXaGl0ZSBzcGFjZSBjaGFuZ2VzLg0KPiANCj4gWW91IGNhbiBhbHNvIHVzZSBQSFlf
SURfTUFUQ0hfTU9ERUwoKS4NCj4gDQo+ICAgICBBbmRyZXcNClRoYW5rcyBmb3IgdGhlIGNvbW1l
bnQuIEkgd2lsbCBrZWVwIG9uZSBjaGFuZ2UgcGVyIHBhdGNoIGFuZCBzcGxpdCB0aGlzDQpwYXRj
aCAmIHJlc2VuZC4NCg==
