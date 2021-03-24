Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21F34772F
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhCXLZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:25:35 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:44370
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234674AbhCXLZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 07:25:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPEbOKL/FfpMUVhSBKdwjw+qqyR74n7QT89la2axqikqUKfRHAX666fJogH+nr7wVM33iVlL4c0eYdZeZLUE1/7FuSYgnws5AdJMfNuTLHpyJk4BcJCfpYFz8rIG3wMKC/tz16XGbVYJfuyYuX0BvWYQjnCgIJ2N6VxQckOhCCRpg6zMlUKk7q1DkA5MzwDfUW/ydSsBy5ikGFeynOI7q4f52Nno6RzrTG4VETiX8bSUogq2I2YxhxJv3JGdhYEErVPmt3TbxNL46vj2lqLZAVmoj7VQ7tZyqQQwmJPRlLFP68eif+rLwlx1cVFEIeRHD9DhYideyFZZRjSyeU+nQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6Id7HcMKUBeuTRR4FubQiGvCTLIvxt6sJZW1E7Zy1A=;
 b=M5vVY1HnqKLVXUGK2+fjr57mmAPa3oJp6qNATFv+kXgoupX7Bt8xkT5DvbmBo7hgke9wGtP94prZvF6V3kOb7oj7X3zL8sBOGKjP6GLnASxhjx6rlsQFAECvzxoudzNM6bYVPhen9/HGerTmqAiuMY2fzBahIiFJV//ocN0WomFkeZN7qniDwU8m0Md9j7hkef86st40koK91wRgvdRtIjhzLugE/rCVPe5wZ2v6eE8tXyr0Y37BOtdHheuNwNn/PWnSgfmFUIdaONLx98h02Hnv5Ihn9fNnDgusS6UQ69DKAYfwZkxZiu5e2PmAihYcVcFx8hQslHbj0G39/7j0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6Id7HcMKUBeuTRR4FubQiGvCTLIvxt6sJZW1E7Zy1A=;
 b=OnH/fNfiW1wV0Ct+3K5ngSpITEmC0j2cHHLSD6jaiC1AmhbkjOsEVqW21e5+Rr34gszY0vCeb1nk4u0zMRDQ7KkHAcAAPzyvrGE6NDLIx168MTOclHLQrSohUOZH9no+wPks0XhxXGUiDkcZYbs3HBNJXQNjkPbbUg0lHUhPEte5S7xEGEYcyGK9mcgCzxLMwLfb8Y61jPuSI/MxBNB+gPddQQhlntd2tLpZXxf66e0sMi7LlkV124zmXOq5TZwO9s17BGoSYLvfPAlq3V9UM/8NrQFvha47ZSY9Ul6hr9SGwpS/Lp527cqkIpYiaYIdhhLHrny/mvznpg0tINaycw==
Received: from MWHPR22CA0055.namprd22.prod.outlook.com (2603:10b6:300:12a::17)
 by CY4PR12MB1335.namprd12.prod.outlook.com (2603:10b6:903:37::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 11:24:59 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::92) by MWHPR22CA0055.outlook.office365.com
 (2603:10b6:300:12a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Wed, 24 Mar 2021 11:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.22 via Frontend Transport; Wed, 24 Mar 2021 11:24:58 +0000
Received: from [172.27.14.215] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 11:24:56 +0000
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia> <YFjdb7DveNOolSTr@horizon.localdomain>
 <20210324013810.GA5861@salvia>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <6173dd63-7769-e4a1-f796-889802b0a898@nvidia.com>
Date:   Wed, 24 Mar 2021 13:24:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324013810.GA5861@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f028e02-41c7-410f-9f12-08d8eeb77587
X-MS-TrafficTypeDiagnostic: CY4PR12MB1335:
X-Microsoft-Antispam-PRVS: <CY4PR12MB133575A85136EBC3CC4BF0FEA6639@CY4PR12MB1335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vzwncbLGsiMli+AEFc8qaIOFbWZHW01vmes5YUWHMt5pYFRo4xXKNSh1Tyijr90LU8GkateNENXmCGfngS9rnJGYBrDIPMOelDZhAbCg+ypSQAQgeOCN51arRNbAjIwkI91FwrE03VfvmehwiZBLz5p+fVcXVhxvPaxMQXIgd03+pfku12Moyr5IQ6AvHn6k3b8TYW9fbvM3p57ppQ/ra6JHzgs5z+OCckR8ECRs82dKN1ouAdLNLuqz6+irg3bXLyC8Jzc30ChNYKsK+Vn0YCk0U4+/qbGMYFIzKNDnbLhVjwn7fLlDQXtHANjGvH84No6LSsRM8X76+zH/o4z7Mcro/PCX8nw25crcjEjiCVqVMVZDKKVnkoBKenEp7xYgdPFgMXusB5bvseB9QO+VKSp9ggHgFtbX9V/8osZ/U/F70wNPrNcNjsifGE1wk0OpvfidoqEu33Y4ASFfNIJjvfavQj5tsEZXVHN/jWjVG291km4iojlzbyVJCN72cxBwc4WcbiJOceBH4zyTdGf4Jz3iZarLsFW0+kFKah8x78Zl63NW9Mz1ce+PWVD0sUPOfYN5NHIOESZxl9mBucp2uFnvh2YVMwGTYJVM9oD7XmJnfNBtNXNg/LVK0dbqRsxoXRh98ISaSD4LUbGUJ5iKp4DDVuSGP0NRJZHJXTA34VSbMUvDR1lBg4GG93eK5Zio
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(36840700001)(46966006)(36756003)(16576012)(110136005)(54906003)(186003)(7636003)(2616005)(426003)(82740400003)(336012)(16526019)(26005)(316002)(2906002)(47076005)(5660300002)(86362001)(31686004)(82310400003)(4326008)(8936002)(6666004)(83380400001)(478600001)(70586007)(107886003)(36906005)(53546011)(36860700001)(31696002)(8676002)(356005)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 11:24:58.8924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f028e02-41c7-410f-9f12-08d8eeb77587
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/24/2021 3:38 AM, Pablo Neira Ayuso wrote:
> Hi Marcelo,
> 
> On Mon, Mar 22, 2021 at 03:09:51PM -0300, Marcelo Ricardo Leitner wrote:
>> On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
> [...]
>>> Or probably make the cookie unique is sufficient? The cookie refers to
>>> the memory address but memory can be recycled very quickly. If the
>>> cookie helps to catch the reorder scenario, then the conntrack id
>>> could be used instead of the memory address as cookie.
>>
>> Something like this, if I got the idea right, would be even better. If
>> the entry actually expired before it had a chance of being offloaded,
>> there is no point in offloading it to then just remove it.
> 
> It would be interesting to explore this idea you describe. Maybe a
> flag can be set on stale objects, or simply remove the stale object
> from the offload queue. So I guess it should be possible to recover
> control on the list of pending requests as a batch that is passed
> through one single queue_work call.
> 

Removing stale objects is a good optimization for cases when the rate of established connections is 
greater than the hardware offload insertion rate.
However, with a single workqueue design, a burst of del commands may postpone connection offload tasks.
Postponed offloads may cause additional packets to go through software, thus creating a chain effect 
which may diminish the system's connection rate.

Marcelo, AFAIU add/del are synchronized by design since the del is triggered by the gc thread.
A del workqueue item will be instantiated only after a connection is in hardware.
