Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F03693FF7
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjBMIt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMIt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:49:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D444ED2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 00:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676278196; x=1707814196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MwIHjikJ7EsqDDJivCXrVMHsdR17pBokxXmwjrYaze4=;
  b=J+BHfIBvzCBQsXb1OvLQ4IQ8Lc6huEgika9r9/LKwu9qsRbYUAX6h4qq
   E+6pd1XTeS3vrnpKQBhsrJV4DjdlnOhZe1u4jWN/g1hjf7YG0LjEWdsqM
   ziEyMUtmarR0tnsC9YhnjdkKprr+qoyrl7sj7Gk7GdjS830ACtqu9+NdI
   S9jP8d8hVAptB9Inj5IHJHr6oSmXI2z1kUVC+jvj+fprcuTKITDR5ahJl
   0KdVOKqiiiIqoZgWZ7QLufNiwZ20LrW+xpdDWXKHduhJ/VCQnUzUSVh3b
   gTh19M+EYGX9T178DzDKyJ7BqNKJKzdkKRORvI/fMp1zqmMI11eXI9hEV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="395455904"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="395455904"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 00:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="670743062"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="670743062"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 13 Feb 2023 00:49:55 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 00:49:55 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 00:49:54 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 00:49:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 00:49:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlkYvXU9UhWwX7ZZhsukJZ5HG3utvu7Epwyd7m2hKgmcQNsljrTwmFURnuswyX5r/UAWht3A45dFd1wKe3tBwtM5nE150i7QWAdoA/+0zVxW6sxDXraFUL979MzMM+1Ga+4qWkSHW0aoxUM/oFwJODyG313hahepj93bDHcRL7YQkVOyzILZiMAWS1TCWE2Ns3VCukDq2kkSYJHxklkQBfzYwcByQQQagAndhCH14q1qyoJ82iCoMIyFvKohvmn5BFiYB/qUKcY+4+QRNupLKTgh9wvEsJmPvhcS4KpziDo+jpwA5hmrkhdKKmSW3/2Jd+oh4pP0Nc/OAkz6LShhLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihmOiIwBuhDn093nQfk0wn3s6ccqRpWp37LNUp+VhBU=;
 b=cBWUnaZqiIrKllaECEjcXjb8pRUvr+MXwmaRAUtTTKlHshbM6mLNP16J5XQ+uKnfaMWXZoNqSsu/NzrE/1at1qeueCx0Z6QK6zJ71p9I9xsmPm8DIPpAOBnlZlxts7Ooxo5f+cwzFp2hMtEDPHqgXCe+YHKdAbLkEvzS3VCpjgug81HkAt5BaznQ/BjYm45VWWHNP7FiwARkGIIS1RJDqCOkw5KiJky0RNEWlb4uNtBNNeq+/DTrkeu7L77iG9tbj/XmbPW/0yzzGIStcl8KRx5gc46dRIKhUJOy1v8inizYm1q8vxXos5SIOGyaNiyYHIVXRQbE0ItPOH4gRUkCcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 08:49:47 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 08:49:47 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH 1/1] ice: add support BIG TCP on IPv6
