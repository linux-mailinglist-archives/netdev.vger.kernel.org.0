Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9DD6C899F
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjCYA1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCYA11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:27:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B716317
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 17:27:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCTXBsr4HcDCFJG5EcwxA1I04QojWgVd3hLJP5Jybdce2ysav2G+g/scalB70pDJohz+kkgn3f35fDwPUz6h1q8qNwuEnJvQj8bq0AVLdUhYaxikM7Qy9t6U+EAHBCu5/wPEAHkFWHkA0o8B45U3r1oBZwoU+YsNgow6IOU0aNutwbMyAaCbZuHoUUsa9aL1lUvjiDgXFbD68frAY7qL7i5faF+CQ2GaB9e/MnqOXLRWS/YvLPbIsUBbDb+E2KEWkUVvGCnxpIq9ONxgjUz4bVQ1ioN8vBMYD+mqsCrl9jetkb8UrjKszeVadIVNc4jgJHwrNJDQWvCA20zM+FGvgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rckgyfi644cURBc6igHDGALJpycyfXjHGuur/uGkAE4=;
 b=fX/Ju0KHd0huK9VZt4I6hZWYIRw3wLj+JUWbUUEORm5lMujBxat26p6Rxjy7qLKd/U8c95N9KY5MgG1CjyBho+MtRPEBA8UQQ4MBqXEGy6gIyqOLerPs9hYlcb1vIkZYTj5cIUnb0kC1asKMJ2mf5QvlYAUBW4wgK9A+ZPKPoMpjboVk2xsZLYbFR8MEmxMEBtMeucVdShU2SOuYI7R3ryJlEHvJCejuV0cnX2F9ma1uIhms9wD9nZFosEoPgawuf/E95C/JQG/liof7tYc8AqWLHyz64E/TxsT9pBH5wVELEkrpi923aeigNpbx2oWwTkAdlZA6+R1b1AU9f5wPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rckgyfi644cURBc6igHDGALJpycyfXjHGuur/uGkAE4=;
 b=T8W2gCYfdI3mNAbdTtB3nbFh7rN7K2cFz+9yRL9T/Ni1voxzqqITmTCyHm/vrMtcIeRAOeIC92uBfJa7Xec7Ce0VRT7IfCbzScLJHQeRMV7/v9pFj+Vx8KS3jLs76OZRXbmeTNXiHlKerJLwMY0yR5kjmaQMr9pI2hvEj/QfhuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sat, 25 Mar
 2023 00:27:02 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:27:02 +0000
