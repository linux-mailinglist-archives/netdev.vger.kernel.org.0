Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785A165D3B0
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbjADNDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbjADNDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:03:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1837503;
        Wed,  4 Jan 2023 05:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1kIZ9zG0dbsxmHOu3QbIXpNiYHOp/Nuy+i/pkvK95YeTImF4xsDvzJeHP68SbZh/pAEqPyHeCYz3dsQII+s1tRiPEobq0LEsHRkIzgF43yCHscJ6GKGGEfVqbHbPOqA202kH5Ggkr0CKmAbQrWfk2SNrCdwBwOfelPKIHeA34mWeE7aocCLZhC48P4qMwLYl/Eud6fM/SUwfO+eDqBhRL78M4ey/R8PjEZtvOfHXgJs6ozYe8w4vuWk371uyFwbOpMs6rW5bfR8wXsOCi2LbTBXDg9rYXsCE2Nzh+sfeyVCwVOQtzdicCzXM/Y4dJv7mRPLFeUOrO0TkXoscEvNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpQ3IrRtIEy5oSRMBjDtNhfsDh+7W6DiZCb+ga13mLY=;
 b=XY9RPJ2LpmX9S86X8wOTCOcmXH5ndZjigbpyoVGD9CllA7y7DTdro7VzCmQZ3ViQL9z2+s2Pdv6mHRtIVl1ixEMJh9bvTlTrAwJx/51LBOboAVTa8QITf/TpcLJKxGFoMaNX1nEnnS965zwthYJVswLhIo3aI/YVugzTgwSGADbWeSH1/ZIns7Wz6IVjZd0VzK2vhXJHfjIn+BPLh0CyMxsAtUKOty2Mfpe1wC0gOJ5kLcJNTaeHswbqNlmKCracyQmKO80Ax2Ffc9519ihtFcBcy/vjVOuUkYrCcsGBv2D1XER6Bc3uDQfr7Ty0MLHXSIzeoU4rwDNl8kWwnmqwpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpQ3IrRtIEy5oSRMBjDtNhfsDh+7W6DiZCb+ga13mLY=;
 b=hqlvMs5/B6avhhi1yeSucDC3isvv7vT3ul0iOFanzrlW77GjFM17FaPkAD3JvrWsz5mrwdpehbJP79klVaQNolUm1gqBlY9Eo43h8HrbCFiuNB3eyTroqVnVmI4AQ2195lkyutxgWd4HX0XZw5ZY1soxPXJj0UfJNAv/5eaZVEA4ZiLK+3kK7MDUfPffPb/GQgapOAa5z2CkK2w1ZjhPB+rzJv7CLUeRcDJRs2+YyQIlStaFhqWyatHpKdnN+b/KLx87JXVPubxbQqvjkKMkho58Ph9/LN8hj1y7dPJZKil4ghLECtfmrOGOPrRR1gIwkNdyVKmqI5HcYYyQFOIgwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8414.namprd12.prod.outlook.com (2603:10b6:8:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Wed, 4 Jan 2023 13:03:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 13:03:07 +0000
Date:   Wed, 4 Jan 2023 09:03:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 4/4] RDMA/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7V5CtJmorEc4u93@nvidia.com>
References: <cover.1672819469.git.leonro@nvidia.com>
 <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: 837fb007-73a5-4bd0-b6ab-08daee540646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vsY8vZuJOjr0FRXwj7F4Eeb+0j9MCoX/WuNqIL1F9NYzxMcmq7z7HOfqvuNqBEGqtBKsfjhve+AfYHgUpFwiVCIJt5symjZZVRSRhaT/mSa8KriTRG+8esVwuZphW/saHNWfLIJilKWTsKIqZx7vjkzzQfJwIr5mv/iql1ju6vFOLUlR4a93Xl59dP/PYDx3kINAtW0JTpmFDfrvXCoISNJJW6MJvbQ5DcqLlERY1Fi4bOiN+xic3SRzyoaosMoMY9E+5WgFvyPG8Fw3zI83y02+lt8x4RhyWyefMd/ezCP5cw7k0sQQuDIRP17YsjrUxw/doYBs9bWeTHxi6AFx+/72Q5hLFt35mj81ZD7FJ079I6oiPpQrSa0KeaiSRQXrY/hSGP0TmA0r5dgPTI6p4MgBwa1t86BP/WQL7ALhSO8sxyXLE1E9lFGf9zI8b3+gOKLsuq8yfjPgMwfSN6jrvCDx9T7hKzr3MLcPioqs/PFeK9knQ/TBA5TwfLuqCvDAgB65dOJs4N/Dud/gtRmHJ+kZFTQAWLcgaUzW4XFtUjLoxEU8ADtI1d59QXQu/lRmIaBi6ri7u6bgCcKREhBO/8d1DllQZC1tj4l3mK+x7eDMfd70Cff2e++ZBbEaAwVXnNgWcSUrYsxo94Sm6Zycg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(2616005)(86362001)(36756003)(38100700002)(6916009)(54906003)(316002)(2906002)(8936002)(41300700001)(66476007)(66946007)(66556008)(8676002)(5660300002)(4326008)(26005)(478600001)(186003)(107886003)(6512007)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4uKeFSuZq43mzC0+zmIwqiDFb7VGGvWKLMs11J/ZOT3HQozEZ49WL2jCyY0z?=
 =?us-ascii?Q?H/nlsShFR6pMtsKf2L/r7BWzpi3+bfe+NfrR0esq0fzj8W1yycB27hywke6h?=
 =?us-ascii?Q?N4jq5ncES49I6KkmK6jSVbOWo7aUYdPPtX+oATKgRQ8EZVXFZgqQpjXi5VDu?=
 =?us-ascii?Q?Uf9l6iKQ00HPV4YKiE6SAi0yaLN5Yd2L6HJ6Qv9irY8XUm/jsDCcwRAxvapE?=
 =?us-ascii?Q?5Twh305lHbSwEp/SeinEWgYVSTWgnLUKb+ja5E6bVptzqxrPPTDGaChGi2xo?=
 =?us-ascii?Q?ii8SzU1tOk16QWhTXREziSfRKcMnL1psGJtslmxMHd7Ii4t/rcKTCY/aIOl5?=
 =?us-ascii?Q?KnE1UWKBoo6XYceikNOQebpUqgsBtCJL7H0ro6oEzm/QCaMUIBPa2IADozv+?=
 =?us-ascii?Q?N0EvAcNCUJWqvMIEffGRYXm/W9gziNomGmnQrMLsCJGXabLS3imnrWdSr7Xr?=
 =?us-ascii?Q?XFEhrJ+53wrSPf+dYQNAn6ia1/qsxsWgbxF6yeaMlVJ1wJduYJS2DbuEa0wH?=
 =?us-ascii?Q?YUq8ZHdTtvZg5lf3Zgk/uMtyVBsfZdkQRv8nLmKkR1A3th/7q983k5q0UjY6?=
 =?us-ascii?Q?xMh0Kl4Q+9/1ENUdaVOHnEXvjoqchba39y9pKRRIa7yKO3ezVZgyZ3oGizpN?=
 =?us-ascii?Q?2KhPtQpnb/tUOi72cvbAXm1c9yuVQiS3ov0/P6ezrRHPFkuHBBrnPIXLdB4w?=
 =?us-ascii?Q?kvThSozSMUs9ngApLyWOOrknq7+F+vF8TS0nswx11Fx315JjU9jKqk6xlHoJ?=
 =?us-ascii?Q?Qqc7H65SmEImmYcM68goiU1J1/6rTJESs7j3/rJ8B9VFMPNywVbnzzTpMDK3?=
 =?us-ascii?Q?xbfYxlDo8r8XAD9bffg90brU8008qChZb0w5JQEZacl4KADmmgGW7Y+vbQm0?=
 =?us-ascii?Q?Tip7YLYLOMRxwqR3YaCyz5TmWO3OWQUfo6hhxShsBicV6BtZY04u7gDes2sd?=
 =?us-ascii?Q?nAfgbp7HD+YHx64G9jbwoa+xZ9kl5z6qW/IQLJSzkUD2GNIfDc7utvZk7YsG?=
 =?us-ascii?Q?vc2plgMdE4ipjPFZ+Yg2NvWxfSrOPDkP7ZM4pSXRqWVCln43U5D3QWgE4i9h?=
 =?us-ascii?Q?X7vdlw0xOspnq9gunKXBjIhoUid6SDaCFQZ4dVpdfTC69/afPmPpD8pxpkDq?=
 =?us-ascii?Q?e3J4EZl8JrpyR70B+mdNw/RjKC7j00HfMVBEkMeqvpy79mucDA3qtQGmrOdo?=
 =?us-ascii?Q?x4KUZH27853++5boRssO14oke6QYDvemrEDOGuQW60Z1zcbruqf6BrMxhELO?=
 =?us-ascii?Q?EH+Jr0VipLZO239EhqrPL4Y8PvwzDoI4P53CvKaEJ+cMQS8QP/1AoaZIqeRS?=
 =?us-ascii?Q?9JAEdcVwqv8EFsmANvnzKmzVmg9JusjHww9YVmza2Fo4qfBzBLgymnMI+kAy?=
 =?us-ascii?Q?cRVTNycHm8jVPgiwwxudBy4d8DriPd7rDMbdazqWYBiRXecwti6qj/wzwcT1?=
 =?us-ascii?Q?p89Yaqjpew5pA7jCy0PHnerboaYgR6aAFiM9+GP6Vf5YzRfMd3ZVqI7Jjtv6?=
 =?us-ascii?Q?c6q5yh0+l0h0td9evIVkx+lvenJfv5aoQYiKN63Be+m0XsD545LvucRYFXVM?=
 =?us-ascii?Q?IiwImMNxiV/EtK0yWMOgPwO9BIauXrUwFiUkbIGa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837fb007-73a5-4bd0-b6ab-08daee540646
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 13:03:07.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEE4XIpt6GUIbjGU424OpQFhGwyRezvBoE9GSzhgpBczIUEcOgp3N1fqJs8io3do
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8414
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> -{
> -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> -	int err;
> +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> +	if (err)
> +		return err;
>  
> -	MLX5_SET(query_special_contexts_in, in, opcode,
> -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> -	if (!err)
> -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> -				      null_mkey);
> -	return err;
> +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> +						     out, dump_fill_mkey);
> +
> +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> +		dev->mkeys.null_mkey = cpu_to_be32(
> +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> +
> +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> +		dev->mkeys.terminate_scatter_list_mkey =
> +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> +					     terminate_scatter_list_mkey));
> +		return 0;
> +	}
> +	dev->mkeys.terminate_scatter_list_mkey =
> +		MLX5_TERMINATE_SCATTER_LIST_LKEY;

This is already stored in the core dev, why are you recalculating it
here?

Jason
