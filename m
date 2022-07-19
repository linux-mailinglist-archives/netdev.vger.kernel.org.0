Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006FF57948A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiGSHt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiGSHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:49:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DEC23BF8;
        Tue, 19 Jul 2022 00:49:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7rl8VIbkveBwGKt4fN1RrLPFDUnfAhs3wJWd3fx3Qn82ZAkXkymWCoACeQ5JwGBL0w2chstnGWcxDnrl4Z1G0R4VgMXIAztKV6VpgZ5Tfw3KdbyggMojnhiH2MqHsQsvVFxxGbnjIlAqRpVE1OWCZq5fqETr43rQlSw/Cx+ALOiniV5kUTjXjDcZzoSJ2coVzkyaWDJFgxkUIR4E9q7qb8Z1Vy0lHtW7aslgridLVzB8Ttz7xtBVm7SsWUaTVEBUVo86ntcjHyD8vjAzsdl6YkYZf2RA60n91nXFza/qQolvf7GfFRYk9Ex5biir2vfzpL4wxaRnUlzpI0EhMBTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ixP9O15KXkCs+L4uNYcqeuybvnq6roYFfqTBtumzZg=;
 b=Ih8hKJ6z5E4q90aGcy68foUKhSK1i48tLNkPMOuQqJx37nXDvdGJjZSmW2Vk9X141isj/OWg2K+csgEKQZBzSXj1EuEk/k6r3QRP6BStjHJLvIJe3/xPCBfLkRr/V1aKKFos0eEPoS0G4Zzm3aSuvazNPQCGl0/IUyW7UQMpuAilMN34ascSf8e/CVH8ymRuEW8vOYm6F5azihjNwQdCc5AzmQDzO9eXQDnQ+z7N0TtFCOM35GQ5hk3wYwbs6q+uASiOL64BaCJ5QCq02cOLvhf7ZcJorB9awKRcXmN1DLdwNoY/SylVYZYSWFa/IKHGfSOiKlMBIFBcSuCGhC4ZjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ixP9O15KXkCs+L4uNYcqeuybvnq6roYFfqTBtumzZg=;
 b=AzraYyPqiEN8pKYOGPoqfotqklJxAzqE2UErQH8CkzWsoQxVFlMcSHWW65dE0GkCgPNWQGIQE2eJxtPfHjKQ+sRiKHJi2+U93lGYZb0cZ2Bc9itosBzYW0MRiR+URMBVXMxdkcHVSa8OWJvf15AgzS3qBK5xB424c42GFRu+6XzBYYyNRjFbzy/SNpl6KXBKpjkk85CyiTHYHdeiGOzL+twBGt+B7gCYY3yxT7ff4DvHnfNWNis8T4/Rl2LsGv3EEOty+jhLYQTNxoe/eKzqigbOThmpq1R3zSszlJhsLpBjyygQyxH4554MIS1lP86gjhhy0+oOaAQ1WBdU2Ilavg==
