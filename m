Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8CB6BDE79
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCQCLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCQCLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:11:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528A5CA15;
        Thu, 16 Mar 2023 19:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679019066; x=1710555066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OIxghcQgTnrtYwgdTfhIZpTKQTvWs6MOyBZWWH2IrDs=;
  b=ZN3lqU2c+r0ixx+yPGqL+bdGPhVjhQl5nz97DIAuD7ab2SSzKFI3fgOC
   gJiQqou8GBHB/jkoEq5UKoV1EPC2kIEeelZTjzBsUV+QSNjljHy5YJiAL
   sYASNgCMVhhMcBAD7Z6HwcGoMKfMUMecJrO/h0iobmZo1BDmRahZlr33L
   nf4s4pFG4KwtTttHSPYKOiZ8dBSG6Sx4BVaIj3wZlhLuCZF2+M0DF4Grg
   GOLEKe+a+eQ7mC5BOfJsgxouZRU9iNmaV0qWbmxSCkv0hCNl1x+Tfv2c6
   A4Mu5fTb6a8OVRGjx5yHGAx8s8GiOfLPx2phJ7R42pGHOzbIEUWffumFa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318555921"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318555921"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 19:10:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="712580676"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="712580676"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2023 19:10:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:10:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 19:10:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 19:10:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CysxdHNsprPI0+bBgQx2y6/lhydGKOod4sHu34CSBSok5zBZ3OvTfyMt2YmURG1E0j2UOtxzgXqcbT0WqxH5nuK1Kw1681LOCsPjqvBoBCCM+YSS7yYryRJNi3kqTSdmCOVUP9hMFdW/1bI0DUbHf9wC7cbkBzdH5hjMIsMMkMRJ0BMewFS/vSD/dqEKOBPgkRaNBXASeeCGZv6J25ubbU+PfyverkTyjADSV2txvBk0sSBr8iH2xNat4sVoYn5R2aSMS9kvODIINJg0Bq8DNTRBc05PMqHSt2+FVIEglPFOGf8yeP5eITD6p2QIXndgDpBTbOl48IZ0QOkbhXC9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6HywG92nBdrMLxRP4YsVmotntRFXLZy+n3/J78nTvc=;
 b=Vq4s2wH8cW8eYWVRCmdraM0+9qMWCQG0h1WMah2rqkq6HWExpmhl813FWpIZ9aPWsFfgc6/t0u4qVlBrtg23lJo2sGuxLF39khR1Quvm2brFD58s31hVuv9EII/p0B1Ihud5F1UaW4Ee0F0uAJc9QG2EOpOZMpEZLdVmMaCvro9ZQd/5xCPW0SsoDYlbwk6qPqsuQgfEmLyo44eGiOwW1TlcRLwIXgCSKsd9BVHXW0qBPZYczXLQFUC14NIYyKkDIc67U2SSmshSysWvBr+XfFoNYqlfDlniunBLNrD8NF7lBVez7iWi2nCsnd3ESsTB4pt39QcY7QMz15SWlTfoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by CY5PR11MB6091.namprd11.prod.outlook.com (2603:10b6:930:2d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 02:10:42 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%8]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 02:10:42 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Thread-Topic: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Thread-Index: AQHZWGNyiptgMBBkxEe3QmwqS1rIqK7+Om6w
Date:   Fri, 17 Mar 2023 02:10:41 +0000
Message-ID: <PH0PR11MB7587073E93849A1E43E3B1C49DBD9@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
        <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
 <20230316170013.4681d0f3@kernel.org>
