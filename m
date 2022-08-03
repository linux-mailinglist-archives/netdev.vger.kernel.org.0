Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9C588E83
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiHCOWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbiHCOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:22:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E4C1583A;
        Wed,  3 Aug 2022 07:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659536528; x=1691072528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oeBedWNJo46GiL7eSF7VyaBbEOGVtDlZGAhnmZoRx8Q=;
  b=P/6hbOVYRC5UbamEcKzdqb1kgEMnFMWWkdO6gxHfU0ef6s5Y6O1wqpAz
   54nnzAvCbi0tCq1B86NVhfOaJDKfZKknlDAGZZawqLmKK1gzgX0+bVBln
   tXyE45TOik45DdRpozhO3SFQwzLlbCVfeGOgxK5ltf6Y8KAi+guw5EnuE
   HLJnGCmFB5KL8sXktPOGEdXU6Ba9EvpNaojHgB+ZV9mtzY6ApVs5neGkS
   gw2pNbsd7J4XImj1frPfBtY6si7b4UufEbIP1y7vkslFOmDaGwduaDxbC
   mypEp70N9I/uS9rE80HkCF6TuwPVw7UY/FlUwloR+wzaVCHzKv2DkozzT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="290456153"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="290456153"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 07:22:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="578665423"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2022 07:22:06 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 07:22:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 3 Aug 2022 07:22:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 3 Aug 2022 07:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sia9T5UKX1La5ffu3ZOnVRVrWGdygHw3MBI+tXL9siVzzKs/E3h824DXHr3ClriM4LruDQtmDJgVXMLuk1QiiGnSrYciTWbY+lmwZRNCQKxVPDECUyQhyfqU/xkYJP6q8lmHrVO4srTHgd+NlxtE780Vge6czTn6K2eD6nby3vufTyly6oLfk2ByrgcP7YVUFDFPRP6ZZx0D8hLN5Lr8b0zAf8hbRtLlbQJQmR2+4zCLDa/LGKzEYanIh3PzzuzEYeLGHM2KXjWcjL6bkp+6At3XTMfNq4KT3uKqAb3ELHBNIS6H03Mn/lE0cVfP65LNAEjODVjNkGvUMgV5yWfb+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2vjV7BxSr0Tum0iWy8oBWH8S0cHrdY6MbofRff+Ou4=;
 b=kqo3Wp/KrCvXdFJVqrBFJo48yoRQTtm1dZI4S53ybl/ETT/xoaEIo1POzSRAHb/SuIfhdEX+U3osa5+IxAgOhvZ4gkTTNI3EYCnNSmPiSr4T66Ma+RL/H6bOHh0qTC4tP7P7itDRjB5FtIX7gAQXL6bkuWHctEbNa2Vp3Hb88/gddCyySa5+cFeTLHjs1EaKgDo78fxk3I3/t263M8+dDHEmY8RuK1uPsoIJLstG8w1dnUoBU35GuBquFcvJnEkV+5xDdX22OhqdLv6Hwv7t1Lcs0PCfZzjZhemC7dF8e9j9KTFbIHKjTqMkqsud11CTz6xf8HFJR3QzQnS/0yxRTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3995.namprd11.prod.outlook.com (2603:10b6:5:6::12) by
 DM4PR11MB5504.namprd11.prod.outlook.com (2603:10b6:5:39d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Wed, 3 Aug 2022 14:22:02 +0000
Received: from DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::155b:4ee0:3b0:2b52]) by DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::155b:4ee0:3b0:2b52%4]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:22:02 +0000
From:   "Koikkara Reeny, Shibin" <shibin.koikkara.reeny@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: RE: [PATCH bpf-next v3] selftests: xsk: Update poll test cases
Thread-Topic: [PATCH bpf-next v3] selftests: xsk: Update poll test cases
Thread-Index: AQHYo05wNwxfhHM2AkKHOSsE1XAdp62Vb94AgAfQSFA=
Date:   Wed, 3 Aug 2022 14:22:02 +0000
Message-ID: <DM6PR11MB39950F8FD74FF42A3B8AEFF5A29C9@DM6PR11MB3995.namprd11.prod.outlook.com>
References: <20220729132337.211443-1-shibin.koikkara.reeny@intel.com>
 <YuP04F3bC5dSI+zJ@boxer>
