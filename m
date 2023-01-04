Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2D65D3F2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbjADNPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239408AbjADNOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:14:49 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3073AA83;
        Wed,  4 Jan 2023 05:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlDqK5DUnU2kVjTdyS8Noxq7OgselnDT3JvkkiRJnx+RWbujYYaToojhUBUkBTDdmZXOZyczTbDCAvKzpUBFl+kWjyi4NRYcT2aXZlcoOQ8aOAwOsflWrnSb8f34kScFqZ3pKFgrRAczujskdlUvfDTctt/YjvsjE5zSDRHH8Kka9cdNYDp0l5DL+QMDmkoiVUa0zJY8BeGy9gheomJ6no7ApT99h++UH9n4QS3Sv/NZ2jbZVfqi362dcMgwnqLuwJ/q/xZQCkwWQLPMRV+C9mWln2THxMHScvIH9Cr+5X0xgLCc8ZiDeaDQQ1F+VYVFjZU7xEKp+d1+zxetp93lvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0RqVTtJ1gOVj4YzVB6k1nl2pppz4NsZ5z5BmY4+ooQ=;
 b=DvHGkhFQXIz/TuduFgg8RXlkkX9hK1m7LyOr3sxyLiK68I/M0GVTmuqhJklpYQulJBUm+AG/FOdY3hO7kHHQWCrnDhQlK2ZugCknYTpDqM+5BNP+ILMmAakwK2jkYgCRDwAiZx02nsFVtyQoky0i+XrIkpup2ak5WzCd9Lkmxw9hnQnWGPj8NhfP/o8biKbfDS6WJsQxoHBnY+L1i1sD/RSoIaZsyMkuQKYHjI3anskaJ8ar77NXf87F7zcYG7CHSbbkiY7RKF2TeBNuM5bhALwxfXHCU3nNTtmj6fbmkn4XS1C0qHNAAtmdvZUf1o/cxRcEdX1thjnfj7JjL1cJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0RqVTtJ1gOVj4YzVB6k1nl2pppz4NsZ5z5BmY4+ooQ=;
 b=MBlqEm10JFMKAKFRWmOgOxpGGkWPyGSBfJNj0EE58/m02KXSjAiPl+0mEAu059rxkK9l1CdW5BH4SroeLHi4hXImSOy+5MseV+DnhAckkGaMt89JY6JttMP1QLmmhuntP5RxnhRXbenGU9BdvMbwgeO7SgjkMqvyJTeIWNox0QhwviMyPMeldr4CiwyUShBAotYzdjqml5BzBt2ql9Xgc0Z6TIcawZs5OPOvCVzRz1RSjljByroF1EzlCF8LIP1gMso18cq40L86JUMw0GKO20NiBRezoDH/gSDB7SIfCgBr6bz0C1nH65xUrosatHjX+BItdF+Fef/6mzYbJ1pPjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4536.namprd12.prod.outlook.com (2603:10b6:208:263::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 13:13:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 13:13:11 +0000
Date:   Wed, 4 Jan 2023 09:13:10 -0400
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
Message-ID: <Y7V7Zmnldy81lRIO@nvidia.com>
References: <cover.1672819469.git.leonro@nvidia.com>
 <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
 <Y7V5CtJmorEc4u93@nvidia.com>
 <Y7V6otdhR5vJ1nPy@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7V6otdhR5vJ1nPy@unreal>
X-ClientProxiedBy: BL0PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:207:3d::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 85ec2073-7fb2-48d1-59b7-08daee556dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZuBW24uQUaPiZ0eH2UuueXFNUFRPXAAPdMzko/WT8Eeuh+/t8bh0Ka49iCPV4y9oLr/HwH05RQGyB/XwirHHQLn3XI+qLMFKc9Ue5i59MRZoIjUnUX1f25Nk3nHfXvnMWDW/+yE+Wgu5AYtUzRq0ZoWM5YsbawKHiqPlYMKqLQFFeheTQmvw6aWTg1YG4SFnkr3RrEYRl7SxStmvNnLQR2vVwx5S1a05MyjLaauZ0yvioJQCPQhlg3mVa7XT3fHhQycb5sAinsgZEgIN+5/2Du7gnbA4Uf4MGa5vEKOJfAxWpbjmTWbrf8Cff1VpKW5mQuGC1h67RHlCtb9hCGMQNyoxuCeOpS9QXEFszBQCl+hJlM3Aah+Nbau+Op0pQOlP6bDFFzjbDOCogtWsOTcvhtf7VJUr2K4yLDI1bqBMVLsj9xJeSeAtercElS6WovrRCfxMCEcK9Vo9i+p26RONtXHsee/ThujmSLBar8MpQjTpj9RZhU/N/mWt0FP4GK7uP1cJRWI4iaHYYnB+fQOXtzTEQv+dOBff/QCZfp33pDc+fVTllNd4BCS8Ztjczwj91fD9RZNr9H8iFmw0JRRj6OgLJkZgY5fjC08VEkSon0wmc70uFxMxtQYoY4UkoVW5vCR8juEmOJIhAJtQndhyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(8676002)(4326008)(5660300002)(66556008)(107886003)(66946007)(66476007)(316002)(41300700001)(8936002)(6506007)(54906003)(6916009)(2906002)(478600001)(6486002)(38100700002)(2616005)(26005)(186003)(6512007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TpQ3VfAUXSG6VcX/027j6Ox1ujSaHEulveHLfgvkWcgIWGh+eWGPB2E8513p?=
 =?us-ascii?Q?FAyKQiorxQvyRPvrKpC1yN/AtUWjsfSijExN0iGYYZ3lhlZ/qXiwjy7H1Shv?=
 =?us-ascii?Q?WLlwsIlGO3TUdIyFcttV0sUPH2lDTq7YrDYp84MCPU/GFFckg4J16lPH7/oP?=
 =?us-ascii?Q?GAe8WIQ3s4Pk/3w3vaugifSzK6nVU8OJH4qQavHi0NYISllLXFt5Hr5vec7B?=
 =?us-ascii?Q?ECakoQIvxYxbmV6RTOvKWqXVhx5jiBNIOJUgHB0fsH3LTI9hrRh7q6xgwtB2?=
 =?us-ascii?Q?UqXgTe333BMOiFOmlUlkpuSj41tMAcVB0cXhnBVcsDDlR61aBDRwK7/9xjMP?=
 =?us-ascii?Q?tYN6ZL+Y7Il0sGQoSEkUzcjaSsTcr+B3X6orMu+9+4lQFY3ClcALVTGdfLef?=
 =?us-ascii?Q?A5PF569XNCkQTh2bi8yqxlM8pDxbQ5Ns/JF24/xhSDuHRGsLbmHE3Ucy19m0?=
 =?us-ascii?Q?/Zz7mhz3wlsMnERnxR/MLaq62SbNk4i8w8KTinnRrZ3sajvreKYFXsXLVMdD?=
 =?us-ascii?Q?MgmcgXox9k0l2hJ341u4sErHdQkrJrTZV1mny101jrl9wJckbDOM4oXlQHnJ?=
 =?us-ascii?Q?qlOSuMuOK+Qefi8j6qmjHJfdDMd0uBoBzp84mmscqWGIwgP8/Cu5TzcIN4a1?=
 =?us-ascii?Q?KNZhal+qZYCHeGZMVA2fSC/+G7UPwiLO2oq7lmlLAvnMgy09D+JZ6JyvPE1h?=
 =?us-ascii?Q?FZbi8Lo6VxJcc6ZFmwja3gK353P5ihsHJGM6EhtNlkQGWHbIyJA5hk9MuE/v?=
 =?us-ascii?Q?ohkbY6M9NY+8tf6CLxxDxVDUNrsSkkhZG2gpG588vuRD4GYWA4r0yuPh+X2q?=
 =?us-ascii?Q?InWzR3q7K/DSt14+anWlTfKc6yZ++9OUKv43e9zeJn+oOo7wh+PjZaZxC1wb?=
 =?us-ascii?Q?P9lbQrEBUrCahDjMsvtIijqpcHTy2O4WNDZ95H8bSWrVPGPYLyiFoSmI07TB?=
 =?us-ascii?Q?2/ZMEEnp4yjlLai5dyXfl6SAwTUc1hYwfUfSsd5f3z4PCdfiDPRJj/8HsbYm?=
 =?us-ascii?Q?qmnPbr2tsP7L2Bol+0J1vfxlDcSy2//NP670T1wmvMq+hYXCzMPuYyXjNVN/?=
 =?us-ascii?Q?yKEJcVZHJTkEbGIbjFZHkBRKtTUeAI61gN2RRfFWq/PmOh1iqy2oAqhMfchZ?=
 =?us-ascii?Q?BTgCE1tK1ONxR/Lh8F5wV/tUbL04QZP8My64Rto+EG81eGUCT7QGO2rUxTZS?=
 =?us-ascii?Q?sDXlI6rJ5P8PQWXU4lG9nUvGHry08HnCimFnJ9nGqBlleDR1yCdfm+qII5d1?=
 =?us-ascii?Q?10XofvrWAklcXS4KR1bGnRep/z9bZxJfl3zb/QT0QuJnnlhQq2CFOphgv+cO?=
 =?us-ascii?Q?fQZk5wd13aytPw9+1WwFhJ9Xx8KAnmmEjM4ExFrbn2fT4860YJc3gkJvhYTr?=
 =?us-ascii?Q?bLDDvutXhUSHqhJONurAbIWpdbf40s7/xsC5NtpiIkJZIUuLFOr8YicU3Z5s?=
 =?us-ascii?Q?3fruXBtI/F19axy9ABwulGG359BFWEtVu/RARKHEAnGfvULmIOt9Y9+yNfSp?=
 =?us-ascii?Q?eUtmNbTu2xZ+VNOYYRDnEyl+UfqOmN/Bi3CMylB2eVibV57kzWuRWhWwVims?=
 =?us-ascii?Q?ewXb6RWvuC0Fiel2LRkS0a+bhtu/2rtoCNkKXpA+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ec2073-7fb2-48d1-59b7-08daee556dec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 13:13:11.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OneZdtxOqsNZosHvYs230+vceI6huU5z/ND1J55KrCZsWcy3ar1JR3ZJ84mHsY1f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4536
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:09:54PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 04, 2023 at 09:03:06AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> > > -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> > > -{
> > > -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > > -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > > -	int err;
> > > +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> > > +	if (err)
> > > +		return err;
> > >  
> > > -	MLX5_SET(query_special_contexts_in, in, opcode,
> > > -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > > -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > > -	if (!err)
> > > -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> > > -				      null_mkey);
> > > -	return err;
> > > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> > > +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> > > +						     out, dump_fill_mkey);
> > > +
> > > +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> > > +		dev->mkeys.null_mkey = cpu_to_be32(
> > > +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> > > +
> > > +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> > > +		dev->mkeys.terminate_scatter_list_mkey =
> > > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > +					     terminate_scatter_list_mkey));
> > > +		return 0;
> > > +	}
> > > +	dev->mkeys.terminate_scatter_list_mkey =
> > > +		MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > 
> > This is already stored in the core dev, why are you recalculating it
> > here?
> 
> It is not recalculating but setting default value. In core dev, we will
> have value only if MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)
> is true.

No, it has the identical code:

+static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
+{
+       if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
+               dev->terminate_scatter_list_mkey =
+                       cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
+                                            terminate_scatter_list_mkey));
+               return 0;
+       }
+       dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;

Jason
