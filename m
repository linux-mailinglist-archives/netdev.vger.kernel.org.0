Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B1C4299C5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 01:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhJKXXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 19:23:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:31665 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhJKXXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 19:23:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="213940373"
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="213940373"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 16:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="460145728"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 11 Oct 2021 16:21:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 16:21:53 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 16:21:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 11 Oct 2021 16:21:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 11 Oct 2021 16:21:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6vVfkESFFxQTO45vqnMo6uflLYCX0wp/c+RXksIHx8oI4S49pYWBfiBTIQ80uQ9qqFOpEvdTefRdSlshDycXNAkLnQdo22dKuMB+seHZspIebURzSOaFxOQQFL1ThFXnzB/kVKxgUgK3swGuWUx+/oU/4I2Wq+/3EypvkuH3LhD1eYFDT+wvTIlPXAR4jT/H0o7I7bHyGRqPOjC76UTfvEvgVsYUlTtKMUht2Tp7+VX/1dpmvrK7TUhLfprRAhuFyZCqT6HNvrL9z6pTI5F026JzykY0oxL7TPFOGT4DxbMHCkrF7PV2j3dGXuvG+ccuE5Vr2fBtYrPGsXJgdxYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PU938sBDE+AAXDYhDH8O6h8m+KscBhDLaU3D7XkUd4=;
 b=TO+BBLmtt1F8Bhnq8EUR8SlBFF0RRcYdQ6IKlSMYwVckrAhRNISpyQHthig8RYvCZEHLtTCLGlmq004C1Try8TFd5BW1LqupxE5TT0xqMUxGRSRMgccHlNrmJpFPu5+QONFqBqzTvHQYjfXooEbwlbzJAgbpS/d4qcqT77MBQkp+qj+RbTu/F1VrxRqiHccSwjnsYaXwyL0qGAVpC/e9LNnmFZFXa+ECAPkUaVlBJiQyek39zcD8w5zadF+5xQYmxGUAT8YoH3+tvwefbhvMHv4VhDLG0bQZXzck58L9tm5/z4D9Qng7fvBF7poIl6BrSD3aGaqvqJVlWn003hlakw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PU938sBDE+AAXDYhDH8O6h8m+KscBhDLaU3D7XkUd4=;
 b=ul5IGMNQVoQNgdaoX3+/nwFaj3P7RihTAooU3rSLjtr11QfCqJ16bRu7RSM4R7L+VsOm+JRrYBWJXA2yLGqn0sB7hmAMqifpnVMWFX+HUJBZWaIaEZUZaIQyfJNEJvkVAyMsk3koYUT1DL1xcdCec9vLunzM2Ex0WLKZQSyFegM=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 23:21:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 23:21:51 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgABgN4CABA0gcIAA/XNQ
Date:   Mon, 11 Oct 2021 23:21:51 +0000
Message-ID: <CO1PR11MB50898047B9C0FAA520505AFDD6B59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
 <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB5089CD14E6293B8024202726D6B59@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB5089CD14E6293B8024202726D6B59@CO1PR11MB5089.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5935b8e6-0826-4f7d-dfa1-08d98d0de834