In-Reply-To: <YuP04F3bC5dSI+zJ@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 078f849a-e996-4465-4fa5-08da755b88c1
x-ms-traffictypediagnostic: DM4PR11MB5504:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sSTo+7G7C2VKMm26pP/I/0xXUMz28EQjY8gasVHmKSj1tHYa6pz6nLWnKxfqj3TPxYTbPahmjkKPeu4PoQJBcGMkVxzauPHbpB0EekJ+MjQku75L1tUn8RZg3x++mdeIZ9H5PN6TMrsyLTn+mU9kZE5zctsZ5IjpF11jC5q/OAddefYkApt+9EkfPGxHcW+GTZA2qtCys79co5mqQ6+YuvGfI4td6xT141igxxLBYt8NMFfu9PdKYT2chZHSUeilNxT0MOggHdxr0zEIRA2a2Bmqykp85iNqbJuq4BQTtOc0Q5evejn7TQv4ZoPEH2GenKxryTQ2cv3sKW9UxaWBsq8b8op8jidr7GSWm3pFcQ/lf19HmMI2y2Hdtk5zSFYDWywvFn0dtHUy67iZSJ6qfLB3fuUw1dFB6uMh0UIgywuV2+6HIXgoa5yQDCc1rOCDubJ0UrCJhQ+I2EEbs9+pb66TE1HsgHJTBNV1mFt5KywnLSDWLM0Rd8FLlDGXMX7V2dNXkjXe/TuFoOWtaq1qfYKymJwTTJs7QgorFFDI1dNxX19GuBW10fw+QAUF4eGEWr3iGfDsBylEylXKjgc5pcwnbZIV20w/umVfR8/hnttcHDlox4x7VEKpFr0z9DuiqxVcvNTxtcuGvIg0jEz+vDrdKCPvoW/0RWw9MFl6RJ7P9BSfqAAr9fNhKCdc7gJaMfF+71Ttv4zvZdnfw9ytK6i8f9HOz87MpR0hxIUnl8Kjjdd0T4+czgqeiGhnSVUGrY/l57vIu8WdW1KFqdnB+lglU2ZsLkEetn8SVXkD6Om+31oY1nEqQ/kqMiC3BJWIQw1rMvQGe8Oa/gR3J5uvKJlS/ge02Bv5QdLbJ7UbbYPyIor5zeup7/56RR6CCU9GxSQsM1+LZemlyRgElZlqmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(396003)(39860400002)(136003)(15650500001)(186003)(38100700002)(107886003)(41300700001)(30864003)(5660300002)(966005)(9686003)(52536014)(26005)(2906002)(8936002)(6862004)(33656002)(6506007)(478600001)(54906003)(7696005)(82960400001)(55016003)(6636002)(53546011)(83380400001)(122000001)(76116006)(66556008)(8676002)(64756008)(4326008)(66476007)(66946007)(71200400001)(86362001)(316002)(66446008)(38070700005)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KehEr9xftJXUseFXMTb/cZ4D8kVg4EXgHv2BkdrqYZB0ohvxxr6dTCZVMLzV?=
 =?us-ascii?Q?XWGaIpRcfRVi8SjSJkgCjeefvE7K9/Ysg2FHLlogk+LJ6QblIyCnaOZFwLC1?=
 =?us-ascii?Q?bWc8C+wmG6BeSbInV+a9HqJV59RNXjl0M5kvYj5g3hLAGoKGbY5l0Xqknbff?=
 =?us-ascii?Q?j7EI1Z8mJYGi1h/lr/+5ymKs80SLtYjKWmdl5SVL45WnsRIw7/67gkHltTt+?=
 =?us-ascii?Q?G8a4aAi7MYtY+ZFmc/9lEBe4odaIUhbkHa65PBddPoISIW6YjKPSSNX0BZ5V?=
 =?us-ascii?Q?AzH+ydMAp1pRPYolkDX6dfAFfG/M3UBvrDqU1O1+neSqEa4d6EL5PgAgxtpD?=
 =?us-ascii?Q?Y0ed7Da7bT30e5yw1CjduIAMDxNKOn5v54Um9dsnuBcSyiYYYn+/jY90/LNu?=
 =?us-ascii?Q?9Ij1MYH9an1oiNh0VKZIOkSQJCwcIAPsezgQfVx0VcISJw4o5HZwl4F0evPo?=
 =?us-ascii?Q?NVPwDv/bRoy1SdBlLFqd5DKuiNR9puxMLjZMEQiKQVlqzaPPFX0v11DN+txq?=
 =?us-ascii?Q?YmInCPwDW28UXcvpZbxAempnx13ZCjPV06nj8AmbhlL8E3w7V7p4chw/zS3G?=
 =?us-ascii?Q?wv9bktB5huTRn6kxrtImg+MOjPAHiIi1CMtwNBKnLTFRgh/11MO/ssRflsAQ?=
 =?us-ascii?Q?zcl4nZ+DOkpFcfl6kNWInGteQM6SBr/Edk0/tEyXY3cJ52pBLCd4kaRUOHJK?=
 =?us-ascii?Q?gPxXH+AmtA9y+5/pVVoyyKhOuxC+MThlcgkFt+pNF0YqDbtvFqzKYg292ScM?=
 =?us-ascii?Q?0ufrZ7LAfaDulWsA3y6osUtbEJMzf0lTvFNyvABJ7aGgnInV39x+U4m/MwgQ?=
 =?us-ascii?Q?troyJK4DjfHQuTL/fJ2RGw8BBY0ZZy9OUEhDjusMqCoKZdQZl8vVA25cJxIM?=
 =?us-ascii?Q?NdjDk3ePXworyviEA9M5b4J4n2X9AHUkuE7i2l0wBwPgglUmvFSm9n3U6Y38?=
 =?us-ascii?Q?Vz9/B7NMlPvIUh/Y4Zv5Lz2U/D682XeHUVoCLjOx7Hzgs6j37tGM2L/vmdo3?=
 =?us-ascii?Q?h8PDp0EpaY3iKJcVom3r3iVWCKxjdrMWROcm0XAgSO44EZ3Mhyi5jD6tW2w6?=
 =?us-ascii?Q?Rn0zXqaItVYDs62iw3NDTZeYDd4RivKqDrD4gIKK/UTFO1HuCXWPovkIODd/?=
 =?us-ascii?Q?2S1k5yvAqye/5PV9EBEuSnu0jq2qhSV786PXX81Xkop8VqWjwIVxpSE5sgrF?=
 =?us-ascii?Q?2CvNto3NmAHEQ6EqQ64XWUOMRIbhIPJpGJxM95FH8fWrL8vwkB7rxPSCDJCC?=
 =?us-ascii?Q?AikByYxVLfb0a4g9CEtz4HMJbMc2wMkAYLs+dMbi0zZYRk6/aDFeDZbrqnl3?=
 =?us-ascii?Q?ysp3S9HgMxMIM+1xpuNGY916awBge4kWbPvfbC+T//MR4W6lYj8DJ+3n9yM3?=
 =?us-ascii?Q?oAINDW2q3fe0HD79gk//BGnG6cJt3v5TkBe7cimyFr6Vi2owsvOZK6qaNefd?=
 =?us-ascii?Q?iN2Wq36oyr0WLKjdXeNb/YZnqPbdZWdrY0M2kcgclLdQuEd3MKQX8KWWPH9M?=
 =?us-ascii?Q?w6l0QsAbw+61EfWuK+VJ6i6rbeBxiIAinCE4OgFDmTMpCm8zakRF92GOnOEV?=
 =?us-ascii?Q?2zZMkjBYq2UJwky62TaAGskBVtciIXgAae+lS4Oa/XxuJ/PtJVtjrF9LuuX7?=
 =?us-ascii?Q?owifMnjMV6GR2e5lVQ4P3uI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078f849a-e996-4465-4fa5-08da755b88c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2022 14:22:02.2565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1TVBO8wMwX/0poqzth7m7JItyrZf3tXVyT818ABREATYadtYDqaJu6dd4EYuGm7wFwkTyhWa7XCYQAdOfIBZP5aDzvQzetgMVfpFRuYS854=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5504
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
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Friday, July 29, 2022 3:55 PM
> To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>;
> bjorn@kernel.org; kuba@kernel.org; andrii@kernel.org; Loftus, Ciara
> <ciara.loftus@intel.com>
> Subject: Re: [PATCH bpf-next v3] selftests: xsk: Update poll test cases
>=20
> On Fri, Jul 29, 2022 at 01:23:37PM +0000, Shibin Koikkara Reeny wrote:
> > Poll test case was not testing all the functionality of the poll
> > feature in the testsuite. This patch update the poll test case which
> > contain 2 testcases to test the RX and the TX poll functionality and
> > additional
> > 2 more testcases to check the timeout features of the poll event.
> >
> > Poll testsuite have 4 test cases:
> >
> > 1. TEST_TYPE_RX_POLL:
> > Check if RX path POLLIN function work as expect. TX path can use any
> > method to sent the traffic.
> >
> > 2. TEST_TYPE_TX_POLL:
> > Check if TX path POLLOUT function work as expect. RX path can use any
> > method to receive the traffic.
> >
> > 3. TEST_TYPE_POLL_RXQ_EMPTY:
> > Call poll function with parameter POLLIN on empty rx queue will cause
> > timeout.If return timeout then test case is pass.
> >
> > 4. TEST_TYPE_POLL_TXQ_FULL:
> > When txq is filled and packets are not cleaned by the kernel then if
> > we invoke the poll function with POLLOUT then it should trigger
> > timeout.
> >
> > v1:
> > https://lore.kernel.org/bpf/20220718095712.588513-1-shibin.koikkara.re
> > eny@intel.com/
> > v2:
> > https://lore.kernel.org/bpf/20220726101723.250746-1-shibin.koikkara.re
> > eny@intel.com/
> >
> > Changes in v2:
> >  * Updated the commit message
> >  * fixed the while loop flow in receive_pkts function.
> > Changes in v3:
> >  * Introduced single thread validation function.
> >  * Removed pkt_stream_invalid().
> >  * Updated TEST_TYPE_POLL_TXQ_FULL testcase to create invalid frame.
> >  * Removed timer from send_pkts().
>=20
> Hmm, so timer is not needed for tx side? Is it okay to remove it altogeth=
er? I
> only meant to pull it out to preceding patch.
>=20

