Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88EC6730B2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjASEyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjASEyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:54:09 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB671799
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674103574; x=1705639574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7akVbq0P52BNTMgJDfm7MfKXhG+VYySWKfey57WLr5k=;
  b=GLqLh2h7Wg/2Yl3Zfq9TSKtdWbfZp2SzXw9MLNoWJtpWBU9gFR90tmkQ
   2V1eTZARfuj0wzt0wA6YjvE1STykcJ/bafLRZtlxlo63S9hVkeXLlwJpj
   MOqe/j9dp2ofWetpFH8WSaQkJoAqKgUupzdfmsA2A50TipyGe3drAK6NS
   fT7VdH70ErFJQRMdcO2oQrjKQM1X3tLFzO19z32UirSXPVPy6g5wiv8xQ
   2vil9CvIdIALbwfFAjwhfsY2WSyK4xUUSwHRkVwKPP/OgFGQI2eHp3iOr
   hJiKDdhJxdt8WsNDeNpge9mYod6CvF3TwOCj2flmQGrdsAp+kasdG1QTQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352436284"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352436284"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:45:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783912415"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783912415"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 19:45:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:45:29 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:45:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlbNH4rpsshthMK9jAuTyK2huyS6ead1iPK/bPe/W0DN7oBAn39IrzsqWSIPRGnDnyaEplq3fQ2sRytd8VgpVxJVBtf7icXHMKOk2704NsBA+kJmtmCMmH/TJszKFbTTFbqNItjv462Ugf6vNmWPeMV5JtNc+KfhmwX43EMD/UJ+NdxjK1R+z0y+pnXkQ0QKYRgMOUquPNrqkI3ZLJErItJOlYS8mCqww9/zTNxK//EOUU8xW/8S1uTVyO56eb6R//qRvBNk9SC81jkDxy1R0f+Kc9PPA0+lAbCTTrvqrWK7L2GxYK+8U8SpwNPqN7ntvI0FUwsTnvSNv1TsbTWw5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7akVbq0P52BNTMgJDfm7MfKXhG+VYySWKfey57WLr5k=;
 b=TXNDXjMTGTNwRxg9DwdUUiHGPqwzjUaunpQXwM5iEJqse5plqalsKhpO2fTEM2czsKKW5xvyQT5aRGau0QHD3tMvIxYK+RwFvQAjIUKLx8+cxdWoa1AMxmrH8AIR8//HHNDupIdfq/8DcEY4qQfW4IrPzr15G8lH1VvuGyIGETikf31VMtWzqY3XpPZS7WNwCg5UkEraa+fzGBqATVpDiTGkzXZg6SpGWScOpM+wQWHUYyMXNw5DQewY8c4H08dLt0wEdSths59pvmRAVsRDNK8jbmBaRaVBQtX8BcQ9noAwUzA/XF/v6gvsGVFO0gC5cI7ptIorI0ua514SaV5/BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7374.namprd11.prod.outlook.com (2603:10b6:8:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 03:45:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 03:45:27 +0000
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
Subject: RE: [PATCH v2 01/10] iommu: Add a gfp parameter to iommu_map()
Thread-Topic: [PATCH v2 01/10] iommu: Add a gfp parameter to iommu_map()
Thread-Index: AQHZK2bhAG5uFdBTPE6j23ADS1S6Ba6lGgRA
Date:   Thu, 19 Jan 2023 03:45:27 +0000
Message-ID: <BN9PR11MB5276FF1670244D0F0924E9948CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <1-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <1-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7374:EE_
x-ms-office365-filtering-correlation-id: 512d9d41-4181-4abb-0f4d-08daf9cf9ac5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nXsKyRwmcMM6jgR7Ux03qKu4xruHqnfKKJorqaUybbE+OrhdRYZeiDJmeX8EVsSTkZdmkbumai1vJaHQUB6fV916ADgD2xjw3eCpLQfHfV4I+EIBPPN2cdkJk7fS5XKzy/7mRBM81so7AnuUB47B2mcvmzw/n4I4noUwB6M7WAQPZyBStCH5ZF3kFYp6ygGnKy3ZsboHvULfCNv6JEkMRtr7We93y7Fka7LQbyF3UaSYaI0dCEwfq5v2cM0wWjE0L+41zaWc9/ZIvdP1v56rNfsJ9JiDMguWBEWTDpOekmunQvXhlCiDvKQd5hvOdygwR+caW8ADzto2++z3/dsnbHk8rLHpv5bl4hH+huJPuTUvt5btdDJJ3wBKNy0V1vUys+etwe0KRXfua4u9C0oMLImdPC8BWHyzkWb+uO7l+2b1eC1zoew/+rbFjinLvspM06ac43IO1y4zUSlqVngAFVlsBulyZ99WDm8r/057J6haWxByXqXTq49+gfkVJExsC85D0ARuE286hAKVYmQo3ZyFSXcbL3wXqHUvow2DNa3ysHtHyGqC5eVal7tKNvwbKD388vvmi8kQEaz8/DUwg09MA3AiZOAstZdyps/G3VQt7apx81CezjjeJqeZm8EtmOfBgCIj+LOMn+bhcSWa8QI1P80hqyA240Nvw6CQIQOe6pZ8tZTo5oLtQgYmiUtq0tJ4e6v6ArxrW9HLxC1KaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(4326008)(38070700005)(64756008)(76116006)(8936002)(316002)(66446008)(66946007)(52536014)(66476007)(7416002)(8676002)(5660300002)(66556008)(4744005)(55016003)(2906002)(83380400001)(38100700002)(82960400001)(41300700001)(122000001)(33656002)(7696005)(54906003)(110136005)(478600001)(71200400001)(86362001)(6506007)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V70RZtzN/HC2Vyvnpyc48yZ79OFEewzTIV97kSb1DxWEQqoP0Enl4R3GyPBS?=
 =?us-ascii?Q?L2yufo1OhJuwCYBJ6+g8CMvM4IQTZWAd/zGV1ir7bPEAsjmUPJOgmM2ucbTD?=
 =?us-ascii?Q?Ai+nEYv223gtgc08jrDFgcpF4RB+aR+AjRzx2ZD7ODTklNF70tWw2ry2vFIw?=
 =?us-ascii?Q?o6ACBN91TAsKNf7SyqTaSubYEhFS6p12wwq/EGw+bNDfs4j4BuufYTYzn+OQ?=
 =?us-ascii?Q?MOFZD88EYTY1J89mM+ZJeoO2doN4Og/MSRy0ncODlZ1HcYHRbOKFSVPaNT+Z?=
 =?us-ascii?Q?WKNoGdNjHNzjSVUlL1R4hezqKMasr8L2AifrWP7xom53rFlkdYeVk4yE6FPb?=
 =?us-ascii?Q?j/4OOqxPutuRVCnEI17j7lXQID48fLkTYwgbKRgJd0s7eAZOmVg7/3bVYgeV?=
 =?us-ascii?Q?QOxrN1Pt3070gpoMGeeGDzbQTejc2X+UmM6vtAlu0B7M1TkAqIwh66T5Dfc+?=
 =?us-ascii?Q?osVPhSPXnnbmTGg0vkfghgNkkJoJx3p8qnBIEBwIx5SMSwpKs9rqXvraPpfJ?=
 =?us-ascii?Q?BHJA0nEPgxPA1wOaEK/8xnKAfY2ZwcSOcakYwBl41PkLZBWcJ7OzRugJXoQj?=
 =?us-ascii?Q?rRj8hp8yE7k3dsT+96d3lnntd9lQpQB5DXQDNNF7695I/SjfIkHqXGwQEDc4?=
 =?us-ascii?Q?7Uje8BO6FqvdqXmRrCIlLKd6RO2edszBIYae+suoGG24htW0q5joAysYVAEy?=
 =?us-ascii?Q?API4TutROEezmP5mSdfEpLzcRbLBhTpCoPah0rAGXnurZLR6yLQ/y371OxNp?=
 =?us-ascii?Q?dcpPE4NuVTdQD4A0eNEZVBjnBirCpGnzzIUu1+XEZRv7PbvLC809la3m5bJj?=
 =?us-ascii?Q?YTPSFkkjZXBx4VzllfBmrey8CSTtxDB9bE6AOLbqMpNJF2bOmcQErD1B7M2Z?=
 =?us-ascii?Q?rvEqvoGUVic1oZwu9efG9VacK48gsqJRRpmVg1IwgyR1mtXRYkGYdowhQwrP?=
 =?us-ascii?Q?/KkyhFhX4P4aUxsX2c79hulbqYbxEgddFl7wkeFQPXGIKMgkacuGyyD4njna?=
 =?us-ascii?Q?Flo8Pbii6eJZR+75BYi7wzmUBUdBFUsD4chtZ2I2iQN6zNjdFrv6IGz2fCNb?=
 =?us-ascii?Q?tr3dPrck4jPe7x6EuClk3uWStrsh9pRAZG0zClMPbCE12E/ViZ4xlg2RPAd3?=
 =?us-ascii?Q?oDx9oC1Rk29aN5WGb/33jwFZMxIR+1ZknFAJKUpzr38JZkv0eRWH6mu5bOcX?=
 =?us-ascii?Q?vPK4XxDhM5ngCoOE992oLKA7/Gx5tJmRY4PhfzpaAzh1I1yt2Zw/NYPfFhjD?=
 =?us-ascii?Q?xxz/yc1vhBcsGNn6+DwpTx34Yr0F8/MHgvgJO+I4T5vf9zdVBYeTgReVFo4+?=
 =?us-ascii?Q?oljl2VtFXN5pknpif1AOcJz3BrXMMq0O6hEhylTDhSDq/2Nzie9jdXj7oHBp?=
 =?us-ascii?Q?iWk86ZXMHcSxxRwG6+yDXumyc+axGJQpf3SSA4K+6Xl5briW7I7Sq4ms/2SY?=
 =?us-ascii?Q?kwQLPyU2QWePi4rkl4gqE7uw21or7ocNfB9wf4SMfYLL9A5Dxy+U34IyEwAT?=
 =?us-ascii?Q?uQSaWJiumqjSfod9Eu+bcM49jh+LpcaXHJhUFlCeu0WaymkyhAOh+MFJCdyt?=
 =?us-ascii?Q?5KOS7dvMa+FDxaWSnf6aU5eEwyVLNzdf8NUmdv3u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512d9d41-4181-4abb-0f4d-08daf9cf9ac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:45:27.5873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VhImZFlxTjjhEYAMo0jxG32ZRffp7cdiw//Vf57QwMKssahbl6155KdZ8tcZYWR+Wf5paRmWFgTBcaaOvWsjOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, January 19, 2023 2:01 AM
>=20
> The internal mechanisms support this, but instead of exposting the gfp to
> the caller it wrappers it into iommu_map() and iommu_map_atomic()
>=20
> Fix this instead of adding more variants for GFP_KERNEL_ACCOUNT.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
