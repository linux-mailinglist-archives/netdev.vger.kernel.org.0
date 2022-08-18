Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A25598F7F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345640AbiHRV2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344637AbiHRV1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:27:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D36E6C770
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857829; x=1692393829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3/F93gNvzTOW0ZBsdx4dHE8cpnPUJlzf05QQFNn915w=;
  b=dM8XpV9MFZOAE3V6Gaf45KOZqNq3ZXeurHSHR5QgTAJU80ACOV3rgz0P
   Iqf09SDObbJ+gdHsAwjun/ob6bTGvsqnridn4x8AMmuPo3xZoNf9b8V3B
   odP+OufQ1pYmi5ZY9B0aiQ/FSAWyFAp2Wu8kw67uOAf6vFpo9HtCQcBNJ
   NDEoqGyChveALJN26yEOr/cKJg3RF7kaizJ7pk8ys2svAMWuHdOGkoZ38
   hIwXN6qC9npicaKNf5sHWI6nJ7ey9Ef1YjRFVl52f76SxJuNK/gKKf7Lp
   7wDa9c1y1CzJlmAi4+nu5B9D8zkT8e1859TtSUt0xcK8hVJlqdpNXGEK/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="354612490"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="354612490"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:23:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558699294"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 14:23:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:23:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:23:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:23:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1Km3zn1TYkrwfu7xVaFkkBy8G/NDT/xxceENmNrV5H/cqUIm78ZnvkEQ+KKOHGkPPUeItLYOK7HFqobLZG2rDQKWWcu25WzDEqdVAmZ5ENzf8JDiKtmtkn8B0h/N7sB6rWO2e6f0vKwrHIM8IHhhrXtVKcM9TJ14F95rAbENRTSke+1HsFvw5X6H13e9IBdW1FiRmimQOyRADnpL1OjV+PQsWR2kQx+S5zRq8K12n8lkD/9qoGBhzuunZw33lt5dl75IhPsdjZB0KOMu2CcGuYnqhZQuq4nURw8VaEYex1xF1X1MMSaMKXw7D6CtNlRR7X2MjWW0rzk1wP8pJkJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crZIhrWsxl2ud/8IDB2jKIQK1fLm9ommzHcuvTU9WuA=;
 b=VW9T0cPRpLSTQe1Y4YkQD+DWpUycVB0Vor5H2eRLlu6xYQ2vH1YLXvNx4Y3w0qtp39OPEHNUgmYO1hW1g1aFf8SPSxsLzCrez3B6L693e9BDMJ4BdtUZYlqiAWJoQR2/XOOMlcgHAu+kwSgbxl7n49tE0A92OIqGKjNq3pn50RgjbRTanTxXOefvvckB5T44KKJJ05m3l2dCxkCzNoKREJjoOg/S7A+Z9qMWVyxEON4QL8YJmFXNvU7X6h3FtIRafbkIf8z2wPK8yDCKzL+fblJ8bfd+W3CYkZ9FWM7T/O357cN2KQOLCOhIbbYO0o6bmQWEcIWdKNMqyPQJtDXPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL0PR11MB2899.namprd11.prod.outlook.com (2603:10b6:208:7b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 21:23:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 21:23:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next 1/4] net: devlink: extend info_get() version put
 to indicate a flash component
Thread-Topic: [patch net-next 1/4] net: devlink: extend info_get() version put
 to indicate a flash component
