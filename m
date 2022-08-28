Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420125A3DB9
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 15:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiH1N3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 09:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiH1N3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 09:29:20 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EFE237C1;
        Sun, 28 Aug 2022 06:29:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOeQm/4WSVUWEcWN6DCrM0KL/P5Q55t0OocKeU3kvacVIwR6M0xdaEzZdwWrhTC7qlxSRE9tI4FodhwSKbK3iW+bU0jWEdmlqK2DsOdRq31CHGkcm+3Kt3DuigfntFvsvdUU07zzfYBzc37OgKg+Mmaw+lfAZsSDHKammyaEZ9XRh6zfoBnjj7JPtlhjWXt+OgqOZ2KQW9E2NwUKVPxslIPm4dfS7F8KuRVDv/vLcLkzXDDbAjrR6d9Cmln8FgVhLGTTJSJAxvAfwBnMFId2pCpPhpQHfgyQg59UddCMdZmuyg0yCBRlc457LfVdX3gcoQ+npuUOsVNQWKB9unLqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsOwu9m9hu9tpeE0sQbUhJy8CjC9JiLyjT4zv3oSuqA=;
 b=C7ea4heDsp0J+YsZU73gsDqXptJskc13vath4Hjg/qHbZNSIugNjMx8MRO6aVnRDyOsct765POdLGb2KBk9w1j0qveNfX2fSyC8G7DbHxIqt91brxHPfDcFVudXz3uWp37x2fcDSD333g8TWKmjA8DLuyX4xFj9LyeD7d57RRb7XAR/V6qoSdpokJ0ME4Wi6qmYPXOBykU4zL+17rWIOSZ/zRWTyzx3BE/GslgYR6onfoh/uwjkesJz4ixYjbLrx2Kl2lfNOGINoCetKRR2LRTSa3P3tPx3ICekYnhKC9QhKrsbc9Pbsjmx1tlNTLlNOSty1HYrUshQY6PFh4g6KKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsOwu9m9hu9tpeE0sQbUhJy8CjC9JiLyjT4zv3oSuqA=;
 b=M8NoNQPTA422JWDgeGLrsi7KNzdjuAL1b+HjeioAz17160qhwmuOEYehK7NGNpMbokNa6/7bw+OhZdKpobKhkHqYb+ia1sgsx/q1i2chZldLZDomVwlyQUARL8gTIeJ6/i6Dw4wFx+XhEBfpdrwqg2ck1nScft/HHBWfFCiROjM8hI56js1+JB510oXdQrMUlJR+Ky6sor4pnNbl5kQRFktBg/CYO0s4ZH6RVAJPM69tmH6lbTkAyMZIgb68mA7HBjDa7XUdCedtZ0AYpuxuz2szz6KVHWo++Ey2Yags3zWEctTbUZsxym3/vY/GPHfSVD3GogHk8Bc3uIG3Js5OxQ==
