Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99287622EE8
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiKIPTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 10:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiKIPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 10:19:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFAFFCEB;
        Wed,  9 Nov 2022 07:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668007182; x=1699543182;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C/r+EwnmVRJ8qVYCY0zuvkTvVXLUDBzKRb6Rv6xMpKQ=;
  b=nMa1IwTRolscxc5jQKqhlnACcjutaXddUbf3HXL7kWHZ2l/LrWa4ms3R
   arIUpTyeYzuIpMlDYZB9NmR+C33XNqpIiK1O0xw95Zt7I2bthuNWpLK+9
   xsuDkIwhD6RCr/HTuafWM6zmyCGwL1pTNXawSwksrCrsgkInFj1YObDC8
   eZfi9xWshN5C5aqVLb4OGVXDRO5++gVdPTkbZeVxEblKNQBfiYjptGhFc
   oroYYj1O2dQXUzCxxMyakvr6oTKVOrprxVCLHi2RSfBHJOV61Bqenrp5E
   Vql+xPNjxVO+uh6Nq2L7dDqvN+TFpo274pp2c7TLDHfb60HhzGNNk25/3
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="186143795"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 08:19:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 08:19:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 08:19:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf70ylPdRrvuSv0s1uT5bPudYZZCKQRl9uAEiAjiOSA5v0kHUPWawyhcVRVdBvtYwIrMVfLqHI9DKNPuZ0WzF4JQ31p20EX3cbrN0V3uM94kTgIKM3ZThzTvn6Nx8Z3NWt1cLn5p7ldYfVmJcQToo+wHPmrY/sPXKdFS4FabbofyNWicpndehEHVssyuHd501U0rQ1ABze8DkQ5JJLnXmafgn4bV5d3iLkX4otLV57oPGr0edv5aOXQHkaD6Q4c96zXnQRwvnXeCrrOtjO9FFZFTGgDKTHcsdVAEhY0jZ35dgfz3zJruk/xI8OSJEpTEiXnSseemmZ0JDgBBpRegvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/r+EwnmVRJ8qVYCY0zuvkTvVXLUDBzKRb6Rv6xMpKQ=;
 b=n0nunuwM4rQfa/+re13iJTg0kBk+b/aK7YyDeKPiWypNsBrK+iKoACvgSrLmKMBVxGNiy4AjJV6RO6YeQ9Zh9Qqa2Jp0IHuGWzfcQmtXtGXkrLboCzErDQcBG1JQ6eEP14E4A86ImGWQe1TQ4pi+rNQOqfS+idROJGy5ekfEenAzN8m8jcRai8QFxjkIMT4CIHGKUoRuCwQVPbyT0j6Hi/dlOeUVj5ptn/zjG05271o0alyZm3bOiZUxvB8lQRP42jOnKFSKiQRMYKQQ0ss57/MuqV+my7H3OgQ1lC589FoFF+DxJvUe7Y1HANknF3n/ARRcNTa8x8mM0YptxojiCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/r+EwnmVRJ8qVYCY0zuvkTvVXLUDBzKRb6Rv6xMpKQ=;
 b=uLBf1MMQtzmGwUzoO7jNSzspSJIi21Kqug7BDQoge5Y63g/xyR7yWEGU9lStKxuAYwpiqWwEfMOvqV9nbMGmZMW3Ylp19HA9o1QN+z/Vyv8GlnIIO43xZ5KtbsWWrNtam1JItC35sHzaR2C8lrx8GWNDEtAdiCVuZthZ3ZnvFHg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH8PR11MB6707.namprd11.prod.outlook.com (2603:10b6:510:1c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 15:19:36 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5769.021; Wed, 9 Nov 2022
 15:19:36 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v3 1/3] net: dsa: microchip: move max mtu to one
 location
Thread-Topic: [PATCH net-next v3 1/3] net: dsa: microchip: move max mtu to one
 location
Thread-Index: AQHY8zUpOghuveeh0km7okG2TkCYTq42tu+A
Date:   Wed, 9 Nov 2022 15:19:36 +0000
Message-ID: <40adce4bb17a90ead75bf216d61b157f7d40fc0c.camel@microchip.com>
References: <20221108054336.4165931-1-o.rempel@pengutronix.de>
         <20221108054336.4165931-2-o.rempel@pengutronix.de>
