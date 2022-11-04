Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE161A082
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiKDTGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiKDTGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:06:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3151543AF9
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667588794; x=1699124794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uAc+xb4EqPLwQ2Lx1339sGccPanHF+EiSdjoCGn62eo=;
  b=fL888xZbwk49G2QcCdRwU+dhKiChGyB293kU4PC6BsIOwZSHB7IvLYHn
   Eg+ybjsgFq2zHqJY23TtHIn1FNcHNexi4hzxEtulq1SlCKYGfpMbOZTBH
   1XbW8NvYd2KlKC4OFxtMavzIP1LZBh5GaDp8T8LgPpC4qDEo94LndLQiu
   05VjOXOc9thlkhAtHzK6m7gVzyFcAnnwQJR03tFL8O97sEaVyCE9QIJVD
   eVK5AjL6a62BYJhl9WBnWPwBqMXgxI+eaakV4IF8Yj7zqzAxkcft0XNgN
   QtSSNnKnCJ5+ufW7P2xcONUxpIi40Ff4xkGDtGmn+7BtAMWBrRZXoMGls
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="290436865"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="290436865"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 12:06:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="760430476"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="760430476"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 04 Nov 2022 12:06:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 12:05:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 12:05:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 12:05:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 12:04:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiRLbFrGCnfFO9VfrdrDJ0HUfV+kqQjI4tHw94isRq3UQTMtge5LP2w/LbkIJpMgv+yPyvbzs1k3EE5QGrtcE4gjoO549nAnZ7rz1bmzXSx3riiyUCRU79dSc7zdGRvxVFGOtkQYUukIVC6ce5j8gcDmTfg7EcuWW/+iTkvCqiz3c1nDS/t1HtkhavjC07c2feeLjkcawsTMIc2ntE+Xqht93We0rVXtkYZTQCV50qdHEy2hqr+0SmkVzEoPP/R6lDPd/+gRi7lMNlHHGvbZLxPyr6BkVMi0J4zAKKE3ybOJMUtA7OML7FUSXr4nRHxxaRM82/G5FOU6CaymPC0A/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2Ht4IJwkhRkxRGCYWV2M+LDP5QCdpY00ctnIZawsJc=;
 b=DJeqpAFrHBC4/mkP9F0vr2cAU+gcybyv+4KadIfVWU8eS/EuhWgdK3lTTr6uKHzS0UDcpxoy2Y4mfEccXHxt0leBgHFmWJi4nUWegTKADoXXSHM4GtTaFCriiFBlnCZ57rfjPj5XmAsktlrseLeVwNi+/4xPXLGr3CqVwn4Vu7ZSslxzix5yEDWCP5vZ8/37zmpvfj6N0wnJNnes4T5trb3k9a6nllyOidKg3p5ARKbJSSaD3cdCljCI3kNN0ZsHGg0cPD/aQfNAKnI8UwonIEtiG+607lzzuRme83fmkzgz/KSghmdficzmPjizi46MfFygo2ZshBN+yBFHi8k3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 19:04:45 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 19:04:45 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] ethtool: add netlink based get rxfh support
Thread-Topic: [PATCH net-next] ethtool: add netlink based get rxfh support
Thread-Index: AQHY78m0wgcJEiaCt0SS8duS6dhOvq4txmAAgAE7EHA=
Date:   Fri, 4 Nov 2022 19:04:45 +0000
Message-ID: <IA1PR11MB62668635AB345ADA118BA9BCE43B9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
 <Y2Q/gmS0v8i6SNi4@lunn.ch>