Received: from BN8PR15CA0035.namprd15.prod.outlook.com (2603:10b6:408:c0::48)
 by BL0PR12MB2404.namprd12.prod.outlook.com (2603:10b6:207:4c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Sun, 28 Aug
 2022 13:29:15 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::f6) by BN8PR15CA0035.outlook.office365.com
 (2603:10b6:408:c0::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21 via Frontend
 Transport; Sun, 28 Aug 2022 13:29:15 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Sun, 28 Aug 2022 13:29:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 28 Aug
 2022 13:29:13 +0000
Received: from [172.27.1.1] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 28 Aug
 2022 06:29:09 -0700
Message-ID: <53e75905-d3a9-725f-43f1-a1bd03f3b326@nvidia.com>
Date:   Sun, 28 Aug 2022 16:29:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Joao Martins <joao.m.martins@oracle.com>, <saeedm@nvidia.com>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <leonro@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-6-yishaih@nvidia.com>
 <20220825144944.237eb78f.alex.williamson@redhat.com>
 <8342117f-87ab-d38e-6fcd-aaa947dbeaaf@oracle.com>
 <20220825164651.384bf099.alex.williamson@redhat.com>
 <YwjCDSPVa0uNy6vX@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <YwjCDSPVa0uNy6vX@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4452458a-efe8-4549-2289-08da88f94ceb
X-MS-TrafficTypeDiagnostic: BL0PR12MB2404:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RIc83Ikzm1cWqtA00rnzk87P22pj0Dsa2/mBFuE4cKVdHpnlCgosYeWScuQErI4+lOJJ01RdcDyIYqugA9AlkWdA/e/I5H3uQdXaa5u3x/DgI3ZmhzsWcIgd9s5/0B4WgRcNQCBHY94plUfsSDKqskeGMU+d/ULiMwTy9nLbz6slUmYv9IA0v8FOsORTtH2POdkzhlm2nN2G1jAXoRUNcwVrf0wX9IqrxSrIjXB6opGUuF2876nHOo+qqdQf02ehy8x9oMDjCG10QYSfn8ayEIC6hdM1WgUk0ENa4GtkGP0FYJIYjZ1atUzZ7CpkYUW0YCBqE/WkQddJqSmM/DhoVop+tDJKPyX6hIut/LZfPsSxBgHRvyWkQ+rPiqx1QD1jorUWGhdsIpb1EdNDo23P0mrZDsS5LhTHB8tp1Vkya6Vv+v9pBzp0axpvB51Wb+rAYtQ1IQsj68dxmKig2Avj9KG2Ji0KIa7OgRddIzx/2myX1AnOgAD5CJFTnftMhoggirGXQyZRg08hHm7AokibehbEVKpXLxt9QD5208pFa7HifPSpvszYR6KyJDwZKkGZ6t5NndJaD0Xuu7Wrb31lVF6woopMt1zzf5CEuPTV6hgTp+zMRYE7PoF8mABxV/KjiA6pX4JVLnajcAyiV7l0htChYE2ARhqSCPGmor8QHdYtgtyd2tpSY6gBEQY9Zbv0HKXOSVgR4ElOItjDnI3UPPctePn2dm0fcQ0PcYwgm4GQ4UB23k2n6AUbFu92W/MdTXnn732Cj54cuAIedsOYldxIIC/00L8Kb+rkTPShke/WXQrdUPdcHZApVMSOu212mxtU3pvQ+cFCtzvwWlvb0g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(40470700004)(46966006)(31686004)(316002)(16576012)(54906003)(110136005)(478600001)(82310400005)(63350400001)(36756003)(8676002)(70206006)(70586007)(82740400003)(4326008)(356005)(41300700001)(8936002)(16526019)(40460700003)(40480700001)(36860700001)(81166007)(5660300002)(6666004)(26005)(53546011)(2906002)(63370400001)(47076005)(426003)(336012)(186003)(31696002)(2616005)(86362001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2022 13:29:14.3340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4452458a-efe8-4549-2289-08da88f94ceb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 15:52, Jason Gunthorpe wrote:
> On Thu, Aug 25, 2022 at 04:46:51PM -0600, Alex Williamson wrote:
>> On Thu, 25 Aug 2022 23:26:04 +0100
>> Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>>> On 8/25/22 21:49, Alex Williamson wrote:
>>>> On Mon, 15 Aug 2022 18:11:04 +0300
>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>> +static int
>>>>> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
>>>>> +					 u32 flags, void __user *arg,
>>>>> +					 size_t argsz)
>>>>> +{
>>>>> +	size_t minsz =
>>>>> +		offsetofend(struct vfio_device_feature_dma_logging_report,
>>>>> +			    bitmap);
>>>>> +	struct vfio_device_feature_dma_logging_report report;
>>>>> +	struct iova_bitmap_iter iter;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (!device->log_ops)
>>>>> +		return -ENOTTY;
>>>>> +
>>>>> +	ret = vfio_check_feature(flags, argsz,
>>>>> +				 VFIO_DEVICE_FEATURE_GET,
>>>>> +				 sizeof(report));
>>>>> +	if (ret != 1)
>>>>> +		return ret;
>>>>> +
>>>>> +	if (copy_from_user(&report, arg, minsz))
>>>>> +		return -EFAULT;
>>>>> +
>>>>> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))
>>>> Why is PAGE_SIZE a factor here?  I'm under the impression that
>>>> iova_bitmap is intended to handle arbitrary page sizes.  Thanks,
>>> Arbritary page sizes ... which are powers of 2. We use page shift in iova bitmap.
>>> While it's not hard to lose this restriction (trading a shift over a slower mul)
>>> ... I am not sure it is worth supporting said use considering that there aren't
>>> non-powers of 2 page sizes right now?
>>>
>>> The PAGE_SIZE restriction might be that it's supposed to be the lowest possible page_size.
>> Sorry, I was unclear.  Size relative to PAGE_SIZE was my only question,
>> not that we shouldn't require power of 2 sizes.  We're adding device
>> level dirty tracking, where the device page size granularity might be
>> 4K on a host with a CPU 64K page size.  Maybe there's a use case for
>> that.  Given the flexibility claimed by the iova_bitmap support,
>> requiring reported page size less than system PAGE_SIZE seems
>> unjustified.  Thanks,
> +1
>
> Jason

OK

So in V5 we may come with the below as we don't really expect page size 
smaller than 4K.

if (report.page_size < SZ_4K || !is_power_of_2(report.page_size))
         return -EINVAL;

Yishai

