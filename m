Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAD14A6D35
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245171AbiBBIq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:46:56 -0500
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:45921
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239242AbiBBIqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 03:46:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CELbxF0XxaBU4Li77RpIui+VbvOPwAMPOpXxRQfTsMSSF8R00l3otU+fU0lgllh8T2vdL/c4FZm5+BP12/urQoL49cHft25zwulnfURA/oxfBnpBHWMk/904cbIA/zGSum28d8PzdNMLKlTlVZiXOb0U0ZDHEFqo4YlFtNsGHGgJJTHQpfGXCHdKF28QPBRxD2Fk5xng2z8cAVysbBOj/vvGOqJCDYizE/7QAiUhPov41jOXoSo2cgtofCl+mWvJOxj6ri3ga2xsnSgeZKnr8DxHf+AxJl2s1mr4CmLhrAhBJakDKe5VL6fFXL2B8yuSV1Ip7X6wGU+W2gfVzsf8NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od4bTuTKbj+8U8nGIr+y/MP+IDpJWcW4l3UDbYiO8JE=;
 b=aKOMtl0eBQnXuzYTR6TTajklvG6AyJ5nSToiuPzO/+CJO1GkP/KzPPJWftzbTApCVlM5VcLOPzZ7CimIfFUABqAW4vSZyFx7VOcBw5NhTMuDxGrtDBm2TMBiYyVNl4ABzi74NHTqXyB5ovIj0cKeIXmxM98iSzZm8I9ahFvEI54XGcIOx3sw7yQLCmxS5/gWSr3BpOPzOogNu13qFwKhMG1xxI90l3gF8T5jEOV9mJxJ7tioQNcsNYUV2TVHO6nxrzmQzkgasC52kXnLHTfsBwZhHy9UZRnZego1mhqlavIDDhAQR/FzhfpIJdyzdykLxneppX53jAulsvMJ9UlrXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od4bTuTKbj+8U8nGIr+y/MP+IDpJWcW4l3UDbYiO8JE=;
 b=jlttoskKtfvvdLsrEolO5Y1fV5T1yFf0wFTx0bWRasA3s0pra95tfDMQg+mOERo/6XURQ8CIrd/dH1MUXYYZzPAbc5+Lporm5arFtPsn6aFJ0sqHu+gtJezptGg6paKYEt8YruCIr56RkI9M2mggI8g14EdmeX7wpC6DeU2wV7C6wW9BqavxKSHJPiWMyZTkJpE5Rku4NjdHFEQooT2yiEs4q8etezTZBI9VuJc+6CfkaOGCG8kSVcbN3uc9KtWnewbXS5FDnttVy6g/P+/QB7b/FvPdlc/O9BCBB+u6zKyO40W0T/IItu/CNoLS9EEXtuI5e6IeKlI+Gmdty2Rk2Q==
