Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B374DC49D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiCQLR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiCQLRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:17:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1221E3744
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647515789; x=1679051789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rP2Oa8wJ2+Uh+FXiM8KIc8JWfxeVKwu0oFtxEwgkMV0=;
  b=HAiOz/WyyuIIHu4SREwysN4nEyKeRj8OPpGzOB037Ou3VdWFfgoIq7EN
   m65fpxNql/grt2BJm6QDW3C2tD040jkGUu/hDMIZ3hMvn9ggjWuJxpxso
   S2reslMxyaPIW9YIFF72VDabMcK6sZh5Nk6P7Qz3BCK8QUO9IcCsMnXZ7
   gVzlZa9hoGRNtkg2WVu8w0ysZswUzC5QnhOmp89S7BqWIPuowvSnrdwYN
   KYLpuNMRZF8nBhjtgFHls5lhr7NCGdyowpJK9wOHF4Tv7e/8QH4PbNDMA
   3+ThviTimUwxySGeA5wVH7x8DYst7rBMFIhdW4nsRUl1AyRFsiw1Y6dF6
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257028537"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257028537"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 04:16:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="613966462"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2022 04:16:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 04:16:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 04:16:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 04:16:28 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 04:16:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca/AxAHMjxt3GF8k5HbKjXIBbD6hpx1DvEp0CdRW+mQuKx/x1GUXMuIU6ik76vtIWR5SuhyDlEPg1651yXQ1iIvjTYBJOtV7RsovYQP9nK+Mm2G4UufbbuiIv/jjgtabPRWTqzcWSLpHVaoOS6QeyohvN+ab6uE+e7LqZeFlCeE77ZfCNvI7dhfeTo6IgBixAfdRNhf6/mF11PGWqg07PlH75Q7ilAU0PcwvFIDWhZVOI6KJFn9MPF6r+jnaFHPqiB3YJIOyjTosZ6TtCflv77dHh1QkKEJ9Y2r1zvEEhBWcZCeXyMB+kDN9+kfCyH8WdfQ7uGd9xsz8t6345PYf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeXuLUoqxWuZPY3Sl1DKiU7HfBYquqnqTbp1O+xS2oc=;
 b=W83lG9g5r959Hk4EDzLHgbHzRHK4i/TwASnwHErDqMjRp7u8CvJbPCvAhOll89kzXk1kvVXZLdUgU6eyN9JbEc16Keh+YhYAXUKCpkdEyYDVs6cIXMFwInEbXXUHycbFXYzXCkeOeZg/UutY1xOs4yNqM8lVeFyK0EBimpKFDiy7OLjCz55oBvZV2xRhi/US2m1gJFXWfq5X+dMF9uPikFa1omswnRpGYwQSS3vCVATT7EuvlAY0o/eiMGbLn0U8+BvQ1v2F6WZcYmqshsI1V4FhNmNujR5N9TioV8/yjiYzAXgDMAp4aIOFfP6CDPWEvX1fCDKvddZmBZzjVdoQEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH0PR11MB5596.namprd11.prod.outlook.com (2603:10b6:510:eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 11:16:26 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%6]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 11:16:26 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@gnumonks.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: RE: PFCP support in kernel
Thread-Topic: PFCP support in kernel
Thread-Index: Adgzonf8LBvYss0DRt2kM5s+Tem75AAP01oAACqSnwAABsH3gAFSN8pg
Date:   Thu, 17 Mar 2022 11:16:26 +0000
Message-ID: <MW4PR11MB577638A44AABF97C854FD383FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <Yiju8kbN87kROucg@nataraja>
 <MW4PR11MB5776AB46BC5702BD0120A7C3FD0B9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <Yio5/+Ko77tu4Vi6@nataraja>
