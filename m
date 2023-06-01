Return-Path: <netdev+bounces-7264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A2E71F64A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B55332817C6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A66E24EB0;
	Thu,  1 Jun 2023 22:53:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4529010FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:53:39 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436C0138
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685660017; x=1717196017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p93jOL3BK7mp1Qpz0A0GrpaavwnSItk08bjsOzt33e8=;
  b=xT5S48724NNTc13e9pGs07gLOI44rQd2jP5OqAvWC9leOS8Tvl5v95zS
   130vgpS1Qr8yz60UCGUbpq6/iIToi9tNH2XBRKc+RS9ytroSWKtbHz3ZJ
   5acNrAzHDmig9gXpyG90rm3J/p7JeD7u6V76jjGe01dKrveeR8VSYR/jz
   t4rR1Su2UGYIec3d+0Cl2HrsXC3eVGo3UaMGkLDy80zI6p4WGyNI60fTs
   PvCZhHgayOFBffAalbl5Mjv1rgNGWEzbSCIWGC++xRQd6KlzlraZViWRr
   K4Tmf1QWwtdhJlx3zTvfErztErQhcPxc13r6k5iJWwfcEngTPOsNoKLYi
   w==;
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="214239156"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jun 2023 15:53:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 1 Jun 2023 15:53:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 1 Jun 2023 15:53:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDso8f48Kon/QM55IfSw+jKMhcmkkdxNJz9q2NpMp2LKxpGQSlIJQvd14AFS+qf+E5zHCQKwtbZ8hzq0c3sPc+45i7q8xuEyhQ5eZfKqdfY5BXMbT1OE3kXfehqVpgGSjKq1//j6N5Kh8zdB+gxNU3GFne+DPKB7Ir/IQySgkp1VowoNVZnUCq3INyqHrCP3WGsbgfs1XmOApdBBFVC4XQtjsh3/Fc76CBQzF5n4XlM4jZlT42joYcyDW3lYcKtHGPd7ES5fHjh1YTqDlG7Us3oCFsbiWa9QNPK2CLwkn1/Oy4qkRtOfnFO7FIja0Ba+l7Ap2rRrbILhsG7oZk0KYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p93jOL3BK7mp1Qpz0A0GrpaavwnSItk08bjsOzt33e8=;
 b=XYXD9YjaWk1x4Rj5M5lPmdhW+gdLB0M13zvPBF0lCFNhxvN9FCBg/ofNRWays4Dwvbnd04h1Uie4cvbV3F1x0OHP25b4UmRUI7HKYQVk4D8mnqGV4InYnEo8TvzpNfGLekU3NnJWyHjeMbzl9/SIgQuS3qZ2oWYCRRmbAh1Ii3fskGXifa9Eb1VgR4TuXzsHDDu7H3D2klp9V7F88jCW4ceXARjSmKwPs4+pX9jiQYLuKw9V3GGXgEbrxIgQ8SYkCCRatt36xp7RVhDJsOpw+e4cVR7iJXRRex1yQWtI09tQLCNyPtJi4XwsOLWRCMWFHbMzQaPbmNNc5bo1kcvxTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p93jOL3BK7mp1Qpz0A0GrpaavwnSItk08bjsOzt33e8=;
 b=rptcqcB5FJAp5lMq5aU7UAJ+zEUkem7rnu5gCQMeVJdslA/rkZH1PJRMLQUc9uptu2q8OrR+glGIiwQFF1aMguJwQ+s0dahwHfWfb02nMvGwMJiB2x3jbHAsRLC/H3FRzxW7hauF8TersPjNrJlCntVgM7Ckb5/eP/uBsCDjgnM=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by SN7PR11MB7068.namprd11.prod.outlook.com (2603:10b6:806:29b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 1 Jun
 2023 22:53:32 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::9617:4881:ecb2:7ce]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::9617:4881:ecb2:7ce%4]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 22:53:32 +0000
From: <Tristram.Ha@microchip.com>
To: <f.fainelli@gmail.com>
CC: <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
	<davem@davemloft.net>, <andrew@lunn.ch>
