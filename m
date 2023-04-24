Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0489B6EC666
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDXGlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDXGlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:41:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2733F26A3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682318475; x=1713854475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uE+60gVdPHj9xAimGpnV9YjyqBPTjvjSyNPIu8TU6KE=;
  b=mh49XTW0gvMmJmUKE4l+WeBq+wkznsaGTHhQb5nkMhUadP7sBupuU7jx
   OJBeSAFwfkPduXvnfEXxcuvQGNR/4YhNbYFsW8/0t183jpopRAWndMHp9
   LTwCB8uq2DfB2T+G03Z/81gUclJ1iCQngRqahVvxWWCZXHFwahYXpWsZq
   Mt1TJfuWDD0xiOXqHvA4Wj9EN+BIPqnDzk7CU1zE2Ve6+CN4aiIq0szqW
   FcZ9P+1yCP/FsIMP0v4LqQCmf5cEuk8EVCRsnr+PS6hk1tNDhq12ddIhg
   TV/jO2SqnLZ1wKTLMWEe7ktM5FpbGLV7Tf5besS82cC1cBpHfqjF+5GE2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="346399887"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="346399887"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:41:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="1022591775"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="1022591775"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 23 Apr 2023 23:41:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:41:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:41:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:41:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:41:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSrEj0VS+ok4AcYSJ5n5Nhd+587JRCZAjWektuSDVhni7b0Us1iIdtd3j02RhZ0ZgW82sT4KYbw9fzRfD8ZeUA68CDNbz9GcSht3LGfIzlukqGJ3Run9LytN8YnTYiQaa1Mp59QhOOGpXE0S0mgpVMJBJhFrCsmhTD5mfK7UM4JkS7HX3DtHX6gcfmOccXc7wiJAIXufpdc4qEWh8DR1YEtjHzh9L5re0bM0tduDR7Df/EG9yS5kkXQ23WGyidxgzEmx0bN5kjPE4WL6lXJr3ks5YoHExyVx5mjxIEA9CAN8XpLBYR4yLZyUDyzYCGMqcxZXAxSzI3PM7YNY88sL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkM9JFHJpQJyvZas/+qanCvrrhjd8F2LxpU8t1NEjLA=;
 b=UKfC5EEVM11164VhYBFfk7gHUYa+WmdfhQzovyuLChXiJv585PWTBQ4zWLOcTwkEeKPjBmxQHox0mXN4Cfz+rPl+MAKWZr28VeSQk8GWjqEqHoNjIpuYA3PwleDZmpajuMd/z46SfqIiIz6AanaMMYHiJXog3Hw+s7uu9WIJZXL/ogypyRvjUyMNX2KsMCEEOosZtibJS1QyEDflr0cjJ1Rc7kD2I9aCzTA/tsqxZ3dFDT6IhdHAVv60tV7AW1Ri+AlhBrv7eY1d1hdEX2MeW/p2km7M54/yldoNTBY1lXxt0haDRkkx/7GfKa4PcmL/gaUC28xJAOmrxDKUCYz8MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by SN7PR11MB7512.namprd11.prod.outlook.com (2603:10b6:806:345::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 06:40:55 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c%2]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:40:55 +0000
From:   "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v4 2/5] ice: remove redundant
 Rx field from rule info
Thread-Topic: [Intel-wired-lan] [PATCH net-next v4 2/5] ice: remove redundant
 Rx field from rule info
