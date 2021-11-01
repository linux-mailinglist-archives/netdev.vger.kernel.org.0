Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8CA441490
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhKAIEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:04:13 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:27424
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229882AbhKAIEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 04:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nf+iK5nFg7AqS9R7AnJ9aWtfPTCn7K36Ltz8odAR75dZXT9/7z8K7ZZ6YTp8AUCLQB7W0Rh5U+CnvoeMQVfy1DZl3fJJmPuCCJ2yU8fm6l47ONmADBbu4fThMNZeAkps88woKqGv7UdAN+qNJlNKnDVyIYpXghoAFlti97OAXVkCooKDsZ+vSjECwVAPf8vVasmj1p2E1QntuQYByokfgaZ4mMOYAoMOQTMzftceBkTblbTy5k3RJgN0asLXW11bipq980zLdUJsmiLqFr0Z2h2LK3rPphye1k2waARnMQVgVx7z08ijT+YhjaS8FHTOkdUEKJ+d4d3wxgXCxN+2XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5o8L+yh3qmbl91rZkvvWedql/DoPG0cu07B9zo0gYE=;
 b=NiKjUETdb+tobc+zUhOxJYsopsRx12zuquyAEWgtYUkqz2ZipMJHiL795aIgcBZYcrg0lat8qON79TiEA9BjjvOgLsdI09MQ3b+fcVthMn1zKVFzmcu3/eGmk4miRp723WP5mZYF9mvTZDxQEuVFXcAkHvaR5yneKru3aipPrayaiCochK+yCAwXS1qmFtoDOzmJQmOjfJTpFTP/Cw9PJaNBtmWtQYdNeU5yJRRjKjA6GyB96oYkfpllYsIAK5UtP4gdKflU2rKn6UVFyxwRAqODfZkXmu1Fv6Y4YOQPDSpLh1JSSvQviK4fpBugz7YXMBUVXi1fvPY7BqgNyAK0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5o8L+yh3qmbl91rZkvvWedql/DoPG0cu07B9zo0gYE=;
 b=PMJP+zZpJRoudKZ4hT5/x+1olzftDt/+GhRpukdBMqm3FP6mG//BSiiSy1B/JUgyrXghmKAilbrHVZPB13NYWMiScqHpvtkPUjLvhOri5w7CiA7Uwkn9v33DMWEtCkhLFFiRt5g1z4re5/wyYe0t4lUwwzUBM6ckpB9o4h/4hGGUMti9MX9fK/v7NTk/TQhOZYiqSGXbPmpyoxBkWiozJV6bjrp4Xn1U/foawIlNeqXSpjd/LpfmgU/J125n2yRXBZr2xraUxUnP4hyC4untMiqwpbT966xyGP0Rn6e1/NU6xYj41H1v4aenfwhvpggDb8Uw9ElTjp098K+/OEg/YA==
