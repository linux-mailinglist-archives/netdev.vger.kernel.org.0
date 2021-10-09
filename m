Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6614274B7
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbhJIAey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:34:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:64973 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243965AbhJIAev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:34:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10131"; a="312810126"
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="312810126"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 17:32:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="657981708"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 08 Oct 2021 17:32:53 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 17:32:53 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 17:32:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 8 Oct 2021 17:32:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 8 Oct 2021 17:32:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlMLVFhdRZsyVPvu5dbegs9u/mKT/iYIaSwkcmF1W0QIory08zihRtGFyM4niRuN65Iqs/5erPS2M0REQbz2OeZFx1iaG+opqLEfif1ssux8c/5z4UPTjHBrVP2bBLilEGzG2CgBBVZNFWPMc8bKwKCIo2I9nRqb4aM+ZtUQZ164orDQPMCJZMyp1mjAKrFSYqxLXEwNB3TdrKVektq7Z6FZwCaGd/ICeC00hnNs808z1xuMYENQ3vFZ5CxPA+n9OEVxwvK/c2y6QDt+m2EQT7PH7iriVhJZVE6mdov2ku7/uBcWdSVbA5cc3PXv9ilV1/NNLU98BB12NHE9JnjATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nAbxm5Tz55nZOKpNiQB/rzDpT5lR89+Y1v1sn/QG2Q=;
 b=D24KN0GUpc/jHp5OrUxoQGf9BodujnbosjbbYg/9rZZPuJo8Wo85Hecza0C4t7D3CO+AIG9HKVnpWiUadwiJd75ILZynv5XbSy+zuPIqvoFW392p44Q6TakXWKXI+Qcrxu50RksbT5xU8sSHzhsCQJxgxTA9oL3mw4fTSzEgmtCnYk/smUc0HM+Uhj8On8Kxhu5un2ThTnLholG0zFXSga+i1lFRe2XPCWtH1gjyqrFOWEUuVKEnp8nPvBxgIMqV2egnV2P4nsuQB2OaUghal8N64HJOiN1lbJed4hqTYMIUCMncibbnK9r6snZCEDaLRPUA8wc7JBCQtvdKgucexA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nAbxm5Tz55nZOKpNiQB/rzDpT5lR89+Y1v1sn/QG2Q=;
 b=lyhknlg1Cr+i3xvhY/FGzfxkpqnDy8wWL293wOp5xkzHaUw2i+tT7BZdD/2rkRe+JC9uXwXxqVuEzKRoaCk4dlb2Y8+Qp/IG4O8aaqghYInzrU94T1rYH58sn0/i0x3UaH89h0tpIYtOjoWtRdM4VDSwAH7rfMoVWjk7doSrXlA=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5155.namprd11.prod.outlook.com (2603:10b6:303:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sat, 9 Oct
 2021 00:32:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8%9]) with mapi id 15.20.4587.024; Sat, 9 Oct 2021
 00:32:50 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgABgN4CAADgc8IAADsAAgAALbUCAABEsgIAAAetg
Date:   Sat, 9 Oct 2021 00:32:49 +0000
Message-ID: <CO1PR11MB50899080E3A33882F9630C98D6B39@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
        <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20211008171757.471966c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008171757.471966c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06d7fa8d-4c90-48a5-3d84-08d98abc52fe
