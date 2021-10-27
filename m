Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE643CAAD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhJ0NcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:32:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:27294 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236324AbhJ0NcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:32:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="228910134"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="228910134"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 06:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="497864620"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 27 Oct 2021 06:29:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 06:29:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 06:29:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 06:29:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fE2AxEvD89gpulRFanjPKU4FtYHAwfPASpORYDXQuqeNZ7jhOXKF0KAusK5OWeAvNZkpTTnxDTqGcadCX0T2Cp6W5eGRKF34UIYD7dDB/0/R/rdqFWe7SIPRTA+Lv3ZFsVAYG/mMUYCTpBS2DuGPAGxr2l5i47EBkTCZSuyvMBzi5cZmRS9xbC8m7oPSbd2EHGsw9iGcVWqnAFMBjiscEB+une9SlLBafxlRRQs7e3Hieb3BaC9bmQCVw6odPc8R9T28ugPi0ac/+YkxbHHvX16ekwxpSg4tv39BDlqAsZnVVSV19t8cuZCOcRvhtNjYr9w27+DYDOtMElLsvJcaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSk0XhH68Z+eg4RkgqgY+7X0yqbL+azvdqyClt0ZWNA=;
 b=ZTea/wzFPGA+I3r0ikyBXW6Ed/778SKk73LE7EBQSJjBN12zWEkSythH1koOuG2qH+Gz8Da1WRaxRzIOHMl/j2xXfeaRscP9HiHJQPnKkN7GS66MNri25F6PDx+ZLRABnyCeQvhZfrI8v1+i4hsT6HDcRD66M0SjzT7+wGmnlCw6EcyISC2yqnINStwqIHPkDXS320ncRzsB2m9cfT0XAWgsxC3w94kg2QAxCMxNvb2OXYdIufkve88qglwSMNJtZoeMFIJH20cTBSKaDH4PTzRRE5xdTlucyZuWRcQqly4FuVcgahVd90HlHwU1T86z1iSHEw/VD4Ri86nwUS3JWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSk0XhH68Z+eg4RkgqgY+7X0yqbL+azvdqyClt0ZWNA=;
 b=BGuouFKjOKs7yvLOOc68OXM6jj6rc91P1lhb6feE0kkG/JXH9rQFIj4Dj1jspNwRLmN3bFXDkb7o1ZUL8/0fOFqrpbMB3IysEXN1Z1JPF+4XlXRbYXtm0S3RnH0sC3D7c+YHuaW0Nkz0xQ00st8pU+WVa7SjC/Dsz+ki9GDByu0=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 27 Oct
 2021 13:29:40 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49%2]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 13:29:40 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE recovered
 clock configuration
Thread-Topic: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE recovered
 clock configuration
Thread-Index: AQHXypF/RRJygJEUHkKdcLZJMnj2hqvlzNkAgAEJThA=
Date:   Wed, 27 Oct 2021 13:29:40 +0000
Message-ID: <PH0PR11MB495117F04EED3A5D56AFB527EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
        <20211026173146.1031412-5-maciej.machnikowski@intel.com>
 <20211026143236.050af4e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026143236.050af4e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b5ac6c7-e54a-4bab-40f9-08d9994dd48b
