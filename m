Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121596B9892
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjCNPKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCNPKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:10:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD151BA
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678806604; x=1710342604;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Air3Qft4x8mwzR1UUSH+fmLWa4V/ZcCD9bSX8O2Rer8=;
  b=hJ0Skrw1zanXy88ZUQk5pPIzZuqKXP29WvigK65WuLyG8ELe3xNFcNml
   2xRv2VQ1ZBz8N4zjPETDBl0x+3ThhJ2vRFsHKIGXpGH1ZeBBTYJiWPNZ7
   wEtCLuNFlsbFQDbVx39cD47HgmACHeYAn5eZYK1Nm4vb/9Vc/mv7ygSkv
   nTfJdx/uHhqlE/YTxd8kWl52tbnz4abJmCF9acdY8XTNnOcpxw6swKDeD
   vImCq+Eb3D+ZinDWflnWTwfaXXPhY7MFC+Hwrci/4N55Za2Zpw42zf+MH
   MdC9Krc+oBAqoakm4GQG/hSE+AEXSkJiRTUs4uaHs8Zc+w3Q04dLaqzcb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400036976"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="400036976"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="802902096"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="802902096"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 14 Mar 2023 08:10:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:10:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:10:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 08:10:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 08:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXn9Mx1PXfHVrjypyDmM6l6wh8FsRnww8A6HKcsSJyvNyVKUddTmpj7Urm2jHFTpiooaFjsCh7cW+tHgyGe+0UA8fhXJ+9VYPGn/8zXizQFNnpme3kNFFLblCj3v+xxCiiZ3mLWN4eBQ7g7od+1vT2u6o391erqQNn56LLmR+4KcV6wJVBGexmF0szJLkPLInnt8gB4krHdzXofRDnzdLdlmVC6GkEIVDLQtQcMEq1pW2Kr02kVLkKAeC+Uooxl4LFhTETfM1A4vMnBZCjOW3LoXnAyPRkJl2fiJoFmRhq9ET7cokgwJilwMSLRGaK38+7xkODcXy70QrEq4ktMkxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKtCi5ILmlHb9ciupUQxOwBL5h1CzsOmPEZ4xU3h9Bo=;
 b=MQmtDqw6p4yq+BAKKRGKrpPRd57EZ0n1S04Gqx7k9TYIU9uUloEsjCbYkw25yAm4CIV+KQCYLGz1SLBEHwZTeqH8bZv/gNiYi4z+UiVUTK10wof1TwQyfu14raYJW4J64vpb02gIdjz0DoMFfAZNPTvS9PX+gH71oVNxlnyXqECYAqqKjILXscNOWzijc0Aa20ku39s2e1Zd+JJaHtt8eOuu2UEhTEkNEn+zdZ/UHLWKe/5uhKQl0GOu0SXi8pyj/idXdog8ol1+vjk7bPjQWCVCJHQ7gKEUrXVMGw5Q91cRMI3NmjPgG7lHKX4mUHUDVy+wBWUL0+UkIotg+5YD0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DS0PR11MB7557.namprd11.prod.outlook.com (2603:10b6:8:14d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 15:09:59 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:09:59 +0000
Date:   Tue, 14 Mar 2023 16:09:51 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <monis@voltaire.com>,
        <syoshida@redhat.com>, <j.vosburgh@gmail.com>,
        <andy@greyhouse.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2 2/4] bonding: restore IFF_MASTER/SLAVE flags on
 bond enslave ether type change
