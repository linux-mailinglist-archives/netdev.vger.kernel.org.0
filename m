Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364A058CC78
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiHHRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiHHRCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 13:02:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CF913F20
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 10:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659978174; x=1691514174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zm7fon29/93pUpyrj2wg1apNTIKrls0z71bpLMMUfY4=;
  b=hvxg4y0I+u7UoZ+miinQV0EB5oizEMuG1vB7aL0F7PSMgqt0/bRc76no
   kjdGer43dTjlsc1alGurzaMJKriHYfJn0T4Zs3GnqzVbDKD4r6VeF5dyw
   EVzu+o+k6GDz7JQSE8S1ZDPCkGvhh1yyfjBgXPEvPzalf59mkwR+SM6cm
   Ohbm/za1K0oJYsQGp3JSw/ElBFo6xh5IT5fcyGzGpS407Ml2psUeOLWs8
   jRmFIlP5Y7Z0GvY7UvDjrfKSbF082v8SS7B1sXyDl/H4zUJAGcjV8AM7g
   K7XMKd6knduHv3i7ELIPC4vaDqafwyVY0Lb9i1M/eKvYftCaoi/WvitgR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="352371878"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="352371878"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 10:02:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="637383207"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 08 Aug 2022 10:02:53 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 10:02:53 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 10:02:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 10:02:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 10:02:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbQNP644WinQcNq3EkQfu99jv7/C6xiXqqvTROyv+F3vsVk2piqSnACjPqQoQ3DueB4Ufroo+Bt5zNgJYqg3FpYkx8mZJzB4KOB6YbegJV9Q0fxscW7cmrxfyDbpXtqngtAeK7JcsWompo5HKMfDbzH/hZSKwVEjikzEiAgwlx6evPMWMCkjYO6/zxfIBd4thwNSVs4Pp5MVVm40DZJknpEiT+22gK2RpLQjIFPi8kRWSIrkxtzeZ0PJwz5JpjisTjdbBRwNtpI2dGoE+VpJxm3mRTxfZ7fxD33pv5Ipdl9/d81T4GmP6xNQstoFYu4SUShXjwGYWAhZVVS8wKGJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Op1nrIl7qIXRJl5EqKCzyGegpLBU7J4qKHVvfDawUak=;
 b=MLxBfug2wDOO3iTNGOmAW2ajvrnPgN0d6r1FnwxvMCrg9c3LfBA5aMXU7El+rEk+AlsiMpcAdM4DnqEQc5aRtkQS7rb6BHzk/kdQVmng6c+/sVEb1biU0f46ckI3bAi3nWxzV6I4eMMt91/sUWPopIHsICdxbYhieNSjhvEtYD3HPLMs7kxAbbBvKv4T4GuZaL5iEapU6GJfBJ98NfVuJF+W34pkyat5iklYV2lJfwkZYy5usRLc+zKR696AZ2akk4mqqCxKAEEiQ4KM0jmuJ/PMdMmXWVV/SWanvytRd+eaWPNbv8D4kZIUmoHsdj/hHswAwkx9GeiERtFHGnOQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by SN6PR11MB3343.namprd11.prod.outlook.com (2603:10b6:805:ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 8 Aug
 2022 17:02:50 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf%9]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 17:02:50 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: RE: [RFC iproute2 0/6] devlink: add policy check for all attributes
Thread-Topic: [RFC iproute2 0/6] devlink: add policy check for all attributes
Thread-Index: AQHYqST7LsXEUCV47UePgGkSOtX+Ha2k0fwAgABppxA=
Date:   Mon, 8 Aug 2022 17:02:49 +0000
Message-ID: <PH0PR11MB5095F7729B6A1EF25D6E052CD6639@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
 <YvDmNO6/QtXfJW8h@nanopsycho>
