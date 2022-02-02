Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27914A6D0C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbiBBIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:39:29 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:7393
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235791AbiBBIj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 03:39:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiBo9F74liAG7CBIrDdDBned1u+nDhCipfVuuV0qRGMsQdqL5q/8YPvpn92cbxRIC9ZlbIs+O2xP0DkBHpY8mpH77roBqqo09YnCKg7P57JWlisagU7xNNKotupj+8AgdOj5PRXFsmGVHwSQ6g2ivPlcBPFQueEo+NcZJMQqeZBj3Peo6Nx2atttiORDpiN5QX83YERUOwXskcM+vD+nXSIwCYJFZkMON1Yv8WvsRgHFvo4u7eDhZ/4oN0wIvIB6EhgbcLOhppV4+NcAVoJQJ7r3Kf7hdY5YaG1GbjW1wSH0mpGB4ZqRDKERPNAx8VwpYmaEn/656kFvuTxV1/1UcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/7a6tDWxkCqMKuSSe54MK8vXHs54/cag1WA5uTvo9g=;
 b=JyKVCrWWF95jQN4e2HXnxPFAVtU8v+P2bWkDiUD8I+3VRKSgZXmoUBIxmZqwAe/3HDqTqaqdqKiWQsyiQznHnA8zh6QPzwkNls2SnolFm3jdlPJrZjwBh7/VL5iuNvLJMozy6GebsydiQaRv8urAn63fitDPMiG1KHT7tTFgFT3XQvzTVJxFYDSQ0Am5PlRvaWafd7t+r6pPf1KJ0GecnqR/t9PnWh+Oqe75qNUsFE/USBwKnk/Yv7sNA2HylqsCY/8lbK+zprqxY2whKvfPiZGdaTnq7LUwRzWgQHuJBB0SeTIcOx2i0k4rF+eCALY6zcqNSnqP58IQyrlaHHr46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/7a6tDWxkCqMKuSSe54MK8vXHs54/cag1WA5uTvo9g=;
 b=TtLkslZX+Uab2ui/w8ymCHa9s4lFCOjD+Qb+v9JGmyeVWBkesFWWflkP/Snb4oyXjiU70rZkS4YIANYsR8FM/vCMBsrMHL7rdB/3y+8ZtAMTJQ/aUGZ5ANXd41fD094E2DovQbLCdfnpwgtTU7fRPT3WWLGVE+RjNBVyP+VzK8klYini1G8fejMWVOy6gBdgXFDW5RgujH36U/bfzUPDhIsjz4DpQCaBDhIdbMZfoyBhYwTHD9YF15LnM5gPzT+U+HqBpRAibcFH6eygF3nYMN5yV/9o8EUaj6krbbsdtzuYr+d5gLPHIpauAMihfvKKP7fZ3FUPdQtPskCJoDq+/w==
