Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4546BBAA8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCORNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCORNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:13:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BB285A77
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 10:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678900411; x=1710436411;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kc0/8G0qP6LZLJAB4OD+RrC5c32/waTrM7VVb7Pb2iA=;
  b=gRhXyf6uZX8lZfnUvIK21BfZMi7bdkgZMEfRlIQ37hOK7dtnf98larNK
   +44/ctRTfYXhgg0wgVLJSuxLXSmhA313Bkhozc+LePfBwife3K3NSTCDM
   qbP5Mk+hexmKKzbsKnZ7jExjlKgNdUuU6Q+cmGjDCvXZDx5K7LIZobrsa
   1P+Htj+zgDvFl+Hctmgl/GINKP0O99EEoMi2JnB7XHqudxrYkH72Q7F/9
   PZ/0mzkqU95n7qA2pjodgg/31qTYc0swykCHgHBGVXy+D+MY9E0YxAl5/
   dpCmDQVCBb428UUKvDHrHMwwfAB39kA3DiBKtBE//RIYoBIUqPxMNFMS+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318166846"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318166846"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 10:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="709752909"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709752909"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 10:13:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 10:13:30 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 10:13:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 10:13:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMogsAKMeBP1PHW10KEUsS1Gfg07L3yzj26v0t17M/ge5rkmwC1mCnzaC0eR606dHwPqt+gn6CcOv90CokRwRz31hM6Af53E/kVZpXisQUsySKoIGRm4IPFg7Rr37ovYunB5DQPj8sygTCMtzC+N56ALtYzqVteVRz475ApVxvKrdMk7ePniDWnSEVm//Z3C87EB9Ch/WIAd9+nSJb7h+qLI+vMshiwMePB0CozwkCxhpEtucn1U4EC9dZelxElXNC4GD5/0Riax9n4yUW6Gy3IJ48WasHOqavH+1Lkf5KfzXSZQYhvkS/XMOKccG1uOucp69os2fiELZxJorgqCdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrhY0/OFi4J9FmYpvW7Z+96dUU+DA0OLARZNTXWJ5kg=;
 b=UT0DwmoOyVX7moqY1eHOCLDoM6RT8qRwanSl+Wjp0aZfkgW+ToygAGlOncN8y7koyAOJhj+ck4dWVP+YRgUPW5xUApalVyCEc2qwEINsVrQjA5NpqHx8SeyfAGmINzlH9osFPe5wUwxHuiIkKmCebyUsi+dD/Tu3lOiQqpdjFrxxS1Dufo497d9+Zo695T8GVOYVBysub+TzhN/k1EdbvMW/+nGYjhHiO6agEZbnWe9xjv4LR5Et+lIJZbnnk8YGI/E38d0Uy3Z9VSOfAToq3Y2RqJP0vRYIy8fb6EvzzqW8UzbVygYEOolaOVI+q87acygbH8AmQbltqWk75IOJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ0PR11MB6792.namprd11.prod.outlook.com (2603:10b6:a03:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 17:13:27 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 17:13:27 +0000
Date:   Wed, 15 Mar 2023 18:13:16 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <maciej.fijalkowski@intel.com>,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next v3 1/5] gve: XDP support GQI-QPL: helper
 function changes
Message-ID: <ZBH8rEi533KEjvKC@localhost.localdomain>
References: <20230313202640.4113427-1-pkaligineedi@google.com>
 <20230313202640.4113427-2-pkaligineedi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313202640.4113427-2-pkaligineedi@google.com>
