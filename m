Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C35286916
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgJGUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:30:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:31206 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgJGUaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:30:23 -0400
IronPort-SDR: XKXKECC4ISWJS9bRVvqEpXQqJqD2FRXeQwCiRDqmq4ukWTOzgq6AxqAbKIeNdlNjPLRO2HutvP
 hmJWmv7n4A3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="152922415"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="152922415"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:30:21 -0700
IronPort-SDR: LKoVg6oLOLTnIXlF6noBjhEmjzoecyFwFjahuWSfKokdP9Uusgk8RyNBPmEtF6NrfvqrwmGOwM
 69mD3xSk9K+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="344449839"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 07 Oct 2020 13:30:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:30:21 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:30:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 13:30:19 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.52) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 13:30:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZuikl+LFOq4zRmBhvkKnMvTr+CuUru3jHjcmBcQW8hNVLpmg3Y1TaSomSK4KPtffnGLbntUen8VdheKWD+FqpOtmSqsN47RJCXzxVltIZdhO1TaBk1x2+u6ahAYqC36+8rXmVq/tk/7LL6lHP0ovoUS3cHJyk2lmc/z+sQ11VWDnsCxreoMlkw/2/PjMXJ48eCx7vDd5MjhlNs5nH87mN007l0umBzKQOYfeXv95YxcJJpSmvulRwrHX0ipxp+klzoh1AjCcsv89TJeyAgyIUSc82WXwKmnch/e9hJ1BvIyOduOfFdvLkV45D/W7/8WOTqtp0wsL8XJQpK3gUKGvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KNGaWoBUiY1CJzRM6H73eBn11l5+XAFgHswwpk2GxI=;
 b=BUNg9zgyQbwxUvg+geMxKjPFvhM62wQUxUFybfgj1K/RE5pLvjECNUurMvMAfVkBsrJ/iuhPsU94zVyld/qfcdjsAkeZPQgWAXw2pri2yf4w2qGdJjrMGdEnSbQwiegxfLoGwT/4PPGEsA2vVu00nzlEQj/nho1uDFpcxjphYDZKbFW18/hmHWp8mQ0uBAnY8CcWT2CMtlogEdIMKA9PI7SZb+W/OGF8iMBDzfju08ilbeqBuLS3rT6QMoMRSjeuJOr5r+akBVzpsgLO8gxZT6Wwtn7HRRrwP2k6fb9OH9DKc3UDED6KnuRMVlsaJh6IV5jUjLHU6bNmw2cETZsL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KNGaWoBUiY1CJzRM6H73eBn11l5+XAFgHswwpk2GxI=;
 b=SX1KuWFp5fSpLzu52Uj2IU0KWjaHFoUF+OkfOW20O4Xmjg8JQAKun5oNWH81G0gXgkNRzbM4xAFApOFAOsmcQjBGYQy2UA/aCtprAs4QBu+rVxX/c26Q8V3hYQ9gQRLYy4kXr+TLp2wXm3B6AJAnA92Ncw7oA/W4MN/0O3O7058=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3978.namprd11.prod.outlook.com (2603:10b6:5:19a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Wed, 7 Oct 2020 20:30:09 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 20:30:09 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABy3BQ
Date:   Wed, 7 Oct 2020 20:30:09 +0000
Message-ID: <DM6PR11MB284100953A60E523A45770FBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
In-Reply-To: <20201006170241.GM1874917@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7934de14-a0ca-4006-f8c7-08d86affc91d
x-ms-traffictypediagnostic: DM6PR11MB3978:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3978C158CBEC4615E665C309DD0A0@DM6PR11MB3978.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OByvu22VU/hV2AkQCfKJOmnXZHgULwwqJzSH/gZdknMqr6Hlwdm2dRKgXJhuDLo8/VP5kVfRhfrccYXJ+G0j6OKis5yXc8mO6Vq2h0eUQ4yWCrkQB/V9IDz/1ZBmMLp0A1xyOYvyZnUExGgqycqVNhK5l4RhKoIxUpHKnGqlP6pRVQ7CiKscb2WaPTv18uCereoSGOjiBqPrdVkcohhbuxoCvBj7xDl12Pr2b5FOC8443ulJ761f9cU8brnBDw0vHJbZq/swMaGGLpmaCCmG2qQS6z6sdYminfMKRLB0CnDYrrUarEe8OsN8pnikMYmn7ASLPR+6Xio93azZR/VmMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(7416002)(53546011)(52536014)(26005)(6506007)(33656002)(8936002)(186003)(66476007)(7696005)(83380400001)(110136005)(5660300002)(55016002)(76116006)(66446008)(66556008)(64756008)(9686003)(316002)(54906003)(86362001)(478600001)(4326008)(71200400001)(2906002)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1GUJtv7s+lECJrdjDpE9jzPxYyb480C2KdNWnOlyJ1Kxqw0kGma+jIXstPmMrhkbixTzlROY6Q34e6ActUBnfcyIg8zWDy30C8iQGTbCgYf1cPSva7arBc5Ar8G6/s5NOTvWeht1qgRCmyTI8JwNVWGxIR6l1vjUYArLzWwQhgW2lQTCBCy7oemPwCo+Qth+lO8q7yNPAddUQwX9bdIMyzk2gw+qVbGed0J1EM0d3dAUWbYdZIn/NjvDbjPQ/A4FJQdUMTCI8x2HtYTZhbP9Oxj4zo82OTtU7vTa+qQ0cW/EWx6Lgb50mqa027iV52QGffh0Nrd4pewSeI8e3CF+sDoGbnKBl37TBFLnnPIkrDT2YM3X/IyBj03pFW5qMD6EXYOjH2l3dZnGEqN/Jib08FAP45r4o6O0sUfHeX1xaxOinSZ6lzgfvmZBeOa9/vEuNgYiPM3yAD2/6jWtIP7S1na1jtB5HTCsgjjmDuYtvfk2jjUhl7uW9PQug/pINGrsoL8Hqnkj5D2K5zqQVw84o+EOT48qTbtr0dXdV5C+lak0Pcd1MkCs7HqmJoiABsUVYgdjIeWT02xnRq92oW4yEwAfKK5HSfsZoDdHVMq4N0oPxPrqBCaM1SShXME7X/eN4/e9bPPwoJZRthzwNUb1XA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7934de14-a0ca-4006-f8c7-08d86affc91d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 20:30:09.5215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ss8M4qOambIYOmEgbyDhfaZoINSPXd5yjoE736oe1XYvHW2WGD0t1L05UJkIqteWZAmL4vAppoAI6FbWEqxYiNVD1zhvq1KALv+c1Tvx26Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3978
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, October 6, 2020 10:03 AM
> To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Cc: Ertman, David M <david.m.ertman@intel.com>; alsa-devel@alsa-
> project.org; parav@mellanox.com; tiwai@suse.de; netdev@vger.kernel.org;
> ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
>=20
> On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > Thanks for the review Leon.

[...]

> > > > +EXPORT_SYMBOL_GPL(__ancillary_device_add);
> > > > +
> > > > +static int ancillary_probe_driver(struct device *dev)
> > > > +{
> > > > +	struct ancillary_driver *ancildrv =3D to_ancillary_drv(dev->drive=
r);
> > > > +	struct ancillary_device *ancildev =3D to_ancillary_dev(dev);
> > > > +	int ret;
> > > > +
> > > > +	ret =3D dev_pm_domain_attach(dev, true);
> > > > +	if (ret) {
> > > > +		dev_warn(dev, "Failed to attach to PM Domain : %d\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	ret =3D ancildrv->probe(ancildev, ancillary_match_id(ancildrv-
> >id_table, ancildev));
> > >
> > > I don't think that you need to call ->probe() if ancillary_match_id()
> > > returned NULL and probably that check should be done before
> > > dev_pm_domain_attach().
> >
> > we'll look into this.
> >

AKAIK, this callback is only accessed from the bus subsystem after a succes=
sful
return from ancillary_match().

-DaveE
