Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A262A5986F2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbiHRPHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344052AbiHRPHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:07:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565F1B600C;
        Thu, 18 Aug 2022 08:07:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i05iyWPRg51OSjZv+8cHEkBvhVWu81CHJEbCSYO0BN3SBKC7G3l5Hux5vzpbcYQ8FYdbd3y3CtmQxbrf9eG9+9xh1xDzSz/3MwJT5FzdplSMiXnq2QJyr7VHvCf5ixkO+CbKymS+i1lizCYsVgNGZ+RmAOrBrt/TCA9Jvnli8bHhm5VNIFblHlR6JCYlmJxTE3K49PRsOCxEdWc6QVTEev0hiUrBoMuFSvc76+y31Ci0qssR0Z+ewbRVZQGAzyRRYJ6NvjKj98gIjyk1Yhp6NwtKAuGanswBobD07IqBZ4Y6DQVDhmEl8LXunGlbs5Q4ucTP17wZ8lzzaZomRhydrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NIY6JG3r3Dh7dd1nnRz0fbb6olJ8aY5shnfDvI0cZiQ=;
 b=bc8E7uVe5QkCWlzkGuNsXm5VnJQIwiUEeSTVVstYXmp8GCIb5TfgimgWbUzuokK5y89hSYMcl+fZKeda2Dxos+5huqR5TIxDxqMUIvDZbG+iVxKukh9BmYGBsMw66Fgc5LPt8ht63vTNzdAGeHhYTntC4X5JDeYy2gi/t9uwnsSxCE1qEhJlTWqouKfIbEZf3oDuk08AqTGbJL4BR6gYWsLV+KtMUiFAPt101tXIa/jrxUCahuTI8blyAtHGdLCSwbcu6UBOaMQlt7FX9stiZGRCea/y/qYz1zpui0E85z5Qwu6Sbv8LlUU/N6jO6jaJS/L5KNKkIX/ynY8e7MF52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIY6JG3r3Dh7dd1nnRz0fbb6olJ8aY5shnfDvI0cZiQ=;
 b=K2xM/fJl3vu17i1CLK2eLKW+v4uwVZpd99xHPrByK1dDViS0/0nDdYQANNw7iPgC4bq94B0b/kjrEavjz4RBTYIDXPOq817G1GOXIyqiuUznn2tByrJtPnCSi8N0W3Z6CsyEnd2ULRMDXjyExvDhOjEX4Yjus2QW6yz9ryhGsWFUP4C61Au6UewRScoIAyPlt5u5IiwlgI2Sw5aJgJiTb4xykUJaGJjhB1jNLwf6btL7G+OwJgyTgquhvIrN5pkXeQAVy/ywf0EV8FVElc3+4VwlbueVYlPEEMicRtYFs/io4Z5AIL94lCENszJF9Jl5Sba81YeWLSApA7jQHWjPYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by CH2PR12MB3816.namprd12.prod.outlook.com (2603:10b6:610:2f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 18 Aug
 2022 15:07:44 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478%8]) with mapi id 15.20.5546.016; Thu, 18 Aug 2022
 15:07:44 +0000
