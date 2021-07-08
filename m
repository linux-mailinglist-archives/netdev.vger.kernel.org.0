Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2B3BF638
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhGHH0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:26:40 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:48771
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229780AbhGHH0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:26:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxG5C+ZzGXBmkLkZnSElWDXKg5HJALaeQ+2qNGdHvKtNFS217FLW+7R9idnRiQ04n8s5Si30Au9XpgEH65xSTP5dXPRe0dRaWdKAvNaWfBgqNX3gBRwW11Yc01RQKNPi0XhusVUaRJruIpzy36qWr4SF6UsGpbtdbXKLPbaHXq0fTfwYJYKkI3eq4cRL4pUEfYnZL+PXN/Stkpth/X0A97yLvkEp/oModCkrNqH1Pm23SElFAqbXhj5Jqm19NUv69ElMVKpyUKU5ClsNRXYEJe4nk57OW62Q5p1gNmjNW7ikcWIj39vf/tlDbOJ9S4WRYngR5X/0JerYDmtl0AWGSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV9u6LgjlIyo3KDBa02rsjE+uJUimBrlAeK7VghADgs=;
 b=gu2UZo2RfKOC6nXsBu6yxdsHfMr0uVGmAslST0aguldQ6+s8ylQCsc1mezZStlggID2tLL2gfRDRwcn/yExNgZ8JTwwBf8TuU6Nt171bfVUse/7muxZNwtAIbVXueNTaEH/PcRdWOaUrJ6sqzX7oAzj505JF0Cs/6rnN3NcZxFDxhFojsEUzoJP5WmAgdk7vPS1R69ACBYh/175iIQIt0YBZkjCPsJIlm1ugiYA6jyiy4apITxyTW21LwbsRfphVtOQgYZYXWpEGzr1JuaaB3+F93LoycJEganK75/ti8uFGHNnC/xADQ66SXobTnvJ3xNQblAkQOHed4Qs9M6kmHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV9u6LgjlIyo3KDBa02rsjE+uJUimBrlAeK7VghADgs=;
 b=qME20CSBFJLcueXM6aFrWDje7V0QiOjTG9OysSAoxf+DokZy3WAq600/JbQjs9LYnCk3kzsxvmbCHFsJbt4B8TzRKSdwjv8PUzsCftarDMPWRTLYuKDqHXfWH3MBpDh88vwmYa8mQNIs0PpZts16QqMh72aG3SJymy/xaSrsVVj9AWV/HwQO/tAv4Rvo7U5JhxAs+VDXmQGl1ZCh3wtK2FnWWA/n7QFQFKe+gctO0W/pjKaK08PtXnDIBTeK5AATRviB5nG6bpMx7lobxzx90q9t1UaXfGckSD0g1Njtvt/W6isIvNBGggABejJX0WFZQNscth6DF9G40v5Ud+MULw==
Received: from BN1PR10CA0007.namprd10.prod.outlook.com (2603:10b6:408:e0::12)
 by BN8PR12MB3284.namprd12.prod.outlook.com (2603:10b6:408:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Thu, 8 Jul
 2021 07:23:57 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0::4) by BN1PR10CA0007.outlook.office365.com
 (2603:10b6:408:e0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Thu, 8 Jul 2021 07:23:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 07:23:57 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 07:23:54 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
From:   Roi Dayan <roid@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
Message-ID: <c17a4e28-5973-7c2a-1fbe-cffcc871a682@nvidia.com>
Date:   Thu, 8 Jul 2021 10:23:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ceb466a-178e-4b05-9f0d-08d941e159a0
X-MS-TrafficTypeDiagnostic: BN8PR12MB3284:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32848316F6C2FB162320B56DB8199@BN8PR12MB3284.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEsJyXCir4xmW5SwUc/iwrED5LzUZrKAAeW/Jgzqsk2q5Z8/UtYxjCK+tehEKZn3W3TidHA5vj7ATM7HYmLwtZwfim7riVThKctxEEx24vPjao10TQa3LszEC2brscQ666jWDHcVGgRjkBVnGnnXbsG5wfoWu+Vw8QadRlhDC8EZ3sKVUwFa/cC1Cjkod5uSYLe8fju5JA23wuFHVw3DBxaxBi8vOZpbM2ktJ34112TCr9WtfXk7+SqtqnbE575e+rXlT719DVoemc2ldJnRvJGYDZM8VbMExK9Jt0dJty9Gp7QRYWU3KY8LsuPJ7I/fdsOnMHkMbyIU2R0EMrJhrHk2q0vkmzMeN+WhB59akGlZLmzladm9DGA/zFr9Cw34AdlDH0cvzSWV+E1Q3DWilTIgzci3jFTsmc/HGmK6iZL+aisnuxo5ojSDgLohAjxQGGkJSL/QLiDO1I1W9WnPepF73jP+c1HZg0FualgJlcKeSQdBO8nx6yNtYDOcO2Ib7FAzClUU+7dcJti43VM63Nc2SOHb9ilsTlXl47hQpqqv5ZCkWSllqm+DrTY+93TXWVQ1Lx2ipeKSM2QK4dKrLlmLFvgG64vk/+HKLzBf+Sr2IuQVODjZXdLd2pnqEomXr5YBB/c8/5VPnnRL1mDoCxMZwKiEWFOJKFa7XEdV6PKOvt9sufAv1KP9MQbXtpFX96Nn72gmWodA/xvjgPg/vu4cAi7j3wIaHmpeKUGKdq0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(36840700001)(46966006)(110136005)(356005)(186003)(83380400001)(54906003)(36756003)(31686004)(16526019)(31696002)(53546011)(82310400003)(336012)(316002)(478600001)(7636003)(70206006)(36860700001)(36906005)(4326008)(426003)(2906002)(2616005)(26005)(86362001)(70586007)(8936002)(5660300002)(47076005)(16576012)(8676002)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 07:23:57.4962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ceb466a-178e-4b05-9f0d-08d941e159a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3284
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 9:57 AM, Roi Dayan wrote:
> 
> 
> On 2021-07-07 9:53 AM, Hangbin Liu wrote:
>> On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
>>> my 2 cents:
>>>
>>> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output 
>>> only to show "index", and
>>> preserve the human-readable printout iproute and kselftests? besides 
>>> avoiding failures because
>>> of mismatching kselftests / iproute, this would preserve 
>>> functionality of scripts that
>>> configure / dump the "police" action. WDYT?
>>
>> +1
>>
> 
> 
> why not fix the kselftest to look for the correct output?
> 
> all actions output unsigned as the index.
> though I did find an issue with the fp output that you pasted
> that I missed.
> 
> 
>          action order 0: police   index 1 rate 1Kbit burst 10Kb mtu 2Kb 
> action reclassify overhead 0 ref 1 bind 0
> 
> 
> You asked about the \t before index and actually there is a missing
> print_nl() call before printing index and the rest as in the other
> actions.
> 
> then the match should be something like this
> 
>      "matchPattern": "action order [0-9]*: police.*index 0x1 rate 1Kbit 
> burst 10Kb"

actually its

    "matchPattern": "action order [0-9]*: police.*index 1 rate 1Kbit 
burst 10Kb"

also i found some selftest fail for "overhead" matching as i used
print_uint() instead of print_size().

let me send a fix for this with fix for the kselftest of police.json
i think its better to have the consistent output of all actions
instead of police using hex for the instance number.
