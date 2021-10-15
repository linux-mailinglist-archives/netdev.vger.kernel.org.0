Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC33042E6D0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhJOCun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:50:43 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:15780
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233054AbhJOCum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:50:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+fpawz1b0jj6Xk5045gzUv0wqKiVwxOugr09qyxJD+wNtdA4lR36KTn548/DtZceL6BwNEF8tLSsE0C2lVKw1v2CS5FfY/mN4emLx9vGmtFXjy3K1MsV9szgk0EmDl4/C0KsCKBetROR4IL2j7K6L73VCr1jxybAeSn/KQR2o0mzXZHieAKhO/IxllWUVBdpEX8idbZA5dXBqV9/Vjq+3uEDZV+cS/fgjj+OP9tFfa/xjpRX+rfaWZI+dYLuuOk5rpH5d7NA+9eqd9Hsn1f30fTCPsYpCwm5yjGLPjfjwujCafEoZOlcG5j9Md1PpQSCArjnRABPgjQhSTMwaHDPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1KkQOuwqhz/7Edt36NnVjQUReIplQ0bucDOK8EcFLM=;
 b=DW+STtoHTO0CSJ1vtA0gYHpnBTZ+00k2Xbi7OMnBOY/5Zkz1/cHU8hBVnY4eoK/FXgLrBKgjuNWuPd6BlJHUzZUYTUmjBFXv1qXCJis+xJ8L3fUjXK+CvP5oIMjOHwxW4JTgaSWOF+nrSY2LHxwlSu8HN0la5Z6z9+SXbr0eojQqB7plkK7coV2WqjSuyObo28P7xYF8lRXVI53WWJuCxJHGhtgdXhoSCEb0APIvptszbhZvhf7dgKs/8lf2V0n8iA/SN+pQ23ORuf8aygV9sjYQNEdcrrn6V8+zY9EbuY7p/fRrKM3HMTWO7s/lN40tDBIs9mCjqIurAMnvGajaWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1KkQOuwqhz/7Edt36NnVjQUReIplQ0bucDOK8EcFLM=;
 b=H8PzBaPxKDj3ZBT4FBXE1TZgpon1n1X1jRCOOio5s8JERklC0s2dKv0VkFbjhRzeRb6BwBIUWX0CriOJxn0YJMHpThH2exWKvpBLt3OBeKouE30Qkc6vcl0Dtrv1/H/8j2yAp3FglnXDNtufRUPAhj0AqOd9BUfYlZE40el1wj7hqD9TKChxKJL1iwFacDS3XEfaqtsV0x9MLdzBO9OD5xr2FIh4n+lsqkKAkQiPwFlXPdK8Z5sKF4T5de6rXh4lHqZXKc7x+ur5GNYBJnkxXE52ZpWKWZ/ga5732Mwv8vTVUooOZg29R5Pfe95fvmrqxpERWx4gzjYzFN7omXzqyQ==
Received: from BN9PR03CA0057.namprd03.prod.outlook.com (2603:10b6:408:fb::32)
 by DM4PR12MB5328.namprd12.prod.outlook.com (2603:10b6:5:39f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 15 Oct
 2021 02:48:35 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::15) by BN9PR03CA0057.outlook.office365.com
 (2603:10b6:408:fb::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Fri, 15 Oct 2021 02:48:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 02:48:34 +0000
Received: from [172.27.4.196] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 15 Oct
 2021 02:48:31 +0000
Subject: Re: [PATCH iproute2-next v1 0/3] Optional counter statistics support
To:     David Ahern <dsahern@gmail.com>, <jgg@nvidia.com>,
        <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20211014075358.239708-1-markzhang@nvidia.com>
 <82b34add-ef1e-dc51-3a1c-5fd7777e59ed@gmail.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <dca007c3-33bf-0707-9726-46d5ef37db6f@nvidia.com>
Date:   Fri, 15 Oct 2021 10:48:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <82b34add-ef1e-dc51-3a1c-5fd7777e59ed@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a5067ec-3aec-45fd-7f1e-08d98f86484a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5328:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5328DAEFB39858FE7705E529C7B99@DM4PR12MB5328.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uI16GnXciXi6uYWdhyU22Yt6odTPyMf+NdfDEWclVLYYVjGI4Y7DG6h68abGAl+7lfLLDSiQjx8Gr1a5N6EvEAFsvGcDYDf/2+C4nbz7+QET6ZsvZ/YDzX4cCC7aauuCnUXyjduHzfT+ROJy+A/Jwl9Ls3PEI0oTtT4oii9rQWteOPeFgbeX3Bab5Uuro8vlLKYkGhFIdh2lN4OYDFbnmlGhqkr1e4QPKrUGE86RM97ne8TbADiv+5EFf3w4M0oZyk7n1r4/9ttF774V0zM51KTPgfELEupgzdEDaajU7LDvV+t+qT8279QeebtuR6L3AfBCDS+gH6pxW79RHmbMC3X6hVLS2zOmIL7EEdne/PtEuy1o/Aj19RZKPB+xM2KrELgvJoIekiyU5tDj27v3e5uDu/PcUbGUo2vGCL6H9L3rykQgP4MfTSyZE1ElcQe2Tysi8OFUpJoFp77WjLSSjX8rMqvMVU6BNzNmHyZtX/EiH+9gCY0nWOGyu+403nVeYuVOQlwPzNdrKDg4wcD0kfuIJ6SzCcazcFAUMfoH4sS+wvR+O7dQ2zgG5bnGIxy0NEl7qjScGL/LjBgKEgmoWK/RcbuP8FKlBdfbT8LtqjDj1FVuL6AE/diVDxhgmP89hZ9E6Xy66bFa41L5cwbGjWdhT5brBpSucs/NI/8SrmB3F2FThEHIx67ecPWkVOd0hHmffn4dtLlCtqoRq1/+NIau0Nv8jlKmswoTDPqkalGczXW1Ee0ZR0AK0Drj86jVdEfCLkBouie/ls9wSp39dGa9MWApxjP8E9fN7es8cKPTlWrZkCCf09362GLqMG0Wva6LIo6c2q2DqO7WDW+5LnYbtFmN4Yn0/WNaIZR6os=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(5660300002)(2616005)(36756003)(70206006)(70586007)(4744005)(426003)(7636003)(31696002)(36860700001)(86362001)(107886003)(8936002)(4326008)(47076005)(26005)(31686004)(82310400003)(110136005)(53546011)(356005)(186003)(8676002)(16526019)(316002)(966005)(508600001)(54906003)(336012)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 02:48:34.9258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5067ec-3aec-45fd-7f1e-08d98f86484a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/2021 10:28 AM, David Ahern wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 10/14/21 1:53 AM, Mark Zhang wrote:
>> Change Log:
>> v1:
>>   * Add a new nldev command to get the counter status;
>>   * Some cosmetic changes.
>> v0: https://lore.kernel.org/all/20210922093038.141905-1-markzhang@nvidia.com/
>>
>> ----------------------------------------------------------------------
>> Hi,
>>
>> This is supplementary part of kernel series [1], which provides an
>> extension to the rdma statistics tool that allows to set or list
>> optional counters dynamically, using netlink.
>>
>> Thanks
>>
>> [1] https://www.spinics.net/lists/linux-rdma/msg106283.html
>>
> 
> this has been committed now?
> 

Do you mean the kernel series? It was accepted to kernel rdma.git.
