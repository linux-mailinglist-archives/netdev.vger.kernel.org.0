Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D95B557EAC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiFWPdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 11:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiFWPde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 11:33:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5378B2C653
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655998410; x=1687534410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tmT8NbT5cwOMwwyiB01mwiSVIgGbiy3KdylqtpQvSGY=;
  b=UkyeVDP1+/p+9y8l0FIqk4gAUzgIBk4mrqw4XzPreasqpAepajeUtBdh
   B+xFN3ehlTMi65m5oMJYx60m9edgEZ/bP8tBVVc/CUQjRY8v62/fXiP4K
   tARzFh2+Cuh+gdpg8xhBJxR9wt++BcYDvme4coGUcu1gaVvyS/7H48Frb
   WJF/6HLfEAFndqgA+nJhMa6rUqgxJ/qDMfK+LN9tVNaKBUabIphcG//oP
   7rn6P/6KnK5USWwl9DlttQ6RPcNred10u+fsqw2/72qSuGvy65L1Ai0MW
   t8wEpJZGFQoHZ7vA3W4qui+FU8XCvAAtaKsiiOXyx0MOlZsNvGyoIhSCe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="278301203"
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="278301203"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 08:33:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="678104714"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jun 2022 08:33:29 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 08:33:29 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 08:33:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 08:33:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 08:33:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKgCzW2ulBrCQXQm0sep3CNxGEWyEa5f6Zfjvx4a7yoWFG++bJIp3tcAD/zliTfl8Idbt1PUUBxrS6Myb95ytqkwvPqHF0K5C3k42rv4mm7YBb0cCh7CFIREr+Qov1W67FadfzNmL3fz/txfYgEZnL28S18E5qzYgPRzIQuH+p09GsEyUgqIucU0q5tqUBP0UBdeyxNUtKyXAlKHgT/jTo64SiZT8W+y+uL74rg7A39v4wcR38PBtd7AA0YVHXm1wT/lwCI83XothtY8TAjREwclxzeAKNhwgIxnFF266m1/IlOT8u3uqTAMW/LR1KWIKGwLeh10OrnrK+9s0yhuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69h9WTV44gddcsQMJ48Q4mjFyjm/PTDcvMLfKTt+05E=;
 b=aZ49BXwYjL4BP0sQMljUDCq5L8d2XJv5TJY6c0edYwF4Y6M1rdSrTdAb3hGhTE9QqLIHp5Wxc43mn6DkzPsXAA98HZUylXmlopXUMXmOjhkbYvkX9pxyD49ysaXtqcKLqt9f8YUz4vwqdwEi8MrCGVj6F6YzLLD0dFJZGRz0koH47mNU+n7ECzzlkK3h8pMsPv8NIhhY/BNlk71c1paHGEm3MCq/YWs/Lqs97rhEd2nqZbcPb92iIhhkFM/AL2EQ3aS+LeZHyfoDIloI6+DVDrNsdsOKZdXLoJUYlLw7eSsAAzyUAGz0hb6N8uoW/4lBbsfnUYESDxw0N/pA6Y83LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM5PR11MB1498.namprd11.prod.outlook.com (2603:10b6:4:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Thu, 23 Jun 2022 15:33:25 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%4]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 15:33:25 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Thread-Index: AQHYhpxJ2Syh50hy706ooWW0d2tMpK1dHSMw