Subject: RE: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Topic: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Index: AQHZkDwiffQVuCP3CUK1xQvBykSLHa91CMkAgAGAM3A=
Date: Thu, 1 Jun 2023 22:53:32 +0000
Message-ID: <BYAPR11MB35582C980FE530595233A8BFEC49A@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
 <40c2010e-337f-6bc1-5080-ab710fc4f991@gmail.com>
In-Reply-To: <40c2010e-337f-6bc1-5080-ab710fc4f991@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3558:EE_|SN7PR11MB7068:EE_
x-ms-office365-filtering-correlation-id: 51761f5d-51d4-46b3-6732-08db62f30634
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i37kn8/UZxN4modb++JDZeOY6mh7EqQr/S5y3f/iJqnYCM/Z1ZF/wbQIIg8bRtSJGD5/ieHSCA7XCpKOpqkyDG/xr10v6j797cSXsypzfGqP/Jg3KZjaN6+UGmFbfsL8Rta+sjVMNphHxv+LZMC3/PKgx+nCQ/Nk8FDJoT68CMES+FtfdMtXiCjU8JpiezcWd0DgRE0KhwkJvlxW740B+5ozCt7mo58VhLjDE18mEdzXdLUlyxfiqKbp4IdXTTk0iWplqcuYJ0uir0GFpUlmRcYtzA2PwqAIZxr8FxHF32njksVVE0bonG2yiT/j2GKqdLneVFzDtLlpLZUBqqNucNUzSWglBuSrRzv9MaaRu68TJfrsgnoSwgIT6RQFm6D2eg8efZEMcROE1x4PgJ0yTzdtKTXbdiqYdaju0qHVKs9Ly5CBCbFigt8Q8m038Hdf+HtpO4KQmSTygFYXq+FBcsXx9+LZUHetDMGw5na6ZtCxOiMH1AsYCm+GOnw97ezA6lE7rfjgrvQXOoqsPAPdl10qHFdAYsdDOLQ6jKRmzVnzQWKDKwcfUrsnIFLq5ZZvP/igSmOQF6rHGzykZLgV9gPPHl5rYdjEfHxj0Ldm3ej0EYeQCF527DJ7mRIURhjH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(86362001)(52536014)(33656002)(122000001)(38100700002)(38070700005)(55016003)(6506007)(26005)(9686003)(83380400001)(54906003)(5660300002)(66446008)(2906002)(66556008)(8936002)(66946007)(76116006)(478600001)(4326008)(66476007)(64756008)(71200400001)(6916009)(8676002)(7696005)(41300700001)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzlxdVhVWUF6WVZEN21HT0hEVGRDTFZoZHErYUNUUWhyVERLZ2hUVW9HUThv?=
 =?utf-8?B?NHFSZDlPVDlPT2JUc1JiRjNrS3NOaGJyaXhIVm54b242K1BGTnBIWW9kUzhU?=
 =?utf-8?B?WEtYUnJRQmxoL1RCRUw4NjZrQlRCbHdzTzM4TVlBTXIzTjdPQ210L3hId1lq?=
 =?utf-8?B?QUNxK3dzc0oyRnoxaXNJT2htdnZSMkg0WlRyM002MEpoVWlndCsyTWZaTlZh?=
 =?utf-8?B?K201QjhZTmNZY1hlZXNHbGRaZnAyY1JpMlRTdC9DaFBtdnpCMVVwRzVDd1Nr?=
 =?utf-8?B?Wll4clBrOVI1YStXS0l2WEtHY3d5RFdNbk5hL0RaWHliS1FLV3U0YTUram52?=
 =?utf-8?B?cWlNSHkyVmF3L0xXSVU1RXlYT3dVMlY4VC9ha3pUd3VDNnJNWVR4K2cyaUdn?=
 =?utf-8?B?SExDV1hpbVZyeXppMTF4RGYrWm1hT2VaVzlycmI0K0YxaG9WMUpYWW8yVVNr?=
 =?utf-8?B?ZGxYNVRucWRRUlJCR3RHSjVyaFdwekRhMmtKT0x6RnUrRWVSc29KTWlZR3dO?=
 =?utf-8?B?dllxOEEvUFlCYllZeFRKc0FxbnlXTXRPdG5EOU44REYyengwOG5zZzVLQXZR?=
 =?utf-8?B?emltNS82cCtwMFFSQlF6dzVQY3FKaWdnb2g1ZjBVYXpHbVN0dDY5Y1lKeUlz?=
 =?utf-8?B?Z2ZxUWllLzZUbFN1ZWN2U0I5ejR6TTlZbkpiTkZrZG1Vam5idHFUcmJxRDJG?=
 =?utf-8?B?cjdhYU1LOVpPQkxrcTc5U0M5eHAvWUxaNGwrVExPaTJJTjlOWUlSMk56eVVR?=
 =?utf-8?B?TUQ0R2x6MFdOd3NBN2grK2xFYndSTG92QnpYTVRDSVhOT3dsYmVIdDZLaHZC?=
 =?utf-8?B?bmRPRnB6NEpzNnpKYUNmTXBYd0xRMktzRE9xTlZ4dkYvMlM3NGRPcmdWSTF5?=
 =?utf-8?B?UU4wWHVJNUZJNDgwZFhNYy8zbHRRNlBJNjAxR1FONk5DYXRwUmtKL1lqRDRU?=
 =?utf-8?B?dTMxYnlBL2ZwSjNhNzIzbzdDN1Y3RHFGNVNZSk1yQXNuY2p5QlFabUxndGxP?=
 =?utf-8?B?UkdjV3RjZnFoVUhpL0VEVVpRL1BPK0YyZHgwWEpVeGRXMnBnWWNHRS9Qa0o1?=
 =?utf-8?B?YXdvVjA4N0oyNk5iMUZMVzZxcWlTR2xOZTlvRXBYSU15N1NUZ29HVG5mK0VX?=
 =?utf-8?B?WW5Wb3Z4c1RMZGd0WVdtQ216emVQNi9YTytoc1J2a1l4Z09EbXZza0gxbHI0?=
 =?utf-8?B?ei9wekQ4UkRaelJHV2JwUnYwMkF3eE9Pc0RycVI4WTRmYWNyUjU1eEJVdDFU?=
 =?utf-8?B?MkcyWWl6OGJESEtraDhBSnV4bXFJa3dFLzlnOHJoZVcyaVd2VUZLZmhXNm4w?=
 =?utf-8?B?bGFFMjB3R25lNnZ2b01sTy84bDhLWTlVdUJ4TlZjYysyRkFNMGVXbkMrSDVh?=
 =?utf-8?B?akF4UjRXWlZYMWlLaE9VN1BROWN4aUcrTnllTEg4ZGVJQ3NzM0MwTU1UWTdC?=
 =?utf-8?B?LzZiVHFXSmQzT2hiZ09zQ0FIcXFVL0lVZnBQZ1Y5Sk1QdTZJRTNXZHJqckNM?=
 =?utf-8?B?M05Ua1ZVRTRPMk9QdzRRTytCaEN2WC9pRHVScHpscFNSRE0xMGM2UGZocnZS?=
 =?utf-8?B?bkFrUGF0WHFOM01NZHVHekJCQmQxNVRqU2tacDAxUmJSK1c1NkJDUkNsclpE?=
 =?utf-8?B?Ukl4cFVxb3QzLzJ6T2dSNmh5Rno0dk5JeHVSL2dsTDQwaUlpa0llanhDc3dB?=
 =?utf-8?B?aGJoOGpUS1NKUXhMaWU4aTNiNjBwdEkxOGNrOWVOOGtHUTdOek9wL1VqVHpK?=
 =?utf-8?B?THNURHdOejVnbmVwR003N3UwdVordisvSEJabWlDNlNHVXFnbDJGdDRPMjM3?=
 =?utf-8?B?aXpzc2NwYU1Id0dhOVNvQUpsT0c5TnlUd0lqbnYxemhtTHQ2OVdCbjBVMmdh?=
 =?utf-8?B?MDBmYVdoK0VWR2JCR2EvbzBNWmY0UU8yS1IrWmVoSlhIRjR6eUwwNFVXdlVu?=
 =?utf-8?B?SXJ4VnBqbXRuRHd6UFpyQzdqcXlqVTJTWHBBZ1BwU1d2MlU2cTNQQWxkUi9l?=
 =?utf-8?B?TWx5Wmkwb1pTWWlKRGdNRXhnNTVyeVNrQ2pFN1BmTWx0RmRsTm9vdk5SaDI4?=
 =?utf-8?B?ZVRwRFlWUnh1MjlNK3RhSVFJZldUTVNlS1B1L2F1ODU5eU1FSGt6cFlNZlc2?=
 =?utf-8?Q?HizErUeXVAKCAAj2nC1njjTE0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51761f5d-51d4-46b3-6732-08db62f30634
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 22:53:32.3390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wUqJmFSS8i/RHUFIcjQq53Y4A0YAVF5aM2r+NG0qQeRSGB+bsKkzC2rEBSO3VcobQthrMWMexHXYfc6fd4sdzSGfsbbWecz7DyxMSbZYl7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7068
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiA+ICsgICAgIGlmICh3b2wtPndvbG9wdHMgJiBXQUtFX1BIWSkNCj4gPiArICAgICAgICAgICAg
IHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKyAgICAgLyogbGFuODc0eCBoYXMgb25s
eSBvbmUgV29MIGZpbHRlciBwYXR0ZXJuICovDQo+ID4gKyAgICAgaWYgKCh3b2wtPndvbG9wdHMg
JiAoV0FLRV9BUlAgfCBXQUtFX01DQVNUKSkgPT0NCj4gPiArICAgICAgICAgKFdBS0VfQVJQIHwg
V0FLRV9NQ0FTVCkpIHsNCj4gPiArICAgICAgICAgICAgIHBoeWRldl9pbmZvKHBoeWRldiwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICJsYW44NzR4IFdvTCBzdXBwb3J0cyBvbmUgb2Yg
QVJQfE1DQVNUIGF0IGEgdGltZVxuIik7DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVPUE5P
VFNVUFA7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICByYyA9IHBoeV9yZWFkX21tZChw
aHlkZXYsIE1ESU9fTU1EX1BDUywNCj4gTUlJX0xBTjg3NFhfUEhZX01NRF9XT0xfV1VDU1IpOw0K
PiA+ICsgICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gcmM7DQo+ID4g
Kw0KPiA+ICsgICAgIHZhbF93dWNzciA9IHJjOw0KPiANCj4gWW91IG5lZWQgdG8gdGFrZSBpbnRv
IGFjY291bnQgdGhlIGNhc2Ugd2hlcmUgYW4gdXNlciB3YW50cyB0byBkaXNhYmxlDQo+IFdha2Ut
b24tTEFOIGVudGlyZWx5LCBlLmcuOg0KPiANCj4gZXRodG9vbCAtcyA8aWZhY2U+IHdvbCBkDQo+
IA0KPiBbc25pcF0NCj4gDQo+ID4gKw0KPiA+ICsgICAgIGlmICh3b2wtPndvbG9wdHMgJiBXQUtF
X1VDQVNUKQ0KPiA+ICsgICAgICAgICAgICAgdmFsX3d1Y3NyIHw9IE1JSV9MQU44NzRYX1BIWV9X
T0xfUEZEQUVOOw0KPiA+ICsgICAgIGVsc2UNCj4gPiArICAgICAgICAgICAgIHZhbF93dWNzciAm
PSB+TUlJX0xBTjg3NFhfUEhZX1dPTF9QRkRBRU47DQo+ID4gKw0KPiA+ICsgICAgIGlmICh3b2wt
PndvbG9wdHMgJiBXQUtFX0JDQVNUKQ0KPiA+ICsgICAgICAgICAgICAgdmFsX3d1Y3NyIHw9IE1J
SV9MQU44NzRYX1BIWV9XT0xfQkNTVEVOOw0KPiA+ICsgICAgIGVsc2UNCj4gPiArICAgICAgICAg
ICAgIHZhbF93dWNzciAmPSB+TUlJX0xBTjg3NFhfUEhZX1dPTF9CQ1NURU47DQo+ID4gKw0KPiA+
ICsgICAgIGlmICh3b2wtPndvbG9wdHMgJiBXQUtFX01BR0lDKQ0KPiA+ICsgICAgICAgICAgICAg
dmFsX3d1Y3NyIHw9IE1JSV9MQU44NzRYX1BIWV9XT0xfTVBFTjsNCj4gPiArICAgICBlbHNlDQo+
ID4gKyAgICAgICAgICAgICB2YWxfd3Vjc3IgJj0gfk1JSV9MQU44NzRYX1BIWV9XT0xfTVBFTjsN
Cj4gPiArDQo+ID4gKyAgICAgLyogTmVlZCB0byB1c2UgcGF0dGVybiBtYXRjaGluZyAqLw0KPiA+
ICsgICAgIGlmICh3b2wtPndvbG9wdHMgJiAoV0FLRV9BUlAgfCBXQUtFX01DQVNUKSkNCj4gPiAr
ICAgICAgICAgICAgIHZhbF93dWNzciB8PSBNSUlfTEFOODc0WF9QSFlfV09MX1dVRU47DQo+ID4g
KyAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgdmFsX3d1Y3NyICY9IH5NSUlfTEFOODc0WF9Q
SFlfV09MX1dVRU47DQo+ID4gKw0KDQpUaGUgd29sb3B0cyBwYXJhbWV0ZXIgY29udGFpbnMgdGhl
IGJpdHMgZm9yIFdBS0VfQVJQIGFuZCBvdGhlcnMuICBXaGVuDQpXb0wgaXMgZGlzYWJsZWQgdGhl
IGJpdHMgYXJlIGVtcHR5LiAgVGhlIGRyaXZlciBkaXNhYmxlcyB0aGUgZnVuY3Rpb24NCndoZW4g
dGhlIGJpdCBpcyBub3Qgc2V0LCBzbyBpdCBzaGFsbCByZXBvcnQgcHJvcGVybHkgYWJvdXQgd2hp
Y2ggV29MDQpmdW5jdGlvbnMgYXJlIGVuYWJsZWQuDQoNCj4gPiArICAgICBpZiAod29sLT53b2xv
cHRzICYgV0FLRV9NQ0FTVCkgew0KPiA+ICsgICAgICAgICAgICAgdTggcGF0dGVybls2XSA9IHsg
MHgzMywgMHgzMywgMHhGRiwgMHgwMCwgMHgwMCwgMHgwMCB9Ow0KPiANCj4gQSBtdWx0aWNhc3Qg
RXRoZXJuZXQgTUFDIGFkZHJlc3MgaXMgZGVmaW5lZCBieSBoYXZpbmcgYml0IDAgb2YgdGhlIGZp
cnN0DQo+IGJ5dGUgKGluIG5ldHdvcmsgb3JkZXIpIGJlaW5nIHNldCwgd2hhdCB5b3UgYXJlIHBy
b2dyYW1taW5nIGhlcmUgaXMgYW4NCj4gSVB2NCBtdWx0aWNhc3QgTUFDIGFkZHJlc3MgcGF0dGVy
bi4gSGF2aW5nIHJlY2VudGx5IHN1Ym1pdHRlZA0KPiBXYWtlLW9uLUxBTiBmb3IgYSBCcm9hZGNv
bSBQSFkgKEI1MDIxMkUpLCBJIHJlYWQgV0FLRV9NQUdJQyBhcyBtZWFuaW5nDQo+ICJhbnkgbXVs
dGljYXN0IiBhbmQgbm90IHNwZWNpZmljYWxseSBJUCBtdWx0aWNhc3QuDQo+DQoNCldBS0VfTUNB
U1QgY2FuIGJlIGltcGxlbWVudGVkIGluIHRoaXMgc2ltcGxlIHdheSwgYnV0IEkgZmVlbCBpdCBp
cyBub3QNCnVzZWZ1bCBhcyB0aGVyZSBhcmUgbWFueSB0eXBlcyBvZiBtdWx0aWNhc3QgZnJhbWVz
LiAgSSBzZXR0bGVkIG9uDQppbXBsZW1lbnRpbmcgdGhpcyB3YXkgc2ltaWxhciB0byBXQUtFX0FS
UCBzbyB0aGF0IHRoZSBXb0wgZnVuY3Rpb25zIGNhbg0KYmUgZWFzaWx5IHRlc3RlZCB3aXRoIHBp
bmcgYW5kIHBpbmc2LiAgQWN0dWFsbHkgSSBkbyBub3Qga25vdyB3aGF0IHVzZXJzDQpyZWFsbHkg
d2FudCBhcyBoYXJkd2FyZSBXb0wgaW1wbGVtZW50YXRpb24gaXMgbWFjaGluZSBkZXBlbmRlbnQu
DQoNCj4gPiArICAgICAgICAgICAgIC8qIFRyeSB0byBtYXRjaCBJUHY2IE5laWdoYm9yIFNvbGlj
aXRhdGlvbi4gKi8NCj4gPiArICAgICAgICAgICAgIGlmIChuZGV2LT5pcDZfcHRyKSB7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBsaXN0X2hlYWQgKmFkZHJfbGlzdCA9DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJm5kZXYtPmlwNl9wdHItPmFkZHJfbGlzdDsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGluZXQ2X2lmYWRkciAqaWZhOw0KPiA+
ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShpZmEsIGFk
ZHJfbGlzdCwgaWZfbGlzdCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlm
IChpZmEtPnNjb3BlID09IElGQV9MSU5LKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBtZW1jcHkoJnBhdHRlcm5bM10sDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgJmlmYS0+YWRkci5pbjZfdS51Nl9hZGRyOFsxM10s
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMyk7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtYXNrWzBdID0gMHgwMDNG
Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGVuID0gNjsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgfQ0K
PiA+ICsgICAgICAgICAgICAgfQ0KPiANCj4gVGhhdCB3b3VsZCBuZWVkIHRvIGJlIGVuY2xvc2Vk
IHdpdGhpbiBhbiAjaWYgSVNfRU5BQkxFRChDT05GSUdfSVBWNikNCj4gcHJlc3VtYWJseWUsIGJ1
dCBzZWUgbXkgY29tbWVudCBhYm92ZSwgSSBkb24ndCB0aGluayB5b3UgbmVlZCB0byBkbyB0aGF0
Lg0KPg0KDQpXaWxsIGNoZWNrIG9uIHRoYXQuDQogDQo+ID4gKyAgICAgICAgICAgICByYyA9IGxh
bjg3NHhfc2V0X3dvbF9wYXR0ZXJuKHBoeWRldiwgdmFsLCBkYXRhLCBkYXRhbGVuLCBtYXNrLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZW4pOw0KPiA+
ICsgICAgICAgICAgICAgaWYgKHJjIDwgMCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0
dXJuIHJjOw0KPiA+ICsgICAgICAgICAgICAgcHJpdi0+d29sX2FycCA9IGZhbHNlOw0KPiANCj4g
cHJpdi0+d29sX2FycCBpcyBvbmx5IHVzZWQgZm9yIHJlcG9ydGluZyBwdXJwb3NlcyBpbiBnZXRf
d29sLCBidXQgc2luY2UNCj4gdGhlIHNhbWUgcGF0dGVybiBtYXRjaGluZyBoYXJkd2FyZSBpcyB1
c2VkIGZvciBXQUtFX01DQVNUIGFuZCBXQUtFX0FSUCwNCj4geW91IG5lZWQgdG8gbWFrZSB0aGF0
IG11dHVhbGx5IGV4Y2x1c2l2ZSB3aXRoIGFuIGlmICh3b2wtPndvbG9wdHMgJg0KPiBXQUtFX0FS
UCkgLi4gZWxzZSBpZiAod29sLT53b2xvcHRzICYgV0FLRV9NQ0FTVCkgb3RoZXJ3aXNlIHdoaWNo
ZXZlciB3YXMNCj4gc3BlY2lmaWVkIGxhc3QgaW4gdGhlIHVzZXIgY29tbWFuZCB3aWxsICJ3aW4i
Lg0KPiANCg0KVGhlIHdvbG9wdHMgcGFyYW1ldGVyIGNhbiBjb250YWluIFdBS0VfQVJQIGFuZCBX
QUtFX01DQVNUIGF0IHRoZSBzYW1lDQp0aW1lLCBidXQgdGhpcyBpcyByZWplY3RlZCBieSB0aGUg
ZHJpdmVyIHdoZW4gdGhlIFdvTCBjb21tYW5kIGlzIGZpcnN0DQpwcm9jZXNzZWQuICBTbyB1c2Vy
cyBjYW4gb25seSB1c2UgV29MIGNvbW1hbmQgb2YgV0FLRV9BUlAgb3IgV0FLRV9NQ0FTVC4NClRo
ZXJlIGlzIG5vIGNoYW5jZSBvZiBwcm9ncmFtbWluZyB0aGUgd3JvbmcgZnVuY3Rpb24uDQoNClVz
ZXJzIGNhbiBkbyBXb0wgV0FLRV9BUlAgZmlyc3QgYW5kIHRoZW4gV29MIFdBS0VfTUNBU1QgbmV4
dCwgYnV0IHRoYXQNCmNhbm5vdCBiZSBoZWxwLiAgSSBkbyBub3QgdGhpbmsgdGhlIFdvTCBjb21t
YW5kcyBhcmUgYWNjdW11bGF0ZWQsIGxpa2UNCmRvaW5nIFdBS0VfQVJQIGZpcnN0IGFuZCBXQUtF
X01DQVNUIG5leHQgbWVhbnMgYm90aCBXQUtFX0FSUCBhbmQNCldBS0VfTUNBU1QgYXJlIGVuYWJs
ZWQuICBUaGUgV29MIGZ1bmN0aW9ucyBhcmUgc3BlY2lmaWVkIGFsbCBhdCBvbmNlDQphcyB1c2Vy
cyBjYW4gbWl4IHVwIHRoZSBXQUtFX0FSUCwgV0FLRV9VQ0FTVCwgV0FLRV9NQ0FTVCwgV0FLRV9C
Q0FTVCwNCmFuZCBXQUtFX01BR0lDIGJpdHMgd2hhdGV2ZXIgdGhleSB3YW50Lg0KDQo+ID4gKyAg
ICAgaWYgKHdvbC0+d29sb3B0cyAmIChXQUtFX01BR0lDIHwgV0FLRV9VQ0FTVCkpIHsNCj4gPiAr
ICAgICAgICAgICAgIGNvbnN0IHU4ICptYWMgPSAoY29uc3QgdTggKiluZGV2LT5kZXZfYWRkcjsN
Cj4gPiArDQo+ID4gKyAgICAgICAgICAgICBpZiAoIWlzX3ZhbGlkX2V0aGVyX2FkZHIobWFjKSkN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBTYW1lIGNv
bW1lbnQgYXMgQW5kcmV3LCBJIHdvdWxkIG5vdCBjYXJlIGFib3V0IHRoYXQgcGFydGljdWxhciBj
aGVjay4NCj4NCg0KV2lsbCByZW1vdmUuDQogDQo+ID4gKyAgICAgICAgICAgICByYyA9IHBoeV93
cml0ZV9tbWQocGh5ZGV2LCBNRElPX01NRF9QQ1MsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgTUlJX0xBTjg3NFhfUEhZX01NRF9XT0xfUlhfQUREUkMsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKChtYWNbMV0gPDwgOCkgfCBtYWNbMF0pKTsNCj4g
PiArICAgICAgICAgICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJl
dHVybiByYzsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICByYyA9IHBoeV93cml0ZV9tbWQocGh5
ZGV2LCBNRElPX01NRF9QQ1MsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
TUlJX0xBTjg3NFhfUEhZX01NRF9XT0xfUlhfQUREUkIsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKChtYWNbM10gPDwgOCkgfCBtYWNbMl0pKTsNCj4gPiArICAgICAgICAg
ICAgIGlmIChyYyA8IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4g
PiArDQo+ID4gKyAgICAgICAgICAgICByYyA9IHBoeV93cml0ZV9tbWQocGh5ZGV2LCBNRElPX01N
RF9QQ1MsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTUlJX0xBTjg3NFhf
UEhZX01NRF9XT0xfUlhfQUREUkEsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKChtYWNbNV0gPDwgOCkgfCBtYWNbNF0pKTsNCj4gPiArICAgICAgICAgICAgIGlmIChyYyA8
IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4gDQo+IENhbiB5b3Ug
aW1wbGVtZW50IHRoaXMgYXMgYSBmb3IgbG9vcCBtYXliZT8NCg0KV2lsbCBkby4NCg0K

