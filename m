Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AC5EFBE3
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiI2RYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 13:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiI2RXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 13:23:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D36B1D1A42
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 10:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664472175; x=1696008175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yXwSIWeWwefWSGb2PUBiyUuVdy7BK3g5Ff/UPXkbuhE=;
  b=ZByTtfLvSOFQmxDKVkolYRBj2X6yoyEit3Etlmb6cMKDbgYDcLfO+t3L
   g4k2vKaFVk96MmX6yPUTX9LBnxnBZNzD4EmEZwAGwo8rUKSuyYdcSpMog
   5t1Qkq7Ce+CX9QzDKyefLcg8YdHY+jOBopyhKvXqiYMuV8GEg2csXWVuc
   yIVI8DALnHWYuGx7Y5pamZqHMiuglklpr2OYq10K4ouvKQoO8kQmF+cBw
   BJKcvFmw2Ir/DReE4ARNXc9Hp4mqQ9PGzPaT7xhBoeRqjfSZ5yDcBJYCe
   TZJTynqKv3jf9e9Ok7hijH+MAjjXNhTAPaLgTa5CJXKSZ0+tYe3QRDn1v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328345345"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="328345345"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 10:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="624656046"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="624656046"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2022 10:22:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 10:22:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 10:22:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 10:22:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7u6rxhNq0wPsrx7yMpBjJu8GXNClZ5442t6soVNIp/1dh4AclUCOyXLAKBEarSDTdVhMMgcQP4nEGHCpB8HntYFjdvhy0EO5T68tdhcK8zZamKmnCVQHEkZWS3z3kgbxIJ61jgpPQ2V9gvnuSN4iubrd/Cc/EUggXtdIdWMM8bZ8jJWAGyUwIbBqifrpURep+Pvx3RK8CdP6rKHjDDASAQu4zbERi2rXrgVP7P6jeG635RS2SMV7fq1V6/k/HFDfw8vyyAyLF85zAJEOmPpoA2w+LoaG6Uz/AJasxi/4YPD6Ty5cKFXmp0koGlgzDhHaqaTD/WaY0Y47UW9Fx38Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pMnMM/WktCEB9tU85Zlydw9LQJVoOny8gWyEeWOm14=;
 b=cmAU8lE7bbalElLhoDucd/sqNkBhoqTnAQpv/FhJoH+RrkHPCf8kKhUQYwDciOvAkcN4dgrgaZWSSPfUIniYkWAtc6D1H9F9MNx92Wzyqz/DRxBvnTkL5kNBJvytgvgPp/O+TcSQzfma1JpI7QeaGNASOkTlJdUo2F7a3t6EUL0/qqKFard6J+8/KIPwYMjRX82ZkJjuQrJPRZqhvy67EuYGkffWWSWEsESMjkXZ7EAaonyrdj4Jql7CnYcZ72cBxn8pe+y8xDy+LN7m3VJpGPFmvgKW0Zx8LyPG0qDmStzVh6VDVb1rfYOW/dVW/iIVLHZv1WVmtbI4oXE8bxadlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 17:22:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 17:22:51 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Florent Fourcot" <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: RE: [PATCH net] genetlink: reject use of nlmsg_flags for new commands
Thread-Topic: [PATCH net] genetlink: reject use of nlmsg_flags for new
 commands
