Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073A6435FA1
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJUKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:49:02 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:4449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230422AbhJUKsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 06:48:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWIn7nd4z0tF2+0pRgz0gKi9PUrP04dbFfkfh79pR6BSxPHvaAJgKZ9axFgSn+Zc2QB6PrWPTANpvMfjoB8kuuMpC59Dgy6TlS4uU47qvsfdcXPUb/63NKjc/F3QfcRrJ0voe/9VDkmI10VSQI4TVE0ByDpcTh9F1WhM0lvxUtY3p8HjNmTASk3jnlZP+FrSazxKmrf3QogkIiSItls2OwYxRPtohLK6eIgTEOc873dpUz50eo/TQhDxez4gdseAUmz5Esuu66Hhi+LmFJ5Cq52pbrVquo5kRmoFPWnEJLQ3/2IZcVv0SL/eF3bpDgdfG6VUe/yAmtkbAfhw13Ra6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahcrlbcOauHdXLNZxbofzqs414V5qW5+9ShyONRoAY8=;
 b=RSnPhrOUMznys3JSxUtD8i0DzcmdcOg3ICPNOEZ7vtVP+s4u7voawADYT9kIbP/M9Ca+wYFBzzRS1b1dSXP36Y1vU3wesXRLCgjG1g+Ta8nvJ07pVwEtjQho2wVua4OyaX7Ohr+jnpYDiB05QfnjHs84r7fxbjsa0OPL8iOayDleoFnRBexY1YETCe7ll7cuvy4oh0iEzByyVHExVjEIZ2YmT9+vSsSVbfU/nnOxfFqyiaBhagq9d6ihaFkCMugLy+cM9avgRVg7JwHy3r4f5b9aZsK2zXzzSPfayUUeWrf/UtdXMXtf5EqCWE0irfnjLXQayp8IoGFA0fQylU5A6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahcrlbcOauHdXLNZxbofzqs414V5qW5+9ShyONRoAY8=;
 b=i+dG3lA+OAjLh1sUl9MRogwO1zmZpw2DKr9UGiBMbJqeBbsSjAJ2+gEoBKONL3SBA9lrOz0tgK7p3kZr8IJs3vuYDZ5xZiHncQWDg0YN2gY0wiAVqeGwdT8/A1PLHchSfRXG7ePvuKstRMoLLoQzmjD7jLDzWF6zglw7ckr+3Ct8+12ng8RRXpm9vifuEXO1FdSiUnfedmByCMGyVILhNjRE32n91BQZSvO8wjRrZQwlKWu50WjEGUOtZROnwLIruObl1dxy8E5iBw0eamlDROBzHoBPrHFpio8defRikcfohsku70MSFX4pFlUx9NUbaRrKiVejVjaItt100bypGg==
