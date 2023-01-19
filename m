Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFCB6730C8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjASEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjASEyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:54:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE5471F17
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674103580; x=1705639580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iP16CB1AoPa/amGjgaMwrJLdfCWmRZcupLesCNLmLQQ=;
  b=UeTtSgYafsRAvgCtMU62dOjBgAFsehYAgs78nwRUWVPkOoRaT/sjlieT
   pCEbdeUmGx9OjaRu59aK8TgQxWmkBbyt+ihaHwRuCh+z2xO0iysWuL6FE
   54t6K9B4um/x0iFQhuHZ5uThOm6Ce2zdlJgvhFap/vENnPikjsTvOte1h
   iEyoTYjysnE8yl0yrzCM2mCvMlYFRjYFrSw9JQMDS75seG6udOm+5VTDG
   3Pl3ruZthawYQzuuj+619WmrqZdmrr+E3ZtXms3srhp02S9GHHUrZ0Eif
   Jms9ltF6mQYIUYqVHWZHoWBUgHHmj4asC1yMwVmtkddkMJtvqfoswGi97
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352436331"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352436331"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:45:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783912491"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783912491"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 19:45:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:45:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElMBhAW/xisGIujSs+YYCSJWEw1zDaQrMTJtMvpXsEHFknOJJ0lC/deGZUCSxCZN37Lo+sySjah5mStlMgl6hx2MllYG/6aIy0C0fPwwT0zdW/yLeti0NS6MWlROMTNCAvQ7VP+1UbpJ4DeaanTOBrLijGWtoZwZ3DDWN8PYKp13I1VA8yXFuCpUvRkm3XSSY6QxB7CIjQ4Gxluz6jAGdKypaU0kdsUb51DKJ+UMU1G8lvwlBs/0EtDvH+heKDUHRZF7P9vjc4cBAV6Vn7exiPrEUlizfFEtEBxBbxJvei/BcfOz3K6Vmb3OxnRIqnou4waSZ46h8859vud2Cv0yng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iP16CB1AoPa/amGjgaMwrJLdfCWmRZcupLesCNLmLQQ=;
 b=j5Qp7qB1ApWmtn4RN6/1gDLFTVcUa+MQ13zFILVdD8DGjvCA1rGem1W0r2vNUydeBLZMvjOvWLcfiPjbnEgYdvgmBUG/9MAkBfE3KohsoIS2i2P3qEEIKU0jBATl5eVn/NEeYzSSUaBgXXgaQ5HCruMXipcQdT5keA9Dw9zVnjgLB2ixs/hu4K/71QBQqLb7T4gqA4SEmt0hRwjE68PFXhcDa4+h+EheTyFDCbMcH+7QZbAtqolAkEQjjqa2X6wcMzGpEKmOZwqC/rcbA9O5Sd4eN1s8KCKE9WQ+DK/ERGmquy8RH/0q/8I7MxwD21wGHcrFXf7cSCkET+3mPGfBww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7374.namprd11.prod.outlook.com (2603:10b6:8:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 03:45:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 03:45:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v2 02/10] iommu: Remove iommu_map_atomic()
