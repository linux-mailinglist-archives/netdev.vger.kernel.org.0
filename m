Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784F43F7E8
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhJ2HiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:38:11 -0400
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:12096
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230247AbhJ2HiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 03:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHMcLhIgV6LFtCPVE1jHLhugqHYiK0DqYtdBFQy9czrAQetl+RSsIkU8Bbhi2sBTXaambl61+8M6h3ZvxjyQuTTbHeH1VN6t6StUG7nRjn2dKHXBssr0V8FWMUZ7oGm4nNyz4NUee2+bzi+HtNbqIwGOKymB2wqWKsfFx7tG2jqr3/tEisYqOcHuIIuSHMOqS9+nn7MBogVn0QxsefULjFLU4vYhwdBkTeAUWy/4mLDLUjX3HYFDFMblqb7Sjna1uzGZgSc97qV9YlxoIclMHJM6HnvdKmZCHaVg8RZ39kz+W5HcYggNH7EI8d0fWkrDMufQWakTP+FQ9Sneejs5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZgQSxteECnfgZlUNpASpRjt/VXjmcHXPuWoFw/b0LE=;
 b=Aorr7ozcNYiaQz5PoKYeRn/Sfpj9GpoW/nm9TNOjoe+zBIuZT7l1OHesAbbiBVUXzAKu+qxtk+dfq07wvNBR/Vq+WjdSp5rphv3AugoTCQm/CrJ0ZSgmMACvokV6WOdeyYs2JQXE7QPcu79uE8M2aBNfjjU4Qva/SWNZhTZH5dTCGCPoOT5F9l4WlRTENw5s6YzHbOOAmMFq+bweSgGGZPmFk7sCguMlqSdDgwJBB3F2N943KmdczvrFs+e3ZC5oA+lD/EvnM1CE5njxb6jHzRLZUMSygQH2aLtoCSn6nYIodY/n6/FINuys60zDgZnPXUp1FoeCZnhdiQ4JnWqZww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZgQSxteECnfgZlUNpASpRjt/VXjmcHXPuWoFw/b0LE=;
 b=NXjztMU2/kZc/f2SIMT0bkmiGn6hoH71MNfneWevgp+PBizGYXhI5glcLAdKNwfpdWV8wmyVZrFawQ+brjB4FS2JAlObSasTmYflHwi8ojg0DxA7cmL1dk+tIzEHo7wdYlBdnTXFMjP7VQPHW4nVsb6GhYvk6mba5lCvUEFDx4I8Z0ZMMLbxhRExhEf2qWIo/nj+ydCtZyUqtEP0lNG6KGLrNaWuZhsL3dfU9f+EVwTLOdxM+KO8L+GEFpAc0d/oilqZRtbnZ6cjmuq2bBZhbom7ZK4PI5adkRFsRDz2IvqzjDhMwKqlC2KQ5erAb4uRtNrSSNsaBc17KOmnV0m8SA==
