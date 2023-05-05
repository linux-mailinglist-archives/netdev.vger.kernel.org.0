Return-Path: <netdev+bounces-595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 343616F85FD
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 365BC1C21904
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA74BC2E3;
	Fri,  5 May 2023 15:39:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2633D8
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:39:59 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::614])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932141492F;
	Fri,  5 May 2023 08:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXsTdGJiK2dGl4wpm9u1HcKE1YSM/LqHZl68mSRCeHpZnLrY/OZVpfZ8DvyyUAdZJEx3Lo2QnRI++licjLc2noPRdTFXyMKX2ubzPFE4QFjogQxGh5SY1HQatV2GIM3vaqz9eoAV+9IWUMZKom74pDLwxGxfdqZx7mynje1FW50tUcSDK97TjiwdOM+x+TWJ5KltN+ELn/Ig6oZHtI9rmUViwHyEpt+oWteKfXfq7QBiN5ZsCBxaMb5Ipwuem96yzZ6ZjOYbvaqRuV6+ilRmlHLuLMSs8g56Lngoa1Gu8dLmmwgBaM6EYTejpzFGy5lluM/UQnKKBr30abInBEP6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46dizuNNAyb0jCrsrO6ClwTQsKcLHqNG67O2bnf1qno=;
 b=QMh1NL/rfmWVLUi7Aa0ICq5FZhqIXL4zPgXsoAmlaA5SH75I5L6tR6v9x+rQH1ibI0CxmknQxkRK9IcOgZBiB6Tbl+ESsqaV7QTHEJHSG9lYF623XRD1oFDTGO9cixqaImYDLznDuiNWuKniyjKdS8kG06UHQ1LbYp9V7UD9rIanwskM6FhGCEy7hwTyI/xOE/RwpdV6O1g4s+3XxVC5qhiO0gsigoGmNNBQQs5k59+KKS++7kU543a3UV5v6VMPfzHy3OtgL3HRt7lI3TdGVK2lyEHYQsi1ekgCYqnYONnEk0PiOPNASj5RGRV6JSavGA629Dj+kJvq0RoiO9S+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46dizuNNAyb0jCrsrO6ClwTQsKcLHqNG67O2bnf1qno=;
 b=Jhq392sbguMjrmDz9KwvVVC/ClXxkjhnLSASYaxtaTZbqgt4rusup/QrMFTgPDLzZfY7MTjtEP39XLRVdboHcPc5zWmXdg6UU3aYjDpHFgcydcyYw0K94uKdzMhp7qnQFxDjgzQ0WH4T+G2ZHCI7xwXBDqCOeOo2N0sgOzKT19I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 15:39:54 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 15:39:54 +0000
