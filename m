Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F16E56FFD6
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiGKLNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiGKLNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:13:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49195F4F
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 03:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657535199; x=1689071199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tmKGD8UXBOccTszX3ZLIuzaRxXlYc6QQF1o25P0xExw=;
  b=ODw5vr6ZQN1UHmZDfOtMAy+eQnJQy5p1b+raZZmFTH83B9Vj4GDJzH85
   dtJlkuPbBTzCY+2ZJBeLXAY/lfKhRd/JUO9fNHohqpGm0BUYMmZJOoAb5
   YBuXSCqSVq6qDuxicyWYZu4skc9MbhzLhA73P9oSR/W0bTs/0xBuc7TVa
   bZNRugxDkDMJ9868u9iXWxumC9BqCemyy9yF0NfSFZBsEftsTMmigIXHy
   UkSunWKsGfTZ9o/rmxmiGmjwyRpnUlVUEtG4fR5denyUtGn0NirhEtrUI
   L0T8Wwcs7M7Vl0RnStSa8KvcDDQlQi3UFo6cPDoJChPYGEEQEX5Ob1jSH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="284653971"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="284653971"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 03:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652400756"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jul 2022 03:26:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 03:26:24 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 03:26:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 03:26:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 03:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FymWCk+ehkdV6+v0wJi5ujnTaKsJlPw9fnChlbiD3rfWC8k2DfxKbzvtAG9J2HD/kiDsrw29xv05MPI744cmYPL0LAcyqMBiVQdLNedaxn/yr0NRWVnbFCIaMRWL0pE1TrZcC1zIvfiLijeEmXCocoFf3T9cH4/BINPTbif+xXAKtF1OHN6q09gW+Ett0G5hQub7u5wxtlch+SEgv6woWkmgTUGkx+H2B9h860XO65ADM5Hxzrc3t0tJyYmjqd0vRxqdINNa1pnYHBxGxLkJBx4KwU0E3XWrlMn2tTK3rGnD1avOJ+ego5u7CRTxqVYZVdIAyEqfFIK9arCGEoQFnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+MRsnsJ0FufK6clB117BKcSboW3Z/uSxlB9cFZm5J0=;
 b=fv/SGEffsiJx44hVhTWpYaSiPTRUXHBEs0GXA9RCDhQM6wgv8J+/nSVF62rfmKPDEGUNLn5X2KqWwzoirDXYZBaNB3EBYG2j2D+d7z6idu0p9KeekC+N2ppwQxM1F34tmpE1ssboswAy5k4fPjeZdpqdN/GJzp8YbLAAtqJVYSFPBHDbaZSQCTGsyjrAEvu9dQjBaOYsBW5iEnq0b8Mrtz9X35Q+lJzS7N039DkOIzItMmp85KCA4w/750oNrkIxmetuLwcaY4d+3duCj/Yc4mWZmQuw/Sj0kiFQHMxN6E1iA8eN1wJltjoxXnQKD+o57rkHl1fMktON42bEfvMeyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Mon, 11 Jul
 2022 10:26:21 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5395.021; Mon, 11 Jul 2022
 10:26:21 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "mostrows@earthlink.net" <mostrows@earthlink.net>,
        "paulus@samba.org" <paulus@samba.org>
Subject: RE: [RFC PATCH net-next v4 2/4] net/sched: flower: Add PPPoE filter
Thread-Topic: [RFC PATCH net-next v4 2/4] net/sched: flower: Add PPPoE filter
Thread-Index: AQHYksXJqrq+szQLGEKenHEPzMd5aK102rGAgAQgaeA=
Date:   Mon, 11 Jul 2022 10:26:21 +0000
Message-ID: <MW4PR11MB57763D75A50EF9CF369C0EDAFD879@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-3-marcin.szycik@linux.intel.com>
 <20220708192253.GC3166@debian.home>
