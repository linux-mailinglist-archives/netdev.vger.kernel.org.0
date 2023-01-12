Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B86667330
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjALNbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjALNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:31:30 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB81B08
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673530289; x=1705066289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FZpOzjYAJVFcM9tv58QpPjK0v2b3vyOrFNxJWr/kYjc=;
  b=oDfRSiS/26QbrVDdj+JkUYKgY4G0WhMevrWfpuNfJCpurund5uECo+C1
   uynrj9yh3Szle2AHsjQqxLPA1tLsRM3aleLnvH67sYPrhejl81A4kyTWK
   kDp6LO99WEA0a7IMo5zsMC70hwJ4r7hADPdVVkJmTmMrVeIBan53XnjHA
   H615MBJJh8Feya5tM8SnM+zEG8tH6plLkuWYyP6nnqO6keYbLxMZ1xpRA
   Ahu/qqMzX6cU9MtNM98CPLa7RMmmJqKnRreNk2R0xitE4MwLc5M/zXHNy
   xhNscjAahkhZFP3N8eJemI8GLzdnaRXCqK32ikCKPm7/oVQaASKHQfe67
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="324938930"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="324938930"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 05:31:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="607787884"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="607787884"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 12 Jan 2023 05:31:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 05:31:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 05:31:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 05:31:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 05:31:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNyXJc14/P/cHZTD6xdQw7tjacBi2LULQB980++0eGY7YdqxpbjNuOcMzrRsEq+Tm/2Jl7Al3UAuBkvw/LOdMMEEE9Fr07gSS86hQNL3CI+o4LATUjVA99yLstoY9MbVLmK9TJfIH+P+JFwjPCNCDRlpZvZNghxBDYpBEScDxn2ELF6yXaNLfECzjYGk/xVqGM4wLPDP1W0d4rJNhnBAvCM7vMI01KjRHPK4/xQLuPODtmNLbAAzFj4cC3l9gkXuzs98veinR6A0WzfwXZN50WkgGbuicmGCNAj3UFr/37affnj0VI98yvrLhEp9Qy7E7bDmm8NzXfZzqHge7zu3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqHByfvHJM31OQ5h8sjvuQGXjA6ZsCEXzeogfP85EXQ=;
 b=W9qpj3F0Fz6wG7xEZKUkN94vM00L5mwvLA/GE4IbyA/beT5u/jt9QfZ1FWKw/aNHgjoQiv/ycdlAY8Rnl8po2EDxqHP7/ANuBYgIO2CBrf/r92al46B9PgHpNCZm03F/S0BL6uCpvDyE0q7XKCnF6qdTNyVpO8ZDzAguwq+TectopmRGLfBOXfS97ALF8R1EgGpxXyJ66fULF3eoxp7WwwPA1sxUq4bYBvUb1QzLkqUaLaeJFxpIz3uPr/KC+ReCtD6qJAxCAOdDZnMp3nr/L5jP73b14apVqtZ5V+2ZRnTaAdyR9tzosguG8iGSOYJHNA8AqNdbdSG0PF7UtzYTdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5293.namprd11.prod.outlook.com (2603:10b6:5:390::20)
 by DM6PR11MB4612.namprd11.prod.outlook.com (2603:10b6:5:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 13:31:07 +0000
Received: from DM4PR11MB5293.namprd11.prod.outlook.com
 ([fe80::cdc9:cafb:fb21:8ce]) by DM4PR11MB5293.namprd11.prod.outlook.com
 ([fe80::cdc9:cafb:fb21:8ce%6]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 13:31:07 +0000
From:   "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Thread-Topic: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Thread-Index: AQHZIP6Giw6BFWb/QEuESGZt/Qoxe66QKbiAgAqnP0A=
Date:   Thu, 12 Jan 2023 13:31:06 +0000
Message-ID: <DM4PR11MB5293E8540016AA8AB2E139F587FD9@DM4PR11MB5293.namprd11.prod.outlook.com>
References: <20230105120518.29776-1-mateusz.palczewski@intel.com>
 <20230105104517.79cd83ed@kernel.org>
In-Reply-To: <20230105104517.79cd83ed@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5293:EE_|DM6PR11MB4612:EE_
x-ms-office365-filtering-correlation-id: cac5722a-ff2f-40f6-828c-08daf4a14283
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jSp86DSr6p3qX0vMNaruwEFZ35vN/psZg4uSXHV9Asd1+y0lzLnSF3j+ZHr9u51wQ47hnEDgR6JMe+9joJKxP5r6HbZJzQAi+v+kH8GxvMu8zl9kus7z5UfeOGpiCFz8Mv43a+xHHS/lAT5xwOSUFt0JRJ5eru2Dvhl3f+QPlAALXT2x72AaUgoX4sesQXnUhuPh9QpOq+CV8UAMtn3/x/x3DZnvJlgc/qSJACVCBLLF2ZVPd7BYvl/CZWtTxtmxJyk3WolOA5YGVxVHaZBDNF6amld8L9PPpjtCE23IMbqQt+dEHQKHnu1kfyVhgVwOBeeiYlm+nRhtiJBG5OHqcIaInrHRP9sFLm4Ix5ljk6p5eZsgjNVC/tf2mfDibYcCvP14vqIZJT63kftoUnRSNZYAMa2dlDMEsev98sRgF5NhtgKB4LgiMCZpG2eC0VDy6cKkblN/OxCwZ4F2+CB3YQmYACcJuyEE7gtdL5shjIyHPoklHytEc0XHmE3a3dVH14WWEhFgCwZDI0baLcS/3UBlY2qVbIXunHi5sNkV2VvjUhWtLlNUpFw+jwrPKxGHHYxQ8gMEfp47qnkcHvZr2qejdlmYiLuHl9o6k1KZCx90H78TK+S9TXY2RAkcu0IVUD5/QT7wol33HMywZjaiUOgQDHrdvmEzNAao8tmUG0q9oYM4dP4f7Gf7QgzzdSKgbaaOAtJt88FAoU6WrAQ1tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199015)(6506007)(2906002)(4326008)(5660300002)(52536014)(8936002)(122000001)(4744005)(6916009)(64756008)(8676002)(66446008)(9686003)(38100700002)(82960400001)(41300700001)(33656002)(38070700005)(478600001)(66556008)(66946007)(26005)(76116006)(186003)(7696005)(55016003)(66476007)(86362001)(71200400001)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B5HyTejcOEn5vSbXZPIEjBsUC/kEzBPK4YHLXglkyU9GIo5c8LFw/pqf8CzF?=
 =?us-ascii?Q?UzqcXH5/0vEgQWguNo1wZ+00s+S9HGtWiLRvG/KeYOUWpvtSZvARmTNyogUj?=
 =?us-ascii?Q?/watLsIOemBLXsKK06oe33z9qqQHMPUGRVimW88nLwz8PKwKtBWkj8o/DZg7?=
 =?us-ascii?Q?rBkFlLmzeTmCXiN5z7u3Pc7TX2m4axjRWjhsr7LZ75e+90vEHghtEbdrLx7h?=
 =?us-ascii?Q?eOn1ALmO2m2BUFS2r6esLpqJtuTclcQEbFxnkpPzNlS3Zqo5LgzHRDJ7uuxQ?=
 =?us-ascii?Q?9i9f/KYgpS1nyV4KNn8FbYwllURBvuajq47OAf8NqejRFZIYsi/xB9E3nS6s?=
 =?us-ascii?Q?kdg5lUV+BDNhRhwRu7Fexozwo/c7F/ozhVVYmGGDuXGPzP5l4YN4kYjNatXO?=
 =?us-ascii?Q?qyvz6Emfw/vBgespk4WA37Gk70I7i/nJ8rLPG97vW3gseCm+0IYM+5C3a+Fk?=
 =?us-ascii?Q?J5BDb4VHVVHtjVpDXSbykBAl5Oi5sbfOLvKBQ1YuY6ue01OyYMAxO1W9l1Eu?=
 =?us-ascii?Q?h8vOwwCH7Q786ab/Wi8gp0seZegETipmXFbUXkp8kz6RJT8prZGh7lMNoC49?=
 =?us-ascii?Q?/enL9wCEj86Ioi2m0lYrFeWSHKz1zSpKTietQYGceNPafx86+50ELsmlXPBa?=
 =?us-ascii?Q?FuQk+mRMOBIV1hES4x0WKkgddEIrzzC2U+Oo5KBSWBlfwgtKCHc/G/Y7tKpf?=
 =?us-ascii?Q?ffHNsUs8jVbt7lsCiJ0WP38At7E3Qz6otfgfiJ0apAkGw/7VPU96/Vt9scBD?=
 =?us-ascii?Q?droHKPIjfeOGgBKhUo93tJ8Dl6RIpxB8Ww/x2pwsS72WGIAb7go16ZrXLYZw?=
 =?us-ascii?Q?RzDVljAwVRh0Jz4Em5eiijIvff5Rskraf61hpKGP1ehZV7burrTQDC94S8iB?=
 =?us-ascii?Q?vsKFDguMcKBYcqK8YGmkLRrect/noydk1UFaSWKB0xGu1QZaR3LbCl8+mCy6?=
 =?us-ascii?Q?u+KigZxXNbpf52wDhq7nRxijl7GRsqhfMebGjzZfE0hFOPoMvfAdvGG3/ua6?=
 =?us-ascii?Q?2ZYp9/hb3Y2lTfaGd6Oi9lNOGFL0Gcwp7ByBbSl4AmvlG6FW+QcWneKhE0Ir?=
 =?us-ascii?Q?jYU40VJ0snkasB31jVhgm1opmyIgZCT3LnTQhuh2lOERl6BrWvGXjd1iEdf0?=
 =?us-ascii?Q?2gJSP0GXcn9qHUlOPfnwv27vxBwCy/0jqkSzX27zPhBy37vGesjm7dZoul2d?=
 =?us-ascii?Q?KzRLQn37IdVp71HaSFpd29k3w70FePs/SwBJVkod3m7hOTXUGRQsRoUqnVDj?=
 =?us-ascii?Q?qjHMVODOWOsw4/CG0U/OKsrm/WcgSBcWj5haQpQMHAbkMXUZZSput6sIxHaQ?=
 =?us-ascii?Q?tUH4ChNs7yPA5bLoY/pnyL9Rbhq78tQ9EI3K90nad+HS/gFA77LGwKbxLGCJ?=
 =?us-ascii?Q?zIFdBbgH7xlIZ/UJEqILzUjMMOKIKFXmzdsi32UB+Gsr4Gfzl8v9PFa8WRbH?=
 =?us-ascii?Q?9EplZHbne0yK5FHUHAgAEIYIGpIyXhnRgXoIHjZiegWqAvCizmEAquAO8unz?=
 =?us-ascii?Q?ZFbsdRZcDys0wLcFYKPvgXY1oVuH7hYph5VgvQr1D2z/S6cWII2AUZKnHDs+?=
 =?us-ascii?Q?ZuRJQQPSHSOBDY78gb9IMVIe1V1DapfZ8L5aFlThMyCbMop6xPKJlxJrg6wU?=
 =?us-ascii?Q?hA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac5722a-ff2f-40f6-828c-08daf4a14283
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 13:31:06.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHyzHceibUz1U2ZZyFO/duA+h+0WFgCGMft5yOKpp9m8AjA/0hDcY4hQrSFSwZMeu84oep178mGhGHbSW8QEfedEDeHLIlzPcUbY/ftpZ0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4612
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Sorry for late response
>
>
>>  		ret =3D ice_vsi_alloc_q_vectors(vsi);
>> -		if (ret)
>> -			goto err_rings;
>> +		if (ret){
>> +			ice_vsi_clear_rings(vsi);
>> +			goto err_reset;
>> +		}
>> =20
>>  		ret =3D ice_vsi_setup_vector_base(vsi);
>>  		if (ret)
>
>Why do cases which jump to err_vectors no need any changes?
During my testing I saw no issues with cases when goto err_vectors were use=
d. Did You manage to have other results?=20
>

Regards,
Mateusz=20
