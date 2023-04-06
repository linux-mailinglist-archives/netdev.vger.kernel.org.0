Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEBD6D9B57
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjDFOza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDFOzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:55:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEB8658B;
        Thu,  6 Apr 2023 07:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680792917; x=1712328917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HKwXeC4gJmFWHjDoMNiSRzO3810WjzUsdT45opmTd/M=;
  b=VWrhNmwH/QZs0Lrj099ACFR6ZXy/SJQlcunR3dvYa/KhX7kKW67QAzcF
   E8oH2+Z3SyuxW7bC0YuqmFRrl3pJKLSYz8ubs8sUAbIDMkIKhgllFI2hL
   4zZu3X1O8IuPuqt8oZI2YoOBxdDHp1y79evpIDB5M6jidceF6PhhcosGx
   23fwe5EVcBDytM7srxRyv3fn5mErJeOuwap7xlx/66HVsboy3EQfZI0OB
   TdDlf7nZNSSvs/Xzd4agPMemtRK7bKHIi/pU1FAb586RjPw0WFX/Znemu
   epqcFAB+EKjVO/U/o2IioHOlj3/Hj/U824S6QfdNvsEY2ry0KbrtnNxRz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="331390330"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="331390330"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 07:55:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="776501402"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="776501402"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Apr 2023 07:55:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:55:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 07:55:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 07:55:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qi+U+bGIbJtyRzWuTlBHlU8+Ss2uBToKyAI5Mom/+NA6sla0wrnoTlElVIw1Rb8OuICujFAObedR1ry4+a49muaJMnIkT4nVGFdLPE63WawRU2R2FKZHln+Firyp/g8iAx2FtaAcdAToqijj6SVNQluDXwQjy/C8mW9PeZ55SBSkev+tgBJ6oUBxZZK7Cv+qNNXiTXsAPO6nDWr756iZQlfffurQDOuD1ZSksk7NelB0m9e989+bI3YwjQkVcLwZrZS0ZZIVsJw76aLtI5zGGQuCWYUorMGyyLumVhDPt8Q8w2QDEyj7FUEsReH/oKINdzL0SyepZmB9mkw/8P55+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfFPPrgv2Aospdb+I/+DLlF4QFnJlB9RM38R3eE8vtA=;
 b=Ys7ElIWE0jTZ2O1oeBZ+FUWCfw/YiZXmQHrGaM5x3CIP4FF0Ack3HF1zGP5d9sXs74bIk3VKDdBWM53XNOrCpm8Q4CcSE7djfgjIsvEHJ3qwPVlOqk6bQ0R7J7cOt4xtaKjQ9+x06A+7UsLleMI7Y/lxXMNW3i7JeouHF3LdNeLjQXeXBAtbiPC8gCJ0b8eb3i0nYu40WHb27AFgpGxlHc++XJxrfOt2gFk6H46AceRhcM/qPsGi1rVu5YXvdyVl1lqKejBaZWZD39k0BkYZK53d0C1qDWg4JLDNPoDyDh/wfb1rm7RvNNx8WmfRyFTiSkDVNliLlw6q2+cqm69ijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by SN7PR11MB7706.namprd11.prod.outlook.com (2603:10b6:806:32c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 14:55:12 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.030; Thu, 6 Apr 2023
 14:55:12 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v2 1/1] net: stmmac: Add queue reset into
 stmmac_xdp_open() function
Thread-Topic: [PATCH net v2 1/1] net: stmmac: Add queue reset into
 stmmac_xdp_open() function
Thread-Index: AQHZaCjPoE45kAl1EUCQfkGhSeNfhK8dh+yAgADXKDA=
Date:   Thu, 6 Apr 2023 14:55:12 +0000
Message-ID: <PH0PR11MB5830FCC231A972444EDA7CA7D8919@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230406014004.3726672-1-yoong.siang.song@intel.com>
 <20230405190429.5db41f58@kernel.org>