In-Reply-To: <YvDmNO6/QtXfJW8h@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a88b03f2-0f32-41b1-f518-08da795fd342
x-ms-traffictypediagnostic: SN6PR11MB3343:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 47oWcGSg3nxtad5GV/SBYGTZeRs7rXiYGAw8UpZfToWX7dU1EWL6XfJKguetQiHr9kfp5FQ+SlS3lurj5H3Fvh1ZNiwYl5C5oiD7xOVgm3YFIna+muf8KxyZYbBPYivoeGjuQT2t2tgDxo7dWTKXLJD5wutugiE6HcnPD6WbaKQisxqkBxBVD4K1P0jK6eg4tdqzO962V/jmalwWCcNc81VO+HiejL5hTBC2nY8kcvwJJFoshiqia/HtySRoXJ6VjOVXDBOAT1KqHGFvWGj+2Pblw/+La9xdxNPmoGBCh33chMtLAR1TmyG2Jcm+rYwvljmUL81i++WIZ3MPYZ4Q62yCgnLtTKly42twdvBxyUPYgoNbEeqP0ZhpzN9KmyT2J50MZboeJMvJJX/oMsWgMY2q1E2VISpkzwCIPmk19zGXoi0R3VZNUCR4pS8a9mHMxcVFjOjjT4a8fpZgLkMUx6Erfqi8dD3MFuEHjjS7gtCjpBQpfHC9u4jROZMa9ABT1pbw+udpvxgLFAoduRMVYM/fnKcTGde326g6Bjk7Dz6y6YjRU2045GXmedZp4SzYUXQcwdDm2wfhj6m3MfS3Y3dqaCkkXgJeZ7slK7SqlecRWT/5olaUFcFPH3FSKFZwqPEeT2leXbFtiTO2YnlQHrDLwVQNupXeaXKmW8a+Axnwigr2xs5NeTs8Y3oKvl2sw/oIDovxts2iD50kesCo6uPMuvrgqWRzUEJEBumZRU1+fltMnR72OGxJ7kd7EcMcS78CcK1zZyTy3LsjxuFh6RsO4RYcUxayKrOb1Um6oah1QYJ8BVvoIVFk2jn+nfJF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(38070700005)(83380400001)(2906002)(122000001)(54906003)(316002)(82960400001)(6916009)(52536014)(8936002)(38100700002)(4326008)(8676002)(64756008)(76116006)(66476007)(66946007)(26005)(9686003)(6506007)(7696005)(66556008)(66446008)(186003)(5660300002)(53546011)(478600001)(71200400001)(41300700001)(86362001)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oDHY09XdVU0Q9Wy8NFx7VKaKgAzqIj6mQ+X9J9gdZbAPKVqjv5+EfDIDcGPH?=
 =?us-ascii?Q?cB1cPoZqU7qyDiUYshzXMk4VZ3wBhFTDVO0DTtRxv6fIrRB6VCymTA6qWykY?=
 =?us-ascii?Q?dONJmtuwHO+oQWxPred1vfGRzR9gs2/N+I0yH5ocMAkmiqxJGOY5EBfE5PIk?=
 =?us-ascii?Q?scS1hRatcDFYyttGMWbuqpP3G9G8cW16QzNailRoI1+bUjf55IlVXIJjI4nG?=
 =?us-ascii?Q?1JmxnLQdOMEj2BTcWVeULY6SBGyeN1aTDFAJJiRA3GL4UEtecMXAPSSsTZLS?=
 =?us-ascii?Q?0FjeGFnCDyymtM4M8Oe+RSSRBCO2WXos89ZIbK8g7TurQzY/t6WYiIwwzPmv?=
 =?us-ascii?Q?CinkwcyQ8N9kUQJuFAFTJuL5728Q0NTKn4/Jsv7sSmlvgP4xuGxy2VH167IU?=
 =?us-ascii?Q?FCXTx0FOu8eHBSuM7YEe7+p5MbIM8eVimTPwW8zSpRZ8K9rGX/i68jSc/wP4?=
 =?us-ascii?Q?IZ4GDVwNv66bWNw+S3N0vpEivkXVAnPT+cimuMQfW5kF5NZsheqG3q7ymZA5?=
 =?us-ascii?Q?mL1O0ebw8dVUOVLryVHzy9dRzihZnLlE9qgp9yIkpGlAklw+3Fw+ykMFFEVX?=
 =?us-ascii?Q?egM1CQacddW4Ct+Wl+PjvMkSOGO2lm3vY35Vxl3Brqf6GbjlmvHvtA59Gxdv?=
 =?us-ascii?Q?htt0AAyKlRFFnP50LeGjpyNtP77LdwnV5ZF6z7KqNYg1jvDKE0DC5aGu2p0M?=
 =?us-ascii?Q?iXLHT7xv+zsRDhpcFpoqtB3mxZKN5yUeObEzHcrPu6Oe7h/mIKm5SOUBGwQl?=
 =?us-ascii?Q?sd2lvID3un1x+zg5hfQMNVhVaGB8Tk4SoMNN3A36n2rcawRlXB9mPcQCXgK3?=
 =?us-ascii?Q?Q1vgAT1H2+SRNSCIi2fvC78L9+CEYtVSKTPlGu0cZ/eCRdJLqpSFTGTZelfQ?=
 =?us-ascii?Q?YNZWB6CS7at/xqoP8IG+u46ykgwdV5N3gfrIjIwj8Dd42GvoDDdGSSIIK4ff?=
 =?us-ascii?Q?OCuIbNKocq2XLXDRSESAwGCgYhubduEmjU9Vh9MeecIeJVWkcTEtAbQ9Owja?=
 =?us-ascii?Q?bC3mR5n9fDo0Ev4dbiYq1e3OArFru+IbJUchHyu+BEbQEj3OqFdKoM+o5gmt?=
 =?us-ascii?Q?tAnP4ZIkcJf6pb951kp9iOoF0KMV2FqHU7FslI0NrenSoJAr6xbJN7XS51Dj?=
 =?us-ascii?Q?mTbd31UFvuR9GFbPJEdjNP/HDlVhZBixT4nr49C47L4H4KHIuNoYXJtIgmmJ?=
 =?us-ascii?Q?U64BnVZpu+ymJxS0Xk+O87XYVHJ6cJl3P8UPBldrht56SlrobwOTtPepe6Di?=
 =?us-ascii?Q?EyDlG8/RUy7ZiHScLqfTSJUbMxddA6AvX/7oKcswNxsDJz/6e6TkshI7Bd/6?=
 =?us-ascii?Q?j4QO9kjlJUnhaEogOLPJnNCKLYjjmP4aVTzv39n2qj56m9Mg8EJOWMMjxzK9?=
 =?us-ascii?Q?fWaLgpwihotzjdnB4E0bPDzbUshOQxFSKj8cjKxflhMAOsFAcxj8RSyMCUrb?=
 =?us-ascii?Q?HtumHsLHyedOIiXNL6zJIkGTpGLSos8In1UEJBLC+ABPakQxwlSjUzXjH3ej?=
 =?us-ascii?Q?eDkT8kqtfah1ENLkGHtAmXHD48sGCyuTbnTZBKmX/4MfCRnwtI4XRG2O6XJ+?=
 =?us-ascii?Q?jQLXCWezibWOk6cdI3/7MU5tV27m5Jq0D7+2Nl1N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88b03f2-0f32-41b1-f518-08da795fd342
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 17:02:49.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 93N9cWAZOODpDkv3nX7YQIfJIQTZ6I3PzRQP9x11eegFlxQn0Ir3c5jpfx2DTa6lXK+/5GyC7clNEk3LaRxn5Or1SC5BDlN4KK2X4qNLXwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@nvidia.com>
> Sent: Monday, August 08, 2022 3:32 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; David S. Mi=
ller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David Ahern
> <dsahern@kernel.org>; Stephen Hemminger <stephen@networkplumber.org>
> Subject: Re: [RFC iproute2 0/6] devlink: add policy check for all attribu=
tes
>=20
> Sat, Aug 06, 2022 at 01:41:49AM CEST, jacob.e.keller@intel.com wrote:
>=20
>=20
> [...]
>=20
> >This is intended to eventually go along with improvements to the policy
> >reporting in devlink kernel code to report separate policy for each comm=
and.
>=20
> Can you explain this a bit please?