Thread-Topic: [PATCH v2 02/10] iommu: Remove iommu_map_atomic()
Thread-Index: AQHZK2bagr0H4LUfwUaLMUvC3iPvl66lGiyQ
Date:   Thu, 19 Jan 2023 03:45:56 +0000
Message-ID: <BN9PR11MB5276D2679877D03DFEDAC4A38CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <2-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <2-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7374:EE_
x-ms-office365-filtering-correlation-id: 98720938-f417-4476-b299-08daf9cfabe7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QwzOHquxNnyS4yHDQyJxZsACYqDJwHMg/aJvSviYcuGmaYVJpWnuZEBw/I5/1u86H4iflseMM4ie9vuOGCaw3czHHWMgSLJgNzGueyZs7qerbMGzg05eirL8AZgVvN7fMCXIbSFWYVKYZYkaOuyvJPazkQV8+CuGcwsfVE5M87LWajsbP+jYZKsctOxS5NebS2HWWoR7mSnX5DxupKvgp58ysLNdd2nT5A5XNxzKhc5mGWdHevCuFJuxYl4MFX/ZAKU7UKhtj4+QO8KYx8k3JxNdGLcnbUjXQ7wyRCoCfrbn33tu4q5OdsN5jLqmPgLwcfFYsFKs8/JjPeAio0SKP5DVghSvQWEQMjLT7sbRiFqyMhIP07mANaY8Vi9EqO6lw778cSUlrFdR3oVmr2S+TQPqy6oru9ZMnDcaFc6QNtOklAJidhcALee43XVhUljoXWvPe3tcN+a9+yvj19x1TlxrnbavElkxoXoQFLjv6kK+liLHgdISt0Q8m7ZpmPi/jEIIiphlbTlYarNCYOcrBol4TXCdGhgYrIhiIhhJx9qTPKJTQ/i/P9iKO1EMhyjHb6i+birAC9zg+prnqnzcVlB6zdhvssRR+EngyE9Zm3Or2BhEfgHufb6OsOtFVPms75ZpXH/VXNkDQDwfwjdyq5JrSOEu+QN0/yUPurDpKeOAJ7EpjZ5o6wg6FTMZ7/fncBk5RzuIM58KUiMxIr1s7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(4326008)(38070700005)(64756008)(76116006)(8936002)(316002)(66446008)(66946007)(52536014)(66476007)(7416002)(8676002)(5660300002)(66556008)(55016003)(2906002)(38100700002)(82960400001)(41300700001)(122000001)(33656002)(558084003)(7696005)(54906003)(110136005)(478600001)(71200400001)(86362001)(6506007)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ThpNQeaK4wl+gsWw8YfMrsFJIZlF8p/qRiHxe9te8SFDJyR7/7FrwFKON2h1?=
 =?us-ascii?Q?93D9IPe+UdAJ/M4md2xQHq+KbZEEG3Z9vcbuuFcG4THlGToce6brScNaXqHm?=
 =?us-ascii?Q?bNOALzvG+ur5DGZ1keYjo46R8CPdNP7yQOQFBLFtOPZyzBoWjZsTpQFnrJDp?=
 =?us-ascii?Q?VZvtEV0gxUvEZZJuQ4GX5fF82ZJ7QlMJT3NQ7q2ocItufXaAKLZ8Yh331sdQ?=
 =?us-ascii?Q?bJdm9RpwkgGQpY1EkaRtNyKsw7LYnzT4Edmw1eLgu2WXdcoGOdXeTyPtv+z4?=
 =?us-ascii?Q?7VBYn7WiA8awL9FF8eKnoqYg2HXPxgQ5Qwt19js8qYi4lCLjCHO417YNbCem?=
 =?us-ascii?Q?fn38YQPLy76ZNegmlMv7Aq2uW2jNCVVIGWGADKuL71T+UWKOWjdpEZhqekcC?=
 =?us-ascii?Q?n+1zbhNg9j1uwcjulppgdkffvsL8zBb/LE+2nmYxO6exN6ZbcW2+H49vaJDy?=
 =?us-ascii?Q?dBZVXihHKtf1Dt3kC8d35WUdOoMhbBfzBKqejaSqlbOACDubcjO3pThicPUH?=
 =?us-ascii?Q?RAKsCIpkFKJ+liXVvZCrb7WProtOIvwvcXrrYE9vQmofg9dIj8bY7Xx4eIlM?=
 =?us-ascii?Q?zChi8ueio5TlEbIehhK1aNXDfdbXhk54FXPJjBCg0A5V8MPzGR6FR9JkEUvZ?=
 =?us-ascii?Q?H9Na7Xajffg6FfCWZNhrsUA+gQg8SvBCEPwb3i7ICPTXunQaM3icpFGKPdA9?=
 =?us-ascii?Q?vAF7A4A5OSUeY8SDBvLtzbtxMQ4pYk4oqGnFEFhvpjZIZ2WwFBfIy8ahGfbS?=
 =?us-ascii?Q?XGWUD0Rf3PurAdbxehOb0CqJM0X2RtU0JFSm30iR0fOt24nP6u+uXdD6FMan?=
 =?us-ascii?Q?6E3FCIdqZIEP4i2JOKpix9pmcwi0cik1sy6EB7uJUoiLwjlRkhgRp+7xsqju?=
 =?us-ascii?Q?QG3wq6xkvy0RYn6Gm/mYEh3+qrobVAbto8aidJ2XMKpP5yGyBO+6qBTWbL/7?=
 =?us-ascii?Q?N25utE5TOGxpa3KpvCT9PSd9tqrF76ggSIwOOEB2oD2cQqMEr/dyVG8LGO83?=
 =?us-ascii?Q?bxtN5HbEVx9xqh7RHABhsFCiTcFn30Sc2LZ0IetKxzD6HPi7Ig43ydmZkb3o?=
 =?us-ascii?Q?K1ArHGseNCR9xAQRxS2ecE+l91AvMVIGFonr6OoXsXcnaApNPwFC0iFBoNvw?=
 =?us-ascii?Q?WzqvoWfuY4pMXer9+BQOR9YGIvS3L57St5HSQBfxKr+Qcw1Rm+XRROGqD1r/?=
 =?us-ascii?Q?JdDlWRMQcEc3K07z5/XnUyZOateiRK82hS/Muop7Lg6oDXL7S6dzVkZjls6R?=
 =?us-ascii?Q?hy2WswL8UgUiec9b7UpRHsLg5ejXe7pu/VdsYxJsclvG+tMiB8zX4aOQaSpL?=
 =?us-ascii?Q?rxHFprzp2sL7nZqj0HywXCKDLVz0xUuqyE0PazJAVMGHGXLFxWLFFIPy8X4B?=
 =?us-ascii?Q?3Iijq8CJ7shbbMAc7Y9EYNQmq+W51x2gCYOO+Q2moSG0MufyMd0J7SFEXQrM?=
 =?us-ascii?Q?p4mjshuIf0VMk6TxlbBjk5gg0gCp1hWOrGi1A/g7jorfb+/o2gl7NcYlENCW?=
 =?us-ascii?Q?aTOoWGjsL9/AeLQMIep0Uw4hOO/gzInHyS2XIZEg1/byLJ/9IkNcV8LCqtO+?=
 =?us-ascii?Q?MEJ+QDYcNaJo4PDk+U8eOOTKE1vzxxznQfkGc/Z4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98720938-f417-4476-b299-08daf9cfabe7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:45:56.3825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDqGFVQ6SbX/s9UNUI7iwUJhOxWCnVfxnuMRV11zIRh3DFPX/kixCqh/8F8VyKuQ6bZri8l8YpajUzPILn2Sug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, January 19, 2023 2:01 AM
>=20
> There is only one call site and it can now just pass the GFP_ATOMIC to th=
e
> normal iommu_map().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
