Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5E51D6AA
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 13:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391351AbiEFLeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 07:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391365AbiEFLeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 07:34:02 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2128.outbound.protection.outlook.com [40.107.95.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3393BB5
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 04:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJHhqbh9IJ8I8x7U7AkyJbAmPEv1ssvJktqC9OZtvfp1Y3A+efwd2GwELnZT/33Ez53DfwLGFWgB7A4TPYrBehn03322anuCJz6Zpbuzo3/+DJ2rw30hA54txc4ZQYTnVsIxuBSiyVBt2kXiXlcKJRE1XxuU/EvLiymUEahbBzzpbSLtJ1lPJKNX2pCkhvhE9YCoDLuMV7pGK52ymJhB1qqezhlgOnxoAKTRj09AEY4yZdbnYvr3PnDPEGP9e//wuURMGsSMHBhteR0Y6LeTyvDfg9+9T0DnvuQLVAchterx/M0DtJnAYbQ1S0O/JC0Q3egbDFUYcCJ+YRdTlYsMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CG1VmaOPQhWUOaJGj/36qnPs1ONHu5Yd49wiiYwgKF0=;
 b=B7xaoMxrBWiIEqrhFL7ZF4QXap8HlH7tcWjGK/3pr0WUSltMhC3nxK8G/+WZt9jJycOieSBEGcZ5Q+lSPzP4jiNAdhI13v0RxzoGEXbsRYsGinONcchTPe6uxI9hZV+/+Wp9QXlpiVJhkHmytmL+9yJHSK7E+qYQMxdeVLxF9J01ByTF6F/J4yQLqqPJ55MyAk2N8WYTpt4Lo+sf1tch5puJ8R1iSPAPQyG/GQYciK4qizNn0pjnFfFXfiGH6TgzCi6PdqSBRRoFh9csdqNtqvNgYKKxqLRlltQSX4xuPde3QI6zEq6ZDsKxCBT3fK/4f3rTei6vvZ1HcC6PJEcSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CG1VmaOPQhWUOaJGj/36qnPs1ONHu5Yd49wiiYwgKF0=;
 b=JLT3yY9yvOYQ4IP6Q6D6PZIhtrQWZYQ5BcDovRntxPgJLq71qnOX6fxYDklMs7Vpr18SHIWY47hEoXZN29DvT8qPUSWeA1SmIjYoXTi0+3y1FEwY14gv96sv0bbaiko2G+snpmRzRDv6YKxn5yZXHslXdH51dvLlFkgtyyGhwiI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4096.namprd13.prod.outlook.com (2603:10b6:806:73::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Fri, 6 May
 2022 11:30:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Fri, 6 May 2022
 11:30:15 +0000
Date:   Fri, 6 May 2022 20:30:03 +0900
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com,
        stephen@networkplumber.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, chris.snook@gmail.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, qiangqing.zhang@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        hkallweit1@gmail.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, woojung.huh@microchip.com,
        wintera@linux.ibm.com, roopa@nvidia.com, razor@blackwall.org,
        cai.huoqing@linux.dev, fei.qin@corigine.com,
        niklas.soderlund@corigine.com, yinjun.zhang@corigine.com,
        marcinguy@gmail.com, jesionowskigreg@gmail.com, jannh@google.com,
        hayeswang@realtek.com
Subject: Re: [PATCH net-next 3/4] net: make drivers set the TSO limit not the
 GSO limit
Message-ID: <YnUGuxF7lLlfDa2Y@corigine.com>
References: <20220506025134.794537-1-kuba@kernel.org>
 <20220506025134.794537-4-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506025134.794537-4-kuba@kernel.org>
X-ClientProxiedBy: OS3PR01CA0064.jpnprd01.prod.outlook.com
 (2603:1096:604:de::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95f2e262-1cad-48d2-de14-08da2f53caa1
X-MS-TrafficTypeDiagnostic: SA0PR13MB4096:EE_
X-Microsoft-Antispam-PRVS: <SA0PR13MB40967A6BD60E8DDD46CE2B04E8C59@SA0PR13MB4096.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRhupLiJ6yhmgc0+RtdXycI3msXLT4pnA/1LQ2urT/4LcnybEK+rS2ivHA8/Oh6BMnvYHDe/x9D8+ixNwtfdPwgtIwbgrZ2wSMDIj8/N4CIipbBJIW75aPSGM77sP9PqS/lwrtCTMB4kEoyHpxMzr2x78Z20HQbhCugJvaMsUvWjGY9evojAb+WQNSC/MPosgMnoWti6AuKx4bx/FPqCLOMbswgHd5E9K1TM7hmiuFb9EtM7yRYQUAB91/KnpDauru3oZiDFGUbg3TCIYIoR18jPJJeW2qnkMfj4azIoRY0f/2sWy+60uoYRQgc4T0g13FHT3rqNb+0x36uPs52IptJ5qO5JLY57GWE4Iodlar/Ktfo2pIKSRcrm+AzwBw7eP3Dmh3i/s/OuGk4C2fGKcmwdovwl6Y9HkEPFkqmO5p28nLDIPg4FNelHzrnHu8TGynIQTbQbpPCGTIaO1nlvJmbC7ggjLPe6MeeSEFp8asYcGwEQyGG1SIuamPziLw3dmu535G7YayxkrAG7AQxLZim3XY3R5ntJX0pWWuVK++2pj0jRtQLEIwb1DEPrqpLY3Spata5nqtneFK7n177SI5RhVheqL4+g/fipVGhQiLuok84PDjTa2MDvSkVmPua/7XFdyQNKK/OOJkRQXXLb7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(376002)(136003)(39830400003)(366004)(2616005)(7406005)(186003)(5660300002)(8936002)(7416002)(316002)(8676002)(4326008)(66476007)(66556008)(66946007)(83380400001)(86362001)(52116002)(508600001)(38100700002)(6666004)(6916009)(36756003)(2906002)(6486002)(44832011)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vgjf+993gNgNdyZ1gwPFzFDvq4Hc7utSmxUEQdWDkioK3bsT9YdxMIwialyO?=
 =?us-ascii?Q?h0sHXAuiE9lNw458IJFlK2FDXV+5Fe3GvR+AxJJutRANFdp9Xf4XcQOWPceh?=
 =?us-ascii?Q?mtTJxqF1YaOWUosO+ghxJLI2NvzLx38FJ+6gm/FeDWsrcLirW4FvABNzO6ud?=
 =?us-ascii?Q?99SdJFLvpLwLf661QqYDgd5VaCbNFVeXi4Kvs+ADV8QodSYzt/u9tjSuHJdn?=
 =?us-ascii?Q?4V/KIGHfnq0Xf2WUB21wcjYiF6JwxqVQazmQeQrMun3O+P+Rox+U3h7bLhH/?=
 =?us-ascii?Q?IWSbf8EInHE4cLWCk+gpg50n6OQsyH+lf/zHQeSBSinU0UWj5TlgWL3HK8hg?=
 =?us-ascii?Q?jsUNEJaCHLIut86qyWZmkxEskx0gJRx/+pkgOr3jd2IfHHRT2izA5ugFM/Gw?=
 =?us-ascii?Q?vehZ4uX0Ig006hjULsjgebutMIYYJsvE2l4bmN/qQtvX0YDbfN00m8fCkUId?=
 =?us-ascii?Q?FuUvNVbsVO5LWNYynrIKSKTK3sciDXcRS/5YLZ9kjlMbAGjXAhHZAVCUPLcU?=
 =?us-ascii?Q?CVaJwb4FN1Mj5m4DSN7C1TUEHBFyPjarGT/eEVkJA02ebTlLi/gwpWfRY85S?=
 =?us-ascii?Q?KpUbKpdeIl1sXqNINATAoW/+CwY5XkNK/WPg0pOuRpGVFa8vDcRIGyao7I/K?=
 =?us-ascii?Q?hxTNkYNYjyumtb6F1/Cr3SbfbRnG5rknbkUjnhjyEafBV6+LnhI7Vzwp6V8l?=
 =?us-ascii?Q?bt7FWYigW7sjBOIMfpHFZLi7MuQimm3StRE3VOBQjw0sioOlgGFeQC/eK/M9?=
 =?us-ascii?Q?2SeTbGSzIqQ4TYSwpllVbhUhWFtpwAk6dpzMvHJIjMwThm0yWV0vDQZkL0tO?=
 =?us-ascii?Q?KsDsZo7I87yLRjGBIMVE5zctFlLphEU3kp1cs7tHZdc4txK2SwPgHtGz92Nx?=
 =?us-ascii?Q?wiCTT4+a6N+7OI8dS1dmOcbqMCERUs0Po+Neo85z09Ig9ahnoeEy9sCMzKxA?=
 =?us-ascii?Q?4va2GFpkhIxVaSRN5RYikptavIXVen7eSWMrS1tyavgrLY48k/7iWakIH/D2?=
 =?us-ascii?Q?iYH/rYq/25DjYwOvL2ndZZRY347NcDPC8gNKlHaE9F1ztPUL/oAmDJIOptHl?=
 =?us-ascii?Q?FhBRaOpsBB99iTmvmHzBBsNyIcWl8Nik5wPRVYH/anin9rqYvELVcb4MgrHp?=
 =?us-ascii?Q?gcbgQ6MPUF/c7JwFGg1MU7cJpsbd6TKxi3GlX2kjZFZ35mjX4ew5JN5iDhY6?=
 =?us-ascii?Q?Imz9tzrXwGlAX0mhyrj5/B2f31S1zeddVMp/Dzc3t0kZwPF7WayZ3555DztY?=
 =?us-ascii?Q?z2LEcXGwJoiUOBAR8VOZWN3mCjBo9RsVno9QCAFQGE9K1MnhUs1aCwI2fWxN?=
 =?us-ascii?Q?QAOGM2MlkajmW8vxtdUPOel4CYdY5AyB6GMuOFEdFMKYczYLXucd++dNrAIn?=
 =?us-ascii?Q?ql5Hy+5ucbQuAjI2SUCSvdsgrc6KdNSKtEAcC1EY0CPnuRlbLiDSKpsFWV9J?=
 =?us-ascii?Q?FpFdTG2PQB+5/K1b6JYlb4nH0O2VhnmF0fSOZvgnw7+grGgM1VypWg41Omgy?=
 =?us-ascii?Q?ycUyZ8NAhAQkLnNf0cXL8MIrRT/6PJdn2KU80jXS7auwmXtxcbFJNItMwH5i?=
 =?us-ascii?Q?bzaDAX7h2nFrX6eItQsm7D8TwnnoGNZREfbODempvmWCT1DqV59Oq/yY01Fh?=
 =?us-ascii?Q?2SI4paLpNBcCQC2ZQwAAzrNCR+Pcdy2zqXA72j2lejDnwuct7mar7YpWzWZi?=
 =?us-ascii?Q?MILWcmGupVFziMfSagBhzZeJsPF2pWi2Ecn1D66HObPdyq+I/G9APWYYhqiI?=
 =?us-ascii?Q?ektcOdv5nOivrbtbvzDcwx8cdmYVv922h+adOpa/mSlsopI5S7sHZRmw5RB1?=
X-MS-Exchange-AntiSpam-MessageData-1: 2T9JeZObQwjgL19VT+c0pF44pIWSL81ziGg=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f2e262-1cad-48d2-de14-08da2f53caa1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 11:30:15.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfATsj8mJhQ+zF5uCb4pSJ/iTSB4cc7/fXfS2DFOmgH4woDAr7Zlp8dX8zZhSJ68grfINOF+BpWltw1Ckgd6L4tJ/VQnzV3P059vyuGynPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4096
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 07:51:33PM -0700, Jakub Kicinski wrote:
> Drivers should call the TSO setting helper, GSO is controllable
> by user space.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

NFP portion:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> ---
>  drivers/net/bonding/bond_main.c                      | 12 ++++++------
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c      |  2 +-
>  drivers/net/ethernet/cavium/liquidio/lio_main.c      |  2 +-
>  drivers/net/ethernet/cavium/liquidio/lio_vf_main.c   |  2 +-
>  drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
>  drivers/net/ethernet/freescale/fec_main.c            |  2 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c        |  4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  4 ++--
>  drivers/net/ethernet/marvell/mv643xx_eth.c           |  2 +-
>  drivers/net/ethernet/marvell/mvneta.c                |  2 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |  2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |  2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  2 +-
>  drivers/net/ethernet/realtek/r8169_main.c            |  8 ++++----
>  drivers/net/ethernet/sfc/ef100_nic.c                 |  9 ++++++---
>  drivers/net/ethernet/sfc/efx.c                       |  2 +-
>  drivers/net/ethernet/sfc/falcon/efx.c                |  2 +-
>  drivers/net/hyperv/rndis_filter.c                    |  2 +-
>  drivers/net/usb/aqc111.c                             |  2 +-
>  drivers/net/usb/ax88179_178a.c                       |  2 +-
>  drivers/net/usb/lan78xx.c                            |  2 +-
>  drivers/net/usb/r8152.c                              |  2 +-
>  drivers/s390/net/qeth_l2_main.c                      |  2 +-
>  drivers/s390/net/qeth_l3_main.c                      |  2 +-
>  net/bridge/br_if.c                                   | 12 ++++++------
>  net/core/dev.c                                       |  4 ++--
>  28 files changed, 49 insertions(+), 46 deletions(-)

...

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 5528d12d1f48..c60ead337d06 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -2320,7 +2320,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
>  	netdev->min_mtu = ETH_MIN_MTU;
>  	netdev->max_mtu = nn->max_mtu;
>  
> -	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
> +	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
>  
>  	netif_carrier_off(netdev);
>  
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index 790e1d5e4b4a..75b5018f2e1b 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -380,7 +380,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
>  
>  	/* Advertise but disable TSO by default. */
>  	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
> -	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
> +	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
>  
>  	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
>  	netdev->features |= NETIF_F_LLTX;
