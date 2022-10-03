Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9025F353B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJCSFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJCSEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:04:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036F6358
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664820280; x=1696356280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uUgESMG0Ssbc1VjZw+nf/iUfoScMAQvm3uUmI3D94Ek=;
  b=YuZidyb0tBMWu90mtySxAJXjFPJdBKx9PeFwYSsYrRts46aLY/sofwzr
   x2mnecsNoItvjce1ND65ca5IM1K2ebBZQL88KZJtnwEhgQu44XHzSvjjF
   zCfVv5QINDDcRoQllLUZXDhOIv2fQ8Reuui4fNHLrJ/BLYnXUsNrWmxsI
   eXWVZ7KUhiboyv9+qS4ltMNoKgNV+NW2I+BrjuzZ2xsZAvQewoFVncshp
   8mPouLUQdimP5/yDz0vHdZPtTcNQUvvCCL7p3T+apr7NhRdBxyZvDtzWR
   rv8ZnqbouGDwILwX9/hGhefEEon15ThpDaTjHqUJ5ipgNCVFsNjUQgLX7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="329116913"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="329116913"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 11:04:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="618831810"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="618831810"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 03 Oct 2022 11:04:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 11:04:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 11:04:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAZodW7wE2G4/fuHh7wTW5gNiLlzbfw3Ebe4wAC3FzHWK47flQPMU3naLCIPY2z0BolPo+xVMu1my42AXwyDk5QjyUjQWwMMdpEEKVKafp1h847m8boJaFdLf0DiQLemNnMXImsV4n+WjWgvmBffMdztdxMXbucImaSU//AwF6NPfFv/IyU4BAOb4pDRtzSxdJwkUIGl5cnX5fsCw2yKus6VwMn0ysGHGJQLZdvvFOZjl+97WSberHlhfpOpheOjUFmNbqi9jN8xoere0kz0qVs87DfQR+Y+8tdrF1BvdBVPEAFjrOkW6K3Cm7ocZVR71depMJkCQaKfd5r/bcX2/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUgESMG0Ssbc1VjZw+nf/iUfoScMAQvm3uUmI3D94Ek=;
 b=TbEmXYAHhbAyex2/+XSPPa3/h81XcTxgGMnQC3ykAFitY8WvFXaGCx3/E10BPG+lY2pWkyRYpHn3DMFfD7CfnmzwBl1i9bPZyEd9pejH7wNGPFTdVROEqbVpzOxVZmmTQvaO/xFa9usrBMKMW8+3GqCas9KLTp3l07X1TJZmpLVzlz2+HH6DucF67eAy1fX77M1TzpI4mqGrMJoOZFngBt/QicwQ/8gEB/ZPof2g9WtCe57DK5WKhW0W6bFK8IypcGfi+MPnrHMxd2Ylps98AweagQepnz96nSgS6fYqTEi1eKxId/G+g4+Cs3ea3TapodiRk1m7Jk/elCNOBooxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5534.namprd11.prod.outlook.com (2603:10b6:5:391::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 18:04:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 18:04:31 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        "Prashant Sreedharan" <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "Yisen Zhuang" <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Bryan Whitehead" <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        "VMware PV-Drivers Reviewers" <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Eran Ben Elisha" <eranbe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: RE: [net-next v2 0/9] ptp: convert drivers to .adjfine
Thread-Topic: [net-next v2 0/9] ptp: convert drivers to .adjfine
Thread-Index: AQHY1Q4SwN1qw7BONkSQDXk8Zq0/ca3854kAgAAQ7GA=
Date:   Mon, 3 Oct 2022 18:04:31 +0000
Message-ID: <CO1PR11MB5089218BA8A7842813349789D65B9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
 <20221003095438.404360f8@kernel.org>
In-Reply-To: <20221003095438.404360f8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DM4PR11MB5534:EE_
x-ms-office365-filtering-correlation-id: 476fbbbf-4cdb-4b18-88c3-08daa569b8e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sQtRwRwX6lVgqgQUjhbtIHWlFmuBgdYoeVEw74fMe53dyterKeNr+qC4G1pbunrRCH046db6EYa2rDY8mPujPuggQ/WOvOMbUYeEfY4mAKhtzSp8NXj/Yh9J3rTMYIVr7pI6RHjhp0wAhIUsViJI73F9ZBQm9EPNgECv002wUeP2cZ67GwNYAOlOReqzoSfK6vhZB9xYKWFHWyq0FxI5kvVMYkQu/dTi0kC+Bm3Den3P5dpjVredr3rUZnJV+6AkIgJD2IPuW9v0/hAZPS4RlNhHDg/2XTGFeVr3vxWn/CVdeOjM5rCGqBQDyhdL9ZJGUQBVAGVyf6/NXiqC9JLoqd9JAW8AIPIcOf45dyodPe31JYqCQzUmzH/5bFIhFNn0Iq2VM5u3WCYyW+EkOpf+fujRj7jPKLFfUZkb0XWx63wVOxKFxg60l+a5Rf7xv5tFZSY+va58Qm+fsZTTOeMchCrvS+s/ZI+D/N+UhWNwYZiYdYIE5foF1vxpMM2mQknkL2Ly2mMFPsVvfI2J5znKKVaOWZP4XPS/6cEloiwRyOuDCLG0mka3GILoh2+CEVc2pcbogbDPm9NM8An4w5Ed//6n4mu8upKv3UQ92GwQv2ZBHe61IiTSOdDBuIoU7XKSAHYi+Wsn6Jmsqd1w/dYRIDNXLA7OKBwt2V15ECcWaSKq723qkFypGv2OKrvW8oRQm5D+KE3LiycL2rRUb1bmrkE0b7s27TMhLGrXIAapTWFdJR05PjCbPa9S3miX8VCQJtPHFWoNb+MGj1lDjxBMteHECgoBtRfQISQvn3mSBI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199015)(54906003)(316002)(6916009)(86362001)(33656002)(9686003)(7406005)(38070700005)(7416002)(82960400001)(83380400001)(186003)(122000001)(38100700002)(53546011)(6506007)(478600001)(26005)(71200400001)(4326008)(66476007)(66946007)(66556008)(66446008)(64756008)(76116006)(7696005)(8676002)(5660300002)(41300700001)(8936002)(2906002)(55016003)(52536014)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xrz1fMUAyspS7Ctpx2f9GYjtEzOdT5MmKsIaFs4L0ZpNJqeqFHl8v4ckUe3K?=
 =?us-ascii?Q?4yfR6JKaff0lsjdr6zqc7+f145R6CQGC5r9hsNmtiZC/X5U0lxX6fQ9lfYZz?=
 =?us-ascii?Q?bJOeVC7sMsQQQW3hAMQ7Bb4qZ+R9TrlA+q0prQgXl3HBKYKa+z31mxJFMPqv?=
 =?us-ascii?Q?7bG6z7EKYR6d82EGNvwo19jkZtupie76vEtfsLWEsA+vfUZMDfnU0OnjZ5L1?=
 =?us-ascii?Q?D30ErUA8k2y0CFsFULV6syDDVFO0INyuPnNh4FNGlrGSBwu+Ytd909hKQUgW?=
 =?us-ascii?Q?QEoNAk6dvJtf9aZQd04/RtPxzGx2SK4/EwF204xXD4g7cEYnT4qhsMMG7SY5?=
 =?us-ascii?Q?Aaa+rpb38OiYsqy5hCzdG94gwc/NMnfjt79tCjlHmAkFWKYNZaNjQzmo6+3v?=
 =?us-ascii?Q?Kk7+IqJ5HJmMPwIATE7dFuYoXBaNPx3NMyShD7wadiZEYnugRBi/xQYnftge?=
 =?us-ascii?Q?QsbHAGKl/yFYdzEKQji4zRgU9eapCiJ1MIS+vbY2V9GVb7Lm82+jn/2efj7y?=
 =?us-ascii?Q?v5Q9cx0RfeF453YxC0Cj5eaLIX6YHIInLeb3BE78sOa6bPg4R4sxzYMF6KMa?=
 =?us-ascii?Q?wxO/eAsoXmv83Cjfx9/4MUvxfFsa38Bi/Yt2u2BVZkm5goHbjYHMI/aG92Q+?=
 =?us-ascii?Q?t1rGtEOpL1sQct1Ga42IMJA502CHT+ZbozkUTQxO78IqvVpL92KdMc1csLQM?=
 =?us-ascii?Q?GHgC4dQrVCikbyf61jNs7oIkHmkd/lq0nq98NZoInUTc/SZi0dPOE2eqntNH?=
 =?us-ascii?Q?yXht2ZQ3kXtVRq3Oid7jQcGptgv4WCUQsXy8LLE/L5r5ie/AJaLHHviuwv4K?=
 =?us-ascii?Q?z3FeB6cQpHgqDxMY+AM/WbwUA8/ZFInudTuM9UGUpYjqjjJe/BNvZT36nTtV?=
 =?us-ascii?Q?xMNDP6DIKdFrCMuyirGJovx+B6uRsfSb9LR5AGpynBT1GtE/AMV26Jc8s2PR?=
 =?us-ascii?Q?LHVresP0ibeZ6j1fGJMyaCYi6DzKI7STpWwLFqQZrUf27Dc+xA9bcTn5ClOg?=
 =?us-ascii?Q?ln//3z5KYX9ryONfxLhebkRa/59XT2FehHjqWPPpz281GK0ZvcWinAEiLIAL?=
 =?us-ascii?Q?sldn5cLaa79Sz30vsUN9ibXPpHDwrNHhLujsbY+Ewloro8Uwe3xPFFpbQjq5?=
 =?us-ascii?Q?no2HtGAKNzb5Wx223Rmlazs6GS5uVzIkpOrwhiZxJ7psRnwAoKE8HgBk4B39?=
 =?us-ascii?Q?piu62oROfRpazSV2+plzYU6JEDvKtofiLrYx5jgPJT0zXFJivhueA4FWDFPj?=
 =?us-ascii?Q?R3Ckmj3HCewL+0lpOejzloT6tKldJxu5p2lLm6DFFsfz0x44yLA9LGeXM4yl?=
 =?us-ascii?Q?b/of6IkdSHQmha5ae+Bcms5TEBcfQiaA9XKMK5QQFdr2PioWsjxvjcXbpbom?=
 =?us-ascii?Q?mYtszD7NNdIlLdrAvv84QmNAqn6rcpjwzv8xf4TcX5YXQOuZkV3hY9r2a604?=
 =?us-ascii?Q?Z4cYlWvTsWxr3Q8gt6NfvpVEAc6z5J8cUqz4IDKT6lPIvfDipwGTv6N1C4mj?=
 =?us-ascii?Q?x6LxdEUjhFX7o1oLxGyVwHqwGnkU6hXqEgg4+yie0AgK1EPP5QUwW2EfjiLU?=
 =?us-ascii?Q?b6R+0MIJtNIa04omEx+aN2Ku0hptWqo+rA1fS1zs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476fbbbf-4cdb-4b18-88c3-08daa569b8e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 18:04:31.8117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfBZrXhz0a0sp5iOqYL2UPWYzzoz/6/3UJG+12l2AynMBYSqCKqoBDEJzytM2nz8ykeiXbyCQaPc+U50TyT83UgNolgPn28yWD7+fGl0XDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5534
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Sent: Monday, October 03, 2022 9:55 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; K. Y. Srinivasan <kys@microsoft.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Cui, Dexuan
> <decui@microsoft.com>; Tom Lendacky <thomas.lendacky@amd.com>; Shyam
> Sundar S K <Shyam-sundar.S-k@amd.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Paolo Abeni
> <pabeni@redhat.com>; Siva Reddy Kallam <siva.kallam@broadcom.com>;
> Prashant Sreedharan <prashant@broadcom.com>; Michael Chan
> <mchan@broadcom.com>; Yisen Zhuang <yisen.zhuang@huawei.com>; Salil
> Mehta <salil.mehta@huawei.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Tariq Toukan <tariqt@nvidia.com>; Saeed
> Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
> Bryan Whitehead <bryan.whitehead@microchip.com>; Sergey Shtylyov
> <s.shtylyov@omp.ru>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> Alexandre Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Richard Cochran <richardcochran@gmail.com>; Thampi, Vivek
> <vithampi@vmware.com>; VMware PV-Drivers Reviewers <pv-
> drivers@vmware.com>; Jie Wang <wangjie125@huawei.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Eran Ben Elisha <eranbe@nvidia.com>; Aya
> Levin <ayal@nvidia.com>; Cai Huoqing <cai.huoqing@linux.dev>; Biju Das
> <biju.das.jz@bp.renesas.com>; Lad Prabhakar <prabhakar.mahadev-
> lad.rj@bp.renesas.com>; Phil Edworthy <phil.edworthy@renesas.com>; Jiashe=
ng
> Jiang <jiasheng@iscas.ac.cn>; Gustavo A. R. Silva <gustavoars@kernel.org>=
; Linus
> Walleij <linus.walleij@linaro.org>; Wan Jiabing <wanjiabing@vivo.com>; Lv=
 Ruyi
> <lv.ruyi@zte.com.cn>; Arnd Bergmann <arnd@arndb.de>
> Subject: Re: [net-next v2 0/9] ptp: convert drivers to .adjfine
>=20
> On Fri, 30 Sep 2022 13:48:42 -0700 Jacob Keller wrote:
> > Many drivers implementing PTP have not yet migrated to the new .adjfine
> > frequency adjustment implementation.
>=20
> On a scale of 1 to 10 - how much do you care about this being in v6.1?

Eh, this can probably wait till after 6.1 merge closes and we can queue it =
into 6.2 instead. That would give everyone a bit longer for catching any is=
sues and more time to include fixes that won't need to be ported back to ne=
t.

I guess I'd say like a 2 or 3 then.
