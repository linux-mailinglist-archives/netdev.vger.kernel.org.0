Return-Path: <netdev+bounces-2525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3F8702546
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42F591C20966
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C4A749F;
	Mon, 15 May 2023 06:48:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518E31FB1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:48:34 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24088F;
	Sun, 14 May 2023 23:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684133312; x=1715669312;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/9n7B88X0kxaJPIURxoCe2QWIFOJRsPldpzqPr94WjI=;
  b=xSSK+wmPoha8IZH8QddP3hHnAyTsip4YxxtNG2EGanD9+hAUXpUwqDJm
   CQzzBY8p0qvW23hgZQY3cbqgZ6hP2Voanvi3bb6dGsz44Spe5wdWM7NUF
   SGB0YeklUs5XPufbP2MHsBx1AqXuArDiZXoVHpNlWJb62Dhp5pbwgFudY
   6TFQGkL0ubfvSopffXDZzB0F3oJ3zK44gk2DKEIAPUngN8dR17vqOAxiP
   dSXJ5O7V1yWgQXNRmnTaEfI+rgcwLDRQU7Duw+iH/GjqS4qM0fm4CV1xt
   Jiqf1ihBPMHlC3MsPGjEYf7oDr9L9WGvq4Myxo+PPOGP7VxV9MM//klhM
   g==;
X-IronPort-AV: E=Sophos;i="5.99,275,1677567600"; 
   d="scan'208";a="225303608"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 May 2023 23:48:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 14 May 2023 23:48:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Sun, 14 May 2023 23:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx9xuOl/UNMfcCrTX5fzMNjF/XG5DVVJW3gXcFrFMIMbJHroSnuLclVerjDOLSwaLV7Pqs6Xuyc89Twcqxh8EEHHMQYNoubdTa9FuYRxniB5Q3N2+PGhfxnhij9fvs/aCYP+V1gfZxTejsyST+s9GjfG64WjPvz9FVxIdcyo0LYpt+2xxAnb4r01zuDtTPB8cOcRffC1Ud2SSbAL0asDqZQBq4WOLRkHt/4DnOOtp+IXPovNrdLoJyRN0CVxv3NlkdbpQSvRDYtDBad6i8TLqV96209l2+DlU86pPBrzs+p41iqCwgDss2+zht90EfFv8O/nDj65N7YjScdsZ2A2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9n7B88X0kxaJPIURxoCe2QWIFOJRsPldpzqPr94WjI=;
 b=E+hf+POhVWwVBYp8r2z8l0R2XgkwLJHfDRojBGTqmNCpPBwf4/tyflHDMIVUfSVKX1nT0vaZBuhBqBXWHR3DRvffistPcbNOtfWL2CwW7PQhe0pl2VTWI0i+WGYawWl4yznxrmBAgh6+9fheN2hbbE5EXMRsEZQQHP3B6zRI7n59HpoN9b1TALIHVhgNMqoyC3d6vLJaF3TEkbhZWzDQM3mwuP+KwWqCIgrygjMXzyfimoDAfD4mRcfiVMpmFa88uETp2OiwczKdLdI5IuIUoTpbbXL6xEtpXYwjGfrG+f31WxBgO1g0V7dByo29Bodz6jhJswBBBhgqjTZk5PBkKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9n7B88X0kxaJPIURxoCe2QWIFOJRsPldpzqPr94WjI=;
 b=Q9s7zLpdqpg2CF+i4G6fzT/v/MZB4ujHB6CFx0b8LuXMhVemtP36X6C+MiazW3BelJ5IDedleqbtUQwqdOIX15QmVTqvdmgIPjVVCjfYjOO4WlUpnrEZJRo2TieS4cnIVVndB/ejnrVy2sLzfFVKldhGTjNwBJKGuxyK7DBC11c=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by DM8PR11MB5669.namprd11.prod.outlook.com (2603:10b6:8:36::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 06:48:29 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 06:48:29 +0000
From: <Claudiu.Beznea@microchip.com>
To: <u.kleine-koenig@pengutronix.de>, <wg@grandegger.com>,
	<mkl@pengutronix.de>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <Nicolas.Ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH 01/19] can: at91_can: Convert to platform remove callback
 returning void
Thread-Topic: [PATCH 01/19] can: at91_can: Convert to platform remove callback
 returning void