Message-ID: <5edbd360-7afb-2605-21ba-7337be15e235@nvidia.com>
Date:   Thu, 18 Aug 2022 18:07:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
Content-Language: en-US
To:     ecree@xilinx.com, netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20220815142251.8909-1-ecree@xilinx.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220815142251.8909-1-ecree@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::15) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e23030c-1567-4bff-6c34-08da812b66d1
X-MS-TrafficTypeDiagnostic: CH2PR12MB3816:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //D2bJ77MmpYHPw+zZ6ddRWVO7VhPPWv7Pk8Kv/77AJgU4AHxA+IQZJ3rQvqpOUMthWUXCitGoxBeKXtiE00PRX4hfud66/dfmzt+hhMK0waTBqFUews53N6sfKQ8TSkgeN1zJhvkQf2F2tV5VzPvYEgNv7bZjZoq2MGuF6JiGRRUpdtiNOl+GRm6bJV7Vev4AX8b1siOtueoKgID2vIN16riwM0UIml9uIVvp+6ZfsCbagk8LEOawwJ0NMvOMTt5kUpdcyI8kW9TP1NQn2mUR5qJvKI2mb5Vy2+COT+rx7X5n3JvRTnADAWzohlISM5R0ifBalzoNsfbHJOplrUKU0aCk9q37KgU8m8WWrRi0Hh/BgvdD+PKB4XftErGRHo+4GVL5SnC3YatkGx8wJhxpqeoc9Iq6nUjY1U0rPwthz9U9YfW3kk3Iec2UdVc5tdGehfrTSiDOdvYXRKDe7o0UZb6J3xOuK1BpXCmSU0h8An1G2xrZyqCozjSb1mdzh8ojwpq099XgcfwweNJ7BaEj/ctItv0FzPIaZTzYaLCBAOGW2mbotdHi7zpmhwVEb9UYlGQ4F2WZiSCLTnXe8nTIQSxhAeES0ewaKngPIwSF0+jmSy6af2CisoYk9aPLKITxH9350psE5U+dt/MWcTDij6DojKbjHDSYCVZ+Vltm50sUh2HhgSCroltiHXy9GOXPA4bLh7q2TiBId6M4VHP9VufAtygCEJZBKfpXBhds5PVwLkKxadl0D+s4wansq6Lk8V8g8KbawG7WyFoczh8HLH0eRjnfTTiUW/HgFM0+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(8676002)(66946007)(66556008)(31686004)(4326008)(316002)(38100700002)(5660300002)(66476007)(30864003)(8936002)(7416002)(2906002)(36756003)(31696002)(86362001)(478600001)(53546011)(41300700001)(6506007)(26005)(2616005)(6486002)(6512007)(83380400001)(6666004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHF5QnN4NEI3ajNXK3QvRndCdDJlaDd5STJmVHBQaEYyUk1HUHdobVpFREpR?=
 =?utf-8?B?SWxsQnNSY0JLVE53Z09GbEkzTnF5elMwOFZUNG5MT1VHdWZ0bXFoYXJYdXZJ?=
 =?utf-8?B?bzZMK0x3aytJdU1LNkVyb2F4RWF0empQbzB0b2NKQ1FrcFVrQ3F3Qm1CTFpB?=
 =?utf-8?B?Qzdva0duU2JudTBTSEs1SXdpWUZjS0pPOWtKYk5QV2VtY1hMQjhXVXBJOXFO?=
 =?utf-8?B?bHZZNC9DUlhEV0plNEZyQkorT3ErcFNibS9QSXFxeW1YV0JvcktIVUFpRHVu?=
 =?utf-8?B?RjB1b3Mvdmpad2lhdDdPS2cwWkpGT2JLcmgwM2dpaW80cGNwNStwS1Mwb29Y?=
 =?utf-8?B?YVhURVNNUjIzdnlHMHdCNEtpc1lCbmJmY05qOGxiV1JOYjhkNmZqc25kK1hi?=
 =?utf-8?B?c0tGckVGN3Zzazd6QnpoYmN3dW9BQ3pZdytuelBOb05UN3BDY2pzWjBuUW56?=
 =?utf-8?B?TlhXKy9udGF6YVh1MEplWnFVMjNYY2E1Si9uZGI5T0pURHNidzltN3Y4dXZo?=
 =?utf-8?B?MXNpWW9MN01iUkhXbFhGRGsrZGJwcWZFTVI5bW50dWVxSENVYnhhL3hPbE9L?=
 =?utf-8?B?MjhxZWFiQ3YxUmRRa1puT2V6Vks3TkV1SUhBT2xTZlVXYWgzaERUekFtOHNu?=
 =?utf-8?B?aHdHK2trU0oxbFZvQWx3KzJiS0d4ZjhEdnFCa3FrQ2NrWmVqSkZPdU85MHRz?=
 =?utf-8?B?Mk5GQ2NSU0ZJOGNydjZQKzRxWFZCM3djdzVwNE9xZEgxNHQzdnhNOUFsOUJS?=
 =?utf-8?B?Q0Rad2I0cjloa1FhVEI3WHBUcm9mSGF4emJVRk13VWFxbThRK1B3SFk1eHFy?=
 =?utf-8?B?SE5FaFJEOC83aTdKT1U0emw4TzhMQmE1dWZmTXBibUpRWlZzalNxVkpGdjR2?=
 =?utf-8?B?aUt2cGZudlByUWZxd1dicWhDUGl4Qmcwa3o4R3ZKS1p4TFVTa1hPNDRNYTlE?=
 =?utf-8?B?ZHVqeTZYYmt3YUdOcTN6aUFBWmYxR0tQbnlkZllUNWo2VzVBZWxTQ2U2TFBo?=
 =?utf-8?B?SDNtTEpLNndqLzRkMmREbkxyYWdyTlRMMVQxV0t2bDFYVkR6am5LRjNOVHZz?=
 =?utf-8?B?OUljd1hxVzR4WkZyRGFiYXM3UktLc1hpdDJZRUZFcWFsMTlmOVFUSmltWStl?=
 =?utf-8?B?SFlqRVluZGtmNjRkOWp1MjhWTTRZMmg4VHJOdHVGWmJrbEJiK3BZRUhEUHBv?=
 =?utf-8?B?SHA0NUhuWTBJWUNQc2pTdzk0NWEzNVpqditwaHZ0VCtRY0ZZR25tMjA2WW9j?=
 =?utf-8?B?WnhCY3l6SU9kKzVCVXVGaEpMN2NkUlNYdlk3VW1xN0xCclN3anpjdE1YUXd6?=
 =?utf-8?B?UGVWcGZmOGh3WjBCS0dubmk2MVJGSUJpL2Q3QXdMWDdmYlNpZE1vTUNwZmk5?=
 =?utf-8?B?WHNwMUpNR0ZMU29vc215WGhpK2krUHJVU1M2S29LVmhSVUIyTUpJSUdiUlU5?=
 =?utf-8?B?RWxGZlVrbEdTSTFPalBFVGlKcUdwODJUZnVHWCtLaFd0Y1F0TERmYmtlZW9o?=
 =?utf-8?B?cEQ3M0lXRE0zRks0alNRUC9YTWtLMlhuZURqSG56VW9na2QrRFFPK1BaWVd6?=
 =?utf-8?B?V1dlRU1CMm0vS3FFdTFhVy9iMnFJdDFOWURBVGlHTWhBdDdoRU0veHV3eFFW?=
 =?utf-8?B?SHpRbktzaTE4THkyMmpFM3JYU2E4OUF1V28za29lc25lTjBXRmxQWVlGVlVk?=
 =?utf-8?B?aFZabFloRnRTK3lhd3dhMXlqM1FnSmlCc2tUamRjQTZnKytPdGIxRzcvamxQ?=
 =?utf-8?B?cllWMlRneVV2cDlBYUk0WnAzQjlVMVB1Vlk2YTJHTVMrZlR0MTRmTHVuNHdn?=
 =?utf-8?B?S2R3VzB2RnZ0RExNQVNXL3lCTjhSOEt0WTZHcW8vRENTQnRaWG5BTmszSmt5?=
 =?utf-8?B?WXBoWnhvWCtHcGRVRUNGMXkzcmtNMzExc1dGZFl6YUNBbVBBOFhKcUhZalQ0?=
 =?utf-8?B?Rkd1enlNNnlKRWZMTkU0SkNiMGljMWEzNmN3NU9tN0ZEQk55VkJRa1N4MmpX?=
 =?utf-8?B?a1pxSlJJcW9XVHhyYitqemo0SVY1N1hrNU5reE9JcmQ1NGxvWHF1dytRRXR6?=
 =?utf-8?B?V2ZCRGwvTUFnZlFYYldMdzBMb2E1MU05bHhSNmVoVzMvalVCeVhvelVoYUxj?=
 =?utf-8?Q?fzudDIn8L/cSBFBkvVSqmQ60t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e23030c-1567-4bff-6c34-08da812b66d1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:07:43.9298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHfQh5OeN94IBJNQ+8nEMYX2x46i1S/ZIHXVEusU9HhWi0C0FHoykegsSP+nxgVf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-08-15 5:22 PM, ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> There's no clear explanation of what VF Representors are for, their
