Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76574B9F6A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiBQLxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:53:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbiBQLxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:53:21 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1E729058D;
        Thu, 17 Feb 2022 03:53:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOyuD4Eu17huUKWMWrua6RvU71TaftVisOnipM3cmUj2mR91Q5gOf9/wNncpx87lxoxK7Q8lDWQQu5XazeKi9VgCUC9kPmMHUi7pX6/UApdUO+1YI5wUPYeV59rEBBHxALmUyl5Fda1JlDMfw9vgAPdnm93j4nvm1t8k4xbk1uKxJBU8oN79hponEj+l6mpxLJturU6H5k7xUiVxGVMr5li2D40hMLbqEjHGII6jRm9jv7xGWErXh5Wc3N3ohsLkWwm2gR+7C3niian5/UI7FgEEjaawFI5Cnq7rYF052YiAbJ/S53sImv1a099n5AzjYHTtA4/FZLVgko0NAdMpfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oEyYNQMBMTeoUb8TXErDbZIfSaOxM6mykOaZR+YmRc=;
 b=fZ1YqgDNHqgONhhLn9SHiARE2/8TZbZwtPSccBk75Sx0N1h42xvOwZBiz3R7Y/tg/TbPmqoNH34jyt4PUduXXePoME9MVHV4kcNl7dednJYRQ4O4CWq1nzObVcGKYKENVewah/OYRVO/nu9uFOtRB8dTSjZ3BNAvCX4ljiSvo3NcuBY9yB0mdj/zr5Ei8HsfB1Fi0IW1PkX29K3Bh6/AR7brk+ws/eCs2QeQ0CEeo6nPgsAnuS/VYf4G4+JrWLB2Ng4dx8M7WRzdG7WgkNJgCdJt2CHcwsLnsqrMm6LsHGZ2ux9OIvEoWkh7/gwnMGJaUMAFutzTVDpLfko6n5dqNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oEyYNQMBMTeoUb8TXErDbZIfSaOxM6mykOaZR+YmRc=;
 b=e0i3qkHnCJBmsL2JkJv1TVr+/gigr/+NJZFG8A8g5rCc+PV0WBGTypMsrH0KLV8m2w1BMXxvslVOn8WXNzXHG6bF+9tYdOIJd9p48TSrehiTW4xYair5aRAbu4EqTCSxcvQPpXkag00YYP7yViHB9BtkrFCfGiacascqtHJo64cUJcfCE2uHepF64fGRq6qNmuOKgI/lih1cIhMH3B5sS5j1Za3WTjPL4XV29hYYdWiCw62NpeMLge4l+PpX1cCPQarHcXdqBXe1QzxzD02GUS14ej+CyAz4CYJvE5T235djjb+Vd8BeaGSsjoUR+Gld506y2Ft6P5nEzT0GbqtrxQ==
Received: from BN9P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::12)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 11:53:04 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::46) by BN9P221CA0004.outlook.office365.com
 (2603:10b6:408:10a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Thu, 17 Feb 2022 11:53:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 11:53:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 11:52:59 +0000
Received: from [172.27.11.82] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 03:52:50 -0800
Message-ID: <5e9a4e05-8501-4d21-c8b9-91c992c109f0@nvidia.com>
Date:   Thu, 17 Feb 2022 13:52:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH net-next v2 0/2] flow_offload: add tc police parameters
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jianbo Liu <jianbol@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217113439.GE4665@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220217113439.GE4665@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb0a7a1c-8dd8-4ad9-fc24-08d9f20c0de9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2509:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB25092AE5532911D23C2222E5B8369@SN1PR12MB2509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GlHpFa9kU/0mWfJdNwDn7V2MyiwKayt0qzJPIg4Kd/YiAPDMPI5tjLYLRtRTbbuARBHj8SeQxcy0ujxSBoNfLSQsEG+WUoExu8cOXELvjB/eAXoKX4+bCNjNF2dq9KmyVUx4ghadGzjsMRht9kC+g3xV2/3vNlA+TQMBfAic3n3el+O8P2MFy+n0F5iV216UNqUodyJ+/VHFO/SKWQ0lwGkolzec3L7SSHYjnpGx/6vWhUWcPTOSoISJLvCnmPjuCtzUjBYiPUxrjBSYvre/VrIdIyS6gwSTGnX4MyE31RUNLnwUqdKgHfwhwRQS/cf/H8bCNEycvuK5oBi/iOiVdfbYC5/LzLAmZqJUcIEmP0ny9jHp1+1ObXDVCOR6l/sl0ec80hhSWTJ2VO/sbzOxW0TpBEpade8eYe0X8k4NtIZtVZi9Og+Cc/fBfFnLnflFQkeyF8fZMCSIvmt7FaPb5QVBR9YUYWH6Dju+Yw8STcMU9M1TnAAybrAquz5IOvAYq/VZNdDpkeI8lwYQyYiDh3ZzFJCWR5qT34/Isywq5PcKFtv1eM/m/H3Dkh76pzvbPibH07PNS6jh57ThKzhNQ+W66LD9wAIMl9drkmtaQnB92VyvbdsxHVUFi6qZ7FKhsbV6ZWmAzkzeVsPn/LRglTHr4uZvUH8qidYSIZDphgdVsrLJub6Wg5JTHIkFRCwuXvcGCM1eXMr1iBr4O2NXVY3khrWNO3J7Y4jtSk1Gow4pZ8DSO+NarfNpjGH/9Gr
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(8936002)(356005)(54906003)(6666004)(81166007)(8676002)(36860700001)(4326008)(70206006)(70586007)(82310400004)(86362001)(2616005)(2906002)(40460700003)(316002)(336012)(426003)(31696002)(16576012)(508600001)(5660300002)(31686004)(4744005)(53546011)(26005)(186003)(83380400001)(16526019)(6636002)(47076005)(7416002)(36756003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 11:53:03.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0a7a1c-8dd8-4ad9-fc24-08d9f20c0de9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-17 1:34 PM, Simon Horman wrote:
> On Thu, Feb 17, 2022 at 08:28:01AM +0000, Jianbo Liu wrote:
>> As a preparation for more advanced police offload in mlx5 (e.g.,
>> jumping to another chain when bandwidth is not exceeded), extend the
>> flow offload API with more tc-police parameters. Adjust existing
>> drivers to reject unsupported configurations.
> 
> Hi,
> 
> I have a concern that
> a) patch 1 introduces a facility that may break existing drivers; and
> b) patch 2 then fixes this
> 
> I'd slightly prefer if the series was rearranged to avoid this problem.
> 
> ...

Hi Simon,

It can't be rearranged as patch 2 can't compile without patch 1.
Patch 1 only adds more information passing to the driver.

The drivers functionality doesn't change. drivers today ignore
police information, like actions, and still being ignored after patch 1.

patch 2 updates the drivers to use that information instead of
ignoring it. so it fixes the drivers that without patch 1 can't be
fixed.

Thanks,
Roi
