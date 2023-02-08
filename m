Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C585E68F3A9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjBHQoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjBHQod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:44:33 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3C065BE;
        Wed,  8 Feb 2023 08:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675874654; x=1707410654;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PyXTGQfUErLeQ23C3SbhI2QMLrNff7z6okg3IQck72c=;
  b=K619qy1k3PdsrVhTjb7o27evvi8IDcxdl8rYVUx0QjT/ofKNwZOA8eZZ
   fir7tJdEZz3Xrk7LLMU5ihOlPPC5vMoaaiIXrRPFH79y5Wn2MEeadAJMJ
   RoPV4K0MRKxjetxWUC89EQtM9G0CBbNPUnhaQckYV9Bei8tqVdQFlXWHG
   gfIXhLdL3Hfs6sYLec8y1F6HcQ+Jd808KsHqlaTOj9yYG/OpKO9eLJmhk
   T+d5+11W5x2IKqDJOcaYoYz3BQWifx5fsJYg8Vw9Fq+TiTs0u/BV5J+cs
   /u7Yp2GT95M1IF0RgLf9oSCAyYvZdCj3q+2F2X0YAvArs+5K+dQ7lm9jo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="317855549"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="317855549"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841251106"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="841251106"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2023 08:42:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:42:09 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:42:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 08:42:09 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 08:42:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPw61QwO62xXh5qB/2WnzyGbIqeunOJSIGtNWgScweWrKMT7UuV9Lk9kZsKKBK0Y6w6VsNxKST1K1OkU3Er8PAhffn1o7Mmwyq/5dlbU0vrY8S/cT8HunaPGZO8l6IOqlIpVYj38pcKVJDFpxMy74VPktgzNdlER4SufZoy7gmKiy+90cL8fIM06NzwzT1JCm35glBEI2nSKVIQLrlRtua6HoavHAuxgFvSsmSnf3QhdYAdYXmmgzF6p4Tdtub5v5tEWdzCdhEq/kCdVwFexydpl4Bfqd5j32uyC/Ozuw4vlaaiebY6iNnKSNxC+ihzLmJT5X4PQONhkrtQksp49MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCQSHK78RH7e0VURKzt7v2TdLZss9TFN6S3Foz0xZx8=;
 b=UDQk1MqgdTLJ8rBOj5ePsb6+RRQkXnudBP7iI+hAXycaGv4zKpqb3X9vX4Xqs6vrLiYys31/Ws2GVV+xuuomszG8D50TCcMEt+SrqUeO9CV2Ry23dSz3SPye7y7A1WJnxxyzl4yT5W6bCTnd3Gteh2DOEBkYZZOOc79tvevCm30UV0vs0GGG6U9MdgF5Db74RaDMD2aPxSdKtYYDmhkDafJqoGIerWEcrxFqq12f30ctarhcpGvnli3SnELHGILPiN7cTz6K/Q2kF/Wyj+Dy5UHRB9lz4uWa/uOJIc4sq6tSTj3IS0IHxpztFBu1pTburrlB3UKZgalmTA9Ek6tsdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 16:42:07 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 16:42:07 +0000