Received: from BN0PR03CA0042.namprd03.prod.outlook.com (2603:10b6:408:e7::17)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 10:46:34 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::9d) by BN0PR03CA0042.outlook.office365.com
 (2603:10b6:408:e7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Thu, 21 Oct 2021 10:46:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 10:46:31 +0000
Received: from [172.27.15.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 10:46:26 +0000
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <d5ba3528-22db-e06b-80bb-0db40a71e67a@nvidia.com>
 <20211020162557.GF2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <95de8964-af56-7ce0-d79b-20d9f75a292d@nvidia.com>
Date:   Thu, 21 Oct 2021 13:46:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211020162557.GF2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70348cf1-1123-4839-3085-08d994800b57
X-MS-TrafficTypeDiagnostic: BL1PR12MB5288:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52888FE0F6EB428F804BBF00C3BF9@BL1PR12MB5288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8ZiMqvkN+xMSm2DhkJFxJ4MmM9gymNGtKbw6FPa0oXadwk3mVI5frtL5FKPPkmWO3SE7NeAC4PP+m6LteITddGuJn9IDJ/Qu2lRFX8I26cl9EWvLKzLLpa/B8hsYdVfGjxVrHxMuMNe+7NAKq+mIm1EVT63mpqYsV7SeRrUbw8k5JeqTkB1F7JXAuk9vLhMLAX8mEOzMtjoblRKRFfafOXU9xLTy98nD5WFoYsgMLUns0bCGC00OVwtE8gjySEjGZwIALsEsXH0tqaUZi3Wk2qpKz7lnICWfWqWRFJn67F4XCXUBx79+N650jyt0Lvr9QaaI1T7hNnyj7Euz9YNyiB0Iv2j98MoE3vWrRelTG3WKeEpfZqtkcHSOr87YL+XlOE2SxiSNzxZEMvsWwQlVZjOXsWUrStoWsPwHHbEfrsLCD7GorVjQs5RfACN3qY99lSmSVYs6ASMNipPjjTmHPdroUWjhLhenh6a5jYkoWGC4W19PLPGeRRgTNpdHUtvKOU4u1RKvZEFgEzxrHWikQncM52JKJUY667f86DCQU3wa+kx8EGNKn9cnslURWkvReNOSWrnqMCkklJdoAkDh9yvlVqnCpAgJKOPYjwXxTlBh2uwVL3d7Qy2RsTugLfTINgPjcHpSZxa6jfflf0KZ4XhmWOSWN4Dot0CDw69drUZHml/Zs/3h+Npxz+lMvZeQM5VQbRSAqlVe4+ejrCYZYaqRxEmkKjCcB4e2Ehj7FU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(36860700001)(82310400003)(26005)(31696002)(2906002)(8936002)(31686004)(86362001)(53546011)(36756003)(5660300002)(8676002)(356005)(2616005)(47076005)(6636002)(70586007)(336012)(54906003)(37006003)(6666004)(70206006)(6862004)(107886003)(83380400001)(316002)(4326008)(426003)(16576012)(7636003)(508600001)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 10:46:31.1717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70348cf1-1123-4839-3085-08d994800b57
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/2021 7:25 PM, Jason Gunthorpe wrote:
> On Wed, Oct 20, 2021 at 11:01:01AM +0300, Yishai Hadas wrote:
>> On 10/19/2021 9:43 PM, Alex Williamson wrote:
>>>> +
>>>> +	/* Resuming switches off */
>>>> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
>>>> +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
>>>> +		/* deserialize state into the device */
>>>> +		ret = mlx5vf_load_state(mvdev);
>>>> +		if (ret) {
>>>> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
>>>> +			return ret;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	/* Resuming switches on */
>>>> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
>>>> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
>>>> +		mlx5vf_reset_mig_state(mvdev);
>>>> +		ret = mlx5vf_pci_new_write_window(mvdev);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>> A couple nits here...
>>>
>>> Perhaps:
>>>
>>> 	if ((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING)) {
>>> 		/* Resuming bit cleared */
>>> 		if (old_state & VFIO_DEVICE_STATE_RESUMING) {
>>> 			...
>>> 		} else { /* Resuming bit set */
>>> 			...
>>> 		}
>>> 	}
>> I tried to avoid nested 'if's as of some previous notes.
> The layout of the if blocks must follow a logical progression of
> the actions toward the chip:
>
>   start precopy tracking
>   quiesce
>   freeze
>   stop precopy tracking
>   save state to buffer
>   clear state buffer
>   load state from buffer
>   unfreeze
>   unquiesce
>
> The order of the if blocks sets the precendence of the requested
> actions, because the bit-field view means userspace can request
> multiple actions concurrently.
>
> When adding the precopy actions into the above list we can see that
> the current patches ordering is backwards, save/load should be
> swapped.
>
> Idiomatically each action needs a single edge triggred predicate
> listed in the right order.
>
> The predicates we define here will become the true ABI for qemu to
> follow to operate the HW
>
> Also, the ordering of the predicates influences what usable state
> transitions exist.
>
> So, it is really important to get this right.
>
>> I run QEMU with 'x-pre-copy-dirty-page-tracking=off' as current driver
>> doesn't support dirty-pages.
>>
>> As so, it seems that this flow wasn't triggered by QEMU in my save/load
>> test.
>>
>>> It seems like there also needs to be a clause in the case where
>>> _RUNNING switches off to test if _SAVING is already set and has not
>>> toggled.
>>>
>> This can be achieved by adding the below to current code, this assumes that
>> we are fine with nested 'if's coding.
> Like this:
>
> if ((flipped_bits & (RUNNING | SAVING)) &&
>       ((old_state & (RUNNING | SAVING)) == (RUNNING|SAVING))
>      /* enter pre-copy state */
>
> if ((flipped_bits & (RUNNING | SAVING)) &&
>       ((old_state & (RUNNING | SAVING)) != (RUNNING|SAVING))
>      /* exit pre-copy state */
>
> if ((flipped_bits & (RUNNING | SAVING)) &&
>       ((old_state & (RUNNING | SAVING)) == SAVING))
>      mlx5vf_pci_save_device_data()
>
> Jason

OK, V3 will follow that.

Note: In the above old_state needs to be the new state.

Thanks,
Yishai