Thread-Index: AQHZaXQAsjyA4CT0sEq6WHfGV68I6q86HF9w
Date:   Mon, 24 Apr 2023 06:40:55 +0000
Message-ID: <PH0PR11MB5013D87A5D3292DB8932C11B96679@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-3-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230407165219.2737504-3-michal.swiatkowski@linux.intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|SN7PR11MB7512:EE_
x-ms-office365-filtering-correlation-id: ba59a49d-07ab-4dd6-0133-08db448edb30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n213hiG6wUDNJqT0qFtaxeUBJYY8Sbn4qv7RjDfbsPoHX+OUQ1p76hieo536mlatewuEaUrtavu3qwqd9YcVrzcUZCbTjX/VXiQTx9f51IqzXXiqN01CB7lERLJ9MxZLkM5i+vUB+e5bYg36VTGb+uXNIJsQtgc2sKA5IgL/iRgGNoa6pyRjpX91BdbOaQ3lJXHt0wrcc9WvQaMSldh7I+D0TQ9ZnYjmZm1vqLuuSjn5vJA91p9skfMZ3lajeAa1+C+5fvtReY3HzEoVnQ6hZIm6I1RBFkhIMk8NiUYZUUgWq4/Nxqbhzoi67JM8Y8eVzYuv4gPIcnYbtHuxNBgHbqYSBIHRTs8yAzEiI6iBuSt2Baw46dMnZfFBL807Sz2b/lZG6QFjlVaInCXCnTe5DKUAe+vTw8FKwXZRydc2rIB19LBW+zJfRfLz0NS4BwTCspsdSK8Gxh8eVHJqYy1/QUmoeRI7nl0GJH2MgjVVS2oEOezv+yQ6OrQ1WebjM66hozAJ9cBORoZo655oQmSK8Mh5NnfDCPsMCDe9i5GDbz6JKjoi9VN1umfKovbP5pLA7vehx1vJSt0jnt9GwhOHSQNEdtU2HGQmJRrTdlXNn+RuTW8SLHHSd5MXNBDlVrdE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(316002)(4326008)(52536014)(8676002)(8936002)(5660300002)(38070700005)(41300700001)(33656002)(86362001)(55016003)(9686003)(26005)(186003)(122000001)(71200400001)(53546011)(38100700002)(478600001)(7696005)(83380400001)(6506007)(110136005)(82960400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bSAzDX9ARyLbc+qAyqdOrYq4gfe7S13tYKv5JU1L9c33MIrwZ3timKa7Acpp?=
 =?us-ascii?Q?xgN8/SzQECHEOvv0m3r1rfIAbXTHzIeHvrXicLAkpDolBR9eQ09K2En1K04U?=
 =?us-ascii?Q?gL3yGNICb4urGfn9q5eiT8hEBVgYXdV7p+v5SvV2nTdZEVQLB5U0gwSkd/MV?=
 =?us-ascii?Q?HocAhFmz9uPLXMrQNBNFrb9gE/fuCOraiJNNI+T0xbAZtOS2eIfwSB/oRrl9?=
 =?us-ascii?Q?UH5wLU2ZgfB+kn0aJa5vfVgQ9buS1FmZrFo1LU+7QHveWxOXv0majauneKGZ?=
 =?us-ascii?Q?VVcucBRljFmvTJNRrfwx/xDbAt4AvgYPG+Dpdb+zlLpyEp3hxtJ/5ZZYTheo?=
 =?us-ascii?Q?8D3kV1CZ6vZwHegUZUXkb8Oa1f4D6gm9zjcNWwFD0jfEM9bypMLHde6T0NLE?=
 =?us-ascii?Q?uOrv/pAUAeRgG039d03csHTYsBd8WOiJDnbF9m7f+vpZHBM5CrAVYiUbMSCr?=
 =?us-ascii?Q?nbLvZ4+2bESBK02gBiyEfRy72sxSqtm/1bEifSQlHnCs27TeKX2aEJEcsINx?=
 =?us-ascii?Q?KDpLMBa1bic6ImfXW0UBO0uyb8vARpYAs/8/DtDWIS2u24ztPUIhxlyig7Fe?=
 =?us-ascii?Q?sOFy6+I4wcRRJcJB601+AI10VMfVC/umcQLuDiQv7oLvC6B1Qvw+kDyj67LI?=
 =?us-ascii?Q?wRwoxbrMhnTPr3CaWmCD8VkGnFDesvAZVOGARgesUcVz3zZuQGfkEITePc7Y?=
 =?us-ascii?Q?jfXknI5Ubhvy0zimcxza6+YzhHFQhelkwdkQ/BK7p82A3voxjVjq4pcTEDTD?=
 =?us-ascii?Q?n8BRSG09OdJzdzJf250zJMeNveyJYBLuTYfxV+lPf24oL1l5CK/e2M0yPbyE?=
 =?us-ascii?Q?AgI9aJDbWJRtbxtbjz5TqjU+uiFRhbNa8AyJQf/IN9SODnLcGUAWm9c+jBZz?=
 =?us-ascii?Q?enO/YxToNPI9WK7CQ39bURb6P6Qqt26TfRM9pC4vLOMy7s6PSKvM08MTFO2p?=
 =?us-ascii?Q?eH0uHGBKsd9mzyr1Yi+AXCgh0OtvoylBImqTItutal2hWin4HvwW1iO5xSGY?=
 =?us-ascii?Q?p6Z3XZCU/NHgeoC0J8QGKBjb9qfraEfRcGxqpi1xwti1R5eZn2XDUY4w0kMN?=
 =?us-ascii?Q?g5m+Flql/khbbWrD+ML064/qzL64Lg7jW4Ii5nyVgKXwGzWQTHhq2ynKwoZ5?=
 =?us-ascii?Q?73PtTNykBHsaVjl84M5+e0swQNLl5RGgbrAmr4TVK8S6Tws335Na4aSIHvKd?=
 =?us-ascii?Q?DdM/C/AhoW+Udi7W2Ojs8K84wLNs1SKxGt8CMwEOhQFOMpf5TO9n+k7ckZG6?=
 =?us-ascii?Q?1XU0QmtZlBjMTAp5Awn2yDbsl0kto5rkvWKZE/1uCOZlkXxvA/wSUaODZmuU?=
 =?us-ascii?Q?5tRN5vDC+3SlEaNEhVqIB4QeK8Y9PY4/wfnktlT+BZz2TmnQPKGAiVKnaF3T?=
 =?us-ascii?Q?I3ha38gwD8YbGlGpv5obN0CDqQg6Co94J4PssYn26kbtImFMi+xw15xAx+DW?=
 =?us-ascii?Q?32flVBC0JaDM5uSjny0VMXgQ8DWLIKbHzwDRbDv7HMim6Xk1t0V9xwGzG5/r?=
 =?us-ascii?Q?57xMMHn83HsuSCJUxdUjEaGpciTvzO7wLXI2Elcs96IWE1uQjj5gVnwRn5oo?=
 =?us-ascii?Q?WDrL7Xq0zRaSj/kFTl/0HUrRVWirYtCZMJMrH6l3G1yEUXR6FPPJLjzINDIe?=
 =?us-ascii?Q?wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba59a49d-07ab-4dd6-0133-08db448edb30
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 06:40:55.6379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjsXqLXzlFWXTtPebD44Fv6Ta4KvBZ4UazyhpDNoc3k85rYTLy0kWFCbWeB2gKAyTWU18PcSV6GKVHenzPUfMDm0UjFmo+OiUYtHXjK+jNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7512
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Michal Swiatkowski
> Sent: Friday, April 7, 2023 10:22 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org; Simon Horman
> <simon.horman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v4 2/5] ice: remove redundant =
Rx
> field from rule info
>=20
> Information about the direction is currently stored in sw_act.flag.
> There is no need to duplicate it in another field.
>=20
> Setting direction flag doesn't mean that there is a match criteria for di=
rection
> in rule. It is only a information for HW from where switch id should be
> collected (VSI or port). In current implementation of advance rule handli=
ng,
> without matching for direction meta data, we can always set one the same
> flag and everything will work the same.
>=20
> Ability to match on direction meta data will be added in follow up patche=
s.
>=20
> Recipe 0, 3 and 9 loaded from package has direction match criteria, but t=
hey
> are handled in other function.
>=20
> Move ice_adv_rule_info fields to avoid holes.
>=20
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
> drivers/net/ethernet/intel/ice/ice_switch.c  | 22 ++++++++++----------
> drivers/net/ethernet/intel/ice/ice_switch.h  |  8 +++----
> drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 -----
>  4 files changed, 14 insertions(+), 22 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

