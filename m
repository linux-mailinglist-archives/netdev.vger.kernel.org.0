Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B788B580456
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiGYTPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbiGYTPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:15:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5F8766E
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658776518; x=1690312518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q+sqW90ON0KxqvgnoAVhtN69drk8Xj/UDUK1gZwXiGw=;
  b=CsZOPKvkFkgXcuYABZ6QDGeCL/DUWQWUlMB3XL8zEOxpIg2YcpchipqO
   n81gnCswC8/3tQg0P5fEIh1zunR4vjq4yIofCx5+K7OkTxIV5+ic0KU5e
   J+YUCHlkMR7ReG0xm7HUOWp0M7qKUbJ2FW7olEIpZp7DXEJsZZ3kwbUQh
   ww+BPQ5bI0cnAd1vbKcBZGzfFkyrS5j1mC+Il1N5JtH12BBq1PvUP2vHH
   I4m+cP8cP++suhNplOoG+91Jua9YBeLpr9VkFSdJJgaSgctsn+KaOXYLb
   Yn308W3gNegP+42UVqN0fTKGp0kBYfjL8KLnq8oy0v5yRVXnB5UwLuPp1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="288535624"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="288535624"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 12:15:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="596779079"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 25 Jul 2022 12:15:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 12:15:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 12:15:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 12:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1979hDgAREwf9XfW2qkExgZ8mB6lCbiaRjFSvJR/lenhYso6TOUZHtuWn/XuFouavPs3wtIh+xIyMgGCHOZHsWSSV7oBE5O8lj65lp20iZWX8bUgP1Cip4DuNQjzhvB58ggRyn4aLmX3tvXTT/1GHt4tcD9+ijgVC9C36EL5f7fnBrzqy0t1Iyadeeul+LrZPrA29s1emv/yno2zoCd41N6690NbfHvOnZtjVRNAsoJNrc+RLMWBgDDKd/Yi74ykQvX77YM2EW98QO+kd73MUKBIXj02kfQXB+wTeZB59M7GbEDhSQQ4J6ZzJPf73enFKmG9jzTFHc7Gkp4t59g7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f94WW55EjeanDWPCY+HAAPfNBZuWjiivbkIQAzsfABA=;
 b=m6VRQk4dHuByT1qAIH+fipiBpCVqrRZGke51AyoJd3suP7K0umu8SmPgAstoj+gKsuwdejuHqVv1D9XHuo4UYHQFCcUdra+ZVRqyxwcO/LI6dMoeAUUDXHWi4JxJq/w93VPUMQBE4KQQfr8hqjCsKnK/jKLVlOULUrV7FybliWnkACNarOjLZDBxHn38Jg81DAL7u7EQ/y+7c7eAlRHhVTVX3vDPy3s0FqJ1AZ24fznsbXc+xEAwGgZsr4XJzYSrMtfJW4Do8BWq2ZJX2DaevjgeD3YNBhLdeeurE+DslMCQY6wZbafpzK4eJ0Q+MPQ/XPUsPY97TKRakAxGCu7pJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by IA1PR11MB6146.namprd11.prod.outlook.com (2603:10b6:208:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 19:15:10 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 19:15:10 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4A==
Date:   Mon, 25 Jul 2022 19:15:10 +0000
Message-ID: <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <YtjqJjIceW+fProb@nanopsycho>
 <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
 <YtpBR2ZnR2ieOg5E@nanopsycho>
 <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YtwW4aMU96JSXIPw@nanopsycho>
In-Reply-To: <YtwW4aMU96JSXIPw@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c53dcb00-df45-42bd-614c-08da6e71fe38
x-ms-traffictypediagnostic: IA1PR11MB6146:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ltzvX69a+0Urlcg8Mux4MnIg4cbb26gTLUBczE1XpBDv+07EvF459gUEtQO6j8Jqz7rWk+ZpHCepAyd4qz+jA9GhldTRmBgSM8i8CgzWSWGHV4RgCydnrCK6xS/2VGG4Eif6afneL2igZwmZsJjcSPQ4SPoiU+QDh5SuNNeIRE4W3eGIUECfHteZsTdhRIEhYUZuIDKBSVG/Ix4xRROym/bdJtUARkxjKOdLWxnPqrJ2FWvaNvlK1ewQYNCG+ubnzUKxo8N8gTSHkIYOMBt7YkNNKXxkzro5LGJUXJC1Q38tps5+guxbb5xsetvvrb5Iagr+KybpxVsKxoFZhnd5DEnK5fR3dytBjfOXgJW1qad3j+Cm4AZC6rvSwhRtSqzCTinOLoCSgtfYszjOT1DgDxfcYA9882FfRYtvgZEpgaxwqIpih+t4DQkMkoSxRXT56PjO38HdBOVz4WA1hNQ2Nwm9J+o+Jyz+M9A3eZ8MfV5k6G4bDVrDk4qVVt1U5+LZZEidsx6CX30xP1ADua+kZTf3F7Nf5R3n0Xnk8+x95ThdJsA61ZSWwFp2s5pV81uhyZJ1ez7A//o+3xBrq66Lf0mtEbZQVO1tYzajHyPb4AD0j+lVj+FyCJvmD9K3Lw8dLCYnYrHc4Ob66YQCl5ZnAx6uqKtttQydyH2p/fQ4RYB4S5sxc77dD4bbFUT1uF5kIjLsG3Hw6ro1sDbOmn5hIpg9mg847PABA2AXyndRmdiRr0Bo9EDVbZP5AGm0xFvik4eW/q0LAUGBp12s54IuBcYSl6OX5su/XPaet518rBb9BGpElo72b/fwWnZFlsak
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(136003)(346002)(366004)(38100700002)(6916009)(122000001)(316002)(54906003)(41300700001)(66446008)(2906002)(76116006)(66556008)(66946007)(64756008)(8676002)(4326008)(66476007)(38070700005)(478600001)(5660300002)(55016003)(53546011)(82960400001)(71200400001)(52536014)(8936002)(9686003)(33656002)(83380400001)(186003)(6506007)(86362001)(15650500001)(7696005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0gtiXqiCGau8kyXDHAt11QUIsYBsQRY8qwbPP0hRWG2cDXftHTRVKH4qoWyG?=
 =?us-ascii?Q?ZhSfRdQ2gfpO9FDwdkb25YVNVb0hE/PXGHr2B2QdRg9UrIOuHQJAmRvgeOsN?=
 =?us-ascii?Q?dElcSZ7SIHW1CYUMV762Tm3O+0UaJJaQWr0qsLos9cookb0qXaIqHjG8/7r1?=
 =?us-ascii?Q?m36SHBo/+MEp5FUcv9O+IEx3EPb/0ziCQUmNe59aO3nWhoUxSe14zgr59k+r?=
 =?us-ascii?Q?PCr3sDiowoI9q1Ckz8fr8XdSjoaIe4mSLUsNCdZqjGhHJj3a4MLmKPCdztTK?=
 =?us-ascii?Q?srX31LYSmKyV5jtV0uaokXr+6B1RhNbP33URt4wrA+JSORwYMMoSAq1uFKNA?=
 =?us-ascii?Q?7vvxvQ8Z4JmDOlKhr9cPNjuC2Yqfe/Dl4fNJbpVYXX/5pEO5i3O0/ym8qpeE?=
 =?us-ascii?Q?F0ufpANKjRY1TZ6FEjQGIYTG7B+oD+2uP+qUg0jxD6LNpvtLfoIVBc+DWEV+?=
 =?us-ascii?Q?W6BNG4QEXIAyTppCD/Siond7dHUkgKuWhiXzOD7PC6OPF3VuXqBdFjXz2Aaq?=
 =?us-ascii?Q?lnq+8wZVkkEGQWhBFUo9Vfqj1QLaax5YgZQ5Rb1bO9BNLkrHIUqx+P8SSozq?=
 =?us-ascii?Q?Z62HixYlg3/5GizxqtiGBkrie8DEs0tGcBRo1uilU6zJQdbkI9LXMDWExetp?=
 =?us-ascii?Q?tXVMFOnjaVMhB6vwuBNmvPlBZrWxXRdQoNpxsjt0+U3S1rmLNHaU86KoQMma?=
 =?us-ascii?Q?UMknv/HRNY3KZab2KCoM+LBzxwzTIKBX8JMqtOOCXQzhXE8DcwB29o+z0Xa9?=
 =?us-ascii?Q?EESH0JJgyTd5Rcg9z65Hn1NorTr2v8mY31dCbr4xJDNP7HspegoEZGeiW6rl?=
 =?us-ascii?Q?xcyM+ocJin//hDRwTSg8n/8K/dBqp4TT7qiMnSuFCfHzhcOdYnphwzNImSBl?=
 =?us-ascii?Q?+8zA6wg8lv0r3PH4mdfIO0z+dPG6acccl/INVy/Cs/OVStW1FGZK0MrCT0qm?=
 =?us-ascii?Q?9fBnOfRYnyul/mDz7GOLCc+NvzSeBYKV/SjFpXg6pTSdLvBGLfY+6eT+J+gT?=
 =?us-ascii?Q?HBNrqR7KlLMUxPUEISUYJJAcE+K1X0a0ePbauFRokdKONMiPIu290SJGha9K?=
 =?us-ascii?Q?JLC3ZNysb/B8FbrpfPs+tMp5QE+QP4dfFlZfvlXZZ2T+zDJfvQD5YI7YWW6l?=
 =?us-ascii?Q?iQmNSOmeId/CEbdnbGKVbjBSvqookkTuR3APZmSucgolfcVKMDSbuJeDsH7i?=
 =?us-ascii?Q?a5oBhwVGeUXJVH779fQcAw0GAhHoETPpFzEcFe8ZS7LNhO1AeO4v8PLJmtwv?=
 =?us-ascii?Q?ErXrectBFXB+AeqCJPlMBzxH+8YHsbPh1tfO+5M7oKVfbwst4O+XxW2atVjG?=
 =?us-ascii?Q?UTr9rmAJ2InNNw6JASCWA4j/KHlOch0dAvomSjl4c2dSlpBMm4rVFyuH5Hxf?=
 =?us-ascii?Q?yUg82wpl7qkObloiWovaDT1g0D8FpsHb665lxv5ioFGahYPQQoLlxaLbju2j?=
 =?us-ascii?Q?NGJR1p4fzjg1Gqq7snNnolEk0Nw2bTjiXWKaYdNlP/9Ur+3tEWnaW+Bc1x7X?=
 =?us-ascii?Q?Rx1RrA6oLBfTpUs563ze323WUfTLD5EYkl08cUzaJBZEev4c13J9cUYWpMMh?=
 =?us-ascii?Q?Msy0S+H6uY2yHhNrCYIHVUrNdUJwFZaON5z3d0Lw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c53dcb00-df45-42bd-614c-08da6e71fe38
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 19:15:10.1501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcLdj0Cnn871pHqJx5qn1HfoqGc62yS/wzopM1e2i+qdGdEVytykYaGM6L7RuEdy56MaGBXzP5EGmXaPC7KEj+uovX1az6Nuz4cIUgloNAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6146
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Saturday, July 23, 2022 8:42 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> Fri, Jul 22, 2022 at 11:12:27PM CEST, jacob.e.keller@intel.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Thursday, July 21, 2022 11:19 PM
> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
> >> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> >> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to fl=
ash
> update
> >>
> >> Thu, Jul 21, 2022 at 10:32:25PM CEST, jacob.e.keller@intel.com wrote:
> >> >
> >> >
> >> >> -----Original Message-----
> >> >> From: Jiri Pirko <jiri@resnulli.us>
> >> >> Sent: Wednesday, July 20, 2022 10:55 PM
> >> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
> >> >> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> >> >> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to=
 flash
> >> update
> >> >
> >> ><...>
> >> >
> >> >> > struct devlink_region;
> >> >> > struct devlink_info_req;
> >> >> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/dev=
link.h
> >> >> >index b3d40a5d72ff..e24a5a808a12 100644
> >> >> >--- a/include/uapi/linux/devlink.h
> >> >> >+++ b/include/uapi/linux/devlink.h
> >> >> >@@ -576,6 +576,14 @@ enum devlink_attr {
> >> >> > 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> >> >> > 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> >> >> >
> >> >> >+	/* Before adding this attribute to a command, user space should
> check
> >> >> >+	 * the policy dump and verify the kernel recognizes the attribut=
e.
> >> >> >+	 * Otherwise older kernels which do not recognize the attribute
> may
> >> >> >+	 * silently accept the unknown attribute while not actually
> performing
> >> >> >+	 * a dry run.
> >> >>
> >> >> Why this comment is needed? Isn't that something generic which appl=
ies
> >> >> to all new attributes what userspace may pass and kernel may ignore=
?
> >> >>
> >> >
> >> >Because other attributes may not have such a negative and unexpected =
side
> >> effect. In most cases the side effect will be "the thing you wanted do=
esn't
> >> happen", but in this case its "the thing you didn't want to happen doe=
s". I
> think
> >> that deserves some warning. A dry run is a request to *not* do somethi=
ng.
> >>
> >> Hmm. Another option, in order to be on the safe side, would be to have=
 a
> >> new cmd for this...
> >>
> >
> >I think that the warning and implementation in the iproute2 devlink user=
space is
> sufficient. The alternative would be to work towards converting devlink o=
ver to
> the explicit validation which rejects unknown parameters.. but that has i=
ts own
> backwards compatibility challenges as well.
> >
> >I guess we could use the same code to implement the command so it wouldn=
't
> be too much of a burden to add, but that also means we'd have a pattern o=
f
> using a new command for every future devlink operation that wants a "dry =
run".
> I was anticipating we might want this  kind of option for other commands =
such as
> port splitting and unsplitting.
> >
> >If we were going to add new commands, I would rather we go to the extra
> trouble of updating all the commands to be strict validation.
>=20
> I think it is good idea. We would prevent many surprises.
>=20

I'm not sure exactly what the process would be here. Maybe something like:

1. identify all of the commands which aren't yet strict
2. introduce new command IDs for these commands with something like _STRICT=
 as a suffix? (or something shorter like _2?)
3. make all of those commands strict validation..

but now that I think about that, i am not sure it would work. We use the sa=
me attribute list for all devlink commands. This means that strict validati=
on would only check that its passed existing/known attributes? But that doe=
sn't necessarily mean the kernel will process that particular attribute for=
 a given command does it?

Like, once we introduce DEVLINK_ATTR_DRY_RUN support for flash, if we then =
want to introduce it later to something like port splitting.. it would be a=
 valid attribute to send from kernels which support flash but would still b=
e ignored on kernels that don't yet support it for port splitting?

Wouldn't we want each individual command to have its own validation of what=
 attributes are valid?

I do think its probably a good idea to migrate to strict mode, but I am not=
 sure it solves the problem of dry run. Thoughts? Am I missing something ob=
vious?

Would we instead have to convert from genl_small_ops to genl_ops and introd=
uce a policy for each command? I think that sounds like the proper approach=
 here....

Thanks,
Jake
