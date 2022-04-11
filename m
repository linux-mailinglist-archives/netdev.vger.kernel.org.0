Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BB74FC4FE
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbiDKTYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiDKTYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:24:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C81098
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdeho3T3NZ3u0g5yth3QAI6ONVHKB/7i1LaFEh2lJdlsZj8V0fSKCSfWsaqCkSNANrCrIE/2z+Q9gpOVX9mPT7qDDDw2Cor1DTQI1pYybkOR+I1y3kiQdfeuSKSMtW5S5tDBdnP/SYFCENGY/ON4Qu2uldf6bDJdBLyrOz7jQieSDCyuZyrZHEP1X0MAFmJvsdsd/zMgsBQJiQ+4ROS7bE33wblh++gcctc+L+i8IpBLSC2HZlOEoeHauynKVgkoGkrJxRartit8CGWLSQVD0ZQc1h89secnimxvotyKrUCNC6YqBYAfyFqHdL74FlXDMyevCuWvM/5Aet+UdkzNDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gs36UPeqkP8H3vA7VWWmygr1vvdGEr59iCCm2pyOkyc=;
 b=Mx5twz4CanMAtUwU0/bLVVbziJQSeTzIkCwIZ4SGEcZubs3BxIqSIIW6vzHD/WY6hARQ3iXp4fzJso4wWCaKaQuhjwvIlIM4p8ZvCZ95H/YFK4H9Sx5d0Inu9msIeyW9wbTABlS4trzvRa1ci+BOoq1n4W44I4K7wFXyXpGGOf3Y65LTo37DwiFxBPrztKb4nqEMExz/zBBqBV8n6Dtttewa29yskKaJu24kJQA3uL8YMIbBiSuPhbpTpdKwkULyyDiyGX+Qf38bYhCAS6ceWjiVn7guJoZ6nzaBPdEekDePvExSqc9E6OR/RmGX2+WV51zxMe4m5X/tMfv05bXdaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gs36UPeqkP8H3vA7VWWmygr1vvdGEr59iCCm2pyOkyc=;
 b=mQwSCkRBfJhIEX7lOT4d3RTCs2aUl9Rtqr/TwN/hCdu+jeheO+LDa3Sc2xACLgjBEz3wp2pRMZsPjg2+XNik1mrp5iKU/d2FmO2zLrT0Z5TNjrtC24O0hwWciGxSHy8p2VR4a/MiT1cdCKz/tLx2lBGMUAjr5hbjeKtjTza219KMMEwzTRqZ55AoC+BOXyY+CkTAFw1xRcWgq3WFveA26KptxSXqTPNh51Mw7zBIibaghF0aj50yYGxu4lb+poVoEh9jlrxp1OTZxIozxtnUaV6OrS7fUUQyx9+H8EKDJRiu0o8bXU45ZnTdM4wOAiXE8adISoAN9komH1wC6KqVMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DM6PR12MB3945.namprd12.prod.outlook.com (2603:10b6:5:1c2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 19:22:27 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 19:22:27 +0000
Message-ID: <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
Date:   Mon, 11 Apr 2022 12:22:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     idosch@idosch.org, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220411172934.1813604-1-razor@blackwall.org>
 <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
 <c46ac324-34a2-ca0c-7c8c-35dc9c1aa0ab@blackwall.org>
 <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:a03:331::22) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f0a4cf8-cbf0-4ff3-293b-08da1bf09d3f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3945:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB39455ADD3ACC553BC46C0FD8CBEA9@DM6PR12MB3945.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rrZs/vYBf9hg5y30JqclUUSPY0NZM45/1zBzsKJQe0IWOAsokiYZR7XY2Sv5VKs+yqE+hxEG3s3Co5ilRqNCmOkSqk+IotSnJP7osqDjjxqKLrflDPDx6Iwoi4JIDYqGqgGh7xyel/6Y2vWCN6cY/1IJCwAK9v7cvyHA4vnXDpDDU9UBW0Sdk8PKhtIUhA2w5+15YEGurZr4AqWJnwHGl0irwiIhb63bFogYjmUCQMZADaABpZRMERpv9/wz4K7Ov31cWLkSeyqjFJZ8ddR55XAGObBgqnBNdhIUNn4HWtCcU6fpwIfX8Ygwtg1XE3YGZSokomRDRwpj05hU/cXuI/JWdRtY3qqXpC2cIWxr7Uh0bQRXBlBIFGXgt/1f7xY0qWxJpfnaf3lFmy1gdmkfWgbizgRZks4noE7GWC3cT7KiYOlM1A20ZsdjHzeWojR68bDLqlueS1afxtc6IEraSrJKOjSvQSpNPRTpXvCed/cC7cTtXkyoKox2SRZjvyykqkoN5i9Revt1Ag6b4QeNmePkAVMI+Yrwxa85y8XLoabW5swkMLa7ApY36CyEf6Y66XWZ4aDYe+COTpUyRt+AHTyiKvM5+CANYm7PrDFDO5NaqjEZHvCyRUmB5bU9BBVRS6jG0G3Qsmtd5BfE0vE5ItTBfNV7z/5RzqDOll/w5V9PI5ftqItCPCqDULBuS2Nl5jFCRSedYXJkr9ZX+stmARNcvQJLaps+1G7Lvi3U6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66946007)(186003)(53546011)(66556008)(8676002)(86362001)(6506007)(4326008)(66476007)(6666004)(6512007)(2906002)(2616005)(36756003)(508600001)(8936002)(31696002)(31686004)(6486002)(26005)(83380400001)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFN3b3lxNi9uaFlGeVZFQkVHVVlNRktCYnJJQ2pNTUh6V0prcnJGU1AyVkNW?=
 =?utf-8?B?V2xHZW1nWktRODRseFByeXUxdWVnRDNnMFpVQ2hTOWVab1l4Y1k5dFFxWjk2?=
 =?utf-8?B?dm9DZXA4MjRWLzNEd3hrY0tmZkU1YzRCYXFiMTY4ZXB3ck9iRElCN1c0aUFL?=
 =?utf-8?B?M0pPUWd5cjhGV3o2Q2tVbFVPWkJaS2pyK1VpaWRZTmVpM2lraXZXVWtYVXNv?=
 =?utf-8?B?RzROT3NKRjU0M2lUbExzT3pKbVh3RDN5WEdHS25aS2lpWDVmekZTQUlObS9x?=
 =?utf-8?B?c1dRaWo1YWRKZG9Xa09nV0l2aUdkZDJ3ZW1Bb01nZFBPRjlkRmxtU3hkK00w?=
 =?utf-8?B?eUZJc1ZtNk9GMUR0VW5ZdVhOa2R1K00ydExYOEZ2N0QzQlMrSzdUY0F2N01L?=
 =?utf-8?B?K3ZXSTJRbDVVQ0IvVEIvR3M0a3cvWk1HVlEzam01OVJud3ViZkFURFdDbGNx?=
 =?utf-8?B?TEk3d2owbllYckp5a2pCcjlwTWowMW8xb2twSkptbENxVERGd1JkWHkyRi94?=
 =?utf-8?B?ZnduV2s1OEw3ME5ULzcwQkVKS0R1b1hRaG45Z3BPY3ZxTnBlclFzR0pzUUFj?=
 =?utf-8?B?dExmSVQ0NFFNM0h2V1N0VDdFVkFKdUFoR0JEeHhaUzlJMFYxbVVlK3RZeksr?=
 =?utf-8?B?K2tVb1YvREVoeXltMzA0WDZha2lHSTIydzFRWEtkeUkvM0d2a0d2MjNUVWRK?=
 =?utf-8?B?dFh6K2VQRWJzK09WSUhiemhPT3lVMGlabTFXZERIQlM3Vm9ZRjFacncwUjdz?=
 =?utf-8?B?aU5CV2I3cDRndVFycS92L1AzQ3o4QSt6R1dWTDdSQkJucXYrOWg1a0Q3M0Z4?=
 =?utf-8?B?YXNTWTN4YXlEZjFqUHpMUzVZZWlmNFpYelFPdHBvbExOOEpjYU9sU1NwT3JR?=
 =?utf-8?B?Ky9YWWVZSUY3VDY5SnVTR0d2R2FxRE9iWTdjZGRQeis0RjhNcWhSNHd3aDBp?=
 =?utf-8?B?dm92UTZuclFzRVovQ2l1cnJGRzlnZVlHRXVpN0RZVjIwZEltT3o1RE9MOTRN?=
 =?utf-8?B?Y2tma2pFRzZxU1BQdHhZQ2NTY3F3OFBuRUkrSTREVys2QmhmamU4N2l4bjVX?=
 =?utf-8?B?K29wNzlCWHR6TVI5UkNSVEJkVGQ3TVNYNlF5QXZXbWs0T1lQNThRS0lFOWJ2?=
 =?utf-8?B?Q2xuenhRVit6VWllU2pPMENXY2tyRzkrV0Z4b1BjMzlpc0VlNWE1T0svTXla?=
 =?utf-8?B?V2FSbFI1V1dYcDhLeVlkd0NvaFZhV0xCMXBNNERwY0I1U3FZVlBzL2xrUUJr?=
 =?utf-8?B?TDFwOXRVNU1Bakc4aHpTcTRUTzhTcUdWRTVKclJiNHg2M3lIUC91YmJRdmk3?=
 =?utf-8?B?c0dPbC9WWVRQL0xjZFpIT0lCQzN1djNYaS94bS9MTTBnQ2pUS0hydDRiSjdD?=
 =?utf-8?B?Z3FISG50Vm0xa1B5Ni82Q1JWT00yTkhKQk1qSVZDdm1MZUZaVlNMU2wySEhU?=
 =?utf-8?B?WkM1L0cxWkZZNTZaUksvT2xFVE9ZcVdqTStWQnNQcDVBbldBaCtCR2VLTVcv?=
 =?utf-8?B?RUpaRXNzUDJXZE5iWUVtWkMwbVBjREE4TjJ2UnQxYzgvYVhjWUh1QnFxdXdR?=
 =?utf-8?B?ait4K2VzU2ZRUUxUNk02SCtqdERmVXVrTmVvd0ZOZjFrTmZKWjBseFAyQ1ZZ?=
 =?utf-8?B?OCt3Tlg1OVQveTZUZUpxVFNEZHZFZGYxOEdjbmRadzFPc3FmdHRpL3hLQlM1?=
 =?utf-8?B?QUVUWmZoVCs0ZjlSMFFlQS94RnA3S1RZUVRlZ1VGY29EdDJFeUgybWtCVEZy?=
 =?utf-8?B?bXpFMEJqREJFcVNaZEhnbEh6cVNtNTEvYnVsS0owQWxHb2NGYlFsaXBqWit0?=
 =?utf-8?B?TkpkbTh2T1lyZmNnazA0MjhrWDRlVFpjZ01QODJubEVkNDRLQStMOE01d2d1?=
 =?utf-8?B?amhFN0J1blpTcHRQb1BmL01HQm0rUlFSVXErRDlteG1aazRyVEFFaGkxZXZz?=
 =?utf-8?B?T0lhQUdyLzVrTUk1ejNhbGNYUTdEY0pwazFoa3BMNDE0QzdHRnlEMTJyQVNw?=
 =?utf-8?B?LytXdnM1elI1bnJWSWxsT0lXTTgydGRVUUMwWHBucndPbVB6RUpac3VIWm12?=
 =?utf-8?B?a09VK1RHUzFCdEpNZ29zSW82czFpVko0bDlmK056OXJaKzlldlVSV0RnMlRD?=
 =?utf-8?B?SzFPSy9oMGxFeVBrMS92Wk5NWUliNk9oZHB0UWh0N2JJZ2NFeGxSazVFU1Y1?=
 =?utf-8?B?SnJ5U0s3TWs2MEZMdzQwYkJCQW5taEN6Vm9DNThkZUlaQzdDSTdPalgzVyt5?=
 =?utf-8?B?UXNqdzRpZXEwTWVaK1E3Y21RaUwrZFA5am5rWFJ4M3JMLzE5dHJ4S0owM2VZ?=
 =?utf-8?B?S1NZUGxJQWFrRkd4ZXJnZ2FtcEpFb1RGd2xKcCtUcmh6M2szVlpMQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0a4cf8-cbf0-4ff3-293b-08da1bf09d3f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 19:22:27.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyB99BIZhlukUKknVM8VdzGcS71mitT3I7LmxUKXyFuLat5j/cxhsKNzTg0TVAQVsFS4NuxXRRCmeJ+fns1dyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3945
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/11/22 11:31, Nikolay Aleksandrov wrote:
> On 11/04/2022 21:18, Nikolay Aleksandrov wrote:
>> On 11/04/2022 21:08, Roopa Prabhu wrote:
>>> On 4/11/22 10:29, Nikolay Aleksandrov wrote:
>>>> Hi,
>>>> This patch-set adds support to specify filtering conditions for a flush
>>>> operation. This version has entirely different entry point (v1 had
>>>> bridge-specific IFLA attribute, here I add new RTM_FLUSHNEIGH msg and
>>>> netdev ndo_fdb_flush op) so I'll give a new overview altogether.
>>>> After me and Ido discussed the feature offlist, we agreed that it would
>>>> be best to add a new generic RTM_FLUSHNEIGH with a new ndo_fdb_flush
>>>> callback which can be re-used for other drivers (e.g. vxlan).
>>>> Patch 01 adds the new RTM_FLUSHNEIGH type, patch 02 then adds the
>>>> new ndo_fdb_flush call. With this structure we need to add a generic
>>>> rtnl_fdb_flush which will be used to do basic attribute validation and
>>>> dispatch the call to the appropriate device based on the NTF_USE/MASTER
>>>> flags (patch 03). Patch 04 then adds some common flush attributes which
>>>> are used by the bridge and vxlan drivers (target ifindex, vlan id, ndm
>>>> flags/state masks) with basic attribute validation, further validation
>>>> can be done by the implementers of the ndo callback. Patch 05 adds a
>>>> minimal ndo_fdb_flush to the bridge driver, it uses the current
>>>> br_fdb_flush implementation to flush all entries similar to existing
>>>> calls. Patch 06 adds filtering support to the new bridge flush op which
>>>> supports target ifindex (port or bridge), vlan id and flags/state mask.
>>>> Patch 07 converts ndm state/flags and their masks to bridge-private flags
>>>> and fills them in the filter descriptor for matching. Finally patch 08
>>>> fills in the target ifindex (after validating it) and vlan id (already
>>>> validated by rtnl_fdb_flush) for matching. Flush filtering is needed
>>>> because user-space applications need a quick way to delete only a
>>>> specific set of entries, e.g. mlag implementations need a way to flush only
>>>> dynamic entries excluding externally learned ones or only externally
>>>> learned ones without static entries etc. Also apps usually want to target
>>>> only a specific vlan or port/vlan combination. The current 2 flush
>>>> operations (per port and bridge-wide) are not extensible and cannot
>>>> provide such filtering.
>>>>
>>>> I decided against embedding new attrs into the old flush attributes for
>>>> multiple reasons - proper error handling on unsupported attributes,
>>>> older kernels silently flushing all, need for a second mechanism to
>>>> signal that the attribute should be parsed (e.g. using boolopts),
>>>> special treatment for permanent entries.
>>>>
>>>> Examples:
>>>> $ bridge fdb flush dev bridge vlan 100 static
>>>> < flush all static entries on vlan 100 >
>>>> $ bridge fdb flush dev bridge vlan 1 dynamic
>>>> < flush all dynamic entries on vlan 1 >
>>>> $ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
>>>> < flush all dynamic entries on port ens16 and vlan 1 >
>>>> $ bridge fdb flush dev ens16 vlan 1 dynamic master
>>>> < as above: flush all dynamic entries on port ens16 and vlan 1 >
>>>> $ bridge fdb flush dev bridge nooffloaded nopermanent self
>>>> < flush all non-offloaded and non-permanent entries >
>>>> $ bridge fdb flush dev bridge static noextern_learn
>>>> < flush all static entries which are not externally learned >
>>>> $ bridge fdb flush dev bridge permanent
>>>> < flush all permanent entries >
>>>> $ bridge fdb flush dev bridge port bridge permanent
>>>> < flush all permanent entries pointing to the bridge itself >
>>>>
>>>> Note that all flags have their negated version (static vs nostatic etc)
>>>> and there are some tricky cases to handle like "static" which in flag
>>>> terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
>>>> mask matches on both but we need only NUD_NOARP to be set. That's
>>>> because permanent entries have both set so we can't just match on
>>>> NUD_NOARP. Also note that this flush operation doesn't treat permanent
>>>> entries in a special way (fdb_delete vs fdb_delete_local), it will
>>>> delete them regardless if any port is using them. We can extend the api
>>>> with a flag to do that if needed in the future.
>>>>
>>>> Patch-sets (in order):
>>>>    - Initial flush infra and fdb flush filtering (this set)
>>>>    - iproute2 support
>>>>    - selftests
>>>>
>>>> Future work:
>>>>    - mdb flush support (RTM_FLUSHMDB type)
>>>>
>>>> Thanks to Ido for the great discussion and feedback while working on this.
>>>>
>>> Cant we pile this on to RTM_DELNEIGH with a flush flag ?.
>>>
>>> It is a bulk del, and sounds seems similar to the bulk dev del discussion on netdev a few months ago (i dont remember how that api ended up to be. unless i am misremembering).
>>>
>>> neigh subsystem also needs this, curious how this api will work there.
>>>
>>> (apologies if you guys already discussed this, did not have time to look through all the comments)
>>>
>>>
>>>
>> I thought about that option, but I didn't like overloading delneigh like that.
>> del currently requires a mac address and we need to either signal the device supports> a null mac, or we should push that verification to ndo_fdb_del users. Also we'll have
> that's the only thing, overloading delneigh with a flush-behaviour (multi-del or whatever)
> would require to push the mac check to ndo_fdb_del implementers
>
> I don't mind going that road if others agree that we should do it through delneigh
> + a bit/option to signal flush, instead of a new rtm type.
>
>> attributes which are flush-specific and will work only when flushing as opposed to when
>> deleting a specific mac, so handling them in the different cases can become a pain.
> scratch the specific attributes, those can be adapted for both cases
>
>> MDBs will need DELMDB to be modified in a similar way.
>>
>> IMO a separate flush op is cleaner, but I don't have a strong preference.
>> This can very easily be adapted to delneigh with just a bit more mechanical changes
>> if the mac check is pushed to the ndo implementers.
>>
>> FLUSHNEIGH can easily work for neighs, just need another address family rtnl_register
>> that implements it, the new ndo is just for PF_BRIDGE. :)

all great points. My only reason to explore RTM_DELNEIGH is to see if we 
can find a recipe to support similar bulk deletes of other objects 
handled via rtm msgs in the future. Plus, it allows you to maintain 
symmetry between flush requests and object delete notification msg types.

Lets see if there are other opinions.

Thanks Nikolay



