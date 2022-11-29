Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3A63B950
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiK2FIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiK2FIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:08:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C23F048;
        Mon, 28 Nov 2022 21:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669698511; x=1701234511;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rbDsPaowVVi5v5w4osjq4MdP/UFHJjNO1Y+JIwa43TA=;
  b=EkaCKNXJP9mOHCQmDxwWx1ZsZzSz2ZGFiHZRM5uMK8u5vfJ9yOkpov7i
   g6RE3MW24KNeGtSp6/6BrfRXR7Enjm4bnYXcN+weJUT9vW/KYvUwPGPl0
   gB4PEMRQgP5ppdRFL0RL3NUApERB+qvivM4omiazhm/hDV4lVia3LxBo5
   82IyVVoedjsxNPV55+XQIbeFWxdOLroWpJ8OdsDjBzf+M0te8YVMtHAXn
   sxv7agoNZYRlebkanVwHuQq6zUyCcFG7Crx3SAGGFUK6j3yTMadU97Rpu
   cOdKHfOmwy0xGC4341neWgLiMtf/Dp9Qoiu57wJVhGP4Otoh/ARUAjAyG
   w==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="125542043"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 22:08:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 22:08:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 22:08:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5/A7XEYxVFzfPKgtYL/FMekRhzFkR9wJXuO+sPpRYxXDZcaTvcCWO5ZKo7N59RYBIT6oE34Zdjr/EW/re3otBYfSlDEwGcQl8/gYpWzaVHDG1z+AwcrT/hxdqF42H0xq2sRotRotbxE9H1jrMZjXeoXphtczRmj2pEhhrXnh8CjvuKfxTHGJ2uFqMqqqMB8Bzjx+BAwtFnGK+RcgQKwPtXAdQR6eSUjCKvJQ3hxTikHfg97JeNLL6mWBXheADpuolf+ljkQAqG5P68A1TT5k6UNAk1IMIbMQdNkvVRpiADPIHdhVEbSnMX9GjHcDf53CoqQWoZiv+co9miFKZPbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbDsPaowVVi5v5w4osjq4MdP/UFHJjNO1Y+JIwa43TA=;
 b=iBhTNFVdGWMTD2+qwl6MvYPmyDx5/zrl84UUUdHgr/gZEPMeruT9JEm1i9acMHtROe9a7U7vo/ZphfkaMnCg5ORQEhi3PuK2VeeKOuebCLW2IqtIff0hmF80T6V0yZ/rwL1aMsV2x1eTpTUPv9AHUQDNzWW7IsXv73Bqjd8lR5pmd6BHMNDJeIG+8qv6D9MdXIisK22ruzF/ussg4/2i7fKSoOe9g2RpATl34kQw5JZvo9cnaqwukKi3Yb0pl0Kt3Gyqh6nRV+ReUd6jvRDzjKwex27TApQevx2lnNqtKkiw2NDq9fXb/ETDNbKDLler4iLz7kvITMRLL6mAEGMfbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbDsPaowVVi5v5w4osjq4MdP/UFHJjNO1Y+JIwa43TA=;
 b=gCuJ9iZVdkIS9hTyqNCM+9vqEk7jLZb8dLXs3zKPVvlfmfmDmur8RTwCHdWsampe+CcMRtuFnOx5brjtn0vHC/rhTijU2eiB+PQMS3QDaQ6U0TbAa8yI9Tl4rhIxj4h4iGW2Tl2ZLN4P5YaR/zFw1m6SjvX6F/p6VE+gtkV3j7U=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY8PR11MB7266.namprd11.prod.outlook.com (2603:10b6:930:99::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 05:08:27 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 05:08:27 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v1 20/26] net: dsa: microchip: make ksz8_r_sta_mac_table()
 static
Thread-Topic: [PATCH v1 20/26] net: dsa: microchip: make
 ksz8_r_sta_mac_table() static
Thread-Index: AQHZAyEdJJzl+aHOvUqhHhhxF8J+zK5VWviA
Date:   Tue, 29 Nov 2022 05:08:27 +0000
Message-ID: <95feafea512835412542815b7d2b9ab285d40be2.camel@microchip.com>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
         <20221128115958.4049431-21-o.rempel@pengutronix.de>
