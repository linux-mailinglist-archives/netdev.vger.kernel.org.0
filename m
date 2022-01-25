Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A32449AF45
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455876AbiAYJHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:47 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:32864
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1454601AbiAYJCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:02:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzkWuyROLMMb7NEtb+dIKmH6sQiZKv/mqrOLDJo5o26x4DCAAIBdlZa7SGsKawtEHKwYoQbAxU5r5bUB3dWWNjZGIwBo7/mzBTttf48Kpvnd2/IJT7WP0SQTcED/R6pW2UnJdfZBKNj76VyX3eJRgX1KOIGBcy8hCLZYhS45+EQJWDqCNnyoMMCKP2p3q2HCsIT29e3plD//EdguOmemATi1XkqQwS5SxpZY36ooQtVpEVHm2qO+u2xZJojo+FVUfLkwnR54omWeXOfvBzTa6svjKdNcE/XnszqlNKW6CI899jUHsq5ZEspYTJxSWWUIoFtXWqzSlOJtLmZAHI43Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0+snOPrwPmIcfSkeIkGiMB7ydHFtx1Q3E/CUB0RnoQ=;
 b=MurGswS6oPCQIPtd689MOZpLjFiSr4KkP4gI8sWbox/Xw97rOOBG4k2PisXj5HFp3+LubHz1IjjcqYEUD6HJqLA2SlZkcZqZzkCd9EebPKmvdFYieu29lhtMbEb2pA5qarcUvOpjTOQhKGL9YwM5nYU4DFEzYY72cDtud6lIbtqYJzOwJLuc+GHtWCqOs95sYwwysASALfYpvrxC1nfcA6hggvTs/zFF9tzaZS1Q45Xf3598z8kLV/4vexQor/R8uCTAOUj/QMhnuIt15ZjaNJfvX0Ao6eiRvqDr9ZCycJDeIh1ittGyDcC2tUfr7ixvV6o4fqJdOg/tX+tlfwLOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0+snOPrwPmIcfSkeIkGiMB7ydHFtx1Q3E/CUB0RnoQ=;
 b=Mwu+14zMuAivEcydnEP6MCDduZO9Jvco8zj2IbrrnAqgVJdR5qdYJN82vCp4P9QX865wYLBoubnGY1gT6KhTdOpP6ReBLtC4uyVpqX2usNNeogzKr7tDN+wFybMyn4SxkFtFMi1i3xgAi/83jcV7wGefNBpQSezFSbu2+a0wBZ3iuwMZSU7GaQJQU4ql8asyhPQo5HJa5na/QYSbUWiV+277/vHW0qznnismh3xlDzgmqEb+pmZ6omHXDC9haqEV0KfiZyHJZMsCyYo//wDM0IIJq0BlRKgLnMDy1iaNFFXV5WZ+MepcTWLySgYmWNYIQ1U/56EnQCLYa6V6FckKHg==