Date:   Thu, 23 Jun 2022 15:33:25 +0000
Message-ID: <DM6PR11MB46579C692B75DEF81530B7339BB59@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-2-vfedorenko@novek.ru>
In-Reply-To: <20220623005717.31040-2-vfedorenko@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4b61da3-97c1-4d83-d20f-08da552db6db
x-ms-traffictypediagnostic: DM5PR11MB1498:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9kd5VVspXGYLIJ7zrsNkXHuCJV4KbjiVyK6/v66BNYf4EHIxKZOj3HZd3HWYvlamfOn7CUrex3XpZrtVpV759cL9Jd3wDKywu0aSPc9MbMuvstw9vK4nGEOdCs8eysnsw7ThXZxfJXM0+yNnBnieHELPMBsULJ/vTyMu609uhNF0r3v8WUkRo6+13bReSrPznXgerDCcKWPQFeRBUs9KTm/FD184lMMF/LSn6otpbrpjzAO1CStqD8DGWftXZAt8TDPUeCuW5p1BH11eISGWE8reMKFtWTMHpTANw76wS5u9A/bG/hujm4MhDcoqwEugIrMdTSg3AUGGgN7UsU6mO84afDDSfCf9DfE5g1NzOT/CD/yy51airzbYJw2IMu/7HzUi/8Z4ln5mrkMQ9cP+pFYdgc9albk6TQyT9d/VOpve0mppOyAjJlTsFxP22kvHaPyzH148gQCR07c4BpFBzO1x0kIlirJyNpWPIJ/h5jLmMVWI7MHSO8Ida3NyhpC/f4w5XGsDSXUeeAqWC1nFi6cba63BtBaCj8O50TZRWXPMBCRfLNITEM8eFoVjdVlAd3NyJK1HEw4yPTl/0TGuXjsI1uCjGbCgEPWFn0gaHIlURJOBFo2yGD7YOnQAMauDJjy5uEZOLnyf6utUn7cJGXlHVJTimNbck+c15p296RGocrVCGuL4zRHIwqGPwIj3pTcL5fCJisCs+ueDbRxyRBPzYAdjNUyJqKd84rACbqxsfPCbQuWVXn3Rc6uHUsYo4NX6Zo4SqeFn2v98725afA0edCs8J4YTfwBP3WSRcQ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(376002)(396003)(6506007)(33656002)(8936002)(76116006)(2906002)(8676002)(66946007)(26005)(66476007)(4326008)(64756008)(5660300002)(71200400001)(86362001)(54906003)(110136005)(9686003)(478600001)(30864003)(66446008)(52536014)(7696005)(316002)(66556008)(186003)(55016003)(41300700001)(122000001)(83380400001)(82960400001)(38070700005)(38100700002)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AKQBACW3775gTwRfhLAOHlksX5NW40ZdwqWi7+VN+bceEsK682zbrYhCrC1f?=
 =?us-ascii?Q?jSPJeQG4kwIg5MTizj/DT86DgvecjdHt8dPYifZhYnz9xdm6xLXTYzisEyR4?=
 =?us-ascii?Q?PO7+peWusoNp5zjY7AO7lCVmwaQIQ/VbtOqAm8bm2y/+kXxOqT1AbEN2zXJd?=
 =?us-ascii?Q?RRjALlSdkIixyj2OifkCDfC56NLOamT3O/1fxmeSK+gdlmdNqSDwoRMrM8tC?=
 =?us-ascii?Q?c36T7/obVoAodyYOqMOYVtlnCeFpAZMU4UWn6UzkH0SBzAjSY/4MMF8nu2EC?=
 =?us-ascii?Q?InQu4sS3KPpo8+JugBc+3tFUPdg1ZyKapuDi+toxIXz1mOTmYVpRV0HnAcRC?=
 =?us-ascii?Q?rUHt+6dp/6RBqV7WHexxRFVDtCjnrsBut7gsKatiIIDuebni1VfmLYoQkX4r?=
 =?us-ascii?Q?FkdFX0WY87nUgqifPNX6Wss4DXsV98o2b0J4/n7j0ITAsd4VHAHepCv4o9TM?=
 =?us-ascii?Q?X6vCiy3ntGtnhflspQznQM4/F81fRgTjQE/zSnbfOqtsNbrOeSGcBSfEI/V8?=
 =?us-ascii?Q?J5dZ1yDAO/d/NvWlB87hVX0OLXjk829WCl4iMi/9DRfok2sqlaVPGd7DH0mn?=
 =?us-ascii?Q?cC32MfwT22KHdGHcF8r9YNggDxwDNErAP8jBKFvBYd0f3SzkhzRVLhrNzukM?=
 =?us-ascii?Q?hJpJStoa925XRZpJDTW7o9felqAhYQKU9ug5PgKSOoNxADW808ncG6nerZAm?=
 =?us-ascii?Q?wKEr9fAw92uFdKc7FJQlfCp9vvQh7B5voUmC+HQ/uPXpcLY22AXXRYZiQG4e?=
 =?us-ascii?Q?nJL3J251d+hahTaw49rafbwynfb/V1k+8+V81dW2uBEyV9cZA66Fj8Hy0Co0?=
 =?us-ascii?Q?FGvTZaOZqTWNDW/9e78uQ0ry5L1dyGmpDm/AJNspWlvvoq1gkjfWvn694R8J?=
 =?us-ascii?Q?PPC8WpgCbElbf531ZqSpVO4Hs2H64GmEkdRo0RVy54bj0+h3lhXQLS2y2VQY?=
 =?us-ascii?Q?XcYk557m3uZxdlZ+E5C1QjNgtVr7bplLaRPifGUKAw9KW/15lWsgMuYBOi9m?=
 =?us-ascii?Q?fwnUn8QZb6+vS3LxZ4wPVuxeyJH8ABr+I1ykSemHHMqbz5dPt2Se3V1YdJnT?=
 =?us-ascii?Q?3OYY+TbWAxP4tkMeU967gyUQHmjwO4hbpqhCsZW3NzTRFeBW86Zw2MWh9ywk?=
 =?us-ascii?Q?pyIu3q/UFtgwtP7Ql7WUSom3DxwG6LoJhcYLQXl+862ViG1ZqPk3ZpWa+a7u?=
 =?us-ascii?Q?aPG8+M1Fi7r0yC8N5TbqBAqH0pLY04luW204+omek0Nh+P2lpSKEM+ou7k93?=
 =?us-ascii?Q?oLZeguKJh3+QMSkyrIg3iwwPel3m4stM9I5e42QdCNR6X4cA8Hm+NeQMTXj0?=
 =?us-ascii?Q?YS3HtE1Wev64B53FuBS9dI1yDXRUdyP0fCA+bEBQObUZeAYC3/59eChEp4vg?=
 =?us-ascii?Q?en4gwBThZ+jTTuTqpFjk/YYg6RK3s7oyuHAJOVOLStK2o003B4+oDT3aNrph?=
 =?us-ascii?Q?5aZ8kTWT/flIygg8qPkUjBCbzTLGOi9wU4eY5iK4Zcc+KrUAzruOHX5o9O/y?=
 =?us-ascii?Q?IurQkx59OH4MAboN0M9daGcCQBtxTP7V9blZnER59v9neMqeme4URPbBf2gs?=
 =?us-ascii?Q?djJ9VTMcZ0ubmQGGJTEnGS0rsYurc7sOw5ZdYk+5QI1sy8ebSYu7DqNYjN3a?=
 =?us-ascii?Q?e0YlhLhX9VXYzZQCjbu/YGFmn9h6pghreNfdJJsV/IaXmQzzLu7OcMU5cwMw?=
 =?us-ascii?Q?pMelVza9icQorOBtslDBiYSNrERhxTEu8AU37uMSpeHasFgsn/y/J5hhzliH?=
 =?us-ascii?Q?ft8GpVqJQe+wsvQlSDGOaFxYsVib9Xs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b61da3-97c1-4d83-d20f-08da552db6db
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 15:33:25.5626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hWrRuCwYFrLedPBHlMWcWZ6q32ahFQ/CN/sAuCSDNAJ0KlbwilUisVvXlJUl+s0OKQ2fqHMBjBjGE/hLN/1gzwGn3z81w7pOHH6h5rvLJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1498
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

