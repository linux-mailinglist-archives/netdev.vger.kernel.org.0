Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480666E2632
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjDNOtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDNOto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:49:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDB09039;
        Fri, 14 Apr 2023 07:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681483753; x=1713019753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PFl6Fwaw25i7A6nZ3ABkAJPeYshvk8EYWyNUOqZuPO8=;
  b=Bblz+BLcEpx1XqA7+xB65ApdZAoN3AK4dB4p7XisEhbMvioV5RN01WDD
   HoYGvIgKbi+U0mSjexm1LtvS2UJqdiTZn29ilIu/PwXCR3ai9Ae0Kd7k5
   wAVxb3z62TqexlzC5RUXwKSObSKEGOwChWEZ8STklCEc5jkO3X/bnQpkK
   r81A1SK8xAitUcvWsFRWCEo5sQkht/wBEq6LqPj18mj9M6Q4XxSzSRsab
   Z4Xjsc8o69tOJrlkg9gg/oNJ0npqJBDVfkV7a2Tb8qT/8Q+SHOlG4ajPg
   gMoYmV0bIFaJkzd2E3kAjRw+Vxe+2IBkSEeAukNe4W//dKUnqSOzEHTmd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="344480962"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="344480962"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 07:48:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="759124440"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="759124440"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 14 Apr 2023 07:48:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 07:48:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 07:48:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 07:48:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xhc3m0FNax8XYzKqTFwSiBsCwLj9hXO5g5zRJG0eJRzrztQ+41dLD46w1gsIEf/qWJ0+ygLUHSgMYQCCRR0A6hC4vI4i7KqKPiKD73Ep8NlCcsGzihAnQZ682thifFBbsFvKVeG1dW7iEJGvrWFOikEitZIK72uGK9AOkLGSzUDjljwdjxntqjrf9GdER5VgHL5cMid+phN+H+ewGHzC2Yj42QQFsM4pcvKfrf+XM0/PVKboWiGM0Pj/x2TOnpPNgeic/AWlysQvvjTK9oVa9rnEk14mWyxVHAZKeyuKy3qXf/70U/K52mQDr03f8y9thqHmPU+ssuKGWkbqKg0wOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFl6Fwaw25i7A6nZ3ABkAJPeYshvk8EYWyNUOqZuPO8=;
 b=FMA/3YMj8A52YPUE95qLu4r/8jY7q6H2eITXmJ1ikU8QvPTYHQ8yAUM9pI73sK2ddrJeY6LI/O13W/1vdiLgJQh04NZCJA0KNhRqD7UUsRMJ19LiLz9BjqYJH8Swd9GeCkKHbcXl++kBZdXYIdwnqP9imfQ9fCj3zq1tOdJXT76RmoMLWQNtciUQ0olVWLEDceZZ9lson0iizos7LIZr2WQXk3uaC2yHfhpz8bOsNvNI1+lYNAklxsfPWgRWCvAOY5jnSCe7v0LoIIPADkkFxFTjWx7zceX9BeMRqzZczMliAKWcNmn3N6oL1XGKXPRK4o4WcvGywOhIVtlurrN9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by MW4PR11MB7031.namprd11.prod.outlook.com (2603:10b6:303:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 14:48:24 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 14:48:23 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "Andre Guedes" <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
Subject: RE: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbnY42u7Gz9ET40eYzbfYWKvVVq8qkCGAgAAQJMCAABqMIIAAIEaAgAAF3oA=
Date:   Fri, 14 Apr 2023 14:48:23 +0000
Message-ID: <PH0PR11MB5830E7158428C51912981EB0D8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
 <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
 <PH0PR11MB5830D3F9144B61A6959A4A0FD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
 <4dc9ea6c77ff49138a49d7f73f7301fd@AcuMS.aculab.com>
 <a81e4d8e-c668-5238-225a-8223af45a063@redhat.com>
In-Reply-To: <a81e4d8e-c668-5238-225a-8223af45a063@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: dd7706b6-8f1e-456b-b3a8-08db3cf74c1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gdm82g3j8wIJRpdWgO6OtgaQjSKhIjFdb+Zhvx6Y7taJGberYCTvYvXbiWGCTx5QnIgirhcyGUEs5/z+8foLn5gQfY1mdeLCz6k7QYu6DhH81dlhr7svtf+uMyjEqO32hvbrhhN18p1D/DbOTZvXPNzaU69AEkjAvFZpO+2j19Xv1Bfpiv0Iwz/AxEb345W110Sp7lArEN2yiUHy0cENdYpvsOaMPL5UGTi1QemRSku2O4Zcxy2GNCEX/iJQRWDMm0oMPDJ7NOGAOtWL/ut0CuS/BsqNsXbp8b76pUW2sYVqGzZXuoKm77jjCHUTSI9XE0SPSw6BogGv4BWCPKRzURDDc27YeXS9t7kDurtVRZNj3y9djV0ELPti3rgRPK05HjiXq1FkxjFOynyDMsa3iAqJYO2ex4XWKZiaokf+5QaNLb2RxhKSv3Civtfl6TVJt6J3WLYLbGBmw/HICSOQYyVQuzPT7YfuKQ2PrPijDYNpFS/SHoY2zNzjRMP63/d3b5ffggoHdbnQHCOaINyXy7BLTOwZX4cdjrq5MuBLm6O4ySrwVw/G4Q9O2ZVvWt84Iks7hC9Xgx+VXzfXdtawSgGOe2dnFBKjboN1Prc2jNxB4b6NuIfrdaK51FHbjYc1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(316002)(4326008)(38100700002)(64756008)(82960400001)(66446008)(66556008)(66946007)(66476007)(76116006)(5660300002)(41300700001)(52536014)(7696005)(71200400001)(86362001)(107886003)(55236004)(54906003)(6636002)(26005)(186003)(9686003)(53546011)(6506007)(38070700005)(2906002)(83380400001)(7416002)(8676002)(8936002)(55016003)(33656002)(478600001)(921005)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STlCVW5sUkh2aWhpRTR5SVVuak5qaGNkMWtQd1E0QlZUd09LU0RvenRtOXY3?=
 =?utf-8?B?YS9JcUpwdWxXSTd2YjJ2clhMQjQ4MmRCU3l2Q3V1MnEwYnYzTGx1ajlvVTJU?=
 =?utf-8?B?a2tkZ2Q3S05vQnZCOUhVVzBoM3V6Rm1WVDlNcmdwUWpVVjZiWmRUemsySmVv?=
 =?utf-8?B?QVh5UE90a3VNRWZlU0hTc2k2TTF4KzRsSnlkaThyUmlJQk9jNXM3ejRoK1RD?=
 =?utf-8?B?K1ExQm9wbEJRWGQxRnVHMjcyQUFYTmxWblpYOHhBNDduQWxkdFZEOG9lRDVy?=
 =?utf-8?B?R0JSTTJIS2hERzlrWGFpMkhuUWFRR0ZMWnYwNjVMREJyZEJJbk9LNWgrL0l5?=
 =?utf-8?B?dFMvbVRTNEg5bGFWZHRycmZTYzhyay95UStyTjI2ZjhTZGxXQ3NOSWFnaTRL?=
 =?utf-8?B?R3FFcWhBaHVlOFVjODZucFZPVDRBUyt4cUhvR2JFVnhGV3hBemZNYVIyOU1x?=
 =?utf-8?B?Q3E1TG1hTzR3U2hxc0JuZ3RTQmRscy9rbzJsd1g5QjcxaG02ZEVlZWNkTE4x?=
 =?utf-8?B?d0dIQThyRzRtRG5VN2U0aTRtT0dRYnVpRHpQRnovK3h4ZFFrdEhrRWdiTm9R?=
 =?utf-8?B?RGVKN21neUNRaWlORjVUc0JkTXY1eHRzcWdURFZRN3RqQVR0OU1BWURqZVZ4?=
 =?utf-8?B?RS9ReWp4RUpCQlkrSExUUjk4N0w1VWZsRjFiMlZhdlNtaUhzc3pvZnJJUXFT?=
 =?utf-8?B?Vko1OTIxa3YzczBIOTRsV09KeUM1d3NaZDBwWWNZWGhjY0Y5N1RSQXk5dWFG?=
 =?utf-8?B?aEZrekpMNnVQWThuZWhyK1JLWk9hTng3UGc1NjZxd2lKSDVHRUdEKzFsV3dO?=
 =?utf-8?B?S3ZUZkIzVGxCNmd2blYvK2Q2eU4xZ3JKdmdNcnhyUWVCZkVBZDVWTlBqYXpK?=
 =?utf-8?B?VTUxeFhGWWp1ZmJDdUtvbmRzU0gzUlNuNENzRUcyNmFOUmhiaUk2akVTd0NE?=
 =?utf-8?B?RkdlNitTQXYyekNuZzJsMFhSRTBIL2hsWDUyWTFOYURGL2cvemp5NngvblJF?=
 =?utf-8?B?K0FTUkFFSHQzcktDMGxTUGtoS1ZNMFhRWnp0bkl0YnNGOFBwNitQVUtjRFVk?=
 =?utf-8?B?Z3EwZEpSeE1WRzlHZHJQNk1xS0JRWmZwajhwdTBWUUppNW16TTVjdjJaVHk2?=
 =?utf-8?B?RmtYQlExTUNWcWs0bjZua1JvTEliQ0IvY1Z1WHE0aVdZRE5ld1JTTWJxT2c1?=
 =?utf-8?B?MVhQaGJwRVQxVW5NQXhpK0E3RjlFNFVCdHM1Y3dHOXk1V0crU0dVU2poZTh6?=
 =?utf-8?B?czZzMGpWdlhIaEJacUdqckh5bklqc3JOUXo0SHJXa200d0piN2x5VXkzVHRr?=
 =?utf-8?B?aUUvZVlvcGpYNXQ4dVJvNEpMSzhobGp6NmE0dFViMTNlRVNMMWVOTkZjb3V6?=
 =?utf-8?B?Sk9YaUlSSjZlekpPck4vUDhrR0Z3cmp0V3N2ZXJ3YVN3UGJzSUxsSmNoalZ2?=
 =?utf-8?B?SHpORU5WQkZSRDh2Q2hReFJmamU5U3EzMkhWZm9jZHRyUDFhdDhrUjd4dXBM?=
 =?utf-8?B?NXptY29sSlY0Tm41bmoxeE1lb0t1SnpuUUFIZzZrNFVja3NmemJVYVQrOXgv?=
 =?utf-8?B?cFpkaHAvZVk0aGliMkRkUTY3TmtYS200UXNZbEIweDRiVmFjOS9uR0NHejh0?=
 =?utf-8?B?QTE2NGNGQlRHbXYwRjNpNXh0cEZhNml2d0hpL0twS05XYlh4bjVEUi9Tbm5j?=
 =?utf-8?B?VTZLaDgwclVqditsSkFyOFpRRjN4c1ZmbHB2bW9VaHFqNlZCT2t2SmdwbXk4?=
 =?utf-8?B?SmRsMUxOOFZpMnVYZy9wVGdxdlVtRW9jeWVPTjNsa3hvZFpaclE4TTFMbDh0?=
 =?utf-8?B?YU1FSnhvM3ZjNXJOMkUyMlA4V1h0dUp1SWdwdHVQMWtBQmw4OXNvcGVkZWpT?=
 =?utf-8?B?bHhLdDNBVVF0cWFuZEdnVGdWTGJYZjJnTXcwRkFZWmVFTW4vQ3hJaFdhMzcy?=
 =?utf-8?B?Sk9zNmdHVDBGMVhJVGhXTmNReThVYTZJQXJlR0ZQZHU1eGRlZjltTmhlMmFi?=
 =?utf-8?B?ZUQrb045VVFqTWUrU3E4aXRlYUR6N0kzZTJ1cThjZThGNkFaKzJ2eE9acTN5?=
 =?utf-8?B?M3lncWRsZ3c2WVROK3FzZllVSGhITkRDRUV2S3NuTkhLa08yTGtTN283U09B?=
 =?utf-8?Q?qG9vh/LD+ieBjQZBHQX54Dd2t?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7706b6-8f1e-456b-b3a8-08db3cf74c1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 14:48:23.4193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1fEZLnosSOIzwIXSpHNvQY2mf2gTGoaJ68i7GIbWBZA7GEc90XlYYhSXN4DWmZIRmQedW7/GE/ZAsE/X5VQxpgqxpIXehylQle7NODY3P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAxMDoxOSBQTSwgSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciA8amJyb3VlckByZWRoYXQuY29tPiB3cm90ZToNCj5PbiAxNC8wNC8yMDIzIDE0LjMyLCBEYXZp
ZCBMYWlnaHQgd3JvdGU6DQo+PiBGcm9tOiBTb25nLCBZb29uZyBTaWFuZw0KPj4+IFNlbnQ6IDE0
IEFwcmlsIDIwMjMgMTI6MTYNCj4+IC4uLg0KPj4+PiBJIGhhdmUgY2hlY2tlZCBGb3h2aWxsZSBt
YW51YWwgZm9yIFNSUkNUTCAoU3BsaXQgYW5kIFJlcGxpY2F0aW9uDQo+Pj4+IFJlY2VpdmUNCj4+
Pj4gQ29udHJvbCkgcmVnaXN0ZXIgYW5kIGJlbG93IEdFTk1BU0tzIGxvb2tzIGNvcnJlY3QuDQo+
Pj4+DQo+Pj4+PiAtI2RlZmluZSBJR0NfU1JSQ1RMX0JTSVpFUEtUX1NISUZUCQkxMCAvKiBTaGlm
dCBfcmlnaHRfICovDQo+Pj4+PiAtI2RlZmluZSBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9TSElG
VAkJMiAgLyogU2hpZnQgX2xlZnRfICovDQo+Pj4+PiArI2RlZmluZSBJR0NfU1JSQ1RMX0JTSVpF
UEtUX01BU0sJR0VOTUFTSyg2LCAwKQ0KPj4+Pj4gKyNkZWZpbmUgSUdDX1NSUkNUTF9CU0laRVBL
VF9TSElGVAkxMCAvKiBTaGlmdCBfcmlnaHRfICovDQo+Pj4+DQo+Pj4+IFNoaWZ0IGR1ZSB0byAx
IEtCIHJlc29sdXRpb24gb2YgQlNJWkVQS1QgKG1hbnVhbCBmaWVsZCBCU0laRVBBQ0tFVCkNCj4+
Pg0KPj4+IFlhLCAxSyA9IEJJVCgxMCksIHNvIG5lZWQgdG8gc2hpZnQgcmlnaHQgMTAgYml0cy4N
Cj4+DQo+PiBJIGJldCB0aGUgY29kZSB3b3VsZCBiZSBlYXNpZXIgdG8gcmVhZCBpZiBpdCBkaWQg
J3ZhbHVlIC8gMTAyNHUnLg0KPj4gVGhlIG9iamVjdCBjb2RlIHdpbGwgYmUgKG11Y2gpIHRoZSBz
YW1lLg0KPg0KPkkgYWdyZWUuIENvZGUgYmVjb21lcyBtb3JlIHJlYWRhYmxlIGZvciBodW1hbnMg
YW5kIG1hY2hpbmUgY29kZSB3aWxsIGJlIHRoZQ0KPnNhbWUuDQo+DQo+Pj4+PiArI2RlZmluZSBJ
R0NfU1JSQ1RMX0JTSVpFSERSU0laRV9NQVNLCUdFTk1BU0soMTMsIDgpDQo+Pj4+PiArI2RlZmlu
ZSBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9TSElGVAkyICAvKiBTaGlmdCBfbGVmdF8gKi8NCj4+
Pj4NCj4+Pj4gVGhpcyBzaGlmdCBpcyBzdXNwaWNpb3VzLCBidXQgYXMgeW91IGluaGVyaXRlZCBp
dCBJIGd1ZXNzIGl0IHdvcmtzLg0KPj4+PiBJIGRpZCB0aGUgbWF0aCwgYW5kIGl0IGhhcHBlbnMg
dG8gd29yaywga25vd2luZyAoZnJvbSBtYW51YWwpIHZhbHVlDQo+Pj4+IGlzIGluIDY0IGJ5dGVz
IHJlc29sdXRpb24uDQo+Pj4NCj4+PiBJdCBpcyBpbiA2NCA9IEJJVCg2KSByZXNvbHV0aW9uLCBz
byBuZWVkIHRvIHNoaWZ0IHJpZ2h0IDYgYml0cy4NCj4+PiBCdXQgaXQgc3RhcnQgb24gOHRoIGJp
dCwgc28gbmVlZCB0byBzaGlmdCBsZWZ0IDggYml0cy4NCj4+PiBUaHVzLCB0b3RhbCA9IHNoaWZ0
IGxlZnQgMiBiaXRzLg0KPj4+DQo+Pj4gSSBkaWRudCBwdXQgdGhlIGV4cGxhbmF0aW9uIGludG8g
dGhlIGhlYWRlciBmaWxlIGJlY2F1c2UgaXQgaXMgdG9vDQo+Pj4gbGVuZ3RoeSBhbmQgdXNlciBj
YW4ga25vdyBmcm9tIGRhdGFib29rLg0KPg0KPldlbGwsIHVzZXJzIHVzdWFsbHkgZG9uJ3QgaGF2
ZSBhY2Nlc3MgdG8gdGhlIGRhdGFib29rIChQcm9ncmFtbWluZw0KPkludGVyZmFjZSkgUERGLiAg
UGVyc29uYWxseSBJIGhhdmUgaXQsIGJ1dCBJIGhhZCB0byBnbyB0aG91Z2ggYSBsb3Qgb2YgcmVk
LXRhcGUgdG8NCj5nZXQgaXQgKHVuZGVyIFJlZCBIYXQgTkRBKS4NCj4NCj4NCj4+Pg0KPj4+IEhv
dyBkbyB5b3UgZmVlbCBvbiB0aGUgbmVjZXNzYXJ5IG9mIGV4cGxhaW5pbmcgdGhlIHNoaWZ0aW5n
IGxvZ2ljPw0KPj4NCj4+IE5vdCBldmVyeW9uZSB0cnlpbmcgdG8gZ3JvayB0aGUgY29kZSB3aWxs
IGhhdmUgdGhlIG1hbnVhbC4NCj4+IEV2ZW4gd3JpdGluZyAoOCAtIDYpIHdpbGwgaGVscC4NCj4+
IE9yIChJIHRoaW5rKSBpZiB0aGUgdmFsdWUgaXMgaW4gYml0cyAxMy04IGluIHVuaXRzIG9mIDY0
IHRoZW4ganVzdDoNCj4+IAkoKHZhbHVlID4+IDgpICYgMHgxZikgKiA2NA0KPj4gZ2NjIHdpbGwg
ZG8gYSBzaW5nbGUgc2hpZnQgcmlnaHQgYW5kIGEgbWFzayA5YXQgc29tZSBwb2ludCkuDQo+PiBZ
b3UgbWlnaHQgd2FudCBzb21lIGRlZmluZXMsIGJ1dCBpZiB0aGV5IGFyZW4ndCB1c2VkIG11Y2gg
anVzdA0KPj4gY29tbWVudHMgdGhhdCByZWZlciB0byB0aGUgbmFtZXMgaW4gdGhlIG1hbnVhbC9k
YXRhc2hlZXQgY2FuIGJlDQo+PiBlbm91Z2guDQo+Pg0KPg0KPkFmdGVyIEFsZXhhbmRlciBMb2Jh
a2luIG9wZW5lZCBteSBleWVzIGZvciBHRU5NQVNLLCBGSUVMRF9QUkVQIGFuZA0KPkZJRUxEX0dF
VCwgSSBmaW5kIHRoYXQgZWFzaWVyIHRvIHJlYWQgYW5kIHdvcmstd2l0aCB0aGVzZSBraW5kIG9m
IHJlZ2lzdGVyIHZhbHVlDQo+bWFuaXB1bGF0aW9ucywgc2VlWzFdIGluY2x1ZGUvbGludXgvYml0
ZmllbGQuaC4gIEl0IHdpbGwgYWxzbyBkZXRlY3QgaWYgdGhlIGFzc2lnbmVkDQo+dmFsdWUgZXhj
ZWVkcyB0aGUgbWFzayAobGlrZSBEYXZpZCBjb2RlIGhhbmRsZWQgdmlhIG1hc2spLiAodGh4IEFs
ZXgpDQo+DQo+ICBbMV0NCj5odHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4zLXJj
Ni9zb3VyY2UvaW5jbHVkZS9saW51eC9iaXRmaWVsZC5oI0wxNA0KPg0KPlNvLCBpbnN0ZWFkIG9m
Og0KPiAgIHNycmN0bCB8PSBJR0NfUlhfSERSX0xFTiA8PCBJR0NfU1JSQ1RMX0JTSVpFSERSU0la
RV9TSElGVDsNCj4NCj5JIHdvdWxkIHdyaXRlDQo+DQo+ICAgLyogQlNJWkVIRFIgdmFsdWUgaW4g
NjQgYnl0ZXMgcmVzb2x1dGlvbiAqLw0KPiAgIHNycmN0bCB8PSBGSUVMRF9QUkVQKElHQ19TUlJD
VExfQlNJWkVIRFJTSVpFX01BU0ssIChJR0NfUlhfSERSX0xFTiAvIDY0KSk7DQo+DQo+LS1KZXNw
ZXINCg0KVGhhbmtzIERhdmlkIGFuZCBKZXNwZXIgZm9yIHRoZSBjb21tZW50cy4NCkkgYWdyZWUg
dG8gbWFrZSB0aGUgY29kZSBtb3JlIGh1bWFuIHJlYWRhYmxlLg0KV2lsbCByZWZhY3RvciB0aGUg
Y29kZSBhbmQgc2VuZCBvdXQgdjMgZm9yIHJldmlldy4NCg0KVGhhbmtzICYgUmVnYXJkcw0KU2lh
bmcNCg0K
