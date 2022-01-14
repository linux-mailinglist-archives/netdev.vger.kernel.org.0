Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A79548E324
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbiANEIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:08:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:41780 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231851AbiANEII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 23:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642133288; x=1673669288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VA6xpRpMhgK2IKZvXRMDKxMJfILHshJRmVSxuySLhZ8=;
  b=CxvUoCWp1On7sJVjoB2n/fEUySJCPPuEdQa9PRA1NYbwx8AOkieLHIH8
   F37+WoS0oomjrUKQYK0UXh8D0LZeS4kxaN+U+yJ4c4mhasRVLs/fKOmAL
   +5Y769K0WVikYrzQ2IEwiJGGj5ADmLDqtvbSblEBehbUa9cfjRJW2ZOvx
   eHABvD57zoDZfvsJkMJtFtQovAaeCipSvrRT3qxv4z/2jELVi7/4LRPtu
   VIoSKVIRY8mhQYMXsVSa4o2L4t9IejzP0ZOsBjRuv3NLiSt5FfsC3pqkf
   PF37V+Mr7fpX2EF9khzGP0dEbztnWA4t6DfJ0ojwUxchLFODpjAzjbg1M
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244382186"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="244382186"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 20:08:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="516212220"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 13 Jan 2022 20:08:05 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 20:08:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 20:08:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 20:08:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agoj9s3KuJtNnl6AQyR3Jkjorcw/wVyw1ijb09KEpSMH9gWL464uxU2tpAxMammW4gbkX7zaDwmQVNm9S9pqq7WIN3Iu7y8lMJzc83FReKtbV2YF0j52kLPzdvcL2ZY4Mznxnw4xDw0EXjlWNS8utbjc1hnXHczG4OOQUVgc+2HRK61Cx1feagN8Kvg5u+xLvgBR2LWU/hYVShSR0Tr9smucToKp0HZWyQ76LX3ACpbKYkO1LfnOek6Qs7O1uMUAMoMHOTfsKQ+TDw+L4EueMiWedhrYg5145a2xJkAhmVlTvQGdvY/r/rDrwJtzJCPGL4VRLwiroviTkAie/uhd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gx+3ULj5Q+hhfkfOfxLVhIypSHq8w+2uJR824CzOpmM=;
 b=GEeoPi9AYydQCoYrX9mux6IxZwygnXhXF38K5d6do7Z4gb/zIUmZsFETbIJBNDHptV0tVjmustugEu0TTcG0kGAJJO1iU5fhLEXwI2wvUk9fl+7nD1RwV9hAJO53IGGMwrLvjN5L+b5oQDSBKzTxjJCjJhEatgSkprck84EohhJTd5n/ccyB6IoqS58z170IP6NwL9ATDSnWzJdIJPf5C2QkP+Yk2j2wEloFKfxVq833hdDDKawXgXgy9PzUm1KEVit23SBRUgk8YHcaH4klisCh/nnxFyGoa6dhNiS8DT59US1yepERXRjK+9aNHgRqmXPJnq4jLTt62GPJvBG7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BN7PR11MB2722.namprd11.prod.outlook.com (2603:10b6:406:b8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 04:08:02 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 04:08:02 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] i40e: Remove useless DMA-32 fallback configuration
