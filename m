Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAC16897AA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 12:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjBCLXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 06:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBCLXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 06:23:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E603A3646E;
        Fri,  3 Feb 2023 03:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675423414; x=1706959414;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C/ieXlHr7r9VEapVlIuxYRNu+No9kuzImiikSM9rRaI=;
  b=F8H53V5LkhwPl8fWmAEXosvDux2KdxKVl3m7dZtLXMc+zO+Z+tm5kEBP
   LqowaeNeWzQtoZf5bpDVIpRwvmLw2CMiSbU1FLmrd25ElC5tnEFviXhf+
   WWOP7wY0IPMRtE7fo0T0g+Gc4249vZjGN3ZyGor9WkDEsBR0GfppEpGzm
   MretLHJNCbmT86SyFD9JTlmAomwBCSO3MvQdVBZl84KXhsR1MQgJ6HYWB
   OuH7XOS5Pawqj453xRcD9PGVQYH2Wtly6+CAmrlAKelwL8Ik/h69fGUGH
   kwvK1inLHbL2dk40lT6vQ5z2j3wJsOXchWYLHaZ6Vn3uPJz0lI2j2HbQK
   w==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="198790566"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 04:23:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 04:23:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 04:23:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z33u7jLZY52oixa89VleHJFLaynVEliSRJDqVe2Pgh9joN5sl3kut3qyYM+685v3nQCBp64oWBdxg2z4vvKsXiSZgeunT3nEaWyqUkubXRT0tTb7DOalfUW9T83sG4txBx6k4WrfZTiKQx2GKopGg8eSxHl2nD9eLSkRY5y6VJ1f6deFnRygXBEHHqNZcsYu/T2zeIr3n0xsEaapMXSA2yW4u3WSJm1Pcrk1ggW5Bqr7+ju/hLttNXlaPK1JKW1vMraUjc4u3rC1eg6svyVGrbhtfYY9tEz4NwWn1XRn9rrUbJvH7b5WZPQjYlP32nk+Kjc7UkUd/B4/fsGmtRCqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/ieXlHr7r9VEapVlIuxYRNu+No9kuzImiikSM9rRaI=;
 b=d0pkChX19JC7o5fh81dmPfmBDfsYkj/B9rM26CSI620fNtWLI86EJsF6CEHIexUbFKIsG5Smu7JpIcnKa/y/85QRtr4ktISNcpH4bCOqX814ktCOKo1dfJWsjWJyNaRwMAEChWtPamZ28rZmf6u4aiVb17C0XK9EeFrpiBAbiCye0XsQzdi1pi72lsrdH2yyp/LNzfWeLTfFSBExPGScWWZm5xo9GxW584TRHdRbuff3kfurZJSsx7svq4y4AdmnSSAXG2s9lCmEHwHud+XMCAnatz6p56miR4aKInWM6TysbBSLZah8FhiR5ITQoAdYmzyMTDYtGXAu4joPTmCqsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/ieXlHr7r9VEapVlIuxYRNu+No9kuzImiikSM9rRaI=;
 b=E1XpktJ/LtiTJjuK31w6ehKoSbMzLRunFuvEugPAfOiEvGZWEwVvF0LW42r4sY66ehsRMzRpYFmAcAnh5LPwvS+7q71XgBi1EbYOrC/11+fXhtyHNgygz4cQnGSWSR23udMYIOYryAR9u0Tfzl1YAmHh26y2rxI+U3FZPMw0Qio=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CO1PR11MB4868.namprd11.prod.outlook.com (2603:10b6:303:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 11:23:30 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5%9]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 11:23:30 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andrew@lunn.ch>
CC:     <git@amd.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macb: Perform zynqmp dynamic configuration only for
 SGMII interface
Thread-Topic: [PATCH] net: macb: Perform zynqmp dynamic configuration only for
 SGMII interface
