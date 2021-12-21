Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8D47C123
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbhLUODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:03:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:45112 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237643AbhLUODy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640095434; x=1671631434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uh70ksbEU7pnFgq98eswdjP5WmynGQUVmaFlmlZHi9c=;
  b=AByXzgUmPzygdZ/pDWiPRTNECkWCCP+AuyE2hITDebyw6QT+odVP14Nn
   zIHtjEA3W+1ZoR5HIYkrmvKj6wm47Gu1qwXsn+oKo8PVZPjFSSrXstThC
   +EZGYY5idWYtLlshNWWyUnaHedd72Nxnn+rUjjdu/xlKO3YtaNtpgBqfq
   bsQoaNIaRLJaMEQnQkXjFn6+tBe3+XIu2wz3jnGFgL60OvjO/bwAaJPN7
   zyazdrTMgy4n4V5XmILcj9nV+5ASkuYuMkCK2o/6S468j5t+odCswSf2s
   i0Ilc3avaJ71+SUgS+A0xVBZWv4UW3+YzkHFmDOgME1v74DaI96gNpZTR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="264589083"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="264589083"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:03:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="663953078"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2021 06:03:42 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:03:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 06:03:40 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 06:03:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcQccyMikg7aIssAYwZD/lDqOwjjvaAbTVq/jH1NgeYS7M50j9X+yqwfXkYe3Pqv4h5FuTaQKs9s+Q53Q6a1o18T9sbZ87jL0EFEBNvwXSZArUORNY9pxrq4cei9bPUYz9/kvsvpcMMwTRKIb7fSwOF7L35RUo9hDwE/x0erGXD96USf7s39Mfzip6raGzKPIgQYk9TgfDSSMG0TPsi/GZqiAy/+VnnyIRzwxXMiHTr78mp496y42D4y1gTGC+ag4r9Ks/9LoUqsk4p2flLsXZ4MxRQ02P4vGs2y37K0egQejrsJ+WrUxfCXcRI5iHrKqXjFjbICL9BNkQVfYau80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fYCMVnvX7SgnPjPAspFwL9cnRHiUsqjqc3tBHIevTk=;
 b=UAGCuU6XpT44+fZ1oNMMxGaOp841Jb4fqvucGt6vAnuinU3JA7X5r2xlQpoRnIL76YSnjyvaGZ4U9hBmruYlEum/Oqbt9cN6gh4T7P04tsrDON1Qb1KdPEk7myynx0dBS4id3HqalVoOsIO2sGZSpbICcXWGdVHFlIGmN1WiA/yeEwumShjClXr0C6j2rBdix5TiQ1QSSMwf3f2ED39hvWUSnmAJOLH63LJDEHrxoy3XLU/mqhbF5dD5NuRXwiGFQvg1Dlc58EaoCiqSha6yWAF0sFpBxeb2I/iK7JZEVqert6nKsRgoH/BpCv54f1aZkLiffn36Yl29duuvD+QCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MW4PR11MB5890.namprd11.prod.outlook.com (2603:10b6:303:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:03:38 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 14:03:38 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Thread-Topic: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Thread-Index: AQHX9jcJdm85rPhvxUq3c7I9WRTitKw8hvqAgABjytA=
Date:   Tue, 21 Dec 2021 14:03:38 +0000
Message-ID: <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <YcF9rRTVzrbCyOtq@kroah.com>
In-Reply-To: <YcF9rRTVzrbCyOtq@kroah.com>
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
x-ms-office365-filtering-correlation-id: e8e331fe-b4f3-4dc7-01f2-08d9c48aafe8
x-ms-traffictypediagnostic: MW4PR11MB5890:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MW4PR11MB5890372A07FCF8211FE0792ED97C9@MW4PR11MB5890.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rgj9dJyD+EfCifdZL+AbjcozgQwUr9JlygIAeYlkzfdoYbk9ZdJRsjdfjo2LIItcReaqVI8AcmWofXxSyjcc82H9+IYb875oSxJUrK6dkE8jw7wevMZfmVJ3B42cTVMEGaDcPMVq4/0IbeM7ArtYAr6blqC1ifzx0LhnjkZ3h3jYDCXwNZXA6rGRehPaqCKB2PjKDFMK3RDB7/H4cZRw2Vajtp8m4mqwXoiE79GM262z3AH8iHVmveYSf/pVnk5Qar0S8OvdCi7mLKy7KtKJf7Uyat8gUQBh0qKyZousEN23/0TchfF4x/jh5jPjrW73OrDxZUhHwDOLrXY91ZNT3Eb9BS8uGMBelyu6oelOcvsSkIVj6nDJawifwFt54Ws80ENVo69pWAs3/GQ/Z9KfVpiRZbh6oKXf137RRP2TTZsjEUQOkd+C8cbQrXYj3GCVxL3DYETTaaFLJUjNyDlJ1xXSFPHUnkl8GjoREN7Cn486Fz2nSsYk+efgIuSh6CYybIoECf3Oawtc6sPcg7nfSbBIAAGYKJdRigIdi34JVLuzVK4hBf3llNsfd9+EM7KmgmbLnpjkaXltAU+TuFJY4w/jUeRBK5bKuUQ0eOEAWEwwhERutqQYPl/P++YgZQXkLzekb07Y5p+ysz2BNcHMhqL5FcyMxfGv9vD77CqbTs/s15eQOlJyCtCeFhfDOZJZ0f488PmEXQjoz4poiNjIow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(38070700005)(7696005)(55016003)(186003)(66476007)(122000001)(26005)(64756008)(83380400001)(86362001)(2906002)(5660300002)(6916009)(54906003)(66556008)(52536014)(82960400001)(9686003)(66946007)(53546011)(6506007)(33656002)(71200400001)(8676002)(508600001)(66446008)(8936002)(38100700002)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s5WRZCgeYRSyYd1tdsuk3Q6FZx5iu06KJiefgbREmMJtOS2/kCYAz8oeqwZ9?=
 =?us-ascii?Q?J+dA2bQurl25arNQcOK7issF5jTD+Zwi3/DKNzMh8M5zRY2qqE2tE6BM4+VT?=
 =?us-ascii?Q?s2lYF6DWoc33EUCqVjxYX/5eynyQ+vPLYYGMT1FhPIbkbmINLNmY6yOLou9i?=
 =?us-ascii?Q?o1GfhkAUx68OLjmvpNMflJ9P8pXrowmO6czajyQA4shLsTZaK5hcpFoT2MNf?=
 =?us-ascii?Q?FQpvSyMlSGyqKYRZWmDOSUFGHUJKVTi5ci+jBya1xiy4PTEncMzk9ZAdOEM9?=
 =?us-ascii?Q?UAKQrMjXtM4XtveuktDeKGmdOwLAIrwNgHSrIR6ZvtWSTIcsmm6c+JVrUmDV?=
 =?us-ascii?Q?9DHOSOhtsjNoEZenouq6sRwUv5aEx5l5tPaJXPqiCSqqTpu7KmhdID3eTXFg?=
 =?us-ascii?Q?cg8LGUN2SzaDubXBo81X85FvajV6E99a83W1Y7dE5Uclu1gaRXZulpVlscff?=
 =?us-ascii?Q?ZFPH7ETuQssu8jqokmlYUJq1qIxjsC45r/R00MXQ5hXvFWxEr4gydZklta6E?=
 =?us-ascii?Q?URe111R5RTn+du3Kdje02qg6ZNtyKiRfG/554juPcvPasl5pk7zFttW2cJUf?=
 =?us-ascii?Q?wUEGhk/k+bKThsY7+tbaPOuYF+fmWAHzCEfzojVjbzirOIqL0wzPvbhQAVQT?=
 =?us-ascii?Q?xRnFU1HQy8oRtySXNpXkUhjhpFLfQeVva7kw2wjX2+8YIXJJ90rx6JGy5ee3?=
 =?us-ascii?Q?rAi4bzuVz2CYftD+bsHZ8xzySMrZord0IykMUPtWi0d3DN+mxPjCT6z2URUD?=
 =?us-ascii?Q?IUeHwpx1e2Ga8rwSWmmw2Glx+RtKIu5O0scGTJZVfJZ6B8SwplbPg0VwX3Zj?=
 =?us-ascii?Q?QEbKkqN6IigDXcND6WZCSwNUCmXyMiGD5YEeVSnI+pYmFGoh4l3SCFuq2i4i?=
 =?us-ascii?Q?zixQtIY0Ew0vbly1sQvIywXedohRFVa4GW3yg83lCJkQn2hFCxAIQhNLqkAw?=
 =?us-ascii?Q?P0L+tbxPFQMNvRns8HAr+0aJXP5t7GuYC+oe5ei3LPatcqNLWzzcmCAF7Jk8?=
 =?us-ascii?Q?WL7m7+el31dSS0PLY8FD0vkA77cZxmjCqw5TiC+vwfO+0mZnKSSraGdXKbyw?=
 =?us-ascii?Q?lw2Di04SV1RmxbZ7Eu37/cqMjfR6gHn0OFvFzqu/fFOSX0THy8Zw/z/jF3oq?=
 =?us-ascii?Q?MMlphqpFQvpoSOFkXlYy5vxNef4wKu3V3VZpgioo2dq96XXLrp0L8hRf1OP8?=
 =?us-ascii?Q?1dcW0x40p+0OsBNG5xcEnGeNCBtT3a8f4BhrEtONzuh7aeirYPtEJEyuY0yA?=
 =?us-ascii?Q?BGvIgLiUfCmzjDyKlGMrQ7s4rnK4aFHj6M+TQzHxFyvp6ApUVFWzOS+xYbhC?=
 =?us-ascii?Q?iQVQXLCZFjlNCoku7dudy1iFqwDrEOSpCjJ3jU6Z8Wc+jOeVL2ae2tbjICu1?=
 =?us-ascii?Q?TjH2jj+fT7PrXqyaBkwslpHsTCwepQMEZLpTJCReE+L2crFod8lAIYx/LGoy?=
 =?us-ascii?Q?Xy2CGRkRZPLDnv/NBftvO8QRi3fNG45G0YoOYTEgY7oIYWeYdupn/MMEq9vs?=
 =?us-ascii?Q?R9+BLVPUT6T3gfTYSmFE45kbOPMSeZyfRhubSrSd/aUp0mONIAunP0TwDPLc?=
 =?us-ascii?Q?Qt0w1OysqLkCra595XeSGLJdE08kjqP0zhJk7T+0bJ2V3cI984oYKbxlBzhI?=
 =?us-ascii?Q?qDFlHgP9OqZIcTUPnBppE1DT8y2lfwcHoeqEUmwxXi3fcRI4XB4Je+Tt72Ld?=
 =?us-ascii?Q?75tgvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e331fe-b4f3-4dc7-01f2-08d9c48aafe8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 14:03:38.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZtkM9DaAzptvLhnTp6yq/gh9qB13oOwxYn7sG/6WkgDVP7RGsX7CX9k6+lbvaslw4qASqhBsThn0bKRlycA33h/aPH0pbHl2kfE6pMmJLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5890
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, December 21, 2021 2:10 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.w=
illiams@intel.com>; pierre-
> louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.ne=
t; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
>=20
> On Tue, Dec 21, 2021 at 12:50:30AM -0600, Mike Ximing Chen wrote:
> > v12:
>=20
> <snip>
>=20
> How is a "RFC" series on version 12?  "RFC" means "I do not think this sh=
ould be merged, please give me
> some comments on how this is all structured" which I think is not the cas=
e here.

Hi Greg,

"RFC" here means exactly what you referred to. As you know we have made man=
y changes since your
last review of the patch set (which was v10).  At this point we are not sur=
e if we are on the right track in
terms of some configfs implementation, and would like some comments from th=
e community. I stated
this in the cover letter before the change log: " This submission is still =
a work in progress.... , a couple of
issues that we would like to get help and suggestions from reviewers and co=
mmunity". I presented two
issues/questions we are facing, and would like to get comments.=20

The code on the other hand are tested and validated on our hardware platfor=
ms. I kept the version number
in series (using v12, instead v1) so that reviewers can track the old submi=
ssions and have a better
understanding of the patch set's history.

>=20
> > - The following coding style changes suggested by Dan will be implement=
ed
> >   in the next revision
> > -- Replace DLB_CSR_RD() and DLB_CSR_WR() with direct ioread32() and
> >    iowrite32() call.
> > -- Remove bitmap wrappers and use linux bitmap functions directly.
> > -- Use trace_event in configfs attribute file update.
>=20
> Why submit a patch series that you know will be changed?  Just do the wor=
k, don't ask anyone to review
> stuff you know is incorrect, that just wastes our time and ensures that w=
e never want to review it again.
>
Since this is a RFC, and is not for merging or a full review, we though it =
was OK to log the pending coding
style changes. The patch set was submitted and reviewed by the community be=
fore, and there was no
complains on using macros like DLB_CSR_RD(), etc, but we think we can repla=
ce them for better
readability of the code.

Thanks
Mike=20
=20
