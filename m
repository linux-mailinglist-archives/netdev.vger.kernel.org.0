Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BE16E0FC9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjDMOP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjDMOPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:15:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73C6448B;
        Thu, 13 Apr 2023 07:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681395318; x=1712931318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IFD5DQjPU1OB7oqff6zh1/TE5sDj40fcYmXdX0nmq30=;
  b=Hl2EkhYgqaXu0yM53uq0DyJLFwtacIP8yMpVy1v7+uNF9WMqXQY55OeZ
   dc+7GYtgM4RCSZO7YnZkFk8eJTrhfV2ejGZVmU63/BTGjfxwpAyDzWWFF
   vjLdRi51Y0r40qGlPOLEuMy409VAmBvD2nbT8tNhNrdu6Q9GRxEU4b7wx
   LszNc8/rUeYe7Otn7BBczc/vCl7BY1SxWMY9b5L96417ILGgnxp8741Pa
   xIKc4OqfHtJel/Dn1njo0qLr5vnsVys4YOPv5HyAAL8N60FUhz61We3a+
   o9/X4hZUtTeI9xJKsIh1SZN9N5Ykycgpjf3oN6UCPokx6IRoIYCvY0B/x
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="328327972"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="328327972"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 07:04:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="833158406"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="833158406"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Apr 2023 07:04:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 07:04:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 07:04:35 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 07:04:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRVvNyZJwj56dNY2+p9/1YlhC6jc3r2FhlY68Qu7/BQOXKIdjZHFCHUJXMgazkLH0LIntHio8IIrLdwxBjAlt1DM8ltW9xzEE1hVbAkl4DsbOqB4IfiEVKIr7XtI7k6MekGK8dcQH0oZTKVWmi2k9lRNB0A3jaWTd2Oa9GUvMv0LJ9Gd3Jji+qQvO4UrGFoLEcW02RNpZU256S2aV/j/nfj6cqNqo315RAMb8UEXbso3LWkdUHAjmIASGjkM9xBFJelrleStfj13rqml+1CzMvK/L8a+MiMp6j6GjucqA7igi2rdv9v+r3WdqrGSI5CHiaIkUzwjMlRhgIaDHQ09ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXR5Z5DDGL3i6fRwx+5LXpCTfE/bdzlGWkDRDdP05Oo=;
 b=N2CwcHRDiSQq4dI03qX3IYJUJti0Vz0afJTwWomyI7HouMKYjQsnhL/OfQp18P/BaTo/WY03ZOLXkcbG+ou8YMDQ4g082gmUuQgyRAKU879gaehf/4cFoH4a/PDqgQuZGk15nNMhbkfDFMf0zeJFkQcd/gSZO4JFo7rtbMaUV8TXO2T7kSF6VeX28IhfSst4m6Rrak9ynCowB7G/0FPQmOkhTlF3KNkb2AVIp1Q3oL9jDu/qJ0TeJ3WMl6YtRXMFf5A4mb9od6eLOmXheB1yGrf9TOMpwVxnpVmCmB9ibFAoDH7SRUxzBvFjfAGv2ge9HCxUlKimG1EAkFVn34Di+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.28; Thu, 13 Apr 2023 14:04:34 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 14:04:34 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Topic: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Index: AQHZbURL//7N1kf7H06LoNzMTKXBn68pOgwAgAAM6+A=
Date:   Thu, 13 Apr 2023 14:04:33 +0000
Message-ID: <DM6PR11MB4657BB5D26421ECA7709C79B9B989@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
 <20230413131726.GQ17993@unreal>
