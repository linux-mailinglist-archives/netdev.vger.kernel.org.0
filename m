Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE21557D3B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiGUS5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiGUS5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:57:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EBA8B4AE
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658429841; x=1689965841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ucZY6zyA2lD//lVAsRvYlwVJl/Z34bQL6ZLl04p14f4=;
  b=QWx4YxYktE5pX18yc1Xqa3TteKtN8oQEfPvtCCT5U/R9ijZYmGZxcTb1
   Dn1kHwjTLnQWVyNSPDS/hu7+aBgxgB4TXh8eLP1IGHJVNeHyQPWcM9a1O
   qD1M97m707RxS+DFVTYxA7YjGtDm9PzwUYoB7cHh1wqcutU0ghZxHfqRZ
   M7n1JuDTo0naTIO7Z6FDi+fstU/4xuCWCQE+f1v0yZ+dVb5YfrPzErvuc
   IZrWUdKqNjkSUTZ6KISQQPdmyE8E40wQX47klN4sbPbEZQfKdk7335eyc
   Mj9593k3j6Cr+MyNCGNkp2hvcXqr2hkoRuHvtRVBP97Jn8AVfEZlEL4YA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312865767"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312865767"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 11:57:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="548895724"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 21 Jul 2022 11:57:21 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:57:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:57:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 11:57:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 11:57:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnXfJWfjEYQbXCoPlzsodswKqdCjDBOlS5yNxx9AmhAj9wtHkbZ3vnZm88MQkblSbubhG1uHzVWLD+RyNZdjQ/jwnfga8cOe0/E9onP0xtBJTvefF1rbqPlaSVaOXH35EobWcGkq8eYKN0TN0qGaVHwbmgQ64pHC5luDXJ6kiaqub5KfzyMSrmwfhgTG1S0PYh1L/rOMpSyzp9RBn5fsqFPzFh4T2YFMbVKJeg7kfseAxuelrpmaa8ThLYWCdOgRGjuH9Pb1kVP1PnJi3IhVAVy7I9eQwlkEHEMPz/kNDoPWb+KuOd/pzTOvtsFhPEszh3R4t40dyleK9xE3kbKHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIsVpmbpAqknShRPecgc/qRYBxdV6AGeYvjKTHlCzuI=;
 b=oBmA5W538TCsxCgCSCn1yRuUffgl5x+L+eOytDjp2ctCQ36SbeH8IlQ4s9D3p5QOh/TNe3ost9PnLtmTncUigcs1MIDfowpa7JviWI7hKr7i4CH8hXd6WbRKldKZm/8mY/CH52D394549/xfSrWlh3NgqThLahuNEIPq22+8+GkRdkNcvGFpIdculL4hQWBO/W0hypsZgxHyEcCzF9fhsMxWrFN1UArtqpnDuCyQyee7R4Htve+DAxZLAVe5Jis2EAm7BIsJZZ/5Mn45fIP9xWDOKi106iOlcsmuXUsSLORUZdy8zbATNL61tKJlQNUAtIwOveX054vuxhDNleGdFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BYAPR11MB2855.namprd11.prod.outlook.com (2603:10b6:a02:ca::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Thu, 21 Jul
 2022 18:57:18 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:57:17 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next PATCH 2/2] ice: support dry run of a flash update to
 validate firmware file
Thread-Topic: [net-next PATCH 2/2] ice: support dry run of a flash update to
 validate firmware file
Thread-Index: AQHYnGdrsH9VZeOIjEmsD1jkWFaMOa2IVFEAgADaAzA=
Date:   Thu, 21 Jul 2022 18:57:17 +0000
Message-ID: <SA2PR11MB5100456266D98F016DCA309AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-3-jacob.e.keller@intel.com>
 <YtjqdJcGpulWsBHs@nanopsycho>
