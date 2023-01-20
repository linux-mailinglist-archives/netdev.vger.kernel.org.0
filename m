Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2803B6756C9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjATORl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjATORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:17:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A22BCB50A;
        Fri, 20 Jan 2023 06:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674224216; x=1705760216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CnKDbuA7khGMqcVYWNnAspBPP/ZToBrxc+DigYwr6FM=;
  b=uWy61/6Z+03si/ACoFWe+m8S+GthIOpCp7Cm8mXQhSI/GZQ5SNVjjs3x
   BQwAqUcJnSl7542WVBrE4jdWftpFwPjT8VQq9SuhScZ9/UXfLLDlqPfHK
   4umU0XgwuuNQcuJOVH0NIt7QkOMSn/OH7V31UzFbCGwRTPCdDv2AsNSjd
   UzZwu6k1rAWv43wV4yQAiz1n0nW8HgwbcFX1P04YyjSv7T8ja0LxpW52Y
   ne2gFr5FP5QJdlO2vOTc4HjEnTxe9mOi34ooDE7M9cCk3dkE1w2IY3nsV
   DVKeksKNmStRwEfx5zq9+OedgGeVAyLHQ/if3Wk4Z6fRgGNfpa5ztZU6H
   g==;
X-IronPort-AV: E=Sophos;i="5.97,232,1669100400"; 
   d="scan'208";a="197636080"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 07:15:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:15:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 20 Jan 2023 07:15:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxSiQV3l3KyUrdnl05XVBtMAxP1DWn80WtML8pCnLqSjtglAyCdUzujgDp5AJyVU/Ud2rbI05r6f4e1N2BXW89z1XCGmQMCP+sSJzkjLyDOUi3gmuS6ywzpJUBgiQov/jvAhCZZbKwf7nZ86TkqXew3RCFXQV2t32tKoHm5ixRkMftl9aa0TLja47BXBJvLFn7DerToRPYaikJV2oeSFigDVRHK7ZYxqFGfVcED4qFM4RoeLF6Ivb9mPgHYUW1ohfeyrTdXVw/YpAsTt1hbRg3LLBvwsSpLZXtyfO8t+t6pbU45OT5tGcJLY5et8xTZgw8dOoEucewGb3dPaQKN3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnKDbuA7khGMqcVYWNnAspBPP/ZToBrxc+DigYwr6FM=;
 b=jQO4IA6mApvCG8TkspR/k/R1g9gZi3mREjhLwX0Cqw00Cfjy2ufahEGjndap0l6kQt3juYIDVNek7zKSLY9k/IkcIY1cg25shXMHCkZ8VdGPzlJ90i2nFi4O3jhr4I1lfj6/pOobk4+x00p0NzRxjBwF7RXq4bs/1tisbfjxbAqh3zzCHaFMHW/wrOxVsb8xPZAtH3jKKd9UreeRZtukqO4mzJFslwjzqG7MD3MO2uINUTns6dKV4O9Y79kKB8z00n9vD29hh3mWUjFS9aEyk/jmX5hPzDmD//SfSnfPi2AaTiSx/3CcqHvB3guWIMuNfIVq2FY114UUccKSElfj7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnKDbuA7khGMqcVYWNnAspBPP/ZToBrxc+DigYwr6FM=;
 b=qJ5GyQhlhLn4QtvOiAPzEE022SqvNObvkqj4R7byVMdshDf7khVR5wlNtOF/DhHueRbZFWciDQSwaxDt8pyEB2dOTq34LmDWugEtqE7M18f71mzxVh5cqLHAu3Czi3tIhbJDstqg2pi67qBqNfnfnusbNKVtoq/+DcgQRgqUtHs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY8PR11MB7291.namprd11.prod.outlook.com (2603:10b6:930:9b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Fri, 20 Jan 2023 14:15:46 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 14:15:46 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <linux@rempel-privat.de>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <a.fatoum@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <pabeni@redhat.com>, <ore@pengutronix.de>,
        <edumazet@google.com>
Subject: Re: [PATCH net v2] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Topic: [PATCH net v2] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Thread-Index: AQHZLL/IT5jbnb/AEke9xpXCu9rkp66nWd+A
Date:   Fri, 20 Jan 2023 14:15:46 +0000
Message-ID: <87797db7cec6f1a06876177fb6702fb18df2a836.camel@microchip.com>
References: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CY8PR11MB7291:EE_
x-ms-office365-filtering-correlation-id: 81836eaa-09cd-4378-e7fd-08dafaf0d2f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5cV1Ek17aOTUGYGPt8uFyaTYwYp8Qlpyn4XZLGgDXA4p+2/oKFwotR30/HIru3bJOUMzFBFJ+QKSf+rRZQQy9XypJEhgFlYRjV5WgtYLRmB6YkUj9rwqlH1C4aVtqAGtnwRfvd7DVGpE2Shx1MkciYSLgDpKw8d5T++RBC9AYzQpfN56uY0IN53eoUknGpvb0+QZEgQ6Q2N7H5/3NtUneu8F/F1sz4vablklVePfryD7iH1zx0v5TN2FojpXEo7hM4oQm9zD9nupPimz/SC80n8qfn1CXm6gjuc/Os72PcssyCxkq018gwMEOiE2FnMHaYOsfvA/3ZFjm+QG4JFOsMq7vYas0zfEK+cMujALOOXdY4U8SMNKOaNEWxBdfHYjoEU4GtghIvFikC/uc7EcAP2DexUsdSGeah6HQqU5aHmoB8w7fdie2GvTQM+1jgLqsbp4uUYClFtNPXkgej6okBqFpoi1B9qB3AJgJM5mIgYufMYK1b9ravlhGCoO4cjllklfQKZ1vD/ylq8j1fNAeuypwbHd8dsl+4IesiZfx0ko13MLAzkINHSRqbOIpuwgTnlQYOh8cjZwv8d/mRcI/2v9R5TK+gxLx/cnpWcQdbpB2WDXI28WnNFsronG1WRVm6YYwG6R9fwDhmiJMpKOLFGq6KVz4H6/njs64/0uyJz7I0MvnXnL8yejaM92dpDVtBbgwpo/zDI/CNyo3bCN0Y53+R4QyguJMn7m77xDo4Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(5660300002)(66556008)(91956017)(41300700001)(8936002)(66946007)(36756003)(8676002)(4326008)(66446008)(64756008)(66476007)(76116006)(6486002)(7416002)(71200400001)(478600001)(966005)(86362001)(2616005)(186003)(38070700005)(6506007)(316002)(110136005)(6512007)(122000001)(54906003)(38100700002)(2906002)(83380400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWI0bGdHb0xuUzMzUHVraXR5c2J2OXQyZ1ZtcW9jYkpRaHc5dFFsNG5DT05F?=
 =?utf-8?B?aXA2WG9vcG12OHVwK21lTmdrRzlyT1BiT1YzQnhoS0FpKzBab1hCT3dJN2w0?=
 =?utf-8?B?WUlweU12WGd6ZXVvNU9HZU5XeHJGQzBhQWFSTXMybUh2R3d1RHBBcHowQ08w?=
 =?utf-8?B?YlhsejExVHZYcHdxUXptYjMzSmUrbi9WMzZjRy9CQUFkUXRNS2t2U2N5RFJL?=
 =?utf-8?B?MXJRTmtLa2V5d2F4a3h6L1dyWk81K0oxbmMwMFlEOHlCU3I4VWgxYS9sTHVK?=
 =?utf-8?B?ZEpPTWwwRTdwcEdkR3NMR2p4U29HNkpWVVEvMWNDaENyWDMzTnkwZFVGaE0w?=
 =?utf-8?B?TUdiaHNyYUtUbTA2a0RlOGtxWXppWnVQM1huMHlCcUIrY0NwTVRHeEpvMXdL?=
 =?utf-8?B?TGFLc2YwMmNtUzFyNVl1ZlJDam5zbWNES2dVdnJMQUJJaTFFbjFJNXcraUdw?=
 =?utf-8?B?cHBwODUxT3NscVpITkEyZ1FPb3ZHc01rV3BrNlpqTDJyaHZkQmh5aldkd2Yz?=
 =?utf-8?B?WmtwYXVSNnc0b0JJQktoSzRzakM2R2I4dC9PejFIMk1KWG1LUHN2TDJmQVRX?=
 =?utf-8?B?eGZIeUhMYVI0dVkxZEpZdHcrQmMzUENxSlZYbVJ4SzZ3YjJ2bUN3ejk3VnZG?=
 =?utf-8?B?Mmg3OHMxK0c2Qk01WGZ5LzJFM2Q2enJaY2pzbVg5ZlUzeTYwaXh0UGR0UXQz?=
 =?utf-8?B?dzRjR3QxNkc0R1l5TkkydUlNeXM3QzFQRXVxeDJ0aERpb0ZkaGhvUXo2SGNM?=
 =?utf-8?B?bElZb3d6VlEvY3hQM213bE5SK2QrQy9Yd0NHODFmeGh1V1l5VjUyak9XV0w0?=
 =?utf-8?B?UTliVGF1YVdUQVpXbzdCem83S0kyVXBlZGsvcGRKRWJUd2hKUXY0NmNudEFi?=
 =?utf-8?B?a21jMzhNNjd4UEpHTDFiKytLQW16NUFXaGVYblFvelgwdjFaS2pYdHp1WWda?=
 =?utf-8?B?dDlVc0Y1amFaTDEwSENlNHM3STdrWEt5SVc2Q3k2RHRRcmF2MGVoaTFkQjNY?=
 =?utf-8?B?ZE81WGtXVklIYm90aUlQb294QmlqdllCMGxjbXhDS2FPMXFXOEFwZXNPamhm?=
 =?utf-8?B?VVhCK3pmeWd6S2pHQUhjdTJhVkxyaS8xdU5ldG9zcW1QY1lzZFBHWmNEekpx?=
 =?utf-8?B?RVVrSHFsSGpRa0Z2QWpGS3FZQnNteVdTQ1I5Zk5aL3BPWnpkdlZPZmgzRmQ2?=
 =?utf-8?B?Q3BvZVdRREdIS1N5S2NFOHBnY0JmWDdsc3FvUUp5TDFyQTl6VkRObmZtcGps?=
 =?utf-8?B?K1dpV1krTUsyUnNMZ1pXajNaZ3A5T3U4eE1QRWcxZy9WeFRTZTlVWE1MNUds?=
 =?utf-8?B?TFk2UVZramh6UjJOQ1UxOTFkWU5zbS9ZSXQ3SldEM01aTWJnQ3U1T0RnMW1L?=
 =?utf-8?B?elFRc0F6cTQzeGZSTUdSUlJMS3lMS1BWeUJVSy9aRlc3TzNNZFh3Umk2ZDFW?=
 =?utf-8?B?dG5yVXBneDdoVUZLQVNSSEZQTnB5YlBmSHB3akJyYUdQMEZaUWJodG5XbmtK?=
 =?utf-8?B?ZmVZUjk0d0g2Y2hIMEhmYkxINTZVQzFtRWh5TGhoQmRCQ1lDd3NMRHQ1K1BM?=
 =?utf-8?B?Y0p2b08xVXMrZUo4S0tWeU41NDlvUFliMVQvVlhPQWZSMTBYUUxQbWVBVnNN?=
 =?utf-8?B?TW1QbWF2a29ocThQYXJiUFMrdllOT0ltRmx2ZHB2S0FIQjZuOHVWR25pQ0Jz?=
 =?utf-8?B?Q3ZnV010V3N4NUtIN2ZENlVFa29rTDd6b3VLN3FlSnVURUYvMmhZN1FWTzdZ?=
 =?utf-8?B?ZnVJOUs4K3JGQ01LMkJXTXNxSnBYbjYxRGV1cHVxUHA5OGQ1NG8xeFVkeXdz?=
 =?utf-8?B?ZThQc1cxU3dGb0xKY3VQT1dCb1h4c2R3dlRFUlZIK0labHZCR0pFMXZ1Mnpi?=
 =?utf-8?B?cStoUDB2dElGcHZUR2ZVazJYYUdEd2s1Q2JNaU9sMkFIZXRZbmVQaWhqdmlv?=
 =?utf-8?B?cDVyY1MwOHVIM0VIeXd2TnBtd25rUjFiSE43TTVMTW9kUzI1SlZtM1pMU1JY?=
 =?utf-8?B?MVdMMHg1Z1BHcXRrZmV5cGJxV3pFaXdPNEp3L0ZYZ1RTTlhRd2tTYy9BZzdU?=
 =?utf-8?B?Qi9PWlNpOFg3L1dyclJGVStKa3YwTVBvOU5YZE04cG9vWVRkMVdLWEpDTzkz?=
 =?utf-8?B?eWZkT1EvbWZxOFZCNmcxSGF5YTlBaU50Vmw5UDQrSE15aXhDWlJlc3ppRnM1?=
 =?utf-8?B?Y2dqODZETEhPKzV6bGVBSmhBcVBHVnk4M1BYdjE4djlGM0F3aDd4L2FLLzZ6?=
 =?utf-8?Q?vbaG83eK3mzOiRTZIrRMI54wKdvamncYt5wz35nzmQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1D1D5583B8BFE48A0EAE7360DC5B1C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81836eaa-09cd-4378-e7fd-08dafaf0d2f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 14:15:46.4147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EmQRDAJXHjBBEgkJRADAT829/Xvj6xWtde09LBruPCH7Hga2tfDd8HQ8lKeMFjLKS9o2woOkhNZTEt9dbmNausD4UNFXrMeABiPo/Oooy3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7291
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTIwIGF0IDEyOjA5ICswMTAwLCBBaG1hZCBGYXRvdW0gd3JvdGU6DQo+
IFtTb21lIHBlb3BsZSB3aG8gcmVjZWl2ZWQgdGhpcyBtZXNzYWdlIGRvbid0IG9mdGVuIGdldCBl
bWFpbCBmcm9tDQo+IGEuZmF0b3VtQHBlbmd1dHJvbml4LmRlLiBMZWFybiB3aHkgdGhpcyBpcyBp
bXBvcnRhbnQgYXQgDQo+IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNh
dGlvbiBdDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
IFN0YXJ0aW5nIHdpdGggY29tbWl0IGVlZTE2YjE0NzEyMSAoIm5ldDogZHNhOiBtaWNyb2NoaXA6
IHBlcmZvcm0gdGhlDQo+IGNvbXBhdGliaWxpdHkgY2hlY2sgZm9yIGRldiBwcm9iZWQiKSwgdGhl
IEtTWiBzd2l0Y2ggZHJpdmVyIG5vdyBiYWlscw0KPiBvdXQgaWYgaXQgdGhpbmtzIHRoZSBEVCBj
b21wYXRpYmxlIGRvZXNuJ3QgbWF0Y2ggdGhlIGFjdHVhbCBjaGlwIElEDQo+IHJlYWQgYmFjayBm
cm9tIHRoZSBoYXJkd2FyZToNCj4gDQo+ICAga3N6OTQ3Ny1zd2l0Y2ggMS0wMDVmOiBEZXZpY2Ug
dHJlZSBzcGVjaWZpZXMgY2hpcCBLU1o5ODkzIGJ1dCBmb3VuZA0KPiAgIEtTWjg1NjMsIHBsZWFz
ZSBmaXggaXQhDQo+IA0KPiBGb3IgdGhlIEtTWjg1NjMsIHdoaWNoIHVzZWQga3N6X3N3aXRjaF9j
aGlwc1tLU1o5ODkzXSwgdGhpcyB3YXMgZmluZQ0KPiBhdCBmaXJzdCwgYmVjYXVzZSBpdCBpbmRl
ZWQgc2hhcmVzIHRoZSBzYW1lIGNoaXAgaWQgYXMgdGhlIEtTWjk4OTMuDQo+IA0KPiBDb21taXQg
YjQ0OTA4MDk1NjEyICgibmV0OiBkc2E6IG1pY3JvY2hpcDogYWRkIHNlcGFyYXRlIHN0cnVjdA0K
PiBrc3pfY2hpcF9kYXRhIGZvciBLU1o4NTYzIGNoaXAiKSBzdGFydGVkIGRpZmZlcmVudGlhdGlu
ZyBLU1o5ODkzDQo+IGNvbXBhdGlibGUgY2hpcHMgYnkgY29uc3VsdGluZyB0aGUgMHgxRiByZWdp
c3Rlci4gVGhlIHJlc3VsdGluZw0KPiBicmVha2FnZQ0KPiB3YXMgZml4ZWQgZm9yIHRoZSBTUEkg
ZHJpdmVyIGluIHRoZSBzYW1lIGNvbW1pdCBieSBpbnRyb2R1Y2luZyB0aGUNCj4gYXBwcm9wcmlh
dGUga3N6X3N3aXRjaF9jaGlwc1tLU1o4NTYzXSwgYnV0IG5vdCBmb3IgdGhlIEkyQyBkcml2ZXIu
DQo+IA0KPiBGaXggdGhpcyBmb3IgSTJDLWNvbm5lY3RlZCBLU1o4NTYzIG5vdyB0byBnZXQgaXQg
cHJvYmluZyBhZ2Fpbi4NCj4gDQo+IEZpeGVzOiBiNDQ5MDgwOTU2MTIgKCJuZXQ6IGRzYTogbWlj
cm9jaGlwOiBhZGQgc2VwYXJhdGUgc3RydWN0DQo+IGtzel9jaGlwX2RhdGEgZm9yIEtTWjg1NjMg
Y2hpcCIpLg0KPiBSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBT
aWduZWQtb2ZmLWJ5OiBBaG1hZCBGYXRvdW0gPGEuZmF0b3VtQHBlbmd1dHJvbml4LmRlPg0KDQpB
Y2tlZC1ieTogQXJ1biBSYW1hZG9zczxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQoNCj4g
LS0tDQo+IHYxIC0+IHYyOg0KPiAgIC0gcmV3cm90ZSBjb21taXQgbWVzc2FnZSBhbmQgRml4ZXM6
IHRvIHBvaW50IGF0IGNvcnJlY3QNCj4gICAgIGN1bHByaXQgY29tbWl0IGludHJvZHVjaW5nIHJl
Z3Jlc3Npb24gKEFydW4pDQo+ICAgLSBpbmNsdWRlZCBBbmRyZXcncyBSZXZpZXdlZC1ieQ0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYyB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiBpbmRleCBjMWE2MzNjYTFl
NmQuLmUzMTVmNjY5ZWMwNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3o5NDc3X2kyYy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3
N19pMmMuYw0KPiBAQCAtMTA0LDcgKzEwNCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2
aWNlX2lkIGtzejk0NzdfZHRfaWRzW10NCj4gPSB7DQo+ICAgICAgICAgfSwNCj4gICAgICAgICB7
DQo+ICAgICAgICAgICAgICAgICAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsa3N6ODU2MyIsDQo+
IC0gICAgICAgICAgICAgICAuZGF0YSA9ICZrc3pfc3dpdGNoX2NoaXBzW0tTWjk4OTNdDQo+ICsg
ICAgICAgICAgICAgICAuZGF0YSA9ICZrc3pfc3dpdGNoX2NoaXBzW0tTWjg1NjNdDQo+ICAgICAg
ICAgfSwNCj4gICAgICAgICB7DQo+ICAgICAgICAgICAgICAgICAuY29tcGF0aWJsZSA9ICJtaWNy
b2NoaXAsa3N6OTU2NyIsDQo+IC0tDQo+IDIuMzAuMg0KPiANCg==
