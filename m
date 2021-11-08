Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7F447C78
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 10:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbhKHJGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 04:06:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:9101 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235592AbhKHJGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 04:06:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="255860025"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="255860025"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 01:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="491139336"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2021 01:04:00 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 01:03:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 01:03:59 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 01:03:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrsFuoXnlrHpsVNOtfXLteXUasBRj4jSqlhDfdNxSveLOzaOm6lq6NPhqzpwqB50UYO8DOILE0aNNHLWJa2T/vg3cpxYCuMVRsoQOcDBKoXYcfk9BFFFNoh++NFdLFMHV8mosojnHnMn777E1jkf6Yf8P9c06dGEqQEXu4QQchwINFmRRwIId85aAAyLfW1BD6H8InT59zJWxWWIbGgISegpuO+FTVic6BL3xwdoBAFBl18nWXbm+l0fbxPHiwJOJcQ6/iRxVKPhsrF5N49kvS8eRJGj2W8aho+UKkxbmgTQuHPni7jYmC/+SuPQsuNol1l9oqutQABpFaZ71Z4gSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSvKiwRdPpaUn3YyURhJpe56SKepG2UyXj/Al8819FA=;
 b=YbxehmqAhyXuXwhKHluRKO+SODoP2BJlvqCIN3k3ZYPL1NQAIj/x9PbOrpghytQlZBxwmXLSr2/l9/fPNTDE2gl8rkK12WPIxowzc200bPT1yEY2qSde+yM25meuVmj5tx3NgZAiF2/P5avXtmgM7JCG9wFhgp+yIanYF7f8bKIZZ+7rLqFxj7x13sUhM/plKTUYmU03XbIg3vphe8CYjy/ffBuSdvSXIh+2aMX/CvxRGviucebs10cAKyzvvCxPIY74qkSonyawZ4Qllof/fCLKcnHBTZBlyQr6HClzzol6dJ+ai1y6pDOjrbTAKocOQjCERE66nuLNSJx7cbT8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSvKiwRdPpaUn3YyURhJpe56SKepG2UyXj/Al8819FA=;
 b=pf48stli9ARgpWfi7HeLazLI38drLJ5Hqu30vRXJGVQUuzcU6UBLYGe1WwR/XcCA64Qt2vDWHAhvd81Htq/Of1JyBS3bdrQpqA5iVL0Hbdj26okiL/80CTmjKTKdY6E8Rs32jCGaZgVKdwIoOTJ8ku5s0gunWyvmoZ8OvSe/aEc=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Mon, 8 Nov
 2021 09:03:58 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Mon, 8 Nov 2021
 09:03:58 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: RE: [PATCH net-next 4/6] rtnetlink: Add support for SyncE recovered
 clock configuration
Thread-Topic: [PATCH net-next 4/6] rtnetlink: Add support for SyncE recovered
 clock configuration
Thread-Index: AQHX0VXaGVDKpAoRukeJgXEmmkmUoavzr9EAgAEko4CAA05OAIABNvJg
Date:   Mon, 8 Nov 2021 09:03:58 +0000
Message-ID: <MW5PR11MB5812A805FD73E435EF43E9CDEA919@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
 <20211104081231.1982753-5-maciej.machnikowski@intel.com>
 <2d379392-a381-e60a-7658-5ac695c30df1@nvidia.com>
 <MW5PR11MB5812F4FD090FCEA7CD83E984EA8E9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <YYfg2Gty6dNmjp1E@shredder>
