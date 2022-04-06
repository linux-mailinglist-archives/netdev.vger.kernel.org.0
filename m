Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685894F5CDE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiDFLye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiDFLyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:54:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C462016BD;
        Wed,  6 Apr 2022 00:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649228994; x=1680764994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ke0E5XZSjDXvXiyHn2Q2MkxyCDM/eWJM8nA5FE6wVj0=;
  b=OEIL1ftcBlC4cCN6GLZXgWXoHyEtx4C3+X0tvkG5R+GIzNDBANpaBpf6
   L5m7jbgrlGUZPCENUl7zyK6qmYvMJUYkdOaFYDlHzR4sR5NuwjqlYwBN1
   W/6j8JOfRlm0EyHiNlyTTVzte86W7BTQ/cYSq2LKS+myFRpgOz2xtPszG
   LsxY7i6Br+BLZ3+m4TF0LpExKZrXMjij+I47tIX0zGc5cFuavUbUDSQHs
   Srwy0E0GmKfjI6OtH+YAOcHTdrZanguBAGFn0sHbZmOwsylGazbnD+80s
   OKbgK9zpuxcc246sVt6Lb7V+O50VaTi9VuG95zhJIeimC/FzVt6QbCUdQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="248493064"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="248493064"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 00:09:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="697262648"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 06 Apr 2022 00:09:52 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 00:09:51 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 00:09:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Apr 2022 00:09:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Apr 2022 00:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxDv8GQwmcQlmpaYzAIE4mZvRdjXlRrHY/Z4emrZ5nwX/mDtMPK3+kOMtSx1R2dR938HM8R/MiImcMJFoOE2T1IFcFIySWmCED832LDl5k0SZWeG9oTNevqcdhmRc9j85/3D5T7hnbQ509jufSX1FId3/7EaD5/OtQa+IEib6Giuj61p2U1xYJqzam3n3aEJJhQgpHqrSvjooY3Oniur4XbJthiZ2S5BVWYQ3PmSud/bf8N405gFx1/Y91VlQq13mO4Ky33GVBsUw0dIh/Iy3VvShezEaBTpX5l4CvXfLi5UAAa4PYLxJndn/jKWTAfuF1e3U7VoP5xL9ZrnKFsFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ke0E5XZSjDXvXiyHn2Q2MkxyCDM/eWJM8nA5FE6wVj0=;
 b=bh85p/AuP1jXHBkq3u1gahabDugy35Ju3YI1kbdH1zk9/IX9mvb8SpHLqL67QcG1n16OZXIFoRdgyBF2N1uTMtJxBACo4Tlh1Q7xwM9IG1ZSyUtRftAVLl+2ZDpSrO+tjZsN1KMZM+mWBalSRU8yDAqE4Ab7xdsMGKrb5VbUUaUTzqUatLtMD8NIGVXgo+zTQWmYzNZK+SV5dnkQBXGr6waRZA/VwLtyGubcaayyg+P5EE4O9Crhi0JJ1XGq2NiRPnsvJAMPKTHObjNhBu/0k3sedEYqJD0YrtH5vpk5bS0vSpfhfR5vKUCgEs7pH2DbcQ8tpRldg0yobo8MQriQqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 07:09:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 07:09:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Christian Benvenuti" <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Topic: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Index: AQHYSQiEbYC3kRQ06EKEzYAnMp+0x6ziduvA