Received: from BN9PR03CA0193.namprd03.prod.outlook.com (2603:10b6:408:f9::18)
 by DM5PR12MB1146.namprd12.prod.outlook.com (2603:10b6:3:73::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 29 Oct
 2021 07:35:40 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::10) by BN9PR03CA0193.outlook.office365.com
 (2603:10b6:408:f9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Fri, 29 Oct 2021 07:35:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 07:35:40 +0000
Received: from [172.27.0.156] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct
 2021 07:35:32 +0000
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Jason Gunthorpe <jgg@nvidia.com>, Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <saeedm@nvidia.com>,
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
 <20211027192345.GJ2744544@nvidia.com> <87zgqtb31g.fsf@redhat.com>
 <20211029002637.GS2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <6334b789-e619-9208-38d2-c6ba5429f830@nvidia.com>
Date:   Fri, 29 Oct 2021 10:35:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211029002637.GS2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa445f7-dcef-43be-9689-08d99aaeb54d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1146:
X-Microsoft-Antispam-PRVS: <DM5PR12MB114622632BBD2A622714C5D6C3879@DM5PR12MB1146.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7knnv0GJqlI0QyEcK90+Uz+EKIzG4Cz7D1Aju1GarWYAI7pSATT+ZTroq2dw5qbQvxmd4AEjC27z2Z5FnS5zfYNuo5sAzvnm1qNSFawbSgGuQsMrxbExF+1ZJzIVQBmBw1bm+UlsvI8d5lNDzID7yE13glQiY4yOcs7AVBOWsevLT3byoMxySKwfqyxjwrh62e9Z8G+sBDhppX5GOEiwzXVJGZiwRFmhTmcWwsa6i+P/OTDoWjjSMzVWji791na2y6x/JZQec1NYoLnuwiYBj37K7s6yBwQZvgFFg49fpnG3EuQQIfwoI2qW+SKgvkXxIcDJgogxO/sTwos/l4L9sFbNXJwVrgAyLIMQ5fUwLiRUr+DN68GQk0KUHUknBoZxlbuopl6OxT5MYT0yDuVyyMw1tGsSWdMfIk/r1kgkOJFTlkrI6RPKxr+LlU633x2ZcAh7kNVALVwvY0o5dpVrh7i7m0jZhYyzRSrlMhOTdw1aRNun5XtJHVy4Wy865Xxv9wJ68Vzqg/IFa6IWIaQYzBYl+MwnMPef0oScczmbDPogVOCXQnPfcsmILs02XH2dvu6iFu54bxXKTxG0+X2F52vkmtf/FmP85v6n6KQrk/GpjiQHCX5XZcOuDtidnhsZTZkiU7YpXkE0FK9ttTU2sLSeLRHcppZ44NY8xja+SLeIDQow/yFVggvZqUZlBa2b2g+YpODKFOEHyASi/KZX7A2pTAtv+leRZM3ioZ3hc0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(2906002)(31696002)(70586007)(2616005)(426003)(16576012)(31686004)(4326008)(70206006)(53546011)(26005)(7636003)(110136005)(316002)(508600001)(16526019)(36860700001)(356005)(186003)(36756003)(8936002)(47076005)(8676002)(83380400001)(86362001)(6666004)(36906005)(82310400003)(54906003)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 07:35:40.4634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: faa445f7-dcef-43be-9689-08d99aaeb54d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/2021 3:26 AM, Jason Gunthorpe wrote:
> On Thu, Oct 28, 2021 at 05:08:11PM +0200, Cornelia Huck wrote:
>
>> that should go in right now. Actually, I'd already consider it too late
>> even if we agreed now; I would expect a change like this to get at least
>> two weeks in linux-next before the merge window.
> Usually linux-next is about sorting out integration problems so we
> have an orderly merge window. Nobody is going to test this code just
> because it is in linux-next, it isn't mm or something with coverage
> there.


Right, in addition, the series has been on-list over a month to let 
people review and comment.

V5 has no specific comment on, I believe that we are in a good state / 
point to move forward with it.

>>> Yes, if qemu becomes deployed, but our testing shows qemu support
>>> needs a lot of work before it is deployable, so that doesn't seem to
>>> be an immediate risk.
>> Do you have any patches/problem reports you can share?
> Yishai has some stuff, he was doing failure injection testing and
> other interesting things. I think we are hoping to start looking at
> it.


Correct, I encountered some SF of QEMU upon failure injection / error flows.

For example,

- Unbinding the VF then trying to run savevm.

- Moving the mlx5 device to ERROR state, my expectation was to see some 
recovery flow from QEMU as of calling the RESET ioctl to let it be 
running again, however it crashed.

- etc.

Yes, we have some plans to start looking at.

>> If you already identified that there is work to be done in QEMU, I think
>> that speaks even more for delaying this. What if we notice that uapi
>> changes are needed while fixing QEMU?
> I don't think it is those kinds of bugs.

Right, it doesn't seem as uapi changed are required, need to debug and 
fix QEMU.

Yishai