In-Reply-To: <20220708192253.GC3166@debian.home>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c434c55-2cab-4e06-0eff-08da6327ccac
x-ms-traffictypediagnostic: SN6PR11MB3504:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dE/1ASSGl7B73m38D5x0x1G+gnoM1zdTLO9zRhdfjJ0Q2e8XmSk3VOun7XPRT9tG8L1GoALtoYgL8sKJXdDB7AMmLcuempPmsktmi1wlCwPvN1kcKG/Z/n+uO3+lM1REpEhDzfC6XRgG3o54fR0jqhO+ovCjrOY1iHbRtt13SiLI+sRoXX9FmOd5l9dT8TN6LtlfiQB8m612JR7gUrdTOUQVbPOWPAASfx5R/LR4eok/IbhEp695BTM57I9xzpOcP8w83Bxcxu6Pp4xYPOWZI5VoEzUNmkA9ACgmhcpfdSPzYvE0zkSPZa1tC32Fyqfl2deQKh+FsGw/85fk087a7T2ftumiKX4zkJFEpoMep+CJhwrS45mXfxFy649NK+OY1JCVGJ/WrliARwr4R3lPSvJsfmH6lv8z4MtaDrs07z6TGMOcVffJV3/MijXkXdx6QWAyq/bf5AFHrQNobt0YCedh7j6HoxjyW6ZtKu+US+j8kN+8ZegbtzNH1TdVR39ZCk1vOKXS34np2g7LH69ydilDhA32TqL3WXBVH/2YWiFL8VUElhojcqGpWaxGScpSl6nr/0rJqIJTGnQSOhaPbHvfD2mWp6QGTserRHB/9hH9ZNmUj9vblhF9Z0K0dCIrNcFaVzKIdCOg4iY54m/qJB17hLzI84b7Y4eT85l1RDhGqesKsjY+tAtEqeEdYJpnNwjOEJPpyuXxfoBSA4eQfpw7COGgnZtjav6lZY4EoRxvsEY+tjY8Uwc3zSbHdHFX8Qz8+1qUjA2hlZdbEfYu4lFpgu/DIFJ3klBGEnAEY+qpiFd9a4NCrzfaxW26wHvA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(346002)(136003)(86362001)(478600001)(6506007)(2906002)(26005)(9686003)(41300700001)(53546011)(38100700002)(7696005)(52536014)(8936002)(33656002)(7416002)(5660300002)(38070700005)(66574015)(83380400001)(186003)(82960400001)(55016003)(54906003)(110136005)(122000001)(8676002)(71200400001)(76116006)(4326008)(66446008)(66556008)(66476007)(66946007)(316002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?AAwsNTFBYgwvyyb+fghxuxWczgiuAUP/TAokHggKXjw6FjO4Hw2HSzKhn+?=
 =?iso-8859-2?Q?W+Bv/mzNMFOxbPFG5uzjo/PkBzcxy9jtTK0e+9EXR10wyfSIFw5WG2qoYK?=
 =?iso-8859-2?Q?fb94Zynw3rpPTW0KKa1SqoVw6DhFENYdvs+dKTjjjLOEVas7ZoM6dKkjTX?=
 =?iso-8859-2?Q?RMcqeW4W9poOGIQPiq10QKKP5tiog1u6H/DhvkEEAG6EF9grq2S5GcDgGH?=
 =?iso-8859-2?Q?jHkdddRyXzk6OrOyCwrekFz/hGFQEvO6MCqPH4uM1pC1sheqmPS/x8e4tG?=
 =?iso-8859-2?Q?z9NBOKxmQe26YSjcL1If39LM7HTKxPKYFQ2HOW2wO337Ijxw1eu58oXSu8?=
 =?iso-8859-2?Q?QempBVy8uyRoyzR3eei4JC9GUcEmKns7FCkvyJZDGA70U7eb8AH733vieh?=
 =?iso-8859-2?Q?G1POhWc2/Vx6HvM3y/FGGu5al22BVpX/xYFH91Nl+e1aYKxPT5EF3HpXBW?=
 =?iso-8859-2?Q?rh0kEwWoHlPYnasyEZnKA+FIRHSXaw+7XJYBuw7CFLpH2EJdllv8K0zb7D?=
 =?iso-8859-2?Q?+Si82meB/pkRnhLXsoQY6b/+Iq6QTJU7CBlLqWa4EUoT6O13YsDu0bjeHR?=
 =?iso-8859-2?Q?9zDqCyVWkoDVqYSLt1X0vIc4MAexDu3KCJbKCN/irK/3mZnYLlrfB++Ycy?=
 =?iso-8859-2?Q?7GMFqLD4jTq31L+2kAcKrj9hAvNYQektiNIIjXeudrYtuEi7F1CS7tM6Jp?=
 =?iso-8859-2?Q?C8puGNJqKRJbvqQE1Ekiu3SFFdNMs8/IsegwrhH44Nz93AetNVeOlFFOBH?=
 =?iso-8859-2?Q?F+23Ghoo3D7rOzBy1jy3iYptILD9drqlUvu4GmcT0HJu5tVqzmozmmk6SS?=
 =?iso-8859-2?Q?zQFS/gYVvzE3pv+25LlnQwX3gMkiNqCcAY4au/Ao9N7m+rxA5KvdofYF6r?=
 =?iso-8859-2?Q?y/vUuX9mC5IaXyScMdKfXXO2siurS1/yG9g+4yraeeDr8BBtAo/5tOWPKu?=
 =?iso-8859-2?Q?RP7bQzWQ4Q6V4x0xX+wJd3fEGhPAC+1OO13Y2If3qbHdjZ95xVkWAqi6L2?=
 =?iso-8859-2?Q?BhL8f/79c2cMvNS/jFgqaooXVG2Nm5INd8G1DMSDKdm1fr/ssnP5AfVzuL?=
 =?iso-8859-2?Q?l3QzMM7BNosr6426mUNgge7oSM/OHnQmsCLuVnbdgP0odJWcPo9Dyp3rcT?=
 =?iso-8859-2?Q?vlX8OfKYcgDDgRk2MyVztfWIQfzZczXb2M02OGlbcV3SkgtxdaICUSFGsx?=
 =?iso-8859-2?Q?28sUX85GIl4qJK9aq+nolR8uuJuYp2GjUJsLFCAO5EAEcIBLNjJHSo421W?=
 =?iso-8859-2?Q?AopQGJhHT/vyJ5Gtb2UxGNT2yi7M/p39qvvhbf92bJ+RU/Z4NffR246dZS?=
 =?iso-8859-2?Q?4g1agLOOhmdgHiXLSgjzXNt6jrLc2HiQOTSTObcm0idsaImVwFygJHSSyk?=
 =?iso-8859-2?Q?+cyyivTxejpvJU515xCvTfwtjbkVveJw0+PEDoAmnzT1OmiOEB/4G0HVQJ?=
 =?iso-8859-2?Q?11M2/SY8K24RueOZM2HjAvU1GO5C5Xra0S0NPzLIjLOFglgMza5BTubkTq?=
 =?iso-8859-2?Q?ppSzlg86WMsXPlY6rNamsR46/pmXrCmUbdAjpazEe0JzKurvMHQDORbnvX?=
 =?iso-8859-2?Q?U+5gHQM9RMSqTLlTspeATe/RN8aJ5V5nM5Z0/ojqcCcoztOXmXmBz352xj?=
 =?iso-8859-2?Q?jbtzry3bvC4ct8hMDql2wTKRz/JqQophB+?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c434c55-2cab-4e06-0eff-08da6327ccac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 10:26:21.4424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nnwEuA2waLXUThRIqPFraqg0nGmH8P9Rh4vKw3woyCQTF1rtiIQ0aqgM2tv47dZBq+S/xoSfvbK/X3/oTqUtEzqcNeMPVV/nS9O+hsE///o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: pi=B1tek, 8 lipca 2022 21:23
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com=
>; davem@davemloft.net;
> xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.brandeburg@intel.com>;=
 gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; edumazet@google=
.com; kuba@kernel.org; jhs@mojatatu.com;
> jiri@resnulli.us; kurt@linutronix.de; pablo@netfilter.org; pabeni@redhat.=
com; paulb@nvidia.com; simon.horman@corigine.com;
> komachi.yoshiki@gmail.com; zhangkaiheb@126.com; intel-wired-lan@lists.osu=
osl.org; michal.swiatkowski@linux.intel.com; Drewek,
> Wojciech <wojciech.drewek@intel.com>; Lobakin, Alexandr <alexandr.lobakin=
@intel.com>; mostrows@earthlink.net;
> paulus@samba.org
> Subject: Re: [RFC PATCH net-next v4 2/4] net/sched: flower: Add PPPoE fil=
ter
>=20
> On Fri, Jul 08, 2022 at 02:24:19PM +0200, Marcin Szycik wrote:
> > From: Wojciech Drewek <wojciech.drewek@intel.com>
> >
> > Add support for PPPoE specific fields for tc-flower.
> > Those fields can be provided only when protocol was set
> > to ETH_P_PPP_SES. Defines, dump, load and set are being done here.
> >
> > Overwrite basic.n_proto only in case of PPP_IP and PPP_IPV6,
>=20
> ... and PPP_MPLS_UC/PPP_MPLS_MC in this new patch version.
>=20
> > otherwise leave it as ETH_P_PPP_SES.
> >
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> > ---
> > v4:
> >   * support of MPLS inner fields
> >   * session_id stored in __be16
> >
> >  include/uapi/linux/pkt_cls.h |  3 ++
> >  net/sched/cls_flower.c       | 61 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 64 insertions(+)
> >
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.=
h
> > index 9a2ee1e39fad..c142c0f8ed8a 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -589,6 +589,9 @@ enum {
> >
> >  	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
> >
> > +	TCA_FLOWER_KEY_PPPOE_SID,	/* be16 */
> > +	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
> > +
> >  	__TCA_FLOWER_MAX,
> >  };
> >
> > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > index dcca70144dff..2a0ebad0e61c 100644
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/in6.h>
> >  #include <linux/ip.h>
> >  #include <linux/mpls.h>
> > +#include <linux/ppp_defs.h>
> >
> >  #include <net/sch_generic.h>
> >  #include <net/pkt_cls.h>
> > @@ -73,6 +74,7 @@ struct fl_flow_key {
> >  	struct flow_dissector_key_ct ct;
> >  	struct flow_dissector_key_hash hash;
> >  	struct flow_dissector_key_num_of_vlans num_of_vlans;
> > +	struct flow_dissector_key_pppoe pppoe;
> >  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons a=
s longs. */
> >
> >  struct fl_flow_mask_range {
> > @@ -714,6 +716,8 @@ static const struct nla_policy fl_policy[TCA_FLOWER=
_MAX + 1] =3D {
> >  	[TCA_FLOWER_KEY_HASH]		=3D { .type =3D NLA_U32 },
> >  	[TCA_FLOWER_KEY_HASH_MASK]	=3D { .type =3D NLA_U32 },
> >  	[TCA_FLOWER_KEY_NUM_OF_VLANS]	=3D { .type =3D NLA_U8 },
> > +	[TCA_FLOWER_KEY_PPPOE_SID]	=3D { .type =3D NLA_U16 },
> > +	[TCA_FLOWER_KEY_PPP_PROTO]	=3D { .type =3D NLA_U16 },
> >
> >  };
> >
> > @@ -1041,6 +1045,50 @@ static void fl_set_key_vlan(struct nlattr **tb,
> >  	}
> >  }
> >
> > +static void fl_set_key_pppoe(struct nlattr **tb,
> > +			     struct flow_dissector_key_pppoe *key_val,
> > +			     struct flow_dissector_key_pppoe *key_mask,
> > +			     struct fl_flow_key *key,
> > +			     struct fl_flow_key *mask)
> > +{
> > +	/* key_val::type must be set to ETH_P_PPP_SES
> > +	 * because ETH_P_PPP_SES was stored in basic.n_proto
> > +	 * which might get overwritten by ppp_proto
> > +	 * or might be set to 0, the role of key_val::type
> > +	 * is simmilar to vlan_key::tpid
>=20
> Didn't you mean "vlan_tpid"?

Yes, is vlan_key::tpid not clear/valid?

>=20
> > +	 */
> > +	key_val->type =3D htons(ETH_P_PPP_SES);
> > +	key_mask->type =3D cpu_to_be16(~0);
> > +
> > +	if (tb[TCA_FLOWER_KEY_PPPOE_SID]) {
> > +		key_val->session_id =3D
> > +			nla_get_be16(tb[TCA_FLOWER_KEY_PPPOE_SID]);
> > +		key_mask->session_id =3D cpu_to_be16(~0);
> > +	}
> > +	if (tb[TCA_FLOWER_KEY_PPP_PROTO]) {
> > +		key_val->ppp_proto =3D
> > +			nla_get_be16(tb[TCA_FLOWER_KEY_PPP_PROTO]);
> > +		key_mask->ppp_proto =3D cpu_to_be16(~0);
> > +
> > +		if (key_val->ppp_proto =3D=3D htons(PPP_IP)) {
> > +			key->basic.n_proto =3D htons(ETH_P_IP);
> > +			mask->basic.n_proto =3D cpu_to_be16(~0);
> > +		} else if (key_val->ppp_proto =3D=3D htons(PPP_IPV6)) {
> > +			key->basic.n_proto =3D htons(ETH_P_IPV6);
> > +			mask->basic.n_proto =3D cpu_to_be16(~0);
> > +		} else if (key_val->ppp_proto =3D=3D htons(PPP_MPLS_UC)) {
> > +			key->basic.n_proto =3D htons(ETH_P_MPLS_UC);
> > +			mask->basic.n_proto =3D cpu_to_be16(~0);
> > +		} else if (key_val->ppp_proto =3D=3D htons(PPP_MPLS_MC)) {
> > +			key->basic.n_proto =3D htons(ETH_P_MPLS_MC);
> > +			mask->basic.n_proto =3D cpu_to_be16(~0);
> > +		}
> > +	} else {
> > +		key->basic.n_proto =3D 0;
> > +		mask->basic.n_proto =3D cpu_to_be16(0);
> > +	}
> > +}
> > +
> >  static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
> >  			    u32 *dissector_key, u32 *dissector_mask,
> >  			    u32 flower_flag_bit, u32 dissector_flag_bit)
> > @@ -1651,6 +1699,9 @@ static int fl_set_key(struct net *net, struct nla=
ttr **tb,
> >  		}
> >  	}
> >
> > +	if (key->basic.n_proto =3D=3D htons(ETH_P_PPP_SES))
> > +		fl_set_key_pppoe(tb, &key->pppoe, &mask->pppoe, key, mask);
> > +
> >  	if (key->basic.n_proto =3D=3D htons(ETH_P_IP) ||
> >  	    key->basic.n_proto =3D=3D htons(ETH_P_IPV6)) {
> >  		fl_set_key_val(tb, &key->basic.ip_proto, TCA_FLOWER_KEY_IP_PROTO,
> > @@ -1923,6 +1974,8 @@ static void fl_init_dissector(struct flow_dissect=
or *dissector,
> >  			     FLOW_DISSECTOR_KEY_HASH, hash);
> >  	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
> >  			     FLOW_DISSECTOR_KEY_NUM_OF_VLANS, num_of_vlans);
> > +	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
> > +			     FLOW_DISSECTOR_KEY_PPPOE, pppoe);
> >
> >  	skb_flow_dissector_init(dissector, keys, cnt);
> >  }
> > @@ -3051,6 +3104,14 @@ static int fl_dump_key(struct sk_buff *skb, stru=
ct net *net,
> >  	    fl_dump_key_ip(skb, false, &key->ip, &mask->ip)))
> >  		goto nla_put_failure;
> >
> > +	if (mask->pppoe.session_id &&
> > +	    nla_put_be16(skb, TCA_FLOWER_KEY_PPPOE_SID, key->pppoe.session_id=
))
> > +		goto nla_put_failure;
> > +
> > +	if (mask->basic.n_proto && mask->pppoe.ppp_proto &&
> > +	    nla_put_be16(skb, TCA_FLOWER_KEY_PPP_PROTO, key->pppoe.ppp_proto)=
)
> > +		goto nla_put_failure;
> > +
> >  	if (key->control.addr_type =3D=3D FLOW_DISSECTOR_KEY_IPV4_ADDRS &&
> >  	    (fl_dump_key_val(skb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
> >  			     &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
> > --
> > 2.35.1
> >

