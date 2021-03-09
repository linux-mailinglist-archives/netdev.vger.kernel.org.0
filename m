Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA17331E18
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 05:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCIExY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 23:53:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:45216 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCIExX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 23:53:23 -0500
IronPort-SDR: y/EMhQ/HTllb4wak3xQT8WaWA5rE1Qt5lETYir8NjweQX4deOEsO1Xjde1ce9++cpMxYOjP+Bg
 MyhCWl+EeXag==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="249537619"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="249537619"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 20:53:22 -0800
IronPort-SDR: N6upvVNfmDjOhq63Kq3qHs2gemMLeW79LGswa5aCfcezHnBcuAPAmQzH8fcRKERq9qxmysfop2
 orSkErORi5xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="430624844"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 08 Mar 2021 20:53:22 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 8 Mar 2021 20:53:21 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 8 Mar 2021 20:53:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 8 Mar 2021 20:53:21 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.52) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 8 Mar 2021 20:53:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkhENeZ0k7Ic6BRB1+FFC1zsEVIo2VZ9m2IxClOH41yRYvUBZG/a4mh8sNrlpvLelTUtAYs0PQzT+BsGFAO2aA9dO6n88H9IV4bFfePiRHypDFnO3yDYTvlXD5MUVSrnoRrPEl6SSRpW3Y6Cyxl+njkPd1tjiS50P7X9pNSyRW/t82p9nLTQOp+Uu3Mz1USodCNpbRSynVM1gwCsD6FWL4jOxBNe6RWbotDn7K3Xdea/p8Y9zXEYALeKbT4udiZbO2xZppJdnP6iLVrvrZ6+poX6ixakg4109vdrfKy0p6/fzptLinhalTZvrDmlsTUdsnQSMlCDppYJi0Dp/g0aVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwLxOxty+9IgGtUjvkqtdFi6w/3frW9seLXHYHqE2Ls=;
 b=h1vUWyiJDJDoZNBOOV6h2yhs1nt5S/aoCZeVtxfqut2uqg6ADnXi2yspldvrf0AvqydTqhiyhmf0zzVLCgFkkIgKLRBDV6n4LJs9FWu4PdUqYAnFLkJJUxdKMQtGmL7SSWBeLcMNSksyohR+LaHlVCgKxuy96soyYK4aCx7DB0lpwvmhLlLKH/ZDzemlKtHLa4oxSTCMJeV5/5UnzHcEQNNY9xklgl6gY00sTf7gAJoKQ1Q79gUZPo3ONh9h/9kGpsqVyRcDe6ZcuNAUXgElfdjAGlusxTREgc+8PHA/TFLU5Pg4wUVXXG42eh8K5Yo8FEzH87y6h3nZ3wU8JVrfwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwLxOxty+9IgGtUjvkqtdFi6w/3frW9seLXHYHqE2Ls=;
 b=FW5uHKoJRXGkk1JxpTPavBSSj94R7vgso4iGMz32Z+gK+4fJ1duVrmgikRY6jZv2mioKQrSEUnrzdog/qmZrZNLchNC2SLYvrfOHD2G4BCJc4Hj7vrXPgvBWCbfeRaxuI+/lG+PBDgjdzJDgSkxvnB8C6x4LfxYSjA74Y4xNtHs=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB2694.namprd11.prod.outlook.com (2603:10b6:a02:c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 9 Mar
 2021 04:53:15 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Tue, 9 Mar 2021
 04:53:15 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Pierre-Louis Bossart" <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Laatz, Kevin" <kevin.laatz@intel.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Topic: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Index: AQHW9P+hri3YEhHn10KqfTIlfsDxHqpP5y6AgAAwW4CAKqelsIAABduAgABm3XA=
Date:   Tue, 9 Mar 2021 04:53:15 +0000
Message-ID: <BYAPR11MB3095534A3B62757F5AD63063D9929@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210127225641.1342-1-mike.ximing.chen@intel.com>
 <20210127225641.1342-2-mike.ximing.chen@intel.com>
 <YCKP5ZUL1/wMzmf4@kroah.com>
 <CAPcyv4hC2dJGAXbG2ogO=2THuDUHjgYekkNy4K_zwEmQcXLcjA@mail.gmail.com>
 <BYAPR11MB3095C54BA878D8A5502CA891D9939@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YEaFbyUM0Fu763vm@kroah.com>
In-Reply-To: <YEaFbyUM0Fu763vm@kroah.com>
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
x-ms-office365-filtering-correlation-id: 3ddf53b4-43e1-4dd3-77db-08d8e2b7402f
x-ms-traffictypediagnostic: BYAPR11MB2694:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2694C7D4CF8E574CB5BB1376D9929@BYAPR11MB2694.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JVTpSgeTEaAI90kFgnP/prcKNtZ2y/hjxOcCZnfUlaeUSsWg3TY+llKvdZB0+qr6UlvrHgKNg8ujmoRiYa0vBPEDmyyMiyuIU50cj7FwoJ3N5IVta6Fo+ly7w15JrGeQPEtlZubOC+IHd+FR3rIU7reAMAYuumET5/+oDb9gnC5Go6BHymdZP5M/eA6BEgndiPvw0wMBiA0twolPAysBGDek9gHPeeR3F0JYfCHLL5tZj5/vO1UhT2cE82HBbdoSwuuEULRQ/QEC8XckkbKlNfgosCgVjkIhnc7tHp342OM0i0AAaihLpEtvXy+dMu7QyvBZRWLaR3cjr46mR7ikLY6V0/SAEx3R0+/R2B7gPL+Uy5XNMAWd5F8N4hwTD79gUUocrqb0d0p8rgdpPq0UiMaMYzG5/qYPnPiHWrDtAyklVblvujA3WZ5LKcRMF0/lZjbHCFv3Ea0H1BgyKzTYycrYKUYAU0aFj/3WYn36Rbnv9IpKmEXBtu/Ou+REvFSR3pBAoinbz4hB6DAyrAlR/AcpfcdmFF8kTqD1xpmtNGeTZYevIqSgXlaQdininSWhNcvmFV06YDE/QGwou6ALINfWExSRs7/vB1kVw77RIxQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(66556008)(8936002)(52536014)(66476007)(71200400001)(186003)(8676002)(76116006)(966005)(66946007)(6916009)(86362001)(5660300002)(2906002)(66446008)(64756008)(4744005)(33656002)(316002)(7696005)(54906003)(4326008)(9686003)(6506007)(478600001)(55016002)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y5V3ha5nYAdRarjtAX/qas6fpfeEsJ4O2IE7KUlJdEVHUbq5PDUPENKvwR++?=
 =?us-ascii?Q?EqbmmER+qt72yqBCp41BXUuqTWSr9V0RKSfkjZK1DAbwFhwgS0Rc9fzRd5xm?=
 =?us-ascii?Q?Oo451vWkIKiEEMCRAGSEV8YtM/U2D22DrcPfonjwwykRsA/S5KsRq+s6h6WG?=
 =?us-ascii?Q?z1N+snqZuYILDWTsHuQUpKyz4RPhnOBEOAo75I2swG5ZElqX1dtJ2LwCEreb?=
 =?us-ascii?Q?Xfw3knvq4UP5O2NEljIQ9Ve5ExUESSlb0SrrHlpxH0kZkarqaTDcRc2BODys?=
 =?us-ascii?Q?LZ2N9pj4HrRWshQR3rQHnHXpWxgt//p5lJT1Qegzu/rKVphVGNd5yWicPcnR?=
 =?us-ascii?Q?lnXsEqolsvvEKi3IcVamZGexW4Ryg06QrVV84cZGkx7DpewiSt/WZWnmKHYe?=
 =?us-ascii?Q?9RDCYtfEdzncffpKndJo4mpZuYEQpvXK+zjOfgDiMNcN2tG+FiPIKCPuJe1t?=
 =?us-ascii?Q?gIHIVmJOG5txVdhOYam/GZy5iR8N2WIkJMfn6DMpItsw0RUYflf7boDvHvPM?=
 =?us-ascii?Q?gowX3W3274BolBW2mlja3FcwsoE2TjM/VfRsbGMGQKTdRokd1iIopKmgWM4l?=
 =?us-ascii?Q?Jx1fL/+giX29gK0sH9uM5i2KFqkbsr280rSyBRgqSclFL2vL+GI2gjhwea25?=
 =?us-ascii?Q?IyH1lIaTm++UmpujEN+ArsCoadT4b7HMvWckwCAylxQY+wBq7yJjWBphL+5H?=
 =?us-ascii?Q?EP0/tryZM+66HhrwU43ppIVZVSvMf6L2u9BfAvBEtO/+olwY8dWJc2c5er/Q?=
 =?us-ascii?Q?iIQSF+bRUECWZMMjbwfo6iaYsXI6chsKmZkbUOVwRKce+L/yS8RyjD5Rm3fc?=
 =?us-ascii?Q?zFJ1h3JbGUudEdqrS7jukw6OeA1lnaA8/U0AH8nmg+P1P+Uypf3fYCg/5UfH?=
 =?us-ascii?Q?uE0MP0s6m/ltzVdOJCC4TkskNqHqrJLiqDgdQ8JtwDl3f0+o3Wy5tWGENqhw?=
 =?us-ascii?Q?0SRII3suC6udZUbA4NQ2GALMdRk+oWxt+hbQX5y5x3POWmW4g7zQwL1B4rbh?=
 =?us-ascii?Q?dwbR1SojIjkzWRqh818zWiiaBa76Fgpk9LNKFNw3IaGIdUTg4lCvSc40P/nB?=
 =?us-ascii?Q?9PaXubYTefMv0+OPhM+uK3kJ8n9MEBgj3MBicwfYowAVsYhYi744NN2XAcOK?=
 =?us-ascii?Q?xwv+Us2FEr6mFWEttsG7hukm7GdsV5kAHjPVR78qCeSXF2rO3uwSRCK3eQRO?=
 =?us-ascii?Q?10ewRAJQP4nNudRHDxephPyN797ZX2t9AS2vGFYL1bVBkvardDcSQi72ToZb?=
 =?us-ascii?Q?76sIEnAFx1wiCD907AeWrQMAeu+U8ju1GiLo+LWkOPhCR0tLcbc4UbWZEIXS?=
 =?us-ascii?Q?zzon8MqdXkRDJg+e9QzL1RXY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddf53b4-43e1-4dd3-77db-08d8e2b7402f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 04:53:15.4911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QsFIx5+IvsTwSGadBr6DwKpExfwcj5GWWUf1MN21SHMUC8j2Kgp2Aluh8AUloFY+0vAfGMu57P52c04kJyDrZbPzon6/8/dZ00TNbngm2oM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2694
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> On Mon, Mar 08, 2021 at 08:00:00PM +0000, Chen, Mike Ximing wrote:
> >
> > Hi Greg,
> >
> > While waiting for the feedback from the networking maintainers, I am
> > wondering if you have any other comments/suggestions that I  should add=
ress
> > in parallel.
>=20
> It's in my "to-review" queue, which is huge at the moment.  But the
> networking developers review will determine how this should go forward,
> so I'll just wait for them to get to it.
>=20

I see the status of the submission (to netdev)  is now marked as "Not Appli=
cable"=20
at netdev's patchwork site
https://patchwork.kernel.org/project/netdevbpf/list/?series=3D&submitter=3D=
197673&state=3D*&q=3D&archive=3Dboth&delegate=3D

Looks like that the patch set is considered as not being networking related=
. (?)

Thanks
Mike=20
