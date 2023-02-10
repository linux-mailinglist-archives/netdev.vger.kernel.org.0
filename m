Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E22691FBC
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBJN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjBJN0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:26:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F863581;
        Fri, 10 Feb 2023 05:26:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0WveJUVd3y3LwW/xZxDzyAub40VGniFtKVd6dBpoUTlMU9V2HEB8znTCP1bOJSB+Lz5u44/JdZT1KR6Rt0fO60KVxmeKE4nW+IK8azeCRq1XZi2AghHX4Xjm/narqxP8ILUJCoQVZTHBgCnz00Nmpr+8I8/LwIGuca9h7L/pKEQMnjqdBQTakbEcr7UHCocjMikw/LPCq8BTInsu/7zyMnGLwaTOTRaKtv8DDOaPVQ70pKF0Kc4Fz3ibkvytYbelqOjHMZTcoxPPyG50ntNoEXkmp334P1Q22T5Fe6mwjR6j/GMyt0a3ohoMcpiqLqFQtUZHMJCvSGvyTPyE5xCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yol6avHkN0D2jgDGl2vGw+I1XiTAqC8/bx1BNkT+BX8=;
 b=nQr27sc/lsAwQyd6PfUcYK1t0Zh56YnwpLcEw5H7axetFSBRonbKuRwuE/Um6O0oGZsfTiFycp1UcZPY3gOpdw6okhbHaRaFzBE4Y3DW0prEixlWxelw8+h0C1hxzRTGS6i6VLjTHjN0/LynAjchTIYHnAe67LQS2HuUbU8PHaUDwSFZsxuxwSiNkERTqbY1X/U8C28IF29QtTnh/zOU3fAyx+OguvBpaDUwTbFojCmJKTxBKUs+zpfgJW+2Q2FJ9FTterNZ8FulTrlaKrLu/SCVlPUwfVSWkx/30u/D5rTKx5jYfz50iaYWVK+228CnMKVkf3WY5Z3SrMg/lN/8ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yol6avHkN0D2jgDGl2vGw+I1XiTAqC8/bx1BNkT+BX8=;
 b=V2kRMTOuHfvHrrvUT3CbiGVJz2L1vGRN0AX3N07rmBTfW+L4UWF2Pem2iSABcq2oWWqOPQaF+7TYlj0OVQKn5DkYAMlEaArBXILCb0OQJFdst06IEmdeiCPRhwTPFbGb8mgJFLnrS9sqqnqpENkp3bh/kFODEBBCO8Fvxtdc1xk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5594.namprd13.prod.outlook.com (2603:10b6:510:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:26:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 13:26:01 +0000
Date:   Fri, 10 Feb 2023 14:25:54 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        saeedm@nvidia.com, richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com,
        naveenm@marvell.com, bpf@vger.kernel.org,
        hariprasad.netdev@gmail.com
Subject: Re: [net-next Patch V4 1/4] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <Y+ZF4k8+CidOG75r@corigine.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-2-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111051.13654-2-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR04CA0095.eurprd04.prod.outlook.com
 (2603:10a6:208:be::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5c85bb-23e1-43ca-2a0f-08db0b6a5a69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+gpYlzvUhtD851XuMd3OMjG2BXu+spKkDB0VnA/heSAJWQxRj6DIzru4IsHjlaJ7W3ulBDhtYTdHgQOHjpPEud+M4gVM1zpu1CBVSoxnScMJjyWOaUO7Om/fZ4XcrsMOv19OrLior8NvteRQpQv+7K08/wwfcpKQxE8F+846XBa66GD7Drz/MJQY74VguB19DnduhTaiVYpA5RuR05EeYy/xRBKH1zm+xqsfclj6rc6Hkf4dE7RjFe8dzPBHTByzOgQeWpd1iW6+vtUqthlKAudC7ZnFTJFrvqMZbgHQt7u9TW1ubUC/qlpJQJ0zHVQMz/wDroPIbANh0FICTaWV723Yvw7EWoRJ4RSTHha0I2mW5Xkh65xtfntSyeo/DidH0ZAyiNbFeQfGQ4x7YdTg9skNSXyMzVsPRwTsjFQXG3MEyCIOUC6EluNkRDKYFCbKhZ2baAaTaXGrWSDLbfbQT5T1+nhf5TDC3urdsEz9K8FOiSflwbEELTuH376IlfwOvb+Uazj1AJuJcfcKh6jV1wCmHN0ygxZ5ODxo5bm0SdT80zMhXCKBzNlLb8ALty6uZM+jlsxpqVIMEnbKyspTearQo0+5yldEaWNy2Ex7jJK8J5sp/J84c8ob8xD2Wwyu6qSukiw43MhcqL4PoX2RcdQPwn9R//+NXY38E+yDRcZLT04Ab/v9HtEeOqAmOdD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39840400004)(451199018)(36756003)(66476007)(6506007)(186003)(6512007)(86362001)(6486002)(478600001)(2616005)(41300700001)(83380400001)(2906002)(5660300002)(6916009)(4326008)(8936002)(44832011)(8676002)(66946007)(7416002)(316002)(38100700002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUkhd0lKzruM9MZOTRjXqmTtN59L8oM5yD5tVjJ09erYPmmWnySJYxBundog?=
 =?us-ascii?Q?/jByiXpUMLG/noOHP2obyeXf1SjzsaJ/9jd9m77LWMA8Mbl8/Wb/bc27O5fx?=
 =?us-ascii?Q?nhMtDnlJYL1NESI+fUUSGxKIWmkLK1mEOgbPBa12y2LPM0oRrVWzodfGJPL+?=
 =?us-ascii?Q?jthNV011kbv/2OZvfTyL9f+dF9X5yUFkXDnex0s4YtAWrewyC/ulHx6Mb8Fq?=
 =?us-ascii?Q?mOsYm6Qi8r8Nb4fMUVd4j8DTlhKv6D9fMPVrsgpzXFoKzdm2AGCnE1JkfLle?=
 =?us-ascii?Q?rqqt8b3atFDQgqELjpR7E2a/dMumKfh9s/NJWw/xoMDDjfutGgJwNLIjHRDD?=
 =?us-ascii?Q?kiCppe0osdT52tWRwH5/Q8VnFWvZ/oTQnlewgaYVY9hFdqU+oIJS/ZhCHkrT?=
 =?us-ascii?Q?bLamRjIn4SrfOqMl/Qwl185bSQNOpH2+Yqxsdv1J/t/ELvChmLQtq5fLHfRS?=
 =?us-ascii?Q?fo/HxTY0FX7fzx0n7p8aqD01xvMQhqGVtvAp1kxPlJM6lm2Bdzhd7NSwZo1V?=
 =?us-ascii?Q?y/7RnF3lwdDDGMYplt92mmUJkAujhYxBK9Y8Y1L0t9vGzIrlsV4f6ZPVhpBq?=
 =?us-ascii?Q?UV7QvCjvfQrWs9jeaWtFjiPIxQtym6dfvHVc80uBKCvip+1s9F7hS4griQ1j?=
 =?us-ascii?Q?e0E9B5lFXMCvdgN2A6MxdSdakjdvuRvrigojs8Rjy4mPG0Rvvregnt2Y1fBa?=
 =?us-ascii?Q?5YMdXmWuWon9f2b5XCNqglFD4mH7P8XujWDEzybLoORsFh82vAOuYyW46GmY?=
 =?us-ascii?Q?twSP/QiQpmQkpfZ3UXbbhtQjS67XdKuIxr4tl9+74EV6csjsmFE+InvnFvvy?=
 =?us-ascii?Q?ehExT5WSC+N3k0Osa4iJqjvItVKvrZavM0CylsaFyMcoZzG9mU56zsQma19x?=
 =?us-ascii?Q?grNI3ucolrXoP0SUD3cSe6rpX4oaiIexkoh8AIUJJrHnD8V1cqYbMGD5vqrr?=
 =?us-ascii?Q?SP+6R+6ZrVAp8C0xrCnifAYOsaLgjIhcB/uxeK6RCOsjmNAxq5J9ayfnqOuA?=
 =?us-ascii?Q?Ml9XbTkCTVXPGVQrKtxG1a0+xvZgss80HFKjI4zohEFEhQ3w/4LZVHsp7n1c?=
 =?us-ascii?Q?uCFEq8HJsOf0iI0UeF4XUzjawCdgjAIe0SXcHh8awcHz6+w05qoxf/DjzaYo?=
 =?us-ascii?Q?dvlfqFLwnCcT4WSn0AyyZ16b5o5LX+W+hOcPQdL9jaTLsZ+ZEaKaA+zDcgEL?=
 =?us-ascii?Q?aJnEpL4arOrMh7ERica/5oId63KQPOpqftJgg9qh8SMpbvmHRqd/ss3PGkrn?=
 =?us-ascii?Q?mwlYgOfmdz81kX8A+jz0s2hIg7CXry55wwL0ee8kum5Hm9iOFnjdgAHseTZa?=
 =?us-ascii?Q?oSjzz+riXNFGjKZY8vQoaWFiWvsqTEJkUGOVVGwZBcBBoHk07TsK00S0cBYb?=
 =?us-ascii?Q?C3+FZaHw4jcT8BE5l4RLh2DcKo0tpvO0tLowl+ST8iWTF0cSR1vNZR/SNDyo?=
 =?us-ascii?Q?KTr1/lDraW604I8eTEwxRZ9XJRIdOSgFSgd1Mtf8ukkZhCqdUXROccEtoCIU?=
 =?us-ascii?Q?pCJ7hkRYofwfkUeb1iH4Dxvt+b95vzJBk8hboLwsLJYGfEW+8Dx33CA2t5Xz?=
 =?us-ascii?Q?dsL2+vsKcXXXH1BeTrh5FKLEVJdf/8X9m+RbzFTcH+mby+Vld4M83q43EZZG?=
 =?us-ascii?Q?OZDg+/3Le4ekt6NpQe0ewPd7GyJU6ISl2nxUmzqDXuLLrvGfi91vE/KTkhvc?=
 =?us-ascii?Q?GU7R8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5c85bb-23e1-43ca-2a0f-08db0b6a5a69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:26:01.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMQUR7YCfNgH24mGZnWh6ANd7Rsm4mplFNZfhTqwCafZTOrdByE4RwSvELofcepetla9LtAs3+kieWktaQx0r+yQmCyCw/lmmtXmoI7zx8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5594
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 04:40:48PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
> of supporting the prio parameter when htb offload is used. Report error
> if prio parameter is set to a non-default value.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 7 ++++++-
>  include/net/pkt_cls.h                            | 1 +
>  net/sched/sch_htb.c                              | 7 +++----
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> index 2842195ee548..b683dc787827 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> @@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb_
>  	if (!htb && htb_qopt->command != TC_HTB_CREATE)
>  		return -EINVAL;
>  
> +	if (htb_qopt->prio) {
> +		NL_SET_ERR_MSG_MOD(htb_qopt->extack,
> +				   "prio parameter is not supported by device with HTB offload enabled.");
> +		return -EINVAL;

I think returning -EOPNOTSUPP would be more appropriate here.

> +	}
> +
>  	switch (htb_qopt->command) {
>  	case TC_HTB_CREATE:
>  		if (!mlx5_qos_is_supported(priv->mdev)) {
> @@ -515,4 +521,3 @@ int mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32 *hw_i
>  	*hw_id = rl->leaves_id[tc];
>  	return 0;
>  }
> -

nit: This is a good cleanup. But not strictly related to this patch.

...