Message-ID: <ZBCOP1NrTEw8cMq7@localhost.localdomain>
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-3-razor@blackwall.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314111426.1254998-3-razor@blackwall.org>
X-ClientProxiedBy: LO2P265CA0440.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::20) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DS0PR11MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7063f3-667c-4b0a-9883-08db249e2dad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIFBIOKKDxvA4JvK14qPnKrEpEnBsoicYh2axKC7CXJ1vkTSL23/vpb0gjGpU1ZRZsB+MvZP6W5dSlCnnmF5ME+PAuhmjWsuSAqPgtWLARbo/aj4SNRR0dt45U8lk33XSKfFWzeYmquRZQrQe58cuOjq3DQxHipO1fxGypKYj6usACZx5Xfjut4iMrocVmeHxFk9CPq5emh4KOUQ7KM1gfKvnYvIURnM9mDLs4xT0p8odiU9IIz/ZA+eBFJhTfJhwdgh3exyr9znL3Yr+GPAtLLYd5xuNrnbolkoaejgJikojEc1RVcNO0W5oqe5xMhDOhlP1vm2A/IAxwsjx5111uUfhxPlI9pp2JbjSmYB5JNwuI5xUrAQueE8XpFZO6xPxjBRkrdK97aWdmuI9P4NSaylFSH0SqX1TbraQ3nhSYuPTt9ZJRl/WS7IdTQ33YG9nJZZmA9X6Lyx8IUGtWiq3swGRsbYVWwYZZor+8tJqtID+tYuC0519WZ4n/p5l6emjoB/U4jeFX4XhHK/WNoOxZO9hQDSnnNaUQuX24fK7Z2Xyu/9dYPpeSo2N/TfMyLyIxHq8fAFZtH/cu1I9ttC/S6R6jjhkmJ+mpQCmK0U1yUcFrsyinzYus88koEQ9mE5cAXB53X6L8a7vYsCHyBOtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(82960400001)(83380400001)(7416002)(5660300002)(44832011)(86362001)(41300700001)(66946007)(66476007)(6916009)(8936002)(4326008)(38100700002)(8676002)(316002)(9686003)(6506007)(66556008)(186003)(478600001)(6486002)(6512007)(26005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QFNAolt4Ijz1R309bUTCQCiZhQv3P2EUZ2fGSbHO2GspcED/58c8v+5vNlqw?=
 =?us-ascii?Q?R7noT4lMzmcecwSeJczScsvd0rxXXRxwnOkDYVqqMOCDwA8TnXwkPcGMql1v?=
 =?us-ascii?Q?27kchP2FUPCiRyu4AyuUvh0LcFEhP++XLA3enXxE8hBDEADJsKfI1cFcTxuG?=
 =?us-ascii?Q?3Ao2zXr/xmpxr6rTpXOfjyOElq4vbmv90XVYvcbunQbcfGbeaJp8SMANHI95?=
 =?us-ascii?Q?GYt5V1voKqEMAvmYKU8St9yvCy7QkF53XH0lSyfd2Gt6DI4vie7gldyvUpE1?=
 =?us-ascii?Q?3Vs3HM6HHCMo2m+QAe8qVEb92bYIX0Iukg2BM2KBJBKVLOtM3SO2rdMNpvaz?=
 =?us-ascii?Q?1ZMU1vc1OYp30hKu0m+t4HZItxcg1+nGkGkJLxZTXJbqmf9cgCD4zr7vLSMg?=
 =?us-ascii?Q?Wii0CRjQTruHbJBTL6cX+1Wb5a7VKz/MH85uj/2hOHJ3GO+oYEUtbjq/9Sg2?=
 =?us-ascii?Q?sCFpxadjmIwRj3pVD9jIiLL+DUNdvquCfmpv6OSnaViC36XHs4hBHRoL4yC6?=
 =?us-ascii?Q?Tv/1VuBjt6WhwPESCdlA+s7TnK+D76Pt7mhszKgijgQUXexvF8RWQqHQnU77?=
 =?us-ascii?Q?pALK/Rp7+lv0gT+A5aGdPsy6+tjzvI3QNV+4TOP9fiioZr0xnVPqB6897DPb?=
 =?us-ascii?Q?BFSCgHbpKMyH2bBeDlULH7UtpAHdaU/moSy20QH8LMm/flJUGghh47b7pzbb?=
 =?us-ascii?Q?r42SD6E8+pH7/RZj/ArKBAtdcTIZTHpDkLrU0yhVytsODL1UhG8AvK1m/Zgd?=
 =?us-ascii?Q?ddVh1nHudNrqpKPIbDyPA2b46Tcjue2uY4kJAWCJMeoyMYbGT6FqLHVi0VnI?=
 =?us-ascii?Q?9Vhob9neud7piU3XFrJcWl1GACBXq0nS4x5CkJKI2mGZQAM5bUeoSoEI68Th?=
 =?us-ascii?Q?UGY7P7fqcZD+9wRfxqdACdvF+WOLaoGDia6HOTBEEz1i92w0WoB/Yb7IYEDi?=
 =?us-ascii?Q?Fr7s2MbHLvq51tSVXSVN22Itu3ayYxSyVR4EU8OG/2yjuEYwLywwgj/B1fZq?=
 =?us-ascii?Q?UJAVXZPezXAxsNrwPUfQERRRglFMH8C029sKHrwKirqB1IdfafRoGOWFV/tc?=
 =?us-ascii?Q?oP0M9wqT5jHOD7MFLfnBCTpNBm3Becou2K3naw66dTd+4oerEBo1WZP3jhg9?=
 =?us-ascii?Q?/FW1u4mzSbqprijIMlsQzWRH/y+SNKfdyaGVhHPGwOWUUZRSzz4B5sBTcD+C?=
 =?us-ascii?Q?e3kWji8wscTfyn0JpVauBCVcwWeVNDkys+2ncLI2zZGdl9fAeJL89y+GehoC?=
 =?us-ascii?Q?GeVHOMT1Y6FPJYQ+Qi1i9EgxldsXgKXph5cIaHLaOI74mWsnPSfagJy2fYqY?=
 =?us-ascii?Q?CoPXSVVBz2v7aCMbtbANoD2BmOVqfr8kl6ofXiKK0j5i2YabB4o/hCtfJtpn?=
 =?us-ascii?Q?XzXTNRx3wd61PiHRkyFGOwxjpHbhfO25sgVbbumrVYzOpJU43mSPhwC2M1Ci?=
 =?us-ascii?Q?92ZcU7sTijmnhMulE3HDmW8TYL23Vz8JK3lCpK2gYFnux6M8+/VZ21QKNE2c?=
 =?us-ascii?Q?ocFX0qhV39RfWUsHKC5wKP4QUVLsELPkwbwoAHCgpXuIj0jH5C4MaAgvDdHJ?=
 =?us-ascii?Q?2TBfsxB4++Pe/g6uxqiC8fayi8TCSbP5+33f9PJz58IqEQrIK0tli6VBOxu6?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7063f3-667c-4b0a-9883-08db249e2dad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:09:59.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cg7gQZ2kM79RPF7xxrVCLTuWQi3YeEh9ZcPdBHu99ut9YquonSdKp6DledJN+l9exQWyBxgHxam3pOG6q0OxeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7557
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

On Tue, Mar 14, 2023 at 01:14:24PM +0200, Nikolay Aleksandrov wrote:
> If the bond enslaves non-ARPHRD_ETHER device (changes its type), then
> releases it and enslaves ARPHRD_ETHER device (changes back) then we
> use ether_setup() to restore the bond device type but it also resets its
> flags and removes IFF_MASTER and IFF_SLAVE[1]. Use the bond_ether_setup
> helper to restore both after such transition.
> 
> [1] reproduce (nlmon is non-ARPHRD_ETHER):
>  $ ip l add nlmon0 type nlmon
>  $ ip l add bond2 type bond mode active-backup
>  $ ip l set nlmon0 master bond2
>  $ ip l set nlmon0 nomaster
>  $ ip l add bond1 type bond
>  (we use bond1 as ARPHRD_ETHER device to restore bond2's mode)
>  $ ip l set bond1 master bond2
>  $ ip l sh dev bond2
>  37: bond2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether be:d7:c5:40:5b:cc brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
>  (notice bond2's IFF_MASTER is missing)
> 
> Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  drivers/net/bonding/bond_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index d41024ad2c18..cd94baccdac5 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1878,10 +1878,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  
>  			if (slave_dev->type != ARPHRD_ETHER)
>  				bond_setup_by_slave(bond_dev, slave_dev);
> -			else {
> -				ether_setup(bond_dev);
> -				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
> -			}
> +			else
> +				bond_ether_setup(bond_dev);

As I already commented on your previous patch: there is the first call
of "bond_ether_setup()".
Please think about merging this patch with the previous one to avoid the
compilation warning.

Thanks,
Michal


>  
>  			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
>  						 bond_dev);
> -- 
> 2.39.2
> 
