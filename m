Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714BF44AB8F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbhKIKfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:35:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:45500 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241776AbhKIKf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 05:35:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="318619439"
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="318619439"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 02:32:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,220,1631602800"; 
   d="scan'208";a="582065929"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Nov 2021 02:32:43 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 9 Nov 2021 02:32:42 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 9 Nov 2021 02:32:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 9 Nov 2021 02:32:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 9 Nov 2021 02:32:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv7nnG056VXpWVCzPjFTpQFD/NZ8U7Hxy9VOQ0c+n5KH5XEHHB6y3ZVUSMF4jqY0h4x9kW7gyg2oNhyFagz27WBMsnD3JyGBjJ1U3RXJ+ynFbIu1IXKcP9EEGTP/oNHvk+kbKKuJFdcvdDfuIz2Ddp0YZpD6byiM5so1hPyNnG05BzhqnR5rBs5aXG8NWGAQtuBpzy7rsbFOmoM0pJ3Dq5A3Dr+X948h+tyT2BD6UxOYmp9sUqpDCS2F6m1FnKRCO4gujDoTjrGxG4bMZE+vClJfnpzRzj5BoTpiWHWlbYJJKuuPG97Ls7KMCd8omtvTN5SJrf3Do6pIzzYYcytCSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JC6Fz0u/S0bpF6yk3qUMAO76KF5zhN2IOoTgKW1uiw0=;
 b=UPPVRaVw44Q9zj9zFRBXhLhTkVDA/O1v0JwEEv62+ywtM4H3aMf2V+PwdGlgs41K8lTKGWJZXokRGmw6inQJg/yuLJN5mwP7u09ewJbMcM3bd8xg5GUfAa3dky92VOQ9a1wGDWx7fphV5sVS72vd96oYJmjx2eg4Ee0+zQ8xmCaCioqbUiqFxA0VGMqzqIYT72jQbnC+hKlNul8KgXHVA8P8E3qsUrJQ64IgvmcPCr4gfJ0wWUkB8KLCqZY1lbSdOwbKwQ+NhHlRSJcb5Xsf9M6FT9VnplQTsVbdnVht0w9RhqDa3O2f6d8mQu2P2LZIjjiygya8NQuTO7jykD0OLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JC6Fz0u/S0bpF6yk3qUMAO76KF5zhN2IOoTgKW1uiw0=;
 b=u0HPRaHaeFvOIX2W41KB6vnP47/EqAjPAn1VDSASWQvpLQ3eIGfdMGB693Y9QGmQfl52DC3iawKms0xi6VY9FZ23SBG/TWjhzOWXeELwzdLHmO1BJidq0fR4nptqX82JYA7t56t5B02gQGTywNujE1F3iR2910MGuzeZTlyq+54=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR1101MB2208.namprd11.prod.outlook.com (2603:10b6:301:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 10:32:41 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Tue, 9 Nov 2021
 10:32:41 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0oli6labJUcox0OLXoT9uSo8Gqv4HN8AgAEw1JCAAIjtAIAAChYw
Date:   Tue, 9 Nov 2021 10:32:40 +0000
Message-ID: <MW5PR11MB58120FAF88326A306AFFC1E9EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <YYfd7DCFFtj/x+zQ@shredder>
 <MW5PR11MB58120F585A5CF1BCA1E7E958EA919@MW5PR11MB5812.namprd11.prod.outlook.com>
 <YYlQfm3eW/jRS4Ra@shredder>
In-Reply-To: <YYlQfm3eW/jRS4Ra@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7116c9f-8eb0-48ce-d22e-08d9a36c4217
x-ms-traffictypediagnostic: MWHPR1101MB2208:
x-microsoft-antispam-prvs: <MWHPR1101MB2208925D5328C15A12DFD7CFEA929@MWHPR1101MB2208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NiSJGGmnVpbOlYYLhJyBI34JJNdxrWjhIQsYVYh4ixEQ2FhyWvDqes9lQApTfKVXtJH8aCUGNqHpO9W5AndV6iv+Gkk2IST3WYyXFVSJ4TJW8uPWAx2LaiZBY1NB5I0dNFh0IcMhspliMzdi3TOfqJnsRhNSFf57Lrqk6qpWHDsCcR81vEXZL4rbAaPG51pYr3tF0PAiToGy8tAZAipdWENtMclzJ+h3G+vK2Rv08hES94Vu3XqRi5UvNkDfSgjaqYpzRKGuZVFKVLRs8Y+Rm7tNFaXppVwAUzwh6OxM71l+k/ghx+XEYjZICIw4r3ea/Z0uPNCO91mAX1Qp9y0t+B8nB5EZM9CEx8bcRiRgW4hK8tX6uojJ9yyKZ5Zv7O8FbSlrpi4yv6y2on1/8KBwYy3U91GL021dGMhhVyqDf5zkiaDHzwwFt4nwrTMFjqkTlfC14N4YThfmSqYmkjcBQIs2yzr1IRlAiQEwj1HroFoJSKV9xrpvxSW5l00q0Bdg410sUNoF+hpUn5Plf12UyU44Fbf6BbE589eMf4LTulfYkx5cMN20qjERih6dC1mQnRzAK7164DebJt/DWOyHL+OeUWnB0yrHD3jVMw0kLH1HhPDyob2zh5HOvKGPB5EzD9azdGnQy1rtkQ1+4UqgUmrx/OQntAmbgN9wcc3EvEaNkGj+2sDqF0Zv74xISuEAfpaYCaZBnJwq10nfo8Xddw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(8676002)(6916009)(508600001)(66446008)(54906003)(9686003)(66476007)(6506007)(33656002)(55016002)(64756008)(7416002)(76116006)(8936002)(66946007)(5660300002)(7696005)(83380400001)(4326008)(66556008)(316002)(86362001)(186003)(38100700002)(2906002)(122000001)(38070700005)(71200400001)(26005)(52536014)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?er+v6BB1q+3sDeqs58YrlzeJ8VGSX/th0n21OxDLp8ocQL0P6T1TzqLPEg9D?=
 =?us-ascii?Q?6NM4plYEJwk3QC27YAYR+3DN8InatQnfuqZfPv2EgNeASTPuc4i6sWQDpTtz?=
 =?us-ascii?Q?RiiMkb7a2Cib3k+o3d+9KNXCEUUOPa14Q1HxYoEy7/GdA6gAMBfMeKnzYeRo?=
 =?us-ascii?Q?s2vOgSi08k9Yg4DYjpC1i0uLSBgeLJ1oVczOL1GyHzJeyA872zWx+6P/SpWS?=
 =?us-ascii?Q?vWWokrW6sqKo385ipN8lQZqjezpeojeKvSsTSjGJ/thwew+GtO0QM+hPIHy6?=
 =?us-ascii?Q?DSe6AKaNnbe6fAMEmfaJIhQNGobEHHPADiGyvVqhFRNAAnMfZYXee1GdNSv8?=
 =?us-ascii?Q?rdDtHvSxeYkkiZ8PBO9RnA2UdTgmfYtF0hawDP5e6rZBfdZvd701IO8p/xhZ?=
 =?us-ascii?Q?tJKZ+RYa4j1YYvx1O3uEA3dozc6vUFBRm6I/jIBXhJEBMvR4a9HEfu7D2O1K?=
 =?us-ascii?Q?u/PV5hzLTBDMegMNPQH+yooGyl62CoXUmV3s1MS6VD1TbJB1kkJoNx/IMZqv?=
 =?us-ascii?Q?4EDJdiJVfZfxcI+icizTujDtIwmPBw6fmWEoNAqf0LnzeVSGAI7l0BoGd5zz?=
 =?us-ascii?Q?bxJqF3Kb3xM+Sos/zGS72pDiAZwJU2KUpe++gNILtavXS2MrKUGhvrxd2GSX?=
 =?us-ascii?Q?McUQJk2gAP+YdAyYBVzcaq2cfRMv7O/ZDUJOUH6jVXWnkNr92D7D8Bt8K6VW?=
 =?us-ascii?Q?B+1K2vA0toyaFWolxKri5q/Q2INXgsZLnkrwzcqiXFhsnXW/O/YK3OmGqPtC?=
 =?us-ascii?Q?mXH81lm5H/ocfa+z5GpJaCA5IcWrObvcRjyyygsMmDSs98mdviJSEFIA+Jr/?=
 =?us-ascii?Q?/+gxhEgYVjbo0HuTgDVIJOhEsSOVUIjeBrlilg6cxHNf4Vu0UYdl8dj6KA+4?=
 =?us-ascii?Q?nEeCirSt/wTqC4burbY0/Ro4xjivbYT5qjZ4ZVzdyRgfxdJgWGPWvq/0boC3?=
 =?us-ascii?Q?uRnou06qfWyDN2NZGV7hEtFLXt7l32i0wuWIbRb7h2pAvjyMUjp6jMIiXXGg?=
 =?us-ascii?Q?aovvvUjUBJ8exvuNq57L3eqJ58YpDE/XCoGsYCXgFV3/ke0Euz2/TbgO98Il?=
 =?us-ascii?Q?jlzYnLbGJp03w9CL4Amy/GfzLZhbV2s9MzR7orl+k4QwpRG/75e2OBhuLDV7?=
 =?us-ascii?Q?WHSTY6ZEnoUWtLe1cCei2JRGaOF+85Rma4+Q1K4KaQD7gGP6cc0/n1s8/7dq?=
 =?us-ascii?Q?EGzqjgsRu2omuSrfkgiZq3EwPkEShHhYhSRvk6ad+sTmGzw8dL/lXlqzCF2t?=
 =?us-ascii?Q?BxwJbBVRwpFBQMTiWZrqkq7x2f5CnF82IOh79BobESGLhEhWyJwGEjkR4dz+?=
 =?us-ascii?Q?mEMPQqdqZ0d7WDlvMSdB1YXW36jhZHo5pFgZvCMJbEqwybIVLaI8odIp1ZTf?=
 =?us-ascii?Q?K+T/ecc9hwENqxnZOqM+qQf3xnMCHWSRf2elS+RdbxJgZlWCN5UtFyECHMLB?=
 =?us-ascii?Q?smJiaGsuhlr/C397+f/mqSCRn5fS2VTQU6fVPkjeJxOQJwA0r0sSSPcFYhFf?=
 =?us-ascii?Q?RAeur+vVZjErbUWXiD9ujZDYubtCNTRYtLrc0xOJWnJJD+0mzJWYkQEWbrad?=
 =?us-ascii?Q?dw1iZkdhL2xxT2LFRsrFPJp1UJgetB8naQvYECYyWy7VGXuaHyq6hOnEpjwL?=
 =?us-ascii?Q?k28zK+uyRq6y0nPt50lbIxPCIGINKPHa1qHTxWX3czxdSgxmUVYIdaQjskWs?=
 =?us-ascii?Q?E0jz2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7116c9f-8eb0-48ce-d22e-08d9a36c4217
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 10:32:40.8675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 430arB/llk8qD9DnYulHi5GkWveqNLpCJQUqyrXMJ4vuNez29k3tD/Fzy44EcDMfzuQUc9WH21mlAOREucEDQXb3LhuC0chBU2vbTq0++xU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2208
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Monday, November 8, 2021 5:30 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
> On Mon, Nov 08, 2021 at 08:35:17AM +0000, Machnikowski, Maciej wrote:
> > > -----Original Message-----
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Sent: Sunday, November 7, 2021 3:09 PM
> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > > Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of Sy=
ncE
> > > interfaces
> > >
> > > On Fri, Nov 05, 2021 at 09:53:31PM +0100, Maciej Machnikowski wrote:
> > > > +Interface
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +The following RTNL messages are used to read/configure SyncE
> recovered
> > > > +clocks.
> > > > +
> > > > +RTM_GETRCLKRANGE
> > > > +-----------------
> > > > +Reads the allowed pin index range for the recovered clock outputs.
> > > > +This can be aligned to PHY outputs or to EEC inputs, whichever is
> > > > +better for a given application.
> > >
> > > Can you explain the difference between PHY outputs and EEC inputs? It=
 is
> > > no clear to me from the diagram.
> >
> > PHY is the source of frequency for the EEC, so PHY produces the referen=
ce
> > And EEC synchronizes to it.
> >
> > Both PHY outputs and EEC inputs are configurable. PHY outputs usually a=
re
> > configured using PHY registers, and EEC inputs in the DPLL references
> > block
> >
> > > How would the diagram look in a multi-port adapter where you have a
> > > single EEC?
> >
> > That depends. It can be either a multiport PHY - in this case it will l=
ook
> > exactly like the one I drawn. In case we have multiple PHYs their recov=
ered
> > clock outputs will go to different recovered clock inputs and each PHY
> > TX clock inputs will be driven from different EEC's synchronized output=
s
> > or from a single one through  clock fan out.
> >
> > > > +Will call the ndo_get_rclk_range function to read the allowed rang=
e
> > > > +of output pin indexes.
> > > > +Will call ndo_get_rclk_range to determine the allowed recovered cl=
ock
> > > > +range and return them in the IFLA_RCLK_RANGE_MIN_PIN and the
> > > > +IFLA_RCLK_RANGE_MAX_PIN attributes
> > >
> > > The first sentence seems to be redundant
> > >
> > > > +
> > > > +RTM_GETRCLKSTATE
> > > > +-----------------
> > > > +Read the state of recovered pins that output recovered clock from
> > > > +a given port. The message will contain the number of assigned cloc=
ks
> > > > +(IFLA_RCLK_STATE_COUNT) and an N pin indexes in
> > > IFLA_RCLK_STATE_OUT_IDX
> > > > +To support multiple recovered clock outputs from the same port, th=
is
> > > message
> > > > +will return the IFLA_RCLK_STATE_COUNT attribute containing the
> number
> > > of
> > > > +active recovered clock outputs (N) and N IFLA_RCLK_STATE_OUT_IDX
> > > attributes
> > > > +listing the active output indexes.
> > > > +This message will call the ndo_get_rclk_range to determine the
> allowed
> > > > +recovered clock indexes and then will loop through them, calling
> > > > +the ndo_get_rclk_state for each of them.
> > >
> > > Why do you need both RTM_GETRCLKRANGE and RTM_GETRCLKSTATE?
> Isn't
> > > RTM_GETRCLKSTATE enough? Instead of skipping over "disabled" pins in
> the
> > > range IFLA_RCLK_RANGE_MIN_PIN..IFLA_RCLK_RANGE_MAX_PIN, just
> > > report the
> > > state (enabled / disable) for all
> >
> > Great idea! Will implement it.
> >
> > > > +
> > > > +RTM_SETRCLKSTATE
> > > > +-----------------
> > > > +Sets the redirection of the recovered clock for a given pin. This
> message
> > > > +expects one attribute:
> > > > +struct if_set_rclk_msg {
> > > > +	__u32 ifindex; /* interface index */
> > > > +	__u32 out_idx; /* output index (from a valid range)
> > > > +	__u32 flags; /* configuration flags */
> > > > +};
> > > > +
> > > > +Supported flags are:
> > > > +SET_RCLK_FLAGS_ENA - if set in flags - the given output will be
> enabled,
> > > > +		     if clear - the output will be disabled.
> > >
> > > In the diagram you have two recovered clock outputs going into the EE=
C.
> > > According to which the EEC is synchronized?
> >
> > That will depend on the future DPLL configuration. For now it'll be bas=
ed
> > on the DPLL's auto select ability and its default configuration.
> >
> > > How does user space know which pins to enable?
> >
> > That's why the RTM_GETRCLKRANGE was invented but I like the suggestion
> > you made above so will rework the code to remove the range one and
> > just return the indexes with enable/disable bit for each of them. In th=
is
> > case youserspace will just send the RTM_GETRCLKSTATE to learn what
> > can be enabled.
>=20
> In the diagram there are multiple Rx lanes, all of which might be used
> by the same port. How does user space know to differentiate between the
> quality levels of the clock signal recovered from each lane / pin when
> the information is transmitted on a per-port basis via ESMC messages?

The lines represent different ports - not necessarily lanes. My bad - will =
fix.

> The uAPI seems to be too low-level and is not compatible with Nvidia's
> devices and potentially other vendors. We really just need a logical
> interface that says "Synchronize the frequency of the EEC to the clock
> recovered from port X". The kernel / drivers should abstract the inner
> workings of the device from user space. Any reason this can't work for
> ice?

You can build a very simple solution with just one recovered clock index an=
d
implement exactly what you described. RTM_SETRCLKSTATE will only set the
redirection and RTM_GETRCLKSTATE will read the current HW setting of
what's enabled.
=20
> I also want to re-iterate my dissatisfaction with the interface being
> netdev-centric. By modelling the EEC as a standalone object we will be
> able to extend it to set the source of the EEC to something other than a
> netdev in the future. If we don't do it now, we will end up with two
> ways to report the source of the EEC (i.e., EEC_SRC_PORT and something
> else).
>=20
> Other advantages of modelling the EEC as a separate object include the
> ability for user space to determine the mapping between netdevs and EECs
> (currently impossible) and reporting additional EEC attributes such as
> SyncE clockIdentity and default SSM code. There is really no reason to
> report all of this identical information via multiple netdevs.
>
> With regards to rtnetlink vs. something else, in my suggestion the only
> thing that should be reported per-netdev is the mapping between the
> netdev and the EEC. Similar to the way user space determines the mapping
> from netdev to PHC via ETHTOOL_GET_TS_INFO. If we go with rtnetlink,
> this can be reported as a new attribute in RTM_NEWLINK, no need to add
> new messages.

Will answer that in the following mail.
