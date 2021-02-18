Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D39831ED6D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhBRRhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:37:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:27285 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232520AbhBRPkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 10:40:39 -0500
IronPort-SDR: haQElPdmSWjnJ5gboxVreoyoNf9K0FpmJZyjjeSYnAHj/QQPo6Q6J8S+I/1GSmNeA2pmipY61b
 Zgpnenxh8UGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="183602011"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="183602011"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 07:37:57 -0800
IronPort-SDR: cZIA8OWCV59Y9OPJ3f8ZjratFwUBjB9qRjJpENbUzELVOaceG+TI9wjWEDNLGhgO4fRjwvtkGe
 igyLVsNb8X4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="427249917"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2021 07:37:56 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Feb 2021 07:37:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Feb 2021 07:37:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Feb 2021 07:37:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPSs5li8iUgo6koe3yQ6Q1VaEVYWUdrTG30rsbfFh3vt+cvPttmwzIRhV1/0NxjMcoGjAUPpu2iKJ4a3Qx2Ock6mJnwq4CeDo45e0aY3kLUP8xG/Uts03I1wAIavBB35h3WCz0LGSM1UTCbFt+EDGAxmhwhP9GyygvOyriKgn9MX9pvZAwPHIXL8hSlGUGW3Kz4/WEId7JSfmU7Ii2PzjUL19IOx/wrKr/Bfz34eydRS0+3hanfr7W93PE3qTnKT4rYNT0GUH3aW0Z4KiT49OGMjkG6GCMXbgKLdrsJShRWmijVruVzJSofje48i0ahmgKXnyQR9ACfjvx4Tg3xt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58cnwgrL8uSlZCDddzvODMa2mZoW45T7mAI4FzoS6Rw=;
 b=I/vcne24+SkVRKsVO6g6JnmZJf7DHRMCRgaEqLOzhpj8/WulCKRFGl5zUK53sLn791pMs+M3uIwYE9i5pQEFrExn2EWH4XnqThYh4xsaRJwxI919bCFg1XIbqoM00SazwG5ZQK9n2aS5O0Y2La7SIT8IQdxDUeyL5Wi38nDSOqG8xLB/YNL3zyEmu06Y/umDyEQWBnaSkCfv8cIvaD+ImIW4gN9bWbRW9KWZCloxm4MLraEPM+uvZd9F8tu6951JGR9MVK9xvnHTT7pwuNHynJwM4gCK7aNAqjX/EwiV6q7qFPpyYDesjZslT1gFlcEREm4h5av2poHUVQTVhtSR4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58cnwgrL8uSlZCDddzvODMa2mZoW45T7mAI4FzoS6Rw=;
 b=sA1dPUMS7Sow9pzZVb/ci7kgdstH9ZvD9Osb43jI3hbGWYdBS8OaR450pJcdyxg2pKLGkzynTMACwRCy0AxAAnqEeeJKmRyIWc6Hwb0MhmQUWth4BZAp5D+fKV/DTZOZ8HX61lkLScheWfIAcFjAQQkTPA/T66ztlHXMxWmxYdo=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB2966.namprd11.prod.outlook.com (2603:10b6:a03:84::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 15:37:54 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f%6]) with mapi id 15.20.3825.039; Thu, 18 Feb 2021
 15:37:54 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: RE: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Topic: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Index: AQHW/9aKF0BC8ECZBUGvMe9o72Vjw6pdfE/wgAAaEICAAHh8QA==
Date:   Thu, 18 Feb 2021 15:37:53 +0000
Message-ID: <BYAPR11MB3095D820C3A094BF773A7495D9859@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-2-mike.ximing.chen@intel.com>
 <BYAPR11MB309511566DBD522FE70D971FD9859@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YC4cxfhaBTD1Mb+2@kroah.com>
