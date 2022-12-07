Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499F46452F1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiLGEPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLGEPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:15:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D984255CB0;
        Tue,  6 Dec 2022 20:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670386509; x=1701922509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S26Zn4KOsTHkA9bod+w6B/bS1h/8dpEjOtMcJ7o9sec=;
  b=nYuMOmJIcYj7oudAvLe2EfQiL3oEaglW+mNPmhwCHXMZlloFOuD6SzyD
   sNsrOofotWSklpisy5+xS+y1RKahrm54Ox8c+hzybKaZ2DLQARoyChq5M
   pth2exawWWOft3Os1Zf9QPryqhA6IaPkNIxeUYcWep9YYIyvz27/UzIv7
   6fTKJJWGdnE6FIiLrvCuYiv1Gn8txuNmP4n0lNZuW+hyWVeiQk+QeiMCe
   VEy/rV5MFnrKgjR+bQFLmoLwJJJiKz50nIZwCNLITy0AqpCjHlxznlpG1
   NbzRG5o7JlPTjJ5wgA+iht/HAR+UJEvXTB/+OJ33W7QMSm0iasXpZkVSD
   g==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="126862003"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 21:15:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 21:15:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 21:15:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpz1Lzg/+5KhQeWz0VptofOnrVDbhmemdcwxBFMwB4s/ZU2GOYb21qUpZqdasheJ2ROuKs1qI8TshtfDJ+HGQZFJx8qCPnPNN+C+hpN6u1/mKlgvzV8U2lwWumNEMKC/2wMFObuJrYG2Qvci3UtehzyikdVNWL19CcXFPoXVrvZ+bSl+n1GPUrKYOHsyLKGd9CjDkFx5s86V8YTK/LZkSzHflvRjwGuSv7gMt3BFhg8IgLb+mxsgW+lUGu+l0huFv01A6j5AGvzYlDD18gsOeXZwfcXzqzqIin/2nEai+LJw9XD12zsXlPtTEQzhESPBgnHRT6QZUe+/addK/6vEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S26Zn4KOsTHkA9bod+w6B/bS1h/8dpEjOtMcJ7o9sec=;
 b=C4CKM98GrIwPXSqomxw75Gji/dPhja8xBvc5agB59KZxX6DrCZ1kbC1gxE5a4eb77XNvZB2z6xGlJcoV5cTvmqWYT1k2GfrCM9rF2u7OZUEYn5zh/8vPDXUmmEGp0ZoFF6VygdhMmd4Hy3EnkAns4Bjua6NBWDanLDpLM7P8gQTDQvPEDyNRN5mF8S2CZEVojVnqba7bzFWARWEVmQdT116GPS3vE6ST81HpNqdIMn2d9YMwm9TAzRnL9u0+YX3NpW6a/PrUNptviv4Pg0Ny4s5pTEv0CCPKJ1WOFw/RnAFeNaUC5nt58/LbYSyYMPYkZILpyfHBw5xUu6Mrpxz/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S26Zn4KOsTHkA9bod+w6B/bS1h/8dpEjOtMcJ7o9sec=;
 b=mq/BBCkyhgCP8TvK7s0fnjX4e/dFFua56fYT3hO+/wHnKr7UL++yIaLYo4OSrZkaZwiHdEqi8RzFPmb/UdYVpqPIxbQTn6NdsZ0XgckQ1wHVctTTkJBwEuv9yhAyqok7avBHckyrIHhpPn8ys6SsHx/diN1Zf22BNQlMOVgzhQ4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MN2PR11MB4678.namprd11.prod.outlook.com (2603:10b6:208:264::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 04:15:05 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 04:15:04 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <richardcochran@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch net-next v2 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Topic: [Patch net-next v2 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Index: AQHZCVNlefZuQqLqaE6myiuoxvY9OK5hD5aAgADCuIA=
Date:   Wed, 7 Dec 2022 04:15:04 +0000
Message-ID: <27ed1d631d1c804565056c4ff207dc66cfa78c80.camel@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
         <20221206091428.28285-7-arun.ramadoss@microchip.com>
         <Y49v73+Hg7x3JhFS@hoboy.vegasvil.org>
In-Reply-To: <Y49v73+Hg7x3JhFS@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MN2PR11MB4678:EE_
x-ms-office365-filtering-correlation-id: d5c51335-f765-474e-8066-08dad8099e53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mCqzOThSG5AGk1vM7HFWHtzOLorsWNvTIVf4XdzemHwY7K4n8ZCQdSM+mggCCEWsFqeW6FvlBaXjWWWT60ccZ+qbSbbO+vyCYvlETfnBB0uK0+OrBVOhI/MmENMhrQbQJPxMgW1A0kPanC5qrqvwMFBwNesbLWZYbgyezqfSmr/ITdVynxMwQe+qzqPwt7OcG5Dzo03hyUaRQoX1/gWHyr+K9axqPpI7E5KIkgTIMVN4yZgXUJ1WH1PYPty2kZGvSx279blHSRgweNREnjxclnT37x/0jsoziKpWxtvx0rqwc8ElzMLUuOfTG1714xoMlBGydgkF9rlXLJQG3QZ/TluszlckMYumIUgLUZFjosJDJMaXg1BjydTXP3dvhAdX4IfRNEUKYrgCrafzzHocp8uPDRjHytoVsPIchF9VaqV5t1XwEaUFd9nTbeRuo2bS5N+uQW/8/0SqBz2OVJQmToIwqyEntsFtp+YiKaKMzOGN/0QnXRufL1lQVmqClTZ1SZDlF5reW1vDU8FEt/DdXBd+3rMZUIQSvOAnSOBZoOIzV97heUMKjspqbttLfiyg7n748s5P9rAac1/XGOWKZeJs2410nsdCVOMznajflokD3FWpPkL6vUE5i9Od9cTj7PjgnUqsgNxCCdJOO+Ud3zjT9hfn39D+HF2n/ygzg7gvGj0L2VLsXXoqri7dh0jEtaro4qxmtdXspmW8a2gP+SnXcKRge9VXB79LTd2fTPKhbw/Uk4ygBVFbWtxAahuL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(66446008)(91956017)(66556008)(478600001)(64756008)(66476007)(66946007)(122000001)(4326008)(8676002)(38100700002)(6486002)(76116006)(966005)(2906002)(186003)(71200400001)(6916009)(26005)(6512007)(86362001)(54906003)(38070700005)(83380400001)(6506007)(8936002)(5660300002)(7416002)(36756003)(2616005)(41300700001)(316002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N28xQTc3cjFzWExTb2ZWWStaM0YwemQ2TTB4NEJFZ1ZyeWdUS3RLc3pBMnJ3?=
 =?utf-8?B?dG5HaWVJVEE3SlpxemMyaXBubWF4cG9iWnZZdDYrVlBqMWYrVFRRNTJrUkYy?=
 =?utf-8?B?UVNGdXE3OGdmK2NkWEFhNFIzNTI0THgrSFlUZzMzbEJ3RlNkN2tmV0JDVE1o?=
 =?utf-8?B?cWVQblVVVUtIVmc2TmNOSStnUTczd3JWMDM3Q1hpMysyc0lyR2JCNkxxTDlB?=
 =?utf-8?B?YVNBK0pvZ2hESnFSY1E5bk1vdS9RUDI0UmRacnFXSWNZd3EzSGVQcWUwZWdM?=
 =?utf-8?B?aUtmelcveHJ5cmVhWlNuclY4SDlXam5KYksvaUZvK29vcmxQQnUrZG9jYzJM?=
 =?utf-8?B?cDRxdENnWmpobVNuc1dWL2x1d0k1amZONUtrQlJaczI2U0thSGFHaEt3T1pL?=
 =?utf-8?B?dGl6aWx0bXFBVUc4amx3OXV0VHpXWmhtVkVpdzhPMWV3QUlaSmltd0EvZmF0?=
 =?utf-8?B?TXJQRWQzR1dBT3dPVmQ5S2dTU2k2U1VNZ3hYMlN4SjVpMWhDSU43M09MMnRV?=
 =?utf-8?B?bnVrUHBnek05bnAwbnBEaEdVR2Z3R3V3VzdUZE9wQjlFTklNRG9OcWFKS3dj?=
 =?utf-8?B?OWZ3NDFEQWFFVW11a2tWa0JKZEVlVXlkRFV4RnlaeDIzUXJRL1dzY1NmYS9j?=
 =?utf-8?B?NmFmdC9YVjB6QlIrZmVYOUxvWFBDOFQ2R2FPQlZicUN6VkRhekhTek5aQUhP?=
 =?utf-8?B?NEdpd3ZZcnc4NUVCLzhNRHVOR3UxTWdIM0F1dE4wTDBaWlArbVFiZVVTdG1a?=
 =?utf-8?B?MDJzaDVuNDFrbkQwdnNHUmlvNXJFcHJVRG82K3VvNUZZZVFRbVIvbHBJR1Q1?=
 =?utf-8?B?Qzk0TGNFVGdxSW9OR1pWc2JBb0NRT0pVV0QwMVZTWGdUdEk4UmFyaG93VEh5?=
 =?utf-8?B?cXNnWWpqVmRCMXRTdno0Qk9RQVcvNGhkMnlUQXRocHUrM1BORSs0aFl3Wnhk?=
 =?utf-8?B?NVJiRG9jM0ZqMVdiaFN4QVFvRkNqSzV6ZXJGNTN2RjltUXR6R1l2ZzlhTUQ1?=
 =?utf-8?B?QW8wWkU2d1pmZ3JtT2tEVnN5ZVoxR1I0anUwQnA3dDdHelZCNnZaNHZrdEx6?=
 =?utf-8?B?V3FXSDBmQnJBNW84WUphcnp6RkNMK1M4NlFNNkV4aC9xMGppTmtMMFRtQk5V?=
 =?utf-8?B?YXhOMW1sUkw3SmpMZU8wdHQ1WHpYT3NqVjZpZ21GWHVUbjBiUVRFQUhXeHQr?=
 =?utf-8?B?L3h0aWRuRU5BMFY3VHpSOVdqbHVvUjJjMVlVc1FJeERqWEU2RlljRDhJS3Bw?=
 =?utf-8?B?MVB2K2RadEdYM2RmcldrZ09Hd0xDcERKWVV5TnRTK2ZIdzJrNWh2K1g2ZjVh?=
 =?utf-8?B?bXhCMDQvSmRJSlZjZ3hmR3dlYmFJQWU3NHJGbDg1cnZoU3JYdFVESFlLQ1Nk?=
 =?utf-8?B?bXNRK29aY1dVbHN5bnpFdk8xV3IzMUdDNTdTUFZ6eW4vQkNDWmNDWkpnUWRT?=
 =?utf-8?B?aWF0SUR5T3MxZVJpSCtsL1NyOGpKSk1WT2M5VTBpd2lnRFZPcWtxNzFIbzlG?=
 =?utf-8?B?c01idWtlT3htYUJhazUvNWp6ZEZocEt1VGhCdFEzR2RsTXYyQmk5bmpyK0RZ?=
 =?utf-8?B?KzJXelRkcGw0UUdYeU84VGRLNFZtUWpJQnJjZHJKam5tbUFhYkt0REJkNDcz?=
 =?utf-8?B?T2FNQmFvcjRnTW5qczRIS0ZLdjJLdEVPMU5MbTcyTUJHMWtKakFFbDNSc1hS?=
 =?utf-8?B?emRPdm5NdnhIY2J4OXovOHIyamVtUkdoQ083c2tVMkVIMFBsWUJQVnBHcURO?=
 =?utf-8?B?YisrWkFRZi8rZ0t5Y0lnTkU1OWpzMmJRWG5MZk9ocUU4WkwwbmhuUUJMN25o?=
 =?utf-8?B?bXkydkk4TUxlbDhWU2pEMWxYU05rTVlJQ0VQZ1RmaFU0Y05MNkYyK3llZGdP?=
 =?utf-8?B?OEpLTWtxQ21JTERXdVNnbnhPREk3WVdxZGpIRHNNV1lhaFppR0dlbUJrYlJh?=
 =?utf-8?B?ek81YnVxZVM0dUVaMzJOQ3N0ODF4dWFnT3I2SzRoZlF0UG80QlFoM1p2czBz?=
 =?utf-8?B?ak8zL3dUZnpKQjJESW9KN29LeVFuZkM2K0RONGxsSGN1aEpjY1ZUK0N5VFVS?=
 =?utf-8?B?WFBSYXdKVERJNExwTEFSOWlYVjkyZ1NSQmZ5cnRscGpUOHdOYVVTQjNvUUt0?=
 =?utf-8?B?V0ZYcEpsTGxjR3dIZzFVMFdONDRNZEVtVStwSE1uTTFwU1JWaklma2ZGRWc3?=
 =?utf-8?Q?bfKVBw+/NsqlJ0SPoRV16J4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0F69810A5E4CB4C952AC6624E000A56@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c51335-f765-474e-8066-08dad8099e53
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 04:15:04.8768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zpbDEM8E32r1rucznwb9nRwitkipI9jpT9f7ZrOZNeTSUSHmcBlMuhosR6X0uZtj8SzcG4lWOnhfz5LLkK0uVjtubgoJ3W57Fsyoq589yc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4678
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCk9uIFR1ZSwgMjAyMi0xMi0wNiBhdCAwODozOCAtMDgwMCwgUmljaGFyZCBD
b2NocmFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4g
DQo+IE9uIFR1ZSwgRGVjIDA2LCAyMDIyIGF0IDAyOjQ0OjIxUE0gKzA1MzAsIEFydW4gUmFtYWRv
c3Mgd3JvdGU6DQo+ID4gRnJvbTogQ2hyaXN0aWFuIEVnZ2VycyA8Y2VnZ2Vyc0BhcnJpLmRlPg0K
PiA+IA0KPiA+IA0KPiA+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4NCj4gDQo+IEhvdyBjYW4gYSB0ZXN0IHJvYm90IHJlcG9ydCBuZXcgY29kZSBhZGRpdGlv
bnM/DQoNClRlc3Qgcm9ib3QgcmFuIHRoZSBjb21waWxhdGlvbiB0ZXN0IGZvciB0aGUgcGF0Y2gg
djEgYW5kIGZvdW5kDQpjb21waWxhdGlvbiBlcnJvciB3aGVuIENPTkZJR19ORVRfUFRQX0NMQVNT
SUZZIGlzIG5vdCBlbmFibGVkLiBJdCBpcw0KZHVlIHRvIG1pc21hdGNoIGluIGZ1bmN0aW9uIG5h
bWUgZGVmaW5lZCBpbiB3aXRoIGFuZCB3aXRob3V0DQpQVFBfQ0xBU1NJRlkgZW5hYmxlZC4NCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMTEyOTA4NDcud1c2eENiTVQtbGtwQGlu
dGVsLmNvbS8NCg0KSW4gdGhlIG1lc3NhZ2UsIGl0IGlzIG1lbnRpb25lZCBsaWtlDQoNCklmIHlv
dSBmaXggdGhlIGlzc3VlLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWcgd2hlcmUgYXBwbGljYWJs
ZQ0KfCBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQoNCkkg
aW5pdGlhbGx5IHRob3VnaHQgcmVwb3J0ZWQtYnkgdGFnIG5lZWRzIHRvIGFkZGVkIG9ubHkgZm9y
IHRoZSBidWcgZml4DQpwYXRjaC4gSSB3YXMgaW4gY29uZnVzaW9uIHdoZXJlIHRvIGFkZCB0aGUg
dGFnIHdoZXRoZXIgaW4gY29tbWl0DQpkZXNjcmlwdGlvbiBvciBpbiB0aGUgcGF0Y2ggcmV2aXNp
b24gbWVzc2FnZS4NCktpbmRseSBzdWdnZXN0IG9uIHdoZXJlIHRvIGFkZCB0YWcsIGJlZm9yZSBz
aWduZWQtb2ZmIG9yIGluIHRoZSBwYXRjaA0KcmV2aXNpb24gbGlzdC4gDQoNClRoYW5rcw0KQXJ1
biANCg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJkDQo=