Great work!

Although, I've been thinking that you already forget about it, so I have
started development of something similar.


-----Original Message-----
From: Vadim Fedorenko <vfedorenko@novek.ru>=20
Sent: Thursday, June 23, 2022 2:57 AM
>=20
> From: Vadim Fedorenko <vadfed@fb.com>
>=20
> DPLL framework is used to represent and configure DPLL devices
> in systems. Each device that has DPLL and can configure sources
> and outputs can use this framework.
>=20
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> ---
>  MAINTAINERS                 |   8 +
>  drivers/Kconfig             |   2 +
>  drivers/Makefile            |   1 +
>  drivers/dpll/Kconfig        |   7 +
>  drivers/dpll/Makefile       |   7 +
>  drivers/dpll/dpll_core.c    | 152 +++++++++++++
>  drivers/dpll/dpll_core.h    |  40 ++++
>  drivers/dpll/dpll_netlink.c | 437 ++++++++++++++++++++++++++++++++++++
>  drivers/dpll/dpll_netlink.h |   7 +
>  include/linux/dpll.h        |  25 +++
>  include/uapi/linux/dpll.h   |  77 +++++++
>  11 files changed, 763 insertions(+)
>  create mode 100644 drivers/dpll/Kconfig
>  create mode 100644 drivers/dpll/Makefile
>  create mode 100644 drivers/dpll/dpll_core.c
>  create mode 100644 drivers/dpll/dpll_core.h
>  create mode 100644 drivers/dpll/dpll_netlink.c
>  create mode 100644 drivers/dpll/dpll_netlink.h
>  create mode 100644 include/linux/dpll.h
>  create mode 100644 include/uapi/linux/dpll.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 05fcbea3e432..5532130baf36 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6122,6 +6122,14 @@ F:	Documentation/networking/device_drivers/etherne=
t/freescale/dpaa2/switch-drive
>  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>  F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
> =20
> +DPLL CLOCK SUBSYSTEM
> +M:	Vadim Fedorenko <vadfed@fb.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/dpll/*
> +F:	include/net/dpll.h
> +F:	include/uapi/linux/dpll.h
> +
>  DPT_I2O SCSI RAID DRIVER
>  M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
>  L:	linux-scsi@vger.kernel.org
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index b6a172d32a7d..dcdc23116eb8 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
> =20
>  source "drivers/hte/Kconfig"
> =20
> +source "drivers/dpll/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 9a30842b22c5..acc370a2cda6 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -189,3 +189,4 @@ obj-$(CONFIG_COUNTER)		+=3D counter/
>  obj-$(CONFIG_MOST)		+=3D most/
>  obj-$(CONFIG_PECI)		+=3D peci/
>  obj-$(CONFIG_HTE)		+=3D hte/
> +obj-$(CONFIG_DPLL)		+=3D dpll/
> diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
> new file mode 100644
> index 000000000000..a4cae73f20d3
> --- /dev/null
> +++ b/drivers/dpll/Kconfig
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Generic DPLL drivers configuration
> +#
> +
> +config DPLL
> +  bool

for RFC help and default were ommited?

> diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
> new file mode 100644
> index 000000000000..0748c80097e4
> --- /dev/null
> +++ b/drivers/dpll/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for DPLL drivers.
> +#
> +
> +obj-$(CONFIG_DPLL)          +=3D dpll_sys.o
> +dpll_sys-y                  +=3D dpll_core.o dpll_netlink.o
> diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
> new file mode 100644
> index 000000000000..e34767e723cf
> --- /dev/null
> +++ b/drivers/dpll/dpll_core.c
> @@ -0,0 +1,152 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *  dpll_core.c - Generic DPLL Management class support.
> + *
> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +
> +#include "dpll_core.h"
> +
> +static DEFINE_MUTEX(dpll_device_xa_lock);
> +static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
> +#define DPLL_REGISTERED XA_MARK_1
> +
> +#define ASSERT_DPLL_REGISTERED(d)                                       =
    \
> +	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
> +#define ASSERT_DPLL_NOT_REGISTERED(d)                                   =
   \
> +	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
> +
> +
> +int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *)=
, void *data)
> +{
> +	struct dpll_device *dpll;
> +	unsigned long index;
> +	int ret =3D 0;
> +
> +	mutex_lock(&dpll_device_xa_lock);
> +	xa_for_each_start(&dpll_device_xa, index, dpll, id) {
> +		if (!xa_get_mark(&dpll_device_xa, index, DPLL_REGISTERED))
> +			continue;
> +		ret =3D cb(dpll, data);
> +		if (ret)
> +			break;
> +	}
> +	mutex_unlock(&dpll_device_xa_lock);
> +
> +	return ret;
> +}
> +
> +struct dpll_device *dpll_device_get_by_id(int id)
> +{
> +	struct dpll_device *dpll =3D NULL;
> +
> +	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
> +		dpll =3D xa_load(&dpll_device_xa, id);
> +	return dpll;
> +}
> +
> +void *dpll_priv(struct dpll_device *dpll)
> +{
> +	return dpll->priv;
> +}
> +EXPORT_SYMBOL_GPL(dpll_priv);
> +
> +static void dpll_device_release(struct device *dev)
> +{
> +	struct dpll_device *dpll;
> +
> +	dpll =3D to_dpll_device(dev);
> +
> +	dpll_device_unregister(dpll);
> +
> +	mutex_destroy(&dpll->lock);
> +	kfree(dpll);
> +}
> +
> +static struct class dpll_class =3D {
> +	.name =3D "dpll",
> +	.dev_release =3D dpll_device_release,
> +};
> +
> +struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int s=
ources_count,
> +					 int outputs_count, void *priv)
> +{
> +	struct dpll_device *dpll;
> +	int ret;
> +
> +	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
> +	if (!dpll)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_init(&dpll->lock);
> +	dpll->ops =3D ops;
> +	dpll->dev.class =3D &dpll_class;
> +	dpll->sources_count =3D sources_count;
> +	dpll->outputs_count =3D outputs_count;
> +
> +	mutex_lock(&dpll_device_xa_lock);
> +	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b, GFP_KE=
RNEL);
> +	if (ret)
> +		goto error;
> +	dev_set_name(&dpll->dev, "dpll%d", dpll->id);
> +	mutex_unlock(&dpll_device_xa_lock);
> +	dpll->priv =3D priv;
> +
> +	return dpll;
> +
> +error:
> +	mutex_unlock(&dpll_device_xa_lock);
> +	kfree(dpll);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(dpll_device_alloc);
> +
> +void dpll_device_register(struct dpll_device *dpll)
> +{
> +	ASSERT_DPLL_NOT_REGISTERED(dpll);
> +
> +	mutex_lock(&dpll_device_xa_lock);
> +	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
> +	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
> +	mutex_unlock(&dpll_device_xa_lock);
> +}
> +EXPORT_SYMBOL_GPL(dpll_device_register);
> +
> +void dpll_device_unregister(struct dpll_device *dpll)
> +{
> +	ASSERT_DPLL_REGISTERED(dpll);
> +
> +	mutex_lock(&dpll_device_xa_lock);
> +	xa_erase(&dpll_device_xa, dpll->id);
> +	mutex_unlock(&dpll_device_xa_lock);
> +}
> +EXPORT_SYMBOL_GPL(dpll_device_unregister);
> +
> +static int __init dpll_init(void)
> +{
> +	int ret;
> +
> +	ret =3D dpll_netlink_init();
> +	if (ret)
> +		goto error;
> +
> +	ret =3D class_register(&dpll_class);
> +	if (ret)
> +		goto unregister_netlink;
> +
> +	return 0;
> +
> +unregister_netlink:
> +	dpll_netlink_finish();
> +error:
> +	mutex_destroy(&dpll_device_xa_lock);
> +	return ret;
> +}
> +subsys_initcall(dpll_init);
> diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
> new file mode 100644
> index 000000000000..5ad3224d5caf
> --- /dev/null
> +++ b/drivers/dpll/dpll_core.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
> + */
> +
> +#ifndef __DPLL_CORE_H__
> +#define __DPLL_CORE_H__
> +
> +#include <linux/dpll.h>
> +
> +#include "dpll_netlink.h"
> +
> +/**
> + * struct dpll_device - structure for a DPLL device
> + * @id:		unique id number for each edvice
> + * @dev:	&struct device for this dpll device
> + * @sources_count:	amount of input sources this dpll_device supports
> + * @outputs_count:	amount of outputs this dpll_device supports
> + * @ops:	operations this &dpll_device supports
> + * @lock:	mutex to serialize operations
> + * @priv:	pointer to private information of owner
> + */
> +struct dpll_device {
> +	int id;
> +	struct device dev;
> +	int sources_count;
> +	int outputs_count;
> +	struct dpll_device_ops *ops;
> +	struct mutex lock;
> +	void *priv;
> +};
> +
> +#define to_dpll_device(_dev) \
> +	container_of(_dev, struct dpll_device, dev)
> +
> +int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *)=
,
> +			  void *data);
> +struct dpll_device *dpll_device_get_by_id(int id);
> +void dpll_device_unregister(struct dpll_device *dpll);
> +#endif
> diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
> new file mode 100644
> index 000000000000..0bbdaa6dde8e
> --- /dev/null
> +++ b/drivers/dpll/dpll_netlink.c
> @@ -0,0 +1,437 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Generic netlink for DPLL management framework
> + *
> + * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <net/genetlink.h>
> +#include "dpll_core.h"
> +
> +#include <uapi/linux/dpll.h>
> +
> +static const struct genl_multicast_group dpll_genl_mcgrps[] =3D {
> +	{ .name =3D DPLL_CONFIG_DEVICE_GROUP_NAME, },
> +	{ .name =3D DPLL_CONFIG_SOURCE_GROUP_NAME, },
> +	{ .name =3D DPLL_CONFIG_OUTPUT_GROUP_NAME, },
> +	{ .name =3D DPLL_MONITOR_GROUP_NAME,  },
> +};
> +
> +static const struct nla_policy dpll_genl_get_policy[] =3D {
> +	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
> +	[DPLLA_DEVICE_NAME]	=3D { .type =3D NLA_STRING,
> +				    .len =3D DPLL_NAME_LENGTH },
> +	[DPLLA_FLAGS]		=3D { .type =3D NLA_U32 },
> +};
> +
> +static const struct nla_policy dpll_genl_set_source_policy[] =3D {
> +	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
> +	[DPLLA_SOURCE_ID]	=3D { .type =3D NLA_U32 },
> +	[DPLLA_SOURCE_TYPE]	=3D { .type =3D NLA_U32 },
> +};
> +
> +static const struct nla_policy dpll_genl_set_output_policy[] =3D {
> +	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
> +	[DPLLA_OUTPUT_ID]	=3D { .type =3D NLA_U32 },
> +	[DPLLA_OUTPUT_TYPE]	=3D { .type =3D NLA_U32 },
> +};
> +
> +struct param {
> +	struct netlink_callback *cb;
> +	struct dpll_device *dpll;
> +	struct nlattr **attrs;
> +	struct sk_buff *msg;
> +	int dpll_id;
> +	int dpll_source_id;
> +	int dpll_source_type;
> +	int dpll_output_id;
> +	int dpll_output_type;
> +};
> +
> +struct dpll_dump_ctx {
> +	struct dpll_device *dev;
> +	int flags;
> +	int pos_idx;
> +	int pos_src_idx;
> +	int pos_out_idx;
> +};
> +
> +typedef int (*cb_t)(struct param *);
> +
> +static struct genl_family dpll_gnl_family;
> +
> +static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *=
cb)
> +{
> +	return (struct dpll_dump_ctx *)cb->ctx;
> +}
> +
> +static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
> +					   struct sk_buff *msg)
> +{
> +	if (nla_put_u32(msg, DPLLA_DEVICE_ID, dpll->id))
> +		return -EMSGSIZE;
> +
> +	if (nla_put_string(msg, DPLLA_DEVICE_NAME, dev_name(&dpll->dev)))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
> +					   struct sk_buff *msg)
> +{
> +	struct nlattr *src_attr;
> +	int i, ret =3D 0, type;
> +
> +	for (i =3D 0; i < dpll->sources_count; i++) {
> +		src_attr =3D nla_nest_start(msg, DPLLA_SOURCE);
> +		if (!src_attr) {
> +			ret =3D -EMSGSIZE;
> +			break;
> +		}
> +		type =3D dpll->ops->get_source_type(dpll, i);
> +		if (nla_put_u32(msg, DPLLA_SOURCE_ID, i) ||
> +		    nla_put_u32(msg, DPLLA_SOURCE_TYPE, type)) {
> +			nla_nest_cancel(msg, src_attr);
> +			ret =3D -EMSGSIZE;
> +			break;
> +		}
> +		nla_nest_end(msg, src_attr);
> +	}
> +
> +	return ret;
> +}
> +
> +static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
> +					   struct sk_buff *msg)
> +{
> +	struct nlattr *out_attr;
> +	int i, ret =3D 0, type;
> +
> +	for (i =3D 0; i < dpll->outputs_count; i++) {
> +		out_attr =3D nla_nest_start(msg, DPLLA_OUTPUT);
> +		if (!out_attr) {
> +			ret =3D -EMSGSIZE;
> +			break;
> +		}
> +		type =3D dpll->ops->get_source_type(dpll, i);
> +		if (nla_put_u32(msg, DPLLA_OUTPUT_ID, i) ||
> +		    nla_put_u32(msg, DPLLA_OUTPUT_TYPE, type)) {
> +			nla_nest_cancel(msg, out_attr);
> +			ret =3D -EMSGSIZE;
> +			break;
> +		}
> +		nla_nest_end(msg, out_attr);
> +	}
> +
> +	return ret;
> +}
> +
> +static int __dpll_cmd_dump_status(struct dpll_device *dpll,
> +					   struct sk_buff *msg)
> +{
> +	int ret;
> +
> +	if (!dpll->ops->get_status && !dpll->ops->get_temp && !dpll->ops->get_l=
ock_status)
> +		return 0;

what if dpll doesn't support one of those commands?

> +
> +	if (dpll->ops->get_status) {
> +		ret =3D dpll->ops->get_status(dpll);
> +		if (nla_put_u32(msg, DPLLA_STATUS, ret))
> +			return -EMSGSIZE;
> +	}
> +
> +	if (dpll->ops->get_temp) {
> +		ret =3D dpll->ops->get_status(dpll);
> +		if (nla_put_u32(msg, DPLLA_TEMP, ret))
> +			return -EMSGSIZE;
> +	}

shouldn't be get_temp(dpll)?

> +
> +	if (dpll->ops->get_lock_status) {
> +		ret =3D dpll->ops->get_lock_status(dpll);
> +		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
> +			return -EMSGSIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dpll_device_dump_one(struct dpll_device *dev, struct sk_buff =
*msg, int flags)
> +{
> +	struct nlattr *hdr;
> +	int ret;
> +
> +	hdr =3D nla_nest_start(msg, DPLLA_DEVICE);
> +	if (!hdr)
> +		return -EMSGSIZE;
> +
> +	mutex_lock(&dev->lock);
> +	ret =3D __dpll_cmd_device_dump_one(dev, msg);
> +	if (ret)
> +		goto out_cancel_nest;
> +
> +	if (flags & DPLL_FLAG_SOURCES && dev->ops->get_source_type) {
> +		ret =3D __dpll_cmd_dump_sources(dev, msg);
> +		if (ret)
> +			goto out_cancel_nest;
> +	}
> +
> +	if (flags & DPLL_FLAG_OUTPUTS && dev->ops->get_output_type) {
> +		ret =3D __dpll_cmd_dump_outputs(dev, msg);
> +		if (ret)
> +			goto out_cancel_nest;
> +	}
> +
> +	if (flags & DPLL_FLAG_STATUS) {
> +		ret =3D __dpll_cmd_dump_status(dev, msg);
> +		if (ret)
> +			goto out_cancel_nest;
> +	}
> +
> +	mutex_unlock(&dev->lock);
> +	nla_nest_end(msg, hdr);
> +
> +	return 0;
> +
> +out_cancel_nest:
> +	mutex_unlock(&dev->lock);
> +	nla_nest_cancel(msg, hdr);
> +
> +	return ret;
> +}
> +
> +static int dpll_genl_cmd_set_source(struct param *p)
> +{
> +	const struct genl_dumpit_info *info =3D genl_dumpit_info(p->cb);
> +	struct dpll_device *dpll =3D p->dpll;
> +	int ret =3D 0, src_id, type;
> +
> +	if (!info->attrs[DPLLA_SOURCE_ID] ||
> +	    !info->attrs[DPLLA_SOURCE_TYPE])
> +		return -EINVAL;
> +
> +	if (!dpll->ops->set_source_type)
> +		return -EOPNOTSUPP;
> +
> +	src_id =3D nla_get_u32(info->attrs[DPLLA_SOURCE_ID]);
> +	type =3D nla_get_u32(info->attrs[DPLLA_SOURCE_TYPE]);
> +
> +	mutex_lock(&dpll->lock);
> +	ret =3D dpll->ops->set_source_type(dpll, src_id, type);
> +	mutex_unlock(&dpll->lock);
> +
> +	return ret;
> +}
> +
> +static int dpll_genl_cmd_set_output(struct param *p)
> +{
> +	const struct genl_dumpit_info *info =3D genl_dumpit_info(p->cb);
> +	struct dpll_device *dpll =3D p->dpll;
> +	int ret =3D 0, out_id, type;
> +
> +	if (!info->attrs[DPLLA_OUTPUT_ID] ||
> +	    !info->attrs[DPLLA_OUTPUT_TYPE])
> +		return -EINVAL;
> +
> +	if (!dpll->ops->set_output_type)
> +		return -EOPNOTSUPP;
> +
> +	out_id =3D nla_get_u32(info->attrs[DPLLA_OUTPUT_ID]);
> +	type =3D nla_get_u32(info->attrs[DPLLA_OUTPUT_TYPE]);
> +
> +	mutex_lock(&dpll->lock);
> +	ret =3D dpll->ops->set_source_type(dpll, out_id, type);
> +	mutex_unlock(&dpll->lock);
> +
> +	return ret;
> +}
> +
> +static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
> +{
> +	struct dpll_dump_ctx *ctx;
> +	struct param *p =3D (struct param *)data;
> +
> +	ctx =3D dpll_dump_context(p->cb);
> +
> +	ctx->pos_idx =3D dpll->id;
> +
> +	return dpll_device_dump_one(dpll, p->msg, ctx->flags);
> +}
> +
> +static int dpll_cmd_device_dump(struct param *p)
> +{
> +	struct dpll_dump_ctx *ctx =3D dpll_dump_context(p->cb);
> +
> +	return for_each_dpll_device(ctx->pos_idx, dpll_device_loop_cb, p);
> +}
> +
> +static int dpll_genl_cmd_device_get_id(struct param *p)
> +{
> +	struct dpll_device *dpll =3D p->dpll;
> +	int flags =3D 0;
> +
> +	if (p->attrs[DPLLA_FLAGS])
> +		flags =3D nla_get_u32(p->attrs[DPLLA_FLAGS]);
> +
> +	return dpll_device_dump_one(dpll, p->msg, flags);
> +}
> +
> +static cb_t cmd_doit_cb[] =3D {
> +	[DPLL_CMD_DEVICE_GET]		=3D dpll_genl_cmd_device_get_id,
> +	[DPLL_CMD_SET_SOURCE_TYPE]	=3D dpll_genl_cmd_set_source,
> +	[DPLL_CMD_SET_OUTPUT_TYPE]	=3D dpll_genl_cmd_set_output,
> +};
> +
> +static cb_t cmd_dump_cb[] =3D {
> +	[DPLL_CMD_DEVICE_GET]		=3D dpll_cmd_device_dump,
> +};
> +
> +static int dpll_genl_cmd_start(struct netlink_callback *cb)
> +{
> +	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
> +	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
> +
> +	ctx->dev =3D NULL;
> +	if (info->attrs[DPLLA_FLAGS])
> +		ctx->flags =3D nla_get_u32(info->attrs[DPLLA_FLAGS]);
> +	else
> +		ctx->flags =3D 0;
> +	ctx->pos_idx =3D 0;
> +	ctx->pos_src_idx =3D 0;
> +	ctx->pos_out_idx =3D 0;
> +	return 0;
> +}
> +
> +static int dpll_genl_cmd_dumpit(struct sk_buff *skb,
> +				   struct netlink_callback *cb)
> +{
> +	struct param p =3D { .cb =3D cb, .msg =3D skb };
> +	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
> +	int cmd =3D info->op.cmd;
> +	int ret;
> +	void *hdr;
> +
> +	hdr =3D genlmsg_put(skb, 0, 0, &dpll_gnl_family, 0, cmd);
> +	if (!hdr)
> +		return -EMSGSIZE;
> +
> +	ret =3D cmd_dump_cb[cmd](&p);
> +	if (ret)
> +		goto out_cancel_msg;
> +
> +	genlmsg_end(skb, hdr);
> +
> +	return 0;
> +
> +out_cancel_msg:
> +	genlmsg_cancel(skb, hdr);
> +
> +	return ret;
> +}
> +
> +static int dpll_genl_cmd_doit(struct sk_buff *skb,
> +				 struct genl_info *info)
> +{
> +	struct param p =3D { .attrs =3D info->attrs, .dpll =3D info->user_ptr[0=
] };
> +	int cmd =3D info->genlhdr->cmd;
> +	struct sk_buff *msg;
> +	void *hdr;
> +	int ret;
> +
> +	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +	p.msg =3D msg;
> +
> +	hdr =3D genlmsg_put_reply(msg, info, &dpll_gnl_family, 0, cmd);
> +	if (!hdr) {
> +		ret =3D -EMSGSIZE;
> +		goto out_free_msg;
> +	}
> +
> +	ret =3D cmd_doit_cb[cmd](&p);
> +	if (ret)
> +		goto out_cancel_msg;
> +
> +	genlmsg_end(msg, hdr);
> +
> +	return genlmsg_reply(msg, info);
> +
> +out_cancel_msg:
> +	genlmsg_cancel(msg, hdr);
> +out_free_msg:
> +	nlmsg_free(msg);
> +
> +	return ret;
> +}
> +
> +static int dpll_pre_doit(const struct genl_ops *ops, struct sk_buff *skb=
,
> +						 struct genl_info *info)
> +{
> +	struct dpll_device *dpll;
> +	int id;
> +
> +	if (!info->attrs[DPLLA_DEVICE_ID])
> +		return -EINVAL;
> +	id =3D nla_get_u32(info->attrs[DPLLA_DEVICE_ID]);
> +
> +	dpll =3D dpll_device_get_by_id(id);
> +	if (!dpll)
> +		return -ENODEV;
> +	info->user_ptr[0] =3D dpll;
> +
> +	return 0;
> +}
> +
> +static const struct genl_ops dpll_genl_ops[] =3D {
> +	{
> +		.cmd	=3D DPLL_CMD_DEVICE_GET,
> +		.start	=3D dpll_genl_cmd_start,
> +		.dumpit	=3D dpll_genl_cmd_dumpit,
> +		.doit	=3D dpll_genl_cmd_doit,
> +		.policy	=3D dpll_genl_get_policy,
> +		.maxattr =3D ARRAY_SIZE(dpll_genl_get_policy) - 1,
> +	},
> +	{
> +		.cmd	=3D DPLL_CMD_SET_SOURCE_TYPE,
> +		.flags	=3D GENL_UNS_ADMIN_PERM,
> +		.doit	=3D dpll_genl_cmd_doit,
> +		.policy	=3D dpll_genl_set_source_policy,
> +		.maxattr =3D ARRAY_SIZE(dpll_genl_set_source_policy) - 1,
> +	},
> +	{
> +		.cmd	=3D DPLL_CMD_SET_OUTPUT_TYPE,
> +		.flags	=3D GENL_UNS_ADMIN_PERM,
> +		.doit	=3D dpll_genl_cmd_doit,
> +		.policy	=3D dpll_genl_set_output_policy,
> +		.maxattr =3D ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
> +	},
> +};
> +
> +static struct genl_family dpll_gnl_family __ro_after_init =3D {
> +	.hdrsize	=3D 0,
> +	.name		=3D DPLL_FAMILY_NAME,
> +	.version	=3D DPLL_VERSION,
> +	.ops		=3D dpll_genl_ops,
> +	.n_ops		=3D ARRAY_SIZE(dpll_genl_ops),
> +	.mcgrps		=3D dpll_genl_mcgrps,
> +	.n_mcgrps	=3D ARRAY_SIZE(dpll_genl_mcgrps),
> +	.pre_doit	=3D dpll_pre_doit,
> +};
> +
> +int __init dpll_netlink_init(void)
> +{
> +	return genl_register_family(&dpll_gnl_family);
> +}
> +
> +void dpll_netlink_finish(void)
> +{
> +	genl_unregister_family(&dpll_gnl_family);
> +}
> +
> +void __exit dpll_netlink_fini(void)
> +{
> +	dpll_netlink_finish();
> +}
> diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
> new file mode 100644
> index 000000000000..e2d100f59dd6
> --- /dev/null
> +++ b/drivers/dpll/dpll_netlink.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
> + */
> +
> +int __init dpll_netlink_init(void);
> +void dpll_netlink_finish(void);
> diff --git a/include/linux/dpll.h b/include/linux/dpll.h
> new file mode 100644
> index 000000000000..9051337bcf9e
> --- /dev/null
> +++ b/include/linux/dpll.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
> + */
> +
> +#ifndef __DPLL_H__
> +#define __DPLL_H__
> +
> +struct dpll_device;
> +
> +struct dpll_device_ops {
> +	int (*get_status)(struct dpll_device *dpll);
> +	int (*get_temp)(struct dpll_device *dpll);
> +	int (*get_lock_status)(struct dpll_device *dpll);
> +	int (*get_source_type)(struct dpll_device *dpll, int id);
> +	int (*get_output_type)(struct dpll_device *dpll, int id);
> +	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
> +	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
> +};
> +
> +struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int s=
ources_count,
> +					 int outputs_count, void *priv);
> +void dpll_device_register(struct dpll_device *dpll);
> +void *dpll_priv(struct dpll_device *dpll);
> +#endif
> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
> new file mode 100644
> index 000000000000..8c00f52736ee
> --- /dev/null
> +++ b/include/uapi/linux/dpll.h
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_DPLL_H
> +#define _UAPI_LINUX_DPLL_H
> +
> +#define DPLL_NAME_LENGTH	20
> +
> +/* Adding event notification support elements */
> +#define DPLL_FAMILY_NAME		"dpll"
> +#define DPLL_VERSION			0x01
> +#define DPLL_CONFIG_DEVICE_GROUP_NAME  "config"
> +#define DPLL_CONFIG_SOURCE_GROUP_NAME  "source"
> +#define DPLL_CONFIG_OUTPUT_GROUP_NAME  "output"
> +#define DPLL_MONITOR_GROUP_NAME        "monitor"
> +
> +#define DPLL_FLAG_SOURCES	1
> +#define DPLL_FLAG_OUTPUTS	2
> +#define DPLL_FLAG_STATUS	4
> +
> +/* Attributes of dpll_genl_family */
> +enum dpll_genl_get_attr {
> +	DPLLA_UNSPEC,
> +	DPLLA_DEVICE,
> +	DPLLA_DEVICE_ID,
> +	DPLLA_DEVICE_NAME,
> +	DPLLA_SOURCE,
> +	DPLLA_SOURCE_ID,
> +	DPLLA_SOURCE_TYPE,
> +	DPLLA_OUTPUT,
> +	DPLLA_OUTPUT_ID,
> +	DPLLA_OUTPUT_TYPE,
> +	DPLLA_STATUS,
> +	DPLLA_TEMP,
> +	DPLLA_LOCK_STATUS,
> +	DPLLA_FLAGS,
> +
> +	__DPLLA_MAX,
> +};
> +#define DPLLA_GET_MAX (__DPLLA_MAX - 1)

I think "_get_/_GET_" in above names is outdated?

> +
> +/* DPLL signal types used as source or as output */
> +enum dpll_genl_signal_type {
> +	DPLL_TYPE_EXT_1PPS,
> +	DPLL_TYPE_EXT_10MHZ,
> +	DPLL_TYPE_SYNCE_ETH_PORT,
> +	DPLL_TYPE_INT_OSCILLATOR,
> +	DPLL_TYPE_GNSS,
> +
> +	__DPLL_TYPE_MAX,
> +};
> +#define DPLL_TYPE_MAX (__DPLL_TYPE_MAX - 1)
> +
> +/* Events of dpll_genl_family */
> +enum dpll_genl_event {
> +	DPLL_EVENT_UNSPEC,
> +	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
> +	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
> +	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
> +	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
> +	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
> +	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
> +
> +	__DPLL_EVENT_MAX,
> +};
> +#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
> +
> +/* Commands supported by the dpll_genl_family */
> +enum dpll_genl_cmd {
> +	DPLL_CMD_UNSPEC,
> +	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
> +	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
> +	DPLL_CMD_SET_OUTPUT_TYPE,	/* Get the DPLL device output type */

"Get" in comment description looks like a typo.
I am getting bit confused with the name and comments.
For me, first look says: it is selection of a type of a source.
But in the code I can see it selects a source id and a type.
Type of source originates in HW design, why would the one want to "set" it?
I can imagine a HW design where a single source or output would allow to ch=
oose
where the signal originates/goes, some kind of extra selector layer for a
source/output, but was that the intention?
If so, shouldn't the user get some bitmap/list of modes available for each
source/output?

The user shall get some extra information about the source/output. Right no=
w
there can be multiple sources/outputs of the same type, but not really poss=
ible
to find out their purpose. I.e. a dpll equipped with four source of=20
DPLL_TYPE_EXT_1PPS type.

This implementation looks like designed for a "forced reference lock" mode
where the user must explicitly select one source. But a multi source/output
DPLL could be running in different modes. I believe most important is autom=
atic
mode, where it tries to lock to a user-configured source priority list.
However, there is also freerun mode, where dpll isn't even trying to lock t=
o
anything, or NCO - Numerically Controlled Oscillator mode.=20
It would be great to have ability to select DPLL modes, but also to be able=
 to
configure priorities, read failure status, configure extra "features" (i.e.
Embedded Sync, EEC modes, Fast Lock).

The sources and outputs can also have some extra features or capabilities, =
like:
- enable Embedded Sync
- add phase delay
- configure frequency (user might need to use source/output with different
  frequency then 1 PPS or 10MHz)

Generally, for simple DPLL designs this interface could do the job (althoug=
h,
I still think user needs more information about the sources/outputs), but f=
or
more complex ones, there should be something different, which takes care of=
 my
comments regarding extra configuration needed.

Thanks,
Arkadiusz

> +
> +	__DPLL_CMD_MAX,
> +};
> +#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
> +
> +#endif /* _UAPI_LINUX_DPLL_H */
> --=20
> 2.27.0
>=20
>
