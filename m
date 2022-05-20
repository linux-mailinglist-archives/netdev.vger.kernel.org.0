Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4E652F235
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352452AbiETSMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352448AbiETSMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C173018C079
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653070366; x=1684606366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bL2B9MdeSRFCNXyOO8Ehu+z1rSDAGQ4qC2rlaXWawYk=;
  b=V2U7ZAn/wyxy7OefzH65kLKMBQJbrJwkgQHLQ7Y/kU8taTU/KLciZAh7
   Vj0CxQgjbUXEoj78HMIyfkJojUT4OR/Dz5IF1suzmuQ2LTJJasy7K3n/+
   H+22d4irww0KwwBVfDzlDMlOAX/zspDVZx6IHXQyZGDFEpD5gVk162LfU
   jJ+hA6W/QnWn1DfHR5zvQV3MVyJp4cWPrVfyWTvE7luszS82wy+6JWigt
   cPqNj4eu7qdUXc6OwyJ4jX179SLvY7AYNw4rHHrOAZfrzEoHeFPVgU8RA
   1ndF1rxgBwif8pA6et9GBFIO1LwvhpQqxO0vJB9G9zinPq3LLsA9l/3PU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="271512054"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="271512054"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:12:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="743613800"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 20 May 2022 11:12:46 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:12:45 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:12:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 20 May 2022 11:12:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 20 May 2022 11:12:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJhERizwfpfhmno/6HEktMKWf/yQfE4iR7RRe0xNjqwx5OfQe04TCOfc/iIz/RNwOPV02utNPUl6oQWG2TEExNHTwn+upn/qnRjyG3MhRcC7L179WemJIQqjPtDciY7xuSc/YJxqpXm8E1McxOsEOFY9vUBa9h9AT6rrCrAvtGBjy6QbeKTF1a7yAOMOaR3XVP98hGLCocThz+YbGVQFjyIGGcGIB5RPRhLuWvqPcANycnnMr1rJiUDNlTfJENZciLBoRH/Q0cAEE98hr1470TkmzWGnMnyYFj9ezWde3BK10tSg0B6PJI0eR4N5anmGbVMFdzvdNTCpHHPtjYym+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQnYt4iLun9kPdsk8KfCors/RvKvR6THR6p0dAiVCyw=;
 b=UHKiQkroUBpMdGbG+qyFoKEj2LQ4+lbLZMFs1g/YLGqsfIIAHmW1VWBeNAW34qRfUz6fm7ID1hixVDcWwwSremmw8jDCTQe4NPYulSIMWGnzD2Aou+ujSdha0tWfJ+12fW9BUqKs1VKFHZs/8GBsYtTFb88zRuEWzK7THyObpbCvhOSJIf0RGLKmuUB4fGbCUWRnTrjJfHkeCrSfTs7vvJlNAL6v5xdz4Mu6834Sk3y90PvKXmqPA/xoJMPgbcGUH7zNDisJjfnLTRv78vRAFNEmwpgAi2FiXLltsQbojajH2Qbasr507vVi+tJwiH/Y2Js+frLLtA2Fah8E48BRfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BN6PR1101MB2258.namprd11.prod.outlook.com (2603:10b6:405:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 18:12:43 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 18:12:43 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
Thread-Topic: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
Thread-Index: AQHYbA8OM/aGYjP29USMkevEfHFwv60nRqWAgADJ5LA=
Date:   Fri, 20 May 2022 18:12:43 +0000
Message-ID: <SJ0PR11MB5008190809F138650A2951C8D7D39@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220520060013.2309497-1-kuba@kernel.org>
 <20220519230353.420c7a46@kernel.org>
In-Reply-To: <20220519230353.420c7a46@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 969ca9ae-ac95-4258-8b06-08da3a8c55cf
x-ms-traffictypediagnostic: BN6PR1101MB2258:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB2258802ED9318992B420286DD7D39@BN6PR1101MB2258.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yXndwvhg3qvMv9RJ/Kb/sZD+HhmZBVHhpy2H39ru1nVdBC4Byd0dZsPGJvNzFcplmtaiZVrjWQZIxYvbcU+iGBSnB72/ca8BN77Op7wD3BzizXmCr4j4w8YUo6DxA1GpcX+3S1+jN4u8Rq6dOI6YAerHeMbIGQYYk2MQYdCuH1n+j4J0/4Wu8w1CmDoISxFOHkZRMRNPVwDdQJg7t7fdPOXGSVsLzvU0HJj0UtZTl7PYHUpWzaB/KpsIFgbRCBdhzx9Yk63gXnjrwNhpW/p0rmfQTIipEDV5QsKmEqMilxOM1Xnp9VD4KHlzjcAwliSkA8P7Epx7Ia6Tke6h9czNGNsTw5WD1xnhujQWYjLCr51j3dkYJbnPuOasRVBkx0JB8JMxJXkKpPxvtq1EqYM844cwbmuubs9cWsZSRENZ8aYHTo7jybPMqiN6bdCmCA2LHlW7ZcgPt1mY3z4CW6AiD9VKJc5T054zJHPPe0fSm3wzIXJ4EE/rAWkhSbysbM8pCQVbfuzY0cND9kt2KkBV0HsKs616I6zE220OnzxapTt9B/VhoFx11aXxKamm6ORKaAypx7i0PW1erzssIICqb96KUja/yDaLFXezPU78FFPf1NqRIlK/Ps2I8FPaHVjfqc0bGsMiHEWNhv8jmLVpBRPNVF4x4VVRqI74VjfXvo3yIhcXESNo2WiaGMtefeB7vVlqKKvC7RJjcnqYrUn5eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(83380400001)(508600001)(5660300002)(186003)(38100700002)(38070700005)(2906002)(55016003)(53546011)(122000001)(82960400001)(316002)(26005)(54906003)(52536014)(110136005)(66946007)(76116006)(6506007)(7696005)(71200400001)(8936002)(8676002)(66446008)(86362001)(4326008)(66556008)(66476007)(64756008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hYU4wkhGpD8EZM2OowOBlPnPwj7iIvvv8KFuykD2YTDTl/odIJzg7LZuP8K0?=
 =?us-ascii?Q?b648w4n45Zspkc6AhvQuPCN/t5OoW8HVGmF8vsh35sSf9XV53TSF8fitMntC?=
 =?us-ascii?Q?n4cmsgyQxASOsHbAvLUaQO1SYpIuzmXnYghmyU6Sl4Y3iOJ3Da6ubZSWGvcW?=
 =?us-ascii?Q?Y2UlDTl03asMws0d6zDvgz0e8IyEOlAkmC2R7/gU8p8pF1hZIqujQL/pZ/Qi?=
 =?us-ascii?Q?Hmn2BSeiN87i6YcTA/WZ47OyJAIhvxog4uZRtHJxgXOKn6VWNaKx+7vyVe8m?=
 =?us-ascii?Q?W+X5FXzzL9VGpR5c4l7pnchdWcJFNgtMD4icLT6ZmO1TNAU9l7eAZ9ePOrG9?=
 =?us-ascii?Q?Zlis34mTJbvs9a/mddpNJ6m+MaR3InUgch6ejSKb3GjVgQwOMx8rMRBTuGR8?=
 =?us-ascii?Q?d7x4nueWt6MO+PY9uu8d9mN1JfOj5CRUMIPFHc8q50EAt6oYTAc+th2fRbFU?=
 =?us-ascii?Q?oVP+s/HxztXYhi3i/S2AHITTq5fqS8S7ua3N+m5SeCXeTR6Zl6AA1UgEpTsI?=
 =?us-ascii?Q?HhmOgMZhAwom36hjIxvXUKSdrQQwmS27TQXdrqsu/ZwG3Hs4vWnQqF2pPrRa?=
 =?us-ascii?Q?f5CkKwRVYfQehQNSuiRoOf8A/+eIZANu3x+oFkIRJGNLNifRRc1FzHrg+NHs?=
 =?us-ascii?Q?i/CoFlqEeaIjdw9ngNDFOzYg90Lgw2FBN8z4vbHpXctPAJ6+DldRoWB0HVOP?=
 =?us-ascii?Q?ZgQlQjg3ubIS1BaXTKs6FNyHr222sPOKqcus0/XjXo36YIQ8XQ7+XJgHzNy3?=
 =?us-ascii?Q?fvJEiqe+5nhSZfkUo/Jn/pxWmkv1OVBxC2hefD0eN3IcQe9fTwXu2CISbHxy?=
 =?us-ascii?Q?Ianz9uwwfnuZKqvfDRy/doJnCDFwzgnU7/8/NxvMagV+3t/eubG91XojLA3x?=
 =?us-ascii?Q?IEN/pidQfaTlp9swUIEggqHZQcrngOet0EK6lDCSz1nNgz9Uob7y/3iEDI7k?=
 =?us-ascii?Q?SqibIs7/sEX9JO/g4OrJQPp6YHneAp8HuMWEzZV22o1ju028Grgfzm/ucUZ/?=
 =?us-ascii?Q?C2dVU3sQmtW9cOjJ62sY80pW3XhfGiXGdwUKIPL2V2KjGtyPEbAGCkT++JFB?=
 =?us-ascii?Q?muCmS7zZF1tcXuiEVi1WF2ufQ9eQ1xnp8jsNQnsL18omJ20umdGiV7n9FFDU?=
 =?us-ascii?Q?9AoY3Aj2i1T1XPTgGvBP7/gBsZgbhyVny7EcQ8uA3ZVSMpyxmLUgHFY8ZHkN?=
 =?us-ascii?Q?B3ndUUjhJ5FrFsmJUtFYNJI0mWLf6paSPfFKAN7xwcAUl2LlPk5trVdpdJWL?=
 =?us-ascii?Q?VZlPjUtltH/5n37KAyNKBFeaRXfNpGkHZNEQ9oRNphtiv+NVqwO/cXHOhTLA?=
 =?us-ascii?Q?vcFQ57esVaG2HSR9+DzSSuFabl7nIzbgZFbr+dhX7tTYP5OvgIVaNteDn6kq?=
 =?us-ascii?Q?OO2h4rP4X0l/7NaxS9Kt3H2Nd1V8NIk5iclakUYUbfVCyQJoG8ub0iF5/GY7?=
 =?us-ascii?Q?F0QiWWoTH5GkSiD9hjP4mPIRiH3pXOhmOa8hJMjoAc3ZdGoioGcG4D8dTOoE?=
 =?us-ascii?Q?C2U8ZbAy1AG3Ac2kn70QMY6/kRKBePi2q7ztQfB0htosk7xOP3xzTum13rHP?=
 =?us-ascii?Q?H3aHCykKwgJgbM9dS4KO6NVF2Xx21OogNnZRbK0FgkkwOuPZI+e6r0WtkAue?=
 =?us-ascii?Q?JIQtj824ZNTMx3LazUbv8tbIgBzvfuepZn8Y5/qVPlVkP0lLwS8O42U7m5/Q?=
 =?us-ascii?Q?fP8QAO4O5NVLhJwqCHdQcQf9rZKElyXeX2Fe6CwslLylpyHESKpqwkJICFLx?=
 =?us-ascii?Q?dZo1U7WqibQC6P3UQINxQfp3ZmjIZ04=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 969ca9ae-ac95-4258-8b06-08da3a8c55cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 18:12:43.5531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NIDzamcMgskzwvIQ5ULabfx1NiwlwVXch0mdOPkWjQ4p7Ue7Feoes5MEzCkTw6t7a/wzFBrSuj+TP6L3IHWGXEGJwXNvg+YLz892OgHr7aI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2258
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, May 20, 2022 11:34 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>; loic.poulain@linaro.org; ryazanov.s.a@gmail.com;
> johannes@sipsolutions.net
> Subject: Re: [PATCH net-next] wwan: iosm: use a flexible array rather tha=
n
> allocate short objects
>=20
> On Thu, 19 May 2022 23:00:13 -0700 Jakub Kicinski wrote:
> > GCC array-bounds warns that ipc_coredump_get_list() under-allocates
> > the size of struct iosm_cd_table *cd_table.
> >
> > This is avoidable - we just need a flexible array. Nothing calls
> > sizeof() on struct iosm_cd_list or anything that contains it.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>=20
> Coincidentally IDK if this:
>=20
> int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd)
>=20
> 	if (byte_read !=3D MAX_CD_LIST_SIZE)
> 		goto cd_init_fail;
>=20
> shouldn't set ret before jumping? Maybe set it to 0 if it's okay for it t=
o be zero
> to make that clear?

This is a redundant check we can remove it.
If the byte_read is less than MAX_CD_LIST_SIZE an error is returned as part=
 of previous ret
check.
