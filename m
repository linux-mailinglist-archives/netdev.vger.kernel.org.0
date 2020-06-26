Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158F820B725
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgFZRei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:34:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:60527 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgFZRec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:34:32 -0400
IronPort-SDR: /8DF+4UVrvYYO9E9QX6zWXoXO4gZcbrMmNqgdsk3byMdNCcUDzFilb/tL0S4jX98W3k/Z9ju2+
 aLnAgnZ+Ci3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="143636478"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="143636478"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:34:29 -0700
IronPort-SDR: E0iAKWLbesHEtJUmb/tdFVHxXPK8x3M/2yAhj1PO/Q0RaOGJ3w4xRLQqcgJir3esMiUO48QC4d
 IlNhEXulZ4uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="294262808"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 26 Jun 2020 10:34:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:34:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jun 2020 10:34:25 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jun 2020 10:34:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 26 Jun 2020 10:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJaMLhnoyR6LlEDdBY9fEpap6DjAhAroUJtg8h+wsZBQjB6RL8SiWaW84CrL+Cc4Ar462w41jjtftEPNr5D0uaIi6uT6vcjnhpLhsznd9ouER7/vjF4ohiGEwe7b1ZF0jPndLuNwdVbZAq7NjETeEB7jz3zFuZjYtYQF16Wtp9RisZ9RisayLNaDqPaWzKUS7IICSaRrvfwKMir4an/nGHDnC3YwyHa5f4xhEJcz2Izzuz4AQntx1gSJ4mZmQzYum8UlLTYs7HBSJaWIE9o/FZFV1FWujkDH103ODHLR9Z5CqWMt+205UHb2js6J/MFdFr8zyxrUXZu+iU83EcSlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=li/ry8f1+JU2SpkxtOa6HV9YsbI1SHM08D9d4aNduKE=;
 b=URmq0Y/YR2sAkWBcQPfK+8320zZtgWYFYe9Y2wKTAyO/361vh6tZLyhx7OAKdVABL88r/AS/i2I5qXeiAOtg2+aUzrHmgvBJTOjJnVpfxjzhe2cwmHqaGVRoixvwlOHqVRSs8oiYQmQTrFFAAkRp1/zLMPVtczIgGs6H2MLLItNEDV0KWaFwiNanIA46OiSn8mBwO3pqONv6Z8e03aRI9+iFbI5Z+vH/BQMo6DorXztIJfYP7CYa8iKu9m1wUz2yGT96ZJoKRvDBqbILzxEXdmwJ9IJAQhi526BGjcQR6nFQWbdtMYXMlJsPyJVcuCxb1ZFTHLDiO92IJgJqFu8gvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=li/ry8f1+JU2SpkxtOa6HV9YsbI1SHM08D9d4aNduKE=;
 b=DlGORhCnOph2WJsboWqMgZVPXgfnIXy7HBy7ss99CVVNo8zIe0Kd/voFco2Xu5ObfntnWPnkmWzg70vBuABQIpETcXcxyz8DhI1WGKZqF7gZ5tx7gjwsktgESNHNuQKjcXmiXbDRv7R6AUAPSFGjSy+h9aCVnH+wcWd+KdbMQL8=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1648.namprd11.prod.outlook.com (2603:10b6:301:e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 17:34:16 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.023; Fri, 26 Jun 2020
 17:34:16 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 04/15] iecm: Common module introduction and function
 stubs
Thread-Topic: [net-next v3 04/15] iecm: Common module introduction and
 function stubs
Thread-Index: AQHWS16Xx8ZJXBmDDESyE7IjsP7/H6jqKtwAgAD6ZMA=
Date:   Fri, 26 Jun 2020 17:34:15 +0000
Message-ID: <MW3PR11MB45220E5C74C2DC14094EF3788F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-5-jeffrey.t.kirsher@intel.com>
 <a6eafe2f110b468a8908e1562bfc707360c27b75.camel@perches.com>
