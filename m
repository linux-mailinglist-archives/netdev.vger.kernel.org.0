Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0A6CFFC2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjC3J0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3J0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:26:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D498CAC;
        Thu, 30 Mar 2023 02:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680168370; x=1711704370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6LAXxRlEcC0fNd/puZeTLV8Pz/6thDyxL5d8lGt0YtM=;
  b=k2KSxTkeSRD8AqpCeH29qMLtr1/pNXKi5JdNUyhNFQtHQeFlYmPO/KX3
   XD0wUVX7mmtXJqTP84MAmFydI8UP/tmoWzQiII4GCeuCE15OJa/kVoWvZ
   eRu7aFpVpGKJTDT6MA7BS+JZw+anDOZaNmQQ9baVfxoQo2CnrMstGEbO6
   SjXrtCXzrOG6YliO8fyUkJeqD5MbKFdZTZ5cOIBUJJ7edXsHR9EDwu7R8
   2tLtKE99oXUZ37v8NiO1IcVtkVLfVe7u3mbGQRucQlZR8r05vY6cNBU05
   2P9Xn+mM1qSO+R+xuNEtCTRkVzceZHWhzuWadZcsSp6i2mvHRXuXzsFDG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="427394614"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="427394614"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 02:26:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="858834069"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="858834069"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 02:26:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 02:26:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 02:26:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 02:26:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf8uQ1PlZnQvRNIscO2Hm2GQqUi6VaBukT/l4CburuvgA1efomG90U0INuSsoJqM3hkpBa7wWNIdjImyPzNZI/EN0KX5Jcz0g9FLPyLaFFJSRQiVnZ2zJqSRXWbJPDhrJDAp0kuGR0Skjk671mMqTlqFEAElC9Eib3Tc5VrQRCoGu2y044mxyuIHVetJJJFl5Ke1/o7bjYBMQsOaCll6mm85D7Y3NO+eUWrb03tq9Lk0NNUgKW17aKtKEwte1ZBXt61Pm+MEGH0LwK2p/ojMooTYO1B5if2V7L9qqLK03HyNAhW3smRsZyyGhtR3+b8CrOnk2UywjlzTL5K07FUCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLD5cszgpaTs0oWgdkw0l3eOUaOxBuixdsoFGiBlLDc=;
 b=OsWhRTp+9STFAc8IX0LJXzO2CukF0pd/LTke8es7i7tC+eTAivfRTMCZrfJEhzEC4Dfc+yKhet6aufwC8qYYYvW8/6PFpMWqajvAT83q2r44OCenrhl6jjooFaTlCBBdkxRzQyqIHWvbB34TEs63jFkacTbM0eG9tCf4esUTj6ppk3OX1ZWW9NnEqu4ZQ1H/ro9/nO/eDuEkoWFVnTkF68dEMM67PTY7X3PxHOjKpH9MJi42w8DsJwaa42igqy1dPHtAf2RUQ7xgFu+MQbT4qvG09RjG96x0psprHtqJlfVaumPfdGq2vGeMrEwP5VL3X93VwyB9C6gYf15Sj54tbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11)
 by CY5PR11MB6464.namprd11.prod.outlook.com (2603:10b6:930:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 09:26:07 +0000
Received: from PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791]) by PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::3912:3caf:a32c:7791%4]) with mapi id 15.20.6222.028; Thu, 30 Mar 2023
 09:26:07 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Andrea Righi <andrea.righi@canonical.com>,
        Guillaume Nault <gnault@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Topic: selftests: net: l2tp.sh regression starting with 6.1-rc1
Thread-Index: AQHZYjl1GRPOFSRp8EO/z00nY9tXgq8RxqfwgAAajwCAAAHa8IAAFiQAgADot4CAACws0A==
Date:   Thu, 30 Mar 2023 09:26:06 +0000
Message-ID: <PH0PR11MB57829AF31406D3EA4B1D9112FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRYpDehyDxsrnfi@debian>
 <MW4PR11MB5776F1B04976CB59D9FE41BFFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRsxERSZiGf5H5e@debian> <ZCUv+8tbH3H5tZKe@righiandr-XPS-13-7390>