In-Reply-To: <20221128115958.4049431-21-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CY8PR11MB7266:EE_
x-ms-office365-filtering-correlation-id: d6d57578-6a88-4ec5-3366-08dad1c7c018
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmlueTZlwbP5JIAvV9nwr4z5dqVAIKBip2krx42ju5RDn80F6fqaXla06knugXYbLRKdTQ5mryWjiEaluz7Oqc/IvPWx46bmAjt5SS6ymgacdPio9uh6J5PvCq1mYByQuCnyc5ZwDW8BQEgfpUxKV4GewvsdM/k2c/fxsCXDB1bhLV6SZ5dD9/8ntfIYx+KKapI1DGcXK6rFWV68z+KKHlctKRGKdh1wSwhyyyfCcO9ubDYCpyaXQ4QU2ljafFswYDQr6ZB+4HRF8o4ljZBtRSb8qAW3OpJ+oJ07btv2SEGIBdpxrw3ZEzuRw2W9xU0YbqXcl+NbdLjBvcktO3CvCOyBTqSlp82UZj6Du9ePfq0rjE6e1h6/9S6wf9Wb1j9ErOySkGoTl9F6C/lInH8sFstMV+9e/6/Y+ojuN8YNcA+v2slMqGZn8lVi3U8djvyUFEpPLwcRLJjBhi5p6RBO+Xd4oFsVCl9BbSA31hECH3T85w1wfRITH3F9EDZTnzkqIk/nDLpdbE9Sh8hf6q0mDl0IE/DSY6slqCNqrAQOwCfHzWSIslBxFPNc2mvVKlCBigp7nzo5bvfPVwHHJUowOtHIgM9euQs/y943+b3gfwIt7BYCb9IVUw86P3w2ic1sJNQVlPvgulDqPQPb2NIFsXEItCj0py3ie52v1VBnIMRpwyvzhEeTsZ4ZnywE2dpiuQsP2yTgyKQFqPgGlZq91lkQ2kV1M0hxl1SI96M9qqgoF0nhbS6zwZUJBiO0c4sI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(8936002)(122000001)(4001150100001)(7416002)(2906002)(38100700002)(86362001)(36756003)(6486002)(38070700005)(921005)(478600001)(186003)(83380400001)(91956017)(5660300002)(76116006)(66946007)(54906003)(316002)(41300700001)(6512007)(6506007)(64756008)(66476007)(66556008)(71200400001)(4326008)(8676002)(66446008)(2616005)(110136005)(26005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVR2bEFDVlEzNkFhVVhtNmo1TnA3cW5zRkZnTVRYVkdQVmFGM1VTTUY4RXVs?=
 =?utf-8?B?QTc2MDlBRnoyWDJKUWdVY21ycEdYOUswM2dyMk9hR3lnWFhpNHNpZjJObHU1?=
 =?utf-8?B?Z3RmcXBVTnFRZTNJTFlJeEtERmYzU3czeFowc25US2N0OENOUE10aTk3RnlM?=
 =?utf-8?B?SzEzK1RkK1lqSElpZEdYUndpMzh3S1JQcGlPTFk0SGthUDJxdjNHejRXbG9m?=
 =?utf-8?B?ditCckJYQ3FjM0xPdk51M1BVeWZlQ3BVc3lJNlVXZHBZVlkrNTlnRnBuVHlV?=
 =?utf-8?B?U2dVWUZRbnBBQjdjUDd2eVJ4WUR6cS8xWnF2d3ZYZGt5cUFPU2NIVTJpMWIr?=
 =?utf-8?B?ZmRFRlNwK0o1N3dHSk9zV1pFMmtSY1IvVlpVUW1xNzE1RkpzdURzd1ZDRngw?=
 =?utf-8?B?K2hpam1OdTZ6OE9yS3Y2TEN3TUdad0Z4MEtoazUvbytzcm95eFZ3WGJURFg4?=
 =?utf-8?B?N0xJRzlPOTg2MStkUlMxUHkzdG4rd1oxVGFnbXRXam8wWm9RejdpcGhiUHQ3?=
 =?utf-8?B?MHNyUWxTcVBBaGRGMjVEcW03SUV4TlFMbU9NMDJWSXlZOFpvTnJzd2dGbU1K?=
 =?utf-8?B?bDRIdkxXMjBUZ1NHeDdDRzhmRXFzN1lZa2tBb3JjS1E5cFUxTE0wK010Mzhx?=
 =?utf-8?B?aVM1aG9yQVB4aXVuQW81eE5qbjJ3YWVYaEVObG1hN21XdTk3MC80R3ZJRlgr?=
 =?utf-8?B?TXlrTSt1eVhaVjhabkRtOW42Uk9qSE1XanF5cDRWWlJ6YWlUcDlabXBJMVE2?=
 =?utf-8?B?NmF1ZjZITTZMWGorZHFvUjJ5VmFnd09xTk5NZDRQWjkvaGlidXQ2V0R6Z01z?=
 =?utf-8?B?ektob3hGd2NPN1FrQkc1dUsrUENNS0RaM2FwYTNta3NMeGdIeDNjamVZSktz?=
 =?utf-8?B?WUVzVURmTlJqSDdBQzQwTzdYSEhYakVwbkdwU0NaMHBuN212K3IvVGJQVGZI?=
 =?utf-8?B?ZFFuQW5tdDVVSjhFQjhOV21NdDhmMWFsMlU0RlZtMFBmQ0w3QW16SzZ1M0Nr?=
 =?utf-8?B?dkpsNXBuZm40TkJ1TFhvQUVwem5hSXV4QWlIWTF4b25pbzZOM1g0WUtMYVph?=
 =?utf-8?B?bmZ6NmRxQk81K3JxZ215aExuTU4wNlB1dGs1MTVhYjZiYlJ0amdyUXNsTGky?=
 =?utf-8?B?S2ZOYlkxWCtFcjhpUXQ1MWtpZUZwcDZBcFIxWHVkblh3QmlZMDhpaEJyZFRO?=
 =?utf-8?B?YXRxcGE2K0duTkFPSnpaR2ZWNFIzWEEvdlM0ZXpaREpiNERGcHBMYzdmVDRC?=
 =?utf-8?B?K01NOEZmZE4wdE1haUIyMDBWajhZdk1MdzhkcWF4RUp3dndQUVRHZDBkNDVv?=
 =?utf-8?B?Uk1KSW5NV2dJS0E3YXBpcjZubE4wR2FHK0FrN3dKY1N5MlRkd084NVZXWjZm?=
 =?utf-8?B?d2x1U2lpVTc0V2p0MURIUFlkVlRML2FSV3RwWkhTdXhuRmR5QVdwQmF0N1h2?=
 =?utf-8?B?ZmFVdThjZThxS1NNN3VWdWVzTkxwT1NPY1V3elR4Z21mbXM2YkRuNFl6UHVP?=
 =?utf-8?B?TGtqTTZOUVZIcjZKVmhxLzdMM0k2TGpSUVZiekg3R2t6ZlBMcDFwUjBYOVU2?=
 =?utf-8?B?cXFGU2ZzNzhoeUJpMzZVYnQyVjJRcTB5V05zTHZLa1BrdEtYZXYrUzRpNGxs?=
 =?utf-8?B?YjBpQnd2dERFbXBVMm5ONjFLQmtHZFc4YWJGTmJYWmNkeVIxQzJTS3Q0MjFJ?=
 =?utf-8?B?b3Y3ck80WHNwNSt1VTBPRENaZUpNck83MjJDZktwckltWXEzMlp1dCtMY3cz?=
 =?utf-8?B?YmJlNzlsTVBFTlVoNGttTjlTdFFqV1NZQzZuZnNScDZtdDlOd3FxNmUzN3kx?=
 =?utf-8?B?M1VhZ1JxMU1saGpUSGxYSnhPcmpVYzNkNUxpckZpdUsyZUxzazBoeUtBQkE0?=
 =?utf-8?B?dkF0cWM5Z3Y0MFFNcDk2N0h2MFgxeE01WDU4Um51QnlPbCtkaFFlTG1tWi9x?=
 =?utf-8?B?eXBmRmNnMU1kNkx6ekJOOExsSWNhK01sV1RYL1h0MkEzOUxqbDJJZzZ0eGY5?=
 =?utf-8?B?dFRtNVg1MHdZRUJ0OFByM1hpdHNGZkFDT0w0d1ZFUGtNWUEza1ZQdS9ST2Jo?=
 =?utf-8?B?NENGRS9lTFZDMHIyYi9qY1dFY2RuN0p6ZVpXQnQvcXMyY2Myc0JFZ3ErWWF0?=
 =?utf-8?B?YWRrTWdScTA0Z3BtTHpUKzY3VkVXN2pYV1FQd1Q0Rm9rekdKUUxZaXpsbFIr?=
 =?utf-8?Q?D13nza75i73HgrfchpShf10=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3C1C5E841E8A2458B110BC310407077@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d57578-6a88-4ec5-3366-08dad1c7c018
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 05:08:27.7698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IjKe0UBWKkITi9XZug29Z9mhR4abB+CXivHJiIahXFRxiPQ9uQYVvLG2sO7sgMTQmRPIQAap+NqImWzuV09+q2EbddQU15c53Pud7podF0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7266
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gTW9uLCAyMDIyLTExLTI4IGF0IDEyOjU5ICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBJdCBpcyB1c2VkIG9ubHkgaW4ga3N6ODc5NS5jLCBubyBuZWVkIHRvIGV4cG9ydCBpdC4N
Cg0KWW91IGNhbiBjb25zaWRlciBncm91cGluZyBwYXRjaCA4LCAyMCBhbmQgMjMgaW50byBzaW5n
bGUgcGF0Y2guIFNpbmNlDQphbGwgYWRkaW5nIHN0YXRpYyB0byBmdW5jdGlvbiBuYW1lbHkga3N6
OF9yX2R5bl9tYWNfdGFibGUsDQprc3o4X3Jfc3RhX21hY190YWJsZSBhbmQga3N6OF93X3N0YV9t
YWNfdGFibGUuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBl
bEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tz
ejguaCAgICB8IDIgLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jIHwg
NCArKy0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejguaA0K
PiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OC5oDQo+IGluZGV4IGEyOGZhN2NkNGQ5
OC4uZWQ3MmVjNjI2NTkzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzejguaA0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejguaA0KPiBAQCAt
MTksOCArMTksNiBAQCB2b2lkIGtzejhfZmx1c2hfZHluX21hY190YWJsZShzdHJ1Y3Qga3N6X2Rl
dmljZQ0KPiAqZGV2LCBpbnQgcG9ydCk7DQo+ICB2b2lkIGtzejhfcG9ydF9zZXR1cChzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgYm9vbA0KPiBjcHVfcG9ydCk7DQo+ICBpbnQga3N6
OF9yX3BoeShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCB1MTYgcGh5LCB1MTYgcmVnLCB1MTYgKnZh
bCk7DQo+ICBpbnQga3N6OF93X3BoeShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCB1MTYgcGh5LCB1
MTYgcmVnLCB1MTYgdmFsKTsNCj4gLWludCBrc3o4X3Jfc3RhX21hY190YWJsZShzdHJ1Y3Qga3N6
X2RldmljZSAqZGV2LCB1MTYgYWRkciwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBhbHVfc3RydWN0ICphbHUpOw0KPiAgdm9pZCBrc3o4X3dfc3RhX21hY190YWJsZShzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2LCB1MTYgYWRkciwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3QgYWx1X3N0cnVjdCAqYWx1KTsNCj4gIHZvaWQga3N6OF9yX21pYl9jbnQoc3RydWN0IGtz
el9kZXZpY2UgKmRldiwgaW50IHBvcnQsIHUxNiBhZGRyLCB1NjQNCj4gKmNudCk7DQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IGluZGV4IDMxYzc3ZTA4NmE5ZC4uMWMwODEw
M2M5ZjUwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiBAQCAtNDU2
LDggKzQ1Niw4IEBAIHN0YXRpYyBpbnQga3N6OF9yX2R5bl9tYWNfdGFibGUoc3RydWN0IGtzel9k
ZXZpY2UNCj4gKmRldiwgdTE2IGFkZHIsIHU4ICptYWNfYWRkciwNCj4gICAgICAgICByZXR1cm4g
cmV0Ow0KPiAgfQ0KPiANCj4gLWludCBrc3o4X3Jfc3RhX21hY190YWJsZShzdHJ1Y3Qga3N6X2Rl
dmljZSAqZGV2LCB1MTYgYWRkciwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBh
bHVfc3RydWN0ICphbHUpDQo+ICtzdGF0aWMgaW50IGtzejhfcl9zdGFfbWFjX3RhYmxlKHN0cnVj
dCBrc3pfZGV2aWNlICpkZXYsIHUxNiBhZGRyLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHN0cnVjdCBhbHVfc3RydWN0ICphbHUpDQo+ICB7DQo+ICAgICAgICAgdTMyIGRhdGFf
aGksIGRhdGFfbG87DQo+ICAgICAgICAgY29uc3QgdTggKnNoaWZ0czsNCj4gLS0NCj4gMi4zMC4y
DQo+IA0K