Received: from DS7PR03CA0280.namprd03.prod.outlook.com (2603:10b6:5:3ad::15)
 by MW2PR12MB2570.namprd12.prod.outlook.com (2603:10b6:907:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Wed, 2 Feb
 2022 08:39:25 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::d6) by DS7PR03CA0280.outlook.office365.com
 (2603:10b6:5:3ad::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11 via Frontend
 Transport; Wed, 2 Feb 2022 08:39:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 08:39:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Feb
 2022 08:39:23 +0000
Received: from [172.27.13.10] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 2 Feb 2022
 00:39:21 -0800
Message-ID: <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
Date:   Wed, 2 Feb 2022 10:39:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101
 Thunderbird/97.0
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
CC:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0442b28-376f-4a1a-33b3-08d9e6278457
X-MS-TrafficTypeDiagnostic: MW2PR12MB2570:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB25704F33EB8DEFA0FD21302BB8279@MW2PR12MB2570.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eza/vnMrIpo4edaAjwsx2Jk1Mg5tGKfTCDVrTbjnp2v/W0neGXbqn/FbvPXVo0juEFt+qKcjNboUzktmrB3PJoWMHxyZJEmqIF4+8l/ElvMFZou4qo4u+W1m/Llf3dzUQbEtUknjjiHd0e+O/pNUQMcLmtsuBwV1GxZRq4nv3Qf6lYv9DgM0AEVUP32eqIP03wQ6IQME64FwH4fVJM7MnGKMW1+8tfqt3Cu7HHVJoVcB+nfZUZf03utz09TTKHQrvlIQkes+ycOOJZZ83OGrUdQXP/OfjVpWYgbW8dygVvxaTSEL5xDNpvLw4GG6WhWix7N6L1ZDbZ6oE8uTwZzgNgc1G1RkwUoxslbxTwprVM9yaUf9RmpdWL0Fd/CAsPVghDs+cd0I144uRI7skvYR5Xor71JMqk1/3vOykOymnvlymbBZt3SR4tfqmzpe8Mg+D1we18fJKoZXFnsNtdbw8L5Vcsze7cbxQus2/freOpvB2MkM5rGxFpS2QP7RVHiks6Woi7X/W1iQUDU/Ml5czDol2P4DVs0X8I2yO+E+5HUK9u3vpJXAvdMJioWw/mJ3n8jwSGh5U/QJEQNT4r3mkCAry8lYeETeeA0y4tRcNG3GhZJ+wfHO69RSKdoyVMsp4Jw+b9ZxoRaofkSPpDZlquutpJXm4gsWyVOLte+mH3K8ibEZaRkuSdeF1Ys3c5kXH7H6SXmN+pHbSsJ6gwRHkRxjJ9o/Vo/rxaCT8I/bMmDoOZyKNaurjK7nR7iZHTiT
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(6666004)(83380400001)(5660300002)(2906002)(36756003)(31686004)(47076005)(53546011)(40460700003)(186003)(70586007)(16526019)(54906003)(86362001)(426003)(2616005)(356005)(508600001)(82310400004)(26005)(316002)(336012)(8936002)(36860700001)(110136005)(70206006)(8676002)(4326008)(31696002)(16576012)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 08:39:24.6806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0442b28-376f-4a1a-33b3-08d9e6278457
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2570
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-01-31 9:40 PM, Jamal Hadi Salim wrote:
> On 2022-01-26 08:41, Victor Nogueira wrote:
>> On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng 
>> <baowen.zheng@corigine.com> wrote:
>>>
>>> Add skip_hw and skip_sw flags for user to control whether
>>> offload action to hardware.
>>>
>>> Also we add hw_count to show how many hardwares accept to offload
>>> the action.
>>>
>>> Change man page to describe the usage of skip_sw and skip_hw flag.
>>>
>>> An example to add and query action as below.
>>>
>>> $ tc actions add action police rate 1mbit burst 100k index 100 skip_sw
>>>
>>> $ tc -s -d actions list action police
>>> total acts 1
>>>      action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb 
>>> action reclassify overhead 0b linklayer ethernet
>>>      ref 1 bind 0  installed 2 sec used 2 sec
>>>      Action statistics:
>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>      backlog 0b 0p requeues 0
>>>      skip_sw in_hw in_hw_count 1
>>>      used_hw_stats delayed
>>>
>>> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>
>> I applied this version, tested it and can confirm the breakage in tdc 
>> is gone.
>> Tested-by: Victor Nogueira <victor@mojatatu.com>
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> cheers,
> jamal


Hi Sorry for not catching this early enough but I see an issue now with
this patch. adding an offload tc rule and dumping it shows actions
not_in_hw.

example rule in_hw and action marked as not_in_hw

filter parent ffff: protocol arp pref 8 flower chain 0 handle 0x1
dst_mac e4:11:22:11:4a:51
src_mac e4:11:22:11:4a:50
   eth_type arp
   in_hw in_hw_count 1
         action order 1: gact action drop
          random type none pass val 0
          index 2 ref 1 bind 1
         not_in_hw
         used_hw_stats delayed


so the action was not created/offloaded outside the filter
but it is acting as offloaded.

also shouldn't the indent be more 1 space in like random/index to
note it's part of the action order 1.

Thanks,
Roi