Date:   Wed, 6 Apr 2022 07:09:49 +0000
Message-ID: <BN9PR11MB527691474154C32D5D1678918CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7780b514-929f-4109-c35b-08da179c7096
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB58966129E3D9B94AE9DE26148CE79@SJ0PR11MB5896.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNiF8/iRDiblS844YTQyoi8VjkASEuVNaThIOx6e7LB6fef01oEaF69jvATCtIt+8bdNW5qTeFfkZxespV88hZ9WXklXo2oEZ2zvhcvy1Hb0XK14oFrVYVAw4MV4x8KiIb7ZRzVNPQeabNZplCwDGy+Z5HZKcmEIlWBfQUvCmUKT/xOiTAnUM8kSSsmFXpGKhHH9CTVn/ScAt1vdrVKMANOxib0lO1IS1JGTqqTVS717hAwXL0NQCQ1QVE7O2Qo2qM1JVdD5QCUlyaQa3gdr1cd+zFm18DYFjRJxcaAfjzEZcme1ma/xogydoSIX3zKqZaHQiwi/yFfZ9ffEDtXyVa13O67Udyp2PtRiWjj1SObrbmnjFB3b3Rzhasbn4zNvOCDno6QV2b0chDibCTFuZRvGuu+RO6MpMqVGly2IB+7N/1TOf+l6YIfMJ+bGkSQ0e69K6hN1oYzcDqkxHTevifqN5cMFYlf41YeX8FVsl4BIKHlQRYykRDxG6HG2YWN7w6eW0jnzU/WKJDey9d6Ea57D4MFihh8G1bVtzxPMg5TK/qaGVpQZVf8S5Ppg1O4N6F9AznQbGMoomTKNSfvg91FNCW7TmYfz2/58ThmKkKRxALwxWH5SPz66qpzKbE9JFmsby1UEPV8KccNbpWAu5NtTEuamXQ6dm6yt0ZlCWjLvAntPDnv9OLuiYTyH4mD6U/ElyUqPocZ72rdiUi7I3tv+YlHT6hib0+OLSGpYdX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(52536014)(76116006)(66446008)(66556008)(4326008)(8676002)(64756008)(66476007)(66946007)(316002)(110136005)(33656002)(38070700005)(921005)(86362001)(38100700002)(82960400001)(122000001)(83380400001)(7696005)(186003)(26005)(9686003)(508600001)(6506007)(55016003)(8936002)(5660300002)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NXB2xpgssG5nVySWEOZfTfpSwQG/mYJdF8Capz0DicbkOY5uybnqDIAtRiar?=
 =?us-ascii?Q?ip6SSemKC3eNI7S+8izDusAAtP7Oun1uD1Rb0N4HweuWB3LE0S611KSpl1Vg?=
 =?us-ascii?Q?7K5fhf8R9XphJQZlklmYtItNfZrrMO63y3/zDQTYLtjM9Nuq22j1gYzIFLQl?=
 =?us-ascii?Q?c5KlmFgUGaADMAYvnjbu8RNPPxe11qPuxUFUC8B6vilnWgKjehrMUBB06e43?=
 =?us-ascii?Q?ph1VYABE0dQwOiBDf8q4b6jEbN5yo7sPr+e1pj93K5oOfgPKsb35qceH1iRd?=
 =?us-ascii?Q?+oFnXCghoZtFYN9mcw4oCmLd8MUgfERY/SQEuSaPiuoKxqw8ED4acSDfiQ2h?=
 =?us-ascii?Q?z+h/p7rzvj+TSxCJS8NxeVQGjGePMpbse7lT1kAmgsLuHi56IIU89HzIv8OP?=
 =?us-ascii?Q?lL4+5hNPiaYhIC83YX7a8uB1buBBwDxDtRxrJcz0fM/3Z1O3Se/QJ1a0+Vn4?=
 =?us-ascii?Q?CC8cA6vv8UvTLC3k+2bAfDbSxK+IUB6jNqviomLgYchcft0+qA1Xdv0GWnL5?=
 =?us-ascii?Q?95/vtSgeJbcSHwQww0sqz7JCZUFmgbuMXPxlpYS1rNu1Arxm690l8ch9UG9Y?=
 =?us-ascii?Q?9fW2BY2Fo4yK0nhUUhN9DnBCXOl5BAkniF54ma46HzA7meVhg5N2VO43tN1Z?=
 =?us-ascii?Q?7cZnZ3X87wOwsd2+NNaDH4M0GU9RFqJPi5EE5G4WRPOMl+JrqZL1egHdWTFP?=
 =?us-ascii?Q?hBd/ZBPSmCjYeIFly4ULkXNfgVvwh5j3fELq9aPEjZwYfak4o38ggwLF2xbC?=
 =?us-ascii?Q?m91QTma9xgIIIXh0BEV3cSkuG+FNaDiEbgUtpqNnSFZPp312341ZKq/CFK87?=
 =?us-ascii?Q?MpQsMcsVhskR9Vzo2ucNmncdzOJUrhJhQiQ1ueuShsdDux8OuzIuwuQOwC3d?=
 =?us-ascii?Q?+UXlzZw+jY6IXxIs4WCW3BeIKYB7M0RgPL9iI+Avse554mqv110VR46KsHUr?=
 =?us-ascii?Q?P9IKnZXq6rccQUI0xtYjL5zDhq/JqF0BGr9+vgoOlzYwisa4E6ml0VZWHzPp?=
 =?us-ascii?Q?8x+ye0jEdsSBwcXfx0gSMoxM8F+S4/AWNiBqLRc8+Q0xmQV4901dVpcaO7qm?=
 =?us-ascii?Q?3R+GUSv+AbqABDv4RBAPViczXUUcovYXPAWWYy8FeM3hPyk4Ui9WY/VpKpsD?=
 =?us-ascii?Q?QPIJQ8boBdlWaXKXabF23A94XjY8f1nt/xedPENmaeQxMd6uZFEC7xVQ81FM?=
 =?us-ascii?Q?3q8yP3xuWbAh1XvMsRZiBeH0x/TnVtPj5/aZGuQSq5g9qVf+sNiWwGzu2dP8?=
 =?us-ascii?Q?sJvhSmRM0gvCeGppwwAl53epANacMklnJiu7m/N9HdVUhGubfxA4cQP8F2/p?=
 =?us-ascii?Q?zk2puFQk5S9SaAYuGEXg1+myk7m1HYcTaEI23c5QDkmSUQbSZ7qVmSW7FwFS?=
 =?us-ascii?Q?YHIpOEzZf44xwkXBt8ZeN/hAYGE/kXImgfdBtZX2JN3PViTSPn4tJRqzVmUq?=
 =?us-ascii?Q?dRLygzvo9tTUFE1KwcipZTQVmmSdPaVb1gNNQ6iVfdi5Jgod609TXmPHthN6?=
 =?us-ascii?Q?meNJNbGmxWc6+YPTxeonh5V3+GPTFWtxLTO5OR/YcK2mpLLZtECXy+2d7TA6?=
 =?us-ascii?Q?g8/WnXkVFOu5WKXSe9CAPRPF7r+AiY7icTpQ6ec5ddKksiP7mVy7jpiD2/U+?=
 =?us-ascii?Q?ACtigKZZTNsHBYju/GmVE5/zTuLoNnBn375P1TTGgfiBhsIi83yFjGVXtdEK?=
 =?us-ascii?Q?snynEIwdsphVLNQiF4WDX2xydL+p+W3Nza5vNOukLc3UHyK71sbqMzMnpaPN?=
 =?us-ascii?Q?Qq6KN0hzpQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7780b514-929f-4109-c35b-08da179c7096
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 07:09:49.6675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VttycdPk4BNt3jNwa6XHUQbzC4Xo5Rrn5jR7E7uU5BuZ/2AuUPMYGIZoEbR+N4GE5MF1xN3vowj3yxxwf+c3/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5896
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 6, 2022 12:16 AM
>=20
> This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY
> and
> IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.
>=20
> Currently only Intel and AMD IOMMUs are known to support this
> feature. They both implement it as an IOPTE bit, that when set, will caus=
e
> PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
> the no-snoop bit was clear.
>=20
> The new API is triggered by calling enforce_cache_coherency() before
> mapping any IOVA to the domain which globally switches on no-snoop
> blocking. This allows other implementations that might block no-snoop
> globally and outside the IOPTE - AMD also documents such an HW capability=
.
>=20
> Leave AMD out of sync with Intel and have it block no-snoop even for
> in-kernel users. This can be trivially resolved in a follow up patch.
>=20
> Only VFIO will call this new API.

Is it too restrictive? In theory vdpa may also implement a contract with
KVM and then wants to call this new API too?

