Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBBE5B8F8F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiINUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiINUKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:10:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE6F3AE69;
        Wed, 14 Sep 2022 13:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHHT28Y6y2ZAKEBOob8Q7onIE8g2hc+VaS8y1xCSl1Ik5JwQ8jX/g234Fm4IBiwhbNzEakhKBXadeHYvl9smjAsCyGGYCjWdj7OIFQ0OyucbzxzdbMpaAAADNvkBzmtF92YJrjno/WtDdfUuWzsL+iMwtH2M4jiL2L8I8PMe4M/Wx2mNz1RSOIkb0j9se5PnCTBtv+VnzT4d0t7cAm7iSf2P9Z5r/UuuH3HcBzUmgrxrC0C7hzMzcClprejkeoccjP2bW2rsm8iiPTX2zTazdAURqnMB9deH5oEa+xsbxWwPzu7amgDTTu3WmaQ7AOFrsPVq3Z6IIa5n0Vkba2IcaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dODVOqkdP9K+/P7foOD4MWO6h/Dc7agRabYXE+/Qn1s=;
 b=L1CxsvUy6If2stFnomwQPeisFyHqMjGP37Z2hM8NF5TzGVqZSjksByaGVsQRrVRvaySZs0dnNxiSi77l9ZbNpfG+vmsi2hngUQUXOpM91S+/u3lqnSCI1+wdJm3ob6zz7zvM83QowIwL656Ggh428gKzSjx1oRaDsdULqZeQipZXgLtEXGZCAn2VvQT+5MtvXj1l9STHxxlXhs4V48gY9LtePbNDdJaB1srecXyZ48pwM+52FBlopeQ+c0140oM/MG0sdwPOBpg9MiJ0y4N6wKKchwl60mM+KhkhJx51UOtwwmBUdteeZJBFwcD4kLyz4reXjeyAI2rkPmBwHwcUvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dODVOqkdP9K+/P7foOD4MWO6h/Dc7agRabYXE+/Qn1s=;
 b=A84RLWxNstXeOyS71V1+9KEDrzysA/FVL86PxaJ2vaY3/0CA9Jn830m6qmx178kFsbps0Wa33XuWNEzSVw1b9o0T2brYsHJSpuYacFZLL/KFR4tdC6YOtt+Iyy56NSukGUrqgEQc2B6tFACi7s0aOPRldQcCmFfpUE1Z6lVwxb0FDCyrzwN+2CW+q//TA5CKEauqAPIncfK7+Tw+6DFy7Ct+YrvAXe9Q6Hfit5dkOXztHstBuvnl/DEj+Eoj6afknTHIMpPLqXJe02E6WCMY0xmjjtkdGZrz0NDPoSBxrkfAPihG/bqUKf6z+81YK223NVXAwg0dM1lQefr+7tVRhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SJ0PR12MB7065.namprd12.prod.outlook.com (2603:10b6:a03:4ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Wed, 14 Sep
 2022 20:10:32 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 20:10:32 +0000
Date:   Wed, 14 Sep 2022 21:10:28 +0100
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        liorna@nvidia.com, raeds@nvidia.com, davem@davemloft.net
Subject: Re: [PATCH -next v2 1/2] net/mlx5e: add missing error code in error
 path
