Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2806460596F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiJTIOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiJTIOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:14:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9463A1EAEF;
        Thu, 20 Oct 2022 01:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666253684; x=1697789684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9SqgOFVqGYnPjx+1SRfwl1+9B7qQoFpwBuHTWEICvLc=;
  b=ES3OafiN0Ka1iIUT9tTI9SvCE8Kh+kDMYF04LghHI2b38KF6waArku83
   wQuocH3TQlqZ4VzkhZBRDq6hnYNNLEhmNIQ5fXb2uzGWDuA9YQEaknEk7
   NYiSDu3q68FCozJOxh3YJc4fe//EwKOV0cn8ZzphZFqk3DzoZxn3OUFFF
   FmBPTgMIAAMNSy8PolxaFhLorSA+jQiAWiD1qGqbw4vtw1ZIg0A10FNQu
   xxGQ8XhWi6VgfG6IdDrknEvcyRXbQkwoYOML3f7Jh9JQddPIOiJulfe/s
   tIsScM0o53gH++21L9yh5EDs5a6oe+2x38s4N6YjGm0jzEsspp7hLxs+m
   g==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="185536761"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 01:14:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 01:14:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 01:14:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arkZCxZjSxEcElH9fJe/oBF96gkmD6XDWj4/dYaKotwSxogqbJ5QikhBV29HG1KPeI6Cv7Q8Sq5nPd7u7h80N5mCf8k8bfyqeDNAyMJPzlSeg3vPvhfF6MA+Mt2u4kEDmLq63ZFhPVcGtw77BCwQe2Prq8GhGWs7fm7Fb9zY3FYQ3Z9baQhnF8QFjMuJmN1MBlwv29Feb4TGMJzLcEHBJT1hH2IMJQ8nuiA22m5eyO2i8SvYT30fmisFaAHi3/voJISEVLNgsjs34bxU51JZUKYMNxAiujKdOZFlKcFZyuVrunIaI+A/pnGD2bMsf+ZDHkFsWCON02ZmhcyyPeQmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SqgOFVqGYnPjx+1SRfwl1+9B7qQoFpwBuHTWEICvLc=;
 b=CmhATkgS4uq78dK43BkwU9DJ2aA6g9LCfG9+0QSn8pQctG3paW1mWvz3wJxD3ML2FBtZMwX1+HjIvvTmkOsb7Da6xqsc2ibovzZG4OsLimBzIg/FQiFvYEvdP9Z3kUObu8eaRePeUubE062+isqz3U0o4XV0WBHX23Ha9jfpuReJhaT6A/xaMV8u1B2MBq1qz7HD/m6gZxUmtbCX3Mo2fInauxo8VQC5y9QrCza4j5UOSuZ260yDnQFj2p1XprIjZUtfRoxydSa8V1V2rlVyOkN7+U88h9URuP3MO3ege03e1CKqZoI8iNs0DMIQQm/b6H3xBQ2zvEfSzyYAv0OumA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SqgOFVqGYnPjx+1SRfwl1+9B7qQoFpwBuHTWEICvLc=;
 b=fMF2Nuvj2TLCzIOqLH+ySs8JEVilwcaP2w6Cl1QVeQgne67qf1LEVT5AGYceuRNZOEVHETWMIKJM/WSe2sNq+ByRl1XsGgv7RkqlUulDejA89ExNXKnjO7ZY6oKLA3g9jD+ouOVExT9L5LgIKIZblRSGrpFacyB2SlBvlfgsSMI=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 08:14:35 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::51f:528c:5fde:40a2]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::51f:528c:5fde:40a2%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 08:14:29 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Sergiu.Moga@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <Tudor.Ambarus@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: macb: Specify PHY PM management done by MAC
