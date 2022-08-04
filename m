Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114D1589BDA
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiHDMnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiHDMnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:43:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE70D2BB01;
        Thu,  4 Aug 2022 05:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659616996; x=1691152996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=l3QgpPxw939Iw1KyWMsJqkKs5LDaUWQK06wfpUfO/Mg=;
  b=LgLYXogultWxeH7VoqYfxPPEYBoqLr9LgseU+XOCt0wB/WRlGorBklrG
   1Xzz9NIMDJYbcJBKFyhozdk1+dmUCs5slsMDVh7ZpFJDXc6L7hitLeRpv
   ATdMCuwsPGZxA3KVsbNf/AHRg8Q5PTjMypP7XkahhJrlpKdqL/ZkyPn6P
   YWgLcKxLliFx3OoM7h0+aasYmfHJooX4MGDvfPLYaLeemzKkjVPu29d6U
   MaO4RIkN3Vyp3QJ31ytw6BBEC8RbUeN3z0AL5tyjF+WTZ3lTp+VjpjDir
   NqWhszwZHDclUSraDslqDsLtlSWFf6JxJjzYSdxc79lZ5OAMmbdY1OITI
   g==;
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="175063832"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2022 05:43:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 4 Aug 2022 05:43:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 05:43:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ff9GRMlksKklZq0iM61j05BqW+ID0DEN3wEclUGxP1+lfr4Wk8hxr7zK+aczz4bvAG+eTSKVhWeaN5PCgk+/XjFd++scCtz8yL0oba/9nJUwle+Sfl6is7LwXxijNhVCKTp1fvngxxHqDG68NrQ5MYxFhR0bE3T57WlZ0X5qg3L5ppgYnY0YS7xRdPQYhILHBFLHw6x5fXw2/lteu8VXYYfciCj8gAj+26IIerdiz3VSqqqL5eBPIzxQ5sFlMA4OFVj2N7d42VwS+JOZZhrm8OtcdzoGCZTeFVT9t1dHorAGzXyDxI3ZeNpx+tYEOhH7M6aFdPBsom5h0QzKkgB4eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3QgpPxw939Iw1KyWMsJqkKs5LDaUWQK06wfpUfO/Mg=;
 b=VRU0CaCW2YMEAanG0TEzTuRS/KGw4eHhI6AJocNBCwdsrYuSqgNWb0aCkJchwlg6UWhE7Ijpre18fjlds6p6LCwyZiYHzDqQPltnhEaY7GP9yXYuSL9IggEoW/OH0WFZxbwpoV++SdrJiWTDh1HHR9LMieKpxyZ9s/4gsE+Aa6gA5/wAaKej+4S+Ad4EtmyZSon5PoVHByxPnIOeBpbCJ9LpSPKWA5vKR0YO5BhTFCo1uts3nHXnu3qSJpSvsHjwP993oq9Z02ola+w3D81tXjTUHXZugK4C0sH4LiULTS6JZ8+v9KsNEiFvvYpgPX5YGC7vUNA19M4zLrJ0tcIkZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3QgpPxw939Iw1KyWMsJqkKs5LDaUWQK06wfpUfO/Mg=;
 b=VqPbooyr245Dme2edP7WHTMZjgcCX8/HbPATSHhp7uHwBSM0BQEK6mGq6l+e5uNzmdGDU3CgaxPBVvJfXjMXX2sHFlrPlwssjDCihBm8URy3YsiWSVTe7MSfceXeYQn/WIuA4Jv/7tL6jmSIIn2axLZBxFbyJenQsK/Q4X9w6jE=