Yes timer is not needed. It was introduced for the poll tx timeout but the =
logic has changed so we don't need it.

> >  * Removed boolean variable skip_rx and skip_tx
> >
> > Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 155 +++++++++++++++++------
> >  tools/testing/selftests/bpf/xskxceiver.h |   8 +-
> >  2 files changed, 125 insertions(+), 38 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> > b/tools/testing/selftests/bpf/xskxceiver.c
> > index 74d56d971baf..32ba6464f29f 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -817,9 +817,9 @@ static int complete_pkts(struct xsk_socket_info
> *xsk, int batch_size)
> >  	return TEST_PASS;
> >  }
> >
> > -static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> > +static int receive_pkts(struct test_spec *test, struct ifobject
> > +*ifobj, struct pollfd *fds)
>=20
> Nit : I think that we could skip passing ifobj explicitly if we're passin=
g
> test_spec itself and just work on
>=20
> 	struct ifobject *ifobj =3D test->ifobj_rx;
>=20
> within the function.
>

Will update in V4 patch.
=20
> >  {
> > -	struct timeval tv_end, tv_now, tv_timeout =3D {RECV_TMOUT, 0};
> > +	struct timeval tv_end, tv_now, tv_timeout =3D {THREAD_TMOUT, 0};
> >  	u32 idx_rx =3D 0, idx_fq =3D 0, rcvd, i, pkts_sent =3D 0;
> >  	struct pkt_stream *pkt_stream =3D ifobj->pkt_stream;
> >  	struct xsk_socket_info *xsk =3D ifobj->xsk; @@ -843,17 +843,28 @@
> > static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> >  		}
> >
> >  		kick_rx(xsk);
> > +		if (ifobj->use_poll) {
> > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > +			if (ret < 0)
> > +				exit_with_error(-ret);
> > +
> > +			if (!ret) {
> > +				if (!test->ifobj_tx->umem->umem)
> > +					return TEST_PASS;
> > +
> > +				ksft_print_msg("ERROR: [%s] Poll timed
> out\n", __func__);
> > +				return TEST_FAILURE;
> >
> > -		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> &idx_rx);
> > -		if (!rcvd) {
> > -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
> > -				ret =3D poll(fds, 1, POLL_TMOUT);
> > -				if (ret < 0)
> > -					exit_with_error(-ret);
> >  			}
> > -			continue;
> > +
> > +			if (!(fds->revents & POLLIN))
> > +				continue;
> >  		}
> >
> > +		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> &idx_rx);
> > +		if (!rcvd)
> > +			continue;
> > +
> >  		if (ifobj->use_fill_ring) {
> >  			ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd,
> &idx_fq);
> >  			while (ret !=3D rcvd) {
> > @@ -900,13 +911,34 @@ static int receive_pkts(struct ifobject *ifobj, s=
truct
> pollfd *fds)
> >  	return TEST_PASS;
> >  }
> >
> > -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> > +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool
> use_poll,
> > +		       struct pollfd *fds, bool timeout)
> >  {
> >  	struct xsk_socket_info *xsk =3D ifobject->xsk;
> > -	u32 i, idx, valid_pkts =3D 0;
> > +	u32 i, idx, ret, valid_pkts =3D 0;
> > +
> > +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> BATCH_SIZE) {
> > +		if (use_poll) {
> > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > +			if (timeout) {
> > +				if (ret < 0) {
> > +					ksft_print_msg("ERROR: [%s] Poll
> error %d\n",
> > +						       __func__, ret);
> > +					return TEST_FAILURE;
> > +				}
> > +				if (ret =3D=3D 0)
> > +					return TEST_PASS;
> > +				break;
> > +			}
> > +			if (ret <=3D 0) {
> > +				ksft_print_msg("ERROR: [%s] Poll error
> %d\n",
> > +					       __func__, ret);
> > +				return TEST_FAILURE;
> > +			}
> > +		}
> >
> > -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> BATCH_SIZE)
> >  		complete_pkts(xsk, BATCH_SIZE);
> > +	}
> >
> >  	for (i =3D 0; i < BATCH_SIZE; i++) {
> >  		struct xdp_desc *tx_desc =3D xsk_ring_prod__tx_desc(&xsk-
> >tx, idx +
> > i); @@ -933,11 +965,27 @@ static int __send_pkts(struct ifobject
> > *ifobject, u32 *pkt_nb)
> >
> >  	xsk_ring_prod__submit(&xsk->tx, i);
> >  	xsk->outstanding_tx +=3D valid_pkts;
> > -	if (complete_pkts(xsk, i))
> > -		return TEST_FAILURE;
> >
> > -	usleep(10);
> > -	return TEST_PASS;
> > +	if (use_poll) {
> > +		ret =3D poll(fds, 1, POLL_TMOUT);
> > +		if (ret <=3D 0) {
> > +			if (ret =3D=3D 0 && timeout)
> > +				return TEST_PASS;
> > +
> > +			ksft_print_msg("ERROR: [%s] Poll error %d\n",
> __func__, ret);
> > +			return TEST_FAILURE;
> > +		}
> > +	}
> > +
> > +	if (!timeout) {
> > +		if (complete_pkts(xsk, i))
> > +			return TEST_FAILURE;
> > +
> > +		usleep(10);
> > +		return TEST_PASS;
> > +	}
> > +
> > +	return TEST_CONTINUE;
> >  }
> >
> >  static void wait_for_tx_completion(struct xsk_socket_info *xsk) @@
> > -948,29 +996,19 @@ static void wait_for_tx_completion(struct
> > xsk_socket_info *xsk)
> >
> >  static int send_pkts(struct test_spec *test, struct ifobject
> > *ifobject)  {
> > +	bool timeout =3D (!test->ifobj_rx->umem->umem) ? true : false;
>=20
> normally instead of such ternary operator to test if some ptr is NULL or =
not
> we would do:
>=20
> static bool is_umem_valid(struct ifobject *ifobj) {
> 	return !!ifobj->umem->umem;
> }
>=20
> 	bool timeout =3D !is_umem_valid(test->ifobj_rx);
>=20
> but I think this can stay as is.
>=20
>=20

I think it is a good suggestion. It is more readable.
Will update in the patch V4.

> >  	struct pollfd fds =3D { };
> > -	u32 pkt_cnt =3D 0;
> > +	u32 pkt_cnt =3D 0, ret;
> >
> >  	fds.fd =3D xsk_socket__fd(ifobject->xsk->xsk);
> >  	fds.events =3D POLLOUT;
> >
> >  	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > -		int err;
> > -
> > -		if (ifobject->use_poll) {
> > -			int ret;
> > -
> > -			ret =3D poll(&fds, 1, POLL_TMOUT);
> > -			if (ret <=3D 0)
> > -				continue;
> > -
> > -			if (!(fds.revents & POLLOUT))
> > -				continue;
> > -		}
> > -
> > -		err =3D __send_pkts(ifobject, &pkt_cnt);
> > -		if (err || test->fail)
> > +		ret =3D __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll,
> &fds,
> > +timeout);
>=20
> could you avoid passing ifobject->use_poll explicitly?

