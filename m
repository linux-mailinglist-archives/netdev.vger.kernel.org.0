Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73E5492A2
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351496AbiFMMbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357106AbiFMM25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:28:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD9B59974
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655118381; x=1686654381;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eDhbNhoyGTGAxHozsX7bS4BdfANurxu77jZKfjw2yIw=;
  b=WRrg2RMg0dC1Sc4so5fXs8oGIDx1YtQ4jTgnnQjhJDvH85JBTXE3L4ra
   LHj2KJ7cB6S845i7D7oLOW8PpFGdaB/KxqIHz9MFirNOduVwSV/ysIXNf
   2f+Tv32a2SPhpA5byqe1eOGmnOXzleEUOokgqsOtnhE4J4sYdO+7+CWZO
   G7ERjqhsJFuzrBT3+hIPNY3yIu2ujWmkXwri2vH0dJ6AhYV0kSsqTaN9r
   35e93o4CRFcJWTz5zNtek6M895uW5J64vfjcRv/WX/SGFexx6/e30aWCd
   s2tnvB11h2CYUTtUHezVLKHXkY6bc5yvEHaZja1houGT7nR56WQmcm+o8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="261282929"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="261282929"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 04:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="651365541"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2022 04:06:17 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 04:06:17 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 04:06:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 04:06:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 04:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nox4Y855ChRqJdTD9vnQ4SFlBsLWXQxwukFqNGadgy3AwONLt0kub77eLnC0w99HdyA/QezqQAGdyaBS24ZbGCwW1rRU2e9Hsi0V04nPTblMS9J8kxob04+gXQbPeM7Uvj1PcDBRrBYfpm5voeQX0C1wlugFx2TpqsYjRxBmii4xpUZ99Otx5y/0ugK1ivbOCjzS202yaMeVcHveTKlJQmsIv1rQM6aNI8o2oluy9to3b6Tbxtk4LrTKGo8esfOtG+2qorxb6/ls+XVthYtSchQBWRW8kXieeQ3mEMkvL+nz3g3HZxT6sJAMBOCC5+YrK4E7B71nv/tKDRfaudIyNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PNJ9Wo9VskCqSgJQu5jl7IhaQw1fdunnYxi6GytLeA=;
 b=PXtTsIU2650AIR1xcq41ApaCswP/sgRjlM3fZ80lUjlbb8rxCmjaA52GZEkTqaFURNSBFnPjkv/Uo4Wi4RzMVM5x2YDFLbG2ycN1zRnH0PaUiQQnRfCHCg4A1Zmj31/390A/81HmjElZlGq0RSDTaTKjRqC/Ws3jo4FHsYqy2wDJH6ViLcXjV8fhPCoZvDBqm5LfkGhoVAHFYrbyYGlRSpfO7zAaRzy7uSZH0kgoJQX6YKrpKE0jfsCsdelBe/ReG6dLvTk9IMB7mmQdAc/PCA+UIY2oPLwXFR9ZL4xH7R+0Pj22hMUtS/h0bxJfnQvtqMSVMU8j7uX4Tpl6n8sEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB2733.namprd11.prod.outlook.com (2603:10b6:805:58::22)
 by SA1PR11MB5828.namprd11.prod.outlook.com (2603:10b6:806:237::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Mon, 13 Jun
 2022 11:06:14 +0000
Received: from SN6PR11MB2733.namprd11.prod.outlook.com
 ([fe80::6d6c:33b5:6380:ac81]) by SN6PR11MB2733.namprd11.prod.outlook.com
 ([fe80::6d6c:33b5:6380:ac81%4]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 11:06:14 +0000
From:   "Jagielski, Jedrzej" <jedrzej.jagielski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Szczurek, GrzegorzX" <grzegorzx.szczurek@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
Subject: RE: [PATCH net 1/4] i40e: Fix adding ADQ filter to TC0
Thread-Topic: [PATCH net 1/4] i40e: Fix adding ADQ filter to TC0
Thread-Index: AQHYfB4bneDaJd6bzkW7fiW/dVTxjq1JqnUAgAOIYeA=
Date:   Mon, 13 Jun 2022 11:06:14 +0000
Message-ID: <SN6PR11MB27339A3590111CEF08641BFEF0AB9@SN6PR11MB2733.namprd11.prod.outlook.com>
References: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
        <20220609162620.2619258-2-anthony.l.nguyen@intel.com>
 <20220610220854.52e5ca44@kernel.org>
In-Reply-To: <20220610220854.52e5ca44@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e212d58-28bb-47b7-df38-08da4d2cbb9f
x-ms-traffictypediagnostic: SA1PR11MB5828:EE_
x-microsoft-antispam-prvs: <SA1PR11MB5828B4BAB28120224F915958F0AB9@SA1PR11MB5828.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HqQ35fbKwN4FzSMjgM1VSYJCSVdEgNESuRnmfkHb6gtuji/HGsen6fq/ew9A92sHfFF+tcHTp8SuiCj3ddJoxeE+5Tnl78P0key1uqSwJQhbZQcE4VCh0b542hPyX1Dr9yGtWh1EI1zpHxcAPU/2CL1K4uV08MiVjEBZSChZOWTE29pOl5j3d8aWGnTLBBiWbC2Yhonlt/SJL9gfx0BnbPukkp9UuUBOll5iDoBNckra2HcCqnx+Uq6BY9RhiVTFUG5AJdCyAvsUfw/rKuTZSqwFdkr5SCq8YAlRwCNwuNR8YJTeMEu6uZ/HAG+DvQMevPX2GJfk07guhLUVy8VP3UIdHQQYvdjDg8ufI97Ou9DdetM0FNHrka2bLRmqUpEwkQxBrAoQrMUps8Kj8Xv3vFqd6WrF7nGj6R3cy8Z08Xc06NHrvEdC7aY30o0muyDIgwTleZrjfDaAFyxtxh7ORU6V4BiGTQv50z0lCiv/GQgdZYUt7KNUPWOjuLEtbW9XgiXS/T8mkjHNNP/HF6HYZG9+1g54sKJ6UUBX9owPa9GEUguIpuIrFpXwyXgbqlrgpk9q3AEUxmzLSKJwh87/kE8qroZ+8p7cAZc0nFyfNuOG/NtWtmsCn+3Gy+lYKBGr5gb/3LUw/ErO8eRDFcywvwsMHRWtK+BdvUR798l/HgnThQP/4c7DX/7RCSph8QZSqSosGjXF0CPXc0XCXbqSKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(76116006)(38070700005)(52536014)(55016003)(8676002)(38100700002)(6636002)(64756008)(66556008)(4326008)(316002)(66446008)(66946007)(66476007)(6506007)(110136005)(86362001)(2906002)(71200400001)(7696005)(4744005)(54906003)(26005)(107886003)(9686003)(8936002)(5660300002)(186003)(33656002)(122000001)(508600001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yO66wOGZ8zUsHY4Jy6DgU41BcVM6qwTzOwxS5DumghNtN4wweHZJAsb6Aef3?=
 =?us-ascii?Q?AakUkTW5cTYa79aMjT/jHvUIaYVdaUd0fiHioz2+GVEnYBTKJU0Q3qGNOVK5?=
 =?us-ascii?Q?tLzAs3KwGKkTt9HPbAkqcQ4uEH4+UezfkTXlgvfh8PCsrlZ0FSWAWaHR74Yx?=
 =?us-ascii?Q?DgINd9IY1+FDwkUYzH/16XwlZOhcyJcqnKeMAXtwCtR2bSgzqoHDxbXDbq1c?=
 =?us-ascii?Q?ER/RYr8EsIyhFKolOqlj6lYoYLSWKmbEZxwPtV8tUqmyyy24UsksNvNqSpGu?=
 =?us-ascii?Q?QdVC+htLN46He6XijAEEWZaJqD00ZTV0xkLfQ2EVHZKlVffin43HPLtJyECe?=
 =?us-ascii?Q?VP+nKjIkK1ae53fSbcWfBTRbyNXqMhxDgNP2D5g9aZObaH03p179gEf5W5/H?=
 =?us-ascii?Q?7RpPFfink/5mGLfNRY3BTWaZ8CQEXpQbklICl6Em0Do+/3BbWqQr1Q834pAb?=
 =?us-ascii?Q?WeSl2l2wLIEAjDtGZoEHQ4AQTmvCPUdvGb9zfqEk6vuxBprBkhv/B4gdWYml?=
 =?us-ascii?Q?COKFW+r1ExyVyOoRDOWCqmFQ2WIy91q3gPjPKxpt5BKEstZneUz6OYG8oI8G?=
 =?us-ascii?Q?IiJl3DL86rmHHKjKhhFFmtQL9M7gFIUSoROEbHUoady+CxTDwUYlaYHgbTJk?=
 =?us-ascii?Q?KHlY5zf4EUFR8/nguPRm6Jb1+GpS8NEp760oCzb/7RpuKeoE8RseuxejwBVZ?=
 =?us-ascii?Q?WxTdn3wOO6lkXFS8jEiQE1LR1f+0QqqG7kZAN+OzM792gvv7gOS6iORXTZ4X?=
 =?us-ascii?Q?+gReVbc9XDSvQTbCGrPg8se/FtERR6nxkaW8fe47Qcfc2XQDLapriYELWizc?=
 =?us-ascii?Q?VM43uTqiQPBzvSYyMVQSc7x0lj1BvN8AXotXwWBaGQO+gRbTJa9J1Djq9gRP?=
 =?us-ascii?Q?K467eOehVEtGLYFU4sxxOI/PiKQLFFUZxrX3P/uTUNQy5I6e1pHNbiG1uiuj?=
 =?us-ascii?Q?j3odhnT9doxBN1vHTzF9O5pwchcA1yq1a8Lpus2CB9mUvDarcIZFjzuNLem1?=
 =?us-ascii?Q?0Tda06W0cKryLnQ2Vz4zuDJJmuz1gg7Rz2LIGCddv101c+WMDXPq6rfp2hBT?=
 =?us-ascii?Q?cjDCqeoKuUCCNUe8A3NXNlnL53H9acFQ0UJzkow76r879SL+tZbi3zazRBab?=
 =?us-ascii?Q?ogkz75+1qPgSrEJAzSNMGZ5Xsx/ax8Vt08F2McT4fXX9Y05DOUD0hXCWkC86?=
 =?us-ascii?Q?j4YXrZDNUmnC7cxfk8a3151bOmc9vhIFA6FEonKoYrB1h/D1o3SXFUluJknf?=
 =?us-ascii?Q?ZQ79/uPk62zOuGWS8lEaLZXBShukNGfiFg/T1QqjPDiODFR0Eh9BQCv+KthW?=
 =?us-ascii?Q?xFuFK3kP1VNAKg9seYWs9Eh3kvJgv6+ViDPjhX+Wb7FPx8txJXy1yXJASbkx?=
 =?us-ascii?Q?MYw5SwQXF6ndV3ITDthZiMj8RRahr+KibdmbkUIsSte54pU0cHdKzaCiZLrQ?=
 =?us-ascii?Q?2wny4XOZlxOJKPnLfumZyU5bHc8/apJhnw1AoChBFLbFEr4GPt25Pko4Mvcz?=
 =?us-ascii?Q?bs/3sBwrx3Vvc47tUOQQweWcYP3Xced8MTzj1sVrg6r1idDuxRejPSl5zefB?=
 =?us-ascii?Q?9fcsjjNkiN77Lums512gjqvSsYZz7VCpmp8R1oHcrTvBsySKR1fw9u1U3g9i?=
 =?us-ascii?Q?J2SHuFRRr0KMpLid72p6x0/6sqOsCV1K5QHdhirjp+qCvd+Eeyjws/FKa3Ig?=
 =?us-ascii?Q?tkmOkv7xi7vAMuO5h0y4T4UHAJuqz4MbacnGCqHbLc486Xw+LnworDRAR1GO?=
 =?us-ascii?Q?WPdtf/aws7jVqW8BOefnJKOTjKkLKbM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e212d58-28bb-47b7-df38-08da4d2cbb9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 11:06:14.7906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vfxO6h1itVQJ0om5VLg9pmyZi4N+MwLgnKOEOjsvjCVlam7OgJoodph5GtNiNAkj/km6hj6CBcJAkk3EIC0etQajZLl8yjsFGzKDlHZrss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5828
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Thu,  9 Jun 2022 09:26:17 -0700 Tony Nguyen wrote:
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -8542,6 +8542,11 @@ static int i40e_configure_clsflower(struct i40e_v=
si *vsi,
>>  		return -EOPNOTSUPP;
>>  	}
>> =20
>> +	if (!tc) {
>> +		dev_err(&pf->pdev->dev, "Unable to add filter because of invalid dest=
ination");
>> +		return -EINVAL;
>> +	}
>
>extacks please ?

Do you mean that the trace should be more informative?

TC0 is a default queue so any filtering rule shouldn't be applied into it.

Thanks,
Jedrzej
