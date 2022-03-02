Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23004CA603
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiCBNbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiCBNbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:31:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756DABA76B;
        Wed,  2 Mar 2022 05:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646227821; x=1677763821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SUwqbCLQ8HwS1l8aBlF8KP0JjVTh59hqRV1TXm8b9iw=;
  b=MJBOHFeJx4jrIH0zqSfJQkxqEADM0Sro7Wd7wkOyQrUAp61J1Bwnfnn9
   q20mPXBtnkXc87c/4IAGRzbUeBM6cjVMts5kWQ6VBPw0+kYGgVSDpgG8f
   kxjnJoiNzHRii59flo+cx2BJQKjtH2/ejU5Fc0emD2/Sycil0AZHYGNVL
   rOM59lRBXq0DgirofPy7/hIML548O2/K7QydlIzWRdAInx4S1+Di1++mE
   ECWAx2w0jgFgtVjySCI7wcf7eFYOQSglgHWOxEsfVgO/brg/bZ6aBtJcf
   MucCDD4SVgwlH/qXKFB5sohaf0sIypj5seT28dnARQif4bb58LDoWWcqg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="253592543"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="253592543"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 05:30:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="630411541"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Mar 2022 05:30:20 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 05:30:20 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 05:30:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 2 Mar 2022 05:30:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 2 Mar 2022 05:30:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpUc/EhTaYUb8DPOgO8SlV6Ndx0H1g6/we7QSFRlEbUT3QgK62obA45DJezo7E++uB/7iq1iq3HUWreuP6JKPjhFddM/cJbLMklJUxtm1cNnHhg1EDcgam2veQllv04MJqEQZ2s+bf1k/1hAx6WtQCw+vsUJTJn8/BJ19shr1Te03AdvTtE+lS5uOkqH+BndylI3eoNEOnbCTjGUnmmhdb/zgMLsWdqYVpEIEvjGhCebnpPsa4rJ+mGUDunfiCC+WEBztzauW//wtjGlQ6yBp9Cj7LwGZN3ynGruLYFzz+YI2v8LojIzKP+nIWyTUFgh4EJoMpz/V+UpyPCpZHCSrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCbxvb/xffL6o8FwZ3wTkZA1nXmgZSqHKZEsGPG+XGo=;
 b=AyEg2vgb7ZxHhbIW7OkpCDmYQtVAx3FrSuLZttLYKSXm2TCFyZO3pbDZEhJcsYDbuRjPfxg1Ob4dQOMcD7cqKcqgHlcb7sU4ZVi5HkAp/IQez2dG48bXwqKU6a/Ffj5dd45LbN2w113l2L1cA13gdnkT67zLjY5LLsofQdYsB9oTieGaf5SckW1zEV05vz5NkZvLOiHNzYjk2ez0sFluDIEhPbfY21eMlAF+J5pii0N9pRbvuYED5LHa261VE2UsULJISAIp728CYj/Sky6T+IQdgPUtjfm2GeMlxvodJZ8d5PcuvbiDA6W7jjBYZU3Y7GGz8zXZggek2DKnaL9MYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4102.namprd11.prod.outlook.com (2603:10b6:a03:181::20)
 by BL0PR11MB3348.namprd11.prod.outlook.com (2603:10b6:208:6a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 13:30:17 +0000
Received: from BY5PR11MB4102.namprd11.prod.outlook.com
 ([fe80::21b9:acda:39a1:2fbc]) by BY5PR11MB4102.namprd11.prod.outlook.com
 ([fe80::21b9:acda:39a1:2fbc%3]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 13:30:16 +0000
From:   "King, Colin" <colin.king@intel.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Chamberlain <mcgrof@kernel.org>
CC:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Hocko, Michal" <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@openvz.org" <kernel@openvz.org>
Subject: RE: [PATCH RFC] net: memcg accounting for veth devices
Thread-Topic: [PATCH RFC] net: memcg accounting for veth devices
Thread-Index: AQHYLbQc4Rbuq/ZYIUySV5ooMqdS86yrDNdjgAEJZiA=
Date:   Wed, 2 Mar 2022 13:30:16 +0000
Message-ID: <BY5PR11MB4102FBFC3E9FAA8371787C358D039@BY5PR11MB4102.namprd11.prod.outlook.com>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
        <YhzeCkXEvga7+o/A@bombadil.infradead.org>
        <20220301180917.tkibx7zpcz2faoxy@google.com>
        <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
 <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76f7a2e9-5219-42ff-d522-08d9fc50ca26
x-ms-traffictypediagnostic: BL0PR11MB3348:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3348827F52E5D50184C969518D039@BL0PR11MB3348.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kph1UDE+Eys1ohSMsQxKjb+V6MxvAlSAZoSZRSOAMHQrPDM/uZvIzfYPvAFIgV0cuHCY+B98J/SkAA8dgCjuKOegytErTQ2MGEXSM+J+AJtj7Irmqws6yp8fGHq1ta3VjP2ObPGq5j+tbHF/atBiJ5ODEEVChmXiua84pCVFziCnIuKOcV42qwvcJodI2wKbi9TEZh0pfstQMbn5vgvtQ17hdHKuU2dk/7xuTRqgRaVzdq0vRqjRvdQVfzQWwleL6XJnT35eI98Vnk2q/HqXh8aJPgZtn9rd/Zc05DZTV1kEeRc5ESSMehbdmY6N41MsATYikJMilj2a3++1M9JK8mwreNF/IRGVV4bk+vxjKKrppIxOxN6tNCWfkOMWu+J35RQi/RHv1b85CGU86eqKbu8bpt91KHEz6ZbJZ2E6a77e6uPrDsWkcsUtO1zYhDwT8mG3KNpINbS3Spgu2TXojS32cgi8prfcTmWqeUSSx+GF3bPth3+9qKTXqwydv5WfCDhz/nII9/3LZnDfPmG5oY8+9JKjHfq5wLr7198GgJtLAgzT2npYQj3RI8xfMiQpZLiWXfwc/dSChuW2uO1IzsYdO3f5wO4VL437TBHGxSs4vPp3xntIfVBGc1THdx1msQTlfmu7lkI4rA7Ek6Up5jidDcnfBpI3S+OW0+Y+WlGUbd/oGt3/9uIqtXTk8//850ORytGh1XO7+oOp9tlQCdp9nKt2INPttU9gS6uS0lszwz5Z2iccYWmywtoTUycSHXQR60CT6B2o6j0mrLAAfVyUwOC+kaW1KPQKeVdx+1ThiNfmDL+JZQHf513VTZqR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4102.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(6506007)(38100700002)(64756008)(66476007)(66446008)(66556008)(86362001)(8936002)(66946007)(7696005)(71200400001)(53546011)(508600001)(38070700005)(110136005)(52536014)(54906003)(316002)(7416002)(55016003)(82960400001)(966005)(5660300002)(122000001)(76116006)(8676002)(2906002)(83380400001)(26005)(15650500001)(186003)(66574015)(33656002)(4326008)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O45oI228W7jBei2TyfyyaUTCwfZQE1Bzl52BJ/FPWgN3UPmq0Xj/8Eyi4Cc7?=
 =?us-ascii?Q?DnFGWknXDvN4roK76BDy0x8oo1F3dgH7tRRzlI9nPJ1/uYtUJZPbcA5zNAQN?=
 =?us-ascii?Q?E5TCupzcWG2IfRtwOgOBGcvQfFLtTB8uAZNNLovZCfh1l2umnbTOSsZ+HO6L?=
 =?us-ascii?Q?Z+HBRQtJJdkBia8VE7YUvKRrr1gCRBb3GdZblQ8wiovFs8wvFPbBNkbSyQmC?=
 =?us-ascii?Q?3+M3Qj7pwNfl1hfClOQYYfR8f5KT5ePolqon8lhTp1A9fV5zb73sqkOOXKVG?=
 =?us-ascii?Q?nOaNssLXL4AxpBMziKbrN2IVgy997Q8f3MY3xfDJis/Gn2JxeBXbHffvv535?=
 =?us-ascii?Q?zT8sjNsN0SuIEwaoL2ZGtYMyO4exT2qPSWUwwtUhi0iBLzDreY5GL/wV/UQC?=
 =?us-ascii?Q?zdnsSFCZJ+d4s4YecrvGK+GL4z2OpBkk9ZvfOMhlBHNcrckb2cvDaT9dqweU?=
 =?us-ascii?Q?CTit8Ku9hin0RBx3px5qFFAA3AIuLFOCDzv3b/w/qXxtX7v6aulLXpnpSVNn?=
 =?us-ascii?Q?Gkebz+0e8GXytallZ9vdfj20a1XTmhbF07dcKCcWLaxoBCmXUWN1rW3bSvba?=
 =?us-ascii?Q?GtyhqwgTkp4Ov9r7u8H9AH4f4ebSEqRIn4GXkBCxo0hD7CyO4lCoc0oxFPKU?=
 =?us-ascii?Q?oHDQuv81wx2/a5x0riJ0aj1bwlUTc5IBeIk1W2kT/DLvn+DugZaGKHS7dcG0?=
 =?us-ascii?Q?Zlo6Wb6UUhy/+c0W7zqJjHpxYHTjEZAvP2qf+XFdMB/uFhoK4gzQsptw9wv8?=
 =?us-ascii?Q?R8JQqOPyJ77uWBWbwfpgdEC7E9Na3T3JYlySw0Dv14qvslnlaeJxx/QDL1dU?=
 =?us-ascii?Q?VwJWJhmXbCK3sm4pe7it1Xo6ZsfeAJWNqQc23WsCNtttO/ngSQX+u/MpUG7w?=
 =?us-ascii?Q?SMtGuf5uHu27VSUDNTh6bSw5tzsCE3lC7FNO2Ma9fzBmLBGgMe/gir6r2RWL?=
 =?us-ascii?Q?mCj/Z4bdbe8nl9f2L1qwwhzw3G8hX/AKO4EZbsbQJTr3cH92JrUhBtUTB5+l?=
 =?us-ascii?Q?MPEPqRPJYivO9fHftaboZVUrMp0tub8B10fDe2MG2WfTfZSjhJbxTiCAra3d?=
 =?us-ascii?Q?l4yKSaBORFJZ4/fRc1sfM1I69wn1satgtgrTFTud2oIB02C2ThUsHhTkgzB+?=
 =?us-ascii?Q?dwmA3c6BDo6J34Y1gtWLCJNN9J65ZZLwtxTKvuC8JZnmIvsl8PQ39kx7RNz0?=
 =?us-ascii?Q?6rhUeqGoMYDs7QptDIuQzfrUfncE7yq+/EZJnsXu7JbCRyKSYsaDUTXpZ5u/?=
 =?us-ascii?Q?2BQW1RYfGBWuxYld5Jnlg277b1qcqh1CYdz21nX97mj2npfseeSlnCKGTrJ3?=
 =?us-ascii?Q?XHXKT+Lada8Ydjk9M2ZKyASORvlZTmxP75TRLtclIWKtKqfqz02hKlcS+P3V?=
 =?us-ascii?Q?xl8Z5bBudbTKjLYfQK6hIB8ABR8BWvonnzwjGm1TgcQvRRcEo2r/MsC9QLC0?=
 =?us-ascii?Q?tjfmy463nxTO1u86n2DEintpjinQd/YqiKsx4l+Izjr3/QuJb7QQGrunRL7c?=
 =?us-ascii?Q?0ozAl6rpS34G7z0S3UvHd+0WSmkj1XV3Z/SOWDKNLBH9vZw5PxY+W1JdhfQb?=
 =?us-ascii?Q?XikDPnBVglnVQ9tZLSL2D1WU2gCP9AxahIhB4w1SWLFfRY5OhXfTS0vHud0e?=
 =?us-ascii?Q?aID+Cujx8pacStuB/vDVC0Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4102.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f7a2e9-5219-42ff-d522-08d9fc50ca26
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 13:30:16.7667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bQ5sZbnDAusq1eismbRNsjhGiabe/dV1xWPSwgI+EH8kPndyKK9JfpalWA9c4+Lm30Jd/lQ/EdB4wXbeN1xP3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3348
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Just to note that stress-ng does attempt to set the maximum ulimits across =
all ulimits before it invokes a stressor to try and stress the system as mu=
ch as possible. It also changes the per-stressor oom adjust setting to make=
 stressors less OOMable, one can disable this with --no-oom-adjust and one =
can force stressors from being restarted on an OOM with the --oomable optio=
n.


-----Original Message-----
From: Eric W. Biederman <ebiederm@xmission.com>=20
Sent: 01 March 2022 20:50
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>; Colin Ian King <colin.king@canonica=
l.com>; NeilBrown <neilb@suse.de>; Vasily Averin <vvs@virtuozzo.com>; Vlast=
imil Babka <vbabka@suse.cz>; Hocko, Michal <mhocko@suse.com>; Roman Gushchi=
n <roman.gushchin@linux.dev>; Linux MM <linux-mm@kvack.org>; netdev@vger.ke=
rnel.org; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kerne=
l.org>; Tejun Heo <tj@kernel.org>; Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org>; Eric Dumazet <edumazet@google.com>; Kees Cook <keescook@chromium.o=
rg>; Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>; David Ahern <dsahern@kern=
el.org>; linux-kernel@vger.kernel.org; kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Tue, Mar 01, 2022 at 10:09:17AM -0800, Shakeel Butt wrote:
>> On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
>> > On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
>> > > Following one-liner running inside memcg-limited container=20
>> > > consumes huge number of host memory and can trigger global OOM.
>> > >
>> > > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ;=20
>> > > done
>> > >
>> > > Patch accounts most part of these allocations and can protect host.
>> > > ---[cut]---
>> > > It is not polished, and perhaps should be splitted.
>> > > obviously it affects other kind of netdevices too.
>> > > Unfortunately I'm not sure that I will have enough time to handle=20
>> > > it
>> > properly
>> > > and decided to publish current patch version as is.
>> > > OpenVz workaround it by using per-container limit for number of=20
>> > > available netdevices, but upstream does not have any kind of=20
>> > > per-container configuration.
>> > > ------
>>=20
>> > Should this just be a new ucount limit on kernel/ucount.c and have=20
>> > veth use something like inc_ucount(current_user_ns(),=20
>> > current_euid(), UCOUNT_VETH)?
>>=20
>> > This might be abusing ucounts though, not sure, Eric?
>>=20
>>=20
>> For admins of systems running multiple workloads, there is no easy=20
>> way to set such limits for each workload.
>
> That's why defaults would exist. Today's ulimits IMHO are insane and=20
> some are arbitrarily large.

My perspective is that we have two basic kinds of limits.

Limits to catch programs that go out of control hopefully before they bring=
 down the entire system.  This is the purpose I see of rlimits and ucounts.=
  Such limits should be set by default so large that no one has to care unl=
ess their program is broken.

Limits to contain programs and keep them from having a negative impact on o=
ther programs.  Generally this is the role I see the cgroups playing.  This=
 limits must be much more tightly managed.

The problem with veth that was reported was that the memory cgroup limits f=
ails to contain veth's allocations and veth manages to affect process outsi=
de the memory cgroup where the veth ``lives''.  The effect is an OOM but th=
e problem is that it is affecting processes out of the memory control group=
.

Part of the reason for the recent ucount work is so that ordinary users can=
 create user namespaces and root in that user namespace won't be able to ex=
ceed the limits that were set when the user namespace was created by creati=
ng additional users.

Part of the reason for my ucount work is my frustration that cgroups would =
up something completely different than what was originally proposed and sol=
ve a rather problem set.  Originally the proposal was that cgroups would be=
 the user interface for the bean-counter patches.
(Roughly counts like the ucounts are now).  Except for maybe the pid contro=
ller you mention below cgroups look nothing like that today.
So I went and I solved the original problem because it was still not solved=
.

The network stack should already have packet limits to prevent a global OOM=
 so I am a bit curious why those limits aren't preventing a global OOM in f=
or the veth device.


I am not saying that the patch is correct (although from 10,000 feet the pa=
tch sounds like it is solving the reported problem).  I am answering the qu=
estion of how I understand limits to work.

Luis does this explanation of how limits work help?


>> From admin's perspective it is preferred to have minimal knobs to set=20
>> and if these objects are charged to memcg then the memcg limits would=20
>> limit them. There was similar situation for inotify instances where=20
>> fs sysctl inotify/max_user_instances already limits the inotify=20
>> instances but we memcg charged them to not worry about setting such=20
>> limits. See ac7b79fd190b ("inotify, memcg: account inotify instances=20
>> to kmemcg").
>
> Yes but we want sensible defaults out of the box. What those should be=20
> IMHO might be work which needs to be figured out well.
>
> IMHO today's ulimits are a bit over the top today. This is off=20
> slightly off topic but for instance play with:
>
> git clone https://github.com/ColinIanKing/stress-ng
> cd stress-ng
> make -j 8
> echo 0 > /proc/sys/vm/oom_dump_tasks                                     =
      =20
> i=3D1; while true; do echo "RUNNING TEST $i"; ./stress-ng --unshare 8192=
=20
> --unshare-ops 10000;  sleep 1; let i=3D$i+1; done
>
> If you see:
>
> [  217.798124] cgroup: fork rejected by pids controller in=20
> /user.slice/user-1000.slice/session-1.scope
>                                                                          =
      =20
> Edit /usr/lib/systemd/system/user-.slice.d/10-defaults.conf to be:
>
> [Slice]                                                                  =
      =20
> TasksMax=3DMAX_TASKS|infinity
>
> Even though we have max_threads set to 61343, things ulimits have a=20
> different limit set, and what this means is the above can end up=20
> easily creating over 1048576 (17 times max_threads) threads all=20
> eagerly doing nothing to just exit, essentially allowing a sort of fork b=
omb on exit.
> Your system may or not fall to its knees.



What max_threads are you talking about here?  The global max_threads expose=
d in /proc/sys/kernel/threads-max?  I don't see how you can get around that=
.  Especially since the count is not decremented until the process is reape=
d.

Or is this the pids controller having a low limit and /proc/sys/kernel/thre=
ads-max having a higher limit?

I really have not looked at this pids controller.

So I am not certain I understand your example here but I hope I have answer=
ed your question.

Eric