In-Reply-To: <20230413131726.GQ17993@unreal>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA0PR11MB4574:EE_
x-ms-office365-filtering-correlation-id: d5f7e2f5-cf2d-43d4-87f0-08db3c280262
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J0wRWxxcSjl6aPfQueXtxhE6bjiBHRRhOY5dB16UzV8h4ucEksC1hL4qRYHAoXi44iVurfmRDTbNkzQwh6jlcAKFI4M18QYF5EmETKUWqidcQxlTvKlElADlVWeFnKmoSzjXsisw1VPoeZz1KoAvl1Cw3Lnko2KBQH1k0pLBdHZx4ZSSIoIcdAjHUgFQJ1wpIsGYfMvVKNQuKSSJHGLaeiG70VwQdl+gjm+9m7b7cxP5lddgzA6ZX9ZlVmr9jVKjt59DrcESCFhKGuOHzIJM3OhM3uAx7skPCKGIzej1T+pBwS+3STIDqNTjA/LVPPj8Q+aQLb4iF6QEZG7bO9WozNK28aehi0d672RFA3VBZf/KXA+6BjYCV0CiQGKpPEE/QrOpREZMrsUQ59wJZRS7z/z8a4GHYFcTWQipnpFSdvXDtY8XvOqIDBYM1oDoefe5LWZKJkFf0MU0uu+3AXw+cLP+Jhh4xgki2lTQudRUhI4qmZ5xQ+mbCeTJE3VXJ2eLti+Z180DcDxECNeBXQ8y6+Xtrdvr7CrbWzT3jRljZOiIEzyIsCr1EQ/i4CLFKAFRr6s+2hkTQb25sfHVzWZ2HNSFBo6hram8dPQo0DtPj4+oVmUUf5aJ+MVKGBESOAu/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(7416002)(82960400001)(9686003)(6506007)(64756008)(6916009)(71200400001)(4326008)(52536014)(86362001)(5660300002)(8676002)(7696005)(316002)(8936002)(41300700001)(54906003)(66476007)(478600001)(66556008)(76116006)(66946007)(66446008)(2906002)(55016003)(38100700002)(83380400001)(122000001)(38070700005)(26005)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z+MwPkZATDP44pFEmARmT9ctUyye+8xjvJ9tocMAYEHBX2+5xr0GINx0ARQj?=
 =?us-ascii?Q?4mSbUJ0mTAIFNo3UcEFDDCkWe6MfkW7SLKA/aSGMr73gjtevg7APRf67LzwI?=
 =?us-ascii?Q?mpq+5Y+2vOHhsrr856dYVzxTiEDcG5zjeVGam52tnuzluNMGkZNFaFi5nXg4?=
 =?us-ascii?Q?6d20JS5tp7+XL7yYl2yfbHDQtSAVY0/M6E3ynpNxLgMSuQrDC34I+x7hFAM/?=
 =?us-ascii?Q?wp+4sS/wdttQwkdc9N7XF3lvJeA1/qpQG2QH43SvyV4bWrcc7uYsfTW2pAVp?=
 =?us-ascii?Q?EBnGN1GAtkLh2/1tm2Cp0P9TGVZvhg6GEmZxjCtyAmkSiIjL2DMgMXpK2cNc?=
 =?us-ascii?Q?3DEaLT/CF1bRNe3eTa1qBq7qX/4nvC1QphllHXOPqo8A+rH/hDAL2/8GUdQe?=
 =?us-ascii?Q?K9UU1dA4oiUUBVasG1EpUeurVhFoOvKAxvauVO4+0uP7LDtgolDh2y8bouiU?=
 =?us-ascii?Q?qOxPl7/mnHVYvkD747V/1l6QHk8xaVnEjknSK18y7KZNgFL5rC9P8ucpCrxx?=
 =?us-ascii?Q?foLCbj3Cu6NoCppY7nes14Nwhf1hJ8AZzU9QnUG9xSUBSQo82fsECtSZcDRs?=
 =?us-ascii?Q?br/dEi5J7F9mPcarA/Mn80SEaYXqiXOjR5BBwefQ9rC0lUUoW31IRzrIEvbI?=
 =?us-ascii?Q?qwdB8DGrljHdAl2lVHTU0uc6RCHhtE7KOYZjHiU0WSHdEckMyPcHLRujUpiw?=
 =?us-ascii?Q?dz2J4aggYzqgOrnGqCzT86hhNSF8WX1stiPdlKKfuJEV1hTSF/HPYru4bzt9?=
 =?us-ascii?Q?Ak63EOagumM2h6VL/kp+pcsBOIYYb5SUxIL2403sseY80FhJlUrO0iRNiUbw?=
 =?us-ascii?Q?0w0S1dWwcHGlKQSMIunYTbgKC69Pps/2/Uch47pamduY5134UYkmERoWft2S?=
 =?us-ascii?Q?JnzXg6qcTItWo4Fe/qWK/ffIsauR3iCkJshpOTdeQam9PjoEwJ2oZkbfJqS3?=
 =?us-ascii?Q?8bC5PHzq136ksJD8D/vzVcVipjjkPtzd9vFm3K3Z0kovDyNVZCSCYLNVD+Bg?=
 =?us-ascii?Q?7dAe9XsqJdpQLhMECXgkge3epHSlkUGxOxOkQghOZjp+7CRcEHeMfvRQwdlE?=
 =?us-ascii?Q?hE+utEpFsB/6uC0bFN82xaRMfZ3PXpyFrGCHlKsYuuh9jfTURGduOdorLn2p?=
 =?us-ascii?Q?A5UFukJMCJctLHCggm9VZn3JNl1vUEpQaJyE1ofrByun7WPjQ0+UXi3FaS1I?=
 =?us-ascii?Q?G3+yGjHau8WSSVfzQGn7Ff7p+kArrooOWRhgYKirQIgd7skAFOwD/h2p7V7z?=
 =?us-ascii?Q?HeL6OHgmEFjkVy9EogtetegVEUi42I4zOSKMvh/bOMcAIsds6WvHjF/kHoJ1?=
 =?us-ascii?Q?DCIlYgKy91Aq9ShF+SazuB6VxP4kTZaQpceOTlLgIObpwz3Z2wZpgJ7/YTdj?=
 =?us-ascii?Q?YSwEoXOYx4G82Ttx+xd2u3NeceVgD2ZDVONH6PHMxnzY4SEGTg8sFcmfS/RE?=
 =?us-ascii?Q?CXLNg/SIZiR3OeOiuo+WFahRwhcAtrxI7FDmWEF2ndbjJ0/vd8HyHaczJE6z?=
 =?us-ascii?Q?R4MtYbeOHOu43FDr3OAI3aKxwCePcNX2QOeVOt/pM1wzh5xzWfH19m1nG2XZ?=
 =?us-ascii?Q?zOQXsU3Wh4sGeNljdYxeggCLaBOY2KfW36cZwNgY8XVEEVj7+SS7WeDda/FN?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f7e2f5-cf2d-43d4-87f0-08db3c280262
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 14:04:33.9058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NPY/BLQ/jRE72rSaS8W5P+XCX7yq+Y0uaKD5iZ78stLYDUPqWe3QBKKyI8IdlMpU/6n8tsk/lflzJd/O2tsXN3s4mm7zoqaYb9KX6RpM/MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Leon Romanovsky <leon@kernel.org>
>Sent: Thursday, April 13, 2023 3:17 PM
>
>On Wed, Apr 12, 2023 at 03:38:11PM +0200, Arkadiusz Kubalewski wrote:
>> If Clock Generation Unit and dplls are present on NIC board user shall
>> know its details.
>> Provide the devlink info callback with a new:
>> - fixed type object `cgu.id` - hardware variant of onboard CGU
>> - running type object `fw.cgu` - CGU firmware version
>> - running type object `fw.cgu.build` - CGU configuration build version
>>
>> These information shall be known for debugging purposes.
>>
>> Test (on NIC board with CGU)
>> $ devlink dev info <bus_name>/<dev_name> | grep cgu
>>         cgu.id 8032
>>         fw.cgu 6021
>>         fw.cgu.build 0x1030001
>>
>> Test (on NIC board without CGU)
>> $ devlink dev info <bus_name>/<dev_name> | grep cgu -c
>> 0
>>
>> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> ---
>>  Documentation/networking/devlink/ice.rst     | 14 +++++++++
>>  drivers/net/ethernet/intel/ice/ice_devlink.c | 30 ++++++++++++++++++++
>>  drivers/net/ethernet/intel/ice/ice_main.c    |  5 +++-
>>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c  | 12 ++++----
>>  drivers/net/ethernet/intel/ice/ice_type.h    |  9 +++++-
>>  5 files changed, 62 insertions(+), 8 deletions(-)
>
><...>
>
>>  Flash Update
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c
>b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> index bc44cc220818..06fe895739af 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> @@ -193,6 +193,33 @@ ice_info_pending_netlist_build(struct ice_pf
>>__always_unused *pf,
>>  		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
>>  }
>>
>> +static void ice_info_cgu_id(struct ice_pf *pf, struct ice_info_ctx *ctx=
)
>> +{
>> +	if (ice_is_feature_supported(pf, ICE_F_CGU)) {
>> +		struct ice_hw *hw =3D &pf->hw;
>> +
>> +		snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);
>> +	}
>
>Please use kernel coding style - success oriented flow
>
>struct ice_hw *hw =3D &pf->hw;
>
>if (!ice_is_feature_supported(pf, ICE_F_CGU))
>  return;
>
>snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);
>
>
>However, it will be nice to have these callbacks only if CGU is
>supported, in such way you won't need any of ice_is_feature_supported()
>checks.
>
>Thanks

Sure, I will fix as suggested in the next version.
Although most important is to achieve common understanding and agreement if
This way is the right one. Maybe those devlink id's shall be defined as a
part of "include/net/devlink.h", so other vendors could use it?
Also in such case probably naming might need to be unified.

Thank you!
Arkadiusz