In-Reply-To: <Y2Q/gmS0v8i6SNi4@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|CY5PR11MB6368:EE_
x-ms-office365-filtering-correlation-id: 4b436fef-91a5-4a30-efa0-08dabe976fea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +fdufYqbfH+Sc1+48W9es1hfht5O5P+mABH4fkaDwrfV2VxR4FAFdBOaEfmeZZI34pYcq0Ge4dGA7KRmrMsU41bAYSvUBu0tbjYpIt/v6Hbw2gQnV7jxA4zPnKQW6XzCmILd/0QbWel0f95PeLSw3swRSi+kdKXZ6yhITrIUEFNUuZkiiBlnl5pcEIqaS7SlHYjDleJrhC+oEvHP4hKRwGWKZ+G6QDb3QklMMEVRFcOVd21hZ9zAUyJHUf67oEHeMboQHX42srklIv1Q/K/ETGpqP0T9UD1FbxuclXtc86EBARdkcvvTMKW3mr6scPvngze/vtb5ULsRar5MUY7WDbln0mNEXqDiKJ6rrtpt1M3oAIrajfkrW0YQ9k5hrPAXIcK14AeXipUUgVVvp4CkJOgU7zQ8UHNRKo/pCM31GoULfT4s1z24ZIrZzj1wPFUPRQ5RWa8KXEBaTikdDEoK2VAHHuApz1hf0ThQN+EMsH3g1px69ltGl2VeZRZZB3wUp/UHDixgtEVUmzmdGikzF0yZkuAmx3cPc1tr2AsfmqQ4MAr/BxGy3MFEl8TfSqF3jRmalxD/aXRUx+8Q+P6+iM3GKVmwKJK27cXyaCqGAKRldbEHadYZz+hjpkui5PDdGeItNtXxhd37xWsL93c5tDri281t133W6AWyefP+EkYTgPa7vQkmGajb8bCsGc7gAp1UqyyeyU3nuq9yxGvsvYUDtEsqm4W44nNBNLwqtCSrFNDOy0BOWIlEgxLNW7JJ/AcLwNEq+LZWGptV2xLAdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(9686003)(478600001)(82960400001)(107886003)(26005)(122000001)(6506007)(54906003)(6916009)(64756008)(316002)(7696005)(66946007)(33656002)(66556008)(8676002)(86362001)(4326008)(66446008)(66476007)(38070700005)(8936002)(55016003)(52536014)(71200400001)(41300700001)(5660300002)(83380400001)(38100700002)(76116006)(2906002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ChF2njnX30NjT9ojL35eLhdl3gRIjR02B6F4ooswUNPIFEwb0kJX2rJot8/u?=
 =?us-ascii?Q?6HuBGb0etRo+UZ+XVn6vZ7lXr2evqgQrCvNODk9pOX3r5PBBIWc4TAAm24Yc?=
 =?us-ascii?Q?ClE1Yqhzc5VBGLGxmAUMux2xkO6IzBYTO+8nxHfukUn3rXuDnku92YOksWwE?=
 =?us-ascii?Q?Ec7SD1SGv7y7NM3FssG4k5AjLfBqrrfwS/aM0k4ixbGkPY29JfIc+QzUzTJs?=
 =?us-ascii?Q?Yi5SExE4S2D7KbwAriXfrGfeb3OinQkhGpotnJDPxytgGeFZ0ySMws57yV/K?=
 =?us-ascii?Q?0wZaDEtRkjB9NYX9JICLWSsM71ERysGo94P/o5UH4rCYOrewVcHF/3T000tp?=
 =?us-ascii?Q?yK2Uz/BzF3JbP//zeS8LQphtlStMAywQJ3ADMUNQ44NyI2TcLXWZntCXNYsj?=
 =?us-ascii?Q?7NhQnkJrmZjaNx1XvCDpzZ27ZBrKfu25zeYWm7vnaPDPbBk833PNHMqDOJKu?=
 =?us-ascii?Q?pEHWrQOvpKIZhrAPcFw5HxGD1KCF4+5N8GXH02lVWpXeniGZR3Uu4AwnwyUN?=
 =?us-ascii?Q?W85HHi76CxDQxJuHvcjwj5Zke7wuu/WcTyyGiOZhtkbbHJJT+BE7N9R787Yt?=
 =?us-ascii?Q?pBsW+IxUtnTamFLAw1Yby5/7zVcwk2ZFV49JTeSlAlC/XCUUBLdBrzKzrjyd?=
 =?us-ascii?Q?G95s/glPhrebwOQ76Z1X+VAYD8aYdBKsqq4i+hw/cb/viyJDbrx15+voYYe7?=
 =?us-ascii?Q?Xcj6uh5WSXyeTWKLijDZ+xCybvkU4Abqf2KFNAIRa49LaKxy2NhP2omQcnUC?=
 =?us-ascii?Q?BGi1YOi1y5KXq2QskBeUajSSQIH93bwHH+yvqOoEXY7hOKK3Y2EdOXpC0Ahl?=
 =?us-ascii?Q?fRO8fSr+0IA8ffna3Ul/LtGqrXEfaBBkPqirP8CT0d3nI7AsO7MgY7Ihkr8l?=
 =?us-ascii?Q?U36YqFiFh1ZFC0MfRBfdN2ZoAoyXswpVd4+w2G9bmQHGMHO6jSRBa/e28KVd?=
 =?us-ascii?Q?qhHVUIz9vEZjiJaJmo2r0MXF4W6q879kFMTaHcvq4jnkfBh9rwrPUxNfvr7v?=
 =?us-ascii?Q?RW1+IFqO7vFeF5tu0OIACqDnH8PGGZeZZrEpPar04PSnS+apGrlUI3bjWHkQ?=
 =?us-ascii?Q?QhvLOUJIxWRWAGBTZURx41zTU2oPSu08f9zdP169AA8xikqYSLVcIAcBVf0C?=
 =?us-ascii?Q?bL7Q0W0M6GFhUzu97qqVbeoU6k9QyOSx819P+erl9fuJ8RLW+JIrmLUStm8X?=
 =?us-ascii?Q?pSE/G5WfbvWr1kgg9Jsv6/SBp1CEsnSS+D2ikSPb3PiSoEFa7gre9hmNhNpL?=
 =?us-ascii?Q?iLsxL49RxLqQ4Cs8Y0j/oMLgVM5CQ4NTPvfqhiyI2pS86wg5QhRw09mbeq4L?=
 =?us-ascii?Q?vau7e9CUSghbspEmQb48S2Vnclt0hOQo7fdFQ7osJNyRcNhZLjJysXnLgPER?=
 =?us-ascii?Q?S6gq/AubKOMvpfiKRbIBYae/mIN220ek+ZZx3a8ePunwQyhZqVWWl2dKdexc?=
 =?us-ascii?Q?JgXaPSvFVcIhmOZxAEXM3t0uf3vvh+B7P40QsMHQ6C9QG9W9NhZsOEVU3Wv9?=
 =?us-ascii?Q?ZiufFORIbGU+K9dXOivcTIgF5IyML2nVuzZtr1c2QFfdgmDXvWQeXfJ6H7Fu?=
 =?us-ascii?Q?6Bw/NNascSqXyfilcYUjmFkX4CGZDAcxcRJxRqiXcwLWtEX0/PSk/wxupdaR?=
 =?us-ascii?Q?aA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b436fef-91a5-4a30-efa0-08dabe976fea
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 19:04:45.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jnor9kBmY8rSPNLg5QvfLag5zk4VUUQA3yKKZaNxt/s/vHblYKl4qw3mv5okkiUB0iKswq4sCQm8Ytx5OhpvI7mhi5EyLrbCfL9TP9t0bGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Subject: Re: [PATCH net-next] ethtool: add netlink based get rxfh
> support
>=20
> > +static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
> > +			     struct ethnl_reply_data *reply_base,
> > +			     struct genl_info *info)
> > +{
>=20
> ...
>=20
> > +
> > +	ret =3D ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Some drivers don't handle rss_context */
> > +	if (rxfh->rss_context && !ops->get_rxfh_context)
> > +		return -EOPNOTSUPP;
>=20
> You called ethnl_ops_begin(). Just returning here is going to mess up
> rumtime power control, and any driver which expects is
> ethtool_ops->complete() call to be called.
>=20
> 	Andrew

Hi Andrew,
Had used other get implementations as reference (which return early=20
since _dev_get is not used). However, this patch uses dev_get/put=20
due to input parameter. Will fix in v2.=20

Got a question wrt rtnl_lock usage. I see lock is acquired for SET
operations and not for GET operations. Is rtnl_lock needed in this
case due to slightly different flow than rest of GET ops?

I apologize regarding lkp error. Had fixed the issue but sent out
old patch by mistake.

Thanks,
Sudheer   =20