x-ms-traffictypediagnostic: PH0PR11MB5064:
x-microsoft-antispam-prvs: <PH0PR11MB5064665062DE331B919BBAC7EA859@PH0PR11MB5064.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cYPapaK4CjRidOH0DqYA1gSpiZPFsfcPb413+EnKuNbk8Fu3SUhpipzveI/eu+FczwDc81RRiIlql4gWW0oOKmWANGnCcYR35VxcYRGHGvXvDm20FoTJYYuzLsjJEGfPvwfywDfD+pfoVgjPCM6K5HLwk3TiBWKNXSUM22HnRwrXehPuADMLOxPIM6I94x6aNYQ4AyXRh6qROw0DiPFnyjDEMzhQ1CBCkdKLzoGsG6gfFPoFrBN0xHUuZFl1AwzSe+f9JiBEZYl+TnWCDnbAMbjFewv07w9LltDnNH9Bb2GZeumkmxU1nJS+9ENGzyu4IUxBh7tijnCdhoOjpVh4TU/i8ujQdtugTvLIcMW4kdBj1kLftNy6pcB8E0H7jgMAzs9L1qMoZ/dWOB6YTuya06ROt+1XU6JIXpq+Gx1SC7mEpxeMUGV30GP6eodnP2j+LdBp3QwQDG5LWKFjub/Z+Z+LQl0F+3C8iAkSjsuJddEson+DwHIS63fHHvq0OPZ1RYU6PD5UO/h4mHWZaQ/P+FEEC8JDQNvMBGHOsr39NIG0rwKKEiSeEzMQpwr/sRjJGdZXk0gUxc+2AWPNpcXzZCdkI/yLAPubsLiSe/TqpDFYclxohFrQuWFXJ0GYDQPeF59eDagyxj51RIbiaDjMcerSzqZcT1Ak9rr9tcjrlQr6PBel15P2v3f3s4h0Ypd4Y1XS+a1ogy5BC0KmA2aV4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(4326008)(55016002)(52536014)(83380400001)(508600001)(7696005)(26005)(2906002)(33656002)(9686003)(7416002)(5660300002)(82960400001)(38070700005)(76116006)(38100700002)(6916009)(53546011)(8936002)(71200400001)(122000001)(316002)(86362001)(66446008)(186003)(64756008)(66946007)(66476007)(8676002)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FY6v89Vq6g3pT6PxjxRFZ2vQJbPK7Il3pVVDzZ0wDGHI3hahg//m7sa/rCFv?=
 =?us-ascii?Q?Q/EOrVUXRsmqVxSYKPjTUmoZ470iLrY3WWthaIfCH/WC/Sbpd7rWYtz+Zskd?=
 =?us-ascii?Q?nWKoKvmOPV3giOAHbnoofrZKZOHJOGKJt9E92WQ6/MKHTlFkhltf80vmyESx?=
 =?us-ascii?Q?K3OV261go8WkI0ST5vQzI1HNFUpM9IiGM0xTch0DnPd46DY6oRwCvECV5jGQ?=
 =?us-ascii?Q?9plMN+B80C6lWm/POYo181VAMdSmZ8sv7elfOvbAyyCLCB95MhDfXrpfGhjQ?=
 =?us-ascii?Q?LyhzOusGMle35zYReIsAU427inYoin9HcGW4tEk2DN1na7iAhq8U8EMXr859?=
 =?us-ascii?Q?vuYV0vufVjUHKl0YXdzZakUDlyw5mcb5cRVVT8jjjTNAwJsSXmL/X4ml2Fra?=
 =?us-ascii?Q?T/rGFRBO090ZeCmB1BvS0HHXgP5l91jV7eL54lUtnOml9UXjjyIQ8d/geYXZ?=
 =?us-ascii?Q?TPj8a96tzR47z5zlRCP7gnhxiEvCINLtpRhJAlx7SHV7eOeCYk7ttbPlFqsH?=
 =?us-ascii?Q?K9Aqb51S/VG2OtHi1TcV5cA3x2/Q/qMtqqtNp9x8X/WmsoMtvH4GR4EiJS+p?=
 =?us-ascii?Q?gXDl6TaEVCLa0e66udIF0nGZBZujkxMR1lGwxN/uvS+pob8iU5LgQDqTWjSE?=
 =?us-ascii?Q?8Aff7/DxK5vRuW+BhvPPfPiUFa9nQHHwPttqibhBxY6H89ebsrWy46I4TyzI?=
 =?us-ascii?Q?3g5KZCfgsplWQirkGM8y6uGM/ChzA8U3H/smT5DuZE5lqtQzaXcH+0eVm0jw?=
 =?us-ascii?Q?nYc030M2xu7uJDrTeGR0bX0ik6iorCQ/TDSYxmbnUT8qYQ031KDAEo90VuKN?=
 =?us-ascii?Q?9WwW47QZos8jiZjmnnpef4qj1vzg7JypPlTnLox2m9IiS+iXHo2t8xOSCcyN?=
 =?us-ascii?Q?ERYEQOqVWfbvxVbQu+XCQqkXIngbeylrNE0WjbA3+6057Z6pIeCC4nwN6t1S?=
 =?us-ascii?Q?BWBIeHRdLpnjwixT1z9PIW5QM+4zF5ITiyy0v1HXXlt584zTvirGB/KBYZyk?=
 =?us-ascii?Q?nzzaF3HQGD95tz2I02TfBGfS+UuiXfGWXC/APmceP7GXvEKs0BAH+gfGLeIA?=
 =?us-ascii?Q?AfKO+aFEDAv+VT6OmFbHogxT5MrgeYW0QDZiRaYZ/jnHkasy4w44haySoqn2?=
 =?us-ascii?Q?Mne06dmE4O5b451Nlk9gK27p68HjsxAUX/e2Oo9fW9oY5pTj4lm6xdVvctY+?=
 =?us-ascii?Q?hH9ULTtatji9e2vohZGY1YgQIHWBVI7dysK3tkRHT7ZBVAPtIWjF+9iUTs+y?=
 =?us-ascii?Q?WpnJ8QNxIFWWNH6JQCslu3UXeY7/p/PH8dFxEuuWnzI3iC5k9l3V6UpzGrIF?=
 =?us-ascii?Q?rpJ8cKsrdAaq/qIggIDt5n22T7/vZsQA9Ax7p5DDut8HeM/V9bzLUt0HofBC?=
 =?us-ascii?Q?7MqfDiv08Czm/sU4k2DROWH+9X2eqcDGZt+qSRsZGy7zgh/WUNceC+3bbO7o?=
 =?us-ascii?Q?qK+eo/kIL8P0Ua7NPUjUb/Lu9l+nfH65SgCkyDEM/fzbeH7zeV5ITDaK3btp?=
 =?us-ascii?Q?eKiOqZoXaPDTfQKlsCZi70qq/dinbIZQkoNnkBJbQcreF5xZJx+B8PzW3I49?=
 =?us-ascii?Q?/Hh0xUNaFLBFnNcaIhtPc41+sRONRjune8UUilpbkdpaYPg7MjBKq8la9Hwo?=
 =?us-ascii?Q?wcXseN+bd9JTFsE7aGLxOqmKiyMx87sYqOXgtKLtUaBhymI1FNZaF5h6MJBZ?=
 =?us-ascii?Q?Z1QHzA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5ac6c7-e54a-4bab-40f9-08d9994dd48b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 13:29:40.5629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w9nGgTopUW6CP2MXzcw9C8g8Ry2jT1zoEb+YGpxNzdHYdU9YJjcbCYArkyogPsphQvwFa9tXe+bN/fUoBg5WPbP79F2cnKSiWcu3/2MRnkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, October 26, 2021 11:33 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE recov=