Thread-Index: AQHYswKml4i03jtRmUSR+JXdSC/FaK21KbsQ
Date:   Thu, 18 Aug 2022 21:23:44 +0000
Message-ID: <CO1PR11MB5089C2E79229F15A132EC3B5D66D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-2-jiri@resnulli.us>
In-Reply-To: <20220818130042.535762-2-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5db6858-afa5-4129-725a-08da815fee80
x-ms-traffictypediagnostic: BL0PR11MB2899:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2b83Zz8eovJehi7LUp0pELITDVc8P+yUPm0WvvllQhtnCfO2cfuGg+3oRmLEqz+ZDITcRsskyb0DbjavlfniqC9XFNW/IZ1lp+x9vbcDDNprZzvMvvQwxDqXONa0+UtMDSZHQoZEzLdAxr5CWjs/mAT95B6kpWJ65C/zG2apoPR+wJ3JTwRF3dKld/2Wpzu6pGRyOV56CdA/A3yV8Yq2/RjQDuEE4hekjgScs3/WsOiEh6gnkKv32/0ALuNoAvUw96JUzeRMAbxuiKdaAmxRo8pcmGe8i3NFAB9m0/8aLlkHFSeX5YIzeKHr2w1D8sjEAzp4VjclZ3lkYrCGzZF9qNw15uTGJQJ6yaDGoPCFPVi8kZ6phFCZ3vmV6MPPteuhdS//52p4yaqqt1pPXyvdc2P4xYGy3qoTiT3bRDpu/sXQ/943E1vLMWbZOhZbgoKehbPdbxUG6eikGL7hltc3CvxkGDrw5pQbulH+nRabVsyIBAnf+I4K+Zp/wXehRQ76ilke9OPxUc8RuYVMoSYEWJHT/MUS9ksdPPEkhpsYR6DtG+yurqD3Lt6LLUcBEUy93QrPxxo5BQcnaDmGNsiVjojeZ8dcplVOk8sIxKO4SmwqAZVy/4KI8pdhVwFlFHC3fccrzsmw2gzPzgPXc7qS1nGOuahA9nAS32XtVBWwaZ/y0Xbhx6uhBPFe9oO8MOo1BF737sQ455W/GzXuXz905AXOt+W1QR4r1/47J0prw4A3AIWqOLjrD09tWkh7amaugNND+JfDKjri6gwTK/U0Sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(376002)(39860400002)(54906003)(38100700002)(41300700001)(55016003)(186003)(478600001)(53546011)(110136005)(9686003)(26005)(316002)(122000001)(86362001)(7696005)(38070700005)(66556008)(6506007)(82960400001)(52536014)(8936002)(2906002)(30864003)(33656002)(71200400001)(76116006)(4326008)(7416002)(66946007)(8676002)(66476007)(5660300002)(66446008)(64756008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TnZnpmksfh0PLVpQMZD96GFZ/8Lpzo0CQLlXXivRIwc0lyam+Dtj4AREaXU5?=
 =?us-ascii?Q?6HFDsK2jqZd6qJMdDPw/TqABbjGK/Wuq/LiGnzeKQMzo+fUNcK8pgT8Tt9Y5?=
 =?us-ascii?Q?tH6CI9fd++97B3q2IVQo6uI+2qO7f1DR10+BQmBEe9IVTJ7a3cwFyMm4f7ro?=
 =?us-ascii?Q?tPTER2Pfr0hbFiYGRr5JLjWfmN8NkDFQEiviwNBgmaUvID99OwBO87rlLyK7?=
 =?us-ascii?Q?6PvNLcdWzDsHJfMb2wUHkDTZWtBY324Ezgz6kI1BiiXtFwASoPDk7BHZRXTB?=
 =?us-ascii?Q?SfaGpYFd2qgLx4jtDmY0AahJEFwu45drXxyIViXxU13j1H7WVeCiFcsmtP3e?=
 =?us-ascii?Q?NOT16heQnD+RktOBRj5Dv2W76wuNPHus2GJETVSMexppDtK9Ig3WMt6GzDCI?=
 =?us-ascii?Q?mws1Giu1dIE7nJSr7djaYA/GMYAa2GChiiF1vgf3Qrug1cjbM86nYP61d4Io?=
 =?us-ascii?Q?x8i2oBgj+2zVGfKcEaYDoKiLm5UsSfM7OklMGj2o/szirVO5oglbubQz/OLu?=
 =?us-ascii?Q?Pk5eJp1UUSHPQI7HnkYY8JRxl2ZjspZYBaKnvAlN9yOM4FbKPcgKAs522FAc?=
 =?us-ascii?Q?ekY3MdY761ZgbgO/kUo4ISjvFts4iFpeHTq9Vf22yrSzDsA7c379KjDbzTDg?=
 =?us-ascii?Q?0vOHG3LJHdvj4sowJAp6fACbJB+FJILPb33AOQ6rufFjqF04+vS9eHDDmrFc?=
 =?us-ascii?Q?RxGmK/9GGrU0xI74P1U4i4tzT71y7FopqMEr9jx4WTDYeSjCELT614OWmaIO?=
 =?us-ascii?Q?xLTkn8k3BbjiMXymklsaw6W8frr26kr7ZYq4giTDdivrWo5awzHpeXvb3FCZ?=
 =?us-ascii?Q?uPeP+F7IWLScp8YD9G+43+TypbFChLT7quHJeuuqXl7ucu1XtoEI/nE8rIj+?=
 =?us-ascii?Q?s8Z0N0lAMcHU/F0YZG7CnmZSdxLFrIxXxjg0zSthFFMDiWgkOj4dXKAqfLDt?=
 =?us-ascii?Q?W4VJzwoSrcHnqOh3O5syzM58l3AlCKw3s1LRCWOCqAi7o/9LsbKWxhovvD6d?=
 =?us-ascii?Q?pqrQKEFlkXzMd3yDCi5dHA3xAkfFAJwOAYFpuNDPZDeG4rHwcPGI26GvdxuO?=
 =?us-ascii?Q?hEneQfK/FkFgQMGSH8sBAU51uGdXceyR+1DvwzEBMMLQx9NU9vUOthLFLalN?=
 =?us-ascii?Q?3j2+DO7u1CUuMcSOUIyqeVB7+l9UlU4aRV++sx7GcO0U1tvpU1p3aut4oovl?=
 =?us-ascii?Q?8xAmvZXOj6U2SbrKuUOVC7ijVLjL4w/fQ007CCso8iTwYI02zq5QlyoyqYwL?=
 =?us-ascii?Q?QuEuH3dA8RjgxRcUBShUFa8D5mv7qN2mrqMau+aALTv+YwQ5WnbDVWH5KjvR?=
 =?us-ascii?Q?DKd8UbqTl2zn6Ks2oj0P/FPO9gAyAve/DL99d0/8c2dtimyv7B5S2rQcA8tD?=
 =?us-ascii?Q?aGOovVcyjsDb0UrqxvnezQ4JfJHh84nUm+lkdPG8tinJ7J8qcuncnti7GCFp?=
 =?us-ascii?Q?jghBRq1mUp0HaE5XUhuRGMcipQjLP+mt7OQ3U3eOOOW4E6QpPs/Ppx8xHawq?=
 =?us-ascii?Q?WsnExRRUArJlJH6Pah+QZrAX0h/c/+PZIGNfuKtQOQXPI/DA2ZUi8K2JKI0t?=
 =?us-ascii?Q?wehGXznNBerIGXXglelZ1eIm/1z0ArsDDlVoTZ2T?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5db6858-afa5-4129-725a-08da815fee80
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:23:44.9461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPYPqVRNvvB4Jd3pHSy7NCgBlVVzC54nxMm9ui95Cvy2kNo1Qc2MI6OkOKgKDJN3xtiOUuioyU45TN1CG+RAc3TrnFJWlVh1FULJgk4v4EI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2899
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, August 18, 2022 6:01 AM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; idosch@nvidia.com;
> pabeni@redhat.com; edumazet@google.com; saeedm@nvidia.com; Keller, Jacob
> E <jacob.e.keller@intel.com>; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: [patch net-next 1/4] net: devlink: extend info_get() version put=
 to