In-Reply-To: <YYfg2Gty6dNmjp1E@shredder>
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
x-ms-office365-filtering-correlation-id: 67a8bfc8-979d-48f1-42e1-08d9a296b34e
x-ms-traffictypediagnostic: MW4PR11MB5822:
x-microsoft-antispam-prvs: <MW4PR11MB5822547FA9286F2D6C7114F3EA919@MW4PR11MB5822.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tTFAVgMOFwbYKxA5YBZwGkq9L0kUxnnc2CF90OJHfMrU7cvsSB+WNf0zgGm+v7e42ij4biuL3rJRWQIbcASa3a9oE5IEAHcRt/ytl7l1U8gUBmFdSzk3FwlimDF+biV5wVI1FMIGbCPug7Xeq6a8efNW3X4JDbhT6XX0x/Q7bxjK95NXPXFoy2euf10DhCB7HFgYT+laJLV1J4C9+Y8bv7PkgjYAx9tDQQatKZjAX4iBF1AWX7+qmU0nUTXo8tXnfFl3x7e5Q5PFMpSuGlE0WtqCiMiiJ1bsLZtE4g7imyX8Yo6MufKwJZzhT7mQHFQAbbS3lmBO5AaqdNWZedZ8xKbq6QNgjUidiqxNExpxpd2r5bexA3v0E4Mh4bp3MoU4UUL9ldHP4DwqZNDFBTW7dDsfMnA8XKQVQPsnH+mK4VlWguIN2le2ZOE8EJ4mgDUmWrtxTl3SyRmhiM/sTz9rsar906vRMTdHMgfhdfl5MNWD/37nfHgmp/Em4TPSfnD3yjxDP6quu0AIlPvx88zMmk1pQcEnEY4Dy9fWsb46DJh4E8GDyndXSAk80HsNPBbPus8jnSTf+Y6x5M1AAP4lrHDsVES4sNuC98HyzXQLQGFR1ZtJW0bxnwURggPeNu5Po3ui22REuRwXJx0k3v58B3NfLe+9bwSyPfOW6xnJEgji0pL6u4cWz43hb5riD+ox/ngU7psA+wHZlYa29eJJUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(76116006)(316002)(6916009)(66476007)(38100700002)(66556008)(64756008)(66446008)(122000001)(53546011)(26005)(186003)(7416002)(8676002)(66946007)(4326008)(7696005)(6506007)(2906002)(52536014)(508600001)(5660300002)(8936002)(55016002)(86362001)(38070700005)(82960400001)(71200400001)(33656002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oi18fF7L5R+WwYaUMmauvp+1PT0kyHPTE/VOwd3i6b1o7o1u5vXk1kM4CZep?=
 =?us-ascii?Q?4ucZ8MGOTgMgFSUPJIWnNbg7fDWXjpjNmvji4mod4UspmyqXAt4/XO/AJv5z?=
 =?us-ascii?Q?1fxguH5ptMpE+zsWO8ulys+67CuiphR6QnzFUlz82WO/vrqJyX+iEZZd2Ca0?=
 =?us-ascii?Q?+fHUh3tn8hEuAdX7cfRasjLupI5ZX1Bp7F2gqRjog+kB3OEtt3IYFyH8vCWc?=
 =?us-ascii?Q?bEXkmaRODVIH5QBECI3izxH/4PMBc39sjpurY2OmepWYZ0a9305GLyF6c/mO?=
 =?us-ascii?Q?oTX/Ahc7t3yAC4XvR31Wno8j5MagNWXeLqidkb73FppHoqAW8PBmiHJqSjvl?=
 =?us-ascii?Q?fYrDt+ZNtgtorDZ3hR72IHCRYmJAct3/BS78QSC0WxISW1VIc7X1AlX74b1b?=
 =?us-ascii?Q?pLBIkXCX6YqkQtqwDdP7S5AfkB4JtBHAkpDY7JkKR0bKqZixebn0GokbGU9Z?=
 =?us-ascii?Q?/YE9WEsR7o71OnRJwkPK+872XehICTRngJho2OsWFJnCKPioznqZPS5R5P5F?=
 =?us-ascii?Q?GMYHgPlSJEN9i0eJbxUNFy6ZZWh2Db5rvY2+mQkKTOIehJzKVc+wvKIYpJQ+?=
 =?us-ascii?Q?S70EHUOaSwx/AY3TSFu4ZZQuYeEuX5AQnhLGblbR0d5+FMYD6QQPhvvO7wZu?=
 =?us-ascii?Q?eKg8RnYBA4u1N6QYUaoC/1PdnE6tx0aMNX2GHFSsRraIObPPZ7RSoo5104/M?=
 =?us-ascii?Q?8odsV9V9uvbYBSkyLyif4vxnMiy374IsSgNz+5i946s0we5tANOxOsw+iaiU?=
 =?us-ascii?Q?7TZl5UBmeEafh6Ssvf0rfOQArukwKq9cWPm+w5jbdOMqfNBdbkV0MF8DZrdn?=
 =?us-ascii?Q?ucrus5ajUeaQvdj5ovoVssLEduyx7RlDdo3CFhAzoPv9wYzQPb3ZPPp3WwUq?=
 =?us-ascii?Q?PO0mn4ibKop/m2iz5pJPxU3En1zRQNQpn3B7mocBavX86LztsiYBJyqgYLcN?=
 =?us-ascii?Q?EzP5jYW9CawzPo9oqc7KFmBt9o7cjkB/uZeDT6q4Y0d7HlNvqKD1gXllBCHn?=
 =?us-ascii?Q?2B4z009lJDtlYYNQe3Xql6YlzuqYMnK6PYi/kR0QwHwyHxWOsG0qAx5K87iZ?=
 =?us-ascii?Q?UkUBJB1QWirfclvpUTOJimZpjCpqMPqlepRQn62346wz0EwlH/y70BGOhLsa?=
 =?us-ascii?Q?QdPcscBaNoWGef9WYud1Vf5ZOj9eU4de5hyNW9IeuNAhd5nYj2LNpxVf0JVy?=
 =?us-ascii?Q?TTyfnZO6LGn0TSge2N6Cw9+BS8CUcy0v6gILAbOd28/pZ+E4agW7NOASO4N8?=
 =?us-ascii?Q?X0JaZfAoxEv/Xc7HTWRYpJet5dzTCyVvIBpl0hKtj2teMn1yq5gxhGXovpLh?=
 =?us-ascii?Q?sR22Y1o/n1eJTYZzlC4+6+Rp/RD613EgztwQkwXkCnK0HNTeURawih3iMQ+6?=
 =?us-ascii?Q?jpUZva/DJnSzU/SgfD+8awhamv9SmQc4H2m+/IdoUR06FfKxiq4NfihQdOE8?=
 =?us-ascii?Q?xApMjxCjBjoiqbmyptYPVZac36Ex7Y75dCoGiaDmsF9cRDDXzCUHuYHJz+A7?=
 =?us-ascii?Q?NyrJZ3vuRcMvX11gd4/bgWC1iwELNL6ZhfOx1QHNDL6xXqRptmlvOuAS5Iyh?=
 =?us-ascii?Q?S5OyvLoC/xHCJm48Cq4QUoD8OZD3UA7BiCpmwmAmA3Ll1CqEI7B8zYs975kW?=
 =?us-ascii?Q?1tddr0pYGt1I+WYJH/oAZqvDScSNdqezIRNX/aA87v95xLa6USb+5qX9uE2Y?=
 =?us-ascii?Q?xjI4ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a8bfc8-979d-48f1-42e1-08d9a296b34e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 09:03:58.5923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8k9t1yWC71tqgwdbP8/+vJF8l09wJw6kswZyLWhZM6Y41PyIA2ny1DDKBoib3VLX8W7RJ/6m4nfm4mYM7n+ZLyefjoBGTm5KxzawNRzLkjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5822
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Sunday, November 7, 2021 3:21 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 4/6] rtnetlink: Add support for SyncE recove=
red
> clock configuration
>=20
> On Fri, Nov 05, 2021 at 12:17:19PM +0000, Machnikowski, Maciej wrote:
> >
> >
> > > -----Original Message-----
> > > From: Roopa Prabhu <roopa@nvidia.com>
> > > Sent: Thursday, November 4, 2021 7:25 PM
> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>;
> > > netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> > > Cc: richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> > > <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> kuba@kernel.org;
> > > linux-kselftest@vger.kernel.org; idosch@idosch.org; mkubecek@suse.cz;
> > > saeed@kernel.org; michael.chan@broadcom.com
> > > Subject: Re: [PATCH net-next 4/6] rtnetlink: Add support for SyncE
> recovered
> > > clock configuration
> > >
> > >
> > > On 11/4/21 1:12 AM, Maciej Machnikowski wrote:
> > > > Add support for RTNL messages for reading/configuring SyncE
> recovered
> > > > clocks.
> > > > The messages are:
> > > > RTM_GETRCLKRANGE: Reads the allowed pin index range for the
> > > recovered
> > > > 		  clock outputs. This can be aligned to PHY outputs or
> > > > 		  to EEC inputs, whichever is better for a given
> > > > 		  application
> > > >
> > > > RTM_GETRCLKSTATE: Read the state of recovered pins that output
> > > recovered
> > > > 		  clock from a given port. The message will contain the
> > > > 		  number of assigned clocks (IFLA_RCLK_STATE_COUNT) and
> > > > 		  a N pin inexes in IFLA_RCLK_STATE_OUT_IDX
> > > >
> > > > RTM_SETRCLKSTATE: Sets the redirection of the recovered clock for
> > > > 		  a given pin
> > > >
> > > > Signed-off-by: Maciej Machnikowski
> <maciej.machnikowski@intel.com>
> > > > ---
> > >
> > >
> > > Can't we just use a single RTM msg with nested attributes ?
> > >
> > > With separate RTM msgtype for each syncE attribute we will end up
> > > bloating the RTM msg namespace.
> > >
> > > (these api's could also be in ethtool given its directly querying the
> > > drivers)
> >
> > I'm not a fan of merging those messages. The mergeable ones are
> > GETRCLKRANGE and GETCLKSTATE, but the get range function may be
> > result in a significantly longer call if the information about the unde=
rlying
> > HW require any HW calls.
> > They are currently grouped in 3 categories:
> > - reading the boundaries in GetRclkRange (we can later add more to it, =
like
> > 	configurable frequency limits)
> > - Reading current configuration
> > - setting the required configuration
> >
> > I don't plan adding any additional RTM msg types for those (and that's
> > the reason why I pulled them before EEC state which may have more
> > messages in the future)
> >
> > We also discussed ethtool way in the past RFCs, but this concept
> > is applicable to any transport layer so I'd rather not limit it to ethe=
rnet
> > devices (i.e. SONET, infiniband and others).
>=20
> I'm still not convinced that this doesn't belong in ethtool. I find it
> very weird to have a message called "Get Ethernet Equipment Clock State"
> in rtnetlink and not in ethtool. I also believe it was a mistake to add
> DCB to rtnetlink (for example, why PAUSE is configured via ethtool, but
> PFC via rtnetlink?)

We can use:
- SEC - Synchronous Equipment Clock
- EC - Equipment Clock

SyncE is a specific implementation of a more generic concept. I'd rather no=
t limit
it to Ethernet only, as there are more network types that already use this =
concept,
like Sonet/SDH or PDH as well as GPON/EPON networks and given the recent
growth in timing applications - I expect more to follow.
