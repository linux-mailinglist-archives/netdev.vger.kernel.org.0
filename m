Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD96C6DB0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjCWQeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjCWQdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:33:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6995B2A9B7;
        Thu, 23 Mar 2023 09:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxiSUq2eJbqlkSmAkh6UJs3Jb+arYfkk7pChDiI/qkBHWvy/4bZ6hLGOTBikRfsVeS558UvN8YZCV5K+sjQ2fklR4R1nmjedspNMUilKqtL3P9nsEk8N+yTgNv22NO1vNTiI6QN9QtPXqCV5t0RI1EjicGeVWDcQQXS0iXd0E5eOOABWFupVFaNOEC3/G5BQMnWqvxFeNz4hTYybhkBXyaLMbSq8riYgO/UefUORti/VSNCpvON8opFGWtOCzNpI+1SFhtRcnC0n3ypauLojHy30uELbf6iVXjuA3Wpxe8iBpczJUWHCsdD7Eg86zjW5F/pAMj61SfwLp71IjB4fxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQKVxgLehqVPkozYhyuaLBqqKvu2gByk6Px+XxdGAHQ=;
 b=D+l7C4otXjmFNgtXn9zTQMC1xw52IhdlTp5pzh84kpuyxHEbvRuUkrOVD21f1GIpTS7X6n7UvHWtITFsfAVJUO5fzvxQqCYw7nis5t9IRo4Oz4acmXEYO2kJzpASjs/L7iupRolqC36/0T8LdGodgJlUpnTxzlf2Vc5YXVQJEoKyjDX3t7KGbZsGte6qcvQ6zSCZdnVlj12Flmw+irUkJ7TnnT7HetbbwscUV50/Cx5dW36O38+2I8mlG1SzfFKo5PxR9e0MS+Ae1lyEgNsLDvppGPf3yw/kfIpL5/lzEWtSLmQ1YCZrgiF+0Lg2xcL4N6rpYak8ThGFAjY8jaDF2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQKVxgLehqVPkozYhyuaLBqqKvu2gByk6Px+XxdGAHQ=;
 b=YbMa8m1YO0Qtm/R4UJRXAvEPRDLYKNlk46isAVDfWbXH/N0HDOjhMnE2VcT86F7y4WXX5b4H0ooyx1i4JL+KfcmzzhjvUriFWx6eOpJRlia/CgGUpxDzbqSJP4KYi6uEedlL1GZ6DfONN10ZDAcuRGtWTZYxS4pJiRMqalcVtGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SN7PR12MB6982.namprd12.prod.outlook.com (2603:10b6:806:262::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Thu, 23 Mar 2023 16:32:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 16:32:31 +0000
Message-ID: <9852b241-2fd0-7d71-9dd1-d240b1303cd4@amd.com>
Date:   Thu, 23 Mar 2023 09:32:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH 7/8] ionic: Remove redundant pci_clear_master
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dariusz Marcinkiewicz <reksio@newterm.pl>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Brett Creeley <brett.creeley@amd.com>, drivers@pensando.io,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, Hao Lan <lanhao@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Long Li <longli@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
References: <20230323090314.22431-1-cai.huoqing@linux.dev>
 <20230323090314.22431-7-cai.huoqing@linux.dev>