Date:   Wed, 8 Feb 2023 17:41:59 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 00/11] NXP ENETC AF_XDP zero-copy sockets
Message-ID: <Y+PQ1+j0l/h/6dx+@boxer>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P265CA0140.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW4PR11MB6737:EE_
X-MS-Office365-Filtering-Correlation-Id: a844ae6e-79a6-4416-a229-08db09f36a67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GEwAntXAlIu5ywR85MU3REDsNOkpzqw1dCX1IPkUY64QQcs0YZx5eetoaq1BbZkFZYWfWG60zTRjtscfIzzI9q8JcgkAHCcKay5HkfjEP+vbMiF617rcQlqVgkGJFBzgZRwqQZEXQ1UyLrMDksbTmdEi2IZiiAJ8y2bg9R68l57+7Azokx7JWJ06JdbqmdETfLl7kEaM419NNFq08/p2MzxYltsphNCEEiyskprOw/ITo/4WdCvF5eGt96dxaNBmW5yX0O7N7OxCG2P9Wk/ZH0MdOfgs4dcjFewx+EHtuX/VhC2ys6dIQ6nNQwi6G5xIxxEbIfMCTHnXYcAupTv0bChcbSF1KGjN9acINdU0PsfhpVPaqXTthflr78VfNfNoG+PIHhKlM5FDqySMdT1rjns4xVdOe1AcXi3oOpszfZT1I0/LbTiKz+9vFj2IsfNbo8pU9dTUyQZRO35lPDYEzd1qnooAlOutVKjq2IMGJk/UjqQFF/ObcuzipF3xvjnHx8P9k8Tl4c9sXk76C7osbuEZ2Oby0Dzej2OArEEbo2msTrjlrfRjsdvr3F/xCQbdtj9KtoGDjVGnrifA05xuPeMGOr84jXkOnT8Gz5yrvm6mW4nf8A5PNibD38cMiTiXsrfXCdw47VQl/4aD3Ezk0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(7416002)(44832011)(33716001)(5660300002)(8936002)(2906002)(83380400001)(66946007)(82960400001)(186003)(316002)(26005)(38100700002)(6506007)(54906003)(41300700001)(66556008)(6916009)(66476007)(8676002)(6512007)(4326008)(86362001)(478600001)(6486002)(9686003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8AXwB3wNBzbPMKGeUdVY35LGWumbXPWN707cny/meBmmfOYVJMZIwozoAqW8?=
 =?us-ascii?Q?zXUIWEi/XVEzDwP5ntOr9V4nWxEdeLURm4Qhvpe6ArD7e7h/raLhbHxwtmJf?=
 =?us-ascii?Q?Ir7uvHpsWJUNOTe3fbz/mLvscoRZc7s/tkJRtjFHLK1LQw2HyPNiNmWVm0Zr?=
 =?us-ascii?Q?y0toJT6R9ZUL93RHyGLD2Vd/hWCqO2HxlX/8fcmrYYnAZleuHncVBkAYYZpc?=
 =?us-ascii?Q?O8TUsFID7wpbZIJPkck/i1WIxuR+Swu0NPoudPAzoVcaoMQ+VkZlNuqp83mx?=
 =?us-ascii?Q?HslOH6yB/WgwaQZ9SlSSW11dQxE4gtIULfJVq+ug0fJKWqe34dwMrqA/Cext?=
 =?us-ascii?Q?BePD1HHeIVF7+2VM2m2Khjw6J5s7s3ZnLd2MvgKHZ9wQDBDFaGn3Z/Xb9dF4?=
 =?us-ascii?Q?/wuHzwx2KWQbIKEKnWKEYBtlhKR/O8+fnTcnd1ZScGDvItvkHtXv4lH7jEKl?=
 =?us-ascii?Q?sm/iIJLokfvjYwVcnFzrkMmemGwVzIhUaSJwjhOZmNrgcSmUAmQopP0l4Bkl?=
 =?us-ascii?Q?B6yA/BTw+FBaQeW6IGVg7uIsHP6pkZ6bxlMoioZdBwqsHXcrXma1331VIk3y?=
 =?us-ascii?Q?5/UfQSSn2QVP2iy+RUR2fHrszpwvTaMXArHMZakM+KXKI5bp29ZO+E9YGukY?=
 =?us-ascii?Q?d+MFs36WHWqKMXPTNUp3RRuwzHfGhg3uLZMY5n/LUjpBsXX0OjWYgP56n3/W?=
 =?us-ascii?Q?1VL8JcGwnNdaimVztdiOClnd6cgzyOd19pATGUFHjfcsVkaT2lAyZcZN1kvb?=
 =?us-ascii?Q?kyGLnNUj9xorwrzWasicbVWdD/j7NUKcJdzCdPi8JL4dl3nDU3kmXIVfQofk?=
 =?us-ascii?Q?+qgDusbQndiOrbxXIBPCg4kWrR8/XxTnvERzkEMTknvO0I2FrS8eRVfMfJqe?=
 =?us-ascii?Q?ZSIu3kGpX0n27YrI3MkJ9oGXemsa1JQvaSylihC0aDFINB8DgFqI3/LECmVA?=
 =?us-ascii?Q?3sHntsxcymw8K4ZmsCM2BoMi1sgQTEI4NW6OzRCRGFlKzxuEYosmB9sDButP?=
 =?us-ascii?Q?GZZ/dE9kDL3tRNdHnp69wkEk0jsUJB7YEKOIrfFeddRdlz08al9a3PPeL8HQ?=
 =?us-ascii?Q?bv6ikNXc7KB0Zd9NopWwCHSAQA9S2qw+oc3V8P48HbvvkKbr2g2f6z3l3swV?=
 =?us-ascii?Q?lnhEQUDEJEBVnmDCd9dZR5raQJy3//YwSOotnq6+Rbq/cSNv9896SX5feCP3?=
 =?us-ascii?Q?5k1gt0ZqdWbVtMk/gv2X/nFGj3zs/CyhEEPuF57TvlufrSEzZtgg5O798Kr6?=
 =?us-ascii?Q?OarD6Umw8dwnz5Scx1x1n5Z5XFhb7pVq2fEw0k+YbYnbxT9XJVa4Ks2JSQT0?=
 =?us-ascii?Q?WRHxKLLiY+qxlrSkj1J1noI+HsxJDZwqfMUQGPOoGSYneZ5q2ZSl3rs9Vkf1?=
 =?us-ascii?Q?15iXikut5ndE3VQ/cRnrneR/m7hrCecGoDyiDCtd7pVGVs1N/gjI8eH5vj38?=
 =?us-ascii?Q?NWvwVhcHscC0UzYowTUzLLxBrG4X/kHvTyBaMD2SdEd+A4NUfWo9MT/+tvAy?=
 =?us-ascii?Q?zyNFJqjVemHi1J3QBo/kxm6ntPPXAW2CgyTvMK4yCN9vEtgITep9QUm706Qb?=
 =?us-ascii?Q?VVpYTN+kfBtUeYYSUAQO7Wmy20egP2QzANvWn9ejhITFg918U07VndaRXZL3?=
 =?us-ascii?Q?c/BCbM6ZQnu320Nw/N5vE5o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a844ae6e-79a6-4416-a229-08db09f36a67
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:42:07.1498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8O+l6ZvFanwv02YvhEgsrHQnq3+CGHyano7Oa7lqQylWVgC6Dx3Fi1cSHmWko0CQUT3BXt1+wLQbAkhaKpckh1vFJbeZdfL74Ye9hpueLbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6737
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 12:08:26PM +0200, Vladimir Oltean wrote:
> This is RFC because I have a few things I'm not 100% certain about.
> I've tested this with the xdpsock test application, I don't have very
> detailed knowledge about the internals of AF_XDP sockets.
> 
> Patches where I'd appreciate if people took a look are 02/11, 05/11,
> 10/11 and 11/11.

All of that looks rather sane to me. Can you point out explicitly your
issues here? Is it around concurrent access to XDP Tx rings or something
more?

I commented on 10 and 11. For 2 it seems fine and 5 has always been
controversial.

> 
> Vladimir Oltean (11):
>   net: enetc: optimize struct enetc_rx_swbd layout
>   net: enetc: perform XDP RX queue registration at enetc_setup_bpf()
>     time
>   net: enetc: rename "cleaned_cnt" to "buffs_missing"
>   net: enetc: continue NAPI processing on frames with RX errors
>   net: enetc: add support for ethtool --show-channels
>   net: enetc: consolidate rx_swbd freeing
>   net: enetc: rename enetc_free_tx_frame() to enetc_free_tx_swbd()
>   net: enetc: increment rx_byte_cnt for XDP data path
>   net: enetc: move setting of ENETC_TXBD_FLAGS_F flag to
>     enetc_xdp_map_tx_buff()
>   net: enetc: add RX support for zero-copy XDP sockets
>   net: enetc: add TX support for zero-copy XDP sockets
> 
>  drivers/net/ethernet/freescale/enetc/enetc.c  | 676 +++++++++++++++---
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
>  .../ethernet/freescale/enetc/enetc_ethtool.c  |  10 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
>  4 files changed, 606 insertions(+), 90 deletions(-)
> 
> -- 
> 2.34.1
> 