Message-ID: <20220914201028.5e7uhpmiolls2aw4@sx1>
References: <20220914140100.3795545-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220914140100.3795545-1-yangyingliang@huawei.com>
X-ClientProxiedBy: BY5PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::14) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|SJ0PR12MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: c465cece-49c2-4881-9195-08da968d2d76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ffsi+j6lESMfwEap4b65LxbX573OFFeGwQHq+MOFnGihY4O/AN3vAR/+x0ZGmcl5c5BiduQtOsbReU+a+RSEb7JB8Q2kzQbARcvtlHTsFyVsYhhix1olFxOwcsGhP5hqgniYP97SRGsc+/LNZ1QtuMYyB4N4f8UtDQJ88stBfkBZfR6iBrzmT9rgVPzQesThiipHY6HLIU5ZqvlCttMSly2+sB1RWJrt6z7idvuvDrOUn+XfpWcSrfI/+HTG4a4UdYsyKzDrp4OT/mnEnvm6lkY0fZxWXaI2w1NoK15TH+WdpZl5VAiUW9FdtrmObrQOfRjU/B/rq5hyBMwLVQpHaV6ixpe9U5SgfRqDm/h+PbPH4GxlLXCJk2R3itILLu7c+J6eITYr/iA1oYg8H+LzgWie2NE0LeJ0KRPZ+5mxXY9vFPDXbefRrdaEo5rtv3/Ld4KHTDgoIlyTIiR9gwrA2pzPFmMoUa5OqXzbwfF26O/1nKzrj6POH5j2TgctJ0xdWTTGjC5HVyksxXTMcPihxFb6t6/R5JKvI8QpbIw/zJigYQQe/lxKdMnbn3gx/MTihEdEjYbToLB/GPbHsB6MuLX9U9L5o5uiQLfTuJGnvQx3woHlq9sVxrhf5m7vz+pGeCMq4gGiA/VvJbNlDAWFNVBV+sla3xAyv3yX/AMZyJd11KtlkoS4twbdEWOqbXWvWyBBGIq7tAsQPau0Zxgag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(9686003)(8676002)(8936002)(26005)(478600001)(41300700001)(186003)(6486002)(66476007)(66946007)(6666004)(86362001)(1076003)(5660300002)(38100700002)(6512007)(6506007)(33716001)(2906002)(4744005)(66556008)(4326008)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?laPzeTr26OzfxyRhMOUI9fdrHDh4OHAcLRPYmVGgiqPjIOB2fzDnWrblgtOJ?=
 =?us-ascii?Q?+WJTPxD0RaHJGAiFb7CL3nrYC3a7PAfmH3ETR1o8jhyq9dn66atkmRmH+QVH?=
 =?us-ascii?Q?1h3tC60+VzBPfwc7m91o4Nd11dV3tQIUcitl1bZDnDcV20UJ/9a+fr/abBHm?=
 =?us-ascii?Q?0PY31XafhHJfFKgbfjp2sXNRHwUUS/GV7IbQ95m/PmPzP1z16Egm6dV6vHoL?=
 =?us-ascii?Q?fvtCgWWv0jJwGp6MiTlYXoaVy8YhEJ3t/Gfdy7EPEcnVAmXsghCRTrYxpi+j?=
 =?us-ascii?Q?/0oouCuVC5SZ5tZ2cnoBTZQM3ZBABrJqQZXgyi8oiegJ9o7GtjacGERWLhk7?=
 =?us-ascii?Q?CwVKc2rdIEtNXuSzI5FrzOe9ZyjH1L4ZkVtl1lfEyVxbA0ikVFnR5ykru2U/?=
 =?us-ascii?Q?1FQJbbjRo0Lj3gZfuCIaVsgDcRhsuHPo/k2TqS9SqUqtAF92rJGVrvCixk2q?=
 =?us-ascii?Q?Rtm6xnAclqDpRdQzUoaZBn4WWmQEK33dAs/F45IaA9OeRBqQygGVmXBgzJ3h?=
 =?us-ascii?Q?VpH806AAQC/boqL/+FN7llv7prm80QtHO6ka9pAIQOht4Hm1kFGWvLQxgXW+?=
 =?us-ascii?Q?9cJh2AsAWdtA7hpE6P3cLfskJY5nYrUi1tm3YzxA27Ln6bRPmrd38ubs4vWQ?=
 =?us-ascii?Q?CS8eNz7PFwlGH1BJxArX0ZtWHMJlfRJaxIZWN8ZWBjv5M6rD6yZpYo1M6ykK?=
 =?us-ascii?Q?sTCT9AuV+jpyhySrHBrD4f9tGlX7itzVFyGq463HiV2YJ0ivG24ScJmJudeC?=
 =?us-ascii?Q?KdFTN4BTQYkUu1hJyY6Kk4nI7S3brJimI4FtDNJ5CoOV4Aw13Q61yf1ihOMb?=
 =?us-ascii?Q?/yJs/Du1Wp+o3+mWqd3dfjilYx2+flGFsM7C6kSdc3/2nqKsG/afZnJ5IiJY?=
 =?us-ascii?Q?HMuKR2ezZqcj0Ija3ZhJkEPgIcvjR503oRAYXzELJO9wKKTE5PYA2+DFD2H7?=
 =?us-ascii?Q?lVmYwKGBEIUATGM6uOe/O+Fe57KTkBBaqQFhdnwGFG60V8racyq84vhViCap?=
 =?us-ascii?Q?/EA07PdefAWn08bZ5C+ps5w29QRP7GoJIZ9khs/FSoiZBb1ddMODkDABzTbK?=
 =?us-ascii?Q?tu2tMkyK45/+wbQelH9eYhn1kWfXPs6zgRBN9vvo6e2trURVTLdPWgj6zV+Y?=
 =?us-ascii?Q?u0bdT8SLpmyUvefjKx76V0yLD7HmRU/mjYqoFVd+ngSjqSuPzUoxt5pcu8B3?=
 =?us-ascii?Q?WMNrbM+iMrraGkqgfkXF6sv+a5ZwO7vVsWwvg0WVcURnLIkCX4etfvetplrb?=
 =?us-ascii?Q?PqwGfCWvzE+BKlBLXQVBldwk8KrhiGHAYD9dF/VNuM6xwXXwEIgsodfTzvCs?=
 =?us-ascii?Q?Rg7iYMIUl9xlzNh6soLwF1vTdZQuuTGVW0rpgbTucU70OkcIyxQx0ODo6Urd?=
 =?us-ascii?Q?VxDry2ny7xHjBukUbpUmQdso0mguPotAMEN9yIlyHQghr3/AOW05tf49jVlq?=
 =?us-ascii?Q?Fz/ZmTbWQikqGz0RTprnUDMve0u1JZeGboqq5uefedKsuMs6o7o83Fz99DGh?=
 =?us-ascii?Q?QmTIcFc5Fz6xAzNTvtE5PnxTrmZsjrEnE4E8WBo8jKMBfYOF9qbtNYBFsbzF?=
 =?us-ascii?Q?loZtkO/eBbGaDULS5qi06+aE1iXK8dBJxMVjC4X9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c465cece-49c2-4881-9195-08da968d2d76
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 20:10:32.5052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5yS/TeYN/Mg9Bm5eqXF6omy+jB/oqQz4BF5NVYd473XzUSMDmhgykyTeFQllojt3EcOytRTgu5Dv5J/obaSbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7065
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Sep 22:00, Yang Yingliang wrote:
>Add missing error code when mlx5e_macsec_fs_add_rule() or
>mlx5e_macsec_fs_init() fails. mlx5e_macsec_fs_init() don't
>return ERR_PTR(), so replace IS_ERR_OR_NULL() check with
>NULL pointer check.
>
>Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>---
>v2:
>  Replace IS_ERR_OR_NULL() check with NULL pointer check.
>---

Acked-by: Saeed Mahameed <saeedm@nvidia.com>

netdev maintainers please apply directly.

Thanks.

