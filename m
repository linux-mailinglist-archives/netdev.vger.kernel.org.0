Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7040250BF46
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiDVSC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236499AbiDVSCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:02:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE0B7F;
        Fri, 22 Apr 2022 10:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650650394; x=1682186394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hMAWaNQf7SYeKHemBs2tGQ7Tt441fpsEPPhDRdQY7Ks=;
  b=J3EE93WZKb2VvFMo2sP83/hI6M0NlL26il397HoXiyiJtZj/vldVZt65
   mT8huMFVas1xuKgGl52XJPP+YIiHgwytc45Yrz3JdKw9DTuCl9CUomqf6
   nvpEF3YtiUtArybt+3eqPaUsX/FBj5QQVkC2WojwjpLPHcnX3204RSg66
   no6/qsZWLIKIy0ZtmZeLijVWAMPyEaQn35J9nrabzyXXuU949a8n9qGuY
   KAfRUbcreqTQMaCyXOKOuAS4w/g0YdXBH7mnmpO95okcRwKBDZcLn6/j7
   ToDphKB9LznhhOrUBqib4CjB4ZM9KamUXs5+UKanGB4stsuI26XBNopGL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264514191"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264514191"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 10:42:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="615504080"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2022 10:42:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 10:42:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 10:42:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 22 Apr 2022 10:42:28 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Apr 2022 10:42:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dibydvLhBkWnHH3xPVousOAf1vcxQB8nkzfyCt66nzOmkZvdXxS2bqK5sp9WyD1/7RG1P+N8ExzaBedhKyk16gOUvS028J+YGIPfw6I06Q+2QuxYOVf1gLZJZpXftCtt1RNvrYhb4q49ZS9g/YRl/62i64Gqxt/hXVGogDaJB9NL8f6ahDectEwrwaifUea9iMuNF6CX8ncX5MjCfQmOJx30fB5faU+bY/TNdcO4s8Xkx5tTfSfpLHONQRL3hGdAO9xToYqW7NicaSOX9ZfW7ka45NP2wG6lOYOCecJw3fE1yOn18WvDgQ7OBM7wexc/0VsWq7R7LTZ6oNawqTMtlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoadOg7K+K5NOuXbiMZSM3kSm9KbcOwxXlMWd3xSppo=;
 b=NeDlYiSYOP0nr4JeetZvXyWk8kAD+j0WZAVwnYT/vCxXOwb+5k3QLKoXvXzcL43lZ87Xr2Y8F2tPACIswMSyRxu9q1UbKm9iWTGPRottPaK1rn87MUjLy5eU5YAys1/rXKTT+7BPPWGi2RzIj5KWGCA0Gpn2eHugJmya6Gfn1YzzUa7RlytDXRa4ui9hV/Mc371ffZz7oFMP9Vy5sI4844Ve5+8GEAlHqhDL6KY5EO8bxfqJM3wuMRhKwm9zk3/o+5zEIRTR4oA44is+pynlJXRKobk+U2otevrXluw9Kng/nFuOC9NG3V0wp32CUu2+wxrvBeUpcyb5urX62FCrsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 17:42:25 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b%6]) with mapi id 15.20.5186.013; Fri, 22 Apr 2022
 17:42:25 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Topic: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Index: AQHYVUZcHI6VX+DIGkiO7KkonUY3tKz8NYDQ