Will update in patch v4.

>=20
> > +		if ((ret || test->fail) && !timeout)
> >  			return TEST_FAILURE;
> > +		else if (ret =3D=3D TEST_PASS && timeout)
> > +			return ret;
> >  	}
> >
> >  	wait_for_tx_completion(ifobject->xsk);
> > @@ -1235,7 +1273,7 @@ static void *worker_testapp_validate_rx(void
> > *arg)
> >
> >  	pthread_barrier_wait(&barr);
> >
> > -	err =3D receive_pkts(ifobject, &fds);
> > +	err =3D receive_pkts(test, ifobject, &fds);
> >
> >  	if (!err && ifobject->validation_func)
> >  		err =3D ifobject->validation_func(ifobject);
> > @@ -1251,6 +1289,33 @@ static void *worker_testapp_validate_rx(void
> *arg)
> >  	pthread_exit(NULL);
> >  }
> >
> > +static int testapp_validate_traffic_single_thread(struct test_spec *te=
st,
> struct ifobject *ifobj,
> > +						  enum test_type type)
> > +{
> > +	pthread_t t0;
> > +
> > +	if (pthread_barrier_init(&barr, NULL, 2))
> > +		exit_with_error(errno);
> > +
> > +	test->current_step++;
> > +	if (type  =3D=3D TEST_TYPE_POLL_RXQ_TMOUT)
> > +		pkt_stream_reset(ifobj->pkt_stream);
> > +	pkts_in_flight =3D 0;
> > +
> > +	/*Spawn thread */
> > +	pthread_create(&t0, NULL, ifobj->func_ptr, test);
> > +
> > +	if (type  !=3D TEST_TYPE_POLL_TXQ_TMOUT)
>=20
> nit: double space before !=3D
>=20
> > +		pthread_barrier_wait(&barr);
> > +
> > +	if (pthread_barrier_destroy(&barr))
> > +		exit_with_error(errno);
> > +
> > +	pthread_join(t0, NULL);
> > +
> > +	return !!test->fail;
> > +}
>=20
> I like this better as it serves its purpose and testapp_validate_traffic(=
) stays
> cleaner. Thanks!