In-Reply-To: <20221108054336.4165931-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH8PR11MB6707:EE_
x-ms-office365-filtering-correlation-id: 7b40927d-c56f-4c53-c177-08dac265cfef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ffpumpj5cIn01MmagQiHIbN/7sTTN03H2VoBeSPExu+l77I1esrF0zY9S5BTcp4csgQh4izamurtYg4srd/dd4nxI3lvUVDlkBACD6k8H/ThZNQbLS8qGy/GpFUvo/ALaqXz7AYZFhgttrb7pnajs2OXLkYD6qeKjeV4/Mn5ra11yZQ6tW27J6i/9PEEN6wvY3RRboWrjXTMcrgHYsqeZwQFC+0NUAes45EnnZBba5r828anbcJ4TIRTxrQ4iFx99a9xRAvoww+04LgyQ5DtUvbCMPdWNtRJ24QK7XGn9Il9Qvc6TGVQ8xRE6hVmFiv5NsLrUfoJOIO2yOavpvL3BAUjKgS88nI8gl/Xs85WQUefXmles2iFtPArxM+nkg2aQmFWYxFirp0YoFi/4xZY1n/aslNISphUKHq0xLGO4g3Ysz+QuPorQbrQhN167mq3ZyLeYqObRph25AdpuFx3V1ePpb2kP1FqhusEAn+qnbPidD7X0zkFF7rphR57NMhV6xeZ78+AeAfkvSky8g4me8btRJA6k2CbAdzGLIPP/Wr9Sz8aNO15OjPZdQs0nzIWBtW9CFbAwrQ1CvTZFUiXcrUY6egwgaoSpDnyQvVXOssgGIa9MhXZrnNzEr0NbgxsJcCu6XTfZDfoaVMdjGVAff6l0uK+dFX9NVB7p29MZ1aQNyH3vGhVbQT/6FgMVSgeWYkIstwjfD7/NI4WxUYJ+BgMsuPlP898jq2b3MBTMWXbuJmKgFoimyzIEt1WntWElD4fB2Z5RRZKQSOkXxL62O7hU/5N6qFCex7TrR6kPs4Zitr8QuEidarilYGauJJdVNdzkQyzhUBzSkKT6kY7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199015)(110136005)(66446008)(86362001)(66476007)(76116006)(64756008)(36756003)(54906003)(71200400001)(38070700005)(2906002)(83380400001)(66556008)(7416002)(8936002)(41300700001)(8676002)(186003)(2616005)(316002)(91956017)(921005)(66946007)(6506007)(38100700002)(122000001)(4326008)(5660300002)(6486002)(966005)(6512007)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clpZdTdQdGRmUFNvZENULy9DbmRJamNqNzVkNHdDZW1YTUdlK2trb0piYnIy?=
 =?utf-8?B?Z2tFeHdnUk9mcWFrbjdJdGJST2pQV0FWbGlmSWV2OEdoOFRPenBHREczWHlv?=
 =?utf-8?B?V0Jxb2hidjVRNWZrTTF0aFloMXhOOGVXOVl2eGl0ZDBJNys5eDN2UWFWaito?=
 =?utf-8?B?bVVscE54NGpUOUNVcVhxWGk1YjZ3Wjk1eGhIV1N5cTZLYmRhMDQzdWdlQWFu?=
 =?utf-8?B?NWtFK3lFYzZLaW9BWjFzRkpWZGFneElqbDNrUEtsTVI0eldhLzRYTldSNUha?=
 =?utf-8?B?bmFKSlMrVVdXMDkyVTdTcUFucmZrWXc1cDJhOTZuY3UydlhBL2JUMG5pY0VD?=
 =?utf-8?B?cWszY0tCOWhQYlVxUnp2ZmlNRDE3YXluSDNacnh3NDh1YmlzRVZDNWF2aWJX?=
 =?utf-8?B?NHFPU1ZObnlTRS9DMnBLQ3VDVHdLSDR4QVFHWjQ1bmtxdEs5Wkdnei8zb2Zq?=
 =?utf-8?B?bG9zbDdrRlhneTBJMThxcGNHcm84cmp5OXMrTTRpMzJSQVp1V3dCaC9aK1N6?=
 =?utf-8?B?TGRlczl6cytwUUVhaUZyUmpzMXIvdDd0b2JEZ3lVTEwzR1dKREIwaFlhYmJl?=
 =?utf-8?B?M1dVWklLclUyUTJuWHpJTUlweTgzWm5iUklncU5vVVVML1AxNGFOYXNPaGlh?=
 =?utf-8?B?UExrU3VROEtMN3BPSHhWUktySDk3clZMalJ1cDB0RXZ2c09uczFaYzQ0bkhZ?=
 =?utf-8?B?OUtUdXBmKzRVYmUxM2tPYm1rcFBIdThhMHNaNExFRVB3VllabWhmL1dYdnNr?=
 =?utf-8?B?RkdkaXh1bTBpM3RmT1kwckVBRlVPVWE4VHBwKzRSeWl4bWI5LytGTmQrL0Jz?=
 =?utf-8?B?U2JoblQ1TDVsMHN0MHVxMks4VTFYVEZxSlJqTkNPZE9pTjVUbEU1bFdYd1lz?=
 =?utf-8?B?K2VqSkhlSnpBakRKNDBTUnNxcFVWaERlSUVrcXcra3JraklwbUcraGZ6Qmda?=
 =?utf-8?B?SjBpQXJDU1JTcWcraS9PSlFIc1drNkpVR3dJOHNiZ2Y0RmFWaHg0ZFNMODhw?=
 =?utf-8?B?WWJIaWNra0ZxVTBnc21RcVZBbGp6bStvYzY5U1RtT3QwUlVTV1VMajVwSHV2?=
 =?utf-8?B?TVEzSHFFNzJlL3drQnZqOVNFZDBFbXoxM3BlWXA4dVJmb3dnNzB3KzZFb3I0?=
 =?utf-8?B?SGNZa0J6Sk5UYzQyeGF0N3R1S3lRMzgvbENRU0V5Z010TlJtYnEvLzJCc3VM?=
 =?utf-8?B?Z0RpK2dRdkdXUjRKMG45M2FVRVdWM3loWmd2alJtY04zdElPWlNINlRtOUVq?=
 =?utf-8?B?U3N4bjZ2NnVBNDN0RDU4MDA1SVorUkxidWtuS0JabkRhaE5SS3dpUDFSOVFJ?=
 =?utf-8?B?NDliSm5jVWxyQTA2YTE2UlVzYUZiMUc1SnlrMEVYY2Y2SzRVYVpnTGl0VE5J?=
 =?utf-8?B?a3BrMUdCOWlwVU1GNnY0L3Fzd1NoSTEybWpIS3hTamkrMlk0VDh6R2ZvQW52?=
 =?utf-8?B?ZTB6V3BWc0U3Z1lFNVRaRjNWaEVYbVZZclBCSFpETUdMUGp1Z0FHc1NlTnVx?=
 =?utf-8?B?OGdMb29SNDI0OFZjR2V2Zmt4TjNMMmFpR1dVQ2tjZnRuLytjL3VFVzE4K1px?=
 =?utf-8?B?bVhCd2JBWktYRGF4SDZ4bWFwQ0xwc3hVdXgwTm1xcHlzT0JRSXdIZ0ZhTXFQ?=
 =?utf-8?B?cnZtR1d2Wm1XVm1jZlZWd2NXd2tFRkNxbHBFRENzMmMxdmZTTXBkWFZUTlUr?=
 =?utf-8?B?SHNwVGlRckdFa1Vvem12Vm5hUUtNYnFSbW9XR2dtVFpEeHVYb0JYT1JGUXhV?=
 =?utf-8?B?c0xadVBoNTJEZDBvb2ZkOUgrU0F0dGxEdmFCa0M4Y2hnOWdQTEMyZnBYcThR?=
 =?utf-8?B?czhWdU95Mnp0N3FDSFk3S01nQXVBeDJpM0s4YktvYzhBdW9NTk5XMVVIRlMy?=
 =?utf-8?B?SUFYbldldjdmeERtOVhKVlEvUFE3ejduVC9idEFHTUE4d1BrajRNdnNXc0Qv?=
 =?utf-8?B?ckVhK1FyUk56OEpWTThuVW9kMEFLZkVaUnpBK2J0b2lmQTc3YWYwMG9URjRV?=
 =?utf-8?B?bjIwYyt5R3k1WGd4WDRLaVl6bGZ0ekZnc3ZpN1pEM0lNR1Q0UWl5VWVaaUY4?=
 =?utf-8?B?eE95czMzUXdsVEtGSk5rbDJqYUtDazNVS1lTcUZNQ3NtUDFGaGJNZUxjKyta?=
 =?utf-8?B?QjVkQ0dWekxUMFpESXZ6S2NiTFlRWFpVdHhDUUpHdGxEZC9mVjhIMS9VSFdV?=
 =?utf-8?B?VGxHQjlFQkRRTFdmb09ablhOMWxrNGtNdUxwcW96S0lQTlc1SkJDL0NpSDdC?=
 =?utf-8?Q?AnJIOvEtN4wdVUiA4GoYerWDYk5eRRtpOCmNKO7/jw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <634FA10F4C10C647B4A823BDAD69AD6C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b40927d-c56f-4c53-c177-08dac265cfef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 15:19:36.2272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAq0wVGHTh3rKfJ7+V9Re8EcrwXjZKdc9mZagW11eMfrk3vnMar6GqQADipNvoCppJYH00nfsC9WMtC2+eKWKajrV57Huhm5HHxAnIVOcy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6707
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gVHVlLCAyMDIyLTExLTA4IGF0IDA2OjQzICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBUaGVyZSBhcmUgbm8gSFcgc3BlY2lmaWMgcmVnaXN0ZXJzLCBzbyB3ZSBjYW4gcHJvY2Vz
cyBhbGwgb2YgdGhlbQ0KPiBpbiBvbmUgbG9jYXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBP
bGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IFRlc3RlZC1ieTogQXJ1
biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPiAoS1NaOTg5MyBhbmQNCj4g
TEFOOTM3eCkNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyAg
ICAgfCAgNSAtLS0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmggICAg
IHwgIDEgLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3JlZy5oIHwgIDIg
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jICB8IDIxICsrKysr
KysrKysrKysrKystLS0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9u
LmggIHwgIDMgKystDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDE0IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6OTQ3Ny5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gaW5k
ZXggYTZhMDMyMWE4OTMxLi5lM2FkYjEyNmZkZmYgMTAwNjQ0DQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9t
aWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IGluZGV4IGQ2MTIxODFiMzIyNi4uNDg2YWQwM2QwYWNm
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0K
PiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiBAQCAtMTQs
NiArMTQsNyBAQA0KPiAgI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4
L2V0aGVyZGV2aWNlLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaWZfYnJpZGdlLmg+DQo+ICsjaW5j
bHVkZSA8bGludXgvaWZfdmxhbi5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2lycS5oPg0KPiAgI2lu
Y2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L29mX21kaW8uaD4N
Cj4gQEAgLTIwNiw3ICsyMDcsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGtzel9kZXZfb3BzIGtz
ejk0NzdfZGV2X29wcyA9DQo+IHsNCj4gICAgICAgICAubWRiX2FkZCA9IGtzejk0NzdfbWRiX2Fk
ZCwNCj4gICAgICAgICAubWRiX2RlbCA9IGtzejk0NzdfbWRiX2RlbCwNCj4gICAgICAgICAuY2hh
bmdlX210dSA9IGtzejk0NzdfY2hhbmdlX210dSwNCj4gLSAgICAgICAubWF4X210dSA9IGtzejk0
NzdfbWF4X210dSwNCj4gICAgICAgICAucGh5bGlua19tYWNfbGlua191cCA9IGtzejk0NzdfcGh5
bGlua19tYWNfbGlua191cCwNCj4gICAgICAgICAuY29uZmlnX2NwdV9wb3J0ID0ga3N6OTQ3N19j
b25maWdfY3B1X3BvcnQsDQo+ICAgICAgICAgLmVuYWJsZV9zdHBfYWRkciA9IGtzejk0NzdfZW5h
YmxlX3N0cF9hZGRyLA0KPiBAQCAtMjQzLDcgKzI0Myw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
a3N6X2Rldl9vcHMgbGFuOTM3eF9kZXZfb3BzID0NCj4gew0KPiAgICAgICAgIC5tZGJfYWRkID0g
a3N6OTQ3N19tZGJfYWRkLA0KPiAgICAgICAgIC5tZGJfZGVsID0ga3N6OTQ3N19tZGJfZGVsLA0K
PiAgICAgICAgIC5jaGFuZ2VfbXR1ID0gbGFuOTM3eF9jaGFuZ2VfbXR1LA0KPiAtICAgICAgIC5t
YXhfbXR1ID0ga3N6OTQ3N19tYXhfbXR1LA0KPiAgICAgICAgIC5waHlsaW5rX21hY19saW5rX3Vw
ID0ga3N6OTQ3N19waHlsaW5rX21hY19saW5rX3VwLA0KPiAgICAgICAgIC5jb25maWdfY3B1X3Bv
cnQgPSBsYW45Mzd4X2NvbmZpZ19jcHVfcG9ydCwNCj4gICAgICAgICAuZW5hYmxlX3N0cF9hZGRy
ID0ga3N6OTQ3N19lbmFibGVfc3RwX2FkZHIsDQo+IEBAIC0yNDczLDEwICsyNDcyLDIyIEBAIHN0
YXRpYyBpbnQga3N6X21heF9tdHUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLA0KPiBpbnQgcG9ydCkN
Cj4gIHsNCj4gICAgICAgICBzdHJ1Y3Qga3N6X2RldmljZSAqZGV2ID0gZHMtPnByaXY7DQo+IA0K
PiAtICAgICAgIGlmICghZGV2LT5kZXZfb3BzLT5tYXhfbXR1KQ0KPiAtICAgICAgICAgICAgICAg
cmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArICAgICAgIHN3aXRjaCAoZGV2LT5jaGlwX2lkKSB7DQo+
ICsgICAgICAgY2FzZSBLU1o4NTYzX0NISVBfSUQ6DQo+ICsgICAgICAgY2FzZSBLU1o5NDc3X0NI
SVBfSUQ6DQo+ICsgICAgICAgY2FzZSBLU1o5NTY3X0NISVBfSUQ6DQo+ICsgICAgICAgY2FzZSBL
U1o5ODkzX0NISVBfSUQ6DQoNClBhdGNoIHRvIGFkZCBLU1o5NTYzIGlzIG5vdyBhY2NlcHRlZCBp
biBuZXQtbmV4dCwgc28gYWRkDQpLU1o5NTYzX0NISVBfSUQgaW4gdGhpcyBjYXNlIHN0YXRlbWVu
dCAsIGluIHRoZSBuZXh0IHZlcnNpb24gb2YgcGF0Y2guDQoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGRldi9uZXQtbmV4dC5naXQvY29tbWl0Lz9p
ZD1lZjkxMmZlNDQzYWQNCg0KPiArICAgICAgIGNhc2UgS1NaOTg5Nl9DSElQX0lEOg0KPiArICAg
ICAgIGNhc2UgS1NaOTg5N19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3MF9DSElQX0lE
Og0KPiArICAgICAgIGNhc2UgTEFOOTM3MV9DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3
Ml9DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3M19DSElQX0lEOg0KPiArICAgICAgIGNh
c2UgTEFOOTM3NF9DSElQX0lEOg0KPiArICAgICAgICAgICAgICAgcmV0dXJuIEtTWjk0NzdfTUFY
X0ZSQU1FX1NJWkUgLSBWTEFOX0VUSF9ITEVOIC0NCj4gRVRIX0ZDU19MRU47DQo+ICsgICAgICAg
fQ0KPiANCj4gLSAgICAgICByZXR1cm4gZGV2LT5kZXZfb3BzLT5tYXhfbXR1KGRldiwgcG9ydCk7
DQo+ICsgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAgfQ0KPiANCj4gDQo=