In-Reply-To: <Yio5/+Ko77tu4Vi6@nataraja>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a02b6d7-118d-4473-583f-08da080793bb
x-ms-traffictypediagnostic: PH0PR11MB5596:EE_
x-microsoft-antispam-prvs: <PH0PR11MB55964F1645AD68F0D37CA4DAFD129@PH0PR11MB5596.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8l7LnnDBGll/50S7H6oFIGTQgU4Yv/vloZaGNjT7Q8qh4dyxfhemVjyuHpjfs69Qxqz/r5xXsWpF61WsHZK6kj+bVEfqca+hqL8+c5mdnoYkpMWLbwMRkB+eTviBfDN1k/tQ5CYUuI2zyNesAslu4hCzi2lQCZTRd5DfoXEG4DZdf82UPjJwoYn0lVCbQyOvqSsB4ojCPqmARXozOczpNSJ1lYMJJMWEZFNkf6GUyYa1WgbN8CNes96N6Re8SdEpGj2Q3cJ+LyZ2lSVkSFtGQgHJ5k2pV69njbbRdXE18Ir9WSrNm0Cs8BfUMxBIKsAmouLYgh2Az+xXNsy7j46EbpGm9YQQy+cPnU5o/mtATIkGgkQbNEY/Iet5DD3O5i805kJmDigZl9xWDGmGtOS50d0hYN7LIgC0y+xqjJx+GhO/MHN8VGMjtV6Zs3AY2deJS51g4eqMmxYJlIYfyVECIQkVw2vrC3EJKZW7CbPqrMJ5QvSM+7A3Dcio3ncLGiEktc+C9ZSFwF51au4A2YFqgoscjeG2BoGIfF3WWrTX8zJg5XYccIRqGcJCjImIcx5m9XQ88RmU5QQadMmK9si19/6IJG7xktaYAAESBtiF7Gv73w1E2pJF2aPtOfZsdNdT6CHuGOXa107+kLwjoU+zG7yU1wA26l2Flyg3Pzavq0bw24asO37xZ3M+44RUYdT3EdFj6IpLuYnZeP9t/UBFmlRtFR8U0n3nFPkBafIjYiCcHajJQMHvoa4UwFUak+UfdTuLC0XGkp775kB9n9bQuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(55016003)(7696005)(186003)(2906002)(26005)(316002)(966005)(6506007)(71200400001)(53546011)(9686003)(122000001)(54906003)(6916009)(38100700002)(76116006)(66556008)(66946007)(66476007)(8676002)(38070700005)(4326008)(86362001)(66446008)(64756008)(508600001)(5660300002)(3480700007)(33656002)(83380400001)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?emWdDizlzWQ8vc29IjAdpVJYUoZMV1tqDCZ99rMSkeWzx+YbIZk+uCv9hnOm?=
 =?us-ascii?Q?OBAcueryyjmkSHj/CwMf5ZtAkTYpBT+xBLnXvhI4agbspllTh3kbzCTdBH+A?=
 =?us-ascii?Q?dAQXLV4ctGdLcrpjti7M+KQAXEyp5Nb0QKlbVvs5vDTIsws1N1bfLKdVijQ1?=
 =?us-ascii?Q?Hnv4hTQA/p68ZJlOdgIBHH1Gyr75QKI/4Sf0rCoNOUVwWnJAj8+KBDRp41db?=
 =?us-ascii?Q?Al3T/zhI+FKcXxL7XjlPrHRNG8WwwjSmGD18Nh9G3LnF3K4Tu7dMTJT1RNAc?=
 =?us-ascii?Q?GAHmK+pREMZMt7Ojt6xVw3VfXbPdgXU7SCADpH2x3Dw/tpAhPj0b19uaMcUl?=
 =?us-ascii?Q?JoqZmxVyRvXlSrK2CIdUFt9Wh6tMWtQ0EyZzLCW5Qy1nKfWh0DeqNIa2yWZ2?=
 =?us-ascii?Q?e46GRoXaj7JzNpVBCG3kuJirKzi7CjJ28CKQUDiBNoZOd6gFu0kIwLvrTZup?=
 =?us-ascii?Q?iGAXb/8JnHVHn5GOFF2B3L/TPs2s2Kl07uBKYZ9yJ+DWqDJWgeGla4hr4uE7?=
 =?us-ascii?Q?/PYhvRCM44VleBJQ9j2yvWrJT81cjgoL3H13ktcQPpy3lLlYwju60xnAQ/6O?=
 =?us-ascii?Q?KyHv2oXJmju3shJ/sLiZAJLeeWIE9XapZgwnTtjlLOXkj1kq117PatY+HbxX?=
 =?us-ascii?Q?CbV4XEF1lTzn1bCFZtBIOnvCcTy54kFiLwsGazzS0aXWf9UZ3RjsIeGyjkE4?=
 =?us-ascii?Q?QTh6OaC81cKHjXy5Yb8kOOAcsC+6YBrgUmu7WnrAO43R7CU+cI1Jo7vaB1ig?=
 =?us-ascii?Q?tyQ0ykPD9bFw7sjUMTVB17M4zFojgdgQiwEYg2Eol4XFCdhWyx8Fc1N1nnLA?=
 =?us-ascii?Q?9qwyTlbtHxzQcYxkQC4xGcb/KPql5s3tGcjeWOlx6yREdJL9zxUNiF4sHFLS?=
 =?us-ascii?Q?s0ZyaQeYl3lg3q4ltAvmHSgc1K8HfxvBzy3CxGgzsWcEIj04fHk3EvpOdsJx?=
 =?us-ascii?Q?IBNYbAg3kfVkuSd9ESY/EH/iqyWgVqH0LjIcrTY1ALHcSVXAik5yHfREU2Zd?=
 =?us-ascii?Q?wPP80O7OnQzpQexzjeMTIrmjdlP/ZlIcd/DszSMbte5Sv3sP+pH62jNVCoGF?=
 =?us-ascii?Q?yRnkKMBH4KAe2Y8tCAqKtY5XXGZR8bX7RzOMS6amVaCqpFueSzltrPReX8NK?=
 =?us-ascii?Q?0el8+vFKJN8JQlDconEredMiag8seYcTlyY5mBfs3Czreg0rsZ0sg0+vr9nZ?=
 =?us-ascii?Q?xsWP05XmGEwFq3FoN4fUz759od+Dhf6ew9KY5gwPj91XmpHwVqCw/5BnwxTI?=
 =?us-ascii?Q?c3ugKYpwPC7pcNHo/GON6RBe0gyiI9gc+8OydjIobMgt7lTtWOhrpcBvuRq8?=
 =?us-ascii?Q?jmUYdxWYLnDdgh9KeoqX/NZSLK5c6jLew3XABLSjgvnbiKs9jtlYbXVPP30j?=
 =?us-ascii?Q?BMs0SZgpeJ4997BTpqdGGzJxLtoKsaN8EL0fSTq9WxHrJh4ZN6ydQso1H3yv?=
 =?us-ascii?Q?yVFwu+LYx2yBSAvsmxbVyEpX2ayoluqU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a02b6d7-118d-4473-583f-08da080793bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 11:16:26.1574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwFWJreKU5us3BwsCpHkMj/mlSXDZJB5l8aVoqNhwIk3VmT7n2aTHI/RNH4d+D5WndcGt5D0jz4fbb/CHzf/IPdEA+P4aFJeaM7CktW9zyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5596
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