Message-ID: <7545c5d1-3f0a-131a-30a6-1c5cbb2b052e@amd.com>
Date: Fri, 5 May 2023 08:39:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com> <ZFPuB8+Kb0lvI/yx@nvidia.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPuB8+Kb0lvI/yx@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:254::15) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA0PR12MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba12f23-e4a2-4a74-5ee0-08db4d7ef90e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BPlTeI01+LttrEub7PMxysyDNS9CKHo4PWIY8z+r7N+Pt8RGa07ifTifrxjYi7Eg8LgljPu3xe/c47zvd3/YJPoZbfdY8/xUMEgxK5NT7EqqoNJ0fCt5FI1xJlD6sdZKa7GwH+KEG93WbvfqC/ESA4xnoRL6hbUUTtLxln++tPel4wPPPd8AWRcK26wZvMlG2eGFobUdtUD+6NG9Lya2rD947qGg5XQ/91k/TijYQzdtUfS5QyDUpZS+pCkQpeaOLVZLJFLybvvRy0eRS4Dly8/rCLBbocvN4f0ZQtEgc03535BmFNDGSZOhLkkutKD9tpePdqSuUIAKtiKHf9OE5uFITKCwiEKrt1wgeZcWwbB8rH7TqhNAy8vWPiRZZen2EDrIR/ZlzpbECE0SLbpsi06VyrbeYugc0LGvojXP4ZAx1IvkhVkGqS/lROxpdVFoTFb/nQd79kzzqv1VNjq8XO1tqCIWBMctbDrgWRpVZOSWexYnoXMBkzbDP/sGTzlXhyAWy7+VMg1wphMM2Aq1OR7tHsImFwgK8uNkgIuMqOAYnv9oGu04eMjm2yvbQYtCQHcpNe4cqSM9AE86CvYhPWrWV+yXqCTBU7ercPCuj4y3mA+DKWAIMArzzTCzPWPIZ6yoBE04Jcm0Vh7IbZKk2Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(31686004)(66899021)(66476007)(66556008)(4326008)(6636002)(66946007)(6486002)(478600001)(110136005)(316002)(36756003)(31696002)(83380400001)(2616005)(6512007)(6506007)(26005)(53546011)(41300700001)(8936002)(8676002)(5660300002)(2906002)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFIwUWhIK1Z2UEk5MjNPRE5ETGpZUU51bFZ6SWcweGZBbHFjbTdVcTVFMFha?=
 =?utf-8?B?dGRXM2tCTnhZTFdGd0NKcUtOaDA4cSttbzNmR1ZsTzZRNFhqMVJQMm9TZyt0?=
 =?utf-8?B?b1BaR3dDR1FOWlJ3Ty9WWVZoamxtUVViS2hKTkJWaVFIVE1DQzk2dDU5OGFT?=
 =?utf-8?B?Q0k0bGEza0t4eDdJY3BmQ2grdFQycTl5ZkRyRGlGV1lRTEpobGVWVnhiTFp1?=
 =?utf-8?B?dHkvcTROMjV0dWlZWm44ayttNEFwZEFIdGVPcGhsai9DbS9PZ2NXNFNSVmFP?=
 =?utf-8?B?c1pXeUl0Z0FOYnFXelgzWXIvYWRsQmpQajFmYjJoTHEyV1pZdWZZU2FpQkJT?=
 =?utf-8?B?dlB1L1BRcE9DaTZleVQ0bHF5ZTFWUS9CQ0JZdXRhNU1kdXJ1d1dzNElYQkE4?=
 =?utf-8?B?L1FUd0FjK2VTL2kyS0NEZzB6eEs2Q3dJUitMczZnbHV2TlF4VytaNlgyY1RJ?=
 =?utf-8?B?eHFLSUhaUnRka2dKUW9VVHY1Vi91Vi9qeWRTODN2eElkaVU1cTNPYXo4S3Iz?=
 =?utf-8?B?VUZrVDBObXFiWmF3cUFBT011YzE2SytsMm8rZ0Z5UEpZTWlIci91ejlYSE5y?=
 =?utf-8?B?c3lHclZUemZwZUtXWjV0d2lUVkJIYzdaeEFORVU0NE8yeXZmelZsbmtFOXRj?=
 =?utf-8?B?ZkFFc1lGL2IwcFY2VlJRTmVhRzBIMjhPZzBXS0Z0V0Q5aUxRR04wc0dlNWow?=
 =?utf-8?B?NlA2SHdhc29qdTVGYUgxdVl0MFg5ZVVVTG9LNldnaUppOUJoS0JERGl5TTdK?=
 =?utf-8?B?WW1wcnJuZ0tOcHR6M3poUU9sd0xsbkpYRUZkZ1ZRck96Y2gvd0cwM1VnK1VU?=
 =?utf-8?B?M2gwRHlmbGg3UnNnZlJkamVXWGROa3V1QmtqeVptbDdqSzkvbyt3Uko3MCsr?=
 =?utf-8?B?QSszMVJmQlJjODUydmFyT3RBZWcvZ2xnOERmU0ZpMlhWYWlHMExRbGpEaDd4?=
 =?utf-8?B?SkhpbFc0d1NGdldxL1NZbTVZVkNCb29oSGNCdVlnR050OUJ0RGFWcGpTSisx?=
 =?utf-8?B?ZUYxeFNycnRDejhWVzRXYWFQVlNUcmFIQ01tTXRxa2JXZmdPN3JoWWdzQ1Nw?=
 =?utf-8?B?U2lSOHplM2pjTzJYcmNYdTlJM2NKRnlBSjN6Q3FkMklLellsMFhMTzd0clpu?=
 =?utf-8?B?Skk4UXB4blVnTURjRlV2WlcvckxaS25TTjNqY1ZXanl0QzZFWU03bkFKZnFi?=
 =?utf-8?B?TmpzRkd2OUFZNUJPYXhnWENnd2RwdzZqOUxnVmpxSWxqZVVaS0owUVlKY2Ix?=
 =?utf-8?B?aEFyN2lPNGxVRktqVGIwTytNS2hLZWc0YWNOVUx2TFIxVExIS3JZZnErVXB2?=
 =?utf-8?B?RVY1ZXYwOU9FUHJxN0lTbVlUSzEvZmp2ZXBWMU00UG9jME56N2tENWRLWGk4?=
 =?utf-8?B?WEhDZkE3UjNRbFpJSlZId0dDNmh6TjI3dER0YVQzUHBJOU9tNVc1VUxEUkxW?=
 =?utf-8?B?andtL00xMlphTGxZM0ZlZkwzMEg2cjc3RUhXdDVTblFGSGUwNEEyMHR1YmZa?=
 =?utf-8?B?bTBIUGZtTHRaWFlPL1BkaW9uRnJzOHJSNXQ0bW13bDlHR24ybE1rOCtLU2R5?=
 =?utf-8?B?QlFSN2t5bVFaU1Q4K2FTb1ppUUduZXhwWVlBWVp2Sk56MlA4YmViUkw5eHM0?=
 =?utf-8?B?eERYM0hERWlJek53Qld0elV0V2Z0NHFFQW1wdGtKdSs5NWFjeTVkOUhiamJq?=
 =?utf-8?B?aTJkV2VqMHgxTUJGQW1VY0JVSlZMOUVXL3JhSnFEbFFTK1EvYWxyVmVKcHY1?=
 =?utf-8?B?Zm1SaGJSNVUvc2VNZm5XYzZRNFZWM2FiYlBvMnhsV0VNWGVNQ2N2RWpFem1y?=
 =?utf-8?B?dFBwU1ZreDFtdXR3RUFwMXpPWWRESHIwa3lrbXkrQTg3M040Q3NBdlZGY3kr?=
 =?utf-8?B?aU5JeGxlSkRhOHpQRjNmc21mSjNwY0hsb0QwOXduUVR4S0QzQ0JQejMwTEtD?=
 =?utf-8?B?b2N1c0VXbUx6dVdQaW9VSFB1cGlxTG83dWZjblRXMkxrOTZUQmF5UGdySkFO?=
 =?utf-8?B?Zy9mRFFGT3JrL0ZCUkxSY2V0aUE1OTR4cUtwOUlxanZuSU1weXhxY3VWSE9R?=
 =?utf-8?B?NXdFVHk5L1FzR3A4M2prR1BNNHJuV0czbVh3K1hqVkZwaW12M0QwRXlEeUE3?=
 =?utf-8?Q?Gp0rQm+Lwwc1y5YmHi3fa/OD0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba12f23-e4a2-4a74-5ee0-08db4d7ef90e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:39:54.3726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sc7zP8z0HR4WwD7jmbH2WVYZ6kx0ZBV5BgqoUn9L9rNXXfqBa1FMoGEiM67ntRzPvsaZkldeo3tx1daSDARFWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/4/2023 10:40 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:
> 
>> +static struct pds_vfio_lm_file *
>> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
>> +{
> 
> I see this function is called with a hardwired 64k size on restore -
> so this means save is also limited to 64k?
> 
> This is really overcomplicated if that is the state size you are
> working with - the mlx5 code this was copied from is dealing with much
> larger values.
> 
> Just kvalloc() your 64k and be done with it. You need a bit of fussing
> to DMA map the vmap, but it is much simpler than all of this
> stuff. See fpga_mgr_buf_load()
> 
> Since the kvalloc is linear the read/write is just memcpy.
> 
> Jason

My only thought here is that if we ever need to support a larger device 
state size in the future we may have to revisit this implementation once 
again.

I will look into this before pushing the next revision. Thanks for the 
example/pointer to fpga_mgr_buf_load() and for the review.

Brett

