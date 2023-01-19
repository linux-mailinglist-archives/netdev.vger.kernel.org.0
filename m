Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACC46730C6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjASEzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjASEyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:54:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591E571F00;
        Wed, 18 Jan 2023 20:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674103576; x=1705639576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RO9Oa4QoDRADYyrfH4FBYCsakx3GCtfYYp2FcGhVI+Q=;
  b=YJqqB/FxOawzsm9tycpV1PuX48ZgApXQPbuiQK3yfMMzUW2d0elYEytO
   Gl7LXwpWxiTmBK7vl6oDbEcf3OZrLB+L03wcSL56J/OZk/yFXfTQ9CgVx
   CK2fuQv1qXXUb7EkOvOUiOkRr57XdW2DztTES5kJqy7NZuZPtBO0xQ7s0
   1xHnuY0ZkL3/DqIG7B+rDQm0cFVVUJGatOtm2krB0WlVm8Qnrh/ABhopb
   pgEURcYZJqjLlvrDvfxznIigilhhGAQ5/UaYfVLWmVeCzOaaAwEMLWHni
   eFgB0LQBWPqcYfUm/3qQ3jlZPqv/SzRsPP/8qACdxO7gVY6oC8HtOXaDM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352436798"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352436798"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:50:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783913448"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783913448"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 19:50:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:50:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:50:15 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGEdNkrRNj7Tt4N9ua0nletLDK1l3TMM5gryqYtDx72qfSsXIzJqCF558kiAWFe++BVqHvNYhhvGAyeokFGnSp03tX41uKuUq3zv96W6yjDKwKtzHl5JWO7toYKjGkRa60qGVMzNWcPIRueCcc0d/Rcw5ELqbytz1FNjFbnMSlrnJW233EiCFafSGXcosWIN+BdEtXl/pfXsZEfJHBesYsdCRq3KsYBjkPHYLz3YMRXebz9fVViAL+Bz+XCsGE5naA6K9e9XmjTnYQNLbyIz+pSl64r2ytiqPuxX+rXFn4h1AteBlUquxOY6aetDulSBOqfevrRVls3rOOM+y9y7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO9Oa4QoDRADYyrfH4FBYCsakx3GCtfYYp2FcGhVI+Q=;
 b=fCs280mYucvTww6xL0KiBhndEJMNPyTGNQe5wX0BoVzwHQtl4wL/dYYt9iZ40LKYXZ+XCl+FLVH1at+X6T+2MjqhqPtLLLtJ4C9MsoOxOrC1DVCJGLF7rOEQGhcPxjiivhKLpXSdyPwIq6o1TWOZWV586yZ3P96rkBvus0UvxE7qSNC6OuY1SyX3KmHyvjgnTWSgcdN+tOOlyKkSB5w/F5mo2UQ7Q5XgJDxzbSAaOH1zuGpNwNH5kfN2Jzwnyh7o9SVi9gjYmRPP9wnY59ROeVYbYd07dFetPwmlDdrp7rRnilrSH1XJCpBRnCf/N8Kwyg3yPkE2H0zxS9pLM0xhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 03:50:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 03:50:13 +0000
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
Subject: RE: [PATCH v2 07/10] iommu/intel: Support the gfp argument to the
 map_pages op
Thread-Topic: [PATCH v2 07/10] iommu/intel: Support the gfp argument to the
 map_pages op
