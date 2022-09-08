Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C595B196B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIHJ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiIHJ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:56:24 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2064.outbound.protection.outlook.com [40.107.212.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECDDE42F7
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 02:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k70yt5qNguuJ5Pzy0h6uIiNIyaO+UdqsRXsVQtRO8Zgy2ewDc5TWKpmqw3KZe/fyC02BfSda3LbVbrmQDso5nBUVVX9klX5mMWG+1qGwggfAuKsOYhHT4m3vVwtVGsUcCkmxLl61y1daR9QrLgKozhHlAPOObmMrPVj1yfXGfzxEsVC78T8BPqZ+eNVoEK5t6T+3kgdRufk+f7LwGKmpxAXZryqt9Myvl0vNvoIVa6XAFxOKvH3t2nr9kF9SJJuCpJGAb/+hAt9NEiGlzfthvwsxy30c62PM8UarK0ZG9QbQ5yOfhJ0M/5Q/hpPUwXRKGZfPPXJHKFbniLBTRymEgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLRczpB/zn+GxoBdB7js7zY68qBY0Bnvm8vXp7tGsdM=;
 b=G00p2Zbuhhr36xiYvxnnDm1U9fN8wmIkUVPvFDaK9bZ6K/yvCTsz7Ox+ut9STTQUvQL4G6w1U93GsLc5i8gTRx7OeS32zQQOjz3LMdfozhJk2MwFHLCDp1fGbQnxavZdg5Lf8vhR9XSvTB62vIpDVzBoaywDJ2zcHbkM2EPcVgXEZpxxgMHbPCQQIUgCFuxmuSNx8/NNCerb0MjkrkAajhzgktlYwJV7yl9mFVuFDhJ3CoZNJDZblUBmfqQDWCWkH09RzWe0n4u9iPgZNxDRNx2eyFYeO3UrWlFFtzIytxufB6zlDBdyUNxs4mb8dkT86bL06XLscMShJUTz+OU5nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLRczpB/zn+GxoBdB7js7zY68qBY0Bnvm8vXp7tGsdM=;
 b=pYF2sIjT2QNzmeCZP2H4clfRiTBWIDlawRdU0cpgf7v5/T010Y4a7OoczYpwXeBynjq7tc9kybJlAFgJ9NUfOS9X46YEC5Qn54P1U1OO76u0SDPbpg2O8Q/cAGCBGecYE/wiRjZqOWP1gs++J7cP1LgG8Cepib+tx5NOoExeAWLrRy2VGQ0juK3zhAHciOPJtFO0KsE4UZtXatH9vYwcJkmoUn9WWjq6qo0DQz54RdZKnJDRpc5yjD4o6CGRQJwu9BsrB3nhSktS6xSbfqq1gA42ltjX6e0YyouB7bQtf8XPicu1rA7Di4dMh2kajKVrWeD9Sn5GfeIswkLxKYxetQ==
Received: from MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::34)
 by IA0PR12MB7628.namprd12.prod.outlook.com (2603:10b6:208:436::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 8 Sep
 2022 09:56:21 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::ee) by MW4P220CA0029.outlook.office365.com
 (2603:10b6:303:115::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Thu, 8 Sep 2022 09:56:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 09:56:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 09:56:20 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 02:56:19 -0700
Date:   Thu, 8 Sep 2022 12:56:16 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <Yxm8QFvtMcpHWzIy@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1662295929.git.leonro@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT018:EE_|IA0PR12MB7628:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb8a5be-79b5-4ad8-4bfb-08da91806202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZ4MwIW4nJRQn7jSOuNPswZ6BqN1pFRcKCkZ2KIUaQ1ayVaPTjqLyFQVkuHZChCu7fIcSWPxL7a7GXEXepalIs1K/UPJl6Esk1wk5nAHHfqHJNSpYE5wX6qFAo+YBKU9cPuoQsM6XLbBb2+5QZU63eaIBJr2nR2km95NwsQFP32B0rOr9CMXxcM1+uOogOXfEnJXYwrCDLhliHRbAx0wslavN8OGLph3on4a2917Yq6EFEntxrcCtqSrucFHbYmsaFle5VHzpwYxlAas7ZME0cK4hA79fFx6gE7O9GQizsKLmTyV3d3pTEthonxqJuojT8m3UvUTsy0AWr6RdJl0LTSOhwiaH9s70EF8o21XG3yS1s80zLdSDVMgYBNkX/cY/+NNxkQXd7WKhlGUvjh723wjamURPyU3kCc3d0LKDQo+cphiLwad1iRQVe0BhsdVeKcqV6DepTHJ37QY/a/yNfvOscJJSjR1Qya9gTSwGiFi5ZdjzV2MdMHZBaaoP7R2UTxCeotmjWyZDfho3yFdUn4Q6vKPt8Wi4up6LiO24RFgLyA8tQaCe3pOETIGtExsnYlm+ir2rulGyAT1XODK+gVFU/pYw+ydWuxexZwXQ1DsAc3JI4F2vuDLxNyzCf8gHhCFLeXtwd6j3qK1jp5bppCGE63zLnAhRd1HBtk382Nz2gdqujTW/rShUcif8ONe8t1fKIKkP3E3nZDF26v2R2ButvZKM1d7Tl64Byca9DlypSvHWMrnpM9vKnSZAdxhWtcM88qHzky6KJebOXIzBKOvQC72j1CsLHU4a9ztr6DNwOcwsYn5YqwWEi9zb+NP
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(40470700004)(46966006)(83380400001)(41300700001)(9686003)(47076005)(6666004)(426003)(33716001)(478600001)(86362001)(186003)(26005)(16526019)(336012)(36860700001)(8936002)(81166007)(316002)(5660300002)(356005)(6916009)(54906003)(2906002)(70206006)(82310400005)(40460700003)(40480700001)(4326008)(82740400003)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 09:56:21.1411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb8a5be-79b5-4ad8-4bfb-08da91806202
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7628
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 04:15:34PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v4:

<...>

>  * perf traces for crypto mode will come later.

Single core RX:
# Children      Self       Samples  Command        Shared Object       Symbol
# ........  ........  ............  .............  ..................  .......................................
#
    99.97%     0.00%             0  ksoftirqd/143  [kernel.vmlinux]    [k] ret_from_fork
            |
            ---ret_from_fork
               kthread
               smpboot_thread_fn
               |
                --99.96%--run_ksoftirqd
                          __do_softirq
                          |
                           --99.86%--net_rx_action
                                     |
                                     |--61.49%--mlx5e_napi_poll
                                     |          |
                                     |          |--58.43%--mlx5e_poll_rx_cq
                                     |          |          |
                                     |          |           --57.27%--mlx5e_handle_rx_cqe
                                     |          |                     |
                                     |          |                     |--33.05%--napi_gro_receive
                                     |          |                     |          |
                                     |          |                     |           --32.42%--dev_gro_receive
                                     |          |                     |                     |
                                     |          |                     |                      --29.64%--inet_gro_receive
                                     |          |                     |                                |
                                     |          |                     |                                 --27.70%--esp4_gro_receive
                                     |          |                     |                                           |
                                     |          |                     |                                            --25.80%--xfrm_input
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--6.86%--xfrm4_transport_finish
                                     |          |                     |                                                      |          |
                                     |          |                     |                                                      |          |--4.19%--__memmove
                                     |          |                     |                                                      |          |
                                     |          |                     |                                                      |           --1.27%--ip_send_check
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--6.02%--esp_input_done2
                                     |          |                     |                                                      |          |
                                     |          |                     |                                                      |           --3.26%--skb_copy_bits
                                     |          |                     |                                                      |                     |
                                     |          |                     |                                                      |                      --2.50%--memcpy_erms
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--2.19%--_raw_spin_lock
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--1.22%--xfrm_rcv_cb
                                     |          |                     |                                                      |          |
                                     |          |                     |                                                      |           --0.68%--xfrm4_rcv_cb
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--0.97%--xfrm_inner_mode_input.isra.35
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--0.97%--gro_cells_receive
                                     |          |                     |                                                      |
                                     |          |                     |                                                      |--0.69%--esp_input_tail
                                     |          |                     |                                                      |
                                     |          |                     |                                                       --0.66%--xfrm_parse_spi
                                     |          |                     |
                                     |          |                     |--11.91%--mlx5e_skb_from_cqe_linear
                                     |          |                     |          |
                                     |          |                     |           --5.63%--build_skb
                                     |          |                     |                     |
                                     |          |                     |                      --3.82%--__build_skb
                                     |          |                     |                                |
                                     |          |                     |                                 --1.97%--kmem_cache_alloc
                                     |          |                     |
                                     |          |                      --9.97%--mlx5e_build_rx_skb
                                     |          |                                |
                                     |          |                                 --7.23%--mlx5e_ipsec_offload_handle_rx_skb
                                     |          |                                           |
                                     |          |                                           |--3.60%--secpath_set
                                     |          |                                           |          |
                                     |          |                                           |           --3.41%--skb_ext_add
                                     |          |                                           |                     |
                                     |          |                                           |                      --2.69%--__skb_ext_alloc
                                     |          |                                           |                                |
                                     |          |                                           |                                 --2.58%--kmem_cache_alloc
                                     |          |                                           |                                           |
                                     |          |                                           |                                            --0.60%--__slab_alloc
                                     |          |                                           |                                                      |
                                     |          |                                           |                                                       --0.56%--___slab_alloc
                                     |          |                                           |
                                     |          |                                            --2.52%--mlx5e_ipsec_sadb_rx_lookup
                                     |          |
                                     |           --2.78%--mlx5e_post_rx_wqes
				   
I have TX traces too and can add if RX are not sufficient. 

Thanks