>   semantics, etc., outside of vendor docs and random conference slides.
> Add a document explaining Representors and defining what drivers that
>   implement them are expected to do.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v2:
>   - incorporated feedback from Jakub including rewrite of the Motivation section,
>     representors for uplink/phys port, replace phys_port_name conventions with
>     devlink port.
>   - fixed archaic spelling (Randy)
>   - painted the bike shed blue ("master PF") for now, we can always change it
>     again later
>   - added Definitions section
> 
>   Documentation/networking/index.rst        |   1 +
>   Documentation/networking/representors.rst | 228 ++++++++++++++++++++++
>   Documentation/networking/switchdev.rst    |   1 +
>   3 files changed, 230 insertions(+)
>   create mode 100644 Documentation/networking/representors.rst
> 
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index 03b215bddde8..c37ea2b54c29 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -93,6 +93,7 @@ Contents:
>      radiotap-headers
>      rds
>      regulatory
> +   representors
>      rxrpc
>      sctp
>      secid
> diff --git a/Documentation/networking/representors.rst b/Documentation/networking/representors.rst
> new file mode 100644
> index 000000000000..be7cc4752d11
> --- /dev/null
> +++ b/Documentation/networking/representors.rst
> @@ -0,0 +1,228 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============================
> +Network Function Representors
> +=============================
> +
> +This document describes the semantics and usage of representor netdevices, as
> +used to control internal switching on SmartNICs.  For the closely-related port
> +representors on physical (multi-port) switches, see
> +:ref:`Documentation/networking/switchdev.rst <switchdev>`.
> +
> +Motivation
> +----------
> +
> +Since the mid-2010s, network cards have started offering more complex
> +virtualisation capabilities than the legacy SR-IOV approach (with its simple
> +MAC/VLAN-based switching model) can support.  This led to a desire to offload
> +software-defined networks (such as OpenVSwitch) to these NICs to specify the
> +network connectivity of each function.  The resulting designs are variously
> +called SmartNICs or DPUs.
> +
> +Network function representors bring the standard Linux networking stack to
> +virtual switches and IOV devices.  Just as each port of a Linux-controlled
> +switch has a separate netdev, so each virtual function has one.  When the system
> +boots, and before any offload is configured, all packets from the virtual
> +functions appear in the networking stack of the PF via the representors.
> +The PF can thus always communicate freely with the virtual functions.
> +The PF can configure standard Linux forwarding between representors, the uplink
> +or any other netdev (routing, bridging, TC classifiers).
> +
> +Thus, a representor is both a control plane object (representing the function in
> +administrative commands) and a data plane object (one end of a virtual pipe).
> +As a virtual link endpoint, the representor can be configured like any other
> +netdevice; in some cases (e.g. link state) the representee will follow the
> +representor's configuration, while in others there are separate APIs to
> +configure the representee.
> +
> +Definitions
> +-----------
> +
> +This document uses the term "master PF" to refer to the PCIe function which has
> +administrative control over the virtual switch on the device.  Conceivably a NIC
> +could be configured to grant these administrative privileges instead to a VF or
> +SF (subfunction); the terminology is not meant to exclude this case.
> +Depending on NIC design, a multi-port NIC might have a single master PF for the
> +whole device or might have a separate virtual switch, and hence master PF, for
> +each physical network port.
> +If the NIC supports nested switching, there might be separate "master PFs" for
> +each nested switch, in which case each "master PF" should only create
> +representors for the ports on the (sub-)switch it directly administers.
> +
> +A "representee" is the object that a representor represents.  So for example in
> +the case of a VF representor, the representee is the corresponding VF.
> +
> +What does a representor do?
> +---------------------------
> +
> +A representor has three main roles.
> +
> +1. It is used to configure the network connection the representee sees, e.g.
> +   link up/down, MTU, etc.  For instance, bringing the representor
> +   administratively UP should cause the representee to see a link up / carrier
> +   on event.
> +2. It provides the slow path for traffic which does not hit any offloaded
> +   fast-path rules in the virtual switch.  Packets transmitted on the
> +   representor netdevice should be delivered to the representee; packets
> +   transmitted to the representee which fail to match any switching rule should
> +   be received on the representor netdevice.  (That is, there is a virtual pipe
> +   connecting the representor to the representee, similar in concept to a veth
> +   pair.)
> +   This allows software switch implementations (such as OpenVSwitch or a Linux
> +   bridge) to forward packets between representees and the rest of the network.
> +3. It acts as a handle by which switching rules (such as TC filters) can refer
> +   to the representee, allowing these rules to be offloaded.
> +
> +The combination of 2) and 3) means that the behaviour (apart from performance)
> +should be the same whether a TC filter is offloaded or not.  E.g. a TC rule
> +on a VF representor applies in software to packets received on that representor
> +netdevice, while in hardware offload it would apply to packets transmitted by
> +the representee VF.  Conversely, a mirred egress redirect to a VF representor
> +corresponds in hardware to delivery directly to the representee VF.
> +
> +What functions should have a representor?
> +-----------------------------------------
> +
> +Essentially, for each virtual port on the device's internal switch, there
> +should be a representor.
> +Some vendors have chosen to omit representors for the uplink and the physical
> +network port, which can simplify usage (the uplink netdev becomes in effect the
> +physical port's representor) but does not generalise to devices with multiple
> +ports or uplinks.
> +
> +Thus, the following should all have representors:
> +
> + - VFs belonging to the master PF.
> + - Other PFs on the local PCIe controller, and any VFs belonging to them.
> + - PFs and VFs on other PCIe controllers on the device (e.g. for any embedded
> +   System-on-Chip within the SmartNIC).
> + - PFs and VFs with other personalities, including network block devices (such
> +   as a vDPA virtio-blk PF backed by remote/distributed storage), if their
> +   network access is implemented through a virtual switch port.
> +   Note that such functions can require a representor despite the representee
> +   not having a netdev.
> + - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they have
> +   their own port on the switch (as opposed to using their parent PF's port).
> + - Any accelerators or plugins on the device whose interface to the network is
> +   through a virtual switch port, even if they do not have a corresponding PCIe
> +   PF or VF.
> +
> +This allows the entire switching behaviour of the NIC to be controlled through
> +representor TC rules.
> +
> +A PCIe function which does not have network access through the internal switch
> +(not even indirectly through the hardware implementation of whatever services
> +the function provides) should *not* have a representor (even if it has a
> +netdev).
> +Such a function has no switch virtual port for the representor to configure or
> +to be the other end of the virtual pipe.
> +
> +How are representors created?
> +-----------------------------
> +
> +The driver instance attached to the master PF should enumerate the virtual ports
> +on the switch, and for each representee, create a pure-software netdevice which
> +has some form of in-kernel reference to the PF's own netdevice or driver private
> +data (``netdev_priv()``).
> +If switch ports can dynamically appear/disappear, the PF driver should create
> +and destroy representors appropriately.
> +The operations of the representor netdevice will generally involve acting
> +through the master PF.  For example, ``ndo_start_xmit()`` might send the packet
> +through a hardware TX queue attached to the master PF, with either packet
> +metadata or queue configuration marking it for delivery to the representee.
> +
> +How are representors identified?
> +--------------------------------
> +
> +The representor netdevice should *not* directly refer to a PCIe device (e.g.
> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
> +representee or of the master PF.

Hi,
maybe I'm confused here, but why representor should not refer to pci
device ? it does exists today for systemd renaming.
and this is used beside of implementing the other ndos you mention
below.

     udevadm output after linking to PCI device:
     $ udevadm test-builtin net_id /sys/class/net/eth6
     Load module index
     Network interface NamePolicy= disabled on kernel command line, 
ignoring.
     Parsed configuration file /usr/lib/systemd/network/99-default.link
     Created link configuration context.
     Using default interface naming scheme 'v243'.
     ID_NET_NAMING_SCHEME=v243
     ID_NET_NAME_PATH=enp0s8f0npf0vf0
     Unload module index
     Unloaded link configuration context.

$  git grep SET_NETDEV_DEV|grep rep
drivers/net/ethernet/intel/ice/ice_repr.c: 
SET_NETDEV_DEV(repr->netdev, ice_pf_to_dev(vf->pf));
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: 
SET_NETDEV_DEV(netdev, mdev->device);
drivers/net/ethernet/netronome/nfp/flower/main.c: 
SET_NETDEV_DEV(repr, &priv->nn->pdev->dev);


> +Instead, it should implement the ``ndo_get_devlink_port()`` netdevice op, which
> +the kernel uses to provide the ``phys_switch_id`` and ``phys_port_name`` sysfs
> +nodes.  (Some legacy drivers implement ``ndo_get_port_parent_id()`` and
> +``ndo_get_phys_port_name`` directly, but this is deprecated.)  See
> +:ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>` for the
> +details of this API.
> +
> +It is expected that userland will use this information (e.g. through udev rules)
> +to construct an appropriately informative name or alias for the netdevice.  For
> +instance if the master PF is ``eth4`` then a representor with a
> +``phys_port_name`` of ``p0pf1vf2`` might be renamed ``eth4pf1vf2rep``.
> +
> +There are as yet no established conventions for naming representors which do not
> +correspond to PCIe functions (e.g. accelerators and plugins).
> +
> +How do representors interact with TC rules?
> +-------------------------------------------
> +
> +Any TC rule on a representor applies (in software TC) to packets received by
> +that representor netdevice.  Thus, if the delivery part of the rule corresponds
> +to another port on the virtual switch, the driver may choose to offload it to
> +hardware, applying it to packets transmitted by the representee.
> +
> +Similarly, since a TC mirred egress action targeting the representor would (in
> +software) send the packet through the representor (and thus indirectly deliver
> +it to the representee), hardware offload should interpret this as delivery to
> +the representee.
> +
> +As a simple example, if ``eth0`` is the master PF's netdevice and ``eth1`` is a
> +VF representor, the following rules::
> +
> +    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
> +        action mirred egress redirect dev eth0
> +    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
> +        action mirred egress mirror dev eth1
> +
> +would mean that all IPv4 packets from the VF are sent out the physical port, and
> +all IPv4 packets received on the physical port are delivered to the VF in
> +addition to the master PF.
> +
> +Of course the rules can (if supported by the NIC) include packet-modifying
> +actions (e.g. VLAN push/pop), which should be performed by the virtual switch.
> +
> +Tunnel encapsulation and decapsulation are rather more complicated, as they
> +involve a third netdevice (a tunnel netdev operating in metadata mode, such as
> +a VxLAN device created with ``ip link add vxlan0 type vxlan external``) and
> +require an IP address to be bound to the underlay device (e.g. master PF or port
> +representor).  TC rules such as::
> +
> +    tc filter add dev eth1 parent ffff: flower \
> +        action tunnel_key set id $VNI src_ip $LOCAL_IP dst_ip $REMOTE_IP \
> +                              dst_port 4789 \
> +        action mirred egress redirect dev vxlan0
> +    tc filter add dev vxlan0 parent ffff: flower enc_src_ip $REMOTE_IP \
> +        enc_dst_ip $LOCAL_IP enc_key_id $VNI enc_dst_port 4789 \
> +        action tunnel_key unset action mirred egress redirect dev eth1
> +
> +where ``LOCAL_IP`` is an IP address bound to ``eth0``, and ``REMOTE_IP`` is
> +another IP address on the same subnet, mean that packets sent by the VF should
> +be VxLAN encapsulated and sent out the physical port (the driver has to deduce
> +this by a route lookup of ``LOCAL_IP`` leading to ``eth0``, and also perform an
> +ARP/neighbour table lookup to find the MAC addresses to use in the outer
> +Ethernet frame), while UDP packets received on the physical port with UDP port
> +4789 should be parsed as VxLAN and, if their VSID matches ``$VNI``, decapsulated
> +and forwarded to the VF.
> +
> +If this all seems complicated, just remember the 'golden rule' of TC offload:
> +the hardware should ensure the same final results as if the packets were
> +processed through the slow path, traversed software TC and were transmitted or
> +received through the representor netdevices.
> +
> +Configuring the representee's MAC
> +---------------------------------
> +
> +The representee's link state is controlled through the representor.  Setting the
> +representor administratively UP or DOWN should cause carrier ON or OFF at the
> +representee.
> +
> +Setting an MTU on the representor should cause that same MTU to be reported to
> +the representee.
> +(On hardware that allows configuring separate and distinct MTU and MRU values,
> +the representor MTU should correspond to the representee's MRU and vice-versa.)
> +
> +Currently there is no way to use the representor to set the station permanent
> +MAC address of the representee; other methods available to do this include:
> +
> + - legacy SR-IOV (``ip link set DEVICE vf NUM mac LLADDR``)
> + - devlink port function (see **devlink-port(8)** and
> +   :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`)
> diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
> index f1f4e6a85a29..21e80c8e661b 100644
> --- a/Documentation/networking/switchdev.rst
> +++ b/Documentation/networking/switchdev.rst
> @@ -1,5 +1,6 @@
>   .. SPDX-License-Identifier: GPL-2.0
>   .. include:: <isonum.txt>
> +.. _switchdev:
>   
>   ===============================================
>   Ethernet switch device driver model (switchdev)
