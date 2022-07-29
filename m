Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86829584A09
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 05:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiG2DCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 23:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiG2DB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 23:01:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B6B7B7AC;
        Thu, 28 Jul 2022 20:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659063714; x=1690599714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gG88/ZzA4rbceH+ZZbcWOfvJIy/u1aWiyDyUZeh4og8=;
  b=bEMgCbBmUjE9RlNgRL10hJqCyUwZ2T6cc4rrknkCnVLTSzbJrO2ZCESR
   DqL1i4PZbqHb3bivD1VfgKS2+sW3N2mdf0dNVq4mOmBMxk4hillXz2Ci1
   Ect2UU5ML6/vA/m4pwlzHtJAY27rCupakGz0O59Yqge2iO1Ln3zwvOYiE
   kZdrF4XZeplH7gCTCCsIJ0S70f68WeKpTrqjk+AZh2T79L6uZ8oaHAMbO
   CTMSGIaHOsz5Sj8dD6x2AG8Nb7LwxtuQAFu/3wufT8KNzKNWio2FbeB7o
   BslzRdZdMumEYkYjj+UK5Ax8CyLLHU8ClZqETZWf0bDz96f9h7XgCimbz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="269060047"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="269060047"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 20:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="669126605"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jul 2022 20:01:54 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 20:01:54 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 20:01:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 20:01:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 20:01:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvTVvOvlMwadAIT1LKYmVX6ECLX15OhXn2sWTCYBAKWeM53AWuRL1cYnqPLyHYG6q5X275UjnaBv1SgRBMyEBhJnmBBsIGYaiEUoAWyJOCIPLEr321p8AGrXgdJcQcK6mFeHsK4sgKXE//JW0z/U+kWQ4T+qvY9whaPx8VIrUNsYX7HpmR9hk0ejAZnSHD1tP0aslBFaEdzoBvv7UWFt0lpvI0612YEYTFveSYCij1mdhLwtCnhwVEJ1A8qefMrYfhw3gUSJyOGMRd7h+zOk56BVVtj1kEl8l9OpUp1YdxSAKf21cX7YioBnActSCsIk3X+j66e0WzDic1IVcHoWGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gG88/ZzA4rbceH+ZZbcWOfvJIy/u1aWiyDyUZeh4og8=;
 b=b+AoDpkfkHd0AO7clei4Yo3Xw6ll1ZAjQXB7FQ561ZSDsd2SIqdbf7VOyGzs5TjgtdmbzoHkFu3u/NIm57GLckERCuZyylpKQf8cTSCPiN8GEcX7129Q0RAxbe8zXIASakiGeedeHyt+tee8JG/V9ko6Z+o2huN4MBRqqRewzCLMoa9Mfcf5sZWlsJQlHE5ERnMRvHfa1nVs7CEC14yFvyFHTk1cdCwx7GNbEf+EYD0Da1J+Xp0pWnUlwLq6Sjv20G8x86guNC6i5nN925/CwJkaEqEQ3q5rNpNQdaPRowQfvQXaZn4Vx75IEak/PMbHgsY3QEPaHJSDSCSWkBJTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 03:01:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 03:01:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
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
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNggAAsCgCABgpRoIABp/gAgABa8gCAABExAIACXSyQgACVnwCAAPkIcA==
Date:   Fri, 29 Jul 2022 03:01:51 +0000
Message-ID: <BN9PR11MB52763DDCBAB61A47693B83B38C999@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
 <20220726080320.798129d5.alex.williamson@redhat.com>
 <20220726150452.GE4438@nvidia.com>
 <BN9PR11MB52766B673C70439A78E16B518C969@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YuJ7vpwCPqg2l8Nq@nvidia.com>
