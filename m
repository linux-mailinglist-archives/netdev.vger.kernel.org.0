Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6911657C6C0
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiGUIps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiGUIp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:45:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CDE7436B;
        Thu, 21 Jul 2022 01:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658393120; x=1689929120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lFVCsUtj5pekMceUo9DCR+9C+hiBK7wtr/mOPssLh0Y=;
  b=VVRS0Cv7tt9DP91EapcRdVeON7onJz4bF5zXAg0jNPFtvUgP2bGiutl/
   fYNBTwrMHHUMn1fU/GShLUG4DLL2KZf9IQujx4UnGKfuaCLMrLTDHHF+T
   34RWrhbtcrityvf/QE04Cq+Nujcn7ZH4N73eWw1Auj5N9ewFGNrolAj7E
   3GJzEjfO89LJn1e3abgXAwF/ZGvgk9ZlXQfCTGvfasE8RqiF9WsA1sgme
   QFXtjlpGq7EuLtxJvE1TwyW2gM1RBS6u7KNa05PPS0jgAHw05QDrd9O9s
   dxXqpt8epHbO0nx7W9QDe48/f5XnMPCEatOz4w5nfKQIznQ6bq7ZM/zb1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="286998550"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="286998550"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:45:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="573655082"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2022 01:45:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:45:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 01:45:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 01:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7Q/OoQCrgP1a8+UIiQHbSzh7CYDOgkqhRR1Yva39nX8w+UrhWpNMSeD1AyRofBhye0t9E100Kd90QgBzl5Dj4+fw8T+CRJqRuHb0Xk8kne2vsGu724A3lh29bHPskwhsqgEae3hbkTdevNR51/XPfGGJ+MI8V8hn0cenm/Mfg5OYvOiyqHwjYbvuHQQ6g41g9MpURp1UD2rRS/BL1AFgXv7CJN6WNo/QGGCMgwS+KILVpS1vd/rRuSYnZ9ZruRbi1xQGu7BqRcNotwaVUdiVaIK8PHJMotBGklOx3Fa6a35MKU3uh1iCvOtXmQhy/llEUCfL1MGCotKUW3qy4uV6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUd6ROEe0UICfaNs7J04fUZdM9/xjP7ywS+bCZGYhTY=;
 b=VTWZL/uKZ3Wmxk1T42RHzCIPDuavjONBpG9MRJkgiOgskRGX4Va/VGSIq081aUDpPHOaOYE00bvxAnlIAr4dKJZOvfH4PNQYzqKo/qGTQy5Q9P9+vRp4MoSH7uuOiJ2kIlgS5rxTuuL/Ler7dQp/QoRcskf/lBDyJChquS9DLOj3MKWq3r/wL+LvlnqQ4mul7HWszsg1RS8Nr3VKvxJb5YHXH1YnAimp2uwKggph/b9Amb6eg6IPgjtIkfLXbaJn+1mGDE1VVFPMJLwPp0TtZx8kaPcfwuGWjKYZpPQZe9Wbw4yqFIkNhbKLRJFnXfjqoUGngx7LVw2bc6EJQxbIrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4255.namprd11.prod.outlook.com (2603:10b6:208:18a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 08:45:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 08:45:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Topic: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNg
Date:   Thu, 21 Jul 2022 08:45:10 +0000
Message-ID: <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
In-Reply-To: <20220714081251.240584-4-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b714c0ab-949a-4310-acd8-08da6af55271
x-ms-traffictypediagnostic: MN2PR11MB4255:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hpmGJ3/yMhWFw7je+60WWefRwGl/H0WI3zIjoxRTQ8t08LZyGk4O7S9lAUp7bZWVdHrWdTfX5SN2mPiK1elX20qPDl2sWqHnQfIAKooKgRoTeD/ru+7TKNw7EOzmyhlWTwi9bctdeghFLfiK8JFraB+itNOGZiCYBaiZT5/h9udojhKf36+6E3Ps7DyLNqreZxEH7mTG5bCvHesEaLPbOUMBa/XFLvDq/yA9AfZ4stPv5BzY5veRaeCj+AK93Fk8fPN3TMgfOYP/5Us9MD4cx3vBcvzhTcc7VaGtU5Vg4B8re7wiaCKuqmQ5MCwHHREY+s9bQomMNrPiD5GwTTPomkl5qXKzlPqiSsncxcjDJOm4/Fsy7LSZGJZuUAmIejsoGxqhHaFVfGU4lBTUAv1LZZqDIFb6UI/5cFgoZimwl5Jnkgz1WL/7fHxJ20Y9ozMYFuIxVZ9KTEGb/zZubcD21fxwqT9q/wjObIEg1yKcPBPREJO/MPgHyWEVZxdxY8bL83dKwUwiCFYBFKIYqVEUcm8ngerbRm0plktnFZ0rRhmxCQAFsCwwGPR6lsPUni9w3Y+J75Ta+O13GVcctMqR+tXutCPFsr/MoZ0Sf+Oo0uSVIBg+8Fd/7A2cy71RD+wOgDF+wCJ2VZ0k8cf77L2skjJz+Um0u2f6jutdwy7XVn7lVeNpKymig0qRdDoCqFZw5xN+j3jAKYlSAb3OsWn/kxAdyV6qNrgZCIVM4VQkk4Fhb9gufdSpXHl1bzELi6ZhEllNSUSPYXje3s4fooyEXe2L3UzLq9JfXZDN5MjcLz/oqD6VKGWZEyjrdnY0e3E6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(5660300002)(7416002)(2906002)(8936002)(52536014)(122000001)(82960400001)(38100700002)(38070700005)(83380400001)(186003)(66476007)(54906003)(110136005)(316002)(8676002)(66946007)(66556008)(64756008)(66446008)(4326008)(76116006)(71200400001)(86362001)(478600001)(41300700001)(33656002)(55016003)(26005)(9686003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J9eENbXxyXXaXdWxStWU3bsUHtZYf2q9Jp6BZo0iKuS25Sr/xXLldtyB8XWa?=
 =?us-ascii?Q?u/h34euFX3EaPFh55WuRd9Tf4ChewRjOKQqcYaBXhx2pFSmm3ThZb7lWnlVf?=
 =?us-ascii?Q?ArvwuzGCzBuQHziDdZi2ZmzenDrGyXWmANPdBN1Xawv/suU2WFGZWNOBRGpr?=
 =?us-ascii?Q?u5QU2jSbyC3jary4jsBRcF8KGQ/P4yI0LxkoTffyqGb5LufeN56cheW6kYLb?=
 =?us-ascii?Q?pTb8xfdVmq72Gy7CFOdkEUqJkeNQNaZPOzhZTR02MNnslUGmlNsYx4ps461B?=
 =?us-ascii?Q?BAOclE08GUzgJY7BWg4bVQpcQuhHSDYdJvtpAJ6IjDx2JZMm65ud6JPcAQlT?=
 =?us-ascii?Q?rxucF3RPng5LZOZLCslsO5vcLRqATyGAW+QsXVOhDS5ELj03lqS8guAYOZgA?=
 =?us-ascii?Q?pLXU1nTqJ+eWf7TWhb1vd3EvZui4d+U87lD5njElUh4Tq+Y63D4GEXw7LUbM?=
 =?us-ascii?Q?FBK9Do3YzBVd5yvJQVeJ7Pymk8mX/qKPSIseYpj+hLv3L7ewh1fc9VG0C0ne?=
 =?us-ascii?Q?3OQYB3q0HHY3zWTWvef3/t/BY0BEXtwAyt9HlA/lJKZ8UWGMvDbCq1NbPPPr?=
 =?us-ascii?Q?l7UNWBtPhTKrwKJJocD+yj0bRHMlq9jn2MANeCkUYIzS4g+rJw51MZsTxXnC?=
 =?us-ascii?Q?SebWVFjtHhqnGU/Zhaa84bTkB8hYockm9Z8SvUTVIH+8GgzoZ2HEeLv8jwQI?=
 =?us-ascii?Q?7xQdibxS4LRYdc+5J3oGfXGyTdZmUQLa3rr++Fjqfm0aiHW1hhv4PCc24qD0?=
 =?us-ascii?Q?47Eqfptql3ewYMTpZPE8zhw3AOmO7fjE+3bJiRX4X530+3TWxIG9dEKdS09r?=
 =?us-ascii?Q?NQrL/yYzbQfaRxo12ZsC9jkcyybtJTIzBisSyGiOj02Uxwa2pttfsBoFHm6D?=
 =?us-ascii?Q?vkA6GjZJgNWxli/JMid56GWMB9HMJhUBB8FOiCdeD97KLxyMHd/vjqcsNl05?=
 =?us-ascii?Q?MyVgDujO+yoQBtLc6A3rnsQxtDZ8SIcJjcWdx2p1bJZBd4TEtMToWqAeohFq?=
 =?us-ascii?Q?YY/LYesq3TnW+UNKbGs/m8cJdfUWcR4GfolKk1B0hB2EHcwObIQrDMYxKAtX?=
 =?us-ascii?Q?WYfybKRE6kNo+6ZZx57keGJunLJGYhwFnW6C2sWO/3v2XSsOYmOdOguliB1z?=
 =?us-ascii?Q?4Px8zr9+iCt42HCw4SHW7zOhD3cDAiaKYnZgRwx+vUy0Q+8VfQ2dqF3va5oH?=
 =?us-ascii?Q?Zg7RSxOKikk366BrcZzeYigZIUBnuFb8zV0qRlppI8aIozUeYe8MycRBsL1k?=
 =?us-ascii?Q?albmfhbooIQ8/bZawkDl2bogsIgsZphHtP4T/08Uz/tsA8oerxVFL4QdyuSP?=
 =?us-ascii?Q?ZaQmpth9iHuzBJqDjUxK5hoNhZ6xBZJzy4dhmG/s0vVpsZah5AFLPtbL3cCO?=
 =?us-ascii?Q?Qvm5UH31a4/0smMdXW+/ja770AjVhJncb6kioDdOhJT5ivXRHtTHyc7f61oc?=
 =?us-ascii?Q?wDJBOq29jnflNo9nnUZkikUrNQ7+vyAbxp6pYiLoR4S/9eKthcw4736pR03y?=
 =?us-ascii?Q?XF4Q0bOHFcTGwAmLU8v618IaVjORcK4fvBmjOXcALAcFJxxWzX75oyxlvhhi?=
 =?us-ascii?Q?6uKNU8usqVFM/C7EiODQLkEVi/FAdnwhnLQ0Vs/F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b714c0ab-949a-4310-acd8-08da6af55271
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 08:45:10.8437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NXmTSVqhJq6Ti62h2JBYhLQfnKIR6SRYiKcqHD8kOVhON3zNmXiNyXpBGSKT36SowokDrCbogrmYw5RJ/x3E4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, July 14, 2022 4:13 PM
>=20
> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
>=20
> This patch introduces the DMA logging involved uAPIs.
>=20
> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
>=20
> It exposes a PROBE option to detect if the device supports DMA logging.
> It exposes a SET option to start device DMA logging in given IOVAs
> ranges.
> It exposes a SET option to stop device DMA logging that was previously
> started.
> It exposes a GET option to read back and clear the device DMA log.
>=20
> Extra details exist as part of vfio.h per a specific option.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 79
> +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 79 insertions(+)
>=20
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 733a1cddde30..81475c3e7c92 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P =3D 5,
>  };
>=20
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.

both 'start'/'stop' are via VFIO_DEVICE_FEATURE_SET

> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device
> supports
> + * DMA logging.
> + *
> + * DMA logging allows a device to internally record what DMAs the device=
 is
> + * initiating and report them back to userspace. It is part of the VFIO
> + * migration infrastructure that allows implementing dirty page tracking
> + * during the pre copy phase of live migration. Only DMA WRITEs are logg=
ed,

Then 'DMA dirty logging' might be a more accurate name throughput this
series.

> + * and this API is not connected to
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

didn't get the point of this explanation.

> + *
> + * When DMA logging is started a range of IOVAs to monitor is provided a=
nd
> the
> + * device can optimize its logging to cover only the IOVA range given. E=
ach
> + * DMA that the device initiates inside the range will be logged by the =
device
> + * for later retrieval.
> + *
> + * page_size is an input that hints what tracking granularity the device
> + * should try to achieve. If the device cannot do the hinted page size t=
hen it
> + * should pick the next closest page size it supports. On output the dev=
ice

next closest 'smaller' page size?

> + * will return the page size it selected.
> + *
> + * ranges is a pointer to an array of
> + * struct vfio_device_feature_dma_logging_range.
> + */
> +struct vfio_device_feature_dma_logging_control {
> +	__aligned_u64 page_size;
> +	__u32 num_ranges;
> +	__u32 __reserved;
> +	__aligned_u64 ranges;
> +};

should we move the definition of LOG_MAX_RANGES to be here
so the user can know the max limits of tracked ranges?

> +
> +struct vfio_device_feature_dma_logging_range {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3

Can the user update the range list by doing another START?

> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was
> started
> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4

Is there value of allowing the user to stop tracking of a specific range?

> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA
> log
> + *
> + * Query the device's DMA log for written pages within the given IOVA ra=
nge.
> + * During querying the log is cleared for the IOVA range.
> + *
> + * bitmap is a pointer to an array of u64s that will hold the output bit=
map
> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to=
 bits
> + * is given by:
> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> + *
> + * The input page_size can be any power of two value and does not have t=
o
> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START.
> The driver
> + * will format its internal logging to match the reporting page size, po=
ssibly
> + * by replicating bits if the internal page size is lower than requested=
.

what's the purpose of this? I didn't quite get why an user would want to
start tracking in one page size and then read back the dirty bitmap in
another page size...

> + *
> + * Bits will be updated in bitmap using atomic or to allow userspace to
> + * combine bitmaps from multiple trackers together. Therefore userspace
> must
> + * zero the bitmap before doing any reports.

I'm a bit lost here. Since we allow userspace to combine bitmaps from=20
multiple trackers then it's perfectly sane for userspace to leave bitmap=20
with some 1's from one tracker when doing a report from another tracker.

> + *
> + * If any error is returned userspace should assume that the dirty log i=
s
> + * corrupted and restart.
> + *
> + * If DMA logging is not enabled, an error will be returned.
> + *
> + */
> +struct vfio_device_feature_dma_logging_report {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 bitmap;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>=20
>  /**
> --
> 2.18.1

