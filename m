Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4C4A6FB9
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiBBLQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:16:03 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:23776
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235137AbiBBLQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 06:16:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK3XBMRQdalg9Fum0Gwnbi73d6xrgnb9Eum/fm2LHURDT0WQLoejIVOL8KpeA96iwmsoqJ+Monx3PyhM7htHs0HcSBIWi19Dfn1irSpADDnhIzK2btChQvKTC32Ddw1UTq9aBRsziqdZ7n5+uwvG2m5qRlXbZPY0BEjVVWei1DbAjgqnmpbzpFbe7Hrm5qYbxWkRN6iFbSpWxwmbHKkP39CpEaz0JppvUzkblBYtYFwUVPBOMv3L+6RRKlZzmcHGAJ+ymhsdjJ4JiAjl5UmjTImglecA7kNEO+Bpjx6EyqvV1ygxMCEP53+aIRD2JfHeV574EC9lWzouadQP0s7y3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqW5QH51jygrgCCBXksbeYRRmO/1jOr/5QNmZdCPL3U=;
 b=LTRKrnWVaBpX3XeuK9FKVkq7hCrRqxtoM4zNVb2FgRfxsAWAzsaSzAb6Lf6OrnIx0qgQy2R/3eeRP9tXTXQIu548xrzn7p8mDFqIW1oWkWePw9Z39Ph6VhhksGOX80z0SmganvYaVc9j6EM/R56tQDyURwK/o7LfHqrry4MQrYkTTSNRYr3Q6sCkVONpy7EPIpDF6X6WycVV0HTU2kYmRzzf0YqcWkzVOX3o4LGwR5NcIcB7nsO8nmUsypTzwM8fNwqc+1UTnSYhgPU3HnefGeMrel03Jf7msYLLcIgCw14630L3CJjWENKXhiL+kDnAPA8Z10y6D6vytDFTiYwHyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqW5QH51jygrgCCBXksbeYRRmO/1jOr/5QNmZdCPL3U=;
 b=P5+EbMaBuAzaoMcd/b+Jt0EaGdESeuw1NMU/sHHGD1ze8KYvbVZcWs6e8lc/IzMdn0JathZ6RBfxZ3VFglpnnxwHlmas6SqlosuDWHbsPo3WPHiZyyRngVt5MOg0QRsGjXLMKDd1H79qq+Gr2RvaXNPGOX66OUfQiAmn1Jl2/IBzDpsO57IPNzPhtgrDWT/9fxX/1aW72WrFBSzKi/EgzfNyu2YiKfI3jK9gpYlCtrNxpSLzvDPX/vNLZXPfgmlzSUp/h0zbqBoQtjftcXNqltcCicaK1igbBe+81rATH4yRJB+zp1M0YEm49UjN2FsHmxFeyXxKNcOModTegdYh+w==