In-Reply-To: <YuJ7vpwCPqg2l8Nq@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 70243fcb-66f3-4541-4021-08da710eaf56
x-ms-traffictypediagnostic: SA0PR11MB4592:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RWUT96Tv2wrXMKPR2BTBLjCg9ILqF6upJMiplllWOh8ee3Udiw8v6pX7BQ1BFKljN05XtW4Rj3PQmg/sOFhQpMpJ9GJhHOqHdRt1x6k1f+6DHh4hI70aehEUQe8KCaQItbhimIpAonYMl54yR0fBVrGq/p/BknXvDkdfo8CfLueJF6T/2u5AgPK8/JpIYGdbUsglAChXEq+hTwFeBPebTd0ShZZjeaGWWoCXWimCsxK6Xz1f/0HWLCYRaPYlq1Mq/6e7R9ihQAe7WnMJPDRP0qD32HyfPDWvcP+QlgDgMKmgHBdlh6E5WdXg+881wHx0Jgq6Rcb6cjGVHN7LgvmpaRHcPo1afr+aYZq8W3zkXXDnAtPm6UgHHLJn3cEn2cPc0ABpNKuXf79bsHnEkRsl7nJ33xIu/qTfg8J7v1t36SZ3roHeBizmWF5q4nLbmXHRhAHGWjPmEeEAbOuPicN85OVlzpCulqzQZfDxEdaYAkn5vRKRAd4KaIOk0QR+5C0S9FTH/8zfOVHvVQQSkgGS/hj+a2slGghNuMKYtgTfl3dniz43nSwSDjSi5hK3KyHri2c77KrVbuZePyvp0KFUEMvRl5A7l3K6kVwGqYdGnuOD70kSbUrWy7J4Y8YnMVVOL/7M+cTmVcIheV3Wc0l7wh6ZcDT1eLhJEtEqzCMxb2JaqFm94rmg3qNG6z5oaTW8WtNhngmIvCx+9Zq/g7cjBSiWz0PJmfXPuoIXpixXQzXsykA6XM0od+CTskSp7YcTVSfumaxPZGnWmO1c07HdejtarCgC4DL1M+ww3q0BwE/9mPilRF7oDZnuHeToLwQa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(136003)(346002)(366004)(82960400001)(52536014)(4326008)(478600001)(66446008)(76116006)(66476007)(7416002)(66946007)(8936002)(122000001)(8676002)(316002)(66556008)(54906003)(5660300002)(6916009)(71200400001)(6506007)(186003)(9686003)(33656002)(64756008)(2906002)(55016003)(41300700001)(26005)(83380400001)(38070700005)(86362001)(38100700002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jzxZsBk79yVWvujJcJ2ZrSCMpZU/zYwW+eoLNuj/E4AE/DOorNOzHKd8LvYG?=
 =?us-ascii?Q?eXx/QRfXQsuVXZ5/Lk2Rzxir1ZWM5wl8/7TxecnPlgC17imK5bZ+c0lztYkd?=
 =?us-ascii?Q?gWS/END2Te9c5q66DF/TRHV0nIQSLmGLZHoVNFVv8mACpcrqMamaaqhswgpj?=
 =?us-ascii?Q?yr96+6aRdfG6ZAHpMPDSBT/jLIA1KO8MqORbrrmOgFXkrl+oE2bqQb8rRo2R?=
 =?us-ascii?Q?yUA7DAKdHmaXLw6Xbwc7B1g+lh2RPYauSCqnbTdWfFrIbbdruYPPlqR4+7Wp?=
 =?us-ascii?Q?cAeijQw7nrKPOjTWCLD2YEJclv3Z+w2zicBnJK/Tahs7UpBEeZ/vxm551NDS?=
 =?us-ascii?Q?ZAFZBBkLLiLzirho9MPDY3ORdMy03P4CzqW4AisekI8s9u94E+PYfohESqLL?=
 =?us-ascii?Q?SUds4pmav+PKSYkkcH/iQd1zD/dAR5l5J0p2GhjpeL7SO3y11n76icb6DcLt?=
 =?us-ascii?Q?mDxulLo+TrtL8CsaaE2oW1W6qNoXSE7s8EWsfoXxNx0wUA2ix1NBYpMgigKT?=
 =?us-ascii?Q?MO24AURhxQOHQrPYKdXNNa9AIMO3z97msYZaC5Er5r26kmO443jzdKmjxSsA?=
 =?us-ascii?Q?1nnigm2kQnBkuIBki5JAwXSNFHfhsNrKXB7PfRoCG+7OCCeiWuOQqoWHoYG1?=
 =?us-ascii?Q?fHp80k20nk/TWIMH6N0hQra2shRcYyAm/zb4t81yIOQ6C77FnVwIlWXawBKz?=
 =?us-ascii?Q?Z8iUYVrAn6HA2yZ2rF+yuU1vTFxAk4kgyp4xDuNEq1SqOx+lxaeOe3Bpklx4?=
 =?us-ascii?Q?6P1Ew4OKXr8K1xhnTa1tJncqFK1iP+OcZUTkWZMqa/cfUuYdel0JVuLcQZ8r?=
 =?us-ascii?Q?FvkwI/DdtFQoji4rjOX36oDA77je5DKgBipFwrHy3hIjIj0KLWq4bkb7rjkm?=
 =?us-ascii?Q?DyPdhxf8W3G38jGSapo9f0ksGhTEYUMPHP0lqV/yKEpTRmIOM4uD+frOhgPB?=
 =?us-ascii?Q?f8yGUnRJ64pHS6uIjYCFlSUuWNefO1H+2EGAlfOZo//v3mZiIr7TQ9dCjxZD?=
 =?us-ascii?Q?33f6iJOljcrHgGdbwmzkk9/tFSx3AdHduStmRtFiHkIa+5vQWPPz41lMMjHA?=
 =?us-ascii?Q?xAcHoNp0neBl6LDr5sKeTmYUNLeRR7SVpYLh6Z7HSDuvdfIlExFlXy2OBALs?=
 =?us-ascii?Q?ENHWVGgf/tsR1KWO80Szal+T3kcnksxteMPjPQCsEejvDprbC5a6uBKjb2xl?=
 =?us-ascii?Q?lgjsN/w3o4rkv7Wh9sqGm4mdRK64qj9n3VSGqe3qogftLbd01bGXJ51pW4p8?=
 =?us-ascii?Q?n8Sogu00lbboc08wFWsDLwmthWYXzW9xy23HEoF7yZFLsUzcNCIUkRzZOemv?=
 =?us-ascii?Q?Cyy1kPxKMCxcKPif1PdJ6sfGvr1qwu1fmUs7DSrr2/KxBNFmVY6XLXA4TBzZ?=
 =?us-ascii?Q?WNY+t5zpyIIpNxX/tVxM7W/5QcIL5Nm5a4j//5rvm+V0EnbYwyE7BXB6wDzj?=
 =?us-ascii?Q?9gKNbcMZO0ef45I5oSV1xRrbbWbNqO2JhWfqWEiNz7KxKG2AsVwF0Qzw2/m/?=
 =?us-ascii?Q?aW3o3s71pxFprCSwCQ7nb13P7DVjg4Nkq9KfV/JUWdLL8CGJrgdw63e7cVWn?=
 =?us-ascii?Q?QV/K48s02z+GKXPIveuHKb+U+dvstZUBrVD1V9IY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70243fcb-66f3-4541-4021-08da710eaf56
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 03:01:51.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: byQPvn7HcqD+oeVdCxQ+Yy8tFtIx0vjkDhWZjOd56JLhCn4XL4IvVuzsOjJN2YfhHDlD4MqptMf9+r7GZiCDXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 28, 2022 8:06 PM
>=20
> On Thu, Jul 28, 2022 at 04:05:04AM +0000, Tian, Kevin wrote:
>=20
> > > I think this is not correct, just because we made it discoverable doe=
s
> > > not absolve the kernel of compatibility. If we change the limit, eg t=
o
> > > 1, and a real userspace stops working then we still broke userspace.
> >
> > iiuc Alex's suggestion doesn't conflict with the 'try and fail' model.
> > By using the reserved field of vfio_device_feature_dma_logging_control
> > to return the limit of the specified page_size from a given tracker,
> > the user can quickly retry and adapt to that limit if workable.
>=20
> Again, no it can't. The marshalling limit is not the device limit and
> it will still potentially fail. Userspace does not gain much
> additional API certainty by knowing this internal limit.

Why cannot the tracker return device limit here?

>=20
> > Otherwise what would be an efficient policy for user to retry after
> > a failure? Say initially user requests 100 ranges with 4K page size
> > but the tracker can only support 10 ranges. w/o a hint returned
> > from the tracker then the user just blindly try 100, 90, 80, ... or
> > using a bisect algorithm?
>=20
> With what I just said the minimum is PAGE_SIZE, so if some userspace
> is using a huge range list it should try the huge list first (assuming
> the kernel has been updated because someone justified a use case
> here), then try to narrow to PAGE_SIZE, then give up.

Then probably it's good to document above as a guidance to
userspace.

>=20
> The main point is there is nothing for current qemu to do - we do not
> want to duplicate the kernel narrowing algorithm into qemu - the idea
> is to define the interface in a way that accomodates what qemu needs.
>=20
> The only issue is the bounding the memory allocation.
>=20
> Jason