Thread-Topic: [PATCH] i40e: Remove useless DMA-32 fallback configuration
Thread-Index: AQHYCPxSNQKagERYUEe91lZJIIAT8A==
Date:   Fri, 14 Jan 2022 04:08:02 +0000
Message-ID: <BYAPR11MB3367C34AB2311D81468B457DFC549@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <869bbf806431086683c64ad32594ff96e85b6aa2.1641749374.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <869bbf806431086683c64ad32594ff96e85b6aa2.1641749374.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 947f87af-ad8f-42f4-86ce-08d9d7137558
x-ms-traffictypediagnostic: BN7PR11MB2722:EE_
x-microsoft-antispam-prvs: <BN7PR11MB2722D28389DC67A4064957ABFC549@BN7PR11MB2722.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zuxTuQIjK+sjYUssVDY9Jyu3CouoGopLWPoLkfCkFshWBUDlQzFrpgmOBdPWuOXRfOTJhW8pffh/VeEpondtOjEtuLIGGgOY4nMn7DuGe7qXjHZJngz6EetQaCrobypbm35CjgJ7OOu5fnoMe+yIOqnQ/dxT4HtzG+IFPPVThw69Vm7inSJo/bcikG+AqnodMJagh5s9deOfslsTK2h7y8ao0y4nkiBPPWPg5MCHsXqSmI0MukpxUbmSTRw5MQNIpmg3AIcM3aYTPujSmCUKUnDwVrH8NhmNgwiYHFkIKllErVDNvV+1AgeDUGzZs3EepOJyu7DbiKKycdPk0YLJ5NTd/8NZOdwa+oAwos4i1AU85UmCC7gu3tdu8gObIy673L/ZvnPzes/bo8WTYw9eihl5Ik5z9Ju+SaUQujyTpMd0+65ivCOSKxdNi768x6M+QEgQKgAeIyWbMoTwXqzotB55EnSQvYmD6aoOV+FVLMs0ogkOdkv9vikpZbhnIQgtLzdEd7UjTlJzS3Mxl6ju4Jg1D2BzFxNDGChpwhgo4yXJLXSD+eDg2mXJZMtTneD2pmXHOCBU/JZQvM9gsZfyhZWUxo4fKSoqtwlVu9ti8zVI4bSQzfkHtx0LmmQsBvLJddUCy1O4uWowNO832HExZoZemeKx8H4BYMfiv1UKd8QavKLusU10XuWynB5HIOndKxDE8iQNonvwTb0PRAZPI3ZaDbDXqP+SlS/ZdJ4kHDUQhMScRYoiy3wd2cICWwy9nwIuI9g9vDoLF+nkH1Bw4jAf8TI1LGiljNLouFl9h7k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(38100700002)(316002)(9686003)(71200400001)(26005)(38070700005)(186003)(122000001)(54906003)(33656002)(52536014)(110136005)(66946007)(82960400001)(6506007)(76116006)(7696005)(966005)(5660300002)(83380400001)(508600001)(86362001)(66556008)(4326008)(4744005)(8936002)(53546011)(55236004)(64756008)(55016003)(66446008)(66476007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cavcF0hq6Ko490Sd53KGpNcMcMzJ/wBplL6ZEHCriP87JgefnKCLqu+DPfKa?=
 =?us-ascii?Q?wptBbUtxM+2T18n5MhQ6tWh69/ioOFyUIdouYy7E8w73wlCuojs0QGeqGSpZ?=
 =?us-ascii?Q?PrOzBIwPKreTJgD8WUz5gXMOLZnh1AgUaFDXnLQ1/C3oT9I2pt9zFURZBTbe?=
 =?us-ascii?Q?OXZp5kf5IlpGstwN35deKeAZzTjJO4bP4Ucjh4GSH84CqVU6xIHhVDANdN7h?=
 =?us-ascii?Q?PomZue3/TdN/JxiLfhYYK4ovayJR2atU4xZv3D1ynKgS4ZRumoPOM4lKbs2L?=
 =?us-ascii?Q?aGxARXCAaEqS6Jpx5Ns2pN58HtFn1LdLH2Q8icYA+7TqrvNSJf8+aA6dqgBY?=
 =?us-ascii?Q?ULOvo4GnDo6ydTEnEZQE3Ek/BhukSQ/G4iIo1hBdCO6eThDS5kcMmqR3Mzln?=
 =?us-ascii?Q?+/dYLa+j01vOWL4C4toGgwqZvVpXDN1coMb5/wiez7qt87jmgbcTL32i8TK8?=
 =?us-ascii?Q?xqpSq+Y1jsqncWs3sLhgsGZz7ayBnGnRzsX0seVfbg+uVluDyIqZxbAL5BgS?=
 =?us-ascii?Q?bxtA6XjIFBEaM6r0ETMNJyxzTGh89wcky2e51SOlLM3js/Xolifzy9oimE/0?=
 =?us-ascii?Q?uP60ryMgnEu1BVfGvb59gvDKTbop0MMCT/S4zUjHoExFVpeYVRbD7BKRMRay?=
 =?us-ascii?Q?6UhNdTpDYxCunIKoBVE3w45BDJIHyx4nVFD2UsqcGbMbDJDapFmLNb23MD+X?=
 =?us-ascii?Q?6aeTew8pJNvi3hCdhu4IsBwaXC/qD8eeMsDRu6m+TQhPyRoJF6uvu6NduaV0?=
 =?us-ascii?Q?KzSbQZ4nSpedT8lTfKhUYfhEM2sP7QO5cB3duJRIA1oFtib+hOteH9PNhYVs?=
 =?us-ascii?Q?Eamu/cXFtGCrYcHQby9UoKwN59/JuQEaR/RhLH0+5chzMlJnL5TrVPOYzWuc?=
 =?us-ascii?Q?n8wo5R99aCd7epVp2S5mmJqn5+Eh2BRW9IFnTeyB5kz3+a30dDCApVQPUOvB?=
 =?us-ascii?Q?+tvy8IfoD02uLd+SmDLNETHr4rVvNj/tPLg9A7/VbMV6MZ6U28ItvsZh/1by?=
 =?us-ascii?Q?0sBbIkUgvJrFIb3dkolFW5ssAL96Eyjs5f0pLzH/1GV+9A7/agvJRxbHokT9?=
 =?us-ascii?Q?6IPmNb2kPiuoHBCJyrk4Yq8Lfuk0M7kS7tAzRa0V+MFM3nAMqpjfkkMO9UJN?=
 =?us-ascii?Q?nb1hhqmwMyNjEPcfLSStFITtjPGvI7HEBQo3K+3TI7aquvVY6qYF3d1RE8gg?=
 =?us-ascii?Q?FZosou8HCZ3lw77xbth6KY0yzA0l0RGXDlE8HCjEaGHYtsgQrpbgfpXBcyrQ?=
 =?us-ascii?Q?R+F8Exy4uFG6HK5jozC/IsiJjgVh4fhPvXbRToKsn4ZWx75vvBzD5mixdbbe?=
 =?us-ascii?Q?6tX0gkrdMNsWSITP3OoF0/I67vNb7GyAGQU3VRVvWkto/fqQ0Z2+J3pcUvMo?=
 =?us-ascii?Q?fSIocMuCFUHk0rN+ibOCJzMH55cqrTOEp5GG64TJmQ7LaiLQt7cU7FjpErvO?=
 =?us-ascii?Q?qPvx488Bv3LTKhUyN4pJMttNInY3g3B0ie1Bjz4nRc6Fcft+UUKJBIKh5ciQ?=
 =?us-ascii?Q?PqsKUzIAyN3MWIaj2+KE3PgtYM09eIPMGVLlJpi4iG1eLV/QTIOPUfWRha0j?=
 =?us-ascii?Q?wJ3tnGHJECWarM4ZF9xTaZ9oy3DqS8HWfRpoQ0CQ2fXGuh2IC+b+lKhA4ROm?=
 =?us-ascii?Q?QQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947f87af-ad8f-42f4-86ce-08d9d7137558
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 04:08:02.1941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zu6t8uPODj5+Tj0W4xX8Egrr1257m0TxlNSx2GnRtOB7btdCdiDUyoAHDtdZYZFYqzEMqqCmU8RQ6BTqkUWQQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2722
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, January 9, 2022 11:00 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>; Christoph Hellwig
> <hch@lst.de>; Lobakin, Alexandr <alexandr.lobakin@intel.com>; intel-wired=
-
> lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: [PATCH] i40e: Remove useless DMA-32 fallback configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