Thread-Topic: [Intel-wired-lan] [PATCH 1/1] ice: add support BIG TCP on IPv6
Thread-Index: AQHZOkTGDcAWG0TWRkiwevAPnyfHT67Mm5CA
Date:   Mon, 13 Feb 2023 08:49:46 +0000
Message-ID: <BYAPR11MB3367D57C52DF680DF68545BAFCDD9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
In-Reply-To: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|SA0PR11MB4528:EE_
x-ms-office365-filtering-correlation-id: 2165032a-5701-4139-a054-08db0d9f4276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCsiBKeWBgc1CB+gCylN5+SR8viLuLWW/ishFbRFzLK8f3xneMNGjbcEGokvVpscl5XjC9tUEVPNmG1UPuCmv6DzeaJ2fR2iqzLTcViEy0iisvq1aQ87WzB6YlVJE09AA8/U7g10TkV8FcOSAS4OmgY1y4KL47TdCE1QvTkvqs79+eWYyU8y+Hz3Ooup1o7mh9/4JupcezaetgtwEiXN97Uem7ROdegAgtGg/ST1sNJkPdWzJ2VLCqQbLjCjFRqqJwATxRSoD8pR/+OrB1pNGbwwA7bSCZM73m8f3XW6zUG9zd4VStcAl/rBU4+o1iVWt0MRCswR7+/lXOd8SWxj2LNapdLy4aJ9kcmtw+If/gq5X/AfNbnjEx5zd08z7sNRlLNjxaO3AS52G8KllnciTBALZOp6fnmz0jhZgKC21x3Vd6Y/lP+FJfUvvtRCzFa3W9S/xk8hP8Icdwu6nXaf3uGw5KTdefUYHjf2FGIobovRoYb3AjVz6yhH1ThfZGVDS4KqSAe4VehFQEvyheDrF3l00TudXpk/jNwYXoLPcDQTenv+U5s+4K6tjgd7mu0KuAA5yI2Xm36YU1At2Xd8aHbg/T6wkBxlCTSr6nRXtS9tHHXACa2i1TO4SJGeovUiM9szL+OZklbJlMmBnZAXjUUyheEr/oGqeiVFJFZaXlgBjV0/me8+RYgr39o4+CXLhgRBitoMowL6tZJm6M55PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199018)(38100700002)(33656002)(82960400001)(86362001)(38070700005)(55016003)(122000001)(64756008)(52536014)(4326008)(76116006)(66556008)(66476007)(66446008)(66946007)(110136005)(41300700001)(8676002)(316002)(8936002)(4744005)(2906002)(5660300002)(83380400001)(71200400001)(53546011)(26005)(6506007)(9686003)(7696005)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9xnvkO3mZiUrvn5qmZL2kg0mSjd+Zc1DpilQxsDb8h26motbg+tAIeOUvTML?=
 =?us-ascii?Q?5ETFl4OcQknxDlGEvfGxaAgstTLny9T7NeFcV4IO+xEXa849Tk9IbjF8FQnV?=
 =?us-ascii?Q?3UvKDnobu1g+o1NDtxXy0BjzBLCuvHXxYG6gVMgrcC7du2BPOfpbNsHuj+2A?=
 =?us-ascii?Q?PYR51ty7pOQNFEZ37uCNS6GJ2HurGHJU65DnV3DglonEtUoYHvsebDO6+5Rd?=
 =?us-ascii?Q?ENBH0Jd7t1sfYbiWLlQ+/z9G3on4aKsv+1C7vbIXtALJ6ADhcEhA96BD7PEC?=
 =?us-ascii?Q?yvxZNT+UUZYZk/JmoMU+edldvVCH+kT9DMu6MKzN34HWhMHPPWSOyTJqous0?=
 =?us-ascii?Q?1O0WXuBmmRp5E9s/hA1gGrUpDHXaqe4nabWbPCEhsnDERH4F73LCRPNEMvFc?=
 =?us-ascii?Q?RV988sPk45Logwz+jaO3LSxUJ9fVa9YMcilvZREB4i9HoUn3O5R2uVi/2MOt?=
 =?us-ascii?Q?j5QmXpywW8ohyUP7w7aCKv/ssqdnR1cERr5b+eBEyJVygtaF+cQd4NnPU7hq?=
 =?us-ascii?Q?vMTICM8bsrSqCAsgchdQ+YQQIkGt4YmfGF7ZA6R/yX7iW8GzemvGUnvUvLGW?=
 =?us-ascii?Q?ibnET2T9ljGqJ/hqJ/0bCi1iXXTT5u6WRke+JRsbCcCMHRWjnNde53ikdB5G?=
 =?us-ascii?Q?s8kqkVoajBqfeFNHKPBd/ugTaSbzBt1FigqOyB8EbIOgJZqgKzKdPymieBnV?=
 =?us-ascii?Q?x5I3O1QsKbh9zi78CLHqXIbacv+XEF4uhtonAd6dqSjK7TTUF5LCkYYy6zq3?=
 =?us-ascii?Q?rSYi4DuMtkolZY73bukKasayzCYPnk+BTxQWwtmKqYACV5PmO2kGTEOHN1/h?=
 =?us-ascii?Q?/S353kd6cWh7HBJ1/kZypVjoMFeF1UoG0+OENo9ak9BjCpUcCcMC9IZBLivq?=
 =?us-ascii?Q?yxyYpFlCWhgagCAcNzHRLJEotHaOJXKVDI/FqB8ux8bZdR9QRWxJRLuvVmag?=
 =?us-ascii?Q?RG7cDcK0Vp0cnkPKOCGbFVJJj90yg7/nZeT9EZ7OvvLSrhdM+Zyve5EcWB++?=
 =?us-ascii?Q?Lvd1BxVsghPxkIdl80WSM5T36dYu8yYPFZihOPfjm3eRkWcqxhhtilTSOVA2?=
 =?us-ascii?Q?LaRhgHpO6TvGUG+yf3mzAnQHAIB0Q/6fDYa6vKTVWhqAby7GmXXhv7t9u9DY?=
 =?us-ascii?Q?XWd8UtRIlIc8wqg2/YZCMSP9phBiH31R2s+IMjmXNfTQlVy56oN9eQYCeUFK?=
 =?us-ascii?Q?BDDGewDNuxyaqHHDhJ3U4Kxv2sOpiOyfEgFzXpndkAzbx2JerWzmgU9b9M9k?=
 =?us-ascii?Q?LB8QSXAvoj4AMGufyTk+CseMAk1bS8nqHfu9xzvhs4JwSPxSdio47YZlUWl9?=
 =?us-ascii?Q?cxbOikJyI5Sy8bZTWnlWzwUck11vFAvkxE8YVB9Czli8gaZydUtq2omkYqMR?=
 =?us-ascii?Q?htTpvMCSQjx/F9JaX+62wVgxLu8JjttTmJtli6MUX4bdoC0XMzKAAAs3Zl57?=
 =?us-ascii?Q?cw6LddnlSMZ6lR0BZ6fFymogVACcXjkt5NC5TxJ1pbZlCIA2NmX4EUY1sedP?=
 =?us-ascii?Q?kCHcheNUEzp77wxf9uWmsn9I/yV/4SafpEkp7K2nDWYZ4tjm5OH4T/nf855x?=
 =?us-ascii?Q?r5iL3Hor/SH+B5HyxWcgfsfvceD50aPJeVCLFj5l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2165032a-5701-4139-a054-08db0d9f4276
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 08:49:46.8776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mb0bYgtwL/xz5C1d6vU7jk8Vpr5Cq3trF0rVEM2OMMEgS615IjAB1gifJhPoFVrRseVx5tdO4TkBn0m+BLbjUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pawel Chmielewski
> Sent: Monday, February 6, 2023 9:29 PM
> To: netdev@vger.kernel.org
> Cc: intel-wired-lan@osuosl.org
> Subject: [Intel-wired-lan] [PATCH 1/1] ice: add support BIG TCP on IPv6
>=20
> This change enables sending BIG TCP packets on IPv6 in the ice driver usi=
ng
> generic ipv6_hopopt_jumbo_remove helper for stripping HBH header.
>=20
> Tested:
> netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O
> MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
>=20
> Results varied from one setup to another, but in every case we got lower
> latencies and increased transactions rate.
>=20
> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      | 2 ++
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
> drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
>  3 files changed, 7 insertions(+)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
