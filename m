Return-Path: <netdev+bounces-2135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 711F670073D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A76F281B11
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF1BD51E;
	Fri, 12 May 2023 11:53:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1FEBE54
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:53:04 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF4A8A60;
	Fri, 12 May 2023 04:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4qGVnun9m6oeV17EF+/JRRvPaTYmiSTb0ES4q4aFEKFIq5r2vozPotjQ0UAIrcMLbyKdm+EFv/4sy1n3tncu2iJ/jaq39k90hvQwN6giOT0g1Hitgtcd6TXyfZlUwBs+//ffAzVnhAlnhVBzwv5u9GkERYvmIXnOQ4vabj+ZWCIXSDbw3wols8iJESMW3qjrfu/BVPP05UifkQsfSZ/qxwoBatJDa+mNAAGHp/umBWTVCp1NRpLpVlflPHhfAVz35BanB6Fpht/Wk01BExX8nwLqRm+8+sFmcL/zUc2f8PyZYad20u2hOTNkwbRPxhmrqkKq6e+Cn32DA43fwBsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/MKRCa1lKkDQHbHbRM/mq6CH3ZzG6yLdSXaqZMIBlI=;
 b=NBWY7ovtvIRpmYgy3/8hc8TGS/LDehAw1Gyb2mTUBvjSciS9rWilgsni+swWphATaR+hjLVUothwWUmtr1XpsW3zJ2UDG4Lsv8ySJSwFEoS9KvV4G3miWf6V806mMwjVI1gDEn9GbPLaUsvJbH+B0CzuTgH+pnNhKcwiVbOWZjhrHwGNqViJb1UG3ZryDcV42727A4nB/BoOknmF4VHuJ99/a9X1+4wrKJaJRagBuIGxETZ0W1lt2m4I2rYQBbJM0woXlofq8UVdO66WTkzap31GJC1+k/5cmRC/xVOp7kwHf1TRBAfBKtuwf+GmP0OWqHz3IX65mKwQKmJdXJxzBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/MKRCa1lKkDQHbHbRM/mq6CH3ZzG6yLdSXaqZMIBlI=;
 b=EWjY1XIXAKIXf2Jyf67hcy2bHrUy/JD1lMRitcnR8r4Nyxs0qi3YJJxWCkqdhdRwrrSi4lnGZLKyl1CkzMkI9jrBC2AuZvMGkOd/avsBO8Xtt+7oY3KcZdQWyuaty+neOBQo05LytDgEEuxPG5SJ6Se578ZevqBQ66sUO5KmzyM=
Received: from BN8PR12MB2852.namprd12.prod.outlook.com (2603:10b6:408:9a::14)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 11:53:01 +0000
Received: from BN8PR12MB2852.namprd12.prod.outlook.com
 ([fe80::c7f2:585:2a91:f27a]) by BN8PR12MB2852.namprd12.prod.outlook.com
 ([fe80::c7f2:585:2a91:f27a%6]) with mapi id 15.20.6387.022; Fri, 12 May 2023
 11:53:00 +0000
From: "Somisetty, Pranavi" <pranavi.somisetty@amd.com>
To: "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
	"Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>
CC: "git (AMD-Xilinx)" <git@amd.com>, "Simek, Michal" <michal.simek@amd.com>,
	"Katakam, Harini" <harini.katakam@amd.com>, "Pandey, Radhey Shyam"
	<radhey.shyam.pandey@amd.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>
Subject: RE: [PATCH net-next v2 2/2] net: macb: Add support for partial store
 and forward
Thread-Topic: [PATCH net-next v2 2/2] net: macb: Add support for partial store
 and forward
Thread-Index: AQHZg9f4LYgs6abPXkGfaFHwWm5+1q9WRzAAgAA+F1A=
Date: Fri, 12 May 2023 11:53:00 +0000
Message-ID:
 <BN8PR12MB28522459ECB41284DF38F61AF7759@BN8PR12MB2852.namprd12.prod.outlook.com>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-3-pranavi.somisetty@amd.com>
 <deadf131-063c-01d3-b33c-b5aac375d713@microchip.com>
