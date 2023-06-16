Return-Path: <netdev+bounces-11303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0637C7327D7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DE92281636
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0CD655;
	Fri, 16 Jun 2023 06:47:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2C624
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:47:44 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1777F2135;
	Thu, 15 Jun 2023 23:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686898063; x=1718434063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aqoIz+OJDjcJ896jxPMaJfPCub45v5RPQvfkgrTeT/I=;
  b=Vq647Q3NuYbIu7N/WXFf666t0BaE8iuIngL/fRf0hJKqoHivbCd2ix6A
   9zT+HwMc5Syz/ADySFODC33F2zaxKSasSsjZeWW/RL65hVazMwCdOaVuh
   QR95xSPTsFJZUwHquR1jFcHMsJrJ8quCTNokJ+3YSUTDyojKPhp06r2X2
   AkM2hIp0MyZxbxU0UWZ9pgL+Az++N1VXjvTv+8eGwCcYxRkdLRV3ieiMy
   VOtZiVpIxn+xntOmF0rTpeHRq9litxA7gjc4cVj41N2XhBr3g6ugx97qW
   XvaotW+7VvoptmIOYHHgLzsS1K7ymMcOotPQsSx1PJb5XaQKZMrL9c0ht
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445523039"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445523039"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:47:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="663077979"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="663077979"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 15 Jun 2023 23:47:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:47:41 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:47:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 23:47:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 23:47:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWcnayeKiNOVjBfZKoEIHt6YBp8MxG8UJXzml3h/zngJAD1UEpfgcKc64In/2I5jk5rnRSVwlkhY6K8tA8X8d2qS7KMnIsLnxkgdxDqGcu55DvSjujZfURllUXp7sl1DS6z5K656GV43YZ4IyF1pWq2/VMNXTdcXgI1ivZOU18W8R8R4jLscexn/Ava5xVpUrh81V7BLSb47vmYYMd/aXdZlePo1SQnetXfFT8Ul6bLLmN7mJ0BWL1a3bvm5doN8G2db9rxqGs+SwDktpKNzgvIZuW+B6pCzuyio/+z4oAsDwngotHjZ/b09oIezg9SANibrmDdoSUznvAS5MnIc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86zYGFHr9SOSXh4QmiindPVChuQEA2Rix9+jezFJty8=;
 b=B/SmxCwFqQvxywEM1TP+F7SZOKqP6VFoCi+8OgxsDE5aYS7rstDwIPCXPS9MJGwp8b4ZoaqHy2DN+oxWd4OxjiEFe6oa7cFzoLwpXibnzh9nQQdbTBfovXsREOmvHcWeTaRGuq60V3zpu7MdHXWcTt9Cou5cBaxd6NEwTT/dCd4W+VCIa0/ipoY7xTg5q6lp499yiXjYKkq528NV5aCWyTso9iWSI1jTXn76a6OZwrpTEPzgxnrh6ZVIS3SbJSOVhvI193ZXrt/rpoowWoQh4efqvEfRL4F1Xgnm1MCcuNRl+9C6osxDe8Ytzyv+S5rhy54nvf+vrXL2utsNRZdUqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB8192.namprd11.prod.outlook.com (2603:10b6:610:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 06:47:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 06:47:39 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 0/7] pds_vfio driver