> -----Original Message-----
> From: Harald Welte <laforge@gnumonks.org>
> Sent: czwartek, 10 marca 2022 18:49
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; Marcin Sz=
ycik <marcin.szycik@linux.intel.com>
> Subject: Re: PFCP support in kernel
>=20
> Hi Wojciech,
>=20
> On Thu, Mar 10, 2022 at 03:24:07PM +0000, Drewek, Wojciech wrote:
>=20
> > > I'm sorry, I have very limited insight into geneve/vxlan.  It may
> > > be of interest to you that within Osmocom we are currently implementi=
ng
> > > a UPF that uses nftables as the backend.  The UPF runs in userspace,
> > > handles a minimal subset of PFCP (no qos/shaping, for example), and t=
hen
> > > installs rules into nftables to perform packet matching and
> > > manipulation.  Contrary to the old kernel GTP driver, this approach i=
s
> > > more flexible as it can also cover the TEID mapping case which you fi=
nd
> > > at SGSN/S-GW or in roaming hubs.  We currently are just about to
> > > complete a prof-of-concept of that.
> >
> > That's interesting, I have two questions:
> > - is it going to be possible to math packets based on SEID?
>=20
> I'm sorry, I'm not following you.  The SEID I know (TS 29.244 Section 5.6=
.2)
> has only significance on the PFCP session between control and user plane.
>=20
> The PFCP peers (e.g. SMF and UPF in a PGW use case) use the SEID to
> differentiate between different PFCP sessions.
>=20
> IMHO this has nothing to do with matching of user plane packets in the
> actual UFP?

Ok, I think I got it. Thanks for explanation!
>=20
> > - any options for offloading this nftables  filters to the hardware?
>=20
> You would have to talk to the netfilter project if there are any related
> approaches for nftables hardware offload, I am no longer involved in
> netfilter development for more than a decade by now.
>=20
> In the context of the "osmo-upf" proof-of-concept we're working on at
> sysmocom, the task is explicitly to avoid any type of hardware
> acceleration and to see what kind of performance we can reach with a
> current mainline kernel in pure software.

Thanks for answer, so I think we will try with TC tool for now.
>=20
> --
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
