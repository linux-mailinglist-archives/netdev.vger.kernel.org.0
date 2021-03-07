Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3993301CE
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 14:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhCGN7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 08:59:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:54299 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232038AbhCGN7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 08:59:05 -0500
IronPort-SDR: wGhnbZiP50Of1u1nIZxvKGymLRcIXt3e/XgYI4U7b5o0qmn6xScWIsPdYgx/cRlSa3Q0R6b6Ne
 HdcjS0kakjKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9915"; a="187260158"
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="187260158"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 05:59:04 -0800
IronPort-SDR: A4bEDb0IAwg+up9eE1oULqCxIIYRzeQ2B8ICWqE3XGYCwUxhOI3Nvg3LtLeaxEwUSiLQ8gKvy8
 5Oy3a/CDU4xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,230,1610438400"; 
   d="scan'208";a="601819866"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 07 Mar 2021 05:59:04 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 7 Mar 2021 05:59:03 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 7 Mar 2021 05:59:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Sun, 7 Mar 2021 05:59:03 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Sun, 7 Mar 2021 05:59:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+oG/BbyOqkbGSTAhc3QvWDtTiOAvmeP+u4Vt1gPFBcyadwr30m3RXFQ9yfutTB15FcPfv9ZpbC7WgxJDZlpn5hw7CE4jxvHOO4Z61IHc9xnDI6hQsPLYsBCCNtpFVQAIzLLtA0xfySZPtmhBfPIcRWqOV42wsX5ViR+kHRiZU3Oy/BVUIAUnvfb6259x17xLuVcdBpAbV+I3rWhoILVIksNpvDEeBCwjcD2Z1G1AuW84Vwfw1tLT3v+A9N222+BATHjnW5sjMiqpgri0ZpF2we0gHjPnuICps8/yMSpx9iAEcjjGb2e8Sqk25SHJtjJtLF0AcY4Xxum2bYz/FiLjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EuDsMt2+PMq62l1c/OtUy3bvdtBGgQavAnkGNe8yCw=;
 b=PxjoKoN+XkCVLeh/w1VT0GXjpS+2R9ayVMpzwIfEBBNmbytwnwrfwZuKm5rYcgesDIe4B3bOZvqrOpqs5xauLAQBeZFn3VJ1VwbfVLktOUF9b/RY92CANON4CFJx1XQaSgQdmgEr4wzvd9KYWMxY+6k/kjayV6svsE2v1pkgDFkshBhDhh3miDTaogKBTS5ksB4IXhbeAVlLFuRLdV7o8CIF8jU4Kynuh80ay2ZrbY0HWIS3Ka9D92Qp92Ucqqmg4BjU/81XzfnkYCdXaZsA1InZ8A+U+eZBup3Flg/E7lAvx4s9XAG6j2Y9lx/PWJDdNJ7OU7txG26TwoS1ULBOhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EuDsMt2+PMq62l1c/OtUy3bvdtBGgQavAnkGNe8yCw=;
 b=d8eHRp6C5Sbzi0i5R+y7G2+I07iOru/Mz5ZXRwAsQXHFfAs+7tKJgYvsJqtwtgEPo8o2L48y4SAxS4GABCoZIDYKxRQAklawmStOHlmoihYkngX+XIIlH7zPKwAfMF5n4IglD0dHjfzXpI39o5sJDPXwgxQoZkZmMLeUmBYDkOM=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3637.namprd11.prod.outlook.com (2603:10b6:a03:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Sun, 7 Mar
 2021 13:59:02 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Sun, 7 Mar 2021
 13:59:02 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Topic: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Index: AQHW/9aKF0BC8ECZBUGvMe9o72Vjw6pdfE/wgAAaEICAGxaw0A==
Date:   Sun, 7 Mar 2021 13:59:02 +0000
Message-ID: <BYAPR11MB30950FD82E2D9A17CC8A0A93D9949@BYAPR11MB3095.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: d1227bf7-60b2-4b6c-d131-08d8e1712a04
x-ms-traffictypediagnostic: BYAPR11MB3637:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3637577B558918758BAE90AED9949@BYAPR11MB3637.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtOyqJtC7TPQiMbIaAfyH/AyYZjUDanN3CTkNCnmwKjaMkmOhmrCxMaAVqm/vsu5bss9mvSNw8ru5RaDmEaXf6/cFno2GU+vxiOAKzpOlfEQ8mr3xtnv+zflbwFREozN7yJTPBPGo1ZY3fLTlvXpu3W2Ff7Q89YajaSUvQ1yoeoxuYHdLWAdcmRBRFYkXBVG5RLaGkVzU+yKH1NSdcz5RUPUabsgYIb8m8wo0kOT3oaaCg7hfSQZpqFwffGml8w52xcT6F2PHSNEr8wK6o5PhnQn8P/x6Ggq3/kNB+YcjyFnl2zFnGDgh2YB1Er208hXBbrUeGwSXC3FqNha5532nzLNGPMvpVp40BnsnYl06Twm7PHGBViI9OP807rI1RzcRXHOZYrXH95H1+oGIQuqcC5UjIBoCuGgjOdqrECJGIIUGJp90xfuI3hWuty5oWTJ2chq23ElWniYDRA7DcOkg1H2HfM/essLhYtajnie+aoIAeLI59hL57XiG2A41bzQjcKkaN1Arvo5A6VTeyUFiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(316002)(4326008)(54906003)(9686003)(55016002)(66556008)(64756008)(8936002)(8676002)(66476007)(66946007)(76116006)(71200400001)(66446008)(2906002)(7696005)(52536014)(33656002)(186003)(26005)(53546011)(6506007)(83380400001)(86362001)(478600001)(5660300002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ycbfMwtuO01EwbLA/Tnpev290lFpY+x1qYoZugKRCtOpuyXX5rW5+WZD3j+b?=
 =?us-ascii?Q?qOOoBy+YK56ujKeo1ercXqMQnEoIpkXCyU5Zaooa10hWsSqWGz9/cK9ufyPe?=
 =?us-ascii?Q?ph+Z5nLlkj6Go3up3mZZ1Oa7iNEl33UO5iUapSkPnk9o7hOVNUANpY8iCVwq?=
 =?us-ascii?Q?Mt2Sljd3lnYP1ecqw3PjcF9imaqB2XFwR0OgAaZGCy6B1hDC9d6aoFM0SfIu?=
 =?us-ascii?Q?V/VGGjvQHBrqQsjXSUdySHIcREOhnGdtlLV1n2WksM3zB55HkuQlMKz5NPwR?=
 =?us-ascii?Q?8Zqrvyw45b6GDGJhObiWYzYYCMl0tZBTWmY3KPvfB65VpwIo9IpxHp2kCKJh?=
 =?us-ascii?Q?cd3IWefesFXAOidxH+3XEtQspabZ1FfPD/9zNCshYSExhuJy1EMQ1reH1Swe?=
 =?us-ascii?Q?KLzrKiTNrW+gBQ326zVkO/sL3Log9VaWIx/pi+bJBKqIdne+9Vzjdr0jmJYf?=
 =?us-ascii?Q?jbSWxxFAVBvhDaXPRI/b63/LMEpIeEatUXWFX8eboImxW3WauX/miM80FeHv?=
 =?us-ascii?Q?FskKcNRYCFURwtDGjZHfbS3TcOuXZlRDcejhihDlG0YVMt8oiwTEm+oOc3ht?=
 =?us-ascii?Q?fgaSCfvo0BmV+ZXGzkhR3KtDIauNTlV2AG7owpEBmsM0uUkfSmXRCQT1CZsG?=
 =?us-ascii?Q?jXisgp8EiqipUyGeI7dH4hUka9iLhRVkhbZ6M/wFnQTOQq1kPlOPr28WgFpW?=
 =?us-ascii?Q?/WhwWzVjVmu4xvoZYkeFeZ/5oSP7z0Y9X3tJSBuDpE4XSpTZOdocyB2EASoR?=
 =?us-ascii?Q?OTOmmHhrakeajtH7EoKlonvOgYFrQ3sw/wfOteu0fpxxVz2g2lKq2Ptp45C8?=
 =?us-ascii?Q?fcG1kWyFMt+iENkrH45T9AAvMMcuq1nIDhHaHB7PkIYiC6HAZ0CyLEUnhnQX?=
 =?us-ascii?Q?305MRxHxiIKpfsT1yuJ722LeapKWY0Osoeh8PtrRd9DOUTjMw92J81plbGaH?=
 =?us-ascii?Q?9uv/yQ94oXowEjm75mhjbe2528zsx6JzpiRcFAiIveUUkDuMShm7GfLB8SQG?=
 =?us-ascii?Q?kSOoFHMfrrCc0RLOq0U9S/MhkGPvU1cRQXeo3ihO4vZRf2TKD06XvL94Ims/?=
 =?us-ascii?Q?IHK4LK+L9e26XYtnhuI2GUFtJ++bd4BIb2bn2xdJ8Ry0iu9ep2MjAc0w19SK?=
 =?us-ascii?Q?x536/yv6/V8HBJy1bvur+d+Hl9tqEVVm63im7G0626tcTXROzRE0EqBiAHeP?=
 =?us-ascii?Q?DCER/tydqrDT29m+gMlohdamyXHIS/QD9odS9LcTmqhgeAB+/9b+TsVQuyVh?=
 =?us-ascii?Q?dzhRWXJwaES4FxeWbtNhSwhosiA9UHum34fIqQFkLVHhieo9fuEtGqYwVNav?=
 =?us-ascii?Q?RlzhAR0KZayq9FNeQgILnwSW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1227bf7-60b2-4b6c-d131-08d8e1712a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2021 13:59:02.4588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Y0aJA3UnrrBO1hdKlKHUD9qZJpqOYmxpx9A5fGRLu20ymRB0AQ4VvmLA2ei1e5Lhrmy52JF1qzSpEDbdj4JwHcMgJ/jkbF8JipFKh7zX7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3637
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

Hi Jakub/Dave,
Just wonder if you had a chance to take a look at our patch. With the close=
 of 5.12
merge window, we would like to get the process moving again.

> In the meantime, why don't you all help out and review submitted patches
> to the mailing lists for the subsystems you all are trying to get this
> patch into.  I know maintainers would appreciate the help, right?
>=20
> thanks,
>=20
> greg k-h

Did a few reviews last weekend, and will continue to help.

Thanks
Mike