Thread-Index: AQHZhvlB/ovBym25Gk6nG/Ou6VBDPg==
Date: Mon, 15 May 2023 06:48:29 +0000
Message-ID: <6fd7b691-1a60-4ee3-7292-aa401de16aed@microchip.com>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <20230512212725.143824-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230512212725.143824-2-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|DM8PR11MB5669:EE_
x-ms-office365-filtering-correlation-id: 18c5f8a6-eaa0-42da-988d-08db5510645e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3DtBR9KQCp5t6mshP23v2cyjz3nJp/Ty4rpU5zeoP/Z/VF/wRdJB0O58aP4mJay95ecNctOZXd7amsq2+cDczG/Te25CLKMaNcL+NLD0neGJxy8jM8zGcgMRMO19nY7/4tagysjWTuuFF01IkRUQO0+NisfnAT85pFdJAGpwDapWPJoiGnGeHOq6JdsLy4oejj6GOSfl/XChzMpPjbCFxJRLZUvxM+Aoq5Y2qBup3Po7O/202A4SxppMdcqPbSl619Q3vhB2aKlYe3VSLwxC1TFG9FKj2CtVjgasaoQkbz4RG5C6czeEtJ3OuDS9gWhCxuIVsiwBkSnvzSCTC8M+Jovc9yJdsI5gwPUSIE3WQhIOW81NGzDpuzHwOCH/uh6Z3oPHbNGV+ORSvcPkUEbrEn2wOKPGGgOQfFL8UNBy9PxBSKL7UzLg6ReS3IWtNccrBXox3JCwj+0UQ+xKqrRq0KPCg2UaRNrNjNNTJF9QE1VwN3tAXWP3Wz7MfteRnPvuAnTZIOQ452X5TP77357kPhFBDrlOIQ8cmviS4O8NGDbtC9Of4tDOFFQWCBSbIZGmScmB81VG0rj0M3CJNyWbM+88lbZ3+Ay6XZHIH37xMilw3z4lYhypOWvHr/PrrhWHpNrOuzzD9krnagc40zOO731cLugXS5Ooc5TCMjoQx02D4Tjhe1i9qPviNxyqCPe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(31686004)(36756003)(38100700002)(4326008)(7416002)(2906002)(8676002)(8936002)(5660300002)(31696002)(83380400001)(86362001)(316002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(38070700005)(41300700001)(122000001)(91956017)(66574015)(186003)(6506007)(26005)(6512007)(53546011)(54906003)(6486002)(71200400001)(478600001)(2616005)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk9PdEZnb3M5TG80dFlrZWFOamE1OUFjVkJkM2R6Y0JYdGNCb2FGZGZyamdT?=
 =?utf-8?B?TjZtbGlMMDJyY0pzTWlxRDJraVY3cjFjTmdRN1NVVjNveXZhZjNKc2E5R2J3?=
 =?utf-8?B?eGVKem1GYk5ZMTg3VUdhY1hjNnZDTmlrSk9ta1NTRk9GaTdUM0NZbGV4TFdj?=
 =?utf-8?B?d2lsSXhZS1VmaW1MWkpkZmpXbW5raXpPRUdxTUMzS2RFb1hHSE5jeFpTR3BC?=
 =?utf-8?B?cUNJN3QyVkx1d1hSSUdlNHZwS0xmVjlQMjNOWVdPM2d1WU9XTWlYamo0WWox?=
 =?utf-8?B?dmkycWtXcGN0Z1lrRUx4MS9QWFErTHRORmMvMUlUUG1PMzlVSDYvSmcvblNS?=
 =?utf-8?B?c1k1ZzVWZkgwS3AvODNiZG5taG5ZZzFhNFYwaGQrRjVla1VjUjVKWFFsczY0?=
 =?utf-8?B?L2N6a3JJWUNJcGp6ekIvcytBZVJEc1N5Z2ZyMWU4a0JwK05BZVdWV0JtQUxL?=
 =?utf-8?B?S2pzRmc5dGpUSnNuVEF4Q0xBSm1SQlV0SGVWQ05wT2ROSzFVazFWZWdDNUFs?=
 =?utf-8?B?NzRQd085Q0RQUnFpbnFFaWRaVXIzdzlBTVN0VlRRM2EvY09kUTZaZUd1cERi?=
 =?utf-8?B?Vi9zUU90cUd1QXR5TXRzMFBmZW4wWGVUMXFHUm82ODNFMVhGekRmWVFRZEoz?=
 =?utf-8?B?clRuL2FEMm10cnUrK09VdHY1emtHUHkvUW9YQmEzdndKbERkM0s2MDhGYWtX?=
 =?utf-8?B?UnJNbUE2RDliWVg1NXR6WmxGaTVjV0ZvQ3EyTmgyaUxsbVE5SGhKaU5qb3Ns?=
 =?utf-8?B?VVg5YWdwVGFWUHhWZzRJdFZ0b1NXVVdkeWRWT25MckIwTlVtUjYzOEZ6c1BC?=
 =?utf-8?B?K0Q0RnJZTW8waTBSZWwzWHRPdk1Qd3RNdHFVeXZhUEhBZ1kyMzVrcG9OYTRh?=
 =?utf-8?B?Y2UvMzBDaVphV0JTZXhkTUV2YzlaWVFaMkRzSmhzZFVheHNrWXJFRk9tQVc5?=
 =?utf-8?B?dWJyNzY2RU02bjFTL3ptRzZFVGpsS3MrbklkS2FrVTY2eklYT1JPTWdVcy8r?=
 =?utf-8?B?K2JQcHZhU25mQkI0d3d1c2pEcWRQd0JyZ0tPa0QvdlFtSnBnWVpCMGUwSjZB?=
 =?utf-8?B?c3hsYzJ3YUFsb2FwbmNEUzlZSDlFM0kvdHVOcjVSUVVKMnYwVno4ZEY0bmVP?=
 =?utf-8?B?ejZxeEJnT2dxZ0s0azZFaVBCb1REZmhrRDhHQ1hXNEpJQkE0SFpJRkduM1dx?=
 =?utf-8?B?aFAweEU0SW0wZ2pHZjVGMC9vbnpqTjhyek1BNnJJeUUxWjVUT2Jzd25ZNVRD?=
 =?utf-8?B?Z3o3RDU1RDFINXZhWWdHeFJpYTRoU05FMTVGZjVBOWtRR3Z6UmFjRklBVkUx?=
 =?utf-8?B?dk5sQWl0MTJPcnJObmhOS2lLUTAwNERoa09lVmdjSkpsRzdhdHJGWlBnY3Nt?=
 =?utf-8?B?aldsbWhtRkhQSDkxcFZYVUg0bzh1ZVRRWW41V3ZZQTljK0ZITGl2OU9FV2hQ?=
 =?utf-8?B?MmU3ZENWNkFpcVFPSDkxQ1hMUkllelVnVC84VktJUkZxOFV6UVkxeHNJcEQr?=
 =?utf-8?B?VXN6U1MyTHBmZXNTQmVSbi8wSThMYWNUV2ttTFNVY3ltc3g1NkwrY0dwWGJJ?=
 =?utf-8?B?RjE1NHprOE5sdkNKWDBLbHlhM1FEQnpmVU5HdXlHMHVjZEEvb0g1WWludjE4?=
 =?utf-8?B?TW9LcVh4K2lBSnUxL3FHT2FQSFF5UkZyV3RJQ0F4UjBkSUtPYXdQcmRTOG42?=
 =?utf-8?B?RWYrOXQ3TnFsS0o3blNBU2RmSW5SVm42STFSZWNuVy8zNGUzZk0xMFk1QXRh?=
 =?utf-8?B?bjRXSWJDUFJBQVlTSnhEU0o1OGxnUmptYTRWMjJRUkloL1FnVHl6bng4dTh4?=
 =?utf-8?B?OCtoeEJ6K0s0cCtYc1J5OVNScDlSdXFnb2lteGJOQ0I1dm5QUjdETE1jRElL?=
 =?utf-8?B?bjdkbVM5SlprTEJpN29xOWdNU0Y1eGR6R2E3ci83UFpEUkQzQjlRaEhCc0Jr?=
 =?utf-8?B?K1NJQVFnWjRMLzMxeC9MU2dlYloxMWJSK29lVWZLbThDUCtMVGZLMXhVd2RE?=
 =?utf-8?B?UVVjQ3R0U2FjSjI3MjBIZnlqZCtTVnk0aThUL0JWOEF1S1Izekg4SVNvSkQ3?=
 =?utf-8?B?VlNFWHlqZU1RZHRkOVh4TE9NRXUwYUZDVVJPdnhhdUFDVmpWWU9BQVJXemtQ?=
 =?utf-8?B?clRkRjFkZ0w3Szg2UkgrOUdIekpuWVV2b0NlMkZMUHdqZ0t3M0FNdUVmOW82?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAB48B3AA76E6743A4CC3452511F77C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c5f8a6-eaa0-42da-988d-08db5510645e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 06:48:29.4814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VbqW23pixav3FgUK7P8xqk1Z/hvbGGP190lFsmB0Lx/Iv+BYLypvCW2mGRGmSsL/4xbSdpwLCBGdYNF+CooVPuC9XARLk5BX8l0zjP1d+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5669
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMTMuMDUuMjAyMyAwMDoyNywgVXdlIEtsZWluZS1Lw7ZuaWcgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIC5yZW1vdmUoKSBjYWxsYmFjayBm
b3IgYSBwbGF0Zm9ybSBkcml2ZXIgcmV0dXJucyBhbiBpbnQgd2hpY2ggbWFrZXMNCj4gbWFueSBk
cml2ZXIgYXV0aG9ycyB3cm9uZ2x5IGFzc3VtZSBpdCdzIHBvc3NpYmxlIHRvIGRvIGVycm9yIGhh
bmRsaW5nIGJ5DQo+IHJldHVybmluZyBhbiBlcnJvciBjb2RlLiBIb3dldmVyIHRoZSB2YWx1ZSBy
ZXR1cm5lZCBpcyBpZ25vcmVkIChhcGFydCBmcm9tDQo+IGVtaXR0aW5nIGEgd2FybmluZykgYW5k
IHRoaXMgdHlwaWNhbGx5IHJlc3VsdHMgaW4gcmVzb3VyY2UgbGVha3MuIFRvIGltcHJvdmUNCj4g
aGVyZSB0aGVyZSBpcyBhIHF1ZXN0IHRvIG1ha2UgdGhlIHJlbW92ZSBjYWxsYmFjayByZXR1cm4g
dm9pZC4gSW4gdGhlIGZpcnN0DQo+IHN0ZXAgb2YgdGhpcyBxdWVzdCBhbGwgZHJpdmVycyBhcmUg
Y29udmVydGVkIHRvIC5yZW1vdmVfbmV3KCkgd2hpY2ggYWxyZWFkeQ0KPiByZXR1cm5zIHZvaWQu
IEV2ZW50dWFsbHkgYWZ0ZXIgYWxsIGRyaXZlcnMgYXJlIGNvbnZlcnRlZCwgLnJlbW92ZV9uZXco
KSBpcw0KPiByZW5hbWVkIHRvIC5yZW1vdmUoKS4NCj4gDQo+IFRyaXZpYWxseSBjb252ZXJ0IHRo
aXMgZHJpdmVyIGZyb20gYWx3YXlzIHJldHVybmluZyB6ZXJvIGluIHRoZSByZW1vdmUNCj4gY2Fs
bGJhY2sgdG8gdGhlIHZvaWQgcmV0dXJuaW5nIHZhcmlhbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBVd2UgS2xlaW5lLUvDtm5pZyA8dS5rbGVpbmUta29lbmlnQHBlbmd1dHJvbml4LmRlPg0KDQpS
ZXZpZXdlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+
DQoNCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9hdDkxX2Nhbi5jIHwgNiArKy0tLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2F0OTFfY2FuLmMgYi9kcml2ZXJzL25ldC9jYW4v
YXQ5MV9jYW4uYw0KPiBpbmRleCAxOTljYjIwMGYyYmQuLjQ2MjEyNjY4NTFlZCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvY2FuL2F0OTFfY2FuLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvY2Fu
L2F0OTFfY2FuLmMNCj4gQEAgLTEzNDYsNyArMTM0Niw3IEBAIHN0YXRpYyBpbnQgYXQ5MV9jYW5f
cHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgICAgICByZXR1cm4gZXJy
Ow0KPiAgfQ0KPiANCj4gLXN0YXRpYyBpbnQgYXQ5MV9jYW5fcmVtb3ZlKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQo+ICtzdGF0aWMgdm9pZCBhdDkxX2Nhbl9yZW1vdmUoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2ID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7DQo+ICAgICAgICAgc3RydWN0IGF0OTFf
cHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+IEBAIC0xMzYyLDggKzEzNjIsNiBAQCBz
dGF0aWMgaW50IGF0OTFfY2FuX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0K
PiAgICAgICAgIGNsa19wdXQocHJpdi0+Y2xrKTsNCj4gDQo+ICAgICAgICAgZnJlZV9jYW5kZXYo
ZGV2KTsNCj4gLQ0KPiAtICAgICAgIHJldHVybiAwOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlX2lkIGF0OTFfY2FuX2lkX3RhYmxlW10gPSB7DQo+IEBA
IC0xMzgxLDcgKzEzNzksNyBAQCBNT0RVTEVfREVWSUNFX1RBQkxFKHBsYXRmb3JtLCBhdDkxX2Nh
bl9pZF90YWJsZSk7DQo+IA0KPiAgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgYXQ5MV9j
YW5fZHJpdmVyID0gew0KPiAgICAgICAgIC5wcm9iZSA9IGF0OTFfY2FuX3Byb2JlLA0KPiAtICAg
ICAgIC5yZW1vdmUgPSBhdDkxX2Nhbl9yZW1vdmUsDQo+ICsgICAgICAgLnJlbW92ZV9uZXcgPSBh
dDkxX2Nhbl9yZW1vdmUsDQo+ICAgICAgICAgLmRyaXZlciA9IHsNCj4gICAgICAgICAgICAgICAg
IC5uYW1lID0gS0JVSUxEX01PRE5BTUUsDQo+ICAgICAgICAgICAgICAgICAub2ZfbWF0Y2hfdGFi
bGUgPSBvZl9tYXRjaF9wdHIoYXQ5MV9jYW5fZHRfaWRzKSwNCj4gLS0NCj4gMi4zOS4yDQo+IA0K
DQo=

