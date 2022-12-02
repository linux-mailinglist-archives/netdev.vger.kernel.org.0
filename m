Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CC76408C8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiLBOym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiLBOyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:54:40 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9A7D2D84;
        Fri,  2 Dec 2022 06:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669992879; x=1701528879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XYVYV++pUMEPUSmEW/xk+KTmynfETsgYwnoqcJvi6WY=;
  b=h4e1qjC1iC2IE/aE2rZc1N8wCwp/gDJdyAP/A+SSGTMyIL9eP9yck637
   26nUYqfhe5+h9E+aro9afYVLWUiQwiQ2GRSei95/uQNz4C4LM5aitMxAq
   BM88MqJbENR1LQKYQ0OOExaweAZ140y7FDHeD/CkadtdLi01DPlxc4uDP
   24qiuOUBfyHFUS/k+VtENPPHGVEGEd0EodkaP+OH4hKYM7KepL8Yv0VeD
   vq8HqbX1aJHBT6qzJK/N3e/tgL22c1RALJaPrLgsaxENUJvtfjjX9xTec
   XJ2/w44Bryh8IcXAqjGQ1xzZgmePTF/Jy1WhJqvWCGRGamb/2u2icniw/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402247367"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="402247367"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 06:54:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="622722114"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="622722114"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 02 Dec 2022 06:54:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 06:54:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 06:54:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 06:54:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 06:54:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtgEfrNkTN7KAMRc7vq6fLoWGy0cILTg/7eXG60WcVrajjInWvFclVzW2AFy7PKu0GKuhA3kLOESWm3Dgp5biczIAGUVbmuBYgdw/VyeA2ANl1qSN8EIBKD3bSOGdOBBAIxonvzuKEwragXKNS6Ud2Ke63FXh5tWVF0MjPp/9114lq4SP6Uxe5naIVa2taE5Cvb2pA5L/SA7O0Q4+CAaXPF/INVyrvAYsmo1QQazbyqv9qWAvQz6Pxnxro1GgbRZMw6+vGUUrPdxM9ZPBgINXAY6IHwjXIqjNozkWqIvGAbyLOHxjOh/GDn6KRFGdJtnForMMHGdlwuKOJ9+HkVEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmM6cXq5ad5yoz0MINBbBiWfPWq8vjI4dCJG0f0cn+E=;
 b=YtpPArpYUq8O5BLIZ1Qp7ubJRihTE056OQV1PONXIavbv2ITXMd+OsP/wLPLxTpcYW93KlSqUQt7jK6u2ddCfUXPXJ2B54tnMUuz6cHDmN4sReaxfTeRPLvGCa89zyUaDUvwC/mwwnHbkgeQN5+n2AwE0RGHmfjxkRfW0T0O2MYQBAWkid11xmJjNpv1RokZj/5/8two3ExBpxbn23VhhiyQJjJrsDwP61/TAAsqR3ueaAh3bYTr7Bszrs0ME4IYFtKbp6TEf+EJBQdjdZioVy7Ap2caUe98++9aeKXkO97Ouwbdi3md4qT0kzpBnuvI550Ozi3HhphyPTuDiV+ylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BN9PR11MB5530.namprd11.prod.outlook.com (2603:10b6:408:103::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8; Fri, 2 Dec 2022 14:54:33 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 14:54:33 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZBDrzHhOO6jCKv0uW33ic8hB1f65Xq5eAgALEiZCAAB2ugIAAIBXA
Date:   Fri, 2 Dec 2022 14:54:33 +0000
Message-ID: <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru> <Y4eGxb2i7uwdkh1T@nanopsycho>
 <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4nyBwNPjuJFB5Km@nanopsycho>
In-Reply-To: <Y4nyBwNPjuJFB5Km@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|BN9PR11MB5530:EE_
x-ms-office365-filtering-correlation-id: cc8bc5d9-e545-4bd5-103b-08dad4751fd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +PShc1aGAyDfKi3YEvu/I5lKO5NNwhPSkkl3dgPcFUZiznvEvn09nfjICqis16NdUmgfbHlC+SDXulJ+bO/hpE/gLQGtwevteFth4gdiDf5tiNcpOWvyq4S8sqCTGLw3Wg5gYJQBIiv2c3Ieq5aosg7kAf1hrLohmh4q34mHmRHzKWRuticZDhfkAnIW/dpLI3U1sNWUvcDuTjeZwcDG6CUkyeiSAQa1vPNJO+FvJrOfViYVnM9U3NN2FLPJXQn8T9Y39QOSZZnnSUU3D8chU9Ep+ylDRlSiIpUgRetDkpEHv1NpVBJyqRW0qHxZKepK3TPqRieBhBtB8iyZq9Kcm50kpu66ubF9rf3uVf4AyTCtQXVTyuMP2vtDLm7M2jPIh5t0Csz4jnRDIvPHJqTPtNQ72OdoHNob0wxnjD1bwX+L59ulRJWffe/ZZ1v11micBAPIJfmDULZqHQFD3yl2qLhixg58vA7FD52gKe1KQ7y5ycTZpJ8tY4CNzFPJX/aqJ1M0SUdN/1uZggD/k4f70MRjtjyUst6M02jwCgT8wvN8WahP1yn+9RwbLwZZb3/LK+my/xJfZgculNrlm+bixqctrasQ6nPvUkMZj8D7x/pnG/CROa6Urpqs4zNiI/GEIj7JSQbxd4hj/NE9C0iph9mCEbYofFdDmxcu6V00UW1BaP/H+S0b9OFG9R/7jnLlNaQ0gEXSsBWXLLNkpDJJvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(33656002)(26005)(478600001)(86362001)(7696005)(9686003)(6506007)(71200400001)(55016003)(38070700005)(82960400001)(83380400001)(186003)(38100700002)(122000001)(52536014)(76116006)(66476007)(41300700001)(107886003)(5660300002)(66446008)(66556008)(2906002)(54906003)(64756008)(8676002)(66946007)(6916009)(8936002)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HMxh62/Uq89IgiEjUANX0WzK+2FeFGmYdAPmu1vyjUlvmbasv7E8HRutVaFa?=
 =?us-ascii?Q?eLBWDKNSajKhkknT6FfueTA1YxQhEoAMUlDB1iWbqSFEzxk9SRSYbfF5txfb?=
 =?us-ascii?Q?FCu+uujSaPYoVWWbodF1msZ9kvBSwKHQLoV2LEjiJE7WU2OBFPlOXbuP/1uj?=
 =?us-ascii?Q?pvNl2qPbRi8WIeP+hLXx2hShWIkKyY9Fr6I4QhvKcV327ALXqYJUTGtuMIQm?=
 =?us-ascii?Q?S+NTqMTJWAeYEzdztBUm6Z/yEBg7Ew9At27XK64wmksaJNoAapgehnKNp3mK?=
 =?us-ascii?Q?N+923TET0YqnhBBvkzoavJRIa0tLabfSxddbJgiLnbUl4Fcpn2qtclZaQSJG?=
 =?us-ascii?Q?sqRhppK/PTrdrCS8ArlFiqvq4kosWh//y4DJSkeHwMVx02TyaHX0apHVkxnz?=
 =?us-ascii?Q?MQSDyju50p1phcjPhyv+Jd45m2KSY76zkPmik4yDPLay0vOSXXvqfnmdQMId?=
 =?us-ascii?Q?kmsQMQL4nXgupJhE2Lc4JFPWsUpGED/VBl1/ughQXhLqrIxa2/Vs85UJ3lVr?=
 =?us-ascii?Q?UJu09bTpNGtLbTFWOsI2Cisb8Ric/3mZzuq60rCCECjuA28o2/J0W70B2SQK?=
 =?us-ascii?Q?foIRgfTFH8h+IrjbvgF7NmQ7qEaQwgiGX8CIsS0IBYBC2uoYHSH0YnOX9E/V?=
 =?us-ascii?Q?JfP26uIPIMmavP7B+JlSJ0FrVFqcRsba686wZcWzlsEbJLO1Acmy/t2YOqJc?=
 =?us-ascii?Q?KbN6S9LyjsJC8JF+vJ+tAvqnDBnfqup6mHohvetkIfQRJFwjRQ+o/1v67IuK?=
 =?us-ascii?Q?R3mTN6jg/JCIYAF8qPyWGnG9wpr+r0TA6/oMaQSYLHsL3qqycboc13pLeOqj?=
 =?us-ascii?Q?abm4zyn/W89w/+0KU2BvJtxNMZ37URRQpfYDuV2Srj4QjGzPYbPdPrdAlUOd?=
 =?us-ascii?Q?o2WntBVvtLnWLTclY5TqarPHmotOZDDKgjecBAP5VdGfymIeClY0U9QzaeUV?=
 =?us-ascii?Q?yPxaXLtpAeBQ3/fuzM7kT+ftuUHvGy/M+ecTsnL9A9Cde0H6TceNL18nrwlR?=
 =?us-ascii?Q?bqn02ztJWrwkFEuRwNt/L8TthxR9FHLn7LysKYNa4y9OYNUeVxDJKSPYEXt7?=
 =?us-ascii?Q?f0VFi9VdZpQl22bKAi1njkb07l7EAnMNvn/ff0kd4PyMUXsDQ1IAPr2+Cjvq?=
 =?us-ascii?Q?KHJEQy5eqqyg1qmZG3SkQqlqkt/KWeG6MsNLagpr7+irRo+BbtBLxg33u4wp?=
 =?us-ascii?Q?QGIhRC9jfmR3xA5p/LcqX/wF/u1xV77z09BmZzGcFTEpd2DTJdGw1AaqOOmJ?=
 =?us-ascii?Q?p/ezRFIjPT9199zXua4rW5tqSkcjOSydzP4NqCzsd6gJhgQCff6H4A83aE3L?=
 =?us-ascii?Q?KWLrFufo+THPZ4I0q5BOx3MpwIQfAQVZwH6hxgIlzFaFHsxyDcFS3CSrPJuj?=
 =?us-ascii?Q?yVju2p6ao146+EGQraF3SLXp5/9YG7Z3WTuSfscf11D5ARxCK/5aBuR3c5uf?=
 =?us-ascii?Q?RcJmaUJ699h5dpn3zlDswu4YMjjAf+OLJVu9pBlTtwxVqGD14gjbHDlvQNOy?=
 =?us-ascii?Q?KdLa+LzvWgUPxP4B/KLN/bC21ypwmp4aNTnYCtytFBT9Oi+9694A+n2L2IJY?=
 =?us-ascii?Q?s0QZaSDU9JL0OtchJwun5ObPm9GH29w/P4uYsisa60HYHXIK/AvD/9mjNtrR?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8bc5d9-e545-4bd5-103b-08dad4751fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 14:54:33.6261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjdgnPR9HNdfjYEA27G3zimA3h3nwwjqNyLqjw8fBtri0TMG/7wgHTOvAjZ7jNzz0YCl6xneqsvM1oE8BxsVLPVTDmrDeO6OREPdAOhmqFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5530
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, December 2, 2022 1:40 PM
>
>Fri, Dec 02, 2022 at 12:27:35PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, November 30, 2022 5:37 PM Tue, Nov 29, 2022 at
>>>10:37:22PM CET, vfedorenko@novek.ru wrote:
>>>>From: Vadim Fedorenko <vadfed@fb.com>
>
>[...]
>
>
>>>>+static int
>>>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct
>>>dpll_pin_attr *attr)
>>>>+{
>>>>+	unsigned int netifindex; // TODO: Should be u32?
>>>>+
>>>>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>>>>+		return 0;
>>>>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>>>
>>>I was thinking about this. It is problematic. DPLL has no notion of
>>>network namespaces. So if the driver passes ifindex, dpll/user has no
>>>clue in which network namespace it is (ifindexes ovelay in multiple
>>>namespaces).
>>>
>>>There is no easy/nice solution. For now, I would go without this and
>>>only have linkage the opposite direction, from netdev to dpll.
>>
>>Well, makes sense to me.
>>Although as I have checked `ip a` showed the same ifindex either if
>>port was in the namespace or not.
>
>That is not the problem. The problem is, that you can have following two
>netdevs with the same ifindex each in different netns.
>1) netdev x: ifindex 8, netns ns1
>2) netdev y: ifindex 8, netns ns2
>

OK, I now see your point what is the confusion.
Thanks for explanation.
But I am still not sure how to make it this way in Linux, if interface adde=
d to
netns uses original netdev ifindex, and driver after reload receives new
(previously unused ifindex) what would be the steps/commands to make it as =
you
described?=20

>>Isn't it better to let the user know ifindex, even if he has to iterate
>>all the namespaces he has created?
>
>Definitelly not. As I showed above, one ifindex may refer to multiple
>netdevice instances.
>
>
>[...]
>
>
>>>>+	DPLLA_NETIFINDEX,
>>>
>>>Duplicate, you have it under pin.
>>
>>The pin can have netifindex as pin signal source may originate there by
>>Clock recovery mechanics.
>>The dpll can have ifindex as it "owns" the dpll.
>
>DPLL is not owned by any netdevice. That does not make any sense.
>Netdevice may be "child" of the same PCI device as the dpll instance.
>But that's it.

Sure, I won't insist on having it there, as I said, thought Maciej have see=
n
a benefit with such traceability, unfortunately I cannot recall what was it=
.


Thanks,
Arkadiusz
=20
>
>
>>Shall user know about it? probably nothing usefull for him, although
>>didn't Maciej Machnikowski asked to have such traceability?