x-ms-traffictypediagnostic: CO1PR11MB4882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4882BD83C05CB9352D27C5A2D6B59@CO1PR11MB4882.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gBJTeJsyuVs9cpiP+NCjkkLBFHk/3Hbu1wq8S9e15GMaeTIC6lKIOhMCzg1yi/KpazfwYtPv2mJ2yZxjQlx67yG4w0nJ2CxXr8I/uloY1YgN1FQQZ0wfy9tJln3Ke46/oyytqarnB9XFG5uCXEOYcF/DsQmvwzYyiWGZTI8SjzA6Xfp8aLikQueeafzvboaPX+S2dAcpWKAGnP284tU0t3m8egLqD7w8NHOZo1O30j3m1kCOteeP9UxejCkJhbJ/CYmjGG+2hWb4xLlvw5kvdCM3yQopFW4ta0kCF9SHwFg9ZtyOx217Wg1iZlTJUVPwLiCkq/qY20ESbaTCpnoEQGJFB70Q6P68QEVquzWVs7vKHQ48TR85WzZzoYa3/Tx3Q2w3pcT8Kd/GRW0d66QCeQcMkQQ2wB8HlFhGEyxkrTU0toKhf6uGQWgri+BQLUedbDfgJIGii8ziKq04BggOhn7BxDksYnr2fXJ9vSJLNL2vB2QY78SkaX+sj7mQaTo95VnhMIkGVdd/Ti7Eg+KMjo9XhoH+rAOBtwywUcNa8dstWyqPZyquNdCVeHy2T7Cg/DOLooXAqlg/AkyXGgNjPyw/IiBPZBg7IRi+AuVwSFcCMuIhhtjJaXi5lljnSGfFhc3HNhCmGqtQULGM5oeWFvYOW7YzSRAw5mdCmlgfJfnSkbMMOim9JtW4sISAqC4J0wuY1sWi2QYFXGO1FoA1KC/Zh79a0Ca5h2e7cPtla+q7j5zXqu4eYIb1XXwina20U81ns64kN8yjXNpi+Fbs/unsKzzCaWDncEeWfef2PI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(66476007)(66556008)(66946007)(64756008)(66446008)(83380400001)(2906002)(8676002)(71200400001)(186003)(76116006)(2940100002)(86362001)(316002)(5660300002)(9686003)(55016002)(38100700002)(508600001)(110136005)(38070700005)(6506007)(53546011)(4326008)(26005)(33656002)(122000001)(7696005)(52536014)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4r/Bflf8IWIABYhOLgXgPG1IVhOcpLGKI5gQBmor440IG6410NNyezpimPmi?=
 =?us-ascii?Q?4MMJ2WF4Tw76XNmPaV9u8aHYX3HYJkDHQ2XzWk0TOZqMG+X8DweBKAbX48hZ?=
 =?us-ascii?Q?IkUCSS3o/5Oy1H5tfJZRq/T+T5LerO0384tizEYHZotDdvMXYinnhMlAYhf8?=
 =?us-ascii?Q?aRua44Z4pZT7DWLKwyZDOHNQcUWN82/QVJKJwG1OHn7nYTkFITJQNROsIgJV?=
 =?us-ascii?Q?W3cywXiXVe6MTjq1Rch4qVFhHB/JdJviunwnvC/NN+h2aS5o0fQ+djjr6ETN?=
 =?us-ascii?Q?rCh9UfLAABMiDcKT4cM25q8jOQLOZOFPjBSnJmFSsZlvHkGxjngP9Vlzp9IE?=
 =?us-ascii?Q?t6bp14mO90o1Xflr54OuYhhFno2t77+AJf0xArDqTdy9PBlADCzO3fdaWAsA?=
 =?us-ascii?Q?FD2o+3OC/0XVTIY93Dyb93fPS24ReQDhKZ/Dm5UdrEOh7ttdN1F1TvrcP1Y0?=
 =?us-ascii?Q?HTnHjt2mUa0mlajMKFR+xDuKBFKSbtLWjCiSc8QFXoMbzoFhkjnT89953Bo8?=
 =?us-ascii?Q?wMjFyoCoYKijBHSTWUOoxAbki4I5PwMuCdgHgLfSQBrOKk4FLentd14hIlIY?=
 =?us-ascii?Q?IRwaqKOfOU5yfkI8vGZ6M3by6pffDwNb5s3pCKTMk3GkpXtRLGRD2e0YdgQr?=
 =?us-ascii?Q?gCFNsAB33ziPbwC59r6+XfXMr4BgM7Nd5EShT0LXPC5DdXWJT/YSCH2caouE?=
 =?us-ascii?Q?XLrf78mUD+M6hF63VVYn8bRdTlv6XtvqvvpK6uziI8iF++4Lx292ZQH92yux?=
 =?us-ascii?Q?TVk0IVGUwRg8zX4hizkVh/Y4dE08/o+KlLSk0eNG1sv97lf/TYzF8DGwpqu6?=
 =?us-ascii?Q?Su/hlfImu2qVsEHmf7p+KdJXYBDO6hWSDxz2YqMncK9jeSyglrcfzP4S7NSK?=
 =?us-ascii?Q?7RB7N9OpMyitRK5rZt8YONWh8wUTKHry6zUpid3Ze73VRMcTpTh74lrb9hoJ?=
 =?us-ascii?Q?CdHG1QHq2xzfAGPXGEH/6y0eCyCIZsS4VbMfxlXJJ86olVDinUI6TKjw2MpO?=
 =?us-ascii?Q?Y0SOWh1gGAcRwvlmVSbvq6OjxSn5BtxlOyx36ermfRcagxNUVIb8U24ndJlz?=
 =?us-ascii?Q?zVL9dKk/bY5+IYlnx6iAsw/x2bBs4/91vbO+q+QtbSIQWGixl3vL9xzE93CI?=
 =?us-ascii?Q?HRhZMq2BlU+vaN6zFLTWbtQ4XGwkR1E8B2sr41fSN8jpPLPdmcgSX6M0Yn/c?=
 =?us-ascii?Q?IiTpPDdk4a258ecJYFtyQHEpawxDSjoMLnFpc7N9lha6EeHzvRLpfcTkE5TH?=
 =?us-ascii?Q?B40eqbwdibgWes6zQQeDmkwLcK975du/k9BtoyV2RlX+MwOCxHxIjLoRYBAP?=
 =?us-ascii?Q?eBs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5935b8e6-0826-4f7d-dfa1-08d98d0de834
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 23:21:51.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eAfOcASZRYUr4A0m7U6AHaCNouvPaWC4soL3mIPdl5s4lMvAMJuSLDlTDqQsgPf22IagE42eVusnoQu3NagyKZ1Qia0bcPCAZuS2NEPazXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Keller, Jacob E <jacob.e.keller@intel.com>
> Sent: Monday, October 11, 2021 1:22 AM
> To: Jakub Kicinski <kuba@kernel.org>; Jiri Pirko <jiri@resnulli.us>
> Cc: netdev@vger.kernel.org
> Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, October 08, 2021 11:22 AM
> > To: Jiri Pirko <jiri@resnulli.us>
> > Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org
> > Subject: Re: [net-next 0/4] devlink: add dry run support for flash upda=
te
> >
> > On Fri, 8 Oct 2021 14:37:37 +0200 Jiri Pirko wrote:
> > > Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
> > > >This is an implementation of a previous idea I had discussed on the =
list at
> > >
> > >https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.=
co
> > m/
> > > >
> > > >The idea is to allow user space to query whether a given destructive=
 devlink