In-Reply-To: <YC4cxfhaBTD1Mb+2@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d352104-28d8-47bd-013d-08d8d4232878
x-ms-traffictypediagnostic: BYAPR11MB2966:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB29662D5853A8EDF4A51B2098D9859@BYAPR11MB2966.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Arx5lyqnOxYacUkZDfFlyky9VxElrB8SPx537PUyEfz7FLcKB+cRXiNJBWhmiEViNWAv2Sp/QSr80/puCJodFOhqbjqIxbb/JfTgmPyLNjcBO3NiAosHuqecMmk3nExZOlwlZ2ouyYEoAmCHPR1pZpV/xgOp5854DG3DxzP3t4wwRLtX2AAGcMKiFcQdC3xtH6cOX/UKaSbEArpG2J5uYBBQvLEdoAHP7twlVggQQLlS3k3pD0EM1WFfcXzHB9R0Pc77Hcg98W1a443+DdkOto/OEI8fmklNTvmvL5p+YTDTIivvW/wQnw3/ws4QZpDSKa9Vry20HUw7D2l5iZRHvbnKGzDkYvnOSEuAOMcD+x6iD3p9XLNRXUcvoRb5g5giuNgNOE2Tp+zhFfiZs0YjyeAa+XLajk7LKaWrvDHGIPCh1TjkLisfUOFuLJhkIzC5Idd1UTgwCRqG6sfQQwUUMnNVvpvyn7+lu45XOVxITLTDi2ouXks+C7Fh9IIHI0+KlJx5gqYKCRULoz7s9IFroQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(7696005)(86362001)(71200400001)(4326008)(8676002)(5660300002)(66556008)(33656002)(52536014)(64756008)(478600001)(9686003)(55016002)(186003)(76116006)(26005)(54906003)(66946007)(83380400001)(6506007)(6916009)(2906002)(316002)(53546011)(66476007)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ytxAoWDTnn1M9DzT8UsKtmzK4WcrXhcdBRlw8xVeJf+bxbMvflscvfT82Ytb?=
 =?us-ascii?Q?S010ZYJDfwbQ3jzVu7pacsulmOZzXTW4aIEo57pWOUqtNFKiD/nDCxba58wj?=
 =?us-ascii?Q?K6lFqFAh5vd+5GJKpkDp2OBmu0DHQNvdFQMn1/jYshYqGdredtB8W3UX0xnb?=
 =?us-ascii?Q?IKOoI++2LpVHeDa6e2400i4/B78RzF8jLZr6mxrziI2sbCBFS9IVQB9IAezC?=
 =?us-ascii?Q?w12DmNuSS7lgDy9gGfN0SVKO/CETN8eefrjERfLyr7KqN4o8aY5KUL8C3Q5g?=
 =?us-ascii?Q?KntVftMEfE0JUIH4wrfBhTFoxqLQmqYRA+BWqfdD392geke+L73L7yGxfniK?=
 =?us-ascii?Q?iXEfIH5eZexPu0TKyN2S58ZXQG206iHYhn86gwiIaHxm4ovT44qD49YZfg9f?=
 =?us-ascii?Q?cDwzmQvJ7Y0vlNVX7+Xa1gzA5MCwjWHzZrSNf3f0IeIQRC2R1fTNoQpWZjcV?=
 =?us-ascii?Q?mJe54JSJ7ziay9tpb6wMaqXtx1C5lJn8kNDZAC0FsWrWmmqn9Gyrcwd49Myq?=
 =?us-ascii?Q?lrY8+HpbrZdRxucC7Ch1euolPAfeGTs7tjOzikZ9/rIii8JF0a7fPlEieLC6?=
 =?us-ascii?Q?ghG0j8Z+Xcm17u8Y51g5WvPJg68XJhHlIcQHe5vcdnEbRXS11wltGRkDXsMa?=
 =?us-ascii?Q?MCgvKPe16v9AoHJ+FG+ZGwKvaWnnuxZj13iI2agBHMBJ4+Ip6gb9ehqNnFNc?=
 =?us-ascii?Q?I4ozIIgabBgs4q/e3fyJ/lbjKhVFdRiNAXP+H0Sz6/Ur9HobGnfpys5w9q6j?=
 =?us-ascii?Q?+DXsAA4fpDsx/VsN2YaV02IkkbEC6k0YgrGDAZvxvLpuWJDMeO2ixj3jhInQ?=
 =?us-ascii?Q?25L2vAjtE5RZJHUYlANffpF+RxYGAHDeJhh9bln/CYWuctHFFH9iph81mT3V?=
 =?us-ascii?Q?A86kpSzhjA+3q1qBuUrD804lzYTgmivUh5nBd0qPVbpPJ0Gh7iewHIzJ4/K1?=
 =?us-ascii?Q?G/cNcJb5pZF1KmE6DBJAQq3x5xDokEy/GGsxcK+dw1lCneTe+Zmf8JNwE9pv?=
 =?us-ascii?Q?X4tT70tVpSzWcI3QdBH9lvcvihsn33jHX6ikr8Q2l2E1hh3EaH0Z0nUlcm27?=
 =?us-ascii?Q?J4soEivyJTte5UWkOu32FBJhCF+rQRWoirfFijtDlANiLZPSY6W0TWbgCfJj?=
 =?us-ascii?Q?N/O1Xhqz7baNRpVA44qoleBelvs7INGTGrXXcVzATpzgyC4zXAUltAv1Uk5R?=
 =?us-ascii?Q?8VPMnt2IoRVOnxDURhqhvHS53OB1HWhIQ+AHs7XfaCGKKoAs2jdWhVKYOlq/?=
 =?us-ascii?Q?mkMuEy0M5vTjIrwZ/D5+ATEcge76cG9MOigjkuecW0GRMCPeRDTil1uiv4QE?=
 =?us-ascii?Q?iW+JfdIOEItIXxw9BrvfUDqL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d352104-28d8-47bd-013d-08d8d4232878
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 15:37:53.9862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TaSTd3xc+BAOOBzUiszjIoM+wjByU44SeHPa/fdXfZTB+wMmRDQRhKgyX1Z8ypEw1wHCgA2dQiaY54G3VEWw656x9DZIyW84iztPhS/1+fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2966
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Thursday, February 18, 2021 2:53 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: netdev@vger.kernel.org; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; davem@davemloft.net; kuba@kernel.org; arnd@arndb=
.de;
> Williams, Dan J <dan.j.williams@intel.com>; pierre-louis.bossart@linux.in=
tel.com
> Subject: Re: [PATCH v10 01/20] dlb: add skeleton for DLB driver
>=20
> On Thu, Feb 18, 2021 at 07:34:31AM +0000, Chen, Mike Ximing wrote:
> >
> >
> > > -----Original Message-----
> > > From: Mike Ximing Chen <mike.ximing.chen@intel.com>
> > > Sent: Wednesday, February 10, 2021 12:54 PM
> > > To: netdev@vger.kernel.org
> > > Cc: davem@davemloft.net; kuba@kernel.org; arnd@arndb.de;
> > > gregkh@linuxfoundation.org; Williams, Dan J <dan.j.williams@intel.com=
>;
> pierre-
> > > louis.bossart@linux.intel.com; Gage Eads <gage.eads@intel.com>
> > > Subject: [PATCH v10 01/20] dlb: add skeleton for DLB driver
> > >
> > > diff --git a/Documentation/misc-devices/dlb.rst b/Documentation/misc-
> > > devices/dlb.rst
> > > new file mode 100644
> > > index 000000000000..aa79be07ee49
> > > --- /dev/null
> > > +++ b/Documentation/misc-devices/dlb.rst
> > > @@ -0,0 +1,259 @@
> > > +.. SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +Intel(R) Dynamic Load Balancer Overview
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +:Authors: Gage Eads and Mike Ximing Chen
> > > +
> > > +Contents
> > > +=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +- Introduction
> > > +- Scheduling
> > > +- Queue Entry
> > > +- Port
> > > +- Queue
> > > +- Credits
> > > +- Scheduling Domain
> > > +- Interrupts
> > > +- Power Management
> > > +- User Interface
> > > +- Reset
> > > +
> > > +Introduction
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device t=
hat
> > > +provides load-balanced, prioritized scheduling of core-to-core commu=
nication.
> > > +
> > > +Intel DLB is an accelerator for the event-driven programming model o=
f
> > > +DPDK's Event Device Library[2]. The library is used in packet proces=
sing
> > > +pipelines that arrange for multi-core scalability, dynamic load-bala=
ncing, and
> > > +variety of packet distribution and synchronization schemes.
> > > +
> > > +Intel DLB device consists of queues and arbiters that connect produc=
er
> > > +cores and consumer cores. The device implements load-balanced queuei=
ng
> > > features
> > > +including:
> > > +- Lock-free multi-producer/multi-consumer operation.
> > > +- Multiple priority levels for varying traffic types.
> > > +- 'Direct' traffic (i.e. multi-producer/single-consumer)
> > > +- Simple unordered load-balanced distribution.
> > > +- Atomic lock free load balancing across multiple consumers.
> > > +- Queue element reordering feature allowing ordered load-balanced di=
stribution.
> > > +
> >
> > Hi Jakub/Dave,
> > This is a device driver for a HW core-to-core communication accelerator=
. It is
> submitted
> > to "linux-kernel" for a module under device/misc. Greg suggested (see b=
elow) that
> we
> > also sent it to you for any potential feedback in case there is any int=
eraction with
> > networking initiatives. The device is used to handle the load balancing=
 among CPU
> cores
> > after the packets are received and forwarded to CPU. We don't think it =
interferes
> > with networking operations, but would appreciate very much your
> review/comment on this.
>=20
> It's the middle of the merge window, getting maintainers to review new
> stuff until after 5.12-rc1 is out is going to be a very difficult thing
> to do.
>=20
> In the meantime, why don't you all help out and review submitted patches
> to the mailing lists for the subsystems you all are trying to get this
> patch into.  I know maintainers would appreciate the help, right?
>=20
> thanks,
>=20
> greg k-h

Sure. I am a little new to the community and process, but will try to help.
Thanks
Mike