X-ClientProxiedBy: FR0P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::6) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ0PR11MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bef7bc6-a73c-4983-9e6c-08db2578975c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I90RoFTMKZw9MAaGuicty9Fd4UQLNtqz0iAgX/LOQuIpElEk57K68IYgvS4HN89NZuVhjGSF/wZuHLcpHuGdXW2KffoZHaYFlUvyAO2Cgie+AoQKZ/6WkDVxksxVODBlS8rRUu6dy4v+suKsr7neIKX27E+LzM52gLej7HAWn7ixGcpwLQEUPkAXeNs1CpiHC3Xspa5ftTQ3RD+to/tXMWevdLDrTRvc/B7MTEmHMaeK7hXBD8CZEsjwoHvZQ0WV3tQZEYuOezv3qoCX7qbroHi5R48WNtq+KMYagKE+620UVd5eO+MDRvWFsDR0i4S3XUvDfdeZdKprRiOcB1YHSMcfoKJCbJJzAKYsSEujKkBKfxcp2j03r/XfOT+CX9F7EA3TeNDL8E1BOG1xtU1ynTYDmDaXYDB1C5SAfdUuIAlWcoQTrhcKis/HsH2OwIMarzSw3+XEAftpfSHlgpRP8zbkhdgH2PAhY6mn4VD/O9Sc7UNJhNnK05qUXxZ5EqWJZNVTTvW2yWYpkytfMpD08Bb9bqALcF/o7Y3fnjA1mTX+P8dRkTGg0n6QZKfyKK9zFubzs56j0FpXzMSXJHDy4G/+RBUY4zt/NMIpiRpbF2COlYamLh5stTT10P4tICa7yOVOUfNBf58D7K3dx6idGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199018)(5660300002)(44832011)(66556008)(83380400001)(30864003)(186003)(478600001)(9686003)(6512007)(6666004)(6506007)(6486002)(26005)(38100700002)(66476007)(6916009)(316002)(4326008)(8936002)(66946007)(8676002)(41300700001)(86362001)(82960400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I3Hf3ddCH0Jz+VypDR+dv0vrOZZ3Nlo09mWUIipy+1M/zl+sdgS8TNrSSpqK?=
 =?us-ascii?Q?r2lqMIzRX+4bDpV1hgnNxWqILypdHB520Yg5daSGO/ZeCwG3bmiQJnZcg40B?=
 =?us-ascii?Q?n3RTp1ZXMgpHJAIDPLy3yL0xLWu7ORAFCinGLOX3XmJeFXCt7tN7S+idiCwg?=
 =?us-ascii?Q?FGanQIrgMVAt2ZvWz8PBZTNaotZ7Moyuw71qthgJwtVVriIyrDy4jA14EXtt?=
 =?us-ascii?Q?Ww3SnGFXtHeGHC5B9x56W9AkHkZOdGuCj7qgZIBJIArj8qjs7lXxHKNf8JtS?=
 =?us-ascii?Q?pbmKHUDQU7eCJydBMQX56crLSkXvWuA1BnUfu8Agi88KmbO0UOd8dyjAClH9?=
 =?us-ascii?Q?4HipSR6E8RZghH4HQfTSv8rqeY5/D449OWUL9iB9TQr6+/ioyEZmmsqkdAPD?=
 =?us-ascii?Q?HDH1qm/72RguFsx7Q7Ckcdnqddhm8DBF+l+UH8PSSqOzl4g/4hcd1ZZSBMtu?=
 =?us-ascii?Q?5ALgnDsEqkd2Wk9ENwtiU92FF35Nt14Og4qNvbxGyv3Th4cuqHJI51DQQyCW?=
 =?us-ascii?Q?Z9lb3FHEYHEF9GRdFgrjst58HxIYvXJ41QDLCNOZLbSv9gKvHEO/K+a2bB/T?=
 =?us-ascii?Q?KXtV4NM+VTYSDW0cEndJby7+w/L3BfNftrBCo2PsAgiUoMXELL3IAVq4xZ4a?=
 =?us-ascii?Q?e02+ig+SzWy7ZCUhSPk3hsts+WPBeSt2FcDSuk+C2w3KTkFfRrHF2NLpXLfB?=
 =?us-ascii?Q?5jR8qKpfNiLn5bUhJfK36X2e14n5zOV5nU1xgpJk/6I+fsDeR3M4bx65WdbJ?=
 =?us-ascii?Q?JsSAulB4Kj8T6biRL9mKo4SNk8W1cJqli7guXzMWJYjJWISwAv1bniLANo+N?=
 =?us-ascii?Q?A3qEIpXEcolteuXOhhkk/o3h6T3ZU/xt86eUh/LVh6jRKaIM8xRrY2UsErN0?=
 =?us-ascii?Q?QTK38WvK4t775W0C7HgY4ipdgNVpjaigt88QhApAE8TV8/TmadPrcIneAJMB?=
 =?us-ascii?Q?IRCx2hi3FbMaghIKGvGOBxl6Tg9lHqQYWfllOkrth8HvGK5gRCU16yhDe4Jp?=
 =?us-ascii?Q?IYuB0S/Im3W1utR7D9Hanhk4PHO5xhmQrEmgQfeC9GjrpKOjdwonIw/r0WSm?=
 =?us-ascii?Q?HvsNCpHKVese4xQrG6wRaoPb01JnnyA+cmluzk64Dl3P7jmssw9eD7bQnZJ0?=
 =?us-ascii?Q?KC73GonKDjHmNRc1l5lUtOZhYN3aap9bh3NlxMWcigk2sW4VtbtF5uVr/cuL?=
 =?us-ascii?Q?z89pXOtwaagdnfGV0fRdQQmjG1O1XdiXoJahiK/7okX8n8PUVe51LRQ4bumw?=
 =?us-ascii?Q?p2u+LVjFRj/DvOEa2RdBajlxW8ByKvHD5wUDBO6X34WgclU0FJoD9KzJnxzU?=
 =?us-ascii?Q?9MdUt94GB40Z0rXNiDoSrzPv6L1QTbnCZTWqgEUs8mfh1lydOnf0mGrcZLYi?=
 =?us-ascii?Q?IJtqwCtbyNinyDQyPUNx90RRP2ZsXpkPFbVCI2l4MlVzrlaz2qpx5HmkAxEu?=
 =?us-ascii?Q?sCkh3+beSPGn2O/f8tAtpH79zDfkDPcfKdWKL4Hn/IQzN3ciS8vCn0Bght2n?=
 =?us-ascii?Q?gMqZI7jJ3EpbnQFzDrvkIE6baiJw4VKvCPuDZ375wFagoGEyJX9ACfjfJmbD?=
 =?us-ascii?Q?gu1kCzGzWOo7rmRFJZn3euc2FjpwMcV/7vmGNBEwXf3Z01CFsm75LB6W15aR?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bef7bc6-a73c-4983-9e6c-08db2578975c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:13:27.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVYATq5p/N0G9cJYvZLVCKaZZeU3rts/6l8hE9hoFzsSMa5IRqYgk/vxAkQKaI4RNeZbIhmMrlvB1/Mg26FFVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6792
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

On Mon, Mar 13, 2023 at 01:26:36PM -0700, Praveen Kaligineedi wrote:
> This patch adds/modifies helper functions needed to add XDP
> support.
> 
> Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> Reviewed-by: Jeroen de Borst <jeroendb@google.com>
> 

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Thanks,
Michal

> ---
> Changed in v2:
> - No changes
> 
> Changed in v3:
> - No changes
> ---
> 
>  drivers/net/ethernet/google/gve/gve.h         |  5 +++
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 26 +++++++----
>  drivers/net/ethernet/google/gve/gve_main.c    | 27 +++++++-----
>  drivers/net/ethernet/google/gve/gve_rx.c      |  2 +-
>  drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  2 +-
>  drivers/net/ethernet/google/gve/gve_tx.c      | 43 +++++++++++--------
>  drivers/net/ethernet/google/gve/gve_utils.c   |  6 +--
>  drivers/net/ethernet/google/gve/gve_utils.h   |  3 +-
>  8 files changed, 70 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 64eb0442c82f..f52f23198278 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -855,6 +855,11 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
>  		priv->queue_format == GVE_GQI_QPL_FORMAT;
>  }
>  
> +static inline u32 gve_num_tx_queues(struct gve_priv *priv)
> +{
> +	return priv->tx_cfg.num_queues;
> +}
> +
>  /* buffers */
>  int gve_alloc_page(struct gve_priv *priv, struct device *dev,
>  		   struct page **page, dma_addr_t *dma,
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index ce574d097e28..5b6e31812fae 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -81,8 +81,10 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
>  {
>  	struct gve_priv *priv = netdev_priv(netdev);
>  	char *s = (char *)data;
> +	int num_tx_queues;
>  	int i, j;
>  
> +	num_tx_queues = gve_num_tx_queues(priv);
>  	switch (stringset) {
>  	case ETH_SS_STATS:
>  		memcpy(s, *gve_gstrings_main_stats,
> @@ -97,7 +99,7 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
>  			}
>  		}
>  
> -		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
> +		for (i = 0; i < num_tx_queues; i++) {
>  			for (j = 0; j < NUM_GVE_TX_CNTS; j++) {
>  				snprintf(s, ETH_GSTRING_LEN,
>  					 gve_gstrings_tx_stats[j], i);
> @@ -124,12 +126,14 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
>  static int gve_get_sset_count(struct net_device *netdev, int sset)
>  {
>  	struct gve_priv *priv = netdev_priv(netdev);
> +	int num_tx_queues;
>  
> +	num_tx_queues = gve_num_tx_queues(priv);
>  	switch (sset) {
>  	case ETH_SS_STATS:
>  		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
>  		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
> -		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
> +		       (num_tx_queues * NUM_GVE_TX_CNTS);
>  	case ETH_SS_PRIV_FLAGS:
>  		return GVE_PRIV_FLAGS_STR_LEN;
>  	default:
> @@ -153,18 +157,20 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  	struct gve_priv *priv;
>  	bool skip_nic_stats;
>  	unsigned int start;
> +	int num_tx_queues;
>  	int ring;
>  	int i, j;
>  
>  	ASSERT_RTNL();
>  
>  	priv = netdev_priv(netdev);
> +	num_tx_queues = gve_num_tx_queues(priv);
>  	report_stats = priv->stats_report->stats;
>  	rx_qid_to_stats_idx = kmalloc_array(priv->rx_cfg.num_queues,
>  					    sizeof(int), GFP_KERNEL);
>  	if (!rx_qid_to_stats_idx)
>  		return;
> -	tx_qid_to_stats_idx = kmalloc_array(priv->tx_cfg.num_queues,
> +	tx_qid_to_stats_idx = kmalloc_array(num_tx_queues,
>  					    sizeof(int), GFP_KERNEL);
>  	if (!tx_qid_to_stats_idx) {
>  		kfree(rx_qid_to_stats_idx);
> @@ -195,7 +201,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  		}
>  	}
>  	for (tx_pkts = 0, tx_bytes = 0, tx_dropped = 0, ring = 0;
> -	     ring < priv->tx_cfg.num_queues; ring++) {
> +	     ring < num_tx_queues; ring++) {
>  		if (priv->tx) {
>  			do {
>  				start =
> @@ -232,7 +238,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  	i = GVE_MAIN_STATS_LEN;
>  
>  	/* For rx cross-reporting stats, start from nic rx stats in report */
> -	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
> +	base_stats_idx = GVE_TX_STATS_REPORT_NUM * num_tx_queues +
>  		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
>  	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
>  		base_stats_idx;
> @@ -298,7 +304,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  
>  	/* For tx cross-reporting stats, start from nic tx stats in report */
>  	base_stats_idx = max_stats_idx;
> -	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
> +	max_stats_idx = NIC_TX_STATS_REPORT_NUM * num_tx_queues +
>  		max_stats_idx;
>  	/* Preprocess the stats report for tx, map queue id to start index */
>  	skip_nic_stats = false;
> @@ -316,7 +322,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  	}
>  	/* walk TX rings */
>  	if (priv->tx) {
> -		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
> +		for (ring = 0; ring < num_tx_queues; ring++) {
>  			struct gve_tx_ring *tx = &priv->tx[ring];
>  
>  			if (gve_is_gqi(priv)) {
> @@ -355,7 +361,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  			}
>  		}
>  	} else {
> -		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
> +		i += num_tx_queues * NUM_GVE_TX_CNTS;
>  	}
>  
>  	kfree(rx_qid_to_stats_idx);
> @@ -502,7 +508,9 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
>  {
>  	struct gve_priv *priv = netdev_priv(netdev);
>  	u64 ori_flags, new_flags;
> +	int num_tx_queues;
>  
> +	num_tx_queues = gve_num_tx_queues(priv);
>  	ori_flags = READ_ONCE(priv->ethtool_flags);
>  	new_flags = ori_flags;
>  
> @@ -522,7 +530,7 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
>  	/* delete report stats timer. */
>  	if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
>  		int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> -			priv->tx_cfg.num_queues;
> +			num_tx_queues;
>  		int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
>  			priv->rx_cfg.num_queues;
>  
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 07111c241e0e..3cfdeeb74f60 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -90,8 +90,10 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
>  	struct gve_priv *priv = netdev_priv(dev);
>  	unsigned int start;
>  	u64 packets, bytes;
> +	int num_tx_queues;
>  	int ring;
>  
> +	num_tx_queues = gve_num_tx_queues(priv);
>  	if (priv->rx) {
>  		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
>  			do {
> @@ -106,7 +108,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
>  		}
>  	}
>  	if (priv->tx) {
> -		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
> +		for (ring = 0; ring < num_tx_queues; ring++) {
>  			do {
>  				start =
>  				  u64_stats_fetch_begin(&priv->tx[ring].statss);
> @@ -180,7 +182,7 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
>  	int tx_stats_num, rx_stats_num;
>  
>  	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
> -		       priv->tx_cfg.num_queues;
> +		       gve_num_tx_queues(priv);
>  	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
>  		       priv->rx_cfg.num_queues;
>  	priv->stats_report_len = struct_size(priv->stats_report, stats,
> @@ -622,20 +624,21 @@ static int gve_unregister_qpls(struct gve_priv *priv)
>  
>  static int gve_create_rings(struct gve_priv *priv)
>  {
> +	int num_tx_queues = gve_num_tx_queues(priv);
>  	int err;
>  	int i;
>  
> -	err = gve_adminq_create_tx_queues(priv, priv->tx_cfg.num_queues);
> +	err = gve_adminq_create_tx_queues(priv, num_tx_queues);
>  	if (err) {
>  		netif_err(priv, drv, priv->dev, "failed to create %d tx queues\n",
> -			  priv->tx_cfg.num_queues);
> +			  num_tx_queues);
>  		/* This failure will trigger a reset - no need to clean
>  		 * up
>  		 */
>  		return err;
>  	}
>  	netif_dbg(priv, drv, priv->dev, "created %d tx queues\n",
> -		  priv->tx_cfg.num_queues);
> +		  num_tx_queues);
>  
>  	err = gve_adminq_create_rx_queues(priv, priv->rx_cfg.num_queues);
>  	if (err) {
> @@ -675,7 +678,7 @@ static void add_napi_init_sync_stats(struct gve_priv *priv,
>  	int i;
>  
>  	/* Add tx napi & init sync stats*/
> -	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
> +	for (i = 0; i < gve_num_tx_queues(priv); i++) {
>  		int ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
>  
>  		u64_stats_init(&priv->tx[i].statss);
> @@ -753,9 +756,10 @@ static int gve_alloc_rings(struct gve_priv *priv)
>  
>  static int gve_destroy_rings(struct gve_priv *priv)
>  {
> +	int num_tx_queues = gve_num_tx_queues(priv);
>  	int err;
>  
> -	err = gve_adminq_destroy_tx_queues(priv, priv->tx_cfg.num_queues);
> +	err = gve_adminq_destroy_tx_queues(priv, num_tx_queues);
>  	if (err) {
>  		netif_err(priv, drv, priv->dev,
>  			  "failed to destroy tx queues\n");
> @@ -784,11 +788,12 @@ static void gve_rx_free_rings(struct gve_priv *priv)
>  
>  static void gve_free_rings(struct gve_priv *priv)
>  {
> +	int num_tx_queues = gve_num_tx_queues(priv);
>  	int ntfy_idx;
>  	int i;
>  
>  	if (priv->tx) {
> -		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
> +		for (i = 0; i < num_tx_queues; i++) {
>  			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
>  			gve_remove_napi(priv, ntfy_idx);
>  		}
> @@ -1118,7 +1123,7 @@ static void gve_turndown(struct gve_priv *priv)
>  		return;
>  
>  	/* Disable napi to prevent more work from coming in */
> -	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
> +	for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
>  		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
>  		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
>  
> @@ -1146,7 +1151,7 @@ static void gve_turnup(struct gve_priv *priv)
>  	netif_tx_start_all_queues(priv->dev);
>  
>  	/* Enable napi and unmask interrupts for all queues */
> -	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
> +	for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
>  		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
>  		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
>  
> @@ -1306,7 +1311,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
>  	be64_add_cpu(&priv->stats_report->written_count, 1);
>  	/* tx stats */
>  	if (priv->tx) {
> -		for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
> +		for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
>  			u32 last_completion = 0;
>  			u32 tx_frames = 0;
>  
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 1f55137722b0..db1c74b1d7d3 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -556,7 +556,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
>  
>  	if (len <= priv->rx_copybreak && is_only_frag)  {
>  		/* Just copy small packets */
> -		skb = gve_rx_copy(netdev, napi, page_info, len, GVE_RX_PAD);
> +		skb = gve_rx_copy(netdev, napi, page_info, len);
>  		if (skb) {
>  			u64_stats_update_begin(&rx->statss);
>  			rx->rx_copied_pkt++;
> diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
> index 630f42a3037b..e57b73eb70f6 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
> @@ -568,7 +568,7 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
>  
>  	if (eop && buf_len <= priv->rx_copybreak) {
>  		rx->ctx.skb_head = gve_rx_copy(priv->dev, napi,
> -					       &buf_state->page_info, buf_len, 0);
> +					       &buf_state->page_info, buf_len);
>  		if (unlikely(!rx->ctx.skb_head))
>  			goto error;
>  		rx->ctx.skb_tail = rx->ctx.skb_head;
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index 4888bf05fbed..0fb052ce9e0b 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -374,18 +374,18 @@ static int gve_maybe_stop_tx(struct gve_priv *priv, struct gve_tx_ring *tx,
>  }
>  
>  static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
> -				 struct sk_buff *skb, bool is_gso,
> +				 u16 csum_offset, u8 ip_summed, bool is_gso,
>  				 int l4_hdr_offset, u32 desc_cnt,
> -				 u16 hlen, u64 addr)
> +				 u16 hlen, u64 addr, u16 pkt_len)
>  {
>  	/* l4_hdr_offset and csum_offset are in units of 16-bit words */
>  	if (is_gso) {
>  		pkt_desc->pkt.type_flags = GVE_TXD_TSO | GVE_TXF_L4CSUM;
> -		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
> +		pkt_desc->pkt.l4_csum_offset = csum_offset >> 1;
>  		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
> -	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
> +	} else if (likely(ip_summed == CHECKSUM_PARTIAL)) {
>  		pkt_desc->pkt.type_flags = GVE_TXD_STD | GVE_TXF_L4CSUM;
> -		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
> +		pkt_desc->pkt.l4_csum_offset = csum_offset >> 1;
>  		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
>  	} else {
>  		pkt_desc->pkt.type_flags = GVE_TXD_STD;
> @@ -393,7 +393,7 @@ static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
>  		pkt_desc->pkt.l4_hdr_offset = 0;
>  	}
>  	pkt_desc->pkt.desc_cnt = desc_cnt;
> -	pkt_desc->pkt.len = cpu_to_be16(skb->len);
> +	pkt_desc->pkt.len = cpu_to_be16(pkt_len);
>  	pkt_desc->pkt.seg_len = cpu_to_be16(hlen);
>  	pkt_desc->pkt.seg_addr = cpu_to_be64(addr);
>  }
> @@ -412,15 +412,16 @@ static void gve_tx_fill_mtd_desc(union gve_tx_desc *mtd_desc,
>  }
>  
>  static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
> -				 struct sk_buff *skb, bool is_gso,
> +				 u16 l3_offset, u16 gso_size,
> +				 bool is_gso_v6, bool is_gso,
>  				 u16 len, u64 addr)
>  {
>  	seg_desc->seg.type_flags = GVE_TXD_SEG;
>  	if (is_gso) {
> -		if (skb_is_gso_v6(skb))
> +		if (is_gso_v6)
>  			seg_desc->seg.type_flags |= GVE_TXSF_IPV6;
> -		seg_desc->seg.l3_offset = skb_network_offset(skb) >> 1;
> -		seg_desc->seg.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
> +		seg_desc->seg.l3_offset = l3_offset >> 1;
> +		seg_desc->seg.mss = cpu_to_be16(gso_size);
>  	}
>  	seg_desc->seg.seg_len = cpu_to_be16(len);
>  	seg_desc->seg.seg_addr = cpu_to_be64(addr);
> @@ -473,9 +474,10 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
>  	payload_nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, skb->len - hlen,
>  					   &info->iov[payload_iov]);
>  
> -	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> +	gve_tx_fill_pkt_desc(pkt_desc, skb->csum_offset, skb->ip_summed,
> +			     is_gso, l4_hdr_offset,
>  			     1 + mtd_desc_nr + payload_nfrags, hlen,
> -			     info->iov[hdr_nfrags - 1].iov_offset);
> +			     info->iov[hdr_nfrags - 1].iov_offset, skb->len);
>  
>  	skb_copy_bits(skb, 0,
>  		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
> @@ -494,7 +496,9 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
>  		next_idx = (tx->req + 1 + mtd_desc_nr + i - payload_iov) & tx->mask;
>  		seg_desc = &tx->desc[next_idx];
>  
> -		gve_tx_fill_seg_desc(seg_desc, skb, is_gso,
> +		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
> +				     skb_shinfo(skb)->gso_size,
> +				     skb_is_gso_v6(skb), is_gso,
>  				     info->iov[i].iov_len,
>  				     info->iov[i].iov_offset);
>  
> @@ -552,8 +556,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
>  	if (mtd_desc_nr)
>  		num_descriptors++;
>  
> -	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> -			     num_descriptors, hlen, addr);
> +	gve_tx_fill_pkt_desc(pkt_desc, skb->csum_offset, skb->ip_summed,
> +			     is_gso, l4_hdr_offset,
> +			     num_descriptors, hlen, addr, skb->len);
>  
>  	if (mtd_desc_nr) {
>  		idx = (idx + 1) & tx->mask;
> @@ -569,7 +574,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
>  		addr += hlen;
>  		idx = (idx + 1) & tx->mask;
>  		seg_desc = &tx->desc[idx];
> -		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> +		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
> +				     skb_shinfo(skb)->gso_size,
> +				     skb_is_gso_v6(skb), is_gso, len, addr);
>  	}
>  
>  	for (i = 0; i < shinfo->nr_frags; i++) {
> @@ -587,7 +594,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
>  		dma_unmap_len_set(&tx->info[idx], len, len);
>  		dma_unmap_addr_set(&tx->info[idx], dma, addr);
>  
> -		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> +		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
> +				     skb_shinfo(skb)->gso_size,
> +				     skb_is_gso_v6(skb), is_gso, len, addr);
>  	}
>  
>  	return num_descriptors;
> diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
> index 6ba46adaaee3..26e08d753270 100644
> --- a/drivers/net/ethernet/google/gve/gve_utils.c
> +++ b/drivers/net/ethernet/google/gve/gve_utils.c
> @@ -49,10 +49,10 @@ void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
>  }
>  
>  struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
> -			    struct gve_rx_slot_page_info *page_info, u16 len,
> -			    u16 padding)
> +			    struct gve_rx_slot_page_info *page_info, u16 len)
>  {
> -	void *va = page_info->page_address + padding + page_info->page_offset;
> +	void *va = page_info->page_address + page_info->page_offset +
> +		page_info->pad;
>  	struct sk_buff *skb;
>  
>  	skb = napi_alloc_skb(napi, len);
> diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
> index 79595940b351..324fd98a6112 100644
> --- a/drivers/net/ethernet/google/gve/gve_utils.h
> +++ b/drivers/net/ethernet/google/gve/gve_utils.h
> @@ -18,8 +18,7 @@ void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx);
>  void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx);
>  
>  struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
> -			    struct gve_rx_slot_page_info *page_info, u16 len,
> -			    u16 pad);
> +			    struct gve_rx_slot_page_info *page_info, u16 len);
>  
>  /* Decrement pagecnt_bias. Set it back to INT_MAX if it reached zero. */
>  void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info);
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