Date:   Fri, 22 Apr 2022 17:42:25 +0000
Message-ID: <MW5PR11MB581100DBD307763A92012BEADDF79@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220421060906.1902576-1-ivecera@redhat.com>
In-Reply-To: <20220421060906.1902576-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9896047d-efdd-44de-02b8-08da248776b0
x-ms-traffictypediagnostic: DM6PR11MB4722:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB4722342DF74E1E7769BCC700DDF79@DM6PR11MB4722.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eirtnIz/NuC4t9BHHPfW+VQRHP0kt5vAaBBoff80fD5ZePKHwdID46WLX8VpQgPXAMQzinguBZ2kWmgBEIxy2yP3w890aGXLkCnw2snyZcXPSsk7v70C21cNDuo2crLaD8alwjtrX+UbaR0+lzTbrBtI4mmfj8yYgI8WMrW9k+J9zscnV97fwU/78/dYkmAXNuuk0vGk9bStlvZabQ3JX/RqX0CIr33XGRvvzpTl0VpIYhhCqoAhA1X6JnU90AgUgj8NNXfnj4n7fmav56XU4Vp1G6pqXoc+T3MZmfOvjrrBBaHDbnobbwG2xwbUlYiKPGzt18BhtxEmt/2zCpjgT0L2OxR6mp7ADv8qWRbK0CmQWfbPkIjKspnucnP8nUg1CSEFkwypOnICIt0ce/dG4yXbJRRl4ADKHMFilLI0JeBUkwyBpUnoQA7zOrJSmUx4wEaDUySrxypyY4+4venKveYSNs9HXWWSKZDPPW/d4wdGKlA/Ko5DHXz1cSRydC4OmySPzsmzv7nGIBmDuHxAGUpVA5P5pkvkIaurTC48THY8Bl4xm/7EpBc3kWEYrmfrD7l1qb+1v+8/l8Oubs6D7NfeFCD4Z9VkORxAu8p/v5PqtUGYjbkIgGsB6DDnbWsb/b1/bR9fWjYf5g/QmZ6mkz78BpjGYUkhzkolq/Flez1lXcJ/g7krju8FCijvIyfaWQXiJ7nMlib4aqRCJbjzVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(82960400001)(122000001)(38070700005)(5660300002)(55016003)(110136005)(66946007)(64756008)(66446008)(76116006)(66476007)(8676002)(66556008)(4326008)(71200400001)(316002)(7696005)(7416002)(186003)(8936002)(33656002)(508600001)(86362001)(26005)(2906002)(9686003)(54906003)(52536014)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n4jnOcRvYTS8GxYy20wGHYbjNB90oF257TVMybh0A5EfCNGOIsSFTdqJP2Lm?=
 =?us-ascii?Q?KIcX/ziO4NaSeGebCNCFWKx4836TZJejetTqswuPuKH5pRIqPN8CNat1rKwr?=
 =?us-ascii?Q?x5KBz8RBAQjqQhHY8XJius5opkCrVihkhh1EZu2s/SRt/jg/h8YTMax79dC1?=
 =?us-ascii?Q?6Ibodw7rA6vO1fsXv0r81Rqrdpg3J5kPQMENHxh0TjI3AanmF0VXGgGL8Nja?=
 =?us-ascii?Q?u/cIwiI78U4rFQS8uE+xtjWcUfOKGATIq3T6Dz5FQL7QlvL1LCJnk/AEvptd?=
 =?us-ascii?Q?ILp/TAQO70dXv5LzWNm+xLv7RcgfPCITUdILHFawF77sEpYyj4MWKDgWlYeC?=
 =?us-ascii?Q?+3bLpaOov6uqg4JI5zwjI1/1f1nW+DU++dgfmch5j6+5h6664WvCv124w5RM?=
 =?us-ascii?Q?MnSHjkYZlpXBpjui+tDUz+YUW8Us1f/ibu3bcUAoaZDR6+M8/jh/GU9jMMER?=
 =?us-ascii?Q?njIts4uue7UBnUg6WwnRUiCsolCoXAcprjHZx8rKAkERpQ/9H0vyrcpH9+gU?=
 =?us-ascii?Q?eaL7PxzvF+NYkuzHkkNnMHpfL+rkzw1RhUND2xwY6ezpL5K5xN8CvMEsNqHD?=
 =?us-ascii?Q?3X+AGEKrmfJ35km9T/jnsH0icSet32rDuWl5kLuEij+3lOn2+Ct76TcRQL1g?=
 =?us-ascii?Q?iKbBdlyBjwForGAo39GJilzDUxwFs3B+5V1P0nZlXDe+lnz3SqX9KrbTkB2q?=
 =?us-ascii?Q?EHdFnlDOqJhdWF0Y3YCzhF0xyXr7ABrcstjTQw7Un1JU6l4LWo7S+ZSdsmgG?=
 =?us-ascii?Q?P519M4uo8h+nXF4ynpXqLyOqCRTNkzuAEifBK19fgoZn0+TxEPhAtIFwt0Jn?=
 =?us-ascii?Q?BWCUAriGivcfQANM1MA7ixfMH+PrJEHxeRcYCwSv4Iq0rmcUgoV2ZxojmUhm?=
 =?us-ascii?Q?LfAKg0LLdsKh7hMg5o4V0EEj2hqH6Q2I5J756vJ+Mhi38UPTV7+5vEX/gwUT?=
 =?us-ascii?Q?BSv0+XuhhIixLvYOQHziZFZPU9XPbFmZQg+Yfe21bJRB0RfGAVowZvzOQqOQ?=
 =?us-ascii?Q?YGEp1CIoFmhj58uajbDuuj0BsYc0esKSL9yIW+EmhcYExQqPE2oeUnxm6q4Y?=
 =?us-ascii?Q?x413eJsY0U0dhak1oF99BKG4Tx6ZOzWRysi73Ig6CHzCU2evEnXTuony7Dob?=
 =?us-ascii?Q?psKsz/seOGpaySGybdBm1OGxMvReliTUaX2osS14pev9oDK7L5Q+AilbLjkW?=
 =?us-ascii?Q?+dhQcF2mfMBbjG1c/pHkJHsBvC3EXCuNHTN5sxAdEy8RguhN6zVWlf42rzRZ?=
 =?us-ascii?Q?KjPvaEqUSwWo7IBlhRzn9rrp5dO1V6SJoqUIbFBxbv9asjzxZeXR3iWW4uhm?=
 =?us-ascii?Q?f52otXqACz/DeTY42SEdu//7tD5CfLm0rCh41wfWYAkP9e0S2z+qs2lS8MfW?=
 =?us-ascii?Q?2w5WLNEFNnD9ZVMq6g+vHv6XPVz2b1taQXVPFWktA4B1F9CTt1S/B5XdyicN?=
 =?us-ascii?Q?gxNiSW4tETAPqlI52vwIRfY/vOtL+PK5jvwjORHSwOYzFyvH5QtAr0AR92YU?=
 =?us-ascii?Q?b9uUFdnteI5GZ33enAgRl9zmPQ5SS4yj5lmwAlunrXzEaTO9xKIi6EQ1wmVF?=
 =?us-ascii?Q?mv1Qbs/wMEIePe3pwE9nQ4ThKRN0PiagpdWwUndILo+a2dys+wkthcIouc8n?=
 =?us-ascii?Q?l5OTJmUlHa/ogWap5wQoyuGebgoPKh/n8asHUiR18p5arddivKhy/HcKZERq?=
 =?us-ascii?Q?GGsxafX0OXgu8YEzfcJaMdnb38ZwskRssVBQ+s1F7KNWarjmWuZNiTGPqF+H?=
 =?us-ascii?Q?g739cKbSDKx+aJhDcwjcs3sGobfdaJU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9896047d-efdd-44de-02b8-08da248776b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 17:42:25.6153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xNImXmsQ8zHLJWzplBctACf2BTs9l9m238KvRw6WOGeFT6lX7ldt7uQQfpE4IBib86D/M3tRZ3I9ollXYhwRhiSzjnUyS2wmA/bxWOICR4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Wednesday, April 20, 2022 11:09 PM
