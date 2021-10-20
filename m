Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781D2434738
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJTIse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:48:34 -0400
Received: from mail-mw2nam08on2065.outbound.protection.outlook.com ([40.107.101.65]:24385
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229817AbhJTIsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:48:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GutJqfUGROLa7HXerGQmHf2stwlthpH0nd7gshXxT5We/hOQL+3izoBZAXuFehm/awbdN3lXz6BeMVAFkDYNrxL4iexkU7VWYSOV092ohxvQsimTFmQPD05S/wLX1DjS7VziDVCqTKqW5oHewgZsnAf5aUqyGzS/dqEQgD01QMgIB6gi/XAGxXvO9Ig6vHJs4ayBq8IXiIVqPrSTlQY419cq/nNTlADHjbBHc6t1p+AV+7BakPm9XfEiOyv/8OclCoEqkiO4sV+xlU2kHxS/uODUTM5SISfsLypGTxWyxC0SFDe2YQU6b8tMUfdIpJVFAQe8xOeakvb8VVHrf56yrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpoVFvpGad/qSRnBAAmuYdWv/NhtYIOwPyMEV6WaVeg=;
 b=kWuJp1EQCw0MTTVmAYqSukUVDQMVC0bgaIpMrGYDR+v1y2QnuG7gyQVJEgYJvwzkYMc5Mh0/N+MRPHyRm4aBAHr4UICORJrZFQ09GpNyVoYMQBzcfSx5fxZdDRnf7Vycv8vWjIuqnWtRWh7Dp+9D8QN53CSY8+ZKcvY0vTwXDdJE6AixR+7uO/c/HnHqc5cEm5ve+qSLiMtWY1/vtx2EQjTfe4YyIlrFIDSIty2S8EWpUyvwuB7wfAg6Vl2PIYjNBHtLkcTt0xBTrl19TmIuhom7hllryKPh9CcSgIN2SQCPK7BBQDEz+hb6bIoXHz+sZJO1OnJ0FM2MBT4sEuTwjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpoVFvpGad/qSRnBAAmuYdWv/NhtYIOwPyMEV6WaVeg=;
 b=XKXmYm4tb/G+pQPhk3vkEK30tpluQL9KinkK4Ctt4JzmW+prYGWjz4XZUExS1u0DDDKsn6bEVk2MvOF0xTIvV1S2SFYnVNZns3ftKwaPSeXTNqFnhy5+2GloWyHB5Kjv1vPLW7gWMZlQiUzHcXV22ABCI4yOk1S6DqOrptrvxXItK9DDPdekGpo0yTr/U+xsRuh3/4o60TRMNko327b7Nie0PmvygQuMvQo70ib8JT7JnJELxNV73loVpHrCi0VHwuGlI7UhTe9N2fT8HTTjImVxIM3K6sfd6fc2aBRsod565WJoZ/6B8QahViF84G0mXgg9S8CgFOY/3Pyy5mzNLA==
Received: from BN9PR03CA0384.namprd03.prod.outlook.com (2603:10b6:408:f7::29)
 by DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 08:46:16 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::60) by BN9PR03CA0384.outlook.office365.com
 (2603:10b6:408:f7::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Wed, 20 Oct 2021 08:46:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 08:46:14 +0000
Received: from [172.27.15.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 08:46:10 +0000
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done
 error handler
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-15-yishaih@nvidia.com>
 <20211019125513.4e522af9.alex.williamson@redhat.com>
 <20211019191025.GA4072278@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
Date:   Wed, 20 Oct 2021 11:46:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019191025.GA4072278@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4ae3c05-459a-4f9e-ff25-08d993a613cd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4862:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4862BC621CE9B0CDFE1481E8C3BE9@DM6PR12MB4862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwIp59C1AzSE31H3t1Znpj8DsxxxNORbQERO5Y0FX4MkfWykpdoDztxJnSL/K1Pj0FBZzq1wTo/SPno/ixW6w8uxupygHJlxCsfoJci1jVabqIgfcxlp7dNyB1EJN0qeHFS1hZqIq+1HAEq8FCk4fM80L1CrXOKrUTCM03MzrQwaGblxhHY1T8Z1Ykf2Mff7BzyzDjKr8PDU4A1/8i0ZGLCfBqhUx2pyvtq94duxaTIgc/ir9biA8242j9ZM2f6xURX0uqqeurSfnNdcnxEydw6/laVjTWCeIQaAJa5DkG4jJpowY4H0KJzX6gkyhbgGPdnitu+nV2HsxUBUcWsg/LnPWX4L7LszmVRa2hTa18njIrPVvhdstDXF8wQT5Iti2b5swgHqm2hVjPM8dpXYuWkvftNmnWD30/g7XcjGkQbgybNxLLlNYKv1KjeUZPoxIm5opKMToiOoiCiT/Lf4Q6VrMDs79ST1UYq6C2ajxRheTB5NiVzaw+iOoH/0W0IqOSMJuSLwQ6ugNExE44tYL/0NPu5itQ3exDHzeA5UdsAk1jXRXG+NgzCTUMyWEXyRDOo7/NCEOsWVlH61XPDdL/F3aYsB11hFlvLRsIQ8F1z6RAz/bP+0SNQ+JEGRH0zBjZOt2XyHtkLzJ6sIcQqM0foDN0Jyx/Wie6hsCRLIvOQWhh8lJDlcaT5be08v0Tlp8WNJOBSTV1CbpOpLH2WHjveSS94i2E66FNYj82ysTIrh5+R0kl6DJkRnREgFN+1qIPq23Y2pBmiLQcrfkw0PjLhT85YlzFXol+gjF+duO7GGi6TLQRyo5lxbqLLlL210
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(36860700001)(53546011)(107886003)(426003)(31686004)(7636003)(2906002)(5660300002)(31696002)(70206006)(54906003)(2616005)(508600001)(6666004)(70586007)(316002)(86362001)(966005)(8676002)(26005)(8936002)(186003)(110136005)(336012)(82310400003)(36756003)(4326008)(16576012)(356005)(47076005)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:46:14.9830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ae3c05-459a-4f9e-ff25-08d993a613cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 10:10 PM, Jason Gunthorpe wrote:
> On Tue, Oct 19, 2021 at 12:55:13PM -0600, Alex Williamson wrote:
>
>>> +static void mlx5vf_reset_work_handler(struct work_struct *work)
>>> +{
>>> +	struct mlx5vf_pci_core_device *mvdev =
>>> +		container_of(work, struct mlx5vf_pci_core_device, work);
>>> +
>>> +	mutex_lock(&mvdev->state_mutex);
>>> +	mlx5vf_reset_mig_state(mvdev);
>> I see this calls mlx5vf_reset_vhca_state() but how does that unfreeze
>> and unquiesce the device as necessary to get back to _RUNNING?
> FLR of the function does it.
>
> Same flow as if userspace attaches the vfio migration, freezes the
> device then closes the FD. The FLR puts everything in the device right
> and the next open will see a functional, unfrozen, blank device.


Right

>
>>> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
>>> +	mutex_unlock(&mvdev->state_mutex);
>>> +}
>>> +
>>> +static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
>>> +{
>>> +	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>>> +
>>> +	if (!mvdev->migrate_cap)
>>> +		return;
>>> +
>>> +	schedule_work(&mvdev->work);
>> This seems troublesome, how long does userspace poll the device state
>> after reset to get back to _RUNNING?  Seems we at least need a
>> flush_work() call when userspace reads the device state.  Thanks,
> The locking is very troubled here because the higher VFIO layers are
> holding locks across reset and using those same locks with the mm_lock
>
> The delay is a good point :(


What is the expectation for a reasonable delay ? we may expect this 
system WQ to run only short tasks and be very responsive.

See 
https://elixir.bootlin.com/linux/v5.15-rc6/source/include/linux/workqueue.h#L355

>
> The other algorithm that can rescue this is to defer the cleanup work
> to the mutex unlock, which ever context happens to get to it:
>
> reset_done:
>     spin_lock(spin)
>     defered_reset = true;
>     if (!mutex_trylock(&state_mutex))
>        spin_unlock(spin)
>        return
>     spin_unlock(spin)
>
>     state_mutex_unlock()
>
> state_mutex_unlock:
>   again:
>     spin_lock(spin)
>     if (defered_reset)
>        spin_unlock()
>        do_post_reset;
>        goto again;
>     mutex_unlock(state_mutex);
>     spin_unlock()
>
> and call state_mutex_unlock() in all unlock cases.
>
> It is a much more complicated algorithm than the work.


Right, it seems much more complicated compared to current code..

In addition, need to get into the details of the above algorithm, not 
sure that I got all of them ..

>
> Yishai this should also have had a comment explaining why this is
> needed as nobody is going to guess a ABBA deadlock on mm_lock is the
> reason.

Sure, this can be done.

Are we fine to start/stay with current simple approach that I wrote and 
tested so far ?

Yishai

