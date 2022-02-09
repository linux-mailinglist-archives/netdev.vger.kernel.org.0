Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1A4AEB42
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiBIHkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiBIHj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:39:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA842C0613CA;
        Tue,  8 Feb 2022 23:40:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZDjW1MO4BkqzvmwvjeY7uVrHlkP7c92vjaVPkpOAXofMNwPLeqwMzQOkdVJfPGKJumv9Hp1gWjt8SCMMRIuJeRjBTpyYl11EwP3Z8c5tMwtOJF/mkyT+ziqp2kXsw7iW4wW88BVwgD9KptotHr72buVIzYAkxExxdcd53U/2sEfZwhS+GH5poaoRvpCUpmjXGRLPZLk14/cZtS1e9qLIQZ3PgauZajjABk06+0zNMLfUJMLnp8pPKefJ3Xo8dhAHQ2JGLcRC2bG7xOT89HA4qqGnnwcu3BUNy50lFlbiB3Qbj8IFqg3Rm7GiBScMVqlQhhQtbEhtd3UConX0fog6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUZGQzUn32O/iqXk9lB1WrZgCwGT+AAtH9dxBXA3flw=;
 b=OHtscqy80lGHkBS8rQDJQG0H4qfq/is0IzLyE5NPlUs2yf5bNxizCl5GEC9rImJcpPCPXNcFPDRBH7+ivouDHaMc8/wFzv+LSN+TWwl0hhuUKsddJKgGpksHjgUfBDK5RGD8PSF4xb7ey345tk3zHava250zj29GoOMq1MqixvRfl21uYu5jYVvRH9qOe708ZVmtrYt2DfqL6OfIWwBIb35B+qHkobn9akl4mB7FdIBvosESvfbuctJF5a2XFH5nnyk3n81ypek8VKvWYgu0rjUMFP5MtclGon9orQ0+hqre2DM0EII0wuAKhu3FcOlGNZ8zht5gNTT/nuZgY5nChQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUZGQzUn32O/iqXk9lB1WrZgCwGT+AAtH9dxBXA3flw=;
 b=hbb6x+30r0QvpJ6suUeFQVNnwllvdtEIwizakRBVf/tZ3sHp3PBAf3OVNfphlhiMF0kH9cA/JCSuvGzO3STPmdAhmu/ZivKVuSPenH4e6xHhRtqFEwF86nE5Dw05yMgCxXCN6K7xvZuWkMd8NUYCZHHoCzAqKEhsVZdLlXUSmouk5CzNb0Imp5YnwYcKrVisma2UwuOqW3/1jRCLBR2XBYH6LlpVxP3+rBWaOqkZ0+pjXV8OZItCY/gwk6z1W6u98RjNNrz9QwwB2Fo2TjyP+oBsv17fQL4qKl8JqF7BHWnF7KHc8NmjYBvisPOv/qKe1On6HsojMkDyQRTjuunAwA==
Received: from BN6PR12CA0040.namprd12.prod.outlook.com (2603:10b6:405:70::26)
 by DM6PR12MB3931.namprd12.prod.outlook.com (2603:10b6:5:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Wed, 9 Feb
 2022 07:40:02 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::1f) by BN6PR12CA0040.outlook.office365.com
 (2603:10b6:405:70::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 9 Feb 2022 07:40:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 07:40:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Feb
 2022 07:40:00 +0000
Received: from [172.27.0.134] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 23:39:58 -0800
Message-ID: <77077fd1-a5a2-09be-5985-1276c509f187@nvidia.com>
Date:   Wed, 9 Feb 2022 09:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to disable
 SF aux dev probe
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 226e5ba7-4763-4066-3fcd-08d9eb9f617a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3931:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB393160173F5FD8AF59B69922D42E9@DM6PR12MB3931.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1t847b2BojTKD94oTjR3NP7DKLlKFCxejVkcyPhKpmY4+U0WukxuUOwGe6JvT1mU37PT/PZmxBXShYkuZukSxT5Fso4OCZW6jEEjXtXQqPEMjCEuZw1DVbihby1YtW98n0ow/AYmnAkNiPbQEH+jNaYtv/81l3eITQHN0Cuevsj5LSNlvvGXqK7+v9aAo9uo2vNuD0TIkcs1ZBfFh0IaQnTNfAAA1q9tFb7QPjhKrCEeIDVTNrekKzt0bAjk6xFnUlvdHaJ+9bl7N1MI7GqviHMK9LjJ6XXbJTGmqw0y+lfSN2yT9ZMmk9fTASuduZCcGSeMjajqEh7lvgsdU1mVY8bYgr3jhOqVIcAgVWSn2UyLxH9clUqbfn5QmqtOpOsDIB5anrkyFEGVxCSlgGjOGKlIvhE/pJeiAN4Er241wpdAP3Jpcwk6yu7zO1qYJxNWaV31G9B0AqFMCH5xeAayuJDVFzs75IcrsU7yhi1hwO91zh8mJoOfmfKKQQzAH9HS0UYYfzOe0C6Zr7Q+eCs24hskNQTZ1yspi3sDaXhMQO1iZ4O+zwgAlfLo0tsAm6qhFQMpNRRccDT6sXOWsWJVC4BclRwBzzQJo8Wa/CJt6oprduImfL9/PAG1Ha2MStMk6G9mX1CVdeGGOqRhkqknTky2+PA4dwRMxGx+aKAyP/JukT4A22FZmRzzpkTum3VPC9yqP9fL5os8f2pqM4BDKzG0vIyzrB/JOGv9asJRZ8rZ5hYVe+vPQWerLm7kzh7L
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(47076005)(6916009)(356005)(2906002)(81166007)(70586007)(336012)(70206006)(26005)(2616005)(36860700001)(426003)(86362001)(186003)(16526019)(31696002)(36756003)(8676002)(8936002)(31686004)(5660300002)(508600001)(16576012)(54906003)(4326008)(316002)(82310400004)(40460700003)(6666004)(53546011)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 07:40:01.5490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 226e5ba7-4763-4066-3fcd-08d9eb9f617a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/9/2022 7:23 AM, Jakub Kicinski wrote:
> On Tue, 8 Feb 2022 19:14:02 +0200 Moshe Shemesh wrote:
>> $ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
>>                value false cmode runtime
>>
>> Create SF:
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>> $ devlink port function set pci/0000:08:00.0/32768 \
>>                 hw_addr 00:00:00:00:00:11 state active
>>
>> Now depending on the use case, the user can enable specific auxiliary
>> device(s). For example:
>>
>> $ devlink dev param set auxiliary/mlx5_core.sf.1 \
>>                name enable_vnet value true cmde driverinit
>>
>> Afterwards, user needs to reload the SF in order for the SF to come up
>> with the specific configuration:
>>
>> $ devlink dev reload auxiliary/mlx5_core.sf.1
> If the user just wants vnet why not add an API which tells the driver
> which functionality the user wants when the "port" is "spawned"?


Well we don't have the SFs at that stage, how can we tell which SF will 
use vnet and which SF will use eth ?