Thread-Topic: [PATCH v2] net: macb: Specify PHY PM management done by MAC
Thread-Index: AQHY5Fv5YDOe1UcH6UKN1CYZKHTQVQ==
Date:   Thu, 20 Oct 2022 08:14:29 +0000
Message-ID: <3078193e-2df2-bfcf-f1e9-302ec7841eb7@microchip.com>
References: <20221019120929.63098-1-sergiu.moga@microchip.com>
In-Reply-To: <20221019120929.63098-1-sergiu.moga@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|SJ0PR11MB4814:EE_
x-ms-office365-filtering-correlation-id: 381b8b26-8d72-47a5-7f95-08dab2731c84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhZ7/e9iRW85ZTT8/NnT4wt3umRfWRgcCdrteLTXvGow3tnFDao2mWpjGLxcQvXtDKSH0olM854TrRlhYlrksRkLmgjWgAxrRKY2fKQnkU5p458s44VgMa3arCvFGxh/WR7CPrJDkCWrmitPB9szV7S3UgeeU3G/6HFQAcjhptQb6nEHkjgJlUjx8iesIK6m34wmDWoWmuw400TIqEzaAtQeKRXf3F4On8byi6/T6TtvfV9xX7nmZVnkGl9lUcepTE+v6uPOnR9+qAdpSc2B1bhtlxdGcTjWfTj4sDxMBOtVb/4jxbMRch0kTCScqnGOTuAfiopvopiTNm/C46F9vMyG/hup6vpZn8fVfh07+PE7Byxi8ObB8dFrL5tfsi1ZetXpRPdU60/oxZv3jjYClE9KGMSYiIfhK0h6NYD3jmaAN1tPgrpiOGJpz1yCKgB0bUA4SWX52xOyVFib7ZOKx287AAFIYjYW0tfa7G0+Y3OHaL61VKW+2wkKLwuPtY6B1gHCeJmvJKSNdFE2csUpIziVp21Ko7w6dcw958uNxmK+EqBYegV5vjVaMITkhBGpmoWis9Jjwp+TSxig8tyx7LWjtNm1aGGI3q10pqohKncT2sBnu+L512map9Zu4PK1fCzc4s+G6uKGiqQH5MRZKdNOujTi5pGvKOpQShYZxMs4P0qkauD8cszA9NHJy5UsWvBh8KJOyuuPiyAwUIKhmu+3bELPTCZCCO+NM+L91ZbViI9z3IWA5WjktlM3Esx7UAqjpI+v3W6AjANFuDCKnGwYjX1FyO4+6+R7+3uCFY+UgSg2H+5ibz+tIXWIl9FltjJoETm6UwDjXwguY9xqlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199015)(31686004)(36756003)(86362001)(31696002)(38070700005)(122000001)(38100700002)(91956017)(83380400001)(316002)(2906002)(6636002)(54906003)(110136005)(186003)(6506007)(76116006)(26005)(53546011)(6512007)(478600001)(71200400001)(2616005)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(41300700001)(5660300002)(8676002)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVdmYjlpeGw5RlpQcUNLWUg3RE5RS3hJN3ZXUDhBMCtPNnIyODJaZnB2TXB6?=
 =?utf-8?B?eWkzWUtabXgrK1R1Q0ptVGNwWVNPUlJjK21KK3hEbjIzVnV2R2hnZlBrS3Z0?=
 =?utf-8?B?OEpSME55UHdCdFd3MjZuRHBoUnhlZ1F5cjQ1ZGpqTzRCVDBURlBuVnRWUWk4?=
 =?utf-8?B?NTcrMm9YbU9XZnhVZFJmUnljQ0x1U2hKS3F3MnN2MTMvUU4yaFhDOTZVNXpk?=
 =?utf-8?B?andBbGdOdzcvNEIzTGYzcDl2eEdVV0RaOC9pcEczcDVmQnhsS1NPODE0VnBi?=
 =?utf-8?B?RUdySitMazBLd05oandIbXNsV2U1VU85ZmtIQzhqL3lpRDhaTGNsTG1vRU9Z?=
 =?utf-8?B?dkcrd3RJNE1iaTVjQjlYSlJWNEpjSG9nWlE3UUcya1ZQRzFHZGlwb3UrMlBH?=
 =?utf-8?B?WlJYSno0V3FacUQ1VjR3aUlCN3ZwSm5hRi9RYzJ3WWV5Wi9EaEdRM3R1czJJ?=
 =?utf-8?B?R3RlTEs4RHVleHoyL2xVMlZyeEkxT2NCNU5wYm9WWXRWMTNQdmhGMGl1c1Vt?=
 =?utf-8?B?bjhWbWllME1jbk0xbWpGeDJFT2JVeFdEUWZQWTk5aGlEMW9BNnkwa05SM2Rm?=
 =?utf-8?B?Z2xUYkZXQ0NZTzEyd2lNOGNwWFRoUXBJa3NDS2hVSHdRSkh3cFF3NUFZOXE5?=
 =?utf-8?B?Wk5GUFJXTFErOEdZZDJsd3RjWm5vMWdHS0hUUFhSc2twRUNJY0g0SlBEN1Q0?=
 =?utf-8?B?bE9iYmwzUFBDdk1CTTNDWGM5OXQyV1Y5aUdEN0gzN2xPZTRKNERMYTdtK2JT?=
 =?utf-8?B?QmQ3TE5qejRiZW9Sbkc2SkU3VTlkMkw1OW5sbVpSUnllZzUzWjdQWkpxbmFj?=
 =?utf-8?B?UWlQRXNYbUNqMHN4Q2hWSWZVNkVmOURqbHIxYkkrSk9zRlhiUURkT3U4Tzlr?=
 =?utf-8?B?aS9FWXhLY0Q2eXEvMGt4N3pOL2FadGxWK1lLbS8xT1M0LzRUMzBnU1F5aVRM?=
 =?utf-8?B?cC8xdVprVmFMZVdMUkdiYy81c3R5ZzQ0UytEdzdteEd4UzNpdmhTMW5wN2Q4?=
 =?utf-8?B?eGJGbktKYTQ3Q2xFTCtmL0Y4ZHp2NTNsYk1jZWQ3eWExaDVlTmVGa2RZRWhC?=
 =?utf-8?B?bm1CcGR4OFFZWWxDU3VLY0NMRFVrVGt6N053WUJyczlPOGRMVHlyVmc5dXlk?=
 =?utf-8?B?TFFzMWdKNDFPK2xHWEMvVEdNL2M5SHE4TzhUb0RqOHlFOUZ1enhqd1cvRnVY?=
 =?utf-8?B?L2pNdGdBVGhzaHNyUFdSTUlIbnBHSjVidjMzWjFjd2FrRE92UTdVa0c4MjNh?=
 =?utf-8?B?NmtZdGd5bzZCT2ppaGhPdVc5TVZHbmtGSVdFL2NnYlNzaUpEc2JPQ1E3ZU1h?=
 =?utf-8?B?OTIzZ1NZVm92QUpkT2lRbmY5MkEyeDBIbElxM3NENDRUYVNSMXBwamg2UW5n?=
 =?utf-8?B?RUEvd2lhL0ZPeEhHaEc1OGRqbmg5eWs0WmRtdm53WDV6UnIzcWFESktQSjFn?=
 =?utf-8?B?emN6Q1ZDa1hTYzhXb25ReXFMNmVxcmd0WmE0dVpMZ0NLdUQ3Sk9mSFcrcGdh?=
 =?utf-8?B?b1cybWRaUnBjbUhGQWtJa1ZqMXFyOE40d1c0MUphKzlYam5ORlE1Y0NPRDg5?=
 =?utf-8?B?Zy9uaGROSXNrTVBJamx5TUVQUW5ieGdVRW5HOGZvTXlYWVRJcVpHMXdiOTUr?=
 =?utf-8?B?bm9vbE1NaUNCSGsxRmIwTi9EVUJJbzIwQmdid3lTMjhQei8vSVEzY1p5b2dV?=
 =?utf-8?B?VUt5VzJrVEhaVDc2NEQ1bFp1bWpTZjZrUnZVR0Q1dEdhanFSZFppSzh4U3Zl?=
 =?utf-8?B?TWFLY2cwNTgxaCthTE1mSkJPT2VMUnhzQ25Nc2l4NGg2Z21ocWx6MnJObnlV?=
 =?utf-8?B?bURwUytxSHBuYjFodlMvQUREeXpOVVZkMEk0T3VhUWRHemwrOTBtRjJTSWZJ?=
 =?utf-8?B?eUhGUmJhcWgva3FjVzdrMlpTSmVIYitvc21CLzlGTW5xZHdSYVZTT1ZHcXRF?=
 =?utf-8?B?ZXg0YUx6YWlpeTIzV2FzZHRvbDAzNFRHbWhmU1QrNkM1TFk2NHdDbGtqRlFQ?=
 =?utf-8?B?QTFsREVHMzJ0amxDbC9reUFNUlZpK0R6MmhHVjl2aFExb0gzSWtkZlpHa284?=
 =?utf-8?B?RjhmUGtSczNCOWhXaDNWYTZCbnBpdmtYMUwwZUJHYUl6cHJiMTV4Z1JaV0Nu?=
 =?utf-8?Q?C+lk5Es9IebhXRgPMnvWKSUmG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0476BC0C8170064E960E007EEB4E6BBB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381b8b26-8d72-47a5-7f95-08dab2731c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 08:14:29.5462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +3gX0QldvJ1JZAiHtxBzvxAQm/ICbsRNzUiK+nJZrS18PQX3giOUCUcWVgibp7y7asnJ+3BL4uFzHZRzIkwJKvQKTHOwL48KsrkxyfoUZQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4814
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkuMTAuMjAyMiAxNTowOSwgU2VyZ2l1IE1vZ2Egd3JvdGU6DQo+IFRoZSBgbWFjYl9yZXN1
bWVgL2BtYWNiX3N1c3BlbmRgIG1ldGhvZHMgYWxyZWFkeSBjYWxsIHRoZQ0KPiBgcGh5bGlua19z
dGFydGAvYHBoeWxpbmtfc3RvcGAgbWV0aG9kcyBkdXJpbmcgdGhlaXIgZXhlY3V0aW9uIHNvDQo+
IGV4cGxpY2l0bHkgc2F5IHRoYXQgdGhlIFBNIG9mIHRoZSBQSFkgaXMgZG9uZSBieSBNQUMgYnkg
dXNpbmcgdGhlDQo+IGBtYWNfbWFuYWdlZF9wbWAgZmxhZyBvZiB0aGUgYHN0cnVjdCBwaHlsaW5r
X2NvbmZpZ2AuDQo+IA0KPiBUaGlzIGFsc28gZml4ZXMgdGhlIHdhcm5pbmcgbWVzc2FnZSBpc3N1
ZWQgZHVyaW5nIHJlc3VtZToNCj4gV0FSTklORzogQ1BVOiAwIFBJRDogMjM3IGF0IGRyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmM6MzIzIG1kaW9fYnVzX3BoeV9yZXN1bWUrMHgxNDQvMHgxNDgN
Cj4gDQo+IERlcGVuZHMtb246IDk2ZGU5MDBhZTc4ZSAoIm5ldDogcGh5bGluazogYWRkIG1hY19t
YW5hZ2VkX3BtIGluIHBoeWxpbmtfY29uZmlnIHN0cnVjdHVyZSIpDQo+IEZpeGVzOiA3NDRkMjNj
NzFhZjMgKCJuZXQ6IHBoeTogV2FybiBhYm91dCBpbmNvcnJlY3QgbWRpb19idXNfcGh5X3Jlc3Vt
ZSgpIHN0YXRlIikNCj4gU2lnbmVkLW9mZi1ieTogU2VyZ2l1IE1vZ2EgPHNlcmdpdS5tb2dhQG1p
Y3JvY2hpcC5jb20+DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpu
ZWFAbWljcm9jaGlwLmNvbT4NCg0KDQo+IC0tLQ0KPiANCj4gDQo+IHYxIC0+IHYyOg0KPiAtIEFk
ZCBEZXBlbmRzLW9uOiB0YWcNCj4gDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX21haW4uYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggNTFj
OWZkNmY2OGE0Li40ZjYzZjFiYTMxNjEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtODA2LDYgKzgwNiw3IEBAIHN0YXRpYyBpbnQgbWFjYl9t
aWlfcHJvYmUoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIA0KPiAgCWJwLT5waHlsaW5rX2Nv
bmZpZy5kZXYgPSAmZGV2LT5kZXY7DQo+ICAJYnAtPnBoeWxpbmtfY29uZmlnLnR5cGUgPSBQSFlM
SU5LX05FVERFVjsNCj4gKwlicC0+cGh5bGlua19jb25maWcubWFjX21hbmFnZWRfcG0gPSB0cnVl
Ow0KPiAgDQo+ICAJaWYgKGJwLT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9T
R01JSSkgew0KPiAgCQlicC0+cGh5bGlua19jb25maWcucG9sbF9maXhlZF9zdGF0ZSA9IHRydWU7
DQoNCg==
