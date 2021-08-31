Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89823FCB20
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbhHaQCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 12:02:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:12169 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhHaQCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 12:02:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218553595"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="218553595"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 09:01:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="531163438"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Aug 2021 09:00:59 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 09:00:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 31 Aug 2021 09:00:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 09:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwQUHI1jYCPiqEXPvtG5aWEd5BC/YcJVbO8AxLHUcBQdP1s6f6mbu0ATK/6UTMslgMBlXZWggoHXN1q6XwyIP5prTgtZzVx2+xFTAAwDHvUnvFzI3Ib+askfZ9YODEvXvOrXsW+LDth3iyx9IpUbExVh74CnIjjT/9l++kUo4pRXK7z4AbLP3GReEWV7JHBBn/4QqsPO9W9xLoJ0fj74F/2QvEUsM58/kq2+eH0WNla9tw5wNRwxG4ztwCwa0+/2Kbra36rQEDGxfNv4gyGxYH8wi4pWCMVp253vvOQT36vS21/bN/UZE3Cs/DrX1Bdg6T0VB6MSJqHDt3zoxy53Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTHSWDXgHcE44BVjwDKQgykuYcHAe8vSgh2DnCiyqZQ=;
 b=mzDvLhQkakvynXfbia3s9R4VKClwCUtT9zlmafPtrtGsnB+Vs3jbQod0L6MEfr+yGBpQ2cepo8RFXmvbrp8X+lwAEgrKUGFKqSlfzSuZ7n6V2ARWdhSzigBou9G7Dc9S/OXEjg8MhvXTCTa6+BwpHra11Qd0WusirHwpXDu46YqzCzdRASA3b3LpcGON0gy9RrAFCKYIU9q3cx0TlfsjKETE18CerrPOwxJquQfuQUXy3C/HejMwSEHjrdLT2aPuFHcI3uQP8YU/8kKiOoeBERqZG/5/M2RwatwskGgJxOFRJnoUMVQ8tlxJ1YI8aYBej79FFyitLEGjVULZQvZXRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTHSWDXgHcE44BVjwDKQgykuYcHAe8vSgh2DnCiyqZQ=;
 b=TIa19a+SM77IR1Wks+cc+4MQgnrTBo4hNIXEVhgTZPuVIuHb0q+1l2GcHf83gMaMDOyPMWCb5iFXyxiX7LZUvuTpCyec1ow49Cd2A6DQtHFpgvXx/cenwikc+uhI1PlwMQzlc4BbZE4EEQFLShwios+JNs0BM7sF+U5ch2iIUms=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BY5PR11MB4166.namprd11.prod.outlook.com (2603:10b6:a03:191::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 16:00:57 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 16:00:57 +0000
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
Thread-Index: AQHXnK7K1rkxJTKXbUG0z9L1S2fbo6uKlpWAgAANa/CAAeYOAIAAKj6AgAC0GNCAADexAIAABHUwgAAIGoCAAAwNIIAACL+AgAAFxuA=
Date:   Tue, 31 Aug 2021 16:00:57 +0000
Message-ID: <SJ0PR11MB495865C165A6D6516653CB03EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831071801.0535c0cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958304AA06A63DD6290D3DEEACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
 <20210831083227.3d9df78a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831083227.3d9df78a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 3bbef468-1e87-48c9-bde8-08d96c988529
x-ms-traffictypediagnostic: BY5PR11MB4166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4166B190DDDCE3115717FB74EACC9@BY5PR11MB4166.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kw1INuvcTLr4ov4coan+sUtgX6FOtGDwP4dBCemr/dWLqnlSHmIrf//xeszGxgMxUcznQ/wna/kgPRWaFPSD9ePYOtLFNCggqsTO1fzT7XO7gzVWvfHc8ujOJQFjZ6Y+4hBCCZgp/fmXKNQaHS2kmRXEE6xO60lpXATHf2vKTzIBWgKjkpd632DmmvXRxWf6AV99/eYOigQKbcOUz8aV3p7pEYHgB3jwMzBKnGzh8BjjQlbAQ+j64USahIRDSZB+D7aJUtv+VjJ+hi1prWlpx1sVtcusCS1ZouoDTTr7K4dXMxhE5pSTZbl2ngLg1ZugxVCH3kndDTs4jph027d0BqRHlmsRerhEr2ooCuG1Y4jSgNGbjPysYKJIkUiXlPzhldhdC+KauHSPfdHKVlBj0vIOVkQAWV/vFImKdnkKTN6tvmTU+URPa2kKnkiTElnSnerVM/l5+4qoawyn//tv2Jcv43FzIzF6VqV7mPrbTYBBl9aS0ugmPiWLq1ryK3kRVR/tXadE2UDrrXprthWpMX1pq4dNEgzeQL162ZzrRGziuqIxHmHSAt8Enell5p1V/MwTxlywif/V7z1vmxqewbKwYKseRGV5eos+6QUJNRTFg/VdwkO6TMBR+YQ+vBNHWHraESWqjTT05HomYKLNH3YG+7hJGE9jNd8FbIlOncZyhnWYEUYy8X/VmGTW8aXgj/0T6A6nrVVMzJNV6UKauw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(5660300002)(52536014)(38070700005)(66446008)(55016002)(66946007)(76116006)(66476007)(66556008)(83380400001)(64756008)(186003)(122000001)(15650500001)(38100700002)(4326008)(6506007)(71200400001)(86362001)(508600001)(8936002)(316002)(8676002)(7696005)(6916009)(54906003)(26005)(9686003)(33656002)(53546011)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4UOEAlj1e2/sUe0fTdIk4QMHPPLcIzE6G5mK97Ufx6SkPE0UE+Kb4zxPlFCW?=
 =?us-ascii?Q?hmNXtaaQyN2UhVA5vTpDmTpEByPfFDFaiZHpmv57h6xiwuvSKDhPnQjk+3Dp?=
 =?us-ascii?Q?aEan8xTq1FEp/3AEffmrxLjgDxPg7lfwXQ/w9Fp8Ui8SVTiJjEuioHirsIIF?=
 =?us-ascii?Q?OfU0X8zsmsWBmXPAR9n55X1fL6yeSMkhj+1t1AWNzE2PN9u75NWUBmn1JMe5?=
 =?us-ascii?Q?ucUFQTNPxqc3Wl0UA7X+pDI9zmOLuwmAXTPrgiCw90cYmI3zUOQGjgknVcFi?=
 =?us-ascii?Q?Pe60HLzR84IGSEetX1Q7ocReE1JlWhoFTMt/6BBGJy7BZwIRB+V5xr11vJUp?=
 =?us-ascii?Q?SzuJGFKXyx7tUzayemB52lrhfXyORKkgr+qCFp6CrHcZqaugrcRoL8WSr4hW?=
 =?us-ascii?Q?5BrMFzBKWVYXuWoDUuGuVAfSKwZQNzBaFx/WEvwogd2QUuLSpnghJRW+bc+O?=
 =?us-ascii?Q?BfTorRsF46f7Mn8XjfSlh+2kNJv/yA3bqNhRiz4g+kaUrgiFuIYKR6g1rClp?=
 =?us-ascii?Q?gjm+qXScHhk4uyJJnmJGn8VuXwcqB3M+bK4Z4grbhUzr6XOq5/GyuqzsZLUe?=
 =?us-ascii?Q?hePsUAJNLhU+d1r6zS0+gWYyZhOgz3TVsr9VFyscxEKS4rQb9JPlh+fGMEen?=
 =?us-ascii?Q?MIhvecHdSZDqvTv2QFYl/1zlZkYFyx7Gkkq3mgOZaTYAwzOn/DGGqQeNVF51?=
 =?us-ascii?Q?BX6L74lRHdxTwFqXWCJpJDjeoeyVbV+uX5DmzbRqUztsCQLgwb3fPG5SRvf4?=
 =?us-ascii?Q?tPZWyU5mitZQFo2yY2lEcaWfUYRY52a+D7v6w/Iva3col0imodHR6cH0DK9X?=
 =?us-ascii?Q?ok3eUc0fmX+vvHmbQmylAWlfu1H+OFg98OyoOoDfDGa/3OHyF4cWodSJgb3U?=
 =?us-ascii?Q?JujBJ3dkiyJiuPT8E1WsmwqkN3osDVavZVNt6/aXvRycNwtOQYX4FediYK45?=
 =?us-ascii?Q?wxh8UixCiEvAZ/PEip+ukY+0YqdHl5ACNPdwy7xOb6NrUu8hCJ3Ck4kgbD6o?=
 =?us-ascii?Q?Cn4IuSVHs6nIHiOheKuzfX49WpIOXeo7cGaOkJqt2WPfG930wvgC8ty1PGtR?=
 =?us-ascii?Q?Cj5I7pXIzc4BKvojp55oWkaOKATHZp2eERHJfgw7p6Njiwk2kAtaDkslUHvP?=
 =?us-ascii?Q?dhDk8rb6+elvANGoYJxgKH93/RPlMRaYFy+W290DsIlmPQSawktpDjRfln8u?=
 =?us-ascii?Q?tbMew761zAKzOHyYa65pmMa76u5QylN4YC6bErFYClA9FJzLOMUO4mqWj5Mq?=
 =?us-ascii?Q?sCKf5zY6IOBWozOfUbnpUUDcjXoBnmT7mRjOc5J4z+nNej9U/iCjgjzJdBYq?=
 =?us-ascii?Q?eJs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbef468-1e87-48c9-bde8-08d96c988529
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 16:00:57.2857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kW5bUFplw1LROgd75CktJJy2YzjR1drTlA3Bz7Zx1Tnil1vMF4UW3SLORZ9dget69R8rgGLVnFtvhDv4jOBo3OA/t4QP30OaprDRaCWAONs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4166
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 31, 2021 5:32 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Tue, 31 Aug 2021 15:19:36 +0000 Machnikowski, Maciej wrote:
> > > It's a reasonable SW design strategy to start simple. Unfortunately,
> > > it doesn't apply to stable uAPI design. You're adding a RTNL op, whic=
h
> > > will have to be supported for ever. If we add anything "later" it wil=
l
> > > be a strict addition, and will have to be backward compatible. Which
> > > I'm not sure how to do when the object we'd operate on would be
> > > completely different (clock vs netdev).
> >
> > I agree - the point I'm trying to make here is that the existence of
> > the PTP-specific interface will not invalidate the need of having
> > SyncE-specific one as well. Even if we report lock-states for the clock
> > we will still need to report lock-states for devices that don't use PTP
> > clocks, but support SyncE. (that's also a reason why RTNL is still requ=
ired).
> >
> > The RTNL interface will also address devices that only need the
> > frequency syntonization (especially in Radio Access Networks).
> >
> > >
> > > As I said I can write the boilerplate code for you if you prefer, the
> > > code implementing the command and the driver interface will be almost
> > > identical.
> >
> > I think it's a great idea to start that in parallel to this patch. Then=
 move
> > the common structures to the generic layer and use them in both
> > SyncE-specific RTNL implementation and PTP-specific part that will
> > be added. This won't affect SyncE specific APIs. The "worst" that can
> > happen is that the driver will put the same info for PTP part and
> > SyncE part if that's the design someone follows.
>=20
> I don't understand why we need the SyncE RTNL if we have clock API for
> controlling the freq source. Are you saying that there are
> implementations out there which use SyncE to recover Rx clock and use
> it for Tx but the PTP ticker is in a different clock domain?

Exactly!
You can also have multiple PTP timers which may use different clock ticks
to support multiple time domains.

The PTP ticker can also be completely absent if all you need is the frequen=
cy
reference. There are many radio devices that expect 10 MHz reference only.
