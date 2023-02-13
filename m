Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5512694E7F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjBMR6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjBMR6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:58:11 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4651516308;
        Mon, 13 Feb 2023 09:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676311089; x=1707847089;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z6vjBaxD1QvCrIv4vlEV5SjgcBdx9ysMySgA0A7bP3s=;
  b=gczUrl7ht4HAroxphSPHd4SNQhQBUDFdjEwcIAlYzWGRQco7tVEk6p1H
   TMkLNsWMxc90o98hdmJOKOymCeXpCl/0Km2VXC6PKS7oX7V3BVoSH693O
   yg2qM9MUuOtY0VEo+ltjPyplX9MUZ7snQPMEIWF8HXO7VDfo99Ow8C6/R
   EFaeVX4sCd1C308OAUVE7yhoZmd79Wihe5MfB9GjzwQuLvU8TYjKcVzwV
   33hIZpkfSsYDUOduFInjIJVFYiA7ucK6qQuw63Btcd801bGIirP7eBMHc
   1FXMo1xnxmLhAfpGsV+C1wgPyO8VKaXD7SGeub05wMsJZqAWVzcEOJXi5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328657709"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328657709"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:58:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811685981"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="811685981"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2023 09:58:08 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 09:58:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 09:58:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 09:58:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfzyjUGl3qjqqrERgp8/HG4Iatsz6vJxY3dCXP57ZHt4frCWiKa9knTm7e7R3HqnD+CzPa6sak4/ectLTvddcmVLaurxmR/wOGwZapRT79BSs/wl2ybgwdFwHML6EUV+paTsGjOotwEHYgNyXU7Axxjn97+V4eEPfZnY2MrWQY0ozNZPzGMK4DO+hWGRA3dPCz+ulwTqUZuuO9dp7f0kIjcv3o0VgsolHR5SZ2ZzDB9WO5nK9OY+pcL05juvLih6vH3dHyGE5gmZWTdd/zaDzzXqSr+WnmlkhCXQ7U+B5VpOzUgwCpjLrz+HB6FYb06WkhR2QGmgN0q9VvLds7zjqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4U1eEJba5EY/ChN/qYIp3G0/YkgTFMUxFXuwR/RoO8o=;
 b=ZRJIo6ZcAOx/ZP8AXUGnRuoDKtnyKHP9KJlcFb49HEtQLGzWCfUb4Q4EHVgaZ85shZBG37yJxp2yPXNnHDJnKggnXgRrL3OwZfQGYqDb6t1JvcNzPia3BLxw0hvb+s0Ce6ECj/aZvIKsoRyvsNcpZimR0BsXynjQMfjaspBtRuphlRTIwrThessviz3c+AM8gd4v3rhjY2pEac0RnZdO8hE0yNUMms4fGuY6dMJT6n4PrO+pYVwMT+0cOD8VTEWI/lC1IVgJmw1HwT81id+hSn1wmdqw9ahATma438PSXOAbHcJRhmACM2ZNlUfiXKUSSYFOT945h04hC2PKwzWIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 17:58:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Mon, 13 Feb 2023
 17:58:04 +0000