In-Reply-To: <20230405190429.5db41f58@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|SN7PR11MB7706:EE_
x-ms-office365-filtering-correlation-id: 226702f8-4f66-4491-8f5e-08db36aeecb0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpXrTP2WnNzaT45uG5leH7BwJg5cyJN1HxcYYaQ28RbtBdo718BwFpPcKfaxzpA8qBnZaK+NtNZmg2JNBVRCbXVEH4B3uJhVDi08yOfEV2VlWqDUFuOC3JaciRpu437v4HpdQL6lu41MF7GHGBWxIs9Z0X1zaKiKaLyH8imTqPSplOCpmzxQEusAklkzrCetehHffNTAKCfg9onwO4b5yrvQsulKW4AuQxT7ooytEsldUA5qCI05MFa4CZaLpz17919kJomc0XEg7qwPf4P4pljGhzP/CMlwe9IyO+YR0tYtC4p+SOjyO9s8btxc+AthJeGoNhH6s1CM/6Sshol2CEr9odsNWeFfj/jMZ+1JSYO7y9OAqgI3GTofnkccukahEZcwFSxRdKi0rtRDzriVNKRkhg7hnj8AFxAzml9pwET4y/ta6bedMclKXSy++nEKAbVxgpKKXb6h/H1zWuqSJRMOYtiMz4wTKmke3sr9bTCqjy6GcNFKo3w1unDv7bPQxwCZ4ZpXaDcyZ5TfxH+PfKW+bRCg7nL6pNFZEoEA1BQlVPnu9WVGF4l9VbkJUkW82G7Kdx9LeiQqL4LVzPm8FBtUDcngSSrGFvmSSAGWldABR8nGaax8iV3vEqzyzqyOZmlDsf5WV+9IQpoCm8LV+6K2yVeV2LjTS39hEi6tqkY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199021)(558084003)(2906002)(478600001)(186003)(55236004)(55016003)(6506007)(9686003)(26005)(33656002)(7696005)(71200400001)(52536014)(38100700002)(82960400001)(6916009)(86362001)(5660300002)(316002)(41300700001)(122000001)(38070700005)(4326008)(8936002)(7416002)(76116006)(66476007)(66446008)(66556008)(64756008)(8676002)(54906003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PbHBsE6tDrUuxZz4w1cC7DE+C03XbuS66PhV8wpS2yfA8inl6/189Y5Zmz4z?=
 =?us-ascii?Q?jzhr19Wda/vyOaucD7yFW0u6MhQ2B3GWJQycDSauF0mYIg5U+CDnb5X4A4Uy?=
 =?us-ascii?Q?mIZNpGs6SvmnP5D/t7AYweRKJ5t1e+cM2Ho6uJDWuvwVBecTxSoMChTs47BQ?=
 =?us-ascii?Q?g5EbcH2J50qbu6FdOl+ORXj1pox2pXD9MvdeX3SrsGNwG5j9sJKnGmz3/b9h?=
 =?us-ascii?Q?bRxFQvwWBJWKTL3ivgIQLc5tCbVz9zpG6gWamrDe3Ebykvi/nM94eWLXG8qI?=
 =?us-ascii?Q?7y4AYaCt6UgrWpKBri4s/opksr8jda7SQHRrOU5qsvyI5WHOqoTz0EnSBFXg?=
 =?us-ascii?Q?rTQJsImUlXvKKY9va1sBTCWjwmVLwc/72aP8P4wFEIGEJlgQJwBH4NW7jEat?=
 =?us-ascii?Q?vBHQcb/fzB8RuAw0wrJzqb3KFtyOdjUTTzFSJj8RKaAEZyHSsUBFx0PB5fzl?=
 =?us-ascii?Q?lrg/8ULgAYjN/xjRu3N1cocG5594AWBsZ3X2uVRsi12xToVeS4+RGB6qC+xB?=
 =?us-ascii?Q?YOKM+P9nB+oOP/9g3SLydLU3spvVE2v3RMTnV3bwQjnRKrXKSFAjal+tiETn?=
 =?us-ascii?Q?bufY1gbc3TRpzADMjTmj3gzHNbWd21EUFJ+mRLOmBh/XbM8Xwj7617Bm4Mbd?=
 =?us-ascii?Q?8otE+JrOvLo2FwmS1N0Do+c9z275p78ElwEKd7S2OZ1kXXhx+Ooeml60iDJ/?=
 =?us-ascii?Q?RzYa7Oahrx35tUunXylQzUxc7DsdsEPDwXP8cbuDt9zUUq/81JdMJ15XhhDY?=
 =?us-ascii?Q?93TTQBAy3PzarSrnIq9aSlYBPh8JencSZDQo3yKFwd97PxVnjRDzINaUrA9C?=
 =?us-ascii?Q?9WEfbyawbaa5/As5jsVFw5Hxswu3l0480Lmn3b75TyYzf8ttg68lkb06j208?=
 =?us-ascii?Q?7gmdMFL41P0j/N1SC0RjHQGR0k2SPYOmL0AeyffwJwI39YtpQEA+rx9gE02K?=
 =?us-ascii?Q?meHfk0W90F3y9Ne9bPkYUvx0hAxRT4oh/dOFFO+StuiOMt9XFyPhsGncZk2E?=
 =?us-ascii?Q?1wW+E4Ogtj+kA/RXknNwBffHKbWQK3Y2kPHY0JJ7ZHV5tnB4U/7DlR2ghclw?=
 =?us-ascii?Q?63vZnAaV24Ndqdag9NV50u9ddmGxY9nk/82CvDjCnVYwFOLqaY5mO0Iunf3/?=
 =?us-ascii?Q?Tc7PYH6BYio5za9MTDSDTSrXdSTeB19E1dmFtuEqiUnDwsVqI+NmZ7Pwzmvd?=
 =?us-ascii?Q?f4Kz5h5cK7cgPSfGhv0MyjDnUM/LOb1jzRgF2q/qhkxTTx/50sSinpi5dMiP?=
 =?us-ascii?Q?3+18VKCSJan50vwSDzfHWWRFjCCsbm3UR7fgIXRFB3uAkHe/DhIunMxTHbiW?=
 =?us-ascii?Q?ANRTlztUJPmaKVOPJHBk7KOI5IIwm3xjbcgUVJAVi0C0vMruPr8jfDaK0Xn2?=
 =?us-ascii?Q?tmiRfEsqpXMViLYoVc5pZ6oPIxjzkNd/xN9DSuHRb4v7H6PvEc13qQY0p+Ai?=
 =?us-ascii?Q?p7JW8Ww5jBqlt3OdnCqWRsZa6qobex0M14aCkwBuL2HZfnukov0f2Q3+217v?=
 =?us-ascii?Q?OdzPZdgYY6ggkt1lYtVAsxYw2Kx1Ot4pK0mG+jrOoZMVzEgIEb7X4Xep+B/5?=
 =?us-ascii?Q?eG0Go+dzoieH40ZUiEXGpNkIXZiUZYYaVRqVrbrG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226702f8-4f66-4491-8f5e-08db36aeecb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 14:55:12.5741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qDBT/HCqJy6IxyRzqkAC0qOPDAtaQnRBKttMAZMuPJuN65IyPvf2F0FBZ5bjEH4T4piUkxqpm1K4mbICzCN3dvbYcckyZAx5h/rI5okh2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7706
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Thu,  6 Apr 2023 09:40:04 +0800 Song Yoong Siang wrote:
>> v2: Add reviewed-by tag
>
>You don't have to repost to add tags, maintainers will collect the tags se=
nt to the
>list when applying the patch. I'm taking v1.

Noted. Thanks.
