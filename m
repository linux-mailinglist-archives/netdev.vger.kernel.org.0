Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2CB4B6524
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiBOIEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:04:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiBOIEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:04:42 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B02C2612C;
        Tue, 15 Feb 2022 00:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644912272; x=1676448272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ohajP8VWg0APv50oj/WoPpGnQ9LUinqnh7Ur5204ucI=;
  b=a2fGFM+0vaXkcWXy/3xP2v7wNtzgKUYtUewlXQ1nVC4E2FSNdjw3CHeJ
   M4vgY5ZNEZlnZFezSF9TeVXEUMpUSae+jLBlAmSMxi0RarnPG7CHu5KvZ
   hbTd6JSakTCnjxo6Hv8I1d4m367XZp7mSgtjvMsoVJ21cekW2OJfO8/W1
   0ytnkEJR5if413u7V/aFNoT3H+C2TSKoXdIZIh+XIvmT79ktea55Yq8bF
   035ngJAhhzjD+OGM6Q/iFXwqkqeOyuaLa+gg0wOBnwB3KfVxDzd2FfIDo
   dqJfWWsTOwO3Xt/XWSRLBa6BPf5tMPX9P50E7vcbbBPtPvnU0O2qYPtTz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230238111"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="230238111"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 00:04:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="502281936"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 15 Feb 2022 00:04:31 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 00:04:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 00:04:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 00:04:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XngtlWnfdNqkV2mIsDIc6Qx08HsnuwujbgVV0lCcGfWMjJtL+ukLmmYAjw27RraPtcqcUAW+HZviWhx3OO+Xf4wzYAxJvn1YfeJfsyZ8pzwE7gqHq74r/Cz9eGQb6WTY0bP7Bq6/BhM7yqYUAC3gJxY+FEFRuifGsTY2M/5BjXRNXzD3Xy/tRz5DKg1RV5sYWS3WtgHnetu+5GdJGklnfvf1NsIebqSYBTTTJ2Z9JP9tfwvdhSy5V6S5k+ytG+Fj2mm+gu7LaiXRTJCWr7ctDoU2++DWdhlgmFL/YLzuRO3ThMK46vQcOxN9PoPHqVjHNlYL4FYL0ij5QxgsVxMeew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvI8Cqe9rjcwjvxKgctyw7YXD/o6qWiiG0vj9vlzEww=;
 b=kQJLoHDH2Phu8c2DIpFsaP3bbJsrQAqOra7YI2Yibv+MEBo0zIr6QH+RTRFl17qheT3hnKYeet65lARC1GIaWnGBquOcK4r5k4QjeD2/CyJP0RsoflGxeQolCBwLNRFJjP/yt2RDTu+ls8MRSQJl4te7G1H0a8P5RaC23XV25Vvzq6CbTFIZ7LmT41PtFDvUeIeDXd6oin+LubK8kUt8cNqtp3ABMNNbv1qHRqXmLBVDUpdnv3TZEComLr256jz9JoiGEgdpj9iwA53avEjek5y6GpjIqyi7P3QTtXoN9/zOP6oLmGV6MD/sUmGCiuGqXVNAnQzrdeTpShZCyoPraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5920.namprd11.prod.outlook.com (2603:10b6:a03:42e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 08:04:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 08:04:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yUPI/g
Date:   Tue, 15 Feb 2022 08:04:27 +0000
Message-ID: <BN9PR11MB5276B8754BA82E94CF288F8C8C349@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
In-Reply-To: <20220207172216.206415-9-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70cbed73-8211-4629-8bd0-08d9f059c9fa
x-ms-traffictypediagnostic: SJ0PR11MB5920:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB59206FDB6841E210FAE68F038C349@SJ0PR11MB5920.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: msbJIoFm2igGph7d7DD7aI0T84XUWThktCvoqoI2DWR3ygVKTxjwyGFFIu2pzOwERT3Ehoxav0K90Wz7N2nPYYtRFQpdoYLoejUeXBjE2zwD0FRc7Dr9/d7nQGpAIf72pJP88cPF362njIMTo0G24eZMK8hVFsjKoGKm7dysdOLRYtNU6oAabF/m2GtU+o/7yoFJMctrV5sQRbxwxye3Y8qIwdYTeFoogWyvAjmFLrgozcC1CxO1Z1ZPfuMthJ2Fxqgekl/TkAbMfMVoHJ8sSdLbDO2uSXF8Cdo5vI2VgaKipDQ8p5/MJUPsHUCAuv8dkPKa/diP3cJqFDna5+uUynEjrTrZ3uF8ub+HgRL+dRV/0Cs1yFBMGIqs0RJwQL2E0HWivQsmYgz2RHPkP1OKgJ874sXwJa4g6aISc0OgmbfgyaONiDBpZ+AUBqgETfPCfZ1UzBMaBPMLTXoF4txswj2ri6hQDp0Sk4eBBVH/2EIfD7aDQj7WM4YfKo/fCnFprp2lloaypd4DR0di9vl+T6cJSscwyXshsPNHMXNiRx8QV6GRvs7yAY8K9SqXx4T4CkEkWeSJ8xB/8QT63iO30y2IGj4mVKmh+oqnfT1XNQ6N1nIY+M9TLAlvkXoM8b9or3NQXSJjpgjDBsjRoVVZYP2KVVhLxoHp6SKGSdTug2oE+XYsydG+hHGRFyaqNCK+QlESpHD2nFKA7EXdobkJ5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(76116006)(8676002)(66556008)(66946007)(54906003)(64756008)(110136005)(38070700005)(316002)(66476007)(4326008)(66446008)(33656002)(2906002)(83380400001)(8936002)(86362001)(26005)(186003)(5660300002)(7696005)(6506007)(71200400001)(55016003)(122000001)(9686003)(508600001)(52536014)(7416002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WA+MD841cmmJd7GLlSH3WD291B4roel0HFr07y6Of9fUToLLuXNEXrIFBvUD?=
 =?us-ascii?Q?LoMyVh+45kS26msJFZwD4r+UbPQSHV8sEWBC4mAUNXgw7wHk5JSvu+V6hqUy?=
 =?us-ascii?Q?6vGla3GwDQX/McaSP6j4gw+bv5LlpXicKyvFRvtQyd4pLd5CkqCdZSvybJQi?=
 =?us-ascii?Q?KmbTn8Mtl8mWSt+W9WaFnV/HV3NzNJoMULRpDARI5D3aKfoKCEnSKKgPnxyA?=
 =?us-ascii?Q?sgoO+6vjNYMTQ8SwHagzbr4M81HfiE403Lpoyj4HYAcNUb6fZYS3l+/XsWDf?=
 =?us-ascii?Q?YjC51L+cnMieUFJ3muZFZdtn1ZX/mj8trI+X1Jxvx5Gf89N9h9oEFmK01lyo?=
 =?us-ascii?Q?NnVAFpZD/pBHKZgfn/7A/49Q2vF/J/wohqLA70008RXp/wozMcE03gi5AoT0?=
 =?us-ascii?Q?egjjVN8SUPE2cpmhFRCnjwB9Yzl9ToxkttkS1+DncpgJMfWMaxERT1OWMmpo?=
 =?us-ascii?Q?SACYXhisTSQS++XHgY+uwM49dQV40XRL9rx1kFyXXZK1oO7ba1yj2fk4ERpM?=
 =?us-ascii?Q?3Rjvll+ZwUaSXub5AHr7iq0F+apWF8ErwsqW5GO0cCrzihqAMW2UrZmLHOO7?=
 =?us-ascii?Q?veW+Hw4OLF0gVOb8krXWk4P5DLWde9Woxfsg2Qj1g+xT+eevXSTMpFH4MbEc?=
 =?us-ascii?Q?J1oghTQQ1wMY/uAF7JqCOS5Jd1v6rzxg5uuYDC0LkVUvB3pFFIYgmBmbXhuV?=
 =?us-ascii?Q?kU/mtN7NiEBrMK1NmWp7bqvucWVOfaARTNCkrUq8DZxKBnV+JyJvvygURIlb?=
 =?us-ascii?Q?Xf2iUk2QmbsTSrlAG68vMPWMWKOZK4HlFf6l4CNMZpq2Cz+ZYr/Da5p6aSv6?=
 =?us-ascii?Q?Lz4E552uQgd50c6LkLcQZgHkqzU2qXZDWfwNBhrsxelp7upWIrHy6Tho3gpn?=
 =?us-ascii?Q?Fs7qGRCgCXPAiJJtGzpedO5bH29QPO4AbTPiK1hCZhqsjp3eqk7AgMXUYllQ?=
 =?us-ascii?Q?o9tYFEHZwyrGMgnNkV/46AcK5dD1YGxss9JteP+PRdMpESsdnBvyjkjdR48U?=
 =?us-ascii?Q?JoLhiIZbnaXLcb+jTI15YTMfmGTpTleQlBvMfN8g3Th3uq8p/brlMGmf8aDr?=
 =?us-ascii?Q?sopJAu++gicejHRk3msXJcEFBuXCL0V5Cptkr1nlFHx98MTPcnYrUF83uUXZ?=
 =?us-ascii?Q?yWEbKMU2xMNrhbYNyhKJcldtMP1RgAHL7QZCfS+9x6Z6Tf4Nwwf8Kl8AyQYR?=
 =?us-ascii?Q?gWBlysYU6ZMOBHTgQvj/8rXnhVr760GTFI50xF/O+/SueoeBbSHHRj5fJYQo?=
 =?us-ascii?Q?o71P/0q1cXgANYupLOLK5F8or+KKjpPGxKyjx26x6jbYRaFou1wniXDfmlp3?=
 =?us-ascii?Q?DPc99Nf0LDnPP2WJSs8bS3N4ziKOIFqxdkvpnPW6iAg59VBDjPbIlzWuaQCp?=
 =?us-ascii?Q?jJyPGacBIz5Sl4QOEos3TukzPOYqs/xNLgtnKmSNKoUH3/Fr+DIB+NZwyo4N?=
 =?us-ascii?Q?QBkCDoBm1zdQ3AQaySR/v5ce/xQV5/PxKvrVqdiuFqXI3zwQ9i2zeEknhRGp?=
 =?us-ascii?Q?KcjPj8jaUZErMrU++19BLCEiE/uKL8T5xiHZm6WvX66SJDqteZ+lHcfkUeXf?=
 =?us-ascii?Q?vuaykqiUa7Y7iKg3OTm7ak/fJvvYCY5cdH+DiUAe8EZvA5OT9OvtoxNcyOWz?=
 =?us-ascii?Q?dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cbed73-8211-4629-8bd0-08d9f059c9fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 08:04:27.9781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDJgZ3CBzwCYDvdQ6m+fyM1xMed46zOVp7kSSul83uBBGw+30GpOQqqyjmqL13UEmvEQ8x7QDXnlaQst8YRCLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Tuesday, February 8, 2022 1:22 AM
>=20
> +static int vfio_ioctl_device_feature_migration(struct vfio_device *devic=
e,
> +					       u32 flags, void __user *arg,
> +					       size_t argsz)
> +{
> +	struct vfio_device_feature_migration mig =3D {
> +		.flags =3D VFIO_MIGRATION_STOP_COPY,
> +	};
> +	int ret;
> +
> +	if (!device->ops->migration_set_state)
> +		return -ENOTTY;

Miss a check on migration_get_state, as done in last function.

> + * @migration_set_state: Optional callback to change the migration state=
 for
> + *         devices that support migration. The returned FD is used for d=
ata
> + *         transfer according to the FSM definition. The driver is respo=
nsible
> + *         to ensure that FD is isolated whenever the migration FSM leav=
es a
> + *         data transfer state or before close_device() returns.

didn't understand the meaning of 'isolated' here.

> +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING
> | \
> +				     VFIO_DEVICE_STATE_V1_SAVING |  \
> +				     VFIO_DEVICE_STATE_V1_RESUMING)

Does it make sense to also add 'V1' to MASK and also following macros
given their names are general?

  #define VFIO_DEVICE_STATE_VALID(state) \
  #define VFIO_DEVICE_STATE_IS_ERROR(state) \
  #define VFIO_DEVICE_STATE_SET_ERROR(state) \

It certainly implies more changes to v1 code but readability can be
slightly improved.

> +/*
> + * Indicates the device can support the migration API. See enum

call it V2? Not necessary to add V2 in code but worthy of a clarification
in comment.

> + * vfio_device_mig_state for details. If present flags must be non-zero =
and
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY
> and
> + * RESUMING are supported.
> + */

Not aligned with other places where 5 states are mentioned. Better add
ERROR here.

> + *
> + * RUNNING -> STOP
> + * STOP_COPY -> STOP
> + *   While in STOP the device must stop the operation of the device. The
> + *   device must not generate interrupts, DMA, or advance its internal
> + *   state. When stopped the device and kernel migration driver must acc=
ept
> + *   and respond to interaction to support external subsystems in the ST=
OP
> + *   state, for example PCI MSI-X and PCI config pace. Failure by the us=
er to
> + *   restrict device access while in STOP must not result in error condi=
tions
> + *   outside the user context (ex. host system faults).

Right above the STOP state is defined as:

       *  STOP - The device does not change the internal or external state

'external state' I assume means P2P activities. For consistency it is clear=
er
to also say something about external state in above paragraph.

> + *
> + *   The STOP_COPY arc will terminate a data transfer session.

remove 'will'

> + *
> + * STOP -> STOP_COPY
> + *   This arc begin the process of saving the device state and will retu=
rn a
> + *   new data_fd.
> + *
> + *   While in the STOP_COPY state the device has the same behavior as ST=
OP
> + *   with the addition that the data transfers session continues to stre=
am the
> + *   migration state. End of stream on the FD indicates the entire devic=
e
> + *   state has been transferred.
> + *
> + *   The user should take steps to restrict access to vfio device region=
s while
> + *   the device is in STOP_COPY or risk corruption of the device migrati=
on
> data
> + *   stream.

Restricting access has been explained in the to-STOP arcs and it is stated=
=20
that while in STOP_COPY the device has the same behavior as STOP. So=20
I think the last paragraph is possibly not required.

> + *
> + * STOP -> RESUMING
> + *   Entering the RESUMING state starts a process of restoring the devic=
e
> + *   state and will return a new data_fd. The data stream fed into the
> data_fd
> + *   should be taken from the data transfer output of the saving group s=
tates

No definition of 'group state' (maybe introduced in a later patch?)

> + *   from a compatible device. The migration driver may alter/reset the
> + *   internal device state for this arc if required to prepare the devic=
e to
> + *   receive the migration data.
> + *

Thanks
Kevin
