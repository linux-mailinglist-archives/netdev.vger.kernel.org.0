Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D657660D
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiGORcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiGORcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:32:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C7E18341;
        Fri, 15 Jul 2022 10:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657906321; x=1689442321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SmAj3vU3OGyfSDY4Sr2oFiLtCQDTW2UEpVjuZxkXdWk=;
  b=FaFuydMy/b0E+q4lnAf4wbMpG4c4IktAkfMxyZuiO/CujGT3ArFmLXq+
   bWAQy38qll+GXJ/3mI593T0slfffgzIBrIUF+0QuiK8hJ4ZJ/UKBMRgTY
   qXfFPsZMKx/tvEGXMFM0TzJ2Es9dBQI5RK6jIO2LzIx193zM7VVopnHqT
   aO4YLAYWdOcIkmHMSyZ9rcsJqCeN+09u9xvicR8DKSRdYo6hTlmlP8iJs
   NH4WHbQtkxLTv84VNs+4kTMjOszVG286ZMcpNhc30m3OX1eIGu0Ank9We
   Ej7xzWmjuWpGXeV6pLmi1zSUq1Zf9CVNNRRDLWqlzQljabTtln3eERfS1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="265643363"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="265643363"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 10:31:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="723155381"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2022 10:31:39 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Jul 2022 10:31:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Jul 2022 10:31:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixKAhu8Yfr5DBSKd5gwLXfMPCByH1zJgL7PGhly8YHwfHKoV1J3OssiH4ZM1EH5oIypoGSXAjKwcGQG1VKNXluHkKvVtvBqqtH65zro0AaAowmkklHxgnbchkZPIhJYrvrNM619vIGL4u9sdWMgEq8aAq1BPnqatoed2NKMWxBW4DVcgyBePlPNFkeCATqNzZWN9lt/0CiL6/SrZWacwQBLavJcp6SMUj3BYtvBBIuNPgmr7dAEWGH7fe3yQXFw8lYnbo+5IUynrAvT7AbsVzDk+4UfUpDFWDPEmPC43CMMgOZRW2ZGcPJlahn/8U8LFDmS9+NOLqiI3NVY+Eoi6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmAj3vU3OGyfSDY4Sr2oFiLtCQDTW2UEpVjuZxkXdWk=;
 b=XmCl2sGmwiha54NmTgkcHCDXcCPT8ZSktpp20OHXqT7h+V0hN2g8Bx2xzozkUxz3I6WDS1XB2UngZduLjUGXR+myn9ciewcc3tELkQk92yRhlfnDarSaxPhFlOlClOPQfskf+O1LXCZpwhLZv/dzn477ajYMghtNyc8C2Wy8Qn00TVXwCsfsRmaKEFS+1GNDsYF01YkZ/xySBA6zwsKoo/5KOI0404VcwYcjROZKvQ15/n4mVtc/kuXOazMtH9kxV1AsZHePin1zaGs8BXnEhVUQyLhf0kFyZ8ruKjBxb03O9UkGicthtYnfsZW346zjFD3MqAKMbEKyVQE8Sq+HjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BN6PR11MB4147.namprd11.prod.outlook.com (2603:10b6:405:80::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Fri, 15 Jul 2022 17:31:34 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%6]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 17:31:34 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Thread-Index: AQHYiZJ9XsNFx64Yukic2kh2Sx3oGa149B1ggAWqRQCAASYmUA==
Date:   Fri, 15 Jul 2022 17:31:34 +0000
Message-ID: <DM6PR11MB46571C7D9DC3FB47239994F29B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-2-vfedorenko@novek.ru>
 <DM6PR11MB4657460B855863E76EBB6BCD9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
 <46554eb0-e7ff-09e5-6a39-5d7545387677@novek.ru>