In-Reply-To: <ZCUv+8tbH3H5tZKe@righiandr-XPS-13-7390>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5782:EE_|CY5PR11MB6464:EE_
x-ms-office365-filtering-correlation-id: dbcd12b2-9fdd-4db0-ef26-08db3100ca63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hk3ESHsDZE9BZJkSNVFc/kQ3spFgx4Dpl3AmJxL/jPsikWbM3904YxEs5+M9INISlBkiHHEXR3NjHPw67b5NpSs+WK2CyPspEfI4YjcShcIzr1TQ7lLe5eaNlI0De8iH4dJHyTmVBlRHer/t1Q3heFxBgxNMeTrSCCUugTkDJemUq1BoOCrBvfWeSZVkTNNjhoXiLV63RPA5/slKwsBq4w7WxyxStoMJu5LVkE2Ty229nB9XQmiYX9sGOnPe5YxZPmn/FPmTXdG2hSmIGm2DvbqjkLGGLXaB9zhXfe/c658fSbDn0PXAF+g7/s9gkxEtUt7tPri4sTRTzAwcThaowg8uUcuealCmVDdvuOy3iFKK76UfqrQCawuUqUiIoZQJV3NkNCpcPAJokBoD9909NBMWjqgSBftXn2Mqfp/K4HUGhOYUsBHGSMA/uBgHIH1FgMut5K48opkhqqFl+fXV7RyLIRmrHUad2+HVbYq+4Prx5BoHTs/12BkhCQ4DGjkCm6G72O/zB/AdfjNbDnAiuqGrL+mCbS5S74rHGgGETAInUW8K8MLHCmjjDZdcdMGSBeRkTATOHy8zFUsRerqJvZfTYWDpsnu1ygR9frNGxPDq0E8C0fLDTPxw762Neg1t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5782.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199021)(86362001)(33656002)(38070700005)(110136005)(478600001)(7696005)(76116006)(4326008)(66946007)(64756008)(66556008)(66476007)(54906003)(66446008)(316002)(41300700001)(71200400001)(82960400001)(55016003)(5660300002)(52536014)(2906002)(7416002)(8936002)(8676002)(122000001)(38100700002)(6506007)(53546011)(9686003)(186003)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F29D9MF63ybnaMtqkuDbk+D/g6ysaTq2RpSed5SiQTvoLgiPzuh6gYIdS82k?=
 =?us-ascii?Q?8tiOipTucLOPUWqnz+7DdPcyfJYW2b6rGO2OVFokXd6Vh+ea7M5zrC+m5tCh?=
 =?us-ascii?Q?ghykOwql/yg/hJqGcGneE+yB309rJFI0jWDmtFV8ugR53f2DH+cOrXcdvBii?=
 =?us-ascii?Q?DLVl9YZGg8WwaBtnE/f+YpWjZRoqgfPuXVpkZpwNSZxU4Nq7rB6S9fqLiZ+n?=
 =?us-ascii?Q?5B54mmnFC50hkAOfe3QSQTGy8Pkfx0a5csmYSzzDXIw3an2i8T1L6NRHd5yS?=
 =?us-ascii?Q?Q6RMrSiOln1UMukrv4Vped4j13nsPm8zZeD8HXAeTdRUyRHu2cnSAXHK0LBj?=
 =?us-ascii?Q?MMaOBdZBGf1QKvsC5Ove+aTsc/3JuC9X4nSFi32YNX8fh4/ymfMVIEPsRXjw?=
 =?us-ascii?Q?a7rTZuiltXGryFdbrt128tTFvA/0IutfDK7562IHKbmk50YnVqqilah72+b6?=
 =?us-ascii?Q?Ve80VaNVRs+axXKIs09CYA3tDr2JjHgo4A6RB4P/AKmFdohQjDprB3lZCycM?=
 =?us-ascii?Q?+C9rRjpJc4ivn5hR32XUdZTGe2T0yDUblE/uIijiRHgTK/8HJTAc5prvZZa9?=
 =?us-ascii?Q?5n+cx31CbTS8+/Svlb0Q9MFdgCmf7Lpd39QSXmRp8M3lB2QA1KKljXgxeb6I?=
 =?us-ascii?Q?RW+zudnkwvulGELToGFDw/2KKKN6ih3Oj70NCCBcusU3WVdu2dzzXmviKJS9?=
 =?us-ascii?Q?tIDLRUgMJNm1l2dSCjt8Ss/5Be1BKgrCW4JmHY9P+J/sY7qSxnNpbWGZl0gD?=
 =?us-ascii?Q?+Oo+0HzmDmgzhn6iYXfFhqm9xXrLdzAEnSizF+f17XbjxYEpjhvngZm9XpBJ?=
 =?us-ascii?Q?iMIfBM6tRD2Vr88zns1zW/BgzM/r8MVIG+SPOcxOefbIMVujsGzp01MZRkJa?=
 =?us-ascii?Q?CrRLUDbTR3JaEyYwrjlYYp7qyooGhtnUSbwh6+qjm5zmWSHONYuPvixObOFR?=
 =?us-ascii?Q?G0b8odOMuIiAl6dJ4hB3TeJmXruma1WcSZYuFo/ta1IwbpqVxUV1rshVXeDY?=
 =?us-ascii?Q?rHQ8N+PxmR8rAQUIlcgYyMexqLkVUi0t7NvmJsBnyenRpwFoNBY+5WbosvYQ?=
 =?us-ascii?Q?V9SQd+Sk8aooUNm+Iy3Wf/WHbMuK67Q1xIU90057lgnzZYSeMouvXo2n3fZH?=
 =?us-ascii?Q?4MnpfDZb4JwFQy3Gil/GSR1B64j0qWwAf3FpCGw0TQKmR0LdQIawN8jStFOL?=
 =?us-ascii?Q?Ds/zIWR0M0VtbCczc19lTiCN55cHh00E4vcfg9YFna4HIo8gQfjpmKzj00hq?=
 =?us-ascii?Q?FoSHQfM5KRSif48YwKzsHYXageyrDD73+gMJl6A5Y81b1j7u/nq/UVVPtxPu?=
 =?us-ascii?Q?kAMHZC81ws7J+tgE7cMdNOtAohR33kzL/I5pZ/u2hN2QFh4I+m9Ye6XfY10O?=
 =?us-ascii?Q?/Ksbn8KEEJn6ihjxCmgKKRHvhdugWT6Nq8zN5Ob2ex9DLWZ56JvAzxmkEmPQ?=
 =?us-ascii?Q?eJBQBYmTehZm2yZYfhpAUIqtUOi6cCDSbAaidzgP4jhdggiLITmfHVCBq+Lw?=
 =?us-ascii?Q?P4Pwxv9nFcvdevoDsvEu4c6qWsvx92sMGZEFhVznwFWUCj5Dc5X3JzJs0zEu?=
 =?us-ascii?Q?xM7/0rvpdz8tYsxRpsYXhArX9U0mpWAdLXcRCM8P?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5782.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcd12b2-9fdd-4db0-ef26-08db3100ca63
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 09:26:06.7766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bD6IhsTAnIu8diFYvSmQ5UIoTU/eM612nTt/znaO3KCBRCp6flQhxDvnkTPvBwsaxWEbe49+Backf7Nfn2J377qwfWXjv/9oDZjjsGvXNpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6464
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Righi <andrea.righi@canonical.com>
> Sent: czwartek, 30 marca 2023 08:45
> To: Guillaume Nault <gnault@redhat.com>
> Cc: Drewek, Wojciech <wojciech.drewek@intel.com>; David S. Miller <davem@=
davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pab=
eni@redhat.com>; Shuah Khan <shuah@kernel.org>;
> netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel@vge=
r.kernel.org
> Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
>=20
> On Wed, Mar 29, 2023 at 06:52:20PM +0200, Guillaume Nault wrote:
> > On Wed, Mar 29, 2023 at 03:39:13PM +0000, Drewek, Wojciech wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> > > > -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> > > > +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2TP */=
);
> > > > +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);
> > >
> > > Btw, am I blind or the alias with type was wrong the whole time?
> > > pf goes first, then proto and type at the end according to the defini=
tion of MODULE_ALIAS_NET_PF_PROTO_TYPE
> > > and here type (2) is 2nd and proto (115) is 3rd
> >
> > You're not blind :). The MODULE_ALIAS_NET_PF_PROTO_TYPE(...) is indeed
> > wrong. Auto-loading the l2tp_ip and l2tp_ip6 modules only worked
> > because of the extra MODULE_ALIAS_NET_PF_PROTO() declaration (as
> > inet_create() and inet6_create() fallback to "net-pf-%d-proto-%d" if
> > "net-pf-%d-proto-%d-type-%d" fails).
>=20
> At this point I think using 115 directly is probably the best solution,
> that is also what we do already with SOCK_DGRAM, but I would just update
> the comment up above, instead of adding the inline comments.

