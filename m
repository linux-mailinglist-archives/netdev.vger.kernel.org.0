Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E254168F34F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjBHQjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjBHQjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:39:07 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C620D59C5;
        Wed,  8 Feb 2023 08:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675874346; x=1707410346;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=35cwA70pHz7BZhaoZ3lwD1LDt9QRoa2XY3c3Knu5TrY=;
  b=RO7UJh3dtNdTKafkK7kxX1rOJyEpKeW6/NVvzWr4DgI0Rt1aiFIahVnb
   erU4Fm0mzfbOL87ySHzd4soljExtZrpclls2phtCu8kAjVIiv84qjBN4P
   TeFMy7G+po91Y0kyjYHdOodc0KVqYlZwD6i930QBcA2zA15dsZA3KqQit
   wMGZ73IPDYLoR1TeAoCNlc2lk3TEBEomYFDr+CIz9Lj7eyyoQoooEEUAd
   9+84jVkKOg43TETnuoQHD47Hut93IoPsPN6KrBkumXIMnAx5ILsH2sufv
   Il+qtuHO4/SWymQ1EuGq7oEsX4n09KUsPneLOlVqtY8RFHdCvWJq/fVvw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="310206817"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="310206817"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:39:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="736001865"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="736001865"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 08 Feb 2023 08:39:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 08:39:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 08:39:05 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 08:39:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb26vZEsko8qIT+orLhMgCklbUvAEDpY6D+/IhssH9Wda7j+S2tud1vZeQxLRUSbjJ50JRDwIjz8hbWaERNn5NAoomFoNA+BaILHTksnFfsV+3ZCJqrcgkeUBHQIJfCCXU/n/7KbC6lqcyyIvPomu5zMA5nUUv6iWl8P6Na4yRspntx+3M9QNrUuHX9f3RkXQEXDZMBkz8xv1JgpsU/eZbsS7JLPLr4JpeATNZkoBvzLEWWo5yoEhMirSZClWVBABUE5bkM6WzLjxdHbG4WkXAIHDMdyAiXT/ND5p42L2//p3KVYbm0fxdHKeXDpymYq+JJu860h3/Sktyd7fSVnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jk2y4jntGeIm4AbXiqdLne3uiVgW1bY63WUmGmCnMUM=;
 b=kDXHCtbelJ2oPcgnbWRkNxhIbkgScAYEvWK5MuIOEglDKQtbgt4EnS5JZ/U17KpEYBlDraLnoo3n9P9b+Es7ICPxuJqTkREoxo92x1qeRaOuVzMnzJftp1oeJ83dwE6ECz2YhmGSY2tJG8wZYYZyoK+RD69k+2537dRkIj7mDNm/1saoHO7LzpW6Bnno/0iQlprRJ/nGaC6Jc46DsMOVx/t5Muk1dJpEFVbyWckVM/IKhrFtoux8cWiIg50U7voOZkEacjxkOZNUV91JqIiiNPsOHH49cMGIUPxhup8xJ/Y0HFB6/dVsUccxLgMRlCTHOWTGakeXdpRwmC0tqzk64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB5026.namprd11.prod.outlook.com (2603:10b6:303:9c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Wed, 8 Feb 2023 16:38:57 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 16:38:57 +0000
Date:   Wed, 8 Feb 2023 17:38:49 +0100
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
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <Y+PQGblCxIRqsYbP@boxer>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
 <20230206101921.zmslsxfzdm6ovxf5@skbuf>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206101921.zmslsxfzdm6ovxf5@skbuf>
X-ClientProxiedBy: LO4P123CA0100.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::15) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB5026:EE_
X-MS-Office365-Filtering-Correlation-Id: f3709080-ebe8-4792-b6e2-08db09f2f903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcW8ijiXt1kxvug57KI6bdoHsJZt6zinTR1KSpdIBZ0tZEyW34kk6zEpPybnj1tjN7xhsboosjpaeRXxcypL6JCuFD1l06noT3r22qAEiwka8GaC0U+blUL2lLUdfaDzUrYjD/377z/YBVvfIqHE+apqeid8pgFuLBKPcrcF3yHFJU1wOWU8PUYqM2ydkykfrYRM69+ZlwBBdmVEUM1GKbRE51owfUlx/p+4moAWyIsyOrMtDYoafthlk6hvWUCH1S9NqHQuGIh3+oJZdO5h5AP7daUYNbKwgkW8hjIiwRS4pSHxzjmmFL+xXDRgq7ZnW2FjaW4/VB8y99D6zvY0JZl7oK4lUKPGfg5x5MeBfr+FMn+dZh/RsoGcwza/KjFtItY6yZPQu1S9x5r7EGcGXpdgULm0dX+iPeAa8KaK4KsicjvqftItOPBIYDZAnSZiU6Gpl/V3uemD7R1U6q7deJhVKHOLOsYypkwl57zKSXutMkhCb9GtrrrVo7ogvAQ+tj1QHbqKQCLrK6aQMWHTvmQOFUXwEKAONJfD+VTBLS5P0KLl1XOZCdYuk0RMC0I24wPeiuTKFPVc6sFdYNzhJXqrDoI7gfrrEmvQOlfjXTqgbVaa9HXLRmq900qEMDUAzT35DacmbtJk239w2dGaGK83hSupw79sGI985sveXNoMW4OxxQ1vIvpamsKyNJDq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(44832011)(6512007)(2906002)(9686003)(186003)(26005)(6506007)(53546011)(6666004)(7416002)(5660300002)(478600001)(6486002)(41300700001)(82960400001)(8936002)(8676002)(66946007)(4326008)(66476007)(6916009)(83380400001)(66556008)(33716001)(86362001)(54906003)(38100700002)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1EPNKWoxXFO5Ng793Gsk9rO0+0XWWpembJjcIf+iBYy18YpWf1XkqgfSTMW?=
 =?us-ascii?Q?T6wTa0O72+po4RnDN/gQcfDhR2T/rwLNLV+G344QOaNd56sf6LkEvzqC79P8?=
 =?us-ascii?Q?ENijo6KE0MPtH3mrXhmlG+8IG5PkDInj8qTYTZ/SE++SpcZ9ynpYAnPJoxe8?=
 =?us-ascii?Q?DI7O++nN27wYu/JM+F31jSazETsXyXBFtXaMY7IuSoGaodBy/c5Hvpr/pAR2?=
 =?us-ascii?Q?BcZwetGTwW68e74ZEabBqI7fByZd9o1OGSHloLFbabGcniUptPV4A16vrXFW?=
 =?us-ascii?Q?b3qyTzm2Q5qAklS65/Z1Y+lvE+dx2GWfgw9XGE2wSyVNy7p69qMCeWSi0KM0?=
 =?us-ascii?Q?wE3DZ+QOFOrt/lEiXII8fpCFEEpBSCjJtJ1tApAHpBvtXd/+8VklA8SnQztk?=
 =?us-ascii?Q?3GVtqAbx7uZfc3CB3cVoX6HFrECIO8YVbuA+VvfmQWDtsRgVgGaFLd6FBqvk?=
 =?us-ascii?Q?8Bqf6bkSZ3v4fZ2N7aXDwtxc0wxufCGfzOPCK0vDxaEcsqx2qtnrs18/QBeV?=
 =?us-ascii?Q?88/hMZV8E9MMAT3g3zO0vetZxdXYAgOvSt+BPSej9rA489uZ1GQJloNfbiZR?=
 =?us-ascii?Q?iW0YYXdTf+hXG1Pq8G+c0vk424WbuLtAuPnjwA6HRplzutbewxlKRv6pFZqT?=
 =?us-ascii?Q?GFIT7WQLmrTuIA1UHZ8e2CXSreXsiu2UtIiVX3oxrRmgYfG20Jx61UyBeabw?=
 =?us-ascii?Q?c96WaSJc1GWv0wH8SayxZzHrE7cGDY2UV23W54En2dD+rNduvvj9qbw04ai7?=
 =?us-ascii?Q?oPktTNN1H+hwetevP4m5NcSlkTCeMgTZnD4o5GbmXM3LhF4LAql5Ro3aB6wq?=
 =?us-ascii?Q?B3rJlF1+jwoexQnkMTdYVoCVkW89myM3uj/811YJ1SZ1fd5gH0wkHg02Pzzm?=
 =?us-ascii?Q?koYJFqBN/rfaot44nf6TSxWduKLcWVTRUZBvdJG9LuwQW/fgixru1UIX3ZoV?=
 =?us-ascii?Q?bCyR+OlotlrO3fF1+RUDalbMgHf0AoDLQEN8iu5E+rrfxYh6PZMYIR0js2Dv?=
 =?us-ascii?Q?OMyosaA9FTeQWZ6m0YKfLTn6D5pVt1n13TpCrJLvC7IYFsh708eW7KSnPPrz?=
 =?us-ascii?Q?UOHeXwvcRvLzXJ0m6WH2hR4TwRbAeqCOshK41oaUaBUNZMKrW2Dp0WZJw7zQ?=
 =?us-ascii?Q?TchcQ9wteXXTpqC/0b+fGMMtsPEbStzrZ8rGqimgeDc1vL8idyns/uespOvs?=
 =?us-ascii?Q?97yBTAzleC6cYhVJ0dORhqSO/e/CzlV5yuVE2BJfukylMyalyFOwISErUoO1?=
 =?us-ascii?Q?MLM0uCutcso5x23PMlEukjAdYzEyz0l0nAjunvnQrBsVZXWF7l3LoNlQDIvp?=
 =?us-ascii?Q?gJuZjqKj/ITctmrTl4AhjA3R60BXgLJ4XVBlm9JprRoTG8kn0wt/lZwM3U/I?=
 =?us-ascii?Q?2qD6zWkWrOZRoLGYljrNBNHzzRzSPbOdUd6UxPMfE1JsgeKrQLvIjEE8D191?=
 =?us-ascii?Q?Bongi3aIde2Jff7ON8KaJsCsmuyVUyMtzYyOxB5t3K01RysfBSzxg4K4zC1z?=
 =?us-ascii?Q?rjy7rhr8AmQtIW9kYn1VTs+qrgY3yfoCa3Tcvu4gWpWQdSlJ6oJnt1lx5mkw?=
 =?us-ascii?Q?svsTP/wGae7GHJ0+HqceXkz+n9PJqn1C6gEsgkJFQGwt43IdDFzD4E8I5X4t?=
 =?us-ascii?Q?NrjGOhFzona+vfese3ZSql4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3709080-ebe8-4792-b6e2-08db09f2f903
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:38:56.9593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmbGdQUVSNXqzf68B7BOiuHRGRGSqhAusE+TXdtLhLYOS3vb1aSr8LujCOpuWAfd2N0TnwuPCBbjqGvvheuIuzuj+0ResGIG0SB06EEdoRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5026
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 12:19:21PM +0200, Vladimir Oltean wrote:
> Yikes, ran git format-patch one patch too soon. There's also a hidden,
> bonus patch "12/11" below. Doesn't affect first 11 patches in any way,
> though. Here it is.
> 
> From f7f10232622309d66a7a1ae1932d0c081936d546 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 25 Oct 2022 02:32:24 +0300
> Subject: [RFC PATCH net-next 12/12] net: enetc: add support for XDP_TX
>  with zero-copy XDP sockets
> 
> Add support for the case when the BPF program attached to a ring with an
> XSK pool returns the XDP_TX verdict. The frame needs to go back on the
> interface it came from.
> 
> No dma_map or dma_sync_for_device is necessary, just a small impedance
> matching logic with the XDP_TX procedure we have in place for non-XSK,
> since the data structures are different (xdp_buff vs xdp_frame; cannot
> have multi-buffer with XSK).
> 
> In the TX confirmation routine, just release the RX buffer (as opposed
> to non-XSK XDP_TX). Recycling might be possible, but I haven't
> experimented with it.

ugh premature response on 10/11.

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++++++++--
>  drivers/net/ethernet/freescale/enetc/enetc.h |  1 +
>  2 files changed, 34 insertions(+), 2 deletions(-)
