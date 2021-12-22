Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B084B47CC3E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhLVEhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:37:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:9158 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235801AbhLVEhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640147852; x=1671683852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fBwtYcv5ZW+2CADmO6Jz5DJ5Y3b9RYieZflGuxy+lG4=;
  b=B/14v1CB4nwvIWA9djKYiiYFbp55Uwejrry0FE8zt68Jp8FUXBYo0w8v
   v7MzZqzb1uqYiRj3iVzBngjRGx4wlWqtNC9eBviz+ogiZv0Dp8cSnMscg
   JVzxs7Iym5VhvZRrqN7YBemUYbT4UkEnrIzjM0raJ6tJQMy6E1nKYvQXF
   FTNtos79/DjKFSqdEiA60A7+EAlMuxVeT03erIHTApon/il/nF6eJe2lb
   pTRvLY9abSLFrA+1ZC9wtZSDqyDE6cPymHx9JxwFoGU+hXwTwuDlH5K+m
   HKZLKAVNPia8ZddqUCOo06maiVJMM7sy10/DaG76barve4+602abuqs7b
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="239295806"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="239295806"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:37:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="548734318"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 21 Dec 2021 20:37:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 20:37:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 20:37:31 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 20:37:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAh2ot4IoT5VXCc3FGlmMr3qnm6XID7z0xUuN1ir7qGflND4L7GtncQK93bsTsPNZbeA63Ozb+5dInrw3uudeD6HsxHdcafhYALbilznw8lXVtkZ9vNzmlpnEdZCTuMxSHeA9C5cj83fby6G7bGQCRTcyHi7gNIb5myrW2SAAx2NB9ThSvjTX7PbWX1SJUD0lDYAqN7DYo2X3rVM6TCJMpVS+7iH+UdX05zNRQm23fC2EexFCsAU4MSPW6bLIn6ZQevdz7eUFgLHJ0nE7BUDNiC5FSN27EtXnWY7jElB9mDJlnT+M9wgcXq+Yr/VAug270HrEXOkkTjghI0y/phUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0bq7HV+Za9FZ+Vnfge+anhekuS9Sfoe9lFQd6WGiyw=;
 b=WYKN2yRLrpfap//83BUEwYQFzNRbxxayC2Tvp4Vaf5iT4jPEfM0V72HUVhlrF7a1dbIRFRmQEvD4gayDzu0F1w23TOQAszKt9DbGbblxh9/9HmvJFpeAEjui4KoiTr0sH6jQSUt4CCqBpqqMa6Ummdry16pzkTrJZUW4FRcWbfGnQtUd8Cjt45Dr15UFk6Ive66afxTeeu7CeHfvvZQPeeE8D1rZ+rdU0rkQZeGhtQLOgIDUtDfPdHyKa3qEaNjVCgQ6YVzF1EekKLnDIrq7IEXoHusCrN1J5JEFeLSQYLeYJ9WOOAU7pQDSJZILkPVpGqjT6D9Ylpju9T8si+ODPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1440.namprd11.prod.outlook.com (2603:10b6:301:7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 22 Dec
 2021 04:37:29 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 04:37:29 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Thread-Topic: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Thread-Index: AQHX9jcJdm85rPhvxUq3c7I9WRTitKw8sTaAgAE5rGA=