Agree,

I verified the fix on my machine,=20
Do you want me to send the patch or you'll just send below one?

>=20
> Something like this maybe:
>=20
> ---
>=20
> From: Andrea Righi <andrea.righi@canonical.com>
> Subject: [PATCH] l2tp: generate correct module alias strings
>=20
> Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
> definition of IPPROTO_L2TP from a define to an enum, but since
> __stringify doesn't work properly with enums, we ended up breaking the
> modalias strings for the l2tp modules:
>=20
>  $ modinfo l2tp_ip l2tp_ip6 | grep alias
>  alias:          net-pf-2-proto-IPPROTO_L2TP
>  alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
>  alias:          net-pf-10-proto-IPPROTO_L2TP
>  alias:          net-pf-10-proto-2-type-IPPROTO_L2TP
>=20
> Use the resolved number directly in MODULE_ALIAS_*() macros (as we
> already do with SOCK_DGRAM) to fix the alias strings:
>=20
> $ modinfo l2tp_ip l2tp_ip6 | grep alias
> alias:          net-pf-2-proto-115
> alias:          net-pf-2-proto-115-type-2
> alias:          net-pf-10-proto-115
> alias:          net-pf-10-proto-115-type-2
>=20
> Moreover, fix the ordering of the parameters passed to
> MODULE_ALIAS_NET_PF_PROTO_TYPE() by switching proto and type.
>=20
> Fixes: 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  net/l2tp/l2tp_ip.c  | 8 ++++----
>  net/l2tp/l2tp_ip6.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
> index 4db5a554bdbd..41a74fc84ca1 100644
> --- a/net/l2tp/l2tp_ip.c
> +++ b/net/l2tp/l2tp_ip.c
> @@ -677,8 +677,8 @@ MODULE_AUTHOR("James Chapman <jchapman@katalix.com>")=
;
>  MODULE_DESCRIPTION("L2TP over IP");
>  MODULE_VERSION("1.0");
>=20
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as pr=
otocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115);
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index 2478aa60145f..5137ea1861ce 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -806,8 +806,8 @@ MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
>  MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
>  MODULE_VERSION("1.0");
>=20
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn'=
t like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as pr=
otocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115);
> --
> 2.39.2

