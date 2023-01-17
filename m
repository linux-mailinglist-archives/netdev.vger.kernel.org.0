Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10487670D6C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjAQX3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjAQX2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:28:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E496C5899C;
        Tue, 17 Jan 2023 13:29:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlNz73Iir02yEaspnTK6uxlHckZA3xfbWe4fQl+9rPaijsKkBoYWAajLxurUiVCj9NNDmtFDeNdl0OG98a6Bu0aG3ZEKv3MWGn2iMrQJrr1+rKNxpCN/w77HfZd6aPJkwdKOSgkC9MC5LA6bWltDxSU7mcCrenYiVcD1MLaU8kZt5r2dNlwNOxkSz3XFUGfoKTkzjU1sJ3yCm6gnF8Cyto0T79XYXpk5TnJ5FBUUA/+KNynG7GM7AmUL4ak7pqAwUidLRXbiKm2Px8z9ip+olhp1qcKe8pOUdqaxTUU9KoyKeDo3L8APO73Rr49SPwod87yXkiITUvr/PQ+O2oN3jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+d4Ua5kqsWYZDxhuG/mfvLDIqFfAShI7keasFNjA0WQ=;
 b=Pm6vkM1dvsf6QZnLivGHdnJ15HUjDYCU0mYccchK48XC+5BQ5DTE8qud8r5sIf2+PeAwaMNqwcZoPxVFLSVuLaa0xtx5sc6Mgek/azJtGhlJoDMtBssWwM5txDPeBDG6V5JWy2eezjo12NVHdbEUkqwvN+26zRtqC8zT8IdRFBwXnL68itKuhKsj3JosOawM7/FP0nen9GcUrXY38XCUj2YnrC91B9KGASTuMJEP9Upl81+PDSLDYPhcVRQhhUIuYpzIMCrx4H63p+t1zt9ULjmOzt4ceixv9TG2+rm9KtME3FBmZ+45JFpdIwytOhH+og4D/hey/DrDoSNYwO1x2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+d4Ua5kqsWYZDxhuG/mfvLDIqFfAShI7keasFNjA0WQ=;
 b=fFgWP09frz/MaRdTi/Q/L5ST+k+Eoqx2YJP7WRigDHiWZEI5B5m32LoPvZMSXTxprHYqbqifsdnmdvlq2PBVz6BLHJfZgEVzJJVM7M8GpkGIwURUxbCgVxf7Hvo+9Wdzz23fdmBXvjZFUITIpCjo/8t7BQ2y7o9so1u5M3q5MEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com (2603:10b6:a03:3e2::9)
 by DM6PR13MB3906.namprd13.prod.outlook.com (2603:10b6:5:2a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 21:29:29 +0000
Received: from SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0]) by SJ0PR13MB6037.namprd13.prod.outlook.com
 ([fe80::a17f:495a:6870:18c0%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 21:29:29 +0000
Date:   Tue, 17 Jan 2023 22:29:12 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <Y8cTKOmCBbMEZK8D@sleipner.dyn.berto.se>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b606e729c9baf36a28be246bf0bfa4d21cc097fb.1673710867.git.lorenzo@kernel.org>
X-ClientProxiedBy: FR2P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::9) To SJ0PR13MB6037.namprd13.prod.outlook.com
 (2603:10b6:a03:3e2::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR13MB6037:EE_|DM6PR13MB3906:EE_
X-MS-Office365-Filtering-Correlation-Id: afa0a3bd-e151-4006-83d3-08daf8d1ea53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2h8Sp/t+T0Zd6Klv2vekrxhs56ZIvjPEctYj5wY44s0xF27JIengwKkY6kA8kTA/+Vf8y8LMybwcMkYfRffjZxXobUWMO+xnnz9MXRFcUrrwHaITmajsGw0mfSVRvjHQ3klNkMnOjwOy+D+SAvJvAUZHO4CT7XS+luGw5HLQ85Bu0RtsdCCkaln/Nha7+K6DspUGhsEob1nidgLJtRiNAi0O3S7dikQTCbST3KFcck4f6EYYYsN0bqTz52hkdsNgexJHs9dchW5IphUuBErJSzUDk/iqGjxqcTpUaEkYwltvqfvEfl+Hp1zDeaVVop0vz7I8M4ElFCyjYJ3UFfeQ3e3DFZaED5NuaWVNBtRqvbV1kfVkwiXOyUvJNkv5msl84Tp1VgbgFGF05TF1MaWczwrzM7sfuY5Bu0IW6dPgQ055t0DG7r/VGyxBcam3zQlzFHEO1QaBN1jFwaNdkkaFxg4/gojz4JZ4YVnUIWy89bJC4Igz4Mb+tw4l00ve02ja3WWi558RUX7AfG3xh+Epk/6PN14squK1JY+IOyA8Z2ObUWsMUE117JwuEoEvm28XgAUJF88SvIvWbyV0Ai/VDtqm18ei81UIY62oW+EVrKx06xNJPn6J/QuSqjh7UxvNtPJrzkJpPoDpXKTsj6UHyNghxANmMg89YOluHB3Oud1CnmX9gSBhOO4/L+u+QbPUl81jRb4x16ZsVq8SoETQDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR13MB6037.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(136003)(346002)(366004)(376002)(396003)(451199015)(52116002)(316002)(186003)(6666004)(6512007)(6506007)(53546011)(8676002)(66946007)(9686003)(6486002)(478600001)(26005)(66476007)(66574015)(41300700001)(4326008)(6916009)(5660300002)(7406005)(2906002)(7416002)(8936002)(38350700002)(38100700002)(66556008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yW280c5XlKkMkLBFh1z+5mDPyVm/5Lgmzqx+D9ekb81OOUgNU/zzmBI0LR?=
 =?iso-8859-1?Q?4s50vs131gmccSLvOJBnrl1Y9F4aG5loizarMhfKy8qJpeU+/Y+GqK1tKk?=
 =?iso-8859-1?Q?qjENb1gbenYIIPIfJXvQy/MSOUaM96N2lVyLK1mzfEBdM/iDqGeBICK3fp?=
 =?iso-8859-1?Q?8/HKXhvw0N0WkbAoY8187gTbqwrAem9ZxlhezQED7pbLZjxeopm98VE/YO?=
 =?iso-8859-1?Q?srnh2mREjzsxFc97H5LPQ8Bx5BZ50cZFQv9x70QeZJX0eQFC4hsj5lsUj+?=
 =?iso-8859-1?Q?gv7rkYBFfhitQtWxg/0WFfUzSsO8sYAin45xEx8+l7KNNNGg6kEwE0rRH6?=
 =?iso-8859-1?Q?ppUgbbTO5Gzu/e7/lgd38cld+y/DyeoUN5rCUlUlDuLG8z3xQzW/84XWRv?=
 =?iso-8859-1?Q?Fh4lezfKoB6i256Bt1ku97rirY8nbIcNS/DyF7q1TlOOTtF05V3H7/cKgD?=
 =?iso-8859-1?Q?5tNNLgcyYLRiTAeHuUwD+M8TAD/IhUwR8WwfcAUhwIJrCyH3u4QRKzdbUf?=
 =?iso-8859-1?Q?ESpiMcirPmjnwoQk0KNI2Ri6d7s3lEqHe4bq8doEIqYzDCn0bwcza05rwY?=
 =?iso-8859-1?Q?ZAOufiSQ5gdmjwAKTwWiOjdE1FkhSWI1/rI+L32cTTwqnzXL8AR5u5ZRV2?=
 =?iso-8859-1?Q?Nm2BL03ay5PS8Q+byaxAjSdufTbo9uGelZFiZbrOIYPaNVOBpRGEz5NqLb?=
 =?iso-8859-1?Q?j0CQTrUJpiSYk2xldH4tg0cEJeHEalmH40fZ/gHpqsLcVBN8MN7zz6hHne?=
 =?iso-8859-1?Q?cW9JF+sP1r+l/Jpd8tPZjeZo1CN3EknpJt6RQKqnSe7pfMWz5KNfaAxo6N?=
 =?iso-8859-1?Q?JyVAKa9NeDtAzOvpxb2cxgNyrvLCWyaCvhoioCQcUN/tEmUxdM/KMWKQ3Y?=
 =?iso-8859-1?Q?oFWJgr0c1UKXNXHVqtLxrOcQUxTzklLkUgYwJEjBSXxxvb+bfwBJL+Tzyl?=
 =?iso-8859-1?Q?zEdHaGnOWPU36ElykGxtdCy+p8HzgBpXKkTOIabKs4+C/QuQkgwMbTLk0c?=
 =?iso-8859-1?Q?sEkWjE7NeJXQi88e99iDBafpTOxlPT225646XsBd3T/9cxQg92GqMAHWi3?=
 =?iso-8859-1?Q?5gRUqNDAMbD/uwzmA8S6PbcVm2qQdw5b1wV9GfowC9lyofl8OnOWthdMvI?=
 =?iso-8859-1?Q?kp4pJSHg97AnqEZF4JZo9/m+yQwC+CYV3usa0925qZiPyFYo+BCToc1Hmb?=
 =?iso-8859-1?Q?kniju5dXTlHG9ph0BUymaRhPqKBZwZPMSet4kkjVTHRQ+6y5hwKowBOXuV?=
 =?iso-8859-1?Q?tifUR+TQx2o0jfkzF5ZzU2jrk9tpxjSzV868ZOhnzyKgdu9kOqzlkl413R?=
 =?iso-8859-1?Q?roP5/+X4sgFPBpenEmy89dhh7SuZw2qckAOFOvwNjVcrkszUQ55PSLGJTG?=
 =?iso-8859-1?Q?Ggp2Wpu9ljEQs34mEv2Jk+GRbwVww4aam5AJzc9qSl/ZfbntvevTRUrB6/?=
 =?iso-8859-1?Q?7JPGvWrSb2n63sw5/QB2cEy3y0iPxDicbyQzNnK4Rx8PqbptyIU7HWI46s?=
 =?iso-8859-1?Q?1l3cfIGTT/oj9t/GGsZG576hH3k3ho1N0ynldGzEXZWCCWgLpkbKJsyEQw?=
 =?iso-8859-1?Q?gmQiNetMoV4MGXF75q+s0zC+VIVSYk2dTN80CdVhOUlFVC4j6V3SOlklOm?=
 =?iso-8859-1?Q?heq4z+TWDJlLGBMhqXrFANrXuwDsCEZd6i21tfCVOoXXD3QTzZ3NB9fg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa0a3bd-e151-4006-83d3-08daf8d1ea53
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR13MB6037.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 21:29:29.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98Ty6JTyOKrYmhtz5wSYHbEnbXLUbbY9R8elU/xKYKwm5wN65IwgSd/DlcuC1GjQFlpNjpaKvg8gZIEMlbcqu3gKY8+hZI8QuNdQH/nSXzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3906
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo and Marek,

Thanks for your work.

On 2023-01-14 16:54:32 +0100, Lorenzo Bianconi wrote:

[...]

> 
> Turn 'hw-offload' feature flag on for:
>  - netronome (nfp)
>  - netdevsim.

Is there a definition of the 'hw-offload' written down somewhere? From 
reading this series I take it is the ability to offload a BPF program?  
It would also be interesting to read documentation for the other flags 
added in this series.

[...]

> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c 
> b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 18fc9971f1c8..5a8ddeaff74d 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -2529,10 +2529,14 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
>  	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
>  	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
>  
> +	nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
> +				      NETDEV_XDP_ACT_HW_OFFLOAD;

If my assumption about the 'hw-offload' flag above is correct I think 
NETDEV_XDP_ACT_HW_OFFLOAD should be conditioned on that the BPF firmware 
flavor is in use.

    nn->dp.netdev->xdp_features = NETDEV_XDP_ACT_BASIC;

    if (nn->app->type->id == NFP_APP_BPF_NIC)
        nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_HW_OFFLOAD;

> +
>  	/* Finalise the netdev setup */
>  	switch (nn->dp.ops->version) {
>  	case NFP_NFD_VER_NFD3:
>  		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
> +		nn->dp.netdev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
>  		break;
>  	case NFP_NFD_VER_NFDK:
>  		netdev->netdev_ops = &nfp_nfdk_netdev_ops;

This is also a wrinkle I would like to understand. Currently NFP support 
zero-copy on NFD3, but not for offloaded BPF programs. But with the BPF 
firmware flavor running the device can still support zero-copy for 
non-offloaded programs.

Is it a problem that the driver advertises support for both 
hardware-offload _and_ zero-copy at the same time, even if they can't be 
used together but separately?

-- 
Kind Regards,
Niklas Söderlund