In-Reply-To: <deadf131-063c-01d3-b33c-b5aac375d713@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8PR12MB2852:EE_|DS0PR12MB8576:EE_
x-ms-office365-filtering-correlation-id: f8379325-dd02-4013-4529-08db52df6fa2
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 C1OBBVcOcvyA6y9mXFY93K1L5hQwimvVJTtYYvdK7xOF5bJOBJT1jbTvGi7nitsMIzebhil+5PULlCSoWtCwlr5JSK3UWIB1t/Qtl93ETQbU/BqnUSDC2ivlPMR9pj7Ds7xUHBgxDP8AXfT+RohlMcgl00EbKX9XC8ksXMylp48NpfTmlo0nXWLQCjipP6nxyWyb6gZ63M725y4HoRMBiZmj29qns0SuagrnJX/yIx+Df4hSkN1PLmFTxCz3MXKlU8CWYuzL3o0F/WlfUvXGsBSpN3tHsUiuv0sVga+ychS7UvB5pmaF/wLDcwB6uB8Ff5ZVfReY4g/V7ETYY/AhEa87Mtpvh0sKp/B8jBFVWFvnATFbSS5KPFYl/aBAD8eNZ2ET6QmqZ9XTl16AKxb3+AcU5LwlNdtgUAOxz83js+DIXGZDsviA0WMIbUVTnGSqx11FR2dubDlQdOHaSnKHJPi/bIm37fDJ3QDwrAUnIC5rtQtSL7WcNpxZWm1T8svDv08qunBxklEy3d3OYp8nTF5wurAAZr4CUDNmEn3movSaelFH5deO2uSKp53lco6kJvAqUqiB7f7yoYODtAweZim7tYFFYzdQQdr8/Ft8M7riPXstXpEUnpIFjz6jwnJr
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2852.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(8676002)(7696005)(52536014)(8936002)(71200400001)(86362001)(38100700002)(53546011)(38070700005)(2906002)(186003)(5660300002)(55016003)(478600001)(6506007)(9686003)(33656002)(316002)(7416002)(4326008)(66556008)(76116006)(83380400001)(64756008)(66946007)(54906003)(66446008)(66476007)(110136005)(122000001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2V1OG1vWTJ6U0hQbHp1VVdPWWhpQTl4dm5aOGc0WUZnRmVQY0h6ZWE4am1Z?=
 =?utf-8?B?WGpFOFJPVzVmLy8yUU10bXZQNk9jYUtpSmc2WmNXWnVkSnUvWmxhRVQ1VU5B?=
 =?utf-8?B?anpaUnY1WVRDWUpGUTRwdm16RXc0cXN6QjF6eGpMTSs2cXpFVHZPcncwMExB?=
 =?utf-8?B?KzVRQlZvNFVuMS9WcDZ2ZVVKZVhlNStLR0IrTXRrVVFVb1JLMXlBVi9WVkt2?=
 =?utf-8?B?OWhJTG96eGFrUTJWSnhOYVQvZ29oKzVaWFZLTHI2dFZMbnNmRzNzMmtjd0J6?=
 =?utf-8?B?Qi8vNkJ3UlFLYkZWU3hUcGlvdGhlS1VudDBUZWdkWkNyUjdEdXJFQkljV0Z6?=
 =?utf-8?B?TFp0TC9kbHZoSG9LNGRabXpsZTY0ZnhZOHFZUHR0dDB4cjVZQWhNRzdKNVJG?=
 =?utf-8?B?UUl2bG1iR3hqL2QwSGhTY3ZVWllybnBoZ1R6bDZWYS9HbVNaWFVSSUc5d2FT?=
 =?utf-8?B?Nm9xTUFoYVpiSlUrc2dybFRneHd0NDdRSXpqbUFzRUtyc1VOYk5rNkhpWWt1?=
 =?utf-8?B?cnpyN2dmeFpwZWNDbVhsSWJDaENlWDJ1b2tDK25MRFJHSmF3TE5tam9uZDMx?=
 =?utf-8?B?LzlTMUt1VTVMOFdQQm5BbndnKzljMmxSRkZlSGh1MlVKRVNzdk9Yb0lRVFFL?=
 =?utf-8?B?RGpoRHFmeFdHL1pzUVJPM0plY2hwQ0RZTFZ4UldtbWNyWU9ERzl3TzNVWUZP?=
 =?utf-8?B?azUzbDlHQTNjYzJhaytrNnRYT1g1cTNiaXA4ckU0TnZqMkwveVBnNzFDazZu?=
 =?utf-8?B?RmZrTG5tVnFQRm8xWFU1NTR0UFhWZDdkamQ3VzM1UUZrRVlCakMrTmZKcjZx?=
 =?utf-8?B?QThmaHpyUmJla3F0MXdVTllQR3dMUHZNMnhjUS9wajF6UGVXRkhBT1hNdVZm?=
 =?utf-8?B?Qmc0NHdxdGpvWFNXaExqRjlXQnFlc2VocmRHV2pMalhITEgwRU14djdaMEVW?=
 =?utf-8?B?WnZvMkY4WjhGQUxlSzFDdXFxT2tPZjVlTEtrY1V1cjljSTg0eElFdVVZNlBW?=
 =?utf-8?B?V0tEdEN5RGxJMzAxdjJEbWlvZ0pBVkF2dndXOVkzNmx0SnplQTdpMHFVZGJ4?=
 =?utf-8?B?cFNLcTBqbEc4RDBnYVVlWW1QK0hiVkNheGo5Rmc0Z3A3elJpcUU0MnlnTXZX?=
 =?utf-8?B?amJnRG9WbWxPRG83bUFHNEpKYnIxRFV3OHdpY1JVRi85ZDFhQUJvOHJkMG1M?=
 =?utf-8?B?R3JCd21SSW05Si9iUlFHYmxmZDNNM3RqWVNnb2pXamlqUWRLck5mcFg1RVFI?=
 =?utf-8?B?ZTE2T2lRaTJWY2pLRU9aRGZDcm92elJ2b0RpSFhnYi9hbnFDcnVudmVFR0RK?=
 =?utf-8?B?Q252RmFTbEZIb2hjZkpBYzBSeE5KZVQ4VDIwWllJMDdSeVJycnRJQVBPTjJY?=
 =?utf-8?B?WHlKOUJqQThDMTZVejZDcGJnQzRmS3FRL1puUlBrdllxWmpXUytMMDl5VGFU?=
 =?utf-8?B?RmkyNHRES29oTms5TjJvcDE1QjE4RnZJVFZNUXUrTEgyekNRQzZLcFg2SDRv?=
 =?utf-8?B?VkZYS3hOWGtnaUtnWElxK1A0RSt5R3ROSStPNlJ0ejV6c1hhbFlBV3h6em9T?=
 =?utf-8?B?dXFOZkN4K25IRnpzTmo1NlNWZ3VXM0VVZm4rVWw2ZWV3a0VWbVNIaFcyaVhh?=
 =?utf-8?B?WEpwblpxbnZrRDZHU2RneTIyRkdJMlhUUWFXcjY2cDRaajEweEFTL1A3eGRp?=
 =?utf-8?B?VjJrSWdPL3J6MkVMNmsyc0h2bktXYkJlT2dnWmV4L1hKeFhMckhXbFNYUDlT?=
 =?utf-8?B?VWJIUzhtclZKYytDbXBXUjJZdjZ4SDdkdndCYjFTaDdyT0FzMWdjSVRlUk9n?=
 =?utf-8?B?VVNpRTlSZmhQVVNKSnJFbHhhU1JWQWYvYUxUM0NsNmJKR2ZSWk1DaU45VUVO?=
 =?utf-8?B?Vml0MzlDQzh3K0pqVXhPWlRMOG5ZREkyZ3F0Z3pjOENjVE9KQ3RZOWJCWmcw?=
 =?utf-8?B?VUNoUkZsUXI2ZURRS1BNUFVweHVoUXVRVS9NY0FEZENHMGNleldXZU9XRWR4?=
 =?utf-8?B?Qk15UFl1UGMvR0dWbUk3VWhReUx4cnN5S0E2QlNldjlVWnd4WVBXdGM2R2ti?=
 =?utf-8?B?ZW1qaWE4N3FNL2NvWW96d0w5MG1WTksvR2NYSzlwSk5UbDBLOFlSREgvb3Br?=
 =?utf-8?B?d2U3U0RtTjBoaGxNRlhuZmoybE5KZ2pCT1ZRQlRUNWh6emNqNU5LMHBuaGZE?=
 =?utf-8?Q?+vFeSTTCv9aToBYB8QpH8ZM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2852.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8379325-dd02-4013-4529-08db52df6fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 11:53:00.6956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z0QdQ6jC01WQ1RKF4R3T8YYOmrH6PisbSh/U08v0KQGwUqdLLcR9MArtdWZ6FNL7Y91vQmZkPvoh9m4RtOzm+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2xhdWRpdS5CZXpuZWFA
bWljcm9jaGlwLmNvbSA8Q2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBNYXkgMTIsIDIwMjMgMToyOCBQTQ0KPiBUbzogU29taXNldHR5LCBQcmFuYXZpIDxwcmFu
YXZpLnNvbWlzZXR0eUBhbWQuY29tPjsNCj4gTmljb2xhcy5GZXJyZUBtaWNyb2NoaXAuY29tOyBk
YXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5v
cmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiByaWNoYXJkY29jaHJhbkBnbWFpbC5jb207IGxpbnV4
QGFybWxpbnV4Lm9yZy51azsgcGFsbWVyQGRhYmJlbHQuY29tDQo+IENjOiBnaXQgKEFNRC1YaWxp
bngpIDxnaXRAYW1kLmNvbT47IFNpbWVrLCBNaWNoYWwNCj4gPG1pY2hhbC5zaW1la0BhbWQuY29t
PjsgS2F0YWthbSwgSGFyaW5pIDxoYXJpbmkua2F0YWthbUBhbWQuY29tPjsNCj4gUGFuZGV5LCBS
YWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT47DQo+IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiByaXNj
dkBsaXN0cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIg
Mi8yXSBuZXQ6IG1hY2I6IEFkZCBzdXBwb3J0IGZvciBwYXJ0aWFsIHN0b3JlDQo+IGFuZCBmb3J3
YXJkDQo+IA0KPiBPbiAxMS4wNS4yMDIzIDEwOjEyLCBQcmFuYXZpIFNvbWlzZXR0eSB3cm90ZToN
Cj4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVu
dHMgdW5sZXNzIHlvdSBrbm93DQo+ID4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiA+DQo+ID4gV2hl
biB0aGUgcmVjZWl2ZSBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkIG1vZGUgaXMgYWN0aXZhdGVk
LCB0aGUNCj4gPiByZWNlaXZlciB3aWxsIG9ubHkgYmVnaW4gdG8gZm9yd2FyZCB0aGUgcGFja2V0
IHRvIHRoZSBleHRlcm5hbCBBSEIgb3INCj4gPiBBWEkgc2xhdmUgd2hlbiBlbm91Z2ggcGFja2V0
IGRhdGEgaXMgc3RvcmVkIGluIHRoZSBwYWNrZXQgYnVmZmVyLg0KPiA+IFRoZSBhbW91bnQgb2Yg
cGFja2V0IGRhdGEgcmVxdWlyZWQgdG8gYWN0aXZhdGUgdGhlIGZvcndhcmRpbmcgcHJvY2Vzcw0K
PiA+IGlzIHByb2dyYW1tYWJsZSB2aWEgd2F0ZXJtYXJrIHJlZ2lzdGVycyB3aGljaCBhcmUgbG9j
YXRlZCBhdCB0aGUgc2FtZQ0KPiA+IGFkZHJlc3MgYXMgdGhlIHBhcnRpYWwgc3RvcmUgYW5kIGZv
cndhcmQgZW5hYmxlIGJpdHMuIEFkZGluZyBzdXBwb3J0DQo+ID4gdG8gcmVhZCB0aGlzIHJ4LXdh
dGVybWFyayB2YWx1ZSBmcm9tIGRldmljZS10cmVlLCB0byBwcm9ncmFtIHRoZQ0KPiA+IHdhdGVy
bWFyayByZWdpc3RlcnMgYW5kIGVuYWJsZSBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJkaW5nLg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWF1bGlrIEpvZGhhbmkgPG1hdWxpay5qb2RoYW5pQHhp
bGlueC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWljaGFsIFNpbWVrIDxtaWNoYWwuc2ltZWtA
eGlsaW54LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYXJpbmkgS2F0YWthbSA8aGFyaW5pLmth
dGFrYW1AeGlsaW54LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5
IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogUHJh
bmF2aSBTb21pc2V0dHkgPHByYW5hdmkuc29taXNldHR5QGFtZC5jb20+DQo+ID4gLS0tDQoNCjxz
bmlwPg0KPiA+ICsgICAgICAgLyogRGlzYWJsZSBSWCBwYXJ0aWFsIHN0b3JlIGFuZCBmb3J3YXJk
IGFuZCByZXNldCB3YXRlcm1hcmsgdmFsdWUgKi8NCj4gPiArICAgICAgIGlmIChicC0+Y2FwcyAm
IE1BQ0JfQ0FQU19QQVJUSUFMX1NUT1JFX0ZPUldBUkQpIHsNCj4gPiArICAgICAgICAgICAgICAg
d2F0ZXJtYXJrX3Jlc2V0X3ZhbHVlID0gKDEgPDwgKEdFTV9CRkVYVChSWF9QQlVGX0FERFIsDQo+
ID4gKyBnZW1fcmVhZGwoYnAsIERDRkcyKSkpKSAtIDE7DQo+IA0KPiBJcyB0aGlzIGJsb2NrIG5l
ZWRlZD8gTWF5YmUgYWxsIHlvdSBuZWVkIGhlcmUgaXMganVzdCB0byBkaXNhYmxlIHRoZSByeCBw
YXJ0aWFsDQo+IHN0b3JlIGFuZCBmb3J3YXJkPw0KDQpZZXMsIHRoZSB2YWx1ZSBkb2VzbuKAmXQg
bmVlZCB0byBiZSB3cml0dGVuLCBkaXNhYmxpbmcgcnggcGFydGlhbCBzdG9yZSBhbmQgZm9yd2Fy
ZA0KaXMgZW5vdWdoLCB3aWxsIHRha2UgY2FyZS4NCjxzbmlwPg0KPiANCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICByZXR2YWwgPSBvZl9wcm9wZXJ0eV9yZWFkX3UxNihicC0+cGRldi0+ZGV2
Lm9mX25vZGUsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgInJ4LXdhdGVybWFyayIsDQo+ID4gKw0KPiA+ICsgJmJwLT5yeF93YXRlcm1h
cmspOw0KPiANCj4gRS5nLiBTQU1BN0c1IGhhcyBQQlVGUlhDVVQud2F0ZXJtYXJrIG9uIDEwIGJp
dHMuIElzIGl0IHRoZSBzYW1lIG9uDQo+IFh5bnFtcD8NCg0KT24gWnlucU1QIGl0cyAxMiBiaXRz
Lg0KDQo+IEZvciBjb21wYXRpYmlsaXR5IHdpdGggZnV0dXJlIGltcGxlbWVudGF0aW9ucyBhbmQg
c3RhYmxlIERUIGludGVyZmFjZSBpdA0KPiB3b3VsZCBiZSBiZXR0ZXIgdG8ganVzdCBrZWVwIHJ4
LXdhdGVybWFyayBEVCBwcm9wZXJ0eSBvbiAzMiBiaXRzLg0KPiANCg0KSSBkb27igJl0IHRoaW5r
IGl0IGNhbiBleHRlbmQgYmV5b25kIHUxNiwgY29uc2lkZXJpbmcsIHRoZSBtYXhpbXVtIHBidWYg
ZGVwdGgNCmZpZWxkIGluIERDRkcyLCBpcyBvbmx5IDQgYml0cyAoMjI6MjUpLiANCg0KSSdsbCBk
byBhIHJlLXNwaW4gYWRkcmVzc2luZyB5b3VyIGFuZCBvdGhlciByZXZpZXdlcidzIGNvbW1lbnRz
Lg0KDQpUaGFua3MNClByYW5hdmkNCg==