> indicate a flash component
>=20
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Limit the acceptance of component name passed to cmd_flash_update() to
> match one of the versions returned by info_get(), marked by version type.
> This makes things clearer and enforces 1:1 mapping between exposed
> version and accepted flash component.
>=20

I feel like this commit does quite a bit and could be separated into one pa=
rt that only adds the components flagging in info and another which uses th=
is in the cmd_flash_update.

> Whenever the driver is called by his info_get() op, it may put multiple
> version names and values to the netlink message. Extend by additional
> helper devlink_info_version_running_put_ext() that allows to specify a
> version type that indicates when particular version name represents
> a flash component.
>=20
> Use this indication during cmd_flash_update() execution by calling
> info_get() with different "req" context. That causes info_get() to
> lookup the component name instead of filling-up the netlink message.
>=20
> Fix the only component user which is netdevsim. It uses component named
> "fw.mgmt" in selftests.
>=20
> Remove now outdated "UPDATE_COMPONENT" flag.

Is this flag outdated? I believe we're supposed to use this to indicate whe=
n a driver supports per-component update, which we would do once another dr=
iver actually uses the interface? I guess now instead we just check to see =
if any of the flash fields have the component flag set instead? Ok
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>


Code looks ok to me, but it would be easier to review if this was separated=
 into one commit for addng the info changes, one for enforcing them, and on=