In-Reply-To: <a6eafe2f110b468a8908e1562bfc707360c27b75.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68c98150-f5fc-4bd2-3d09-08d819f72629
x-ms-traffictypediagnostic: MWHPR11MB1648:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1648E0D3EC18C3BB28002D498F930@MWHPR11MB1648.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: avUQdGvgl9/phtg1leOtN4mOvZWYaL6SK197VixwtZfkw/y7gD0HN10d6uA0jkQXApYrsJnf85dRQJugS6/7uqBsMnhKSj51t9phkTvd1aUrFJE92yU3SlCEmtvnR03j1WdODDstZFFV90wN9smKnKpu9CdsaUSo8J76t0H3+NV+PmUsML7BvF8sMCEUz4Ek+w4Ff8rdZUWOZYpOofT8DPEvMW7U7+KUougCkzNLbmwDPK4tW3Pnza5Hg1i3kBnyjqSNOZCcvEfVwCb9W2aGfD/MiWhuJqt0myIFqQz8QbU5x+LF5zFePddtRfff7wK86G3Q6JIpGFgydkUIMhVWcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(107886003)(71200400001)(64756008)(26005)(186003)(76116006)(66476007)(86362001)(5660300002)(66556008)(9686003)(66446008)(52536014)(55016002)(66946007)(6506007)(478600001)(8936002)(33656002)(2906002)(7696005)(53546011)(4326008)(83380400001)(316002)(8676002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iqk6Qz8F2YSk1VwSKI+JZZe02ywnIECDf0omQEOfsv2zTvBEDkr6guHmC0rGQP4deJQxN+sXOGMAyWMwLuOprAPreBJdGUhcjCFt+VUDhXGQBXImEBnooFDqbKeCTFt2ka1XfPb1ySyc7uSGkdvHf/HB/5/8usaGdm84Z84th+L3pCi1hV3qWE3SZLk2le7aOXYrzB76fGvezT84TN7iKeMpxH8S+8KWIsWVaZOd83kVQQNu99cnXM+aGl6kxvrmN87yFKK5RDWLCjHU1rQEoAAVZdRMwejvtI7wGFdeUq7WJrTwXhMeAZ2BUa8lOJ4i3LtGUBM2YwaHc2znKXjcttrK6LNkyYhDdoeWnC/Ttvd21h7NYtrOxSRXwHBhRjoMLgBx2DA++K90bGKv/r/91MKnWUgyeXxtqDTVnvf2hAFk2ja5x0+SihyQqG4fqcw0LtKSYLyV0zBDleETVzbDH22y1/AFoycGMuYmLGh0SI/aVPqCQcTiCMETIU7Qf4Sj
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c98150-f5fc-4bd2-3d09-08d819f72629
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 17:34:15.8359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: se2c8CHPixSU+nZDXplWfHRO2iqIRlKe4Ah8kQBztw+T+h9pv52vprARo0zWv2nNunIMMELndEH9V0r53pKUxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1648
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 7:24 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 04/15] iecm: Common module introduction and
> function stubs
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > This introduces function stubs for the framework of the common module.
>=20
> trivia:
>=20
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> []
> > @@ -0,0 +1,407 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2020 Intel Corporation */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/net/intel/iecm.h>
> > +
> > +static const struct net_device_ops iecm_netdev_ops_splitq; static
> > +const struct net_device_ops iecm_netdev_ops_singleq; extern int
> > +debug;
>=20
> extern int debug doesn't seem like a good global name.
>=20
> extern int iecm_debug?
>=20

Agreed, will fix.

> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_main.c
> > b/drivers/net/ethernet/intel/iecm/iecm_main.c
> []
> > @@ -0,0 +1,47 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2020 Intel Corporation */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/net/intel/iecm.h>
> > +
> > +char iecm_drv_name[] =3D "iecm";
> > +#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
> > +static const char iecm_driver_string[] =3D DRV_SUMMARY; static const
> > +char iecm_copyright[] =3D "Copyright (c) 2020, Intel Corporation.";
> > +
> > +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> > +MODULE_DESCRIPTION(DRV_SUMMARY); MODULE_LICENSE("GPL v2");
> > +
> > +int debug =3D -1;
>=20
> iecm_debug?
>=20

Yes will fix.

> > +module_param(debug, int, 0644);
> > +#ifndef CONFIG_DYNAMIC_DEBUG
> > +MODULE_PARM_DESC(debug, "netif level (0=3Dnone,...,16=3Dall), hw
> > +debug_mask (0x8XXXXXXX)"); #else MODULE_PARM_DESC(debug, "netif level
> > +(0=3Dnone,...,16=3Dall)"); #endif /* !CONFIG_DYNAMIC_DEBUG */
>=20
> Are debugging levels described?
>=20
>

I'm not confident I know what's being asked here.  We use this module param=
eter to pass into netif_msg_init for adapter->msg_enable similar to how oth=
er Intel NIC drivers do.
=20
Alan

