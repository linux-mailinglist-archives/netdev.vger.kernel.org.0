Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE953FC95E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhHaOIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:08:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:7534 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhHaOIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 10:08:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218488483"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="218488483"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 07:07:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="519697201"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2021 07:07:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 31 Aug 2021 07:07:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 07:07:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 31 Aug 2021 07:07:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 07:07:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcMxGrmmPazta7BE0fIE1rKNaFIy0PltUVfaZQ2BGS34+pbq/msIIL75bkHg1jOzbpEH2gRrul/uiELGkBQivvin5A4qykWsCq0/fC/nCJQ56Nu4MiZKfqaU11ksH8XXqbilzGDC6pb/HCdVJmrps5XgL91vviE0fziw9yjjh4f8v0Pner1IksjPR+bCQyNirQ0Y3o2cwFo7vgNBR9uHKTiIJYOLP86Sj1fbZj1JSYxBR4ZbMhoom6FFq08sI8PqYmdgXyV02jo4TFIeLXPcvPWP5UjfMmbUKkVac/pg5rqAUijYufcVjI1qR53NMnxWIBf7TKRw9aKNinBEe8LAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OTOghWyawvFhVndMldnt183wHAtDJXBqmRIaCR37+20=;
 b=iu9SAdzTLWRCojBuWDCO7Z3qvMSzKRmIZAX0tdDai0h6rt8STYX2qZSPd9f+eBYgJFjfET9un/suVNNNxm2EpjDwwJUg9FOgBwwvB76wvcT6PMxcTeLOgC/ROhKapzD8+uGLhfVmiSgyx6W4li6teKrBtRv6kqGF04wZxvfxfrlckChrcv+pYHRWYJIJW/rVgN2PlQ2IiFhdrXYgkGsjjanpEZx3GVXZHW2ccvw1iX+7mHVOKAaIjB6J1fnd4exei/y5mtImvxYaGDl1iy6nAE6QgPE667MA1tBtoWcXjidXW9in3JdoYSWCLkeXMLpLr2ApmYzGM3gyL4ZQ8UjjYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTOghWyawvFhVndMldnt183wHAtDJXBqmRIaCR37+20=;
 b=l2OZWqtHLGNOGQEDd9DlG26FTvYZJWTACV6r2fvHWayfQvnFzxRh11iTNHVzNXL8VMO3b1Ps9RSqTUofPaCJkVc+V2e/Tirrx7cGXpgNWDykVDIZERiwThZXiv6Ub69Mzd90cknUxF7sG+W8GzmdVkmm4AG9/LYQyK9m0keLF/8=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BYAPR11MB3173.namprd11.prod.outlook.com (2603:10b6:a03:1d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Tue, 31 Aug
 2021 14:07:32 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 14:07:32 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>
Subject: RE: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Topic: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Index: AQHXnK7K1rkxJTKXbUG0z9L1S2fbo6uKlpWAgAANa/CAAeYOAIAAKj6AgAC0GNCAADexAIAABHUw
Date:   Tue, 31 Aug 2021 14:07:32 +0000
Message-ID: <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
 <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c90ddd04-1118-4c5d-19cd-08d96c88ad0f
x-ms-traffictypediagnostic: BYAPR11MB3173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3173B069E7A7B8AFB5005120EACC9@BYAPR11MB3173.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZRHMNP1eIdnyv8uXEgxOTBi4N47nCzbjv5Gokp8B7ln6NLZsWHupInBQ55sCs+MQ0tyw2Ms7jfbj4PVE5KqLYOSsguZxzUAfT4+RBVpNZr6zbJPIyp70HP9ap29VMTwWo7tEsQ9AaMKIKPGGmeiE5ttPWQWjS5nPoplPs8vgHTSM3JTeAhYMVBMMAKZY44jiGShfRV2lu/lCs5FIaNouOqRX3jGvudu6AeQmTC5hbdBxkErsYVGVdx1cuAd+FzTx9OXa/N/PjmOroCngdW4dTh2J2mF48Fiv/6syPBh63cc0o2vLWbgmlom9GSMrMVux9nxJfsLacjUpBhei3z1h2iC+W2Si3KCZgIi831poIuPyDE5uP9laxHouuo0wenIwnV/rWun0Bhq7XEFcRWLus3sXa3mHuRwEyjtyL7ug8jnVcyTMvJzR+qmSxVDnosyNWkKTxMD/OHDMBY6gGxQ9EgWI0oH8YODG9UrslgRAkC0pDWyPmsP9QdpP/eVrMFqhLuVwoPgysdfWish0wtKR9bwCfFF2m+xx48hB7KRzjdz2tzVxOEDBMe+KYcKcArlUWWuGWMeO67+KJMRN0bvsvM6kh9YqWX1ncbMtHLMyn0UXIo7XKMpHdUJrGdhPjRKHQ+BUhafX2OsDl7z6iwEM73eYA7W5hppdGx6k5fGdkKpCp2H6ClM46OB45gO32pjj73xm8LnRslmKQ1WPOPLgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(6506007)(66946007)(71200400001)(66446008)(76116006)(53546011)(4326008)(66476007)(64756008)(66556008)(15650500001)(186003)(6916009)(26005)(33656002)(55016002)(9686003)(478600001)(5660300002)(86362001)(83380400001)(2906002)(54906003)(7696005)(8936002)(8676002)(122000001)(316002)(38070700005)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mtAa8PhoFX+FrH46W0br8aiQ+MsamgNdkj9SC7FdYu2gFaPpmriiAUo6zsTf?=
 =?us-ascii?Q?E3Mi/nr/qwVyBYwwjYoBkNspJu5mD97liljSKhbuvj/2MG+AY5VfbC1ZQbmx?=
 =?us-ascii?Q?q8QttcgCQw+pzk10VPh4tTXmc8TGOiQ5TSbDiY2kW2QpjjwQC6fckGQ6N9SA?=
 =?us-ascii?Q?kk5COLU3HO/C5vu1JcyQrzlpLgGVyuBrTBn8hCY7OHIK8dqP66G3ifTm122r?=
 =?us-ascii?Q?3bepnSBamWoAp7RWeKbvp5e5P4ooTsOPbuTyCKEjTBHbqOHfKPOI9pHHkAjr?=
 =?us-ascii?Q?vL98SJ3ggYSMfjsmKCpAIWM0zCfo7eSzwtlZjXZYLw8pJ4TYFvM5wPXeCYNi?=
 =?us-ascii?Q?RAiDDUtgjeocqOdy1BtbMFotR9GaB2W3BnZzDr0al50p58ZELVw35uIl7JkW?=
 =?us-ascii?Q?OBxjRqoc5xUyl69hwc3Ch/Lqk13G2HTPfC5K6kEYvQdByn4Kukh818+/JzZ5?=
 =?us-ascii?Q?pGtCDEEfXc+ahZJ7Tv0nXWtLNPsSNqGZVPjQlFHd7tXHwmVQdpSiu3LGMho+?=
 =?us-ascii?Q?IPlsqa2eelqRK5MO96j1OSUuD8kbNgtsYYCsmis1b53nRJlvcb9Fmp5D5lxc?=
 =?us-ascii?Q?20KgA3A+UtAZ1Gp3N5LVdUdgsTfxxAu6tvR42zafWHINXnLul4f+BjEvRHKX?=
 =?us-ascii?Q?ioc58geRZVNWKMUYzQu3yMpxFHoeYwq7bHi8NA9Uhg5NtGa9uucVUVJO26Xq?=
 =?us-ascii?Q?sGAm6F8lAC7qKhDsBI2ki0oNugRJs/eCUyhI3XtvWaBJOt4h+pGE/BLrGdYf?=
 =?us-ascii?Q?SWrWdFrm1d6kQFQO52EbTdcBrxWSinVY1jDzScJ/lBfK7qoqQBEYyRQoAh29?=
 =?us-ascii?Q?LWa7AExo2xa6CA1bnQ2OCriZclQEphLKdFWaFI7SkY+nSRGjg+9Uzrkc+UZz?=
 =?us-ascii?Q?E2jxVxDcZmnnjE+4CGrmhd68T+Ga5Fe0JXqnpO3DoD/rwBWcdt8lZmoHpOF5?=
 =?us-ascii?Q?m9Jr8lw7hdehndgqsQiTGWmsvMKVzaM8f6CVw5I8qYzR0gM6yN1JZnauCjT7?=
 =?us-ascii?Q?nsV6ZXL+9jzHIT9LDur2H9sOxp6CWYSkpK31OxRhdsphstTGvdiYltwin/Di?=
 =?us-ascii?Q?tD/QBoI8P5fniUaKJF07P7qwngZEUYcmzLNLqxC6hrqXMxlYp/I1aY15jA3d?=
 =?us-ascii?Q?9Kcy7s0D4xHkBicvFb8kHixM8xWJE8tbmd3i2bTwZNzazbDR5I0Eg34GFcUr?=
 =?us-ascii?Q?9cfZIZh6KCVU7viAhpVvMXeedTwdDbk6N+c09kbNtR+cBqYxOtD19ANH3fCe?=
 =?us-ascii?Q?uGNTOFh1sxwzskb4YsJdhgOA3ukPiOBstcj/lJDtNaMjP0NJfXyFfC+0I1BQ?=
 =?us-ascii?Q?iVw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90ddd04-1118-4c5d-19cd-08d96c88ad0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 14:07:32.1259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OPI6/n4KBhiTQtgqTOKxDGE+L1Od/QY745qcgQTEGqtD3ME+LgLx+i5853+k4Cy9T4zlcBh0//pOp1Ihsdx3+UDNHPI0WYGKAIPGUwDeY7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3173
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 31, 2021 3:33 PM
> Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Tue, 31 Aug 2021 10:20:18 +0000 Machnikowski, Maciej wrote:
> > > Hmm, IDK if this really belongs in RTNL. The OCP time card that
> > > Jonathan works on also wants to report signal lock, and it locks to
> > > GNSS. It doesn't have any networking functionality whatsoever.
> > >
> > > Can we add a genetlink family for clock info/configuration? From
> > > what I understood discussing this with Jonathan it sounded like most
> > > clocks today have a vendor-specific character device for
> > > configuration and reading status.
> > >
> > > I'm happy to write the plumbing if this seems like an okay idea but
> > > too much work for anyone to commit.
> > >
> >
> > I agree that this also is useful for Time card, yet it's also useful he=
re.
> > PTP subsystem should implement a similar logic to this one for
> > DPLL-driven timers which can lock its frequency to external sources.
>=20
> Why would we have two APIs for doing the same thing? IIUC Richard does
> not want this in the PTP ioctls which is fair, but we need to cater to de=
vices
> which do not have netdevs.

From technical point of view - it can be explained by the fact that the DPL=
L
driving the SyncE logic can be separate from the one driving PTP.  Also
SyncE is frequency-only oriented and doesn't care about phase and
Time of Day that PTP also needs. The GNSS lock on the PTP side will be
multi-layered, as the full lock would mean that our PTP clock is not only
syntonized, but also has its time and phase set correctly.

A PTP can reuse the "physical" part of this interface later on, but it also=
 needs
to solve more SW-specific challenges, like reporting the PTP lock on a SW l=
evel.

I agree that having such API for PTP subsystem will be very useful,
but let's address SyncE in netdev first and build the PTP netlink on top of=
 what
we learn here. We can always move the structures defined here to the layer
above without affecting any APIs.

>=20
> > The reasoning behind putting it here is to enable returning the lock
> > to the GNSS receiver embedded on the NIC as a source for the SyncE
> > frequency. It helps distinguishing the embedded GNSS from the external
> > sources. As a result - the upper layer can report GNSS lock based only
> > on this message without the need to put the embedded  GNSS receiver in
> > the config file. On the other hand - if sync to External source is
> > reported such SW would need to read the source of external sync from
> > the config file.
> >
> > And the list is expandable - if we need to define more embedded sync
> > source types we can always add more to it.