Received: from PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5)
 by BL3PR11MB5681.namprd11.prod.outlook.com (2603:10b6:208:33c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 12:43:05 +0000
Received: from PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8d74:5951:571e:531e]) by PH0PR11MB5176.namprd11.prod.outlook.com
 ([fe80::8d74:5951:571e:531e%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 12:43:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <michael@walle.cc>
CC:     <David.Laight@aculab.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mwalle@kernel.org>
Subject: Re: [PATCH] wilc1000: fix DMA on stack objects
Thread-Topic: [PATCH] wilc1000: fix DMA on stack objects
Thread-Index: AQHYopXBsLYisv99UkizyRPRMtdn/a2VHE0AgABV2QCAAAuOgIAI4yOAgABZeYA=
Date:   Thu, 4 Aug 2022 12:43:05 +0000
Message-ID: <6ccf4fd8-f456-8757-288d-e8bd057eaae8@microchip.com>
References: <20220728152037.386543-1-michael@walle.cc>
 <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
 <612ECEE6-1C05-4325-92A3-21E17EC177A9@walle.cc>
 <a7bcf24b-1343-b437-4e2e-1e707b5e3bd5@microchip.com>
 <b40636e354df866d044c07241483ff81@walle.cc>
In-Reply-To: <b40636e354df866d044c07241483ff81@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb2570c3-ce76-4abb-9d73-08da7616e07f
x-ms-traffictypediagnostic: BL3PR11MB5681:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uLAOtVnrCUcuQIWmcXHca6Z70JlZUcMvCE/bSpK/YOj0bwEQ352XOzl/n8rRvCrFbbRqf7EnFek6Klwud6rHAFiQ+RdHAlPxl8ukgX+Y6o80XOh+9dCBGDPfpqBMcvksuc1hA9IwyiT0m33VnIkILaa3SEZsm1F+rl1Q8nxyffCqmUPUIHI6AVPudZYpqUmgiLU/iwZHhcoIlugmFXB9a9O+yNbqlwKTY3KnNyXSZYWw6vok5DLGpW4HGVoFyetkhc/KmtwR8vHshWYJuP3M25/EsyHcAlHFRqYgZeirEqjoTY72CNRUMhvlUaZmSKkoPH5NWrKqwlp1KvS9Bm/fztd5bKQR9R+710OEEyPmE5BaR6COdYHTf88Vpwf425buBeQhueP7yNDVcxs8jewRpVoiixN50R/7xB9EZzm7FVLnkkByZvNGTGQotI/088c1h2lZpWUvz0L/n9foqO4H9xIUMg2bh/SX5mBQG2TV9TMWucAkcIHQsf/uYBwJgp5o1zH7Q48zI+3c2cxTIs2TO0uwQtXx5WWnLhQrHLZF5SfcrR6XleDOkCxgkla7RpqQCheu4VIzeRq7AcvFJVleGu+uGJhJBZqvIG54etgoR1EM6GZrMnHUduju7PmovSMhIAqi8OOM2F0g769MIUpTODfmLN4DoXidpxO3MtL+/uBcQbYUdQerCyYI2cPD/esfm5Bk4SBkBrcstUJgIf+L2coXXRUljpmUgrYt7GOuKvOFJHfkJNVxHApup5/MuNqXzHjkG5b9aOPDe4rG7rDu6qUH8Yw1QzEDC8KVJ0UJ+E4NKJlC9xfJCUW+abFHLCmS83qtjcbhWMahzkxP5LCt6tyCSGTgefhq5MmJqh6Gk9LGp7Jrrf7PyMj1VicnsfIW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5176.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(346002)(136003)(376002)(26005)(55236004)(53546011)(7416002)(186003)(54906003)(8936002)(5660300002)(2616005)(6512007)(6486002)(36756003)(31686004)(6506007)(478600001)(71200400001)(41300700001)(122000001)(86362001)(91956017)(31696002)(83380400001)(38070700005)(76116006)(6916009)(316002)(2906002)(8676002)(66446008)(38100700002)(4326008)(66946007)(64756008)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGtNbzVZQ1JhNFFSblhhQnhuQmNJdTFMd1k1dFZ0bUI3RmZiaW9RYmhIK25R?=
 =?utf-8?B?a29oc3UyTXlQNW9TbGo4R01rcmZQUnYyUVJ0c2V2NTJCRC9ndHptY1N3WUZK?=
 =?utf-8?B?WkVEcW5tdEU5VGtxYlY5NWJzVThDMmJxcm9pc2MzMVlWZmc4Z0tFUnhpMUVp?=
 =?utf-8?B?NjU1Ly84TVl3WkpINVdCbS9UOEF1dnVPYkxDbTJqQ01meDhIWHc1QTduaEtP?=
 =?utf-8?B?eWdGSUhNT3B5RWNUVGhDWlI0bCtUVk9hQWc2SHhTK0IzdE5ZU1YyNzVTSEZU?=
 =?utf-8?B?TzFYNGpoN3BMM3ptZWtObkJ4MHJoNmVPb0ROS3RSQ3pTcXJqMFpxWDZzeHJE?=
 =?utf-8?B?dStNaUJLUW51MjZFTTJJM21pcFVXRkFxRGpQb0N3Q1RZdUhMWkN3b0xxZ1U0?=
 =?utf-8?B?b2prVENONGcvcE5US0wvZDRuYjVJWGhZdHV0bE4xSmJEYVdkSnRtQTZ3UElE?=
 =?utf-8?B?WW9odm9SL3NnT21YQkZwQm1RYVRGNXdTbGtLbUZiNW9CcmI3bFBlUXRFNWFE?=
 =?utf-8?B?d3RTQkFRTStidEVmdThnRGtCbEZrbSthN3JTVnY4REV6RjQ2ZlErMm53d1VW?=
 =?utf-8?B?NUdvb1ZvNmlQbmNxK3pzMURjWSs4MzlVZUk2OFJXM0QwS2ttU2V2RFpkeFd0?=
 =?utf-8?B?cEFWbEFWaXFLdm9sZTQrTlJsTDU0ck0wNC9rQnd6Y0FjM0JrZG1IL3piUXRL?=
 =?utf-8?B?UEZxOEtZWCswakI5VFYxL1JYN0twRVVvZzJCSWNVZzN3bElHdy9za1ZESU1q?=
 =?utf-8?B?ejVMVmFXNHo2MmxpVFJQeTBiOG5wRjBsdFVGYytQT1AzWG4ybnU1N0RoUmMr?=
 =?utf-8?B?MmFoTzBQdm5LQkVjdXEwQzRKa1ArTERrMTIrb1FTeHFyaEZSTG5TNzh5UWJL?=
 =?utf-8?B?ZUNaMitzODNZczhhRDVpNTZ4MHhDTE1ZcHk2ZUVZd1hYSmxhY1ptMWpJTVdB?=
 =?utf-8?B?R0FRNFVmZ1pRTk51QmlHREU3eEVreEJjMkp6b0l0bWdTNnZkaUZ3THA2SlF3?=
 =?utf-8?B?UmpKM2xoRkhSQS9mZXVSVTZTb2FENEJWQWRyK3Y3djllUWpFcTBLbzhGTDBq?=
 =?utf-8?B?SFBPRWpGY2tjaHVndjJFaGxzK2ptWXI4aWEvRkFOQjFFV3JKWnZIOWhFWFlm?=
 =?utf-8?B?SHlzUFduTks4aFhXdG9YNyttTTBZcU80azdCZjRPQkhGRFZTWm05UlA0Qk9Q?=
 =?utf-8?B?dXF3cnJzQkxEMmFBVjRkN3JXalhIcVFqOHA5TWxHMzg1WXN6Yy84SWt0K3Bo?=
 =?utf-8?B?dlU1OU9FWHhFV2tXeER4WTdRWXNBNmZUWlBkdEY4MTJjMDNWSW5xalBZd3BW?=
 =?utf-8?B?aFlUZVFzRUZJWWk1NEZSdVRyeEVMRzFzV1dwbDVvc0ZPZjhna3RXSVlHVFJr?=
 =?utf-8?B?UCt5Wk0ydGdWbEM5Y2UwWDAycXlCN3NwTjBsVE1Yd1YrWWpJOHc2QkUyaDJN?=
 =?utf-8?B?VTl2dEhrSVdWdFpRMmRTNVRweDlYN1RDUDFKZXlBL09SMWVWQmdRQVZSNnph?=
 =?utf-8?B?WjFrZFhJTHJUN1BMNFRUWlZBc0hSVTZMN0YzVjhJdHluNXJYTmFpd1RoMzNX?=
 =?utf-8?B?K01tdkhNbmI5ZWY2MVk3QXVtQkhlMGtXRElNMkxlamJJQjBwOEdoY0J1MVVK?=
 =?utf-8?B?K0p5T2p2QXpXdURRMlZvcHBxK0g4MlRNMFIvYUZ2YVUwZTFaSXpXd3dmWVJE?=
 =?utf-8?B?dHZySUtGbmpCOHNSU0ZNVDluNTFLZTBxaGtWQ3N3NFVxMmJ3WjZOeXg0SzRY?=
 =?utf-8?B?dkdEMXhzWWxlN0NIdFV2aUZ1MUw1TzZhd09QUVd4NUlSRkRZdm9MakJzVGZx?=
 =?utf-8?B?d1lTWUZEQ2g0Vms2UjFBQldjMzRCUWxsWGlqZlYzWUhKaWxKdVJQaWRRWndC?=
 =?utf-8?B?dFltRFR5U2p6S01LVEZkc2pVT1RNNFVNZEE0UTFUd2JaYUx3bnZLRVFtdzJQ?=
 =?utf-8?B?TnFEVndMYkhMV0g2RlZ5dTZ0dzdtc2haSUxsM05iZW5YUWlmdWtXZzJLWDZY?=
 =?utf-8?B?Yk4vTkRXbXVtNzUxQjlGaDVvRGQrOW1ucDF3YnRaWksweWtCNXpNK2NhdVVp?=
 =?utf-8?B?aGt4WU45bWg0eHFyT0FDQVBzVkdtczNzdzV6em1rRk1WZm5KTTh1MkZxeW1t?=
 =?utf-8?Q?nnMuXDE+WZnwvDzaVNxj0HlOt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E388E54EFF46BC48B469CEDA55243C97@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5176.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2570c3-ce76-4abb-9d73-08da7616e07f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 12:43:05.3695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MTXTfDCisnP6TS7DjD6C8QXxoqVG7EvOVZ+Ci+DwBy5MTEPnjVf//YTJHDgDSHAHqOSCYK/yPfWlKPP7r8xvRUy77SkIBePyCyzhD7Jjtss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5681
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDgvMjIgMTI6NTIsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
DQo+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gQW0gMjAyMi0wNy0yOSAxNzozOSwgc2Nocmll
YiBBamF5LkthdGhhdEBtaWNyb2NoaXAuY29tOg0KPj4gT24gMjkvMDcvMjIgMjA6MjgsIE1pY2hh
ZWwgV2FsbGUgd3JvdGU6DQo+Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdw0KPj4+IHRoZSBjb250ZW50IGlzIHNh
ZmUNCj4+Pg0KPj4+IEFtIDI5LiBKdWxpIDIwMjIgMTE6NTE6MTIgTUVTWiBzY2hyaWViIERhdmlk
IExhaWdodA0KPj4+IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT46DQo+Pj4+IEZyb206IE1pY2hh
ZWwgV2FsbGUNCj4+Pj4+IFNlbnQ6IDI4IEp1bHkgMjAyMiAxNjoyMQ0KPj4+Pj4NCj4+Pj4+IEZy
b206IE1pY2hhZWwgV2FsbGUgPG13YWxsZUBrZXJuZWwub3JnPg0KPj4+Pj4NCj4+Pj4+IFNvbWV0
aW1lcyB3aWxjX3NkaW9fY21kNTMoKSBpcyBjYWxsZWQgd2l0aCBhZGRyZXNzZXMgcG9pbnRpbmcg
dG8gYW4NCj4+Pj4+IG9iamVjdCBvbiB0aGUgc3RhY2suIEUuZy4gd2lsY19zZGlvX3dyaXRlX3Jl
ZygpIHdpbGwgY2FsbCBpdCB3aXRoIGFuDQo+Pj4+PiBhZGRyZXNzIHBvaW50aW5nIHRvIG9uZSBv
ZiBpdHMgYXJndW1lbnRzLiBEZXRlY3Qgd2hldGhlciB0aGUgYnVmZmVyDQo+Pj4+PiBhZGRyZXNz
IGlzIG5vdCBETUEtYWJsZSBpbiB3aGljaCBjYXNlIGEgYm91bmNlIGJ1ZmZlciBpcyB1c2VkLiBU
aGUNCj4+Pj4+IGJvdW5jZQ0KPj4+Pj4gYnVmZmVyIGl0c2VsZiBpcyBwcm90ZWN0ZWQgZnJvbSBw
YXJhbGxlbCBhY2Nlc3NlcyBieQ0KPj4+Pj4gc2Rpb19jbGFpbV9ob3N0KCkuDQo+Pj4+Pg0KPj4+
Pj4gRml4ZXM6IDU2MjVmOTY1ZDc2NCAoIndpbGMxMDAwOiBtb3ZlIHdpbGMgZHJpdmVyIG91dCBv
ZiBzdGFnaW5nIikNCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgV2FsbGUgPG13YWxsZUBr
ZXJuZWwub3JnPg0KPj4+Pj4gLS0tDQo+Pj4+PiBUaGUgYnVnIGl0c2VsZiBwcm9iYWJseSBnb2Vz
IGJhY2sgd2F5IG1vcmUsIGJ1dCBJIGRvbid0IGtub3cgaWYgaXQNCj4+Pj4+IG1ha2VzDQo+Pj4+
PiBhbnkgc2Vuc2UgdG8gdXNlIGFuIG9sZGVyIGNvbW1pdCBmb3IgdGhlIEZpeGVzIHRhZy4gSWYg
c28sIHBsZWFzZQ0KPj4+Pj4gc3VnZ2VzdA0KPj4+Pj4gb25lLg0KPj4+Pj4NCj4+Pj4+IFRoZSBi
dWcgbGVhZHMgdG8gYW4gYWN0dWFsIGVycm9yIG9uIGFuIGlteDhtbiBTb0Mgd2l0aCAxR2lCIG9m
IFJBTS4NCj4+Pj4+IEJ1dCB0aGUNCj4+Pj4+IGVycm9yIHdpbGwgYWxzbyBiZSBjYXRjaGVkIGJ5
IENPTkZJR19ERUJVR19WSVJUVUFMOg0KPj4+Pj4gW8KgwqDCoCA5LjgxNzUxMl0gdmlydF90b19w
aHlzIHVzZWQgZm9yIG5vbi1saW5lYXIgYWRkcmVzczoNCj4+Pj4+IChfX19fcHRydmFsX19fXykg
KDB4ZmZmZjgwMDAwYTk0YmM5YykNCj4+Pj4+DQo+Pj4+PiDCoCAuLi4vbmV0L3dpcmVsZXNzL21p
Y3JvY2hpcC93aWxjMTAwMC9zZGlvLmPCoMKgwqAgfCAyOA0KPj4+Pj4gKysrKysrKysrKysrKysr
Ky0tLQ0KPj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21p
Y3JvY2hpcC93aWxjMTAwMC9zZGlvLmMNCj4+Pj4+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWlj
cm9jaGlwL3dpbGMxMDAwL3NkaW8uYw0KPj4+Pj4gaW5kZXggNzk2MmMxMWNmZTg0Li5lOTg4YmVk
ZTg4MGMgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAv
d2lsYzEwMDAvc2Rpby5jDQo+Pj4+PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2No
aXAvd2lsYzEwMDAvc2Rpby5jDQo+Pj4+PiBAQCAtMjcsNiArMjcsNyBAQCBzdHJ1Y3Qgd2lsY19z
ZGlvIHsNCj4+Pj4+IMKgwqDCoMKgwqAgYm9vbCBpcnFfZ3BpbzsNCj4+Pj4+IMKgwqDCoMKgwqAg
dTMyIGJsb2NrX3NpemU7DQo+Pj4+PiDCoMKgwqDCoMKgIGludCBoYXNfdGhycHRfZW5oMzsNCj4+
Pj4+ICvCoMKgwqAgdTggKmRtYV9idWZmZXI7DQo+Pj4+PiDCoCB9Ow0KPj4+Pj4NCj4+Pj4+IMKg
IHN0cnVjdCBzZGlvX2NtZDUyIHsNCj4+Pj4+IEBAIC04OSw2ICs5MCw5IEBAIHN0YXRpYyBpbnQg
d2lsY19zZGlvX2NtZDUyKHN0cnVjdCB3aWxjICp3aWxjLA0KPj4+Pj4gc3RydWN0IHNkaW9fY21k
NTIgKmNtZCkNCj4+Pj4+IMKgIHN0YXRpYyBpbnQgd2lsY19zZGlvX2NtZDUzKHN0cnVjdCB3aWxj
ICp3aWxjLCBzdHJ1Y3Qgc2Rpb19jbWQ1Mw0KPj4+Pj4gKmNtZCkNCj4+Pj4+IMKgIHsNCj4+Pj4+
IMKgwqDCoMKgwqAgc3RydWN0IHNkaW9fZnVuYyAqZnVuYyA9IGNvbnRhaW5lcl9vZih3aWxjLT5k
ZXYsIHN0cnVjdA0KPj4+Pj4gc2Rpb19mdW5jLCBkZXYpOw0KPj4+Pj4gK8KgwqDCoCBzdHJ1Y3Qg
d2lsY19zZGlvICpzZGlvX3ByaXYgPSB3aWxjLT5idXNfZGF0YTsNCj4+Pj4+ICvCoMKgwqAgYm9v
bCBuZWVkX2JvdW5jZV9idWYgPSBmYWxzZTsNCj4+Pj4+ICvCoMKgwqAgdTggKmJ1ZiA9IGNtZC0+
YnVmZmVyOw0KPj4+Pj4gwqDCoMKgwqDCoCBpbnQgc2l6ZSwgcmV0Ow0KPj4+Pj4NCj4+Pj4+IMKg
wqDCoMKgwqAgc2Rpb19jbGFpbV9ob3N0KGZ1bmMpOw0KPj4+Pj4gQEAgLTEwMCwxMiArMTA0LDIw
IEBAIHN0YXRpYyBpbnQgd2lsY19zZGlvX2NtZDUzKHN0cnVjdCB3aWxjICp3aWxjLA0KPj4+Pj4g
c3RydWN0IHNkaW9fY21kNTMgKmNtZCkNCj4+Pj4+IMKgwqDCoMKgwqAgZWxzZQ0KPj4+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSA9IGNtZC0+Y291bnQ7DQo+Pj4+Pg0KPj4+Pj4g
K8KgwqDCoCBpZiAoKCF2aXJ0X2FkZHJfdmFsaWQoYnVmKSB8fCBvYmplY3RfaXNfb25fc3RhY2so
YnVmKSkgJiYNCj4+Pj4gSG93IGNoZWFwIGFyZSB0aGUgYWJvdmUgdGVzdHM/DQo+Pj4+IEl0IG1p
Z2h0IGp1c3QgYmUgd29ydGggYWx3YXlzIGRvaW5nIHRoZSAnYm91bmNlJz8NCj4+PiBJJ20gbm90
IHN1cmUgaG93IGNoZWFwIHRoZXkgYXJlLCBidXQgSSBkb24ndCB0aGluayBpdCBjb3N0cyBtb3Jl
IHRoYW4NCj4+PiBjb3B5aW5nIHRoZSBidWxrIGRhdGEgYXJvdW5kLiBUaGF0J3MgdXAgdG8gdGhl
IG1haW50YWluZXIgdG8gZGVjaWRlLg0KPj4NCj4+DQo+PiBJIHRoaW5rLCB0aGUgYWJvdmUgY2hl
Y2tzIGZvciBlYWNoIENNRDUzIG1pZ2h0IGFkZCB1cCB0byB0aGUgcHJvY2Vzc2luZw0KPj4gdGlt
ZSBvZiB0aGlzIGZ1bmN0aW9uLiBUaGVzZSBjaGVja3MgY2FuIGJlIGF2b2lkZWQsIGlmIHdlIGFk
ZCBuZXcNCj4+IGZ1bmN0aW9uIHNpbWlsYXIgdG8gJ3dpbGNfc2Rpb19jbWQ1Mycgd2hpY2ggY2Fu
IGJlIGNhbGxlZCB3aGVuIHRoZQ0KPj4gbG9jYWwNCj4+IHZhcmlhYmxlcyBhcmUgdXNlZC4gVGhv
dWdoIHdlIGhhdmUgdG8gcGVyZm9ybSB0aGUgbWVtY3B5IG9wZXJhdGlvbg0KPj4gd2hpY2gNCj4+
IGlzIGFueXdheSByZXF1aXJlZCB0byBoYW5kbGUgdGhpcyBzY2VuYXJpbyBmb3Igc21hbGwgc2l6
ZSBkYXRhLg0KPj4NCj4+IE1vc3RseSwgZWl0aGVyIHRoZSBzdGF0aWMgZ2xvYmFsIGRhdGEgb3Ig
ZHluYW1pY2FsbHkgYWxsb2NhdGVkIGJ1ZmZlcg0KPj4gaXMNCj4+IHVzZWQgd2l0aCBjbWQ1MyBl
eGNlcHQgd2lsY19zZGlvX3dyaXRlX3JlZywgd2lsY19zZGlvX3JlYWRfcmVnDQo+PiB3aWxjX3ds
YW5faGFuZGxlX3R4cSBmdW5jdGlvbnMuDQo+Pg0KPj4gSSBoYXZlIGNyZWF0ZWQgYSBwYXRjaCB1
c2luZyB0aGUgYWJvdmUgYXBwcm9hY2ggd2hpY2ggY2FuIGZpeCB0aGlzDQo+PiBpc3N1ZQ0KPj4g
YW5kIHdpbGwgaGF2ZSBubyBvciBtaW5pbWFsIGltcGFjdCBvbiBleGlzdGluZyBmdW5jdGlvbmFs
aXR5LiBUaGUgc2FtZQ0KPj4gaXMgY29waWVkIGJlbG93Og0KPj4NCj4+DQo+PiAtLS0NCj4+IMKg
IC4uLi9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL25ldGRldi5owqAgfMKgIDEgKw0K
Pj4gwqAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvc2Rpby5jwqDCoMKgIHwg
NDYNCj4+ICsrKysrKysrKysrKysrKysrLS0NCj4+IMKgIC4uLi9uZXQvd2lyZWxlc3MvbWljcm9j
aGlwL3dpbGMxMDAwL3dsYW4uY8KgwqDCoCB8wqAgMiArLQ0KPj4gwqAgMyBmaWxlcyBjaGFuZ2Vk
LCA0NSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvbmV0ZGV2LmgNCj4+IGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL25ldGRldi5oDQo+PiBpbmRleCA0
M2MwODVjNzRiN2EuLjIxMzdlZjI5NDk1MyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9uZXRkZXYuaA0KPj4gKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL25ldGRldi5oDQo+PiBAQCAtMjQ1LDYgKzI0NSw3
IEBAIHN0cnVjdCB3aWxjIHsNCj4+IMKgwqDCoMKgwqAgdTggKnJ4X2J1ZmZlcjsNCj4+IMKgwqDC
oMKgwqAgdTMyIHJ4X2J1ZmZlcl9vZmZzZXQ7DQo+PiDCoMKgwqDCoMKgIHU4ICp0eF9idWZmZXI7
DQo+PiArwqDCoMKgIHUzMiB2bW1fdGFibGVbV0lMQ19WTU1fVEJMX1NJWkVdOw0KPj4NCj4+IMKg
wqDCoMKgwqAgc3RydWN0IHR4cV9oYW5kbGUgdHhxW05RVUVVRVNdOw0KPj4gwqDCoMKgwqDCoCBp
bnQgdHhxX2VudHJpZXM7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWlj
cm9jaGlwL3dpbGMxMDAwL3NkaW8uYw0KPj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2No
aXAvd2lsYzEwMDAvc2Rpby5jDQo+PiBpbmRleCA2MDBjYzU3ZTlkYTIuLjE5ZDQzNTBlY2MyMiAx
MDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9z
ZGlvLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9z
ZGlvLmMNCj4+IEBAIC0yOCw2ICsyOCw3IEBAIHN0cnVjdCB3aWxjX3NkaW8gew0KPj4gwqDCoMKg
wqDCoCB1MzIgYmxvY2tfc2l6ZTsNCj4+IMKgwqDCoMKgwqAgYm9vbCBpc2luaXQ7DQo+PiDCoMKg
wqDCoMKgIGludCBoYXNfdGhycHRfZW5oMzsNCj4+ICvCoMKgwqAgdTggKmRtYV9idWZmZXI7DQo+
PiDCoCB9Ow0KPj4NCj4+IMKgIHN0cnVjdCBzZGlvX2NtZDUyIHsNCj4+IEBAIC0xMTcsNiArMTE4
LDM2IEBAIHN0YXRpYyBpbnQgd2lsY19zZGlvX2NtZDUzKHN0cnVjdCB3aWxjICp3aWxjLA0KPj4g
c3RydWN0IHNkaW9fY21kNTMgKmNtZCkNCj4+IMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+IMKg
IH0NCj4+DQo+PiArc3RhdGljIGludCB3aWxjX3NkaW9fY21kNTNfZXh0ZW5kKHN0cnVjdCB3aWxj
ICp3aWxjLCBzdHJ1Y3Qgc2Rpb19jbWQ1Mw0KPj4gKmNtZCkNCj4NCj4gSWYgeW91IGhhbmRsZSBh
bGwgdGhlIHN0YWNrIGNhc2VzIGFueXdheSwgdGhlIGNhbGxlciBjYW4ganVzdCB1c2UNCj4gYSBi
b3VuY2UgYnVmZmVyIGFuZCB5b3UgZG9uJ3QgbmVlZCB0byBkdXBsaWNhdGUgdGhlIGZ1bmN0aW9u
Lg0KDQoNClRoYW5rcy4gSW5kZWVkLCB0aGUgZHVwbGljYXRlIGZ1bmN0aW9uIGNhbiBiZSBhdm9p
ZGVkLiBJIHdpbGwgdXBkYXRlIHRoZSANCnBhdGNoIGFuZCBzZW5kIG1vZGlmaWVkIHBhdGNoIGZv
ciB0aGUgcmV2aWV3Lg0KQnR3LCBJIHdhcyB0cnlpbmcgdG8gcmVwcm9kdWNlIHRoZSB3YXJuaW5n
IG1lc3NhZ2UgYnkgZW5hYmxpbmcgDQpDT05GSUdfREVCVUdfVklSVFVBTCBjb25maWcgYnV0IG5v
IGx1Y2suIEl0IHNlZW1zIGVuYWJsaW5nIHRoZSBjb25maWcgaXMgDQpub3QgZW5vdWdoIHRvIHRl
c3Qgb24gbXkgaG9zdCBvciBtYXkgYmUgSSBhbSBtaXNzaW5nIHNvbWV0aGluZy4gSSB3b3VsZCAN
Cm5lZWQgdGhlIGhlbHAgdG8gdGVzdCBhbmQgY29uZmlybSBpZiB0aGUgbW9kaWZpZWQgcGF0Y2gg
ZG8gc29sdmUgdGhlIA0KaXNzdWUgd2l0aCBpbXg4bW4uDQoNClJlZ2FyZHMsDQpBamF5DQoNCg==