> > > >command would work without actually performing any actions. This is
> > commonly
> > > >referred to as a "dry run", and is intended to give tools and system
> > > >administrators the ability to test things like flash image validity,=
 or
> > > >whether a given option is valid without having to risk performing th=
e update
> > > >when not sufficiently ready.
> > > >
> > > >The intention is that all "destructive" commands can be updated to s=
upport
> > > >the new DEVLINK_ATTR_DRY_RUN, although this series only implements i=
t
> for
> > > >flash update.
> > > >
> > > >I expect we would want to support this for commands such as reload a=
s well
> > > >as other commands which perform some action with no interface to che=
ck
> > state
> > > >before hand.
> > > >
> > > >I tried to implement the DRY_RUN checks along with useful extended A=
CK
> > > >messages so that even if a driver does not support DRY_RUN, some use=
ful
> > > >information can be retrieved. (i.e. the stack indicates that flash u=
pdate is
> > > >supported and will validate the other attributes first before reject=
ing the
> > > >command due to inability to fully validate the run within the driver=
).
> > >
> > > Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> > > really dry run. I guess that user might be surprised in that case...
> >
> > Would it be enough to do a policy dump in user space to check attr is
> > recognized and add a warning that this is required next to the attr
> > in the uAPI header?
>=20
> I'd be more in favor of converting either this specific op (or devlink as=
 a whole) to
> strict checking. I think that most of the devlink commands and ops would
> function better if unknown behaviors were rejected rather than ignored.
>=20
> If we prefer to avoid that due to historically not being strict, I'm ok w=
ith a
> userspace check. It does complicate the userspace a bit more, but I agree=
 that
> especially for dry_run we don't want it accidentally updating when a dry =
run was
> expected.
>=20
> There is some maintenance cost to switching to strict checking but I thin=
k it's
> pretty minimal because the strict checking simply prevents the unknown
> attributes from being ignored.
>=20
> I'm happy to go either direction if we get consensus on this thread thoug=
h.
>=20
> Thanks,
> Jake

The ice changes in this patch conflict with similar work that I posted on I=
WL to cleanup some things for devlink reload support, so I'll probably wait=
 to re-submit this until those changes make it through IWL and onto the lis=
t proper.

Thanks,
Jake
