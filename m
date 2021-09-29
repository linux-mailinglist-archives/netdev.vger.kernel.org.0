Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02CD41C316
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245543AbhI2K7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:59:07 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:50657
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245255AbhI2K7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:59:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmutKXKRjZx9Fah0nGM4qtuPngjBkm+vXdCt6/9m4MkGIBeG50PM3tHVhan9ufVYjtpfmc7YwdOw3AnK2Ark/xiizOjQWQOBTkAXfy6Wp0hkoYcatIIwwGx0NokxZC77ZG+nJiV16AqdoEPmwaiIz/OX2dI3s5jQh/WacpDZHkDRQeyr+iiod18jCh1qLXcIbT1hzD0YFILYeEnKgh8p2sD/TzQ2boESXa87WjGW6jqy2hfr4viI1Th5iPRE+06uSdieikAXuiYjbhlGlvrUSDmiBTz9R00stxWbuRKAVXE+jooj+Zv33dj+ObTcWmOjpd/T0t9AIzyLF2lFFQrclg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dgGNUBVw4jfBeJzO1awQNVB9kOaYEfD7VMM1UMr/QMo=;
 b=Tc105saZs8U96EaF+YwPHPUmwgat8CpXty4pwtbzEXI9RCC3DD2ja++Pp/FJ87derNaKOg9RIGeAtIfp/QOxrEHSTVQtbGPOm4qy6NvUz963LNqH48ThV+C/ymV+K8NKo+veDRmlaxovfPNyjSuaMI3nFhoiGkw+TKThzqjedybSHDaMFJzV5vtRjNNIBMr4EUOs/K2fJvqynmqutPesNzrbmQ2f3MAqTGwGQyzanL+l/OKA6IVqsbwNrhh5Y4R6z9cIuvqXPfzrBWv5pJTb5B9CRxtgthbgUCaGk0RD7eTsb2XyaPeDajp2AJbScEu3WwtLbxEKxQChxPSADOJmFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgGNUBVw4jfBeJzO1awQNVB9kOaYEfD7VMM1UMr/QMo=;
 b=A37akE0GFVhsiRHG2k5F2ML77ZcjrxXVekeGIhz3RhOkyal6cihj2gdHhAf99Gu/BSD2fm68fRJm3rUnpeiC9G0EOFeTMJChJkLDdaDYfvOS+qyjPqUSU2P3dB8sh7vgDwAaPvU2XctI5dPqcbZzcIfPCyNWiQBekUbkr+KaqA11ZdYbXtKSzf/jd4I4/r5uujgDswfRNTUUiNs4g6HbZ7vUEBaxiuvOfBYTBV0iL1cQj0ZZ328ZJowJjwTTdhKXDj8D+Qob4kvfEHjB+yiCDwZsbx5hELBxiKiJtcb00zPPuXcRqqSR6UZxxqv2fhKN6KNjVZL4Hm0f4gSv0xCR/Q==
