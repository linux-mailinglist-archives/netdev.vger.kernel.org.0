Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA647589C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhLOMNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:13:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:63948 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhLOMNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 07:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639570431; x=1671106431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UMxpYNYWAZLxSKWOVEiHMx1a+anopYlNCFRPccrejSI=;
  b=NFYaX2lnqh3ow42x56m+m/d6FHHzeJ7haiYiCCR7XbxNJwxsRTkHaDpI
   IzfMxU9hxg/5Uyuqk6L09v5750eLUuFwdjuI4bdGv/x+TlGLzqY3a8bSO
   xOFgn6u7foK4OfJ2YpQprx6FNJpIltAEwmHpPTonI3PrHDO1GyKN2fefT
   wHyBagCBRGvEZwwB7QogkwIanlyGhEqY2DRgQIgnPAUxUdnEHgHrV2IzC
   1rClJZXuaTgpVYniyDs1hRkLNTCBX4z5B7k4Ry6M2gJl8FeBn+Zq5DCHP
   eor9YDlwvikPiAxikI3mJKNyFBHOjEFM1xKFGMXeTn88UZ+tCMPSnnfKp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="236749437"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236749437"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 04:13:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="661904764"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2021 04:13:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 04:13:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 04:13:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 04:13:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 04:13:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZswrIMxmh3cTe8s3Nq73YRr1mg7jWrTDJXBFJVlCwKGCvwnCR/Lj0vzNbkce12gWQ6Ce1fI9mf5j+8OEDajnGn78FtATuGNd0/ueRaJTehZlWKRa//FU/o8HPtejgsyajPyzc5DPNbvOkM1G0hjcC63GMkiOaNZfUIjWv9zc4hIG8ltI/IMRphAQtdLZVEHBVrWQ1cwgHmxg7mQSNAkIJglnR1dFzADnXijT0zE/Y0wnakijgg/QmaEGOC5DH/cjQtIoaBE4u8Vxy9XAMAgfmcq8CVq35/IvO4mmmQZoBRD++S8vy65Tjs/vqdsHHUm8q86xk11819GcwdB0WwvExw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lf9Q2gZ5kslS7rcT+MG8r0NCtrtgX4gkOp2K96PaLrM=;
 b=VVmai+FdEGMwhJWDf6zwjTZtpJRSFWnjDzj6YfqGM3hqM5ETm0kpDvRXjmdhxb9tsWQpB4x4X5ZgbW3241ft5K7OUUtYFPP5mViGr+LfQEKgXkEyNzxts1u4KhTTkBgnMssBJ5a2A78BSxrcwjMRL3zxPMQzrBlGTAcOx0C2hMbIkZ3MFywEA3Gy87gXEPvwzBu4Ny2CJi9U9Th5WcIMRXoeVcKWI43IlQDhvZQw3LgwNxV+sgI+MYPbReNgNyBXget9ADCW4nLH9wMbOucCAWjLxpsvbBnfVdgcXtmBS9gR6Vwq8bH/Qb8sEqnSZR9RNO9mZMzUTs7R/UQAltv46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4617.namprd11.prod.outlook.com (2603:10b6:303:59::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 12:13:48 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1ca9:6778:2b2f:7de9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1ca9:6778:2b2f:7de9%5]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 12:13:48 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "Vadim Fedorenko" <vfedorenko@novek.ru>
Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Topic: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Index: AQHX7c5gIm8QXL1ZEECyYOKvL6PbZKwuwIcAgAFiCYA=
Date:   Wed, 15 Dec 2021 12:13:47 +0000
Message-ID: <MW5PR11MB5812E5A30C05E2F1EAB2D9D5EA769@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <YbXhXstRpzpQRBR8@shredder>
In-Reply-To: <YbXhXstRpzpQRBR8@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507cf438-2216-476c-a649-08d9bfc4593c
x-ms-traffictypediagnostic: MW3PR11MB4617:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW3PR11MB461737C4072B8A8F52750E50EA769@MW3PR11MB4617.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HyckihH8yBX/3Rw5zFOiLZa6pS3h+ZrWAHD7CMaodyUE4oyNl2n6BwwvlpbaAiUJsnLDHV8a/u39XzWSLc6BDPsEVEuklXcvAe0NPZdMDFtorNgW47TP0FqvfF5t+//i2iGQWP4D+xdZh9Ezv4XxShDKINWZSmHsiUksKv9z7/lii4F0+bRr04BlVRevzOhpsOUm8+7ct7XKJ87FUlUHNCT4uyjkC9/0HWL1LqS42w0E0TxnnV18j+458hht4yRLEPJ9taAfXmHERwEhSvWvl2UCGs0/DgC6ZrVmS21FCwriqlT0yMMf454iUGoboRSNk6Fe0RKh/n5ceD46b/8J6ucs+QTgBVx769Z+tm8+JPqhMtFZJHQp38V4DiAMlI2psVrolzgMt673xVi5UBlbYMctbXHZSeUmrVHhH8PFqgVJZpcDo0StMcVDfQhc9QRAZPt7MZ0alzlJ0Xuv3qpZXmKfZ/bRsLg1jnrE7OaFADpEQxkKSSF9bjpQE0SFdz5zmF9JL9LQorPLrg2htriPvYudZssDp4O0u0Wg5ZhzCljSa/eIWQsNRNafGa5zel77uKstWlQjYC7fvZTxpgQP9UjrPhtrsqt8fxFfEIREjeZFBq+vXgGoDKyeKSlQlf+HowyzsaVlJ9K/qAscnUjQ0ZfRaYmBJg4Tzo5n3wZGJQuHnyt52HzW/MiRyG7b8WPI+5yQ8pvHFakjHqOS0lwTFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66446008)(6506007)(53546011)(5660300002)(33656002)(508600001)(54906003)(76116006)(316002)(38070700005)(186003)(66556008)(55016003)(66946007)(66476007)(4326008)(82960400001)(7416002)(6916009)(8676002)(64756008)(7696005)(52536014)(9686003)(71200400001)(83380400001)(38100700002)(122000001)(2906002)(8936002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z+ez4U7pLDU6DEk9gnJ3NLhhy4nPogR5xvN5GXSH2VvyYHn+Ln2gu19cmOJc?=
 =?us-ascii?Q?BYmkSuqOR95woqSbVYGMiq19UZUj3LrlQFHq3ExhzBJW7gl6noYWRastmK2g?=
 =?us-ascii?Q?KeCUVnOH94lDI8/r0/Mx02ORr/uRlGZGaHDGrVh7hmi3AOBT9tSUjk/ND/+W?=
 =?us-ascii?Q?gRnoAuShx7+e2px5pgMQ9/rXCP96XZatAver948al78OENctbI8r+8HZF4ip?=
 =?us-ascii?Q?9U5WYcgiqAQerGmYuFl/SoakgryUWGSBXezQ8wwAgop9gk7x6S7xdvbxMekA?=
 =?us-ascii?Q?MFpZqB1+k75RPCAVrJXfLetLDtVpB2LkmQ+hDP4KaD9BNLhM1IXFlqu4ayFm?=
 =?us-ascii?Q?o+phvas6A8V4TrPBpeTCQwOdef1CsyGiLgD3ACY5Z/aAAJBJ2ht+Pto4Keac?=
 =?us-ascii?Q?sXfaGKH8HLGMlQvoPAtuThY0O6b4mFTzbBmV83zRbsjEUovr1mJSObZPTaJI?=
 =?us-ascii?Q?WzPg0I5EjZ6c1Jgii0jZcQ00oTwMEc9OADO1LfYHBAvitsUqMO5tD1i8mpS4?=
 =?us-ascii?Q?BC+XpNhoksau3ueaQrWWf2VeoEaufdCF1yMGRzE7OUlIlKbnY6HKzBCvR25X?=
 =?us-ascii?Q?PqMkE/Fapl4v2a3EfB4XSRBwkufWyxEp2BDqoySedSdhkIi4uGgFpbjPCvqp?=
 =?us-ascii?Q?4sWYJtfU44ZLSfSJZbYisjEnqpn9Xr9xvHwpRstGff9fX72YwZz6qpKdIJPP?=
 =?us-ascii?Q?PYlyyr4e2a1tKshZILVkS7JpOPsBWwC59AnuclVgRyu84L47aGrQIgwSbCTp?=
 =?us-ascii?Q?KaGIRAZLmFDuv3itEx+DvUfgYJ1LpxEfvDWo8t8WwZhAOAuLKAC5CWihvBSb?=
 =?us-ascii?Q?6Zq7IDvpteZI6ES6V9EMRBzpsE6yB4tuX8SvsAI5sUdmy1lzVW3R+XaMGBfh?=
 =?us-ascii?Q?KCuyOaSl4qZzzXIMUKXPuln3BizYPCxyd4VPBXWBCRLQVOI39V9fblgvrhJP?=
 =?us-ascii?Q?7rvYlQwDn77QBqlKqKUGK8HPHAfiBNEH+O1kGqFUkFxHEAptM/yrnyAUQaki?=
 =?us-ascii?Q?Xmi/Hxj9N4KoGIHXVJCdZbH+i1aRflsCqzGhwKUDcvTnLxjFXaMS30P+Oosx?=
 =?us-ascii?Q?a/teR9BSzEwlSGGMt+4c3O2GPDmqh75R721hpwZhWPicmTAkBBbk9rH4R5z9?=
 =?us-ascii?Q?OezOZe9R77FXhhF5nDpxV8psQj8QkTRD6yeGHSAtN/ZbSM+pObfF8T8hcIcV?=
 =?us-ascii?Q?nKnKsMJVdGT+tNMu1xBXAN1ZPSJ3aCoqhukqrtWrOHa6XhzVdI8l7/kPj1sJ?=
 =?us-ascii?Q?zSJKoWi4jH954STmf5f5YtpeaI3dXiZNJ9DdpYkUcOaHQp5dsbPHeE+Dge8k?=
 =?us-ascii?Q?NF8sPowKHo9FbZYjskXqoP6HBL+3aKBJrCG7MqM8WAMJhPhJ3AsjbW94Uh80?=
 =?us-ascii?Q?gAdF3OHSdDdHTQaNz86+o+6MDJBEw+Pq6YU9RJsU+Yq5dcyyEksETemegttE?=
 =?us-ascii?Q?ALMrFm05M1nZnoNmDGMLtH3rHlxqyYafbY5YNyQJ3WjUZ0D4NRohujuh7ZyD?=
 =?us-ascii?Q?vJUxVGEyg6S11gXOESjMPjBS+zzki5xVKxlnBiBSXaoT1h2U8tVxqSWm7TZt?=
 =?us-ascii?Q?ovRH7ywtqFiv/8Gbw1TUOTEl1v9Tl6Kiwo6VHE3QYGStcCHCzuPXhu/9jFUM?=
 =?us-ascii?Q?mBi39xRAC5eIEwuBqJdCtmuyQB/ffq09V5ZZRDtmPopaCxcvSUbnX+b8FDLi?=
 =?us-ascii?Q?fgwtMg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507cf438-2216-476c-a649-08d9bfc4593c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 12:13:48.0027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGAr2PO/T9yosgAzAduKv5vOkS30+I3K65fl3xoCS86iLm5+h7o5Dgl2C/mv6yWuiFc1J46kJzEitGsgf7tuyUsmcnOr60VgBo8bc+2yAt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4617
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Sunday, December 12, 2021 12:48 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>=20
> On Fri, Dec 10, 2021 at 02:45:46PM +0100, Maciej Machnikowski wrote:
> > Synchronous Ethernet networks use a physical layer clock to syntonize
> > the frequency across different network elements.
> >
> > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > Equipment Clock (EEC) and have the ability to synchronize to reference
> > frequency sources.
> >
> > This patch series is a prerequisite for EEC object and adds ability
> > to enable recovered clocks in the physical layer of the netdev object.
> > Recovered clocks can be used as one of the reference signal by the EEC.
>=20
> The dependency is the other way around. It doesn't make sense to add
> APIs to configure the inputs of an object that doesn't exist. First add
> the EEC object, then we can talk about APIs to configure its inputs from
> netdevs.

