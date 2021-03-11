Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C234337864
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhCKPqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:46:11 -0500
Received: from mail-eopbgr760057.outbound.protection.outlook.com ([40.107.76.57]:35695
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234179AbhCKPqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:46:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjkW7YMb4G2l++SKxGcw+Vtxh0iVS4q9PZQLCoW2tnghH7Ai9CCV6/VR9D8CbPx3SGpwXEhlr/zM7XFJFSD56yNnhh3Nne24JFueXOMOAxL78upxfcI+2UMuNTLLB8ZwrBwfeA+xzhav+KxFihMQfn9qkZ6Uwv9Kwu3Cd6SATnCdljha8XxoaZfjd4MoHUC50B7206s519ZUfb08wC2BiarxxYrZc6f8YOmxBvB01oyhchdd77IEggT4BRVaYkS2sGDNRy9RV8NsMtMcX2sbOq2Iv3aMe4O03AvLVX0cEov6Ei553ayajZAM3fspRWTXDYENv8ABQEEosHo3KehEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpjzToF27LfUjWpAvENP3fGdm/+/1YKosj+G0dSFZAY=;
 b=isjPTlOzCUKaOhFU28jvhATg4HEK3UHOyoiDkI32pX8RvOfrwbp6x7x7Wyw6Rh9c8R7aG/BJ1kXZZCcJYjrSUKTHNANbmPcEa1efiZe+n3ybKQ/GjEt+b90BcPmm5BnwlrTdqNt2QPO3/EHeoU/l6jomtKe3xlkMFjcY+pTQf6xFlrAcWRKCJ7zjrk7oexo27BmrmFNpI3/hDS4RefkmCzX6I4Lzk3gChwInBVYLXdJC/kP1f43fb1u7Pv+rRQN7BhJKvgRXd/uko8v9kK3c78egg4GMLxZEpTAZ5IwzXvyOjY9Ps3+Uv97KA9aoUFOQMIpRdbkOg0tJq3CwKP23jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpjzToF27LfUjWpAvENP3fGdm/+/1YKosj+G0dSFZAY=;
 b=I2+tgYuTXGqeBRbxWg1rCLliIy9oUNme1TA2n1hIywxTXsyi83IMx8ctX090/MvPHqh7YFKzrnD7WF7iV6h0IdfJl9rgm/KuJAw7F6Vpy41VtWpc2xMKIsqMNSFLoEK+erV8UXDfZbkh7TMaTj0y+6GEbcNEilpSDgDlPrjhnOVghznARs29QeA0oRkGDQob8tD/smy/zaVj8DN9Z/eCjFX+Ie2ib2dfqU13RntuG0bb3cdj/zhJxoDmMlje1tVDZX0X0++vcZ8PxsuEc3OoFpWSO1mnBOXKit9XxvOsG6q+gaKezqh8VNQZioV2jzHrbUgAcuuRGt3wHVn6qh20Dw==
Received: from BN0PR04CA0144.namprd04.prod.outlook.com (2603:10b6:408:ed::29)
 by DM6PR12MB3276.namprd12.prod.outlook.com (2603:10b6:5:15e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Thu, 11 Mar
 2021 15:45:51 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::6f) by BN0PR04CA0144.outlook.office365.com
 (2603:10b6:408:ed::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 15:45:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 15:45:51 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 15:45:06
 +0000
References: <cover.1615387786.git.petrm@nvidia.com>
 <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
 <b42999d9-1be3-203b-e143-e4ac5e7d268b@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 04/14] nexthop: Add netlink defines and
 enumerators for resilient NH groups
In-Reply-To: <b42999d9-1be3-203b-e143-e4ac5e7d268b@gmail.com>
Date:   Thu, 11 Mar 2021 16:45:02 +0100
Message-ID: <87ft11itj5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a733387-1131-41b3-efb7-08d8e4a4bfe0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3276:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3276BC6ED71B656361CFC3E1D6909@DM6PR12MB3276.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C81F6wqtQQt610sKWm/IouCeaujFL3mADXmWdNE/P+hcaRidW8w5eWudL2CJtpmXEsHPJi8DndZHI8IWMADIWynCUZUhKNJmQQY1bLmhnkk9AwJqT7+dk8UBN8mAC9j6bqi7ZyEt7sYVs27V/JCQp1durfOE6uE8qZys9NGVWy5YFAUXG52bDyhzB09+duAFeWFnsCKoNPcMUaxOjpsyR8WAeWJCGorG5EFgYnxDq44/NxVq1K8LV5D+GkdKR7GT6um1G5yXZB6GUr+nQ/UcC5crrVyDqYuUEbdUAcl5EABGayY8K96DUTYHibz9R+avrlzvJndpn672HQyxwZ/U7BXfCp3/yXnhsHVeDUpn+YUZWdPTEDlG2xR7qT2vRdQWvexo7e0c6SVXgSPN/TDKFGKzCk5EEC2vEWn8hdt1Lrd7ng2X9h99klF7hoeSXX1TjYHLENJ/ii/3x0+4i5G9cNSEIAdHKVFQ7BD5R0YHnHO6lFHnsjWU/s4KhwXYo5XCsDggkUCrxmaEQ4l6ttGG2pH+xgK7VgZB1K5WEWfrfRXs2365NrP4ftrS8KVEeyKK1VNWZ0E2Li2V7y/Yvfa3tkKRlPX6C70DZYXLURPklfj2Scd3V3xmeZnb6vJ/zf3IVGHJ0rFcyQkA009w1RXM6jyIGgHlGG8AfE07dVisttGEYBxsMUhhLhZEij9XAZS0
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(46966006)(34070700002)(8676002)(83380400001)(478600001)(26005)(426003)(36756003)(54906003)(336012)(5660300002)(4744005)(86362001)(316002)(36906005)(4326008)(6666004)(53546011)(36860700001)(82310400003)(356005)(2616005)(70586007)(16526019)(6916009)(8936002)(186003)(47076005)(82740400003)(7636003)(2906002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 15:45:51.6275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a733387-1131-41b3-efb7-08d8e4a4bfe0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3276
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/10/21 8:02 AM, Petr Machata wrote:
>> diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
>> index 2d4a1e784cf0..8efebf3cb9c7 100644
>> --- a/include/uapi/linux/nexthop.h
>> +++ b/include/uapi/linux/nexthop.h
>> @@ -22,6 +22,7 @@ struct nexthop_grp {
>>  
>>  enum {
>>  	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
>
> Update the above comment that it is for legacy, hash based multipath.

Maybe this would make sense?

	NEXTHOP_GRP_TYPE_MPATH,  /* hash-threshold nexthop group */