In-Reply-To: <YtjqdJcGpulWsBHs@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a74aebf-dfb7-4491-8280-08da6b4ad56b
x-ms-traffictypediagnostic: BYAPR11MB2855:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KSO4cIxHEe1cUohmkJQiSAmtFuUrKrSFXQvDSnPNvBpKRDbMdl7iN1rZF7soGiYPjFxV8jS1kDD8h7HmlOnbTRdevzx2D29RG5aYuU8Kpz6QMqSbeNxjo+UAPv+A7UZkvSyAahNeN3ZGvRR2spaY6a2tg61bLmm0sCbc2YyyNnntoh/tcS6ZkmWYaJwk9VAYDtoQTRGNR7Z3aQOoJqn3DyOA6y5pZerUnrvbu1jAutl5snp58aGqYq4JshvLT2C0P/yLoWi0i/Q5YX/GXf4yDc+emm8rBVD03RkPWiAGWRXueq5kvW/3/W9lgTqXaojY2BfWhTrHbNVeLP/3D/PbB5xkRh7PdF4hZt9ZbRih2MrUMmNfsJTaV8agGwRubwmT6JOcERKqZ11zw56eyLlDYND6jNlbpFetOJw0sqpdIconsoP2neKINr8FDsU7o3jrfl9EGRvL7zVv8x/KDcIFG0VQQE/dtC9F4FTNQ3T5YSnatm5sTq+IlPVCfAEJJmRAEUIJKQPnMIoGrY6yh9Wl8UsBRTr1xgG7pUubOZSp/bVsWi3dIgCnIZSt7t0pq4sdXe1cjJFhC5HQTQMkSpNP+j8A7xNTyUBQXul1o/XSjxVi447U6/uKi8KKVo2/il4x5vsobyZE/ddDwM1HoCHkQUUdO1C33OlPzs8ekZt/zfyHc8Afp3Lj2Pg/W6VTmfF9yMCHWff0/2bGJq+4OA2xkreNijrT4vCLpIPZ9DnUAsPb+yIlCiQLBe982KzYh2ofV2zyyVHdu/NQqw70bbJsdfHW8XqFaA1PZUzsGn5wKwN1FN/FoCct4xGj7lWDRiWc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(376002)(39860400002)(346002)(186003)(316002)(478600001)(26005)(6506007)(9686003)(55016003)(5660300002)(83380400001)(86362001)(41300700001)(122000001)(4326008)(64756008)(8676002)(66556008)(8936002)(66476007)(66446008)(38100700002)(33656002)(54906003)(53546011)(82960400001)(15650500001)(76116006)(66946007)(7696005)(2906002)(38070700005)(6916009)(52536014)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ot96zgLQTonqwQffsq/PQ3fAO4Pyx5BSbDeO36siunwFll2iXMNB6/7sO6wX?=
 =?us-ascii?Q?1e7BSFYKZR5e6HTKojX/pdyBFb6d/CJHDjJw76zIqn8ae7AT/8UMGrBhkH2g?=
 =?us-ascii?Q?MhV7nij5wPzYQ7ZfbaBhS32Q2AcEIENDSt1I0RAhDu0YaGnt8uAfQNmBqzFx?=
 =?us-ascii?Q?fk0KujcYZ6Ax0Tybx9quV/GxUvP9HtrTrFEGnuirZuxYUb6noum8iVkYTF/G?=
 =?us-ascii?Q?99w+0DaKTWYJ9CDfHOIbDf9C3/qy25wRWdPfff4C+UkDCc9WQth/EBJ3ux96?=
 =?us-ascii?Q?KqXn/VFPCt0Z1OuEOYuJSiXhfDqbectVIhVAS9i6/y71FIMTfMEAVUgwyF5s?=
 =?us-ascii?Q?8qjygGay6/9gEVVre6fXZ2oQNSF6lOpG9X+IL75SA6alWjmyPKXPKHrHrY8b?=
 =?us-ascii?Q?LnJtjNy6Zh8TVpHgEWk67GdMRPPpxxZRUbSzjNMmvKN+dnKAIx31xoagqcHd?=
 =?us-ascii?Q?qM5Pgv4SEWWEuQEB4mw6PiweI3Q1kSGjORdCq0HURWQO5JQL9sanTZu8sT9q?=
 =?us-ascii?Q?/I4oP6c2iHJSKYfp7CSNeb87v5pYgE2q+JqdQxodfX9Lt7VdY8hThmPgBwW5?=
 =?us-ascii?Q?EU0VBQuvvb0mBb94sMvgI4gsylNN1ru0vD5cYj+Y3sRC/CBoYAE9zyu2QFnQ?=
 =?us-ascii?Q?x6DvqmQxXePE4Bpyx+niiDBI51lMrHnkBbAGXeEWJX8KgwIWDAyuAY4Jvmfv?=
 =?us-ascii?Q?/TijOCyo/fnNrrPijfkVh5MBZnv+tIVXzJq54md5CfY3MWlqWcdx8siGJBdM?=
 =?us-ascii?Q?EymV04NhfrOu3nr01wjCczDrNnGy9BOw13mZMl+KjKKmmP3h8MYx1YtyKSVu?=
 =?us-ascii?Q?qf4mbyjOKYepw38j8xNEmxyZ1VUUiYAMEwFAJEiyeZj51B5qOwmFLLvjqT/C?=
 =?us-ascii?Q?il8AawzU+WXoVEzoazKCXcb0Zy5j/L9nS0vbJHxqNKjLi7filQGfTveC5Bai?=
 =?us-ascii?Q?7prSt4mFH0OhKoYHYiOZlSofmcKVBoXN9413fcxujsGtiUgLrxRGzDDl0Ha0?=
 =?us-ascii?Q?02exTTLF9r52rAEF9jeyFtIiwDbd1lBASH0knGZKjlV329quOqeM8+5ScKQ/?=
 =?us-ascii?Q?kNADcpuJjqrY3UYa+izstae4uF680YLORdlrr/UWFEyXrQF7GYkPC3nZWlBe?=
 =?us-ascii?Q?WlSGMZu5zQ5d0Rize6pIprYBsTa7GpmRAhKyam9p4ckcKoU6lr/hA6dLNgxI?=
 =?us-ascii?Q?6VydIamhcEMgU7grvd3FuAM1Uy2DJj3gXVxmtHSQn/nxNIOEN+h+ukb+L4he?=
 =?us-ascii?Q?MjZt/f4szjmnL5IwofdNplK0KnGMJoi/4VZz9fz5+4INJA2cEGVmSz/V7vwn?=
 =?us-ascii?Q?c2mH5zdjcUumdFCorm+DYoqYkEprwduVizazTbpF4lsa7OlRC75xlFNg0N/1?=
 =?us-ascii?Q?XZZeUcCI5ccsFXxvFUzRdLt69PmASudJQG7nBhy8DvDBebmeMtobahrXAQ61?=
 =?us-ascii?Q?7pXKdWkvdCO03jIR0U2qRw9pSh0Y5U8X8qRLGMVIt/sslco1oQypA0nvOHLw?=
 =?us-ascii?Q?Re5A7eerFS9G0ocC2rSzql5oY/yGD2+tcFHzNlsQqAFjBVHMS5w9YYV6C7YT?=
 =?us-ascii?Q?IM3D37YFkpnyxZl67dTL8MiYgrbUlvdjJqRowfpi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a74aebf-dfb7-4491-8280-08da6b4ad56b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:57:17.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOEFvkHbDTVHcbrSlzQpV5bSw2NAANqahni5FF+Pa9V72C8yneEYmlKMVaBhV/CJkA0zcuRnyqoqBIVGQ1H+GrfReDL7aFJKc68N57lh1yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2855
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 20, 2022 10:56 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [net-next PATCH 2/2] ice: support dry run of a flash update =
to
> validate firmware file
>=20
> Wed, Jul 20, 2022 at 08:34:33PM CEST, jacob.e.keller@intel.com wrote:
> >Now that devlink core flash update can handle dry run requests, update
> >the ice driver to allow validating a PLDM file in dry_run mode.
> >
> >First, add a new dry_run field to the pldmfw context structure. This
> >indicates that the PLDM firmware file library should only validate the
> >file and verify that it has a matching record. Update the pldmfw
> >documentation to indicate this "dry run" mode.
> >
> >In the ice driver, let the stack know that we support the dry run
> >attribute for flash update by setting the appropriate bit in the
> >.supported_flash_update_params field.
> >
> >If the dry run is requested, notify the PLDM firmware library by setting
> >the context bit appropriately. Don't cancel a pending update during
> >a dry run.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >---
> > Documentation/driver-api/pldmfw/index.rst      | 10 ++++++++++
> > drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
> > drivers/net/ethernet/intel/ice/ice_fw_update.c | 14 ++++++++++----
> > include/linux/pldmfw.h                         |  5 +++++
> > lib/pldmfw/pldmfw.c                            | 12 ++++++++++++
> > 5 files changed, 39 insertions(+), 5 deletions(-)
> >
> >diff --git a/Documentation/driver-api/pldmfw/index.rst
> b/Documentation/driver-api/pldmfw/index.rst
> >index ad2c33ece30f..454b3ed6576a 100644
> >--- a/Documentation/driver-api/pldmfw/index.rst
> >+++ b/Documentation/driver-api/pldmfw/index.rst
> >@@ -51,6 +51,16 @@ unaligned access of multi-byte fields, and to properl=
y
> convert from Little
> > Endian to CPU host format. Additionally the records, descriptors, and
> > components are stored in linked lists.
> >
> >+Validating a PLDM firmware file
> >+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >+
> >+To simply validate a PLDM firmware file, and verify whether it applies =
to
> >+the device, set the ``dry_run`` flag in the ``pldmfw`` context structur=
e.
> >+If this flag is set, the library will parse the file, validating its UU=
ID
> >+and checking if any record matches the device. Note that in a dry run, =
the
> >+library will *not* issue any ops besides ``match_record``. It will not
> >+attempt to send the component table or package data to the device firmw=
are.
> >+
> > Performing a flash update
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> >diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c
> b/drivers/net/ethernet/intel/ice/ice_devlink.c
> >index 3337314a7b35..18214ea33e2d 100644
> >--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> >+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> >@@ -467,7 +467,8 @@ ice_devlink_reload_empr_finish(struct devlink *devli=
nk,
> > }
> >
> > static const struct devlink_ops ice_devlink_ops =3D {
> >-	.supported_flash_update_params =3D
> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
> >+	.supported_flash_update_params =3D
> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK |
> >+
> DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN,
> > 	.reload_actions =3D BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
> > 	/* The ice driver currently does not support driver reinit */
> > 	.reload_down =3D ice_devlink_reload_empr_start,
> >diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c
> b/drivers/net/ethernet/intel/ice/ice_fw_update.c
> >index 3dc5662d62a6..63317ae88186 100644
> >--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
> >+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
> >@@ -1015,15 +1015,21 @@ int ice_devlink_flash_update(struct devlink
> *devlink,
> > 	else
> > 		priv.context.ops =3D &ice_fwu_ops_e810;
> > 	priv.context.dev =3D dev;
> >+	priv.context.dry_run =3D params->dry_run;
> > 	priv.extack =3D extack;
> > 	priv.pf =3D pf;
> > 	priv.activate_flags =3D preservation;
> >
> >-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL=
,
> 0, 0);
> >+	if (params->dry_run)
> >+		devlink_flash_update_status_notify(devlink, "Validating flash
> binary", NULL, 0, 0);
>=20
> You do validation of the binary instead of the actual flash. Why is it
> called "dry-run" then? Perhaps "validate" would be more suitable?
>=20

I had it as dry-run to match the naming of the devlink, but validate might =
make more sense for what we are able to do with PLDM here.

I don't believe we have  a method to actually load it and have firmware per=
form any further validation without actually updating.

