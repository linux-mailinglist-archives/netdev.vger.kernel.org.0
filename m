Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4518C580F33
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 10:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiGZIiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 04:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiGZIiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 04:38:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3642F66B;
        Tue, 26 Jul 2022 01:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I21pv9ahW2q6stuNhgBF6jGZc+5moTUU7cw5FDDyjzHqoyxDGI5S7TMzKlX/ArmMPDiak1zR8Qxbnqemi+xIEIktosMMs9aqx4eolRNdvzLRi2+4PRk2Zqxf48xAJuejddc6HsRVEB821SwiSUuj5ayd0Ba+SNFx6H2+2ZzFSk/g1EwveBy1o3ToGQIznXhxjEmfmTy9yLOAZLvNVwCKmWhPS+Eq+iInKC3WZRVBDIBdMxc0VDoFeQyR/S0QnXKbPWI89X91xIEfBo1cqSvb6DX6GLnaX4uyrspgQpWN6BHzO6lUQ4IW0iF9WC5ZJ5bKCzPjGkZ7aoXRhiMvLh7Ujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZPy4bw6euaAFKV24oK81/zeZu+EttybNgQ1nWYnxSc=;
 b=ZuAk1VYK7gMMa5dW+ASfod2x3EjU6NDiHTBZ+x1Opa6JbOcQ+nqB9FIwGn0KRgcRJVANylydhCcTW/hperCFhNPv1chaekgqH6eyjiM63OLAhDg7Rg4Nk0dj/Vvsn4IlE+I0rwCzQCS7/n9uBheNoKUZl2dKHVLQ+fUlM0t53oiLHat7NYI3gAcQwPNKRlQz104gyfwiW7VDRTWgo252CC4Ce5gR/rmqEttMDY1vP+MY7TBbMlvqY3g+83en5AonOayi+YviZrQTBsqlUxdtgX/h3mnQUk+WIU/qiRXAOhJ6Q3k8Xm32HRxFi5JJDrTxddkGgkQx8tKKCLfZg0rNVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZPy4bw6euaAFKV24oK81/zeZu+EttybNgQ1nWYnxSc=;
 b=b/N5VKKzliRRpCglVAqJer8K6RmETVqjoxD5N6222fuCJ+XwqvUWFdFkjdP5BbpgxIN8jyLNke+O9Vg28KeDs9QzaRemdjR1B65hb1sFFkwfZNa2JNDTq0G5erQhNrkv0vZcVtd3Qn1+gxaGfKva1s9QcWwJcJd96i/IPRnhAMIL4bhLM6vkRjHtImiKdVCo/Asa5lU1HK78/fJVyp3dgVceKfXQK8IQL5B5MgJQiR24eSSwTtvT2DbpZSWlwNL3mYsmG8FCDYvU9+9PtUaNdPcUamDOXifr7BAWUcdF1Y7YIjUBBmXrqHGHI4eWPMsvZLy5q1Xkcgaw1K6M+DGfwg==
