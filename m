Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE215430997
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhJQOFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:05:51 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:48096
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236660AbhJQOFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 10:05:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2eIvAraXDNGfZyYn2Kd+TzzISuZA+SzI1xAiZ82heO075ivg6ZR2xJtWddOQG+Dgx78hwmXiVaqJdM86S4UKgHBinnpmZvLiuThR3LjmBl64YvXYlAapQVyX1mN9bFc5Dy4bbOZ13JDcEQkovfPnJXDfEl/LPb9rR8JyX7QWtdqICc31FVes2GqkGj91TphS4zXXcd+Xx/1eiDyFVrP/EVigDQ6gC35h/5aem9j05CxxNwC35+0LQ/AAE4KoWpxdYAc6BO7xEI9DSuvg7+2zyjDTZmXjwlY7TUO7cTAy4Ft9hVNqIAoCmPbu8zJjl/ypjer6QmMCboPgDkhGKM63Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtzHTYhxnAjoMRKJmluol4sZLre5eOr47424RX1pQvQ=;
 b=atzkvK4jONwGICm9t3rGbRBtLP4IMz9SZ5NuUrBk0oTsTJMA25AQMUUALm0GKz5vQ+TAbMB9L3RJHX9xnfwnzGuR2OX8+IIzCct79cFA7nuRWkIDKduKMzFph8Y4yADBpM5BQcY3w3tMF7fgM+Z/hScZRQOTUCvMonoYtZ8gVu6lHUGKRpugaRZj1BRyQLEHz1+44+2NX4VfX5fL1Rdorqgazj2q/NBQ9kMx06889riwnq3FGbzbLvsFT+7iZFY9gauROb6Y5x3CM0L/uf0pE2vgbxvUxyT4tQWNxVFrOdoBeBEoNxWo0loQXAb88gVb4zg5jAO/LzL3sw9yMUg4xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtzHTYhxnAjoMRKJmluol4sZLre5eOr47424RX1pQvQ=;
 b=OTs963BNhE04g5AFZxdixNqUysDkQ0T2Swor+va09c2BkAxdo+LAEztMv9hSMs3d7b1q+mBONhYtGmUNnoX3NhwDXEVZF9HjwT91aQ+v8c61JhCG7tmF/cYYjh48+/pZjYBL4+pubdIsqRb2Dlgw4rgijoSUOjyj2Hs8zwHLE8jpnzTIvxy62oZBynxuBZbgTwE3aEWBNaX9l4Na3sYRfN1BzyWGUtYUQWKxPpwSQ1SMkDhhoBHJXhLYaE1UTGoJl4bUWPg3STLcjKICBGXe7YDPK+yM0/EJVUeLoFXFQ0bufhLyy1OERRy4bcKCr8JO5ZaYagLXvTmeg1vvq4lI5Q==