In-Reply-To: <46554eb0-e7ff-09e5-6a39-5d7545387677@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e21894a-f590-4877-4f15-08da6687dd59
x-ms-traffictypediagnostic: BN6PR11MB4147:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYsVOguAFMIQn8Ujqtys+5tCdlPOgKXKGtb7BUg0+rORsmT/3HgwzwyMRdCEdVBqSN9Y3ZHqtAONBDEQUqZ6WmARmRTfikSlCZoaY3GV0wD7fPku7exlLmxRYdsr9uANwdVxJQovNnAwUpv0xZkrQDFUPtPk/TIA5z6Var9f8NiM85IyXA+QhPSdFx90Py/zo4abDyl4iZFA5e72tJXqwnVP61N9MbesxlrzfXdh7aPu1/nMFSMwc/wPYRy6GyE1NFSlE6473C2ckkY2E+GjcICaWhw66r8SEUHPQr2Z/94kY2qryvgmSJm4FmsBSbpZefN24fBykIjimR9rNWj0cL/DMGD73r2KAUDK672KCMyz0G58pfwLXO+IDbF78J8WpGlVrfFHpSAvLVqmiTJfvf1QMkfY6KbEF94CILdYMuR66/0GdblsJ4KS9yqdqO5Lz9exRuhJZlb1UFbKr5myerTGAge3ihZNRUI8/ZmSa49ZWDqsBCneoFwGSLp5y/ckhH02oIv+r00fp4LbYLic/KreFj6Rq8gQg6IHhNDN+Wh7X2BCNSnpKuQ5bSYgApIR5othdxkGyk0UuB3GTDBEEIZ4ODFASBE4LmmLXyondLFiSCxkp14s13tfmJyKHXMeyH8v5bgIRTK9qZJxoeyXx/evURJAFZd9albMWNPzPU87SxIozHJoHd8ScCBf+REbaFRiXrUzupzFPeU/zO/JGktSsw3y70gkb9ok3iZyl1sy6gkzC6XUQ4e8+OLqR1/m6NQKBCX3WkstsK3m/6foWq5wdgoUingmV7Nq9OXf31Z9iS/ADoHhUjklQMyg3a29
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(396003)(376002)(366004)(52536014)(33656002)(86362001)(38070700005)(122000001)(82960400001)(186003)(83380400001)(38100700002)(55016003)(76116006)(71200400001)(7696005)(8676002)(478600001)(26005)(41300700001)(54906003)(316002)(5660300002)(6506007)(4326008)(110136005)(66946007)(64756008)(9686003)(66556008)(66476007)(8936002)(2906002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGhIbUc3eVJtbXhpRzdVMS9rQmdrN3NGRG9XN0l2Q0plRUg4c0src01XMTBV?=
 =?utf-8?B?VGcrWFhyYmRFdkF2OUovVlBtcGpFbGIzTjFYcTNJeWoyRmdrN0xwWThIdjlZ?=
 =?utf-8?B?em5vVlpDNlVzaWsrc2pxSi9CWUVpT3Y2UmZ1bnJUYnV3a2lqeEs2WU1qSVhq?=
 =?utf-8?B?eTNJUWh1ZHhTUW1NcUVoYzMwNkFBbHZWU0VvYlkyWVVjOVNyNVJwbVJnWktx?=
 =?utf-8?B?MnIzbEYrZHRSdHZCQUM5Y2o0ODEyWTJQR05kWFBsWERSV2huT216NXJDcVd6?=
 =?utf-8?B?Mk1YRHYwWUhRK3VUcnc0b0ZXcUE0eno4Qzg2dGlJbjNvSVVIYlhHSEFFdlJy?=
 =?utf-8?B?SDJkOEFWbHBRUTdsQ3ZMVlFTN2pMU3BqOXVIMytBRzdELzZiUXBxMEppNGc5?=
 =?utf-8?B?eVIwaDIxMFVuK2FGRFhkZk1WaGlwaHVKbDluTGJIYU1IUTRJUHdMZHl5SkZK?=
 =?utf-8?B?R2JxTWVmZkkrNHBldk41MEdQT2hjcENsUE1FcW9LcVFTSU9XRFJCRVZhQUFL?=
 =?utf-8?B?QSs0amIzaDRIWHlDaERVTjBBeUdZTU1KQzhqTlk4WlhoWURIOTRIb1pKYjZp?=
 =?utf-8?B?QlZ2L0tmU284aEFzNXNjSCtWaFFINWpZYWZ1bUhrUjd4aDdVem1WSVJzNnd4?=
 =?utf-8?B?TGZqcitxOWp1R00vcnRwKzV4YkhreHRkSFR4QjZBYlRoZFA1eXdEMzNwWlFS?=
 =?utf-8?B?OGw4Y3RSR1ZpTzI5SjZBY1RRdTJxQWNXWCthdm1yZWZwazNQQ3dKOFFtN0RD?=
 =?utf-8?B?UUszMktmNXhjZkdGUzFUcXpHaWZLaXkwWk9YMkRHTTFSRjZXR01aVkhmcmEx?=
 =?utf-8?B?bXVaN0owWHovb3ZkYXdvZWFOak5NdGh6aWRlZzBnbHRLWng0YmViajVXaU13?=
 =?utf-8?B?U0wwNkNBekZKVWZvM3pKSkNMbGMwMUo2VTBXaERRc2lCV3VDNXMrU0V4cWVk?=
 =?utf-8?B?SFY3Uk15VmJSNmlzQUhyVVNyYStuc2Fkckdub0wyWDhMMGxXcFRFaEIydVh4?=
 =?utf-8?B?enh2OWhxTDFUa2ljOERydWh0VzlSaEVINHMvZkF3MWNhTms1Rzd1MmwvTFRm?=
 =?utf-8?B?QXVTQU9nY05tS0pWVWFpMCtLbGtiY0Y0R1FZbS9YWFFRSWl6UEpZdHpYWlo2?=
 =?utf-8?B?L041alBxSWlPU2VubG5KcTU0TFROWkM5K3dSYTlXb0hHREcrKzBUai94VlIy?=
 =?utf-8?B?bElCRHU4dWkrSUxmOTkvSHhWS3BacU5ZdGV2MndIbllIbE5nZEduS3crdnl5?=
 =?utf-8?B?cEdhUVEzRUdBbTcremp1Mk1qbXRmS1FuNDZNOVVyWHV4V09nY0VMVy9lWWNp?=
 =?utf-8?B?V0tyeEVaK0wxb3FRRTF2NmVTaFVGZHZtQmNuSU9SNitDamo5NzBvWTgyNlQ3?=
 =?utf-8?B?SXpiYmc4T0pQYnhRVlhHMGVPN1c1ZGcwUStxNjJEQ2dsQkp5aW8rZnFDc3p0?=
 =?utf-8?B?S0ZURDVCamgvQjhCTGVWY0FhNGg3d3lYOVZFTWo4Yi9XdFFUSDlSY0Y4SFlB?=
 =?utf-8?B?bU9QSlg2SklVZ2E3VXpVYU9KbjZ5SXBUcXVMQW5LNzF2MklhdXAyV1RLTEhZ?=
 =?utf-8?B?WVdINXNSRHUyajZNd1ZBS1ptTHd0aWZQMnBiZ29Uc2RXNmY1Mmpvamk3YlRm?=
 =?utf-8?B?T1pHK0NKUE1QVHRxanZPQVU2TjZKZUlscndzSUxkbGkxSlJtQTFVYTBlSUUz?=
 =?utf-8?B?RjVBc3d6ejFqV1o0b2pHWndtM2xXcGhYNXFzbHJUVXI2Rmh3QVVRaU13V0Zx?=
 =?utf-8?B?MlZSR3UxaitEVFlVZTduVFVYZjlQVlRUS2RrUXE5U3RBSVJFa0JlRGZaZmhO?=
 =?utf-8?B?YzBML2Q1cEROaWxhMnNheGlzdE9Za1ZSYlJxUDFza0xwVWxCMWdNYlk1ekx3?=
 =?utf-8?B?cTZuSWQydTQvSE9uOWRDZUk3RmFXanhKaHJFRjBHQ3lnbXdwL0ZYKzNTdEoy?=
 =?utf-8?B?ZlVvUjFQYTY0Tzc2QVV3Sms5VjBQYjY2UFU1Y2l6VnVnRXFZZE5EOTFKemp6?=
 =?utf-8?B?T1dHSTE4cWpKSjVpUVoyT1pCK2E0WTYrZkRYYjNpa1lheWU2T3VvUFcrVVhQ?=
 =?utf-8?B?NkpNd0g5MWlrTkVlL3hJZEtoZlNYblkrUkNwOEhNN3dZK3FlbzF6Y0NPbHRQ?=
 =?utf-8?B?NGxuMFRkNU15aHN4WEhLbTBkcFR5a2l3MTF6Y2F5a1BQOGRZZ2Ywb3o2ZlVH?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e21894a-f590-4877-4f15-08da6687dd59
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 17:31:34.6256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +jRDFsdl5rUecCzSeQoiFeHYKYueSNypzvKDXgXpORS0aDP/PSyadXWquzuP3pYZSptxDzzpE8JQHLeveig/41EK+j7dxabA+BtDBm7edaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4147
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmFkaW0gRmVkb3JlbmtvIDx2ZmVk
b3JlbmtvQG5vdmVrLnJ1PiANClNlbnQ6IEZyaWRheSwgSnVseSAxNSwgMjAyMiAxOjI0IEFNDQo+
DQo+T24gMTEuMDcuMjAyMiAxMDowMSwgS3ViYWxld3NraSwgQXJrYWRpdXN6IHdyb3RlOg0KPj4g
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+IEZyb206IFZhZGltIEZlZG9yZW5rbyA8dmZl
ZG9yZW5rb0Bub3Zlay5ydT4NCj4+IFNlbnQ6IFN1bmRheSwgSnVuZSAyNiwgMjAyMiA5OjI1IFBN
DQo+Pj4NCj4+PiBGcm9tOiBWYWRpbSBGZWRvcmVua28gPHZhZGZlZEBmYi5jb20+DQo+Pj4NCj4+
PiBEUExMIGZyYW1ld29yayBpcyB1c2VkIHRvIHJlcHJlc2VudCBhbmQgY29uZmlndXJlIERQTEwg
ZGV2aWNlcw0KPj4+IGluIHN5c3RlbXMuIEVhY2ggZGV2aWNlIHRoYXQgaGFzIERQTEwgYW5kIGNh
biBjb25maWd1cmUgc291cmNlcw0KPj4+IGFuZCBvdXRwdXRzIGNhbiB1c2UgdGhpcyBmcmFtZXdv
cmsuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBWYWRpbSBGZWRvcmVua28gPHZhZGZlZEBmYi5j
b20+DQo+PiANCj4+IEhpIFZhZGltLA0KPj4gSSd2ZSBiZWVuIHRyeWluZyB0byBpbXBsZW1lbnQg
dXNhZ2Ugb2YgdGhpcyBjb2RlIGluIG91ciBkcml2ZXIuDQo+PiBBbnkgY2hhbmNlIGZvciBzb21l
IHRlc3RpbmcvZXhhbXBsZSBhcHA/DQo+PiANCj4NCj5IaSBBcmthZGl1c3osDQo+U29ycnksIGJ1
dCBJIGRvbid0IGhhdmUgYW55IHdvcmtpbmcgYXBwIHlldCwgdGhpcyBzdWJzeXN0ZW0gaXMNCj50
cmVhdGVkIGFzIGV4cGVyaW1lbnRhbCBhbmQgYXMgd2Ugbm93IGhhdmUgZGlmZmVyZW50IGludGVy
ZmFjZQ0KPmZvciBjb25maWd1cmluZyBmZWF0dXJlcyB3ZSBuZWVkLCBhcHAgaW1wbGVtZW50YXRp
b24gaXMgcG9zdHBvbmVkDQo+YSBiaXQuIEFmdGVyIHNvbWUgY29udmVyc2F0aW9uIHdpdGggSmFr
dWIgSSdtIHRoaW5raW5nIGFib3V0IGxpYnJhcnkNCj50byBwcm92aWRlIGVhc3kgaW50ZXJmYWNl
IHRvIHRoaXMgc3Vic3lzdGVtLCBidXQgc3RpbCBubyBjb2RlIHlldC4NCj4NCj4+PiArc3RydWN0
IGRwbGxfZGV2aWNlICpkcGxsX2RldmljZV9hbGxvYyhzdHJ1Y3QgZHBsbF9kZXZpY2Vfb3BzICpv
cHMsIGludCBzb3VyY2VzX2NvdW50LA0KPj4+ICsJCQkJCSBpbnQgb3V0cHV0c19jb3VudCwgdm9p
ZCAqcHJpdikNCj4+IA0KPj4gQXJlbid0IHRoZXJlIHNvbWUgYWxpZ25tZW50IGlzc3VlcyBhcm91
bmQgZnVuY3Rpb24gZGVmaW5pdGlvbnM/DQo+Pg0KPg0KPlllYWgsIEkga25vdyBhYm91dCBzb21l
IHN0eWxlIGlzc3VlcywgdHJ5aW5nIHRvIGZpeCB0aGVtIGZvciB0aGUgbmV4dCByb3VuZC4NCj4N
Cj4+PiArew0KPj4+ICsJc3RydWN0IGRwbGxfZGV2aWNlICpkcGxsOw0KPj4+ICsJaW50IHJldDsN
Cj4+PiArDQo+Pj4gKwlkcGxsID0ga3phbGxvYyhzaXplb2YoKmRwbGwpLCBHRlBfS0VSTkVMKTsN
Cj4+PiArCWlmICghZHBsbCkNCj4+PiArCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCj4+PiAr
DQo+Pj4gKwltdXRleF9pbml0KCZkcGxsLT5sb2NrKTsNCj4+PiArCWRwbGwtPm9wcyA9IG9wczsN
Cj4+PiArCWRwbGwtPmRldi5jbGFzcyA9ICZkcGxsX2NsYXNzOw0KPj4+ICsJZHBsbC0+c291cmNl
c19jb3VudCA9IHNvdXJjZXNfY291bnQ7DQo+Pj4gKwlkcGxsLT5vdXRwdXRzX2NvdW50ID0gb3V0
cHV0c19jb3VudDsNCj4+PiArDQo+Pj4gKwltdXRleF9sb2NrKCZkcGxsX2RldmljZV94YV9sb2Nr
KTsNCj4+PiArCXJldCA9IHhhX2FsbG9jKCZkcGxsX2RldmljZV94YSwgJmRwbGwtPmlkLCBkcGxs
LCB4YV9saW1pdF8xNmIsIEdGUF9LRVJORUwpOw0KPj4+ICsJaWYgKHJldCkNCj4+PiArCQlnb3Rv
IGVycm9yOw0KPj4+ICsJZGV2X3NldF9uYW1lKCZkcGxsLT5kZXYsICJkcGxsJWQiLCBkcGxsLT5p
ZCk7DQo+PiANCj4+IE5vdCBzdXJlIGlmIEkgbWVudGlvbmVkIGl0IGJlZm9yZSwgdGhlIHVzZXIg
bXVzdCBiZSBhYmxlIHRvIGlkZW50aWZ5IHRoZQ0KPj4gcHVycG9zZSBhbmQgb3JpZ2luIG9mIGRw
bGwuIFJpZ2h0IG5vdywgaWYgMiBkcGxscyByZWdpc3RlciBpbiB0aGUgc3lzdGVtLCBpdCBpcw0K
Pj4gbm90IHBvc3NpYmxlIHRvIGRldGVybWluZSB3aGVyZSB0aGV5IGJlbG9uZyBvciB3aGF0IGRv
IHRoZXkgZG8uIEkgd291bGQgc2F5LA0KPj4gZWFzaWVzdCB0byBsZXQgY2FsbGVyIG9mIGRwbGxf
ZGV2aWNlX2FsbG9jIGFzc2lnbiBzb21lIG5hbWUgb3IgZGVzY3JpcHRpb24uDQo+Pg0KPg0KPk1h
eWJlIGRyaXZlciBjYW4gZXhwb3J0IGluZm9ybWF0aW9uIGFib3V0IGRwbGwgZGV2aWNlIG5hbWUg
YWZ0ZXIgcmVnaXN0ZXJpbmcgaXQ/DQo+QnV0IGF0IHRoZSBzYW1lIHRpbWUgbG9va3MgbGlrZSBp
dCdzIGVhc3kgZW5vdWdoIHRvIGltcGxlbWVudCBjdXN0b20gbmFtaW5nLiBUaGUNCj5vbmx5IHBy
b2JsZW0gaXMgdG8gY29udHJvbCB0aGF0IG5hbWVzIGFyZSB1bmlxdWUuDQoNClJpZ2h0IG5vdyB0
aGUgbmFtZSBpcyB1bmlxdWUsIGJ1dCBpdHMgbm90IHBlcnNpc3RlbnQsIHNvIHRoaXMgYWxzbyBt
aWdodCBiZQ0KaGFyZCBmb3IgdGhlIHVzZXIuIFJlbG9hZGluZyBkcml2ZXJzIHdoaWNoIGltcGxl
bWVudGVkIHRoZSBkcGxsIGludGVyZmFjZSB3aWxsDQpyZXN1bHQgaW4gYSB1c2Vyc3BhY2UgYXBw
IGNvbmZpZyBtZXNzLCBhcyBvcmRlciBvZiBsb2FkaW5nIHdpbGwgaW1wYWN0IHRoZWlyIGlkDQpp
biBkcGxsPGlkPiBmb3JtYXQuDQoNCk1heWJlIHNvbWUgYWRkaXRpb25hbCBzdHJpbmcgaWQgaW4g
Zm9ybWF0IGxpa2UgPHBjaV9pZD4uPGlkeD4/DQpBcyBJIHVuZGVyc3RhbmQgd2hhdGV2ZXIgaXMg
cmVnaXN0ZXJpbmcgYSBkcGxsLCBpdCBzaG91bGQgYmUgc29tZSBraW5kIG9mDQpkZXZpY2UsIHRo
dXMgd2UgY291bGQgcGFzcyBwb2ludGVyIHRvIGRldiBvbiBhbGxvYyBhbmQgYXNrIGl0IGZvciBk
ZXZpY2UgbmFtZQ0KKGRldl9uYW1lKGRldikpPw0KVGhlIDxpZHg+IGNvdWxkIGJlIGdpdmVuIGFs
c28gb24gYWxsb2MsIHRoZSBkcml2ZXIgZGV2ZWxvcGVyIHdoaWNoIHdvdWxkIGJlDQp1c2luZyBk
cGxsIHN1YnN5c3RlbSB3aWxsIHRha2UgY2FyZSBvZiBnZXR0aW5nIHVuaXFlIHZhbHVlcyBmb3Ig
aXQsIGFzIGl0IHdvbid0DQpiZSBmdWxseSB1c2FibGUgd2l0aG91dCBpdCBiZWluZyB1bmlxdWUu
DQoNCj4NCj4+PiArCW11dGV4X3VubG9jaygmZHBsbF9kZXZpY2VfeGFfbG9jayk7DQo+Pj4gKwlk
cGxsLT5wcml2ID0gcHJpdjsNCj4+PiArDQo+Pj4gKwlyZXR1cm4gZHBsbDsNCj4+PiArDQo+Pj4g
K2Vycm9yOg0KPj4+ICsJbXV0ZXhfdW5sb2NrKCZkcGxsX2RldmljZV94YV9sb2NrKTsNCj4+PiAr
CWtmcmVlKGRwbGwpOw0KPj4+ICsJcmV0dXJuIEVSUl9QVFIocmV0KTsNCj4+PiArfQ0KPj4+ICtF
WFBPUlRfU1lNQk9MX0dQTChkcGxsX2RldmljZV9hbGxvYyk7DQo+Pj4gKw0KPj4+ICt2b2lkIGRw
bGxfZGV2aWNlX2ZyZWUoc3RydWN0IGRwbGxfZGV2aWNlICpkcGxsKQ0KPj4+ICt7DQo+Pj4gKwlp
ZiAoIWRwbGwpDQo+Pj4gKwkJcmV0dXJuOw0KPj4+ICsNCj4+PiArCW11dGV4X2Rlc3Ryb3koJmRw
bGwtPmxvY2spOw0KPj4+ICsJa2ZyZWUoZHBsbCk7DQo+Pj4gK30NCj4+IA0KPj4gZHBsbF9kZXZp
Y2VfZnJlZSgpIGlzIGRlZmluZWQgaW4gaGVhZGVyLCBzaG91bGRuJ3QgaXQgYmUgZXhwb3J0ZWQ/
DQo+PiANCj4NCj55ZWFoLCBkZWZpbml0ZWx5LiBBbHJlYWR5IGNoYW5nZWQgaW4gbmV3IGRyYWZ0
Lg0KPg0KPj4+ICsNCj4+PiArdm9pZCBkcGxsX2RldmljZV9yZWdpc3RlcihzdHJ1Y3QgZHBsbF9k
ZXZpY2UgKmRwbGwpDQo+Pj4gK3sNCj4+PiArCUFTU0VSVF9EUExMX05PVF9SRUdJU1RFUkVEKGRw
bGwpOw0KPj4+ICsNCj4+PiArCW11dGV4X2xvY2soJmRwbGxfZGV2aWNlX3hhX2xvY2spOw0KPj4+
ICsJeGFfc2V0X21hcmsoJmRwbGxfZGV2aWNlX3hhLCBkcGxsLT5pZCwgRFBMTF9SRUdJU1RFUkVE
KTsNCj4+PiArCWRwbGxfbm90aWZ5X2RldmljZV9jcmVhdGUoZHBsbC0+aWQsIGRldl9uYW1lKCZk
cGxsLT5kZXYpKTsNCj4+IA0KPj4gZHBsbF9ub3RpZnlfZGV2aWNlX2NyZWF0ZSBpcyBub3QgeWV0
IGRlZmluZWQsIHRoaXMgaXMgcGFydCBvZiBwYXRjaCAyLzM/DQo+PiBBbHNvIGluIHBhdGNoIDIv
MyBzaW1pbGFyIGNhbGwgd2FzIGFkZGVkIGluIGRwbGxfZGV2aWNlX2FsbG9jKCkuDQo+Pg0KPg0K
PkFoLiBZZXMsIHRoZXJlIHdhcyBzb21lIG1lc3Mgd2l0aCBwYXRjaGVzLCBsb29rcyBsaWtlIEkg
bWlzc2VkIHRoaXMgdGhpbmcsIHRoYW5rDQo+eW91IGZvciBwb2ludGluZyBpdC4NCj4NCj4NCj4+
PiArc3RhdGljIGNvbnN0IHN0cnVjdCBnZW5sX29wcyBkcGxsX2dlbmxfb3BzW10gPSB7DQo+Pj4g
Kwl7DQo+Pj4gKwkJLmNtZAk9IERQTExfQ01EX0RFVklDRV9HRVQsDQo+Pj4gKwkJLnN0YXJ0CT0g
ZHBsbF9nZW5sX2NtZF9zdGFydCwNCj4+PiArCQkuZHVtcGl0CT0gZHBsbF9nZW5sX2NtZF9kdW1w
aXQsDQo+Pj4gKwkJLmRvaXQJPSBkcGxsX2dlbmxfY21kX2RvaXQsDQo+Pj4gKwkJLnBvbGljeQk9
IGRwbGxfZ2VubF9nZXRfcG9saWN5LA0KPj4+ICsJCS5tYXhhdHRyID0gQVJSQVlfU0laRShkcGxs
X2dlbmxfZ2V0X3BvbGljeSkgLSAxLA0KPj4+ICsJfSwNCj4+IA0KPj4gSSB3b3VsZG4ndCBsZWF2
ZSBub24tcHJpdmlsZWdlZCB1c2VyIHdpdGggcG9zc2liaWxpdHkgdG8gY2FsbCBhbnkgSFcgcmVx
dWVzdHMuDQo+Pg0KPg0KPlllcCwgZGVmaW5pdGVseS4gRGlkbid0IHRob3VnaHQgYWJvdXQgc2Vj
dXJpdHkgcmVzdHJpY3Rpb25zIHlldC4NCj4NCj4NCj4+PiArLyogQ29tbWFuZHMgc3VwcG9ydGVk
IGJ5IHRoZSBkcGxsX2dlbmxfZmFtaWx5ICovDQo+Pj4gK2VudW0gZHBsbF9nZW5sX2NtZCB7DQo+
Pj4gKwlEUExMX0NNRF9VTlNQRUMsDQo+Pj4gKwlEUExMX0NNRF9ERVZJQ0VfR0VULAkvKiBMaXN0
IG9mIERQTEwgZGV2aWNlcyBpZCAqLw0KPj4+ICsJRFBMTF9DTURfU0VUX1NPVVJDRV9UWVBFLAkv
KiBTZXQgdGhlIERQTEwgZGV2aWNlIHNvdXJjZSB0eXBlICovDQo+Pj4gKwlEUExMX0NNRF9TRVRf
T1VUUFVUX1RZUEUsCS8qIFNldCB0aGUgRFBMTCBkZXZpY2Ugb3V0cHV0IHR5cGUgKi8NCj4+IA0K
Pj4gVGhpcyB3ZWVrLCBJIGFtIGdvaW5nIHRvIHByZXBhcmUgdGhlIHBhdGNoIGZvciBEUExMIG1v
ZGUgYW5kIGlucHV0IHByaW9yaXR5IGxpc3QNCj4+IHdlIGhhdmUgZGlzY3Vzc2VkIG9uIHRoZSBw
cmV2aW91cyBwYXRjaCBzZXJpZXMuDQo+Pg0KPg0KPkdyZWF0ISBEbyB5b3UgaGF2ZSB0aGlzIHdv
cmsgc29tZXdoZXJlIGluIHB1YmxpYyBnaXQ/IElmIG5vdCBJIHdpbGwgdHJ5IHRvIA0KPnB1Ymxp
c2ggdGhpcyBicmFuY2ggc29tZXdoZXJlIHRvIG1ha2UgY29sbGFib3JhdGlvbiBlYXNpZXIuDQoN
Ck5vdCB5ZXQsIGJ1dCBzdXJlLCBwbGVhc2Ugc3RhcnQgdGhlIGJyYW5jaCBmb3IgY29sbGFib3Jh
dGlvbi4NCg0KVGhhbmtzLA0KQXJrYWRpdXN6DQo+DQo+PiBUaGFuayB5b3UhDQo+PiBBcmthZGl1
c3oNCj4+IA0KPj4+ICsNCj4+PiArCV9fRFBMTF9DTURfTUFYLA0KPj4+ICt9Ow0KPj4+ICsjZGVm
aW5lIERQTExfQ01EX01BWCAoX19EUExMX0NNRF9NQVggLSAxKQ0KPj4+ICsNCj4+PiArI2VuZGlm
IC8qIF9VQVBJX0xJTlVYX0RQTExfSCAqLw0KPj4+IC0tIA0KPj4+IDIuMjcuMA0KPj4+DQo+DQo=
