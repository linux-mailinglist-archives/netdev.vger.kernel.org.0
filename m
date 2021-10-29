Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F177043F817
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhJ2Hvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:51:49 -0400
Received: from mail-dm3nam07on2063.outbound.protection.outlook.com ([40.107.95.63]:4256
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232348AbhJ2HvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 03:51:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kS9wziXzo5nD08B13KvmFVrSpgutstUzrI2jVdAkFqQK+y+KknrlM1QpbkGNzs8zwA6BrEGgjsfpsbuyC9RI1NZSGPdy31Z2j64EzaIWFvXhtJYMT8yOqCSlF9i8FnntoHgM9Awgz/4Vgg03GLdmFUqNHjHCLyBM4sOMYhiX7S8yZvMZMTpo2pqvX2TzMw7J/AnbSTNR36SwpxWJ66pKfi0py14ofWkznkSEc6jbVuitXLOsv6ARKp4cP8+S5Wj8tFPAYKxMpQkEYICZE8MMerWv8HL03q2hPM9BX/Zm0CSEC8ygufrlVUU3xrECBZ3CGxpxLXttrHLQMsqy83NNvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YBp0orr3fgREoQihO4wMEf9UfgCaQ/ih2zPCpuM8X0=;
 b=cBU5LCZ7i+lRsa5gEtLV1Rbh7JM6/MAZmgwjoTK+S9lrojbuGcnWB42+4tD0ZlyhzOL4MviSpQC175D4oa8xP02dRBCDD5InY/2JPCkneh5009HwHGfdWl1XXEvxanN8/9orLHL3dR3NURQ3SM2ddgVLdA1tKun4ok2hn/VQGp2jW3+y1Cs0sxta0oi2DxJhqRTOTJEo0wr4akIBeIIQkbPd0rgjroW5yXil1ng4bCyT9jnWOcOkZ3H64tmLCAmrOMdbOKGFr5XVUgPhXt0eFjtD8F9NgEV6ElyMcFWlsY0rN/e7v927OryczuDU6DYTo/i/gXtEW46RuPfPmjdA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YBp0orr3fgREoQihO4wMEf9UfgCaQ/ih2zPCpuM8X0=;
 b=bDuUgeboaFwPx5k4KwD1DdTkBSKQt9AzVam+672001cu5TeEx8IGKsClMDHdeymqx/MDCqXLtVEe7C0GRKaWWqxTAJ8h7rClKOBLvPdjY4q4yKktkG/iy/i+mUKo7UKQHXHU1kmTaeeaCistOxA6gQLahXuZHVGM4mcoxGHSgSJs2zA/D8KrQiOEJMmb0HfGirCW5Mx8tkOGMIRWAsP1fFuHAr5aN4YY/t41U7okV+CLqFoKyhCAik6aFCZYPx/ToWIa7/ccZYNnMJPKco8KDzxaT3AKNm8RyUgIES1R9OOxI9RrIxmnry0125ArwKOPmJBVEJffNoacNS/HbA3heQ==
Received: from CO2PR04CA0124.namprd04.prod.outlook.com (2603:10b6:104:7::26)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 07:48:42 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::1e) by CO2PR04CA0124.outlook.office365.com
 (2603:10b6:104:7::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Fri, 29 Oct 2021 07:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 07:48:41 +0000
Received: from [172.27.0.156] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct
 2021 07:48:34 +0000
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com> <87wnlwb9o3.fsf@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <76130eb7-6252-85a7-33d9-c7f00f5a3506@nvidia.com>
Date:   Fri, 29 Oct 2021 10:48:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87wnlwb9o3.fsf@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82a557b0-6705-4e82-5128-08d99ab086ff
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149B0332BA5B779CA0C5D19C3879@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1phuo8cSI3RkkX3ffdXrvL+3pHvmKWrpq1dyLcbXFOBDYxvqYZ9CkYvVME/wuTwi1gZUEnlUw4TysU9mX/HLw6WLChe2I6r4LeiZcX6LYns9x1wehk6WUps3K0dYElrmfMFS3PlzpfTZBHvGQY/hCJqm8NNw68HcpZpIliIDdSCpq68bhp0ekJ2jt2kgx7yq9s5iHFyWVjK0sbtVeddaDYsVl+ZXyCsP1mQ6jrB+qt32x6XVFtho06FXxGJpdLUAXXMaUlERoApdZ+KEc8Mv0EsJ3drd0uo0c+gbZM5AEYZI2tCWqAGtX6iIICRzXK2KiXp8N+lobq8oHUBH4a0Ps0cQfC49k1w2m/3xv7RXOLVqrI19jqlHpWnrT8Eppf0krIHSQJTkCnizr+yhn3qy2H2nJNUAH+0jbENtpE48c7QbVrvIPcCLBeiaS4OzZE9twsqkKhyQOwJTur/e9HB4R4RtF+GgD9CrdS0b81hB620s+E4Ja6wN3LInlF912ajo96GpcQIIXeK3nSbDEk1NP9XOj8UoJ5CAFseaRN1h2yi5r/OqTc0LULu6W8QwUSUgKS0aRVbRU4efC2Tn+T/l6r1SaftHlRruZiIrw1BfSB9PjepPDUXB8WbHEAI3kEE7xxRAbGhW+c7ALksWEBOy16bQoTQuOUtm3ZmgZFWhQ7VMOKEjBHSySEGQlBKVTXr1RQz14ec01rEiRGEh3hnelCDrViL7cadlYAUEokKtNw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(53546011)(54906003)(47076005)(16576012)(110136005)(2906002)(8676002)(5660300002)(86362001)(31686004)(82310400003)(6666004)(316002)(4326008)(36860700001)(26005)(2616005)(508600001)(70206006)(36756003)(31696002)(16526019)(70586007)(336012)(426003)(83380400001)(356005)(7636003)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 07:48:41.6718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a557b0-6705-4e82-5128-08d99ab086ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/2021 9:57 AM, Cornelia Huck wrote:
> On Thu, Oct 28 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Thu, Oct 28, 2021 at 09:30:35AM -0600, Alex Williamson wrote:
>>> On Wed, 27 Oct 2021 16:23:45 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
>>>>
>>>>>> As far as the actual issue, if you hadn't just discovered it now
>>>>>> nobody would have known we have this gap - much like how the very
>>>>>> similar reset issue was present in VFIO for so many years until you
>>>>>> plugged it.
>>>>> But the fact that we did discover it is hugely important.  We've
>>>>> identified that the potential use case is significantly limited and
>>>>> that userspace doesn't have a good mechanism to determine when to
>>>>> expose that limitation to the user.
>>>> Huh?
>>>>
>>>> We've identified that, depending on device behavior, the kernel may
>>>> need to revoke MMIO access to protect itself from hostile userspace
>>>> triggering TLP Errors or something.
>>>>
>>>> Well behaved userspace must already stop touching the MMIO on the
>>>> device when !RUNNING - I see no compelling argument against that
>>>> position.
>>> Not touching MMIO is not specified in our uAPI protocol,
>> To be frank, not much is specified in the uAPI comment, certainly not
>> a detailed meaning of RUNNING.
> Yes! And I think that means we need to improve that comment before the
> first in-tree driver to use it is merged, just to make sure we all agree
> on the protocol, and future drivers can rely on that understanding as
> well.
>

This can done by a follow-up patch as part of the the RC cycles, once we 
agree on the exact comment.

Alternatively,

We can come with V6 on Sunday if we can agree on the comment here soon.

In any case, we don't expect for now code changes in mlx5 as of that.

Frankly, I don't believe that this should block the series from being 
merged.

Yishai

