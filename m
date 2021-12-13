Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149364734E1
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 20:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhLMTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 14:22:07 -0500
Received: from mail-dm3nam07on2050.outbound.protection.outlook.com ([40.107.95.50]:43124
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242301AbhLMTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 14:22:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iADiqHZTcPP3+EwiInogu7W7oa8izGRB1Q0R0G1Gp/JS7FDqN7rueOZzfgn/hYMmqUTTsZnid6okChe23x+phFLL4XP7mMvYgjIowkqWO650/C8cQqKC5s0+AZhWOqFV90WUZYFtRDxmcqO3FOkFYnLxX97Z8PFxDdlHAN3Dhp35EG5OAe0R/PHiIyM1wk3uQHjjd5DFnwbJ/lH+d1Gu3eSKCrPxZWv5sk+dlL38qSh1rDDylPU1vVe4wg639g9MssaR8o/nAv9nRn1HgexYG1sOJkgKUCKhTPTA/fd3v8QtC8kgLqj7j6/VtC0tkSkTTHZckRxlXFoPmW//Ogbnag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XddImDywvqZCihuZTdupwXYPn5W9/U30/BkKgybABwM=;
 b=Zbu1ttI7V9EbWLyjjvKAUou2qo2jUYRBq60BDRYCSEFkf9M7qFg5hcqj6b3yzKclJqwU8UMpPTkkbhwos7skzf/65n6Wj6Kp83Ust70kanPqLQ1Yt8YhruiWvy9PiacZSxUH96PET3XEuJdj+wmG4ga9pMXJ2K/iXKKZCdwjwB35dvkM5jN8cZfISTxVSfGCHnCrBXBhyDCvq3URPZMRZhS2WOuTimfjES6wn6nk45Ku9/Z4KbA5W6RvLLzrCwXv5FqlzQnwCMHeg5l94r1SYKb7pci00vEM8Y8xEC459xlMWjK+YQACpGFCv+V37s+3VP4DrsOuQlu+mAg+QxK/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XddImDywvqZCihuZTdupwXYPn5W9/U30/BkKgybABwM=;
 b=OiuL+2Rzz928F09frp9rAbObUw3FDSh/Uj3qSdAe7JX3Dy1e/+Jrm83vdm+BHjUQRtZXYl/YeFnykHUl/mu0KsuAiZkjgs7LnErbjJJM9kuaIVTeF0EY0re1pLvk19CW0Juhc+JCJuRZ5QO1sco+s7z8riG9QH+Y6WNfAYsuNwg9RzclTaoEYQGfpuxKux8Fsscfnau83Lvw6Yc+yi1QqreQ5x6liF5ueOAT9dG0LF9sMIO3AjKqSlalrqLtdiicSqrxgnKkgzlevE8dbR7K3sTs4BdpAE0d2gYr4lT6RdCwp54eNE04SVUB35s4ge5Mx3EkacNoyFoZs4OxffPzkA==
Received: from BN6PR20CA0072.namprd20.prod.outlook.com (2603:10b6:404:151::34)
 by MWHPR1201MB0254.namprd12.prod.outlook.com (2603:10b6:301:57::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 19:22:04 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::5c) by BN6PR20CA0072.outlook.office365.com
 (2603:10b6:404:151::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Mon, 13 Dec 2021 19:22:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 19:22:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Dec
 2021 19:22:02 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Mon, 13 Dec 2021 11:21:57 -0800
References: <20211209092806.12336-1-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, "Oz Shlomo" <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [PATCH v6 net-next 00/12] allow user to offload tc action to
 net device
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
Date:   Mon, 13 Dec 2021 21:21:54 +0200
Message-ID: <ygnhzgp4nwdp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceb784ce-6873-4ce4-03d5-08d9be6dd887
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0254:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02546E3B83DE4871F97F04DAA0749@MWHPR1201MB0254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRpx+nDvjU3yq+Qphop4RqusnEH5kBqQaA2aWtC9kUh9d/cKfgJrNOyAmnYjVBDiDacKw4zYFTOcmVkb5jkQ8qsV9BneN5O0W+W0BbX+Td8e3L3QVx+FMRxJRsFsut9fQfSgYWVNN21zbOVk95la7Ia8ODebCMQolUetIjlNQRJsk+EbepiObTkYS/fW15tw96+z1Jv1VK0yqobIy7Fs/o2xlU+cZqo3ulW7a7WVCJwAgBXwaLVGgvRqHKH2LeIsb73iIjJ+10bcO6TeqrwGUDC5a/Ton7RYUdEZGApgll02KgLYsJlJVCsB8k8LHLAcHZzG6nJHRtYsgIVoc8cWO+fxSXN3eFxW7L/gZq70+wWuWGeElpA/rD4tp840GPUYdKG69feln/8Lid19hqrthnuAV3OsGzMOsX5ogTpfBOf73+nQTjl8EK98Xc7oKrVqNTgr/c42k7pqaFeVpJozjr2Zz9ZVfR3jMK9aUondKQrJ2nJ/65ssiPlDl9/ZYaTVl5Svs+CSL2GILAB1PkKLdE9ObX/Mw2CMS6Uj9fM7uyDOpiQtIDo9dWQx/YWLpvxKp3oZwEtGYsk0z7rJzP9SXgNkMcETb/GkOv07PEVtCdyyY/7n969XzOyboyANorlljbGsRQ2pZ5yBkV2LFrv2NL26w5vLAdZMgiLFgwINmQF6HeToc+bUxUiJyKUmADLkk6TWle6+bT/lUqFeFzY4CF/3xDUEQokQ9veVN4CK/OyrFbwJvZWjAlgIP+HyO5udA7JPT7FYdaYv/fr9fV1eZwchE5eoLmOOMMqhGwXGzr8=
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(36756003)(7696005)(5660300002)(83380400001)(426003)(86362001)(2906002)(8936002)(6666004)(40460700001)(82310400004)(4326008)(70206006)(316002)(16526019)(336012)(186003)(70586007)(356005)(7636003)(26005)(54906003)(36860700001)(34070700002)(47076005)(508600001)(8676002)(6916009)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 19:22:03.8075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb784ce-6873-4ce4-03d5-08d9be6dd887
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 09 Dec 2021 at 11:27, Simon Horman <simon.horman@corigine.com> wrote:
> Baowen Zheng says:
>
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
>
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used by multiple flows and whose lifecycle is
> independent of any flows that use them.
>
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
>
> Tc cli command to offload and quote an action:
>
>  # tc qdisc del dev $DEV ingress && sleep 1 || true
>  # tc actions delete action police index 200 || true
>
>  # tc qdisc add dev $DEV ingress
>  # tc qdisc show dev $DEV ingress
>
>  # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
>  # tc -s -d actions list action police
>  total acts 1
>
>          action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify 
>          overhead 0b linklayer ethernet
>          ref 1 bind 0  installed 142 sec used 0 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
>          skip_sw in_hw in_hw_count 1
>          used_hw_stats delayed
>
>  # tc filter add dev $DEV protocol ip parent ffff: \
>          flower skip_sw ip_proto tcp action police index 200
>  # tc -s -d filter show dev $DEV protocol ip parent ffff:
>  filter pref 49152 flower chain 0
>  filter pref 49152 flower chain 0 handle 0x1
>    eth_type ipv4
>    ip_proto tcp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
>          reclassify overhead 0b linklayer ethernet
>          ref 2 bind 1  installed 300 sec used 0 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
>          skip_sw in_hw in_hw_count 1
>          used_hw_stats delayed
>
>  # tc filter add dev $DEV protocol ipv6 parent ffff: \
>          flower skip_sw ip_proto tcp action police index 200
>  # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
>    filter pref 49151 flower chain 0
>    filter pref 49151 flower chain 0 handle 0x1
>    eth_type ipv6
>    ip_proto tcp
>    skip_sw
>    in_hw in_hw_count 1
>          action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
>          reclassify overhead 0b linklayer ethernet
>          ref 3 bind 2  installed 761 sec used 0 sec
>          Action statistics:
>          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>          backlog 0b 0p requeues 0
>          skip_sw in_hw in_hw_count 1
>          used_hw_stats delayed
>
>  # tc -s -d actions list action police
>  total acts 1
>
>           action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
>           ref 3 bind 2  installed 917 sec used 0 sec
>           Action statistics:
>           Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>           backlog 0b 0p requeues 0
>           skip_sw in_hw in_hw_count 1
>          used_hw_stats delayed
>
> Changes compared to v5 patches:
> * Fix issue reported by Dan Carpenter found using Smatch.

Hi,

Sorry for late response to this and previous version. From my side
series LGTM besides points raised by Jamal and Roi.

Regards,
Vlad

[...]

