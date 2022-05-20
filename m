Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6342252F58F
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353858AbiETWQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345089AbiETWQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:16:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A916E8CD;
        Fri, 20 May 2022 15:16:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4QKgCA1iI9oWTz2SVBYBraDVfB6uuXhgrb0EgA9AXBA2Pn5VKz6UIc/9+3ww3IqD5/WlBmrFOQLJR5je/akozWI/pkAZ6QVLPbVKhxe2GOxesLlm6p+gIOsSf3p4NlF/lIzO+h9TMRTylJiiPALbwRu2//47A0tzTsuInRsieyV0aoOD2gDCayNERiOliBzb2m7YW0L9qLshwBjeN0FFfFYmX9KV1bioTV/qct2nfuYSNck778gG/W5O+4oo79X30YHAx2LuvXIgZH//Y5xuReZioD4N9hsvQkacbY6GT5yT9HKhw+WdkCh2qK2mTaIix8mazuETJe8Kia2yaalCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4H55jr8ld4bsOPUqGSMtesrL4oIDlLT/4Hx9CIhMqQ=;
 b=CNVvMe9qwP6w58khQAmmuSPaNjlLBIUrrcqx8YoFiAlicMDXSp1ZlaYiTt3K82gVZg1rLFaZ/D2pc8Il6RRpwcjwieVJ1SeyBDP4ugpVEfW6v/JW2bhWYq7VtXKvpEPtAkRXByKNx11OFwSSOavsFIj7+d9J5Nd+5OXdY7HtDXRCsYWs0fM5z+1SHvcuWP/pWX9B8sAZrrGmzE4hanTXiD+lGGp8kMlWf7/dnN+xrzTjLJFuDmvcaoo49pxhNJjY07Er4IjHqKAkOFVWtm0WtYFhU4X5BZperlhkzQMm3vVsgu4x0vGDx2n69OczVddAJxBO2NFJGiib3T7yXsZYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4H55jr8ld4bsOPUqGSMtesrL4oIDlLT/4Hx9CIhMqQ=;
 b=WT6Kl3o+hpB2dLkr2fgtRKxStLOK+Wx9vLt8pX6K22YhPzQvdMd6wjIlbEcpTAZMRi+cWTXtkoBOXTMZI5btv37eeJ++CDZed/jhUP/yqKusoz1UuIDkx2+9R6QdlrW+Jgq90dBP6UhwK1xs5THXjW+vPse5xJOtaNtDuhJC8WKaBe6CRI8xbaVj8awRYf7xDjLIhk9lrjueqVsFekNPiazvqnsBi/sD4sp9Hqzymmc/iosUlODzghRTWfv099SQCwZEQbJ0ojtbyxyPXEqQ3kDrxvFNynB3fv6k34lvgcRPZwV+bOkbK8B4dNqMGMPfS6eE9rnZgSPERUH0IAXU9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DS7PR12MB6071.namprd12.prod.outlook.com (2603:10b6:8:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 22:16:38 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 22:16:38 +0000
Date:   Fri, 20 May 2022 15:16:37 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: linux-next: manual merge of the rdma tree with the net tree
Message-ID: <20220520221637.24jwi3uy5iai3pxo@sx1>
References: <20220519113529.226bc3e2@canb.auug.org.au>
 <20220519040345.6yrjromcdistu7vh@sx1>
 <20220519104852.0b6afa26@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220519104852.0b6afa26@kernel.org>
X-ClientProxiedBy: BYAPR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:74::31) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e679d8e6-d826-4fc1-eb8b-08da3aae68a3
X-MS-TrafficTypeDiagnostic: DS7PR12MB6071:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60715254B21868638972F6A3B3D39@DS7PR12MB6071.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnTCh21Kt5rk7U9YoYPKI18LrOrJzmgkQFpXy6423SfV6DQ8ppS2tTG6ktZjU3m8Kt8VVgrGDCKCBnBjP3c2w3Ta+CO0KpZqtBRyzVxICfQlgNkipoQ6NVG+opEQ+vJeaUxA1zm+ZigQEtOyV/QYVVIUAN5G4Av8GkkGQTVIVH7UEqb7EQDsaOT+B1udangQ8wHI0MPcRMOdqwJVuEGmsjGLCDzm+g+wgPMqU8FZ3FWXDD6IW0aBa4Q8qCOh3IcLzTSyyw/iS5BQdF/v02TIkrki9qZEECDPFuAGlJVS+dHNmthMMHbieLic4vzjmUmzlveP7JX4FlCzYbHAMDfdC5WE+g9CeDhktOdSsJpHT2vX9FKIlaKk9PgM96lRHU+mUT3Jlt6t8W9NBRXqOWwEycmuWjaOHjPzTJlpIAuSP6sOLYnrEJXHdLzLdbQuswIcXHqgnAKoqOxtKZQprNRyloIwNRz/y6Wd/P1crWPOYJ85fW1nC7qJUrJ95jPaoWbEVbF+meIWqv5mdwOyoAqtXkfRYSr2wxOINFKK8IoKB+PwGB/3Z1ErlaqVCXc+fLXBhac6D81XZRhi8Z2Rh9jl5tdjKsDfZOdYHeZg2+7oeuBTggMWivLPPjbYv5d1xBMziDPymBlBj19yKh3tCeezOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6486002)(1076003)(66556008)(33716001)(4326008)(8676002)(4744005)(66476007)(66946007)(508600001)(5660300002)(8936002)(107886003)(2906002)(186003)(316002)(38100700002)(6512007)(9686003)(6506007)(54906003)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3N5lZHvkXkgY+ApfdoTj+rlFU1RgeIz5X2JflhFlqsFRj3zcDlgdHLexAaKV?=
 =?us-ascii?Q?EVgWpELzzR8oLFEvPjoljRdzk0YeVw+hvKBU2ehYJs9p8oa+fWVbKXtO93Gx?=
 =?us-ascii?Q?gy2us0K9DWCH1uAHDED04BxGOPqAYsdCe06ewb8qulGAJXYNv2BDInx+hQYN?=
 =?us-ascii?Q?LkoUzxSMkOkjCkO/IsBTS+tLQSCN3N4Nt8k2nSrLGdOe/Ug0Def72asGiZPy?=
 =?us-ascii?Q?VuUtPRDx+QkKm+f/ao6hp90Kofgr4knlhceaw2OO0dPqSHgeaQhn4v/e/HK/?=
 =?us-ascii?Q?0Vlg8jahBO9vk+/wQh+S5Kl49EVDBtwQ8lLODKRuQhZRcFpaOdrPd+6IvwO5?=
 =?us-ascii?Q?a9e3FKUWF5Pr8QDYWzJDEzO9qQEhIu7hUpbfXnTCmWkKiK4EPxabQLve1/C+?=
 =?us-ascii?Q?Xv/qymX6+I6mHC2lI/OSB4IdW72UdE9WV6IpRRD4FAm7taVdk+8vtPdkVWPA?=
 =?us-ascii?Q?gnzUNbHQnGpIuLwukKY1gnnMPRfRC3KH1c7KDKBI4a0v66voveDnnCelEOkL?=
 =?us-ascii?Q?OR6G/8VZe30ic3TPFDbCaR+oIbShI4Dquooe+HiZyW9J24qU93aUo0hBa794?=
 =?us-ascii?Q?vP4p97ifQ2ZWll7pqrWS3qj2LOKJXiphDHbalTRIUiZEjlW7268GGDF4REfB?=
 =?us-ascii?Q?L0QqbAW/hhNPx8vJWSEigElYMsW6Ih5x5rbqvMLPreYwXPELGuHRZocK6GZj?=
 =?us-ascii?Q?rCxqdbh4XXw4j+ngneZfs94qFwtvbtWGYjLsjvPdSG9sSHu7Pq+7FCDEexTk?=
 =?us-ascii?Q?idmv264zWvjeQabky1U3mI24nwItW7uGVfWfzy5D8xOmkQQF67v5HmpyRlOM?=
 =?us-ascii?Q?7WuvEBmj1gJfVWcgW0kPADcGke+nDYazXZ5nht8vbiZ6eNuJp4vzvm8MZFvU?=
 =?us-ascii?Q?n8AM5yJL71rCtFKXNTs1xTRIsi9EnHOCyic2YUOY+C/kmxIZcL1p1vBQdFQO?=
 =?us-ascii?Q?uL/Shto99Enkxd5r5VaDVIGrVXLYaxt/wSWoiZ8jDKVkKgXFTzpRSazBHiem?=
 =?us-ascii?Q?UFVZaBW4Z5gnutIJwPlI9qewUD2kVbjx/lKIfOaO1zGGJdx8Gu2WHOkZkrAB?=
 =?us-ascii?Q?okVjHVuPPlXKzBh77QVCDhNE9TbRpFpyhq8j/NeUNEtlv1avVT0dXHbWqTT4?=
 =?us-ascii?Q?SZthVnAxjW+ko2YRL7OksEmKa/+Wk9983Sh5Y0+V5s6wWMv6GIjlkjU7nNOl?=
 =?us-ascii?Q?K2MjQN6Mtd3VhprzBy5LfAiIqh1lw7MtwnwNkXgUOdG/PaZBsoKROA8QoRSg?=
 =?us-ascii?Q?J4HsISNOIW78P09v72V1DlZaauiUNx0WAyTt0flo6YpjW/g4dI50rQzmCnJF?=
 =?us-ascii?Q?Smmw+6skFJ1B11CfQt34XU1J0uuprYAyuq8UzuHZeAfwYxRPO5Q23rAWpMEw?=
 =?us-ascii?Q?3HCpmGdnyt37ePn/drKnKg+9h//fVVYq1Jxg/jJ27OoncicB9o3rI+gC0FtY?=
 =?us-ascii?Q?CjB8cdHlVE74F74vLL/Hbz0gkHLERETyeY5W1fpBzTPqxq5cVWh9MkBgEgi/?=
 =?us-ascii?Q?B7Z9W2twe9wLvV2v7XenZCNldpEdwXxCfTR6gO6Uynw9xykzAk1bb92MTkS1?=
 =?us-ascii?Q?iC/4R25oaGbMdecFJrAiNZlF29AjtFiI6CwSSyM5FGzHYCPyPYhlp/hsfm/y?=
 =?us-ascii?Q?18JiE6N2whRMU6mIinMERVji8wUYDOyaVoZGhlfrucd13UKyZYUzG1bcRmXQ?=
 =?us-ascii?Q?xyM7VNMLu+x9ynZR6l9ZBPx42rzPd73cNOMgOpcdrJ8RHKRipXeuV7c23JHZ?=
 =?us-ascii?Q?04TlIreNncWNhaamEh5L26SIF111ULKzzGqTBlL81ZiU/zpBSlCJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e679d8e6-d826-4fc1-eb8b-08da3aae68a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 22:16:38.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SWKgqX2C+QvgC1hQYnxxmqb97I6Hme0QWz4gg0FLEoWGedOwRBvlVONe0sygVv/lr4gXi+Xdq+YNMV8jhREjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6071
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 May 10:48, Jakub Kicinski wrote:
>On Wed, 18 May 2022 21:03:45 -0700 Saeed Mahameed wrote:
>> >@@@ -1274,9 -1252,7 +1261,7 @@@ static void mlx5_unload(struct mlx5_cor
>> >  	mlx5_ec_cleanup(dev);
>> >  	mlx5_sf_hw_table_destroy(dev);
>> >  	mlx5_vhca_event_stop(dev);
>> > -	mlx5_cleanup_fs(dev);
>> > +	mlx5_fs_core_cleanup(dev);
>> >- 	mlx5_accel_ipsec_cleanup(dev);
>> >- 	mlx5_accel_tls_cleanup(dev);
>> >  	mlx5_fpga_device_stop(dev);
>> >  	mlx5_rsc_dump_cleanup(dev);
>> >  	mlx5_hv_vhca_cleanup(dev->hv_vhca);
>>
>> I already mentioned this to the netdev maintainers, same conflict should
>> appear in net-next, this is the correct resolution, Thanks Stephen.
>
>FTR could you not have held off the mlx5_$verb_fs() -> mlx5_fs_$verb
>rename until net-next? This conflict looks avoidable :/

Yes, sorry again, will be more careful in the future. 
