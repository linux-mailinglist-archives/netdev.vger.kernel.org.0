Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7180941CE6C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbhI2Vu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:50:56 -0400
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:11104
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344935AbhI2Vux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 17:50:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esg99x0t/oMUVd0SsiuENixFCTpA24vkLgmm+t1hCiQ830b0x87qurh/EKVBo3eCKpcqIl1UgBtbh4SDRVyMRKY5A3cIPlLpODX/SiCFZwH05SNQ2lx/Q36fAozJIGlTChxcm1Xl8PZmOUXccOOZ6KdLVKOpShA0n4IFVQSv3INKM4ti0hIaZ7irATeE3nWPoC/gKAwlKUfM0qcKsZ/S8vdHLI4v9TFpngb3PvCiBdDTKFI7mGk/iG8gpcj60vWDSpvbJGhIOjtY41P5R/uMwrQUgzRGRqBIhNJTnwajxvoRW+OfHMo4iL83l0OEb33PuwCI2zyemKfLcdYNkrNGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j6uIBgfrj/36cNcorP4Dwz6nJnv2/L+fiooMjtLw8q0=;
 b=GcpT2Uy8BaH1iX7y2z5w5/QSYwrfo5ogO19Usfg1zzxG/T4yr7DIKEXkYT2X53Djdwu7vmxRX+W1KTyp4f9nj3OrKXeoFHdDWwqHZjG0rsjtEcpHRe/p9elPHPluzgJTdceUNlA1ri2bcc1gND5fmsMNNCc5LybZ9Em9cqAa1+olUlj90O3blAhwb3VYiHvIpovqmnPlvpV1MMnqKo9RtglGpov9CeFmYAtP6PTnyjs5QnTNfVuqghlp2zFdg4yShqa9Q4f2EnquScnwWiuOWBaXagnfN8bWYzXJMlrDUZzP87jCFgH5bRAI10t8ZkhqO+Mm38kgNKbYgMRRY/ZziA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6uIBgfrj/36cNcorP4Dwz6nJnv2/L+fiooMjtLw8q0=;
 b=raQacofIGbi74i5L89eHbDngLyBS9hcLQW6p/wmE2x6ZWmZnXB2JsF+9/exnZcGaItTqbGOhoGYLhjT217SWjq52jhgJCQEMhXg+PJ6vArTWfYWr+lIDtSXCF8hbbXDbtslu2FeaoHRNkZr2KGG12pQYsN4Nb0pCc1sYSl/s3a26PqXWiFJQVOJkli/nnMqKUGDXTV8O2oQJucHnbEgbDMAdUq4K40LxiUSJpMCFheswY6K1X+6piOibzmIAIO4zJArOeASkAof6V7TwS/Z/Rcpw9EJSkTAoGuYlEZJdnWJHtNj72nV+VGGiA17AoGHY7907nkW5/A8i8+tKY97mIg==
Received: from MW4PR04CA0266.namprd04.prod.outlook.com (2603:10b6:303:88::31)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 21:49:08 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::62) by MW4PR04CA0266.outlook.office365.com
 (2603:10b6:303:88::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Wed, 29 Sep 2021 21:49:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 21:49:08 +0000
Received: from [172.27.1.131] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 21:49:03 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
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
References: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
Date:   Thu, 30 Sep 2021 00:48:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929161433.GA1808627@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53cf2461-f6c8-4768-ce0c-08d98392f6fb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4493:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44931AF1587AD68D08C07580DEA99@SA0PR12MB4493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYSe4t9RiQ/MhZSZ/O9G+Ct9xBb3UQaFRvhodr350MF34I+QSTfyrT8/OPK1JP67dUMgyrVMWPyUopEZbN4bqn30BMsiPiu4mcpmixmc4tsU0paS0KL/iBUO7caKTQ5nzO3Fsm6RkBOulnaVa8LxuARDD4tsoNnWzwel1ugGhFcdxSC4XYXOrcPZvPhHrF4K0w9q9x6SZtFDvAV58ADW9KrIzJ8QrFoalUZCASdcb8hhH1yIUcyUfQKu0zjkr7r+lzOPz2HhaNslpOHiH3iRUGwKyZhZOEI2OyleTZt+EE9GymC9fUQjr2o6PHi/q5c9u3wqc/MUATL/tIxLQKmzazu7QwP1qMBqIIvuJ7Pg/dSpnYwFU4GP7RCHQRfNYudYFTWVbX5cw5pPUvaGQ5yoL8md+4llqjKMe3gVqxAjEsrRQ9ZsxStoXNPDF0r3vzL6klA2EuOc9JAqQeWhNn2yiKvwJ8YhmfB9+u/Q3SDKCZJXYwRFkWh3VxHbFh6q9LmM7R6ZFHXaPLdVfYBE57QVxbHhPz87MvbqdG3czy/psoHJLPZ3ROsOGopZMjI2+ZcCCSVKE9teApiRARibmDLJPZ70xdVVN1oglB07w0le6QMAkCpJrnZnMsj7+/Mo1vamOGDjIO6K2zx59DcpEB8hh1yjxi4HPRY4ziLLoowtn74yi6WkATp4VceUe6VR4sAJoPqIG5x1N6EwWdiOSQ2OK0U5QED1P98IoFxSqCLMhVA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16526019)(31686004)(7636003)(6916009)(53546011)(5660300002)(4326008)(6666004)(356005)(83380400001)(186003)(82310400003)(508600001)(426003)(47076005)(336012)(36756003)(70586007)(31696002)(2616005)(8676002)(2906002)(7416002)(70206006)(54906003)(316002)(36860700001)(26005)(16576012)(8936002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 21:49:08.0684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cf2461-f6c8-4768-ce0c-08d98392f6fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/2021 7:14 PM, Jason Gunthorpe wrote:
> On Wed, Sep 29, 2021 at 06:28:44PM +0300, Max Gurtovoy wrote:
>
>>> So you have a device that's actively modifying its internal state,
>>> performing I/O, including DMA (thereby dirtying VM memory), all while
>>> in the _STOP state?  And you don't see this as a problem?
>> I don't see how is it different from vfio-pci situation.
> vfio-pci provides no way to observe the migration state. It isn't
> "000b"

Alex said that there is a problem of compatibility.

I migration SW is not involved, nobody will read this migration state.

>> Maybe we need to rename STOP state. We can call it READY or LIVE or
>> NON_MIGRATION_STATE.
> It was a poor choice to use 000b as stop, but it doesn't really
> matter. The mlx5 driver should just pre-init this readable to running.

I guess we can do it for this reason. There is no functional problem nor 
compatibility issue here as was mentioned.

But still we need the kernel to track transitions. We don't want to 
allow moving from RESUMING to SAVING state for example. How this 
transition can be allowed ?

In this case we need to fail the request from the migration SW...


>
> Jason