Received: from BN9PR03CA0559.namprd03.prod.outlook.com (2603:10b6:408:138::24)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 11:16:00 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::69) by BN9PR03CA0559.outlook.office365.com
 (2603:10b6:408:138::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Wed, 2 Feb 2022 11:16:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 11:15:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Feb
 2022 11:15:59 +0000
Received: from [172.27.13.10] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 2 Feb 2022
 03:15:56 -0800
Message-ID: <c18aa473-0cf5-bb80-1aa3-838d3945f0f9@nvidia.com>
Date:   Wed, 2 Feb 2022 13:15:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101
 Thunderbird/97.0
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        "Simon Horman" <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
 <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6fd2d1b-16ea-4958-2758-08d9e63d6449
X-MS-TrafficTypeDiagnostic: BL1PR12MB5377:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53775B93C57A64EB31974DA1B8279@BL1PR12MB5377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0jN5hucRXe+DCJ+s9WINum0qpLMuXKKim8V/XwVcpJrz7WvFKpS1drdeoRGjwSXcCs4e8Uou/aWwTVSJY3RPYI9rUXD/9R0ab2rPrifdAKD7vWuZc7O670cQH+ZcFV2ODcKT9MVL628xkDbUpSAnU+1sSKy/Zrq6OcOnzosWWlhekx6egmpTMptz+aH+xLRX5M2qEHmrXR03e9F+4HB17LQfj1mDUJkIeXJRRFYwEuq0WVonnPKCAK6CNXKyWj2Reqg9q8KGa+VLpmhkKZ1d7YFDgcTz4WuEYjw1qKZQQ83XOST5J2nObQQeJUoiylvEY6zYLnwV8JKkam+oPoeepCAjrMZ4DpZBXdFI0l9Fakq0yX/vs6Hn9YFNAMc0eir63L/ZssRRSueo03XmSnOtck46y8ifIXzUZJjAZ0i3MSL+xz490Vd+X+HQ/3BVbjF/Mow+d/qlfekEnKxBc8mM8ikyYzyv4sl/2jBJMJ+cGiguoA3ZVPv2eQB/xHk3Giulpp9feFjiP6z8yWMdwxiQpIN6Fxkk0lafsojZ1WifXqIuEapWettd1OkBxx/RammrkKpayvbE4ov0YS1ETJyb2IgYbXRfjLHr8JfQ6Ux6BtlHkCknqgeoW9dYHyzN5LTKbu9v25Pr+78uKgg4eH7ob0pbLnOS19JNvrFObFCjx/c1ROAhkr+GQ+Y+boZ094S40jcW8qZ/T77EYdG78SPVc7UwqZTBC5yrLk0Q3vYPhFq0HByEdFu+oVcKX8hwdDA
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(83380400001)(53546011)(16526019)(54906003)(2616005)(336012)(36860700001)(16576012)(26005)(186003)(31686004)(36756003)(426003)(47076005)(110136005)(8936002)(356005)(70586007)(70206006)(8676002)(81166007)(82310400004)(5660300002)(31696002)(508600001)(40460700003)(86362001)(4326008)(2906002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 11:15:59.7826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fd2d1b-16ea-4958-2758-08d9e63d6449
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-02 11:37 AM, Baowen Zheng wrote:
> Hi Roi:
> Thanks for bring this to us, please see the inline comments.
> 
>> On 2022-02-02 10:39 AM, Roi Dayan wrote:
>>>
>>>
>>> On 2022-01-31 9:40 PM, Jamal Hadi Salim wrote:
>>>> On 2022-01-26 08:41, Victor Nogueira wrote:
>>>>> On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng
>>>>> <baowen.zheng@corigine.com> wrote:
>>>>>>
>>>>>> Add skip_hw and skip_sw flags for user to control whether offload
>>>>>> action to hardware.
>>>>>>
>>>>>> Also we add hw_count to show how many hardwares accept to offload
>>>>>> the action.
>>>>>>
>>>>>> Change man page to describe the usage of skip_sw and skip_hw flag.
>>>>>>
>>>>>> An example to add and query action as below.
>>>>>>
>>>>>> $ tc actions add action police rate 1mbit burst 100k index 100
>>>>>> skip_sw
>>>>>>
>>>>>> $ tc -s -d actions list action police total acts 1
>>>>>>       action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb
>>>>>> action reclassify overhead 0b linklayer ethernet
>>>>>>       ref 1 bind 0  installed 2 sec used 2 sec
>>>>>>       Action statistics:
>>>>>>       Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>>       backlog 0b 0p requeues 0
>>>>>>       skip_sw in_hw in_hw_count 1
>>>>>>       used_hw_stats delayed
>>>>>>
>>>>>> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
>>>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>>>>
>>>>> I applied this version, tested it and can confirm the breakage in
>>>>> tdc is gone.
>>>>> Tested-by: Victor Nogueira <victor@mojatatu.com>
>>>>
>>>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>>>
>>>> cheers,
>>>> jamal
>>>
>>>
>>> Hi Sorry for not catching this early enough but I see an issue now
>>> with this patch. adding an offload tc rule and dumping it shows
>>> actions not_in_hw.
>>>
>>> example rule in_hw and action marked as not_in_hw
>>>
>>> filter parent ffff: protocol arp pref 8 flower chain 0 handle 0x1
>>> dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50
>>>     eth_type arp
>>>     in_hw in_hw_count 1
>>>           action order 1: gact action drop
>>>            random type none pass val 0
>>>            index 2 ref 1 bind 1
>>>           not_in_hw
>>>           used_hw_stats delayed
>>>
>>>
>>> so the action was not created/offloaded outside the filter but it is
>>> acting as offloaded.
> Hi Roi, the flag in_hw and not_in_hw in action section describes if the action is offloaded as an action independent of any filter. So the actions created along with the filter will be marked with not_in_hw.
> This is to be compatible with what we do in Linux upstream 8cbfe93 ("flow_offload: allow user to offload tc action to net device").
> 

I understand it's for the actions offload but there is not confusing
output between if actions were created explicitly or by the filter.

In the example above the action is "offloaded". the matching and action
are both done in hw.
maybe if action is created by the filter should not dump in_hw/not_in_hw
flags at all.

>>>
>>> also shouldn't the indent be more 1 space in like random/index to note
>>> it's part of the action order 1.
>  From my environment, I did not find this indent issue, I will make more check to verify.

its ok. i saw the indents from different commit and got fixed, I needed
to refetch. i dont see the indent issues now.

>>>
>>> Thanks,
>>> Roi
>>>
>>
>> also, not tested. what is printed if match is not supported but uses offloaded
>> action?
> If match is not supported but uses offloaded action, the match will be marked as not_in_hw and the action will be marked as in_hw since the action is offloaded independent from filter rule.
>>
>> it could print filter not_in_hw but action in_hw?