This API configures frequency outputs of the PTY layer of
a PHY/integrated MAC. It does not configure any inputs nor it interacts
with the EEC. The goal of it is to expose the clock to the piece that
requires it as a reference one (a DPLL/FPGA/anything else).

I don't agree with the statement that we must have EEC object first,
as we can already configure different frequency sources using different
subsystems. The source of signal should be separated from its
consumer.
=20
> With these four patches alone, user space doesn't know how many EECs
> there are in the system, it doesn't know the mapping from netdev to EEC,
> it doesn't know the state of the EEC, it doesn't know which source is
> chosen in case more than one source is enabled. Patch #3 tries to work
> around it by having ice print to kernel log, when the information should
> really be exposed via the EEC object.

The goal of them is to add API for recovered clocks - not for EECs. This pa=
rt=20
is there for observability and will still be there when EEC is in place.
Those will need to be addressed by the DPLL subsystem.

> +		dev_warn(ice_pf_to_dev(pf),
> +			 "<DPLL%i> state changed to: %d, pin %d",
> +			 ICE_CGU_DPLL_SYNCE,
> +			 pf->synce_dpll_state,
> +			 pin);
>=20
> >
> > Further work is required to add the DPLL subsystem, link it to the
> > netdev object and create API to read the EEC DPLL state.
>=20
> When the EEC object materializes, we might find out that this API needs
> to be changed / reworked / removed, but we won't be able to do that
> given it's uAPI. I don't know where the confidence that it won't happen
> stems from when there are so many question marks around this new
> object.

This API follows the functionality of other frequency outputs that exist
in the kernel, like PTP period file for frequency output of PTP clock
or other GPIOs. I highly doubt it'll change - we may extend it to add mappi=
ng
between pins, but like I indicated - this will not always be known to SW.

Regards
Maciek