In-Reply-To: <20230316170013.4681d0f3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|CY5PR11MB6091:EE_
x-ms-office365-filtering-correlation-id: 99317b40-26b0-4fa8-67f5-08db268ccf57
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BTA7RAUzjC7if2pPTTtUtfhQJlJUWvQylazbax5Z5z8Jx7PYEtb+FvsckiHL26rBDJ6BQOP5+bPii+8q3JZtKkmM6UcPCdEIP61fUko9qyHjch9YfmIX+dUpym6CC18S2mnGQdO1ln7f+7rxDnwIha5nXbvPneMbuVg9XAfiA6BjdjOJLpM57BJ22wI7W4OAwepEjwUc9xtivX91MLST+dFEH1faK/L7Yrcil2puyTBzEu1L7rMAodylAQaxF3wjHH5R1OFR0yMnYHKyLdOgN6pB0Ppm1Ktp7RbgLeqpNSvUpPRE4Ypzej09LqyL2pQcbOe9KT8efSmE4Ft7MUCzUNHvrdGIdqb3HtVO8weNRPeKfLHsKgKBQExwarep0EQ2DNXjrh8+PRbh/Rz8/RNKsKfFFFj/PyTtiR56/Cj2OOeu1B6tpHV7vlLtrXLQEEaUzdu3QVbqFCh2ydvpPZUxvVAVpvuvdUJyJA7DkjGODqfadthkrMtrkF03pBNiNg8Rk7hjKebL2xf0dhpXj1rCOl37441H6FMjuOwD66EHRm7RHZrl0RWPimRDOH/EQRAFwRAODpNl+8iAsOZ2m7bHUKulMzBWx3ZWyhlb137DE2GO6GKMx4KJHODWCtMhN9afa/bndLpPw0Jx/EihZm+k7g3w1cK/1X5SZTCAljKXc2J1PKkCuBZVHwL84ZbG37+KWqqF2hYWoJ0nrwPQVAiiyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199018)(8936002)(4326008)(9686003)(53546011)(6916009)(5660300002)(26005)(186003)(52536014)(86362001)(7416002)(6506007)(41300700001)(33656002)(316002)(4744005)(66556008)(2906002)(107886003)(8676002)(83380400001)(66476007)(66946007)(38070700005)(66446008)(38100700002)(71200400001)(55016003)(478600001)(54906003)(64756008)(76116006)(7696005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z+5hfviHxR+wIm+QtzLXQWYyNwanHSKfWJh4dvbxJtrvN3U+D0xaVNFuLPcY?=
 =?us-ascii?Q?j8cB56y5yhPtK973AGE1/HRIsqhBFtu1HUPkTOcHTHwjVujFvRA2umsEIbmM?=
 =?us-ascii?Q?XAWPTtT/7/2YhJ8f8d8NHB2VSvY/xBmBS+wV/f1uglkytq+Zek8Hng87xaX1?=
 =?us-ascii?Q?2lVrmfI0F0vF9jPOcqq3JyiMWezWwwiM5deAXrpJjqqbZ0sB+OrkK/vdyU7E?=
 =?us-ascii?Q?v/cn8IcBeEJr4BFjVFJF7G2s4Fq3SOroZdG895A+njgMwkWUL22d1NVHzsOx?=
 =?us-ascii?Q?20/4o68Dc1o7NbTfJin5KfVTsEl9R3/tYcv+ZXZ1pk+lO1dylJdYOTO/XEeT?=
 =?us-ascii?Q?A2g7zAMPigIzL5XHDqCQT+YxUOzSB0nY6Of/hhZm1VosktbNr3ZHG1Ab6cIf?=
 =?us-ascii?Q?0ZG9ik3Jc3B30MJGuv60/sG9QApWKxb1CaEgdQjh1paLSm6wAm8HAk65kEyx?=
 =?us-ascii?Q?n2QWgyXSbjuh6H6U972f+OvMQMhfOLqUs75lfUboxPo1kAsUKGMH0zGVsAm4?=
 =?us-ascii?Q?894Kq6PADByMTsMq0coP9WmZSsQia5jq93W+Uc6OobcMaV6CQT39FgCfjHyW?=
 =?us-ascii?Q?yzrIXb7Q9bDQKScJ4Yb/iv9XjNAf4dlPMhRBruwmipSgscnrcG0+n5IGrdi6?=
 =?us-ascii?Q?ePJTliZAKu476nz8Dd3LJmktfNDPObUkFY0jcXyDOzWAM8fFYJKFJlTYFQiF?=
 =?us-ascii?Q?DLhVvJlVlVupaCXv488wctNF9pNEKcJ/nIE7hhZ2XTS++4KS4N3Bot9GgA3Y?=
 =?us-ascii?Q?EEF9fpBJEiF/SdrSGwHHMtoLax+NO7hSwcZAxDf48whEOgHaXK2obcDxWsi7?=
 =?us-ascii?Q?GBapWnUJ7Etqbwbb263DQ7rmZ5Qr1YCusJmGRwBdw0lSt54RYkZTkkEU1ASY?=
 =?us-ascii?Q?Ab+OuSp6SgXtv0Y19GW/VgOu1bzK92JI6Llx+FX8cQoygZFS9UuYbKdmHnLr?=
 =?us-ascii?Q?dqIxsdHgvgoLndKFw86E+APOgRs1dnXOsv1Brhx2YhX7hpZwcdjmH7tb1R5a?=
 =?us-ascii?Q?rud4n6hir4CtkRIKOb/aa+xYExG7cis5PCx+S7zeVXrrLx/NQIHNUECDgcgL?=
 =?us-ascii?Q?jhgfbxFYKLw80aN74uP63xto7aTCBjsDhTJH6tMODdMm5QGqn+mNfr4Pcxuf?=
 =?us-ascii?Q?Wlx7NWmuUJtUmQvlAxW279tU3fEjRLvqaNjLVltfdmz+1f9fZW5gLyDvlkJi?=
 =?us-ascii?Q?qzuxbsbP391TF6w9ErBy4SHVWCUiqLa8rClktzQXrB0S21VEKGRVRCLGXl1q?=
 =?us-ascii?Q?5vXagMKjPX04dHN0HGvBnKuw6Iqbm8zHjOXUnFCr6sWz6pdD7qpwlQloq94V?=
 =?us-ascii?Q?rezUSGm5qiWfcvWTWWdL2VDDNTph6n/Ys6UdAPNeCBkBduZIZX/yo1+R1U6V?=
 =?us-ascii?Q?P2kFOXRYqG95uAgf5UAG9FBVZdPHmmN0eRpqtDwX1yuOjTqBJ/gTkliZsqvu?=
 =?us-ascii?Q?jQAhNxyxqgipqi9sEDuYNjL+M292TkFFd3PcxTOYKY9Kfyx/F7ZkwIDPB/bd?=
 =?us-ascii?Q?cHaqDWO9jjSTqD7dQAJD3JERguUz1fPrd+4lFKvB3XTagsTFdjP3oThUEkhF?=
 =?us-ascii?Q?rL3TSniVPPRXKgzw8HWM5ZpcieRRxUK0lKicmhPVbREZXeXZdfZs1MnF1SJt?=
 =?us-ascii?Q?RQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99317b40-26b0-4fa8-67f5-08db268ccf57
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 02:10:41.8477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TW5u+3jxVOj1rTOsi4dO28/p/dGTjnPyrcweiuZp0OlupY8rxFKCc7Bq4ZVIF7axda/B/rKSM6KFCMqyydIXm69IJe3Lw82Q2EXpglaMTSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6091
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, March 17, 2023 8:00 AM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller
> <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>;
> Maxime Coquelin <mcoquelin.stm32@gmail.com>; Ong, Boon
> Leong <boon.leong.ong@intel.com>; netdev@vger.kernel.org;
> linux-stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle
> parsing
>=20
> On Tue, 14 Mar 2023 15:02:07 +0800 Michael Sit Wei Hong wrote:
> > +		fixed_node =3D
> fwnode_get_named_child_node(fwnode, "fixed-link");
> > +		fwnode_handle_put(fixed_node);
>=20
> fwnode_property_present() ?
Good suggestion, will modify and submit in next revision.
