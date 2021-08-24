Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4AD3F55B3
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhHXCOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:14:25 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:64800
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233657AbhHXCOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 22:14:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MreZf65L+4UM19IuJ3M/81G9GUKkQcvdg0fHt6FWapvbt4vfkIBvxDUsF7xHKlcaRk7pAy4AJVA22/yt48gvwb4aC1qwe6FapicZbhcHsdm8kUNTw1OqmgWJg75Hv4B/07nUNSGqqxrEf89HZEucKu5QyyhWTg57h+1hT0e07JrVJp4h8Xsc376i/jRWVZ9EzUim1bYT6njScbYkdmysSM7uPHQkK52EldNyDN/tDiqF2uaRKvpJjkCTcUZByswc6dcmtZdJl6rx/aTpT1viCeKuWvpqz6Zr9f3NQrvZl9STBpOYtOcGaa/9g6pPPnD38FwMs+VvRHzzpFkJD7TfhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0gxXJEtEw/EnMRpJnekErvv9tCS4cE6oGdM1drpUyA=;
 b=lC9CTe/6lZ/1Cejv8axli5CpH1PmmS+UON7d94snxwkDwY6Hh2cCWw2xQR2m5m++/4K3JNdJ1I3pIWIVIHzqQW7Bd9aCWqBA6i7swM9RSqRz2B6Fplhrti95MaIGrWqjr+TDWFSj24KQLWiSgb92tE6yofD3wta/iGHLZv7+ThBubAuX5ZE0sDBRCIQlY41SR3XCRmivz9+O3tputvfBU5i7i3FwhWzDGaXmvmpFnJFP5HbP4rBnm+fnnKuEj/4grevj9l6bG+kaVs3A02wP8YhUflEB1rxkdws/PgmWIBtiWMfzu39y1lTXJjpaM3hYHw9NWlcq0AKVxrnO+cTfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0gxXJEtEw/EnMRpJnekErvv9tCS4cE6oGdM1drpUyA=;
 b=n2tGRpxy+zqzJsOm5TQ78srdRv8G5mNDW7861E95pcsVat5t7mlJaE6vmKfz/Cmw0gub7iMBsGdMYwCULdLYuV9EF1509kEX7S1yx42modTAgS1SRG9ALS1+JRfCEWjRgXtLMe2HpOouUEZCcRqavrn14Fxo5Lxay70qoWcWrMk77depBPzzCmAdCVlKlm+LEaIW9c85d5golygFhE3HQu8zvNsXtkXFFTxTSP6RZhEazzIZ59faOfTohp1QMobdzzbcsyXKCpAgKA2QU82r7DZMxlFUM8xlaQgrMl/6mAH4YdA/vYEES923dDPGDrez7N4c4J8e/gXWCSv3+X+iNw==
Received: from BN0PR04CA0072.namprd04.prod.outlook.com (2603:10b6:408:ea::17)
 by MN2PR12MB3166.namprd12.prod.outlook.com (2603:10b6:208:106::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 02:13:39 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::a9) by BN0PR04CA0072.outlook.office365.com
 (2603:10b6:408:ea::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 24 Aug 2021 02:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 02:13:39 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 02:13:39 +0000
Received: from [172.27.8.76] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 02:13:36 +0000
Subject: Re: [PATCH rdma-next 10/10] RDMA/nldev: Add support to get current
 enabled optional counters
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <dledford@redhat.com>, <saeedm@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-11-markzhang@nvidia.com>
 <20210823194459.GC1006065@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <29c4973e-2e9b-9ea1-e8f4-c10e73671f21@nvidia.com>
Date:   Tue, 24 Aug 2021 10:13:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823194459.GC1006065@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23c1fbbe-6d06-4fdd-8e13-08d966a4c9fc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3166:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3166585784D5AE50C1ED9821C7C59@MN2PR12MB3166.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SToYw0DXKQnnzaB0N+XxgA4yJPDgApuV2YCJYRGPIQAHr4CCKq+x1oILmp1m0DGhCHtubzwok7YWb1Aw2Z9VjgtLqUkBW5/rewmK6vE1Ge/m7h1ZrieqYlUuQReUMsVhNiBlFzFnhtb0v75aAPOibCuts1/eOTGDUQwk6uK10hq/eml8mUbcsBZqvPdYsE0oQRjnO+3dQpuPdgAh0w7drAI9vQKQK0bXasdVV/dDs/Fz0K9AikJ0tZsamDethZrufwU3Zzd8qxXPpjqFiOLroyPEOAXCjjx6DV/THfm5FN42zZ9CaaDKepjpVlYUcGZSsdBOHRtSW3flF9XOpW7zF/6tIgSuhachHyWxQD5eAUzouHFs+dmeJntI9AOB5o+JPe1X0gBg7NSPQ/Y8Mevj/Rwjf2BOHWOycgN9ERygcCCz9Y7DTgUZb0kNlJbPD8tMTcWkmgUxRrApFC6JquhRtRq+TUaDLxmUQzz8t2PcXI+Hw6eONVCJZLy4kQIDaTN/n6biMWvno3uuMjO07kiQHK7X3PG8Gr8yF5+OuIxuZj8BMQ8AZ4Lz7/9DRp98cjHRQsH6dtBGWPGDnlg7TRQaYGhy1MeiI9Gkewo02qdDxGe919eVt8aru/i7RY9w4olROylEYshMmVnZU4XIDzfLS9GGU/UurJk4UQgr72Te3ZYGCyrK24hY+Y2FCFkjRgEVZWzy1PaKJbXSYIXu0AgHv41nnLzFKD6n2LgYd4kJFpU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(54906003)(8936002)(7636003)(316002)(4326008)(6636002)(4744005)(70206006)(356005)(53546011)(86362001)(5660300002)(6862004)(37006003)(107886003)(16576012)(8676002)(36906005)(36756003)(508600001)(47076005)(31686004)(2616005)(36860700001)(2906002)(186003)(336012)(70586007)(426003)(82310400003)(26005)(16526019)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 02:13:39.7558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c1fbbe-6d06-4fdd-8e13-08d966a4c9fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3166
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/2021 3:44 AM, Jason Gunthorpe wrote:
> On Wed, Aug 18, 2021 at 02:24:28PM +0300, Mark Zhang wrote:
> 
>> diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
>> index 79e6ca87d2e0..57f39d8fe434 100644
>> +++ b/include/uapi/rdma/rdma_netlink.h
>> @@ -557,6 +557,8 @@ enum rdma_nldev_attr {
>>   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY,	/* nested table */
>>   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,	/* string */
>>   	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,	/* u64 */
>> +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST,		/* u8 */
>> +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED,	/* u8 */
> 
> See, here - shouldn't manipulation of MODE_LIST be done by a normal
> RDMA_NLDEV_CMD_STAT_SET with the new MODE_LIST array? This doesn't seem
> netlinky at all..

Both of them are flags and this is a "get" operation; "MODE_LIST" asks 
kernel to return currently enabled op-counters, "MODE_LIST_SUPPORTED" 
asks kernel to return supported op-counters. Maybe the macro name are 
not good?