ered
> clock configuration
>=20
> Please add a write up of how things fit together in Documentation/.
> I'm sure reviewers and future users will appreciate that.
=20
Sure! Documentation/networking/synce.rst would be the right place to add it=
?
Or is there any better place?

> Some nits below.
>=20
> On Tue, 26 Oct 2021 19:31:45 +0200 Maciej Machnikowski wrote:
> > Add support for RTNL messages for reading/configuring SyncE recovered
> > clocks.
> > The messages are:
> > RTM_GETRCLKRANGE: Reads the allowed pin index range for the
> recovered
> > 		  clock outputs. This can be aligned to PHY outputs or
> > 		  to EEC inputs, whichever is better for a given
> > 		  application
> >
> > RTM_GETRCLKSTATE: Read the state of recovered pins that output
> recovered
> > 		  clock from a given port. The message will contain the
> > 		  number of assigned clocks (IFLA_RCLK_STATE_COUNT) and
> > 		  a N pin inexes in IFLA_RCLK_STATE_OUT_IDX
>=20
> Do we need two separate calls for the gets?

I feel it's better to separate the "control plane" from the "information pl=
ane",
but if having less is better we can merge those 2. Then the GETRCLKSTATE wo=
uld
return:
Number of active outputs
Output indexes
Max allowed output range
Min allowed output range

Since Min/Max are usually only needed once (and may require some FW
Interaction) I'd rather keep them separate.
=20
> > RTM_SETRCLKSTATE: Sets the redirection of the recovered clock for
> > 		  a given pin
>=20
>=20
> > +struct if_set_rclk_msg {
> > +	__u32 ifindex;
> > +	__u32 out_idx;
> > +	__u32 flags;
>=20
> Why not break this out into separate attrs?

I think it would break the functionality - we need both the index and the
action (ena/dis in the flags) to know what to do.
=20
> > +++ b/net/core/rtnetlink.c
> > @@ -5524,8 +5524,10 @@ static int rtnl_eec_state_get(struct sk_buff
> *skb, struct nlmsghdr *nlh,
> >
> >  	state =3D nlmsg_data(nlh);
> >  	dev =3D __dev_get_by_index(net, state->ifindex);
> > -	if (!dev)
> > +	if (!dev) {
> > +		NL_SET_ERR_MSG(extack, "unknown ifindex");
> >  		return -ENODEV;
> > +	}
> >
> >  	nskb =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >  	if (!nskb)
>=20
> Belongs in previous patch?

True - will fix in next revision :)

Regards
Maciek