Received: from BN9PR03CA0667.namprd03.prod.outlook.com (2603:10b6:408:10e::12)
 by DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Tue, 19 Jul 2022 07:49:51 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::5) by BN9PR03CA0667.outlook.office365.com
 (2603:10b6:408:10e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Tue, 19 Jul 2022 07:49:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 07:49:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Jul
 2022 07:49:50 +0000
Received: from [172.27.15.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 19 Jul
 2022 00:49:45 -0700
Message-ID: <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
Date:   Tue, 19 Jul 2022 10:49:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <20220718162957.45ac2a0b.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220718162957.45ac2a0b.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c46272ea-3d69-48a8-92b4-08da695b42d1
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZi9QMW7SKIKjwcqDlKiBdOpQxZ90/yRHCkO0Wrht5X31pR+G+W6MhjuJv6Y0jdQWQU5gzigtSYlrbdTd9zpv4mhHQDl1sT2YOAoj53LTwEjnt46VFJZfCC5U0vTBMVxM9hvmpJFLYIAedWE2zcJXmOnLT9FZ2VAtrB/Zub6dduLabn9tmOu6CzgDniskTtk6jkSNLPgfdPLlf/FJkggKzjW92SjdwKMbm1qRBXS4w1KNG4lhn3CdGjHcz6pcB94Wc29z9/iufSN66ys5SACtcWb66D5TxtgkcodlMNQZeX1owWiwkYXpN6oXdfqeIF9vl07totCJZ4Tgewz966PM2bcS/49DUe4IREO6zZUUJplbyWoBwTnHsVpV5Ub1HR60W6VebHJy++UVx66esgz6hrGCMymcs+3qU2eO5Utk8PcGAKBko9NDiSFgckXjKe+8TmbeQtZHAn+CTM8LnMlDOXIymKAS/DUGlJG79TOT9kLv5EwUL4Lp4uin4gChddkAYH8ZI5ZA/8YFmjFTlIYD5A/frIXIjgX/pBA6QFKTAxECUYX/L2N3jTY3QTrSMSPiBwljqN2c2c46/J7zocsJR5sXJOr5XKi8Z1T4QpjFt0gndDFf39J9yyplPeaPIYgh4GOzFsloTndD0cMmKiW9BLT2s/Zb4F7jMJMHGW9nwKyWlYhnuBSnurqRuGPZbRZSclMoZaTI72EIYoe12AUx34GaVrSltfAcca47AEEYo/Hs1E4S0zHQs6JoShicxEsLtZdVKaGKw0DxW77JDJAUxaGawjqLHZ4x1Fi6tmB1T3qjhcxdjFOpSwiQUS/hCBU5YYVKugHkE0xjfJwiwfpuR2XyzQQWrFkZ3ZpZua7fVqwyD7XPWyQ9swiA7MGmGFf
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(8936002)(5660300002)(70586007)(70206006)(8676002)(4326008)(82310400005)(40460700003)(40480700001)(36756003)(2906002)(36860700001)(6916009)(356005)(82740400003)(478600001)(426003)(336012)(31686004)(54906003)(16576012)(41300700001)(6666004)(316002)(81166007)(107886003)(53546011)(47076005)(16526019)(186003)(26005)(83380400001)(2616005)(31696002)(86362001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 07:49:50.8599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c46272ea-3d69-48a8-92b4-08da695b42d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5398
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 1:29, Alex Williamson wrote:
> On Thu, 14 Jul 2022 11:12:43 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> DMA logging allows a device to internally record what DMAs the device is
>> initiating and report them back to userspace. It is part of the VFIO
>> migration infrastructure that allows implementing dirty page tracking
>> during the pre copy phase of live migration. Only DMA WRITEs are logged,
>> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
>>
>> This patch introduces the DMA logging involved uAPIs.
>>
>> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
>>
>> It exposes a PROBE option to detect if the device supports DMA logging.
>> It exposes a SET option to start device DMA logging in given IOVAs
>> ranges.
>> It exposes a SET option to stop device DMA logging that was previously
>> started.
>> It exposes a GET option to read back and clear the device DMA log.
>>
>> Extra details exist as part of vfio.h per a specific option.
>
> Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
> potentially other devices that might make use of this or is everyone
> else waiting for IOMMU based dirty tracking?
>
>   
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
>>   include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 79 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 733a1cddde30..81475c3e7c92 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
>>   	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>   };
>>   
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
>> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
>> + * DMA logging.
>> + *
>> + * DMA logging allows a device to internally record what DMAs the device is
>> + * initiating and report them back to userspace. It is part of the VFIO
>> + * migration infrastructure that allows implementing dirty page tracking
>> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
>> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
>> + *
>> + * When DMA logging is started a range of IOVAs to monitor is provided and the
>> + * device can optimize its logging to cover only the IOVA range given. Each
>> + * DMA that the device initiates inside the range will be logged by the device
>> + * for later retrieval.
>> + *
>> + * page_size is an input that hints what tracking granularity the device
>> + * should try to achieve. If the device cannot do the hinted page size then it
>> + * should pick the next closest page size it supports. On output the device
>> + * will return the page size it selected.
>> + *
>> + * ranges is a pointer to an array of
>> + * struct vfio_device_feature_dma_logging_range.
>> + */
>> +struct vfio_device_feature_dma_logging_control {
>> +	__aligned_u64 page_size;
>> +	__u32 num_ranges;
>> +	__u32 __reserved;
>> +	__aligned_u64 ranges;
>> +};
>> +
>> +struct vfio_device_feature_dma_logging_range {
>> +	__aligned_u64 iova;
>> +	__aligned_u64 length;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
>> +
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
>> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
>> + */
>> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
>> +
>> +/*
>> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
>> + *
>> + * Query the device's DMA log for written pages within the given IOVA range.
>> + * During querying the log is cleared for the IOVA range.
>> + *
>> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
>> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
>> + * is given by:
>> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
>> + *
>> + * The input page_size can be any power of two value and does not have to
>> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
>> + * will format its internal logging to match the reporting page size, possibly
>> + * by replicating bits if the internal page size is lower than requested.
>> + *
>> + * Bits will be updated in bitmap using atomic or to allow userspace to
>> + * combine bitmaps from multiple trackers together. Therefore userspace must
>> + * zero the bitmap before doing any reports.
> Somewhat confusing, perhaps "between report sets"?

The idea was that the driver just turns on its own dirty bits and 
doesn't touch others.

Do you suggest the below ?

"Therefore userspace must zero the bitmap between report sets".

>
>> + *
>> + * If any error is returned userspace should assume that the dirty log is
>> + * corrupted and restart.
> Restart what?  The user can't just zero the bitmap and retry, dirty
> information at the device has been lost.

Right

>   Are we suggesting they stop
> DMA logging and restart it, which sounds a lot like failing a migration
> and starting over.  Or could the user gratuitously mark the bitmap
> fully dirty and a subsequent logging report iteration might work?
> Thanks,
>
> Alex

An error at that step is not expected and might be fatal.

User space can consider marking all as dirty and continue with that 
approach for next iterations, maybe even without calling the driver.

Alternatively, user space can abort the migration and retry later on.

We can come with some rephrasing as of the above.

What do you think ?

Yishai

>> + *
>> + * If DMA logging is not enabled, an error will be returned.
>> + *
>> + */
>> +struct vfio_device_feature_dma_logging_report {
>> +	__aligned_u64 iova;
>> +	__aligned_u64 length;
>> +	__aligned_u64 page_size;
>> +	__aligned_u64 bitmap;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
>> +
>>   /* -------- API for Type1 VFIO IOMMU -------- */
>>   
>>   /**


