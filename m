Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F63431CD9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhJRNpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:45:41 -0400
Received: from mail-bn8nam08on2052.outbound.protection.outlook.com ([40.107.100.52]:52961
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233985AbhJRNnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbSEwGCi9l2AdssROxWwgQieYLlXTn8/+vIN0SzThBiutTyeDnHV8mgr/uDVgqlTx9hsN2n7oXfc4QJj9NTMktB19awg4xk0/lGYTd8YZcLQQnEJhor958rSB/hVoPuyJsH+w7IXOQJJVFO/Me486m4YIFYH93mQkCuSL8u+D6Jb+BO7KrL8wSqRq68sJr6jBP7zemaYfsjU1FO3Iw0Gb1jtMlyErBL8G1zhbSfwJ+HED+H4BoVQX67d1pXDFjgYrV3bInwf4LiHzaEY6Tn0QdEaT16liM/j5ZTxo4bVZLo7x8wcUmjdlBR3Lh89B2YnAtddTHN7BIWluWsXyEEwew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZRaz6ciJ/JL3Zs9yVmytud2xPFip6iO2z7XQUDYv5o=;
 b=MZ9oV1hNB/M9PGQnZq07IKY4UByDc4FC/ShQD6ioN/kCnDG4qbwIf57zsyiizmYybxm+vE1MCKHRBRbtX0Ee643eppd9D+K8AuH6Req8ZE+xQExwN00Z94jkam+QoiIx3e94T3a75Q+Y8Q+Cz6HucFAQNpkJwkFScoPJ1DbWKAkAar163O+bIMNB3OEmsMr5RG95ht9bNnXc/v+kHvjMtkCcJSm4WcHcvO4NDL08hs+QYYabW2Uw+5Q8uCQIcanVa8ZdahO4XfiSkZNaipzY+1UKgU6M82EjZZL4q5plXj3+Vbn8Ds8cDCLDlEZsyj8uGb1kFfs+XId3hFiJi/23BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZRaz6ciJ/JL3Zs9yVmytud2xPFip6iO2z7XQUDYv5o=;
 b=PAykCVvx7+RLuJafqhbC4heLDhnMo6LZ10o+a3Qp/Rvzleu8CncqdgIfNjkn5RGeHoe8NE1u0pIiqM7PcnomccgqrMMOOif0Wd7PL0HBb9su9Qu0UzI3lNfLTd5mJBzZyzgJ1RT6DZlpiQYXmfGZ1Wg0vUuoooRkqXjSUFNgc1NlwtWj7ZUBwQTgnB//JvEO//d55EsZ2WfDJV4AMM8nYIe2jlIPLhcwv5y4jNScLk1eb5GpOSZF93X6xTPFh4youdAACrVAjpS7FH/5kCFgnDDH7tccw4190H6h4GnvZW81Nqa5+MXfCdZzjFrd2pRMNYmFSvZMsG8HoQjv7D5fPA==
Received: from CO2PR04CA0082.namprd04.prod.outlook.com (2603:10b6:102:1::50)
 by SJ0PR12MB5501.namprd12.prod.outlook.com (2603:10b6:a03:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 13:41:26 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::a6) by CO2PR04CA0082.outlook.office365.com
 (2603:10b6:102:1::50) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Mon, 18 Oct 2021 13:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 13:41:26 +0000
Received: from [172.27.14.240] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 18 Oct
 2021 13:41:12 +0000
Subject: Re: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let
 vfio_pci_core drivers trap device RESET
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-13-yishaih@nvidia.com>
 <20211015135237.759fe688.alex.williamson@redhat.com>
 <20211015200328.GG2744544@nvidia.com>
 <20211015151243.3c5b0910.alex.williamson@redhat.com>
 <d91f729b-d547-406f-353f-04627d4e555c@nvidia.com>
 <20211018120234.GN2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <abc3aead-8f81-8c9c-c071-d22119aeac5f@nvidia.com>
Date:   Mon, 18 Oct 2021 16:41:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018120234.GN2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17af3fe9-4817-4a48-182b-08d9923cfbab
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5501:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5501284F5635E6A5DDD37D5EC3BC9@SJ0PR12MB5501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yxW5B7JFjrhTSVC87nhnP4Tov7eK5bQ4zSj88d+080KNeur1D+Hzp4A4lTnbqPlGr0DkzII7qYZ1BVOCXmgXTeDQRWCtu7h2vlKDRLM3wnrP3BjDtoTxArwEnXxYnU0jsjYO2qJ7lGq0U/vm0Tr3QtGyK/qas8DxMIN2Y5mz7QUIBVOw2bgJd2qD6lEL5PnVbjuEUzaO3bnRbzPpQlRXEI5v3fEcl+3WoLEYcQt6rCUZXAvUdfU5rwulBKSCYrSpadMUK7eat6CgcR+iAz8oOeoAqsFh3CQE9IG7FZAMbq3bvkXHgpH0I64+iMcZlJUXjPq7OeNExnpH9XpLf6+/estj6L1oW8ApBG+ARWXze2E0qGdBjLJyTNCW45C+6FkUlWvNE0i5qdHalfEmW0qGoUq0ICUEOh6lqv04LZOkqW5XsNQFCoxAw+lx32aRWRDj5AXV6yOKXEirIQesR/uNxqa9ml+/XuDxHhcFMqXK6tdU1h5GyF/BGZw1+56rZ5ZdoWhmTZYSft8RQy5sreXgWZnL9Q9as8kr85ZjG8QircjWjqTdauJYS5CuU5k4ywG6HKxcfjLBy4JaPJXnoQqqz7ZFzHebM8IQciWqei90mzx98bHJW8JkMtFjrzSEE9KQpIZF7DH6RI5oFsfT+dwSJOjzqeJdIha6gfDBusUh82irMbpiQ/nDgMeLEevkR7axKZDaKHLQH3NMKwj67WuQFSmbO0UbiBVH9je7v3MO5ho=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(53546011)(8676002)(107886003)(6862004)(6666004)(508600001)(82310400003)(70586007)(8936002)(70206006)(16526019)(6636002)(2906002)(83380400001)(26005)(316002)(356005)(2616005)(186003)(31686004)(336012)(7636003)(5660300002)(37006003)(47076005)(426003)(31696002)(36756003)(36860700001)(16576012)(36906005)(54906003)(86362001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:41:26.6524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17af3fe9-4817-4a48-182b-08d9923cfbab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2021 3:02 PM, Jason Gunthorpe wrote:
> On Sun, Oct 17, 2021 at 05:29:39PM +0300, Yishai Hadas wrote:
>> On 10/16/2021 12:12 AM, Alex Williamson wrote:
>>> On Fri, 15 Oct 2021 17:03:28 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> On Fri, Oct 15, 2021 at 01:52:37PM -0600, Alex Williamson wrote:
>>>>> On Wed, 13 Oct 2021 12:47:06 +0300
>>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>>> Add infrastructure to let vfio_pci_core drivers trap device RESET.
>>>>>>
>>>>>> The motivation for this is to let the underlay driver be aware that
>>>>>> reset was done and set its internal state accordingly.
>>>>> I think the intention of the uAPI here is that the migration error
>>>>> state is exited specifically via the reset ioctl.  Maybe that should be
>>>>> made more clear, but variant drivers can already wrap the core ioctl
>>>>> for the purpose of determining that mechanism of reset has occurred.
>>>> It is not just recovering the error state.
>>>>
>>>> Any transition to reset changes the firmware state. Eg if userspace
>>>> uses one of the other emulation paths to trigger the reset after
>>>> putting the device off running then the driver state and FW state
>>>> become desynchronized.
>>>>
>>>> So all the reset paths need to be synchronized some how, either
>>>> blocked while in non-running states or aligning the SW state with the
>>>> new post-reset FW state.
>>> This only catches the two flavors of FLR and the RESET ioctl itself, so
>>> we've got gaps relative to "all the reset paths" anyway.  I'm also
>>> concerned about adding arbitrary callbacks for every case that it gets
>>> too cumbersome to write a wrapper for the existing callbacks.
>>>
>>> However, why is this a vfio thing when we have the
>>> pci_error_handlers.reset_done callback.  At best this ought to be
>>> redundant to that.  Thanks,
>>>
>>> Alex
>>>
>> Alex,
>>
>> How about the below patch instead ?
>>
>> This will centralize the 'reset_done' notifications for drivers to one place
>> (i.e. pci_error_handlers.reset_done)  and may close the gap that you pointed
>> on.
>>
>> I just followed the logic in vfio_pci_aer_err_detected() from usage and
>> locking point of view.
>>
>> Do we really need to take the &vdev->igate mutex as was done there ?
>>
>> The next patch from the series in mlx5 will stay as of in V1, it may just
>> set its ops and be called upon PCI 'reset_done'.
>>
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index e581a327f90d..20bf37c00fb6 100644
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1925,6 +1925,27 @@ static pci_ers_result_t
>> vfio_pci_aer_err_detected(struct pci_dev *pdev,
>>          return PCI_ERS_RESULT_CAN_RECOVER;
>>   }
>>
>> +static void vfio_pci_aer_err_reset_done(struct pci_dev *pdev)
>> +{
>> +       struct vfio_pci_core_device *vdev;
>> +       struct vfio_device *device;
>> +
>> +       device = vfio_device_get_from_dev(&pdev->dev);
>> +       if (device == NULL)
>> +               return;
> Do not add new vfio_device_get_from_dev() calls, this should extract
> it from the pci_get_drvdata.
>
>> +
>> +       vdev = container_of(device, struct vfio_pci_core_device, vdev);
>> +
>> +       mutex_lock(&vdev->igate);
>> +       if (vdev->ops && vdev->ops->reset_done)
>> +               vdev->ops->reset_done(vdev);
>> +       mutex_unlock(&vdev->igate);
>> +
>> +       vfio_device_put(device);
>> +
>> +       return;
>> +}
>> +
>>   int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>>   {
>>          struct vfio_device *device;
>> @@ -1947,6 +1968,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
>>
>>   const struct pci_error_handlers vfio_pci_core_err_handlers = {
>>          .error_detected = vfio_pci_aer_err_detected,
>> +       .reset_done = vfio_pci_aer_err_reset_done,
>>   };
>>   EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
> Most likely mlx5vf should just implement a pci_error_handlers struct
> and install vfio_pci_aer_err_detected in it.
>
> Jason

This can work as well.

It may cleanup the need to set an extra ops on vfio_pci_core_device, the 
reset will go directly to the mlx5 driver.

I plan to follow that in coming V2.

Yishai