e for updating netdevsim.

I'll try to find the patches I had for ice to implement this per-component =
update and specifying which components are default once this gets merged.

Thanks,
Jake

> ---
>  drivers/net/netdevsim/dev.c |  12 +++-
>  include/net/devlink.h       |  15 ++++-
>  net/core/devlink.c          | 128 ++++++++++++++++++++++++++++++------
>  3 files changed, 129 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index e88f783c297e..cea130490dea 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -984,7 +984,14 @@ static int nsim_dev_info_get(struct devlink *devlink=
,
>  			     struct devlink_info_req *req,
>  			     struct netlink_ext_ack *extack)
>  {
> -	return devlink_info_driver_name_put(req, DRV_NAME);
> +	int err;
> +
> +	err =3D devlink_info_driver_name_put(req, DRV_NAME);
> +	if (err)
> +		return err;
> +
> +	return devlink_info_version_running_put_ext(req, "fw.mgmt",
> "10.20.30",
> +
> DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>  }
>=20
>  #define NSIM_DEV_FLASH_SIZE 500000
> @@ -1312,8 +1319,7 @@ nsim_dev_devlink_trap_drop_counter_get(struct
> devlink *devlink,
>  static const struct devlink_ops nsim_dev_devlink_ops =3D {
>  	.eswitch_mode_set =3D nsim_devlink_eswitch_mode_set,
>  	.eswitch_mode_get =3D nsim_devlink_eswitch_mode_get,
> -	.supported_flash_update_params =3D
> DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
> -
> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
> +	.supported_flash_update_params =3D
> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
>  	.reload_actions =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>  	.reload_down =3D nsim_dev_reload_down,
>  	.reload_up =3D nsim_dev_reload_up,
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 119ed1ffb988..9bf4f03feca6 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -624,8 +624,7 @@ struct devlink_flash_update_params {
>  	u32 overwrite_mask;
>  };
>=20
> -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
> -#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
> +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(0)
>=20

This stays in the kernel so there's no issue with changing the bits. Ok.

>  struct devlink_region;
>  struct devlink_info_req;
> @@ -1714,6 +1713,14 @@ int devlink_info_driver_name_put(struct
> devlink_info_req *req,
>  				 const char *name);
>  int devlink_info_board_serial_number_put(struct devlink_info_req *req,
>  					 const char *bsn);
> +
> +enum devlink_info_version_type {
> +	DEVLINK_INFO_VERSION_TYPE_NONE,
> +	DEVLINK_INFO_VERSION_TYPE_COMPONENT, /* May be used as flash
> update
> +					      * component by name.
> +					      */
> +};
> +
>  int devlink_info_version_fixed_put(struct devlink_info_req *req,
>  				   const char *version_name,
>  				   const char *version_value);
> @@ -1723,6 +1730,10 @@ int devlink_info_version_stored_put(struct
> devlink_info_req *req,
>  int devlink_info_version_running_put(struct devlink_info_req *req,
>  				     const char *version_name,
>  				     const char *version_value);
> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> +					 const char *version_name,
> +					 const char *version_value,
> +					 enum devlink_info_version_type
> version_type);
>=20
>  int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg);
>  int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index b50bcc18b8d9..17b78123ad9d 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4742,10 +4742,76 @@ void devlink_flash_update_timeout_notify(struct
> devlink *devlink,
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
>=20
> +struct devlink_info_req {
> +	struct sk_buff *msg;
> +	void (*version_cb)(const char *version_name,
> +			   enum devlink_info_version_type version_type,
> +			   void *version_cb_priv);
> +	void *version_cb_priv;
> +};
> +
> +struct devlink_flash_component_lookup_ctx {
> +	const char *lookup_name;
> +	bool lookup_name_found;
> +};
> +
> +static void
> +devlink_flash_component_lookup_cb(const char *version_name,
> +				  enum devlink_info_version_type version_type,
> +				  void *version_cb_priv)
> +{
> +	struct devlink_flash_component_lookup_ctx *lookup_ctx =3D
> version_cb_priv;
> +
> +	if (version_type !=3D DEVLINK_INFO_VERSION_TYPE_COMPONENT ||
> +	    lookup_ctx->lookup_name_found)
> +		return;
> +
> +	lookup_ctx->lookup_name_found =3D
> +		!strcmp(lookup_ctx->lookup_name, version_name);
> +}
> +
> +static int devlink_flash_component_get(struct devlink *devlink,
> +				       struct nlattr *nla_component,
> +				       const char **p_component,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct devlink_flash_component_lookup_ctx lookup_ctx =3D {};
> +	struct devlink_info_req req =3D {};
> +	const char *component;
> +	int ret;
> +
> +	if (!nla_component)
> +		return 0;
> +
> +	component =3D nla_data(nla_component);
> +
> +	if (!devlink->ops->info_get) {
> +		NL_SET_ERR_MSG_ATTR(extack, nla_component,
> +				    "component update is not supported by this
> device");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	lookup_ctx.lookup_name =3D component;
> +	req.version_cb =3D devlink_flash_component_lookup_cb;
> +	req.version_cb_priv =3D &lookup_ctx;
> +
> +	ret =3D devlink->ops->info_get(devlink, &req, NULL);
> +	if (ret)
> +		return ret;
> +
> +	if (!lookup_ctx.lookup_name_found) {
> +		NL_SET_ERR_MSG_ATTR(extack, nla_component,
> +				    "selected component is not supported by this
> device");
> +		return -EINVAL;
> +	}
> +	*p_component =3D component;
> +	return 0;
> +}
> +
>  static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  				       struct genl_info *info)
>  {
> -	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
> +	struct nlattr *nla_overwrite_mask, *nla_file_name;
>  	struct devlink_flash_update_params params =3D {};
>  	struct devlink *devlink =3D info->user_ptr[0];
>  	const char *file_name;
> @@ -4758,17 +4824,13 @@ static int devlink_nl_cmd_flash_update(struct
> sk_buff *skb,
>  	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
>  		return -EINVAL;
>=20
> -	supported_params =3D devlink->ops->supported_flash_update_params;
> +	ret =3D devlink_flash_component_get(devlink,
> +					  info-
> >attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT],
> +					  &params.component, info->extack);
> +	if (ret)
> +		return ret;
>=20
> -	nla_component =3D info-
> >attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT];
> -	if (nla_component) {
> -		if (!(supported_params &
> DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
> -			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
> -					    "component update is not supported
> by this device");
> -			return -EOPNOTSUPP;
> -		}
> -		params.component =3D nla_data(nla_component);
> -	}
> +	supported_params =3D devlink->ops->supported_flash_update_params;
>=20
>  	nla_overwrite_mask =3D info-
> >attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
>  	if (nla_overwrite_mask) {
> @@ -6553,18 +6615,18 @@ static int
> devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  	return err;
>  }
>=20
> -struct devlink_info_req {
> -	struct sk_buff *msg;
> -};
> -
>  int devlink_info_driver_name_put(struct devlink_info_req *req, const cha=
r
> *name)
>  {
> +	if (!req->msg)
> +		return 0;
>  	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME,
> name);
>  }
>  EXPORT_SYMBOL_GPL(devlink_info_driver_name_put);
>=20
>  int devlink_info_serial_number_put(struct devlink_info_req *req, const c=
har
> *sn)
>  {
> +	if (!req->msg)
> +		return 0;
>  	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_SERIAL_NUMBER,
> sn);
>  }
>  EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
> @@ -6572,6 +6634,8 @@
> EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
>  int devlink_info_board_serial_number_put(struct devlink_info_req *req,
>  					 const char *bsn)
>  {
> +	if (!req->msg)
> +		return 0;
>  	return nla_put_string(req->msg,
> DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
>  			      bsn);
>  }
> @@ -6579,11 +6643,19 @@
> EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
>=20
>  static int devlink_info_version_put(struct devlink_info_req *req, int at=
tr,
>  				    const char *version_name,
> -				    const char *version_value)
> +				    const char *version_value,
> +				    enum devlink_info_version_type version_type)
>  {
>  	struct nlattr *nest;
>  	int err;
>=20
> +	if (req->version_cb)
> +		req->version_cb(version_name, version_type,
> +				req->version_cb_priv);
> +
> +	if (!req->msg)
> +		return 0;
> +
>  	nest =3D nla_nest_start_noflag(req->msg, attr);
>  	if (!nest)
>  		return -EMSGSIZE;
> @@ -6612,7 +6684,8 @@ int devlink_info_version_fixed_put(struct
> devlink_info_req *req,
>  				   const char *version_value)
>  {
>  	return devlink_info_version_put(req,
> DEVLINK_ATTR_INFO_VERSION_FIXED,
> -					version_name, version_value);
> +					version_name, version_value,
> +					DEVLINK_INFO_VERSION_TYPE_NONE);
>  }
>  EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
>=20
> @@ -6621,7 +6694,8 @@ int devlink_info_version_stored_put(struct
> devlink_info_req *req,
>  				    const char *version_value)
>  {
>  	return devlink_info_version_put(req,
> DEVLINK_ATTR_INFO_VERSION_STORED,
> -					version_name, version_value);
> +					version_name, version_value,
> +					DEVLINK_INFO_VERSION_TYPE_NONE);
>  }
>  EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
>=20
> @@ -6630,16 +6704,28 @@ int devlink_info_version_running_put(struct
> devlink_info_req *req,
>  				     const char *version_value)
>  {
>  	return devlink_info_version_put(req,
> DEVLINK_ATTR_INFO_VERSION_RUNNING,
> -					version_name, version_value);
> +					version_name, version_value,
> +					DEVLINK_INFO_VERSION_TYPE_NONE);
>  }
>  EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
>=20
> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> +					 const char *version_name,
> +					 const char *version_value,
> +					 enum devlink_info_version_type
> version_type)
> +{
> +	return devlink_info_version_put(req,
> DEVLINK_ATTR_INFO_VERSION_RUNNING,
> +					version_name, version_value,
> +					version_type);
> +}
> +EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
> +
>  static int
>  devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>  		     enum devlink_command cmd, u32 portid,
>  		     u32 seq, int flags, struct netlink_ext_ack *extack)
>  {
> -	struct devlink_info_req req;
> +	struct devlink_info_req req =3D {};
>  	void *hdr;
>  	int err;
>=20
> @@ -12306,8 +12392,8 @@
> EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
>  static void __devlink_compat_running_version(struct devlink *devlink,
>  					     char *buf, size_t len)
>  {
> +	struct devlink_info_req req =3D {};
>  	const struct nlattr *nlattr;
> -	struct devlink_info_req req;
>  	struct sk_buff *msg;
>  	int rem, err;
>=20
> --
> 2.37.1