Received: from BN6PR16CA0010.namprd16.prod.outlook.com (2603:10b6:404:f5::20)
 by DM6PR12MB2812.namprd12.prod.outlook.com (2603:10b6:5:44::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 08:01:36 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::48) by BN6PR16CA0010.outlook.office365.com
 (2603:10b6:404:f5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Mon, 1 Nov 2021 08:01:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 08:01:36 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 1 Nov 2021 08:01:30 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Oz Shlomo <ozsh@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
In-Reply-To: <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
Date:   Mon, 1 Nov 2021 10:01:28 +0200
Message-ID: <ygnha6io9uef.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9393c244-82b3-4c92-e87f-08d99d0dd3e6
X-MS-TrafficTypeDiagnostic: DM6PR12MB2812:
X-Microsoft-Antispam-PRVS: <DM6PR12MB281237684AFB7F827699F60CA08A9@DM6PR12MB2812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qAwUUbnVyyeIvkS+LoIxnSwQZvaIHJ9Xlt8fP6PXopX+XowKqqAnrKTRxqUV7MiX0Ht5DSKlYfWHAhbfSePh9w4sWZ3xggHaSMzVqNhC5tmbnnWyuxvSkRCrGO79GUodl8ixgPTWFQ3rpI/qqNzhFZHwM2GVciOYzyFtkCHBQlr9UDwsnBmsDLS0cqnvXP/niSq4pkjCxrMxFmX4Gutkr0OcLhso47NI9qS9eB/ZgYfzdP1LqjSmxl2zu76G4+grpL+x9+urjvm5lsiI4V/vcYjyUC9QOtHPxm7331pfLJLuB9P4iixZnzYEpfvya/GuUgaf24KFNIwQTZi/2s5sjgz1R0lMoltDTqNX3WbBfP9SLxRsJAg4siinc0UOavU5lL2fOFd5DlCBC9E2lrNbaauFSGw5sJ7Tvv7y0fS3TgugmlChQAIPghU/HZC2lBIyyh/fqLiEQ4W2q1dsw3gNagkHdp8eXd6feDFNJGDaftePS6sooVu1ZfeVv0/FXscCxHBsp7MHbkeZwKzYzhUtYwezq+AVAwS6aqrhy+sbifyZRWBWITwq109FzmUaW0vZg8OZAt4nnvmGWUHs8n7HghJeyDZuw1+cbY6sMzf3KIOdZ8ov4VDxE7iCwHAV2C6T31lnvi6hDl/cDO4QMHre32NUvvJdRCGyEL9gFpI+srIgzFKSQ+sj6MXLEF3b9aTI7BNkYZn1OijIhx9gAc5+MA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(4326008)(6916009)(47076005)(86362001)(2906002)(83380400001)(316002)(54906003)(4001150100001)(7636003)(508600001)(356005)(5660300002)(8676002)(336012)(2616005)(426003)(70586007)(36860700001)(70206006)(53546011)(186003)(26005)(82310400003)(7696005)(16526019)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 08:01:36.3207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9393c244-82b3-4c92-e87f-08d99d0dd3e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2812
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 31 Oct 2021 at 15:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2021-10-31 05:50, Oz Shlomo wrote:
>> 
>> On 10/28/2021 2:06 PM, Simon Horman wrote:
>>> Baowen Zheng says:
>>>
>>> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
>>> tc actions independent of flows.
>>>
>>> The motivation for this work is to prepare for using TC police action
>>> instances to provide hardware offload of OVS metering feature - which calls
>>> for policers that may be used by multiple flows and whose lifecycle is
>>> independent of any flows that use them.
>>>
>>> This patch includes basic changes to offload drivers to return EOPNOTSUPP
>>> if this feature is used - it is not yet supported by any driver.
>>>
>>> Tc cli command to offload and quote an action:
>>>
>>> tc qdisc del dev $DEV ingress && sleep 1 || true
>>> tc actions delete action police index 99 || true
>>>
>>> tc qdisc add dev $DEV ingress
>>> tc qdisc show dev $DEV ingress
>>>
>>> tc actions add action police index 99 rate 1mbit burst 100k skip_sw
>>> tc actions list action police
>>>
>>> tc filter add dev $DEV protocol ip parent ffff:
>>> flower ip_proto tcp action police index 99
>>> tc -s -d filter show dev $DEV protocol ip parent ffff:
>>> tc filter add dev $DEV protocol ipv6 parent ffff:
>>> flower skip_sw ip_proto tcp action police index 99
>>> tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
>>> tc actions list action police
>>>
>>> tc qdisc del dev $DEV ingress && sleep 1
>>> tc actions delete action police index 99
>>> tc actions list action police
>>>
>> Actions are also (implicitly) instantiated when filters are created.
>> In the following example the mirred action instance (created by the first
>> filter) is shared by the second filter:
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>      ip_proto tcp action mirred egress redirect dev $DEV3
>> tc filter add dev $DEV2 proto ip parent ffff: flower \
>>      ip_proto tcp action mirred index 1
>> 
>
> I sure hope this is supported. At least the discussions so far
> are a nod in that direction...
> I know there is hardware that is not capable of achieving this
> (little CPE type devices) but lets not make that the common case.

Looks like it isn't supported in this change since
tcf_action_offload_add() is only called by tcf_action_init() when BIND
flag is not set (the flag is always set when called from cls code).
Moreover, I don't think it is good idea to support such use-case because
that would require to increase number of calls to driver offload
infrastructure from 1 per filter to 1+number_of_actions, which would
significantly impact insertion rate.