Thread-Index: AQHZN8HxpjPQehAis0OgrG3/voWKyg==
Date:   Fri, 3 Feb 2023 11:23:29 +0000
Message-ID: <b8c85e4e-d426-a68b-2d3d-704fc7675963@microchip.com>
References: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|CO1PR11MB4868:EE_
x-ms-office365-filtering-correlation-id: c3b7fa19-8938-42be-a36b-08db05d913bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mM3nZcjX3NdpgToGOCWDZF73TQt8fMVPURjKeZAiPvnnOF+COq90EzVigdwWqQybBkPZjvBHKBycoLuWZZvL2Uum1Mt0gjsmK3bz+8tySXHx1w4qirdpvMZYB8fpIBVW7cSb5qGpURLf85AX26uTaPcKtUUBjV4/FiRz6rmDF+olRHfP1nh59Yg//h0lJc5lkgl6sq0qgLJDeHSf3AVSDoMPVUEjHq1m58HfxWsumUjKRLvSQLXLXOSPi3x7DD/fu3AF4ecbtkuStaqDGE5xG/xYCTKuhfsIjJs4E+9KOueFlVKkEoMMhw8Ch3TZ80uhuN111v11A9hV0lqJAjjLtr9uBFrvCt793q3+zyK6KF2oV5wiq7fVSmXYa4UvhEaCv0lmvFrmKlT1hmt4GtiEcu4NI/fRiqzAzpzryJhioDZHQpBNLlwZlESU2VymiiVcnw0LiGNMsHGgo48XbYSL5cbFyOLbeFJssTnaSrbvdohP7kaSwH+4HsUEUAkpQrvMaraRFz2PfB0g03aYO/9AcSHdXu+zVcs9hgnBNtYPb+LMFHqevWx6+aOik+2xJOQqDeYBe9e7WewQTsFc1bQaLJ/e60fjNnigctTTRQae52bc2e/6V8GQqc/6iZiD4BFKyGn6oUc9KNv1dg+ALOQsbOrq+ommDUeFBuaATK2qlCMw5lmH1wP8mCRSfWaQXaoTqKNOgEqB4RPp+q2aXgNZOFQYQqVtxONocSjgpPIOxqfgPllgb+IPKHI7ua8aWmhgJCgU6AyLZibvUKUCAEkbew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199018)(31686004)(36756003)(31696002)(86362001)(122000001)(38100700002)(478600001)(53546011)(6506007)(83380400001)(2616005)(6512007)(186003)(26005)(38070700005)(54906003)(110136005)(6486002)(2906002)(8676002)(91956017)(76116006)(66476007)(4326008)(316002)(5660300002)(66946007)(66556008)(66446008)(71200400001)(64756008)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0RzZE94Q3lDNzlpWmlyempxRktmemZoVGp1YWdOb1pGWDJsTTNQVEdaZlFm?=
 =?utf-8?B?cXRFT0UyMjh3c09zUURnN1pHNmVZWHM5blVobkxrdWpnLzZyKzlqM1NFTTIw?=
 =?utf-8?B?NlU0RElHaGU1dUUrb2JRVmRaYmFSY0RRYjJ6bktLNS9xMDJHM0tZcE1IQXdT?=
 =?utf-8?B?cWtSeVdUZ0JXaVZwWTY5ek9yWjk1UUdXdk5aRVZUeHRTMlMrZUd6cFBjQnJr?=
 =?utf-8?B?WG5ML3Y0aEFtUkNheFhtMy9LckRhZ3JxeE80RlovRWE2UWNNVHJPR3ZsLy9n?=
 =?utf-8?B?NkxFMnRqUStvaW5ScGhQRTlUSUdZSWE2TUpOb3dUNkRUSFNkM0lmVmtTWXdE?=
 =?utf-8?B?R3g2a1JVa1BwRFFpZXVqTkhmTitvZ1duaVhkZ211NDVFaTBxNC9VNTBQQnpw?=
 =?utf-8?B?a3I4cEpCVjBvaGJCMGJTa2FKVkJMTW1WNVIvL0hkMENWS0RuR1ZXRGd0bm9G?=
 =?utf-8?B?QXFrT2srTWF5eE1ZYnJpSU1tRE01dm9qTmcvbXUzeTJ6QkVLRlB5N3YrSDdy?=
 =?utf-8?B?UXpXYUtLd3FyREtqQzJqZi96WUNjZDJaUFVIc0ZOZXhFNFJUdWZZeGpTU05S?=
 =?utf-8?B?dkhNNVd4cUdlWkZENkN3cjFUZmZPc1pYR1lxellkbFFnNmJlcEd3bkRNclpP?=
 =?utf-8?B?SUVYcCs5WDFXTlVZRjhGMTZYa0oyTElaZ0d6eEc1U1U4ZFZmVmhTNTRqV0Zn?=
 =?utf-8?B?N1NxZWFseHM0SjlxMTVVR2M5TE42bXR3cXQ3QlQvQ2dUR3ZpenNuNjg5eHRW?=
 =?utf-8?B?cjVOWndXYnFmYmRJZlJFR1YzSGFGbEg3REpWaE9XRklGOWRhVksyM2VMb0JL?=
 =?utf-8?B?d2djM1JNY1ZQeWVoOTFFWGZsejhPdVFQdGZ1WklPaEVaN1VWbFJyM2hwejdi?=
 =?utf-8?B?NEdYZkVvVXpUU2o2U1BaeEw5TCtBWGJpY1VKejRpZldUZllIdXc1UGN5eDZw?=
 =?utf-8?B?YWZ1OGxkYkNIMUFBcjV1ZU5ySEovV2JaQlg3RFF3NkpYdk54ejVGbWhlcVRw?=
 =?utf-8?B?ZjhMUkhWd01Qc01mNXBCbzJHL3dmTFQzOVNMTGVwUGNhK000d25vQUN2aWJ6?=
 =?utf-8?B?NFBCQkxLTVIyRDgwcjhvSFh1dWVMSE1VclFlaFFweHlyTDRmbmlvdGZnUkRS?=
 =?utf-8?B?S084Z3F0YjFoaHh1SlFsQnFlUHZoRTBkcVVUZWZUck9IcHhqSmQxUkR0Ty81?=
 =?utf-8?B?MkJDS1c5OUIvQjY3SUQ3MFZVVTZjK2NHNkFhVzRIRmFNa0laMlpDMXFIVS9V?=
 =?utf-8?B?Mk40cXprNEMwMW05bFlFYk1CZTh0SGc5TTljSG9OdGxOb0Z4OHZpUmhzdFpr?=
 =?utf-8?B?cjF0T2plT1ZPajd2cG1yNW1jcUN4d092UU9CVVMxT3REbXBlM052UVdVQ2JF?=
 =?utf-8?B?bXYrZGN2WVlXY3M3OEhZd2tjdFdydEgrdm5HVVg3NW1uQmhHNnpnMzlWMG9x?=
 =?utf-8?B?d245cTVCaU4vQWw4a1NteGM5akJzNHZ0QnpxS3Evc1lxVEoxaEFOc3Rpc1FR?=
 =?utf-8?B?eHJHUGRSWUtZemJyNGRKb3J4Tlg0MmVnRC90dUg2azJwM1Q2YTdFSHAyR1hR?=
 =?utf-8?B?NG5IdklVTDBwNlpiaWFsSkZyOENMQk91ZWZ2bzZmWFRoVzFmWGltTGRmYi9y?=
 =?utf-8?B?eFM4OExieldHQkZjTEMzTEh6YnZMMkgxZ2NSTFpBVkNaaDRPQ0VyU0Y5VzNY?=
 =?utf-8?B?SVIwLzlwNk5Way9zbk9jZGZhVHpMNEd6SUZiZDlZM21WMVBYeVFTSEJNLzZH?=
 =?utf-8?B?b0tJRXMreThuZXA0M2JvaWJ4WVlYQkVjQ1lvRFlKejhEZHkvVnhxS3AzaHZH?=
 =?utf-8?B?L3h2cnMydE5EVk01dTFibEZLdi8ybFRzMHlKRVJ0eFB2Ni9xSDl5TFNkVTl6?=
 =?utf-8?B?dG9rRStIV0V3bW83RGtjODhsZkR3bnNEUmlIRldjbXNDME5XZFRXQkQvaTV2?=
 =?utf-8?B?bFFBd2Z4ZElwRGVFTWpxS3ZXcDZqV1R5RzdoMm55VlFoc3ptcmxWQVMxTTBW?=
 =?utf-8?B?OU9NUUg4aE5FeDJVSVRMSTZUWWJ4OVlWQnQ0ZlM4dGYyZlZKZ3djdElsemc1?=
 =?utf-8?B?d2xEZzUzMUh4Q2NRb2UxU3VMcU5LdEF1Rm05VElZRDFWT1l5WDRDVHZRNFZP?=
 =?utf-8?B?M3dGN3FvMVJ4aUVsTnJEN0lDR0E0T2lzSkwzMEdWY1dKMkFzRndVTjYyRTY2?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <649B7F35F455D74799CA1A5E6F42CAB9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b7fa19-8938-42be-a36b-08db05d913bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 11:23:29.9956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hv+O5wTYPzzh3JfZIo0B3rFLZSnnzXtl6/0igq77+Vttm+pYH5rbPNzBO1kY6aV5rQUb8cgnschVO+yNA73599zi9N5h8Ms30n9wf9Z5/g4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4868
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIuMDIuMjAyMyAxNDoyNiwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBJbiB6eW5xbXAgcGxhdGZvcm1zIHdo
ZXJlIGZpcm13YXJlIHN1cHBvcnRzIGR5bmFtaWMgU0dNSUkgY29uZmlndXJhdGlvbg0KPiBidXQg
aGFzIG90aGVyIG5vbi1TR01JSSBldGhlcm5ldCBkZXZpY2VzLCBpdCBmYWlscyB0aGVtIHdpdGgg
bm8gcGFja2V0cw0KPiByZWNlaXZlZCBhdCB0aGUgUlggaW50ZXJmYWNlLg0KPiANCj4gVG8gZml4
IHRoaXMgYmVoYXZpb3VyIHBlcmZvcm0gU0dNSUkgZHluYW1pYyBjb25maWd1cmF0aW9uIG9ubHkN
Cj4gZm9yIHRoZSBTR01JSSBwaHkgaW50ZXJmYWNlLg0KPiANCj4gRml4ZXM6IDMyY2VlNzgxODEx
MSAoIm5ldDogbWFjYjogQWRkIHp5bnFtcCBTR01JSSBkeW5hbWljIGNvbmZpZ3VyYXRpb24gc3Vw
cG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlh
bS5wYW5kZXlAYW1kLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1
LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMzEgKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggNzJlNDI4MjA3
MTNkLi42Y2RhMzE1MjBjNDIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYw0KPiBAQCAtNDYyNywyNSArNDYyNywyNiBAQCBzdGF0aWMgaW50IGluaXRfcmVz
ZXRfb3B0aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgICAgICAgICAg
ICAgIGlmIChyZXQpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBkZXZfZXJyX3By
b2JlKCZwZGV2LT5kZXYsIHJldCwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgImZhaWxlZCB0byBpbml0IFNHTUlJIFBIWVxuIik7DQo+IC0gICAgICAgfQ0K
PiANCj4gLSAgICAgICByZXQgPSB6eW5xbXBfcG1faXNfZnVuY3Rpb25fc3VwcG9ydGVkKFBNX0lP
Q1RMLCBJT0NUTF9TRVRfR0VNX0NPTkZJRyk7DQo+IC0gICAgICAgaWYgKCFyZXQpIHsNCj4gLSAg
ICAgICAgICAgICAgIHUzMiBwbV9pbmZvWzJdOw0KPiArICAgICAgICAgICAgICAgcmV0ID0genlu
cW1wX3BtX2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChQTV9JT0NUTCwgSU9DVExfU0VUX0dFTV9DT05G
SUcpOw0KPiArICAgICAgICAgICAgICAgaWYgKCFyZXQpIHsNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgdTMyIHBtX2luZm9bMl07DQo+ICsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0
ID0gb2ZfcHJvcGVydHlfcmVhZF91MzJfYXJyYXkocGRldi0+ZGV2Lm9mX25vZGUsICJwb3dlci1k
b21haW5zIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcG1faW5mbywgQVJSQVlfU0laRShwbV9pbmZvKSk7DQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBkZXZfZXJyKCZwZGV2LT5kZXYsICJGYWlsZWQgdG8gcmVhZCBwb3dlciBtYW5hZ2VtZW50IGlu
Zm9ybWF0aW9uXG4iKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVy
cl9vdXRfcGh5X2V4aXQ7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmV0ID0genlucW1wX3BtX3NldF9nZW1fY29uZmlnKHBtX2luZm9bMV0s
IEdFTV9DT05GSUdfRklYRUQsIDApOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAocmV0
KQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyX291dF9waHlfZXhp
dDsNCj4gDQo+IC0gICAgICAgICAgICAgICByZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMl9hcnJh
eShwZGV2LT5kZXYub2Zfbm9kZSwgInBvd2VyLWRvbWFpbnMiLA0KPiAtICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcG1faW5mbywgQVJSQVlfU0laRShwbV9p
bmZvKSk7DQo+IC0gICAgICAgICAgICAgICBpZiAocmV0KSB7DQo+IC0gICAgICAgICAgICAgICAg
ICAgICAgIGRldl9lcnIoJnBkZXYtPmRldiwgIkZhaWxlZCB0byByZWFkIHBvd2VyIG1hbmFnZW1l
bnQgaW5mb3JtYXRpb25cbiIpOw0KPiAtICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVycl9v
dXRfcGh5X2V4aXQ7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IHp5bnFtcF9wbV9z
ZXRfZ2VtX2NvbmZpZyhwbV9pbmZvWzFdLCBHRU1fQ09ORklHX1NHTUlJX01PREUsIDEpOw0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGdvdG8gZXJyX291dF9waHlfZXhpdDsNCj4gICAgICAgICAgICAgICAgIH0NCj4g
LSAgICAgICAgICAgICAgIHJldCA9IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyhwbV9pbmZvWzFd
LCBHRU1fQ09ORklHX0ZJWEVELCAwKTsNCj4gLSAgICAgICAgICAgICAgIGlmIChyZXQpDQo+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyX291dF9waHlfZXhpdDsNCj4gDQo+IC0gICAg
ICAgICAgICAgICByZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcocG1faW5mb1sxXSwgR0VN
X0NPTkZJR19TR01JSV9NT0RFLCAxKTsNCj4gLSAgICAgICAgICAgICAgIGlmIChyZXQpDQo+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyX291dF9waHlfZXhpdDsNCj4gICAgICAgICB9
DQo+IA0KPiAgICAgICAgIC8qIEZ1bGx5IHJlc2V0IGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2
ZWwgaWYgbWFwcGVkIGluIGRldmljZSB0cmVlICovDQo+IC0tDQo+IDIuMjUuMQ0KPiANCg0K