Your welcome.

>=20
> > +
> >  static int testapp_validate_traffic(struct test_spec *test)  {
> >  	struct ifobject *ifobj_tx =3D test->ifobj_tx; @@ -1548,12 +1613,30 @@
> > static void run_pkt_test(struct test_spec *test, enum test_mode mode,
> > enum test_
> >
> >  		pkt_stream_restore_default(test);
> >  		break;
> > -	case TEST_TYPE_POLL:
> > -		test->ifobj_tx->use_poll =3D true;
> > +	case TEST_TYPE_RX_POLL:
> >  		test->ifobj_rx->use_poll =3D true;
> > -		test_spec_set_name(test, "POLL");
> > +		test_spec_set_name(test, "POLL_RX");
> > +		testapp_validate_traffic(test);
> > +		break;
> > +	case TEST_TYPE_TX_POLL:
> > +		test->ifobj_tx->use_poll =3D true;
> > +		test_spec_set_name(test, "POLL_TX");
> >  		testapp_validate_traffic(test);
> >  		break;
> > +	case TEST_TYPE_POLL_TXQ_TMOUT:
> > +		test_spec_set_name(test, "POLL_TXQ_FULL");
> > +		test->ifobj_tx->use_poll =3D true;
> > +		/* create invalid frame by set umem frame_size and pkt
> length equal to 2048 */
> > +		test->ifobj_tx->umem->frame_size =3D 2048;
> > +		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> > +		testapp_validate_traffic_single_thread(test, test->ifobj_tx,
> type);
> > +		pkt_stream_restore_default(test);
> > +		break;
> > +	case TEST_TYPE_POLL_RXQ_TMOUT:
> > +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > +		test->ifobj_rx->use_poll =3D true;
> > +		testapp_validate_traffic_single_thread(test, test->ifobj_rx,
> type);
> > +		break;
> >  	case TEST_TYPE_ALIGNED_INV_DESC:
> >  		test_spec_set_name(test, "ALIGNED_INV_DESC");
> >  		testapp_invalid_desc(test);
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.h
> > b/tools/testing/selftests/bpf/xskxceiver.h
> > index 3d17053f98e5..ee97576757a9 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > @@ -27,6 +27,7 @@
> >
> >  #define TEST_PASS 0
> >  #define TEST_FAILURE -1
> > +#define TEST_CONTINUE 1
> >  #define MAX_INTERFACES 2
> >  #define MAX_INTERFACE_NAME_CHARS 7
> >  #define MAX_INTERFACES_NAMESPACE_CHARS 10 @@ -48,7 +49,7 @@
> #define
> > SOCK_RECONF_CTR 10  #define BATCH_SIZE 64  #define POLL_TMOUT
> 1000
> > -#define RECV_TMOUT 3
> > +#define THREAD_TMOUT 3
> >  #define DEFAULT_PKT_CNT (4 * 1024)
> >  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)  #define
> UMEM_SIZE
> > (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE) @@ -
> 68,7 +69,10
> > @@ enum test_type {
> >  	TEST_TYPE_RUN_TO_COMPLETION,
> >  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> >  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> > -	TEST_TYPE_POLL,
> > +	TEST_TYPE_RX_POLL,
> > +	TEST_TYPE_TX_POLL,
> > +	TEST_TYPE_POLL_RXQ_TMOUT,
> > +	TEST_TYPE_POLL_TXQ_TMOUT,
> >  	TEST_TYPE_UNALIGNED,
> >  	TEST_TYPE_ALIGNED_INV_DESC,
> >  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> > --
> > 2.34.1
> >
