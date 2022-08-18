Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE16598ECA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346262AbiHRVGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346164AbiHRVFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:05:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D311D8E15;
        Thu, 18 Aug 2022 14:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660856538; x=1692392538;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F8HfNNdPDpOEC8LQWnmi8RTqJqxwb583skrgDcQ2gb0=;
  b=PNhEeSAGz9wIUxrY1gb8VtHqW66gYPbmEd90tSlmyu7ukW8sIdmZ0VK+
   Z+5g+gY3JiAWYOR9A8C4mRReD4nmjGZEctSpq+O+pRVjNDRABM5N4saJq
   ijokKjMds7/5uXQ2G6UnQiJ7s8VcqBDh7onAaD9RU+mRt9S0VtFThqm2r
   MB43vWILS/vSEzg8K+DMDXX8Pi0aBv8A5FSu/HfuEUjmzwwpvnKu420aR
   L/K4gY5buyO7pBuwYlkeCzELduNiO7XoflIA6cJPfkD4tNabE/5OK4sIh
   PtaA76m5jtFKk1yYp6fzDrx313dPn3j4AUl5ONHsAt8vTYgwlR0CFNkmn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="356857390"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="356857390"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="584376647"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 18 Aug 2022 14:01:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:01:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:01:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:01:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IX9nTauZuTy6rDabyYr4/1pYYR5ZC0mVy9vQYe1KQAwkEjj5bcFYkdu4kPir28lrNPurg+/gzPlMcCtaj5KGqUhNLHycu5ixTrErRjk9+Eyn6W0op/lUiNHfQRiu6vXYp50qniaPvQNg0bzmhwdANGRZQN0KciAKCA/zvYpHWIbd0cDWtinMMmoiB/NioViLmc50Yo95ixEAW4QjPnEsXGQg1PpPNe5A1dKhSSSOae5fcjHr01zc9v/5tKM1vF/AHnFavR8Lwx4sB3PlDN9kiEhMMRctOLWdPrZm8+nSjio0SbO+wHEPXqbSdaBKpSP9Ij1ZyCKv5874kFv0i5DoLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lzyp63I0q0fgg2bSp/lgjalmwZVuisQFpLszfi9wjwk=;
 b=KEFTZUSJqnJYEpL2cNYTIPeRhgyxRAbVnuU+XcWNGpeDvSouHgR7BgBCw0I9OS0j4c7jzxbNfMMi1VInQ84YgtBJMtUJseTAJdZqocUMeEu2PZ5Bd/v/sTVOvNbl4/Huqb2IL06VGYi6H4d/0HRGsFkeLachtbxE2tJf56nSySqb/+quGSGRQdyPJ0Xs5ULqaJEcR1bmKifbZbnKNVHYpBzLt4VOx2PNfZYlg9aK7Q2IAVtfUgJ0PCf0cjMetPCJPbEAti78zcmxXDDaQpJbQzl7leNktiitjQFeylIflZcLY894XJd+0IA9Kdbq36BDeTZAnLmgr3xKT8TXAwM3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN8PR11MB3715.namprd11.prod.outlook.com (2603:10b6:408:85::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 21:01:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 21:01:43 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "sdf@google.com" <sdf@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "benjamin.poirier@gmail.com" <benjamin.poirier@gmail.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "svinota.saveliev@gmail.com" <svinota.saveliev@gmail.com>
Subject: RE: [PATCH net-next 2/2] docs: netlink: basic introduction to Netlink
Thread-Topic: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
Thread-Index: AQHYsqsyuoDL5FxZhUKRrS3IK/ZKpa21JdZw
Date:   Thu, 18 Aug 2022 21:01:43 +0000
Message-ID: <CO1PR11MB50894FB421E81435F88FFCFBD66D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818023504.105565-1-kuba@kernel.org>
 <20220818023504.105565-2-kuba@kernel.org>
In-Reply-To: <20220818023504.105565-2-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abab26d2-1087-48ca-8ffb-08da815cdb02
x-ms-traffictypediagnostic: BN8PR11MB3715:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m5UszhA2hOfaLWkxHTqHNsZmAcbuM2gq5IGfXMgCaBWGzpcfYwoICiPELIg0c/dFm3/nHjsCvuGF8dNxqW3VvoqyFUeBrxFCVaGsX8Ogz4rVpiLUcAhaVtbfH4a2w2+WbZQ+L3gmTXRflUL4UTQj+n1/8eeCOT0ZVTOAWl+JJuf1hgWfnBugJ7RX+sEiSLv55fDw2EABg5F3XOLoyPmoqY+okvuC2UzqYEEGoaZusrwEz113qST020wBdj4Piny6e3c0tQxenglg5CoKnFmyB6PFHK1lT1UGXEcqyzoLo/mslF+5lldeg0DhMVmqV9NYam/8rY4aN7EGz+adfZqIci/IhxPbKdY+8TMfsfZSqd9U87HMU7arOEG/ZJ7WSrf44bzxKe2OmCQI/j40iHE7MRuxs7m5wBdmFTVfA7ut7oafkF6bbmJPJKWBkIK7SasD6sGmjVL6demmxQWZRtgO0CaSNG/dj2otrWpc7fCrVRMYu+KK6RgsttQQzOGyjzyaKkpzl7CXKXCjsG7ujtC9wHH2+pfb3nCJ3BP7lxUv3U/ef7YQUBvLbgRFU55r8cdSNBWJ+eq5HgIaSVQHRZdqmoU8gOkzTdECoZSoBLh3oNs2Y31X2bXJCKdHLL2d1bnd0TJkMT7VGsl6tFtwCaGqNhr2JaOfSU1QQ3fhMUUeAy4yIOKURS/XcaT8AsifDP1ecREK8JqjVdVf9qvZSxnAYdD7iRnKcVbbDwtc/bk+94nQEyes2/dZcypfML/3bn/XiwW/HJ0SKfXhVmuEYmTrOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(366004)(376002)(346002)(30864003)(76116006)(478600001)(2906002)(41300700001)(66946007)(66476007)(4326008)(66446008)(64756008)(55016003)(8676002)(66556008)(6506007)(71200400001)(33656002)(316002)(86362001)(26005)(7696005)(9686003)(53546011)(54906003)(110136005)(82960400001)(38070700005)(38100700002)(186003)(83380400001)(52536014)(122000001)(7416002)(5660300002)(8936002)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Aeee01OBCnIFeifdrHtOwtxkXU88H60t6OqfrMBfy2N9uRyS+GZ4pPSU5thE?=
 =?us-ascii?Q?Y70WeEENP5jn6gzIBEeSywsBIfupZoH6PTK0VKuHX6dOqZjQzi0433Hir7Uc?=
 =?us-ascii?Q?jo996v3f8JUb2yMt4CvzzHGwq58q5U5i+Jp67WuQOCPIKmed4ad0/2X9SZ4O?=
 =?us-ascii?Q?JFRn9MfkMdCEg+czX2QHHcamDVSjhb+RUgaG8D7hz/Ay2bLvrZIS5Yv4pjF4?=
 =?us-ascii?Q?cq7DQbedta+GrsL5rYwSegtNM2jTGNFzplqBleQgHqpyO7fT8ioPNR7rnyrC?=
 =?us-ascii?Q?ZKg/ERZTrxCkgjzmBsecmiDvKDf15fGSHZ9Sa4B27VtNTQwc+TdRuD9X4hyl?=
 =?us-ascii?Q?XDDwdXwn3Wivy8rNALCR8zo+VRBRvbX4uafbxgv4fHPrLpnYmpBTIrlKNN1z?=
 =?us-ascii?Q?7QxlOk/wYD8sTtmyqCCR5E7+Zf85lRnsDSAXcOUylsZBprjdbmrATAAHBctc?=
 =?us-ascii?Q?YgkXASq4tVZfJgU7B2hq3IPXAs8Wzd0o9w/tUd5skkmo+0BiR38Ia39x7s+O?=
 =?us-ascii?Q?JucXDFJsQbplbVmoQXdP5IO42cOIqvsjFXg9jUF16FHwLq2IfTDyExKTUZcL?=
 =?us-ascii?Q?19DCxg05hfLWNXXsSpbojlu4uAe/iHH7oo8qGDZKvxqCpB75Nm3/fXqbKvBC?=
 =?us-ascii?Q?FbRfDBuWaDdIMLlCS5xU2FXCGNCJfxwXCXaZY+UemJlawLfO493NlExdAlK8?=
 =?us-ascii?Q?Mjwmy19e3NEa3QmSL+HiiLrWiBbAz3iq6umowC6ZyWVUXJgDZpqq4sUuz0eX?=
 =?us-ascii?Q?wdnlM6JTyzKwvSnVYuoTTuJ29ysiixT3cHqHKvweJIEM9Hwrb/ESW7cu/sSw?=
 =?us-ascii?Q?w4f52Kw6ObYGYLFHHIxeUAi5jt2WwSHbP8jLrTSJ0+TUDT3CLr7OqbJt1kD3?=
 =?us-ascii?Q?9K5g/AlPZeR/j53NOgPBxVh6HP5D9AEDEqeaxu5kLV0pICNwv0Ri52Vo/ORF?=
 =?us-ascii?Q?i7t+YvjfhdqHdWYl+w3Kpj4yCZhrnJjopjXUx0LNOInmbYJz2nV0jTXUntIO?=
 =?us-ascii?Q?SsroFH5Fs19zVAK7eoimAI0FbdbNGpuCzQNEWjIPpzNSXqb+hwsPb2OGGImJ?=
 =?us-ascii?Q?hw12JFO2gWt+7SNRfM60fEztM7pFXG7ZSRaACoFY0T6Sl5JW6CchSHnodAmy?=
 =?us-ascii?Q?tMRKD+UURyO2Re8FtU5ZnoSL7BySUuDZ8FIKkAohg55MBigTb60qRzafho1U?=
 =?us-ascii?Q?gx57iSlBozO5Vlktj+qmTzA9/JF80VUQzOVwMqlYRNZk0ZD9cJmi1mo0wQak?=
 =?us-ascii?Q?mbI3aHHGmSKgRl4wvs6zZE82w1U10G9tmAoFAQxgWjuUQ1oC4r7BR8x+2mzz?=
 =?us-ascii?Q?CB9FYTM3UK43cSTn3eQovicP/bTi8ufju6+/OOrb7TSlHbE+VE61Zp4AsQbv?=
 =?us-ascii?Q?q5wOZzwonG7Kczv48tFM9QmEQQMyQHRPg/Gha6vsUcuMFxFga4Qe1hFZ2L73?=
 =?us-ascii?Q?5YAhWwIWC9BbQ5kzU4lE3H/PiDjy6qNG4f4OoeQKHT0U+VkR38shkT3jVgnt?=
 =?us-ascii?Q?0OkK8BA/U0a1csC18CRlDb3TXS+DWkpS2j8o5CFlfEBX5+LI1U/kJOUhEXNT?=
 =?us-ascii?Q?q8qj0Oa2eMG5d9Hq1ZlW8QsM+5O2cXcpFphZYPTT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abab26d2-1087-48ca-8ffb-08da815cdb02
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:01:43.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FDnzDMBKXvnHKiqhW1d7+F0iwRsEJhx7fut91HoEnknAxuSYHSjV10zn7rNTXJBmH/xYg0yjFEVI8TcsawE4/LN6yn5CtdQsHF93GxZr2GA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3715
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, August 17, 2022 7:35 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; corbet@lwn.=
net;
> johannes@sipsolutions.net; stephen@networkplumber.org; sdf@google.com;
> ecree.xilinx@gmail.com; benjamin.poirier@gmail.com; idosch@idosch.org;
> f.fainelli@gmail.com; jiri@resnulli.us; dsahern@kernel.org; fw@strlen.de;=
 linux-
> doc@vger.kernel.org; jhs@mojatatu.com; tgraf@suug.ch; Keller, Jacob E
> <jacob.e.keller@intel.com>; svinota.saveliev@gmail.com
> Subject: [PATCH net-next 2/2] docs: netlink: basic introduction to Netlin=
k
>=20
> Provide a bit of a brain dump of netlink related information
> as documentation. Hopefully this will be useful to people
> trying to navigate implementing YAML based parsing in languages
> we won't be able to help with.
>=20
> I started writing this doc while trying to figure out what
> it'd take to widen the applicability of YAML to good old rtnl,
> but the doc grew beyond that as it usually happens.
>=20
> In all honesty a lot of this information is new to me as I usually
> follow the "copy an existing example, drink to forget" process
> of writing netlink user space, so reviews will be much appreciated.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> Jon, I'm putting this in userspace-api/ I think it fits reasonably
> well there but please don't hesitate to suggest a better home.
>=20

This is really great, thanks!

I read through it and didn't see any glaring flaws. I really appreciate cal=
ling out the differences between  generic netlink and classic netlink inter=
faces

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

-Jake

> CC: corbet@lwn.net
> CC: johannes@sipsolutions.net
> CC: stephen@networkplumber.org
> CC: sdf@google.com
> CC: ecree.xilinx@gmail.com
> CC: benjamin.poirier@gmail.com
> CC: idosch@idosch.org
> CC: f.fainelli@gmail.com
> CC: jiri@resnulli.us
> CC: dsahern@kernel.org
> CC: fw@strlen.de
> CC: linux-doc@vger.kernel.org
> CC: jhs@mojatatu.com
> CC: tgraf@suug.ch
> CC: jacob.e.keller@intel.com
> CC: svinota.saveliev@gmail.com
> ---
>  Documentation/userspace-api/netlink/index.rst |  12 +
>  Documentation/userspace-api/netlink/intro.rst | 538 ++++++++++++++++++
>  2 files changed, 550 insertions(+)
>  create mode 100644 Documentation/userspace-api/netlink/index.rst
>  create mode 100644 Documentation/userspace-api/netlink/intro.rst
>=20
> diff --git a/Documentation/userspace-api/netlink/index.rst
> b/Documentation/userspace-api/netlink/index.rst
> new file mode 100644
> index 000000000000..c2ef21dce6e7
> --- /dev/null
> +++ b/Documentation/userspace-api/netlink/index.rst
> @@ -0,0 +1,12 @@
> +.. SPDX-License-Identifier: BSD-3-Clause
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Netlink Handbook
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Netlink documentation.
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   intro
> diff --git a/Documentation/userspace-api/netlink/intro.rst
> b/Documentation/userspace-api/netlink/intro.rst
> new file mode 100644
> index 000000000000..1e6154e7bea6
> --- /dev/null
> +++ b/Documentation/userspace-api/netlink/intro.rst
> @@ -0,0 +1,538 @@
> +.. SPDX-License-Identifier: BSD-3-Clause
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Introduction to Netlink
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Netlink is often described as an ioctl() replacement.
> +It aims to replace fixed-format C structures as supplied
> +to ioctl() with a format which allows an easy way to add
> +or extended the arguments.
> +
> +To achieve this Netlink uses a minimal fixed-format metadata header
> +followed by multiple attributes in the TLV (type, length, value) format.
> +
> +Unfortunately the protocol has evolved over the years, in an organic
> +and undocumented fashion, making it hard to coherently explain.
> +To make the most practical sense this document starts by describing
> +netlink as it is used today and dives into more "historical" uses
> +in later sections.
> +
> +Opening a socket
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Netlink communication happens over sockets, a socket needs to be
> +opened first:
> +
> +.. code-block:: c
> +
> +  fd =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
> +
> +The use of sockets allows for a natural way of exchanging information
> +in both directions (to and from the kernel). The operations are still
> +performed synchronously when applications send() the request but
> +a separate recv() system call is needed to read the reply.
> +
> +A very simplified flow of a Netlink "call" will therefore look
> +something like:
> +
> +.. code-block:: c
> +
> +  fd =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
> +
> +  /* format the request */
> +  send(fd, &request, sizeof(request));
> +  n =3D recv(fd, &response, RSP_BUFFER_SIZE);
> +  /* interpret the response */
> +
> +Netlink also provides natural support for "dumping", i.e. communicating
> +to user space all objects of a certain type (e.g. dumping all network
> +interfaces).
> +
> +.. code-block:: c
> +
> +  fd =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
> +
> +  /* format the dump request */
> +  send(fd, &request, sizeof(request));
> +  while (1) {
> +    n =3D recv(fd, &buffer, RSP_BUFFER_SIZE);
> +    /* one recv() call can read multiple messages, hence the loop below =
*/
> +    for (nl_msg in buffer) {
> +      if (nl_msg.nlmsg_type =3D=3D NLMSG_DONE)
> +        goto dump_finished;
> +      /* process the object */
> +    }
> +  }
> +  dump_finished:
> +
> +The first two arguments of the socket() call require little explanation =
-
> +it is opening a Netlink socket, with all headers provided by the user
> +(hence NETLINK, RAW). The last argument is the protocol within Netlink.
> +This field used to identify the subsystem with which the socket will
> +communicate.
> +
> +Classic vs Generic Netlink
> +--------------------------
> +
> +Initial implementation of Netlink depended on a static allocation
> +of IDs to subsystems and provided little supporting infrastructure.
> +Let us refer to those protocols collectively as **Classic Netlink**.
> +The list of them is defined on top of the ``include/uapi/linux/netlink.h=
``
> +file, they include among others - general networking (NETLINK_ROUTE),
> +iSCSI (NETLINK_ISCSI), and audit (NETLINK_AUDIT).
> +
> +**Generic Netlink** (introduced in 2005) allows for dynamic registration=
 of
> +subsystems (and subsystem ID allocation), introspection and simplifies
> +implementing the kernel side of the interface.
> +
> +The following section describes how to use Generic Netlink, as the
> +number of subsystems using Generic Netlink outnumbers the older
> +protocols by an order of magnitude. There are also no plans for adding
> +more Classic Netlink protocols to the kernel.
> +Basic information on how communicating with core networking parts of
> +the Linux kernel (or another of the 20 subsystems using Classic
> +Netlink) differs from Generic Netlink is provided later in this document=
.
> +
> +Generic Netlink
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +In addition to the Netlink fixed metadata header each Netlink protocol
> +defines its own fixed metadata header. (Similarly to how network
> +headers stack - Ethernet > IP > TCP we have Netlink > Generic N. > Famil=
y.)
> +
> +A Netlink message always starts with struct nlmsghdr, which is followed
> +by a protocol-specific header. In case of Generic Netlink the protocol
> +header is struct genlmsghdr.
> +
> +The practical meaning of the fields in case of Generic Netlink is as fol=
lows:
> +
> +.. code-block:: c
> +
> +  struct nlmsghdr {
> +	__u32	nlmsg_len;	/* Length of message including headers */
> +	__u16	nlmsg_type;	/* Generic Netlink Family (subsystem) ID */
> +	__u16	nlmsg_flags;	/* Flags - request or dump */
> +	__u32	nlmsg_seq;	/* Sequence number */
> +	__u32	nlmsg_pid;	/* Endpoint ID, set to 0 */
> +  };
> +  struct genlmsghdr {
> +	__u8	cmd;		/* Command, as defined by the Family */
> +	__u8	version;	/* Irrelevant, set to 1 */
> +	__u16	reserved;	/* Reserved, set to 0 */
> +  };
> +  /* TLV attributes follow... */
> +
> +In Classic Netlink :c:member:`nlmsghdr.nlmsg_type` used to identify
> +which operation within the subsystem the message was referring to
> +(e.g. get information about a netdev). Generic Netlink needs to mux
> +multiple subsystems in a single protocol so it uses this field to
> +identify the subsystem, and :c:member:`genlmsghdr.cmd` identifies
> +the operation instead. (See :ref:`res_fam` for
> +information on how to find the Family ID of the subsystem of interest.)
> +Note that the first 16 values (0 - 15) of this field are reserved for
> +control messages both in Classic Netlink and Generic Netlink.
> +See :ref:`nl_msg_type` for more details.
> +
> +There are 3 usual types of message exchanges on a Netlink socket:
> +
> + - performing a single action (``do``);
> + - dumping information (``dump``);
> + - getting asynchronous notifications (``multicast``).
> +
> +Classic Netlink is very flexible and presumably allows other types
> +of exchanges to happen, but in practice those are the three that get
> +used.
> +
> +Asynchronous notifications are sent by the kernel and received by
> +the user sockets which subscribed to them. ``do`` and ``dump`` requests
> +are initiated by the user. :c:member:`nlmsghdr.nlmsg_flags` should
> +be set as follows:
> +
> + - for ``do``: ``NLM_F_REQUEST | NLM_F_ACK``
> + - for ``dump``: ``NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP``
> +
> +:c:member:`nlmsghdr.nlmsg_seq` should be a set to a monotonically
> +increasing value. The value gets echoed back in responses and doesn't
> +matter in practice, but setting it to an increasing value for each
> +message sent is considered good hygiene. The purpose of the field is
> +matching responses to requests. Asynchronous notifications will have
> +:c:member:`nlmsghdr.nlmsg_seq` of ``0``.
> +
> +:c:member:`nlmsghdr.nlmsg_pid` is the Netlink equivalent of an address.
> +This field can be set to ``0`` when talking to the kernel.
> +See :ref:`nlmsg_pid` for the (uncommon) uses of the field.
> +
> +The expected use for :c:member:`genlmsghdr.version` was to allow
> +versioning of the APIs provided by the subsystems. No subsystem to
> +date made significant use of this field, so setting it to ``1`` seems
> +like a safe bet.
> +
> +.. _nl_msg_type:
> +
> +Netlink message types
> +---------------------
> +
> +As previously mentioned :c:member:`nlmsghdr.nlmsg_type` carries
> +protocol specific values but the first 16 identifiers are reserved
> +(first subsystem specific message type should be equal to
> +``NLMSG_MIN_TYPE`` which is ``0x10``).
> +
> +There are only 4 Netlink control messages defined:
> +
> + - ``NLMSG_NOOP`` - ignore the message, not used in practice;
> + - ``NLMSG_ERROR`` - carries the return code of an operation;
> + - ``NLMSG_DONE`` - marks the end of a dump;
> + - ``NLMSG_OVERRUN`` - socket buffer has overflown.
> +
> +``NLMSG_ERROR`` and ``NLMSG_DONE`` are of practical importance.
> +They carry return codes for operations. Note that unless
> +the ``NLM_F_ACK`` flag is set on the request Netlink will not respond
> +with ``NLMSG_ERROR`` if there is no error. To avoid having to special-ca=
se
> +this quirk it is recommended to always set ``NLM_F_ACK``.
> +
> +The format of ``NLMSG_ERROR`` is described by struct nlmsgerr::
> +
> +  ----------------------------------------------
> +  | struct nlmsghdr - response header          |
> +  ----------------------------------------------
> +  |    int error                               |
> +  ----------------------------------------------
> +  | struct nlmsghdr - original request header |
> +  ----------------------------------------------
> +  | ** optionally (1) payload of the request   |
> +  ----------------------------------------------
> +  | ** optionally (2) extended ACK             |
> +  ----------------------------------------------
> +
> +There are two instances of struct nlmsghdr here, first of the response
> +and second of the request. ``NLMSG_ERROR`` carries the information about
> +the request which led to the error. This could be useful when trying
> +to match requests to responses or re-parse the request to dump it into
> +logs.
> +
> +The payload of the request is not echoed in messages reporting success
> +(``error =3D=3D 0``) or if ``NETLINK_CAP_ACK`` setsockopt() was set.
> +The latter is common
> +and perhaps recommended as having to read a copy of every request back
> +from the kernel is rather wasteful. The absence of request payload
> +is indicated by ``NLM_F_CAPPED`` in :c:member:`nlmsghdr.nlmsg_flags`.
> +
> +The second optional element of ``NLMSG_ERROR`` are the extended ACK
> +attributes. See :ref:`ext_ack` for more details. The presence
> +of extended ACK is indicated by ``NLM_F_ACK_TLVS`` in
> +:c:member:`nlmsghdr.nlmsg_flags`.
> +
> +``NLMSG_DONE`` is simpler, the request is never echoed but the extended
> +ACK attributes may be present::
> +
> +  ----------------------------------------------
> +  | struct nlmsghdr - response header          |
> +  ----------------------------------------------
> +  |    int error                               |
> +  ----------------------------------------------
> +  | ** optionally extended ACK                 |
> +  ----------------------------------------------
> +
> +.. _res_fam:
> +
> +Resolving the Family ID
> +-----------------------
> +
> +This sections explains how to find the Family ID of a subsystem.
> +It also serves as an example of Generic Netlink communication.
> +
> +Generic Netlink is itself a subsystem exposed via the Generic Netlink AP=
I.
> +To avoid a circular dependency Generic Netlink has a statically allocate=
d
> +Family ID (``GENL_ID_CTRL`` which is equal to ``NLMSG_MIN_TYPE``).
> +The Generic Netlink family implements a command used to find out informa=
tion
> +about other families (``CTRL_CMD_GETFAMILY``).
> +
> +To get information about the Generic Netlink family named for example
> +``"test1"`` we need to send a message on the previously opened Generic N=
etlink
> +socket. The message should target the Generic Netlink Family (1), be a
> +``do`` (2) call to ``CTRL_CMD_GETFAMILY`` (3). A ``dump`` version of thi=
s
> +call would make the kernel respond with information about *all* the fami=
lies
> +it knows about. Last but not least the name of the family in question ha=
s
> +to be specified (4) as an attribute with the appropriate type::
> +
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	32
> +    __u16 nlmsg_type:	GENL_ID_CTRL               // (1)
> +    __u16 nlmsg_flags:	NLM_F_REQUEST | NLM_F_ACK  // (2)
> +    __u32 nlmsg_seq:	1
> +    __u32 nlmsg_pid:	0
> +
> +  struct genlmsghdr:
> +    __u8 cmd:		CTRL_CMD_GETFAMILY         // (3)
> +    __u8 version:	2 /* or 1, doesn't matter */
> +    __u16 reserved:	0
> +
> +  struct nlattr:                                   // (4)
> +    __u16 nla_len:	10
> +    __u16 nla_type:	CTRL_ATTR_FAMILY_NAME
> +    char data: 		test1\0
> +
> +  (padding:)
> +    char data:		\0\0
> +
> +The length fields in Netlink (:c:member:`nlmsghdr.nlmsg_len`
> +and :c:member:`nlattr.nla_len`) always *include* the header.
> +Headers in netlink must be aligned to 4 bytes from the start of the mess=
age,
> +hence the extra ``\0\0`` at the end of the message. The attribute length=
s
> +*exclude* the padding.
> +
> +If the family is found kernel will reply with two messages, the response
> +with all the information about the family::
> +
> +  /* Message #1 - reply */
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	136
> +    __u16 nlmsg_type:	GENL_ID_CTRL
> +    __u16 nlmsg_flags:	0
> +    __u32 nlmsg_seq:	1    /* echoed from our request */
> +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */
> +
> +  struct genlmsghdr:
> +    __u8 cmd:		CTRL_CMD_GETFAMILY
> +    __u8 version:	2
> +    __u16 reserved:	0
> +
> +  struct nlattr:
> +    __u16 nla_len:	10
> +    __u16 nla_type:	CTRL_ATTR_FAMILY_NAME
> +    char data: 		test1\0
> +
> +  (padding:)
> +    data:		\0\0
> +
> +  struct nlattr:
> +    __u16 nla_len:	6
> +    __u16 nla_type:	CTRL_ATTR_FAMILY_ID
> +    __u16: 		123  /* The Family ID we are after */
> +
> +  (padding:)
> +    char data:		\0\0
> +
> +  struct nlattr:
> +    __u16 nla_len:	9
> +    __u16 nla_type:	CTRL_ATTR_FAMILY_VERSION
> +    __u16: 		1
> +
> +  /* ... etc, more attributes will follow. */
> +
> +And the error code (success) since ``NLM_F_ACK`` had been set on the req=
uest::
> +
> +  /* Message #2 - the ACK */
> +  struct nlmsghdr:
> +    __u32 nlmsg_len:	36
> +    __u16 nlmsg_type:	NLMSG_ERROR
> +    __u16 nlmsg_flags:	NLM_F_CAPPED /* There won't be a payload */
> +    __u32 nlmsg_seq:	1    /* echoed from our request */
> +    __u32 nlmsg_pid:	5831 /* The PID of our user space process */
> +
> +  int error:		0
> +
> +  struct nlmsghdr: /* Copy of the request header as we sent it */
> +    __u32 nlmsg_len:	32
> +    __u16 nlmsg_type:	GENL_ID_CTRL
> +    __u16 nlmsg_flags:	NLM_F_REQUEST | NLM_F_ACK
> +    __u32 nlmsg_seq:	1
> +    __u32 nlmsg_pid:	0
> +
> +The order of attributes (struct nlattr) is not guaranteed so the user
> +has to walk the attributes and parse them.
> +
> +Note that Generic Netlink sockets are not associated or bound to a singl=
e
> +family. A socket can be used to exchange messages with many different
> +families, selecting the recipient family on message-by-message basis usi=
ng
> +the :c:member:`nlmsghdr.nlmsg_type` field.
> +
> +.. _ext_ack:
> +
> +Extended ACK
> +------------
> +
> +Extended ACK controls reporting of additional error/warning TLVs
> +in ``NLMSG_ERROR`` and ``NLMSG_DONE`` messages. To maintain backward
> +compatibility this feature has to be explicitly enabled by setting
> +the ``NETLINK_EXT_ACK`` setsockopt() to ``1``.
> +
> +Types of extended ack attributes are defined in enum nlmsgerr_attrs.
> +The two most commonly used attributes are ``NLMSGERR_ATTR_MSG``
> +and ``NLMSGERR_ATTR_OFFS``.
> +
> +``NLMSGERR_ATTR_MSG`` carries a message in English describing
> +the encountered problem. These messages are far more detailed
> +than what can be expressed thru standard UNIX error codes.
> +
> +``NLMSGERR_ATTR_OFFS`` points to the attribute which caused the problem.
> +
> +Extended ACKs can be reported on errors as well as in case of success.
> +The latter should be treated as a warning.
> +
> +Extended ACKs greatly improve the usability of Netlink and should
> +always be enabled, appropriately parsed and reported to the user.
> +
> +Dump consistency
> +----------------
> +
> +Some of the data structures kernel uses for storing objects make
> +it hard to provide an atomic snapshot of all the objects in a dump
> +(without impacting the fast-paths updating them).
> +
> +Kernel may set the ``NLM_F_DUMP_INTR`` flag on any message in a dump
> +(including the ``NLMSG_DONE`` message) if the dump was interrupted and
> +may be inconsistent (e.g. missing objects). User space should retry
> +the dump if it sees the flag set.
> +
> +Introspection
> +-------------
> +
> +The basic introspection abilities are enabled by access to the Family
> +object as reported in :ref:`res_fam`. User can query information about
> +the Generic Netlink family, including which operations are supported
> +by the kernel and what attributes the kernel understands.
> +Family information includes the highest ID of an attribute kernel can pa=
rse,
> +a separate command (``CTRL_CMD_GETPOLICY``) provides detailed informatio=
n
> +about supported attributes, including ranges of values the kernel accept=
s.
> +
> +Querying family information is useful in rare cases when user space need=
s
> +to make sure that the kernel has support for a feature before issuing
> +a request.
> +
> +.. _nlmsg_pid:
> +
> +nlmsg_pid
> +---------
> +
> +:c:member:`nlmsghdr.nlmsg_pid` is called PID because the protocol predat=
es
> +wide spread use of multi-threading and the initial recommendation was
> +to use process ID in this field. Process IDs start from 1 hence the use
> +of ``0`` to mean "allocate automatically".
> +
> +The field is still used today in rare cases when kernel needs to send
> +a unicast notification. User space application can use bind() to associa=
te
> +its socket with a specific PID (similarly to binding to a UDP port),
> +it then communicates its PID to the kernel.
> +The kernel can now reach the user space process.
> +
> +This sort of communication is utilized in UMH (user mode helper)-like
> +scenarios when kernel needs to trigger user space logic or ask user
> +space for a policy decision.
> +
> +Kernel will automatically fill the field with process ID when responding
> +to a request sent with the :c:member:`nlmsghdr.nlmsg_pid` value of ``0``=
.
> +
> +Classic Netlink
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The main differences between Classic and Generic Netlink are the dynamic
> +allocation of subsystem identifiers and availability of introspection.
> +In theory the protocol does not differ significantly, however, in practi=
ce
> +Classic Netlink experimented with concepts which were abandoned in Gener=
ic
> +Netlink (really, they usually only found use in a small corner of a sing=
le
> +subsystem). This section is meant as an explainer of a few of such conce=
pts,
> +with the explicit goal of giving the Generic Netlink
> +users the confidence to ignore them when reading the uAPI headers.
> +
> +Most of the concepts and examples here refer to the ``NETLINK_ROUTE`` fa=
mily,
> +which covers much of the configuration of the Linux networking stack.
> +Real documentation of that family, deserves a chapter (or a book) of its=
 own.
> +
> +Families
> +--------
> +
> +Netlink refers to subsystems as families. This is a remnant of using
> +sockets and the concept of protocol families, which are part of message
> +demultiplexing in ``NETLINK_ROUTE``.
> +
> +Sadly every layer of encapsulation likes to refer to whatever it's carry=
ing
> +as "families" making the term very confusing:
> +
> + 1. AF_NETLINK is a bona fide socket protocol family
> + 2. AF_NETLINK's documentation refers to what comes after its own
> +    header (struct nlmsghdr) in a message as a "Family Header"
> + 3. Generic Netlink is a family for AF_NETLINK (struct genlmsghdr follow=
s
> +    struct nlmsghdr), yet it also calls its users "Families".
> +
> +Note that the Generic Netlink Family IDs are in a different "ID space"
> +and overlap with Classic Netlink protocol numbers (e.g. ``NETLINK_CRYPTO=
``
> +has the Classic Netlink protocol ID of 21 which Generic Netlink will
> +happily allocate to one of its families as well).
> +
> +Strict checking
> +---------------
> +
> +The ``NETLINK_GET_STRICT_CHK`` socket option enables strict input checki=
ng
> +in ``NETLINK_ROUTE``. It was needed because historically kernel did not
> +validate the fields of structures it didn't process. This made it imposs=
ible
> +to start using those fields later without risking regressions in applica=
tions
> +which initialized them incorrectly or not at all.
> +
> +``NETLINK_GET_STRICT_CHK`` declares that the application is initializing
> +all fields correctly. It also opts into validating that message does not
> +contain trailing data and requests that kernel rejects attributes with
> +type higher than largest attribute type known to the kernel.
> +
> +``NETLINK_GET_STRICT_CHK`` is not used outside of ``NETLINK_ROUTE``.
> +
> +Unknown attributes
> +------------------
> +
> +Historically Netlink ignored all unknown attributes. The thinking was th=
at
> +it would free the application from having to probe what kernel supports.
> +The application could make a request to change the state and check which
> +parts of the request "stuck".
> +
> +This is no longer the case for new Generic Netlink families and those op=
ting
> +in to strict checking. See enum netlink_validation for validation types
> +performed.
> +
> +Fixed metadata and structures
> +-----------------------------
> +
> +Classic Netlink made liberal use of fixed-format structures within
> +the messages. Messages would commonly have a structure with
> +a considerable number of fields after struct nlmsghdr. It was also
> +common to put structures with multiple members inside attributes,
> +without breaking each member into an attribute of its own.
> +
> +Request types
> +-------------
> +
> +``NETLINK_ROUTE`` categorized requests into 4 types ``NEW``, ``DEL``, ``=
GET``,
> +and ``SET``. Each object can handle all or some of those requests
> +(objects being netdevs, routes, addresses, qdiscs etc.) Request type
> +is defined by the 2 lowest bits of the message type, so commands for
> +new objects would always be allocated with a stride of 4.
> +
> +Each object would also have it's own fixed metadata shared by all reques=
t
> +types (e.g. struct ifinfomsg for netdev requests, struct ifaddrmsg for a=
ddress
> +requests, struct tcmsg for qdisc requests).
> +
> +Even though other protocols and Generic Netlink commands often use
> +the same verbs in their message names (``GET``, ``SET``) the concept
> +of request types did not find wider adoption.
> +
> +Message flags
> +-------------
> +
> +The earlier section has already covered the basic request flags
> +(``NLM_F_REQUEST``, ``NLM_F_ACK``, ``NLM_F_DUMP``) and the
> ``NLMSG_ERROR`` /
> +``NLMSG_DONE`` flags (``NLM_F_CAPPED``, ``NLM_F_ACK_TLVS``).
> +Dump flags were also mentioned (``NLM_F_MULTI``, ``NLM_F_DUMP_INTR``).
> +
> +Those are the main flags of note, with a small exception (of ``ieee80215=
4``)
> +Generic Netlink does not make use of other flags. If the protocol needs
> +to communicate special constraints for a request it should use
> +an attribute, not the flags in struct nlmsghdr.
> +
> +Classic Netlink, however, defined various flags for its ``GET``, ``NEW``
> +and ``DEL`` requests. Since request types have not been generalized
> +the request type specific flags should not be used either.
> +
> +uAPI reference
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. kernel-doc:: include/uapi/linux/netlink.h
> --
> 2.37.2