Thread-Topic: [PATCH v10 vfio 0/7] pds_vfio driver
Thread-Index: AQHZlZ4dNha9H/OwQkSSQdhDRD0P06+NEW+Q
Date: Fri, 16 Jun 2023 06:47:39 +0000
Message-ID: <BN9PR11MB52764A3D962F65B25FCE88748C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB8192:EE_
x-ms-office365-filtering-correlation-id: 01eedb20-c651-481b-1b68-08db6e3593b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TFkDFDg1+q88JUF81Z4tygfKyDq+X+6kopw9xwR286tL3LkNThKpCTGHxm2uQu8I801bzTw14KMraMlpXLaHtusn2WmvbzlL4MDrlMmZfm2Tii+vzM27pS9+YFNqFd6ywFuFJiDaArencihm66KtsOT6Ak9Xy5XwslIegcbeaxbqpNmoZkXPN9G6rLpqOmlQyAsWYmJiXMj5bpkgkeAW+dXUTZhwRMDJj4Aqmuq/CvCMDVb7l3BVPmRb7g6KMwC1A7pduTWX4DYSr0HtNp90Vm8aaQ6Ze2VpnrTkv1N16lDXjog3id8qxVVLWmKwkKPNFZoVzmvoq9PYjm/DihjBkShUmQkY+sJFvwVLBs4od/ibbMnWzr3RCPaV2VxhwKSUG8uBBhSvNnSB3NENcoVZ08D8ikHLJBaEuxbsFd5KThu9Es/7Vu04riSOD6iN3WsQcrcTYxqgmrBXMmpSCTTPMu8AigNB2LqlkFK6xg7S1a7CeIzncRbR+h0O5XIi3UGhFTDdtEDfymLSN0OdSqTOMyuvmdT7Csw/iQ5AQnwvmRyjXl885Q6u/Hb1JHa788sZVMBKUq4I1dKdK3YU1nP28jq0t8EGvfY+6zut/ZKRx52rD+ZAHysTLBYySAhSSUw5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(71200400001)(6506007)(9686003)(26005)(66946007)(4326008)(316002)(64756008)(66446008)(66476007)(66556008)(76116006)(186003)(83380400001)(7696005)(122000001)(55016003)(110136005)(478600001)(38100700002)(8676002)(52536014)(82960400001)(8936002)(5660300002)(41300700001)(86362001)(38070700005)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Elj+YZ3WeJkcqFXzdPcfnxgPZ0I+jy4gHfDkFTYc71Le212l2+tTXfzehAcX?=
 =?us-ascii?Q?+IWQpDa6y92iJa7Sal8bbhyiSzSzYsOSSkMT0c6FPV+qdxEfmRA+XFedcqHy?=
 =?us-ascii?Q?e9MCOjPMN5lJ9HPC4gXJBZZgrsTq/OfnHt1WChWwKme0v30wx6Mcyuxh9WfM?=
 =?us-ascii?Q?XmI5j2uV3opGz2S0M74hIkVudXsIuyeNH39G/vYKVjZkHtJ/dFekdyjHOLGR?=
 =?us-ascii?Q?wjN7HL4FlrPv1BakpMHUfY8gdvaYye1a9SoYwwZmekUYhpi5hw72UjsiFEca?=
 =?us-ascii?Q?QhUJrMPxZJbJSRDczujmicLTVzQqTllyVyindVgCI+K1ViybV9OLs3opBEAX?=
 =?us-ascii?Q?2sA6kIXlJL0Vw+7Jn4aW3k+IzpnZTyffYMAoVK1w30+iTFm3oi0QAJ08dzLX?=
 =?us-ascii?Q?aNUEzLQpHvv7WVvTDxNdpZ6j8RxWsGAaNOQ7Xmo1ujnyGORN76rvedV70Wlt?=
 =?us-ascii?Q?oqd+aaIYOsOJIUnQbh9SD5CgKLNZNoOL0C5efYpqWIbFGD5W3ycOWGS4c1Ww?=
 =?us-ascii?Q?379soGmIXe9Zge1rKv/CpnT3RP00nRMmDJUx8w0QE1JieCDzRz6FRB2YUYCm?=
 =?us-ascii?Q?A0XCxznpCS6udSQqjPFLSFUrMf42S0brRg19Zr9HuyIWhhjkogybFbpi1/hV?=
 =?us-ascii?Q?RXZDJvKF9FrcLfw8oonP9uIJhuOA869HUfggNF1relg6/crnfB8jiv+c8dyC?=
 =?us-ascii?Q?abPiLHb0R54SVb+DQZpNGwlLIVU7730FyzI8xbHM05uedyWxuMWLjUh0O1gX?=
 =?us-ascii?Q?zhELAM/Ol1Xc9RsPvkpGik9qVpCSe1NyVyJ0hn0XCa5++Q8cNkRZqiowVK2A?=
 =?us-ascii?Q?yWuMwWiXdRzvkOW2j55bfsKLXWoCG1EBpBIoCXVasvG7tzAnVWbvO6YWhOWd?=
 =?us-ascii?Q?Cvwl19rEhdSfiE3CFdt36DyncpevS/a8ci+/FMnADb/vunjgvMCp0LGVBiXz?=
 =?us-ascii?Q?JMdzm56n7wlqsmQTTJ0EAu2hctJSMFhkj1r60PJeWm5WVypmpavMhqnE8QXS?=
 =?us-ascii?Q?joneYHMFXwDlfxA+J1DsEfs8w7CCuk4yHzWd5vecdLE5T1nDFKl4Gef0XTXb?=
 =?us-ascii?Q?KVLk5OUeGJj0Z5JiXYkvfS7jabLYqXoZe/VOgffdLoC1XWPG4dZ4PW4UlrJ9?=
 =?us-ascii?Q?/7vVDGyUl4E2xT9S1rmzPljx09U7ptsMc6MaqdHPoFPcCb3j9KGePoyx+MWr?=
 =?us-ascii?Q?v89s2d/pM7AJrFql57YRzVKTUTGo3nYPhmo7NdzpZucd8jg/V2u5JPpP18WQ?=
 =?us-ascii?Q?uy+2P0dYL57TXn0c3TtDS8VrorTnsmOlT+2tqa8Fw5rPZwC4kLCH8lfgW1ov?=
 =?us-ascii?Q?jVcuJN2BxJPM0n+EQyFXXZXRs7fLVEM9ifxEthUx4/WeQsKsn+QUoGaxKSjv?=
 =?us-ascii?Q?GoSDk1uGFaQVMStb5UPTwrF2xgsU+KMOm6lGAlmK6WeP9Cc1Af5NIAfVzQDt?=
 =?us-ascii?Q?QlWEO4849PfkY30YzLA80Q/YM91sQvckflrjYucte/osJxEcHCXJGYOGp8tq?=
 =?us-ascii?Q?4LTBaOlN4D2cZYf0wJdUxcHP6lrUR5GQWxdqkQGPmYO+DMCWP8ZiqLeb3l0h?=
 =?us-ascii?Q?5YjDIbJuTL1AMUrvN/yY60V0fZxjmiPg7mB3GDzB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01eedb20-c651-481b-1b68-08db6e3593b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 06:47:39.3303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSiaKsBD7CeKdaU4etTI3iOHc4QlNuMD+PCIWCtokN3Bax6LSDlSmu0bwNLrJn1o2Q542l0yVBfWXYYyOcfz/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8192
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
>=20
> This is a patchset for a new vendor specific VFIO driver
> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> (DSC). This driver makes use of the pds_core driver.
>=20
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
>=20
> In order to receive events from pds_core, the pds_vfio driver
> registers to a private notifier. This is needed for various events
> that come from the device.
>=20
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
>=20
>                                .------.  .-----------------------.
>                                | QEMU |--|  VM  .-------------.  |
>                                '......'  |      |   Eth VF    |  |
>                                   |      |      .-------------.  |
>                                   |      |      |  SR-IOV VF  |  |
>                                   |      |      '-------------'  |
>                                   |      '------------||---------'
>                                .--------------.       ||
>                                |/dev/<vfio_fd>|       ||
>                                '--------------'       ||
> Host Userspace                         |              ||
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D   ||
> Host Kernel                            |              ||
>                                   .--------.          ||
>                                   |vfio-pci|          ||
>                                   '--------'          ||
>        .------------------.           ||              ||
>        |   | exported API |<----+     ||              ||
>        |   '--------------|     |     ||              ||
>        |                  |    .-------------.        ||
>        |     pds_core     |--->|   pds_vfio  |        ||
>        '------------------' |  '-------------'        ||
>                ||           |         ||              ||
>              09:00.0     notifier    09:00.1          ||
> =3D=3D PCI =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D||=3D=3D=3D=3D=3D
>                ||                     ||              ||
>           .----------.          .----------.          ||
>     ,-----|    PF    |----------|    VF    |-------------------,
>     |     '----------'          '----------'  |       VF       |
>     |                     DSC                 |  data/control  |
>     |                                         |      path      |
>     -----------------------------------------------------------
>=20

why is "VF data/control path" drawn out of the VF box?