> To: netdev@vger.kernel.org
> Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>; Leon
> Romanovsky <leon@kernel.org>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Ertman, David M <david.m.ertman@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH net v3] ice: Fix race during aux device (un)plugging
>=20
> Function ice_plug_aux_dev() assigns pf->adev field too early prior
> aux device initialization and on other side ice_unplug_aux_dev()
> starts aux device deinit and at the end assigns NULL to pf->adev.
> This is wrong because pf->adev should always be non-NULL only when
> aux device is fully initialized and ready. This wrong order causes
> a crash when ice_send_event_to_aux() call occurs because that function
> depends on non-NULL value of pf->adev and does not assume that
> aux device is half-initialized or half-destroyed.
> After order correction the race window is tiny but it is still there,
> as Leon mentioned and manipulation with pf->adev needs to be protected
> by mutex.
>=20
> Fix (un-)plugging functions so pf->adev field is set after aux device
> init and prior aux device destroy and protect pf->adev assignment by
> new mutex. This mutex is also held during ice_send_event_to_aux()
> call to ensure that aux device is valid during that call. Device
> lock used ice_send_event_to_aux() to avoid its concurrent run can
> be removed as this is secured by that mutex.
>=20
> Reproducer:
> cycle=3D1
> while :;do
>         echo "#### Cycle: $cycle"
>=20
>         ip link set ens7f0 mtu 9000
>         ip link add bond0 type bond mode 1 miimon 100
>         ip link set bond0 up
>         ifenslave bond0 ens7f0
>         ip link set bond0 mtu 9000
>         ethtool -L ens7f0 combined 1
>         ip link del bond0
>         ip link set ens7f0 mtu 1500
>         sleep 1
>=20
>         let cycle++
> done
>=20
> In short when the device is added/removed to/from bond the aux device
> is unplugged/plugged. When MTU of the device is changed an event is
> sent to aux device asynchronously. This can race with (un)plugging
> operation and because pf->adev is set too early (plug) or too late
> (unplug) the function ice_send_event_to_aux() can touch uninitialized
> or destroyed fields. In the case of crash below pf->adev->dev.mutex.
>=20
> Crash:
> [   53.372066] bond0: (slave ens7f0): making interface the new active one
> [   53.378622] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes
> ready
> [   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.248204] bond0: (slave ens7f0): Releasing backup interface
> [   54.253955] bond0: (slave ens7f1): making interface the new active one
> [   54.274875] bond0: (slave ens7f1): Releasing backup interface
> [   54.289153] bond0 (unregistering): Released all slaves
> [   55.383179] MII link monitoring set to 100 ms
> [   55.398696] bond0: (slave ens7f0): making interface the new active one
> [   55.405241] BUG: kernel NULL pointer dereference, address:
> 0000000000000080
> [   55.405289] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   55.412198] #PF: supervisor write access in kernel mode
> [   55.412200] #PF: error_code(0x0002) - not-present page
> [   55.412201] PGD 25d2ad067 P4D 0
> [   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted: G
> S
>            5.17.0-13579-g57f2d6540f03 #1
> [   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4
> 10/07/
> 2021
> [   55.430226] Workqueue: ice ice_service_task [ice]
> [   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
> [   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff 6=
6 0f 1f 84
> 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 0f=
 b1 17 75
> 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
> [   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
> [   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX:
> 0000000000000001
> [   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI:
> 0000000000000080
> [   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09:
> 0000000000000041
> [   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12:
> ff1a79d1c7e48bc0
> [   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15:
> 0000000000000000
> [   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000)
> knlGS:0000000000000000
> [   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4:
> 0000000000771ef0
> [   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [   55.567305] PKRU: 55555554
> [   55.570018] Call Trace:
> [   55.572474]  <TASK>
> [   55.574579]  ice_service_task+0xaab/0xef0 [ice]
> [   55.579130]  process_one_work+0x1c5/0x390
> [   55.583141]  ? process_one_work+0x390/0x390
> [   55.587326]  worker_thread+0x30/0x360
> [   55.590994]  ? process_one_work+0x390/0x390
> [   55.595180]  kthread+0xe6/0x110
> [   55.598325]  ? kthread_complete_and_exit+0x20/0x20
> [   55.603116]  ret_from_fork+0x1f/0x30
> [   55.606698]  </TASK>
>=20
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Sorry for previous mis-reply - hit the wrong button.

LGTM
Acked-by: Dave Ertman <david.m.ertman@intel.com>