Received: from BN6PR22CA0072.namprd22.prod.outlook.com (2603:10b6:404:ca::34)
 by MWHPR12MB1774.namprd12.prod.outlook.com (2603:10b6:300:112::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 09:02:15 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::ad) by BN6PR22CA0072.outlook.office365.com
 (2603:10b6:404:ca::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Tue, 25 Jan 2022 09:02:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 09:02:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 25 Jan
 2022 09:02:14 +0000
Received: from [172.27.12.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 25 Jan 2022
 01:02:08 -0800
Message-ID: <8eac3258-8b2a-37eb-2a1e-6a71d5d1f859@nvidia.com>
Date:   Tue, 25 Jan 2022 11:02:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v9] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jay.vosburgh@canonical.com>, <huyd12@chinatelecom.cn>
References: <20220125023755.94837-1-sunshouxin@chinatelecom.cn>
 <d0afa956-6852-2749-fce8-2a3e06cae556@nvidia.com>
In-Reply-To: <d0afa956-6852-2749-fce8-2a3e06cae556@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail202.nvidia.com (10.126.190.181) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a12e97e-2006-4faf-7db2-08d9dfe161c0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1774:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1774ACCDDDC337986EAE47C5DF5F9@MWHPR12MB1774.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMkGsa60DZ7KZcBwZmy16gxniR06NY4jVfC1VSuzGhW2AGKjd9Lp4PpFlOjLEfGVsJWGKP0xz4U84GU4jZJbg+FJFsFKTEf+rwtWCzB2Cy1oGyoDfntLIKQzx+hhiFI7OuNeoW2InAZeUk5vswyqUpqaOSBuu+IfimTvBz4CS3ch0h7vJsDYlSnJVHT7ay+/Xr+m+iFY5N4owSl5DRNDKyv0OtPQ4rJuYz8+1QozBZSy4SqZa/9gwbGcqyalmd93CnU9SYG1u9a7pXO89SxYbYxdGJNumA7I8nrJJSSWAaHlZq0Z9ZrKfv3QI9ARNxcipoFsZHX7jy/6XkBcB+tJ0upskVB0anAwLxkiA07eTOt5YK9yfmqDorTnySpZxtITamHt3T6yCO8k7bkWUb44y91+lT5lME5p7zMXZSE9fKufmAgCDxEs8uoKh/oyzOL7ZelK+C9XYqlQYHJO48X33GkndMAdCIeEgrD5kFAHcCWrtOBfcZXyL+Y2d3YvkfUXEIZHlNJ5zDqVYBqSAqaTcCSPVXCcWcQC+Z7lqIs+eILehdlAYbPOAtxx7eLdc9RyYI5/TmntapzrSaBx1z1B8N/kKK36rzFvpqYlq+nikkQJcPu9t9kKYVpRh0dwW3P9uxUP2EaOjiEPTOtWLt78S4nrxAvZGu2Ztw5Jf9F9Gq/Q3ppzEPFwtxcRvch81cCEK8GfCHKHPbaWn26Nm5Mu3+pkWJ7XoHifYt8FtTSFICs6Po7uuWWm5mgxYw7Li6w4Z6RjBJGxLbaRwEISCqSJbNexZVYOsp8r3Tt2Ui1KeoaxEqVWdTW1Fk7jznzOoKzT0m8nGiamAx+xGtOTpNhMQA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(4326008)(86362001)(82310400004)(5660300002)(16576012)(7416002)(316002)(83380400001)(53546011)(31686004)(40460700003)(81166007)(70586007)(70206006)(36860700001)(508600001)(8676002)(2906002)(426003)(47076005)(26005)(336012)(16526019)(31696002)(356005)(6666004)(36756003)(110136005)(2616005)(54906003)(8936002)(186003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 09:02:14.8557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a12e97e-2006-4faf-7db2-08d9dfe161c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1774
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 10:51, Nikolay Aleksandrov wrote:
> On 25/01/2022 04:37, Sun Shouxin wrote:
>> Since ipv6 neighbor solicitation and advertisement messages
>> isn't handled gracefully in bond6 driver, we can see packet
>> drop due to inconsistency between mac address in the option
>> message and source MAC .
>>
>> Another examples is ipv6 neighbor solicitation and advertisement
>> messages from VM via tap attached to host bridge, the src mac
>> might be changed through balance-alb mode, but it is not synced
>> with Link-layer address in the option message.
>>
>> The patch implements bond6's tx handle for ipv6 neighbor
>> solicitation and advertisement messages.
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>>  drivers/net/bonding/bond_alb.c | 38 +++++++++++++++++++++++++++++++++-
>>  1 file changed, 37 insertions(+), 1 deletion(-)
>>
[snip]

Also forgot to mention, you should add a changelog between patch versions.
You can add it below the --- marker so it won't be included in the commit
message. Otherwise it's hard to track how the patch reached v9 and what
changed between versions.

E.g. v8 -> v9: <changed blah>

Thanks,
 Nik