Received: from DM5PR06CA0052.namprd06.prod.outlook.com (2603:10b6:3:37::14) by
 BYAPR12MB3173.namprd12.prod.outlook.com (2603:10b6:a03:13d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 14:03:36 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::b1) by DM5PR06CA0052.outlook.office365.com
 (2603:10b6:3:37::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Sun, 17 Oct 2021 14:03:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 14:03:36 +0000
Received: from [172.27.13.186] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 17 Oct
 2021 14:03:33 +0000
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
 <20211015195937.GF2744544@nvidia.com>
 <20211015141201.617049e9.alex.williamson@redhat.com>
 <20211015201654.GH2744544@nvidia.com>
 <20211015145921.0abf7cb0.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
Date:   Sun, 17 Oct 2021 17:03:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211015145921.0abf7cb0.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8acd979f-a4cc-4b8d-2b44-08d99176ea03
X-MS-TrafficTypeDiagnostic: BYAPR12MB3173:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3173656DA1CCCA971C886C65C3BB9@BYAPR12MB3173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7yGWSi2I5vqIkPIxifAIGo9Gb7Au4ehiaJ6ZAaRBs17DVFHIvlBP2mgSqT5cOqHP2xtCTMJ5wTgHdfrloUk9FwmBIWu5N12SWNgl9NbosNszsQfKvLqB1L3qRF0P3e3Vp/N7YCijJAtyq/8/fHUFrEIB9ioqAHjNaKfpCMdj6DZuHRlhhY3s12FXLz82FKYYGEaSNGyy1HhAEBNloHVFOCF4YYGzP9Zf/E6G+bBg5Dy8XJplc1mm2zevaoZUbVc6Ujkz6VrFTil3IS6sshxSmDZKOv4SMq8YgTZt5tvJTR0GQ/HldzkdL+YAxbPu2xL9klRTOW1fZKTV9dkTR9UbR2GDmAWwBNmWJBNOtOc3Uh5THTodzwateSkvZTfW+6aQ2shTra+aSfM/G8R2vvXOuIkjsmVU2jjViBgr46J76JoZC2XRtYZ5//5laJvQyF9zgnUKwyqhadRobg9eLrOeeVDEZlkUVZuiBGrqF1xIjZXEhKXO5Kb5Jz60okPL6XUwgxZ5UNqv7oeE4ywJmRdwj10wUb0tN7/V23ZvJt2Y8JmI3ue6dfiEZbzJnrsfWuyXfvR8gn44d3bYPYYV8Z+hCNN+9jksUr9oGB3kFnHQ5XZY5WM0V6lmrCoUBRGOd5gNSCfFElK5EufGd78O+/qEFCt9gOTO2y+07siqxsTgO/eu1AewtFVtWQe0zvH/qYP7E33hvNXddieQqDHATdzJYm1ATH+q4Ng0kE6zRd6jMg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(316002)(70586007)(16576012)(31696002)(36906005)(36860700001)(4326008)(5660300002)(54906003)(2906002)(508600001)(31686004)(47076005)(110136005)(26005)(16526019)(186003)(53546011)(7636003)(82310400003)(6636002)(356005)(107886003)(8936002)(6666004)(2616005)(86362001)(36756003)(426003)(336012)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 14:03:36.6861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acd979f-a4cc-4b8d-2b44-08d99176ea03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3173
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/2021 11:59 PM, Alex Williamson wrote:
> On Fri, 15 Oct 2021 17:16:54 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
>>> On Fri, 15 Oct 2021 16:59:37 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>    
>>>> On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
>>>>>> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
>>>>>> +				       u32 state)
>>>>>> +{
>>>>>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>>>>>> +	u32 old_state = vmig->vfio_dev_state;
>>>>>> +	int ret = 0;
>>>>>> +
>>>>>> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
>>>>>> +		return -EINVAL;
>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))
>>>> AFAICT this macro doesn't do what is needed, eg
>>>>
>>>> VFIO_DEVICE_STATE_VALID(0xF000) == true
>>>>
>>>> What Yishai implemented is at least functionally correct - states this
>>>> driver does not support are rejected.
>>>
>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
>>>
>>> old_state is controlled by the driver and can never have random bits
>>> set, user state should be sanitized to prevent setting undefined bits.
>> In that instance let's just write
>>
>> old_state != VFIO_DEVICE_STATE_ERROR
>>
>> ?
> Not quite, the user can't set either of the other invalid states
> either.


OK so let's go with below as you suggested.
if (!VFIO_DEVICE_STATE_VALID(old_state) ||
      !VFIO_DEVICE_STATE_VALID(state) ||
       (state & ~VFIO_DEVICE_STATE_MASK))
            return -EINVAL;

As was suggested to have some new const for ERROR STATE and use it in 
drivers when state gets into error I may come in V2 with the below extra 
patch.

Any comments on ?

commit cc7cb23773c70b998aaee5bfc2434da86c80b600
Author: Yishai Hadas <yishaih@nvidia.com>
Date:   Sun Oct 17 11:34:06 2021 +0300

     Vfio: Add a const value for VFIO_DEVICE_STATE_ERROR

     Add a const value for VFIO_DEVICE_STATE_ERROR to be used by drivers to
     set an error state.

     Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b53a9557884a..37376dadca5a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,8 @@
  #include <linux/poll.h>
  #include <uapi/linux/vfio.h>

+static const int VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING |
+ VFIO_DEVICE_STATE_RESUMING;


Yishai