Thread-Index: AQHY02kjQF+vVmdCt0avkzvBd2pqH632qIOw
Date:   Thu, 29 Sep 2022 17:22:51 +0000
Message-ID: <CO1PR11MB50899F39FE001E0864A79FA3D6579@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220928183515.1063481-1-kuba@kernel.org>
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CO1PR11MB4993:EE_
x-ms-office365-filtering-correlation-id: 82fe972b-5530-4c5f-8ada-08daa23f3ccc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jTupq6u2LZDeTaSgncQCZNYFZEzwHVd0HjUHMYoVsZvKa9zoxgyaYjCXL5DaYpx2geNeWB6EHES3trmnIE+kDvWIlHsmuJW2u5gkZRUAQ9Gx5tfyPApmpUgvxlkMQzQKoXHIs2RtWf5kVb+KDJV8XBHVgGqvYD1843rAbHh6k+ajtGOADdnDL9ozOqQC6q85hxV1oE/lI7aB0Sw3jBvGBq/3Ai6ldPeFLXDJbcdjbq0m2RwcD8DahBN7F06dqiQK9kxqXnYKeVxDy1PohQyOBLuU76Yji2Muuw7dB0lEjGdkDjrh35HoD/q3/qnCmt+6mdkVjR/0Eu72f6SpuZE0OwIjIFjNk5dDHGRueAy/qsFbFB+xI7/xNiY7bBU85chae1NPp/2D41SiTg0Rms3pkBrLcsEmoQ16qk7Rl8Ni8YKKMoyjDlSB+7jzjj++gmE9Ipao99vyGNcO51YO3NUblK5VH8ygcGQ+gKwtwMYuaohLWurfRMmeA8NbRR9LZyPxPuzgxg7p9dHanFn2dpf6bjNCTrRt9D9N4VMI5F79OudRNJ1XnMG1B+o0Fc9YAdQK3os1e7XL9ijQ9w2kHwpgCBceWtlqIwzLCgoXS+/8p01bJb4ITZwIukaVBmD7e3y16w72dtTPWOSxRrmNofk1iMS7AcMuxqh9ZDV6PBCqWEE3gpw1qwgnx3O+iK5E2CeAb12j4aXoUHrd1S37EBYvtGP0PbFSTdXO586k6kN3nGxGcgVgzoRFOJ4FS/RDrpt+Wr9kenyjys6oeTJVu62bQ7VPIH0Fa9RYPgp+iNt/DE4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199015)(66946007)(66556008)(76116006)(8676002)(41300700001)(4326008)(64756008)(66446008)(66476007)(316002)(54906003)(110136005)(8936002)(71200400001)(52536014)(966005)(33656002)(53546011)(9686003)(2906002)(86362001)(38100700002)(82960400001)(55016003)(26005)(478600001)(186003)(7416002)(5660300002)(6506007)(7696005)(83380400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bcvinmwn86RjZVViCfOtbUh2rrHUBYnrrShq2VC89yiYD8ci5T9ijlcFqlLY?=
 =?us-ascii?Q?nlCrqgYx4zF0kjgiZ50XwgWljmRczZzoqy8QwSRiJQVfotgPV/UsL36e+dqO?=
 =?us-ascii?Q?6qNEoS0f53YkglNKJwXueAHZX1gToDAOnmUK8+Kyj3SHz3TUtBdJ8p++j9V+?=
 =?us-ascii?Q?R3iVR3F8Stx9Rpdf2LNx+9u75YeDntcYpiNG+UReK5re48eFktkOiKZkmNsL?=
 =?us-ascii?Q?lzQKEmc1KqRGjcyWFkDQMXM7E2aJ8Rp5mnP3mJchSH0GdDImhEoErRQBDi0I?=
 =?us-ascii?Q?1uYAAf8YK2gg/4xgcWhVmgGrvCTS8ihqmcmwTahdRM0bmnCaf/1z+HUe0aa/?=
 =?us-ascii?Q?1dq2DluxI69NzwV9xyF4wctXNWEYYJbm8b2rIx5PTDq1MOOshaqv4bXt4Ge5?=
 =?us-ascii?Q?9p+jVKQbdzLG2h1a6hFTNsbDWTzacDJa7PPQOxhXGSyLcJpszXVmvvDkuUBw?=
 =?us-ascii?Q?BJ1/UJwehx3h9BMi4gCjYTLOLza93eSh8ghZVUXzfmp1ENboQaTthHnmivrV?=
 =?us-ascii?Q?VpGw4VVh0PChmxBuh2IoHtslE8EUUPjLFa3hjKAPeWrjM7+BgpWbTn1il80J?=
 =?us-ascii?Q?r8zPeMO62+aRCd/bncoQJX4DfOgUnal5+yEKAd70nq16Xc/OStaysCSPQgLR?=
 =?us-ascii?Q?q2uUc6jvgTjhwGIBKkImYq9M6yFyfk2NEVIcfO3Tprbd+rCCkgE7pTks9aIz?=
 =?us-ascii?Q?YfE84e78KfJwx+vvXuReLN+Fvh5skDzmZys6LcdoxQZSlHlUZDejM+/1F6LI?=
 =?us-ascii?Q?5P6J/QwrEiJVXbp6DBsrXiDhL/ignEKsa1c4DtZC3zmG5EsXB6THzNbkMk1/?=
 =?us-ascii?Q?ZEugLdWHOoZ6Xtp5iGJR5QOyct17ON+GAQNBp+U6SnzlcHydqhAt5JCyzHzD?=
 =?us-ascii?Q?vfdBligD7/D6fIXg5Wky0yjmvYVMJfGgsI2GPbcpDtl9lGaNGgvYnshZUDAh?=
 =?us-ascii?Q?0kcpj9H2j5y3qXeK3uMdQKzlB3f2Cegrgsq/wwhdmB9VuWkshSjH68G7nw+8?=
 =?us-ascii?Q?ujallCuZijmZ24/b9DLXJa6lNwsOGwA1V384jGJmtmxeiGpyie/fmZv2vsVD?=
 =?us-ascii?Q?ajH2fM+jQB9RZ8Kda9puhoSLsc6wj89rbqFcJUAQliYCK5f8aH8JdupPYdq6?=
 =?us-ascii?Q?dAMEx+Kffa6P3Nh1hD69kXF0OrrQelRqUmcnB/Qv8NRNTg6d9sENWzdT0pl1?=
 =?us-ascii?Q?r/UuscOpdZY4EM9n+PTQooUrUYJLwDWUAgDPsM5UgXWtfGll6tBBi67UTrEO?=
 =?us-ascii?Q?ad/qknPFm9L7YyyLcmaghPHktk+BY8t1CCY41zHTxrz9TjA7MGqF62NCs7o/?=
 =?us-ascii?Q?nZnPNei4+NHoSEd7GC8CUAqjlnzUwn4jO4H2r3a/pDntTuP1ntRdUTg64ARt?=
 =?us-ascii?Q?4rTi7cr8jzK+lh1WwyHLrCCu6yEw8PdmHKzkDv5ISqnTM1+UB2I48lL/bJPb?=
 =?us-ascii?Q?ZospoWjVl16ZdBcq17u0AsPu4SLqTZYcHRmJgWOjJDyBqDuq3Zz7Zq8eBZQf?=
 =?us-ascii?Q?zUfiQUZTIiygHu/RPiiAD5/LLzSFi2Zebxmt22f7pa4l5UA537Ryv+z2MKg7?=
 =?us-ascii?Q?DEwMGPbsyDofcRsnFjKZWq/yZ17cZhKHNaNRqF0S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fe972b-5530-4c5f-8ada-08daa23f3ccc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 17:22:51.2867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8TKeoZOsxcsxY24WWSD4K0yariZfPjoR6ud36u72rv1c5uVCWdx/EGqljQMwSC7/Y2f6eKF+Wv5meg+8F2SEOzWtwZGMkvy45GQR3hbiq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 28, 2022 11:35 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com; Jakub
> Kicinski <kuba@kernel.org>; Florent Fourcot <florent.fourcot@wifirst.fr>;=
 Nikolay
> Aleksandrov <razor@blackwall.org>; Nicolas Dichtel
> <nicolas.dichtel@6wind.com>; Johannes Berg <johannes@sipsolutions.net>;
> Pablo Neira Ayuso <pablo@netfilter.org>; Florian Westphal <fw@strlen.de>;
> Jamal Hadi Salim <jhs@mojatatu.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>; Guillaume Nault <gnault@redhat.com>; Hangbin =
Liu
> <liuhangbin@gmail.com>
> Subject: [PATCH net] genetlink: reject use of nlmsg_flags for new command=
s
>=20
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes"=
)
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
>=20
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.
>=20
> Link: https://lore.kernel.org/all/20220928073709.1b93b74a@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Florent Fourcot <florent.fourcot@wifirst.fr>
> CC: Nikolay Aleksandrov <razor@blackwall.org>
> CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: Florian Westphal <fw@strlen.de>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Jacob Keller <jacob.e.keller@intel.com>
> CC: Guillaume Nault <gnault@redhat.com>
> CC: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/netlink/genetlink.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 7c136de117eb..39b7c00e4cef 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -739,6 +739,36 @@ static int genl_family_rcv_msg_doit(const struct
> genl_family *family,
>  	return err;
>  }
>=20
> +static int genl_header_check(const struct genl_family *family,
> +			     struct nlmsghdr *nlh, struct genlmsghdr *hdr,
> +			     struct netlink_ext_ack *extack)
> +{
> +	u16 flags;
> +
> +	/* Only for commands added after we started validating */
> +	if (hdr->cmd < family->resv_start_op)
> +		return 0;
> +
> +	if (hdr->reserved) {
> +		NL_SET_ERR_MSG(extack, "genlmsghdr.reserved field is not 0");
> +		return -EINVAL;
> +	}
> +
> +	/* Old netlink flags have pretty loose semantics, allow only the flags
> +	 * consumed by the core where we can enforce the meaning.
> +	 */
> +	flags =3D nlh->nlmsg_flags;
> +	if ((flags & NLM_F_DUMP) =3D=3D NLM_F_DUMP) /* DUMP is 2 bits */
> +		flags &=3D ~NLM_F_DUMP;

Ok so this check is making sure that flags has BOTH NLM_F_ROOT and NLM_F_MA=
TCH or neither, but not only one of them?

That's why it can't go in the following section, because we want to allow N=
LM_F_DUMP but not NLM_F_ROOT or NLM_F_MATCH on its own.

Ok.

> +	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "ambiguous or reserved bits set in nlmsg_flags");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int genl_family_rcv_msg(const struct genl_family *family,
>  			       struct sk_buff *skb,
>  			       struct nlmsghdr *nlh,
> @@ -757,7 +787,7 @@ static int genl_family_rcv_msg(const struct genl_fami=
ly
> *family,
>  	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
>  		return -EINVAL;
>=20
> -	if (hdr->cmd >=3D family->resv_start_op && hdr->reserved)
> +	if (genl_header_check(family, nlh, hdr, extack))
>  		return -EINVAL;
>=20
>  	if (genl_get_cmd(hdr->cmd, family, &op))
> --
> 2.37.3

Looks good to me!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