Content-Language: en-US
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230323090314.22431-7-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0205.namprd05.prod.outlook.com
 (2603:10b6:a03:330::30) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SN7PR12MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f90d8ea-287b-4a4e-57ca-08db2bbc32b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PPM2AG8weNxsZvAC1mTHna5wPHLeB3p3KQw+iMRLVxMvS3CqDumhqN5cEP0oteNlTSzoYBtWuWann7Z3RhvNe9vaEtKWpW0jxkPm3soHJcHBjKPKR5e1wj4Fm/VJBymrAXOHMksV88y6TmLqTYd+r08HD89RzFe4fv3oXh0qSftd81izq0YHB981CYK5AJl02qLzxhS98iP797POrN1/fxhKhLjhipw7GU1UppBeQM6HYylrvTBhHHJ5AKjpWL01FIcujA8jDQgNlg7Jxp9JKtqkms0WFbdbFq2SWEt3pUL214wAGL6kNrFwB89gzRF7L4ogID6LR13/dL86lN9Nav9MQbD6An5+LCW00J4lkDacBktkJDPy/+cxzzQSKKXuBCinLjXbZfqTdNEqc9VsG/OzA6TtzNnomkVBlkL8qKa8hEg6BXGFXeOHxmyyqmMBITIevZLMxczU2JhMuH87kY7qhmiEUeqR/Zx2e2feMAj5XG2Cwf/6FGALw5lbhhhmDGDFGOCNcsIneYIXC/Ibeqa3AsQVxzEZxVpJX57V1ZjklrKTAEu2Plq/HilIcM9QNSf0+gCa73NcwS4IIM/Qarg9UsPgCFQQOFSYbfOKnFqeOapj/wmozgpmS17Nh8j/aTe+CGzgrddjflO8ZsVjz/4WKNGViVNrYhePc9RRsq+GkjvClKivWl93FMdVYUyZ1toX6K/REXdudN7r8sOzLXAt4NpQGrOBSpc4o/yu1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199018)(31686004)(41300700001)(66476007)(6916009)(7416002)(5660300002)(7406005)(4326008)(66556008)(2906002)(44832011)(31696002)(86362001)(36756003)(8676002)(38100700002)(6486002)(66946007)(6666004)(26005)(478600001)(316002)(8936002)(6506007)(54906003)(6512007)(83380400001)(2616005)(186003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODNhRVlZYno0WjluQnEvdHFHSllRZU5kMEVzRzRPMHdUMXJjQ3E3ZGFBcnQw?=
 =?utf-8?B?ZXV4czlsZ01CR01LQUJlaGxUcGoreXdsaCtDK09nMlo3MTZRMENnQVdqWlRR?=
 =?utf-8?B?Qk9JeTRuYVpUQXJyRkZLKzhFaEVkcFNPaFZjTDF1QXFrYUxlTG51a0VCM3VZ?=
 =?utf-8?B?eCtuVEdkNGtGS3F0dHVBMUl5TzFWaUJXWDExVVFBOEVDamZJd0RiVmpqUUhF?=
 =?utf-8?B?V0JlcTRvZTVDRDg4MFg3Z3NDY0hPTHdzWVI2SDEzT2FNa0VKekZoenkzWTIz?=
 =?utf-8?B?STRBWFEwVldnRG5LcHIyYTRpY1pGUjdrQTJTSWtWS2lJcTM3Mlh4dFB3ZU1P?=
 =?utf-8?B?OGJBNjV2bEhIUVQ2NjQ0OXdaSnJ5a3FKNlJMNDl3bHlTajJIMi9tdyt1RVRZ?=
 =?utf-8?B?dktIVVlFVHdXK1RUN0MrOWYwYTM4R2l2QkFPY2VQZVZ0QlBoQnRWNEI0OUZP?=
 =?utf-8?B?SXMxYWt0OFJwRE9SYjk1bmZWcE1HNzRTeHRvdWpIVFBBbnhTMGtaOXJFNEZM?=
 =?utf-8?B?Z3pJbHgyV2R2cThOU2RSS08zMi9mYk4yZG1RMW40Q2IvQjkwOEdDU0xLRFFQ?=
 =?utf-8?B?TW9XMVhQaFN5Yzk3TzFXRTU4NkpJR2RROUR5cnFCMmdFUFFWM29SRnN5K0xD?=
 =?utf-8?B?cFFrWjV4cFRVc2d1dFo1ZGJzNm1ocmFlbWlsNWZ6MFpobkhxUVNvc1VaQ1VU?=
 =?utf-8?B?UWd6NlZ5QVV4ekxMbVF0ZzFreHVFeDJBSEJEQTcrbTliNThEcTRLakU2VDQw?=
 =?utf-8?B?ZG1RVHpncHVldGtUU1JTaWJOYjJmMlplVWdZSkpMamgvWEdQY2xydTNvTXpZ?=
 =?utf-8?B?SktaZCtxVHZxd3lLUFVpdWJtNG5IN2t6djRLMlRPT0tybGlXMnJaWCtEK3FM?=
 =?utf-8?B?dmIwYjRHQXViQ1dxeE9XaVNUK3RGQTJnOEI1NWRXWnYvTVVCN1JEbSsrS21E?=
 =?utf-8?B?QTYyMm02cTZnei91V0NjRGhxR2Q3NWU4VGc4cFBlS3hhRzczcDRjK3ZrTVN1?=
 =?utf-8?B?eTRhQU9ncjgrblJCSWFhNDh0clhUMU9JdUo4WGRKQkNuR0QzclNDSDBRRldi?=
 =?utf-8?B?c0hWREJiU3BtSy83UmVWRlU5MEZFaEJlMHdndjZyTnNaM0hzbFZSZGx2R1BZ?=
 =?utf-8?B?eHFSM1c3M1ZURVdUVnZrazg1RGV3UDZBbnhQUUxzR2RTUS9kOFBJRC9kWFBk?=
 =?utf-8?B?MUl5ZTV0Uk1pMzhPQnk0S3RNYmx2bDBqcm1pNTRWeGV5K3RTZ0xvQU5pUlhP?=
 =?utf-8?B?T3hiK0tLdUovZmZRL2YyTkl2V1hFRHhmMDViVkpYRHltM3lncnB2V3AwRy82?=
 =?utf-8?B?bkdGNTlPSTlTejh1Z3krQUR4enZOSjdVRFBaVXN3THBhMG5uWHh0clphc2ZZ?=
 =?utf-8?B?bHA3dzhGMzJXNUlGZFZ3OTJ6YUJ5R2VTbHFHVzNRRU8xUHNpNlNHR0xVRmlX?=
 =?utf-8?B?cWd3aFpjVVB3eDNnZG15NTZpbU9yUHFZeUlVQ0JOZnVGZCs1WktZU251MTVT?=
 =?utf-8?B?NWZrN25xWW9LUmg5YTBwQzF4dVhkNkFrNlFpcS92NTBwVTZ3eWxqaVJWZzdT?=
 =?utf-8?B?c0ZJNXRLMUhtdlVHb2FmNUdVUVk2SzJES1BOSGhvcjgvSFdJQ1VYajBUekJD?=
 =?utf-8?B?clpZY0NNNzVhQWpjUEg3K3RKWkRHdTl1ZWFBZXdqNlVRaVcwRng4OU1sMFFB?=
 =?utf-8?B?VlFDd2FhOEJWMU13NnV2b3J1TUxlVXZpcThNOGwyVkFPS0FOYitPclBKWC9D?=
 =?utf-8?B?bzJhNjJYTnNJenZveFNRSGhaem9YbEY4NmE1aWRDMEZFNFlpZlNQUC9yZVIw?=
 =?utf-8?B?dVoxRWt0VTg4SktsdVlsTzIxWERQb0k5TDRvS3F6dFZKOHc5OXlkemtnd1hW?=
 =?utf-8?B?eTZQWkJKNHBGTFVpelBZMm1VU1c0dWdzL2ViK0grZTM4OHpEa1VweWc0MUE1?=
 =?utf-8?B?M2lDQUtHcWdyb3lXK2dQa3p5WjlvY2JienhGbklUT2s0MEMyZVJodVB6R0VP?=
 =?utf-8?B?ZjdvUllxQUdCTWZ0c08zU0Z2dFpPN2pSdGhkQ28zRXlFcEFjZ2NXVWNQMHdw?=
 =?utf-8?B?ZXBBdDFkc084M054T3pGS0tPbHpyenhrc3VkUXN4aUF4QzBDczBXaTZHdUpN?=
 =?utf-8?Q?+ZfgZaPIi2BpA2yGMEHT3d26P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f90d8ea-287b-4a4e-57ca-08db2bbc32b8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:32:30.9875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAoNQhp9xqMJs8taJMF2KSeyA2H7ulvpcrI1w8lpf8UALKcObE89SBBbl3IS2ejiFP0HbSshMU/qQwRjeJRUfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6982
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 2:03 AM, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
>          u16 pci_command;
> 
>          pci_read_config_word(dev, PCI_COMMAND, &pci_command);
>          if (pci_command & PCI_COMMAND_MASTER) {
>                  pci_command &= ~PCI_COMMAND_MASTER;
>                  pci_write_config_word(dev, PCI_COMMAND, pci_command);
>          }
> 
>          pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Thanks!
sln

Acked-by: Shannon Nelson <shannon.nelson@amd.com>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> index e508f8eb43bf..b8678da1cce5 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -392,7 +392,6 @@ static void ionic_remove(struct pci_dev *pdev)
>          ionic_port_reset(ionic);
>          ionic_reset(ionic);
>          ionic_dev_teardown(ionic);
> -       pci_clear_master(pdev);
>          ionic_unmap_bars(ionic);
>          pci_release_regions(pdev);
>          pci_disable_device(pdev);
> --
> 2.34.1
> 