Received: from BN9PR03CA0261.namprd03.prod.outlook.com (2603:10b6:408:ff::26)
 by DM5PR12MB1834.namprd12.prod.outlook.com (2603:10b6:3:10a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 08:38:14 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::3) by BN9PR03CA0261.outlook.office365.com
 (2603:10b6:408:ff::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Tue, 26 Jul 2022 08:38:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 08:38:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 08:37:55 +0000
Received: from [172.27.11.162] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 01:37:51 -0700
Message-ID: <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
Date:   Tue, 26 Jul 2022 11:37:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e6267fb-3e3a-4732-d835-08da6ee22e24
X-MS-TrafficTypeDiagnostic: DM5PR12MB1834:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUkzZFp0LQEqTzL2ZBI78OoduXpd70MCOyRNLRfjBAnp6OhPMF9sypEatU60nxPvpfUUch4W+s20Xs2JlXjI/dDXyPGpByNmUr77njmqChGJN7JEwH/OPKGJaHFMRLTR5EiDeoUYB27Z+GU8YyE/qDRWt9O/oX/dp9wuhMvPp27TbL9YSVXtsBO16G+5q8XIwZZ5NJhp9hePY2LQIoi50yU7Ye8ZAbICNYn4cyFFBCJEHTj69pphreQ0Lec5sU74lxz/lOlTdqqGYYi/Pw4K+sUk3ZmYX84mtsZKnK2x+1SBfRS1hwTjQ4pcmpgL2KOrZYW+4ZC0hFagvVZ6CqQSbeTf/yZIP33QQdHwA+lyrk1VqqkAoKUnUBOy1/Tj7kHepqXiIwP2T1M8fqsRVhEcJBzHaM9SgeQa+2KtkE/yuwoCQUrtRUKMRtO939tmLBsY5ifB3SI+CF+DqdrdgsKwoXdjKUL4sIZBSrsxpSb1BMqeOSpSlx45XDfwYASC2YcFSRD+bIc2Q+CRU79Dkypv6VoQtOrz0MSgO7ElTLNpz+x36IYS+l//Qom9HqKvoE6EAs/xlRrgMW3VAd7THQBg/FAuMRDDAWxjbwfz0P73e9E1EzLMYHjb7oaqvmC1fna7OZ4OEOb//VbBrMlnOISMlb1ooaBR+RO195N4OpehHP66ccCmT/r4QA8DLQQcDASc3mO0L1ubLcic84WND+TCO15+vh36+6mtyfiGKdU52Zy2Oag7xC8eHs4usijxHgibmrYFUQsKm2aFiGPa5IkRUQsPbvQ2DFHEbAATOm4s3azabzqwk/MOvgXnqXKO93SPT+UEvgPQrmV3TR3K9mxaOGZH96wjZHiLA46E+ip50Uo6rrMuZ7XCib6xA1cRu5hc
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(136003)(376002)(40470700004)(46966006)(36840700001)(82310400005)(36860700001)(86362001)(40460700003)(31696002)(356005)(81166007)(478600001)(82740400003)(8936002)(5660300002)(316002)(16576012)(110136005)(2616005)(6636002)(54906003)(70206006)(70586007)(4326008)(47076005)(426003)(336012)(107886003)(16526019)(186003)(40480700001)(83380400001)(8676002)(31686004)(41300700001)(2906002)(26005)(53546011)(36756003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 08:38:14.0458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6267fb-3e3a-4732-d835-08da6ee22e24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1834
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2022 10:30, Tian, Kevin wrote:
> <please use plain-text next time>
>
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, July 21, 2022 7:06 PM
>>>> +/*
>>>> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
>>> both 'start'/'stop' are via VFIO_DEVICE_FEATURE_SET
>> Right, we have a note for that near VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP.
>> Here it refers to the start option.
> let's make it accurate here.

OK

>
>>>> + * page_size is an input that hints what tracking granularity the device
>>>> + * should try to achieve. If the device cannot do the hinted page size then it
>>>> + * should pick the next closest page size it supports. On output the device
>>> next closest 'smaller' page size?
>> Not only, it depends on the device capabilities/support and should be a driver choice.
> 'should pick next closest" is a guideline to the driver. If user requests
> 8KB while the device supports 4KB and 16KB, which one is closest?
>
> It's probably safer to just say that it's a driver choice when the hinted page
> size cannot be set?

Yes, may rephrase in V3 accordingly.

>
>>>> +struct vfio_device_feature_dma_logging_control {
>>>> +	__aligned_u64 page_size;
>>>> +	__u32 num_ranges;
>>>> +	__u32 __reserved;
>>>> +	__aligned_u64 ranges;
>>>> +};
>>> should we move the definition of LOG_MAX_RANGES to be here
>>> so the user can know the max limits of tracked ranges?
>> This was raised as an option as part of this mail thread.
>> However, for now it seems redundant as we may not expect user space to hit this limit and it mainly comes to protect kernel from memory exploding by a malicious user.
> No matter how realistic an user might hit an limitation, it doesn't
> sound good to not expose it if existing.

As Jason replied at some point here, we need to see a clear use case for 
more than a few 10's of ranges before we complicate things.

For now we don't see one. If one does crop up someday it is easy to add 
a new query, or some other behavior.

Alex,

Can you please comment here so that we can converge and be ready for V3 ?

>>>> +
>>>> +struct vfio_device_feature_dma_logging_range {
>>>> +	__aligned_u64 iova;
>>>> +	__aligned_u64 length;
>>>> +};
>>>> +
>>>> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
>>> Can the user update the range list by doing another START?
>> No, single start to ask the device what to track and a matching single stop should follow at the end.
> let's document it then.

OK

>
> Thanks
> Kevin
>
Thanks,
Yishai

