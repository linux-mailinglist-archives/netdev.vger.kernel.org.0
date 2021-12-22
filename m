Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E330C47CC0B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhLVEVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:21:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:50506 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238768AbhLVEVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640146870; x=1671682870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=39lhxRLm8Nl6jT84yB4QdHrnK6gEf8FSo+9OOojKUk4=;
  b=A05OHbJ3ZVvEl4ZDnkwcSH5ewo6dMCU9fGI8Rj+4JG4MuTomCOqaGV7c
   zSCj2K9z3/xZJ4W3qKq7iEADvuIPr1SPFoMVgtDXnZkmeFgw0y2LW7Vry
   0NExJgLaZrqfb1agJSaG2rWzYK9UpvFkIH+QUYopj1gLQ4YS3PKdUqDXi
   enH8iUR7UEhvFVHsxbaTP3R0RP2lewZTYRzyEu1ZFR7dRZW/O2DSUt6J9
   6EnjIsEKpk2C23seOZI/dYmGYLP6FEhH0nZ3wrh6f/8oDngmLFAOen+cg
   QzuKW2iCOhLy4VepgXGZso2g3I7WpRAKNBslFNAbrVT414QmzoWZeVxA6
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240495907"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="240495907"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:21:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="617002664"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 21 Dec 2021 20:21:10 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 20:21:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 20:21:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 20:21:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vd4mI74qCHUqCnaSvEEdWPB5ga1pzNnZrBRYf7zSoiMJNbRZYa66MQFwjppUK+SFkPzJoOlHCxqJjmCOFXp3xmC3Rqcka/Oxj6XknVoDsNKOA7FwBVrNLPAFYFftziIvtJiVBk2pebFGvUlq9aSOAbi328pje3xcB27YZ9g4AV29xemN6iTSDKt+ScYB4GL4370Wn/i59kI9tUGJQ8CbzTsD9NdmQnZGY6FrwIFfO/L/Ji/1AAJpK+hoPuQ2dZ22KoE4/8u/ZmtZnyTWUMqojTuX6q9WIrR8OTFLnnPWFtJUinuDIPItA8PsvfEZsLH5yBGGeTGwzaQXGIP2BKX3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peH1BJpW2vn4DiOBO1hFYY3wIM40LSa4FeQaHWuYn9k=;
 b=WG2zwCA481zhQxiV813gt38fXhmdN8TlvIKy87RF/8/nj4psLMC2/Wh9NPkyI63dxPUnRDeq0pxsL3m0Mt7P7gVCFpmpkwtyWCS2oMWME0EBHavwVUPsqYFUrhGAN18xVgSt9lalvj7KVfVE5kGN+X3Oodx8xr85VHlNFDMycns7uC5cf6OJ3sPCsQDUC8dZSScpJa3S6oNW4OPzsKGtYHQjHIwNITH9yC3O2A8OT/VN6g5Lj53ZuaG9u9Qz55Az5H7svBlUyPB6Dxtr7bZ0JN14Syf7DjNcJkzSXz33zMHpTXuAOgGuBNQYnEbeRmdr8iOxkAlSXLQ4DIalixZsCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1743.namprd11.prod.outlook.com (2603:10b6:300:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 22 Dec
 2021 04:21:06 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 04:21:06 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Topic: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Index: AQHX9jdp8zCLYq9nh0Woi5QXeJNDCaw9mkwAgABNtGA=
Date:   Wed, 22 Dec 2021 04:21:06 +0000
Message-ID: <CO1PR11MB5170DC5C16ADE17DA4C5AD0FD97D9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
        <20211221065047.290182-18-mike.ximing.chen@intel.com>
 <20211221153458.51710479@hermes.local>
In-Reply-To: <20211221153458.51710479@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 869a9a07-3c2f-4c2e-2b46-08d9c5027925
x-ms-traffictypediagnostic: MWHPR11MB1743:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB174393F1F28194C02807FDC3D97D9@MWHPR11MB1743.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a9VoJyoy3LC6kx/z38Cm83oNlRvyRZ8JIQqJWtTNw2qb0V5hu8g7naATnB6uY7Ao98qalZiqORdL2z3BU8eMdJGh0dNbyk9kLzjm3fkCdLiQTt0YeKHItFtrGuQ5dSI5V40jpo9kaESwO172NwOvc/ugZ/lN0qro01R0T265SUJCbGSjuc7uxsjK4qK9DdViPnwcXy82VV9mmVzGdfPFp5wHPyKmhvk1AXml4joqRMYD/Tj+IuajcvIjJUvducYsAiz0FbbGgFTj/9l9R71TVeYdVgbMC2Q82UBsUVSWSaYOq2bxb1uvCktOfeSA38pU8bxLOsZtcPjtX1C05ygQhjOOTTwow8d4XQ97vwGHkgz+eBaRL8Ys3L8alG6NcnfX4FTb4rbYsJpjUWWNda8gMd+ErnqH060xqJgcgCuneak5FrRHwLykLrkCjZgHEiC92xc/rLnzPw4Dt1+RsqFsqzrgVp+km83zbRQitKFsC+fnsGtfQ3QCmrp7KYbZxUNUn7UsasQk2uuiCvxLM0/DsQnZqgwL5J/yevpl4P6361J+CpCo2UyI5AF75UQciazaG50it/pUrp0q1JLcMX/Ysi/dg1rlLl4j719r3RO1x9MT8CJ8BofQJtSQuDathSs95vL41V/xfrjwuApS44GEw4kv3GPa0d9k+AsuTL9mLWB9+KIXrrLefpPKx8hZISDoL4ai73eE958RPU3bY6zc/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(33656002)(508600001)(7696005)(8676002)(38100700002)(4326008)(55016003)(2906002)(5660300002)(86362001)(26005)(9686003)(76116006)(66556008)(66476007)(66946007)(66446008)(316002)(64756008)(6506007)(38070700005)(53546011)(54906003)(8936002)(6916009)(83380400001)(71200400001)(52536014)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BX8qNY+VBOdRftM1JP1TpfG+ybUfWtgMqLD+Kq8rHg1aUUH91zWoDKneNWVI?=
 =?us-ascii?Q?hSqV9sQt6IiRYIJt7aPx0qbTr4DLCoi5mWxVzBijRXdOdpTcyze4irAo4bLl?=
 =?us-ascii?Q?xdcEpsgqCZgBAEHOTo/GCcDEi8RueD7LKl42HqNZqpG61lEBxq5ii4BB2Zzy?=
 =?us-ascii?Q?uHpLGgLPPemio+QJf9RbhBCFENemUhKfGy7iP/SWN7ok4hidbaRKOsnKO9t0?=
 =?us-ascii?Q?I6/jiXDsK2XVo0VrDImfzr4kn9D8dCLebG4V1f266IAbr6O35XFi/tEBusOF?=
 =?us-ascii?Q?RaLPjeGIF0O4ss4AH7ftJLR/GfPodkMW7DXpRXH9NOcYq6N+wDtLk8cSHUj8?=
 =?us-ascii?Q?u5dEPGLYFTyjIyDnn2FGJSAohiK0IxoO2Mp37wh6nRL0K/aUzLNftOepYuwv?=
 =?us-ascii?Q?9a6GC2XQlTs81YHQULcnBlFtSS9IgxW+C0E5lvjbgUqXJlwX42eU4VYUxTrZ?=
 =?us-ascii?Q?/HD9zWXql6UJbi4rsGPcAGkqJQucb1YOcVzHP4REPaIfG9yqdWLzo7iM/8j4?=
 =?us-ascii?Q?wcAt6mYrGdEMKGlvGaLM4/7lt2HIMnYyLXjerDNhAlbh81YzmpEx2dO9URdW?=
 =?us-ascii?Q?moHUgJV8Pu2mFfG7eSO+zYYx6++nQ2s4qAjcIDGlOnrq9A0RJW3daxefD7Mi?=
 =?us-ascii?Q?EHrgjUAGq2HceC5rluOSJ+3vjghMoukf/B2Hye4B8x/J83Be6be3GNo9OKsb?=
 =?us-ascii?Q?YWNmxRvY0yH3jJExJ7pt4l/2resGQ9YWaZ2avnw//UXnlBemJ7Oy/EN6oHfU?=
 =?us-ascii?Q?1XhRXeKS4qD11XtmCpSjNCH8PQ6WY5+xJLyjMt0+otnxZKlAD8O2+LQKWKBO?=
 =?us-ascii?Q?VNIVB0d+lXiiLzbbk12TJJ1E4kyQIoia5/BnG8bxUlSD2JN14NzJN8cVSJDd?=
 =?us-ascii?Q?I0jmLUgN+8VDhp8uFfw6nxJ3vxl/v86E+nu/tWkix2l2TO1WvMMEk7bCspcZ?=
 =?us-ascii?Q?GG1dx3l691hXN4aPDe7+uA7VpoG3clnbFzqKaNKXgEeAV2AtKV88LEoJyQiS?=
 =?us-ascii?Q?KgqKoaexZHu0ui/CYk5IksvL0f47CxK/E+e+i7AZqO+C85kw1wxhnEBjbD0L?=
 =?us-ascii?Q?b9ihigxP5gxziqJcCb79VBzZZxOUo5YwFB+oi/mzaDcvVQHGVJb9rf4qraAM?=
 =?us-ascii?Q?oI5raT8nzim47SwyPlwd7PPzHvpN1gPgfOrh/fQmye4WX+pgmYKRXcr+s3o1?=
 =?us-ascii?Q?nxtp+xLNYAPc6YcRNJhmzrW7MnqJ7xA4BR33gFweHxibpi2Kl7NAHfmKNvBA?=
 =?us-ascii?Q?LNMTzXKtf7wMhvznuTBJs+WvexjSXPHhI/2TrDnvMWAqr1NMczVnxrm/3QzW?=
 =?us-ascii?Q?33Ua3GR266C8pwfKX6KCdWqQlVRXrp/yujFWGMn/rLSxbhYeVjNUIO11wtsE?=
 =?us-ascii?Q?A3cUX5PF9TwgpG7VCZkiqSHJcvAN3LgQat4qRSyxrDLrgJEihUgQ3YEHtUVv?=
 =?us-ascii?Q?wbQs15k8OJh1uHP+/LrjpB4w+mNzWARpiGZXDF1NjJnur9EJCAXMbQJRkLFC?=
 =?us-ascii?Q?AaeS4PryMnITE7m1CP+lwc/WPAzm9EWP84cboxDRlyEoSdG5kUOy6NWgo/rC?=
 =?us-ascii?Q?Y8SieGVNr3tnCkJeD4zHTFFzcGMq82DUDPMBQDNyOS9eFHRum9Bwqz3Cf4zL?=
 =?us-ascii?Q?kIgXf9cy7qGnjSho/pnQH08rL8dBxiOVynp75sascFNjxcRBY6S7Iec8lrjd?=
 =?us-ascii?Q?XgIxtQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869a9a07-3c2f-4c2e-2b46-08d9c5027925
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 04:21:06.0988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlriGxS4IrLH0OtG3mYxIe5G54yiO3zg82ZGEE0GvQKV4Dpz8FurDKg1yYeOVFE+GIUMQBOZ4XUHzbDcUnsUzU40Upm3Ca1kk43Z1VWbwDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1743
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Tuesday, December 21, 2021 6:35 PM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
>=20
> On Tue, 21 Dec 2021 00:50:47 -0600
> Mike Ximing Chen <mike.ximing.chen@intel.com> wrote:
>=20
> > The dlb sysfs interfaces include files for reading the total and
> > available device resources, and reading the device ID and version. The
> > interfaces are used for device level configurations and resource
> > inquiries.
> >
> > Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-dlb | 116 ++++++++++++
> >  drivers/misc/dlb/dlb_args.h                |  34 ++++
> >  drivers/misc/dlb/dlb_main.c                |   5 +
> >  drivers/misc/dlb/dlb_main.h                |   3 +
> >  drivers/misc/dlb/dlb_pf_ops.c              | 195 +++++++++++++++++++++
> >  drivers/misc/dlb/dlb_resource.c            |  50 ++++++
> >  6 files changed, 403 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-driver-dlb
> >
> > diff --git a/Documentation/ABI/testing/sysfs-driver-dlb
> > b/Documentation/ABI/testing/sysfs-driver-dlb
> > new file mode 100644
> > index 000000000000..bf09ef6f8a3a
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-driver-dlb
> > @@ -0,0 +1,116 @@
> > +What:		/sys/bus/pci/devices/.../total_resources/num_atomic_inflights
> > +What:		/sys/bus/pci/devices/.../total_resources/num_dir_credits
> > +What:		/sys/bus/pci/devices/.../total_resources/num_dir_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_hist_list_entries
> > +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_credits
> > +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_cos0_ldb_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_cos1_ldb_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_cos2_ldb_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_cos3_ldb_ports
> > +What:		/sys/bus/pci/devices/.../total_resources/num_ldb_queues
> > +What:		/sys/bus/pci/devices/.../total_resources/num_sched_domains
> > +Date:		Oct 15, 2021
> > +KernelVersion:	5.15
> > +Contact:	mike.ximing.chen@intel.com
> > +Description:
> > +		The total_resources subdirectory contains read-only files that
> > +		indicate the total number of resources in the device.
> > +
> > +		num_atomic_inflights:  Total number of atomic inflights in the
> > +				       device. Atomic inflights refers to the
> > +				       on-device storage used by the atomic
> > +				       scheduler.
> > +
> > +		num_dir_credits:       Total number of directed credits in the
> > +				       device.
> > +
> > +		num_dir_ports:	       Total number of directed ports (and
> > +				       queues) in the device.
> > +
> > +		num_hist_list_entries: Total number of history list entries in
> > +				       the device.
> > +
> > +		num_ldb_credits:       Total number of load-balanced credits in
> > +				       the device.
> > +
> > +		num_ldb_ports:	       Total number of load-balanced ports in
> > +				       the device.
> > +
> > +		num_cos<M>_ldb_ports:  Total number of load-balanced ports
> > +				       belonging to class-of-service M in the
> > +				       device.
> > +
> > +		num_ldb_queues:	       Total number of load-balanced queues in
> > +				       the device.
> > +
> > +		num_sched_domains:     Total number of scheduling domains in the
> > +				       device.
> > +
>=20
> Sysfs is only slightly better than /proc as an API.
> If it is just for testing than debugfs might be better.
>=20
Sysfs in our driver is not only for testing. It is used for the system conf=
iguration
at run time.

> Could this be done with a real netlink interface?
> Maybe as part of devlink?
Thanks for the suggestion. I will look into some sample implementations of
devlink/netlink. Our current plan is to stay with the configfs interface, a=
nd
find ways to resolve issues related to atomic update and resource reset at
tear-down time.

Mike=20