Date:   Mon, 13 Feb 2023 18:57:56 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/6] ice: post-mbuf fixes
Message-ID: <Y+p6JAsc+OHxARyq@boxer>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
X-ClientProxiedBy: LO4P123CA0585.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a35cbc-de68-4f2e-9709-08db0debda98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZk+srrkQOR1lscbDGen3XTr/frClB+i1+sOJF2hUp+aGhzZkHQwnAhrpmqsLAdY50Z6bI3cdhGHPOxgJM5ofDD6d8MzU9xjTdvxFXPtSogxGi0E0bAivaj7RmOQ4BFr+zRKPitFwGS2p1T6SKw5HD4SLdIQ5OfgdtmqLPueG358vkemc7ScRP3lxt3pHjrbW2GFHCA8Y4JyR/X6LpeeSd6n5k1QihvK5h2ybKsWWU/uPAa3q6UJ+9goF7DGMuZzNe2M+JHPJG3zaFApNP1keaREDYsZrPFjpKOVmttqtfl598VSAw/aixSw4LX5/8fAr0aSVN0stUq7D7OoQL9RMK9iM6j8W3w0fvSn/m4luviSp6J4d1BCcefXC6tpez5OvrnY5ENZ0AzJoS/N4FhwUm5NgafOeZTiAbSHOryfyOtkogIFeKf1bwXofoNaD9s5cxdIW1an/ukkE8rnC+Ys4LKJ+0ysxOF8UESelTljoE7j7p850oBpwvX9MYZ2YVxpYWC/hOlrLG9JnU0iWepHe83A0YHmOhU7mNJEbf4ukQpMohkWsgz4tz/gA786qCRhjx1GHYXF5KDd2MlgnWc8A8evANZJSYO5yN59/BkR1oBcS+66T+QgtcSWFMcXalYPSdHTjjq3AJ71sX3caVToYuyctLSCGtFfMqx34P5KCsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(6862004)(8936002)(41300700001)(2906002)(7416002)(5660300002)(82960400001)(83380400001)(38100700002)(44832011)(186003)(26005)(6512007)(6506007)(6486002)(33716001)(478600001)(86362001)(8676002)(4326008)(66556008)(66476007)(66946007)(6666004)(966005)(54906003)(9686003)(6636002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jr4G+WpI8KflJvrxMHKkPdMmVLz6bD/TxH0tY8mh869Iy++2pNdM3fj6qQkt?=
 =?us-ascii?Q?oCvkpvSIJfIn0VwyqUVnoVrtYOyHg9Wkmdnz5zOmoPBR3MrJXln8QkLsJO2E?=
 =?us-ascii?Q?GgV8fat1tHcNlbLc5Hol9AolMX+FUOVYZDswXLryZBFS9sRiGOcNuKFITg6G?=
 =?us-ascii?Q?TvSlI2vLkyc/oJP5R7nKmCn6nKa5lp54PS0Q/sLIoznWumwFf7Q7mQINfc7t?=
 =?us-ascii?Q?obIr4lheTxP3GZ39cnoc2HeNrRL0JBM+3iDJX+2EwAMCnszsS1OwRokDOroV?=
 =?us-ascii?Q?+8TQZUShaX0lUmQ0py8O68GtTiu09VUCj0GTtN2uKYU0MtPUNrmnUnIZLKX7?=
 =?us-ascii?Q?1eaOtFo8rZyq5WKmmZKRdNRGXbZ6ypKitvBY5/SEhOfOSdmPiUjdtuLApiN7?=
 =?us-ascii?Q?uEks1iaQx22hkIneM374Sel7T1QkZJLkkolDMtq5O5IhqpTHqTP1qED4dqg7?=
 =?us-ascii?Q?6aP6PApEOovEVW9QuVyau/8LKVqKAlHcCskVefrDHhAbBvTL7bHRCJM76Mtt?=
 =?us-ascii?Q?6YJlV8cZaTCUKU3JMN9Q2Wp9lDYASaBGhWwKZR0NkAZ1uSvQCOO//owCoA42?=
 =?us-ascii?Q?yBJ1xHzbO+sSowzCAf94J2GTwfZYwNjk0fWfFmxBW3OrNC64fw5mUy2mJ08G?=
 =?us-ascii?Q?MPXKZmnDAzUhl1vGURCTew6TnbwLjeDJoDDDgFBcj0Cb6a9k4jZsMa2Hkhgu?=
 =?us-ascii?Q?PDlsR0YFXSgC49ojhIoebNxdPExsBGijBeLFjt054C3WdKDTcl4xq6xHaU5L?=
 =?us-ascii?Q?lLV3GOrl61VOy6EAsx65YpyoLww4X3gpIyFzBuZwUC3/Uc+HoqkUs9lVBEh3?=
 =?us-ascii?Q?NlWu4VH+uk53M29OQ89tpRslnuEpOexJgFnuX/QPYp4IC/l48BM4PjzAq0La?=
 =?us-ascii?Q?YPaJThJe4oPDXj3iy8ARmBHuzi/gI+4AvBtKvSBqECKKTW3P4Lfdn70heXt6?=
 =?us-ascii?Q?l7gsvgTCPqtssZ3nMNdgLggkyNju3IcT/k/QMvOBnWwbl/07orGJh0ZLjLSd?=
 =?us-ascii?Q?mE+l+ORzt+oJKZJ8ceIQ1ODcENFIBAcfucG3kq/ZFvWxggcx9ZGgt2fgU3Bl?=
 =?us-ascii?Q?dgPjxKgjIEXnPcAMe9ulpF8yqa9zB7yc+RdmDNXYC5Ma5jsGfVvVxlIemXc5?=
 =?us-ascii?Q?o71hFpxxvsoj+rQKoXNyGe4erZioKJVjvZ414r9V5BWO9TIymcbEio5NXbIq?=
 =?us-ascii?Q?WYQamgcl+ZLU66+p0dgrfuUreyfHSvVVZXlXcSOY5bSt7T/TFMVEKO6uQkQJ?=
 =?us-ascii?Q?HMasAkCgHrwK3SDKDRQ+2LShIpYs7mi8z6TYMseHC+ZPFeihp2AHfrN1iueq?=
 =?us-ascii?Q?UOW2/Y1Ff2jbSkemE5a4/7tfBXGJei5doSg1+whU9DVAqaWnDCDwrByKxQV1?=
 =?us-ascii?Q?XkG990DkS4nU3RkfKVPiXdYjxmwIGgt7cBDVjYC6ofsIaw6YY0/GMktYSYUf?=
 =?us-ascii?Q?xUqmT3g5VlhvilTENbyoRWxtov3QI0X7eVzSI+Pa2kGlIcWuONzbXQADKa1F?=
 =?us-ascii?Q?obcftoWjpTF2t8RBG7rF2zUYagjj09/DTkAL7rQJavwDBYcUJFIdVbmFTJgn?=
 =?us-ascii?Q?lmXncFHe/3D5d9wWtkgILAreCx56pl34H98oywwAf5h1IXNjlRbIrJIW67Fk?=
 =?us-ascii?Q?V0c0vIZeU+g+Dbmr0QY38Vk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a35cbc-de68-4f2e-9709-08db0debda98
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 17:58:04.0840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ronw2/JR/MmKXoUc/BR8+KfGJ/t1o2u289+EE4DOtn1vp3vFBcU6UbQAR/9rncjoHQjjOj3qBw72BRTNNcI5kzd6QD4l3YvG1scHl0qyvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 06:06:12PM +0100, Alexander Lobakin wrote:
> The set grew from the poor performance of %BPF_F_TEST_XDP_LIVE_FRAMES
> when the ice-backed device is a sender. Initially there were around
> 3.3 Mpps / thread, while I have 5.5 on skb-based pktgen...
> 
> After fixing 0005 (0004 is a prereq for it) first (strange thing nobody
> noticed that earlier), I started catching random OOMs. This is how 0002
> (and partially 0001) appeared.
> 0003 is a suggestion from Maciej to not waste time on refactoring dead
> lines. 0006 is a "cherry on top" to get away with the final 6.7 Mpps.
> 4.5 of 6 are fixes, but only the first three are tagged, since it then
> starts being tricky. I may backport them manually later on.
> 
> TL;DR for the series is that shortcuts are good, but only as long as
> they don't make the driver miss important things. %XDP_TX is purely
> driver-local, however .ndo_xdp_xmit() is not, and sometimes assumptions
> can be unsafe there.
> 
> With that series and also one core code patch[0], "live frames" and
> xdp-trafficgen are now safe'n'fast on ice (probably more to come).
> 
> [0] https://lore.kernel.org/all/20230209172827.874728-1-alexandr.lobakin@intel.com
> ---
> Goes to directly to bpf-next as touches the recently added/changed code.

For the series:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Alexander Lobakin (6):
>   ice: fix ice_tx_ring::xdp_tx_active underflow
>   ice: fix XDP Tx ring overrun
>   ice: remove two impossible branches on XDP Tx cleaning
>   ice: robustify cleaning/completing XDP Tx buffers
>   ice: fix freeing XDP frames backed by Page Pool
>   ice: micro-optimize .ndo_xdp_xmit() path
> 
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 67 +++++++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 37 ++++++--
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 88 ++++++++++++-------
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  4 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      | 12 +--
>  5 files changed, 136 insertions(+), 72 deletions(-)
> 
> -- 
> 2.39.1
> 
