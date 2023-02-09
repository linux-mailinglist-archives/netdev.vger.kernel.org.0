Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35AD6901D0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBIIG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBIIG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:06:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B0A26867;
        Thu,  9 Feb 2023 00:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675929982; x=1707465982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=161RJVuWhNxjiJKY/c16Jr4uOuk0friAVgIzpmMEJwE=;
  b=XyWttxrlI2D2yNQ6DDsuoHBf6HScIDjg8jcqrAJkHFeaAw8q/CMZgDfl
   xZaDXiEI6M1PL3iqg240c3nWJPu95skOzk5TLKPuiDKpd5QA0qZekbc7n
   acL0Yzzj+GJ7oW25sZ+4sllXswmyGbsQR7aevWeFkVp6nRxpscAiYE3LD
   O0FaLECPeM+KJbeu7fXE6I8Wnhhqv3i+U9ExsfgNN51I4KEbylzIV/Trt
   34dtmxTnRNcQi+moYMLJwBeNRsVCKg3St2VeIzErN/juM19Aa8yS+ob/5
   ZKeNBiIPWqBX/33ld29rEbDTM7H9z+5l+ik2ohpBL4kWFqLgyjXFcdbXm
   w==;
X-IronPort-AV: E=Sophos;i="5.97,283,1669100400"; 
   d="scan'208";a="196076249"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 01:06:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:06:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 01:06:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM5YTsGXeVfoUjkEH9vwQo9rH0BFCSCb8TBzGZUOPGRqsiAcH4pQ7Tp+EYPNXVAL20Y+pN0/wRDqBfM1bMYSKCKDAX5Czcn1obCWO2zQIExM7BR5BJCdzornCR3GcysfqQTxbI0AL4Y8k53Pdsq75s4re6pNxIeytQq8SeHQnNpckCRdp2AzK2tO/S+KPaEZax1QlqkCpvzmCdWSErz2Sj6a9nrb+EEFZavSYxlAFuluk/RuBOyfhP4z9q9o6ua7R3SOublf1Ay27hCgGJlW/gB24bpZ8fLfexQ1Bf8Fwxk5LoO+6Uk7BLAGi1o0Gmp9Mh1bkf5BtNSfvy9LCLxFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=161RJVuWhNxjiJKY/c16Jr4uOuk0friAVgIzpmMEJwE=;
 b=ei4A/qt3IF7pmC5ppT3adGbXJ5ILBHLd2JW+kK5Y5KbqMllbc45OJUXsmrMkWVG+G0w3uJ2NkhEUW1n1Dm6utR2XV6c8+3taBHS5TM3gmDlUpylOaeaVfgpQOJRQSHQUA9r8aD4XX/rTpigxl3sTv0YOQPDFf4dszWDmjirw4ST0EvDzg0UdmmPtOlQIOH7bdHZriPm+NyGcOd8T+iGHPjz2K1STfEZS9fwErl5xsZpbf8H1iEeVwgpVSTs6D5STg0x7HaSTatXVgT6SuKNMMU/fbuT8l3ZHJ2iI2/3QasCQg0wMfbNhjdCM7O798np1j5+1lzAiVfPcV7Ot6SNecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=161RJVuWhNxjiJKY/c16Jr4uOuk0friAVgIzpmMEJwE=;
 b=sLzhSVxDoqzUi0un8qnNcdMvRLVP2SaeRpBrGXuM5wSLl+t4oHppYKx41BdQC4ePbGfSIXrWitglUO8bl2HkkWPsa5Pvy/ZRsLpy+pmx6a5qbwO9zu5nLQvJRKsNRUcI5z7U/j1DcjimDVPGPUKAfAF7w7iOiKg0i/ZoesnMeJM=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA2PR11MB5036.namprd11.prod.outlook.com (2603:10b6:806:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 08:06:14 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 08:06:14 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <wei.fang@nxp.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Thread-Topic: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Thread-Index: AQHZO6i8rQRV75tTjUqi+3V/hQ46ta7GAKUAgAAccICAACZZAA==
Date:   Thu, 9 Feb 2023 08:06:13 +0000
Message-ID: <bd6c90ff8c5bb176567cd07b761a51e691dfe0b4.camel@microchip.com>
References: <20230208103211.2521836-1-o.rempel@pengutronix.de>
         <20230208103211.2521836-2-o.rempel@pengutronix.de>
         <332df2fff4503fac256e0895e4565b68fd76dee4.camel@microchip.com>
         <20230209054857.GB19895@pengutronix.de>
In-Reply-To: <20230209054857.GB19895@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA2PR11MB5036:EE_
x-ms-office365-filtering-correlation-id: 51f036eb-1a0d-4023-21b8-08db0a74835e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wNFgZFuHfuWouFK+hXdL9pg+pASKj3MJZ/h+8PiRzTRYaQmqLJ28q/K49VK8V7i1JCD2N1ZXKbM4i0I28E93kEHM4O2A0RvvPrbrY1gAq0ZQwmTKNHDeLpSrwUQ93Ku8ZCM2v5rsel4hPRwwievqPlImvamhmYDpCueUEsEt+w8txFtWVPSa4a+MI9mQHfoSVwcHIt/jVwIKdk0vPe2tMTHeTx+BqCv+DeUjJ2XoKKm7/TEcZWTn4RgNEl6bicn1p9fTSr8cEZx53+DgkcihVl57Igrzl/dbKFyCFOWgyiZMEovGbIFNmrl7iekYGXuHaqnYTTpkTXY6xAFb0nOILNJLNOUqXGKF23yt1s5tL+b9CiZlmum00fw40f+/mG7pZcwchAqfkFXhPE1F7C572y1C/knW4Ky6Ycq2u4G8g+yVpOErumLbc5tvicu8w5Y/ANDE6J5KdPkTs///JAQbbk/nXdoi+q0Tzvzz1Uk/R3h4PS2PHEQa0dvcxu8p/25Nh4xveq9N3AKYDRXpaVnlQc6WSbK3wzca6PwkY9vyhhpFGhxsrFEXyPqPbTtDoCVzVoMMbo3qzTn5nJMueT/HJRvWHHrPY/08Hrvg9mb+sdIQh5SZkePr9qtNT60YIAOHraRjEDlS1qgXGlb5czXTqQXMJqoj/awgN0FttrWKj+GBo9S7ycWm0tZGhg7OO5rkkKRkwOjIY9/yNekwGoQ4zl95a9r7wOK1if4Vk12ogjD1NRnd1qCYknD6A6Wdhl5f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199018)(36756003)(8676002)(76116006)(91956017)(4326008)(478600001)(6486002)(86362001)(6506007)(54906003)(316002)(966005)(66946007)(66446008)(66556008)(6512007)(66476007)(26005)(64756008)(6916009)(186003)(7416002)(122000001)(38100700002)(5660300002)(71200400001)(83380400001)(2906002)(8936002)(38070700005)(41300700001)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXAwSzhWRXc3V2ZUR2UrUW1OYkJBRUkyVlFDYnMvbzdQaVI1NjVzekhJbUJM?=
 =?utf-8?B?OFlkalRETDR3dnlmR2hReGlyNnFwenFIdklCcm1yWkh6enpWNjNFQTJLbWRq?=
 =?utf-8?B?cVIrZTd0Q1JPcUdpVS9mN1BoYlJWRjkza1RUSW9saUFWRGQxVHd0Nm5PWFFK?=
 =?utf-8?B?S05xRWhNQi9Ba3dkVmhwKzZMZVRCNk93YWlLZmxCRU9mTzZlTk9KenpPTkVT?=
 =?utf-8?B?SWxHUU9Ob1lNTDFPcGtyVkJOYWFwOCt3NXBOa2VMOE4rVUlTSGc1VGxIUTRE?=
 =?utf-8?B?NVI3U2FzWXFqZ3hlR29LampVWUpLTVdVTXAxQW1kVUNqWUozazcxRDd4eDlw?=
 =?utf-8?B?ZnB1Smd0SDUvbTJsa2p3YjZLZnZRQ0t2Y2FsNklCRDg2VC9PY2VONENoR3No?=
 =?utf-8?B?ZHRRWGw4ZWZRekxPeXNFd3Fyamp5K2tJUjRuY3lnWVVPcEFtR3ozTk8xK29E?=
 =?utf-8?B?SHVwN0Jmdk1oYStCdFhlQUZsb2wxKzNSWTRLT3NzV09QZmFEcGN3aHcvdzMx?=
 =?utf-8?B?WDNkOXlsbUtZM2EvbTR0SEdJUzRQT0Z1aGJtZGtzVFlaNjQzeXhxMmNaTDFm?=
 =?utf-8?B?ZW9kVFMyd3o2dkRlUCsyQ25qMHE2TjlKN0dqOUllSm1xanZRcUVRMkZjWnFP?=
 =?utf-8?B?YjlmbHZVd2JwbG14VXlQcnRiN1ROOHg0L2dPRU51SldrYVJkNWlKY01UN2pv?=
 =?utf-8?B?bXdGYmNQaUlidTAzM0F5b1RvOFo5a2c5ajVHdDdkUzFmemw1d0k1cllLUUtk?=
 =?utf-8?B?NWUxa1I3eUJqcHVFODR1ekJQQkJiWG5qdmFtS084RVlhaXlnSlRRTjg3UTZz?=
 =?utf-8?B?K2R5d2VqVFB1OEFQUHZRSms3MXRBRklCdzdkaGFnL3hkUTQ1U1gxd3B6K2F0?=
 =?utf-8?B?WmtNYlpkMkFqcEl3dlVzM0tsLzdocWM5SDU1aFRoWU53NHJPSmYzWi9TUGM0?=
 =?utf-8?B?Mm9oK3pzT1VTVDJBTmdGMkF1aFc2U0xQekxNL0FoNytUV25BVk5CY3V1dFVm?=
 =?utf-8?B?UFQ5K2svNnM4WGNNY0prdy9nK2FMTk5naFFGRlhpNVN6aHVUWmZBTUtzbVg5?=
 =?utf-8?B?by9QWlJ6K1dTVE1jeHFudDRxWStkMFVpQnlGQTJIc0pWMTBsM1BzaG9YMG9C?=
 =?utf-8?B?eS92SG9vNnlkZ1FOa1lIZ0pQRXZINm1QcEJVM3JHT04vTTBIenlWUmlLZ2Qy?=
 =?utf-8?B?NmNTMTUvcWNMR0lRczJRYXBMb0ZxNGxSUy9LL2dXblJKT05VSEN6WUF1dDZX?=
 =?utf-8?B?STBWNFRXUkN5Z3FHcWxvd3QxTkYycWZncFN6d2p3OWkvYy9CM2xZS045VXlw?=
 =?utf-8?B?ajRQKytJbm1oNVVrbkFnalNoSzEreHhUYTNFZzVqcENaQzBqbmRLWDlwVlJO?=
 =?utf-8?B?TVlpWUZwblNmdFdtUDQ4UVBCaGtYVmxDMjRqTnBjWFpzYWZ3cUxmV0FLZTJp?=
 =?utf-8?B?ZjF4MVpBQkYyVkRkWHlGNEtTVVM3aHpkQ3d5S24zSzBxK1MxREl3Sm1ZSDNq?=
 =?utf-8?B?N2FXNWw0S2Y2MHg3T285ZEN0emJCL1o2NUJoNjFyVXB1N1RDTWtaOWduOWtG?=
 =?utf-8?B?S2pUNU5RSE43V3poNUFMWEkwSW0xRmV5VlhDTUZoVFBWRkE5SFZjem1neGJp?=
 =?utf-8?B?UG9ubmJaek1hTldjdTVxRFNJcmdKZTI2MnYyR2VSV1RDcHhSalh3ZEJYSEVp?=
 =?utf-8?B?YUFNZE5DOVduRW51ZTNRY1BRVDZteEM5emJHck94TTJaRG1TN3FsZ3FCU1dy?=
 =?utf-8?B?Z0E4ZnQ0RDVuVTNIMythbWI3V0Zab1RQMHVwc3RUeG10OHl0eWo1eERFQUhW?=
 =?utf-8?B?cC9IYmNkT0lRQlBrUGxvL2ZrcDloUWpDbTY2OXVMcCtsU2JFdjU5Vmw4Z2xs?=
 =?utf-8?B?TjNvNTBxWkJqRExjaU00SDRtS2Z4T0o1OTl5UDQ4cXlqV3EzZjlPYU5JRHRO?=
 =?utf-8?B?VjZkQWM5QnBmK1JXZWRiTURoS1gzdGN2VWNyNDZkOCtBMFg0bnlXUHF6T3dX?=
 =?utf-8?B?bWozTVZscFJkeTZYMnpYMHA2R1JrSWZTNytHdmkyOUdRZlVycS8xMGF0S1Ev?=
 =?utf-8?B?TDF3UGVMNk9MdHcyWnZNSDgybUFLa3BsOEpCNjZ4bTJoWGJBTlBRYi9MdzFF?=
 =?utf-8?B?UVdIVTJCb1dXQUFMU2FJa2IrOTlCa2lNS28xekxyOFpBTHV6bkkvdXFyTDc3?=
 =?utf-8?Q?xzaQ3gYXaNtqb82521RCWlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC34A28ADA3BBA48A576979355C0A14D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f036eb-1a0d-4023-21b8-08db0a74835e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 08:06:13.8900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EmrfuNX7MldJLHRWpbVM+DyDcFoeuLoikwmz6s5WkENmKwZZ42YkEvh0Nf531lmQmSOli/eQfR+3t9879Q9wDHg7K1f4+zxlA+kyKKOAYJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5036
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCk9uIFRodSwgMjAyMy0wMi0wOSBhdCAwNjo0OCArMDEwMCwgT2xla3NpaiBS
ZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiAN
Cj4gSGkgQXJ1biwNCj4gDQo+IE9uIFRodSwgRmViIDA5LCAyMDIzIGF0IDA0OjA3OjExQU0gKzAw
MDAsIEFydW4uUmFtYWRvc3NAbWljcm9jaGlwLmNvbQ0KPiAgd3JvdGU6DQo+ID4gSGkgT2xla3Np
aiwNCj4gPiBPbiBXZWQsIDIwMjMtMDItMDggYXQgMTE6MzIgKzAxMDAsIE9sZWtzaWogUmVtcGVs
IHdyb3RlOg0KPiA+ID4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4gPiA+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0K
PiA+ID4gDQo+ID4gPiBTb21lIG9mIEtTWjk0NzcgZmFtaWx5IHN3aXRjaGVzIHByb3ZpZGVzIEVF
RSBzdXBwb3J0Lg0KPiA+IA0KPiA+IG5pdDogSWYgeW91IGNhbiBlbGFib3JhdGUgd2hhdCBhcmUg
dGhlIGNoaXAgc3VwcG9ydHMgd2lsbCBiZSBnb29kLg0KPiANCj4gRG8geW91IG1lYW4gbGlzdCBv
ZiBzdXBwb3J0ZWQgY2hpcHMgb3IgbGluayBzcGVlZHMgd2l0aCBFRUUgc3VwcG9ydD8NCg0KWWVz
LCBzaW5jZSB5b3UgbWVudGlvbmVkIHNvbWUgb2YgS1NaOTQ3NywgSSB0aG91Z2h0IGl0IHdpbGwg
YmUgYmV0dGVyDQp0byBtZW50aW9uIHRoZSBzdXBwb3J0ZWQgY2hpcHMgaW4gY29tbWl0IGRlc2Ny
aXB0aW9uLg0KDQo+IA0KPiA+ID4gVG8gZW5hYmxlIGl0LCB3ZQ0KPiA+ID4ganVzdCBuZWVkIHRv
IHJlZ2lzdGVyIHNldF9tYWNfZWVlL3NldF9tYWNfZWVlIGhhbmRsZXJzIGFuZA0KPiA+ID4gdmFs
aWRhdGUNCj4gPiA+IHN1cHBvcnRlZCBjaGlwIHZlcnNpb24gYW5kIHBvcnQuDQo+ID4gPiANCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5k
ZT4NCj4gPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+ID4g
PiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyB8IDY1
DQo+ID4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCA2NSBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzel9jb21tb24uYw0KPiA+ID4gaW5kZXggNDZiZWNjMDM4MmQ2Li4wYTJkNzgyNTNk
MTcgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMN
Cj4gPiA+IEBAIC0yNjczLDYgKzI2NzMsNjkgQEAgc3RhdGljIGludCBrc3pfbWF4X210dShzdHJ1
Y3QgZHNhX3N3aXRjaA0KPiA+ID4gKmRzLA0KPiA+ID4gaW50IHBvcnQpDQo+ID4gPiAgICAgICAg
IHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiA+ICB9DQo+ID4gPiANCj4gPiA+ICtzdGF0aWMgaW50
IGtzel9nZXRfbWFjX2VlZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGV0aHRvb2xfZWVlICplKQ0KPiA+ID4g
K3sNCj4gPiA+ICsgICAgICAgaW50IHJldDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgcmV0ID0g
a3N6X3ZhbGlkYXRlX2VlZShkcywgcG9ydCk7DQo+ID4gPiArICAgICAgIGlmIChyZXQpDQo+ID4g
PiArICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgLyog
VGhlcmUgaXMgbm8gZG9jdW1lbnRlZCBjb250cm9sIG9mIFR4IExQSQ0KPiA+ID4gY29uZmlndXJh
dGlvbi4gKi8NCj4gPiA+ICsgICAgICAgZS0+dHhfbHBpX2VuYWJsZWQgPSB0cnVlOw0KPiA+IA0K
PiA+IEJsYW5rIGxpbmUgYmVmb3JlIGNvbW1lbnQgd2lsbCBpbmNyZWFzZSByZWFkYWJpbGl0eS4N
Cj4gPiANCj4gPiA+ICsgICAgICAgLyogVGhlcmUgaXMgbm8gZG9jdW1lbnRlZCBjb250cm9sIG9m
IFR4IExQSSB0aW1lci4NCj4gPiA+IEFjY29yZGluZw0KPiA+ID4gdG8gdGVzdHMNCj4gPiA+ICsg
ICAgICAgICogVHggTFBJIHRpbWVyIHNlZW1zIHRvIGJlIHNldCBieSBkZWZhdWx0IHRvIG1pbmlt
YWwNCj4gPiA+IHZhbHVlLg0KPiA+ID4gKyAgICAgICAgKi8NCj4gPiA+ICsgICAgICAgZS0+dHhf
bHBpX3RpbWVyID0gMDsNCj4gPiANCj4gPiBmb3IgbHBpX2VuYWJsZWQsIHlvdSBoYXZlIHVzZWQg
dHJ1ZSBhbmQgZm9yIGxwaV90aW1lciB5b3UgaGF2ZSB1c2VkDQo+ID4gMC4NCj4gPiBJdCBjYW4g
YmUgY29uc2lzdGVudCBlaXRoZXIgdHJ1ZS9mYWxzZSBvciAxLzAuDQo+IA0KPiB0eF9scGlfZW5h
YmxlZCBoYXMgb25seSBvbi9vZmYgc3RhdGVzLiBUaGlzIGlzIHdoeSBpIHVzZSBib29sIHZhbHVl
cy4NCj4gDQo+IHR4X2xwaV90aW1lciBpcyBhIHJhbmdlIGluIG1pY3Jvc2Vjb25kcyB0byByZS1l
bnRlciBMUEkgbW9kZS4NCg0KR290IGl0LiBJIG92ZXJsb29rZWQgdGhlIHZhcmlhYmxlIGRhdGEg
dHlwZS4NCg0KPiANCj4gQmVzaWRlLCB0eF9scGlfdGltZXIgY2FuIGJlIHVzZWQgdG8gb3B0aW1p
emUgRUVFIGZvciBzb21lDQo+IGFwcGxpY2F0aW9ucy4NCj4gRm9yIGV4YW1wbGUgZG8gbm90IHN0
YXJ0IExvdyBQb3dlciBJZGxlIGZvciBzb21lIHVzZWNzIHNvIGxhdGVuY3kNCj4gd2lsbA0KPiBi
ZSByZWR1Y2VkLiBBcmUgdGhlcmUgc29tZSBzZWNyZXQgcmVnaXN0ZXIgdG8gY29uZmlndXJlIHRo
aXMgdmFsdWU/DQoNCkkgYW0gbm90IGF3YXJlIG9mIGl0LiANCg0KPiANCj4gUmVnYXJkcywNCj4g
T2xla3Npag0KPiAtLQ0KPiBQZW5ndXRyb25peA0KPiBlLksuICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiBTdGV1ZXJ3YWxkZXIgU3Ry
LiAyMSAgICAgICAgICAgICAgICAgICAgICAgfCANCj4gaHR0cDovL3d3dy5wZW5ndXRyb25peC5k
ZS9lLyAgfA0KPiAzMTEzNyBIaWxkZXNoZWltLCBHZXJtYW55ICAgICAgICAgICAgICAgICAgfCBQ
aG9uZTogKzQ5LTUxMjEtMjA2OTE3LQ0KPiAwICAgIHwNCj4gQW10c2dlcmljaHQgSGlsZGVzaGVp
bSwgSFJBIDI2ODYgICAgICAgICAgIHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy0NCj4gNTU1NSB8
DQo=