Date:   Wed, 22 Dec 2021 04:37:29 +0000
Message-ID: <CO1PR11MB51708FDE2087EE1F382AD14CD97D9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <YcGhG8bdUi4WyXAf@lunn.ch>
In-Reply-To: <YcGhG8bdUi4WyXAf@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 5b3096b4-7828-490f-dc2f-08d9c504c33c
x-ms-traffictypediagnostic: MWHPR11MB1440:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB1440D1ED880FFC838E9DD6FFD97D9@MWHPR11MB1440.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MqEVEVL2BxOy9dCPfiFgWQkgOC7C7n3f748W7lulUKmYUH4Ss55ehgbK0oEQ/fp/09ca8FzPgSeQx3VE4bhKIPbQhavvarT3C4CR3faNfEgbJ4VkFMQzjawc85Kl1X0XmAzOajt93tJdthfBkcHPYm3UYB8rzLQpkOBbvP+jZdjPH2aSjfEoGIYNnHTpAWL9TdOzvs34R83X3vMCAoFDlwtzXeE+sia3SMouYNInnwMbQk+TNd8fAE6Utp9m6u6ygUx44dtagtecDHO5mng/MO6Hd5UdalOWJ0u7hoJ5BmT07ZD1PIXWJG2Wv3x+nLMU+6N3e/yozfGV8l2f791yd+s470EjaBx5HTzPyUiI+E/ibmwCB4WkPy7GiWFn+UlK4pc4z6oq14f4GQhDxmiD2cBiST56Jca5XssOHUUyfvUTPfX53th9a+Hx0SrzoEimrTw553ArIPqJcX4G9Txir6gxTRJgreplJA2GXQ1h349proSq5E5fC6Fmf5Njhx3IQdYpDZ9R/C2nWn6rsWB9xP9LYc42C6GOISZmERMCw16cQGYM/K1WFe9DQChRJKxKn5aVlkfy8mwqifE+XptpkLwX2oxeTBYTqNEI6KhDRhBg5pPWauEvx8O74WWepykcYhob8WsXrL6zZ7njI8VENcrMZ4PksZbXeCIw8u/gt995TijAZ2k5hMKpvd9XrWusJaAw6g7/08v2+PW5KdNYPJef7WE9SirvfLnE4tvdXHI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(66476007)(66946007)(26005)(66556008)(64756008)(8676002)(8936002)(66446008)(33656002)(2906002)(71200400001)(186003)(52536014)(83380400001)(55016003)(9686003)(6506007)(54906003)(5660300002)(6916009)(53546011)(38070700005)(86362001)(316002)(122000001)(82960400001)(7696005)(4326008)(508600001)(38100700002)(60764002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XObPFMBCypTC7G/A2i4Be5Nzv1jl5hEUTohO2zFk6EiV5fobcO3xwLh+hpg9?=
 =?us-ascii?Q?QcNEp/JxejSYcNbbBEgwuUueoMz5s+Mai+Q//EL3rWkT/wirVW363hG35bHZ?=
 =?us-ascii?Q?qXtCZfghx+JOO4cBfewjNytsJE3OCSA1eIpe4jmNeAQPnhi4Nn3titslT6cR?=
 =?us-ascii?Q?+q2zTgHA7/0yN826U2sbphqq3KumVVq0QdS5yX6QI+Cw/ki7KHlZiA0bv64c?=
 =?us-ascii?Q?uVWJbzBpPsS0q6CAXfuFRFTmUiGz/HTrhXHshtFDjf3TGrIKaNr5WAWnw99R?=
 =?us-ascii?Q?Jz/QcxiUCzQYKKgcwfEp9h1/P01ogC+Ux0jacpUyi/abjKdsdhIf3umf+RGV?=
 =?us-ascii?Q?fqI1dCVVxYKrlTbKiKScDsxMqjgW9Zr0xLqUdFfTtA7VrgGYAlkAW3b+Pf1A?=
 =?us-ascii?Q?DN7yLFhQHQFdoJR+TnrYR0kucnLrY17vjlar7qT3MixNMKy+uFLn4uksd6l5?=
 =?us-ascii?Q?fJSfJr1GjEsTLPDwYY0QIY/ljn3FLzUDKY4BNPDGF94w32y4/rKzEJdVjMVL?=
 =?us-ascii?Q?gXAafG2F7hq+7x7tJdoeNRmZQ1RomsTdBPsHseLhaLxqPBaYLzZPCHzG4I0X?=
 =?us-ascii?Q?oNGfHzscQ8Uu1lH2DqeenTZB0asPjVuKk0JVXbwHfnZ2e3Ez0rYT9w+a54a2?=
 =?us-ascii?Q?e2B2+P29xHeAWGkfiJQQAzQntpQD4mMoZiIhOVeIMLRbTL3pML+XA/uyRviY?=
 =?us-ascii?Q?2hjWvZb3j7hNTW394dywPddwn4EnXnXOqfpFyR3CGYcDtOMO81WU7poK0o4w?=
 =?us-ascii?Q?T6QXGJ024yPKLzGkrEsyIzXRfRVnPJ9EbEPSf/CnYmXjyirGlfSu1J7aLSMC?=
 =?us-ascii?Q?5Op8LRwrgx2CvoSrGF4fiMy4ZGLElJYL+ryP61PRicAcVBjqKZb+C8tdJ+1v?=
 =?us-ascii?Q?1IXUTJIBZiYAjqNSWSp0lD9UF9df7Zhi9vjAKmzylUN9wwxKAHfwkFXyilmq?=
 =?us-ascii?Q?MHCWj1EY/C40Nzm/YfFF98YyrSg2cUPAmrs9NqSbKFd6MlWN5Zab5L1u20RM?=
 =?us-ascii?Q?84JKYwDx/I1h7asneFYiYWlJlazsbSe6d7stULmHK0qaRq0RtpJK/Maido9K?=
 =?us-ascii?Q?7X2JpjZCLt0XvQ4Kp3IFb7ECVXukyUxiZAoQCoQWp7JJlHAXlS5DZlHHGDJQ?=
 =?us-ascii?Q?0nMyTWIRWw1h2jpqSCP7hOprqglszx6XCZpDVHd0ueE7LByFZ/mIUpVtm6+E?=
 =?us-ascii?Q?mesc3e0cBi8i7WsoRpfqP/pwjUy978ph0LYyL/Zxjn2ohyqdW92iFP4APgW6?=
 =?us-ascii?Q?quWXf6O754YjRJyDJRc0Rc8qrBrWfezs3CKiDlyB8pNNBeI0b2Db3GB7P4ff?=
 =?us-ascii?Q?jDUwcI3QjHHOS6SXgCHw1myA6PJbjd+msYwI2zQgUbNLO49ditUVjUZsAk7x?=
 =?us-ascii?Q?eNu8Zgy6XaNzIuA4JAx9gMQzw+EznrgP1Sc1gws9MEjHGs7k85DFi671eCRd?=
 =?us-ascii?Q?FjmgW7al/B+BhxhGA0Q2mLw8NWDhsGS+vzUJVbM5xWGkOzsI8PCp2Tw3PO0J?=
 =?us-ascii?Q?H5pWPHAj8H86MYC5IZ+NVegQ9KhZuayKblyqGkMIV/PTfH7rYEVQJFLKdkCW?=
 =?us-ascii?Q?8X+jFj1PKEWeAWkIymJ3i33ofkQDIS5VQqzgbwmUldN+deqaD11dLuY4KVr+?=
 =?us-ascii?Q?Gv9r4xjudxPSAJzR/+qRO7PXl1FdkorUJQulFy1wTqAhljPj9DzqZmB1L6j8?=
 =?us-ascii?Q?Pu+mSA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3096b4-7828-490f-dc2f-08d9c504c33c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 04:37:29.4776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63DmYwf7HdRhDnhyL0egs4B+vZ/xnsr78F0HBMsRz9rBir7php1hiDm/TXhZG9Sg1P4SGw+JrbRfLtiWVvep3cyCYcOkFRwV/Uuxe2FoUv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1440
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 21, 2021 4:41 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
>=20
> > 1. Before a scheduling domain is created/enabled, a set of parameters
> > are passed to the kernel driver via configfs attribute files in an
> > configfs domain directory (say $domain) created by user. Each
> > attribute file corresponds to a configuration parameter of the domain.
> > After writing to all the attribute files, user writes 1 to "create"
> > attribute, which triggers an action (i.e., domain creation) in the
> > kernel driver. Since multiple processes/users can access the $domain
> > directory, multiple users can write to the attribute files at the same
> > time.  How do we guarantee an atomic update/configuration of a domain?
> > In other words, if user A wants to set attributes 1 and 2, how can we
> > prevent user B from changing attribute 1 and 2 before user A writes 1
> > to "create"? A configfs directory with individual attribute files
> > seems to not be able to provide atomic configuration in this case. One
> > option to solve this issue could be write a structured data (with a
> > set of parameters) to a single attribute file. This would guarantee the=
 atomic configuration, but may not
> be a conventional configfs operation.
>=20
> How about throw away configfs and use netlink? Messages are atomic, and y=
ou can add an arbitrary
> number of attributes to a single netlink message. It will also make your =
code more network like, since
> nothing else in the network stack uses configfs, as far as i know.
>=20
Hi Andrew,
As I explained in my other response, DLB is not a network accelerator and D=
LB
driver is not a part of network stack. We would obviously prefer to resolve=
 the
atomic update and resource reset at tear-down Issues within the configfs
framework if possible. But I will take a look at the netlink implementation=
s.

Thanks for the suggestion
Mike