Received: from MW4PR03CA0030.namprd03.prod.outlook.com (2603:10b6:303:8f::35)
 by SN1PR12MB2382.namprd12.prod.outlook.com (2603:10b6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Wed, 2 Feb
 2022 08:46:52 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::2) by MW4PR03CA0030.outlook.office365.com
 (2603:10b6:303:8f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20 via Frontend
 Transport; Wed, 2 Feb 2022 08:46:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 08:46:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Feb
 2022 08:46:51 +0000
Received: from [172.27.13.10] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 2 Feb 2022
 00:46:49 -0800
Message-ID: <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
Date:   Wed, 2 Feb 2022 10:46:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101
 Thunderbird/97.0
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
CC:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
In-Reply-To: <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e66c0c1d-691f-46fd-805d-08d9e6288f30
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB23826C0535E87A14A6F1255FB8279@SN1PR12MB2382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ly+CzmYRDPmmSe8s+OQwkym8pV+7mVsfNGPDAk5JrvLbITfGZcCmiDD67d0p8B4kZRJs3g7Ay077sPQo45qDi2n5cWP3ciNLe66OvwUNSdhgg3h2WM7HMXI9O26HV4tEE5Wil13sEvhkHpmv2FJMiSjB3I0sy6SbdsnOOQBQsUi/U85Cj5imLEoUmyLEBnKbD7p9gjZkFCe5FWmPwcPR4k5bcGE+EZf6vnqI0t9BMcTEdISW83Rft99CRlzwaAxwQDTwd0phiqLG7q3L25HhqelZBZHc2POztXSWXXz1UC6AAaLoKhQZF1tddmuLIseG3pJeqQsGZON9f+oVUTSQ4GLk0Wnfv4kuzcb1lygB9WbunZWLVd8DTGd5Z6cgH+q1T8OWK3Pdvxv+wKOEzkHebHwA3YqUv769kUh8znkLnHJzwEQXYfLLvkthhchpjVqsDjXepUmnHjXgLtYqWj1hZqL3WvWzLPYsrBmmoKtBm3FZ3s/eISTM4zYyk+6Cb1/zBMIQowITmH4vGp4u/Mm0rnWS1Ul0GPYbQ+F+ACj2xtSM2ldHzXAr0zHUH4YtS+qmOHdcONe7uFIhkKWVhdq+K50HbzOJt8StqzOXlH9gCboyGAyzUfFZrEp5SCm6ZdzBGySPAMf+Gxt+80TnWjo+dPYK/qpno4sVx/scNEIrrGL2nhS2J9RCCgi22ehhlHRmZi+0AkZYGaVJKKWtLZFvf03CITjRVTqzuoPhSbR/DF2M/Eog3Izc8EXR6dmH35PK
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(8936002)(508600001)(40460700003)(70206006)(70586007)(31696002)(316002)(86362001)(54906003)(81166007)(82310400004)(4326008)(53546011)(8676002)(356005)(16576012)(36756003)(31686004)(186003)(36860700001)(26005)(83380400001)(5660300002)(16526019)(47076005)(2906002)(2616005)(336012)(426003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 08:46:52.4099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e66c0c1d-691f-46fd-805d-08d9e6288f30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-02 10:39 AM, Roi Dayan wrote:
> 
> 
> On 2022-01-31 9:40 PM, Jamal Hadi Salim wrote:
>> On 2022-01-26 08:41, Victor Nogueira wrote:
>>> On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng 
>>> <baowen.zheng@corigine.com> wrote:
>>>>
>>>> Add skip_hw and skip_sw flags for user to control whether
>>>> offload action to hardware.
>>>>
>>>> Also we add hw_count to show how many hardwares accept to offload
>>>> the action.
>>>>
>>>> Change man page to describe the usage of skip_sw and skip_hw flag.
>>>>
>>>> An example to add and query action as below.
>>>>
>>>> $ tc actions add action police rate 1mbit burst 100k index 100 skip_sw
>>>>
>>>> $ tc -s -d actions list action police
>>>> total acts 1
>>>>      action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb 
>>>> action reclassify overhead 0b linklayer ethernet
>>>>      ref 1 bind 0  installed 2 sec used 2 sec
>>>>      Action statistics:
>>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>      backlog 0b 0p requeues 0
>>>>      skip_sw in_hw in_hw_count 1
>>>>      used_hw_stats delayed
>>>>
>>>> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>>
>>> I applied this version, tested it and can confirm the breakage in tdc 
>>> is gone.
>>> Tested-by: Victor Nogueira <victor@mojatatu.com>
>>
>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>
>> cheers,
>> jamal
> 
> 
> Hi Sorry for not catching this early enough but I see an issue now with
> this patch. adding an offload tc rule and dumping it shows actions
> not_in_hw.
> 
> example rule in_hw and action marked as not_in_hw
> 
> filter parent ffff: protocol arp pref 8 flower chain 0 handle 0x1
> dst_mac e4:11:22:11:4a:51
> src_mac e4:11:22:11:4a:50
>    eth_type arp
>    in_hw in_hw_count 1
>          action order 1: gact action drop
>           random type none pass val 0
>           index 2 ref 1 bind 1
>          not_in_hw
>          used_hw_stats delayed
> 
> 
> so the action was not created/offloaded outside the filter
> but it is acting as offloaded.
> 
> also shouldn't the indent be more 1 space in like random/index to
> note it's part of the action order 1.
> 
> Thanks,
> Roi
> 

also, not tested. what is printed if match is not supported but uses
offloaded action?

it could print filter not_in_hw but action in_hw?