Message-ID: <efa1bda9-6b12-54c1-8d98-7838469cee03@amd.com>
Date:   Fri, 24 Mar 2023 17:26:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 virtio 6/8] pds_vdpa: add support for vdpa and vdpamgmt
 interfaces
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-7-shannon.nelson@amd.com>
 <CACGkMEvacgachSZK8J4zpSXAYaCBkyJrqp8_rYV7-k1O7arC7Q@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvacgachSZK8J4zpSXAYaCBkyJrqp8_rYV7-k1O7arC7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:40::15) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 7153c97c-d846-4903-ba01-08db2cc7a77c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWLEBPOMBtuvgnxM0mdK0E9zczPYVjlwANIv3dU8y9z5PiSrSLBzk1n7CqTzZr1ugEceIMgTuAgYJETJXrcNsBtkN0ISSU/Ub4ybLVKzZHNou89oY7+pXBgsZIzEGwEyBsd0FFSVm6xUFEDipba71eJw+BlanLUgLunaogwtJ5GJr4dk3hBQZHDkBS+T9K2QKGi77Aj70XpOqqlX3vxmXZQUoUyR2rT4dTQgl/jN0D5NmVPRAhkYbxkq0q5k4VgQymCe64PlHlJpLm1wna0vKFXNgt8q6BLH8kLLX021xOV2ncIFKEgOOyz6SgJGD/4IJPPWZxcx1RIJGii7TUiLTo+ZgU6KDZrr+c7UkClBFk1YL8EQsrSj1YjF4prNQbTbYJ1GR2Sp3asl/TpCuJMXbNwyr/E/6Wm0jGi77gFfsGuzCGWLjeMLIcszhOgFqgLZbOyhJHAr1Onf0gVEgCOrJyd4sMfJwX2BBwuxsMioajzCuFYS1387BqVc6SmlVcQggxwLDpqxZGg/KSluWSKYOfREKldFlUROkblXFQNokpwilWgpHAT7250Q1u91U43uiETa5PqxwUsP9r7MlWibNkG3mHFXCsgApKZw+kAKfI+hgF+f351lIyzDrJ8Jg1n4w6YxEpQld3Cum2t+LM4Wxz/N9qseXb6DDMBAISV2rraoM7aE49hfuuPHIwouSqRuIlZ9UgKQlSx5OoUIpC4gWdI144EAsRGQLgE3kRnooiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(66899021)(2616005)(2906002)(38100700002)(31686004)(5660300002)(6666004)(8676002)(4326008)(66476007)(6916009)(316002)(66556008)(41300700001)(66946007)(44832011)(6486002)(6506007)(6512007)(26005)(36756003)(53546011)(8936002)(478600001)(86362001)(31696002)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2ozRGJ2Ui9jSW03UEZCVXFVSDJuYktLdEI3eURta2FQMUZsRDVEM0FBV2JD?=
 =?utf-8?B?ZUU1YlF1dys5NXJXTVBzdjJwbGJGNzk5eW5Ocm5UejVtYTh3QTV3M2ROdWlP?=
 =?utf-8?B?eTYxK20rMUxUaENzaVpYdXp2aHRQdkZtZ2VSUHBzMy9sU3VIT0ZZNUE1RS8z?=
 =?utf-8?B?S3drZHpMZXV2YTl3bzVPN3lBdkVCREtqSUVQaWtmWFB4T1VFSWtKRjF3RzlC?=
 =?utf-8?B?MjFhbC9MS2F4WHpPbi8vcmJUUURJdWswVW1rMCswdXE1bURzelhicFd0N2h0?=
 =?utf-8?B?WXJqMk51YzU0S09USFVrZVpsNHVBeExSam1ZMG56V05ndEVVcExZTExIM0U0?=
 =?utf-8?B?L0w0TXVqczhOZ0syUjZsODBlWGJEK3VjUWdiUUdMVGNPTVM5QnJiUmZUajBS?=
 =?utf-8?B?ZXY1Y2NoNHgwSGNOZGJMTnhnZ1Y3RWtOS2pvMXdLY2dqTFhYQ3pncmJFdm4v?=
 =?utf-8?B?aGIyM2oyVWtCWVRoQ2l4Z0xaaFBBYXl3RUdVdDlJMkpZMGpjNGxjYW5ocGRJ?=
 =?utf-8?B?UDNYVW9kbGkya2ZoSHdqeEhrVWlLZkowVFpQbHpDSDVCQyt5RjJ5dmRaM01W?=
 =?utf-8?B?OHB2VU1DTjM4aWhSb2F0MWVNdkpPbm5mOThrck5SYmJEUDBLbmFrQXM2aWk0?=
 =?utf-8?B?cVl6RW52N0tmV1ZhczJoRW5uNVBZamsza3VZL0JhWUpQeEZsNlQ0QmNWa2NL?=
 =?utf-8?B?OGNMazlEZThYZ2R1bGZTK3VDU3d1MUhDbVRZTHBjb3dxTDFkV0FQb2Rpb0pp?=
 =?utf-8?B?WVRnL0NvQWYwOXRKMlNhUUJiZHY1a0FYQVVBUUJXaFdES3FTMGNzQzRPdjBx?=
 =?utf-8?B?aVBJeTdPOTdqZ0hUM3VJRS9naFA5SHdQdVBDalU3SFhrRCt0RUwyRDVxRDBk?=
 =?utf-8?B?c0dJK2RCTWNuQ2NpT05OVlRFQ3RjZnh6bUZiT2lhbHlHTFA2L3ZPNGdxSDRY?=
 =?utf-8?B?ZnR5Z2JNZlpaZ3hudWJUMVQ3SEIrNnlnaXF4cVV5Q01hR1VCb2xKc0JVNVhi?=
 =?utf-8?B?cFNiWTlMQ1czVFFjS3IxWCs5YndSNWZTV0dhSVpneXNxbjRZZThyQ1h1MTcw?=
 =?utf-8?B?TmZZZFhZeVpzdTdEOFBodjdPTGNhQzZPUFhMTWtucGZSRXN6NUltdHRZVWQr?=
 =?utf-8?B?K2xoVUJTVy91ejhxQnMybHRKS3JRa09JYldwZXhxeDJkUXJPcGNScFlOSXdm?=
 =?utf-8?B?UnhhTVltdER0bVA5aXh4d1lSNExxdmNPdFJPaklGMWVJUHhoUFhxaDRoaUww?=
 =?utf-8?B?ZjRTMWRPSVlHQ0FtVHU4cWtMM2JVNWd3Q3ZIRURSOXdzbERLT2syU0tqanhK?=
 =?utf-8?B?SE1rUGI2VldUenU2M2lXRGFpZGRBbmsvV0xvVFYrZGVRTEVNNWwveHhKbUF4?=
 =?utf-8?B?TTRieElDaTMwSi9GUTY5bDEzYjBVL21GdU1DVi9lZ2wwVGRuZzV6THlGR1ZJ?=
 =?utf-8?B?dlNzdHFlRmdDM1M5Q1QzVTFmUVdaNGZKT3hwazgwdXY4QWhJQWFNS2xMVEZG?=
 =?utf-8?B?SHpwT2pyYkNKR21LL2xGY1FEQkY5YWF1dS83UjhrSkxwNVd2amZDKytlSkNm?=
 =?utf-8?B?dGMxR1NEMVNOSU5MYit3eEJaWkpaNXhsYXZ6S2ZqYkVjVXQxZnZEa0ZGYmx0?=
 =?utf-8?B?bFFBcjZuc1VrVUNrcE12cW1EV2x0US9rV2ZqRmxKNUtHQS9VK1lLbjdoa1FF?=
 =?utf-8?B?S1NCOWwzN0FhUmxrMTBMZFZIczU3Q3N4QTdYTEhKY0ZOSkpWZVBTQW9DcUVi?=
 =?utf-8?B?cEw3Q0JHQTdEUnVWeU5DenhEdldXTityVTV1M2VseFB2VHRhdGxtQ2p6K3Np?=
 =?utf-8?B?d09qS3E2UnA4UVNMQWFyc3Uvd2RZdWs4dnFnTyt6OUhPSzhPTHlvUzYzRU9I?=
 =?utf-8?B?RndyRlVtL1hRMVlPeHYybnZMMERsNDRJelp6bm9KMkdYcEFNVHVKTXpyMGNG?=
 =?utf-8?B?c3ZPVWdLQ01GSVFnUkhIUEk4ZGRUdVk3MWkzRkxIWk5ab21nSXYrZHdWZVZ0?=
 =?utf-8?B?K3Q1NHV4YW1aNUVzd1M5SHJZVnoyRU04UlpHOGpLYXFnSTgvOHRTR202c0xO?=
 =?utf-8?B?RENWNTZmOElWWVp0cHR3YmpHazNmbVFyZzN5dG14cnpEMXh1Qml0L2RoOTdI?=
 =?utf-8?Q?DCEOI9X53/SrYKJ0cqE/cCtau?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7153c97c-d846-4903-ba01-08db2cc7a77c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:27:02.6108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/b8ukfgRhIu4fGrG7dxVz/TdUWtQfVzJzM4Bp+WzwfYTwDE/I+kI4kjU3xfzr1r8Xl/S88+NyRKe4bzgmxhFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6881
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 10:18 PM, Jason Wang wrote:
> On Thu, Mar 23, 2023 at 3:11 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> This is the vDPA device support, where we advertise that we can
>> support the virtio queues and deal with the configuration work
>> through the pds_core's adminq.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/aux_drv.c  |  15 +
>>   drivers/vdpa/pds/aux_drv.h  |   1 +
>>   drivers/vdpa/pds/debugfs.c  | 260 +++++++++++++++++
>>   drivers/vdpa/pds/debugfs.h  |  10 +
>>   drivers/vdpa/pds/vdpa_dev.c | 560 +++++++++++++++++++++++++++++++++++-
>>   5 files changed, 845 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index 8f3ae3326885..e54f0371c60e 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
> 
> [...]
> 
>> +
>> +static struct vdpa_notification_area
>> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct virtio_pci_modern_device *vd_mdev;
>> +       struct vdpa_notification_area area;
>> +
>> +       area.addr = pdsv->vqs[qid].notify_pa;
>> +
>> +       vd_mdev = &pdsv->vdpa_aux->vd_mdev;
>> +       if (!vd_mdev->notify_offset_multiplier)
>> +               area.size = PDS_PAGE_SIZE;
> 
> This hasn't been defined so far? Others look good.

Sorry, I don't understand your question.
sln


> 
> Thanks
> 
