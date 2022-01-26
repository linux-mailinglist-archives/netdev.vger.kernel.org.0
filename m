Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8066E49C90C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiAZLr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:47:58 -0500
Received: from mail-dm3nam07on2067.outbound.protection.outlook.com ([40.107.95.67]:7008
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232111AbiAZLr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 06:47:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPK0FqYf/grozAnx0Jk0BvyQvvIwGugFmT/atR6eN9aLa9b7rUvMUhxbKeShVuB7AcgYPJM/AAH71ZXjzHZYDNs8LZV+5OWO34PA+GvaELiSJoDLCyirjyYe3mfqXOvMYlCfrLXd0qNoqa9XT4YsWpTfWX7mRxdL2ZgbcN7scckD4KKQFHnn5l58ReMejVq05XYw0RWsHcU3F80zr+IUrbQKF8OHSb0+B0QE8yK6z7J48IUI/M9UXL3sI/bFYMcwDHFN2ZNzTX6ipm5YV5Wgopw4y81Jev2V3II3khwxpDK7o7/wgrV7KtB7rrICJSC+pkEwdTkojY5UfNgNkUspSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBU0mFLnrxNzUJLTuzxW7CrmGo9YeBtK4S7blNHscPw=;
 b=Sur6gvcza4TzUlrj8fpn4lJ6hCokHmtfVVGKhmssCAFshAJKRuc9QeIFejk+8ZOHf44L0Qd3Z+OPbdW6ff1yTlRnDODEdENLxWc/s3wEMLXy2FenrC2nH/m8tZ79IVrVug/QMcy5DlAmrhy7zd/D6uIvmkhMD/anUoBQhXaOehJNA4UriO0kwlpy+KleIIJTUX45uVOYMlXNKGXpV/id3g0DdDaF4t9uY1jeaG33AuKV1r8u3Cl6dctOitl3f6cVbocKpDp6304lXVH1AULcVRtndI7/b4L3xVPXyOjJEQDyDLiW69i1dLSON/SI+jlG0O3FrcRJZFyYWUkF0mOokA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBU0mFLnrxNzUJLTuzxW7CrmGo9YeBtK4S7blNHscPw=;
 b=TmQZrrkjt26iAyUpAo/UkoR7iX/z4jLIs6FoZag3zzYh0fLFIjvsoF4HrTXqBHx1CjGqfjEJ0y1QeBj1tdkWxXU3yC9G99LJ+397JsVxbPzLn7WvfHv0mE6fgzpbjcwjg2pDdT8yresE9C2VYRTFATrPYee3sqOs8JulBuDGRCOp3uzi2cJ/Xwv5SLKDD0cHjyGpchP9kgrdDCwgykhx+m85ZWoKzKDQIUcDsx6es6L99rmybNrsUNcARZLssDJse6wIFzQo1eTuoA0EOH9mdLAVjznjh2xvt68R9aYayakS7ZFY1Nunr+OUtg34brRNOVj2TXiNIsyDLupUY/LREA==
Received: from BN9PR03CA0312.namprd03.prod.outlook.com (2603:10b6:408:112::17)
 by BL0PR12MB4674.namprd12.prod.outlook.com (2603:10b6:207:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 26 Jan
 2022 11:47:56 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::68) by BN9PR03CA0312.outlook.office365.com
 (2603:10b6:408:112::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Wed, 26 Jan 2022 11:47:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 11:47:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 11:47:53 +0000
Received: from [172.27.15.168] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 03:47:49 -0800
Message-ID: <66d6c646-d71d-91d3-993c-fc542bf77e0f@nvidia.com>
Date:   Wed, 26 Jan 2022 13:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC net-next 0/5] bonding: add IPv6 NS/NA monitor support
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7924ea6f-ee20-4db7-5207-08d9e0c1b13b
X-MS-TrafficTypeDiagnostic: BL0PR12MB4674:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB46746A57D1627B746E786BEDDF209@BL0PR12MB4674.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dlVjOqorOCs1dzOtfNrDUt/IwXxPON4zDRtvkzf3knD5qGHFEug2RABQ2DrGEaKM2Ky4OkfOtnn41lI6TTqtftah2MrcYPPA/qjUwVcRv0rHnnm8EGb3FgL4jIFveV+Dn63Sb7l6WTE5jDStWv+jri+xjR57dqm/FUunQhHc9kFVRNiOWWrJwXyRqSoIUWqVzHRg1FhVqcXF94+FiHNdKwuhNvGrCNHSGyU+fuWAIa0E8gFJ+5rscqhBG6vSeHz8OwawyHqqFKCNZVMgnDLJdk45CvUxwdF8GBl3A4ILYyDrEpjh8Ed5d5Lnceu0usKGy94nGF9Jp6blcUAXNCOXGAj2s689PTcEafqGDzxTPsIrmvDYa+P7BcMk9F6HfAONpDUXeQqILrI8l15zj0Shwfeutpq0wmjSv0+rkPHCvVx+Na1CF1Hkk6P6DY2aMWyAv0QYGFaaso1z0EQsSVFYqeKyvvbdimJwg+gu0XnjstiRZ3uIbdHUhid/2oFVbnyANmWJbSVzAp44bO50cn9uhcgSSSGHtL0rEqA7x9gblaPnhBIPdjxIBXhamKBKz6kOz/TZUcg3LH38fB+TqYeLaDqTlA/pAtns1KCOLNQyex8zx64Lwy9LHr219ZD72QLwYJv99zazmCpHF+g2d/0XlP9geKmwmG+jiI+h8+gTOHNx0ynen3IElVkj1gGxXyvcroR8oR/PPeGKDXig1KmmkMnmpUKhPJr2LK3RDWaBp+SHNDE1uLlT3AflcJ2Z7DJZfJg9nnZqBdHYdL7rdqyXif3XFd5HJRB4ARHVrI2YIbwKgTNZYU/DDWVQS+FcKBTB/xJ5vWNEPQ0CUdU2uI99l+fFJb5FiX8URlR1NV8Lgw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(53546011)(81166007)(356005)(70586007)(70206006)(4326008)(8936002)(8676002)(31696002)(54906003)(110136005)(16576012)(86362001)(316002)(966005)(40460700003)(6666004)(508600001)(426003)(336012)(47076005)(36860700001)(31686004)(82310400004)(83380400001)(2906002)(36756003)(2616005)(5660300002)(186003)(16526019)(26005)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 11:47:55.4213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7924ea6f-ee20-4db7-5207-08d9e0c1b13b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 09:35, Hangbin Liu wrote:
> This is an RFC of adding IPv6 NS/NA monitor support for bonding. I
> posted a draft patch before[1]. But that patch is too big and David
> Ahern suggested to split it smaller. So I split the previous patch
> to 5 small ones, maybe not very good :)
> 
> The iproute2 patch is here [2].
> 
> This patch add bond IPv6 NS/NA monitor support. A new option
> ns_ip6_target is added, which is similar with arp_ip_target.
> The IPv6 NS/NA monitor will take effect when there is a valid IPv6
> address. And ARP monitor will stop working.
> 
> A new field struct in6_addr ip6_addr is added to struct bond_opt_value
> for IPv6 support. Thus __bond_opt_init() is also updated to check
> string, addr first.
> 
> Function bond_handle_vlan() is split from bond_arp_send() for both
> IPv4/IPv6 usage.
> 
> To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
> are exported.
> 
> [1] https://lore.kernel.org/netdev/20211124071854.1400032-1-liuhangbin@gmail.com
> [2] https://lore.kernel.org/netdev/20211124071854.1400032-2-liuhangbin@gmail.com
> 
> Hangbin Liu (5):
>   ipv6: separate ndisc_ns_create() from ndisc_send_ns()
>   Bonding: split bond_handle_vlan from bond_arp_send
>   bonding: add ip6_addr for bond_opt_value
>   bonding: add new parameter ns_targets
>   bonding: add new option ns_ip6_target
> 
>  Documentation/networking/bonding.rst |  11 ++
>  drivers/net/bonding/bond_main.c      | 266 ++++++++++++++++++++++++---
>  drivers/net/bonding/bond_netlink.c   |  55 ++++++
>  drivers/net/bonding/bond_options.c   | 142 +++++++++++++-
>  drivers/net/bonding/bond_sysfs.c     |  22 +++
>  include/net/bond_options.h           |  14 +-
>  include/net/bonding.h                |  36 ++++
>  include/net/ndisc.h                  |   5 +
>  include/uapi/linux/if_link.h         |   1 +
>  net/ipv6/ndisc.c                     |  45 +++--
>  tools/include/uapi/linux/if_link.h   |   1 +
>  11 files changed, 549 insertions(+), 49 deletions(-)
> 

Hi,
I'd imagine such option to work alongside ARP, i.e. to be able to have both
ARP and ND targets at the same time. On Rx you can choose which one to check
based on the protocol, at Tx the same. Then you can reuse and extend most of the
current arp procedures to handle IPv6 as well. And most of all remove these ifs
all around the code:
+		if (bond_slave_is_up(slave)) {
+			if (bond_do_ns_validate(bond))
+				bond_ns_send_all(bond, slave);
+			else
+				bond_arp_send_all(bond, slave);
+		}

and just have one procedure that handles both if there are any targets for that protocol.
That will completely remove the need for bond_do_ns_validate() helper.

Also define BOND_MAX_ND_TARGETS as BOND_MAX_ARP_TARGETS just for the namesake.

Another cosmetic nit: adjust for reverse xmas tree ordering of local variables all over.

Cheers,
 Nik