Received: from CO2PR06CA0069.namprd06.prod.outlook.com (2603:10b6:104:3::27)
 by CY4PR1201MB0070.namprd12.prod.outlook.com (2603:10b6:910:18::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 10:57:23 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::30) by CO2PR06CA0069.outlook.office365.com
 (2603:10b6:104:3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Wed, 29 Sep 2021 10:57:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 10:57:22 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 10:57:21 +0000
Received: from [172.27.14.186] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 10:57:15 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <20210928131958.61b3abec.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e216c772-1921-c728-b91a-56b41048cbfa@nvidia.com>
Date:   Wed, 29 Sep 2021 13:57:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928131958.61b3abec.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6241b022-448e-41f4-7486-08d98337ea48
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0070:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0070202B81ED46F0A6287AA6DEA99@CY4PR1201MB0070.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77RCsknL047Kn9/PBpsDT8lHr0J6oGgY+r5hIaFYkSsWKZC80JK79TgOcdQI8bwBk8fj6J/dw71RClYYGb24EVgbMpdcyofXEuCBtPOe+2sKzsxOf3fYj1+HmRrauDV77lGJBs6hCK9iKSXHp1qiYVzWeHjhPFGGR2BNBWD1tAYk/7orBfDhOzCpgRG30AT57zf2QfYRHeXuOdx1Kl35stuo93AhNzzkq0HGcNi6g+PI83/dHDszOLPdNOAgfjf3dm16CsHrD3IRequHr69wc3Uer/mh0Iynr73qCdXEpU+MOxstXvqLyg+xci5P193x1qNuEbgJObHQ1zLghuf/GxdjVIrjepNINAlLJUDB+5yX4T9TiU9z6dBLmqr4yxSyYRr1N4HvqiE7STeJVfJYwmFlgSUpCaeFmUBGq5mJh/uOUrEyki8IMe63iFFZ1He1awnvsAf019jMRVa7eaXmizLlhRInJrBTM1hFfFoP3tKiigE0p21qC/6JTy6TCO9G6quqWSaYcrwijHh3r2+lsAoZA64IOtjTEcGacYix9G0W44a60XObmHJNsVyBRzqWIL55ZCs5b+9PO/y0kv5u3iY7/tuRCvG2UBj5lHf1Knc1Ip6rsNCTG+SWRfuNyXDyoeSx8Z32Oo6tJt6xA42IAgsk/JN1EXhQUkWIKPsu8EJuJwQBmnTFFdmzLYso6W+bfZVjzrmRpsSpFaTjudqLA/GYETQVIcBHR0akcBnkGLrkuoN3zF0gLCZ4rIoKFG0SCJ+DbhQKbqA7Ra4BxMRS+qsl3vkmJJZoGwuX1YlYal/Br7ap+B2WALwgfzlWOh4URa2IL7TVQFOjOenF0fjbz5spapfLh0BlXrGbLki+WYE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(356005)(7636003)(966005)(7416002)(53546011)(83380400001)(2906002)(47076005)(5660300002)(8676002)(54906003)(31696002)(70586007)(70206006)(86362001)(336012)(36860700001)(508600001)(36756003)(82310400003)(110136005)(16576012)(186003)(2616005)(16526019)(426003)(4326008)(31686004)(8936002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 10:57:22.5679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6241b022-448e-41f4-7486-08d98337ea48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/28/2021 10:19 PM, Alex Williamson wrote:
> On Mon, 27 Sep 2021 20:12:39 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:
>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>> +		},
>>> Our state transition diagram is pretty weak on reachable transitions
>>> out of the _STOP state, why do we select only these two as valid?
>> I have no particular opinion on specific states here, however adding
>> more states means more stuff for drivers to implement and more risk
>> driver writers will mess up this uAPI.
> It looks like state transitions were largely discussed in v9 and v10 of
> the migration proposals:
>
> https://lore.kernel.org/all/1573578220-7530-2-git-send-email-kwankhede@nvidia.com/
> https://lore.kernel.org/all/1576527700-21805-2-git-send-email-kwankhede@nvidia.com/
>
> I'm not seeing that we really excluded many transitions there.
>
>> So only on those grounds I'd suggest to keep this to the minimum
>> needed instead of the maximum logically possible..
>>
>> Also, probably the FSM comment from the uapi header file should be
>> moved into a function comment above this function?
> It's not clear this function shouldn't be anything more than:
>
> 	if (new_state > MAX_STATE || old_state > MAX_STATE)
> 		return false;	/* exited via device reset, */
> 				/* entered via transition fault */
>
> 	return true;
>
> That's still only 5 fully interconnected states to work between, and
> potentially a 6th if we decide _RESUMING|_RUNNING is valid for a device
> supporting post-copy.
>
> In defining the device state, we tried to steer away from defining it
> in terms of the QEMU migration API, but rather as a set of controls
> that could be used to support that API to leave us some degree of
> independence that QEMU implementation might evolve.

The state machine is not related to QEMU specifically.

The state machine defines an agreement between user application (let's 
say QEMU) and VFIO.

If a user application would like to move, for example, from RESUMING to 
SAVING state, then the kernel should fail. I don't that there is a 
device that can support it.

If you prefer we check this inside our mlx5 vfio driver, we can do it. 
But we think that this is a common logic according to the defined FSM.

Do you prefer code duplication in vendor vfio-pci drivers ?

> To that extent, it actually seems easier for a device implementation to
> focus on bit definition rather than the state machine node.
>
> I'd also vote that any clarification of state validity and transitions
> belongs in the uAPI header and a transition test function should
> reference that header as the source of truth, rather than the other way
> around.  Thanks,

Yes, I guess this is possible.

>
> Alex
>
