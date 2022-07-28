Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC2D5837C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 06:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiG1EF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 00:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiG1EFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 00:05:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D139B51407;
        Wed, 27 Jul 2022 21:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658981123; x=1690517123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wYa6z7XlX3TWLKNNoJ1v6Qilc+/lgtZiuUV5IAb7qT8=;
  b=mV4HAW3EYEQbQSDB7PQaoEwQu1O3Sx4PT2/LS7Q1HF7wpXR3gaKidrSz
   HnJjALuIB2Mzntp17fvHUH7ewwjqKNC5BrJlyJeDAVXdOOakLE73yWYzg
   mp65vo4uRYPvF21PaDkomkl8g/JSir/X2DIuCPlm7rwdVzmbpEvacCBva
   +qQz4GtMd9GNsoXFnCZ6ioi7vjJbI9kW72bya7ciNGAmo+s+V2spCAszP
   2rQNp7FQ+gdMJxQ0I97D8tzW4wfbpyOQSwJvSazQIOZ3YTQkvogJuGCUs
   4bOPRN2AURBbjko+Ax8q5XscxP1SrxpYqyovGrPZtSOVMjtzzLVsqYGYC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="350120377"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="350120377"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 21:05:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="628681414"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2022 21:05:07 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 21:05:07 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 21:05:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 21:05:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 21:05:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idhqANQ98di3TLk+tt3FIrse96z/sz3EBXirurpj32yDlOrsaJS1bZS9unhycXW2hqPHi6EWosAzLgWOjbdGfYS9LMbbCg7lZMsQGVoUG2+qKZ5YNr3XCVlKwgoOimfUNFW+fU+PZq6dbZmvOuQ5dSbCY+hO6BaR4HfM+Q14CCoqpciKGGo9+FFE3dqHNHtTMKlFuAFjHJeeIB+uFM9jEbjYylNa7PIbabYstznIGby9DdmKQzB/V3IJ2ps8Vz0CCIhU2/8lvnrqUpfMLPINLQXnsY3BAQWCyEpjDIEXuH/BZF5iutIjmf9PQtaIG0TY8icPKUWYYTK5XBfY0v5seA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjwK8vfY5DTwPb/SpwWirBLJ2RoKigVb13EE+letqB0=;
 b=CzRMmasvOZeKUUYL31gd5Lr1uGQjzcJJpMvPcnuH6BwhKppkSJ9CTUnyTAgziSyaxI2waBXd+M48zgJl/y6jGfyekGioKy378Qsn6+R/R/Us928UKgRGCAJds4l2At1vABZjGX62TiT9ija+kZddnPa1x1InOKMtvsOPVIG9gYsI8YNF0Bxi/ssynEUE9Mx9e9S0FoCoogaC4fWWAyp+WTrVnLGeSkdqCQf2Axfwv/VxXJSChwSqjO6ptzzVHh8ChVSLp6NTzNk4JX8Z5HLD+C/Uc5tAJjOHyp9/ymB1b4CxpZ/BuL43O+0+/IJrOg52G62FQ2R2VSMAoT2ymD71dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5496.namprd11.prod.outlook.com (2603:10b6:208:314::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 04:05:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 04:05:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Topic: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNggAAsCgCABgpRoIABp/gAgABa8gCAABExAIACXSyQ
Date:   Thu, 28 Jul 2022 04:05:04 +0000
Message-ID: <BN9PR11MB52766B673C70439A78E16B518C969@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
 <20220726080320.798129d5.alex.williamson@redhat.com>
 <20220726150452.GE4438@nvidia.com>
In-Reply-To: <20220726150452.GE4438@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b9fd56a-5c7a-441f-469e-08da704e59cd
x-ms-traffictypediagnostic: BL1PR11MB5496:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8rxAckKGX3MNAuGPxfAnEjEkfOEOUIQUcqHtHntOcHfKApGeXr7bVdPnTZani2QX0Ds2bJg609zoQqUBaREKIOcTLVfvNpA3SJm1UFnSrTF1iJWIVuQvg8Fz8zcbEvzSAvSYQLQVyxkc1ID/b3grXBCJJdjaEsKWxN6IBX3shEznDB/JrO9Q2pvzxeB+n3AWJmUlZLwN4zhBhBoXmi0OGlI5o88K9SkGpo26EWev3dzWzWOEQi5ns1VUPmhjRlp+LW6H7spZZZD7uLrUuqddvp0t+XO7DI7wBrjirqKzviDcRz8p6CawkLIMd60G5WflrVc8O/YitHNl9dSqtGghkL5TFSmPCgVPbT/5dfelOe0mLU0NGcmtvJJ5BReqVjyXCD26KBlfGt07941E9HSFdTf3y615Uvc2DnakjakPutY+/2jl4bjU0onCj1sSX+2kCSrDH9Zg3WeLKfuF2a3JDnsYcDKfZtHKCYbn9f/2bKzpf4J0RDCdCerKD3eERlWNSYMv5ezkjKQUCDi36XYNCaDjc/xYlCVgyy+VwsiVWcEnAMTIZ/55Sg0a7O+ubV5VCYddqkv/EbLUUMubEsDjqYH0NmosN0lGcmWhYhaQkCgvyelbVXwSpdqDszXkEF43e9IZzYkwZyeJcO89EHN3CE8hk1U/tzGX/AFXxVJjrOWC20ECBtMvqzk2BWHNf/wEXbRW41XsIwdUBT07273y3acvil46MDUb89osKz4+gmjkSKW+RiGY5J1VZwxEGGqicj9rSDDY5S8riLcolQzI6KuRz5ukY/viLket5ZSg6iSbQurhIFtAne8hBywzLTOQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(366004)(39860400002)(33656002)(52536014)(55016003)(2906002)(5660300002)(66476007)(8676002)(38070700005)(122000001)(64756008)(8936002)(66446008)(66946007)(4326008)(7416002)(86362001)(76116006)(66556008)(110136005)(316002)(7696005)(478600001)(6506007)(9686003)(71200400001)(41300700001)(54906003)(186003)(26005)(83380400001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?htGZsenzF9k5+xAgIJ9KNprikvdjdjtIzIO9FbPGDsIGdj6iMwM0zvGWjPPV?=
 =?us-ascii?Q?Vzd0x/d0VrNcW6He7RqRMQUO+jifgi55xc0UysA8EzFh0SX/u11Fo/QRu5n9?=
 =?us-ascii?Q?49K46aEePdWfIqzWZGLTKGzs9+T8xRnV7GkWXVx1vAgWBqV9FJJlxpyPou9H?=
 =?us-ascii?Q?rC9wpD3KY4elnM545NAPZjDHQauQkikf99FTwAl+WFjQ29XPkAcFRnuC43X9?=
 =?us-ascii?Q?4+Og3pCcmuphq4+O1eIrfPoOvkxpCKKJb8wKNaFLreD7uxeJaVG875UouN58?=
 =?us-ascii?Q?JsA+K1ekx9tiOgB2CANtzY2M3Zip8UieexV6ButJ1bOz83Et2/Db1iVznVPV?=
 =?us-ascii?Q?rs5DiMH9z6eakyOSczsPs556yhmQxsz+RgQ1oaIhJIfJsaxIoF1pTZeR6YS+?=
 =?us-ascii?Q?BbmGRYize1HTx/KA3nIr11upneFt/E8td8zgMc5tbPEzxmuST8tbH9DiqYMv?=
 =?us-ascii?Q?49zEMAILhavBOAdhHaNdo33/1YWRlAJoPf86blCx0/gxziQFO4toCzPWYNzs?=
 =?us-ascii?Q?YBDhaq//rLvcufTqzzvmen7BvTK3nYdkedJ3UQszYCr1leD+UXFi444NWEiQ?=
 =?us-ascii?Q?tzqFHUk6ppCG3sEbi3e5g9jELm9kXBnrXzOO+UwcG1ZtTf8ALyEv9kufa8pc?=
 =?us-ascii?Q?u8b+fa74rrCiIiJj/O7FSUHIlbfn3FhHnqDMm0BOWzHiJbA1liPDjNLTvE4S?=
 =?us-ascii?Q?xRs72UwJrE8PEWQZyLqDIV9HLK7E6Ju8X9P4As6Y2NXei1KbhxCUA6EpgNgs?=
 =?us-ascii?Q?GefwA5MFdEcH9aBW/C2mkB/IsD1ERgJxcsDlP7gx8XLF9LKSuAOopamhhQqb?=
 =?us-ascii?Q?o4NSNVgretHkzEvHvIcYwkoSVB5qpmL8L9AY/EdfIEMLsgA86wExLG7elKNM?=
 =?us-ascii?Q?SNjyLuOwf/0zDKYijRLv2yiEHqejSm8Dr0aSCHt7A1lHIIT/X5BTHQQ/t88J?=
 =?us-ascii?Q?QE/8we8F7S3sgd4sOD6M9R8mgtifePd7tb9vomCsxShA+k7qIXUWISYc49cw?=
 =?us-ascii?Q?lFwVpiTps2wiQVBL4nlZ6yjRkjR1RZgAsOS4Li5I/Ux5FFLXazbDg253EECX?=
 =?us-ascii?Q?hy0zxviTVKnbB6uBgJHltfNQfjaV8/MaOH81xJTVlloYvJxEcT8LGbYOMPuc?=
 =?us-ascii?Q?HZA9CwtFAxzZveUszqtGIUS49XZCTqsl08yKAbH4mMVARsWT9GcaE84OvI/s?=
 =?us-ascii?Q?veBGS+q5oYS5Jijb/1LUK2s6XNrouHuwd8VcqWe4+B3uOdCpb/vQczvERtcO?=
 =?us-ascii?Q?wSerJ75OiKjF7mZ4VO6C5fZvtbPu/62G9FeBhGKFMfCEWz756Oy+wrTUOOna?=
 =?us-ascii?Q?HfQjEYYBn+a6agEad7dwbyZPdYH8Ets6Tqi8WwgQw7QpQBLK45vptTBHUj3V?=
 =?us-ascii?Q?9mtCFfFLAGpC8tmT7luoFJ7ib32oKkaMD5tNK9AUpRF4fp0ybFTi5dl/M3mC?=
 =?us-ascii?Q?pvyf9KLLz4vUZb3VJ58+aOEZuMl/+E7vv4vs6lwsGC1pjNIyouqh0uP9l++y?=
 =?us-ascii?Q?/tCaTrfaG6vKF+NLI499xcuKsZRhLTwSVvLN6NK5Ez++8lgg9oqmoobud97I?=
 =?us-ascii?Q?CoBZz+UT6eSWRLsi0ZA3GNaC8Wr8ApH/w3Tlamn9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9fd56a-5c7a-441f-469e-08da704e59cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 04:05:04.2575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6SqXkjLsSwq3EjLFWQ1kuNFDUrFbXuso4JMJs0RzIofNPI4E/MrsLZR5G3R/w5bTKcjulHmnik292Y+4iNe2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5496
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, July 26, 2022 11:05 PM
>=20
> On Tue, Jul 26, 2022 at 08:03:20AM -0600, Alex Williamson wrote:
>=20
> > I raised the same concern myself, the reason for having a limit is
> > clear, but focusing on a single use case and creating an arbitrary
> > "good enough" limit that isn't exposed to userspace makes this an
> > implementation detail that can subtly break userspace.  For instance,
> > what if userspace comes to expect the limit is 1000 and we decide to be
> > even more strict?  If only a few 10s of entries are used, why isn't 100
> > more than sufficient?
>=20
> So lets use the number of elements that will fit in PAGE_SIZE as the
> guideline. It means the kernel can memdup the userspace array into a
> single kernel page of memory to process it, which seems reasonably
> future proof in that we won't need to make it lower. Thus we can
> promise we won't make it smaller.
>=20
> However, remember, this isn't even the real device limit - this is
> just the limit that the core kernel code will accept to marshal the
> data to pass internally the driver.
>=20
> I fully expect that the driver will still refuse ranges in certain
> configurations even if they can be marshaled.
>=20
> This is primarily why I don't think it make sense to expose some
> internal limit that is not even the real "will the call succeed"
> parameters.
>=20
> The API is specifically designed as 'try and fail' to allow the
> drivers flexibility it how they map the requested ranges to their
> internal operations.
>=20
> > We change it, we break userspace.  OTOH, if we simply make use of
> > that reserved field to expose the limit, now we have a contract with
> > userspace and we can change our implementation because that detail
> > of the implementation is visible to userspace.  Thanks,
>=20
> I think this is not correct, just because we made it discoverable does
> not absolve the kernel of compatibility. If we change the limit, eg to
> 1, and a real userspace stops working then we still broke userspace.

iiuc Alex's suggestion doesn't conflict with the 'try and fail' model.
By using the reserved field of vfio_device_feature_dma_logging_control
to return the limit of the specified page_size from a given tracker,=20
the user can quickly retry and adapt to that limit if workable.

Otherwise what would be an efficient policy for user to retry after
a failure? Say initially user requests 100 ranges with 4K page size
but the tracker can only support 10 ranges. w/o a hint returned
from the tracker then the user just blindly try 100, 90, 80, ... or=20
using a bisect algorithm?

>=20
> Complaining that userspace does not check the discoverable limit
> doesn't help matters - I seem to remember Linus has written about this
> in recent times even.
>=20
> So, it is ultimately not different from 'try and fail', unless we
> implement some algorithm in qemu - an algorithm that would duplicate
> the one we already have in the kernel :\
>=20
> Jason