Currently devlink only reports a global policy which is the same for every =
command. This means that commands like DEVLINK_CMD_FLASH report the same at=
tributes as valid as other commands like DEVLINK_CMD_INFO_GET. The policy (=
if the command is strict) would only require that attributes be one of the =
known attributes according to the general devlink policy.

However, none of the commands accept or honor all the attributes. The netli=
nk policy support allows each command to report an individual policy that w=
ould only include the attributes which the command uses and would honor the=
 meaning of.

Without per-command policy, there is no way for user space to tell when the=
 kernel changed support for some attribute (such as the DEVLINK_ATTR_DRY_RU=
N I recently proposed). Yes, you can use maxattr to determine of the kernel=
 knows about the attribute, but that doesn't guarantee that every command s=
upports it.

The per-command policy would report only the subset of attributes supported=
 by the command. In strict validation, this would also make the kernel reje=
ct commands which tried to send other attributes. Ideally we would also hav=
e nested attribute policy, so each nested attribute would express the polic=
y for the subset of attributes which are valid within that nest as well.

By adding policy checking support to user space, we can make sure that at l=
east iproute2 userspace won't accidentally send an unsupported attribute to=
 a command, but that only works once the policy for the command in the kern=
el is updated to list the specific policy. Right now, this will effectively=
 get the generic policy and indicate that all known attributes in the polic=
y table are accepted.

Note that this means strict validation on its own is not enough.  It doesn'=
t really matter if a command is set to strict validation when the validatio=
n still allows every attribute in the general policy, regardless of whether=
 the command currently does anything with the attribute. Any of the unsuppo=
rted ones get silently ignored, with no warning to the user.

Related to this, also think we should determine a plan for how to migrate d=
evlink to strict validation, once the per-command policy is defined and imp=
lemented. However, I am not sure what the backwards-compatibility issues ex=
ist for switching.

Hope this explains things,
Jake