x-ms-traffictypediagnostic: CO1PR11MB5155:
x-microsoft-antispam-prvs: <CO1PR11MB515539EB71AA36929F220284D6B39@CO1PR11MB5155.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikSSgyY5VEktWx8Dhg3uTFAnFaeyKipRGbhT4t0GQVDMzpycOqajM2o9ebA/n8DRcSxu1wLSkjyt94ftGLeQ8Q115KmPDn4EJgzVeHKN6sLjWVp2xbPvR3KC/EH2UJ/5yLROihO7dVqOeOQOiH9X1tXqdvblw8vQutnIwJHieAwznYFGByo4XP+zuN1itAThtGI9rvPdqZpzpru7HOhIs2E4S5mnhObw4BP2siVjsvH0AkZjuHEANpVfp4hXUANLw12bsbKAOWMFHjRx4r7pqzKbu6eqPqLlCBGXHNwod0PXCz+zhQ2cPRNr1COjN7ZTPBLUCJcXmYKVMxrVBzyzSPeyDY2b0m+VxoO3/YX639WMRaljLCscxq5VAGjVtxN5F73SGvtGES7owo/hg87TO/Uo6+6gXVjNaNjaVeR8QBihCK5D+XFA3N1ppxjCCqD5rUaYyub0bu08NEtXVtZmrSRF3dFh7xxc39KzQPctiKF0kT1605ki9AF9tISX6bHAxZmD66Yfi/Ft9G7/CbWEP/Jt8h5JqY1fWvDoTZICnG/Pdu3VpH0ws0WluhCbasj+ftqFcs8paT7deU/893fNei+rdUG6K1Bnm9G+nUPxDka83z625nl6Y7pcf9L3mob560Kb+OD7zxCn07Prj/SGKPxX8bNF1IJ93nwz9A/nOqb0MScJ3DeweNZ77OMy3+RaYAiuY2aw6PqhBcsCtWBPKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(33656002)(2906002)(66556008)(71200400001)(66476007)(186003)(86362001)(76116006)(83380400001)(53546011)(6506007)(55016002)(54906003)(4326008)(122000001)(7696005)(8936002)(9686003)(26005)(8676002)(6916009)(64756008)(66446008)(66946007)(15650500001)(5660300002)(38070700005)(38100700002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pWs81+YA7Ohn3rSIoZQSDPZvdsVbfLyJsGCy/M0YkKxVGpWRVjeDqTTaJycD?=
 =?us-ascii?Q?Q+FvpsyewOG8obdCKLglKNJ21CAMbV9cNjGffawAMQlgtzyniQtt6QhTrqzn?=
 =?us-ascii?Q?G949uyPpNMw1froZNmg5FxuwXWkYO9RRMl/1Bq5RJdQnC3eMtaVC5fH7wZkz?=
 =?us-ascii?Q?JVpukaPYVdVqO2dbmZusnOG2pmkyETUkhcEmPsJjvb6+uAMbhOAqmRSvfzro?=
 =?us-ascii?Q?ick3NZpC7ureFovErpXcUR1cpzq8vD3OQVT4uQvhsMA8slBWVftOmOOkP5iS?=
 =?us-ascii?Q?NeqmstbcR50NpaWj21TkG2BJbNZ8TykPvVCV9hH9mpToAUs9gBH2rMoVolmY?=
 =?us-ascii?Q?5W4oOLZzVQC0th0SBlnmV7dt/RpnI8qEGALBzwiJ2nu3QGDgIbFPHwLPrQxj?=
 =?us-ascii?Q?rN4GuMXg3vOfOiUUh664goUwlIb6WtqDY/ZNZNSCa9Sg2PY4+G+Yu5M8nj+L?=
 =?us-ascii?Q?+wOGd3hIxq7KcDw11qeglDcEw8nMyXbU/jSp1o53GL0cqG/1x+9lDfSz+NMu?=
 =?us-ascii?Q?iRcFwH20ba01X3eQ2hP1uGpksJ421IL22gHFT0402GN9qGshw1NOWCkZxwfS?=
 =?us-ascii?Q?6JynD+E9JShslmPJRaLzRdlDlhPDa3Z4/SuDto0r9rB6XwYY3/fkG79lNv6w?=
 =?us-ascii?Q?0Pm30CXY2HoXgtVSJOpHkVkAyXVm65UDrJXi0+g++qzdZo9vClyWP5hTLVSa?=
 =?us-ascii?Q?Z/o0QTCwsCcwcbgY0XTVEFESmcHwJFlP9IBpYJHinV2i8rYatyQD5lEfHXJ6?=
 =?us-ascii?Q?15/1wQFSx7bDai88frhNQmAOdbfo7lZT7G6+fP+SA9oVmrIS4Sm50G/R0cP2?=
 =?us-ascii?Q?U//DJEcQmvYZr7UlwGC2Sd4zqVbp9pJJdES8Z9EHusaQthj4RRfFNKGIuDZW?=
 =?us-ascii?Q?pvE29o2msszi4AyD9ccJFtk8ptEamZ9kxT14jnD9sem/pk0HdKHcPQowZazo?=
 =?us-ascii?Q?owtPIpDE7rfMne674ds9xguvx5CtPBw1qeQafqhoVA7F81s/AmHeDPFgj7Tb?=
 =?us-ascii?Q?y4ulSW2FzPXmVWRAOPJw/ZtbElUouCSIOxso90rUOMlzjsbdbKjhNVgKFQuU?=
 =?us-ascii?Q?YSS50cuoUNWe2MBsSrAx0BsQ+PYMF/fUJRMtZHQtcNrbGohxzUbUT4rrnY9Z?=
 =?us-ascii?Q?tBCa17Ebq3E2HF8Rv35HA5zUbSxlYMtmcPeD6oZKIpiHLHOAMY84E/EFbTpS?=
 =?us-ascii?Q?X6hdFT49Z29au3JeQxUhf30FG1C5RTsBjMb3SjvJsPk/lNiFy4Fr0BTj4egx?=
 =?us-ascii?Q?VHy+NqvkDhgmSfmW0XwDq08j5O22fkq1+HxPToF4XW6gGRKeuUltzcQbyPt4?=
 =?us-ascii?Q?pW1g5i7+7m1KGjr2Sj7JjRYb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d7fa8d-4c90-48a5-3d84-08d98abc52fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2021 00:32:49.8921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2pYWjUgBz/q2ZjRy3bcaI5lIKNq65kSGrypWRFg32DDpc4Ux17ci8yvTozYj/dMKFPh/IvFjrqeYozBwa33fJvJZQiwLtNvoZ9GFIXvG4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5155
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, October 08, 2021 5:18 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
>=20
> On Fri, 8 Oct 2021 23:58:45 +0000 Keller, Jacob E wrote:
> > > > Doesn't the policy checks prevent any unknown attributes?
> > > > Or are unknown attributes silently ignored?
> > >
> > > Did you test it?
> > >
> > > DEVLINK_CMD_FLASH_UPDATE has GENL_DONT_VALIDATE_STRICT set.
> >
> > Hmm. I did run into an issue while initially testing where
> > DEVLINK_ATTR_DRY_RUN wasn't in the devlink_nla_policy table and it
> > rejected the command with an unknown attribute. I had to add the
> > attribute to the policy table to fix this.
> >
> > I'm double checking on a different kernel now with the new userspace
> > to see if I get the same behavior.
>=20
> Weird.
>=20
> > I'm not super familiar with the validation code or what
> > GENL_DONT_VALIDATE_STRICT means...
> >
> > Indeed.. I just did a search for GENL_DONT_VALIDATE_STRICT and the
> > only uses I can find are ones which *set* the flag. Nothing ever
> > checks it!!
> >
> > I suspect it got removed at some point.. still digging into exact
> > history though...
>=20
>=20
>  It's passed by genl_family_rcv_msg_doit() to
> genl_family_rcv_msg_attrs_parse() where it chooses the netlink policy.

Ah.. I see how its done. It's passed as the argument so you  don't see a di=
rect comparison which makes it look like there isn't one... Feels like ther=
e could probably be a better abstraction that was more readable here...

Anyways. I'll confirm what happens on the kernel that doesn't have the attr=
ibute defined at all.

I wonder if the thing I saw differently was because the attribute *was* kno=
wn but wasn't in policy. I.e. because it was defined it was validated....

Yep, I confirm that on a kernel without the DRY_RUN flag that it would allo=
w the run because we aren't being strict.

I am guessing that we can't convert devlink over to strict validation?

Thanks,
Jake