Thread-Index: AQHZK2bjuC6W6FK9yEGqzSMidYloka6lG15g
Date:   Thu, 19 Jan 2023 03:50:13 +0000
Message-ID: <BN9PR11MB5276482D6A6D47B078F34E078CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6948:EE_
x-ms-office365-filtering-correlation-id: 8950f40e-e59f-4bda-ffdd-08daf9d04535
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bv0rBh7iT6do4QZqk6k5jlOfsE0872fn0FsJIDPSf6Kp8MMhrSVs+MJesRiNwW+SENHkwwCyUi3I4rnfzef3I8JPh2R+51D+O3HmV6FTTAyF1IpcIY/XkzRLHass/zTkdDASXa1uPOOlP6uUpGdVhWvdEd24CL/tPe3vORlIxMmq1n23yfBMDrzkNoHwGbfEu8AD+CU2J0URNctAJJ147dDBX5snSzhHazIceAsZ/gUYdTj5Ko6cNZcYetttjVqT/XSfY1tg+YFKE3Hx9iqL8a5hTTVAittIQK9lk19ejdlunmamNCSlTLdtLStkZnPnnOeMZGu3rmDMxgbPsGgESmbp1QAEuuQTr5clA1LFGHgxfBhjPzzsgGQO3fc1y/U1B3AleEb+9S8/J+esjR4sMJ+4lRlc0Kbqv1HZd2t6Soh0fmTNLg0JCWLsNEloVrjDhrkOMjhOXVz5C9icov+s6ITUm3XZOfOvTBA6tXavS7/IvMbYg1NGrXqcqPuvkcjQUHLhUz19PNPEOVHA+xgRmJxecw8rFYGZyn0LVnp/YHmMZpDrqqlNzm+GyQEdmmMB1oPOfeiM+Y0p96v7iIM+XE21BOdG3Xl0VTVMRySQnHfUT0IIWYP7+lun4cuQMu9mx8k5WJ4UzYbJ5sQjJJzRPpPFmtbGePUS1p0T0p6oHwtyctdwVJGqG3sBfwFSm324I5+wsh82qsM8lR2LHN9j0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(6506007)(26005)(186003)(9686003)(7696005)(122000001)(71200400001)(33656002)(478600001)(54906003)(316002)(110136005)(76116006)(66946007)(66556008)(64756008)(66446008)(8676002)(4326008)(66476007)(41300700001)(8936002)(52536014)(55016003)(7416002)(2906002)(5660300002)(38070700005)(38100700002)(82960400001)(86362001)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mS/20OheNsClKZchPRFEgPd04t8LVjI7V8EP1ICieHdZS3AhZ7S+v5FIcREC?=
 =?us-ascii?Q?OWQPu8WAcOGixuvQUbdoFe/rp3+2W06sgrh6h8eJLr972z4DPEtj+nwdJl9s?=
 =?us-ascii?Q?H+WaBwxhszWGdU0jtArGaw+wIjK75xwAhLuH86WWFSpT8k0I8Ml1ti2HlGy9?=
 =?us-ascii?Q?xc4TI9yBpeFktWXWczndBllKjgQ3RDj0XVQnoAgpepAb+xW+SfQ3tLHeUpO1?=
 =?us-ascii?Q?FlSUDMiP9TpvGVOgpO7cky9TLIQPfhVzSTtRZC1YbID13u6uPj8j6nmt626l?=
 =?us-ascii?Q?skPmYaw3BFWHqhW/z4TI7o1+zn13ESkEd3wNxCux8Dosj5dJHxXzF8wSmjR1?=
 =?us-ascii?Q?tfXFIfTKwx+gAYzJbiUVNuNbbKCWTOr6S2TkxiD8WYqn0UT+5nk7uPBdGnkL?=
 =?us-ascii?Q?E7XKD4xETtbfQpXJ+b3GcInlLKMIsrJal1lYYRRqPmN2rnqNFJUPYL5YtWGp?=
 =?us-ascii?Q?SN7EyM/AgZ5ok7e/meQdEe5mOO6gG0qmRaKoEy5q12v4PMT15LKxZ7hOYmPO?=
 =?us-ascii?Q?0G3yYaMUEE5WKa66+vkW7ELteoD6jpGNgvnr0tuMoAAfnRA9Ez7PDKngpav0?=
 =?us-ascii?Q?GJbtvC+osjpvnK9xzqvL7bZF1bfAqX7HjKbtX5nyGTFba5QPzRReHmLQ4fCX?=
 =?us-ascii?Q?//oqTlG8dMchK8EkWQBs6E73R2MoIcXABJJekIFWz60v3druklSF/K7O/ie4?=
 =?us-ascii?Q?g0YhY0QJr+HQkx61haE+0t5bIuS4pKNsaCFWgJLuVObGDGAJSnruRx06bG1Z?=
 =?us-ascii?Q?RNkuaxz0pg9NPUMtjqyD3nhGpS7MBUtZDjfKefg9b4cU0Uynlg+ceEpneQE2?=
 =?us-ascii?Q?Cx3apkF1YUgLXr0hPZFCe/rx90rD4iXmku5klQRLWJ1D7EtJochdZYcule/Z?=
 =?us-ascii?Q?CjFr1ZiF5Olsm2rNcvYhRZ2n+zrF2k2T5nWRsANlC3uBj79iMEgbJBAho+80?=
 =?us-ascii?Q?qe2k6dNKiUnqWQyLsBgkynP7Y7rYjz8Kqpgqlh5gNmM7EyWHO9zdkDDCFxgX?=
 =?us-ascii?Q?rbVP7IeBUC/2EQ5FNFPElpUOjoGHZAjsbTpU829fFUPh1KdCrXpXUtbI9Wjj?=
 =?us-ascii?Q?XrLcsw/N3OJh6pITFWtbDVjNWCgNhr0hyAsxOETREWOzbsZ0yTXM18n9SA4Q?=
 =?us-ascii?Q?6bf0DCX4wxIg/h9NtIJbOPLfSDEwpFI+7VgfjHrM+g0z9N5wK93ZSouvSYYe?=
 =?us-ascii?Q?sj/ue1N6Dme6suBTZR+pMkBPpIz2Y8Wa1hDhMrRbsxLHlGF1YYNI62w6vdO5?=
 =?us-ascii?Q?z5/zWqYPiP8V5ULSk8t+Ur3D2bLAvA4bYFwhx/MwwNuiowz5djBPy+1TUANc?=
 =?us-ascii?Q?TvtRlVqRVeTp85TrDjosKKYS5IWRZRT37keUMHHHS453C3MlYAKROky8anDt?=
 =?us-ascii?Q?WdU3gLZKn4+1Dm2D9918VWfj+EZIw9NN4waidm0sV8PKTePdCQHQ1IfdrToZ?=
 =?us-ascii?Q?GTZDtmFO5pUf0+et7LJYVmefwNhPjV8oovnAPbsX880B+6FxiYPCfCxUg5jT?=
 =?us-ascii?Q?I5st8B2Yu1PJ5XrvUaEO7osIL3Ro7+92ZOLb0PIr5ecC0EdqXqa/oi0OU9AC?=
 =?us-ascii?Q?r4O5VP5lStBlCMjxlCQ+X+ozLSu31Z1xkYqAph21?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8950f40e-e59f-4bda-ffdd-08daf9d04535
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:50:13.5714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7IkG5HbG5Vbtn1JG9P/W4BMYWFgKrSbZ3vtMV0F/9tEeg4H43IhTCQAHu8rsI6THtWkW1d8Dq3Sj4cYBkz2L9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
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
> Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
> __domain_mapping().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
